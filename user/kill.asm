
user/_kill:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char **argv)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
   8:	4785                	li	a5,1
   a:	02a7df63          	bge	a5,a0,48 <main+0x48>
   e:	e426                	sd	s1,8(sp)
  10:	e04a                	sd	s2,0(sp)
  12:	00858493          	add	s1,a1,8
  16:	ffe5091b          	addw	s2,a0,-2
  1a:	02091793          	sll	a5,s2,0x20
  1e:	01d7d913          	srl	s2,a5,0x1d
  22:	05c1                	add	a1,a1,16
  24:	992e                	add	s2,s2,a1
    fprintf(2, "usage: kill pid...\n");
    exit(1);
  }
  for(i=1; i<argc; i++)
    kill(atoi(argv[i]));
  26:	6088                	ld	a0,0(s1)
  28:	00000097          	auipc	ra,0x0
  2c:	1cc080e7          	jalr	460(ra) # 1f4 <atoi>
  30:	00000097          	auipc	ra,0x0
  34:	306080e7          	jalr	774(ra) # 336 <kill>
  for(i=1; i<argc; i++)
  38:	04a1                	add	s1,s1,8
  3a:	ff2496e3          	bne	s1,s2,26 <main+0x26>
  exit(0);
  3e:	4501                	li	a0,0
  40:	00000097          	auipc	ra,0x0
  44:	2c6080e7          	jalr	710(ra) # 306 <exit>
  48:	e426                	sd	s1,8(sp)
  4a:	e04a                	sd	s2,0(sp)
    fprintf(2, "usage: kill pid...\n");
  4c:	00001597          	auipc	a1,0x1
  50:	80458593          	add	a1,a1,-2044 # 850 <malloc+0x10a>
  54:	4509                	li	a0,2
  56:	00000097          	auipc	ra,0x0
  5a:	60a080e7          	jalr	1546(ra) # 660 <fprintf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	00000097          	auipc	ra,0x0
  64:	2a6080e7          	jalr	678(ra) # 306 <exit>

0000000000000068 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  68:	1141                	add	sp,sp,-16
  6a:	e406                	sd	ra,8(sp)
  6c:	e022                	sd	s0,0(sp)
  6e:	0800                	add	s0,sp,16
  extern int main();
  main();
  70:	00000097          	auipc	ra,0x0
  74:	f90080e7          	jalr	-112(ra) # 0 <main>
  exit(0);
  78:	4501                	li	a0,0
  7a:	00000097          	auipc	ra,0x0
  7e:	28c080e7          	jalr	652(ra) # 306 <exit>

0000000000000082 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  82:	1141                	add	sp,sp,-16
  84:	e422                	sd	s0,8(sp)
  86:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  88:	87aa                	mv	a5,a0
  8a:	0585                	add	a1,a1,1
  8c:	0785                	add	a5,a5,1
  8e:	fff5c703          	lbu	a4,-1(a1)
  92:	fee78fa3          	sb	a4,-1(a5)
  96:	fb75                	bnez	a4,8a <strcpy+0x8>
    ;
  return os;
}
  98:	6422                	ld	s0,8(sp)
  9a:	0141                	add	sp,sp,16
  9c:	8082                	ret

000000000000009e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9e:	1141                	add	sp,sp,-16
  a0:	e422                	sd	s0,8(sp)
  a2:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x1e>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x1e>
    p++, q++;
  b2:	0505                	add	a0,a0,1
  b4:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	6422                	ld	s0,8(sp)
  c6:	0141                	add	sp,sp,16
  c8:	8082                	ret

00000000000000ca <strlen>:

uint
strlen(const char *s)
{
  ca:	1141                	add	sp,sp,-16
  cc:	e422                	sd	s0,8(sp)
  ce:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  d0:	00054783          	lbu	a5,0(a0)
  d4:	cf91                	beqz	a5,f0 <strlen+0x26>
  d6:	0505                	add	a0,a0,1
  d8:	87aa                	mv	a5,a0
  da:	86be                	mv	a3,a5
  dc:	0785                	add	a5,a5,1
  de:	fff7c703          	lbu	a4,-1(a5)
  e2:	ff65                	bnez	a4,da <strlen+0x10>
  e4:	40a6853b          	subw	a0,a3,a0
  e8:	2505                	addw	a0,a0,1
    ;
  return n;
}
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	add	sp,sp,16
  ee:	8082                	ret
  for(n = 0; s[n]; n++)
  f0:	4501                	li	a0,0
  f2:	bfe5                	j	ea <strlen+0x20>

00000000000000f4 <memset>:

void*
memset(void *dst, int c, uint n)
{
  f4:	1141                	add	sp,sp,-16
  f6:	e422                	sd	s0,8(sp)
  f8:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  fa:	ca19                	beqz	a2,110 <memset+0x1c>
  fc:	87aa                	mv	a5,a0
  fe:	1602                	sll	a2,a2,0x20
 100:	9201                	srl	a2,a2,0x20
 102:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 106:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 10a:	0785                	add	a5,a5,1
 10c:	fee79de3          	bne	a5,a4,106 <memset+0x12>
  }
  return dst;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret

0000000000000116 <strchr>:

char*
strchr(const char *s, char c)
{
 116:	1141                	add	sp,sp,-16
 118:	e422                	sd	s0,8(sp)
 11a:	0800                	add	s0,sp,16
  for(; *s; s++)
 11c:	00054783          	lbu	a5,0(a0)
 120:	cb99                	beqz	a5,136 <strchr+0x20>
    if(*s == c)
 122:	00f58763          	beq	a1,a5,130 <strchr+0x1a>
  for(; *s; s++)
 126:	0505                	add	a0,a0,1
 128:	00054783          	lbu	a5,0(a0)
 12c:	fbfd                	bnez	a5,122 <strchr+0xc>
      return (char*)s;
  return 0;
 12e:	4501                	li	a0,0
}
 130:	6422                	ld	s0,8(sp)
 132:	0141                	add	sp,sp,16
 134:	8082                	ret
  return 0;
 136:	4501                	li	a0,0
 138:	bfe5                	j	130 <strchr+0x1a>

000000000000013a <gets>:

char*
gets(char *buf, int max)
{
 13a:	711d                	add	sp,sp,-96
 13c:	ec86                	sd	ra,88(sp)
 13e:	e8a2                	sd	s0,80(sp)
 140:	e4a6                	sd	s1,72(sp)
 142:	e0ca                	sd	s2,64(sp)
 144:	fc4e                	sd	s3,56(sp)
 146:	f852                	sd	s4,48(sp)
 148:	f456                	sd	s5,40(sp)
 14a:	f05a                	sd	s6,32(sp)
 14c:	ec5e                	sd	s7,24(sp)
 14e:	1080                	add	s0,sp,96
 150:	8baa                	mv	s7,a0
 152:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 154:	892a                	mv	s2,a0
 156:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 158:	4aa9                	li	s5,10
 15a:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 15c:	89a6                	mv	s3,s1
 15e:	2485                	addw	s1,s1,1
 160:	0344d863          	bge	s1,s4,190 <gets+0x56>
    cc = read(0, &c, 1);
 164:	4605                	li	a2,1
 166:	faf40593          	add	a1,s0,-81
 16a:	4501                	li	a0,0
 16c:	00000097          	auipc	ra,0x0
 170:	1b2080e7          	jalr	434(ra) # 31e <read>
    if(cc < 1)
 174:	00a05e63          	blez	a0,190 <gets+0x56>
    buf[i++] = c;
 178:	faf44783          	lbu	a5,-81(s0)
 17c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 180:	01578763          	beq	a5,s5,18e <gets+0x54>
 184:	0905                	add	s2,s2,1
 186:	fd679be3          	bne	a5,s6,15c <gets+0x22>
    buf[i++] = c;
 18a:	89a6                	mv	s3,s1
 18c:	a011                	j	190 <gets+0x56>
 18e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 190:	99de                	add	s3,s3,s7
 192:	00098023          	sb	zero,0(s3)
  return buf;
}
 196:	855e                	mv	a0,s7
 198:	60e6                	ld	ra,88(sp)
 19a:	6446                	ld	s0,80(sp)
 19c:	64a6                	ld	s1,72(sp)
 19e:	6906                	ld	s2,64(sp)
 1a0:	79e2                	ld	s3,56(sp)
 1a2:	7a42                	ld	s4,48(sp)
 1a4:	7aa2                	ld	s5,40(sp)
 1a6:	7b02                	ld	s6,32(sp)
 1a8:	6be2                	ld	s7,24(sp)
 1aa:	6125                	add	sp,sp,96
 1ac:	8082                	ret

00000000000001ae <stat>:

int
stat(const char *n, struct stat *st)
{
 1ae:	1101                	add	sp,sp,-32
 1b0:	ec06                	sd	ra,24(sp)
 1b2:	e822                	sd	s0,16(sp)
 1b4:	e04a                	sd	s2,0(sp)
 1b6:	1000                	add	s0,sp,32
 1b8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ba:	4581                	li	a1,0
 1bc:	00000097          	auipc	ra,0x0
 1c0:	18a080e7          	jalr	394(ra) # 346 <open>
  if(fd < 0)
 1c4:	02054663          	bltz	a0,1f0 <stat+0x42>
 1c8:	e426                	sd	s1,8(sp)
 1ca:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1cc:	85ca                	mv	a1,s2
 1ce:	00000097          	auipc	ra,0x0
 1d2:	190080e7          	jalr	400(ra) # 35e <fstat>
 1d6:	892a                	mv	s2,a0
  close(fd);
 1d8:	8526                	mv	a0,s1
 1da:	00000097          	auipc	ra,0x0
 1de:	154080e7          	jalr	340(ra) # 32e <close>
  return r;
 1e2:	64a2                	ld	s1,8(sp)
}
 1e4:	854a                	mv	a0,s2
 1e6:	60e2                	ld	ra,24(sp)
 1e8:	6442                	ld	s0,16(sp)
 1ea:	6902                	ld	s2,0(sp)
 1ec:	6105                	add	sp,sp,32
 1ee:	8082                	ret
    return -1;
 1f0:	597d                	li	s2,-1
 1f2:	bfcd                	j	1e4 <stat+0x36>

