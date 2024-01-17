
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	add	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	02f50163          	beq	a0,a5,2c <main+0x2c>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	83058593          	add	a1,a1,-2000 # 840 <malloc+0x100>
  18:	4509                	li	a0,2
  1a:	00000097          	auipc	ra,0x0
  1e:	640080e7          	jalr	1600(ra) # 65a <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	00000097          	auipc	ra,0x0
  28:	2dc080e7          	jalr	732(ra) # 300 <exit>
  2c:	e426                	sd	s1,8(sp)
  2e:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  30:	698c                	ld	a1,16(a1)
  32:	6488                	ld	a0,8(s1)
  34:	00000097          	auipc	ra,0x0
  38:	32c080e7          	jalr	812(ra) # 360 <link>
  3c:	00054763          	bltz	a0,4a <main+0x4a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  40:	4501                	li	a0,0
  42:	00000097          	auipc	ra,0x0
  46:	2be080e7          	jalr	702(ra) # 300 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4a:	6894                	ld	a3,16(s1)
  4c:	6490                	ld	a2,8(s1)
  4e:	00001597          	auipc	a1,0x1
  52:	80a58593          	add	a1,a1,-2038 # 858 <malloc+0x118>
  56:	4509                	li	a0,2
  58:	00000097          	auipc	ra,0x0
  5c:	602080e7          	jalr	1538(ra) # 65a <fprintf>
  60:	b7c5                	j	40 <main+0x40>

0000000000000062 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  62:	1141                	add	sp,sp,-16
  64:	e406                	sd	ra,8(sp)
  66:	e022                	sd	s0,0(sp)
  68:	0800                	add	s0,sp,16
  extern int main();
  main();
  6a:	00000097          	auipc	ra,0x0
  6e:	f96080e7          	jalr	-106(ra) # 0 <main>
  exit(0);
  72:	4501                	li	a0,0
  74:	00000097          	auipc	ra,0x0
  78:	28c080e7          	jalr	652(ra) # 300 <exit>

000000000000007c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  7c:	1141                	add	sp,sp,-16
  7e:	e422                	sd	s0,8(sp)
  80:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  82:	87aa                	mv	a5,a0
  84:	0585                	add	a1,a1,1
  86:	0785                	add	a5,a5,1
  88:	fff5c703          	lbu	a4,-1(a1)
  8c:	fee78fa3          	sb	a4,-1(a5)
  90:	fb75                	bnez	a4,84 <strcpy+0x8>
    ;
  return os;
}
  92:	6422                	ld	s0,8(sp)
  94:	0141                	add	sp,sp,16
  96:	8082                	ret

0000000000000098 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  98:	1141                	add	sp,sp,-16
  9a:	e422                	sd	s0,8(sp)
  9c:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  9e:	00054783          	lbu	a5,0(a0)
  a2:	cb91                	beqz	a5,b6 <strcmp+0x1e>
  a4:	0005c703          	lbu	a4,0(a1)
  a8:	00f71763          	bne	a4,a5,b6 <strcmp+0x1e>
    p++, q++;
  ac:	0505                	add	a0,a0,1
  ae:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  b0:	00054783          	lbu	a5,0(a0)
  b4:	fbe5                	bnez	a5,a4 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  b6:	0005c503          	lbu	a0,0(a1)
}
  ba:	40a7853b          	subw	a0,a5,a0
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	add	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strlen>:

uint
strlen(const char *s)
{
  c4:	1141                	add	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cf91                	beqz	a5,ea <strlen+0x26>
  d0:	0505                	add	a0,a0,1
  d2:	87aa                	mv	a5,a0
  d4:	86be                	mv	a3,a5
  d6:	0785                	add	a5,a5,1
  d8:	fff7c703          	lbu	a4,-1(a5)
  dc:	ff65                	bnez	a4,d4 <strlen+0x10>
  de:	40a6853b          	subw	a0,a3,a0
  e2:	2505                	addw	a0,a0,1
    ;
  return n;
}
  e4:	6422                	ld	s0,8(sp)
  e6:	0141                	add	sp,sp,16
  e8:	8082                	ret
  for(n = 0; s[n]; n++)
  ea:	4501                	li	a0,0
  ec:	bfe5                	j	e4 <strlen+0x20>

00000000000000ee <memset>:

void*
memset(void *dst, int c, uint n)
{
  ee:	1141                	add	sp,sp,-16
  f0:	e422                	sd	s0,8(sp)
  f2:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  f4:	ca19                	beqz	a2,10a <memset+0x1c>
  f6:	87aa                	mv	a5,a0
  f8:	1602                	sll	a2,a2,0x20
  fa:	9201                	srl	a2,a2,0x20
  fc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 100:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 104:	0785                	add	a5,a5,1
 106:	fee79de3          	bne	a5,a4,100 <memset+0x12>
  }
  return dst;
}
 10a:	6422                	ld	s0,8(sp)
 10c:	0141                	add	sp,sp,16
 10e:	8082                	ret

