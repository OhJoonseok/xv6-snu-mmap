
user/_mmaptest3:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

void
main(int argc, char *argv[])
{
   0:	711d                	add	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	1080                	add	s0,sp,96
  uint64 p = (uint64) 0x100000000ULL;
  uint64 p2 = p +4096*1024;
  uint64 p3 = p2 +4096*1024;
  uint64 p4 = p3 +4096*1024;
  
  mmap((void *)p, 513*4096, PROT_WRITE, MAP_PRIVATE);
   8:	46c1                	li	a3,16
   a:	4609                	li	a2,2
   c:	002015b7          	lui	a1,0x201
  10:	4505                	li	a0,1
  12:	1502                	sll	a0,a0,0x20
  14:	00000097          	auipc	ra,0x0
  18:	684080e7          	jalr	1668(ra) # 698 <mmap>
  mmap((void *)p2, 513*4096, PROT_WRITE, MAP_PRIVATE | MAP_HUGEPAGE);
  1c:	11000693          	li	a3,272
  20:	4609                	li	a2,2
  22:	002015b7          	lui	a1,0x201
  26:	40100513          	li	a0,1025
  2a:	055a                	sll	a0,a0,0x16
  2c:	00000097          	auipc	ra,0x0
  30:	66c080e7          	jalr	1644(ra) # 698 <mmap>
  mmap((void *)p3, 513*4096, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);
  34:	12000693          	li	a3,288
  38:	4609                	li	a2,2
  3a:	002015b7          	lui	a1,0x201
  3e:	20100513          	li	a0,513
  42:	055e                	sll	a0,a0,0x17
  44:	00000097          	auipc	ra,0x0
  48:	654080e7          	jalr	1620(ra) # 698 <mmap>
  mmap((void *)p4, 513*4096, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);
  4c:	12000693          	li	a3,288
  50:	4609                	li	a2,2
  52:	002015b7          	lui	a1,0x201
  56:	40300513          	li	a0,1027
  5a:	055a                	sll	a0,a0,0x16
  5c:	00000097          	auipc	ra,0x0
  60:	63c080e7          	jalr	1596(ra) # 698 <mmap>
  


  *(int *)p = 0xdead1111;
  64:	4785                	li	a5,1
  66:	1782                	sll	a5,a5,0x20
  68:	dead1737          	lui	a4,0xdead1
  6c:	11170713          	add	a4,a4,273 # ffffffffdead1111 <base+0xffffffffdead0101>
  70:	c398                	sw	a4,0(a5)
  *(int *)p2 = 0xdead2222;
  72:	40100793          	li	a5,1025
  76:	07da                	sll	a5,a5,0x16
  78:	dead2737          	lui	a4,0xdead2
  7c:	22270713          	add	a4,a4,546 # ffffffffdead2222 <base+0xffffffffdead1212>
  80:	c398                	sw	a4,0(a5)
  //*(int *)p3 = 0xdead3333;
  *(int *)p4 = 0xdead4444;
  82:	40300793          	li	a5,1027
  86:	07da                	sll	a5,a5,0x16
  88:	dead4737          	lui	a4,0xdead4
  8c:	44470713          	add	a4,a4,1092 # ffffffffdead4444 <base+0xffffffffdead3434>
  90:	c398                	sw	a4,0(a5)
  
  //*(int *)(p+512*4096) = 0xddddaaaa;
  if (fork() == 0)
  92:	00000097          	auipc	ra,0x0
  96:	54e080e7          	jalr	1358(ra) # 5e0 <fork>
  9a:	22051263          	bnez	a0,2be <main+0x2be>
  9e:	e4a6                	sd	s1,72(sp)
  {
    //*(int *)p = 0x900dbeef;

    char *echoargv[] = { "echo", "OK", 0 };
  a0:	00001797          	auipc	a5,0x1
  a4:	a9078793          	add	a5,a5,-1392 # b30 <malloc+0x108>
  a8:	faf43023          	sd	a5,-96(s0)
  ac:	00001797          	auipc	a5,0x1
  b0:	a9478793          	add	a5,a5,-1388 # b40 <malloc+0x118>
  b4:	faf43423          	sd	a5,-88(s0)
  b8:	fa043823          	sd	zero,-80(s0)
      printf("pid %d: %x\n", getpid(), *(int *)p);
  bc:	00000097          	auipc	ra,0x0
  c0:	5ac080e7          	jalr	1452(ra) # 668 <getpid>
  c4:	85aa                	mv	a1,a0
  c6:	4485                	li	s1,1
  c8:	1482                	sll	s1,s1,0x20
  ca:	4090                	lw	a2,0(s1)
  cc:	00001517          	auipc	a0,0x1
  d0:	a7c50513          	add	a0,a0,-1412 # b48 <malloc+0x120>
  d4:	00001097          	auipc	ra,0x1
  d8:	89c080e7          	jalr	-1892(ra) # 970 <printf>
      *(int *)p = 0xbeefbeef;
  dc:	beefc7b7          	lui	a5,0xbeefc
  e0:	eef78793          	add	a5,a5,-273 # ffffffffbeefbeef <base+0xffffffffbeefaedf>
  e4:	c09c                	sw	a5,0(s1)
      printf("pid %d: %x\n", getpid(), *(int *)p);
  e6:	00000097          	auipc	ra,0x0
  ea:	582080e7          	jalr	1410(ra) # 668 <getpid>
  ee:	85aa                	mv	a1,a0
  f0:	4090                	lw	a2,0(s1)
  f2:	00001517          	auipc	a0,0x1
  f6:	a5650513          	add	a0,a0,-1450 # b48 <malloc+0x120>
  fa:	00001097          	auipc	ra,0x1
  fe:	876080e7          	jalr	-1930(ra) # 970 <printf>
      // printf("pid %d: %x\n", getpid(), *(int *)p2);
      // *(int *)p2 = 0xbeefbeef;
      // printf("pid %d: %x\n", getpid(), *(int *)p2);
      

      printf("pid %d: %x\n", getpid(), *(int *)(p+512*4096));
 102:	00000097          	auipc	ra,0x0
 106:	566080e7          	jalr	1382(ra) # 668 <getpid>
 10a:	85aa                	mv	a1,a0
 10c:	008017b7          	lui	a5,0x801
 110:	07a6                	sll	a5,a5,0x9
 112:	4390                	lw	a2,0(a5)
 114:	00001517          	auipc	a0,0x1
 118:	a3450513          	add	a0,a0,-1484 # b48 <malloc+0x120>
 11c:	00001097          	auipc	ra,0x1
 120:	854080e7          	jalr	-1964(ra) # 970 <printf>

      

    if (fork() == 0)
 124:	00000097          	auipc	ra,0x0
 128:	4bc080e7          	jalr	1212(ra) # 5e0 <fork>
 12c:	e97d                	bnez	a0,222 <main+0x222>
 12e:	e0ca                	sd	s2,64(sp)
 130:	fc4e                	sd	s3,56(sp)
    {
      char *echoargv[] = { "echo", "OK", 0 };
 132:	00001997          	auipc	s3,0x1
 136:	9fe98993          	add	s3,s3,-1538 # b30 <malloc+0x108>
 13a:	fb343c23          	sd	s3,-72(s0)
 13e:	00001797          	auipc	a5,0x1
 142:	a0278793          	add	a5,a5,-1534 # b40 <malloc+0x118>
 146:	fcf43023          	sd	a5,-64(s0)
 14a:	fc043423          	sd	zero,-56(s0)
      printf("pid %d: %x\n", getpid(), *(int *)p);
 14e:	00000097          	auipc	ra,0x0
 152:	51a080e7          	jalr	1306(ra) # 668 <getpid>
 156:	85aa                	mv	a1,a0
 158:	4485                	li	s1,1
 15a:	1482                	sll	s1,s1,0x20
 15c:	4090                	lw	a2,0(s1)
 15e:	00001517          	auipc	a0,0x1
 162:	9ea50513          	add	a0,a0,-1558 # b48 <malloc+0x120>
 166:	00001097          	auipc	ra,0x1
 16a:	80a080e7          	jalr	-2038(ra) # 970 <printf>
      *(int *)p = 0xbeefbeef;
 16e:	beefc937          	lui	s2,0xbeefc
 172:	eef90913          	add	s2,s2,-273 # ffffffffbeefbeef <base+0xffffffffbeefaedf>
 176:	0124a023          	sw	s2,0(s1)
      printf("pid %d: %x\n", getpid(), *(int *)p);
 17a:	00000097          	auipc	ra,0x0
 17e:	4ee080e7          	jalr	1262(ra) # 668 <getpid>
 182:	85aa                	mv	a1,a0
 184:	4090                	lw	a2,0(s1)
 186:	00001517          	auipc	a0,0x1
 18a:	9c250513          	add	a0,a0,-1598 # b48 <malloc+0x120>
 18e:	00000097          	auipc	ra,0x0
 192:	7e2080e7          	jalr	2018(ra) # 970 <printf>

      printf("pid %d: %x\n", getpid(), *(int *)p2);
 196:	00000097          	auipc	ra,0x0
 19a:	4d2080e7          	jalr	1234(ra) # 668 <getpid>
 19e:	85aa                	mv	a1,a0
 1a0:	40100493          	li	s1,1025
 1a4:	04da                	sll	s1,s1,0x16
 1a6:	4090                	lw	a2,0(s1)
 1a8:	00001517          	auipc	a0,0x1
 1ac:	9a050513          	add	a0,a0,-1632 # b48 <malloc+0x120>
 1b0:	00000097          	auipc	ra,0x0
 1b4:	7c0080e7          	jalr	1984(ra) # 970 <printf>
      *(int *)p2 = 0xbeefbeef;
 1b8:	0124a023          	sw	s2,0(s1)
      printf("pid %d: %x\n", getpid(), *(int *)p2);
 1bc:	00000097          	auipc	ra,0x0
 1c0:	4ac080e7          	jalr	1196(ra) # 668 <getpid>
 1c4:	85aa                	mv	a1,a0
 1c6:	4090                	lw	a2,0(s1)
 1c8:	00001517          	auipc	a0,0x1
 1cc:	98050513          	add	a0,a0,-1664 # b48 <malloc+0x120>
 1d0:	00000097          	auipc	ra,0x0
 1d4:	7a0080e7          	jalr	1952(ra) # 970 <printf>
      

      printf("pid %d: %x\n", getpid(), *(int *)(p+512*4096));
 1d8:	00000097          	auipc	ra,0x0
 1dc:	490080e7          	jalr	1168(ra) # 668 <getpid>
 1e0:	85aa                	mv	a1,a0
 1e2:	008017b7          	lui	a5,0x801
 1e6:	07a6                	sll	a5,a5,0x9
 1e8:	4390                	lw	a2,0(a5)
 1ea:	00001517          	auipc	a0,0x1
 1ee:	95e50513          	add	a0,a0,-1698 # b48 <malloc+0x120>
 1f2:	00000097          	auipc	ra,0x0
 1f6:	77e080e7          	jalr	1918(ra) # 970 <printf>

      exec("echo", echoargv);
 1fa:	fb840593          	add	a1,s0,-72
 1fe:	854e                	mv	a0,s3
 200:	00000097          	auipc	ra,0x0
 204:	420080e7          	jalr	1056(ra) # 620 <exec>
      printf("exec returned\n");
 208:	00001517          	auipc	a0,0x1
 20c:	95050513          	add	a0,a0,-1712 # b58 <malloc+0x130>
 210:	00000097          	auipc	ra,0x0
 214:	760080e7          	jalr	1888(ra) # 970 <printf>
      exit(0);
 218:	4501                	li	a0,0
 21a:	00000097          	auipc	ra,0x0
 21e:	3ce080e7          	jalr	974(ra) # 5e8 <exit>
 222:	e0ca                	sd	s2,64(sp)
 224:	fc4e                	sd	s3,56(sp)
    }
    wait(0);
 226:	4501                	li	a0,0
 228:	00000097          	auipc	ra,0x0
 22c:	3c8080e7          	jalr	968(ra) # 5f0 <wait>

    printf("pid %d: %x\n", getpid(), *(int *)p);
 230:	00000097          	auipc	ra,0x0
 234:	438080e7          	jalr	1080(ra) # 668 <getpid>
 238:	85aa                	mv	a1,a0
 23a:	4485                	li	s1,1
 23c:	1482                	sll	s1,s1,0x20
 23e:	4090                	lw	a2,0(s1)
 240:	00001517          	auipc	a0,0x1
 244:	90850513          	add	a0,a0,-1784 # b48 <malloc+0x120>
 248:	00000097          	auipc	ra,0x0
 24c:	728080e7          	jalr	1832(ra) # 970 <printf>
    *(int *)(p3+ 512*4096) = 0xeeeebbbb;
 250:	008057b7          	lui	a5,0x805
 254:	07a6                	sll	a5,a5,0x9
 256:	eeeec737          	lui	a4,0xeeeec
 25a:	bbb70713          	add	a4,a4,-1093 # ffffffffeeeebbbb <base+0xffffffffeeeeabab>
 25e:	c398                	sw	a4,0(a5)
    *(int *)(p) = 0xbbbbeeee;
 260:	bbbbf7b7          	lui	a5,0xbbbbf
 264:	eee78793          	add	a5,a5,-274 # ffffffffbbbbeeee <base+0xffffffffbbbbdede>
 268:	c09c                	sw	a5,0(s1)
    sleep(10);
 26a:	4529                	li	a0,10
 26c:	00000097          	auipc	ra,0x0
 270:	40c080e7          	jalr	1036(ra) # 678 <sleep>
    printf("pid %d: %x\n", getpid(), *(int *)p);
 274:	00000097          	auipc	ra,0x0
 278:	3f4080e7          	jalr	1012(ra) # 668 <getpid>
 27c:	85aa                	mv	a1,a0
 27e:	4090                	lw	a2,0(s1)
 280:	00001517          	auipc	a0,0x1
 284:	8c850513          	add	a0,a0,-1848 # b48 <malloc+0x120>
 288:	00000097          	auipc	ra,0x0
 28c:	6e8080e7          	jalr	1768(ra) # 970 <printf>
    exec("echo", echoargv);
 290:	fa040593          	add	a1,s0,-96
 294:	00001517          	auipc	a0,0x1
 298:	89c50513          	add	a0,a0,-1892 # b30 <malloc+0x108>
 29c:	00000097          	auipc	ra,0x0
 2a0:	384080e7          	jalr	900(ra) # 620 <exec>
      printf("exec returned\n");
 2a4:	00001517          	auipc	a0,0x1
 2a8:	8b450513          	add	a0,a0,-1868 # b58 <malloc+0x130>
 2ac:	00000097          	auipc	ra,0x0
 2b0:	6c4080e7          	jalr	1732(ra) # 970 <printf>
      exit(0);
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	332080e7          	jalr	818(ra) # 5e8 <exit>
 2be:	e4a6                	sd	s1,72(sp)
 2c0:	e0ca                	sd	s2,64(sp)
 2c2:	fc4e                	sd	s3,56(sp)
  }
  wait(0);
 2c4:	4501                	li	a0,0
 2c6:	00000097          	auipc	ra,0x0
 2ca:	32a080e7          	jalr	810(ra) # 5f0 <wait>
  printf("pid %d: %x\n", getpid(), *(int *)p);
 2ce:	00000097          	auipc	ra,0x0
 2d2:	39a080e7          	jalr	922(ra) # 668 <getpid>
 2d6:	85aa                	mv	a1,a0
 2d8:	4485                	li	s1,1
 2da:	1482                	sll	s1,s1,0x20
 2dc:	4090                	lw	a2,0(s1)
 2de:	00001517          	auipc	a0,0x1
 2e2:	86a50513          	add	a0,a0,-1942 # b48 <malloc+0x120>
 2e6:	00000097          	auipc	ra,0x0
 2ea:	68a080e7          	jalr	1674(ra) # 970 <printf>
    *(int *)p = 0x1111beef;
 2ee:	1111c7b7          	lui	a5,0x1111c
 2f2:	eef78793          	add	a5,a5,-273 # 1111beef <base+0x1111aedf>
 2f6:	c09c                	sw	a5,0(s1)
  printf("pid %d: %x\n", getpid(), *(int *)p);
 2f8:	00000097          	auipc	ra,0x0
 2fc:	370080e7          	jalr	880(ra) # 668 <getpid>
 300:	85aa                	mv	a1,a0
 302:	4090                	lw	a2,0(s1)
 304:	00001517          	auipc	a0,0x1
 308:	84450513          	add	a0,a0,-1980 # b48 <malloc+0x120>
 30c:	00000097          	auipc	ra,0x0
 310:	664080e7          	jalr	1636(ra) # 970 <printf>
  printf("p3 pid %d: %x\n", getpid(), *(int *)(p3+ 512*4096));
 314:	00000097          	auipc	ra,0x0
 318:	354080e7          	jalr	852(ra) # 668 <getpid>
 31c:	85aa                	mv	a1,a0
 31e:	008057b7          	lui	a5,0x805
 322:	07a6                	sll	a5,a5,0x9
 324:	4390                	lw	a2,0(a5)
 326:	00001517          	auipc	a0,0x1
 32a:	84250513          	add	a0,a0,-1982 # b68 <malloc+0x140>
 32e:	00000097          	auipc	ra,0x0
 332:	642080e7          	jalr	1602(ra) # 970 <printf>
  
    
  munmap((void *)p);
 336:	8526                	mv	a0,s1
 338:	00000097          	auipc	ra,0x0
 33c:	368080e7          	jalr	872(ra) # 6a0 <munmap>
  exit(0);
 340:	4501                	li	a0,0
 342:	00000097          	auipc	ra,0x0
 346:	2a6080e7          	jalr	678(ra) # 5e8 <exit>

000000000000034a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 34a:	1141                	add	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	add	s0,sp,16
  extern int main();
  main();
 352:	00000097          	auipc	ra,0x0
 356:	cae080e7          	jalr	-850(ra) # 0 <main>
  exit(0);
 35a:	4501                	li	a0,0
 35c:	00000097          	auipc	ra,0x0
 360:	28c080e7          	jalr	652(ra) # 5e8 <exit>

0000000000000364 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 364:	1141                	add	sp,sp,-16
 366:	e422                	sd	s0,8(sp)
 368:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 36a:	87aa                	mv	a5,a0
 36c:	0585                	add	a1,a1,1 # 201001 <base+0x1ffff1>
 36e:	0785                	add	a5,a5,1 # 805001 <base+0x803ff1>
 370:	fff5c703          	lbu	a4,-1(a1)
 374:	fee78fa3          	sb	a4,-1(a5)
 378:	fb75                	bnez	a4,36c <strcpy+0x8>
    ;
  return os;
}
 37a:	6422                	ld	s0,8(sp)
 37c:	0141                	add	sp,sp,16
 37e:	8082                	ret

