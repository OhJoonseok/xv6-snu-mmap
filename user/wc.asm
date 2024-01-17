
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	add	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	add	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4d01                	li	s10,0
  2a:	4c81                	li	s9,0
  2c:	4c01                	li	s8,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	00001d97          	auipc	s11,0x1
  32:	fe2d8d93          	add	s11,s11,-30 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  36:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  38:	00001a17          	auipc	s4,0x1
  3c:	938a0a13          	add	s4,s4,-1736 # 970 <malloc+0x102>
        inword = 0;
  40:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  42:	a805                	j	72 <wc+0x72>
      if(strchr(" \r\t\n\v", buf[i]))
  44:	8552                	mv	a0,s4
  46:	00000097          	auipc	ra,0x0
  4a:	1f8080e7          	jalr	504(ra) # 23e <strchr>
  4e:	c919                	beqz	a0,64 <wc+0x64>
        inword = 0;
  50:	895e                	mv	s2,s7
    for(i=0; i<n; i++){
  52:	0485                	add	s1,s1,1
  54:	01348d63          	beq	s1,s3,6e <wc+0x6e>
      if(buf[i] == '\n')
  58:	0004c583          	lbu	a1,0(s1)
  5c:	ff5594e3          	bne	a1,s5,44 <wc+0x44>
        l++;
  60:	2c05                	addw	s8,s8,1
  62:	b7cd                	j	44 <wc+0x44>
      else if(!inword){
  64:	fe0917e3          	bnez	s2,52 <wc+0x52>
        w++;
  68:	2c85                	addw	s9,s9,1
        inword = 1;
  6a:	4905                	li	s2,1
  6c:	b7dd                	j	52 <wc+0x52>
  6e:	01ab0d3b          	addw	s10,s6,s10
  while((n = read(fd, buf, sizeof(buf))) > 0){
  72:	20000613          	li	a2,512
  76:	85ee                	mv	a1,s11
  78:	f8843503          	ld	a0,-120(s0)
  7c:	00000097          	auipc	ra,0x0
  80:	3ca080e7          	jalr	970(ra) # 446 <read>
  84:	8b2a                	mv	s6,a0
  86:	00a05963          	blez	a0,98 <wc+0x98>
    for(i=0; i<n; i++){
  8a:	00001497          	auipc	s1,0x1
  8e:	f8648493          	add	s1,s1,-122 # 1010 <buf>
  92:	009509b3          	add	s3,a0,s1
  96:	b7c9                	j	58 <wc+0x58>
      }
    }
  }
  if(n < 0){
  98:	02054e63          	bltz	a0,d4 <wc+0xd4>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  9c:	f8043703          	ld	a4,-128(s0)
  a0:	86ea                	mv	a3,s10
  a2:	8666                	mv	a2,s9
  a4:	85e2                	mv	a1,s8
  a6:	00001517          	auipc	a0,0x1
  aa:	8ea50513          	add	a0,a0,-1814 # 990 <malloc+0x122>
  ae:	00000097          	auipc	ra,0x0
  b2:	708080e7          	jalr	1800(ra) # 7b6 <printf>
}
  b6:	70e6                	ld	ra,120(sp)
  b8:	7446                	ld	s0,112(sp)
  ba:	74a6                	ld	s1,104(sp)
  bc:	7906                	ld	s2,96(sp)
  be:	69e6                	ld	s3,88(sp)
  c0:	6a46                	ld	s4,80(sp)
  c2:	6aa6                	ld	s5,72(sp)
  c4:	6b06                	ld	s6,64(sp)
  c6:	7be2                	ld	s7,56(sp)
  c8:	7c42                	ld	s8,48(sp)
  ca:	7ca2                	ld	s9,40(sp)
  cc:	7d02                	ld	s10,32(sp)
  ce:	6de2                	ld	s11,24(sp)
  d0:	6109                	add	sp,sp,128
  d2:	8082                	ret
    printf("wc: read error\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	8ac50513          	add	a0,a0,-1876 # 980 <malloc+0x112>
  dc:	00000097          	auipc	ra,0x0
  e0:	6da080e7          	jalr	1754(ra) # 7b6 <printf>
    exit(1);
  e4:	4505                	li	a0,1
  e6:	00000097          	auipc	ra,0x0
  ea:	348080e7          	jalr	840(ra) # 42e <exit>

00000000000000ee <main>:

int
main(int argc, char *argv[])
{
  ee:	7179                	add	sp,sp,-48
  f0:	f406                	sd	ra,40(sp)
  f2:	f022                	sd	s0,32(sp)
  f4:	1800                	add	s0,sp,48
  int fd, i;

  if(argc <= 1){
  f6:	4785                	li	a5,1
  f8:	04a7dc63          	bge	a5,a0,150 <main+0x62>
  fc:	ec26                	sd	s1,24(sp)
  fe:	e84a                	sd	s2,16(sp)
 100:	e44e                	sd	s3,8(sp)
 102:	00858913          	add	s2,a1,8
 106:	ffe5099b          	addw	s3,a0,-2
 10a:	02099793          	sll	a5,s3,0x20
 10e:	01d7d993          	srl	s3,a5,0x1d
 112:	05c1                	add	a1,a1,16
 114:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], 0)) < 0){
 116:	4581                	li	a1,0
 118:	00093503          	ld	a0,0(s2)
 11c:	00000097          	auipc	ra,0x0
 120:	352080e7          	jalr	850(ra) # 46e <open>
 124:	84aa                	mv	s1,a0
 126:	04054663          	bltz	a0,172 <main+0x84>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 12a:	00093583          	ld	a1,0(s2)
 12e:	00000097          	auipc	ra,0x0
 132:	ed2080e7          	jalr	-302(ra) # 0 <wc>
    close(fd);
 136:	8526                	mv	a0,s1
 138:	00000097          	auipc	ra,0x0
 13c:	31e080e7          	jalr	798(ra) # 456 <close>
  for(i = 1; i < argc; i++){
 140:	0921                	add	s2,s2,8
 142:	fd391ae3          	bne	s2,s3,116 <main+0x28>
  }
  exit(0);
 146:	4501                	li	a0,0
 148:	00000097          	auipc	ra,0x0
 14c:	2e6080e7          	jalr	742(ra) # 42e <exit>
 150:	ec26                	sd	s1,24(sp)
 152:	e84a                	sd	s2,16(sp)
 154:	e44e                	sd	s3,8(sp)
    wc(0, "");
 156:	00001597          	auipc	a1,0x1
 15a:	82258593          	add	a1,a1,-2014 # 978 <malloc+0x10a>
 15e:	4501                	li	a0,0
 160:	00000097          	auipc	ra,0x0
 164:	ea0080e7          	jalr	-352(ra) # 0 <wc>
    exit(0);
 168:	4501                	li	a0,0
 16a:	00000097          	auipc	ra,0x0
 16e:	2c4080e7          	jalr	708(ra) # 42e <exit>
      printf("wc: cannot open %s\n", argv[i]);
 172:	00093583          	ld	a1,0(s2)
 176:	00001517          	auipc	a0,0x1
 17a:	82a50513          	add	a0,a0,-2006 # 9a0 <malloc+0x132>
 17e:	00000097          	auipc	ra,0x0
 182:	638080e7          	jalr	1592(ra) # 7b6 <printf>
      exit(1);
 186:	4505                	li	a0,1
 188:	00000097          	auipc	ra,0x0
 18c:	2a6080e7          	jalr	678(ra) # 42e <exit>

0000000000000190 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 190:	1141                	add	sp,sp,-16
 192:	e406                	sd	ra,8(sp)
 194:	e022                	sd	s0,0(sp)
 196:	0800                	add	s0,sp,16
  extern int main();
  main();
 198:	00000097          	auipc	ra,0x0
 19c:	f56080e7          	jalr	-170(ra) # ee <main>
  exit(0);
 1a0:	4501                	li	a0,0
 1a2:	00000097          	auipc	ra,0x0
 1a6:	28c080e7          	jalr	652(ra) # 42e <exit>

00000000000001aa <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1aa:	1141                	add	sp,sp,-16
 1ac:	e422                	sd	s0,8(sp)
 1ae:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1b0:	87aa                	mv	a5,a0
 1b2:	0585                	add	a1,a1,1
 1b4:	0785                	add	a5,a5,1
 1b6:	fff5c703          	lbu	a4,-1(a1)
 1ba:	fee78fa3          	sb	a4,-1(a5)
 1be:	fb75                	bnez	a4,1b2 <strcpy+0x8>
    ;
  return os;
}
 1c0:	6422                	ld	s0,8(sp)
 1c2:	0141                	add	sp,sp,16
 1c4:	8082                	ret

