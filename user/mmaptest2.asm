
user/_mmaptest2:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

void
main(int argc, char *argv[])
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	0080                	add	s0,sp,64
  uint64 p = (uint64) 0x100000000ULL;


  mmap((void *)p, 513, PROT_WRITE, MAP_SHARED);
   8:	02000693          	li	a3,32
   c:	4609                	li	a2,2
   e:	20100593          	li	a1,513
  12:	4505                	li	a0,1
  14:	1502                	sll	a0,a0,0x20
  16:	00000097          	auipc	ra,0x0
  1a:	4f4080e7          	jalr	1268(ra) # 50a <mmap>
  //munmap((void *)p);

  *(int *)p = 0xdeadbeef;
  1e:	4785                	li	a5,1
  20:	1782                	sll	a5,a5,0x20
  22:	deadc737          	lui	a4,0xdeadc
  26:	eef70713          	add	a4,a4,-273 # ffffffffdeadbeef <base+0xffffffffdeadaedf>
  2a:	c398                	sw	a4,0(a5)


  char *echoargv[] = { "echo", "OK", 0 };
  2c:	00001517          	auipc	a0,0x1
  30:	97450513          	add	a0,a0,-1676 # 9a0 <malloc+0x106>
  34:	fca43423          	sd	a0,-56(s0)
  38:	00001797          	auipc	a5,0x1
  3c:	97878793          	add	a5,a5,-1672 # 9b0 <malloc+0x116>
  40:	fcf43823          	sd	a5,-48(s0)
  44:	fc043c23          	sd	zero,-40(s0)
  exec("echo", echoargv);
  48:	fc840593          	add	a1,s0,-56
  4c:	00000097          	auipc	ra,0x0
  50:	446080e7          	jalr	1094(ra) # 492 <exec>


    if (fork() == 0)
  54:	00000097          	auipc	ra,0x0
  58:	3fe080e7          	jalr	1022(ra) # 452 <fork>
  5c:	e16d                	bnez	a0,13e <main+0x13e>
  5e:	f426                	sd	s1,40(sp)
  60:	f04a                	sd	s2,32(sp)
  {
    //munmap((void *)p);
    //mmap((void *)p, 100, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE);

    printf("pid %d: %x\n", getpid(), *(int *)p);
  62:	00000097          	auipc	ra,0x0
  66:	478080e7          	jalr	1144(ra) # 4da <getpid>
  6a:	85aa                	mv	a1,a0
  6c:	4485                	li	s1,1
  6e:	1482                	sll	s1,s1,0x20
  70:	4090                	lw	a2,0(s1)
  72:	00001517          	auipc	a0,0x1
  76:	94650513          	add	a0,a0,-1722 # 9b8 <malloc+0x11e>
  7a:	00000097          	auipc	ra,0x0
  7e:	768080e7          	jalr	1896(ra) # 7e2 <printf>
    *(int *)p = 0x900dbeef;
  82:	900dc7b7          	lui	a5,0x900dc
  86:	eef78793          	add	a5,a5,-273 # ffffffff900dbeef <base+0xffffffff900daedf>
  8a:	c09c                	sw	a5,0(s1)



    printf("pid %d: %x\n", getpid(), *(int *)p);
  8c:	00000097          	auipc	ra,0x0
  90:	44e080e7          	jalr	1102(ra) # 4da <getpid>
  94:	85aa                	mv	a1,a0
  96:	4090                	lw	a2,0(s1)
  98:	00001517          	auipc	a0,0x1
  9c:	92050513          	add	a0,a0,-1760 # 9b8 <malloc+0x11e>
  a0:	00000097          	auipc	ra,0x0
  a4:	742080e7          	jalr	1858(ra) # 7e2 <printf>
    *(int *)(p+4096) = 0xbeefbeef;
  a8:	001004b7          	lui	s1,0x100
  ac:	0485                	add	s1,s1,1 # 100001 <base+0xfeff1>
  ae:	04b2                	sll	s1,s1,0xc
  b0:	beefc7b7          	lui	a5,0xbeefc
  b4:	eef78793          	add	a5,a5,-273 # ffffffffbeefbeef <base+0xffffffffbeefaedf>
  b8:	c09c                	sw	a5,0(s1)
    *(int *)(p+4096*2) = 0x33333333;
  ba:	000807b7          	lui	a5,0x80
  be:	0785                	add	a5,a5,1 # 80001 <base+0x7eff1>
  c0:	07b6                	sll	a5,a5,0xd
  c2:	33333737          	lui	a4,0x33333
  c6:	33370713          	add	a4,a4,819 # 33333333 <base+0x33332323>
  ca:	c398                	sw	a4,0(a5)

    printf("pid %d: %x\n", getpid(), *(int *)(p+4096));
  cc:	00000097          	auipc	ra,0x0
  d0:	40e080e7          	jalr	1038(ra) # 4da <getpid>
  d4:	85aa                	mv	a1,a0
  d6:	4090                	lw	a2,0(s1)
  d8:	00001517          	auipc	a0,0x1
  dc:	8e050513          	add	a0,a0,-1824 # 9b8 <malloc+0x11e>
  e0:	00000097          	auipc	ra,0x0
  e4:	702080e7          	jalr	1794(ra) # 7e2 <printf>


    *(int *)(p+4096*512) = 0x44444444;
  e8:	00801937          	lui	s2,0x801
  ec:	0926                	sll	s2,s2,0x9
  ee:	444447b7          	lui	a5,0x44444
  f2:	44478793          	add	a5,a5,1092 # 44444444 <base+0x44443434>
  f6:	00f92023          	sw	a5,0(s2) # 801000 <base+0x7ffff0>
  
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096));
  fa:	00000097          	auipc	ra,0x0
  fe:	3e0080e7          	jalr	992(ra) # 4da <getpid>
 102:	85aa                	mv	a1,a0
 104:	4090                	lw	a2,0(s1)
 106:	00001517          	auipc	a0,0x1
 10a:	8b250513          	add	a0,a0,-1870 # 9b8 <malloc+0x11e>
 10e:	00000097          	auipc	ra,0x0
 112:	6d4080e7          	jalr	1748(ra) # 7e2 <printf>
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096*512));
 116:	00000097          	auipc	ra,0x0
 11a:	3c4080e7          	jalr	964(ra) # 4da <getpid>
 11e:	85aa                	mv	a1,a0
 120:	00092603          	lw	a2,0(s2)
 124:	00001517          	auipc	a0,0x1
 128:	89450513          	add	a0,a0,-1900 # 9b8 <malloc+0x11e>
 12c:	00000097          	auipc	ra,0x0
 130:	6b6080e7          	jalr	1718(ra) # 7e2 <printf>

    exit(0);
 134:	4501                	li	a0,0
 136:	00000097          	auipc	ra,0x0
 13a:	324080e7          	jalr	804(ra) # 45a <exit>
 13e:	f426                	sd	s1,40(sp)
 140:	f04a                	sd	s2,32(sp)
  }
    wait(0);
 142:	4501                	li	a0,0
 144:	00000097          	auipc	ra,0x0
 148:	31e080e7          	jalr	798(ra) # 462 <wait>
    printf("pid %d: %x\n", getpid(), *(int *)p);
 14c:	00000097          	auipc	ra,0x0
 150:	38e080e7          	jalr	910(ra) # 4da <getpid>
 154:	85aa                	mv	a1,a0
 156:	4785                	li	a5,1
 158:	1782                	sll	a5,a5,0x20
 15a:	4390                	lw	a2,0(a5)
 15c:	00001517          	auipc	a0,0x1
 160:	85c50513          	add	a0,a0,-1956 # 9b8 <malloc+0x11e>
 164:	00000097          	auipc	ra,0x0
 168:	67e080e7          	jalr	1662(ra) # 7e2 <printf>
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096));
 16c:	00000097          	auipc	ra,0x0
 170:	36e080e7          	jalr	878(ra) # 4da <getpid>
 174:	85aa                	mv	a1,a0
 176:	001007b7          	lui	a5,0x100
 17a:	0785                	add	a5,a5,1 # 100001 <base+0xfeff1>
 17c:	07b2                	sll	a5,a5,0xc
 17e:	4390                	lw	a2,0(a5)
 180:	00001517          	auipc	a0,0x1
 184:	83850513          	add	a0,a0,-1992 # 9b8 <malloc+0x11e>
 188:	00000097          	auipc	ra,0x0
 18c:	65a080e7          	jalr	1626(ra) # 7e2 <printf>
    printf("pid %d: %x\n", getpid(), *(int *)(p+4096*512));
 190:	00000097          	auipc	ra,0x0
 194:	34a080e7          	jalr	842(ra) # 4da <getpid>
 198:	85aa                	mv	a1,a0
 19a:	008017b7          	lui	a5,0x801
 19e:	07a6                	sll	a5,a5,0x9
 1a0:	4390                	lw	a2,0(a5)
 1a2:	00001517          	auipc	a0,0x1
 1a6:	81650513          	add	a0,a0,-2026 # 9b8 <malloc+0x11e>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	638080e7          	jalr	1592(ra) # 7e2 <printf>
  // }

  // wait(0);
  // printf("pid %d: %x\n", getpid(), *(int *)p);
  // //munmap((void *)p);
  exit(0);
 1b2:	4501                	li	a0,0
 1b4:	00000097          	auipc	ra,0x0
 1b8:	2a6080e7          	jalr	678(ra) # 45a <exit>