0000000000000380 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 380:	1141                	add	sp,sp,-16
 382:	e422                	sd	s0,8(sp)
 384:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 386:	00054783          	lbu	a5,0(a0)
 38a:	cb91                	beqz	a5,39e <strcmp+0x1e>
 38c:	0005c703          	lbu	a4,0(a1)
 390:	00f71763          	bne	a4,a5,39e <strcmp+0x1e>
    p++, q++;
 394:	0505                	add	a0,a0,1
 396:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 398:	00054783          	lbu	a5,0(a0)
 39c:	fbe5                	bnez	a5,38c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 39e:	0005c503          	lbu	a0,0(a1)
}
 3a2:	40a7853b          	subw	a0,a5,a0
 3a6:	6422                	ld	s0,8(sp)
 3a8:	0141                	add	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <strlen>:

uint
strlen(const char *s)
{
 3ac:	1141                	add	sp,sp,-16
 3ae:	e422                	sd	s0,8(sp)
 3b0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 3b2:	00054783          	lbu	a5,0(a0)
 3b6:	cf91                	beqz	a5,3d2 <strlen+0x26>
 3b8:	0505                	add	a0,a0,1
 3ba:	87aa                	mv	a5,a0
 3bc:	86be                	mv	a3,a5
 3be:	0785                	add	a5,a5,1
 3c0:	fff7c703          	lbu	a4,-1(a5)
 3c4:	ff65                	bnez	a4,3bc <strlen+0x10>
 3c6:	40a6853b          	subw	a0,a3,a0
 3ca:	2505                	addw	a0,a0,1
    ;
  return n;
}
 3cc:	6422                	ld	s0,8(sp)
 3ce:	0141                	add	sp,sp,16
 3d0:	8082                	ret
  for(n = 0; s[n]; n++)
 3d2:	4501                	li	a0,0
 3d4:	bfe5                	j	3cc <strlen+0x20>