00000000000001c6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1c6:	1141                	add	sp,sp,-16
 1c8:	e422                	sd	s0,8(sp)
 1ca:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 1cc:	00054783          	lbu	a5,0(a0)
 1d0:	cb91                	beqz	a5,1e4 <strcmp+0x1e>
 1d2:	0005c703          	lbu	a4,0(a1)
 1d6:	00f71763          	bne	a4,a5,1e4 <strcmp+0x1e>
    p++, q++;
 1da:	0505                	add	a0,a0,1
 1dc:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 1de:	00054783          	lbu	a5,0(a0)
 1e2:	fbe5                	bnez	a5,1d2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1e4:	0005c503          	lbu	a0,0(a1)
}
 1e8:	40a7853b          	subw	a0,a5,a0
 1ec:	6422                	ld	s0,8(sp)
 1ee:	0141                	add	sp,sp,16
 1f0:	8082                	ret

00000000000001f2 <strlen>:

uint
strlen(const char *s)
{
 1f2:	1141                	add	sp,sp,-16
 1f4:	e422                	sd	s0,8(sp)
 1f6:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1f8:	00054783          	lbu	a5,0(a0)
 1fc:	cf91                	beqz	a5,218 <strlen+0x26>
 1fe:	0505                	add	a0,a0,1
 200:	87aa                	mv	a5,a0
 202:	86be                	mv	a3,a5
 204:	0785                	add	a5,a5,1
 206:	fff7c703          	lbu	a4,-1(a5)
 20a:	ff65                	bnez	a4,202 <strlen+0x10>
 20c:	40a6853b          	subw	a0,a3,a0
 210:	2505                	addw	a0,a0,1
    ;
  return n;
}
 212:	6422                	ld	s0,8(sp)
 214:	0141                	add	sp,sp,16
 216:	8082                	ret
  for(n = 0; s[n]; n++)
 218:	4501                	li	a0,0
 21a:	bfe5                	j	212 <strlen+0x20>

000000000000021c <memset>:

void*
memset(void *dst, int c, uint n)
{
 21c:	1141                	add	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 222:	ca19                	beqz	a2,238 <memset+0x1c>
 224:	87aa                	mv	a5,a0
 226:	1602                	sll	a2,a2,0x20
 228:	9201                	srl	a2,a2,0x20
 22a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 22e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 232:	0785                	add	a5,a5,1
 234:	fee79de3          	bne	a5,a4,22e <memset+0x12>
  }
  return dst;
}
 238:	6422                	ld	s0,8(sp)
 23a:	0141                	add	sp,sp,16
 23c:	8082                	ret

000000000000023e <strchr>:

char*
strchr(const char *s, char c)
{
 23e:	1141                	add	sp,sp,-16
 240:	e422                	sd	s0,8(sp)
 242:	0800                	add	s0,sp,16
  for(; *s; s++)
 244:	00054783          	lbu	a5,0(a0)
 248:	cb99                	beqz	a5,25e <strchr+0x20>
    if(*s == c)
 24a:	00f58763          	beq	a1,a5,258 <strchr+0x1a>
  for(; *s; s++)
 24e:	0505                	add	a0,a0,1
 250:	00054783          	lbu	a5,0(a0)
 254:	fbfd                	bnez	a5,24a <strchr+0xc>
      return (char*)s;
  return 0;
 256:	4501                	li	a0,0
}
 258:	6422                	ld	s0,8(sp)
 25a:	0141                	add	sp,sp,16
 25c:	8082                	ret
  return 0;
 25e:	4501                	li	a0,0
 260:	bfe5                	j	258 <strchr+0x1a>

0000000000000262 <gets>:

char*
gets(char *buf, int max)
{
 262:	711d                	add	sp,sp,-96
 264:	ec86                	sd	ra,88(sp)
 266:	e8a2                	sd	s0,80(sp)
 268:	e4a6                	sd	s1,72(sp)
 26a:	e0ca                	sd	s2,64(sp)
 26c:	fc4e                	sd	s3,56(sp)
 26e:	f852                	sd	s4,48(sp)
 270:	f456                	sd	s5,40(sp)
 272:	f05a                	sd	s6,32(sp)
 274:	ec5e                	sd	s7,24(sp)
 276:	1080                	add	s0,sp,96
 278:	8baa                	mv	s7,a0
 27a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 27c:	892a                	mv	s2,a0
 27e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 280:	4aa9                	li	s5,10
 282:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 284:	89a6                	mv	s3,s1
 286:	2485                	addw	s1,s1,1
 288:	0344d863          	bge	s1,s4,2b8 <gets+0x56>
    cc = read(0, &c, 1);
 28c:	4605                	li	a2,1
 28e:	faf40593          	add	a1,s0,-81
 292:	4501                	li	a0,0
 294:	00000097          	auipc	ra,0x0
 298:	1b2080e7          	jalr	434(ra) # 446 <read>
    if(cc < 1)
 29c:	00a05e63          	blez	a0,2b8 <gets+0x56>
    buf[i++] = c;
 2a0:	faf44783          	lbu	a5,-81(s0)
 2a4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2a8:	01578763          	beq	a5,s5,2b6 <gets+0x54>
 2ac:	0905                	add	s2,s2,1
 2ae:	fd679be3          	bne	a5,s6,284 <gets+0x22>
    buf[i++] = c;
 2b2:	89a6                	mv	s3,s1
 2b4:	a011                	j	2b8 <gets+0x56>
 2b6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2b8:	99de                	add	s3,s3,s7
 2ba:	00098023          	sb	zero,0(s3)
  return buf;
}
 2be:	855e                	mv	a0,s7
 2c0:	60e6                	ld	ra,88(sp)
 2c2:	6446                	ld	s0,80(sp)
 2c4:	64a6                	ld	s1,72(sp)
 2c6:	6906                	ld	s2,64(sp)
 2c8:	79e2                	ld	s3,56(sp)
 2ca:	7a42                	ld	s4,48(sp)
 2cc:	7aa2                	ld	s5,40(sp)
 2ce:	7b02                	ld	s6,32(sp)
 2d0:	6be2                	ld	s7,24(sp)
 2d2:	6125                	add	sp,sp,96
 2d4:	8082                	ret

00000000000002d6 <stat>:

int
stat(const char *n, struct stat *st)
{
 2d6:	1101                	add	sp,sp,-32
 2d8:	ec06                	sd	ra,24(sp)
 2da:	e822                	sd	s0,16(sp)
 2dc:	e04a                	sd	s2,0(sp)
 2de:	1000                	add	s0,sp,32
 2e0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2e2:	4581                	li	a1,0
 2e4:	00000097          	auipc	ra,0x0
 2e8:	18a080e7          	jalr	394(ra) # 46e <open>
  if(fd < 0)
 2ec:	02054663          	bltz	a0,318 <stat+0x42>
 2f0:	e426                	sd	s1,8(sp)
 2f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2f4:	85ca                	mv	a1,s2
 2f6:	00000097          	auipc	ra,0x0
 2fa:	190080e7          	jalr	400(ra) # 486 <fstat>
 2fe:	892a                	mv	s2,a0
  close(fd);
 300:	8526                	mv	a0,s1
 302:	00000097          	auipc	ra,0x0
 306:	154080e7          	jalr	340(ra) # 456 <close>
  return r;
 30a:	64a2                	ld	s1,8(sp)
}
 30c:	854a                	mv	a0,s2
 30e:	60e2                	ld	ra,24(sp)
 310:	6442                	ld	s0,16(sp)
 312:	6902                	ld	s2,0(sp)
 314:	6105                	add	sp,sp,32
 316:	8082                	ret
    return -1;
 318:	597d                	li	s2,-1
 31a:	bfcd                	j	30c <stat+0x36>

000000000000031c <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 31c:	1141                	add	sp,sp,-16
 31e:	e422                	sd	s0,8(sp)
 320:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 322:	00054703          	lbu	a4,0(a0)
 326:	02d00793          	li	a5,45
 32a:	4585                	li	a1,1
 32c:	04f70363          	beq	a4,a5,372 <atoi+0x56>

  while('0' <= *s && *s <= '9')
 330:	00054703          	lbu	a4,0(a0)
 334:	fd07079b          	addw	a5,a4,-48
 338:	0ff7f793          	zext.b	a5,a5
 33c:	46a5                	li	a3,9
 33e:	02f6ed63          	bltu	a3,a5,378 <atoi+0x5c>
  int n = 0;
 342:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 344:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 346:	0505                	add	a0,a0,1
 348:	0026979b          	sllw	a5,a3,0x2
 34c:	9fb5                	addw	a5,a5,a3
 34e:	0017979b          	sllw	a5,a5,0x1
 352:	9fb9                	addw	a5,a5,a4
 354:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 358:	00054703          	lbu	a4,0(a0)
 35c:	fd07079b          	addw	a5,a4,-48
 360:	0ff7f793          	zext.b	a5,a5
 364:	fef671e3          	bgeu	a2,a5,346 <atoi+0x2a>
  return sign * n;
}
 368:	02d5853b          	mulw	a0,a1,a3
 36c:	6422                	ld	s0,8(sp)
 36e:	0141                	add	sp,sp,16
 370:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 372:	0505                	add	a0,a0,1
 374:	55fd                	li	a1,-1
 376:	bf6d                	j	330 <atoi+0x14>
  int n = 0;
 378:	4681                	li	a3,0
 37a:	b7fd                	j	368 <atoi+0x4c>