00000000000001bc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1bc:	1141                	add	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	add	s0,sp,16
  extern int main();
  main();
 1c4:	00000097          	auipc	ra,0x0
 1c8:	e3c080e7          	jalr	-452(ra) # 0 <main>
  exit(0);
 1cc:	4501                	li	a0,0
 1ce:	00000097          	auipc	ra,0x0
 1d2:	28c080e7          	jalr	652(ra) # 45a <exit>

00000000000001d6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1d6:	1141                	add	sp,sp,-16
 1d8:	e422                	sd	s0,8(sp)
 1da:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1dc:	87aa                	mv	a5,a0
 1de:	0585                	add	a1,a1,1
 1e0:	0785                	add	a5,a5,1 # 801001 <base+0x7ffff1>
 1e2:	fff5c703          	lbu	a4,-1(a1)
 1e6:	fee78fa3          	sb	a4,-1(a5)
 1ea:	fb75                	bnez	a4,1de <strcpy+0x8>
    ;
  return os;
}
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	add	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f2:	1141                	add	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cb91                	beqz	a5,210 <strcmp+0x1e>
 1fe:	0005c703          	lbu	a4,0(a1)
 202:	00f71763          	bne	a4,a5,210 <strcmp+0x1e>
    p++, q++;
 206:	0505                	add	a0,a0,1
 208:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	fbe5                	bnez	a5,1fe <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 210:	0005c503          	lbu	a0,0(a1)
}
 214:	40a7853b          	subw	a0,a5,a0
 218:	6422                	ld	s0,8(sp)
 21a:	0141                	add	sp,sp,16
 21c:	8082                	ret

000000000000021e <strlen>:

uint
strlen(const char *s)
{
 21e:	1141                	add	sp,sp,-16
 220:	e422                	sd	s0,8(sp)
 222:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 224:	00054783          	lbu	a5,0(a0)
 228:	cf91                	beqz	a5,244 <strlen+0x26>
 22a:	0505                	add	a0,a0,1
 22c:	87aa                	mv	a5,a0
 22e:	86be                	mv	a3,a5
 230:	0785                	add	a5,a5,1
 232:	fff7c703          	lbu	a4,-1(a5)
 236:	ff65                	bnez	a4,22e <strlen+0x10>
 238:	40a6853b          	subw	a0,a3,a0
 23c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	add	sp,sp,16
 242:	8082                	ret
  for(n = 0; s[n]; n++)
 244:	4501                	li	a0,0
 246:	bfe5                	j	23e <strlen+0x20>

0000000000000248 <memset>:

void*
memset(void *dst, int c, uint n)
{
 248:	1141                	add	sp,sp,-16
 24a:	e422                	sd	s0,8(sp)
 24c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 24e:	ca19                	beqz	a2,264 <memset+0x1c>
 250:	87aa                	mv	a5,a0
 252:	1602                	sll	a2,a2,0x20
 254:	9201                	srl	a2,a2,0x20
 256:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 25a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 25e:	0785                	add	a5,a5,1
 260:	fee79de3          	bne	a5,a4,25a <memset+0x12>
  }
  return dst;
}
 264:	6422                	ld	s0,8(sp)
 266:	0141                	add	sp,sp,16
 268:	8082                	ret

000000000000026a <strchr>:

char*
strchr(const char *s, char c)
{
 26a:	1141                	add	sp,sp,-16
 26c:	e422                	sd	s0,8(sp)
 26e:	0800                	add	s0,sp,16
  for(; *s; s++)
 270:	00054783          	lbu	a5,0(a0)
 274:	cb99                	beqz	a5,28a <strchr+0x20>
    if(*s == c)
 276:	00f58763          	beq	a1,a5,284 <strchr+0x1a>
  for(; *s; s++)
 27a:	0505                	add	a0,a0,1
 27c:	00054783          	lbu	a5,0(a0)
 280:	fbfd                	bnez	a5,276 <strchr+0xc>
      return (char*)s;
  return 0;
 282:	4501                	li	a0,0
}
 284:	6422                	ld	s0,8(sp)
 286:	0141                	add	sp,sp,16
 288:	8082                	ret
  return 0;
 28a:	4501                	li	a0,0
 28c:	bfe5                	j	284 <strchr+0x1a>

000000000000028e <gets>:

char*
gets(char *buf, int max)
{
 28e:	711d                	add	sp,sp,-96
 290:	ec86                	sd	ra,88(sp)
 292:	e8a2                	sd	s0,80(sp)
 294:	e4a6                	sd	s1,72(sp)
 296:	e0ca                	sd	s2,64(sp)
 298:	fc4e                	sd	s3,56(sp)
 29a:	f852                	sd	s4,48(sp)
 29c:	f456                	sd	s5,40(sp)
 29e:	f05a                	sd	s6,32(sp)
 2a0:	ec5e                	sd	s7,24(sp)
 2a2:	1080                	add	s0,sp,96
 2a4:	8baa                	mv	s7,a0
 2a6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2a8:	892a                	mv	s2,a0
 2aa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ac:	4aa9                	li	s5,10
 2ae:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2b0:	89a6                	mv	s3,s1
 2b2:	2485                	addw	s1,s1,1
 2b4:	0344d863          	bge	s1,s4,2e4 <gets+0x56>
    cc = read(0, &c, 1);
 2b8:	4605                	li	a2,1
 2ba:	faf40593          	add	a1,s0,-81
 2be:	4501                	li	a0,0
 2c0:	00000097          	auipc	ra,0x0
 2c4:	1b2080e7          	jalr	434(ra) # 472 <read>
    if(cc < 1)
 2c8:	00a05e63          	blez	a0,2e4 <gets+0x56>
    buf[i++] = c;
 2cc:	faf44783          	lbu	a5,-81(s0)
 2d0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d4:	01578763          	beq	a5,s5,2e2 <gets+0x54>
 2d8:	0905                	add	s2,s2,1
 2da:	fd679be3          	bne	a5,s6,2b0 <gets+0x22>
    buf[i++] = c;
 2de:	89a6                	mv	s3,s1
 2e0:	a011                	j	2e4 <gets+0x56>
 2e2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2e4:	99de                	add	s3,s3,s7
 2e6:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ea:	855e                	mv	a0,s7
 2ec:	60e6                	ld	ra,88(sp)
 2ee:	6446                	ld	s0,80(sp)
 2f0:	64a6                	ld	s1,72(sp)
 2f2:	6906                	ld	s2,64(sp)
 2f4:	79e2                	ld	s3,56(sp)
 2f6:	7a42                	ld	s4,48(sp)
 2f8:	7aa2                	ld	s5,40(sp)
 2fa:	7b02                	ld	s6,32(sp)
 2fc:	6be2                	ld	s7,24(sp)
 2fe:	6125                	add	sp,sp,96
 300:	8082                	ret

0000000000000302 <stat>:

int
stat(const char *n, struct stat *st)
{
 302:	1101                	add	sp,sp,-32
 304:	ec06                	sd	ra,24(sp)
 306:	e822                	sd	s0,16(sp)
 308:	e04a                	sd	s2,0(sp)
 30a:	1000                	add	s0,sp,32
 30c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 30e:	4581                	li	a1,0
 310:	00000097          	auipc	ra,0x0
 314:	18a080e7          	jalr	394(ra) # 49a <open>
  if(fd < 0)
 318:	02054663          	bltz	a0,344 <stat+0x42>
 31c:	e426                	sd	s1,8(sp)
 31e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 320:	85ca                	mv	a1,s2
 322:	00000097          	auipc	ra,0x0
 326:	190080e7          	jalr	400(ra) # 4b2 <fstat>
 32a:	892a                	mv	s2,a0
  close(fd);
 32c:	8526                	mv	a0,s1
 32e:	00000097          	auipc	ra,0x0
 332:	154080e7          	jalr	340(ra) # 482 <close>
  return r;
 336:	64a2                	ld	s1,8(sp)
}
 338:	854a                	mv	a0,s2
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	6902                	ld	s2,0(sp)
 340:	6105                	add	sp,sp,32
 342:	8082                	ret
    return -1;
 344:	597d                	li	s2,-1
 346:	bfcd                	j	338 <stat+0x36>

0000000000000348 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 348:	1141                	add	sp,sp,-16
 34a:	e422                	sd	s0,8(sp)
 34c:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 34e:	00054703          	lbu	a4,0(a0)
 352:	02d00793          	li	a5,45
 356:	4585                	li	a1,1
 358:	04f70363          	beq	a4,a5,39e <atoi+0x56>

  while('0' <= *s && *s <= '9')
 35c:	00054703          	lbu	a4,0(a0)
 360:	fd07079b          	addw	a5,a4,-48
 364:	0ff7f793          	zext.b	a5,a5
 368:	46a5                	li	a3,9
 36a:	02f6ed63          	bltu	a3,a5,3a4 <atoi+0x5c>
  int n = 0;
 36e:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 370:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 372:	0505                	add	a0,a0,1
 374:	0026979b          	sllw	a5,a3,0x2
 378:	9fb5                	addw	a5,a5,a3
 37a:	0017979b          	sllw	a5,a5,0x1
 37e:	9fb9                	addw	a5,a5,a4
 380:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 384:	00054703          	lbu	a4,0(a0)
 388:	fd07079b          	addw	a5,a4,-48
 38c:	0ff7f793          	zext.b	a5,a5
 390:	fef671e3          	bgeu	a2,a5,372 <atoi+0x2a>
  return sign * n;
}
 394:	02d5853b          	mulw	a0,a1,a3
 398:	6422                	ld	s0,8(sp)
 39a:	0141                	add	sp,sp,16
 39c:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 39e:	0505                	add	a0,a0,1
 3a0:	55fd                	li	a1,-1
 3a2:	bf6d                	j	35c <atoi+0x14>
  int n = 0;
 3a4:	4681                	li	a3,0
 3a6:	b7fd                	j	394 <atoi+0x4c>

