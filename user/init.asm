
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	add	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	add	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	8d250513          	add	a0,a0,-1838 # 8e0 <malloc+0x10a>
  16:	00000097          	auipc	ra,0x0
  1a:	3c0080e7          	jalr	960(ra) # 3d6 <open>
  1e:	06054363          	bltz	a0,84 <main+0x84>
    mknod("console", CONSOLE, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  22:	4501                	li	a0,0
  24:	00000097          	auipc	ra,0x0
  28:	3ea080e7          	jalr	1002(ra) # 40e <dup>
  dup(0);  // stderr
  2c:	4501                	li	a0,0
  2e:	00000097          	auipc	ra,0x0
  32:	3e0080e7          	jalr	992(ra) # 40e <dup>

  for(;;){
    printf("init: starting sh\n");
  36:	00001917          	auipc	s2,0x1
  3a:	8b290913          	add	s2,s2,-1870 # 8e8 <malloc+0x112>
  3e:	854a                	mv	a0,s2
  40:	00000097          	auipc	ra,0x0
  44:	6de080e7          	jalr	1758(ra) # 71e <printf>
    pid = fork();
  48:	00000097          	auipc	ra,0x0
  4c:	346080e7          	jalr	838(ra) # 38e <fork>
  50:	84aa                	mv	s1,a0
    if(pid < 0){
  52:	04054d63          	bltz	a0,ac <main+0xac>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  56:	c925                	beqz	a0,c6 <main+0xc6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  58:	4501                	li	a0,0
  5a:	00000097          	auipc	ra,0x0
  5e:	344080e7          	jalr	836(ra) # 39e <wait>
      if(wpid == pid){
  62:	fca48ee3          	beq	s1,a0,3e <main+0x3e>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  66:	fe0559e3          	bgez	a0,58 <main+0x58>
        printf("init: wait returned an error\n");
  6a:	00001517          	auipc	a0,0x1
  6e:	8ce50513          	add	a0,a0,-1842 # 938 <malloc+0x162>
  72:	00000097          	auipc	ra,0x0
  76:	6ac080e7          	jalr	1708(ra) # 71e <printf>
        exit(1);
  7a:	4505                	li	a0,1
  7c:	00000097          	auipc	ra,0x0
  80:	31a080e7          	jalr	794(ra) # 396 <exit>
    mknod("console", CONSOLE, 0);
  84:	4601                	li	a2,0
  86:	4585                	li	a1,1
  88:	00001517          	auipc	a0,0x1
  8c:	85850513          	add	a0,a0,-1960 # 8e0 <malloc+0x10a>
  90:	00000097          	auipc	ra,0x0
  94:	34e080e7          	jalr	846(ra) # 3de <mknod>
    open("console", O_RDWR);
  98:	4589                	li	a1,2
  9a:	00001517          	auipc	a0,0x1
  9e:	84650513          	add	a0,a0,-1978 # 8e0 <malloc+0x10a>
  a2:	00000097          	auipc	ra,0x0
  a6:	334080e7          	jalr	820(ra) # 3d6 <open>
  aa:	bfa5                	j	22 <main+0x22>
      printf("init: fork failed\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	85450513          	add	a0,a0,-1964 # 900 <malloc+0x12a>
  b4:	00000097          	auipc	ra,0x0
  b8:	66a080e7          	jalr	1642(ra) # 71e <printf>
      exit(1);
  bc:	4505                	li	a0,1
  be:	00000097          	auipc	ra,0x0
  c2:	2d8080e7          	jalr	728(ra) # 396 <exit>
      exec("sh", argv);
  c6:	00001597          	auipc	a1,0x1
  ca:	f3a58593          	add	a1,a1,-198 # 1000 <argv>
  ce:	00001517          	auipc	a0,0x1
  d2:	84a50513          	add	a0,a0,-1974 # 918 <malloc+0x142>
  d6:	00000097          	auipc	ra,0x0
  da:	2f8080e7          	jalr	760(ra) # 3ce <exec>
      printf("init: exec sh failed\n");
  de:	00001517          	auipc	a0,0x1
  e2:	84250513          	add	a0,a0,-1982 # 920 <malloc+0x14a>
  e6:	00000097          	auipc	ra,0x0
  ea:	638080e7          	jalr	1592(ra) # 71e <printf>
      exit(1);
  ee:	4505                	li	a0,1
  f0:	00000097          	auipc	ra,0x0
  f4:	2a6080e7          	jalr	678(ra) # 396 <exit>

00000000000000f8 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
  f8:	1141                	add	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	add	s0,sp,16
  extern int main();
  main();
 100:	00000097          	auipc	ra,0x0
 104:	f00080e7          	jalr	-256(ra) # 0 <main>
  exit(0);
 108:	4501                	li	a0,0
 10a:	00000097          	auipc	ra,0x0
 10e:	28c080e7          	jalr	652(ra) # 396 <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	add	sp,sp,-16
 114:	e422                	sd	s0,8(sp)
 116:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 118:	87aa                	mv	a5,a0
 11a:	0585                	add	a1,a1,1
 11c:	0785                	add	a5,a5,1
 11e:	fff5c703          	lbu	a4,-1(a1)
 122:	fee78fa3          	sb	a4,-1(a5)
 126:	fb75                	bnez	a4,11a <strcpy+0x8>
    ;
  return os;
}
 128:	6422                	ld	s0,8(sp)
 12a:	0141                	add	sp,sp,16
 12c:	8082                	ret

000000000000012e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12e:	1141                	add	sp,sp,-16
 130:	e422                	sd	s0,8(sp)
 132:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x1e>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x1e>
    p++, q++;
 142:	0505                	add	a0,a0,1
 144:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	6422                	ld	s0,8(sp)
 156:	0141                	add	sp,sp,16
 158:	8082                	ret

000000000000015a <strlen>:

uint
strlen(const char *s)
{
 15a:	1141                	add	sp,sp,-16
 15c:	e422                	sd	s0,8(sp)
 15e:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 160:	00054783          	lbu	a5,0(a0)
 164:	cf91                	beqz	a5,180 <strlen+0x26>
 166:	0505                	add	a0,a0,1
 168:	87aa                	mv	a5,a0
 16a:	86be                	mv	a3,a5
 16c:	0785                	add	a5,a5,1
 16e:	fff7c703          	lbu	a4,-1(a5)
 172:	ff65                	bnez	a4,16a <strlen+0x10>
 174:	40a6853b          	subw	a0,a3,a0
 178:	2505                	addw	a0,a0,1
    ;
  return n;
}
 17a:	6422                	ld	s0,8(sp)
 17c:	0141                	add	sp,sp,16
 17e:	8082                	ret
  for(n = 0; s[n]; n++)
 180:	4501                	li	a0,0
 182:	bfe5                	j	17a <strlen+0x20>

0000000000000184 <memset>:

void*
memset(void *dst, int c, uint n)
{
 184:	1141                	add	sp,sp,-16
 186:	e422                	sd	s0,8(sp)
 188:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 18a:	ca19                	beqz	a2,1a0 <memset+0x1c>
 18c:	87aa                	mv	a5,a0
 18e:	1602                	sll	a2,a2,0x20
 190:	9201                	srl	a2,a2,0x20
 192:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 196:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 19a:	0785                	add	a5,a5,1
 19c:	fee79de3          	bne	a5,a4,196 <memset+0x12>
  }
  return dst;
}
 1a0:	6422                	ld	s0,8(sp)
 1a2:	0141                	add	sp,sp,16
 1a4:	8082                	ret

00000000000001a6 <strchr>:

char*
strchr(const char *s, char c)
{
 1a6:	1141                	add	sp,sp,-16
 1a8:	e422                	sd	s0,8(sp)
 1aa:	0800                	add	s0,sp,16
  for(; *s; s++)
 1ac:	00054783          	lbu	a5,0(a0)
 1b0:	cb99                	beqz	a5,1c6 <strchr+0x20>
    if(*s == c)
 1b2:	00f58763          	beq	a1,a5,1c0 <strchr+0x1a>
  for(; *s; s++)
 1b6:	0505                	add	a0,a0,1
 1b8:	00054783          	lbu	a5,0(a0)
 1bc:	fbfd                	bnez	a5,1b2 <strchr+0xc>
      return (char*)s;
  return 0;
 1be:	4501                	li	a0,0
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	add	sp,sp,16
 1c4:	8082                	ret
  return 0;
 1c6:	4501                	li	a0,0
 1c8:	bfe5                	j	1c0 <strchr+0x1a>

00000000000001ca <gets>:

char*
gets(char *buf, int max)
{
 1ca:	711d                	add	sp,sp,-96
 1cc:	ec86                	sd	ra,88(sp)
 1ce:	e8a2                	sd	s0,80(sp)
 1d0:	e4a6                	sd	s1,72(sp)
 1d2:	e0ca                	sd	s2,64(sp)
 1d4:	fc4e                	sd	s3,56(sp)
 1d6:	f852                	sd	s4,48(sp)
 1d8:	f456                	sd	s5,40(sp)
 1da:	f05a                	sd	s6,32(sp)
 1dc:	ec5e                	sd	s7,24(sp)
 1de:	1080                	add	s0,sp,96
 1e0:	8baa                	mv	s7,a0
 1e2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e4:	892a                	mv	s2,a0
 1e6:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 1e8:	4aa9                	li	s5,10
 1ea:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 1ec:	89a6                	mv	s3,s1
 1ee:	2485                	addw	s1,s1,1
 1f0:	0344d863          	bge	s1,s4,220 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	4605                	li	a2,1
 1f6:	faf40593          	add	a1,s0,-81
 1fa:	4501                	li	a0,0
 1fc:	00000097          	auipc	ra,0x0
 200:	1b2080e7          	jalr	434(ra) # 3ae <read>
    if(cc < 1)
 204:	00a05e63          	blez	a0,220 <gets+0x56>
    buf[i++] = c;
 208:	faf44783          	lbu	a5,-81(s0)
 20c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 210:	01578763          	beq	a5,s5,21e <gets+0x54>
 214:	0905                	add	s2,s2,1
 216:	fd679be3          	bne	a5,s6,1ec <gets+0x22>
    buf[i++] = c;
 21a:	89a6                	mv	s3,s1
 21c:	a011                	j	220 <gets+0x56>
 21e:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 220:	99de                	add	s3,s3,s7
 222:	00098023          	sb	zero,0(s3)
  return buf;
}
 226:	855e                	mv	a0,s7
 228:	60e6                	ld	ra,88(sp)
 22a:	6446                	ld	s0,80(sp)
 22c:	64a6                	ld	s1,72(sp)
 22e:	6906                	ld	s2,64(sp)
 230:	79e2                	ld	s3,56(sp)
 232:	7a42                	ld	s4,48(sp)
 234:	7aa2                	ld	s5,40(sp)
 236:	7b02                	ld	s6,32(sp)
 238:	6be2                	ld	s7,24(sp)
 23a:	6125                	add	sp,sp,96
 23c:	8082                	ret

000000000000023e <stat>:

int
stat(const char *n, struct stat *st)
{
 23e:	1101                	add	sp,sp,-32
 240:	ec06                	sd	ra,24(sp)
 242:	e822                	sd	s0,16(sp)
 244:	e04a                	sd	s2,0(sp)
 246:	1000                	add	s0,sp,32
 248:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 24a:	4581                	li	a1,0
 24c:	00000097          	auipc	ra,0x0
 250:	18a080e7          	jalr	394(ra) # 3d6 <open>
  if(fd < 0)
 254:	02054663          	bltz	a0,280 <stat+0x42>
 258:	e426                	sd	s1,8(sp)
 25a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 25c:	85ca                	mv	a1,s2
 25e:	00000097          	auipc	ra,0x0
 262:	190080e7          	jalr	400(ra) # 3ee <fstat>
 266:	892a                	mv	s2,a0
  close(fd);
 268:	8526                	mv	a0,s1
 26a:	00000097          	auipc	ra,0x0
 26e:	154080e7          	jalr	340(ra) # 3be <close>
  return r;
 272:	64a2                	ld	s1,8(sp)
}
 274:	854a                	mv	a0,s2
 276:	60e2                	ld	ra,24(sp)
 278:	6442                	ld	s0,16(sp)
 27a:	6902                	ld	s2,0(sp)
 27c:	6105                	add	sp,sp,32
 27e:	8082                	ret
    return -1;
 280:	597d                	li	s2,-1
 282:	bfcd                	j	274 <stat+0x36>

0000000000000284 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 284:	1141                	add	sp,sp,-16
 286:	e422                	sd	s0,8(sp)
 288:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 28a:	00054703          	lbu	a4,0(a0)
 28e:	02d00793          	li	a5,45
 292:	4585                	li	a1,1
 294:	04f70363          	beq	a4,a5,2da <atoi+0x56>

  while('0' <= *s && *s <= '9')
 298:	00054703          	lbu	a4,0(a0)
 29c:	fd07079b          	addw	a5,a4,-48
 2a0:	0ff7f793          	zext.b	a5,a5
 2a4:	46a5                	li	a3,9
 2a6:	02f6ed63          	bltu	a3,a5,2e0 <atoi+0x5c>
  int n = 0;
 2aa:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 2ac:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 2ae:	0505                	add	a0,a0,1
 2b0:	0026979b          	sllw	a5,a3,0x2
 2b4:	9fb5                	addw	a5,a5,a3
 2b6:	0017979b          	sllw	a5,a5,0x1
 2ba:	9fb9                	addw	a5,a5,a4
 2bc:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 2c0:	00054703          	lbu	a4,0(a0)
 2c4:	fd07079b          	addw	a5,a4,-48
 2c8:	0ff7f793          	zext.b	a5,a5
 2cc:	fef671e3          	bgeu	a2,a5,2ae <atoi+0x2a>
  return sign * n;
}
 2d0:	02d5853b          	mulw	a0,a1,a3
 2d4:	6422                	ld	s0,8(sp)
 2d6:	0141                	add	sp,sp,16
 2d8:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 2da:	0505                	add	a0,a0,1
 2dc:	55fd                	li	a1,-1
 2de:	bf6d                	j	298 <atoi+0x14>
  int n = 0;
 2e0:	4681                	li	a3,0
 2e2:	b7fd                	j	2d0 <atoi+0x4c>

00000000000002e4 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2e4:	1141                	add	sp,sp,-16
 2e6:	e422                	sd	s0,8(sp)
 2e8:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ea:	02b57463          	bgeu	a0,a1,312 <memmove+0x2e>
    while(n-- > 0)
 2ee:	00c05f63          	blez	a2,30c <memmove+0x28>
 2f2:	1602                	sll	a2,a2,0x20
 2f4:	9201                	srl	a2,a2,0x20
 2f6:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2fa:	872a                	mv	a4,a0
      *dst++ = *src++;
 2fc:	0585                	add	a1,a1,1
 2fe:	0705                	add	a4,a4,1
 300:	fff5c683          	lbu	a3,-1(a1)
 304:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 308:	fef71ae3          	bne	a4,a5,2fc <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	add	sp,sp,16
 310:	8082                	ret
    dst += n;
 312:	00c50733          	add	a4,a0,a2
    src += n;
 316:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 318:	fec05ae3          	blez	a2,30c <memmove+0x28>
 31c:	fff6079b          	addw	a5,a2,-1
 320:	1782                	sll	a5,a5,0x20
 322:	9381                	srl	a5,a5,0x20
 324:	fff7c793          	not	a5,a5
 328:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 32a:	15fd                	add	a1,a1,-1
 32c:	177d                	add	a4,a4,-1
 32e:	0005c683          	lbu	a3,0(a1)
 332:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 336:	fee79ae3          	bne	a5,a4,32a <memmove+0x46>
 33a:	bfc9                	j	30c <memmove+0x28>

000000000000033c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 33c:	1141                	add	sp,sp,-16
 33e:	e422                	sd	s0,8(sp)
 340:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 342:	ca05                	beqz	a2,372 <memcmp+0x36>
 344:	fff6069b          	addw	a3,a2,-1
 348:	1682                	sll	a3,a3,0x20
 34a:	9281                	srl	a3,a3,0x20
 34c:	0685                	add	a3,a3,1
 34e:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 350:	00054783          	lbu	a5,0(a0)
 354:	0005c703          	lbu	a4,0(a1)
 358:	00e79863          	bne	a5,a4,368 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 35c:	0505                	add	a0,a0,1
    p2++;
 35e:	0585                	add	a1,a1,1
  while (n-- > 0) {
 360:	fed518e3          	bne	a0,a3,350 <memcmp+0x14>
  }
  return 0;
 364:	4501                	li	a0,0
 366:	a019                	j	36c <memcmp+0x30>
      return *p1 - *p2;
 368:	40e7853b          	subw	a0,a5,a4
}
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	add	sp,sp,16
 370:	8082                	ret
  return 0;
 372:	4501                	li	a0,0
 374:	bfe5                	j	36c <memcmp+0x30>

0000000000000376 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 376:	1141                	add	sp,sp,-16
 378:	e406                	sd	ra,8(sp)
 37a:	e022                	sd	s0,0(sp)
 37c:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 37e:	00000097          	auipc	ra,0x0
 382:	f66080e7          	jalr	-154(ra) # 2e4 <memmove>
}
 386:	60a2                	ld	ra,8(sp)
 388:	6402                	ld	s0,0(sp)
 38a:	0141                	add	sp,sp,16
 38c:	8082                	ret

000000000000038e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 38e:	4885                	li	a7,1
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <exit>:
.global exit
exit:
 li a7, SYS_exit
 396:	4889                	li	a7,2
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <wait>:
.global wait
wait:
 li a7, SYS_wait
 39e:	488d                	li	a7,3
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3a6:	4891                	li	a7,4
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <read>:
.global read
read:
 li a7, SYS_read
 3ae:	4895                	li	a7,5
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <write>:
.global write
write:
 li a7, SYS_write
 3b6:	48c1                	li	a7,16
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <close>:
.global close
close:
 li a7, SYS_close
 3be:	48d5                	li	a7,21
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3c6:	4899                	li	a7,6
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ce:	489d                	li	a7,7
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <open>:
.global open
open:
 li a7, SYS_open
 3d6:	48bd                	li	a7,15
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3de:	48c5                	li	a7,17
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3e6:	48c9                	li	a7,18
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3ee:	48a1                	li	a7,8
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <link>:
.global link
link:
 li a7, SYS_link
 3f6:	48cd                	li	a7,19
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3fe:	48d1                	li	a7,20
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 406:	48a5                	li	a7,9
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <dup>:
.global dup
dup:
 li a7, SYS_dup
 40e:	48a9                	li	a7,10
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 416:	48ad                	li	a7,11
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 41e:	48b1                	li	a7,12
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 426:	48b5                	li	a7,13
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 42e:	48b9                	li	a7,14
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 436:	48d9                	li	a7,22
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 43e:	48dd                	li	a7,23
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 446:	48e1                	li	a7,24
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 44e:	48e5                	li	a7,25
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 456:	1101                	add	sp,sp,-32
 458:	ec06                	sd	ra,24(sp)
 45a:	e822                	sd	s0,16(sp)
 45c:	1000                	add	s0,sp,32
 45e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 462:	4605                	li	a2,1
 464:	fef40593          	add	a1,s0,-17
 468:	00000097          	auipc	ra,0x0
 46c:	f4e080e7          	jalr	-178(ra) # 3b6 <write>
}
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	6105                	add	sp,sp,32
 476:	8082                	ret

