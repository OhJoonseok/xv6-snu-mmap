
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	add	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	add	s0,sp,16
  if(fork() > 0)
   8:	00000097          	auipc	ra,0x0
   c:	2b8080e7          	jalr	696(ra) # 2c0 <fork>
  10:	00a04763          	bgtz	a0,1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  exit(0);
  14:	4501                	li	a0,0
  16:	00000097          	auipc	ra,0x0
  1a:	2b2080e7          	jalr	690(ra) # 2c8 <exit>
    sleep(5);  // Let child exit before parent.
  1e:	4515                	li	a0,5
  20:	00000097          	auipc	ra,0x0
  24:	338080e7          	jalr	824(ra) # 358 <sleep>
  28:	b7f5                	j	14 <main+0x14>

000000000000002a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  2a:	1141                	add	sp,sp,-16
  2c:	e406                	sd	ra,8(sp)
  2e:	e022                	sd	s0,0(sp)
  30:	0800                	add	s0,sp,16
  extern int main();
  main();
  32:	00000097          	auipc	ra,0x0
  36:	fce080e7          	jalr	-50(ra) # 0 <main>
  exit(0);
  3a:	4501                	li	a0,0
  3c:	00000097          	auipc	ra,0x0
  40:	28c080e7          	jalr	652(ra) # 2c8 <exit>

0000000000000044 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  44:	1141                	add	sp,sp,-16
  46:	e422                	sd	s0,8(sp)
  48:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  4a:	87aa                	mv	a5,a0
  4c:	0585                	add	a1,a1,1
  4e:	0785                	add	a5,a5,1
  50:	fff5c703          	lbu	a4,-1(a1)
  54:	fee78fa3          	sb	a4,-1(a5)
  58:	fb75                	bnez	a4,4c <strcpy+0x8>
    ;
  return os;
}
  5a:	6422                	ld	s0,8(sp)
  5c:	0141                	add	sp,sp,16
  5e:	8082                	ret

0000000000000060 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  60:	1141                	add	sp,sp,-16
  62:	e422                	sd	s0,8(sp)
  64:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  66:	00054783          	lbu	a5,0(a0)
  6a:	cb91                	beqz	a5,7e <strcmp+0x1e>
  6c:	0005c703          	lbu	a4,0(a1)
  70:	00f71763          	bne	a4,a5,7e <strcmp+0x1e>
    p++, q++;
  74:	0505                	add	a0,a0,1
  76:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  78:	00054783          	lbu	a5,0(a0)
  7c:	fbe5                	bnez	a5,6c <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  7e:	0005c503          	lbu	a0,0(a1)
}
  82:	40a7853b          	subw	a0,a5,a0
  86:	6422                	ld	s0,8(sp)
  88:	0141                	add	sp,sp,16
  8a:	8082                	ret

000000000000008c <strlen>:

uint
strlen(const char *s)
{
  8c:	1141                	add	sp,sp,-16
  8e:	e422                	sd	s0,8(sp)
  90:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  92:	00054783          	lbu	a5,0(a0)
  96:	cf91                	beqz	a5,b2 <strlen+0x26>
  98:	0505                	add	a0,a0,1
  9a:	87aa                	mv	a5,a0
  9c:	86be                	mv	a3,a5
  9e:	0785                	add	a5,a5,1
  a0:	fff7c703          	lbu	a4,-1(a5)
  a4:	ff65                	bnez	a4,9c <strlen+0x10>
  a6:	40a6853b          	subw	a0,a3,a0
  aa:	2505                	addw	a0,a0,1
    ;
  return n;
}
  ac:	6422                	ld	s0,8(sp)
  ae:	0141                	add	sp,sp,16
  b0:	8082                	ret
  for(n = 0; s[n]; n++)
  b2:	4501                	li	a0,0
  b4:	bfe5                	j	ac <strlen+0x20>

00000000000000b6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b6:	1141                	add	sp,sp,-16
  b8:	e422                	sd	s0,8(sp)
  ba:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  bc:	ca19                	beqz	a2,d2 <memset+0x1c>
  be:	87aa                	mv	a5,a0
  c0:	1602                	sll	a2,a2,0x20
  c2:	9201                	srl	a2,a2,0x20
  c4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  cc:	0785                	add	a5,a5,1
  ce:	fee79de3          	bne	a5,a4,c8 <memset+0x12>
  }
  return dst;
}
  d2:	6422                	ld	s0,8(sp)
  d4:	0141                	add	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char*
