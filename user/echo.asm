
user/_echo:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	7139                	add	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	f04a                	sd	s2,32(sp)
   a:	ec4e                	sd	s3,24(sp)
   c:	e852                	sd	s4,16(sp)
   e:	e456                	sd	s5,8(sp)
  10:	0080                	add	s0,sp,64
  int i;

  for(i = 1; i < argc; i++){
  12:	4785                	li	a5,1
  14:	06a7d863          	bge	a5,a0,84 <main+0x84>
  18:	00858493          	add	s1,a1,8
  1c:	3579                	addw	a0,a0,-2
  1e:	02051793          	sll	a5,a0,0x20
  22:	01d7d513          	srl	a0,a5,0x1d
  26:	00a48a33          	add	s4,s1,a0
  2a:	05c1                	add	a1,a1,16
  2c:	00a589b3          	add	s3,a1,a0
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
  30:	00001a97          	auipc	s5,0x1
  34:	840a8a93          	add	s5,s5,-1984 # 870 <malloc+0x104>
  38:	a819                	j	4e <main+0x4e>
  3a:	4605                	li	a2,1
  3c:	85d6                	mv	a1,s5
  3e:	4505                	li	a0,1
  40:	00000097          	auipc	ra,0x0
  44:	30c080e7          	jalr	780(ra) # 34c <write>
  for(i = 1; i < argc; i++){
  48:	04a1                	add	s1,s1,8
  4a:	03348d63          	beq	s1,s3,84 <main+0x84>
    write(1, argv[i], strlen(argv[i]));
  4e:	0004b903          	ld	s2,0(s1)
  52:	854a                	mv	a0,s2
  54:	00000097          	auipc	ra,0x0
  58:	09c080e7          	jalr	156(ra) # f0 <strlen>
  5c:	0005061b          	sext.w	a2,a0
  60:	85ca                	mv	a1,s2
  62:	4505                	li	a0,1
  64:	00000097          	auipc	ra,0x0
  68:	2e8080e7          	jalr	744(ra) # 34c <write>
    if(i + 1 < argc){
  6c:	fd4497e3          	bne	s1,s4,3a <main+0x3a>
    } else {
      write(1, "\n", 1);
  70:	4605                	li	a2,1
  72:	00001597          	auipc	a1,0x1
  76:	80658593          	add	a1,a1,-2042 # 878 <malloc+0x10c>
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	2d0080e7          	jalr	720(ra) # 34c <write>
    }
  }
  exit(0);
  84:	4501                	li	a0,0
  86:	00000097          	auipc	ra,0x0
  8a:	2a6080e7          	jalr	678(ra) # 32c <exit>

000000000000008e <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  8e:	1141                	add	sp,sp,-16
  90:	e406                	sd	ra,8(sp)
  92:	e022                	sd	s0,0(sp)
  94:	0800                	add	s0,sp,16
  extern int main();
  main();
  96:	00000097          	auipc	ra,0x0
  9a:	f6a080e7          	jalr	-150(ra) # 0 <main>
  exit(0);
  9e:	4501                	li	a0,0
  a0:	00000097          	auipc	ra,0x0
  a4:	28c080e7          	jalr	652(ra) # 32c <exit>

00000000000000a8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  a8:	1141                	add	sp,sp,-16
  aa:	e422                	sd	s0,8(sp)
  ac:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  ae:	87aa                	mv	a5,a0
  b0:	0585                	add	a1,a1,1
  b2:	0785                	add	a5,a5,1
  b4:	fff5c703          	lbu	a4,-1(a1)
  b8:	fee78fa3          	sb	a4,-1(a5)
  bc:	fb75                	bnez	a4,b0 <strcpy+0x8>
    ;
  return os;
}
  be:	6422                	ld	s0,8(sp)
  c0:	0141                	add	sp,sp,16
  c2:	8082                	ret

00000000000000c4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  c4:	1141                	add	sp,sp,-16
  c6:	e422                	sd	s0,8(sp)
  c8:	0800                	add	s0,sp,16
  while(*p && *p == *q)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cb91                	beqz	a5,e2 <strcmp+0x1e>
  d0:	0005c703          	lbu	a4,0(a1)
  d4:	00f71763          	bne	a4,a5,e2 <strcmp+0x1e>
    p++, q++;
  d8:	0505                	add	a0,a0,1
  da:	0585                	add	a1,a1,1
  while(*p && *p == *q)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	fbe5                	bnez	a5,d0 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
  e2:	0005c503          	lbu	a0,0(a1)
}
  e6:	40a7853b          	subw	a0,a5,a0
  ea:	6422                	ld	s0,8(sp)
  ec:	0141                	add	sp,sp,16
  ee:	8082                	ret

00000000000000f0 <strlen>:

