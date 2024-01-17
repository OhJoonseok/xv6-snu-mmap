
user/_ls:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <fmtname>:
#include "user/user.h"
#include "kernel/fs.h"

char*
fmtname(char *path)
{
   0:	7179                	add	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	add	s0,sp,48
   a:	84aa                	mv	s1,a0
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   c:	00000097          	auipc	ra,0x0
  10:	332080e7          	jalr	818(ra) # 33e <strlen>
  14:	02051793          	sll	a5,a0,0x20
  18:	9381                	srl	a5,a5,0x20
  1a:	97a6                	add	a5,a5,s1
  1c:	02f00693          	li	a3,47
  20:	0097e963          	bltu	a5,s1,32 <fmtname+0x32>
  24:	0007c703          	lbu	a4,0(a5)
  28:	00d70563          	beq	a4,a3,32 <fmtname+0x32>
  2c:	17fd                	add	a5,a5,-1
  2e:	fe97fbe3          	bgeu	a5,s1,24 <fmtname+0x24>
    ;
  p++;
  32:	00178493          	add	s1,a5,1

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  36:	8526                	mv	a0,s1
  38:	00000097          	auipc	ra,0x0
  3c:	306080e7          	jalr	774(ra) # 33e <strlen>
  40:	2501                	sext.w	a0,a0
  42:	47b5                	li	a5,13
  44:	00a7f863          	bgeu	a5,a0,54 <fmtname+0x54>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  48:	8526                	mv	a0,s1
  4a:	70a2                	ld	ra,40(sp)
  4c:	7402                	ld	s0,32(sp)
  4e:	64e2                	ld	s1,24(sp)
  50:	6145                	add	sp,sp,48
  52:	8082                	ret
  54:	e84a                	sd	s2,16(sp)
  56:	e44e                	sd	s3,8(sp)
  memmove(buf, p, strlen(p));
  58:	8526                	mv	a0,s1
  5a:	00000097          	auipc	ra,0x0
  5e:	2e4080e7          	jalr	740(ra) # 33e <strlen>
  62:	00001997          	auipc	s3,0x1
  66:	fae98993          	add	s3,s3,-82 # 1010 <buf.0>
  6a:	0005061b          	sext.w	a2,a0
  6e:	85a6                	mv	a1,s1
  70:	854e                	mv	a0,s3
  72:	00000097          	auipc	ra,0x0
  76:	456080e7          	jalr	1110(ra) # 4c8 <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  7a:	8526                	mv	a0,s1
  7c:	00000097          	auipc	ra,0x0
  80:	2c2080e7          	jalr	706(ra) # 33e <strlen>
  84:	0005091b          	sext.w	s2,a0
  88:	8526                	mv	a0,s1
  8a:	00000097          	auipc	ra,0x0
  8e:	2b4080e7          	jalr	692(ra) # 33e <strlen>
  92:	1902                	sll	s2,s2,0x20
  94:	02095913          	srl	s2,s2,0x20
  98:	4639                	li	a2,14
  9a:	9e09                	subw	a2,a2,a0
  9c:	02000593          	li	a1,32
  a0:	01298533          	add	a0,s3,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	2c4080e7          	jalr	708(ra) # 368 <memset>
  return buf;
  ac:	84ce                	mv	s1,s3
  ae:	6942                	ld	s2,16(sp)
  b0:	69a2                	ld	s3,8(sp)
  b2:	bf59                	j	48 <fmtname+0x48>

00000000000000b4 <ls>:

void
ls(char *path)
{
  b4:	d9010113          	add	sp,sp,-624
  b8:	26113423          	sd	ra,616(sp)
  bc:	26813023          	sd	s0,608(sp)
  c0:	25213823          	sd	s2,592(sp)
  c4:	1c80                	add	s0,sp,624
  c6:	892a                	mv	s2,a0
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  c8:	4581                	li	a1,0
  ca:	00000097          	auipc	ra,0x0
  ce:	4f0080e7          	jalr	1264(ra) # 5ba <open>
  d2:	06054b63          	bltz	a0,148 <ls+0x94>
  d6:	24913c23          	sd	s1,600(sp)
  da:	84aa                	mv	s1,a0
    fprintf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  dc:	d9840593          	add	a1,s0,-616
  e0:	00000097          	auipc	ra,0x0
  e4:	4f2080e7          	jalr	1266(ra) # 5d2 <fstat>
  e8:	06054b63          	bltz	a0,15e <ls+0xaa>
    fprintf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ec:	da041783          	lh	a5,-608(s0)
  f0:	4705                	li	a4,1
  f2:	08e78863          	beq	a5,a4,182 <ls+0xce>
  f6:	37f9                	addw	a5,a5,-2
  f8:	17c2                	sll	a5,a5,0x30
  fa:	93c1                	srl	a5,a5,0x30
  fc:	02f76663          	bltu	a4,a5,128 <ls+0x74>
  case T_DEVICE:
  case T_FILE:
    printf("%s %d %d %l\n", fmtname(path), st.type, st.ino, st.size);
 100:	854a                	mv	a0,s2
 102:	00000097          	auipc	ra,0x0
 106:	efe080e7          	jalr	-258(ra) # 0 <fmtname>
 10a:	85aa                	mv	a1,a0
 10c:	da843703          	ld	a4,-600(s0)
 110:	d9c42683          	lw	a3,-612(s0)
 114:	da041603          	lh	a2,-608(s0)
 118:	00001517          	auipc	a0,0x1
 11c:	9d850513          	add	a0,a0,-1576 # af0 <malloc+0x136>
 120:	00000097          	auipc	ra,0x0
 124:	7e2080e7          	jalr	2018(ra) # 902 <printf>
      }
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 128:	8526                	mv	a0,s1
 12a:	00000097          	auipc	ra,0x0
 12e:	478080e7          	jalr	1144(ra) # 5a2 <close>
 132:	25813483          	ld	s1,600(sp)
}
 136:	26813083          	ld	ra,616(sp)
 13a:	26013403          	ld	s0,608(sp)
 13e:	25013903          	ld	s2,592(sp)
 142:	27010113          	add	sp,sp,624
 146:	8082                	ret
    fprintf(2, "ls: cannot open %s\n", path);
 148:	864a                	mv	a2,s2
 14a:	00001597          	auipc	a1,0x1
 14e:	97658593          	add	a1,a1,-1674 # ac0 <malloc+0x106>
 152:	4509                	li	a0,2
 154:	00000097          	auipc	ra,0x0
 158:	780080e7          	jalr	1920(ra) # 8d4 <fprintf>
    return;
 15c:	bfe9                	j	136 <ls+0x82>
    fprintf(2, "ls: cannot stat %s\n", path);
 15e:	864a                	mv	a2,s2
 160:	00001597          	auipc	a1,0x1
 164:	97858593          	add	a1,a1,-1672 # ad8 <malloc+0x11e>
 168:	4509                	li	a0,2
 16a:	00000097          	auipc	ra,0x0
 16e:	76a080e7          	jalr	1898(ra) # 8d4 <fprintf>
    close(fd);
 172:	8526                	mv	a0,s1
 174:	00000097          	auipc	ra,0x0
 178:	42e080e7          	jalr	1070(ra) # 5a2 <close>
    return;
 17c:	25813483          	ld	s1,600(sp)
 180:	bf5d                	j	136 <ls+0x82>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 182:	854a                	mv	a0,s2
 184:	00000097          	auipc	ra,0x0
 188:	1ba080e7          	jalr	442(ra) # 33e <strlen>
 18c:	2541                	addw	a0,a0,16
 18e:	20000793          	li	a5,512
 192:	00a7fb63          	bgeu	a5,a0,1a8 <ls+0xf4>
      printf("ls: path too long\n");
 196:	00001517          	auipc	a0,0x1
 19a:	96a50513          	add	a0,a0,-1686 # b00 <malloc+0x146>
 19e:	00000097          	auipc	ra,0x0
 1a2:	764080e7          	jalr	1892(ra) # 902 <printf>
      break;
 1a6:	b749                	j	128 <ls+0x74>
 1a8:	25313423          	sd	s3,584(sp)
 1ac:	25413023          	sd	s4,576(sp)
 1b0:	23513c23          	sd	s5,568(sp)
    strcpy(buf, path);
 1b4:	85ca                	mv	a1,s2
 1b6:	dc040513          	add	a0,s0,-576
 1ba:	00000097          	auipc	ra,0x0
 1be:	13c080e7          	jalr	316(ra) # 2f6 <strcpy>
    p = buf+strlen(buf);
 1c2:	dc040513          	add	a0,s0,-576
 1c6:	00000097          	auipc	ra,0x0
 1ca:	178080e7          	jalr	376(ra) # 33e <strlen>
 1ce:	1502                	sll	a0,a0,0x20
 1d0:	9101                	srl	a0,a0,0x20
 1d2:	dc040793          	add	a5,s0,-576
 1d6:	00a78933          	add	s2,a5,a0
    *p++ = '/';
 1da:	00190993          	add	s3,s2,1
 1de:	02f00793          	li	a5,47
 1e2:	00f90023          	sb	a5,0(s2)
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 1e6:	00001a17          	auipc	s4,0x1
 1ea:	932a0a13          	add	s4,s4,-1742 # b18 <malloc+0x15e>
        printf("ls: cannot stat %s\n", buf);
 1ee:	00001a97          	auipc	s5,0x1
 1f2:	8eaa8a93          	add	s5,s5,-1814 # ad8 <malloc+0x11e>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f6:	a801                	j	206 <ls+0x152>
        printf("ls: cannot stat %s\n", buf);
 1f8:	dc040593          	add	a1,s0,-576
 1fc:	8556                	mv	a0,s5
 1fe:	00000097          	auipc	ra,0x0
 202:	704080e7          	jalr	1796(ra) # 902 <printf>
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 206:	4641                	li	a2,16
 208:	db040593          	add	a1,s0,-592
 20c:	8526                	mv	a0,s1
 20e:	00000097          	auipc	ra,0x0
 212:	384080e7          	jalr	900(ra) # 592 <read>
 216:	47c1                	li	a5,16
 218:	04f51c63          	bne	a0,a5,270 <ls+0x1bc>
      if(de.inum == 0)
 21c:	db045783          	lhu	a5,-592(s0)
 220:	d3fd                	beqz	a5,206 <ls+0x152>
      memmove(p, de.name, DIRSIZ);
 222:	4639                	li	a2,14
 224:	db240593          	add	a1,s0,-590
 228:	854e                	mv	a0,s3
 22a:	00000097          	auipc	ra,0x0
 22e:	29e080e7          	jalr	670(ra) # 4c8 <memmove>
      p[DIRSIZ] = 0;
 232:	000907a3          	sb	zero,15(s2)
      if(stat(buf, &st) < 0){
 236:	d9840593          	add	a1,s0,-616
 23a:	dc040513          	add	a0,s0,-576
 23e:	00000097          	auipc	ra,0x0
 242:	1e4080e7          	jalr	484(ra) # 422 <stat>
 246:	fa0549e3          	bltz	a0,1f8 <ls+0x144>
      printf("%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 24a:	dc040513          	add	a0,s0,-576
 24e:	00000097          	auipc	ra,0x0
 252:	db2080e7          	jalr	-590(ra) # 0 <fmtname>
 256:	85aa                	mv	a1,a0
 258:	da843703          	ld	a4,-600(s0)
 25c:	d9c42683          	lw	a3,-612(s0)
 260:	da041603          	lh	a2,-608(s0)
 264:	8552                	mv	a0,s4
 266:	00000097          	auipc	ra,0x0
 26a:	69c080e7          	jalr	1692(ra) # 902 <printf>
 26e:	bf61                	j	206 <ls+0x152>
 270:	24813983          	ld	s3,584(sp)
 274:	24013a03          	ld	s4,576(sp)
 278:	23813a83          	ld	s5,568(sp)
 27c:	b575                	j	128 <ls+0x74>

000000000000027e <main>:

int
main(int argc, char *argv[])
{
 27e:	1101                	add	sp,sp,-32
 280:	ec06                	sd	ra,24(sp)
 282:	e822                	sd	s0,16(sp)
 284:	1000                	add	s0,sp,32
  int i;

  if(argc < 2){
 286:	4785                	li	a5,1
 288:	02a7db63          	bge	a5,a0,2be <main+0x40>
 28c:	e426                	sd	s1,8(sp)
 28e:	e04a                	sd	s2,0(sp)
 290:	00858493          	add	s1,a1,8
 294:	ffe5091b          	addw	s2,a0,-2
 298:	02091793          	sll	a5,s2,0x20
 29c:	01d7d913          	srl	s2,a5,0x1d
 2a0:	05c1                	add	a1,a1,16
 2a2:	992e                	add	s2,s2,a1
    ls(".");
    exit(0);
  }
  for(i=1; i<argc; i++)
    ls(argv[i]);
 2a4:	6088                	ld	a0,0(s1)
 2a6:	00000097          	auipc	ra,0x0
 2aa:	e0e080e7          	jalr	-498(ra) # b4 <ls>
  for(i=1; i<argc; i++)
 2ae:	04a1                	add	s1,s1,8
 2b0:	ff249ae3          	bne	s1,s2,2a4 <main+0x26>
  exit(0);
 2b4:	4501                	li	a0,0
 2b6:	00000097          	auipc	ra,0x0
 2ba:	2c4080e7          	jalr	708(ra) # 57a <exit>
 2be:	e426                	sd	s1,8(sp)
 2c0:	e04a                	sd	s2,0(sp)
    ls(".");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	86650513          	add	a0,a0,-1946 # b28 <malloc+0x16e>
 2ca:	00000097          	auipc	ra,0x0
 2ce:	dea080e7          	jalr	-534(ra) # b4 <ls>
    exit(0);
 2d2:	4501                	li	a0,0
 2d4:	00000097          	auipc	ra,0x0
 2d8:	2a6080e7          	jalr	678(ra) # 57a <exit>

00000000000002dc <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
 2dc:	1141                	add	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	add	s0,sp,16
  extern int main();
  main();
 2e4:	00000097          	auipc	ra,0x0
 2e8:	f9a080e7          	jalr	-102(ra) # 27e <main>
  exit(0);
 2ec:	4501                	li	a0,0
 2ee:	00000097          	auipc	ra,0x0
 2f2:	28c080e7          	jalr	652(ra) # 57a <exit>

00000000000002f6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2f6:	1141                	add	sp,sp,-16
 2f8:	e422                	sd	s0,8(sp)
 2fa:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2fc:	87aa                	mv	a5,a0
 2fe:	0585                	add	a1,a1,1
 300:	0785                	add	a5,a5,1
 302:	fff5c703          	lbu	a4,-1(a1)
 306:	fee78fa3          	sb	a4,-1(a5)
 30a:	fb75                	bnez	a4,2fe <strcpy+0x8>
    ;
  return os;
}
 30c:	6422                	ld	s0,8(sp)
 30e:	0141                	add	sp,sp,16
 310:	8082                	ret

0000000000000312 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 312:	1141                	add	sp,sp,-16
 314:	e422                	sd	s0,8(sp)
 316:	0800                	add	s0,sp,16
  while(*p && *p == *q)
 318:	00054783          	lbu	a5,0(a0)
 31c:	cb91                	beqz	a5,330 <strcmp+0x1e>
 31e:	0005c703          	lbu	a4,0(a1)
 322:	00f71763          	bne	a4,a5,330 <strcmp+0x1e>
    p++, q++;
 326:	0505                	add	a0,a0,1
 328:	0585                	add	a1,a1,1
  while(*p && *p == *q)
 32a:	00054783          	lbu	a5,0(a0)
 32e:	fbe5                	bnez	a5,31e <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 330:	0005c503          	lbu	a0,0(a1)
}
 334:	40a7853b          	subw	a0,a5,a0
 338:	6422                	ld	s0,8(sp)
 33a:	0141                	add	sp,sp,16
 33c:	8082                	ret

000000000000033e <strlen>:

uint
strlen(const char *s)
{
 33e:	1141                	add	sp,sp,-16
 340:	e422                	sd	s0,8(sp)
 342:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 344:	00054783          	lbu	a5,0(a0)
 348:	cf91                	beqz	a5,364 <strlen+0x26>
 34a:	0505                	add	a0,a0,1
 34c:	87aa                	mv	a5,a0
 34e:	86be                	mv	a3,a5
 350:	0785                	add	a5,a5,1
 352:	fff7c703          	lbu	a4,-1(a5)
 356:	ff65                	bnez	a4,34e <strlen+0x10>
 358:	40a6853b          	subw	a0,a3,a0
 35c:	2505                	addw	a0,a0,1
    ;
  return n;
}
 35e:	6422                	ld	s0,8(sp)
 360:	0141                	add	sp,sp,16
 362:	8082                	ret
  for(n = 0; s[n]; n++)
 364:	4501                	li	a0,0
 366:	bfe5                	j	35e <strlen+0x20>

0000000000000368 <memset>:

void*
memset(void *dst, int c, uint n)
{
 368:	1141                	add	sp,sp,-16
 36a:	e422                	sd	s0,8(sp)
 36c:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 36e:	ca19                	beqz	a2,384 <memset+0x1c>
 370:	87aa                	mv	a5,a0
 372:	1602                	sll	a2,a2,0x20
 374:	9201                	srl	a2,a2,0x20
 376:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 37a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 37e:	0785                	add	a5,a5,1
 380:	fee79de3          	bne	a5,a4,37a <memset+0x12>
  }
  return dst;
}
 384:	6422                	ld	s0,8(sp)
 386:	0141                	add	sp,sp,16
 388:	8082                	ret