00000000000003d6 <memset>:

void*
memset(void *dst, int c, uint n)
{
 3d6:	1141                	add	sp,sp,-16
 3d8:	e422                	sd	s0,8(sp)
 3da:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 3dc:	ca19                	beqz	a2,3f2 <memset+0x1c>
 3de:	87aa                	mv	a5,a0
 3e0:	1602                	sll	a2,a2,0x20
 3e2:	9201                	srl	a2,a2,0x20
 3e4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3e8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 3ec:	0785                	add	a5,a5,1
 3ee:	fee79de3          	bne	a5,a4,3e8 <memset+0x12>
  }
  return dst;
}
 3f2:	6422                	ld	s0,8(sp)
 3f4:	0141                	add	sp,sp,16
 3f6:	8082                	ret

00000000000003f8 <strchr>:

char*
strchr(const char *s, char c)
{
 3f8:	1141                	add	sp,sp,-16
 3fa:	e422                	sd	s0,8(sp)
 3fc:	0800                	add	s0,sp,16
  for(; *s; s++)
 3fe:	00054783          	lbu	a5,0(a0)
 402:	cb99                	beqz	a5,418 <strchr+0x20>
    if(*s == c)
 404:	00f58763          	beq	a1,a5,412 <strchr+0x1a>
  for(; *s; s++)
 408:	0505                	add	a0,a0,1
 40a:	00054783          	lbu	a5,0(a0)
 40e:	fbfd                	bnez	a5,404 <strchr+0xc>
      return (char*)s;
  return 0;
 410:	4501                	li	a0,0
}
 412:	6422                	ld	s0,8(sp)
 414:	0141                	add	sp,sp,16
 416:	8082                	ret
  return 0;
 418:	4501                	li	a0,0
 41a:	bfe5                	j	412 <strchr+0x1a>