0000000000000110 <strchr>:

char*
strchr(const char *s, char c)
{
 110:	1141                	add	sp,sp,-16
 112:	e422                	sd	s0,8(sp)
 114:	0800                	add	s0,sp,16
  for(; *s; s++)
 116:	00054783          	lbu	a5,0(a0)
 11a:	cb99                	beqz	a5,130 <strchr+0x20>
    if(*s == c)
 11c:	00f58763          	beq	a1,a5,12a <strchr+0x1a>
  for(; *s; s++)
 120:	0505                	add	a0,a0,1
 122:	00054783          	lbu	a5,0(a0)
 126:	fbfd                	bnez	a5,11c <strchr+0xc>
      return (char*)s;
  return 0;
 128:	4501                	li	a0,0
}
 12a:	6422                	ld	s0,8(sp)
 12c:	0141                	add	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfe5                	j	12a <strchr+0x1a>

0000000000000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	711d                	add	sp,sp,-96
 136:	ec86                	sd	ra,88(sp)
 138:	e8a2                	sd	s0,80(sp)
 13a:	e4a6                	sd	s1,72(sp)
 13c:	e0ca                	sd	s2,64(sp)
 13e:	fc4e                	sd	s3,56(sp)
 140:	f852                	sd	s4,48(sp)
 142:	f456                	sd	s5,40(sp)
 144:	f05a                	sd	s6,32(sp)
 146:	ec5e                	sd	s7,24(sp)
 148:	1080                	add	s0,sp,96
 14a:	8baa                	mv	s7,a0
 14c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 14e:	892a                	mv	s2,a0
 150:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 152:	4aa9                	li	s5,10
 154:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 156:	89a6                	mv	s3,s1
 158:	2485                	addw	s1,s1,1
 15a:	0344d863          	bge	s1,s4,18a <gets+0x56>
    cc = read(0, &c, 1);
 15e:	4605                	li	a2,1
 160:	faf40593          	add	a1,s0,-81
 164:	4501                	li	a0,0
 166:	00000097          	auipc	ra,0x0
 16a:	1b2080e7          	jalr	434(ra) # 318 <read>
    if(cc < 1)
 16e:	00a05e63          	blez	a0,18a <gets+0x56>
    buf[i++] = c;
 172:	faf44783          	lbu	a5,-81(s0)
 176:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17a:	01578763          	beq	a5,s5,188 <gets+0x54>
 17e:	0905                	add	s2,s2,1
 180:	fd679be3          	bne	a5,s6,156 <gets+0x22>
    buf[i++] = c;
 184:	89a6                	mv	s3,s1
 186:	a011                	j	18a <gets+0x56>
 188:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 18a:	99de                	add	s3,s3,s7
 18c:	00098023          	sb	zero,0(s3)
  return buf;
}
 190:	855e                	mv	a0,s7
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6125                	add	sp,sp,96
 1a6:	8082                	ret

00000000000001a8 <stat>:

int
stat(const char *n, struct stat *st)
{
 1a8:	1101                	add	sp,sp,-32
 1aa:	ec06                	sd	ra,24(sp)
 1ac:	e822                	sd	s0,16(sp)
 1ae:	e04a                	sd	s2,0(sp)
 1b0:	1000                	add	s0,sp,32
 1b2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b4:	4581                	li	a1,0
 1b6:	00000097          	auipc	ra,0x0
 1ba:	18a080e7          	jalr	394(ra) # 340 <open>
  if(fd < 0)
 1be:	02054663          	bltz	a0,1ea <stat+0x42>
 1c2:	e426                	sd	s1,8(sp)
 1c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c6:	85ca                	mv	a1,s2
 1c8:	00000097          	auipc	ra,0x0
 1cc:	190080e7          	jalr	400(ra) # 358 <fstat>
 1d0:	892a                	mv	s2,a0
  close(fd);
 1d2:	8526                	mv	a0,s1
 1d4:	00000097          	auipc	ra,0x0
 1d8:	154080e7          	jalr	340(ra) # 328 <close>
  return r;
 1dc:	64a2                	ld	s1,8(sp)
}
 1de:	854a                	mv	a0,s2
 1e0:	60e2                	ld	ra,24(sp)
 1e2:	6442                	ld	s0,16(sp)
 1e4:	6902                	ld	s2,0(sp)
 1e6:	6105                	add	sp,sp,32
 1e8:	8082                	ret
    return -1;
 1ea:	597d                	li	s2,-1
 1ec:	bfcd                	j	1de <stat+0x36>