0000000000000478 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 478:	7139                	add	sp,sp,-64
 47a:	fc06                	sd	ra,56(sp)
 47c:	f822                	sd	s0,48(sp)
 47e:	f426                	sd	s1,40(sp)
 480:	0080                	add	s0,sp,64
 482:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 484:	c299                	beqz	a3,48a <printint+0x12>
 486:	0805cb63          	bltz	a1,51c <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 48a:	2581                	sext.w	a1,a1
  neg = 0;
 48c:	4881                	li	a7,0
 48e:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 492:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 494:	2601                	sext.w	a2,a2
 496:	00000517          	auipc	a0,0x0
 49a:	52250513          	add	a0,a0,1314 # 9b8 <digits>
 49e:	883a                	mv	a6,a4
 4a0:	2705                	addw	a4,a4,1
 4a2:	02c5f7bb          	remuw	a5,a1,a2
 4a6:	1782                	sll	a5,a5,0x20
 4a8:	9381                	srl	a5,a5,0x20
 4aa:	97aa                	add	a5,a5,a0
 4ac:	0007c783          	lbu	a5,0(a5)
 4b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b4:	0005879b          	sext.w	a5,a1
 4b8:	02c5d5bb          	divuw	a1,a1,a2
 4bc:	0685                	add	a3,a3,1
 4be:	fec7f0e3          	bgeu	a5,a2,49e <printint+0x26>
  if(neg)
 4c2:	00088c63          	beqz	a7,4da <printint+0x62>
    buf[i++] = '-';
 4c6:	fd070793          	add	a5,a4,-48
 4ca:	00878733          	add	a4,a5,s0
 4ce:	02d00793          	li	a5,45
 4d2:	fef70823          	sb	a5,-16(a4)
 4d6:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 4da:	02e05c63          	blez	a4,512 <printint+0x9a>
 4de:	f04a                	sd	s2,32(sp)
 4e0:	ec4e                	sd	s3,24(sp)
 4e2:	fc040793          	add	a5,s0,-64
 4e6:	00e78933          	add	s2,a5,a4
 4ea:	fff78993          	add	s3,a5,-1
 4ee:	99ba                	add	s3,s3,a4
 4f0:	377d                	addw	a4,a4,-1
 4f2:	1702                	sll	a4,a4,0x20
 4f4:	9301                	srl	a4,a4,0x20
 4f6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4fa:	fff94583          	lbu	a1,-1(s2)
 4fe:	8526                	mv	a0,s1
 500:	00000097          	auipc	ra,0x0
 504:	f56080e7          	jalr	-170(ra) # 456 <putc>
  while(--i >= 0)
 508:	197d                	add	s2,s2,-1
 50a:	ff3918e3          	bne	s2,s3,4fa <printint+0x82>
 50e:	7902                	ld	s2,32(sp)
 510:	69e2                	ld	s3,24(sp)
}
 512:	70e2                	ld	ra,56(sp)
 514:	7442                	ld	s0,48(sp)
 516:	74a2                	ld	s1,40(sp)
 518:	6121                	add	sp,sp,64
 51a:	8082                	ret
    x = -xx;
 51c:	40b005bb          	negw	a1,a1
    neg = 1;
 520:	4885                	li	a7,1
    x = -xx;
 522:	b7b5                	j	48e <printint+0x16>