strchr(const char *s, char c)
{
  d8:	1141                	add	sp,sp,-16
  da:	e422                	sd	s0,8(sp)
  dc:	0800                	add	s0,sp,16
  for(; *s; s++)
  de:	00054783          	lbu	a5,0(a0)
  e2:	cb99                	beqz	a5,f8 <strchr+0x20>
    if(*s == c)
  e4:	00f58763          	beq	a1,a5,f2 <strchr+0x1a>
  for(; *s; s++)
  e8:	0505                	add	a0,a0,1
  ea:	00054783          	lbu	a5,0(a0)
  ee:	fbfd                	bnez	a5,e4 <strchr+0xc>
      return (char*)s;
  return 0;
  f0:	4501                	li	a0,0
}
  f2:	6422                	ld	s0,8(sp)
  f4:	0141                	add	sp,sp,16
  f6:	8082                	ret
  return 0;
  f8:	4501                	li	a0,0
  fa:	bfe5                	j	f2 <strchr+0x1a>

00000000000000fc <gets>:

char*
gets(char *buf, int max)
{
  fc:	711d                	add	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	1080                	add	s0,sp,96
 112:	8baa                	mv	s7,a0
 114:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 116:	892a                	mv	s2,a0
 118:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 11a:	4aa9                	li	s5,10
 11c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 11e:	89a6                	mv	s3,s1
 120:	2485                	addw	s1,s1,1
 122:	0344d863          	bge	s1,s4,152 <gets+0x56>
    cc = read(0, &c, 1);
 126:	4605                	li	a2,1
 128:	faf40593          	add	a1,s0,-81
 12c:	4501                	li	a0,0
 12e:	00000097          	auipc	ra,0x0
 132:	1b2080e7          	jalr	434(ra) # 2e0 <read>
    if(cc < 1)
 136:	00a05e63          	blez	a0,152 <gets+0x56>
    buf[i++] = c;
 13a:	faf44783          	lbu	a5,-81(s0)
 13e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 142:	01578763          	beq	a5,s5,150 <gets+0x54>
 146:	0905                	add	s2,s2,1
 148:	fd679be3          	bne	a5,s6,11e <gets+0x22>
    buf[i++] = c;
 14c:	89a6                	mv	s3,s1
 14e:	a011                	j	152 <gets+0x56>
 150:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 152:	99de                	add	s3,s3,s7
 154:	00098023          	sb	zero,0(s3)
  return buf;
}
 158:	855e                	mv	a0,s7
 15a:	60e6                	ld	ra,88(sp)
 15c:	6446                	ld	s0,80(sp)
 15e:	64a6                	ld	s1,72(sp)
 160:	6906                	ld	s2,64(sp)
 162:	79e2                	ld	s3,56(sp)
 164:	7a42                	ld	s4,48(sp)
 166:	7aa2                	ld	s5,40(sp)
 168:	7b02                	ld	s6,32(sp)
 16a:	6be2                	ld	s7,24(sp)
 16c:	6125                	add	sp,sp,96
 16e:	8082                	ret

0000000000000170 <stat>:

int
stat(const char *n, struct stat *st)
{
 170:	1101                	add	sp,sp,-32
 172:	ec06                	sd	ra,24(sp)
 174:	e822                	sd	s0,16(sp)
 176:	e04a                	sd	s2,0(sp)
 178:	1000                	add	s0,sp,32
 17a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17c:	4581                	li	a1,0
 17e:	00000097          	auipc	ra,0x0
 182:	18a080e7          	jalr	394(ra) # 308 <open>
  if(fd < 0)
 186:	02054663          	bltz	a0,1b2 <stat+0x42>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	00000097          	auipc	ra,0x0
 194:	190080e7          	jalr	400(ra) # 320 <fstat>
 198:	892a                	mv	s2,a0
  close(fd);
 19a:	8526                	mv	a0,s1
 19c:	00000097          	auipc	ra,0x0
 1a0:	154080e7          	jalr	340(ra) # 2f0 <close>
  return r;
 1a4:	64a2                	ld	s1,8(sp)
}
 1a6:	854a                	mv	a0,s2
 1a8:	60e2                	ld	ra,24(sp)
 1aa:	6442                	ld	s0,16(sp)
 1ac:	6902                	ld	s2,0(sp)
 1ae:	6105                	add	sp,sp,32
 1b0:	8082                	ret
    return -1;
 1b2:	597d                	li	s2,-1
 1b4:	bfcd                	j	1a6 <stat+0x36>

