
user/_mmaptest1:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

void
main(int argc, char *argv[])
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
  uint64 p = (uint64) 0x100000000ULL;
  
  printf("base page : %p\n", mmap((void *)(p), 4097, PROT_WRITE, MAP_SHARED));
   e:	02000693          	li	a3,32
  12:	4609                	li	a2,2
  14:	6585                	lui	a1,0x1
  16:	0585                	add	a1,a1,1 # 1001 <freep+0x1>
  18:	4505                	li	a0,1
  1a:	1502                	sll	a0,a0,0x20
  1c:	00000097          	auipc	ra,0x0
  20:	488080e7          	jalr	1160(ra) # 4a4 <mmap>
  24:	85aa                	mv	a1,a0
  26:	00001517          	auipc	a0,0x1
  2a:	91a50513          	add	a0,a0,-1766 # 940 <malloc+0x10c>
  2e:	00000097          	auipc	ra,0x0
  32:	74e080e7          	jalr	1870(ra) # 77c <printf>
  *(int *)(p+16) = 0x900dbeef;
  36:	4485                	li	s1,1
  38:	1482                	sll	s1,s1,0x20
  3a:	900dc937          	lui	s2,0x900dc
  3e:	eef90913          	add	s2,s2,-273 # ffffffff900dbeef <base+0xffffffff900daedf>
  42:	0124a823          	sw	s2,16(s1)
  printf("[%d]try read 1: %x\n",1,*(int *)(p+24));
  46:	4c90                	lw	a2,24(s1)
  48:	4585                	li	a1,1
  4a:	00001517          	auipc	a0,0x1
  4e:	90650513          	add	a0,a0,-1786 # 950 <malloc+0x11c>
  52:	00000097          	auipc	ra,0x0
  56:	72a080e7          	jalr	1834(ra) # 77c <printf>
  munmap((void*)p);
  5a:	8526                	mv	a0,s1
  5c:	00000097          	auipc	ra,0x0
  60:	450080e7          	jalr	1104(ra) # 4ac <munmap>

  printf("base page2 : %p\n", mmap((void *)(p), 4096*4, PROT_WRITE, MAP_SHARED));
  64:	02000693          	li	a3,32
  68:	4609                	li	a2,2
  6a:	6591                	lui	a1,0x4
  6c:	8526                	mv	a0,s1
  6e:	00000097          	auipc	ra,0x0
  72:	436080e7          	jalr	1078(ra) # 4a4 <mmap>
  76:	85aa                	mv	a1,a0
  78:	00001517          	auipc	a0,0x1
  7c:	8f050513          	add	a0,a0,-1808 # 968 <malloc+0x134>
  80:	00000097          	auipc	ra,0x0
  84:	6fc080e7          	jalr	1788(ra) # 77c <printf>
  *(int *)(p+5000) = 0x900dbeef;
  88:	200009b7          	lui	s3,0x20000
  8c:	27198993          	add	s3,s3,625 # 20000271 <base+0x1ffff261>
  90:	098e                	sll	s3,s3,0x3
  92:	0129a023          	sw	s2,0(s3)
  //   printf("[%d]try read 2: %x\n\n",i,*(int *)(p+i));
  // }
  
  // munmap((void*)p);

  printf("HUGE page : %p\n", mmap((void *)(p), 4096*513, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE));
  96:	12000693          	li	a3,288
  9a:	4609                	li	a2,2
  9c:	002015b7          	lui	a1,0x201
  a0:	8526                	mv	a0,s1
  a2:	00000097          	auipc	ra,0x0
  a6:	402080e7          	jalr	1026(ra) # 4a4 <mmap>
  aa:	85aa                	mv	a1,a0
  ac:	00001517          	auipc	a0,0x1
  b0:	8d450513          	add	a0,a0,-1836 # 980 <malloc+0x14c>
  b4:	00000097          	auipc	ra,0x0
  b8:	6c8080e7          	jalr	1736(ra) # 77c <printf>
  printf("(HUGE)[]try read 1: %x\n",*(int *)(p+5000));
  bc:	0009a583          	lw	a1,0(s3)
  c0:	00001517          	auipc	a0,0x1
  c4:	8d050513          	add	a0,a0,-1840 # 990 <malloc+0x15c>
  c8:	00000097          	auipc	ra,0x0
  cc:	6b4080e7          	jalr	1716(ra) # 77c <printf>
  *(int *)(p) = 0xbeefbeef;
  d0:	beefc5b7          	lui	a1,0xbeefc
  d4:	eef58593          	add	a1,a1,-273 # ffffffffbeefbeef <base+0xffffffffbeefaedf>
  d8:	c08c                	sw	a1,0(s1)
  printf("(HUGE)[]try read 2: %x\n\n",*(int *)(p));
  da:	00001517          	auipc	a0,0x1
  de:	8ce50513          	add	a0,a0,-1842 # 9a8 <malloc+0x174>
  e2:	00000097          	auipc	ra,0x0
  e6:	69a080e7          	jalr	1690(ra) # 77c <printf>
  munmap((void*)p);
  ea:	8526                	mv	a0,s1
  ec:	00000097          	auipc	ra,0x0
  f0:	3c0080e7          	jalr	960(ra) # 4ac <munmap>
  printf("HUGE page 2: %p\n", mmap((void *)(p), 4096*513, PROT_WRITE, MAP_SHARED | MAP_HUGEPAGE));
  f4:	12000693          	li	a3,288
  f8:	4609                	li	a2,2
  fa:	002015b7          	lui	a1,0x201
  fe:	8526                	mv	a0,s1
 100:	00000097          	auipc	ra,0x0
 104:	3a4080e7          	jalr	932(ra) # 4a4 <mmap>
 108:	85aa                	mv	a1,a0
 10a:	00001517          	auipc	a0,0x1
 10e:	8be50513          	add	a0,a0,-1858 # 9c8 <malloc+0x194>
 112:	00000097          	auipc	ra,0x0
 116:	66a080e7          	jalr	1642(ra) # 77c <printf>
 


  printf("(HUGE)[]try read 3: %x\n",*(int *)(p+4096*512));
 11a:	008014b7          	lui	s1,0x801
 11e:	04a6                	sll	s1,s1,0x9
 120:	408c                	lw	a1,0(s1)
 122:	00001517          	auipc	a0,0x1
 126:	8be50513          	add	a0,a0,-1858 # 9e0 <malloc+0x1ac>
 12a:	00000097          	auipc	ra,0x0
 12e:	652080e7          	jalr	1618(ra) # 77c <printf>
  *(int *)(p+4096*512) = 0x900dbeef;
 132:	0124a023          	sw	s2,0(s1) # 801000 <base+0x7ffff0>
  printf("(HUGE)[]try read 4: %x\n\n",*(int *)(p+4096*512));
 136:	85ca                	mv	a1,s2
 138:	00001517          	auipc	a0,0x1
 13c:	8c050513          	add	a0,a0,-1856 # 9f8 <malloc+0x1c4>
 140:	00000097          	auipc	ra,0x0
 144:	63c080e7          	jalr	1596(ra) # 77c <printf>



 
  return;
}
 148:	70a2                	ld	ra,40(sp)
 14a:	7402                	ld	s0,32(sp)
 14c:	64e2                	ld	s1,24(sp)
 14e:	6942                	ld	s2,16(sp)
 150:	69a2                	ld	s3,8(sp)
 152:	6145                	add	sp,sp,48
 154:	8082                	ret

