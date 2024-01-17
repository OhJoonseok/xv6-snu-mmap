#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "riscv.h"
#include "spinlock.h"
#include "proc.h"
#include "defs.h"

struct cpu cpus[NCPU];

struct proc proc[NPROC];

struct proc *initproc;

int nextpid = 1;
struct spinlock pid_lock;




int pagefaults;


extern void forkret(void);
static void freeproc(struct proc *p);

extern char trampoline[]; // trampoline.S

// helps ensure that wakeups of wait()ing
// parents are not lost. helps obey the
// memory model when using p->parent.
// must be acquired before any p->lock.
struct spinlock wait_lock;

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
  }
}

// initialize the proc table.
void
procinit(void)
{
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
  initlock(&wait_lock, "wait_lock");
  for(p = proc; p < &proc[NPROC]; p++) {
      initlock(&p->lock, "proc");
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
  }
}

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
  int id = r_tp();
  return id;
}

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
  int id = cpuid();
  struct cpu *c = &cpus[id];
  return c;
}

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
  push_off();
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
  pop_off();
  return p;
}

int
allocpid()
{
  int pid;
  
  acquire(&pid_lock);
  pid = nextpid;
  nextpid = nextpid + 1;
  release(&pid_lock);

  return pid;
}

// Look in the process table for an UNUSED proc.
// If found, initialize state required to run in the kernel,
// and return with p->lock held.
// If there are no free procs, or a memory allocation fails, return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    acquire(&p->lock);
    if(p->state == UNUSED) {
      goto found;
    } else {
      release(&p->lock);
    }
  }
  return 0;

found:
  p->pid = allocpid();
  p->state = USED;

  // Allocate a trapframe page.
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // An empty user page table.
  p->pagetable = proc_pagetable(p);
  if(p->pagetable == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }

  // Set up new context to start executing at forkret,
  // which returns to user space.
  memset(&p->context, 0, sizeof(p->context));
  p->context.ra = (uint64)forkret;
  p->context.sp = p->kstack + PGSIZE;

  return p;
}

// free a proc structure and the data hanging from it,
// including user pages.
// p->lock must be held.
static void
freeproc(struct proc *p)
{
  if(p->trapframe)
    kfree((void*)p->trapframe);
  p->trapframe = 0;
  if(p->pagetable)
    proc_freepagetable(p->pagetable, p->sz, p);
  p->pagetable = 0;
  p->sz = 0;
  p->pid = 0;
  p->parent = 0;
  p->name[0] = 0;
  p->chan = 0;
  p->killed = 0;
  p->xstate = 0;
  p->state = UNUSED;
}

// Create a user page table for a given process, with no user memory,
// but with trampoline and trapframe pages.
pagetable_t
proc_pagetable(struct proc *p)
{
  pagetable_t pagetable;

  // An empty page table.
  pagetable = uvmcreate();
  if(pagetable == 0)
    return 0;

  // map the trampoline code (for system call return)
  // at the highest user virtual address.
  // only the supervisor uses it, on the way
  // to/from user space, so not PTE_U.
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
              (uint64)trampoline, PTE_R | PTE_X) < 0){
    uvmfree(pagetable, 0);
    return 0;
  }

  // map the trapframe page just below the trampoline page, for
  // trampoline.S.
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
              (uint64)(p->trapframe), PTE_R | PTE_W) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }

  return pagetable;
}

