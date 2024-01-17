
user/_forktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <print>:

#define N  1000

void
print(const char *s)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	add	s0,sp,32
   a:	84aa                	mv	s1,a0
  write(1, s, strlen(s));
   c:	00000097          	auipc	ra,0x0
  10:	16c080e7          	jalr	364(ra) # 178 <strlen>
  14:	0005061b          	sext.w	a2,a0
  18:	85a6                	mv	a1,s1
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	3b8080e7          	jalr	952(ra) # 3d4 <write>
}
  24:	60e2                	ld	ra,24(sp)
  26:	6442                	ld	s0,16(sp)
  28:	64a2                	ld	s1,8(sp)
  2a:	6105                	add	sp,sp,32
  2c:	8082                	ret

000000000000002e <forktest>:

void
forktest(void)
{
  2e:	1101                	add	sp,sp,-32
  30:	ec06                	sd	ra,24(sp)
  32:	e822                	sd	s0,16(sp)
  34:	e426                	sd	s1,8(sp)
  36:	e04a                	sd	s2,0(sp)
  38:	1000                	add	s0,sp,32
  int n, pid;

  print("fork test\n");
  3a:	00000517          	auipc	a0,0x0
  3e:	43e50513          	add	a0,a0,1086 # 478 <munmap+0xc>
  42:	00000097          	auipc	ra,0x0
  46:	fbe080e7          	jalr	-66(ra) # 0 <print>

  for(n=0; n<N; n++){
  4a:	4481                	li	s1,0
  4c:	3e800913          	li	s2,1000
    pid = fork();
  50:	00000097          	auipc	ra,0x0
  54:	35c080e7          	jalr	860(ra) # 3ac <fork>
    if(pid < 0)
  58:	06054163          	bltz	a0,ba <forktest+0x8c>
      break;
    if(pid == 0)
  5c:	c10d                	beqz	a0,7e <forktest+0x50>
  for(n=0; n<N; n++){
  5e:	2485                	addw	s1,s1,1
  60:	ff2498e3          	bne	s1,s2,50 <forktest+0x22>
      exit(0);
  }

  if(n == N){
    print("fork claimed to work N times!\n");
  64:	00000517          	auipc	a0,0x0
  68:	46450513          	add	a0,a0,1124 # 4c8 <munmap+0x5c>
  6c:	00000097          	auipc	ra,0x0
  70:	f94080e7          	jalr	-108(ra) # 0 <print>
    exit(1);
  74:	4505                	li	a0,1
  76:	00000097          	auipc	ra,0x0
  7a:	33e080e7          	jalr	830(ra) # 3b4 <exit>
      exit(0);
  7e:	00000097          	auipc	ra,0x0
  82:	336080e7          	jalr	822(ra) # 3b4 <exit>
  }

  for(; n > 0; n--){
    if(wait(0) < 0){
      print("wait stopped early\n");
  86:	00000517          	auipc	a0,0x0
  8a:	40250513          	add	a0,a0,1026 # 488 <munmap+0x1c>
  8e:	00000097          	auipc	ra,0x0
  92:	f72080e7          	jalr	-142(ra) # 0 <print>
      exit(1);
  96:	4505                	li	a0,1
  98:	00000097          	auipc	ra,0x0
  9c:	31c080e7          	jalr	796(ra) # 3b4 <exit>
    }
  }

  if(wait(0) != -1){
    print("wait got too many\n");
  a0:	00000517          	auipc	a0,0x0
  a4:	40050513          	add	a0,a0,1024 # 4a0 <munmap+0x34>
  a8:	00000097          	auipc	ra,0x0
  ac:	f58080e7          	jalr	-168(ra) # 0 <print>
    exit(1);
  b0:	4505                	li	a0,1
  b2:	00000097          	auipc	ra,0x0
  b6:	302080e7          	jalr	770(ra) # 3b4 <exit>
  for(; n > 0; n--){
  ba:	00905b63          	blez	s1,d0 <forktest+0xa2>
    if(wait(0) < 0){
  be:	4501                	li	a0,0
  c0:	00000097          	auipc	ra,0x0
  c4:	2fc080e7          	jalr	764(ra) # 3bc <wait>
  c8:	fa054fe3          	bltz	a0,86 <forktest+0x58>
  for(; n > 0; n--){
  cc:	34fd                	addw	s1,s1,-1
  ce:	f8e5                	bnez	s1,be <forktest+0x90>
  if(wait(0) != -1){
  d0:	4501                	li	a0,0
  d2:	00000097          	auipc	ra,0x0
  d6:	2ea080e7          	jalr	746(ra) # 3bc <wait>
  da:	57fd                	li	a5,-1
  dc:	fcf512e3          	bne	a0,a5,a0 <forktest+0x72>
  }

  print("fork test OK\n");
  e0:	00000517          	auipc	a0,0x0
  e4:	3d850513          	add	a0,a0,984 # 4b8 <munmap+0x4c>
  e8:	00000097          	auipc	ra,0x0
  ec:	f18080e7          	jalr	-232(ra) # 0 <print>
}
  f0:	60e2                	ld	ra,24(sp)
  f2:	6442                	ld	s0,16(sp)
  f4:	64a2                	ld	s1,8(sp)
  f6:	6902                	ld	s2,0(sp)
  f8:	6105                	add	sp,sp,32
  fa:	8082                	ret

00000000000000fc <main>:

int
main(void)
{
  fc:	1141                	add	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	add	s0,sp,16
  forktest();
 104:	00000097          	auipc	ra,0x0
 108:	f2a080e7          	jalr	-214(ra) # 2e <forktest>
  exit(0);
 10c:	4501                	li	a0,0
 10e:	00000097          	auipc	ra,0x0
 112:	2a6080e7          	jalr	678(ra) # 3b4 <exit>

0000000000000116 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 116:	1141                	add	sp,sp,-16
 118:	e406                	sd	ra,8(sp)
 11a:	e022                	sd	s0,0(sp)
 11c:	0800                	add	s0,sp,16
  extern int main();
  main();
 11e:	00000097          	auipc	ra,0x0
 122:	fde080e7          	jalr	-34(ra) # fc <main>
  exit(0);
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	28c080e7          	jalr	652(ra) # 3b4 <exit>

0000000000000130 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 130:	1141                	add	sp,sp,-16
 132:	e422                	sd	s0,8(sp)
 134:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 136:	87aa                	mv	a5,a0
 138:	0585                	add	a1,a1,1
 13a:	0785                	add	a5,a5,1
 13c:	fff5c703          	lbu	a4,-1(a1)
 140:	fee78fa3          	sb	a4,-1(a5)
 144:	fb75                	bnez	a4,138 <strcpy+0x8>
    ;
  return os;
}
 146:	6422                	ld	s0,8(sp)
 148:	0141                	add	sp,sp,16
 14a:	8082                	ret

000000000000014c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14c:	1141                	add	sp,sp,-16
 14e:	e422                	sd	s0,8(sp)
 150:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 152:	00054783          	lbu	a5,0(a0)
 156:	cb91                	beqz	a5,16a <strcmp+0x1e>
 158:	0005c703          	lbu	a4,0(a1)
 15c:	00f71763          	bne	a4,a5,16a <strcmp+0x1e>
    p++, q++;
 160:	0505                	add	a0,a0,1
 162:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 164:	00054783          	lbu	a5,0(a0)
 168:	fbe5                	bnez	a5,158 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 16a:	0005c503          	lbu	a0,0(a1)
}
 16e:	40a7853b          	subw	a0,a5,a0
 172:	6422                	ld	s0,8(sp)
 174:	0141                	add	sp,sp,16
 176:	8082                	ret

0000000000000178 <strlen>:

uint
strlen(const char *s)
{
 178:	1141                	add	sp,sp,-16
 17a:	e422                	sd	s0,8(sp)
 17c:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 17e:	00054783          	lbu	a5,0(a0)
 182:	cf91                	beqz	a5,19e <strlen+0x26>
 184:	0505                	add	a0,a0,1
 186:	87aa                	mv	a5,a0
 188:	86be                	mv	a3,a5
 18a:	0785                	add	a5,a5,1
 18c:	fff7c703          	lbu	a4,-1(a5)
 190:	ff65                	bnez	a4,188 <strlen+0x10>
 192:	40a6853b          	subw	a0,a3,a0
 196:	2505                	addw	a0,a0,1
    ;
  return n;
}
 198:	6422                	ld	s0,8(sp)
 19a:	0141                	add	sp,sp,16
 19c:	8082                	ret
  for(n = 0; s[n]; n++)
 19e:	4501                	li	a0,0
 1a0:	bfe5                	j	198 <strlen+0x20>

00000000000001a2 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1a2:	1141                	add	sp,sp,-16
 1a4:	e422                	sd	s0,8(sp)
 1a6:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1a8:	ca19                	beqz	a2,1be <memset+0x1c>
 1aa:	87aa                	mv	a5,a0
 1ac:	1602                	sll	a2,a2,0x20
 1ae:	9201                	srl	a2,a2,0x20
 1b0:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1b4:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1b8:	0785                	add	a5,a5,1
 1ba:	fee79de3          	bne	a5,a4,1b4 <memset+0x12>
  }
  return dst;
}
 1be:	6422                	ld	s0,8(sp)
 1c0:	0141                	add	sp,sp,16
 1c2:	8082                	ret

00000000000001c4 <strchr>:

char*
strchr(const char *s, char c)
{
 1c4:	1141                	add	sp,sp,-16
 1c6:	e422                	sd	s0,8(sp)
 1c8:	0800                	add	s0,sp,16
  for(; *s; s++)
 1ca:	00054783          	lbu	a5,0(a0)
 1ce:	cb99                	beqz	a5,1e4 <strchr+0x20>
    if(*s == c)
 1d0:	00f58763          	beq	a1,a5,1de <strchr+0x1a>
  for(; *s; s++)
 1d4:	0505                	add	a0,a0,1
 1d6:	00054783          	lbu	a5,0(a0)
 1da:	fbfd                	bnez	a5,1d0 <strchr+0xc>
      return (char*)s;
  return 0;
 1dc:	4501                	li	a0,0
}
 1de:	6422                	ld	s0,8(sp)
 1e0:	0141                	add	sp,sp,16
 1e2:	8082                	ret
  return 0;
 1e4:	4501                	li	a0,0
 1e6:	bfe5                	j	1de <strchr+0x1a>

00000000000001e8 <gets>:

char*
gets(char *buf, int max)
{
 1e8:	711d                	add	sp,sp,-96
 1ea:	ec86                	sd	ra,88(sp)
 1ec:	e8a2                	sd	s0,80(sp)
 1ee:	e4a6                	sd	s1,72(sp)
 1f0:	e0ca                	sd	s2,64(sp)
 1f2:	fc4e                	sd	s3,56(sp)
 1f4:	f852                	sd	s4,48(sp)
 1f6:	f456                	sd	s5,40(sp)
 1f8:	f05a                	sd	s6,32(sp)
 1fa:	ec5e                	sd	s7,24(sp)
 1fc:	1080                	add	s0,sp,96
 1fe:	8baa                	mv	s7,a0
 200:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 202:	892a                	mv	s2,a0
 204:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 206:	4aa9                	li	s5,10
 208:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 20a:	89a6                	mv	s3,s1
 20c:	2485                	addw	s1,s1,1
 20e:	0344d863          	bge	s1,s4,23e <gets+0x56>
    cc = read(0, &c, 1);
 212:	4605                	li	a2,1
 214:	faf40593          	add	a1,s0,-81
 218:	4501                	li	a0,0
 21a:	00000097          	auipc	ra,0x0
 21e:	1b2080e7          	jalr	434(ra) # 3cc <read>
    if(cc < 1)
 222:	00a05e63          	blez	a0,23e <gets+0x56>
    buf[i++] = c;
 226:	faf44783          	lbu	a5,-81(s0)
 22a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 22e:	01578763          	beq	a5,s5,23c <gets+0x54>
 232:	0905                	add	s2,s2,1
 234:	fd679be3          	bne	a5,s6,20a <gets+0x22>
    buf[i++] = c;
 238:	89a6                	mv	s3,s1
 23a:	a011                	j	23e <gets+0x56>
 23c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 23e:	99de                	add	s3,s3,s7
 240:	00098023          	sb	zero,0(s3)
  return buf;
}
 244:	855e                	mv	a0,s7
 246:	60e6                	ld	ra,88(sp)
 248:	6446                	ld	s0,80(sp)
 24a:	64a6                	ld	s1,72(sp)
 24c:	6906                	ld	s2,64(sp)
 24e:	79e2                	ld	s3,56(sp)
 250:	7a42                	ld	s4,48(sp)
 252:	7aa2                	ld	s5,40(sp)
 254:	7b02                	ld	s6,32(sp)
 256:	6be2                	ld	s7,24(sp)
 258:	6125                	add	sp,sp,96
 25a:	8082                	ret

000000000000025c <stat>:

int
stat(const char *n, struct stat *st)
{
 25c:	1101                	add	sp,sp,-32
 25e:	ec06                	sd	ra,24(sp)
 260:	e822                	sd	s0,16(sp)
 262:	e04a                	sd	s2,0(sp)
 264:	1000                	add	s0,sp,32
 266:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 268:	4581                	li	a1,0
 26a:	00000097          	auipc	ra,0x0
 26e:	18a080e7          	jalr	394(ra) # 3f4 <open>
  if(fd < 0)
 272:	02054663          	bltz	a0,29e <stat+0x42>
 276:	e426                	sd	s1,8(sp)
 278:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 27a:	85ca                	mv	a1,s2
 27c:	00000097          	auipc	ra,0x0
 280:	190080e7          	jalr	400(ra) # 40c <fstat>
 284:	892a                	mv	s2,a0
  close(fd);
 286:	8526                	mv	a0,s1
 288:	00000097          	auipc	ra,0x0
 28c:	154080e7          	jalr	340(ra) # 3dc <close>
  return r;
 290:	64a2                	ld	s1,8(sp)
}
 292:	854a                	mv	a0,s2
 294:	60e2                	ld	ra,24(sp)
 296:	6442                	ld	s0,16(sp)
 298:	6902                	ld	s2,0(sp)
 29a:	6105                	add	sp,sp,32
 29c:	8082                	ret
    return -1;
 29e:	597d                	li	s2,-1
 2a0:	bfcd                	j	292 <stat+0x36>

00000000000002a2 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 2a2:	1141                	add	sp,sp,-16
 2a4:	e422                	sd	s0,8(sp)
 2a6:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 2a8:	00054703          	lbu	a4,0(a0)
 2ac:	02d00793          	li	a5,45
 2b0:	4585                	li	a1,1
 2b2:	04f70363          	beq	a4,a5,2f8 <atoi+0x56>

  while('0' <= *s && *s <= '9')
 2b6:	00054703          	lbu	a4,0(a0)
 2ba:	fd07079b          	addw	a5,a4,-48
 2be:	0ff7f793          	zext.b	a5,a5
 2c2:	46a5                	li	a3,9
 2c4:	02f6ed63          	bltu	a3,a5,2fe <atoi+0x5c>
  int n = 0;
 2c8:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 2ca:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 2cc:	0505                	add	a0,a0,1
 2ce:	0026979b          	sllw	a5,a3,0x2
 2d2:	9fb5                	addw	a5,a5,a3
 2d4:	0017979b          	sllw	a5,a5,0x1
 2d8:	9fb9                	addw	a5,a5,a4
 2da:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 2de:	00054703          	lbu	a4,0(a0)
 2e2:	fd07079b          	addw	a5,a4,-48
 2e6:	0ff7f793          	zext.b	a5,a5
 2ea:	fef671e3          	bgeu	a2,a5,2cc <atoi+0x2a>
  return sign * n;
}
 2ee:	02d5853b          	mulw	a0,a1,a3
 2f2:	6422                	ld	s0,8(sp)
 2f4:	0141                	add	sp,sp,16
 2f6:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 2f8:	0505                	add	a0,a0,1
 2fa:	55fd                	li	a1,-1
 2fc:	bf6d                	j	2b6 <atoi+0x14>
  int n = 0;
 2fe:	4681                	li	a3,0
 300:	b7fd                	j	2ee <atoi+0x4c>

0000000000000302 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 302:	1141                	add	sp,sp,-16
 304:	e422                	sd	s0,8(sp)
 306:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 308:	02b57463          	bgeu	a0,a1,330 <memmove+0x2e>
    while(n-- > 0)
 30c:	00c05f63          	blez	a2,32a <memmove+0x28>
 310:	1602                	sll	a2,a2,0x20
 312:	9201                	srl	a2,a2,0x20
 314:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 318:	872a                	mv	a4,a0
      *dst++ = *src++;
 31a:	0585                	add	a1,a1,1
 31c:	0705                	add	a4,a4,1
 31e:	fff5c683          	lbu	a3,-1(a1)
 322:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 326:	fef71ae3          	bne	a4,a5,31a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 32a:	6422                	ld	s0,8(sp)
 32c:	0141                	add	sp,sp,16
 32e:	8082                	ret
    dst += n;
 330:	00c50733          	add	a4,a0,a2
    src += n;
 334:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 336:	fec05ae3          	blez	a2,32a <memmove+0x28>
 33a:	fff6079b          	addw	a5,a2,-1
 33e:	1782                	sll	a5,a5,0x20
 340:	9381                	srl	a5,a5,0x20
 342:	fff7c793          	not	a5,a5
 346:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 348:	15fd                	add	a1,a1,-1
 34a:	177d                	add	a4,a4,-1
 34c:	0005c683          	lbu	a3,0(a1)
 350:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 354:	fee79ae3          	bne	a5,a4,348 <memmove+0x46>
 358:	bfc9                	j	32a <memmove+0x28>

000000000000035a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 35a:	1141                	add	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 360:	ca05                	beqz	a2,390 <memcmp+0x36>
 362:	fff6069b          	addw	a3,a2,-1
 366:	1682                	sll	a3,a3,0x20
 368:	9281                	srl	a3,a3,0x20
 36a:	0685                	add	a3,a3,1
 36c:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 36e:	00054783          	lbu	a5,0(a0)
 372:	0005c703          	lbu	a4,0(a1)
 376:	00e79863          	bne	a5,a4,386 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 37a:	0505                	add	a0,a0,1
    p2++;
 37c:	0585                	add	a1,a1,1
  while (n-- > 0) {
 37e:	fed518e3          	bne	a0,a3,36e <memcmp+0x14>
  }
  return 0;
 382:	4501                	li	a0,0
 384:	a019                	j	38a <memcmp+0x30>
      return *p1 - *p2;
 386:	40e7853b          	subw	a0,a5,a4
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	add	sp,sp,16
 38e:	8082                	ret
  return 0;
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <memcmp+0x30>

0000000000000394 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 394:	1141                	add	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 39c:	00000097          	auipc	ra,0x0
 3a0:	f66080e7          	jalr	-154(ra) # 302 <memmove>
}
 3a4:	60a2                	ld	ra,8(sp)
 3a6:	6402                	ld	s0,0(sp)
 3a8:	0141                	add	sp,sp,16
 3aa:	8082                	ret