000000000000041c <gets>:

char*
gets(char *buf, int max)
{
 41c:	711d                	add	sp,sp,-96
 41e:	ec86                	sd	ra,88(sp)
 420:	e8a2                	sd	s0,80(sp)
 422:	e4a6                	sd	s1,72(sp)
 424:	e0ca                	sd	s2,64(sp)
 426:	fc4e                	sd	s3,56(sp)
 428:	f852                	sd	s4,48(sp)
 42a:	f456                	sd	s5,40(sp)
 42c:	f05a                	sd	s6,32(sp)
 42e:	ec5e                	sd	s7,24(sp)
 430:	1080                	add	s0,sp,96
 432:	8baa                	mv	s7,a0
 434:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 436:	892a                	mv	s2,a0
 438:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 43a:	4aa9                	li	s5,10
 43c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 43e:	89a6                	mv	s3,s1
 440:	2485                	addw	s1,s1,1
 442:	0344d863          	bge	s1,s4,472 <gets+0x56>
    cc = read(0, &c, 1);
 446:	4605                	li	a2,1
 448:	faf40593          	add	a1,s0,-81
 44c:	4501                	li	a0,0
 44e:	00000097          	auipc	ra,0x0
 452:	1b2080e7          	jalr	434(ra) # 600 <read>
    if(cc < 1)
 456:	00a05e63          	blez	a0,472 <gets+0x56>
    buf[i++] = c;
 45a:	faf44783          	lbu	a5,-81(s0)
 45e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 462:	01578763          	beq	a5,s5,470 <gets+0x54>
 466:	0905                	add	s2,s2,1
 468:	fd679be3          	bne	a5,s6,43e <gets+0x22>
    buf[i++] = c;
 46c:	89a6                	mv	s3,s1
 46e:	a011                	j	472 <gets+0x56>
 470:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 472:	99de                	add	s3,s3,s7
 474:	00098023          	sb	zero,0(s3)
  return buf;
}
 478:	855e                	mv	a0,s7
 47a:	60e6                	ld	ra,88(sp)
 47c:	6446                	ld	s0,80(sp)
 47e:	64a6                	ld	s1,72(sp)
 480:	6906                	ld	s2,64(sp)
 482:	79e2                	ld	s3,56(sp)
 484:	7a42                	ld	s4,48(sp)
 486:	7aa2                	ld	s5,40(sp)
 488:	7b02                	ld	s6,32(sp)
 48a:	6be2                	ld	s7,24(sp)
 48c:	6125                	add	sp,sp,96
 48e:	8082                	ret

0000000000000490 <stat>:

int
stat(const char *n, struct stat *st)
{
 490:	1101                	add	sp,sp,-32
 492:	ec06                	sd	ra,24(sp)
 494:	e822                	sd	s0,16(sp)
 496:	e04a                	sd	s2,0(sp)
 498:	1000                	add	s0,sp,32
 49a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 49c:	4581                	li	a1,0
 49e:	00000097          	auipc	ra,0x0
 4a2:	18a080e7          	jalr	394(ra) # 628 <open>
  if(fd < 0)
 4a6:	02054663          	bltz	a0,4d2 <stat+0x42>
 4aa:	e426                	sd	s1,8(sp)
 4ac:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 4ae:	85ca                	mv	a1,s2
 4b0:	00000097          	auipc	ra,0x0
 4b4:	190080e7          	jalr	400(ra) # 640 <fstat>
 4b8:	892a                	mv	s2,a0
  close(fd);
 4ba:	8526                	mv	a0,s1
 4bc:	00000097          	auipc	ra,0x0
 4c0:	154080e7          	jalr	340(ra) # 610 <close>
  return r;
 4c4:	64a2                	ld	s1,8(sp)
}
 4c6:	854a                	mv	a0,s2
 4c8:	60e2                	ld	ra,24(sp)
 4ca:	6442                	ld	s0,16(sp)
 4cc:	6902                	ld	s2,0(sp)
 4ce:	6105                	add	sp,sp,32
 4d0:	8082                	ret
    return -1;
 4d2:	597d                	li	s2,-1
 4d4:	bfcd                	j	4c6 <stat+0x36>

00000000000004d6 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 4d6:	1141                	add	sp,sp,-16
 4d8:	e422                	sd	s0,8(sp)
 4da:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 4dc:	00054703          	lbu	a4,0(a0)
 4e0:	02d00793          	li	a5,45
 4e4:	4585                	li	a1,1
 4e6:	04f70363          	beq	a4,a5,52c <atoi+0x56>

  while('0' <= *s && *s <= '9')
 4ea:	00054703          	lbu	a4,0(a0)
 4ee:	fd07079b          	addw	a5,a4,-48
 4f2:	0ff7f793          	zext.b	a5,a5
 4f6:	46a5                	li	a3,9
 4f8:	02f6ed63          	bltu	a3,a5,532 <atoi+0x5c>
  int n = 0;
 4fc:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 4fe:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 500:	0505                	add	a0,a0,1
 502:	0026979b          	sllw	a5,a3,0x2
 506:	9fb5                	addw	a5,a5,a3
 508:	0017979b          	sllw	a5,a5,0x1
 50c:	9fb9                	addw	a5,a5,a4
 50e:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 512:	00054703          	lbu	a4,0(a0)
 516:	fd07079b          	addw	a5,a4,-48
 51a:	0ff7f793          	zext.b	a5,a5
 51e:	fef671e3          	bgeu	a2,a5,500 <atoi+0x2a>
  return sign * n;
}
 522:	02d5853b          	mulw	a0,a1,a3
 526:	6422                	ld	s0,8(sp)
 528:	0141                	add	sp,sp,16
 52a:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 52c:	0505                	add	a0,a0,1
 52e:	55fd                	li	a1,-1
 530:	bf6d                	j	4ea <atoi+0x14>
  int n = 0;
 532:	4681                	li	a3,0
 534:	b7fd                	j	522 <atoi+0x4c>

0000000000000536 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 536:	1141                	add	sp,sp,-16
 538:	e422                	sd	s0,8(sp)
 53a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 53c:	02b57463          	bgeu	a0,a1,564 <memmove+0x2e>
    while(n-- > 0)
 540:	00c05f63          	blez	a2,55e <memmove+0x28>
 544:	1602                	sll	a2,a2,0x20
 546:	9201                	srl	a2,a2,0x20
 548:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 54c:	872a                	mv	a4,a0
      *dst++ = *src++;
 54e:	0585                	add	a1,a1,1
 550:	0705                	add	a4,a4,1
 552:	fff5c683          	lbu	a3,-1(a1)
 556:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 55a:	fef71ae3          	bne	a4,a5,54e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 55e:	6422                	ld	s0,8(sp)
 560:	0141                	add	sp,sp,16
 562:	8082                	ret
    dst += n;
 564:	00c50733          	add	a4,a0,a2
    src += n;
 568:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 56a:	fec05ae3          	blez	a2,55e <memmove+0x28>
 56e:	fff6079b          	addw	a5,a2,-1
 572:	1782                	sll	a5,a5,0x20
 574:	9381                	srl	a5,a5,0x20
 576:	fff7c793          	not	a5,a5
 57a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 57c:	15fd                	add	a1,a1,-1
 57e:	177d                	add	a4,a4,-1
 580:	0005c683          	lbu	a3,0(a1)
 584:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 588:	fee79ae3          	bne	a5,a4,57c <memmove+0x46>
 58c:	bfc9                	j	55e <memmove+0x28>

000000000000058e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 58e:	1141                	add	sp,sp,-16
 590:	e422                	sd	s0,8(sp)
 592:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 594:	ca05                	beqz	a2,5c4 <memcmp+0x36>
 596:	fff6069b          	addw	a3,a2,-1
 59a:	1682                	sll	a3,a3,0x20
 59c:	9281                	srl	a3,a3,0x20
 59e:	0685                	add	a3,a3,1
 5a0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 5a2:	00054783          	lbu	a5,0(a0)
 5a6:	0005c703          	lbu	a4,0(a1)
 5aa:	00e79863          	bne	a5,a4,5ba <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 5ae:	0505                	add	a0,a0,1
    p2++;
 5b0:	0585                	add	a1,a1,1
  while (n-- > 0) {
 5b2:	fed518e3          	bne	a0,a3,5a2 <memcmp+0x14>
  }
  return 0;
 5b6:	4501                	li	a0,0
 5b8:	a019                	j	5be <memcmp+0x30>
      return *p1 - *p2;
 5ba:	40e7853b          	subw	a0,a5,a4
}
 5be:	6422                	ld	s0,8(sp)
 5c0:	0141                	add	sp,sp,16
 5c2:	8082                	ret
  return 0;
 5c4:	4501                	li	a0,0
 5c6:	bfe5                	j	5be <memcmp+0x30>

00000000000005c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 5c8:	1141                	add	sp,sp,-16
 5ca:	e406                	sd	ra,8(sp)
 5cc:	e022                	sd	s0,0(sp)
 5ce:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 5d0:	00000097          	auipc	ra,0x0
 5d4:	f66080e7          	jalr	-154(ra) # 536 <memmove>
}
 5d8:	60a2                	ld	ra,8(sp)
 5da:	6402                	ld	s0,0(sp)
 5dc:	0141                	add	sp,sp,16
 5de:	8082                	ret

00000000000005e0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5e0:	4885                	li	a7,1
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5e8:	4889                	li	a7,2
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 5f0:	488d                	li	a7,3
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5f8:	4891                	li	a7,4
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <read>:
.global read
read:
 li a7, SYS_read
 600:	4895                	li	a7,5
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <write>:
.global write
write:
 li a7, SYS_write
 608:	48c1                	li	a7,16
 ecall
 60a:	00000073          	ecall
 ret
 60e:	8082                	ret

0000000000000610 <close>:
.global close
close:
 li a7, SYS_close
 610:	48d5                	li	a7,21
 ecall
 612:	00000073          	ecall
 ret
 616:	8082                	ret

0000000000000618 <kill>:
.global kill
kill:
 li a7, SYS_kill
 618:	4899                	li	a7,6
 ecall
 61a:	00000073          	ecall
 ret
 61e:	8082                	ret

0000000000000620 <exec>:
.global exec
exec:
 li a7, SYS_exec
 620:	489d                	li	a7,7
 ecall
 622:	00000073          	ecall
 ret
 626:	8082                	ret

0000000000000628 <open>:
.global open
open:
 li a7, SYS_open
 628:	48bd                	li	a7,15
 ecall
 62a:	00000073          	ecall
 ret
 62e:	8082                	ret

0000000000000630 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 630:	48c5                	li	a7,17
 ecall
 632:	00000073          	ecall
 ret
 636:	8082                	ret

0000000000000638 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 638:	48c9                	li	a7,18
 ecall
 63a:	00000073          	ecall
 ret
 63e:	8082                	ret

0000000000000640 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 640:	48a1                	li	a7,8
 ecall
 642:	00000073          	ecall
 ret
 646:	8082                	ret

0000000000000648 <link>:
.global link
link:
 li a7, SYS_link
 648:	48cd                	li	a7,19
 ecall
 64a:	00000073          	ecall
 ret
 64e:	8082                	ret

0000000000000650 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 650:	48d1                	li	a7,20
 ecall
 652:	00000073          	ecall
 ret
 656:	8082                	ret

0000000000000658 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 658:	48a5                	li	a7,9
 ecall
 65a:	00000073          	ecall
 ret
 65e:	8082                	ret

0000000000000660 <dup>:
.global dup
dup:
 li a7, SYS_dup
 660:	48a9                	li	a7,10
 ecall
 662:	00000073          	ecall
 ret
 666:	8082                	ret

0000000000000668 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 668:	48ad                	li	a7,11
 ecall
 66a:	00000073          	ecall
 ret
 66e:	8082                	ret

0000000000000670 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 670:	48b1                	li	a7,12
 ecall
 672:	00000073          	ecall
 ret
 676:	8082                	ret

0000000000000678 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 678:	48b5                	li	a7,13
 ecall
 67a:	00000073          	ecall
 ret
 67e:	8082                	ret

0000000000000680 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 680:	48b9                	li	a7,14
 ecall
 682:	00000073          	ecall
 ret
 686:	8082                	ret

0000000000000688 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 688:	48d9                	li	a7,22
 ecall
 68a:	00000073          	ecall
 ret
 68e:	8082                	ret

0000000000000690 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 690:	48dd                	li	a7,23
 ecall
 692:	00000073          	ecall
 ret
 696:	8082                	ret

0000000000000698 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 698:	48e1                	li	a7,24
 ecall
 69a:	00000073          	ecall
 ret
 69e:	8082                	ret

00000000000006a0 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 6a0:	48e5                	li	a7,25
 ecall
 6a2:	00000073          	ecall
 ret
 6a6:	8082                	ret

00000000000006a8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 6a8:	1101                	add	sp,sp,-32
 6aa:	ec06                	sd	ra,24(sp)
 6ac:	e822                	sd	s0,16(sp)
 6ae:	1000                	add	s0,sp,32
 6b0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6b4:	4605                	li	a2,1
 6b6:	fef40593          	add	a1,s0,-17
 6ba:	00000097          	auipc	ra,0x0
 6be:	f4e080e7          	jalr	-178(ra) # 608 <write>
}
 6c2:	60e2                	ld	ra,24(sp)
 6c4:	6442                	ld	s0,16(sp)
 6c6:	6105                	add	sp,sp,32
 6c8:	8082                	ret

00000000000006ca <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 6ca:	7139                	add	sp,sp,-64
 6cc:	fc06                	sd	ra,56(sp)
 6ce:	f822                	sd	s0,48(sp)
 6d0:	f426                	sd	s1,40(sp)
 6d2:	0080                	add	s0,sp,64
 6d4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6d6:	c299                	beqz	a3,6dc <printint+0x12>
 6d8:	0805cb63          	bltz	a1,76e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 6dc:	2581                	sext.w	a1,a1
  neg = 0;
 6de:	4881                	li	a7,0
 6e0:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 6e4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 6e6:	2601                	sext.w	a2,a2
 6e8:	00000517          	auipc	a0,0x0
 6ec:	4f050513          	add	a0,a0,1264 # bd8 <digits>
 6f0:	883a                	mv	a6,a4
 6f2:	2705                	addw	a4,a4,1
 6f4:	02c5f7bb          	remuw	a5,a1,a2
 6f8:	1782                	sll	a5,a5,0x20
 6fa:	9381                	srl	a5,a5,0x20
 6fc:	97aa                	add	a5,a5,a0
 6fe:	0007c783          	lbu	a5,0(a5)
 702:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 706:	0005879b          	sext.w	a5,a1
 70a:	02c5d5bb          	divuw	a1,a1,a2
 70e:	0685                	add	a3,a3,1
 710:	fec7f0e3          	bgeu	a5,a2,6f0 <printint+0x26>
  if(neg)
 714:	00088c63          	beqz	a7,72c <printint+0x62>
    buf[i++] = '-';
 718:	fd070793          	add	a5,a4,-48
 71c:	00878733          	add	a4,a5,s0
 720:	02d00793          	li	a5,45
 724:	fef70823          	sb	a5,-16(a4)
 728:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 72c:	02e05c63          	blez	a4,764 <printint+0x9a>
 730:	f04a                	sd	s2,32(sp)
 732:	ec4e                	sd	s3,24(sp)
 734:	fc040793          	add	a5,s0,-64
 738:	00e78933          	add	s2,a5,a4
 73c:	fff78993          	add	s3,a5,-1
 740:	99ba                	add	s3,s3,a4
 742:	377d                	addw	a4,a4,-1
 744:	1702                	sll	a4,a4,0x20
 746:	9301                	srl	a4,a4,0x20
 748:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 74c:	fff94583          	lbu	a1,-1(s2)
 750:	8526                	mv	a0,s1
 752:	00000097          	auipc	ra,0x0
 756:	f56080e7          	jalr	-170(ra) # 6a8 <putc>
  while(--i >= 0)
 75a:	197d                	add	s2,s2,-1
 75c:	ff3918e3          	bne	s2,s3,74c <printint+0x82>
 760:	7902                	ld	s2,32(sp)
 762:	69e2                	ld	s3,24(sp)
}
 764:	70e2                	ld	ra,56(sp)
 766:	7442                	ld	s0,48(sp)
 768:	74a2                	ld	s1,40(sp)
 76a:	6121                	add	sp,sp,64
 76c:	8082                	ret
    x = -xx;
 76e:	40b005bb          	negw	a1,a1
    neg = 1;
 772:	4885                	li	a7,1
    x = -xx;
 774:	b7b5                	j	6e0 <printint+0x16>

