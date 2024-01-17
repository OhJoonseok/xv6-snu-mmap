
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dd010113          	add	sp,sp,-560
   4:	22113423          	sd	ra,552(sp)
   8:	22813023          	sd	s0,544(sp)
   c:	20913c23          	sd	s1,536(sp)
  10:	21213823          	sd	s2,528(sp)
  14:	1c00                	add	s0,sp,560
  int fd, i;
  char path[] = "stressfs0";
  16:	00001797          	auipc	a5,0x1
  1a:	90a78793          	add	a5,a5,-1782 # 920 <malloc+0x136>
  1e:	6398                	ld	a4,0(a5)
  20:	fce43823          	sd	a4,-48(s0)
  24:	0087d783          	lhu	a5,8(a5)
  28:	fcf41c23          	sh	a5,-40(s0)
  char data[512];

  printf("stressfs starting\n");
  2c:	00001517          	auipc	a0,0x1
  30:	8c450513          	add	a0,a0,-1852 # 8f0 <malloc+0x106>
  34:	00000097          	auipc	ra,0x0
  38:	6fe080e7          	jalr	1790(ra) # 732 <printf>
  memset(data, 'a', sizeof(data));
  3c:	20000613          	li	a2,512
  40:	06100593          	li	a1,97
  44:	dd040513          	add	a0,s0,-560
  48:	00000097          	auipc	ra,0x0
  4c:	150080e7          	jalr	336(ra) # 198 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	00000097          	auipc	ra,0x0
  58:	34e080e7          	jalr	846(ra) # 3a2 <fork>
  5c:	00a04563          	bgtz	a0,66 <main+0x66>
  for(i = 0; i < 4; i++)
  60:	2485                	addw	s1,s1,1
  62:	ff2499e3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  66:	85a6                	mv	a1,s1
  68:	00001517          	auipc	a0,0x1
  6c:	8a050513          	add	a0,a0,-1888 # 908 <malloc+0x11e>
  70:	00000097          	auipc	ra,0x0
  74:	6c2080e7          	jalr	1730(ra) # 732 <printf>

  path[8] += i;
  78:	fd844783          	lbu	a5,-40(s0)
  7c:	9fa5                	addw	a5,a5,s1
  7e:	fcf40c23          	sb	a5,-40(s0)
  fd = open(path, O_CREATE | O_RDWR);
  82:	20200593          	li	a1,514
  86:	fd040513          	add	a0,s0,-48
  8a:	00000097          	auipc	ra,0x0
  8e:	360080e7          	jalr	864(ra) # 3ea <open>
  92:	892a                	mv	s2,a0
  94:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  96:	20000613          	li	a2,512
  9a:	dd040593          	add	a1,s0,-560
  9e:	854a                	mv	a0,s2
  a0:	00000097          	auipc	ra,0x0
  a4:	32a080e7          	jalr	810(ra) # 3ca <write>
  for(i = 0; i < 20; i++)
  a8:	34fd                	addw	s1,s1,-1
  aa:	f4f5                	bnez	s1,96 <main+0x96>
  close(fd);
  ac:	854a                	mv	a0,s2
  ae:	00000097          	auipc	ra,0x0
  b2:	324080e7          	jalr	804(ra) # 3d2 <close>

  printf("read\n");
  b6:	00001517          	auipc	a0,0x1
  ba:	86250513          	add	a0,a0,-1950 # 918 <malloc+0x12e>
  be:	00000097          	auipc	ra,0x0
  c2:	674080e7          	jalr	1652(ra) # 732 <printf>

  fd = open(path, O_RDONLY);
  c6:	4581                	li	a1,0
  c8:	fd040513          	add	a0,s0,-48
  cc:	00000097          	auipc	ra,0x0
  d0:	31e080e7          	jalr	798(ra) # 3ea <open>
  d4:	892a                	mv	s2,a0
  d6:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  d8:	20000613          	li	a2,512
  dc:	dd040593          	add	a1,s0,-560
  e0:	854a                	mv	a0,s2
  e2:	00000097          	auipc	ra,0x0
  e6:	2e0080e7          	jalr	736(ra) # 3c2 <read>
  for (i = 0; i < 20; i++)
  ea:	34fd                	addw	s1,s1,-1
  ec:	f4f5                	bnez	s1,d8 <main+0xd8>
  close(fd);
  ee:	854a                	mv	a0,s2
  f0:	00000097          	auipc	ra,0x0
  f4:	2e2080e7          	jalr	738(ra) # 3d2 <close>

  wait(0);
  f8:	4501                	li	a0,0
  fa:	00000097          	auipc	ra,0x0
  fe:	2b8080e7          	jalr	696(ra) # 3b2 <wait>

  exit(0);
 102:	4501                	li	a0,0
 104:	00000097          	auipc	ra,0x0
 108:	2a6080e7          	jalr	678(ra) # 3aa <exit>

000000000000010c <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 10c:	1141                	add	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	add	s0,sp,16
  extern int main();
  main();
 114:	00000097          	auipc	ra,0x0
 118:	eec080e7          	jalr	-276(ra) # 0 <main>
  exit(0);
 11c:	4501                	li	a0,0
 11e:	00000097          	auipc	ra,0x0
 122:	28c080e7          	jalr	652(ra) # 3aa <exit>

