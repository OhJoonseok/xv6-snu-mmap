
user/_ktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <meminfo>:
#include "user/user.h"


void 
meminfo(char *s)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	add	s0,sp,48
   e:	84aa                	mv	s1,a0
  printf("%s: freemem=%d, used4k=%d, used2m=%d\n", 
  10:	4501                	li	a0,0
  12:	00000097          	auipc	ra,0x0
  16:	4d4080e7          	jalr	1236(ra) # 4e6 <kcall>
  1a:	892a                	mv	s2,a0
  1c:	4505                	li	a0,1
  1e:	00000097          	auipc	ra,0x0
  22:	4c8080e7          	jalr	1224(ra) # 4e6 <kcall>
  26:	89aa                	mv	s3,a0
  28:	4509                	li	a0,2
  2a:	00000097          	auipc	ra,0x0
  2e:	4bc080e7          	jalr	1212(ra) # 4e6 <kcall>
  32:	872a                	mv	a4,a0
  34:	86ce                	mv	a3,s3
  36:	864a                	mv	a2,s2
  38:	85a6                	mv	a1,s1
  3a:	00001517          	auipc	a0,0x1
  3e:	95650513          	add	a0,a0,-1706 # 990 <malloc+0x10a>
  42:	00000097          	auipc	ra,0x0
  46:	78c080e7          	jalr	1932(ra) # 7ce <printf>
      s, kcall(KC_FREEMEM), kcall(KC_USED4K), kcall(KC_USED2M));
}
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6942                	ld	s2,16(sp)
  52:	69a2                	ld	s3,8(sp)
  54:	6145                	add	sp,sp,48
  56:	8082                	ret

0000000000000058 <main>:

void
main(int argc, char *argv[])
{
  58:	7179                	add	sp,sp,-48
  5a:	f406                	sd	ra,40(sp)
  5c:	f022                	sd	s0,32(sp)
  5e:	ec26                	sd	s1,24(sp)
  60:	e84a                	sd	s2,16(sp)
  62:	e44e                	sd	s3,8(sp)
  64:	e052                	sd	s4,0(sp)
  66:	1800                	add	s0,sp,48
  void *pa;
  //void *pa_prev;


  meminfo("Init");
  68:	00001517          	auipc	a0,0x1
  6c:	95850513          	add	a0,a0,-1704 # 9c0 <malloc+0x13a>
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <meminfo>
  pa = ktest(KT_KALLOC_HUGE, 0);
  78:	4581                	li	a1,0
  7a:	4509                	li	a0,2
  7c:	00000097          	auipc	ra,0x0
  80:	472080e7          	jalr	1138(ra) # 4ee <ktest>
  meminfo("After KT_KALLOC_HUGE()");
  84:	00001517          	auipc	a0,0x1
  88:	94450513          	add	a0,a0,-1724 # 9c8 <malloc+0x142>
  8c:	00000097          	auipc	ra,0x0
  90:	f74080e7          	jalr	-140(ra) # 0 <meminfo>
  // ktest(KT_KFREE_HUGE, pa);
  // meminfo("After KT_KFREE_HUGE()");
  pa = ktest(KT_KALLOC, 0);
  94:	4581                	li	a1,0
  96:	4501                	li	a0,0
  98:	00000097          	auipc	ra,0x0
  9c:	456080e7          	jalr	1110(ra) # 4ee <ktest>
  a0:	84aa                	mv	s1,a0
  printf("%p\n",pa);
  a2:	85aa                	mv	a1,a0
  a4:	00001517          	auipc	a0,0x1
  a8:	93c50513          	add	a0,a0,-1732 # 9e0 <malloc+0x15a>
  ac:	00000097          	auipc	ra,0x0
  b0:	722080e7          	jalr	1826(ra) # 7ce <printf>
  meminfo("After KT_KALLOC()");
  b4:	00001517          	auipc	a0,0x1
  b8:	93450513          	add	a0,a0,-1740 # 9e8 <malloc+0x162>
  bc:	00000097          	auipc	ra,0x0
  c0:	f44080e7          	jalr	-188(ra) # 0 <meminfo>
  ktest(KT_KFREE, pa);
  c4:	85a6                	mv	a1,s1
  c6:	4505                	li	a0,1
  c8:	00000097          	auipc	ra,0x0
  cc:	426080e7          	jalr	1062(ra) # 4ee <ktest>
  meminfo("After KT_KFREE()");
  d0:	00001517          	auipc	a0,0x1
  d4:	93050513          	add	a0,a0,-1744 # a00 <malloc+0x17a>
  d8:	00000097          	auipc	ra,0x0
  dc:	f28080e7          	jalr	-216(ra) # 0 <meminfo>

  void* prev_pa = 0;
  for(int i=0; i< 40000; i++)  
  e0:	4901                	li	s2,0
  e2:	69a9                	lui	s3,0xa
  e4:	c4098993          	add	s3,s3,-960 # 9c40 <base+0x8c30>
  {
    prev_pa = pa;
    pa = ktest(KT_KALLOC, 0);
  e8:	8a26                	mv	s4,s1
  ea:	4581                	li	a1,0
  ec:	4501                	li	a0,0
  ee:	00000097          	auipc	ra,0x0
  f2:	400080e7          	jalr	1024(ra) # 4ee <ktest>
  f6:	84aa                	mv	s1,a0
    if(pa == 0)
  f8:	c509                	beqz	a0,102 <main+0xaa>
  for(int i=0; i< 40000; i++)  
  fa:	2905                	addw	s2,s2,1
  fc:	ff3916e3          	bne	s2,s3,e8 <main+0x90>
 100:	a819                	j	116 <main+0xbe>
    {
      printf("%d, %p\n",i, pa);
 102:	4601                	li	a2,0
 104:	85ca                	mv	a1,s2
 106:	00001517          	auipc	a0,0x1
 10a:	91250513          	add	a0,a0,-1774 # a18 <malloc+0x192>
 10e:	00000097          	auipc	ra,0x0
 112:	6c0080e7          	jalr	1728(ra) # 7ce <printf>
      break;
    }

  }
  meminfo("after loop");
 116:	00001517          	auipc	a0,0x1
 11a:	90a50513          	add	a0,a0,-1782 # a20 <malloc+0x19a>
 11e:	00000097          	auipc	ra,0x0
 122:	ee2080e7          	jalr	-286(ra) # 0 <meminfo>

//   meminfo("After kalloc(_huge loop)");
//  ktest(KT_KFREE_HUGE, pa);
//   meminfo("After kfree_huge()");

 ktest(KT_KFREE, prev_pa);
 126:	85d2                	mv	a1,s4
 128:	4505                	li	a0,1
 12a:	00000097          	auipc	ra,0x0
 12e:	3c4080e7          	jalr	964(ra) # 4ee <ktest>

  meminfo("After kfree()_prev");
 132:	00001517          	auipc	a0,0x1
 136:	8fe50513          	add	a0,a0,-1794 # a30 <malloc+0x1aa>
 13a:	00000097          	auipc	ra,0x0
 13e:	ec6080e7          	jalr	-314(ra) # 0 <meminfo>

    pa = ktest(KT_KALLOC, 0);
 142:	4581                	li	a1,0
 144:	4501                	li	a0,0
 146:	00000097          	auipc	ra,0x0
 14a:	3a8080e7          	jalr	936(ra) # 4ee <ktest>
 14e:	84aa                	mv	s1,a0
  meminfo("After kalloc()");
 150:	00001517          	auipc	a0,0x1
 154:	8f850513          	add	a0,a0,-1800 # a48 <malloc+0x1c2>
 158:	00000097          	auipc	ra,0x0
 15c:	ea8080e7          	jalr	-344(ra) # 0 <meminfo>
  ktest(KT_KFREE, pa);
 160:	85a6                	mv	a1,s1
 162:	4505                	li	a0,1
 164:	00000097          	auipc	ra,0x0
 168:	38a080e7          	jalr	906(ra) # 4ee <ktest>

  meminfo("After kfree()");
 16c:	00001517          	auipc	a0,0x1
 170:	8ec50513          	add	a0,a0,-1812 # a58 <malloc+0x1d2>
 174:	00000097          	auipc	ra,0x0
 178:	e8c080e7          	jalr	-372(ra) # 0 <meminfo>
 ktest(KT_KALLOC_HUGE, 0);
 17c:	4581                	li	a1,0
 17e:	4509                	li	a0,2
 180:	00000097          	auipc	ra,0x0
 184:	36e080e7          	jalr	878(ra) # 4ee <ktest>
  meminfo("After final huge alloc()");
 188:	00001517          	auipc	a0,0x1
 18c:	8e050513          	add	a0,a0,-1824 # a68 <malloc+0x1e2>
 190:	00000097          	auipc	ra,0x0
 194:	e70080e7          	jalr	-400(ra) # 0 <meminfo>
  return;
}
 198:	70a2                	ld	ra,40(sp)
 19a:	7402                	ld	s0,32(sp)
 19c:	64e2                	ld	s1,24(sp)
 19e:	6942                	ld	s2,16(sp)
 1a0:	69a2                	ld	s3,8(sp)
 1a2:	6a02                	ld	s4,0(sp)
 1a4:	6145                	add	sp,sp,48
 1a6:	8082                	ret

