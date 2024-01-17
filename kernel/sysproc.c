#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  exit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return fork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return wait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int n;

  argint(0, &n);
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

uint64
sys_sleep(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


uint64
sys_kcall(void)
{
  int n;

  argint(0, &n);
  switch (n)
  {
    case KC_FREEMEM:    return freemem;
    case KC_USED4K:     return used4k;
    case KC_USED2M:     return used2m;
    case KC_PF:         return pagefaults;
    default:            return -1;
  }
}


//void *mmap(void *addr, int length, int prot, int flags);


struct spinlock mmaplock;

struct mmap
{
  uint64 addr;
  int length;
  int prot;
  int flags;
};


uint64
sys_mmap(void)
{
  // PA4: FILL HERE
  

  uint64 addr;
  int length, prot,flags;
  
  argaddr(0, &addr);
  argint(1,&length);
  argint(2,&prot);
  argint(3,&flags);

  //printf("mmap : %p, %d, %d, %d\n",addr, length, prot, flags);


  // error checks
  // 1) addr out of range or 3) addr not aligned


  // printf("%p\n", PHYSTOP);
  // printf("%p\n", MAXVA - 0x10000000);
  if((addr < PHYSTOP) || (MAXVA - 0x10000000 < addr) || ((addr % PGSIZE) != 0))
    return 0;

  // 4) length out of range. The maximum size (length) in mmap() is limited to 64MiB. must be greater than 0
  if(length <= 0 || (32* HUGEPGSIZE)< length)
    return 0;

  // 5) weird prot bits
  if(!(prot == PROT_READ || prot == PROT_WRITE))
    return 0;
  
  // 6) weird flags
  if(!(flags == MAP_PRIVATE || flags == MAP_SHARED || flags == (MAP_PRIVATE | MAP_HUGEPAGE) || flags == (MAP_SHARED | MAP_HUGEPAGE)))
    return 0;
  
  int is_huge = 0;
  //int is_private = 0;

  if(flags > MAP_SHARED)
    is_huge = 1;

  // if((flags%MAP_HUGEPAGE) == MAP_PRIVATE)
  //   is_private = 1;

  //printf("flags :  %d, %d\n", is_huge, is_private); 

  // int page_size = PGSIZE;

  // if(is_huge)
  //   page_size = HUGEPGSIZE;

  if(is_huge)
    length = HUGEPGROUNDUP(length);
  else
    length = PGROUNDUP(length);
  
  struct proc *p = myproc();

  acquire(&mmaplock);


  // first check 2) if already mapped place
  // remember order : address-length-(prot | ishuge | flags)
  for(int i=0; i<12; i+=3)
  {
    uint64 va = p->mmap_list[i];
    uint64 s = p->mmap_list[i+1];
    
    // mmap start area
    if(va <= addr && addr <va+s)
    {
      //printf("mmap joongbok\n");
      release(&mmaplock);
      return 0;
    }

    // mmap end area
    if(addr <= va && va <addr +length)
    {
      //printf("mmap joongbok type 2\n");
      release(&mmaplock);
      return 0;
    }
  }



  // search for empty mmap_list, if found, update
  // remember order : address-length-(prot | ishuge | flags)
  for(int i=0; i<12; i+=3)
  {
    uint64 va = p->mmap_list[i];  
    if(va == 0)
    {
      p->mmap_list[i] = addr;
      p->mmap_list[i+1] = length;
      p->mmap_list[i+2] = (prot | flags);
      break;
    }
  }
  // don't actually allocate PA
  release(&mmaplock);
  //printf("returning addr : %p\n",addr);

  return addr;
}

uint64
sys_munmap(void)
{
  // PA4: FILL HERE

  uint64 addr;
  argaddr(0, &addr);

  // error1) addr not aligned/out of range

  // TODO : maxva - 10000000이 끝임. 시작이 아니라
  if(((addr%4096)!=0) || (addr < PHYSTOP) || (MAXVA - 0x10000000 < addr))
  {
    //printf("OOR\n");
    return -1;
  }
  struct proc *p = myproc();

  // for(int i=0; i<12; i+=3)
  // {
  //   printf("mmunmap called point : %p, %p, %p\n",p->mmap_list[i], p->mmap_list[i+1], p->mmap_list[i+2]);
  // }

  acquire(&mmaplock);


  // error2) no mapping for starting address 
  // remember order : address-length-(prot | ishuge | flags)
  int page_index=0;
  int map_exists = 0;
  for(int i=0; i<12; i+=3)
  {
    if(addr == p->mmap_list[i])
    {
      page_index = i;
      map_exists = 1;
      break;
    }
  }

  if(!map_exists)
  {
    // no mapping exists
    release(&mmaplock);
    return -1;
  }

  int length, flags;
  length = p->mmap_list[page_index+1];
  flags = p->mmap_list[page_index+2];

  // how about munmaping right after mmap?
  
  if(HUGE_MASK & flags)
  {
    
    // fixed uvmunmap_huge for munmap right after mmap/auto free
    uvmunmap_huge(p->pagetable, addr, length/(4096*512),1);
  }
  else
  {

    // 여기서 무지성 일괄 uvunmap시 문제점 : 일부만 할당되었는데, 전부 unmap시도 하여, panic: uvmunmap: not mapped 문제발생...

    // 즉, 여기서 실제로 PA에 올라온 얘들에 대해서만 직접 uvmunmap을 수동으로 불러줘야함!
    uint64 a;
    pte_t *pte;

    for(a = addr; a < addr + length; a += PGSIZE){
      
      if((pte = walk(p->pagetable, a, 0)) == 0)
      {
        // page table has not been created
        // printf("for va %p no page table entry\n",a);
        continue;
      }
      // printf("pte %p : %p \n", pte, *pte);
      
      if((*pte & PTE_V) == 0)
      {
        // printf("page table exists for va %p, but not valid\n", a);
        continue;
        panic("munmap: not mapped");
      }
      if(PTE_FLAGS(*pte) == PTE_V)
        panic("munmap: not a leaf");

      // actually free
      // TODO : 여기는 이후 Fork등에선 free 안해야 할수도
      //TODO : fix this (do_free) for fork()
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
      
      //printf("uvmunmap for pte-%p : %p\n",pte,*pte);
      *pte = 0;
    }
    //uvmunmap(p->pagetable, addr, length/4096, 1);    
  }


  //unmmaping includes clearing out address
  p->mmap_list[page_index] = 0;
  p->mmap_list[page_index+1] = 0;
  p->mmap_list[page_index+2] = 0;
  
  release(&mmaplock);



  return 0;
}