// Free a process's page table, and free the
// physical memory it refers to.
void
proc_freepagetable(pagetable_t pagetable, uint64 sz, struct proc* p)
{
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
  uvmunmap(pagetable, TRAPFRAME, 1, 0);

  // auto free mmapings
  for(int i=0; i<12; i+=3)
  {
    uint64 addr = p->mmap_list[i];
    uint64 length = p->mmap_list[i+1];

    // printf("search addr length : %p %p\n",addr,length);
    //printf("proc_free %p %p %p\n",addr,length,p->mmap_list[i+2]);
    if(addr !=0)
    {
      
      if ((p->mmap_list[i+2]) & HUGE_MASK)
      {
        // printf("AUTO free huge : ");
        // printf("proc_free %p %p %p\n",addr,length,p->mmap_list[i+2]);
        uvmunmap_huge(pagetable,addr,length/HUGEPGSIZE,1);
      }
      else
      {
        // printf("AUTO free base : ");
        // printf("proc_free %p %p %p\n",addr,length,p->mmap_list[i+2]);

        // fix as same as munmap

        uint64 a;
        pte_t *pte;

        for(a = addr; a < addr + length; a += PGSIZE){
          if((pte = walk(pagetable, a, 0)) == 0)
          {
            // page table has not been created
            //printf("for va %p no page table entry\n",a);
            continue;
          }
          //printf("pte %p : %p \n", pte, *pte);
          
          if((*pte & PTE_V) == 0)
          {
            //printf("page table exists for va %p, but not valid\n", a);
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


        //uvmunmap(pagetable,addr,length/PGSIZE,1);
      }

      p->mmap_list[i] = 0;
      p->mmap_list[i+1] = 0;
      p->mmap_list[i+2] = 0;
    }
  }
  
  uvmfree(pagetable, sz);
}

// a user program that calls exec("/init")
// assembled from ../user/initcode.S
// od -t xC ../user/initcode
uchar initcode[] = {
  0x17, 0x05, 0x00, 0x00, 0x13, 0x05, 0x45, 0x02,
  0x97, 0x05, 0x00, 0x00, 0x93, 0x85, 0x35, 0x02,
  0x93, 0x08, 0x70, 0x00, 0x73, 0x00, 0x00, 0x00,
  0x93, 0x08, 0x20, 0x00, 0x73, 0x00, 0x00, 0x00,
  0xef, 0xf0, 0x9f, 0xff, 0x2f, 0x69, 0x6e, 0x69,
  0x74, 0x00, 0x00, 0x24, 0x00, 0x00, 0x00, 0x00,
  0x00, 0x00, 0x00, 0x00
};

// Set up first user process.
void
userinit(void)
{
  struct proc *p;

  p = allocproc();
  initproc = p;
  
  // allocate one user page and copy initcode's instructions
  // and data into it.
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
  p->sz = PGSIZE;

  // prepare for the very first "return" from kernel to user.
  p->trapframe->epc = 0;      // user program counter
  p->trapframe->sp = PGSIZE;  // user stack pointer

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  p->state = RUNNABLE;

  release(&p->lock);
}

// Grow or shrink user memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint64 sz;
  struct proc *p = myproc();

  sz = p->sz;
  if(n > 0){
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
      return -1;
    }
  } else if(n < 0){
    sz = uvmdealloc(p->pagetable, sz, sz + n);
  }
  p->sz = sz;
  return 0;
}


// input mmap_list flags, return pte flags.
uint64 create_pte_flag(uint64 m_flags, int isSharedNotMapped, int is_cow_private)
{

  uint flags = 1;

  

  if((m_flags & PROT_MASK) == PROT_READ)
    flags +=2;
  else
    flags +=6;

  // allow user access
  flags += 16;
  

  if((m_flags & FLAG_MASK) == MAP_PRIVATE)
    flags += 256;

  // need to make not valid for page faults(think!)
  if(isSharedNotMapped)
  {
    // not valid
    flags -= 1;
    flags += 512;
  }

  if(is_cow_private)
  {
    flags += 512;
    if((m_flags & PROT_MASK) == PROT_WRITE)
      flags -= 4;
  }
  
  //printf("flag changer. %p to %p\n", m_flags, flags);

  return flags;
  
}


#define PROT_READ       0x0001
#define PROT_WRITE      0x0002

