
user/_sh:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <getcmd>:
  exit(0);
}

int
getcmd(char *buf, int nbuf)
{
       0:	1101                	add	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	add	s0,sp,32
       c:	84aa                	mv	s1,a0
       e:	892e                	mv	s2,a1
  write(2, "$ ", 2);
      10:	4609                	li	a2,2
      12:	00001597          	auipc	a1,0x1
      16:	33e58593          	add	a1,a1,830 # 1350 <malloc+0x108>
      1a:	4509                	li	a0,2
      1c:	00001097          	auipc	ra,0x1
      20:	e0c080e7          	jalr	-500(ra) # e28 <write>
  memset(buf, 0, nbuf);
      24:	864a                	mv	a2,s2
      26:	4581                	li	a1,0
      28:	8526                	mv	a0,s1
      2a:	00001097          	auipc	ra,0x1
      2e:	bcc080e7          	jalr	-1076(ra) # bf6 <memset>
  gets(buf, nbuf);
      32:	85ca                	mv	a1,s2
      34:	8526                	mv	a0,s1
      36:	00001097          	auipc	ra,0x1
      3a:	c06080e7          	jalr	-1018(ra) # c3c <gets>
  if(buf[0] == 0) // EOF
      3e:	0004c503          	lbu	a0,0(s1)
      42:	00153513          	seqz	a0,a0
    return -1;
  return 0;
}
      46:	40a00533          	neg	a0,a0
      4a:	60e2                	ld	ra,24(sp)
      4c:	6442                	ld	s0,16(sp)
      4e:	64a2                	ld	s1,8(sp)
      50:	6902                	ld	s2,0(sp)
      52:	6105                	add	sp,sp,32
      54:	8082                	ret

0000000000000056 <panic>:
  exit(0);
}

void
panic(char *s)
{
      56:	1141                	add	sp,sp,-16
      58:	e406                	sd	ra,8(sp)
      5a:	e022                	sd	s0,0(sp)
      5c:	0800                	add	s0,sp,16
      5e:	862a                	mv	a2,a0
  fprintf(2, "%s\n", s);
      60:	00001597          	auipc	a1,0x1
      64:	30058593          	add	a1,a1,768 # 1360 <malloc+0x118>
      68:	4509                	li	a0,2
      6a:	00001097          	auipc	ra,0x1
      6e:	0f8080e7          	jalr	248(ra) # 1162 <fprintf>
  exit(1);
      72:	4505                	li	a0,1
      74:	00001097          	auipc	ra,0x1
      78:	d94080e7          	jalr	-620(ra) # e08 <exit>

000000000000007c <fork1>:
}

int
fork1(void)
{
      7c:	1141                	add	sp,sp,-16
      7e:	e406                	sd	ra,8(sp)
      80:	e022                	sd	s0,0(sp)
      82:	0800                	add	s0,sp,16
  int pid;

  pid = fork();
      84:	00001097          	auipc	ra,0x1
      88:	d7c080e7          	jalr	-644(ra) # e00 <fork>
  if(pid == -1)
      8c:	57fd                	li	a5,-1
      8e:	00f50663          	beq	a0,a5,9a <fork1+0x1e>
    panic("fork");
  return pid;
}
      92:	60a2                	ld	ra,8(sp)
      94:	6402                	ld	s0,0(sp)
      96:	0141                	add	sp,sp,16
      98:	8082                	ret
    panic("fork");
      9a:	00001517          	auipc	a0,0x1
      9e:	2ce50513          	add	a0,a0,718 # 1368 <malloc+0x120>
      a2:	00000097          	auipc	ra,0x0
      a6:	fb4080e7          	jalr	-76(ra) # 56 <panic>

00000000000000aa <runcmd>:
{
      aa:	7179                	add	sp,sp,-48
      ac:	f406                	sd	ra,40(sp)
      ae:	f022                	sd	s0,32(sp)
      b0:	1800                	add	s0,sp,48
  if(cmd == 0)
      b2:	c115                	beqz	a0,d6 <runcmd+0x2c>
      b4:	ec26                	sd	s1,24(sp)
      b6:	84aa                	mv	s1,a0
  switch(cmd->type){
      b8:	4118                	lw	a4,0(a0)
      ba:	4795                	li	a5,5
      bc:	02e7e363          	bltu	a5,a4,e2 <runcmd+0x38>
      c0:	00056783          	lwu	a5,0(a0)
      c4:	078a                	sll	a5,a5,0x2
      c6:	00001717          	auipc	a4,0x1
      ca:	3a270713          	add	a4,a4,930 # 1468 <malloc+0x220>
      ce:	97ba                	add	a5,a5,a4
      d0:	439c                	lw	a5,0(a5)
      d2:	97ba                	add	a5,a5,a4
      d4:	8782                	jr	a5
      d6:	ec26                	sd	s1,24(sp)
    exit(1);
      d8:	4505                	li	a0,1
      da:	00001097          	auipc	ra,0x1
      de:	d2e080e7          	jalr	-722(ra) # e08 <exit>
    panic("runcmd");
      e2:	00001517          	auipc	a0,0x1
      e6:	28e50513          	add	a0,a0,654 # 1370 <malloc+0x128>
      ea:	00000097          	auipc	ra,0x0
      ee:	f6c080e7          	jalr	-148(ra) # 56 <panic>
    if(ecmd->argv[0] == 0)
      f2:	6508                	ld	a0,8(a0)
      f4:	c515                	beqz	a0,120 <runcmd+0x76>
    exec(ecmd->argv[0], ecmd->argv);
      f6:	00848593          	add	a1,s1,8
      fa:	00001097          	auipc	ra,0x1
      fe:	d46080e7          	jalr	-698(ra) # e40 <exec>
    fprintf(2, "exec %s failed\n", ecmd->argv[0]);
     102:	6490                	ld	a2,8(s1)
     104:	00001597          	auipc	a1,0x1
     108:	27458593          	add	a1,a1,628 # 1378 <malloc+0x130>
     10c:	4509                	li	a0,2
     10e:	00001097          	auipc	ra,0x1
     112:	054080e7          	jalr	84(ra) # 1162 <fprintf>
  exit(0);
     116:	4501                	li	a0,0
     118:	00001097          	auipc	ra,0x1
     11c:	cf0080e7          	jalr	-784(ra) # e08 <exit>
      exit(1);
     120:	4505                	li	a0,1
     122:	00001097          	auipc	ra,0x1
     126:	ce6080e7          	jalr	-794(ra) # e08 <exit>
    close(rcmd->fd);
     12a:	5148                	lw	a0,36(a0)
     12c:	00001097          	auipc	ra,0x1
     130:	d04080e7          	jalr	-764(ra) # e30 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     134:	508c                	lw	a1,32(s1)
     136:	6888                	ld	a0,16(s1)
     138:	00001097          	auipc	ra,0x1
     13c:	d10080e7          	jalr	-752(ra) # e48 <open>
     140:	00054763          	bltz	a0,14e <runcmd+0xa4>
    runcmd(rcmd->cmd);
     144:	6488                	ld	a0,8(s1)
     146:	00000097          	auipc	ra,0x0
     14a:	f64080e7          	jalr	-156(ra) # aa <runcmd>
      fprintf(2, "open %s failed\n", rcmd->file);
     14e:	6890                	ld	a2,16(s1)
     150:	00001597          	auipc	a1,0x1
     154:	23858593          	add	a1,a1,568 # 1388 <malloc+0x140>
     158:	4509                	li	a0,2
     15a:	00001097          	auipc	ra,0x1
     15e:	008080e7          	jalr	8(ra) # 1162 <fprintf>
      exit(1);
     162:	4505                	li	a0,1
     164:	00001097          	auipc	ra,0x1
     168:	ca4080e7          	jalr	-860(ra) # e08 <exit>
    if(fork1() == 0)
     16c:	00000097          	auipc	ra,0x0
     170:	f10080e7          	jalr	-240(ra) # 7c <fork1>
     174:	e511                	bnez	a0,180 <runcmd+0xd6>
      runcmd(lcmd->left);
     176:	6488                	ld	a0,8(s1)
     178:	00000097          	auipc	ra,0x0
     17c:	f32080e7          	jalr	-206(ra) # aa <runcmd>
    wait(0);
     180:	4501                	li	a0,0
     182:	00001097          	auipc	ra,0x1
     186:	c8e080e7          	jalr	-882(ra) # e10 <wait>
    runcmd(lcmd->right);
     18a:	6888                	ld	a0,16(s1)
     18c:	00000097          	auipc	ra,0x0
     190:	f1e080e7          	jalr	-226(ra) # aa <runcmd>
    if(pipe(p) < 0)
     194:	fd840513          	add	a0,s0,-40
     198:	00001097          	auipc	ra,0x1
     19c:	c80080e7          	jalr	-896(ra) # e18 <pipe>
     1a0:	04054363          	bltz	a0,1e6 <runcmd+0x13c>
    if(fork1() == 0){
     1a4:	00000097          	auipc	ra,0x0
     1a8:	ed8080e7          	jalr	-296(ra) # 7c <fork1>
     1ac:	e529                	bnez	a0,1f6 <runcmd+0x14c>
      close(1);
     1ae:	4505                	li	a0,1
     1b0:	00001097          	auipc	ra,0x1
     1b4:	c80080e7          	jalr	-896(ra) # e30 <close>
      dup(p[1]);
     1b8:	fdc42503          	lw	a0,-36(s0)
     1bc:	00001097          	auipc	ra,0x1
     1c0:	cc4080e7          	jalr	-828(ra) # e80 <dup>
      close(p[0]);
     1c4:	fd842503          	lw	a0,-40(s0)
     1c8:	00001097          	auipc	ra,0x1
     1cc:	c68080e7          	jalr	-920(ra) # e30 <close>
      close(p[1]);
     1d0:	fdc42503          	lw	a0,-36(s0)
     1d4:	00001097          	auipc	ra,0x1
     1d8:	c5c080e7          	jalr	-932(ra) # e30 <close>
      runcmd(pcmd->left);
     1dc:	6488                	ld	a0,8(s1)
     1de:	00000097          	auipc	ra,0x0
     1e2:	ecc080e7          	jalr	-308(ra) # aa <runcmd>
      panic("pipe");
     1e6:	00001517          	auipc	a0,0x1
     1ea:	1b250513          	add	a0,a0,434 # 1398 <malloc+0x150>
     1ee:	00000097          	auipc	ra,0x0
     1f2:	e68080e7          	jalr	-408(ra) # 56 <panic>
    if(fork1() == 0){
     1f6:	00000097          	auipc	ra,0x0
     1fa:	e86080e7          	jalr	-378(ra) # 7c <fork1>
     1fe:	ed05                	bnez	a0,236 <runcmd+0x18c>
      close(0);
     200:	00001097          	auipc	ra,0x1
     204:	c30080e7          	jalr	-976(ra) # e30 <close>
      dup(p[0]);
     208:	fd842503          	lw	a0,-40(s0)
     20c:	00001097          	auipc	ra,0x1
     210:	c74080e7          	jalr	-908(ra) # e80 <dup>
      close(p[0]);
     214:	fd842503          	lw	a0,-40(s0)
     218:	00001097          	auipc	ra,0x1
     21c:	c18080e7          	jalr	-1000(ra) # e30 <close>
      close(p[1]);
     220:	fdc42503          	lw	a0,-36(s0)
     224:	00001097          	auipc	ra,0x1
     228:	c0c080e7          	jalr	-1012(ra) # e30 <close>
      runcmd(pcmd->right);
     22c:	6888                	ld	a0,16(s1)
     22e:	00000097          	auipc	ra,0x0
     232:	e7c080e7          	jalr	-388(ra) # aa <runcmd>
    close(p[0]);
     236:	fd842503          	lw	a0,-40(s0)
     23a:	00001097          	auipc	ra,0x1
     23e:	bf6080e7          	jalr	-1034(ra) # e30 <close>
    close(p[1]);
     242:	fdc42503          	lw	a0,-36(s0)
     246:	00001097          	auipc	ra,0x1
     24a:	bea080e7          	jalr	-1046(ra) # e30 <close>
    wait(0);
     24e:	4501                	li	a0,0
     250:	00001097          	auipc	ra,0x1
     254:	bc0080e7          	jalr	-1088(ra) # e10 <wait>
    wait(0);
     258:	4501                	li	a0,0
     25a:	00001097          	auipc	ra,0x1
     25e:	bb6080e7          	jalr	-1098(ra) # e10 <wait>
    break;
     262:	bd55                	j	116 <runcmd+0x6c>
    if(fork1() == 0)
     264:	00000097          	auipc	ra,0x0
     268:	e18080e7          	jalr	-488(ra) # 7c <fork1>
     26c:	ea0515e3          	bnez	a0,116 <runcmd+0x6c>
      runcmd(bcmd->cmd);
     270:	6488                	ld	a0,8(s1)
     272:	00000097          	auipc	ra,0x0
     276:	e38080e7          	jalr	-456(ra) # aa <runcmd>

000000000000027a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     27a:	1101                	add	sp,sp,-32
     27c:	ec06                	sd	ra,24(sp)
     27e:	e822                	sd	s0,16(sp)
     280:	e426                	sd	s1,8(sp)
     282:	1000                	add	s0,sp,32
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     284:	0a800513          	li	a0,168
     288:	00001097          	auipc	ra,0x1
     28c:	fc0080e7          	jalr	-64(ra) # 1248 <malloc>
     290:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     292:	0a800613          	li	a2,168
     296:	4581                	li	a1,0
     298:	00001097          	auipc	ra,0x1
     29c:	95e080e7          	jalr	-1698(ra) # bf6 <memset>
  cmd->type = EXEC;
     2a0:	4785                	li	a5,1
     2a2:	c09c                	sw	a5,0(s1)
  return (struct cmd*)cmd;
}
     2a4:	8526                	mv	a0,s1
     2a6:	60e2                	ld	ra,24(sp)
     2a8:	6442                	ld	s0,16(sp)
     2aa:	64a2                	ld	s1,8(sp)
     2ac:	6105                	add	sp,sp,32
     2ae:	8082                	ret

00000000000002b0 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     2b0:	7139                	add	sp,sp,-64
     2b2:	fc06                	sd	ra,56(sp)
     2b4:	f822                	sd	s0,48(sp)
     2b6:	f426                	sd	s1,40(sp)
     2b8:	f04a                	sd	s2,32(sp)
     2ba:	ec4e                	sd	s3,24(sp)
     2bc:	e852                	sd	s4,16(sp)
     2be:	e456                	sd	s5,8(sp)
     2c0:	e05a                	sd	s6,0(sp)
     2c2:	0080                	add	s0,sp,64
     2c4:	8b2a                	mv	s6,a0
     2c6:	8aae                	mv	s5,a1
     2c8:	8a32                	mv	s4,a2
     2ca:	89b6                	mv	s3,a3
     2cc:	893a                	mv	s2,a4
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     2ce:	02800513          	li	a0,40
     2d2:	00001097          	auipc	ra,0x1
     2d6:	f76080e7          	jalr	-138(ra) # 1248 <malloc>
     2da:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     2dc:	02800613          	li	a2,40
     2e0:	4581                	li	a1,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	914080e7          	jalr	-1772(ra) # bf6 <memset>
  cmd->type = REDIR;
     2ea:	4789                	li	a5,2
     2ec:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     2ee:	0164b423          	sd	s6,8(s1)
  cmd->file = file;
     2f2:	0154b823          	sd	s5,16(s1)
  cmd->efile = efile;
     2f6:	0144bc23          	sd	s4,24(s1)
  cmd->mode = mode;
     2fa:	0334a023          	sw	s3,32(s1)
  cmd->fd = fd;
     2fe:	0324a223          	sw	s2,36(s1)
  return (struct cmd*)cmd;
}
     302:	8526                	mv	a0,s1
     304:	70e2                	ld	ra,56(sp)
     306:	7442                	ld	s0,48(sp)
     308:	74a2                	ld	s1,40(sp)
     30a:	7902                	ld	s2,32(sp)
     30c:	69e2                	ld	s3,24(sp)
     30e:	6a42                	ld	s4,16(sp)
     310:	6aa2                	ld	s5,8(sp)
     312:	6b02                	ld	s6,0(sp)
     314:	6121                	add	sp,sp,64
     316:	8082                	ret

0000000000000318 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     318:	7179                	add	sp,sp,-48
     31a:	f406                	sd	ra,40(sp)
     31c:	f022                	sd	s0,32(sp)
     31e:	ec26                	sd	s1,24(sp)
     320:	e84a                	sd	s2,16(sp)
     322:	e44e                	sd	s3,8(sp)
     324:	1800                	add	s0,sp,48
     326:	89aa                	mv	s3,a0
     328:	892e                	mv	s2,a1
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     32a:	4561                	li	a0,24
     32c:	00001097          	auipc	ra,0x1
     330:	f1c080e7          	jalr	-228(ra) # 1248 <malloc>
     334:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     336:	4661                	li	a2,24
     338:	4581                	li	a1,0
     33a:	00001097          	auipc	ra,0x1
     33e:	8bc080e7          	jalr	-1860(ra) # bf6 <memset>
  cmd->type = PIPE;
     342:	478d                	li	a5,3
     344:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     346:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     34a:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     34e:	8526                	mv	a0,s1
     350:	70a2                	ld	ra,40(sp)
     352:	7402                	ld	s0,32(sp)
     354:	64e2                	ld	s1,24(sp)
     356:	6942                	ld	s2,16(sp)
     358:	69a2                	ld	s3,8(sp)
     35a:	6145                	add	sp,sp,48
     35c:	8082                	ret

000000000000035e <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     35e:	7179                	add	sp,sp,-48
     360:	f406                	sd	ra,40(sp)
     362:	f022                	sd	s0,32(sp)
     364:	ec26                	sd	s1,24(sp)
     366:	e84a                	sd	s2,16(sp)
     368:	e44e                	sd	s3,8(sp)
     36a:	1800                	add	s0,sp,48
     36c:	89aa                	mv	s3,a0
     36e:	892e                	mv	s2,a1
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     370:	4561                	li	a0,24
     372:	00001097          	auipc	ra,0x1
     376:	ed6080e7          	jalr	-298(ra) # 1248 <malloc>
     37a:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     37c:	4661                	li	a2,24
     37e:	4581                	li	a1,0
     380:	00001097          	auipc	ra,0x1
     384:	876080e7          	jalr	-1930(ra) # bf6 <memset>
  cmd->type = LIST;
     388:	4791                	li	a5,4
     38a:	c09c                	sw	a5,0(s1)
  cmd->left = left;
     38c:	0134b423          	sd	s3,8(s1)
  cmd->right = right;
     390:	0124b823          	sd	s2,16(s1)
  return (struct cmd*)cmd;
}
     394:	8526                	mv	a0,s1
     396:	70a2                	ld	ra,40(sp)
     398:	7402                	ld	s0,32(sp)
     39a:	64e2                	ld	s1,24(sp)
     39c:	6942                	ld	s2,16(sp)
     39e:	69a2                	ld	s3,8(sp)
     3a0:	6145                	add	sp,sp,48
     3a2:	8082                	ret

00000000000003a4 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     3a4:	1101                	add	sp,sp,-32
     3a6:	ec06                	sd	ra,24(sp)
     3a8:	e822                	sd	s0,16(sp)
     3aa:	e426                	sd	s1,8(sp)
     3ac:	e04a                	sd	s2,0(sp)
     3ae:	1000                	add	s0,sp,32
     3b0:	892a                	mv	s2,a0
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     3b2:	4541                	li	a0,16
     3b4:	00001097          	auipc	ra,0x1
     3b8:	e94080e7          	jalr	-364(ra) # 1248 <malloc>
     3bc:	84aa                	mv	s1,a0
  memset(cmd, 0, sizeof(*cmd));
     3be:	4641                	li	a2,16
     3c0:	4581                	li	a1,0
     3c2:	00001097          	auipc	ra,0x1
     3c6:	834080e7          	jalr	-1996(ra) # bf6 <memset>
  cmd->type = BACK;
     3ca:	4795                	li	a5,5
     3cc:	c09c                	sw	a5,0(s1)
  cmd->cmd = subcmd;
     3ce:	0124b423          	sd	s2,8(s1)
  return (struct cmd*)cmd;
}
     3d2:	8526                	mv	a0,s1
     3d4:	60e2                	ld	ra,24(sp)
     3d6:	6442                	ld	s0,16(sp)
     3d8:	64a2                	ld	s1,8(sp)
     3da:	6902                	ld	s2,0(sp)
     3dc:	6105                	add	sp,sp,32
     3de:	8082                	ret