0000000000000156 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 156:	1141                	add	sp,sp,-16
 158:	e406                	sd	ra,8(sp)
 15a:	e022                	sd	s0,0(sp)
 15c:	0800                	add	s0,sp,16
  extern int main();
  main();
 15e:	00000097          	auipc	ra,0x0
 162:	ea2080e7          	jalr	-350(ra) # 0 <main>
  exit(0);
 166:	4501                	li	a0,0
 168:	00000097          	auipc	ra,0x0
 16c:	28c080e7          	jalr	652(ra) # 3f4 <exit>

0000000000000170 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 170:	1141                	add	sp,sp,-16
 172:	e422                	sd	s0,8(sp)
 174:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 176:	87aa                	mv	a5,a0
 178:	0585                	add	a1,a1,1 # 201001 <base+0x1ffff1>
 17a:	0785                	add	a5,a5,1
 17c:	fff5c703          	lbu	a4,-1(a1)
 180:	fee78fa3          	sb	a4,-1(a5)
 184:	fb75                	bnez	a4,178 <strcpy+0x8>
    ;
  return os;
}
 186:	6422                	ld	s0,8(sp)
 188:	0141                	add	sp,sp,16
 18a:	8082                	ret

000000000000018c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18c:	1141                	add	sp,sp,-16
 18e:	e422                	sd	s0,8(sp)
 190:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 192:	00054783          	lbu	a5,0(a0)
 196:	cb91                	beqz	a5,1aa <strcmp+0x1e>
 198:	0005c703          	lbu	a4,0(a1)
 19c:	00f71763          	bne	a4,a5,1aa <strcmp+0x1e>
    p++, q++;
 1a0:	0505                	add	a0,a0,1
 1a2:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1a4:	00054783          	lbu	a5,0(a0)
 1a8:	fbe5                	bnez	a5,198 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1aa:	0005c503          	lbu	a0,0(a1)
}
 1ae:	40a7853b          	subw	a0,a5,a0
 1b2:	6422                	ld	s0,8(sp)
 1b4:	0141                	add	sp,sp,16
 1b6:	8082                	ret

00000000000001b8 <strlen>:

uint
strlen(const char *s)
{
 1b8:	1141                	add	sp,sp,-16
 1ba:	e422                	sd	s0,8(sp)
 1bc:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1be:	00054783          	lbu	a5,0(a0)
 1c2:	cf91                	beqz	a5,1de <strlen+0x26>
 1c4:	0505                	add	a0,a0,1
 1c6:	87aa                	mv	a5,a0
 1c8:	86be                	mv	a3,a5
 1ca:	0785                	add	a5,a5,1
 1cc:	fff7c703          	lbu	a4,-1(a5)
 1d0:	ff65                	bnez	a4,1c8 <strlen+0x10>
 1d2:	40a6853b          	subw	a0,a3,a0
 1d6:	2505                	addw	a0,a0,1
    ;
  return n;
}
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	add	sp,sp,16
 1dc:	8082                	ret
  for(n = 0; s[n]; n++)
 1de:	4501                	li	a0,0
 1e0:	bfe5                	j	1d8 <strlen+0x20>

00000000000001e2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e2:	1141                	add	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1e8:	ca19                	beqz	a2,1fe <memset+0x1c>
 1ea:	87aa                	mv	a5,a0
 1ec:	1602                	sll	a2,a2,0x20
 1ee:	9201                	srl	a2,a2,0x20
 1f0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1f4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1f8:	0785                	add	a5,a5,1
 1fa:	fee79de3          	bne	a5,a4,1f4 <memset+0x12>
  }
  return dst;
}
 1fe:	6422                	ld	s0,8(sp)
 200:	0141                	add	sp,sp,16
 202:	8082                	ret

