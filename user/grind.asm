
user/_grind:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <do_rand>:
#include "kernel/riscv.h"

// from FreeBSD.
int
do_rand(unsigned long *ctx)
{
       0:	1141                	add	sp,sp,-16
       2:	e422                	sd	s0,8(sp)
       4:	0800                	add	s0,sp,16
 * October 1988, p. 1195.
 */
    long hi, lo, x;

    /* Transform to [1, 0x7ffffffe] range. */
    x = (*ctx % 0x7ffffffe) + 1;
       6:	611c                	ld	a5,0(a0)
       8:	80000737          	lui	a4,0x80000
       c:	ffe74713          	xor	a4,a4,-2
      10:	02e7f7b3          	remu	a5,a5,a4
      14:	0785                	add	a5,a5,1
    hi = x / 127773;
    lo = x % 127773;
      16:	66fd                	lui	a3,0x1f
      18:	31d68693          	add	a3,a3,797 # 1f31d <base+0x1cf15>
      1c:	02d7e733          	rem	a4,a5,a3
    x = 16807 * lo - 2836 * hi;
      20:	6611                	lui	a2,0x4
      22:	1a760613          	add	a2,a2,423 # 41a7 <base+0x1d9f>
      26:	02c70733          	mul	a4,a4,a2
    hi = x / 127773;
      2a:	02d7c7b3          	div	a5,a5,a3
    x = 16807 * lo - 2836 * hi;
      2e:	76fd                	lui	a3,0xfffff
      30:	4ec68693          	add	a3,a3,1260 # fffffffffffff4ec <base+0xffffffffffffd0e4>
      34:	02d787b3          	mul	a5,a5,a3
      38:	97ba                	add	a5,a5,a4
    if (x < 0)
      3a:	0007c963          	bltz	a5,4c <do_rand+0x4c>
        x += 0x7fffffff;
    /* Transform to [0, 0x7ffffffd] range. */
    x--;
      3e:	17fd                	add	a5,a5,-1
    *ctx = x;
      40:	e11c                	sd	a5,0(a0)
    return (x);
}
      42:	0007851b          	sext.w	a0,a5
      46:	6422                	ld	s0,8(sp)
      48:	0141                	add	sp,sp,16
      4a:	8082                	ret
        x += 0x7fffffff;
      4c:	80000737          	lui	a4,0x80000
      50:	fff74713          	not	a4,a4
      54:	97ba                	add	a5,a5,a4
      56:	b7e5                	j	3e <do_rand+0x3e>

0000000000000058 <rand>:

unsigned long rand_next = 1;

int
rand(void)
{
      58:	1141                	add	sp,sp,-16
      5a:	e406                	sd	ra,8(sp)
      5c:	e022                	sd	s0,0(sp)
      5e:	0800                	add	s0,sp,16
    return (do_rand(&rand_next));
      60:	00002517          	auipc	a0,0x2
      64:	fa050513          	add	a0,a0,-96 # 2000 <rand_next>
      68:	00000097          	auipc	ra,0x0
      6c:	f98080e7          	jalr	-104(ra) # 0 <do_rand>
}
      70:	60a2                	ld	ra,8(sp)
      72:	6402                	ld	s0,0(sp)
      74:	0141                	add	sp,sp,16
      76:	8082                	ret

0000000000000078 <go>:

void
go(int which_child)
{
      78:	7159                	add	sp,sp,-112
      7a:	f486                	sd	ra,104(sp)
      7c:	f0a2                	sd	s0,96(sp)
      7e:	eca6                	sd	s1,88(sp)
      80:	fc56                	sd	s5,56(sp)
      82:	1880                	add	s0,sp,112
      84:	84aa                	mv	s1,a0
  int fd = -1;
  static char buf[999];
  char *break0 = sbrk(0);
      86:	4501                	li	a0,0
      88:	00001097          	auipc	ra,0x1
      8c:	e58080e7          	jalr	-424(ra) # ee0 <sbrk>
      90:	8aaa                	mv	s5,a0
  uint64 iters = 0;

  mkdir("grindir");
      92:	00001517          	auipc	a0,0x1
      96:	30e50513          	add	a0,a0,782 # 13a0 <malloc+0x108>
      9a:	00001097          	auipc	ra,0x1
      9e:	e26080e7          	jalr	-474(ra) # ec0 <mkdir>
  if(chdir("grindir") != 0){
      a2:	00001517          	auipc	a0,0x1
      a6:	2fe50513          	add	a0,a0,766 # 13a0 <malloc+0x108>
      aa:	00001097          	auipc	ra,0x1
      ae:	e1e080e7          	jalr	-482(ra) # ec8 <chdir>
      b2:	c115                	beqz	a0,d6 <go+0x5e>
      b4:	e8ca                	sd	s2,80(sp)
      b6:	e4ce                	sd	s3,72(sp)
      b8:	e0d2                	sd	s4,64(sp)
      ba:	f85a                	sd	s6,48(sp)
    printf("grind: chdir grindir failed\n");
      bc:	00001517          	auipc	a0,0x1
      c0:	2ec50513          	add	a0,a0,748 # 13a8 <malloc+0x110>
      c4:	00001097          	auipc	ra,0x1
      c8:	11c080e7          	jalr	284(ra) # 11e0 <printf>
    exit(1);
      cc:	4505                	li	a0,1
      ce:	00001097          	auipc	ra,0x1
      d2:	d8a080e7          	jalr	-630(ra) # e58 <exit>
      d6:	e8ca                	sd	s2,80(sp)
      d8:	e4ce                	sd	s3,72(sp)
      da:	e0d2                	sd	s4,64(sp)
      dc:	f85a                	sd	s6,48(sp)
  }
  chdir("/");
      de:	00001517          	auipc	a0,0x1
      e2:	2f250513          	add	a0,a0,754 # 13d0 <malloc+0x138>
      e6:	00001097          	auipc	ra,0x1
      ea:	de2080e7          	jalr	-542(ra) # ec8 <chdir>
      ee:	00001997          	auipc	s3,0x1
      f2:	2f298993          	add	s3,s3,754 # 13e0 <malloc+0x148>
      f6:	c489                	beqz	s1,100 <go+0x88>
      f8:	00001997          	auipc	s3,0x1
      fc:	2e098993          	add	s3,s3,736 # 13d8 <malloc+0x140>
  uint64 iters = 0;
     100:	4481                	li	s1,0
  int fd = -1;
     102:	5a7d                	li	s4,-1
     104:	00001917          	auipc	s2,0x1
     108:	5ac90913          	add	s2,s2,1452 # 16b0 <malloc+0x418>
     10c:	a839                	j	12a <go+0xb2>
    iters++;
    if((iters % 500) == 0)
      write(1, which_child?"B":"A", 1);
    int what = rand() % 23;
    if(what == 1){
      close(open("grindir/../a", O_CREATE|O_RDWR));
     10e:	20200593          	li	a1,514
     112:	00001517          	auipc	a0,0x1
     116:	2d650513          	add	a0,a0,726 # 13e8 <malloc+0x150>
     11a:	00001097          	auipc	ra,0x1
     11e:	d7e080e7          	jalr	-642(ra) # e98 <open>
     122:	00001097          	auipc	ra,0x1
     126:	d5e080e7          	jalr	-674(ra) # e80 <close>
    iters++;
     12a:	0485                	add	s1,s1,1
    if((iters % 500) == 0)
     12c:	1f400793          	li	a5,500
     130:	02f4f7b3          	remu	a5,s1,a5
     134:	eb81                	bnez	a5,144 <go+0xcc>
      write(1, which_child?"B":"A", 1);
     136:	4605                	li	a2,1
     138:	85ce                	mv	a1,s3
     13a:	4505                	li	a0,1
     13c:	00001097          	auipc	ra,0x1
     140:	d3c080e7          	jalr	-708(ra) # e78 <write>
    int what = rand() % 23;
     144:	00000097          	auipc	ra,0x0
     148:	f14080e7          	jalr	-236(ra) # 58 <rand>
     14c:	47dd                	li	a5,23
     14e:	02f5653b          	remw	a0,a0,a5
     152:	0005071b          	sext.w	a4,a0
     156:	47d9                	li	a5,22
     158:	fce7e9e3          	bltu	a5,a4,12a <go+0xb2>
     15c:	02051793          	sll	a5,a0,0x20
     160:	01e7d513          	srl	a0,a5,0x1e
     164:	954a                	add	a0,a0,s2
     166:	411c                	lw	a5,0(a0)
     168:	97ca                	add	a5,a5,s2
     16a:	8782                	jr	a5
    } else if(what == 2){
      close(open("grindir/../grindir/../b", O_CREATE|O_RDWR));
     16c:	20200593          	li	a1,514
     170:	00001517          	auipc	a0,0x1
     174:	28850513          	add	a0,a0,648 # 13f8 <malloc+0x160>
     178:	00001097          	auipc	ra,0x1
     17c:	d20080e7          	jalr	-736(ra) # e98 <open>
     180:	00001097          	auipc	ra,0x1
     184:	d00080e7          	jalr	-768(ra) # e80 <close>
     188:	b74d                	j	12a <go+0xb2>
    } else if(what == 3){
      unlink("grindir/../a");
     18a:	00001517          	auipc	a0,0x1
     18e:	25e50513          	add	a0,a0,606 # 13e8 <malloc+0x150>
     192:	00001097          	auipc	ra,0x1
     196:	d16080e7          	jalr	-746(ra) # ea8 <unlink>
     19a:	bf41                	j	12a <go+0xb2>
    } else if(what == 4){
      if(chdir("grindir") != 0){
     19c:	00001517          	auipc	a0,0x1
     1a0:	20450513          	add	a0,a0,516 # 13a0 <malloc+0x108>
     1a4:	00001097          	auipc	ra,0x1
     1a8:	d24080e7          	jalr	-732(ra) # ec8 <chdir>
     1ac:	e115                	bnez	a0,1d0 <go+0x158>
        printf("grind: chdir grindir failed\n");
        exit(1);
      }
      unlink("../b");
     1ae:	00001517          	auipc	a0,0x1
     1b2:	26250513          	add	a0,a0,610 # 1410 <malloc+0x178>
     1b6:	00001097          	auipc	ra,0x1
     1ba:	cf2080e7          	jalr	-782(ra) # ea8 <unlink>
      chdir("/");
     1be:	00001517          	auipc	a0,0x1
     1c2:	21250513          	add	a0,a0,530 # 13d0 <malloc+0x138>
     1c6:	00001097          	auipc	ra,0x1
     1ca:	d02080e7          	jalr	-766(ra) # ec8 <chdir>
     1ce:	bfb1                	j	12a <go+0xb2>
        printf("grind: chdir grindir failed\n");
     1d0:	00001517          	auipc	a0,0x1
     1d4:	1d850513          	add	a0,a0,472 # 13a8 <malloc+0x110>
     1d8:	00001097          	auipc	ra,0x1
     1dc:	008080e7          	jalr	8(ra) # 11e0 <printf>
        exit(1);
     1e0:	4505                	li	a0,1
     1e2:	00001097          	auipc	ra,0x1
     1e6:	c76080e7          	jalr	-906(ra) # e58 <exit>
    } else if(what == 5){
      close(fd);
     1ea:	8552                	mv	a0,s4
     1ec:	00001097          	auipc	ra,0x1
     1f0:	c94080e7          	jalr	-876(ra) # e80 <close>
      fd = open("/grindir/../a", O_CREATE|O_RDWR);
     1f4:	20200593          	li	a1,514
     1f8:	00001517          	auipc	a0,0x1
     1fc:	22050513          	add	a0,a0,544 # 1418 <malloc+0x180>
     200:	00001097          	auipc	ra,0x1
     204:	c98080e7          	jalr	-872(ra) # e98 <open>
     208:	8a2a                	mv	s4,a0
     20a:	b705                	j	12a <go+0xb2>
    } else if(what == 6){
      close(fd);
     20c:	8552                	mv	a0,s4
     20e:	00001097          	auipc	ra,0x1
     212:	c72080e7          	jalr	-910(ra) # e80 <close>
      fd = open("/./grindir/./../b", O_CREATE|O_RDWR);
     216:	20200593          	li	a1,514
     21a:	00001517          	auipc	a0,0x1
     21e:	20e50513          	add	a0,a0,526 # 1428 <malloc+0x190>
     222:	00001097          	auipc	ra,0x1
     226:	c76080e7          	jalr	-906(ra) # e98 <open>
     22a:	8a2a                	mv	s4,a0
     22c:	bdfd                	j	12a <go+0xb2>
    } else if(what == 7){
      write(fd, buf, sizeof(buf));
     22e:	3e700613          	li	a2,999
     232:	00002597          	auipc	a1,0x2
     236:	dee58593          	add	a1,a1,-530 # 2020 <buf.0>
     23a:	8552                	mv	a0,s4
     23c:	00001097          	auipc	ra,0x1
     240:	c3c080e7          	jalr	-964(ra) # e78 <write>
     244:	b5dd                	j	12a <go+0xb2>
    } else if(what == 8){
      read(fd, buf, sizeof(buf));
     246:	3e700613          	li	a2,999
     24a:	00002597          	auipc	a1,0x2
     24e:	dd658593          	add	a1,a1,-554 # 2020 <buf.0>
     252:	8552                	mv	a0,s4
     254:	00001097          	auipc	ra,0x1
     258:	c1c080e7          	jalr	-996(ra) # e70 <read>
     25c:	b5f9                	j	12a <go+0xb2>
    } else if(what == 9){
      mkdir("grindir/../a");
     25e:	00001517          	auipc	a0,0x1
     262:	18a50513          	add	a0,a0,394 # 13e8 <malloc+0x150>
     266:	00001097          	auipc	ra,0x1
     26a:	c5a080e7          	jalr	-934(ra) # ec0 <mkdir>
      close(open("a/../a/./a", O_CREATE|O_RDWR));
     26e:	20200593          	li	a1,514
     272:	00001517          	auipc	a0,0x1
     276:	1ce50513          	add	a0,a0,462 # 1440 <malloc+0x1a8>
     27a:	00001097          	auipc	ra,0x1
     27e:	c1e080e7          	jalr	-994(ra) # e98 <open>
     282:	00001097          	auipc	ra,0x1
     286:	bfe080e7          	jalr	-1026(ra) # e80 <close>
      unlink("a/a");
     28a:	00001517          	auipc	a0,0x1
     28e:	1c650513          	add	a0,a0,454 # 1450 <malloc+0x1b8>
     292:	00001097          	auipc	ra,0x1
     296:	c16080e7          	jalr	-1002(ra) # ea8 <unlink>
     29a:	bd41                	j	12a <go+0xb2>
    } else if(what == 10){
      mkdir("/../b");
     29c:	00001517          	auipc	a0,0x1
     2a0:	1bc50513          	add	a0,a0,444 # 1458 <malloc+0x1c0>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	c1c080e7          	jalr	-996(ra) # ec0 <mkdir>
      close(open("grindir/../b/b", O_CREATE|O_RDWR));
     2ac:	20200593          	li	a1,514
     2b0:	00001517          	auipc	a0,0x1
     2b4:	1b050513          	add	a0,a0,432 # 1460 <malloc+0x1c8>
     2b8:	00001097          	auipc	ra,0x1
     2bc:	be0080e7          	jalr	-1056(ra) # e98 <open>
     2c0:	00001097          	auipc	ra,0x1
     2c4:	bc0080e7          	jalr	-1088(ra) # e80 <close>
      unlink("b/b");
     2c8:	00001517          	auipc	a0,0x1
     2cc:	1a850513          	add	a0,a0,424 # 1470 <malloc+0x1d8>
     2d0:	00001097          	auipc	ra,0x1
     2d4:	bd8080e7          	jalr	-1064(ra) # ea8 <unlink>
     2d8:	bd89                	j	12a <go+0xb2>
    } else if(what == 11){
      unlink("b");
     2da:	00001517          	auipc	a0,0x1
     2de:	19e50513          	add	a0,a0,414 # 1478 <malloc+0x1e0>
     2e2:	00001097          	auipc	ra,0x1
     2e6:	bc6080e7          	jalr	-1082(ra) # ea8 <unlink>
      link("../grindir/./../a", "../b");
     2ea:	00001597          	auipc	a1,0x1
     2ee:	12658593          	add	a1,a1,294 # 1410 <malloc+0x178>
     2f2:	00001517          	auipc	a0,0x1
     2f6:	18e50513          	add	a0,a0,398 # 1480 <malloc+0x1e8>
     2fa:	00001097          	auipc	ra,0x1
     2fe:	bbe080e7          	jalr	-1090(ra) # eb8 <link>
     302:	b525                	j	12a <go+0xb2>
    } else if(what == 12){
      unlink("../grindir/../a");
     304:	00001517          	auipc	a0,0x1
     308:	19450513          	add	a0,a0,404 # 1498 <malloc+0x200>
     30c:	00001097          	auipc	ra,0x1
     310:	b9c080e7          	jalr	-1124(ra) # ea8 <unlink>
      link(".././b", "/grindir/../a");
     314:	00001597          	auipc	a1,0x1
     318:	10458593          	add	a1,a1,260 # 1418 <malloc+0x180>
     31c:	00001517          	auipc	a0,0x1
     320:	18c50513          	add	a0,a0,396 # 14a8 <malloc+0x210>
     324:	00001097          	auipc	ra,0x1
     328:	b94080e7          	jalr	-1132(ra) # eb8 <link>
     32c:	bbfd                	j	12a <go+0xb2>
    } else if(what == 13){
      int pid = fork();
     32e:	00001097          	auipc	ra,0x1
     332:	b22080e7          	jalr	-1246(ra) # e50 <fork>
      if(pid == 0){
     336:	c909                	beqz	a0,348 <go+0x2d0>
        exit(0);
      } else if(pid < 0){
     338:	00054c63          	bltz	a0,350 <go+0x2d8>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     33c:	4501                	li	a0,0
     33e:	00001097          	auipc	ra,0x1
     342:	b22080e7          	jalr	-1246(ra) # e60 <wait>
     346:	b3d5                	j	12a <go+0xb2>
        exit(0);
     348:	00001097          	auipc	ra,0x1
     34c:	b10080e7          	jalr	-1264(ra) # e58 <exit>
        printf("grind: fork failed\n");
     350:	00001517          	auipc	a0,0x1
     354:	16050513          	add	a0,a0,352 # 14b0 <malloc+0x218>
     358:	00001097          	auipc	ra,0x1
     35c:	e88080e7          	jalr	-376(ra) # 11e0 <printf>
        exit(1);
     360:	4505                	li	a0,1
     362:	00001097          	auipc	ra,0x1
     366:	af6080e7          	jalr	-1290(ra) # e58 <exit>
    } else if(what == 14){
      int pid = fork();
     36a:	00001097          	auipc	ra,0x1
     36e:	ae6080e7          	jalr	-1306(ra) # e50 <fork>
      if(pid == 0){
     372:	c909                	beqz	a0,384 <go+0x30c>
        fork();
        fork();
        exit(0);
      } else if(pid < 0){
     374:	02054563          	bltz	a0,39e <go+0x326>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     378:	4501                	li	a0,0
     37a:	00001097          	auipc	ra,0x1
     37e:	ae6080e7          	jalr	-1306(ra) # e60 <wait>
     382:	b365                	j	12a <go+0xb2>
        fork();
     384:	00001097          	auipc	ra,0x1
     388:	acc080e7          	jalr	-1332(ra) # e50 <fork>
        fork();
     38c:	00001097          	auipc	ra,0x1
     390:	ac4080e7          	jalr	-1340(ra) # e50 <fork>
        exit(0);
     394:	4501                	li	a0,0
     396:	00001097          	auipc	ra,0x1
     39a:	ac2080e7          	jalr	-1342(ra) # e58 <exit>
        printf("grind: fork failed\n");
     39e:	00001517          	auipc	a0,0x1
     3a2:	11250513          	add	a0,a0,274 # 14b0 <malloc+0x218>
     3a6:	00001097          	auipc	ra,0x1
     3aa:	e3a080e7          	jalr	-454(ra) # 11e0 <printf>
        exit(1);
     3ae:	4505                	li	a0,1
     3b0:	00001097          	auipc	ra,0x1
     3b4:	aa8080e7          	jalr	-1368(ra) # e58 <exit>
    } else if(what == 15){
      sbrk(6011);
     3b8:	6505                	lui	a0,0x1
     3ba:	77b50513          	add	a0,a0,1915 # 177b <digits+0x13>
     3be:	00001097          	auipc	ra,0x1
     3c2:	b22080e7          	jalr	-1246(ra) # ee0 <sbrk>
     3c6:	b395                	j	12a <go+0xb2>
    } else if(what == 16){
      if(sbrk(0) > break0)
     3c8:	4501                	li	a0,0
     3ca:	00001097          	auipc	ra,0x1
     3ce:	b16080e7          	jalr	-1258(ra) # ee0 <sbrk>
     3d2:	d4aafce3          	bgeu	s5,a0,12a <go+0xb2>
        sbrk(-(sbrk(0) - break0));
     3d6:	4501                	li	a0,0
     3d8:	00001097          	auipc	ra,0x1
     3dc:	b08080e7          	jalr	-1272(ra) # ee0 <sbrk>
     3e0:	40aa853b          	subw	a0,s5,a0
     3e4:	00001097          	auipc	ra,0x1
     3e8:	afc080e7          	jalr	-1284(ra) # ee0 <sbrk>
     3ec:	bb3d                	j	12a <go+0xb2>
    } else if(what == 17){
      int pid = fork();
     3ee:	00001097          	auipc	ra,0x1
     3f2:	a62080e7          	jalr	-1438(ra) # e50 <fork>
     3f6:	8b2a                	mv	s6,a0
      if(pid == 0){
     3f8:	c51d                	beqz	a0,426 <go+0x3ae>
        close(open("a", O_CREATE|O_RDWR));
        exit(0);
      } else if(pid < 0){
     3fa:	04054963          	bltz	a0,44c <go+0x3d4>
        printf("grind: fork failed\n");
        exit(1);
      }
      if(chdir("../grindir/..") != 0){
     3fe:	00001517          	auipc	a0,0x1
     402:	0d250513          	add	a0,a0,210 # 14d0 <malloc+0x238>
     406:	00001097          	auipc	ra,0x1
     40a:	ac2080e7          	jalr	-1342(ra) # ec8 <chdir>
     40e:	ed21                	bnez	a0,466 <go+0x3ee>
        printf("grind: chdir failed\n");
        exit(1);
      }
      kill(pid);
     410:	855a                	mv	a0,s6
     412:	00001097          	auipc	ra,0x1
     416:	a76080e7          	jalr	-1418(ra) # e88 <kill>
      wait(0);
     41a:	4501                	li	a0,0
     41c:	00001097          	auipc	ra,0x1
     420:	a44080e7          	jalr	-1468(ra) # e60 <wait>
     424:	b319                	j	12a <go+0xb2>
        close(open("a", O_CREATE|O_RDWR));
     426:	20200593          	li	a1,514
     42a:	00001517          	auipc	a0,0x1
     42e:	09e50513          	add	a0,a0,158 # 14c8 <malloc+0x230>
     432:	00001097          	auipc	ra,0x1
     436:	a66080e7          	jalr	-1434(ra) # e98 <open>
     43a:	00001097          	auipc	ra,0x1
     43e:	a46080e7          	jalr	-1466(ra) # e80 <close>
        exit(0);
     442:	4501                	li	a0,0
     444:	00001097          	auipc	ra,0x1
     448:	a14080e7          	jalr	-1516(ra) # e58 <exit>
        printf("grind: fork failed\n");
     44c:	00001517          	auipc	a0,0x1
     450:	06450513          	add	a0,a0,100 # 14b0 <malloc+0x218>
     454:	00001097          	auipc	ra,0x1
     458:	d8c080e7          	jalr	-628(ra) # 11e0 <printf>
        exit(1);
     45c:	4505                	li	a0,1
     45e:	00001097          	auipc	ra,0x1
     462:	9fa080e7          	jalr	-1542(ra) # e58 <exit>
        printf("grind: chdir failed\n");
     466:	00001517          	auipc	a0,0x1
     46a:	07a50513          	add	a0,a0,122 # 14e0 <malloc+0x248>
     46e:	00001097          	auipc	ra,0x1
     472:	d72080e7          	jalr	-654(ra) # 11e0 <printf>
        exit(1);
     476:	4505                	li	a0,1
     478:	00001097          	auipc	ra,0x1
     47c:	9e0080e7          	jalr	-1568(ra) # e58 <exit>
    } else if(what == 18){
      int pid = fork();
     480:	00001097          	auipc	ra,0x1
     484:	9d0080e7          	jalr	-1584(ra) # e50 <fork>
      if(pid == 0){
     488:	c909                	beqz	a0,49a <go+0x422>
        kill(getpid());
        exit(0);
      } else if(pid < 0){
     48a:	02054563          	bltz	a0,4b4 <go+0x43c>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     48e:	4501                	li	a0,0
     490:	00001097          	auipc	ra,0x1
     494:	9d0080e7          	jalr	-1584(ra) # e60 <wait>
     498:	b949                	j	12a <go+0xb2>
        kill(getpid());
     49a:	00001097          	auipc	ra,0x1
     49e:	a3e080e7          	jalr	-1474(ra) # ed8 <getpid>
     4a2:	00001097          	auipc	ra,0x1
     4a6:	9e6080e7          	jalr	-1562(ra) # e88 <kill>
        exit(0);
     4aa:	4501                	li	a0,0
     4ac:	00001097          	auipc	ra,0x1
     4b0:	9ac080e7          	jalr	-1620(ra) # e58 <exit>
        printf("grind: fork failed\n");
     4b4:	00001517          	auipc	a0,0x1
     4b8:	ffc50513          	add	a0,a0,-4 # 14b0 <malloc+0x218>
     4bc:	00001097          	auipc	ra,0x1
     4c0:	d24080e7          	jalr	-732(ra) # 11e0 <printf>
        exit(1);
     4c4:	4505                	li	a0,1
     4c6:	00001097          	auipc	ra,0x1
     4ca:	992080e7          	jalr	-1646(ra) # e58 <exit>
    } else if(what == 19){
      int fds[2];
      if(pipe(fds) < 0){
     4ce:	fa840513          	add	a0,s0,-88
     4d2:	00001097          	auipc	ra,0x1
     4d6:	996080e7          	jalr	-1642(ra) # e68 <pipe>
     4da:	02054b63          	bltz	a0,510 <go+0x498>
        printf("grind: pipe failed\n");
        exit(1);
      }
      int pid = fork();
     4de:	00001097          	auipc	ra,0x1
     4e2:	972080e7          	jalr	-1678(ra) # e50 <fork>
      if(pid == 0){
     4e6:	c131                	beqz	a0,52a <go+0x4b2>
          printf("grind: pipe write failed\n");
        char c;
        if(read(fds[0], &c, 1) != 1)
          printf("grind: pipe read failed\n");
        exit(0);
      } else if(pid < 0){
     4e8:	0a054a63          	bltz	a0,59c <go+0x524>
        printf("grind: fork failed\n");
        exit(1);
      }
      close(fds[0]);
     4ec:	fa842503          	lw	a0,-88(s0)
     4f0:	00001097          	auipc	ra,0x1
     4f4:	990080e7          	jalr	-1648(ra) # e80 <close>
      close(fds[1]);
     4f8:	fac42503          	lw	a0,-84(s0)
     4fc:	00001097          	auipc	ra,0x1
     500:	984080e7          	jalr	-1660(ra) # e80 <close>
      wait(0);
     504:	4501                	li	a0,0
     506:	00001097          	auipc	ra,0x1
     50a:	95a080e7          	jalr	-1702(ra) # e60 <wait>
     50e:	b931                	j	12a <go+0xb2>
        printf("grind: pipe failed\n");
     510:	00001517          	auipc	a0,0x1
     514:	fe850513          	add	a0,a0,-24 # 14f8 <malloc+0x260>
     518:	00001097          	auipc	ra,0x1
     51c:	cc8080e7          	jalr	-824(ra) # 11e0 <printf>
        exit(1);
     520:	4505                	li	a0,1
     522:	00001097          	auipc	ra,0x1
     526:	936080e7          	jalr	-1738(ra) # e58 <exit>
        fork();
     52a:	00001097          	auipc	ra,0x1
     52e:	926080e7          	jalr	-1754(ra) # e50 <fork>
        fork();
     532:	00001097          	auipc	ra,0x1
     536:	91e080e7          	jalr	-1762(ra) # e50 <fork>
        if(write(fds[1], "x", 1) != 1)
     53a:	4605                	li	a2,1
     53c:	00001597          	auipc	a1,0x1
     540:	fd458593          	add	a1,a1,-44 # 1510 <malloc+0x278>
     544:	fac42503          	lw	a0,-84(s0)
     548:	00001097          	auipc	ra,0x1
     54c:	930080e7          	jalr	-1744(ra) # e78 <write>
     550:	4785                	li	a5,1
     552:	02f51363          	bne	a0,a5,578 <go+0x500>
        if(read(fds[0], &c, 1) != 1)
     556:	4605                	li	a2,1
     558:	fa040593          	add	a1,s0,-96
     55c:	fa842503          	lw	a0,-88(s0)
     560:	00001097          	auipc	ra,0x1
     564:	910080e7          	jalr	-1776(ra) # e70 <read>
     568:	4785                	li	a5,1
     56a:	02f51063          	bne	a0,a5,58a <go+0x512>
        exit(0);
     56e:	4501                	li	a0,0
     570:	00001097          	auipc	ra,0x1
     574:	8e8080e7          	jalr	-1816(ra) # e58 <exit>
          printf("grind: pipe write failed\n");
     578:	00001517          	auipc	a0,0x1
     57c:	fa050513          	add	a0,a0,-96 # 1518 <malloc+0x280>
     580:	00001097          	auipc	ra,0x1
     584:	c60080e7          	jalr	-928(ra) # 11e0 <printf>
     588:	b7f9                	j	556 <go+0x4de>
          printf("grind: pipe read failed\n");
     58a:	00001517          	auipc	a0,0x1
     58e:	fae50513          	add	a0,a0,-82 # 1538 <malloc+0x2a0>
     592:	00001097          	auipc	ra,0x1
     596:	c4e080e7          	jalr	-946(ra) # 11e0 <printf>
     59a:	bfd1                	j	56e <go+0x4f6>
        printf("grind: fork failed\n");
     59c:	00001517          	auipc	a0,0x1
     5a0:	f1450513          	add	a0,a0,-236 # 14b0 <malloc+0x218>
     5a4:	00001097          	auipc	ra,0x1
     5a8:	c3c080e7          	jalr	-964(ra) # 11e0 <printf>
        exit(1);
     5ac:	4505                	li	a0,1
     5ae:	00001097          	auipc	ra,0x1
     5b2:	8aa080e7          	jalr	-1878(ra) # e58 <exit>
    } else if(what == 20){
      int pid = fork();
     5b6:	00001097          	auipc	ra,0x1
     5ba:	89a080e7          	jalr	-1894(ra) # e50 <fork>
      if(pid == 0){
     5be:	c909                	beqz	a0,5d0 <go+0x558>
        chdir("a");
        unlink("../a");
        fd = open("x", O_CREATE|O_RDWR);
        unlink("x");
        exit(0);
      } else if(pid < 0){
     5c0:	06054f63          	bltz	a0,63e <go+0x5c6>
        printf("grind: fork failed\n");
        exit(1);
      }
      wait(0);
     5c4:	4501                	li	a0,0
     5c6:	00001097          	auipc	ra,0x1
     5ca:	89a080e7          	jalr	-1894(ra) # e60 <wait>
     5ce:	beb1                	j	12a <go+0xb2>
        unlink("a");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	ef850513          	add	a0,a0,-264 # 14c8 <malloc+0x230>
     5d8:	00001097          	auipc	ra,0x1
     5dc:	8d0080e7          	jalr	-1840(ra) # ea8 <unlink>
        mkdir("a");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	ee850513          	add	a0,a0,-280 # 14c8 <malloc+0x230>
     5e8:	00001097          	auipc	ra,0x1
     5ec:	8d8080e7          	jalr	-1832(ra) # ec0 <mkdir>
        chdir("a");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	ed850513          	add	a0,a0,-296 # 14c8 <malloc+0x230>
     5f8:	00001097          	auipc	ra,0x1
     5fc:	8d0080e7          	jalr	-1840(ra) # ec8 <chdir>
        unlink("../a");
     600:	00001517          	auipc	a0,0x1
     604:	f5850513          	add	a0,a0,-168 # 1558 <malloc+0x2c0>
     608:	00001097          	auipc	ra,0x1
     60c:	8a0080e7          	jalr	-1888(ra) # ea8 <unlink>
        fd = open("x", O_CREATE|O_RDWR);
     610:	20200593          	li	a1,514
     614:	00001517          	auipc	a0,0x1
     618:	efc50513          	add	a0,a0,-260 # 1510 <malloc+0x278>
     61c:	00001097          	auipc	ra,0x1
     620:	87c080e7          	jalr	-1924(ra) # e98 <open>
        unlink("x");
     624:	00001517          	auipc	a0,0x1
     628:	eec50513          	add	a0,a0,-276 # 1510 <malloc+0x278>
     62c:	00001097          	auipc	ra,0x1
     630:	87c080e7          	jalr	-1924(ra) # ea8 <unlink>
        exit(0);
     634:	4501                	li	a0,0
     636:	00001097          	auipc	ra,0x1
     63a:	822080e7          	jalr	-2014(ra) # e58 <exit>
        printf("grind: fork failed\n");
     63e:	00001517          	auipc	a0,0x1
     642:	e7250513          	add	a0,a0,-398 # 14b0 <malloc+0x218>
     646:	00001097          	auipc	ra,0x1
     64a:	b9a080e7          	jalr	-1126(ra) # 11e0 <printf>
        exit(1);
     64e:	4505                	li	a0,1
     650:	00001097          	auipc	ra,0x1
     654:	808080e7          	jalr	-2040(ra) # e58 <exit>
    } else if(what == 21){
      unlink("c");
     658:	00001517          	auipc	a0,0x1
     65c:	f0850513          	add	a0,a0,-248 # 1560 <malloc+0x2c8>
     660:	00001097          	auipc	ra,0x1
     664:	848080e7          	jalr	-1976(ra) # ea8 <unlink>
      // should always succeed. check that there are free i-nodes,
      // file descriptors, blocks.
      int fd1 = open("c", O_CREATE|O_RDWR);
     668:	20200593          	li	a1,514
     66c:	00001517          	auipc	a0,0x1
     670:	ef450513          	add	a0,a0,-268 # 1560 <malloc+0x2c8>
     674:	00001097          	auipc	ra,0x1
     678:	824080e7          	jalr	-2012(ra) # e98 <open>
     67c:	8b2a                	mv	s6,a0
      if(fd1 < 0){
     67e:	04054f63          	bltz	a0,6dc <go+0x664>
        printf("grind: create c failed\n");
        exit(1);
      }
      if(write(fd1, "x", 1) != 1){
     682:	4605                	li	a2,1
     684:	00001597          	auipc	a1,0x1
     688:	e8c58593          	add	a1,a1,-372 # 1510 <malloc+0x278>
     68c:	00000097          	auipc	ra,0x0
     690:	7ec080e7          	jalr	2028(ra) # e78 <write>
     694:	4785                	li	a5,1
     696:	06f51063          	bne	a0,a5,6f6 <go+0x67e>
        printf("grind: write c failed\n");
        exit(1);
      }
      struct stat st;
      if(fstat(fd1, &st) != 0){
     69a:	fa840593          	add	a1,s0,-88
     69e:	855a                	mv	a0,s6
     6a0:	00001097          	auipc	ra,0x1
     6a4:	810080e7          	jalr	-2032(ra) # eb0 <fstat>
     6a8:	e525                	bnez	a0,710 <go+0x698>
        printf("grind: fstat failed\n");
        exit(1);
      }
      if(st.size != 1){
     6aa:	fb843583          	ld	a1,-72(s0)
     6ae:	4785                	li	a5,1
     6b0:	06f59d63          	bne	a1,a5,72a <go+0x6b2>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
        exit(1);
      }
      if(st.ino > 200){
     6b4:	fac42583          	lw	a1,-84(s0)
     6b8:	0c800793          	li	a5,200
     6bc:	08b7e563          	bltu	a5,a1,746 <go+0x6ce>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
        exit(1);
      }
      close(fd1);
     6c0:	855a                	mv	a0,s6
     6c2:	00000097          	auipc	ra,0x0
     6c6:	7be080e7          	jalr	1982(ra) # e80 <close>
      unlink("c");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	e9650513          	add	a0,a0,-362 # 1560 <malloc+0x2c8>
     6d2:	00000097          	auipc	ra,0x0
     6d6:	7d6080e7          	jalr	2006(ra) # ea8 <unlink>
     6da:	bc81                	j	12a <go+0xb2>
        printf("grind: create c failed\n");
     6dc:	00001517          	auipc	a0,0x1
     6e0:	e8c50513          	add	a0,a0,-372 # 1568 <malloc+0x2d0>
     6e4:	00001097          	auipc	ra,0x1
     6e8:	afc080e7          	jalr	-1284(ra) # 11e0 <printf>
        exit(1);
     6ec:	4505                	li	a0,1
     6ee:	00000097          	auipc	ra,0x0
     6f2:	76a080e7          	jalr	1898(ra) # e58 <exit>
        printf("grind: write c failed\n");
     6f6:	00001517          	auipc	a0,0x1
     6fa:	e8a50513          	add	a0,a0,-374 # 1580 <malloc+0x2e8>
     6fe:	00001097          	auipc	ra,0x1
     702:	ae2080e7          	jalr	-1310(ra) # 11e0 <printf>
        exit(1);
     706:	4505                	li	a0,1
     708:	00000097          	auipc	ra,0x0
     70c:	750080e7          	jalr	1872(ra) # e58 <exit>
        printf("grind: fstat failed\n");
     710:	00001517          	auipc	a0,0x1
     714:	e8850513          	add	a0,a0,-376 # 1598 <malloc+0x300>
     718:	00001097          	auipc	ra,0x1
     71c:	ac8080e7          	jalr	-1336(ra) # 11e0 <printf>
        exit(1);
     720:	4505                	li	a0,1
     722:	00000097          	auipc	ra,0x0
     726:	736080e7          	jalr	1846(ra) # e58 <exit>
        printf("grind: fstat reports wrong size %d\n", (int)st.size);
     72a:	2581                	sext.w	a1,a1
     72c:	00001517          	auipc	a0,0x1
     730:	e8450513          	add	a0,a0,-380 # 15b0 <malloc+0x318>
     734:	00001097          	auipc	ra,0x1
     738:	aac080e7          	jalr	-1364(ra) # 11e0 <printf>
        exit(1);
     73c:	4505                	li	a0,1
     73e:	00000097          	auipc	ra,0x0
     742:	71a080e7          	jalr	1818(ra) # e58 <exit>
        printf("grind: fstat reports crazy i-number %d\n", st.ino);
     746:	00001517          	auipc	a0,0x1
     74a:	e9250513          	add	a0,a0,-366 # 15d8 <malloc+0x340>
     74e:	00001097          	auipc	ra,0x1
     752:	a92080e7          	jalr	-1390(ra) # 11e0 <printf>
        exit(1);
     756:	4505                	li	a0,1
     758:	00000097          	auipc	ra,0x0
     75c:	700080e7          	jalr	1792(ra) # e58 <exit>
    } else if(what == 22){
      // echo hi | cat
      int aa[2], bb[2];
      if(pipe(aa) < 0){
     760:	f9840513          	add	a0,s0,-104
     764:	00000097          	auipc	ra,0x0
     768:	704080e7          	jalr	1796(ra) # e68 <pipe>
     76c:	10054063          	bltz	a0,86c <go+0x7f4>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      if(pipe(bb) < 0){
     770:	fa040513          	add	a0,s0,-96
     774:	00000097          	auipc	ra,0x0
     778:	6f4080e7          	jalr	1780(ra) # e68 <pipe>
     77c:	10054663          	bltz	a0,888 <go+0x810>
        fprintf(2, "grind: pipe failed\n");
        exit(1);
      }
      int pid1 = fork();
     780:	00000097          	auipc	ra,0x0
     784:	6d0080e7          	jalr	1744(ra) # e50 <fork>
      if(pid1 == 0){
     788:	10050e63          	beqz	a0,8a4 <go+0x82c>
        close(aa[1]);
        char *args[3] = { "echo", "hi", 0 };
        exec("grindir/../echo", args);
        fprintf(2, "grind: echo: not found\n");
        exit(2);
      } else if(pid1 < 0){
     78c:	1c054663          	bltz	a0,958 <go+0x8e0>
        fprintf(2, "grind: fork failed\n");
        exit(3);
      }
      int pid2 = fork();
     790:	00000097          	auipc	ra,0x0
     794:	6c0080e7          	jalr	1728(ra) # e50 <fork>
      if(pid2 == 0){
     798:	1c050e63          	beqz	a0,974 <go+0x8fc>
        close(bb[1]);
        char *args[2] = { "cat", 0 };
        exec("/cat", args);
        fprintf(2, "grind: cat: not found\n");
        exit(6);
      } else if(pid2 < 0){
     79c:	2a054a63          	bltz	a0,a50 <go+0x9d8>
        fprintf(2, "grind: fork failed\n");
        exit(7);
      }
      close(aa[0]);
     7a0:	f9842503          	lw	a0,-104(s0)
     7a4:	00000097          	auipc	ra,0x0
     7a8:	6dc080e7          	jalr	1756(ra) # e80 <close>
      close(aa[1]);
     7ac:	f9c42503          	lw	a0,-100(s0)
     7b0:	00000097          	auipc	ra,0x0
     7b4:	6d0080e7          	jalr	1744(ra) # e80 <close>
      close(bb[1]);
     7b8:	fa442503          	lw	a0,-92(s0)
     7bc:	00000097          	auipc	ra,0x0
     7c0:	6c4080e7          	jalr	1732(ra) # e80 <close>
      char buf[4] = { 0, 0, 0, 0 };
     7c4:	f8042823          	sw	zero,-112(s0)
      read(bb[0], buf+0, 1);
     7c8:	4605                	li	a2,1
     7ca:	f9040593          	add	a1,s0,-112
     7ce:	fa042503          	lw	a0,-96(s0)
     7d2:	00000097          	auipc	ra,0x0
     7d6:	69e080e7          	jalr	1694(ra) # e70 <read>
      read(bb[0], buf+1, 1);
     7da:	4605                	li	a2,1
     7dc:	f9140593          	add	a1,s0,-111
     7e0:	fa042503          	lw	a0,-96(s0)
     7e4:	00000097          	auipc	ra,0x0
     7e8:	68c080e7          	jalr	1676(ra) # e70 <read>
      read(bb[0], buf+2, 1);
     7ec:	4605                	li	a2,1
     7ee:	f9240593          	add	a1,s0,-110
     7f2:	fa042503          	lw	a0,-96(s0)
     7f6:	00000097          	auipc	ra,0x0
     7fa:	67a080e7          	jalr	1658(ra) # e70 <read>
      close(bb[0]);
     7fe:	fa042503          	lw	a0,-96(s0)
     802:	00000097          	auipc	ra,0x0
     806:	67e080e7          	jalr	1662(ra) # e80 <close>
      int st1, st2;
      wait(&st1);
     80a:	f9440513          	add	a0,s0,-108
     80e:	00000097          	auipc	ra,0x0
     812:	652080e7          	jalr	1618(ra) # e60 <wait>
      wait(&st2);
     816:	fa840513          	add	a0,s0,-88
     81a:	00000097          	auipc	ra,0x0
     81e:	646080e7          	jalr	1606(ra) # e60 <wait>
      if(st1 != 0 || st2 != 0 || strcmp(buf, "hi\n") != 0){
     822:	f9442783          	lw	a5,-108(s0)
     826:	fa842703          	lw	a4,-88(s0)
     82a:	8fd9                	or	a5,a5,a4
     82c:	ef89                	bnez	a5,846 <go+0x7ce>
     82e:	00001597          	auipc	a1,0x1
     832:	e4a58593          	add	a1,a1,-438 # 1678 <malloc+0x3e0>
     836:	f9040513          	add	a0,s0,-112
     83a:	00000097          	auipc	ra,0x0
     83e:	3b6080e7          	jalr	950(ra) # bf0 <strcmp>
     842:	8e0504e3          	beqz	a0,12a <go+0xb2>
        printf("grind: exec pipeline failed %d %d \"%s\"\n", st1, st2, buf);
     846:	f9040693          	add	a3,s0,-112
     84a:	fa842603          	lw	a2,-88(s0)
     84e:	f9442583          	lw	a1,-108(s0)
     852:	00001517          	auipc	a0,0x1
     856:	e2e50513          	add	a0,a0,-466 # 1680 <malloc+0x3e8>
     85a:	00001097          	auipc	ra,0x1
     85e:	986080e7          	jalr	-1658(ra) # 11e0 <printf>
        exit(1);
     862:	4505                	li	a0,1
     864:	00000097          	auipc	ra,0x0
     868:	5f4080e7          	jalr	1524(ra) # e58 <exit>
        fprintf(2, "grind: pipe failed\n");
     86c:	00001597          	auipc	a1,0x1
     870:	c8c58593          	add	a1,a1,-884 # 14f8 <malloc+0x260>
     874:	4509                	li	a0,2
     876:	00001097          	auipc	ra,0x1
     87a:	93c080e7          	jalr	-1732(ra) # 11b2 <fprintf>
        exit(1);
     87e:	4505                	li	a0,1
     880:	00000097          	auipc	ra,0x0
     884:	5d8080e7          	jalr	1496(ra) # e58 <exit>
        fprintf(2, "grind: pipe failed\n");
     888:	00001597          	auipc	a1,0x1
     88c:	c7058593          	add	a1,a1,-912 # 14f8 <malloc+0x260>
     890:	4509                	li	a0,2
     892:	00001097          	auipc	ra,0x1
     896:	920080e7          	jalr	-1760(ra) # 11b2 <fprintf>
        exit(1);
     89a:	4505                	li	a0,1
     89c:	00000097          	auipc	ra,0x0
     8a0:	5bc080e7          	jalr	1468(ra) # e58 <exit>
        close(bb[0]);
     8a4:	fa042503          	lw	a0,-96(s0)
     8a8:	00000097          	auipc	ra,0x0
     8ac:	5d8080e7          	jalr	1496(ra) # e80 <close>
        close(bb[1]);
     8b0:	fa442503          	lw	a0,-92(s0)
     8b4:	00000097          	auipc	ra,0x0
     8b8:	5cc080e7          	jalr	1484(ra) # e80 <close>
        close(aa[0]);
     8bc:	f9842503          	lw	a0,-104(s0)
     8c0:	00000097          	auipc	ra,0x0
     8c4:	5c0080e7          	jalr	1472(ra) # e80 <close>
        close(1);
     8c8:	4505                	li	a0,1
     8ca:	00000097          	auipc	ra,0x0
     8ce:	5b6080e7          	jalr	1462(ra) # e80 <close>
        if(dup(aa[1]) != 1){
     8d2:	f9c42503          	lw	a0,-100(s0)
     8d6:	00000097          	auipc	ra,0x0
     8da:	5fa080e7          	jalr	1530(ra) # ed0 <dup>
     8de:	4785                	li	a5,1
     8e0:	02f50063          	beq	a0,a5,900 <go+0x888>
          fprintf(2, "grind: dup failed\n");
     8e4:	00001597          	auipc	a1,0x1
     8e8:	d1c58593          	add	a1,a1,-740 # 1600 <malloc+0x368>
     8ec:	4509                	li	a0,2
     8ee:	00001097          	auipc	ra,0x1
     8f2:	8c4080e7          	jalr	-1852(ra) # 11b2 <fprintf>
          exit(1);
     8f6:	4505                	li	a0,1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	560080e7          	jalr	1376(ra) # e58 <exit>
        close(aa[1]);
     900:	f9c42503          	lw	a0,-100(s0)
     904:	00000097          	auipc	ra,0x0
     908:	57c080e7          	jalr	1404(ra) # e80 <close>
        char *args[3] = { "echo", "hi", 0 };
     90c:	00001797          	auipc	a5,0x1
     910:	d0c78793          	add	a5,a5,-756 # 1618 <malloc+0x380>
     914:	faf43423          	sd	a5,-88(s0)
     918:	00001797          	auipc	a5,0x1
     91c:	d0878793          	add	a5,a5,-760 # 1620 <malloc+0x388>
     920:	faf43823          	sd	a5,-80(s0)
     924:	fa043c23          	sd	zero,-72(s0)
        exec("grindir/../echo", args);
     928:	fa840593          	add	a1,s0,-88
     92c:	00001517          	auipc	a0,0x1
     930:	cfc50513          	add	a0,a0,-772 # 1628 <malloc+0x390>
     934:	00000097          	auipc	ra,0x0
     938:	55c080e7          	jalr	1372(ra) # e90 <exec>
        fprintf(2, "grind: echo: not found\n");
     93c:	00001597          	auipc	a1,0x1
     940:	cfc58593          	add	a1,a1,-772 # 1638 <malloc+0x3a0>
     944:	4509                	li	a0,2
     946:	00001097          	auipc	ra,0x1
     94a:	86c080e7          	jalr	-1940(ra) # 11b2 <fprintf>
        exit(2);
     94e:	4509                	li	a0,2
     950:	00000097          	auipc	ra,0x0
     954:	508080e7          	jalr	1288(ra) # e58 <exit>
        fprintf(2, "grind: fork failed\n");
     958:	00001597          	auipc	a1,0x1
     95c:	b5858593          	add	a1,a1,-1192 # 14b0 <malloc+0x218>
     960:	4509                	li	a0,2
     962:	00001097          	auipc	ra,0x1
     966:	850080e7          	jalr	-1968(ra) # 11b2 <fprintf>
        exit(3);
     96a:	450d                	li	a0,3
     96c:	00000097          	auipc	ra,0x0
     970:	4ec080e7          	jalr	1260(ra) # e58 <exit>
        close(aa[1]);
     974:	f9c42503          	lw	a0,-100(s0)
     978:	00000097          	auipc	ra,0x0
     97c:	508080e7          	jalr	1288(ra) # e80 <close>
        close(bb[0]);
     980:	fa042503          	lw	a0,-96(s0)
     984:	00000097          	auipc	ra,0x0
     988:	4fc080e7          	jalr	1276(ra) # e80 <close>
        close(0);
     98c:	4501                	li	a0,0
     98e:	00000097          	auipc	ra,0x0
     992:	4f2080e7          	jalr	1266(ra) # e80 <close>
        if(dup(aa[0]) != 0){
     996:	f9842503          	lw	a0,-104(s0)
     99a:	00000097          	auipc	ra,0x0
     99e:	536080e7          	jalr	1334(ra) # ed0 <dup>
     9a2:	cd19                	beqz	a0,9c0 <go+0x948>
          fprintf(2, "grind: dup failed\n");
     9a4:	00001597          	auipc	a1,0x1
     9a8:	c5c58593          	add	a1,a1,-932 # 1600 <malloc+0x368>
     9ac:	4509                	li	a0,2
     9ae:	00001097          	auipc	ra,0x1
     9b2:	804080e7          	jalr	-2044(ra) # 11b2 <fprintf>
          exit(4);
     9b6:	4511                	li	a0,4
     9b8:	00000097          	auipc	ra,0x0
     9bc:	4a0080e7          	jalr	1184(ra) # e58 <exit>
        close(aa[0]);
     9c0:	f9842503          	lw	a0,-104(s0)
     9c4:	00000097          	auipc	ra,0x0
     9c8:	4bc080e7          	jalr	1212(ra) # e80 <close>
        close(1);
     9cc:	4505                	li	a0,1
     9ce:	00000097          	auipc	ra,0x0
     9d2:	4b2080e7          	jalr	1202(ra) # e80 <close>
        if(dup(bb[1]) != 1){
     9d6:	fa442503          	lw	a0,-92(s0)
     9da:	00000097          	auipc	ra,0x0
     9de:	4f6080e7          	jalr	1270(ra) # ed0 <dup>
     9e2:	4785                	li	a5,1
     9e4:	02f50063          	beq	a0,a5,a04 <go+0x98c>
          fprintf(2, "grind: dup failed\n");
     9e8:	00001597          	auipc	a1,0x1
     9ec:	c1858593          	add	a1,a1,-1000 # 1600 <malloc+0x368>
     9f0:	4509                	li	a0,2
     9f2:	00000097          	auipc	ra,0x0
     9f6:	7c0080e7          	jalr	1984(ra) # 11b2 <fprintf>
          exit(5);
     9fa:	4515                	li	a0,5
     9fc:	00000097          	auipc	ra,0x0
     a00:	45c080e7          	jalr	1116(ra) # e58 <exit>
        close(bb[1]);
     a04:	fa442503          	lw	a0,-92(s0)
     a08:	00000097          	auipc	ra,0x0
     a0c:	478080e7          	jalr	1144(ra) # e80 <close>
        char *args[2] = { "cat", 0 };
     a10:	00001797          	auipc	a5,0x1
     a14:	c4078793          	add	a5,a5,-960 # 1650 <malloc+0x3b8>
     a18:	faf43423          	sd	a5,-88(s0)
     a1c:	fa043823          	sd	zero,-80(s0)
        exec("/cat", args);
     a20:	fa840593          	add	a1,s0,-88
     a24:	00001517          	auipc	a0,0x1
     a28:	c3450513          	add	a0,a0,-972 # 1658 <malloc+0x3c0>
     a2c:	00000097          	auipc	ra,0x0
     a30:	464080e7          	jalr	1124(ra) # e90 <exec>
        fprintf(2, "grind: cat: not found\n");
     a34:	00001597          	auipc	a1,0x1
     a38:	c2c58593          	add	a1,a1,-980 # 1660 <malloc+0x3c8>
     a3c:	4509                	li	a0,2
     a3e:	00000097          	auipc	ra,0x0
     a42:	774080e7          	jalr	1908(ra) # 11b2 <fprintf>
        exit(6);
     a46:	4519                	li	a0,6
     a48:	00000097          	auipc	ra,0x0
     a4c:	410080e7          	jalr	1040(ra) # e58 <exit>
        fprintf(2, "grind: fork failed\n");
     a50:	00001597          	auipc	a1,0x1
     a54:	a6058593          	add	a1,a1,-1440 # 14b0 <malloc+0x218>
     a58:	4509                	li	a0,2
     a5a:	00000097          	auipc	ra,0x0
     a5e:	758080e7          	jalr	1880(ra) # 11b2 <fprintf>
        exit(7);
     a62:	451d                	li	a0,7
     a64:	00000097          	auipc	ra,0x0
     a68:	3f4080e7          	jalr	1012(ra) # e58 <exit>

0000000000000a6c <iter>:
  }
}

void
iter()
{
     a6c:	7179                	add	sp,sp,-48
     a6e:	f406                	sd	ra,40(sp)
     a70:	f022                	sd	s0,32(sp)
     a72:	1800                	add	s0,sp,48
  unlink("a");
     a74:	00001517          	auipc	a0,0x1
     a78:	a5450513          	add	a0,a0,-1452 # 14c8 <malloc+0x230>
     a7c:	00000097          	auipc	ra,0x0
     a80:	42c080e7          	jalr	1068(ra) # ea8 <unlink>
  unlink("b");
     a84:	00001517          	auipc	a0,0x1
     a88:	9f450513          	add	a0,a0,-1548 # 1478 <malloc+0x1e0>
     a8c:	00000097          	auipc	ra,0x0
     a90:	41c080e7          	jalr	1052(ra) # ea8 <unlink>
  
  int pid1 = fork();
     a94:	00000097          	auipc	ra,0x0
     a98:	3bc080e7          	jalr	956(ra) # e50 <fork>
  if(pid1 < 0){
     a9c:	02054363          	bltz	a0,ac2 <iter+0x56>
     aa0:	ec26                	sd	s1,24(sp)
     aa2:	84aa                	mv	s1,a0
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid1 == 0){
     aa4:	ed15                	bnez	a0,ae0 <iter+0x74>
     aa6:	e84a                	sd	s2,16(sp)
    rand_next ^= 31;
     aa8:	00001717          	auipc	a4,0x1
     aac:	55870713          	add	a4,a4,1368 # 2000 <rand_next>
     ab0:	631c                	ld	a5,0(a4)
     ab2:	01f7c793          	xor	a5,a5,31
     ab6:	e31c                	sd	a5,0(a4)
    go(0);
     ab8:	4501                	li	a0,0
     aba:	fffff097          	auipc	ra,0xfffff
     abe:	5be080e7          	jalr	1470(ra) # 78 <go>
     ac2:	ec26                	sd	s1,24(sp)
     ac4:	e84a                	sd	s2,16(sp)
    printf("grind: fork failed\n");
     ac6:	00001517          	auipc	a0,0x1
     aca:	9ea50513          	add	a0,a0,-1558 # 14b0 <malloc+0x218>
     ace:	00000097          	auipc	ra,0x0
     ad2:	712080e7          	jalr	1810(ra) # 11e0 <printf>
    exit(1);
     ad6:	4505                	li	a0,1
     ad8:	00000097          	auipc	ra,0x0
     adc:	380080e7          	jalr	896(ra) # e58 <exit>
     ae0:	e84a                	sd	s2,16(sp)
    exit(0);
  }

  int pid2 = fork();
     ae2:	00000097          	auipc	ra,0x0
     ae6:	36e080e7          	jalr	878(ra) # e50 <fork>
     aea:	892a                	mv	s2,a0
  if(pid2 < 0){
     aec:	02054263          	bltz	a0,b10 <iter+0xa4>
    printf("grind: fork failed\n");
    exit(1);
  }
  if(pid2 == 0){
     af0:	ed0d                	bnez	a0,b2a <iter+0xbe>
    rand_next ^= 7177;
     af2:	00001697          	auipc	a3,0x1
     af6:	50e68693          	add	a3,a3,1294 # 2000 <rand_next>
     afa:	629c                	ld	a5,0(a3)
     afc:	6709                	lui	a4,0x2
     afe:	c0970713          	add	a4,a4,-1015 # 1c09 <digits+0x4a1>
     b02:	8fb9                	xor	a5,a5,a4
     b04:	e29c                	sd	a5,0(a3)
    go(1);
     b06:	4505                	li	a0,1
     b08:	fffff097          	auipc	ra,0xfffff
     b0c:	570080e7          	jalr	1392(ra) # 78 <go>
    printf("grind: fork failed\n");
     b10:	00001517          	auipc	a0,0x1
     b14:	9a050513          	add	a0,a0,-1632 # 14b0 <malloc+0x218>
     b18:	00000097          	auipc	ra,0x0
     b1c:	6c8080e7          	jalr	1736(ra) # 11e0 <printf>
    exit(1);
     b20:	4505                	li	a0,1
     b22:	00000097          	auipc	ra,0x0
     b26:	336080e7          	jalr	822(ra) # e58 <exit>
    exit(0);
  }

  int st1 = -1;
     b2a:	57fd                	li	a5,-1
     b2c:	fcf42e23          	sw	a5,-36(s0)
  wait(&st1);
     b30:	fdc40513          	add	a0,s0,-36
     b34:	00000097          	auipc	ra,0x0
     b38:	32c080e7          	jalr	812(ra) # e60 <wait>
  if(st1 != 0){
     b3c:	fdc42783          	lw	a5,-36(s0)
     b40:	ef99                	bnez	a5,b5e <iter+0xf2>
    kill(pid1);
    kill(pid2);
  }
  int st2 = -1;
     b42:	57fd                	li	a5,-1
     b44:	fcf42c23          	sw	a5,-40(s0)
  wait(&st2);
     b48:	fd840513          	add	a0,s0,-40
     b4c:	00000097          	auipc	ra,0x0
     b50:	314080e7          	jalr	788(ra) # e60 <wait>

  exit(0);
     b54:	4501                	li	a0,0
     b56:	00000097          	auipc	ra,0x0
     b5a:	302080e7          	jalr	770(ra) # e58 <exit>
    kill(pid1);
     b5e:	8526                	mv	a0,s1
     b60:	00000097          	auipc	ra,0x0
     b64:	328080e7          	jalr	808(ra) # e88 <kill>
    kill(pid2);
     b68:	854a                	mv	a0,s2
     b6a:	00000097          	auipc	ra,0x0
     b6e:	31e080e7          	jalr	798(ra) # e88 <kill>
     b72:	bfc1                	j	b42 <iter+0xd6>

0000000000000b74 <main>:
}

int
main()
{
     b74:	1101                	add	sp,sp,-32
     b76:	ec06                	sd	ra,24(sp)
     b78:	e822                	sd	s0,16(sp)
     b7a:	e426                	sd	s1,8(sp)
     b7c:	1000                	add	s0,sp,32
    }
    if(pid > 0){
      wait(0);
    }
    sleep(20);
    rand_next += 1;
     b7e:	00001497          	auipc	s1,0x1
     b82:	48248493          	add	s1,s1,1154 # 2000 <rand_next>
     b86:	a829                	j	ba0 <main+0x2c>
      iter();
     b88:	00000097          	auipc	ra,0x0
     b8c:	ee4080e7          	jalr	-284(ra) # a6c <iter>
    sleep(20);
     b90:	4551                	li	a0,20
     b92:	00000097          	auipc	ra,0x0
     b96:	356080e7          	jalr	854(ra) # ee8 <sleep>
    rand_next += 1;
     b9a:	609c                	ld	a5,0(s1)
     b9c:	0785                	add	a5,a5,1
     b9e:	e09c                	sd	a5,0(s1)
    int pid = fork();
     ba0:	00000097          	auipc	ra,0x0
     ba4:	2b0080e7          	jalr	688(ra) # e50 <fork>
    if(pid == 0){
     ba8:	d165                	beqz	a0,b88 <main+0x14>
    if(pid > 0){
     baa:	fea053e3          	blez	a0,b90 <main+0x1c>
      wait(0);
     bae:	4501                	li	a0,0
     bb0:	00000097          	auipc	ra,0x0
     bb4:	2b0080e7          	jalr	688(ra) # e60 <wait>
     bb8:	bfe1                	j	b90 <main+0x1c>

0000000000000bba <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     bba:	1141                	add	sp,sp,-16
     bbc:	e406                	sd	ra,8(sp)
     bbe:	e022                	sd	s0,0(sp)
     bc0:	0800                	add	s0,sp,16
  extern int main();
  main();
     bc2:	00000097          	auipc	ra,0x0
     bc6:	fb2080e7          	jalr	-78(ra) # b74 <main>
  exit(0);
     bca:	4501                	li	a0,0
     bcc:	00000097          	auipc	ra,0x0
     bd0:	28c080e7          	jalr	652(ra) # e58 <exit>

0000000000000bd4 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     bd4:	1141                	add	sp,sp,-16
     bd6:	e422                	sd	s0,8(sp)
     bd8:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     bda:	87aa                	mv	a5,a0
     bdc:	0585                	add	a1,a1,1
     bde:	0785                	add	a5,a5,1
     be0:	fff5c703          	lbu	a4,-1(a1)
     be4:	fee78fa3          	sb	a4,-1(a5)
     be8:	fb75                	bnez	a4,bdc <strcpy+0x8>
    ;
  return os;
}
     bea:	6422                	ld	s0,8(sp)
     bec:	0141                	add	sp,sp,16
     bee:	8082                	ret

0000000000000bf0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     bf0:	1141                	add	sp,sp,-16
     bf2:	e422                	sd	s0,8(sp)
     bf4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     bf6:	00054783          	lbu	a5,0(a0)
     bfa:	cb91                	beqz	a5,c0e <strcmp+0x1e>
     bfc:	0005c703          	lbu	a4,0(a1)
     c00:	00f71763          	bne	a4,a5,c0e <strcmp+0x1e>
    p++, q++;
     c04:	0505                	add	a0,a0,1
     c06:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     c08:	00054783          	lbu	a5,0(a0)
     c0c:	fbe5                	bnez	a5,bfc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     c0e:	0005c503          	lbu	a0,0(a1)
}
     c12:	40a7853b          	subw	a0,a5,a0
     c16:	6422                	ld	s0,8(sp)
     c18:	0141                	add	sp,sp,16
     c1a:	8082                	ret

0000000000000c1c <strlen>:

uint
strlen(const char *s)
{
     c1c:	1141                	add	sp,sp,-16
     c1e:	e422                	sd	s0,8(sp)
     c20:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     c22:	00054783          	lbu	a5,0(a0)
     c26:	cf91                	beqz	a5,c42 <strlen+0x26>
     c28:	0505                	add	a0,a0,1
     c2a:	87aa                	mv	a5,a0
     c2c:	86be                	mv	a3,a5
     c2e:	0785                	add	a5,a5,1
     c30:	fff7c703          	lbu	a4,-1(a5)
     c34:	ff65                	bnez	a4,c2c <strlen+0x10>
     c36:	40a6853b          	subw	a0,a3,a0
     c3a:	2505                	addw	a0,a0,1
    ;
  return n;
}
     c3c:	6422                	ld	s0,8(sp)
     c3e:	0141                	add	sp,sp,16
     c40:	8082                	ret
  for(n = 0; s[n]; n++)
     c42:	4501                	li	a0,0
     c44:	bfe5                	j	c3c <strlen+0x20>

0000000000000c46 <memset>:

void*
memset(void *dst, int c, uint n)
{
     c46:	1141                	add	sp,sp,-16
     c48:	e422                	sd	s0,8(sp)
     c4a:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     c4c:	ca19                	beqz	a2,c62 <memset+0x1c>
     c4e:	87aa                	mv	a5,a0
     c50:	1602                	sll	a2,a2,0x20
     c52:	9201                	srl	a2,a2,0x20
     c54:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c58:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c5c:	0785                	add	a5,a5,1
     c5e:	fee79de3          	bne	a5,a4,c58 <memset+0x12>
  }
  return dst;
}
     c62:	6422                	ld	s0,8(sp)
     c64:	0141                	add	sp,sp,16
     c66:	8082                	ret

0000000000000c68 <strchr>:

char*
strchr(const char *s, char c)
{
     c68:	1141                	add	sp,sp,-16
     c6a:	e422                	sd	s0,8(sp)
     c6c:	0800                	add	s0,sp,16
  for(; *s; s++)
     c6e:	00054783          	lbu	a5,0(a0)
     c72:	cb99                	beqz	a5,c88 <strchr+0x20>
    if(*s == c)
     c74:	00f58763          	beq	a1,a5,c82 <strchr+0x1a>
  for(; *s; s++)
     c78:	0505                	add	a0,a0,1
     c7a:	00054783          	lbu	a5,0(a0)
     c7e:	fbfd                	bnez	a5,c74 <strchr+0xc>
      return (char*)s;
  return 0;
     c80:	4501                	li	a0,0
}
     c82:	6422                	ld	s0,8(sp)
     c84:	0141                	add	sp,sp,16
     c86:	8082                	ret
  return 0;
     c88:	4501                	li	a0,0
     c8a:	bfe5                	j	c82 <strchr+0x1a>

0000000000000c8c <gets>:

char*
gets(char *buf, int max)
{
     c8c:	711d                	add	sp,sp,-96
     c8e:	ec86                	sd	ra,88(sp)
     c90:	e8a2                	sd	s0,80(sp)
     c92:	e4a6                	sd	s1,72(sp)
     c94:	e0ca                	sd	s2,64(sp)
     c96:	fc4e                	sd	s3,56(sp)
     c98:	f852                	sd	s4,48(sp)
     c9a:	f456                	sd	s5,40(sp)
     c9c:	f05a                	sd	s6,32(sp)
     c9e:	ec5e                	sd	s7,24(sp)
     ca0:	1080                	add	s0,sp,96
     ca2:	8baa                	mv	s7,a0
     ca4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     ca6:	892a                	mv	s2,a0
     ca8:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     caa:	4aa9                	li	s5,10
     cac:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     cae:	89a6                	mv	s3,s1
     cb0:	2485                	addw	s1,s1,1
     cb2:	0344d863          	bge	s1,s4,ce2 <gets+0x56>
    cc = read(0, &c, 1);
     cb6:	4605                	li	a2,1
     cb8:	faf40593          	add	a1,s0,-81
     cbc:	4501                	li	a0,0
     cbe:	00000097          	auipc	ra,0x0
     cc2:	1b2080e7          	jalr	434(ra) # e70 <read>
    if(cc < 1)
     cc6:	00a05e63          	blez	a0,ce2 <gets+0x56>
    buf[i++] = c;
     cca:	faf44783          	lbu	a5,-81(s0)
     cce:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     cd2:	01578763          	beq	a5,s5,ce0 <gets+0x54>
     cd6:	0905                	add	s2,s2,1
     cd8:	fd679be3          	bne	a5,s6,cae <gets+0x22>
    buf[i++] = c;
     cdc:	89a6                	mv	s3,s1
     cde:	a011                	j	ce2 <gets+0x56>
     ce0:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ce2:	99de                	add	s3,s3,s7
     ce4:	00098023          	sb	zero,0(s3)
  return buf;
}
     ce8:	855e                	mv	a0,s7
     cea:	60e6                	ld	ra,88(sp)
     cec:	6446                	ld	s0,80(sp)
     cee:	64a6                	ld	s1,72(sp)
     cf0:	6906                	ld	s2,64(sp)
     cf2:	79e2                	ld	s3,56(sp)
     cf4:	7a42                	ld	s4,48(sp)
     cf6:	7aa2                	ld	s5,40(sp)
     cf8:	7b02                	ld	s6,32(sp)
     cfa:	6be2                	ld	s7,24(sp)
     cfc:	6125                	add	sp,sp,96
     cfe:	8082                	ret

0000000000000d00 <stat>:

int
stat(const char *n, struct stat *st)
{
     d00:	1101                	add	sp,sp,-32
     d02:	ec06                	sd	ra,24(sp)
     d04:	e822                	sd	s0,16(sp)
     d06:	e04a                	sd	s2,0(sp)
     d08:	1000                	add	s0,sp,32
     d0a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     d0c:	4581                	li	a1,0
     d0e:	00000097          	auipc	ra,0x0
     d12:	18a080e7          	jalr	394(ra) # e98 <open>
  if(fd < 0)
     d16:	02054663          	bltz	a0,d42 <stat+0x42>
     d1a:	e426                	sd	s1,8(sp)
     d1c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     d1e:	85ca                	mv	a1,s2
     d20:	00000097          	auipc	ra,0x0
     d24:	190080e7          	jalr	400(ra) # eb0 <fstat>
     d28:	892a                	mv	s2,a0
  close(fd);
     d2a:	8526                	mv	a0,s1
     d2c:	00000097          	auipc	ra,0x0
     d30:	154080e7          	jalr	340(ra) # e80 <close>
  return r;
     d34:	64a2                	ld	s1,8(sp)
}
     d36:	854a                	mv	a0,s2
     d38:	60e2                	ld	ra,24(sp)
     d3a:	6442                	ld	s0,16(sp)
     d3c:	6902                	ld	s2,0(sp)
     d3e:	6105                	add	sp,sp,32
     d40:	8082                	ret
    return -1;
     d42:	597d                	li	s2,-1
     d44:	bfcd                	j	d36 <stat+0x36>

0000000000000d46 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
     d46:	1141                	add	sp,sp,-16
     d48:	e422                	sd	s0,8(sp)
     d4a:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
     d4c:	00054703          	lbu	a4,0(a0)
     d50:	02d00793          	li	a5,45
     d54:	4585                	li	a1,1
     d56:	04f70363          	beq	a4,a5,d9c <atoi+0x56>

  while('0' <= *s && *s <= '9')
     d5a:	00054703          	lbu	a4,0(a0)
     d5e:	fd07079b          	addw	a5,a4,-48
     d62:	0ff7f793          	zext.b	a5,a5
     d66:	46a5                	li	a3,9
     d68:	02f6ed63          	bltu	a3,a5,da2 <atoi+0x5c>
  int n = 0;
     d6c:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
     d6e:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
     d70:	0505                	add	a0,a0,1
     d72:	0026979b          	sllw	a5,a3,0x2
     d76:	9fb5                	addw	a5,a5,a3
     d78:	0017979b          	sllw	a5,a5,0x1
     d7c:	9fb9                	addw	a5,a5,a4
     d7e:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
     d82:	00054703          	lbu	a4,0(a0)
     d86:	fd07079b          	addw	a5,a4,-48
     d8a:	0ff7f793          	zext.b	a5,a5
     d8e:	fef671e3          	bgeu	a2,a5,d70 <atoi+0x2a>
  return sign * n;
}
     d92:	02d5853b          	mulw	a0,a1,a3
     d96:	6422                	ld	s0,8(sp)
     d98:	0141                	add	sp,sp,16
     d9a:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
     d9c:	0505                	add	a0,a0,1
     d9e:	55fd                	li	a1,-1
     da0:	bf6d                	j	d5a <atoi+0x14>
  int n = 0;
     da2:	4681                	li	a3,0
     da4:	b7fd                	j	d92 <atoi+0x4c>

0000000000000da6 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
     da6:	1141                	add	sp,sp,-16
     da8:	e422                	sd	s0,8(sp)
     daa:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     dac:	02b57463          	bgeu	a0,a1,dd4 <memmove+0x2e>
    while(n-- > 0)
     db0:	00c05f63          	blez	a2,dce <memmove+0x28>
     db4:	1602                	sll	a2,a2,0x20
     db6:	9201                	srl	a2,a2,0x20
     db8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     dbc:	872a                	mv	a4,a0
      *dst++ = *src++;
     dbe:	0585                	add	a1,a1,1
     dc0:	0705                	add	a4,a4,1
     dc2:	fff5c683          	lbu	a3,-1(a1)
     dc6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     dca:	fef71ae3          	bne	a4,a5,dbe <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     dce:	6422                	ld	s0,8(sp)
     dd0:	0141                	add	sp,sp,16
     dd2:	8082                	ret
    dst += n;
     dd4:	00c50733          	add	a4,a0,a2
    src += n;
     dd8:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     dda:	fec05ae3          	blez	a2,dce <memmove+0x28>
     dde:	fff6079b          	addw	a5,a2,-1
     de2:	1782                	sll	a5,a5,0x20
     de4:	9381                	srl	a5,a5,0x20
     de6:	fff7c793          	not	a5,a5
     dea:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     dec:	15fd                	add	a1,a1,-1
     dee:	177d                	add	a4,a4,-1
     df0:	0005c683          	lbu	a3,0(a1)
     df4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     df8:	fee79ae3          	bne	a5,a4,dec <memmove+0x46>
     dfc:	bfc9                	j	dce <memmove+0x28>

0000000000000dfe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dfe:	1141                	add	sp,sp,-16
     e00:	e422                	sd	s0,8(sp)
     e02:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     e04:	ca05                	beqz	a2,e34 <memcmp+0x36>
     e06:	fff6069b          	addw	a3,a2,-1
     e0a:	1682                	sll	a3,a3,0x20
     e0c:	9281                	srl	a3,a3,0x20
     e0e:	0685                	add	a3,a3,1
     e10:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     e12:	00054783          	lbu	a5,0(a0)
     e16:	0005c703          	lbu	a4,0(a1)
     e1a:	00e79863          	bne	a5,a4,e2a <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     e1e:	0505                	add	a0,a0,1
    p2++;
     e20:	0585                	add	a1,a1,1
  while (n-- > 0) {
     e22:	fed518e3          	bne	a0,a3,e12 <memcmp+0x14>
  }
  return 0;
     e26:	4501                	li	a0,0
     e28:	a019                	j	e2e <memcmp+0x30>
      return *p1 - *p2;
     e2a:	40e7853b          	subw	a0,a5,a4
}
     e2e:	6422                	ld	s0,8(sp)
     e30:	0141                	add	sp,sp,16
     e32:	8082                	ret
  return 0;
     e34:	4501                	li	a0,0
     e36:	bfe5                	j	e2e <memcmp+0x30>

0000000000000e38 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     e38:	1141                	add	sp,sp,-16
     e3a:	e406                	sd	ra,8(sp)
     e3c:	e022                	sd	s0,0(sp)
     e3e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     e40:	00000097          	auipc	ra,0x0
     e44:	f66080e7          	jalr	-154(ra) # da6 <memmove>
}
     e48:	60a2                	ld	ra,8(sp)
     e4a:	6402                	ld	s0,0(sp)
     e4c:	0141                	add	sp,sp,16
     e4e:	8082                	ret

0000000000000e50 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e50:	4885                	li	a7,1
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e58:	4889                	li	a7,2
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e60:	488d                	li	a7,3
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e68:	4891                	li	a7,4
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <read>:
.global read
read:
 li a7, SYS_read
     e70:	4895                	li	a7,5
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <write>:
.global write
write:
 li a7, SYS_write
     e78:	48c1                	li	a7,16
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <close>:
.global close
close:
 li a7, SYS_close
     e80:	48d5                	li	a7,21
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e88:	4899                	li	a7,6
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e90:	489d                	li	a7,7
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <open>:
.global open
open:
 li a7, SYS_open
     e98:	48bd                	li	a7,15
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     ea0:	48c5                	li	a7,17
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ea8:	48c9                	li	a7,18
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     eb0:	48a1                	li	a7,8
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <link>:
.global link
link:
 li a7, SYS_link
     eb8:	48cd                	li	a7,19
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     ec0:	48d1                	li	a7,20
 ecall
     ec2:	00000073          	ecall
 ret
     ec6:	8082                	ret

0000000000000ec8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     ec8:	48a5                	li	a7,9
 ecall
     eca:	00000073          	ecall
 ret
     ece:	8082                	ret

0000000000000ed0 <dup>:
.global dup
dup:
 li a7, SYS_dup
     ed0:	48a9                	li	a7,10
 ecall
     ed2:	00000073          	ecall
 ret
     ed6:	8082                	ret

0000000000000ed8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     ed8:	48ad                	li	a7,11
 ecall
     eda:	00000073          	ecall
 ret
     ede:	8082                	ret

0000000000000ee0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ee0:	48b1                	li	a7,12
 ecall
     ee2:	00000073          	ecall
 ret
     ee6:	8082                	ret

0000000000000ee8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ee8:	48b5                	li	a7,13
 ecall
     eea:	00000073          	ecall
 ret
     eee:	8082                	ret

0000000000000ef0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ef0:	48b9                	li	a7,14
 ecall
     ef2:	00000073          	ecall
 ret
     ef6:	8082                	ret

0000000000000ef8 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
     ef8:	48d9                	li	a7,22
 ecall
     efa:	00000073          	ecall
 ret
     efe:	8082                	ret

0000000000000f00 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
     f00:	48dd                	li	a7,23
 ecall
     f02:	00000073          	ecall
 ret
     f06:	8082                	ret

0000000000000f08 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     f08:	48e1                	li	a7,24
 ecall
     f0a:	00000073          	ecall
 ret
     f0e:	8082                	ret

0000000000000f10 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     f10:	48e5                	li	a7,25
 ecall
     f12:	00000073          	ecall
 ret
     f16:	8082                	ret

0000000000000f18 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     f18:	1101                	add	sp,sp,-32
     f1a:	ec06                	sd	ra,24(sp)
     f1c:	e822                	sd	s0,16(sp)
     f1e:	1000                	add	s0,sp,32
     f20:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     f24:	4605                	li	a2,1
     f26:	fef40593          	add	a1,s0,-17
     f2a:	00000097          	auipc	ra,0x0
     f2e:	f4e080e7          	jalr	-178(ra) # e78 <write>
}
     f32:	60e2                	ld	ra,24(sp)
     f34:	6442                	ld	s0,16(sp)
     f36:	6105                	add	sp,sp,32
     f38:	8082                	ret

0000000000000f3a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f3a:	7139                	add	sp,sp,-64
     f3c:	fc06                	sd	ra,56(sp)
     f3e:	f822                	sd	s0,48(sp)
     f40:	f426                	sd	s1,40(sp)
     f42:	0080                	add	s0,sp,64
     f44:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f46:	c299                	beqz	a3,f4c <printint+0x12>
     f48:	0805cb63          	bltz	a1,fde <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f4c:	2581                	sext.w	a1,a1
  neg = 0;
     f4e:	4881                	li	a7,0
     f50:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     f54:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f56:	2601                	sext.w	a2,a2
     f58:	00001517          	auipc	a0,0x1
     f5c:	81050513          	add	a0,a0,-2032 # 1768 <digits>
     f60:	883a                	mv	a6,a4
     f62:	2705                	addw	a4,a4,1
     f64:	02c5f7bb          	remuw	a5,a1,a2
     f68:	1782                	sll	a5,a5,0x20
     f6a:	9381                	srl	a5,a5,0x20
     f6c:	97aa                	add	a5,a5,a0
     f6e:	0007c783          	lbu	a5,0(a5)
     f72:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f76:	0005879b          	sext.w	a5,a1
     f7a:	02c5d5bb          	divuw	a1,a1,a2
     f7e:	0685                	add	a3,a3,1
     f80:	fec7f0e3          	bgeu	a5,a2,f60 <printint+0x26>
  if(neg)
     f84:	00088c63          	beqz	a7,f9c <printint+0x62>
    buf[i++] = '-';
     f88:	fd070793          	add	a5,a4,-48
     f8c:	00878733          	add	a4,a5,s0
     f90:	02d00793          	li	a5,45
     f94:	fef70823          	sb	a5,-16(a4)
     f98:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f9c:	02e05c63          	blez	a4,fd4 <printint+0x9a>
     fa0:	f04a                	sd	s2,32(sp)
     fa2:	ec4e                	sd	s3,24(sp)
     fa4:	fc040793          	add	a5,s0,-64
     fa8:	00e78933          	add	s2,a5,a4
     fac:	fff78993          	add	s3,a5,-1
     fb0:	99ba                	add	s3,s3,a4
     fb2:	377d                	addw	a4,a4,-1
     fb4:	1702                	sll	a4,a4,0x20
     fb6:	9301                	srl	a4,a4,0x20
     fb8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     fbc:	fff94583          	lbu	a1,-1(s2)
     fc0:	8526                	mv	a0,s1
     fc2:	00000097          	auipc	ra,0x0
     fc6:	f56080e7          	jalr	-170(ra) # f18 <putc>
  while(--i >= 0)
     fca:	197d                	add	s2,s2,-1
     fcc:	ff3918e3          	bne	s2,s3,fbc <printint+0x82>
     fd0:	7902                	ld	s2,32(sp)
     fd2:	69e2                	ld	s3,24(sp)
}
     fd4:	70e2                	ld	ra,56(sp)
     fd6:	7442                	ld	s0,48(sp)
     fd8:	74a2                	ld	s1,40(sp)
     fda:	6121                	add	sp,sp,64
     fdc:	8082                	ret
    x = -xx;
     fde:	40b005bb          	negw	a1,a1
    neg = 1;
     fe2:	4885                	li	a7,1
    x = -xx;
     fe4:	b7b5                	j	f50 <printint+0x16>

0000000000000fe6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     fe6:	715d                	add	sp,sp,-80
     fe8:	e486                	sd	ra,72(sp)
     fea:	e0a2                	sd	s0,64(sp)
     fec:	f84a                	sd	s2,48(sp)
     fee:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     ff0:	0005c903          	lbu	s2,0(a1)
     ff4:	1a090a63          	beqz	s2,11a8 <vprintf+0x1c2>
     ff8:	fc26                	sd	s1,56(sp)
     ffa:	f44e                	sd	s3,40(sp)
     ffc:	f052                	sd	s4,32(sp)
     ffe:	ec56                	sd	s5,24(sp)
    1000:	e85a                	sd	s6,16(sp)
    1002:	e45e                	sd	s7,8(sp)
    1004:	8aaa                	mv	s5,a0
    1006:	8bb2                	mv	s7,a2
    1008:	00158493          	add	s1,a1,1
  state = 0;
    100c:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    100e:	02500a13          	li	s4,37
    1012:	4b55                	li	s6,21
    1014:	a839                	j	1032 <vprintf+0x4c>
        putc(fd, c);
    1016:	85ca                	mv	a1,s2
    1018:	8556                	mv	a0,s5
    101a:	00000097          	auipc	ra,0x0
    101e:	efe080e7          	jalr	-258(ra) # f18 <putc>
    1022:	a019                	j	1028 <vprintf+0x42>
    } else if(state == '%'){
    1024:	01498d63          	beq	s3,s4,103e <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
    1028:	0485                	add	s1,s1,1
    102a:	fff4c903          	lbu	s2,-1(s1)
    102e:	16090763          	beqz	s2,119c <vprintf+0x1b6>
    if(state == 0){
    1032:	fe0999e3          	bnez	s3,1024 <vprintf+0x3e>
      if(c == '%'){
    1036:	ff4910e3          	bne	s2,s4,1016 <vprintf+0x30>
        state = '%';
    103a:	89d2                	mv	s3,s4
    103c:	b7f5                	j	1028 <vprintf+0x42>
      if(c == 'd'){
    103e:	13490463          	beq	s2,s4,1166 <vprintf+0x180>
    1042:	f9d9079b          	addw	a5,s2,-99
    1046:	0ff7f793          	zext.b	a5,a5
    104a:	12fb6763          	bltu	s6,a5,1178 <vprintf+0x192>
    104e:	f9d9079b          	addw	a5,s2,-99
    1052:	0ff7f713          	zext.b	a4,a5
    1056:	12eb6163          	bltu	s6,a4,1178 <vprintf+0x192>
    105a:	00271793          	sll	a5,a4,0x2
    105e:	00000717          	auipc	a4,0x0
    1062:	6b270713          	add	a4,a4,1714 # 1710 <malloc+0x478>
    1066:	97ba                	add	a5,a5,a4
    1068:	439c                	lw	a5,0(a5)
    106a:	97ba                	add	a5,a5,a4
    106c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    106e:	008b8913          	add	s2,s7,8
    1072:	4685                	li	a3,1
    1074:	4629                	li	a2,10
    1076:	000ba583          	lw	a1,0(s7)
    107a:	8556                	mv	a0,s5
    107c:	00000097          	auipc	ra,0x0
    1080:	ebe080e7          	jalr	-322(ra) # f3a <printint>
    1084:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1086:	4981                	li	s3,0
    1088:	b745                	j	1028 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    108a:	008b8913          	add	s2,s7,8
    108e:	4681                	li	a3,0
    1090:	4629                	li	a2,10
    1092:	000ba583          	lw	a1,0(s7)
    1096:	8556                	mv	a0,s5
    1098:	00000097          	auipc	ra,0x0
    109c:	ea2080e7          	jalr	-350(ra) # f3a <printint>
    10a0:	8bca                	mv	s7,s2
      state = 0;
    10a2:	4981                	li	s3,0
    10a4:	b751                	j	1028 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    10a6:	008b8913          	add	s2,s7,8
    10aa:	4681                	li	a3,0
    10ac:	4641                	li	a2,16
    10ae:	000ba583          	lw	a1,0(s7)
    10b2:	8556                	mv	a0,s5
    10b4:	00000097          	auipc	ra,0x0
    10b8:	e86080e7          	jalr	-378(ra) # f3a <printint>
    10bc:	8bca                	mv	s7,s2
      state = 0;
    10be:	4981                	li	s3,0
    10c0:	b7a5                	j	1028 <vprintf+0x42>
    10c2:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    10c4:	008b8c13          	add	s8,s7,8
    10c8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    10cc:	03000593          	li	a1,48
    10d0:	8556                	mv	a0,s5
    10d2:	00000097          	auipc	ra,0x0
    10d6:	e46080e7          	jalr	-442(ra) # f18 <putc>
  putc(fd, 'x');
    10da:	07800593          	li	a1,120
    10de:	8556                	mv	a0,s5
    10e0:	00000097          	auipc	ra,0x0
    10e4:	e38080e7          	jalr	-456(ra) # f18 <putc>
    10e8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    10ea:	00000b97          	auipc	s7,0x0
    10ee:	67eb8b93          	add	s7,s7,1662 # 1768 <digits>
    10f2:	03c9d793          	srl	a5,s3,0x3c
    10f6:	97de                	add	a5,a5,s7
    10f8:	0007c583          	lbu	a1,0(a5)
    10fc:	8556                	mv	a0,s5
    10fe:	00000097          	auipc	ra,0x0
    1102:	e1a080e7          	jalr	-486(ra) # f18 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1106:	0992                	sll	s3,s3,0x4
    1108:	397d                	addw	s2,s2,-1
    110a:	fe0914e3          	bnez	s2,10f2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    110e:	8be2                	mv	s7,s8
      state = 0;
    1110:	4981                	li	s3,0
    1112:	6c02                	ld	s8,0(sp)
    1114:	bf11                	j	1028 <vprintf+0x42>
        s = va_arg(ap, char*);
    1116:	008b8993          	add	s3,s7,8
    111a:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    111e:	02090163          	beqz	s2,1140 <vprintf+0x15a>
        while(*s != 0){
    1122:	00094583          	lbu	a1,0(s2)
    1126:	c9a5                	beqz	a1,1196 <vprintf+0x1b0>
          putc(fd, *s);
    1128:	8556                	mv	a0,s5
    112a:	00000097          	auipc	ra,0x0
    112e:	dee080e7          	jalr	-530(ra) # f18 <putc>
          s++;
    1132:	0905                	add	s2,s2,1
        while(*s != 0){
    1134:	00094583          	lbu	a1,0(s2)
    1138:	f9e5                	bnez	a1,1128 <vprintf+0x142>
        s = va_arg(ap, char*);
    113a:	8bce                	mv	s7,s3
      state = 0;
    113c:	4981                	li	s3,0
    113e:	b5ed                	j	1028 <vprintf+0x42>
          s = "(null)";
    1140:	00000917          	auipc	s2,0x0
    1144:	56890913          	add	s2,s2,1384 # 16a8 <malloc+0x410>
        while(*s != 0){
    1148:	02800593          	li	a1,40
    114c:	bff1                	j	1128 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    114e:	008b8913          	add	s2,s7,8
    1152:	000bc583          	lbu	a1,0(s7)
    1156:	8556                	mv	a0,s5
    1158:	00000097          	auipc	ra,0x0
    115c:	dc0080e7          	jalr	-576(ra) # f18 <putc>
    1160:	8bca                	mv	s7,s2
      state = 0;
    1162:	4981                	li	s3,0
    1164:	b5d1                	j	1028 <vprintf+0x42>
        putc(fd, c);
    1166:	02500593          	li	a1,37
    116a:	8556                	mv	a0,s5
    116c:	00000097          	auipc	ra,0x0
    1170:	dac080e7          	jalr	-596(ra) # f18 <putc>
      state = 0;
    1174:	4981                	li	s3,0
    1176:	bd4d                	j	1028 <vprintf+0x42>
        putc(fd, '%');
    1178:	02500593          	li	a1,37
    117c:	8556                	mv	a0,s5
    117e:	00000097          	auipc	ra,0x0
    1182:	d9a080e7          	jalr	-614(ra) # f18 <putc>
        putc(fd, c);
    1186:	85ca                	mv	a1,s2
    1188:	8556                	mv	a0,s5
    118a:	00000097          	auipc	ra,0x0
    118e:	d8e080e7          	jalr	-626(ra) # f18 <putc>
      state = 0;
    1192:	4981                	li	s3,0
    1194:	bd51                	j	1028 <vprintf+0x42>
        s = va_arg(ap, char*);
    1196:	8bce                	mv	s7,s3
      state = 0;
    1198:	4981                	li	s3,0
    119a:	b579                	j	1028 <vprintf+0x42>
    119c:	74e2                	ld	s1,56(sp)
    119e:	79a2                	ld	s3,40(sp)
    11a0:	7a02                	ld	s4,32(sp)
    11a2:	6ae2                	ld	s5,24(sp)
    11a4:	6b42                	ld	s6,16(sp)
    11a6:	6ba2                	ld	s7,8(sp)
    }
  }
}
    11a8:	60a6                	ld	ra,72(sp)
    11aa:	6406                	ld	s0,64(sp)
    11ac:	7942                	ld	s2,48(sp)
    11ae:	6161                	add	sp,sp,80
    11b0:	8082                	ret

00000000000011b2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    11b2:	715d                	add	sp,sp,-80
    11b4:	ec06                	sd	ra,24(sp)
    11b6:	e822                	sd	s0,16(sp)
    11b8:	1000                	add	s0,sp,32
    11ba:	e010                	sd	a2,0(s0)
    11bc:	e414                	sd	a3,8(s0)
    11be:	e818                	sd	a4,16(s0)
    11c0:	ec1c                	sd	a5,24(s0)
    11c2:	03043023          	sd	a6,32(s0)
    11c6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    11ca:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    11ce:	8622                	mv	a2,s0
    11d0:	00000097          	auipc	ra,0x0
    11d4:	e16080e7          	jalr	-490(ra) # fe6 <vprintf>
}
    11d8:	60e2                	ld	ra,24(sp)
    11da:	6442                	ld	s0,16(sp)
    11dc:	6161                	add	sp,sp,80
    11de:	8082                	ret

00000000000011e0 <printf>:

void
printf(const char *fmt, ...)
{
    11e0:	711d                	add	sp,sp,-96
    11e2:	ec06                	sd	ra,24(sp)
    11e4:	e822                	sd	s0,16(sp)
    11e6:	1000                	add	s0,sp,32
    11e8:	e40c                	sd	a1,8(s0)
    11ea:	e810                	sd	a2,16(s0)
    11ec:	ec14                	sd	a3,24(s0)
    11ee:	f018                	sd	a4,32(s0)
    11f0:	f41c                	sd	a5,40(s0)
    11f2:	03043823          	sd	a6,48(s0)
    11f6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11fa:	00840613          	add	a2,s0,8
    11fe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1202:	85aa                	mv	a1,a0
    1204:	4505                	li	a0,1
    1206:	00000097          	auipc	ra,0x0
    120a:	de0080e7          	jalr	-544(ra) # fe6 <vprintf>
}
    120e:	60e2                	ld	ra,24(sp)
    1210:	6442                	ld	s0,16(sp)
    1212:	6125                	add	sp,sp,96
    1214:	8082                	ret

0000000000001216 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1216:	1141                	add	sp,sp,-16
    1218:	e422                	sd	s0,8(sp)
    121a:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    121c:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1220:	00001797          	auipc	a5,0x1
    1224:	df07b783          	ld	a5,-528(a5) # 2010 <freep>
    1228:	a02d                	j	1252 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    122a:	4618                	lw	a4,8(a2)
    122c:	9f2d                	addw	a4,a4,a1
    122e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1232:	6398                	ld	a4,0(a5)
    1234:	6310                	ld	a2,0(a4)
    1236:	a83d                	j	1274 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    1238:	ff852703          	lw	a4,-8(a0)
    123c:	9f31                	addw	a4,a4,a2
    123e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1240:	ff053683          	ld	a3,-16(a0)
    1244:	a091                	j	1288 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1246:	6398                	ld	a4,0(a5)
    1248:	00e7e463          	bltu	a5,a4,1250 <free+0x3a>
    124c:	00e6ea63          	bltu	a3,a4,1260 <free+0x4a>
{
    1250:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1252:	fed7fae3          	bgeu	a5,a3,1246 <free+0x30>
    1256:	6398                	ld	a4,0(a5)
    1258:	00e6e463          	bltu	a3,a4,1260 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    125c:	fee7eae3          	bltu	a5,a4,1250 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1260:	ff852583          	lw	a1,-8(a0)
    1264:	6390                	ld	a2,0(a5)
    1266:	02059813          	sll	a6,a1,0x20
    126a:	01c85713          	srl	a4,a6,0x1c
    126e:	9736                	add	a4,a4,a3
    1270:	fae60de3          	beq	a2,a4,122a <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1274:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1278:	4790                	lw	a2,8(a5)
    127a:	02061593          	sll	a1,a2,0x20
    127e:	01c5d713          	srl	a4,a1,0x1c
    1282:	973e                	add	a4,a4,a5
    1284:	fae68ae3          	beq	a3,a4,1238 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1288:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    128a:	00001717          	auipc	a4,0x1
    128e:	d8f73323          	sd	a5,-634(a4) # 2010 <freep>
}
    1292:	6422                	ld	s0,8(sp)
    1294:	0141                	add	sp,sp,16
    1296:	8082                	ret

0000000000001298 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1298:	7139                	add	sp,sp,-64
    129a:	fc06                	sd	ra,56(sp)
    129c:	f822                	sd	s0,48(sp)
    129e:	f426                	sd	s1,40(sp)
    12a0:	ec4e                	sd	s3,24(sp)
    12a2:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    12a4:	02051493          	sll	s1,a0,0x20
    12a8:	9081                	srl	s1,s1,0x20
    12aa:	04bd                	add	s1,s1,15
    12ac:	8091                	srl	s1,s1,0x4
    12ae:	0014899b          	addw	s3,s1,1
    12b2:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    12b4:	00001517          	auipc	a0,0x1
    12b8:	d5c53503          	ld	a0,-676(a0) # 2010 <freep>
    12bc:	c915                	beqz	a0,12f0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12be:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12c0:	4798                	lw	a4,8(a5)
    12c2:	08977e63          	bgeu	a4,s1,135e <malloc+0xc6>
    12c6:	f04a                	sd	s2,32(sp)
    12c8:	e852                	sd	s4,16(sp)
    12ca:	e456                	sd	s5,8(sp)
    12cc:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    12ce:	8a4e                	mv	s4,s3
    12d0:	0009871b          	sext.w	a4,s3
    12d4:	6685                	lui	a3,0x1
    12d6:	00d77363          	bgeu	a4,a3,12dc <malloc+0x44>
    12da:	6a05                	lui	s4,0x1
    12dc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    12e0:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    12e4:	00001917          	auipc	s2,0x1
    12e8:	d2c90913          	add	s2,s2,-724 # 2010 <freep>
  if(p == (char*)-1)
    12ec:	5afd                	li	s5,-1
    12ee:	a091                	j	1332 <malloc+0x9a>
    12f0:	f04a                	sd	s2,32(sp)
    12f2:	e852                	sd	s4,16(sp)
    12f4:	e456                	sd	s5,8(sp)
    12f6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12f8:	00001797          	auipc	a5,0x1
    12fc:	11078793          	add	a5,a5,272 # 2408 <base>
    1300:	00001717          	auipc	a4,0x1
    1304:	d0f73823          	sd	a5,-752(a4) # 2010 <freep>
    1308:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    130a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    130e:	b7c1                	j	12ce <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    1310:	6398                	ld	a4,0(a5)
    1312:	e118                	sd	a4,0(a0)
    1314:	a08d                	j	1376 <malloc+0xde>
  hp->s.size = nu;
    1316:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    131a:	0541                	add	a0,a0,16
    131c:	00000097          	auipc	ra,0x0
    1320:	efa080e7          	jalr	-262(ra) # 1216 <free>
  return freep;
    1324:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    1328:	c13d                	beqz	a0,138e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    132a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    132c:	4798                	lw	a4,8(a5)
    132e:	02977463          	bgeu	a4,s1,1356 <malloc+0xbe>
    if(p == freep)
    1332:	00093703          	ld	a4,0(s2)
    1336:	853e                	mv	a0,a5
    1338:	fef719e3          	bne	a4,a5,132a <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    133c:	8552                	mv	a0,s4
    133e:	00000097          	auipc	ra,0x0
    1342:	ba2080e7          	jalr	-1118(ra) # ee0 <sbrk>
  if(p == (char*)-1)
    1346:	fd5518e3          	bne	a0,s5,1316 <malloc+0x7e>
        return 0;
    134a:	4501                	li	a0,0
    134c:	7902                	ld	s2,32(sp)
    134e:	6a42                	ld	s4,16(sp)
    1350:	6aa2                	ld	s5,8(sp)
    1352:	6b02                	ld	s6,0(sp)
    1354:	a03d                	j	1382 <malloc+0xea>
    1356:	7902                	ld	s2,32(sp)
    1358:	6a42                	ld	s4,16(sp)
    135a:	6aa2                	ld	s5,8(sp)
    135c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    135e:	fae489e3          	beq	s1,a4,1310 <malloc+0x78>
        p->s.size -= nunits;
    1362:	4137073b          	subw	a4,a4,s3
    1366:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1368:	02071693          	sll	a3,a4,0x20
    136c:	01c6d713          	srl	a4,a3,0x1c
    1370:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1372:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1376:	00001717          	auipc	a4,0x1
    137a:	c8a73d23          	sd	a0,-870(a4) # 2010 <freep>
      return (void*)(p + 1);
    137e:	01078513          	add	a0,a5,16
  }
}
    1382:	70e2                	ld	ra,56(sp)
    1384:	7442                	ld	s0,48(sp)
    1386:	74a2                	ld	s1,40(sp)
    1388:	69e2                	ld	s3,24(sp)
    138a:	6121                	add	sp,sp,64
    138c:	8082                	ret
    138e:	7902                	ld	s2,32(sp)
    1390:	6a42                	ld	s4,16(sp)
    1392:	6aa2                	ld	s5,8(sp)
    1394:	6b02                	ld	s6,0(sp)
    1396:	b7f5                	j	1382 <malloc+0xea>