000000000000038a <strchr>:

char*
strchr(const char *s, char c)
{
 38a:	1141                	add	sp,sp,-16
 38c:	e422                	sd	s0,8(sp)
 38e:	0800                	add	s0,sp,16
  for(; *s; s++)
 390:	00054783          	lbu	a5,0(a0)
 394:	cb99                	beqz	a5,3aa <strchr+0x20>
    if(*s == c)
 396:	00f58763          	beq	a1,a5,3a4 <strchr+0x1a>
  for(; *s; s++)
 39a:	0505                	add	a0,a0,1
 39c:	00054783          	lbu	a5,0(a0)
 3a0:	fbfd                	bnez	a5,396 <strchr+0xc>
      return (char*)s;
  return 0;
 3a2:	4501                	li	a0,0
}
 3a4:	6422                	ld	s0,8(sp)
 3a6:	0141                	add	sp,sp,16
 3a8:	8082                	ret
  return 0;
 3aa:	4501                	li	a0,0
 3ac:	bfe5                	j	3a4 <strchr+0x1a>

00000000000003ae <gets>:

char*
gets(char *buf, int max)
{
 3ae:	711d                	add	sp,sp,-96
 3b0:	ec86                	sd	ra,88(sp)
 3b2:	e8a2                	sd	s0,80(sp)
 3b4:	e4a6                	sd	s1,72(sp)
 3b6:	e0ca                	sd	s2,64(sp)
 3b8:	fc4e                	sd	s3,56(sp)
 3ba:	f852                	sd	s4,48(sp)
 3bc:	f456                	sd	s5,40(sp)
 3be:	f05a                	sd	s6,32(sp)
 3c0:	ec5e                	sd	s7,24(sp)
 3c2:	1080                	add	s0,sp,96
 3c4:	8baa                	mv	s7,a0
 3c6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3c8:	892a                	mv	s2,a0
 3ca:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 3cc:	4aa9                	li	s5,10
 3ce:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 3d0:	89a6                	mv	s3,s1
 3d2:	2485                	addw	s1,s1,1
 3d4:	0344d863          	bge	s1,s4,404 <gets+0x56>
    cc = read(0, &c, 1);
 3d8:	4605                	li	a2,1
 3da:	faf40593          	add	a1,s0,-81
 3de:	4501                	li	a0,0
 3e0:	00000097          	auipc	ra,0x0
 3e4:	1b2080e7          	jalr	434(ra) # 592 <read>
    if(cc < 1)
 3e8:	00a05e63          	blez	a0,404 <gets+0x56>
    buf[i++] = c;
 3ec:	faf44783          	lbu	a5,-81(s0)
 3f0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3f4:	01578763          	beq	a5,s5,402 <gets+0x54>
 3f8:	0905                	add	s2,s2,1
 3fa:	fd679be3          	bne	a5,s6,3d0 <gets+0x22>
    buf[i++] = c;
 3fe:	89a6                	mv	s3,s1
 400:	a011                	j	404 <gets+0x56>
 402:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 404:	99de                	add	s3,s3,s7
 406:	00098023          	sb	zero,0(s3)
  return buf;
}
 40a:	855e                	mv	a0,s7
 40c:	60e6                	ld	ra,88(sp)
 40e:	6446                	ld	s0,80(sp)
 410:	64a6                	ld	s1,72(sp)
 412:	6906                	ld	s2,64(sp)
 414:	79e2                	ld	s3,56(sp)
 416:	7a42                	ld	s4,48(sp)
 418:	7aa2                	ld	s5,40(sp)
 41a:	7b02                	ld	s6,32(sp)
 41c:	6be2                	ld	s7,24(sp)
 41e:	6125                	add	sp,sp,96
 420:	8082                	ret