0000000000000204 <strchr>:

char*
strchr(const char *s, char c)
{
 204:	1141                	add	sp,sp,-16
 206:	e422                	sd	s0,8(sp)
 208:	0800                	add	s0,sp,16
  for(; *s; s++)
 20a:	00054783          	lbu	a5,0(a0)
 20e:	cb99                	beqz	a5,224 <strchr+0x20>
    if(*s == c)
 210:	00f58763          	beq	a1,a5,21e <strchr+0x1a>
  for(; *s; s++)
 214:	0505                	add	a0,a0,1
 216:	00054783          	lbu	a5,0(a0)
 21a:	fbfd                	bnez	a5,210 <strchr+0xc>
      return (char*)s;
  return 0;
 21c:	4501                	li	a0,0
}
 21e:	6422                	ld	s0,8(sp)
 220:	0141                	add	sp,sp,16
 222:	8082                	ret
  return 0;
 224:	4501                	li	a0,0
 226:	bfe5                	j	21e <strchr+0x1a>

0000000000000228 <gets>:

char*
gets(char *buf, int max)
{
 228:	711d                	add	sp,sp,-96
 22a:	ec86                	sd	ra,88(sp)
 22c:	e8a2                	sd	s0,80(sp)
 22e:	e4a6                	sd	s1,72(sp)
 230:	e0ca                	sd	s2,64(sp)
 232:	fc4e                	sd	s3,56(sp)
 234:	f852                	sd	s4,48(sp)
 236:	f456                	sd	s5,40(sp)
 238:	f05a                	sd	s6,32(sp)
 23a:	ec5e                	sd	s7,24(sp)
 23c:	1080                	add	s0,sp,96
 23e:	8baa                	mv	s7,a0
 240:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 242:	892a                	mv	s2,a0
 244:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 246:	4aa9                	li	s5,10
 248:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 24a:	89a6                	mv	s3,s1
 24c:	2485                	addw	s1,s1,1
 24e:	0344d863          	bge	s1,s4,27e <gets+0x56>
    cc = read(0, &c, 1);
 252:	4605                	li	a2,1
 254:	faf40593          	add	a1,s0,-81
 258:	4501                	li	a0,0
 25a:	00000097          	auipc	ra,0x0
 25e:	1b2080e7          	jalr	434(ra) # 40c <read>
    if(cc < 1)
 262:	00a05e63          	blez	a0,27e <gets+0x56>
    buf[i++] = c;
 266:	faf44783          	lbu	a5,-81(s0)
 26a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 26e:	01578763          	beq	a5,s5,27c <gets+0x54>
 272:	0905                	add	s2,s2,1
 274:	fd679be3          	bne	a5,s6,24a <gets+0x22>
    buf[i++] = c;
 278:	89a6                	mv	s3,s1
 27a:	a011                	j	27e <gets+0x56>
 27c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 27e:	99de                	add	s3,s3,s7
 280:	00098023          	sb	zero,0(s3)
  return buf;
}
 284:	855e                	mv	a0,s7
 286:	60e6                	ld	ra,88(sp)
 288:	6446                	ld	s0,80(sp)
 28a:	64a6                	ld	s1,72(sp)
 28c:	6906                	ld	s2,64(sp)
 28e:	79e2                	ld	s3,56(sp)
 290:	7a42                	ld	s4,48(sp)
 292:	7aa2                	ld	s5,40(sp)
 294:	7b02                	ld	s6,32(sp)
 296:	6be2                	ld	s7,24(sp)
 298:	6125                	add	sp,sp,96
 29a:	8082                	ret

000000000000029c <stat>:

int
stat(const char *n, struct stat *st)
{
 29c:	1101                	add	sp,sp,-32
 29e:	ec06                	sd	ra,24(sp)
 2a0:	e822                	sd	s0,16(sp)
 2a2:	e04a                	sd	s2,0(sp)
 2a4:	1000                	add	s0,sp,32
 2a6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2a8:	4581                	li	a1,0
 2aa:	00000097          	auipc	ra,0x0
 2ae:	18a080e7          	jalr	394(ra) # 434 <open>
  if(fd < 0)
 2b2:	02054663          	bltz	a0,2de <stat+0x42>
 2b6:	e426                	sd	s1,8(sp)
 2b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2ba:	85ca                	mv	a1,s2
 2bc:	00000097          	auipc	ra,0x0
 2c0:	190080e7          	jalr	400(ra) # 44c <fstat>
 2c4:	892a                	mv	s2,a0
  close(fd);
 2c6:	8526                	mv	a0,s1
 2c8:	00000097          	auipc	ra,0x0
 2cc:	154080e7          	jalr	340(ra) # 41c <close>
  return r;
 2d0:	64a2                	ld	s1,8(sp)
}
 2d2:	854a                	mv	a0,s2
 2d4:	60e2                	ld	ra,24(sp)
 2d6:	6442                	ld	s0,16(sp)
 2d8:	6902                	ld	s2,0(sp)
 2da:	6105                	add	sp,sp,32
 2dc:	8082                	ret
    return -1;
 2de:	597d                	li	s2,-1
 2e0:	bfcd                	j	2d2 <stat+0x36>

