// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

#include "vm/globals.h"
#if defined(DART_HOST_OS_ANDROID) || defined(DART_HOST_OS_LINUX) ||            \
    defined(DART_HOST_OS_MACOS)

#include "vm/virtual_memory.h"

#include <errno.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/syscall.h>
#include <unistd.h>

#include "platform/assert.h"
#include "platform/utils.h"
#include "vm/heap/pages.h"
#include "vm/isolate.h"
#include "vm/virtual_memory_compressed.h"

// #define VIRTUAL_MEMORY_LOGGING 1
#if defined(VIRTUAL_MEMORY_LOGGING)
#define LOG_INFO(msg, ...) OS::PrintErr(msg, ##__VA_ARGS__)
#else
#define LOG_INFO(msg, ...)
#endif  // defined(VIRTUAL_MEMORY_LOGGING)

namespace dart {

// standard MAP_FAILED causes "error: use of old-style cast" as it
// defines MAP_FAILED as ((void *) -1)
#undef MAP_FAILED
#define MAP_FAILED reinterpret_cast<void*>(-1)

DECLARE_FLAG(bool, dual_map_code);
DECLARE_FLAG(bool, write_protect_code);

#if defined(DART_TARGET_OS_LINUX)
DECLARE_FLAG(bool, generate_perf_events_symbols);
DECLARE_FLAG(bool, generate_perf_jitdump);
#endif

uword VirtualMemory::page_size_ = 0;

static void unmap(uword start, uword end);

static void* GenericMapAligned(void* hint,
                               int prot,
                               intptr_t size,
                               intptr_t alignment,
                               intptr_t allocated_size,
                               int map_flags) {
  void* address = mmap(hint, allocated_size, prot, map_flags, -1, 0);
  LOG_INFO("mmap(%p, 0x%" Px ", %u, ...): %p\n", hint, allocated_size, prot,
           address);
  if (address == MAP_FAILED) {
    return nullptr;
  }

  const uword base = reinterpret_cast<uword>(address);
  const uword aligned_base = Utils::RoundUp(base, alignment);

  unmap(base, aligned_base);
  unmap(aligned_base + size, base + allocated_size);
  return reinterpret_cast<void*>(aligned_base);
}

intptr_t VirtualMemory::CalculatePageSize() {
  const intptr_t page_size = getpagesize();
  ASSERT(page_size != 0);
  ASSERT(Utils::IsPowerOfTwo(page_size));
  return page_size;
}

void VirtualMemory::Init() {
#if defined(DART_COMPRESSED_POINTERS)
  if (VirtualMemoryCompressedHeap::GetRegion() == nullptr) {
    void* address = GenericMapAligned(
        nullptr, PROT_NONE, kCompressedHeapSize, kCompressedHeapAlignment,
        kCompressedHeapSize + kCompressedHeapAlignment,
        MAP_PRIVATE | MAP_ANONYMOUS);
    if (address == nullptr) {
      int error = errno;
      const int kBufferSize = 1024;
      char error_buf[kBufferSize];
      FATAL2("Failed to reserve region for compressed heap: %d (%s)", error,
             Utils::StrError(error, error_buf, kBufferSize));
    }
    VirtualMemoryCompressedHeap::Init(address);
  }
#endif  // defined(DART_COMPRESSED_POINTERS)

  if (page_size_ != 0) {
    // Already initialized.
    return;
  }

  page_size_ = CalculatePageSize();

#if defined(DUAL_MAPPING_SUPPORTED)
// Perf is Linux-specific and the flags aren't defined in Product.
#if defined(DART_TARGET_OS_LINUX) && !defined(PRODUCT)
  // Perf interacts strangely with memfds, leading it to sometimes collect
  // garbled return addresses.
  if (FLAG_generate_perf_events_symbols || FLAG_generate_perf_jitdump) {
    LOG_INFO(
        "Dual code mapping disabled to generate perf events or jitdump.\n");
    FLAG_dual_map_code = false;
    return;
  }
#endif

  // Detect dual mapping exec permission limitation on some platforms,
  // such as on docker containers, and disable dual mapping in this case.
  // Also detect for missing support of memfd_create syscall.
  if (FLAG_dual_map_code) {
    intptr_t size = PageSize();
    intptr_t alignment = kOldPageSize;
    VirtualMemory* vm = AllocateAligned(size, alignment, true, "memfd-test");
    if (vm == nullptr) {
      LOG_INFO("memfd_create not supported; disabling dual mapping of code.\n");
      FLAG_dual_map_code = false;
      return;
    }
    void* region = reinterpret_cast<void*>(vm->region_.start());
    void* alias = reinterpret_cast<void*>(vm->alias_.start());
    if (region == alias ||
        mprotect(region, size, PROT_READ) != 0 ||  // Remove PROT_WRITE.
        mprotect(alias, size, PROT_READ | PROT_EXEC) != 0) {  // Add PROT_EXEC.
      LOG_INFO("mprotect fails; disabling dual mapping of code.\n");
      FLAG_dual_map_code = false;
    }
    delete vm;
  }
#endif  // defined(DUAL_MAPPING_SUPPORTED)

#if defined(DART_HOST_OS_LINUX) || defined(DART_HOST_OS_ANDROID)
  FILE* fp = fopen("/proc/sys/vm/max_map_count", "r");
  if (fp != nullptr) {
    size_t max_map_count = 0;
    int count = fscanf(fp, "%zu", &max_map_count);
    fclose(fp);
    if (count == 1) {
      size_t max_heap_pages = FLAG_old_gen_heap_size * MB / kOldPageSize;
      if (max_map_count < max_heap_pages) {
        OS::PrintErr(
            "warning: vm.max_map_count (%zu) is not large enough to support "
            "--old_gen_heap_size=%d. Consider increasing it with `sysctl -w "
            "vm.max_map_count=%zu`\n",
            max_map_count, FLAG_old_gen_heap_size, max_heap_pages);
      }
    }
  }
#endif
}

void VirtualMemory::Cleanup() {
#if defined(DART_COMPRESSED_POINTERS)
  uword heap_base =
      reinterpret_cast<uword>(VirtualMemoryCompressedHeap::GetRegion());
  unmap(heap_base, heap_base + kCompressedHeapSize);
  VirtualMemoryCompressedHeap::Cleanup();
#endif  // defined(DART_COMPRESSED_POINTERS)
}

bool VirtualMemory::DualMappingEnabled() {
  return FLAG_dual_map_code;
}

static void unmap(uword start, uword end) {
  ASSERT(start <= end);
  uword size = end - start;
  if (size == 0) {
    return;
  }

  if (munmap(reinterpret_cast<void*>(start), size) != 0) {
    int error = errno;
    const int kBufferSize = 1024;
    char error_buf[kBufferSize];
    FATAL2("munmap error: %d (%s)", error,
           Utils::StrError(error, error_buf, kBufferSize));
  }
}

#if defined(DUAL_MAPPING_SUPPORTED)
// Do not leak file descriptors to child processes.
#if !defined(MFD_CLOEXEC)
#define MFD_CLOEXEC 0x0001U
#endif

// Wrapper to call memfd_create syscall.
static inline int memfd_create(const char* name, unsigned int flags) {
#if !defined(__NR_memfd_create)
  errno = ENOSYS;
  return -1;
#else
  return syscall(__NR_memfd_create, name, flags);
#endif
}

static void* MapAligned(void* hint,
                        int fd,
                        int prot,
                        intptr_t size,
                        intptr_t alignment,
                        intptr_t allocated_size) {
  void* address =
      mmap(hint, allocated_size, PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
  LOG_INFO("mmap(%p, 0x%" Px ", PROT_NONE, ...): %p\n", hint, allocated_size,
           address);
  if (address == MAP_FAILED) {
    return nullptr;
  }

  const uword base = reinterpret_cast<uword>(address);
  const uword aligned_base = Utils::RoundUp(base, alignment);

  // Guarantee the alignment by mapping at a fixed address inside the above
  // mapping. Overlapping region will be automatically discarded in the above
  // mapping. Manually discard non-overlapping regions.
  address = mmap(reinterpret_cast<void*>(aligned_base), size, prot,
                 MAP_SHARED | MAP_FIXED, fd, 0);
  LOG_INFO("mmap(0x%" Px ", 0x%" Px ", %u, ...): %p\n", aligned_base, size,
           prot, address);
  if (address == MAP_FAILED) {
    unmap(base, base + allocated_size);
    return nullptr;
  }
  ASSERT(address == reinterpret_cast<void*>(aligned_base));
  unmap(base, aligned_base);
  unmap(aligned_base + size, base + allocated_size);
  return address;
}
#endif  // defined(DUAL_MAPPING_SUPPORTED)

VirtualMemory* VirtualMemory::AllocateAligned(intptr_t size,
                                              intptr_t alignment,
                                              bool is_executable,
                                              const char* name) {
  // When FLAG_write_protect_code is active, code memory (indicated by
  // is_executable = true) is allocated as non-executable and later
  // changed to executable via VirtualMemory::Protect.
  //
  // If FLAG_dual_map_code is active, the executable mapping will be mapped RX
  // immediately and never changes protection until it is eventually unmapped.
  ASSERT(Utils::IsAligned(size, PageSize()));
  ASSERT(Utils::IsPowerOfTwo(alignment));
  ASSERT(Utils::IsAligned(alignment, PageSize()));
  ASSERT(name != nullptr);

#if defined(DART_COMPRESSED_POINTERS)
  if (!is_executable) {
    MemoryRegion region =
        VirtualMemoryCompressedHeap::Allocate(size, alignment);
    if (region.pointer() == nullptr) {
      return nullptr;
    }
    mprotect(region.pointer(), region.size(), PROT_READ | PROT_WRITE);
    return new VirtualMemory(region, region);
  }
#endif  // defined(DART_COMPRESSED_POINTERS)

  const intptr_t allocated_size = size + alignment - PageSize();
#if defined(DUAL_MAPPING_SUPPORTED)
  const bool dual_mapping =
      is_executable && FLAG_write_protect_code && FLAG_dual_map_code;
  if (dual_mapping) {
    int fd = memfd_create(name, MFD_CLOEXEC);
    if (fd == -1) {
      return nullptr;
    }
    if (ftruncate(fd, size) == -1) {
      close(fd);
      return nullptr;
    }
    const int region_prot = PROT_READ | PROT_WRITE;
    void* region_ptr =
        MapAligned(nullptr, fd, region_prot, size, alignment, allocated_size);
    if (region_ptr == nullptr) {
      close(fd);
      return nullptr;
    }
    // The mapping will be RX and stays that way until it will eventually be
    // unmapped.
    MemoryRegion region(region_ptr, size);
    // DUAL_MAPPING_SUPPORTED is false in DART_TARGET_OS_MACOS and hence support
    // for MAP_JIT is not required here.
    const int alias_prot = PROT_READ | PROT_EXEC;
    void* hint = reinterpret_cast<void*>(&Dart_Initialize);
    void* alias_ptr =
        MapAligned(hint, fd, alias_prot, size, alignment, allocated_size);
    close(fd);
    if (alias_ptr == nullptr) {
      const uword region_base = reinterpret_cast<uword>(region_ptr);
      unmap(region_base, region_base + size);
      return nullptr;
    }
    ASSERT(region_ptr != alias_ptr);
    MemoryRegion alias(alias_ptr, size);
    return new VirtualMemory(region, alias, region);
  }
#endif  // defined(DUAL_MAPPING_SUPPORTED)

  const int prot =
      PROT_READ | PROT_WRITE |
      ((is_executable && !FLAG_write_protect_code) ? PROT_EXEC : 0);

#if defined(DUAL_MAPPING_SUPPORTED)
  // Try to use memfd for single-mapped regions too, so they will have an
  // associated name for memory attribution. Skip if FLAG_dual_map_code is
  // false, which happens if we detected memfd wasn't working in Init above.
  if (FLAG_dual_map_code) {
    int fd = memfd_create(name, MFD_CLOEXEC);
    if (fd == -1) {
      return nullptr;
    }
    if (ftruncate(fd, size) == -1) {
      close(fd);
      return nullptr;
    }
    void* region_ptr =
        MapAligned(nullptr, fd, prot, size, alignment, allocated_size);
    close(fd);
    if (region_ptr == nullptr) {
      return nullptr;
    }
    MemoryRegion region(region_ptr, size);
    return new VirtualMemory(region, region);
  }
#endif

  int map_flags = MAP_PRIVATE | MAP_ANONYMOUS;
#if (defined(DART_HOST_OS_MACOS) && !defined(DART_HOST_OS_IOS))
  if (is_executable && IsAtLeastOS10_14()) {
    map_flags |= MAP_JIT;
  }
#endif  // defined(DART_HOST_OS_MACOS)

  void* hint = nullptr;
  // Some 64-bit microarchitectures store only the low 32-bits of targets as
  // part of indirect branch prediction, predicting that the target's upper bits
  // will be same as the call instruction's address. This leads to misprediction
  // for indirect calls crossing a 4GB boundary. We ask mmap to place our
  // generated code near the VM binary to avoid this.
  if (is_executable) {
    hint = reinterpret_cast<void*>(&Dart_Initialize);
  }
  void* address =
      GenericMapAligned(hint, prot, size, alignment, allocated_size, map_flags);
  if (address == nullptr) {
    return nullptr;
  }

  MemoryRegion region(reinterpret_cast<void*>(address), size);
  return new VirtualMemory(region, region);
}

VirtualMemory::~VirtualMemory() {
#if defined(DART_COMPRESSED_POINTERS)
  if (VirtualMemoryCompressedHeap::Contains(reserved_.pointer())) {
    madvise(reserved_.pointer(), reserved_.size(), MADV_DONTNEED);
    VirtualMemoryCompressedHeap::Free(reserved_.pointer(), reserved_.size());
    return;
  }
#endif  // defined(DART_COMPRESSED_POINTERS)
  if (vm_owns_region()) {
    unmap(reserved_.start(), reserved_.end());
    const intptr_t alias_offset = AliasOffset();
    if (alias_offset != 0) {
      unmap(reserved_.start() + alias_offset, reserved_.end() + alias_offset);
    }
  }
}

bool VirtualMemory::FreeSubSegment(void* address, intptr_t size) {
#if defined(DART_COMPRESSED_POINTERS)
  // Don't free the sub segment if it's managed by the compressed pointer heap.
  if (VirtualMemoryCompressedHeap::Contains(address)) {
    return false;
  }
#endif  // defined(DART_COMPRESSED_POINTERS)
  const uword start = reinterpret_cast<uword>(address);
  unmap(start, start + size);
  return true;
}

void VirtualMemory::Protect(void* address, intptr_t size, Protection mode) {
#if defined(DEBUG)
  Thread* thread = Thread::Current();
  ASSERT(thread == nullptr || thread->IsMutatorThread() ||
         thread->isolate() == nullptr ||
         thread->isolate()->mutator_thread()->IsAtSafepoint());
#endif
  uword start_address = reinterpret_cast<uword>(address);
  uword end_address = start_address + size;
  uword page_address = Utils::RoundDown(start_address, PageSize());
  int prot = 0;
  switch (mode) {
    case kNoAccess:
      prot = PROT_NONE;
      break;
    case kReadOnly:
      prot = PROT_READ;
      break;
    case kReadWrite:
      prot = PROT_READ | PROT_WRITE;
      break;
    case kReadExecute:
      prot = PROT_READ | PROT_EXEC;
      break;
    case kReadWriteExecute:
      prot = PROT_READ | PROT_WRITE | PROT_EXEC;
      break;
  }
  if (mprotect(reinterpret_cast<void*>(page_address),
               end_address - page_address, prot) != 0) {
    int error = errno;
    const int kBufferSize = 1024;
    char error_buf[kBufferSize];
    LOG_INFO("mprotect(0x%" Px ", 0x%" Px ", %u) failed\n", page_address,
             end_address - page_address, prot);
    FATAL2("mprotect error: %d (%s)", error,
           Utils::StrError(error, error_buf, kBufferSize));
  }
  LOG_INFO("mprotect(0x%" Px ", 0x%" Px ", %u) ok\n", page_address,
           end_address - page_address, prot);
}

}  // namespace dart

#endif  // defined(DART_HOST_OS_ANDROID) || defined(DART_HOST_OS_LINUX) ||     \
        // defined(DART_HOST_OS_MACOS)