uint
strlen(const char *s)
{
  f0:	1141                	add	sp,sp,-16
  f2:	e422                	sd	s0,8(sp)
  f4:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f6:	00054783          	lbu	a5,0(a0)
  fa:	cf91                	beqz	a5,116 <strlen+0x26>
  fc:	0505                	add	a0,a0,1
  fe:	87aa                	mv	a5,a0
 100:	86be                	mv	a3,a5
 102:	0785                	add	a5,a5,1
 104:	fff7c703          	lbu	a4,-1(a5)
 108:	ff65                	bnez	a4,100 <strlen+0x10>
 10a:	40a6853b          	subw	a0,a3,a0
 10e:	2505                	addw	a0,a0,1
    ;
  return n;
}
 110:	6422                	ld	s0,8(sp)
 112:	0141                	add	sp,sp,16
 114:	8082                	ret
  for(n = 0; s[n]; n++)
 116:	4501                	li	a0,0
 118:	bfe5                	j	110 <strlen+0x20>

000000000000011a <memset>:

void*
memset(void *dst, int c, uint n)
{
 11a:	1141                	add	sp,sp,-16
 11c:	e422                	sd	s0,8(sp)
 11e:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1c>
 122:	87aa                	mv	a5,a0
 124:	1602                	sll	a2,a2,0x20
 126:	9201                	srl	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	add	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x12>
  }
  return dst;
}
 136:	6422                	ld	s0,8(sp)
 138:	0141                	add	sp,sp,16
 13a:	8082                	ret

000000000000013c <strchr>:

char*
strchr(const char *s, char c)
{
 13c:	1141                	add	sp,sp,-16
 13e:	e422                	sd	s0,8(sp)
 140:	0800                	add	s0,sp,16
  for(; *s; s++)
 142:	00054783          	lbu	a5,0(a0)
 146:	cb99                	beqz	a5,15c <strchr+0x20>
    if(*s == c)
 148:	00f58763          	beq	a1,a5,156 <strchr+0x1a>
  for(; *s; s++)
 14c:	0505                	add	a0,a0,1
 14e:	00054783          	lbu	a5,0(a0)
 152:	fbfd                	bnez	a5,148 <strchr+0xc>
      return (char*)s;
  return 0;
 154:	4501                	li	a0,0
}
 156:	6422                	ld	s0,8(sp)
 158:	0141                	add	sp,sp,16
 15a:	8082                	ret
  return 0;
 15c:	4501                	li	a0,0
 15e:	bfe5                	j	156 <strchr+0x1a>

0000000000000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	711d                	add	sp,sp,-96
 162:	ec86                	sd	ra,88(sp)
 164:	e8a2                	sd	s0,80(sp)
 166:	e4a6                	sd	s1,72(sp)
 168:	e0ca                	sd	s2,64(sp)
 16a:	fc4e                	sd	s3,56(sp)
 16c:	f852                	sd	s4,48(sp)
 16e:	f456                	sd	s5,40(sp)
 170:	f05a                	sd	s6,32(sp)
 172:	ec5e                	sd	s7,24(sp)
 174:	1080                	add	s0,sp,96
 176:	8baa                	mv	s7,a0
 178:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17a:	892a                	mv	s2,a0
 17c:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 17e:	4aa9                	li	s5,10
 180:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 182:	89a6                	mv	s3,s1
 184:	2485                	addw	s1,s1,1
 186:	0344d863          	bge	s1,s4,1b6 <gets+0x56>
    cc = read(0, &c, 1);
 18a:	4605                	li	a2,1
 18c:	faf40593          	add	a1,s0,-81
 190:	4501                	li	a0,0
 192:	00000097          	auipc	ra,0x0
 196:	1b2080e7          	jalr	434(ra) # 344 <read>
    if(cc < 1)
 19a:	00a05e63          	blez	a0,1b6 <gets+0x56>
    buf[i++] = c;
 19e:	faf44783          	lbu	a5,-81(s0)
 1a2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1a6:	01578763          	beq	a5,s5,1b4 <gets+0x54>
 1aa:	0905                	add	s2,s2,1
 1ac:	fd679be3          	bne	a5,s6,182 <gets+0x22>
    buf[i++] = c;
 1b0:	89a6                	mv	s3,s1
 1b2:	a011                	j	1b6 <gets+0x56>
 1b4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 1b6:	99de                	add	s3,s3,s7
 1b8:	00098023          	sb	zero,0(s3)
  return buf;
}
 1bc:	855e                	mv	a0,s7
 1be:	60e6                	ld	ra,88(sp)
 1c0:	6446                	ld	s0,80(sp)
 1c2:	64a6                	ld	s1,72(sp)
 1c4:	6906                	ld	s2,64(sp)
 1c6:	79e2                	ld	s3,56(sp)
 1c8:	7a42                	ld	s4,48(sp)
 1ca:	7aa2                	ld	s5,40(sp)
 1cc:	7b02                	ld	s6,32(sp)
 1ce:	6be2                	ld	s7,24(sp)
 1d0:	6125                	add	sp,sp,96
 1d2:	8082                	ret

