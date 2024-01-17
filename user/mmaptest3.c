#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

void
main(int argc, char *argv[])
{
  uint64 p = (uint64) 0x100000000ULL;
  uint64 p2 = p +4096*1024;
  uint64 p3 = p2 +4096*1024;
  uint64 p4 = p3 +4096*1024;
  
  mmap((void *)p, 513*4096, PROT_WRITE, MAP_PRIVATE);
  mmap((void *)p2, 513*4096, PROT_WRITE, MAP_PRIVATE | MAP_HUGEPAGE);
  mmap((void *)p3, 513*4096, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);
  mmap((void *)p4, 513*4096, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);
  


  *(int *)p = 0xdead1111;
  *(int *)p2 = 0xdead2222;
  //*(int *)p3 = 0xdead3333;
  *(int *)p4 = 0xdead4444;
  
  //*(int *)(p+512*4096) = 0xddddaaaa;
  if (fork() == 0)
  {
    //*(int *)p = 0x900dbeef;

    char *echoargv[] = { "echo", "OK", 0 };
      printf("pid %d: %x\n", getpid(), *(int *)p);
      *(int *)p = 0xbeefbeef;
      printf("pid %d: %x\n", getpid(), *(int *)p);

      // printf("pid %d: %x\n", getpid(), *(int *)p2);
      // *(int *)p2 = 0xbeefbeef;
      // printf("pid %d: %x\n", getpid(), *(int *)p2);
      

      printf("pid %d: %x\n", getpid(), *(int *)(p+512*4096));

      

    if (fork() == 0)
    {
      char *echoargv[] = { "echo", "OK", 0 };
      printf("pid %d: %x\n", getpid(), *(int *)p);
      *(int *)p = 0xbeefbeef;
      printf("pid %d: %x\n", getpid(), *(int *)p);

      printf("pid %d: %x\n", getpid(), *(int *)p2);
      *(int *)p2 = 0xbeefbeef;
      printf("pid %d: %x\n", getpid(), *(int *)p2);
      

      printf("pid %d: %x\n", getpid(), *(int *)(p+512*4096));

      exec("echo", echoargv);
      printf("exec returned\n");
      exit(0);
    }
    wait(0);

    printf("pid %d: %x\n", getpid(), *(int *)p);
    *(int *)(p3+ 512*4096) = 0xeeeebbbb;
    *(int *)(p) = 0xbbbbeeee;
    sleep(10);
    printf("pid %d: %x\n", getpid(), *(int *)p);
    exec("echo", echoargv);
      printf("exec returned\n");
      exit(0);
  }
  wait(0);
  printf("pid %d: %x\n", getpid(), *(int *)p);
    *(int *)p = 0x1111beef;
  printf("pid %d: %x\n", getpid(), *(int *)p);
  printf("p3 pid %d: %x\n", getpid(), *(int *)(p3+ 512*4096));
  
    
  munmap((void *)p);
  exit(0);
  return;
}