0000000000000422 <stat>:

int
stat(const char *n, struct stat *st)
{
 422:	1101                	add	sp,sp,-32
 424:	ec06                	sd	ra,24(sp)
 426:	e822                	sd	s0,16(sp)
 428:	e04a                	sd	s2,0(sp)
 42a:	1000                	add	s0,sp,32
 42c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 42e:	4581                	li	a1,0
 430:	00000097          	auipc	ra,0x0
 434:	18a080e7          	jalr	394(ra) # 5ba <open>
  if(fd < 0)
 438:	02054663          	bltz	a0,464 <stat+0x42>
 43c:	e426                	sd	s1,8(sp)
 43e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 440:	85ca                	mv	a1,s2
 442:	00000097          	auipc	ra,0x0
 446:	190080e7          	jalr	400(ra) # 5d2 <fstat>
 44a:	892a                	mv	s2,a0
  close(fd);
 44c:	8526                	mv	a0,s1
 44e:	00000097          	auipc	ra,0x0
 452:	154080e7          	jalr	340(ra) # 5a2 <close>
  return r;
 456:	64a2                	ld	s1,8(sp)
}
 458:	854a                	mv	a0,s2
 45a:	60e2                	ld	ra,24(sp)
 45c:	6442                	ld	s0,16(sp)
 45e:	6902                	ld	s2,0(sp)
 460:	6105                	add	sp,sp,32
 462:	8082                	ret
    return -1;
 464:	597d                	li	s2,-1
 466:	bfcd                	j	458 <stat+0x36>