00000000000001d4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d4:	1101                	add	sp,sp,-32
 1d6:	ec06                	sd	ra,24(sp)
 1d8:	e822                	sd	s0,16(sp)
 1da:	e04a                	sd	s2,0(sp)
 1dc:	1000                	add	s0,sp,32
 1de:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e0:	4581                	li	a1,0
 1e2:	00000097          	auipc	ra,0x0
 1e6:	18a080e7          	jalr	394(ra) # 36c <open>
  if(fd < 0)
 1ea:	02054663          	bltz	a0,216 <stat+0x42>
 1ee:	e426                	sd	s1,8(sp)
 1f0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f2:	85ca                	mv	a1,s2
 1f4:	00000097          	auipc	ra,0x0
 1f8:	190080e7          	jalr	400(ra) # 384 <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	00000097          	auipc	ra,0x0
 204:	154080e7          	jalr	340(ra) # 354 <close>
  return r;
 208:	64a2                	ld	s1,8(sp)
}
 20a:	854a                	mv	a0,s2
 20c:	60e2                	ld	ra,24(sp)
 20e:	6442                	ld	s0,16(sp)
 210:	6902                	ld	s2,0(sp)
 212:	6105                	add	sp,sp,32
 214:	8082                	ret
    return -1;
 216:	597d                	li	s2,-1
 218:	bfcd                	j	20a <stat+0x36>

000000000000021a <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 21a:	1141                	add	sp,sp,-16
 21c:	e422                	sd	s0,8(sp)
 21e:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 220:	00054703          	lbu	a4,0(a0)
 224:	02d00793          	li	a5,45
 228:	4585                	li	a1,1
 22a:	04f70363          	beq	a4,a5,270 <atoi+0x56>

  while('0' <= *s && *s <= '9')
 22e:	00054703          	lbu	a4,0(a0)
 232:	fd07079b          	addw	a5,a4,-48
 236:	0ff7f793          	zext.b	a5,a5
 23a:	46a5                	li	a3,9
 23c:	02f6ed63          	bltu	a3,a5,276 <atoi+0x5c>
  int n = 0;
 240:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 242:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 244:	0505                	add	a0,a0,1
 246:	0026979b          	sllw	a5,a3,0x2
 24a:	9fb5                	addw	a5,a5,a3
 24c:	0017979b          	sllw	a5,a5,0x1
 250:	9fb9                	addw	a5,a5,a4
 252:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 256:	00054703          	lbu	a4,0(a0)
 25a:	fd07079b          	addw	a5,a4,-48
 25e:	0ff7f793          	zext.b	a5,a5
 262:	fef671e3          	bgeu	a2,a5,244 <atoi+0x2a>
  return sign * n;
}
 266:	02d5853b          	mulw	a0,a1,a3
 26a:	6422                	ld	s0,8(sp)
 26c:	0141                	add	sp,sp,16
 26e:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 270:	0505                	add	a0,a0,1
 272:	55fd                	li	a1,-1
 274:	bf6d                	j	22e <atoi+0x14>
  int n = 0;
 276:	4681                	li	a3,0
 278:	b7fd                	j	266 <atoi+0x4c>

000000000000027a <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 27a:	1141                	add	sp,sp,-16
 27c:	e422                	sd	s0,8(sp)
 27e:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 280:	02b57463          	bgeu	a0,a1,2a8 <memmove+0x2e>
    while(n-- > 0)
 284:	00c05f63          	blez	a2,2a2 <memmove+0x28>
 288:	1602                	sll	a2,a2,0x20
 28a:	9201                	srl	a2,a2,0x20
 28c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 290:	872a                	mv	a4,a0
      *dst++ = *src++;
 292:	0585                	add	a1,a1,1
 294:	0705                	add	a4,a4,1
 296:	fff5c683          	lbu	a3,-1(a1)
 29a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 29e:	fef71ae3          	bne	a4,a5,292 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2a2:	6422                	ld	s0,8(sp)
 2a4:	0141                	add	sp,sp,16
 2a6:	8082                	ret
    dst += n;
 2a8:	00c50733          	add	a4,a0,a2
    src += n;
 2ac:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 2ae:	fec05ae3          	blez	a2,2a2 <memmove+0x28>
 2b2:	fff6079b          	addw	a5,a2,-1
 2b6:	1782                	sll	a5,a5,0x20
 2b8:	9381                	srl	a5,a5,0x20
 2ba:	fff7c793          	not	a5,a5
 2be:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2c0:	15fd                	add	a1,a1,-1
 2c2:	177d                	add	a4,a4,-1
 2c4:	0005c683          	lbu	a3,0(a1)
 2c8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2cc:	fee79ae3          	bne	a5,a4,2c0 <memmove+0x46>
 2d0:	bfc9                	j	2a2 <memmove+0x28>