#define MAP_PRIVATE     0x0010
#define MAP_SHARED      0x0020
#define MAP_HUGEPAGE    0x0100

// Create a new process, copying the parent.
// Sets up child kernel stack to return as if from fork() system call.
int
fork(void)
{
  int i, pid;
  struct proc *np;
  struct proc *p = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy user memory from parent to child.
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    freeproc(np);
    release(&np->lock);
    return -1;
  }
  np->sz = p->sz;

  // add mmap region copy mach
  for(int i=0; i<12; i+=3)
  {
    uint64 addr = p->mmap_list[i];
    uint64 length = p->mmap_list[i+1];
    uint64 flags = p->mmap_list[i+2];

    //printf("flags on %d : %p\n",i, flags&FLAG_MASK);

    
    if(addr == 0)
      continue;
    
    //printf("proc_free %p %p %p\n",addr,length,p->mmap_list[2]);

    // mmap region exists. first make room
    np->mmap_list[i] = addr;
    np->mmap_list[i+1] = length;
    // flags will be changed accordingly


    if (flags & HUGE_MASK)
    {
      //HUGE
      // printf("HUGE fork :");
      // printf("%p %p %p\n",addr,length,p->mmap_list[i+2]);
      uint64 a;
      pte_t *pte;
      if((flags & FLAG_MASK) == MAP_SHARED)
      {
        // case1) shared
        for(a = addr; a < addr + length; a += HUGEPGSIZE)
        {
          
          if((pte = walk_huge(p->pagetable, a, 0)) == 0)
          {
            // case 1-i-a) page table has not been created
            //printf("(huge)for va %p no page table entry\n",a);

            //create only page tables with no mapping, send to b)
            pte = walk_huge(p->pagetable,a,1);
            
          }
          if((*pte & PTE_V) == 0)
          {
            // case 1-i-b) page table exists, but not valid
            //printf("(huge)page table exists for va %p, but not valid\n", a);

            
            *pte = create_pte_flag(flags,1,0);
            pte_t* new_pte = walk_huge(np->pagetable,a,1);

            *new_pte = *pte;
            np->mmap_list[i+2] = p->mmap_list[i+2];
            continue;
            

            //continue;
            
          }
          if(PTE_FLAGS(*pte) == PTE_V)
            panic("fork: not a leaf");        
          
          // case 1-i) 'shared' and already mapped(kalloc'd)
          // just map np->mmap_list to 기존의 pa page
          pte_t* old_pte = walk_huge(p->pagetable,a,0);
          // printf("old_pte : %p %p\n",old_pte, *old_pte);
          // printf("_pte : %p %p\n",pte, *pte);
          
          if(old_pte == 0)
            panic("(fork, shared, mapped)");

          pte_t* new_pte = walk_huge(np->pagetable,a,1);

          *new_pte = *old_pte;
          np->mmap_list[i+2] = p->mmap_list[i+2];   
          
          //make ref N ++
          incr_huge_pa_ref((void*)PTE2PA((*old_pte)));
        }
      }
      else if((flags&FLAG_MASK) == MAP_PRIVATE)
      {
        // case2) private
        for(a = addr; a < addr + length; a += HUGEPGSIZE)
        {
          
          if((pte = walk_huge(p->pagetable, a, 0)) == 0)
          {
            // case 2-ii-a) page table has not been created
            // no need to share pages
            // but need to share mmap_list
            //printf("(huge)for va %p no need to share\n",a);
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            continue;
            
          }
          if((*pte & PTE_V) == 0)
          {
            // case 2-ii-b) page table exists, but not valid
            // no need to share
            //printf("(huge)page table exists for va %p, no need to share\n", a);
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            continue;
            
          }
          if(PTE_FLAGS(*pte) == PTE_V)
            panic("fork: not a leaf");        

          
          if((flags & PROT_MASK) == PROT_READ)
          {
            // case 2-i-a) 'private' and already mapped(kalloc'd), read-only
            // just need sharing


            // just map np->mmap_list to 기존의 pa page
            pte_t* old_pte = walk_huge(p->pagetable,a,0);

            
            if(old_pte == 0)
              panic("((huge)fork, shared, mapped)");

            
            pte_t* new_pte = walk_huge(np->pagetable,a,1);

            *new_pte = *old_pte;
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            
            //make ref N ++
            incr_huge_pa_ref((void*)PTE2PA((*old_pte)));

          }
          else
          {
            // case 2-i-b) 'private' and already mapped(kalloc'd), read-write
            // need to CoW
            
            //value, not pointer
            pte_t changed_pte = *pte;

            //change flags for new_pte
            uint64 newflags = create_pte_flag(flags, 0, 1);

            changed_pte = (changed_pte & (~0x3FF)) | newflags;


            // make both child and parent's pte

            *pte = changed_pte;


            pte_t* old_pte = walk_huge(p->pagetable,a,0);

            
            if(old_pte == 0)
              panic("((huge)fork, private, mapped)");

            
            pte_t* new_pte = walk_huge(np->pagetable,a,1);

            *new_pte = *old_pte;
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            
            //make ref N ++
            incr_huge_pa_ref((void*)PTE2PA((*old_pte)));
          }
        }
      }
      else
      {
        // printf("weird flags on %p : %p\n",addr, flags&FLAG_MASK);
        // panic("weird flags in mmap_list");
      }

    }
    else
    {
      //base page
      
      uint64 a;
      pte_t *pte;
      if((flags & FLAG_MASK) == MAP_SHARED)
      {
        // case1) shared
        for(a = addr; a < addr + length; a += PGSIZE)
        {
          
          if((pte = walk(p->pagetable, a, 0)) == 0)
          {
            // case 1-i-a) page table has not been created

            //create only page tables with no mapping, send to b)
            pte = walk(p->pagetable,a,1);
            
          }
          if((*pte & PTE_V) == 0)
          {
            // case 1-i-b) page table exists, but not valid

            // make pte for this version
            *pte = create_pte_flag(flags,1,0);
            pte_t* new_pte = walk(np->pagetable,a,1);

            *new_pte = *pte;
            np->mmap_list[i+2] = p->mmap_list[i+2];
            continue;
          }
          if(PTE_FLAGS(*pte) == PTE_V)
            panic("fork: not a leaf");        

          
          // case 1-i) 'shared' and already mapped(kalloc'd)
          // just map np->mmap_list to 기존의 pa page
          pte_t* old_pte = walk(p->pagetable,a,0);
          // printf("old_pte : %p %p\n",old_pte, *old_pte);
          // printf("_pte : %p %p\n",pte, *pte);
          
          if(old_pte == 0)
            panic("(fork, shared, mapped)");

          pte_t* new_pte = walk(np->pagetable,a,1);

          *new_pte = *old_pte;
          np->mmap_list[i+2] = p->mmap_list[i+2];   
          
          //make ref N ++
          incr_pa_ref((void*)PTE2PA((*old_pte)));
        }
      }
      else if((flags&FLAG_MASK) == MAP_PRIVATE)
      {
        // case2) private

        for(a = addr; a < addr + length; a += PGSIZE)
        {
          
          if((pte = walk(p->pagetable, a, 0)) == 0)
          {
            // case 2-ii-a) page table has not been created
            // no need to share pages
            // but need to share mmap_list
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            continue;

            //create only page tables with no mapping, send to b)
            pte = walk(p->pagetable,a,1);
            
          }
          if((*pte & PTE_V) == 0)
          {
            // case 2-ii-b) page table exists, but not valid
            // no need to share
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            continue;
            
          }
          if(PTE_FLAGS(*pte) == PTE_V)
            panic("fork: not a leaf");        

          
          if((flags & PROT_MASK) == PROT_READ)
          {
            // case 2-i-a) 'private' and already mapped(kalloc'd), read-only
            // just need sharing


            // just map np->mmap_list to 기존의 pa page
            pte_t* old_pte = walk(p->pagetable,a,0);

            
            if(old_pte == 0)
              panic("(fork, shared, mapped)");

            
            pte_t* new_pte = walk(np->pagetable,a,1);

            *new_pte = *old_pte;
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            
            //make ref N ++
            incr_pa_ref((void*)PTE2PA((*old_pte)));

          }
          else
          {
            // case 2-i-b) 'private' and already mapped(kalloc'd), read-write
            // need to CoW

            
            //value, not pointer
            pte_t changed_pte = *pte;

            //change flags for new_pte
            uint64 newflags = create_pte_flag(flags, 0, 1);

            changed_pte = (changed_pte & (~0x3FF)) | newflags;


            // make both child and parent's pte

            *pte = changed_pte;


            pte_t* old_pte = walk(p->pagetable,a,0);
            // printf("old_pte : %p %p\n",old_pte, *old_pte);
            // printf("_pte : %p %p\n",pte, *pte);
            
            if(old_pte == 0)
              panic("(fork, private, mapped)");

            
            pte_t* new_pte = walk(np->pagetable,a,1);

            *new_pte = *old_pte;
            np->mmap_list[i+2] = p->mmap_list[i+2];   
            
            //make ref N ++
            incr_pa_ref((void*)PTE2PA((*old_pte)));
          }
        }
      }
      else
      {
        // printf("weird flags on %p : %p\n",addr, flags&FLAG_MASK);
        // panic("weird flags in mmap_list");
      }
      //uvmunmap(pagetable,addr,length/PGSIZE,1);
    }      
  }
  

  // copy saved user registers.
  *(np->trapframe) = *(p->trapframe);

  // Cause fork to return 0 in the child.
  np->trapframe->a0 = 0;

  // increment reference counts on open file descriptors.
  for(i = 0; i < NOFILE; i++)
    if(p->ofile[i])
      np->ofile[i] = filedup(p->ofile[i]);
  np->cwd = idup(p->cwd);

  safestrcpy(np->name, p->name, sizeof(p->name));

  pid = np->pid;

  release(&np->lock);

  acquire(&wait_lock);
  np->parent = p;
  release(&wait_lock);

  acquire(&np->lock);
  np->state = RUNNABLE;
  release(&np->lock);

  return pid;
}