00000000000001ee <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 1ee:	1141                	add	sp,sp,-16
 1f0:	e422                	sd	s0,8(sp)
 1f2:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 1f4:	00054703          	lbu	a4,0(a0)
 1f8:	02d00793          	li	a5,45
 1fc:	4585                	li	a1,1
 1fe:	04f70363          	beq	a4,a5,244 <atoi+0x56>

  while('0' <= *s && *s <= '9')
 202:	00054703          	lbu	a4,0(a0)
 206:	fd07079b          	addw	a5,a4,-48
 20a:	0ff7f793          	zext.b	a5,a5
 20e:	46a5                	li	a3,9
 210:	02f6ed63          	bltu	a3,a5,24a <atoi+0x5c>
  int n = 0;
 214:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 216:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 218:	0505                	add	a0,a0,1
 21a:	0026979b          	sllw	a5,a3,0x2
 21e:	9fb5                	addw	a5,a5,a3
 220:	0017979b          	sllw	a5,a5,0x1
 224:	9fb9                	addw	a5,a5,a4
 226:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 22a:	00054703          	lbu	a4,0(a0)
 22e:	fd07079b          	addw	a5,a4,-48
 232:	0ff7f793          	zext.b	a5,a5
 236:	fef671e3          	bgeu	a2,a5,218 <atoi+0x2a>
  return sign * n;
}
 23a:	02d5853b          	mulw	a0,a1,a3
 23e:	6422                	ld	s0,8(sp)
 240:	0141                	add	sp,sp,16
 242:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 244:	0505                	add	a0,a0,1
 246:	55fd                	li	a1,-1
 248:	bf6d                	j	202 <atoi+0x14>
  int n = 0;
 24a:	4681                	li	a3,0
 24c:	b7fd                	j	23a <atoi+0x4c>

000000000000024e <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24e:	1141                	add	sp,sp,-16
 250:	e422                	sd	s0,8(sp)
 252:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57463          	bgeu	a0,a1,27c <memmove+0x2e>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x28>
 25c:	1602                	sll	a2,a2,0x20
 25e:	9201                	srl	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	add	a1,a1,1
 268:	0705                	add	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fef71ae3          	bne	a4,a5,266 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	6422                	ld	s0,8(sp)
 278:	0141                	add	sp,sp,16
 27a:	8082                	ret
    dst += n;
 27c:	00c50733          	add	a4,a0,a2
    src += n;
 280:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 282:	fec05ae3          	blez	a2,276 <memmove+0x28>
 286:	fff6079b          	addw	a5,a2,-1
 28a:	1782                	sll	a5,a5,0x20
 28c:	9381                	srl	a5,a5,0x20
 28e:	fff7c793          	not	a5,a5
 292:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 294:	15fd                	add	a1,a1,-1
 296:	177d                	add	a4,a4,-1
 298:	0005c683          	lbu	a3,0(a1)
 29c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a0:	fee79ae3          	bne	a5,a4,294 <memmove+0x46>
 2a4:	bfc9                	j	276 <memmove+0x28>

00000000000002a6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a6:	1141                	add	sp,sp,-16
 2a8:	e422                	sd	s0,8(sp)
 2aa:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ca05                	beqz	a2,2dc <memcmp+0x36>
 2ae:	fff6069b          	addw	a3,a2,-1
 2b2:	1682                	sll	a3,a3,0x20
 2b4:	9281                	srl	a3,a3,0x20
 2b6:	0685                	add	a3,a3,1
 2b8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	add	a0,a0,1
    p2++;
 2c8:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x14>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x30>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	6422                	ld	s0,8(sp)
 2d8:	0141                	add	sp,sp,16
 2da:	8082                	ret
  return 0;
 2dc:	4501                	li	a0,0
 2de:	bfe5                	j	2d6 <memcmp+0x30>

00000000000002e0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e0:	1141                	add	sp,sp,-16
 2e2:	e406                	sd	ra,8(sp)
 2e4:	e022                	sd	s0,0(sp)
 2e6:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 2e8:	00000097          	auipc	ra,0x0
 2ec:	f66080e7          	jalr	-154(ra) # 24e <memmove>
}
 2f0:	60a2                	ld	ra,8(sp)
 2f2:	6402                	ld	s0,0(sp)
 2f4:	0141                	add	sp,sp,16
 2f6:	8082                	ret