00000000000002d2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2d2:	1141                	add	sp,sp,-16
 2d4:	e422                	sd	s0,8(sp)
 2d6:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2d8:	ca05                	beqz	a2,308 <memcmp+0x36>
 2da:	fff6069b          	addw	a3,a2,-1
 2de:	1682                	sll	a3,a3,0x20
 2e0:	9281                	srl	a3,a3,0x20
 2e2:	0685                	add	a3,a3,1
 2e4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	0005c703          	lbu	a4,0(a1)
 2ee:	00e79863          	bne	a5,a4,2fe <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 2f2:	0505                	add	a0,a0,1
    p2++;
 2f4:	0585                	add	a1,a1,1
  while (n-- > 0) {
 2f6:	fed518e3          	bne	a0,a3,2e6 <memcmp+0x14>
  }
  return 0;
 2fa:	4501                	li	a0,0
 2fc:	a019                	j	302 <memcmp+0x30>
      return *p1 - *p2;
 2fe:	40e7853b          	subw	a0,a5,a4
}
 302:	6422                	ld	s0,8(sp)
 304:	0141                	add	sp,sp,16
 306:	8082                	ret
  return 0;
 308:	4501                	li	a0,0
 30a:	bfe5                	j	302 <memcmp+0x30>

000000000000030c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 314:	00000097          	auipc	ra,0x0
 318:	f66080e7          	jalr	-154(ra) # 27a <memmove>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	add	sp,sp,16
 322:	8082                	ret

0000000000000324 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 324:	4885                	li	a7,1
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <exit>:
.global exit
exit:
 li a7, SYS_exit
 32c:	4889                	li	a7,2
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <wait>:
.global wait
wait:
 li a7, SYS_wait
 334:	488d                	li	a7,3
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33c:	4891                	li	a7,4
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <read>:
.global read
read:
 li a7, SYS_read
 344:	4895                	li	a7,5
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <write>:
.global write
write:
 li a7, SYS_write
 34c:	48c1                	li	a7,16
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <close>:
.global close
close:
 li a7, SYS_close
 354:	48d5                	li	a7,21
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <kill>:
.global kill
kill:
 li a7, SYS_kill
 35c:	4899                	li	a7,6
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <exec>:
.global exec
exec:
 li a7, SYS_exec
 364:	489d                	li	a7,7
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <open>:
.global open
open:
 li a7, SYS_open
 36c:	48bd                	li	a7,15
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 374:	48c5                	li	a7,17
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37c:	48c9                	li	a7,18
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 384:	48a1                	li	a7,8
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <link>:
.global link
link:
 li a7, SYS_link
 38c:	48cd                	li	a7,19
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 394:	48d1                	li	a7,20
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39c:	48a5                	li	a7,9
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a4:	48a9                	li	a7,10
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3ac:	48ad                	li	a7,11
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 3b4:	48b1                	li	a7,12
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 3bc:	48b5                	li	a7,13
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c4:	48b9                	li	a7,14
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 3cc:	48d9                	li	a7,22
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 3d4:	48dd                	li	a7,23
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 3dc:	48e1                	li	a7,24
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 3e4:	48e5                	li	a7,25
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ec:	1101                	add	sp,sp,-32
 3ee:	ec06                	sd	ra,24(sp)
 3f0:	e822                	sd	s0,16(sp)
 3f2:	1000                	add	s0,sp,32
 3f4:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f8:	4605                	li	a2,1
 3fa:	fef40593          	add	a1,s0,-17
 3fe:	00000097          	auipc	ra,0x0
 402:	f4e080e7          	jalr	-178(ra) # 34c <write>
}
 406:	60e2                	ld	ra,24(sp)
 408:	6442                	ld	s0,16(sp)
 40a:	6105                	add	sp,sp,32
 40c:	8082                	ret

