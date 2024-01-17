// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

// will be set only once. no need to protect with lock
uint64 page_start;
//uint64 huge_page_start;

//63*512 = 32256

//

struct run {
  struct run *next;
};

int get_page_i(void* pa)
{
  return ((uint64)pa - page_start)/PGSIZE;
}


int get_hugepage_i(void* pa)
{
  return ((uint64)pa - page_start)/HUGEPGSIZE;
}

void* pageindex_to_pa(int i)
{
  
  return (void*)(page_start + PGSIZE*i);
}


struct {
  struct spinlock lock;
  //struct run *freelist;
  // 0~2mb section is un-alloc'able
  short hugepagelist[63];
  // 0 is alloc'd(false) 1 is free-allocatable(true)
  char pagelist[32256];
  char pa_referenced[32256];
  char huge_pa_referenced[63];
  
} kmem;

int freemem, used4k, used2m;

// for debugs
void debug_hugepagechecker()
{
  acquire(&kmem.lock);
  for(int i=0; i<63; i++)
  {

    printf("kmem.hugepagelist[%d] = %d\n",i,kmem.hugepagelist[i]);
    if(kmem.hugepagelist[i] < -1 || kmem.hugepagelist[i] > 512)
    {
      printf("kmem.hugepagelist[%d] error = %d",i,kmem.hugepagelist[i]);
      panic("debug_hugepagechecker()");
    }
  }
  release(&kmem.lock);
}

void debug_pagechecker(int huge_page_i)
{
  acquire(&kmem.lock);
  for(int i=0; i<512; i++)
  {
    printf("kmem.pagelist[%d] = %d\n",huge_page_i*512 + i,kmem.pagelist[huge_page_i*512 + i]);
    if(kmem.pagelist[huge_page_i*512 + i] < 0 || kmem.pagelist[huge_page_i*512 + i] > 1)
    {
      printf("kmem.pagelist[%d] error = %d",huge_page_i*512 + i,kmem.pagelist[huge_page_i*512 + i]);
      panic("debug_pagechecker()");
    }
  }
  release(&kmem.lock);
}

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  acquire(&kmem.lock);
  page_start = HUGEPGROUNDUP((uint64)end);
 
  
  printf("page_start : %p\n", page_start);
  printf("page end : %p\n", (void*)PHYSTOP);
  

  
  //huge_page_start = HUGEPGROUNDUP((uint64)end);
  release(&kmem.lock);
  freerange(end, (void*)PHYSTOP);
  // restore wrong value changes during init
  used4k = 0;
  freemem += 512;
}

void
freerange(void *pa_start, void *pa_end)
{

  acquire(&kmem.lock);
  for(int i=0; i<63; i++)
    kmem.hugepagelist[i] = 512;
  release(&kmem.lock);

  char *p;
  p = (char*)HUGEPGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    kfree(p);
  

}