00000000000001a8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 1a8:	1141                	add	sp,sp,-16
 1aa:	e406                	sd	ra,8(sp)
 1ac:	e022                	sd	s0,0(sp)
 1ae:	0800                	add	s0,sp,16
  extern int main();
  main();
 1b0:	00000097          	auipc	ra,0x0
 1b4:	ea8080e7          	jalr	-344(ra) # 58 <main>
  exit(0);
 1b8:	4501                	li	a0,0
 1ba:	00000097          	auipc	ra,0x0
 1be:	28c080e7          	jalr	652(ra) # 446 <exit>

00000000000001c2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1c2:	1141                	add	sp,sp,-16
 1c4:	e422                	sd	s0,8(sp)
 1c6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1c8:	87aa                	mv	a5,a0
 1ca:	0585                	add	a1,a1,1
 1cc:	0785                	add	a5,a5,1
 1ce:	fff5c703          	lbu	a4,-1(a1)
 1d2:	fee78fa3          	sb	a4,-1(a5)
 1d6:	fb75                	bnez	a4,1ca <strcpy+0x8>
    ;
  return os;
}
 1d8:	6422                	ld	s0,8(sp)
 1da:	0141                	add	sp,sp,16
 1dc:	8082                	ret

00000000000001de <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1de:	1141                	add	sp,sp,-16
 1e0:	e422                	sd	s0,8(sp)
 1e2:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1e4:	00054783          	lbu	a5,0(a0)
 1e8:	cb91                	beqz	a5,1fc <strcmp+0x1e>
 1ea:	0005c703          	lbu	a4,0(a1)
 1ee:	00f71763          	bne	a4,a5,1fc <strcmp+0x1e>
    p++, q++;
 1f2:	0505                	add	a0,a0,1
 1f4:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	fbe5                	bnez	a5,1ea <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1fc:	0005c503          	lbu	a0,0(a1)
}
 200:	40a7853b          	subw	a0,a5,a0
 204:	6422                	ld	s0,8(sp)
 206:	0141                	add	sp,sp,16
 208:	8082                	ret

000000000000020a <strlen>:

uint
strlen(const char *s)
{
 20a:	1141                	add	sp,sp,-16
 20c:	e422                	sd	s0,8(sp)
 20e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 210:	00054783          	lbu	a5,0(a0)
 214:	cf91                	beqz	a5,230 <strlen+0x26>
 216:	0505                	add	a0,a0,1
 218:	87aa                	mv	a5,a0
 21a:	86be                	mv	a3,a5
 21c:	0785                	add	a5,a5,1
 21e:	fff7c703          	lbu	a4,-1(a5)
 222:	ff65                	bnez	a4,21a <strlen+0x10>
 224:	40a6853b          	subw	a0,a3,a0
 228:	2505                	addw	a0,a0,1
    ;
  return n;
}
 22a:	6422                	ld	s0,8(sp)
 22c:	0141                	add	sp,sp,16
 22e:	8082                	ret
  for(n = 0; s[n]; n++)
 230:	4501                	li	a0,0
 232:	bfe5                	j	22a <strlen+0x20>

0000000000000234 <memset>:

void*
memset(void *dst, int c, uint n)
{
 234:	1141                	add	sp,sp,-16
 236:	e422                	sd	s0,8(sp)
 238:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 23a:	ca19                	beqz	a2,250 <memset+0x1c>
 23c:	87aa                	mv	a5,a0
 23e:	1602                	sll	a2,a2,0x20
 240:	9201                	srl	a2,a2,0x20
 242:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 246:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 24a:	0785                	add	a5,a5,1
 24c:	fee79de3          	bne	a5,a4,246 <memset+0x12>
  }
  return dst;
}
 250:	6422                	ld	s0,8(sp)
 252:	0141                	add	sp,sp,16
 254:	8082                	ret

0000000000000256 <strchr>:

char*
strchr(const char *s, char c)
{
 256:	1141                	add	sp,sp,-16
 258:	e422                	sd	s0,8(sp)
 25a:	0800                	add	s0,sp,16
  for(; *s; s++)
 25c:	00054783          	lbu	a5,0(a0)
 260:	cb99                	beqz	a5,276 <strchr+0x20>
    if(*s == c)
 262:	00f58763          	beq	a1,a5,270 <strchr+0x1a>
  for(; *s; s++)
 266:	0505                	add	a0,a0,1
 268:	00054783          	lbu	a5,0(a0)
 26c:	fbfd                	bnez	a5,262 <strchr+0xc>
      return (char*)s;
  return 0;
 26e:	4501                	li	a0,0
}
 270:	6422                	ld	s0,8(sp)
 272:	0141                	add	sp,sp,16
 274:	8082                	ret
  return 0;
 276:	4501                	li	a0,0
 278:	bfe5                	j	270 <strchr+0x1a>

000000000000027a <gets>:

char*
gets(char *buf, int max)
{
 27a:	711d                	add	sp,sp,-96
 27c:	ec86                	sd	ra,88(sp)
 27e:	e8a2                	sd	s0,80(sp)
 280:	e4a6                	sd	s1,72(sp)
 282:	e0ca                	sd	s2,64(sp)
 284:	fc4e                	sd	s3,56(sp)
 286:	f852                	sd	s4,48(sp)
 288:	f456                	sd	s5,40(sp)
 28a:	f05a                	sd	s6,32(sp)
 28c:	ec5e                	sd	s7,24(sp)
 28e:	1080                	add	s0,sp,96
 290:	8baa                	mv	s7,a0
 292:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 294:	892a                	mv	s2,a0
 296:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 298:	4aa9                	li	s5,10
 29a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 29c:	89a6                	mv	s3,s1
 29e:	2485                	addw	s1,s1,1
 2a0:	0344d863          	bge	s1,s4,2d0 <gets+0x56>
    cc = read(0, &c, 1);
 2a4:	4605                	li	a2,1
 2a6:	faf40593          	add	a1,s0,-81
 2aa:	4501                	li	a0,0
 2ac:	00000097          	auipc	ra,0x0
 2b0:	1b2080e7          	jalr	434(ra) # 45e <read>
    if(cc < 1)
 2b4:	00a05e63          	blez	a0,2d0 <gets+0x56>
    buf[i++] = c;
 2b8:	faf44783          	lbu	a5,-81(s0)
 2bc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2c0:	01578763          	beq	a5,s5,2ce <gets+0x54>
 2c4:	0905                	add	s2,s2,1
 2c6:	fd679be3          	bne	a5,s6,29c <gets+0x22>
    buf[i++] = c;
 2ca:	89a6                	mv	s3,s1
 2cc:	a011                	j	2d0 <gets+0x56>
 2ce:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2d0:	99de                	add	s3,s3,s7
 2d2:	00098023          	sb	zero,0(s3)
  return buf;
}
 2d6:	855e                	mv	a0,s7
 2d8:	60e6                	ld	ra,88(sp)
 2da:	6446                	ld	s0,80(sp)
 2dc:	64a6                	ld	s1,72(sp)
 2de:	6906                	ld	s2,64(sp)
 2e0:	79e2                	ld	s3,56(sp)
 2e2:	7a42                	ld	s4,48(sp)
 2e4:	7aa2                	ld	s5,40(sp)
 2e6:	7b02                	ld	s6,32(sp)
 2e8:	6be2                	ld	s7,24(sp)
 2ea:	6125                	add	sp,sp,96
 2ec:	8082                	ret

00000000000002ee <stat>:

int
stat(const char *n, struct stat *st)
{
 2ee:	1101                	add	sp,sp,-32
 2f0:	ec06                	sd	ra,24(sp)
 2f2:	e822                	sd	s0,16(sp)
 2f4:	e04a                	sd	s2,0(sp)
 2f6:	1000                	add	s0,sp,32
 2f8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2fa:	4581                	li	a1,0
 2fc:	00000097          	auipc	ra,0x0
 300:	18a080e7          	jalr	394(ra) # 486 <open>
  if(fd < 0)
 304:	02054663          	bltz	a0,330 <stat+0x42>
 308:	e426                	sd	s1,8(sp)
 30a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 30c:	85ca                	mv	a1,s2
 30e:	00000097          	auipc	ra,0x0
 312:	190080e7          	jalr	400(ra) # 49e <fstat>
 316:	892a                	mv	s2,a0
  close(fd);
 318:	8526                	mv	a0,s1
 31a:	00000097          	auipc	ra,0x0
 31e:	154080e7          	jalr	340(ra) # 46e <close>
  return r;
 322:	64a2                	ld	s1,8(sp)
}
 324:	854a                	mv	a0,s2
 326:	60e2                	ld	ra,24(sp)
 328:	6442                	ld	s0,16(sp)
 32a:	6902                	ld	s2,0(sp)
 32c:	6105                	add	sp,sp,32
 32e:	8082                	ret
    return -1;
 330:	597d                	li	s2,-1
 332:	bfcd                	j	324 <stat+0x36>

0000000000000334 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 334:	1141                	add	sp,sp,-16
 336:	e422                	sd	s0,8(sp)
 338:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 33a:	00054703          	lbu	a4,0(a0)
 33e:	02d00793          	li	a5,45
 342:	4585                	li	a1,1
 344:	04f70363          	beq	a4,a5,38a <atoi+0x56>

  while('0' <= *s && *s <= '9')
 348:	00054703          	lbu	a4,0(a0)
 34c:	fd07079b          	addw	a5,a4,-48
 350:	0ff7f793          	zext.b	a5,a5
 354:	46a5                	li	a3,9
 356:	02f6ed63          	bltu	a3,a5,390 <atoi+0x5c>
  int n = 0;
 35a:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 35c:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 35e:	0505                	add	a0,a0,1
 360:	0026979b          	sllw	a5,a3,0x2
 364:	9fb5                	addw	a5,a5,a3
 366:	0017979b          	sllw	a5,a5,0x1
 36a:	9fb9                	addw	a5,a5,a4
 36c:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 370:	00054703          	lbu	a4,0(a0)
 374:	fd07079b          	addw	a5,a4,-48
 378:	0ff7f793          	zext.b	a5,a5
 37c:	fef671e3          	bgeu	a2,a5,35e <atoi+0x2a>
  return sign * n;
}
 380:	02d5853b          	mulw	a0,a1,a3
 384:	6422                	ld	s0,8(sp)
 386:	0141                	add	sp,sp,16
 388:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 38a:	0505                	add	a0,a0,1
 38c:	55fd                	li	a1,-1
 38e:	bf6d                	j	348 <atoi+0x14>
  int n = 0;
 390:	4681                	li	a3,0
 392:	b7fd                	j	380 <atoi+0x4c>

0000000000000394 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 394:	1141                	add	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39a:	02b57463          	bgeu	a0,a1,3c2 <memmove+0x2e>
    while(n-- > 0)
 39e:	00c05f63          	blez	a2,3bc <memmove+0x28>
 3a2:	1602                	sll	a2,a2,0x20
 3a4:	9201                	srl	a2,a2,0x20
 3a6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3aa:	872a                	mv	a4,a0
      *dst++ = *src++;
 3ac:	0585                	add	a1,a1,1
 3ae:	0705                	add	a4,a4,1
 3b0:	fff5c683          	lbu	a3,-1(a1)
 3b4:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3b8:	fef71ae3          	bne	a4,a5,3ac <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3bc:	6422                	ld	s0,8(sp)
 3be:	0141                	add	sp,sp,16
 3c0:	8082                	ret
    dst += n;
 3c2:	00c50733          	add	a4,a0,a2
    src += n;
 3c6:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3c8:	fec05ae3          	blez	a2,3bc <memmove+0x28>
 3cc:	fff6079b          	addw	a5,a2,-1
 3d0:	1782                	sll	a5,a5,0x20
 3d2:	9381                	srl	a5,a5,0x20
 3d4:	fff7c793          	not	a5,a5
 3d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3da:	15fd                	add	a1,a1,-1
 3dc:	177d                	add	a4,a4,-1
 3de:	0005c683          	lbu	a3,0(a1)
 3e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3e6:	fee79ae3          	bne	a5,a4,3da <memmove+0x46>
 3ea:	bfc9                	j	3bc <memmove+0x28>

00000000000003ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3ec:	1141                	add	sp,sp,-16
 3ee:	e422                	sd	s0,8(sp)
 3f0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f2:	ca05                	beqz	a2,422 <memcmp+0x36>
 3f4:	fff6069b          	addw	a3,a2,-1
 3f8:	1682                	sll	a3,a3,0x20
 3fa:	9281                	srl	a3,a3,0x20
 3fc:	0685                	add	a3,a3,1
 3fe:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 400:	00054783          	lbu	a5,0(a0)
 404:	0005c703          	lbu	a4,0(a1)
 408:	00e79863          	bne	a5,a4,418 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 40c:	0505                	add	a0,a0,1
    p2++;
 40e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 410:	fed518e3          	bne	a0,a3,400 <memcmp+0x14>
  }
  return 0;
 414:	4501                	li	a0,0
 416:	a019                	j	41c <memcmp+0x30>
      return *p1 - *p2;
 418:	40e7853b          	subw	a0,a5,a4
}
 41c:	6422                	ld	s0,8(sp)
 41e:	0141                	add	sp,sp,16
 420:	8082                	ret
  return 0;
 422:	4501                	li	a0,0
 424:	bfe5                	j	41c <memcmp+0x30>

0000000000000426 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 426:	1141                	add	sp,sp,-16
 428:	e406                	sd	ra,8(sp)
 42a:	e022                	sd	s0,0(sp)
 42c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 42e:	00000097          	auipc	ra,0x0
 432:	f66080e7          	jalr	-154(ra) # 394 <memmove>
}
 436:	60a2                	ld	ra,8(sp)
 438:	6402                	ld	s0,0(sp)
 43a:	0141                	add	sp,sp,16
 43c:	8082                	ret

000000000000043e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 43e:	4885                	li	a7,1
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <exit>:
.global exit
exit:
 li a7, SYS_exit
 446:	4889                	li	a7,2
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <wait>:
.global wait
wait:
 li a7, SYS_wait
 44e:	488d                	li	a7,3
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 456:	4891                	li	a7,4
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <read>:
.global read
read:
 li a7, SYS_read
 45e:	4895                	li	a7,5
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <write>:
.global write
write:
 li a7, SYS_write
 466:	48c1                	li	a7,16
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <close>:
.global close
close:
 li a7, SYS_close
 46e:	48d5                	li	a7,21
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <kill>:
.global kill
kill:
 li a7, SYS_kill
 476:	4899                	li	a7,6
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <exec>:
.global exec
exec:
 li a7, SYS_exec
 47e:	489d                	li	a7,7
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <open>:
.global open
open:
 li a7, SYS_open
 486:	48bd                	li	a7,15
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 48e:	48c5                	li	a7,17
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 496:	48c9                	li	a7,18
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 49e:	48a1                	li	a7,8
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <link>:
.global link
link:
 li a7, SYS_link
 4a6:	48cd                	li	a7,19
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ae:	48d1                	li	a7,20
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4b6:	48a5                	li	a7,9
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <dup>:
.global dup
dup:
 li a7, SYS_dup
 4be:	48a9                	li	a7,10
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4c6:	48ad                	li	a7,11
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4ce:	48b1                	li	a7,12
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4d6:	48b5                	li	a7,13
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4de:	48b9                	li	a7,14
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 4e6:	48d9                	li	a7,22
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 4ee:	48dd                	li	a7,23
 ecall
 4f0:	00000073          	ecall
 ret
 4f4:	8082                	ret

00000000000004f6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 4f6:	48e1                	li	a7,24
 ecall
 4f8:	00000073          	ecall
 ret
 4fc:	8082                	ret

00000000000004fe <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 4fe:	48e5                	li	a7,25
 ecall
 500:	00000073          	ecall
 ret
 504:	8082                	ret

0000000000000506 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 506:	1101                	add	sp,sp,-32
 508:	ec06                	sd	ra,24(sp)
 50a:	e822                	sd	s0,16(sp)
 50c:	1000                	add	s0,sp,32
 50e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 512:	4605                	li	a2,1
 514:	fef40593          	add	a1,s0,-17
 518:	00000097          	auipc	ra,0x0
 51c:	f4e080e7          	jalr	-178(ra) # 466 <write>
}
 520:	60e2                	ld	ra,24(sp)
 522:	6442                	ld	s0,16(sp)
 524:	6105                	add	sp,sp,32
 526:	8082                	ret

0000000000000528 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 528:	7139                	add	sp,sp,-64
 52a:	fc06                	sd	ra,56(sp)
 52c:	f822                	sd	s0,48(sp)
 52e:	f426                	sd	s1,40(sp)
 530:	0080                	add	s0,sp,64
 532:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 534:	c299                	beqz	a3,53a <printint+0x12>
 536:	0805cb63          	bltz	a1,5cc <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 53a:	2581                	sext.w	a1,a1
  neg = 0;
 53c:	4881                	li	a7,0
 53e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 542:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 544:	2601                	sext.w	a2,a2
 546:	00000517          	auipc	a0,0x0
 54a:	5a250513          	add	a0,a0,1442 # ae8 <digits>
 54e:	883a                	mv	a6,a4
 550:	2705                	addw	a4,a4,1
 552:	02c5f7bb          	remuw	a5,a1,a2
 556:	1782                	sll	a5,a5,0x20
 558:	9381                	srl	a5,a5,0x20
 55a:	97aa                	add	a5,a5,a0
 55c:	0007c783          	lbu	a5,0(a5)
 560:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 564:	0005879b          	sext.w	a5,a1
 568:	02c5d5bb          	divuw	a1,a1,a2
 56c:	0685                	add	a3,a3,1
 56e:	fec7f0e3          	bgeu	a5,a2,54e <printint+0x26>
  if(neg)
 572:	00088c63          	beqz	a7,58a <printint+0x62>
    buf[i++] = '-';
 576:	fd070793          	add	a5,a4,-48
 57a:	00878733          	add	a4,a5,s0
 57e:	02d00793          	li	a5,45
 582:	fef70823          	sb	a5,-16(a4)
 586:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 58a:	02e05c63          	blez	a4,5c2 <printint+0x9a>
 58e:	f04a                	sd	s2,32(sp)
 590:	ec4e                	sd	s3,24(sp)
 592:	fc040793          	add	a5,s0,-64
 596:	00e78933          	add	s2,a5,a4
 59a:	fff78993          	add	s3,a5,-1
 59e:	99ba                	add	s3,s3,a4
 5a0:	377d                	addw	a4,a4,-1
 5a2:	1702                	sll	a4,a4,0x20
 5a4:	9301                	srl	a4,a4,0x20
 5a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5aa:	fff94583          	lbu	a1,-1(s2)
 5ae:	8526                	mv	a0,s1
 5b0:	00000097          	auipc	ra,0x0
 5b4:	f56080e7          	jalr	-170(ra) # 506 <putc>
  while(--i >= 0)
 5b8:	197d                	add	s2,s2,-1
 5ba:	ff3918e3          	bne	s2,s3,5aa <printint+0x82>
 5be:	7902                	ld	s2,32(sp)
 5c0:	69e2                	ld	s3,24(sp)
}
 5c2:	70e2                	ld	ra,56(sp)
 5c4:	7442                	ld	s0,48(sp)
 5c6:	74a2                	ld	s1,40(sp)
 5c8:	6121                	add	sp,sp,64
 5ca:	8082                	ret
    x = -xx;
 5cc:	40b005bb          	negw	a1,a1
    neg = 1;
 5d0:	4885                	li	a7,1
    x = -xx;
 5d2:	b7b5                	j	53e <printint+0x16>

00000000000005d4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d4:	715d                	add	sp,sp,-80
 5d6:	e486                	sd	ra,72(sp)
 5d8:	e0a2                	sd	s0,64(sp)
 5da:	f84a                	sd	s2,48(sp)
 5dc:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5de:	0005c903          	lbu	s2,0(a1)
 5e2:	1a090a63          	beqz	s2,796 <vprintf+0x1c2>
 5e6:	fc26                	sd	s1,56(sp)
 5e8:	f44e                	sd	s3,40(sp)
 5ea:	f052                	sd	s4,32(sp)
 5ec:	ec56                	sd	s5,24(sp)
 5ee:	e85a                	sd	s6,16(sp)
 5f0:	e45e                	sd	s7,8(sp)
 5f2:	8aaa                	mv	s5,a0
 5f4:	8bb2                	mv	s7,a2
 5f6:	00158493          	add	s1,a1,1
  state = 0;
 5fa:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5fc:	02500a13          	li	s4,37
 600:	4b55                	li	s6,21
 602:	a839                	j	620 <vprintf+0x4c>
        putc(fd, c);
 604:	85ca                	mv	a1,s2
 606:	8556                	mv	a0,s5
 608:	00000097          	auipc	ra,0x0
 60c:	efe080e7          	jalr	-258(ra) # 506 <putc>
 610:	a019                	j	616 <vprintf+0x42>
    } else if(state == '%'){
 612:	01498d63          	beq	s3,s4,62c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 616:	0485                	add	s1,s1,1
 618:	fff4c903          	lbu	s2,-1(s1)
 61c:	16090763          	beqz	s2,78a <vprintf+0x1b6>
    if(state == 0){
 620:	fe0999e3          	bnez	s3,612 <vprintf+0x3e>
      if(c == '%'){
 624:	ff4910e3          	bne	s2,s4,604 <vprintf+0x30>
        state = '%';
 628:	89d2                	mv	s3,s4
 62a:	b7f5                	j	616 <vprintf+0x42>
      if(c == 'd'){
 62c:	13490463          	beq	s2,s4,754 <vprintf+0x180>
 630:	f9d9079b          	addw	a5,s2,-99
 634:	0ff7f793          	zext.b	a5,a5
 638:	12fb6763          	bltu	s6,a5,766 <vprintf+0x192>
 63c:	f9d9079b          	addw	a5,s2,-99
 640:	0ff7f713          	zext.b	a4,a5
 644:	12eb6163          	bltu	s6,a4,766 <vprintf+0x192>
 648:	00271793          	sll	a5,a4,0x2
 64c:	00000717          	auipc	a4,0x0
 650:	44470713          	add	a4,a4,1092 # a90 <malloc+0x20a>
 654:	97ba                	add	a5,a5,a4
 656:	439c                	lw	a5,0(a5)
 658:	97ba                	add	a5,a5,a4
 65a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 65c:	008b8913          	add	s2,s7,8
 660:	4685                	li	a3,1
 662:	4629                	li	a2,10
 664:	000ba583          	lw	a1,0(s7)
 668:	8556                	mv	a0,s5
 66a:	00000097          	auipc	ra,0x0
 66e:	ebe080e7          	jalr	-322(ra) # 528 <printint>
 672:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 674:	4981                	li	s3,0
 676:	b745                	j	616 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	008b8913          	add	s2,s7,8
 67c:	4681                	li	a3,0
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	ea2080e7          	jalr	-350(ra) # 528 <printint>
 68e:	8bca                	mv	s7,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b751                	j	616 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 694:	008b8913          	add	s2,s7,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000ba583          	lw	a1,0(s7)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e86080e7          	jalr	-378(ra) # 528 <printint>
 6aa:	8bca                	mv	s7,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	b7a5                	j	616 <vprintf+0x42>
 6b0:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 6b2:	008b8c13          	add	s8,s7,8
 6b6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ba:	03000593          	li	a1,48
 6be:	8556                	mv	a0,s5
 6c0:	00000097          	auipc	ra,0x0
 6c4:	e46080e7          	jalr	-442(ra) # 506 <putc>
  putc(fd, 'x');
 6c8:	07800593          	li	a1,120
 6cc:	8556                	mv	a0,s5
 6ce:	00000097          	auipc	ra,0x0
 6d2:	e38080e7          	jalr	-456(ra) # 506 <putc>
 6d6:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d8:	00000b97          	auipc	s7,0x0
 6dc:	410b8b93          	add	s7,s7,1040 # ae8 <digits>
 6e0:	03c9d793          	srl	a5,s3,0x3c
 6e4:	97de                	add	a5,a5,s7
 6e6:	0007c583          	lbu	a1,0(a5)
 6ea:	8556                	mv	a0,s5
 6ec:	00000097          	auipc	ra,0x0
 6f0:	e1a080e7          	jalr	-486(ra) # 506 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6f4:	0992                	sll	s3,s3,0x4
 6f6:	397d                	addw	s2,s2,-1
 6f8:	fe0914e3          	bnez	s2,6e0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6fc:	8be2                	mv	s7,s8
      state = 0;
 6fe:	4981                	li	s3,0
 700:	6c02                	ld	s8,0(sp)
 702:	bf11                	j	616 <vprintf+0x42>
        s = va_arg(ap, char*);
 704:	008b8993          	add	s3,s7,8
 708:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 70c:	02090163          	beqz	s2,72e <vprintf+0x15a>
        while(*s != 0){
 710:	00094583          	lbu	a1,0(s2)
 714:	c9a5                	beqz	a1,784 <vprintf+0x1b0>
          putc(fd, *s);
 716:	8556                	mv	a0,s5
 718:	00000097          	auipc	ra,0x0
 71c:	dee080e7          	jalr	-530(ra) # 506 <putc>
          s++;
 720:	0905                	add	s2,s2,1
        while(*s != 0){
 722:	00094583          	lbu	a1,0(s2)
 726:	f9e5                	bnez	a1,716 <vprintf+0x142>
        s = va_arg(ap, char*);
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b5ed                	j	616 <vprintf+0x42>
          s = "(null)";
 72e:	00000917          	auipc	s2,0x0
 732:	35a90913          	add	s2,s2,858 # a88 <malloc+0x202>
        while(*s != 0){
 736:	02800593          	li	a1,40
 73a:	bff1                	j	716 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 73c:	008b8913          	add	s2,s7,8
 740:	000bc583          	lbu	a1,0(s7)
 744:	8556                	mv	a0,s5
 746:	00000097          	auipc	ra,0x0
 74a:	dc0080e7          	jalr	-576(ra) # 506 <putc>
 74e:	8bca                	mv	s7,s2
      state = 0;
 750:	4981                	li	s3,0
 752:	b5d1                	j	616 <vprintf+0x42>
        putc(fd, c);
 754:	02500593          	li	a1,37
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	dac080e7          	jalr	-596(ra) # 506 <putc>
      state = 0;
 762:	4981                	li	s3,0
 764:	bd4d                	j	616 <vprintf+0x42>
        putc(fd, '%');
 766:	02500593          	li	a1,37
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	d9a080e7          	jalr	-614(ra) # 506 <putc>
        putc(fd, c);
 774:	85ca                	mv	a1,s2
 776:	8556                	mv	a0,s5
 778:	00000097          	auipc	ra,0x0
 77c:	d8e080e7          	jalr	-626(ra) # 506 <putc>
      state = 0;
 780:	4981                	li	s3,0
 782:	bd51                	j	616 <vprintf+0x42>
        s = va_arg(ap, char*);
 784:	8bce                	mv	s7,s3
      state = 0;
 786:	4981                	li	s3,0
 788:	b579                	j	616 <vprintf+0x42>
 78a:	74e2                	ld	s1,56(sp)
 78c:	79a2                	ld	s3,40(sp)
 78e:	7a02                	ld	s4,32(sp)
 790:	6ae2                	ld	s5,24(sp)
 792:	6b42                	ld	s6,16(sp)
 794:	6ba2                	ld	s7,8(sp)
    }
  }
}
 796:	60a6                	ld	ra,72(sp)
 798:	6406                	ld	s0,64(sp)
 79a:	7942                	ld	s2,48(sp)
 79c:	6161                	add	sp,sp,80
 79e:	8082                	ret

00000000000007a0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a0:	715d                	add	sp,sp,-80
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	add	s0,sp,32
 7a8:	e010                	sd	a2,0(s0)
 7aa:	e414                	sd	a3,8(s0)
 7ac:	e818                	sd	a4,16(s0)
 7ae:	ec1c                	sd	a5,24(s0)
 7b0:	03043023          	sd	a6,32(s0)
 7b4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7bc:	8622                	mv	a2,s0
 7be:	00000097          	auipc	ra,0x0
 7c2:	e16080e7          	jalr	-490(ra) # 5d4 <vprintf>
}
 7c6:	60e2                	ld	ra,24(sp)
 7c8:	6442                	ld	s0,16(sp)
 7ca:	6161                	add	sp,sp,80
 7cc:	8082                	ret

00000000000007ce <printf>:

void
printf(const char *fmt, ...)
{
 7ce:	711d                	add	sp,sp,-96
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	add	s0,sp,32
 7d6:	e40c                	sd	a1,8(s0)
 7d8:	e810                	sd	a2,16(s0)
 7da:	ec14                	sd	a3,24(s0)
 7dc:	f018                	sd	a4,32(s0)
 7de:	f41c                	sd	a5,40(s0)
 7e0:	03043823          	sd	a6,48(s0)
 7e4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e8:	00840613          	add	a2,s0,8
 7ec:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f0:	85aa                	mv	a1,a0
 7f2:	4505                	li	a0,1
 7f4:	00000097          	auipc	ra,0x0
 7f8:	de0080e7          	jalr	-544(ra) # 5d4 <vprintf>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6125                	add	sp,sp,96
 802:	8082                	ret

0000000000000804 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 804:	1141                	add	sp,sp,-16
 806:	e422                	sd	s0,8(sp)
 808:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80e:	00000797          	auipc	a5,0x0
 812:	7f27b783          	ld	a5,2034(a5) # 1000 <freep>
 816:	a02d                	j	840 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 818:	4618                	lw	a4,8(a2)
 81a:	9f2d                	addw	a4,a4,a1
 81c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 820:	6398                	ld	a4,0(a5)
 822:	6310                	ld	a2,0(a4)
 824:	a83d                	j	862 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 826:	ff852703          	lw	a4,-8(a0)
 82a:	9f31                	addw	a4,a4,a2
 82c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 82e:	ff053683          	ld	a3,-16(a0)
 832:	a091                	j	876 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 834:	6398                	ld	a4,0(a5)
 836:	00e7e463          	bltu	a5,a4,83e <free+0x3a>
 83a:	00e6ea63          	bltu	a3,a4,84e <free+0x4a>
{
 83e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 840:	fed7fae3          	bgeu	a5,a3,834 <free+0x30>
 844:	6398                	ld	a4,0(a5)
 846:	00e6e463          	bltu	a3,a4,84e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84a:	fee7eae3          	bltu	a5,a4,83e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 84e:	ff852583          	lw	a1,-8(a0)
 852:	6390                	ld	a2,0(a5)
 854:	02059813          	sll	a6,a1,0x20
 858:	01c85713          	srl	a4,a6,0x1c
 85c:	9736                	add	a4,a4,a3
 85e:	fae60de3          	beq	a2,a4,818 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 862:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 866:	4790                	lw	a2,8(a5)
 868:	02061593          	sll	a1,a2,0x20
 86c:	01c5d713          	srl	a4,a1,0x1c
 870:	973e                	add	a4,a4,a5
 872:	fae68ae3          	beq	a3,a4,826 <free+0x22>
    p->s.ptr = bp->s.ptr;
 876:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 878:	00000717          	auipc	a4,0x0
 87c:	78f73423          	sd	a5,1928(a4) # 1000 <freep>
}
 880:	6422                	ld	s0,8(sp)
 882:	0141                	add	sp,sp,16
 884:	8082                	ret

0000000000000886 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 886:	7139                	add	sp,sp,-64
 888:	fc06                	sd	ra,56(sp)
 88a:	f822                	sd	s0,48(sp)
 88c:	f426                	sd	s1,40(sp)
 88e:	ec4e                	sd	s3,24(sp)
 890:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 892:	02051493          	sll	s1,a0,0x20
 896:	9081                	srl	s1,s1,0x20
 898:	04bd                	add	s1,s1,15
 89a:	8091                	srl	s1,s1,0x4
 89c:	0014899b          	addw	s3,s1,1
 8a0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 8a2:	00000517          	auipc	a0,0x0
 8a6:	75e53503          	ld	a0,1886(a0) # 1000 <freep>
 8aa:	c915                	beqz	a0,8de <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ac:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8ae:	4798                	lw	a4,8(a5)
 8b0:	08977e63          	bgeu	a4,s1,94c <malloc+0xc6>
 8b4:	f04a                	sd	s2,32(sp)
 8b6:	e852                	sd	s4,16(sp)
 8b8:	e456                	sd	s5,8(sp)
 8ba:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8bc:	8a4e                	mv	s4,s3
 8be:	0009871b          	sext.w	a4,s3
 8c2:	6685                	lui	a3,0x1
 8c4:	00d77363          	bgeu	a4,a3,8ca <malloc+0x44>
 8c8:	6a05                	lui	s4,0x1
 8ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8ce:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d2:	00000917          	auipc	s2,0x0
 8d6:	72e90913          	add	s2,s2,1838 # 1000 <freep>
  if(p == (char*)-1)
 8da:	5afd                	li	s5,-1
 8dc:	a091                	j	920 <malloc+0x9a>
 8de:	f04a                	sd	s2,32(sp)
 8e0:	e852                	sd	s4,16(sp)
 8e2:	e456                	sd	s5,8(sp)
 8e4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e6:	00000797          	auipc	a5,0x0
 8ea:	72a78793          	add	a5,a5,1834 # 1010 <base>
 8ee:	00000717          	auipc	a4,0x0
 8f2:	70f73923          	sd	a5,1810(a4) # 1000 <freep>
 8f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fc:	b7c1                	j	8bc <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8fe:	6398                	ld	a4,0(a5)
 900:	e118                	sd	a4,0(a0)
 902:	a08d                	j	964 <malloc+0xde>
  hp->s.size = nu;
 904:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 908:	0541                	add	a0,a0,16
 90a:	00000097          	auipc	ra,0x0
 90e:	efa080e7          	jalr	-262(ra) # 804 <free>
  return freep;
 912:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 916:	c13d                	beqz	a0,97c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 918:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 91a:	4798                	lw	a4,8(a5)
 91c:	02977463          	bgeu	a4,s1,944 <malloc+0xbe>
    if(p == freep)
 920:	00093703          	ld	a4,0(s2)
 924:	853e                	mv	a0,a5
 926:	fef719e3          	bne	a4,a5,918 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 92a:	8552                	mv	a0,s4
 92c:	00000097          	auipc	ra,0x0
 930:	ba2080e7          	jalr	-1118(ra) # 4ce <sbrk>
  if(p == (char*)-1)
 934:	fd5518e3          	bne	a0,s5,904 <malloc+0x7e>
        return 0;
 938:	4501                	li	a0,0
 93a:	7902                	ld	s2,32(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
 942:	a03d                	j	970 <malloc+0xea>
 944:	7902                	ld	s2,32(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 94c:	fae489e3          	beq	s1,a4,8fe <malloc+0x78>
        p->s.size -= nunits;
 950:	4137073b          	subw	a4,a4,s3
 954:	c798                	sw	a4,8(a5)
        p += p->s.size;
 956:	02071693          	sll	a3,a4,0x20
 95a:	01c6d713          	srl	a4,a3,0x1c
 95e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 960:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 964:	00000717          	auipc	a4,0x0
 968:	68a73e23          	sd	a0,1692(a4) # 1000 <freep>
      return (void*)(p + 1);
 96c:	01078513          	add	a0,a5,16
  }
}
 970:	70e2                	ld	ra,56(sp)
 972:	7442                	ld	s0,48(sp)
 974:	74a2                	ld	s1,40(sp)
 976:	69e2                	ld	s3,24(sp)
 978:	6121                	add	sp,sp,64
 97a:	8082                	ret
 97c:	7902                	ld	s2,32(sp)
 97e:	6a42                	ld	s4,16(sp)
 980:	6aa2                	ld	s5,8(sp)
 982:	6b02                	ld	s6,0(sp)
 984:	b7f5                	j	970 <malloc+0xea>