000000000000040e <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 40e:	7139                	add	sp,sp,-64
 410:	fc06                	sd	ra,56(sp)
 412:	f822                	sd	s0,48(sp)
 414:	f426                	sd	s1,40(sp)
 416:	0080                	add	s0,sp,64
 418:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 41a:	c299                	beqz	a3,420 <printint+0x12>
 41c:	0805cb63          	bltz	a1,4b2 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 420:	2581                	sext.w	a1,a1
  neg = 0;
 422:	4881                	li	a7,0
 424:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 428:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 42a:	2601                	sext.w	a2,a2
 42c:	00000517          	auipc	a0,0x0
 430:	4b450513          	add	a0,a0,1204 # 8e0 <digits>
 434:	883a                	mv	a6,a4
 436:	2705                	addw	a4,a4,1
 438:	02c5f7bb          	remuw	a5,a1,a2
 43c:	1782                	sll	a5,a5,0x20
 43e:	9381                	srl	a5,a5,0x20
 440:	97aa                	add	a5,a5,a0
 442:	0007c783          	lbu	a5,0(a5)
 446:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 44a:	0005879b          	sext.w	a5,a1
 44e:	02c5d5bb          	divuw	a1,a1,a2
 452:	0685                	add	a3,a3,1
 454:	fec7f0e3          	bgeu	a5,a2,434 <printint+0x26>
  if(neg)
 458:	00088c63          	beqz	a7,470 <printint+0x62>
    buf[i++] = '-';
 45c:	fd070793          	add	a5,a4,-48
 460:	00878733          	add	a4,a5,s0
 464:	02d00793          	li	a5,45
 468:	fef70823          	sb	a5,-16(a4)
 46c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 470:	02e05c63          	blez	a4,4a8 <printint+0x9a>
 474:	f04a                	sd	s2,32(sp)
 476:	ec4e                	sd	s3,24(sp)
 478:	fc040793          	add	a5,s0,-64
 47c:	00e78933          	add	s2,a5,a4
 480:	fff78993          	add	s3,a5,-1
 484:	99ba                	add	s3,s3,a4
 486:	377d                	addw	a4,a4,-1
 488:	1702                	sll	a4,a4,0x20
 48a:	9301                	srl	a4,a4,0x20
 48c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 490:	fff94583          	lbu	a1,-1(s2)
 494:	8526                	mv	a0,s1
 496:	00000097          	auipc	ra,0x0
 49a:	f56080e7          	jalr	-170(ra) # 3ec <putc>
  while(--i >= 0)
 49e:	197d                	add	s2,s2,-1
 4a0:	ff3918e3          	bne	s2,s3,490 <printint+0x82>
 4a4:	7902                	ld	s2,32(sp)
 4a6:	69e2                	ld	s3,24(sp)
}
 4a8:	70e2                	ld	ra,56(sp)
 4aa:	7442                	ld	s0,48(sp)
 4ac:	74a2                	ld	s1,40(sp)
 4ae:	6121                	add	sp,sp,64
 4b0:	8082                	ret
    x = -xx;
 4b2:	40b005bb          	negw	a1,a1
    neg = 1;
 4b6:	4885                	li	a7,1
    x = -xx;
 4b8:	b7b5                	j	424 <printint+0x16>