0000000000000776 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 776:	715d                	add	sp,sp,-80
 778:	e486                	sd	ra,72(sp)
 77a:	e0a2                	sd	s0,64(sp)
 77c:	f84a                	sd	s2,48(sp)
 77e:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 780:	0005c903          	lbu	s2,0(a1)
 784:	1a090a63          	beqz	s2,938 <vprintf+0x1c2>
 788:	fc26                	sd	s1,56(sp)
 78a:	f44e                	sd	s3,40(sp)
 78c:	f052                	sd	s4,32(sp)
 78e:	ec56                	sd	s5,24(sp)
 790:	e85a                	sd	s6,16(sp)
 792:	e45e                	sd	s7,8(sp)
 794:	8aaa                	mv	s5,a0
 796:	8bb2                	mv	s7,a2
 798:	00158493          	add	s1,a1,1
  state = 0;
 79c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 79e:	02500a13          	li	s4,37
 7a2:	4b55                	li	s6,21
 7a4:	a839                	j	7c2 <vprintf+0x4c>
        putc(fd, c);
 7a6:	85ca                	mv	a1,s2
 7a8:	8556                	mv	a0,s5
 7aa:	00000097          	auipc	ra,0x0
 7ae:	efe080e7          	jalr	-258(ra) # 6a8 <putc>
 7b2:	a019                	j	7b8 <vprintf+0x42>
    } else if(state == '%'){
 7b4:	01498d63          	beq	s3,s4,7ce <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 7b8:	0485                	add	s1,s1,1
 7ba:	fff4c903          	lbu	s2,-1(s1)
 7be:	16090763          	beqz	s2,92c <vprintf+0x1b6>
    if(state == 0){
 7c2:	fe0999e3          	bnez	s3,7b4 <vprintf+0x3e>
      if(c == '%'){
 7c6:	ff4910e3          	bne	s2,s4,7a6 <vprintf+0x30>
        state = '%';
 7ca:	89d2                	mv	s3,s4
 7cc:	b7f5                	j	7b8 <vprintf+0x42>
      if(c == 'd'){
 7ce:	13490463          	beq	s2,s4,8f6 <vprintf+0x180>
 7d2:	f9d9079b          	addw	a5,s2,-99
 7d6:	0ff7f793          	zext.b	a5,a5
 7da:	12fb6763          	bltu	s6,a5,908 <vprintf+0x192>
 7de:	f9d9079b          	addw	a5,s2,-99
 7e2:	0ff7f713          	zext.b	a4,a5
 7e6:	12eb6163          	bltu	s6,a4,908 <vprintf+0x192>
 7ea:	00271793          	sll	a5,a4,0x2
 7ee:	00000717          	auipc	a4,0x0
 7f2:	39270713          	add	a4,a4,914 # b80 <malloc+0x158>
 7f6:	97ba                	add	a5,a5,a4
 7f8:	439c                	lw	a5,0(a5)
 7fa:	97ba                	add	a5,a5,a4
 7fc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 7fe:	008b8913          	add	s2,s7,8
 802:	4685                	li	a3,1
 804:	4629                	li	a2,10
 806:	000ba583          	lw	a1,0(s7)
 80a:	8556                	mv	a0,s5
 80c:	00000097          	auipc	ra,0x0
 810:	ebe080e7          	jalr	-322(ra) # 6ca <printint>
 814:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 816:	4981                	li	s3,0
 818:	b745                	j	7b8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 81a:	008b8913          	add	s2,s7,8
 81e:	4681                	li	a3,0
 820:	4629                	li	a2,10
 822:	000ba583          	lw	a1,0(s7)
 826:	8556                	mv	a0,s5
 828:	00000097          	auipc	ra,0x0
 82c:	ea2080e7          	jalr	-350(ra) # 6ca <printint>
 830:	8bca                	mv	s7,s2
      state = 0;
 832:	4981                	li	s3,0
 834:	b751                	j	7b8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 836:	008b8913          	add	s2,s7,8
 83a:	4681                	li	a3,0
 83c:	4641                	li	a2,16
 83e:	000ba583          	lw	a1,0(s7)
 842:	8556                	mv	a0,s5
 844:	00000097          	auipc	ra,0x0
 848:	e86080e7          	jalr	-378(ra) # 6ca <printint>
 84c:	8bca                	mv	s7,s2
      state = 0;
 84e:	4981                	li	s3,0
 850:	b7a5                	j	7b8 <vprintf+0x42>
 852:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 854:	008b8c13          	add	s8,s7,8
 858:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 85c:	03000593          	li	a1,48
 860:	8556                	mv	a0,s5
 862:	00000097          	auipc	ra,0x0
 866:	e46080e7          	jalr	-442(ra) # 6a8 <putc>
  putc(fd, 'x');
 86a:	07800593          	li	a1,120
 86e:	8556                	mv	a0,s5
 870:	00000097          	auipc	ra,0x0
 874:	e38080e7          	jalr	-456(ra) # 6a8 <putc>
 878:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 87a:	00000b97          	auipc	s7,0x0
 87e:	35eb8b93          	add	s7,s7,862 # bd8 <digits>
 882:	03c9d793          	srl	a5,s3,0x3c
 886:	97de                	add	a5,a5,s7
 888:	0007c583          	lbu	a1,0(a5)
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	e1a080e7          	jalr	-486(ra) # 6a8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 896:	0992                	sll	s3,s3,0x4
 898:	397d                	addw	s2,s2,-1
 89a:	fe0914e3          	bnez	s2,882 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 89e:	8be2                	mv	s7,s8
      state = 0;
 8a0:	4981                	li	s3,0
 8a2:	6c02                	ld	s8,0(sp)
 8a4:	bf11                	j	7b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 8a6:	008b8993          	add	s3,s7,8
 8aa:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 8ae:	02090163          	beqz	s2,8d0 <vprintf+0x15a>
        while(*s != 0){
 8b2:	00094583          	lbu	a1,0(s2)
 8b6:	c9a5                	beqz	a1,926 <vprintf+0x1b0>
          putc(fd, *s);
 8b8:	8556                	mv	a0,s5
 8ba:	00000097          	auipc	ra,0x0
 8be:	dee080e7          	jalr	-530(ra) # 6a8 <putc>
          s++;
 8c2:	0905                	add	s2,s2,1
        while(*s != 0){
 8c4:	00094583          	lbu	a1,0(s2)
 8c8:	f9e5                	bnez	a1,8b8 <vprintf+0x142>
        s = va_arg(ap, char*);
 8ca:	8bce                	mv	s7,s3
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b5ed                	j	7b8 <vprintf+0x42>
          s = "(null)";
 8d0:	00000917          	auipc	s2,0x0
 8d4:	2a890913          	add	s2,s2,680 # b78 <malloc+0x150>
        while(*s != 0){
 8d8:	02800593          	li	a1,40
 8dc:	bff1                	j	8b8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 8de:	008b8913          	add	s2,s7,8
 8e2:	000bc583          	lbu	a1,0(s7)
 8e6:	8556                	mv	a0,s5
 8e8:	00000097          	auipc	ra,0x0
 8ec:	dc0080e7          	jalr	-576(ra) # 6a8 <putc>
 8f0:	8bca                	mv	s7,s2
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	b5d1                	j	7b8 <vprintf+0x42>
        putc(fd, c);
 8f6:	02500593          	li	a1,37
 8fa:	8556                	mv	a0,s5
 8fc:	00000097          	auipc	ra,0x0
 900:	dac080e7          	jalr	-596(ra) # 6a8 <putc>
      state = 0;
 904:	4981                	li	s3,0
 906:	bd4d                	j	7b8 <vprintf+0x42>
        putc(fd, '%');
 908:	02500593          	li	a1,37
 90c:	8556                	mv	a0,s5
 90e:	00000097          	auipc	ra,0x0
 912:	d9a080e7          	jalr	-614(ra) # 6a8 <putc>
        putc(fd, c);
 916:	85ca                	mv	a1,s2
 918:	8556                	mv	a0,s5
 91a:	00000097          	auipc	ra,0x0
 91e:	d8e080e7          	jalr	-626(ra) # 6a8 <putc>
      state = 0;
 922:	4981                	li	s3,0
 924:	bd51                	j	7b8 <vprintf+0x42>
        s = va_arg(ap, char*);
 926:	8bce                	mv	s7,s3
      state = 0;
 928:	4981                	li	s3,0
 92a:	b579                	j	7b8 <vprintf+0x42>
 92c:	74e2                	ld	s1,56(sp)
 92e:	79a2                	ld	s3,40(sp)
 930:	7a02                	ld	s4,32(sp)
 932:	6ae2                	ld	s5,24(sp)
 934:	6b42                	ld	s6,16(sp)
 936:	6ba2                	ld	s7,8(sp)
    }
  }
}
 938:	60a6                	ld	ra,72(sp)
 93a:	6406                	ld	s0,64(sp)
 93c:	7942                	ld	s2,48(sp)
 93e:	6161                	add	sp,sp,80
 940:	8082                	ret

0000000000000942 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 942:	715d                	add	sp,sp,-80
 944:	ec06                	sd	ra,24(sp)
 946:	e822                	sd	s0,16(sp)
 948:	1000                	add	s0,sp,32
 94a:	e010                	sd	a2,0(s0)
 94c:	e414                	sd	a3,8(s0)
 94e:	e818                	sd	a4,16(s0)
 950:	ec1c                	sd	a5,24(s0)
 952:	03043023          	sd	a6,32(s0)
 956:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 95a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 95e:	8622                	mv	a2,s0
 960:	00000097          	auipc	ra,0x0
 964:	e16080e7          	jalr	-490(ra) # 776 <vprintf>
}
 968:	60e2                	ld	ra,24(sp)
 96a:	6442                	ld	s0,16(sp)
 96c:	6161                	add	sp,sp,80
 96e:	8082                	ret

0000000000000970 <printf>:

void
printf(const char *fmt, ...)
{
 970:	711d                	add	sp,sp,-96
 972:	ec06                	sd	ra,24(sp)
 974:	e822                	sd	s0,16(sp)
 976:	1000                	add	s0,sp,32
 978:	e40c                	sd	a1,8(s0)
 97a:	e810                	sd	a2,16(s0)
 97c:	ec14                	sd	a3,24(s0)
 97e:	f018                	sd	a4,32(s0)
 980:	f41c                	sd	a5,40(s0)
 982:	03043823          	sd	a6,48(s0)
 986:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 98a:	00840613          	add	a2,s0,8
 98e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 992:	85aa                	mv	a1,a0
 994:	4505                	li	a0,1
 996:	00000097          	auipc	ra,0x0
 99a:	de0080e7          	jalr	-544(ra) # 776 <vprintf>
}
 99e:	60e2                	ld	ra,24(sp)
 9a0:	6442                	ld	s0,16(sp)
 9a2:	6125                	add	sp,sp,96
 9a4:	8082                	ret

00000000000009a6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9a6:	1141                	add	sp,sp,-16
 9a8:	e422                	sd	s0,8(sp)
 9aa:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ac:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9b0:	00000797          	auipc	a5,0x0
 9b4:	6507b783          	ld	a5,1616(a5) # 1000 <freep>
 9b8:	a02d                	j	9e2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 9ba:	4618                	lw	a4,8(a2)
 9bc:	9f2d                	addw	a4,a4,a1
 9be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c2:	6398                	ld	a4,0(a5)
 9c4:	6310                	ld	a2,0(a4)
 9c6:	a83d                	j	a04 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 9c8:	ff852703          	lw	a4,-8(a0)
 9cc:	9f31                	addw	a4,a4,a2
 9ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9d0:	ff053683          	ld	a3,-16(a0)
 9d4:	a091                	j	a18 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9d6:	6398                	ld	a4,0(a5)
 9d8:	00e7e463          	bltu	a5,a4,9e0 <free+0x3a>
 9dc:	00e6ea63          	bltu	a3,a4,9f0 <free+0x4a>
{
 9e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e2:	fed7fae3          	bgeu	a5,a3,9d6 <free+0x30>
 9e6:	6398                	ld	a4,0(a5)
 9e8:	00e6e463          	bltu	a3,a4,9f0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9ec:	fee7eae3          	bltu	a5,a4,9e0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 9f0:	ff852583          	lw	a1,-8(a0)
 9f4:	6390                	ld	a2,0(a5)
 9f6:	02059813          	sll	a6,a1,0x20
 9fa:	01c85713          	srl	a4,a6,0x1c
 9fe:	9736                	add	a4,a4,a3
 a00:	fae60de3          	beq	a2,a4,9ba <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 a04:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 a08:	4790                	lw	a2,8(a5)
 a0a:	02061593          	sll	a1,a2,0x20
 a0e:	01c5d713          	srl	a4,a1,0x1c
 a12:	973e                	add	a4,a4,a5
 a14:	fae68ae3          	beq	a3,a4,9c8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 a18:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a1a:	00000717          	auipc	a4,0x0
 a1e:	5ef73323          	sd	a5,1510(a4) # 1000 <freep>
}
 a22:	6422                	ld	s0,8(sp)
 a24:	0141                	add	sp,sp,16
 a26:	8082                	ret

0000000000000a28 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a28:	7139                	add	sp,sp,-64
 a2a:	fc06                	sd	ra,56(sp)
 a2c:	f822                	sd	s0,48(sp)
 a2e:	f426                	sd	s1,40(sp)
 a30:	ec4e                	sd	s3,24(sp)
 a32:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a34:	02051493          	sll	s1,a0,0x20
 a38:	9081                	srl	s1,s1,0x20
 a3a:	04bd                	add	s1,s1,15
 a3c:	8091                	srl	s1,s1,0x4
 a3e:	0014899b          	addw	s3,s1,1
 a42:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 a44:	00000517          	auipc	a0,0x0
 a48:	5bc53503          	ld	a0,1468(a0) # 1000 <freep>
 a4c:	c915                	beqz	a0,a80 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a50:	4798                	lw	a4,8(a5)
 a52:	08977e63          	bgeu	a4,s1,aee <malloc+0xc6>
 a56:	f04a                	sd	s2,32(sp)
 a58:	e852                	sd	s4,16(sp)
 a5a:	e456                	sd	s5,8(sp)
 a5c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a5e:	8a4e                	mv	s4,s3
 a60:	0009871b          	sext.w	a4,s3
 a64:	6685                	lui	a3,0x1
 a66:	00d77363          	bgeu	a4,a3,a6c <malloc+0x44>
 a6a:	6a05                	lui	s4,0x1
 a6c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a70:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a74:	00000917          	auipc	s2,0x0
 a78:	58c90913          	add	s2,s2,1420 # 1000 <freep>
  if(p == (char*)-1)
 a7c:	5afd                	li	s5,-1
 a7e:	a091                	j	ac2 <malloc+0x9a>
 a80:	f04a                	sd	s2,32(sp)
 a82:	e852                	sd	s4,16(sp)
 a84:	e456                	sd	s5,8(sp)
 a86:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a88:	00000797          	auipc	a5,0x0
 a8c:	58878793          	add	a5,a5,1416 # 1010 <base>
 a90:	00000717          	auipc	a4,0x0
 a94:	56f73823          	sd	a5,1392(a4) # 1000 <freep>
 a98:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a9a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a9e:	b7c1                	j	a5e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 aa0:	6398                	ld	a4,0(a5)
 aa2:	e118                	sd	a4,0(a0)
 aa4:	a08d                	j	b06 <malloc+0xde>
  hp->s.size = nu;
 aa6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 aaa:	0541                	add	a0,a0,16
 aac:	00000097          	auipc	ra,0x0
 ab0:	efa080e7          	jalr	-262(ra) # 9a6 <free>
  return freep;
 ab4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 ab8:	c13d                	beqz	a0,b1e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 aba:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 abc:	4798                	lw	a4,8(a5)
 abe:	02977463          	bgeu	a4,s1,ae6 <malloc+0xbe>
    if(p == freep)
 ac2:	00093703          	ld	a4,0(s2)
 ac6:	853e                	mv	a0,a5
 ac8:	fef719e3          	bne	a4,a5,aba <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 acc:	8552                	mv	a0,s4
 ace:	00000097          	auipc	ra,0x0
 ad2:	ba2080e7          	jalr	-1118(ra) # 670 <sbrk>
  if(p == (char*)-1)
 ad6:	fd5518e3          	bne	a0,s5,aa6 <malloc+0x7e>
        return 0;
 ada:	4501                	li	a0,0
 adc:	7902                	ld	s2,32(sp)
 ade:	6a42                	ld	s4,16(sp)
 ae0:	6aa2                	ld	s5,8(sp)
 ae2:	6b02                	ld	s6,0(sp)
 ae4:	a03d                	j	b12 <malloc+0xea>
 ae6:	7902                	ld	s2,32(sp)
 ae8:	6a42                	ld	s4,16(sp)
 aea:	6aa2                	ld	s5,8(sp)
 aec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 aee:	fae489e3          	beq	s1,a4,aa0 <malloc+0x78>
        p->s.size -= nunits;
 af2:	4137073b          	subw	a4,a4,s3
 af6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 af8:	02071693          	sll	a3,a4,0x20
 afc:	01c6d713          	srl	a4,a3,0x1c
 b00:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b02:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b06:	00000717          	auipc	a4,0x0
 b0a:	4ea73d23          	sd	a0,1274(a4) # 1000 <freep>
      return (void*)(p + 1);
 b0e:	01078513          	add	a0,a5,16
  }
}
 b12:	70e2                	ld	ra,56(sp)
 b14:	7442                	ld	s0,48(sp)
 b16:	74a2                	ld	s1,40(sp)
 b18:	69e2                	ld	s3,24(sp)
 b1a:	6121                	add	sp,sp,64
 b1c:	8082                	ret
 b1e:	7902                	ld	s2,32(sp)
 b20:	6a42                	ld	s4,16(sp)
 b22:	6aa2                	ld	s5,8(sp)
 b24:	6b02                	ld	s6,0(sp)
 b26:	b7f5                	j	b12 <malloc+0xea>