00000000000001f4 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 1f4:	1141                	add	sp,sp,-16
 1f6:	e422                	sd	s0,8(sp)
 1f8:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 1fa:	00054703          	lbu	a4,0(a0)
 1fe:	02d00793          	li	a5,45
 202:	4585                	li	a1,1
 204:	04f70363          	beq	a4,a5,24a <atoi+0x56>

  while('0' <= *s && *s <= '9')
 208:	00054703          	lbu	a4,0(a0)
 20c:	fd07079b          	addw	a5,a4,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	46a5                	li	a3,9
 216:	02f6ed63          	bltu	a3,a5,250 <atoi+0x5c>
  int n = 0;
 21a:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 21c:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 21e:	0505                	add	a0,a0,1
 220:	0026979b          	sllw	a5,a3,0x2
 224:	9fb5                	addw	a5,a5,a3
 226:	0017979b          	sllw	a5,a5,0x1
 22a:	9fb9                	addw	a5,a5,a4
 22c:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 230:	00054703          	lbu	a4,0(a0)
 234:	fd07079b          	addw	a5,a4,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	fef671e3          	bgeu	a2,a5,21e <atoi+0x2a>
  return sign * n;
}
 240:	02d5853b          	mulw	a0,a1,a3
 244:	6422                	ld	s0,8(sp)
 246:	0141                	add	sp,sp,16
 248:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 24a:	0505                	add	a0,a0,1
 24c:	55fd                	li	a1,-1
 24e:	bf6d                	j	208 <atoi+0x14>
  int n = 0;
 250:	4681                	li	a3,0
 252:	b7fd                	j	240 <atoi+0x4c>

0000000000000254 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 254:	1141                	add	sp,sp,-16
 256:	e422                	sd	s0,8(sp)
 258:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 25a:	02b57463          	bgeu	a0,a1,282 <memmove+0x2e>
    while(n-- > 0)
 25e:	00c05f63          	blez	a2,27c <memmove+0x28>
 262:	1602                	sll	a2,a2,0x20
 264:	9201                	srl	a2,a2,0x20
 266:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 26a:	872a                	mv	a4,a0
      *dst++ = *src++;
 26c:	0585                	add	a1,a1,1
 26e:	0705                	add	a4,a4,1
 270:	fff5c683          	lbu	a3,-1(a1)
 274:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 278:	fef71ae3          	bne	a4,a5,26c <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 27c:	6422                	ld	s0,8(sp)
 27e:	0141                	add	sp,sp,16
 280:	8082                	ret
    dst += n;
 282:	00c50733          	add	a4,a0,a2
    src += n;
 286:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 288:	fec05ae3          	blez	a2,27c <memmove+0x28>
 28c:	fff6079b          	addw	a5,a2,-1
 290:	1782                	sll	a5,a5,0x20
 292:	9381                	srl	a5,a5,0x20
 294:	fff7c793          	not	a5,a5
 298:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 29a:	15fd                	add	a1,a1,-1
 29c:	177d                	add	a4,a4,-1
 29e:	0005c683          	lbu	a3,0(a1)
 2a2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a6:	fee79ae3          	bne	a5,a4,29a <memmove+0x46>
 2aa:	bfc9                	j	27c <memmove+0x28>

00000000000002ac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2ac:	1141                	add	sp,sp,-16
 2ae:	e422                	sd	s0,8(sp)
 2b0:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b2:	ca05                	beqz	a2,2e2 <memcmp+0x36>
 2b4:	fff6069b          	addw	a3,a2,-1
 2b8:	1682                	sll	a3,a3,0x20
 2ba:	9281                	srl	a3,a3,0x20
 2bc:	0685                	add	a3,a3,1
 2be:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2c0:	00054783          	lbu	a5,0(a0)
 2c4:	0005c703          	lbu	a4,0(a1)
 2c8:	00e79863          	bne	a5,a4,2d8 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2cc:	0505                	add	a0,a0,1
    p2++;
 2ce:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2d0:	fed518e3          	bne	a0,a3,2c0 <memcmp+0x14>
  }
  return 0;
 2d4:	4501                	li	a0,0
 2d6:	a019                	j	2dc <memcmp+0x30>
      return *p1 - *p2;
 2d8:	40e7853b          	subw	a0,a5,a4
}
 2dc:	6422                	ld	s0,8(sp)
 2de:	0141                	add	sp,sp,16
 2e0:	8082                	ret
  return 0;
 2e2:	4501                	li	a0,0
 2e4:	bfe5                	j	2dc <memcmp+0x30>