void incr_huge_pa_ref(void *pa)
{
  if(((uint64)pa % HUGEPGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("incr_pa_ref");

  //int page_i = get_page_i(pa);
  int huge_page_i = get_hugepage_i(pa);

  acquire(&kmem.lock);
  if(kmem.huge_pa_referenced[huge_page_i] == 0)
  {
    //printf("incr_huge_pa_ref : was not referenced\n");
  }
  kmem.huge_pa_referenced[huge_page_i]++;
  release(&kmem.lock);
}

void incr_pa_ref(void *pa)
{
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("incr_pa_ref");

  int page_i = get_page_i(pa);
  //int huge_page_i = get_hugepage_i(pa);

  acquire(&kmem.lock);
  if(kmem.pa_referenced[page_i] == 0)
  {
    //printf("incr_pa_ref : was not referenced\n");
  }
  kmem.pa_referenced[page_i]++;
  release(&kmem.lock);
}

void reduce_pa_ref(void *pa)
{
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("reduce_pa_ref");

  int page_i = get_page_i(pa);
  //int huge_page_i = get_hugepage_i(pa);

  acquire(&kmem.lock);
  if(kmem.pa_referenced[page_i] == 0)
  {
    panic("reduce ref should not have been called");
  }
  kmem.pa_referenced[page_i]--;
  release(&kmem.lock);

}



// Free the page of physical memory pointed at by pa,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  //struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree");

  

  int page_i = get_page_i(pa);
  int huge_page_i = get_hugepage_i(pa);

  //debug_pagechecker(huge_page_i);
  //printf("kfree : %d %d\n",page_i,huge_page_i);

  
  // kfree 예외 : 1) huge alloc을 free 2) double free 3) freeing unalloc'd page


  

  // r = (struct run*)pa;

  acquire(&kmem.lock);
  // r->next = kmem.freelist;
  //kmem.freelist = r;
  // 0 is alloc'd(false) 1 is free-allocatable(true)

  // 2) and 3)
  if(kmem.pagelist[page_i])
  {
    release(&kmem.lock);
    //printf("%d %d",page_i, huge_page_i);
    panic("double kfree");
  }

  // check PA's referenced numbers
  if(kmem.pa_referenced[page_i] >0)
    kmem.pa_referenced[page_i]--;

  // only free when referenced num == 0
  if(kmem.pa_referenced[page_i] == 0)
  {
    // Fill with junk to catch dangling refs.
    memset(pa, 0, PGSIZE);

    // mark free
    kmem.pagelist[page_i] = 1;
    kmem.hugepagelist[huge_page_i]--;
    freemem++;
    used4k--;
  }

  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  // debug_pagechecker();
  // debug_hugepagechecker();

  acquire(&kmem.lock);

  int flag_1 = 0;
  int flag_2 = 0;
  

  int huge_page_i = -1;

  // 1) search for [1,511] huge pages
  for(int i=0; i<63;i++)
  {
    if(0 < kmem.hugepagelist[i] && kmem.hugepagelist[i] < 512)
    {
      huge_page_i = i;
      flag_1 = 1;
      break;
    }
  }

  // 2) if '1)' not found, search for empty huge pages 

  if(!flag_1)
  {
    for(int i=0; i<63;i++)
    {
      if(kmem.hugepagelist[i] == 0)
      {
        huge_page_i = i;
        flag_2 = 1;
        break;
      }
    }
  }

  // if none were found, return 0
  if(flag_1 == 0 && flag_2 == 0 )
  {
    //printf("all filled: freemem=%d, used4k=%d, used2m=%d\n", freemem, used4k, used2m);

    release(&kmem.lock);
    return 0;  
  }


  // linear search each huge page section
  int page_i = huge_page_i*512;
  int page_end = page_i + 512;

  for(; page_i < page_end; page_i++)
  {
    // 0 is alloc'd(false) 1 is free-allocatable(true)
    if(kmem.pagelist[page_i])
    {
      //printf("found page %d\n",page_i);
      break;
    }
  }

  //printf("kalloc : %d %d\n",page_i,huge_page_i);

  // Fill with junk to catch dangling refs.

  uint64* pa = pageindex_to_pa(page_i);

  kmem.pa_referenced[page_i]++;

  // first time being referenced
  if(kmem.pa_referenced[page_i] == 1)
  {
    memset(pa, 0, PGSIZE);

    // update(alloc)
    kmem.pagelist[page_i] = 0;
    kmem.hugepagelist[huge_page_i]++;
    freemem--;
    used4k++;

  }
  
  release(&kmem.lock);
  return pageindex_to_pa(page_i);
}

void *
kalloc_huge(void)
{
  // PA4: FILL HERE
  uint64 pa = 0;
  acquire(&kmem.lock);


  for(int i=0; i< 63; i++)
  {
    if (kmem.hugepagelist[i] == 0)
      {
        kmem.hugepagelist[i] = -1;

        kmem.huge_pa_referenced[i]++;
        
        pa = page_start + HUGEPGSIZE*i;
        //fill with junk
        memset((char*)pa, 0, HUGEPGSIZE);

        // 할거 : 숫자업데이트
        freemem -= 512;
        used2m++;

        //printf("kalloc huge : %d\n",i);
        break;
      }
  }


  release(&kmem.lock);

  //debug_hugepagechecker();
  return (void*)pa;
}

void 
kfree_huge(void *pa)
{
  if(((uint64)pa % HUGEPGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    panic("kfree_huge");
  acquire(&kmem.lock);

  int hugepage_i = get_hugepage_i(pa);
  
  // check double kfree
  if(kmem.hugepagelist[hugepage_i] != -1)
  {
    // printf("trying to free unallocated huge page! [%d] : %d \n", hugepage_i, kmem.hugepagelist[hugepage_i]);
    panic("kfree_huge");
  }

  if(kmem.huge_pa_referenced[hugepage_i] >0)
    kmem.huge_pa_referenced[hugepage_i]--;

  if(kmem.huge_pa_referenced[hugepage_i] == 0)
  {
    // fill with junk
    memset(pa, 0, HUGEPGSIZE);
    
    // free
    kmem.hugepagelist[hugepage_i] = 0;
    freemem += 512;
    used2m--;
  }
  release(&kmem.lock);
}