00000000000002e2 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 2e2:	1141                	add	sp,sp,-16
 2e4:	e422                	sd	s0,8(sp)
 2e6:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 2e8:	00054703          	lbu	a4,0(a0)
 2ec:	02d00793          	li	a5,45
 2f0:	4585                	li	a1,1
 2f2:	04f70363          	beq	a4,a5,338 <atoi+0x56>

  while('0' <= *s && *s <= '9')
 2f6:	00054703          	lbu	a4,0(a0)
 2fa:	fd07079b          	addw	a5,a4,-48
 2fe:	0ff7f793          	zext.b	a5,a5
 302:	46a5                	li	a3,9
 304:	02f6ed63          	bltu	a3,a5,33e <atoi+0x5c>
  int n = 0;
 308:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 30a:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 30c:	0505                	add	a0,a0,1
 30e:	0026979b          	sllw	a5,a3,0x2
 312:	9fb5                	addw	a5,a5,a3
 314:	0017979b          	sllw	a5,a5,0x1
 318:	9fb9                	addw	a5,a5,a4
 31a:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 31e:	00054703          	lbu	a4,0(a0)
 322:	fd07079b          	addw	a5,a4,-48
 326:	0ff7f793          	zext.b	a5,a5
 32a:	fef671e3          	bgeu	a2,a5,30c <atoi+0x2a>
  return sign * n;
}
 32e:	02d5853b          	mulw	a0,a1,a3
 332:	6422                	ld	s0,8(sp)
 334:	0141                	add	sp,sp,16
 336:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 338:	0505                	add	a0,a0,1
 33a:	55fd                	li	a1,-1
 33c:	bf6d                	j	2f6 <atoi+0x14>
  int n = 0;
 33e:	4681                	li	a3,0
 340:	b7fd                	j	32e <atoi+0x4c>

0000000000000342 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 342:	1141                	add	sp,sp,-16
 344:	e422                	sd	s0,8(sp)
 346:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 348:	02b57463          	bgeu	a0,a1,370 <memmove+0x2e>
    while(n-- > 0)
 34c:	00c05f63          	blez	a2,36a <memmove+0x28>
 350:	1602                	sll	a2,a2,0x20
 352:	9201                	srl	a2,a2,0x20
 354:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 358:	872a                	mv	a4,a0
      *dst++ = *src++;
 35a:	0585                	add	a1,a1,1
 35c:	0705                	add	a4,a4,1
 35e:	fff5c683          	lbu	a3,-1(a1)
 362:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 366:	fef71ae3          	bne	a4,a5,35a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 36a:	6422                	ld	s0,8(sp)
 36c:	0141                	add	sp,sp,16
 36e:	8082                	ret
    dst += n;
 370:	00c50733          	add	a4,a0,a2
    src += n;
 374:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 376:	fec05ae3          	blez	a2,36a <memmove+0x28>
 37a:	fff6079b          	addw	a5,a2,-1
 37e:	1782                	sll	a5,a5,0x20
 380:	9381                	srl	a5,a5,0x20
 382:	fff7c793          	not	a5,a5
 386:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 388:	15fd                	add	a1,a1,-1
 38a:	177d                	add	a4,a4,-1
 38c:	0005c683          	lbu	a3,0(a1)
 390:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 394:	fee79ae3          	bne	a5,a4,388 <memmove+0x46>
 398:	bfc9                	j	36a <memmove+0x28>

000000000000039a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 39a:	1141                	add	sp,sp,-16
 39c:	e422                	sd	s0,8(sp)
 39e:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3a0:	ca05                	beqz	a2,3d0 <memcmp+0x36>
 3a2:	fff6069b          	addw	a3,a2,-1
 3a6:	1682                	sll	a3,a3,0x20
 3a8:	9281                	srl	a3,a3,0x20
 3aa:	0685                	add	a3,a3,1
 3ac:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ae:	00054783          	lbu	a5,0(a0)
 3b2:	0005c703          	lbu	a4,0(a1)
 3b6:	00e79863          	bne	a5,a4,3c6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3ba:	0505                	add	a0,a0,1
    p2++;
 3bc:	0585                	add	a1,a1,1
  while (n-- > 0) {
 3be:	fed518e3          	bne	a0,a3,3ae <memcmp+0x14>
  }
  return 0;
 3c2:	4501                	li	a0,0
 3c4:	a019                	j	3ca <memcmp+0x30>
      return *p1 - *p2;
 3c6:	40e7853b          	subw	a0,a5,a4
}
 3ca:	6422                	ld	s0,8(sp)
 3cc:	0141                	add	sp,sp,16
 3ce:	8082                	ret
  return 0;
 3d0:	4501                	li	a0,0
 3d2:	bfe5                	j	3ca <memcmp+0x30>

00000000000003d4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3d4:	1141                	add	sp,sp,-16
 3d6:	e406                	sd	ra,8(sp)
 3d8:	e022                	sd	s0,0(sp)
 3da:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 3dc:	00000097          	auipc	ra,0x0
 3e0:	f66080e7          	jalr	-154(ra) # 342 <memmove>
}
 3e4:	60a2                	ld	ra,8(sp)
 3e6:	6402                	ld	s0,0(sp)
 3e8:	0141                	add	sp,sp,16
 3ea:	8082                	ret

