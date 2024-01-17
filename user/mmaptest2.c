#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
main(int argc, char *argv[])
{
  uint64 p = (uint64) 0x100000000ULL;


  mmap((void *)p, 513, PROT_WRITE, MAP_SHARED);
  //munmap((void *)p);

  *(int *)p = 0xdeadbeef;


  char *echoargv[] = { "echo", "OK", 0 };
  exec("echo", echoargv);


    if (fork() == 0)
  {
    //munmap((void *)p);
    //mmap((void *)p, 100, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);

    printf("pid %d: %x\n", getpid(), *(int *)p);
    *(int *)p = 0x900dbeef;



    printf("pid %d: %x\n", getpid(), *(int *)p);
    *(int *)(p+4096) = 0xbeefbeef;
    *(int *)(p+4096*2) = 0x33333333;

    printf("pid %d: %x\n", getpid(), *(int *)(p+4096));


    *(int *)(p+4096*512) = 0x44444444;
  
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096));
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096*512));

    exit(0);
  }
    wait(0);
    printf("pid %d: %x\n", getpid(), *(int *)p);
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096));
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096*512));


  // if (fork() == 0)
  // {
  //   //munmap((void *)p);
  //   //mmap((void *)p, 100, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);
  //   sleep(50);
  //   printf("pid %d: %x\n", getpid(), *(int *)p);
  //   *(int *)p = 0x900dbeef;

  //   printf("pid %d: %x\n", getpid(), *(int *)p);
  //   exit(0);
  // }
  // if (fork() == 0)
  // {
  //   //munmap((void *)p);
  //   //mmap((void *)p, 100, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);
  //   *(int *)p = 0x11111111;

  //   sleep(10);

  //   printf("pid %d: %x\n", getpid(), *(int *)p);
  //   exit(0);
  // }
  //   wait(0);
  //   wait(0);
  // printf("pid %d: %x\n", getpid(), *(int *)p);

  // if (fork() == 0)
  // {
  //   //munmap((void *)p);
  //   //mmap((void *)p, 100, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);
  //   *(int *)p = 0xbeefbeef;

  //   printf("pid %d: %x\n", getpid(), *(int *)p);

  //   if(fork() == 0)
  //   {
  //     *(int *)p = 0xbeefdead;
  //     printf("pid %d: %x\n", getpid(), *(int *)p);
  //   }
  //   wait(0);

  //   exit(0);
  // }

  // wait(0);
  // printf("pid %d: %x\n", getpid(), *(int *)p);
  // //munmap((void *)p);
  exit(0);
  return;
}
