#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"


void 
meminfo(char *s)
{
  printf("%s: freemem=%d, used4k=%d, used2m=%d\n", 
      s, kcall(KC_FREEMEM), kcall(KC_USED4K), kcall(KC_USED2M));
}

void
main(int argc, char *argv[])
{
  void *pa;
  //void *pa_prev;


  meminfo("Init");
  pa = ktest(KT_KALLOC_HUGE, 0);
  meminfo("After KT_KALLOC_HUGE()");
  // ktest(KT_KFREE_HUGE, pa);
  // meminfo("After KT_KFREE_HUGE()");
  pa = ktest(KT_KALLOC, 0);
  printf("%p\n",pa);
  meminfo("After KT_KALLOC()");
  ktest(KT_KFREE, pa);
  meminfo("After KT_KFREE()");

  void* prev_pa = 0;
  for(int i=0; i< 40000; i++)  
  {
    prev_pa = pa;
    pa = ktest(KT_KALLOC, 0);
    if(pa == 0)
    {
      printf("%d, %p\n",i, pa);
      break;
    }

  }
  meminfo("after loop");

//   for(int i=0; i< 60; i++)
//   {
//     pa = ktest(KT_KALLOC_HUGE, 0);
//     printf("%d : %p kalloc_huge\n",i,pa);
//   }

//   for(int i=0; i< 60; i++)
//   {
//     ktest(KT_KFREE_HUGE, pa);
//     printf("%d : kalloc_free\n",i);
//     pa-= 2097152*2;
//   }

//   meminfo("After kalloc(_huge loop)");
//  ktest(KT_KFREE_HUGE, pa);
//   meminfo("After kfree_huge()");

 ktest(KT_KFREE, prev_pa);

  meminfo("After kfree()_prev");

    pa = ktest(KT_KALLOC, 0);
  meminfo("After kalloc()");
  ktest(KT_KFREE, pa);

  meminfo("After kfree()");
 ktest(KT_KALLOC_HUGE, 0);
  meminfo("After final huge alloc()");
  return;
}