00000000000003ec <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ec:	4885                	li	a7,1
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3f4:	4889                	li	a7,2
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3fc:	488d                	li	a7,3
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 404:	4891                	li	a7,4
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <read>:
.global read
read:
 li a7, SYS_read
 40c:	4895                	li	a7,5
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <write>:
.global write
write:
 li a7, SYS_write
 414:	48c1                	li	a7,16
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <close>:
.global close
close:
 li a7, SYS_close
 41c:	48d5                	li	a7,21
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <kill>:
.global kill
kill:
 li a7, SYS_kill
 424:	4899                	li	a7,6
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <exec>:
.global exec
exec:
 li a7, SYS_exec
 42c:	489d                	li	a7,7
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <open>:
.global open
open:
 li a7, SYS_open
 434:	48bd                	li	a7,15
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 43c:	48c5                	li	a7,17
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 444:	48c9                	li	a7,18
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 44c:	48a1                	li	a7,8
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <link>:
.global link
link:
 li a7, SYS_link
 454:	48cd                	li	a7,19
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 45c:	48d1                	li	a7,20
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 464:	48a5                	li	a7,9
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <dup>:
.global dup
dup:
 li a7, SYS_dup
 46c:	48a9                	li	a7,10
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 474:	48ad                	li	a7,11
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 47c:	48b1                	li	a7,12
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 484:	48b5                	li	a7,13
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 48c:	48b9                	li	a7,14
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 494:	48d9                	li	a7,22
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 49c:	48dd                	li	a7,23
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 4a4:	48e1                	li	a7,24
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 4ac:	48e5                	li	a7,25
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b4:	1101                	add	sp,sp,-32
 4b6:	ec06                	sd	ra,24(sp)
 4b8:	e822                	sd	s0,16(sp)
 4ba:	1000                	add	s0,sp,32
 4bc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c0:	4605                	li	a2,1
 4c2:	fef40593          	add	a1,s0,-17
 4c6:	00000097          	auipc	ra,0x0
 4ca:	f4e080e7          	jalr	-178(ra) # 414 <write>
}
 4ce:	60e2                	ld	ra,24(sp)
 4d0:	6442                	ld	s0,16(sp)
 4d2:	6105                	add	sp,sp,32
 4d4:	8082                	ret

00000000000004d6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4d6:	7139                	add	sp,sp,-64
 4d8:	fc06                	sd	ra,56(sp)
 4da:	f822                	sd	s0,48(sp)
 4dc:	f426                	sd	s1,40(sp)
 4de:	0080                	add	s0,sp,64
 4e0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4e2:	c299                	beqz	a3,4e8 <printint+0x12>
 4e4:	0805cb63          	bltz	a1,57a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4e8:	2581                	sext.w	a1,a1
  neg = 0;
 4ea:	4881                	li	a7,0
 4ec:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4f0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4f2:	2601                	sext.w	a2,a2
 4f4:	00000517          	auipc	a0,0x0
 4f8:	58450513          	add	a0,a0,1412 # a78 <digits>
 4fc:	883a                	mv	a6,a4
 4fe:	2705                	addw	a4,a4,1
 500:	02c5f7bb          	remuw	a5,a1,a2
 504:	1782                	sll	a5,a5,0x20
 506:	9381                	srl	a5,a5,0x20
 508:	97aa                	add	a5,a5,a0
 50a:	0007c783          	lbu	a5,0(a5)
 50e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 512:	0005879b          	sext.w	a5,a1
 516:	02c5d5bb          	divuw	a1,a1,a2
 51a:	0685                	add	a3,a3,1
 51c:	fec7f0e3          	bgeu	a5,a2,4fc <printint+0x26>
  if(neg)
 520:	00088c63          	beqz	a7,538 <printint+0x62>
    buf[i++] = '-';
 524:	fd070793          	add	a5,a4,-48
 528:	00878733          	add	a4,a5,s0
 52c:	02d00793          	li	a5,45
 530:	fef70823          	sb	a5,-16(a4)
 534:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 538:	02e05c63          	blez	a4,570 <printint+0x9a>
 53c:	f04a                	sd	s2,32(sp)
 53e:	ec4e                	sd	s3,24(sp)
 540:	fc040793          	add	a5,s0,-64
 544:	00e78933          	add	s2,a5,a4
 548:	fff78993          	add	s3,a5,-1
 54c:	99ba                	add	s3,s3,a4
 54e:	377d                	addw	a4,a4,-1
 550:	1702                	sll	a4,a4,0x20
 552:	9301                	srl	a4,a4,0x20
 554:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 558:	fff94583          	lbu	a1,-1(s2)
 55c:	8526                	mv	a0,s1
 55e:	00000097          	auipc	ra,0x0
 562:	f56080e7          	jalr	-170(ra) # 4b4 <putc>
  while(--i >= 0)
 566:	197d                	add	s2,s2,-1
 568:	ff3918e3          	bne	s2,s3,558 <printint+0x82>
 56c:	7902                	ld	s2,32(sp)
 56e:	69e2                	ld	s3,24(sp)
}
 570:	70e2                	ld	ra,56(sp)
 572:	7442                	ld	s0,48(sp)
 574:	74a2                	ld	s1,40(sp)
 576:	6121                	add	sp,sp,64
 578:	8082                	ret
    x = -xx;
 57a:	40b005bb          	negw	a1,a1
    neg = 1;
 57e:	4885                	li	a7,1
    x = -xx;
 580:	b7b5                	j	4ec <printint+0x16>

