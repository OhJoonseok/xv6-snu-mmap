
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	1141                	add	sp,sp,-16
       2:	e406                	sd	ra,8(sp)
       4:	e022                	sd	s0,0(sp)
       6:	0800                	add	s0,sp,16
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };

  for(int ai = 0; ai < 2; ai++){
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
       8:	20100593          	li	a1,513
       c:	4505                	li	a0,1
       e:	057e                	sll	a0,a0,0x1f
      10:	00006097          	auipc	ra,0x6
      14:	c44080e7          	jalr	-956(ra) # 5c54 <open>
    if(fd >= 0){
      18:	02055063          	bgez	a0,38 <copyinstr1+0x38>
    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      1c:	20100593          	li	a1,513
      20:	557d                	li	a0,-1
      22:	00006097          	auipc	ra,0x6
      26:	c32080e7          	jalr	-974(ra) # 5c54 <open>
    if(fd >= 0){
      2a:	55fd                	li	a1,-1
      2c:	00055863          	bgez	a0,3c <copyinstr1+0x3c>
      printf("open(%p) returned %d, not -1\n", addr, fd);
      exit(1);
    }
  }
}
      30:	60a2                	ld	ra,8(sp)
      32:	6402                	ld	s0,0(sp)
      34:	0141                	add	sp,sp,16
      36:	8082                	ret
    uint64 addr = addrs[ai];
      38:	4585                	li	a1,1
      3a:	05fe                	sll	a1,a1,0x1f
      printf("open(%p) returned %d, not -1\n", addr, fd);
      3c:	862a                	mv	a2,a0
      3e:	00006517          	auipc	a0,0x6
      42:	12250513          	add	a0,a0,290 # 6160 <malloc+0x10c>
      46:	00006097          	auipc	ra,0x6
      4a:	f56080e7          	jalr	-170(ra) # 5f9c <printf>
      exit(1);
      4e:	4505                	li	a0,1
      50:	00006097          	auipc	ra,0x6
      54:	bc4080e7          	jalr	-1084(ra) # 5c14 <exit>

0000000000000058 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      58:	0000a797          	auipc	a5,0xa
      5c:	51078793          	add	a5,a5,1296 # a568 <uninit>
      60:	0000d697          	auipc	a3,0xd
      64:	c1868693          	add	a3,a3,-1000 # cc78 <buf>
    if(uninit[i] != '\0'){
      68:	0007c703          	lbu	a4,0(a5)
      6c:	e709                	bnez	a4,76 <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      6e:	0785                	add	a5,a5,1
      70:	fed79ce3          	bne	a5,a3,68 <bsstest+0x10>
      74:	8082                	ret
{
      76:	1141                	add	sp,sp,-16
      78:	e406                	sd	ra,8(sp)
      7a:	e022                	sd	s0,0(sp)
      7c:	0800                	add	s0,sp,16
      printf("%s: bss test failed\n", s);
      7e:	85aa                	mv	a1,a0
      80:	00006517          	auipc	a0,0x6
      84:	10050513          	add	a0,a0,256 # 6180 <malloc+0x12c>
      88:	00006097          	auipc	ra,0x6
      8c:	f14080e7          	jalr	-236(ra) # 5f9c <printf>
      exit(1);
      90:	4505                	li	a0,1
      92:	00006097          	auipc	ra,0x6
      96:	b82080e7          	jalr	-1150(ra) # 5c14 <exit>

000000000000009a <opentest>:
{
      9a:	1101                	add	sp,sp,-32
      9c:	ec06                	sd	ra,24(sp)
      9e:	e822                	sd	s0,16(sp)
      a0:	e426                	sd	s1,8(sp)
      a2:	1000                	add	s0,sp,32
      a4:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      a6:	4581                	li	a1,0
      a8:	00006517          	auipc	a0,0x6
      ac:	0f050513          	add	a0,a0,240 # 6198 <malloc+0x144>
      b0:	00006097          	auipc	ra,0x6
      b4:	ba4080e7          	jalr	-1116(ra) # 5c54 <open>
  if(fd < 0){
      b8:	02054663          	bltz	a0,e4 <opentest+0x4a>
  close(fd);
      bc:	00006097          	auipc	ra,0x6
      c0:	b80080e7          	jalr	-1152(ra) # 5c3c <close>
  fd = open("doesnotexist", 0);
      c4:	4581                	li	a1,0
      c6:	00006517          	auipc	a0,0x6
      ca:	0f250513          	add	a0,a0,242 # 61b8 <malloc+0x164>
      ce:	00006097          	auipc	ra,0x6
      d2:	b86080e7          	jalr	-1146(ra) # 5c54 <open>
  if(fd >= 0){
      d6:	02055563          	bgez	a0,100 <opentest+0x66>
}
      da:	60e2                	ld	ra,24(sp)
      dc:	6442                	ld	s0,16(sp)
      de:	64a2                	ld	s1,8(sp)
      e0:	6105                	add	sp,sp,32
      e2:	8082                	ret
    printf("%s: open echo failed!\n", s);
      e4:	85a6                	mv	a1,s1
      e6:	00006517          	auipc	a0,0x6
      ea:	0ba50513          	add	a0,a0,186 # 61a0 <malloc+0x14c>
      ee:	00006097          	auipc	ra,0x6
      f2:	eae080e7          	jalr	-338(ra) # 5f9c <printf>
    exit(1);
      f6:	4505                	li	a0,1
      f8:	00006097          	auipc	ra,0x6
      fc:	b1c080e7          	jalr	-1252(ra) # 5c14 <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     100:	85a6                	mv	a1,s1
     102:	00006517          	auipc	a0,0x6
     106:	0c650513          	add	a0,a0,198 # 61c8 <malloc+0x174>
     10a:	00006097          	auipc	ra,0x6
     10e:	e92080e7          	jalr	-366(ra) # 5f9c <printf>
    exit(1);
     112:	4505                	li	a0,1
     114:	00006097          	auipc	ra,0x6
     118:	b00080e7          	jalr	-1280(ra) # 5c14 <exit>

000000000000011c <truncate2>:
{
     11c:	7179                	add	sp,sp,-48
     11e:	f406                	sd	ra,40(sp)
     120:	f022                	sd	s0,32(sp)
     122:	ec26                	sd	s1,24(sp)
     124:	e84a                	sd	s2,16(sp)
     126:	e44e                	sd	s3,8(sp)
     128:	1800                	add	s0,sp,48
     12a:	89aa                	mv	s3,a0
  unlink("truncfile");
     12c:	00006517          	auipc	a0,0x6
     130:	0c450513          	add	a0,a0,196 # 61f0 <malloc+0x19c>
     134:	00006097          	auipc	ra,0x6
     138:	b30080e7          	jalr	-1232(ra) # 5c64 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13c:	60100593          	li	a1,1537
     140:	00006517          	auipc	a0,0x6
     144:	0b050513          	add	a0,a0,176 # 61f0 <malloc+0x19c>
     148:	00006097          	auipc	ra,0x6
     14c:	b0c080e7          	jalr	-1268(ra) # 5c54 <open>
     150:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     152:	4611                	li	a2,4
     154:	00006597          	auipc	a1,0x6
     158:	0ac58593          	add	a1,a1,172 # 6200 <malloc+0x1ac>
     15c:	00006097          	auipc	ra,0x6
     160:	ad8080e7          	jalr	-1320(ra) # 5c34 <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     164:	40100593          	li	a1,1025
     168:	00006517          	auipc	a0,0x6
     16c:	08850513          	add	a0,a0,136 # 61f0 <malloc+0x19c>
     170:	00006097          	auipc	ra,0x6
     174:	ae4080e7          	jalr	-1308(ra) # 5c54 <open>
     178:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     17a:	4605                	li	a2,1
     17c:	00006597          	auipc	a1,0x6
     180:	08c58593          	add	a1,a1,140 # 6208 <malloc+0x1b4>
     184:	8526                	mv	a0,s1
     186:	00006097          	auipc	ra,0x6
     18a:	aae080e7          	jalr	-1362(ra) # 5c34 <write>
  if(n != -1){
     18e:	57fd                	li	a5,-1
     190:	02f51b63          	bne	a0,a5,1c6 <truncate2+0xaa>
  unlink("truncfile");
     194:	00006517          	auipc	a0,0x6
     198:	05c50513          	add	a0,a0,92 # 61f0 <malloc+0x19c>
     19c:	00006097          	auipc	ra,0x6
     1a0:	ac8080e7          	jalr	-1336(ra) # 5c64 <unlink>
  close(fd1);
     1a4:	8526                	mv	a0,s1
     1a6:	00006097          	auipc	ra,0x6
     1aa:	a96080e7          	jalr	-1386(ra) # 5c3c <close>
  close(fd2);
     1ae:	854a                	mv	a0,s2
     1b0:	00006097          	auipc	ra,0x6
     1b4:	a8c080e7          	jalr	-1396(ra) # 5c3c <close>
}
     1b8:	70a2                	ld	ra,40(sp)
     1ba:	7402                	ld	s0,32(sp)
     1bc:	64e2                	ld	s1,24(sp)
     1be:	6942                	ld	s2,16(sp)
     1c0:	69a2                	ld	s3,8(sp)
     1c2:	6145                	add	sp,sp,48
     1c4:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1c6:	862a                	mv	a2,a0
     1c8:	85ce                	mv	a1,s3
     1ca:	00006517          	auipc	a0,0x6
     1ce:	04650513          	add	a0,a0,70 # 6210 <malloc+0x1bc>
     1d2:	00006097          	auipc	ra,0x6
     1d6:	dca080e7          	jalr	-566(ra) # 5f9c <printf>
    exit(1);
     1da:	4505                	li	a0,1
     1dc:	00006097          	auipc	ra,0x6
     1e0:	a38080e7          	jalr	-1480(ra) # 5c14 <exit>

00000000000001e4 <createtest>:
{
     1e4:	7179                	add	sp,sp,-48
     1e6:	f406                	sd	ra,40(sp)
     1e8:	f022                	sd	s0,32(sp)
     1ea:	ec26                	sd	s1,24(sp)
     1ec:	e84a                	sd	s2,16(sp)
     1ee:	1800                	add	s0,sp,48
  name[0] = 'a';
     1f0:	06100793          	li	a5,97
     1f4:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     1f8:	fc040d23          	sb	zero,-38(s0)
     1fc:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     200:	06400913          	li	s2,100
    name[1] = '0' + i;
     204:	fc940ca3          	sb	s1,-39(s0)
    fd = open(name, O_CREATE|O_RDWR);
     208:	20200593          	li	a1,514
     20c:	fd840513          	add	a0,s0,-40
     210:	00006097          	auipc	ra,0x6
     214:	a44080e7          	jalr	-1468(ra) # 5c54 <open>
    close(fd);
     218:	00006097          	auipc	ra,0x6
     21c:	a24080e7          	jalr	-1500(ra) # 5c3c <close>
  for(i = 0; i < N; i++){
     220:	2485                	addw	s1,s1,1
     222:	0ff4f493          	zext.b	s1,s1
     226:	fd249fe3          	bne	s1,s2,204 <createtest+0x20>
  name[0] = 'a';
     22a:	06100793          	li	a5,97
     22e:	fcf40c23          	sb	a5,-40(s0)
  name[2] = '\0';
     232:	fc040d23          	sb	zero,-38(s0)
     236:	03000493          	li	s1,48
  for(i = 0; i < N; i++){
     23a:	06400913          	li	s2,100
    name[1] = '0' + i;
     23e:	fc940ca3          	sb	s1,-39(s0)
    unlink(name);
     242:	fd840513          	add	a0,s0,-40
     246:	00006097          	auipc	ra,0x6
     24a:	a1e080e7          	jalr	-1506(ra) # 5c64 <unlink>
  for(i = 0; i < N; i++){
     24e:	2485                	addw	s1,s1,1
     250:	0ff4f493          	zext.b	s1,s1
     254:	ff2495e3          	bne	s1,s2,23e <createtest+0x5a>
}
     258:	70a2                	ld	ra,40(sp)
     25a:	7402                	ld	s0,32(sp)
     25c:	64e2                	ld	s1,24(sp)
     25e:	6942                	ld	s2,16(sp)
     260:	6145                	add	sp,sp,48
     262:	8082                	ret

0000000000000264 <bigwrite>:
{
     264:	715d                	add	sp,sp,-80
     266:	e486                	sd	ra,72(sp)
     268:	e0a2                	sd	s0,64(sp)
     26a:	fc26                	sd	s1,56(sp)
     26c:	f84a                	sd	s2,48(sp)
     26e:	f44e                	sd	s3,40(sp)
     270:	f052                	sd	s4,32(sp)
     272:	ec56                	sd	s5,24(sp)
     274:	e85a                	sd	s6,16(sp)
     276:	e45e                	sd	s7,8(sp)
     278:	0880                	add	s0,sp,80
     27a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     27c:	00006517          	auipc	a0,0x6
     280:	fbc50513          	add	a0,a0,-68 # 6238 <malloc+0x1e4>
     284:	00006097          	auipc	ra,0x6
     288:	9e0080e7          	jalr	-1568(ra) # 5c64 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     28c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     290:	00006a97          	auipc	s5,0x6
     294:	fa8a8a93          	add	s5,s5,-88 # 6238 <malloc+0x1e4>
      int cc = write(fd, buf, sz);
     298:	0000da17          	auipc	s4,0xd
     29c:	9e0a0a13          	add	s4,s4,-1568 # cc78 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2a0:	6b0d                	lui	s6,0x3
     2a2:	1c9b0b13          	add	s6,s6,457 # 31c9 <fourteen+0x157>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     2a6:	20200593          	li	a1,514
     2aa:	8556                	mv	a0,s5
     2ac:	00006097          	auipc	ra,0x6
     2b0:	9a8080e7          	jalr	-1624(ra) # 5c54 <open>
     2b4:	892a                	mv	s2,a0
    if(fd < 0){
     2b6:	04054d63          	bltz	a0,310 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     2ba:	8626                	mv	a2,s1
     2bc:	85d2                	mv	a1,s4
     2be:	00006097          	auipc	ra,0x6
     2c2:	976080e7          	jalr	-1674(ra) # 5c34 <write>
     2c6:	89aa                	mv	s3,a0
      if(cc != sz){
     2c8:	06a49263          	bne	s1,a0,32c <bigwrite+0xc8>
      int cc = write(fd, buf, sz);
     2cc:	8626                	mv	a2,s1
     2ce:	85d2                	mv	a1,s4
     2d0:	854a                	mv	a0,s2
     2d2:	00006097          	auipc	ra,0x6
     2d6:	962080e7          	jalr	-1694(ra) # 5c34 <write>
      if(cc != sz){
     2da:	04951a63          	bne	a0,s1,32e <bigwrite+0xca>
    close(fd);
     2de:	854a                	mv	a0,s2
     2e0:	00006097          	auipc	ra,0x6
     2e4:	95c080e7          	jalr	-1700(ra) # 5c3c <close>
    unlink("bigwrite");
     2e8:	8556                	mv	a0,s5
     2ea:	00006097          	auipc	ra,0x6
     2ee:	97a080e7          	jalr	-1670(ra) # 5c64 <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2f2:	1d74849b          	addw	s1,s1,471
     2f6:	fb6498e3          	bne	s1,s6,2a6 <bigwrite+0x42>
}
     2fa:	60a6                	ld	ra,72(sp)
     2fc:	6406                	ld	s0,64(sp)
     2fe:	74e2                	ld	s1,56(sp)
     300:	7942                	ld	s2,48(sp)
     302:	79a2                	ld	s3,40(sp)
     304:	7a02                	ld	s4,32(sp)
     306:	6ae2                	ld	s5,24(sp)
     308:	6b42                	ld	s6,16(sp)
     30a:	6ba2                	ld	s7,8(sp)
     30c:	6161                	add	sp,sp,80
     30e:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     310:	85de                	mv	a1,s7
     312:	00006517          	auipc	a0,0x6
     316:	f3650513          	add	a0,a0,-202 # 6248 <malloc+0x1f4>
     31a:	00006097          	auipc	ra,0x6
     31e:	c82080e7          	jalr	-894(ra) # 5f9c <printf>
      exit(1);
     322:	4505                	li	a0,1
     324:	00006097          	auipc	ra,0x6
     328:	8f0080e7          	jalr	-1808(ra) # 5c14 <exit>
      if(cc != sz){
     32c:	89a6                	mv	s3,s1
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     32e:	86aa                	mv	a3,a0
     330:	864e                	mv	a2,s3
     332:	85de                	mv	a1,s7
     334:	00006517          	auipc	a0,0x6
     338:	f3450513          	add	a0,a0,-204 # 6268 <malloc+0x214>
     33c:	00006097          	auipc	ra,0x6
     340:	c60080e7          	jalr	-928(ra) # 5f9c <printf>
        exit(1);
     344:	4505                	li	a0,1
     346:	00006097          	auipc	ra,0x6
     34a:	8ce080e7          	jalr	-1842(ra) # 5c14 <exit>

000000000000034e <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     34e:	7179                	add	sp,sp,-48
     350:	f406                	sd	ra,40(sp)
     352:	f022                	sd	s0,32(sp)
     354:	ec26                	sd	s1,24(sp)
     356:	e84a                	sd	s2,16(sp)
     358:	e44e                	sd	s3,8(sp)
     35a:	e052                	sd	s4,0(sp)
     35c:	1800                	add	s0,sp,48
  int assumed_free = 600;
  
  unlink("junk");
     35e:	00006517          	auipc	a0,0x6
     362:	f2250513          	add	a0,a0,-222 # 6280 <malloc+0x22c>
     366:	00006097          	auipc	ra,0x6
     36a:	8fe080e7          	jalr	-1794(ra) # 5c64 <unlink>
     36e:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     372:	00006997          	auipc	s3,0x6
     376:	f0e98993          	add	s3,s3,-242 # 6280 <malloc+0x22c>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     37a:	5a7d                	li	s4,-1
     37c:	018a5a13          	srl	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     380:	20100593          	li	a1,513
     384:	854e                	mv	a0,s3
     386:	00006097          	auipc	ra,0x6
     38a:	8ce080e7          	jalr	-1842(ra) # 5c54 <open>
     38e:	84aa                	mv	s1,a0
    if(fd < 0){
     390:	06054b63          	bltz	a0,406 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
     394:	4605                	li	a2,1
     396:	85d2                	mv	a1,s4
     398:	00006097          	auipc	ra,0x6
     39c:	89c080e7          	jalr	-1892(ra) # 5c34 <write>
    close(fd);
     3a0:	8526                	mv	a0,s1
     3a2:	00006097          	auipc	ra,0x6
     3a6:	89a080e7          	jalr	-1894(ra) # 5c3c <close>
    unlink("junk");
     3aa:	854e                	mv	a0,s3
     3ac:	00006097          	auipc	ra,0x6
     3b0:	8b8080e7          	jalr	-1864(ra) # 5c64 <unlink>
  for(int i = 0; i < assumed_free; i++){
     3b4:	397d                	addw	s2,s2,-1
     3b6:	fc0915e3          	bnez	s2,380 <badwrite+0x32>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     3ba:	20100593          	li	a1,513
     3be:	00006517          	auipc	a0,0x6
     3c2:	ec250513          	add	a0,a0,-318 # 6280 <malloc+0x22c>
     3c6:	00006097          	auipc	ra,0x6
     3ca:	88e080e7          	jalr	-1906(ra) # 5c54 <open>
     3ce:	84aa                	mv	s1,a0
  if(fd < 0){
     3d0:	04054863          	bltz	a0,420 <badwrite+0xd2>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     3d4:	4605                	li	a2,1
     3d6:	00006597          	auipc	a1,0x6
     3da:	e3258593          	add	a1,a1,-462 # 6208 <malloc+0x1b4>
     3de:	00006097          	auipc	ra,0x6
     3e2:	856080e7          	jalr	-1962(ra) # 5c34 <write>
     3e6:	4785                	li	a5,1
     3e8:	04f50963          	beq	a0,a5,43a <badwrite+0xec>
    printf("write failed\n");
     3ec:	00006517          	auipc	a0,0x6
     3f0:	eb450513          	add	a0,a0,-332 # 62a0 <malloc+0x24c>
     3f4:	00006097          	auipc	ra,0x6
     3f8:	ba8080e7          	jalr	-1112(ra) # 5f9c <printf>
    exit(1);
     3fc:	4505                	li	a0,1
     3fe:	00006097          	auipc	ra,0x6
     402:	816080e7          	jalr	-2026(ra) # 5c14 <exit>
      printf("open junk failed\n");
     406:	00006517          	auipc	a0,0x6
     40a:	e8250513          	add	a0,a0,-382 # 6288 <malloc+0x234>
     40e:	00006097          	auipc	ra,0x6
     412:	b8e080e7          	jalr	-1138(ra) # 5f9c <printf>
      exit(1);
     416:	4505                	li	a0,1
     418:	00005097          	auipc	ra,0x5
     41c:	7fc080e7          	jalr	2044(ra) # 5c14 <exit>
    printf("open junk failed\n");
     420:	00006517          	auipc	a0,0x6
     424:	e6850513          	add	a0,a0,-408 # 6288 <malloc+0x234>
     428:	00006097          	auipc	ra,0x6
     42c:	b74080e7          	jalr	-1164(ra) # 5f9c <printf>
    exit(1);
     430:	4505                	li	a0,1
     432:	00005097          	auipc	ra,0x5
     436:	7e2080e7          	jalr	2018(ra) # 5c14 <exit>
  }
  close(fd);
     43a:	8526                	mv	a0,s1
     43c:	00006097          	auipc	ra,0x6
     440:	800080e7          	jalr	-2048(ra) # 5c3c <close>
  unlink("junk");
     444:	00006517          	auipc	a0,0x6
     448:	e3c50513          	add	a0,a0,-452 # 6280 <malloc+0x22c>
     44c:	00006097          	auipc	ra,0x6
     450:	818080e7          	jalr	-2024(ra) # 5c64 <unlink>

  exit(0);
     454:	4501                	li	a0,0
     456:	00005097          	auipc	ra,0x5
     45a:	7be080e7          	jalr	1982(ra) # 5c14 <exit>

000000000000045e <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     45e:	715d                	add	sp,sp,-80
     460:	e486                	sd	ra,72(sp)
     462:	e0a2                	sd	s0,64(sp)
     464:	fc26                	sd	s1,56(sp)
     466:	f84a                	sd	s2,48(sp)
     468:	f44e                	sd	s3,40(sp)
     46a:	0880                	add	s0,sp,80
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     46c:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     46e:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     472:	40000993          	li	s3,1024
    name[0] = 'z';
     476:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     47a:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     47e:	41f4d71b          	sraw	a4,s1,0x1f
     482:	01b7571b          	srlw	a4,a4,0x1b
     486:	009707bb          	addw	a5,a4,s1
     48a:	4057d69b          	sraw	a3,a5,0x5
     48e:	0306869b          	addw	a3,a3,48
     492:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     496:	8bfd                	and	a5,a5,31
     498:	9f99                	subw	a5,a5,a4
     49a:	0307879b          	addw	a5,a5,48
     49e:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     4a2:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     4a6:	fb040513          	add	a0,s0,-80
     4aa:	00005097          	auipc	ra,0x5
     4ae:	7ba080e7          	jalr	1978(ra) # 5c64 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     4b2:	60200593          	li	a1,1538
     4b6:	fb040513          	add	a0,s0,-80
     4ba:	00005097          	auipc	ra,0x5
     4be:	79a080e7          	jalr	1946(ra) # 5c54 <open>
    if(fd < 0){
     4c2:	00054963          	bltz	a0,4d4 <outofinodes+0x76>
      // failure is eventually expected.
      break;
    }
    close(fd);
     4c6:	00005097          	auipc	ra,0x5
     4ca:	776080e7          	jalr	1910(ra) # 5c3c <close>
  for(int i = 0; i < nzz; i++){
     4ce:	2485                	addw	s1,s1,1
     4d0:	fb3493e3          	bne	s1,s3,476 <outofinodes+0x18>
     4d4:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     4d6:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
     4da:	40000993          	li	s3,1024
    name[0] = 'z';
     4de:	fb240823          	sb	s2,-80(s0)
    name[1] = 'z';
     4e2:	fb2408a3          	sb	s2,-79(s0)
    name[2] = '0' + (i / 32);
     4e6:	41f4d71b          	sraw	a4,s1,0x1f
     4ea:	01b7571b          	srlw	a4,a4,0x1b
     4ee:	009707bb          	addw	a5,a4,s1
     4f2:	4057d69b          	sraw	a3,a5,0x5
     4f6:	0306869b          	addw	a3,a3,48
     4fa:	fad40923          	sb	a3,-78(s0)
    name[3] = '0' + (i % 32);
     4fe:	8bfd                	and	a5,a5,31
     500:	9f99                	subw	a5,a5,a4
     502:	0307879b          	addw	a5,a5,48
     506:	faf409a3          	sb	a5,-77(s0)
    name[4] = '\0';
     50a:	fa040a23          	sb	zero,-76(s0)
    unlink(name);
     50e:	fb040513          	add	a0,s0,-80
     512:	00005097          	auipc	ra,0x5
     516:	752080e7          	jalr	1874(ra) # 5c64 <unlink>
  for(int i = 0; i < nzz; i++){
     51a:	2485                	addw	s1,s1,1
     51c:	fd3491e3          	bne	s1,s3,4de <outofinodes+0x80>
  }
}
     520:	60a6                	ld	ra,72(sp)
     522:	6406                	ld	s0,64(sp)
     524:	74e2                	ld	s1,56(sp)
     526:	7942                	ld	s2,48(sp)
     528:	79a2                	ld	s3,40(sp)
     52a:	6161                	add	sp,sp,80
     52c:	8082                	ret

000000000000052e <copyin>:
{
     52e:	715d                	add	sp,sp,-80
     530:	e486                	sd	ra,72(sp)
     532:	e0a2                	sd	s0,64(sp)
     534:	fc26                	sd	s1,56(sp)
     536:	f84a                	sd	s2,48(sp)
     538:	f44e                	sd	s3,40(sp)
     53a:	f052                	sd	s4,32(sp)
     53c:	0880                	add	s0,sp,80
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     53e:	4785                	li	a5,1
     540:	07fe                	sll	a5,a5,0x1f
     542:	fcf43023          	sd	a5,-64(s0)
     546:	57fd                	li	a5,-1
     548:	fcf43423          	sd	a5,-56(s0)
  for(int ai = 0; ai < 2; ai++){
     54c:	fc040913          	add	s2,s0,-64
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     550:	00006a17          	auipc	s4,0x6
     554:	d60a0a13          	add	s4,s4,-672 # 62b0 <malloc+0x25c>
    uint64 addr = addrs[ai];
     558:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     55c:	20100593          	li	a1,513
     560:	8552                	mv	a0,s4
     562:	00005097          	auipc	ra,0x5
     566:	6f2080e7          	jalr	1778(ra) # 5c54 <open>
     56a:	84aa                	mv	s1,a0
    if(fd < 0){
     56c:	08054863          	bltz	a0,5fc <copyin+0xce>
    int n = write(fd, (void*)addr, 8192);
     570:	6609                	lui	a2,0x2
     572:	85ce                	mv	a1,s3
     574:	00005097          	auipc	ra,0x5
     578:	6c0080e7          	jalr	1728(ra) # 5c34 <write>
    if(n >= 0){
     57c:	08055d63          	bgez	a0,616 <copyin+0xe8>
    close(fd);
     580:	8526                	mv	a0,s1
     582:	00005097          	auipc	ra,0x5
     586:	6ba080e7          	jalr	1722(ra) # 5c3c <close>
    unlink("copyin1");
     58a:	8552                	mv	a0,s4
     58c:	00005097          	auipc	ra,0x5
     590:	6d8080e7          	jalr	1752(ra) # 5c64 <unlink>
    n = write(1, (char*)addr, 8192);
     594:	6609                	lui	a2,0x2
     596:	85ce                	mv	a1,s3
     598:	4505                	li	a0,1
     59a:	00005097          	auipc	ra,0x5
     59e:	69a080e7          	jalr	1690(ra) # 5c34 <write>
    if(n > 0){
     5a2:	08a04963          	bgtz	a0,634 <copyin+0x106>
    if(pipe(fds) < 0){
     5a6:	fb840513          	add	a0,s0,-72
     5aa:	00005097          	auipc	ra,0x5
     5ae:	67a080e7          	jalr	1658(ra) # 5c24 <pipe>
     5b2:	0a054063          	bltz	a0,652 <copyin+0x124>
    n = write(fds[1], (char*)addr, 8192);
     5b6:	6609                	lui	a2,0x2
     5b8:	85ce                	mv	a1,s3
     5ba:	fbc42503          	lw	a0,-68(s0)
     5be:	00005097          	auipc	ra,0x5
     5c2:	676080e7          	jalr	1654(ra) # 5c34 <write>
    if(n > 0){
     5c6:	0aa04363          	bgtz	a0,66c <copyin+0x13e>
    close(fds[0]);
     5ca:	fb842503          	lw	a0,-72(s0)
     5ce:	00005097          	auipc	ra,0x5
     5d2:	66e080e7          	jalr	1646(ra) # 5c3c <close>
    close(fds[1]);
     5d6:	fbc42503          	lw	a0,-68(s0)
     5da:	00005097          	auipc	ra,0x5
     5de:	662080e7          	jalr	1634(ra) # 5c3c <close>
  for(int ai = 0; ai < 2; ai++){
     5e2:	0921                	add	s2,s2,8
     5e4:	fd040793          	add	a5,s0,-48
     5e8:	f6f918e3          	bne	s2,a5,558 <copyin+0x2a>
}
     5ec:	60a6                	ld	ra,72(sp)
     5ee:	6406                	ld	s0,64(sp)
     5f0:	74e2                	ld	s1,56(sp)
     5f2:	7942                	ld	s2,48(sp)
     5f4:	79a2                	ld	s3,40(sp)
     5f6:	7a02                	ld	s4,32(sp)
     5f8:	6161                	add	sp,sp,80
     5fa:	8082                	ret
      printf("open(copyin1) failed\n");
     5fc:	00006517          	auipc	a0,0x6
     600:	cbc50513          	add	a0,a0,-836 # 62b8 <malloc+0x264>
     604:	00006097          	auipc	ra,0x6
     608:	998080e7          	jalr	-1640(ra) # 5f9c <printf>
      exit(1);
     60c:	4505                	li	a0,1
     60e:	00005097          	auipc	ra,0x5
     612:	606080e7          	jalr	1542(ra) # 5c14 <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", addr, n);
     616:	862a                	mv	a2,a0
     618:	85ce                	mv	a1,s3
     61a:	00006517          	auipc	a0,0x6
     61e:	cb650513          	add	a0,a0,-842 # 62d0 <malloc+0x27c>
     622:	00006097          	auipc	ra,0x6
     626:	97a080e7          	jalr	-1670(ra) # 5f9c <printf>
      exit(1);
     62a:	4505                	li	a0,1
     62c:	00005097          	auipc	ra,0x5
     630:	5e8080e7          	jalr	1512(ra) # 5c14 <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     634:	862a                	mv	a2,a0
     636:	85ce                	mv	a1,s3
     638:	00006517          	auipc	a0,0x6
     63c:	cc850513          	add	a0,a0,-824 # 6300 <malloc+0x2ac>
     640:	00006097          	auipc	ra,0x6
     644:	95c080e7          	jalr	-1700(ra) # 5f9c <printf>
      exit(1);
     648:	4505                	li	a0,1
     64a:	00005097          	auipc	ra,0x5
     64e:	5ca080e7          	jalr	1482(ra) # 5c14 <exit>
      printf("pipe() failed\n");
     652:	00006517          	auipc	a0,0x6
     656:	cde50513          	add	a0,a0,-802 # 6330 <malloc+0x2dc>
     65a:	00006097          	auipc	ra,0x6
     65e:	942080e7          	jalr	-1726(ra) # 5f9c <printf>
      exit(1);
     662:	4505                	li	a0,1
     664:	00005097          	auipc	ra,0x5
     668:	5b0080e7          	jalr	1456(ra) # 5c14 <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     66c:	862a                	mv	a2,a0
     66e:	85ce                	mv	a1,s3
     670:	00006517          	auipc	a0,0x6
     674:	cd050513          	add	a0,a0,-816 # 6340 <malloc+0x2ec>
     678:	00006097          	auipc	ra,0x6
     67c:	924080e7          	jalr	-1756(ra) # 5f9c <printf>
      exit(1);
     680:	4505                	li	a0,1
     682:	00005097          	auipc	ra,0x5
     686:	592080e7          	jalr	1426(ra) # 5c14 <exit>

000000000000068a <copyout>:
{
     68a:	711d                	add	sp,sp,-96
     68c:	ec86                	sd	ra,88(sp)
     68e:	e8a2                	sd	s0,80(sp)
     690:	e4a6                	sd	s1,72(sp)
     692:	e0ca                	sd	s2,64(sp)
     694:	fc4e                	sd	s3,56(sp)
     696:	f852                	sd	s4,48(sp)
     698:	f456                	sd	s5,40(sp)
     69a:	1080                	add	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0xffffffffffffffff };
     69c:	4785                	li	a5,1
     69e:	07fe                	sll	a5,a5,0x1f
     6a0:	faf43823          	sd	a5,-80(s0)
     6a4:	57fd                	li	a5,-1
     6a6:	faf43c23          	sd	a5,-72(s0)
  for(int ai = 0; ai < 2; ai++){
     6aa:	fb040913          	add	s2,s0,-80
    int fd = open("README", 0);
     6ae:	00006a17          	auipc	s4,0x6
     6b2:	cc2a0a13          	add	s4,s4,-830 # 6370 <malloc+0x31c>
    n = write(fds[1], "x", 1);
     6b6:	00006a97          	auipc	s5,0x6
     6ba:	b52a8a93          	add	s5,s5,-1198 # 6208 <malloc+0x1b4>
    uint64 addr = addrs[ai];
     6be:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     6c2:	4581                	li	a1,0
     6c4:	8552                	mv	a0,s4
     6c6:	00005097          	auipc	ra,0x5
     6ca:	58e080e7          	jalr	1422(ra) # 5c54 <open>
     6ce:	84aa                	mv	s1,a0
    if(fd < 0){
     6d0:	08054663          	bltz	a0,75c <copyout+0xd2>
    int n = read(fd, (void*)addr, 8192);
     6d4:	6609                	lui	a2,0x2
     6d6:	85ce                	mv	a1,s3
     6d8:	00005097          	auipc	ra,0x5
     6dc:	554080e7          	jalr	1364(ra) # 5c2c <read>
    if(n > 0){
     6e0:	08a04b63          	bgtz	a0,776 <copyout+0xec>
    close(fd);
     6e4:	8526                	mv	a0,s1
     6e6:	00005097          	auipc	ra,0x5
     6ea:	556080e7          	jalr	1366(ra) # 5c3c <close>
    if(pipe(fds) < 0){
     6ee:	fa840513          	add	a0,s0,-88
     6f2:	00005097          	auipc	ra,0x5
     6f6:	532080e7          	jalr	1330(ra) # 5c24 <pipe>
     6fa:	08054d63          	bltz	a0,794 <copyout+0x10a>
    n = write(fds[1], "x", 1);
     6fe:	4605                	li	a2,1
     700:	85d6                	mv	a1,s5
     702:	fac42503          	lw	a0,-84(s0)
     706:	00005097          	auipc	ra,0x5
     70a:	52e080e7          	jalr	1326(ra) # 5c34 <write>
    if(n != 1){
     70e:	4785                	li	a5,1
     710:	08f51f63          	bne	a0,a5,7ae <copyout+0x124>
    n = read(fds[0], (void*)addr, 8192);
     714:	6609                	lui	a2,0x2
     716:	85ce                	mv	a1,s3
     718:	fa842503          	lw	a0,-88(s0)
     71c:	00005097          	auipc	ra,0x5
     720:	510080e7          	jalr	1296(ra) # 5c2c <read>
    if(n > 0){
     724:	0aa04263          	bgtz	a0,7c8 <copyout+0x13e>
    close(fds[0]);
     728:	fa842503          	lw	a0,-88(s0)
     72c:	00005097          	auipc	ra,0x5
     730:	510080e7          	jalr	1296(ra) # 5c3c <close>
    close(fds[1]);
     734:	fac42503          	lw	a0,-84(s0)
     738:	00005097          	auipc	ra,0x5
     73c:	504080e7          	jalr	1284(ra) # 5c3c <close>
  for(int ai = 0; ai < 2; ai++){
     740:	0921                	add	s2,s2,8
     742:	fc040793          	add	a5,s0,-64
     746:	f6f91ce3          	bne	s2,a5,6be <copyout+0x34>
}
     74a:	60e6                	ld	ra,88(sp)
     74c:	6446                	ld	s0,80(sp)
     74e:	64a6                	ld	s1,72(sp)
     750:	6906                	ld	s2,64(sp)
     752:	79e2                	ld	s3,56(sp)
     754:	7a42                	ld	s4,48(sp)
     756:	7aa2                	ld	s5,40(sp)
     758:	6125                	add	sp,sp,96
     75a:	8082                	ret
      printf("open(README) failed\n");
     75c:	00006517          	auipc	a0,0x6
     760:	c1c50513          	add	a0,a0,-996 # 6378 <malloc+0x324>
     764:	00006097          	auipc	ra,0x6
     768:	838080e7          	jalr	-1992(ra) # 5f9c <printf>
      exit(1);
     76c:	4505                	li	a0,1
     76e:	00005097          	auipc	ra,0x5
     772:	4a6080e7          	jalr	1190(ra) # 5c14 <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     776:	862a                	mv	a2,a0
     778:	85ce                	mv	a1,s3
     77a:	00006517          	auipc	a0,0x6
     77e:	c1650513          	add	a0,a0,-1002 # 6390 <malloc+0x33c>
     782:	00006097          	auipc	ra,0x6
     786:	81a080e7          	jalr	-2022(ra) # 5f9c <printf>
      exit(1);
     78a:	4505                	li	a0,1
     78c:	00005097          	auipc	ra,0x5
     790:	488080e7          	jalr	1160(ra) # 5c14 <exit>
      printf("pipe() failed\n");
     794:	00006517          	auipc	a0,0x6
     798:	b9c50513          	add	a0,a0,-1124 # 6330 <malloc+0x2dc>
     79c:	00006097          	auipc	ra,0x6
     7a0:	800080e7          	jalr	-2048(ra) # 5f9c <printf>
      exit(1);
     7a4:	4505                	li	a0,1
     7a6:	00005097          	auipc	ra,0x5
     7aa:	46e080e7          	jalr	1134(ra) # 5c14 <exit>
      printf("pipe write failed\n");
     7ae:	00006517          	auipc	a0,0x6
     7b2:	c1250513          	add	a0,a0,-1006 # 63c0 <malloc+0x36c>
     7b6:	00005097          	auipc	ra,0x5
     7ba:	7e6080e7          	jalr	2022(ra) # 5f9c <printf>
      exit(1);
     7be:	4505                	li	a0,1
     7c0:	00005097          	auipc	ra,0x5
     7c4:	454080e7          	jalr	1108(ra) # 5c14 <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", addr, n);
     7c8:	862a                	mv	a2,a0
     7ca:	85ce                	mv	a1,s3
     7cc:	00006517          	auipc	a0,0x6
     7d0:	c0c50513          	add	a0,a0,-1012 # 63d8 <malloc+0x384>
     7d4:	00005097          	auipc	ra,0x5
     7d8:	7c8080e7          	jalr	1992(ra) # 5f9c <printf>
      exit(1);
     7dc:	4505                	li	a0,1
     7de:	00005097          	auipc	ra,0x5
     7e2:	436080e7          	jalr	1078(ra) # 5c14 <exit>

00000000000007e6 <truncate1>:
{
     7e6:	711d                	add	sp,sp,-96
     7e8:	ec86                	sd	ra,88(sp)
     7ea:	e8a2                	sd	s0,80(sp)
     7ec:	e4a6                	sd	s1,72(sp)
     7ee:	e0ca                	sd	s2,64(sp)
     7f0:	fc4e                	sd	s3,56(sp)
     7f2:	f852                	sd	s4,48(sp)
     7f4:	f456                	sd	s5,40(sp)
     7f6:	1080                	add	s0,sp,96
     7f8:	8aaa                	mv	s5,a0
  unlink("truncfile");
     7fa:	00006517          	auipc	a0,0x6
     7fe:	9f650513          	add	a0,a0,-1546 # 61f0 <malloc+0x19c>
     802:	00005097          	auipc	ra,0x5
     806:	462080e7          	jalr	1122(ra) # 5c64 <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     80a:	60100593          	li	a1,1537
     80e:	00006517          	auipc	a0,0x6
     812:	9e250513          	add	a0,a0,-1566 # 61f0 <malloc+0x19c>
     816:	00005097          	auipc	ra,0x5
     81a:	43e080e7          	jalr	1086(ra) # 5c54 <open>
     81e:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     820:	4611                	li	a2,4
     822:	00006597          	auipc	a1,0x6
     826:	9de58593          	add	a1,a1,-1570 # 6200 <malloc+0x1ac>
     82a:	00005097          	auipc	ra,0x5
     82e:	40a080e7          	jalr	1034(ra) # 5c34 <write>
  close(fd1);
     832:	8526                	mv	a0,s1
     834:	00005097          	auipc	ra,0x5
     838:	408080e7          	jalr	1032(ra) # 5c3c <close>
  int fd2 = open("truncfile", O_RDONLY);
     83c:	4581                	li	a1,0
     83e:	00006517          	auipc	a0,0x6
     842:	9b250513          	add	a0,a0,-1614 # 61f0 <malloc+0x19c>
     846:	00005097          	auipc	ra,0x5
     84a:	40e080e7          	jalr	1038(ra) # 5c54 <open>
     84e:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     850:	02000613          	li	a2,32
     854:	fa040593          	add	a1,s0,-96
     858:	00005097          	auipc	ra,0x5
     85c:	3d4080e7          	jalr	980(ra) # 5c2c <read>
  if(n != 4){
     860:	4791                	li	a5,4
     862:	0cf51e63          	bne	a0,a5,93e <truncate1+0x158>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     866:	40100593          	li	a1,1025
     86a:	00006517          	auipc	a0,0x6
     86e:	98650513          	add	a0,a0,-1658 # 61f0 <malloc+0x19c>
     872:	00005097          	auipc	ra,0x5
     876:	3e2080e7          	jalr	994(ra) # 5c54 <open>
     87a:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     87c:	4581                	li	a1,0
     87e:	00006517          	auipc	a0,0x6
     882:	97250513          	add	a0,a0,-1678 # 61f0 <malloc+0x19c>
     886:	00005097          	auipc	ra,0x5
     88a:	3ce080e7          	jalr	974(ra) # 5c54 <open>
     88e:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     890:	02000613          	li	a2,32
     894:	fa040593          	add	a1,s0,-96
     898:	00005097          	auipc	ra,0x5
     89c:	394080e7          	jalr	916(ra) # 5c2c <read>
     8a0:	8a2a                	mv	s4,a0
  if(n != 0){
     8a2:	ed4d                	bnez	a0,95c <truncate1+0x176>
  n = read(fd2, buf, sizeof(buf));
     8a4:	02000613          	li	a2,32
     8a8:	fa040593          	add	a1,s0,-96
     8ac:	8526                	mv	a0,s1
     8ae:	00005097          	auipc	ra,0x5
     8b2:	37e080e7          	jalr	894(ra) # 5c2c <read>
     8b6:	8a2a                	mv	s4,a0
  if(n != 0){
     8b8:	e971                	bnez	a0,98c <truncate1+0x1a6>
  write(fd1, "abcdef", 6);
     8ba:	4619                	li	a2,6
     8bc:	00006597          	auipc	a1,0x6
     8c0:	bac58593          	add	a1,a1,-1108 # 6468 <malloc+0x414>
     8c4:	854e                	mv	a0,s3
     8c6:	00005097          	auipc	ra,0x5
     8ca:	36e080e7          	jalr	878(ra) # 5c34 <write>
  n = read(fd3, buf, sizeof(buf));
     8ce:	02000613          	li	a2,32
     8d2:	fa040593          	add	a1,s0,-96
     8d6:	854a                	mv	a0,s2
     8d8:	00005097          	auipc	ra,0x5
     8dc:	354080e7          	jalr	852(ra) # 5c2c <read>
  if(n != 6){
     8e0:	4799                	li	a5,6
     8e2:	0cf51d63          	bne	a0,a5,9bc <truncate1+0x1d6>
  n = read(fd2, buf, sizeof(buf));
     8e6:	02000613          	li	a2,32
     8ea:	fa040593          	add	a1,s0,-96
     8ee:	8526                	mv	a0,s1
     8f0:	00005097          	auipc	ra,0x5
     8f4:	33c080e7          	jalr	828(ra) # 5c2c <read>
  if(n != 2){
     8f8:	4789                	li	a5,2
     8fa:	0ef51063          	bne	a0,a5,9da <truncate1+0x1f4>
  unlink("truncfile");
     8fe:	00006517          	auipc	a0,0x6
     902:	8f250513          	add	a0,a0,-1806 # 61f0 <malloc+0x19c>
     906:	00005097          	auipc	ra,0x5
     90a:	35e080e7          	jalr	862(ra) # 5c64 <unlink>
  close(fd1);
     90e:	854e                	mv	a0,s3
     910:	00005097          	auipc	ra,0x5
     914:	32c080e7          	jalr	812(ra) # 5c3c <close>
  close(fd2);
     918:	8526                	mv	a0,s1
     91a:	00005097          	auipc	ra,0x5
     91e:	322080e7          	jalr	802(ra) # 5c3c <close>
  close(fd3);
     922:	854a                	mv	a0,s2
     924:	00005097          	auipc	ra,0x5
     928:	318080e7          	jalr	792(ra) # 5c3c <close>
}
     92c:	60e6                	ld	ra,88(sp)
     92e:	6446                	ld	s0,80(sp)
     930:	64a6                	ld	s1,72(sp)
     932:	6906                	ld	s2,64(sp)
     934:	79e2                	ld	s3,56(sp)
     936:	7a42                	ld	s4,48(sp)
     938:	7aa2                	ld	s5,40(sp)
     93a:	6125                	add	sp,sp,96
     93c:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     93e:	862a                	mv	a2,a0
     940:	85d6                	mv	a1,s5
     942:	00006517          	auipc	a0,0x6
     946:	ac650513          	add	a0,a0,-1338 # 6408 <malloc+0x3b4>
     94a:	00005097          	auipc	ra,0x5
     94e:	652080e7          	jalr	1618(ra) # 5f9c <printf>
    exit(1);
     952:	4505                	li	a0,1
     954:	00005097          	auipc	ra,0x5
     958:	2c0080e7          	jalr	704(ra) # 5c14 <exit>
    printf("aaa fd3=%d\n", fd3);
     95c:	85ca                	mv	a1,s2
     95e:	00006517          	auipc	a0,0x6
     962:	aca50513          	add	a0,a0,-1334 # 6428 <malloc+0x3d4>
     966:	00005097          	auipc	ra,0x5
     96a:	636080e7          	jalr	1590(ra) # 5f9c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     96e:	8652                	mv	a2,s4
     970:	85d6                	mv	a1,s5
     972:	00006517          	auipc	a0,0x6
     976:	ac650513          	add	a0,a0,-1338 # 6438 <malloc+0x3e4>
     97a:	00005097          	auipc	ra,0x5
     97e:	622080e7          	jalr	1570(ra) # 5f9c <printf>
    exit(1);
     982:	4505                	li	a0,1
     984:	00005097          	auipc	ra,0x5
     988:	290080e7          	jalr	656(ra) # 5c14 <exit>
    printf("bbb fd2=%d\n", fd2);
     98c:	85a6                	mv	a1,s1
     98e:	00006517          	auipc	a0,0x6
     992:	aca50513          	add	a0,a0,-1334 # 6458 <malloc+0x404>
     996:	00005097          	auipc	ra,0x5
     99a:	606080e7          	jalr	1542(ra) # 5f9c <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     99e:	8652                	mv	a2,s4
     9a0:	85d6                	mv	a1,s5
     9a2:	00006517          	auipc	a0,0x6
     9a6:	a9650513          	add	a0,a0,-1386 # 6438 <malloc+0x3e4>
     9aa:	00005097          	auipc	ra,0x5
     9ae:	5f2080e7          	jalr	1522(ra) # 5f9c <printf>
    exit(1);
     9b2:	4505                	li	a0,1
     9b4:	00005097          	auipc	ra,0x5
     9b8:	260080e7          	jalr	608(ra) # 5c14 <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     9bc:	862a                	mv	a2,a0
     9be:	85d6                	mv	a1,s5
     9c0:	00006517          	auipc	a0,0x6
     9c4:	ab050513          	add	a0,a0,-1360 # 6470 <malloc+0x41c>
     9c8:	00005097          	auipc	ra,0x5
     9cc:	5d4080e7          	jalr	1492(ra) # 5f9c <printf>
    exit(1);
     9d0:	4505                	li	a0,1
     9d2:	00005097          	auipc	ra,0x5
     9d6:	242080e7          	jalr	578(ra) # 5c14 <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     9da:	862a                	mv	a2,a0
     9dc:	85d6                	mv	a1,s5
     9de:	00006517          	auipc	a0,0x6
     9e2:	ab250513          	add	a0,a0,-1358 # 6490 <malloc+0x43c>
     9e6:	00005097          	auipc	ra,0x5
     9ea:	5b6080e7          	jalr	1462(ra) # 5f9c <printf>
    exit(1);
     9ee:	4505                	li	a0,1
     9f0:	00005097          	auipc	ra,0x5
     9f4:	224080e7          	jalr	548(ra) # 5c14 <exit>

00000000000009f8 <writetest>:
{
     9f8:	7139                	add	sp,sp,-64
     9fa:	fc06                	sd	ra,56(sp)
     9fc:	f822                	sd	s0,48(sp)
     9fe:	f426                	sd	s1,40(sp)
     a00:	f04a                	sd	s2,32(sp)
     a02:	ec4e                	sd	s3,24(sp)
     a04:	e852                	sd	s4,16(sp)
     a06:	e456                	sd	s5,8(sp)
     a08:	e05a                	sd	s6,0(sp)
     a0a:	0080                	add	s0,sp,64
     a0c:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     a0e:	20200593          	li	a1,514
     a12:	00006517          	auipc	a0,0x6
     a16:	a9e50513          	add	a0,a0,-1378 # 64b0 <malloc+0x45c>
     a1a:	00005097          	auipc	ra,0x5
     a1e:	23a080e7          	jalr	570(ra) # 5c54 <open>
  if(fd < 0){
     a22:	0a054d63          	bltz	a0,adc <writetest+0xe4>
     a26:	892a                	mv	s2,a0
     a28:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a2a:	00006997          	auipc	s3,0x6
     a2e:	aae98993          	add	s3,s3,-1362 # 64d8 <malloc+0x484>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a32:	00006a97          	auipc	s5,0x6
     a36:	adea8a93          	add	s5,s5,-1314 # 6510 <malloc+0x4bc>
  for(i = 0; i < N; i++){
     a3a:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     a3e:	4629                	li	a2,10
     a40:	85ce                	mv	a1,s3
     a42:	854a                	mv	a0,s2
     a44:	00005097          	auipc	ra,0x5
     a48:	1f0080e7          	jalr	496(ra) # 5c34 <write>
     a4c:	47a9                	li	a5,10
     a4e:	0af51563          	bne	a0,a5,af8 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     a52:	4629                	li	a2,10
     a54:	85d6                	mv	a1,s5
     a56:	854a                	mv	a0,s2
     a58:	00005097          	auipc	ra,0x5
     a5c:	1dc080e7          	jalr	476(ra) # 5c34 <write>
     a60:	47a9                	li	a5,10
     a62:	0af51a63          	bne	a0,a5,b16 <writetest+0x11e>
  for(i = 0; i < N; i++){
     a66:	2485                	addw	s1,s1,1
     a68:	fd449be3          	bne	s1,s4,a3e <writetest+0x46>
  close(fd);
     a6c:	854a                	mv	a0,s2
     a6e:	00005097          	auipc	ra,0x5
     a72:	1ce080e7          	jalr	462(ra) # 5c3c <close>
  fd = open("small", O_RDONLY);
     a76:	4581                	li	a1,0
     a78:	00006517          	auipc	a0,0x6
     a7c:	a3850513          	add	a0,a0,-1480 # 64b0 <malloc+0x45c>
     a80:	00005097          	auipc	ra,0x5
     a84:	1d4080e7          	jalr	468(ra) # 5c54 <open>
     a88:	84aa                	mv	s1,a0
  if(fd < 0){
     a8a:	0a054563          	bltz	a0,b34 <writetest+0x13c>
  i = read(fd, buf, N*SZ*2);
     a8e:	7d000613          	li	a2,2000
     a92:	0000c597          	auipc	a1,0xc
     a96:	1e658593          	add	a1,a1,486 # cc78 <buf>
     a9a:	00005097          	auipc	ra,0x5
     a9e:	192080e7          	jalr	402(ra) # 5c2c <read>
  if(i != N*SZ*2){
     aa2:	7d000793          	li	a5,2000
     aa6:	0af51563          	bne	a0,a5,b50 <writetest+0x158>
  close(fd);
     aaa:	8526                	mv	a0,s1
     aac:	00005097          	auipc	ra,0x5
     ab0:	190080e7          	jalr	400(ra) # 5c3c <close>
  if(unlink("small") < 0){
     ab4:	00006517          	auipc	a0,0x6
     ab8:	9fc50513          	add	a0,a0,-1540 # 64b0 <malloc+0x45c>
     abc:	00005097          	auipc	ra,0x5
     ac0:	1a8080e7          	jalr	424(ra) # 5c64 <unlink>
     ac4:	0a054463          	bltz	a0,b6c <writetest+0x174>
}
     ac8:	70e2                	ld	ra,56(sp)
     aca:	7442                	ld	s0,48(sp)
     acc:	74a2                	ld	s1,40(sp)
     ace:	7902                	ld	s2,32(sp)
     ad0:	69e2                	ld	s3,24(sp)
     ad2:	6a42                	ld	s4,16(sp)
     ad4:	6aa2                	ld	s5,8(sp)
     ad6:	6b02                	ld	s6,0(sp)
     ad8:	6121                	add	sp,sp,64
     ada:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     adc:	85da                	mv	a1,s6
     ade:	00006517          	auipc	a0,0x6
     ae2:	9da50513          	add	a0,a0,-1574 # 64b8 <malloc+0x464>
     ae6:	00005097          	auipc	ra,0x5
     aea:	4b6080e7          	jalr	1206(ra) # 5f9c <printf>
    exit(1);
     aee:	4505                	li	a0,1
     af0:	00005097          	auipc	ra,0x5
     af4:	124080e7          	jalr	292(ra) # 5c14 <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     af8:	8626                	mv	a2,s1
     afa:	85da                	mv	a1,s6
     afc:	00006517          	auipc	a0,0x6
     b00:	9ec50513          	add	a0,a0,-1556 # 64e8 <malloc+0x494>
     b04:	00005097          	auipc	ra,0x5
     b08:	498080e7          	jalr	1176(ra) # 5f9c <printf>
      exit(1);
     b0c:	4505                	li	a0,1
     b0e:	00005097          	auipc	ra,0x5
     b12:	106080e7          	jalr	262(ra) # 5c14 <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     b16:	8626                	mv	a2,s1
     b18:	85da                	mv	a1,s6
     b1a:	00006517          	auipc	a0,0x6
     b1e:	a0650513          	add	a0,a0,-1530 # 6520 <malloc+0x4cc>
     b22:	00005097          	auipc	ra,0x5
     b26:	47a080e7          	jalr	1146(ra) # 5f9c <printf>
      exit(1);
     b2a:	4505                	li	a0,1
     b2c:	00005097          	auipc	ra,0x5
     b30:	0e8080e7          	jalr	232(ra) # 5c14 <exit>
    printf("%s: error: open small failed!\n", s);
     b34:	85da                	mv	a1,s6
     b36:	00006517          	auipc	a0,0x6
     b3a:	a1250513          	add	a0,a0,-1518 # 6548 <malloc+0x4f4>
     b3e:	00005097          	auipc	ra,0x5
     b42:	45e080e7          	jalr	1118(ra) # 5f9c <printf>
    exit(1);
     b46:	4505                	li	a0,1
     b48:	00005097          	auipc	ra,0x5
     b4c:	0cc080e7          	jalr	204(ra) # 5c14 <exit>
    printf("%s: read failed\n", s);
     b50:	85da                	mv	a1,s6
     b52:	00006517          	auipc	a0,0x6
     b56:	a1650513          	add	a0,a0,-1514 # 6568 <malloc+0x514>
     b5a:	00005097          	auipc	ra,0x5
     b5e:	442080e7          	jalr	1090(ra) # 5f9c <printf>
    exit(1);
     b62:	4505                	li	a0,1
     b64:	00005097          	auipc	ra,0x5
     b68:	0b0080e7          	jalr	176(ra) # 5c14 <exit>
    printf("%s: unlink small failed\n", s);
     b6c:	85da                	mv	a1,s6
     b6e:	00006517          	auipc	a0,0x6
     b72:	a1250513          	add	a0,a0,-1518 # 6580 <malloc+0x52c>
     b76:	00005097          	auipc	ra,0x5
     b7a:	426080e7          	jalr	1062(ra) # 5f9c <printf>
    exit(1);
     b7e:	4505                	li	a0,1
     b80:	00005097          	auipc	ra,0x5
     b84:	094080e7          	jalr	148(ra) # 5c14 <exit>

0000000000000b88 <writebig>:
{
     b88:	7139                	add	sp,sp,-64
     b8a:	fc06                	sd	ra,56(sp)
     b8c:	f822                	sd	s0,48(sp)
     b8e:	f426                	sd	s1,40(sp)
     b90:	f04a                	sd	s2,32(sp)
     b92:	ec4e                	sd	s3,24(sp)
     b94:	e852                	sd	s4,16(sp)
     b96:	e456                	sd	s5,8(sp)
     b98:	0080                	add	s0,sp,64
     b9a:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
     b9c:	20200593          	li	a1,514
     ba0:	00006517          	auipc	a0,0x6
     ba4:	a0050513          	add	a0,a0,-1536 # 65a0 <malloc+0x54c>
     ba8:	00005097          	auipc	ra,0x5
     bac:	0ac080e7          	jalr	172(ra) # 5c54 <open>
     bb0:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
     bb2:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     bb4:	0000c917          	auipc	s2,0xc
     bb8:	0c490913          	add	s2,s2,196 # cc78 <buf>
  for(i = 0; i < MAXFILE; i++){
     bbc:	10c00a13          	li	s4,268
  if(fd < 0){
     bc0:	06054c63          	bltz	a0,c38 <writebig+0xb0>
    ((int*)buf)[0] = i;
     bc4:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
     bc8:	40000613          	li	a2,1024
     bcc:	85ca                	mv	a1,s2
     bce:	854e                	mv	a0,s3
     bd0:	00005097          	auipc	ra,0x5
     bd4:	064080e7          	jalr	100(ra) # 5c34 <write>
     bd8:	40000793          	li	a5,1024
     bdc:	06f51c63          	bne	a0,a5,c54 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
     be0:	2485                	addw	s1,s1,1
     be2:	ff4491e3          	bne	s1,s4,bc4 <writebig+0x3c>
  close(fd);
     be6:	854e                	mv	a0,s3
     be8:	00005097          	auipc	ra,0x5
     bec:	054080e7          	jalr	84(ra) # 5c3c <close>
  fd = open("big", O_RDONLY);
     bf0:	4581                	li	a1,0
     bf2:	00006517          	auipc	a0,0x6
     bf6:	9ae50513          	add	a0,a0,-1618 # 65a0 <malloc+0x54c>
     bfa:	00005097          	auipc	ra,0x5
     bfe:	05a080e7          	jalr	90(ra) # 5c54 <open>
     c02:	89aa                	mv	s3,a0
  n = 0;
     c04:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     c06:	0000c917          	auipc	s2,0xc
     c0a:	07290913          	add	s2,s2,114 # cc78 <buf>
  if(fd < 0){
     c0e:	06054263          	bltz	a0,c72 <writebig+0xea>
    i = read(fd, buf, BSIZE);
     c12:	40000613          	li	a2,1024
     c16:	85ca                	mv	a1,s2
     c18:	854e                	mv	a0,s3
     c1a:	00005097          	auipc	ra,0x5
     c1e:	012080e7          	jalr	18(ra) # 5c2c <read>
    if(i == 0){
     c22:	c535                	beqz	a0,c8e <writebig+0x106>
    } else if(i != BSIZE){
     c24:	40000793          	li	a5,1024
     c28:	0af51f63          	bne	a0,a5,ce6 <writebig+0x15e>
    if(((int*)buf)[0] != n){
     c2c:	00092683          	lw	a3,0(s2)
     c30:	0c969a63          	bne	a3,s1,d04 <writebig+0x17c>
    n++;
     c34:	2485                	addw	s1,s1,1
    i = read(fd, buf, BSIZE);
     c36:	bff1                	j	c12 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
     c38:	85d6                	mv	a1,s5
     c3a:	00006517          	auipc	a0,0x6
     c3e:	96e50513          	add	a0,a0,-1682 # 65a8 <malloc+0x554>
     c42:	00005097          	auipc	ra,0x5
     c46:	35a080e7          	jalr	858(ra) # 5f9c <printf>
    exit(1);
     c4a:	4505                	li	a0,1
     c4c:	00005097          	auipc	ra,0x5
     c50:	fc8080e7          	jalr	-56(ra) # 5c14 <exit>
      printf("%s: error: write big file failed\n", s, i);
     c54:	8626                	mv	a2,s1
     c56:	85d6                	mv	a1,s5
     c58:	00006517          	auipc	a0,0x6
     c5c:	97050513          	add	a0,a0,-1680 # 65c8 <malloc+0x574>
     c60:	00005097          	auipc	ra,0x5
     c64:	33c080e7          	jalr	828(ra) # 5f9c <printf>
      exit(1);
     c68:	4505                	li	a0,1
     c6a:	00005097          	auipc	ra,0x5
     c6e:	faa080e7          	jalr	-86(ra) # 5c14 <exit>
    printf("%s: error: open big failed!\n", s);
     c72:	85d6                	mv	a1,s5
     c74:	00006517          	auipc	a0,0x6
     c78:	97c50513          	add	a0,a0,-1668 # 65f0 <malloc+0x59c>
     c7c:	00005097          	auipc	ra,0x5
     c80:	320080e7          	jalr	800(ra) # 5f9c <printf>
    exit(1);
     c84:	4505                	li	a0,1
     c86:	00005097          	auipc	ra,0x5
     c8a:	f8e080e7          	jalr	-114(ra) # 5c14 <exit>
      if(n == MAXFILE - 1){
     c8e:	10b00793          	li	a5,267
     c92:	02f48a63          	beq	s1,a5,cc6 <writebig+0x13e>
  close(fd);
     c96:	854e                	mv	a0,s3
     c98:	00005097          	auipc	ra,0x5
     c9c:	fa4080e7          	jalr	-92(ra) # 5c3c <close>
  if(unlink("big") < 0){
     ca0:	00006517          	auipc	a0,0x6
     ca4:	90050513          	add	a0,a0,-1792 # 65a0 <malloc+0x54c>
     ca8:	00005097          	auipc	ra,0x5
     cac:	fbc080e7          	jalr	-68(ra) # 5c64 <unlink>
     cb0:	06054963          	bltz	a0,d22 <writebig+0x19a>
}
     cb4:	70e2                	ld	ra,56(sp)
     cb6:	7442                	ld	s0,48(sp)
     cb8:	74a2                	ld	s1,40(sp)
     cba:	7902                	ld	s2,32(sp)
     cbc:	69e2                	ld	s3,24(sp)
     cbe:	6a42                	ld	s4,16(sp)
     cc0:	6aa2                	ld	s5,8(sp)
     cc2:	6121                	add	sp,sp,64
     cc4:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     cc6:	10b00613          	li	a2,267
     cca:	85d6                	mv	a1,s5
     ccc:	00006517          	auipc	a0,0x6
     cd0:	94450513          	add	a0,a0,-1724 # 6610 <malloc+0x5bc>
     cd4:	00005097          	auipc	ra,0x5
     cd8:	2c8080e7          	jalr	712(ra) # 5f9c <printf>
        exit(1);
     cdc:	4505                	li	a0,1
     cde:	00005097          	auipc	ra,0x5
     ce2:	f36080e7          	jalr	-202(ra) # 5c14 <exit>
      printf("%s: read failed %d\n", s, i);
     ce6:	862a                	mv	a2,a0
     ce8:	85d6                	mv	a1,s5
     cea:	00006517          	auipc	a0,0x6
     cee:	94e50513          	add	a0,a0,-1714 # 6638 <malloc+0x5e4>
     cf2:	00005097          	auipc	ra,0x5
     cf6:	2aa080e7          	jalr	682(ra) # 5f9c <printf>
      exit(1);
     cfa:	4505                	li	a0,1
     cfc:	00005097          	auipc	ra,0x5
     d00:	f18080e7          	jalr	-232(ra) # 5c14 <exit>
      printf("%s: read content of block %d is %d\n", s,
     d04:	8626                	mv	a2,s1
     d06:	85d6                	mv	a1,s5
     d08:	00006517          	auipc	a0,0x6
     d0c:	94850513          	add	a0,a0,-1720 # 6650 <malloc+0x5fc>
     d10:	00005097          	auipc	ra,0x5
     d14:	28c080e7          	jalr	652(ra) # 5f9c <printf>
      exit(1);
     d18:	4505                	li	a0,1
     d1a:	00005097          	auipc	ra,0x5
     d1e:	efa080e7          	jalr	-262(ra) # 5c14 <exit>
    printf("%s: unlink big failed\n", s);
     d22:	85d6                	mv	a1,s5
     d24:	00006517          	auipc	a0,0x6
     d28:	95450513          	add	a0,a0,-1708 # 6678 <malloc+0x624>
     d2c:	00005097          	auipc	ra,0x5
     d30:	270080e7          	jalr	624(ra) # 5f9c <printf>
    exit(1);
     d34:	4505                	li	a0,1
     d36:	00005097          	auipc	ra,0x5
     d3a:	ede080e7          	jalr	-290(ra) # 5c14 <exit>

0000000000000d3e <unlinkread>:
{
     d3e:	7179                	add	sp,sp,-48
     d40:	f406                	sd	ra,40(sp)
     d42:	f022                	sd	s0,32(sp)
     d44:	ec26                	sd	s1,24(sp)
     d46:	e84a                	sd	s2,16(sp)
     d48:	e44e                	sd	s3,8(sp)
     d4a:	1800                	add	s0,sp,48
     d4c:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     d4e:	20200593          	li	a1,514
     d52:	00006517          	auipc	a0,0x6
     d56:	93e50513          	add	a0,a0,-1730 # 6690 <malloc+0x63c>
     d5a:	00005097          	auipc	ra,0x5
     d5e:	efa080e7          	jalr	-262(ra) # 5c54 <open>
  if(fd < 0){
     d62:	0e054563          	bltz	a0,e4c <unlinkread+0x10e>
     d66:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     d68:	4615                	li	a2,5
     d6a:	00006597          	auipc	a1,0x6
     d6e:	95658593          	add	a1,a1,-1706 # 66c0 <malloc+0x66c>
     d72:	00005097          	auipc	ra,0x5
     d76:	ec2080e7          	jalr	-318(ra) # 5c34 <write>
  close(fd);
     d7a:	8526                	mv	a0,s1
     d7c:	00005097          	auipc	ra,0x5
     d80:	ec0080e7          	jalr	-320(ra) # 5c3c <close>
  fd = open("unlinkread", O_RDWR);
     d84:	4589                	li	a1,2
     d86:	00006517          	auipc	a0,0x6
     d8a:	90a50513          	add	a0,a0,-1782 # 6690 <malloc+0x63c>
     d8e:	00005097          	auipc	ra,0x5
     d92:	ec6080e7          	jalr	-314(ra) # 5c54 <open>
     d96:	84aa                	mv	s1,a0
  if(fd < 0){
     d98:	0c054863          	bltz	a0,e68 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
     d9c:	00006517          	auipc	a0,0x6
     da0:	8f450513          	add	a0,a0,-1804 # 6690 <malloc+0x63c>
     da4:	00005097          	auipc	ra,0x5
     da8:	ec0080e7          	jalr	-320(ra) # 5c64 <unlink>
     dac:	ed61                	bnez	a0,e84 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     dae:	20200593          	li	a1,514
     db2:	00006517          	auipc	a0,0x6
     db6:	8de50513          	add	a0,a0,-1826 # 6690 <malloc+0x63c>
     dba:	00005097          	auipc	ra,0x5
     dbe:	e9a080e7          	jalr	-358(ra) # 5c54 <open>
     dc2:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     dc4:	460d                	li	a2,3
     dc6:	00006597          	auipc	a1,0x6
     dca:	94258593          	add	a1,a1,-1726 # 6708 <malloc+0x6b4>
     dce:	00005097          	auipc	ra,0x5
     dd2:	e66080e7          	jalr	-410(ra) # 5c34 <write>
  close(fd1);
     dd6:	854a                	mv	a0,s2
     dd8:	00005097          	auipc	ra,0x5
     ddc:	e64080e7          	jalr	-412(ra) # 5c3c <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     de0:	660d                	lui	a2,0x3
     de2:	0000c597          	auipc	a1,0xc
     de6:	e9658593          	add	a1,a1,-362 # cc78 <buf>
     dea:	8526                	mv	a0,s1
     dec:	00005097          	auipc	ra,0x5
     df0:	e40080e7          	jalr	-448(ra) # 5c2c <read>
     df4:	4795                	li	a5,5
     df6:	0af51563          	bne	a0,a5,ea0 <unlinkread+0x162>
  if(buf[0] != 'h'){
     dfa:	0000c717          	auipc	a4,0xc
     dfe:	e7e74703          	lbu	a4,-386(a4) # cc78 <buf>
     e02:	06800793          	li	a5,104
     e06:	0af71b63          	bne	a4,a5,ebc <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
     e0a:	4629                	li	a2,10
     e0c:	0000c597          	auipc	a1,0xc
     e10:	e6c58593          	add	a1,a1,-404 # cc78 <buf>
     e14:	8526                	mv	a0,s1
     e16:	00005097          	auipc	ra,0x5
     e1a:	e1e080e7          	jalr	-482(ra) # 5c34 <write>
     e1e:	47a9                	li	a5,10
     e20:	0af51c63          	bne	a0,a5,ed8 <unlinkread+0x19a>
  close(fd);
     e24:	8526                	mv	a0,s1
     e26:	00005097          	auipc	ra,0x5
     e2a:	e16080e7          	jalr	-490(ra) # 5c3c <close>
  unlink("unlinkread");
     e2e:	00006517          	auipc	a0,0x6
     e32:	86250513          	add	a0,a0,-1950 # 6690 <malloc+0x63c>
     e36:	00005097          	auipc	ra,0x5
     e3a:	e2e080e7          	jalr	-466(ra) # 5c64 <unlink>
}
     e3e:	70a2                	ld	ra,40(sp)
     e40:	7402                	ld	s0,32(sp)
     e42:	64e2                	ld	s1,24(sp)
     e44:	6942                	ld	s2,16(sp)
     e46:	69a2                	ld	s3,8(sp)
     e48:	6145                	add	sp,sp,48
     e4a:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     e4c:	85ce                	mv	a1,s3
     e4e:	00006517          	auipc	a0,0x6
     e52:	85250513          	add	a0,a0,-1966 # 66a0 <malloc+0x64c>
     e56:	00005097          	auipc	ra,0x5
     e5a:	146080e7          	jalr	326(ra) # 5f9c <printf>
    exit(1);
     e5e:	4505                	li	a0,1
     e60:	00005097          	auipc	ra,0x5
     e64:	db4080e7          	jalr	-588(ra) # 5c14 <exit>
    printf("%s: open unlinkread failed\n", s);
     e68:	85ce                	mv	a1,s3
     e6a:	00006517          	auipc	a0,0x6
     e6e:	85e50513          	add	a0,a0,-1954 # 66c8 <malloc+0x674>
     e72:	00005097          	auipc	ra,0x5
     e76:	12a080e7          	jalr	298(ra) # 5f9c <printf>
    exit(1);
     e7a:	4505                	li	a0,1
     e7c:	00005097          	auipc	ra,0x5
     e80:	d98080e7          	jalr	-616(ra) # 5c14 <exit>
    printf("%s: unlink unlinkread failed\n", s);
     e84:	85ce                	mv	a1,s3
     e86:	00006517          	auipc	a0,0x6
     e8a:	86250513          	add	a0,a0,-1950 # 66e8 <malloc+0x694>
     e8e:	00005097          	auipc	ra,0x5
     e92:	10e080e7          	jalr	270(ra) # 5f9c <printf>
    exit(1);
     e96:	4505                	li	a0,1
     e98:	00005097          	auipc	ra,0x5
     e9c:	d7c080e7          	jalr	-644(ra) # 5c14 <exit>
    printf("%s: unlinkread read failed", s);
     ea0:	85ce                	mv	a1,s3
     ea2:	00006517          	auipc	a0,0x6
     ea6:	86e50513          	add	a0,a0,-1938 # 6710 <malloc+0x6bc>
     eaa:	00005097          	auipc	ra,0x5
     eae:	0f2080e7          	jalr	242(ra) # 5f9c <printf>
    exit(1);
     eb2:	4505                	li	a0,1
     eb4:	00005097          	auipc	ra,0x5
     eb8:	d60080e7          	jalr	-672(ra) # 5c14 <exit>
    printf("%s: unlinkread wrong data\n", s);
     ebc:	85ce                	mv	a1,s3
     ebe:	00006517          	auipc	a0,0x6
     ec2:	87250513          	add	a0,a0,-1934 # 6730 <malloc+0x6dc>
     ec6:	00005097          	auipc	ra,0x5
     eca:	0d6080e7          	jalr	214(ra) # 5f9c <printf>
    exit(1);
     ece:	4505                	li	a0,1
     ed0:	00005097          	auipc	ra,0x5
     ed4:	d44080e7          	jalr	-700(ra) # 5c14 <exit>
    printf("%s: unlinkread write failed\n", s);
     ed8:	85ce                	mv	a1,s3
     eda:	00006517          	auipc	a0,0x6
     ede:	87650513          	add	a0,a0,-1930 # 6750 <malloc+0x6fc>
     ee2:	00005097          	auipc	ra,0x5
     ee6:	0ba080e7          	jalr	186(ra) # 5f9c <printf>
    exit(1);
     eea:	4505                	li	a0,1
     eec:	00005097          	auipc	ra,0x5
     ef0:	d28080e7          	jalr	-728(ra) # 5c14 <exit>

0000000000000ef4 <linktest>:
{
     ef4:	1101                	add	sp,sp,-32
     ef6:	ec06                	sd	ra,24(sp)
     ef8:	e822                	sd	s0,16(sp)
     efa:	e426                	sd	s1,8(sp)
     efc:	e04a                	sd	s2,0(sp)
     efe:	1000                	add	s0,sp,32
     f00:	892a                	mv	s2,a0
  unlink("lf1");
     f02:	00006517          	auipc	a0,0x6
     f06:	86e50513          	add	a0,a0,-1938 # 6770 <malloc+0x71c>
     f0a:	00005097          	auipc	ra,0x5
     f0e:	d5a080e7          	jalr	-678(ra) # 5c64 <unlink>
  unlink("lf2");
     f12:	00006517          	auipc	a0,0x6
     f16:	86650513          	add	a0,a0,-1946 # 6778 <malloc+0x724>
     f1a:	00005097          	auipc	ra,0x5
     f1e:	d4a080e7          	jalr	-694(ra) # 5c64 <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     f22:	20200593          	li	a1,514
     f26:	00006517          	auipc	a0,0x6
     f2a:	84a50513          	add	a0,a0,-1974 # 6770 <malloc+0x71c>
     f2e:	00005097          	auipc	ra,0x5
     f32:	d26080e7          	jalr	-730(ra) # 5c54 <open>
  if(fd < 0){
     f36:	10054763          	bltz	a0,1044 <linktest+0x150>
     f3a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     f3c:	4615                	li	a2,5
     f3e:	00005597          	auipc	a1,0x5
     f42:	78258593          	add	a1,a1,1922 # 66c0 <malloc+0x66c>
     f46:	00005097          	auipc	ra,0x5
     f4a:	cee080e7          	jalr	-786(ra) # 5c34 <write>
     f4e:	4795                	li	a5,5
     f50:	10f51863          	bne	a0,a5,1060 <linktest+0x16c>
  close(fd);
     f54:	8526                	mv	a0,s1
     f56:	00005097          	auipc	ra,0x5
     f5a:	ce6080e7          	jalr	-794(ra) # 5c3c <close>
  if(link("lf1", "lf2") < 0){
     f5e:	00006597          	auipc	a1,0x6
     f62:	81a58593          	add	a1,a1,-2022 # 6778 <malloc+0x724>
     f66:	00006517          	auipc	a0,0x6
     f6a:	80a50513          	add	a0,a0,-2038 # 6770 <malloc+0x71c>
     f6e:	00005097          	auipc	ra,0x5
     f72:	d06080e7          	jalr	-762(ra) # 5c74 <link>
     f76:	10054363          	bltz	a0,107c <linktest+0x188>
  unlink("lf1");
     f7a:	00005517          	auipc	a0,0x5
     f7e:	7f650513          	add	a0,a0,2038 # 6770 <malloc+0x71c>
     f82:	00005097          	auipc	ra,0x5
     f86:	ce2080e7          	jalr	-798(ra) # 5c64 <unlink>
  if(open("lf1", 0) >= 0){
     f8a:	4581                	li	a1,0
     f8c:	00005517          	auipc	a0,0x5
     f90:	7e450513          	add	a0,a0,2020 # 6770 <malloc+0x71c>
     f94:	00005097          	auipc	ra,0x5
     f98:	cc0080e7          	jalr	-832(ra) # 5c54 <open>
     f9c:	0e055e63          	bgez	a0,1098 <linktest+0x1a4>
  fd = open("lf2", 0);
     fa0:	4581                	li	a1,0
     fa2:	00005517          	auipc	a0,0x5
     fa6:	7d650513          	add	a0,a0,2006 # 6778 <malloc+0x724>
     faa:	00005097          	auipc	ra,0x5
     fae:	caa080e7          	jalr	-854(ra) # 5c54 <open>
     fb2:	84aa                	mv	s1,a0
  if(fd < 0){
     fb4:	10054063          	bltz	a0,10b4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
     fb8:	660d                	lui	a2,0x3
     fba:	0000c597          	auipc	a1,0xc
     fbe:	cbe58593          	add	a1,a1,-834 # cc78 <buf>
     fc2:	00005097          	auipc	ra,0x5
     fc6:	c6a080e7          	jalr	-918(ra) # 5c2c <read>
     fca:	4795                	li	a5,5
     fcc:	10f51263          	bne	a0,a5,10d0 <linktest+0x1dc>
  close(fd);
     fd0:	8526                	mv	a0,s1
     fd2:	00005097          	auipc	ra,0x5
     fd6:	c6a080e7          	jalr	-918(ra) # 5c3c <close>
  if(link("lf2", "lf2") >= 0){
     fda:	00005597          	auipc	a1,0x5
     fde:	79e58593          	add	a1,a1,1950 # 6778 <malloc+0x724>
     fe2:	852e                	mv	a0,a1
     fe4:	00005097          	auipc	ra,0x5
     fe8:	c90080e7          	jalr	-880(ra) # 5c74 <link>
     fec:	10055063          	bgez	a0,10ec <linktest+0x1f8>
  unlink("lf2");
     ff0:	00005517          	auipc	a0,0x5
     ff4:	78850513          	add	a0,a0,1928 # 6778 <malloc+0x724>
     ff8:	00005097          	auipc	ra,0x5
     ffc:	c6c080e7          	jalr	-916(ra) # 5c64 <unlink>
  if(link("lf2", "lf1") >= 0){
    1000:	00005597          	auipc	a1,0x5
    1004:	77058593          	add	a1,a1,1904 # 6770 <malloc+0x71c>
    1008:	00005517          	auipc	a0,0x5
    100c:	77050513          	add	a0,a0,1904 # 6778 <malloc+0x724>
    1010:	00005097          	auipc	ra,0x5
    1014:	c64080e7          	jalr	-924(ra) # 5c74 <link>
    1018:	0e055863          	bgez	a0,1108 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    101c:	00005597          	auipc	a1,0x5
    1020:	75458593          	add	a1,a1,1876 # 6770 <malloc+0x71c>
    1024:	00006517          	auipc	a0,0x6
    1028:	85c50513          	add	a0,a0,-1956 # 6880 <malloc+0x82c>
    102c:	00005097          	auipc	ra,0x5
    1030:	c48080e7          	jalr	-952(ra) # 5c74 <link>
    1034:	0e055863          	bgez	a0,1124 <linktest+0x230>
}
    1038:	60e2                	ld	ra,24(sp)
    103a:	6442                	ld	s0,16(sp)
    103c:	64a2                	ld	s1,8(sp)
    103e:	6902                	ld	s2,0(sp)
    1040:	6105                	add	sp,sp,32
    1042:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    1044:	85ca                	mv	a1,s2
    1046:	00005517          	auipc	a0,0x5
    104a:	73a50513          	add	a0,a0,1850 # 6780 <malloc+0x72c>
    104e:	00005097          	auipc	ra,0x5
    1052:	f4e080e7          	jalr	-178(ra) # 5f9c <printf>
    exit(1);
    1056:	4505                	li	a0,1
    1058:	00005097          	auipc	ra,0x5
    105c:	bbc080e7          	jalr	-1092(ra) # 5c14 <exit>
    printf("%s: write lf1 failed\n", s);
    1060:	85ca                	mv	a1,s2
    1062:	00005517          	auipc	a0,0x5
    1066:	73650513          	add	a0,a0,1846 # 6798 <malloc+0x744>
    106a:	00005097          	auipc	ra,0x5
    106e:	f32080e7          	jalr	-206(ra) # 5f9c <printf>
    exit(1);
    1072:	4505                	li	a0,1
    1074:	00005097          	auipc	ra,0x5
    1078:	ba0080e7          	jalr	-1120(ra) # 5c14 <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    107c:	85ca                	mv	a1,s2
    107e:	00005517          	auipc	a0,0x5
    1082:	73250513          	add	a0,a0,1842 # 67b0 <malloc+0x75c>
    1086:	00005097          	auipc	ra,0x5
    108a:	f16080e7          	jalr	-234(ra) # 5f9c <printf>
    exit(1);
    108e:	4505                	li	a0,1
    1090:	00005097          	auipc	ra,0x5
    1094:	b84080e7          	jalr	-1148(ra) # 5c14 <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    1098:	85ca                	mv	a1,s2
    109a:	00005517          	auipc	a0,0x5
    109e:	73650513          	add	a0,a0,1846 # 67d0 <malloc+0x77c>
    10a2:	00005097          	auipc	ra,0x5
    10a6:	efa080e7          	jalr	-262(ra) # 5f9c <printf>
    exit(1);
    10aa:	4505                	li	a0,1
    10ac:	00005097          	auipc	ra,0x5
    10b0:	b68080e7          	jalr	-1176(ra) # 5c14 <exit>
    printf("%s: open lf2 failed\n", s);
    10b4:	85ca                	mv	a1,s2
    10b6:	00005517          	auipc	a0,0x5
    10ba:	74a50513          	add	a0,a0,1866 # 6800 <malloc+0x7ac>
    10be:	00005097          	auipc	ra,0x5
    10c2:	ede080e7          	jalr	-290(ra) # 5f9c <printf>
    exit(1);
    10c6:	4505                	li	a0,1
    10c8:	00005097          	auipc	ra,0x5
    10cc:	b4c080e7          	jalr	-1204(ra) # 5c14 <exit>
    printf("%s: read lf2 failed\n", s);
    10d0:	85ca                	mv	a1,s2
    10d2:	00005517          	auipc	a0,0x5
    10d6:	74650513          	add	a0,a0,1862 # 6818 <malloc+0x7c4>
    10da:	00005097          	auipc	ra,0x5
    10de:	ec2080e7          	jalr	-318(ra) # 5f9c <printf>
    exit(1);
    10e2:	4505                	li	a0,1
    10e4:	00005097          	auipc	ra,0x5
    10e8:	b30080e7          	jalr	-1232(ra) # 5c14 <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    10ec:	85ca                	mv	a1,s2
    10ee:	00005517          	auipc	a0,0x5
    10f2:	74250513          	add	a0,a0,1858 # 6830 <malloc+0x7dc>
    10f6:	00005097          	auipc	ra,0x5
    10fa:	ea6080e7          	jalr	-346(ra) # 5f9c <printf>
    exit(1);
    10fe:	4505                	li	a0,1
    1100:	00005097          	auipc	ra,0x5
    1104:	b14080e7          	jalr	-1260(ra) # 5c14 <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
    1108:	85ca                	mv	a1,s2
    110a:	00005517          	auipc	a0,0x5
    110e:	74e50513          	add	a0,a0,1870 # 6858 <malloc+0x804>
    1112:	00005097          	auipc	ra,0x5
    1116:	e8a080e7          	jalr	-374(ra) # 5f9c <printf>
    exit(1);
    111a:	4505                	li	a0,1
    111c:	00005097          	auipc	ra,0x5
    1120:	af8080e7          	jalr	-1288(ra) # 5c14 <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    1124:	85ca                	mv	a1,s2
    1126:	00005517          	auipc	a0,0x5
    112a:	76250513          	add	a0,a0,1890 # 6888 <malloc+0x834>
    112e:	00005097          	auipc	ra,0x5
    1132:	e6e080e7          	jalr	-402(ra) # 5f9c <printf>
    exit(1);
    1136:	4505                	li	a0,1
    1138:	00005097          	auipc	ra,0x5
    113c:	adc080e7          	jalr	-1316(ra) # 5c14 <exit>

0000000000001140 <validatetest>:
{
    1140:	7139                	add	sp,sp,-64
    1142:	fc06                	sd	ra,56(sp)
    1144:	f822                	sd	s0,48(sp)
    1146:	f426                	sd	s1,40(sp)
    1148:	f04a                	sd	s2,32(sp)
    114a:	ec4e                	sd	s3,24(sp)
    114c:	e852                	sd	s4,16(sp)
    114e:	e456                	sd	s5,8(sp)
    1150:	e05a                	sd	s6,0(sp)
    1152:	0080                	add	s0,sp,64
    1154:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1156:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    1158:	00005997          	auipc	s3,0x5
    115c:	75098993          	add	s3,s3,1872 # 68a8 <malloc+0x854>
    1160:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1162:	6a85                	lui	s5,0x1
    1164:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    1168:	85a6                	mv	a1,s1
    116a:	854e                	mv	a0,s3
    116c:	00005097          	auipc	ra,0x5
    1170:	b08080e7          	jalr	-1272(ra) # 5c74 <link>
    1174:	01251f63          	bne	a0,s2,1192 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    1178:	94d6                	add	s1,s1,s5
    117a:	ff4497e3          	bne	s1,s4,1168 <validatetest+0x28>
}
    117e:	70e2                	ld	ra,56(sp)
    1180:	7442                	ld	s0,48(sp)
    1182:	74a2                	ld	s1,40(sp)
    1184:	7902                	ld	s2,32(sp)
    1186:	69e2                	ld	s3,24(sp)
    1188:	6a42                	ld	s4,16(sp)
    118a:	6aa2                	ld	s5,8(sp)
    118c:	6b02                	ld	s6,0(sp)
    118e:	6121                	add	sp,sp,64
    1190:	8082                	ret
      printf("%s: link should not succeed\n", s);
    1192:	85da                	mv	a1,s6
    1194:	00005517          	auipc	a0,0x5
    1198:	72450513          	add	a0,a0,1828 # 68b8 <malloc+0x864>
    119c:	00005097          	auipc	ra,0x5
    11a0:	e00080e7          	jalr	-512(ra) # 5f9c <printf>
      exit(1);
    11a4:	4505                	li	a0,1
    11a6:	00005097          	auipc	ra,0x5
    11aa:	a6e080e7          	jalr	-1426(ra) # 5c14 <exit>

00000000000011ae <bigdir>:
{
    11ae:	715d                	add	sp,sp,-80
    11b0:	e486                	sd	ra,72(sp)
    11b2:	e0a2                	sd	s0,64(sp)
    11b4:	fc26                	sd	s1,56(sp)
    11b6:	f84a                	sd	s2,48(sp)
    11b8:	f44e                	sd	s3,40(sp)
    11ba:	f052                	sd	s4,32(sp)
    11bc:	ec56                	sd	s5,24(sp)
    11be:	e85a                	sd	s6,16(sp)
    11c0:	0880                	add	s0,sp,80
    11c2:	89aa                	mv	s3,a0
  unlink("bd");
    11c4:	00005517          	auipc	a0,0x5
    11c8:	71450513          	add	a0,a0,1812 # 68d8 <malloc+0x884>
    11cc:	00005097          	auipc	ra,0x5
    11d0:	a98080e7          	jalr	-1384(ra) # 5c64 <unlink>
  fd = open("bd", O_CREATE);
    11d4:	20000593          	li	a1,512
    11d8:	00005517          	auipc	a0,0x5
    11dc:	70050513          	add	a0,a0,1792 # 68d8 <malloc+0x884>
    11e0:	00005097          	auipc	ra,0x5
    11e4:	a74080e7          	jalr	-1420(ra) # 5c54 <open>
  if(fd < 0){
    11e8:	0c054963          	bltz	a0,12ba <bigdir+0x10c>
  close(fd);
    11ec:	00005097          	auipc	ra,0x5
    11f0:	a50080e7          	jalr	-1456(ra) # 5c3c <close>
  for(i = 0; i < N; i++){
    11f4:	4901                	li	s2,0
    name[0] = 'x';
    11f6:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    11fa:	00005a17          	auipc	s4,0x5
    11fe:	6dea0a13          	add	s4,s4,1758 # 68d8 <malloc+0x884>
  for(i = 0; i < N; i++){
    1202:	1f400b13          	li	s6,500
    name[0] = 'x';
    1206:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    120a:	41f9571b          	sraw	a4,s2,0x1f
    120e:	01a7571b          	srlw	a4,a4,0x1a
    1212:	012707bb          	addw	a5,a4,s2
    1216:	4067d69b          	sraw	a3,a5,0x6
    121a:	0306869b          	addw	a3,a3,48
    121e:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1222:	03f7f793          	and	a5,a5,63
    1226:	9f99                	subw	a5,a5,a4
    1228:	0307879b          	addw	a5,a5,48
    122c:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    1230:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    1234:	fb040593          	add	a1,s0,-80
    1238:	8552                	mv	a0,s4
    123a:	00005097          	auipc	ra,0x5
    123e:	a3a080e7          	jalr	-1478(ra) # 5c74 <link>
    1242:	84aa                	mv	s1,a0
    1244:	e949                	bnez	a0,12d6 <bigdir+0x128>
  for(i = 0; i < N; i++){
    1246:	2905                	addw	s2,s2,1
    1248:	fb691fe3          	bne	s2,s6,1206 <bigdir+0x58>
  unlink("bd");
    124c:	00005517          	auipc	a0,0x5
    1250:	68c50513          	add	a0,a0,1676 # 68d8 <malloc+0x884>
    1254:	00005097          	auipc	ra,0x5
    1258:	a10080e7          	jalr	-1520(ra) # 5c64 <unlink>
    name[0] = 'x';
    125c:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    1260:	1f400a13          	li	s4,500
    name[0] = 'x';
    1264:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    1268:	41f4d71b          	sraw	a4,s1,0x1f
    126c:	01a7571b          	srlw	a4,a4,0x1a
    1270:	009707bb          	addw	a5,a4,s1
    1274:	4067d69b          	sraw	a3,a5,0x6
    1278:	0306869b          	addw	a3,a3,48
    127c:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    1280:	03f7f793          	and	a5,a5,63
    1284:	9f99                	subw	a5,a5,a4
    1286:	0307879b          	addw	a5,a5,48
    128a:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    128e:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    1292:	fb040513          	add	a0,s0,-80
    1296:	00005097          	auipc	ra,0x5
    129a:	9ce080e7          	jalr	-1586(ra) # 5c64 <unlink>
    129e:	ed21                	bnez	a0,12f6 <bigdir+0x148>
  for(i = 0; i < N; i++){
    12a0:	2485                	addw	s1,s1,1
    12a2:	fd4491e3          	bne	s1,s4,1264 <bigdir+0xb6>
}
    12a6:	60a6                	ld	ra,72(sp)
    12a8:	6406                	ld	s0,64(sp)
    12aa:	74e2                	ld	s1,56(sp)
    12ac:	7942                	ld	s2,48(sp)
    12ae:	79a2                	ld	s3,40(sp)
    12b0:	7a02                	ld	s4,32(sp)
    12b2:	6ae2                	ld	s5,24(sp)
    12b4:	6b42                	ld	s6,16(sp)
    12b6:	6161                	add	sp,sp,80
    12b8:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    12ba:	85ce                	mv	a1,s3
    12bc:	00005517          	auipc	a0,0x5
    12c0:	62450513          	add	a0,a0,1572 # 68e0 <malloc+0x88c>
    12c4:	00005097          	auipc	ra,0x5
    12c8:	cd8080e7          	jalr	-808(ra) # 5f9c <printf>
    exit(1);
    12cc:	4505                	li	a0,1
    12ce:	00005097          	auipc	ra,0x5
    12d2:	946080e7          	jalr	-1722(ra) # 5c14 <exit>
      printf("%s: bigdir link(bd, %s) failed\n", s, name);
    12d6:	fb040613          	add	a2,s0,-80
    12da:	85ce                	mv	a1,s3
    12dc:	00005517          	auipc	a0,0x5
    12e0:	62450513          	add	a0,a0,1572 # 6900 <malloc+0x8ac>
    12e4:	00005097          	auipc	ra,0x5
    12e8:	cb8080e7          	jalr	-840(ra) # 5f9c <printf>
      exit(1);
    12ec:	4505                	li	a0,1
    12ee:	00005097          	auipc	ra,0x5
    12f2:	926080e7          	jalr	-1754(ra) # 5c14 <exit>
      printf("%s: bigdir unlink failed", s);
    12f6:	85ce                	mv	a1,s3
    12f8:	00005517          	auipc	a0,0x5
    12fc:	62850513          	add	a0,a0,1576 # 6920 <malloc+0x8cc>
    1300:	00005097          	auipc	ra,0x5
    1304:	c9c080e7          	jalr	-868(ra) # 5f9c <printf>
      exit(1);
    1308:	4505                	li	a0,1
    130a:	00005097          	auipc	ra,0x5
    130e:	90a080e7          	jalr	-1782(ra) # 5c14 <exit>

0000000000001312 <pgbug>:
{
    1312:	7179                	add	sp,sp,-48
    1314:	f406                	sd	ra,40(sp)
    1316:	f022                	sd	s0,32(sp)
    1318:	ec26                	sd	s1,24(sp)
    131a:	1800                	add	s0,sp,48
  argv[0] = 0;
    131c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1320:	00008497          	auipc	s1,0x8
    1324:	ce048493          	add	s1,s1,-800 # 9000 <big>
    1328:	fd840593          	add	a1,s0,-40
    132c:	6088                	ld	a0,0(s1)
    132e:	00005097          	auipc	ra,0x5
    1332:	91e080e7          	jalr	-1762(ra) # 5c4c <exec>
  pipe(big);
    1336:	6088                	ld	a0,0(s1)
    1338:	00005097          	auipc	ra,0x5
    133c:	8ec080e7          	jalr	-1812(ra) # 5c24 <pipe>
  exit(0);
    1340:	4501                	li	a0,0
    1342:	00005097          	auipc	ra,0x5
    1346:	8d2080e7          	jalr	-1838(ra) # 5c14 <exit>

000000000000134a <badarg>:
{
    134a:	7139                	add	sp,sp,-64
    134c:	fc06                	sd	ra,56(sp)
    134e:	f822                	sd	s0,48(sp)
    1350:	f426                	sd	s1,40(sp)
    1352:	f04a                	sd	s2,32(sp)
    1354:	ec4e                	sd	s3,24(sp)
    1356:	0080                	add	s0,sp,64
    1358:	64b1                	lui	s1,0xc
    135a:	35048493          	add	s1,s1,848 # c350 <uninit+0x1de8>
    argv[0] = (char*)0xffffffff;
    135e:	597d                	li	s2,-1
    1360:	02095913          	srl	s2,s2,0x20
    exec("echo", argv);
    1364:	00005997          	auipc	s3,0x5
    1368:	e3498993          	add	s3,s3,-460 # 6198 <malloc+0x144>
    argv[0] = (char*)0xffffffff;
    136c:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1370:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1374:	fc040593          	add	a1,s0,-64
    1378:	854e                	mv	a0,s3
    137a:	00005097          	auipc	ra,0x5
    137e:	8d2080e7          	jalr	-1838(ra) # 5c4c <exec>
  for(int i = 0; i < 50000; i++){
    1382:	34fd                	addw	s1,s1,-1
    1384:	f4e5                	bnez	s1,136c <badarg+0x22>
  exit(0);
    1386:	4501                	li	a0,0
    1388:	00005097          	auipc	ra,0x5
    138c:	88c080e7          	jalr	-1908(ra) # 5c14 <exit>

0000000000001390 <copyinstr2>:
{
    1390:	7155                	add	sp,sp,-208
    1392:	e586                	sd	ra,200(sp)
    1394:	e1a2                	sd	s0,192(sp)
    1396:	0980                	add	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    1398:	f6840793          	add	a5,s0,-152
    139c:	fe840693          	add	a3,s0,-24
    b[i] = 'x';
    13a0:	07800713          	li	a4,120
    13a4:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    13a8:	0785                	add	a5,a5,1
    13aa:	fed79de3          	bne	a5,a3,13a4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    13ae:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    13b2:	f6840513          	add	a0,s0,-152
    13b6:	00005097          	auipc	ra,0x5
    13ba:	8ae080e7          	jalr	-1874(ra) # 5c64 <unlink>
  if(ret != -1){
    13be:	57fd                	li	a5,-1
    13c0:	0ef51063          	bne	a0,a5,14a0 <copyinstr2+0x110>
  int fd = open(b, O_CREATE | O_WRONLY);
    13c4:	20100593          	li	a1,513
    13c8:	f6840513          	add	a0,s0,-152
    13cc:	00005097          	auipc	ra,0x5
    13d0:	888080e7          	jalr	-1912(ra) # 5c54 <open>
  if(fd != -1){
    13d4:	57fd                	li	a5,-1
    13d6:	0ef51563          	bne	a0,a5,14c0 <copyinstr2+0x130>
  ret = link(b, b);
    13da:	f6840593          	add	a1,s0,-152
    13de:	852e                	mv	a0,a1
    13e0:	00005097          	auipc	ra,0x5
    13e4:	894080e7          	jalr	-1900(ra) # 5c74 <link>
  if(ret != -1){
    13e8:	57fd                	li	a5,-1
    13ea:	0ef51b63          	bne	a0,a5,14e0 <copyinstr2+0x150>
  char *args[] = { "xx", 0 };
    13ee:	00006797          	auipc	a5,0x6
    13f2:	78a78793          	add	a5,a5,1930 # 7b78 <malloc+0x1b24>
    13f6:	f4f43c23          	sd	a5,-168(s0)
    13fa:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    13fe:	f5840593          	add	a1,s0,-168
    1402:	f6840513          	add	a0,s0,-152
    1406:	00005097          	auipc	ra,0x5
    140a:	846080e7          	jalr	-1978(ra) # 5c4c <exec>
  if(ret != -1){
    140e:	57fd                	li	a5,-1
    1410:	0ef51963          	bne	a0,a5,1502 <copyinstr2+0x172>
  int pid = fork();
    1414:	00004097          	auipc	ra,0x4
    1418:	7f8080e7          	jalr	2040(ra) # 5c0c <fork>
  if(pid < 0){
    141c:	10054363          	bltz	a0,1522 <copyinstr2+0x192>
  if(pid == 0){
    1420:	12051463          	bnez	a0,1548 <copyinstr2+0x1b8>
    1424:	00008797          	auipc	a5,0x8
    1428:	13c78793          	add	a5,a5,316 # 9560 <big.0>
    142c:	00009697          	auipc	a3,0x9
    1430:	13468693          	add	a3,a3,308 # a560 <big.0+0x1000>
      big[i] = 'x';
    1434:	07800713          	li	a4,120
    1438:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    143c:	0785                	add	a5,a5,1
    143e:	fed79de3          	bne	a5,a3,1438 <copyinstr2+0xa8>
    big[PGSIZE] = '\0';
    1442:	00009797          	auipc	a5,0x9
    1446:	10078f23          	sb	zero,286(a5) # a560 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    144a:	00007797          	auipc	a5,0x7
    144e:	17678793          	add	a5,a5,374 # 85c0 <malloc+0x256c>
    1452:	6390                	ld	a2,0(a5)
    1454:	6794                	ld	a3,8(a5)
    1456:	6b98                	ld	a4,16(a5)
    1458:	6f9c                	ld	a5,24(a5)
    145a:	f2c43823          	sd	a2,-208(s0)
    145e:	f2d43c23          	sd	a3,-200(s0)
    1462:	f4e43023          	sd	a4,-192(s0)
    1466:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    146a:	f3040593          	add	a1,s0,-208
    146e:	00005517          	auipc	a0,0x5
    1472:	d2a50513          	add	a0,a0,-726 # 6198 <malloc+0x144>
    1476:	00004097          	auipc	ra,0x4
    147a:	7d6080e7          	jalr	2006(ra) # 5c4c <exec>
    if(ret != -1){
    147e:	57fd                	li	a5,-1
    1480:	0af50e63          	beq	a0,a5,153c <copyinstr2+0x1ac>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1484:	55fd                	li	a1,-1
    1486:	00005517          	auipc	a0,0x5
    148a:	54250513          	add	a0,a0,1346 # 69c8 <malloc+0x974>
    148e:	00005097          	auipc	ra,0x5
    1492:	b0e080e7          	jalr	-1266(ra) # 5f9c <printf>
      exit(1);
    1496:	4505                	li	a0,1
    1498:	00004097          	auipc	ra,0x4
    149c:	77c080e7          	jalr	1916(ra) # 5c14 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    14a0:	862a                	mv	a2,a0
    14a2:	f6840593          	add	a1,s0,-152
    14a6:	00005517          	auipc	a0,0x5
    14aa:	49a50513          	add	a0,a0,1178 # 6940 <malloc+0x8ec>
    14ae:	00005097          	auipc	ra,0x5
    14b2:	aee080e7          	jalr	-1298(ra) # 5f9c <printf>
    exit(1);
    14b6:	4505                	li	a0,1
    14b8:	00004097          	auipc	ra,0x4
    14bc:	75c080e7          	jalr	1884(ra) # 5c14 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    14c0:	862a                	mv	a2,a0
    14c2:	f6840593          	add	a1,s0,-152
    14c6:	00005517          	auipc	a0,0x5
    14ca:	49a50513          	add	a0,a0,1178 # 6960 <malloc+0x90c>
    14ce:	00005097          	auipc	ra,0x5
    14d2:	ace080e7          	jalr	-1330(ra) # 5f9c <printf>
    exit(1);
    14d6:	4505                	li	a0,1
    14d8:	00004097          	auipc	ra,0x4
    14dc:	73c080e7          	jalr	1852(ra) # 5c14 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    14e0:	86aa                	mv	a3,a0
    14e2:	f6840613          	add	a2,s0,-152
    14e6:	85b2                	mv	a1,a2
    14e8:	00005517          	auipc	a0,0x5
    14ec:	49850513          	add	a0,a0,1176 # 6980 <malloc+0x92c>
    14f0:	00005097          	auipc	ra,0x5
    14f4:	aac080e7          	jalr	-1364(ra) # 5f9c <printf>
    exit(1);
    14f8:	4505                	li	a0,1
    14fa:	00004097          	auipc	ra,0x4
    14fe:	71a080e7          	jalr	1818(ra) # 5c14 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1502:	567d                	li	a2,-1
    1504:	f6840593          	add	a1,s0,-152
    1508:	00005517          	auipc	a0,0x5
    150c:	4a050513          	add	a0,a0,1184 # 69a8 <malloc+0x954>
    1510:	00005097          	auipc	ra,0x5
    1514:	a8c080e7          	jalr	-1396(ra) # 5f9c <printf>
    exit(1);
    1518:	4505                	li	a0,1
    151a:	00004097          	auipc	ra,0x4
    151e:	6fa080e7          	jalr	1786(ra) # 5c14 <exit>
    printf("fork failed\n");
    1522:	00006517          	auipc	a0,0x6
    1526:	90650513          	add	a0,a0,-1786 # 6e28 <malloc+0xdd4>
    152a:	00005097          	auipc	ra,0x5
    152e:	a72080e7          	jalr	-1422(ra) # 5f9c <printf>
    exit(1);
    1532:	4505                	li	a0,1
    1534:	00004097          	auipc	ra,0x4
    1538:	6e0080e7          	jalr	1760(ra) # 5c14 <exit>
    exit(747); // OK
    153c:	2eb00513          	li	a0,747
    1540:	00004097          	auipc	ra,0x4
    1544:	6d4080e7          	jalr	1748(ra) # 5c14 <exit>
  int st = 0;
    1548:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    154c:	f5440513          	add	a0,s0,-172
    1550:	00004097          	auipc	ra,0x4
    1554:	6cc080e7          	jalr	1740(ra) # 5c1c <wait>
  if(st != 747){
    1558:	f5442703          	lw	a4,-172(s0)
    155c:	2eb00793          	li	a5,747
    1560:	00f71663          	bne	a4,a5,156c <copyinstr2+0x1dc>
}
    1564:	60ae                	ld	ra,200(sp)
    1566:	640e                	ld	s0,192(sp)
    1568:	6169                	add	sp,sp,208
    156a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    156c:	00005517          	auipc	a0,0x5
    1570:	48450513          	add	a0,a0,1156 # 69f0 <malloc+0x99c>
    1574:	00005097          	auipc	ra,0x5
    1578:	a28080e7          	jalr	-1496(ra) # 5f9c <printf>
    exit(1);
    157c:	4505                	li	a0,1
    157e:	00004097          	auipc	ra,0x4
    1582:	696080e7          	jalr	1686(ra) # 5c14 <exit>

0000000000001586 <truncate3>:
{
    1586:	7159                	add	sp,sp,-112
    1588:	f486                	sd	ra,104(sp)
    158a:	f0a2                	sd	s0,96(sp)
    158c:	e8ca                	sd	s2,80(sp)
    158e:	1880                	add	s0,sp,112
    1590:	892a                	mv	s2,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    1592:	60100593          	li	a1,1537
    1596:	00005517          	auipc	a0,0x5
    159a:	c5a50513          	add	a0,a0,-934 # 61f0 <malloc+0x19c>
    159e:	00004097          	auipc	ra,0x4
    15a2:	6b6080e7          	jalr	1718(ra) # 5c54 <open>
    15a6:	00004097          	auipc	ra,0x4
    15aa:	696080e7          	jalr	1686(ra) # 5c3c <close>
  pid = fork();
    15ae:	00004097          	auipc	ra,0x4
    15b2:	65e080e7          	jalr	1630(ra) # 5c0c <fork>
  if(pid < 0){
    15b6:	08054463          	bltz	a0,163e <truncate3+0xb8>
  if(pid == 0){
    15ba:	e16d                	bnez	a0,169c <truncate3+0x116>
    15bc:	eca6                	sd	s1,88(sp)
    15be:	e4ce                	sd	s3,72(sp)
    15c0:	e0d2                	sd	s4,64(sp)
    15c2:	fc56                	sd	s5,56(sp)
    15c4:	06400993          	li	s3,100
      int fd = open("truncfile", O_WRONLY);
    15c8:	00005a17          	auipc	s4,0x5
    15cc:	c28a0a13          	add	s4,s4,-984 # 61f0 <malloc+0x19c>
      int n = write(fd, "1234567890", 10);
    15d0:	00005a97          	auipc	s5,0x5
    15d4:	480a8a93          	add	s5,s5,1152 # 6a50 <malloc+0x9fc>
      int fd = open("truncfile", O_WRONLY);
    15d8:	4585                	li	a1,1
    15da:	8552                	mv	a0,s4
    15dc:	00004097          	auipc	ra,0x4
    15e0:	678080e7          	jalr	1656(ra) # 5c54 <open>
    15e4:	84aa                	mv	s1,a0
      if(fd < 0){
    15e6:	06054e63          	bltz	a0,1662 <truncate3+0xdc>
      int n = write(fd, "1234567890", 10);
    15ea:	4629                	li	a2,10
    15ec:	85d6                	mv	a1,s5
    15ee:	00004097          	auipc	ra,0x4
    15f2:	646080e7          	jalr	1606(ra) # 5c34 <write>
      if(n != 10){
    15f6:	47a9                	li	a5,10
    15f8:	08f51363          	bne	a0,a5,167e <truncate3+0xf8>
      close(fd);
    15fc:	8526                	mv	a0,s1
    15fe:	00004097          	auipc	ra,0x4
    1602:	63e080e7          	jalr	1598(ra) # 5c3c <close>
      fd = open("truncfile", O_RDONLY);
    1606:	4581                	li	a1,0
    1608:	8552                	mv	a0,s4
    160a:	00004097          	auipc	ra,0x4
    160e:	64a080e7          	jalr	1610(ra) # 5c54 <open>
    1612:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    1614:	02000613          	li	a2,32
    1618:	f9840593          	add	a1,s0,-104
    161c:	00004097          	auipc	ra,0x4
    1620:	610080e7          	jalr	1552(ra) # 5c2c <read>
      close(fd);
    1624:	8526                	mv	a0,s1
    1626:	00004097          	auipc	ra,0x4
    162a:	616080e7          	jalr	1558(ra) # 5c3c <close>
    for(int i = 0; i < 100; i++){
    162e:	39fd                	addw	s3,s3,-1
    1630:	fa0994e3          	bnez	s3,15d8 <truncate3+0x52>
    exit(0);
    1634:	4501                	li	a0,0
    1636:	00004097          	auipc	ra,0x4
    163a:	5de080e7          	jalr	1502(ra) # 5c14 <exit>
    163e:	eca6                	sd	s1,88(sp)
    1640:	e4ce                	sd	s3,72(sp)
    1642:	e0d2                	sd	s4,64(sp)
    1644:	fc56                	sd	s5,56(sp)
    printf("%s: fork failed\n", s);
    1646:	85ca                	mv	a1,s2
    1648:	00005517          	auipc	a0,0x5
    164c:	3d850513          	add	a0,a0,984 # 6a20 <malloc+0x9cc>
    1650:	00005097          	auipc	ra,0x5
    1654:	94c080e7          	jalr	-1716(ra) # 5f9c <printf>
    exit(1);
    1658:	4505                	li	a0,1
    165a:	00004097          	auipc	ra,0x4
    165e:	5ba080e7          	jalr	1466(ra) # 5c14 <exit>
        printf("%s: open failed\n", s);
    1662:	85ca                	mv	a1,s2
    1664:	00005517          	auipc	a0,0x5
    1668:	3d450513          	add	a0,a0,980 # 6a38 <malloc+0x9e4>
    166c:	00005097          	auipc	ra,0x5
    1670:	930080e7          	jalr	-1744(ra) # 5f9c <printf>
        exit(1);
    1674:	4505                	li	a0,1
    1676:	00004097          	auipc	ra,0x4
    167a:	59e080e7          	jalr	1438(ra) # 5c14 <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    167e:	862a                	mv	a2,a0
    1680:	85ca                	mv	a1,s2
    1682:	00005517          	auipc	a0,0x5
    1686:	3de50513          	add	a0,a0,990 # 6a60 <malloc+0xa0c>
    168a:	00005097          	auipc	ra,0x5
    168e:	912080e7          	jalr	-1774(ra) # 5f9c <printf>
        exit(1);
    1692:	4505                	li	a0,1
    1694:	00004097          	auipc	ra,0x4
    1698:	580080e7          	jalr	1408(ra) # 5c14 <exit>
    169c:	eca6                	sd	s1,88(sp)
    169e:	e4ce                	sd	s3,72(sp)
    16a0:	e0d2                	sd	s4,64(sp)
    16a2:	fc56                	sd	s5,56(sp)
    16a4:	09600993          	li	s3,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16a8:	00005a17          	auipc	s4,0x5
    16ac:	b48a0a13          	add	s4,s4,-1208 # 61f0 <malloc+0x19c>
    int n = write(fd, "xxx", 3);
    16b0:	00005a97          	auipc	s5,0x5
    16b4:	3d0a8a93          	add	s5,s5,976 # 6a80 <malloc+0xa2c>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    16b8:	60100593          	li	a1,1537
    16bc:	8552                	mv	a0,s4
    16be:	00004097          	auipc	ra,0x4
    16c2:	596080e7          	jalr	1430(ra) # 5c54 <open>
    16c6:	84aa                	mv	s1,a0
    if(fd < 0){
    16c8:	04054763          	bltz	a0,1716 <truncate3+0x190>
    int n = write(fd, "xxx", 3);
    16cc:	460d                	li	a2,3
    16ce:	85d6                	mv	a1,s5
    16d0:	00004097          	auipc	ra,0x4
    16d4:	564080e7          	jalr	1380(ra) # 5c34 <write>
    if(n != 3){
    16d8:	478d                	li	a5,3
    16da:	04f51c63          	bne	a0,a5,1732 <truncate3+0x1ac>
    close(fd);
    16de:	8526                	mv	a0,s1
    16e0:	00004097          	auipc	ra,0x4
    16e4:	55c080e7          	jalr	1372(ra) # 5c3c <close>
  for(int i = 0; i < 150; i++){
    16e8:	39fd                	addw	s3,s3,-1
    16ea:	fc0997e3          	bnez	s3,16b8 <truncate3+0x132>
  wait(&xstatus);
    16ee:	fbc40513          	add	a0,s0,-68
    16f2:	00004097          	auipc	ra,0x4
    16f6:	52a080e7          	jalr	1322(ra) # 5c1c <wait>
  unlink("truncfile");
    16fa:	00005517          	auipc	a0,0x5
    16fe:	af650513          	add	a0,a0,-1290 # 61f0 <malloc+0x19c>
    1702:	00004097          	auipc	ra,0x4
    1706:	562080e7          	jalr	1378(ra) # 5c64 <unlink>
  exit(xstatus);
    170a:	fbc42503          	lw	a0,-68(s0)
    170e:	00004097          	auipc	ra,0x4
    1712:	506080e7          	jalr	1286(ra) # 5c14 <exit>
      printf("%s: open failed\n", s);
    1716:	85ca                	mv	a1,s2
    1718:	00005517          	auipc	a0,0x5
    171c:	32050513          	add	a0,a0,800 # 6a38 <malloc+0x9e4>
    1720:	00005097          	auipc	ra,0x5
    1724:	87c080e7          	jalr	-1924(ra) # 5f9c <printf>
      exit(1);
    1728:	4505                	li	a0,1
    172a:	00004097          	auipc	ra,0x4
    172e:	4ea080e7          	jalr	1258(ra) # 5c14 <exit>
      printf("%s: write got %d, expected 3\n", s, n);
    1732:	862a                	mv	a2,a0
    1734:	85ca                	mv	a1,s2
    1736:	00005517          	auipc	a0,0x5
    173a:	35250513          	add	a0,a0,850 # 6a88 <malloc+0xa34>
    173e:	00005097          	auipc	ra,0x5
    1742:	85e080e7          	jalr	-1954(ra) # 5f9c <printf>
      exit(1);
    1746:	4505                	li	a0,1
    1748:	00004097          	auipc	ra,0x4
    174c:	4cc080e7          	jalr	1228(ra) # 5c14 <exit>

0000000000001750 <exectest>:
{
    1750:	715d                	add	sp,sp,-80
    1752:	e486                	sd	ra,72(sp)
    1754:	e0a2                	sd	s0,64(sp)
    1756:	f84a                	sd	s2,48(sp)
    1758:	0880                	add	s0,sp,80
    175a:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    175c:	00005797          	auipc	a5,0x5
    1760:	a3c78793          	add	a5,a5,-1476 # 6198 <malloc+0x144>
    1764:	fcf43023          	sd	a5,-64(s0)
    1768:	00005797          	auipc	a5,0x5
    176c:	34078793          	add	a5,a5,832 # 6aa8 <malloc+0xa54>
    1770:	fcf43423          	sd	a5,-56(s0)
    1774:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    1778:	00005517          	auipc	a0,0x5
    177c:	33850513          	add	a0,a0,824 # 6ab0 <malloc+0xa5c>
    1780:	00004097          	auipc	ra,0x4
    1784:	4e4080e7          	jalr	1252(ra) # 5c64 <unlink>
  pid = fork();
    1788:	00004097          	auipc	ra,0x4
    178c:	484080e7          	jalr	1156(ra) # 5c0c <fork>
  if(pid < 0) {
    1790:	04054763          	bltz	a0,17de <exectest+0x8e>
    1794:	fc26                	sd	s1,56(sp)
    1796:	84aa                	mv	s1,a0
  if(pid == 0) {
    1798:	ed41                	bnez	a0,1830 <exectest+0xe0>
    close(1);
    179a:	4505                	li	a0,1
    179c:	00004097          	auipc	ra,0x4
    17a0:	4a0080e7          	jalr	1184(ra) # 5c3c <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    17a4:	20100593          	li	a1,513
    17a8:	00005517          	auipc	a0,0x5
    17ac:	30850513          	add	a0,a0,776 # 6ab0 <malloc+0xa5c>
    17b0:	00004097          	auipc	ra,0x4
    17b4:	4a4080e7          	jalr	1188(ra) # 5c54 <open>
    if(fd < 0) {
    17b8:	04054263          	bltz	a0,17fc <exectest+0xac>
    if(fd != 1) {
    17bc:	4785                	li	a5,1
    17be:	04f50d63          	beq	a0,a5,1818 <exectest+0xc8>
      printf("%s: wrong fd\n", s);
    17c2:	85ca                	mv	a1,s2
    17c4:	00005517          	auipc	a0,0x5
    17c8:	30c50513          	add	a0,a0,780 # 6ad0 <malloc+0xa7c>
    17cc:	00004097          	auipc	ra,0x4
    17d0:	7d0080e7          	jalr	2000(ra) # 5f9c <printf>
      exit(1);
    17d4:	4505                	li	a0,1
    17d6:	00004097          	auipc	ra,0x4
    17da:	43e080e7          	jalr	1086(ra) # 5c14 <exit>
    17de:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    17e0:	85ca                	mv	a1,s2
    17e2:	00005517          	auipc	a0,0x5
    17e6:	23e50513          	add	a0,a0,574 # 6a20 <malloc+0x9cc>
    17ea:	00004097          	auipc	ra,0x4
    17ee:	7b2080e7          	jalr	1970(ra) # 5f9c <printf>
     exit(1);
    17f2:	4505                	li	a0,1
    17f4:	00004097          	auipc	ra,0x4
    17f8:	420080e7          	jalr	1056(ra) # 5c14 <exit>
      printf("%s: create failed\n", s);
    17fc:	85ca                	mv	a1,s2
    17fe:	00005517          	auipc	a0,0x5
    1802:	2ba50513          	add	a0,a0,698 # 6ab8 <malloc+0xa64>
    1806:	00004097          	auipc	ra,0x4
    180a:	796080e7          	jalr	1942(ra) # 5f9c <printf>
      exit(1);
    180e:	4505                	li	a0,1
    1810:	00004097          	auipc	ra,0x4
    1814:	404080e7          	jalr	1028(ra) # 5c14 <exit>
    if(exec("echo", echoargv) < 0){
    1818:	fc040593          	add	a1,s0,-64
    181c:	00005517          	auipc	a0,0x5
    1820:	97c50513          	add	a0,a0,-1668 # 6198 <malloc+0x144>
    1824:	00004097          	auipc	ra,0x4
    1828:	428080e7          	jalr	1064(ra) # 5c4c <exec>
    182c:	02054163          	bltz	a0,184e <exectest+0xfe>
  if (wait(&xstatus) != pid) {
    1830:	fdc40513          	add	a0,s0,-36
    1834:	00004097          	auipc	ra,0x4
    1838:	3e8080e7          	jalr	1000(ra) # 5c1c <wait>
    183c:	02951763          	bne	a0,s1,186a <exectest+0x11a>
  if(xstatus != 0)
    1840:	fdc42503          	lw	a0,-36(s0)
    1844:	cd0d                	beqz	a0,187e <exectest+0x12e>
    exit(xstatus);
    1846:	00004097          	auipc	ra,0x4
    184a:	3ce080e7          	jalr	974(ra) # 5c14 <exit>
      printf("%s: exec echo failed\n", s);
    184e:	85ca                	mv	a1,s2
    1850:	00005517          	auipc	a0,0x5
    1854:	29050513          	add	a0,a0,656 # 6ae0 <malloc+0xa8c>
    1858:	00004097          	auipc	ra,0x4
    185c:	744080e7          	jalr	1860(ra) # 5f9c <printf>
      exit(1);
    1860:	4505                	li	a0,1
    1862:	00004097          	auipc	ra,0x4
    1866:	3b2080e7          	jalr	946(ra) # 5c14 <exit>
    printf("%s: wait failed!\n", s);
    186a:	85ca                	mv	a1,s2
    186c:	00005517          	auipc	a0,0x5
    1870:	28c50513          	add	a0,a0,652 # 6af8 <malloc+0xaa4>
    1874:	00004097          	auipc	ra,0x4
    1878:	728080e7          	jalr	1832(ra) # 5f9c <printf>
    187c:	b7d1                	j	1840 <exectest+0xf0>
  fd = open("echo-ok", O_RDONLY);
    187e:	4581                	li	a1,0
    1880:	00005517          	auipc	a0,0x5
    1884:	23050513          	add	a0,a0,560 # 6ab0 <malloc+0xa5c>
    1888:	00004097          	auipc	ra,0x4
    188c:	3cc080e7          	jalr	972(ra) # 5c54 <open>
  if(fd < 0) {
    1890:	02054a63          	bltz	a0,18c4 <exectest+0x174>
  if (read(fd, buf, 2) != 2) {
    1894:	4609                	li	a2,2
    1896:	fb840593          	add	a1,s0,-72
    189a:	00004097          	auipc	ra,0x4
    189e:	392080e7          	jalr	914(ra) # 5c2c <read>
    18a2:	4789                	li	a5,2
    18a4:	02f50e63          	beq	a0,a5,18e0 <exectest+0x190>
    printf("%s: read failed\n", s);
    18a8:	85ca                	mv	a1,s2
    18aa:	00005517          	auipc	a0,0x5
    18ae:	cbe50513          	add	a0,a0,-834 # 6568 <malloc+0x514>
    18b2:	00004097          	auipc	ra,0x4
    18b6:	6ea080e7          	jalr	1770(ra) # 5f9c <printf>
    exit(1);
    18ba:	4505                	li	a0,1
    18bc:	00004097          	auipc	ra,0x4
    18c0:	358080e7          	jalr	856(ra) # 5c14 <exit>
    printf("%s: open failed\n", s);
    18c4:	85ca                	mv	a1,s2
    18c6:	00005517          	auipc	a0,0x5
    18ca:	17250513          	add	a0,a0,370 # 6a38 <malloc+0x9e4>
    18ce:	00004097          	auipc	ra,0x4
    18d2:	6ce080e7          	jalr	1742(ra) # 5f9c <printf>
    exit(1);
    18d6:	4505                	li	a0,1
    18d8:	00004097          	auipc	ra,0x4
    18dc:	33c080e7          	jalr	828(ra) # 5c14 <exit>
  unlink("echo-ok");
    18e0:	00005517          	auipc	a0,0x5
    18e4:	1d050513          	add	a0,a0,464 # 6ab0 <malloc+0xa5c>
    18e8:	00004097          	auipc	ra,0x4
    18ec:	37c080e7          	jalr	892(ra) # 5c64 <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    18f0:	fb844703          	lbu	a4,-72(s0)
    18f4:	04f00793          	li	a5,79
    18f8:	00f71863          	bne	a4,a5,1908 <exectest+0x1b8>
    18fc:	fb944703          	lbu	a4,-71(s0)
    1900:	04b00793          	li	a5,75
    1904:	02f70063          	beq	a4,a5,1924 <exectest+0x1d4>
    printf("%s: wrong output\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00005517          	auipc	a0,0x5
    190e:	20650513          	add	a0,a0,518 # 6b10 <malloc+0xabc>
    1912:	00004097          	auipc	ra,0x4
    1916:	68a080e7          	jalr	1674(ra) # 5f9c <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00004097          	auipc	ra,0x4
    1920:	2f8080e7          	jalr	760(ra) # 5c14 <exit>
    exit(0);
    1924:	4501                	li	a0,0
    1926:	00004097          	auipc	ra,0x4
    192a:	2ee080e7          	jalr	750(ra) # 5c14 <exit>

000000000000192e <pipe1>:
{
    192e:	711d                	add	sp,sp,-96
    1930:	ec86                	sd	ra,88(sp)
    1932:	e8a2                	sd	s0,80(sp)
    1934:	fc4e                	sd	s3,56(sp)
    1936:	1080                	add	s0,sp,96
    1938:	89aa                	mv	s3,a0
  if(pipe(fds) != 0){
    193a:	fa840513          	add	a0,s0,-88
    193e:	00004097          	auipc	ra,0x4
    1942:	2e6080e7          	jalr	742(ra) # 5c24 <pipe>
    1946:	ed3d                	bnez	a0,19c4 <pipe1+0x96>
    1948:	e4a6                	sd	s1,72(sp)
    194a:	f852                	sd	s4,48(sp)
    194c:	84aa                	mv	s1,a0
  pid = fork();
    194e:	00004097          	auipc	ra,0x4
    1952:	2be080e7          	jalr	702(ra) # 5c0c <fork>
    1956:	8a2a                	mv	s4,a0
  if(pid == 0){
    1958:	c951                	beqz	a0,19ec <pipe1+0xbe>
  } else if(pid > 0){
    195a:	18a05b63          	blez	a0,1af0 <pipe1+0x1c2>
    195e:	e0ca                	sd	s2,64(sp)
    1960:	f456                	sd	s5,40(sp)
    close(fds[1]);
    1962:	fac42503          	lw	a0,-84(s0)
    1966:	00004097          	auipc	ra,0x4
    196a:	2d6080e7          	jalr	726(ra) # 5c3c <close>
    total = 0;
    196e:	8a26                	mv	s4,s1
    cc = 1;
    1970:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    1972:	0000ba97          	auipc	s5,0xb
    1976:	306a8a93          	add	s5,s5,774 # cc78 <buf>
    197a:	864a                	mv	a2,s2
    197c:	85d6                	mv	a1,s5
    197e:	fa842503          	lw	a0,-88(s0)
    1982:	00004097          	auipc	ra,0x4
    1986:	2aa080e7          	jalr	682(ra) # 5c2c <read>
    198a:	10a05a63          	blez	a0,1a9e <pipe1+0x170>
      for(i = 0; i < n; i++){
    198e:	0000b717          	auipc	a4,0xb
    1992:	2ea70713          	add	a4,a4,746 # cc78 <buf>
    1996:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    199a:	00074683          	lbu	a3,0(a4)
    199e:	0ff4f793          	zext.b	a5,s1
    19a2:	2485                	addw	s1,s1,1
    19a4:	0cf69b63          	bne	a3,a5,1a7a <pipe1+0x14c>
      for(i = 0; i < n; i++){
    19a8:	0705                	add	a4,a4,1
    19aa:	fec498e3          	bne	s1,a2,199a <pipe1+0x6c>
      total += n;
    19ae:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    19b2:	0019179b          	sllw	a5,s2,0x1
    19b6:	0007891b          	sext.w	s2,a5
      if(cc > sizeof(buf))
    19ba:	670d                	lui	a4,0x3
    19bc:	fb277fe3          	bgeu	a4,s2,197a <pipe1+0x4c>
        cc = sizeof(buf);
    19c0:	690d                	lui	s2,0x3
    19c2:	bf65                	j	197a <pipe1+0x4c>
    19c4:	e4a6                	sd	s1,72(sp)
    19c6:	e0ca                	sd	s2,64(sp)
    19c8:	f852                	sd	s4,48(sp)
    19ca:	f456                	sd	s5,40(sp)
    19cc:	f05a                	sd	s6,32(sp)
    19ce:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    19d0:	85ce                	mv	a1,s3
    19d2:	00005517          	auipc	a0,0x5
    19d6:	15650513          	add	a0,a0,342 # 6b28 <malloc+0xad4>
    19da:	00004097          	auipc	ra,0x4
    19de:	5c2080e7          	jalr	1474(ra) # 5f9c <printf>
    exit(1);
    19e2:	4505                	li	a0,1
    19e4:	00004097          	auipc	ra,0x4
    19e8:	230080e7          	jalr	560(ra) # 5c14 <exit>
    19ec:	e0ca                	sd	s2,64(sp)
    19ee:	f456                	sd	s5,40(sp)
    19f0:	f05a                	sd	s6,32(sp)
    19f2:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    19f4:	fa842503          	lw	a0,-88(s0)
    19f8:	00004097          	auipc	ra,0x4
    19fc:	244080e7          	jalr	580(ra) # 5c3c <close>
    for(n = 0; n < N; n++){
    1a00:	0000bb17          	auipc	s6,0xb
    1a04:	278b0b13          	add	s6,s6,632 # cc78 <buf>
    1a08:	416004bb          	negw	s1,s6
    1a0c:	0ff4f493          	zext.b	s1,s1
    1a10:	409b0913          	add	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a14:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1a16:	6a85                	lui	s5,0x1
    1a18:	42da8a93          	add	s5,s5,1069 # 142d <copyinstr2+0x9d>
{
    1a1c:	87da                	mv	a5,s6
        buf[i] = seq++;
    1a1e:	0097873b          	addw	a4,a5,s1
    1a22:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1a26:	0785                	add	a5,a5,1
    1a28:	ff279be3          	bne	a5,s2,1a1e <pipe1+0xf0>
    1a2c:	409a0a1b          	addw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    1a30:	40900613          	li	a2,1033
    1a34:	85de                	mv	a1,s7
    1a36:	fac42503          	lw	a0,-84(s0)
    1a3a:	00004097          	auipc	ra,0x4
    1a3e:	1fa080e7          	jalr	506(ra) # 5c34 <write>
    1a42:	40900793          	li	a5,1033
    1a46:	00f51c63          	bne	a0,a5,1a5e <pipe1+0x130>
    for(n = 0; n < N; n++){
    1a4a:	24a5                	addw	s1,s1,9
    1a4c:	0ff4f493          	zext.b	s1,s1
    1a50:	fd5a16e3          	bne	s4,s5,1a1c <pipe1+0xee>
    exit(0);
    1a54:	4501                	li	a0,0
    1a56:	00004097          	auipc	ra,0x4
    1a5a:	1be080e7          	jalr	446(ra) # 5c14 <exit>
        printf("%s: pipe1 oops 1\n", s);
    1a5e:	85ce                	mv	a1,s3
    1a60:	00005517          	auipc	a0,0x5
    1a64:	0e050513          	add	a0,a0,224 # 6b40 <malloc+0xaec>
    1a68:	00004097          	auipc	ra,0x4
    1a6c:	534080e7          	jalr	1332(ra) # 5f9c <printf>
        exit(1);
    1a70:	4505                	li	a0,1
    1a72:	00004097          	auipc	ra,0x4
    1a76:	1a2080e7          	jalr	418(ra) # 5c14 <exit>
          printf("%s: pipe1 oops 2\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00005517          	auipc	a0,0x5
    1a80:	0dc50513          	add	a0,a0,220 # 6b58 <malloc+0xb04>
    1a84:	00004097          	auipc	ra,0x4
    1a88:	518080e7          	jalr	1304(ra) # 5f9c <printf>
          return;
    1a8c:	64a6                	ld	s1,72(sp)
    1a8e:	6906                	ld	s2,64(sp)
    1a90:	7a42                	ld	s4,48(sp)
    1a92:	7aa2                	ld	s5,40(sp)
}
    1a94:	60e6                	ld	ra,88(sp)
    1a96:	6446                	ld	s0,80(sp)
    1a98:	79e2                	ld	s3,56(sp)
    1a9a:	6125                	add	sp,sp,96
    1a9c:	8082                	ret
    if(total != N * SZ){
    1a9e:	6785                	lui	a5,0x1
    1aa0:	42d78793          	add	a5,a5,1069 # 142d <copyinstr2+0x9d>
    1aa4:	02fa0263          	beq	s4,a5,1ac8 <pipe1+0x19a>
    1aa8:	f05a                	sd	s6,32(sp)
    1aaa:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", total);
    1aac:	85d2                	mv	a1,s4
    1aae:	00005517          	auipc	a0,0x5
    1ab2:	0c250513          	add	a0,a0,194 # 6b70 <malloc+0xb1c>
    1ab6:	00004097          	auipc	ra,0x4
    1aba:	4e6080e7          	jalr	1254(ra) # 5f9c <printf>
      exit(1);
    1abe:	4505                	li	a0,1
    1ac0:	00004097          	auipc	ra,0x4
    1ac4:	154080e7          	jalr	340(ra) # 5c14 <exit>
    1ac8:	f05a                	sd	s6,32(sp)
    1aca:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1acc:	fa842503          	lw	a0,-88(s0)
    1ad0:	00004097          	auipc	ra,0x4
    1ad4:	16c080e7          	jalr	364(ra) # 5c3c <close>
    wait(&xstatus);
    1ad8:	fa440513          	add	a0,s0,-92
    1adc:	00004097          	auipc	ra,0x4
    1ae0:	140080e7          	jalr	320(ra) # 5c1c <wait>
    exit(xstatus);
    1ae4:	fa442503          	lw	a0,-92(s0)
    1ae8:	00004097          	auipc	ra,0x4
    1aec:	12c080e7          	jalr	300(ra) # 5c14 <exit>
    1af0:	e0ca                	sd	s2,64(sp)
    1af2:	f456                	sd	s5,40(sp)
    1af4:	f05a                	sd	s6,32(sp)
    1af6:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1af8:	85ce                	mv	a1,s3
    1afa:	00005517          	auipc	a0,0x5
    1afe:	09650513          	add	a0,a0,150 # 6b90 <malloc+0xb3c>
    1b02:	00004097          	auipc	ra,0x4
    1b06:	49a080e7          	jalr	1178(ra) # 5f9c <printf>
    exit(1);
    1b0a:	4505                	li	a0,1
    1b0c:	00004097          	auipc	ra,0x4
    1b10:	108080e7          	jalr	264(ra) # 5c14 <exit>

0000000000001b14 <exitwait>:
{
    1b14:	7139                	add	sp,sp,-64
    1b16:	fc06                	sd	ra,56(sp)
    1b18:	f822                	sd	s0,48(sp)
    1b1a:	f426                	sd	s1,40(sp)
    1b1c:	f04a                	sd	s2,32(sp)
    1b1e:	ec4e                	sd	s3,24(sp)
    1b20:	e852                	sd	s4,16(sp)
    1b22:	0080                	add	s0,sp,64
    1b24:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
    1b26:	4901                	li	s2,0
    1b28:	06400993          	li	s3,100
    pid = fork();
    1b2c:	00004097          	auipc	ra,0x4
    1b30:	0e0080e7          	jalr	224(ra) # 5c0c <fork>
    1b34:	84aa                	mv	s1,a0
    if(pid < 0){
    1b36:	02054a63          	bltz	a0,1b6a <exitwait+0x56>
    if(pid){
    1b3a:	c151                	beqz	a0,1bbe <exitwait+0xaa>
      if(wait(&xstate) != pid){
    1b3c:	fcc40513          	add	a0,s0,-52
    1b40:	00004097          	auipc	ra,0x4
    1b44:	0dc080e7          	jalr	220(ra) # 5c1c <wait>
    1b48:	02951f63          	bne	a0,s1,1b86 <exitwait+0x72>
      if(i != xstate) {
    1b4c:	fcc42783          	lw	a5,-52(s0)
    1b50:	05279963          	bne	a5,s2,1ba2 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
    1b54:	2905                	addw	s2,s2,1 # 3001 <execout+0x53>
    1b56:	fd391be3          	bne	s2,s3,1b2c <exitwait+0x18>
}
    1b5a:	70e2                	ld	ra,56(sp)
    1b5c:	7442                	ld	s0,48(sp)
    1b5e:	74a2                	ld	s1,40(sp)
    1b60:	7902                	ld	s2,32(sp)
    1b62:	69e2                	ld	s3,24(sp)
    1b64:	6a42                	ld	s4,16(sp)
    1b66:	6121                	add	sp,sp,64
    1b68:	8082                	ret
      printf("%s: fork failed\n", s);
    1b6a:	85d2                	mv	a1,s4
    1b6c:	00005517          	auipc	a0,0x5
    1b70:	eb450513          	add	a0,a0,-332 # 6a20 <malloc+0x9cc>
    1b74:	00004097          	auipc	ra,0x4
    1b78:	428080e7          	jalr	1064(ra) # 5f9c <printf>
      exit(1);
    1b7c:	4505                	li	a0,1
    1b7e:	00004097          	auipc	ra,0x4
    1b82:	096080e7          	jalr	150(ra) # 5c14 <exit>
        printf("%s: wait wrong pid\n", s);
    1b86:	85d2                	mv	a1,s4
    1b88:	00005517          	auipc	a0,0x5
    1b8c:	02050513          	add	a0,a0,32 # 6ba8 <malloc+0xb54>
    1b90:	00004097          	auipc	ra,0x4
    1b94:	40c080e7          	jalr	1036(ra) # 5f9c <printf>
        exit(1);
    1b98:	4505                	li	a0,1
    1b9a:	00004097          	auipc	ra,0x4
    1b9e:	07a080e7          	jalr	122(ra) # 5c14 <exit>
        printf("%s: wait wrong exit status\n", s);
    1ba2:	85d2                	mv	a1,s4
    1ba4:	00005517          	auipc	a0,0x5
    1ba8:	01c50513          	add	a0,a0,28 # 6bc0 <malloc+0xb6c>
    1bac:	00004097          	auipc	ra,0x4
    1bb0:	3f0080e7          	jalr	1008(ra) # 5f9c <printf>
        exit(1);
    1bb4:	4505                	li	a0,1
    1bb6:	00004097          	auipc	ra,0x4
    1bba:	05e080e7          	jalr	94(ra) # 5c14 <exit>
      exit(i);
    1bbe:	854a                	mv	a0,s2
    1bc0:	00004097          	auipc	ra,0x4
    1bc4:	054080e7          	jalr	84(ra) # 5c14 <exit>

0000000000001bc8 <twochildren>:
{
    1bc8:	1101                	add	sp,sp,-32
    1bca:	ec06                	sd	ra,24(sp)
    1bcc:	e822                	sd	s0,16(sp)
    1bce:	e426                	sd	s1,8(sp)
    1bd0:	e04a                	sd	s2,0(sp)
    1bd2:	1000                	add	s0,sp,32
    1bd4:	892a                	mv	s2,a0
    1bd6:	3e800493          	li	s1,1000
    int pid1 = fork();
    1bda:	00004097          	auipc	ra,0x4
    1bde:	032080e7          	jalr	50(ra) # 5c0c <fork>
    if(pid1 < 0){
    1be2:	02054c63          	bltz	a0,1c1a <twochildren+0x52>
    if(pid1 == 0){
    1be6:	c921                	beqz	a0,1c36 <twochildren+0x6e>
      int pid2 = fork();
    1be8:	00004097          	auipc	ra,0x4
    1bec:	024080e7          	jalr	36(ra) # 5c0c <fork>
      if(pid2 < 0){
    1bf0:	04054763          	bltz	a0,1c3e <twochildren+0x76>
      if(pid2 == 0){
    1bf4:	c13d                	beqz	a0,1c5a <twochildren+0x92>
        wait(0);
    1bf6:	4501                	li	a0,0
    1bf8:	00004097          	auipc	ra,0x4
    1bfc:	024080e7          	jalr	36(ra) # 5c1c <wait>
        wait(0);
    1c00:	4501                	li	a0,0
    1c02:	00004097          	auipc	ra,0x4
    1c06:	01a080e7          	jalr	26(ra) # 5c1c <wait>
  for(int i = 0; i < 1000; i++){
    1c0a:	34fd                	addw	s1,s1,-1
    1c0c:	f4f9                	bnez	s1,1bda <twochildren+0x12>
}
    1c0e:	60e2                	ld	ra,24(sp)
    1c10:	6442                	ld	s0,16(sp)
    1c12:	64a2                	ld	s1,8(sp)
    1c14:	6902                	ld	s2,0(sp)
    1c16:	6105                	add	sp,sp,32
    1c18:	8082                	ret
      printf("%s: fork failed\n", s);
    1c1a:	85ca                	mv	a1,s2
    1c1c:	00005517          	auipc	a0,0x5
    1c20:	e0450513          	add	a0,a0,-508 # 6a20 <malloc+0x9cc>
    1c24:	00004097          	auipc	ra,0x4
    1c28:	378080e7          	jalr	888(ra) # 5f9c <printf>
      exit(1);
    1c2c:	4505                	li	a0,1
    1c2e:	00004097          	auipc	ra,0x4
    1c32:	fe6080e7          	jalr	-26(ra) # 5c14 <exit>
      exit(0);
    1c36:	00004097          	auipc	ra,0x4
    1c3a:	fde080e7          	jalr	-34(ra) # 5c14 <exit>
        printf("%s: fork failed\n", s);
    1c3e:	85ca                	mv	a1,s2
    1c40:	00005517          	auipc	a0,0x5
    1c44:	de050513          	add	a0,a0,-544 # 6a20 <malloc+0x9cc>
    1c48:	00004097          	auipc	ra,0x4
    1c4c:	354080e7          	jalr	852(ra) # 5f9c <printf>
        exit(1);
    1c50:	4505                	li	a0,1
    1c52:	00004097          	auipc	ra,0x4
    1c56:	fc2080e7          	jalr	-62(ra) # 5c14 <exit>
        exit(0);
    1c5a:	00004097          	auipc	ra,0x4
    1c5e:	fba080e7          	jalr	-70(ra) # 5c14 <exit>

0000000000001c62 <forkfork>:
{
    1c62:	7179                	add	sp,sp,-48
    1c64:	f406                	sd	ra,40(sp)
    1c66:	f022                	sd	s0,32(sp)
    1c68:	ec26                	sd	s1,24(sp)
    1c6a:	1800                	add	s0,sp,48
    1c6c:	84aa                	mv	s1,a0
    int pid = fork();
    1c6e:	00004097          	auipc	ra,0x4
    1c72:	f9e080e7          	jalr	-98(ra) # 5c0c <fork>
    if(pid < 0){
    1c76:	04054163          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c7a:	cd29                	beqz	a0,1cd4 <forkfork+0x72>
    int pid = fork();
    1c7c:	00004097          	auipc	ra,0x4
    1c80:	f90080e7          	jalr	-112(ra) # 5c0c <fork>
    if(pid < 0){
    1c84:	02054a63          	bltz	a0,1cb8 <forkfork+0x56>
    if(pid == 0){
    1c88:	c531                	beqz	a0,1cd4 <forkfork+0x72>
    wait(&xstatus);
    1c8a:	fdc40513          	add	a0,s0,-36
    1c8e:	00004097          	auipc	ra,0x4
    1c92:	f8e080e7          	jalr	-114(ra) # 5c1c <wait>
    if(xstatus != 0) {
    1c96:	fdc42783          	lw	a5,-36(s0)
    1c9a:	ebbd                	bnez	a5,1d10 <forkfork+0xae>
    wait(&xstatus);
    1c9c:	fdc40513          	add	a0,s0,-36
    1ca0:	00004097          	auipc	ra,0x4
    1ca4:	f7c080e7          	jalr	-132(ra) # 5c1c <wait>
    if(xstatus != 0) {
    1ca8:	fdc42783          	lw	a5,-36(s0)
    1cac:	e3b5                	bnez	a5,1d10 <forkfork+0xae>
}
    1cae:	70a2                	ld	ra,40(sp)
    1cb0:	7402                	ld	s0,32(sp)
    1cb2:	64e2                	ld	s1,24(sp)
    1cb4:	6145                	add	sp,sp,48
    1cb6:	8082                	ret
      printf("%s: fork failed", s);
    1cb8:	85a6                	mv	a1,s1
    1cba:	00005517          	auipc	a0,0x5
    1cbe:	f2650513          	add	a0,a0,-218 # 6be0 <malloc+0xb8c>
    1cc2:	00004097          	auipc	ra,0x4
    1cc6:	2da080e7          	jalr	730(ra) # 5f9c <printf>
      exit(1);
    1cca:	4505                	li	a0,1
    1ccc:	00004097          	auipc	ra,0x4
    1cd0:	f48080e7          	jalr	-184(ra) # 5c14 <exit>
{
    1cd4:	0c800493          	li	s1,200
        int pid1 = fork();
    1cd8:	00004097          	auipc	ra,0x4
    1cdc:	f34080e7          	jalr	-204(ra) # 5c0c <fork>
        if(pid1 < 0){
    1ce0:	00054f63          	bltz	a0,1cfe <forkfork+0x9c>
        if(pid1 == 0){
    1ce4:	c115                	beqz	a0,1d08 <forkfork+0xa6>
        wait(0);
    1ce6:	4501                	li	a0,0
    1ce8:	00004097          	auipc	ra,0x4
    1cec:	f34080e7          	jalr	-204(ra) # 5c1c <wait>
      for(int j = 0; j < 200; j++){
    1cf0:	34fd                	addw	s1,s1,-1
    1cf2:	f0fd                	bnez	s1,1cd8 <forkfork+0x76>
      exit(0);
    1cf4:	4501                	li	a0,0
    1cf6:	00004097          	auipc	ra,0x4
    1cfa:	f1e080e7          	jalr	-226(ra) # 5c14 <exit>
          exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00004097          	auipc	ra,0x4
    1d04:	f14080e7          	jalr	-236(ra) # 5c14 <exit>
          exit(0);
    1d08:	00004097          	auipc	ra,0x4
    1d0c:	f0c080e7          	jalr	-244(ra) # 5c14 <exit>
      printf("%s: fork in child failed", s);
    1d10:	85a6                	mv	a1,s1
    1d12:	00005517          	auipc	a0,0x5
    1d16:	ede50513          	add	a0,a0,-290 # 6bf0 <malloc+0xb9c>
    1d1a:	00004097          	auipc	ra,0x4
    1d1e:	282080e7          	jalr	642(ra) # 5f9c <printf>
      exit(1);
    1d22:	4505                	li	a0,1
    1d24:	00004097          	auipc	ra,0x4
    1d28:	ef0080e7          	jalr	-272(ra) # 5c14 <exit>

0000000000001d2c <reparent2>:
{
    1d2c:	1101                	add	sp,sp,-32
    1d2e:	ec06                	sd	ra,24(sp)
    1d30:	e822                	sd	s0,16(sp)
    1d32:	e426                	sd	s1,8(sp)
    1d34:	1000                	add	s0,sp,32
    1d36:	32000493          	li	s1,800
    int pid1 = fork();
    1d3a:	00004097          	auipc	ra,0x4
    1d3e:	ed2080e7          	jalr	-302(ra) # 5c0c <fork>
    if(pid1 < 0){
    1d42:	00054f63          	bltz	a0,1d60 <reparent2+0x34>
    if(pid1 == 0){
    1d46:	c915                	beqz	a0,1d7a <reparent2+0x4e>
    wait(0);
    1d48:	4501                	li	a0,0
    1d4a:	00004097          	auipc	ra,0x4
    1d4e:	ed2080e7          	jalr	-302(ra) # 5c1c <wait>
  for(int i = 0; i < 800; i++){
    1d52:	34fd                	addw	s1,s1,-1
    1d54:	f0fd                	bnez	s1,1d3a <reparent2+0xe>
  exit(0);
    1d56:	4501                	li	a0,0
    1d58:	00004097          	auipc	ra,0x4
    1d5c:	ebc080e7          	jalr	-324(ra) # 5c14 <exit>
      printf("fork failed\n");
    1d60:	00005517          	auipc	a0,0x5
    1d64:	0c850513          	add	a0,a0,200 # 6e28 <malloc+0xdd4>
    1d68:	00004097          	auipc	ra,0x4
    1d6c:	234080e7          	jalr	564(ra) # 5f9c <printf>
      exit(1);
    1d70:	4505                	li	a0,1
    1d72:	00004097          	auipc	ra,0x4
    1d76:	ea2080e7          	jalr	-350(ra) # 5c14 <exit>
      fork();
    1d7a:	00004097          	auipc	ra,0x4
    1d7e:	e92080e7          	jalr	-366(ra) # 5c0c <fork>
      fork();
    1d82:	00004097          	auipc	ra,0x4
    1d86:	e8a080e7          	jalr	-374(ra) # 5c0c <fork>
      exit(0);
    1d8a:	4501                	li	a0,0
    1d8c:	00004097          	auipc	ra,0x4
    1d90:	e88080e7          	jalr	-376(ra) # 5c14 <exit>

0000000000001d94 <createdelete>:
{
    1d94:	7175                	add	sp,sp,-144
    1d96:	e506                	sd	ra,136(sp)
    1d98:	e122                	sd	s0,128(sp)
    1d9a:	fca6                	sd	s1,120(sp)
    1d9c:	f8ca                	sd	s2,112(sp)
    1d9e:	f4ce                	sd	s3,104(sp)
    1da0:	f0d2                	sd	s4,96(sp)
    1da2:	ecd6                	sd	s5,88(sp)
    1da4:	e8da                	sd	s6,80(sp)
    1da6:	e4de                	sd	s7,72(sp)
    1da8:	e0e2                	sd	s8,64(sp)
    1daa:	fc66                	sd	s9,56(sp)
    1dac:	0900                	add	s0,sp,144
    1dae:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
    1db0:	4901                	li	s2,0
    1db2:	4991                	li	s3,4
    pid = fork();
    1db4:	00004097          	auipc	ra,0x4
    1db8:	e58080e7          	jalr	-424(ra) # 5c0c <fork>
    1dbc:	84aa                	mv	s1,a0
    if(pid < 0){
    1dbe:	02054f63          	bltz	a0,1dfc <createdelete+0x68>
    if(pid == 0){
    1dc2:	c939                	beqz	a0,1e18 <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
    1dc4:	2905                	addw	s2,s2,1
    1dc6:	ff3917e3          	bne	s2,s3,1db4 <createdelete+0x20>
    1dca:	4491                	li	s1,4
    wait(&xstatus);
    1dcc:	f7c40513          	add	a0,s0,-132
    1dd0:	00004097          	auipc	ra,0x4
    1dd4:	e4c080e7          	jalr	-436(ra) # 5c1c <wait>
    if(xstatus != 0)
    1dd8:	f7c42903          	lw	s2,-132(s0)
    1ddc:	0e091263          	bnez	s2,1ec0 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
    1de0:	34fd                	addw	s1,s1,-1
    1de2:	f4ed                	bnez	s1,1dcc <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
    1de4:	f8040123          	sb	zero,-126(s0)
    1de8:	03000993          	li	s3,48
    1dec:	5a7d                	li	s4,-1
    1dee:	07000c13          	li	s8,112
      if((i == 0 || i >= N/2) && fd < 0){
    1df2:	4b25                	li	s6,9
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1df4:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    1df6:	07400a93          	li	s5,116
    1dfa:	a28d                	j	1f5c <createdelete+0x1c8>
      printf("fork failed\n", s);
    1dfc:	85e6                	mv	a1,s9
    1dfe:	00005517          	auipc	a0,0x5
    1e02:	02a50513          	add	a0,a0,42 # 6e28 <malloc+0xdd4>
    1e06:	00004097          	auipc	ra,0x4
    1e0a:	196080e7          	jalr	406(ra) # 5f9c <printf>
      exit(1);
    1e0e:	4505                	li	a0,1
    1e10:	00004097          	auipc	ra,0x4
    1e14:	e04080e7          	jalr	-508(ra) # 5c14 <exit>
      name[0] = 'p' + pi;
    1e18:	0709091b          	addw	s2,s2,112
    1e1c:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
    1e20:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
    1e24:	4951                	li	s2,20
    1e26:	a015                	j	1e4a <createdelete+0xb6>
          printf("%s: create failed\n", s);
    1e28:	85e6                	mv	a1,s9
    1e2a:	00005517          	auipc	a0,0x5
    1e2e:	c8e50513          	add	a0,a0,-882 # 6ab8 <malloc+0xa64>
    1e32:	00004097          	auipc	ra,0x4
    1e36:	16a080e7          	jalr	362(ra) # 5f9c <printf>
          exit(1);
    1e3a:	4505                	li	a0,1
    1e3c:	00004097          	auipc	ra,0x4
    1e40:	dd8080e7          	jalr	-552(ra) # 5c14 <exit>
      for(i = 0; i < N; i++){
    1e44:	2485                	addw	s1,s1,1
    1e46:	07248863          	beq	s1,s2,1eb6 <createdelete+0x122>
        name[1] = '0' + i;
    1e4a:	0304879b          	addw	a5,s1,48
    1e4e:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1e52:	20200593          	li	a1,514
    1e56:	f8040513          	add	a0,s0,-128
    1e5a:	00004097          	auipc	ra,0x4
    1e5e:	dfa080e7          	jalr	-518(ra) # 5c54 <open>
        if(fd < 0){
    1e62:	fc0543e3          	bltz	a0,1e28 <createdelete+0x94>
        close(fd);
    1e66:	00004097          	auipc	ra,0x4
    1e6a:	dd6080e7          	jalr	-554(ra) # 5c3c <close>
        if(i > 0 && (i % 2 ) == 0){
    1e6e:	12905763          	blez	s1,1f9c <createdelete+0x208>
    1e72:	0014f793          	and	a5,s1,1
    1e76:	f7f9                	bnez	a5,1e44 <createdelete+0xb0>
          name[1] = '0' + (i / 2);
    1e78:	01f4d79b          	srlw	a5,s1,0x1f
    1e7c:	9fa5                	addw	a5,a5,s1
    1e7e:	4017d79b          	sraw	a5,a5,0x1
    1e82:	0307879b          	addw	a5,a5,48
    1e86:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
    1e8a:	f8040513          	add	a0,s0,-128
    1e8e:	00004097          	auipc	ra,0x4
    1e92:	dd6080e7          	jalr	-554(ra) # 5c64 <unlink>
    1e96:	fa0557e3          	bgez	a0,1e44 <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
    1e9a:	85e6                	mv	a1,s9
    1e9c:	00005517          	auipc	a0,0x5
    1ea0:	d7450513          	add	a0,a0,-652 # 6c10 <malloc+0xbbc>
    1ea4:	00004097          	auipc	ra,0x4
    1ea8:	0f8080e7          	jalr	248(ra) # 5f9c <printf>
            exit(1);
    1eac:	4505                	li	a0,1
    1eae:	00004097          	auipc	ra,0x4
    1eb2:	d66080e7          	jalr	-666(ra) # 5c14 <exit>
      exit(0);
    1eb6:	4501                	li	a0,0
    1eb8:	00004097          	auipc	ra,0x4
    1ebc:	d5c080e7          	jalr	-676(ra) # 5c14 <exit>
      exit(1);
    1ec0:	4505                	li	a0,1
    1ec2:	00004097          	auipc	ra,0x4
    1ec6:	d52080e7          	jalr	-686(ra) # 5c14 <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1eca:	f8040613          	add	a2,s0,-128
    1ece:	85e6                	mv	a1,s9
    1ed0:	00005517          	auipc	a0,0x5
    1ed4:	d5850513          	add	a0,a0,-680 # 6c28 <malloc+0xbd4>
    1ed8:	00004097          	auipc	ra,0x4
    1edc:	0c4080e7          	jalr	196(ra) # 5f9c <printf>
        exit(1);
    1ee0:	4505                	li	a0,1
    1ee2:	00004097          	auipc	ra,0x4
    1ee6:	d32080e7          	jalr	-718(ra) # 5c14 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1eea:	034bff63          	bgeu	s7,s4,1f28 <createdelete+0x194>
      if(fd >= 0)
    1eee:	02055863          	bgez	a0,1f1e <createdelete+0x18a>
    for(pi = 0; pi < NCHILD; pi++){
    1ef2:	2485                	addw	s1,s1,1
    1ef4:	0ff4f493          	zext.b	s1,s1
    1ef8:	05548a63          	beq	s1,s5,1f4c <createdelete+0x1b8>
      name[0] = 'p' + pi;
    1efc:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
    1f00:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
    1f04:	4581                	li	a1,0
    1f06:	f8040513          	add	a0,s0,-128
    1f0a:	00004097          	auipc	ra,0x4
    1f0e:	d4a080e7          	jalr	-694(ra) # 5c54 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1f12:	00090463          	beqz	s2,1f1a <createdelete+0x186>
    1f16:	fd2b5ae3          	bge	s6,s2,1eea <createdelete+0x156>
    1f1a:	fa0548e3          	bltz	a0,1eca <createdelete+0x136>
        close(fd);
    1f1e:	00004097          	auipc	ra,0x4
    1f22:	d1e080e7          	jalr	-738(ra) # 5c3c <close>
    1f26:	b7f1                	j	1ef2 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1f28:	fc0545e3          	bltz	a0,1ef2 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1f2c:	f8040613          	add	a2,s0,-128
    1f30:	85e6                	mv	a1,s9
    1f32:	00005517          	auipc	a0,0x5
    1f36:	d1e50513          	add	a0,a0,-738 # 6c50 <malloc+0xbfc>
    1f3a:	00004097          	auipc	ra,0x4
    1f3e:	062080e7          	jalr	98(ra) # 5f9c <printf>
        exit(1);
    1f42:	4505                	li	a0,1
    1f44:	00004097          	auipc	ra,0x4
    1f48:	cd0080e7          	jalr	-816(ra) # 5c14 <exit>
  for(i = 0; i < N; i++){
    1f4c:	2905                	addw	s2,s2,1
    1f4e:	2a05                	addw	s4,s4,1
    1f50:	2985                	addw	s3,s3,1
    1f52:	0ff9f993          	zext.b	s3,s3
    1f56:	47d1                	li	a5,20
    1f58:	02f90a63          	beq	s2,a5,1f8c <createdelete+0x1f8>
    for(pi = 0; pi < NCHILD; pi++){
    1f5c:	84e2                	mv	s1,s8
    1f5e:	bf79                	j	1efc <createdelete+0x168>
  for(i = 0; i < N; i++){
    1f60:	2905                	addw	s2,s2,1
    1f62:	0ff97913          	zext.b	s2,s2
    1f66:	2985                	addw	s3,s3,1
    1f68:	0ff9f993          	zext.b	s3,s3
    1f6c:	03490a63          	beq	s2,s4,1fa0 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
    1f70:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
    1f72:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
    1f76:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
    1f7a:	f8040513          	add	a0,s0,-128
    1f7e:	00004097          	auipc	ra,0x4
    1f82:	ce6080e7          	jalr	-794(ra) # 5c64 <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1f86:	34fd                	addw	s1,s1,-1
    1f88:	f4ed                	bnez	s1,1f72 <createdelete+0x1de>
    1f8a:	bfd9                	j	1f60 <createdelete+0x1cc>
    1f8c:	03000993          	li	s3,48
    1f90:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
    1f94:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
    1f96:	08400a13          	li	s4,132
    1f9a:	bfd9                	j	1f70 <createdelete+0x1dc>
      for(i = 0; i < N; i++){
    1f9c:	2485                	addw	s1,s1,1
    1f9e:	b575                	j	1e4a <createdelete+0xb6>
}
    1fa0:	60aa                	ld	ra,136(sp)
    1fa2:	640a                	ld	s0,128(sp)
    1fa4:	74e6                	ld	s1,120(sp)
    1fa6:	7946                	ld	s2,112(sp)
    1fa8:	79a6                	ld	s3,104(sp)
    1faa:	7a06                	ld	s4,96(sp)
    1fac:	6ae6                	ld	s5,88(sp)
    1fae:	6b46                	ld	s6,80(sp)
    1fb0:	6ba6                	ld	s7,72(sp)
    1fb2:	6c06                	ld	s8,64(sp)
    1fb4:	7ce2                	ld	s9,56(sp)
    1fb6:	6149                	add	sp,sp,144
    1fb8:	8082                	ret

0000000000001fba <linkunlink>:
{
    1fba:	711d                	add	sp,sp,-96
    1fbc:	ec86                	sd	ra,88(sp)
    1fbe:	e8a2                	sd	s0,80(sp)
    1fc0:	e4a6                	sd	s1,72(sp)
    1fc2:	e0ca                	sd	s2,64(sp)
    1fc4:	fc4e                	sd	s3,56(sp)
    1fc6:	f852                	sd	s4,48(sp)
    1fc8:	f456                	sd	s5,40(sp)
    1fca:	f05a                	sd	s6,32(sp)
    1fcc:	ec5e                	sd	s7,24(sp)
    1fce:	e862                	sd	s8,16(sp)
    1fd0:	e466                	sd	s9,8(sp)
    1fd2:	1080                	add	s0,sp,96
    1fd4:	84aa                	mv	s1,a0
  unlink("x");
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	23250513          	add	a0,a0,562 # 6208 <malloc+0x1b4>
    1fde:	00004097          	auipc	ra,0x4
    1fe2:	c86080e7          	jalr	-890(ra) # 5c64 <unlink>
  pid = fork();
    1fe6:	00004097          	auipc	ra,0x4
    1fea:	c26080e7          	jalr	-986(ra) # 5c0c <fork>
  if(pid < 0){
    1fee:	02054b63          	bltz	a0,2024 <linkunlink+0x6a>
    1ff2:	8caa                	mv	s9,a0
  unsigned int x = (pid ? 1 : 97);
    1ff4:	06100913          	li	s2,97
    1ff8:	c111                	beqz	a0,1ffc <linkunlink+0x42>
    1ffa:	4905                	li	s2,1
    1ffc:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    2000:	41c65a37          	lui	s4,0x41c65
    2004:	e6da0a1b          	addw	s4,s4,-403 # 41c64e6d <base+0x41c551f5>
    2008:	698d                	lui	s3,0x3
    200a:	0399899b          	addw	s3,s3,57 # 3039 <execout+0x8b>
    if((x % 3) == 0){
    200e:	4a8d                	li	s5,3
    } else if((x % 3) == 1){
    2010:	4b85                	li	s7,1
      unlink("x");
    2012:	00004b17          	auipc	s6,0x4
    2016:	1f6b0b13          	add	s6,s6,502 # 6208 <malloc+0x1b4>
      link("cat", "x");
    201a:	00005c17          	auipc	s8,0x5
    201e:	c5ec0c13          	add	s8,s8,-930 # 6c78 <malloc+0xc24>
    2022:	a825                	j	205a <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    2024:	85a6                	mv	a1,s1
    2026:	00005517          	auipc	a0,0x5
    202a:	9fa50513          	add	a0,a0,-1542 # 6a20 <malloc+0x9cc>
    202e:	00004097          	auipc	ra,0x4
    2032:	f6e080e7          	jalr	-146(ra) # 5f9c <printf>
    exit(1);
    2036:	4505                	li	a0,1
    2038:	00004097          	auipc	ra,0x4
    203c:	bdc080e7          	jalr	-1060(ra) # 5c14 <exit>
      close(open("x", O_RDWR | O_CREATE));
    2040:	20200593          	li	a1,514
    2044:	855a                	mv	a0,s6
    2046:	00004097          	auipc	ra,0x4
    204a:	c0e080e7          	jalr	-1010(ra) # 5c54 <open>
    204e:	00004097          	auipc	ra,0x4
    2052:	bee080e7          	jalr	-1042(ra) # 5c3c <close>
  for(i = 0; i < 100; i++){
    2056:	34fd                	addw	s1,s1,-1
    2058:	c895                	beqz	s1,208c <linkunlink+0xd2>
    x = x * 1103515245 + 12345;
    205a:	034907bb          	mulw	a5,s2,s4
    205e:	013787bb          	addw	a5,a5,s3
    2062:	0007891b          	sext.w	s2,a5
    if((x % 3) == 0){
    2066:	0357f7bb          	remuw	a5,a5,s5
    206a:	2781                	sext.w	a5,a5
    206c:	dbf1                	beqz	a5,2040 <linkunlink+0x86>
    } else if((x % 3) == 1){
    206e:	01778863          	beq	a5,s7,207e <linkunlink+0xc4>
      unlink("x");
    2072:	855a                	mv	a0,s6
    2074:	00004097          	auipc	ra,0x4
    2078:	bf0080e7          	jalr	-1040(ra) # 5c64 <unlink>
    207c:	bfe9                	j	2056 <linkunlink+0x9c>
      link("cat", "x");
    207e:	85da                	mv	a1,s6
    2080:	8562                	mv	a0,s8
    2082:	00004097          	auipc	ra,0x4
    2086:	bf2080e7          	jalr	-1038(ra) # 5c74 <link>
    208a:	b7f1                	j	2056 <linkunlink+0x9c>
  if(pid)
    208c:	020c8463          	beqz	s9,20b4 <linkunlink+0xfa>
    wait(0);
    2090:	4501                	li	a0,0
    2092:	00004097          	auipc	ra,0x4
    2096:	b8a080e7          	jalr	-1142(ra) # 5c1c <wait>
}
    209a:	60e6                	ld	ra,88(sp)
    209c:	6446                	ld	s0,80(sp)
    209e:	64a6                	ld	s1,72(sp)
    20a0:	6906                	ld	s2,64(sp)
    20a2:	79e2                	ld	s3,56(sp)
    20a4:	7a42                	ld	s4,48(sp)
    20a6:	7aa2                	ld	s5,40(sp)
    20a8:	7b02                	ld	s6,32(sp)
    20aa:	6be2                	ld	s7,24(sp)
    20ac:	6c42                	ld	s8,16(sp)
    20ae:	6ca2                	ld	s9,8(sp)
    20b0:	6125                	add	sp,sp,96
    20b2:	8082                	ret
    exit(0);
    20b4:	4501                	li	a0,0
    20b6:	00004097          	auipc	ra,0x4
    20ba:	b5e080e7          	jalr	-1186(ra) # 5c14 <exit>

00000000000020be <forktest>:
{
    20be:	7179                	add	sp,sp,-48
    20c0:	f406                	sd	ra,40(sp)
    20c2:	f022                	sd	s0,32(sp)
    20c4:	ec26                	sd	s1,24(sp)
    20c6:	e84a                	sd	s2,16(sp)
    20c8:	e44e                	sd	s3,8(sp)
    20ca:	1800                	add	s0,sp,48
    20cc:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    20ce:	4481                	li	s1,0
    20d0:	3e800913          	li	s2,1000
    pid = fork();
    20d4:	00004097          	auipc	ra,0x4
    20d8:	b38080e7          	jalr	-1224(ra) # 5c0c <fork>
    if(pid < 0)
    20dc:	08054263          	bltz	a0,2160 <forktest+0xa2>
    if(pid == 0)
    20e0:	c115                	beqz	a0,2104 <forktest+0x46>
  for(n=0; n<N; n++){
    20e2:	2485                	addw	s1,s1,1
    20e4:	ff2498e3          	bne	s1,s2,20d4 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    20e8:	85ce                	mv	a1,s3
    20ea:	00005517          	auipc	a0,0x5
    20ee:	bde50513          	add	a0,a0,-1058 # 6cc8 <malloc+0xc74>
    20f2:	00004097          	auipc	ra,0x4
    20f6:	eaa080e7          	jalr	-342(ra) # 5f9c <printf>
    exit(1);
    20fa:	4505                	li	a0,1
    20fc:	00004097          	auipc	ra,0x4
    2100:	b18080e7          	jalr	-1256(ra) # 5c14 <exit>
      exit(0);
    2104:	00004097          	auipc	ra,0x4
    2108:	b10080e7          	jalr	-1264(ra) # 5c14 <exit>
    printf("%s: no fork at all!\n", s);
    210c:	85ce                	mv	a1,s3
    210e:	00005517          	auipc	a0,0x5
    2112:	b7250513          	add	a0,a0,-1166 # 6c80 <malloc+0xc2c>
    2116:	00004097          	auipc	ra,0x4
    211a:	e86080e7          	jalr	-378(ra) # 5f9c <printf>
    exit(1);
    211e:	4505                	li	a0,1
    2120:	00004097          	auipc	ra,0x4
    2124:	af4080e7          	jalr	-1292(ra) # 5c14 <exit>
      printf("%s: wait stopped early\n", s);
    2128:	85ce                	mv	a1,s3
    212a:	00005517          	auipc	a0,0x5
    212e:	b6e50513          	add	a0,a0,-1170 # 6c98 <malloc+0xc44>
    2132:	00004097          	auipc	ra,0x4
    2136:	e6a080e7          	jalr	-406(ra) # 5f9c <printf>
      exit(1);
    213a:	4505                	li	a0,1
    213c:	00004097          	auipc	ra,0x4
    2140:	ad8080e7          	jalr	-1320(ra) # 5c14 <exit>
    printf("%s: wait got too many\n", s);
    2144:	85ce                	mv	a1,s3
    2146:	00005517          	auipc	a0,0x5
    214a:	b6a50513          	add	a0,a0,-1174 # 6cb0 <malloc+0xc5c>
    214e:	00004097          	auipc	ra,0x4
    2152:	e4e080e7          	jalr	-434(ra) # 5f9c <printf>
    exit(1);
    2156:	4505                	li	a0,1
    2158:	00004097          	auipc	ra,0x4
    215c:	abc080e7          	jalr	-1348(ra) # 5c14 <exit>
  if (n == 0) {
    2160:	d4d5                	beqz	s1,210c <forktest+0x4e>
  for(; n > 0; n--){
    2162:	00905b63          	blez	s1,2178 <forktest+0xba>
    if(wait(0) < 0){
    2166:	4501                	li	a0,0
    2168:	00004097          	auipc	ra,0x4
    216c:	ab4080e7          	jalr	-1356(ra) # 5c1c <wait>
    2170:	fa054ce3          	bltz	a0,2128 <forktest+0x6a>
  for(; n > 0; n--){
    2174:	34fd                	addw	s1,s1,-1
    2176:	f8e5                	bnez	s1,2166 <forktest+0xa8>
  if(wait(0) != -1){
    2178:	4501                	li	a0,0
    217a:	00004097          	auipc	ra,0x4
    217e:	aa2080e7          	jalr	-1374(ra) # 5c1c <wait>
    2182:	57fd                	li	a5,-1
    2184:	fcf510e3          	bne	a0,a5,2144 <forktest+0x86>
}
    2188:	70a2                	ld	ra,40(sp)
    218a:	7402                	ld	s0,32(sp)
    218c:	64e2                	ld	s1,24(sp)
    218e:	6942                	ld	s2,16(sp)
    2190:	69a2                	ld	s3,8(sp)
    2192:	6145                	add	sp,sp,48
    2194:	8082                	ret

0000000000002196 <kernmem>:
{
    2196:	715d                	add	sp,sp,-80
    2198:	e486                	sd	ra,72(sp)
    219a:	e0a2                	sd	s0,64(sp)
    219c:	fc26                	sd	s1,56(sp)
    219e:	f84a                	sd	s2,48(sp)
    21a0:	f44e                	sd	s3,40(sp)
    21a2:	f052                	sd	s4,32(sp)
    21a4:	ec56                	sd	s5,24(sp)
    21a6:	0880                	add	s0,sp,80
    21a8:	8aaa                	mv	s5,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21aa:	4485                	li	s1,1
    21ac:	04fe                	sll	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
    21ae:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21b0:	69b1                	lui	s3,0xc
    21b2:	35098993          	add	s3,s3,848 # c350 <uninit+0x1de8>
    21b6:	1003d937          	lui	s2,0x1003d
    21ba:	090e                	sll	s2,s2,0x3
    21bc:	48090913          	add	s2,s2,1152 # 1003d480 <base+0x1002d808>
    pid = fork();
    21c0:	00004097          	auipc	ra,0x4
    21c4:	a4c080e7          	jalr	-1460(ra) # 5c0c <fork>
    if(pid < 0){
    21c8:	02054963          	bltz	a0,21fa <kernmem+0x64>
    if(pid == 0){
    21cc:	c529                	beqz	a0,2216 <kernmem+0x80>
    wait(&xstatus);
    21ce:	fbc40513          	add	a0,s0,-68
    21d2:	00004097          	auipc	ra,0x4
    21d6:	a4a080e7          	jalr	-1462(ra) # 5c1c <wait>
    if(xstatus != -1)  // did kernel kill child?
    21da:	fbc42783          	lw	a5,-68(s0)
    21de:	05479d63          	bne	a5,s4,2238 <kernmem+0xa2>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    21e2:	94ce                	add	s1,s1,s3
    21e4:	fd249ee3          	bne	s1,s2,21c0 <kernmem+0x2a>
}
    21e8:	60a6                	ld	ra,72(sp)
    21ea:	6406                	ld	s0,64(sp)
    21ec:	74e2                	ld	s1,56(sp)
    21ee:	7942                	ld	s2,48(sp)
    21f0:	79a2                	ld	s3,40(sp)
    21f2:	7a02                	ld	s4,32(sp)
    21f4:	6ae2                	ld	s5,24(sp)
    21f6:	6161                	add	sp,sp,80
    21f8:	8082                	ret
      printf("%s: fork failed\n", s);
    21fa:	85d6                	mv	a1,s5
    21fc:	00005517          	auipc	a0,0x5
    2200:	82450513          	add	a0,a0,-2012 # 6a20 <malloc+0x9cc>
    2204:	00004097          	auipc	ra,0x4
    2208:	d98080e7          	jalr	-616(ra) # 5f9c <printf>
      exit(1);
    220c:	4505                	li	a0,1
    220e:	00004097          	auipc	ra,0x4
    2212:	a06080e7          	jalr	-1530(ra) # 5c14 <exit>
      printf("%s: oops could read %x = %x\n", s, a, *a);
    2216:	0004c683          	lbu	a3,0(s1)
    221a:	8626                	mv	a2,s1
    221c:	85d6                	mv	a1,s5
    221e:	00005517          	auipc	a0,0x5
    2222:	ad250513          	add	a0,a0,-1326 # 6cf0 <malloc+0xc9c>
    2226:	00004097          	auipc	ra,0x4
    222a:	d76080e7          	jalr	-650(ra) # 5f9c <printf>
      exit(1);
    222e:	4505                	li	a0,1
    2230:	00004097          	auipc	ra,0x4
    2234:	9e4080e7          	jalr	-1564(ra) # 5c14 <exit>
      exit(1);
    2238:	4505                	li	a0,1
    223a:	00004097          	auipc	ra,0x4
    223e:	9da080e7          	jalr	-1574(ra) # 5c14 <exit>

0000000000002242 <MAXVAplus>:
{
    2242:	7179                	add	sp,sp,-48
    2244:	f406                	sd	ra,40(sp)
    2246:	f022                	sd	s0,32(sp)
    2248:	1800                	add	s0,sp,48
  volatile uint64 a = MAXVA;
    224a:	4785                	li	a5,1
    224c:	179a                	sll	a5,a5,0x26
    224e:	fcf43c23          	sd	a5,-40(s0)
  for( ; a != 0; a <<= 1){
    2252:	fd843783          	ld	a5,-40(s0)
    2256:	c3a1                	beqz	a5,2296 <MAXVAplus+0x54>
    2258:	ec26                	sd	s1,24(sp)
    225a:	e84a                	sd	s2,16(sp)
    225c:	892a                	mv	s2,a0
    if(xstatus != -1)  // did kernel kill child?
    225e:	54fd                	li	s1,-1
    pid = fork();
    2260:	00004097          	auipc	ra,0x4
    2264:	9ac080e7          	jalr	-1620(ra) # 5c0c <fork>
    if(pid < 0){
    2268:	02054b63          	bltz	a0,229e <MAXVAplus+0x5c>
    if(pid == 0){
    226c:	c539                	beqz	a0,22ba <MAXVAplus+0x78>
    wait(&xstatus);
    226e:	fd440513          	add	a0,s0,-44
    2272:	00004097          	auipc	ra,0x4
    2276:	9aa080e7          	jalr	-1622(ra) # 5c1c <wait>
    if(xstatus != -1)  // did kernel kill child?
    227a:	fd442783          	lw	a5,-44(s0)
    227e:	06979463          	bne	a5,s1,22e6 <MAXVAplus+0xa4>
  for( ; a != 0; a <<= 1){
    2282:	fd843783          	ld	a5,-40(s0)
    2286:	0786                	sll	a5,a5,0x1
    2288:	fcf43c23          	sd	a5,-40(s0)
    228c:	fd843783          	ld	a5,-40(s0)
    2290:	fbe1                	bnez	a5,2260 <MAXVAplus+0x1e>
    2292:	64e2                	ld	s1,24(sp)
    2294:	6942                	ld	s2,16(sp)
}
    2296:	70a2                	ld	ra,40(sp)
    2298:	7402                	ld	s0,32(sp)
    229a:	6145                	add	sp,sp,48
    229c:	8082                	ret
      printf("%s: fork failed\n", s);
    229e:	85ca                	mv	a1,s2
    22a0:	00004517          	auipc	a0,0x4
    22a4:	78050513          	add	a0,a0,1920 # 6a20 <malloc+0x9cc>
    22a8:	00004097          	auipc	ra,0x4
    22ac:	cf4080e7          	jalr	-780(ra) # 5f9c <printf>
      exit(1);
    22b0:	4505                	li	a0,1
    22b2:	00004097          	auipc	ra,0x4
    22b6:	962080e7          	jalr	-1694(ra) # 5c14 <exit>
      *(char*)a = 99;
    22ba:	fd843783          	ld	a5,-40(s0)
    22be:	06300713          	li	a4,99
    22c2:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %x\n", s, a);
    22c6:	fd843603          	ld	a2,-40(s0)
    22ca:	85ca                	mv	a1,s2
    22cc:	00005517          	auipc	a0,0x5
    22d0:	a4450513          	add	a0,a0,-1468 # 6d10 <malloc+0xcbc>
    22d4:	00004097          	auipc	ra,0x4
    22d8:	cc8080e7          	jalr	-824(ra) # 5f9c <printf>
      exit(1);
    22dc:	4505                	li	a0,1
    22de:	00004097          	auipc	ra,0x4
    22e2:	936080e7          	jalr	-1738(ra) # 5c14 <exit>
      exit(1);
    22e6:	4505                	li	a0,1
    22e8:	00004097          	auipc	ra,0x4
    22ec:	92c080e7          	jalr	-1748(ra) # 5c14 <exit>

00000000000022f0 <bigargtest>:
{
    22f0:	7179                	add	sp,sp,-48
    22f2:	f406                	sd	ra,40(sp)
    22f4:	f022                	sd	s0,32(sp)
    22f6:	ec26                	sd	s1,24(sp)
    22f8:	1800                	add	s0,sp,48
    22fa:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    22fc:	00005517          	auipc	a0,0x5
    2300:	a2c50513          	add	a0,a0,-1492 # 6d28 <malloc+0xcd4>
    2304:	00004097          	auipc	ra,0x4
    2308:	960080e7          	jalr	-1696(ra) # 5c64 <unlink>
  pid = fork();
    230c:	00004097          	auipc	ra,0x4
    2310:	900080e7          	jalr	-1792(ra) # 5c0c <fork>
  if(pid == 0){
    2314:	c121                	beqz	a0,2354 <bigargtest+0x64>
  } else if(pid < 0){
    2316:	0a054063          	bltz	a0,23b6 <bigargtest+0xc6>
  wait(&xstatus);
    231a:	fdc40513          	add	a0,s0,-36
    231e:	00004097          	auipc	ra,0x4
    2322:	8fe080e7          	jalr	-1794(ra) # 5c1c <wait>
  if(xstatus != 0)
    2326:	fdc42503          	lw	a0,-36(s0)
    232a:	e545                	bnez	a0,23d2 <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    232c:	4581                	li	a1,0
    232e:	00005517          	auipc	a0,0x5
    2332:	9fa50513          	add	a0,a0,-1542 # 6d28 <malloc+0xcd4>
    2336:	00004097          	auipc	ra,0x4
    233a:	91e080e7          	jalr	-1762(ra) # 5c54 <open>
  if(fd < 0){
    233e:	08054e63          	bltz	a0,23da <bigargtest+0xea>
  close(fd);
    2342:	00004097          	auipc	ra,0x4
    2346:	8fa080e7          	jalr	-1798(ra) # 5c3c <close>
}
    234a:	70a2                	ld	ra,40(sp)
    234c:	7402                	ld	s0,32(sp)
    234e:	64e2                	ld	s1,24(sp)
    2350:	6145                	add	sp,sp,48
    2352:	8082                	ret
    2354:	00007797          	auipc	a5,0x7
    2358:	10c78793          	add	a5,a5,268 # 9460 <args.1>
    235c:	00007697          	auipc	a3,0x7
    2360:	1fc68693          	add	a3,a3,508 # 9558 <args.1+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    2364:	00005717          	auipc	a4,0x5
    2368:	9d470713          	add	a4,a4,-1580 # 6d38 <malloc+0xce4>
    236c:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    236e:	07a1                	add	a5,a5,8
    2370:	fed79ee3          	bne	a5,a3,236c <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    2374:	00007597          	auipc	a1,0x7
    2378:	0ec58593          	add	a1,a1,236 # 9460 <args.1>
    237c:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    2380:	00004517          	auipc	a0,0x4
    2384:	e1850513          	add	a0,a0,-488 # 6198 <malloc+0x144>
    2388:	00004097          	auipc	ra,0x4
    238c:	8c4080e7          	jalr	-1852(ra) # 5c4c <exec>
    fd = open("bigarg-ok", O_CREATE);
    2390:	20000593          	li	a1,512
    2394:	00005517          	auipc	a0,0x5
    2398:	99450513          	add	a0,a0,-1644 # 6d28 <malloc+0xcd4>
    239c:	00004097          	auipc	ra,0x4
    23a0:	8b8080e7          	jalr	-1864(ra) # 5c54 <open>
    close(fd);
    23a4:	00004097          	auipc	ra,0x4
    23a8:	898080e7          	jalr	-1896(ra) # 5c3c <close>
    exit(0);
    23ac:	4501                	li	a0,0
    23ae:	00004097          	auipc	ra,0x4
    23b2:	866080e7          	jalr	-1946(ra) # 5c14 <exit>
    printf("%s: bigargtest: fork failed\n", s);
    23b6:	85a6                	mv	a1,s1
    23b8:	00005517          	auipc	a0,0x5
    23bc:	a6050513          	add	a0,a0,-1440 # 6e18 <malloc+0xdc4>
    23c0:	00004097          	auipc	ra,0x4
    23c4:	bdc080e7          	jalr	-1060(ra) # 5f9c <printf>
    exit(1);
    23c8:	4505                	li	a0,1
    23ca:	00004097          	auipc	ra,0x4
    23ce:	84a080e7          	jalr	-1974(ra) # 5c14 <exit>
    exit(xstatus);
    23d2:	00004097          	auipc	ra,0x4
    23d6:	842080e7          	jalr	-1982(ra) # 5c14 <exit>
    printf("%s: bigarg test failed!\n", s);
    23da:	85a6                	mv	a1,s1
    23dc:	00005517          	auipc	a0,0x5
    23e0:	a5c50513          	add	a0,a0,-1444 # 6e38 <malloc+0xde4>
    23e4:	00004097          	auipc	ra,0x4
    23e8:	bb8080e7          	jalr	-1096(ra) # 5f9c <printf>
    exit(1);
    23ec:	4505                	li	a0,1
    23ee:	00004097          	auipc	ra,0x4
    23f2:	826080e7          	jalr	-2010(ra) # 5c14 <exit>

00000000000023f6 <stacktest>:
{
    23f6:	7179                	add	sp,sp,-48
    23f8:	f406                	sd	ra,40(sp)
    23fa:	f022                	sd	s0,32(sp)
    23fc:	ec26                	sd	s1,24(sp)
    23fe:	1800                	add	s0,sp,48
    2400:	84aa                	mv	s1,a0
  pid = fork();
    2402:	00004097          	auipc	ra,0x4
    2406:	80a080e7          	jalr	-2038(ra) # 5c0c <fork>
  if(pid == 0) {
    240a:	c115                	beqz	a0,242e <stacktest+0x38>
  } else if(pid < 0){
    240c:	04054463          	bltz	a0,2454 <stacktest+0x5e>
  wait(&xstatus);
    2410:	fdc40513          	add	a0,s0,-36
    2414:	00004097          	auipc	ra,0x4
    2418:	808080e7          	jalr	-2040(ra) # 5c1c <wait>
  if(xstatus == -1)  // kernel killed child?
    241c:	fdc42503          	lw	a0,-36(s0)
    2420:	57fd                	li	a5,-1
    2422:	04f50763          	beq	a0,a5,2470 <stacktest+0x7a>
    exit(xstatus);
    2426:	00003097          	auipc	ra,0x3
    242a:	7ee080e7          	jalr	2030(ra) # 5c14 <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    242e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", s, *sp);
    2430:	77fd                	lui	a5,0xfffff
    2432:	97ba                	add	a5,a5,a4
    2434:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xfffffffffffef388>
    2438:	85a6                	mv	a1,s1
    243a:	00005517          	auipc	a0,0x5
    243e:	a1e50513          	add	a0,a0,-1506 # 6e58 <malloc+0xe04>
    2442:	00004097          	auipc	ra,0x4
    2446:	b5a080e7          	jalr	-1190(ra) # 5f9c <printf>
    exit(1);
    244a:	4505                	li	a0,1
    244c:	00003097          	auipc	ra,0x3
    2450:	7c8080e7          	jalr	1992(ra) # 5c14 <exit>
    printf("%s: fork failed\n", s);
    2454:	85a6                	mv	a1,s1
    2456:	00004517          	auipc	a0,0x4
    245a:	5ca50513          	add	a0,a0,1482 # 6a20 <malloc+0x9cc>
    245e:	00004097          	auipc	ra,0x4
    2462:	b3e080e7          	jalr	-1218(ra) # 5f9c <printf>
    exit(1);
    2466:	4505                	li	a0,1
    2468:	00003097          	auipc	ra,0x3
    246c:	7ac080e7          	jalr	1964(ra) # 5c14 <exit>
    exit(0);
    2470:	4501                	li	a0,0
    2472:	00003097          	auipc	ra,0x3
    2476:	7a2080e7          	jalr	1954(ra) # 5c14 <exit>

000000000000247a <textwrite>:
{
    247a:	7179                	add	sp,sp,-48
    247c:	f406                	sd	ra,40(sp)
    247e:	f022                	sd	s0,32(sp)
    2480:	ec26                	sd	s1,24(sp)
    2482:	1800                	add	s0,sp,48
    2484:	84aa                	mv	s1,a0
  pid = fork();
    2486:	00003097          	auipc	ra,0x3
    248a:	786080e7          	jalr	1926(ra) # 5c0c <fork>
  if(pid == 0) {
    248e:	c115                	beqz	a0,24b2 <textwrite+0x38>
  } else if(pid < 0){
    2490:	02054963          	bltz	a0,24c2 <textwrite+0x48>
  wait(&xstatus);
    2494:	fdc40513          	add	a0,s0,-36
    2498:	00003097          	auipc	ra,0x3
    249c:	784080e7          	jalr	1924(ra) # 5c1c <wait>
  if(xstatus == -1)  // kernel killed child?
    24a0:	fdc42503          	lw	a0,-36(s0)
    24a4:	57fd                	li	a5,-1
    24a6:	02f50c63          	beq	a0,a5,24de <textwrite+0x64>
    exit(xstatus);
    24aa:	00003097          	auipc	ra,0x3
    24ae:	76a080e7          	jalr	1898(ra) # 5c14 <exit>
    *addr = 10;
    24b2:	47a9                	li	a5,10
    24b4:	00f02023          	sw	a5,0(zero) # 0 <copyinstr1>
    exit(1);
    24b8:	4505                	li	a0,1
    24ba:	00003097          	auipc	ra,0x3
    24be:	75a080e7          	jalr	1882(ra) # 5c14 <exit>
    printf("%s: fork failed\n", s);
    24c2:	85a6                	mv	a1,s1
    24c4:	00004517          	auipc	a0,0x4
    24c8:	55c50513          	add	a0,a0,1372 # 6a20 <malloc+0x9cc>
    24cc:	00004097          	auipc	ra,0x4
    24d0:	ad0080e7          	jalr	-1328(ra) # 5f9c <printf>
    exit(1);
    24d4:	4505                	li	a0,1
    24d6:	00003097          	auipc	ra,0x3
    24da:	73e080e7          	jalr	1854(ra) # 5c14 <exit>
    exit(0);
    24de:	4501                	li	a0,0
    24e0:	00003097          	auipc	ra,0x3
    24e4:	734080e7          	jalr	1844(ra) # 5c14 <exit>

00000000000024e8 <manywrites>:
{
    24e8:	711d                	add	sp,sp,-96
    24ea:	ec86                	sd	ra,88(sp)
    24ec:	e8a2                	sd	s0,80(sp)
    24ee:	e4a6                	sd	s1,72(sp)
    24f0:	e0ca                	sd	s2,64(sp)
    24f2:	fc4e                	sd	s3,56(sp)
    24f4:	f456                	sd	s5,40(sp)
    24f6:	1080                	add	s0,sp,96
    24f8:	8aaa                	mv	s5,a0
  for(int ci = 0; ci < nchildren; ci++){
    24fa:	4981                	li	s3,0
    24fc:	4911                	li	s2,4
    int pid = fork();
    24fe:	00003097          	auipc	ra,0x3
    2502:	70e080e7          	jalr	1806(ra) # 5c0c <fork>
    2506:	84aa                	mv	s1,a0
    if(pid < 0){
    2508:	02054d63          	bltz	a0,2542 <manywrites+0x5a>
    if(pid == 0){
    250c:	c939                	beqz	a0,2562 <manywrites+0x7a>
  for(int ci = 0; ci < nchildren; ci++){
    250e:	2985                	addw	s3,s3,1
    2510:	ff2997e3          	bne	s3,s2,24fe <manywrites+0x16>
    2514:	f852                	sd	s4,48(sp)
    2516:	f05a                	sd	s6,32(sp)
    2518:	ec5e                	sd	s7,24(sp)
    251a:	4491                	li	s1,4
    int st = 0;
    251c:	fa042423          	sw	zero,-88(s0)
    wait(&st);
    2520:	fa840513          	add	a0,s0,-88
    2524:	00003097          	auipc	ra,0x3
    2528:	6f8080e7          	jalr	1784(ra) # 5c1c <wait>
    if(st != 0)
    252c:	fa842503          	lw	a0,-88(s0)
    2530:	10051463          	bnez	a0,2638 <manywrites+0x150>
  for(int ci = 0; ci < nchildren; ci++){
    2534:	34fd                	addw	s1,s1,-1
    2536:	f0fd                	bnez	s1,251c <manywrites+0x34>
  exit(0);
    2538:	4501                	li	a0,0
    253a:	00003097          	auipc	ra,0x3
    253e:	6da080e7          	jalr	1754(ra) # 5c14 <exit>
    2542:	f852                	sd	s4,48(sp)
    2544:	f05a                	sd	s6,32(sp)
    2546:	ec5e                	sd	s7,24(sp)
      printf("fork failed\n");
    2548:	00005517          	auipc	a0,0x5
    254c:	8e050513          	add	a0,a0,-1824 # 6e28 <malloc+0xdd4>
    2550:	00004097          	auipc	ra,0x4
    2554:	a4c080e7          	jalr	-1460(ra) # 5f9c <printf>
      exit(1);
    2558:	4505                	li	a0,1
    255a:	00003097          	auipc	ra,0x3
    255e:	6ba080e7          	jalr	1722(ra) # 5c14 <exit>
    2562:	f852                	sd	s4,48(sp)
    2564:	f05a                	sd	s6,32(sp)
    2566:	ec5e                	sd	s7,24(sp)
      name[0] = 'b';
    2568:	06200793          	li	a5,98
    256c:	faf40423          	sb	a5,-88(s0)
      name[1] = 'a' + ci;
    2570:	0619879b          	addw	a5,s3,97
    2574:	faf404a3          	sb	a5,-87(s0)
      name[2] = '\0';
    2578:	fa040523          	sb	zero,-86(s0)
      unlink(name);
    257c:	fa840513          	add	a0,s0,-88
    2580:	00003097          	auipc	ra,0x3
    2584:	6e4080e7          	jalr	1764(ra) # 5c64 <unlink>
    2588:	4bf9                	li	s7,30
          int cc = write(fd, buf, sz);
    258a:	0000ab17          	auipc	s6,0xa
    258e:	6eeb0b13          	add	s6,s6,1774 # cc78 <buf>
        for(int i = 0; i < ci+1; i++){
    2592:	8a26                	mv	s4,s1
    2594:	0209ce63          	bltz	s3,25d0 <manywrites+0xe8>
          int fd = open(name, O_CREATE | O_RDWR);
    2598:	20200593          	li	a1,514
    259c:	fa840513          	add	a0,s0,-88
    25a0:	00003097          	auipc	ra,0x3
    25a4:	6b4080e7          	jalr	1716(ra) # 5c54 <open>
    25a8:	892a                	mv	s2,a0
          if(fd < 0){
    25aa:	04054763          	bltz	a0,25f8 <manywrites+0x110>
          int cc = write(fd, buf, sz);
    25ae:	660d                	lui	a2,0x3
    25b0:	85da                	mv	a1,s6
    25b2:	00003097          	auipc	ra,0x3
    25b6:	682080e7          	jalr	1666(ra) # 5c34 <write>
          if(cc != sz){
    25ba:	678d                	lui	a5,0x3
    25bc:	04f51e63          	bne	a0,a5,2618 <manywrites+0x130>
          close(fd);
    25c0:	854a                	mv	a0,s2
    25c2:	00003097          	auipc	ra,0x3
    25c6:	67a080e7          	jalr	1658(ra) # 5c3c <close>
        for(int i = 0; i < ci+1; i++){
    25ca:	2a05                	addw	s4,s4,1
    25cc:	fd49d6e3          	bge	s3,s4,2598 <manywrites+0xb0>
        unlink(name);
    25d0:	fa840513          	add	a0,s0,-88
    25d4:	00003097          	auipc	ra,0x3
    25d8:	690080e7          	jalr	1680(ra) # 5c64 <unlink>
      for(int iters = 0; iters < howmany; iters++){
    25dc:	3bfd                	addw	s7,s7,-1
    25de:	fa0b9ae3          	bnez	s7,2592 <manywrites+0xaa>
      unlink(name);
    25e2:	fa840513          	add	a0,s0,-88
    25e6:	00003097          	auipc	ra,0x3
    25ea:	67e080e7          	jalr	1662(ra) # 5c64 <unlink>
      exit(0);
    25ee:	4501                	li	a0,0
    25f0:	00003097          	auipc	ra,0x3
    25f4:	624080e7          	jalr	1572(ra) # 5c14 <exit>
            printf("%s: cannot create %s\n", s, name);
    25f8:	fa840613          	add	a2,s0,-88
    25fc:	85d6                	mv	a1,s5
    25fe:	00005517          	auipc	a0,0x5
    2602:	88250513          	add	a0,a0,-1918 # 6e80 <malloc+0xe2c>
    2606:	00004097          	auipc	ra,0x4
    260a:	996080e7          	jalr	-1642(ra) # 5f9c <printf>
            exit(1);
    260e:	4505                	li	a0,1
    2610:	00003097          	auipc	ra,0x3
    2614:	604080e7          	jalr	1540(ra) # 5c14 <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    2618:	86aa                	mv	a3,a0
    261a:	660d                	lui	a2,0x3
    261c:	85d6                	mv	a1,s5
    261e:	00004517          	auipc	a0,0x4
    2622:	c4a50513          	add	a0,a0,-950 # 6268 <malloc+0x214>
    2626:	00004097          	auipc	ra,0x4
    262a:	976080e7          	jalr	-1674(ra) # 5f9c <printf>
            exit(1);
    262e:	4505                	li	a0,1
    2630:	00003097          	auipc	ra,0x3
    2634:	5e4080e7          	jalr	1508(ra) # 5c14 <exit>
      exit(st);
    2638:	00003097          	auipc	ra,0x3
    263c:	5dc080e7          	jalr	1500(ra) # 5c14 <exit>

0000000000002640 <copyinstr3>:
{
    2640:	7179                	add	sp,sp,-48
    2642:	f406                	sd	ra,40(sp)
    2644:	f022                	sd	s0,32(sp)
    2646:	ec26                	sd	s1,24(sp)
    2648:	1800                	add	s0,sp,48
  sbrk(8192);
    264a:	6509                	lui	a0,0x2
    264c:	00003097          	auipc	ra,0x3
    2650:	650080e7          	jalr	1616(ra) # 5c9c <sbrk>
  uint64 top = (uint64) sbrk(0);
    2654:	4501                	li	a0,0
    2656:	00003097          	auipc	ra,0x3
    265a:	646080e7          	jalr	1606(ra) # 5c9c <sbrk>
  if((top % PGSIZE) != 0){
    265e:	03451793          	sll	a5,a0,0x34
    2662:	e3c9                	bnez	a5,26e4 <copyinstr3+0xa4>
  top = (uint64) sbrk(0);
    2664:	4501                	li	a0,0
    2666:	00003097          	auipc	ra,0x3
    266a:	636080e7          	jalr	1590(ra) # 5c9c <sbrk>
  if(top % PGSIZE){
    266e:	03451793          	sll	a5,a0,0x34
    2672:	e3d9                	bnez	a5,26f8 <copyinstr3+0xb8>
  char *b = (char *) (top - 1);
    2674:	fff50493          	add	s1,a0,-1 # 1fff <linkunlink+0x45>
  *b = 'x';
    2678:	07800793          	li	a5,120
    267c:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2680:	8526                	mv	a0,s1
    2682:	00003097          	auipc	ra,0x3
    2686:	5e2080e7          	jalr	1506(ra) # 5c64 <unlink>
  if(ret != -1){
    268a:	57fd                	li	a5,-1
    268c:	08f51363          	bne	a0,a5,2712 <copyinstr3+0xd2>
  int fd = open(b, O_CREATE | O_WRONLY);
    2690:	20100593          	li	a1,513
    2694:	8526                	mv	a0,s1
    2696:	00003097          	auipc	ra,0x3
    269a:	5be080e7          	jalr	1470(ra) # 5c54 <open>
  if(fd != -1){
    269e:	57fd                	li	a5,-1
    26a0:	08f51863          	bne	a0,a5,2730 <copyinstr3+0xf0>
  ret = link(b, b);
    26a4:	85a6                	mv	a1,s1
    26a6:	8526                	mv	a0,s1
    26a8:	00003097          	auipc	ra,0x3
    26ac:	5cc080e7          	jalr	1484(ra) # 5c74 <link>
  if(ret != -1){
    26b0:	57fd                	li	a5,-1
    26b2:	08f51e63          	bne	a0,a5,274e <copyinstr3+0x10e>
  char *args[] = { "xx", 0 };
    26b6:	00005797          	auipc	a5,0x5
    26ba:	4c278793          	add	a5,a5,1218 # 7b78 <malloc+0x1b24>
    26be:	fcf43823          	sd	a5,-48(s0)
    26c2:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    26c6:	fd040593          	add	a1,s0,-48
    26ca:	8526                	mv	a0,s1
    26cc:	00003097          	auipc	ra,0x3
    26d0:	580080e7          	jalr	1408(ra) # 5c4c <exec>
  if(ret != -1){
    26d4:	57fd                	li	a5,-1
    26d6:	08f51c63          	bne	a0,a5,276e <copyinstr3+0x12e>
}
    26da:	70a2                	ld	ra,40(sp)
    26dc:	7402                	ld	s0,32(sp)
    26de:	64e2                	ld	s1,24(sp)
    26e0:	6145                	add	sp,sp,48
    26e2:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26e4:	0347d513          	srl	a0,a5,0x34
    26e8:	6785                	lui	a5,0x1
    26ea:	40a7853b          	subw	a0,a5,a0
    26ee:	00003097          	auipc	ra,0x3
    26f2:	5ae080e7          	jalr	1454(ra) # 5c9c <sbrk>
    26f6:	b7bd                	j	2664 <copyinstr3+0x24>
    printf("oops\n");
    26f8:	00004517          	auipc	a0,0x4
    26fc:	7a050513          	add	a0,a0,1952 # 6e98 <malloc+0xe44>
    2700:	00004097          	auipc	ra,0x4
    2704:	89c080e7          	jalr	-1892(ra) # 5f9c <printf>
    exit(1);
    2708:	4505                	li	a0,1
    270a:	00003097          	auipc	ra,0x3
    270e:	50a080e7          	jalr	1290(ra) # 5c14 <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2712:	862a                	mv	a2,a0
    2714:	85a6                	mv	a1,s1
    2716:	00004517          	auipc	a0,0x4
    271a:	22a50513          	add	a0,a0,554 # 6940 <malloc+0x8ec>
    271e:	00004097          	auipc	ra,0x4
    2722:	87e080e7          	jalr	-1922(ra) # 5f9c <printf>
    exit(1);
    2726:	4505                	li	a0,1
    2728:	00003097          	auipc	ra,0x3
    272c:	4ec080e7          	jalr	1260(ra) # 5c14 <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    2730:	862a                	mv	a2,a0
    2732:	85a6                	mv	a1,s1
    2734:	00004517          	auipc	a0,0x4
    2738:	22c50513          	add	a0,a0,556 # 6960 <malloc+0x90c>
    273c:	00004097          	auipc	ra,0x4
    2740:	860080e7          	jalr	-1952(ra) # 5f9c <printf>
    exit(1);
    2744:	4505                	li	a0,1
    2746:	00003097          	auipc	ra,0x3
    274a:	4ce080e7          	jalr	1230(ra) # 5c14 <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    274e:	86aa                	mv	a3,a0
    2750:	8626                	mv	a2,s1
    2752:	85a6                	mv	a1,s1
    2754:	00004517          	auipc	a0,0x4
    2758:	22c50513          	add	a0,a0,556 # 6980 <malloc+0x92c>
    275c:	00004097          	auipc	ra,0x4
    2760:	840080e7          	jalr	-1984(ra) # 5f9c <printf>
    exit(1);
    2764:	4505                	li	a0,1
    2766:	00003097          	auipc	ra,0x3
    276a:	4ae080e7          	jalr	1198(ra) # 5c14 <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    276e:	567d                	li	a2,-1
    2770:	85a6                	mv	a1,s1
    2772:	00004517          	auipc	a0,0x4
    2776:	23650513          	add	a0,a0,566 # 69a8 <malloc+0x954>
    277a:	00004097          	auipc	ra,0x4
    277e:	822080e7          	jalr	-2014(ra) # 5f9c <printf>
    exit(1);
    2782:	4505                	li	a0,1
    2784:	00003097          	auipc	ra,0x3
    2788:	490080e7          	jalr	1168(ra) # 5c14 <exit>

000000000000278c <rwsbrk>:
{
    278c:	1101                	add	sp,sp,-32
    278e:	ec06                	sd	ra,24(sp)
    2790:	e822                	sd	s0,16(sp)
    2792:	1000                	add	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    2794:	6509                	lui	a0,0x2
    2796:	00003097          	auipc	ra,0x3
    279a:	506080e7          	jalr	1286(ra) # 5c9c <sbrk>
  if(a == 0xffffffffffffffffLL) {
    279e:	57fd                	li	a5,-1
    27a0:	06f50463          	beq	a0,a5,2808 <rwsbrk+0x7c>
    27a4:	e426                	sd	s1,8(sp)
    27a6:	84aa                	mv	s1,a0
  if ((uint64) sbrk(-8192) ==  0xffffffffffffffffLL) {
    27a8:	7579                	lui	a0,0xffffe
    27aa:	00003097          	auipc	ra,0x3
    27ae:	4f2080e7          	jalr	1266(ra) # 5c9c <sbrk>
    27b2:	57fd                	li	a5,-1
    27b4:	06f50963          	beq	a0,a5,2826 <rwsbrk+0x9a>
    27b8:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    27ba:	20100593          	li	a1,513
    27be:	00004517          	auipc	a0,0x4
    27c2:	71a50513          	add	a0,a0,1818 # 6ed8 <malloc+0xe84>
    27c6:	00003097          	auipc	ra,0x3
    27ca:	48e080e7          	jalr	1166(ra) # 5c54 <open>
    27ce:	892a                	mv	s2,a0
  if(fd < 0){
    27d0:	06054963          	bltz	a0,2842 <rwsbrk+0xb6>
  n = write(fd, (void*)(a+4096), 1024);
    27d4:	6785                	lui	a5,0x1
    27d6:	94be                	add	s1,s1,a5
    27d8:	40000613          	li	a2,1024
    27dc:	85a6                	mv	a1,s1
    27de:	00003097          	auipc	ra,0x3
    27e2:	456080e7          	jalr	1110(ra) # 5c34 <write>
    27e6:	862a                	mv	a2,a0
  if(n >= 0){
    27e8:	06054a63          	bltz	a0,285c <rwsbrk+0xd0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", a+4096, n);
    27ec:	85a6                	mv	a1,s1
    27ee:	00004517          	auipc	a0,0x4
    27f2:	70a50513          	add	a0,a0,1802 # 6ef8 <malloc+0xea4>
    27f6:	00003097          	auipc	ra,0x3
    27fa:	7a6080e7          	jalr	1958(ra) # 5f9c <printf>
    exit(1);
    27fe:	4505                	li	a0,1
    2800:	00003097          	auipc	ra,0x3
    2804:	414080e7          	jalr	1044(ra) # 5c14 <exit>
    2808:	e426                	sd	s1,8(sp)
    280a:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    280c:	00004517          	auipc	a0,0x4
    2810:	69450513          	add	a0,a0,1684 # 6ea0 <malloc+0xe4c>
    2814:	00003097          	auipc	ra,0x3
    2818:	788080e7          	jalr	1928(ra) # 5f9c <printf>
    exit(1);
    281c:	4505                	li	a0,1
    281e:	00003097          	auipc	ra,0x3
    2822:	3f6080e7          	jalr	1014(ra) # 5c14 <exit>
    2826:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    2828:	00004517          	auipc	a0,0x4
    282c:	69050513          	add	a0,a0,1680 # 6eb8 <malloc+0xe64>
    2830:	00003097          	auipc	ra,0x3
    2834:	76c080e7          	jalr	1900(ra) # 5f9c <printf>
    exit(1);
    2838:	4505                	li	a0,1
    283a:	00003097          	auipc	ra,0x3
    283e:	3da080e7          	jalr	986(ra) # 5c14 <exit>
    printf("open(rwsbrk) failed\n");
    2842:	00004517          	auipc	a0,0x4
    2846:	69e50513          	add	a0,a0,1694 # 6ee0 <malloc+0xe8c>
    284a:	00003097          	auipc	ra,0x3
    284e:	752080e7          	jalr	1874(ra) # 5f9c <printf>
    exit(1);
    2852:	4505                	li	a0,1
    2854:	00003097          	auipc	ra,0x3
    2858:	3c0080e7          	jalr	960(ra) # 5c14 <exit>
  close(fd);
    285c:	854a                	mv	a0,s2
    285e:	00003097          	auipc	ra,0x3
    2862:	3de080e7          	jalr	990(ra) # 5c3c <close>
  unlink("rwsbrk");
    2866:	00004517          	auipc	a0,0x4
    286a:	67250513          	add	a0,a0,1650 # 6ed8 <malloc+0xe84>
    286e:	00003097          	auipc	ra,0x3
    2872:	3f6080e7          	jalr	1014(ra) # 5c64 <unlink>
  fd = open("README", O_RDONLY);
    2876:	4581                	li	a1,0
    2878:	00004517          	auipc	a0,0x4
    287c:	af850513          	add	a0,a0,-1288 # 6370 <malloc+0x31c>
    2880:	00003097          	auipc	ra,0x3
    2884:	3d4080e7          	jalr	980(ra) # 5c54 <open>
    2888:	892a                	mv	s2,a0
  if(fd < 0){
    288a:	02054963          	bltz	a0,28bc <rwsbrk+0x130>
  n = read(fd, (void*)(a+4096), 10);
    288e:	4629                	li	a2,10
    2890:	85a6                	mv	a1,s1
    2892:	00003097          	auipc	ra,0x3
    2896:	39a080e7          	jalr	922(ra) # 5c2c <read>
    289a:	862a                	mv	a2,a0
  if(n >= 0){
    289c:	02054d63          	bltz	a0,28d6 <rwsbrk+0x14a>
    printf("read(fd, %p, 10) returned %d, not -1\n", a+4096, n);
    28a0:	85a6                	mv	a1,s1
    28a2:	00004517          	auipc	a0,0x4
    28a6:	68650513          	add	a0,a0,1670 # 6f28 <malloc+0xed4>
    28aa:	00003097          	auipc	ra,0x3
    28ae:	6f2080e7          	jalr	1778(ra) # 5f9c <printf>
    exit(1);
    28b2:	4505                	li	a0,1
    28b4:	00003097          	auipc	ra,0x3
    28b8:	360080e7          	jalr	864(ra) # 5c14 <exit>
    printf("open(rwsbrk) failed\n");
    28bc:	00004517          	auipc	a0,0x4
    28c0:	62450513          	add	a0,a0,1572 # 6ee0 <malloc+0xe8c>
    28c4:	00003097          	auipc	ra,0x3
    28c8:	6d8080e7          	jalr	1752(ra) # 5f9c <printf>
    exit(1);
    28cc:	4505                	li	a0,1
    28ce:	00003097          	auipc	ra,0x3
    28d2:	346080e7          	jalr	838(ra) # 5c14 <exit>
  close(fd);
    28d6:	854a                	mv	a0,s2
    28d8:	00003097          	auipc	ra,0x3
    28dc:	364080e7          	jalr	868(ra) # 5c3c <close>
  exit(0);
    28e0:	4501                	li	a0,0
    28e2:	00003097          	auipc	ra,0x3
    28e6:	332080e7          	jalr	818(ra) # 5c14 <exit>

00000000000028ea <sbrkbasic>:
{
    28ea:	7139                	add	sp,sp,-64
    28ec:	fc06                	sd	ra,56(sp)
    28ee:	f822                	sd	s0,48(sp)
    28f0:	ec4e                	sd	s3,24(sp)
    28f2:	0080                	add	s0,sp,64
    28f4:	89aa                	mv	s3,a0
  pid = fork();
    28f6:	00003097          	auipc	ra,0x3
    28fa:	316080e7          	jalr	790(ra) # 5c0c <fork>
  if(pid < 0){
    28fe:	02054f63          	bltz	a0,293c <sbrkbasic+0x52>
  if(pid == 0){
    2902:	e52d                	bnez	a0,296c <sbrkbasic+0x82>
    a = sbrk(TOOMUCH);
    2904:	40000537          	lui	a0,0x40000
    2908:	00003097          	auipc	ra,0x3
    290c:	394080e7          	jalr	916(ra) # 5c9c <sbrk>
    if(a == (char*)0xffffffffffffffffL){
    2910:	57fd                	li	a5,-1
    2912:	04f50563          	beq	a0,a5,295c <sbrkbasic+0x72>
    2916:	f426                	sd	s1,40(sp)
    2918:	f04a                	sd	s2,32(sp)
    291a:	e852                	sd	s4,16(sp)
    for(b = a; b < a+TOOMUCH; b += 4096){
    291c:	400007b7          	lui	a5,0x40000
    2920:	97aa                	add	a5,a5,a0
      *b = 99;
    2922:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += 4096){
    2926:	6705                	lui	a4,0x1
      *b = 99;
    2928:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff0388>
    for(b = a; b < a+TOOMUCH; b += 4096){
    292c:	953a                	add	a0,a0,a4
    292e:	fef51de3          	bne	a0,a5,2928 <sbrkbasic+0x3e>
    exit(1);
    2932:	4505                	li	a0,1
    2934:	00003097          	auipc	ra,0x3
    2938:	2e0080e7          	jalr	736(ra) # 5c14 <exit>
    293c:	f426                	sd	s1,40(sp)
    293e:	f04a                	sd	s2,32(sp)
    2940:	e852                	sd	s4,16(sp)
    printf("fork failed in sbrkbasic\n");
    2942:	00004517          	auipc	a0,0x4
    2946:	60e50513          	add	a0,a0,1550 # 6f50 <malloc+0xefc>
    294a:	00003097          	auipc	ra,0x3
    294e:	652080e7          	jalr	1618(ra) # 5f9c <printf>
    exit(1);
    2952:	4505                	li	a0,1
    2954:	00003097          	auipc	ra,0x3
    2958:	2c0080e7          	jalr	704(ra) # 5c14 <exit>
    295c:	f426                	sd	s1,40(sp)
    295e:	f04a                	sd	s2,32(sp)
    2960:	e852                	sd	s4,16(sp)
      exit(0);
    2962:	4501                	li	a0,0
    2964:	00003097          	auipc	ra,0x3
    2968:	2b0080e7          	jalr	688(ra) # 5c14 <exit>
  wait(&xstatus);
    296c:	fcc40513          	add	a0,s0,-52
    2970:	00003097          	auipc	ra,0x3
    2974:	2ac080e7          	jalr	684(ra) # 5c1c <wait>
  if(xstatus == 1){
    2978:	fcc42703          	lw	a4,-52(s0)
    297c:	4785                	li	a5,1
    297e:	02f70063          	beq	a4,a5,299e <sbrkbasic+0xb4>
    2982:	f426                	sd	s1,40(sp)
    2984:	f04a                	sd	s2,32(sp)
    2986:	e852                	sd	s4,16(sp)
  a = sbrk(0);
    2988:	4501                	li	a0,0
    298a:	00003097          	auipc	ra,0x3
    298e:	312080e7          	jalr	786(ra) # 5c9c <sbrk>
    2992:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2994:	4901                	li	s2,0
    2996:	6a05                	lui	s4,0x1
    2998:	388a0a13          	add	s4,s4,904 # 1388 <badarg+0x3e>
    299c:	a01d                	j	29c2 <sbrkbasic+0xd8>
    299e:	f426                	sd	s1,40(sp)
    29a0:	f04a                	sd	s2,32(sp)
    29a2:	e852                	sd	s4,16(sp)
    printf("%s: too much memory allocated!\n", s);
    29a4:	85ce                	mv	a1,s3
    29a6:	00004517          	auipc	a0,0x4
    29aa:	5ca50513          	add	a0,a0,1482 # 6f70 <malloc+0xf1c>
    29ae:	00003097          	auipc	ra,0x3
    29b2:	5ee080e7          	jalr	1518(ra) # 5f9c <printf>
    exit(1);
    29b6:	4505                	li	a0,1
    29b8:	00003097          	auipc	ra,0x3
    29bc:	25c080e7          	jalr	604(ra) # 5c14 <exit>
    29c0:	84be                	mv	s1,a5
    b = sbrk(1);
    29c2:	4505                	li	a0,1
    29c4:	00003097          	auipc	ra,0x3
    29c8:	2d8080e7          	jalr	728(ra) # 5c9c <sbrk>
    if(b != a){
    29cc:	04951c63          	bne	a0,s1,2a24 <sbrkbasic+0x13a>
    *b = 1;
    29d0:	4785                	li	a5,1
    29d2:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    29d6:	00148793          	add	a5,s1,1
  for(i = 0; i < 5000; i++){
    29da:	2905                	addw	s2,s2,1
    29dc:	ff4912e3          	bne	s2,s4,29c0 <sbrkbasic+0xd6>
  pid = fork();
    29e0:	00003097          	auipc	ra,0x3
    29e4:	22c080e7          	jalr	556(ra) # 5c0c <fork>
    29e8:	892a                	mv	s2,a0
  if(pid < 0){
    29ea:	04054e63          	bltz	a0,2a46 <sbrkbasic+0x15c>
  c = sbrk(1);
    29ee:	4505                	li	a0,1
    29f0:	00003097          	auipc	ra,0x3
    29f4:	2ac080e7          	jalr	684(ra) # 5c9c <sbrk>
  c = sbrk(1);
    29f8:	4505                	li	a0,1
    29fa:	00003097          	auipc	ra,0x3
    29fe:	2a2080e7          	jalr	674(ra) # 5c9c <sbrk>
  if(c != a + 1){
    2a02:	0489                	add	s1,s1,2
    2a04:	04a48f63          	beq	s1,a0,2a62 <sbrkbasic+0x178>
    printf("%s: sbrk test failed post-fork\n", s);
    2a08:	85ce                	mv	a1,s3
    2a0a:	00004517          	auipc	a0,0x4
    2a0e:	5c650513          	add	a0,a0,1478 # 6fd0 <malloc+0xf7c>
    2a12:	00003097          	auipc	ra,0x3
    2a16:	58a080e7          	jalr	1418(ra) # 5f9c <printf>
    exit(1);
    2a1a:	4505                	li	a0,1
    2a1c:	00003097          	auipc	ra,0x3
    2a20:	1f8080e7          	jalr	504(ra) # 5c14 <exit>
      printf("%s: sbrk test failed %d %x %x\n", s, i, a, b);
    2a24:	872a                	mv	a4,a0
    2a26:	86a6                	mv	a3,s1
    2a28:	864a                	mv	a2,s2
    2a2a:	85ce                	mv	a1,s3
    2a2c:	00004517          	auipc	a0,0x4
    2a30:	56450513          	add	a0,a0,1380 # 6f90 <malloc+0xf3c>
    2a34:	00003097          	auipc	ra,0x3
    2a38:	568080e7          	jalr	1384(ra) # 5f9c <printf>
      exit(1);
    2a3c:	4505                	li	a0,1
    2a3e:	00003097          	auipc	ra,0x3
    2a42:	1d6080e7          	jalr	470(ra) # 5c14 <exit>
    printf("%s: sbrk test fork failed\n", s);
    2a46:	85ce                	mv	a1,s3
    2a48:	00004517          	auipc	a0,0x4
    2a4c:	56850513          	add	a0,a0,1384 # 6fb0 <malloc+0xf5c>
    2a50:	00003097          	auipc	ra,0x3
    2a54:	54c080e7          	jalr	1356(ra) # 5f9c <printf>
    exit(1);
    2a58:	4505                	li	a0,1
    2a5a:	00003097          	auipc	ra,0x3
    2a5e:	1ba080e7          	jalr	442(ra) # 5c14 <exit>
  if(pid == 0)
    2a62:	00091763          	bnez	s2,2a70 <sbrkbasic+0x186>
    exit(0);
    2a66:	4501                	li	a0,0
    2a68:	00003097          	auipc	ra,0x3
    2a6c:	1ac080e7          	jalr	428(ra) # 5c14 <exit>
  wait(&xstatus);
    2a70:	fcc40513          	add	a0,s0,-52
    2a74:	00003097          	auipc	ra,0x3
    2a78:	1a8080e7          	jalr	424(ra) # 5c1c <wait>
  exit(xstatus);
    2a7c:	fcc42503          	lw	a0,-52(s0)
    2a80:	00003097          	auipc	ra,0x3
    2a84:	194080e7          	jalr	404(ra) # 5c14 <exit>

0000000000002a88 <sbrkmuch>:
{
    2a88:	7179                	add	sp,sp,-48
    2a8a:	f406                	sd	ra,40(sp)
    2a8c:	f022                	sd	s0,32(sp)
    2a8e:	ec26                	sd	s1,24(sp)
    2a90:	e84a                	sd	s2,16(sp)
    2a92:	e44e                	sd	s3,8(sp)
    2a94:	e052                	sd	s4,0(sp)
    2a96:	1800                	add	s0,sp,48
    2a98:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2a9a:	4501                	li	a0,0
    2a9c:	00003097          	auipc	ra,0x3
    2aa0:	200080e7          	jalr	512(ra) # 5c9c <sbrk>
    2aa4:	892a                	mv	s2,a0
  a = sbrk(0);
    2aa6:	4501                	li	a0,0
    2aa8:	00003097          	auipc	ra,0x3
    2aac:	1f4080e7          	jalr	500(ra) # 5c9c <sbrk>
    2ab0:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2ab2:	06400537          	lui	a0,0x6400
    2ab6:	9d05                	subw	a0,a0,s1
    2ab8:	00003097          	auipc	ra,0x3
    2abc:	1e4080e7          	jalr	484(ra) # 5c9c <sbrk>
  if (p != a) {
    2ac0:	0ca49863          	bne	s1,a0,2b90 <sbrkmuch+0x108>
  char *eee = sbrk(0);
    2ac4:	4501                	li	a0,0
    2ac6:	00003097          	auipc	ra,0x3
    2aca:	1d6080e7          	jalr	470(ra) # 5c9c <sbrk>
    2ace:	87aa                	mv	a5,a0
  for(char *pp = a; pp < eee; pp += 4096)
    2ad0:	00a4f963          	bgeu	s1,a0,2ae2 <sbrkmuch+0x5a>
    *pp = 1;
    2ad4:	4685                	li	a3,1
  for(char *pp = a; pp < eee; pp += 4096)
    2ad6:	6705                	lui	a4,0x1
    *pp = 1;
    2ad8:	00d48023          	sb	a3,0(s1)
  for(char *pp = a; pp < eee; pp += 4096)
    2adc:	94ba                	add	s1,s1,a4
    2ade:	fef4ede3          	bltu	s1,a5,2ad8 <sbrkmuch+0x50>
  *lastaddr = 99;
    2ae2:	064007b7          	lui	a5,0x6400
    2ae6:	06300713          	li	a4,99
    2aea:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f0387>
  a = sbrk(0);
    2aee:	4501                	li	a0,0
    2af0:	00003097          	auipc	ra,0x3
    2af4:	1ac080e7          	jalr	428(ra) # 5c9c <sbrk>
    2af8:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2afa:	757d                	lui	a0,0xfffff
    2afc:	00003097          	auipc	ra,0x3
    2b00:	1a0080e7          	jalr	416(ra) # 5c9c <sbrk>
  if(c == (char*)0xffffffffffffffffL){
    2b04:	57fd                	li	a5,-1
    2b06:	0af50363          	beq	a0,a5,2bac <sbrkmuch+0x124>
  c = sbrk(0);
    2b0a:	4501                	li	a0,0
    2b0c:	00003097          	auipc	ra,0x3
    2b10:	190080e7          	jalr	400(ra) # 5c9c <sbrk>
  if(c != a - PGSIZE){
    2b14:	77fd                	lui	a5,0xfffff
    2b16:	97a6                	add	a5,a5,s1
    2b18:	0af51863          	bne	a0,a5,2bc8 <sbrkmuch+0x140>
  a = sbrk(0);
    2b1c:	4501                	li	a0,0
    2b1e:	00003097          	auipc	ra,0x3
    2b22:	17e080e7          	jalr	382(ra) # 5c9c <sbrk>
    2b26:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2b28:	6505                	lui	a0,0x1
    2b2a:	00003097          	auipc	ra,0x3
    2b2e:	172080e7          	jalr	370(ra) # 5c9c <sbrk>
    2b32:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2b34:	0aa49a63          	bne	s1,a0,2be8 <sbrkmuch+0x160>
    2b38:	4501                	li	a0,0
    2b3a:	00003097          	auipc	ra,0x3
    2b3e:	162080e7          	jalr	354(ra) # 5c9c <sbrk>
    2b42:	6785                	lui	a5,0x1
    2b44:	97a6                	add	a5,a5,s1
    2b46:	0af51163          	bne	a0,a5,2be8 <sbrkmuch+0x160>
  if(*lastaddr == 99){
    2b4a:	064007b7          	lui	a5,0x6400
    2b4e:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f0387>
    2b52:	06300793          	li	a5,99
    2b56:	0af70963          	beq	a4,a5,2c08 <sbrkmuch+0x180>
  a = sbrk(0);
    2b5a:	4501                	li	a0,0
    2b5c:	00003097          	auipc	ra,0x3
    2b60:	140080e7          	jalr	320(ra) # 5c9c <sbrk>
    2b64:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2b66:	4501                	li	a0,0
    2b68:	00003097          	auipc	ra,0x3
    2b6c:	134080e7          	jalr	308(ra) # 5c9c <sbrk>
    2b70:	40a9053b          	subw	a0,s2,a0
    2b74:	00003097          	auipc	ra,0x3
    2b78:	128080e7          	jalr	296(ra) # 5c9c <sbrk>
  if(c != a){
    2b7c:	0aa49463          	bne	s1,a0,2c24 <sbrkmuch+0x19c>
}
    2b80:	70a2                	ld	ra,40(sp)
    2b82:	7402                	ld	s0,32(sp)
    2b84:	64e2                	ld	s1,24(sp)
    2b86:	6942                	ld	s2,16(sp)
    2b88:	69a2                	ld	s3,8(sp)
    2b8a:	6a02                	ld	s4,0(sp)
    2b8c:	6145                	add	sp,sp,48
    2b8e:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    2b90:	85ce                	mv	a1,s3
    2b92:	00004517          	auipc	a0,0x4
    2b96:	45e50513          	add	a0,a0,1118 # 6ff0 <malloc+0xf9c>
    2b9a:	00003097          	auipc	ra,0x3
    2b9e:	402080e7          	jalr	1026(ra) # 5f9c <printf>
    exit(1);
    2ba2:	4505                	li	a0,1
    2ba4:	00003097          	auipc	ra,0x3
    2ba8:	070080e7          	jalr	112(ra) # 5c14 <exit>
    printf("%s: sbrk could not deallocate\n", s);
    2bac:	85ce                	mv	a1,s3
    2bae:	00004517          	auipc	a0,0x4
    2bb2:	48a50513          	add	a0,a0,1162 # 7038 <malloc+0xfe4>
    2bb6:	00003097          	auipc	ra,0x3
    2bba:	3e6080e7          	jalr	998(ra) # 5f9c <printf>
    exit(1);
    2bbe:	4505                	li	a0,1
    2bc0:	00003097          	auipc	ra,0x3
    2bc4:	054080e7          	jalr	84(ra) # 5c14 <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", s, a, c);
    2bc8:	86aa                	mv	a3,a0
    2bca:	8626                	mv	a2,s1
    2bcc:	85ce                	mv	a1,s3
    2bce:	00004517          	auipc	a0,0x4
    2bd2:	48a50513          	add	a0,a0,1162 # 7058 <malloc+0x1004>
    2bd6:	00003097          	auipc	ra,0x3
    2bda:	3c6080e7          	jalr	966(ra) # 5f9c <printf>
    exit(1);
    2bde:	4505                	li	a0,1
    2be0:	00003097          	auipc	ra,0x3
    2be4:	034080e7          	jalr	52(ra) # 5c14 <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", s, a, c);
    2be8:	86d2                	mv	a3,s4
    2bea:	8626                	mv	a2,s1
    2bec:	85ce                	mv	a1,s3
    2bee:	00004517          	auipc	a0,0x4
    2bf2:	4aa50513          	add	a0,a0,1194 # 7098 <malloc+0x1044>
    2bf6:	00003097          	auipc	ra,0x3
    2bfa:	3a6080e7          	jalr	934(ra) # 5f9c <printf>
    exit(1);
    2bfe:	4505                	li	a0,1
    2c00:	00003097          	auipc	ra,0x3
    2c04:	014080e7          	jalr	20(ra) # 5c14 <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2c08:	85ce                	mv	a1,s3
    2c0a:	00004517          	auipc	a0,0x4
    2c0e:	4be50513          	add	a0,a0,1214 # 70c8 <malloc+0x1074>
    2c12:	00003097          	auipc	ra,0x3
    2c16:	38a080e7          	jalr	906(ra) # 5f9c <printf>
    exit(1);
    2c1a:	4505                	li	a0,1
    2c1c:	00003097          	auipc	ra,0x3
    2c20:	ff8080e7          	jalr	-8(ra) # 5c14 <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", s, a, c);
    2c24:	86aa                	mv	a3,a0
    2c26:	8626                	mv	a2,s1
    2c28:	85ce                	mv	a1,s3
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	4d650513          	add	a0,a0,1238 # 7100 <malloc+0x10ac>
    2c32:	00003097          	auipc	ra,0x3
    2c36:	36a080e7          	jalr	874(ra) # 5f9c <printf>
    exit(1);
    2c3a:	4505                	li	a0,1
    2c3c:	00003097          	auipc	ra,0x3
    2c40:	fd8080e7          	jalr	-40(ra) # 5c14 <exit>

0000000000002c44 <sbrkarg>:
{
    2c44:	7179                	add	sp,sp,-48
    2c46:	f406                	sd	ra,40(sp)
    2c48:	f022                	sd	s0,32(sp)
    2c4a:	ec26                	sd	s1,24(sp)
    2c4c:	e84a                	sd	s2,16(sp)
    2c4e:	e44e                	sd	s3,8(sp)
    2c50:	1800                	add	s0,sp,48
    2c52:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2c54:	6505                	lui	a0,0x1
    2c56:	00003097          	auipc	ra,0x3
    2c5a:	046080e7          	jalr	70(ra) # 5c9c <sbrk>
    2c5e:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    2c60:	20100593          	li	a1,513
    2c64:	00004517          	auipc	a0,0x4
    2c68:	4c450513          	add	a0,a0,1220 # 7128 <malloc+0x10d4>
    2c6c:	00003097          	auipc	ra,0x3
    2c70:	fe8080e7          	jalr	-24(ra) # 5c54 <open>
    2c74:	84aa                	mv	s1,a0
  unlink("sbrk");
    2c76:	00004517          	auipc	a0,0x4
    2c7a:	4b250513          	add	a0,a0,1202 # 7128 <malloc+0x10d4>
    2c7e:	00003097          	auipc	ra,0x3
    2c82:	fe6080e7          	jalr	-26(ra) # 5c64 <unlink>
  if(fd < 0)  {
    2c86:	0404c163          	bltz	s1,2cc8 <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2c8a:	6605                	lui	a2,0x1
    2c8c:	85ca                	mv	a1,s2
    2c8e:	8526                	mv	a0,s1
    2c90:	00003097          	auipc	ra,0x3
    2c94:	fa4080e7          	jalr	-92(ra) # 5c34 <write>
    2c98:	04054663          	bltz	a0,2ce4 <sbrkarg+0xa0>
  close(fd);
    2c9c:	8526                	mv	a0,s1
    2c9e:	00003097          	auipc	ra,0x3
    2ca2:	f9e080e7          	jalr	-98(ra) # 5c3c <close>
  a = sbrk(PGSIZE);
    2ca6:	6505                	lui	a0,0x1
    2ca8:	00003097          	auipc	ra,0x3
    2cac:	ff4080e7          	jalr	-12(ra) # 5c9c <sbrk>
  if(pipe((int *) a) != 0){
    2cb0:	00003097          	auipc	ra,0x3
    2cb4:	f74080e7          	jalr	-140(ra) # 5c24 <pipe>
    2cb8:	e521                	bnez	a0,2d00 <sbrkarg+0xbc>
}
    2cba:	70a2                	ld	ra,40(sp)
    2cbc:	7402                	ld	s0,32(sp)
    2cbe:	64e2                	ld	s1,24(sp)
    2cc0:	6942                	ld	s2,16(sp)
    2cc2:	69a2                	ld	s3,8(sp)
    2cc4:	6145                	add	sp,sp,48
    2cc6:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2cc8:	85ce                	mv	a1,s3
    2cca:	00004517          	auipc	a0,0x4
    2cce:	46650513          	add	a0,a0,1126 # 7130 <malloc+0x10dc>
    2cd2:	00003097          	auipc	ra,0x3
    2cd6:	2ca080e7          	jalr	714(ra) # 5f9c <printf>
    exit(1);
    2cda:	4505                	li	a0,1
    2cdc:	00003097          	auipc	ra,0x3
    2ce0:	f38080e7          	jalr	-200(ra) # 5c14 <exit>
    printf("%s: write sbrk failed\n", s);
    2ce4:	85ce                	mv	a1,s3
    2ce6:	00004517          	auipc	a0,0x4
    2cea:	46250513          	add	a0,a0,1122 # 7148 <malloc+0x10f4>
    2cee:	00003097          	auipc	ra,0x3
    2cf2:	2ae080e7          	jalr	686(ra) # 5f9c <printf>
    exit(1);
    2cf6:	4505                	li	a0,1
    2cf8:	00003097          	auipc	ra,0x3
    2cfc:	f1c080e7          	jalr	-228(ra) # 5c14 <exit>
    printf("%s: pipe() failed\n", s);
    2d00:	85ce                	mv	a1,s3
    2d02:	00004517          	auipc	a0,0x4
    2d06:	e2650513          	add	a0,a0,-474 # 6b28 <malloc+0xad4>
    2d0a:	00003097          	auipc	ra,0x3
    2d0e:	292080e7          	jalr	658(ra) # 5f9c <printf>
    exit(1);
    2d12:	4505                	li	a0,1
    2d14:	00003097          	auipc	ra,0x3
    2d18:	f00080e7          	jalr	-256(ra) # 5c14 <exit>

0000000000002d1c <argptest>:
{
    2d1c:	1101                	add	sp,sp,-32
    2d1e:	ec06                	sd	ra,24(sp)
    2d20:	e822                	sd	s0,16(sp)
    2d22:	e426                	sd	s1,8(sp)
    2d24:	e04a                	sd	s2,0(sp)
    2d26:	1000                	add	s0,sp,32
    2d28:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2d2a:	4581                	li	a1,0
    2d2c:	00004517          	auipc	a0,0x4
    2d30:	43450513          	add	a0,a0,1076 # 7160 <malloc+0x110c>
    2d34:	00003097          	auipc	ra,0x3
    2d38:	f20080e7          	jalr	-224(ra) # 5c54 <open>
  if (fd < 0) {
    2d3c:	02054b63          	bltz	a0,2d72 <argptest+0x56>
    2d40:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    2d42:	4501                	li	a0,0
    2d44:	00003097          	auipc	ra,0x3
    2d48:	f58080e7          	jalr	-168(ra) # 5c9c <sbrk>
    2d4c:	567d                	li	a2,-1
    2d4e:	fff50593          	add	a1,a0,-1
    2d52:	8526                	mv	a0,s1
    2d54:	00003097          	auipc	ra,0x3
    2d58:	ed8080e7          	jalr	-296(ra) # 5c2c <read>
  close(fd);
    2d5c:	8526                	mv	a0,s1
    2d5e:	00003097          	auipc	ra,0x3
    2d62:	ede080e7          	jalr	-290(ra) # 5c3c <close>
}
    2d66:	60e2                	ld	ra,24(sp)
    2d68:	6442                	ld	s0,16(sp)
    2d6a:	64a2                	ld	s1,8(sp)
    2d6c:	6902                	ld	s2,0(sp)
    2d6e:	6105                	add	sp,sp,32
    2d70:	8082                	ret
    printf("%s: open failed\n", s);
    2d72:	85ca                	mv	a1,s2
    2d74:	00004517          	auipc	a0,0x4
    2d78:	cc450513          	add	a0,a0,-828 # 6a38 <malloc+0x9e4>
    2d7c:	00003097          	auipc	ra,0x3
    2d80:	220080e7          	jalr	544(ra) # 5f9c <printf>
    exit(1);
    2d84:	4505                	li	a0,1
    2d86:	00003097          	auipc	ra,0x3
    2d8a:	e8e080e7          	jalr	-370(ra) # 5c14 <exit>

0000000000002d8e <sbrkbugs>:
{
    2d8e:	1141                	add	sp,sp,-16
    2d90:	e406                	sd	ra,8(sp)
    2d92:	e022                	sd	s0,0(sp)
    2d94:	0800                	add	s0,sp,16
  int pid = fork();
    2d96:	00003097          	auipc	ra,0x3
    2d9a:	e76080e7          	jalr	-394(ra) # 5c0c <fork>
  if(pid < 0){
    2d9e:	02054263          	bltz	a0,2dc2 <sbrkbugs+0x34>
  if(pid == 0){
    2da2:	ed0d                	bnez	a0,2ddc <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    2da4:	00003097          	auipc	ra,0x3
    2da8:	ef8080e7          	jalr	-264(ra) # 5c9c <sbrk>
    sbrk(-sz);
    2dac:	40a0053b          	negw	a0,a0
    2db0:	00003097          	auipc	ra,0x3
    2db4:	eec080e7          	jalr	-276(ra) # 5c9c <sbrk>
    exit(0);
    2db8:	4501                	li	a0,0
    2dba:	00003097          	auipc	ra,0x3
    2dbe:	e5a080e7          	jalr	-422(ra) # 5c14 <exit>
    printf("fork failed\n");
    2dc2:	00004517          	auipc	a0,0x4
    2dc6:	06650513          	add	a0,a0,102 # 6e28 <malloc+0xdd4>
    2dca:	00003097          	auipc	ra,0x3
    2dce:	1d2080e7          	jalr	466(ra) # 5f9c <printf>
    exit(1);
    2dd2:	4505                	li	a0,1
    2dd4:	00003097          	auipc	ra,0x3
    2dd8:	e40080e7          	jalr	-448(ra) # 5c14 <exit>
  wait(0);
    2ddc:	4501                	li	a0,0
    2dde:	00003097          	auipc	ra,0x3
    2de2:	e3e080e7          	jalr	-450(ra) # 5c1c <wait>
  pid = fork();
    2de6:	00003097          	auipc	ra,0x3
    2dea:	e26080e7          	jalr	-474(ra) # 5c0c <fork>
  if(pid < 0){
    2dee:	02054563          	bltz	a0,2e18 <sbrkbugs+0x8a>
  if(pid == 0){
    2df2:	e121                	bnez	a0,2e32 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    2df4:	00003097          	auipc	ra,0x3
    2df8:	ea8080e7          	jalr	-344(ra) # 5c9c <sbrk>
    sbrk(-(sz - 3500));
    2dfc:	6785                	lui	a5,0x1
    2dfe:	dac7879b          	addw	a5,a5,-596 # dac <unlinkread+0x6e>
    2e02:	40a7853b          	subw	a0,a5,a0
    2e06:	00003097          	auipc	ra,0x3
    2e0a:	e96080e7          	jalr	-362(ra) # 5c9c <sbrk>
    exit(0);
    2e0e:	4501                	li	a0,0
    2e10:	00003097          	auipc	ra,0x3
    2e14:	e04080e7          	jalr	-508(ra) # 5c14 <exit>
    printf("fork failed\n");
    2e18:	00004517          	auipc	a0,0x4
    2e1c:	01050513          	add	a0,a0,16 # 6e28 <malloc+0xdd4>
    2e20:	00003097          	auipc	ra,0x3
    2e24:	17c080e7          	jalr	380(ra) # 5f9c <printf>
    exit(1);
    2e28:	4505                	li	a0,1
    2e2a:	00003097          	auipc	ra,0x3
    2e2e:	dea080e7          	jalr	-534(ra) # 5c14 <exit>
  wait(0);
    2e32:	4501                	li	a0,0
    2e34:	00003097          	auipc	ra,0x3
    2e38:	de8080e7          	jalr	-536(ra) # 5c1c <wait>
  pid = fork();
    2e3c:	00003097          	auipc	ra,0x3
    2e40:	dd0080e7          	jalr	-560(ra) # 5c0c <fork>
  if(pid < 0){
    2e44:	02054a63          	bltz	a0,2e78 <sbrkbugs+0xea>
  if(pid == 0){
    2e48:	e529                	bnez	a0,2e92 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    2e4a:	00003097          	auipc	ra,0x3
    2e4e:	e52080e7          	jalr	-430(ra) # 5c9c <sbrk>
    2e52:	67ad                	lui	a5,0xb
    2e54:	8007879b          	addw	a5,a5,-2048 # a800 <uninit+0x298>
    2e58:	40a7853b          	subw	a0,a5,a0
    2e5c:	00003097          	auipc	ra,0x3
    2e60:	e40080e7          	jalr	-448(ra) # 5c9c <sbrk>
    sbrk(-10);
    2e64:	5559                	li	a0,-10
    2e66:	00003097          	auipc	ra,0x3
    2e6a:	e36080e7          	jalr	-458(ra) # 5c9c <sbrk>
    exit(0);
    2e6e:	4501                	li	a0,0
    2e70:	00003097          	auipc	ra,0x3
    2e74:	da4080e7          	jalr	-604(ra) # 5c14 <exit>
    printf("fork failed\n");
    2e78:	00004517          	auipc	a0,0x4
    2e7c:	fb050513          	add	a0,a0,-80 # 6e28 <malloc+0xdd4>
    2e80:	00003097          	auipc	ra,0x3
    2e84:	11c080e7          	jalr	284(ra) # 5f9c <printf>
    exit(1);
    2e88:	4505                	li	a0,1
    2e8a:	00003097          	auipc	ra,0x3
    2e8e:	d8a080e7          	jalr	-630(ra) # 5c14 <exit>
  wait(0);
    2e92:	4501                	li	a0,0
    2e94:	00003097          	auipc	ra,0x3
    2e98:	d88080e7          	jalr	-632(ra) # 5c1c <wait>
  exit(0);
    2e9c:	4501                	li	a0,0
    2e9e:	00003097          	auipc	ra,0x3
    2ea2:	d76080e7          	jalr	-650(ra) # 5c14 <exit>

0000000000002ea6 <sbrklast>:
{
    2ea6:	7179                	add	sp,sp,-48
    2ea8:	f406                	sd	ra,40(sp)
    2eaa:	f022                	sd	s0,32(sp)
    2eac:	ec26                	sd	s1,24(sp)
    2eae:	e84a                	sd	s2,16(sp)
    2eb0:	e44e                	sd	s3,8(sp)
    2eb2:	e052                	sd	s4,0(sp)
    2eb4:	1800                	add	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    2eb6:	4501                	li	a0,0
    2eb8:	00003097          	auipc	ra,0x3
    2ebc:	de4080e7          	jalr	-540(ra) # 5c9c <sbrk>
  if((top % 4096) != 0)
    2ec0:	03451793          	sll	a5,a0,0x34
    2ec4:	ebd9                	bnez	a5,2f5a <sbrklast+0xb4>
  sbrk(4096);
    2ec6:	6505                	lui	a0,0x1
    2ec8:	00003097          	auipc	ra,0x3
    2ecc:	dd4080e7          	jalr	-556(ra) # 5c9c <sbrk>
  sbrk(10);
    2ed0:	4529                	li	a0,10
    2ed2:	00003097          	auipc	ra,0x3
    2ed6:	dca080e7          	jalr	-566(ra) # 5c9c <sbrk>
  sbrk(-20);
    2eda:	5531                	li	a0,-20
    2edc:	00003097          	auipc	ra,0x3
    2ee0:	dc0080e7          	jalr	-576(ra) # 5c9c <sbrk>
  top = (uint64) sbrk(0);
    2ee4:	4501                	li	a0,0
    2ee6:	00003097          	auipc	ra,0x3
    2eea:	db6080e7          	jalr	-586(ra) # 5c9c <sbrk>
    2eee:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2ef0:	fc050913          	add	s2,a0,-64 # fc0 <linktest+0xcc>
  p[0] = 'x';
    2ef4:	07800a13          	li	s4,120
    2ef8:	fd450023          	sb	s4,-64(a0)
  p[1] = '\0';
    2efc:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2f00:	20200593          	li	a1,514
    2f04:	854a                	mv	a0,s2
    2f06:	00003097          	auipc	ra,0x3
    2f0a:	d4e080e7          	jalr	-690(ra) # 5c54 <open>
    2f0e:	89aa                	mv	s3,a0
  write(fd, p, 1);
    2f10:	4605                	li	a2,1
    2f12:	85ca                	mv	a1,s2
    2f14:	00003097          	auipc	ra,0x3
    2f18:	d20080e7          	jalr	-736(ra) # 5c34 <write>
  close(fd);
    2f1c:	854e                	mv	a0,s3
    2f1e:	00003097          	auipc	ra,0x3
    2f22:	d1e080e7          	jalr	-738(ra) # 5c3c <close>
  fd = open(p, O_RDWR);
    2f26:	4589                	li	a1,2
    2f28:	854a                	mv	a0,s2
    2f2a:	00003097          	auipc	ra,0x3
    2f2e:	d2a080e7          	jalr	-726(ra) # 5c54 <open>
  p[0] = '\0';
    2f32:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2f36:	4605                	li	a2,1
    2f38:	85ca                	mv	a1,s2
    2f3a:	00003097          	auipc	ra,0x3
    2f3e:	cf2080e7          	jalr	-782(ra) # 5c2c <read>
  if(p[0] != 'x')
    2f42:	fc04c783          	lbu	a5,-64(s1)
    2f46:	03479463          	bne	a5,s4,2f6e <sbrklast+0xc8>
}
    2f4a:	70a2                	ld	ra,40(sp)
    2f4c:	7402                	ld	s0,32(sp)
    2f4e:	64e2                	ld	s1,24(sp)
    2f50:	6942                	ld	s2,16(sp)
    2f52:	69a2                	ld	s3,8(sp)
    2f54:	6a02                	ld	s4,0(sp)
    2f56:	6145                	add	sp,sp,48
    2f58:	8082                	ret
    sbrk(4096 - (top % 4096));
    2f5a:	0347d513          	srl	a0,a5,0x34
    2f5e:	6785                	lui	a5,0x1
    2f60:	40a7853b          	subw	a0,a5,a0
    2f64:	00003097          	auipc	ra,0x3
    2f68:	d38080e7          	jalr	-712(ra) # 5c9c <sbrk>
    2f6c:	bfa9                	j	2ec6 <sbrklast+0x20>
    exit(1);
    2f6e:	4505                	li	a0,1
    2f70:	00003097          	auipc	ra,0x3
    2f74:	ca4080e7          	jalr	-860(ra) # 5c14 <exit>

0000000000002f78 <sbrk8000>:
{
    2f78:	1141                	add	sp,sp,-16
    2f7a:	e406                	sd	ra,8(sp)
    2f7c:	e022                	sd	s0,0(sp)
    2f7e:	0800                	add	s0,sp,16
  sbrk(0x80000004);
    2f80:	80000537          	lui	a0,0x80000
    2f84:	0511                	add	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff038c>
    2f86:	00003097          	auipc	ra,0x3
    2f8a:	d16080e7          	jalr	-746(ra) # 5c9c <sbrk>
  volatile char *top = sbrk(0);
    2f8e:	4501                	li	a0,0
    2f90:	00003097          	auipc	ra,0x3
    2f94:	d0c080e7          	jalr	-756(ra) # 5c9c <sbrk>
  *(top-1) = *(top-1) + 1;
    2f98:	fff54783          	lbu	a5,-1(a0)
    2f9c:	2785                	addw	a5,a5,1 # 1001 <linktest+0x10d>
    2f9e:	0ff7f793          	zext.b	a5,a5
    2fa2:	fef50fa3          	sb	a5,-1(a0)
}
    2fa6:	60a2                	ld	ra,8(sp)
    2fa8:	6402                	ld	s0,0(sp)
    2faa:	0141                	add	sp,sp,16
    2fac:	8082                	ret

0000000000002fae <execout>:
{
    2fae:	715d                	add	sp,sp,-80
    2fb0:	e486                	sd	ra,72(sp)
    2fb2:	e0a2                	sd	s0,64(sp)
    2fb4:	fc26                	sd	s1,56(sp)
    2fb6:	f84a                	sd	s2,48(sp)
    2fb8:	f44e                	sd	s3,40(sp)
    2fba:	f052                	sd	s4,32(sp)
    2fbc:	0880                	add	s0,sp,80
  for(int avail = 0; avail < 15; avail++){
    2fbe:	4901                	li	s2,0
    2fc0:	49bd                	li	s3,15
    int pid = fork();
    2fc2:	00003097          	auipc	ra,0x3
    2fc6:	c4a080e7          	jalr	-950(ra) # 5c0c <fork>
    2fca:	84aa                	mv	s1,a0
    if(pid < 0){
    2fcc:	02054063          	bltz	a0,2fec <execout+0x3e>
    } else if(pid == 0){
    2fd0:	c91d                	beqz	a0,3006 <execout+0x58>
      wait((int*)0);
    2fd2:	4501                	li	a0,0
    2fd4:	00003097          	auipc	ra,0x3
    2fd8:	c48080e7          	jalr	-952(ra) # 5c1c <wait>
  for(int avail = 0; avail < 15; avail++){
    2fdc:	2905                	addw	s2,s2,1
    2fde:	ff3912e3          	bne	s2,s3,2fc2 <execout+0x14>
  exit(0);
    2fe2:	4501                	li	a0,0
    2fe4:	00003097          	auipc	ra,0x3
    2fe8:	c30080e7          	jalr	-976(ra) # 5c14 <exit>
      printf("fork failed\n");
    2fec:	00004517          	auipc	a0,0x4
    2ff0:	e3c50513          	add	a0,a0,-452 # 6e28 <malloc+0xdd4>
    2ff4:	00003097          	auipc	ra,0x3
    2ff8:	fa8080e7          	jalr	-88(ra) # 5f9c <printf>
      exit(1);
    2ffc:	4505                	li	a0,1
    2ffe:	00003097          	auipc	ra,0x3
    3002:	c16080e7          	jalr	-1002(ra) # 5c14 <exit>
        if(a == 0xffffffffffffffffLL)
    3006:	59fd                	li	s3,-1
        *(char*)(a + 4096 - 1) = 1;
    3008:	4a05                	li	s4,1
        uint64 a = (uint64) sbrk(4096);
    300a:	6505                	lui	a0,0x1
    300c:	00003097          	auipc	ra,0x3
    3010:	c90080e7          	jalr	-880(ra) # 5c9c <sbrk>
        if(a == 0xffffffffffffffffLL)
    3014:	01350763          	beq	a0,s3,3022 <execout+0x74>
        *(char*)(a + 4096 - 1) = 1;
    3018:	6785                	lui	a5,0x1
    301a:	97aa                	add	a5,a5,a0
    301c:	ff478fa3          	sb	s4,-1(a5) # fff <linktest+0x10b>
      while(1){
    3020:	b7ed                	j	300a <execout+0x5c>
      for(int i = 0; i < avail; i++)
    3022:	01205a63          	blez	s2,3036 <execout+0x88>
        sbrk(-4096);
    3026:	757d                	lui	a0,0xfffff
    3028:	00003097          	auipc	ra,0x3
    302c:	c74080e7          	jalr	-908(ra) # 5c9c <sbrk>
      for(int i = 0; i < avail; i++)
    3030:	2485                	addw	s1,s1,1
    3032:	ff249ae3          	bne	s1,s2,3026 <execout+0x78>
      close(1);
    3036:	4505                	li	a0,1
    3038:	00003097          	auipc	ra,0x3
    303c:	c04080e7          	jalr	-1020(ra) # 5c3c <close>
      char *args[] = { "echo", "x", 0 };
    3040:	00003517          	auipc	a0,0x3
    3044:	15850513          	add	a0,a0,344 # 6198 <malloc+0x144>
    3048:	faa43c23          	sd	a0,-72(s0)
    304c:	00003797          	auipc	a5,0x3
    3050:	1bc78793          	add	a5,a5,444 # 6208 <malloc+0x1b4>
    3054:	fcf43023          	sd	a5,-64(s0)
    3058:	fc043423          	sd	zero,-56(s0)
      exec("echo", args);
    305c:	fb840593          	add	a1,s0,-72
    3060:	00003097          	auipc	ra,0x3
    3064:	bec080e7          	jalr	-1044(ra) # 5c4c <exec>
      exit(0);
    3068:	4501                	li	a0,0
    306a:	00003097          	auipc	ra,0x3
    306e:	baa080e7          	jalr	-1110(ra) # 5c14 <exit>

0000000000003072 <fourteen>:
{
    3072:	1101                	add	sp,sp,-32
    3074:	ec06                	sd	ra,24(sp)
    3076:	e822                	sd	s0,16(sp)
    3078:	e426                	sd	s1,8(sp)
    307a:	1000                	add	s0,sp,32
    307c:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    307e:	00004517          	auipc	a0,0x4
    3082:	2ba50513          	add	a0,a0,698 # 7338 <malloc+0x12e4>
    3086:	00003097          	auipc	ra,0x3
    308a:	bf6080e7          	jalr	-1034(ra) # 5c7c <mkdir>
    308e:	e165                	bnez	a0,316e <fourteen+0xfc>
  if(mkdir("12345678901234/123456789012345") != 0){
    3090:	00004517          	auipc	a0,0x4
    3094:	10050513          	add	a0,a0,256 # 7190 <malloc+0x113c>
    3098:	00003097          	auipc	ra,0x3
    309c:	be4080e7          	jalr	-1052(ra) # 5c7c <mkdir>
    30a0:	e56d                	bnez	a0,318a <fourteen+0x118>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    30a2:	20000593          	li	a1,512
    30a6:	00004517          	auipc	a0,0x4
    30aa:	14250513          	add	a0,a0,322 # 71e8 <malloc+0x1194>
    30ae:	00003097          	auipc	ra,0x3
    30b2:	ba6080e7          	jalr	-1114(ra) # 5c54 <open>
  if(fd < 0){
    30b6:	0e054863          	bltz	a0,31a6 <fourteen+0x134>
  close(fd);
    30ba:	00003097          	auipc	ra,0x3
    30be:	b82080e7          	jalr	-1150(ra) # 5c3c <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    30c2:	4581                	li	a1,0
    30c4:	00004517          	auipc	a0,0x4
    30c8:	19c50513          	add	a0,a0,412 # 7260 <malloc+0x120c>
    30cc:	00003097          	auipc	ra,0x3
    30d0:	b88080e7          	jalr	-1144(ra) # 5c54 <open>
  if(fd < 0){
    30d4:	0e054763          	bltz	a0,31c2 <fourteen+0x150>
  close(fd);
    30d8:	00003097          	auipc	ra,0x3
    30dc:	b64080e7          	jalr	-1180(ra) # 5c3c <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    30e0:	00004517          	auipc	a0,0x4
    30e4:	1f050513          	add	a0,a0,496 # 72d0 <malloc+0x127c>
    30e8:	00003097          	auipc	ra,0x3
    30ec:	b94080e7          	jalr	-1132(ra) # 5c7c <mkdir>
    30f0:	c57d                	beqz	a0,31de <fourteen+0x16c>
  if(mkdir("123456789012345/12345678901234") == 0){
    30f2:	00004517          	auipc	a0,0x4
    30f6:	23650513          	add	a0,a0,566 # 7328 <malloc+0x12d4>
    30fa:	00003097          	auipc	ra,0x3
    30fe:	b82080e7          	jalr	-1150(ra) # 5c7c <mkdir>
    3102:	cd65                	beqz	a0,31fa <fourteen+0x188>
  unlink("123456789012345/12345678901234");
    3104:	00004517          	auipc	a0,0x4
    3108:	22450513          	add	a0,a0,548 # 7328 <malloc+0x12d4>
    310c:	00003097          	auipc	ra,0x3
    3110:	b58080e7          	jalr	-1192(ra) # 5c64 <unlink>
  unlink("12345678901234/12345678901234");
    3114:	00004517          	auipc	a0,0x4
    3118:	1bc50513          	add	a0,a0,444 # 72d0 <malloc+0x127c>
    311c:	00003097          	auipc	ra,0x3
    3120:	b48080e7          	jalr	-1208(ra) # 5c64 <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    3124:	00004517          	auipc	a0,0x4
    3128:	13c50513          	add	a0,a0,316 # 7260 <malloc+0x120c>
    312c:	00003097          	auipc	ra,0x3
    3130:	b38080e7          	jalr	-1224(ra) # 5c64 <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    3134:	00004517          	auipc	a0,0x4
    3138:	0b450513          	add	a0,a0,180 # 71e8 <malloc+0x1194>
    313c:	00003097          	auipc	ra,0x3
    3140:	b28080e7          	jalr	-1240(ra) # 5c64 <unlink>
  unlink("12345678901234/123456789012345");
    3144:	00004517          	auipc	a0,0x4
    3148:	04c50513          	add	a0,a0,76 # 7190 <malloc+0x113c>
    314c:	00003097          	auipc	ra,0x3
    3150:	b18080e7          	jalr	-1256(ra) # 5c64 <unlink>
  unlink("12345678901234");
    3154:	00004517          	auipc	a0,0x4
    3158:	1e450513          	add	a0,a0,484 # 7338 <malloc+0x12e4>
    315c:	00003097          	auipc	ra,0x3
    3160:	b08080e7          	jalr	-1272(ra) # 5c64 <unlink>
}
    3164:	60e2                	ld	ra,24(sp)
    3166:	6442                	ld	s0,16(sp)
    3168:	64a2                	ld	s1,8(sp)
    316a:	6105                	add	sp,sp,32
    316c:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    316e:	85a6                	mv	a1,s1
    3170:	00004517          	auipc	a0,0x4
    3174:	ff850513          	add	a0,a0,-8 # 7168 <malloc+0x1114>
    3178:	00003097          	auipc	ra,0x3
    317c:	e24080e7          	jalr	-476(ra) # 5f9c <printf>
    exit(1);
    3180:	4505                	li	a0,1
    3182:	00003097          	auipc	ra,0x3
    3186:	a92080e7          	jalr	-1390(ra) # 5c14 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    318a:	85a6                	mv	a1,s1
    318c:	00004517          	auipc	a0,0x4
    3190:	02450513          	add	a0,a0,36 # 71b0 <malloc+0x115c>
    3194:	00003097          	auipc	ra,0x3
    3198:	e08080e7          	jalr	-504(ra) # 5f9c <printf>
    exit(1);
    319c:	4505                	li	a0,1
    319e:	00003097          	auipc	ra,0x3
    31a2:	a76080e7          	jalr	-1418(ra) # 5c14 <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    31a6:	85a6                	mv	a1,s1
    31a8:	00004517          	auipc	a0,0x4
    31ac:	07050513          	add	a0,a0,112 # 7218 <malloc+0x11c4>
    31b0:	00003097          	auipc	ra,0x3
    31b4:	dec080e7          	jalr	-532(ra) # 5f9c <printf>
    exit(1);
    31b8:	4505                	li	a0,1
    31ba:	00003097          	auipc	ra,0x3
    31be:	a5a080e7          	jalr	-1446(ra) # 5c14 <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    31c2:	85a6                	mv	a1,s1
    31c4:	00004517          	auipc	a0,0x4
    31c8:	0cc50513          	add	a0,a0,204 # 7290 <malloc+0x123c>
    31cc:	00003097          	auipc	ra,0x3
    31d0:	dd0080e7          	jalr	-560(ra) # 5f9c <printf>
    exit(1);
    31d4:	4505                	li	a0,1
    31d6:	00003097          	auipc	ra,0x3
    31da:	a3e080e7          	jalr	-1474(ra) # 5c14 <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    31de:	85a6                	mv	a1,s1
    31e0:	00004517          	auipc	a0,0x4
    31e4:	11050513          	add	a0,a0,272 # 72f0 <malloc+0x129c>
    31e8:	00003097          	auipc	ra,0x3
    31ec:	db4080e7          	jalr	-588(ra) # 5f9c <printf>
    exit(1);
    31f0:	4505                	li	a0,1
    31f2:	00003097          	auipc	ra,0x3
    31f6:	a22080e7          	jalr	-1502(ra) # 5c14 <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    31fa:	85a6                	mv	a1,s1
    31fc:	00004517          	auipc	a0,0x4
    3200:	14c50513          	add	a0,a0,332 # 7348 <malloc+0x12f4>
    3204:	00003097          	auipc	ra,0x3
    3208:	d98080e7          	jalr	-616(ra) # 5f9c <printf>
    exit(1);
    320c:	4505                	li	a0,1
    320e:	00003097          	auipc	ra,0x3
    3212:	a06080e7          	jalr	-1530(ra) # 5c14 <exit>

0000000000003216 <diskfull>:
{
    3216:	b9010113          	add	sp,sp,-1136
    321a:	46113423          	sd	ra,1128(sp)
    321e:	46813023          	sd	s0,1120(sp)
    3222:	44913c23          	sd	s1,1112(sp)
    3226:	45213823          	sd	s2,1104(sp)
    322a:	45313423          	sd	s3,1096(sp)
    322e:	45413023          	sd	s4,1088(sp)
    3232:	43513c23          	sd	s5,1080(sp)
    3236:	43613823          	sd	s6,1072(sp)
    323a:	43713423          	sd	s7,1064(sp)
    323e:	43813023          	sd	s8,1056(sp)
    3242:	47010413          	add	s0,sp,1136
    3246:	8c2a                	mv	s8,a0
  unlink("diskfulldir");
    3248:	00004517          	auipc	a0,0x4
    324c:	13850513          	add	a0,a0,312 # 7380 <malloc+0x132c>
    3250:	00003097          	auipc	ra,0x3
    3254:	a14080e7          	jalr	-1516(ra) # 5c64 <unlink>
  for(fi = 0; done == 0; fi++){
    3258:	4a01                	li	s4,0
    name[0] = 'b';
    325a:	06200b13          	li	s6,98
    name[1] = 'i';
    325e:	06900a93          	li	s5,105
    name[2] = 'g';
    3262:	06700993          	li	s3,103
    3266:	10c00b93          	li	s7,268
    326a:	aabd                	j	33e8 <diskfull+0x1d2>
      printf("%s: could not create file %s\n", s, name);
    326c:	b9040613          	add	a2,s0,-1136
    3270:	85e2                	mv	a1,s8
    3272:	00004517          	auipc	a0,0x4
    3276:	11e50513          	add	a0,a0,286 # 7390 <malloc+0x133c>
    327a:	00003097          	auipc	ra,0x3
    327e:	d22080e7          	jalr	-734(ra) # 5f9c <printf>
      break;
    3282:	a821                	j	329a <diskfull+0x84>
        close(fd);
    3284:	854a                	mv	a0,s2
    3286:	00003097          	auipc	ra,0x3
    328a:	9b6080e7          	jalr	-1610(ra) # 5c3c <close>
    close(fd);
    328e:	854a                	mv	a0,s2
    3290:	00003097          	auipc	ra,0x3
    3294:	9ac080e7          	jalr	-1620(ra) # 5c3c <close>
  for(fi = 0; done == 0; fi++){
    3298:	2a05                	addw	s4,s4,1
  for(int i = 0; i < nzz; i++){
    329a:	4481                	li	s1,0
    name[0] = 'z';
    329c:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    32a0:	08000993          	li	s3,128
    name[0] = 'z';
    32a4:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    32a8:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    32ac:	41f4d71b          	sraw	a4,s1,0x1f
    32b0:	01b7571b          	srlw	a4,a4,0x1b
    32b4:	009707bb          	addw	a5,a4,s1
    32b8:	4057d69b          	sraw	a3,a5,0x5
    32bc:	0306869b          	addw	a3,a3,48
    32c0:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    32c4:	8bfd                	and	a5,a5,31
    32c6:	9f99                	subw	a5,a5,a4
    32c8:	0307879b          	addw	a5,a5,48
    32cc:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    32d0:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    32d4:	bb040513          	add	a0,s0,-1104
    32d8:	00003097          	auipc	ra,0x3
    32dc:	98c080e7          	jalr	-1652(ra) # 5c64 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    32e0:	60200593          	li	a1,1538
    32e4:	bb040513          	add	a0,s0,-1104
    32e8:	00003097          	auipc	ra,0x3
    32ec:	96c080e7          	jalr	-1684(ra) # 5c54 <open>
    if(fd < 0)
    32f0:	00054963          	bltz	a0,3302 <diskfull+0xec>
    close(fd);
    32f4:	00003097          	auipc	ra,0x3
    32f8:	948080e7          	jalr	-1720(ra) # 5c3c <close>
  for(int i = 0; i < nzz; i++){
    32fc:	2485                	addw	s1,s1,1
    32fe:	fb3493e3          	bne	s1,s3,32a4 <diskfull+0x8e>
  if(mkdir("diskfulldir") == 0)
    3302:	00004517          	auipc	a0,0x4
    3306:	07e50513          	add	a0,a0,126 # 7380 <malloc+0x132c>
    330a:	00003097          	auipc	ra,0x3
    330e:	972080e7          	jalr	-1678(ra) # 5c7c <mkdir>
    3312:	12050963          	beqz	a0,3444 <diskfull+0x22e>
  unlink("diskfulldir");
    3316:	00004517          	auipc	a0,0x4
    331a:	06a50513          	add	a0,a0,106 # 7380 <malloc+0x132c>
    331e:	00003097          	auipc	ra,0x3
    3322:	946080e7          	jalr	-1722(ra) # 5c64 <unlink>
  for(int i = 0; i < nzz; i++){
    3326:	4481                	li	s1,0
    name[0] = 'z';
    3328:	07a00913          	li	s2,122
  for(int i = 0; i < nzz; i++){
    332c:	08000993          	li	s3,128
    name[0] = 'z';
    3330:	bb240823          	sb	s2,-1104(s0)
    name[1] = 'z';
    3334:	bb2408a3          	sb	s2,-1103(s0)
    name[2] = '0' + (i / 32);
    3338:	41f4d71b          	sraw	a4,s1,0x1f
    333c:	01b7571b          	srlw	a4,a4,0x1b
    3340:	009707bb          	addw	a5,a4,s1
    3344:	4057d69b          	sraw	a3,a5,0x5
    3348:	0306869b          	addw	a3,a3,48
    334c:	bad40923          	sb	a3,-1102(s0)
    name[3] = '0' + (i % 32);
    3350:	8bfd                	and	a5,a5,31
    3352:	9f99                	subw	a5,a5,a4
    3354:	0307879b          	addw	a5,a5,48
    3358:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    335c:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    3360:	bb040513          	add	a0,s0,-1104
    3364:	00003097          	auipc	ra,0x3
    3368:	900080e7          	jalr	-1792(ra) # 5c64 <unlink>
  for(int i = 0; i < nzz; i++){
    336c:	2485                	addw	s1,s1,1
    336e:	fd3491e3          	bne	s1,s3,3330 <diskfull+0x11a>
  for(int i = 0; i < fi; i++){
    3372:	03405e63          	blez	s4,33ae <diskfull+0x198>
    3376:	4481                	li	s1,0
    name[0] = 'b';
    3378:	06200a93          	li	s5,98
    name[1] = 'i';
    337c:	06900993          	li	s3,105
    name[2] = 'g';
    3380:	06700913          	li	s2,103
    name[0] = 'b';
    3384:	bb540823          	sb	s5,-1104(s0)
    name[1] = 'i';
    3388:	bb3408a3          	sb	s3,-1103(s0)
    name[2] = 'g';
    338c:	bb240923          	sb	s2,-1102(s0)
    name[3] = '0' + i;
    3390:	0304879b          	addw	a5,s1,48
    3394:	baf409a3          	sb	a5,-1101(s0)
    name[4] = '\0';
    3398:	ba040a23          	sb	zero,-1100(s0)
    unlink(name);
    339c:	bb040513          	add	a0,s0,-1104
    33a0:	00003097          	auipc	ra,0x3
    33a4:	8c4080e7          	jalr	-1852(ra) # 5c64 <unlink>
  for(int i = 0; i < fi; i++){
    33a8:	2485                	addw	s1,s1,1
    33aa:	fd449de3          	bne	s1,s4,3384 <diskfull+0x16e>
}
    33ae:	46813083          	ld	ra,1128(sp)
    33b2:	46013403          	ld	s0,1120(sp)
    33b6:	45813483          	ld	s1,1112(sp)
    33ba:	45013903          	ld	s2,1104(sp)
    33be:	44813983          	ld	s3,1096(sp)
    33c2:	44013a03          	ld	s4,1088(sp)
    33c6:	43813a83          	ld	s5,1080(sp)
    33ca:	43013b03          	ld	s6,1072(sp)
    33ce:	42813b83          	ld	s7,1064(sp)
    33d2:	42013c03          	ld	s8,1056(sp)
    33d6:	47010113          	add	sp,sp,1136
    33da:	8082                	ret
    close(fd);
    33dc:	854a                	mv	a0,s2
    33de:	00003097          	auipc	ra,0x3
    33e2:	85e080e7          	jalr	-1954(ra) # 5c3c <close>
  for(fi = 0; done == 0; fi++){
    33e6:	2a05                	addw	s4,s4,1
    name[0] = 'b';
    33e8:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    33ec:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    33f0:	b9340923          	sb	s3,-1134(s0)
    name[3] = '0' + fi;
    33f4:	030a079b          	addw	a5,s4,48
    33f8:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    33fc:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    3400:	b9040513          	add	a0,s0,-1136
    3404:	00003097          	auipc	ra,0x3
    3408:	860080e7          	jalr	-1952(ra) # 5c64 <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    340c:	60200593          	li	a1,1538
    3410:	b9040513          	add	a0,s0,-1136
    3414:	00003097          	auipc	ra,0x3
    3418:	840080e7          	jalr	-1984(ra) # 5c54 <open>
    341c:	892a                	mv	s2,a0
    if(fd < 0){
    341e:	e40547e3          	bltz	a0,326c <diskfull+0x56>
    3422:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    3424:	40000613          	li	a2,1024
    3428:	bb040593          	add	a1,s0,-1104
    342c:	854a                	mv	a0,s2
    342e:	00003097          	auipc	ra,0x3
    3432:	806080e7          	jalr	-2042(ra) # 5c34 <write>
    3436:	40000793          	li	a5,1024
    343a:	e4f515e3          	bne	a0,a5,3284 <diskfull+0x6e>
    for(int i = 0; i < MAXFILE; i++){
    343e:	34fd                	addw	s1,s1,-1
    3440:	f0f5                	bnez	s1,3424 <diskfull+0x20e>
    3442:	bf69                	j	33dc <diskfull+0x1c6>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n");
    3444:	00004517          	auipc	a0,0x4
    3448:	f6c50513          	add	a0,a0,-148 # 73b0 <malloc+0x135c>
    344c:	00003097          	auipc	ra,0x3
    3450:	b50080e7          	jalr	-1200(ra) # 5f9c <printf>
    3454:	b5c9                	j	3316 <diskfull+0x100>

0000000000003456 <iputtest>:
{
    3456:	1101                	add	sp,sp,-32
    3458:	ec06                	sd	ra,24(sp)
    345a:	e822                	sd	s0,16(sp)
    345c:	e426                	sd	s1,8(sp)
    345e:	1000                	add	s0,sp,32
    3460:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    3462:	00004517          	auipc	a0,0x4
    3466:	f7e50513          	add	a0,a0,-130 # 73e0 <malloc+0x138c>
    346a:	00003097          	auipc	ra,0x3
    346e:	812080e7          	jalr	-2030(ra) # 5c7c <mkdir>
    3472:	04054563          	bltz	a0,34bc <iputtest+0x66>
  if(chdir("iputdir") < 0){
    3476:	00004517          	auipc	a0,0x4
    347a:	f6a50513          	add	a0,a0,-150 # 73e0 <malloc+0x138c>
    347e:	00003097          	auipc	ra,0x3
    3482:	806080e7          	jalr	-2042(ra) # 5c84 <chdir>
    3486:	04054963          	bltz	a0,34d8 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
    348a:	00004517          	auipc	a0,0x4
    348e:	f9650513          	add	a0,a0,-106 # 7420 <malloc+0x13cc>
    3492:	00002097          	auipc	ra,0x2
    3496:	7d2080e7          	jalr	2002(ra) # 5c64 <unlink>
    349a:	04054d63          	bltz	a0,34f4 <iputtest+0x9e>
  if(chdir("/") < 0){
    349e:	00004517          	auipc	a0,0x4
    34a2:	fb250513          	add	a0,a0,-78 # 7450 <malloc+0x13fc>
    34a6:	00002097          	auipc	ra,0x2
    34aa:	7de080e7          	jalr	2014(ra) # 5c84 <chdir>
    34ae:	06054163          	bltz	a0,3510 <iputtest+0xba>
}
    34b2:	60e2                	ld	ra,24(sp)
    34b4:	6442                	ld	s0,16(sp)
    34b6:	64a2                	ld	s1,8(sp)
    34b8:	6105                	add	sp,sp,32
    34ba:	8082                	ret
    printf("%s: mkdir failed\n", s);
    34bc:	85a6                	mv	a1,s1
    34be:	00004517          	auipc	a0,0x4
    34c2:	f2a50513          	add	a0,a0,-214 # 73e8 <malloc+0x1394>
    34c6:	00003097          	auipc	ra,0x3
    34ca:	ad6080e7          	jalr	-1322(ra) # 5f9c <printf>
    exit(1);
    34ce:	4505                	li	a0,1
    34d0:	00002097          	auipc	ra,0x2
    34d4:	744080e7          	jalr	1860(ra) # 5c14 <exit>
    printf("%s: chdir iputdir failed\n", s);
    34d8:	85a6                	mv	a1,s1
    34da:	00004517          	auipc	a0,0x4
    34de:	f2650513          	add	a0,a0,-218 # 7400 <malloc+0x13ac>
    34e2:	00003097          	auipc	ra,0x3
    34e6:	aba080e7          	jalr	-1350(ra) # 5f9c <printf>
    exit(1);
    34ea:	4505                	li	a0,1
    34ec:	00002097          	auipc	ra,0x2
    34f0:	728080e7          	jalr	1832(ra) # 5c14 <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    34f4:	85a6                	mv	a1,s1
    34f6:	00004517          	auipc	a0,0x4
    34fa:	f3a50513          	add	a0,a0,-198 # 7430 <malloc+0x13dc>
    34fe:	00003097          	auipc	ra,0x3
    3502:	a9e080e7          	jalr	-1378(ra) # 5f9c <printf>
    exit(1);
    3506:	4505                	li	a0,1
    3508:	00002097          	auipc	ra,0x2
    350c:	70c080e7          	jalr	1804(ra) # 5c14 <exit>
    printf("%s: chdir / failed\n", s);
    3510:	85a6                	mv	a1,s1
    3512:	00004517          	auipc	a0,0x4
    3516:	f4650513          	add	a0,a0,-186 # 7458 <malloc+0x1404>
    351a:	00003097          	auipc	ra,0x3
    351e:	a82080e7          	jalr	-1406(ra) # 5f9c <printf>
    exit(1);
    3522:	4505                	li	a0,1
    3524:	00002097          	auipc	ra,0x2
    3528:	6f0080e7          	jalr	1776(ra) # 5c14 <exit>

000000000000352c <exitiputtest>:
{
    352c:	7179                	add	sp,sp,-48
    352e:	f406                	sd	ra,40(sp)
    3530:	f022                	sd	s0,32(sp)
    3532:	ec26                	sd	s1,24(sp)
    3534:	1800                	add	s0,sp,48
    3536:	84aa                	mv	s1,a0
  pid = fork();
    3538:	00002097          	auipc	ra,0x2
    353c:	6d4080e7          	jalr	1748(ra) # 5c0c <fork>
  if(pid < 0){
    3540:	04054663          	bltz	a0,358c <exitiputtest+0x60>
  if(pid == 0){
    3544:	ed45                	bnez	a0,35fc <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
    3546:	00004517          	auipc	a0,0x4
    354a:	e9a50513          	add	a0,a0,-358 # 73e0 <malloc+0x138c>
    354e:	00002097          	auipc	ra,0x2
    3552:	72e080e7          	jalr	1838(ra) # 5c7c <mkdir>
    3556:	04054963          	bltz	a0,35a8 <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
    355a:	00004517          	auipc	a0,0x4
    355e:	e8650513          	add	a0,a0,-378 # 73e0 <malloc+0x138c>
    3562:	00002097          	auipc	ra,0x2
    3566:	722080e7          	jalr	1826(ra) # 5c84 <chdir>
    356a:	04054d63          	bltz	a0,35c4 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
    356e:	00004517          	auipc	a0,0x4
    3572:	eb250513          	add	a0,a0,-334 # 7420 <malloc+0x13cc>
    3576:	00002097          	auipc	ra,0x2
    357a:	6ee080e7          	jalr	1774(ra) # 5c64 <unlink>
    357e:	06054163          	bltz	a0,35e0 <exitiputtest+0xb4>
    exit(0);
    3582:	4501                	li	a0,0
    3584:	00002097          	auipc	ra,0x2
    3588:	690080e7          	jalr	1680(ra) # 5c14 <exit>
    printf("%s: fork failed\n", s);
    358c:	85a6                	mv	a1,s1
    358e:	00003517          	auipc	a0,0x3
    3592:	49250513          	add	a0,a0,1170 # 6a20 <malloc+0x9cc>
    3596:	00003097          	auipc	ra,0x3
    359a:	a06080e7          	jalr	-1530(ra) # 5f9c <printf>
    exit(1);
    359e:	4505                	li	a0,1
    35a0:	00002097          	auipc	ra,0x2
    35a4:	674080e7          	jalr	1652(ra) # 5c14 <exit>
      printf("%s: mkdir failed\n", s);
    35a8:	85a6                	mv	a1,s1
    35aa:	00004517          	auipc	a0,0x4
    35ae:	e3e50513          	add	a0,a0,-450 # 73e8 <malloc+0x1394>
    35b2:	00003097          	auipc	ra,0x3
    35b6:	9ea080e7          	jalr	-1558(ra) # 5f9c <printf>
      exit(1);
    35ba:	4505                	li	a0,1
    35bc:	00002097          	auipc	ra,0x2
    35c0:	658080e7          	jalr	1624(ra) # 5c14 <exit>
      printf("%s: child chdir failed\n", s);
    35c4:	85a6                	mv	a1,s1
    35c6:	00004517          	auipc	a0,0x4
    35ca:	eaa50513          	add	a0,a0,-342 # 7470 <malloc+0x141c>
    35ce:	00003097          	auipc	ra,0x3
    35d2:	9ce080e7          	jalr	-1586(ra) # 5f9c <printf>
      exit(1);
    35d6:	4505                	li	a0,1
    35d8:	00002097          	auipc	ra,0x2
    35dc:	63c080e7          	jalr	1596(ra) # 5c14 <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    35e0:	85a6                	mv	a1,s1
    35e2:	00004517          	auipc	a0,0x4
    35e6:	e4e50513          	add	a0,a0,-434 # 7430 <malloc+0x13dc>
    35ea:	00003097          	auipc	ra,0x3
    35ee:	9b2080e7          	jalr	-1614(ra) # 5f9c <printf>
      exit(1);
    35f2:	4505                	li	a0,1
    35f4:	00002097          	auipc	ra,0x2
    35f8:	620080e7          	jalr	1568(ra) # 5c14 <exit>
  wait(&xstatus);
    35fc:	fdc40513          	add	a0,s0,-36
    3600:	00002097          	auipc	ra,0x2
    3604:	61c080e7          	jalr	1564(ra) # 5c1c <wait>
  exit(xstatus);
    3608:	fdc42503          	lw	a0,-36(s0)
    360c:	00002097          	auipc	ra,0x2
    3610:	608080e7          	jalr	1544(ra) # 5c14 <exit>

0000000000003614 <dirtest>:
{
    3614:	1101                	add	sp,sp,-32
    3616:	ec06                	sd	ra,24(sp)
    3618:	e822                	sd	s0,16(sp)
    361a:	e426                	sd	s1,8(sp)
    361c:	1000                	add	s0,sp,32
    361e:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    3620:	00004517          	auipc	a0,0x4
    3624:	e6850513          	add	a0,a0,-408 # 7488 <malloc+0x1434>
    3628:	00002097          	auipc	ra,0x2
    362c:	654080e7          	jalr	1620(ra) # 5c7c <mkdir>
    3630:	04054563          	bltz	a0,367a <dirtest+0x66>
  if(chdir("dir0") < 0){
    3634:	00004517          	auipc	a0,0x4
    3638:	e5450513          	add	a0,a0,-428 # 7488 <malloc+0x1434>
    363c:	00002097          	auipc	ra,0x2
    3640:	648080e7          	jalr	1608(ra) # 5c84 <chdir>
    3644:	04054963          	bltz	a0,3696 <dirtest+0x82>
  if(chdir("..") < 0){
    3648:	00004517          	auipc	a0,0x4
    364c:	e6050513          	add	a0,a0,-416 # 74a8 <malloc+0x1454>
    3650:	00002097          	auipc	ra,0x2
    3654:	634080e7          	jalr	1588(ra) # 5c84 <chdir>
    3658:	04054d63          	bltz	a0,36b2 <dirtest+0x9e>
  if(unlink("dir0") < 0){
    365c:	00004517          	auipc	a0,0x4
    3660:	e2c50513          	add	a0,a0,-468 # 7488 <malloc+0x1434>
    3664:	00002097          	auipc	ra,0x2
    3668:	600080e7          	jalr	1536(ra) # 5c64 <unlink>
    366c:	06054163          	bltz	a0,36ce <dirtest+0xba>
}
    3670:	60e2                	ld	ra,24(sp)
    3672:	6442                	ld	s0,16(sp)
    3674:	64a2                	ld	s1,8(sp)
    3676:	6105                	add	sp,sp,32
    3678:	8082                	ret
    printf("%s: mkdir failed\n", s);
    367a:	85a6                	mv	a1,s1
    367c:	00004517          	auipc	a0,0x4
    3680:	d6c50513          	add	a0,a0,-660 # 73e8 <malloc+0x1394>
    3684:	00003097          	auipc	ra,0x3
    3688:	918080e7          	jalr	-1768(ra) # 5f9c <printf>
    exit(1);
    368c:	4505                	li	a0,1
    368e:	00002097          	auipc	ra,0x2
    3692:	586080e7          	jalr	1414(ra) # 5c14 <exit>
    printf("%s: chdir dir0 failed\n", s);
    3696:	85a6                	mv	a1,s1
    3698:	00004517          	auipc	a0,0x4
    369c:	df850513          	add	a0,a0,-520 # 7490 <malloc+0x143c>
    36a0:	00003097          	auipc	ra,0x3
    36a4:	8fc080e7          	jalr	-1796(ra) # 5f9c <printf>
    exit(1);
    36a8:	4505                	li	a0,1
    36aa:	00002097          	auipc	ra,0x2
    36ae:	56a080e7          	jalr	1386(ra) # 5c14 <exit>
    printf("%s: chdir .. failed\n", s);
    36b2:	85a6                	mv	a1,s1
    36b4:	00004517          	auipc	a0,0x4
    36b8:	dfc50513          	add	a0,a0,-516 # 74b0 <malloc+0x145c>
    36bc:	00003097          	auipc	ra,0x3
    36c0:	8e0080e7          	jalr	-1824(ra) # 5f9c <printf>
    exit(1);
    36c4:	4505                	li	a0,1
    36c6:	00002097          	auipc	ra,0x2
    36ca:	54e080e7          	jalr	1358(ra) # 5c14 <exit>
    printf("%s: unlink dir0 failed\n", s);
    36ce:	85a6                	mv	a1,s1
    36d0:	00004517          	auipc	a0,0x4
    36d4:	df850513          	add	a0,a0,-520 # 74c8 <malloc+0x1474>
    36d8:	00003097          	auipc	ra,0x3
    36dc:	8c4080e7          	jalr	-1852(ra) # 5f9c <printf>
    exit(1);
    36e0:	4505                	li	a0,1
    36e2:	00002097          	auipc	ra,0x2
    36e6:	532080e7          	jalr	1330(ra) # 5c14 <exit>

00000000000036ea <subdir>:
{
    36ea:	1101                	add	sp,sp,-32
    36ec:	ec06                	sd	ra,24(sp)
    36ee:	e822                	sd	s0,16(sp)
    36f0:	e426                	sd	s1,8(sp)
    36f2:	e04a                	sd	s2,0(sp)
    36f4:	1000                	add	s0,sp,32
    36f6:	892a                	mv	s2,a0
  unlink("ff");
    36f8:	00004517          	auipc	a0,0x4
    36fc:	f1850513          	add	a0,a0,-232 # 7610 <malloc+0x15bc>
    3700:	00002097          	auipc	ra,0x2
    3704:	564080e7          	jalr	1380(ra) # 5c64 <unlink>
  if(mkdir("dd") != 0){
    3708:	00004517          	auipc	a0,0x4
    370c:	dd850513          	add	a0,a0,-552 # 74e0 <malloc+0x148c>
    3710:	00002097          	auipc	ra,0x2
    3714:	56c080e7          	jalr	1388(ra) # 5c7c <mkdir>
    3718:	38051663          	bnez	a0,3aa4 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    371c:	20200593          	li	a1,514
    3720:	00004517          	auipc	a0,0x4
    3724:	de050513          	add	a0,a0,-544 # 7500 <malloc+0x14ac>
    3728:	00002097          	auipc	ra,0x2
    372c:	52c080e7          	jalr	1324(ra) # 5c54 <open>
    3730:	84aa                	mv	s1,a0
  if(fd < 0){
    3732:	38054763          	bltz	a0,3ac0 <subdir+0x3d6>
  write(fd, "ff", 2);
    3736:	4609                	li	a2,2
    3738:	00004597          	auipc	a1,0x4
    373c:	ed858593          	add	a1,a1,-296 # 7610 <malloc+0x15bc>
    3740:	00002097          	auipc	ra,0x2
    3744:	4f4080e7          	jalr	1268(ra) # 5c34 <write>
  close(fd);
    3748:	8526                	mv	a0,s1
    374a:	00002097          	auipc	ra,0x2
    374e:	4f2080e7          	jalr	1266(ra) # 5c3c <close>
  if(unlink("dd") >= 0){
    3752:	00004517          	auipc	a0,0x4
    3756:	d8e50513          	add	a0,a0,-626 # 74e0 <malloc+0x148c>
    375a:	00002097          	auipc	ra,0x2
    375e:	50a080e7          	jalr	1290(ra) # 5c64 <unlink>
    3762:	36055d63          	bgez	a0,3adc <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    3766:	00004517          	auipc	a0,0x4
    376a:	df250513          	add	a0,a0,-526 # 7558 <malloc+0x1504>
    376e:	00002097          	auipc	ra,0x2
    3772:	50e080e7          	jalr	1294(ra) # 5c7c <mkdir>
    3776:	38051163          	bnez	a0,3af8 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    377a:	20200593          	li	a1,514
    377e:	00004517          	auipc	a0,0x4
    3782:	e0250513          	add	a0,a0,-510 # 7580 <malloc+0x152c>
    3786:	00002097          	auipc	ra,0x2
    378a:	4ce080e7          	jalr	1230(ra) # 5c54 <open>
    378e:	84aa                	mv	s1,a0
  if(fd < 0){
    3790:	38054263          	bltz	a0,3b14 <subdir+0x42a>
  write(fd, "FF", 2);
    3794:	4609                	li	a2,2
    3796:	00004597          	auipc	a1,0x4
    379a:	e1a58593          	add	a1,a1,-486 # 75b0 <malloc+0x155c>
    379e:	00002097          	auipc	ra,0x2
    37a2:	496080e7          	jalr	1174(ra) # 5c34 <write>
  close(fd);
    37a6:	8526                	mv	a0,s1
    37a8:	00002097          	auipc	ra,0x2
    37ac:	494080e7          	jalr	1172(ra) # 5c3c <close>
  fd = open("dd/dd/../ff", 0);
    37b0:	4581                	li	a1,0
    37b2:	00004517          	auipc	a0,0x4
    37b6:	e0650513          	add	a0,a0,-506 # 75b8 <malloc+0x1564>
    37ba:	00002097          	auipc	ra,0x2
    37be:	49a080e7          	jalr	1178(ra) # 5c54 <open>
    37c2:	84aa                	mv	s1,a0
  if(fd < 0){
    37c4:	36054663          	bltz	a0,3b30 <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    37c8:	660d                	lui	a2,0x3
    37ca:	00009597          	auipc	a1,0x9
    37ce:	4ae58593          	add	a1,a1,1198 # cc78 <buf>
    37d2:	00002097          	auipc	ra,0x2
    37d6:	45a080e7          	jalr	1114(ra) # 5c2c <read>
  if(cc != 2 || buf[0] != 'f'){
    37da:	4789                	li	a5,2
    37dc:	36f51863          	bne	a0,a5,3b4c <subdir+0x462>
    37e0:	00009717          	auipc	a4,0x9
    37e4:	49874703          	lbu	a4,1176(a4) # cc78 <buf>
    37e8:	06600793          	li	a5,102
    37ec:	36f71063          	bne	a4,a5,3b4c <subdir+0x462>
  close(fd);
    37f0:	8526                	mv	a0,s1
    37f2:	00002097          	auipc	ra,0x2
    37f6:	44a080e7          	jalr	1098(ra) # 5c3c <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    37fa:	00004597          	auipc	a1,0x4
    37fe:	e0e58593          	add	a1,a1,-498 # 7608 <malloc+0x15b4>
    3802:	00004517          	auipc	a0,0x4
    3806:	d7e50513          	add	a0,a0,-642 # 7580 <malloc+0x152c>
    380a:	00002097          	auipc	ra,0x2
    380e:	46a080e7          	jalr	1130(ra) # 5c74 <link>
    3812:	34051b63          	bnez	a0,3b68 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    3816:	00004517          	auipc	a0,0x4
    381a:	d6a50513          	add	a0,a0,-662 # 7580 <malloc+0x152c>
    381e:	00002097          	auipc	ra,0x2
    3822:	446080e7          	jalr	1094(ra) # 5c64 <unlink>
    3826:	34051f63          	bnez	a0,3b84 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    382a:	4581                	li	a1,0
    382c:	00004517          	auipc	a0,0x4
    3830:	d5450513          	add	a0,a0,-684 # 7580 <malloc+0x152c>
    3834:	00002097          	auipc	ra,0x2
    3838:	420080e7          	jalr	1056(ra) # 5c54 <open>
    383c:	36055263          	bgez	a0,3ba0 <subdir+0x4b6>
  if(chdir("dd") != 0){
    3840:	00004517          	auipc	a0,0x4
    3844:	ca050513          	add	a0,a0,-864 # 74e0 <malloc+0x148c>
    3848:	00002097          	auipc	ra,0x2
    384c:	43c080e7          	jalr	1084(ra) # 5c84 <chdir>
    3850:	36051663          	bnez	a0,3bbc <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    3854:	00004517          	auipc	a0,0x4
    3858:	e4c50513          	add	a0,a0,-436 # 76a0 <malloc+0x164c>
    385c:	00002097          	auipc	ra,0x2
    3860:	428080e7          	jalr	1064(ra) # 5c84 <chdir>
    3864:	36051a63          	bnez	a0,3bd8 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    3868:	00004517          	auipc	a0,0x4
    386c:	e6850513          	add	a0,a0,-408 # 76d0 <malloc+0x167c>
    3870:	00002097          	auipc	ra,0x2
    3874:	414080e7          	jalr	1044(ra) # 5c84 <chdir>
    3878:	36051e63          	bnez	a0,3bf4 <subdir+0x50a>
  if(chdir("./..") != 0){
    387c:	00004517          	auipc	a0,0x4
    3880:	e8450513          	add	a0,a0,-380 # 7700 <malloc+0x16ac>
    3884:	00002097          	auipc	ra,0x2
    3888:	400080e7          	jalr	1024(ra) # 5c84 <chdir>
    388c:	38051263          	bnez	a0,3c10 <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    3890:	4581                	li	a1,0
    3892:	00004517          	auipc	a0,0x4
    3896:	d7650513          	add	a0,a0,-650 # 7608 <malloc+0x15b4>
    389a:	00002097          	auipc	ra,0x2
    389e:	3ba080e7          	jalr	954(ra) # 5c54 <open>
    38a2:	84aa                	mv	s1,a0
  if(fd < 0){
    38a4:	38054463          	bltz	a0,3c2c <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    38a8:	660d                	lui	a2,0x3
    38aa:	00009597          	auipc	a1,0x9
    38ae:	3ce58593          	add	a1,a1,974 # cc78 <buf>
    38b2:	00002097          	auipc	ra,0x2
    38b6:	37a080e7          	jalr	890(ra) # 5c2c <read>
    38ba:	4789                	li	a5,2
    38bc:	38f51663          	bne	a0,a5,3c48 <subdir+0x55e>
  close(fd);
    38c0:	8526                	mv	a0,s1
    38c2:	00002097          	auipc	ra,0x2
    38c6:	37a080e7          	jalr	890(ra) # 5c3c <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    38ca:	4581                	li	a1,0
    38cc:	00004517          	auipc	a0,0x4
    38d0:	cb450513          	add	a0,a0,-844 # 7580 <malloc+0x152c>
    38d4:	00002097          	auipc	ra,0x2
    38d8:	380080e7          	jalr	896(ra) # 5c54 <open>
    38dc:	38055463          	bgez	a0,3c64 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    38e0:	20200593          	li	a1,514
    38e4:	00004517          	auipc	a0,0x4
    38e8:	eac50513          	add	a0,a0,-340 # 7790 <malloc+0x173c>
    38ec:	00002097          	auipc	ra,0x2
    38f0:	368080e7          	jalr	872(ra) # 5c54 <open>
    38f4:	38055663          	bgez	a0,3c80 <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    38f8:	20200593          	li	a1,514
    38fc:	00004517          	auipc	a0,0x4
    3900:	ec450513          	add	a0,a0,-316 # 77c0 <malloc+0x176c>
    3904:	00002097          	auipc	ra,0x2
    3908:	350080e7          	jalr	848(ra) # 5c54 <open>
    390c:	38055863          	bgez	a0,3c9c <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    3910:	20000593          	li	a1,512
    3914:	00004517          	auipc	a0,0x4
    3918:	bcc50513          	add	a0,a0,-1076 # 74e0 <malloc+0x148c>
    391c:	00002097          	auipc	ra,0x2
    3920:	338080e7          	jalr	824(ra) # 5c54 <open>
    3924:	38055a63          	bgez	a0,3cb8 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    3928:	4589                	li	a1,2
    392a:	00004517          	auipc	a0,0x4
    392e:	bb650513          	add	a0,a0,-1098 # 74e0 <malloc+0x148c>
    3932:	00002097          	auipc	ra,0x2
    3936:	322080e7          	jalr	802(ra) # 5c54 <open>
    393a:	38055d63          	bgez	a0,3cd4 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    393e:	4585                	li	a1,1
    3940:	00004517          	auipc	a0,0x4
    3944:	ba050513          	add	a0,a0,-1120 # 74e0 <malloc+0x148c>
    3948:	00002097          	auipc	ra,0x2
    394c:	30c080e7          	jalr	780(ra) # 5c54 <open>
    3950:	3a055063          	bgez	a0,3cf0 <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    3954:	00004597          	auipc	a1,0x4
    3958:	efc58593          	add	a1,a1,-260 # 7850 <malloc+0x17fc>
    395c:	00004517          	auipc	a0,0x4
    3960:	e3450513          	add	a0,a0,-460 # 7790 <malloc+0x173c>
    3964:	00002097          	auipc	ra,0x2
    3968:	310080e7          	jalr	784(ra) # 5c74 <link>
    396c:	3a050063          	beqz	a0,3d0c <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    3970:	00004597          	auipc	a1,0x4
    3974:	ee058593          	add	a1,a1,-288 # 7850 <malloc+0x17fc>
    3978:	00004517          	auipc	a0,0x4
    397c:	e4850513          	add	a0,a0,-440 # 77c0 <malloc+0x176c>
    3980:	00002097          	auipc	ra,0x2
    3984:	2f4080e7          	jalr	756(ra) # 5c74 <link>
    3988:	3a050063          	beqz	a0,3d28 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    398c:	00004597          	auipc	a1,0x4
    3990:	c7c58593          	add	a1,a1,-900 # 7608 <malloc+0x15b4>
    3994:	00004517          	auipc	a0,0x4
    3998:	b6c50513          	add	a0,a0,-1172 # 7500 <malloc+0x14ac>
    399c:	00002097          	auipc	ra,0x2
    39a0:	2d8080e7          	jalr	728(ra) # 5c74 <link>
    39a4:	3a050063          	beqz	a0,3d44 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    39a8:	00004517          	auipc	a0,0x4
    39ac:	de850513          	add	a0,a0,-536 # 7790 <malloc+0x173c>
    39b0:	00002097          	auipc	ra,0x2
    39b4:	2cc080e7          	jalr	716(ra) # 5c7c <mkdir>
    39b8:	3a050463          	beqz	a0,3d60 <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    39bc:	00004517          	auipc	a0,0x4
    39c0:	e0450513          	add	a0,a0,-508 # 77c0 <malloc+0x176c>
    39c4:	00002097          	auipc	ra,0x2
    39c8:	2b8080e7          	jalr	696(ra) # 5c7c <mkdir>
    39cc:	3a050863          	beqz	a0,3d7c <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    39d0:	00004517          	auipc	a0,0x4
    39d4:	c3850513          	add	a0,a0,-968 # 7608 <malloc+0x15b4>
    39d8:	00002097          	auipc	ra,0x2
    39dc:	2a4080e7          	jalr	676(ra) # 5c7c <mkdir>
    39e0:	3a050c63          	beqz	a0,3d98 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    39e4:	00004517          	auipc	a0,0x4
    39e8:	ddc50513          	add	a0,a0,-548 # 77c0 <malloc+0x176c>
    39ec:	00002097          	auipc	ra,0x2
    39f0:	278080e7          	jalr	632(ra) # 5c64 <unlink>
    39f4:	3c050063          	beqz	a0,3db4 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    39f8:	00004517          	auipc	a0,0x4
    39fc:	d9850513          	add	a0,a0,-616 # 7790 <malloc+0x173c>
    3a00:	00002097          	auipc	ra,0x2
    3a04:	264080e7          	jalr	612(ra) # 5c64 <unlink>
    3a08:	3c050463          	beqz	a0,3dd0 <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    3a0c:	00004517          	auipc	a0,0x4
    3a10:	af450513          	add	a0,a0,-1292 # 7500 <malloc+0x14ac>
    3a14:	00002097          	auipc	ra,0x2
    3a18:	270080e7          	jalr	624(ra) # 5c84 <chdir>
    3a1c:	3c050863          	beqz	a0,3dec <subdir+0x702>
  if(chdir("dd/xx") == 0){
    3a20:	00004517          	auipc	a0,0x4
    3a24:	f8050513          	add	a0,a0,-128 # 79a0 <malloc+0x194c>
    3a28:	00002097          	auipc	ra,0x2
    3a2c:	25c080e7          	jalr	604(ra) # 5c84 <chdir>
    3a30:	3c050c63          	beqz	a0,3e08 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    3a34:	00004517          	auipc	a0,0x4
    3a38:	bd450513          	add	a0,a0,-1068 # 7608 <malloc+0x15b4>
    3a3c:	00002097          	auipc	ra,0x2
    3a40:	228080e7          	jalr	552(ra) # 5c64 <unlink>
    3a44:	3e051063          	bnez	a0,3e24 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    3a48:	00004517          	auipc	a0,0x4
    3a4c:	ab850513          	add	a0,a0,-1352 # 7500 <malloc+0x14ac>
    3a50:	00002097          	auipc	ra,0x2
    3a54:	214080e7          	jalr	532(ra) # 5c64 <unlink>
    3a58:	3e051463          	bnez	a0,3e40 <subdir+0x756>
  if(unlink("dd") == 0){
    3a5c:	00004517          	auipc	a0,0x4
    3a60:	a8450513          	add	a0,a0,-1404 # 74e0 <malloc+0x148c>
    3a64:	00002097          	auipc	ra,0x2
    3a68:	200080e7          	jalr	512(ra) # 5c64 <unlink>
    3a6c:	3e050863          	beqz	a0,3e5c <subdir+0x772>
  if(unlink("dd/dd") < 0){
    3a70:	00004517          	auipc	a0,0x4
    3a74:	fa050513          	add	a0,a0,-96 # 7a10 <malloc+0x19bc>
    3a78:	00002097          	auipc	ra,0x2
    3a7c:	1ec080e7          	jalr	492(ra) # 5c64 <unlink>
    3a80:	3e054c63          	bltz	a0,3e78 <subdir+0x78e>
  if(unlink("dd") < 0){
    3a84:	00004517          	auipc	a0,0x4
    3a88:	a5c50513          	add	a0,a0,-1444 # 74e0 <malloc+0x148c>
    3a8c:	00002097          	auipc	ra,0x2
    3a90:	1d8080e7          	jalr	472(ra) # 5c64 <unlink>
    3a94:	40054063          	bltz	a0,3e94 <subdir+0x7aa>
}
    3a98:	60e2                	ld	ra,24(sp)
    3a9a:	6442                	ld	s0,16(sp)
    3a9c:	64a2                	ld	s1,8(sp)
    3a9e:	6902                	ld	s2,0(sp)
    3aa0:	6105                	add	sp,sp,32
    3aa2:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3aa4:	85ca                	mv	a1,s2
    3aa6:	00004517          	auipc	a0,0x4
    3aaa:	a4250513          	add	a0,a0,-1470 # 74e8 <malloc+0x1494>
    3aae:	00002097          	auipc	ra,0x2
    3ab2:	4ee080e7          	jalr	1262(ra) # 5f9c <printf>
    exit(1);
    3ab6:	4505                	li	a0,1
    3ab8:	00002097          	auipc	ra,0x2
    3abc:	15c080e7          	jalr	348(ra) # 5c14 <exit>
    printf("%s: create dd/ff failed\n", s);
    3ac0:	85ca                	mv	a1,s2
    3ac2:	00004517          	auipc	a0,0x4
    3ac6:	a4650513          	add	a0,a0,-1466 # 7508 <malloc+0x14b4>
    3aca:	00002097          	auipc	ra,0x2
    3ace:	4d2080e7          	jalr	1234(ra) # 5f9c <printf>
    exit(1);
    3ad2:	4505                	li	a0,1
    3ad4:	00002097          	auipc	ra,0x2
    3ad8:	140080e7          	jalr	320(ra) # 5c14 <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3adc:	85ca                	mv	a1,s2
    3ade:	00004517          	auipc	a0,0x4
    3ae2:	a4a50513          	add	a0,a0,-1462 # 7528 <malloc+0x14d4>
    3ae6:	00002097          	auipc	ra,0x2
    3aea:	4b6080e7          	jalr	1206(ra) # 5f9c <printf>
    exit(1);
    3aee:	4505                	li	a0,1
    3af0:	00002097          	auipc	ra,0x2
    3af4:	124080e7          	jalr	292(ra) # 5c14 <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    3af8:	85ca                	mv	a1,s2
    3afa:	00004517          	auipc	a0,0x4
    3afe:	a6650513          	add	a0,a0,-1434 # 7560 <malloc+0x150c>
    3b02:	00002097          	auipc	ra,0x2
    3b06:	49a080e7          	jalr	1178(ra) # 5f9c <printf>
    exit(1);
    3b0a:	4505                	li	a0,1
    3b0c:	00002097          	auipc	ra,0x2
    3b10:	108080e7          	jalr	264(ra) # 5c14 <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3b14:	85ca                	mv	a1,s2
    3b16:	00004517          	auipc	a0,0x4
    3b1a:	a7a50513          	add	a0,a0,-1414 # 7590 <malloc+0x153c>
    3b1e:	00002097          	auipc	ra,0x2
    3b22:	47e080e7          	jalr	1150(ra) # 5f9c <printf>
    exit(1);
    3b26:	4505                	li	a0,1
    3b28:	00002097          	auipc	ra,0x2
    3b2c:	0ec080e7          	jalr	236(ra) # 5c14 <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3b30:	85ca                	mv	a1,s2
    3b32:	00004517          	auipc	a0,0x4
    3b36:	a9650513          	add	a0,a0,-1386 # 75c8 <malloc+0x1574>
    3b3a:	00002097          	auipc	ra,0x2
    3b3e:	462080e7          	jalr	1122(ra) # 5f9c <printf>
    exit(1);
    3b42:	4505                	li	a0,1
    3b44:	00002097          	auipc	ra,0x2
    3b48:	0d0080e7          	jalr	208(ra) # 5c14 <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3b4c:	85ca                	mv	a1,s2
    3b4e:	00004517          	auipc	a0,0x4
    3b52:	a9a50513          	add	a0,a0,-1382 # 75e8 <malloc+0x1594>
    3b56:	00002097          	auipc	ra,0x2
    3b5a:	446080e7          	jalr	1094(ra) # 5f9c <printf>
    exit(1);
    3b5e:	4505                	li	a0,1
    3b60:	00002097          	auipc	ra,0x2
    3b64:	0b4080e7          	jalr	180(ra) # 5c14 <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    3b68:	85ca                	mv	a1,s2
    3b6a:	00004517          	auipc	a0,0x4
    3b6e:	aae50513          	add	a0,a0,-1362 # 7618 <malloc+0x15c4>
    3b72:	00002097          	auipc	ra,0x2
    3b76:	42a080e7          	jalr	1066(ra) # 5f9c <printf>
    exit(1);
    3b7a:	4505                	li	a0,1
    3b7c:	00002097          	auipc	ra,0x2
    3b80:	098080e7          	jalr	152(ra) # 5c14 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3b84:	85ca                	mv	a1,s2
    3b86:	00004517          	auipc	a0,0x4
    3b8a:	aba50513          	add	a0,a0,-1350 # 7640 <malloc+0x15ec>
    3b8e:	00002097          	auipc	ra,0x2
    3b92:	40e080e7          	jalr	1038(ra) # 5f9c <printf>
    exit(1);
    3b96:	4505                	li	a0,1
    3b98:	00002097          	auipc	ra,0x2
    3b9c:	07c080e7          	jalr	124(ra) # 5c14 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    3ba0:	85ca                	mv	a1,s2
    3ba2:	00004517          	auipc	a0,0x4
    3ba6:	abe50513          	add	a0,a0,-1346 # 7660 <malloc+0x160c>
    3baa:	00002097          	auipc	ra,0x2
    3bae:	3f2080e7          	jalr	1010(ra) # 5f9c <printf>
    exit(1);
    3bb2:	4505                	li	a0,1
    3bb4:	00002097          	auipc	ra,0x2
    3bb8:	060080e7          	jalr	96(ra) # 5c14 <exit>
    printf("%s: chdir dd failed\n", s);
    3bbc:	85ca                	mv	a1,s2
    3bbe:	00004517          	auipc	a0,0x4
    3bc2:	aca50513          	add	a0,a0,-1334 # 7688 <malloc+0x1634>
    3bc6:	00002097          	auipc	ra,0x2
    3bca:	3d6080e7          	jalr	982(ra) # 5f9c <printf>
    exit(1);
    3bce:	4505                	li	a0,1
    3bd0:	00002097          	auipc	ra,0x2
    3bd4:	044080e7          	jalr	68(ra) # 5c14 <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    3bd8:	85ca                	mv	a1,s2
    3bda:	00004517          	auipc	a0,0x4
    3bde:	ad650513          	add	a0,a0,-1322 # 76b0 <malloc+0x165c>
    3be2:	00002097          	auipc	ra,0x2
    3be6:	3ba080e7          	jalr	954(ra) # 5f9c <printf>
    exit(1);
    3bea:	4505                	li	a0,1
    3bec:	00002097          	auipc	ra,0x2
    3bf0:	028080e7          	jalr	40(ra) # 5c14 <exit>
    printf("chdir dd/../../dd failed\n", s);
    3bf4:	85ca                	mv	a1,s2
    3bf6:	00004517          	auipc	a0,0x4
    3bfa:	aea50513          	add	a0,a0,-1302 # 76e0 <malloc+0x168c>
    3bfe:	00002097          	auipc	ra,0x2
    3c02:	39e080e7          	jalr	926(ra) # 5f9c <printf>
    exit(1);
    3c06:	4505                	li	a0,1
    3c08:	00002097          	auipc	ra,0x2
    3c0c:	00c080e7          	jalr	12(ra) # 5c14 <exit>
    printf("%s: chdir ./.. failed\n", s);
    3c10:	85ca                	mv	a1,s2
    3c12:	00004517          	auipc	a0,0x4
    3c16:	af650513          	add	a0,a0,-1290 # 7708 <malloc+0x16b4>
    3c1a:	00002097          	auipc	ra,0x2
    3c1e:	382080e7          	jalr	898(ra) # 5f9c <printf>
    exit(1);
    3c22:	4505                	li	a0,1
    3c24:	00002097          	auipc	ra,0x2
    3c28:	ff0080e7          	jalr	-16(ra) # 5c14 <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3c2c:	85ca                	mv	a1,s2
    3c2e:	00004517          	auipc	a0,0x4
    3c32:	af250513          	add	a0,a0,-1294 # 7720 <malloc+0x16cc>
    3c36:	00002097          	auipc	ra,0x2
    3c3a:	366080e7          	jalr	870(ra) # 5f9c <printf>
    exit(1);
    3c3e:	4505                	li	a0,1
    3c40:	00002097          	auipc	ra,0x2
    3c44:	fd4080e7          	jalr	-44(ra) # 5c14 <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    3c48:	85ca                	mv	a1,s2
    3c4a:	00004517          	auipc	a0,0x4
    3c4e:	af650513          	add	a0,a0,-1290 # 7740 <malloc+0x16ec>
    3c52:	00002097          	auipc	ra,0x2
    3c56:	34a080e7          	jalr	842(ra) # 5f9c <printf>
    exit(1);
    3c5a:	4505                	li	a0,1
    3c5c:	00002097          	auipc	ra,0x2
    3c60:	fb8080e7          	jalr	-72(ra) # 5c14 <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3c64:	85ca                	mv	a1,s2
    3c66:	00004517          	auipc	a0,0x4
    3c6a:	afa50513          	add	a0,a0,-1286 # 7760 <malloc+0x170c>
    3c6e:	00002097          	auipc	ra,0x2
    3c72:	32e080e7          	jalr	814(ra) # 5f9c <printf>
    exit(1);
    3c76:	4505                	li	a0,1
    3c78:	00002097          	auipc	ra,0x2
    3c7c:	f9c080e7          	jalr	-100(ra) # 5c14 <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3c80:	85ca                	mv	a1,s2
    3c82:	00004517          	auipc	a0,0x4
    3c86:	b1e50513          	add	a0,a0,-1250 # 77a0 <malloc+0x174c>
    3c8a:	00002097          	auipc	ra,0x2
    3c8e:	312080e7          	jalr	786(ra) # 5f9c <printf>
    exit(1);
    3c92:	4505                	li	a0,1
    3c94:	00002097          	auipc	ra,0x2
    3c98:	f80080e7          	jalr	-128(ra) # 5c14 <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3c9c:	85ca                	mv	a1,s2
    3c9e:	00004517          	auipc	a0,0x4
    3ca2:	b3250513          	add	a0,a0,-1230 # 77d0 <malloc+0x177c>
    3ca6:	00002097          	auipc	ra,0x2
    3caa:	2f6080e7          	jalr	758(ra) # 5f9c <printf>
    exit(1);
    3cae:	4505                	li	a0,1
    3cb0:	00002097          	auipc	ra,0x2
    3cb4:	f64080e7          	jalr	-156(ra) # 5c14 <exit>
    printf("%s: create dd succeeded!\n", s);
    3cb8:	85ca                	mv	a1,s2
    3cba:	00004517          	auipc	a0,0x4
    3cbe:	b3650513          	add	a0,a0,-1226 # 77f0 <malloc+0x179c>
    3cc2:	00002097          	auipc	ra,0x2
    3cc6:	2da080e7          	jalr	730(ra) # 5f9c <printf>
    exit(1);
    3cca:	4505                	li	a0,1
    3ccc:	00002097          	auipc	ra,0x2
    3cd0:	f48080e7          	jalr	-184(ra) # 5c14 <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3cd4:	85ca                	mv	a1,s2
    3cd6:	00004517          	auipc	a0,0x4
    3cda:	b3a50513          	add	a0,a0,-1222 # 7810 <malloc+0x17bc>
    3cde:	00002097          	auipc	ra,0x2
    3ce2:	2be080e7          	jalr	702(ra) # 5f9c <printf>
    exit(1);
    3ce6:	4505                	li	a0,1
    3ce8:	00002097          	auipc	ra,0x2
    3cec:	f2c080e7          	jalr	-212(ra) # 5c14 <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3cf0:	85ca                	mv	a1,s2
    3cf2:	00004517          	auipc	a0,0x4
    3cf6:	b3e50513          	add	a0,a0,-1218 # 7830 <malloc+0x17dc>
    3cfa:	00002097          	auipc	ra,0x2
    3cfe:	2a2080e7          	jalr	674(ra) # 5f9c <printf>
    exit(1);
    3d02:	4505                	li	a0,1
    3d04:	00002097          	auipc	ra,0x2
    3d08:	f10080e7          	jalr	-240(ra) # 5c14 <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3d0c:	85ca                	mv	a1,s2
    3d0e:	00004517          	auipc	a0,0x4
    3d12:	b5250513          	add	a0,a0,-1198 # 7860 <malloc+0x180c>
    3d16:	00002097          	auipc	ra,0x2
    3d1a:	286080e7          	jalr	646(ra) # 5f9c <printf>
    exit(1);
    3d1e:	4505                	li	a0,1
    3d20:	00002097          	auipc	ra,0x2
    3d24:	ef4080e7          	jalr	-268(ra) # 5c14 <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3d28:	85ca                	mv	a1,s2
    3d2a:	00004517          	auipc	a0,0x4
    3d2e:	b5e50513          	add	a0,a0,-1186 # 7888 <malloc+0x1834>
    3d32:	00002097          	auipc	ra,0x2
    3d36:	26a080e7          	jalr	618(ra) # 5f9c <printf>
    exit(1);
    3d3a:	4505                	li	a0,1
    3d3c:	00002097          	auipc	ra,0x2
    3d40:	ed8080e7          	jalr	-296(ra) # 5c14 <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3d44:	85ca                	mv	a1,s2
    3d46:	00004517          	auipc	a0,0x4
    3d4a:	b6a50513          	add	a0,a0,-1174 # 78b0 <malloc+0x185c>
    3d4e:	00002097          	auipc	ra,0x2
    3d52:	24e080e7          	jalr	590(ra) # 5f9c <printf>
    exit(1);
    3d56:	4505                	li	a0,1
    3d58:	00002097          	auipc	ra,0x2
    3d5c:	ebc080e7          	jalr	-324(ra) # 5c14 <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3d60:	85ca                	mv	a1,s2
    3d62:	00004517          	auipc	a0,0x4
    3d66:	b7650513          	add	a0,a0,-1162 # 78d8 <malloc+0x1884>
    3d6a:	00002097          	auipc	ra,0x2
    3d6e:	232080e7          	jalr	562(ra) # 5f9c <printf>
    exit(1);
    3d72:	4505                	li	a0,1
    3d74:	00002097          	auipc	ra,0x2
    3d78:	ea0080e7          	jalr	-352(ra) # 5c14 <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3d7c:	85ca                	mv	a1,s2
    3d7e:	00004517          	auipc	a0,0x4
    3d82:	b7a50513          	add	a0,a0,-1158 # 78f8 <malloc+0x18a4>
    3d86:	00002097          	auipc	ra,0x2
    3d8a:	216080e7          	jalr	534(ra) # 5f9c <printf>
    exit(1);
    3d8e:	4505                	li	a0,1
    3d90:	00002097          	auipc	ra,0x2
    3d94:	e84080e7          	jalr	-380(ra) # 5c14 <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3d98:	85ca                	mv	a1,s2
    3d9a:	00004517          	auipc	a0,0x4
    3d9e:	b7e50513          	add	a0,a0,-1154 # 7918 <malloc+0x18c4>
    3da2:	00002097          	auipc	ra,0x2
    3da6:	1fa080e7          	jalr	506(ra) # 5f9c <printf>
    exit(1);
    3daa:	4505                	li	a0,1
    3dac:	00002097          	auipc	ra,0x2
    3db0:	e68080e7          	jalr	-408(ra) # 5c14 <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3db4:	85ca                	mv	a1,s2
    3db6:	00004517          	auipc	a0,0x4
    3dba:	b8a50513          	add	a0,a0,-1142 # 7940 <malloc+0x18ec>
    3dbe:	00002097          	auipc	ra,0x2
    3dc2:	1de080e7          	jalr	478(ra) # 5f9c <printf>
    exit(1);
    3dc6:	4505                	li	a0,1
    3dc8:	00002097          	auipc	ra,0x2
    3dcc:	e4c080e7          	jalr	-436(ra) # 5c14 <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3dd0:	85ca                	mv	a1,s2
    3dd2:	00004517          	auipc	a0,0x4
    3dd6:	b8e50513          	add	a0,a0,-1138 # 7960 <malloc+0x190c>
    3dda:	00002097          	auipc	ra,0x2
    3dde:	1c2080e7          	jalr	450(ra) # 5f9c <printf>
    exit(1);
    3de2:	4505                	li	a0,1
    3de4:	00002097          	auipc	ra,0x2
    3de8:	e30080e7          	jalr	-464(ra) # 5c14 <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3dec:	85ca                	mv	a1,s2
    3dee:	00004517          	auipc	a0,0x4
    3df2:	b9250513          	add	a0,a0,-1134 # 7980 <malloc+0x192c>
    3df6:	00002097          	auipc	ra,0x2
    3dfa:	1a6080e7          	jalr	422(ra) # 5f9c <printf>
    exit(1);
    3dfe:	4505                	li	a0,1
    3e00:	00002097          	auipc	ra,0x2
    3e04:	e14080e7          	jalr	-492(ra) # 5c14 <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    3e08:	85ca                	mv	a1,s2
    3e0a:	00004517          	auipc	a0,0x4
    3e0e:	b9e50513          	add	a0,a0,-1122 # 79a8 <malloc+0x1954>
    3e12:	00002097          	auipc	ra,0x2
    3e16:	18a080e7          	jalr	394(ra) # 5f9c <printf>
    exit(1);
    3e1a:	4505                	li	a0,1
    3e1c:	00002097          	auipc	ra,0x2
    3e20:	df8080e7          	jalr	-520(ra) # 5c14 <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3e24:	85ca                	mv	a1,s2
    3e26:	00004517          	auipc	a0,0x4
    3e2a:	81a50513          	add	a0,a0,-2022 # 7640 <malloc+0x15ec>
    3e2e:	00002097          	auipc	ra,0x2
    3e32:	16e080e7          	jalr	366(ra) # 5f9c <printf>
    exit(1);
    3e36:	4505                	li	a0,1
    3e38:	00002097          	auipc	ra,0x2
    3e3c:	ddc080e7          	jalr	-548(ra) # 5c14 <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3e40:	85ca                	mv	a1,s2
    3e42:	00004517          	auipc	a0,0x4
    3e46:	b8650513          	add	a0,a0,-1146 # 79c8 <malloc+0x1974>
    3e4a:	00002097          	auipc	ra,0x2
    3e4e:	152080e7          	jalr	338(ra) # 5f9c <printf>
    exit(1);
    3e52:	4505                	li	a0,1
    3e54:	00002097          	auipc	ra,0x2
    3e58:	dc0080e7          	jalr	-576(ra) # 5c14 <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3e5c:	85ca                	mv	a1,s2
    3e5e:	00004517          	auipc	a0,0x4
    3e62:	b8a50513          	add	a0,a0,-1142 # 79e8 <malloc+0x1994>
    3e66:	00002097          	auipc	ra,0x2
    3e6a:	136080e7          	jalr	310(ra) # 5f9c <printf>
    exit(1);
    3e6e:	4505                	li	a0,1
    3e70:	00002097          	auipc	ra,0x2
    3e74:	da4080e7          	jalr	-604(ra) # 5c14 <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3e78:	85ca                	mv	a1,s2
    3e7a:	00004517          	auipc	a0,0x4
    3e7e:	b9e50513          	add	a0,a0,-1122 # 7a18 <malloc+0x19c4>
    3e82:	00002097          	auipc	ra,0x2
    3e86:	11a080e7          	jalr	282(ra) # 5f9c <printf>
    exit(1);
    3e8a:	4505                	li	a0,1
    3e8c:	00002097          	auipc	ra,0x2
    3e90:	d88080e7          	jalr	-632(ra) # 5c14 <exit>
    printf("%s: unlink dd failed\n", s);
    3e94:	85ca                	mv	a1,s2
    3e96:	00004517          	auipc	a0,0x4
    3e9a:	ba250513          	add	a0,a0,-1118 # 7a38 <malloc+0x19e4>
    3e9e:	00002097          	auipc	ra,0x2
    3ea2:	0fe080e7          	jalr	254(ra) # 5f9c <printf>
    exit(1);
    3ea6:	4505                	li	a0,1
    3ea8:	00002097          	auipc	ra,0x2
    3eac:	d6c080e7          	jalr	-660(ra) # 5c14 <exit>

0000000000003eb0 <rmdot>:
{
    3eb0:	1101                	add	sp,sp,-32
    3eb2:	ec06                	sd	ra,24(sp)
    3eb4:	e822                	sd	s0,16(sp)
    3eb6:	e426                	sd	s1,8(sp)
    3eb8:	1000                	add	s0,sp,32
    3eba:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3ebc:	00004517          	auipc	a0,0x4
    3ec0:	b9450513          	add	a0,a0,-1132 # 7a50 <malloc+0x19fc>
    3ec4:	00002097          	auipc	ra,0x2
    3ec8:	db8080e7          	jalr	-584(ra) # 5c7c <mkdir>
    3ecc:	e549                	bnez	a0,3f56 <rmdot+0xa6>
  if(chdir("dots") != 0){
    3ece:	00004517          	auipc	a0,0x4
    3ed2:	b8250513          	add	a0,a0,-1150 # 7a50 <malloc+0x19fc>
    3ed6:	00002097          	auipc	ra,0x2
    3eda:	dae080e7          	jalr	-594(ra) # 5c84 <chdir>
    3ede:	e951                	bnez	a0,3f72 <rmdot+0xc2>
  if(unlink(".") == 0){
    3ee0:	00003517          	auipc	a0,0x3
    3ee4:	9a050513          	add	a0,a0,-1632 # 6880 <malloc+0x82c>
    3ee8:	00002097          	auipc	ra,0x2
    3eec:	d7c080e7          	jalr	-644(ra) # 5c64 <unlink>
    3ef0:	cd59                	beqz	a0,3f8e <rmdot+0xde>
  if(unlink("..") == 0){
    3ef2:	00003517          	auipc	a0,0x3
    3ef6:	5b650513          	add	a0,a0,1462 # 74a8 <malloc+0x1454>
    3efa:	00002097          	auipc	ra,0x2
    3efe:	d6a080e7          	jalr	-662(ra) # 5c64 <unlink>
    3f02:	c545                	beqz	a0,3faa <rmdot+0xfa>
  if(chdir("/") != 0){
    3f04:	00003517          	auipc	a0,0x3
    3f08:	54c50513          	add	a0,a0,1356 # 7450 <malloc+0x13fc>
    3f0c:	00002097          	auipc	ra,0x2
    3f10:	d78080e7          	jalr	-648(ra) # 5c84 <chdir>
    3f14:	e94d                	bnez	a0,3fc6 <rmdot+0x116>
  if(unlink("dots/.") == 0){
    3f16:	00004517          	auipc	a0,0x4
    3f1a:	ba250513          	add	a0,a0,-1118 # 7ab8 <malloc+0x1a64>
    3f1e:	00002097          	auipc	ra,0x2
    3f22:	d46080e7          	jalr	-698(ra) # 5c64 <unlink>
    3f26:	cd55                	beqz	a0,3fe2 <rmdot+0x132>
  if(unlink("dots/..") == 0){
    3f28:	00004517          	auipc	a0,0x4
    3f2c:	bb850513          	add	a0,a0,-1096 # 7ae0 <malloc+0x1a8c>
    3f30:	00002097          	auipc	ra,0x2
    3f34:	d34080e7          	jalr	-716(ra) # 5c64 <unlink>
    3f38:	c179                	beqz	a0,3ffe <rmdot+0x14e>
  if(unlink("dots") != 0){
    3f3a:	00004517          	auipc	a0,0x4
    3f3e:	b1650513          	add	a0,a0,-1258 # 7a50 <malloc+0x19fc>
    3f42:	00002097          	auipc	ra,0x2
    3f46:	d22080e7          	jalr	-734(ra) # 5c64 <unlink>
    3f4a:	e961                	bnez	a0,401a <rmdot+0x16a>
}
    3f4c:	60e2                	ld	ra,24(sp)
    3f4e:	6442                	ld	s0,16(sp)
    3f50:	64a2                	ld	s1,8(sp)
    3f52:	6105                	add	sp,sp,32
    3f54:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    3f56:	85a6                	mv	a1,s1
    3f58:	00004517          	auipc	a0,0x4
    3f5c:	b0050513          	add	a0,a0,-1280 # 7a58 <malloc+0x1a04>
    3f60:	00002097          	auipc	ra,0x2
    3f64:	03c080e7          	jalr	60(ra) # 5f9c <printf>
    exit(1);
    3f68:	4505                	li	a0,1
    3f6a:	00002097          	auipc	ra,0x2
    3f6e:	caa080e7          	jalr	-854(ra) # 5c14 <exit>
    printf("%s: chdir dots failed\n", s);
    3f72:	85a6                	mv	a1,s1
    3f74:	00004517          	auipc	a0,0x4
    3f78:	afc50513          	add	a0,a0,-1284 # 7a70 <malloc+0x1a1c>
    3f7c:	00002097          	auipc	ra,0x2
    3f80:	020080e7          	jalr	32(ra) # 5f9c <printf>
    exit(1);
    3f84:	4505                	li	a0,1
    3f86:	00002097          	auipc	ra,0x2
    3f8a:	c8e080e7          	jalr	-882(ra) # 5c14 <exit>
    printf("%s: rm . worked!\n", s);
    3f8e:	85a6                	mv	a1,s1
    3f90:	00004517          	auipc	a0,0x4
    3f94:	af850513          	add	a0,a0,-1288 # 7a88 <malloc+0x1a34>
    3f98:	00002097          	auipc	ra,0x2
    3f9c:	004080e7          	jalr	4(ra) # 5f9c <printf>
    exit(1);
    3fa0:	4505                	li	a0,1
    3fa2:	00002097          	auipc	ra,0x2
    3fa6:	c72080e7          	jalr	-910(ra) # 5c14 <exit>
    printf("%s: rm .. worked!\n", s);
    3faa:	85a6                	mv	a1,s1
    3fac:	00004517          	auipc	a0,0x4
    3fb0:	af450513          	add	a0,a0,-1292 # 7aa0 <malloc+0x1a4c>
    3fb4:	00002097          	auipc	ra,0x2
    3fb8:	fe8080e7          	jalr	-24(ra) # 5f9c <printf>
    exit(1);
    3fbc:	4505                	li	a0,1
    3fbe:	00002097          	auipc	ra,0x2
    3fc2:	c56080e7          	jalr	-938(ra) # 5c14 <exit>
    printf("%s: chdir / failed\n", s);
    3fc6:	85a6                	mv	a1,s1
    3fc8:	00003517          	auipc	a0,0x3
    3fcc:	49050513          	add	a0,a0,1168 # 7458 <malloc+0x1404>
    3fd0:	00002097          	auipc	ra,0x2
    3fd4:	fcc080e7          	jalr	-52(ra) # 5f9c <printf>
    exit(1);
    3fd8:	4505                	li	a0,1
    3fda:	00002097          	auipc	ra,0x2
    3fde:	c3a080e7          	jalr	-966(ra) # 5c14 <exit>
    printf("%s: unlink dots/. worked!\n", s);
    3fe2:	85a6                	mv	a1,s1
    3fe4:	00004517          	auipc	a0,0x4
    3fe8:	adc50513          	add	a0,a0,-1316 # 7ac0 <malloc+0x1a6c>
    3fec:	00002097          	auipc	ra,0x2
    3ff0:	fb0080e7          	jalr	-80(ra) # 5f9c <printf>
    exit(1);
    3ff4:	4505                	li	a0,1
    3ff6:	00002097          	auipc	ra,0x2
    3ffa:	c1e080e7          	jalr	-994(ra) # 5c14 <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3ffe:	85a6                	mv	a1,s1
    4000:	00004517          	auipc	a0,0x4
    4004:	ae850513          	add	a0,a0,-1304 # 7ae8 <malloc+0x1a94>
    4008:	00002097          	auipc	ra,0x2
    400c:	f94080e7          	jalr	-108(ra) # 5f9c <printf>
    exit(1);
    4010:	4505                	li	a0,1
    4012:	00002097          	auipc	ra,0x2
    4016:	c02080e7          	jalr	-1022(ra) # 5c14 <exit>
    printf("%s: unlink dots failed!\n", s);
    401a:	85a6                	mv	a1,s1
    401c:	00004517          	auipc	a0,0x4
    4020:	aec50513          	add	a0,a0,-1300 # 7b08 <malloc+0x1ab4>
    4024:	00002097          	auipc	ra,0x2
    4028:	f78080e7          	jalr	-136(ra) # 5f9c <printf>
    exit(1);
    402c:	4505                	li	a0,1
    402e:	00002097          	auipc	ra,0x2
    4032:	be6080e7          	jalr	-1050(ra) # 5c14 <exit>

0000000000004036 <dirfile>:
{
    4036:	1101                	add	sp,sp,-32
    4038:	ec06                	sd	ra,24(sp)
    403a:	e822                	sd	s0,16(sp)
    403c:	e426                	sd	s1,8(sp)
    403e:	e04a                	sd	s2,0(sp)
    4040:	1000                	add	s0,sp,32
    4042:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    4044:	20000593          	li	a1,512
    4048:	00004517          	auipc	a0,0x4
    404c:	ae050513          	add	a0,a0,-1312 # 7b28 <malloc+0x1ad4>
    4050:	00002097          	auipc	ra,0x2
    4054:	c04080e7          	jalr	-1020(ra) # 5c54 <open>
  if(fd < 0){
    4058:	0e054d63          	bltz	a0,4152 <dirfile+0x11c>
  close(fd);
    405c:	00002097          	auipc	ra,0x2
    4060:	be0080e7          	jalr	-1056(ra) # 5c3c <close>
  if(chdir("dirfile") == 0){
    4064:	00004517          	auipc	a0,0x4
    4068:	ac450513          	add	a0,a0,-1340 # 7b28 <malloc+0x1ad4>
    406c:	00002097          	auipc	ra,0x2
    4070:	c18080e7          	jalr	-1000(ra) # 5c84 <chdir>
    4074:	cd6d                	beqz	a0,416e <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    4076:	4581                	li	a1,0
    4078:	00004517          	auipc	a0,0x4
    407c:	af850513          	add	a0,a0,-1288 # 7b70 <malloc+0x1b1c>
    4080:	00002097          	auipc	ra,0x2
    4084:	bd4080e7          	jalr	-1068(ra) # 5c54 <open>
  if(fd >= 0){
    4088:	10055163          	bgez	a0,418a <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    408c:	20000593          	li	a1,512
    4090:	00004517          	auipc	a0,0x4
    4094:	ae050513          	add	a0,a0,-1312 # 7b70 <malloc+0x1b1c>
    4098:	00002097          	auipc	ra,0x2
    409c:	bbc080e7          	jalr	-1092(ra) # 5c54 <open>
  if(fd >= 0){
    40a0:	10055363          	bgez	a0,41a6 <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    40a4:	00004517          	auipc	a0,0x4
    40a8:	acc50513          	add	a0,a0,-1332 # 7b70 <malloc+0x1b1c>
    40ac:	00002097          	auipc	ra,0x2
    40b0:	bd0080e7          	jalr	-1072(ra) # 5c7c <mkdir>
    40b4:	10050763          	beqz	a0,41c2 <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    40b8:	00004517          	auipc	a0,0x4
    40bc:	ab850513          	add	a0,a0,-1352 # 7b70 <malloc+0x1b1c>
    40c0:	00002097          	auipc	ra,0x2
    40c4:	ba4080e7          	jalr	-1116(ra) # 5c64 <unlink>
    40c8:	10050b63          	beqz	a0,41de <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    40cc:	00004597          	auipc	a1,0x4
    40d0:	aa458593          	add	a1,a1,-1372 # 7b70 <malloc+0x1b1c>
    40d4:	00002517          	auipc	a0,0x2
    40d8:	29c50513          	add	a0,a0,668 # 6370 <malloc+0x31c>
    40dc:	00002097          	auipc	ra,0x2
    40e0:	b98080e7          	jalr	-1128(ra) # 5c74 <link>
    40e4:	10050b63          	beqz	a0,41fa <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    40e8:	00004517          	auipc	a0,0x4
    40ec:	a4050513          	add	a0,a0,-1472 # 7b28 <malloc+0x1ad4>
    40f0:	00002097          	auipc	ra,0x2
    40f4:	b74080e7          	jalr	-1164(ra) # 5c64 <unlink>
    40f8:	10051f63          	bnez	a0,4216 <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    40fc:	4589                	li	a1,2
    40fe:	00002517          	auipc	a0,0x2
    4102:	78250513          	add	a0,a0,1922 # 6880 <malloc+0x82c>
    4106:	00002097          	auipc	ra,0x2
    410a:	b4e080e7          	jalr	-1202(ra) # 5c54 <open>
  if(fd >= 0){
    410e:	12055263          	bgez	a0,4232 <dirfile+0x1fc>
  fd = open(".", 0);
    4112:	4581                	li	a1,0
    4114:	00002517          	auipc	a0,0x2
    4118:	76c50513          	add	a0,a0,1900 # 6880 <malloc+0x82c>
    411c:	00002097          	auipc	ra,0x2
    4120:	b38080e7          	jalr	-1224(ra) # 5c54 <open>
    4124:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    4126:	4605                	li	a2,1
    4128:	00002597          	auipc	a1,0x2
    412c:	0e058593          	add	a1,a1,224 # 6208 <malloc+0x1b4>
    4130:	00002097          	auipc	ra,0x2
    4134:	b04080e7          	jalr	-1276(ra) # 5c34 <write>
    4138:	10a04b63          	bgtz	a0,424e <dirfile+0x218>
  close(fd);
    413c:	8526                	mv	a0,s1
    413e:	00002097          	auipc	ra,0x2
    4142:	afe080e7          	jalr	-1282(ra) # 5c3c <close>
}
    4146:	60e2                	ld	ra,24(sp)
    4148:	6442                	ld	s0,16(sp)
    414a:	64a2                	ld	s1,8(sp)
    414c:	6902                	ld	s2,0(sp)
    414e:	6105                	add	sp,sp,32
    4150:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    4152:	85ca                	mv	a1,s2
    4154:	00004517          	auipc	a0,0x4
    4158:	9dc50513          	add	a0,a0,-1572 # 7b30 <malloc+0x1adc>
    415c:	00002097          	auipc	ra,0x2
    4160:	e40080e7          	jalr	-448(ra) # 5f9c <printf>
    exit(1);
    4164:	4505                	li	a0,1
    4166:	00002097          	auipc	ra,0x2
    416a:	aae080e7          	jalr	-1362(ra) # 5c14 <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    416e:	85ca                	mv	a1,s2
    4170:	00004517          	auipc	a0,0x4
    4174:	9e050513          	add	a0,a0,-1568 # 7b50 <malloc+0x1afc>
    4178:	00002097          	auipc	ra,0x2
    417c:	e24080e7          	jalr	-476(ra) # 5f9c <printf>
    exit(1);
    4180:	4505                	li	a0,1
    4182:	00002097          	auipc	ra,0x2
    4186:	a92080e7          	jalr	-1390(ra) # 5c14 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    418a:	85ca                	mv	a1,s2
    418c:	00004517          	auipc	a0,0x4
    4190:	9f450513          	add	a0,a0,-1548 # 7b80 <malloc+0x1b2c>
    4194:	00002097          	auipc	ra,0x2
    4198:	e08080e7          	jalr	-504(ra) # 5f9c <printf>
    exit(1);
    419c:	4505                	li	a0,1
    419e:	00002097          	auipc	ra,0x2
    41a2:	a76080e7          	jalr	-1418(ra) # 5c14 <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    41a6:	85ca                	mv	a1,s2
    41a8:	00004517          	auipc	a0,0x4
    41ac:	9d850513          	add	a0,a0,-1576 # 7b80 <malloc+0x1b2c>
    41b0:	00002097          	auipc	ra,0x2
    41b4:	dec080e7          	jalr	-532(ra) # 5f9c <printf>
    exit(1);
    41b8:	4505                	li	a0,1
    41ba:	00002097          	auipc	ra,0x2
    41be:	a5a080e7          	jalr	-1446(ra) # 5c14 <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    41c2:	85ca                	mv	a1,s2
    41c4:	00004517          	auipc	a0,0x4
    41c8:	9e450513          	add	a0,a0,-1564 # 7ba8 <malloc+0x1b54>
    41cc:	00002097          	auipc	ra,0x2
    41d0:	dd0080e7          	jalr	-560(ra) # 5f9c <printf>
    exit(1);
    41d4:	4505                	li	a0,1
    41d6:	00002097          	auipc	ra,0x2
    41da:	a3e080e7          	jalr	-1474(ra) # 5c14 <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    41de:	85ca                	mv	a1,s2
    41e0:	00004517          	auipc	a0,0x4
    41e4:	9f050513          	add	a0,a0,-1552 # 7bd0 <malloc+0x1b7c>
    41e8:	00002097          	auipc	ra,0x2
    41ec:	db4080e7          	jalr	-588(ra) # 5f9c <printf>
    exit(1);
    41f0:	4505                	li	a0,1
    41f2:	00002097          	auipc	ra,0x2
    41f6:	a22080e7          	jalr	-1502(ra) # 5c14 <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    41fa:	85ca                	mv	a1,s2
    41fc:	00004517          	auipc	a0,0x4
    4200:	9fc50513          	add	a0,a0,-1540 # 7bf8 <malloc+0x1ba4>
    4204:	00002097          	auipc	ra,0x2
    4208:	d98080e7          	jalr	-616(ra) # 5f9c <printf>
    exit(1);
    420c:	4505                	li	a0,1
    420e:	00002097          	auipc	ra,0x2
    4212:	a06080e7          	jalr	-1530(ra) # 5c14 <exit>
    printf("%s: unlink dirfile failed!\n", s);
    4216:	85ca                	mv	a1,s2
    4218:	00004517          	auipc	a0,0x4
    421c:	a0850513          	add	a0,a0,-1528 # 7c20 <malloc+0x1bcc>
    4220:	00002097          	auipc	ra,0x2
    4224:	d7c080e7          	jalr	-644(ra) # 5f9c <printf>
    exit(1);
    4228:	4505                	li	a0,1
    422a:	00002097          	auipc	ra,0x2
    422e:	9ea080e7          	jalr	-1558(ra) # 5c14 <exit>
    printf("%s: open . for writing succeeded!\n", s);
    4232:	85ca                	mv	a1,s2
    4234:	00004517          	auipc	a0,0x4
    4238:	a0c50513          	add	a0,a0,-1524 # 7c40 <malloc+0x1bec>
    423c:	00002097          	auipc	ra,0x2
    4240:	d60080e7          	jalr	-672(ra) # 5f9c <printf>
    exit(1);
    4244:	4505                	li	a0,1
    4246:	00002097          	auipc	ra,0x2
    424a:	9ce080e7          	jalr	-1586(ra) # 5c14 <exit>
    printf("%s: write . succeeded!\n", s);
    424e:	85ca                	mv	a1,s2
    4250:	00004517          	auipc	a0,0x4
    4254:	a1850513          	add	a0,a0,-1512 # 7c68 <malloc+0x1c14>
    4258:	00002097          	auipc	ra,0x2
    425c:	d44080e7          	jalr	-700(ra) # 5f9c <printf>
    exit(1);
    4260:	4505                	li	a0,1
    4262:	00002097          	auipc	ra,0x2
    4266:	9b2080e7          	jalr	-1614(ra) # 5c14 <exit>

000000000000426a <iref>:
{
    426a:	7139                	add	sp,sp,-64
    426c:	fc06                	sd	ra,56(sp)
    426e:	f822                	sd	s0,48(sp)
    4270:	f426                	sd	s1,40(sp)
    4272:	f04a                	sd	s2,32(sp)
    4274:	ec4e                	sd	s3,24(sp)
    4276:	e852                	sd	s4,16(sp)
    4278:	e456                	sd	s5,8(sp)
    427a:	e05a                	sd	s6,0(sp)
    427c:	0080                	add	s0,sp,64
    427e:	8b2a                	mv	s6,a0
    4280:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    4284:	00004a17          	auipc	s4,0x4
    4288:	9fca0a13          	add	s4,s4,-1540 # 7c80 <malloc+0x1c2c>
    mkdir("");
    428c:	00003497          	auipc	s1,0x3
    4290:	4fc48493          	add	s1,s1,1276 # 7788 <malloc+0x1734>
    link("README", "");
    4294:	00002a97          	auipc	s5,0x2
    4298:	0dca8a93          	add	s5,s5,220 # 6370 <malloc+0x31c>
    fd = open("xx", O_CREATE);
    429c:	00004997          	auipc	s3,0x4
    42a0:	8dc98993          	add	s3,s3,-1828 # 7b78 <malloc+0x1b24>
    42a4:	a891                	j	42f8 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    42a6:	85da                	mv	a1,s6
    42a8:	00004517          	auipc	a0,0x4
    42ac:	9e050513          	add	a0,a0,-1568 # 7c88 <malloc+0x1c34>
    42b0:	00002097          	auipc	ra,0x2
    42b4:	cec080e7          	jalr	-788(ra) # 5f9c <printf>
      exit(1);
    42b8:	4505                	li	a0,1
    42ba:	00002097          	auipc	ra,0x2
    42be:	95a080e7          	jalr	-1702(ra) # 5c14 <exit>
      printf("%s: chdir irefd failed\n", s);
    42c2:	85da                	mv	a1,s6
    42c4:	00004517          	auipc	a0,0x4
    42c8:	9dc50513          	add	a0,a0,-1572 # 7ca0 <malloc+0x1c4c>
    42cc:	00002097          	auipc	ra,0x2
    42d0:	cd0080e7          	jalr	-816(ra) # 5f9c <printf>
      exit(1);
    42d4:	4505                	li	a0,1
    42d6:	00002097          	auipc	ra,0x2
    42da:	93e080e7          	jalr	-1730(ra) # 5c14 <exit>
      close(fd);
    42de:	00002097          	auipc	ra,0x2
    42e2:	95e080e7          	jalr	-1698(ra) # 5c3c <close>
    42e6:	a889                	j	4338 <iref+0xce>
    unlink("xx");
    42e8:	854e                	mv	a0,s3
    42ea:	00002097          	auipc	ra,0x2
    42ee:	97a080e7          	jalr	-1670(ra) # 5c64 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    42f2:	397d                	addw	s2,s2,-1
    42f4:	06090063          	beqz	s2,4354 <iref+0xea>
    if(mkdir("irefd") != 0){
    42f8:	8552                	mv	a0,s4
    42fa:	00002097          	auipc	ra,0x2
    42fe:	982080e7          	jalr	-1662(ra) # 5c7c <mkdir>
    4302:	f155                	bnez	a0,42a6 <iref+0x3c>
    if(chdir("irefd") != 0){
    4304:	8552                	mv	a0,s4
    4306:	00002097          	auipc	ra,0x2
    430a:	97e080e7          	jalr	-1666(ra) # 5c84 <chdir>
    430e:	f955                	bnez	a0,42c2 <iref+0x58>
    mkdir("");
    4310:	8526                	mv	a0,s1
    4312:	00002097          	auipc	ra,0x2
    4316:	96a080e7          	jalr	-1686(ra) # 5c7c <mkdir>
    link("README", "");
    431a:	85a6                	mv	a1,s1
    431c:	8556                	mv	a0,s5
    431e:	00002097          	auipc	ra,0x2
    4322:	956080e7          	jalr	-1706(ra) # 5c74 <link>
    fd = open("", O_CREATE);
    4326:	20000593          	li	a1,512
    432a:	8526                	mv	a0,s1
    432c:	00002097          	auipc	ra,0x2
    4330:	928080e7          	jalr	-1752(ra) # 5c54 <open>
    if(fd >= 0)
    4334:	fa0555e3          	bgez	a0,42de <iref+0x74>
    fd = open("xx", O_CREATE);
    4338:	20000593          	li	a1,512
    433c:	854e                	mv	a0,s3
    433e:	00002097          	auipc	ra,0x2
    4342:	916080e7          	jalr	-1770(ra) # 5c54 <open>
    if(fd >= 0)
    4346:	fa0541e3          	bltz	a0,42e8 <iref+0x7e>
      close(fd);
    434a:	00002097          	auipc	ra,0x2
    434e:	8f2080e7          	jalr	-1806(ra) # 5c3c <close>
    4352:	bf59                	j	42e8 <iref+0x7e>
    4354:	03300493          	li	s1,51
    chdir("..");
    4358:	00003997          	auipc	s3,0x3
    435c:	15098993          	add	s3,s3,336 # 74a8 <malloc+0x1454>
    unlink("irefd");
    4360:	00004917          	auipc	s2,0x4
    4364:	92090913          	add	s2,s2,-1760 # 7c80 <malloc+0x1c2c>
    chdir("..");
    4368:	854e                	mv	a0,s3
    436a:	00002097          	auipc	ra,0x2
    436e:	91a080e7          	jalr	-1766(ra) # 5c84 <chdir>
    unlink("irefd");
    4372:	854a                	mv	a0,s2
    4374:	00002097          	auipc	ra,0x2
    4378:	8f0080e7          	jalr	-1808(ra) # 5c64 <unlink>
  for(i = 0; i < NINODE + 1; i++){
    437c:	34fd                	addw	s1,s1,-1
    437e:	f4ed                	bnez	s1,4368 <iref+0xfe>
  chdir("/");
    4380:	00003517          	auipc	a0,0x3
    4384:	0d050513          	add	a0,a0,208 # 7450 <malloc+0x13fc>
    4388:	00002097          	auipc	ra,0x2
    438c:	8fc080e7          	jalr	-1796(ra) # 5c84 <chdir>
}
    4390:	70e2                	ld	ra,56(sp)
    4392:	7442                	ld	s0,48(sp)
    4394:	74a2                	ld	s1,40(sp)
    4396:	7902                	ld	s2,32(sp)
    4398:	69e2                	ld	s3,24(sp)
    439a:	6a42                	ld	s4,16(sp)
    439c:	6aa2                	ld	s5,8(sp)
    439e:	6b02                	ld	s6,0(sp)
    43a0:	6121                	add	sp,sp,64
    43a2:	8082                	ret

00000000000043a4 <openiputtest>:
{
    43a4:	7179                	add	sp,sp,-48
    43a6:	f406                	sd	ra,40(sp)
    43a8:	f022                	sd	s0,32(sp)
    43aa:	ec26                	sd	s1,24(sp)
    43ac:	1800                	add	s0,sp,48
    43ae:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    43b0:	00004517          	auipc	a0,0x4
    43b4:	90850513          	add	a0,a0,-1784 # 7cb8 <malloc+0x1c64>
    43b8:	00002097          	auipc	ra,0x2
    43bc:	8c4080e7          	jalr	-1852(ra) # 5c7c <mkdir>
    43c0:	04054263          	bltz	a0,4404 <openiputtest+0x60>
  pid = fork();
    43c4:	00002097          	auipc	ra,0x2
    43c8:	848080e7          	jalr	-1976(ra) # 5c0c <fork>
  if(pid < 0){
    43cc:	04054a63          	bltz	a0,4420 <openiputtest+0x7c>
  if(pid == 0){
    43d0:	e93d                	bnez	a0,4446 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
    43d2:	4589                	li	a1,2
    43d4:	00004517          	auipc	a0,0x4
    43d8:	8e450513          	add	a0,a0,-1820 # 7cb8 <malloc+0x1c64>
    43dc:	00002097          	auipc	ra,0x2
    43e0:	878080e7          	jalr	-1928(ra) # 5c54 <open>
    if(fd >= 0){
    43e4:	04054c63          	bltz	a0,443c <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
    43e8:	85a6                	mv	a1,s1
    43ea:	00004517          	auipc	a0,0x4
    43ee:	8ee50513          	add	a0,a0,-1810 # 7cd8 <malloc+0x1c84>
    43f2:	00002097          	auipc	ra,0x2
    43f6:	baa080e7          	jalr	-1110(ra) # 5f9c <printf>
      exit(1);
    43fa:	4505                	li	a0,1
    43fc:	00002097          	auipc	ra,0x2
    4400:	818080e7          	jalr	-2024(ra) # 5c14 <exit>
    printf("%s: mkdir oidir failed\n", s);
    4404:	85a6                	mv	a1,s1
    4406:	00004517          	auipc	a0,0x4
    440a:	8ba50513          	add	a0,a0,-1862 # 7cc0 <malloc+0x1c6c>
    440e:	00002097          	auipc	ra,0x2
    4412:	b8e080e7          	jalr	-1138(ra) # 5f9c <printf>
    exit(1);
    4416:	4505                	li	a0,1
    4418:	00001097          	auipc	ra,0x1
    441c:	7fc080e7          	jalr	2044(ra) # 5c14 <exit>
    printf("%s: fork failed\n", s);
    4420:	85a6                	mv	a1,s1
    4422:	00002517          	auipc	a0,0x2
    4426:	5fe50513          	add	a0,a0,1534 # 6a20 <malloc+0x9cc>
    442a:	00002097          	auipc	ra,0x2
    442e:	b72080e7          	jalr	-1166(ra) # 5f9c <printf>
    exit(1);
    4432:	4505                	li	a0,1
    4434:	00001097          	auipc	ra,0x1
    4438:	7e0080e7          	jalr	2016(ra) # 5c14 <exit>
    exit(0);
    443c:	4501                	li	a0,0
    443e:	00001097          	auipc	ra,0x1
    4442:	7d6080e7          	jalr	2006(ra) # 5c14 <exit>
  sleep(1);
    4446:	4505                	li	a0,1
    4448:	00002097          	auipc	ra,0x2
    444c:	85c080e7          	jalr	-1956(ra) # 5ca4 <sleep>
  if(unlink("oidir") != 0){
    4450:	00004517          	auipc	a0,0x4
    4454:	86850513          	add	a0,a0,-1944 # 7cb8 <malloc+0x1c64>
    4458:	00002097          	auipc	ra,0x2
    445c:	80c080e7          	jalr	-2036(ra) # 5c64 <unlink>
    4460:	cd19                	beqz	a0,447e <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
    4462:	85a6                	mv	a1,s1
    4464:	00002517          	auipc	a0,0x2
    4468:	7ac50513          	add	a0,a0,1964 # 6c10 <malloc+0xbbc>
    446c:	00002097          	auipc	ra,0x2
    4470:	b30080e7          	jalr	-1232(ra) # 5f9c <printf>
    exit(1);
    4474:	4505                	li	a0,1
    4476:	00001097          	auipc	ra,0x1
    447a:	79e080e7          	jalr	1950(ra) # 5c14 <exit>
  wait(&xstatus);
    447e:	fdc40513          	add	a0,s0,-36
    4482:	00001097          	auipc	ra,0x1
    4486:	79a080e7          	jalr	1946(ra) # 5c1c <wait>
  exit(xstatus);
    448a:	fdc42503          	lw	a0,-36(s0)
    448e:	00001097          	auipc	ra,0x1
    4492:	786080e7          	jalr	1926(ra) # 5c14 <exit>

0000000000004496 <forkforkfork>:
{
    4496:	1101                	add	sp,sp,-32
    4498:	ec06                	sd	ra,24(sp)
    449a:	e822                	sd	s0,16(sp)
    449c:	e426                	sd	s1,8(sp)
    449e:	1000                	add	s0,sp,32
    44a0:	84aa                	mv	s1,a0
  unlink("stopforking");
    44a2:	00004517          	auipc	a0,0x4
    44a6:	85e50513          	add	a0,a0,-1954 # 7d00 <malloc+0x1cac>
    44aa:	00001097          	auipc	ra,0x1
    44ae:	7ba080e7          	jalr	1978(ra) # 5c64 <unlink>
  int pid = fork();
    44b2:	00001097          	auipc	ra,0x1
    44b6:	75a080e7          	jalr	1882(ra) # 5c0c <fork>
  if(pid < 0){
    44ba:	04054563          	bltz	a0,4504 <forkforkfork+0x6e>
  if(pid == 0){
    44be:	c12d                	beqz	a0,4520 <forkforkfork+0x8a>
  sleep(20); // two seconds
    44c0:	4551                	li	a0,20
    44c2:	00001097          	auipc	ra,0x1
    44c6:	7e2080e7          	jalr	2018(ra) # 5ca4 <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
    44ca:	20200593          	li	a1,514
    44ce:	00004517          	auipc	a0,0x4
    44d2:	83250513          	add	a0,a0,-1998 # 7d00 <malloc+0x1cac>
    44d6:	00001097          	auipc	ra,0x1
    44da:	77e080e7          	jalr	1918(ra) # 5c54 <open>
    44de:	00001097          	auipc	ra,0x1
    44e2:	75e080e7          	jalr	1886(ra) # 5c3c <close>
  wait(0);
    44e6:	4501                	li	a0,0
    44e8:	00001097          	auipc	ra,0x1
    44ec:	734080e7          	jalr	1844(ra) # 5c1c <wait>
  sleep(10); // one second
    44f0:	4529                	li	a0,10
    44f2:	00001097          	auipc	ra,0x1
    44f6:	7b2080e7          	jalr	1970(ra) # 5ca4 <sleep>
}
    44fa:	60e2                	ld	ra,24(sp)
    44fc:	6442                	ld	s0,16(sp)
    44fe:	64a2                	ld	s1,8(sp)
    4500:	6105                	add	sp,sp,32
    4502:	8082                	ret
    printf("%s: fork failed", s);
    4504:	85a6                	mv	a1,s1
    4506:	00002517          	auipc	a0,0x2
    450a:	6da50513          	add	a0,a0,1754 # 6be0 <malloc+0xb8c>
    450e:	00002097          	auipc	ra,0x2
    4512:	a8e080e7          	jalr	-1394(ra) # 5f9c <printf>
    exit(1);
    4516:	4505                	li	a0,1
    4518:	00001097          	auipc	ra,0x1
    451c:	6fc080e7          	jalr	1788(ra) # 5c14 <exit>
      int fd = open("stopforking", 0);
    4520:	00003497          	auipc	s1,0x3
    4524:	7e048493          	add	s1,s1,2016 # 7d00 <malloc+0x1cac>
    4528:	4581                	li	a1,0
    452a:	8526                	mv	a0,s1
    452c:	00001097          	auipc	ra,0x1
    4530:	728080e7          	jalr	1832(ra) # 5c54 <open>
      if(fd >= 0){
    4534:	02055763          	bgez	a0,4562 <forkforkfork+0xcc>
      if(fork() < 0){
    4538:	00001097          	auipc	ra,0x1
    453c:	6d4080e7          	jalr	1748(ra) # 5c0c <fork>
    4540:	fe0554e3          	bgez	a0,4528 <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
    4544:	20200593          	li	a1,514
    4548:	00003517          	auipc	a0,0x3
    454c:	7b850513          	add	a0,a0,1976 # 7d00 <malloc+0x1cac>
    4550:	00001097          	auipc	ra,0x1
    4554:	704080e7          	jalr	1796(ra) # 5c54 <open>
    4558:	00001097          	auipc	ra,0x1
    455c:	6e4080e7          	jalr	1764(ra) # 5c3c <close>
    4560:	b7e1                	j	4528 <forkforkfork+0x92>
        exit(0);
    4562:	4501                	li	a0,0
    4564:	00001097          	auipc	ra,0x1
    4568:	6b0080e7          	jalr	1712(ra) # 5c14 <exit>

000000000000456c <killstatus>:
{
    456c:	7139                	add	sp,sp,-64
    456e:	fc06                	sd	ra,56(sp)
    4570:	f822                	sd	s0,48(sp)
    4572:	f426                	sd	s1,40(sp)
    4574:	f04a                	sd	s2,32(sp)
    4576:	ec4e                	sd	s3,24(sp)
    4578:	e852                	sd	s4,16(sp)
    457a:	0080                	add	s0,sp,64
    457c:	8a2a                	mv	s4,a0
    457e:	06400913          	li	s2,100
    if(xst != -1) {
    4582:	59fd                	li	s3,-1
    int pid1 = fork();
    4584:	00001097          	auipc	ra,0x1
    4588:	688080e7          	jalr	1672(ra) # 5c0c <fork>
    458c:	84aa                	mv	s1,a0
    if(pid1 < 0){
    458e:	02054f63          	bltz	a0,45cc <killstatus+0x60>
    if(pid1 == 0){
    4592:	c939                	beqz	a0,45e8 <killstatus+0x7c>
    sleep(1);
    4594:	4505                	li	a0,1
    4596:	00001097          	auipc	ra,0x1
    459a:	70e080e7          	jalr	1806(ra) # 5ca4 <sleep>
    kill(pid1);
    459e:	8526                	mv	a0,s1
    45a0:	00001097          	auipc	ra,0x1
    45a4:	6a4080e7          	jalr	1700(ra) # 5c44 <kill>
    wait(&xst);
    45a8:	fcc40513          	add	a0,s0,-52
    45ac:	00001097          	auipc	ra,0x1
    45b0:	670080e7          	jalr	1648(ra) # 5c1c <wait>
    if(xst != -1) {
    45b4:	fcc42783          	lw	a5,-52(s0)
    45b8:	03379d63          	bne	a5,s3,45f2 <killstatus+0x86>
  for(int i = 0; i < 100; i++){
    45bc:	397d                	addw	s2,s2,-1
    45be:	fc0913e3          	bnez	s2,4584 <killstatus+0x18>
  exit(0);
    45c2:	4501                	li	a0,0
    45c4:	00001097          	auipc	ra,0x1
    45c8:	650080e7          	jalr	1616(ra) # 5c14 <exit>
      printf("%s: fork failed\n", s);
    45cc:	85d2                	mv	a1,s4
    45ce:	00002517          	auipc	a0,0x2
    45d2:	45250513          	add	a0,a0,1106 # 6a20 <malloc+0x9cc>
    45d6:	00002097          	auipc	ra,0x2
    45da:	9c6080e7          	jalr	-1594(ra) # 5f9c <printf>
      exit(1);
    45de:	4505                	li	a0,1
    45e0:	00001097          	auipc	ra,0x1
    45e4:	634080e7          	jalr	1588(ra) # 5c14 <exit>
        getpid();
    45e8:	00001097          	auipc	ra,0x1
    45ec:	6ac080e7          	jalr	1708(ra) # 5c94 <getpid>
      while(1) {
    45f0:	bfe5                	j	45e8 <killstatus+0x7c>
       printf("%s: status should be -1\n", s);
    45f2:	85d2                	mv	a1,s4
    45f4:	00003517          	auipc	a0,0x3
    45f8:	71c50513          	add	a0,a0,1820 # 7d10 <malloc+0x1cbc>
    45fc:	00002097          	auipc	ra,0x2
    4600:	9a0080e7          	jalr	-1632(ra) # 5f9c <printf>
       exit(1);
    4604:	4505                	li	a0,1
    4606:	00001097          	auipc	ra,0x1
    460a:	60e080e7          	jalr	1550(ra) # 5c14 <exit>

000000000000460e <preempt>:
{
    460e:	7139                	add	sp,sp,-64
    4610:	fc06                	sd	ra,56(sp)
    4612:	f822                	sd	s0,48(sp)
    4614:	f426                	sd	s1,40(sp)
    4616:	f04a                	sd	s2,32(sp)
    4618:	ec4e                	sd	s3,24(sp)
    461a:	e852                	sd	s4,16(sp)
    461c:	0080                	add	s0,sp,64
    461e:	892a                	mv	s2,a0
  pid1 = fork();
    4620:	00001097          	auipc	ra,0x1
    4624:	5ec080e7          	jalr	1516(ra) # 5c0c <fork>
  if(pid1 < 0) {
    4628:	00054563          	bltz	a0,4632 <preempt+0x24>
    462c:	84aa                	mv	s1,a0
  if(pid1 == 0)
    462e:	e105                	bnez	a0,464e <preempt+0x40>
    for(;;)
    4630:	a001                	j	4630 <preempt+0x22>
    printf("%s: fork failed", s);
    4632:	85ca                	mv	a1,s2
    4634:	00002517          	auipc	a0,0x2
    4638:	5ac50513          	add	a0,a0,1452 # 6be0 <malloc+0xb8c>
    463c:	00002097          	auipc	ra,0x2
    4640:	960080e7          	jalr	-1696(ra) # 5f9c <printf>
    exit(1);
    4644:	4505                	li	a0,1
    4646:	00001097          	auipc	ra,0x1
    464a:	5ce080e7          	jalr	1486(ra) # 5c14 <exit>
  pid2 = fork();
    464e:	00001097          	auipc	ra,0x1
    4652:	5be080e7          	jalr	1470(ra) # 5c0c <fork>
    4656:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    4658:	00054463          	bltz	a0,4660 <preempt+0x52>
  if(pid2 == 0)
    465c:	e105                	bnez	a0,467c <preempt+0x6e>
    for(;;)
    465e:	a001                	j	465e <preempt+0x50>
    printf("%s: fork failed\n", s);
    4660:	85ca                	mv	a1,s2
    4662:	00002517          	auipc	a0,0x2
    4666:	3be50513          	add	a0,a0,958 # 6a20 <malloc+0x9cc>
    466a:	00002097          	auipc	ra,0x2
    466e:	932080e7          	jalr	-1742(ra) # 5f9c <printf>
    exit(1);
    4672:	4505                	li	a0,1
    4674:	00001097          	auipc	ra,0x1
    4678:	5a0080e7          	jalr	1440(ra) # 5c14 <exit>
  pipe(pfds);
    467c:	fc840513          	add	a0,s0,-56
    4680:	00001097          	auipc	ra,0x1
    4684:	5a4080e7          	jalr	1444(ra) # 5c24 <pipe>
  pid3 = fork();
    4688:	00001097          	auipc	ra,0x1
    468c:	584080e7          	jalr	1412(ra) # 5c0c <fork>
    4690:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    4692:	02054e63          	bltz	a0,46ce <preempt+0xc0>
  if(pid3 == 0){
    4696:	e525                	bnez	a0,46fe <preempt+0xf0>
    close(pfds[0]);
    4698:	fc842503          	lw	a0,-56(s0)
    469c:	00001097          	auipc	ra,0x1
    46a0:	5a0080e7          	jalr	1440(ra) # 5c3c <close>
    if(write(pfds[1], "x", 1) != 1)
    46a4:	4605                	li	a2,1
    46a6:	00002597          	auipc	a1,0x2
    46aa:	b6258593          	add	a1,a1,-1182 # 6208 <malloc+0x1b4>
    46ae:	fcc42503          	lw	a0,-52(s0)
    46b2:	00001097          	auipc	ra,0x1
    46b6:	582080e7          	jalr	1410(ra) # 5c34 <write>
    46ba:	4785                	li	a5,1
    46bc:	02f51763          	bne	a0,a5,46ea <preempt+0xdc>
    close(pfds[1]);
    46c0:	fcc42503          	lw	a0,-52(s0)
    46c4:	00001097          	auipc	ra,0x1
    46c8:	578080e7          	jalr	1400(ra) # 5c3c <close>
    for(;;)
    46cc:	a001                	j	46cc <preempt+0xbe>
     printf("%s: fork failed\n", s);
    46ce:	85ca                	mv	a1,s2
    46d0:	00002517          	auipc	a0,0x2
    46d4:	35050513          	add	a0,a0,848 # 6a20 <malloc+0x9cc>
    46d8:	00002097          	auipc	ra,0x2
    46dc:	8c4080e7          	jalr	-1852(ra) # 5f9c <printf>
     exit(1);
    46e0:	4505                	li	a0,1
    46e2:	00001097          	auipc	ra,0x1
    46e6:	532080e7          	jalr	1330(ra) # 5c14 <exit>
      printf("%s: preempt write error", s);
    46ea:	85ca                	mv	a1,s2
    46ec:	00003517          	auipc	a0,0x3
    46f0:	64450513          	add	a0,a0,1604 # 7d30 <malloc+0x1cdc>
    46f4:	00002097          	auipc	ra,0x2
    46f8:	8a8080e7          	jalr	-1880(ra) # 5f9c <printf>
    46fc:	b7d1                	j	46c0 <preempt+0xb2>
  close(pfds[1]);
    46fe:	fcc42503          	lw	a0,-52(s0)
    4702:	00001097          	auipc	ra,0x1
    4706:	53a080e7          	jalr	1338(ra) # 5c3c <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    470a:	660d                	lui	a2,0x3
    470c:	00008597          	auipc	a1,0x8
    4710:	56c58593          	add	a1,a1,1388 # cc78 <buf>
    4714:	fc842503          	lw	a0,-56(s0)
    4718:	00001097          	auipc	ra,0x1
    471c:	514080e7          	jalr	1300(ra) # 5c2c <read>
    4720:	4785                	li	a5,1
    4722:	02f50363          	beq	a0,a5,4748 <preempt+0x13a>
    printf("%s: preempt read error", s);
    4726:	85ca                	mv	a1,s2
    4728:	00003517          	auipc	a0,0x3
    472c:	62050513          	add	a0,a0,1568 # 7d48 <malloc+0x1cf4>
    4730:	00002097          	auipc	ra,0x2
    4734:	86c080e7          	jalr	-1940(ra) # 5f9c <printf>
}
    4738:	70e2                	ld	ra,56(sp)
    473a:	7442                	ld	s0,48(sp)
    473c:	74a2                	ld	s1,40(sp)
    473e:	7902                	ld	s2,32(sp)
    4740:	69e2                	ld	s3,24(sp)
    4742:	6a42                	ld	s4,16(sp)
    4744:	6121                	add	sp,sp,64
    4746:	8082                	ret
  close(pfds[0]);
    4748:	fc842503          	lw	a0,-56(s0)
    474c:	00001097          	auipc	ra,0x1
    4750:	4f0080e7          	jalr	1264(ra) # 5c3c <close>
  printf("kill... ");
    4754:	00003517          	auipc	a0,0x3
    4758:	60c50513          	add	a0,a0,1548 # 7d60 <malloc+0x1d0c>
    475c:	00002097          	auipc	ra,0x2
    4760:	840080e7          	jalr	-1984(ra) # 5f9c <printf>
  kill(pid1);
    4764:	8526                	mv	a0,s1
    4766:	00001097          	auipc	ra,0x1
    476a:	4de080e7          	jalr	1246(ra) # 5c44 <kill>
  kill(pid2);
    476e:	854e                	mv	a0,s3
    4770:	00001097          	auipc	ra,0x1
    4774:	4d4080e7          	jalr	1236(ra) # 5c44 <kill>
  kill(pid3);
    4778:	8552                	mv	a0,s4
    477a:	00001097          	auipc	ra,0x1
    477e:	4ca080e7          	jalr	1226(ra) # 5c44 <kill>
  printf("wait... ");
    4782:	00003517          	auipc	a0,0x3
    4786:	5ee50513          	add	a0,a0,1518 # 7d70 <malloc+0x1d1c>
    478a:	00002097          	auipc	ra,0x2
    478e:	812080e7          	jalr	-2030(ra) # 5f9c <printf>
  wait(0);
    4792:	4501                	li	a0,0
    4794:	00001097          	auipc	ra,0x1
    4798:	488080e7          	jalr	1160(ra) # 5c1c <wait>
  wait(0);
    479c:	4501                	li	a0,0
    479e:	00001097          	auipc	ra,0x1
    47a2:	47e080e7          	jalr	1150(ra) # 5c1c <wait>
  wait(0);
    47a6:	4501                	li	a0,0
    47a8:	00001097          	auipc	ra,0x1
    47ac:	474080e7          	jalr	1140(ra) # 5c1c <wait>
    47b0:	b761                	j	4738 <preempt+0x12a>

00000000000047b2 <reparent>:
{
    47b2:	7179                	add	sp,sp,-48
    47b4:	f406                	sd	ra,40(sp)
    47b6:	f022                	sd	s0,32(sp)
    47b8:	ec26                	sd	s1,24(sp)
    47ba:	e84a                	sd	s2,16(sp)
    47bc:	e44e                	sd	s3,8(sp)
    47be:	e052                	sd	s4,0(sp)
    47c0:	1800                	add	s0,sp,48
    47c2:	89aa                	mv	s3,a0
  int master_pid = getpid();
    47c4:	00001097          	auipc	ra,0x1
    47c8:	4d0080e7          	jalr	1232(ra) # 5c94 <getpid>
    47cc:	8a2a                	mv	s4,a0
    47ce:	0c800913          	li	s2,200
    int pid = fork();
    47d2:	00001097          	auipc	ra,0x1
    47d6:	43a080e7          	jalr	1082(ra) # 5c0c <fork>
    47da:	84aa                	mv	s1,a0
    if(pid < 0){
    47dc:	02054263          	bltz	a0,4800 <reparent+0x4e>
    if(pid){
    47e0:	cd21                	beqz	a0,4838 <reparent+0x86>
      if(wait(0) != pid){
    47e2:	4501                	li	a0,0
    47e4:	00001097          	auipc	ra,0x1
    47e8:	438080e7          	jalr	1080(ra) # 5c1c <wait>
    47ec:	02951863          	bne	a0,s1,481c <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    47f0:	397d                	addw	s2,s2,-1
    47f2:	fe0910e3          	bnez	s2,47d2 <reparent+0x20>
  exit(0);
    47f6:	4501                	li	a0,0
    47f8:	00001097          	auipc	ra,0x1
    47fc:	41c080e7          	jalr	1052(ra) # 5c14 <exit>
      printf("%s: fork failed\n", s);
    4800:	85ce                	mv	a1,s3
    4802:	00002517          	auipc	a0,0x2
    4806:	21e50513          	add	a0,a0,542 # 6a20 <malloc+0x9cc>
    480a:	00001097          	auipc	ra,0x1
    480e:	792080e7          	jalr	1938(ra) # 5f9c <printf>
      exit(1);
    4812:	4505                	li	a0,1
    4814:	00001097          	auipc	ra,0x1
    4818:	400080e7          	jalr	1024(ra) # 5c14 <exit>
        printf("%s: wait wrong pid\n", s);
    481c:	85ce                	mv	a1,s3
    481e:	00002517          	auipc	a0,0x2
    4822:	38a50513          	add	a0,a0,906 # 6ba8 <malloc+0xb54>
    4826:	00001097          	auipc	ra,0x1
    482a:	776080e7          	jalr	1910(ra) # 5f9c <printf>
        exit(1);
    482e:	4505                	li	a0,1
    4830:	00001097          	auipc	ra,0x1
    4834:	3e4080e7          	jalr	996(ra) # 5c14 <exit>
      int pid2 = fork();
    4838:	00001097          	auipc	ra,0x1
    483c:	3d4080e7          	jalr	980(ra) # 5c0c <fork>
      if(pid2 < 0){
    4840:	00054763          	bltz	a0,484e <reparent+0x9c>
      exit(0);
    4844:	4501                	li	a0,0
    4846:	00001097          	auipc	ra,0x1
    484a:	3ce080e7          	jalr	974(ra) # 5c14 <exit>
        kill(master_pid);
    484e:	8552                	mv	a0,s4
    4850:	00001097          	auipc	ra,0x1
    4854:	3f4080e7          	jalr	1012(ra) # 5c44 <kill>
        exit(1);
    4858:	4505                	li	a0,1
    485a:	00001097          	auipc	ra,0x1
    485e:	3ba080e7          	jalr	954(ra) # 5c14 <exit>

0000000000004862 <sbrkfail>:
{
    4862:	7119                	add	sp,sp,-128
    4864:	fc86                	sd	ra,120(sp)
    4866:	f8a2                	sd	s0,112(sp)
    4868:	f4a6                	sd	s1,104(sp)
    486a:	f0ca                	sd	s2,96(sp)
    486c:	ecce                	sd	s3,88(sp)
    486e:	e8d2                	sd	s4,80(sp)
    4870:	e4d6                	sd	s5,72(sp)
    4872:	0100                	add	s0,sp,128
    4874:	8aaa                	mv	s5,a0
  if(pipe(fds) != 0){
    4876:	fb040513          	add	a0,s0,-80
    487a:	00001097          	auipc	ra,0x1
    487e:	3aa080e7          	jalr	938(ra) # 5c24 <pipe>
    4882:	e901                	bnez	a0,4892 <sbrkfail+0x30>
    4884:	f8040493          	add	s1,s0,-128
    4888:	fa840993          	add	s3,s0,-88
    488c:	8926                	mv	s2,s1
    if(pids[i] != -1)
    488e:	5a7d                	li	s4,-1
    4890:	a085                	j	48f0 <sbrkfail+0x8e>
    printf("%s: pipe() failed\n", s);
    4892:	85d6                	mv	a1,s5
    4894:	00002517          	auipc	a0,0x2
    4898:	29450513          	add	a0,a0,660 # 6b28 <malloc+0xad4>
    489c:	00001097          	auipc	ra,0x1
    48a0:	700080e7          	jalr	1792(ra) # 5f9c <printf>
    exit(1);
    48a4:	4505                	li	a0,1
    48a6:	00001097          	auipc	ra,0x1
    48aa:	36e080e7          	jalr	878(ra) # 5c14 <exit>
      sbrk(BIG - (uint64)sbrk(0));
    48ae:	00001097          	auipc	ra,0x1
    48b2:	3ee080e7          	jalr	1006(ra) # 5c9c <sbrk>
    48b6:	064007b7          	lui	a5,0x6400
    48ba:	40a7853b          	subw	a0,a5,a0
    48be:	00001097          	auipc	ra,0x1
    48c2:	3de080e7          	jalr	990(ra) # 5c9c <sbrk>
      write(fds[1], "x", 1);
    48c6:	4605                	li	a2,1
    48c8:	00002597          	auipc	a1,0x2
    48cc:	94058593          	add	a1,a1,-1728 # 6208 <malloc+0x1b4>
    48d0:	fb442503          	lw	a0,-76(s0)
    48d4:	00001097          	auipc	ra,0x1
    48d8:	360080e7          	jalr	864(ra) # 5c34 <write>
      for(;;) sleep(1000);
    48dc:	3e800513          	li	a0,1000
    48e0:	00001097          	auipc	ra,0x1
    48e4:	3c4080e7          	jalr	964(ra) # 5ca4 <sleep>
    48e8:	bfd5                	j	48dc <sbrkfail+0x7a>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    48ea:	0911                	add	s2,s2,4
    48ec:	03390563          	beq	s2,s3,4916 <sbrkfail+0xb4>
    if((pids[i] = fork()) == 0){
    48f0:	00001097          	auipc	ra,0x1
    48f4:	31c080e7          	jalr	796(ra) # 5c0c <fork>
    48f8:	00a92023          	sw	a0,0(s2)
    48fc:	d94d                	beqz	a0,48ae <sbrkfail+0x4c>
    if(pids[i] != -1)
    48fe:	ff4506e3          	beq	a0,s4,48ea <sbrkfail+0x88>
      read(fds[0], &scratch, 1);
    4902:	4605                	li	a2,1
    4904:	faf40593          	add	a1,s0,-81
    4908:	fb042503          	lw	a0,-80(s0)
    490c:	00001097          	auipc	ra,0x1
    4910:	320080e7          	jalr	800(ra) # 5c2c <read>
    4914:	bfd9                	j	48ea <sbrkfail+0x88>
  c = sbrk(PGSIZE);
    4916:	6505                	lui	a0,0x1
    4918:	00001097          	auipc	ra,0x1
    491c:	384080e7          	jalr	900(ra) # 5c9c <sbrk>
    4920:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    4922:	597d                	li	s2,-1
    4924:	a021                	j	492c <sbrkfail+0xca>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    4926:	0491                	add	s1,s1,4
    4928:	01348f63          	beq	s1,s3,4946 <sbrkfail+0xe4>
    if(pids[i] == -1)
    492c:	4088                	lw	a0,0(s1)
    492e:	ff250ce3          	beq	a0,s2,4926 <sbrkfail+0xc4>
    kill(pids[i]);
    4932:	00001097          	auipc	ra,0x1
    4936:	312080e7          	jalr	786(ra) # 5c44 <kill>
    wait(0);
    493a:	4501                	li	a0,0
    493c:	00001097          	auipc	ra,0x1
    4940:	2e0080e7          	jalr	736(ra) # 5c1c <wait>
    4944:	b7cd                	j	4926 <sbrkfail+0xc4>
  if(c == (char*)0xffffffffffffffffL){
    4946:	57fd                	li	a5,-1
    4948:	04fa0163          	beq	s4,a5,498a <sbrkfail+0x128>
  pid = fork();
    494c:	00001097          	auipc	ra,0x1
    4950:	2c0080e7          	jalr	704(ra) # 5c0c <fork>
    4954:	84aa                	mv	s1,a0
  if(pid < 0){
    4956:	04054863          	bltz	a0,49a6 <sbrkfail+0x144>
  if(pid == 0){
    495a:	c525                	beqz	a0,49c2 <sbrkfail+0x160>
  wait(&xstatus);
    495c:	fbc40513          	add	a0,s0,-68
    4960:	00001097          	auipc	ra,0x1
    4964:	2bc080e7          	jalr	700(ra) # 5c1c <wait>
  if(xstatus != -1 && xstatus != 2)
    4968:	fbc42783          	lw	a5,-68(s0)
    496c:	577d                	li	a4,-1
    496e:	00e78563          	beq	a5,a4,4978 <sbrkfail+0x116>
    4972:	4709                	li	a4,2
    4974:	08e79d63          	bne	a5,a4,4a0e <sbrkfail+0x1ac>
}
    4978:	70e6                	ld	ra,120(sp)
    497a:	7446                	ld	s0,112(sp)
    497c:	74a6                	ld	s1,104(sp)
    497e:	7906                	ld	s2,96(sp)
    4980:	69e6                	ld	s3,88(sp)
    4982:	6a46                	ld	s4,80(sp)
    4984:	6aa6                	ld	s5,72(sp)
    4986:	6109                	add	sp,sp,128
    4988:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    498a:	85d6                	mv	a1,s5
    498c:	00003517          	auipc	a0,0x3
    4990:	3f450513          	add	a0,a0,1012 # 7d80 <malloc+0x1d2c>
    4994:	00001097          	auipc	ra,0x1
    4998:	608080e7          	jalr	1544(ra) # 5f9c <printf>
    exit(1);
    499c:	4505                	li	a0,1
    499e:	00001097          	auipc	ra,0x1
    49a2:	276080e7          	jalr	630(ra) # 5c14 <exit>
    printf("%s: fork failed\n", s);
    49a6:	85d6                	mv	a1,s5
    49a8:	00002517          	auipc	a0,0x2
    49ac:	07850513          	add	a0,a0,120 # 6a20 <malloc+0x9cc>
    49b0:	00001097          	auipc	ra,0x1
    49b4:	5ec080e7          	jalr	1516(ra) # 5f9c <printf>
    exit(1);
    49b8:	4505                	li	a0,1
    49ba:	00001097          	auipc	ra,0x1
    49be:	25a080e7          	jalr	602(ra) # 5c14 <exit>
    a = sbrk(0);
    49c2:	4501                	li	a0,0
    49c4:	00001097          	auipc	ra,0x1
    49c8:	2d8080e7          	jalr	728(ra) # 5c9c <sbrk>
    49cc:	892a                	mv	s2,a0
    sbrk(10*BIG);
    49ce:	3e800537          	lui	a0,0x3e800
    49d2:	00001097          	auipc	ra,0x1
    49d6:	2ca080e7          	jalr	714(ra) # 5c9c <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49da:	87ca                	mv	a5,s2
    49dc:	3e800737          	lui	a4,0x3e800
    49e0:	993a                	add	s2,s2,a4
    49e2:	6705                	lui	a4,0x1
      n += *(a+i);
    49e4:	0007c683          	lbu	a3,0(a5) # 6400000 <base+0x63f0388>
    49e8:	9cb5                	addw	s1,s1,a3
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    49ea:	97ba                	add	a5,a5,a4
    49ec:	fef91ce3          	bne	s2,a5,49e4 <sbrkfail+0x182>
    printf("%s: allocate a lot of memory succeeded %d\n", s, n);
    49f0:	8626                	mv	a2,s1
    49f2:	85d6                	mv	a1,s5
    49f4:	00003517          	auipc	a0,0x3
    49f8:	3ac50513          	add	a0,a0,940 # 7da0 <malloc+0x1d4c>
    49fc:	00001097          	auipc	ra,0x1
    4a00:	5a0080e7          	jalr	1440(ra) # 5f9c <printf>
    exit(1);
    4a04:	4505                	li	a0,1
    4a06:	00001097          	auipc	ra,0x1
    4a0a:	20e080e7          	jalr	526(ra) # 5c14 <exit>
    exit(1);
    4a0e:	4505                	li	a0,1
    4a10:	00001097          	auipc	ra,0x1
    4a14:	204080e7          	jalr	516(ra) # 5c14 <exit>

0000000000004a18 <mem>:
{
    4a18:	7139                	add	sp,sp,-64
    4a1a:	fc06                	sd	ra,56(sp)
    4a1c:	f822                	sd	s0,48(sp)
    4a1e:	f426                	sd	s1,40(sp)
    4a20:	f04a                	sd	s2,32(sp)
    4a22:	ec4e                	sd	s3,24(sp)
    4a24:	0080                	add	s0,sp,64
    4a26:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    4a28:	00001097          	auipc	ra,0x1
    4a2c:	1e4080e7          	jalr	484(ra) # 5c0c <fork>
    m1 = 0;
    4a30:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    4a32:	6909                	lui	s2,0x2
    4a34:	71190913          	add	s2,s2,1809 # 2711 <copyinstr3+0xd1>
  if((pid = fork()) == 0){
    4a38:	c115                	beqz	a0,4a5c <mem+0x44>
    wait(&xstatus);
    4a3a:	fcc40513          	add	a0,s0,-52
    4a3e:	00001097          	auipc	ra,0x1
    4a42:	1de080e7          	jalr	478(ra) # 5c1c <wait>
    if(xstatus == -1){
    4a46:	fcc42503          	lw	a0,-52(s0)
    4a4a:	57fd                	li	a5,-1
    4a4c:	06f50363          	beq	a0,a5,4ab2 <mem+0x9a>
    exit(xstatus);
    4a50:	00001097          	auipc	ra,0x1
    4a54:	1c4080e7          	jalr	452(ra) # 5c14 <exit>
      *(char**)m2 = m1;
    4a58:	e104                	sd	s1,0(a0)
      m1 = m2;
    4a5a:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    4a5c:	854a                	mv	a0,s2
    4a5e:	00001097          	auipc	ra,0x1
    4a62:	5f6080e7          	jalr	1526(ra) # 6054 <malloc>
    4a66:	f96d                	bnez	a0,4a58 <mem+0x40>
    while(m1){
    4a68:	c881                	beqz	s1,4a78 <mem+0x60>
      m2 = *(char**)m1;
    4a6a:	8526                	mv	a0,s1
    4a6c:	6084                	ld	s1,0(s1)
      free(m1);
    4a6e:	00001097          	auipc	ra,0x1
    4a72:	564080e7          	jalr	1380(ra) # 5fd2 <free>
    while(m1){
    4a76:	f8f5                	bnez	s1,4a6a <mem+0x52>
    m1 = malloc(1024*20);
    4a78:	6515                	lui	a0,0x5
    4a7a:	00001097          	auipc	ra,0x1
    4a7e:	5da080e7          	jalr	1498(ra) # 6054 <malloc>
    if(m1 == 0){
    4a82:	c911                	beqz	a0,4a96 <mem+0x7e>
    free(m1);
    4a84:	00001097          	auipc	ra,0x1
    4a88:	54e080e7          	jalr	1358(ra) # 5fd2 <free>
    exit(0);
    4a8c:	4501                	li	a0,0
    4a8e:	00001097          	auipc	ra,0x1
    4a92:	186080e7          	jalr	390(ra) # 5c14 <exit>
      printf("couldn't allocate mem?!!\n", s);
    4a96:	85ce                	mv	a1,s3
    4a98:	00003517          	auipc	a0,0x3
    4a9c:	33850513          	add	a0,a0,824 # 7dd0 <malloc+0x1d7c>
    4aa0:	00001097          	auipc	ra,0x1
    4aa4:	4fc080e7          	jalr	1276(ra) # 5f9c <printf>
      exit(1);
    4aa8:	4505                	li	a0,1
    4aaa:	00001097          	auipc	ra,0x1
    4aae:	16a080e7          	jalr	362(ra) # 5c14 <exit>
      exit(0);
    4ab2:	4501                	li	a0,0
    4ab4:	00001097          	auipc	ra,0x1
    4ab8:	160080e7          	jalr	352(ra) # 5c14 <exit>

0000000000004abc <sharedfd>:
{
    4abc:	7159                	add	sp,sp,-112
    4abe:	f486                	sd	ra,104(sp)
    4ac0:	f0a2                	sd	s0,96(sp)
    4ac2:	e0d2                	sd	s4,64(sp)
    4ac4:	1880                	add	s0,sp,112
    4ac6:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    4ac8:	00003517          	auipc	a0,0x3
    4acc:	32850513          	add	a0,a0,808 # 7df0 <malloc+0x1d9c>
    4ad0:	00001097          	auipc	ra,0x1
    4ad4:	194080e7          	jalr	404(ra) # 5c64 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    4ad8:	20200593          	li	a1,514
    4adc:	00003517          	auipc	a0,0x3
    4ae0:	31450513          	add	a0,a0,788 # 7df0 <malloc+0x1d9c>
    4ae4:	00001097          	auipc	ra,0x1
    4ae8:	170080e7          	jalr	368(ra) # 5c54 <open>
  if(fd < 0){
    4aec:	06054063          	bltz	a0,4b4c <sharedfd+0x90>
    4af0:	eca6                	sd	s1,88(sp)
    4af2:	e8ca                	sd	s2,80(sp)
    4af4:	e4ce                	sd	s3,72(sp)
    4af6:	fc56                	sd	s5,56(sp)
    4af8:	f85a                	sd	s6,48(sp)
    4afa:	f45e                	sd	s7,40(sp)
    4afc:	892a                	mv	s2,a0
  pid = fork();
    4afe:	00001097          	auipc	ra,0x1
    4b02:	10e080e7          	jalr	270(ra) # 5c0c <fork>
    4b06:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    4b08:	07000593          	li	a1,112
    4b0c:	e119                	bnez	a0,4b12 <sharedfd+0x56>
    4b0e:	06300593          	li	a1,99
    4b12:	4629                	li	a2,10
    4b14:	fa040513          	add	a0,s0,-96
    4b18:	00001097          	auipc	ra,0x1
    4b1c:	eea080e7          	jalr	-278(ra) # 5a02 <memset>
    4b20:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    4b24:	4629                	li	a2,10
    4b26:	fa040593          	add	a1,s0,-96
    4b2a:	854a                	mv	a0,s2
    4b2c:	00001097          	auipc	ra,0x1
    4b30:	108080e7          	jalr	264(ra) # 5c34 <write>
    4b34:	47a9                	li	a5,10
    4b36:	02f51f63          	bne	a0,a5,4b74 <sharedfd+0xb8>
  for(i = 0; i < N; i++){
    4b3a:	34fd                	addw	s1,s1,-1
    4b3c:	f4e5                	bnez	s1,4b24 <sharedfd+0x68>
  if(pid == 0) {
    4b3e:	04099963          	bnez	s3,4b90 <sharedfd+0xd4>
    exit(0);
    4b42:	4501                	li	a0,0
    4b44:	00001097          	auipc	ra,0x1
    4b48:	0d0080e7          	jalr	208(ra) # 5c14 <exit>
    4b4c:	eca6                	sd	s1,88(sp)
    4b4e:	e8ca                	sd	s2,80(sp)
    4b50:	e4ce                	sd	s3,72(sp)
    4b52:	fc56                	sd	s5,56(sp)
    4b54:	f85a                	sd	s6,48(sp)
    4b56:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    4b58:	85d2                	mv	a1,s4
    4b5a:	00003517          	auipc	a0,0x3
    4b5e:	2a650513          	add	a0,a0,678 # 7e00 <malloc+0x1dac>
    4b62:	00001097          	auipc	ra,0x1
    4b66:	43a080e7          	jalr	1082(ra) # 5f9c <printf>
    exit(1);
    4b6a:	4505                	li	a0,1
    4b6c:	00001097          	auipc	ra,0x1
    4b70:	0a8080e7          	jalr	168(ra) # 5c14 <exit>
      printf("%s: write sharedfd failed\n", s);
    4b74:	85d2                	mv	a1,s4
    4b76:	00003517          	auipc	a0,0x3
    4b7a:	2b250513          	add	a0,a0,690 # 7e28 <malloc+0x1dd4>
    4b7e:	00001097          	auipc	ra,0x1
    4b82:	41e080e7          	jalr	1054(ra) # 5f9c <printf>
      exit(1);
    4b86:	4505                	li	a0,1
    4b88:	00001097          	auipc	ra,0x1
    4b8c:	08c080e7          	jalr	140(ra) # 5c14 <exit>
    wait(&xstatus);
    4b90:	f9c40513          	add	a0,s0,-100
    4b94:	00001097          	auipc	ra,0x1
    4b98:	088080e7          	jalr	136(ra) # 5c1c <wait>
    if(xstatus != 0)
    4b9c:	f9c42983          	lw	s3,-100(s0)
    4ba0:	00098763          	beqz	s3,4bae <sharedfd+0xf2>
      exit(xstatus);
    4ba4:	854e                	mv	a0,s3
    4ba6:	00001097          	auipc	ra,0x1
    4baa:	06e080e7          	jalr	110(ra) # 5c14 <exit>
  close(fd);
    4bae:	854a                	mv	a0,s2
    4bb0:	00001097          	auipc	ra,0x1
    4bb4:	08c080e7          	jalr	140(ra) # 5c3c <close>
  fd = open("sharedfd", 0);
    4bb8:	4581                	li	a1,0
    4bba:	00003517          	auipc	a0,0x3
    4bbe:	23650513          	add	a0,a0,566 # 7df0 <malloc+0x1d9c>
    4bc2:	00001097          	auipc	ra,0x1
    4bc6:	092080e7          	jalr	146(ra) # 5c54 <open>
    4bca:	8baa                	mv	s7,a0
  nc = np = 0;
    4bcc:	8ace                	mv	s5,s3
  if(fd < 0){
    4bce:	02054563          	bltz	a0,4bf8 <sharedfd+0x13c>
    4bd2:	faa40913          	add	s2,s0,-86
      if(buf[i] == 'c')
    4bd6:	06300493          	li	s1,99
      if(buf[i] == 'p')
    4bda:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    4bde:	4629                	li	a2,10
    4be0:	fa040593          	add	a1,s0,-96
    4be4:	855e                	mv	a0,s7
    4be6:	00001097          	auipc	ra,0x1
    4bea:	046080e7          	jalr	70(ra) # 5c2c <read>
    4bee:	02a05f63          	blez	a0,4c2c <sharedfd+0x170>
    4bf2:	fa040793          	add	a5,s0,-96
    4bf6:	a01d                	j	4c1c <sharedfd+0x160>
    printf("%s: cannot open sharedfd for reading\n", s);
    4bf8:	85d2                	mv	a1,s4
    4bfa:	00003517          	auipc	a0,0x3
    4bfe:	24e50513          	add	a0,a0,590 # 7e48 <malloc+0x1df4>
    4c02:	00001097          	auipc	ra,0x1
    4c06:	39a080e7          	jalr	922(ra) # 5f9c <printf>
    exit(1);
    4c0a:	4505                	li	a0,1
    4c0c:	00001097          	auipc	ra,0x1
    4c10:	008080e7          	jalr	8(ra) # 5c14 <exit>
        nc++;
    4c14:	2985                	addw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    4c16:	0785                	add	a5,a5,1
    4c18:	fd2783e3          	beq	a5,s2,4bde <sharedfd+0x122>
      if(buf[i] == 'c')
    4c1c:	0007c703          	lbu	a4,0(a5)
    4c20:	fe970ae3          	beq	a4,s1,4c14 <sharedfd+0x158>
      if(buf[i] == 'p')
    4c24:	ff6719e3          	bne	a4,s6,4c16 <sharedfd+0x15a>
        np++;
    4c28:	2a85                	addw	s5,s5,1
    4c2a:	b7f5                	j	4c16 <sharedfd+0x15a>
  close(fd);
    4c2c:	855e                	mv	a0,s7
    4c2e:	00001097          	auipc	ra,0x1
    4c32:	00e080e7          	jalr	14(ra) # 5c3c <close>
  unlink("sharedfd");
    4c36:	00003517          	auipc	a0,0x3
    4c3a:	1ba50513          	add	a0,a0,442 # 7df0 <malloc+0x1d9c>
    4c3e:	00001097          	auipc	ra,0x1
    4c42:	026080e7          	jalr	38(ra) # 5c64 <unlink>
  if(nc == N*SZ && np == N*SZ){
    4c46:	6789                	lui	a5,0x2
    4c48:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xd0>
    4c4c:	00f99763          	bne	s3,a5,4c5a <sharedfd+0x19e>
    4c50:	6789                	lui	a5,0x2
    4c52:	71078793          	add	a5,a5,1808 # 2710 <copyinstr3+0xd0>
    4c56:	02fa8063          	beq	s5,a5,4c76 <sharedfd+0x1ba>
    printf("%s: nc/np test fails\n", s);
    4c5a:	85d2                	mv	a1,s4
    4c5c:	00003517          	auipc	a0,0x3
    4c60:	21450513          	add	a0,a0,532 # 7e70 <malloc+0x1e1c>
    4c64:	00001097          	auipc	ra,0x1
    4c68:	338080e7          	jalr	824(ra) # 5f9c <printf>
    exit(1);
    4c6c:	4505                	li	a0,1
    4c6e:	00001097          	auipc	ra,0x1
    4c72:	fa6080e7          	jalr	-90(ra) # 5c14 <exit>
    exit(0);
    4c76:	4501                	li	a0,0
    4c78:	00001097          	auipc	ra,0x1
    4c7c:	f9c080e7          	jalr	-100(ra) # 5c14 <exit>

0000000000004c80 <fourfiles>:
{
    4c80:	7135                	add	sp,sp,-160
    4c82:	ed06                	sd	ra,152(sp)
    4c84:	e922                	sd	s0,144(sp)
    4c86:	e526                	sd	s1,136(sp)
    4c88:	e14a                	sd	s2,128(sp)
    4c8a:	fcce                	sd	s3,120(sp)
    4c8c:	f8d2                	sd	s4,112(sp)
    4c8e:	f4d6                	sd	s5,104(sp)
    4c90:	f0da                	sd	s6,96(sp)
    4c92:	ecde                	sd	s7,88(sp)
    4c94:	e8e2                	sd	s8,80(sp)
    4c96:	e4e6                	sd	s9,72(sp)
    4c98:	e0ea                	sd	s10,64(sp)
    4c9a:	fc6e                	sd	s11,56(sp)
    4c9c:	1100                	add	s0,sp,160
    4c9e:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    4ca0:	00003797          	auipc	a5,0x3
    4ca4:	1e878793          	add	a5,a5,488 # 7e88 <malloc+0x1e34>
    4ca8:	f6f43823          	sd	a5,-144(s0)
    4cac:	00003797          	auipc	a5,0x3
    4cb0:	1e478793          	add	a5,a5,484 # 7e90 <malloc+0x1e3c>
    4cb4:	f6f43c23          	sd	a5,-136(s0)
    4cb8:	00003797          	auipc	a5,0x3
    4cbc:	1e078793          	add	a5,a5,480 # 7e98 <malloc+0x1e44>
    4cc0:	f8f43023          	sd	a5,-128(s0)
    4cc4:	00003797          	auipc	a5,0x3
    4cc8:	1dc78793          	add	a5,a5,476 # 7ea0 <malloc+0x1e4c>
    4ccc:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    4cd0:	f7040b93          	add	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    4cd4:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    4cd6:	4481                	li	s1,0
    4cd8:	4a11                	li	s4,4
    fname = names[pi];
    4cda:	00093983          	ld	s3,0(s2)
    unlink(fname);
    4cde:	854e                	mv	a0,s3
    4ce0:	00001097          	auipc	ra,0x1
    4ce4:	f84080e7          	jalr	-124(ra) # 5c64 <unlink>
    pid = fork();
    4ce8:	00001097          	auipc	ra,0x1
    4cec:	f24080e7          	jalr	-220(ra) # 5c0c <fork>
    if(pid < 0){
    4cf0:	04054063          	bltz	a0,4d30 <fourfiles+0xb0>
    if(pid == 0){
    4cf4:	cd21                	beqz	a0,4d4c <fourfiles+0xcc>
  for(pi = 0; pi < NCHILD; pi++){
    4cf6:	2485                	addw	s1,s1,1
    4cf8:	0921                	add	s2,s2,8
    4cfa:	ff4490e3          	bne	s1,s4,4cda <fourfiles+0x5a>
    4cfe:	4491                	li	s1,4
    wait(&xstatus);
    4d00:	f6c40513          	add	a0,s0,-148
    4d04:	00001097          	auipc	ra,0x1
    4d08:	f18080e7          	jalr	-232(ra) # 5c1c <wait>
    if(xstatus != 0)
    4d0c:	f6c42a83          	lw	s5,-148(s0)
    4d10:	0c0a9863          	bnez	s5,4de0 <fourfiles+0x160>
  for(pi = 0; pi < NCHILD; pi++){
    4d14:	34fd                	addw	s1,s1,-1
    4d16:	f4ed                	bnez	s1,4d00 <fourfiles+0x80>
    4d18:	03000b13          	li	s6,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4d1c:	00008a17          	auipc	s4,0x8
    4d20:	f5ca0a13          	add	s4,s4,-164 # cc78 <buf>
    if(total != N*SZ){
    4d24:	6d05                	lui	s10,0x1
    4d26:	770d0d13          	add	s10,s10,1904 # 1770 <exectest+0x20>
  for(i = 0; i < NCHILD; i++){
    4d2a:	03400d93          	li	s11,52
    4d2e:	a22d                	j	4e58 <fourfiles+0x1d8>
      printf("fork failed\n", s);
    4d30:	85e6                	mv	a1,s9
    4d32:	00002517          	auipc	a0,0x2
    4d36:	0f650513          	add	a0,a0,246 # 6e28 <malloc+0xdd4>
    4d3a:	00001097          	auipc	ra,0x1
    4d3e:	262080e7          	jalr	610(ra) # 5f9c <printf>
      exit(1);
    4d42:	4505                	li	a0,1
    4d44:	00001097          	auipc	ra,0x1
    4d48:	ed0080e7          	jalr	-304(ra) # 5c14 <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    4d4c:	20200593          	li	a1,514
    4d50:	854e                	mv	a0,s3
    4d52:	00001097          	auipc	ra,0x1
    4d56:	f02080e7          	jalr	-254(ra) # 5c54 <open>
    4d5a:	892a                	mv	s2,a0
      if(fd < 0){
    4d5c:	04054763          	bltz	a0,4daa <fourfiles+0x12a>
      memset(buf, '0'+pi, SZ);
    4d60:	1f400613          	li	a2,500
    4d64:	0304859b          	addw	a1,s1,48
    4d68:	00008517          	auipc	a0,0x8
    4d6c:	f1050513          	add	a0,a0,-240 # cc78 <buf>
    4d70:	00001097          	auipc	ra,0x1
    4d74:	c92080e7          	jalr	-878(ra) # 5a02 <memset>
    4d78:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    4d7a:	00008997          	auipc	s3,0x8
    4d7e:	efe98993          	add	s3,s3,-258 # cc78 <buf>
    4d82:	1f400613          	li	a2,500
    4d86:	85ce                	mv	a1,s3
    4d88:	854a                	mv	a0,s2
    4d8a:	00001097          	auipc	ra,0x1
    4d8e:	eaa080e7          	jalr	-342(ra) # 5c34 <write>
    4d92:	85aa                	mv	a1,a0
    4d94:	1f400793          	li	a5,500
    4d98:	02f51763          	bne	a0,a5,4dc6 <fourfiles+0x146>
      for(i = 0; i < N; i++){
    4d9c:	34fd                	addw	s1,s1,-1
    4d9e:	f0f5                	bnez	s1,4d82 <fourfiles+0x102>
      exit(0);
    4da0:	4501                	li	a0,0
    4da2:	00001097          	auipc	ra,0x1
    4da6:	e72080e7          	jalr	-398(ra) # 5c14 <exit>
        printf("create failed\n", s);
    4daa:	85e6                	mv	a1,s9
    4dac:	00003517          	auipc	a0,0x3
    4db0:	0fc50513          	add	a0,a0,252 # 7ea8 <malloc+0x1e54>
    4db4:	00001097          	auipc	ra,0x1
    4db8:	1e8080e7          	jalr	488(ra) # 5f9c <printf>
        exit(1);
    4dbc:	4505                	li	a0,1
    4dbe:	00001097          	auipc	ra,0x1
    4dc2:	e56080e7          	jalr	-426(ra) # 5c14 <exit>
          printf("write failed %d\n", n);
    4dc6:	00003517          	auipc	a0,0x3
    4dca:	0f250513          	add	a0,a0,242 # 7eb8 <malloc+0x1e64>
    4dce:	00001097          	auipc	ra,0x1
    4dd2:	1ce080e7          	jalr	462(ra) # 5f9c <printf>
          exit(1);
    4dd6:	4505                	li	a0,1
    4dd8:	00001097          	auipc	ra,0x1
    4ddc:	e3c080e7          	jalr	-452(ra) # 5c14 <exit>
      exit(xstatus);
    4de0:	8556                	mv	a0,s5
    4de2:	00001097          	auipc	ra,0x1
    4de6:	e32080e7          	jalr	-462(ra) # 5c14 <exit>
          printf("wrong char\n", s);
    4dea:	85e6                	mv	a1,s9
    4dec:	00003517          	auipc	a0,0x3
    4df0:	0e450513          	add	a0,a0,228 # 7ed0 <malloc+0x1e7c>
    4df4:	00001097          	auipc	ra,0x1
    4df8:	1a8080e7          	jalr	424(ra) # 5f9c <printf>
          exit(1);
    4dfc:	4505                	li	a0,1
    4dfe:	00001097          	auipc	ra,0x1
    4e02:	e16080e7          	jalr	-490(ra) # 5c14 <exit>
      total += n;
    4e06:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e0a:	660d                	lui	a2,0x3
    4e0c:	85d2                	mv	a1,s4
    4e0e:	854e                	mv	a0,s3
    4e10:	00001097          	auipc	ra,0x1
    4e14:	e1c080e7          	jalr	-484(ra) # 5c2c <read>
    4e18:	02a05063          	blez	a0,4e38 <fourfiles+0x1b8>
    4e1c:	00008797          	auipc	a5,0x8
    4e20:	e5c78793          	add	a5,a5,-420 # cc78 <buf>
    4e24:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    4e28:	0007c703          	lbu	a4,0(a5)
    4e2c:	fa971fe3          	bne	a4,s1,4dea <fourfiles+0x16a>
      for(j = 0; j < n; j++){
    4e30:	0785                	add	a5,a5,1
    4e32:	fed79be3          	bne	a5,a3,4e28 <fourfiles+0x1a8>
    4e36:	bfc1                	j	4e06 <fourfiles+0x186>
    close(fd);
    4e38:	854e                	mv	a0,s3
    4e3a:	00001097          	auipc	ra,0x1
    4e3e:	e02080e7          	jalr	-510(ra) # 5c3c <close>
    if(total != N*SZ){
    4e42:	03a91863          	bne	s2,s10,4e72 <fourfiles+0x1f2>
    unlink(fname);
    4e46:	8562                	mv	a0,s8
    4e48:	00001097          	auipc	ra,0x1
    4e4c:	e1c080e7          	jalr	-484(ra) # 5c64 <unlink>
  for(i = 0; i < NCHILD; i++){
    4e50:	0ba1                	add	s7,s7,8
    4e52:	2b05                	addw	s6,s6,1
    4e54:	03bb0d63          	beq	s6,s11,4e8e <fourfiles+0x20e>
    fname = names[i];
    4e58:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    4e5c:	4581                	li	a1,0
    4e5e:	8562                	mv	a0,s8
    4e60:	00001097          	auipc	ra,0x1
    4e64:	df4080e7          	jalr	-524(ra) # 5c54 <open>
    4e68:	89aa                	mv	s3,a0
    total = 0;
    4e6a:	8956                	mv	s2,s5
        if(buf[j] != '0'+i){
    4e6c:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    4e70:	bf69                	j	4e0a <fourfiles+0x18a>
      printf("wrong length %d\n", total);
    4e72:	85ca                	mv	a1,s2
    4e74:	00003517          	auipc	a0,0x3
    4e78:	06c50513          	add	a0,a0,108 # 7ee0 <malloc+0x1e8c>
    4e7c:	00001097          	auipc	ra,0x1
    4e80:	120080e7          	jalr	288(ra) # 5f9c <printf>
      exit(1);
    4e84:	4505                	li	a0,1
    4e86:	00001097          	auipc	ra,0x1
    4e8a:	d8e080e7          	jalr	-626(ra) # 5c14 <exit>
}
    4e8e:	60ea                	ld	ra,152(sp)
    4e90:	644a                	ld	s0,144(sp)
    4e92:	64aa                	ld	s1,136(sp)
    4e94:	690a                	ld	s2,128(sp)
    4e96:	79e6                	ld	s3,120(sp)
    4e98:	7a46                	ld	s4,112(sp)
    4e9a:	7aa6                	ld	s5,104(sp)
    4e9c:	7b06                	ld	s6,96(sp)
    4e9e:	6be6                	ld	s7,88(sp)
    4ea0:	6c46                	ld	s8,80(sp)
    4ea2:	6ca6                	ld	s9,72(sp)
    4ea4:	6d06                	ld	s10,64(sp)
    4ea6:	7de2                	ld	s11,56(sp)
    4ea8:	610d                	add	sp,sp,160
    4eaa:	8082                	ret

0000000000004eac <concreate>:
{
    4eac:	7135                	add	sp,sp,-160
    4eae:	ed06                	sd	ra,152(sp)
    4eb0:	e922                	sd	s0,144(sp)
    4eb2:	e526                	sd	s1,136(sp)
    4eb4:	e14a                	sd	s2,128(sp)
    4eb6:	fcce                	sd	s3,120(sp)
    4eb8:	f8d2                	sd	s4,112(sp)
    4eba:	f4d6                	sd	s5,104(sp)
    4ebc:	f0da                	sd	s6,96(sp)
    4ebe:	ecde                	sd	s7,88(sp)
    4ec0:	1100                	add	s0,sp,160
    4ec2:	89aa                	mv	s3,a0
  file[0] = 'C';
    4ec4:	04300793          	li	a5,67
    4ec8:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    4ecc:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    4ed0:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    4ed2:	4b0d                	li	s6,3
    4ed4:	4a85                	li	s5,1
      link("C0", file);
    4ed6:	00003b97          	auipc	s7,0x3
    4eda:	022b8b93          	add	s7,s7,34 # 7ef8 <malloc+0x1ea4>
  for(i = 0; i < N; i++){
    4ede:	02800a13          	li	s4,40
    4ee2:	acc9                	j	51b4 <concreate+0x308>
      link("C0", file);
    4ee4:	fa840593          	add	a1,s0,-88
    4ee8:	855e                	mv	a0,s7
    4eea:	00001097          	auipc	ra,0x1
    4eee:	d8a080e7          	jalr	-630(ra) # 5c74 <link>
    if(pid == 0) {
    4ef2:	a465                	j	519a <concreate+0x2ee>
    } else if(pid == 0 && (i % 5) == 1){
    4ef4:	4795                	li	a5,5
    4ef6:	02f9693b          	remw	s2,s2,a5
    4efa:	4785                	li	a5,1
    4efc:	02f90b63          	beq	s2,a5,4f32 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    4f00:	20200593          	li	a1,514
    4f04:	fa840513          	add	a0,s0,-88
    4f08:	00001097          	auipc	ra,0x1
    4f0c:	d4c080e7          	jalr	-692(ra) # 5c54 <open>
      if(fd < 0){
    4f10:	26055c63          	bgez	a0,5188 <concreate+0x2dc>
        printf("concreate create %s failed\n", file);
    4f14:	fa840593          	add	a1,s0,-88
    4f18:	00003517          	auipc	a0,0x3
    4f1c:	fe850513          	add	a0,a0,-24 # 7f00 <malloc+0x1eac>
    4f20:	00001097          	auipc	ra,0x1
    4f24:	07c080e7          	jalr	124(ra) # 5f9c <printf>
        exit(1);
    4f28:	4505                	li	a0,1
    4f2a:	00001097          	auipc	ra,0x1
    4f2e:	cea080e7          	jalr	-790(ra) # 5c14 <exit>
      link("C0", file);
    4f32:	fa840593          	add	a1,s0,-88
    4f36:	00003517          	auipc	a0,0x3
    4f3a:	fc250513          	add	a0,a0,-62 # 7ef8 <malloc+0x1ea4>
    4f3e:	00001097          	auipc	ra,0x1
    4f42:	d36080e7          	jalr	-714(ra) # 5c74 <link>
      exit(0);
    4f46:	4501                	li	a0,0
    4f48:	00001097          	auipc	ra,0x1
    4f4c:	ccc080e7          	jalr	-820(ra) # 5c14 <exit>
        exit(1);
    4f50:	4505                	li	a0,1
    4f52:	00001097          	auipc	ra,0x1
    4f56:	cc2080e7          	jalr	-830(ra) # 5c14 <exit>
  memset(fa, 0, sizeof(fa));
    4f5a:	02800613          	li	a2,40
    4f5e:	4581                	li	a1,0
    4f60:	f8040513          	add	a0,s0,-128
    4f64:	00001097          	auipc	ra,0x1
    4f68:	a9e080e7          	jalr	-1378(ra) # 5a02 <memset>
  fd = open(".", 0);
    4f6c:	4581                	li	a1,0
    4f6e:	00002517          	auipc	a0,0x2
    4f72:	91250513          	add	a0,a0,-1774 # 6880 <malloc+0x82c>
    4f76:	00001097          	auipc	ra,0x1
    4f7a:	cde080e7          	jalr	-802(ra) # 5c54 <open>
    4f7e:	892a                	mv	s2,a0
  n = 0;
    4f80:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4f82:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    4f86:	02700b13          	li	s6,39
      fa[i] = 1;
    4f8a:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    4f8c:	4641                	li	a2,16
    4f8e:	f7040593          	add	a1,s0,-144
    4f92:	854a                	mv	a0,s2
    4f94:	00001097          	auipc	ra,0x1
    4f98:	c98080e7          	jalr	-872(ra) # 5c2c <read>
    4f9c:	08a05263          	blez	a0,5020 <concreate+0x174>
    if(de.inum == 0)
    4fa0:	f7045783          	lhu	a5,-144(s0)
    4fa4:	d7e5                	beqz	a5,4f8c <concreate+0xe0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4fa6:	f7244783          	lbu	a5,-142(s0)
    4faa:	ff4791e3          	bne	a5,s4,4f8c <concreate+0xe0>
    4fae:	f7444783          	lbu	a5,-140(s0)
    4fb2:	ffe9                	bnez	a5,4f8c <concreate+0xe0>
      i = de.name[1] - '0';
    4fb4:	f7344783          	lbu	a5,-141(s0)
    4fb8:	fd07879b          	addw	a5,a5,-48
    4fbc:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    4fc0:	02eb6063          	bltu	s6,a4,4fe0 <concreate+0x134>
      if(fa[i]){
    4fc4:	fb070793          	add	a5,a4,-80 # fb0 <linktest+0xbc>
    4fc8:	97a2                	add	a5,a5,s0
    4fca:	fd07c783          	lbu	a5,-48(a5)
    4fce:	eb8d                	bnez	a5,5000 <concreate+0x154>
      fa[i] = 1;
    4fd0:	fb070793          	add	a5,a4,-80
    4fd4:	00878733          	add	a4,a5,s0
    4fd8:	fd770823          	sb	s7,-48(a4)
      n++;
    4fdc:	2a85                	addw	s5,s5,1
    4fde:	b77d                	j	4f8c <concreate+0xe0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4fe0:	f7240613          	add	a2,s0,-142
    4fe4:	85ce                	mv	a1,s3
    4fe6:	00003517          	auipc	a0,0x3
    4fea:	f3a50513          	add	a0,a0,-198 # 7f20 <malloc+0x1ecc>
    4fee:	00001097          	auipc	ra,0x1
    4ff2:	fae080e7          	jalr	-82(ra) # 5f9c <printf>
        exit(1);
    4ff6:	4505                	li	a0,1
    4ff8:	00001097          	auipc	ra,0x1
    4ffc:	c1c080e7          	jalr	-996(ra) # 5c14 <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    5000:	f7240613          	add	a2,s0,-142
    5004:	85ce                	mv	a1,s3
    5006:	00003517          	auipc	a0,0x3
    500a:	f3a50513          	add	a0,a0,-198 # 7f40 <malloc+0x1eec>
    500e:	00001097          	auipc	ra,0x1
    5012:	f8e080e7          	jalr	-114(ra) # 5f9c <printf>
        exit(1);
    5016:	4505                	li	a0,1
    5018:	00001097          	auipc	ra,0x1
    501c:	bfc080e7          	jalr	-1028(ra) # 5c14 <exit>
  close(fd);
    5020:	854a                	mv	a0,s2
    5022:	00001097          	auipc	ra,0x1
    5026:	c1a080e7          	jalr	-998(ra) # 5c3c <close>
  if(n != N){
    502a:	02800793          	li	a5,40
    502e:	00fa9763          	bne	s5,a5,503c <concreate+0x190>
    if(((i % 3) == 0 && pid == 0) ||
    5032:	4a8d                	li	s5,3
    5034:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    5036:	02800a13          	li	s4,40
    503a:	a8c9                	j	510c <concreate+0x260>
    printf("%s: concreate not enough files in directory listing\n", s);
    503c:	85ce                	mv	a1,s3
    503e:	00003517          	auipc	a0,0x3
    5042:	f2a50513          	add	a0,a0,-214 # 7f68 <malloc+0x1f14>
    5046:	00001097          	auipc	ra,0x1
    504a:	f56080e7          	jalr	-170(ra) # 5f9c <printf>
    exit(1);
    504e:	4505                	li	a0,1
    5050:	00001097          	auipc	ra,0x1
    5054:	bc4080e7          	jalr	-1084(ra) # 5c14 <exit>
      printf("%s: fork failed\n", s);
    5058:	85ce                	mv	a1,s3
    505a:	00002517          	auipc	a0,0x2
    505e:	9c650513          	add	a0,a0,-1594 # 6a20 <malloc+0x9cc>
    5062:	00001097          	auipc	ra,0x1
    5066:	f3a080e7          	jalr	-198(ra) # 5f9c <printf>
      exit(1);
    506a:	4505                	li	a0,1
    506c:	00001097          	auipc	ra,0x1
    5070:	ba8080e7          	jalr	-1112(ra) # 5c14 <exit>
      close(open(file, 0));
    5074:	4581                	li	a1,0
    5076:	fa840513          	add	a0,s0,-88
    507a:	00001097          	auipc	ra,0x1
    507e:	bda080e7          	jalr	-1062(ra) # 5c54 <open>
    5082:	00001097          	auipc	ra,0x1
    5086:	bba080e7          	jalr	-1094(ra) # 5c3c <close>
      close(open(file, 0));
    508a:	4581                	li	a1,0
    508c:	fa840513          	add	a0,s0,-88
    5090:	00001097          	auipc	ra,0x1
    5094:	bc4080e7          	jalr	-1084(ra) # 5c54 <open>
    5098:	00001097          	auipc	ra,0x1
    509c:	ba4080e7          	jalr	-1116(ra) # 5c3c <close>
      close(open(file, 0));
    50a0:	4581                	li	a1,0
    50a2:	fa840513          	add	a0,s0,-88
    50a6:	00001097          	auipc	ra,0x1
    50aa:	bae080e7          	jalr	-1106(ra) # 5c54 <open>
    50ae:	00001097          	auipc	ra,0x1
    50b2:	b8e080e7          	jalr	-1138(ra) # 5c3c <close>
      close(open(file, 0));
    50b6:	4581                	li	a1,0
    50b8:	fa840513          	add	a0,s0,-88
    50bc:	00001097          	auipc	ra,0x1
    50c0:	b98080e7          	jalr	-1128(ra) # 5c54 <open>
    50c4:	00001097          	auipc	ra,0x1
    50c8:	b78080e7          	jalr	-1160(ra) # 5c3c <close>
      close(open(file, 0));
    50cc:	4581                	li	a1,0
    50ce:	fa840513          	add	a0,s0,-88
    50d2:	00001097          	auipc	ra,0x1
    50d6:	b82080e7          	jalr	-1150(ra) # 5c54 <open>
    50da:	00001097          	auipc	ra,0x1
    50de:	b62080e7          	jalr	-1182(ra) # 5c3c <close>
      close(open(file, 0));
    50e2:	4581                	li	a1,0
    50e4:	fa840513          	add	a0,s0,-88
    50e8:	00001097          	auipc	ra,0x1
    50ec:	b6c080e7          	jalr	-1172(ra) # 5c54 <open>
    50f0:	00001097          	auipc	ra,0x1
    50f4:	b4c080e7          	jalr	-1204(ra) # 5c3c <close>
    if(pid == 0)
    50f8:	08090363          	beqz	s2,517e <concreate+0x2d2>
      wait(0);
    50fc:	4501                	li	a0,0
    50fe:	00001097          	auipc	ra,0x1
    5102:	b1e080e7          	jalr	-1250(ra) # 5c1c <wait>
  for(i = 0; i < N; i++){
    5106:	2485                	addw	s1,s1,1
    5108:	0f448563          	beq	s1,s4,51f2 <concreate+0x346>
    file[1] = '0' + i;
    510c:	0304879b          	addw	a5,s1,48
    5110:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    5114:	00001097          	auipc	ra,0x1
    5118:	af8080e7          	jalr	-1288(ra) # 5c0c <fork>
    511c:	892a                	mv	s2,a0
    if(pid < 0){
    511e:	f2054de3          	bltz	a0,5058 <concreate+0x1ac>
    if(((i % 3) == 0 && pid == 0) ||
    5122:	0354e73b          	remw	a4,s1,s5
    5126:	00a767b3          	or	a5,a4,a0
    512a:	2781                	sext.w	a5,a5
    512c:	d7a1                	beqz	a5,5074 <concreate+0x1c8>
    512e:	01671363          	bne	a4,s6,5134 <concreate+0x288>
       ((i % 3) == 1 && pid != 0)){
    5132:	f129                	bnez	a0,5074 <concreate+0x1c8>
      unlink(file);
    5134:	fa840513          	add	a0,s0,-88
    5138:	00001097          	auipc	ra,0x1
    513c:	b2c080e7          	jalr	-1236(ra) # 5c64 <unlink>
      unlink(file);
    5140:	fa840513          	add	a0,s0,-88
    5144:	00001097          	auipc	ra,0x1
    5148:	b20080e7          	jalr	-1248(ra) # 5c64 <unlink>
      unlink(file);
    514c:	fa840513          	add	a0,s0,-88
    5150:	00001097          	auipc	ra,0x1
    5154:	b14080e7          	jalr	-1260(ra) # 5c64 <unlink>
      unlink(file);
    5158:	fa840513          	add	a0,s0,-88
    515c:	00001097          	auipc	ra,0x1
    5160:	b08080e7          	jalr	-1272(ra) # 5c64 <unlink>
      unlink(file);
    5164:	fa840513          	add	a0,s0,-88
    5168:	00001097          	auipc	ra,0x1
    516c:	afc080e7          	jalr	-1284(ra) # 5c64 <unlink>
      unlink(file);
    5170:	fa840513          	add	a0,s0,-88
    5174:	00001097          	auipc	ra,0x1
    5178:	af0080e7          	jalr	-1296(ra) # 5c64 <unlink>
    517c:	bfb5                	j	50f8 <concreate+0x24c>
      exit(0);
    517e:	4501                	li	a0,0
    5180:	00001097          	auipc	ra,0x1
    5184:	a94080e7          	jalr	-1388(ra) # 5c14 <exit>
      close(fd);
    5188:	00001097          	auipc	ra,0x1
    518c:	ab4080e7          	jalr	-1356(ra) # 5c3c <close>
    if(pid == 0) {
    5190:	bb5d                	j	4f46 <concreate+0x9a>
      close(fd);
    5192:	00001097          	auipc	ra,0x1
    5196:	aaa080e7          	jalr	-1366(ra) # 5c3c <close>
      wait(&xstatus);
    519a:	f6c40513          	add	a0,s0,-148
    519e:	00001097          	auipc	ra,0x1
    51a2:	a7e080e7          	jalr	-1410(ra) # 5c1c <wait>
      if(xstatus != 0)
    51a6:	f6c42483          	lw	s1,-148(s0)
    51aa:	da0493e3          	bnez	s1,4f50 <concreate+0xa4>
  for(i = 0; i < N; i++){
    51ae:	2905                	addw	s2,s2,1
    51b0:	db4905e3          	beq	s2,s4,4f5a <concreate+0xae>
    file[1] = '0' + i;
    51b4:	0309079b          	addw	a5,s2,48
    51b8:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    51bc:	fa840513          	add	a0,s0,-88
    51c0:	00001097          	auipc	ra,0x1
    51c4:	aa4080e7          	jalr	-1372(ra) # 5c64 <unlink>
    pid = fork();
    51c8:	00001097          	auipc	ra,0x1
    51cc:	a44080e7          	jalr	-1468(ra) # 5c0c <fork>
    if(pid && (i % 3) == 1){
    51d0:	d20502e3          	beqz	a0,4ef4 <concreate+0x48>
    51d4:	036967bb          	remw	a5,s2,s6
    51d8:	d15786e3          	beq	a5,s5,4ee4 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    51dc:	20200593          	li	a1,514
    51e0:	fa840513          	add	a0,s0,-88
    51e4:	00001097          	auipc	ra,0x1
    51e8:	a70080e7          	jalr	-1424(ra) # 5c54 <open>
      if(fd < 0){
    51ec:	fa0553e3          	bgez	a0,5192 <concreate+0x2e6>
    51f0:	b315                	j	4f14 <concreate+0x68>
}
    51f2:	60ea                	ld	ra,152(sp)
    51f4:	644a                	ld	s0,144(sp)
    51f6:	64aa                	ld	s1,136(sp)
    51f8:	690a                	ld	s2,128(sp)
    51fa:	79e6                	ld	s3,120(sp)
    51fc:	7a46                	ld	s4,112(sp)
    51fe:	7aa6                	ld	s5,104(sp)
    5200:	7b06                	ld	s6,96(sp)
    5202:	6be6                	ld	s7,88(sp)
    5204:	610d                	add	sp,sp,160
    5206:	8082                	ret

0000000000005208 <bigfile>:
{
    5208:	7139                	add	sp,sp,-64
    520a:	fc06                	sd	ra,56(sp)
    520c:	f822                	sd	s0,48(sp)
    520e:	f426                	sd	s1,40(sp)
    5210:	f04a                	sd	s2,32(sp)
    5212:	ec4e                	sd	s3,24(sp)
    5214:	e852                	sd	s4,16(sp)
    5216:	e456                	sd	s5,8(sp)
    5218:	0080                	add	s0,sp,64
    521a:	8aaa                	mv	s5,a0
  unlink("bigfile.dat");
    521c:	00003517          	auipc	a0,0x3
    5220:	d8450513          	add	a0,a0,-636 # 7fa0 <malloc+0x1f4c>
    5224:	00001097          	auipc	ra,0x1
    5228:	a40080e7          	jalr	-1472(ra) # 5c64 <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    522c:	20200593          	li	a1,514
    5230:	00003517          	auipc	a0,0x3
    5234:	d7050513          	add	a0,a0,-656 # 7fa0 <malloc+0x1f4c>
    5238:	00001097          	auipc	ra,0x1
    523c:	a1c080e7          	jalr	-1508(ra) # 5c54 <open>
    5240:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    5242:	4481                	li	s1,0
    memset(buf, i, SZ);
    5244:	00008917          	auipc	s2,0x8
    5248:	a3490913          	add	s2,s2,-1484 # cc78 <buf>
  for(i = 0; i < N; i++){
    524c:	4a51                	li	s4,20
  if(fd < 0){
    524e:	0a054063          	bltz	a0,52ee <bigfile+0xe6>
    memset(buf, i, SZ);
    5252:	25800613          	li	a2,600
    5256:	85a6                	mv	a1,s1
    5258:	854a                	mv	a0,s2
    525a:	00000097          	auipc	ra,0x0
    525e:	7a8080e7          	jalr	1960(ra) # 5a02 <memset>
    if(write(fd, buf, SZ) != SZ){
    5262:	25800613          	li	a2,600
    5266:	85ca                	mv	a1,s2
    5268:	854e                	mv	a0,s3
    526a:	00001097          	auipc	ra,0x1
    526e:	9ca080e7          	jalr	-1590(ra) # 5c34 <write>
    5272:	25800793          	li	a5,600
    5276:	08f51a63          	bne	a0,a5,530a <bigfile+0x102>
  for(i = 0; i < N; i++){
    527a:	2485                	addw	s1,s1,1
    527c:	fd449be3          	bne	s1,s4,5252 <bigfile+0x4a>
  close(fd);
    5280:	854e                	mv	a0,s3
    5282:	00001097          	auipc	ra,0x1
    5286:	9ba080e7          	jalr	-1606(ra) # 5c3c <close>
  fd = open("bigfile.dat", 0);
    528a:	4581                	li	a1,0
    528c:	00003517          	auipc	a0,0x3
    5290:	d1450513          	add	a0,a0,-748 # 7fa0 <malloc+0x1f4c>
    5294:	00001097          	auipc	ra,0x1
    5298:	9c0080e7          	jalr	-1600(ra) # 5c54 <open>
    529c:	8a2a                	mv	s4,a0
  total = 0;
    529e:	4981                	li	s3,0
  for(i = 0; ; i++){
    52a0:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    52a2:	00008917          	auipc	s2,0x8
    52a6:	9d690913          	add	s2,s2,-1578 # cc78 <buf>
  if(fd < 0){
    52aa:	06054e63          	bltz	a0,5326 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    52ae:	12c00613          	li	a2,300
    52b2:	85ca                	mv	a1,s2
    52b4:	8552                	mv	a0,s4
    52b6:	00001097          	auipc	ra,0x1
    52ba:	976080e7          	jalr	-1674(ra) # 5c2c <read>
    if(cc < 0){
    52be:	08054263          	bltz	a0,5342 <bigfile+0x13a>
    if(cc == 0)
    52c2:	c971                	beqz	a0,5396 <bigfile+0x18e>
    if(cc != SZ/2){
    52c4:	12c00793          	li	a5,300
    52c8:	08f51b63          	bne	a0,a5,535e <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    52cc:	01f4d79b          	srlw	a5,s1,0x1f
    52d0:	9fa5                	addw	a5,a5,s1
    52d2:	4017d79b          	sraw	a5,a5,0x1
    52d6:	00094703          	lbu	a4,0(s2)
    52da:	0af71063          	bne	a4,a5,537a <bigfile+0x172>
    52de:	12b94703          	lbu	a4,299(s2)
    52e2:	08f71c63          	bne	a4,a5,537a <bigfile+0x172>
    total += cc;
    52e6:	12c9899b          	addw	s3,s3,300
  for(i = 0; ; i++){
    52ea:	2485                	addw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    52ec:	b7c9                	j	52ae <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    52ee:	85d6                	mv	a1,s5
    52f0:	00003517          	auipc	a0,0x3
    52f4:	cc050513          	add	a0,a0,-832 # 7fb0 <malloc+0x1f5c>
    52f8:	00001097          	auipc	ra,0x1
    52fc:	ca4080e7          	jalr	-860(ra) # 5f9c <printf>
    exit(1);
    5300:	4505                	li	a0,1
    5302:	00001097          	auipc	ra,0x1
    5306:	912080e7          	jalr	-1774(ra) # 5c14 <exit>
      printf("%s: write bigfile failed\n", s);
    530a:	85d6                	mv	a1,s5
    530c:	00003517          	auipc	a0,0x3
    5310:	cc450513          	add	a0,a0,-828 # 7fd0 <malloc+0x1f7c>
    5314:	00001097          	auipc	ra,0x1
    5318:	c88080e7          	jalr	-888(ra) # 5f9c <printf>
      exit(1);
    531c:	4505                	li	a0,1
    531e:	00001097          	auipc	ra,0x1
    5322:	8f6080e7          	jalr	-1802(ra) # 5c14 <exit>
    printf("%s: cannot open bigfile\n", s);
    5326:	85d6                	mv	a1,s5
    5328:	00003517          	auipc	a0,0x3
    532c:	cc850513          	add	a0,a0,-824 # 7ff0 <malloc+0x1f9c>
    5330:	00001097          	auipc	ra,0x1
    5334:	c6c080e7          	jalr	-916(ra) # 5f9c <printf>
    exit(1);
    5338:	4505                	li	a0,1
    533a:	00001097          	auipc	ra,0x1
    533e:	8da080e7          	jalr	-1830(ra) # 5c14 <exit>
      printf("%s: read bigfile failed\n", s);
    5342:	85d6                	mv	a1,s5
    5344:	00003517          	auipc	a0,0x3
    5348:	ccc50513          	add	a0,a0,-820 # 8010 <malloc+0x1fbc>
    534c:	00001097          	auipc	ra,0x1
    5350:	c50080e7          	jalr	-944(ra) # 5f9c <printf>
      exit(1);
    5354:	4505                	li	a0,1
    5356:	00001097          	auipc	ra,0x1
    535a:	8be080e7          	jalr	-1858(ra) # 5c14 <exit>
      printf("%s: short read bigfile\n", s);
    535e:	85d6                	mv	a1,s5
    5360:	00003517          	auipc	a0,0x3
    5364:	cd050513          	add	a0,a0,-816 # 8030 <malloc+0x1fdc>
    5368:	00001097          	auipc	ra,0x1
    536c:	c34080e7          	jalr	-972(ra) # 5f9c <printf>
      exit(1);
    5370:	4505                	li	a0,1
    5372:	00001097          	auipc	ra,0x1
    5376:	8a2080e7          	jalr	-1886(ra) # 5c14 <exit>
      printf("%s: read bigfile wrong data\n", s);
    537a:	85d6                	mv	a1,s5
    537c:	00003517          	auipc	a0,0x3
    5380:	ccc50513          	add	a0,a0,-820 # 8048 <malloc+0x1ff4>
    5384:	00001097          	auipc	ra,0x1
    5388:	c18080e7          	jalr	-1000(ra) # 5f9c <printf>
      exit(1);
    538c:	4505                	li	a0,1
    538e:	00001097          	auipc	ra,0x1
    5392:	886080e7          	jalr	-1914(ra) # 5c14 <exit>
  close(fd);
    5396:	8552                	mv	a0,s4
    5398:	00001097          	auipc	ra,0x1
    539c:	8a4080e7          	jalr	-1884(ra) # 5c3c <close>
  if(total != N*SZ){
    53a0:	678d                	lui	a5,0x3
    53a2:	ee078793          	add	a5,a5,-288 # 2ee0 <sbrklast+0x3a>
    53a6:	02f99363          	bne	s3,a5,53cc <bigfile+0x1c4>
  unlink("bigfile.dat");
    53aa:	00003517          	auipc	a0,0x3
    53ae:	bf650513          	add	a0,a0,-1034 # 7fa0 <malloc+0x1f4c>
    53b2:	00001097          	auipc	ra,0x1
    53b6:	8b2080e7          	jalr	-1870(ra) # 5c64 <unlink>
}
    53ba:	70e2                	ld	ra,56(sp)
    53bc:	7442                	ld	s0,48(sp)
    53be:	74a2                	ld	s1,40(sp)
    53c0:	7902                	ld	s2,32(sp)
    53c2:	69e2                	ld	s3,24(sp)
    53c4:	6a42                	ld	s4,16(sp)
    53c6:	6aa2                	ld	s5,8(sp)
    53c8:	6121                	add	sp,sp,64
    53ca:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    53cc:	85d6                	mv	a1,s5
    53ce:	00003517          	auipc	a0,0x3
    53d2:	c9a50513          	add	a0,a0,-870 # 8068 <malloc+0x2014>
    53d6:	00001097          	auipc	ra,0x1
    53da:	bc6080e7          	jalr	-1082(ra) # 5f9c <printf>
    exit(1);
    53de:	4505                	li	a0,1
    53e0:	00001097          	auipc	ra,0x1
    53e4:	834080e7          	jalr	-1996(ra) # 5c14 <exit>

00000000000053e8 <fsfull>:
{
    53e8:	7135                	add	sp,sp,-160
    53ea:	ed06                	sd	ra,152(sp)
    53ec:	e922                	sd	s0,144(sp)
    53ee:	e526                	sd	s1,136(sp)
    53f0:	e14a                	sd	s2,128(sp)
    53f2:	fcce                	sd	s3,120(sp)
    53f4:	f8d2                	sd	s4,112(sp)
    53f6:	f4d6                	sd	s5,104(sp)
    53f8:	f0da                	sd	s6,96(sp)
    53fa:	ecde                	sd	s7,88(sp)
    53fc:	e8e2                	sd	s8,80(sp)
    53fe:	e4e6                	sd	s9,72(sp)
    5400:	e0ea                	sd	s10,64(sp)
    5402:	1100                	add	s0,sp,160
  printf("fsfull test\n");
    5404:	00003517          	auipc	a0,0x3
    5408:	c8450513          	add	a0,a0,-892 # 8088 <malloc+0x2034>
    540c:	00001097          	auipc	ra,0x1
    5410:	b90080e7          	jalr	-1136(ra) # 5f9c <printf>
  for(nfiles = 0; ; nfiles++){
    5414:	4481                	li	s1,0
    name[0] = 'f';
    5416:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    541a:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    541e:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    5422:	4b29                	li	s6,10
    printf("writing %s\n", name);
    5424:	00003c97          	auipc	s9,0x3
    5428:	c74c8c93          	add	s9,s9,-908 # 8098 <malloc+0x2044>
    name[0] = 'f';
    542c:	f7a40023          	sb	s10,-160(s0)
    name[1] = '0' + nfiles / 1000;
    5430:	0384c7bb          	divw	a5,s1,s8
    5434:	0307879b          	addw	a5,a5,48
    5438:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    543c:	0384e7bb          	remw	a5,s1,s8
    5440:	0377c7bb          	divw	a5,a5,s7
    5444:	0307879b          	addw	a5,a5,48
    5448:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    544c:	0374e7bb          	remw	a5,s1,s7
    5450:	0367c7bb          	divw	a5,a5,s6
    5454:	0307879b          	addw	a5,a5,48
    5458:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    545c:	0364e7bb          	remw	a5,s1,s6
    5460:	0307879b          	addw	a5,a5,48
    5464:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    5468:	f60402a3          	sb	zero,-155(s0)
    printf("writing %s\n", name);
    546c:	f6040593          	add	a1,s0,-160
    5470:	8566                	mv	a0,s9
    5472:	00001097          	auipc	ra,0x1
    5476:	b2a080e7          	jalr	-1238(ra) # 5f9c <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    547a:	20200593          	li	a1,514
    547e:	f6040513          	add	a0,s0,-160
    5482:	00000097          	auipc	ra,0x0
    5486:	7d2080e7          	jalr	2002(ra) # 5c54 <open>
    548a:	892a                	mv	s2,a0
    if(fd < 0){
    548c:	0a055563          	bgez	a0,5536 <fsfull+0x14e>
      printf("open %s failed\n", name);
    5490:	f6040593          	add	a1,s0,-160
    5494:	00003517          	auipc	a0,0x3
    5498:	c1450513          	add	a0,a0,-1004 # 80a8 <malloc+0x2054>
    549c:	00001097          	auipc	ra,0x1
    54a0:	b00080e7          	jalr	-1280(ra) # 5f9c <printf>
  while(nfiles >= 0){
    54a4:	0604c363          	bltz	s1,550a <fsfull+0x122>
    name[0] = 'f';
    54a8:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    54ac:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    54b0:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    54b4:	4929                	li	s2,10
  while(nfiles >= 0){
    54b6:	5afd                	li	s5,-1
    name[0] = 'f';
    54b8:	f7640023          	sb	s6,-160(s0)
    name[1] = '0' + nfiles / 1000;
    54bc:	0344c7bb          	divw	a5,s1,s4
    54c0:	0307879b          	addw	a5,a5,48
    54c4:	f6f400a3          	sb	a5,-159(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    54c8:	0344e7bb          	remw	a5,s1,s4
    54cc:	0337c7bb          	divw	a5,a5,s3
    54d0:	0307879b          	addw	a5,a5,48
    54d4:	f6f40123          	sb	a5,-158(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    54d8:	0334e7bb          	remw	a5,s1,s3
    54dc:	0327c7bb          	divw	a5,a5,s2
    54e0:	0307879b          	addw	a5,a5,48
    54e4:	f6f401a3          	sb	a5,-157(s0)
    name[4] = '0' + (nfiles % 10);
    54e8:	0324e7bb          	remw	a5,s1,s2
    54ec:	0307879b          	addw	a5,a5,48
    54f0:	f6f40223          	sb	a5,-156(s0)
    name[5] = '\0';
    54f4:	f60402a3          	sb	zero,-155(s0)
    unlink(name);
    54f8:	f6040513          	add	a0,s0,-160
    54fc:	00000097          	auipc	ra,0x0
    5500:	768080e7          	jalr	1896(ra) # 5c64 <unlink>
    nfiles--;
    5504:	34fd                	addw	s1,s1,-1
  while(nfiles >= 0){
    5506:	fb5499e3          	bne	s1,s5,54b8 <fsfull+0xd0>
  printf("fsfull test finished\n");
    550a:	00003517          	auipc	a0,0x3
    550e:	bbe50513          	add	a0,a0,-1090 # 80c8 <malloc+0x2074>
    5512:	00001097          	auipc	ra,0x1
    5516:	a8a080e7          	jalr	-1398(ra) # 5f9c <printf>
}
    551a:	60ea                	ld	ra,152(sp)
    551c:	644a                	ld	s0,144(sp)
    551e:	64aa                	ld	s1,136(sp)
    5520:	690a                	ld	s2,128(sp)
    5522:	79e6                	ld	s3,120(sp)
    5524:	7a46                	ld	s4,112(sp)
    5526:	7aa6                	ld	s5,104(sp)
    5528:	7b06                	ld	s6,96(sp)
    552a:	6be6                	ld	s7,88(sp)
    552c:	6c46                	ld	s8,80(sp)
    552e:	6ca6                	ld	s9,72(sp)
    5530:	6d06                	ld	s10,64(sp)
    5532:	610d                	add	sp,sp,160
    5534:	8082                	ret
    int total = 0;
    5536:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    5538:	00007a97          	auipc	s5,0x7
    553c:	740a8a93          	add	s5,s5,1856 # cc78 <buf>
      if(cc < BSIZE)
    5540:	3ff00a13          	li	s4,1023
      int cc = write(fd, buf, BSIZE);
    5544:	40000613          	li	a2,1024
    5548:	85d6                	mv	a1,s5
    554a:	854a                	mv	a0,s2
    554c:	00000097          	auipc	ra,0x0
    5550:	6e8080e7          	jalr	1768(ra) # 5c34 <write>
      if(cc < BSIZE)
    5554:	00aa5563          	bge	s4,a0,555e <fsfull+0x176>
      total += cc;
    5558:	00a989bb          	addw	s3,s3,a0
    while(1){
    555c:	b7e5                	j	5544 <fsfull+0x15c>
    printf("wrote %d bytes\n", total);
    555e:	85ce                	mv	a1,s3
    5560:	00003517          	auipc	a0,0x3
    5564:	b5850513          	add	a0,a0,-1192 # 80b8 <malloc+0x2064>
    5568:	00001097          	auipc	ra,0x1
    556c:	a34080e7          	jalr	-1484(ra) # 5f9c <printf>
    close(fd);
    5570:	854a                	mv	a0,s2
    5572:	00000097          	auipc	ra,0x0
    5576:	6ca080e7          	jalr	1738(ra) # 5c3c <close>
    if(total == 0)
    557a:	f20985e3          	beqz	s3,54a4 <fsfull+0xbc>
  for(nfiles = 0; ; nfiles++){
    557e:	2485                	addw	s1,s1,1
    5580:	b575                	j	542c <fsfull+0x44>

0000000000005582 <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    5582:	7179                	add	sp,sp,-48
    5584:	f406                	sd	ra,40(sp)
    5586:	f022                	sd	s0,32(sp)
    5588:	ec26                	sd	s1,24(sp)
    558a:	e84a                	sd	s2,16(sp)
    558c:	1800                	add	s0,sp,48
    558e:	84aa                	mv	s1,a0
    5590:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    5592:	00003517          	auipc	a0,0x3
    5596:	b4e50513          	add	a0,a0,-1202 # 80e0 <malloc+0x208c>
    559a:	00001097          	auipc	ra,0x1
    559e:	a02080e7          	jalr	-1534(ra) # 5f9c <printf>
  if((pid = fork()) < 0) {
    55a2:	00000097          	auipc	ra,0x0
    55a6:	66a080e7          	jalr	1642(ra) # 5c0c <fork>
    55aa:	02054e63          	bltz	a0,55e6 <run+0x64>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    55ae:	c929                	beqz	a0,5600 <run+0x7e>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    55b0:	fdc40513          	add	a0,s0,-36
    55b4:	00000097          	auipc	ra,0x0
    55b8:	668080e7          	jalr	1640(ra) # 5c1c <wait>
    if(xstatus != 0) 
    55bc:	fdc42783          	lw	a5,-36(s0)
    55c0:	c7b9                	beqz	a5,560e <run+0x8c>
      printf("FAILED\n");
    55c2:	00003517          	auipc	a0,0x3
    55c6:	b4650513          	add	a0,a0,-1210 # 8108 <malloc+0x20b4>
    55ca:	00001097          	auipc	ra,0x1
    55ce:	9d2080e7          	jalr	-1582(ra) # 5f9c <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    55d2:	fdc42503          	lw	a0,-36(s0)
  }
}
    55d6:	00153513          	seqz	a0,a0
    55da:	70a2                	ld	ra,40(sp)
    55dc:	7402                	ld	s0,32(sp)
    55de:	64e2                	ld	s1,24(sp)
    55e0:	6942                	ld	s2,16(sp)
    55e2:	6145                	add	sp,sp,48
    55e4:	8082                	ret
    printf("runtest: fork error\n");
    55e6:	00003517          	auipc	a0,0x3
    55ea:	b0a50513          	add	a0,a0,-1270 # 80f0 <malloc+0x209c>
    55ee:	00001097          	auipc	ra,0x1
    55f2:	9ae080e7          	jalr	-1618(ra) # 5f9c <printf>
    exit(1);
    55f6:	4505                	li	a0,1
    55f8:	00000097          	auipc	ra,0x0
    55fc:	61c080e7          	jalr	1564(ra) # 5c14 <exit>
    f(s);
    5600:	854a                	mv	a0,s2
    5602:	9482                	jalr	s1
    exit(0);
    5604:	4501                	li	a0,0
    5606:	00000097          	auipc	ra,0x0
    560a:	60e080e7          	jalr	1550(ra) # 5c14 <exit>
      printf("OK\n");
    560e:	00003517          	auipc	a0,0x3
    5612:	b0250513          	add	a0,a0,-1278 # 8110 <malloc+0x20bc>
    5616:	00001097          	auipc	ra,0x1
    561a:	986080e7          	jalr	-1658(ra) # 5f9c <printf>
    561e:	bf55                	j	55d2 <run+0x50>

0000000000005620 <runtests>:

int
runtests(struct test *tests, char *justone) {
    5620:	1101                	add	sp,sp,-32
    5622:	ec06                	sd	ra,24(sp)
    5624:	e822                	sd	s0,16(sp)
    5626:	e426                	sd	s1,8(sp)
    5628:	e04a                	sd	s2,0(sp)
    562a:	1000                	add	s0,sp,32
    562c:	84aa                	mv	s1,a0
    562e:	892e                	mv	s2,a1
  for (struct test *t = tests; t->s != 0; t++) {
    5630:	6508                	ld	a0,8(a0)
    5632:	ed09                	bnez	a0,564c <runtests+0x2c>
        printf("SOME TESTS FAILED\n");
        return 1;
      }
    }
  }
  return 0;
    5634:	4501                	li	a0,0
    5636:	a82d                	j	5670 <runtests+0x50>
      if(!run(t->f, t->s)){
    5638:	648c                	ld	a1,8(s1)
    563a:	6088                	ld	a0,0(s1)
    563c:	00000097          	auipc	ra,0x0
    5640:	f46080e7          	jalr	-186(ra) # 5582 <run>
    5644:	cd09                	beqz	a0,565e <runtests+0x3e>
  for (struct test *t = tests; t->s != 0; t++) {
    5646:	04c1                	add	s1,s1,16
    5648:	6488                	ld	a0,8(s1)
    564a:	c11d                	beqz	a0,5670 <runtests+0x50>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    564c:	fe0906e3          	beqz	s2,5638 <runtests+0x18>
    5650:	85ca                	mv	a1,s2
    5652:	00000097          	auipc	ra,0x0
    5656:	35a080e7          	jalr	858(ra) # 59ac <strcmp>
    565a:	f575                	bnez	a0,5646 <runtests+0x26>
    565c:	bff1                	j	5638 <runtests+0x18>
        printf("SOME TESTS FAILED\n");
    565e:	00003517          	auipc	a0,0x3
    5662:	aba50513          	add	a0,a0,-1350 # 8118 <malloc+0x20c4>
    5666:	00001097          	auipc	ra,0x1
    566a:	936080e7          	jalr	-1738(ra) # 5f9c <printf>
        return 1;
    566e:	4505                	li	a0,1
}
    5670:	60e2                	ld	ra,24(sp)
    5672:	6442                	ld	s0,16(sp)
    5674:	64a2                	ld	s1,8(sp)
    5676:	6902                	ld	s2,0(sp)
    5678:	6105                	add	sp,sp,32
    567a:	8082                	ret

000000000000567c <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    567c:	7139                	add	sp,sp,-64
    567e:	fc06                	sd	ra,56(sp)
    5680:	f822                	sd	s0,48(sp)
    5682:	0080                	add	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    5684:	fc840513          	add	a0,s0,-56
    5688:	00000097          	auipc	ra,0x0
    568c:	59c080e7          	jalr	1436(ra) # 5c24 <pipe>
    5690:	06054a63          	bltz	a0,5704 <countfree+0x88>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    5694:	00000097          	auipc	ra,0x0
    5698:	578080e7          	jalr	1400(ra) # 5c0c <fork>

  if(pid < 0){
    569c:	08054463          	bltz	a0,5724 <countfree+0xa8>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    56a0:	e55d                	bnez	a0,574e <countfree+0xd2>
    56a2:	f426                	sd	s1,40(sp)
    56a4:	f04a                	sd	s2,32(sp)
    56a6:	ec4e                	sd	s3,24(sp)
    close(fds[0]);
    56a8:	fc842503          	lw	a0,-56(s0)
    56ac:	00000097          	auipc	ra,0x0
    56b0:	590080e7          	jalr	1424(ra) # 5c3c <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
      if(a == 0xffffffffffffffff){
    56b4:	597d                	li	s2,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    56b6:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    56b8:	00001997          	auipc	s3,0x1
    56bc:	b5098993          	add	s3,s3,-1200 # 6208 <malloc+0x1b4>
      uint64 a = (uint64) sbrk(4096);
    56c0:	6505                	lui	a0,0x1
    56c2:	00000097          	auipc	ra,0x0
    56c6:	5da080e7          	jalr	1498(ra) # 5c9c <sbrk>
      if(a == 0xffffffffffffffff){
    56ca:	07250d63          	beq	a0,s2,5744 <countfree+0xc8>
      *(char *)(a + 4096 - 1) = 1;
    56ce:	6785                	lui	a5,0x1
    56d0:	97aa                	add	a5,a5,a0
    56d2:	fe978fa3          	sb	s1,-1(a5) # fff <linktest+0x10b>
      if(write(fds[1], "x", 1) != 1){
    56d6:	8626                	mv	a2,s1
    56d8:	85ce                	mv	a1,s3
    56da:	fcc42503          	lw	a0,-52(s0)
    56de:	00000097          	auipc	ra,0x0
    56e2:	556080e7          	jalr	1366(ra) # 5c34 <write>
    56e6:	fc950de3          	beq	a0,s1,56c0 <countfree+0x44>
        printf("write() failed in countfree()\n");
    56ea:	00003517          	auipc	a0,0x3
    56ee:	a8650513          	add	a0,a0,-1402 # 8170 <malloc+0x211c>
    56f2:	00001097          	auipc	ra,0x1
    56f6:	8aa080e7          	jalr	-1878(ra) # 5f9c <printf>
        exit(1);
    56fa:	4505                	li	a0,1
    56fc:	00000097          	auipc	ra,0x0
    5700:	518080e7          	jalr	1304(ra) # 5c14 <exit>
    5704:	f426                	sd	s1,40(sp)
    5706:	f04a                	sd	s2,32(sp)
    5708:	ec4e                	sd	s3,24(sp)
    printf("pipe() failed in countfree()\n");
    570a:	00003517          	auipc	a0,0x3
    570e:	a2650513          	add	a0,a0,-1498 # 8130 <malloc+0x20dc>
    5712:	00001097          	auipc	ra,0x1
    5716:	88a080e7          	jalr	-1910(ra) # 5f9c <printf>
    exit(1);
    571a:	4505                	li	a0,1
    571c:	00000097          	auipc	ra,0x0
    5720:	4f8080e7          	jalr	1272(ra) # 5c14 <exit>
    5724:	f426                	sd	s1,40(sp)
    5726:	f04a                	sd	s2,32(sp)
    5728:	ec4e                	sd	s3,24(sp)
    printf("fork failed in countfree()\n");
    572a:	00003517          	auipc	a0,0x3
    572e:	a2650513          	add	a0,a0,-1498 # 8150 <malloc+0x20fc>
    5732:	00001097          	auipc	ra,0x1
    5736:	86a080e7          	jalr	-1942(ra) # 5f9c <printf>
    exit(1);
    573a:	4505                	li	a0,1
    573c:	00000097          	auipc	ra,0x0
    5740:	4d8080e7          	jalr	1240(ra) # 5c14 <exit>
      }
    }

    exit(0);
    5744:	4501                	li	a0,0
    5746:	00000097          	auipc	ra,0x0
    574a:	4ce080e7          	jalr	1230(ra) # 5c14 <exit>
    574e:	f426                	sd	s1,40(sp)
  }

  close(fds[1]);
    5750:	fcc42503          	lw	a0,-52(s0)
    5754:	00000097          	auipc	ra,0x0
    5758:	4e8080e7          	jalr	1256(ra) # 5c3c <close>

  int n = 0;
    575c:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    575e:	4605                	li	a2,1
    5760:	fc740593          	add	a1,s0,-57
    5764:	fc842503          	lw	a0,-56(s0)
    5768:	00000097          	auipc	ra,0x0
    576c:	4c4080e7          	jalr	1220(ra) # 5c2c <read>
    if(cc < 0){
    5770:	00054563          	bltz	a0,577a <countfree+0xfe>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    5774:	c115                	beqz	a0,5798 <countfree+0x11c>
      break;
    n += 1;
    5776:	2485                	addw	s1,s1,1
  while(1){
    5778:	b7dd                	j	575e <countfree+0xe2>
    577a:	f04a                	sd	s2,32(sp)
    577c:	ec4e                	sd	s3,24(sp)
      printf("read() failed in countfree()\n");
    577e:	00003517          	auipc	a0,0x3
    5782:	a1250513          	add	a0,a0,-1518 # 8190 <malloc+0x213c>
    5786:	00001097          	auipc	ra,0x1
    578a:	816080e7          	jalr	-2026(ra) # 5f9c <printf>
      exit(1);
    578e:	4505                	li	a0,1
    5790:	00000097          	auipc	ra,0x0
    5794:	484080e7          	jalr	1156(ra) # 5c14 <exit>
  }

  close(fds[0]);
    5798:	fc842503          	lw	a0,-56(s0)
    579c:	00000097          	auipc	ra,0x0
    57a0:	4a0080e7          	jalr	1184(ra) # 5c3c <close>
  wait((int*)0);
    57a4:	4501                	li	a0,0
    57a6:	00000097          	auipc	ra,0x0
    57aa:	476080e7          	jalr	1142(ra) # 5c1c <wait>
  
  return n;
}
    57ae:	8526                	mv	a0,s1
    57b0:	74a2                	ld	s1,40(sp)
    57b2:	70e2                	ld	ra,56(sp)
    57b4:	7442                	ld	s0,48(sp)
    57b6:	6121                	add	sp,sp,64
    57b8:	8082                	ret

00000000000057ba <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    57ba:	711d                	add	sp,sp,-96
    57bc:	ec86                	sd	ra,88(sp)
    57be:	e8a2                	sd	s0,80(sp)
    57c0:	e4a6                	sd	s1,72(sp)
    57c2:	e0ca                	sd	s2,64(sp)
    57c4:	fc4e                	sd	s3,56(sp)
    57c6:	f852                	sd	s4,48(sp)
    57c8:	f456                	sd	s5,40(sp)
    57ca:	f05a                	sd	s6,32(sp)
    57cc:	ec5e                	sd	s7,24(sp)
    57ce:	e862                	sd	s8,16(sp)
    57d0:	e466                	sd	s9,8(sp)
    57d2:	e06a                	sd	s10,0(sp)
    57d4:	1080                	add	s0,sp,96
    57d6:	8aaa                	mv	s5,a0
    57d8:	89ae                	mv	s3,a1
    57da:	8932                	mv	s2,a2
  do {
    printf("usertests starting\n");
    57dc:	00003b97          	auipc	s7,0x3
    57e0:	9d4b8b93          	add	s7,s7,-1580 # 81b0 <malloc+0x215c>
    int free0 = countfree();
    int free1 = 0;
    if (runtests(quicktests, justone)) {
    57e4:	00004b17          	auipc	s6,0x4
    57e8:	82cb0b13          	add	s6,s6,-2004 # 9010 <quicktests>
      if(continuous != 2) {
    57ec:	4a09                	li	s4,2
      }
    }
    if(!quick) {
      if (justone == 0)
        printf("usertests slow tests starting\n");
      if (runtests(slowtests, justone)) {
    57ee:	00004c17          	auipc	s8,0x4
    57f2:	bf2c0c13          	add	s8,s8,-1038 # 93e0 <slowtests>
        printf("usertests slow tests starting\n");
    57f6:	00003d17          	auipc	s10,0x3
    57fa:	9d2d0d13          	add	s10,s10,-1582 # 81c8 <malloc+0x2174>
          return 1;
        }
      }
    }
    if((free1 = countfree()) < free0) {
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    57fe:	00003c97          	auipc	s9,0x3
    5802:	9eac8c93          	add	s9,s9,-1558 # 81e8 <malloc+0x2194>
    5806:	a839                	j	5824 <drivetests+0x6a>
        printf("usertests slow tests starting\n");
    5808:	856a                	mv	a0,s10
    580a:	00000097          	auipc	ra,0x0
    580e:	792080e7          	jalr	1938(ra) # 5f9c <printf>
    5812:	a081                	j	5852 <drivetests+0x98>
    if((free1 = countfree()) < free0) {
    5814:	00000097          	auipc	ra,0x0
    5818:	e68080e7          	jalr	-408(ra) # 567c <countfree>
    581c:	04954663          	blt	a0,s1,5868 <drivetests+0xae>
      if(continuous != 2) {
        return 1;
      }
    }
  } while(continuous);
    5820:	06098163          	beqz	s3,5882 <drivetests+0xc8>
    printf("usertests starting\n");
    5824:	855e                	mv	a0,s7
    5826:	00000097          	auipc	ra,0x0
    582a:	776080e7          	jalr	1910(ra) # 5f9c <printf>
    int free0 = countfree();
    582e:	00000097          	auipc	ra,0x0
    5832:	e4e080e7          	jalr	-434(ra) # 567c <countfree>
    5836:	84aa                	mv	s1,a0
    if (runtests(quicktests, justone)) {
    5838:	85ca                	mv	a1,s2
    583a:	855a                	mv	a0,s6
    583c:	00000097          	auipc	ra,0x0
    5840:	de4080e7          	jalr	-540(ra) # 5620 <runtests>
    5844:	c119                	beqz	a0,584a <drivetests+0x90>
      if(continuous != 2) {
    5846:	03499c63          	bne	s3,s4,587e <drivetests+0xc4>
    if(!quick) {
    584a:	fc0a95e3          	bnez	s5,5814 <drivetests+0x5a>
      if (justone == 0)
    584e:	fa090de3          	beqz	s2,5808 <drivetests+0x4e>
      if (runtests(slowtests, justone)) {
    5852:	85ca                	mv	a1,s2
    5854:	8562                	mv	a0,s8
    5856:	00000097          	auipc	ra,0x0
    585a:	dca080e7          	jalr	-566(ra) # 5620 <runtests>
    585e:	d95d                	beqz	a0,5814 <drivetests+0x5a>
        if(continuous != 2) {
    5860:	fb498ae3          	beq	s3,s4,5814 <drivetests+0x5a>
          return 1;
    5864:	4505                	li	a0,1
    5866:	a839                	j	5884 <drivetests+0xca>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    5868:	8626                	mv	a2,s1
    586a:	85aa                	mv	a1,a0
    586c:	8566                	mv	a0,s9
    586e:	00000097          	auipc	ra,0x0
    5872:	72e080e7          	jalr	1838(ra) # 5f9c <printf>
      if(continuous != 2) {
    5876:	fb4987e3          	beq	s3,s4,5824 <drivetests+0x6a>
        return 1;
    587a:	4505                	li	a0,1
    587c:	a021                	j	5884 <drivetests+0xca>
        return 1;
    587e:	4505                	li	a0,1
    5880:	a011                	j	5884 <drivetests+0xca>
  return 0;
    5882:	854e                	mv	a0,s3
}
    5884:	60e6                	ld	ra,88(sp)
    5886:	6446                	ld	s0,80(sp)
    5888:	64a6                	ld	s1,72(sp)
    588a:	6906                	ld	s2,64(sp)
    588c:	79e2                	ld	s3,56(sp)
    588e:	7a42                	ld	s4,48(sp)
    5890:	7aa2                	ld	s5,40(sp)
    5892:	7b02                	ld	s6,32(sp)
    5894:	6be2                	ld	s7,24(sp)
    5896:	6c42                	ld	s8,16(sp)
    5898:	6ca2                	ld	s9,8(sp)
    589a:	6d02                	ld	s10,0(sp)
    589c:	6125                	add	sp,sp,96
    589e:	8082                	ret

00000000000058a0 <main>:

int
main(int argc, char *argv[])
{
    58a0:	1101                	add	sp,sp,-32
    58a2:	ec06                	sd	ra,24(sp)
    58a4:	e822                	sd	s0,16(sp)
    58a6:	e426                	sd	s1,8(sp)
    58a8:	e04a                	sd	s2,0(sp)
    58aa:	1000                	add	s0,sp,32
    58ac:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58ae:	4789                	li	a5,2
    58b0:	02f50263          	beq	a0,a5,58d4 <main+0x34>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    58b4:	4785                	li	a5,1
    58b6:	08a7c063          	blt	a5,a0,5936 <main+0x96>
  char *justone = 0;
    58ba:	4601                	li	a2,0
  int quick = 0;
    58bc:	4501                	li	a0,0
  int continuous = 0;
    58be:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    58c0:	00000097          	auipc	ra,0x0
    58c4:	efa080e7          	jalr	-262(ra) # 57ba <drivetests>
    58c8:	c951                	beqz	a0,595c <main+0xbc>
    exit(1);
    58ca:	4505                	li	a0,1
    58cc:	00000097          	auipc	ra,0x0
    58d0:	348080e7          	jalr	840(ra) # 5c14 <exit>
    58d4:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    58d6:	00003597          	auipc	a1,0x3
    58da:	94258593          	add	a1,a1,-1726 # 8218 <malloc+0x21c4>
    58de:	00893503          	ld	a0,8(s2)
    58e2:	00000097          	auipc	ra,0x0
    58e6:	0ca080e7          	jalr	202(ra) # 59ac <strcmp>
    58ea:	85aa                	mv	a1,a0
    58ec:	e501                	bnez	a0,58f4 <main+0x54>
  char *justone = 0;
    58ee:	4601                	li	a2,0
    quick = 1;
    58f0:	4505                	li	a0,1
    58f2:	b7f9                	j	58c0 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    58f4:	00003597          	auipc	a1,0x3
    58f8:	92c58593          	add	a1,a1,-1748 # 8220 <malloc+0x21cc>
    58fc:	00893503          	ld	a0,8(s2)
    5900:	00000097          	auipc	ra,0x0
    5904:	0ac080e7          	jalr	172(ra) # 59ac <strcmp>
    5908:	c521                	beqz	a0,5950 <main+0xb0>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    590a:	00003597          	auipc	a1,0x3
    590e:	96658593          	add	a1,a1,-1690 # 8270 <malloc+0x221c>
    5912:	00893503          	ld	a0,8(s2)
    5916:	00000097          	auipc	ra,0x0
    591a:	096080e7          	jalr	150(ra) # 59ac <strcmp>
    591e:	cd05                	beqz	a0,5956 <main+0xb6>
  } else if(argc == 2 && argv[1][0] != '-'){
    5920:	00893603          	ld	a2,8(s2)
    5924:	00064703          	lbu	a4,0(a2) # 3000 <execout+0x52>
    5928:	02d00793          	li	a5,45
    592c:	00f70563          	beq	a4,a5,5936 <main+0x96>
  int quick = 0;
    5930:	4501                	li	a0,0
  int continuous = 0;
    5932:	4581                	li	a1,0
    5934:	b771                	j	58c0 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    5936:	00003517          	auipc	a0,0x3
    593a:	8f250513          	add	a0,a0,-1806 # 8228 <malloc+0x21d4>
    593e:	00000097          	auipc	ra,0x0
    5942:	65e080e7          	jalr	1630(ra) # 5f9c <printf>
    exit(1);
    5946:	4505                	li	a0,1
    5948:	00000097          	auipc	ra,0x0
    594c:	2cc080e7          	jalr	716(ra) # 5c14 <exit>
  char *justone = 0;
    5950:	4601                	li	a2,0
    continuous = 1;
    5952:	4585                	li	a1,1
    5954:	b7b5                	j	58c0 <main+0x20>
    continuous = 2;
    5956:	85a6                	mv	a1,s1
  char *justone = 0;
    5958:	4601                	li	a2,0
    595a:	b79d                	j	58c0 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    595c:	00003517          	auipc	a0,0x3
    5960:	8fc50513          	add	a0,a0,-1796 # 8258 <malloc+0x2204>
    5964:	00000097          	auipc	ra,0x0
    5968:	638080e7          	jalr	1592(ra) # 5f9c <printf>
  exit(0);
    596c:	4501                	li	a0,0
    596e:	00000097          	auipc	ra,0x0
    5972:	2a6080e7          	jalr	678(ra) # 5c14 <exit>

0000000000005976 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
    5976:	1141                	add	sp,sp,-16
    5978:	e406                	sd	ra,8(sp)
    597a:	e022                	sd	s0,0(sp)
    597c:	0800                	add	s0,sp,16
  extern int main();
  main();
    597e:	00000097          	auipc	ra,0x0
    5982:	f22080e7          	jalr	-222(ra) # 58a0 <main>
  exit(0);
    5986:	4501                	li	a0,0
    5988:	00000097          	auipc	ra,0x0
    598c:	28c080e7          	jalr	652(ra) # 5c14 <exit>

0000000000005990 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    5990:	1141                	add	sp,sp,-16
    5992:	e422                	sd	s0,8(sp)
    5994:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    5996:	87aa                	mv	a5,a0
    5998:	0585                	add	a1,a1,1
    599a:	0785                	add	a5,a5,1
    599c:	fff5c703          	lbu	a4,-1(a1)
    59a0:	fee78fa3          	sb	a4,-1(a5)
    59a4:	fb75                	bnez	a4,5998 <strcpy+0x8>
    ;
  return os;
}
    59a6:	6422                	ld	s0,8(sp)
    59a8:	0141                	add	sp,sp,16
    59aa:	8082                	ret

00000000000059ac <strcmp>:

int
strcmp(const char *p, const char *q)
{
    59ac:	1141                	add	sp,sp,-16
    59ae:	e422                	sd	s0,8(sp)
    59b0:	0800                	add	s0,sp,16
  while(*p && *p == *q)
    59b2:	00054783          	lbu	a5,0(a0)
    59b6:	cb91                	beqz	a5,59ca <strcmp+0x1e>
    59b8:	0005c703          	lbu	a4,0(a1)
    59bc:	00f71763          	bne	a4,a5,59ca <strcmp+0x1e>
    p++, q++;
    59c0:	0505                	add	a0,a0,1
    59c2:	0585                	add	a1,a1,1
  while(*p && *p == *q)
    59c4:	00054783          	lbu	a5,0(a0)
    59c8:	fbe5                	bnez	a5,59b8 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    59ca:	0005c503          	lbu	a0,0(a1)
}
    59ce:	40a7853b          	subw	a0,a5,a0
    59d2:	6422                	ld	s0,8(sp)
    59d4:	0141                	add	sp,sp,16
    59d6:	8082                	ret

00000000000059d8 <strlen>:

uint
strlen(const char *s)
{
    59d8:	1141                	add	sp,sp,-16
    59da:	e422                	sd	s0,8(sp)
    59dc:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    59de:	00054783          	lbu	a5,0(a0)
    59e2:	cf91                	beqz	a5,59fe <strlen+0x26>
    59e4:	0505                	add	a0,a0,1
    59e6:	87aa                	mv	a5,a0
    59e8:	86be                	mv	a3,a5
    59ea:	0785                	add	a5,a5,1
    59ec:	fff7c703          	lbu	a4,-1(a5)
    59f0:	ff65                	bnez	a4,59e8 <strlen+0x10>
    59f2:	40a6853b          	subw	a0,a3,a0
    59f6:	2505                	addw	a0,a0,1
    ;
  return n;
}
    59f8:	6422                	ld	s0,8(sp)
    59fa:	0141                	add	sp,sp,16
    59fc:	8082                	ret
  for(n = 0; s[n]; n++)
    59fe:	4501                	li	a0,0
    5a00:	bfe5                	j	59f8 <strlen+0x20>

0000000000005a02 <memset>:

void*
memset(void *dst, int c, uint n)
{
    5a02:	1141                	add	sp,sp,-16
    5a04:	e422                	sd	s0,8(sp)
    5a06:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    5a08:	ca19                	beqz	a2,5a1e <memset+0x1c>
    5a0a:	87aa                	mv	a5,a0
    5a0c:	1602                	sll	a2,a2,0x20
    5a0e:	9201                	srl	a2,a2,0x20
    5a10:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    5a14:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    5a18:	0785                	add	a5,a5,1
    5a1a:	fee79de3          	bne	a5,a4,5a14 <memset+0x12>
  }
  return dst;
}
    5a1e:	6422                	ld	s0,8(sp)
    5a20:	0141                	add	sp,sp,16
    5a22:	8082                	ret

0000000000005a24 <strchr>:

char*
strchr(const char *s, char c)
{
    5a24:	1141                	add	sp,sp,-16
    5a26:	e422                	sd	s0,8(sp)
    5a28:	0800                	add	s0,sp,16
  for(; *s; s++)
    5a2a:	00054783          	lbu	a5,0(a0)
    5a2e:	cb99                	beqz	a5,5a44 <strchr+0x20>
    if(*s == c)
    5a30:	00f58763          	beq	a1,a5,5a3e <strchr+0x1a>
  for(; *s; s++)
    5a34:	0505                	add	a0,a0,1
    5a36:	00054783          	lbu	a5,0(a0)
    5a3a:	fbfd                	bnez	a5,5a30 <strchr+0xc>
      return (char*)s;
  return 0;
    5a3c:	4501                	li	a0,0
}
    5a3e:	6422                	ld	s0,8(sp)
    5a40:	0141                	add	sp,sp,16
    5a42:	8082                	ret
  return 0;
    5a44:	4501                	li	a0,0
    5a46:	bfe5                	j	5a3e <strchr+0x1a>

0000000000005a48 <gets>:

char*
gets(char *buf, int max)
{
    5a48:	711d                	add	sp,sp,-96
    5a4a:	ec86                	sd	ra,88(sp)
    5a4c:	e8a2                	sd	s0,80(sp)
    5a4e:	e4a6                	sd	s1,72(sp)
    5a50:	e0ca                	sd	s2,64(sp)
    5a52:	fc4e                	sd	s3,56(sp)
    5a54:	f852                	sd	s4,48(sp)
    5a56:	f456                	sd	s5,40(sp)
    5a58:	f05a                	sd	s6,32(sp)
    5a5a:	ec5e                	sd	s7,24(sp)
    5a5c:	1080                	add	s0,sp,96
    5a5e:	8baa                	mv	s7,a0
    5a60:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    5a62:	892a                	mv	s2,a0
    5a64:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    5a66:	4aa9                	li	s5,10
    5a68:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    5a6a:	89a6                	mv	s3,s1
    5a6c:	2485                	addw	s1,s1,1
    5a6e:	0344d863          	bge	s1,s4,5a9e <gets+0x56>
    cc = read(0, &c, 1);
    5a72:	4605                	li	a2,1
    5a74:	faf40593          	add	a1,s0,-81
    5a78:	4501                	li	a0,0
    5a7a:	00000097          	auipc	ra,0x0
    5a7e:	1b2080e7          	jalr	434(ra) # 5c2c <read>
    if(cc < 1)
    5a82:	00a05e63          	blez	a0,5a9e <gets+0x56>
    buf[i++] = c;
    5a86:	faf44783          	lbu	a5,-81(s0)
    5a8a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    5a8e:	01578763          	beq	a5,s5,5a9c <gets+0x54>
    5a92:	0905                	add	s2,s2,1
    5a94:	fd679be3          	bne	a5,s6,5a6a <gets+0x22>
    buf[i++] = c;
    5a98:	89a6                	mv	s3,s1
    5a9a:	a011                	j	5a9e <gets+0x56>
    5a9c:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    5a9e:	99de                	add	s3,s3,s7
    5aa0:	00098023          	sb	zero,0(s3)
  return buf;
}
    5aa4:	855e                	mv	a0,s7
    5aa6:	60e6                	ld	ra,88(sp)
    5aa8:	6446                	ld	s0,80(sp)
    5aaa:	64a6                	ld	s1,72(sp)
    5aac:	6906                	ld	s2,64(sp)
    5aae:	79e2                	ld	s3,56(sp)
    5ab0:	7a42                	ld	s4,48(sp)
    5ab2:	7aa2                	ld	s5,40(sp)
    5ab4:	7b02                	ld	s6,32(sp)
    5ab6:	6be2                	ld	s7,24(sp)
    5ab8:	6125                	add	sp,sp,96
    5aba:	8082                	ret

0000000000005abc <stat>:

int
stat(const char *n, struct stat *st)
{
    5abc:	1101                	add	sp,sp,-32
    5abe:	ec06                	sd	ra,24(sp)
    5ac0:	e822                	sd	s0,16(sp)
    5ac2:	e04a                	sd	s2,0(sp)
    5ac4:	1000                	add	s0,sp,32
    5ac6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    5ac8:	4581                	li	a1,0
    5aca:	00000097          	auipc	ra,0x0
    5ace:	18a080e7          	jalr	394(ra) # 5c54 <open>
  if(fd < 0)
    5ad2:	02054663          	bltz	a0,5afe <stat+0x42>
    5ad6:	e426                	sd	s1,8(sp)
    5ad8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    5ada:	85ca                	mv	a1,s2
    5adc:	00000097          	auipc	ra,0x0
    5ae0:	190080e7          	jalr	400(ra) # 5c6c <fstat>
    5ae4:	892a                	mv	s2,a0
  close(fd);
    5ae6:	8526                	mv	a0,s1
    5ae8:	00000097          	auipc	ra,0x0
    5aec:	154080e7          	jalr	340(ra) # 5c3c <close>
  return r;
    5af0:	64a2                	ld	s1,8(sp)
}
    5af2:	854a                	mv	a0,s2
    5af4:	60e2                	ld	ra,24(sp)
    5af6:	6442                	ld	s0,16(sp)
    5af8:	6902                	ld	s2,0(sp)
    5afa:	6105                	add	sp,sp,32
    5afc:	8082                	ret
    return -1;
    5afe:	597d                	li	s2,-1
    5b00:	bfcd                	j	5af2 <stat+0x36>

0000000000005b02 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
    5b02:	1141                	add	sp,sp,-16
    5b04:	e422                	sd	s0,8(sp)
    5b06:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
    5b08:	00054703          	lbu	a4,0(a0)
    5b0c:	02d00793          	li	a5,45
    5b10:	4585                	li	a1,1
    5b12:	04f70363          	beq	a4,a5,5b58 <atoi+0x56>

  while('0' <= *s && *s <= '9')
    5b16:	00054703          	lbu	a4,0(a0)
    5b1a:	fd07079b          	addw	a5,a4,-48
    5b1e:	0ff7f793          	zext.b	a5,a5
    5b22:	46a5                	li	a3,9
    5b24:	02f6ed63          	bltu	a3,a5,5b5e <atoi+0x5c>
  int n = 0;
    5b28:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
    5b2a:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
    5b2c:	0505                	add	a0,a0,1
    5b2e:	0026979b          	sllw	a5,a3,0x2
    5b32:	9fb5                	addw	a5,a5,a3
    5b34:	0017979b          	sllw	a5,a5,0x1
    5b38:	9fb9                	addw	a5,a5,a4
    5b3a:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
    5b3e:	00054703          	lbu	a4,0(a0)
    5b42:	fd07079b          	addw	a5,a4,-48
    5b46:	0ff7f793          	zext.b	a5,a5
    5b4a:	fef671e3          	bgeu	a2,a5,5b2c <atoi+0x2a>
  return sign * n;
}
    5b4e:	02d5853b          	mulw	a0,a1,a3
    5b52:	6422                	ld	s0,8(sp)
    5b54:	0141                	add	sp,sp,16
    5b56:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
    5b58:	0505                	add	a0,a0,1
    5b5a:	55fd                	li	a1,-1
    5b5c:	bf6d                	j	5b16 <atoi+0x14>
  int n = 0;
    5b5e:	4681                	li	a3,0
    5b60:	b7fd                	j	5b4e <atoi+0x4c>

0000000000005b62 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
    5b62:	1141                	add	sp,sp,-16
    5b64:	e422                	sd	s0,8(sp)
    5b66:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    5b68:	02b57463          	bgeu	a0,a1,5b90 <memmove+0x2e>
    while(n-- > 0)
    5b6c:	00c05f63          	blez	a2,5b8a <memmove+0x28>
    5b70:	1602                	sll	a2,a2,0x20
    5b72:	9201                	srl	a2,a2,0x20
    5b74:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    5b78:	872a                	mv	a4,a0
      *dst++ = *src++;
    5b7a:	0585                	add	a1,a1,1
    5b7c:	0705                	add	a4,a4,1
    5b7e:	fff5c683          	lbu	a3,-1(a1)
    5b82:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    5b86:	fef71ae3          	bne	a4,a5,5b7a <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    5b8a:	6422                	ld	s0,8(sp)
    5b8c:	0141                	add	sp,sp,16
    5b8e:	8082                	ret
    dst += n;
    5b90:	00c50733          	add	a4,a0,a2
    src += n;
    5b94:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    5b96:	fec05ae3          	blez	a2,5b8a <memmove+0x28>
    5b9a:	fff6079b          	addw	a5,a2,-1
    5b9e:	1782                	sll	a5,a5,0x20
    5ba0:	9381                	srl	a5,a5,0x20
    5ba2:	fff7c793          	not	a5,a5
    5ba6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    5ba8:	15fd                	add	a1,a1,-1
    5baa:	177d                	add	a4,a4,-1
    5bac:	0005c683          	lbu	a3,0(a1)
    5bb0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    5bb4:	fee79ae3          	bne	a5,a4,5ba8 <memmove+0x46>
    5bb8:	bfc9                	j	5b8a <memmove+0x28>

0000000000005bba <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    5bba:	1141                	add	sp,sp,-16
    5bbc:	e422                	sd	s0,8(sp)
    5bbe:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    5bc0:	ca05                	beqz	a2,5bf0 <memcmp+0x36>
    5bc2:	fff6069b          	addw	a3,a2,-1
    5bc6:	1682                	sll	a3,a3,0x20
    5bc8:	9281                	srl	a3,a3,0x20
    5bca:	0685                	add	a3,a3,1
    5bcc:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    5bce:	00054783          	lbu	a5,0(a0)
    5bd2:	0005c703          	lbu	a4,0(a1)
    5bd6:	00e79863          	bne	a5,a4,5be6 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    5bda:	0505                	add	a0,a0,1
    p2++;
    5bdc:	0585                	add	a1,a1,1
  while (n-- > 0) {
    5bde:	fed518e3          	bne	a0,a3,5bce <memcmp+0x14>
  }
  return 0;
    5be2:	4501                	li	a0,0
    5be4:	a019                	j	5bea <memcmp+0x30>
      return *p1 - *p2;
    5be6:	40e7853b          	subw	a0,a5,a4
}
    5bea:	6422                	ld	s0,8(sp)
    5bec:	0141                	add	sp,sp,16
    5bee:	8082                	ret
  return 0;
    5bf0:	4501                	li	a0,0
    5bf2:	bfe5                	j	5bea <memcmp+0x30>

0000000000005bf4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    5bf4:	1141                	add	sp,sp,-16
    5bf6:	e406                	sd	ra,8(sp)
    5bf8:	e022                	sd	s0,0(sp)
    5bfa:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    5bfc:	00000097          	auipc	ra,0x0
    5c00:	f66080e7          	jalr	-154(ra) # 5b62 <memmove>
}
    5c04:	60a2                	ld	ra,8(sp)
    5c06:	6402                	ld	s0,0(sp)
    5c08:	0141                	add	sp,sp,16
    5c0a:	8082                	ret

0000000000005c0c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5c0c:	4885                	li	a7,1
 ecall
    5c0e:	00000073          	ecall
 ret
    5c12:	8082                	ret

0000000000005c14 <exit>:
.global exit
exit:
 li a7, SYS_exit
    5c14:	4889                	li	a7,2
 ecall
    5c16:	00000073          	ecall
 ret
    5c1a:	8082                	ret

0000000000005c1c <wait>:
.global wait
wait:
 li a7, SYS_wait
    5c1c:	488d                	li	a7,3
 ecall
    5c1e:	00000073          	ecall
 ret
    5c22:	8082                	ret

0000000000005c24 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    5c24:	4891                	li	a7,4
 ecall
    5c26:	00000073          	ecall
 ret
    5c2a:	8082                	ret

0000000000005c2c <read>:
.global read
read:
 li a7, SYS_read
    5c2c:	4895                	li	a7,5
 ecall
    5c2e:	00000073          	ecall
 ret
    5c32:	8082                	ret

0000000000005c34 <write>:
.global write
write:
 li a7, SYS_write
    5c34:	48c1                	li	a7,16
 ecall
    5c36:	00000073          	ecall
 ret
    5c3a:	8082                	ret

0000000000005c3c <close>:
.global close
close:
 li a7, SYS_close
    5c3c:	48d5                	li	a7,21
 ecall
    5c3e:	00000073          	ecall
 ret
    5c42:	8082                	ret

0000000000005c44 <kill>:
.global kill
kill:
 li a7, SYS_kill
    5c44:	4899                	li	a7,6
 ecall
    5c46:	00000073          	ecall
 ret
    5c4a:	8082                	ret

0000000000005c4c <exec>:
.global exec
exec:
 li a7, SYS_exec
    5c4c:	489d                	li	a7,7
 ecall
    5c4e:	00000073          	ecall
 ret
    5c52:	8082                	ret

0000000000005c54 <open>:
.global open
open:
 li a7, SYS_open
    5c54:	48bd                	li	a7,15
 ecall
    5c56:	00000073          	ecall
 ret
    5c5a:	8082                	ret

0000000000005c5c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5c5c:	48c5                	li	a7,17
 ecall
    5c5e:	00000073          	ecall
 ret
    5c62:	8082                	ret

0000000000005c64 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    5c64:	48c9                	li	a7,18
 ecall
    5c66:	00000073          	ecall
 ret
    5c6a:	8082                	ret

0000000000005c6c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5c6c:	48a1                	li	a7,8
 ecall
    5c6e:	00000073          	ecall
 ret
    5c72:	8082                	ret

0000000000005c74 <link>:
.global link
link:
 li a7, SYS_link
    5c74:	48cd                	li	a7,19
 ecall
    5c76:	00000073          	ecall
 ret
    5c7a:	8082                	ret

0000000000005c7c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5c7c:	48d1                	li	a7,20
 ecall
    5c7e:	00000073          	ecall
 ret
    5c82:	8082                	ret

0000000000005c84 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    5c84:	48a5                	li	a7,9
 ecall
    5c86:	00000073          	ecall
 ret
    5c8a:	8082                	ret

0000000000005c8c <dup>:
.global dup
dup:
 li a7, SYS_dup
    5c8c:	48a9                	li	a7,10
 ecall
    5c8e:	00000073          	ecall
 ret
    5c92:	8082                	ret

0000000000005c94 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    5c94:	48ad                	li	a7,11
 ecall
    5c96:	00000073          	ecall
 ret
    5c9a:	8082                	ret

0000000000005c9c <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    5c9c:	48b1                	li	a7,12
 ecall
    5c9e:	00000073          	ecall
 ret
    5ca2:	8082                	ret

0000000000005ca4 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    5ca4:	48b5                	li	a7,13
 ecall
    5ca6:	00000073          	ecall
 ret
    5caa:	8082                	ret

0000000000005cac <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    5cac:	48b9                	li	a7,14
 ecall
    5cae:	00000073          	ecall
 ret
    5cb2:	8082                	ret

0000000000005cb4 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
    5cb4:	48d9                	li	a7,22
 ecall
    5cb6:	00000073          	ecall
 ret
    5cba:	8082                	ret

0000000000005cbc <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
    5cbc:	48dd                	li	a7,23
 ecall
    5cbe:	00000073          	ecall
 ret
    5cc2:	8082                	ret

0000000000005cc4 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    5cc4:	48e1                	li	a7,24
 ecall
    5cc6:	00000073          	ecall
 ret
    5cca:	8082                	ret

0000000000005ccc <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    5ccc:	48e5                	li	a7,25
 ecall
    5cce:	00000073          	ecall
 ret
    5cd2:	8082                	ret

0000000000005cd4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    5cd4:	1101                	add	sp,sp,-32
    5cd6:	ec06                	sd	ra,24(sp)
    5cd8:	e822                	sd	s0,16(sp)
    5cda:	1000                	add	s0,sp,32
    5cdc:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    5ce0:	4605                	li	a2,1
    5ce2:	fef40593          	add	a1,s0,-17
    5ce6:	00000097          	auipc	ra,0x0
    5cea:	f4e080e7          	jalr	-178(ra) # 5c34 <write>
}
    5cee:	60e2                	ld	ra,24(sp)
    5cf0:	6442                	ld	s0,16(sp)
    5cf2:	6105                	add	sp,sp,32
    5cf4:	8082                	ret

0000000000005cf6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    5cf6:	7139                	add	sp,sp,-64
    5cf8:	fc06                	sd	ra,56(sp)
    5cfa:	f822                	sd	s0,48(sp)
    5cfc:	f426                	sd	s1,40(sp)
    5cfe:	0080                	add	s0,sp,64
    5d00:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    5d02:	c299                	beqz	a3,5d08 <printint+0x12>
    5d04:	0805cb63          	bltz	a1,5d9a <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    5d08:	2581                	sext.w	a1,a1
  neg = 0;
    5d0a:	4881                	li	a7,0
    5d0c:	fc040693          	add	a3,s0,-64
  }

  i = 0;
    5d10:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    5d12:	2601                	sext.w	a2,a2
    5d14:	00003517          	auipc	a0,0x3
    5d18:	92450513          	add	a0,a0,-1756 # 8638 <digits>
    5d1c:	883a                	mv	a6,a4
    5d1e:	2705                	addw	a4,a4,1
    5d20:	02c5f7bb          	remuw	a5,a1,a2
    5d24:	1782                	sll	a5,a5,0x20
    5d26:	9381                	srl	a5,a5,0x20
    5d28:	97aa                	add	a5,a5,a0
    5d2a:	0007c783          	lbu	a5,0(a5)
    5d2e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5d32:	0005879b          	sext.w	a5,a1
    5d36:	02c5d5bb          	divuw	a1,a1,a2
    5d3a:	0685                	add	a3,a3,1
    5d3c:	fec7f0e3          	bgeu	a5,a2,5d1c <printint+0x26>
  if(neg)
    5d40:	00088c63          	beqz	a7,5d58 <printint+0x62>
    buf[i++] = '-';
    5d44:	fd070793          	add	a5,a4,-48
    5d48:	00878733          	add	a4,a5,s0
    5d4c:	02d00793          	li	a5,45
    5d50:	fef70823          	sb	a5,-16(a4)
    5d54:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    5d58:	02e05c63          	blez	a4,5d90 <printint+0x9a>
    5d5c:	f04a                	sd	s2,32(sp)
    5d5e:	ec4e                	sd	s3,24(sp)
    5d60:	fc040793          	add	a5,s0,-64
    5d64:	00e78933          	add	s2,a5,a4
    5d68:	fff78993          	add	s3,a5,-1
    5d6c:	99ba                	add	s3,s3,a4
    5d6e:	377d                	addw	a4,a4,-1
    5d70:	1702                	sll	a4,a4,0x20
    5d72:	9301                	srl	a4,a4,0x20
    5d74:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    5d78:	fff94583          	lbu	a1,-1(s2)
    5d7c:	8526                	mv	a0,s1
    5d7e:	00000097          	auipc	ra,0x0
    5d82:	f56080e7          	jalr	-170(ra) # 5cd4 <putc>
  while(--i >= 0)
    5d86:	197d                	add	s2,s2,-1
    5d88:	ff3918e3          	bne	s2,s3,5d78 <printint+0x82>
    5d8c:	7902                	ld	s2,32(sp)
    5d8e:	69e2                	ld	s3,24(sp)
}
    5d90:	70e2                	ld	ra,56(sp)
    5d92:	7442                	ld	s0,48(sp)
    5d94:	74a2                	ld	s1,40(sp)
    5d96:	6121                	add	sp,sp,64
    5d98:	8082                	ret
    x = -xx;
    5d9a:	40b005bb          	negw	a1,a1
    neg = 1;
    5d9e:	4885                	li	a7,1
    x = -xx;
    5da0:	b7b5                	j	5d0c <printint+0x16>

0000000000005da2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5da2:	715d                	add	sp,sp,-80
    5da4:	e486                	sd	ra,72(sp)
    5da6:	e0a2                	sd	s0,64(sp)
    5da8:	f84a                	sd	s2,48(sp)
    5daa:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    5dac:	0005c903          	lbu	s2,0(a1)
    5db0:	1a090a63          	beqz	s2,5f64 <vprintf+0x1c2>
    5db4:	fc26                	sd	s1,56(sp)
    5db6:	f44e                	sd	s3,40(sp)
    5db8:	f052                	sd	s4,32(sp)
    5dba:	ec56                	sd	s5,24(sp)
    5dbc:	e85a                	sd	s6,16(sp)
    5dbe:	e45e                	sd	s7,8(sp)
    5dc0:	8aaa                	mv	s5,a0
    5dc2:	8bb2                	mv	s7,a2
    5dc4:	00158493          	add	s1,a1,1
  state = 0;
    5dc8:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    5dca:	02500a13          	li	s4,37
    5dce:	4b55                	li	s6,21
    5dd0:	a839                	j	5dee <vprintf+0x4c>
        putc(fd, c);
    5dd2:	85ca                	mv	a1,s2
    5dd4:	8556                	mv	a0,s5
    5dd6:	00000097          	auipc	ra,0x0
    5dda:	efe080e7          	jalr	-258(ra) # 5cd4 <putc>
    5dde:	a019                	j	5de4 <vprintf+0x42>
    } else if(state == '%'){
    5de0:	01498d63          	beq	s3,s4,5dfa <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    5de4:	0485                	add	s1,s1,1
    5de6:	fff4c903          	lbu	s2,-1(s1)
    5dea:	16090763          	beqz	s2,5f58 <vprintf+0x1b6>
    if(state == 0){
    5dee:	fe0999e3          	bnez	s3,5de0 <vprintf+0x3e>
      if(c == '%'){
    5df2:	ff4910e3          	bne	s2,s4,5dd2 <vprintf+0x30>
        state = '%';
    5df6:	89d2                	mv	s3,s4
    5df8:	b7f5                	j	5de4 <vprintf+0x42>
      if(c == 'd'){
    5dfa:	13490463          	beq	s2,s4,5f22 <vprintf+0x180>
    5dfe:	f9d9079b          	addw	a5,s2,-99
    5e02:	0ff7f793          	zext.b	a5,a5
    5e06:	12fb6763          	bltu	s6,a5,5f34 <vprintf+0x192>
    5e0a:	f9d9079b          	addw	a5,s2,-99
    5e0e:	0ff7f713          	zext.b	a4,a5
    5e12:	12eb6163          	bltu	s6,a4,5f34 <vprintf+0x192>
    5e16:	00271793          	sll	a5,a4,0x2
    5e1a:	00002717          	auipc	a4,0x2
    5e1e:	7c670713          	add	a4,a4,1990 # 85e0 <malloc+0x258c>
    5e22:	97ba                	add	a5,a5,a4
    5e24:	439c                	lw	a5,0(a5)
    5e26:	97ba                	add	a5,a5,a4
    5e28:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    5e2a:	008b8913          	add	s2,s7,8
    5e2e:	4685                	li	a3,1
    5e30:	4629                	li	a2,10
    5e32:	000ba583          	lw	a1,0(s7)
    5e36:	8556                	mv	a0,s5
    5e38:	00000097          	auipc	ra,0x0
    5e3c:	ebe080e7          	jalr	-322(ra) # 5cf6 <printint>
    5e40:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    5e42:	4981                	li	s3,0
    5e44:	b745                	j	5de4 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5e46:	008b8913          	add	s2,s7,8
    5e4a:	4681                	li	a3,0
    5e4c:	4629                	li	a2,10
    5e4e:	000ba583          	lw	a1,0(s7)
    5e52:	8556                	mv	a0,s5
    5e54:	00000097          	auipc	ra,0x0
    5e58:	ea2080e7          	jalr	-350(ra) # 5cf6 <printint>
    5e5c:	8bca                	mv	s7,s2
      state = 0;
    5e5e:	4981                	li	s3,0
    5e60:	b751                	j	5de4 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    5e62:	008b8913          	add	s2,s7,8
    5e66:	4681                	li	a3,0
    5e68:	4641                	li	a2,16
    5e6a:	000ba583          	lw	a1,0(s7)
    5e6e:	8556                	mv	a0,s5
    5e70:	00000097          	auipc	ra,0x0
    5e74:	e86080e7          	jalr	-378(ra) # 5cf6 <printint>
    5e78:	8bca                	mv	s7,s2
      state = 0;
    5e7a:	4981                	li	s3,0
    5e7c:	b7a5                	j	5de4 <vprintf+0x42>
    5e7e:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    5e80:	008b8c13          	add	s8,s7,8
    5e84:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    5e88:	03000593          	li	a1,48
    5e8c:	8556                	mv	a0,s5
    5e8e:	00000097          	auipc	ra,0x0
    5e92:	e46080e7          	jalr	-442(ra) # 5cd4 <putc>
  putc(fd, 'x');
    5e96:	07800593          	li	a1,120
    5e9a:	8556                	mv	a0,s5
    5e9c:	00000097          	auipc	ra,0x0
    5ea0:	e38080e7          	jalr	-456(ra) # 5cd4 <putc>
    5ea4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5ea6:	00002b97          	auipc	s7,0x2
    5eaa:	792b8b93          	add	s7,s7,1938 # 8638 <digits>
    5eae:	03c9d793          	srl	a5,s3,0x3c
    5eb2:	97de                	add	a5,a5,s7
    5eb4:	0007c583          	lbu	a1,0(a5)
    5eb8:	8556                	mv	a0,s5
    5eba:	00000097          	auipc	ra,0x0
    5ebe:	e1a080e7          	jalr	-486(ra) # 5cd4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5ec2:	0992                	sll	s3,s3,0x4
    5ec4:	397d                	addw	s2,s2,-1
    5ec6:	fe0914e3          	bnez	s2,5eae <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    5eca:	8be2                	mv	s7,s8
      state = 0;
    5ecc:	4981                	li	s3,0
    5ece:	6c02                	ld	s8,0(sp)
    5ed0:	bf11                	j	5de4 <vprintf+0x42>
        s = va_arg(ap, char*);
    5ed2:	008b8993          	add	s3,s7,8
    5ed6:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    5eda:	02090163          	beqz	s2,5efc <vprintf+0x15a>
        while(*s != 0){
    5ede:	00094583          	lbu	a1,0(s2)
    5ee2:	c9a5                	beqz	a1,5f52 <vprintf+0x1b0>
          putc(fd, *s);
    5ee4:	8556                	mv	a0,s5
    5ee6:	00000097          	auipc	ra,0x0
    5eea:	dee080e7          	jalr	-530(ra) # 5cd4 <putc>
          s++;
    5eee:	0905                	add	s2,s2,1
        while(*s != 0){
    5ef0:	00094583          	lbu	a1,0(s2)
    5ef4:	f9e5                	bnez	a1,5ee4 <vprintf+0x142>
        s = va_arg(ap, char*);
    5ef6:	8bce                	mv	s7,s3
      state = 0;
    5ef8:	4981                	li	s3,0
    5efa:	b5ed                	j	5de4 <vprintf+0x42>
          s = "(null)";
    5efc:	00002917          	auipc	s2,0x2
    5f00:	6bc90913          	add	s2,s2,1724 # 85b8 <malloc+0x2564>
        while(*s != 0){
    5f04:	02800593          	li	a1,40
    5f08:	bff1                	j	5ee4 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    5f0a:	008b8913          	add	s2,s7,8
    5f0e:	000bc583          	lbu	a1,0(s7)
    5f12:	8556                	mv	a0,s5
    5f14:	00000097          	auipc	ra,0x0
    5f18:	dc0080e7          	jalr	-576(ra) # 5cd4 <putc>
    5f1c:	8bca                	mv	s7,s2
      state = 0;
    5f1e:	4981                	li	s3,0
    5f20:	b5d1                	j	5de4 <vprintf+0x42>
        putc(fd, c);
    5f22:	02500593          	li	a1,37
    5f26:	8556                	mv	a0,s5
    5f28:	00000097          	auipc	ra,0x0
    5f2c:	dac080e7          	jalr	-596(ra) # 5cd4 <putc>
      state = 0;
    5f30:	4981                	li	s3,0
    5f32:	bd4d                	j	5de4 <vprintf+0x42>
        putc(fd, '%');
    5f34:	02500593          	li	a1,37
    5f38:	8556                	mv	a0,s5
    5f3a:	00000097          	auipc	ra,0x0
    5f3e:	d9a080e7          	jalr	-614(ra) # 5cd4 <putc>
        putc(fd, c);
    5f42:	85ca                	mv	a1,s2
    5f44:	8556                	mv	a0,s5
    5f46:	00000097          	auipc	ra,0x0
    5f4a:	d8e080e7          	jalr	-626(ra) # 5cd4 <putc>
      state = 0;
    5f4e:	4981                	li	s3,0
    5f50:	bd51                	j	5de4 <vprintf+0x42>
        s = va_arg(ap, char*);
    5f52:	8bce                	mv	s7,s3
      state = 0;
    5f54:	4981                	li	s3,0
    5f56:	b579                	j	5de4 <vprintf+0x42>
    5f58:	74e2                	ld	s1,56(sp)
    5f5a:	79a2                	ld	s3,40(sp)
    5f5c:	7a02                	ld	s4,32(sp)
    5f5e:	6ae2                	ld	s5,24(sp)
    5f60:	6b42                	ld	s6,16(sp)
    5f62:	6ba2                	ld	s7,8(sp)
    }
  }
}
    5f64:	60a6                	ld	ra,72(sp)
    5f66:	6406                	ld	s0,64(sp)
    5f68:	7942                	ld	s2,48(sp)
    5f6a:	6161                	add	sp,sp,80
    5f6c:	8082                	ret

0000000000005f6e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5f6e:	715d                	add	sp,sp,-80
    5f70:	ec06                	sd	ra,24(sp)
    5f72:	e822                	sd	s0,16(sp)
    5f74:	1000                	add	s0,sp,32
    5f76:	e010                	sd	a2,0(s0)
    5f78:	e414                	sd	a3,8(s0)
    5f7a:	e818                	sd	a4,16(s0)
    5f7c:	ec1c                	sd	a5,24(s0)
    5f7e:	03043023          	sd	a6,32(s0)
    5f82:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5f86:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5f8a:	8622                	mv	a2,s0
    5f8c:	00000097          	auipc	ra,0x0
    5f90:	e16080e7          	jalr	-490(ra) # 5da2 <vprintf>
}
    5f94:	60e2                	ld	ra,24(sp)
    5f96:	6442                	ld	s0,16(sp)
    5f98:	6161                	add	sp,sp,80
    5f9a:	8082                	ret

0000000000005f9c <printf>:

void
printf(const char *fmt, ...)
{
    5f9c:	711d                	add	sp,sp,-96
    5f9e:	ec06                	sd	ra,24(sp)
    5fa0:	e822                	sd	s0,16(sp)
    5fa2:	1000                	add	s0,sp,32
    5fa4:	e40c                	sd	a1,8(s0)
    5fa6:	e810                	sd	a2,16(s0)
    5fa8:	ec14                	sd	a3,24(s0)
    5faa:	f018                	sd	a4,32(s0)
    5fac:	f41c                	sd	a5,40(s0)
    5fae:	03043823          	sd	a6,48(s0)
    5fb2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5fb6:	00840613          	add	a2,s0,8
    5fba:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    5fbe:	85aa                	mv	a1,a0
    5fc0:	4505                	li	a0,1
    5fc2:	00000097          	auipc	ra,0x0
    5fc6:	de0080e7          	jalr	-544(ra) # 5da2 <vprintf>
}
    5fca:	60e2                	ld	ra,24(sp)
    5fcc:	6442                	ld	s0,16(sp)
    5fce:	6125                	add	sp,sp,96
    5fd0:	8082                	ret

0000000000005fd2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    5fd2:	1141                	add	sp,sp,-16
    5fd4:	e422                	sd	s0,8(sp)
    5fd6:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5fd8:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5fdc:	00003797          	auipc	a5,0x3
    5fe0:	4747b783          	ld	a5,1140(a5) # 9450 <freep>
    5fe4:	a02d                	j	600e <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    5fe6:	4618                	lw	a4,8(a2)
    5fe8:	9f2d                	addw	a4,a4,a1
    5fea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    5fee:	6398                	ld	a4,0(a5)
    5ff0:	6310                	ld	a2,0(a4)
    5ff2:	a83d                	j	6030 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    5ff4:	ff852703          	lw	a4,-8(a0)
    5ff8:	9f31                	addw	a4,a4,a2
    5ffa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5ffc:	ff053683          	ld	a3,-16(a0)
    6000:	a091                	j	6044 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6002:	6398                	ld	a4,0(a5)
    6004:	00e7e463          	bltu	a5,a4,600c <free+0x3a>
    6008:	00e6ea63          	bltu	a3,a4,601c <free+0x4a>
{
    600c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    600e:	fed7fae3          	bgeu	a5,a3,6002 <free+0x30>
    6012:	6398                	ld	a4,0(a5)
    6014:	00e6e463          	bltu	a3,a4,601c <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    6018:	fee7eae3          	bltu	a5,a4,600c <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    601c:	ff852583          	lw	a1,-8(a0)
    6020:	6390                	ld	a2,0(a5)
    6022:	02059813          	sll	a6,a1,0x20
    6026:	01c85713          	srl	a4,a6,0x1c
    602a:	9736                	add	a4,a4,a3
    602c:	fae60de3          	beq	a2,a4,5fe6 <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    6030:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    6034:	4790                	lw	a2,8(a5)
    6036:	02061593          	sll	a1,a2,0x20
    603a:	01c5d713          	srl	a4,a1,0x1c
    603e:	973e                	add	a4,a4,a5
    6040:	fae68ae3          	beq	a3,a4,5ff4 <free+0x22>
    p->s.ptr = bp->s.ptr;
    6044:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    6046:	00003717          	auipc	a4,0x3
    604a:	40f73523          	sd	a5,1034(a4) # 9450 <freep>
}
    604e:	6422                	ld	s0,8(sp)
    6050:	0141                	add	sp,sp,16
    6052:	8082                	ret

0000000000006054 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    6054:	7139                	add	sp,sp,-64
    6056:	fc06                	sd	ra,56(sp)
    6058:	f822                	sd	s0,48(sp)
    605a:	f426                	sd	s1,40(sp)
    605c:	ec4e                	sd	s3,24(sp)
    605e:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    6060:	02051493          	sll	s1,a0,0x20
    6064:	9081                	srl	s1,s1,0x20
    6066:	04bd                	add	s1,s1,15
    6068:	8091                	srl	s1,s1,0x4
    606a:	0014899b          	addw	s3,s1,1
    606e:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    6070:	00003517          	auipc	a0,0x3
    6074:	3e053503          	ld	a0,992(a0) # 9450 <freep>
    6078:	c915                	beqz	a0,60ac <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    607a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    607c:	4798                	lw	a4,8(a5)
    607e:	08977e63          	bgeu	a4,s1,611a <malloc+0xc6>
    6082:	f04a                	sd	s2,32(sp)
    6084:	e852                	sd	s4,16(sp)
    6086:	e456                	sd	s5,8(sp)
    6088:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    608a:	8a4e                	mv	s4,s3
    608c:	0009871b          	sext.w	a4,s3
    6090:	6685                	lui	a3,0x1
    6092:	00d77363          	bgeu	a4,a3,6098 <malloc+0x44>
    6096:	6a05                	lui	s4,0x1
    6098:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    609c:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    60a0:	00003917          	auipc	s2,0x3
    60a4:	3b090913          	add	s2,s2,944 # 9450 <freep>
  if(p == (char*)-1)
    60a8:	5afd                	li	s5,-1
    60aa:	a091                	j	60ee <malloc+0x9a>
    60ac:	f04a                	sd	s2,32(sp)
    60ae:	e852                	sd	s4,16(sp)
    60b0:	e456                	sd	s5,8(sp)
    60b2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    60b4:	0000a797          	auipc	a5,0xa
    60b8:	bc478793          	add	a5,a5,-1084 # fc78 <base>
    60bc:	00003717          	auipc	a4,0x3
    60c0:	38f73a23          	sd	a5,916(a4) # 9450 <freep>
    60c4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    60c6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    60ca:	b7c1                	j	608a <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    60cc:	6398                	ld	a4,0(a5)
    60ce:	e118                	sd	a4,0(a0)
    60d0:	a08d                	j	6132 <malloc+0xde>
  hp->s.size = nu;
    60d2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    60d6:	0541                	add	a0,a0,16
    60d8:	00000097          	auipc	ra,0x0
    60dc:	efa080e7          	jalr	-262(ra) # 5fd2 <free>
  return freep;
    60e0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    60e4:	c13d                	beqz	a0,614a <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    60e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    60e8:	4798                	lw	a4,8(a5)
    60ea:	02977463          	bgeu	a4,s1,6112 <malloc+0xbe>
    if(p == freep)
    60ee:	00093703          	ld	a4,0(s2)
    60f2:	853e                	mv	a0,a5
    60f4:	fef719e3          	bne	a4,a5,60e6 <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    60f8:	8552                	mv	a0,s4
    60fa:	00000097          	auipc	ra,0x0
    60fe:	ba2080e7          	jalr	-1118(ra) # 5c9c <sbrk>
  if(p == (char*)-1)
    6102:	fd5518e3          	bne	a0,s5,60d2 <malloc+0x7e>
        return 0;
    6106:	4501                	li	a0,0
    6108:	7902                	ld	s2,32(sp)
    610a:	6a42                	ld	s4,16(sp)
    610c:	6aa2                	ld	s5,8(sp)
    610e:	6b02                	ld	s6,0(sp)
    6110:	a03d                	j	613e <malloc+0xea>
    6112:	7902                	ld	s2,32(sp)
    6114:	6a42                	ld	s4,16(sp)
    6116:	6aa2                	ld	s5,8(sp)
    6118:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    611a:	fae489e3          	beq	s1,a4,60cc <malloc+0x78>
        p->s.size -= nunits;
    611e:	4137073b          	subw	a4,a4,s3
    6122:	c798                	sw	a4,8(a5)
        p += p->s.size;
    6124:	02071693          	sll	a3,a4,0x20
    6128:	01c6d713          	srl	a4,a3,0x1c
    612c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    612e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    6132:	00003717          	auipc	a4,0x3
    6136:	30a73f23          	sd	a0,798(a4) # 9450 <freep>
      return (void*)(p + 1);
    613a:	01078513          	add	a0,a5,16
  }
}
    613e:	70e2                	ld	ra,56(sp)
    6140:	7442                	ld	s0,48(sp)
    6142:	74a2                	ld	s1,40(sp)
    6144:	69e2                	ld	s3,24(sp)
    6146:	6121                	add	sp,sp,64
    6148:	8082                	ret
    614a:	7902                	ld	s2,32(sp)
    614c:	6a42                	ld	s4,16(sp)
    614e:	6aa2                	ld	s5,8(sp)
    6150:	6b02                	ld	s6,0(sp)
    6152:	b7f5                	j	613e <malloc+0xea>