// Pass p's abandoned children to init.
// Caller must hold wait_lock.
void
reparent(struct proc *p)
{
  struct proc *pp;

  for(pp = proc; pp < &proc[NPROC]; pp++){
    if(pp->parent == p){
      pp->parent = initproc;
      wakeup(initproc);
    }
  }
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait().
void
exit(int status)
{
  struct proc *p = myproc();

  if(p == initproc)
    panic("init exiting");

  // for(int i=0; i<12; i+=3)
  // {
  //   printf("exiting... %p\n",p->mmap_list[i]);
  // }

  // Close all open files.
  for(int fd = 0; fd < NOFILE; fd++){
    if(p->ofile[fd]){
      struct file *f = p->ofile[fd];
      fileclose(f);
      p->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(p->cwd);
  end_op();
  p->cwd = 0;

  acquire(&wait_lock);

  // Give any children to init.
  reparent(p);

  // Parent might be sleeping in wait().
  wakeup(p->parent);
  
  acquire(&p->lock);

  p->xstate = status;
  p->state = ZOMBIE;

  release(&wait_lock);

  // Jump into the scheduler, never to return.
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(uint64 addr)
{
  struct proc *pp;
  int havekids, pid;
  struct proc *p = myproc();

  acquire(&wait_lock);

  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(pp = proc; pp < &proc[NPROC]; pp++){
      if(pp->parent == p){
        // make sure the child isn't still in exit() or swtch().
        acquire(&pp->lock);

        havekids = 1;
        if(pp->state == ZOMBIE){
          // Found one.
          pid = pp->pid;
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
                                  sizeof(pp->xstate)) < 0) {
            release(&pp->lock);
            release(&wait_lock);
            return -1;
          }
          freeproc(pp);
          release(&pp->lock);
          release(&wait_lock);
          return pid;
        }
        release(&pp->lock);
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || killed(p)){
      release(&wait_lock);
      return -1;
    }
    
    // Wait for a child to exit.
    sleep(p, &wait_lock);  //DOC: wait-sleep
  }
}

// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run.
//  - swtch to start running that process.
//  - eventually that process transfers control
//    via swtch back to the scheduler.
void
scheduler(void)
{
  struct proc *p;
  struct cpu *c = mycpu();
  
  c->proc = 0;
  for(;;){
    // Avoid deadlock by ensuring that devices can interrupt.
    intr_on();

    for(p = proc; p < &proc[NPROC]; p++) {
      acquire(&p->lock);
      if(p->state == RUNNABLE) {
        // Switch to chosen process.  It is the process's job
        // to release its lock and then reacquire it
        // before jumping back to us.
        p->state = RUNNING;
        c->proc = p;
        swtch(&c->context, &p->context);

        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
      }
      release(&p->lock);
    }
  }
}

// Switch to scheduler.  Must hold only p->lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->noff, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&p->lock))
    panic("sched p->lock");
  if(mycpu()->noff != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(intr_get())
    panic("sched interruptible");

  intena = mycpu()->intena;
  swtch(&p->context, &mycpu()->context);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  struct proc *p = myproc();
  acquire(&p->lock);
  p->state = RUNNABLE;
  sched();
  release(&p->lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);

  if (first) {
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  // Must acquire p->lock in order to
  // change p->state and then call sched.
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
  release(lk);

  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  release(&p->lock);
  acquire(lk);
}

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
        p->state = RUNNABLE;
      }
      release(&p->lock);
    }
  }
}

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    acquire(&p->lock);
    if(p->pid == pid){
      p->killed = 1;
      if(p->state == SLEEPING){
        // Wake process from sleep().
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
  }
  return -1;
}