00000000000003ac <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3ac:	4885                	li	a7,1
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b4:	4889                	li	a7,2
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <wait>:
.global wait
wait:
 li a7, SYS_wait
 3bc:	488d                	li	a7,3
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c4:	4891                	li	a7,4
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <read>:
.global read
read:
 li a7, SYS_read
 3cc:	4895                	li	a7,5
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <write>:
.global write
write:
 li a7, SYS_write
 3d4:	48c1                	li	a7,16
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <close>:
.global close
close:
 li a7, SYS_close
 3dc:	48d5                	li	a7,21
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e4:	4899                	li	a7,6
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ec:	489d                	li	a7,7
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <open>:
.global open
open:
 li a7, SYS_open
 3f4:	48bd                	li	a7,15
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fc:	48c5                	li	a7,17
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 404:	48c9                	li	a7,18
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40c:	48a1                	li	a7,8
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <link>:
.global link
link:
 li a7, SYS_link
 414:	48cd                	li	a7,19
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41c:	48d1                	li	a7,20
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 424:	48a5                	li	a7,9
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <dup>:
.global dup
dup:
 li a7, SYS_dup
 42c:	48a9                	li	a7,10
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 434:	48ad                	li	a7,11
 ecall
 436:	00000073          	ecall
 ret
 43a:	8082                	ret

000000000000043c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 43c:	48b1                	li	a7,12
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 444:	48b5                	li	a7,13
 ecall
 446:	00000073          	ecall
 ret
 44a:	8082                	ret

000000000000044c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44c:	48b9                	li	a7,14
 ecall
 44e:	00000073          	ecall
 ret
 452:	8082                	ret

0000000000000454 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 454:	48d9                	li	a7,22
 ecall
 456:	00000073          	ecall
 ret
 45a:	8082                	ret

000000000000045c <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 45c:	48dd                	li	a7,23
 ecall
 45e:	00000073          	ecall
 ret
 462:	8082                	ret

0000000000000464 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 464:	48e1                	li	a7,24
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 46c:	48e5                	li	a7,25
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret
