
user/_grep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	e052                	sd	s4,0(sp)
   e:	1800                	add	s0,sp,48
  10:	892a                	mv	s2,a0
  12:	89ae                	mv	s3,a1
  14:	84b2                	mv	s1,a2
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  16:	02e00a13          	li	s4,46
    if(matchhere(re, text))
  1a:	85a6                	mv	a1,s1
  1c:	854e                	mv	a0,s3
  1e:	00000097          	auipc	ra,0x0
  22:	030080e7          	jalr	48(ra) # 4e <matchhere>
  26:	e919                	bnez	a0,3c <matchstar+0x3c>
  }while(*text!='\0' && (*text++==c || c=='.'));
  28:	0004c783          	lbu	a5,0(s1)
  2c:	cb89                	beqz	a5,3e <matchstar+0x3e>
  2e:	0485                	add	s1,s1,1
  30:	2781                	sext.w	a5,a5
  32:	ff2784e3          	beq	a5,s2,1a <matchstar+0x1a>
  36:	ff4902e3          	beq	s2,s4,1a <matchstar+0x1a>
  3a:	a011                	j	3e <matchstar+0x3e>
      return 1;
  3c:	4505                	li	a0,1
  return 0;
}
  3e:	70a2                	ld	ra,40(sp)
  40:	7402                	ld	s0,32(sp)
  42:	64e2                	ld	s1,24(sp)
  44:	6942                	ld	s2,16(sp)
  46:	69a2                	ld	s3,8(sp)
  48:	6a02                	ld	s4,0(sp)
  4a:	6145                	add	sp,sp,48
  4c:	8082                	ret

000000000000004e <matchhere>:
  if(re[0] == '\0')
  4e:	00054703          	lbu	a4,0(a0)
  52:	cb3d                	beqz	a4,c8 <matchhere+0x7a>
{
  54:	1141                	add	sp,sp,-16
  56:	e406                	sd	ra,8(sp)
  58:	e022                	sd	s0,0(sp)
  5a:	0800                	add	s0,sp,16
  5c:	87aa                	mv	a5,a0
  if(re[1] == '*')
  5e:	00154683          	lbu	a3,1(a0)
  62:	02a00613          	li	a2,42
  66:	02c68563          	beq	a3,a2,90 <matchhere+0x42>
  if(re[0] == '$' && re[1] == '\0')
  6a:	02400613          	li	a2,36
  6e:	02c70a63          	beq	a4,a2,a2 <matchhere+0x54>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  72:	0005c683          	lbu	a3,0(a1)
  return 0;
  76:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  78:	ca81                	beqz	a3,88 <matchhere+0x3a>
  7a:	02e00613          	li	a2,46
  7e:	02c70d63          	beq	a4,a2,b8 <matchhere+0x6a>
  return 0;
  82:	4501                	li	a0,0
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  84:	02d70a63          	beq	a4,a3,b8 <matchhere+0x6a>
}
  88:	60a2                	ld	ra,8(sp)
  8a:	6402                	ld	s0,0(sp)
  8c:	0141                	add	sp,sp,16
  8e:	8082                	ret
    return matchstar(re[0], re+2, text);
  90:	862e                	mv	a2,a1
  92:	00250593          	add	a1,a0,2
  96:	853a                	mv	a0,a4
  98:	00000097          	auipc	ra,0x0
  9c:	f68080e7          	jalr	-152(ra) # 0 <matchstar>
  a0:	b7e5                	j	88 <matchhere+0x3a>
  if(re[0] == '$' && re[1] == '\0')
  a2:	c691                	beqz	a3,ae <matchhere+0x60>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  a4:	0005c683          	lbu	a3,0(a1)
  a8:	fee9                	bnez	a3,82 <matchhere+0x34>
  return 0;
  aa:	4501                	li	a0,0
  ac:	bff1                	j	88 <matchhere+0x3a>
    return *text == '\0';
  ae:	0005c503          	lbu	a0,0(a1)
  b2:	00153513          	seqz	a0,a0
  b6:	bfc9                	j	88 <matchhere+0x3a>
    return matchhere(re+1, text+1);
  b8:	0585                	add	a1,a1,1
  ba:	00178513          	add	a0,a5,1
  be:	00000097          	auipc	ra,0x0
  c2:	f90080e7          	jalr	-112(ra) # 4e <matchhere>
  c6:	b7c9                	j	88 <matchhere+0x3a>
    return 1;
  c8:	4505                	li	a0,1
}
  ca:	8082                	ret

00000000000000cc <match>:
{
  cc:	1101                	add	sp,sp,-32
  ce:	ec06                	sd	ra,24(sp)
  d0:	e822                	sd	s0,16(sp)
  d2:	e426                	sd	s1,8(sp)
  d4:	e04a                	sd	s2,0(sp)
  d6:	1000                	add	s0,sp,32
  d8:	892a                	mv	s2,a0
  da:	84ae                	mv	s1,a1
  if(re[0] == '^')
  dc:	00054703          	lbu	a4,0(a0)
  e0:	05e00793          	li	a5,94
  e4:	00f70e63          	beq	a4,a5,100 <match+0x34>
    if(matchhere(re, text))
  e8:	85a6                	mv	a1,s1
  ea:	854a                	mv	a0,s2
  ec:	00000097          	auipc	ra,0x0
  f0:	f62080e7          	jalr	-158(ra) # 4e <matchhere>
  f4:	ed01                	bnez	a0,10c <match+0x40>
  }while(*text++ != '\0');
  f6:	0485                	add	s1,s1,1
  f8:	fff4c783          	lbu	a5,-1(s1)
  fc:	f7f5                	bnez	a5,e8 <match+0x1c>
  fe:	a801                	j	10e <match+0x42>
    return matchhere(re+1, text);
 100:	0505                	add	a0,a0,1
 102:	00000097          	auipc	ra,0x0
 106:	f4c080e7          	jalr	-180(ra) # 4e <matchhere>
 10a:	a011                	j	10e <match+0x42>
      return 1;
 10c:	4505                	li	a0,1
}
 10e:	60e2                	ld	ra,24(sp)
 110:	6442                	ld	s0,16(sp)
 112:	64a2                	ld	s1,8(sp)
 114:	6902                	ld	s2,0(sp)
 116:	6105                	add	sp,sp,32
 118:	8082                	ret

000000000000011a <grep>:
{
 11a:	715d                	add	sp,sp,-80
 11c:	e486                	sd	ra,72(sp)
 11e:	e0a2                	sd	s0,64(sp)
 120:	fc26                	sd	s1,56(sp)
 122:	f84a                	sd	s2,48(sp)
 124:	f44e                	sd	s3,40(sp)
 126:	f052                	sd	s4,32(sp)
 128:	ec56                	sd	s5,24(sp)
 12a:	e85a                	sd	s6,16(sp)
 12c:	e45e                	sd	s7,8(sp)
 12e:	e062                	sd	s8,0(sp)
 130:	0880                	add	s0,sp,80
 132:	89aa                	mv	s3,a0
 134:	8b2e                	mv	s6,a1
  m = 0;
 136:	4a01                	li	s4,0
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 138:	3ff00b93          	li	s7,1023
 13c:	00001a97          	auipc	s5,0x1
 140:	ed4a8a93          	add	s5,s5,-300 # 1010 <buf>
 144:	a0a1                	j	18c <grep+0x72>
      p = q+1;
 146:	00148913          	add	s2,s1,1
    while((q = strchr(p, '\n')) != 0){
 14a:	45a9                	li	a1,10
 14c:	854a                	mv	a0,s2
 14e:	00000097          	auipc	ra,0x0
 152:	20a080e7          	jalr	522(ra) # 358 <strchr>
 156:	84aa                	mv	s1,a0
 158:	c905                	beqz	a0,188 <grep+0x6e>
      *q = 0;
 15a:	00048023          	sb	zero,0(s1)
      if(match(pattern, p)){
 15e:	85ca                	mv	a1,s2
 160:	854e                	mv	a0,s3
 162:	00000097          	auipc	ra,0x0
 166:	f6a080e7          	jalr	-150(ra) # cc <match>
 16a:	dd71                	beqz	a0,146 <grep+0x2c>
        *q = '\n';
 16c:	47a9                	li	a5,10
 16e:	00f48023          	sb	a5,0(s1)
        write(1, p, q+1 - p);
 172:	00148613          	add	a2,s1,1
 176:	4126063b          	subw	a2,a2,s2
 17a:	85ca                	mv	a1,s2
 17c:	4505                	li	a0,1
 17e:	00000097          	auipc	ra,0x0
 182:	3ea080e7          	jalr	1002(ra) # 568 <write>
 186:	b7c1                	j	146 <grep+0x2c>
    if(m > 0){
 188:	03404763          	bgtz	s4,1b6 <grep+0x9c>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 18c:	414b863b          	subw	a2,s7,s4
 190:	014a85b3          	add	a1,s5,s4
 194:	855a                	mv	a0,s6
 196:	00000097          	auipc	ra,0x0
 19a:	3ca080e7          	jalr	970(ra) # 560 <read>
 19e:	02a05b63          	blez	a0,1d4 <grep+0xba>
    m += n;
 1a2:	00aa0c3b          	addw	s8,s4,a0
 1a6:	000c0a1b          	sext.w	s4,s8
    buf[m] = '\0';
 1aa:	014a87b3          	add	a5,s5,s4
 1ae:	00078023          	sb	zero,0(a5)
    p = buf;
 1b2:	8956                	mv	s2,s5
    while((q = strchr(p, '\n')) != 0){
 1b4:	bf59                	j	14a <grep+0x30>
      m -= p - buf;
 1b6:	00001517          	auipc	a0,0x1
 1ba:	e5a50513          	add	a0,a0,-422 # 1010 <buf>
 1be:	40a90a33          	sub	s4,s2,a0
 1c2:	414c0a3b          	subw	s4,s8,s4
      memmove(buf, p, m);
 1c6:	8652                	mv	a2,s4
 1c8:	85ca                	mv	a1,s2
 1ca:	00000097          	auipc	ra,0x0
 1ce:	2cc080e7          	jalr	716(ra) # 496 <memmove>
 1d2:	bf6d                	j	18c <grep+0x72>
}
 1d4:	60a6                	ld	ra,72(sp)
 1d6:	6406                	ld	s0,64(sp)
 1d8:	74e2                	ld	s1,56(sp)
 1da:	7942                	ld	s2,48(sp)
 1dc:	79a2                	ld	s3,40(sp)
 1de:	7a02                	ld	s4,32(sp)
 1e0:	6ae2                	ld	s5,24(sp)
 1e2:	6b42                	ld	s6,16(sp)
 1e4:	6ba2                	ld	s7,8(sp)
 1e6:	6c02                	ld	s8,0(sp)
 1e8:	6161                	add	sp,sp,80
 1ea:	8082                	ret

00000000000001ec <main>:
{
 1ec:	7179                	add	sp,sp,-48
 1ee:	f406                	sd	ra,40(sp)
 1f0:	f022                	sd	s0,32(sp)
 1f2:	ec26                	sd	s1,24(sp)
 1f4:	e84a                	sd	s2,16(sp)
 1f6:	e44e                	sd	s3,8(sp)
 1f8:	e052                	sd	s4,0(sp)
 1fa:	1800                	add	s0,sp,48
  if(argc <= 1){
 1fc:	4785                	li	a5,1
 1fe:	04a7de63          	bge	a5,a0,25a <main+0x6e>
  pattern = argv[1];
 202:	0085ba03          	ld	s4,8(a1)
  if(argc <= 2){
 206:	4789                	li	a5,2
 208:	06a7d763          	bge	a5,a0,276 <main+0x8a>
 20c:	01058913          	add	s2,a1,16
 210:	ffd5099b          	addw	s3,a0,-3
 214:	02099793          	sll	a5,s3,0x20
 218:	01d7d993          	srl	s3,a5,0x1d
 21c:	05e1                	add	a1,a1,24
 21e:	99ae                	add	s3,s3,a1
    if((fd = open(argv[i], 0)) < 0){
 220:	4581                	li	a1,0
 222:	00093503          	ld	a0,0(s2)
 226:	00000097          	auipc	ra,0x0
 22a:	362080e7          	jalr	866(ra) # 588 <open>
 22e:	84aa                	mv	s1,a0
 230:	04054e63          	bltz	a0,28c <main+0xa0>
    grep(pattern, fd);
 234:	85aa                	mv	a1,a0
 236:	8552                	mv	a0,s4
 238:	00000097          	auipc	ra,0x0
 23c:	ee2080e7          	jalr	-286(ra) # 11a <grep>
    close(fd);
 240:	8526                	mv	a0,s1
 242:	00000097          	auipc	ra,0x0
 246:	32e080e7          	jalr	814(ra) # 570 <close>
  for(i = 2; i < argc; i++){
 24a:	0921                	add	s2,s2,8
 24c:	fd391ae3          	bne	s2,s3,220 <main+0x34>
  exit(0);
 250:	4501                	li	a0,0
 252:	00000097          	auipc	ra,0x0
 256:	2f6080e7          	jalr	758(ra) # 548 <exit>
    fprintf(2, "usage: grep pattern [file ...]\n");
 25a:	00001597          	auipc	a1,0x1
 25e:	83658593          	add	a1,a1,-1994 # a90 <malloc+0x108>
 262:	4509                	li	a0,2
 264:	00000097          	auipc	ra,0x0
 268:	63e080e7          	jalr	1598(ra) # 8a2 <fprintf>
    exit(1);
 26c:	4505                	li	a0,1
 26e:	00000097          	auipc	ra,0x0
 272:	2da080e7          	jalr	730(ra) # 548 <exit>
    grep(pattern, 0);
 276:	4581                	li	a1,0
 278:	8552                	mv	a0,s4
 27a:	00000097          	auipc	ra,0x0
 27e:	ea0080e7          	jalr	-352(ra) # 11a <grep>
    exit(0);
 282:	4501                	li	a0,0
 284:	00000097          	auipc	ra,0x0
 288:	2c4080e7          	jalr	708(ra) # 548 <exit>
      printf("grep: cannot open %s\n", argv[i]);
 28c:	00093583          	ld	a1,0(s2)
 290:	00001517          	auipc	a0,0x1
 294:	82050513          	add	a0,a0,-2016 # ab0 <malloc+0x128>
 298:	00000097          	auipc	ra,0x0
 29c:	638080e7          	jalr	1592(ra) # 8d0 <printf>
      exit(1);
 2a0:	4505                	li	a0,1
 2a2:	00000097          	auipc	ra,0x0
 2a6:	2a6080e7          	jalr	678(ra) # 548 <exit>

00000000000002aa <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2aa:	1141                	add	sp,sp,-16
 2ac:	e406                	sd	ra,8(sp)
 2ae:	e022                	sd	s0,0(sp)
 2b0:	0800                	add	s0,sp,16
  extern int main();
  main();
 2b2:	00000097          	auipc	ra,0x0
 2b6:	f3a080e7          	jalr	-198(ra) # 1ec <main>
  exit(0);
 2ba:	4501                	li	a0,0
 2bc:	00000097          	auipc	ra,0x0
 2c0:	28c080e7          	jalr	652(ra) # 548 <exit>

00000000000002c4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c4:	1141                	add	sp,sp,-16
 2c6:	e422                	sd	s0,8(sp)
 2c8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ca:	87aa                	mv	a5,a0
 2cc:	0585                	add	a1,a1,1
 2ce:	0785                	add	a5,a5,1
 2d0:	fff5c703          	lbu	a4,-1(a1)
 2d4:	fee78fa3          	sb	a4,-1(a5)
 2d8:	fb75                	bnez	a4,2cc <strcpy+0x8>
    ;
  return os;
}
 2da:	6422                	ld	s0,8(sp)
 2dc:	0141                	add	sp,sp,16
 2de:	8082                	ret

00000000000002e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e0:	1141                	add	sp,sp,-16
 2e2:	e422                	sd	s0,8(sp)
 2e4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 2e6:	00054783          	lbu	a5,0(a0)
 2ea:	cb91                	beqz	a5,2fe <strcmp+0x1e>
 2ec:	0005c703          	lbu	a4,0(a1)
 2f0:	00f71763          	bne	a4,a5,2fe <strcmp+0x1e>
    p++, q++;
 2f4:	0505                	add	a0,a0,1
 2f6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 2f8:	00054783          	lbu	a5,0(a0)
 2fc:	fbe5                	bnez	a5,2ec <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 2fe:	0005c503          	lbu	a0,0(a1)
}
 302:	40a7853b          	subw	a0,a5,a0
 306:	6422                	ld	s0,8(sp)
 308:	0141                	add	sp,sp,16
 30a:	8082                	ret

000000000000030c <strlen>:

uint
strlen(const char *s)
{
 30c:	1141                	add	sp,sp,-16
 30e:	e422                	sd	s0,8(sp)
 310:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 312:	00054783          	lbu	a5,0(a0)
 316:	cf91                	beqz	a5,332 <strlen+0x26>
 318:	0505                	add	a0,a0,1
 31a:	87aa                	mv	a5,a0
 31c:	86be                	mv	a3,a5
 31e:	0785                	add	a5,a5,1
 320:	fff7c703          	lbu	a4,-1(a5)
 324:	ff65                	bnez	a4,31c <strlen+0x10>
 326:	40a6853b          	subw	a0,a3,a0
 32a:	2505                	addw	a0,a0,1
    ;
  return n;
}
 32c:	6422                	ld	s0,8(sp)
 32e:	0141                	add	sp,sp,16
 330:	8082                	ret
  for(n = 0; s[n]; n++)
 332:	4501                	li	a0,0
 334:	bfe5                	j	32c <strlen+0x20>

0000000000000336 <memset>:

void*
memset(void *dst, int c, uint n)
{
 336:	1141                	add	sp,sp,-16
 338:	e422                	sd	s0,8(sp)
 33a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 33c:	ca19                	beqz	a2,352 <memset+0x1c>
 33e:	87aa                	mv	a5,a0
 340:	1602                	sll	a2,a2,0x20
 342:	9201                	srl	a2,a2,0x20
 344:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 348:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 34c:	0785                	add	a5,a5,1
 34e:	fee79de3          	bne	a5,a4,348 <memset+0x12>
  }
  return dst;
}
 352:	6422                	ld	s0,8(sp)
 354:	0141                	add	sp,sp,16
 356:	8082                	ret

0000000000000358 <strchr>:

char*
strchr(const char *s, char c)
{
 358:	1141                	add	sp,sp,-16
 35a:	e422                	sd	s0,8(sp)
 35c:	0800                	add	s0,sp,16
  for(; *s; s++)
 35e:	00054783          	lbu	a5,0(a0)
 362:	cb99                	beqz	a5,378 <strchr+0x20>
    if(*s == c)
 364:	00f58763          	beq	a1,a5,372 <strchr+0x1a>
  for(; *s; s++)
 368:	0505                	add	a0,a0,1
 36a:	00054783          	lbu	a5,0(a0)
 36e:	fbfd                	bnez	a5,364 <strchr+0xc>
      return (char*)s;
  return 0;
 370:	4501                	li	a0,0
}
 372:	6422                	ld	s0,8(sp)
 374:	0141                	add	sp,sp,16
 376:	8082                	ret
  return 0;
 378:	4501                	li	a0,0
 37a:	bfe5                	j	372 <strchr+0x1a>

000000000000037c <gets>:

char*
gets(char *buf, int max)
{
 37c:	711d                	add	sp,sp,-96
 37e:	ec86                	sd	ra,88(sp)
 380:	e8a2                	sd	s0,80(sp)
 382:	e4a6                	sd	s1,72(sp)
 384:	e0ca                	sd	s2,64(sp)
 386:	fc4e                	sd	s3,56(sp)
 388:	f852                	sd	s4,48(sp)
 38a:	f456                	sd	s5,40(sp)
 38c:	f05a                	sd	s6,32(sp)
 38e:	ec5e                	sd	s7,24(sp)
 390:	1080                	add	s0,sp,96
 392:	8baa                	mv	s7,a0
 394:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 396:	892a                	mv	s2,a0
 398:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 39a:	4aa9                	li	s5,10
 39c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 39e:	89a6                	mv	s3,s1
 3a0:	2485                	addw	s1,s1,1
 3a2:	0344d863          	bge	s1,s4,3d2 <gets+0x56>
    cc = read(0, &c, 1);
 3a6:	4605                	li	a2,1
 3a8:	faf40593          	add	a1,s0,-81
 3ac:	4501                	li	a0,0
 3ae:	00000097          	auipc	ra,0x0
 3b2:	1b2080e7          	jalr	434(ra) # 560 <read>
    if(cc < 1)
 3b6:	00a05e63          	blez	a0,3d2 <gets+0x56>
    buf[i++] = c;
 3ba:	faf44783          	lbu	a5,-81(s0)
 3be:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3c2:	01578763          	beq	a5,s5,3d0 <gets+0x54>
 3c6:	0905                	add	s2,s2,1
 3c8:	fd679be3          	bne	a5,s6,39e <gets+0x22>
    buf[i++] = c;
 3cc:	89a6                	mv	s3,s1
 3ce:	a011                	j	3d2 <gets+0x56>
 3d0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 3d2:	99de                	add	s3,s3,s7
 3d4:	00098023          	sb	zero,0(s3)
  return buf;
}
 3d8:	855e                	mv	a0,s7
 3da:	60e6                	ld	ra,88(sp)
 3dc:	6446                	ld	s0,80(sp)
 3de:	64a6                	ld	s1,72(sp)
 3e0:	6906                	ld	s2,64(sp)
 3e2:	79e2                	ld	s3,56(sp)
 3e4:	7a42                	ld	s4,48(sp)
 3e6:	7aa2                	ld	s5,40(sp)
 3e8:	7b02                	ld	s6,32(sp)
 3ea:	6be2                	ld	s7,24(sp)
 3ec:	6125                	add	sp,sp,96
 3ee:	8082                	ret

00000000000003f0 <stat>:

int
stat(const char *n, struct stat *st)
{
 3f0:	1101                	add	sp,sp,-32
 3f2:	ec06                	sd	ra,24(sp)
 3f4:	e822                	sd	s0,16(sp)
 3f6:	e04a                	sd	s2,0(sp)
 3f8:	1000                	add	s0,sp,32
 3fa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3fc:	4581                	li	a1,0
 3fe:	00000097          	auipc	ra,0x0
 402:	18a080e7          	jalr	394(ra) # 588 <open>
  if(fd < 0)
 406:	02054663          	bltz	a0,432 <stat+0x42>
 40a:	e426                	sd	s1,8(sp)
 40c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 40e:	85ca                	mv	a1,s2
 410:	00000097          	auipc	ra,0x0
 414:	190080e7          	jalr	400(ra) # 5a0 <fstat>
 418:	892a                	mv	s2,a0
  close(fd);
 41a:	8526                	mv	a0,s1
 41c:	00000097          	auipc	ra,0x0
 420:	154080e7          	jalr	340(ra) # 570 <close>
  return r;
 424:	64a2                	ld	s1,8(sp)
}
 426:	854a                	mv	a0,s2
 428:	60e2                	ld	ra,24(sp)
 42a:	6442                	ld	s0,16(sp)
 42c:	6902                	ld	s2,0(sp)
 42e:	6105                	add	sp,sp,32
 430:	8082                	ret
    return -1;
 432:	597d                	li	s2,-1
 434:	bfcd                	j	426 <stat+0x36>

0000000000000436 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 436:	1141                	add	sp,sp,-16
 438:	e422                	sd	s0,8(sp)
 43a:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 43c:	00054703          	lbu	a4,0(a0)
 440:	02d00793          	li	a5,45
 444:	4585                	li	a1,1
 446:	04f70363          	beq	a4,a5,48c <atoi+0x56>

  while('0' <= *s && *s <= '9')
 44a:	00054703          	lbu	a4,0(a0)
 44e:	fd07079b          	addw	a5,a4,-48
 452:	0ff7f793          	zext.b	a5,a5
 456:	46a5                	li	a3,9
 458:	02f6ed63          	bltu	a3,a5,492 <atoi+0x5c>
  int n = 0;
 45c:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 45e:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 460:	0505                	add	a0,a0,1
 462:	0026979b          	sllw	a5,a3,0x2
 466:	9fb5                	addw	a5,a5,a3
 468:	0017979b          	sllw	a5,a5,0x1
 46c:	9fb9                	addw	a5,a5,a4
 46e:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 472:	00054703          	lbu	a4,0(a0)
 476:	fd07079b          	addw	a5,a4,-48
 47a:	0ff7f793          	zext.b	a5,a5
 47e:	fef671e3          	bgeu	a2,a5,460 <atoi+0x2a>
  return sign * n;
}
 482:	02d5853b          	mulw	a0,a1,a3
 486:	6422                	ld	s0,8(sp)
 488:	0141                	add	sp,sp,16
 48a:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 48c:	0505                	add	a0,a0,1
 48e:	55fd                	li	a1,-1
 490:	bf6d                	j	44a <atoi+0x14>
  int n = 0;
 492:	4681                	li	a3,0
 494:	b7fd                	j	482 <atoi+0x4c>

0000000000000496 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 496:	1141                	add	sp,sp,-16
 498:	e422                	sd	s0,8(sp)
 49a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 49c:	02b57463          	bgeu	a0,a1,4c4 <memmove+0x2e>
    while(n-- > 0)
 4a0:	00c05f63          	blez	a2,4be <memmove+0x28>
 4a4:	1602                	sll	a2,a2,0x20
 4a6:	9201                	srl	a2,a2,0x20
 4a8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4ac:	872a                	mv	a4,a0
      *dst++ = *src++;
 4ae:	0585                	add	a1,a1,1
 4b0:	0705                	add	a4,a4,1
 4b2:	fff5c683          	lbu	a3,-1(a1)
 4b6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ba:	fef71ae3          	bne	a4,a5,4ae <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4be:	6422                	ld	s0,8(sp)
 4c0:	0141                	add	sp,sp,16
 4c2:	8082                	ret
    dst += n;
 4c4:	00c50733          	add	a4,a0,a2
    src += n;
 4c8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4ca:	fec05ae3          	blez	a2,4be <memmove+0x28>
 4ce:	fff6079b          	addw	a5,a2,-1
 4d2:	1782                	sll	a5,a5,0x20
 4d4:	9381                	srl	a5,a5,0x20
 4d6:	fff7c793          	not	a5,a5
 4da:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4dc:	15fd                	add	a1,a1,-1
 4de:	177d                	add	a4,a4,-1
 4e0:	0005c683          	lbu	a3,0(a1)
 4e4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e8:	fee79ae3          	bne	a5,a4,4dc <memmove+0x46>
 4ec:	bfc9                	j	4be <memmove+0x28>

00000000000004ee <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ee:	1141                	add	sp,sp,-16
 4f0:	e422                	sd	s0,8(sp)
 4f2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f4:	ca05                	beqz	a2,524 <memcmp+0x36>
 4f6:	fff6069b          	addw	a3,a2,-1
 4fa:	1682                	sll	a3,a3,0x20
 4fc:	9281                	srl	a3,a3,0x20
 4fe:	0685                	add	a3,a3,1
 500:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 502:	00054783          	lbu	a5,0(a0)
 506:	0005c703          	lbu	a4,0(a1)
 50a:	00e79863          	bne	a5,a4,51a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 50e:	0505                	add	a0,a0,1
    p2++;
 510:	0585                	add	a1,a1,1
  while (n-- > 0) {
 512:	fed518e3          	bne	a0,a3,502 <memcmp+0x14>
  }
  return 0;
 516:	4501                	li	a0,0
 518:	a019                	j	51e <memcmp+0x30>
      return *p1 - *p2;
 51a:	40e7853b          	subw	a0,a5,a4
}
 51e:	6422                	ld	s0,8(sp)
 520:	0141                	add	sp,sp,16
 522:	8082                	ret
  return 0;
 524:	4501                	li	a0,0
 526:	bfe5                	j	51e <memcmp+0x30>

0000000000000528 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 528:	1141                	add	sp,sp,-16
 52a:	e406                	sd	ra,8(sp)
 52c:	e022                	sd	s0,0(sp)
 52e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 530:	00000097          	auipc	ra,0x0
 534:	f66080e7          	jalr	-154(ra) # 496 <memmove>
}
 538:	60a2                	ld	ra,8(sp)
 53a:	6402                	ld	s0,0(sp)
 53c:	0141                	add	sp,sp,16
 53e:	8082                	ret

0000000000000540 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 540:	4885                	li	a7,1
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <exit>:
.global exit
exit:
 li a7, SYS_exit
 548:	4889                	li	a7,2
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <wait>:
.global wait
wait:
 li a7, SYS_wait
 550:	488d                	li	a7,3
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 558:	4891                	li	a7,4
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <read>:
.global read
read:
 li a7, SYS_read
 560:	4895                	li	a7,5
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <write>:
.global write
write:
 li a7, SYS_write
 568:	48c1                	li	a7,16
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <close>:
.global close
close:
 li a7, SYS_close
 570:	48d5                	li	a7,21
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <kill>:
.global kill
kill:
 li a7, SYS_kill
 578:	4899                	li	a7,6
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <exec>:
.global exec
exec:
 li a7, SYS_exec
 580:	489d                	li	a7,7
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <open>:
.global open
open:
 li a7, SYS_open
 588:	48bd                	li	a7,15
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 590:	48c5                	li	a7,17
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 598:	48c9                	li	a7,18
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5a0:	48a1                	li	a7,8
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <link>:
.global link
link:
 li a7, SYS_link
 5a8:	48cd                	li	a7,19
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5b0:	48d1                	li	a7,20
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b8:	48a5                	li	a7,9
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c0:	48a9                	li	a7,10
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c8:	48ad                	li	a7,11
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 5d0:	48b1                	li	a7,12
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 5d8:	48b5                	li	a7,13
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5e0:	48b9                	li	a7,14
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 5e8:	48d9                	li	a7,22
 ecall
 5ea:	00000073          	ecall
 ret
 5ee:	8082                	ret

00000000000005f0 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 5f0:	48dd                	li	a7,23
 ecall
 5f2:	00000073          	ecall
 ret
 5f6:	8082                	ret

00000000000005f8 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 5f8:	48e1                	li	a7,24
 ecall
 5fa:	00000073          	ecall
 ret
 5fe:	8082                	ret

0000000000000600 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 600:	48e5                	li	a7,25
 ecall
 602:	00000073          	ecall
 ret
 606:	8082                	ret

0000000000000608 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 608:	1101                	add	sp,sp,-32
 60a:	ec06                	sd	ra,24(sp)
 60c:	e822                	sd	s0,16(sp)
 60e:	1000                	add	s0,sp,32
 610:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 614:	4605                	li	a2,1
 616:	fef40593          	add	a1,s0,-17
 61a:	00000097          	auipc	ra,0x0
 61e:	f4e080e7          	jalr	-178(ra) # 568 <write>
}
 622:	60e2                	ld	ra,24(sp)
 624:	6442                	ld	s0,16(sp)
 626:	6105                	add	sp,sp,32
 628:	8082                	ret

000000000000062a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 62a:	7139                	add	sp,sp,-64
 62c:	fc06                	sd	ra,56(sp)
 62e:	f822                	sd	s0,48(sp)
 630:	f426                	sd	s1,40(sp)
 632:	0080                	add	s0,sp,64
 634:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 636:	c299                	beqz	a3,63c <printint+0x12>
 638:	0805cb63          	bltz	a1,6ce <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 63c:	2581                	sext.w	a1,a1
  neg = 0;
 63e:	4881                	li	a7,0
 640:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 644:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 646:	2601                	sext.w	a2,a2
 648:	00000517          	auipc	a0,0x0
 64c:	4e050513          	add	a0,a0,1248 # b28 <digits>
 650:	883a                	mv	a6,a4
 652:	2705                	addw	a4,a4,1
 654:	02c5f7bb          	remuw	a5,a1,a2
 658:	1782                	sll	a5,a5,0x20
 65a:	9381                	srl	a5,a5,0x20
 65c:	97aa                	add	a5,a5,a0
 65e:	0007c783          	lbu	a5,0(a5)
 662:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 666:	0005879b          	sext.w	a5,a1
 66a:	02c5d5bb          	divuw	a1,a1,a2
 66e:	0685                	add	a3,a3,1
 670:	fec7f0e3          	bgeu	a5,a2,650 <printint+0x26>
  if(neg)
 674:	00088c63          	beqz	a7,68c <printint+0x62>
    buf[i++] = '-';
 678:	fd070793          	add	a5,a4,-48
 67c:	00878733          	add	a4,a5,s0
 680:	02d00793          	li	a5,45
 684:	fef70823          	sb	a5,-16(a4)
 688:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 68c:	02e05c63          	blez	a4,6c4 <printint+0x9a>
 690:	f04a                	sd	s2,32(sp)
 692:	ec4e                	sd	s3,24(sp)
 694:	fc040793          	add	a5,s0,-64
 698:	00e78933          	add	s2,a5,a4
 69c:	fff78993          	add	s3,a5,-1
 6a0:	99ba                	add	s3,s3,a4
 6a2:	377d                	addw	a4,a4,-1
 6a4:	1702                	sll	a4,a4,0x20
 6a6:	9301                	srl	a4,a4,0x20
 6a8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6ac:	fff94583          	lbu	a1,-1(s2)
 6b0:	8526                	mv	a0,s1
 6b2:	00000097          	auipc	ra,0x0
 6b6:	f56080e7          	jalr	-170(ra) # 608 <putc>
  while(--i >= 0)
 6ba:	197d                	add	s2,s2,-1
 6bc:	ff3918e3          	bne	s2,s3,6ac <printint+0x82>
 6c0:	7902                	ld	s2,32(sp)
 6c2:	69e2                	ld	s3,24(sp)
}
 6c4:	70e2                	ld	ra,56(sp)
 6c6:	7442                	ld	s0,48(sp)
 6c8:	74a2                	ld	s1,40(sp)
 6ca:	6121                	add	sp,sp,64
 6cc:	8082                	ret
    x = -xx;
 6ce:	40b005bb          	negw	a1,a1
    neg = 1;
 6d2:	4885                	li	a7,1
    x = -xx;
 6d4:	b7b5                	j	640 <printint+0x16>

00000000000006d6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6d6:	715d                	add	sp,sp,-80
 6d8:	e486                	sd	ra,72(sp)
 6da:	e0a2                	sd	s0,64(sp)
 6dc:	f84a                	sd	s2,48(sp)
 6de:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6e0:	0005c903          	lbu	s2,0(a1)
 6e4:	1a090a63          	beqz	s2,898 <vprintf+0x1c2>
 6e8:	fc26                	sd	s1,56(sp)
 6ea:	f44e                	sd	s3,40(sp)
 6ec:	f052                	sd	s4,32(sp)
 6ee:	ec56                	sd	s5,24(sp)
 6f0:	e85a                	sd	s6,16(sp)
 6f2:	e45e                	sd	s7,8(sp)
 6f4:	8aaa                	mv	s5,a0
 6f6:	8bb2                	mv	s7,a2
 6f8:	00158493          	add	s1,a1,1
  state = 0;
 6fc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6fe:	02500a13          	li	s4,37
 702:	4b55                	li	s6,21
 704:	a839                	j	722 <vprintf+0x4c>
        putc(fd, c);
 706:	85ca                	mv	a1,s2
 708:	8556                	mv	a0,s5
 70a:	00000097          	auipc	ra,0x0
 70e:	efe080e7          	jalr	-258(ra) # 608 <putc>
 712:	a019                	j	718 <vprintf+0x42>
    } else if(state == '%'){
 714:	01498d63          	beq	s3,s4,72e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 718:	0485                	add	s1,s1,1
 71a:	fff4c903          	lbu	s2,-1(s1)
 71e:	16090763          	beqz	s2,88c <vprintf+0x1b6>
    if(state == 0){
 722:	fe0999e3          	bnez	s3,714 <vprintf+0x3e>
      if(c == '%'){
 726:	ff4910e3          	bne	s2,s4,706 <vprintf+0x30>
        state = '%';
 72a:	89d2                	mv	s3,s4
 72c:	b7f5                	j	718 <vprintf+0x42>
      if(c == 'd'){
 72e:	13490463          	beq	s2,s4,856 <vprintf+0x180>
 732:	f9d9079b          	addw	a5,s2,-99
 736:	0ff7f793          	zext.b	a5,a5
 73a:	12fb6763          	bltu	s6,a5,868 <vprintf+0x192>
 73e:	f9d9079b          	addw	a5,s2,-99
 742:	0ff7f713          	zext.b	a4,a5
 746:	12eb6163          	bltu	s6,a4,868 <vprintf+0x192>
 74a:	00271793          	sll	a5,a4,0x2
 74e:	00000717          	auipc	a4,0x0
 752:	38270713          	add	a4,a4,898 # ad0 <malloc+0x148>
 756:	97ba                	add	a5,a5,a4
 758:	439c                	lw	a5,0(a5)
 75a:	97ba                	add	a5,a5,a4
 75c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 75e:	008b8913          	add	s2,s7,8
 762:	4685                	li	a3,1
 764:	4629                	li	a2,10
 766:	000ba583          	lw	a1,0(s7)
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	ebe080e7          	jalr	-322(ra) # 62a <printint>
 774:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 776:	4981                	li	s3,0
 778:	b745                	j	718 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 77a:	008b8913          	add	s2,s7,8
 77e:	4681                	li	a3,0
 780:	4629                	li	a2,10
 782:	000ba583          	lw	a1,0(s7)
 786:	8556                	mv	a0,s5
 788:	00000097          	auipc	ra,0x0
 78c:	ea2080e7          	jalr	-350(ra) # 62a <printint>
 790:	8bca                	mv	s7,s2
      state = 0;
 792:	4981                	li	s3,0
 794:	b751                	j	718 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 796:	008b8913          	add	s2,s7,8
 79a:	4681                	li	a3,0
 79c:	4641                	li	a2,16
 79e:	000ba583          	lw	a1,0(s7)
 7a2:	8556                	mv	a0,s5
 7a4:	00000097          	auipc	ra,0x0
 7a8:	e86080e7          	jalr	-378(ra) # 62a <printint>
 7ac:	8bca                	mv	s7,s2
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	b7a5                	j	718 <vprintf+0x42>
 7b2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7b4:	008b8c13          	add	s8,s7,8
 7b8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7bc:	03000593          	li	a1,48
 7c0:	8556                	mv	a0,s5
 7c2:	00000097          	auipc	ra,0x0
 7c6:	e46080e7          	jalr	-442(ra) # 608 <putc>
  putc(fd, 'x');
 7ca:	07800593          	li	a1,120
 7ce:	8556                	mv	a0,s5
 7d0:	00000097          	auipc	ra,0x0
 7d4:	e38080e7          	jalr	-456(ra) # 608 <putc>
 7d8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7da:	00000b97          	auipc	s7,0x0
 7de:	34eb8b93          	add	s7,s7,846 # b28 <digits>
 7e2:	03c9d793          	srl	a5,s3,0x3c
 7e6:	97de                	add	a5,a5,s7
 7e8:	0007c583          	lbu	a1,0(a5)
 7ec:	8556                	mv	a0,s5
 7ee:	00000097          	auipc	ra,0x0
 7f2:	e1a080e7          	jalr	-486(ra) # 608 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f6:	0992                	sll	s3,s3,0x4
 7f8:	397d                	addw	s2,s2,-1
 7fa:	fe0914e3          	bnez	s2,7e2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 7fe:	8be2                	mv	s7,s8
      state = 0;
 800:	4981                	li	s3,0
 802:	6c02                	ld	s8,0(sp)
 804:	bf11                	j	718 <vprintf+0x42>
        s = va_arg(ap, char*);
 806:	008b8993          	add	s3,s7,8
 80a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 80e:	02090163          	beqz	s2,830 <vprintf+0x15a>
        while(*s != 0){
 812:	00094583          	lbu	a1,0(s2)
 816:	c9a5                	beqz	a1,886 <vprintf+0x1b0>
          putc(fd, *s);
 818:	8556                	mv	a0,s5
 81a:	00000097          	auipc	ra,0x0
 81e:	dee080e7          	jalr	-530(ra) # 608 <putc>
          s++;
 822:	0905                	add	s2,s2,1
        while(*s != 0){
 824:	00094583          	lbu	a1,0(s2)
 828:	f9e5                	bnez	a1,818 <vprintf+0x142>
        s = va_arg(ap, char*);
 82a:	8bce                	mv	s7,s3
      state = 0;
 82c:	4981                	li	s3,0
 82e:	b5ed                	j	718 <vprintf+0x42>
          s = "(null)";
 830:	00000917          	auipc	s2,0x0
 834:	29890913          	add	s2,s2,664 # ac8 <malloc+0x140>
        while(*s != 0){
 838:	02800593          	li	a1,40
 83c:	bff1                	j	818 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 83e:	008b8913          	add	s2,s7,8
 842:	000bc583          	lbu	a1,0(s7)
 846:	8556                	mv	a0,s5
 848:	00000097          	auipc	ra,0x0
 84c:	dc0080e7          	jalr	-576(ra) # 608 <putc>
 850:	8bca                	mv	s7,s2
      state = 0;
 852:	4981                	li	s3,0
 854:	b5d1                	j	718 <vprintf+0x42>
        putc(fd, c);
 856:	02500593          	li	a1,37
 85a:	8556                	mv	a0,s5
 85c:	00000097          	auipc	ra,0x0
 860:	dac080e7          	jalr	-596(ra) # 608 <putc>
      state = 0;
 864:	4981                	li	s3,0
 866:	bd4d                	j	718 <vprintf+0x42>
        putc(fd, '%');
 868:	02500593          	li	a1,37
 86c:	8556                	mv	a0,s5
 86e:	00000097          	auipc	ra,0x0
 872:	d9a080e7          	jalr	-614(ra) # 608 <putc>
        putc(fd, c);
 876:	85ca                	mv	a1,s2
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	d8e080e7          	jalr	-626(ra) # 608 <putc>
      state = 0;
 882:	4981                	li	s3,0
 884:	bd51                	j	718 <vprintf+0x42>
        s = va_arg(ap, char*);
 886:	8bce                	mv	s7,s3
      state = 0;
 888:	4981                	li	s3,0
 88a:	b579                	j	718 <vprintf+0x42>
 88c:	74e2                	ld	s1,56(sp)
 88e:	79a2                	ld	s3,40(sp)
 890:	7a02                	ld	s4,32(sp)
 892:	6ae2                	ld	s5,24(sp)
 894:	6b42                	ld	s6,16(sp)
 896:	6ba2                	ld	s7,8(sp)
    }
  }
}
 898:	60a6                	ld	ra,72(sp)
 89a:	6406                	ld	s0,64(sp)
 89c:	7942                	ld	s2,48(sp)
 89e:	6161                	add	sp,sp,80
 8a0:	8082                	ret

00000000000008a2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a2:	715d                	add	sp,sp,-80
 8a4:	ec06                	sd	ra,24(sp)
 8a6:	e822                	sd	s0,16(sp)
 8a8:	1000                	add	s0,sp,32
 8aa:	e010                	sd	a2,0(s0)
 8ac:	e414                	sd	a3,8(s0)
 8ae:	e818                	sd	a4,16(s0)
 8b0:	ec1c                	sd	a5,24(s0)
 8b2:	03043023          	sd	a6,32(s0)
 8b6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ba:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8be:	8622                	mv	a2,s0
 8c0:	00000097          	auipc	ra,0x0
 8c4:	e16080e7          	jalr	-490(ra) # 6d6 <vprintf>
}
 8c8:	60e2                	ld	ra,24(sp)
 8ca:	6442                	ld	s0,16(sp)
 8cc:	6161                	add	sp,sp,80
 8ce:	8082                	ret

00000000000008d0 <printf>:

void
printf(const char *fmt, ...)
{
 8d0:	711d                	add	sp,sp,-96
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	add	s0,sp,32
 8d8:	e40c                	sd	a1,8(s0)
 8da:	e810                	sd	a2,16(s0)
 8dc:	ec14                	sd	a3,24(s0)
 8de:	f018                	sd	a4,32(s0)
 8e0:	f41c                	sd	a5,40(s0)
 8e2:	03043823          	sd	a6,48(s0)
 8e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ea:	00840613          	add	a2,s0,8
 8ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f2:	85aa                	mv	a1,a0
 8f4:	4505                	li	a0,1
 8f6:	00000097          	auipc	ra,0x0
 8fa:	de0080e7          	jalr	-544(ra) # 6d6 <vprintf>
}
 8fe:	60e2                	ld	ra,24(sp)
 900:	6442                	ld	s0,16(sp)
 902:	6125                	add	sp,sp,96
 904:	8082                	ret

0000000000000906 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 906:	1141                	add	sp,sp,-16
 908:	e422                	sd	s0,8(sp)
 90a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 910:	00000797          	auipc	a5,0x0
 914:	6f07b783          	ld	a5,1776(a5) # 1000 <freep>
 918:	a02d                	j	942 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 91a:	4618                	lw	a4,8(a2)
 91c:	9f2d                	addw	a4,a4,a1
 91e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 922:	6398                	ld	a4,0(a5)
 924:	6310                	ld	a2,0(a4)
 926:	a83d                	j	964 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 928:	ff852703          	lw	a4,-8(a0)
 92c:	9f31                	addw	a4,a4,a2
 92e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 930:	ff053683          	ld	a3,-16(a0)
 934:	a091                	j	978 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 936:	6398                	ld	a4,0(a5)
 938:	00e7e463          	bltu	a5,a4,940 <free+0x3a>
 93c:	00e6ea63          	bltu	a3,a4,950 <free+0x4a>
{
 940:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 942:	fed7fae3          	bgeu	a5,a3,936 <free+0x30>
 946:	6398                	ld	a4,0(a5)
 948:	00e6e463          	bltu	a3,a4,950 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 94c:	fee7eae3          	bltu	a5,a4,940 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 950:	ff852583          	lw	a1,-8(a0)
 954:	6390                	ld	a2,0(a5)
 956:	02059813          	sll	a6,a1,0x20
 95a:	01c85713          	srl	a4,a6,0x1c
 95e:	9736                	add	a4,a4,a3
 960:	fae60de3          	beq	a2,a4,91a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 964:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 968:	4790                	lw	a2,8(a5)
 96a:	02061593          	sll	a1,a2,0x20
 96e:	01c5d713          	srl	a4,a1,0x1c
 972:	973e                	add	a4,a4,a5
 974:	fae68ae3          	beq	a3,a4,928 <free+0x22>
    p->s.ptr = bp->s.ptr;
 978:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 97a:	00000717          	auipc	a4,0x0
 97e:	68f73323          	sd	a5,1670(a4) # 1000 <freep>
}
 982:	6422                	ld	s0,8(sp)
 984:	0141                	add	sp,sp,16
 986:	8082                	ret

0000000000000988 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 988:	7139                	add	sp,sp,-64
 98a:	fc06                	sd	ra,56(sp)
 98c:	f822                	sd	s0,48(sp)
 98e:	f426                	sd	s1,40(sp)
 990:	ec4e                	sd	s3,24(sp)
 992:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 994:	02051493          	sll	s1,a0,0x20
 998:	9081                	srl	s1,s1,0x20
 99a:	04bd                	add	s1,s1,15
 99c:	8091                	srl	s1,s1,0x4
 99e:	0014899b          	addw	s3,s1,1
 9a2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9a4:	00000517          	auipc	a0,0x0
 9a8:	65c53503          	ld	a0,1628(a0) # 1000 <freep>
 9ac:	c915                	beqz	a0,9e0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9ae:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b0:	4798                	lw	a4,8(a5)
 9b2:	08977e63          	bgeu	a4,s1,a4e <malloc+0xc6>
 9b6:	f04a                	sd	s2,32(sp)
 9b8:	e852                	sd	s4,16(sp)
 9ba:	e456                	sd	s5,8(sp)
 9bc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9be:	8a4e                	mv	s4,s3
 9c0:	0009871b          	sext.w	a4,s3
 9c4:	6685                	lui	a3,0x1
 9c6:	00d77363          	bgeu	a4,a3,9cc <malloc+0x44>
 9ca:	6a05                	lui	s4,0x1
 9cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9d0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d4:	00000917          	auipc	s2,0x0
 9d8:	62c90913          	add	s2,s2,1580 # 1000 <freep>
  if(p == (char*)-1)
 9dc:	5afd                	li	s5,-1
 9de:	a091                	j	a22 <malloc+0x9a>
 9e0:	f04a                	sd	s2,32(sp)
 9e2:	e852                	sd	s4,16(sp)
 9e4:	e456                	sd	s5,8(sp)
 9e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e8:	00001797          	auipc	a5,0x1
 9ec:	a2878793          	add	a5,a5,-1496 # 1410 <base>
 9f0:	00000717          	auipc	a4,0x0
 9f4:	60f73823          	sd	a5,1552(a4) # 1000 <freep>
 9f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fe:	b7c1                	j	9be <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a00:	6398                	ld	a4,0(a5)
 a02:	e118                	sd	a4,0(a0)
 a04:	a08d                	j	a66 <malloc+0xde>
  hp->s.size = nu;
 a06:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a0a:	0541                	add	a0,a0,16
 a0c:	00000097          	auipc	ra,0x0
 a10:	efa080e7          	jalr	-262(ra) # 906 <free>
  return freep;
 a14:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a18:	c13d                	beqz	a0,a7e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a1a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a1c:	4798                	lw	a4,8(a5)
 a1e:	02977463          	bgeu	a4,s1,a46 <malloc+0xbe>
    if(p == freep)
 a22:	00093703          	ld	a4,0(s2)
 a26:	853e                	mv	a0,a5
 a28:	fef719e3          	bne	a4,a5,a1a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a2c:	8552                	mv	a0,s4
 a2e:	00000097          	auipc	ra,0x0
 a32:	ba2080e7          	jalr	-1118(ra) # 5d0 <sbrk>
  if(p == (char*)-1)
 a36:	fd5518e3          	bne	a0,s5,a06 <malloc+0x7e>
        return 0;
 a3a:	4501                	li	a0,0
 a3c:	7902                	ld	s2,32(sp)
 a3e:	6a42                	ld	s4,16(sp)
 a40:	6aa2                	ld	s5,8(sp)
 a42:	6b02                	ld	s6,0(sp)
 a44:	a03d                	j	a72 <malloc+0xea>
 a46:	7902                	ld	s2,32(sp)
 a48:	6a42                	ld	s4,16(sp)
 a4a:	6aa2                	ld	s5,8(sp)
 a4c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a4e:	fae489e3          	beq	s1,a4,a00 <malloc+0x78>
        p->s.size -= nunits;
 a52:	4137073b          	subw	a4,a4,s3
 a56:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a58:	02071693          	sll	a3,a4,0x20
 a5c:	01c6d713          	srl	a4,a3,0x1c
 a60:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a62:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a66:	00000717          	auipc	a4,0x0
 a6a:	58a73d23          	sd	a0,1434(a4) # 1000 <freep>
      return (void*)(p + 1);
 a6e:	01078513          	add	a0,a5,16
  }
}
 a72:	70e2                	ld	ra,56(sp)
 a74:	7442                	ld	s0,48(sp)
 a76:	74a2                	ld	s1,40(sp)
 a78:	69e2                	ld	s3,24(sp)
 a7a:	6121                	add	sp,sp,64
 a7c:	8082                	ret
 a7e:	7902                	ld	s2,32(sp)
 a80:	6a42                	ld	s4,16(sp)
 a82:	6aa2                	ld	s5,8(sp)
 a84:	6b02                	ld	s6,0(sp)
 a86:	b7f5                	j	a72 <malloc+0xea>