00000000000002e6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e6:	1141                	add	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2ee:	00000097          	auipc	ra,0x0
 2f2:	f66080e7          	jalr	-154(ra) # 254 <memmove>
}
 2f6:	60a2                	ld	ra,8(sp)
 2f8:	6402                	ld	s0,0(sp)
 2fa:	0141                	add	sp,sp,16
 2fc:	8082                	ret

00000000000002fe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fe:	4885                	li	a7,1
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <exit>:
.global exit
exit:
 li a7, SYS_exit
 306:	4889                	li	a7,2
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <wait>:
.global wait
wait:
 li a7, SYS_wait
 30e:	488d                	li	a7,3
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 316:	4891                	li	a7,4
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <read>:
.global read
read:
 li a7, SYS_read
 31e:	4895                	li	a7,5
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <write>:
.global write
write:
 li a7, SYS_write
 326:	48c1                	li	a7,16
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <close>:
.global close
close:
 li a7, SYS_close
 32e:	48d5                	li	a7,21
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <kill>:
.global kill
kill:
 li a7, SYS_kill
 336:	4899                	li	a7,6
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <exec>:
.global exec
exec:
 li a7, SYS_exec
 33e:	489d                	li	a7,7
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <open>:
.global open
open:
 li a7, SYS_open
 346:	48bd                	li	a7,15
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34e:	48c5                	li	a7,17
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 356:	48c9                	li	a7,18
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35e:	48a1                	li	a7,8
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <link>:
.global link
link:
 li a7, SYS_link
 366:	48cd                	li	a7,19
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36e:	48d1                	li	a7,20
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 376:	48a5                	li	a7,9
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <dup>:
.global dup
dup:
 li a7, SYS_dup
 37e:	48a9                	li	a7,10
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 386:	48ad                	li	a7,11
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 38e:	48b1                	li	a7,12
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 396:	48b5                	li	a7,13
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39e:	48b9                	li	a7,14
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 3a6:	48d9                	li	a7,22
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 3ae:	48dd                	li	a7,23
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3b6:	48e1                	li	a7,24
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3be:	48e5                	li	a7,25
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c6:	1101                	add	sp,sp,-32
 3c8:	ec06                	sd	ra,24(sp)
 3ca:	e822                	sd	s0,16(sp)
 3cc:	1000                	add	s0,sp,32
 3ce:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3d2:	4605                	li	a2,1
 3d4:	fef40593          	add	a1,s0,-17
 3d8:	00000097          	auipc	ra,0x0
 3dc:	f4e080e7          	jalr	-178(ra) # 326 <write>
}
 3e0:	60e2                	ld	ra,24(sp)
 3e2:	6442                	ld	s0,16(sp)
 3e4:	6105                	add	sp,sp,32
 3e6:	8082                	ret

00000000000003e8 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e8:	7139                	add	sp,sp,-64
 3ea:	fc06                	sd	ra,56(sp)
 3ec:	f822                	sd	s0,48(sp)
 3ee:	f426                	sd	s1,40(sp)
 3f0:	0080                	add	s0,sp,64
 3f2:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f4:	c299                	beqz	a3,3fa <printint+0x12>
 3f6:	0805cb63          	bltz	a1,48c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3fa:	2581                	sext.w	a1,a1
  neg = 0;
 3fc:	4881                	li	a7,0
 3fe:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 402:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 404:	2601                	sext.w	a2,a2
 406:	00000517          	auipc	a0,0x0
 40a:	4c250513          	add	a0,a0,1218 # 8c8 <digits>
 40e:	883a                	mv	a6,a4
 410:	2705                	addw	a4,a4,1
 412:	02c5f7bb          	remuw	a5,a1,a2
 416:	1782                	sll	a5,a5,0x20
 418:	9381                	srl	a5,a5,0x20
 41a:	97aa                	add	a5,a5,a0
 41c:	0007c783          	lbu	a5,0(a5)
 420:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 424:	0005879b          	sext.w	a5,a1
 428:	02c5d5bb          	divuw	a1,a1,a2
 42c:	0685                	add	a3,a3,1
 42e:	fec7f0e3          	bgeu	a5,a2,40e <printint+0x26>
  if(neg)
 432:	00088c63          	beqz	a7,44a <printint+0x62>
    buf[i++] = '-';
 436:	fd070793          	add	a5,a4,-48
 43a:	00878733          	add	a4,a5,s0
 43e:	02d00793          	li	a5,45
 442:	fef70823          	sb	a5,-16(a4)
 446:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 44a:	02e05c63          	blez	a4,482 <printint+0x9a>
 44e:	f04a                	sd	s2,32(sp)
 450:	ec4e                	sd	s3,24(sp)
 452:	fc040793          	add	a5,s0,-64
 456:	00e78933          	add	s2,a5,a4
 45a:	fff78993          	add	s3,a5,-1
 45e:	99ba                	add	s3,s3,a4
 460:	377d                	addw	a4,a4,-1
 462:	1702                	sll	a4,a4,0x20
 464:	9301                	srl	a4,a4,0x20
 466:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 46a:	fff94583          	lbu	a1,-1(s2)
 46e:	8526                	mv	a0,s1
 470:	00000097          	auipc	ra,0x0
 474:	f56080e7          	jalr	-170(ra) # 3c6 <putc>
  while(--i >= 0)
 478:	197d                	add	s2,s2,-1
 47a:	ff3918e3          	bne	s2,s3,46a <printint+0x82>
 47e:	7902                	ld	s2,32(sp)
 480:	69e2                	ld	s3,24(sp)
}
 482:	70e2                	ld	ra,56(sp)
 484:	7442                	ld	s0,48(sp)
 486:	74a2                	ld	s1,40(sp)
 488:	6121                	add	sp,sp,64
 48a:	8082                	ret
    x = -xx;
 48c:	40b005bb          	negw	a1,a1
    neg = 1;
 490:	4885                	li	a7,1
    x = -xx;
 492:	b7b5                	j	3fe <printint+0x16>