00000000000003e0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     3e0:	7139                	add	sp,sp,-64
     3e2:	fc06                	sd	ra,56(sp)
     3e4:	f822                	sd	s0,48(sp)
     3e6:	f426                	sd	s1,40(sp)
     3e8:	f04a                	sd	s2,32(sp)
     3ea:	ec4e                	sd	s3,24(sp)
     3ec:	e852                	sd	s4,16(sp)
     3ee:	e456                	sd	s5,8(sp)
     3f0:	e05a                	sd	s6,0(sp)
     3f2:	0080                	add	s0,sp,64
     3f4:	8a2a                	mv	s4,a0
     3f6:	892e                	mv	s2,a1
     3f8:	8ab2                	mv	s5,a2
     3fa:	8b36                	mv	s6,a3
  char *s;
  int ret;

  s = *ps;
     3fc:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     3fe:	00002997          	auipc	s3,0x2
     402:	c0a98993          	add	s3,s3,-1014 # 2008 <whitespace>
     406:	00b4fe63          	bgeu	s1,a1,422 <gettoken+0x42>
     40a:	0004c583          	lbu	a1,0(s1)
     40e:	854e                	mv	a0,s3
     410:	00001097          	auipc	ra,0x1
     414:	808080e7          	jalr	-2040(ra) # c18 <strchr>
     418:	c509                	beqz	a0,422 <gettoken+0x42>
    s++;
     41a:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     41c:	fe9917e3          	bne	s2,s1,40a <gettoken+0x2a>
     420:	84ca                	mv	s1,s2
  if(q)
     422:	000a8463          	beqz	s5,42a <gettoken+0x4a>
    *q = s;
     426:	009ab023          	sd	s1,0(s5)
  ret = *s;
     42a:	0004c783          	lbu	a5,0(s1)
     42e:	00078a9b          	sext.w	s5,a5
  switch(*s){
     432:	03c00713          	li	a4,60
     436:	06f76663          	bltu	a4,a5,4a2 <gettoken+0xc2>
     43a:	03a00713          	li	a4,58
     43e:	00f76e63          	bltu	a4,a5,45a <gettoken+0x7a>
     442:	cf89                	beqz	a5,45c <gettoken+0x7c>
     444:	02600713          	li	a4,38
     448:	00e78963          	beq	a5,a4,45a <gettoken+0x7a>
     44c:	fd87879b          	addw	a5,a5,-40
     450:	0ff7f793          	zext.b	a5,a5
     454:	4705                	li	a4,1
     456:	06f76d63          	bltu	a4,a5,4d0 <gettoken+0xf0>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
     45a:	0485                	add	s1,s1,1
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     45c:	000b0463          	beqz	s6,464 <gettoken+0x84>
    *eq = s;
     460:	009b3023          	sd	s1,0(s6)

  while(s < es && strchr(whitespace, *s))
     464:	00002997          	auipc	s3,0x2
     468:	ba498993          	add	s3,s3,-1116 # 2008 <whitespace>
     46c:	0124fe63          	bgeu	s1,s2,488 <gettoken+0xa8>
     470:	0004c583          	lbu	a1,0(s1)
     474:	854e                	mv	a0,s3
     476:	00000097          	auipc	ra,0x0
     47a:	7a2080e7          	jalr	1954(ra) # c18 <strchr>
     47e:	c509                	beqz	a0,488 <gettoken+0xa8>
    s++;
     480:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     482:	fe9917e3          	bne	s2,s1,470 <gettoken+0x90>
     486:	84ca                	mv	s1,s2
  *ps = s;
     488:	009a3023          	sd	s1,0(s4)
  return ret;
}
     48c:	8556                	mv	a0,s5
     48e:	70e2                	ld	ra,56(sp)
     490:	7442                	ld	s0,48(sp)
     492:	74a2                	ld	s1,40(sp)
     494:	7902                	ld	s2,32(sp)
     496:	69e2                	ld	s3,24(sp)
     498:	6a42                	ld	s4,16(sp)
     49a:	6aa2                	ld	s5,8(sp)
     49c:	6b02                	ld	s6,0(sp)
     49e:	6121                	add	sp,sp,64
     4a0:	8082                	ret
  switch(*s){
     4a2:	03e00713          	li	a4,62
     4a6:	02e79163          	bne	a5,a4,4c8 <gettoken+0xe8>
    s++;
     4aa:	00148693          	add	a3,s1,1
    if(*s == '>'){
     4ae:	0014c703          	lbu	a4,1(s1)
     4b2:	03e00793          	li	a5,62
      s++;
     4b6:	0489                	add	s1,s1,2
      ret = '+';
     4b8:	02b00a93          	li	s5,43
    if(*s == '>'){
     4bc:	faf700e3          	beq	a4,a5,45c <gettoken+0x7c>
    s++;
     4c0:	84b6                	mv	s1,a3
  ret = *s;
     4c2:	03e00a93          	li	s5,62
     4c6:	bf59                	j	45c <gettoken+0x7c>
  switch(*s){
     4c8:	07c00713          	li	a4,124
     4cc:	f8e787e3          	beq	a5,a4,45a <gettoken+0x7a>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     4d0:	00002997          	auipc	s3,0x2
     4d4:	b3898993          	add	s3,s3,-1224 # 2008 <whitespace>
     4d8:	00002a97          	auipc	s5,0x2
     4dc:	b28a8a93          	add	s5,s5,-1240 # 2000 <symbols>
     4e0:	0524f163          	bgeu	s1,s2,522 <gettoken+0x142>
     4e4:	0004c583          	lbu	a1,0(s1)
     4e8:	854e                	mv	a0,s3
     4ea:	00000097          	auipc	ra,0x0
     4ee:	72e080e7          	jalr	1838(ra) # c18 <strchr>
     4f2:	e50d                	bnez	a0,51c <gettoken+0x13c>
     4f4:	0004c583          	lbu	a1,0(s1)
     4f8:	8556                	mv	a0,s5
     4fa:	00000097          	auipc	ra,0x0
     4fe:	71e080e7          	jalr	1822(ra) # c18 <strchr>
     502:	e911                	bnez	a0,516 <gettoken+0x136>
      s++;
     504:	0485                	add	s1,s1,1
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     506:	fc991fe3          	bne	s2,s1,4e4 <gettoken+0x104>
  if(eq)
     50a:	84ca                	mv	s1,s2
    ret = 'a';
     50c:	06100a93          	li	s5,97
  if(eq)
     510:	f40b18e3          	bnez	s6,460 <gettoken+0x80>
     514:	bf95                	j	488 <gettoken+0xa8>
    ret = 'a';
     516:	06100a93          	li	s5,97
     51a:	b789                	j	45c <gettoken+0x7c>
     51c:	06100a93          	li	s5,97
     520:	bf35                	j	45c <gettoken+0x7c>
     522:	06100a93          	li	s5,97
  if(eq)
     526:	f20b1de3          	bnez	s6,460 <gettoken+0x80>
     52a:	bfb9                	j	488 <gettoken+0xa8>

000000000000052c <peek>:

int
peek(char **ps, char *es, char *toks)
{
     52c:	7139                	add	sp,sp,-64
     52e:	fc06                	sd	ra,56(sp)
     530:	f822                	sd	s0,48(sp)
     532:	f426                	sd	s1,40(sp)
     534:	f04a                	sd	s2,32(sp)
     536:	ec4e                	sd	s3,24(sp)
     538:	e852                	sd	s4,16(sp)
     53a:	e456                	sd	s5,8(sp)
     53c:	0080                	add	s0,sp,64
     53e:	8a2a                	mv	s4,a0
     540:	892e                	mv	s2,a1
     542:	8ab2                	mv	s5,a2
  char *s;

  s = *ps;
     544:	6104                	ld	s1,0(a0)
  while(s < es && strchr(whitespace, *s))
     546:	00002997          	auipc	s3,0x2
     54a:	ac298993          	add	s3,s3,-1342 # 2008 <whitespace>
     54e:	00b4fe63          	bgeu	s1,a1,56a <peek+0x3e>
     552:	0004c583          	lbu	a1,0(s1)
     556:	854e                	mv	a0,s3
     558:	00000097          	auipc	ra,0x0
     55c:	6c0080e7          	jalr	1728(ra) # c18 <strchr>
     560:	c509                	beqz	a0,56a <peek+0x3e>
    s++;
     562:	0485                	add	s1,s1,1
  while(s < es && strchr(whitespace, *s))
     564:	fe9917e3          	bne	s2,s1,552 <peek+0x26>
     568:	84ca                	mv	s1,s2
  *ps = s;
     56a:	009a3023          	sd	s1,0(s4)
  return *s && strchr(toks, *s);
     56e:	0004c583          	lbu	a1,0(s1)
     572:	4501                	li	a0,0
     574:	e991                	bnez	a1,588 <peek+0x5c>
}
     576:	70e2                	ld	ra,56(sp)
     578:	7442                	ld	s0,48(sp)
     57a:	74a2                	ld	s1,40(sp)
     57c:	7902                	ld	s2,32(sp)
     57e:	69e2                	ld	s3,24(sp)
     580:	6a42                	ld	s4,16(sp)
     582:	6aa2                	ld	s5,8(sp)
     584:	6121                	add	sp,sp,64
     586:	8082                	ret
  return *s && strchr(toks, *s);
     588:	8556                	mv	a0,s5
     58a:	00000097          	auipc	ra,0x0
     58e:	68e080e7          	jalr	1678(ra) # c18 <strchr>
     592:	00a03533          	snez	a0,a0
     596:	b7c5                	j	576 <peek+0x4a>

0000000000000598 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     598:	711d                	add	sp,sp,-96
     59a:	ec86                	sd	ra,88(sp)
     59c:	e8a2                	sd	s0,80(sp)
     59e:	e4a6                	sd	s1,72(sp)
     5a0:	e0ca                	sd	s2,64(sp)
     5a2:	fc4e                	sd	s3,56(sp)
     5a4:	f852                	sd	s4,48(sp)
     5a6:	f456                	sd	s5,40(sp)
     5a8:	f05a                	sd	s6,32(sp)
     5aa:	ec5e                	sd	s7,24(sp)
     5ac:	1080                	add	s0,sp,96
     5ae:	8a2a                	mv	s4,a0
     5b0:	89ae                	mv	s3,a1
     5b2:	8932                	mv	s2,a2
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     5b4:	00001a97          	auipc	s5,0x1
     5b8:	e0ca8a93          	add	s5,s5,-500 # 13c0 <malloc+0x178>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
     5bc:	06100b13          	li	s6,97
      panic("missing file for redirection");
    switch(tok){
     5c0:	03c00b93          	li	s7,60
  while(peek(ps, es, "<>")){
     5c4:	a02d                	j	5ee <parseredirs+0x56>
      panic("missing file for redirection");
     5c6:	00001517          	auipc	a0,0x1
     5ca:	dda50513          	add	a0,a0,-550 # 13a0 <malloc+0x158>
     5ce:	00000097          	auipc	ra,0x0
     5d2:	a88080e7          	jalr	-1400(ra) # 56 <panic>
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     5d6:	4701                	li	a4,0
     5d8:	4681                	li	a3,0
     5da:	fa043603          	ld	a2,-96(s0)
     5de:	fa843583          	ld	a1,-88(s0)
     5e2:	8552                	mv	a0,s4
     5e4:	00000097          	auipc	ra,0x0
     5e8:	ccc080e7          	jalr	-820(ra) # 2b0 <redircmd>
     5ec:	8a2a                	mv	s4,a0
  while(peek(ps, es, "<>")){
     5ee:	8656                	mv	a2,s5
     5f0:	85ca                	mv	a1,s2
     5f2:	854e                	mv	a0,s3
     5f4:	00000097          	auipc	ra,0x0
     5f8:	f38080e7          	jalr	-200(ra) # 52c <peek>
     5fc:	cd25                	beqz	a0,674 <parseredirs+0xdc>
    tok = gettoken(ps, es, 0, 0);
     5fe:	4681                	li	a3,0
     600:	4601                	li	a2,0
     602:	85ca                	mv	a1,s2
     604:	854e                	mv	a0,s3
     606:	00000097          	auipc	ra,0x0
     60a:	dda080e7          	jalr	-550(ra) # 3e0 <gettoken>
     60e:	84aa                	mv	s1,a0
    if(gettoken(ps, es, &q, &eq) != 'a')
     610:	fa040693          	add	a3,s0,-96
     614:	fa840613          	add	a2,s0,-88
     618:	85ca                	mv	a1,s2
     61a:	854e                	mv	a0,s3
     61c:	00000097          	auipc	ra,0x0
     620:	dc4080e7          	jalr	-572(ra) # 3e0 <gettoken>
     624:	fb6511e3          	bne	a0,s6,5c6 <parseredirs+0x2e>
    switch(tok){
     628:	fb7487e3          	beq	s1,s7,5d6 <parseredirs+0x3e>
     62c:	03e00793          	li	a5,62
     630:	02f48463          	beq	s1,a5,658 <parseredirs+0xc0>
     634:	02b00793          	li	a5,43
     638:	faf49be3          	bne	s1,a5,5ee <parseredirs+0x56>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     63c:	4705                	li	a4,1
     63e:	20100693          	li	a3,513
     642:	fa043603          	ld	a2,-96(s0)
     646:	fa843583          	ld	a1,-88(s0)
     64a:	8552                	mv	a0,s4
     64c:	00000097          	auipc	ra,0x0
     650:	c64080e7          	jalr	-924(ra) # 2b0 <redircmd>
     654:	8a2a                	mv	s4,a0
      break;
     656:	bf61                	j	5ee <parseredirs+0x56>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
     658:	4705                	li	a4,1
     65a:	60100693          	li	a3,1537
     65e:	fa043603          	ld	a2,-96(s0)
     662:	fa843583          	ld	a1,-88(s0)
     666:	8552                	mv	a0,s4
     668:	00000097          	auipc	ra,0x0
     66c:	c48080e7          	jalr	-952(ra) # 2b0 <redircmd>
     670:	8a2a                	mv	s4,a0
      break;
     672:	bfb5                	j	5ee <parseredirs+0x56>
    }
  }
  return cmd;
}
     674:	8552                	mv	a0,s4
     676:	60e6                	ld	ra,88(sp)
     678:	6446                	ld	s0,80(sp)
     67a:	64a6                	ld	s1,72(sp)
     67c:	6906                	ld	s2,64(sp)
     67e:	79e2                	ld	s3,56(sp)
     680:	7a42                	ld	s4,48(sp)
     682:	7aa2                	ld	s5,40(sp)
     684:	7b02                	ld	s6,32(sp)
     686:	6be2                	ld	s7,24(sp)
     688:	6125                	add	sp,sp,96
     68a:	8082                	ret

000000000000068c <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     68c:	7159                	add	sp,sp,-112
     68e:	f486                	sd	ra,104(sp)
     690:	f0a2                	sd	s0,96(sp)
     692:	eca6                	sd	s1,88(sp)
     694:	e0d2                	sd	s4,64(sp)
     696:	fc56                	sd	s5,56(sp)
     698:	1880                	add	s0,sp,112
     69a:	8a2a                	mv	s4,a0
     69c:	8aae                	mv	s5,a1
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     69e:	00001617          	auipc	a2,0x1
     6a2:	d2a60613          	add	a2,a2,-726 # 13c8 <malloc+0x180>
     6a6:	00000097          	auipc	ra,0x0
     6aa:	e86080e7          	jalr	-378(ra) # 52c <peek>
     6ae:	ed15                	bnez	a0,6ea <parseexec+0x5e>
     6b0:	e8ca                	sd	s2,80(sp)
     6b2:	e4ce                	sd	s3,72(sp)
     6b4:	f85a                	sd	s6,48(sp)
     6b6:	f45e                	sd	s7,40(sp)
     6b8:	f062                	sd	s8,32(sp)
     6ba:	ec66                	sd	s9,24(sp)
     6bc:	89aa                	mv	s3,a0
    return parseblock(ps, es);

  ret = execcmd();
     6be:	00000097          	auipc	ra,0x0
     6c2:	bbc080e7          	jalr	-1092(ra) # 27a <execcmd>
     6c6:	8c2a                	mv	s8,a0
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     6c8:	8656                	mv	a2,s5
     6ca:	85d2                	mv	a1,s4
     6cc:	00000097          	auipc	ra,0x0
     6d0:	ecc080e7          	jalr	-308(ra) # 598 <parseredirs>
     6d4:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     6d6:	008c0913          	add	s2,s8,8
     6da:	00001b17          	auipc	s6,0x1
     6de:	d0eb0b13          	add	s6,s6,-754 # 13e8 <malloc+0x1a0>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
      break;
    if(tok != 'a')
     6e2:	06100c93          	li	s9,97
      panic("syntax");
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
     6e6:	4ba9                	li	s7,10
  while(!peek(ps, es, "|)&;")){
     6e8:	a081                	j	728 <parseexec+0x9c>
    return parseblock(ps, es);
     6ea:	85d6                	mv	a1,s5
     6ec:	8552                	mv	a0,s4
     6ee:	00000097          	auipc	ra,0x0
     6f2:	1bc080e7          	jalr	444(ra) # 8aa <parseblock>
     6f6:	84aa                	mv	s1,a0
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     6f8:	8526                	mv	a0,s1
     6fa:	70a6                	ld	ra,104(sp)
     6fc:	7406                	ld	s0,96(sp)
     6fe:	64e6                	ld	s1,88(sp)
     700:	6a06                	ld	s4,64(sp)
     702:	7ae2                	ld	s5,56(sp)
     704:	6165                	add	sp,sp,112
     706:	8082                	ret
      panic("syntax");
     708:	00001517          	auipc	a0,0x1
     70c:	cc850513          	add	a0,a0,-824 # 13d0 <malloc+0x188>
     710:	00000097          	auipc	ra,0x0
     714:	946080e7          	jalr	-1722(ra) # 56 <panic>
    ret = parseredirs(ret, ps, es);
     718:	8656                	mv	a2,s5
     71a:	85d2                	mv	a1,s4
     71c:	8526                	mv	a0,s1
     71e:	00000097          	auipc	ra,0x0
     722:	e7a080e7          	jalr	-390(ra) # 598 <parseredirs>
     726:	84aa                	mv	s1,a0
  while(!peek(ps, es, "|)&;")){
     728:	865a                	mv	a2,s6
     72a:	85d6                	mv	a1,s5
     72c:	8552                	mv	a0,s4
     72e:	00000097          	auipc	ra,0x0
     732:	dfe080e7          	jalr	-514(ra) # 52c <peek>
     736:	e131                	bnez	a0,77a <parseexec+0xee>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     738:	f9040693          	add	a3,s0,-112
     73c:	f9840613          	add	a2,s0,-104
     740:	85d6                	mv	a1,s5
     742:	8552                	mv	a0,s4
     744:	00000097          	auipc	ra,0x0
     748:	c9c080e7          	jalr	-868(ra) # 3e0 <gettoken>
     74c:	c51d                	beqz	a0,77a <parseexec+0xee>
    if(tok != 'a')
     74e:	fb951de3          	bne	a0,s9,708 <parseexec+0x7c>
    cmd->argv[argc] = q;
     752:	f9843783          	ld	a5,-104(s0)
     756:	00f93023          	sd	a5,0(s2)
    cmd->eargv[argc] = eq;
     75a:	f9043783          	ld	a5,-112(s0)
     75e:	04f93823          	sd	a5,80(s2)
    argc++;
     762:	2985                	addw	s3,s3,1
    if(argc >= MAXARGS)
     764:	0921                	add	s2,s2,8
     766:	fb7999e3          	bne	s3,s7,718 <parseexec+0x8c>
      panic("too many args");
     76a:	00001517          	auipc	a0,0x1
     76e:	c6e50513          	add	a0,a0,-914 # 13d8 <malloc+0x190>
     772:	00000097          	auipc	ra,0x0
     776:	8e4080e7          	jalr	-1820(ra) # 56 <panic>
  cmd->argv[argc] = 0;
     77a:	098e                	sll	s3,s3,0x3
     77c:	9c4e                	add	s8,s8,s3
     77e:	000c3423          	sd	zero,8(s8)
  cmd->eargv[argc] = 0;
     782:	040c3c23          	sd	zero,88(s8)
     786:	6946                	ld	s2,80(sp)
     788:	69a6                	ld	s3,72(sp)
     78a:	7b42                	ld	s6,48(sp)
     78c:	7ba2                	ld	s7,40(sp)
     78e:	7c02                	ld	s8,32(sp)
     790:	6ce2                	ld	s9,24(sp)
  return ret;
     792:	b79d                	j	6f8 <parseexec+0x6c>

0000000000000794 <parsepipe>:
{
     794:	7179                	add	sp,sp,-48
     796:	f406                	sd	ra,40(sp)
     798:	f022                	sd	s0,32(sp)
     79a:	ec26                	sd	s1,24(sp)
     79c:	e84a                	sd	s2,16(sp)
     79e:	e44e                	sd	s3,8(sp)
     7a0:	1800                	add	s0,sp,48
     7a2:	892a                	mv	s2,a0
     7a4:	89ae                	mv	s3,a1
  cmd = parseexec(ps, es);
     7a6:	00000097          	auipc	ra,0x0
     7aa:	ee6080e7          	jalr	-282(ra) # 68c <parseexec>
     7ae:	84aa                	mv	s1,a0
  if(peek(ps, es, "|")){
     7b0:	00001617          	auipc	a2,0x1
     7b4:	c4060613          	add	a2,a2,-960 # 13f0 <malloc+0x1a8>
     7b8:	85ce                	mv	a1,s3
     7ba:	854a                	mv	a0,s2
     7bc:	00000097          	auipc	ra,0x0
     7c0:	d70080e7          	jalr	-656(ra) # 52c <peek>
     7c4:	e909                	bnez	a0,7d6 <parsepipe+0x42>
}
     7c6:	8526                	mv	a0,s1
     7c8:	70a2                	ld	ra,40(sp)
     7ca:	7402                	ld	s0,32(sp)
     7cc:	64e2                	ld	s1,24(sp)
     7ce:	6942                	ld	s2,16(sp)
     7d0:	69a2                	ld	s3,8(sp)
     7d2:	6145                	add	sp,sp,48
     7d4:	8082                	ret
    gettoken(ps, es, 0, 0);
     7d6:	4681                	li	a3,0
     7d8:	4601                	li	a2,0
     7da:	85ce                	mv	a1,s3
     7dc:	854a                	mv	a0,s2
     7de:	00000097          	auipc	ra,0x0
     7e2:	c02080e7          	jalr	-1022(ra) # 3e0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     7e6:	85ce                	mv	a1,s3
     7e8:	854a                	mv	a0,s2
     7ea:	00000097          	auipc	ra,0x0
     7ee:	faa080e7          	jalr	-86(ra) # 794 <parsepipe>
     7f2:	85aa                	mv	a1,a0
     7f4:	8526                	mv	a0,s1
     7f6:	00000097          	auipc	ra,0x0
     7fa:	b22080e7          	jalr	-1246(ra) # 318 <pipecmd>
     7fe:	84aa                	mv	s1,a0
  return cmd;
     800:	b7d9                	j	7c6 <parsepipe+0x32>

0000000000000802 <parseline>:
{
     802:	7179                	add	sp,sp,-48
     804:	f406                	sd	ra,40(sp)
     806:	f022                	sd	s0,32(sp)
     808:	ec26                	sd	s1,24(sp)
     80a:	e84a                	sd	s2,16(sp)
     80c:	e44e                	sd	s3,8(sp)
     80e:	e052                	sd	s4,0(sp)
     810:	1800                	add	s0,sp,48
     812:	892a                	mv	s2,a0
     814:	89ae                	mv	s3,a1
  cmd = parsepipe(ps, es);
     816:	00000097          	auipc	ra,0x0
     81a:	f7e080e7          	jalr	-130(ra) # 794 <parsepipe>
     81e:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     820:	00001a17          	auipc	s4,0x1
     824:	bd8a0a13          	add	s4,s4,-1064 # 13f8 <malloc+0x1b0>
     828:	a839                	j	846 <parseline+0x44>
    gettoken(ps, es, 0, 0);
     82a:	4681                	li	a3,0
     82c:	4601                	li	a2,0
     82e:	85ce                	mv	a1,s3
     830:	854a                	mv	a0,s2
     832:	00000097          	auipc	ra,0x0
     836:	bae080e7          	jalr	-1106(ra) # 3e0 <gettoken>
    cmd = backcmd(cmd);
     83a:	8526                	mv	a0,s1
     83c:	00000097          	auipc	ra,0x0
     840:	b68080e7          	jalr	-1176(ra) # 3a4 <backcmd>
     844:	84aa                	mv	s1,a0
  while(peek(ps, es, "&")){
     846:	8652                	mv	a2,s4
     848:	85ce                	mv	a1,s3
     84a:	854a                	mv	a0,s2
     84c:	00000097          	auipc	ra,0x0
     850:	ce0080e7          	jalr	-800(ra) # 52c <peek>
     854:	f979                	bnez	a0,82a <parseline+0x28>
  if(peek(ps, es, ";")){
     856:	00001617          	auipc	a2,0x1
     85a:	baa60613          	add	a2,a2,-1110 # 1400 <malloc+0x1b8>
     85e:	85ce                	mv	a1,s3
     860:	854a                	mv	a0,s2
     862:	00000097          	auipc	ra,0x0
     866:	cca080e7          	jalr	-822(ra) # 52c <peek>
     86a:	e911                	bnez	a0,87e <parseline+0x7c>
}
     86c:	8526                	mv	a0,s1
     86e:	70a2                	ld	ra,40(sp)
     870:	7402                	ld	s0,32(sp)
     872:	64e2                	ld	s1,24(sp)
     874:	6942                	ld	s2,16(sp)
     876:	69a2                	ld	s3,8(sp)
     878:	6a02                	ld	s4,0(sp)
     87a:	6145                	add	sp,sp,48
     87c:	8082                	ret
    gettoken(ps, es, 0, 0);
     87e:	4681                	li	a3,0
     880:	4601                	li	a2,0
     882:	85ce                	mv	a1,s3
     884:	854a                	mv	a0,s2
     886:	00000097          	auipc	ra,0x0
     88a:	b5a080e7          	jalr	-1190(ra) # 3e0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     88e:	85ce                	mv	a1,s3
     890:	854a                	mv	a0,s2
     892:	00000097          	auipc	ra,0x0
     896:	f70080e7          	jalr	-144(ra) # 802 <parseline>
     89a:	85aa                	mv	a1,a0
     89c:	8526                	mv	a0,s1
     89e:	00000097          	auipc	ra,0x0
     8a2:	ac0080e7          	jalr	-1344(ra) # 35e <listcmd>
     8a6:	84aa                	mv	s1,a0
  return cmd;
     8a8:	b7d1                	j	86c <parseline+0x6a>

00000000000008aa <parseblock>:
{
     8aa:	7179                	add	sp,sp,-48
     8ac:	f406                	sd	ra,40(sp)
     8ae:	f022                	sd	s0,32(sp)
     8b0:	ec26                	sd	s1,24(sp)
     8b2:	e84a                	sd	s2,16(sp)
     8b4:	e44e                	sd	s3,8(sp)
     8b6:	1800                	add	s0,sp,48
     8b8:	84aa                	mv	s1,a0
     8ba:	892e                	mv	s2,a1
  if(!peek(ps, es, "("))
     8bc:	00001617          	auipc	a2,0x1
     8c0:	b0c60613          	add	a2,a2,-1268 # 13c8 <malloc+0x180>
     8c4:	00000097          	auipc	ra,0x0
     8c8:	c68080e7          	jalr	-920(ra) # 52c <peek>
     8cc:	c12d                	beqz	a0,92e <parseblock+0x84>
  gettoken(ps, es, 0, 0);
     8ce:	4681                	li	a3,0
     8d0:	4601                	li	a2,0
     8d2:	85ca                	mv	a1,s2
     8d4:	8526                	mv	a0,s1
     8d6:	00000097          	auipc	ra,0x0
     8da:	b0a080e7          	jalr	-1270(ra) # 3e0 <gettoken>
  cmd = parseline(ps, es);
     8de:	85ca                	mv	a1,s2
     8e0:	8526                	mv	a0,s1
     8e2:	00000097          	auipc	ra,0x0
     8e6:	f20080e7          	jalr	-224(ra) # 802 <parseline>
     8ea:	89aa                	mv	s3,a0
  if(!peek(ps, es, ")"))
     8ec:	00001617          	auipc	a2,0x1
     8f0:	b2c60613          	add	a2,a2,-1236 # 1418 <malloc+0x1d0>
     8f4:	85ca                	mv	a1,s2
     8f6:	8526                	mv	a0,s1
     8f8:	00000097          	auipc	ra,0x0
     8fc:	c34080e7          	jalr	-972(ra) # 52c <peek>
     900:	cd1d                	beqz	a0,93e <parseblock+0x94>
  gettoken(ps, es, 0, 0);
     902:	4681                	li	a3,0
     904:	4601                	li	a2,0
     906:	85ca                	mv	a1,s2
     908:	8526                	mv	a0,s1
     90a:	00000097          	auipc	ra,0x0
     90e:	ad6080e7          	jalr	-1322(ra) # 3e0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     912:	864a                	mv	a2,s2
     914:	85a6                	mv	a1,s1
     916:	854e                	mv	a0,s3
     918:	00000097          	auipc	ra,0x0
     91c:	c80080e7          	jalr	-896(ra) # 598 <parseredirs>
}
     920:	70a2                	ld	ra,40(sp)
     922:	7402                	ld	s0,32(sp)
     924:	64e2                	ld	s1,24(sp)
     926:	6942                	ld	s2,16(sp)
     928:	69a2                	ld	s3,8(sp)
     92a:	6145                	add	sp,sp,48
     92c:	8082                	ret
    panic("parseblock");
     92e:	00001517          	auipc	a0,0x1
     932:	ada50513          	add	a0,a0,-1318 # 1408 <malloc+0x1c0>
     936:	fffff097          	auipc	ra,0xfffff
     93a:	720080e7          	jalr	1824(ra) # 56 <panic>
    panic("syntax - missing )");
     93e:	00001517          	auipc	a0,0x1
     942:	ae250513          	add	a0,a0,-1310 # 1420 <malloc+0x1d8>
     946:	fffff097          	auipc	ra,0xfffff
     94a:	710080e7          	jalr	1808(ra) # 56 <panic>

000000000000094e <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     94e:	1101                	add	sp,sp,-32
     950:	ec06                	sd	ra,24(sp)
     952:	e822                	sd	s0,16(sp)
     954:	e426                	sd	s1,8(sp)
     956:	1000                	add	s0,sp,32
     958:	84aa                	mv	s1,a0
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     95a:	c521                	beqz	a0,9a2 <nulterminate+0x54>
    return 0;

  switch(cmd->type){
     95c:	4118                	lw	a4,0(a0)
     95e:	4795                	li	a5,5
     960:	04e7e163          	bltu	a5,a4,9a2 <nulterminate+0x54>
     964:	00056783          	lwu	a5,0(a0)
     968:	078a                	sll	a5,a5,0x2
     96a:	00001717          	auipc	a4,0x1
     96e:	b1670713          	add	a4,a4,-1258 # 1480 <malloc+0x238>
     972:	97ba                	add	a5,a5,a4
     974:	439c                	lw	a5,0(a5)
     976:	97ba                	add	a5,a5,a4
     978:	8782                	jr	a5
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
     97a:	651c                	ld	a5,8(a0)
     97c:	c39d                	beqz	a5,9a2 <nulterminate+0x54>
     97e:	01050793          	add	a5,a0,16
      *ecmd->eargv[i] = 0;
     982:	67b8                	ld	a4,72(a5)
     984:	00070023          	sb	zero,0(a4)
    for(i=0; ecmd->argv[i]; i++)
     988:	07a1                	add	a5,a5,8
     98a:	ff87b703          	ld	a4,-8(a5)
     98e:	fb75                	bnez	a4,982 <nulterminate+0x34>
     990:	a809                	j	9a2 <nulterminate+0x54>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
     992:	6508                	ld	a0,8(a0)
     994:	00000097          	auipc	ra,0x0
     998:	fba080e7          	jalr	-70(ra) # 94e <nulterminate>
    *rcmd->efile = 0;
     99c:	6c9c                	ld	a5,24(s1)
     99e:	00078023          	sb	zero,0(a5)
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     9a2:	8526                	mv	a0,s1
     9a4:	60e2                	ld	ra,24(sp)
     9a6:	6442                	ld	s0,16(sp)
     9a8:	64a2                	ld	s1,8(sp)
     9aa:	6105                	add	sp,sp,32
     9ac:	8082                	ret
    nulterminate(pcmd->left);
     9ae:	6508                	ld	a0,8(a0)
     9b0:	00000097          	auipc	ra,0x0
     9b4:	f9e080e7          	jalr	-98(ra) # 94e <nulterminate>
    nulterminate(pcmd->right);
     9b8:	6888                	ld	a0,16(s1)
     9ba:	00000097          	auipc	ra,0x0
     9be:	f94080e7          	jalr	-108(ra) # 94e <nulterminate>
    break;
     9c2:	b7c5                	j	9a2 <nulterminate+0x54>
    nulterminate(lcmd->left);
     9c4:	6508                	ld	a0,8(a0)
     9c6:	00000097          	auipc	ra,0x0
     9ca:	f88080e7          	jalr	-120(ra) # 94e <nulterminate>
    nulterminate(lcmd->right);
     9ce:	6888                	ld	a0,16(s1)
     9d0:	00000097          	auipc	ra,0x0
     9d4:	f7e080e7          	jalr	-130(ra) # 94e <nulterminate>
    break;
     9d8:	b7e9                	j	9a2 <nulterminate+0x54>
    nulterminate(bcmd->cmd);
     9da:	6508                	ld	a0,8(a0)
     9dc:	00000097          	auipc	ra,0x0
     9e0:	f72080e7          	jalr	-142(ra) # 94e <nulterminate>
    break;
     9e4:	bf7d                	j	9a2 <nulterminate+0x54>

00000000000009e6 <parsecmd>:
{
     9e6:	7179                	add	sp,sp,-48
     9e8:	f406                	sd	ra,40(sp)
     9ea:	f022                	sd	s0,32(sp)
     9ec:	ec26                	sd	s1,24(sp)
     9ee:	e84a                	sd	s2,16(sp)
     9f0:	1800                	add	s0,sp,48
     9f2:	fca43c23          	sd	a0,-40(s0)
  es = s + strlen(s);
     9f6:	84aa                	mv	s1,a0
     9f8:	00000097          	auipc	ra,0x0
     9fc:	1d4080e7          	jalr	468(ra) # bcc <strlen>
     a00:	1502                	sll	a0,a0,0x20
     a02:	9101                	srl	a0,a0,0x20
     a04:	94aa                	add	s1,s1,a0
  cmd = parseline(&s, es);
     a06:	85a6                	mv	a1,s1
     a08:	fd840513          	add	a0,s0,-40
     a0c:	00000097          	auipc	ra,0x0
     a10:	df6080e7          	jalr	-522(ra) # 802 <parseline>
     a14:	892a                	mv	s2,a0
  peek(&s, es, "");
     a16:	00001617          	auipc	a2,0x1
     a1a:	94260613          	add	a2,a2,-1726 # 1358 <malloc+0x110>
     a1e:	85a6                	mv	a1,s1
     a20:	fd840513          	add	a0,s0,-40
     a24:	00000097          	auipc	ra,0x0
     a28:	b08080e7          	jalr	-1272(ra) # 52c <peek>
  if(s != es){
     a2c:	fd843603          	ld	a2,-40(s0)
     a30:	00961e63          	bne	a2,s1,a4c <parsecmd+0x66>
  nulterminate(cmd);
     a34:	854a                	mv	a0,s2
     a36:	00000097          	auipc	ra,0x0
     a3a:	f18080e7          	jalr	-232(ra) # 94e <nulterminate>
}
     a3e:	854a                	mv	a0,s2
     a40:	70a2                	ld	ra,40(sp)
     a42:	7402                	ld	s0,32(sp)
     a44:	64e2                	ld	s1,24(sp)
     a46:	6942                	ld	s2,16(sp)
     a48:	6145                	add	sp,sp,48
     a4a:	8082                	ret
    fprintf(2, "leftovers: %s\n", s);
     a4c:	00001597          	auipc	a1,0x1
     a50:	9ec58593          	add	a1,a1,-1556 # 1438 <malloc+0x1f0>
     a54:	4509                	li	a0,2
     a56:	00000097          	auipc	ra,0x0
     a5a:	70c080e7          	jalr	1804(ra) # 1162 <fprintf>
    panic("syntax");
     a5e:	00001517          	auipc	a0,0x1
     a62:	97250513          	add	a0,a0,-1678 # 13d0 <malloc+0x188>
     a66:	fffff097          	auipc	ra,0xfffff
     a6a:	5f0080e7          	jalr	1520(ra) # 56 <panic>

0000000000000a6e <main>:
{
     a6e:	7179                	add	sp,sp,-48
     a70:	f406                	sd	ra,40(sp)
     a72:	f022                	sd	s0,32(sp)
     a74:	ec26                	sd	s1,24(sp)
     a76:	e84a                	sd	s2,16(sp)
     a78:	e44e                	sd	s3,8(sp)
     a7a:	e052                	sd	s4,0(sp)
     a7c:	1800                	add	s0,sp,48
  while((fd = open("console", O_RDWR)) >= 0){
     a7e:	00001497          	auipc	s1,0x1
     a82:	9ca48493          	add	s1,s1,-1590 # 1448 <malloc+0x200>
     a86:	4589                	li	a1,2
     a88:	8526                	mv	a0,s1
     a8a:	00000097          	auipc	ra,0x0
     a8e:	3be080e7          	jalr	958(ra) # e48 <open>
     a92:	00054963          	bltz	a0,aa4 <main+0x36>
    if(fd >= 3){
     a96:	4789                	li	a5,2
     a98:	fea7d7e3          	bge	a5,a0,a86 <main+0x18>
      close(fd);
     a9c:	00000097          	auipc	ra,0x0
     aa0:	394080e7          	jalr	916(ra) # e30 <close>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aa4:	00001497          	auipc	s1,0x1
     aa8:	57c48493          	add	s1,s1,1404 # 2020 <buf.0>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     aac:	06300913          	li	s2,99
     ab0:	02000993          	li	s3,32
     ab4:	a819                	j	aca <main+0x5c>
    if(fork1() == 0)
     ab6:	fffff097          	auipc	ra,0xfffff
     aba:	5c6080e7          	jalr	1478(ra) # 7c <fork1>
     abe:	c549                	beqz	a0,b48 <main+0xda>
    wait(0);
     ac0:	4501                	li	a0,0
     ac2:	00000097          	auipc	ra,0x0
     ac6:	34e080e7          	jalr	846(ra) # e10 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
     aca:	06400593          	li	a1,100
     ace:	8526                	mv	a0,s1
     ad0:	fffff097          	auipc	ra,0xfffff
     ad4:	530080e7          	jalr	1328(ra) # 0 <getcmd>
     ad8:	08054463          	bltz	a0,b60 <main+0xf2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     adc:	0004c783          	lbu	a5,0(s1)
     ae0:	fd279be3          	bne	a5,s2,ab6 <main+0x48>
     ae4:	0014c703          	lbu	a4,1(s1)
     ae8:	06400793          	li	a5,100
     aec:	fcf715e3          	bne	a4,a5,ab6 <main+0x48>
     af0:	0024c783          	lbu	a5,2(s1)
     af4:	fd3791e3          	bne	a5,s3,ab6 <main+0x48>
      buf[strlen(buf)-1] = 0;  // chop \n
     af8:	00001a17          	auipc	s4,0x1
     afc:	528a0a13          	add	s4,s4,1320 # 2020 <buf.0>
     b00:	8552                	mv	a0,s4
     b02:	00000097          	auipc	ra,0x0
     b06:	0ca080e7          	jalr	202(ra) # bcc <strlen>
     b0a:	fff5079b          	addw	a5,a0,-1
     b0e:	1782                	sll	a5,a5,0x20
     b10:	9381                	srl	a5,a5,0x20
     b12:	9a3e                	add	s4,s4,a5
     b14:	000a0023          	sb	zero,0(s4)
      if(chdir(buf+3) < 0)
     b18:	00001517          	auipc	a0,0x1
     b1c:	50b50513          	add	a0,a0,1291 # 2023 <buf.0+0x3>
     b20:	00000097          	auipc	ra,0x0
     b24:	358080e7          	jalr	856(ra) # e78 <chdir>
     b28:	fa0551e3          	bgez	a0,aca <main+0x5c>
        fprintf(2, "cannot cd %s\n", buf+3);
     b2c:	00001617          	auipc	a2,0x1
     b30:	4f760613          	add	a2,a2,1271 # 2023 <buf.0+0x3>
     b34:	00001597          	auipc	a1,0x1
     b38:	91c58593          	add	a1,a1,-1764 # 1450 <malloc+0x208>
     b3c:	4509                	li	a0,2
     b3e:	00000097          	auipc	ra,0x0
     b42:	624080e7          	jalr	1572(ra) # 1162 <fprintf>
     b46:	b751                	j	aca <main+0x5c>
      runcmd(parsecmd(buf));
     b48:	00001517          	auipc	a0,0x1
     b4c:	4d850513          	add	a0,a0,1240 # 2020 <buf.0>
     b50:	00000097          	auipc	ra,0x0
     b54:	e96080e7          	jalr	-362(ra) # 9e6 <parsecmd>
     b58:	fffff097          	auipc	ra,0xfffff
     b5c:	552080e7          	jalr	1362(ra) # aa <runcmd>
  exit(0);
     b60:	4501                	li	a0,0
     b62:	00000097          	auipc	ra,0x0
     b66:	2a6080e7          	jalr	678(ra) # e08 <exit>

0000000000000b6a <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     b6a:	1141                	add	sp,sp,-16
     b6c:	e406                	sd	ra,8(sp)
     b6e:	e022                	sd	s0,0(sp)
     b70:	0800                	add	s0,sp,16
  extern int main();
  main();
     b72:	00000097          	auipc	ra,0x0
     b76:	efc080e7          	jalr	-260(ra) # a6e <main>
  exit(0);
     b7a:	4501                	li	a0,0
     b7c:	00000097          	auipc	ra,0x0
     b80:	28c080e7          	jalr	652(ra) # e08 <exit>

0000000000000b84 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     b84:	1141                	add	sp,sp,-16
     b86:	e422                	sd	s0,8(sp)
     b88:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     b8a:	87aa                	mv	a5,a0
     b8c:	0585                	add	a1,a1,1
     b8e:	0785                	add	a5,a5,1
     b90:	fff5c703          	lbu	a4,-1(a1)
     b94:	fee78fa3          	sb	a4,-1(a5)
     b98:	fb75                	bnez	a4,b8c <strcpy+0x8>
    ;
  return os;
}
     b9a:	6422                	ld	s0,8(sp)
     b9c:	0141                	add	sp,sp,16
     b9e:	8082                	ret

0000000000000ba0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     ba0:	1141                	add	sp,sp,-16
     ba2:	e422                	sd	s0,8(sp)
     ba4:	0800                	add	s0,sp,16
  while(*p && *p == *q)
     ba6:	00054783          	lbu	a5,0(a0)
     baa:	cb91                	beqz	a5,bbe <strcmp+0x1e>
     bac:	0005c703          	lbu	a4,0(a1)
     bb0:	00f71763          	bne	a4,a5,bbe <strcmp+0x1e>
    p++, q++;
     bb4:	0505                	add	a0,a0,1
     bb6:	0585                	add	a1,a1,1
  while(*p && *p == *q)
     bb8:	00054783          	lbu	a5,0(a0)
     bbc:	fbe5                	bnez	a5,bac <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     bbe:	0005c503          	lbu	a0,0(a1)
}
     bc2:	40a7853b          	subw	a0,a5,a0
     bc6:	6422                	ld	s0,8(sp)
     bc8:	0141                	add	sp,sp,16
     bca:	8082                	ret

0000000000000bcc <strlen>:

uint
strlen(const char *s)
{
     bcc:	1141                	add	sp,sp,-16
     bce:	e422                	sd	s0,8(sp)
     bd0:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     bd2:	00054783          	lbu	a5,0(a0)
     bd6:	cf91                	beqz	a5,bf2 <strlen+0x26>
     bd8:	0505                	add	a0,a0,1
     bda:	87aa                	mv	a5,a0
     bdc:	86be                	mv	a3,a5
     bde:	0785                	add	a5,a5,1
     be0:	fff7c703          	lbu	a4,-1(a5)
     be4:	ff65                	bnez	a4,bdc <strlen+0x10>
     be6:	40a6853b          	subw	a0,a3,a0
     bea:	2505                	addw	a0,a0,1
    ;
  return n;
}
     bec:	6422                	ld	s0,8(sp)
     bee:	0141                	add	sp,sp,16
     bf0:	8082                	ret
  for(n = 0; s[n]; n++)
     bf2:	4501                	li	a0,0
     bf4:	bfe5                	j	bec <strlen+0x20>

0000000000000bf6 <memset>:

void*
memset(void *dst, int c, uint n)
{
     bf6:	1141                	add	sp,sp,-16
     bf8:	e422                	sd	s0,8(sp)
     bfa:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     bfc:	ca19                	beqz	a2,c12 <memset+0x1c>
     bfe:	87aa                	mv	a5,a0
     c00:	1602                	sll	a2,a2,0x20
     c02:	9201                	srl	a2,a2,0x20
     c04:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     c08:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     c0c:	0785                	add	a5,a5,1
     c0e:	fee79de3          	bne	a5,a4,c08 <memset+0x12>
  }
  return dst;
}
     c12:	6422                	ld	s0,8(sp)
     c14:	0141                	add	sp,sp,16
     c16:	8082                	ret

0000000000000c18 <strchr>:

char*
strchr(const char *s, char c)
{
     c18:	1141                	add	sp,sp,-16
     c1a:	e422                	sd	s0,8(sp)
     c1c:	0800                	add	s0,sp,16
  for(; *s; s++)
     c1e:	00054783          	lbu	a5,0(a0)
     c22:	cb99                	beqz	a5,c38 <strchr+0x20>
    if(*s == c)
     c24:	00f58763          	beq	a1,a5,c32 <strchr+0x1a>
  for(; *s; s++)
     c28:	0505                	add	a0,a0,1
     c2a:	00054783          	lbu	a5,0(a0)
     c2e:	fbfd                	bnez	a5,c24 <strchr+0xc>
      return (char*)s;
  return 0;
     c30:	4501                	li	a0,0
}
     c32:	6422                	ld	s0,8(sp)
     c34:	0141                	add	sp,sp,16
     c36:	8082                	ret
  return 0;
     c38:	4501                	li	a0,0
     c3a:	bfe5                	j	c32 <strchr+0x1a>

0000000000000c3c <gets>:

char*
gets(char *buf, int max)
{
     c3c:	711d                	add	sp,sp,-96
     c3e:	ec86                	sd	ra,88(sp)
     c40:	e8a2                	sd	s0,80(sp)
     c42:	e4a6                	sd	s1,72(sp)
     c44:	e0ca                	sd	s2,64(sp)
     c46:	fc4e                	sd	s3,56(sp)
     c48:	f852                	sd	s4,48(sp)
     c4a:	f456                	sd	s5,40(sp)
     c4c:	f05a                	sd	s6,32(sp)
     c4e:	ec5e                	sd	s7,24(sp)
     c50:	1080                	add	s0,sp,96
     c52:	8baa                	mv	s7,a0
     c54:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     c56:	892a                	mv	s2,a0
     c58:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     c5a:	4aa9                	li	s5,10
     c5c:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     c5e:	89a6                	mv	s3,s1
     c60:	2485                	addw	s1,s1,1
     c62:	0344d863          	bge	s1,s4,c92 <gets+0x56>
    cc = read(0, &c, 1);
     c66:	4605                	li	a2,1
     c68:	faf40593          	add	a1,s0,-81
     c6c:	4501                	li	a0,0
     c6e:	00000097          	auipc	ra,0x0
     c72:	1b2080e7          	jalr	434(ra) # e20 <read>
    if(cc < 1)
     c76:	00a05e63          	blez	a0,c92 <gets+0x56>
    buf[i++] = c;
     c7a:	faf44783          	lbu	a5,-81(s0)
     c7e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     c82:	01578763          	beq	a5,s5,c90 <gets+0x54>
     c86:	0905                	add	s2,s2,1
     c88:	fd679be3          	bne	a5,s6,c5e <gets+0x22>
    buf[i++] = c;
     c8c:	89a6                	mv	s3,s1
     c8e:	a011                	j	c92 <gets+0x56>
     c90:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     c92:	99de                	add	s3,s3,s7
     c94:	00098023          	sb	zero,0(s3)
  return buf;
}
     c98:	855e                	mv	a0,s7
     c9a:	60e6                	ld	ra,88(sp)
     c9c:	6446                	ld	s0,80(sp)
     c9e:	64a6                	ld	s1,72(sp)
     ca0:	6906                	ld	s2,64(sp)
     ca2:	79e2                	ld	s3,56(sp)
     ca4:	7a42                	ld	s4,48(sp)
     ca6:	7aa2                	ld	s5,40(sp)
     ca8:	7b02                	ld	s6,32(sp)
     caa:	6be2                	ld	s7,24(sp)
     cac:	6125                	add	sp,sp,96
     cae:	8082                	ret

0000000000000cb0 <stat>:

int
stat(const char *n, struct stat *st)
{
     cb0:	1101                	add	sp,sp,-32
     cb2:	ec06                	sd	ra,24(sp)
     cb4:	e822                	sd	s0,16(sp)
     cb6:	e04a                	sd	s2,0(sp)
     cb8:	1000                	add	s0,sp,32
     cba:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     cbc:	4581                	li	a1,0
     cbe:	00000097          	auipc	ra,0x0
     cc2:	18a080e7          	jalr	394(ra) # e48 <open>
  if(fd < 0)
     cc6:	02054663          	bltz	a0,cf2 <stat+0x42>
     cca:	e426                	sd	s1,8(sp)
     ccc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     cce:	85ca                	mv	a1,s2
     cd0:	00000097          	auipc	ra,0x0
     cd4:	190080e7          	jalr	400(ra) # e60 <fstat>
     cd8:	892a                	mv	s2,a0
  close(fd);
     cda:	8526                	mv	a0,s1
     cdc:	00000097          	auipc	ra,0x0
     ce0:	154080e7          	jalr	340(ra) # e30 <close>
  return r;
     ce4:	64a2                	ld	s1,8(sp)
}
     ce6:	854a                	mv	a0,s2
     ce8:	60e2                	ld	ra,24(sp)
     cea:	6442                	ld	s0,16(sp)
     cec:	6902                	ld	s2,0(sp)
     cee:	6105                	add	sp,sp,32
     cf0:	8082                	ret
    return -1;
     cf2:	597d                	li	s2,-1
     cf4:	bfcd                	j	ce6 <stat+0x36>

0000000000000cf6 <atoi>:

#ifdef SNU
// Make atoi() recognize negative integers
int
atoi(const char *s)
{
     cf6:	1141                	add	sp,sp,-16
     cf8:	e422                	sd	s0,8(sp)
     cfa:	0800                	add	s0,sp,16
  int n = 0;
  int sign = (*s == '-')? s++, -1 : 1;
     cfc:	00054703          	lbu	a4,0(a0)
     d00:	02d00793          	li	a5,45
     d04:	4585                	li	a1,1
     d06:	04f70363          	beq	a4,a5,d4c <atoi+0x56>

  while('0' <= *s && *s <= '9')
     d0a:	00054703          	lbu	a4,0(a0)
     d0e:	fd07079b          	addw	a5,a4,-48
     d12:	0ff7f793          	zext.b	a5,a5
     d16:	46a5                	li	a3,9
     d18:	02f6ed63          	bltu	a3,a5,d52 <atoi+0x5c>
  int n = 0;
     d1c:	4681                	li	a3,0
  while('0' <= *s && *s <= '9')
     d1e:	4625                	li	a2,9
    n = n*10 + *s++ - '0';
     d20:	0505                	add	a0,a0,1
     d22:	0026979b          	sllw	a5,a3,0x2
     d26:	9fb5                	addw	a5,a5,a3
     d28:	0017979b          	sllw	a5,a5,0x1
     d2c:	9fb9                	addw	a5,a5,a4
     d2e:	fd07869b          	addw	a3,a5,-48
  while('0' <= *s && *s <= '9')
     d32:	00054703          	lbu	a4,0(a0)
     d36:	fd07079b          	addw	a5,a4,-48
     d3a:	0ff7f793          	zext.b	a5,a5
     d3e:	fef671e3          	bgeu	a2,a5,d20 <atoi+0x2a>
  return sign * n;
}
     d42:	02d5853b          	mulw	a0,a1,a3
     d46:	6422                	ld	s0,8(sp)
     d48:	0141                	add	sp,sp,16
     d4a:	8082                	ret
  int sign = (*s == '-')? s++, -1 : 1;
     d4c:	0505                	add	a0,a0,1
     d4e:	55fd                	li	a1,-1
     d50:	bf6d                	j	d0a <atoi+0x14>
  int n = 0;
     d52:	4681                	li	a3,0
     d54:	b7fd                	j	d42 <atoi+0x4c>

0000000000000d56 <memmove>:
}
#endif

void*
memmove(void *vdst, const void *vsrc, int n)
{
     d56:	1141                	add	sp,sp,-16
     d58:	e422                	sd	s0,8(sp)
     d5a:	0800                	add	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     d5c:	02b57463          	bgeu	a0,a1,d84 <memmove+0x2e>
    while(n-- > 0)
     d60:	00c05f63          	blez	a2,d7e <memmove+0x28>
     d64:	1602                	sll	a2,a2,0x20
     d66:	9201                	srl	a2,a2,0x20
     d68:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     d6c:	872a                	mv	a4,a0
      *dst++ = *src++;
     d6e:	0585                	add	a1,a1,1
     d70:	0705                	add	a4,a4,1
     d72:	fff5c683          	lbu	a3,-1(a1)
     d76:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     d7a:	fef71ae3          	bne	a4,a5,d6e <memmove+0x18>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     d7e:	6422                	ld	s0,8(sp)
     d80:	0141                	add	sp,sp,16
     d82:	8082                	ret
    dst += n;
     d84:	00c50733          	add	a4,a0,a2
    src += n;
     d88:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     d8a:	fec05ae3          	blez	a2,d7e <memmove+0x28>
     d8e:	fff6079b          	addw	a5,a2,-1
     d92:	1782                	sll	a5,a5,0x20
     d94:	9381                	srl	a5,a5,0x20
     d96:	fff7c793          	not	a5,a5
     d9a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     d9c:	15fd                	add	a1,a1,-1
     d9e:	177d                	add	a4,a4,-1
     da0:	0005c683          	lbu	a3,0(a1)
     da4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     da8:	fee79ae3          	bne	a5,a4,d9c <memmove+0x46>
     dac:	bfc9                	j	d7e <memmove+0x28>

0000000000000dae <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     dae:	1141                	add	sp,sp,-16
     db0:	e422                	sd	s0,8(sp)
     db2:	0800                	add	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     db4:	ca05                	beqz	a2,de4 <memcmp+0x36>
     db6:	fff6069b          	addw	a3,a2,-1
     dba:	1682                	sll	a3,a3,0x20
     dbc:	9281                	srl	a3,a3,0x20
     dbe:	0685                	add	a3,a3,1
     dc0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     dc2:	00054783          	lbu	a5,0(a0)
     dc6:	0005c703          	lbu	a4,0(a1)
     dca:	00e79863          	bne	a5,a4,dda <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     dce:	0505                	add	a0,a0,1
    p2++;
     dd0:	0585                	add	a1,a1,1
  while (n-- > 0) {
     dd2:	fed518e3          	bne	a0,a3,dc2 <memcmp+0x14>
  }
  return 0;
     dd6:	4501                	li	a0,0
     dd8:	a019                	j	dde <memcmp+0x30>
      return *p1 - *p2;
     dda:	40e7853b          	subw	a0,a5,a4
}
     dde:	6422                	ld	s0,8(sp)
     de0:	0141                	add	sp,sp,16
     de2:	8082                	ret
  return 0;
     de4:	4501                	li	a0,0
     de6:	bfe5                	j	dde <memcmp+0x30>

0000000000000de8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     de8:	1141                	add	sp,sp,-16
     dea:	e406                	sd	ra,8(sp)
     dec:	e022                	sd	s0,0(sp)
     dee:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
     df0:	00000097          	auipc	ra,0x0
     df4:	f66080e7          	jalr	-154(ra) # d56 <memmove>
}
     df8:	60a2                	ld	ra,8(sp)
     dfa:	6402                	ld	s0,0(sp)
     dfc:	0141                	add	sp,sp,16
     dfe:	8082                	ret

0000000000000e00 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     e00:	4885                	li	a7,1
 ecall
     e02:	00000073          	ecall
 ret
     e06:	8082                	ret

0000000000000e08 <exit>:
.global exit
exit:
 li a7, SYS_exit
     e08:	4889                	li	a7,2
 ecall
     e0a:	00000073          	ecall
 ret
     e0e:	8082                	ret

0000000000000e10 <wait>:
.global wait
wait:
 li a7, SYS_wait
     e10:	488d                	li	a7,3
 ecall
     e12:	00000073          	ecall
 ret
     e16:	8082                	ret

0000000000000e18 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     e18:	4891                	li	a7,4
 ecall
     e1a:	00000073          	ecall
 ret
     e1e:	8082                	ret

0000000000000e20 <read>:
.global read
read:
 li a7, SYS_read
     e20:	4895                	li	a7,5
 ecall
     e22:	00000073          	ecall
 ret
     e26:	8082                	ret

0000000000000e28 <write>:
.global write
write:
 li a7, SYS_write
     e28:	48c1                	li	a7,16
 ecall
     e2a:	00000073          	ecall
 ret
     e2e:	8082                	ret

0000000000000e30 <close>:
.global close
close:
 li a7, SYS_close
     e30:	48d5                	li	a7,21
 ecall
     e32:	00000073          	ecall
 ret
     e36:	8082                	ret

0000000000000e38 <kill>:
.global kill
kill:
 li a7, SYS_kill
     e38:	4899                	li	a7,6
 ecall
     e3a:	00000073          	ecall
 ret
     e3e:	8082                	ret

0000000000000e40 <exec>:
.global exec
exec:
 li a7, SYS_exec
     e40:	489d                	li	a7,7
 ecall
     e42:	00000073          	ecall
 ret
     e46:	8082                	ret

0000000000000e48 <open>:
.global open
open:
 li a7, SYS_open
     e48:	48bd                	li	a7,15
 ecall
     e4a:	00000073          	ecall
 ret
     e4e:	8082                	ret

0000000000000e50 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     e50:	48c5                	li	a7,17
 ecall
     e52:	00000073          	ecall
 ret
     e56:	8082                	ret

0000000000000e58 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     e58:	48c9                	li	a7,18
 ecall
     e5a:	00000073          	ecall
 ret
     e5e:	8082                	ret

0000000000000e60 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     e60:	48a1                	li	a7,8
 ecall
     e62:	00000073          	ecall
 ret
     e66:	8082                	ret

0000000000000e68 <link>:
.global link
link:
 li a7, SYS_link
     e68:	48cd                	li	a7,19
 ecall
     e6a:	00000073          	ecall
 ret
     e6e:	8082                	ret

0000000000000e70 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     e70:	48d1                	li	a7,20
 ecall
     e72:	00000073          	ecall
 ret
     e76:	8082                	ret

0000000000000e78 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     e78:	48a5                	li	a7,9
 ecall
     e7a:	00000073          	ecall
 ret
     e7e:	8082                	ret

0000000000000e80 <dup>:
.global dup
dup:
 li a7, SYS_dup
     e80:	48a9                	li	a7,10
 ecall
     e82:	00000073          	ecall
 ret
     e86:	8082                	ret

0000000000000e88 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     e88:	48ad                	li	a7,11
 ecall
     e8a:	00000073          	ecall
 ret
     e8e:	8082                	ret

0000000000000e90 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     e90:	48b1                	li	a7,12
 ecall
     e92:	00000073          	ecall
 ret
     e96:	8082                	ret

0000000000000e98 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     e98:	48b5                	li	a7,13
 ecall
     e9a:	00000073          	ecall
 ret
     e9e:	8082                	ret

0000000000000ea0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     ea0:	48b9                	li	a7,14
 ecall
     ea2:	00000073          	ecall
 ret
     ea6:	8082                	ret

0000000000000ea8 <kcall>:
.global kcall
kcall:
 li a7, SYS_kcall
     ea8:	48d9                	li	a7,22
 ecall
     eaa:	00000073          	ecall
 ret
     eae:	8082                	ret

0000000000000eb0 <ktest>:
.global ktest
ktest:
 li a7, SYS_ktest
     eb0:	48dd                	li	a7,23
 ecall
     eb2:	00000073          	ecall
 ret
     eb6:	8082                	ret

0000000000000eb8 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     eb8:	48e1                	li	a7,24
 ecall
     eba:	00000073          	ecall
 ret
     ebe:	8082                	ret

0000000000000ec0 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     ec0:	48e5                	li	a7,25
 ecall
     ec2:	00000073          	ecall
 ret
     ec6:	8082                	ret

0000000000000ec8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     ec8:	1101                	add	sp,sp,-32
     eca:	ec06                	sd	ra,24(sp)
     ecc:	e822                	sd	s0,16(sp)
     ece:	1000                	add	s0,sp,32
     ed0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     ed4:	4605                	li	a2,1
     ed6:	fef40593          	add	a1,s0,-17
     eda:	00000097          	auipc	ra,0x0
     ede:	f4e080e7          	jalr	-178(ra) # e28 <write>
}
     ee2:	60e2                	ld	ra,24(sp)
     ee4:	6442                	ld	s0,16(sp)
     ee6:	6105                	add	sp,sp,32
     ee8:	8082                	ret

0000000000000eea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     eea:	7139                	add	sp,sp,-64
     eec:	fc06                	sd	ra,56(sp)
     eee:	f822                	sd	s0,48(sp)
     ef0:	f426                	sd	s1,40(sp)
     ef2:	0080                	add	s0,sp,64
     ef4:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     ef6:	c299                	beqz	a3,efc <printint+0x12>
     ef8:	0805cb63          	bltz	a1,f8e <printint+0xa4>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     efc:	2581                	sext.w	a1,a1
  neg = 0;
     efe:	4881                	li	a7,0
     f00:	fc040693          	add	a3,s0,-64
  }

  i = 0;
     f04:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     f06:	2601                	sext.w	a2,a2
     f08:	00000517          	auipc	a0,0x0
     f0c:	5e850513          	add	a0,a0,1512 # 14f0 <digits>
     f10:	883a                	mv	a6,a4
     f12:	2705                	addw	a4,a4,1
     f14:	02c5f7bb          	remuw	a5,a1,a2
     f18:	1782                	sll	a5,a5,0x20
     f1a:	9381                	srl	a5,a5,0x20
     f1c:	97aa                	add	a5,a5,a0
     f1e:	0007c783          	lbu	a5,0(a5)
     f22:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     f26:	0005879b          	sext.w	a5,a1
     f2a:	02c5d5bb          	divuw	a1,a1,a2
     f2e:	0685                	add	a3,a3,1
     f30:	fec7f0e3          	bgeu	a5,a2,f10 <printint+0x26>
  if(neg)
     f34:	00088c63          	beqz	a7,f4c <printint+0x62>
    buf[i++] = '-';
     f38:	fd070793          	add	a5,a4,-48
     f3c:	00878733          	add	a4,a5,s0
     f40:	02d00793          	li	a5,45
     f44:	fef70823          	sb	a5,-16(a4)
     f48:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
     f4c:	02e05c63          	blez	a4,f84 <printint+0x9a>
     f50:	f04a                	sd	s2,32(sp)
     f52:	ec4e                	sd	s3,24(sp)
     f54:	fc040793          	add	a5,s0,-64
     f58:	00e78933          	add	s2,a5,a4
     f5c:	fff78993          	add	s3,a5,-1
     f60:	99ba                	add	s3,s3,a4
     f62:	377d                	addw	a4,a4,-1
     f64:	1702                	sll	a4,a4,0x20
     f66:	9301                	srl	a4,a4,0x20
     f68:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     f6c:	fff94583          	lbu	a1,-1(s2)
     f70:	8526                	mv	a0,s1
     f72:	00000097          	auipc	ra,0x0
     f76:	f56080e7          	jalr	-170(ra) # ec8 <putc>
  while(--i >= 0)
     f7a:	197d                	add	s2,s2,-1
     f7c:	ff3918e3          	bne	s2,s3,f6c <printint+0x82>
     f80:	7902                	ld	s2,32(sp)
     f82:	69e2                	ld	s3,24(sp)
}
     f84:	70e2                	ld	ra,56(sp)
     f86:	7442                	ld	s0,48(sp)
     f88:	74a2                	ld	s1,40(sp)
     f8a:	6121                	add	sp,sp,64
     f8c:	8082                	ret
    x = -xx;
     f8e:	40b005bb          	negw	a1,a1
    neg = 1;
     f92:	4885                	li	a7,1
    x = -xx;
     f94:	b7b5                	j	f00 <printint+0x16>

0000000000000f96 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     f96:	715d                	add	sp,sp,-80
     f98:	e486                	sd	ra,72(sp)
     f9a:	e0a2                	sd	s0,64(sp)
     f9c:	f84a                	sd	s2,48(sp)
     f9e:	0880                	add	s0,sp,80
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     fa0:	0005c903          	lbu	s2,0(a1)
     fa4:	1a090a63          	beqz	s2,1158 <vprintf+0x1c2>
     fa8:	fc26                	sd	s1,56(sp)
     faa:	f44e                	sd	s3,40(sp)
     fac:	f052                	sd	s4,32(sp)
     fae:	ec56                	sd	s5,24(sp)
     fb0:	e85a                	sd	s6,16(sp)
     fb2:	e45e                	sd	s7,8(sp)
     fb4:	8aaa                	mv	s5,a0
     fb6:	8bb2                	mv	s7,a2
     fb8:	00158493          	add	s1,a1,1
  state = 0;
     fbc:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     fbe:	02500a13          	li	s4,37
     fc2:	4b55                	li	s6,21
     fc4:	a839                	j	fe2 <vprintf+0x4c>
        putc(fd, c);
     fc6:	85ca                	mv	a1,s2
     fc8:	8556                	mv	a0,s5
     fca:	00000097          	auipc	ra,0x0
     fce:	efe080e7          	jalr	-258(ra) # ec8 <putc>
     fd2:	a019                	j	fd8 <vprintf+0x42>
    } else if(state == '%'){
     fd4:	01498d63          	beq	s3,s4,fee <vprintf+0x58>
  for(i = 0; fmt[i]; i++){
     fd8:	0485                	add	s1,s1,1
     fda:	fff4c903          	lbu	s2,-1(s1)
     fde:	16090763          	beqz	s2,114c <vprintf+0x1b6>
    if(state == 0){
     fe2:	fe0999e3          	bnez	s3,fd4 <vprintf+0x3e>
      if(c == '%'){
     fe6:	ff4910e3          	bne	s2,s4,fc6 <vprintf+0x30>
        state = '%';
     fea:	89d2                	mv	s3,s4
     fec:	b7f5                	j	fd8 <vprintf+0x42>
      if(c == 'd'){
     fee:	13490463          	beq	s2,s4,1116 <vprintf+0x180>
     ff2:	f9d9079b          	addw	a5,s2,-99
     ff6:	0ff7f793          	zext.b	a5,a5
     ffa:	12fb6763          	bltu	s6,a5,1128 <vprintf+0x192>
     ffe:	f9d9079b          	addw	a5,s2,-99
    1002:	0ff7f713          	zext.b	a4,a5
    1006:	12eb6163          	bltu	s6,a4,1128 <vprintf+0x192>
    100a:	00271793          	sll	a5,a4,0x2
    100e:	00000717          	auipc	a4,0x0
    1012:	48a70713          	add	a4,a4,1162 # 1498 <malloc+0x250>
    1016:	97ba                	add	a5,a5,a4
    1018:	439c                	lw	a5,0(a5)
    101a:	97ba                	add	a5,a5,a4
    101c:	8782                	jr	a5
        printint(fd, va_arg(ap, int), 10, 1);
    101e:	008b8913          	add	s2,s7,8
    1022:	4685                	li	a3,1
    1024:	4629                	li	a2,10
    1026:	000ba583          	lw	a1,0(s7)
    102a:	8556                	mv	a0,s5
    102c:	00000097          	auipc	ra,0x0
    1030:	ebe080e7          	jalr	-322(ra) # eea <printint>
    1034:	8bca                	mv	s7,s2
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1036:	4981                	li	s3,0
    1038:	b745                	j	fd8 <vprintf+0x42>
        printint(fd, va_arg(ap, uint64), 10, 0);
    103a:	008b8913          	add	s2,s7,8
    103e:	4681                	li	a3,0
    1040:	4629                	li	a2,10
    1042:	000ba583          	lw	a1,0(s7)
    1046:	8556                	mv	a0,s5
    1048:	00000097          	auipc	ra,0x0
    104c:	ea2080e7          	jalr	-350(ra) # eea <printint>
    1050:	8bca                	mv	s7,s2
      state = 0;
    1052:	4981                	li	s3,0
    1054:	b751                	j	fd8 <vprintf+0x42>
        printint(fd, va_arg(ap, int), 16, 0);
    1056:	008b8913          	add	s2,s7,8
    105a:	4681                	li	a3,0
    105c:	4641                	li	a2,16
    105e:	000ba583          	lw	a1,0(s7)
    1062:	8556                	mv	a0,s5
    1064:	00000097          	auipc	ra,0x0
    1068:	e86080e7          	jalr	-378(ra) # eea <printint>
    106c:	8bca                	mv	s7,s2
      state = 0;
    106e:	4981                	li	s3,0
    1070:	b7a5                	j	fd8 <vprintf+0x42>
    1072:	e062                	sd	s8,0(sp)
        printptr(fd, va_arg(ap, uint64));
    1074:	008b8c13          	add	s8,s7,8
    1078:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    107c:	03000593          	li	a1,48
    1080:	8556                	mv	a0,s5
    1082:	00000097          	auipc	ra,0x0
    1086:	e46080e7          	jalr	-442(ra) # ec8 <putc>
  putc(fd, 'x');
    108a:	07800593          	li	a1,120
    108e:	8556                	mv	a0,s5
    1090:	00000097          	auipc	ra,0x0
    1094:	e38080e7          	jalr	-456(ra) # ec8 <putc>
    1098:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    109a:	00000b97          	auipc	s7,0x0
    109e:	456b8b93          	add	s7,s7,1110 # 14f0 <digits>
    10a2:	03c9d793          	srl	a5,s3,0x3c
    10a6:	97de                	add	a5,a5,s7
    10a8:	0007c583          	lbu	a1,0(a5)
    10ac:	8556                	mv	a0,s5
    10ae:	00000097          	auipc	ra,0x0
    10b2:	e1a080e7          	jalr	-486(ra) # ec8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    10b6:	0992                	sll	s3,s3,0x4
    10b8:	397d                	addw	s2,s2,-1
    10ba:	fe0914e3          	bnez	s2,10a2 <vprintf+0x10c>
        printptr(fd, va_arg(ap, uint64));
    10be:	8be2                	mv	s7,s8
      state = 0;
    10c0:	4981                	li	s3,0
    10c2:	6c02                	ld	s8,0(sp)
    10c4:	bf11                	j	fd8 <vprintf+0x42>
        s = va_arg(ap, char*);
    10c6:	008b8993          	add	s3,s7,8
    10ca:	000bb903          	ld	s2,0(s7)
        if(s == 0)
    10ce:	02090163          	beqz	s2,10f0 <vprintf+0x15a>
        while(*s != 0){
    10d2:	00094583          	lbu	a1,0(s2)
    10d6:	c9a5                	beqz	a1,1146 <vprintf+0x1b0>
          putc(fd, *s);
    10d8:	8556                	mv	a0,s5
    10da:	00000097          	auipc	ra,0x0
    10de:	dee080e7          	jalr	-530(ra) # ec8 <putc>
          s++;
    10e2:	0905                	add	s2,s2,1
        while(*s != 0){
    10e4:	00094583          	lbu	a1,0(s2)
    10e8:	f9e5                	bnez	a1,10d8 <vprintf+0x142>
        s = va_arg(ap, char*);
    10ea:	8bce                	mv	s7,s3
      state = 0;
    10ec:	4981                	li	s3,0
    10ee:	b5ed                	j	fd8 <vprintf+0x42>
          s = "(null)";
    10f0:	00000917          	auipc	s2,0x0
    10f4:	37090913          	add	s2,s2,880 # 1460 <malloc+0x218>
        while(*s != 0){
    10f8:	02800593          	li	a1,40
    10fc:	bff1                	j	10d8 <vprintf+0x142>
        putc(fd, va_arg(ap, uint));
    10fe:	008b8913          	add	s2,s7,8
    1102:	000bc583          	lbu	a1,0(s7)
    1106:	8556                	mv	a0,s5
    1108:	00000097          	auipc	ra,0x0
    110c:	dc0080e7          	jalr	-576(ra) # ec8 <putc>
    1110:	8bca                	mv	s7,s2
      state = 0;
    1112:	4981                	li	s3,0
    1114:	b5d1                	j	fd8 <vprintf+0x42>
        putc(fd, c);
    1116:	02500593          	li	a1,37
    111a:	8556                	mv	a0,s5
    111c:	00000097          	auipc	ra,0x0
    1120:	dac080e7          	jalr	-596(ra) # ec8 <putc>
      state = 0;
    1124:	4981                	li	s3,0
    1126:	bd4d                	j	fd8 <vprintf+0x42>
        putc(fd, '%');
    1128:	02500593          	li	a1,37
    112c:	8556                	mv	a0,s5
    112e:	00000097          	auipc	ra,0x0
    1132:	d9a080e7          	jalr	-614(ra) # ec8 <putc>
        putc(fd, c);
    1136:	85ca                	mv	a1,s2
    1138:	8556                	mv	a0,s5
    113a:	00000097          	auipc	ra,0x0
    113e:	d8e080e7          	jalr	-626(ra) # ec8 <putc>
      state = 0;
    1142:	4981                	li	s3,0
    1144:	bd51                	j	fd8 <vprintf+0x42>
        s = va_arg(ap, char*);
    1146:	8bce                	mv	s7,s3
      state = 0;
    1148:	4981                	li	s3,0
    114a:	b579                	j	fd8 <vprintf+0x42>
    114c:	74e2                	ld	s1,56(sp)
    114e:	79a2                	ld	s3,40(sp)
    1150:	7a02                	ld	s4,32(sp)
    1152:	6ae2                	ld	s5,24(sp)
    1154:	6b42                	ld	s6,16(sp)
    1156:	6ba2                	ld	s7,8(sp)
    }
  }
}
    1158:	60a6                	ld	ra,72(sp)
    115a:	6406                	ld	s0,64(sp)
    115c:	7942                	ld	s2,48(sp)
    115e:	6161                	add	sp,sp,80
    1160:	8082                	ret

0000000000001162 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1162:	715d                	add	sp,sp,-80
    1164:	ec06                	sd	ra,24(sp)
    1166:	e822                	sd	s0,16(sp)
    1168:	1000                	add	s0,sp,32
    116a:	e010                	sd	a2,0(s0)
    116c:	e414                	sd	a3,8(s0)
    116e:	e818                	sd	a4,16(s0)
    1170:	ec1c                	sd	a5,24(s0)
    1172:	03043023          	sd	a6,32(s0)
    1176:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    117a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    117e:	8622                	mv	a2,s0
    1180:	00000097          	auipc	ra,0x0
    1184:	e16080e7          	jalr	-490(ra) # f96 <vprintf>
}
    1188:	60e2                	ld	ra,24(sp)
    118a:	6442                	ld	s0,16(sp)
    118c:	6161                	add	sp,sp,80
    118e:	8082                	ret

0000000000001190 <printf>:

void
printf(const char *fmt, ...)
{
    1190:	711d                	add	sp,sp,-96
    1192:	ec06                	sd	ra,24(sp)
    1194:	e822                	sd	s0,16(sp)
    1196:	1000                	add	s0,sp,32
    1198:	e40c                	sd	a1,8(s0)
    119a:	e810                	sd	a2,16(s0)
    119c:	ec14                	sd	a3,24(s0)
    119e:	f018                	sd	a4,32(s0)
    11a0:	f41c                	sd	a5,40(s0)
    11a2:	03043823          	sd	a6,48(s0)
    11a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    11aa:	00840613          	add	a2,s0,8
    11ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    11b2:	85aa                	mv	a1,a0
    11b4:	4505                	li	a0,1
    11b6:	00000097          	auipc	ra,0x0
    11ba:	de0080e7          	jalr	-544(ra) # f96 <vprintf>
}
    11be:	60e2                	ld	ra,24(sp)
    11c0:	6442                	ld	s0,16(sp)
    11c2:	6125                	add	sp,sp,96
    11c4:	8082                	ret

00000000000011c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    11c6:	1141                	add	sp,sp,-16
    11c8:	e422                	sd	s0,8(sp)
    11ca:	0800                	add	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    11cc:	ff050693          	add	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    11d0:	00001797          	auipc	a5,0x1
    11d4:	e407b783          	ld	a5,-448(a5) # 2010 <freep>
    11d8:	a02d                	j	1202 <free+0x3c>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    11da:	4618                	lw	a4,8(a2)
    11dc:	9f2d                	addw	a4,a4,a1
    11de:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    11e2:	6398                	ld	a4,0(a5)
    11e4:	6310                	ld	a2,0(a4)
    11e6:	a83d                	j	1224 <free+0x5e>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    11e8:	ff852703          	lw	a4,-8(a0)
    11ec:	9f31                	addw	a4,a4,a2
    11ee:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    11f0:	ff053683          	ld	a3,-16(a0)
    11f4:	a091                	j	1238 <free+0x72>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    11f6:	6398                	ld	a4,0(a5)
    11f8:	00e7e463          	bltu	a5,a4,1200 <free+0x3a>
    11fc:	00e6ea63          	bltu	a3,a4,1210 <free+0x4a>
{
    1200:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1202:	fed7fae3          	bgeu	a5,a3,11f6 <free+0x30>
    1206:	6398                	ld	a4,0(a5)
    1208:	00e6e463          	bltu	a3,a4,1210 <free+0x4a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    120c:	fee7eae3          	bltu	a5,a4,1200 <free+0x3a>
  if(bp + bp->s.size == p->s.ptr){
    1210:	ff852583          	lw	a1,-8(a0)
    1214:	6390                	ld	a2,0(a5)
    1216:	02059813          	sll	a6,a1,0x20
    121a:	01c85713          	srl	a4,a6,0x1c
    121e:	9736                	add	a4,a4,a3
    1220:	fae60de3          	beq	a2,a4,11da <free+0x14>
    bp->s.ptr = p->s.ptr->s.ptr;
    1224:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    1228:	4790                	lw	a2,8(a5)
    122a:	02061593          	sll	a1,a2,0x20
    122e:	01c5d713          	srl	a4,a1,0x1c
    1232:	973e                	add	a4,a4,a5
    1234:	fae68ae3          	beq	a3,a4,11e8 <free+0x22>
    p->s.ptr = bp->s.ptr;
    1238:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    123a:	00001717          	auipc	a4,0x1
    123e:	dcf73b23          	sd	a5,-554(a4) # 2010 <freep>
}
    1242:	6422                	ld	s0,8(sp)
    1244:	0141                	add	sp,sp,16
    1246:	8082                	ret

0000000000001248 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1248:	7139                	add	sp,sp,-64
    124a:	fc06                	sd	ra,56(sp)
    124c:	f822                	sd	s0,48(sp)
    124e:	f426                	sd	s1,40(sp)
    1250:	ec4e                	sd	s3,24(sp)
    1252:	0080                	add	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1254:	02051493          	sll	s1,a0,0x20
    1258:	9081                	srl	s1,s1,0x20
    125a:	04bd                	add	s1,s1,15
    125c:	8091                	srl	s1,s1,0x4
    125e:	0014899b          	addw	s3,s1,1
    1262:	0485                	add	s1,s1,1
  if((prevp = freep) == 0){
    1264:	00001517          	auipc	a0,0x1
    1268:	dac53503          	ld	a0,-596(a0) # 2010 <freep>
    126c:	c915                	beqz	a0,12a0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    126e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1270:	4798                	lw	a4,8(a5)
    1272:	08977e63          	bgeu	a4,s1,130e <malloc+0xc6>
    1276:	f04a                	sd	s2,32(sp)
    1278:	e852                	sd	s4,16(sp)
    127a:	e456                	sd	s5,8(sp)
    127c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    127e:	8a4e                	mv	s4,s3
    1280:	0009871b          	sext.w	a4,s3
    1284:	6685                	lui	a3,0x1
    1286:	00d77363          	bgeu	a4,a3,128c <malloc+0x44>
    128a:	6a05                	lui	s4,0x1
    128c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1290:	004a1a1b          	sllw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1294:	00001917          	auipc	s2,0x1
    1298:	d7c90913          	add	s2,s2,-644 # 2010 <freep>
  if(p == (char*)-1)
    129c:	5afd                	li	s5,-1
    129e:	a091                	j	12e2 <malloc+0x9a>
    12a0:	f04a                	sd	s2,32(sp)
    12a2:	e852                	sd	s4,16(sp)
    12a4:	e456                	sd	s5,8(sp)
    12a6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    12a8:	00001797          	auipc	a5,0x1
    12ac:	de078793          	add	a5,a5,-544 # 2088 <base>
    12b0:	00001717          	auipc	a4,0x1
    12b4:	d6f73023          	sd	a5,-672(a4) # 2010 <freep>
    12b8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    12ba:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    12be:	b7c1                	j	127e <malloc+0x36>
        prevp->s.ptr = p->s.ptr;
    12c0:	6398                	ld	a4,0(a5)
    12c2:	e118                	sd	a4,0(a0)
    12c4:	a08d                	j	1326 <malloc+0xde>
  hp->s.size = nu;
    12c6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    12ca:	0541                	add	a0,a0,16
    12cc:	00000097          	auipc	ra,0x0
    12d0:	efa080e7          	jalr	-262(ra) # 11c6 <free>
  return freep;
    12d4:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    12d8:	c13d                	beqz	a0,133e <malloc+0xf6>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    12da:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    12dc:	4798                	lw	a4,8(a5)
    12de:	02977463          	bgeu	a4,s1,1306 <malloc+0xbe>
    if(p == freep)
    12e2:	00093703          	ld	a4,0(s2)
    12e6:	853e                	mv	a0,a5
    12e8:	fef719e3          	bne	a4,a5,12da <malloc+0x92>
  p = sbrk(nu * sizeof(Header));
    12ec:	8552                	mv	a0,s4
    12ee:	00000097          	auipc	ra,0x0
    12f2:	ba2080e7          	jalr	-1118(ra) # e90 <sbrk>
  if(p == (char*)-1)
    12f6:	fd5518e3          	bne	a0,s5,12c6 <malloc+0x7e>
        return 0;
    12fa:	4501                	li	a0,0
    12fc:	7902                	ld	s2,32(sp)
    12fe:	6a42                	ld	s4,16(sp)
    1300:	6aa2                	ld	s5,8(sp)
    1302:	6b02                	ld	s6,0(sp)
    1304:	a03d                	j	1332 <malloc+0xea>
    1306:	7902                	ld	s2,32(sp)
    1308:	6a42                	ld	s4,16(sp)
    130a:	6aa2                	ld	s5,8(sp)
    130c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    130e:	fae489e3          	beq	s1,a4,12c0 <malloc+0x78>
        p->s.size -= nunits;
    1312:	4137073b          	subw	a4,a4,s3
    1316:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1318:	02071693          	sll	a3,a4,0x20
    131c:	01c6d713          	srl	a4,a3,0x1c
    1320:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1322:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1326:	00001717          	auipc	a4,0x1
    132a:	cea73523          	sd	a0,-790(a4) # 2010 <freep>
      return (void*)(p + 1);
    132e:	01078513          	add	a0,a5,16
  }
}
    1332:	70e2                	ld	ra,56(sp)
    1334:	7442                	ld	s0,48(sp)
    1336:	74a2                	ld	s1,40(sp)
    1338:	69e2                	ld	s3,24(sp)
    133a:	6121                	add	sp,sp,64
    133c:	8082                	ret
    133e:	7902                	ld	s2,32(sp)
    1340:	6a42                	ld	s4,16(sp)
    1342:	6aa2                	ld	s5,8(sp)
    1344:	6b02                	ld	s6,0(sp)
    1346:	b7f5                	j	1332 <malloc+0xea>