0000000000000582 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 582:	715d                	add	sp,sp,-80
 584:	e486                	sd	ra,72(sp)
 586:	e0a2                	sd	s0,64(sp)
 588:	f84a                	sd	s2,48(sp)
 58a:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 58c:	0005c903          	lbu	s2,0(a1)
 590:	1a090a63          	beqz	s2,744 <vprintf+0x1c2>
 594:	fc26                	sd	s1,56(sp)
 596:	f44e                	sd	s3,40(sp)
 598:	f052                	sd	s4,32(sp)
 59a:	ec56                	sd	s5,24(sp)
 59c:	e85a                	sd	s6,16(sp)
 59e:	e45e                	sd	s7,8(sp)
 5a0:	8aaa                	mv	s5,a0
 5a2:	8bb2                	mv	s7,a2
 5a4:	00158493          	add	s1,a1,1
  state = 0;
 5a8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5aa:	02500a13          	li	s4,37
 5ae:	4b55                	li	s6,21
 5b0:	a839                	j	5ce <vprintf+0x4c>
        putc(fd, c);
 5b2:	85ca                	mv	a1,s2
 5b4:	8556                	mv	a0,s5
 5b6:	00000097          	auipc	ra,0x0
 5ba:	efe080e7          	jalr	-258(ra) # 4b4 <putc>
 5be:	a019                	j	5c4 <vprintf+0x42>
    } else if(state == '%'){
 5c0:	01498d63          	beq	s3,s4,5da <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5c4:	0485                	add	s1,s1,1
 5c6:	fff4c903          	lbu	s2,-1(s1)
 5ca:	16090763          	beqz	s2,738 <vprintf+0x1b6>
    if(state == 0){
 5ce:	fe0999e3          	bnez	s3,5c0 <vprintf+0x3e>
      if(c == '%'){
 5d2:	ff4910e3          	bne	s2,s4,5b2 <vprintf+0x30>
        state = '%';
 5d6:	89d2                	mv	s3,s4
 5d8:	b7f5                	j	5c4 <vprintf+0x42>
      if(c == 'd'){
 5da:	13490463          	beq	s2,s4,702 <vprintf+0x180>
 5de:	f9d9079b          	addw	a5,s2,-99
 5e2:	0ff7f793          	zext.b	a5,a5
 5e6:	12fb6763          	bltu	s6,a5,714 <vprintf+0x192>
 5ea:	f9d9079b          	addw	a5,s2,-99
 5ee:	0ff7f713          	zext.b	a4,a5
 5f2:	12eb6163          	bltu	s6,a4,714 <vprintf+0x192>
 5f6:	00271793          	sll	a5,a4,0x2
 5fa:	00000717          	auipc	a4,0x0
 5fe:	42670713          	add	a4,a4,1062 # a20 <malloc+0x1ec>
 602:	97ba                	add	a5,a5,a4
 604:	439c                	lw	a5,0(a5)
 606:	97ba                	add	a5,a5,a4
 608:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 60a:	008b8913          	add	s2,s7,8
 60e:	4685                	li	a3,1
 610:	4629                	li	a2,10
 612:	000ba583          	lw	a1,0(s7)
 616:	8556                	mv	a0,s5
 618:	00000097          	auipc	ra,0x0
 61c:	ebe080e7          	jalr	-322(ra) # 4d6 <printint>
 620:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 622:	4981                	li	s3,0
 624:	b745                	j	5c4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 626:	008b8913          	add	s2,s7,8
 62a:	4681                	li	a3,0
 62c:	4629                	li	a2,10
 62e:	000ba583          	lw	a1,0(s7)
 632:	8556                	mv	a0,s5
 634:	00000097          	auipc	ra,0x0
 638:	ea2080e7          	jalr	-350(ra) # 4d6 <printint>
 63c:	8bca                	mv	s7,s2
      state = 0;
 63e:	4981                	li	s3,0
 640:	b751                	j	5c4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 642:	008b8913          	add	s2,s7,8
 646:	4681                	li	a3,0
 648:	4641                	li	a2,16
 64a:	000ba583          	lw	a1,0(s7)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e86080e7          	jalr	-378(ra) # 4d6 <printint>
 658:	8bca                	mv	s7,s2
      state = 0;
 65a:	4981                	li	s3,0
 65c:	b7a5                	j	5c4 <vprintf+0x42>
 65e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 660:	008b8c13          	add	s8,s7,8
 664:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 668:	03000593          	li	a1,48
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	e46080e7          	jalr	-442(ra) # 4b4 <putc>
  putc(fd, 'x');
 676:	07800593          	li	a1,120
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	e38080e7          	jalr	-456(ra) # 4b4 <putc>
 684:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 686:	00000b97          	auipc	s7,0x0
 68a:	3f2b8b93          	add	s7,s7,1010 # a78 <digits>
 68e:	03c9d793          	srl	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	8556                	mv	a0,s5
 69a:	00000097          	auipc	ra,0x0
 69e:	e1a080e7          	jalr	-486(ra) # 4b4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a2:	0992                	sll	s3,s3,0x4
 6a4:	397d                	addw	s2,s2,-1
 6a6:	fe0914e3          	bnez	s2,68e <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6aa:	8be2                	mv	s7,s8
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	6c02                	ld	s8,0(sp)
 6b0:	bf11                	j	5c4 <vprintf+0x42>
        s = va_arg(ap, char*);
 6b2:	008b8993          	add	s3,s7,8
 6b6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6ba:	02090163          	beqz	s2,6dc <vprintf+0x15a>
        while(*s != 0){
 6be:	00094583          	lbu	a1,0(s2)
 6c2:	c9a5                	beqz	a1,732 <vprintf+0x1b0>
          putc(fd, *s);
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	dee080e7          	jalr	-530(ra) # 4b4 <putc>
          s++;
 6ce:	0905                	add	s2,s2,1
        while(*s != 0){
 6d0:	00094583          	lbu	a1,0(s2)
 6d4:	f9e5                	bnez	a1,6c4 <vprintf+0x142>
        s = va_arg(ap, char*);
 6d6:	8bce                	mv	s7,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b5ed                	j	5c4 <vprintf+0x42>
          s = "(null)";
 6dc:	00000917          	auipc	s2,0x0
 6e0:	33c90913          	add	s2,s2,828 # a18 <malloc+0x1e4>
        while(*s != 0){
 6e4:	02800593          	li	a1,40
 6e8:	bff1                	j	6c4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6ea:	008b8913          	add	s2,s7,8
 6ee:	000bc583          	lbu	a1,0(s7)
 6f2:	8556                	mv	a0,s5
 6f4:	00000097          	auipc	ra,0x0
 6f8:	dc0080e7          	jalr	-576(ra) # 4b4 <putc>
 6fc:	8bca                	mv	s7,s2
      state = 0;
 6fe:	4981                	li	s3,0
 700:	b5d1                	j	5c4 <vprintf+0x42>
        putc(fd, c);
 702:	02500593          	li	a1,37
 706:	8556                	mv	a0,s5
 708:	00000097          	auipc	ra,0x0
 70c:	dac080e7          	jalr	-596(ra) # 4b4 <putc>
      state = 0;
 710:	4981                	li	s3,0
 712:	bd4d                	j	5c4 <vprintf+0x42>
        putc(fd, '%');
 714:	02500593          	li	a1,37
 718:	8556                	mv	a0,s5
 71a:	00000097          	auipc	ra,0x0
 71e:	d9a080e7          	jalr	-614(ra) # 4b4 <putc>
        putc(fd, c);
 722:	85ca                	mv	a1,s2
 724:	8556                	mv	a0,s5
 726:	00000097          	auipc	ra,0x0
 72a:	d8e080e7          	jalr	-626(ra) # 4b4 <putc>
      state = 0;
 72e:	4981                	li	s3,0
 730:	bd51                	j	5c4 <vprintf+0x42>
        s = va_arg(ap, char*);
 732:	8bce                	mv	s7,s3
      state = 0;
 734:	4981                	li	s3,0
 736:	b579                	j	5c4 <vprintf+0x42>
 738:	74e2                	ld	s1,56(sp)
 73a:	79a2                	ld	s3,40(sp)
 73c:	7a02                	ld	s4,32(sp)
 73e:	6ae2                	ld	s5,24(sp)
 740:	6b42                	ld	s6,16(sp)
 742:	6ba2                	ld	s7,8(sp)
    }
  }
}
 744:	60a6                	ld	ra,72(sp)
 746:	6406                	ld	s0,64(sp)
 748:	7942                	ld	s2,48(sp)
 74a:	6161                	add	sp,sp,80
 74c:	8082                	ret

000000000000074e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 74e:	715d                	add	sp,sp,-80
 750:	ec06                	sd	ra,24(sp)
 752:	e822                	sd	s0,16(sp)
 754:	1000                	add	s0,sp,32
 756:	e010                	sd	a2,0(s0)
 758:	e414                	sd	a3,8(s0)
 75a:	e818                	sd	a4,16(s0)
 75c:	ec1c                	sd	a5,24(s0)
 75e:	03043023          	sd	a6,32(s0)
 762:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 766:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 76a:	8622                	mv	a2,s0
 76c:	00000097          	auipc	ra,0x0
 770:	e16080e7          	jalr	-490(ra) # 582 <vprintf>
}
 774:	60e2                	ld	ra,24(sp)
 776:	6442                	ld	s0,16(sp)
 778:	6161                	add	sp,sp,80
 77a:	8082                	ret

000000000000077c <printf>:

void
printf(const char *fmt, ...)
{
 77c:	711d                	add	sp,sp,-96
 77e:	ec06                	sd	ra,24(sp)
 780:	e822                	sd	s0,16(sp)
 782:	1000                	add	s0,sp,32
 784:	e40c                	sd	a1,8(s0)
 786:	e810                	sd	a2,16(s0)
 788:	ec14                	sd	a3,24(s0)
 78a:	f018                	sd	a4,32(s0)
 78c:	f41c                	sd	a5,40(s0)
 78e:	03043823          	sd	a6,48(s0)
 792:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 796:	00840613          	add	a2,s0,8
 79a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 79e:	85aa                	mv	a1,a0
 7a0:	4505                	li	a0,1
 7a2:	00000097          	auipc	ra,0x0
 7a6:	de0080e7          	jalr	-544(ra) # 582 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	add	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b2:	1141                	add	sp,sp,-16
 7b4:	e422                	sd	s0,8(sp)
 7b6:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	00001797          	auipc	a5,0x1
 7c0:	8447b783          	ld	a5,-1980(a5) # 1000 <freep>
 7c4:	a02d                	j	7ee <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7c6:	4618                	lw	a4,8(a2)
 7c8:	9f2d                	addw	a4,a4,a1
 7ca:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7ce:	6398                	ld	a4,0(a5)
 7d0:	6310                	ld	a2,0(a4)
 7d2:	a83d                	j	810 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7d4:	ff852703          	lw	a4,-8(a0)
 7d8:	9f31                	addw	a4,a4,a2
 7da:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7dc:	ff053683          	ld	a3,-16(a0)
 7e0:	a091                	j	824 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e2:	6398                	ld	a4,0(a5)
 7e4:	00e7e463          	bltu	a5,a4,7ec <free+0x3a>
 7e8:	00e6ea63          	bltu	a3,a4,7fc <free+0x4a>
{
 7ec:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ee:	fed7fae3          	bgeu	a5,a3,7e2 <free+0x30>
 7f2:	6398                	ld	a4,0(a5)
 7f4:	00e6e463          	bltu	a3,a4,7fc <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	fee7eae3          	bltu	a5,a4,7ec <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7fc:	ff852583          	lw	a1,-8(a0)
 800:	6390                	ld	a2,0(a5)
 802:	02059813          	sll	a6,a1,0x20
 806:	01c85713          	srl	a4,a6,0x1c
 80a:	9736                	add	a4,a4,a3
 80c:	fae60de3          	beq	a2,a4,7c6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 810:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 814:	4790                	lw	a2,8(a5)
 816:	02061593          	sll	a1,a2,0x20
 81a:	01c5d713          	srl	a4,a1,0x1c
 81e:	973e                	add	a4,a4,a5
 820:	fae68ae3          	beq	a3,a4,7d4 <free+0x22>
    p->s.ptr = bp->s.ptr;
 824:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 826:	00000717          	auipc	a4,0x0
 82a:	7cf73d23          	sd	a5,2010(a4) # 1000 <freep>
}
 82e:	6422                	ld	s0,8(sp)
 830:	0141                	add	sp,sp,16
 832:	8082                	ret

0000000000000834 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 834:	7139                	add	sp,sp,-64
 836:	fc06                	sd	ra,56(sp)
 838:	f822                	sd	s0,48(sp)
 83a:	f426                	sd	s1,40(sp)
 83c:	ec4e                	sd	s3,24(sp)
 83e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 840:	02051493          	sll	s1,a0,0x20
 844:	9081                	srl	s1,s1,0x20
 846:	04bd                	add	s1,s1,15
 848:	8091                	srl	s1,s1,0x4
 84a:	0014899b          	addw	s3,s1,1
 84e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 850:	00000517          	auipc	a0,0x0
 854:	7b053503          	ld	a0,1968(a0) # 1000 <freep>
 858:	c915                	beqz	a0,88c <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85c:	4798                	lw	a4,8(a5)
 85e:	08977e63          	bgeu	a4,s1,8fa <malloc+0xc6>
 862:	f04a                	sd	s2,32(sp)
 864:	e852                	sd	s4,16(sp)
 866:	e456                	sd	s5,8(sp)
 868:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86a:	8a4e                	mv	s4,s3
 86c:	0009871b          	sext.w	a4,s3
 870:	6685                	lui	a3,0x1
 872:	00d77363          	bgeu	a4,a3,878 <malloc+0x44>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 880:	00000917          	auipc	s2,0x0
 884:	78090913          	add	s2,s2,1920 # 1000 <freep>
  if(p == (char*)-1)
 888:	5afd                	li	s5,-1
 88a:	a091                	j	8ce <malloc+0x9a>
 88c:	f04a                	sd	s2,32(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	77c78793          	add	a5,a5,1916 # 1010 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8aa:	b7c1                	j	86a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	a08d                	j	912 <malloc+0xde>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b6:	0541                	add	a0,a0,16
 8b8:	00000097          	auipc	ra,0x0
 8bc:	efa080e7          	jalr	-262(ra) # 7b2 <free>
  return freep;
 8c0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8c4:	c13d                	beqz	a0,92a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c8:	4798                	lw	a4,8(a5)
 8ca:	02977463          	bgeu	a4,s1,8f2 <malloc+0xbe>
    if(p == freep)
 8ce:	00093703          	ld	a4,0(s2)
 8d2:	853e                	mv	a0,a5
 8d4:	fef719e3          	bne	a4,a5,8c6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 8d8:	8552                	mv	a0,s4
 8da:	00000097          	auipc	ra,0x0
 8de:	ba2080e7          	jalr	-1118(ra) # 47c <sbrk>
  if(p == (char*)-1)
 8e2:	fd5518e3          	bne	a0,s5,8b2 <malloc+0x7e>
        return 0;
 8e6:	4501                	li	a0,0
 8e8:	7902                	ld	s2,32(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	a03d                	j	91e <malloc+0xea>
 8f2:	7902                	ld	s2,32(sp)
 8f4:	6a42                	ld	s4,16(sp)
 8f6:	6aa2                	ld	s5,8(sp)
 8f8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8fa:	fae489e3          	beq	s1,a4,8ac <malloc+0x78>
        p->s.size -= nunits;
 8fe:	4137073b          	subw	a4,a4,s3
 902:	c798                	sw	a4,8(a5)
        p += p->s.size;
 904:	02071693          	sll	a3,a4,0x20
 908:	01c6d713          	srl	a4,a3,0x1c
 90c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 912:	00000717          	auipc	a4,0x0
 916:	6ea73723          	sd	a0,1774(a4) # 1000 <freep>
      return (void*)(p + 1);
 91a:	01078513          	add	a0,a5,16
  }
}
 91e:	70e2                	ld	ra,56(sp)
 920:	7442                	ld	s0,48(sp)
 922:	74a2                	ld	s1,40(sp)
 924:	69e2                	ld	s3,24(sp)
 926:	6121                	add	sp,sp,64
 928:	8082                	ret
 92a:	7902                	ld	s2,32(sp)
 92c:	6a42                	ld	s4,16(sp)
 92e:	6aa2                	ld	s5,8(sp)
 930:	6b02                	ld	s6,0(sp)
 932:	b7f5                	j	91e <malloc+0xea>