0000000000000468 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
 468:	1141                	add	sp,sp,-16
 46a:	e422                	sd	s0,8(sp)
 46c:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
 46e:	00054703          	lbu	a4,0(a0)
 472:	02d00793          	li	a5,45
 476:	4585                	li	a1,1
 478:	04f70363          	beq	a4,a5,4be <atoi+0x56>

  while('0' <= *s && *s <= '9')
 47c:	00054703          	lbu	a4,0(a0)
 480:	fd07079b          	addw	a5,a4,-48
 484:	0ff7f793          	zext.b	a5,a5
 488:	46a5                	li	a3,9
 48a:	02f6ed63          	bltu	a3,a5,4c4 <atoi+0x5c>
  int n = 0;
 48e:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
 490:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
 492:	0505                	add	a0,a0,1
 494:	0026979b          	sllw	a5,a3,0x2
 498:	9fb5                	addw	a5,a5,a3
 49a:	0017979b          	sllw	a5,a5,0x1
 49e:	9fb9                	addw	a5,a5,a4
 4a0:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
 4a4:	00054703          	lbu	a4,0(a0)
 4a8:	fd07079b          	addw	a5,a4,-48
 4ac:	0ff7f793          	zext.b	a5,a5
 4b0:	fef671e3          	bgeu	a2,a5,492 <atoi+0x2a>
  return sign * n;
}
 4b4:	02d5853b          	mulw	a0,a1,a3
 4b8:	6422                	ld	s0,8(sp)
 4ba:	0141                	add	sp,sp,16
 4bc:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
 4be:	0505                	add	a0,a0,1
 4c0:	55fd                	li	a1,-1
 4c2:	bf6d                	j	47c <atoi+0x14>
  int n = 0;
 4c4:	4681                	li	a3,0
 4c6:	b7fd                	j	4b4 <atoi+0x4c>

00000000000004c8 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4c8:	1141                	add	sp,sp,-16
 4ca:	e422                	sd	s0,8(sp)
 4cc:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 4ce:	02b57463          	bgeu	a0,a1,4f6 <memmove+0x2e>
    while(n-- > 0)
 4d2:	00c05f63          	blez	a2,4f0 <memmove+0x28>
 4d6:	1602                	sll	a2,a2,0x20
 4d8:	9201                	srl	a2,a2,0x20
 4da:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4de:	872a                	mv	a4,a0
      *dst++ = *src++;
 4e0:	0585                	add	a1,a1,1
 4e2:	0705                	add	a4,a4,1
 4e4:	fff5c683          	lbu	a3,-1(a1)
 4e8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4ec:	fef71ae3          	bne	a4,a5,4e0 <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4f0:	6422                	ld	s0,8(sp)
 4f2:	0141                	add	sp,sp,16
 4f4:	8082                	ret
    dst += n;
 4f6:	00c50733          	add	a4,a0,a2
    src += n;
 4fa:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 4fc:	fec05ae3          	blez	a2,4f0 <memmove+0x28>
 500:	fff6079b          	addw	a5,a2,-1
 504:	1782                	sll	a5,a5,0x20
 506:	9381                	srl	a5,a5,0x20
 508:	fff7c793          	not	a5,a5
 50c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 50e:	15fd                	add	a1,a1,-1
 510:	177d                	add	a4,a4,-1
 512:	0005c683          	lbu	a3,0(a1)
 516:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 51a:	fee79ae3          	bne	a5,a4,50e <memmove+0x46>
 51e:	bfc9                	j	4f0 <memmove+0x28>

0000000000000520 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 520:	1141                	add	sp,sp,-16
 522:	e422                	sd	s0,8(sp)
 524:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 526:	ca05                	beqz	a2,556 <memcmp+0x36>
 528:	fff6069b          	addw	a3,a2,-1
 52c:	1682                	sll	a3,a3,0x20
 52e:	9281                	srl	a3,a3,0x20
 530:	0685                	add	a3,a3,1
 532:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 534:	00054783          	lbu	a5,0(a0)
 538:	0005c703          	lbu	a4,0(a1)
 53c:	00e79863          	bne	a5,a4,54c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 540:	0505                	add	a0,a0,1
    p2++;
 542:	0585                	add	a1,a1,1
  while (n-- > 0) {
 544:	fed518e3          	bne	a0,a3,534 <memcmp+0x14>
  }
  return 0;
 548:	4501                	li	a0,0
 54a:	a019                	j	550 <memcmp+0x30>
      return *p1 - *p2;
 54c:	40e7853b          	subw	a0,a5,a4
}
 550:	6422                	ld	s0,8(sp)
 552:	0141                	add	sp,sp,16
 554:	8082                	ret
  return 0;
 556:	4501                	li	a0,0
 558:	bfe5                	j	550 <memcmp+0x30>

000000000000055a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 55a:	1141                	add	sp,sp,-16
 55c:	e406                	sd	ra,8(sp)
 55e:	e022                	sd	s0,0(sp)
 560:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
 562:	00000097          	auipc	ra,0x0
 566:	f66080e7          	jalr	-154(ra) # 4c8 <memmove>
}
 56a:	60a2                	ld	ra,8(sp)
 56c:	6402                	ld	s0,0(sp)
 56e:	0141                	add	sp,sp,16
 570:	8082                	ret

0000000000000572 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 572:	4885                	li	a7,1
 ecall
 574:	00000073          	ecall
 ret
 578:	8082                	ret

000000000000057a <exit>:
.global exit
exit:
 li a7, SYS_exit
 57a:	4889                	li	a7,2
 ecall
 57c:	00000073          	ecall
 ret
 580:	8082                	ret

0000000000000582 <wait>:
.global wait
wait:
 li a7, SYS_wait
 582:	488d                	li	a7,3
 ecall
 584:	00000073          	ecall
 ret
 588:	8082                	ret

000000000000058a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 58a:	4891                	li	a7,4
 ecall
 58c:	00000073          	ecall
 ret
 590:	8082                	ret

0000000000000592 <read>:
.global read
read:
 li a7, SYS_read
 592:	4895                	li	a7,5
 ecall
 594:	00000073          	ecall
 ret
 598:	8082                	ret

000000000000059a <write>:
.global write
write:
 li a7, SYS_write
 59a:	48c1                	li	a7,16
 ecall
 59c:	00000073          	ecall
 ret
 5a0:	8082                	ret

00000000000005a2 <close>:
.global close
close:
 li a7, SYS_close
 5a2:	48d5                	li	a7,21
 ecall
 5a4:	00000073          	ecall
 ret
 5a8:	8082                	ret

00000000000005aa <kill>:
.global kill
kill:
 li a7, SYS_kill
 5aa:	4899                	li	a7,6
 ecall
 5ac:	00000073          	ecall
 ret
 5b0:	8082                	ret

00000000000005b2 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5b2:	489d                	li	a7,7
 ecall
 5b4:	00000073          	ecall
 ret
 5b8:	8082                	ret

00000000000005ba <open>:
.global open
open:
 li a7, SYS_open
 5ba:	48bd                	li	a7,15
 ecall
 5bc:	00000073          	ecall
 ret
 5c0:	8082                	ret

00000000000005c2 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5c2:	48c5                	li	a7,17
 ecall
 5c4:	00000073          	ecall
 ret
 5c8:	8082                	ret

00000000000005ca <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5ca:	48c9                	li	a7,18
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5d2:	48a1                	li	a7,8
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <link>:
.global link
link:
 li a7, SYS_link
 5da:	48cd                	li	a7,19
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5e2:	48d1                	li	a7,20
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5ea:	48a5                	li	a7,9
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5f2:	48a9                	li	a7,10
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5fa:	48ad                	li	a7,11
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 602:	48b1                	li	a7,12
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 60a:	48b5                	li	a7,13
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 612:	48b9                	li	a7,14
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
 61a:	48d9                	li	a7,22
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
 622:	48dd                	li	a7,23
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
 62a:	48e1                	li	a7,24
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
 632:	48e5                	li	a7,25
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 63a:	1101                	add	sp,sp,-32
 63c:	ec06                	sd	ra,24(sp)
 63e:	e822                	sd	s0,16(sp)
 640:	1000                	add	s0,sp,32
 642:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 646:	4605                	li	a2,1
 648:	fef40593          	add	a1,s0,-17
 64c:	00000097          	auipc	ra,0x0
 650:	f4e080e7          	jalr	-178(ra) # 59a <write>
}
 654:	60e2                	ld	ra,24(sp)
 656:	6442                	ld	s0,16(sp)
 658:	6105                	add	sp,sp,32
 65a:	8082                	ret

000000000000065c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 65c:	7139                	add	sp,sp,-64
 65e:	fc06                	sd	ra,56(sp)
 660:	f822                	sd	s0,48(sp)
 662:	f426                	sd	s1,40(sp)
 664:	0080                	add	s0,sp,64
 666:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 668:	c299                	beqz	a3,66e <printint+0x12>
 66a:	0805cb63          	bltz	a1,700 <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 66e:	2581                	sext.w	a1,a1
  neg = 0;
 670:	4881                	li	a7,0
 672:	fc040693          	add	a3,s0,-64
  }

  i = 0;
 676:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 678:	2601                	sext.w	a2,a2
 67a:	00000517          	auipc	a0,0x0
 67e:	51650513          	add	a0,a0,1302 # b90 <digits>
 682:	883a                	mv	a6,a4
 684:	2705                	addw	a4,a4,1
 686:	02c5f7bb          	remuw	a5,a1,a2
 68a:	1782                	sll	a5,a5,0x20
 68c:	9381                	srl	a5,a5,0x20
 68e:	97aa                	add	a5,a5,a0
 690:	0007c783          	lbu	a5,0(a5)
 694:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 698:	0005879b          	sext.w	a5,a1
 69c:	02c5d5bb          	divuw	a1,a1,a2
 6a0:	0685                	add	a3,a3,1
 6a2:	fec7f0e3          	bgeu	a5,a2,682 <printint+0x26>
  if(neg)
 6a6:	00088c63          	beqz	a7,6be <printint+0x62>
    buf[i++] = '-';
 6aa:	fd070793          	add	a5,a4,-48
 6ae:	00878733          	add	a4,a5,s0
 6b2:	02d00793          	li	a5,45
 6b6:	fef70823          	sb	a5,-16(a4)
 6ba:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
 6be:	02e05c63          	blez	a4,6f6 <printint+0x9a>
 6c2:	f04a                	sd	s2,32(sp)
 6c4:	ec4e                	sd	s3,24(sp)
 6c6:	fc040793          	add	a5,s0,-64
 6ca:	00e78933          	add	s2,a5,a4
 6ce:	fff78993          	add	s3,a5,-1
 6d2:	99ba                	add	s3,s3,a4
 6d4:	377d                	addw	a4,a4,-1
 6d6:	1702                	sll	a4,a4,0x20
 6d8:	9301                	srl	a4,a4,0x20
 6da:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6de:	fff94583          	lbu	a1,-1(s2)
 6e2:	8526                	mv	a0,s1
 6e4:	00000097          	auipc	ra,0x0
 6e8:	f56080e7          	jalr	-170(ra) # 63a <putc>
  while(--i >= 0)
 6ec:	197d                	add	s2,s2,-1
 6ee:	ff3918e3          	bne	s2,s3,6de <printint+0x82>
 6f2:	7902                	ld	s2,32(sp)
 6f4:	69e2                	ld	s3,24(sp)
}
 6f6:	70e2                	ld	ra,56(sp)
 6f8:	7442                	ld	s0,48(sp)
 6fa:	74a2                	ld	s1,40(sp)
 6fc:	6121                	add	sp,sp,64
 6fe:	8082                	ret
    x = -xx;
 700:	40b005bb          	negw	a1,a1
    neg = 1;
 704:	4885                	li	a7,1
    x = -xx;
 706:	b7b5                	j	672 <printint+0x16>