000000000000037c <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 37c:	1141                	add	sp,sp,-16
 37e:	e422                	sd	s0,8(sp)
 380:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 382:	02b57463          	bgeu	a0,a1,3aa <memmove+0x2e>
    while(n-- > 0)
 386:	00c05f63          	blez	a2,3a4 <memmove+0x28>
 38a:	1602                	sll	a2,a2,0x20
 38c:	9201                	srl	a2,a2,0x20
 38e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 392:	872a                	mv	a4,a0
      *dst++ = *src++;
 394:	0585                	add	a1,a1,1
 396:	0705                	add	a4,a4,1
 398:	fff5c683          	lbu	a3,-1(a1)
 39c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3a0:	fef71ae3          	bne	a4,a5,394 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	add	sp,sp,16
 3a8:	8082                	ret
    dst += n;
 3aa:	00c50733          	add	a4,a0,a2
    src += n;
 3ae:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3b0:	fec05ae3          	blez	a2,3a4 <memmove+0x28>
 3b4:	fff6079b          	addw	a5,a2,-1
 3b8:	1782                	sll	a5,a5,0x20
 3ba:	9381                	srl	a5,a5,0x20
 3bc:	fff7c793          	not	a5,a5
 3c0:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3c2:	15fd                	add	a1,a1,-1
 3c4:	177d                	add	a4,a4,-1
 3c6:	0005c683          	lbu	a3,0(a1)
 3ca:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ce:	fee79ae3          	bne	a5,a4,3c2 <memmove+0x46>
 3d2:	bfc9                	j	3a4 <memmove+0x28>

00000000000003d4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3d4:	1141                	add	sp,sp,-16
 3d6:	e422                	sd	s0,8(sp)
 3d8:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3da:	ca05                	beqz	a2,40a <memcmp+0x36>
 3dc:	fff6069b          	addw	a3,a2,-1
 3e0:	1682                	sll	a3,a3,0x20
 3e2:	9281                	srl	a3,a3,0x20
 3e4:	0685                	add	a3,a3,1
 3e6:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3e8:	00054783          	lbu	a5,0(a0)
 3ec:	0005c703          	lbu	a4,0(a1)
 3f0:	00e79863          	bne	a5,a4,400 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3f4:	0505                	add	a0,a0,1
    p2++;
 3f6:	0585                	add	a1,a1,1
  while (n-- > 0) {
 3f8:	fed518e3          	bne	a0,a3,3e8 <memcmp+0x14>
  }
  return 0;
 3fc:	4501                	li	a0,0
 3fe:	a019                	j	404 <memcmp+0x30>
      return *p1 - *p2;
 400:	40e7853b          	subw	a0,a5,a4
}
 404:	6422                	ld	s0,8(sp)
 406:	0141                	add	sp,sp,16
 408:	8082                	ret
  return 0;
 40a:	4501                	li	a0,0
 40c:	bfe5                	j	404 <memcmp+0x30>

000000000000040e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 40e:	1141                	add	sp,sp,-16
 410:	e406                	sd	ra,8(sp)
 412:	e022                	sd	s0,0(sp)
 414:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 416:	00000097          	auipc	ra,0x0
 41a:	f66080e7          	jalr	-154(ra) # 37c <memmove>
}
 41e:	60a2                	ld	ra,8(sp)
 420:	6402                	ld	s0,0(sp)
 422:	0141                	add	sp,sp,16
 424:	8082                	ret

0000000000000426 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 426:	4885                	li	a7,1
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <exit>:
.global exit
exit:
 li a7, SYS_exit
 42e:	4889                	li	a7,2
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <wait>:
.global wait
wait:
 li a7, SYS_wait
 436:	488d                	li	a7,3
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 43e:	4891                	li	a7,4
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <read>:
.global read
read:
 li a7, SYS_read
 446:	4895                	li	a7,5
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <write>:
.global write
write:
 li a7, SYS_write
 44e:	48c1                	li	a7,16
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <close>:
.global close
close:
 li a7, SYS_close
 456:	48d5                	li	a7,21
 ecall
 458:	00000073          	ecall
 ret
 45c:	8082                	ret

000000000000045e <kill>:
.global kill
kill:
 li a7, SYS_kill
 45e:	4899                	li	a7,6
 ecall
 460:	00000073          	ecall
 ret
 464:	8082                	ret

0000000000000466 <exec>:
.global exec
exec:
 li a7, SYS_exec
 466:	489d                	li	a7,7
 ecall
 468:	00000073          	ecall
 ret
 46c:	8082                	ret

000000000000046e <open>:
.global open
open:
 li a7, SYS_open
 46e:	48bd                	li	a7,15
 ecall
 470:	00000073          	ecall
 ret
 474:	8082                	ret

0000000000000476 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 476:	48c5                	li	a7,17
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 47e:	48c9                	li	a7,18
 ecall
 480:	00000073          	ecall
 ret
 484:	8082                	ret