0000000000000494 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 494:	715d                	add	sp,sp,-80
 496:	e486                	sd	ra,72(sp)
 498:	e0a2                	sd	s0,64(sp)
 49a:	f84a                	sd	s2,48(sp)
 49c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49e:	0005c903          	lbu	s2,0(a1)
 4a2:	1a090a63          	beqz	s2,656 <vprintf+0x1c2>
 4a6:	fc26                	sd	s1,56(sp)
 4a8:	f44e                	sd	s3,40(sp)
 4aa:	f052                	sd	s4,32(sp)
 4ac:	ec56                	sd	s5,24(sp)
 4ae:	e85a                	sd	s6,16(sp)
 4b0:	e45e                	sd	s7,8(sp)
 4b2:	8aaa                	mv	s5,a0
 4b4:	8bb2                	mv	s7,a2
 4b6:	00158493          	add	s1,a1,1
  state = 0;
 4ba:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4bc:	02500a13          	li	s4,37
 4c0:	4b55                	li	s6,21
 4c2:	a839                	j	4e0 <vprintf+0x4c>
        putc(fd, c);
 4c4:	85ca                	mv	a1,s2
 4c6:	8556                	mv	a0,s5
 4c8:	00000097          	auipc	ra,0x0
 4cc:	efe080e7          	jalr	-258(ra) # 3c6 <putc>
 4d0:	a019                	j	4d6 <vprintf+0x42>
    } else if(state == '%'){
 4d2:	01498d63          	beq	s3,s4,4ec <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4d6:	0485                	add	s1,s1,1
 4d8:	fff4c903          	lbu	s2,-1(s1)
 4dc:	16090763          	beqz	s2,64a <vprintf+0x1b6>
    if(state == 0){
 4e0:	fe0999e3          	bnez	s3,4d2 <vprintf+0x3e>
      if(c == '%'){
 4e4:	ff4910e3          	bne	s2,s4,4c4 <vprintf+0x30>
        state = '%';
 4e8:	89d2                	mv	s3,s4
 4ea:	b7f5                	j	4d6 <vprintf+0x42>
      if(c == 'd'){
 4ec:	13490463          	beq	s2,s4,614 <vprintf+0x180>
 4f0:	f9d9079b          	addw	a5,s2,-99
 4f4:	0ff7f793          	zext.b	a5,a5
 4f8:	12fb6763          	bltu	s6,a5,626 <vprintf+0x192>
 4fc:	f9d9079b          	addw	a5,s2,-99
 500:	0ff7f713          	zext.b	a4,a5
 504:	12eb6163          	bltu	s6,a4,626 <vprintf+0x192>
 508:	00271793          	sll	a5,a4,0x2
 50c:	00000717          	auipc	a4,0x0
 510:	36470713          	add	a4,a4,868 # 870 <malloc+0x12a>
 514:	97ba                	add	a5,a5,a4
 516:	439c                	lw	a5,0(a5)
 518:	97ba                	add	a5,a5,a4
 51a:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 51c:	008b8913          	add	s2,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000ba583          	lw	a1,0(s7)
 528:	8556                	mv	a0,s5
 52a:	00000097          	auipc	ra,0x0
 52e:	ebe080e7          	jalr	-322(ra) # 3e8 <printint>
 532:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 534:	4981                	li	s3,0
 536:	b745                	j	4d6 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 538:	008b8913          	add	s2,s7,8
 53c:	4681                	li	a3,0
 53e:	4629                	li	a2,10
 540:	000ba583          	lw	a1,0(s7)
 544:	8556                	mv	a0,s5
 546:	00000097          	auipc	ra,0x0
 54a:	ea2080e7          	jalr	-350(ra) # 3e8 <printint>
 54e:	8bca                	mv	s7,s2
      state = 0;
 550:	4981                	li	s3,0
 552:	b751                	j	4d6 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 554:	008b8913          	add	s2,s7,8
 558:	4681                	li	a3,0
 55a:	4641                	li	a2,16
 55c:	000ba583          	lw	a1,0(s7)
 560:	8556                	mv	a0,s5
 562:	00000097          	auipc	ra,0x0
 566:	e86080e7          	jalr	-378(ra) # 3e8 <printint>
 56a:	8bca                	mv	s7,s2
      state = 0;
 56c:	4981                	li	s3,0
 56e:	b7a5                	j	4d6 <vprintf+0x42>
 570:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 572:	008b8c13          	add	s8,s7,8
 576:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 57a:	03000593          	li	a1,48
 57e:	8556                	mv	a0,s5
 580:	00000097          	auipc	ra,0x0
 584:	e46080e7          	jalr	-442(ra) # 3c6 <putc>
  putc(fd, 'x');
 588:	07800593          	li	a1,120
 58c:	8556                	mv	a0,s5
 58e:	00000097          	auipc	ra,0x0
 592:	e38080e7          	jalr	-456(ra) # 3c6 <putc>
 596:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 598:	00000b97          	auipc	s7,0x0
 59c:	330b8b93          	add	s7,s7,816 # 8c8 <digits>
 5a0:	03c9d793          	srl	a5,s3,0x3c
 5a4:	97de                	add	a5,a5,s7
 5a6:	0007c583          	lbu	a1,0(a5)
 5aa:	8556                	mv	a0,s5
 5ac:	00000097          	auipc	ra,0x0
 5b0:	e1a080e7          	jalr	-486(ra) # 3c6 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5b4:	0992                	sll	s3,s3,0x4
 5b6:	397d                	addw	s2,s2,-1
 5b8:	fe0914e3          	bnez	s2,5a0 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5bc:	8be2                	mv	s7,s8
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	6c02                	ld	s8,0(sp)
 5c2:	bf11                	j	4d6 <vprintf+0x42>
        s = va_arg(ap, char*);
 5c4:	008b8993          	add	s3,s7,8
 5c8:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5cc:	02090163          	beqz	s2,5ee <vprintf+0x15a>
        while(*s != 0){
 5d0:	00094583          	lbu	a1,0(s2)
 5d4:	c9a5                	beqz	a1,644 <vprintf+0x1b0>
          putc(fd, *s);
 5d6:	8556                	mv	a0,s5
 5d8:	00000097          	auipc	ra,0x0
 5dc:	dee080e7          	jalr	-530(ra) # 3c6 <putc>
          s++;
 5e0:	0905                	add	s2,s2,1
        while(*s != 0){
 5e2:	00094583          	lbu	a1,0(s2)
 5e6:	f9e5                	bnez	a1,5d6 <vprintf+0x142>
        s = va_arg(ap, char*);
 5e8:	8bce                	mv	s7,s3
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b5ed                	j	4d6 <vprintf+0x42>
          s = "(null)";
 5ee:	00000917          	auipc	s2,0x0
 5f2:	27a90913          	add	s2,s2,634 # 868 <malloc+0x122>
        while(*s != 0){
 5f6:	02800593          	li	a1,40
 5fa:	bff1                	j	5d6 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5fc:	008b8913          	add	s2,s7,8
 600:	000bc583          	lbu	a1,0(s7)
 604:	8556                	mv	a0,s5
 606:	00000097          	auipc	ra,0x0
 60a:	dc0080e7          	jalr	-576(ra) # 3c6 <putc>
 60e:	8bca                	mv	s7,s2
      state = 0;
 610:	4981                	li	s3,0
 612:	b5d1                	j	4d6 <vprintf+0x42>
        putc(fd, c);
 614:	02500593          	li	a1,37
 618:	8556                	mv	a0,s5
 61a:	00000097          	auipc	ra,0x0
 61e:	dac080e7          	jalr	-596(ra) # 3c6 <putc>
      state = 0;
 622:	4981                	li	s3,0
 624:	bd4d                	j	4d6 <vprintf+0x42>
        putc(fd, '%');
 626:	02500593          	li	a1,37
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	d9a080e7          	jalr	-614(ra) # 3c6 <putc>
        putc(fd, c);
 634:	85ca                	mv	a1,s2
 636:	8556                	mv	a0,s5
 638:	00000097          	auipc	ra,0x0
 63c:	d8e080e7          	jalr	-626(ra) # 3c6 <putc>
      state = 0;
 640:	4981                	li	s3,0
 642:	bd51                	j	4d6 <vprintf+0x42>
        s = va_arg(ap, char*);
 644:	8bce                	mv	s7,s3
      state = 0;
 646:	4981                	li	s3,0
 648:	b579                	j	4d6 <vprintf+0x42>
 64a:	74e2                	ld	s1,56(sp)
 64c:	79a2                	ld	s3,40(sp)
 64e:	7a02                	ld	s4,32(sp)
 650:	6ae2                	ld	s5,24(sp)
 652:	6b42                	ld	s6,16(sp)
 654:	6ba2                	ld	s7,8(sp)
    }
  }
}
 656:	60a6                	ld	ra,72(sp)
 658:	6406                	ld	s0,64(sp)
 65a:	7942                	ld	s2,48(sp)
 65c:	6161                	add	sp,sp,80
 65e:	8082                	ret

0000000000000660 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 660:	715d                	add	sp,sp,-80
 662:	ec06                	sd	ra,24(sp)
 664:	e822                	sd	s0,16(sp)
 666:	1000                	add	s0,sp,32
 668:	e010                	sd	a2,0(s0)
 66a:	e414                	sd	a3,8(s0)
 66c:	e818                	sd	a4,16(s0)
 66e:	ec1c                	sd	a5,24(s0)
 670:	03043023          	sd	a6,32(s0)
 674:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 678:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 67c:	8622                	mv	a2,s0
 67e:	00000097          	auipc	ra,0x0
 682:	e16080e7          	jalr	-490(ra) # 494 <vprintf>
}
 686:	60e2                	ld	ra,24(sp)
 688:	6442                	ld	s0,16(sp)
 68a:	6161                	add	sp,sp,80
 68c:	8082                	ret

000000000000068e <printf>:

void
printf(const char *fmt, ...)
{
 68e:	711d                	add	sp,sp,-96
 690:	ec06                	sd	ra,24(sp)
 692:	e822                	sd	s0,16(sp)
 694:	1000                	add	s0,sp,32
 696:	e40c                	sd	a1,8(s0)
 698:	e810                	sd	a2,16(s0)
 69a:	ec14                	sd	a3,24(s0)
 69c:	f018                	sd	a4,32(s0)
 69e:	f41c                	sd	a5,40(s0)
 6a0:	03043823          	sd	a6,48(s0)
 6a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a8:	00840613          	add	a2,s0,8
 6ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6b0:	85aa                	mv	a1,a0
 6b2:	4505                	li	a0,1
 6b4:	00000097          	auipc	ra,0x0
 6b8:	de0080e7          	jalr	-544(ra) # 494 <vprintf>
}
 6bc:	60e2                	ld	ra,24(sp)
 6be:	6442                	ld	s0,16(sp)
 6c0:	6125                	add	sp,sp,96
 6c2:	8082                	ret

00000000000006c4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c4:	1141                	add	sp,sp,-16
 6c6:	e422                	sd	s0,8(sp)
 6c8:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6ca:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6ce:	00001797          	auipc	a5,0x1
 6d2:	9327b783          	ld	a5,-1742(a5) # 1000 <freep>
 6d6:	a02d                	j	700 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d8:	4618                	lw	a4,8(a2)
 6da:	9f2d                	addw	a4,a4,a1
 6dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6e0:	6398                	ld	a4,0(a5)
 6e2:	6310                	ld	a2,0(a4)
 6e4:	a83d                	j	722 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e6:	ff852703          	lw	a4,-8(a0)
 6ea:	9f31                	addw	a4,a4,a2
 6ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6ee:	ff053683          	ld	a3,-16(a0)
 6f2:	a091                	j	736 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6f4:	6398                	ld	a4,0(a5)
 6f6:	00e7e463          	bltu	a5,a4,6fe <free+0x3a>
 6fa:	00e6ea63          	bltu	a3,a4,70e <free+0x4a>
{
 6fe:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 700:	fed7fae3          	bgeu	a5,a3,6f4 <free+0x30>
 704:	6398                	ld	a4,0(a5)
 706:	00e6e463          	bltu	a3,a4,70e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 70a:	fee7eae3          	bltu	a5,a4,6fe <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 70e:	ff852583          	lw	a1,-8(a0)
 712:	6390                	ld	a2,0(a5)
 714:	02059813          	sll	a6,a1,0x20
 718:	01c85713          	srl	a4,a6,0x1c
 71c:	9736                	add	a4,a4,a3
 71e:	fae60de3          	beq	a2,a4,6d8 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 726:	4790                	lw	a2,8(a5)
 728:	02061593          	sll	a1,a2,0x20
 72c:	01c5d713          	srl	a4,a1,0x1c
 730:	973e                	add	a4,a4,a5
 732:	fae68ae3          	beq	a3,a4,6e6 <free+0x22>
    p->s.ptr = bp->s.ptr;
 736:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 738:	00001717          	auipc	a4,0x1
 73c:	8cf73423          	sd	a5,-1848(a4) # 1000 <freep>
}
 740:	6422                	ld	s0,8(sp)
 742:	0141                	add	sp,sp,16
 744:	8082                	ret

0000000000000746 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 746:	7139                	add	sp,sp,-64
 748:	fc06                	sd	ra,56(sp)
 74a:	f822                	sd	s0,48(sp)
 74c:	f426                	sd	s1,40(sp)
 74e:	ec4e                	sd	s3,24(sp)
 750:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 752:	02051493          	sll	s1,a0,0x20
 756:	9081                	srl	s1,s1,0x20
 758:	04bd                	add	s1,s1,15
 75a:	8091                	srl	s1,s1,0x4
 75c:	0014899b          	addw	s3,s1,1
 760:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 762:	00001517          	auipc	a0,0x1
 766:	89e53503          	ld	a0,-1890(a0) # 1000 <freep>
 76a:	c915                	beqz	a0,79e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 76c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 76e:	4798                	lw	a4,8(a5)
 770:	08977e63          	bgeu	a4,s1,80c <malloc+0xc6>
 774:	f04a                	sd	s2,32(sp)
 776:	e852                	sd	s4,16(sp)
 778:	e456                	sd	s5,8(sp)
 77a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 77c:	8a4e                	mv	s4,s3
 77e:	0009871b          	sext.w	a4,s3
 782:	6685                	lui	a3,0x1
 784:	00d77363          	bgeu	a4,a3,78a <malloc+0x44>
 788:	6a05                	lui	s4,0x1
 78a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 78e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 792:	00001917          	auipc	s2,0x1
 796:	86e90913          	add	s2,s2,-1938 # 1000 <freep>
  if(p == (char*)-1)
 79a:	5afd                	li	s5,-1
 79c:	a091                	j	7e0 <malloc+0x9a>
 79e:	f04a                	sd	s2,32(sp)
 7a0:	e852                	sd	s4,16(sp)
 7a2:	e456                	sd	s5,8(sp)
 7a4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7a6:	00001797          	auipc	a5,0x1
 7aa:	86a78793          	add	a5,a5,-1942 # 1010 <base>
 7ae:	00001717          	auipc	a4,0x1
 7b2:	84f73923          	sd	a5,-1966(a4) # 1000 <freep>
 7b6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7bc:	b7c1                	j	77c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7be:	6398                	ld	a4,0(a5)
 7c0:	e118                	sd	a4,0(a0)
 7c2:	a08d                	j	824 <malloc+0xde>
  hp->s.size = nu;
 7c4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c8:	0541                	add	a0,a0,16
 7ca:	00000097          	auipc	ra,0x0
 7ce:	efa080e7          	jalr	-262(ra) # 6c4 <free>
  return freep;
 7d2:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7d6:	c13d                	beqz	a0,83c <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7da:	4798                	lw	a4,8(a5)
 7dc:	02977463          	bgeu	a4,s1,804 <malloc+0xbe>
    if(p == freep)
 7e0:	00093703          	ld	a4,0(s2)
 7e4:	853e                	mv	a0,a5
 7e6:	fef719e3          	bne	a4,a5,7d8 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7ea:	8552                	mv	a0,s4
 7ec:	00000097          	auipc	ra,0x0
 7f0:	ba2080e7          	jalr	-1118(ra) # 38e <sbrk>
  if(p == (char*)-1)
 7f4:	fd5518e3          	bne	a0,s5,7c4 <malloc+0x7e>
        return 0;
 7f8:	4501                	li	a0,0
 7fa:	7902                	ld	s2,32(sp)
 7fc:	6a42                	ld	s4,16(sp)
 7fe:	6aa2                	ld	s5,8(sp)
 800:	6b02                	ld	s6,0(sp)
 802:	a03d                	j	830 <malloc+0xea>
 804:	7902                	ld	s2,32(sp)
 806:	6a42                	ld	s4,16(sp)
 808:	6aa2                	ld	s5,8(sp)
 80a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 80c:	fae489e3          	beq	s1,a4,7be <malloc+0x78>
        p->s.size -= nunits;
 810:	4137073b          	subw	a4,a4,s3
 814:	c798                	sw	a4,8(a5)
        p += p->s.size;
 816:	02071693          	sll	a3,a4,0x20
 81a:	01c6d713          	srl	a4,a3,0x1c
 81e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 820:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 824:	00000717          	auipc	a4,0x0
 828:	7ca73e23          	sd	a0,2012(a4) # 1000 <freep>
      return (void*)(p + 1);
 82c:	01078513          	add	a0,a5,16
  }
}
 830:	70e2                	ld	ra,56(sp)
 832:	7442                	ld	s0,48(sp)
 834:	74a2                	ld	s1,40(sp)
 836:	69e2                	ld	s3,24(sp)
 838:	6121                	add	sp,sp,64
 83a:	8082                	ret
 83c:	7902                	ld	s2,32(sp)
 83e:	6a42                	ld	s4,16(sp)
 840:	6aa2                	ld	s5,8(sp)
 842:	6b02                	ld	s6,0(sp)
 844:	b7f5                	j	830 <malloc+0xea>