0000000000000708 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 708:	715d                	add	sp,sp,-80
 70a:	e486                	sd	ra,72(sp)
 70c:	e0a2                	sd	s0,64(sp)
 70e:	f84a                	sd	s2,48(sp)
 710:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 712:	0005c903          	lbu	s2,0(a1)
 716:	1a090a63          	beqz	s2,8ca <vprintf+0x1c2>
 71a:	fc26                	sd	s1,56(sp)
 71c:	f44e                	sd	s3,40(sp)
 71e:	f052                	sd	s4,32(sp)
 720:	ec56                	sd	s5,24(sp)
 722:	e85a                	sd	s6,16(sp)
 724:	e45e                	sd	s7,8(sp)
 726:	8aaa                	mv	s5,a0
 728:	8bb2                	mv	s7,a2
 72a:	00158493          	add	s1,a1,1
  state = 0;
 72e:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 730:	02500a13          	li	s4,37
 734:	4b55                	li	s6,21
 736:	a839                	j	754 <vprintf+0x4c>
        putc(fd, c);
 738:	85ca                	mv	a1,s2
 73a:	8556                	mv	a0,s5
 73c:	00000097          	auipc	ra,0x0
 740:	efe080e7          	jalr	-258(ra) # 63a <putc>
 744:	a019                	j	74a <vprintf+0x42>
    } else if(state == '%'){
 746:	01498d63          	beq	s3,s4,760 <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
 74a:	0485                	add	s1,s1,1
 74c:	fff4c903          	lbu	s2,-1(s1)
 750:	16090763          	beqz	s2,8be <vprintf+0x1b6>
    if(state == 0){
 754:	fe0999e3          	bnez	s3,746 <vprintf+0x3e>
      if(c == '%'){
 758:	ff4910e3          	bne	s2,s4,738 <vprintf+0x30>
        state = '%';
 75c:	89d2                	mv	s3,s4
 75e:	b7f5                	j	74a <vprintf+0x42>
      if(c == 'd'){
 760:	13490463          	beq	s2,s4,888 <vprintf+0x180>
 764:	f9d9079b          	addw	a5,s2,-99
 768:	0ff7f793          	zext.b	a5,a5
 76c:	12fb6763          	bltu	s6,a5,89a <vprintf+0x192>
 770:	f9d9079b          	addw	a5,s2,-99
 774:	0ff7f713          	zext.b	a4,a5
 778:	12eb6163          	bltu	s6,a4,89a <vprintf+0x192>
 77c:	00271793          	sll	a5,a4,0x2
 780:	00000717          	auipc	a4,0x0
 784:	3b870713          	add	a4,a4,952 # b38 <malloc+0x17e>
 788:	97ba                	add	a5,a5,a4
 78a:	439c                	lw	a5,0(a5)
 78c:	97ba                	add	a5,a5,a4
 78e:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
 790:	008b8913          	add	s2,s7,8
 794:	4685                	li	a3,1
 796:	4629                	li	a2,10
 798:	000ba583          	lw	a1,0(s7)
 79c:	8556                	mv	a0,s5
 79e:	00000097          	auipc	ra,0x0
 7a2:	ebe080e7          	jalr	-322(ra) # 65c <printint>
 7a6:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 7a8:	4981                	li	s3,0
 7aa:	b745                	j	74a <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ac:	008b8913          	add	s2,s7,8
 7b0:	4681                	li	a3,0
 7b2:	4629                	li	a2,10
 7b4:	000ba583          	lw	a1,0(s7)
 7b8:	8556                	mv	a0,s5
 7ba:	00000097          	auipc	ra,0x0
 7be:	ea2080e7          	jalr	-350(ra) # 65c <printint>
 7c2:	8bca                	mv	s7,s2
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b751                	j	74a <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
 7c8:	008b8913          	add	s2,s7,8
 7cc:	4681                	li	a3,0
 7ce:	4641                	li	a2,16
 7d0:	000ba583          	lw	a1,0(s7)
 7d4:	8556                	mv	a0,s5
 7d6:	00000097          	auipc	ra,0x0
 7da:	e86080e7          	jalr	-378(ra) # 65c <printint>
 7de:	8bca                	mv	s7,s2
      state = 0;
 7e0:	4981                	li	s3,0
 7e2:	b7a5                	j	74a <vprintf+0x42>
 7e4:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
 7e6:	008b8c13          	add	s8,s7,8
 7ea:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7ee:	03000593          	li	a1,48
 7f2:	8556                	mv	a0,s5
 7f4:	00000097          	auipc	ra,0x0
 7f8:	e46080e7          	jalr	-442(ra) # 63a <putc>
  putc(fd, 'x');
 7fc:	07800593          	li	a1,120
 800:	8556                	mv	a0,s5
 802:	00000097          	auipc	ra,0x0
 806:	e38080e7          	jalr	-456(ra) # 63a <putc>
 80a:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 80c:	00000b97          	auipc	s7,0x0
 810:	384b8b93          	add	s7,s7,900 # b90 <digits>
 814:	03c9d793          	srl	a5,s3,0x3c
 818:	97de                	add	a5,a5,s7
 81a:	0007c583          	lbu	a1,0(a5)
 81e:	8556                	mv	a0,s5
 820:	00000097          	auipc	ra,0x0
 824:	e1a080e7          	jalr	-486(ra) # 63a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 828:	0992                	sll	s3,s3,0x4
 82a:	397d                	addw	s2,s2,-1
 82c:	fe0914e3          	bnez	s2,814 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
 830:	8be2                	mv	s7,s8
      state = 0;
 832:	4981                	li	s3,0
 834:	6c02                	ld	s8,0(sp)
 836:	bf11                	j	74a <vprintf+0x42>
        s = va_arg(ap, char*);
 838:	008b8993          	add	s3,s7,8
 83c:	000bb903          	ld	s2,0(s7)
        if(s == 0)
 840:	02090163          	beqz	s2,862 <vprintf+0x15a>
        while(*s != 0){
 844:	00094583          	lbu	a1,0(s2)
 848:	c9a5                	beqz	a1,8b8 <vprintf+0x1b0>
          putc(fd, *s);
 84a:	8556                	mv	a0,s5
 84c:	00000097          	auipc	ra,0x0
 850:	dee080e7          	jalr	-530(ra) # 63a <putc>
          s++;
 854:	0905                	add	s2,s2,1
        while(*s != 0){
 856:	00094583          	lbu	a1,0(s2)
 85a:	f9e5                	bnez	a1,84a <vprintf+0x142>
        s = va_arg(ap, char*);
 85c:	8bce                	mv	s7,s3
      state = 0;
 85e:	4981                	li	s3,0
 860:	b5ed                	j	74a <vprintf+0x42>
          s = "(null)";
 862:	00000917          	auipc	s2,0x0
 866:	2ce90913          	add	s2,s2,718 # b30 <malloc+0x176>
        while(*s != 0){
 86a:	02800593          	li	a1,40
 86e:	bff1                	j	84a <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
 870:	008b8913          	add	s2,s7,8
 874:	000bc583          	lbu	a1,0(s7)
 878:	8556                	mv	a0,s5
 87a:	00000097          	auipc	ra,0x0
 87e:	dc0080e7          	jalr	-576(ra) # 63a <putc>
 882:	8bca                	mv	s7,s2
      state = 0;
 884:	4981                	li	s3,0
 886:	b5d1                	j	74a <vprintf+0x42>
        putc(fd, c);
 888:	02500593          	li	a1,37
 88c:	8556                	mv	a0,s5
 88e:	00000097          	auipc	ra,0x0
 892:	dac080e7          	jalr	-596(ra) # 63a <putc>
      state = 0;
 896:	4981                	li	s3,0
 898:	bd4d                	j	74a <vprintf+0x42>
        putc(fd, '%');
 89a:	02500593          	li	a1,37
 89e:	8556                	mv	a0,s5
 8a0:	00000097          	auipc	ra,0x0
 8a4:	d9a080e7          	jalr	-614(ra) # 63a <putc>
        putc(fd, c);
 8a8:	85ca                	mv	a1,s2
 8aa:	8556                	mv	a0,s5
 8ac:	00000097          	auipc	ra,0x0
 8b0:	d8e080e7          	jalr	-626(ra) # 63a <putc>
      state = 0;
 8b4:	4981                	li	s3,0
 8b6:	bd51                	j	74a <vprintf+0x42>
        s = va_arg(ap, char*);
 8b8:	8bce                	mv	s7,s3
      state = 0;
 8ba:	4981                	li	s3,0
 8bc:	b579                	j	74a <vprintf+0x42>
 8be:	74e2                	ld	s1,56(sp)
 8c0:	79a2                	ld	s3,40(sp)
 8c2:	7a02                	ld	s4,32(sp)
 8c4:	6ae2                	ld	s5,24(sp)
 8c6:	6b42                	ld	s6,16(sp)
 8c8:	6ba2                	ld	s7,8(sp)
    }
  }
}
 8ca:	60a6                	ld	ra,72(sp)
 8cc:	6406                	ld	s0,64(sp)
 8ce:	7942                	ld	s2,48(sp)
 8d0:	6161                	add	sp,sp,80
 8d2:	8082                	ret

00000000000008d4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8d4:	715d                	add	sp,sp,-80
 8d6:	ec06                	sd	ra,24(sp)
 8d8:	e822                	sd	s0,16(sp)
 8da:	1000                	add	s0,sp,32
 8dc:	e010                	sd	a2,0(s0)
 8de:	e414                	sd	a3,8(s0)
 8e0:	e818                	sd	a4,16(s0)
 8e2:	ec1c                	sd	a5,24(s0)
 8e4:	03043023          	sd	a6,32(s0)
 8e8:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8f0:	8622                	mv	a2,s0
 8f2:	00000097          	auipc	ra,0x0
 8f6:	e16080e7          	jalr	-490(ra) # 708 <vprintf>
}
 8fa:	60e2                	ld	ra,24(sp)
 8fc:	6442                	ld	s0,16(sp)
 8fe:	6161                	add	sp,sp,80
 900:	8082                	ret

0000000000000902 <printf>:

void
printf(const char *fmt, ...)
{
 902:	711d                	add	sp,sp,-96
 904:	ec06                	sd	ra,24(sp)
 906:	e822                	sd	s0,16(sp)
 908:	1000                	add	s0,sp,32
 90a:	e40c                	sd	a1,8(s0)
 90c:	e810                	sd	a2,16(s0)
 90e:	ec14                	sd	a3,24(s0)
 910:	f018                	sd	a4,32(s0)
 912:	f41c                	sd	a5,40(s0)
 914:	03043823          	sd	a6,48(s0)
 918:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 91c:	00840613          	add	a2,s0,8
 920:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 924:	85aa                	mv	a1,a0
 926:	4505                	li	a0,1
 928:	00000097          	auipc	ra,0x0
 92c:	de0080e7          	jalr	-544(ra) # 708 <vprintf>
}
 930:	60e2                	ld	ra,24(sp)
 932:	6442                	ld	s0,16(sp)
 934:	6125                	add	sp,sp,96
 936:	8082                	ret

0000000000000938 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 938:	1141                	add	sp,sp,-16
 93a:	e422                	sd	s0,8(sp)
 93c:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 93e:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 942:	00000797          	auipc	a5,0x0
 946:	6be7b783          	ld	a5,1726(a5) # 1000 <freep>
 94a:	a02d                	j	974 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 94c:	4618                	lw	a4,8(a2)
 94e:	9f2d                	addw	a4,a4,a1
 950:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 954:	6398                	ld	a4,0(a5)
 956:	6310                	ld	a2,0(a4)
 958:	a83d                	j	996 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 95a:	ff852703          	lw	a4,-8(a0)
 95e:	9f31                	addw	a4,a4,a2
 960:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 962:	ff053683          	ld	a3,-16(a0)
 966:	a091                	j	9aa <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 968:	6398                	ld	a4,0(a5)
 96a:	00e7e463          	bltu	a5,a4,972 <free+0x3a>
 96e:	00e6ea63          	bltu	a3,a4,982 <free+0x4a>
{
 972:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 974:	fed7fae3          	bgeu	a5,a3,968 <free+0x30>
 978:	6398                	ld	a4,0(a5)
 97a:	00e6e463          	bltu	a3,a4,982 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97e:	fee7eae3          	bltu	a5,a4,972 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
 982:	ff852583          	lw	a1,-8(a0)
 986:	6390                	ld	a2,0(a5)
 988:	02059813          	sll	a6,a1,0x20
 98c:	01c85713          	srl	a4,a6,0x1c
 990:	9736                	add	a4,a4,a3
 992:	fae60de3          	beq	a2,a4,94c <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
 996:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 99a:	4790                	lw	a2,8(a5)
 99c:	02061593          	sll	a1,a2,0x20
 9a0:	01c5d713          	srl	a4,a1,0x1c
 9a4:	973e                	add	a4,a4,a5
 9a6:	fae68ae3          	beq	a3,a4,95a <free+0x22>
    p->s.ptr = bp->s.ptr;
 9aa:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64f73a23          	sd	a5,1620(a4) # 1000 <freep>
}
 9b4:	6422                	ld	s0,8(sp)
 9b6:	0141                	add	sp,sp,16
 9b8:	8082                	ret

00000000000009ba <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9ba:	7139                	add	sp,sp,-64
 9bc:	fc06                	sd	ra,56(sp)
 9be:	f822                	sd	s0,48(sp)
 9c0:	f426                	sd	s1,40(sp)
 9c2:	ec4e                	sd	s3,24(sp)
 9c4:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c6:	02051493          	sll	s1,a0,0x20
 9ca:	9081                	srl	s1,s1,0x20
 9cc:	04bd                	add	s1,s1,15
 9ce:	8091                	srl	s1,s1,0x4
 9d0:	0014899b          	addw	s3,s1,1
 9d4:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
 9d6:	00000517          	auipc	a0,0x0
 9da:	62a53503          	ld	a0,1578(a0) # 1000 <freep>
 9de:	c915                	beqz	a0,a12 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e2:	4798                	lw	a4,8(a5)
 9e4:	08977e63          	bgeu	a4,s1,a80 <malloc+0xc6>
 9e8:	f04a                	sd	s2,32(sp)
 9ea:	e852                	sd	s4,16(sp)
 9ec:	e456                	sd	s5,8(sp)
 9ee:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9f0:	8a4e                	mv	s4,s3
 9f2:	0009871b          	sext.w	a4,s3
 9f6:	6685                	lui	a3,0x1
 9f8:	00d77363          	bgeu	a4,a3,9fe <malloc+0x44>
 9fc:	6a05                	lui	s4,0x1
 9fe:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a02:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a06:	00000917          	auipc	s2,0x0
 a0a:	5fa90913          	add	s2,s2,1530 # 1000 <freep>
  if(p == (char*)-1)
 a0e:	5afd                	li	s5,-1
 a10:	a091                	j	a54 <malloc+0x9a>
 a12:	f04a                	sd	s2,32(sp)
 a14:	e852                	sd	s4,16(sp)
 a16:	e456                	sd	s5,8(sp)
 a18:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a1a:	00000797          	auipc	a5,0x0
 a1e:	60678793          	add	a5,a5,1542 # 1020 <base>
 a22:	00000717          	auipc	a4,0x0
 a26:	5cf73f23          	sd	a5,1502(a4) # 1000 <freep>
 a2a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a2c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a30:	b7c1                	j	9f0 <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
 a32:	6398                	ld	a4,0(a5)
 a34:	e118                	sd	a4,0(a0)
 a36:	a08d                	j	a98 <malloc+0xde>
  hp->s.size = nu;
 a38:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a3c:	0541                	add	a0,a0,16
 a3e:	00000097          	auipc	ra,0x0
 a42:	efa080e7          	jalr	-262(ra) # 938 <free>
  return freep;
 a46:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 a4a:	c13d                	beqz	a0,ab0 <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a4c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a4e:	4798                	lw	a4,8(a5)
 a50:	02977463          	bgeu	a4,s1,a78 <malloc+0xbe>
    if(p == freep)
 a54:	00093703          	ld	a4,0(s2)
 a58:	853e                	mv	a0,a5
 a5a:	fef719e3          	bne	a4,a5,a4c <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
 a5e:	8552                	mv	a0,s4
 a60:	00000097          	auipc	ra,0x0
 a64:	ba2080e7          	jalr	-1118(ra) # 602 <sbrk>
  if(p == (char*)-1)
 a68:	fd5518e3          	bne	a0,s5,a38 <malloc+0x7e>
        return 0;
 a6c:	4501                	li	a0,0
 a6e:	7902                	ld	s2,32(sp)
 a70:	6a42                	ld	s4,16(sp)
 a72:	6aa2                	ld	s5,8(sp)
 a74:	6b02                	ld	s6,0(sp)
 a76:	a03d                	j	aa4 <malloc+0xea>
 a78:	7902                	ld	s2,32(sp)
 a7a:	6a42                	ld	s4,16(sp)
 a7c:	6aa2                	ld	s5,8(sp)
 a7e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a80:	fae489e3          	beq	s1,a4,a32 <malloc+0x78>
        p->s.size -= nunits;
 a84:	4137073b          	subw	a4,a4,s3
 a88:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a8a:	02071693          	sll	a3,a4,0x20
 a8e:	01c6d713          	srl	a4,a3,0x1c
 a92:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a94:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a98:	00000717          	auipc	a4,0x0
 a9c:	56a73423          	sd	a0,1384(a4) # 1000 <freep>
      return (void*)(p + 1);
 aa0:	01078513          	add	a0,a5,16
  }
}
 aa4:	70e2                	ld	ra,56(sp)
 aa6:	7442                	ld	s0,48(sp)
 aa8:	74a2                	ld	s1,40(sp)
 aaa:	69e2                	ld	s3,24(sp)
 aac:	6121                	add	sp,sp,64
 aae:	8082                	ret
 ab0:	7902                	ld	s2,32(sp)
 ab2:	6a42                	ld	s4,16(sp)
 ab4:	6aa2                	ld	s5,8(sp)
 ab6:	6b02                	ld	s6,0(sp)
 ab8:	b7f5                	j	aa4 <malloc+0xea>