00000000000004ba <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4ba:	715d                	add	sp,sp,-80
 4bc:	e486                	sd	ra,72(sp)
 4be:	e0a2                	sd	s0,64(sp)
 4c0:	f84a                	sd	s2,48(sp)
 4c2:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c4:	0005c903          	lbu	s2,0(a1)
 4c8:	1a090a63          	beqz	s2,67c <vprintf+0x1c2>
 4cc:	fc26                	sd	s1,56(sp)
 4ce:	f44e                	sd	s3,40(sp)
 4d0:	f052                	sd	s4,32(sp)
 4d2:	ec56                	sd	s5,24(sp)
 4d4:	e85a                	sd	s6,16(sp)
 4d6:	e45e                	sd	s7,8(sp)
 4d8:	8aaa                	mv	s5,a0
 4da:	8bb2                	mv	s7,a2
 4dc:	00158493          	add	s1,a1,1
  state = 0;
 4e0:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4e2:	02500a13          	li	s4,37
 4e6:	4b55                	li	s6,21
 4e8:	a839                	j	506 <vprintf+0x4c>
        putc(fd, c);
 4ea:	85ca                	mv	a1,s2
 4ec:	8556                	mv	a0,s5
 4ee:	00000097          	auipc	ra,0x0
 4f2:	efe080e7          	jalr	-258(ra) # 3ec <putc>
 4f6:	a019                	j	4fc <vprintf+0x42>
    } else if(state == '%'){
 4f8:	01498d63          	beq	s3,s4,512 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 4fc:	0485                	add	s1,s1,1
 4fe:	fff4c903          	lbu	s2,-1(s1)
 502:	16090763          	beqz	s2,670 <vprintf+0x1b6>
    if(state == 0){
 506:	fe0999e3          	bnez	s3,4f8 <vprintf+0x3e>
      if(c == '%'){
 50a:	ff4910e3          	bne	s2,s4,4ea <vprintf+0x30>
        state = '%';
 50e:	89d2                	mv	s3,s4
 510:	b7f5                	j	4fc <vprintf+0x42>
      if(c == 'd'){
 512:	13490463          	beq	s2,s4,63a <vprintf+0x180>
 516:	f9d9079b          	addw	a5,s2,-99
 51a:	0ff7f793          	zext.b	a5,a5
 51e:	12fb6763          	bltu	s6,a5,64c <vprintf+0x192>
 522:	f9d9079b          	addw	a5,s2,-99
 526:	0ff7f713          	zext.b	a4,a5
 52a:	12eb6163          	bltu	s6,a4,64c <vprintf+0x192>
 52e:	00271793          	sll	a5,a4,0x2
 532:	00000717          	auipc	a4,0x0
 536:	35670713          	add	a4,a4,854 # 888 <malloc+0x11c>
 53a:	97ba                	add	a5,a5,a4
 53c:	439c                	lw	a5,0(a5)
 53e:	97ba                	add	a5,a5,a4
 540:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 542:	008b8913          	add	s2,s7,8
 546:	4685                	li	a3,1
 548:	4629                	li	a2,10
 54a:	000ba583          	lw	a1,0(s7)
 54e:	8556                	mv	a0,s5
 550:	00000097          	auipc	ra,0x0
 554:	ebe080e7          	jalr	-322(ra) # 40e <printint>
 558:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 55a:	4981                	li	s3,0
 55c:	b745                	j	4fc <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 55e:	008b8913          	add	s2,s7,8
 562:	4681                	li	a3,0
 564:	4629                	li	a2,10
 566:	000ba583          	lw	a1,0(s7)
 56a:	8556                	mv	a0,s5
 56c:	00000097          	auipc	ra,0x0
 570:	ea2080e7          	jalr	-350(ra) # 40e <printint>
 574:	8bca                	mv	s7,s2
      state = 0;
 576:	4981                	li	s3,0
 578:	b751                	j	4fc <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 57a:	008b8913          	add	s2,s7,8
 57e:	4681                	li	a3,0
 580:	4641                	li	a2,16
 582:	000ba583          	lw	a1,0(s7)
 586:	8556                	mv	a0,s5
 588:	00000097          	auipc	ra,0x0
 58c:	e86080e7          	jalr	-378(ra) # 40e <printint>
 590:	8bca                	mv	s7,s2
      state = 0;
 592:	4981                	li	s3,0
 594:	b7a5                	j	4fc <vprintf+0x42>
 596:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 598:	008b8c13          	add	s8,s7,8
 59c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5a0:	03000593          	li	a1,48
 5a4:	8556                	mv	a0,s5
 5a6:	00000097          	auipc	ra,0x0
 5aa:	e46080e7          	jalr	-442(ra) # 3ec <putc>
  putc(fd, 'x');
 5ae:	07800593          	li	a1,120
 5b2:	8556                	mv	a0,s5
 5b4:	00000097          	auipc	ra,0x0
 5b8:	e38080e7          	jalr	-456(ra) # 3ec <putc>
 5bc:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5be:	00000b97          	auipc	s7,0x0
 5c2:	322b8b93          	add	s7,s7,802 # 8e0 <digits>
 5c6:	03c9d793          	srl	a5,s3,0x3c
 5ca:	97de                	add	a5,a5,s7
 5cc:	0007c583          	lbu	a1,0(a5)
 5d0:	8556                	mv	a0,s5
 5d2:	00000097          	auipc	ra,0x0
 5d6:	e1a080e7          	jalr	-486(ra) # 3ec <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5da:	0992                	sll	s3,s3,0x4
 5dc:	397d                	addw	s2,s2,-1
 5de:	fe0914e3          	bnez	s2,5c6 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 5e2:	8be2                	mv	s7,s8
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	6c02                	ld	s8,0(sp)
 5e8:	bf11                	j	4fc <vprintf+0x42>
        s = va_arg(ap, char*);
 5ea:	008b8993          	add	s3,s7,8
 5ee:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 5f2:	02090163          	beqz	s2,614 <vprintf+0x15a>
        while(*s != 0){
 5f6:	00094583          	lbu	a1,0(s2)
 5fa:	c9a5                	beqz	a1,66a <vprintf+0x1b0>
          putc(fd, *s);
 5fc:	8556                	mv	a0,s5
 5fe:	00000097          	auipc	ra,0x0
 602:	dee080e7          	jalr	-530(ra) # 3ec <putc>
          s++;
 606:	0905                	add	s2,s2,1
        while(*s != 0){
 608:	00094583          	lbu	a1,0(s2)
 60c:	f9e5                	bnez	a1,5fc <vprintf+0x142>
        s = va_arg(ap, char*);
 60e:	8bce                	mv	s7,s3
      state = 0;
 610:	4981                	li	s3,0
 612:	b5ed                	j	4fc <vprintf+0x42>
          s = "(null)";
 614:	00000917          	auipc	s2,0x0
 618:	26c90913          	add	s2,s2,620 # 880 <malloc+0x114>
        while(*s != 0){
 61c:	02800593          	li	a1,40
 620:	bff1                	j	5fc <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 622:	008b8913          	add	s2,s7,8
 626:	000bc583          	lbu	a1,0(s7)
 62a:	8556                	mv	a0,s5
 62c:	00000097          	auipc	ra,0x0
 630:	dc0080e7          	jalr	-576(ra) # 3ec <putc>
 634:	8bca                	mv	s7,s2
      state = 0;
 636:	4981                	li	s3,0
 638:	b5d1                	j	4fc <vprintf+0x42>
        putc(fd, c);
 63a:	02500593          	li	a1,37
 63e:	8556                	mv	a0,s5
 640:	00000097          	auipc	ra,0x0
 644:	dac080e7          	jalr	-596(ra) # 3ec <putc>
      state = 0;
 648:	4981                	li	s3,0
 64a:	bd4d                	j	4fc <vprintf+0x42>
        putc(fd, '%');
 64c:	02500593          	li	a1,37
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	d9a080e7          	jalr	-614(ra) # 3ec <putc>
        putc(fd, c);
 65a:	85ca                	mv	a1,s2
 65c:	8556                	mv	a0,s5
 65e:	00000097          	auipc	ra,0x0
 662:	d8e080e7          	jalr	-626(ra) # 3ec <putc>
      state = 0;
 666:	4981                	li	s3,0
 668:	bd51                	j	4fc <vprintf+0x42>
        s = va_arg(ap, char*);
 66a:	8bce                	mv	s7,s3
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b579                	j	4fc <vprintf+0x42>
 670:	74e2                	ld	s1,56(sp)
 672:	79a2                	ld	s3,40(sp)
 674:	7a02                	ld	s4,32(sp)
 676:	6ae2                	ld	s5,24(sp)
 678:	6b42                	ld	s6,16(sp)
 67a:	6ba2                	ld	s7,8(sp)
    }
  }
}
 67c:	60a6                	ld	ra,72(sp)
 67e:	6406                	ld	s0,64(sp)
 680:	7942                	ld	s2,48(sp)
 682:	6161                	add	sp,sp,80
 684:	8082                	ret

0000000000000686 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 686:	715d                	add	sp,sp,-80
 688:	ec06                	sd	ra,24(sp)
 68a:	e822                	sd	s0,16(sp)
 68c:	1000                	add	s0,sp,32
 68e:	e010                	sd	a2,0(s0)
 690:	e414                	sd	a3,8(s0)
 692:	e818                	sd	a4,16(s0)
 694:	ec1c                	sd	a5,24(s0)
 696:	03043023          	sd	a6,32(s0)
 69a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 69e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 6a2:	8622                	mv	a2,s0
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e16080e7          	jalr	-490(ra) # 4ba <vprintf>
}
 6ac:	60e2                	ld	ra,24(sp)
 6ae:	6442                	ld	s0,16(sp)
 6b0:	6161                	add	sp,sp,80
 6b2:	8082                	ret

00000000000006b4 <printf>:

void
printf(const char *fmt, ...)
{
 6b4:	711d                	add	sp,sp,-96
 6b6:	ec06                	sd	ra,24(sp)
 6b8:	e822                	sd	s0,16(sp)
 6ba:	1000                	add	s0,sp,32
 6bc:	e40c                	sd	a1,8(s0)
 6be:	e810                	sd	a2,16(s0)
 6c0:	ec14                	sd	a3,24(s0)
 6c2:	f018                	sd	a4,32(s0)
 6c4:	f41c                	sd	a5,40(s0)
 6c6:	03043823          	sd	a6,48(s0)
 6ca:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 6ce:	00840613          	add	a2,s0,8
 6d2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 6d6:	85aa                	mv	a1,a0
 6d8:	4505                	li	a0,1
 6da:	00000097          	auipc	ra,0x0
 6de:	de0080e7          	jalr	-544(ra) # 4ba <vprintf>
}
 6e2:	60e2                	ld	ra,24(sp)
 6e4:	6442                	ld	s0,16(sp)
 6e6:	6125                	add	sp,sp,96
 6e8:	8082                	ret

00000000000006ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6ea:	1141                	add	sp,sp,-16
 6ec:	e422                	sd	s0,8(sp)
 6ee:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6f0:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6f4:	00001797          	auipc	a5,0x1
 6f8:	90c7b783          	ld	a5,-1780(a5) # 1000 <freep>
 6fc:	a02d                	j	726 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 6fe:	4618                	lw	a4,8(a2)
 700:	9f2d                	addw	a4,a4,a1
 702:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 706:	6398                	ld	a4,0(a5)
 708:	6310                	ld	a2,0(a4)
 70a:	a83d                	j	748 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 70c:	ff852703          	lw	a4,-8(a0)
 710:	9f31                	addw	a4,a4,a2
 712:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 714:	ff053683          	ld	a3,-16(a0)
 718:	a091                	j	75c <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 71a:	6398                	ld	a4,0(a5)
 71c:	00e7e463          	bltu	a5,a4,724 <free+0x3a>
 720:	00e6ea63          	bltu	a3,a4,734 <free+0x4a>
{
 724:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 726:	fed7fae3          	bgeu	a5,a3,71a <free+0x30>
 72a:	6398                	ld	a4,0(a5)
 72c:	00e6e463          	bltu	a3,a4,734 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 730:	fee7eae3          	bltu	a5,a4,724 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 734:	ff852583          	lw	a1,-8(a0)
 738:	6390                	ld	a2,0(a5)
 73a:	02059813          	sll	a6,a1,0x20
 73e:	01c85713          	srl	a4,a6,0x1c
 742:	9736                	add	a4,a4,a3
 744:	fae60de3          	beq	a2,a4,6fe <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 748:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 74c:	4790                	lw	a2,8(a5)
 74e:	02061593          	sll	a1,a2,0x20
 752:	01c5d713          	srl	a4,a1,0x1c
 756:	973e                	add	a4,a4,a5
 758:	fae68ae3          	beq	a3,a4,70c <free+0x22>
    p->s.ptr = bp->s.ptr;
 75c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 75e:	00001717          	auipc	a4,0x1
 762:	8af73123          	sd	a5,-1886(a4) # 1000 <freep>
}
 766:	6422                	ld	s0,8(sp)
 768:	0141                	add	sp,sp,16
 76a:	8082                	ret

000000000000076c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 76c:	7139                	add	sp,sp,-64
 76e:	fc06                	sd	ra,56(sp)
 770:	f822                	sd	s0,48(sp)
 772:	f426                	sd	s1,40(sp)
 774:	ec4e                	sd	s3,24(sp)
 776:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 778:	02051493          	sll	s1,a0,0x20
 77c:	9081                	srl	s1,s1,0x20
 77e:	04bd                	add	s1,s1,15
 780:	8091                	srl	s1,s1,0x4
 782:	0014899b          	addw	s3,s1,1
 786:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 788:	00001517          	auipc	a0,0x1
 78c:	87853503          	ld	a0,-1928(a0) # 1000 <freep>
 790:	c915                	beqz	a0,7c4 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 792:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 794:	4798                	lw	a4,8(a5)
 796:	08977e63          	bgeu	a4,s1,832 <malloc+0xc6>
 79a:	f04a                	sd	s2,32(sp)
 79c:	e852                	sd	s4,16(sp)
 79e:	e456                	sd	s5,8(sp)
 7a0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 7a2:	8a4e                	mv	s4,s3
 7a4:	0009871b          	sext.w	a4,s3
 7a8:	6685                	lui	a3,0x1
 7aa:	00d77363          	bgeu	a4,a3,7b0 <malloc+0x44>
 7ae:	6a05                	lui	s4,0x1
 7b0:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 7b4:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 7b8:	00001917          	auipc	s2,0x1
 7bc:	84890913          	add	s2,s2,-1976 # 1000 <freep>
  if(p == (char*)-1)
 7c0:	5afd                	li	s5,-1
 7c2:	a091                	j	806 <malloc+0x9a>
 7c4:	f04a                	sd	s2,32(sp)
 7c6:	e852                	sd	s4,16(sp)
 7c8:	e456                	sd	s5,8(sp)
 7ca:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 7cc:	00001797          	auipc	a5,0x1
 7d0:	84478793          	add	a5,a5,-1980 # 1010 <base>
 7d4:	00001717          	auipc	a4,0x1
 7d8:	82f73623          	sd	a5,-2004(a4) # 1000 <freep>
 7dc:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 7de:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 7e2:	b7c1                	j	7a2 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 7e4:	6398                	ld	a4,0(a5)
 7e6:	e118                	sd	a4,0(a0)
 7e8:	a08d                	j	84a <malloc+0xde>
  hp->s.size = nu;
 7ea:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 7ee:	0541                	add	a0,a0,16
 7f0:	00000097          	auipc	ra,0x0
 7f4:	efa080e7          	jalr	-262(ra) # 6ea <free>
  return freep;
 7f8:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 7fc:	c13d                	beqz	a0,862 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 800:	4798                	lw	a4,8(a5)
 802:	02977463          	bgeu	a4,s1,82a <malloc+0xbe>
    if(p == freep)
 806:	00093703          	ld	a4,0(s2)
 80a:	853e                	mv	a0,a5
 80c:	fef719e3          	bne	a4,a5,7fe <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 810:	8552                	mv	a0,s4
 812:	00000097          	auipc	ra,0x0
 816:	ba2080e7          	jalr	-1118(ra) # 3b4 <sbrk>
  if(p == (char*)-1)
 81a:	fd5518e3          	bne	a0,s5,7ea <malloc+0x7e>
        return 0;
 81e:	4501                	li	a0,0
 820:	7902                	ld	s2,32(sp)
 822:	6a42                	ld	s4,16(sp)
 824:	6aa2                	ld	s5,8(sp)
 826:	6b02                	ld	s6,0(sp)
 828:	a03d                	j	856 <malloc+0xea>
 82a:	7902                	ld	s2,32(sp)
 82c:	6a42                	ld	s4,16(sp)
 82e:	6aa2                	ld	s5,8(sp)
 830:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 832:	fae489e3          	beq	s1,a4,7e4 <malloc+0x78>
        p->s.size -= nunits;
 836:	4137073b          	subw	a4,a4,s3
 83a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 83c:	02071693          	sll	a3,a4,0x20
 840:	01c6d713          	srl	a4,a3,0x1c
 844:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 846:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 84a:	00000717          	auipc	a4,0x0
 84e:	7aa73b23          	sd	a0,1974(a4) # 1000 <freep>
      return (void*)(p + 1);
 852:	01078513          	add	a0,a5,16
  }
}
 856:	70e2                	ld	ra,56(sp)
 858:	7442                	ld	s0,48(sp)
 85a:	74a2                	ld	s1,40(sp)
 85c:	69e2                	ld	s3,24(sp)
 85e:	6121                	add	sp,sp,64
 860:	8082                	ret
 862:	7902                	ld	s2,32(sp)
 864:	6a42                	ld	s4,16(sp)
 866:	6aa2                	ld	s5,8(sp)
 868:	6b02                	ld	s6,0(sp)
 86a:	b7f5                	j	856 <malloc+0xea>