void
setkilled(struct proc *p)
{
  acquire(&p->lock);
  p->killed = 1;
  release(&p->lock);
}

int
killed(struct proc *p)
{
  int k;
  
  acquire(&p->lock);
  k = p->killed;
  release(&p->lock);
  return k;
}

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
  struct proc *p = myproc();
  if(user_dst){
    return copyout(p->pagetable, dst, src, len);
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
  struct proc *p = myproc();
  if(user_src){
    return copyin(p->pagetable, dst, src, len);
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [USED]      "used",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
  for(p = proc; p < &proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    printf("%d %s %s", p->pid, state, p->name);
    printf("\n");
  }
}


void
pagefault(uint64 scause, uint64 stval)
{
  pagefaults++;
  //stval is va

  int is_mmaped = 0;
  struct proc *p = myproc();

  acquire(&mmaplock);

  uint64 addr, length, b, flags, huge_page, prot;

  // find mapping
  // remember order : address-length-(prot | ishuge | flags)
  for(int i=0;i <12; i+=3)
  {
    addr = p->mmap_list[i];
    length = p->mmap_list[i+1];
    b = p->mmap_list[i+2];

    if(addr == 0)
      continue;

    // printf("addr : %p\n", addr);
    // printf("length : %d\n", length);
    // printf("b : %p\n", b);

    flags = (b & FLAG_MASK);
    huge_page = (b & HUGE_MASK);
    prot = (b & PROT_MASK);

    // was page fault inside mmap'ed zone 
    if(addr <= stval && stval < addr + length)
    {
      is_mmaped = 1;

      // now, find the addr for the proper block
      if(huge_page)
      {
        addr = HUGEPGROUNDDOWN(stval);
      }
      else
      {
        addr = PGROUNDDOWN(stval);
      }

      break;
    }
  }

  if(!is_mmaped)
  {
    release(&mmaplock);
    printf("usertrap(): unexpected scause %p pid=%d\n", scause, p->pid);
    printf("            sepc=%p stval=%p\n", r_sepc(), stval);
    setkilled(p);
    return;
  }

  

  //now, actually allocate


// #define PROT_READ       0x0001
// #define PROT_WRITE      0x0002

// #define MAP_PRIVATE     0x0010
// #define MAP_SHARED      0x0020
// #define MAP_HUGEPAGE    0x0100

  if(huge_page == MAP_HUGEPAGE)
  {

    // 1. make a walk that stops at level 1

    // 2. use that walk.

    
    
    // make perm(valid bit 1)
    uint64 perm = 1;
    
    // read/write 
    if(prot == PROT_READ)
      perm += 2;
    else
      perm += 6;

    
    // allow user access
    perm += 16;

 
    // private/shared(private is 1 on 9th block(256))
    if(flags == MAP_PRIVATE)
      perm += 256;

    
    // this only checks if page table for VA has been created
    // doesn't check validity(or actual mapping 여부) for the PTE 
    pte_t* leaf_pte = walk_huge(p->pagetable, addr, 1);
    //printf("HUGE PAGE FAULT : %p %p\n",leaf_pte, *leaf_pte);
    
    // huge page kalloc
    uint64 pa;

    // checks validity
    if(*leaf_pte & PTE_V)
    {
      // the virtual address addr has already been mapped

      // catch writing to read-only violation
      pa = PTE2PA(*leaf_pte);

      if(scause == 15 && ((*leaf_pte & PTE_W) == 0))
      {
        if(((*leaf_pte & PTE_CoW) == 0x300) && ((*leaf_pte & PTE_R) != 0))
        {
          //printf("(huge)before cow : %p %p\n",leaf_pte,*leaf_pte);
          uint64* new_page = kalloc_huge();
 
          memmove(new_page, (void*)PTE2PA(*leaf_pte), HUGEPGSIZE);
          
          kfree_huge((void*)PTE2PA(*leaf_pte));
          *leaf_pte = PA2PTE(new_page) | create_pte_flag(b,0,0);
          //printf("(huge)after cow : %p %p\n",leaf_pte,*leaf_pte);
          

          release(&mmaplock);
          return;
        }

        release(&mmaplock);
        printf("usertrap(): unexpected scause %p pid=%d\n", scause, p->pid);
        printf("            sepc=%p stval=%p\n", r_sepc(), stval);
        setkilled(p);
        return;
      }
    }
    else
    {
      // not mapped, make mapping for page

      // catch read/write to shared pages that were not alloc'd
      // isCow flag on + isShared + readable
      if(((*leaf_pte & PTE_CoW) == 0x200) && ((*leaf_pte & PTE_R) != 0))
      {
        pa = (uint64)kalloc_huge();
        *leaf_pte = PA2PTE(pa) | perm;

        // connect all other processes ptes' to this pa
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
        {
          acquire(&np->lock);
          // non -exe procs must be skipped
          if(np->pagetable ==0)
          {
            release(&np->lock);
            continue;
          }          

          //skip itself
          if(np->pid == p->pid)
          {
            release(&np->lock);
            continue;
          }

          pte_t* np_pte = walk_huge(np->pagetable, addr, 0);
          if(np_pte == 0)
          {
            release(&np->lock);
            continue;
          }

          // double check for sure
          if(((*np_pte & PTE_CoW) == 0x200) && ((*np_pte & PTE_R) != 0) && ((*np_pte & PTE_V) == 0))
          {
            *np_pte = *leaf_pte;
            incr_huge_pa_ref((void*)pa);
          }
          else
          {
          }
          release(&np->lock);
        }
        release(&mmaplock);
        return;
      }

      pa = (uint64)kalloc_huge();
      *leaf_pte = PA2PTE(pa) | perm; 
    }
     //printf("(huge page) va : %p, pa : %p, &PTE : %p, PTE: %p\n",addr, pa, leaf_pte, *leaf_pte);
  }
  else
  {
    // base page
    
    // make perm(valid bit 1)
    uint64 perm = 1;
    
    // read/write 
    if(prot == PROT_READ)
      perm += 2;
    else
      perm += 6;


    // allow user access
    perm += 16;

    // private/shared(private is 1 on 9th block(256))
    if(flags == MAP_PRIVATE)
      perm += 256;

    

    // this only checks if page table for VA has been created
    // doesn't check validity(or actual mapping 여부) for the PTE 


    // TODO : need to map for "all" lengths    

    pte_t* leaf_pte = walk(p->pagetable, addr, 1);

    uint64 pa = 0;

    // checks validity
    if(*leaf_pte & PTE_V)
    {
    // mapping already exists

      // catch writing to read-only violation
      if(scause == 15 && ((*leaf_pte & PTE_W) == 0))
      {
        if(((*leaf_pte & PTE_CoW) == 0x300) && ((*leaf_pte & PTE_R) != 0))
        {
          //printf("before cow : %p %p\n",leaf_pte,*leaf_pte);
          uint64* new_page = kalloc();
          memmove(new_page, (void*)PTE2PA(*leaf_pte), PGSIZE);
          kfree((void*)PTE2PA(*leaf_pte));
          *leaf_pte = PA2PTE(new_page) | create_pte_flag(b,0,0);
          //printf("after cow : %p %p\n",leaf_pte,*leaf_pte);
          

          release(&mmaplock);
          return;
        }

        release(&mmaplock);
        printf("usertrap(): unexpected scause %p pid=%d\n", scause, p->pid);
        printf("            sepc=%p stval=%p\n", r_sepc(), stval);
        setkilled(p);
        return;
      }

    }
    else
    {
      // catch read/write to shared pages that were not alloc'd
      // isCow flag on + isShared + readable
      if(((*leaf_pte & PTE_CoW) == 0x200) && ((*leaf_pte & PTE_R) != 0))
      {
        //printf("found shared without alloc on %p\n", addr);
        pa = (uint64)kalloc();
        *leaf_pte = PA2PTE(pa) | perm;

        // connect all other processes ptes' to this pa
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
        {
          acquire(&np->lock);
          // non -exe procs must be skipped
          if(np->pagetable ==0)
          {
            release(&np->lock);
            continue;
          }          

          //skip itself
          if(np->pid == p->pid)
          {
            release(&np->lock);
            continue;
          }

          pte_t* np_pte = walk(np->pagetable, addr, 0);
          if(np_pte == 0)
          {
            release(&np->lock);
            continue;
          }

          // double check for sure
          if(((*np_pte & PTE_CoW) == 0x200) && ((*np_pte & PTE_R) != 0) && ((*np_pte & PTE_V) == 0))
          {
            //printf("pte found at pid = %d. %p : %p\n", np->pid, np_pte, *np_pte);
            *np_pte = *leaf_pte;
            incr_pa_ref((void*)pa);
          }
          else
          {
            //printf("wrong pte found at pid = %d. %p : %p\n", np->pid, np_pte, *np_pte);
          }

          release(&np->lock);
        }
        release(&mmaplock);
        return;
      }

      // map the actual PA to VA
      pa = (uint64)kalloc();

      *leaf_pte = PA2PTE(pa) | perm;
      
      

    }
      
    //printf("va : %p, pa : %p, &PTE : %p, PTE: %p\n",addr, pa, leaf_pte, *leaf_pte);

  }
  release(&mmaplock);

  // PA4: FILL HERE
  
  //panic("page fault he he");
}