0000000000000126 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 126:	1141                	add	sp,sp,-16
 128:	e422                	sd	s0,8(sp)
 12a:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12c:	87aa                	mv	a5,a0
 12e:	0585                	add	a1,a1,1
 130:	0785                	add	a5,a5,1
 132:	fff5c703          	lbu	a4,-1(a1)
 136:	fee78fa3          	sb	a4,-1(a5)
 13a:	fb75                	bnez	a4,12e <strcpy+0x8>
    ;
  return os;
}
 13c:	6422                	ld	s0,8(sp)
 13e:	0141                	add	sp,sp,16
 140:	8082                	ret

0000000000000142 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 142:	1141                	add	sp,sp,-16
 144:	e422                	sd	s0,8(sp)
 146:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 148:	00054783          	lbu	a5,0(a0)
 14c:	cb91                	beqz	a5,160 <strcmp+0x1e>
 14e:	0005c703          	lbu	a4,0(a1)
 152:	00f71763          	bne	a4,a5,160 <strcmp+0x1e>
    p++, q++;
 156:	0505                	add	a0,a0,1
 158:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 15a:	00054783          	lbu	a5,0(a0)
 15e:	fbe5                	bnez	a5,14e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 160:	0005c503          	lbu	a0,0(a1)
}
 164:	40a7853b          	subw	a0,a5,a0
 168:	6422                	ld	s0,8(sp)
 16a:	0141                	add	sp,sp,16
 16c:	8082                	ret

000000000000016e <strlen>:

uint
strlen(const char *s)
{
 16e:	1141                	add	sp,sp,-16
 170:	e422                	sd	s0,8(sp)
 172:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 174:	00054783          	lbu	a5,0(a0)
 178:	cf91                	beqz	a5,194 <strlen+0x26>
 17a:	0505                	add	a0,a0,1
 17c:	87aa                	mv	a5,a0
 17e:	86be                	mv	a3,a5
 180:	0785                	add	a5,a5,1
 182:	fff7c703          	lbu	a4,-1(a5)
 186:	ff65                	bnez	a4,17e <strlen+0x10>
 188:	40a6853b          	subw	a0,a3,a0
 18c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 18e:	6422                	ld	s0,8(sp)
 190:	0141                	add	sp,sp,16
 192:	8082                	ret
  for(n = 0; s[n]; n++)
 194:	4501                	li	a0,0
 196:	bfe5                	j	18e <strlen+0x20>

0000000000000198 <memset>:

void*
memset(void *dst, int c, uint n)
{
 198:	1141                	add	sp,sp,-16
 19a:	e422                	sd	s0,8(sp)
 19c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 19e:	ca19                	beqz	a2,1b4 <memset+0x1c>
 1a0:	87aa                	mv	a5,a0
 1a2:	1602                	sll	a2,a2,0x20
 1a4:	9201                	srl	a2,a2,0x20
 1a6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1aa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1ae:	0785                	add	a5,a5,1
 1b0:	fee79de3          	bne	a5,a4,1aa <memset+0x12>
  }
  return dst;
}
 1b4:	6422                	ld	s0,8(sp)
 1b6:	0141                	add	sp,sp,16
 1b8:	8082                	ret

00000000000001ba <strchr>:

char*
strchr(const char *s, char c)
{
 1ba:	1141                	add	sp,sp,-16
 1bc:	e422                	sd	s0,8(sp)
 1be:	0800                	add	s0,sp,16
  for(; *s; s++)
 1c0:	00054783          	lbu	a5,0(a0)
 1c4:	cb99                	beqz	a5,1da <strchr+0x20>
    if(*s == c)
 1c6:	00f58763          	beq	a1,a5,1d4 <strchr+0x1a>
  for(; *s; s++)
 1ca:	0505                	add	a0,a0,1
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	fbfd                	bnez	a5,1c6 <strchr+0xc>
      return (char*)s;
  return 0;
 1d2:	4501                	li	a0,0
}
 1d4:	6422                	ld	s0,8(sp)
 1d6:	0141                	add	sp,sp,16
 1d8:	8082                	ret
  return 0;
 1da:	4501                	li	a0,0
 1dc:	bfe5                	j	1d4 <strchr+0x1a>

00000000000001de <gets>:

char*
gets(char *buf, int max)
{
 1de:	711d                	add	sp,sp,-96
 1e0:	ec86                	sd	ra,88(sp)
 1e2:	e8a2                	sd	s0,80(sp)
 1e4:	e4a6                	sd	s1,72(sp)
 1e6:	e0ca                	sd	s2,64(sp)
 1e8:	fc4e                	sd	s3,56(sp)
 1ea:	f852                	sd	s4,48(sp)
 1ec:	f456                	sd	s5,40(sp)
 1ee:	f05a                	sd	s6,32(sp)
 1f0:	ec5e                	sd	s7,24(sp)
 1f2:	1080                	add	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1fc:	4aa9                	li	s5,10
 1fe:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 200:	89a6                	mv	s3,s1
 202:	2485                	addw	s1,s1,1
 204:	0344d863          	bge	s1,s4,234 <gets+0x56>
    cc = read(0, &c, 1);
 208:	4605                	li	a2,1
 20a:	faf40593          	add	a1,s0,-81
 20e:	4501                	li	a0,0
 210:	00000097          	auipc	ra,0x0
 214:	1b2080e7          	jalr	434(ra) # 3c2 <read>
    if(cc < 1)
 218:	00a05e63          	blez	a0,234 <gets+0x56>
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	01578763          	beq	a5,s5,232 <gets+0x54>
 228:	0905                	add	s2,s2,1
 22a:	fd679be3          	bne	a5,s6,200 <gets+0x22>
    buf[i++] = c;
 22e:	89a6                	mv	s3,s1
 230:	a011                	j	234 <gets+0x56>
 232:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 234:	99de                	add	s3,s3,s7
 236:	00098023          	sb	zero,0(s3)
  return buf;
}
 23a:	855e                	mv	a0,s7
 23c:	60e6                	ld	ra,88(sp)
 23e:	6446                	ld	s0,80(sp)
 240:	64a6                	ld	s1,72(sp)
 242:	6906                	ld	s2,64(sp)
 244:	79e2                	ld	s3,56(sp)
 246:	7a42                	ld	s4,48(sp)
 248:	7aa2                	ld	s5,40(sp)
 24a:	7b02                	ld	s6,32(sp)
 24c:	6be2                	ld	s7,24(sp)
 24e:	6125                	add	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	add	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	add	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	00000097          	auipc	ra,0x0
 264:	18a080e7          	jalr	394(ra) # 3ea <open>
  if(fd < 0)
 268:	02054663          	bltz	a0,294 <stat+0x42>
 26c:	e426                	sd	s1,8(sp)
 26e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 270:	85ca                	mv	a1,s2
 272:	00000097          	auipc	ra,0x0
 276:	190080e7          	jalr	400(ra) # 402 <fstat>
 27a:	892a                	mv	s2,a0
  close(fd);
 27c:	8526                	mv	a0,s1
 27e:	00000097          	auipc	ra,0x0
 282:	154080e7          	jalr	340(ra) # 3d2 <close>
  return r;
 286:	64a2                	ld	s1,8(sp)
}
 288:	854a                	mv	a0,s2
 28a:	60e2                	ld	ra,24(sp)
 28c:	6442                	ld	s0,16(sp)
 28e:	6902                	ld	s2,0(sp)
 290:	6105                	add	sp,sp,32
 292:	8082                	ret
    return -1;
 294:	597d                	li	s2,-1
 296:	bfcd                	j	288 <stat+0x36>

0000000000000298 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 298:	1141                	add	sp,sp,-16
 29a:	e422                	sd	s0,8(sp)
 29c:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 29e:	00054703          	lbu	a4,0(a0)
 2a2:	02d00793          	li	a5,45
 2a6:	4585                	li	a1,1
 2a8:	04f70363          	beq	a4,a5,2ee <atoi+0x56>

  while('0' <= *s && *s <= '9')
 2ac:	00054703          	lbu	a4,0(a0)
 2b0:	fd07079b          	addw	a5,a4,-48
 2b4:	0ff7f793          	zext.b	a5,a5
 2b8:	46a5                	li	a3,9
 2ba:	02f6ed63          	bltu	a3,a5,2f4 <atoi+0x5c>
  int n = 0;
 2be:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 2c0:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 2c2:	0505                	add	a0,a0,1
 2c4:	0026979b          	sllw	a5,a3,0x2
 2c8:	9fb5                	addw	a5,a5,a3
 2ca:	0017979b          	sllw	a5,a5,0x1
 2ce:	9fb9                	addw	a5,a5,a4
 2d0:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 2d4:	00054703          	lbu	a4,0(a0)
 2d8:	fd07079b          	addw	a5,a4,-48
 2dc:	0ff7f793          	zext.b	a5,a5
 2e0:	fef671e3          	bgeu	a2,a5,2c2 <atoi+0x2a>
  return sign * n;
}
 2e4:	02d5853b          	mulw	a0,a1,a3
 2e8:	6422                	ld	s0,8(sp)
 2ea:	0141                	add	sp,sp,16
 2ec:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 2ee:	0505                	add	a0,a0,1
 2f0:	55fd                	li	a1,-1
 2f2:	bf6d                	j	2ac <atoi+0x14>
  int n = 0;
 2f4:	4681                	li	a3,0
 2f6:	b7fd                	j	2e4 <atoi+0x4c>