00000000000001b6 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 1b6:	1141                	add	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 1bc:	00054703          	lbu	a4,0(a0)
 1c0:	02d00793          	li	a5,45
 1c4:	4585                	li	a1,1
 1c6:	04f70363          	beq	a4,a5,20c <atoi+0x56>

  while('0' <= *s && *s <= '9')
 1ca:	00054703          	lbu	a4,0(a0)
 1ce:	fd07079b          	addw	a5,a4,-48
 1d2:	0ff7f793          	zext.b	a5,a5
 1d6:	46a5                	li	a3,9
 1d8:	02f6ed63          	bltu	a3,a5,212 <atoi+0x5c>
  int n = 0;
 1dc:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 1de:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 1e0:	0505                	add	a0,a0,1
 1e2:	0026979b          	sllw	a5,a3,0x2
 1e6:	9fb5                	addw	a5,a5,a3
 1e8:	0017979b          	sllw	a5,a5,0x1
 1ec:	9fb9                	addw	a5,a5,a4
 1ee:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 1f2:	00054703          	lbu	a4,0(a0)
 1f6:	fd07079b          	addw	a5,a4,-48
 1fa:	0ff7f793          	zext.b	a5,a5
 1fe:	fef671e3          	bgeu	a2,a5,1e0 <atoi+0x2a>
  return sign * n;
}
 202:	02d5853b          	mulw	a0,a1,a3
 206:	6422                	ld	s0,8(sp)
 208:	0141                	add	sp,sp,16
 20a:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 20c:	0505                	add	a0,a0,1
 20e:	55fd                	li	a1,-1
 210:	bf6d                	j	1ca <atoi+0x14>
  int n = 0;
 212:	4681                	li	a3,0
 214:	b7fd                	j	202 <atoi+0x4c>

0000000000000216 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 216:	1141                	add	sp,sp,-16
 218:	e422                	sd	s0,8(sp)
 21a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21c:	02b57463          	bgeu	a0,a1,244 <memmove+0x2e>
    while(n-- > 0)
 220:	00c05f63          	blez	a2,23e <memmove+0x28>
 224:	1602                	sll	a2,a2,0x20
 226:	9201                	srl	a2,a2,0x20
 228:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22c:	872a                	mv	a4,a0
      *dst++ = *src++;
 22e:	0585                	add	a1,a1,1
 230:	0705                	add	a4,a4,1
 232:	fff5c683          	lbu	a3,-1(a1)
 236:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 23a:	fef71ae3          	bne	a4,a5,22e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	add	sp,sp,16
 242:	8082                	ret
    dst += n;
 244:	00c50733          	add	a4,a0,a2
    src += n;
 248:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 24a:	fec05ae3          	blez	a2,23e <memmove+0x28>
 24e:	fff6079b          	addw	a5,a2,-1
 252:	1782                	sll	a5,a5,0x20
 254:	9381                	srl	a5,a5,0x20
 256:	fff7c793          	not	a5,a5
 25a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25c:	15fd                	add	a1,a1,-1
 25e:	177d                	add	a4,a4,-1
 260:	0005c683          	lbu	a3,0(a1)
 264:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 268:	fee79ae3          	bne	a5,a4,25c <memmove+0x46>
 26c:	bfc9                	j	23e <memmove+0x28>

000000000000026e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26e:	1141                	add	sp,sp,-16
 270:	e422                	sd	s0,8(sp)
 272:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 274:	ca05                	beqz	a2,2a4 <memcmp+0x36>
 276:	fff6069b          	addw	a3,a2,-1
 27a:	1682                	sll	a3,a3,0x20
 27c:	9281                	srl	a3,a3,0x20
 27e:	0685                	add	a3,a3,1
 280:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 282:	00054783          	lbu	a5,0(a0)
 286:	0005c703          	lbu	a4,0(a1)
 28a:	00e79863          	bne	a5,a4,29a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 28e:	0505                	add	a0,a0,1
    p2++;
 290:	0585                	add	a1,a1,1
  while (n-- > 0) {
 292:	fed518e3          	bne	a0,a3,282 <memcmp+0x14>
  }
  return 0;
 296:	4501                	li	a0,0
 298:	a019                	j	29e <memcmp+0x30>
      return *p1 - *p2;
 29a:	40e7853b          	subw	a0,a5,a4
}
 29e:	6422                	ld	s0,8(sp)
 2a0:	0141                	add	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfe5                	j	29e <memcmp+0x30>

00000000000002a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a8:	1141                	add	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2b0:	00000097          	auipc	ra,0x0
 2b4:	f66080e7          	jalr	-154(ra) # 216 <memmove>
}
 2b8:	60a2                	ld	ra,8(sp)
 2ba:	6402                	ld	s0,0(sp)
 2bc:	0141                	add	sp,sp,16
 2be:	8082                	ret

00000000000002c0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2c0:	4885                	li	a7,1
 ecall
 2c2:	00000073          	ecall
 ret
 2c6:	8082                	ret

00000000000002c8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c8:	4889                	li	a7,2
 ecall
 2ca:	00000073          	ecall
 ret
 2ce:	8082                	ret

00000000000002d0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2d0:	488d                	li	a7,3
 ecall
 2d2:	00000073          	ecall
 ret
 2d6:	8082                	ret