00000000000002f8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2f8:	4885                	li	a7,1
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <exit>:
.global exit
exit:
 li a7, SYS_exit
 300:	4889                	li	a7,2
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <wait>:
.global wait
wait:
 li a7, SYS_wait
 308:	488d                	li	a7,3
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 310:	4891                	li	a7,4
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <read>:
.global read
read:
 li a7, SYS_read
 318:	4895                	li	a7,5
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <write>:
.global write
write:
 li a7, SYS_write
 320:	48c1                	li	a7,16
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <close>:
.global close
close:
 li a7, SYS_close
 328:	48d5                	li	a7,21
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <kill>:
.global kill
kill:
 li a7, SYS_kill
 330:	4899                	li	a7,6
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exec>:
.global exec
exec:
 li a7, SYS_exec
 338:	489d                	li	a7,7
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <open>:
.global open
open:
 li a7, SYS_open
 340:	48bd                	li	a7,15
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 348:	48c5                	li	a7,17
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 350:	48c9                	li	a7,18
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 358:	48a1                	li	a7,8
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <link>:
.global link
link:
 li a7, SYS_link
 360:	48cd                	li	a7,19
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 368:	48d1                	li	a7,20
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 370:	48a5                	li	a7,9
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <dup>:
.global dup
dup:
 li a7, SYS_dup
 378:	48a9                	li	a7,10
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 380:	48ad                	li	a7,11
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 388:	48b1                	li	a7,12
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 390:	48b5                	li	a7,13
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 398:	48b9                	li	a7,14
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 3a0:	48d9                	li	a7,22
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 3a8:	48dd                	li	a7,23
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3b0:	48e1                	li	a7,24
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3b8:	48e5                	li	a7,25
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3c0:	1101                	add	sp,sp,-32
 3c2:	ec06                	sd	ra,24(sp)
 3c4:	e822                	sd	s0,16(sp)
 3c6:	1000                	add	s0,sp,32
 3c8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3cc:	4605                	li	a2,1
 3ce:	fef40593          	add	a1,s0,-17
 3d2:	00000097          	auipc	ra,0x0
 3d6:	f4e080e7          	jalr	-178(ra) # 320 <write>
}
 3da:	60e2                	ld	ra,24(sp)
 3dc:	6442                	ld	s0,16(sp)
 3de:	6105                	add	sp,sp,32
 3e0:	8082                	ret

00000000000003e2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e2:	7139                	add	sp,sp,-64
 3e4:	fc06                	sd	ra,56(sp)
 3e6:	f822                	sd	s0,48(sp)
 3e8:	f426                	sd	s1,40(sp)
 3ea:	0080                	add	s0,sp,64
 3ec:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ee:	c299                	beqz	a3,3f4 <printint+0x12>
 3f0:	0805cb63          	bltz	a1,486 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3f4:	2581                	sext.w	a1,a1
  neg = 0;
 3f6:	4881                	li	a7,0
 3f8:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 3fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fe:	2601                	sext.w	a2,a2
 400:	00000517          	auipc	a0,0x0
 404:	4d050513          	add	a0,a0,1232 # 8d0 <digits>
 408:	883a                	mv	a6,a4
 40a:	2705                	addw	a4,a4,1
 40c:	02c5f7bb          	remuw	a5,a1,a2
 410:	1782                	sll	a5,a5,0x20
 412:	9381                	srl	a5,a5,0x20
 414:	97aa                	add	a5,a5,a0
 416:	0007c783          	lbu	a5,0(a5)
 41a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41e:	0005879b          	sext.w	a5,a1
 422:	02c5d5bb          	divuw	a1,a1,a2
 426:	0685                	add	a3,a3,1
 428:	fec7f0e3          	bgeu	a5,a2,408 <printint+0x26>
  if(neg)
 42c:	00088c63          	beqz	a7,444 <printint+0x62>
    buf[i++] = '-';
 430:	fd070793          	add	a5,a4,-48
 434:	00878733          	add	a4,a5,s0
 438:	02d00793          	li	a5,45
 43c:	fef70823          	sb	a5,-16(a4)
 440:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 444:	02e05c63          	blez	a4,47c <printint+0x9a>
 448:	f04a                	sd	s2,32(sp)
 44a:	ec4e                	sd	s3,24(sp)
 44c:	fc040793          	add	a5,s0,-64
 450:	00e78933          	add	s2,a5,a4
 454:	fff78993          	add	s3,a5,-1
 458:	99ba                	add	s3,s3,a4
 45a:	377d                	addw	a4,a4,-1
 45c:	1702                	sll	a4,a4,0x20
 45e:	9301                	srl	a4,a4,0x20
 460:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 464:	fff94583          	lbu	a1,-1(s2)
 468:	8526                	mv	a0,s1
 46a:	00000097          	auipc	ra,0x0
 46e:	f56080e7          	jalr	-170(ra) # 3c0 <putc>
  while(--i >= 0)
 472:	197d                	add	s2,s2,-1
 474:	ff3918e3          	bne	s2,s3,464 <printint+0x82>
 478:	7902                	ld	s2,32(sp)
 47a:	69e2                	ld	s3,24(sp)
}
 47c:	70e2                	ld	ra,56(sp)
 47e:	7442                	ld	s0,48(sp)
 480:	74a2                	ld	s1,40(sp)
 482:	6121                	add	sp,sp,64
 484:	8082                	ret
    x = -xx;
 486:	40b005bb          	negw	a1,a1
    neg = 1;
 48a:	4885                	li	a7,1
    x = -xx;
 48c:	b7b5                	j	3f8 <printint+0x16>