0000000000000486 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 486:	48a1                	li	a7,8
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <link>:
.global link
link:
 li a7, SYS_link
 48e:	48cd                	li	a7,19
 ecall
 490:	00000073          	ecall
 ret
 494:	8082                	ret

0000000000000496 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 496:	48d1                	li	a7,20
 ecall
 498:	00000073          	ecall
 ret
 49c:	8082                	ret

000000000000049e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 49e:	48a5                	li	a7,9
 ecall
 4a0:	00000073          	ecall
 ret
 4a4:	8082                	ret

00000000000004a6 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4a6:	48a9                	li	a7,10
 ecall
 4a8:	00000073          	ecall
 ret
 4ac:	8082                	ret

00000000000004ae <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ae:	48ad                	li	a7,11
 ecall
 4b0:	00000073          	ecall
 ret
 4b4:	8082                	ret

00000000000004b6 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4b6:	48b1                	li	a7,12
 ecall
 4b8:	00000073          	ecall
 ret
 4bc:	8082                	ret

00000000000004be <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4be:	48b5                	li	a7,13
 ecall
 4c0:	00000073          	ecall
 ret
 4c4:	8082                	ret

00000000000004c6 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4c6:	48b9                	li	a7,14
 ecall
 4c8:	00000073          	ecall
 ret
 4cc:	8082                	ret

00000000000004ce <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 4ce:	48d9                	li	a7,22
 ecall
 4d0:	00000073          	ecall
 ret
 4d4:	8082                	ret

00000000000004d6 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 4d6:	48dd                	li	a7,23
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 4de:	48e1                	li	a7,24
 ecall
 4e0:	00000073          	ecall
 ret
 4e4:	8082                	ret

00000000000004e6 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 4e6:	48e5                	li	a7,25
 ecall
 4e8:	00000073          	ecall
 ret
 4ec:	8082                	ret

00000000000004ee <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4ee:	1101                	add	sp,sp,-32
 4f0:	ec06                	sd	ra,24(sp)
 4f2:	e822                	sd	s0,16(sp)
 4f4:	1000                	add	s0,sp,32
 4f6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fa:	4605                	li	a2,1
 4fc:	fef40593          	add	a1,s0,-17
 500:	00000097          	auipc	ra,0x0
 504:	f4e080e7          	jalr	-178(ra) # 44e <write>
}
 508:	60e2                	ld	ra,24(sp)
 50a:	6442                	ld	s0,16(sp)
 50c:	6105                	add	sp,sp,32
 50e:	8082                	ret

0000000000000510 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 510:	7139                	add	sp,sp,-64
 512:	fc06                	sd	ra,56(sp)
 514:	f822                	sd	s0,48(sp)
 516:	f426                	sd	s1,40(sp)
 518:	0080                	add	s0,sp,64
 51a:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 51c:	c299                	beqz	a3,522 <printint+0x12>
 51e:	0805cb63          	bltz	a1,5b4 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 522:	2581                	sext.w	a1,a1
  neg = 0;
 524:	4881                	li	a7,0
 526:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 52a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 52c:	2601                	sext.w	a2,a2
 52e:	00000517          	auipc	a0,0x0
 532:	4ea50513          	add	a0,a0,1258 # a18 <digits>
 536:	883a                	mv	a6,a4
 538:	2705                	addw	a4,a4,1
 53a:	02c5f7bb          	remuw	a5,a1,a2
 53e:	1782                	sll	a5,a5,0x20
 540:	9381                	srl	a5,a5,0x20
 542:	97aa                	add	a5,a5,a0
 544:	0007c783          	lbu	a5,0(a5)
 548:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 54c:	0005879b          	sext.w	a5,a1
 550:	02c5d5bb          	divuw	a1,a1,a2
 554:	0685                	add	a3,a3,1
 556:	fec7f0e3          	bgeu	a5,a2,536 <printint+0x26>
  if(neg)
 55a:	00088c63          	beqz	a7,572 <printint+0x62>
    buf[i++] = '-';
 55e:	fd070793          	add	a5,a4,-48
 562:	00878733          	add	a4,a5,s0
 566:	02d00793          	li	a5,45
 56a:	fef70823          	sb	a5,-16(a4)
 56e:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 572:	02e05c63          	blez	a4,5aa <printint+0x9a>
 576:	f04a                	sd	s2,32(sp)
 578:	ec4e                	sd	s3,24(sp)
 57a:	fc040793          	add	a5,s0,-64
 57e:	00e78933          	add	s2,a5,a4
 582:	fff78993          	add	s3,a5,-1
 586:	99ba                	add	s3,s3,a4
 588:	377d                	addw	a4,a4,-1
 58a:	1702                	sll	a4,a4,0x20
 58c:	9301                	srl	a4,a4,0x20
 58e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 592:	fff94583          	lbu	a1,-1(s2)
 596:	8526                	mv	a0,s1
 598:	00000097          	auipc	ra,0x0
 59c:	f56080e7          	jalr	-170(ra) # 4ee <putc>
  while(--i >= 0)
 5a0:	197d                	add	s2,s2,-1
 5a2:	ff3918e3          	bne	s2,s3,592 <printint+0x82>
 5a6:	7902                	ld	s2,32(sp)
 5a8:	69e2                	ld	s3,24(sp)
}
 5aa:	70e2                	ld	ra,56(sp)
 5ac:	7442                	ld	s0,48(sp)
 5ae:	74a2                	ld	s1,40(sp)
 5b0:	6121                	add	sp,sp,64
 5b2:	8082                	ret
    x = -xx;
 5b4:	40b005bb          	negw	a1,a1
    neg = 1;
 5b8:	4885                	li	a7,1
    x = -xx;
 5ba:	b7b5                	j	526 <printint+0x16>

00000000000005bc <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5bc:	715d                	add	sp,sp,-80
 5be:	e486                	sd	ra,72(sp)
 5c0:	e0a2                	sd	s0,64(sp)
 5c2:	f84a                	sd	s2,48(sp)
 5c4:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c6:	0005c903          	lbu	s2,0(a1)
 5ca:	1a090a63          	beqz	s2,77e <vprintf+0x1c2>
 5ce:	fc26                	sd	s1,56(sp)
 5d0:	f44e                	sd	s3,40(sp)
 5d2:	f052                	sd	s4,32(sp)
 5d4:	ec56                	sd	s5,24(sp)
 5d6:	e85a                	sd	s6,16(sp)
 5d8:	e45e                	sd	s7,8(sp)
 5da:	8aaa                	mv	s5,a0
 5dc:	8bb2                	mv	s7,a2
 5de:	00158493          	add	s1,a1,1
  state = 0;
 5e2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5e4:	02500a13          	li	s4,37
 5e8:	4b55                	li	s6,21
 5ea:	a839                	j	608 <vprintf+0x4c>
        putc(fd, c);
 5ec:	85ca                	mv	a1,s2
 5ee:	8556                	mv	a0,s5
 5f0:	00000097          	auipc	ra,0x0
 5f4:	efe080e7          	jalr	-258(ra) # 4ee <putc>
 5f8:	a019                	j	5fe <vprintf+0x42>
    } else if(state == '%'){
 5fa:	01498d63          	beq	s3,s4,614 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 5fe:	0485                	add	s1,s1,1
 600:	fff4c903          	lbu	s2,-1(s1)
 604:	16090763          	beqz	s2,772 <vprintf+0x1b6>
    if(state == 0){
 608:	fe0999e3          	bnez	s3,5fa <vprintf+0x3e>
      if(c == '%'){
 60c:	ff4910e3          	bne	s2,s4,5ec <vprintf+0x30>
        state = '%';
 610:	89d2                	mv	s3,s4
 612:	b7f5                	j	5fe <vprintf+0x42>
      if(c == 'd'){
 614:	13490463          	beq	s2,s4,73c <vprintf+0x180>
 618:	f9d9079b          	addw	a5,s2,-99
 61c:	0ff7f793          	zext.b	a5,a5
 620:	12fb6763          	bltu	s6,a5,74e <vprintf+0x192>
 624:	f9d9079b          	addw	a5,s2,-99
 628:	0ff7f713          	zext.b	a4,a5
 62c:	12eb6163          	bltu	s6,a4,74e <vprintf+0x192>
 630:	00271793          	sll	a5,a4,0x2
 634:	00000717          	auipc	a4,0x0
 638:	38c70713          	add	a4,a4,908 # 9c0 <malloc+0x152>
 63c:	97ba                	add	a5,a5,a4
 63e:	439c                	lw	a5,0(a5)
 640:	97ba                	add	a5,a5,a4
 642:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 644:	008b8913          	add	s2,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	8556                	mv	a0,s5
 652:	00000097          	auipc	ra,0x0
 656:	ebe080e7          	jalr	-322(ra) # 510 <printint>
 65a:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 65c:	4981                	li	s3,0
 65e:	b745                	j	5fe <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 660:	008b8913          	add	s2,s7,8
 664:	4681                	li	a3,0
 666:	4629                	li	a2,10
 668:	000ba583          	lw	a1,0(s7)
 66c:	8556                	mv	a0,s5
 66e:	00000097          	auipc	ra,0x0
 672:	ea2080e7          	jalr	-350(ra) # 510 <printint>
 676:	8bca                	mv	s7,s2
      state = 0;
 678:	4981                	li	s3,0
 67a:	b751                	j	5fe <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 67c:	008b8913          	add	s2,s7,8
 680:	4681                	li	a3,0
 682:	4641                	li	a2,16
 684:	000ba583          	lw	a1,0(s7)
 688:	8556                	mv	a0,s5
 68a:	00000097          	auipc	ra,0x0
 68e:	e86080e7          	jalr	-378(ra) # 510 <printint>
 692:	8bca                	mv	s7,s2
      state = 0;
 694:	4981                	li	s3,0
 696:	b7a5                	j	5fe <vprintf+0x42>
 698:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 69a:	008b8c13          	add	s8,s7,8
 69e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a2:	03000593          	li	a1,48
 6a6:	8556                	mv	a0,s5
 6a8:	00000097          	auipc	ra,0x0
 6ac:	e46080e7          	jalr	-442(ra) # 4ee <putc>
  putc(fd, 'x');
 6b0:	07800593          	li	a1,120
 6b4:	8556                	mv	a0,s5
 6b6:	00000097          	auipc	ra,0x0
 6ba:	e38080e7          	jalr	-456(ra) # 4ee <putc>
 6be:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c0:	00000b97          	auipc	s7,0x0
 6c4:	358b8b93          	add	s7,s7,856 # a18 <digits>
 6c8:	03c9d793          	srl	a5,s3,0x3c
 6cc:	97de                	add	a5,a5,s7
 6ce:	0007c583          	lbu	a1,0(a5)
 6d2:	8556                	mv	a0,s5
 6d4:	00000097          	auipc	ra,0x0
 6d8:	e1a080e7          	jalr	-486(ra) # 4ee <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6dc:	0992                	sll	s3,s3,0x4
 6de:	397d                	addw	s2,s2,-1
 6e0:	fe0914e3          	bnez	s2,6c8 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 6e4:	8be2                	mv	s7,s8
      state = 0;
 6e6:	4981                	li	s3,0
 6e8:	6c02                	ld	s8,0(sp)
 6ea:	bf11                	j	5fe <vprintf+0x42>
        s = va_arg(ap, char*);
 6ec:	008b8993          	add	s3,s7,8
 6f0:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 6f4:	02090163          	beqz	s2,716 <vprintf+0x15a>
        while(*s != 0){
 6f8:	00094583          	lbu	a1,0(s2)
 6fc:	c9a5                	beqz	a1,76c <vprintf+0x1b0>
          putc(fd, *s);
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	dee080e7          	jalr	-530(ra) # 4ee <putc>
          s++;
 708:	0905                	add	s2,s2,1
        while(*s != 0){
 70a:	00094583          	lbu	a1,0(s2)
 70e:	f9e5                	bnez	a1,6fe <vprintf+0x142>
        s = va_arg(ap, char*);
 710:	8bce                	mv	s7,s3
      state = 0;
 712:	4981                	li	s3,0
 714:	b5ed                	j	5fe <vprintf+0x42>
          s = "(null)";
 716:	00000917          	auipc	s2,0x0
 71a:	2a290913          	add	s2,s2,674 # 9b8 <malloc+0x14a>
        while(*s != 0){
 71e:	02800593          	li	a1,40
 722:	bff1                	j	6fe <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 724:	008b8913          	add	s2,s7,8
 728:	000bc583          	lbu	a1,0(s7)
 72c:	8556                	mv	a0,s5
 72e:	00000097          	auipc	ra,0x0
 732:	dc0080e7          	jalr	-576(ra) # 4ee <putc>
 736:	8bca                	mv	s7,s2
      state = 0;
 738:	4981                	li	s3,0
 73a:	b5d1                	j	5fe <vprintf+0x42>
        putc(fd, c);
 73c:	02500593          	li	a1,37
 740:	8556                	mv	a0,s5
 742:	00000097          	auipc	ra,0x0
 746:	dac080e7          	jalr	-596(ra) # 4ee <putc>
      state = 0;
 74a:	4981                	li	s3,0
 74c:	bd4d                	j	5fe <vprintf+0x42>
        putc(fd, '%');
 74e:	02500593          	li	a1,37
 752:	8556                	mv	a0,s5
 754:	00000097          	auipc	ra,0x0
 758:	d9a080e7          	jalr	-614(ra) # 4ee <putc>
        putc(fd, c);
 75c:	85ca                	mv	a1,s2
 75e:	8556                	mv	a0,s5
 760:	00000097          	auipc	ra,0x0
 764:	d8e080e7          	jalr	-626(ra) # 4ee <putc>
      state = 0;
 768:	4981                	li	s3,0
 76a:	bd51                	j	5fe <vprintf+0x42>
        s = va_arg(ap, char*);
 76c:	8bce                	mv	s7,s3
      state = 0;
 76e:	4981                	li	s3,0
 770:	b579                	j	5fe <vprintf+0x42>
 772:	74e2                	ld	s1,56(sp)
 774:	79a2                	ld	s3,40(sp)
 776:	7a02                	ld	s4,32(sp)
 778:	6ae2                	ld	s5,24(sp)
 77a:	6b42                	ld	s6,16(sp)
 77c:	6ba2                	ld	s7,8(sp)
    }
  }
}
 77e:	60a6                	ld	ra,72(sp)
 780:	6406                	ld	s0,64(sp)
 782:	7942                	ld	s2,48(sp)
 784:	6161                	add	sp,sp,80
 786:	8082                	ret

0000000000000788 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 788:	715d                	add	sp,sp,-80
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	add	s0,sp,32
 790:	e010                	sd	a2,0(s0)
 792:	e414                	sd	a3,8(s0)
 794:	e818                	sd	a4,16(s0)
 796:	ec1c                	sd	a5,24(s0)
 798:	03043023          	sd	a6,32(s0)
 79c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7a0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7a4:	8622                	mv	a2,s0
 7a6:	00000097          	auipc	ra,0x0
 7aa:	e16080e7          	jalr	-490(ra) # 5bc <vprintf>
}
 7ae:	60e2                	ld	ra,24(sp)
 7b0:	6442                	ld	s0,16(sp)
 7b2:	6161                	add	sp,sp,80
 7b4:	8082                	ret

00000000000007b6 <printf>:

void
printf(const char *fmt, ...)
{
 7b6:	711d                	add	sp,sp,-96
 7b8:	ec06                	sd	ra,24(sp)
 7ba:	e822                	sd	s0,16(sp)
 7bc:	1000                	add	s0,sp,32
 7be:	e40c                	sd	a1,8(s0)
 7c0:	e810                	sd	a2,16(s0)
 7c2:	ec14                	sd	a3,24(s0)
 7c4:	f018                	sd	a4,32(s0)
 7c6:	f41c                	sd	a5,40(s0)
 7c8:	03043823          	sd	a6,48(s0)
 7cc:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7d0:	00840613          	add	a2,s0,8
 7d4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7d8:	85aa                	mv	a1,a0
 7da:	4505                	li	a0,1
 7dc:	00000097          	auipc	ra,0x0
 7e0:	de0080e7          	jalr	-544(ra) # 5bc <vprintf>
}
 7e4:	60e2                	ld	ra,24(sp)
 7e6:	6442                	ld	s0,16(sp)
 7e8:	6125                	add	sp,sp,96
 7ea:	8082                	ret

00000000000007ec <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ec:	1141                	add	sp,sp,-16
 7ee:	e422                	sd	s0,8(sp)
 7f0:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7f2:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f6:	00001797          	auipc	a5,0x1
 7fa:	80a7b783          	ld	a5,-2038(a5) # 1000 <freep>
 7fe:	a02d                	j	828 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 800:	4618                	lw	a4,8(a2)
 802:	9f2d                	addw	a4,a4,a1
 804:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 808:	6398                	ld	a4,0(a5)
 80a:	6310                	ld	a2,0(a4)
 80c:	a83d                	j	84a <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 80e:	ff852703          	lw	a4,-8(a0)
 812:	9f31                	addw	a4,a4,a2
 814:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 816:	ff053683          	ld	a3,-16(a0)
 81a:	a091                	j	85e <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81c:	6398                	ld	a4,0(a5)
 81e:	00e7e463          	bltu	a5,a4,826 <free+0x3a>
 822:	00e6ea63          	bltu	a3,a4,836 <free+0x4a>
{
 826:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 828:	fed7fae3          	bgeu	a5,a3,81c <free+0x30>
 82c:	6398                	ld	a4,0(a5)
 82e:	00e6e463          	bltu	a3,a4,836 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 832:	fee7eae3          	bltu	a5,a4,826 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 836:	ff852583          	lw	a1,-8(a0)
 83a:	6390                	ld	a2,0(a5)
 83c:	02059813          	sll	a6,a1,0x20
 840:	01c85713          	srl	a4,a6,0x1c
 844:	9736                	add	a4,a4,a3
 846:	fae60de3          	beq	a2,a4,800 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 84a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 84e:	4790                	lw	a2,8(a5)
 850:	02061593          	sll	a1,a2,0x20
 854:	01c5d713          	srl	a4,a1,0x1c
 858:	973e                	add	a4,a4,a5
 85a:	fae68ae3          	beq	a3,a4,80e <free+0x22>
    p->s.ptr = bp->s.ptr;
 85e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 860:	00000717          	auipc	a4,0x0
 864:	7af73023          	sd	a5,1952(a4) # 1000 <freep>
}
 868:	6422                	ld	s0,8(sp)
 86a:	0141                	add	sp,sp,16
 86c:	8082                	ret

000000000000086e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 86e:	7139                	add	sp,sp,-64
 870:	fc06                	sd	ra,56(sp)
 872:	f822                	sd	s0,48(sp)
 874:	f426                	sd	s1,40(sp)
 876:	ec4e                	sd	s3,24(sp)
 878:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 87a:	02051493          	sll	s1,a0,0x20
 87e:	9081                	srl	s1,s1,0x20
 880:	04bd                	add	s1,s1,15
 882:	8091                	srl	s1,s1,0x4
 884:	0014899b          	addw	s3,s1,1
 888:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 88a:	00000517          	auipc	a0,0x0
 88e:	77653503          	ld	a0,1910(a0) # 1000 <freep>
 892:	c915                	beqz	a0,8c6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 894:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 896:	4798                	lw	a4,8(a5)
 898:	08977e63          	bgeu	a4,s1,934 <malloc+0xc6>
 89c:	f04a                	sd	s2,32(sp)
 89e:	e852                	sd	s4,16(sp)
 8a0:	e456                	sd	s5,8(sp)
 8a2:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8a4:	8a4e                	mv	s4,s3
 8a6:	0009871b          	sext.w	a4,s3
 8aa:	6685                	lui	a3,0x1
 8ac:	00d77363          	bgeu	a4,a3,8b2 <malloc+0x44>
 8b0:	6a05                	lui	s4,0x1
 8b2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8b6:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8ba:	00000917          	auipc	s2,0x0
 8be:	74690913          	add	s2,s2,1862 # 1000 <freep>
  if(p == (char*)-1)
 8c2:	5afd                	li	s5,-1
 8c4:	a091                	j	908 <malloc+0x9a>
 8c6:	f04a                	sd	s2,32(sp)
 8c8:	e852                	sd	s4,16(sp)
 8ca:	e456                	sd	s5,8(sp)
 8cc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ce:	00001797          	auipc	a5,0x1
 8d2:	94278793          	add	a5,a5,-1726 # 1210 <base>
 8d6:	00000717          	auipc	a4,0x0
 8da:	72f73523          	sd	a5,1834(a4) # 1000 <freep>
 8de:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8e0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8e4:	b7c1                	j	8a4 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 8e6:	6398                	ld	a4,0(a5)
 8e8:	e118                	sd	a4,0(a0)
 8ea:	a08d                	j	94c <malloc+0xde>
  hp->s.size = nu;
 8ec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8f0:	0541                	add	a0,a0,16
 8f2:	00000097          	auipc	ra,0x0
 8f6:	efa080e7          	jalr	-262(ra) # 7ec <free>
  return freep;
 8fa:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 8fe:	c13d                	beqz	a0,964 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 900:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 902:	4798                	lw	a4,8(a5)
 904:	02977463          	bgeu	a4,s1,92c <malloc+0xbe>
    if(p == freep)
 908:	00093703          	ld	a4,0(s2)
 90c:	853e                	mv	a0,a5
 90e:	fef719e3          	bne	a4,a5,900 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 912:	8552                	mv	a0,s4
 914:	00000097          	auipc	ra,0x0
 918:	ba2080e7          	jalr	-1118(ra) # 4b6 <sbrk>
  if(p == (char*)-1)
 91c:	fd5518e3          	bne	a0,s5,8ec <malloc+0x7e>
        return 0;
 920:	4501                	li	a0,0
 922:	7902                	ld	s2,32(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	a03d                	j	958 <malloc+0xea>
 92c:	7902                	ld	s2,32(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 934:	fae489e3          	beq	s1,a4,8e6 <malloc+0x78>
        p->s.size -= nunits;
 938:	4137073b          	subw	a4,a4,s3
 93c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 93e:	02071693          	sll	a3,a4,0x20
 942:	01c6d713          	srl	a4,a3,0x1c
 946:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 948:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 94c:	00000717          	auipc	a4,0x0
 950:	6aa73a23          	sd	a0,1716(a4) # 1000 <freep>
      return (void*)(p + 1);
 954:	01078513          	add	a0,a5,16
  }
}
 958:	70e2                	ld	ra,56(sp)
 95a:	7442                	ld	s0,48(sp)
 95c:	74a2                	ld	s1,40(sp)
 95e:	69e2                	ld	s3,24(sp)
 960:	6121                	add	sp,sp,64
 962:	8082                	ret
 964:	7902                	ld	s2,32(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
 96c:	b7f5                	j	958 <malloc+0xea>