00000000000002d8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d8:	4891                	li	a7,4
 ecall
 2da:	00000073          	ecall
 ret
 2de:	8082                	ret

00000000000002e0 <read>:
.global read
read:
 li a7, SYS_read
 2e0:	4895                	li	a7,5
 ecall
 2e2:	00000073          	ecall
 ret
 2e6:	8082                	ret

00000000000002e8 <write>:
.global write
write:
 li a7, SYS_write
 2e8:	48c1                	li	a7,16
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <close>:
.global close
close:
 li a7, SYS_close
 2f0:	48d5                	li	a7,21
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f8:	4899                	li	a7,6
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exec>:
.global exec
exec:
 li a7, SYS_exec
 300:	489d                	li	a7,7
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <open>:
.global open
open:
 li a7, SYS_open
 308:	48bd                	li	a7,15
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 310:	48c5                	li	a7,17
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 318:	48c9                	li	a7,18
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 320:	48a1                	li	a7,8
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <link>:
.global link
link:
 li a7, SYS_link
 328:	48cd                	li	a7,19
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 330:	48d1                	li	a7,20
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 338:	48a5                	li	a7,9
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <dup>:
.global dup
dup:
 li a7, SYS_dup
 340:	48a9                	li	a7,10
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 348:	48ad                	li	a7,11
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 350:	48b1                	li	a7,12
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 358:	48b5                	li	a7,13
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 360:	48b9                	li	a7,14
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 368:	48d9                	li	a7,22
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 370:	48dd                	li	a7,23
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 378:	48e1                	li	a7,24
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 380:	48e5                	li	a7,25
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 388:	1101                	add	sp,sp,-32
 38a:	ec06                	sd	ra,24(sp)
 38c:	e822                	sd	s0,16(sp)
 38e:	1000                	add	s0,sp,32
 390:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 394:	4605                	li	a2,1
 396:	fef40593          	add	a1,s0,-17
 39a:	00000097          	auipc	ra,0x0
 39e:	f4e080e7          	jalr	-178(ra) # 2e8 <write>
}
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	6105                	add	sp,sp,32
 3a8:	8082                	ret

00000000000003aa <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3aa:	7139                	add	sp,sp,-64
 3ac:	fc06                	sd	ra,56(sp)
 3ae:	f822                	sd	s0,48(sp)
 3b0:	f426                	sd	s1,40(sp)
 3b2:	0080                	add	s0,sp,64
 3b4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3b6:	c299                	beqz	a3,3bc <printint+0x12>
 3b8:	0805cb63          	bltz	a1,44e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3bc:	2581                	sext.w	a1,a1
  neg = 0;
 3be:	4881                	li	a7,0
 3c0:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3c4:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3c6:	2601                	sext.w	a2,a2
 3c8:	00000517          	auipc	a0,0x0
 3cc:	4a850513          	add	a0,a0,1192 # 870 <digits>
 3d0:	883a                	mv	a6,a4
 3d2:	2705                	addw	a4,a4,1
 3d4:	02c5f7bb          	remuw	a5,a1,a2
 3d8:	1782                	sll	a5,a5,0x20
 3da:	9381                	srl	a5,a5,0x20
 3dc:	97aa                	add	a5,a5,a0
 3de:	0007c783          	lbu	a5,0(a5)
 3e2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3e6:	0005879b          	sext.w	a5,a1
 3ea:	02c5d5bb          	divuw	a1,a1,a2
 3ee:	0685                	add	a3,a3,1
 3f0:	fec7f0e3          	bgeu	a5,a2,3d0 <printint+0x26>
  if(neg)
 3f4:	00088c63          	beqz	a7,40c <printint+0x62>
    buf[i++] = '-';
 3f8:	fd070793          	add	a5,a4,-48
 3fc:	00878733          	add	a4,a5,s0
 400:	02d00793          	li	a5,45
 404:	fef70823          	sb	a5,-16(a4)
 408:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 40c:	02e05c63          	blez	a4,444 <printint+0x9a>
 410:	f04a                	sd	s2,32(sp)
 412:	ec4e                	sd	s3,24(sp)
 414:	fc040793          	add	a5,s0,-64
 418:	00e78933          	add	s2,a5,a4
 41c:	fff78993          	add	s3,a5,-1
 420:	99ba                	add	s3,s3,a4
 422:	377d                	addw	a4,a4,-1
 424:	1702                	sll	a4,a4,0x20
 426:	9301                	srl	a4,a4,0x20
 428:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42c:	fff94583          	lbu	a1,-1(s2)
 430:	8526                	mv	a0,s1
 432:	00000097          	auipc	ra,0x0
 436:	f56080e7          	jalr	-170(ra) # 388 <putc>
  while(--i >= 0)
 43a:	197d                	add	s2,s2,-1
 43c:	ff3918e3          	bne	s2,s3,42c <printint+0x82>
 440:	7902                	ld	s2,32(sp)
 442:	69e2                	ld	s3,24(sp)
}
 444:	70e2                	ld	ra,56(sp)
 446:	7442                	ld	s0,48(sp)
 448:	74a2                	ld	s1,40(sp)
 44a:	6121                	add	sp,sp,64
 44c:	8082                	ret
    x = -xx;
 44e:	40b005bb          	negw	a1,a1
    neg = 1;
 452:	4885                	li	a7,1
    x = -xx;
 454:	b7b5                	j	3c0 <printint+0x16>