000000000000048e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 48e:	715d                	add	sp,sp,-80
 490:	e486                	sd	ra,72(sp)
 492:	e0a2                	sd	s0,64(sp)
 494:	f84a                	sd	s2,48(sp)
 496:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 498:	0005c903          	lbu	s2,0(a1)
 49c:	1a090a63          	beqz	s2,650 <vprintf+0x1c2>
 4a0:	fc26                	sd	s1,56(sp)
 4a2:	f44e                	sd	s3,40(sp)
 4a4:	f052                	sd	s4,32(sp)
 4a6:	ec56                	sd	s5,24(sp)
 4a8:	e85a                	sd	s6,16(sp)
 4aa:	e45e                	sd	s7,8(sp)
 4ac:	8aaa                	mv	s5,a0
 4ae:	8bb2                	mv	s7,a2
 4b0:	00158493          	add	s1,a1,1
  state = 0;
 4b4:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b6:	02500a13          	li	s4,37
 4ba:	4b55                	li	s6,21
 4bc:	a839                	j	4da <vprintf+0x4c>
        putc(fd, c);
 4be:	85ca                	mv	a1,s2
 4c0:	8556                	mv	a0,s5
 4c2:	00000097          	auipc	ra,0x0
 4c6:	efe080e7          	jalr	-258(ra) # 3c0 <putc>
 4ca:	a019                	j	4d0 <vprintf+0x42>
    } else if(state == '%'){
 4cc:	01498d63          	beq	s3,s4,4e6 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4d0:	0485                	add	s1,s1,1
 4d2:	fff4c903          	lbu	s2,-1(s1)
 4d6:	16090763          	beqz	s2,644 <vprintf+0x1b6>
    if(state == 0){
 4da:	fe0999e3          	bnez	s3,4cc <vprintf+0x3e>
      if(c == '%'){
 4de:	ff4910e3          	bne	s2,s4,4be <vprintf+0x30>
        state = '%';
 4e2:	89d2                	mv	s3,s4
 4e4:	b7f5                	j	4d0 <vprintf+0x42>
      if(c == 'd'){
 4e6:	13490463          	beq	s2,s4,60e <vprintf+0x180>
 4ea:	f9d9079b          	addw	a5,s2,-99
 4ee:	0ff7f793          	zext.b	a5,a5
 4f2:	12fb6763          	bltu	s6,a5,620 <vprintf+0x192>
 4f6:	f9d9079b          	addw	a5,s2,-99
 4fa:	0ff7f713          	zext.b	a4,a5
 4fe:	12eb6163          	bltu	s6,a4,620 <vprintf+0x192>
 502:	00271793          	sll	a5,a4,0x2
 506:	00000717          	auipc	a4,0x0
 50a:	37270713          	add	a4,a4,882 # 878 <malloc+0x138>
 50e:	97ba                	add	a5,a5,a4
 510:	439c                	lw	a5,0(a5)
 512:	97ba                	add	a5,a5,a4
 514:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 516:	008b8913          	add	s2,s7,8
 51a:	4685                	li	a3,1
 51c:	4629                	li	a2,10
 51e:	000ba583          	lw	a1,0(s7)
 522:	8556                	mv	a0,s5
 524:	00000097          	auipc	ra,0x0
 528:	ebe080e7          	jalr	-322(ra) # 3e2 <printint>
 52c:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 52e:	4981                	li	s3,0
 530:	b745                	j	4d0 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 532:	008b8913          	add	s2,s7,8
 536:	4681                	li	a3,0
 538:	4629                	li	a2,10
 53a:	000ba583          	lw	a1,0(s7)
 53e:	8556                	mv	a0,s5
 540:	00000097          	auipc	ra,0x0
 544:	ea2080e7          	jalr	-350(ra) # 3e2 <printint>
 548:	8bca                	mv	s7,s2
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b751                	j	4d0 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 54e:	008b8913          	add	s2,s7,8
 552:	4681                	li	a3,0
 554:	4641                	li	a2,16
 556:	000ba583          	lw	a1,0(s7)
 55a:	8556                	mv	a0,s5
 55c:	00000097          	auipc	ra,0x0
 560:	e86080e7          	jalr	-378(ra) # 3e2 <printint>
 564:	8bca                	mv	s7,s2
      state = 0;
 566:	4981                	li	s3,0
 568:	b7a5                	j	4d0 <vprintf+0x42>
 56a:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 56c:	008b8c13          	add	s8,s7,8
 570:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 574:	03000593          	li	a1,48
 578:	8556                	mv	a0,s5
 57a:	00000097          	auipc	ra,0x0
 57e:	e46080e7          	jalr	-442(ra) # 3c0 <putc>
  putc(fd, 'x');
 582:	07800593          	li	a1,120
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e38080e7          	jalr	-456(ra) # 3c0 <putc>
 590:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 592:	00000b97          	auipc	s7,0x0
 596:	33eb8b93          	add	s7,s7,830 # 8d0 <digits>
 59a:	03c9d793          	srl	a5,s3,0x3c
 59e:	97de                	add	a5,a5,s7
 5a0:	0007c583          	lbu	a1,0(a5)
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e1a080e7          	jalr	-486(ra) # 3c0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5ae:	0992                	sll	s3,s3,0x4
 5b0:	397d                	addw	s2,s2,-1
 5b2:	fe0914e3          	bnez	s2,59a <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5b6:	8be2                	mv	s7,s8
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	6c02                	ld	s8,0(sp)
 5bc:	bf11                	j	4d0 <vprintf+0x42>
        s = va_arg(ap, char*);
 5be:	008b8993          	add	s3,s7,8
 5c2:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5c6:	02090163          	beqz	s2,5e8 <vprintf+0x15a>
        while(*s != 0){
 5ca:	00094583          	lbu	a1,0(s2)
 5ce:	c9a5                	beqz	a1,63e <vprintf+0x1b0>
          putc(fd, *s);
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	dee080e7          	jalr	-530(ra) # 3c0 <putc>
          s++;
 5da:	0905                	add	s2,s2,1
        while(*s != 0){
 5dc:	00094583          	lbu	a1,0(s2)
 5e0:	f9e5                	bnez	a1,5d0 <vprintf+0x142>
        s = va_arg(ap, char*);
 5e2:	8bce                	mv	s7,s3
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b5ed                	j	4d0 <vprintf+0x42>
          s = "(null)";
 5e8:	00000917          	auipc	s2,0x0
 5ec:	28890913          	add	s2,s2,648 # 870 <malloc+0x130>
        while(*s != 0){
 5f0:	02800593          	li	a1,40
 5f4:	bff1                	j	5d0 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 5f6:	008b8913          	add	s2,s7,8
 5fa:	000bc583          	lbu	a1,0(s7)
 5fe:	8556                	mv	a0,s5
 600:	00000097          	auipc	ra,0x0
 604:	dc0080e7          	jalr	-576(ra) # 3c0 <putc>
 608:	8bca                	mv	s7,s2
      state = 0;
 60a:	4981                	li	s3,0
 60c:	b5d1                	j	4d0 <vprintf+0x42>
        putc(fd, c);
 60e:	02500593          	li	a1,37
 612:	8556                	mv	a0,s5
 614:	00000097          	auipc	ra,0x0
 618:	dac080e7          	jalr	-596(ra) # 3c0 <putc>
      state = 0;
 61c:	4981                	li	s3,0
 61e:	bd4d                	j	4d0 <vprintf+0x42>
        putc(fd, '%');
 620:	02500593          	li	a1,37
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	d9a080e7          	jalr	-614(ra) # 3c0 <putc>
        putc(fd, c);
 62e:	85ca                	mv	a1,s2
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	d8e080e7          	jalr	-626(ra) # 3c0 <putc>
      state = 0;
 63a:	4981                	li	s3,0
 63c:	bd51                	j	4d0 <vprintf+0x42>
        s = va_arg(ap, char*);
 63e:	8bce                	mv	s7,s3
      state = 0;
 640:	4981                	li	s3,0
 642:	b579                	j	4d0 <vprintf+0x42>
 644:	74e2                	ld	s1,56(sp)
 646:	79a2                	ld	s3,40(sp)
 648:	7a02                	ld	s4,32(sp)
 64a:	6ae2                	ld	s5,24(sp)
 64c:	6b42                	ld	s6,16(sp)
 64e:	6ba2                	ld	s7,8(sp)
    }
  }
}
 650:	60a6                	ld	ra,72(sp)
 652:	6406                	ld	s0,64(sp)
 654:	7942                	ld	s2,48(sp)
 656:	6161                	add	sp,sp,80
 658:	8082                	ret

000000000000065a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 65a:	715d                	add	sp,sp,-80
 65c:	ec06                	sd	ra,24(sp)
 65e:	e822                	sd	s0,16(sp)
 660:	1000                	add	s0,sp,32
 662:	e010                	sd	a2,0(s0)
 664:	e414                	sd	a3,8(s0)
 666:	e818                	sd	a4,16(s0)
 668:	ec1c                	sd	a5,24(s0)
 66a:	03043023          	sd	a6,32(s0)
 66e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 672:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 676:	8622                	mv	a2,s0
 678:	00000097          	auipc	ra,0x0
 67c:	e16080e7          	jalr	-490(ra) # 48e <vprintf>
}
 680:	60e2                	ld	ra,24(sp)
 682:	6442                	ld	s0,16(sp)
 684:	6161                	add	sp,sp,80
 686:	8082                	ret

0000000000000688 <printf>:

void
printf(const char *fmt, ...)
{
 688:	711d                	add	sp,sp,-96
 68a:	ec06                	sd	ra,24(sp)
 68c:	e822                	sd	s0,16(sp)
 68e:	1000                	add	s0,sp,32
 690:	e40c                	sd	a1,8(s0)
 692:	e810                	sd	a2,16(s0)
 694:	ec14                	sd	a3,24(s0)
 696:	f018                	sd	a4,32(s0)
 698:	f41c                	sd	a5,40(s0)
 69a:	03043823          	sd	a6,48(s0)
 69e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6a2:	00840613          	add	a2,s0,8
 6a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6aa:	85aa                	mv	a1,a0
 6ac:	4505                	li	a0,1
 6ae:	00000097          	auipc	ra,0x0
 6b2:	de0080e7          	jalr	-544(ra) # 48e <vprintf>
}
 6b6:	60e2                	ld	ra,24(sp)
 6b8:	6442                	ld	s0,16(sp)
 6ba:	6125                	add	sp,sp,96
 6bc:	8082                	ret

00000000000006be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6be:	1141                	add	sp,sp,-16
 6c0:	e422                	sd	s0,8(sp)
 6c2:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6c4:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c8:	00001797          	auipc	a5,0x1
 6cc:	9387b783          	ld	a5,-1736(a5) # 1000 <freep>
 6d0:	a02d                	j	6fa <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6d2:	4618                	lw	a4,8(a2)
 6d4:	9f2d                	addw	a4,a4,a1
 6d6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 6da:	6398                	ld	a4,0(a5)
 6dc:	6310                	ld	a2,0(a4)
 6de:	a83d                	j	71c <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6e0:	ff852703          	lw	a4,-8(a0)
 6e4:	9f31                	addw	a4,a4,a2
 6e6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 6e8:	ff053683          	ld	a3,-16(a0)
 6ec:	a091                	j	730 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6ee:	6398                	ld	a4,0(a5)
 6f0:	00e7e463          	bltu	a5,a4,6f8 <free+0x3a>
 6f4:	00e6ea63          	bltu	a3,a4,708 <free+0x4a>
{
 6f8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6fa:	fed7fae3          	bgeu	a5,a3,6ee <free+0x30>
 6fe:	6398                	ld	a4,0(a5)
 700:	00e6e463          	bltu	a3,a4,708 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 704:	fee7eae3          	bltu	a5,a4,6f8 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 708:	ff852583          	lw	a1,-8(a0)
 70c:	6390                	ld	a2,0(a5)
 70e:	02059813          	sll	a6,a1,0x20
 712:	01c85713          	srl	a4,a6,0x1c
 716:	9736                	add	a4,a4,a3
 718:	fae60de3          	beq	a2,a4,6d2 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 71c:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 720:	4790                	lw	a2,8(a5)
 722:	02061593          	sll	a1,a2,0x20
 726:	01c5d713          	srl	a4,a1,0x1c
 72a:	973e                	add	a4,a4,a5
 72c:	fae68ae3          	beq	a3,a4,6e0 <free+0x22>
    p->s.ptr = bp->s.ptr;
 730:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 732:	00001717          	auipc	a4,0x1
 736:	8cf73723          	sd	a5,-1842(a4) # 1000 <freep>
}
 73a:	6422                	ld	s0,8(sp)
 73c:	0141                	add	sp,sp,16
 73e:	8082                	ret

0000000000000740 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 740:	7139                	add	sp,sp,-64
 742:	fc06                	sd	ra,56(sp)
 744:	f822                	sd	s0,48(sp)
 746:	f426                	sd	s1,40(sp)
 748:	ec4e                	sd	s3,24(sp)
 74a:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 74c:	02051493          	sll	s1,a0,0x20
 750:	9081                	srl	s1,s1,0x20
 752:	04bd                	add	s1,s1,15
 754:	8091                	srl	s1,s1,0x4
 756:	0014899b          	addw	s3,s1,1
 75a:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 75c:	00001517          	auipc	a0,0x1
 760:	8a453503          	ld	a0,-1884(a0) # 1000 <freep>
 764:	c915                	beqz	a0,798 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 766:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 768:	4798                	lw	a4,8(a5)
 76a:	08977e63          	bgeu	a4,s1,806 <malloc+0xc6>
 76e:	f04a                	sd	s2,32(sp)
 770:	e852                	sd	s4,16(sp)
 772:	e456                	sd	s5,8(sp)
 774:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 776:	8a4e                	mv	s4,s3
 778:	0009871b          	sext.w	a4,s3
 77c:	6685                	lui	a3,0x1
 77e:	00d77363          	bgeu	a4,a3,784 <malloc+0x44>
 782:	6a05                	lui	s4,0x1
 784:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 788:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 78c:	00001917          	auipc	s2,0x1
 790:	87490913          	add	s2,s2,-1932 # 1000 <freep>
  if(p == (char*)-1)
 794:	5afd                	li	s5,-1
 796:	a091                	j	7da <malloc+0x9a>
 798:	f04a                	sd	s2,32(sp)
 79a:	e852                	sd	s4,16(sp)
 79c:	e456                	sd	s5,8(sp)
 79e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7a0:	00001797          	auipc	a5,0x1
 7a4:	87078793          	add	a5,a5,-1936 # 1010 <base>
 7a8:	00001717          	auipc	a4,0x1
 7ac:	84f73c23          	sd	a5,-1960(a4) # 1000 <freep>
 7b0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7b2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7b6:	b7c1                	j	776 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7b8:	6398                	ld	a4,0(a5)
 7ba:	e118                	sd	a4,0(a0)
 7bc:	a08d                	j	81e <malloc+0xde>
  hp->s.size = nu;
 7be:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7c2:	0541                	add	a0,a0,16
 7c4:	00000097          	auipc	ra,0x0
 7c8:	efa080e7          	jalr	-262(ra) # 6be <free>
  return freep;
 7cc:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7d0:	c13d                	beqz	a0,836 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7d2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7d4:	4798                	lw	a4,8(a5)
 7d6:	02977463          	bgeu	a4,s1,7fe <malloc+0xbe>
    if(p == freep)
 7da:	00093703          	ld	a4,0(s2)
 7de:	853e                	mv	a0,a5
 7e0:	fef719e3          	bne	a4,a5,7d2 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 7e4:	8552                	mv	a0,s4
 7e6:	00000097          	auipc	ra,0x0
 7ea:	ba2080e7          	jalr	-1118(ra) # 388 <sbrk>
  if(p == (char*)-1)
 7ee:	fd5518e3          	bne	a0,s5,7be <malloc+0x7e>
        return 0;
 7f2:	4501                	li	a0,0
 7f4:	7902                	ld	s2,32(sp)
 7f6:	6a42                	ld	s4,16(sp)
 7f8:	6aa2                	ld	s5,8(sp)
 7fa:	6b02                	ld	s6,0(sp)
 7fc:	a03d                	j	82a <malloc+0xea>
 7fe:	7902                	ld	s2,32(sp)
 800:	6a42                	ld	s4,16(sp)
 802:	6aa2                	ld	s5,8(sp)
 804:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 806:	fae489e3          	beq	s1,a4,7b8 <malloc+0x78>
        p->s.size -= nunits;
 80a:	4137073b          	subw	a4,a4,s3
 80e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 810:	02071693          	sll	a3,a4,0x20
 814:	01c6d713          	srl	a4,a3,0x1c
 818:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 81a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 81e:	00000717          	auipc	a4,0x0
 822:	7ea73123          	sd	a0,2018(a4) # 1000 <freep>
      return (void*)(p + 1);
 826:	01078513          	add	a0,a5,16
  }
}
 82a:	70e2                	ld	ra,56(sp)
 82c:	7442                	ld	s0,48(sp)
 82e:	74a2                	ld	s1,40(sp)
 830:	69e2                	ld	s3,24(sp)
 832:	6121                	add	sp,sp,64
 834:	8082                	ret
 836:	7902                	ld	s2,32(sp)
 838:	6a42                	ld	s4,16(sp)
 83a:	6aa2                	ld	s5,8(sp)
 83c:	6b02                	ld	s6,0(sp)
 83e:	b7f5                	j	82a <malloc+0xea>