00000000000003a8 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a8:	1141                	add	sp,sp,-16
 3aa:	e422                	sd	s0,8(sp)
 3ac:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ae:	02b57463          	bgeu	a0,a1,3d6 <memmove+0x2e>
    while(n-- > 0)
 3b2:	00c05f63          	blez	a2,3d0 <memmove+0x28>
 3b6:	1602                	sll	a2,a2,0x20
 3b8:	9201                	srl	a2,a2,0x20
 3ba:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3be:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c0:	0585                	add	a1,a1,1
 3c2:	0705                	add	a4,a4,1
 3c4:	fff5c683          	lbu	a3,-1(a1)
 3c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3cc:	fef71ae3          	bne	a4,a5,3c0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d0:	6422                	ld	s0,8(sp)
 3d2:	0141                	add	sp,sp,16
 3d4:	8082                	ret
    dst += n;
 3d6:	00c50733          	add	a4,a0,a2
    src += n;
 3da:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3dc:	fec05ae3          	blez	a2,3d0 <memmove+0x28>
 3e0:	fff6079b          	addw	a5,a2,-1
 3e4:	1782                	sll	a5,a5,0x20
 3e6:	9381                	srl	a5,a5,0x20
 3e8:	fff7c793          	not	a5,a5
 3ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3ee:	15fd                	add	a1,a1,-1
 3f0:	177d                	add	a4,a4,-1
 3f2:	0005c683          	lbu	a3,0(a1)
 3f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3fa:	fee79ae3          	bne	a5,a4,3ee <memmove+0x46>
 3fe:	bfc9                	j	3d0 <memmove+0x28>

0000000000000400 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 400:	1141                	add	sp,sp,-16
 402:	e422                	sd	s0,8(sp)
 404:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 406:	ca05                	beqz	a2,436 <memcmp+0x36>
 408:	fff6069b          	addw	a3,a2,-1
 40c:	1682                	sll	a3,a3,0x20
 40e:	9281                	srl	a3,a3,0x20
 410:	0685                	add	a3,a3,1
 412:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 414:	00054783          	lbu	a5,0(a0)
 418:	0005c703          	lbu	a4,0(a1)
 41c:	00e79863          	bne	a5,a4,42c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 420:	0505                	add	a0,a0,1
    p2++;
 422:	0585                	add	a1,a1,1
  while (n-- > 0) {
 424:	fed518e3          	bne	a0,a3,414 <memcmp+0x14>
  }
  return 0;
 428:	4501                	li	a0,0
 42a:	a019                	j	430 <memcmp+0x30>
      return *p1 - *p2;
 42c:	40e7853b          	subw	a0,a5,a4
}
 430:	6422                	ld	s0,8(sp)
 432:	0141                	add	sp,sp,16
 434:	8082                	ret
  return 0;
 436:	4501                	li	a0,0
 438:	bfe5                	j	430 <memcmp+0x30>

000000000000043a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 43a:	1141                	add	sp,sp,-16
 43c:	e406                	sd	ra,8(sp)
 43e:	e022                	sd	s0,0(sp)
 440:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 442:	00000097          	auipc	ra,0x0
 446:	f66080e7          	jalr	-154(ra) # 3a8 <memmove>
}
 44a:	60a2                	ld	ra,8(sp)
 44c:	6402                	ld	s0,0(sp)
 44e:	0141                	add	sp,sp,16
 450:	8082                	ret

0000000000000452 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 452:	4885                	li	a7,1
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <exit>:
.global exit
exit:
 li a7, SYS_exit
 45a:	4889                	li	a7,2
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <wait>:
.global wait
wait:
 li a7, SYS_wait
 462:	488d                	li	a7,3
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 46a:	4891                	li	a7,4
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <read>:
.global read
read:
 li a7, SYS_read
 472:	4895                	li	a7,5
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <write>:
.global write
write:
 li a7, SYS_write
 47a:	48c1                	li	a7,16
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <close>:
.global close
close:
 li a7, SYS_close
 482:	48d5                	li	a7,21
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <kill>:
.global kill
kill:
 li a7, SYS_kill
 48a:	4899                	li	a7,6
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <exec>:
.global exec
exec:
 li a7, SYS_exec
 492:	489d                	li	a7,7
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <open>:
.global open
open:
 li a7, SYS_open
 49a:	48bd                	li	a7,15
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4a2:	48c5                	li	a7,17
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4aa:	48c9                	li	a7,18
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4b2:	48a1                	li	a7,8
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <link>:
.global link
link:
 li a7, SYS_link
 4ba:	48cd                	li	a7,19
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4c2:	48d1                	li	a7,20
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ca:	48a5                	li	a7,9
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4d2:	48a9                	li	a7,10
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4da:	48ad                	li	a7,11
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4e2:	48b1                	li	a7,12
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4ea:	48b5                	li	a7,13
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4f2:	48b9                	li	a7,14
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 4fa:	48d9                	li	a7,22
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 502:	48dd                	li	a7,23
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 50a:	48e1                	li	a7,24
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 512:	48e5                	li	a7,25
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 51a:	1101                	add	sp,sp,-32
 51c:	ec06                	sd	ra,24(sp)
 51e:	e822                	sd	s0,16(sp)
 520:	1000                	add	s0,sp,32
 522:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 526:	4605                	li	a2,1
 528:	fef40593          	add	a1,s0,-17
 52c:	00000097          	auipc	ra,0x0
 530:	f4e080e7          	jalr	-178(ra) # 47a <write>
}
 534:	60e2                	ld	ra,24(sp)
 536:	6442                	ld	s0,16(sp)
 538:	6105                	add	sp,sp,32
 53a:	8082                	ret

000000000000053c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 53c:	7139                	add	sp,sp,-64
 53e:	fc06                	sd	ra,56(sp)
 540:	f822                	sd	s0,48(sp)
 542:	f426                	sd	s1,40(sp)
 544:	0080                	add	s0,sp,64
 546:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 548:	c299                	beqz	a3,54e <printint+0x12>
 54a:	0805cb63          	bltz	a1,5e0 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 54e:	2581                	sext.w	a1,a1
  neg = 0;
 550:	4881                	li	a7,0
 552:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 556:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 558:	2601                	sext.w	a2,a2
 55a:	00000517          	auipc	a0,0x0
 55e:	4ce50513          	add	a0,a0,1230 # a28 <digits>
 562:	883a                	mv	a6,a4
 564:	2705                	addw	a4,a4,1
 566:	02c5f7bb          	remuw	a5,a1,a2
 56a:	1782                	sll	a5,a5,0x20
 56c:	9381                	srl	a5,a5,0x20
 56e:	97aa                	add	a5,a5,a0
 570:	0007c783          	lbu	a5,0(a5)
 574:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 578:	0005879b          	sext.w	a5,a1
 57c:	02c5d5bb          	divuw	a1,a1,a2
 580:	0685                	add	a3,a3,1
 582:	fec7f0e3          	bgeu	a5,a2,562 <printint+0x26>
  if(neg)
 586:	00088c63          	beqz	a7,59e <printint+0x62>
    buf[i++] = '-';
 58a:	fd070793          	add	a5,a4,-48
 58e:	00878733          	add	a4,a5,s0
 592:	02d00793          	li	a5,45
 596:	fef70823          	sb	a5,-16(a4)
 59a:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 59e:	02e05c63          	blez	a4,5d6 <printint+0x9a>
 5a2:	f04a                	sd	s2,32(sp)
 5a4:	ec4e                	sd	s3,24(sp)
 5a6:	fc040793          	add	a5,s0,-64
 5aa:	00e78933          	add	s2,a5,a4
 5ae:	fff78993          	add	s3,a5,-1
 5b2:	99ba                	add	s3,s3,a4
 5b4:	377d                	addw	a4,a4,-1
 5b6:	1702                	sll	a4,a4,0x20
 5b8:	9301                	srl	a4,a4,0x20
 5ba:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5be:	fff94583          	lbu	a1,-1(s2)
 5c2:	8526                	mv	a0,s1
 5c4:	00000097          	auipc	ra,0x0
 5c8:	f56080e7          	jalr	-170(ra) # 51a <putc>
  while(--i >= 0)
 5cc:	197d                	add	s2,s2,-1
 5ce:	ff3918e3          	bne	s2,s3,5be <printint+0x82>
 5d2:	7902                	ld	s2,32(sp)
 5d4:	69e2                	ld	s3,24(sp)
}
 5d6:	70e2                	ld	ra,56(sp)
 5d8:	7442                	ld	s0,48(sp)
 5da:	74a2                	ld	s1,40(sp)
 5dc:	6121                	add	sp,sp,64
 5de:	8082                	ret
    x = -xx;
 5e0:	40b005bb          	negw	a1,a1
    neg = 1;
 5e4:	4885                	li	a7,1
    x = -xx;
 5e6:	b7b5                	j	552 <printint+0x16>

00000000000005e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e8:	715d                	add	sp,sp,-80
 5ea:	e486                	sd	ra,72(sp)
 5ec:	e0a2                	sd	s0,64(sp)
 5ee:	f84a                	sd	s2,48(sp)
 5f0:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f2:	0005c903          	lbu	s2,0(a1)
 5f6:	1a090a63          	beqz	s2,7aa <vprintf+0x1c2>
 5fa:	fc26                	sd	s1,56(sp)
 5fc:	f44e                	sd	s3,40(sp)
 5fe:	f052                	sd	s4,32(sp)
 600:	ec56                	sd	s5,24(sp)
 602:	e85a                	sd	s6,16(sp)
 604:	e45e                	sd	s7,8(sp)
 606:	8aaa                	mv	s5,a0
 608:	8bb2                	mv	s7,a2
 60a:	00158493          	add	s1,a1,1
  state = 0;
 60e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 610:	02500a13          	li	s4,37
 614:	4b55                	li	s6,21
 616:	a839                	j	634 <vprintf+0x4c>
        putc(fd, c);
 618:	85ca                	mv	a1,s2
 61a:	8556                	mv	a0,s5
 61c:	00000097          	auipc	ra,0x0
 620:	efe080e7          	jalr	-258(ra) # 51a <putc>
 624:	a019                	j	62a <vprintf+0x42>
    } else if(state == '%'){
 626:	01498d63          	beq	s3,s4,640 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 62a:	0485                	add	s1,s1,1
 62c:	fff4c903          	lbu	s2,-1(s1)
 630:	16090763          	beqz	s2,79e <vprintf+0x1b6>
    if(state == 0){
 634:	fe0999e3          	bnez	s3,626 <vprintf+0x3e>
      if(c == '%'){
 638:	ff4910e3          	bne	s2,s4,618 <vprintf+0x30>
        state = '%';
 63c:	89d2                	mv	s3,s4
 63e:	b7f5                	j	62a <vprintf+0x42>
      if(c == 'd'){
 640:	13490463          	beq	s2,s4,768 <vprintf+0x180>
 644:	f9d9079b          	addw	a5,s2,-99
 648:	0ff7f793          	zext.b	a5,a5
 64c:	12fb6763          	bltu	s6,a5,77a <vprintf+0x192>
 650:	f9d9079b          	addw	a5,s2,-99
 654:	0ff7f713          	zext.b	a4,a5
 658:	12eb6163          	bltu	s6,a4,77a <vprintf+0x192>
 65c:	00271793          	sll	a5,a4,0x2
 660:	00000717          	auipc	a4,0x0
 664:	37070713          	add	a4,a4,880 # 9d0 <malloc+0x136>
 668:	97ba                	add	a5,a5,a4
 66a:	439c                	lw	a5,0(a5)
 66c:	97ba                	add	a5,a5,a4
 66e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 670:	008b8913          	add	s2,s7,8
 674:	4685                	li	a3,1
 676:	4629                	li	a2,10
 678:	000ba583          	lw	a1,0(s7)
 67c:	8556                	mv	a0,s5
 67e:	00000097          	auipc	ra,0x0
 682:	ebe080e7          	jalr	-322(ra) # 53c <printint>
 686:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 688:	4981                	li	s3,0
 68a:	b745                	j	62a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 68c:	008b8913          	add	s2,s7,8
 690:	4681                	li	a3,0
 692:	4629                	li	a2,10
 694:	000ba583          	lw	a1,0(s7)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	ea2080e7          	jalr	-350(ra) # 53c <printint>
 6a2:	8bca                	mv	s7,s2
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b751                	j	62a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 6a8:	008b8913          	add	s2,s7,8
 6ac:	4681                	li	a3,0
 6ae:	4641                	li	a2,16
 6b0:	000ba583          	lw	a1,0(s7)
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e86080e7          	jalr	-378(ra) # 53c <printint>
 6be:	8bca                	mv	s7,s2
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b7a5                	j	62a <vprintf+0x42>
 6c4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6c6:	008b8c13          	add	s8,s7,8
 6ca:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ce:	03000593          	li	a1,48
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e46080e7          	jalr	-442(ra) # 51a <putc>
  putc(fd, 'x');
 6dc:	07800593          	li	a1,120
 6e0:	8556                	mv	a0,s5
 6e2:	00000097          	auipc	ra,0x0
 6e6:	e38080e7          	jalr	-456(ra) # 51a <putc>
 6ea:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ec:	00000b97          	auipc	s7,0x0
 6f0:	33cb8b93          	add	s7,s7,828 # a28 <digits>
 6f4:	03c9d793          	srl	a5,s3,0x3c
 6f8:	97de                	add	a5,a5,s7
 6fa:	0007c583          	lbu	a1,0(a5)
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	e1a080e7          	jalr	-486(ra) # 51a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 708:	0992                	sll	s3,s3,0x4
 70a:	397d                	addw	s2,s2,-1
 70c:	fe0914e3          	bnez	s2,6f4 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 710:	8be2                	mv	s7,s8
      state = 0;
 712:	4981                	li	s3,0
 714:	6c02                	ld	s8,0(sp)
 716:	bf11                	j	62a <vprintf+0x42>
        s = va_arg(ap, char*);
 718:	008b8993          	add	s3,s7,8
 71c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 720:	02090163          	beqz	s2,742 <vprintf+0x15a>
        while(*s != 0){
 724:	00094583          	lbu	a1,0(s2)
 728:	c9a5                	beqz	a1,798 <vprintf+0x1b0>
          putc(fd, *s);
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	dee080e7          	jalr	-530(ra) # 51a <putc>
          s++;
 734:	0905                	add	s2,s2,1
        while(*s != 0){
 736:	00094583          	lbu	a1,0(s2)
 73a:	f9e5                	bnez	a1,72a <vprintf+0x142>
        s = va_arg(ap, char*);
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b5ed                	j	62a <vprintf+0x42>
          s = "(null)";
 742:	00000917          	auipc	s2,0x0
 746:	28690913          	add	s2,s2,646 # 9c8 <malloc+0x12e>
        while(*s != 0){
 74a:	02800593          	li	a1,40
 74e:	bff1                	j	72a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 750:	008b8913          	add	s2,s7,8
 754:	000bc583          	lbu	a1,0(s7)
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	dc0080e7          	jalr	-576(ra) # 51a <putc>
 762:	8bca                	mv	s7,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	b5d1                	j	62a <vprintf+0x42>
        putc(fd, c);
 768:	02500593          	li	a1,37
 76c:	8556                	mv	a0,s5
 76e:	00000097          	auipc	ra,0x0
 772:	dac080e7          	jalr	-596(ra) # 51a <putc>
      state = 0;
 776:	4981                	li	s3,0
 778:	bd4d                	j	62a <vprintf+0x42>
        putc(fd, '%');
 77a:	02500593          	li	a1,37
 77e:	8556                	mv	a0,s5
 780:	00000097          	auipc	ra,0x0
 784:	d9a080e7          	jalr	-614(ra) # 51a <putc>
        putc(fd, c);
 788:	85ca                	mv	a1,s2
 78a:	8556                	mv	a0,s5
 78c:	00000097          	auipc	ra,0x0
 790:	d8e080e7          	jalr	-626(ra) # 51a <putc>
      state = 0;
 794:	4981                	li	s3,0
 796:	bd51                	j	62a <vprintf+0x42>
        s = va_arg(ap, char*);
 798:	8bce                	mv	s7,s3
      state = 0;
 79a:	4981                	li	s3,0
 79c:	b579                	j	62a <vprintf+0x42>
 79e:	74e2                	ld	s1,56(sp)
 7a0:	79a2                	ld	s3,40(sp)
 7a2:	7a02                	ld	s4,32(sp)
 7a4:	6ae2                	ld	s5,24(sp)
 7a6:	6b42                	ld	s6,16(sp)
 7a8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 7aa:	60a6                	ld	ra,72(sp)
 7ac:	6406                	ld	s0,64(sp)
 7ae:	7942                	ld	s2,48(sp)
 7b0:	6161                	add	sp,sp,80
 7b2:	8082                	ret

00000000000007b4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7b4:	715d                	add	sp,sp,-80
 7b6:	ec06                	sd	ra,24(sp)
 7b8:	e822                	sd	s0,16(sp)
 7ba:	1000                	add	s0,sp,32
 7bc:	e010                	sd	a2,0(s0)
 7be:	e414                	sd	a3,8(s0)
 7c0:	e818                	sd	a4,16(s0)
 7c2:	ec1c                	sd	a5,24(s0)
 7c4:	03043023          	sd	a6,32(s0)
 7c8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7cc:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7d0:	8622                	mv	a2,s0
 7d2:	00000097          	auipc	ra,0x0
 7d6:	e16080e7          	jalr	-490(ra) # 5e8 <vprintf>
}
 7da:	60e2                	ld	ra,24(sp)
 7dc:	6442                	ld	s0,16(sp)
 7de:	6161                	add	sp,sp,80
 7e0:	8082                	ret

00000000000007e2 <printf>:

void
printf(const char *fmt, ...)
{
 7e2:	711d                	add	sp,sp,-96
 7e4:	ec06                	sd	ra,24(sp)
 7e6:	e822                	sd	s0,16(sp)
 7e8:	1000                	add	s0,sp,32
 7ea:	e40c                	sd	a1,8(s0)
 7ec:	e810                	sd	a2,16(s0)
 7ee:	ec14                	sd	a3,24(s0)
 7f0:	f018                	sd	a4,32(s0)
 7f2:	f41c                	sd	a5,40(s0)
 7f4:	03043823          	sd	a6,48(s0)
 7f8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7fc:	00840613          	add	a2,s0,8
 800:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 804:	85aa                	mv	a1,a0
 806:	4505                	li	a0,1
 808:	00000097          	auipc	ra,0x0
 80c:	de0080e7          	jalr	-544(ra) # 5e8 <vprintf>
}
 810:	60e2                	ld	ra,24(sp)
 812:	6442                	ld	s0,16(sp)
 814:	6125                	add	sp,sp,96
 816:	8082                	ret

0000000000000818 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 818:	1141                	add	sp,sp,-16
 81a:	e422                	sd	s0,8(sp)
 81c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 81e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 822:	00000797          	auipc	a5,0x0
 826:	7de7b783          	ld	a5,2014(a5) # 1000 <freep>
 82a:	a02d                	j	854 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 82c:	4618                	lw	a4,8(a2)
 82e:	9f2d                	addw	a4,a4,a1
 830:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 834:	6398                	ld	a4,0(a5)
 836:	6310                	ld	a2,0(a4)
 838:	a83d                	j	876 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 83a:	ff852703          	lw	a4,-8(a0)
 83e:	9f31                	addw	a4,a4,a2
 840:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 842:	ff053683          	ld	a3,-16(a0)
 846:	a091                	j	88a <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 848:	6398                	ld	a4,0(a5)
 84a:	00e7e463          	bltu	a5,a4,852 <free+0x3a>
 84e:	00e6ea63          	bltu	a3,a4,862 <free+0x4a>
{
 852:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 854:	fed7fae3          	bgeu	a5,a3,848 <free+0x30>
 858:	6398                	ld	a4,0(a5)
 85a:	00e6e463          	bltu	a3,a4,862 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85e:	fee7eae3          	bltu	a5,a4,852 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 862:	ff852583          	lw	a1,-8(a0)
 866:	6390                	ld	a2,0(a5)
 868:	02059813          	sll	a6,a1,0x20
 86c:	01c85713          	srl	a4,a6,0x1c
 870:	9736                	add	a4,a4,a3
 872:	fae60de3          	beq	a2,a4,82c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 87a:	4790                	lw	a2,8(a5)
 87c:	02061593          	sll	a1,a2,0x20
 880:	01c5d713          	srl	a4,a1,0x1c
 884:	973e                	add	a4,a4,a5
 886:	fae68ae3          	beq	a3,a4,83a <free+0x22>
    p->s.ptr = bp->s.ptr;
 88a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 88c:	00000717          	auipc	a4,0x0
 890:	76f73a23          	sd	a5,1908(a4) # 1000 <freep>
}
 894:	6422                	ld	s0,8(sp)
 896:	0141                	add	sp,sp,16
 898:	8082                	ret

000000000000089a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 89a:	7139                	add	sp,sp,-64
 89c:	fc06                	sd	ra,56(sp)
 89e:	f822                	sd	s0,48(sp)
 8a0:	f426                	sd	s1,40(sp)
 8a2:	ec4e                	sd	s3,24(sp)
 8a4:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8a6:	02051493          	sll	s1,a0,0x20
 8aa:	9081                	srl	s1,s1,0x20
 8ac:	04bd                	add	s1,s1,15
 8ae:	8091                	srl	s1,s1,0x4
 8b0:	0014899b          	addw	s3,s1,1
 8b4:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8b6:	00000517          	auipc	a0,0x0
 8ba:	74a53503          	ld	a0,1866(a0) # 1000 <freep>
 8be:	c915                	beqz	a0,8f2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	08977e63          	bgeu	a4,s1,960 <malloc+0xc6>
 8c8:	f04a                	sd	s2,32(sp)
 8ca:	e852                	sd	s4,16(sp)
 8cc:	e456                	sd	s5,8(sp)
 8ce:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8d0:	8a4e                	mv	s4,s3
 8d2:	0009871b          	sext.w	a4,s3
 8d6:	6685                	lui	a3,0x1
 8d8:	00d77363          	bgeu	a4,a3,8de <malloc+0x44>
 8dc:	6a05                	lui	s4,0x1
 8de:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8e2:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8e6:	00000917          	auipc	s2,0x0
 8ea:	71a90913          	add	s2,s2,1818 # 1000 <freep>
  if(p == (char*)-1)
 8ee:	5afd                	li	s5,-1
 8f0:	a091                	j	934 <malloc+0x9a>
 8f2:	f04a                	sd	s2,32(sp)
 8f4:	e852                	sd	s4,16(sp)
 8f6:	e456                	sd	s5,8(sp)
 8f8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8fa:	00000797          	auipc	a5,0x0
 8fe:	71678793          	add	a5,a5,1814 # 1010 <base>
 902:	00000717          	auipc	a4,0x0
 906:	6ef73f23          	sd	a5,1790(a4) # 1000 <freep>
 90a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 90c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 910:	b7c1                	j	8d0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 912:	6398                	ld	a4,0(a5)
 914:	e118                	sd	a4,0(a0)
 916:	a08d                	j	978 <malloc+0xde>
  hp->s.size = nu;
 918:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 91c:	0541                	add	a0,a0,16
 91e:	00000097          	auipc	ra,0x0
 922:	efa080e7          	jalr	-262(ra) # 818 <free>
  return freep;
 926:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 92a:	c13d                	beqz	a0,990 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 92c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92e:	4798                	lw	a4,8(a5)
 930:	02977463          	bgeu	a4,s1,958 <malloc+0xbe>
    if(p == freep)
 934:	00093703          	ld	a4,0(s2)
 938:	853e                	mv	a0,a5
 93a:	fef719e3          	bne	a4,a5,92c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 93e:	8552                	mv	a0,s4
 940:	00000097          	auipc	ra,0x0
 944:	ba2080e7          	jalr	-1118(ra) # 4e2 <sbrk>
  if(p == (char*)-1)
 948:	fd5518e3          	bne	a0,s5,918 <malloc+0x7e>
        return 0;
 94c:	4501                	li	a0,0
 94e:	7902                	ld	s2,32(sp)
 950:	6a42                	ld	s4,16(sp)
 952:	6aa2                	ld	s5,8(sp)
 954:	6b02                	ld	s6,0(sp)
 956:	a03d                	j	984 <malloc+0xea>
 958:	7902                	ld	s2,32(sp)
 95a:	6a42                	ld	s4,16(sp)
 95c:	6aa2                	ld	s5,8(sp)
 95e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 960:	fae489e3          	beq	s1,a4,912 <malloc+0x78>
        p->s.size -= nunits;
 964:	4137073b          	subw	a4,a4,s3
 968:	c798                	sw	a4,8(a5)
        p += p->s.size;
 96a:	02071693          	sll	a3,a4,0x20
 96e:	01c6d713          	srl	a4,a3,0x1c
 972:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 974:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 978:	00000717          	auipc	a4,0x0
 97c:	68a73423          	sd	a0,1672(a4) # 1000 <freep>
      return (void*)(p + 1);
 980:	01078513          	add	a0,a5,16
  }
}
 984:	70e2                	ld	ra,56(sp)
 986:	7442                	ld	s0,48(sp)
 988:	74a2                	ld	s1,40(sp)
 98a:	69e2                	ld	s3,24(sp)
 98c:	6121                	add	sp,sp,64
 98e:	8082                	ret
 990:	7902                	ld	s2,32(sp)
 992:	6a42                	ld	s4,16(sp)
 994:	6aa2                	ld	s5,8(sp)
 996:	6b02                	ld	s6,0(sp)
 998:	b7f5                	j	984 <malloc+0xea>