0000000000000524 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 524:	715d                	add	sp,sp,-80
 526:	e486                	sd	ra,72(sp)
 528:	e0a2                	sd	s0,64(sp)
 52a:	f84a                	sd	s2,48(sp)
 52c:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 52e:	0005c903          	lbu	s2,0(a1)
 532:	1a090a63          	beqz	s2,6e6 <vprintf+0x1c2>
 536:	fc26                	sd	s1,56(sp)
 538:	f44e                	sd	s3,40(sp)
 53a:	f052                	sd	s4,32(sp)
 53c:	ec56                	sd	s5,24(sp)
 53e:	e85a                	sd	s6,16(sp)
 540:	e45e                	sd	s7,8(sp)
 542:	8aaa                	mv	s5,a0
 544:	8bb2                	mv	s7,a2
 546:	00158493          	add	s1,a1,1
  state = 0;
 54a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 54c:	02500a13          	li	s4,37
 550:	4b55                	li	s6,21
 552:	a839                	j	570 <vprintf+0x4c>
        putc(fd, c);
 554:	85ca                	mv	a1,s2
 556:	8556                	mv	a0,s5
 558:	00000097          	auipc	ra,0x0
 55c:	efe080e7          	jalr	-258(ra) # 456 <putc>
 560:	a019                	j	566 <vprintf+0x42>
    } else if(state == '%'){
 562:	01498d63          	beq	s3,s4,57c <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 566:	0485                	add	s1,s1,1
 568:	fff4c903          	lbu	s2,-1(s1)
 56c:	16090763          	beqz	s2,6da <vprintf+0x1b6>
    if(state == 0){
 570:	fe0999e3          	bnez	s3,562 <vprintf+0x3e>
      if(c == '%'){
 574:	ff4910e3          	bne	s2,s4,554 <vprintf+0x30>
        state = '%';
 578:	89d2                	mv	s3,s4
 57a:	b7f5                	j	566 <vprintf+0x42>
      if(c == 'd'){
 57c:	13490463          	beq	s2,s4,6a4 <vprintf+0x180>
 580:	f9d9079b          	addw	a5,s2,-99
 584:	0ff7f793          	zext.b	a5,a5
 588:	12fb6763          	bltu	s6,a5,6b6 <vprintf+0x192>
 58c:	f9d9079b          	addw	a5,s2,-99
 590:	0ff7f713          	zext.b	a4,a5
 594:	12eb6163          	bltu	s6,a4,6b6 <vprintf+0x192>
 598:	00271793          	sll	a5,a4,0x2
 59c:	00000717          	auipc	a4,0x0
 5a0:	3c470713          	add	a4,a4,964 # 960 <malloc+0x18a>
 5a4:	97ba                	add	a5,a5,a4
 5a6:	439c                	lw	a5,0(a5)
 5a8:	97ba                	add	a5,a5,a4
 5aa:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 5ac:	008b8913          	add	s2,s7,8
 5b0:	4685                	li	a3,1
 5b2:	4629                	li	a2,10
 5b4:	000ba583          	lw	a1,0(s7)
 5b8:	8556                	mv	a0,s5
 5ba:	00000097          	auipc	ra,0x0
 5be:	ebe080e7          	jalr	-322(ra) # 478 <printint>
 5c2:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b745                	j	566 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	008b8913          	add	s2,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	ea2080e7          	jalr	-350(ra) # 478 <printint>
 5de:	8bca                	mv	s7,s2
      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b751                	j	566 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 5e4:	008b8913          	add	s2,s7,8
 5e8:	4681                	li	a3,0
 5ea:	4641                	li	a2,16
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	8556                	mv	a0,s5
 5f2:	00000097          	auipc	ra,0x0
 5f6:	e86080e7          	jalr	-378(ra) # 478 <printint>
 5fa:	8bca                	mv	s7,s2
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b7a5                	j	566 <vprintf+0x42>
 600:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 602:	008b8c13          	add	s8,s7,8
 606:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60a:	03000593          	li	a1,48
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	e46080e7          	jalr	-442(ra) # 456 <putc>
  putc(fd, 'x');
 618:	07800593          	li	a1,120
 61c:	8556                	mv	a0,s5
 61e:	00000097          	auipc	ra,0x0
 622:	e38080e7          	jalr	-456(ra) # 456 <putc>
 626:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 628:	00000b97          	auipc	s7,0x0
 62c:	390b8b93          	add	s7,s7,912 # 9b8 <digits>
 630:	03c9d793          	srl	a5,s3,0x3c
 634:	97de                	add	a5,a5,s7
 636:	0007c583          	lbu	a1,0(a5)
 63a:	8556                	mv	a0,s5
 63c:	00000097          	auipc	ra,0x0
 640:	e1a080e7          	jalr	-486(ra) # 456 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 644:	0992                	sll	s3,s3,0x4
 646:	397d                	addw	s2,s2,-1
 648:	fe0914e3          	bnez	s2,630 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 64c:	8be2                	mv	s7,s8
      state = 0;
 64e:	4981                	li	s3,0
 650:	6c02                	ld	s8,0(sp)
 652:	bf11                	j	566 <vprintf+0x42>
        s = va_arg(ap, char*);
 654:	008b8993          	add	s3,s7,8
 658:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 65c:	02090163          	beqz	s2,67e <vprintf+0x15a>
        while(*s != 0){
 660:	00094583          	lbu	a1,0(s2)
 664:	c9a5                	beqz	a1,6d4 <vprintf+0x1b0>
          putc(fd, *s);
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	dee080e7          	jalr	-530(ra) # 456 <putc>
          s++;
 670:	0905                	add	s2,s2,1
        while(*s != 0){
 672:	00094583          	lbu	a1,0(s2)
 676:	f9e5                	bnez	a1,666 <vprintf+0x142>
        s = va_arg(ap, char*);
 678:	8bce                	mv	s7,s3
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b5ed                	j	566 <vprintf+0x42>
          s = "(null)";
 67e:	00000917          	auipc	s2,0x0
 682:	2da90913          	add	s2,s2,730 # 958 <malloc+0x182>
        while(*s != 0){
 686:	02800593          	li	a1,40
 68a:	bff1                	j	666 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 68c:	008b8913          	add	s2,s7,8
 690:	000bc583          	lbu	a1,0(s7)
 694:	8556                	mv	a0,s5
 696:	00000097          	auipc	ra,0x0
 69a:	dc0080e7          	jalr	-576(ra) # 456 <putc>
 69e:	8bca                	mv	s7,s2
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	b5d1                	j	566 <vprintf+0x42>
        putc(fd, c);
 6a4:	02500593          	li	a1,37
 6a8:	8556                	mv	a0,s5
 6aa:	00000097          	auipc	ra,0x0
 6ae:	dac080e7          	jalr	-596(ra) # 456 <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	bd4d                	j	566 <vprintf+0x42>
        putc(fd, '%');
 6b6:	02500593          	li	a1,37
 6ba:	8556                	mv	a0,s5
 6bc:	00000097          	auipc	ra,0x0
 6c0:	d9a080e7          	jalr	-614(ra) # 456 <putc>
        putc(fd, c);
 6c4:	85ca                	mv	a1,s2
 6c6:	8556                	mv	a0,s5
 6c8:	00000097          	auipc	ra,0x0
 6cc:	d8e080e7          	jalr	-626(ra) # 456 <putc>
      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	bd51                	j	566 <vprintf+0x42>
        s = va_arg(ap, char*);
 6d4:	8bce                	mv	s7,s3
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	b579                	j	566 <vprintf+0x42>
 6da:	74e2                	ld	s1,56(sp)
 6dc:	79a2                	ld	s3,40(sp)
 6de:	7a02                	ld	s4,32(sp)
 6e0:	6ae2                	ld	s5,24(sp)
 6e2:	6b42                	ld	s6,16(sp)
 6e4:	6ba2                	ld	s7,8(sp)
    }
  }
}
 6e6:	60a6                	ld	ra,72(sp)
 6e8:	6406                	ld	s0,64(sp)
 6ea:	7942                	ld	s2,48(sp)
 6ec:	6161                	add	sp,sp,80
 6ee:	8082                	ret

00000000000006f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f0:	715d                	add	sp,sp,-80
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	add	s0,sp,32
 6f8:	e010                	sd	a2,0(s0)
 6fa:	e414                	sd	a3,8(s0)
 6fc:	e818                	sd	a4,16(s0)
 6fe:	ec1c                	sd	a5,24(s0)
 700:	03043023          	sd	a6,32(s0)
 704:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70c:	8622                	mv	a2,s0
 70e:	00000097          	auipc	ra,0x0
 712:	e16080e7          	jalr	-490(ra) # 524 <vprintf>
}
 716:	60e2                	ld	ra,24(sp)
 718:	6442                	ld	s0,16(sp)
 71a:	6161                	add	sp,sp,80
 71c:	8082                	ret

000000000000071e <printf>:

void
printf(const char *fmt, ...)
{
 71e:	711d                	add	sp,sp,-96
 720:	ec06                	sd	ra,24(sp)
 722:	e822                	sd	s0,16(sp)
 724:	1000                	add	s0,sp,32
 726:	e40c                	sd	a1,8(s0)
 728:	e810                	sd	a2,16(s0)
 72a:	ec14                	sd	a3,24(s0)
 72c:	f018                	sd	a4,32(s0)
 72e:	f41c                	sd	a5,40(s0)
 730:	03043823          	sd	a6,48(s0)
 734:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 738:	00840613          	add	a2,s0,8
 73c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 740:	85aa                	mv	a1,a0
 742:	4505                	li	a0,1
 744:	00000097          	auipc	ra,0x0
 748:	de0080e7          	jalr	-544(ra) # 524 <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6125                	add	sp,sp,96
 752:	8082                	ret

0000000000000754 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 754:	1141                	add	sp,sp,-16
 756:	e422                	sd	s0,8(sp)
 758:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 75a:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 75e:	00001797          	auipc	a5,0x1
 762:	8b27b783          	ld	a5,-1870(a5) # 1010 <freep>
 766:	a02d                	j	790 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 768:	4618                	lw	a4,8(a2)
 76a:	9f2d                	addw	a4,a4,a1
 76c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 770:	6398                	ld	a4,0(a5)
 772:	6310                	ld	a2,0(a4)
 774:	a83d                	j	7b2 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 776:	ff852703          	lw	a4,-8(a0)
 77a:	9f31                	addw	a4,a4,a2
 77c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 77e:	ff053683          	ld	a3,-16(a0)
 782:	a091                	j	7c6 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	6398                	ld	a4,0(a5)
 786:	00e7e463          	bltu	a5,a4,78e <free+0x3a>
 78a:	00e6ea63          	bltu	a3,a4,79e <free+0x4a>
{
 78e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	fed7fae3          	bgeu	a5,a3,784 <free+0x30>
 794:	6398                	ld	a4,0(a5)
 796:	00e6e463          	bltu	a3,a4,79e <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	fee7eae3          	bltu	a5,a4,78e <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 79e:	ff852583          	lw	a1,-8(a0)
 7a2:	6390                	ld	a2,0(a5)
 7a4:	02059813          	sll	a6,a1,0x20
 7a8:	01c85713          	srl	a4,a6,0x1c
 7ac:	9736                	add	a4,a4,a3
 7ae:	fae60de3          	beq	a2,a4,768 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 7b6:	4790                	lw	a2,8(a5)
 7b8:	02061593          	sll	a1,a2,0x20
 7bc:	01c5d713          	srl	a4,a1,0x1c
 7c0:	973e                	add	a4,a4,a5
 7c2:	fae68ae3          	beq	a3,a4,776 <free+0x22>
    p->s.ptr = bp->s.ptr;
 7c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c8:	00001717          	auipc	a4,0x1
 7cc:	84f73423          	sd	a5,-1976(a4) # 1010 <freep>
}
 7d0:	6422                	ld	s0,8(sp)
 7d2:	0141                	add	sp,sp,16
 7d4:	8082                	ret

00000000000007d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d6:	7139                	add	sp,sp,-64
 7d8:	fc06                	sd	ra,56(sp)
 7da:	f822                	sd	s0,48(sp)
 7dc:	f426                	sd	s1,40(sp)
 7de:	ec4e                	sd	s3,24(sp)
 7e0:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7e2:	02051493          	sll	s1,a0,0x20
 7e6:	9081                	srl	s1,s1,0x20
 7e8:	04bd                	add	s1,s1,15
 7ea:	8091                	srl	s1,s1,0x4
 7ec:	0014899b          	addw	s3,s1,1
 7f0:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 7f2:	00001517          	auipc	a0,0x1
 7f6:	81e53503          	ld	a0,-2018(a0) # 1010 <freep>
 7fa:	c915                	beqz	a0,82e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fe:	4798                	lw	a4,8(a5)
 800:	08977e63          	bgeu	a4,s1,89c <malloc+0xc6>
 804:	f04a                	sd	s2,32(sp)
 806:	e852                	sd	s4,16(sp)
 808:	e456                	sd	s5,8(sp)
 80a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 80c:	8a4e                	mv	s4,s3
 80e:	0009871b          	sext.w	a4,s3
 812:	6685                	lui	a3,0x1
 814:	00d77363          	bgeu	a4,a3,81a <malloc+0x44>
 818:	6a05                	lui	s4,0x1
 81a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 81e:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 822:	00000917          	auipc	s2,0x0
 826:	7ee90913          	add	s2,s2,2030 # 1010 <freep>
  if(p == (char*)-1)
 82a:	5afd                	li	s5,-1
 82c:	a091                	j	870 <malloc+0x9a>
 82e:	f04a                	sd	s2,32(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 836:	00000797          	auipc	a5,0x0
 83a:	7ea78793          	add	a5,a5,2026 # 1020 <base>
 83e:	00000717          	auipc	a4,0x0
 842:	7cf73923          	sd	a5,2002(a4) # 1010 <freep>
 846:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 848:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 84c:	b7c1                	j	80c <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 84e:	6398                	ld	a4,0(a5)
 850:	e118                	sd	a4,0(a0)
 852:	a08d                	j	8b4 <malloc+0xde>
  hp->s.size = nu;
 854:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 858:	0541                	add	a0,a0,16
 85a:	00000097          	auipc	ra,0x0
 85e:	efa080e7          	jalr	-262(ra) # 754 <free>
  return freep;
 862:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 866:	c13d                	beqz	a0,8cc <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 868:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86a:	4798                	lw	a4,8(a5)
 86c:	02977463          	bgeu	a4,s1,894 <malloc+0xbe>
    if(p == freep)
 870:	00093703          	ld	a4,0(s2)
 874:	853e                	mv	a0,a5
 876:	fef719e3          	bne	a4,a5,868 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 87a:	8552                	mv	a0,s4
 87c:	00000097          	auipc	ra,0x0
 880:	ba2080e7          	jalr	-1118(ra) # 41e <sbrk>
  if(p == (char*)-1)
 884:	fd5518e3          	bne	a0,s5,854 <malloc+0x7e>
        return 0;
 888:	4501                	li	a0,0
 88a:	7902                	ld	s2,32(sp)
 88c:	6a42                	ld	s4,16(sp)
 88e:	6aa2                	ld	s5,8(sp)
 890:	6b02                	ld	s6,0(sp)
 892:	a03d                	j	8c0 <malloc+0xea>
 894:	7902                	ld	s2,32(sp)
 896:	6a42                	ld	s4,16(sp)
 898:	6aa2                	ld	s5,8(sp)
 89a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 89c:	fae489e3          	beq	s1,a4,84e <malloc+0x78>
        p->s.size -= nunits;
 8a0:	4137073b          	subw	a4,a4,s3
 8a4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8a6:	02071693          	sll	a3,a4,0x20
 8aa:	01c6d713          	srl	a4,a3,0x1c
 8ae:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8b0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8b4:	00000717          	auipc	a4,0x0
 8b8:	74a73e23          	sd	a0,1884(a4) # 1010 <freep>
      return (void*)(p + 1);
 8bc:	01078513          	add	a0,a5,16
  }
}
 8c0:	70e2                	ld	ra,56(sp)
 8c2:	7442                	ld	s0,48(sp)
 8c4:	74a2                	ld	s1,40(sp)
 8c6:	69e2                	ld	s3,24(sp)
 8c8:	6121                	add	sp,sp,64
 8ca:	8082                	ret
 8cc:	7902                	ld	s2,32(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
 8d4:	b7f5                	j	8c0 <malloc+0xea>