00000000000002f8 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2f8:	1141                	add	sp,sp,-16
 2fa:	e422                	sd	s0,8(sp)
 2fc:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2fe:	02b57463          	bgeu	a0,a1,326 <memmove+0x2e>
    while(n-- > 0)
 302:	00c05f63          	blez	a2,320 <memmove+0x28>
 306:	1602                	sll	a2,a2,0x20
 308:	9201                	srl	a2,a2,0x20
 30a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 30e:	872a                	mv	a4,a0
      *dst++ = *src++;
 310:	0585                	add	a1,a1,1
 312:	0705                	add	a4,a4,1
 314:	fff5c683          	lbu	a3,-1(a1)
 318:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 31c:	fef71ae3          	bne	a4,a5,310 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 320:	6422                	ld	s0,8(sp)
 322:	0141                	add	sp,sp,16
 324:	8082                	ret
    dst += n;
 326:	00c50733          	add	a4,a0,a2
    src += n;
 32a:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 32c:	fec05ae3          	blez	a2,320 <memmove+0x28>
 330:	fff6079b          	addw	a5,a2,-1
 334:	1782                	sll	a5,a5,0x20
 336:	9381                	srl	a5,a5,0x20
 338:	fff7c793          	not	a5,a5
 33c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 33e:	15fd                	add	a1,a1,-1
 340:	177d                	add	a4,a4,-1
 342:	0005c683          	lbu	a3,0(a1)
 346:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 34a:	fee79ae3          	bne	a5,a4,33e <memmove+0x46>
 34e:	bfc9                	j	320 <memmove+0x28>

0000000000000350 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 350:	1141                	add	sp,sp,-16
 352:	e422                	sd	s0,8(sp)
 354:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 356:	ca05                	beqz	a2,386 <memcmp+0x36>
 358:	fff6069b          	addw	a3,a2,-1
 35c:	1682                	sll	a3,a3,0x20
 35e:	9281                	srl	a3,a3,0x20
 360:	0685                	add	a3,a3,1
 362:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 364:	00054783          	lbu	a5,0(a0)
 368:	0005c703          	lbu	a4,0(a1)
 36c:	00e79863          	bne	a5,a4,37c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 370:	0505                	add	a0,a0,1
    p2++;
 372:	0585                	add	a1,a1,1
  while (n-- > 0) {
 374:	fed518e3          	bne	a0,a3,364 <memcmp+0x14>
  }
  return 0;
 378:	4501                	li	a0,0
 37a:	a019                	j	380 <memcmp+0x30>
      return *p1 - *p2;
 37c:	40e7853b          	subw	a0,a5,a4
}
 380:	6422                	ld	s0,8(sp)
 382:	0141                	add	sp,sp,16
 384:	8082                	ret
  return 0;
 386:	4501                	li	a0,0
 388:	bfe5                	j	380 <memcmp+0x30>

000000000000038a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 38a:	1141                	add	sp,sp,-16
 38c:	e406                	sd	ra,8(sp)
 38e:	e022                	sd	s0,0(sp)
 390:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 392:	00000097          	auipc	ra,0x0
 396:	f66080e7          	jalr	-154(ra) # 2f8 <memmove>
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	add	sp,sp,16
 3a0:	8082                	ret

00000000000003a2 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3a2:	4885                	li	a7,1
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <exit>:
.global exit
exit:
 li a7, SYS_exit
 3aa:	4889                	li	a7,2
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3b2:	488d                	li	a7,3
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ba:	4891                	li	a7,4
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <read>:
.global read
read:
 li a7, SYS_read
 3c2:	4895                	li	a7,5
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <write>:
.global write
write:
 li a7, SYS_write
 3ca:	48c1                	li	a7,16
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <close>:
.global close
close:
 li a7, SYS_close
 3d2:	48d5                	li	a7,21
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <kill>:
.global kill
kill:
 li a7, SYS_kill
 3da:	4899                	li	a7,6
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3e2:	489d                	li	a7,7
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <open>:
.global open
open:
 li a7, SYS_open
 3ea:	48bd                	li	a7,15
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3f2:	48c5                	li	a7,17
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3fa:	48c9                	li	a7,18
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 402:	48a1                	li	a7,8
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <link>:
.global link
link:
 li a7, SYS_link
 40a:	48cd                	li	a7,19
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 412:	48d1                	li	a7,20
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 41a:	48a5                	li	a7,9
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <dup>:
.global dup
dup:
 li a7, SYS_dup
 422:	48a9                	li	a7,10
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 42a:	48ad                	li	a7,11
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 432:	48b1                	li	a7,12
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 43a:	48b5                	li	a7,13
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 442:	48b9                	li	a7,14
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 44a:	48d9                	li	a7,22
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 452:	48dd                	li	a7,23
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 45a:	48e1                	li	a7,24
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 462:	48e5                	li	a7,25
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46a:	1101                	add	sp,sp,-32
 46c:	ec06                	sd	ra,24(sp)
 46e:	e822                	sd	s0,16(sp)
 470:	1000                	add	s0,sp,32
 472:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 476:	4605                	li	a2,1
 478:	fef40593          	add	a1,s0,-17
 47c:	00000097          	auipc	ra,0x0
 480:	f4e080e7          	jalr	-178(ra) # 3ca <write>
}
 484:	60e2                	ld	ra,24(sp)
 486:	6442                	ld	s0,16(sp)
 488:	6105                	add	sp,sp,32
 48a:	8082                	ret

000000000000048c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 48c:	7139                	add	sp,sp,-64
 48e:	fc06                	sd	ra,56(sp)
 490:	f822                	sd	s0,48(sp)
 492:	f426                	sd	s1,40(sp)
 494:	0080                	add	s0,sp,64
 496:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 498:	c299                	beqz	a3,49e <printint+0x12>
 49a:	0805cb63          	bltz	a1,530 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 49e:	2581                	sext.w	a1,a1
  neg = 0;
 4a0:	4881                	li	a7,0
 4a2:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 4a6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4a8:	2601                	sext.w	a2,a2
 4aa:	00000517          	auipc	a0,0x0
 4ae:	4e650513          	add	a0,a0,1254 # 990 <digits>
 4b2:	883a                	mv	a6,a4
 4b4:	2705                	addw	a4,a4,1
 4b6:	02c5f7bb          	remuw	a5,a1,a2
 4ba:	1782                	sll	a5,a5,0x20
 4bc:	9381                	srl	a5,a5,0x20
 4be:	97aa                	add	a5,a5,a0
 4c0:	0007c783          	lbu	a5,0(a5)
 4c4:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4c8:	0005879b          	sext.w	a5,a1
 4cc:	02c5d5bb          	divuw	a1,a1,a2
 4d0:	0685                	add	a3,a3,1
 4d2:	fec7f0e3          	bgeu	a5,a2,4b2 <printint+0x26>
  if(neg)
 4d6:	00088c63          	beqz	a7,4ee <printint+0x62>
    buf[i++] = '-';
 4da:	fd070793          	add	a5,a4,-48
 4de:	00878733          	add	a4,a5,s0
 4e2:	02d00793          	li	a5,45
 4e6:	fef70823          	sb	a5,-16(a4)
 4ea:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4ee:	02e05c63          	blez	a4,526 <printint+0x9a>
 4f2:	f04a                	sd	s2,32(sp)
 4f4:	ec4e                	sd	s3,24(sp)
 4f6:	fc040793          	add	a5,s0,-64
 4fa:	00e78933          	add	s2,a5,a4
 4fe:	fff78993          	add	s3,a5,-1
 502:	99ba                	add	s3,s3,a4
 504:	377d                	addw	a4,a4,-1
 506:	1702                	sll	a4,a4,0x20
 508:	9301                	srl	a4,a4,0x20
 50a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 50e:	fff94583          	lbu	a1,-1(s2)
 512:	8526                	mv	a0,s1
 514:	00000097          	auipc	ra,0x0
 518:	f56080e7          	jalr	-170(ra) # 46a <putc>
  while(--i >= 0)
 51c:	197d                	add	s2,s2,-1
 51e:	ff3918e3          	bne	s2,s3,50e <printint+0x82>
 522:	7902                	ld	s2,32(sp)
 524:	69e2                	ld	s3,24(sp)
}
 526:	70e2                	ld	ra,56(sp)
 528:	7442                	ld	s0,48(sp)
 52a:	74a2                	ld	s1,40(sp)
 52c:	6121                	add	sp,sp,64
 52e:	8082                	ret
    x = -xx;
 530:	40b005bb          	negw	a1,a1
    neg = 1;
 534:	4885                	li	a7,1
    x = -xx;
 536:	b7b5                	j	4a2 <printint+0x16>

