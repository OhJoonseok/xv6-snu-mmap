#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
main(int argc, char *argv[])
{
  uint64 p = (uint64) 0x100000000ULL;
  
  printf("base page : %p\n", mmap((void *)(p), 4097, PROT_WRITE, MAP_SHARED));
  *(int *)(p+16) = 0x900dbeef;
  printf("[%d]try read 1: %x\n",1,*(int *)(p+24));
  munmap((void*)p);

  printf("base page2 : %p\n", mmap((void *)(p), 4096*4, PROT_WRITE, MAP_SHARED));
  *(int *)(p+5000) = 0x900dbeef;
  //munmap((void*)p);

  

  // for(int i=0; i<5000; i+=8)
  // {
    
  //   printf("[%d]try read 1: %x\n",i,*(int *)(p+i));
  //   *(int *)(p+i) = 0x900dbeef;
  //   printf("[%d]try read 2: %x\n\n",i,*(int *)(p+i));
  // }
  
  // munmap((void*)p);

  printf("HUGE page : %p\n", mmap((void *)(p), 4096*513, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE));
  printf("(HUGE)[]try read 1: %x\n",*(int *)(p+5000));
  *(int *)(p) = 0xbeefbeef;
  printf("(HUGE)[]try read 2: %x\n\n",*(int *)(p));
  munmap((void*)p);
  printf("HUGE page 2: %p\n", mmap((void *)(p), 4096*513, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE));
 


  printf("(HUGE)[]try read 3: %x\n",*(int *)(p+4096*512));
  *(int *)(p+4096*512) = 0x900dbeef;
  printf("(HUGE)[]try read 4: %x\n\n",*(int *)(p+4096*512));
  



 
  return;
}