0000000000000456 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 456:	715d                	add	sp,sp,-80
 458:	e486                	sd	ra,72(sp)
 45a:	e0a2                	sd	s0,64(sp)
 45c:	f84a                	sd	s2,48(sp)
 45e:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 460:	0005c903          	lbu	s2,0(a1)
 464:	1a090a63          	beqz	s2,618 <vprintf+0x1c2>
 468:	fc26                	sd	s1,56(sp)
 46a:	f44e                	sd	s3,40(sp)
 46c:	f052                	sd	s4,32(sp)
 46e:	ec56                	sd	s5,24(sp)
 470:	e85a                	sd	s6,16(sp)
 472:	e45e                	sd	s7,8(sp)
 474:	8aaa                	mv	s5,a0
 476:	8bb2                	mv	s7,a2
 478:	00158493          	add	s1,a1,1
  state = 0;
 47c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 47e:	02500a13          	li	s4,37
 482:	4b55                	li	s6,21
 484:	a839                	j	4a2 <vprintf+0x4c>
        putc(fd, c);
 486:	85ca                	mv	a1,s2
 488:	8556                	mv	a0,s5
 48a:	00000097          	auipc	ra,0x0
 48e:	efe080e7          	jalr	-258(ra) # 388 <putc>
 492:	a019                	j	498 <vprintf+0x42>
    } else if(state == '%'){
 494:	01498d63          	beq	s3,s4,4ae <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 498:	0485                	add	s1,s1,1
 49a:	fff4c903          	lbu	s2,-1(s1)
 49e:	16090763          	beqz	s2,60c <vprintf+0x1b6>
    if(state == 0){
 4a2:	fe0999e3          	bnez	s3,494 <vprintf+0x3e>
      if(c == '%'){
 4a6:	ff4910e3          	bne	s2,s4,486 <vprintf+0x30>
        state = '%';
 4aa:	89d2                	mv	s3,s4
 4ac:	b7f5                	j	498 <vprintf+0x42>
      if(c == 'd'){
 4ae:	13490463          	beq	s2,s4,5d6 <vprintf+0x180>
 4b2:	f9d9079b          	addw	a5,s2,-99
 4b6:	0ff7f793          	zext.b	a5,a5
 4ba:	12fb6763          	bltu	s6,a5,5e8 <vprintf+0x192>
 4be:	f9d9079b          	addw	a5,s2,-99
 4c2:	0ff7f713          	zext.b	a4,a5
 4c6:	12eb6163          	bltu	s6,a4,5e8 <vprintf+0x192>
 4ca:	00271793          	sll	a5,a4,0x2
 4ce:	00000717          	auipc	a4,0x0
 4d2:	34a70713          	add	a4,a4,842 # 818 <malloc+0x110>
 4d6:	97ba                	add	a5,a5,a4
 4d8:	439c                	lw	a5,0(a5)
 4da:	97ba                	add	a5,a5,a4
 4dc:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 4de:	008b8913          	add	s2,s7,8
 4e2:	4685                	li	a3,1
 4e4:	4629                	li	a2,10
 4e6:	000ba583          	lw	a1,0(s7)
 4ea:	8556                	mv	a0,s5
 4ec:	00000097          	auipc	ra,0x0
 4f0:	ebe080e7          	jalr	-322(ra) # 3aa <printint>
 4f4:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f6:	4981                	li	s3,0
 4f8:	b745                	j	498 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 4fa:	008b8913          	add	s2,s7,8
 4fe:	4681                	li	a3,0
 500:	4629                	li	a2,10
 502:	000ba583          	lw	a1,0(s7)
 506:	8556                	mv	a0,s5
 508:	00000097          	auipc	ra,0x0
 50c:	ea2080e7          	jalr	-350(ra) # 3aa <printint>
 510:	8bca                	mv	s7,s2
      state = 0;
 512:	4981                	li	s3,0
 514:	b751                	j	498 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 516:	008b8913          	add	s2,s7,8
 51a:	4681                	li	a3,0
 51c:	4641                	li	a2,16
 51e:	000ba583          	lw	a1,0(s7)
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	e86080e7          	jalr	-378(ra) # 3aa <printint>
 52c:	8bca                	mv	s7,s2
      state = 0;
 52e:	4981                	li	s3,0
 530:	b7a5                	j	498 <vprintf+0x42>
 532:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 534:	008b8c13          	add	s8,s7,8
 538:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 53c:	03000593          	li	a1,48
 540:	8556                	mv	a0,s5
 542:	00000097          	auipc	ra,0x0
 546:	e46080e7          	jalr	-442(ra) # 388 <putc>
  putc(fd, 'x');
 54a:	07800593          	li	a1,120
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	e38080e7          	jalr	-456(ra) # 388 <putc>
 558:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 55a:	00000b97          	auipc	s7,0x0
 55e:	316b8b93          	add	s7,s7,790 # 870 <digits>
 562:	03c9d793          	srl	a5,s3,0x3c
 566:	97de                	add	a5,a5,s7
 568:	0007c583          	lbu	a1,0(a5)
 56c:	8556                	mv	a0,s5
 56e:	00000097          	auipc	ra,0x0
 572:	e1a080e7          	jalr	-486(ra) # 388 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 576:	0992                	sll	s3,s3,0x4
 578:	397d                	addw	s2,s2,-1
 57a:	fe0914e3          	bnez	s2,562 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 57e:	8be2                	mv	s7,s8
      state = 0;
 580:	4981                	li	s3,0
 582:	6c02                	ld	s8,0(sp)
 584:	bf11                	j	498 <vprintf+0x42>
        s = va_arg(ap, char*);
 586:	008b8993          	add	s3,s7,8
 58a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 58e:	02090163          	beqz	s2,5b0 <vprintf+0x15a>
        while(*s != 0){
 592:	00094583          	lbu	a1,0(s2)
 596:	c9a5                	beqz	a1,606 <vprintf+0x1b0>
          putc(fd, *s);
 598:	8556                	mv	a0,s5
 59a:	00000097          	auipc	ra,0x0
 59e:	dee080e7          	jalr	-530(ra) # 388 <putc>
          s++;
 5a2:	0905                	add	s2,s2,1
        while(*s != 0){
 5a4:	00094583          	lbu	a1,0(s2)
 5a8:	f9e5                	bnez	a1,598 <vprintf+0x142>
        s = va_arg(ap, char*);
 5aa:	8bce                	mv	s7,s3
      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b5ed                	j	498 <vprintf+0x42>
          s = "(null)";
 5b0:	00000917          	auipc	s2,0x0
 5b4:	26090913          	add	s2,s2,608 # 810 <malloc+0x108>
        while(*s != 0){
 5b8:	02800593          	li	a1,40
 5bc:	bff1                	j	598 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5be:	008b8913          	add	s2,s7,8
 5c2:	000bc583          	lbu	a1,0(s7)
 5c6:	8556                	mv	a0,s5
 5c8:	00000097          	auipc	ra,0x0
 5cc:	dc0080e7          	jalr	-576(ra) # 388 <putc>
 5d0:	8bca                	mv	s7,s2
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b5d1                	j	498 <vprintf+0x42>
        putc(fd, c);
 5d6:	02500593          	li	a1,37
 5da:	8556                	mv	a0,s5
 5dc:	00000097          	auipc	ra,0x0
 5e0:	dac080e7          	jalr	-596(ra) # 388 <putc>
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bd4d                	j	498 <vprintf+0x42>
        putc(fd, '%');
 5e8:	02500593          	li	a1,37
 5ec:	8556                	mv	a0,s5
 5ee:	00000097          	auipc	ra,0x0
 5f2:	d9a080e7          	jalr	-614(ra) # 388 <putc>
        putc(fd, c);
 5f6:	85ca                	mv	a1,s2
 5f8:	8556                	mv	a0,s5
 5fa:	00000097          	auipc	ra,0x0
 5fe:	d8e080e7          	jalr	-626(ra) # 388 <putc>
      state = 0;
 602:	4981                	li	s3,0
 604:	bd51                	j	498 <vprintf+0x42>
        s = va_arg(ap, char*);
 606:	8bce                	mv	s7,s3
      state = 0;
 608:	4981                	li	s3,0
 60a:	b579                	j	498 <vprintf+0x42>
 60c:	74e2                	ld	s1,56(sp)
 60e:	79a2                	ld	s3,40(sp)
 610:	7a02                	ld	s4,32(sp)
 612:	6ae2                	ld	s5,24(sp)
 614:	6b42                	ld	s6,16(sp)
 616:	6ba2                	ld	s7,8(sp)
    }
  }
}
 618:	60a6                	ld	ra,72(sp)
 61a:	6406                	ld	s0,64(sp)
 61c:	7942                	ld	s2,48(sp)
 61e:	6161                	add	sp,sp,80
 620:	8082                	ret

0000000000000622 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 622:	715d                	add	sp,sp,-80
 624:	ec06                	sd	ra,24(sp)
 626:	e822                	sd	s0,16(sp)
 628:	1000                	add	s0,sp,32
 62a:	e010                	sd	a2,0(s0)
 62c:	e414                	sd	a3,8(s0)
 62e:	e818                	sd	a4,16(s0)
 630:	ec1c                	sd	a5,24(s0)
 632:	03043023          	sd	a6,32(s0)
 636:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 63a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 63e:	8622                	mv	a2,s0
 640:	00000097          	auipc	ra,0x0
 644:	e16080e7          	jalr	-490(ra) # 456 <vprintf>
}
 648:	60e2                	ld	ra,24(sp)
 64a:	6442                	ld	s0,16(sp)
 64c:	6161                	add	sp,sp,80
 64e:	8082                	ret

0000000000000650 <printf>:

void
printf(const char *fmt, ...)
{
 650:	711d                	add	sp,sp,-96
 652:	ec06                	sd	ra,24(sp)
 654:	e822                	sd	s0,16(sp)
 656:	1000                	add	s0,sp,32
 658:	e40c                	sd	a1,8(s0)
 65a:	e810                	sd	a2,16(s0)
 65c:	ec14                	sd	a3,24(s0)
 65e:	f018                	sd	a4,32(s0)
 660:	f41c                	sd	a5,40(s0)
 662:	03043823          	sd	a6,48(s0)
 666:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 66a:	00840613          	add	a2,s0,8
 66e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 672:	85aa                	mv	a1,a0
 674:	4505                	li	a0,1
 676:	00000097          	auipc	ra,0x0
 67a:	de0080e7          	jalr	-544(ra) # 456 <vprintf>
}
 67e:	60e2                	ld	ra,24(sp)
 680:	6442                	ld	s0,16(sp)
 682:	6125                	add	sp,sp,96
 684:	8082                	ret

0000000000000686 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 686:	1141                	add	sp,sp,-16
 688:	e422                	sd	s0,8(sp)
 68a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 68c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 690:	00001797          	auipc	a5,0x1
 694:	9707b783          	ld	a5,-1680(a5) # 1000 <freep>
 698:	a02d                	j	6c2 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 69a:	4618                	lw	a4,8(a2)
 69c:	9f2d                	addw	a4,a4,a1
 69e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6a2:	6398                	ld	a4,0(a5)
 6a4:	6310                	ld	a2,0(a4)
 6a6:	a83d                	j	6e4 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6a8:	ff852703          	lw	a4,-8(a0)
 6ac:	9f31                	addw	a4,a4,a2
 6ae:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6b0:	ff053683          	ld	a3,-16(a0)
 6b4:	a091                	j	6f8 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6b6:	6398                	ld	a4,0(a5)
 6b8:	00e7e463          	bltu	a5,a4,6c0 <free+0x3a>
 6bc:	00e6ea63          	bltu	a3,a4,6d0 <free+0x4a>
{
 6c0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c2:	fed7fae3          	bgeu	a5,a3,6b6 <free+0x30>
 6c6:	6398                	ld	a4,0(a5)
 6c8:	00e6e463          	bltu	a3,a4,6d0 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6cc:	fee7eae3          	bltu	a5,a4,6c0 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 6d0:	ff852583          	lw	a1,-8(a0)
 6d4:	6390                	ld	a2,0(a5)
 6d6:	02059813          	sll	a6,a1,0x20
 6da:	01c85713          	srl	a4,a6,0x1c
 6de:	9736                	add	a4,a4,a3
 6e0:	fae60de3          	beq	a2,a4,69a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 6e4:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 6e8:	4790                	lw	a2,8(a5)
 6ea:	02061593          	sll	a1,a2,0x20
 6ee:	01c5d713          	srl	a4,a1,0x1c
 6f2:	973e                	add	a4,a4,a5
 6f4:	fae68ae3          	beq	a3,a4,6a8 <free+0x22>
    p->s.ptr = bp->s.ptr;
 6f8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 6fa:	00001717          	auipc	a4,0x1
 6fe:	90f73323          	sd	a5,-1786(a4) # 1000 <freep>
}
 702:	6422                	ld	s0,8(sp)
 704:	0141                	add	sp,sp,16
 706:	8082                	ret

0000000000000708 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 708:	7139                	add	sp,sp,-64
 70a:	fc06                	sd	ra,56(sp)
 70c:	f822                	sd	s0,48(sp)
 70e:	f426                	sd	s1,40(sp)
 710:	ec4e                	sd	s3,24(sp)
 712:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 714:	02051493          	sll	s1,a0,0x20
 718:	9081                	srl	s1,s1,0x20
 71a:	04bd                	add	s1,s1,15
 71c:	8091                	srl	s1,s1,0x4
 71e:	0014899b          	addw	s3,s1,1
 722:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 724:	00001517          	auipc	a0,0x1
 728:	8dc53503          	ld	a0,-1828(a0) # 1000 <freep>
 72c:	c915                	beqz	a0,760 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 72e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 730:	4798                	lw	a4,8(a5)
 732:	08977e63          	bgeu	a4,s1,7ce <malloc+0xc6>
 736:	f04a                	sd	s2,32(sp)
 738:	e852                	sd	s4,16(sp)
 73a:	e456                	sd	s5,8(sp)
 73c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 73e:	8a4e                	mv	s4,s3
 740:	0009871b          	sext.w	a4,s3
 744:	6685                	lui	a3,0x1
 746:	00d77363          	bgeu	a4,a3,74c <malloc+0x44>
 74a:	6a05                	lui	s4,0x1
 74c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 750:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 754:	00001917          	auipc	s2,0x1
 758:	8ac90913          	add	s2,s2,-1876 # 1000 <freep>
  if(p == (char*)-1)
 75c:	5afd                	li	s5,-1
 75e:	a091                	j	7a2 <malloc+0x9a>
 760:	f04a                	sd	s2,32(sp)
 762:	e852                	sd	s4,16(sp)
 764:	e456                	sd	s5,8(sp)
 766:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 768:	00001797          	auipc	a5,0x1
 76c:	8a878793          	add	a5,a5,-1880 # 1010 <base>
 770:	00001717          	auipc	a4,0x1
 774:	88f73823          	sd	a5,-1904(a4) # 1000 <freep>
 778:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 77a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 77e:	b7c1                	j	73e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 780:	6398                	ld	a4,0(a5)
 782:	e118                	sd	a4,0(a0)
 784:	a08d                	j	7e6 <malloc+0xde>
  hp->s.size = nu;
 786:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 78a:	0541                	add	a0,a0,16
 78c:	00000097          	auipc	ra,0x0
 790:	efa080e7          	jalr	-262(ra) # 686 <free>
  return freep;
 794:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 798:	c13d                	beqz	a0,7fe <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 79a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 79c:	4798                	lw	a4,8(a5)
 79e:	02977463          	bgeu	a4,s1,7c6 <malloc+0xbe>
    if(p == freep)
 7a2:	00093703          	ld	a4,0(s2)
 7a6:	853e                	mv	a0,a5
 7a8:	fef719e3          	bne	a4,a5,79a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7ac:	8552                	mv	a0,s4
 7ae:	00000097          	auipc	ra,0x0
 7b2:	ba2080e7          	jalr	-1118(ra) # 350 <sbrk>
  if(p == (char*)-1)
 7b6:	fd5518e3          	bne	a0,s5,786 <malloc+0x7e>
        return 0;
 7ba:	4501                	li	a0,0
 7bc:	7902                	ld	s2,32(sp)
 7be:	6a42                	ld	s4,16(sp)
 7c0:	6aa2                	ld	s5,8(sp)
 7c2:	6b02                	ld	s6,0(sp)
 7c4:	a03d                	j	7f2 <malloc+0xea>
 7c6:	7902                	ld	s2,32(sp)
 7c8:	6a42                	ld	s4,16(sp)
 7ca:	6aa2                	ld	s5,8(sp)
 7cc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 7ce:	fae489e3          	beq	s1,a4,780 <malloc+0x78>
        p->s.size -= nunits;
 7d2:	4137073b          	subw	a4,a4,s3
 7d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 7d8:	02071693          	sll	a3,a4,0x20
 7dc:	01c6d713          	srl	a4,a3,0x1c
 7e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 7e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 7e6:	00001717          	auipc	a4,0x1
 7ea:	80a73d23          	sd	a0,-2022(a4) # 1000 <freep>
      return (void*)(p + 1);
 7ee:	01078513          	add	a0,a5,16
  }
}
 7f2:	70e2                	ld	ra,56(sp)
 7f4:	7442                	ld	s0,48(sp)
 7f6:	74a2                	ld	s1,40(sp)
 7f8:	69e2                	ld	s3,24(sp)
 7fa:	6121                	add	sp,sp,64
 7fc:	8082                	ret
 7fe:	7902                	ld	s2,32(sp)
 800:	6a42                	ld	s4,16(sp)
 802:	6aa2                	ld	s5,8(sp)
 804:	6b02                	ld	s6,0(sp)
 806:	b7f5                	j	7f2 <malloc+0xea>