0000000000000538 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 538:	715d                	add	sp,sp,-80
 53a:	e486                	sd	ra,72(sp)
 53c:	e0a2                	sd	s0,64(sp)
 53e:	f84a                	sd	s2,48(sp)
 540:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 542:	0005c903          	lbu	s2,0(a1)
 546:	1a090a63          	beqz	s2,6fa <vprintf+0x1c2>
 54a:	fc26                	sd	s1,56(sp)
 54c:	f44e                	sd	s3,40(sp)
 54e:	f052                	sd	s4,32(sp)
 550:	ec56                	sd	s5,24(sp)
 552:	e85a                	sd	s6,16(sp)
 554:	e45e                	sd	s7,8(sp)
 556:	8aaa                	mv	s5,a0
 558:	8bb2                	mv	s7,a2
 55a:	00158493          	add	s1,a1,1
  state = 0;
 55e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 560:	02500a13          	li	s4,37
 564:	4b55                	li	s6,21
 566:	a839                	j	584 <vprintf+0x4c>
        putc(fd, c);
 568:	85ca                	mv	a1,s2
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	efe080e7          	jalr	-258(ra) # 46a <putc>
 574:	a019                	j	57a <vprintf+0x42>
    } else if(state == '%'){
 576:	01498d63          	beq	s3,s4,590 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 57a:	0485                	add	s1,s1,1
 57c:	fff4c903          	lbu	s2,-1(s1)
 580:	16090763          	beqz	s2,6ee <vprintf+0x1b6>
    if(state == 0){
 584:	fe0999e3          	bnez	s3,576 <vprintf+0x3e>
      if(c == '%'){
 588:	ff4910e3          	bne	s2,s4,568 <vprintf+0x30>
        state = '%';
 58c:	89d2                	mv	s3,s4
 58e:	b7f5                	j	57a <vprintf+0x42>
      if(c == 'd'){
 590:	13490463          	beq	s2,s4,6b8 <vprintf+0x180>
 594:	f9d9079b          	addw	a5,s2,-99
 598:	0ff7f793          	zext.b	a5,a5
 59c:	12fb6763          	bltu	s6,a5,6ca <vprintf+0x192>
 5a0:	f9d9079b          	addw	a5,s2,-99
 5a4:	0ff7f713          	zext.b	a4,a5
 5a8:	12eb6163          	bltu	s6,a4,6ca <vprintf+0x192>
 5ac:	00271793          	sll	a5,a4,0x2
 5b0:	00000717          	auipc	a4,0x0
 5b4:	38870713          	add	a4,a4,904 # 938 <malloc+0x14e>
 5b8:	97ba                	add	a5,a5,a4
 5ba:	439c                	lw	a5,0(a5)
 5bc:	97ba                	add	a5,a5,a4
 5be:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5c0:	008b8913          	add	s2,s7,8
 5c4:	4685                	li	a3,1
 5c6:	4629                	li	a2,10
 5c8:	000ba583          	lw	a1,0(s7)
 5cc:	8556                	mv	a0,s5
 5ce:	00000097          	auipc	ra,0x0
 5d2:	ebe080e7          	jalr	-322(ra) # 48c <printint>
 5d6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5d8:	4981                	li	s3,0
 5da:	b745                	j	57a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5dc:	008b8913          	add	s2,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4629                	li	a2,10
 5e4:	000ba583          	lw	a1,0(s7)
 5e8:	8556                	mv	a0,s5
 5ea:	00000097          	auipc	ra,0x0
 5ee:	ea2080e7          	jalr	-350(ra) # 48c <printint>
 5f2:	8bca                	mv	s7,s2
      state = 0;
 5f4:	4981                	li	s3,0
 5f6:	b751                	j	57a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5f8:	008b8913          	add	s2,s7,8
 5fc:	4681                	li	a3,0
 5fe:	4641                	li	a2,16
 600:	000ba583          	lw	a1,0(s7)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	e86080e7          	jalr	-378(ra) # 48c <printint>
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	b7a5                	j	57a <vprintf+0x42>
 614:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 616:	008b8c13          	add	s8,s7,8
 61a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 61e:	03000593          	li	a1,48
 622:	8556                	mv	a0,s5
 624:	00000097          	auipc	ra,0x0
 628:	e46080e7          	jalr	-442(ra) # 46a <putc>
  putc(fd, 'x');
 62c:	07800593          	li	a1,120
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e38080e7          	jalr	-456(ra) # 46a <putc>
 63a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63c:	00000b97          	auipc	s7,0x0
 640:	354b8b93          	add	s7,s7,852 # 990 <digits>
 644:	03c9d793          	srl	a5,s3,0x3c
 648:	97de                	add	a5,a5,s7
 64a:	0007c583          	lbu	a1,0(a5)
 64e:	8556                	mv	a0,s5
 650:	00000097          	auipc	ra,0x0
 654:	e1a080e7          	jalr	-486(ra) # 46a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 658:	0992                	sll	s3,s3,0x4
 65a:	397d                	addw	s2,s2,-1
 65c:	fe0914e3          	bnez	s2,644 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 660:	8be2                	mv	s7,s8
      state = 0;
 662:	4981                	li	s3,0
 664:	6c02                	ld	s8,0(sp)
 666:	bf11                	j	57a <vprintf+0x42>
        s = va_arg(ap, char*);
 668:	008b8993          	add	s3,s7,8
 66c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 670:	02090163          	beqz	s2,692 <vprintf+0x15a>
        while(*s != 0){
 674:	00094583          	lbu	a1,0(s2)
 678:	c9a5                	beqz	a1,6e8 <vprintf+0x1b0>
          putc(fd, *s);
 67a:	8556                	mv	a0,s5
 67c:	00000097          	auipc	ra,0x0
 680:	dee080e7          	jalr	-530(ra) # 46a <putc>
          s++;
 684:	0905                	add	s2,s2,1
        while(*s != 0){
 686:	00094583          	lbu	a1,0(s2)
 68a:	f9e5                	bnez	a1,67a <vprintf+0x142>
        s = va_arg(ap, char*);
 68c:	8bce                	mv	s7,s3
      state = 0;
 68e:	4981                	li	s3,0
 690:	b5ed                	j	57a <vprintf+0x42>
          s = "(null)";
 692:	00000917          	auipc	s2,0x0
 696:	29e90913          	add	s2,s2,670 # 930 <malloc+0x146>
        while(*s != 0){
 69a:	02800593          	li	a1,40
 69e:	bff1                	j	67a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 6a0:	008b8913          	add	s2,s7,8
 6a4:	000bc583          	lbu	a1,0(s7)
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	dc0080e7          	jalr	-576(ra) # 46a <putc>
 6b2:	8bca                	mv	s7,s2
      state = 0;
 6b4:	4981                	li	s3,0
 6b6:	b5d1                	j	57a <vprintf+0x42>
        putc(fd, c);
 6b8:	02500593          	li	a1,37
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	dac080e7          	jalr	-596(ra) # 46a <putc>
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bd4d                	j	57a <vprintf+0x42>
        putc(fd, '%');
 6ca:	02500593          	li	a1,37
 6ce:	8556                	mv	a0,s5
 6d0:	00000097          	auipc	ra,0x0
 6d4:	d9a080e7          	jalr	-614(ra) # 46a <putc>
        putc(fd, c);
 6d8:	85ca                	mv	a1,s2
 6da:	8556                	mv	a0,s5
 6dc:	00000097          	auipc	ra,0x0
 6e0:	d8e080e7          	jalr	-626(ra) # 46a <putc>
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	bd51                	j	57a <vprintf+0x42>
        s = va_arg(ap, char*);
 6e8:	8bce                	mv	s7,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b579                	j	57a <vprintf+0x42>
 6ee:	74e2                	ld	s1,56(sp)
 6f0:	79a2                	ld	s3,40(sp)
 6f2:	7a02                	ld	s4,32(sp)
 6f4:	6ae2                	ld	s5,24(sp)
 6f6:	6b42                	ld	s6,16(sp)
 6f8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6fa:	60a6                	ld	ra,72(sp)
 6fc:	6406                	ld	s0,64(sp)
 6fe:	7942                	ld	s2,48(sp)
 700:	6161                	add	sp,sp,80
 702:	8082                	ret

0000000000000704 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 704:	715d                	add	sp,sp,-80
 706:	ec06                	sd	ra,24(sp)
 708:	e822                	sd	s0,16(sp)
 70a:	1000                	add	s0,sp,32
 70c:	e010                	sd	a2,0(s0)
 70e:	e414                	sd	a3,8(s0)
 710:	e818                	sd	a4,16(s0)
 712:	ec1c                	sd	a5,24(s0)
 714:	03043023          	sd	a6,32(s0)
 718:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 71c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 720:	8622                	mv	a2,s0
 722:	00000097          	auipc	ra,0x0
 726:	e16080e7          	jalr	-490(ra) # 538 <vprintf>
}
 72a:	60e2                	ld	ra,24(sp)
 72c:	6442                	ld	s0,16(sp)
 72e:	6161                	add	sp,sp,80
 730:	8082                	ret

0000000000000732 <printf>:

void
printf(const char *fmt, ...)
{
 732:	711d                	add	sp,sp,-96
 734:	ec06                	sd	ra,24(sp)
 736:	e822                	sd	s0,16(sp)
 738:	1000                	add	s0,sp,32
 73a:	e40c                	sd	a1,8(s0)
 73c:	e810                	sd	a2,16(s0)
 73e:	ec14                	sd	a3,24(s0)
 740:	f018                	sd	a4,32(s0)
 742:	f41c                	sd	a5,40(s0)
 744:	03043823          	sd	a6,48(s0)
 748:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 74c:	00840613          	add	a2,s0,8
 750:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 754:	85aa                	mv	a1,a0
 756:	4505                	li	a0,1
 758:	00000097          	auipc	ra,0x0
 75c:	de0080e7          	jalr	-544(ra) # 538 <vprintf>
}
 760:	60e2                	ld	ra,24(sp)
 762:	6442                	ld	s0,16(sp)
 764:	6125                	add	sp,sp,96
 766:	8082                	ret

0000000000000768 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 768:	1141                	add	sp,sp,-16
 76a:	e422                	sd	s0,8(sp)
 76c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 76e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 772:	00001797          	auipc	a5,0x1
 776:	88e7b783          	ld	a5,-1906(a5) # 1000 <freep>
 77a:	a02d                	j	7a4 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 77c:	4618                	lw	a4,8(a2)
 77e:	9f2d                	addw	a4,a4,a1
 780:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 784:	6398                	ld	a4,0(a5)
 786:	6310                	ld	a2,0(a4)
 788:	a83d                	j	7c6 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 78a:	ff852703          	lw	a4,-8(a0)
 78e:	9f31                	addw	a4,a4,a2
 790:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 792:	ff053683          	ld	a3,-16(a0)
 796:	a091                	j	7da <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	6398                	ld	a4,0(a5)
 79a:	00e7e463          	bltu	a5,a4,7a2 <free+0x3a>
 79e:	00e6ea63          	bltu	a3,a4,7b2 <free+0x4a>
{
 7a2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	fed7fae3          	bgeu	a5,a3,798 <free+0x30>
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e6e463          	bltu	a3,a4,7b2 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ae:	fee7eae3          	bltu	a5,a4,7a2 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 7b2:	ff852583          	lw	a1,-8(a0)
 7b6:	6390                	ld	a2,0(a5)
 7b8:	02059813          	sll	a6,a1,0x20
 7bc:	01c85713          	srl	a4,a6,0x1c
 7c0:	9736                	add	a4,a4,a3
 7c2:	fae60de3          	beq	a2,a4,77c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7ca:	4790                	lw	a2,8(a5)
 7cc:	02061593          	sll	a1,a2,0x20
 7d0:	01c5d713          	srl	a4,a1,0x1c
 7d4:	973e                	add	a4,a4,a5
 7d6:	fae68ae3          	beq	a3,a4,78a <free+0x22>
    p->s.ptr = bp->s.ptr;
 7da:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7dc:	00001717          	auipc	a4,0x1
 7e0:	82f73223          	sd	a5,-2012(a4) # 1000 <freep>
}
 7e4:	6422                	ld	s0,8(sp)
 7e6:	0141                	add	sp,sp,16
 7e8:	8082                	ret

00000000000007ea <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7ea:	7139                	add	sp,sp,-64
 7ec:	fc06                	sd	ra,56(sp)
 7ee:	f822                	sd	s0,48(sp)
 7f0:	f426                	sd	s1,40(sp)
 7f2:	ec4e                	sd	s3,24(sp)
 7f4:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7f6:	02051493          	sll	s1,a0,0x20
 7fa:	9081                	srl	s1,s1,0x20
 7fc:	04bd                	add	s1,s1,15
 7fe:	8091                	srl	s1,s1,0x4
 800:	0014899b          	addw	s3,s1,1
 804:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 806:	00000517          	auipc	a0,0x0
 80a:	7fa53503          	ld	a0,2042(a0) # 1000 <freep>
 80e:	c915                	beqz	a0,842 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 810:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 812:	4798                	lw	a4,8(a5)
 814:	08977e63          	bgeu	a4,s1,8b0 <malloc+0xc6>
 818:	f04a                	sd	s2,32(sp)
 81a:	e852                	sd	s4,16(sp)
 81c:	e456                	sd	s5,8(sp)
 81e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 820:	8a4e                	mv	s4,s3
 822:	0009871b          	sext.w	a4,s3
 826:	6685                	lui	a3,0x1
 828:	00d77363          	bgeu	a4,a3,82e <malloc+0x44>
 82c:	6a05                	lui	s4,0x1
 82e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 832:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 836:	00000917          	auipc	s2,0x0
 83a:	7ca90913          	add	s2,s2,1994 # 1000 <freep>
  if(p == (char*)-1)
 83e:	5afd                	li	s5,-1
 840:	a091                	j	884 <malloc+0x9a>
 842:	f04a                	sd	s2,32(sp)
 844:	e852                	sd	s4,16(sp)
 846:	e456                	sd	s5,8(sp)
 848:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 84a:	00000797          	auipc	a5,0x0
 84e:	7c678793          	add	a5,a5,1990 # 1010 <base>
 852:	00000717          	auipc	a4,0x0
 856:	7af73723          	sd	a5,1966(a4) # 1000 <freep>
 85a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 85c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 860:	b7c1                	j	820 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 862:	6398                	ld	a4,0(a5)
 864:	e118                	sd	a4,0(a0)
 866:	a08d                	j	8c8 <malloc+0xde>
  hp->s.size = nu;
 868:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 86c:	0541                	add	a0,a0,16
 86e:	00000097          	auipc	ra,0x0
 872:	efa080e7          	jalr	-262(ra) # 768 <free>
  return freep;
 876:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 87a:	c13d                	beqz	a0,8e0 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	02977463          	bgeu	a4,s1,8a8 <malloc+0xbe>
    if(p == freep)
 884:	00093703          	ld	a4,0(s2)
 888:	853e                	mv	a0,a5
 88a:	fef719e3          	bne	a4,a5,87c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 88e:	8552                	mv	a0,s4
 890:	00000097          	auipc	ra,0x0
 894:	ba2080e7          	jalr	-1118(ra) # 432 <sbrk>
  if(p == (char*)-1)
 898:	fd5518e3          	bne	a0,s5,868 <malloc+0x7e>
        return 0;
 89c:	4501                	li	a0,0
 89e:	7902                	ld	s2,32(sp)
 8a0:	6a42                	ld	s4,16(sp)
 8a2:	6aa2                	ld	s5,8(sp)
 8a4:	6b02                	ld	s6,0(sp)
 8a6:	a03d                	j	8d4 <malloc+0xea>
 8a8:	7902                	ld	s2,32(sp)
 8aa:	6a42                	ld	s4,16(sp)
 8ac:	6aa2                	ld	s5,8(sp)
 8ae:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8b0:	fae489e3          	beq	s1,a4,862 <malloc+0x78>
        p->s.size -= nunits;
 8b4:	4137073b          	subw	a4,a4,s3
 8b8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ba:	02071693          	sll	a3,a4,0x20
 8be:	01c6d713          	srl	a4,a3,0x1c
 8c2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c8:	00000717          	auipc	a4,0x0
 8cc:	72a73c23          	sd	a0,1848(a4) # 1000 <freep>
      return (void*)(p + 1);
 8d0:	01078513          	add	a0,a5,16
  }
}
 8d4:	70e2                	ld	ra,56(sp)
 8d6:	7442                	ld	s0,48(sp)
 8d8:	74a2                	ld	s1,40(sp)
 8da:	69e2                	ld	s3,24(sp)
 8dc:	6121                	add	sp,sp,64
 8de:	8082                	ret
 8e0:	7902                	ld	s2,32(sp)
 8e2:	6a42                	ld	s4,16(sp)
 8e4:	6aa2                	ld	s5,8(sp)
 8e6:	6b02                	ld	s6,0(sp)
 8e8:	b7f5                	j	8d4 <malloc+0xea>
