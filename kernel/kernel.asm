
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000a117          	auipc	sp,0xa
    80000004:	cd010113          	add	sp,sp,-816 # 80009cd0 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	add	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	076000ef          	jal	8000008c <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	add	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	add	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80000026:	0007859b          	sext.w	a1,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    8000002a:	0037979b          	sllw	a5,a5,0x3
    8000002e:	02004737          	lui	a4,0x2004
    80000032:	97ba                	add	a5,a5,a4
    80000034:	0200c737          	lui	a4,0x200c
    80000038:	1761                	add	a4,a4,-8 # 200bff8 <_entry-0x7dff4008>
    8000003a:	6318                	ld	a4,0(a4)
    8000003c:	000f4637          	lui	a2,0xf4
    80000040:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	9732                	add	a4,a4,a2
    80000046:	e398                	sd	a4,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80000048:	00259693          	sll	a3,a1,0x2
    8000004c:	96ae                	add	a3,a3,a1
    8000004e:	068e                	sll	a3,a3,0x3
    80000050:	0000a717          	auipc	a4,0xa
    80000054:	b4070713          	add	a4,a4,-1216 # 80009b90 <timer_scratch>
    80000058:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    8000005a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    8000005c:	f310                	sd	a2,32(a4)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    8000005e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80000062:	00007797          	auipc	a5,0x7
    80000066:	40e78793          	add	a5,a5,1038 # 80007470 <timervec>
    8000006a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000006e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80000072:	0087e793          	or	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000076:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    8000007a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    8000007e:	0807e793          	or	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80000082:	30479073          	csrw	mie,a5
}
    80000086:	6422                	ld	s0,8(sp)
    80000088:	0141                	add	sp,sp,16
    8000008a:	8082                	ret

000000008000008c <start>:
{
    8000008c:	1141                	add	sp,sp,-16
    8000008e:	e406                	sd	ra,8(sp)
    80000090:	e022                	sd	s0,0(sp)
    80000092:	0800                	add	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000094:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000098:	7779                	lui	a4,0xffffe
    8000009a:	7ff70713          	add	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffca32f>
    8000009e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800000a0:	6705                	lui	a4,0x1
    800000a2:	80070713          	add	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000ac:	00001797          	auipc	a5,0x1
    800000b0:	5a278793          	add	a5,a5,1442 # 8000164e <main>
    800000b4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b8:	4781                	li	a5,0
    800000ba:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000be:	67c1                	lui	a5,0x10
    800000c0:	17fd                	add	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800000c2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000ca:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000ce:	2227e793          	or	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000d2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800000d6:	57fd                	li	a5,-1
    800000d8:	83a9                	srl	a5,a5,0xa
    800000da:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800000de:	47bd                	li	a5,15
    800000e0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800000e4:	00000097          	auipc	ra,0x0
    800000e8:	f38080e7          	jalr	-200(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000ec:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000f0:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000f2:	823e                	mv	tp,a5
  asm volatile("mret");
    800000f4:	30200073          	mret
}
    800000f8:	60a2                	ld	ra,8(sp)
    800000fa:	6402                	ld	s0,0(sp)
    800000fc:	0141                	add	sp,sp,16
    800000fe:	8082                	ret

0000000080000100 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80000100:	715d                	add	sp,sp,-80
    80000102:	e486                	sd	ra,72(sp)
    80000104:	e0a2                	sd	s0,64(sp)
    80000106:	f84a                	sd	s2,48(sp)
    80000108:	0880                	add	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    8000010a:	04c05663          	blez	a2,80000156 <consolewrite+0x56>
    8000010e:	fc26                	sd	s1,56(sp)
    80000110:	f44e                	sd	s3,40(sp)
    80000112:	f052                	sd	s4,32(sp)
    80000114:	ec56                	sd	s5,24(sp)
    80000116:	8a2a                	mv	s4,a0
    80000118:	84ae                	mv	s1,a1
    8000011a:	89b2                	mv	s3,a2
    8000011c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000011e:	5afd                	li	s5,-1
    80000120:	4685                	li	a3,1
    80000122:	8626                	mv	a2,s1
    80000124:	85d2                	mv	a1,s4
    80000126:	fbf40513          	add	a0,s0,-65
    8000012a:	00003097          	auipc	ra,0x3
    8000012e:	31a080e7          	jalr	794(ra) # 80003444 <either_copyin>
    80000132:	03550463          	beq	a0,s5,8000015a <consolewrite+0x5a>
      break;
    uartputc(c);
    80000136:	fbf44503          	lbu	a0,-65(s0)
    8000013a:	00001097          	auipc	ra,0x1
    8000013e:	81a080e7          	jalr	-2022(ra) # 80000954 <uartputc>
  for(i = 0; i < n; i++){
    80000142:	2905                	addw	s2,s2,1
    80000144:	0485                	add	s1,s1,1
    80000146:	fd299de3          	bne	s3,s2,80000120 <consolewrite+0x20>
    8000014a:	894e                	mv	s2,s3
    8000014c:	74e2                	ld	s1,56(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	a039                	j	80000162 <consolewrite+0x62>
    80000156:	4901                	li	s2,0
    80000158:	a029                	j	80000162 <consolewrite+0x62>
    8000015a:	74e2                	ld	s1,56(sp)
    8000015c:	79a2                	ld	s3,40(sp)
    8000015e:	7a02                	ld	s4,32(sp)
    80000160:	6ae2                	ld	s5,24(sp)
  }

  return i;
}
    80000162:	854a                	mv	a0,s2
    80000164:	60a6                	ld	ra,72(sp)
    80000166:	6406                	ld	s0,64(sp)
    80000168:	7942                	ld	s2,48(sp)
    8000016a:	6161                	add	sp,sp,80
    8000016c:	8082                	ret

000000008000016e <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000016e:	711d                	add	sp,sp,-96
    80000170:	ec86                	sd	ra,88(sp)
    80000172:	e8a2                	sd	s0,80(sp)
    80000174:	e4a6                	sd	s1,72(sp)
    80000176:	e0ca                	sd	s2,64(sp)
    80000178:	fc4e                	sd	s3,56(sp)
    8000017a:	f852                	sd	s4,48(sp)
    8000017c:	f456                	sd	s5,40(sp)
    8000017e:	f05a                	sd	s6,32(sp)
    80000180:	1080                	add	s0,sp,96
    80000182:	8aaa                	mv	s5,a0
    80000184:	8a2e                	mv	s4,a1
    80000186:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000188:	00060b1b          	sext.w	s6,a2
  acquire(&cons.lock);
    8000018c:	00012517          	auipc	a0,0x12
    80000190:	b4450513          	add	a0,a0,-1212 # 80011cd0 <cons>
    80000194:	00001097          	auipc	ra,0x1
    80000198:	220080e7          	jalr	544(ra) # 800013b4 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000019c:	00012497          	auipc	s1,0x12
    800001a0:	b3448493          	add	s1,s1,-1228 # 80011cd0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a4:	00012917          	auipc	s2,0x12
    800001a8:	bc490913          	add	s2,s2,-1084 # 80011d68 <cons+0x98>
  while(n > 0){
    800001ac:	0d305763          	blez	s3,8000027a <consoleread+0x10c>
    while(cons.r == cons.w){
    800001b0:	0984a783          	lw	a5,152(s1)
    800001b4:	09c4a703          	lw	a4,156(s1)
    800001b8:	0af71c63          	bne	a4,a5,80000270 <consoleread+0x102>
      if(killed(myproc())){
    800001bc:	00002097          	auipc	ra,0x2
    800001c0:	1c8080e7          	jalr	456(ra) # 80002384 <myproc>
    800001c4:	00003097          	auipc	ra,0x3
    800001c8:	0ca080e7          	jalr	202(ra) # 8000328e <killed>
    800001cc:	e52d                	bnez	a0,80000236 <consoleread+0xc8>
      sleep(&cons.r, &cons.lock);
    800001ce:	85a6                	mv	a1,s1
    800001d0:	854a                	mv	a0,s2
    800001d2:	00003097          	auipc	ra,0x3
    800001d6:	e14080e7          	jalr	-492(ra) # 80002fe6 <sleep>
    while(cons.r == cons.w){
    800001da:	0984a783          	lw	a5,152(s1)
    800001de:	09c4a703          	lw	a4,156(s1)
    800001e2:	fcf70de3          	beq	a4,a5,800001bc <consoleread+0x4e>
    800001e6:	ec5e                	sd	s7,24(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e8:	00012717          	auipc	a4,0x12
    800001ec:	ae870713          	add	a4,a4,-1304 # 80011cd0 <cons>
    800001f0:	0017869b          	addw	a3,a5,1
    800001f4:	08d72c23          	sw	a3,152(a4)
    800001f8:	07f7f693          	and	a3,a5,127
    800001fc:	9736                	add	a4,a4,a3
    800001fe:	01874703          	lbu	a4,24(a4)
    80000202:	00070b9b          	sext.w	s7,a4

    if(c == C('D')){  // end-of-file
    80000206:	4691                	li	a3,4
    80000208:	04db8a63          	beq	s7,a3,8000025c <consoleread+0xee>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    8000020c:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000210:	4685                	li	a3,1
    80000212:	faf40613          	add	a2,s0,-81
    80000216:	85d2                	mv	a1,s4
    80000218:	8556                	mv	a0,s5
    8000021a:	00003097          	auipc	ra,0x3
    8000021e:	1d4080e7          	jalr	468(ra) # 800033ee <either_copyout>
    80000222:	57fd                	li	a5,-1
    80000224:	04f50a63          	beq	a0,a5,80000278 <consoleread+0x10a>
      break;

    dst++;
    80000228:	0a05                	add	s4,s4,1
    --n;
    8000022a:	39fd                	addw	s3,s3,-1

    if(c == '\n'){
    8000022c:	47a9                	li	a5,10
    8000022e:	06fb8163          	beq	s7,a5,80000290 <consoleread+0x122>
    80000232:	6be2                	ld	s7,24(sp)
    80000234:	bfa5                	j	800001ac <consoleread+0x3e>
        release(&cons.lock);
    80000236:	00012517          	auipc	a0,0x12
    8000023a:	a9a50513          	add	a0,a0,-1382 # 80011cd0 <cons>
    8000023e:	00001097          	auipc	ra,0x1
    80000242:	22a080e7          	jalr	554(ra) # 80001468 <release>
        return -1;
    80000246:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000248:	60e6                	ld	ra,88(sp)
    8000024a:	6446                	ld	s0,80(sp)
    8000024c:	64a6                	ld	s1,72(sp)
    8000024e:	6906                	ld	s2,64(sp)
    80000250:	79e2                	ld	s3,56(sp)
    80000252:	7a42                	ld	s4,48(sp)
    80000254:	7aa2                	ld	s5,40(sp)
    80000256:	7b02                	ld	s6,32(sp)
    80000258:	6125                	add	sp,sp,96
    8000025a:	8082                	ret
      if(n < target){
    8000025c:	0009871b          	sext.w	a4,s3
    80000260:	01677a63          	bgeu	a4,s6,80000274 <consoleread+0x106>
        cons.r--;
    80000264:	00012717          	auipc	a4,0x12
    80000268:	b0f72223          	sw	a5,-1276(a4) # 80011d68 <cons+0x98>
    8000026c:	6be2                	ld	s7,24(sp)
    8000026e:	a031                	j	8000027a <consoleread+0x10c>
    80000270:	ec5e                	sd	s7,24(sp)
    80000272:	bf9d                	j	800001e8 <consoleread+0x7a>
    80000274:	6be2                	ld	s7,24(sp)
    80000276:	a011                	j	8000027a <consoleread+0x10c>
    80000278:	6be2                	ld	s7,24(sp)
  release(&cons.lock);
    8000027a:	00012517          	auipc	a0,0x12
    8000027e:	a5650513          	add	a0,a0,-1450 # 80011cd0 <cons>
    80000282:	00001097          	auipc	ra,0x1
    80000286:	1e6080e7          	jalr	486(ra) # 80001468 <release>
  return target - n;
    8000028a:	413b053b          	subw	a0,s6,s3
    8000028e:	bf6d                	j	80000248 <consoleread+0xda>
    80000290:	6be2                	ld	s7,24(sp)
    80000292:	b7e5                	j	8000027a <consoleread+0x10c>

0000000080000294 <consputc>:
{
    80000294:	1141                	add	sp,sp,-16
    80000296:	e406                	sd	ra,8(sp)
    80000298:	e022                	sd	s0,0(sp)
    8000029a:	0800                	add	s0,sp,16
  if(c == BACKSPACE){
    8000029c:	10000793          	li	a5,256
    800002a0:	00f50a63          	beq	a0,a5,800002b4 <consputc+0x20>
    uartputc_sync(c);
    800002a4:	00000097          	auipc	ra,0x0
    800002a8:	5d2080e7          	jalr	1490(ra) # 80000876 <uartputc_sync>
}
    800002ac:	60a2                	ld	ra,8(sp)
    800002ae:	6402                	ld	s0,0(sp)
    800002b0:	0141                	add	sp,sp,16
    800002b2:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800002b4:	4521                	li	a0,8
    800002b6:	00000097          	auipc	ra,0x0
    800002ba:	5c0080e7          	jalr	1472(ra) # 80000876 <uartputc_sync>
    800002be:	02000513          	li	a0,32
    800002c2:	00000097          	auipc	ra,0x0
    800002c6:	5b4080e7          	jalr	1460(ra) # 80000876 <uartputc_sync>
    800002ca:	4521                	li	a0,8
    800002cc:	00000097          	auipc	ra,0x0
    800002d0:	5aa080e7          	jalr	1450(ra) # 80000876 <uartputc_sync>
    800002d4:	bfe1                	j	800002ac <consputc+0x18>

00000000800002d6 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002d6:	1101                	add	sp,sp,-32
    800002d8:	ec06                	sd	ra,24(sp)
    800002da:	e822                	sd	s0,16(sp)
    800002dc:	e426                	sd	s1,8(sp)
    800002de:	1000                	add	s0,sp,32
    800002e0:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e2:	00012517          	auipc	a0,0x12
    800002e6:	9ee50513          	add	a0,a0,-1554 # 80011cd0 <cons>
    800002ea:	00001097          	auipc	ra,0x1
    800002ee:	0ca080e7          	jalr	202(ra) # 800013b4 <acquire>

  switch(c){
    800002f2:	47c1                	li	a5,16
    800002f4:	0ef48363          	beq	s1,a5,800003da <consoleintr+0x104>
    800002f8:	0097ca63          	blt	a5,s1,8000030c <consoleintr+0x36>
    800002fc:	4799                	li	a5,6
    800002fe:	12f48763          	beq	s1,a5,8000042c <consoleintr+0x156>
    80000302:	47a1                	li	a5,8
    80000304:	0ef48e63          	beq	s1,a5,80000400 <consoleintr+0x12a>
  case C('F'):
    printf("%d (freemem), %d (4K), %d (2M), %d (PF)\n", freemem, used4k, used2m, pagefaults);
    break;
#endif
  default:
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80000308:	cce9                	beqz	s1,800003e2 <consoleintr+0x10c>
    8000030a:	a801                	j	8000031a <consoleintr+0x44>
  switch(c){
    8000030c:	47d5                	li	a5,21
    8000030e:	06f48c63          	beq	s1,a5,80000386 <consoleintr+0xb0>
    80000312:	07f00793          	li	a5,127
    80000316:	0ef48563          	beq	s1,a5,80000400 <consoleintr+0x12a>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000031a:	00012717          	auipc	a4,0x12
    8000031e:	9b670713          	add	a4,a4,-1610 # 80011cd0 <cons>
    80000322:	0a072783          	lw	a5,160(a4)
    80000326:	09872703          	lw	a4,152(a4)
    8000032a:	9f99                	subw	a5,a5,a4
    8000032c:	07f00713          	li	a4,127
    80000330:	0af76963          	bltu	a4,a5,800003e2 <consoleintr+0x10c>
      c = (c == '\r') ? '\n' : c;
    80000334:	47b5                	li	a5,13
    80000336:	12f48463          	beq	s1,a5,8000045e <consoleintr+0x188>

      // echo back to the user.
      consputc(c);
    8000033a:	8526                	mv	a0,s1
    8000033c:	00000097          	auipc	ra,0x0
    80000340:	f58080e7          	jalr	-168(ra) # 80000294 <consputc>

      // store for consumption by consoleread().
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000344:	00012797          	auipc	a5,0x12
    80000348:	98c78793          	add	a5,a5,-1652 # 80011cd0 <cons>
    8000034c:	0a07a683          	lw	a3,160(a5)
    80000350:	0016871b          	addw	a4,a3,1
    80000354:	0007061b          	sext.w	a2,a4
    80000358:	0ae7a023          	sw	a4,160(a5)
    8000035c:	07f6f693          	and	a3,a3,127
    80000360:	97b6                	add	a5,a5,a3
    80000362:	00978c23          	sb	s1,24(a5)

      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80000366:	47a9                	li	a5,10
    80000368:	12f48263          	beq	s1,a5,8000048c <consoleintr+0x1b6>
    8000036c:	4791                	li	a5,4
    8000036e:	10f48f63          	beq	s1,a5,8000048c <consoleintr+0x1b6>
    80000372:	00012797          	auipc	a5,0x12
    80000376:	9f67a783          	lw	a5,-1546(a5) # 80011d68 <cons+0x98>
    8000037a:	9f1d                	subw	a4,a4,a5
    8000037c:	08000793          	li	a5,128
    80000380:	06f71163          	bne	a4,a5,800003e2 <consoleintr+0x10c>
    80000384:	a221                	j	8000048c <consoleintr+0x1b6>
    80000386:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80000388:	00012717          	auipc	a4,0x12
    8000038c:	94870713          	add	a4,a4,-1720 # 80011cd0 <cons>
    80000390:	0a072783          	lw	a5,160(a4)
    80000394:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80000398:	00012497          	auipc	s1,0x12
    8000039c:	93848493          	add	s1,s1,-1736 # 80011cd0 <cons>
    while(cons.e != cons.w &&
    800003a0:	4929                	li	s2,10
    800003a2:	02f70a63          	beq	a4,a5,800003d6 <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800003a6:	37fd                	addw	a5,a5,-1
    800003a8:	07f7f713          	and	a4,a5,127
    800003ac:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003ae:	01874703          	lbu	a4,24(a4)
    800003b2:	05270563          	beq	a4,s2,800003fc <consoleintr+0x126>
      cons.e--;
    800003b6:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800003ba:	10000513          	li	a0,256
    800003be:	00000097          	auipc	ra,0x0
    800003c2:	ed6080e7          	jalr	-298(ra) # 80000294 <consputc>
    while(cons.e != cons.w &&
    800003c6:	0a04a783          	lw	a5,160(s1)
    800003ca:	09c4a703          	lw	a4,156(s1)
    800003ce:	fcf71ce3          	bne	a4,a5,800003a6 <consoleintr+0xd0>
    800003d2:	6902                	ld	s2,0(sp)
    800003d4:	a039                	j	800003e2 <consoleintr+0x10c>
    800003d6:	6902                	ld	s2,0(sp)
    800003d8:	a029                	j	800003e2 <consoleintr+0x10c>
    procdump();
    800003da:	00003097          	auipc	ra,0x3
    800003de:	0c0080e7          	jalr	192(ra) # 8000349a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800003e2:	00012517          	auipc	a0,0x12
    800003e6:	8ee50513          	add	a0,a0,-1810 # 80011cd0 <cons>
    800003ea:	00001097          	auipc	ra,0x1
    800003ee:	07e080e7          	jalr	126(ra) # 80001468 <release>
}
    800003f2:	60e2                	ld	ra,24(sp)
    800003f4:	6442                	ld	s0,16(sp)
    800003f6:	64a2                	ld	s1,8(sp)
    800003f8:	6105                	add	sp,sp,32
    800003fa:	8082                	ret
    800003fc:	6902                	ld	s2,0(sp)
    800003fe:	b7d5                	j	800003e2 <consoleintr+0x10c>
    if(cons.e != cons.w){
    80000400:	00012717          	auipc	a4,0x12
    80000404:	8d070713          	add	a4,a4,-1840 # 80011cd0 <cons>
    80000408:	0a072783          	lw	a5,160(a4)
    8000040c:	09c72703          	lw	a4,156(a4)
    80000410:	fcf709e3          	beq	a4,a5,800003e2 <consoleintr+0x10c>
      cons.e--;
    80000414:	37fd                	addw	a5,a5,-1
    80000416:	00012717          	auipc	a4,0x12
    8000041a:	94f72d23          	sw	a5,-1702(a4) # 80011d70 <cons+0xa0>
      consputc(BACKSPACE);
    8000041e:	10000513          	li	a0,256
    80000422:	00000097          	auipc	ra,0x0
    80000426:	e72080e7          	jalr	-398(ra) # 80000294 <consputc>
    8000042a:	bf65                	j	800003e2 <consoleintr+0x10c>
    printf("%d (freemem), %d (4K), %d (2M), %d (PF)\n", freemem, used4k, used2m, pagefaults);
    8000042c:	00009717          	auipc	a4,0x9
    80000430:	74472703          	lw	a4,1860(a4) # 80009b70 <pagefaults>
    80000434:	00009697          	auipc	a3,0x9
    80000438:	7146a683          	lw	a3,1812(a3) # 80009b48 <used2m>
    8000043c:	00009617          	auipc	a2,0x9
    80000440:	71062603          	lw	a2,1808(a2) # 80009b4c <used4k>
    80000444:	00009597          	auipc	a1,0x9
    80000448:	70c5a583          	lw	a1,1804(a1) # 80009b50 <freemem>
    8000044c:	00009517          	auipc	a0,0x9
    80000450:	bb450513          	add	a0,a0,-1100 # 80009000 <etext>
    80000454:	00000097          	auipc	ra,0x0
    80000458:	18c080e7          	jalr	396(ra) # 800005e0 <printf>
    break;
    8000045c:	b759                	j	800003e2 <consoleintr+0x10c>
      consputc(c);
    8000045e:	4529                	li	a0,10
    80000460:	00000097          	auipc	ra,0x0
    80000464:	e34080e7          	jalr	-460(ra) # 80000294 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000468:	00012797          	auipc	a5,0x12
    8000046c:	86878793          	add	a5,a5,-1944 # 80011cd0 <cons>
    80000470:	0a07a703          	lw	a4,160(a5)
    80000474:	0017069b          	addw	a3,a4,1
    80000478:	0006861b          	sext.w	a2,a3
    8000047c:	0ad7a023          	sw	a3,160(a5)
    80000480:	07f77713          	and	a4,a4,127
    80000484:	97ba                	add	a5,a5,a4
    80000486:	4729                	li	a4,10
    80000488:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000048c:	00012797          	auipc	a5,0x12
    80000490:	8ec7a023          	sw	a2,-1824(a5) # 80011d6c <cons+0x9c>
        wakeup(&cons.r);
    80000494:	00012517          	auipc	a0,0x12
    80000498:	8d450513          	add	a0,a0,-1836 # 80011d68 <cons+0x98>
    8000049c:	00003097          	auipc	ra,0x3
    800004a0:	bae080e7          	jalr	-1106(ra) # 8000304a <wakeup>
    800004a4:	bf3d                	j	800003e2 <consoleintr+0x10c>

00000000800004a6 <consoleinit>:

void
consoleinit(void)
{
    800004a6:	1141                	add	sp,sp,-16
    800004a8:	e406                	sd	ra,8(sp)
    800004aa:	e022                	sd	s0,0(sp)
    800004ac:	0800                	add	s0,sp,16
  initlock(&cons.lock, "cons");
    800004ae:	00009597          	auipc	a1,0x9
    800004b2:	b8258593          	add	a1,a1,-1150 # 80009030 <etext+0x30>
    800004b6:	00012517          	auipc	a0,0x12
    800004ba:	81a50513          	add	a0,a0,-2022 # 80011cd0 <cons>
    800004be:	00001097          	auipc	ra,0x1
    800004c2:	e66080e7          	jalr	-410(ra) # 80001324 <initlock>

  uartinit();
    800004c6:	00000097          	auipc	ra,0x0
    800004ca:	354080e7          	jalr	852(ra) # 8000081a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800004ce:	00033797          	auipc	a5,0x33
    800004d2:	e6a78793          	add	a5,a5,-406 # 80033338 <devsw>
    800004d6:	00000717          	auipc	a4,0x0
    800004da:	c9870713          	add	a4,a4,-872 # 8000016e <consoleread>
    800004de:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004e0:	00000717          	auipc	a4,0x0
    800004e4:	c2070713          	add	a4,a4,-992 # 80000100 <consolewrite>
    800004e8:	ef98                	sd	a4,24(a5)
}
    800004ea:	60a2                	ld	ra,8(sp)
    800004ec:	6402                	ld	s0,0(sp)
    800004ee:	0141                	add	sp,sp,16
    800004f0:	8082                	ret

00000000800004f2 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004f2:	7179                	add	sp,sp,-48
    800004f4:	f406                	sd	ra,40(sp)
    800004f6:	f022                	sd	s0,32(sp)
    800004f8:	1800                	add	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004fa:	c219                	beqz	a2,80000500 <printint+0xe>
    800004fc:	08054963          	bltz	a0,8000058e <printint+0x9c>
    x = -xx;
  else
    x = xx;
    80000500:	2501                	sext.w	a0,a0
    80000502:	4881                	li	a7,0
    80000504:	fd040693          	add	a3,s0,-48

  i = 0;
    80000508:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000050a:	2581                	sext.w	a1,a1
    8000050c:	00009617          	auipc	a2,0x9
    80000510:	4a460613          	add	a2,a2,1188 # 800099b0 <digits>
    80000514:	883a                	mv	a6,a4
    80000516:	2705                	addw	a4,a4,1
    80000518:	02b577bb          	remuw	a5,a0,a1
    8000051c:	1782                	sll	a5,a5,0x20
    8000051e:	9381                	srl	a5,a5,0x20
    80000520:	97b2                	add	a5,a5,a2
    80000522:	0007c783          	lbu	a5,0(a5)
    80000526:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000052a:	0005079b          	sext.w	a5,a0
    8000052e:	02b5553b          	divuw	a0,a0,a1
    80000532:	0685                	add	a3,a3,1
    80000534:	feb7f0e3          	bgeu	a5,a1,80000514 <printint+0x22>

  if(sign)
    80000538:	00088c63          	beqz	a7,80000550 <printint+0x5e>
    buf[i++] = '-';
    8000053c:	fe070793          	add	a5,a4,-32
    80000540:	00878733          	add	a4,a5,s0
    80000544:	02d00793          	li	a5,45
    80000548:	fef70823          	sb	a5,-16(a4)
    8000054c:	0028071b          	addw	a4,a6,2

  while(--i >= 0)
    80000550:	02e05b63          	blez	a4,80000586 <printint+0x94>
    80000554:	ec26                	sd	s1,24(sp)
    80000556:	e84a                	sd	s2,16(sp)
    80000558:	fd040793          	add	a5,s0,-48
    8000055c:	00e784b3          	add	s1,a5,a4
    80000560:	fff78913          	add	s2,a5,-1
    80000564:	993a                	add	s2,s2,a4
    80000566:	377d                	addw	a4,a4,-1
    80000568:	1702                	sll	a4,a4,0x20
    8000056a:	9301                	srl	a4,a4,0x20
    8000056c:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000570:	fff4c503          	lbu	a0,-1(s1)
    80000574:	00000097          	auipc	ra,0x0
    80000578:	d20080e7          	jalr	-736(ra) # 80000294 <consputc>
  while(--i >= 0)
    8000057c:	14fd                	add	s1,s1,-1
    8000057e:	ff2499e3          	bne	s1,s2,80000570 <printint+0x7e>
    80000582:	64e2                	ld	s1,24(sp)
    80000584:	6942                	ld	s2,16(sp)
}
    80000586:	70a2                	ld	ra,40(sp)
    80000588:	7402                	ld	s0,32(sp)
    8000058a:	6145                	add	sp,sp,48
    8000058c:	8082                	ret
    x = -xx;
    8000058e:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000592:	4885                	li	a7,1
    x = -xx;
    80000594:	bf85                	j	80000504 <printint+0x12>

0000000080000596 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80000596:	1101                	add	sp,sp,-32
    80000598:	ec06                	sd	ra,24(sp)
    8000059a:	e822                	sd	s0,16(sp)
    8000059c:	e426                	sd	s1,8(sp)
    8000059e:	1000                	add	s0,sp,32
    800005a0:	84aa                	mv	s1,a0
  pr.locking = 0;
    800005a2:	00011797          	auipc	a5,0x11
    800005a6:	7e07a723          	sw	zero,2030(a5) # 80011d90 <pr+0x18>
  printf("panic: ");
    800005aa:	00009517          	auipc	a0,0x9
    800005ae:	a8e50513          	add	a0,a0,-1394 # 80009038 <etext+0x38>
    800005b2:	00000097          	auipc	ra,0x0
    800005b6:	02e080e7          	jalr	46(ra) # 800005e0 <printf>
  printf(s);
    800005ba:	8526                	mv	a0,s1
    800005bc:	00000097          	auipc	ra,0x0
    800005c0:	024080e7          	jalr	36(ra) # 800005e0 <printf>
  printf("\n");
    800005c4:	00009517          	auipc	a0,0x9
    800005c8:	a7c50513          	add	a0,a0,-1412 # 80009040 <etext+0x40>
    800005cc:	00000097          	auipc	ra,0x0
    800005d0:	014080e7          	jalr	20(ra) # 800005e0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    800005d4:	4785                	li	a5,1
    800005d6:	00009717          	auipc	a4,0x9
    800005da:	54f72d23          	sw	a5,1370(a4) # 80009b30 <panicked>
  for(;;)
    800005de:	a001                	j	800005de <panic+0x48>

00000000800005e0 <printf>:
{
    800005e0:	7131                	add	sp,sp,-192
    800005e2:	fc86                	sd	ra,120(sp)
    800005e4:	f8a2                	sd	s0,112(sp)
    800005e6:	e8d2                	sd	s4,80(sp)
    800005e8:	f06a                	sd	s10,32(sp)
    800005ea:	0100                	add	s0,sp,128
    800005ec:	8a2a                	mv	s4,a0
    800005ee:	e40c                	sd	a1,8(s0)
    800005f0:	e810                	sd	a2,16(s0)
    800005f2:	ec14                	sd	a3,24(s0)
    800005f4:	f018                	sd	a4,32(s0)
    800005f6:	f41c                	sd	a5,40(s0)
    800005f8:	03043823          	sd	a6,48(s0)
    800005fc:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80000600:	00011d17          	auipc	s10,0x11
    80000604:	790d2d03          	lw	s10,1936(s10) # 80011d90 <pr+0x18>
  if(locking)
    80000608:	040d1463          	bnez	s10,80000650 <printf+0x70>
  if (fmt == 0)
    8000060c:	040a0b63          	beqz	s4,80000662 <printf+0x82>
  va_start(ap, fmt);
    80000610:	00840793          	add	a5,s0,8
    80000614:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80000618:	000a4503          	lbu	a0,0(s4)
    8000061c:	18050b63          	beqz	a0,800007b2 <printf+0x1d2>
    80000620:	f4a6                	sd	s1,104(sp)
    80000622:	f0ca                	sd	s2,96(sp)
    80000624:	ecce                	sd	s3,88(sp)
    80000626:	e4d6                	sd	s5,72(sp)
    80000628:	e0da                	sd	s6,64(sp)
    8000062a:	fc5e                	sd	s7,56(sp)
    8000062c:	f862                	sd	s8,48(sp)
    8000062e:	f466                	sd	s9,40(sp)
    80000630:	ec6e                	sd	s11,24(sp)
    80000632:	4981                	li	s3,0
    if(c != '%'){
    80000634:	02500b13          	li	s6,37
    switch(c){
    80000638:	07000b93          	li	s7,112
  consputc('x');
    8000063c:	4cc1                	li	s9,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000063e:	00009a97          	auipc	s5,0x9
    80000642:	372a8a93          	add	s5,s5,882 # 800099b0 <digits>
    switch(c){
    80000646:	07300c13          	li	s8,115
    8000064a:	06400d93          	li	s11,100
    8000064e:	a0b1                	j	8000069a <printf+0xba>
    acquire(&pr.lock);
    80000650:	00011517          	auipc	a0,0x11
    80000654:	72850513          	add	a0,a0,1832 # 80011d78 <pr>
    80000658:	00001097          	auipc	ra,0x1
    8000065c:	d5c080e7          	jalr	-676(ra) # 800013b4 <acquire>
    80000660:	b775                	j	8000060c <printf+0x2c>
    80000662:	f4a6                	sd	s1,104(sp)
    80000664:	f0ca                	sd	s2,96(sp)
    80000666:	ecce                	sd	s3,88(sp)
    80000668:	e4d6                	sd	s5,72(sp)
    8000066a:	e0da                	sd	s6,64(sp)
    8000066c:	fc5e                	sd	s7,56(sp)
    8000066e:	f862                	sd	s8,48(sp)
    80000670:	f466                	sd	s9,40(sp)
    80000672:	ec6e                	sd	s11,24(sp)
    panic("null fmt");
    80000674:	00009517          	auipc	a0,0x9
    80000678:	9dc50513          	add	a0,a0,-1572 # 80009050 <etext+0x50>
    8000067c:	00000097          	auipc	ra,0x0
    80000680:	f1a080e7          	jalr	-230(ra) # 80000596 <panic>
      consputc(c);
    80000684:	00000097          	auipc	ra,0x0
    80000688:	c10080e7          	jalr	-1008(ra) # 80000294 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000068c:	2985                	addw	s3,s3,1
    8000068e:	013a07b3          	add	a5,s4,s3
    80000692:	0007c503          	lbu	a0,0(a5)
    80000696:	10050563          	beqz	a0,800007a0 <printf+0x1c0>
    if(c != '%'){
    8000069a:	ff6515e3          	bne	a0,s6,80000684 <printf+0xa4>
    c = fmt[++i] & 0xff;
    8000069e:	2985                	addw	s3,s3,1
    800006a0:	013a07b3          	add	a5,s4,s3
    800006a4:	0007c783          	lbu	a5,0(a5)
    800006a8:	0007849b          	sext.w	s1,a5
    if(c == 0)
    800006ac:	10078b63          	beqz	a5,800007c2 <printf+0x1e2>
    switch(c){
    800006b0:	05778a63          	beq	a5,s7,80000704 <printf+0x124>
    800006b4:	02fbf663          	bgeu	s7,a5,800006e0 <printf+0x100>
    800006b8:	09878863          	beq	a5,s8,80000748 <printf+0x168>
    800006bc:	07800713          	li	a4,120
    800006c0:	0ce79563          	bne	a5,a4,8000078a <printf+0x1aa>
      printint(va_arg(ap, int), 16, 1);
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	add	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	4605                	li	a2,1
    800006d2:	85e6                	mv	a1,s9
    800006d4:	4388                	lw	a0,0(a5)
    800006d6:	00000097          	auipc	ra,0x0
    800006da:	e1c080e7          	jalr	-484(ra) # 800004f2 <printint>
      break;
    800006de:	b77d                	j	8000068c <printf+0xac>
    switch(c){
    800006e0:	09678f63          	beq	a5,s6,8000077e <printf+0x19e>
    800006e4:	0bb79363          	bne	a5,s11,8000078a <printf+0x1aa>
      printint(va_arg(ap, int), 10, 1);
    800006e8:	f8843783          	ld	a5,-120(s0)
    800006ec:	00878713          	add	a4,a5,8
    800006f0:	f8e43423          	sd	a4,-120(s0)
    800006f4:	4605                	li	a2,1
    800006f6:	45a9                	li	a1,10
    800006f8:	4388                	lw	a0,0(a5)
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	df8080e7          	jalr	-520(ra) # 800004f2 <printint>
      break;
    80000702:	b769                	j	8000068c <printf+0xac>
      printptr(va_arg(ap, uint64));
    80000704:	f8843783          	ld	a5,-120(s0)
    80000708:	00878713          	add	a4,a5,8
    8000070c:	f8e43423          	sd	a4,-120(s0)
    80000710:	0007b903          	ld	s2,0(a5)
  consputc('0');
    80000714:	03000513          	li	a0,48
    80000718:	00000097          	auipc	ra,0x0
    8000071c:	b7c080e7          	jalr	-1156(ra) # 80000294 <consputc>
  consputc('x');
    80000720:	07800513          	li	a0,120
    80000724:	00000097          	auipc	ra,0x0
    80000728:	b70080e7          	jalr	-1168(ra) # 80000294 <consputc>
    8000072c:	84e6                	mv	s1,s9
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000072e:	03c95793          	srl	a5,s2,0x3c
    80000732:	97d6                	add	a5,a5,s5
    80000734:	0007c503          	lbu	a0,0(a5)
    80000738:	00000097          	auipc	ra,0x0
    8000073c:	b5c080e7          	jalr	-1188(ra) # 80000294 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000740:	0912                	sll	s2,s2,0x4
    80000742:	34fd                	addw	s1,s1,-1
    80000744:	f4ed                	bnez	s1,8000072e <printf+0x14e>
    80000746:	b799                	j	8000068c <printf+0xac>
      if((s = va_arg(ap, char*)) == 0)
    80000748:	f8843783          	ld	a5,-120(s0)
    8000074c:	00878713          	add	a4,a5,8
    80000750:	f8e43423          	sd	a4,-120(s0)
    80000754:	6384                	ld	s1,0(a5)
    80000756:	cc89                	beqz	s1,80000770 <printf+0x190>
      for(; *s; s++)
    80000758:	0004c503          	lbu	a0,0(s1)
    8000075c:	d905                	beqz	a0,8000068c <printf+0xac>
        consputc(*s);
    8000075e:	00000097          	auipc	ra,0x0
    80000762:	b36080e7          	jalr	-1226(ra) # 80000294 <consputc>
      for(; *s; s++)
    80000766:	0485                	add	s1,s1,1
    80000768:	0004c503          	lbu	a0,0(s1)
    8000076c:	f96d                	bnez	a0,8000075e <printf+0x17e>
    8000076e:	bf39                	j	8000068c <printf+0xac>
        s = "(null)";
    80000770:	00009497          	auipc	s1,0x9
    80000774:	8d848493          	add	s1,s1,-1832 # 80009048 <etext+0x48>
      for(; *s; s++)
    80000778:	02800513          	li	a0,40
    8000077c:	b7cd                	j	8000075e <printf+0x17e>
      consputc('%');
    8000077e:	855a                	mv	a0,s6
    80000780:	00000097          	auipc	ra,0x0
    80000784:	b14080e7          	jalr	-1260(ra) # 80000294 <consputc>
      break;
    80000788:	b711                	j	8000068c <printf+0xac>
      consputc('%');
    8000078a:	855a                	mv	a0,s6
    8000078c:	00000097          	auipc	ra,0x0
    80000790:	b08080e7          	jalr	-1272(ra) # 80000294 <consputc>
      consputc(c);
    80000794:	8526                	mv	a0,s1
    80000796:	00000097          	auipc	ra,0x0
    8000079a:	afe080e7          	jalr	-1282(ra) # 80000294 <consputc>
      break;
    8000079e:	b5fd                	j	8000068c <printf+0xac>
    800007a0:	74a6                	ld	s1,104(sp)
    800007a2:	7906                	ld	s2,96(sp)
    800007a4:	69e6                	ld	s3,88(sp)
    800007a6:	6aa6                	ld	s5,72(sp)
    800007a8:	6b06                	ld	s6,64(sp)
    800007aa:	7be2                	ld	s7,56(sp)
    800007ac:	7c42                	ld	s8,48(sp)
    800007ae:	7ca2                	ld	s9,40(sp)
    800007b0:	6de2                	ld	s11,24(sp)
  if(locking)
    800007b2:	020d1263          	bnez	s10,800007d6 <printf+0x1f6>
}
    800007b6:	70e6                	ld	ra,120(sp)
    800007b8:	7446                	ld	s0,112(sp)
    800007ba:	6a46                	ld	s4,80(sp)
    800007bc:	7d02                	ld	s10,32(sp)
    800007be:	6129                	add	sp,sp,192
    800007c0:	8082                	ret
    800007c2:	74a6                	ld	s1,104(sp)
    800007c4:	7906                	ld	s2,96(sp)
    800007c6:	69e6                	ld	s3,88(sp)
    800007c8:	6aa6                	ld	s5,72(sp)
    800007ca:	6b06                	ld	s6,64(sp)
    800007cc:	7be2                	ld	s7,56(sp)
    800007ce:	7c42                	ld	s8,48(sp)
    800007d0:	7ca2                	ld	s9,40(sp)
    800007d2:	6de2                	ld	s11,24(sp)
    800007d4:	bff9                	j	800007b2 <printf+0x1d2>
    release(&pr.lock);
    800007d6:	00011517          	auipc	a0,0x11
    800007da:	5a250513          	add	a0,a0,1442 # 80011d78 <pr>
    800007de:	00001097          	auipc	ra,0x1
    800007e2:	c8a080e7          	jalr	-886(ra) # 80001468 <release>
}
    800007e6:	bfc1                	j	800007b6 <printf+0x1d6>

00000000800007e8 <printfinit>:
    ;
}

void
printfinit(void)
{
    800007e8:	1101                	add	sp,sp,-32
    800007ea:	ec06                	sd	ra,24(sp)
    800007ec:	e822                	sd	s0,16(sp)
    800007ee:	e426                	sd	s1,8(sp)
    800007f0:	1000                	add	s0,sp,32
  initlock(&pr.lock, "pr");
    800007f2:	00011497          	auipc	s1,0x11
    800007f6:	58648493          	add	s1,s1,1414 # 80011d78 <pr>
    800007fa:	00009597          	auipc	a1,0x9
    800007fe:	86658593          	add	a1,a1,-1946 # 80009060 <etext+0x60>
    80000802:	8526                	mv	a0,s1
    80000804:	00001097          	auipc	ra,0x1
    80000808:	b20080e7          	jalr	-1248(ra) # 80001324 <initlock>
  pr.locking = 1;
    8000080c:	4785                	li	a5,1
    8000080e:	cc9c                	sw	a5,24(s1)
}
    80000810:	60e2                	ld	ra,24(sp)
    80000812:	6442                	ld	s0,16(sp)
    80000814:	64a2                	ld	s1,8(sp)
    80000816:	6105                	add	sp,sp,32
    80000818:	8082                	ret

000000008000081a <uartinit>:

void uartstart();

void
uartinit(void)
{
    8000081a:	1141                	add	sp,sp,-16
    8000081c:	e406                	sd	ra,8(sp)
    8000081e:	e022                	sd	s0,0(sp)
    80000820:	0800                	add	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80000822:	100007b7          	lui	a5,0x10000
    80000826:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    8000082a:	10000737          	lui	a4,0x10000
    8000082e:	f8000693          	li	a3,-128
    80000832:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80000836:	468d                	li	a3,3
    80000838:	10000637          	lui	a2,0x10000
    8000083c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80000840:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80000844:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80000848:	10000737          	lui	a4,0x10000
    8000084c:	461d                	li	a2,7
    8000084e:	00c70123          	sb	a2,2(a4) # 10000002 <_entry-0x6ffffffe>

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80000852:	00d780a3          	sb	a3,1(a5)

  initlock(&uart_tx_lock, "uart");
    80000856:	00009597          	auipc	a1,0x9
    8000085a:	81258593          	add	a1,a1,-2030 # 80009068 <etext+0x68>
    8000085e:	00011517          	auipc	a0,0x11
    80000862:	53a50513          	add	a0,a0,1338 # 80011d98 <uart_tx_lock>
    80000866:	00001097          	auipc	ra,0x1
    8000086a:	abe080e7          	jalr	-1346(ra) # 80001324 <initlock>
}
    8000086e:	60a2                	ld	ra,8(sp)
    80000870:	6402                	ld	s0,0(sp)
    80000872:	0141                	add	sp,sp,16
    80000874:	8082                	ret

0000000080000876 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000876:	1101                	add	sp,sp,-32
    80000878:	ec06                	sd	ra,24(sp)
    8000087a:	e822                	sd	s0,16(sp)
    8000087c:	e426                	sd	s1,8(sp)
    8000087e:	1000                	add	s0,sp,32
    80000880:	84aa                	mv	s1,a0
  push_off();
    80000882:	00001097          	auipc	ra,0x1
    80000886:	ae6080e7          	jalr	-1306(ra) # 80001368 <push_off>

  if(panicked){
    8000088a:	00009797          	auipc	a5,0x9
    8000088e:	2a67a783          	lw	a5,678(a5) # 80009b30 <panicked>
    80000892:	eb85                	bnez	a5,800008c2 <uartputc_sync+0x4c>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80000894:	10000737          	lui	a4,0x10000
    80000898:	0715                	add	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    8000089a:	00074783          	lbu	a5,0(a4)
    8000089e:	0207f793          	and	a5,a5,32
    800008a2:	dfe5                	beqz	a5,8000089a <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800008a4:	0ff4f513          	zext.b	a0,s1
    800008a8:	100007b7          	lui	a5,0x10000
    800008ac:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  pop_off();
    800008b0:	00001097          	auipc	ra,0x1
    800008b4:	b58080e7          	jalr	-1192(ra) # 80001408 <pop_off>
}
    800008b8:	60e2                	ld	ra,24(sp)
    800008ba:	6442                	ld	s0,16(sp)
    800008bc:	64a2                	ld	s1,8(sp)
    800008be:	6105                	add	sp,sp,32
    800008c0:	8082                	ret
    for(;;)
    800008c2:	a001                	j	800008c2 <uartputc_sync+0x4c>

00000000800008c4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800008c4:	00009797          	auipc	a5,0x9
    800008c8:	2747b783          	ld	a5,628(a5) # 80009b38 <uart_tx_r>
    800008cc:	00009717          	auipc	a4,0x9
    800008d0:	27473703          	ld	a4,628(a4) # 80009b40 <uart_tx_w>
    800008d4:	06f70f63          	beq	a4,a5,80000952 <uartstart+0x8e>
{
    800008d8:	7139                	add	sp,sp,-64
    800008da:	fc06                	sd	ra,56(sp)
    800008dc:	f822                	sd	s0,48(sp)
    800008de:	f426                	sd	s1,40(sp)
    800008e0:	f04a                	sd	s2,32(sp)
    800008e2:	ec4e                	sd	s3,24(sp)
    800008e4:	e852                	sd	s4,16(sp)
    800008e6:	e456                	sd	s5,8(sp)
    800008e8:	e05a                	sd	s6,0(sp)
    800008ea:	0080                	add	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800008ec:	10000937          	lui	s2,0x10000
    800008f0:	0915                	add	s2,s2,5 # 10000005 <_entry-0x6ffffffb>
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800008f2:	00011a97          	auipc	s5,0x11
    800008f6:	4a6a8a93          	add	s5,s5,1190 # 80011d98 <uart_tx_lock>
    uart_tx_r += 1;
    800008fa:	00009497          	auipc	s1,0x9
    800008fe:	23e48493          	add	s1,s1,574 # 80009b38 <uart_tx_r>
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    
    WriteReg(THR, c);
    80000902:	10000a37          	lui	s4,0x10000
    if(uart_tx_w == uart_tx_r){
    80000906:	00009997          	auipc	s3,0x9
    8000090a:	23a98993          	add	s3,s3,570 # 80009b40 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000090e:	00094703          	lbu	a4,0(s2)
    80000912:	02077713          	and	a4,a4,32
    80000916:	c705                	beqz	a4,8000093e <uartstart+0x7a>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80000918:	01f7f713          	and	a4,a5,31
    8000091c:	9756                	add	a4,a4,s5
    8000091e:	01874b03          	lbu	s6,24(a4)
    uart_tx_r += 1;
    80000922:	0785                	add	a5,a5,1
    80000924:	e09c                	sd	a5,0(s1)
    wakeup(&uart_tx_r);
    80000926:	8526                	mv	a0,s1
    80000928:	00002097          	auipc	ra,0x2
    8000092c:	722080e7          	jalr	1826(ra) # 8000304a <wakeup>
    WriteReg(THR, c);
    80000930:	016a0023          	sb	s6,0(s4) # 10000000 <_entry-0x70000000>
    if(uart_tx_w == uart_tx_r){
    80000934:	609c                	ld	a5,0(s1)
    80000936:	0009b703          	ld	a4,0(s3)
    8000093a:	fcf71ae3          	bne	a4,a5,8000090e <uartstart+0x4a>
  }
}
    8000093e:	70e2                	ld	ra,56(sp)
    80000940:	7442                	ld	s0,48(sp)
    80000942:	74a2                	ld	s1,40(sp)
    80000944:	7902                	ld	s2,32(sp)
    80000946:	69e2                	ld	s3,24(sp)
    80000948:	6a42                	ld	s4,16(sp)
    8000094a:	6aa2                	ld	s5,8(sp)
    8000094c:	6b02                	ld	s6,0(sp)
    8000094e:	6121                	add	sp,sp,64
    80000950:	8082                	ret
    80000952:	8082                	ret

0000000080000954 <uartputc>:
{
    80000954:	7179                	add	sp,sp,-48
    80000956:	f406                	sd	ra,40(sp)
    80000958:	f022                	sd	s0,32(sp)
    8000095a:	ec26                	sd	s1,24(sp)
    8000095c:	e84a                	sd	s2,16(sp)
    8000095e:	e44e                	sd	s3,8(sp)
    80000960:	e052                	sd	s4,0(sp)
    80000962:	1800                	add	s0,sp,48
    80000964:	8a2a                	mv	s4,a0
  acquire(&uart_tx_lock);
    80000966:	00011517          	auipc	a0,0x11
    8000096a:	43250513          	add	a0,a0,1074 # 80011d98 <uart_tx_lock>
    8000096e:	00001097          	auipc	ra,0x1
    80000972:	a46080e7          	jalr	-1466(ra) # 800013b4 <acquire>
  if(panicked){
    80000976:	00009797          	auipc	a5,0x9
    8000097a:	1ba7a783          	lw	a5,442(a5) # 80009b30 <panicked>
    8000097e:	e7c9                	bnez	a5,80000a08 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80000980:	00009717          	auipc	a4,0x9
    80000984:	1c073703          	ld	a4,448(a4) # 80009b40 <uart_tx_w>
    80000988:	00009797          	auipc	a5,0x9
    8000098c:	1b07b783          	ld	a5,432(a5) # 80009b38 <uart_tx_r>
    80000990:	02078793          	add	a5,a5,32
    sleep(&uart_tx_r, &uart_tx_lock);
    80000994:	00011997          	auipc	s3,0x11
    80000998:	40498993          	add	s3,s3,1028 # 80011d98 <uart_tx_lock>
    8000099c:	00009497          	auipc	s1,0x9
    800009a0:	19c48493          	add	s1,s1,412 # 80009b38 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009a4:	00009917          	auipc	s2,0x9
    800009a8:	19c90913          	add	s2,s2,412 # 80009b40 <uart_tx_w>
    800009ac:	00e79f63          	bne	a5,a4,800009ca <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800009b0:	85ce                	mv	a1,s3
    800009b2:	8526                	mv	a0,s1
    800009b4:	00002097          	auipc	ra,0x2
    800009b8:	632080e7          	jalr	1586(ra) # 80002fe6 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800009bc:	00093703          	ld	a4,0(s2)
    800009c0:	609c                	ld	a5,0(s1)
    800009c2:	02078793          	add	a5,a5,32
    800009c6:	fee785e3          	beq	a5,a4,800009b0 <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800009ca:	00011497          	auipc	s1,0x11
    800009ce:	3ce48493          	add	s1,s1,974 # 80011d98 <uart_tx_lock>
    800009d2:	01f77793          	and	a5,a4,31
    800009d6:	97a6                	add	a5,a5,s1
    800009d8:	01478c23          	sb	s4,24(a5)
  uart_tx_w += 1;
    800009dc:	0705                	add	a4,a4,1
    800009de:	00009797          	auipc	a5,0x9
    800009e2:	16e7b123          	sd	a4,354(a5) # 80009b40 <uart_tx_w>
  uartstart();
    800009e6:	00000097          	auipc	ra,0x0
    800009ea:	ede080e7          	jalr	-290(ra) # 800008c4 <uartstart>
  release(&uart_tx_lock);
    800009ee:	8526                	mv	a0,s1
    800009f0:	00001097          	auipc	ra,0x1
    800009f4:	a78080e7          	jalr	-1416(ra) # 80001468 <release>
}
    800009f8:	70a2                	ld	ra,40(sp)
    800009fa:	7402                	ld	s0,32(sp)
    800009fc:	64e2                	ld	s1,24(sp)
    800009fe:	6942                	ld	s2,16(sp)
    80000a00:	69a2                	ld	s3,8(sp)
    80000a02:	6a02                	ld	s4,0(sp)
    80000a04:	6145                	add	sp,sp,48
    80000a06:	8082                	ret
    for(;;)
    80000a08:	a001                	j	80000a08 <uartputc+0xb4>

0000000080000a0a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80000a0a:	1141                	add	sp,sp,-16
    80000a0c:	e422                	sd	s0,8(sp)
    80000a0e:	0800                	add	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000a10:	100007b7          	lui	a5,0x10000
    80000a14:	0795                	add	a5,a5,5 # 10000005 <_entry-0x6ffffffb>
    80000a16:	0007c783          	lbu	a5,0(a5)
    80000a1a:	8b85                	and	a5,a5,1
    80000a1c:	cb81                	beqz	a5,80000a2c <uartgetc+0x22>
    // input data is ready.
    return ReadReg(RHR);
    80000a1e:	100007b7          	lui	a5,0x10000
    80000a22:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80000a26:	6422                	ld	s0,8(sp)
    80000a28:	0141                	add	sp,sp,16
    80000a2a:	8082                	ret
    return -1;
    80000a2c:	557d                	li	a0,-1
    80000a2e:	bfe5                	j	80000a26 <uartgetc+0x1c>

0000000080000a30 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80000a30:	1101                	add	sp,sp,-32
    80000a32:	ec06                	sd	ra,24(sp)
    80000a34:	e822                	sd	s0,16(sp)
    80000a36:	e426                	sd	s1,8(sp)
    80000a38:	1000                	add	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80000a3a:	54fd                	li	s1,-1
    80000a3c:	a029                	j	80000a46 <uartintr+0x16>
      break;
    consoleintr(c);
    80000a3e:	00000097          	auipc	ra,0x0
    80000a42:	898080e7          	jalr	-1896(ra) # 800002d6 <consoleintr>
    int c = uartgetc();
    80000a46:	00000097          	auipc	ra,0x0
    80000a4a:	fc4080e7          	jalr	-60(ra) # 80000a0a <uartgetc>
    if(c == -1)
    80000a4e:	fe9518e3          	bne	a0,s1,80000a3e <uartintr+0xe>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    80000a52:	00011497          	auipc	s1,0x11
    80000a56:	34648493          	add	s1,s1,838 # 80011d98 <uart_tx_lock>
    80000a5a:	8526                	mv	a0,s1
    80000a5c:	00001097          	auipc	ra,0x1
    80000a60:	958080e7          	jalr	-1704(ra) # 800013b4 <acquire>
  uartstart();
    80000a64:	00000097          	auipc	ra,0x0
    80000a68:	e60080e7          	jalr	-416(ra) # 800008c4 <uartstart>
  release(&uart_tx_lock);
    80000a6c:	8526                	mv	a0,s1
    80000a6e:	00001097          	auipc	ra,0x1
    80000a72:	9fa080e7          	jalr	-1542(ra) # 80001468 <release>
}
    80000a76:	60e2                	ld	ra,24(sp)
    80000a78:	6442                	ld	s0,16(sp)
    80000a7a:	64a2                	ld	s1,8(sp)
    80000a7c:	6105                	add	sp,sp,32
    80000a7e:	8082                	ret

0000000080000a80 <get_page_i>:
struct run {
  struct run *next;
};

int get_page_i(void* pa)
{
    80000a80:	1141                	add	sp,sp,-16
    80000a82:	e422                	sd	s0,8(sp)
    80000a84:	0800                	add	s0,sp,16
  return ((uint64)pa - page_start)/PGSIZE;
    80000a86:	00009797          	auipc	a5,0x9
    80000a8a:	0d27b783          	ld	a5,210(a5) # 80009b58 <page_start>
    80000a8e:	8d1d                	sub	a0,a0,a5
    80000a90:	8131                	srl	a0,a0,0xc
}
    80000a92:	2501                	sext.w	a0,a0
    80000a94:	6422                	ld	s0,8(sp)
    80000a96:	0141                	add	sp,sp,16
    80000a98:	8082                	ret

0000000080000a9a <get_hugepage_i>:


int get_hugepage_i(void* pa)
{
    80000a9a:	1141                	add	sp,sp,-16
    80000a9c:	e422                	sd	s0,8(sp)
    80000a9e:	0800                	add	s0,sp,16
  return ((uint64)pa - page_start)/HUGEPGSIZE;
    80000aa0:	00009797          	auipc	a5,0x9
    80000aa4:	0b87b783          	ld	a5,184(a5) # 80009b58 <page_start>
    80000aa8:	8d1d                	sub	a0,a0,a5
    80000aaa:	8155                	srl	a0,a0,0x15
}
    80000aac:	2501                	sext.w	a0,a0
    80000aae:	6422                	ld	s0,8(sp)
    80000ab0:	0141                	add	sp,sp,16
    80000ab2:	8082                	ret

0000000080000ab4 <pageindex_to_pa>:

void* pageindex_to_pa(int i)
{
    80000ab4:	1141                	add	sp,sp,-16
    80000ab6:	e422                	sd	s0,8(sp)
    80000ab8:	0800                	add	s0,sp,16
  
  return (void*)(page_start + PGSIZE*i);
    80000aba:	00c5151b          	sllw	a0,a0,0xc
}
    80000abe:	00009797          	auipc	a5,0x9
    80000ac2:	09a7b783          	ld	a5,154(a5) # 80009b58 <page_start>
    80000ac6:	953e                	add	a0,a0,a5
    80000ac8:	6422                	ld	s0,8(sp)
    80000aca:	0141                	add	sp,sp,16
    80000acc:	8082                	ret

0000000080000ace <debug_hugepagechecker>:

int freemem, used4k, used2m;

// for debugs
void debug_hugepagechecker()
{
    80000ace:	7139                	add	sp,sp,-64
    80000ad0:	fc06                	sd	ra,56(sp)
    80000ad2:	f822                	sd	s0,48(sp)
    80000ad4:	f426                	sd	s1,40(sp)
    80000ad6:	f04a                	sd	s2,32(sp)
    80000ad8:	ec4e                	sd	s3,24(sp)
    80000ada:	e852                	sd	s4,16(sp)
    80000adc:	e456                	sd	s5,8(sp)
    80000ade:	0080                	add	s0,sp,64
  acquire(&kmem.lock);
    80000ae0:	00011517          	auipc	a0,0x11
    80000ae4:	2f050513          	add	a0,a0,752 # 80011dd0 <kmem>
    80000ae8:	00001097          	auipc	ra,0x1
    80000aec:	8cc080e7          	jalr	-1844(ra) # 800013b4 <acquire>
  for(int i=0; i<63; i++)
    80000af0:	00011917          	auipc	s2,0x11
    80000af4:	2f890913          	add	s2,s2,760 # 80011de8 <kmem+0x18>
    80000af8:	4481                	li	s1,0
  {

    printf("kmem.hugepagelist[%d] = %d\n",i,kmem.hugepagelist[i]);
    80000afa:	00008a97          	auipc	s5,0x8
    80000afe:	576a8a93          	add	s5,s5,1398 # 80009070 <etext+0x70>
    if(kmem.hugepagelist[i] < -1 || kmem.hugepagelist[i] > 512)
    80000b02:	20100a13          	li	s4,513
  for(int i=0; i<63; i++)
    80000b06:	03f00993          	li	s3,63
    printf("kmem.hugepagelist[%d] = %d\n",i,kmem.hugepagelist[i]);
    80000b0a:	00091603          	lh	a2,0(s2)
    80000b0e:	85a6                	mv	a1,s1
    80000b10:	8556                	mv	a0,s5
    80000b12:	00000097          	auipc	ra,0x0
    80000b16:	ace080e7          	jalr	-1330(ra) # 800005e0 <printf>
    if(kmem.hugepagelist[i] < -1 || kmem.hugepagelist[i] > 512)
    80000b1a:	00091603          	lh	a2,0(s2)
    80000b1e:	0016079b          	addw	a5,a2,1
    80000b22:	17c2                	sll	a5,a5,0x30
    80000b24:	93c1                	srl	a5,a5,0x30
    80000b26:	02fa6763          	bltu	s4,a5,80000b54 <debug_hugepagechecker+0x86>
  for(int i=0; i<63; i++)
    80000b2a:	2485                	addw	s1,s1,1
    80000b2c:	0909                	add	s2,s2,2
    80000b2e:	fd349ee3          	bne	s1,s3,80000b0a <debug_hugepagechecker+0x3c>
    {
      printf("kmem.hugepagelist[%d] error = %d",i,kmem.hugepagelist[i]);
      panic("debug_hugepagechecker()");
    }
  }
  release(&kmem.lock);
    80000b32:	00011517          	auipc	a0,0x11
    80000b36:	29e50513          	add	a0,a0,670 # 80011dd0 <kmem>
    80000b3a:	00001097          	auipc	ra,0x1
    80000b3e:	92e080e7          	jalr	-1746(ra) # 80001468 <release>
}
    80000b42:	70e2                	ld	ra,56(sp)
    80000b44:	7442                	ld	s0,48(sp)
    80000b46:	74a2                	ld	s1,40(sp)
    80000b48:	7902                	ld	s2,32(sp)
    80000b4a:	69e2                	ld	s3,24(sp)
    80000b4c:	6a42                	ld	s4,16(sp)
    80000b4e:	6aa2                	ld	s5,8(sp)
    80000b50:	6121                	add	sp,sp,64
    80000b52:	8082                	ret
      printf("kmem.hugepagelist[%d] error = %d",i,kmem.hugepagelist[i]);
    80000b54:	85a6                	mv	a1,s1
    80000b56:	00008517          	auipc	a0,0x8
    80000b5a:	53a50513          	add	a0,a0,1338 # 80009090 <etext+0x90>
    80000b5e:	00000097          	auipc	ra,0x0
    80000b62:	a82080e7          	jalr	-1406(ra) # 800005e0 <printf>
      panic("debug_hugepagechecker()");
    80000b66:	00008517          	auipc	a0,0x8
    80000b6a:	55250513          	add	a0,a0,1362 # 800090b8 <etext+0xb8>
    80000b6e:	00000097          	auipc	ra,0x0
    80000b72:	a28080e7          	jalr	-1496(ra) # 80000596 <panic>

0000000080000b76 <debug_pagechecker>:

void debug_pagechecker(int huge_page_i)
{
    80000b76:	7139                	add	sp,sp,-64
    80000b78:	fc06                	sd	ra,56(sp)
    80000b7a:	f822                	sd	s0,48(sp)
    80000b7c:	f426                	sd	s1,40(sp)
    80000b7e:	f04a                	sd	s2,32(sp)
    80000b80:	ec4e                	sd	s3,24(sp)
    80000b82:	e852                	sd	s4,16(sp)
    80000b84:	e456                	sd	s5,8(sp)
    80000b86:	e05a                	sd	s6,0(sp)
    80000b88:	0080                	add	s0,sp,64
    80000b8a:	892a                	mv	s2,a0
  acquire(&kmem.lock);
    80000b8c:	00011517          	auipc	a0,0x11
    80000b90:	24450513          	add	a0,a0,580 # 80011dd0 <kmem>
    80000b94:	00001097          	auipc	ra,0x1
    80000b98:	820080e7          	jalr	-2016(ra) # 800013b4 <acquire>
  for(int i=0; i<512; i++)
    80000b9c:	00991793          	sll	a5,s2,0x9
    80000ba0:	00011497          	auipc	s1,0x11
    80000ba4:	2c648493          	add	s1,s1,710 # 80011e66 <kmem+0x96>
    80000ba8:	94be                	add	s1,s1,a5
    80000baa:	00011a17          	auipc	s4,0x11
    80000bae:	4bca0a13          	add	s4,s4,1212 # 80012066 <kmem+0x296>
    80000bb2:	9a3e                	add	s4,s4,a5
    80000bb4:	0099191b          	sllw	s2,s2,0x9
    80000bb8:	409909bb          	subw	s3,s2,s1
  {
    printf("kmem.pagelist[%d] = %d\n",huge_page_i*512 + i,kmem.pagelist[huge_page_i*512 + i]);
    80000bbc:	00008b17          	auipc	s6,0x8
    80000bc0:	514b0b13          	add	s6,s6,1300 # 800090d0 <etext+0xd0>
    if(kmem.pagelist[huge_page_i*512 + i] < 0 || kmem.pagelist[huge_page_i*512 + i] > 1)
    80000bc4:	4a85                	li	s5,1
    printf("kmem.pagelist[%d] = %d\n",huge_page_i*512 + i,kmem.pagelist[huge_page_i*512 + i]);
    80000bc6:	0134893b          	addw	s2,s1,s3
    80000bca:	0004c603          	lbu	a2,0(s1)
    80000bce:	85ca                	mv	a1,s2
    80000bd0:	855a                	mv	a0,s6
    80000bd2:	00000097          	auipc	ra,0x0
    80000bd6:	a0e080e7          	jalr	-1522(ra) # 800005e0 <printf>
    if(kmem.pagelist[huge_page_i*512 + i] < 0 || kmem.pagelist[huge_page_i*512 + i] > 1)
    80000bda:	0004c603          	lbu	a2,0(s1)
    80000bde:	02cae763          	bltu	s5,a2,80000c0c <debug_pagechecker+0x96>
  for(int i=0; i<512; i++)
    80000be2:	0485                	add	s1,s1,1
    80000be4:	ff4491e3          	bne	s1,s4,80000bc6 <debug_pagechecker+0x50>
    {
      printf("kmem.pagelist[%d] error = %d",huge_page_i*512 + i,kmem.pagelist[huge_page_i*512 + i]);
      panic("debug_pagechecker()");
    }
  }
  release(&kmem.lock);
    80000be8:	00011517          	auipc	a0,0x11
    80000bec:	1e850513          	add	a0,a0,488 # 80011dd0 <kmem>
    80000bf0:	00001097          	auipc	ra,0x1
    80000bf4:	878080e7          	jalr	-1928(ra) # 80001468 <release>
}
    80000bf8:	70e2                	ld	ra,56(sp)
    80000bfa:	7442                	ld	s0,48(sp)
    80000bfc:	74a2                	ld	s1,40(sp)
    80000bfe:	7902                	ld	s2,32(sp)
    80000c00:	69e2                	ld	s3,24(sp)
    80000c02:	6a42                	ld	s4,16(sp)
    80000c04:	6aa2                	ld	s5,8(sp)
    80000c06:	6b02                	ld	s6,0(sp)
    80000c08:	6121                	add	sp,sp,64
    80000c0a:	8082                	ret
      printf("kmem.pagelist[%d] error = %d",huge_page_i*512 + i,kmem.pagelist[huge_page_i*512 + i]);
    80000c0c:	85ca                	mv	a1,s2
    80000c0e:	00008517          	auipc	a0,0x8
    80000c12:	4da50513          	add	a0,a0,1242 # 800090e8 <etext+0xe8>
    80000c16:	00000097          	auipc	ra,0x0
    80000c1a:	9ca080e7          	jalr	-1590(ra) # 800005e0 <printf>
      panic("debug_pagechecker()");
    80000c1e:	00008517          	auipc	a0,0x8
    80000c22:	4ea50513          	add	a0,a0,1258 # 80009108 <etext+0x108>
    80000c26:	00000097          	auipc	ra,0x0
    80000c2a:	970080e7          	jalr	-1680(ra) # 80000596 <panic>

0000000080000c2e <incr_huge_pa_ref>:
  

}

void incr_huge_pa_ref(void *pa)
{
    80000c2e:	1101                	add	sp,sp,-32
    80000c30:	ec06                	sd	ra,24(sp)
    80000c32:	e822                	sd	s0,16(sp)
    80000c34:	e426                	sd	s1,8(sp)
    80000c36:	1000                	add	s0,sp,32
  if(((uint64)pa % HUGEPGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000c38:	02b51793          	sll	a5,a0,0x2b
    80000c3c:	e3a5                	bnez	a5,80000c9c <incr_huge_pa_ref+0x6e>
    80000c3e:	00034797          	auipc	a5,0x34
    80000c42:	89278793          	add	a5,a5,-1902 # 800344d0 <end>
    80000c46:	04f56b63          	bltu	a0,a5,80000c9c <incr_huge_pa_ref+0x6e>
    80000c4a:	47c5                	li	a5,17
    80000c4c:	07ee                	sll	a5,a5,0x1b
    80000c4e:	04f57763          	bgeu	a0,a5,80000c9c <incr_huge_pa_ref+0x6e>
  return ((uint64)pa - page_start)/HUGEPGSIZE;
    80000c52:	00009797          	auipc	a5,0x9
    80000c56:	f067b783          	ld	a5,-250(a5) # 80009b58 <page_start>
    80000c5a:	40f504b3          	sub	s1,a0,a5
    80000c5e:	80d5                	srl	s1,s1,0x15
    80000c60:	2481                	sext.w	s1,s1
    panic("incr_pa_ref");

  //int page_i = get_page_i(pa);
  int huge_page_i = get_hugepage_i(pa);

  acquire(&kmem.lock);
    80000c62:	00011517          	auipc	a0,0x11
    80000c66:	16e50513          	add	a0,a0,366 # 80011dd0 <kmem>
    80000c6a:	00000097          	auipc	ra,0x0
    80000c6e:	74a080e7          	jalr	1866(ra) # 800013b4 <acquire>
  if(kmem.huge_pa_referenced[huge_page_i] == 0)
  {
    //printf("incr_huge_pa_ref : was not referenced\n");
  }
  kmem.huge_pa_referenced[huge_page_i]++;
    80000c72:	00011517          	auipc	a0,0x11
    80000c76:	15e50513          	add	a0,a0,350 # 80011dd0 <kmem>
    80000c7a:	94aa                	add	s1,s1,a0
    80000c7c:	67c1                	lui	a5,0x10
    80000c7e:	97a6                	add	a5,a5,s1
    80000c80:	c967c703          	lbu	a4,-874(a5) # fc96 <_entry-0x7fff036a>
    80000c84:	2705                	addw	a4,a4,1
    80000c86:	c8e78b23          	sb	a4,-874(a5)
  release(&kmem.lock);
    80000c8a:	00000097          	auipc	ra,0x0
    80000c8e:	7de080e7          	jalr	2014(ra) # 80001468 <release>
}
    80000c92:	60e2                	ld	ra,24(sp)
    80000c94:	6442                	ld	s0,16(sp)
    80000c96:	64a2                	ld	s1,8(sp)
    80000c98:	6105                	add	sp,sp,32
    80000c9a:	8082                	ret
    panic("incr_pa_ref");
    80000c9c:	00008517          	auipc	a0,0x8
    80000ca0:	48450513          	add	a0,a0,1156 # 80009120 <etext+0x120>
    80000ca4:	00000097          	auipc	ra,0x0
    80000ca8:	8f2080e7          	jalr	-1806(ra) # 80000596 <panic>

0000000080000cac <incr_pa_ref>:

void incr_pa_ref(void *pa)
{
    80000cac:	1101                	add	sp,sp,-32
    80000cae:	ec06                	sd	ra,24(sp)
    80000cb0:	e822                	sd	s0,16(sp)
    80000cb2:	e426                	sd	s1,8(sp)
    80000cb4:	1000                	add	s0,sp,32
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000cb6:	03451793          	sll	a5,a0,0x34
    80000cba:	e3a5                	bnez	a5,80000d1a <incr_pa_ref+0x6e>
    80000cbc:	00034797          	auipc	a5,0x34
    80000cc0:	81478793          	add	a5,a5,-2028 # 800344d0 <end>
    80000cc4:	04f56b63          	bltu	a0,a5,80000d1a <incr_pa_ref+0x6e>
    80000cc8:	47c5                	li	a5,17
    80000cca:	07ee                	sll	a5,a5,0x1b
    80000ccc:	04f57763          	bgeu	a0,a5,80000d1a <incr_pa_ref+0x6e>
  return ((uint64)pa - page_start)/PGSIZE;
    80000cd0:	00009797          	auipc	a5,0x9
    80000cd4:	e887b783          	ld	a5,-376(a5) # 80009b58 <page_start>
    80000cd8:	40f504b3          	sub	s1,a0,a5
    80000cdc:	80b1                	srl	s1,s1,0xc
    80000cde:	2481                	sext.w	s1,s1
    panic("incr_pa_ref");

  int page_i = get_page_i(pa);
  //int huge_page_i = get_hugepage_i(pa);

  acquire(&kmem.lock);
    80000ce0:	00011517          	auipc	a0,0x11
    80000ce4:	0f050513          	add	a0,a0,240 # 80011dd0 <kmem>
    80000ce8:	00000097          	auipc	ra,0x0
    80000cec:	6cc080e7          	jalr	1740(ra) # 800013b4 <acquire>
  if(kmem.pa_referenced[page_i] == 0)
  {
    //printf("incr_pa_ref : was not referenced\n");
  }
  kmem.pa_referenced[page_i]++;
    80000cf0:	00011517          	auipc	a0,0x11
    80000cf4:	0e050513          	add	a0,a0,224 # 80011dd0 <kmem>
    80000cf8:	94aa                	add	s1,s1,a0
    80000cfa:	67a1                	lui	a5,0x8
    80000cfc:	97a6                	add	a5,a5,s1
    80000cfe:	e967c703          	lbu	a4,-362(a5) # 7e96 <_entry-0x7fff816a>
    80000d02:	2705                	addw	a4,a4,1
    80000d04:	e8e78b23          	sb	a4,-362(a5)
  release(&kmem.lock);
    80000d08:	00000097          	auipc	ra,0x0
    80000d0c:	760080e7          	jalr	1888(ra) # 80001468 <release>
}
    80000d10:	60e2                	ld	ra,24(sp)
    80000d12:	6442                	ld	s0,16(sp)
    80000d14:	64a2                	ld	s1,8(sp)
    80000d16:	6105                	add	sp,sp,32
    80000d18:	8082                	ret
    panic("incr_pa_ref");
    80000d1a:	00008517          	auipc	a0,0x8
    80000d1e:	40650513          	add	a0,a0,1030 # 80009120 <etext+0x120>
    80000d22:	00000097          	auipc	ra,0x0
    80000d26:	874080e7          	jalr	-1932(ra) # 80000596 <panic>

0000000080000d2a <reduce_pa_ref>:

void reduce_pa_ref(void *pa)
{
    80000d2a:	1101                	add	sp,sp,-32
    80000d2c:	ec06                	sd	ra,24(sp)
    80000d2e:	e822                	sd	s0,16(sp)
    80000d30:	e426                	sd	s1,8(sp)
    80000d32:	1000                	add	s0,sp,32
  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000d34:	03451793          	sll	a5,a0,0x34
    80000d38:	eba5                	bnez	a5,80000da8 <reduce_pa_ref+0x7e>
    80000d3a:	00033797          	auipc	a5,0x33
    80000d3e:	79678793          	add	a5,a5,1942 # 800344d0 <end>
    80000d42:	06f56363          	bltu	a0,a5,80000da8 <reduce_pa_ref+0x7e>
    80000d46:	47c5                	li	a5,17
    80000d48:	07ee                	sll	a5,a5,0x1b
    80000d4a:	04f57f63          	bgeu	a0,a5,80000da8 <reduce_pa_ref+0x7e>
  return ((uint64)pa - page_start)/PGSIZE;
    80000d4e:	00009797          	auipc	a5,0x9
    80000d52:	e0a7b783          	ld	a5,-502(a5) # 80009b58 <page_start>
    80000d56:	40f504b3          	sub	s1,a0,a5
    80000d5a:	80b1                	srl	s1,s1,0xc
    80000d5c:	2481                	sext.w	s1,s1
    panic("reduce_pa_ref");

  int page_i = get_page_i(pa);
  //int huge_page_i = get_hugepage_i(pa);

  acquire(&kmem.lock);
    80000d5e:	00011517          	auipc	a0,0x11
    80000d62:	07250513          	add	a0,a0,114 # 80011dd0 <kmem>
    80000d66:	00000097          	auipc	ra,0x0
    80000d6a:	64e080e7          	jalr	1614(ra) # 800013b4 <acquire>
  if(kmem.pa_referenced[page_i] == 0)
    80000d6e:	00011717          	auipc	a4,0x11
    80000d72:	06270713          	add	a4,a4,98 # 80011dd0 <kmem>
    80000d76:	9726                	add	a4,a4,s1
    80000d78:	67a1                	lui	a5,0x8
    80000d7a:	97ba                	add	a5,a5,a4
    80000d7c:	e967c783          	lbu	a5,-362(a5) # 7e96 <_entry-0x7fff816a>
    80000d80:	cf85                	beqz	a5,80000db8 <reduce_pa_ref+0x8e>
  {
    panic("reduce ref should not have been called");
  }
  kmem.pa_referenced[page_i]--;
    80000d82:	00011517          	auipc	a0,0x11
    80000d86:	04e50513          	add	a0,a0,78 # 80011dd0 <kmem>
    80000d8a:	94aa                	add	s1,s1,a0
    80000d8c:	6721                	lui	a4,0x8
    80000d8e:	9726                	add	a4,a4,s1
    80000d90:	37fd                	addw	a5,a5,-1
    80000d92:	e8f70b23          	sb	a5,-362(a4) # 7e96 <_entry-0x7fff816a>
  release(&kmem.lock);
    80000d96:	00000097          	auipc	ra,0x0
    80000d9a:	6d2080e7          	jalr	1746(ra) # 80001468 <release>

}
    80000d9e:	60e2                	ld	ra,24(sp)
    80000da0:	6442                	ld	s0,16(sp)
    80000da2:	64a2                	ld	s1,8(sp)
    80000da4:	6105                	add	sp,sp,32
    80000da6:	8082                	ret
    panic("reduce_pa_ref");
    80000da8:	00008517          	auipc	a0,0x8
    80000dac:	38850513          	add	a0,a0,904 # 80009130 <etext+0x130>
    80000db0:	fffff097          	auipc	ra,0xfffff
    80000db4:	7e6080e7          	jalr	2022(ra) # 80000596 <panic>
    panic("reduce ref should not have been called");
    80000db8:	00008517          	auipc	a0,0x8
    80000dbc:	38850513          	add	a0,a0,904 # 80009140 <etext+0x140>
    80000dc0:	fffff097          	auipc	ra,0xfffff
    80000dc4:	7d6080e7          	jalr	2006(ra) # 80000596 <panic>

0000000080000dc8 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000dc8:	7179                	add	sp,sp,-48
    80000dca:	f406                	sd	ra,40(sp)
    80000dcc:	f022                	sd	s0,32(sp)
    80000dce:	ec26                	sd	s1,24(sp)
    80000dd0:	e84a                	sd	s2,16(sp)
    80000dd2:	e44e                	sd	s3,8(sp)
    80000dd4:	1800                	add	s0,sp,48
  //struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000dd6:	03451793          	sll	a5,a0,0x34
    80000dda:	e7d9                	bnez	a5,80000e68 <kfree+0xa0>
    80000ddc:	84aa                	mv	s1,a0
    80000dde:	00033797          	auipc	a5,0x33
    80000de2:	6f278793          	add	a5,a5,1778 # 800344d0 <end>
    80000de6:	08f56163          	bltu	a0,a5,80000e68 <kfree+0xa0>
    80000dea:	47c5                	li	a5,17
    80000dec:	07ee                	sll	a5,a5,0x1b
    80000dee:	06f57d63          	bgeu	a0,a5,80000e68 <kfree+0xa0>
  return ((uint64)pa - page_start)/PGSIZE;
    80000df2:	00009917          	auipc	s2,0x9
    80000df6:	d6693903          	ld	s2,-666(s2) # 80009b58 <page_start>
    80000dfa:	41250933          	sub	s2,a0,s2
    80000dfe:	00c95993          	srl	s3,s2,0xc
    80000e02:	2981                	sext.w	s3,s3

  

  // r = (struct run*)pa;

  acquire(&kmem.lock);
    80000e04:	00011517          	auipc	a0,0x11
    80000e08:	fcc50513          	add	a0,a0,-52 # 80011dd0 <kmem>
    80000e0c:	00000097          	auipc	ra,0x0
    80000e10:	5a8080e7          	jalr	1448(ra) # 800013b4 <acquire>
  // r->next = kmem.freelist;
  //kmem.freelist = r;
  // 0 is alloc'd(false) 1 is free-allocatable(true)

  // 2) and 3)
  if(kmem.pagelist[page_i])
    80000e14:	00011797          	auipc	a5,0x11
    80000e18:	fbc78793          	add	a5,a5,-68 # 80011dd0 <kmem>
    80000e1c:	97ce                	add	a5,a5,s3
    80000e1e:	0967c783          	lbu	a5,150(a5)
    80000e22:	ebb9                	bnez	a5,80000e78 <kfree+0xb0>
    //printf("%d %d",page_i, huge_page_i);
    panic("double kfree");
  }

  // check PA's referenced numbers
  if(kmem.pa_referenced[page_i] >0)
    80000e24:	00011717          	auipc	a4,0x11
    80000e28:	fac70713          	add	a4,a4,-84 # 80011dd0 <kmem>
    80000e2c:	974e                	add	a4,a4,s3
    80000e2e:	67a1                	lui	a5,0x8
    80000e30:	97ba                	add	a5,a5,a4
    80000e32:	e967c783          	lbu	a5,-362(a5) # 7e96 <_entry-0x7fff816a>
    80000e36:	c3ad                	beqz	a5,80000e98 <kfree+0xd0>
    kmem.pa_referenced[page_i]--;
    80000e38:	37fd                	addw	a5,a5,-1
    80000e3a:	0ff7f793          	zext.b	a5,a5
    80000e3e:	86ba                	mv	a3,a4
    80000e40:	6721                	lui	a4,0x8
    80000e42:	9736                	add	a4,a4,a3
    80000e44:	e8f70b23          	sb	a5,-362(a4) # 7e96 <_entry-0x7fff816a>

  // only free when referenced num == 0
  if(kmem.pa_referenced[page_i] == 0)
    80000e48:	cba1                	beqz	a5,80000e98 <kfree+0xd0>
    kmem.hugepagelist[huge_page_i]--;
    freemem++;
    used4k--;
  }

  release(&kmem.lock);
    80000e4a:	00011517          	auipc	a0,0x11
    80000e4e:	f8650513          	add	a0,a0,-122 # 80011dd0 <kmem>
    80000e52:	00000097          	auipc	ra,0x0
    80000e56:	616080e7          	jalr	1558(ra) # 80001468 <release>
}
    80000e5a:	70a2                	ld	ra,40(sp)
    80000e5c:	7402                	ld	s0,32(sp)
    80000e5e:	64e2                	ld	s1,24(sp)
    80000e60:	6942                	ld	s2,16(sp)
    80000e62:	69a2                	ld	s3,8(sp)
    80000e64:	6145                	add	sp,sp,48
    80000e66:	8082                	ret
    panic("kfree");
    80000e68:	00008517          	auipc	a0,0x8
    80000e6c:	30050513          	add	a0,a0,768 # 80009168 <etext+0x168>
    80000e70:	fffff097          	auipc	ra,0xfffff
    80000e74:	726080e7          	jalr	1830(ra) # 80000596 <panic>
    release(&kmem.lock);
    80000e78:	00011517          	auipc	a0,0x11
    80000e7c:	f5850513          	add	a0,a0,-168 # 80011dd0 <kmem>
    80000e80:	00000097          	auipc	ra,0x0
    80000e84:	5e8080e7          	jalr	1512(ra) # 80001468 <release>
    panic("double kfree");
    80000e88:	00008517          	auipc	a0,0x8
    80000e8c:	2e850513          	add	a0,a0,744 # 80009170 <etext+0x170>
    80000e90:	fffff097          	auipc	ra,0xfffff
    80000e94:	706080e7          	jalr	1798(ra) # 80000596 <panic>
  return ((uint64)pa - page_start)/HUGEPGSIZE;
    80000e98:	01595913          	srl	s2,s2,0x15
    80000e9c:	2901                	sext.w	s2,s2
    memset(pa, 0, PGSIZE);
    80000e9e:	6605                	lui	a2,0x1
    80000ea0:	4581                	li	a1,0
    80000ea2:	8526                	mv	a0,s1
    80000ea4:	00000097          	auipc	ra,0x0
    80000ea8:	60c080e7          	jalr	1548(ra) # 800014b0 <memset>
    kmem.pagelist[page_i] = 1;
    80000eac:	00011797          	auipc	a5,0x11
    80000eb0:	f2478793          	add	a5,a5,-220 # 80011dd0 <kmem>
    80000eb4:	99be                	add	s3,s3,a5
    80000eb6:	4705                	li	a4,1
    80000eb8:	08e98b23          	sb	a4,150(s3)
    kmem.hugepagelist[huge_page_i]--;
    80000ebc:	0921                	add	s2,s2,8
    80000ebe:	0906                	sll	s2,s2,0x1
    80000ec0:	97ca                	add	a5,a5,s2
    80000ec2:	0087d703          	lhu	a4,8(a5)
    80000ec6:	377d                	addw	a4,a4,-1
    80000ec8:	00e79423          	sh	a4,8(a5)
    freemem++;
    80000ecc:	00009717          	auipc	a4,0x9
    80000ed0:	c8470713          	add	a4,a4,-892 # 80009b50 <freemem>
    80000ed4:	431c                	lw	a5,0(a4)
    80000ed6:	2785                	addw	a5,a5,1
    80000ed8:	c31c                	sw	a5,0(a4)
    used4k--;
    80000eda:	00009717          	auipc	a4,0x9
    80000ede:	c7270713          	add	a4,a4,-910 # 80009b4c <used4k>
    80000ee2:	431c                	lw	a5,0(a4)
    80000ee4:	37fd                	addw	a5,a5,-1
    80000ee6:	c31c                	sw	a5,0(a4)
    80000ee8:	b78d                	j	80000e4a <kfree+0x82>

0000000080000eea <freerange>:
{
    80000eea:	7179                	add	sp,sp,-48
    80000eec:	f406                	sd	ra,40(sp)
    80000eee:	f022                	sd	s0,32(sp)
    80000ef0:	ec26                	sd	s1,24(sp)
    80000ef2:	e84a                	sd	s2,16(sp)
    80000ef4:	1800                	add	s0,sp,48
    80000ef6:	84aa                	mv	s1,a0
    80000ef8:	892e                	mv	s2,a1
  acquire(&kmem.lock);
    80000efa:	00011517          	auipc	a0,0x11
    80000efe:	ed650513          	add	a0,a0,-298 # 80011dd0 <kmem>
    80000f02:	00000097          	auipc	ra,0x0
    80000f06:	4b2080e7          	jalr	1202(ra) # 800013b4 <acquire>
  for(int i=0; i<63; i++)
    80000f0a:	00011797          	auipc	a5,0x11
    80000f0e:	ede78793          	add	a5,a5,-290 # 80011de8 <kmem+0x18>
    80000f12:	00011697          	auipc	a3,0x11
    80000f16:	f5468693          	add	a3,a3,-172 # 80011e66 <kmem+0x96>
    kmem.hugepagelist[i] = 512;
    80000f1a:	20000713          	li	a4,512
    80000f1e:	00e79023          	sh	a4,0(a5)
  for(int i=0; i<63; i++)
    80000f22:	0789                	add	a5,a5,2
    80000f24:	fed79de3          	bne	a5,a3,80000f1e <freerange+0x34>
  release(&kmem.lock);
    80000f28:	00011517          	auipc	a0,0x11
    80000f2c:	ea850513          	add	a0,a0,-344 # 80011dd0 <kmem>
    80000f30:	00000097          	auipc	ra,0x0
    80000f34:	538080e7          	jalr	1336(ra) # 80001468 <release>
  p = (char*)HUGEPGROUNDUP((uint64)pa_start);
    80000f38:	002007b7          	lui	a5,0x200
    80000f3c:	17fd                	add	a5,a5,-1 # 1fffff <_entry-0x7fe00001>
    80000f3e:	94be                	add	s1,s1,a5
    80000f40:	ffe007b7          	lui	a5,0xffe00
    80000f44:	8cfd                	and	s1,s1,a5
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000f46:	6785                	lui	a5,0x1
    80000f48:	94be                	add	s1,s1,a5
    80000f4a:	02996163          	bltu	s2,s1,80000f6c <freerange+0x82>
    80000f4e:	e44e                	sd	s3,8(sp)
    80000f50:	e052                	sd	s4,0(sp)
    kfree(p);
    80000f52:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000f54:	6985                	lui	s3,0x1
    kfree(p);
    80000f56:	01448533          	add	a0,s1,s4
    80000f5a:	00000097          	auipc	ra,0x0
    80000f5e:	e6e080e7          	jalr	-402(ra) # 80000dc8 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000f62:	94ce                	add	s1,s1,s3
    80000f64:	fe9979e3          	bgeu	s2,s1,80000f56 <freerange+0x6c>
    80000f68:	69a2                	ld	s3,8(sp)
    80000f6a:	6a02                	ld	s4,0(sp)
}
    80000f6c:	70a2                	ld	ra,40(sp)
    80000f6e:	7402                	ld	s0,32(sp)
    80000f70:	64e2                	ld	s1,24(sp)
    80000f72:	6942                	ld	s2,16(sp)
    80000f74:	6145                	add	sp,sp,48
    80000f76:	8082                	ret

0000000080000f78 <kinit>:
{
    80000f78:	1141                	add	sp,sp,-16
    80000f7a:	e406                	sd	ra,8(sp)
    80000f7c:	e022                	sd	s0,0(sp)
    80000f7e:	0800                	add	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000f80:	00008597          	auipc	a1,0x8
    80000f84:	20058593          	add	a1,a1,512 # 80009180 <etext+0x180>
    80000f88:	00011517          	auipc	a0,0x11
    80000f8c:	e4850513          	add	a0,a0,-440 # 80011dd0 <kmem>
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	394080e7          	jalr	916(ra) # 80001324 <initlock>
  acquire(&kmem.lock);
    80000f98:	00011517          	auipc	a0,0x11
    80000f9c:	e3850513          	add	a0,a0,-456 # 80011dd0 <kmem>
    80000fa0:	00000097          	auipc	ra,0x0
    80000fa4:	414080e7          	jalr	1044(ra) # 800013b4 <acquire>
  page_start = HUGEPGROUNDUP((uint64)end);
    80000fa8:	00233597          	auipc	a1,0x233
    80000fac:	52758593          	add	a1,a1,1319 # 802344cf <end+0x1fffff>
    80000fb0:	ffe007b7          	lui	a5,0xffe00
    80000fb4:	8dfd                	and	a1,a1,a5
    80000fb6:	00009797          	auipc	a5,0x9
    80000fba:	bab7b123          	sd	a1,-1118(a5) # 80009b58 <page_start>
  printf("page_start : %p\n", page_start);
    80000fbe:	00008517          	auipc	a0,0x8
    80000fc2:	1ca50513          	add	a0,a0,458 # 80009188 <etext+0x188>
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	61a080e7          	jalr	1562(ra) # 800005e0 <printf>
  printf("page end : %p\n", (void*)PHYSTOP);
    80000fce:	45c5                	li	a1,17
    80000fd0:	05ee                	sll	a1,a1,0x1b
    80000fd2:	00008517          	auipc	a0,0x8
    80000fd6:	1ce50513          	add	a0,a0,462 # 800091a0 <etext+0x1a0>
    80000fda:	fffff097          	auipc	ra,0xfffff
    80000fde:	606080e7          	jalr	1542(ra) # 800005e0 <printf>
  release(&kmem.lock);
    80000fe2:	00011517          	auipc	a0,0x11
    80000fe6:	dee50513          	add	a0,a0,-530 # 80011dd0 <kmem>
    80000fea:	00000097          	auipc	ra,0x0
    80000fee:	47e080e7          	jalr	1150(ra) # 80001468 <release>
  freerange(end, (void*)PHYSTOP);
    80000ff2:	45c5                	li	a1,17
    80000ff4:	05ee                	sll	a1,a1,0x1b
    80000ff6:	00033517          	auipc	a0,0x33
    80000ffa:	4da50513          	add	a0,a0,1242 # 800344d0 <end>
    80000ffe:	00000097          	auipc	ra,0x0
    80001002:	eec080e7          	jalr	-276(ra) # 80000eea <freerange>
  used4k = 0;
    80001006:	00009797          	auipc	a5,0x9
    8000100a:	b407a323          	sw	zero,-1210(a5) # 80009b4c <used4k>
  freemem += 512;
    8000100e:	00009717          	auipc	a4,0x9
    80001012:	b4270713          	add	a4,a4,-1214 # 80009b50 <freemem>
    80001016:	431c                	lw	a5,0(a4)
    80001018:	2007879b          	addw	a5,a5,512
    8000101c:	c31c                	sw	a5,0(a4)
}
    8000101e:	60a2                	ld	ra,8(sp)
    80001020:	6402                	ld	s0,0(sp)
    80001022:	0141                	add	sp,sp,16
    80001024:	8082                	ret

0000000080001026 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80001026:	7179                	add	sp,sp,-48
    80001028:	f406                	sd	ra,40(sp)
    8000102a:	f022                	sd	s0,32(sp)
    8000102c:	ec26                	sd	s1,24(sp)
    8000102e:	1800                	add	s0,sp,48
  // debug_pagechecker();
  // debug_hugepagechecker();

  acquire(&kmem.lock);
    80001030:	00011517          	auipc	a0,0x11
    80001034:	da050513          	add	a0,a0,-608 # 80011dd0 <kmem>
    80001038:	00000097          	auipc	ra,0x0
    8000103c:	37c080e7          	jalr	892(ra) # 800013b4 <acquire>
  

  int huge_page_i = -1;

  // 1) search for [1,511] huge pages
  for(int i=0; i<63;i++)
    80001040:	00011697          	auipc	a3,0x11
    80001044:	da868693          	add	a3,a3,-600 # 80011de8 <kmem+0x18>
  acquire(&kmem.lock);
    80001048:	8736                	mv	a4,a3
  for(int i=0; i<63;i++)
    8000104a:	4481                	li	s1,0
  {
    if(0 < kmem.hugepagelist[i] && kmem.hugepagelist[i] < 512)
    8000104c:	1fe00613          	li	a2,510
  for(int i=0; i<63;i++)
    80001050:	03f00593          	li	a1,63
    if(0 < kmem.hugepagelist[i] && kmem.hugepagelist[i] < 512)
    80001054:	00075783          	lhu	a5,0(a4)
    80001058:	37fd                	addw	a5,a5,-1
    8000105a:	17c2                	sll	a5,a5,0x30
    8000105c:	93c1                	srl	a5,a5,0x30
    8000105e:	02f67a63          	bgeu	a2,a5,80001092 <kalloc+0x6c>
  for(int i=0; i<63;i++)
    80001062:	2485                	addw	s1,s1,1
    80001064:	0709                	add	a4,a4,2
    80001066:	feb497e3          	bne	s1,a1,80001054 <kalloc+0x2e>

  // 2) if '1)' not found, search for empty huge pages 

  if(!flag_1)
  {
    for(int i=0; i<63;i++)
    8000106a:	4481                	li	s1,0
    8000106c:	03f00713          	li	a4,63
    {
      if(kmem.hugepagelist[i] == 0)
    80001070:	00069783          	lh	a5,0(a3)
    80001074:	cf99                	beqz	a5,80001092 <kalloc+0x6c>
    for(int i=0; i<63;i++)
    80001076:	2485                	addw	s1,s1,1
    80001078:	0689                	add	a3,a3,2
    8000107a:	fee49be3          	bne	s1,a4,80001070 <kalloc+0x4a>
  // if none were found, return 0
  if(flag_1 == 0 && flag_2 == 0 )
  {
    //printf("all filled: freemem=%d, used4k=%d, used2m=%d\n", freemem, used4k, used2m);

    release(&kmem.lock);
    8000107e:	00011517          	auipc	a0,0x11
    80001082:	d5250513          	add	a0,a0,-686 # 80011dd0 <kmem>
    80001086:	00000097          	auipc	ra,0x0
    8000108a:	3e2080e7          	jalr	994(ra) # 80001468 <release>
    return 0;  
    8000108e:	4501                	li	a0,0
    80001090:	a8bd                	j	8000110e <kalloc+0xe8>
    80001092:	e84a                	sd	s2,16(sp)
    80001094:	e44e                	sd	s3,8(sp)
  }


  // linear search each huge page section
  int page_i = huge_page_i*512;
    80001096:	0094991b          	sllw	s2,s1,0x9
  int page_end = page_i + 512;

  for(; page_i < page_end; page_i++)
    8000109a:	00949793          	sll	a5,s1,0x9
    8000109e:	00011717          	auipc	a4,0x11
    800010a2:	dc870713          	add	a4,a4,-568 # 80011e66 <kmem+0x96>
    800010a6:	97ba                	add	a5,a5,a4
    800010a8:	0014869b          	addw	a3,s1,1
    800010ac:	0096969b          	sllw	a3,a3,0x9
  {
    // 0 is alloc'd(false) 1 is free-allocatable(true)
    if(kmem.pagelist[page_i])
    800010b0:	0007c703          	lbu	a4,0(a5)
    800010b4:	e711                	bnez	a4,800010c0 <kalloc+0x9a>
  for(; page_i < page_end; page_i++)
    800010b6:	2905                	addw	s2,s2,1
    800010b8:	0785                	add	a5,a5,1
    800010ba:	fed91be3          	bne	s2,a3,800010b0 <kalloc+0x8a>
    800010be:	8936                	mv	s2,a3
  return (void*)(page_start + PGSIZE*i);
    800010c0:	00c9199b          	sllw	s3,s2,0xc
    800010c4:	00009517          	auipc	a0,0x9
    800010c8:	a9453503          	ld	a0,-1388(a0) # 80009b58 <page_start>

  // Fill with junk to catch dangling refs.

  uint64* pa = pageindex_to_pa(page_i);

  kmem.pa_referenced[page_i]++;
    800010cc:	00011797          	auipc	a5,0x11
    800010d0:	d0478793          	add	a5,a5,-764 # 80011dd0 <kmem>
    800010d4:	97ca                	add	a5,a5,s2
    800010d6:	6721                	lui	a4,0x8
    800010d8:	973e                	add	a4,a4,a5
    800010da:	e9674783          	lbu	a5,-362(a4) # 7e96 <_entry-0x7fff816a>
    800010de:	2785                	addw	a5,a5,1
    800010e0:	0ff7f793          	zext.b	a5,a5
    800010e4:	e8f70b23          	sb	a5,-362(a4)

  // first time being referenced
  if(kmem.pa_referenced[page_i] == 1)
    800010e8:	4705                	li	a4,1
    800010ea:	02e78763          	beq	a5,a4,80001118 <kalloc+0xf2>
    freemem--;
    used4k++;

  }
  
  release(&kmem.lock);
    800010ee:	00011517          	auipc	a0,0x11
    800010f2:	ce250513          	add	a0,a0,-798 # 80011dd0 <kmem>
    800010f6:	00000097          	auipc	ra,0x0
    800010fa:	372080e7          	jalr	882(ra) # 80001468 <release>
  return (void*)(page_start + PGSIZE*i);
    800010fe:	00009797          	auipc	a5,0x9
    80001102:	a5a7b783          	ld	a5,-1446(a5) # 80009b58 <page_start>
    80001106:	00f98533          	add	a0,s3,a5
  return pageindex_to_pa(page_i);
    8000110a:	6942                	ld	s2,16(sp)
    8000110c:	69a2                	ld	s3,8(sp)
}
    8000110e:	70a2                	ld	ra,40(sp)
    80001110:	7402                	ld	s0,32(sp)
    80001112:	64e2                	ld	s1,24(sp)
    80001114:	6145                	add	sp,sp,48
    80001116:	8082                	ret
    memset(pa, 0, PGSIZE);
    80001118:	6605                	lui	a2,0x1
    8000111a:	4581                	li	a1,0
    8000111c:	954e                	add	a0,a0,s3
    8000111e:	00000097          	auipc	ra,0x0
    80001122:	392080e7          	jalr	914(ra) # 800014b0 <memset>
    kmem.pagelist[page_i] = 0;
    80001126:	00011717          	auipc	a4,0x11
    8000112a:	caa70713          	add	a4,a4,-854 # 80011dd0 <kmem>
    8000112e:	993a                	add	s2,s2,a4
    80001130:	08090b23          	sb	zero,150(s2)
    kmem.hugepagelist[huge_page_i]++;
    80001134:	00848793          	add	a5,s1,8
    80001138:	0786                	sll	a5,a5,0x1
    8000113a:	97ba                	add	a5,a5,a4
    8000113c:	0087d703          	lhu	a4,8(a5)
    80001140:	2705                	addw	a4,a4,1
    80001142:	00e79423          	sh	a4,8(a5)
    freemem--;
    80001146:	00009717          	auipc	a4,0x9
    8000114a:	a0a70713          	add	a4,a4,-1526 # 80009b50 <freemem>
    8000114e:	431c                	lw	a5,0(a4)
    80001150:	37fd                	addw	a5,a5,-1
    80001152:	c31c                	sw	a5,0(a4)
    used4k++;
    80001154:	00009717          	auipc	a4,0x9
    80001158:	9f870713          	add	a4,a4,-1544 # 80009b4c <used4k>
    8000115c:	431c                	lw	a5,0(a4)
    8000115e:	2785                	addw	a5,a5,1
    80001160:	c31c                	sw	a5,0(a4)
    80001162:	b771                	j	800010ee <kalloc+0xc8>

0000000080001164 <kalloc_huge>:

void *
kalloc_huge(void)
{
    80001164:	1101                	add	sp,sp,-32
    80001166:	ec06                	sd	ra,24(sp)
    80001168:	e822                	sd	s0,16(sp)
    8000116a:	e426                	sd	s1,8(sp)
    8000116c:	1000                	add	s0,sp,32
  // PA4: FILL HERE
  uint64 pa = 0;
  acquire(&kmem.lock);
    8000116e:	00011517          	auipc	a0,0x11
    80001172:	c6250513          	add	a0,a0,-926 # 80011dd0 <kmem>
    80001176:	00000097          	auipc	ra,0x0
    8000117a:	23e080e7          	jalr	574(ra) # 800013b4 <acquire>


  for(int i=0; i< 63; i++)
    8000117e:	00011717          	auipc	a4,0x11
    80001182:	c6a70713          	add	a4,a4,-918 # 80011de8 <kmem+0x18>
    80001186:	4781                	li	a5,0
    80001188:	03f00613          	li	a2,63
  {
    if (kmem.hugepagelist[i] == 0)
    8000118c:	00071683          	lh	a3,0(a4)
    80001190:	c699                	beqz	a3,8000119e <kalloc_huge+0x3a>
  for(int i=0; i< 63; i++)
    80001192:	2785                	addw	a5,a5,1
    80001194:	0709                	add	a4,a4,2
    80001196:	fec79be3          	bne	a5,a2,8000118c <kalloc_huge+0x28>
  uint64 pa = 0;
    8000119a:	4481                	li	s1,0
    8000119c:	a09d                	j	80001202 <kalloc_huge+0x9e>
      {
        kmem.hugepagelist[i] = -1;
    8000119e:	00011697          	auipc	a3,0x11
    800011a2:	c3268693          	add	a3,a3,-974 # 80011dd0 <kmem>
    800011a6:	00878713          	add	a4,a5,8
    800011aa:	0706                	sll	a4,a4,0x1
    800011ac:	9736                	add	a4,a4,a3
    800011ae:	567d                	li	a2,-1
    800011b0:	00c71423          	sh	a2,8(a4)

        kmem.huge_pa_referenced[i]++;
    800011b4:	96be                	add	a3,a3,a5
    800011b6:	6741                	lui	a4,0x10
    800011b8:	9736                	add	a4,a4,a3
    800011ba:	c9674683          	lbu	a3,-874(a4) # fc96 <_entry-0x7fff036a>
    800011be:	2685                	addw	a3,a3,1
    800011c0:	c8d70b23          	sb	a3,-874(a4)
        
        pa = page_start + HUGEPGSIZE*i;
    800011c4:	0157979b          	sllw	a5,a5,0x15
    800011c8:	00009717          	auipc	a4,0x9
    800011cc:	99073703          	ld	a4,-1648(a4) # 80009b58 <page_start>
    800011d0:	00e784b3          	add	s1,a5,a4
        //fill with junk
        memset((char*)pa, 0, HUGEPGSIZE);
    800011d4:	00200637          	lui	a2,0x200
    800011d8:	4581                	li	a1,0
    800011da:	8526                	mv	a0,s1
    800011dc:	00000097          	auipc	ra,0x0
    800011e0:	2d4080e7          	jalr	724(ra) # 800014b0 <memset>

        // 할거 : 숫자업데이트
        freemem -= 512;
    800011e4:	00009717          	auipc	a4,0x9
    800011e8:	96c70713          	add	a4,a4,-1684 # 80009b50 <freemem>
    800011ec:	431c                	lw	a5,0(a4)
    800011ee:	e007879b          	addw	a5,a5,-512
    800011f2:	c31c                	sw	a5,0(a4)
        used2m++;
    800011f4:	00009717          	auipc	a4,0x9
    800011f8:	95470713          	add	a4,a4,-1708 # 80009b48 <used2m>
    800011fc:	431c                	lw	a5,0(a4)
    800011fe:	2785                	addw	a5,a5,1
    80001200:	c31c                	sw	a5,0(a4)
        break;
      }
  }


  release(&kmem.lock);
    80001202:	00011517          	auipc	a0,0x11
    80001206:	bce50513          	add	a0,a0,-1074 # 80011dd0 <kmem>
    8000120a:	00000097          	auipc	ra,0x0
    8000120e:	25e080e7          	jalr	606(ra) # 80001468 <release>

  //debug_hugepagechecker();
  return (void*)pa;
}
    80001212:	8526                	mv	a0,s1
    80001214:	60e2                	ld	ra,24(sp)
    80001216:	6442                	ld	s0,16(sp)
    80001218:	64a2                	ld	s1,8(sp)
    8000121a:	6105                	add	sp,sp,32
    8000121c:	8082                	ret

000000008000121e <kfree_huge>:

void 
kfree_huge(void *pa)
{
    8000121e:	1101                	add	sp,sp,-32
    80001220:	ec06                	sd	ra,24(sp)
    80001222:	e822                	sd	s0,16(sp)
    80001224:	e426                	sd	s1,8(sp)
    80001226:	e04a                	sd	s2,0(sp)
    80001228:	1000                	add	s0,sp,32
  if(((uint64)pa % HUGEPGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000122a:	02b51793          	sll	a5,a0,0x2b
    8000122e:	ebd1                	bnez	a5,800012c2 <kfree_huge+0xa4>
    80001230:	892a                	mv	s2,a0
    80001232:	00033797          	auipc	a5,0x33
    80001236:	29e78793          	add	a5,a5,670 # 800344d0 <end>
    8000123a:	08f56463          	bltu	a0,a5,800012c2 <kfree_huge+0xa4>
    8000123e:	47c5                	li	a5,17
    80001240:	07ee                	sll	a5,a5,0x1b
    80001242:	08f57063          	bgeu	a0,a5,800012c2 <kfree_huge+0xa4>
    panic("kfree_huge");
  acquire(&kmem.lock);
    80001246:	00011517          	auipc	a0,0x11
    8000124a:	b8a50513          	add	a0,a0,-1142 # 80011dd0 <kmem>
    8000124e:	00000097          	auipc	ra,0x0
    80001252:	166080e7          	jalr	358(ra) # 800013b4 <acquire>
  return ((uint64)pa - page_start)/HUGEPGSIZE;
    80001256:	00009497          	auipc	s1,0x9
    8000125a:	9024b483          	ld	s1,-1790(s1) # 80009b58 <page_start>
    8000125e:	409904b3          	sub	s1,s2,s1
    80001262:	80d5                	srl	s1,s1,0x15
    80001264:	2481                	sext.w	s1,s1

  int hugepage_i = get_hugepage_i(pa);
  
  // check double kfree
  if(kmem.hugepagelist[hugepage_i] != -1)
    80001266:	00848713          	add	a4,s1,8
    8000126a:	0706                	sll	a4,a4,0x1
    8000126c:	00011797          	auipc	a5,0x11
    80001270:	b6478793          	add	a5,a5,-1180 # 80011dd0 <kmem>
    80001274:	97ba                	add	a5,a5,a4
    80001276:	00879703          	lh	a4,8(a5)
    8000127a:	57fd                	li	a5,-1
    8000127c:	04f71b63          	bne	a4,a5,800012d2 <kfree_huge+0xb4>
  {
    // printf("trying to free unallocated huge page! [%d] : %d \n", hugepage_i, kmem.hugepagelist[hugepage_i]);
    panic("kfree_huge");
  }

  if(kmem.huge_pa_referenced[hugepage_i] >0)
    80001280:	00011717          	auipc	a4,0x11
    80001284:	b5070713          	add	a4,a4,-1200 # 80011dd0 <kmem>
    80001288:	9726                	add	a4,a4,s1
    8000128a:	67c1                	lui	a5,0x10
    8000128c:	97ba                	add	a5,a5,a4
    8000128e:	c967c783          	lbu	a5,-874(a5) # fc96 <_entry-0x7fff036a>
    80001292:	cba1                	beqz	a5,800012e2 <kfree_huge+0xc4>
    kmem.huge_pa_referenced[hugepage_i]--;
    80001294:	37fd                	addw	a5,a5,-1
    80001296:	0ff7f793          	zext.b	a5,a5
    8000129a:	86ba                	mv	a3,a4
    8000129c:	6741                	lui	a4,0x10
    8000129e:	9736                	add	a4,a4,a3
    800012a0:	c8f70b23          	sb	a5,-874(a4) # fc96 <_entry-0x7fff036a>

  if(kmem.huge_pa_referenced[hugepage_i] == 0)
    800012a4:	cf9d                	beqz	a5,800012e2 <kfree_huge+0xc4>
    // free
    kmem.hugepagelist[hugepage_i] = 0;
    freemem += 512;
    used2m--;
  }
  release(&kmem.lock);
    800012a6:	00011517          	auipc	a0,0x11
    800012aa:	b2a50513          	add	a0,a0,-1238 # 80011dd0 <kmem>
    800012ae:	00000097          	auipc	ra,0x0
    800012b2:	1ba080e7          	jalr	442(ra) # 80001468 <release>
}
    800012b6:	60e2                	ld	ra,24(sp)
    800012b8:	6442                	ld	s0,16(sp)
    800012ba:	64a2                	ld	s1,8(sp)
    800012bc:	6902                	ld	s2,0(sp)
    800012be:	6105                	add	sp,sp,32
    800012c0:	8082                	ret
    panic("kfree_huge");
    800012c2:	00008517          	auipc	a0,0x8
    800012c6:	eee50513          	add	a0,a0,-274 # 800091b0 <etext+0x1b0>
    800012ca:	fffff097          	auipc	ra,0xfffff
    800012ce:	2cc080e7          	jalr	716(ra) # 80000596 <panic>
    panic("kfree_huge");
    800012d2:	00008517          	auipc	a0,0x8
    800012d6:	ede50513          	add	a0,a0,-290 # 800091b0 <etext+0x1b0>
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	2bc080e7          	jalr	700(ra) # 80000596 <panic>
    memset(pa, 0, HUGEPGSIZE);
    800012e2:	00200637          	lui	a2,0x200
    800012e6:	4581                	li	a1,0
    800012e8:	854a                	mv	a0,s2
    800012ea:	00000097          	auipc	ra,0x0
    800012ee:	1c6080e7          	jalr	454(ra) # 800014b0 <memset>
    kmem.hugepagelist[hugepage_i] = 0;
    800012f2:	04a1                	add	s1,s1,8
    800012f4:	0486                	sll	s1,s1,0x1
    800012f6:	00011797          	auipc	a5,0x11
    800012fa:	ada78793          	add	a5,a5,-1318 # 80011dd0 <kmem>
    800012fe:	97a6                	add	a5,a5,s1
    80001300:	00079423          	sh	zero,8(a5)
    freemem += 512;
    80001304:	00009717          	auipc	a4,0x9
    80001308:	84c70713          	add	a4,a4,-1972 # 80009b50 <freemem>
    8000130c:	431c                	lw	a5,0(a4)
    8000130e:	2007879b          	addw	a5,a5,512
    80001312:	c31c                	sw	a5,0(a4)
    used2m--;
    80001314:	00009717          	auipc	a4,0x9
    80001318:	83470713          	add	a4,a4,-1996 # 80009b48 <used2m>
    8000131c:	431c                	lw	a5,0(a4)
    8000131e:	37fd                	addw	a5,a5,-1
    80001320:	c31c                	sw	a5,0(a4)
    80001322:	b751                	j	800012a6 <kfree_huge+0x88>

0000000080001324 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80001324:	1141                	add	sp,sp,-16
    80001326:	e422                	sd	s0,8(sp)
    80001328:	0800                	add	s0,sp,16
  lk->name = name;
    8000132a:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    8000132c:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80001330:	00053823          	sd	zero,16(a0)
}
    80001334:	6422                	ld	s0,8(sp)
    80001336:	0141                	add	sp,sp,16
    80001338:	8082                	ret

000000008000133a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    8000133a:	411c                	lw	a5,0(a0)
    8000133c:	e399                	bnez	a5,80001342 <holding+0x8>
    8000133e:	4501                	li	a0,0
  return r;
}
    80001340:	8082                	ret
{
    80001342:	1101                	add	sp,sp,-32
    80001344:	ec06                	sd	ra,24(sp)
    80001346:	e822                	sd	s0,16(sp)
    80001348:	e426                	sd	s1,8(sp)
    8000134a:	1000                	add	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000134c:	6904                	ld	s1,16(a0)
    8000134e:	00001097          	auipc	ra,0x1
    80001352:	01a080e7          	jalr	26(ra) # 80002368 <mycpu>
    80001356:	40a48533          	sub	a0,s1,a0
    8000135a:	00153513          	seqz	a0,a0
}
    8000135e:	60e2                	ld	ra,24(sp)
    80001360:	6442                	ld	s0,16(sp)
    80001362:	64a2                	ld	s1,8(sp)
    80001364:	6105                	add	sp,sp,32
    80001366:	8082                	ret

0000000080001368 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80001368:	1101                	add	sp,sp,-32
    8000136a:	ec06                	sd	ra,24(sp)
    8000136c:	e822                	sd	s0,16(sp)
    8000136e:	e426                	sd	s1,8(sp)
    80001370:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001372:	100024f3          	csrr	s1,sstatus
    80001376:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000137a:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000137c:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80001380:	00001097          	auipc	ra,0x1
    80001384:	fe8080e7          	jalr	-24(ra) # 80002368 <mycpu>
    80001388:	5d3c                	lw	a5,120(a0)
    8000138a:	cf89                	beqz	a5,800013a4 <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    8000138c:	00001097          	auipc	ra,0x1
    80001390:	fdc080e7          	jalr	-36(ra) # 80002368 <mycpu>
    80001394:	5d3c                	lw	a5,120(a0)
    80001396:	2785                	addw	a5,a5,1
    80001398:	dd3c                	sw	a5,120(a0)
}
    8000139a:	60e2                	ld	ra,24(sp)
    8000139c:	6442                	ld	s0,16(sp)
    8000139e:	64a2                	ld	s1,8(sp)
    800013a0:	6105                	add	sp,sp,32
    800013a2:	8082                	ret
    mycpu()->intena = old;
    800013a4:	00001097          	auipc	ra,0x1
    800013a8:	fc4080e7          	jalr	-60(ra) # 80002368 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800013ac:	8085                	srl	s1,s1,0x1
    800013ae:	8885                	and	s1,s1,1
    800013b0:	dd64                	sw	s1,124(a0)
    800013b2:	bfe9                	j	8000138c <push_off+0x24>

00000000800013b4 <acquire>:
{
    800013b4:	1101                	add	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	add	s0,sp,32
    800013be:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800013c0:	00000097          	auipc	ra,0x0
    800013c4:	fa8080e7          	jalr	-88(ra) # 80001368 <push_off>
  if(holding(lk))
    800013c8:	8526                	mv	a0,s1
    800013ca:	00000097          	auipc	ra,0x0
    800013ce:	f70080e7          	jalr	-144(ra) # 8000133a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800013d2:	4705                	li	a4,1
  if(holding(lk))
    800013d4:	e115                	bnez	a0,800013f8 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800013d6:	87ba                	mv	a5,a4
    800013d8:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800013dc:	2781                	sext.w	a5,a5
    800013de:	ffe5                	bnez	a5,800013d6 <acquire+0x22>
  __sync_synchronize();
    800013e0:	0ff0000f          	fence
  lk->cpu = mycpu();
    800013e4:	00001097          	auipc	ra,0x1
    800013e8:	f84080e7          	jalr	-124(ra) # 80002368 <mycpu>
    800013ec:	e888                	sd	a0,16(s1)
}
    800013ee:	60e2                	ld	ra,24(sp)
    800013f0:	6442                	ld	s0,16(sp)
    800013f2:	64a2                	ld	s1,8(sp)
    800013f4:	6105                	add	sp,sp,32
    800013f6:	8082                	ret
    panic("acquire");
    800013f8:	00008517          	auipc	a0,0x8
    800013fc:	dc850513          	add	a0,a0,-568 # 800091c0 <etext+0x1c0>
    80001400:	fffff097          	auipc	ra,0xfffff
    80001404:	196080e7          	jalr	406(ra) # 80000596 <panic>

0000000080001408 <pop_off>:

void
pop_off(void)
{
    80001408:	1141                	add	sp,sp,-16
    8000140a:	e406                	sd	ra,8(sp)
    8000140c:	e022                	sd	s0,0(sp)
    8000140e:	0800                	add	s0,sp,16
  struct cpu *c = mycpu();
    80001410:	00001097          	auipc	ra,0x1
    80001414:	f58080e7          	jalr	-168(ra) # 80002368 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001418:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000141c:	8b89                	and	a5,a5,2
  if(intr_get())
    8000141e:	e78d                	bnez	a5,80001448 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80001420:	5d3c                	lw	a5,120(a0)
    80001422:	02f05b63          	blez	a5,80001458 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80001426:	37fd                	addw	a5,a5,-1
    80001428:	0007871b          	sext.w	a4,a5
    8000142c:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000142e:	eb09                	bnez	a4,80001440 <pop_off+0x38>
    80001430:	5d7c                	lw	a5,124(a0)
    80001432:	c799                	beqz	a5,80001440 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001434:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001438:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000143c:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80001440:	60a2                	ld	ra,8(sp)
    80001442:	6402                	ld	s0,0(sp)
    80001444:	0141                	add	sp,sp,16
    80001446:	8082                	ret
    panic("pop_off - interruptible");
    80001448:	00008517          	auipc	a0,0x8
    8000144c:	d8050513          	add	a0,a0,-640 # 800091c8 <etext+0x1c8>
    80001450:	fffff097          	auipc	ra,0xfffff
    80001454:	146080e7          	jalr	326(ra) # 80000596 <panic>
    panic("pop_off");
    80001458:	00008517          	auipc	a0,0x8
    8000145c:	d8850513          	add	a0,a0,-632 # 800091e0 <etext+0x1e0>
    80001460:	fffff097          	auipc	ra,0xfffff
    80001464:	136080e7          	jalr	310(ra) # 80000596 <panic>

0000000080001468 <release>:
{
    80001468:	1101                	add	sp,sp,-32
    8000146a:	ec06                	sd	ra,24(sp)
    8000146c:	e822                	sd	s0,16(sp)
    8000146e:	e426                	sd	s1,8(sp)
    80001470:	1000                	add	s0,sp,32
    80001472:	84aa                	mv	s1,a0
  if(!holding(lk))
    80001474:	00000097          	auipc	ra,0x0
    80001478:	ec6080e7          	jalr	-314(ra) # 8000133a <holding>
    8000147c:	c115                	beqz	a0,800014a0 <release+0x38>
  lk->cpu = 0;
    8000147e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80001482:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80001486:	0f50000f          	fence	iorw,ow
    8000148a:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    8000148e:	00000097          	auipc	ra,0x0
    80001492:	f7a080e7          	jalr	-134(ra) # 80001408 <pop_off>
}
    80001496:	60e2                	ld	ra,24(sp)
    80001498:	6442                	ld	s0,16(sp)
    8000149a:	64a2                	ld	s1,8(sp)
    8000149c:	6105                	add	sp,sp,32
    8000149e:	8082                	ret
    panic("release");
    800014a0:	00008517          	auipc	a0,0x8
    800014a4:	d4850513          	add	a0,a0,-696 # 800091e8 <etext+0x1e8>
    800014a8:	fffff097          	auipc	ra,0xfffff
    800014ac:	0ee080e7          	jalr	238(ra) # 80000596 <panic>

00000000800014b0 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800014b0:	1141                	add	sp,sp,-16
    800014b2:	e422                	sd	s0,8(sp)
    800014b4:	0800                	add	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800014b6:	ca19                	beqz	a2,800014cc <memset+0x1c>
    800014b8:	87aa                	mv	a5,a0
    800014ba:	1602                	sll	a2,a2,0x20
    800014bc:	9201                	srl	a2,a2,0x20
    800014be:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800014c2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800014c6:	0785                	add	a5,a5,1
    800014c8:	fee79de3          	bne	a5,a4,800014c2 <memset+0x12>
  }
  return dst;
}
    800014cc:	6422                	ld	s0,8(sp)
    800014ce:	0141                	add	sp,sp,16
    800014d0:	8082                	ret

00000000800014d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800014d2:	1141                	add	sp,sp,-16
    800014d4:	e422                	sd	s0,8(sp)
    800014d6:	0800                	add	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800014d8:	ca05                	beqz	a2,80001508 <memcmp+0x36>
    800014da:	fff6069b          	addw	a3,a2,-1 # 1fffff <_entry-0x7fe00001>
    800014de:	1682                	sll	a3,a3,0x20
    800014e0:	9281                	srl	a3,a3,0x20
    800014e2:	0685                	add	a3,a3,1
    800014e4:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800014e6:	00054783          	lbu	a5,0(a0)
    800014ea:	0005c703          	lbu	a4,0(a1)
    800014ee:	00e79863          	bne	a5,a4,800014fe <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800014f2:	0505                	add	a0,a0,1
    800014f4:	0585                	add	a1,a1,1
  while(n-- > 0){
    800014f6:	fed518e3          	bne	a0,a3,800014e6 <memcmp+0x14>
  }

  return 0;
    800014fa:	4501                	li	a0,0
    800014fc:	a019                	j	80001502 <memcmp+0x30>
      return *s1 - *s2;
    800014fe:	40e7853b          	subw	a0,a5,a4
}
    80001502:	6422                	ld	s0,8(sp)
    80001504:	0141                	add	sp,sp,16
    80001506:	8082                	ret
  return 0;
    80001508:	4501                	li	a0,0
    8000150a:	bfe5                	j	80001502 <memcmp+0x30>

000000008000150c <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000150c:	1141                	add	sp,sp,-16
    8000150e:	e422                	sd	s0,8(sp)
    80001510:	0800                	add	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80001512:	c205                	beqz	a2,80001532 <memmove+0x26>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80001514:	02a5e263          	bltu	a1,a0,80001538 <memmove+0x2c>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80001518:	1602                	sll	a2,a2,0x20
    8000151a:	9201                	srl	a2,a2,0x20
    8000151c:	00c587b3          	add	a5,a1,a2
{
    80001520:	872a                	mv	a4,a0
      *d++ = *s++;
    80001522:	0585                	add	a1,a1,1
    80001524:	0705                	add	a4,a4,1
    80001526:	fff5c683          	lbu	a3,-1(a1)
    8000152a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000152e:	feb79ae3          	bne	a5,a1,80001522 <memmove+0x16>

  return dst;
}
    80001532:	6422                	ld	s0,8(sp)
    80001534:	0141                	add	sp,sp,16
    80001536:	8082                	ret
  if(s < d && s + n > d){
    80001538:	02061693          	sll	a3,a2,0x20
    8000153c:	9281                	srl	a3,a3,0x20
    8000153e:	00d58733          	add	a4,a1,a3
    80001542:	fce57be3          	bgeu	a0,a4,80001518 <memmove+0xc>
    d += n;
    80001546:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80001548:	fff6079b          	addw	a5,a2,-1
    8000154c:	1782                	sll	a5,a5,0x20
    8000154e:	9381                	srl	a5,a5,0x20
    80001550:	fff7c793          	not	a5,a5
    80001554:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80001556:	177d                	add	a4,a4,-1
    80001558:	16fd                	add	a3,a3,-1
    8000155a:	00074603          	lbu	a2,0(a4)
    8000155e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80001562:	fef71ae3          	bne	a4,a5,80001556 <memmove+0x4a>
    80001566:	b7f1                	j	80001532 <memmove+0x26>

0000000080001568 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80001568:	1141                	add	sp,sp,-16
    8000156a:	e406                	sd	ra,8(sp)
    8000156c:	e022                	sd	s0,0(sp)
    8000156e:	0800                	add	s0,sp,16
  return memmove(dst, src, n);
    80001570:	00000097          	auipc	ra,0x0
    80001574:	f9c080e7          	jalr	-100(ra) # 8000150c <memmove>
}
    80001578:	60a2                	ld	ra,8(sp)
    8000157a:	6402                	ld	s0,0(sp)
    8000157c:	0141                	add	sp,sp,16
    8000157e:	8082                	ret

0000000080001580 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80001580:	1141                	add	sp,sp,-16
    80001582:	e422                	sd	s0,8(sp)
    80001584:	0800                	add	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80001586:	ce11                	beqz	a2,800015a2 <strncmp+0x22>
    80001588:	00054783          	lbu	a5,0(a0)
    8000158c:	cf89                	beqz	a5,800015a6 <strncmp+0x26>
    8000158e:	0005c703          	lbu	a4,0(a1)
    80001592:	00f71a63          	bne	a4,a5,800015a6 <strncmp+0x26>
    n--, p++, q++;
    80001596:	367d                	addw	a2,a2,-1
    80001598:	0505                	add	a0,a0,1
    8000159a:	0585                	add	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000159c:	f675                	bnez	a2,80001588 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000159e:	4501                	li	a0,0
    800015a0:	a801                	j	800015b0 <strncmp+0x30>
    800015a2:	4501                	li	a0,0
    800015a4:	a031                	j	800015b0 <strncmp+0x30>
  return (uchar)*p - (uchar)*q;
    800015a6:	00054503          	lbu	a0,0(a0)
    800015aa:	0005c783          	lbu	a5,0(a1)
    800015ae:	9d1d                	subw	a0,a0,a5
}
    800015b0:	6422                	ld	s0,8(sp)
    800015b2:	0141                	add	sp,sp,16
    800015b4:	8082                	ret

00000000800015b6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800015b6:	1141                	add	sp,sp,-16
    800015b8:	e422                	sd	s0,8(sp)
    800015ba:	0800                	add	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800015bc:	87aa                	mv	a5,a0
    800015be:	86b2                	mv	a3,a2
    800015c0:	367d                	addw	a2,a2,-1
    800015c2:	02d05563          	blez	a3,800015ec <strncpy+0x36>
    800015c6:	0785                	add	a5,a5,1
    800015c8:	0005c703          	lbu	a4,0(a1)
    800015cc:	fee78fa3          	sb	a4,-1(a5)
    800015d0:	0585                	add	a1,a1,1
    800015d2:	f775                	bnez	a4,800015be <strncpy+0x8>
    ;
  while(n-- > 0)
    800015d4:	873e                	mv	a4,a5
    800015d6:	9fb5                	addw	a5,a5,a3
    800015d8:	37fd                	addw	a5,a5,-1
    800015da:	00c05963          	blez	a2,800015ec <strncpy+0x36>
    *s++ = 0;
    800015de:	0705                	add	a4,a4,1
    800015e0:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800015e4:	40e786bb          	subw	a3,a5,a4
    800015e8:	fed04be3          	bgtz	a3,800015de <strncpy+0x28>
  return os;
}
    800015ec:	6422                	ld	s0,8(sp)
    800015ee:	0141                	add	sp,sp,16
    800015f0:	8082                	ret

00000000800015f2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800015f2:	1141                	add	sp,sp,-16
    800015f4:	e422                	sd	s0,8(sp)
    800015f6:	0800                	add	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800015f8:	02c05363          	blez	a2,8000161e <safestrcpy+0x2c>
    800015fc:	fff6069b          	addw	a3,a2,-1
    80001600:	1682                	sll	a3,a3,0x20
    80001602:	9281                	srl	a3,a3,0x20
    80001604:	96ae                	add	a3,a3,a1
    80001606:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80001608:	00d58963          	beq	a1,a3,8000161a <safestrcpy+0x28>
    8000160c:	0585                	add	a1,a1,1
    8000160e:	0785                	add	a5,a5,1
    80001610:	fff5c703          	lbu	a4,-1(a1)
    80001614:	fee78fa3          	sb	a4,-1(a5)
    80001618:	fb65                	bnez	a4,80001608 <safestrcpy+0x16>
    ;
  *s = 0;
    8000161a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000161e:	6422                	ld	s0,8(sp)
    80001620:	0141                	add	sp,sp,16
    80001622:	8082                	ret

0000000080001624 <strlen>:

int
strlen(const char *s)
{
    80001624:	1141                	add	sp,sp,-16
    80001626:	e422                	sd	s0,8(sp)
    80001628:	0800                	add	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000162a:	00054783          	lbu	a5,0(a0)
    8000162e:	cf91                	beqz	a5,8000164a <strlen+0x26>
    80001630:	0505                	add	a0,a0,1
    80001632:	87aa                	mv	a5,a0
    80001634:	86be                	mv	a3,a5
    80001636:	0785                	add	a5,a5,1
    80001638:	fff7c703          	lbu	a4,-1(a5)
    8000163c:	ff65                	bnez	a4,80001634 <strlen+0x10>
    8000163e:	40a6853b          	subw	a0,a3,a0
    80001642:	2505                	addw	a0,a0,1
    ;
  return n;
}
    80001644:	6422                	ld	s0,8(sp)
    80001646:	0141                	add	sp,sp,16
    80001648:	8082                	ret
  for(n = 0; s[n]; n++)
    8000164a:	4501                	li	a0,0
    8000164c:	bfe5                	j	80001644 <strlen+0x20>

000000008000164e <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000164e:	1141                	add	sp,sp,-16
    80001650:	e406                	sd	ra,8(sp)
    80001652:	e022                	sd	s0,0(sp)
    80001654:	0800                	add	s0,sp,16
  if(cpuid() == 0){
    80001656:	00001097          	auipc	ra,0x1
    8000165a:	d02080e7          	jalr	-766(ra) # 80002358 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000165e:	00008717          	auipc	a4,0x8
    80001662:	50270713          	add	a4,a4,1282 # 80009b60 <started>
  if(cpuid() == 0){
    80001666:	c139                	beqz	a0,800016ac <main+0x5e>
    while(started == 0)
    80001668:	431c                	lw	a5,0(a4)
    8000166a:	2781                	sext.w	a5,a5
    8000166c:	dff5                	beqz	a5,80001668 <main+0x1a>
      ;
    __sync_synchronize();
    8000166e:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80001672:	00001097          	auipc	ra,0x1
    80001676:	ce6080e7          	jalr	-794(ra) # 80002358 <cpuid>
    8000167a:	85aa                	mv	a1,a0
    8000167c:	00008517          	auipc	a0,0x8
    80001680:	b8c50513          	add	a0,a0,-1140 # 80009208 <etext+0x208>
    80001684:	fffff097          	auipc	ra,0xfffff
    80001688:	f5c080e7          	jalr	-164(ra) # 800005e0 <printf>
    kvminithart();    // turn on paging
    8000168c:	00000097          	auipc	ra,0x0
    80001690:	0d8080e7          	jalr	216(ra) # 80001764 <kvminithart>
    trapinithart();   // install kernel trap vector
    80001694:	00002097          	auipc	ra,0x2
    80001698:	404080e7          	jalr	1028(ra) # 80003a98 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000169c:	00006097          	auipc	ra,0x6
    800016a0:	e18080e7          	jalr	-488(ra) # 800074b4 <plicinithart>
  }

  scheduler();        
    800016a4:	00001097          	auipc	ra,0x1
    800016a8:	790080e7          	jalr	1936(ra) # 80002e34 <scheduler>
    consoleinit();
    800016ac:	fffff097          	auipc	ra,0xfffff
    800016b0:	dfa080e7          	jalr	-518(ra) # 800004a6 <consoleinit>
    printfinit();
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	134080e7          	jalr	308(ra) # 800007e8 <printfinit>
    printf("\n");
    800016bc:	00008517          	auipc	a0,0x8
    800016c0:	98450513          	add	a0,a0,-1660 # 80009040 <etext+0x40>
    800016c4:	fffff097          	auipc	ra,0xfffff
    800016c8:	f1c080e7          	jalr	-228(ra) # 800005e0 <printf>
    printf("xv6 kernel is booting\n");
    800016cc:	00008517          	auipc	a0,0x8
    800016d0:	b2450513          	add	a0,a0,-1244 # 800091f0 <etext+0x1f0>
    800016d4:	fffff097          	auipc	ra,0xfffff
    800016d8:	f0c080e7          	jalr	-244(ra) # 800005e0 <printf>
    printf("\n");
    800016dc:	00008517          	auipc	a0,0x8
    800016e0:	96450513          	add	a0,a0,-1692 # 80009040 <etext+0x40>
    800016e4:	fffff097          	auipc	ra,0xfffff
    800016e8:	efc080e7          	jalr	-260(ra) # 800005e0 <printf>
    kinit();         // physical page allocator
    800016ec:	00000097          	auipc	ra,0x0
    800016f0:	88c080e7          	jalr	-1908(ra) # 80000f78 <kinit>
    kvminit();       // create kernel page table
    800016f4:	00000097          	auipc	ra,0x0
    800016f8:	3e2080e7          	jalr	994(ra) # 80001ad6 <kvminit>
    kvminithart();   // turn on paging
    800016fc:	00000097          	auipc	ra,0x0
    80001700:	068080e7          	jalr	104(ra) # 80001764 <kvminithart>
    procinit();      // process table
    80001704:	00001097          	auipc	ra,0x1
    80001708:	b92080e7          	jalr	-1134(ra) # 80002296 <procinit>
    trapinit();      // trap vectors
    8000170c:	00002097          	auipc	ra,0x2
    80001710:	364080e7          	jalr	868(ra) # 80003a70 <trapinit>
    trapinithart();  // install kernel trap vector
    80001714:	00002097          	auipc	ra,0x2
    80001718:	384080e7          	jalr	900(ra) # 80003a98 <trapinithart>
    plicinit();      // set up interrupt controller
    8000171c:	00006097          	auipc	ra,0x6
    80001720:	d7e080e7          	jalr	-642(ra) # 8000749a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001724:	00006097          	auipc	ra,0x6
    80001728:	d90080e7          	jalr	-624(ra) # 800074b4 <plicinithart>
    binit();         // buffer cache
    8000172c:	00003097          	auipc	ra,0x3
    80001730:	e2c080e7          	jalr	-468(ra) # 80004558 <binit>
    iinit();         // inode table
    80001734:	00003097          	auipc	ra,0x3
    80001738:	4e2080e7          	jalr	1250(ra) # 80004c16 <iinit>
    fileinit();      // file table
    8000173c:	00004097          	auipc	ra,0x4
    80001740:	492080e7          	jalr	1170(ra) # 80005bce <fileinit>
    virtio_disk_init(); // emulated hard disk
    80001744:	00006097          	auipc	ra,0x6
    80001748:	e78080e7          	jalr	-392(ra) # 800075bc <virtio_disk_init>
    userinit();      // first user process
    8000174c:	00001097          	auipc	ra,0x1
    80001750:	fd0080e7          	jalr	-48(ra) # 8000271c <userinit>
    __sync_synchronize();
    80001754:	0ff0000f          	fence
    started = 1;
    80001758:	4785                	li	a5,1
    8000175a:	00008717          	auipc	a4,0x8
    8000175e:	40f72323          	sw	a5,1030(a4) # 80009b60 <started>
    80001762:	b789                	j	800016a4 <main+0x56>

0000000080001764 <kvminithart>:

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void
kvminithart()
{
    80001764:	1141                	add	sp,sp,-16
    80001766:	e422                	sd	s0,8(sp)
    80001768:	0800                	add	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000176a:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000176e:	00008797          	auipc	a5,0x8
    80001772:	3fa7b783          	ld	a5,1018(a5) # 80009b68 <kernel_pagetable>
    80001776:	83b1                	srl	a5,a5,0xc
    80001778:	577d                	li	a4,-1
    8000177a:	177e                	sll	a4,a4,0x3f
    8000177c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000177e:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80001782:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80001786:	6422                	ld	s0,8(sp)
    80001788:	0141                	add	sp,sp,16
    8000178a:	8082                	ret

000000008000178c <lazy_alloc>:


void lazy_alloc(pagetable_t pagetable, uint64 va, int isHuge)
{
    8000178c:	1141                	add	sp,sp,-16
    8000178e:	e422                	sd	s0,8(sp)
    80001790:	0800                	add	s0,sp,16
  
}
    80001792:	6422                	ld	s0,8(sp)
    80001794:	0141                	add	sp,sp,16
    80001796:	8082                	ret

0000000080001798 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80001798:	7139                	add	sp,sp,-64
    8000179a:	fc06                	sd	ra,56(sp)
    8000179c:	f822                	sd	s0,48(sp)
    8000179e:	f426                	sd	s1,40(sp)
    800017a0:	f04a                	sd	s2,32(sp)
    800017a2:	ec4e                	sd	s3,24(sp)
    800017a4:	e852                	sd	s4,16(sp)
    800017a6:	e456                	sd	s5,8(sp)
    800017a8:	e05a                	sd	s6,0(sp)
    800017aa:	0080                	add	s0,sp,64
    800017ac:	84aa                	mv	s1,a0
    800017ae:	89ae                	mv	s3,a1
    800017b0:	8ab2                	mv	s5,a2
  if(va >= MAXVA)
    800017b2:	57fd                	li	a5,-1
    800017b4:	83e9                	srl	a5,a5,0x1a
    800017b6:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800017b8:	4b31                	li	s6,12
  if(va >= MAXVA)
    800017ba:	04b7f263          	bgeu	a5,a1,800017fe <walk+0x66>
    panic("walk");
    800017be:	00008517          	auipc	a0,0x8
    800017c2:	a6250513          	add	a0,a0,-1438 # 80009220 <etext+0x220>
    800017c6:	fffff097          	auipc	ra,0xfffff
    800017ca:	dd0080e7          	jalr	-560(ra) # 80000596 <panic>
    if(*pte & PTE_V) {
      //printf("WOW! FOUND! at level %d\n",level);
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
            //printf("NOT FOUND! at level %d\n",level);
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800017ce:	060a8663          	beqz	s5,8000183a <walk+0xa2>
    800017d2:	00000097          	auipc	ra,0x0
    800017d6:	854080e7          	jalr	-1964(ra) # 80001026 <kalloc>
    800017da:	84aa                	mv	s1,a0
    800017dc:	c529                	beqz	a0,80001826 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    800017de:	6605                	lui	a2,0x1
    800017e0:	4581                	li	a1,0
    800017e2:	00000097          	auipc	ra,0x0
    800017e6:	cce080e7          	jalr	-818(ra) # 800014b0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800017ea:	00c4d793          	srl	a5,s1,0xc
    800017ee:	07aa                	sll	a5,a5,0xa
    800017f0:	0017e793          	or	a5,a5,1
    800017f4:	00f93023          	sd	a5,0(s2)
  for(int level = 2; level > 0; level--) {
    800017f8:	3a5d                	addw	s4,s4,-9 # ffffffffffffeff7 <end+0xffffffff7ffcab27>
    800017fa:	036a0063          	beq	s4,s6,8000181a <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800017fe:	0149d933          	srl	s2,s3,s4
    80001802:	1ff97913          	and	s2,s2,511
    80001806:	090e                	sll	s2,s2,0x3
    80001808:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000180a:	00093483          	ld	s1,0(s2)
    8000180e:	0014f793          	and	a5,s1,1
    80001812:	dfd5                	beqz	a5,800017ce <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80001814:	80a9                	srl	s1,s1,0xa
    80001816:	04b2                	sll	s1,s1,0xc
    80001818:	b7c5                	j	800017f8 <walk+0x60>
    }
  }
  
  //printf("WALK value : %p\n",PTE2PA(pagetable[PX(0, va)]));
  return &pagetable[PX(0, va)];
    8000181a:	00c9d513          	srl	a0,s3,0xc
    8000181e:	1ff57513          	and	a0,a0,511
    80001822:	050e                	sll	a0,a0,0x3
    80001824:	9526                	add	a0,a0,s1
}
    80001826:	70e2                	ld	ra,56(sp)
    80001828:	7442                	ld	s0,48(sp)
    8000182a:	74a2                	ld	s1,40(sp)
    8000182c:	7902                	ld	s2,32(sp)
    8000182e:	69e2                	ld	s3,24(sp)
    80001830:	6a42                	ld	s4,16(sp)
    80001832:	6aa2                	ld	s5,8(sp)
    80001834:	6b02                	ld	s6,0(sp)
    80001836:	6121                	add	sp,sp,64
    80001838:	8082                	ret
        return 0;
    8000183a:	4501                	li	a0,0
    8000183c:	b7ed                	j	80001826 <walk+0x8e>

000000008000183e <walk_huge>:


pte_t *
walk_huge(pagetable_t pagetable, uint64 va, int alloc)
{
    8000183e:	7179                	add	sp,sp,-48
    80001840:	f406                	sd	ra,40(sp)
    80001842:	f022                	sd	s0,32(sp)
    80001844:	ec26                	sd	s1,24(sp)
    80001846:	e84a                	sd	s2,16(sp)
    80001848:	e44e                	sd	s3,8(sp)
    8000184a:	1800                	add	s0,sp,48
  if(va >= MAXVA)
    8000184c:	57fd                	li	a5,-1
    8000184e:	83e9                	srl	a5,a5,0x1a
    80001850:	04b7e463          	bltu	a5,a1,80001898 <walk_huge+0x5a>
    80001854:	84ae                	mv	s1,a1


  

  for(int level = 2; level > 1; level--) {
    pte_t *pte = &pagetable[PX(level, va)];
    80001856:	01e5d793          	srl	a5,a1,0x1e
    8000185a:	078e                	sll	a5,a5,0x3
    8000185c:	00f509b3          	add	s3,a0,a5

    // PTE_V works as mask here
    // use *pte & PTE_( ) as masks later!

    if(*pte & PTE_V) {
    80001860:	0009b903          	ld	s2,0(s3) # 1000 <_entry-0x7ffff000>
    80001864:	00197793          	and	a5,s2,1
    80001868:	c3a1                	beqz	a5,800018a8 <walk_huge+0x6a>
      //printf("WOW! FOUND! at level %d\n",level);
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000186a:	00a95913          	srl	s2,s2,0xa
    8000186e:	0932                	sll	s2,s2,0xc
  // 1) non valid : 그냥 보내주면 됨
  // 2-1) valid - but non-leaf: 비워서(non-valid하게 만들어서) 보내주면 됨. 그러면 leaf로 인식됨
  // ㄴ 여기에 추가적으로 non-leaf에 딸려있는 page는 비어있어야 할것...(생각해보자...)
  // 2-2) valid - and leaf : 보내주면 됨

  pte_t* pte  = &pagetable[PX(1,va)];
    80001870:	80d5                	srl	s1,s1,0x15
    80001872:	1ff4f493          	and	s1,s1,511
    80001876:	048e                	sll	s1,s1,0x3
    80001878:	9926                	add	s2,s2,s1

  //2-1 valid non leaf(make non-valid, but non zero)
  if((*pte & PTE_V) && (*pte & (PTE_R|PTE_W|PTE_X)) == 0)
    8000187a:	00093503          	ld	a0,0(s2)
    8000187e:	00f57713          	and	a4,a0,15
    80001882:	4785                	li	a5,1
    80001884:	04f70763          	beq	a4,a5,800018d2 <walk_huge+0x94>
  //printf("WALK value : %p\n",PTE2PA(pagetable[PX(0, va)]));

  // is it okay..?

  return &pagetable[PX(1, va)];
}
    80001888:	854a                	mv	a0,s2
    8000188a:	70a2                	ld	ra,40(sp)
    8000188c:	7402                	ld	s0,32(sp)
    8000188e:	64e2                	ld	s1,24(sp)
    80001890:	6942                	ld	s2,16(sp)
    80001892:	69a2                	ld	s3,8(sp)
    80001894:	6145                	add	sp,sp,48
    80001896:	8082                	ret
    panic("walk");
    80001898:	00008517          	auipc	a0,0x8
    8000189c:	98850513          	add	a0,a0,-1656 # 80009220 <etext+0x220>
    800018a0:	fffff097          	auipc	ra,0xfffff
    800018a4:	cf6080e7          	jalr	-778(ra) # 80000596 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800018a8:	c229                	beqz	a2,800018ea <walk_huge+0xac>
    800018aa:	fffff097          	auipc	ra,0xfffff
    800018ae:	77c080e7          	jalr	1916(ra) # 80001026 <kalloc>
    800018b2:	892a                	mv	s2,a0
    800018b4:	d971                	beqz	a0,80001888 <walk_huge+0x4a>
      memset(pagetable, 0, PGSIZE);
    800018b6:	6605                	lui	a2,0x1
    800018b8:	4581                	li	a1,0
    800018ba:	00000097          	auipc	ra,0x0
    800018be:	bf6080e7          	jalr	-1034(ra) # 800014b0 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800018c2:	00c95793          	srl	a5,s2,0xc
    800018c6:	07aa                	sll	a5,a5,0xa
    800018c8:	0017e793          	or	a5,a5,1
    800018cc:	00f9b023          	sd	a5,0(s3)
    800018d0:	b745                	j	80001870 <walk_huge+0x32>
    uint64 leaf_pa = PTE2PA((*pte));
    800018d2:	8129                	srl	a0,a0,0xa
    kfree((void*)leaf_pa);
    800018d4:	0532                	sll	a0,a0,0xc
    800018d6:	fffff097          	auipc	ra,0xfffff
    800018da:	4f2080e7          	jalr	1266(ra) # 80000dc8 <kfree>
    *pte = *pte - 1;
    800018de:	00093783          	ld	a5,0(s2)
    800018e2:	17fd                	add	a5,a5,-1
    800018e4:	00f93023          	sd	a5,0(s2)
    800018e8:	b745                	j	80001888 <walk_huge+0x4a>
        return 0;
    800018ea:	4901                	li	s2,0
    800018ec:	bf71                	j	80001888 <walk_huge+0x4a>

00000000800018ee <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800018ee:	57fd                	li	a5,-1
    800018f0:	83e9                	srl	a5,a5,0x1a
    800018f2:	00b7f463          	bgeu	a5,a1,800018fa <walkaddr+0xc>
    return 0;
    800018f6:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800018f8:	8082                	ret
{
    800018fa:	1141                	add	sp,sp,-16
    800018fc:	e406                	sd	ra,8(sp)
    800018fe:	e022                	sd	s0,0(sp)
    80001900:	0800                	add	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001902:	4601                	li	a2,0
    80001904:	00000097          	auipc	ra,0x0
    80001908:	e94080e7          	jalr	-364(ra) # 80001798 <walk>
  if(pte == 0)
    8000190c:	c105                	beqz	a0,8000192c <walkaddr+0x3e>
  if((*pte & PTE_V) == 0)
    8000190e:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80001910:	0117f693          	and	a3,a5,17
    80001914:	4745                	li	a4,17
    return 0;
    80001916:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80001918:	00e68663          	beq	a3,a4,80001924 <walkaddr+0x36>
}
    8000191c:	60a2                	ld	ra,8(sp)
    8000191e:	6402                	ld	s0,0(sp)
    80001920:	0141                	add	sp,sp,16
    80001922:	8082                	ret
  pa = PTE2PA(*pte);
    80001924:	83a9                	srl	a5,a5,0xa
    80001926:	00c79513          	sll	a0,a5,0xc
  return pa;
    8000192a:	bfcd                	j	8000191c <walkaddr+0x2e>
    return 0;
    8000192c:	4501                	li	a0,0
    8000192e:	b7fd                	j	8000191c <walkaddr+0x2e>

0000000080001930 <mappages>:
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001930:	715d                	add	sp,sp,-80
    80001932:	e486                	sd	ra,72(sp)
    80001934:	e0a2                	sd	s0,64(sp)
    80001936:	fc26                	sd	s1,56(sp)
    80001938:	f84a                	sd	s2,48(sp)
    8000193a:	f44e                	sd	s3,40(sp)
    8000193c:	f052                	sd	s4,32(sp)
    8000193e:	ec56                	sd	s5,24(sp)
    80001940:	e85a                	sd	s6,16(sp)
    80001942:	e45e                	sd	s7,8(sp)
    80001944:	0880                	add	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if(size == 0)
    80001946:	c639                	beqz	a2,80001994 <mappages+0x64>
    80001948:	8aaa                	mv	s5,a0
    8000194a:	8b3a                	mv	s6,a4
    panic("mappages: size");
  
  a = PGROUNDDOWN(va);
    8000194c:	777d                	lui	a4,0xfffff
    8000194e:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    80001952:	fff58993          	add	s3,a1,-1
    80001956:	99b2                	add	s3,s3,a2
    80001958:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    8000195c:	893e                	mv	s2,a5
    8000195e:	40f68a33          	sub	s4,a3,a5
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80001962:	6b85                	lui	s7,0x1
    80001964:	014904b3          	add	s1,s2,s4
    if((pte = walk(pagetable, a, 1)) == 0)
    80001968:	4605                	li	a2,1
    8000196a:	85ca                	mv	a1,s2
    8000196c:	8556                	mv	a0,s5
    8000196e:	00000097          	auipc	ra,0x0
    80001972:	e2a080e7          	jalr	-470(ra) # 80001798 <walk>
    80001976:	cd1d                	beqz	a0,800019b4 <mappages+0x84>
    if(*pte & PTE_V)
    80001978:	611c                	ld	a5,0(a0)
    8000197a:	8b85                	and	a5,a5,1
    8000197c:	e785                	bnez	a5,800019a4 <mappages+0x74>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000197e:	80b1                	srl	s1,s1,0xc
    80001980:	04aa                	sll	s1,s1,0xa
    80001982:	0164e4b3          	or	s1,s1,s6
    80001986:	0014e493          	or	s1,s1,1
    8000198a:	e104                	sd	s1,0(a0)
    if(a == last)
    8000198c:	05390063          	beq	s2,s3,800019cc <mappages+0x9c>
    a += PGSIZE;
    80001990:	995e                	add	s2,s2,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80001992:	bfc9                	j	80001964 <mappages+0x34>
    panic("mappages: size");
    80001994:	00008517          	auipc	a0,0x8
    80001998:	89450513          	add	a0,a0,-1900 # 80009228 <etext+0x228>
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	bfa080e7          	jalr	-1030(ra) # 80000596 <panic>
      panic("mappages: remap");
    800019a4:	00008517          	auipc	a0,0x8
    800019a8:	89450513          	add	a0,a0,-1900 # 80009238 <etext+0x238>
    800019ac:	fffff097          	auipc	ra,0xfffff
    800019b0:	bea080e7          	jalr	-1046(ra) # 80000596 <panic>
      return -1;
    800019b4:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800019b6:	60a6                	ld	ra,72(sp)
    800019b8:	6406                	ld	s0,64(sp)
    800019ba:	74e2                	ld	s1,56(sp)
    800019bc:	7942                	ld	s2,48(sp)
    800019be:	79a2                	ld	s3,40(sp)
    800019c0:	7a02                	ld	s4,32(sp)
    800019c2:	6ae2                	ld	s5,24(sp)
    800019c4:	6b42                	ld	s6,16(sp)
    800019c6:	6ba2                	ld	s7,8(sp)
    800019c8:	6161                	add	sp,sp,80
    800019ca:	8082                	ret
  return 0;
    800019cc:	4501                	li	a0,0
    800019ce:	b7e5                	j	800019b6 <mappages+0x86>

00000000800019d0 <kvmmap>:
{
    800019d0:	1141                	add	sp,sp,-16
    800019d2:	e406                	sd	ra,8(sp)
    800019d4:	e022                	sd	s0,0(sp)
    800019d6:	0800                	add	s0,sp,16
    800019d8:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800019da:	86b2                	mv	a3,a2
    800019dc:	863e                	mv	a2,a5
    800019de:	00000097          	auipc	ra,0x0
    800019e2:	f52080e7          	jalr	-174(ra) # 80001930 <mappages>
    800019e6:	e509                	bnez	a0,800019f0 <kvmmap+0x20>
}
    800019e8:	60a2                	ld	ra,8(sp)
    800019ea:	6402                	ld	s0,0(sp)
    800019ec:	0141                	add	sp,sp,16
    800019ee:	8082                	ret
    panic("kvmmap");
    800019f0:	00008517          	auipc	a0,0x8
    800019f4:	85850513          	add	a0,a0,-1960 # 80009248 <etext+0x248>
    800019f8:	fffff097          	auipc	ra,0xfffff
    800019fc:	b9e080e7          	jalr	-1122(ra) # 80000596 <panic>

0000000080001a00 <kvmmake>:
{
    80001a00:	1101                	add	sp,sp,-32
    80001a02:	ec06                	sd	ra,24(sp)
    80001a04:	e822                	sd	s0,16(sp)
    80001a06:	e426                	sd	s1,8(sp)
    80001a08:	e04a                	sd	s2,0(sp)
    80001a0a:	1000                	add	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80001a0c:	fffff097          	auipc	ra,0xfffff
    80001a10:	61a080e7          	jalr	1562(ra) # 80001026 <kalloc>
    80001a14:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001a16:	6605                	lui	a2,0x1
    80001a18:	4581                	li	a1,0
    80001a1a:	00000097          	auipc	ra,0x0
    80001a1e:	a96080e7          	jalr	-1386(ra) # 800014b0 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001a22:	4719                	li	a4,6
    80001a24:	6685                	lui	a3,0x1
    80001a26:	10000637          	lui	a2,0x10000
    80001a2a:	100005b7          	lui	a1,0x10000
    80001a2e:	8526                	mv	a0,s1
    80001a30:	00000097          	auipc	ra,0x0
    80001a34:	fa0080e7          	jalr	-96(ra) # 800019d0 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001a38:	4719                	li	a4,6
    80001a3a:	6685                	lui	a3,0x1
    80001a3c:	10001637          	lui	a2,0x10001
    80001a40:	100015b7          	lui	a1,0x10001
    80001a44:	8526                	mv	a0,s1
    80001a46:	00000097          	auipc	ra,0x0
    80001a4a:	f8a080e7          	jalr	-118(ra) # 800019d0 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001a4e:	4719                	li	a4,6
    80001a50:	004006b7          	lui	a3,0x400
    80001a54:	0c000637          	lui	a2,0xc000
    80001a58:	0c0005b7          	lui	a1,0xc000
    80001a5c:	8526                	mv	a0,s1
    80001a5e:	00000097          	auipc	ra,0x0
    80001a62:	f72080e7          	jalr	-142(ra) # 800019d0 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80001a66:	00007917          	auipc	s2,0x7
    80001a6a:	59a90913          	add	s2,s2,1434 # 80009000 <etext>
    80001a6e:	4729                	li	a4,10
    80001a70:	80007697          	auipc	a3,0x80007
    80001a74:	59068693          	add	a3,a3,1424 # 9000 <_entry-0x7fff7000>
    80001a78:	4605                	li	a2,1
    80001a7a:	067e                	sll	a2,a2,0x1f
    80001a7c:	85b2                	mv	a1,a2
    80001a7e:	8526                	mv	a0,s1
    80001a80:	00000097          	auipc	ra,0x0
    80001a84:	f50080e7          	jalr	-176(ra) # 800019d0 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80001a88:	46c5                	li	a3,17
    80001a8a:	06ee                	sll	a3,a3,0x1b
    80001a8c:	4719                	li	a4,6
    80001a8e:	412686b3          	sub	a3,a3,s2
    80001a92:	864a                	mv	a2,s2
    80001a94:	85ca                	mv	a1,s2
    80001a96:	8526                	mv	a0,s1
    80001a98:	00000097          	auipc	ra,0x0
    80001a9c:	f38080e7          	jalr	-200(ra) # 800019d0 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001aa0:	4729                	li	a4,10
    80001aa2:	6685                	lui	a3,0x1
    80001aa4:	00006617          	auipc	a2,0x6
    80001aa8:	55c60613          	add	a2,a2,1372 # 80008000 <_trampoline>
    80001aac:	040005b7          	lui	a1,0x4000
    80001ab0:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001ab2:	05b2                	sll	a1,a1,0xc
    80001ab4:	8526                	mv	a0,s1
    80001ab6:	00000097          	auipc	ra,0x0
    80001aba:	f1a080e7          	jalr	-230(ra) # 800019d0 <kvmmap>
  proc_mapstacks(kpgtbl);
    80001abe:	8526                	mv	a0,s1
    80001ac0:	00000097          	auipc	ra,0x0
    80001ac4:	732080e7          	jalr	1842(ra) # 800021f2 <proc_mapstacks>
}
    80001ac8:	8526                	mv	a0,s1
    80001aca:	60e2                	ld	ra,24(sp)
    80001acc:	6442                	ld	s0,16(sp)
    80001ace:	64a2                	ld	s1,8(sp)
    80001ad0:	6902                	ld	s2,0(sp)
    80001ad2:	6105                	add	sp,sp,32
    80001ad4:	8082                	ret

0000000080001ad6 <kvminit>:
{
    80001ad6:	1141                	add	sp,sp,-16
    80001ad8:	e406                	sd	ra,8(sp)
    80001ada:	e022                	sd	s0,0(sp)
    80001adc:	0800                	add	s0,sp,16
  kernel_pagetable = kvmmake();
    80001ade:	00000097          	auipc	ra,0x0
    80001ae2:	f22080e7          	jalr	-222(ra) # 80001a00 <kvmmake>
    80001ae6:	00008797          	auipc	a5,0x8
    80001aea:	08a7b123          	sd	a0,130(a5) # 80009b68 <kernel_pagetable>
}
    80001aee:	60a2                	ld	ra,8(sp)
    80001af0:	6402                	ld	s0,0(sp)
    80001af2:	0141                	add	sp,sp,16
    80001af4:	8082                	ret

0000000080001af6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001af6:	715d                	add	sp,sp,-80
    80001af8:	e486                	sd	ra,72(sp)
    80001afa:	e0a2                	sd	s0,64(sp)
    80001afc:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80001afe:	03459793          	sll	a5,a1,0x34
    80001b02:	e39d                	bnez	a5,80001b28 <uvmunmap+0x32>
    80001b04:	f84a                	sd	s2,48(sp)
    80001b06:	f44e                	sd	s3,40(sp)
    80001b08:	f052                	sd	s4,32(sp)
    80001b0a:	ec56                	sd	s5,24(sp)
    80001b0c:	e85a                	sd	s6,16(sp)
    80001b0e:	e45e                	sd	s7,8(sp)
    80001b10:	8a2a                	mv	s4,a0
    80001b12:	892e                	mv	s2,a1
    80001b14:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001b16:	0632                	sll	a2,a2,0xc
    80001b18:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0)
      panic("uvmunmap: walk");
    if((*pte & PTE_V) == 0)
      panic("uvmunmap: not mapped");
    if(PTE_FLAGS(*pte) == PTE_V)
    80001b1c:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001b1e:	6b05                	lui	s6,0x1
    80001b20:	0935fb63          	bgeu	a1,s3,80001bb6 <uvmunmap+0xc0>
    80001b24:	fc26                	sd	s1,56(sp)
    80001b26:	a8a9                	j	80001b80 <uvmunmap+0x8a>
    80001b28:	fc26                	sd	s1,56(sp)
    80001b2a:	f84a                	sd	s2,48(sp)
    80001b2c:	f44e                	sd	s3,40(sp)
    80001b2e:	f052                	sd	s4,32(sp)
    80001b30:	ec56                	sd	s5,24(sp)
    80001b32:	e85a                	sd	s6,16(sp)
    80001b34:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80001b36:	00007517          	auipc	a0,0x7
    80001b3a:	71a50513          	add	a0,a0,1818 # 80009250 <etext+0x250>
    80001b3e:	fffff097          	auipc	ra,0xfffff
    80001b42:	a58080e7          	jalr	-1448(ra) # 80000596 <panic>
      panic("uvmunmap: walk");
    80001b46:	00007517          	auipc	a0,0x7
    80001b4a:	72250513          	add	a0,a0,1826 # 80009268 <etext+0x268>
    80001b4e:	fffff097          	auipc	ra,0xfffff
    80001b52:	a48080e7          	jalr	-1464(ra) # 80000596 <panic>
      panic("uvmunmap: not mapped");
    80001b56:	00007517          	auipc	a0,0x7
    80001b5a:	72250513          	add	a0,a0,1826 # 80009278 <etext+0x278>
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	a38080e7          	jalr	-1480(ra) # 80000596 <panic>
      panic("uvmunmap: not a leaf");
    80001b66:	00007517          	auipc	a0,0x7
    80001b6a:	72a50513          	add	a0,a0,1834 # 80009290 <etext+0x290>
    80001b6e:	fffff097          	auipc	ra,0xfffff
    80001b72:	a28080e7          	jalr	-1496(ra) # 80000596 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    //printf("uvmunmap for pte-%p : %p\n",pte,*pte);
    *pte = 0;
    80001b76:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80001b7a:	995a                	add	s2,s2,s6
    80001b7c:	03397c63          	bgeu	s2,s3,80001bb4 <uvmunmap+0xbe>
    if((pte = walk(pagetable, a, 0)) == 0)
    80001b80:	4601                	li	a2,0
    80001b82:	85ca                	mv	a1,s2
    80001b84:	8552                	mv	a0,s4
    80001b86:	00000097          	auipc	ra,0x0
    80001b8a:	c12080e7          	jalr	-1006(ra) # 80001798 <walk>
    80001b8e:	84aa                	mv	s1,a0
    80001b90:	d95d                	beqz	a0,80001b46 <uvmunmap+0x50>
    if((*pte & PTE_V) == 0)
    80001b92:	6108                	ld	a0,0(a0)
    80001b94:	00157793          	and	a5,a0,1
    80001b98:	dfdd                	beqz	a5,80001b56 <uvmunmap+0x60>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001b9a:	3ff57793          	and	a5,a0,1023
    80001b9e:	fd7784e3          	beq	a5,s7,80001b66 <uvmunmap+0x70>
    if(do_free){
    80001ba2:	fc0a8ae3          	beqz	s5,80001b76 <uvmunmap+0x80>
      uint64 pa = PTE2PA(*pte);
    80001ba6:	8129                	srl	a0,a0,0xa
      kfree((void*)pa);
    80001ba8:	0532                	sll	a0,a0,0xc
    80001baa:	fffff097          	auipc	ra,0xfffff
    80001bae:	21e080e7          	jalr	542(ra) # 80000dc8 <kfree>
    80001bb2:	b7d1                	j	80001b76 <uvmunmap+0x80>
    80001bb4:	74e2                	ld	s1,56(sp)
    80001bb6:	7942                	ld	s2,48(sp)
    80001bb8:	79a2                	ld	s3,40(sp)
    80001bba:	7a02                	ld	s4,32(sp)
    80001bbc:	6ae2                	ld	s5,24(sp)
    80001bbe:	6b42                	ld	s6,16(sp)
    80001bc0:	6ba2                	ld	s7,8(sp)
  }
}
    80001bc2:	60a6                	ld	ra,72(sp)
    80001bc4:	6406                	ld	s0,64(sp)
    80001bc6:	6161                	add	sp,sp,80
    80001bc8:	8082                	ret

0000000080001bca <uvmunmap_huge>:

void
uvmunmap_huge(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80001bca:	715d                	add	sp,sp,-80
    80001bcc:	e486                	sd	ra,72(sp)
    80001bce:	e0a2                	sd	s0,64(sp)
    80001bd0:	0880                	add	s0,sp,80
  uint64 a;
  pte_t *pte;
  //int cycle = 0;

  if((va % HUGEPGSIZE) != 0)
    80001bd2:	02b59793          	sll	a5,a1,0x2b
    80001bd6:	e785                	bnez	a5,80001bfe <uvmunmap_huge+0x34>
    80001bd8:	f84a                	sd	s2,48(sp)
    80001bda:	f44e                	sd	s3,40(sp)
    80001bdc:	f052                	sd	s4,32(sp)
    80001bde:	ec56                	sd	s5,24(sp)
    80001be0:	e85a                	sd	s6,16(sp)
    80001be2:	e45e                	sd	s7,8(sp)
    80001be4:	8a2a                	mv	s4,a0
    80001be6:	892e                	mv	s2,a1
    80001be8:	8b36                	mv	s6,a3
    panic("uvmunmap(huge): not aligned");

  

  for(a = va; a < va + npages*HUGEPGSIZE; a += HUGEPGSIZE){
    80001bea:	0656                	sll	a2,a2,0x15
    80001bec:	00b609b3          	add	s3,a2,a1
      //printf("(huge)page table exists for va %p, but not valid\n", a);
      continue;
      panic("uvmunmap(huge): not mapped");
    }

    if(PTE_FLAGS(*pte) == PTE_V)
    80001bf0:	4b85                	li	s7,1
  for(a = va; a < va + npages*HUGEPGSIZE; a += HUGEPGSIZE){
    80001bf2:	00200ab7          	lui	s5,0x200
    80001bf6:	0735fc63          	bgeu	a1,s3,80001c6e <uvmunmap_huge+0xa4>
    80001bfa:	fc26                	sd	s1,56(sp)
    80001bfc:	a82d                	j	80001c36 <uvmunmap_huge+0x6c>
    80001bfe:	fc26                	sd	s1,56(sp)
    80001c00:	f84a                	sd	s2,48(sp)
    80001c02:	f44e                	sd	s3,40(sp)
    80001c04:	f052                	sd	s4,32(sp)
    80001c06:	ec56                	sd	s5,24(sp)
    80001c08:	e85a                	sd	s6,16(sp)
    80001c0a:	e45e                	sd	s7,8(sp)
    panic("uvmunmap(huge): not aligned");
    80001c0c:	00007517          	auipc	a0,0x7
    80001c10:	69c50513          	add	a0,a0,1692 # 800092a8 <etext+0x2a8>
    80001c14:	fffff097          	auipc	ra,0xfffff
    80001c18:	982080e7          	jalr	-1662(ra) # 80000596 <panic>
      panic("uvmunmap(huge): not a leaf");
    80001c1c:	00007517          	auipc	a0,0x7
    80001c20:	6ac50513          	add	a0,a0,1708 # 800092c8 <etext+0x2c8>
    80001c24:	fffff097          	auipc	ra,0xfffff
    80001c28:	972080e7          	jalr	-1678(ra) # 80000596 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree_huge((void*)pa);
    }
    
    *pte = 0;
    80001c2c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*HUGEPGSIZE; a += HUGEPGSIZE){
    80001c30:	9956                	add	s2,s2,s5
    80001c32:	03397d63          	bgeu	s2,s3,80001c6c <uvmunmap_huge+0xa2>
    if((pte = walk_huge(pagetable, a, 0)) == 0)
    80001c36:	4601                	li	a2,0
    80001c38:	85ca                	mv	a1,s2
    80001c3a:	8552                	mv	a0,s4
    80001c3c:	00000097          	auipc	ra,0x0
    80001c40:	c02080e7          	jalr	-1022(ra) # 8000183e <walk_huge>
    80001c44:	84aa                	mv	s1,a0
    80001c46:	d56d                	beqz	a0,80001c30 <uvmunmap_huge+0x66>
    if((*pte & PTE_V) == 0)
    80001c48:	611c                	ld	a5,0(a0)
    80001c4a:	0017f713          	and	a4,a5,1
    80001c4e:	d36d                	beqz	a4,80001c30 <uvmunmap_huge+0x66>
    if(PTE_FLAGS(*pte) == PTE_V)
    80001c50:	3ff7f713          	and	a4,a5,1023
    80001c54:	fd7704e3          	beq	a4,s7,80001c1c <uvmunmap_huge+0x52>
    if(do_free){
    80001c58:	fc0b0ae3          	beqz	s6,80001c2c <uvmunmap_huge+0x62>
      uint64 pa = PTE2PA(*pte);
    80001c5c:	83a9                	srl	a5,a5,0xa
      kfree_huge((void*)pa);
    80001c5e:	00c79513          	sll	a0,a5,0xc
    80001c62:	fffff097          	auipc	ra,0xfffff
    80001c66:	5bc080e7          	jalr	1468(ra) # 8000121e <kfree_huge>
    80001c6a:	b7c9                	j	80001c2c <uvmunmap_huge+0x62>
    80001c6c:	74e2                	ld	s1,56(sp)
    80001c6e:	7942                	ld	s2,48(sp)
    80001c70:	79a2                	ld	s3,40(sp)
    80001c72:	7a02                	ld	s4,32(sp)
    80001c74:	6ae2                	ld	s5,24(sp)
    80001c76:	6b42                	ld	s6,16(sp)
    80001c78:	6ba2                	ld	s7,8(sp)
  }
}
    80001c7a:	60a6                	ld	ra,72(sp)
    80001c7c:	6406                	ld	s0,64(sp)
    80001c7e:	6161                	add	sp,sp,80
    80001c80:	8082                	ret

0000000080001c82 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80001c82:	1101                	add	sp,sp,-32
    80001c84:	ec06                	sd	ra,24(sp)
    80001c86:	e822                	sd	s0,16(sp)
    80001c88:	e426                	sd	s1,8(sp)
    80001c8a:	1000                	add	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80001c8c:	fffff097          	auipc	ra,0xfffff
    80001c90:	39a080e7          	jalr	922(ra) # 80001026 <kalloc>
    80001c94:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80001c96:	c519                	beqz	a0,80001ca4 <uvmcreate+0x22>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80001c98:	6605                	lui	a2,0x1
    80001c9a:	4581                	li	a1,0
    80001c9c:	00000097          	auipc	ra,0x0
    80001ca0:	814080e7          	jalr	-2028(ra) # 800014b0 <memset>
  return pagetable;
}
    80001ca4:	8526                	mv	a0,s1
    80001ca6:	60e2                	ld	ra,24(sp)
    80001ca8:	6442                	ld	s0,16(sp)
    80001caa:	64a2                	ld	s1,8(sp)
    80001cac:	6105                	add	sp,sp,32
    80001cae:	8082                	ret

0000000080001cb0 <uvmfirst>:
// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void
uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    80001cb0:	7179                	add	sp,sp,-48
    80001cb2:	f406                	sd	ra,40(sp)
    80001cb4:	f022                	sd	s0,32(sp)
    80001cb6:	ec26                	sd	s1,24(sp)
    80001cb8:	e84a                	sd	s2,16(sp)
    80001cba:	e44e                	sd	s3,8(sp)
    80001cbc:	e052                	sd	s4,0(sp)
    80001cbe:	1800                	add	s0,sp,48
  char *mem;

  if(sz >= PGSIZE)
    80001cc0:	6785                	lui	a5,0x1
    80001cc2:	04f67863          	bgeu	a2,a5,80001d12 <uvmfirst+0x62>
    80001cc6:	8a2a                	mv	s4,a0
    80001cc8:	89ae                	mv	s3,a1
    80001cca:	84b2                	mv	s1,a2
    panic("uvmfirst: more than a page");
  mem = kalloc();
    80001ccc:	fffff097          	auipc	ra,0xfffff
    80001cd0:	35a080e7          	jalr	858(ra) # 80001026 <kalloc>
    80001cd4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    80001cd6:	6605                	lui	a2,0x1
    80001cd8:	4581                	li	a1,0
    80001cda:	fffff097          	auipc	ra,0xfffff
    80001cde:	7d6080e7          	jalr	2006(ra) # 800014b0 <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W|PTE_R|PTE_X|PTE_U);
    80001ce2:	4779                	li	a4,30
    80001ce4:	86ca                	mv	a3,s2
    80001ce6:	6605                	lui	a2,0x1
    80001ce8:	4581                	li	a1,0
    80001cea:	8552                	mv	a0,s4
    80001cec:	00000097          	auipc	ra,0x0
    80001cf0:	c44080e7          	jalr	-956(ra) # 80001930 <mappages>
  memmove(mem, src, sz);
    80001cf4:	8626                	mv	a2,s1
    80001cf6:	85ce                	mv	a1,s3
    80001cf8:	854a                	mv	a0,s2
    80001cfa:	00000097          	auipc	ra,0x0
    80001cfe:	812080e7          	jalr	-2030(ra) # 8000150c <memmove>
}
    80001d02:	70a2                	ld	ra,40(sp)
    80001d04:	7402                	ld	s0,32(sp)
    80001d06:	64e2                	ld	s1,24(sp)
    80001d08:	6942                	ld	s2,16(sp)
    80001d0a:	69a2                	ld	s3,8(sp)
    80001d0c:	6a02                	ld	s4,0(sp)
    80001d0e:	6145                	add	sp,sp,48
    80001d10:	8082                	ret
    panic("uvmfirst: more than a page");
    80001d12:	00007517          	auipc	a0,0x7
    80001d16:	5d650513          	add	a0,a0,1494 # 800092e8 <etext+0x2e8>
    80001d1a:	fffff097          	auipc	ra,0xfffff
    80001d1e:	87c080e7          	jalr	-1924(ra) # 80000596 <panic>

0000000080001d22 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80001d22:	1101                	add	sp,sp,-32
    80001d24:	ec06                	sd	ra,24(sp)
    80001d26:	e822                	sd	s0,16(sp)
    80001d28:	e426                	sd	s1,8(sp)
    80001d2a:	1000                	add	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80001d2c:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80001d2e:	00b67d63          	bgeu	a2,a1,80001d48 <uvmdealloc+0x26>
    80001d32:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80001d34:	6785                	lui	a5,0x1
    80001d36:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001d38:	00f60733          	add	a4,a2,a5
    80001d3c:	76fd                	lui	a3,0xfffff
    80001d3e:	8f75                	and	a4,a4,a3
    80001d40:	97ae                	add	a5,a5,a1
    80001d42:	8ff5                	and	a5,a5,a3
    80001d44:	00f76863          	bltu	a4,a5,80001d54 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80001d48:	8526                	mv	a0,s1
    80001d4a:	60e2                	ld	ra,24(sp)
    80001d4c:	6442                	ld	s0,16(sp)
    80001d4e:	64a2                	ld	s1,8(sp)
    80001d50:	6105                	add	sp,sp,32
    80001d52:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80001d54:	8f99                	sub	a5,a5,a4
    80001d56:	83b1                	srl	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80001d58:	4685                	li	a3,1
    80001d5a:	0007861b          	sext.w	a2,a5
    80001d5e:	85ba                	mv	a1,a4
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	d96080e7          	jalr	-618(ra) # 80001af6 <uvmunmap>
    80001d68:	b7c5                	j	80001d48 <uvmdealloc+0x26>

0000000080001d6a <uvmalloc>:
  if(newsz < oldsz)
    80001d6a:	0ab66b63          	bltu	a2,a1,80001e20 <uvmalloc+0xb6>
{
    80001d6e:	7139                	add	sp,sp,-64
    80001d70:	fc06                	sd	ra,56(sp)
    80001d72:	f822                	sd	s0,48(sp)
    80001d74:	ec4e                	sd	s3,24(sp)
    80001d76:	e852                	sd	s4,16(sp)
    80001d78:	e456                	sd	s5,8(sp)
    80001d7a:	0080                	add	s0,sp,64
    80001d7c:	8aaa                	mv	s5,a0
    80001d7e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001d80:	6785                	lui	a5,0x1
    80001d82:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001d84:	95be                	add	a1,a1,a5
    80001d86:	77fd                	lui	a5,0xfffff
    80001d88:	00f5f9b3          	and	s3,a1,a5
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001d8c:	08c9fc63          	bgeu	s3,a2,80001e24 <uvmalloc+0xba>
    80001d90:	f426                	sd	s1,40(sp)
    80001d92:	f04a                	sd	s2,32(sp)
    80001d94:	e05a                	sd	s6,0(sp)
    80001d96:	894e                	mv	s2,s3
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001d98:	0126eb13          	or	s6,a3,18
    mem = kalloc();
    80001d9c:	fffff097          	auipc	ra,0xfffff
    80001da0:	28a080e7          	jalr	650(ra) # 80001026 <kalloc>
    80001da4:	84aa                	mv	s1,a0
    if(mem == 0){
    80001da6:	c915                	beqz	a0,80001dda <uvmalloc+0x70>
    memset(mem, 0, PGSIZE);
    80001da8:	6605                	lui	a2,0x1
    80001daa:	4581                	li	a1,0
    80001dac:	fffff097          	auipc	ra,0xfffff
    80001db0:	704080e7          	jalr	1796(ra) # 800014b0 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80001db4:	875a                	mv	a4,s6
    80001db6:	86a6                	mv	a3,s1
    80001db8:	6605                	lui	a2,0x1
    80001dba:	85ca                	mv	a1,s2
    80001dbc:	8556                	mv	a0,s5
    80001dbe:	00000097          	auipc	ra,0x0
    80001dc2:	b72080e7          	jalr	-1166(ra) # 80001930 <mappages>
    80001dc6:	ed05                	bnez	a0,80001dfe <uvmalloc+0x94>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80001dc8:	6785                	lui	a5,0x1
    80001dca:	993e                	add	s2,s2,a5
    80001dcc:	fd4968e3          	bltu	s2,s4,80001d9c <uvmalloc+0x32>
  return newsz;
    80001dd0:	8552                	mv	a0,s4
    80001dd2:	74a2                	ld	s1,40(sp)
    80001dd4:	7902                	ld	s2,32(sp)
    80001dd6:	6b02                	ld	s6,0(sp)
    80001dd8:	a821                	j	80001df0 <uvmalloc+0x86>
      uvmdealloc(pagetable, a, oldsz);
    80001dda:	864e                	mv	a2,s3
    80001ddc:	85ca                	mv	a1,s2
    80001dde:	8556                	mv	a0,s5
    80001de0:	00000097          	auipc	ra,0x0
    80001de4:	f42080e7          	jalr	-190(ra) # 80001d22 <uvmdealloc>
      return 0;
    80001de8:	4501                	li	a0,0
    80001dea:	74a2                	ld	s1,40(sp)
    80001dec:	7902                	ld	s2,32(sp)
    80001dee:	6b02                	ld	s6,0(sp)
}
    80001df0:	70e2                	ld	ra,56(sp)
    80001df2:	7442                	ld	s0,48(sp)
    80001df4:	69e2                	ld	s3,24(sp)
    80001df6:	6a42                	ld	s4,16(sp)
    80001df8:	6aa2                	ld	s5,8(sp)
    80001dfa:	6121                	add	sp,sp,64
    80001dfc:	8082                	ret
      kfree(mem);
    80001dfe:	8526                	mv	a0,s1
    80001e00:	fffff097          	auipc	ra,0xfffff
    80001e04:	fc8080e7          	jalr	-56(ra) # 80000dc8 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001e08:	864e                	mv	a2,s3
    80001e0a:	85ca                	mv	a1,s2
    80001e0c:	8556                	mv	a0,s5
    80001e0e:	00000097          	auipc	ra,0x0
    80001e12:	f14080e7          	jalr	-236(ra) # 80001d22 <uvmdealloc>
      return 0;
    80001e16:	4501                	li	a0,0
    80001e18:	74a2                	ld	s1,40(sp)
    80001e1a:	7902                	ld	s2,32(sp)
    80001e1c:	6b02                	ld	s6,0(sp)
    80001e1e:	bfc9                	j	80001df0 <uvmalloc+0x86>
    return oldsz;
    80001e20:	852e                	mv	a0,a1
}
    80001e22:	8082                	ret
  return newsz;
    80001e24:	8532                	mv	a0,a2
    80001e26:	b7e9                	j	80001df0 <uvmalloc+0x86>

0000000080001e28 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001e28:	7139                	add	sp,sp,-64
    80001e2a:	fc06                	sd	ra,56(sp)
    80001e2c:	f822                	sd	s0,48(sp)
    80001e2e:	f426                	sd	s1,40(sp)
    80001e30:	f04a                	sd	s2,32(sp)
    80001e32:	ec4e                	sd	s3,24(sp)
    80001e34:	e852                	sd	s4,16(sp)
    80001e36:	e456                	sd	s5,8(sp)
    80001e38:	e05a                	sd	s6,0(sp)
    80001e3a:	0080                	add	s0,sp,64
    80001e3c:	8b2a                	mv	s6,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80001e3e:	84aa                	mv	s1,a0
    80001e40:	6985                	lui	s3,0x1
    80001e42:	99aa                	add	s3,s3,a0
    pte_t pte = pagetable[i];
    //printf("%p %p\n",pagetable+i,pte);
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001e44:	4a05                	li	s4,1
    80001e46:	a831                	j	80001e62 <freewalk+0x3a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    80001e48:	00a95913          	srl	s2,s2,0xa
      freewalk((pagetable_t)child);
    80001e4c:	00c91513          	sll	a0,s2,0xc
    80001e50:	00000097          	auipc	ra,0x0
    80001e54:	fd8080e7          	jalr	-40(ra) # 80001e28 <freewalk>
      pagetable[i] = 0;
    80001e58:	0004b023          	sd	zero,0(s1)
  for(int i = 0; i < 512; i++){
    80001e5c:	04a1                	add	s1,s1,8
    80001e5e:	07348163          	beq	s1,s3,80001ec0 <freewalk+0x98>
    pte_t pte = pagetable[i];
    80001e62:	0004b903          	ld	s2,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80001e66:	00f97793          	and	a5,s2,15
    80001e6a:	fd478fe3          	beq	a5,s4,80001e48 <freewalk+0x20>
    } else if(pte & PTE_V){
    80001e6e:	00197793          	and	a5,s2,1
    80001e72:	d7ed                	beqz	a5,80001e5c <freewalk+0x34>
      uint64 pa = PTE2PA(pte);
    80001e74:	00a95593          	srl	a1,s2,0xa
      printf("pa : %p\n",pa);
    80001e78:	05b2                	sll	a1,a1,0xc
    80001e7a:	00007517          	auipc	a0,0x7
    80001e7e:	48e50513          	add	a0,a0,1166 # 80009308 <etext+0x308>
    80001e82:	ffffe097          	auipc	ra,0xffffe
    80001e86:	75e080e7          	jalr	1886(ra) # 800005e0 <printf>
      printf("pagetable : %p\n",pagetable);
    80001e8a:	85da                	mv	a1,s6
    80001e8c:	00007517          	auipc	a0,0x7
    80001e90:	48c50513          	add	a0,a0,1164 # 80009318 <etext+0x318>
    80001e94:	ffffe097          	auipc	ra,0xffffe
    80001e98:	74c080e7          	jalr	1868(ra) # 800005e0 <printf>
      printf("fail at %p : %p\n", pagetable + i, pte);
    80001e9c:	864a                	mv	a2,s2
    80001e9e:	85a6                	mv	a1,s1
    80001ea0:	00007517          	auipc	a0,0x7
    80001ea4:	48850513          	add	a0,a0,1160 # 80009328 <etext+0x328>
    80001ea8:	ffffe097          	auipc	ra,0xffffe
    80001eac:	738080e7          	jalr	1848(ra) # 800005e0 <printf>
      panic("freewalk: leaf");
    80001eb0:	00007517          	auipc	a0,0x7
    80001eb4:	49050513          	add	a0,a0,1168 # 80009340 <etext+0x340>
    80001eb8:	ffffe097          	auipc	ra,0xffffe
    80001ebc:	6de080e7          	jalr	1758(ra) # 80000596 <panic>
    }
  }
  kfree((void*)pagetable);
    80001ec0:	855a                	mv	a0,s6
    80001ec2:	fffff097          	auipc	ra,0xfffff
    80001ec6:	f06080e7          	jalr	-250(ra) # 80000dc8 <kfree>
  //TODO : level 1에서 freewalk를 하는데, 여기가 leaf인 경우, 이는 huge_page이기에 kfree가 아니라 huge_kfree를 해야함
  //근데이게 겹칠 수 있나?
  //겹칠 수 있지 그냥 freewalk이니깐!
}
    80001eca:	70e2                	ld	ra,56(sp)
    80001ecc:	7442                	ld	s0,48(sp)
    80001ece:	74a2                	ld	s1,40(sp)
    80001ed0:	7902                	ld	s2,32(sp)
    80001ed2:	69e2                	ld	s3,24(sp)
    80001ed4:	6a42                	ld	s4,16(sp)
    80001ed6:	6aa2                	ld	s5,8(sp)
    80001ed8:	6b02                	ld	s6,0(sp)
    80001eda:	6121                	add	sp,sp,64
    80001edc:	8082                	ret

0000000080001ede <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80001ede:	1101                	add	sp,sp,-32
    80001ee0:	ec06                	sd	ra,24(sp)
    80001ee2:	e822                	sd	s0,16(sp)
    80001ee4:	e426                	sd	s1,8(sp)
    80001ee6:	1000                	add	s0,sp,32
    80001ee8:	84aa                	mv	s1,a0
  if(sz > 0)
    80001eea:	e999                	bnez	a1,80001f00 <uvmfree+0x22>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80001eec:	8526                	mv	a0,s1
    80001eee:	00000097          	auipc	ra,0x0
    80001ef2:	f3a080e7          	jalr	-198(ra) # 80001e28 <freewalk>
}
    80001ef6:	60e2                	ld	ra,24(sp)
    80001ef8:	6442                	ld	s0,16(sp)
    80001efa:	64a2                	ld	s1,8(sp)
    80001efc:	6105                	add	sp,sp,32
    80001efe:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80001f00:	6785                	lui	a5,0x1
    80001f02:	17fd                	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001f04:	95be                	add	a1,a1,a5
    80001f06:	4685                	li	a3,1
    80001f08:	00c5d613          	srl	a2,a1,0xc
    80001f0c:	4581                	li	a1,0
    80001f0e:	00000097          	auipc	ra,0x0
    80001f12:	be8080e7          	jalr	-1048(ra) # 80001af6 <uvmunmap>
    80001f16:	bfd9                	j	80001eec <uvmfree+0xe>

0000000080001f18 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80001f18:	c679                	beqz	a2,80001fe6 <uvmcopy+0xce>
{
    80001f1a:	715d                	add	sp,sp,-80
    80001f1c:	e486                	sd	ra,72(sp)
    80001f1e:	e0a2                	sd	s0,64(sp)
    80001f20:	fc26                	sd	s1,56(sp)
    80001f22:	f84a                	sd	s2,48(sp)
    80001f24:	f44e                	sd	s3,40(sp)
    80001f26:	f052                	sd	s4,32(sp)
    80001f28:	ec56                	sd	s5,24(sp)
    80001f2a:	e85a                	sd	s6,16(sp)
    80001f2c:	e45e                	sd	s7,8(sp)
    80001f2e:	0880                	add	s0,sp,80
    80001f30:	8b2a                	mv	s6,a0
    80001f32:	8aae                	mv	s5,a1
    80001f34:	8a32                	mv	s4,a2
  for(i = 0; i < sz; i += PGSIZE){
    80001f36:	4981                	li	s3,0
    if((pte = walk(old, i, 0)) == 0)
    80001f38:	4601                	li	a2,0
    80001f3a:	85ce                	mv	a1,s3
    80001f3c:	855a                	mv	a0,s6
    80001f3e:	00000097          	auipc	ra,0x0
    80001f42:	85a080e7          	jalr	-1958(ra) # 80001798 <walk>
    80001f46:	c531                	beqz	a0,80001f92 <uvmcopy+0x7a>
      panic("uvmcopy: pte should exist");
    if((*pte & PTE_V) == 0)
    80001f48:	6118                	ld	a4,0(a0)
    80001f4a:	00177793          	and	a5,a4,1
    80001f4e:	cbb1                	beqz	a5,80001fa2 <uvmcopy+0x8a>
      panic("uvmcopy: page not present");
    pa = PTE2PA(*pte);
    80001f50:	00a75593          	srl	a1,a4,0xa
    80001f54:	00c59b93          	sll	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    80001f58:	3ff77493          	and	s1,a4,1023
    if((mem = kalloc()) == 0)
    80001f5c:	fffff097          	auipc	ra,0xfffff
    80001f60:	0ca080e7          	jalr	202(ra) # 80001026 <kalloc>
    80001f64:	892a                	mv	s2,a0
    80001f66:	c939                	beqz	a0,80001fbc <uvmcopy+0xa4>
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80001f68:	6605                	lui	a2,0x1
    80001f6a:	85de                	mv	a1,s7
    80001f6c:	fffff097          	auipc	ra,0xfffff
    80001f70:	5a0080e7          	jalr	1440(ra) # 8000150c <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80001f74:	8726                	mv	a4,s1
    80001f76:	86ca                	mv	a3,s2
    80001f78:	6605                	lui	a2,0x1
    80001f7a:	85ce                	mv	a1,s3
    80001f7c:	8556                	mv	a0,s5
    80001f7e:	00000097          	auipc	ra,0x0
    80001f82:	9b2080e7          	jalr	-1614(ra) # 80001930 <mappages>
    80001f86:	e515                	bnez	a0,80001fb2 <uvmcopy+0x9a>
  for(i = 0; i < sz; i += PGSIZE){
    80001f88:	6785                	lui	a5,0x1
    80001f8a:	99be                	add	s3,s3,a5
    80001f8c:	fb49e6e3          	bltu	s3,s4,80001f38 <uvmcopy+0x20>
    80001f90:	a081                	j	80001fd0 <uvmcopy+0xb8>
      panic("uvmcopy: pte should exist");
    80001f92:	00007517          	auipc	a0,0x7
    80001f96:	3be50513          	add	a0,a0,958 # 80009350 <etext+0x350>
    80001f9a:	ffffe097          	auipc	ra,0xffffe
    80001f9e:	5fc080e7          	jalr	1532(ra) # 80000596 <panic>
      panic("uvmcopy: page not present");
    80001fa2:	00007517          	auipc	a0,0x7
    80001fa6:	3ce50513          	add	a0,a0,974 # 80009370 <etext+0x370>
    80001faa:	ffffe097          	auipc	ra,0xffffe
    80001fae:	5ec080e7          	jalr	1516(ra) # 80000596 <panic>
      kfree(mem);
    80001fb2:	854a                	mv	a0,s2
    80001fb4:	fffff097          	auipc	ra,0xfffff
    80001fb8:	e14080e7          	jalr	-492(ra) # 80000dc8 <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001fbc:	4685                	li	a3,1
    80001fbe:	00c9d613          	srl	a2,s3,0xc
    80001fc2:	4581                	li	a1,0
    80001fc4:	8556                	mv	a0,s5
    80001fc6:	00000097          	auipc	ra,0x0
    80001fca:	b30080e7          	jalr	-1232(ra) # 80001af6 <uvmunmap>
  return -1;
    80001fce:	557d                	li	a0,-1
}
    80001fd0:	60a6                	ld	ra,72(sp)
    80001fd2:	6406                	ld	s0,64(sp)
    80001fd4:	74e2                	ld	s1,56(sp)
    80001fd6:	7942                	ld	s2,48(sp)
    80001fd8:	79a2                	ld	s3,40(sp)
    80001fda:	7a02                	ld	s4,32(sp)
    80001fdc:	6ae2                	ld	s5,24(sp)
    80001fde:	6b42                	ld	s6,16(sp)
    80001fe0:	6ba2                	ld	s7,8(sp)
    80001fe2:	6161                	add	sp,sp,80
    80001fe4:	8082                	ret
  return 0;
    80001fe6:	4501                	li	a0,0
}
    80001fe8:	8082                	ret

0000000080001fea <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80001fea:	1141                	add	sp,sp,-16
    80001fec:	e406                	sd	ra,8(sp)
    80001fee:	e022                	sd	s0,0(sp)
    80001ff0:	0800                	add	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80001ff2:	4601                	li	a2,0
    80001ff4:	fffff097          	auipc	ra,0xfffff
    80001ff8:	7a4080e7          	jalr	1956(ra) # 80001798 <walk>
  if(pte == 0)
    80001ffc:	c901                	beqz	a0,8000200c <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80001ffe:	611c                	ld	a5,0(a0)
    80002000:	9bbd                	and	a5,a5,-17
    80002002:	e11c                	sd	a5,0(a0)
}
    80002004:	60a2                	ld	ra,8(sp)
    80002006:	6402                	ld	s0,0(sp)
    80002008:	0141                	add	sp,sp,16
    8000200a:	8082                	ret
    panic("uvmclear");
    8000200c:	00007517          	auipc	a0,0x7
    80002010:	38450513          	add	a0,a0,900 # 80009390 <etext+0x390>
    80002014:	ffffe097          	auipc	ra,0xffffe
    80002018:	582080e7          	jalr	1410(ra) # 80000596 <panic>

000000008000201c <copyout>:
int
copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    8000201c:	c6bd                	beqz	a3,8000208a <copyout+0x6e>
{
    8000201e:	715d                	add	sp,sp,-80
    80002020:	e486                	sd	ra,72(sp)
    80002022:	e0a2                	sd	s0,64(sp)
    80002024:	fc26                	sd	s1,56(sp)
    80002026:	f84a                	sd	s2,48(sp)
    80002028:	f44e                	sd	s3,40(sp)
    8000202a:	f052                	sd	s4,32(sp)
    8000202c:	ec56                	sd	s5,24(sp)
    8000202e:	e85a                	sd	s6,16(sp)
    80002030:	e45e                	sd	s7,8(sp)
    80002032:	e062                	sd	s8,0(sp)
    80002034:	0880                	add	s0,sp,80
    80002036:	8b2a                	mv	s6,a0
    80002038:	8c2e                	mv	s8,a1
    8000203a:	8a32                	mv	s4,a2
    8000203c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000203e:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    80002040:	6a85                	lui	s5,0x1
    80002042:	a015                	j	80002066 <copyout+0x4a>
    if(n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80002044:	9562                	add	a0,a0,s8
    80002046:	0004861b          	sext.w	a2,s1
    8000204a:	85d2                	mv	a1,s4
    8000204c:	41250533          	sub	a0,a0,s2
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	4bc080e7          	jalr	1212(ra) # 8000150c <memmove>

    len -= n;
    80002058:	409989b3          	sub	s3,s3,s1
    src += n;
    8000205c:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000205e:	01590c33          	add	s8,s2,s5
  while(len > 0){
    80002062:	02098263          	beqz	s3,80002086 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80002066:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    8000206a:	85ca                	mv	a1,s2
    8000206c:	855a                	mv	a0,s6
    8000206e:	00000097          	auipc	ra,0x0
    80002072:	880080e7          	jalr	-1920(ra) # 800018ee <walkaddr>
    if(pa0 == 0)
    80002076:	cd01                	beqz	a0,8000208e <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80002078:	418904b3          	sub	s1,s2,s8
    8000207c:	94d6                	add	s1,s1,s5
    if(n > len)
    8000207e:	fc99f3e3          	bgeu	s3,s1,80002044 <copyout+0x28>
    80002082:	84ce                	mv	s1,s3
    80002084:	b7c1                	j	80002044 <copyout+0x28>
  }
  return 0;
    80002086:	4501                	li	a0,0
    80002088:	a021                	j	80002090 <copyout+0x74>
    8000208a:	4501                	li	a0,0
}
    8000208c:	8082                	ret
      return -1;
    8000208e:	557d                	li	a0,-1
}
    80002090:	60a6                	ld	ra,72(sp)
    80002092:	6406                	ld	s0,64(sp)
    80002094:	74e2                	ld	s1,56(sp)
    80002096:	7942                	ld	s2,48(sp)
    80002098:	79a2                	ld	s3,40(sp)
    8000209a:	7a02                	ld	s4,32(sp)
    8000209c:	6ae2                	ld	s5,24(sp)
    8000209e:	6b42                	ld	s6,16(sp)
    800020a0:	6ba2                	ld	s7,8(sp)
    800020a2:	6c02                	ld	s8,0(sp)
    800020a4:	6161                	add	sp,sp,80
    800020a6:	8082                	ret

00000000800020a8 <copyin>:
int
copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
  uint64 n, va0, pa0;

  while(len > 0){
    800020a8:	caa5                	beqz	a3,80002118 <copyin+0x70>
{
    800020aa:	715d                	add	sp,sp,-80
    800020ac:	e486                	sd	ra,72(sp)
    800020ae:	e0a2                	sd	s0,64(sp)
    800020b0:	fc26                	sd	s1,56(sp)
    800020b2:	f84a                	sd	s2,48(sp)
    800020b4:	f44e                	sd	s3,40(sp)
    800020b6:	f052                	sd	s4,32(sp)
    800020b8:	ec56                	sd	s5,24(sp)
    800020ba:	e85a                	sd	s6,16(sp)
    800020bc:	e45e                	sd	s7,8(sp)
    800020be:	e062                	sd	s8,0(sp)
    800020c0:	0880                	add	s0,sp,80
    800020c2:	8b2a                	mv	s6,a0
    800020c4:	8a2e                	mv	s4,a1
    800020c6:	8c32                	mv	s8,a2
    800020c8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800020ca:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800020cc:	6a85                	lui	s5,0x1
    800020ce:	a01d                	j	800020f4 <copyin+0x4c>
    if(n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800020d0:	018505b3          	add	a1,a0,s8
    800020d4:	0004861b          	sext.w	a2,s1
    800020d8:	412585b3          	sub	a1,a1,s2
    800020dc:	8552                	mv	a0,s4
    800020de:	fffff097          	auipc	ra,0xfffff
    800020e2:	42e080e7          	jalr	1070(ra) # 8000150c <memmove>

    len -= n;
    800020e6:	409989b3          	sub	s3,s3,s1
    dst += n;
    800020ea:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800020ec:	01590c33          	add	s8,s2,s5
  while(len > 0){
    800020f0:	02098263          	beqz	s3,80002114 <copyin+0x6c>
    va0 = PGROUNDDOWN(srcva);
    800020f4:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    800020f8:	85ca                	mv	a1,s2
    800020fa:	855a                	mv	a0,s6
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	7f2080e7          	jalr	2034(ra) # 800018ee <walkaddr>
    if(pa0 == 0)
    80002104:	cd01                	beqz	a0,8000211c <copyin+0x74>
    n = PGSIZE - (srcva - va0);
    80002106:	418904b3          	sub	s1,s2,s8
    8000210a:	94d6                	add	s1,s1,s5
    if(n > len)
    8000210c:	fc99f2e3          	bgeu	s3,s1,800020d0 <copyin+0x28>
    80002110:	84ce                	mv	s1,s3
    80002112:	bf7d                	j	800020d0 <copyin+0x28>
  }
  return 0;
    80002114:	4501                	li	a0,0
    80002116:	a021                	j	8000211e <copyin+0x76>
    80002118:	4501                	li	a0,0
}
    8000211a:	8082                	ret
      return -1;
    8000211c:	557d                	li	a0,-1
}
    8000211e:	60a6                	ld	ra,72(sp)
    80002120:	6406                	ld	s0,64(sp)
    80002122:	74e2                	ld	s1,56(sp)
    80002124:	7942                	ld	s2,48(sp)
    80002126:	79a2                	ld	s3,40(sp)
    80002128:	7a02                	ld	s4,32(sp)
    8000212a:	6ae2                	ld	s5,24(sp)
    8000212c:	6b42                	ld	s6,16(sp)
    8000212e:	6ba2                	ld	s7,8(sp)
    80002130:	6c02                	ld	s8,0(sp)
    80002132:	6161                	add	sp,sp,80
    80002134:	8082                	ret

0000000080002136 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80002136:	cacd                	beqz	a3,800021e8 <copyinstr+0xb2>
{
    80002138:	715d                	add	sp,sp,-80
    8000213a:	e486                	sd	ra,72(sp)
    8000213c:	e0a2                	sd	s0,64(sp)
    8000213e:	fc26                	sd	s1,56(sp)
    80002140:	f84a                	sd	s2,48(sp)
    80002142:	f44e                	sd	s3,40(sp)
    80002144:	f052                	sd	s4,32(sp)
    80002146:	ec56                	sd	s5,24(sp)
    80002148:	e85a                	sd	s6,16(sp)
    8000214a:	e45e                	sd	s7,8(sp)
    8000214c:	0880                	add	s0,sp,80
    8000214e:	8a2a                	mv	s4,a0
    80002150:	8b2e                	mv	s6,a1
    80002152:	8bb2                	mv	s7,a2
    80002154:	8936                	mv	s2,a3
    va0 = PGROUNDDOWN(srcva);
    80002156:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80002158:	6985                	lui	s3,0x1
    8000215a:	a825                	j	80002192 <copyinstr+0x5c>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    8000215c:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80002160:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80002162:	37fd                	addw	a5,a5,-1
    80002164:	0007851b          	sext.w	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80002168:	60a6                	ld	ra,72(sp)
    8000216a:	6406                	ld	s0,64(sp)
    8000216c:	74e2                	ld	s1,56(sp)
    8000216e:	7942                	ld	s2,48(sp)
    80002170:	79a2                	ld	s3,40(sp)
    80002172:	7a02                	ld	s4,32(sp)
    80002174:	6ae2                	ld	s5,24(sp)
    80002176:	6b42                	ld	s6,16(sp)
    80002178:	6ba2                	ld	s7,8(sp)
    8000217a:	6161                	add	sp,sp,80
    8000217c:	8082                	ret
    8000217e:	fff90713          	add	a4,s2,-1
    80002182:	9742                	add	a4,a4,a6
      --max;
    80002184:	40b70933          	sub	s2,a4,a1
    srcva = va0 + PGSIZE;
    80002188:	01348bb3          	add	s7,s1,s3
  while(got_null == 0 && max > 0){
    8000218c:	04e58663          	beq	a1,a4,800021d8 <copyinstr+0xa2>
{
    80002190:	8b3e                	mv	s6,a5
    va0 = PGROUNDDOWN(srcva);
    80002192:	015bf4b3          	and	s1,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80002196:	85a6                	mv	a1,s1
    80002198:	8552                	mv	a0,s4
    8000219a:	fffff097          	auipc	ra,0xfffff
    8000219e:	754080e7          	jalr	1876(ra) # 800018ee <walkaddr>
    if(pa0 == 0)
    800021a2:	cd0d                	beqz	a0,800021dc <copyinstr+0xa6>
    n = PGSIZE - (srcva - va0);
    800021a4:	417486b3          	sub	a3,s1,s7
    800021a8:	96ce                	add	a3,a3,s3
    if(n > max)
    800021aa:	00d97363          	bgeu	s2,a3,800021b0 <copyinstr+0x7a>
    800021ae:	86ca                	mv	a3,s2
    char *p = (char *) (pa0 + (srcva - va0));
    800021b0:	955e                	add	a0,a0,s7
    800021b2:	8d05                	sub	a0,a0,s1
    while(n > 0){
    800021b4:	c695                	beqz	a3,800021e0 <copyinstr+0xaa>
    800021b6:	87da                	mv	a5,s6
    800021b8:	885a                	mv	a6,s6
      if(*p == '\0'){
    800021ba:	41650633          	sub	a2,a0,s6
    while(n > 0){
    800021be:	96da                	add	a3,a3,s6
    800021c0:	85be                	mv	a1,a5
      if(*p == '\0'){
    800021c2:	00f60733          	add	a4,a2,a5
    800021c6:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffcab30>
    800021ca:	db49                	beqz	a4,8000215c <copyinstr+0x26>
        *dst = *p;
    800021cc:	00e78023          	sb	a4,0(a5)
      dst++;
    800021d0:	0785                	add	a5,a5,1
    while(n > 0){
    800021d2:	fed797e3          	bne	a5,a3,800021c0 <copyinstr+0x8a>
    800021d6:	b765                	j	8000217e <copyinstr+0x48>
    800021d8:	4781                	li	a5,0
    800021da:	b761                	j	80002162 <copyinstr+0x2c>
      return -1;
    800021dc:	557d                	li	a0,-1
    800021de:	b769                	j	80002168 <copyinstr+0x32>
    srcva = va0 + PGSIZE;
    800021e0:	6b85                	lui	s7,0x1
    800021e2:	9ba6                	add	s7,s7,s1
    800021e4:	87da                	mv	a5,s6
    800021e6:	b76d                	j	80002190 <copyinstr+0x5a>
  int got_null = 0;
    800021e8:	4781                	li	a5,0
  if(got_null){
    800021ea:	37fd                	addw	a5,a5,-1
    800021ec:	0007851b          	sext.w	a0,a5
}
    800021f0:	8082                	ret

00000000800021f2 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800021f2:	7139                	add	sp,sp,-64
    800021f4:	fc06                	sd	ra,56(sp)
    800021f6:	f822                	sd	s0,48(sp)
    800021f8:	f426                	sd	s1,40(sp)
    800021fa:	f04a                	sd	s2,32(sp)
    800021fc:	ec4e                	sd	s3,24(sp)
    800021fe:	e852                	sd	s4,16(sp)
    80002200:	e456                	sd	s5,8(sp)
    80002202:	e05a                	sd	s6,0(sp)
    80002204:	0080                	add	s0,sp,64
    80002206:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80002208:	00020497          	auipc	s1,0x20
    8000220c:	cd048493          	add	s1,s1,-816 # 80021ed8 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80002210:	8b26                	mv	s6,s1
    80002212:	ff048937          	lui	s2,0xff048
    80002216:	dc190913          	add	s2,s2,-575 # ffffffffff047dc1 <end+0xffffffff7f0138f1>
    8000221a:	0932                	sll	s2,s2,0xc
    8000221c:	1f790913          	add	s2,s2,503
    80002220:	093e                	sll	s2,s2,0xf
    80002222:	23f90913          	add	s2,s2,575
    80002226:	0932                	sll	s2,s2,0xc
    80002228:	e0990913          	add	s2,s2,-503
    8000222c:	040009b7          	lui	s3,0x4000
    80002230:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80002232:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80002234:	00027a97          	auipc	s5,0x27
    80002238:	ea4a8a93          	add	s5,s5,-348 # 800290d8 <tickslock>
    char *pa = kalloc();
    8000223c:	fffff097          	auipc	ra,0xfffff
    80002240:	dea080e7          	jalr	-534(ra) # 80001026 <kalloc>
    80002244:	862a                	mv	a2,a0
    if(pa == 0)
    80002246:	c121                	beqz	a0,80002286 <proc_mapstacks+0x94>
    uint64 va = KSTACK((int) (p - proc));
    80002248:	416485b3          	sub	a1,s1,s6
    8000224c:	858d                	sra	a1,a1,0x3
    8000224e:	032585b3          	mul	a1,a1,s2
    80002252:	2585                	addw	a1,a1,1
    80002254:	00d5959b          	sllw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80002258:	4719                	li	a4,6
    8000225a:	6685                	lui	a3,0x1
    8000225c:	40b985b3          	sub	a1,s3,a1
    80002260:	8552                	mv	a0,s4
    80002262:	fffff097          	auipc	ra,0xfffff
    80002266:	76e080e7          	jalr	1902(ra) # 800019d0 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000226a:	1c848493          	add	s1,s1,456
    8000226e:	fd5497e3          	bne	s1,s5,8000223c <proc_mapstacks+0x4a>
  }
}
    80002272:	70e2                	ld	ra,56(sp)
    80002274:	7442                	ld	s0,48(sp)
    80002276:	74a2                	ld	s1,40(sp)
    80002278:	7902                	ld	s2,32(sp)
    8000227a:	69e2                	ld	s3,24(sp)
    8000227c:	6a42                	ld	s4,16(sp)
    8000227e:	6aa2                	ld	s5,8(sp)
    80002280:	6b02                	ld	s6,0(sp)
    80002282:	6121                	add	sp,sp,64
    80002284:	8082                	ret
      panic("kalloc");
    80002286:	00007517          	auipc	a0,0x7
    8000228a:	11a50513          	add	a0,a0,282 # 800093a0 <etext+0x3a0>
    8000228e:	ffffe097          	auipc	ra,0xffffe
    80002292:	308080e7          	jalr	776(ra) # 80000596 <panic>

0000000080002296 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80002296:	7139                	add	sp,sp,-64
    80002298:	fc06                	sd	ra,56(sp)
    8000229a:	f822                	sd	s0,48(sp)
    8000229c:	f426                	sd	s1,40(sp)
    8000229e:	f04a                	sd	s2,32(sp)
    800022a0:	ec4e                	sd	s3,24(sp)
    800022a2:	e852                	sd	s4,16(sp)
    800022a4:	e456                	sd	s5,8(sp)
    800022a6:	e05a                	sd	s6,0(sp)
    800022a8:	0080                	add	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    800022aa:	00007597          	auipc	a1,0x7
    800022ae:	0fe58593          	add	a1,a1,254 # 800093a8 <etext+0x3a8>
    800022b2:	0001f517          	auipc	a0,0x1f
    800022b6:	7f650513          	add	a0,a0,2038 # 80021aa8 <pid_lock>
    800022ba:	fffff097          	auipc	ra,0xfffff
    800022be:	06a080e7          	jalr	106(ra) # 80001324 <initlock>
  initlock(&wait_lock, "wait_lock");
    800022c2:	00007597          	auipc	a1,0x7
    800022c6:	0ee58593          	add	a1,a1,238 # 800093b0 <etext+0x3b0>
    800022ca:	0001f517          	auipc	a0,0x1f
    800022ce:	7f650513          	add	a0,a0,2038 # 80021ac0 <wait_lock>
    800022d2:	fffff097          	auipc	ra,0xfffff
    800022d6:	052080e7          	jalr	82(ra) # 80001324 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    800022da:	00020497          	auipc	s1,0x20
    800022de:	bfe48493          	add	s1,s1,-1026 # 80021ed8 <proc>
      initlock(&p->lock, "proc");
    800022e2:	00007b17          	auipc	s6,0x7
    800022e6:	0deb0b13          	add	s6,s6,222 # 800093c0 <etext+0x3c0>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800022ea:	8aa6                	mv	s5,s1
    800022ec:	ff048937          	lui	s2,0xff048
    800022f0:	dc190913          	add	s2,s2,-575 # ffffffffff047dc1 <end+0xffffffff7f0138f1>
    800022f4:	0932                	sll	s2,s2,0xc
    800022f6:	1f790913          	add	s2,s2,503
    800022fa:	093e                	sll	s2,s2,0xf
    800022fc:	23f90913          	add	s2,s2,575
    80002300:	0932                	sll	s2,s2,0xc
    80002302:	e0990913          	add	s2,s2,-503
    80002306:	040009b7          	lui	s3,0x4000
    8000230a:	19fd                	add	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    8000230c:	09b2                	sll	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    8000230e:	00027a17          	auipc	s4,0x27
    80002312:	dcaa0a13          	add	s4,s4,-566 # 800290d8 <tickslock>
      initlock(&p->lock, "proc");
    80002316:	85da                	mv	a1,s6
    80002318:	8526                	mv	a0,s1
    8000231a:	fffff097          	auipc	ra,0xfffff
    8000231e:	00a080e7          	jalr	10(ra) # 80001324 <initlock>
      p->state = UNUSED;
    80002322:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80002326:	415487b3          	sub	a5,s1,s5
    8000232a:	878d                	sra	a5,a5,0x3
    8000232c:	032787b3          	mul	a5,a5,s2
    80002330:	2785                	addw	a5,a5,1
    80002332:	00d7979b          	sllw	a5,a5,0xd
    80002336:	40f987b3          	sub	a5,s3,a5
    8000233a:	f0dc                	sd	a5,160(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    8000233c:	1c848493          	add	s1,s1,456
    80002340:	fd449be3          	bne	s1,s4,80002316 <procinit+0x80>
  }
}
    80002344:	70e2                	ld	ra,56(sp)
    80002346:	7442                	ld	s0,48(sp)
    80002348:	74a2                	ld	s1,40(sp)
    8000234a:	7902                	ld	s2,32(sp)
    8000234c:	69e2                	ld	s3,24(sp)
    8000234e:	6a42                	ld	s4,16(sp)
    80002350:	6aa2                	ld	s5,8(sp)
    80002352:	6b02                	ld	s6,0(sp)
    80002354:	6121                	add	sp,sp,64
    80002356:	8082                	ret

0000000080002358 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80002358:	1141                	add	sp,sp,-16
    8000235a:	e422                	sd	s0,8(sp)
    8000235c:	0800                	add	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    8000235e:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80002360:	2501                	sext.w	a0,a0
    80002362:	6422                	ld	s0,8(sp)
    80002364:	0141                	add	sp,sp,16
    80002366:	8082                	ret

0000000080002368 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80002368:	1141                	add	sp,sp,-16
    8000236a:	e422                	sd	s0,8(sp)
    8000236c:	0800                	add	s0,sp,16
    8000236e:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80002370:	2781                	sext.w	a5,a5
    80002372:	079e                	sll	a5,a5,0x7
  return c;
}
    80002374:	0001f517          	auipc	a0,0x1f
    80002378:	76450513          	add	a0,a0,1892 # 80021ad8 <cpus>
    8000237c:	953e                	add	a0,a0,a5
    8000237e:	6422                	ld	s0,8(sp)
    80002380:	0141                	add	sp,sp,16
    80002382:	8082                	ret

0000000080002384 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80002384:	1101                	add	sp,sp,-32
    80002386:	ec06                	sd	ra,24(sp)
    80002388:	e822                	sd	s0,16(sp)
    8000238a:	e426                	sd	s1,8(sp)
    8000238c:	1000                	add	s0,sp,32
  push_off();
    8000238e:	fffff097          	auipc	ra,0xfffff
    80002392:	fda080e7          	jalr	-38(ra) # 80001368 <push_off>
    80002396:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80002398:	2781                	sext.w	a5,a5
    8000239a:	079e                	sll	a5,a5,0x7
    8000239c:	0001f717          	auipc	a4,0x1f
    800023a0:	70c70713          	add	a4,a4,1804 # 80021aa8 <pid_lock>
    800023a4:	97ba                	add	a5,a5,a4
    800023a6:	7b84                	ld	s1,48(a5)
  pop_off();
    800023a8:	fffff097          	auipc	ra,0xfffff
    800023ac:	060080e7          	jalr	96(ra) # 80001408 <pop_off>
  return p;
}
    800023b0:	8526                	mv	a0,s1
    800023b2:	60e2                	ld	ra,24(sp)
    800023b4:	6442                	ld	s0,16(sp)
    800023b6:	64a2                	ld	s1,8(sp)
    800023b8:	6105                	add	sp,sp,32
    800023ba:	8082                	ret

00000000800023bc <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    800023bc:	1141                	add	sp,sp,-16
    800023be:	e406                	sd	ra,8(sp)
    800023c0:	e022                	sd	s0,0(sp)
    800023c2:	0800                	add	s0,sp,16
  static int first = 1;

  // Still holding p->lock from scheduler.
  release(&myproc()->lock);
    800023c4:	00000097          	auipc	ra,0x0
    800023c8:	fc0080e7          	jalr	-64(ra) # 80002384 <myproc>
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	09c080e7          	jalr	156(ra) # 80001468 <release>

  if (first) {
    800023d4:	00007797          	auipc	a5,0x7
    800023d8:	70c7a783          	lw	a5,1804(a5) # 80009ae0 <first.1>
    800023dc:	eb89                	bnez	a5,800023ee <forkret+0x32>
    // be run from main().
    first = 0;
    fsinit(ROOTDEV);
  }

  usertrapret();
    800023de:	00001097          	auipc	ra,0x1
    800023e2:	6d2080e7          	jalr	1746(ra) # 80003ab0 <usertrapret>
}
    800023e6:	60a2                	ld	ra,8(sp)
    800023e8:	6402                	ld	s0,0(sp)
    800023ea:	0141                	add	sp,sp,16
    800023ec:	8082                	ret
    first = 0;
    800023ee:	00007797          	auipc	a5,0x7
    800023f2:	6e07a923          	sw	zero,1778(a5) # 80009ae0 <first.1>
    fsinit(ROOTDEV);
    800023f6:	4505                	li	a0,1
    800023f8:	00002097          	auipc	ra,0x2
    800023fc:	79e080e7          	jalr	1950(ra) # 80004b96 <fsinit>
    80002400:	bff9                	j	800023de <forkret+0x22>

0000000080002402 <allocpid>:
{
    80002402:	1101                	add	sp,sp,-32
    80002404:	ec06                	sd	ra,24(sp)
    80002406:	e822                	sd	s0,16(sp)
    80002408:	e426                	sd	s1,8(sp)
    8000240a:	e04a                	sd	s2,0(sp)
    8000240c:	1000                	add	s0,sp,32
  acquire(&pid_lock);
    8000240e:	0001f917          	auipc	s2,0x1f
    80002412:	69a90913          	add	s2,s2,1690 # 80021aa8 <pid_lock>
    80002416:	854a                	mv	a0,s2
    80002418:	fffff097          	auipc	ra,0xfffff
    8000241c:	f9c080e7          	jalr	-100(ra) # 800013b4 <acquire>
  pid = nextpid;
    80002420:	00007797          	auipc	a5,0x7
    80002424:	6c478793          	add	a5,a5,1732 # 80009ae4 <nextpid>
    80002428:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000242a:	0014871b          	addw	a4,s1,1
    8000242e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80002430:	854a                	mv	a0,s2
    80002432:	fffff097          	auipc	ra,0xfffff
    80002436:	036080e7          	jalr	54(ra) # 80001468 <release>
}
    8000243a:	8526                	mv	a0,s1
    8000243c:	60e2                	ld	ra,24(sp)
    8000243e:	6442                	ld	s0,16(sp)
    80002440:	64a2                	ld	s1,8(sp)
    80002442:	6902                	ld	s2,0(sp)
    80002444:	6105                	add	sp,sp,32
    80002446:	8082                	ret

0000000080002448 <proc_pagetable>:
{
    80002448:	1101                	add	sp,sp,-32
    8000244a:	ec06                	sd	ra,24(sp)
    8000244c:	e822                	sd	s0,16(sp)
    8000244e:	e426                	sd	s1,8(sp)
    80002450:	e04a                	sd	s2,0(sp)
    80002452:	1000                	add	s0,sp,32
    80002454:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80002456:	00000097          	auipc	ra,0x0
    8000245a:	82c080e7          	jalr	-2004(ra) # 80001c82 <uvmcreate>
    8000245e:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80002460:	c121                	beqz	a0,800024a0 <proc_pagetable+0x58>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80002462:	4729                	li	a4,10
    80002464:	00006697          	auipc	a3,0x6
    80002468:	b9c68693          	add	a3,a3,-1124 # 80008000 <_trampoline>
    8000246c:	6605                	lui	a2,0x1
    8000246e:	040005b7          	lui	a1,0x4000
    80002472:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002474:	05b2                	sll	a1,a1,0xc
    80002476:	fffff097          	auipc	ra,0xfffff
    8000247a:	4ba080e7          	jalr	1210(ra) # 80001930 <mappages>
    8000247e:	02054863          	bltz	a0,800024ae <proc_pagetable+0x66>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80002482:	4719                	li	a4,6
    80002484:	0b893683          	ld	a3,184(s2)
    80002488:	6605                	lui	a2,0x1
    8000248a:	020005b7          	lui	a1,0x2000
    8000248e:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002490:	05b6                	sll	a1,a1,0xd
    80002492:	8526                	mv	a0,s1
    80002494:	fffff097          	auipc	ra,0xfffff
    80002498:	49c080e7          	jalr	1180(ra) # 80001930 <mappages>
    8000249c:	02054163          	bltz	a0,800024be <proc_pagetable+0x76>
}
    800024a0:	8526                	mv	a0,s1
    800024a2:	60e2                	ld	ra,24(sp)
    800024a4:	6442                	ld	s0,16(sp)
    800024a6:	64a2                	ld	s1,8(sp)
    800024a8:	6902                	ld	s2,0(sp)
    800024aa:	6105                	add	sp,sp,32
    800024ac:	8082                	ret
    uvmfree(pagetable, 0);
    800024ae:	4581                	li	a1,0
    800024b0:	8526                	mv	a0,s1
    800024b2:	00000097          	auipc	ra,0x0
    800024b6:	a2c080e7          	jalr	-1492(ra) # 80001ede <uvmfree>
    return 0;
    800024ba:	4481                	li	s1,0
    800024bc:	b7d5                	j	800024a0 <proc_pagetable+0x58>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800024be:	4681                	li	a3,0
    800024c0:	4605                	li	a2,1
    800024c2:	040005b7          	lui	a1,0x4000
    800024c6:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800024c8:	05b2                	sll	a1,a1,0xc
    800024ca:	8526                	mv	a0,s1
    800024cc:	fffff097          	auipc	ra,0xfffff
    800024d0:	62a080e7          	jalr	1578(ra) # 80001af6 <uvmunmap>
    uvmfree(pagetable, 0);
    800024d4:	4581                	li	a1,0
    800024d6:	8526                	mv	a0,s1
    800024d8:	00000097          	auipc	ra,0x0
    800024dc:	a06080e7          	jalr	-1530(ra) # 80001ede <uvmfree>
    return 0;
    800024e0:	4481                	li	s1,0
    800024e2:	bf7d                	j	800024a0 <proc_pagetable+0x58>

00000000800024e4 <proc_freepagetable>:
{
    800024e4:	711d                	add	sp,sp,-96
    800024e6:	ec86                	sd	ra,88(sp)
    800024e8:	e8a2                	sd	s0,80(sp)
    800024ea:	e4a6                	sd	s1,72(sp)
    800024ec:	e0ca                	sd	s2,64(sp)
    800024ee:	fc4e                	sd	s3,56(sp)
    800024f0:	f852                	sd	s4,48(sp)
    800024f2:	f456                	sd	s5,40(sp)
    800024f4:	f05a                	sd	s6,32(sp)
    800024f6:	ec5e                	sd	s7,24(sp)
    800024f8:	e862                	sd	s8,16(sp)
    800024fa:	e466                	sd	s9,8(sp)
    800024fc:	e06a                	sd	s10,0(sp)
    800024fe:	1080                	add	s0,sp,96
    80002500:	8aaa                	mv	s5,a0
    80002502:	8d2e                	mv	s10,a1
    80002504:	8bb2                	mv	s7,a2
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80002506:	4681                	li	a3,0
    80002508:	4605                	li	a2,1
    8000250a:	040005b7          	lui	a1,0x4000
    8000250e:	15fd                	add	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80002510:	05b2                	sll	a1,a1,0xc
    80002512:	fffff097          	auipc	ra,0xfffff
    80002516:	5e4080e7          	jalr	1508(ra) # 80001af6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000251a:	4681                	li	a3,0
    8000251c:	4605                	li	a2,1
    8000251e:	020005b7          	lui	a1,0x2000
    80002522:	15fd                	add	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80002524:	05b6                	sll	a1,a1,0xd
    80002526:	8556                	mv	a0,s5
    80002528:	fffff097          	auipc	ra,0xfffff
    8000252c:	5ce080e7          	jalr	1486(ra) # 80001af6 <uvmunmap>
  for(int i=0; i<12; i+=3)
    80002530:	038b8993          	add	s3,s7,56 # 1038 <_entry-0x7fffefc8>
    80002534:	098b8b93          	add	s7,s7,152
    80002538:	a005                	j	80002558 <proc_freepagetable+0x74>
        for(a = addr; a < addr + length; a += PGSIZE){
    8000253a:	00c90a33          	add	s4,s2,a2
          if(PTE_FLAGS(*pte) == PTE_V)
    8000253e:	4c85                	li	s9,1
        for(a = addr; a < addr + length; a += PGSIZE){
    80002540:	6b05                	lui	s6,0x1
    80002542:	05496b63          	bltu	s2,s4,80002598 <proc_freepagetable+0xb4>
      p->mmap_list[i] = 0;
    80002546:	000c3023          	sd	zero,0(s8)
      p->mmap_list[i+1] = 0;
    8000254a:	000c3423          	sd	zero,8(s8)
      p->mmap_list[i+2] = 0;
    8000254e:	000c3823          	sd	zero,16(s8)
  for(int i=0; i<12; i+=3)
    80002552:	09e1                	add	s3,s3,24
    80002554:	07798c63          	beq	s3,s7,800025cc <proc_freepagetable+0xe8>
    uint64 addr = p->mmap_list[i];
    80002558:	8c4e                	mv	s8,s3
    8000255a:	0009b903          	ld	s2,0(s3)
    uint64 length = p->mmap_list[i+1];
    8000255e:	0089b603          	ld	a2,8(s3)
    if(addr !=0)
    80002562:	fe0908e3          	beqz	s2,80002552 <proc_freepagetable+0x6e>
      if ((p->mmap_list[i+2]) & HUGE_MASK)
    80002566:	0109b783          	ld	a5,16(s3)
    8000256a:	1007f793          	and	a5,a5,256
    8000256e:	d7f1                	beqz	a5,8000253a <proc_freepagetable+0x56>
        uvmunmap_huge(pagetable,addr,length/HUGEPGSIZE,1);
    80002570:	4685                	li	a3,1
    80002572:	8255                	srl	a2,a2,0x15
    80002574:	85ca                	mv	a1,s2
    80002576:	8556                	mv	a0,s5
    80002578:	fffff097          	auipc	ra,0xfffff
    8000257c:	652080e7          	jalr	1618(ra) # 80001bca <uvmunmap_huge>
    80002580:	b7d9                	j	80002546 <proc_freepagetable+0x62>
            panic("munmap: not a leaf");
    80002582:	00007517          	auipc	a0,0x7
    80002586:	e4650513          	add	a0,a0,-442 # 800093c8 <etext+0x3c8>
    8000258a:	ffffe097          	auipc	ra,0xffffe
    8000258e:	00c080e7          	jalr	12(ra) # 80000596 <panic>
        for(a = addr; a < addr + length; a += PGSIZE){
    80002592:	995a                	add	s2,s2,s6
    80002594:	fb4979e3          	bgeu	s2,s4,80002546 <proc_freepagetable+0x62>
          if((pte = walk(pagetable, a, 0)) == 0)
    80002598:	4601                	li	a2,0
    8000259a:	85ca                	mv	a1,s2
    8000259c:	8556                	mv	a0,s5
    8000259e:	fffff097          	auipc	ra,0xfffff
    800025a2:	1fa080e7          	jalr	506(ra) # 80001798 <walk>
    800025a6:	84aa                	mv	s1,a0
    800025a8:	d56d                	beqz	a0,80002592 <proc_freepagetable+0xae>
          if((*pte & PTE_V) == 0)
    800025aa:	6108                	ld	a0,0(a0)
    800025ac:	00157793          	and	a5,a0,1
    800025b0:	d3ed                	beqz	a5,80002592 <proc_freepagetable+0xae>
          if(PTE_FLAGS(*pte) == PTE_V)
    800025b2:	3ff57793          	and	a5,a0,1023
    800025b6:	fd9786e3          	beq	a5,s9,80002582 <proc_freepagetable+0x9e>
          uint64 pa = PTE2PA(*pte);
    800025ba:	8129                	srl	a0,a0,0xa
          kfree((void*)pa);
    800025bc:	0532                	sll	a0,a0,0xc
    800025be:	fffff097          	auipc	ra,0xfffff
    800025c2:	80a080e7          	jalr	-2038(ra) # 80000dc8 <kfree>
          *pte = 0;
    800025c6:	0004b023          	sd	zero,0(s1)
    800025ca:	b7e1                	j	80002592 <proc_freepagetable+0xae>
  uvmfree(pagetable, sz);
    800025cc:	85ea                	mv	a1,s10
    800025ce:	8556                	mv	a0,s5
    800025d0:	00000097          	auipc	ra,0x0
    800025d4:	90e080e7          	jalr	-1778(ra) # 80001ede <uvmfree>
}
    800025d8:	60e6                	ld	ra,88(sp)
    800025da:	6446                	ld	s0,80(sp)
    800025dc:	64a6                	ld	s1,72(sp)
    800025de:	6906                	ld	s2,64(sp)
    800025e0:	79e2                	ld	s3,56(sp)
    800025e2:	7a42                	ld	s4,48(sp)
    800025e4:	7aa2                	ld	s5,40(sp)
    800025e6:	7b02                	ld	s6,32(sp)
    800025e8:	6be2                	ld	s7,24(sp)
    800025ea:	6c42                	ld	s8,16(sp)
    800025ec:	6ca2                	ld	s9,8(sp)
    800025ee:	6d02                	ld	s10,0(sp)
    800025f0:	6125                	add	sp,sp,96
    800025f2:	8082                	ret

00000000800025f4 <freeproc>:
{
    800025f4:	1101                	add	sp,sp,-32
    800025f6:	ec06                	sd	ra,24(sp)
    800025f8:	e822                	sd	s0,16(sp)
    800025fa:	e426                	sd	s1,8(sp)
    800025fc:	1000                	add	s0,sp,32
    800025fe:	84aa                	mv	s1,a0
  if(p->trapframe)
    80002600:	7d48                	ld	a0,184(a0)
    80002602:	c509                	beqz	a0,8000260c <freeproc+0x18>
    kfree((void*)p->trapframe);
    80002604:	ffffe097          	auipc	ra,0xffffe
    80002608:	7c4080e7          	jalr	1988(ra) # 80000dc8 <kfree>
  p->trapframe = 0;
    8000260c:	0a04bc23          	sd	zero,184(s1)
  if(p->pagetable)
    80002610:	78c8                	ld	a0,176(s1)
    80002612:	c519                	beqz	a0,80002620 <freeproc+0x2c>
    proc_freepagetable(p->pagetable, p->sz, p);
    80002614:	8626                	mv	a2,s1
    80002616:	74cc                	ld	a1,168(s1)
    80002618:	00000097          	auipc	ra,0x0
    8000261c:	ecc080e7          	jalr	-308(ra) # 800024e4 <proc_freepagetable>
  p->pagetable = 0;
    80002620:	0a04b823          	sd	zero,176(s1)
  p->sz = 0;
    80002624:	0a04b423          	sd	zero,168(s1)
  p->pid = 0;
    80002628:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000262c:	0804bc23          	sd	zero,152(s1)
  p->name[0] = 0;
    80002630:	1a048c23          	sb	zero,440(s1)
  p->chan = 0;
    80002634:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80002638:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000263c:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80002640:	0004ac23          	sw	zero,24(s1)
}
    80002644:	60e2                	ld	ra,24(sp)
    80002646:	6442                	ld	s0,16(sp)
    80002648:	64a2                	ld	s1,8(sp)
    8000264a:	6105                	add	sp,sp,32
    8000264c:	8082                	ret

000000008000264e <allocproc>:
{
    8000264e:	1101                	add	sp,sp,-32
    80002650:	ec06                	sd	ra,24(sp)
    80002652:	e822                	sd	s0,16(sp)
    80002654:	e426                	sd	s1,8(sp)
    80002656:	e04a                	sd	s2,0(sp)
    80002658:	1000                	add	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000265a:	00020497          	auipc	s1,0x20
    8000265e:	87e48493          	add	s1,s1,-1922 # 80021ed8 <proc>
    80002662:	00027917          	auipc	s2,0x27
    80002666:	a7690913          	add	s2,s2,-1418 # 800290d8 <tickslock>
    acquire(&p->lock);
    8000266a:	8526                	mv	a0,s1
    8000266c:	fffff097          	auipc	ra,0xfffff
    80002670:	d48080e7          	jalr	-696(ra) # 800013b4 <acquire>
    if(p->state == UNUSED) {
    80002674:	4c9c                	lw	a5,24(s1)
    80002676:	cf81                	beqz	a5,8000268e <allocproc+0x40>
      release(&p->lock);
    80002678:	8526                	mv	a0,s1
    8000267a:	fffff097          	auipc	ra,0xfffff
    8000267e:	dee080e7          	jalr	-530(ra) # 80001468 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80002682:	1c848493          	add	s1,s1,456
    80002686:	ff2492e3          	bne	s1,s2,8000266a <allocproc+0x1c>
  return 0;
    8000268a:	4481                	li	s1,0
    8000268c:	a889                	j	800026de <allocproc+0x90>
  p->pid = allocpid();
    8000268e:	00000097          	auipc	ra,0x0
    80002692:	d74080e7          	jalr	-652(ra) # 80002402 <allocpid>
    80002696:	d888                	sw	a0,48(s1)
  p->state = USED;
    80002698:	4785                	li	a5,1
    8000269a:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    8000269c:	fffff097          	auipc	ra,0xfffff
    800026a0:	98a080e7          	jalr	-1654(ra) # 80001026 <kalloc>
    800026a4:	892a                	mv	s2,a0
    800026a6:	fcc8                	sd	a0,184(s1)
    800026a8:	c131                	beqz	a0,800026ec <allocproc+0x9e>
  p->pagetable = proc_pagetable(p);
    800026aa:	8526                	mv	a0,s1
    800026ac:	00000097          	auipc	ra,0x0
    800026b0:	d9c080e7          	jalr	-612(ra) # 80002448 <proc_pagetable>
    800026b4:	892a                	mv	s2,a0
    800026b6:	f8c8                	sd	a0,176(s1)
  if(p->pagetable == 0){
    800026b8:	c531                	beqz	a0,80002704 <allocproc+0xb6>
  memset(&p->context, 0, sizeof(p->context));
    800026ba:	07000613          	li	a2,112
    800026be:	4581                	li	a1,0
    800026c0:	0c048513          	add	a0,s1,192
    800026c4:	fffff097          	auipc	ra,0xfffff
    800026c8:	dec080e7          	jalr	-532(ra) # 800014b0 <memset>
  p->context.ra = (uint64)forkret;
    800026cc:	00000797          	auipc	a5,0x0
    800026d0:	cf078793          	add	a5,a5,-784 # 800023bc <forkret>
    800026d4:	e0fc                	sd	a5,192(s1)
  p->context.sp = p->kstack + PGSIZE;
    800026d6:	70dc                	ld	a5,160(s1)
    800026d8:	6705                	lui	a4,0x1
    800026da:	97ba                	add	a5,a5,a4
    800026dc:	e4fc                	sd	a5,200(s1)
}
    800026de:	8526                	mv	a0,s1
    800026e0:	60e2                	ld	ra,24(sp)
    800026e2:	6442                	ld	s0,16(sp)
    800026e4:	64a2                	ld	s1,8(sp)
    800026e6:	6902                	ld	s2,0(sp)
    800026e8:	6105                	add	sp,sp,32
    800026ea:	8082                	ret
    freeproc(p);
    800026ec:	8526                	mv	a0,s1
    800026ee:	00000097          	auipc	ra,0x0
    800026f2:	f06080e7          	jalr	-250(ra) # 800025f4 <freeproc>
    release(&p->lock);
    800026f6:	8526                	mv	a0,s1
    800026f8:	fffff097          	auipc	ra,0xfffff
    800026fc:	d70080e7          	jalr	-656(ra) # 80001468 <release>
    return 0;
    80002700:	84ca                	mv	s1,s2
    80002702:	bff1                	j	800026de <allocproc+0x90>
    freeproc(p);
    80002704:	8526                	mv	a0,s1
    80002706:	00000097          	auipc	ra,0x0
    8000270a:	eee080e7          	jalr	-274(ra) # 800025f4 <freeproc>
    release(&p->lock);
    8000270e:	8526                	mv	a0,s1
    80002710:	fffff097          	auipc	ra,0xfffff
    80002714:	d58080e7          	jalr	-680(ra) # 80001468 <release>
    return 0;
    80002718:	84ca                	mv	s1,s2
    8000271a:	b7d1                	j	800026de <allocproc+0x90>

000000008000271c <userinit>:
{
    8000271c:	1101                	add	sp,sp,-32
    8000271e:	ec06                	sd	ra,24(sp)
    80002720:	e822                	sd	s0,16(sp)
    80002722:	e426                	sd	s1,8(sp)
    80002724:	1000                	add	s0,sp,32
  p = allocproc();
    80002726:	00000097          	auipc	ra,0x0
    8000272a:	f28080e7          	jalr	-216(ra) # 8000264e <allocproc>
    8000272e:	84aa                	mv	s1,a0
  initproc = p;
    80002730:	00007797          	auipc	a5,0x7
    80002734:	44a7b423          	sd	a0,1096(a5) # 80009b78 <initproc>
  uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80002738:	03400613          	li	a2,52
    8000273c:	00007597          	auipc	a1,0x7
    80002740:	3b458593          	add	a1,a1,948 # 80009af0 <initcode>
    80002744:	7948                	ld	a0,176(a0)
    80002746:	fffff097          	auipc	ra,0xfffff
    8000274a:	56a080e7          	jalr	1386(ra) # 80001cb0 <uvmfirst>
  p->sz = PGSIZE;
    8000274e:	6785                	lui	a5,0x1
    80002750:	f4dc                	sd	a5,168(s1)
  p->trapframe->epc = 0;      // user program counter
    80002752:	7cd8                	ld	a4,184(s1)
    80002754:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->trapframe->sp = PGSIZE;  // user stack pointer
    80002758:	7cd8                	ld	a4,184(s1)
    8000275a:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    8000275c:	4641                	li	a2,16
    8000275e:	00007597          	auipc	a1,0x7
    80002762:	c8258593          	add	a1,a1,-894 # 800093e0 <etext+0x3e0>
    80002766:	1b848513          	add	a0,s1,440
    8000276a:	fffff097          	auipc	ra,0xfffff
    8000276e:	e88080e7          	jalr	-376(ra) # 800015f2 <safestrcpy>
  p->cwd = namei("/");
    80002772:	00007517          	auipc	a0,0x7
    80002776:	c7e50513          	add	a0,a0,-898 # 800093f0 <etext+0x3f0>
    8000277a:	00003097          	auipc	ra,0x3
    8000277e:	e6e080e7          	jalr	-402(ra) # 800055e8 <namei>
    80002782:	1aa4b823          	sd	a0,432(s1)
  p->state = RUNNABLE;
    80002786:	478d                	li	a5,3
    80002788:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000278a:	8526                	mv	a0,s1
    8000278c:	fffff097          	auipc	ra,0xfffff
    80002790:	cdc080e7          	jalr	-804(ra) # 80001468 <release>
}
    80002794:	60e2                	ld	ra,24(sp)
    80002796:	6442                	ld	s0,16(sp)
    80002798:	64a2                	ld	s1,8(sp)
    8000279a:	6105                	add	sp,sp,32
    8000279c:	8082                	ret

000000008000279e <growproc>:
{
    8000279e:	1101                	add	sp,sp,-32
    800027a0:	ec06                	sd	ra,24(sp)
    800027a2:	e822                	sd	s0,16(sp)
    800027a4:	e426                	sd	s1,8(sp)
    800027a6:	e04a                	sd	s2,0(sp)
    800027a8:	1000                	add	s0,sp,32
    800027aa:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	bd8080e7          	jalr	-1064(ra) # 80002384 <myproc>
    800027b4:	84aa                	mv	s1,a0
  sz = p->sz;
    800027b6:	754c                	ld	a1,168(a0)
  if(n > 0){
    800027b8:	01204c63          	bgtz	s2,800027d0 <growproc+0x32>
  } else if(n < 0){
    800027bc:	02094663          	bltz	s2,800027e8 <growproc+0x4a>
  p->sz = sz;
    800027c0:	f4cc                	sd	a1,168(s1)
  return 0;
    800027c2:	4501                	li	a0,0
}
    800027c4:	60e2                	ld	ra,24(sp)
    800027c6:	6442                	ld	s0,16(sp)
    800027c8:	64a2                	ld	s1,8(sp)
    800027ca:	6902                	ld	s2,0(sp)
    800027cc:	6105                	add	sp,sp,32
    800027ce:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800027d0:	4691                	li	a3,4
    800027d2:	00b90633          	add	a2,s2,a1
    800027d6:	7948                	ld	a0,176(a0)
    800027d8:	fffff097          	auipc	ra,0xfffff
    800027dc:	592080e7          	jalr	1426(ra) # 80001d6a <uvmalloc>
    800027e0:	85aa                	mv	a1,a0
    800027e2:	fd79                	bnez	a0,800027c0 <growproc+0x22>
      return -1;
    800027e4:	557d                	li	a0,-1
    800027e6:	bff9                	j	800027c4 <growproc+0x26>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800027e8:	00b90633          	add	a2,s2,a1
    800027ec:	7948                	ld	a0,176(a0)
    800027ee:	fffff097          	auipc	ra,0xfffff
    800027f2:	534080e7          	jalr	1332(ra) # 80001d22 <uvmdealloc>
    800027f6:	85aa                	mv	a1,a0
    800027f8:	b7e1                	j	800027c0 <growproc+0x22>

00000000800027fa <create_pte_flag>:
{
    800027fa:	1141                	add	sp,sp,-16
    800027fc:	e422                	sd	s0,8(sp)
    800027fe:	0800                	add	s0,sp,16
  if((m_flags & PROT_MASK) == PROT_READ)
    80002800:	00f57693          	and	a3,a0,15
    80002804:	4785                	li	a5,1
    flags +=6;
    80002806:	471d                	li	a4,7
  if((m_flags & PROT_MASK) == PROT_READ)
    80002808:	02f68a63          	beq	a3,a5,8000283c <create_pte_flag+0x42>
  if((m_flags & FLAG_MASK) == MAP_PRIVATE)
    8000280c:	0f057513          	and	a0,a0,240
    80002810:	4841                	li	a6,16
    flags += 256;
    80002812:	11070793          	add	a5,a4,272
  if((m_flags & FLAG_MASK) == MAP_PRIVATE)
    80002816:	01050463          	beq	a0,a6,8000281e <create_pte_flag+0x24>
  flags += 16;
    8000281a:	01070793          	add	a5,a4,16
  if(isSharedNotMapped)
    8000281e:	c199                	beqz	a1,80002824 <create_pte_flag+0x2a>
    flags += 512;
    80002820:	1ff7879b          	addw	a5,a5,511 # 11ff <_entry-0x7fffee01>
  if(is_cow_private)
    80002824:	c611                	beqz	a2,80002830 <create_pte_flag+0x36>
    if((m_flags & PROT_MASK) == PROT_WRITE)
    80002826:	4709                	li	a4,2
    80002828:	00e68c63          	beq	a3,a4,80002840 <create_pte_flag+0x46>
    flags += 512;
    8000282c:	2007879b          	addw	a5,a5,512
}
    80002830:	02079513          	sll	a0,a5,0x20
    80002834:	9101                	srl	a0,a0,0x20
    80002836:	6422                	ld	s0,8(sp)
    80002838:	0141                	add	sp,sp,16
    8000283a:	8082                	ret
    flags +=2;
    8000283c:	470d                	li	a4,3
    8000283e:	b7f9                	j	8000280c <create_pte_flag+0x12>
      flags -= 4;
    80002840:	1fc7879b          	addw	a5,a5,508
    80002844:	b7f5                	j	80002830 <create_pte_flag+0x36>

0000000080002846 <fork>:
{
    80002846:	7175                	add	sp,sp,-144
    80002848:	e506                	sd	ra,136(sp)
    8000284a:	e122                	sd	s0,128(sp)
    8000284c:	f8ca                	sd	s2,112(sp)
    8000284e:	f0d2                	sd	s4,96(sp)
    80002850:	0900                	add	s0,sp,144
  struct proc *p = myproc();
    80002852:	00000097          	auipc	ra,0x0
    80002856:	b32080e7          	jalr	-1230(ra) # 80002384 <myproc>
    8000285a:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	df2080e7          	jalr	-526(ra) # 8000264e <allocproc>
    80002864:	5c050663          	beqz	a0,80002e30 <fork+0x5ea>
    80002868:	f4ce                	sd	s3,104(sp)
    8000286a:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000286c:	0a893603          	ld	a2,168(s2)
    80002870:	794c                	ld	a1,176(a0)
    80002872:	0b093503          	ld	a0,176(s2)
    80002876:	fffff097          	auipc	ra,0xfffff
    8000287a:	6a2080e7          	jalr	1698(ra) # 80001f18 <uvmcopy>
    8000287e:	02054863          	bltz	a0,800028ae <fork+0x68>
    80002882:	fca6                	sd	s1,120(sp)
    80002884:	ecd6                	sd	s5,88(sp)
    80002886:	e8da                	sd	s6,80(sp)
    80002888:	e4de                	sd	s7,72(sp)
    8000288a:	e0e2                	sd	s8,64(sp)
    8000288c:	fc66                	sd	s9,56(sp)
    8000288e:	f86a                	sd	s10,48(sp)
    80002890:	f46e                	sd	s11,40(sp)
  np->sz = p->sz;
    80002892:	0a893783          	ld	a5,168(s2)
    80002896:	0af9b423          	sd	a5,168(s3)
  for(int i=0; i<12; i+=3)
    8000289a:	03890a93          	add	s5,s2,56
    8000289e:	03898d13          	add	s10,s3,56
    800028a2:	09890793          	add	a5,s2,152
    800028a6:	f8f43023          	sd	a5,-128(s0)
          if(PTE_FLAGS(*pte) == PTE_V)
    800028aa:	4c85                	li	s9,1
    800028ac:	ac3d                	j	80002aea <fork+0x2a4>
    freeproc(np);
    800028ae:	854e                	mv	a0,s3
    800028b0:	00000097          	auipc	ra,0x0
    800028b4:	d44080e7          	jalr	-700(ra) # 800025f4 <freeproc>
    release(&np->lock);
    800028b8:	854e                	mv	a0,s3
    800028ba:	fffff097          	auipc	ra,0xfffff
    800028be:	bae080e7          	jalr	-1106(ra) # 80001468 <release>
    return -1;
    800028c2:	5a7d                	li	s4,-1
    800028c4:	79a6                	ld	s3,104(sp)
    800028c6:	abb1                	j	80002e22 <fork+0x5dc>
        for(a = addr; a < addr + length; a += HUGEPGSIZE)
    800028c8:	9c26                	add	s8,s8,s1
    800028ca:	0984ea63          	bltu	s1,s8,8000295e <fork+0x118>
    800028ce:	ac01                	j	80002ade <fork+0x298>
            pte = walk_huge(p->pagetable,a,1);
    800028d0:	4605                	li	a2,1
    800028d2:	85a6                	mv	a1,s1
    800028d4:	0b093503          	ld	a0,176(s2)
    800028d8:	fffff097          	auipc	ra,0xfffff
    800028dc:	f66080e7          	jalr	-154(ra) # 8000183e <walk_huge>
    800028e0:	8a2a                	mv	s4,a0
    800028e2:	a841                	j	80002972 <fork+0x12c>
            *pte = create_pte_flag(flags,1,0);
    800028e4:	4601                	li	a2,0
    800028e6:	85e6                	mv	a1,s9
    800028e8:	856e                	mv	a0,s11
    800028ea:	00000097          	auipc	ra,0x0
    800028ee:	f10080e7          	jalr	-240(ra) # 800027fa <create_pte_flag>
    800028f2:	00aa3023          	sd	a0,0(s4)
            pte_t* new_pte = walk_huge(np->pagetable,a,1);
    800028f6:	8666                	mv	a2,s9
    800028f8:	85a6                	mv	a1,s1
    800028fa:	0b09b503          	ld	a0,176(s3)
    800028fe:	fffff097          	auipc	ra,0xfffff
    80002902:	f40080e7          	jalr	-192(ra) # 8000183e <walk_huge>
            *new_pte = *pte;
    80002906:	000a3783          	ld	a5,0(s4)
    8000290a:	e11c                	sd	a5,0(a0)
            np->mmap_list[i+2] = p->mmap_list[i+2];
    8000290c:	010b3783          	ld	a5,16(s6) # 1010 <_entry-0x7fffeff0>
    80002910:	00fbb823          	sd	a5,16(s7)
            continue;
    80002914:	a081                	j	80002954 <fork+0x10e>
            panic("fork: not a leaf");        
    80002916:	00007517          	auipc	a0,0x7
    8000291a:	ae250513          	add	a0,a0,-1310 # 800093f8 <etext+0x3f8>
    8000291e:	ffffe097          	auipc	ra,0xffffe
    80002922:	c78080e7          	jalr	-904(ra) # 80000596 <panic>
          pte_t* new_pte = walk_huge(np->pagetable,a,1);
    80002926:	8666                	mv	a2,s9
    80002928:	85a6                	mv	a1,s1
    8000292a:	0b09b503          	ld	a0,176(s3)
    8000292e:	fffff097          	auipc	ra,0xfffff
    80002932:	f10080e7          	jalr	-240(ra) # 8000183e <walk_huge>
          *new_pte = *old_pte;
    80002936:	000a3783          	ld	a5,0(s4)
    8000293a:	e11c                	sd	a5,0(a0)
          np->mmap_list[i+2] = p->mmap_list[i+2];   
    8000293c:	010b3783          	ld	a5,16(s6)
    80002940:	00fbb823          	sd	a5,16(s7)
          incr_huge_pa_ref((void*)PTE2PA((*old_pte)));
    80002944:	000a3503          	ld	a0,0(s4)
    80002948:	8129                	srl	a0,a0,0xa
    8000294a:	0532                	sll	a0,a0,0xc
    8000294c:	ffffe097          	auipc	ra,0xffffe
    80002950:	2e2080e7          	jalr	738(ra) # 80000c2e <incr_huge_pa_ref>
        for(a = addr; a < addr + length; a += HUGEPGSIZE)
    80002954:	002007b7          	lui	a5,0x200
    80002958:	94be                	add	s1,s1,a5
    8000295a:	1984f263          	bgeu	s1,s8,80002ade <fork+0x298>
          if((pte = walk_huge(p->pagetable, a, 0)) == 0)
    8000295e:	4601                	li	a2,0
    80002960:	85a6                	mv	a1,s1
    80002962:	0b093503          	ld	a0,176(s2)
    80002966:	fffff097          	auipc	ra,0xfffff
    8000296a:	ed8080e7          	jalr	-296(ra) # 8000183e <walk_huge>
    8000296e:	8a2a                	mv	s4,a0
    80002970:	d125                	beqz	a0,800028d0 <fork+0x8a>
          if((*pte & PTE_V) == 0)
    80002972:	000a3783          	ld	a5,0(s4)
    80002976:	0017f713          	and	a4,a5,1
    8000297a:	d72d                	beqz	a4,800028e4 <fork+0x9e>
          if(PTE_FLAGS(*pte) == PTE_V)
    8000297c:	3ff7f793          	and	a5,a5,1023
    80002980:	f9978be3          	beq	a5,s9,80002916 <fork+0xd0>
          pte_t* old_pte = walk_huge(p->pagetable,a,0);
    80002984:	4601                	li	a2,0
    80002986:	85a6                	mv	a1,s1
    80002988:	0b093503          	ld	a0,176(s2)
    8000298c:	fffff097          	auipc	ra,0xfffff
    80002990:	eb2080e7          	jalr	-334(ra) # 8000183e <walk_huge>
    80002994:	8a2a                	mv	s4,a0
          if(old_pte == 0)
    80002996:	f941                	bnez	a0,80002926 <fork+0xe0>
            panic("(fork, shared, mapped)");
    80002998:	00007517          	auipc	a0,0x7
    8000299c:	a7850513          	add	a0,a0,-1416 # 80009410 <etext+0x410>
    800029a0:	ffffe097          	auipc	ra,0xffffe
    800029a4:	bf6080e7          	jalr	-1034(ra) # 80000596 <panic>
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    800029a8:	010b3783          	ld	a5,16(s6)
    800029ac:	00fbb823          	sd	a5,16(s7)
            continue;
    800029b0:	a029                	j	800029ba <fork+0x174>
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    800029b2:	010b3783          	ld	a5,16(s6)
    800029b6:	00fbb823          	sd	a5,16(s7)
        for(a = addr; a < addr + length; a += HUGEPGSIZE)
    800029ba:	002007b7          	lui	a5,0x200
    800029be:	94be                	add	s1,s1,a5
    800029c0:	f8843783          	ld	a5,-120(s0)
    800029c4:	10f4fd63          	bgeu	s1,a5,80002ade <fork+0x298>
          if((pte = walk_huge(p->pagetable, a, 0)) == 0)
    800029c8:	4601                	li	a2,0
    800029ca:	85a6                	mv	a1,s1
    800029cc:	0b093503          	ld	a0,176(s2)
    800029d0:	fffff097          	auipc	ra,0xfffff
    800029d4:	e6e080e7          	jalr	-402(ra) # 8000183e <walk_huge>
    800029d8:	8a2a                	mv	s4,a0
    800029da:	d579                	beqz	a0,800029a8 <fork+0x162>
          if((*pte & PTE_V) == 0)
    800029dc:	00053c03          	ld	s8,0(a0)
    800029e0:	001c7793          	and	a5,s8,1
    800029e4:	d7f9                	beqz	a5,800029b2 <fork+0x16c>
          if(PTE_FLAGS(*pte) == PTE_V)
    800029e6:	3ffc7793          	and	a5,s8,1023
    800029ea:	4705                	li	a4,1
    800029ec:	06e78663          	beq	a5,a4,80002a58 <fork+0x212>
          if((flags & PROT_MASK) == PROT_READ)
    800029f0:	f7843783          	ld	a5,-136(s0)
    800029f4:	4705                	li	a4,1
    800029f6:	06e78963          	beq	a5,a4,80002a68 <fork+0x222>
            uint64 newflags = create_pte_flag(flags, 0, 1);
    800029fa:	4605                	li	a2,1
    800029fc:	4581                	li	a1,0
    800029fe:	856e                	mv	a0,s11
    80002a00:	00000097          	auipc	ra,0x0
    80002a04:	dfa080e7          	jalr	-518(ra) # 800027fa <create_pte_flag>
            changed_pte = (changed_pte & (~0x3FF)) | newflags;
    80002a08:	c00c7c13          	and	s8,s8,-1024
    80002a0c:	00ac6c33          	or	s8,s8,a0
            *pte = changed_pte;
    80002a10:	018a3023          	sd	s8,0(s4)
            pte_t* old_pte = walk_huge(p->pagetable,a,0);
    80002a14:	4601                	li	a2,0
    80002a16:	85a6                	mv	a1,s1
    80002a18:	0b093503          	ld	a0,176(s2)
    80002a1c:	fffff097          	auipc	ra,0xfffff
    80002a20:	e22080e7          	jalr	-478(ra) # 8000183e <walk_huge>
    80002a24:	8a2a                	mv	s4,a0
            if(old_pte == 0)
    80002a26:	c959                	beqz	a0,80002abc <fork+0x276>
            pte_t* new_pte = walk_huge(np->pagetable,a,1);
    80002a28:	4605                	li	a2,1
    80002a2a:	85a6                	mv	a1,s1
    80002a2c:	0b09b503          	ld	a0,176(s3)
    80002a30:	fffff097          	auipc	ra,0xfffff
    80002a34:	e0e080e7          	jalr	-498(ra) # 8000183e <walk_huge>
            *new_pte = *old_pte;
    80002a38:	000a3783          	ld	a5,0(s4)
    80002a3c:	e11c                	sd	a5,0(a0)
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    80002a3e:	010b3783          	ld	a5,16(s6)
    80002a42:	00fbb823          	sd	a5,16(s7)
            incr_huge_pa_ref((void*)PTE2PA((*old_pte)));
    80002a46:	000a3503          	ld	a0,0(s4)
    80002a4a:	8129                	srl	a0,a0,0xa
    80002a4c:	0532                	sll	a0,a0,0xc
    80002a4e:	ffffe097          	auipc	ra,0xffffe
    80002a52:	1e0080e7          	jalr	480(ra) # 80000c2e <incr_huge_pa_ref>
    80002a56:	b795                	j	800029ba <fork+0x174>
            panic("fork: not a leaf");        
    80002a58:	00007517          	auipc	a0,0x7
    80002a5c:	9a050513          	add	a0,a0,-1632 # 800093f8 <etext+0x3f8>
    80002a60:	ffffe097          	auipc	ra,0xffffe
    80002a64:	b36080e7          	jalr	-1226(ra) # 80000596 <panic>
            pte_t* old_pte = walk_huge(p->pagetable,a,0);
    80002a68:	4601                	li	a2,0
    80002a6a:	85a6                	mv	a1,s1
    80002a6c:	0b093503          	ld	a0,176(s2)
    80002a70:	fffff097          	auipc	ra,0xfffff
    80002a74:	dce080e7          	jalr	-562(ra) # 8000183e <walk_huge>
    80002a78:	8a2a                	mv	s4,a0
            if(old_pte == 0)
    80002a7a:	c90d                	beqz	a0,80002aac <fork+0x266>
            pte_t* new_pte = walk_huge(np->pagetable,a,1);
    80002a7c:	4605                	li	a2,1
    80002a7e:	85a6                	mv	a1,s1
    80002a80:	0b09b503          	ld	a0,176(s3)
    80002a84:	fffff097          	auipc	ra,0xfffff
    80002a88:	dba080e7          	jalr	-582(ra) # 8000183e <walk_huge>
            *new_pte = *old_pte;
    80002a8c:	000a3783          	ld	a5,0(s4)
    80002a90:	e11c                	sd	a5,0(a0)
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    80002a92:	010b3783          	ld	a5,16(s6)
    80002a96:	00fbb823          	sd	a5,16(s7)
            incr_huge_pa_ref((void*)PTE2PA((*old_pte)));
    80002a9a:	000a3503          	ld	a0,0(s4)
    80002a9e:	8129                	srl	a0,a0,0xa
    80002aa0:	0532                	sll	a0,a0,0xc
    80002aa2:	ffffe097          	auipc	ra,0xffffe
    80002aa6:	18c080e7          	jalr	396(ra) # 80000c2e <incr_huge_pa_ref>
    80002aaa:	bf01                	j	800029ba <fork+0x174>
              panic("((huge)fork, shared, mapped)");
    80002aac:	00007517          	auipc	a0,0x7
    80002ab0:	97c50513          	add	a0,a0,-1668 # 80009428 <etext+0x428>
    80002ab4:	ffffe097          	auipc	ra,0xffffe
    80002ab8:	ae2080e7          	jalr	-1310(ra) # 80000596 <panic>
              panic("((huge)fork, private, mapped)");
    80002abc:	00007517          	auipc	a0,0x7
    80002ac0:	98c50513          	add	a0,a0,-1652 # 80009448 <etext+0x448>
    80002ac4:	ffffe097          	auipc	ra,0xffffe
    80002ac8:	ad2080e7          	jalr	-1326(ra) # 80000596 <panic>
      if((flags & FLAG_MASK) == MAP_SHARED)
    80002acc:	0f0df793          	and	a5,s11,240
    80002ad0:	02000713          	li	a4,32
    80002ad4:	04e78f63          	beq	a5,a4,80002b32 <fork+0x2ec>
      else if((flags&FLAG_MASK) == MAP_PRIVATE)
    80002ad8:	4741                	li	a4,16
    80002ada:	12e78b63          	beq	a5,a4,80002c10 <fork+0x3ca>
  for(int i=0; i<12; i+=3)
    80002ade:	0ae1                	add	s5,s5,24
    80002ae0:	0d61                	add	s10,s10,24
    80002ae2:	f8043783          	ld	a5,-128(s0)
    80002ae6:	26fa8163          	beq	s5,a5,80002d48 <fork+0x502>
    uint64 addr = p->mmap_list[i];
    80002aea:	8b56                	mv	s6,s5
    80002aec:	000ab483          	ld	s1,0(s5)
    uint64 length = p->mmap_list[i+1];
    80002af0:	008abc03          	ld	s8,8(s5)
    uint64 flags = p->mmap_list[i+2];
    80002af4:	010abd83          	ld	s11,16(s5)
    if(addr == 0)
    80002af8:	d0fd                	beqz	s1,80002ade <fork+0x298>
    np->mmap_list[i] = addr;
    80002afa:	8bea                	mv	s7,s10
    80002afc:	009d3023          	sd	s1,0(s10)
    np->mmap_list[i+1] = length;
    80002b00:	018d3423          	sd	s8,8(s10)
    if (flags & HUGE_MASK)
    80002b04:	100df793          	and	a5,s11,256
    80002b08:	d3f1                	beqz	a5,80002acc <fork+0x286>
      if((flags & FLAG_MASK) == MAP_SHARED)
    80002b0a:	0f0df793          	and	a5,s11,240
    80002b0e:	02000713          	li	a4,32
    80002b12:	dae78be3          	beq	a5,a4,800028c8 <fork+0x82>
      else if((flags&FLAG_MASK) == MAP_PRIVATE)
    80002b16:	4741                	li	a4,16
    80002b18:	fce793e3          	bne	a5,a4,80002ade <fork+0x298>
        for(a = addr; a < addr + length; a += HUGEPGSIZE)
    80002b1c:	018487b3          	add	a5,s1,s8
    80002b20:	f8f43423          	sd	a5,-120(s0)
    80002b24:	faf4fde3          	bgeu	s1,a5,80002ade <fork+0x298>
          if((flags & PROT_MASK) == PROT_READ)
    80002b28:	00fdf793          	and	a5,s11,15
    80002b2c:	f6f43c23          	sd	a5,-136(s0)
    80002b30:	bd61                	j	800029c8 <fork+0x182>
        for(a = addr; a < addr + length; a += PGSIZE)
    80002b32:	9c26                	add	s8,s8,s1
    80002b34:	0984e963          	bltu	s1,s8,80002bc6 <fork+0x380>
    80002b38:	b75d                	j	80002ade <fork+0x298>
            pte = walk(p->pagetable,a,1);
    80002b3a:	4605                	li	a2,1
    80002b3c:	85a6                	mv	a1,s1
    80002b3e:	0b093503          	ld	a0,176(s2)
    80002b42:	fffff097          	auipc	ra,0xfffff
    80002b46:	c56080e7          	jalr	-938(ra) # 80001798 <walk>
    80002b4a:	8a2a                	mv	s4,a0
    80002b4c:	a079                	j	80002bda <fork+0x394>
            *pte = create_pte_flag(flags,1,0);
    80002b4e:	4601                	li	a2,0
    80002b50:	85e6                	mv	a1,s9
    80002b52:	856e                	mv	a0,s11
    80002b54:	00000097          	auipc	ra,0x0
    80002b58:	ca6080e7          	jalr	-858(ra) # 800027fa <create_pte_flag>
    80002b5c:	00aa3023          	sd	a0,0(s4)
            pte_t* new_pte = walk(np->pagetable,a,1);
    80002b60:	8666                	mv	a2,s9
    80002b62:	85a6                	mv	a1,s1
    80002b64:	0b09b503          	ld	a0,176(s3)
    80002b68:	fffff097          	auipc	ra,0xfffff
    80002b6c:	c30080e7          	jalr	-976(ra) # 80001798 <walk>
            *new_pte = *pte;
    80002b70:	000a3783          	ld	a5,0(s4)
    80002b74:	e11c                	sd	a5,0(a0)
            np->mmap_list[i+2] = p->mmap_list[i+2];
    80002b76:	010b3783          	ld	a5,16(s6)
    80002b7a:	00fbb823          	sd	a5,16(s7)
            continue;
    80002b7e:	a081                	j	80002bbe <fork+0x378>
            panic("fork: not a leaf");        
    80002b80:	00007517          	auipc	a0,0x7
    80002b84:	87850513          	add	a0,a0,-1928 # 800093f8 <etext+0x3f8>
    80002b88:	ffffe097          	auipc	ra,0xffffe
    80002b8c:	a0e080e7          	jalr	-1522(ra) # 80000596 <panic>
          pte_t* new_pte = walk(np->pagetable,a,1);
    80002b90:	8666                	mv	a2,s9
    80002b92:	85a6                	mv	a1,s1
    80002b94:	0b09b503          	ld	a0,176(s3)
    80002b98:	fffff097          	auipc	ra,0xfffff
    80002b9c:	c00080e7          	jalr	-1024(ra) # 80001798 <walk>
          *new_pte = *old_pte;
    80002ba0:	000a3783          	ld	a5,0(s4)
    80002ba4:	e11c                	sd	a5,0(a0)
          np->mmap_list[i+2] = p->mmap_list[i+2];   
    80002ba6:	010b3783          	ld	a5,16(s6)
    80002baa:	00fbb823          	sd	a5,16(s7)
          incr_pa_ref((void*)PTE2PA((*old_pte)));
    80002bae:	000a3503          	ld	a0,0(s4)
    80002bb2:	8129                	srl	a0,a0,0xa
    80002bb4:	0532                	sll	a0,a0,0xc
    80002bb6:	ffffe097          	auipc	ra,0xffffe
    80002bba:	0f6080e7          	jalr	246(ra) # 80000cac <incr_pa_ref>
        for(a = addr; a < addr + length; a += PGSIZE)
    80002bbe:	6785                	lui	a5,0x1
    80002bc0:	94be                	add	s1,s1,a5
    80002bc2:	f184fee3          	bgeu	s1,s8,80002ade <fork+0x298>
          if((pte = walk(p->pagetable, a, 0)) == 0)
    80002bc6:	4601                	li	a2,0
    80002bc8:	85a6                	mv	a1,s1
    80002bca:	0b093503          	ld	a0,176(s2)
    80002bce:	fffff097          	auipc	ra,0xfffff
    80002bd2:	bca080e7          	jalr	-1078(ra) # 80001798 <walk>
    80002bd6:	8a2a                	mv	s4,a0
    80002bd8:	d12d                	beqz	a0,80002b3a <fork+0x2f4>
          if((*pte & PTE_V) == 0)
    80002bda:	000a3783          	ld	a5,0(s4)
    80002bde:	0017f713          	and	a4,a5,1
    80002be2:	d735                	beqz	a4,80002b4e <fork+0x308>
          if(PTE_FLAGS(*pte) == PTE_V)
    80002be4:	3ff7f793          	and	a5,a5,1023
    80002be8:	f9978ce3          	beq	a5,s9,80002b80 <fork+0x33a>
          pte_t* old_pte = walk(p->pagetable,a,0);
    80002bec:	4601                	li	a2,0
    80002bee:	85a6                	mv	a1,s1
    80002bf0:	0b093503          	ld	a0,176(s2)
    80002bf4:	fffff097          	auipc	ra,0xfffff
    80002bf8:	ba4080e7          	jalr	-1116(ra) # 80001798 <walk>
    80002bfc:	8a2a                	mv	s4,a0
          if(old_pte == 0)
    80002bfe:	f949                	bnez	a0,80002b90 <fork+0x34a>
            panic("(fork, shared, mapped)");
    80002c00:	00007517          	auipc	a0,0x7
    80002c04:	81050513          	add	a0,a0,-2032 # 80009410 <etext+0x410>
    80002c08:	ffffe097          	auipc	ra,0xffffe
    80002c0c:	98e080e7          	jalr	-1650(ra) # 80000596 <panic>
        for(a = addr; a < addr + length; a += PGSIZE)
    80002c10:	018487b3          	add	a5,s1,s8
    80002c14:	f8f43423          	sd	a5,-120(s0)
    80002c18:	ecf4f3e3          	bgeu	s1,a5,80002ade <fork+0x298>
          if((flags & PROT_MASK) == PROT_READ)
    80002c1c:	00fdf793          	and	a5,s11,15
    80002c20:	f6f43c23          	sd	a5,-136(s0)
    80002c24:	a005                	j	80002c44 <fork+0x3fe>
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    80002c26:	010b3783          	ld	a5,16(s6)
    80002c2a:	00fbb823          	sd	a5,16(s7)
            continue;
    80002c2e:	a029                	j	80002c38 <fork+0x3f2>
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    80002c30:	010b3783          	ld	a5,16(s6)
    80002c34:	00fbb823          	sd	a5,16(s7)
        for(a = addr; a < addr + length; a += PGSIZE)
    80002c38:	6785                	lui	a5,0x1
    80002c3a:	94be                	add	s1,s1,a5
    80002c3c:	f8843783          	ld	a5,-120(s0)
    80002c40:	e8f4ffe3          	bgeu	s1,a5,80002ade <fork+0x298>
          if((pte = walk(p->pagetable, a, 0)) == 0)
    80002c44:	4601                	li	a2,0
    80002c46:	85a6                	mv	a1,s1
    80002c48:	0b093503          	ld	a0,176(s2)
    80002c4c:	fffff097          	auipc	ra,0xfffff
    80002c50:	b4c080e7          	jalr	-1204(ra) # 80001798 <walk>
    80002c54:	8a2a                	mv	s4,a0
    80002c56:	d961                	beqz	a0,80002c26 <fork+0x3e0>
          if((*pte & PTE_V) == 0)
    80002c58:	00053c03          	ld	s8,0(a0)
    80002c5c:	001c7793          	and	a5,s8,1
    80002c60:	dbe1                	beqz	a5,80002c30 <fork+0x3ea>
          if(PTE_FLAGS(*pte) == PTE_V)
    80002c62:	3ffc7793          	and	a5,s8,1023
    80002c66:	4705                	li	a4,1
    80002c68:	06e78663          	beq	a5,a4,80002cd4 <fork+0x48e>
          if((flags & PROT_MASK) == PROT_READ)
    80002c6c:	f7843783          	ld	a5,-136(s0)
    80002c70:	4705                	li	a4,1
    80002c72:	06e78963          	beq	a5,a4,80002ce4 <fork+0x49e>
            uint64 newflags = create_pte_flag(flags, 0, 1);
    80002c76:	4605                	li	a2,1
    80002c78:	4581                	li	a1,0
    80002c7a:	856e                	mv	a0,s11
    80002c7c:	00000097          	auipc	ra,0x0
    80002c80:	b7e080e7          	jalr	-1154(ra) # 800027fa <create_pte_flag>
            changed_pte = (changed_pte & (~0x3FF)) | newflags;
    80002c84:	c00c7c13          	and	s8,s8,-1024
    80002c88:	00ac6c33          	or	s8,s8,a0
            *pte = changed_pte;
    80002c8c:	018a3023          	sd	s8,0(s4)
            pte_t* old_pte = walk(p->pagetable,a,0);
    80002c90:	4601                	li	a2,0
    80002c92:	85a6                	mv	a1,s1
    80002c94:	0b093503          	ld	a0,176(s2)
    80002c98:	fffff097          	auipc	ra,0xfffff
    80002c9c:	b00080e7          	jalr	-1280(ra) # 80001798 <walk>
    80002ca0:	8a2a                	mv	s4,a0
            if(old_pte == 0)
    80002ca2:	c959                	beqz	a0,80002d38 <fork+0x4f2>
            pte_t* new_pte = walk(np->pagetable,a,1);
    80002ca4:	4605                	li	a2,1
    80002ca6:	85a6                	mv	a1,s1
    80002ca8:	0b09b503          	ld	a0,176(s3)
    80002cac:	fffff097          	auipc	ra,0xfffff
    80002cb0:	aec080e7          	jalr	-1300(ra) # 80001798 <walk>
            *new_pte = *old_pte;
    80002cb4:	000a3783          	ld	a5,0(s4)
    80002cb8:	e11c                	sd	a5,0(a0)
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    80002cba:	010b3783          	ld	a5,16(s6)
    80002cbe:	00fbb823          	sd	a5,16(s7)
            incr_pa_ref((void*)PTE2PA((*old_pte)));
    80002cc2:	000a3503          	ld	a0,0(s4)
    80002cc6:	8129                	srl	a0,a0,0xa
    80002cc8:	0532                	sll	a0,a0,0xc
    80002cca:	ffffe097          	auipc	ra,0xffffe
    80002cce:	fe2080e7          	jalr	-30(ra) # 80000cac <incr_pa_ref>
    80002cd2:	b79d                	j	80002c38 <fork+0x3f2>
            panic("fork: not a leaf");        
    80002cd4:	00006517          	auipc	a0,0x6
    80002cd8:	72450513          	add	a0,a0,1828 # 800093f8 <etext+0x3f8>
    80002cdc:	ffffe097          	auipc	ra,0xffffe
    80002ce0:	8ba080e7          	jalr	-1862(ra) # 80000596 <panic>
            pte_t* old_pte = walk(p->pagetable,a,0);
    80002ce4:	4601                	li	a2,0
    80002ce6:	85a6                	mv	a1,s1
    80002ce8:	0b093503          	ld	a0,176(s2)
    80002cec:	fffff097          	auipc	ra,0xfffff
    80002cf0:	aac080e7          	jalr	-1364(ra) # 80001798 <walk>
    80002cf4:	8a2a                	mv	s4,a0
            if(old_pte == 0)
    80002cf6:	c90d                	beqz	a0,80002d28 <fork+0x4e2>
            pte_t* new_pte = walk(np->pagetable,a,1);
    80002cf8:	4605                	li	a2,1
    80002cfa:	85a6                	mv	a1,s1
    80002cfc:	0b09b503          	ld	a0,176(s3)
    80002d00:	fffff097          	auipc	ra,0xfffff
    80002d04:	a98080e7          	jalr	-1384(ra) # 80001798 <walk>
            *new_pte = *old_pte;
    80002d08:	000a3783          	ld	a5,0(s4)
    80002d0c:	e11c                	sd	a5,0(a0)
            np->mmap_list[i+2] = p->mmap_list[i+2];   
    80002d0e:	010b3783          	ld	a5,16(s6)
    80002d12:	00fbb823          	sd	a5,16(s7)
            incr_pa_ref((void*)PTE2PA((*old_pte)));
    80002d16:	000a3503          	ld	a0,0(s4)
    80002d1a:	8129                	srl	a0,a0,0xa
    80002d1c:	0532                	sll	a0,a0,0xc
    80002d1e:	ffffe097          	auipc	ra,0xffffe
    80002d22:	f8e080e7          	jalr	-114(ra) # 80000cac <incr_pa_ref>
    80002d26:	bf09                	j	80002c38 <fork+0x3f2>
              panic("(fork, shared, mapped)");
    80002d28:	00006517          	auipc	a0,0x6
    80002d2c:	6e850513          	add	a0,a0,1768 # 80009410 <etext+0x410>
    80002d30:	ffffe097          	auipc	ra,0xffffe
    80002d34:	866080e7          	jalr	-1946(ra) # 80000596 <panic>
              panic("(fork, private, mapped)");
    80002d38:	00006517          	auipc	a0,0x6
    80002d3c:	73050513          	add	a0,a0,1840 # 80009468 <etext+0x468>
    80002d40:	ffffe097          	auipc	ra,0xffffe
    80002d44:	856080e7          	jalr	-1962(ra) # 80000596 <panic>
  *(np->trapframe) = *(p->trapframe);
    80002d48:	0b893683          	ld	a3,184(s2)
    80002d4c:	87b6                	mv	a5,a3
    80002d4e:	0b89b703          	ld	a4,184(s3)
    80002d52:	12068693          	add	a3,a3,288
    80002d56:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80002d5a:	6788                	ld	a0,8(a5)
    80002d5c:	6b8c                	ld	a1,16(a5)
    80002d5e:	6f90                	ld	a2,24(a5)
    80002d60:	01073023          	sd	a6,0(a4)
    80002d64:	e708                	sd	a0,8(a4)
    80002d66:	eb0c                	sd	a1,16(a4)
    80002d68:	ef10                	sd	a2,24(a4)
    80002d6a:	02078793          	add	a5,a5,32
    80002d6e:	02070713          	add	a4,a4,32
    80002d72:	fed792e3          	bne	a5,a3,80002d56 <fork+0x510>
  np->trapframe->a0 = 0;
    80002d76:	0b89b783          	ld	a5,184(s3)
    80002d7a:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80002d7e:	13090493          	add	s1,s2,304
    80002d82:	13098a13          	add	s4,s3,304
    80002d86:	1b090a93          	add	s5,s2,432
    80002d8a:	a029                	j	80002d94 <fork+0x54e>
    80002d8c:	04a1                	add	s1,s1,8
    80002d8e:	0a21                	add	s4,s4,8
    80002d90:	01548b63          	beq	s1,s5,80002da6 <fork+0x560>
    if(p->ofile[i])
    80002d94:	6088                	ld	a0,0(s1)
    80002d96:	d97d                	beqz	a0,80002d8c <fork+0x546>
      np->ofile[i] = filedup(p->ofile[i]);
    80002d98:	00003097          	auipc	ra,0x3
    80002d9c:	ec8080e7          	jalr	-312(ra) # 80005c60 <filedup>
    80002da0:	00aa3023          	sd	a0,0(s4)
    80002da4:	b7e5                	j	80002d8c <fork+0x546>
  np->cwd = idup(p->cwd);
    80002da6:	1b093503          	ld	a0,432(s2)
    80002daa:	00002097          	auipc	ra,0x2
    80002dae:	032080e7          	jalr	50(ra) # 80004ddc <idup>
    80002db2:	1aa9b823          	sd	a0,432(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80002db6:	4641                	li	a2,16
    80002db8:	1b890593          	add	a1,s2,440
    80002dbc:	1b898513          	add	a0,s3,440
    80002dc0:	fffff097          	auipc	ra,0xfffff
    80002dc4:	832080e7          	jalr	-1998(ra) # 800015f2 <safestrcpy>
  pid = np->pid;
    80002dc8:	0309aa03          	lw	s4,48(s3)
  release(&np->lock);
    80002dcc:	854e                	mv	a0,s3
    80002dce:	ffffe097          	auipc	ra,0xffffe
    80002dd2:	69a080e7          	jalr	1690(ra) # 80001468 <release>
  acquire(&wait_lock);
    80002dd6:	0001f497          	auipc	s1,0x1f
    80002dda:	cea48493          	add	s1,s1,-790 # 80021ac0 <wait_lock>
    80002dde:	8526                	mv	a0,s1
    80002de0:	ffffe097          	auipc	ra,0xffffe
    80002de4:	5d4080e7          	jalr	1492(ra) # 800013b4 <acquire>
  np->parent = p;
    80002de8:	0929bc23          	sd	s2,152(s3)
  release(&wait_lock);
    80002dec:	8526                	mv	a0,s1
    80002dee:	ffffe097          	auipc	ra,0xffffe
    80002df2:	67a080e7          	jalr	1658(ra) # 80001468 <release>
  acquire(&np->lock);
    80002df6:	854e                	mv	a0,s3
    80002df8:	ffffe097          	auipc	ra,0xffffe
    80002dfc:	5bc080e7          	jalr	1468(ra) # 800013b4 <acquire>
  np->state = RUNNABLE;
    80002e00:	478d                	li	a5,3
    80002e02:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80002e06:	854e                	mv	a0,s3
    80002e08:	ffffe097          	auipc	ra,0xffffe
    80002e0c:	660080e7          	jalr	1632(ra) # 80001468 <release>
  return pid;
    80002e10:	74e6                	ld	s1,120(sp)
    80002e12:	79a6                	ld	s3,104(sp)
    80002e14:	6ae6                	ld	s5,88(sp)
    80002e16:	6b46                	ld	s6,80(sp)
    80002e18:	6ba6                	ld	s7,72(sp)
    80002e1a:	6c06                	ld	s8,64(sp)
    80002e1c:	7ce2                	ld	s9,56(sp)
    80002e1e:	7d42                	ld	s10,48(sp)
    80002e20:	7da2                	ld	s11,40(sp)
}
    80002e22:	8552                	mv	a0,s4
    80002e24:	60aa                	ld	ra,136(sp)
    80002e26:	640a                	ld	s0,128(sp)
    80002e28:	7946                	ld	s2,112(sp)
    80002e2a:	7a06                	ld	s4,96(sp)
    80002e2c:	6149                	add	sp,sp,144
    80002e2e:	8082                	ret
    return -1;
    80002e30:	5a7d                	li	s4,-1
    80002e32:	bfc5                	j	80002e22 <fork+0x5dc>

0000000080002e34 <scheduler>:
{
    80002e34:	7139                	add	sp,sp,-64
    80002e36:	fc06                	sd	ra,56(sp)
    80002e38:	f822                	sd	s0,48(sp)
    80002e3a:	f426                	sd	s1,40(sp)
    80002e3c:	f04a                	sd	s2,32(sp)
    80002e3e:	ec4e                	sd	s3,24(sp)
    80002e40:	e852                	sd	s4,16(sp)
    80002e42:	e456                	sd	s5,8(sp)
    80002e44:	e05a                	sd	s6,0(sp)
    80002e46:	0080                	add	s0,sp,64
    80002e48:	8792                	mv	a5,tp
  int id = r_tp();
    80002e4a:	2781                	sext.w	a5,a5
  c->proc = 0;
    80002e4c:	00779a93          	sll	s5,a5,0x7
    80002e50:	0001f717          	auipc	a4,0x1f
    80002e54:	c5870713          	add	a4,a4,-936 # 80021aa8 <pid_lock>
    80002e58:	9756                	add	a4,a4,s5
    80002e5a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80002e5e:	0001f717          	auipc	a4,0x1f
    80002e62:	c8270713          	add	a4,a4,-894 # 80021ae0 <cpus+0x8>
    80002e66:	9aba                	add	s5,s5,a4
      if(p->state == RUNNABLE) {
    80002e68:	498d                	li	s3,3
        p->state = RUNNING;
    80002e6a:	4b11                	li	s6,4
        c->proc = p;
    80002e6c:	079e                	sll	a5,a5,0x7
    80002e6e:	0001fa17          	auipc	s4,0x1f
    80002e72:	c3aa0a13          	add	s4,s4,-966 # 80021aa8 <pid_lock>
    80002e76:	9a3e                	add	s4,s4,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002e78:	00026917          	auipc	s2,0x26
    80002e7c:	26090913          	add	s2,s2,608 # 800290d8 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002e80:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80002e84:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002e88:	10079073          	csrw	sstatus,a5
    80002e8c:	0001f497          	auipc	s1,0x1f
    80002e90:	04c48493          	add	s1,s1,76 # 80021ed8 <proc>
    80002e94:	a811                	j	80002ea8 <scheduler+0x74>
      release(&p->lock);
    80002e96:	8526                	mv	a0,s1
    80002e98:	ffffe097          	auipc	ra,0xffffe
    80002e9c:	5d0080e7          	jalr	1488(ra) # 80001468 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80002ea0:	1c848493          	add	s1,s1,456
    80002ea4:	fd248ee3          	beq	s1,s2,80002e80 <scheduler+0x4c>
      acquire(&p->lock);
    80002ea8:	8526                	mv	a0,s1
    80002eaa:	ffffe097          	auipc	ra,0xffffe
    80002eae:	50a080e7          	jalr	1290(ra) # 800013b4 <acquire>
      if(p->state == RUNNABLE) {
    80002eb2:	4c9c                	lw	a5,24(s1)
    80002eb4:	ff3791e3          	bne	a5,s3,80002e96 <scheduler+0x62>
        p->state = RUNNING;
    80002eb8:	0164ac23          	sw	s6,24(s1)
        c->proc = p;
    80002ebc:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80002ec0:	0c048593          	add	a1,s1,192
    80002ec4:	8556                	mv	a0,s5
    80002ec6:	00001097          	auipc	ra,0x1
    80002eca:	b40080e7          	jalr	-1216(ra) # 80003a06 <swtch>
        c->proc = 0;
    80002ece:	020a3823          	sd	zero,48(s4)
    80002ed2:	b7d1                	j	80002e96 <scheduler+0x62>

0000000080002ed4 <sched>:
{
    80002ed4:	7179                	add	sp,sp,-48
    80002ed6:	f406                	sd	ra,40(sp)
    80002ed8:	f022                	sd	s0,32(sp)
    80002eda:	ec26                	sd	s1,24(sp)
    80002edc:	e84a                	sd	s2,16(sp)
    80002ede:	e44e                	sd	s3,8(sp)
    80002ee0:	1800                	add	s0,sp,48
  struct proc *p = myproc();
    80002ee2:	fffff097          	auipc	ra,0xfffff
    80002ee6:	4a2080e7          	jalr	1186(ra) # 80002384 <myproc>
    80002eea:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80002eec:	ffffe097          	auipc	ra,0xffffe
    80002ef0:	44e080e7          	jalr	1102(ra) # 8000133a <holding>
    80002ef4:	c93d                	beqz	a0,80002f6a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002ef6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80002ef8:	2781                	sext.w	a5,a5
    80002efa:	079e                	sll	a5,a5,0x7
    80002efc:	0001f717          	auipc	a4,0x1f
    80002f00:	bac70713          	add	a4,a4,-1108 # 80021aa8 <pid_lock>
    80002f04:	97ba                	add	a5,a5,a4
    80002f06:	0a87a703          	lw	a4,168(a5)
    80002f0a:	4785                	li	a5,1
    80002f0c:	06f71763          	bne	a4,a5,80002f7a <sched+0xa6>
  if(p->state == RUNNING)
    80002f10:	4c98                	lw	a4,24(s1)
    80002f12:	4791                	li	a5,4
    80002f14:	06f70b63          	beq	a4,a5,80002f8a <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002f18:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002f1c:	8b89                	and	a5,a5,2
  if(intr_get())
    80002f1e:	efb5                	bnez	a5,80002f9a <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80002f20:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002f22:	0001f917          	auipc	s2,0x1f
    80002f26:	b8690913          	add	s2,s2,-1146 # 80021aa8 <pid_lock>
    80002f2a:	2781                	sext.w	a5,a5
    80002f2c:	079e                	sll	a5,a5,0x7
    80002f2e:	97ca                	add	a5,a5,s2
    80002f30:	0ac7a983          	lw	s3,172(a5)
    80002f34:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80002f36:	2781                	sext.w	a5,a5
    80002f38:	079e                	sll	a5,a5,0x7
    80002f3a:	0001f597          	auipc	a1,0x1f
    80002f3e:	ba658593          	add	a1,a1,-1114 # 80021ae0 <cpus+0x8>
    80002f42:	95be                	add	a1,a1,a5
    80002f44:	0c048513          	add	a0,s1,192
    80002f48:	00001097          	auipc	ra,0x1
    80002f4c:	abe080e7          	jalr	-1346(ra) # 80003a06 <swtch>
    80002f50:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002f52:	2781                	sext.w	a5,a5
    80002f54:	079e                	sll	a5,a5,0x7
    80002f56:	993e                	add	s2,s2,a5
    80002f58:	0b392623          	sw	s3,172(s2)
}
    80002f5c:	70a2                	ld	ra,40(sp)
    80002f5e:	7402                	ld	s0,32(sp)
    80002f60:	64e2                	ld	s1,24(sp)
    80002f62:	6942                	ld	s2,16(sp)
    80002f64:	69a2                	ld	s3,8(sp)
    80002f66:	6145                	add	sp,sp,48
    80002f68:	8082                	ret
    panic("sched p->lock");
    80002f6a:	00006517          	auipc	a0,0x6
    80002f6e:	51650513          	add	a0,a0,1302 # 80009480 <etext+0x480>
    80002f72:	ffffd097          	auipc	ra,0xffffd
    80002f76:	624080e7          	jalr	1572(ra) # 80000596 <panic>
    panic("sched locks");
    80002f7a:	00006517          	auipc	a0,0x6
    80002f7e:	51650513          	add	a0,a0,1302 # 80009490 <etext+0x490>
    80002f82:	ffffd097          	auipc	ra,0xffffd
    80002f86:	614080e7          	jalr	1556(ra) # 80000596 <panic>
    panic("sched running");
    80002f8a:	00006517          	auipc	a0,0x6
    80002f8e:	51650513          	add	a0,a0,1302 # 800094a0 <etext+0x4a0>
    80002f92:	ffffd097          	auipc	ra,0xffffd
    80002f96:	604080e7          	jalr	1540(ra) # 80000596 <panic>
    panic("sched interruptible");
    80002f9a:	00006517          	auipc	a0,0x6
    80002f9e:	51650513          	add	a0,a0,1302 # 800094b0 <etext+0x4b0>
    80002fa2:	ffffd097          	auipc	ra,0xffffd
    80002fa6:	5f4080e7          	jalr	1524(ra) # 80000596 <panic>

0000000080002faa <yield>:
{
    80002faa:	1101                	add	sp,sp,-32
    80002fac:	ec06                	sd	ra,24(sp)
    80002fae:	e822                	sd	s0,16(sp)
    80002fb0:	e426                	sd	s1,8(sp)
    80002fb2:	1000                	add	s0,sp,32
  struct proc *p = myproc();
    80002fb4:	fffff097          	auipc	ra,0xfffff
    80002fb8:	3d0080e7          	jalr	976(ra) # 80002384 <myproc>
    80002fbc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80002fbe:	ffffe097          	auipc	ra,0xffffe
    80002fc2:	3f6080e7          	jalr	1014(ra) # 800013b4 <acquire>
  p->state = RUNNABLE;
    80002fc6:	478d                	li	a5,3
    80002fc8:	cc9c                	sw	a5,24(s1)
  sched();
    80002fca:	00000097          	auipc	ra,0x0
    80002fce:	f0a080e7          	jalr	-246(ra) # 80002ed4 <sched>
  release(&p->lock);
    80002fd2:	8526                	mv	a0,s1
    80002fd4:	ffffe097          	auipc	ra,0xffffe
    80002fd8:	494080e7          	jalr	1172(ra) # 80001468 <release>
}
    80002fdc:	60e2                	ld	ra,24(sp)
    80002fde:	6442                	ld	s0,16(sp)
    80002fe0:	64a2                	ld	s1,8(sp)
    80002fe2:	6105                	add	sp,sp,32
    80002fe4:	8082                	ret

0000000080002fe6 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80002fe6:	7179                	add	sp,sp,-48
    80002fe8:	f406                	sd	ra,40(sp)
    80002fea:	f022                	sd	s0,32(sp)
    80002fec:	ec26                	sd	s1,24(sp)
    80002fee:	e84a                	sd	s2,16(sp)
    80002ff0:	e44e                	sd	s3,8(sp)
    80002ff2:	1800                	add	s0,sp,48
    80002ff4:	89aa                	mv	s3,a0
    80002ff6:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002ff8:	fffff097          	auipc	ra,0xfffff
    80002ffc:	38c080e7          	jalr	908(ra) # 80002384 <myproc>
    80003000:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80003002:	ffffe097          	auipc	ra,0xffffe
    80003006:	3b2080e7          	jalr	946(ra) # 800013b4 <acquire>
  release(lk);
    8000300a:	854a                	mv	a0,s2
    8000300c:	ffffe097          	auipc	ra,0xffffe
    80003010:	45c080e7          	jalr	1116(ra) # 80001468 <release>

  // Go to sleep.
  p->chan = chan;
    80003014:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80003018:	4789                	li	a5,2
    8000301a:	cc9c                	sw	a5,24(s1)

  sched();
    8000301c:	00000097          	auipc	ra,0x0
    80003020:	eb8080e7          	jalr	-328(ra) # 80002ed4 <sched>

  // Tidy up.
  p->chan = 0;
    80003024:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80003028:	8526                	mv	a0,s1
    8000302a:	ffffe097          	auipc	ra,0xffffe
    8000302e:	43e080e7          	jalr	1086(ra) # 80001468 <release>
  acquire(lk);
    80003032:	854a                	mv	a0,s2
    80003034:	ffffe097          	auipc	ra,0xffffe
    80003038:	380080e7          	jalr	896(ra) # 800013b4 <acquire>
}
    8000303c:	70a2                	ld	ra,40(sp)
    8000303e:	7402                	ld	s0,32(sp)
    80003040:	64e2                	ld	s1,24(sp)
    80003042:	6942                	ld	s2,16(sp)
    80003044:	69a2                	ld	s3,8(sp)
    80003046:	6145                	add	sp,sp,48
    80003048:	8082                	ret

000000008000304a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void
wakeup(void *chan)
{
    8000304a:	7139                	add	sp,sp,-64
    8000304c:	fc06                	sd	ra,56(sp)
    8000304e:	f822                	sd	s0,48(sp)
    80003050:	f426                	sd	s1,40(sp)
    80003052:	f04a                	sd	s2,32(sp)
    80003054:	ec4e                	sd	s3,24(sp)
    80003056:	e852                	sd	s4,16(sp)
    80003058:	e456                	sd	s5,8(sp)
    8000305a:	0080                	add	s0,sp,64
    8000305c:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000305e:	0001f497          	auipc	s1,0x1f
    80003062:	e7a48493          	add	s1,s1,-390 # 80021ed8 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80003066:	4989                	li	s3,2
        p->state = RUNNABLE;
    80003068:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000306a:	00026917          	auipc	s2,0x26
    8000306e:	06e90913          	add	s2,s2,110 # 800290d8 <tickslock>
    80003072:	a811                	j	80003086 <wakeup+0x3c>
      }
      release(&p->lock);
    80003074:	8526                	mv	a0,s1
    80003076:	ffffe097          	auipc	ra,0xffffe
    8000307a:	3f2080e7          	jalr	1010(ra) # 80001468 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000307e:	1c848493          	add	s1,s1,456
    80003082:	03248663          	beq	s1,s2,800030ae <wakeup+0x64>
    if(p != myproc()){
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	2fe080e7          	jalr	766(ra) # 80002384 <myproc>
    8000308e:	fea488e3          	beq	s1,a0,8000307e <wakeup+0x34>
      acquire(&p->lock);
    80003092:	8526                	mv	a0,s1
    80003094:	ffffe097          	auipc	ra,0xffffe
    80003098:	320080e7          	jalr	800(ra) # 800013b4 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000309c:	4c9c                	lw	a5,24(s1)
    8000309e:	fd379be3          	bne	a5,s3,80003074 <wakeup+0x2a>
    800030a2:	709c                	ld	a5,32(s1)
    800030a4:	fd4798e3          	bne	a5,s4,80003074 <wakeup+0x2a>
        p->state = RUNNABLE;
    800030a8:	0154ac23          	sw	s5,24(s1)
    800030ac:	b7e1                	j	80003074 <wakeup+0x2a>
    }
  }
}
    800030ae:	70e2                	ld	ra,56(sp)
    800030b0:	7442                	ld	s0,48(sp)
    800030b2:	74a2                	ld	s1,40(sp)
    800030b4:	7902                	ld	s2,32(sp)
    800030b6:	69e2                	ld	s3,24(sp)
    800030b8:	6a42                	ld	s4,16(sp)
    800030ba:	6aa2                	ld	s5,8(sp)
    800030bc:	6121                	add	sp,sp,64
    800030be:	8082                	ret

00000000800030c0 <reparent>:
{
    800030c0:	7179                	add	sp,sp,-48
    800030c2:	f406                	sd	ra,40(sp)
    800030c4:	f022                	sd	s0,32(sp)
    800030c6:	ec26                	sd	s1,24(sp)
    800030c8:	e84a                	sd	s2,16(sp)
    800030ca:	e44e                	sd	s3,8(sp)
    800030cc:	e052                	sd	s4,0(sp)
    800030ce:	1800                	add	s0,sp,48
    800030d0:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800030d2:	0001f497          	auipc	s1,0x1f
    800030d6:	e0648493          	add	s1,s1,-506 # 80021ed8 <proc>
      pp->parent = initproc;
    800030da:	00007a17          	auipc	s4,0x7
    800030de:	a9ea0a13          	add	s4,s4,-1378 # 80009b78 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800030e2:	00026997          	auipc	s3,0x26
    800030e6:	ff698993          	add	s3,s3,-10 # 800290d8 <tickslock>
    800030ea:	a029                	j	800030f4 <reparent+0x34>
    800030ec:	1c848493          	add	s1,s1,456
    800030f0:	01348d63          	beq	s1,s3,8000310a <reparent+0x4a>
    if(pp->parent == p){
    800030f4:	6cdc                	ld	a5,152(s1)
    800030f6:	ff279be3          	bne	a5,s2,800030ec <reparent+0x2c>
      pp->parent = initproc;
    800030fa:	000a3503          	ld	a0,0(s4)
    800030fe:	ecc8                	sd	a0,152(s1)
      wakeup(initproc);
    80003100:	00000097          	auipc	ra,0x0
    80003104:	f4a080e7          	jalr	-182(ra) # 8000304a <wakeup>
    80003108:	b7d5                	j	800030ec <reparent+0x2c>
}
    8000310a:	70a2                	ld	ra,40(sp)
    8000310c:	7402                	ld	s0,32(sp)
    8000310e:	64e2                	ld	s1,24(sp)
    80003110:	6942                	ld	s2,16(sp)
    80003112:	69a2                	ld	s3,8(sp)
    80003114:	6a02                	ld	s4,0(sp)
    80003116:	6145                	add	sp,sp,48
    80003118:	8082                	ret

000000008000311a <exit>:
{
    8000311a:	7179                	add	sp,sp,-48
    8000311c:	f406                	sd	ra,40(sp)
    8000311e:	f022                	sd	s0,32(sp)
    80003120:	ec26                	sd	s1,24(sp)
    80003122:	e84a                	sd	s2,16(sp)
    80003124:	e44e                	sd	s3,8(sp)
    80003126:	e052                	sd	s4,0(sp)
    80003128:	1800                	add	s0,sp,48
    8000312a:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000312c:	fffff097          	auipc	ra,0xfffff
    80003130:	258080e7          	jalr	600(ra) # 80002384 <myproc>
    80003134:	89aa                	mv	s3,a0
  if(p == initproc)
    80003136:	00007797          	auipc	a5,0x7
    8000313a:	a427b783          	ld	a5,-1470(a5) # 80009b78 <initproc>
    8000313e:	13050493          	add	s1,a0,304
    80003142:	1b050913          	add	s2,a0,432
    80003146:	02a79363          	bne	a5,a0,8000316c <exit+0x52>
    panic("init exiting");
    8000314a:	00006517          	auipc	a0,0x6
    8000314e:	37e50513          	add	a0,a0,894 # 800094c8 <etext+0x4c8>
    80003152:	ffffd097          	auipc	ra,0xffffd
    80003156:	444080e7          	jalr	1092(ra) # 80000596 <panic>
      fileclose(f);
    8000315a:	00003097          	auipc	ra,0x3
    8000315e:	b58080e7          	jalr	-1192(ra) # 80005cb2 <fileclose>
      p->ofile[fd] = 0;
    80003162:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    80003166:	04a1                	add	s1,s1,8
    80003168:	01248563          	beq	s1,s2,80003172 <exit+0x58>
    if(p->ofile[fd]){
    8000316c:	6088                	ld	a0,0(s1)
    8000316e:	f575                	bnez	a0,8000315a <exit+0x40>
    80003170:	bfdd                	j	80003166 <exit+0x4c>
  begin_op();
    80003172:	00002097          	auipc	ra,0x2
    80003176:	676080e7          	jalr	1654(ra) # 800057e8 <begin_op>
  iput(p->cwd);
    8000317a:	1b09b503          	ld	a0,432(s3)
    8000317e:	00002097          	auipc	ra,0x2
    80003182:	e5a080e7          	jalr	-422(ra) # 80004fd8 <iput>
  end_op();
    80003186:	00002097          	auipc	ra,0x2
    8000318a:	6dc080e7          	jalr	1756(ra) # 80005862 <end_op>
  p->cwd = 0;
    8000318e:	1a09b823          	sd	zero,432(s3)
  acquire(&wait_lock);
    80003192:	0001f497          	auipc	s1,0x1f
    80003196:	92e48493          	add	s1,s1,-1746 # 80021ac0 <wait_lock>
    8000319a:	8526                	mv	a0,s1
    8000319c:	ffffe097          	auipc	ra,0xffffe
    800031a0:	218080e7          	jalr	536(ra) # 800013b4 <acquire>
  reparent(p);
    800031a4:	854e                	mv	a0,s3
    800031a6:	00000097          	auipc	ra,0x0
    800031aa:	f1a080e7          	jalr	-230(ra) # 800030c0 <reparent>
  wakeup(p->parent);
    800031ae:	0989b503          	ld	a0,152(s3)
    800031b2:	00000097          	auipc	ra,0x0
    800031b6:	e98080e7          	jalr	-360(ra) # 8000304a <wakeup>
  acquire(&p->lock);
    800031ba:	854e                	mv	a0,s3
    800031bc:	ffffe097          	auipc	ra,0xffffe
    800031c0:	1f8080e7          	jalr	504(ra) # 800013b4 <acquire>
  p->xstate = status;
    800031c4:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800031c8:	4795                	li	a5,5
    800031ca:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800031ce:	8526                	mv	a0,s1
    800031d0:	ffffe097          	auipc	ra,0xffffe
    800031d4:	298080e7          	jalr	664(ra) # 80001468 <release>
  sched();
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	cfc080e7          	jalr	-772(ra) # 80002ed4 <sched>
  panic("zombie exit");
    800031e0:	00006517          	auipc	a0,0x6
    800031e4:	2f850513          	add	a0,a0,760 # 800094d8 <etext+0x4d8>
    800031e8:	ffffd097          	auipc	ra,0xffffd
    800031ec:	3ae080e7          	jalr	942(ra) # 80000596 <panic>

00000000800031f0 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800031f0:	7179                	add	sp,sp,-48
    800031f2:	f406                	sd	ra,40(sp)
    800031f4:	f022                	sd	s0,32(sp)
    800031f6:	ec26                	sd	s1,24(sp)
    800031f8:	e84a                	sd	s2,16(sp)
    800031fa:	e44e                	sd	s3,8(sp)
    800031fc:	1800                	add	s0,sp,48
    800031fe:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80003200:	0001f497          	auipc	s1,0x1f
    80003204:	cd848493          	add	s1,s1,-808 # 80021ed8 <proc>
    80003208:	00026997          	auipc	s3,0x26
    8000320c:	ed098993          	add	s3,s3,-304 # 800290d8 <tickslock>
    acquire(&p->lock);
    80003210:	8526                	mv	a0,s1
    80003212:	ffffe097          	auipc	ra,0xffffe
    80003216:	1a2080e7          	jalr	418(ra) # 800013b4 <acquire>
    if(p->pid == pid){
    8000321a:	589c                	lw	a5,48(s1)
    8000321c:	01278d63          	beq	a5,s2,80003236 <kill+0x46>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80003220:	8526                	mv	a0,s1
    80003222:	ffffe097          	auipc	ra,0xffffe
    80003226:	246080e7          	jalr	582(ra) # 80001468 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000322a:	1c848493          	add	s1,s1,456
    8000322e:	ff3491e3          	bne	s1,s3,80003210 <kill+0x20>
  }
  return -1;
    80003232:	557d                	li	a0,-1
    80003234:	a829                	j	8000324e <kill+0x5e>
      p->killed = 1;
    80003236:	4785                	li	a5,1
    80003238:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000323a:	4c98                	lw	a4,24(s1)
    8000323c:	4789                	li	a5,2
    8000323e:	00f70f63          	beq	a4,a5,8000325c <kill+0x6c>
      release(&p->lock);
    80003242:	8526                	mv	a0,s1
    80003244:	ffffe097          	auipc	ra,0xffffe
    80003248:	224080e7          	jalr	548(ra) # 80001468 <release>
      return 0;
    8000324c:	4501                	li	a0,0
}
    8000324e:	70a2                	ld	ra,40(sp)
    80003250:	7402                	ld	s0,32(sp)
    80003252:	64e2                	ld	s1,24(sp)
    80003254:	6942                	ld	s2,16(sp)
    80003256:	69a2                	ld	s3,8(sp)
    80003258:	6145                	add	sp,sp,48
    8000325a:	8082                	ret
        p->state = RUNNABLE;
    8000325c:	478d                	li	a5,3
    8000325e:	cc9c                	sw	a5,24(s1)
    80003260:	b7cd                	j	80003242 <kill+0x52>

0000000080003262 <setkilled>:

void
setkilled(struct proc *p)
{
    80003262:	1101                	add	sp,sp,-32
    80003264:	ec06                	sd	ra,24(sp)
    80003266:	e822                	sd	s0,16(sp)
    80003268:	e426                	sd	s1,8(sp)
    8000326a:	1000                	add	s0,sp,32
    8000326c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000326e:	ffffe097          	auipc	ra,0xffffe
    80003272:	146080e7          	jalr	326(ra) # 800013b4 <acquire>
  p->killed = 1;
    80003276:	4785                	li	a5,1
    80003278:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000327a:	8526                	mv	a0,s1
    8000327c:	ffffe097          	auipc	ra,0xffffe
    80003280:	1ec080e7          	jalr	492(ra) # 80001468 <release>
}
    80003284:	60e2                	ld	ra,24(sp)
    80003286:	6442                	ld	s0,16(sp)
    80003288:	64a2                	ld	s1,8(sp)
    8000328a:	6105                	add	sp,sp,32
    8000328c:	8082                	ret

000000008000328e <killed>:

int
killed(struct proc *p)
{
    8000328e:	1101                	add	sp,sp,-32
    80003290:	ec06                	sd	ra,24(sp)
    80003292:	e822                	sd	s0,16(sp)
    80003294:	e426                	sd	s1,8(sp)
    80003296:	e04a                	sd	s2,0(sp)
    80003298:	1000                	add	s0,sp,32
    8000329a:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000329c:	ffffe097          	auipc	ra,0xffffe
    800032a0:	118080e7          	jalr	280(ra) # 800013b4 <acquire>
  k = p->killed;
    800032a4:	0284a903          	lw	s2,40(s1)
  release(&p->lock);
    800032a8:	8526                	mv	a0,s1
    800032aa:	ffffe097          	auipc	ra,0xffffe
    800032ae:	1be080e7          	jalr	446(ra) # 80001468 <release>
  return k;
}
    800032b2:	854a                	mv	a0,s2
    800032b4:	60e2                	ld	ra,24(sp)
    800032b6:	6442                	ld	s0,16(sp)
    800032b8:	64a2                	ld	s1,8(sp)
    800032ba:	6902                	ld	s2,0(sp)
    800032bc:	6105                	add	sp,sp,32
    800032be:	8082                	ret

00000000800032c0 <wait>:
{
    800032c0:	715d                	add	sp,sp,-80
    800032c2:	e486                	sd	ra,72(sp)
    800032c4:	e0a2                	sd	s0,64(sp)
    800032c6:	fc26                	sd	s1,56(sp)
    800032c8:	f84a                	sd	s2,48(sp)
    800032ca:	f44e                	sd	s3,40(sp)
    800032cc:	f052                	sd	s4,32(sp)
    800032ce:	ec56                	sd	s5,24(sp)
    800032d0:	e85a                	sd	s6,16(sp)
    800032d2:	e45e                	sd	s7,8(sp)
    800032d4:	e062                	sd	s8,0(sp)
    800032d6:	0880                	add	s0,sp,80
    800032d8:	8b2a                	mv	s6,a0
  struct proc *p = myproc();
    800032da:	fffff097          	auipc	ra,0xfffff
    800032de:	0aa080e7          	jalr	170(ra) # 80002384 <myproc>
    800032e2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800032e4:	0001e517          	auipc	a0,0x1e
    800032e8:	7dc50513          	add	a0,a0,2012 # 80021ac0 <wait_lock>
    800032ec:	ffffe097          	auipc	ra,0xffffe
    800032f0:	0c8080e7          	jalr	200(ra) # 800013b4 <acquire>
    havekids = 0;
    800032f4:	4b81                	li	s7,0
        if(pp->state == ZOMBIE){
    800032f6:	4a15                	li	s4,5
        havekids = 1;
    800032f8:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800032fa:	00026997          	auipc	s3,0x26
    800032fe:	dde98993          	add	s3,s3,-546 # 800290d8 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80003302:	0001ec17          	auipc	s8,0x1e
    80003306:	7bec0c13          	add	s8,s8,1982 # 80021ac0 <wait_lock>
    8000330a:	a0d1                	j	800033ce <wait+0x10e>
          pid = pp->pid;
    8000330c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80003310:	000b0e63          	beqz	s6,8000332c <wait+0x6c>
    80003314:	4691                	li	a3,4
    80003316:	02c48613          	add	a2,s1,44
    8000331a:	85da                	mv	a1,s6
    8000331c:	0b093503          	ld	a0,176(s2)
    80003320:	fffff097          	auipc	ra,0xfffff
    80003324:	cfc080e7          	jalr	-772(ra) # 8000201c <copyout>
    80003328:	04054163          	bltz	a0,8000336a <wait+0xaa>
          freeproc(pp);
    8000332c:	8526                	mv	a0,s1
    8000332e:	fffff097          	auipc	ra,0xfffff
    80003332:	2c6080e7          	jalr	710(ra) # 800025f4 <freeproc>
          release(&pp->lock);
    80003336:	8526                	mv	a0,s1
    80003338:	ffffe097          	auipc	ra,0xffffe
    8000333c:	130080e7          	jalr	304(ra) # 80001468 <release>
          release(&wait_lock);
    80003340:	0001e517          	auipc	a0,0x1e
    80003344:	78050513          	add	a0,a0,1920 # 80021ac0 <wait_lock>
    80003348:	ffffe097          	auipc	ra,0xffffe
    8000334c:	120080e7          	jalr	288(ra) # 80001468 <release>
}
    80003350:	854e                	mv	a0,s3
    80003352:	60a6                	ld	ra,72(sp)
    80003354:	6406                	ld	s0,64(sp)
    80003356:	74e2                	ld	s1,56(sp)
    80003358:	7942                	ld	s2,48(sp)
    8000335a:	79a2                	ld	s3,40(sp)
    8000335c:	7a02                	ld	s4,32(sp)
    8000335e:	6ae2                	ld	s5,24(sp)
    80003360:	6b42                	ld	s6,16(sp)
    80003362:	6ba2                	ld	s7,8(sp)
    80003364:	6c02                	ld	s8,0(sp)
    80003366:	6161                	add	sp,sp,80
    80003368:	8082                	ret
            release(&pp->lock);
    8000336a:	8526                	mv	a0,s1
    8000336c:	ffffe097          	auipc	ra,0xffffe
    80003370:	0fc080e7          	jalr	252(ra) # 80001468 <release>
            release(&wait_lock);
    80003374:	0001e517          	auipc	a0,0x1e
    80003378:	74c50513          	add	a0,a0,1868 # 80021ac0 <wait_lock>
    8000337c:	ffffe097          	auipc	ra,0xffffe
    80003380:	0ec080e7          	jalr	236(ra) # 80001468 <release>
            return -1;
    80003384:	59fd                	li	s3,-1
    80003386:	b7e9                	j	80003350 <wait+0x90>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80003388:	1c848493          	add	s1,s1,456
    8000338c:	03348463          	beq	s1,s3,800033b4 <wait+0xf4>
      if(pp->parent == p){
    80003390:	6cdc                	ld	a5,152(s1)
    80003392:	ff279be3          	bne	a5,s2,80003388 <wait+0xc8>
        acquire(&pp->lock);
    80003396:	8526                	mv	a0,s1
    80003398:	ffffe097          	auipc	ra,0xffffe
    8000339c:	01c080e7          	jalr	28(ra) # 800013b4 <acquire>
        if(pp->state == ZOMBIE){
    800033a0:	4c9c                	lw	a5,24(s1)
    800033a2:	f74785e3          	beq	a5,s4,8000330c <wait+0x4c>
        release(&pp->lock);
    800033a6:	8526                	mv	a0,s1
    800033a8:	ffffe097          	auipc	ra,0xffffe
    800033ac:	0c0080e7          	jalr	192(ra) # 80001468 <release>
        havekids = 1;
    800033b0:	8756                	mv	a4,s5
    800033b2:	bfd9                	j	80003388 <wait+0xc8>
    if(!havekids || killed(p)){
    800033b4:	c31d                	beqz	a4,800033da <wait+0x11a>
    800033b6:	854a                	mv	a0,s2
    800033b8:	00000097          	auipc	ra,0x0
    800033bc:	ed6080e7          	jalr	-298(ra) # 8000328e <killed>
    800033c0:	ed09                	bnez	a0,800033da <wait+0x11a>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800033c2:	85e2                	mv	a1,s8
    800033c4:	854a                	mv	a0,s2
    800033c6:	00000097          	auipc	ra,0x0
    800033ca:	c20080e7          	jalr	-992(ra) # 80002fe6 <sleep>
    havekids = 0;
    800033ce:	875e                	mv	a4,s7
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800033d0:	0001f497          	auipc	s1,0x1f
    800033d4:	b0848493          	add	s1,s1,-1272 # 80021ed8 <proc>
    800033d8:	bf65                	j	80003390 <wait+0xd0>
      release(&wait_lock);
    800033da:	0001e517          	auipc	a0,0x1e
    800033de:	6e650513          	add	a0,a0,1766 # 80021ac0 <wait_lock>
    800033e2:	ffffe097          	auipc	ra,0xffffe
    800033e6:	086080e7          	jalr	134(ra) # 80001468 <release>
      return -1;
    800033ea:	59fd                	li	s3,-1
    800033ec:	b795                	j	80003350 <wait+0x90>

00000000800033ee <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800033ee:	7179                	add	sp,sp,-48
    800033f0:	f406                	sd	ra,40(sp)
    800033f2:	f022                	sd	s0,32(sp)
    800033f4:	ec26                	sd	s1,24(sp)
    800033f6:	e84a                	sd	s2,16(sp)
    800033f8:	e44e                	sd	s3,8(sp)
    800033fa:	e052                	sd	s4,0(sp)
    800033fc:	1800                	add	s0,sp,48
    800033fe:	84aa                	mv	s1,a0
    80003400:	892e                	mv	s2,a1
    80003402:	89b2                	mv	s3,a2
    80003404:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    80003406:	fffff097          	auipc	ra,0xfffff
    8000340a:	f7e080e7          	jalr	-130(ra) # 80002384 <myproc>
  if(user_dst){
    8000340e:	c08d                	beqz	s1,80003430 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80003410:	86d2                	mv	a3,s4
    80003412:	864e                	mv	a2,s3
    80003414:	85ca                	mv	a1,s2
    80003416:	7948                	ld	a0,176(a0)
    80003418:	fffff097          	auipc	ra,0xfffff
    8000341c:	c04080e7          	jalr	-1020(ra) # 8000201c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80003420:	70a2                	ld	ra,40(sp)
    80003422:	7402                	ld	s0,32(sp)
    80003424:	64e2                	ld	s1,24(sp)
    80003426:	6942                	ld	s2,16(sp)
    80003428:	69a2                	ld	s3,8(sp)
    8000342a:	6a02                	ld	s4,0(sp)
    8000342c:	6145                	add	sp,sp,48
    8000342e:	8082                	ret
    memmove((char *)dst, src, len);
    80003430:	000a061b          	sext.w	a2,s4
    80003434:	85ce                	mv	a1,s3
    80003436:	854a                	mv	a0,s2
    80003438:	ffffe097          	auipc	ra,0xffffe
    8000343c:	0d4080e7          	jalr	212(ra) # 8000150c <memmove>
    return 0;
    80003440:	8526                	mv	a0,s1
    80003442:	bff9                	j	80003420 <either_copyout+0x32>

0000000080003444 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80003444:	7179                	add	sp,sp,-48
    80003446:	f406                	sd	ra,40(sp)
    80003448:	f022                	sd	s0,32(sp)
    8000344a:	ec26                	sd	s1,24(sp)
    8000344c:	e84a                	sd	s2,16(sp)
    8000344e:	e44e                	sd	s3,8(sp)
    80003450:	e052                	sd	s4,0(sp)
    80003452:	1800                	add	s0,sp,48
    80003454:	892a                	mv	s2,a0
    80003456:	84ae                	mv	s1,a1
    80003458:	89b2                	mv	s3,a2
    8000345a:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	f28080e7          	jalr	-216(ra) # 80002384 <myproc>
  if(user_src){
    80003464:	c08d                	beqz	s1,80003486 <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    80003466:	86d2                	mv	a3,s4
    80003468:	864e                	mv	a2,s3
    8000346a:	85ca                	mv	a1,s2
    8000346c:	7948                	ld	a0,176(a0)
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	c3a080e7          	jalr	-966(ra) # 800020a8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80003476:	70a2                	ld	ra,40(sp)
    80003478:	7402                	ld	s0,32(sp)
    8000347a:	64e2                	ld	s1,24(sp)
    8000347c:	6942                	ld	s2,16(sp)
    8000347e:	69a2                	ld	s3,8(sp)
    80003480:	6a02                	ld	s4,0(sp)
    80003482:	6145                	add	sp,sp,48
    80003484:	8082                	ret
    memmove(dst, (char*)src, len);
    80003486:	000a061b          	sext.w	a2,s4
    8000348a:	85ce                	mv	a1,s3
    8000348c:	854a                	mv	a0,s2
    8000348e:	ffffe097          	auipc	ra,0xffffe
    80003492:	07e080e7          	jalr	126(ra) # 8000150c <memmove>
    return 0;
    80003496:	8526                	mv	a0,s1
    80003498:	bff9                	j	80003476 <either_copyin+0x32>

000000008000349a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000349a:	715d                	add	sp,sp,-80
    8000349c:	e486                	sd	ra,72(sp)
    8000349e:	e0a2                	sd	s0,64(sp)
    800034a0:	fc26                	sd	s1,56(sp)
    800034a2:	f84a                	sd	s2,48(sp)
    800034a4:	f44e                	sd	s3,40(sp)
    800034a6:	f052                	sd	s4,32(sp)
    800034a8:	ec56                	sd	s5,24(sp)
    800034aa:	e85a                	sd	s6,16(sp)
    800034ac:	e45e                	sd	s7,8(sp)
    800034ae:	0880                	add	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800034b0:	00006517          	auipc	a0,0x6
    800034b4:	b9050513          	add	a0,a0,-1136 # 80009040 <etext+0x40>
    800034b8:	ffffd097          	auipc	ra,0xffffd
    800034bc:	128080e7          	jalr	296(ra) # 800005e0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800034c0:	0001f497          	auipc	s1,0x1f
    800034c4:	bd048493          	add	s1,s1,-1072 # 80022090 <proc+0x1b8>
    800034c8:	00026917          	auipc	s2,0x26
    800034cc:	dc890913          	add	s2,s2,-568 # 80029290 <bcache+0x188>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800034d0:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800034d2:	00006997          	auipc	s3,0x6
    800034d6:	01698993          	add	s3,s3,22 # 800094e8 <etext+0x4e8>
    printf("%d %s %s", p->pid, state, p->name);
    800034da:	00006a97          	auipc	s5,0x6
    800034de:	016a8a93          	add	s5,s5,22 # 800094f0 <etext+0x4f0>
    printf("\n");
    800034e2:	00006a17          	auipc	s4,0x6
    800034e6:	b5ea0a13          	add	s4,s4,-1186 # 80009040 <etext+0x40>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800034ea:	00006b97          	auipc	s7,0x6
    800034ee:	4deb8b93          	add	s7,s7,1246 # 800099c8 <states.0>
    800034f2:	a00d                	j	80003514 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    800034f4:	e786a583          	lw	a1,-392(a3)
    800034f8:	8556                	mv	a0,s5
    800034fa:	ffffd097          	auipc	ra,0xffffd
    800034fe:	0e6080e7          	jalr	230(ra) # 800005e0 <printf>
    printf("\n");
    80003502:	8552                	mv	a0,s4
    80003504:	ffffd097          	auipc	ra,0xffffd
    80003508:	0dc080e7          	jalr	220(ra) # 800005e0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000350c:	1c848493          	add	s1,s1,456
    80003510:	03248263          	beq	s1,s2,80003534 <procdump+0x9a>
    if(p->state == UNUSED)
    80003514:	86a6                	mv	a3,s1
    80003516:	e604a783          	lw	a5,-416(s1)
    8000351a:	dbed                	beqz	a5,8000350c <procdump+0x72>
      state = "???";
    8000351c:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000351e:	fcfb6be3          	bltu	s6,a5,800034f4 <procdump+0x5a>
    80003522:	02079713          	sll	a4,a5,0x20
    80003526:	01d75793          	srl	a5,a4,0x1d
    8000352a:	97de                	add	a5,a5,s7
    8000352c:	6390                	ld	a2,0(a5)
    8000352e:	f279                	bnez	a2,800034f4 <procdump+0x5a>
      state = "???";
    80003530:	864e                	mv	a2,s3
    80003532:	b7c9                	j	800034f4 <procdump+0x5a>
  }
}
    80003534:	60a6                	ld	ra,72(sp)
    80003536:	6406                	ld	s0,64(sp)
    80003538:	74e2                	ld	s1,56(sp)
    8000353a:	7942                	ld	s2,48(sp)
    8000353c:	79a2                	ld	s3,40(sp)
    8000353e:	7a02                	ld	s4,32(sp)
    80003540:	6ae2                	ld	s5,24(sp)
    80003542:	6b42                	ld	s6,16(sp)
    80003544:	6ba2                	ld	s7,8(sp)
    80003546:	6161                	add	sp,sp,80
    80003548:	8082                	ret

000000008000354a <pagefault>:


void
pagefault(uint64 scause, uint64 stval)
{
    8000354a:	715d                	add	sp,sp,-80
    8000354c:	e486                	sd	ra,72(sp)
    8000354e:	e0a2                	sd	s0,64(sp)
    80003550:	fc26                	sd	s1,56(sp)
    80003552:	f84a                	sd	s2,48(sp)
    80003554:	f052                	sd	s4,32(sp)
    80003556:	e85a                	sd	s6,16(sp)
    80003558:	0880                	add	s0,sp,80
    8000355a:	8b2a                	mv	s6,a0
    8000355c:	84ae                	mv	s1,a1
  pagefaults++;
    8000355e:	00006717          	auipc	a4,0x6
    80003562:	61270713          	add	a4,a4,1554 # 80009b70 <pagefaults>
    80003566:	431c                	lw	a5,0(a4)
    80003568:	2785                	addw	a5,a5,1
    8000356a:	c31c                	sw	a5,0(a4)
  //stval is va

  int is_mmaped = 0;
  struct proc *p = myproc();
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	e18080e7          	jalr	-488(ra) # 80002384 <myproc>
    80003574:	892a                	mv	s2,a0

  acquire(&mmaplock);
    80003576:	00026517          	auipc	a0,0x26
    8000357a:	b7a50513          	add	a0,a0,-1158 # 800290f0 <mmaplock>
    8000357e:	ffffe097          	auipc	ra,0xffffe
    80003582:	e36080e7          	jalr	-458(ra) # 800013b4 <acquire>

  uint64 addr, length, b, flags, huge_page, prot;

  // find mapping
  // remember order : address-length-(prot | ishuge | flags)
  for(int i=0;i <12; i+=3)
    80003586:	03890793          	add	a5,s2,56
    8000358a:	09890613          	add	a2,s2,152
    8000358e:	a84d                	j	80003640 <pagefault+0xf6>
    // make perm(valid bit 1)
    uint64 perm = 1;
    
    // read/write 
    if(prot == PROT_READ)
      perm += 2;
    80003590:	478d                	li	a5,3
    80003592:	a0e5                	j	8000367a <pagefault+0x130>
        addr = PGROUNDDOWN(stval);
    80003594:	79fd                	lui	s3,0xfffff
    80003596:	0134f9b3          	and	s3,s1,s3
    
    // make perm(valid bit 1)
    uint64 perm = 1;
    
    // read/write 
    if(prot == PROT_READ)
    8000359a:	4705                	li	a4,1
      perm += 2;
    else
      perm += 6;
    8000359c:	479d                	li	a5,7
    if(prot == PROT_READ)
    8000359e:	08e60c63          	beq	a2,a4,80003636 <pagefault+0xec>

    // allow user access
    perm += 16;

    // private/shared(private is 1 on 9th block(256))
    if(flags == MAP_PRIVATE)
    800035a2:	4741                	li	a4,16
      perm += 256;
    800035a4:	11078c13          	add	s8,a5,272
    if(flags == MAP_PRIVATE)
    800035a8:	00e68463          	beq	a3,a4,800035b0 <pagefault+0x66>
    perm += 16;
    800035ac:	01078c13          	add	s8,a5,16
    // doesn't check validity(or actual mapping 여부) for the PTE 


    // TODO : need to map for "all" lengths    

    pte_t* leaf_pte = walk(p->pagetable, addr, 1);
    800035b0:	4605                	li	a2,1
    800035b2:	85ce                	mv	a1,s3
    800035b4:	0b093503          	ld	a0,176(s2)
    800035b8:	ffffe097          	auipc	ra,0xffffe
    800035bc:	1e0080e7          	jalr	480(ra) # 80001798 <walk>
    800035c0:	8aaa                	mv	s5,a0

    uint64 pa = 0;

    // checks validity
    if(*leaf_pte & PTE_V)
    800035c2:	611c                	ld	a5,0(a0)
    800035c4:	0017f713          	and	a4,a5,1
    800035c8:	32070a63          	beqz	a4,800038fc <pagefault+0x3b2>
    {
    // mapping already exists

      // catch writing to read-only violation
      if(scause == 15 && ((*leaf_pte & PTE_W) == 0))
    800035cc:	473d                	li	a4,15
    800035ce:	34eb1863          	bne	s6,a4,8000391e <pagefault+0x3d4>
    800035d2:	0047f713          	and	a4,a5,4
    800035d6:	34071463          	bnez	a4,8000391e <pagefault+0x3d4>
      {
        if(((*leaf_pte & PTE_CoW) == 0x300) && ((*leaf_pte & PTE_R) != 0))
    800035da:	3027f793          	and	a5,a5,770
    800035de:	30200713          	li	a4,770
    800035e2:	2ae78d63          	beq	a5,a4,8000389c <pagefault+0x352>

          release(&mmaplock);
          return;
        }

        release(&mmaplock);
    800035e6:	00026517          	auipc	a0,0x26
    800035ea:	b0a50513          	add	a0,a0,-1270 # 800290f0 <mmaplock>
    800035ee:	ffffe097          	auipc	ra,0xffffe
    800035f2:	e7a080e7          	jalr	-390(ra) # 80001468 <release>
        printf("usertrap(): unexpected scause %p pid=%d\n", scause, p->pid);
    800035f6:	03092603          	lw	a2,48(s2)
    800035fa:	45bd                	li	a1,15
    800035fc:	00006517          	auipc	a0,0x6
    80003600:	f0450513          	add	a0,a0,-252 # 80009500 <etext+0x500>
    80003604:	ffffd097          	auipc	ra,0xffffd
    80003608:	fdc080e7          	jalr	-36(ra) # 800005e0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000360c:	141025f3          	csrr	a1,sepc
        printf("            sepc=%p stval=%p\n", r_sepc(), stval);
    80003610:	8626                	mv	a2,s1
    80003612:	00006517          	auipc	a0,0x6
    80003616:	f1e50513          	add	a0,a0,-226 # 80009530 <etext+0x530>
    8000361a:	ffffd097          	auipc	ra,0xffffd
    8000361e:	fc6080e7          	jalr	-58(ra) # 800005e0 <printf>
        setkilled(p);
    80003622:	854a                	mv	a0,s2
    80003624:	00000097          	auipc	ra,0x0
    80003628:	c3e080e7          	jalr	-962(ra) # 80003262 <setkilled>
        return;
    8000362c:	79a2                	ld	s3,40(sp)
    8000362e:	6ae2                	ld	s5,24(sp)
    80003630:	6ba2                	ld	s7,8(sp)
    80003632:	6c02                	ld	s8,0(sp)
    80003634:	a609                	j	80003936 <pagefault+0x3ec>
      perm += 2;
    80003636:	478d                	li	a5,3
    80003638:	b7ad                	j	800035a2 <pagefault+0x58>
  for(int i=0;i <12; i+=3)
    8000363a:	07e1                	add	a5,a5,24
    8000363c:	0cc78963          	beq	a5,a2,8000370e <pagefault+0x1c4>
    addr = p->mmap_list[i];
    80003640:	6398                	ld	a4,0(a5)
    length = p->mmap_list[i+1];
    80003642:	6794                	ld	a3,8(a5)
    b = p->mmap_list[i+2];
    80003644:	0107ba03          	ld	s4,16(a5)
    if(addr == 0)
    80003648:	db6d                	beqz	a4,8000363a <pagefault+0xf0>
    if(addr <= stval && stval < addr + length)
    8000364a:	fee4e8e3          	bltu	s1,a4,8000363a <pagefault+0xf0>
    8000364e:	9736                	add	a4,a4,a3
    80003650:	fee4f5e3          	bgeu	s1,a4,8000363a <pagefault+0xf0>
    80003654:	f44e                	sd	s3,40(sp)
    80003656:	ec56                	sd	s5,24(sp)
    80003658:	e45e                	sd	s7,8(sp)
    8000365a:	e062                	sd	s8,0(sp)
    flags = (b & FLAG_MASK);
    8000365c:	0f0a7693          	and	a3,s4,240
    prot = (b & PROT_MASK);
    80003660:	00fa7613          	and	a2,s4,15
    huge_page = (b & HUGE_MASK);
    80003664:	100a7793          	and	a5,s4,256
      if(huge_page)
    80003668:	d795                	beqz	a5,80003594 <pagefault+0x4a>
        addr = HUGEPGROUNDDOWN(stval);
    8000366a:	ffe009b7          	lui	s3,0xffe00
    8000366e:	0134f9b3          	and	s3,s1,s3
    if(prot == PROT_READ)
    80003672:	4705                	li	a4,1
      perm += 6;
    80003674:	479d                	li	a5,7
    if(prot == PROT_READ)
    80003676:	f0e60de3          	beq	a2,a4,80003590 <pagefault+0x46>
    if(flags == MAP_PRIVATE)
    8000367a:	4741                	li	a4,16
      perm += 256;
    8000367c:	11078c13          	add	s8,a5,272
    if(flags == MAP_PRIVATE)
    80003680:	00e68463          	beq	a3,a4,80003688 <pagefault+0x13e>
    perm += 16;
    80003684:	01078c13          	add	s8,a5,16
    pte_t* leaf_pte = walk_huge(p->pagetable, addr, 1);
    80003688:	4605                	li	a2,1
    8000368a:	85ce                	mv	a1,s3
    8000368c:	0b093503          	ld	a0,176(s2)
    80003690:	ffffe097          	auipc	ra,0xffffe
    80003694:	1ae080e7          	jalr	430(ra) # 8000183e <walk_huge>
    80003698:	8aaa                	mv	s5,a0
    if(*leaf_pte & PTE_V)
    8000369a:	611c                	ld	a5,0(a0)
    8000369c:	0017f713          	and	a4,a5,1
    800036a0:	10070c63          	beqz	a4,800037b8 <pagefault+0x26e>
      if(scause == 15 && ((*leaf_pte & PTE_W) == 0))
    800036a4:	473d                	li	a4,15
    800036a6:	26eb1c63          	bne	s6,a4,8000391e <pagefault+0x3d4>
    800036aa:	0047f713          	and	a4,a5,4
    800036ae:	26071863          	bnez	a4,8000391e <pagefault+0x3d4>
        if(((*leaf_pte & PTE_CoW) == 0x300) && ((*leaf_pte & PTE_R) != 0))
    800036b2:	3027f793          	and	a5,a5,770
    800036b6:	30200713          	li	a4,770
    800036ba:	08e78e63          	beq	a5,a4,80003756 <pagefault+0x20c>
        release(&mmaplock);
    800036be:	00026517          	auipc	a0,0x26
    800036c2:	a3250513          	add	a0,a0,-1486 # 800290f0 <mmaplock>
    800036c6:	ffffe097          	auipc	ra,0xffffe
    800036ca:	da2080e7          	jalr	-606(ra) # 80001468 <release>
        printf("usertrap(): unexpected scause %p pid=%d\n", scause, p->pid);
    800036ce:	03092603          	lw	a2,48(s2)
    800036d2:	45bd                	li	a1,15
    800036d4:	00006517          	auipc	a0,0x6
    800036d8:	e2c50513          	add	a0,a0,-468 # 80009500 <etext+0x500>
    800036dc:	ffffd097          	auipc	ra,0xffffd
    800036e0:	f04080e7          	jalr	-252(ra) # 800005e0 <printf>
    800036e4:	141025f3          	csrr	a1,sepc
        printf("            sepc=%p stval=%p\n", r_sepc(), stval);
    800036e8:	8626                	mv	a2,s1
    800036ea:	00006517          	auipc	a0,0x6
    800036ee:	e4650513          	add	a0,a0,-442 # 80009530 <etext+0x530>
    800036f2:	ffffd097          	auipc	ra,0xffffd
    800036f6:	eee080e7          	jalr	-274(ra) # 800005e0 <printf>
        setkilled(p);
    800036fa:	854a                	mv	a0,s2
    800036fc:	00000097          	auipc	ra,0x0
    80003700:	b66080e7          	jalr	-1178(ra) # 80003262 <setkilled>
        return;
    80003704:	79a2                	ld	s3,40(sp)
    80003706:	6ae2                	ld	s5,24(sp)
    80003708:	6ba2                	ld	s7,8(sp)
    8000370a:	6c02                	ld	s8,0(sp)
    8000370c:	a42d                	j	80003936 <pagefault+0x3ec>
    release(&mmaplock);
    8000370e:	00026517          	auipc	a0,0x26
    80003712:	9e250513          	add	a0,a0,-1566 # 800290f0 <mmaplock>
    80003716:	ffffe097          	auipc	ra,0xffffe
    8000371a:	d52080e7          	jalr	-686(ra) # 80001468 <release>
    printf("usertrap(): unexpected scause %p pid=%d\n", scause, p->pid);
    8000371e:	03092603          	lw	a2,48(s2)
    80003722:	85da                	mv	a1,s6
    80003724:	00006517          	auipc	a0,0x6
    80003728:	ddc50513          	add	a0,a0,-548 # 80009500 <etext+0x500>
    8000372c:	ffffd097          	auipc	ra,0xffffd
    80003730:	eb4080e7          	jalr	-332(ra) # 800005e0 <printf>
    80003734:	141025f3          	csrr	a1,sepc
    printf("            sepc=%p stval=%p\n", r_sepc(), stval);
    80003738:	8626                	mv	a2,s1
    8000373a:	00006517          	auipc	a0,0x6
    8000373e:	df650513          	add	a0,a0,-522 # 80009530 <etext+0x530>
    80003742:	ffffd097          	auipc	ra,0xffffd
    80003746:	e9e080e7          	jalr	-354(ra) # 800005e0 <printf>
    setkilled(p);
    8000374a:	854a                	mv	a0,s2
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	b16080e7          	jalr	-1258(ra) # 80003262 <setkilled>
    return;
    80003754:	a2cd                	j	80003936 <pagefault+0x3ec>
          uint64* new_page = kalloc_huge();
    80003756:	ffffe097          	auipc	ra,0xffffe
    8000375a:	a0e080e7          	jalr	-1522(ra) # 80001164 <kalloc_huge>
    8000375e:	84aa                	mv	s1,a0
          memmove(new_page, (void*)PTE2PA(*leaf_pte), HUGEPGSIZE);
    80003760:	000ab583          	ld	a1,0(s5)
    80003764:	81a9                	srl	a1,a1,0xa
    80003766:	00200637          	lui	a2,0x200
    8000376a:	05b2                	sll	a1,a1,0xc
    8000376c:	ffffe097          	auipc	ra,0xffffe
    80003770:	da0080e7          	jalr	-608(ra) # 8000150c <memmove>
          kfree_huge((void*)PTE2PA(*leaf_pte));
    80003774:	000ab503          	ld	a0,0(s5)
    80003778:	8129                	srl	a0,a0,0xa
    8000377a:	0532                	sll	a0,a0,0xc
    8000377c:	ffffe097          	auipc	ra,0xffffe
    80003780:	aa2080e7          	jalr	-1374(ra) # 8000121e <kfree_huge>
          *leaf_pte = PA2PTE(new_page) | create_pte_flag(b,0,0);
    80003784:	4601                	li	a2,0
    80003786:	4581                	li	a1,0
    80003788:	8552                	mv	a0,s4
    8000378a:	fffff097          	auipc	ra,0xfffff
    8000378e:	070080e7          	jalr	112(ra) # 800027fa <create_pte_flag>
    80003792:	00c4d793          	srl	a5,s1,0xc
    80003796:	07aa                	sll	a5,a5,0xa
    80003798:	8fc9                	or	a5,a5,a0
    8000379a:	00fab023          	sd	a5,0(s5)
          release(&mmaplock);
    8000379e:	00026517          	auipc	a0,0x26
    800037a2:	95250513          	add	a0,a0,-1710 # 800290f0 <mmaplock>
    800037a6:	ffffe097          	auipc	ra,0xffffe
    800037aa:	cc2080e7          	jalr	-830(ra) # 80001468 <release>
          return;
    800037ae:	79a2                	ld	s3,40(sp)
    800037b0:	6ae2                	ld	s5,24(sp)
    800037b2:	6ba2                	ld	s7,8(sp)
    800037b4:	6c02                	ld	s8,0(sp)
    800037b6:	a241                	j	80003936 <pagefault+0x3ec>
      if(((*leaf_pte & PTE_CoW) == 0x200) && ((*leaf_pte & PTE_R) != 0))
    800037b8:	3027f793          	and	a5,a5,770
    800037bc:	20200713          	li	a4,514
    800037c0:	00e78e63          	beq	a5,a4,800037dc <pagefault+0x292>
      pa = (uint64)kalloc_huge();
    800037c4:	ffffe097          	auipc	ra,0xffffe
    800037c8:	9a0080e7          	jalr	-1632(ra) # 80001164 <kalloc_huge>
      *leaf_pte = PA2PTE(pa) | perm; 
    800037cc:	00c55793          	srl	a5,a0,0xc
    800037d0:	07aa                	sll	a5,a5,0xa
    800037d2:	0187e7b3          	or	a5,a5,s8
    800037d6:	00fab023          	sd	a5,0(s5)
    800037da:	a291                	j	8000391e <pagefault+0x3d4>
        pa = (uint64)kalloc_huge();
    800037dc:	ffffe097          	auipc	ra,0xffffe
    800037e0:	988080e7          	jalr	-1656(ra) # 80001164 <kalloc_huge>
    800037e4:	8baa                	mv	s7,a0
        *leaf_pte = PA2PTE(pa) | perm;
    800037e6:	00c55793          	srl	a5,a0,0xc
    800037ea:	07aa                	sll	a5,a5,0xa
    800037ec:	0187e7b3          	or	a5,a5,s8
    800037f0:	00fab023          	sd	a5,0(s5)
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
    800037f4:	0001e497          	auipc	s1,0x1e
    800037f8:	6e448493          	add	s1,s1,1764 # 80021ed8 <proc>
          if(((*np_pte & PTE_CoW) == 0x200) && ((*np_pte & PTE_R) != 0) && ((*np_pte & PTE_V) == 0))
    800037fc:	20200b13          	li	s6,514
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
    80003800:	00026a17          	auipc	s4,0x26
    80003804:	8d8a0a13          	add	s4,s4,-1832 # 800290d8 <tickslock>
    80003808:	a825                	j	80003840 <pagefault+0x2f6>
            release(&np->lock);
    8000380a:	8526                	mv	a0,s1
    8000380c:	ffffe097          	auipc	ra,0xffffe
    80003810:	c5c080e7          	jalr	-932(ra) # 80001468 <release>
            continue;
    80003814:	a015                	j	80003838 <pagefault+0x2ee>
            release(&np->lock);
    80003816:	8526                	mv	a0,s1
    80003818:	ffffe097          	auipc	ra,0xffffe
    8000381c:	c50080e7          	jalr	-944(ra) # 80001468 <release>
            continue;
    80003820:	a821                	j	80003838 <pagefault+0x2ee>
            release(&np->lock);
    80003822:	8526                	mv	a0,s1
    80003824:	ffffe097          	auipc	ra,0xffffe
    80003828:	c44080e7          	jalr	-956(ra) # 80001468 <release>
            continue;
    8000382c:	a031                	j	80003838 <pagefault+0x2ee>
          release(&np->lock);
    8000382e:	8526                	mv	a0,s1
    80003830:	ffffe097          	auipc	ra,0xffffe
    80003834:	c38080e7          	jalr	-968(ra) # 80001468 <release>
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
    80003838:	1c848493          	add	s1,s1,456
    8000383c:	05448363          	beq	s1,s4,80003882 <pagefault+0x338>
          acquire(&np->lock);
    80003840:	8526                	mv	a0,s1
    80003842:	ffffe097          	auipc	ra,0xffffe
    80003846:	b72080e7          	jalr	-1166(ra) # 800013b4 <acquire>
          if(np->pagetable ==0)
    8000384a:	78c8                	ld	a0,176(s1)
    8000384c:	dd5d                	beqz	a0,8000380a <pagefault+0x2c0>
          if(np->pid == p->pid)
    8000384e:	5898                	lw	a4,48(s1)
    80003850:	03092783          	lw	a5,48(s2)
    80003854:	fcf701e3          	beq	a4,a5,80003816 <pagefault+0x2cc>
          pte_t* np_pte = walk_huge(np->pagetable, addr, 0);
    80003858:	4601                	li	a2,0
    8000385a:	85ce                	mv	a1,s3
    8000385c:	ffffe097          	auipc	ra,0xffffe
    80003860:	fe2080e7          	jalr	-30(ra) # 8000183e <walk_huge>
          if(np_pte == 0)
    80003864:	dd5d                	beqz	a0,80003822 <pagefault+0x2d8>
          if(((*np_pte & PTE_CoW) == 0x200) && ((*np_pte & PTE_R) != 0) && ((*np_pte & PTE_V) == 0))
    80003866:	611c                	ld	a5,0(a0)
    80003868:	3037f793          	and	a5,a5,771
    8000386c:	fd6791e3          	bne	a5,s6,8000382e <pagefault+0x2e4>
            *np_pte = *leaf_pte;
    80003870:	000ab783          	ld	a5,0(s5)
    80003874:	e11c                	sd	a5,0(a0)
            incr_huge_pa_ref((void*)pa);
    80003876:	855e                	mv	a0,s7
    80003878:	ffffd097          	auipc	ra,0xffffd
    8000387c:	3b6080e7          	jalr	950(ra) # 80000c2e <incr_huge_pa_ref>
    80003880:	b77d                	j	8000382e <pagefault+0x2e4>
        release(&mmaplock);
    80003882:	00026517          	auipc	a0,0x26
    80003886:	86e50513          	add	a0,a0,-1938 # 800290f0 <mmaplock>
    8000388a:	ffffe097          	auipc	ra,0xffffe
    8000388e:	bde080e7          	jalr	-1058(ra) # 80001468 <release>
        return;
    80003892:	79a2                	ld	s3,40(sp)
    80003894:	6ae2                	ld	s5,24(sp)
    80003896:	6ba2                	ld	s7,8(sp)
    80003898:	6c02                	ld	s8,0(sp)
    8000389a:	a871                	j	80003936 <pagefault+0x3ec>
          uint64* new_page = kalloc();
    8000389c:	ffffd097          	auipc	ra,0xffffd
    800038a0:	78a080e7          	jalr	1930(ra) # 80001026 <kalloc>
    800038a4:	84aa                	mv	s1,a0
          memmove(new_page, (void*)PTE2PA(*leaf_pte), PGSIZE);
    800038a6:	000ab583          	ld	a1,0(s5)
    800038aa:	81a9                	srl	a1,a1,0xa
    800038ac:	6605                	lui	a2,0x1
    800038ae:	05b2                	sll	a1,a1,0xc
    800038b0:	ffffe097          	auipc	ra,0xffffe
    800038b4:	c5c080e7          	jalr	-932(ra) # 8000150c <memmove>
          kfree((void*)PTE2PA(*leaf_pte));
    800038b8:	000ab503          	ld	a0,0(s5)
    800038bc:	8129                	srl	a0,a0,0xa
    800038be:	0532                	sll	a0,a0,0xc
    800038c0:	ffffd097          	auipc	ra,0xffffd
    800038c4:	508080e7          	jalr	1288(ra) # 80000dc8 <kfree>
          *leaf_pte = PA2PTE(new_page) | create_pte_flag(b,0,0);
    800038c8:	4601                	li	a2,0
    800038ca:	4581                	li	a1,0
    800038cc:	8552                	mv	a0,s4
    800038ce:	fffff097          	auipc	ra,0xfffff
    800038d2:	f2c080e7          	jalr	-212(ra) # 800027fa <create_pte_flag>
    800038d6:	00c4d793          	srl	a5,s1,0xc
    800038da:	07aa                	sll	a5,a5,0xa
    800038dc:	8fc9                	or	a5,a5,a0
    800038de:	00fab023          	sd	a5,0(s5)
          release(&mmaplock);
    800038e2:	00026517          	auipc	a0,0x26
    800038e6:	80e50513          	add	a0,a0,-2034 # 800290f0 <mmaplock>
    800038ea:	ffffe097          	auipc	ra,0xffffe
    800038ee:	b7e080e7          	jalr	-1154(ra) # 80001468 <release>
          return;
    800038f2:	79a2                	ld	s3,40(sp)
    800038f4:	6ae2                	ld	s5,24(sp)
    800038f6:	6ba2                	ld	s7,8(sp)
    800038f8:	6c02                	ld	s8,0(sp)
    800038fa:	a835                	j	80003936 <pagefault+0x3ec>
    }
    else
    {
      // catch read/write to shared pages that were not alloc'd
      // isCow flag on + isShared + readable
      if(((*leaf_pte & PTE_CoW) == 0x200) && ((*leaf_pte & PTE_R) != 0))
    800038fc:	3027f793          	and	a5,a5,770
    80003900:	20200713          	li	a4,514
    80003904:	04e78163          	beq	a5,a4,80003946 <pagefault+0x3fc>
        release(&mmaplock);
        return;
      }

      // map the actual PA to VA
      pa = (uint64)kalloc();
    80003908:	ffffd097          	auipc	ra,0xffffd
    8000390c:	71e080e7          	jalr	1822(ra) # 80001026 <kalloc>

      *leaf_pte = PA2PTE(pa) | perm;
    80003910:	00c55793          	srl	a5,a0,0xc
    80003914:	07aa                	sll	a5,a5,0xa
    80003916:	0187e7b3          	or	a5,a5,s8
    8000391a:	00fab023          	sd	a5,0(s5)
    }
      
    //printf("va : %p, pa : %p, &PTE : %p, PTE: %p\n",addr, pa, leaf_pte, *leaf_pte);

  }
  release(&mmaplock);
    8000391e:	00025517          	auipc	a0,0x25
    80003922:	7d250513          	add	a0,a0,2002 # 800290f0 <mmaplock>
    80003926:	ffffe097          	auipc	ra,0xffffe
    8000392a:	b42080e7          	jalr	-1214(ra) # 80001468 <release>
    8000392e:	79a2                	ld	s3,40(sp)
    80003930:	6ae2                	ld	s5,24(sp)
    80003932:	6ba2                	ld	s7,8(sp)
    80003934:	6c02                	ld	s8,0(sp)

  // PA4: FILL HERE
  
  //panic("page fault he he");
}
    80003936:	60a6                	ld	ra,72(sp)
    80003938:	6406                	ld	s0,64(sp)
    8000393a:	74e2                	ld	s1,56(sp)
    8000393c:	7942                	ld	s2,48(sp)
    8000393e:	7a02                	ld	s4,32(sp)
    80003940:	6b42                	ld	s6,16(sp)
    80003942:	6161                	add	sp,sp,80
    80003944:	8082                	ret
        pa = (uint64)kalloc();
    80003946:	ffffd097          	auipc	ra,0xffffd
    8000394a:	6e0080e7          	jalr	1760(ra) # 80001026 <kalloc>
    8000394e:	8baa                	mv	s7,a0
        *leaf_pte = PA2PTE(pa) | perm;
    80003950:	00c55793          	srl	a5,a0,0xc
    80003954:	07aa                	sll	a5,a5,0xa
    80003956:	0187e7b3          	or	a5,a5,s8
    8000395a:	00fab023          	sd	a5,0(s5)
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
    8000395e:	0001e497          	auipc	s1,0x1e
    80003962:	57a48493          	add	s1,s1,1402 # 80021ed8 <proc>
          if(((*np_pte & PTE_CoW) == 0x200) && ((*np_pte & PTE_R) != 0) && ((*np_pte & PTE_V) == 0))
    80003966:	20200b13          	li	s6,514
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
    8000396a:	00025a17          	auipc	s4,0x25
    8000396e:	76ea0a13          	add	s4,s4,1902 # 800290d8 <tickslock>
    80003972:	a825                	j	800039aa <pagefault+0x460>
            release(&np->lock);
    80003974:	8526                	mv	a0,s1
    80003976:	ffffe097          	auipc	ra,0xffffe
    8000397a:	af2080e7          	jalr	-1294(ra) # 80001468 <release>
            continue;
    8000397e:	a015                	j	800039a2 <pagefault+0x458>
            release(&np->lock);
    80003980:	8526                	mv	a0,s1
    80003982:	ffffe097          	auipc	ra,0xffffe
    80003986:	ae6080e7          	jalr	-1306(ra) # 80001468 <release>
            continue;
    8000398a:	a821                	j	800039a2 <pagefault+0x458>
            release(&np->lock);
    8000398c:	8526                	mv	a0,s1
    8000398e:	ffffe097          	auipc	ra,0xffffe
    80003992:	ada080e7          	jalr	-1318(ra) # 80001468 <release>
            continue;
    80003996:	a031                	j	800039a2 <pagefault+0x458>
          release(&np->lock);
    80003998:	8526                	mv	a0,s1
    8000399a:	ffffe097          	auipc	ra,0xffffe
    8000399e:	ace080e7          	jalr	-1330(ra) # 80001468 <release>
        for(struct proc* np = proc; np < &proc[NPROC]; np++) 
    800039a2:	1c848493          	add	s1,s1,456
    800039a6:	05448363          	beq	s1,s4,800039ec <pagefault+0x4a2>
          acquire(&np->lock);
    800039aa:	8526                	mv	a0,s1
    800039ac:	ffffe097          	auipc	ra,0xffffe
    800039b0:	a08080e7          	jalr	-1528(ra) # 800013b4 <acquire>
          if(np->pagetable ==0)
    800039b4:	78c8                	ld	a0,176(s1)
    800039b6:	dd5d                	beqz	a0,80003974 <pagefault+0x42a>
          if(np->pid == p->pid)
    800039b8:	5898                	lw	a4,48(s1)
    800039ba:	03092783          	lw	a5,48(s2)
    800039be:	fcf701e3          	beq	a4,a5,80003980 <pagefault+0x436>
          pte_t* np_pte = walk(np->pagetable, addr, 0);
    800039c2:	4601                	li	a2,0
    800039c4:	85ce                	mv	a1,s3
    800039c6:	ffffe097          	auipc	ra,0xffffe
    800039ca:	dd2080e7          	jalr	-558(ra) # 80001798 <walk>
          if(np_pte == 0)
    800039ce:	dd5d                	beqz	a0,8000398c <pagefault+0x442>
          if(((*np_pte & PTE_CoW) == 0x200) && ((*np_pte & PTE_R) != 0) && ((*np_pte & PTE_V) == 0))
    800039d0:	611c                	ld	a5,0(a0)
    800039d2:	3037f793          	and	a5,a5,771
    800039d6:	fd6791e3          	bne	a5,s6,80003998 <pagefault+0x44e>
            *np_pte = *leaf_pte;
    800039da:	000ab783          	ld	a5,0(s5)
    800039de:	e11c                	sd	a5,0(a0)
            incr_pa_ref((void*)pa);
    800039e0:	855e                	mv	a0,s7
    800039e2:	ffffd097          	auipc	ra,0xffffd
    800039e6:	2ca080e7          	jalr	714(ra) # 80000cac <incr_pa_ref>
    800039ea:	b77d                	j	80003998 <pagefault+0x44e>
        release(&mmaplock);
    800039ec:	00025517          	auipc	a0,0x25
    800039f0:	70450513          	add	a0,a0,1796 # 800290f0 <mmaplock>
    800039f4:	ffffe097          	auipc	ra,0xffffe
    800039f8:	a74080e7          	jalr	-1420(ra) # 80001468 <release>
        return;
    800039fc:	79a2                	ld	s3,40(sp)
    800039fe:	6ae2                	ld	s5,24(sp)
    80003a00:	6ba2                	ld	s7,8(sp)
    80003a02:	6c02                	ld	s8,0(sp)
    80003a04:	bf0d                	j	80003936 <pagefault+0x3ec>

0000000080003a06 <swtch>:
    80003a06:	00153023          	sd	ra,0(a0)
    80003a0a:	00253423          	sd	sp,8(a0)
    80003a0e:	e900                	sd	s0,16(a0)
    80003a10:	ed04                	sd	s1,24(a0)
    80003a12:	03253023          	sd	s2,32(a0)
    80003a16:	03353423          	sd	s3,40(a0)
    80003a1a:	03453823          	sd	s4,48(a0)
    80003a1e:	03553c23          	sd	s5,56(a0)
    80003a22:	05653023          	sd	s6,64(a0)
    80003a26:	05753423          	sd	s7,72(a0)
    80003a2a:	05853823          	sd	s8,80(a0)
    80003a2e:	05953c23          	sd	s9,88(a0)
    80003a32:	07a53023          	sd	s10,96(a0)
    80003a36:	07b53423          	sd	s11,104(a0)
    80003a3a:	0005b083          	ld	ra,0(a1)
    80003a3e:	0085b103          	ld	sp,8(a1)
    80003a42:	6980                	ld	s0,16(a1)
    80003a44:	6d84                	ld	s1,24(a1)
    80003a46:	0205b903          	ld	s2,32(a1)
    80003a4a:	0285b983          	ld	s3,40(a1)
    80003a4e:	0305ba03          	ld	s4,48(a1)
    80003a52:	0385ba83          	ld	s5,56(a1)
    80003a56:	0405bb03          	ld	s6,64(a1)
    80003a5a:	0485bb83          	ld	s7,72(a1)
    80003a5e:	0505bc03          	ld	s8,80(a1)
    80003a62:	0585bc83          	ld	s9,88(a1)
    80003a66:	0605bd03          	ld	s10,96(a1)
    80003a6a:	0685bd83          	ld	s11,104(a1)
    80003a6e:	8082                	ret

0000000080003a70 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80003a70:	1141                	add	sp,sp,-16
    80003a72:	e406                	sd	ra,8(sp)
    80003a74:	e022                	sd	s0,0(sp)
    80003a76:	0800                	add	s0,sp,16
  initlock(&tickslock, "time");
    80003a78:	00006597          	auipc	a1,0x6
    80003a7c:	b0858593          	add	a1,a1,-1272 # 80009580 <etext+0x580>
    80003a80:	00025517          	auipc	a0,0x25
    80003a84:	65850513          	add	a0,a0,1624 # 800290d8 <tickslock>
    80003a88:	ffffe097          	auipc	ra,0xffffe
    80003a8c:	89c080e7          	jalr	-1892(ra) # 80001324 <initlock>
}
    80003a90:	60a2                	ld	ra,8(sp)
    80003a92:	6402                	ld	s0,0(sp)
    80003a94:	0141                	add	sp,sp,16
    80003a96:	8082                	ret

0000000080003a98 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80003a98:	1141                	add	sp,sp,-16
    80003a9a:	e422                	sd	s0,8(sp)
    80003a9c:	0800                	add	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003a9e:	00004797          	auipc	a5,0x4
    80003aa2:	94278793          	add	a5,a5,-1726 # 800073e0 <kernelvec>
    80003aa6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80003aaa:	6422                	ld	s0,8(sp)
    80003aac:	0141                	add	sp,sp,16
    80003aae:	8082                	ret

0000000080003ab0 <usertrapret>:
//
// return to user space
//
void
usertrapret(void)
{
    80003ab0:	1141                	add	sp,sp,-16
    80003ab2:	e406                	sd	ra,8(sp)
    80003ab4:	e022                	sd	s0,0(sp)
    80003ab6:	0800                	add	s0,sp,16
  struct proc *p = myproc();
    80003ab8:	fffff097          	auipc	ra,0xfffff
    80003abc:	8cc080e7          	jalr	-1844(ra) # 80002384 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003ac0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80003ac4:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003ac6:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(), so turn off interrupts until
  // we're back in user space, where usertrap() is correct.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80003aca:	00004697          	auipc	a3,0x4
    80003ace:	53668693          	add	a3,a3,1334 # 80008000 <_trampoline>
    80003ad2:	00004717          	auipc	a4,0x4
    80003ad6:	52e70713          	add	a4,a4,1326 # 80008000 <_trampoline>
    80003ada:	8f15                	sub	a4,a4,a3
    80003adc:	040007b7          	lui	a5,0x4000
    80003ae0:	17fd                	add	a5,a5,-1 # 3ffffff <_entry-0x7c000001>
    80003ae2:	07b2                	sll	a5,a5,0xc
    80003ae4:	973e                	add	a4,a4,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003ae6:	10571073          	csrw	stvec,a4
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80003aea:	7d58                	ld	a4,184(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80003aec:	18002673          	csrr	a2,satp
    80003af0:	e310                	sd	a2,0(a4)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80003af2:	7d50                	ld	a2,184(a0)
    80003af4:	7158                	ld	a4,160(a0)
    80003af6:	6585                	lui	a1,0x1
    80003af8:	972e                	add	a4,a4,a1
    80003afa:	e618                	sd	a4,8(a2)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80003afc:	7d58                	ld	a4,184(a0)
    80003afe:	00000617          	auipc	a2,0x0
    80003b02:	13860613          	add	a2,a2,312 # 80003c36 <usertrap>
    80003b06:	eb10                	sd	a2,16(a4)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80003b08:	7d58                	ld	a4,184(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80003b0a:	8612                	mv	a2,tp
    80003b0c:	f310                	sd	a2,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003b0e:	10002773          	csrr	a4,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80003b12:	eff77713          	and	a4,a4,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80003b16:	02076713          	or	a4,a4,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003b1a:	10071073          	csrw	sstatus,a4
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80003b1e:	7d58                	ld	a4,184(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003b20:	6f18                	ld	a4,24(a4)
    80003b22:	14171073          	csrw	sepc,a4

  // tell trampoline.S the user page table to switch to.
  uint64 satp = MAKE_SATP(p->pagetable);
    80003b26:	7948                	ld	a0,176(a0)
    80003b28:	8131                	srl	a0,a0,0xc

  // jump to userret in trampoline.S at the top of memory, which 
  // switches to the user page table, restores user registers,
  // and switches to user mode with sret.
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80003b2a:	00004717          	auipc	a4,0x4
    80003b2e:	57270713          	add	a4,a4,1394 # 8000809c <userret>
    80003b32:	8f15                	sub	a4,a4,a3
    80003b34:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80003b36:	577d                	li	a4,-1
    80003b38:	177e                	sll	a4,a4,0x3f
    80003b3a:	8d59                	or	a0,a0,a4
    80003b3c:	9782                	jalr	a5
}
    80003b3e:	60a2                	ld	ra,8(sp)
    80003b40:	6402                	ld	s0,0(sp)
    80003b42:	0141                	add	sp,sp,16
    80003b44:	8082                	ret

0000000080003b46 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80003b46:	1101                	add	sp,sp,-32
    80003b48:	ec06                	sd	ra,24(sp)
    80003b4a:	e822                	sd	s0,16(sp)
    80003b4c:	e426                	sd	s1,8(sp)
    80003b4e:	1000                	add	s0,sp,32
  acquire(&tickslock);
    80003b50:	00025497          	auipc	s1,0x25
    80003b54:	58848493          	add	s1,s1,1416 # 800290d8 <tickslock>
    80003b58:	8526                	mv	a0,s1
    80003b5a:	ffffe097          	auipc	ra,0xffffe
    80003b5e:	85a080e7          	jalr	-1958(ra) # 800013b4 <acquire>
  ticks++;
    80003b62:	00006517          	auipc	a0,0x6
    80003b66:	01e50513          	add	a0,a0,30 # 80009b80 <ticks>
    80003b6a:	411c                	lw	a5,0(a0)
    80003b6c:	2785                	addw	a5,a5,1
    80003b6e:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	4da080e7          	jalr	1242(ra) # 8000304a <wakeup>
  release(&tickslock);
    80003b78:	8526                	mv	a0,s1
    80003b7a:	ffffe097          	auipc	ra,0xffffe
    80003b7e:	8ee080e7          	jalr	-1810(ra) # 80001468 <release>
}
    80003b82:	60e2                	ld	ra,24(sp)
    80003b84:	6442                	ld	s0,16(sp)
    80003b86:	64a2                	ld	s1,8(sp)
    80003b88:	6105                	add	sp,sp,32
    80003b8a:	8082                	ret

0000000080003b8c <devintr>:
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003b8c:	142027f3          	csrr	a5,scause
    // the SSIP bit in sip.
    w_sip(r_sip() & ~2);

    return 2;
  } else {
    return 0;
    80003b90:	4501                	li	a0,0
  if((scause & 0x8000000000000000L) &&
    80003b92:	0a07d163          	bgez	a5,80003c34 <devintr+0xa8>
{
    80003b96:	1101                	add	sp,sp,-32
    80003b98:	ec06                	sd	ra,24(sp)
    80003b9a:	e822                	sd	s0,16(sp)
    80003b9c:	1000                	add	s0,sp,32
     (scause & 0xff) == 9){
    80003b9e:	0ff7f713          	zext.b	a4,a5
  if((scause & 0x8000000000000000L) &&
    80003ba2:	46a5                	li	a3,9
    80003ba4:	00d70c63          	beq	a4,a3,80003bbc <devintr+0x30>
  } else if(scause == 0x8000000000000001L){
    80003ba8:	577d                	li	a4,-1
    80003baa:	177e                	sll	a4,a4,0x3f
    80003bac:	0705                	add	a4,a4,1
    return 0;
    80003bae:	4501                	li	a0,0
  } else if(scause == 0x8000000000000001L){
    80003bb0:	06e78163          	beq	a5,a4,80003c12 <devintr+0x86>
  }
}
    80003bb4:	60e2                	ld	ra,24(sp)
    80003bb6:	6442                	ld	s0,16(sp)
    80003bb8:	6105                	add	sp,sp,32
    80003bba:	8082                	ret
    80003bbc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80003bbe:	00004097          	auipc	ra,0x4
    80003bc2:	92e080e7          	jalr	-1746(ra) # 800074ec <plic_claim>
    80003bc6:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80003bc8:	47a9                	li	a5,10
    80003bca:	00f50963          	beq	a0,a5,80003bdc <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80003bce:	4785                	li	a5,1
    80003bd0:	00f50b63          	beq	a0,a5,80003be6 <devintr+0x5a>
    return 1;
    80003bd4:	4505                	li	a0,1
    } else if(irq){
    80003bd6:	ec89                	bnez	s1,80003bf0 <devintr+0x64>
    80003bd8:	64a2                	ld	s1,8(sp)
    80003bda:	bfe9                	j	80003bb4 <devintr+0x28>
      uartintr();
    80003bdc:	ffffd097          	auipc	ra,0xffffd
    80003be0:	e54080e7          	jalr	-428(ra) # 80000a30 <uartintr>
    if(irq)
    80003be4:	a839                	j	80003c02 <devintr+0x76>
      virtio_disk_intr();
    80003be6:	00004097          	auipc	ra,0x4
    80003bea:	e30080e7          	jalr	-464(ra) # 80007a16 <virtio_disk_intr>
    if(irq)
    80003bee:	a811                	j	80003c02 <devintr+0x76>
      printf("unexpected interrupt irq=%d\n", irq);
    80003bf0:	85a6                	mv	a1,s1
    80003bf2:	00006517          	auipc	a0,0x6
    80003bf6:	99650513          	add	a0,a0,-1642 # 80009588 <etext+0x588>
    80003bfa:	ffffd097          	auipc	ra,0xffffd
    80003bfe:	9e6080e7          	jalr	-1562(ra) # 800005e0 <printf>
      plic_complete(irq);
    80003c02:	8526                	mv	a0,s1
    80003c04:	00004097          	auipc	ra,0x4
    80003c08:	90c080e7          	jalr	-1780(ra) # 80007510 <plic_complete>
    return 1;
    80003c0c:	4505                	li	a0,1
    80003c0e:	64a2                	ld	s1,8(sp)
    80003c10:	b755                	j	80003bb4 <devintr+0x28>
    if(cpuid() == 0){
    80003c12:	ffffe097          	auipc	ra,0xffffe
    80003c16:	746080e7          	jalr	1862(ra) # 80002358 <cpuid>
    80003c1a:	c901                	beqz	a0,80003c2a <devintr+0x9e>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80003c1c:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80003c20:	9bf5                	and	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80003c22:	14479073          	csrw	sip,a5
    return 2;
    80003c26:	4509                	li	a0,2
    80003c28:	b771                	j	80003bb4 <devintr+0x28>
      clockintr();
    80003c2a:	00000097          	auipc	ra,0x0
    80003c2e:	f1c080e7          	jalr	-228(ra) # 80003b46 <clockintr>
    80003c32:	b7ed                	j	80003c1c <devintr+0x90>
}
    80003c34:	8082                	ret

0000000080003c36 <usertrap>:
{
    80003c36:	1101                	add	sp,sp,-32
    80003c38:	ec06                	sd	ra,24(sp)
    80003c3a:	e822                	sd	s0,16(sp)
    80003c3c:	e426                	sd	s1,8(sp)
    80003c3e:	e04a                	sd	s2,0(sp)
    80003c40:	1000                	add	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003c42:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80003c46:	1007f793          	and	a5,a5,256
    80003c4a:	e7bd                	bnez	a5,80003cb8 <usertrap+0x82>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80003c4c:	00003797          	auipc	a5,0x3
    80003c50:	79478793          	add	a5,a5,1940 # 800073e0 <kernelvec>
    80003c54:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80003c58:	ffffe097          	auipc	ra,0xffffe
    80003c5c:	72c080e7          	jalr	1836(ra) # 80002384 <myproc>
    80003c60:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80003c62:	7d5c                	ld	a5,184(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003c64:	14102773          	csrr	a4,sepc
    80003c68:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003c6a:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80003c6e:	47a1                	li	a5,8
    80003c70:	04f70c63          	beq	a4,a5,80003cc8 <usertrap+0x92>
    80003c74:	14202773          	csrr	a4,scause
  } else if (r_scause() == 13 || r_scause() == 15) {
    80003c78:	47b5                	li	a5,13
    80003c7a:	00f70763          	beq	a4,a5,80003c88 <usertrap+0x52>
    80003c7e:	14202773          	csrr	a4,scause
    80003c82:	47bd                	li	a5,15
    80003c84:	06f71c63          	bne	a4,a5,80003cfc <usertrap+0xc6>
    80003c88:	14202573          	csrr	a0,scause
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003c8c:	143025f3          	csrr	a1,stval
    pagefault(r_scause(), r_stval());
    80003c90:	00000097          	auipc	ra,0x0
    80003c94:	8ba080e7          	jalr	-1862(ra) # 8000354a <pagefault>
  if(killed(p))
    80003c98:	8526                	mv	a0,s1
    80003c9a:	fffff097          	auipc	ra,0xfffff
    80003c9e:	5f4080e7          	jalr	1524(ra) # 8000328e <killed>
    80003ca2:	e55d                	bnez	a0,80003d50 <usertrap+0x11a>
  usertrapret();
    80003ca4:	00000097          	auipc	ra,0x0
    80003ca8:	e0c080e7          	jalr	-500(ra) # 80003ab0 <usertrapret>
}
    80003cac:	60e2                	ld	ra,24(sp)
    80003cae:	6442                	ld	s0,16(sp)
    80003cb0:	64a2                	ld	s1,8(sp)
    80003cb2:	6902                	ld	s2,0(sp)
    80003cb4:	6105                	add	sp,sp,32
    80003cb6:	8082                	ret
    panic("usertrap: not from user mode");
    80003cb8:	00006517          	auipc	a0,0x6
    80003cbc:	8f050513          	add	a0,a0,-1808 # 800095a8 <etext+0x5a8>
    80003cc0:	ffffd097          	auipc	ra,0xffffd
    80003cc4:	8d6080e7          	jalr	-1834(ra) # 80000596 <panic>
    if(killed(p))
    80003cc8:	fffff097          	auipc	ra,0xfffff
    80003ccc:	5c6080e7          	jalr	1478(ra) # 8000328e <killed>
    80003cd0:	e105                	bnez	a0,80003cf0 <usertrap+0xba>
    p->trapframe->epc += 4;
    80003cd2:	7cd8                	ld	a4,184(s1)
    80003cd4:	6f1c                	ld	a5,24(a4)
    80003cd6:	0791                	add	a5,a5,4
    80003cd8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003cda:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80003cde:	0027e793          	or	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003ce2:	10079073          	csrw	sstatus,a5
    syscall();
    80003ce6:	00000097          	auipc	ra,0x0
    80003cea:	2d0080e7          	jalr	720(ra) # 80003fb6 <syscall>
    80003cee:	b76d                	j	80003c98 <usertrap+0x62>
      exit(-1);
    80003cf0:	557d                	li	a0,-1
    80003cf2:	fffff097          	auipc	ra,0xfffff
    80003cf6:	428080e7          	jalr	1064(ra) # 8000311a <exit>
    80003cfa:	bfe1                	j	80003cd2 <usertrap+0x9c>
  } else if((which_dev = devintr()) != 0){
    80003cfc:	00000097          	auipc	ra,0x0
    80003d00:	e90080e7          	jalr	-368(ra) # 80003b8c <devintr>
    80003d04:	892a                	mv	s2,a0
    80003d06:	c901                	beqz	a0,80003d16 <usertrap+0xe0>
  if(killed(p))
    80003d08:	8526                	mv	a0,s1
    80003d0a:	fffff097          	auipc	ra,0xfffff
    80003d0e:	584080e7          	jalr	1412(ra) # 8000328e <killed>
    80003d12:	c529                	beqz	a0,80003d5c <usertrap+0x126>
    80003d14:	a83d                	j	80003d52 <usertrap+0x11c>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003d16:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80003d1a:	5890                	lw	a2,48(s1)
    80003d1c:	00005517          	auipc	a0,0x5
    80003d20:	7e450513          	add	a0,a0,2020 # 80009500 <etext+0x500>
    80003d24:	ffffd097          	auipc	ra,0xffffd
    80003d28:	8bc080e7          	jalr	-1860(ra) # 800005e0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003d2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003d30:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003d34:	00005517          	auipc	a0,0x5
    80003d38:	7fc50513          	add	a0,a0,2044 # 80009530 <etext+0x530>
    80003d3c:	ffffd097          	auipc	ra,0xffffd
    80003d40:	8a4080e7          	jalr	-1884(ra) # 800005e0 <printf>
    setkilled(p);
    80003d44:	8526                	mv	a0,s1
    80003d46:	fffff097          	auipc	ra,0xfffff
    80003d4a:	51c080e7          	jalr	1308(ra) # 80003262 <setkilled>
    80003d4e:	b7a9                	j	80003c98 <usertrap+0x62>
  if(killed(p))
    80003d50:	4901                	li	s2,0
    exit(-1);
    80003d52:	557d                	li	a0,-1
    80003d54:	fffff097          	auipc	ra,0xfffff
    80003d58:	3c6080e7          	jalr	966(ra) # 8000311a <exit>
  if(which_dev == 2)
    80003d5c:	4789                	li	a5,2
    80003d5e:	f4f913e3          	bne	s2,a5,80003ca4 <usertrap+0x6e>
    yield();
    80003d62:	fffff097          	auipc	ra,0xfffff
    80003d66:	248080e7          	jalr	584(ra) # 80002faa <yield>
    80003d6a:	bf2d                	j	80003ca4 <usertrap+0x6e>

0000000080003d6c <kerneltrap>:
{
    80003d6c:	7179                	add	sp,sp,-48
    80003d6e:	f406                	sd	ra,40(sp)
    80003d70:	f022                	sd	s0,32(sp)
    80003d72:	ec26                	sd	s1,24(sp)
    80003d74:	e84a                	sd	s2,16(sp)
    80003d76:	e44e                	sd	s3,8(sp)
    80003d78:	1800                	add	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003d7a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003d7e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80003d82:	142029f3          	csrr	s3,scause
  if((sstatus & SSTATUS_SPP) == 0)
    80003d86:	1004f793          	and	a5,s1,256
    80003d8a:	cb85                	beqz	a5,80003dba <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80003d8c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80003d90:	8b89                	and	a5,a5,2
  if(intr_get() != 0)
    80003d92:	ef85                	bnez	a5,80003dca <kerneltrap+0x5e>
  if((which_dev = devintr()) == 0){
    80003d94:	00000097          	auipc	ra,0x0
    80003d98:	df8080e7          	jalr	-520(ra) # 80003b8c <devintr>
    80003d9c:	cd1d                	beqz	a0,80003dda <kerneltrap+0x6e>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003d9e:	4789                	li	a5,2
    80003da0:	06f50a63          	beq	a0,a5,80003e14 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80003da4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80003da8:	10049073          	csrw	sstatus,s1
}
    80003dac:	70a2                	ld	ra,40(sp)
    80003dae:	7402                	ld	s0,32(sp)
    80003db0:	64e2                	ld	s1,24(sp)
    80003db2:	6942                	ld	s2,16(sp)
    80003db4:	69a2                	ld	s3,8(sp)
    80003db6:	6145                	add	sp,sp,48
    80003db8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80003dba:	00006517          	auipc	a0,0x6
    80003dbe:	80e50513          	add	a0,a0,-2034 # 800095c8 <etext+0x5c8>
    80003dc2:	ffffc097          	auipc	ra,0xffffc
    80003dc6:	7d4080e7          	jalr	2004(ra) # 80000596 <panic>
    panic("kerneltrap: interrupts enabled");
    80003dca:	00006517          	auipc	a0,0x6
    80003dce:	82650513          	add	a0,a0,-2010 # 800095f0 <etext+0x5f0>
    80003dd2:	ffffc097          	auipc	ra,0xffffc
    80003dd6:	7c4080e7          	jalr	1988(ra) # 80000596 <panic>
    printf("scause %p\n", scause);
    80003dda:	85ce                	mv	a1,s3
    80003ddc:	00006517          	auipc	a0,0x6
    80003de0:	83450513          	add	a0,a0,-1996 # 80009610 <etext+0x610>
    80003de4:	ffffc097          	auipc	ra,0xffffc
    80003de8:	7fc080e7          	jalr	2044(ra) # 800005e0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80003dec:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80003df0:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80003df4:	00006517          	auipc	a0,0x6
    80003df8:	82c50513          	add	a0,a0,-2004 # 80009620 <etext+0x620>
    80003dfc:	ffffc097          	auipc	ra,0xffffc
    80003e00:	7e4080e7          	jalr	2020(ra) # 800005e0 <printf>
    panic("kerneltrap");
    80003e04:	00006517          	auipc	a0,0x6
    80003e08:	83450513          	add	a0,a0,-1996 # 80009638 <etext+0x638>
    80003e0c:	ffffc097          	auipc	ra,0xffffc
    80003e10:	78a080e7          	jalr	1930(ra) # 80000596 <panic>
  if(which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80003e14:	ffffe097          	auipc	ra,0xffffe
    80003e18:	570080e7          	jalr	1392(ra) # 80002384 <myproc>
    80003e1c:	d541                	beqz	a0,80003da4 <kerneltrap+0x38>
    80003e1e:	ffffe097          	auipc	ra,0xffffe
    80003e22:	566080e7          	jalr	1382(ra) # 80002384 <myproc>
    80003e26:	4d18                	lw	a4,24(a0)
    80003e28:	4791                	li	a5,4
    80003e2a:	f6f71de3          	bne	a4,a5,80003da4 <kerneltrap+0x38>
    yield();
    80003e2e:	fffff097          	auipc	ra,0xfffff
    80003e32:	17c080e7          	jalr	380(ra) # 80002faa <yield>
    80003e36:	b7bd                	j	80003da4 <kerneltrap+0x38>

0000000080003e38 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80003e38:	1101                	add	sp,sp,-32
    80003e3a:	ec06                	sd	ra,24(sp)
    80003e3c:	e822                	sd	s0,16(sp)
    80003e3e:	e426                	sd	s1,8(sp)
    80003e40:	1000                	add	s0,sp,32
    80003e42:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80003e44:	ffffe097          	auipc	ra,0xffffe
    80003e48:	540080e7          	jalr	1344(ra) # 80002384 <myproc>
  switch (n) {
    80003e4c:	4795                	li	a5,5
    80003e4e:	0497e163          	bltu	a5,s1,80003e90 <argraw+0x58>
    80003e52:	048a                	sll	s1,s1,0x2
    80003e54:	00006717          	auipc	a4,0x6
    80003e58:	ba470713          	add	a4,a4,-1116 # 800099f8 <states.0+0x30>
    80003e5c:	94ba                	add	s1,s1,a4
    80003e5e:	409c                	lw	a5,0(s1)
    80003e60:	97ba                	add	a5,a5,a4
    80003e62:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80003e64:	7d5c                	ld	a5,184(a0)
    80003e66:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80003e68:	60e2                	ld	ra,24(sp)
    80003e6a:	6442                	ld	s0,16(sp)
    80003e6c:	64a2                	ld	s1,8(sp)
    80003e6e:	6105                	add	sp,sp,32
    80003e70:	8082                	ret
    return p->trapframe->a1;
    80003e72:	7d5c                	ld	a5,184(a0)
    80003e74:	7fa8                	ld	a0,120(a5)
    80003e76:	bfcd                	j	80003e68 <argraw+0x30>
    return p->trapframe->a2;
    80003e78:	7d5c                	ld	a5,184(a0)
    80003e7a:	63c8                	ld	a0,128(a5)
    80003e7c:	b7f5                	j	80003e68 <argraw+0x30>
    return p->trapframe->a3;
    80003e7e:	7d5c                	ld	a5,184(a0)
    80003e80:	67c8                	ld	a0,136(a5)
    80003e82:	b7dd                	j	80003e68 <argraw+0x30>
    return p->trapframe->a4;
    80003e84:	7d5c                	ld	a5,184(a0)
    80003e86:	6bc8                	ld	a0,144(a5)
    80003e88:	b7c5                	j	80003e68 <argraw+0x30>
    return p->trapframe->a5;
    80003e8a:	7d5c                	ld	a5,184(a0)
    80003e8c:	6fc8                	ld	a0,152(a5)
    80003e8e:	bfe9                	j	80003e68 <argraw+0x30>
  panic("argraw");
    80003e90:	00005517          	auipc	a0,0x5
    80003e94:	7b850513          	add	a0,a0,1976 # 80009648 <etext+0x648>
    80003e98:	ffffc097          	auipc	ra,0xffffc
    80003e9c:	6fe080e7          	jalr	1790(ra) # 80000596 <panic>

0000000080003ea0 <fetchaddr>:
{
    80003ea0:	1101                	add	sp,sp,-32
    80003ea2:	ec06                	sd	ra,24(sp)
    80003ea4:	e822                	sd	s0,16(sp)
    80003ea6:	e426                	sd	s1,8(sp)
    80003ea8:	e04a                	sd	s2,0(sp)
    80003eaa:	1000                	add	s0,sp,32
    80003eac:	84aa                	mv	s1,a0
    80003eae:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80003eb0:	ffffe097          	auipc	ra,0xffffe
    80003eb4:	4d4080e7          	jalr	1236(ra) # 80002384 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80003eb8:	755c                	ld	a5,168(a0)
    80003eba:	02f4f863          	bgeu	s1,a5,80003eea <fetchaddr+0x4a>
    80003ebe:	00848713          	add	a4,s1,8
    80003ec2:	02e7e663          	bltu	a5,a4,80003eee <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80003ec6:	46a1                	li	a3,8
    80003ec8:	8626                	mv	a2,s1
    80003eca:	85ca                	mv	a1,s2
    80003ecc:	7948                	ld	a0,176(a0)
    80003ece:	ffffe097          	auipc	ra,0xffffe
    80003ed2:	1da080e7          	jalr	474(ra) # 800020a8 <copyin>
    80003ed6:	00a03533          	snez	a0,a0
    80003eda:	40a00533          	neg	a0,a0
}
    80003ede:	60e2                	ld	ra,24(sp)
    80003ee0:	6442                	ld	s0,16(sp)
    80003ee2:	64a2                	ld	s1,8(sp)
    80003ee4:	6902                	ld	s2,0(sp)
    80003ee6:	6105                	add	sp,sp,32
    80003ee8:	8082                	ret
    return -1;
    80003eea:	557d                	li	a0,-1
    80003eec:	bfcd                	j	80003ede <fetchaddr+0x3e>
    80003eee:	557d                	li	a0,-1
    80003ef0:	b7fd                	j	80003ede <fetchaddr+0x3e>

0000000080003ef2 <fetchstr>:
{
    80003ef2:	7179                	add	sp,sp,-48
    80003ef4:	f406                	sd	ra,40(sp)
    80003ef6:	f022                	sd	s0,32(sp)
    80003ef8:	ec26                	sd	s1,24(sp)
    80003efa:	e84a                	sd	s2,16(sp)
    80003efc:	e44e                	sd	s3,8(sp)
    80003efe:	1800                	add	s0,sp,48
    80003f00:	892a                	mv	s2,a0
    80003f02:	84ae                	mv	s1,a1
    80003f04:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80003f06:	ffffe097          	auipc	ra,0xffffe
    80003f0a:	47e080e7          	jalr	1150(ra) # 80002384 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80003f0e:	86ce                	mv	a3,s3
    80003f10:	864a                	mv	a2,s2
    80003f12:	85a6                	mv	a1,s1
    80003f14:	7948                	ld	a0,176(a0)
    80003f16:	ffffe097          	auipc	ra,0xffffe
    80003f1a:	220080e7          	jalr	544(ra) # 80002136 <copyinstr>
    80003f1e:	00054e63          	bltz	a0,80003f3a <fetchstr+0x48>
  return strlen(buf);
    80003f22:	8526                	mv	a0,s1
    80003f24:	ffffd097          	auipc	ra,0xffffd
    80003f28:	700080e7          	jalr	1792(ra) # 80001624 <strlen>
}
    80003f2c:	70a2                	ld	ra,40(sp)
    80003f2e:	7402                	ld	s0,32(sp)
    80003f30:	64e2                	ld	s1,24(sp)
    80003f32:	6942                	ld	s2,16(sp)
    80003f34:	69a2                	ld	s3,8(sp)
    80003f36:	6145                	add	sp,sp,48
    80003f38:	8082                	ret
    return -1;
    80003f3a:	557d                	li	a0,-1
    80003f3c:	bfc5                	j	80003f2c <fetchstr+0x3a>

0000000080003f3e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80003f3e:	1101                	add	sp,sp,-32
    80003f40:	ec06                	sd	ra,24(sp)
    80003f42:	e822                	sd	s0,16(sp)
    80003f44:	e426                	sd	s1,8(sp)
    80003f46:	1000                	add	s0,sp,32
    80003f48:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003f4a:	00000097          	auipc	ra,0x0
    80003f4e:	eee080e7          	jalr	-274(ra) # 80003e38 <argraw>
    80003f52:	c088                	sw	a0,0(s1)
}
    80003f54:	60e2                	ld	ra,24(sp)
    80003f56:	6442                	ld	s0,16(sp)
    80003f58:	64a2                	ld	s1,8(sp)
    80003f5a:	6105                	add	sp,sp,32
    80003f5c:	8082                	ret

0000000080003f5e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80003f5e:	1101                	add	sp,sp,-32
    80003f60:	ec06                	sd	ra,24(sp)
    80003f62:	e822                	sd	s0,16(sp)
    80003f64:	e426                	sd	s1,8(sp)
    80003f66:	1000                	add	s0,sp,32
    80003f68:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80003f6a:	00000097          	auipc	ra,0x0
    80003f6e:	ece080e7          	jalr	-306(ra) # 80003e38 <argraw>
    80003f72:	e088                	sd	a0,0(s1)
}
    80003f74:	60e2                	ld	ra,24(sp)
    80003f76:	6442                	ld	s0,16(sp)
    80003f78:	64a2                	ld	s1,8(sp)
    80003f7a:	6105                	add	sp,sp,32
    80003f7c:	8082                	ret

0000000080003f7e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80003f7e:	7179                	add	sp,sp,-48
    80003f80:	f406                	sd	ra,40(sp)
    80003f82:	f022                	sd	s0,32(sp)
    80003f84:	ec26                	sd	s1,24(sp)
    80003f86:	e84a                	sd	s2,16(sp)
    80003f88:	1800                	add	s0,sp,48
    80003f8a:	84ae                	mv	s1,a1
    80003f8c:	8932                	mv	s2,a2
  uint64 addr;
  argaddr(n, &addr);
    80003f8e:	fd840593          	add	a1,s0,-40
    80003f92:	00000097          	auipc	ra,0x0
    80003f96:	fcc080e7          	jalr	-52(ra) # 80003f5e <argaddr>
  return fetchstr(addr, buf, max);
    80003f9a:	864a                	mv	a2,s2
    80003f9c:	85a6                	mv	a1,s1
    80003f9e:	fd843503          	ld	a0,-40(s0)
    80003fa2:	00000097          	auipc	ra,0x0
    80003fa6:	f50080e7          	jalr	-176(ra) # 80003ef2 <fetchstr>
}
    80003faa:	70a2                	ld	ra,40(sp)
    80003fac:	7402                	ld	s0,32(sp)
    80003fae:	64e2                	ld	s1,24(sp)
    80003fb0:	6942                	ld	s2,16(sp)
    80003fb2:	6145                	add	sp,sp,48
    80003fb4:	8082                	ret

0000000080003fb6 <syscall>:
#endif
};

void
syscall(void)
{
    80003fb6:	1101                	add	sp,sp,-32
    80003fb8:	ec06                	sd	ra,24(sp)
    80003fba:	e822                	sd	s0,16(sp)
    80003fbc:	e426                	sd	s1,8(sp)
    80003fbe:	e04a                	sd	s2,0(sp)
    80003fc0:	1000                	add	s0,sp,32
  int num;
  struct proc *p = myproc();
    80003fc2:	ffffe097          	auipc	ra,0xffffe
    80003fc6:	3c2080e7          	jalr	962(ra) # 80002384 <myproc>
    80003fca:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80003fcc:	0b853903          	ld	s2,184(a0)
    80003fd0:	0a893783          	ld	a5,168(s2)
    80003fd4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80003fd8:	37fd                	addw	a5,a5,-1
    80003fda:	4761                	li	a4,24
    80003fdc:	00f76f63          	bltu	a4,a5,80003ffa <syscall+0x44>
    80003fe0:	00369713          	sll	a4,a3,0x3
    80003fe4:	00006797          	auipc	a5,0x6
    80003fe8:	a2c78793          	add	a5,a5,-1492 # 80009a10 <syscalls>
    80003fec:	97ba                	add	a5,a5,a4
    80003fee:	639c                	ld	a5,0(a5)
    80003ff0:	c789                	beqz	a5,80003ffa <syscall+0x44>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80003ff2:	9782                	jalr	a5
    80003ff4:	06a93823          	sd	a0,112(s2)
    80003ff8:	a839                	j	80004016 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80003ffa:	1b848613          	add	a2,s1,440
    80003ffe:	588c                	lw	a1,48(s1)
    80004000:	00005517          	auipc	a0,0x5
    80004004:	65050513          	add	a0,a0,1616 # 80009650 <etext+0x650>
    80004008:	ffffc097          	auipc	ra,0xffffc
    8000400c:	5d8080e7          	jalr	1496(ra) # 800005e0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80004010:	7cdc                	ld	a5,184(s1)
    80004012:	577d                	li	a4,-1
    80004014:	fbb8                	sd	a4,112(a5)
  }
}
    80004016:	60e2                	ld	ra,24(sp)
    80004018:	6442                	ld	s0,16(sp)
    8000401a:	64a2                	ld	s1,8(sp)
    8000401c:	6902                	ld	s2,0(sp)
    8000401e:	6105                	add	sp,sp,32
    80004020:	8082                	ret

0000000080004022 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80004022:	1101                	add	sp,sp,-32
    80004024:	ec06                	sd	ra,24(sp)
    80004026:	e822                	sd	s0,16(sp)
    80004028:	1000                	add	s0,sp,32
  int n;
  argint(0, &n);
    8000402a:	fec40593          	add	a1,s0,-20
    8000402e:	4501                	li	a0,0
    80004030:	00000097          	auipc	ra,0x0
    80004034:	f0e080e7          	jalr	-242(ra) # 80003f3e <argint>
  exit(n);
    80004038:	fec42503          	lw	a0,-20(s0)
    8000403c:	fffff097          	auipc	ra,0xfffff
    80004040:	0de080e7          	jalr	222(ra) # 8000311a <exit>
  return 0;  // not reached
}
    80004044:	4501                	li	a0,0
    80004046:	60e2                	ld	ra,24(sp)
    80004048:	6442                	ld	s0,16(sp)
    8000404a:	6105                	add	sp,sp,32
    8000404c:	8082                	ret

000000008000404e <sys_getpid>:

uint64
sys_getpid(void)
{
    8000404e:	1141                	add	sp,sp,-16
    80004050:	e406                	sd	ra,8(sp)
    80004052:	e022                	sd	s0,0(sp)
    80004054:	0800                	add	s0,sp,16
  return myproc()->pid;
    80004056:	ffffe097          	auipc	ra,0xffffe
    8000405a:	32e080e7          	jalr	814(ra) # 80002384 <myproc>
}
    8000405e:	5908                	lw	a0,48(a0)
    80004060:	60a2                	ld	ra,8(sp)
    80004062:	6402                	ld	s0,0(sp)
    80004064:	0141                	add	sp,sp,16
    80004066:	8082                	ret

0000000080004068 <sys_fork>:

uint64
sys_fork(void)
{
    80004068:	1141                	add	sp,sp,-16
    8000406a:	e406                	sd	ra,8(sp)
    8000406c:	e022                	sd	s0,0(sp)
    8000406e:	0800                	add	s0,sp,16
  return fork();
    80004070:	ffffe097          	auipc	ra,0xffffe
    80004074:	7d6080e7          	jalr	2006(ra) # 80002846 <fork>
}
    80004078:	60a2                	ld	ra,8(sp)
    8000407a:	6402                	ld	s0,0(sp)
    8000407c:	0141                	add	sp,sp,16
    8000407e:	8082                	ret

0000000080004080 <sys_wait>:

uint64
sys_wait(void)
{
    80004080:	1101                	add	sp,sp,-32
    80004082:	ec06                	sd	ra,24(sp)
    80004084:	e822                	sd	s0,16(sp)
    80004086:	1000                	add	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80004088:	fe840593          	add	a1,s0,-24
    8000408c:	4501                	li	a0,0
    8000408e:	00000097          	auipc	ra,0x0
    80004092:	ed0080e7          	jalr	-304(ra) # 80003f5e <argaddr>
  return wait(p);
    80004096:	fe843503          	ld	a0,-24(s0)
    8000409a:	fffff097          	auipc	ra,0xfffff
    8000409e:	226080e7          	jalr	550(ra) # 800032c0 <wait>
}
    800040a2:	60e2                	ld	ra,24(sp)
    800040a4:	6442                	ld	s0,16(sp)
    800040a6:	6105                	add	sp,sp,32
    800040a8:	8082                	ret

00000000800040aa <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800040aa:	7179                	add	sp,sp,-48
    800040ac:	f406                	sd	ra,40(sp)
    800040ae:	f022                	sd	s0,32(sp)
    800040b0:	ec26                	sd	s1,24(sp)
    800040b2:	1800                	add	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800040b4:	fdc40593          	add	a1,s0,-36
    800040b8:	4501                	li	a0,0
    800040ba:	00000097          	auipc	ra,0x0
    800040be:	e84080e7          	jalr	-380(ra) # 80003f3e <argint>
  addr = myproc()->sz;
    800040c2:	ffffe097          	auipc	ra,0xffffe
    800040c6:	2c2080e7          	jalr	706(ra) # 80002384 <myproc>
    800040ca:	7544                	ld	s1,168(a0)
  if(growproc(n) < 0)
    800040cc:	fdc42503          	lw	a0,-36(s0)
    800040d0:	ffffe097          	auipc	ra,0xffffe
    800040d4:	6ce080e7          	jalr	1742(ra) # 8000279e <growproc>
    800040d8:	00054863          	bltz	a0,800040e8 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800040dc:	8526                	mv	a0,s1
    800040de:	70a2                	ld	ra,40(sp)
    800040e0:	7402                	ld	s0,32(sp)
    800040e2:	64e2                	ld	s1,24(sp)
    800040e4:	6145                	add	sp,sp,48
    800040e6:	8082                	ret
    return -1;
    800040e8:	54fd                	li	s1,-1
    800040ea:	bfcd                	j	800040dc <sys_sbrk+0x32>

00000000800040ec <sys_sleep>:

uint64
sys_sleep(void)
{
    800040ec:	7139                	add	sp,sp,-64
    800040ee:	fc06                	sd	ra,56(sp)
    800040f0:	f822                	sd	s0,48(sp)
    800040f2:	f04a                	sd	s2,32(sp)
    800040f4:	0080                	add	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800040f6:	fcc40593          	add	a1,s0,-52
    800040fa:	4501                	li	a0,0
    800040fc:	00000097          	auipc	ra,0x0
    80004100:	e42080e7          	jalr	-446(ra) # 80003f3e <argint>
  acquire(&tickslock);
    80004104:	00025517          	auipc	a0,0x25
    80004108:	fd450513          	add	a0,a0,-44 # 800290d8 <tickslock>
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	2a8080e7          	jalr	680(ra) # 800013b4 <acquire>
  ticks0 = ticks;
    80004114:	00006917          	auipc	s2,0x6
    80004118:	a6c92903          	lw	s2,-1428(s2) # 80009b80 <ticks>
  while(ticks - ticks0 < n){
    8000411c:	fcc42783          	lw	a5,-52(s0)
    80004120:	c3b9                	beqz	a5,80004166 <sys_sleep+0x7a>
    80004122:	f426                	sd	s1,40(sp)
    80004124:	ec4e                	sd	s3,24(sp)
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80004126:	00025997          	auipc	s3,0x25
    8000412a:	fb298993          	add	s3,s3,-78 # 800290d8 <tickslock>
    8000412e:	00006497          	auipc	s1,0x6
    80004132:	a5248493          	add	s1,s1,-1454 # 80009b80 <ticks>
    if(killed(myproc())){
    80004136:	ffffe097          	auipc	ra,0xffffe
    8000413a:	24e080e7          	jalr	590(ra) # 80002384 <myproc>
    8000413e:	fffff097          	auipc	ra,0xfffff
    80004142:	150080e7          	jalr	336(ra) # 8000328e <killed>
    80004146:	ed15                	bnez	a0,80004182 <sys_sleep+0x96>
    sleep(&ticks, &tickslock);
    80004148:	85ce                	mv	a1,s3
    8000414a:	8526                	mv	a0,s1
    8000414c:	fffff097          	auipc	ra,0xfffff
    80004150:	e9a080e7          	jalr	-358(ra) # 80002fe6 <sleep>
  while(ticks - ticks0 < n){
    80004154:	409c                	lw	a5,0(s1)
    80004156:	412787bb          	subw	a5,a5,s2
    8000415a:	fcc42703          	lw	a4,-52(s0)
    8000415e:	fce7ece3          	bltu	a5,a4,80004136 <sys_sleep+0x4a>
    80004162:	74a2                	ld	s1,40(sp)
    80004164:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80004166:	00025517          	auipc	a0,0x25
    8000416a:	f7250513          	add	a0,a0,-142 # 800290d8 <tickslock>
    8000416e:	ffffd097          	auipc	ra,0xffffd
    80004172:	2fa080e7          	jalr	762(ra) # 80001468 <release>
  return 0;
    80004176:	4501                	li	a0,0
}
    80004178:	70e2                	ld	ra,56(sp)
    8000417a:	7442                	ld	s0,48(sp)
    8000417c:	7902                	ld	s2,32(sp)
    8000417e:	6121                	add	sp,sp,64
    80004180:	8082                	ret
      release(&tickslock);
    80004182:	00025517          	auipc	a0,0x25
    80004186:	f5650513          	add	a0,a0,-170 # 800290d8 <tickslock>
    8000418a:	ffffd097          	auipc	ra,0xffffd
    8000418e:	2de080e7          	jalr	734(ra) # 80001468 <release>
      return -1;
    80004192:	557d                	li	a0,-1
    80004194:	74a2                	ld	s1,40(sp)
    80004196:	69e2                	ld	s3,24(sp)
    80004198:	b7c5                	j	80004178 <sys_sleep+0x8c>

000000008000419a <sys_kill>:

uint64
sys_kill(void)
{
    8000419a:	1101                	add	sp,sp,-32
    8000419c:	ec06                	sd	ra,24(sp)
    8000419e:	e822                	sd	s0,16(sp)
    800041a0:	1000                	add	s0,sp,32
  int pid;

  argint(0, &pid);
    800041a2:	fec40593          	add	a1,s0,-20
    800041a6:	4501                	li	a0,0
    800041a8:	00000097          	auipc	ra,0x0
    800041ac:	d96080e7          	jalr	-618(ra) # 80003f3e <argint>
  return kill(pid);
    800041b0:	fec42503          	lw	a0,-20(s0)
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	03c080e7          	jalr	60(ra) # 800031f0 <kill>
}
    800041bc:	60e2                	ld	ra,24(sp)
    800041be:	6442                	ld	s0,16(sp)
    800041c0:	6105                	add	sp,sp,32
    800041c2:	8082                	ret

00000000800041c4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800041c4:	1101                	add	sp,sp,-32
    800041c6:	ec06                	sd	ra,24(sp)
    800041c8:	e822                	sd	s0,16(sp)
    800041ca:	e426                	sd	s1,8(sp)
    800041cc:	1000                	add	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800041ce:	00025517          	auipc	a0,0x25
    800041d2:	f0a50513          	add	a0,a0,-246 # 800290d8 <tickslock>
    800041d6:	ffffd097          	auipc	ra,0xffffd
    800041da:	1de080e7          	jalr	478(ra) # 800013b4 <acquire>
  xticks = ticks;
    800041de:	00006497          	auipc	s1,0x6
    800041e2:	9a24a483          	lw	s1,-1630(s1) # 80009b80 <ticks>
  release(&tickslock);
    800041e6:	00025517          	auipc	a0,0x25
    800041ea:	ef250513          	add	a0,a0,-270 # 800290d8 <tickslock>
    800041ee:	ffffd097          	auipc	ra,0xffffd
    800041f2:	27a080e7          	jalr	634(ra) # 80001468 <release>
  return xticks;
}
    800041f6:	02049513          	sll	a0,s1,0x20
    800041fa:	9101                	srl	a0,a0,0x20
    800041fc:	60e2                	ld	ra,24(sp)
    800041fe:	6442                	ld	s0,16(sp)
    80004200:	64a2                	ld	s1,8(sp)
    80004202:	6105                	add	sp,sp,32
    80004204:	8082                	ret

0000000080004206 <sys_kcall>:


uint64
sys_kcall(void)
{
    80004206:	1101                	add	sp,sp,-32
    80004208:	ec06                	sd	ra,24(sp)
    8000420a:	e822                	sd	s0,16(sp)
    8000420c:	1000                	add	s0,sp,32
  int n;

  argint(0, &n);
    8000420e:	fec40593          	add	a1,s0,-20
    80004212:	4501                	li	a0,0
    80004214:	00000097          	auipc	ra,0x0
    80004218:	d2a080e7          	jalr	-726(ra) # 80003f3e <argint>
  switch (n)
    8000421c:	fec42783          	lw	a5,-20(s0)
    80004220:	4709                	li	a4,2
    80004222:	02e78f63          	beq	a5,a4,80004260 <sys_kcall+0x5a>
    80004226:	00f74c63          	blt	a4,a5,8000423e <sys_kcall+0x38>
    8000422a:	c39d                	beqz	a5,80004250 <sys_kcall+0x4a>
    8000422c:	4705                	li	a4,1
    8000422e:	557d                	li	a0,-1
    80004230:	02e79463          	bne	a5,a4,80004258 <sys_kcall+0x52>
  {
    case KC_FREEMEM:    return freemem;
    case KC_USED4K:     return used4k;
    80004234:	00006517          	auipc	a0,0x6
    80004238:	91852503          	lw	a0,-1768(a0) # 80009b4c <used4k>
    8000423c:	a831                	j	80004258 <sys_kcall+0x52>
  switch (n)
    8000423e:	470d                	li	a4,3
    80004240:	557d                	li	a0,-1
    80004242:	00e79b63          	bne	a5,a4,80004258 <sys_kcall+0x52>
    case KC_USED2M:     return used2m;
    case KC_PF:         return pagefaults;
    80004246:	00006517          	auipc	a0,0x6
    8000424a:	92a52503          	lw	a0,-1750(a0) # 80009b70 <pagefaults>
    8000424e:	a029                	j	80004258 <sys_kcall+0x52>
    case KC_FREEMEM:    return freemem;
    80004250:	00006517          	auipc	a0,0x6
    80004254:	90052503          	lw	a0,-1792(a0) # 80009b50 <freemem>
    default:            return -1;
  }
}
    80004258:	60e2                	ld	ra,24(sp)
    8000425a:	6442                	ld	s0,16(sp)
    8000425c:	6105                	add	sp,sp,32
    8000425e:	8082                	ret
    case KC_USED2M:     return used2m;
    80004260:	00006517          	auipc	a0,0x6
    80004264:	8e852503          	lw	a0,-1816(a0) # 80009b48 <used2m>
    80004268:	bfc5                	j	80004258 <sys_kcall+0x52>

000000008000426a <sys_mmap>:
};


uint64
sys_mmap(void)
{
    8000426a:	7139                	add	sp,sp,-64
    8000426c:	fc06                	sd	ra,56(sp)
    8000426e:	f822                	sd	s0,48(sp)
    80004270:	f426                	sd	s1,40(sp)
    80004272:	0080                	add	s0,sp,64
  

  uint64 addr;
  int length, prot,flags;
  
  argaddr(0, &addr);
    80004274:	fd840593          	add	a1,s0,-40
    80004278:	4501                	li	a0,0
    8000427a:	00000097          	auipc	ra,0x0
    8000427e:	ce4080e7          	jalr	-796(ra) # 80003f5e <argaddr>
  argint(1,&length);
    80004282:	fd440593          	add	a1,s0,-44
    80004286:	4505                	li	a0,1
    80004288:	00000097          	auipc	ra,0x0
    8000428c:	cb6080e7          	jalr	-842(ra) # 80003f3e <argint>
  argint(2,&prot);
    80004290:	fd040593          	add	a1,s0,-48
    80004294:	4509                	li	a0,2
    80004296:	00000097          	auipc	ra,0x0
    8000429a:	ca8080e7          	jalr	-856(ra) # 80003f3e <argint>
  argint(3,&flags);
    8000429e:	fcc40593          	add	a1,s0,-52
    800042a2:	450d                	li	a0,3
    800042a4:	00000097          	auipc	ra,0x0
    800042a8:	c9a080e7          	jalr	-870(ra) # 80003f3e <argint>
  // 1) addr out of range or 3) addr not aligned


  // printf("%p\n", PHYSTOP);
  // printf("%p\n", MAXVA - 0x10000000);
  if((addr < PHYSTOP) || (MAXVA - 0x10000000 < addr) || ((addr % PGSIZE) != 0))
    800042ac:	fd843703          	ld	a4,-40(s0)
    800042b0:	57bd                	li	a5,-17
    800042b2:	07ee                	sll	a5,a5,0x1b
    800042b4:	97ba                	add	a5,a5,a4
    800042b6:	7ed00693          	li	a3,2029
    800042ba:	06ee                	sll	a3,a3,0x1b
    return 0;
    800042bc:	4481                	li	s1,0
  if((addr < PHYSTOP) || (MAXVA - 0x10000000 < addr) || ((addr % PGSIZE) != 0))
    800042be:	12f6e263          	bltu	a3,a5,800043e2 <sys_mmap+0x178>
    800042c2:	1752                	sll	a4,a4,0x34
    800042c4:	03475493          	srl	s1,a4,0x34
    800042c8:	10071c63          	bnez	a4,800043e0 <sys_mmap+0x176>

  // 4) length out of range. The maximum size (length) in mmap() is limited to 64MiB. must be greater than 0
  if(length <= 0 || (32* HUGEPGSIZE)< length)
    800042cc:	fd442783          	lw	a5,-44(s0)
    800042d0:	fff7869b          	addw	a3,a5,-1
    800042d4:	04000737          	lui	a4,0x4000
    800042d8:	10e6f563          	bgeu	a3,a4,800043e2 <sys_mmap+0x178>
    return 0;

  // 5) weird prot bits
  if(!(prot == PROT_READ || prot == PROT_WRITE))
    800042dc:	fd042703          	lw	a4,-48(s0)
    800042e0:	377d                	addw	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800042e2:	4685                	li	a3,1
    800042e4:	0ee6ef63          	bltu	a3,a4,800043e2 <sys_mmap+0x178>
    return 0;
  
  // 6) weird flags
  if(!(flags == MAP_PRIVATE || flags == MAP_SHARED || flags == (MAP_PRIVATE | MAP_HUGEPAGE) || flags == (MAP_SHARED | MAP_HUGEPAGE)))
    800042e8:	fcc42683          	lw	a3,-52(s0)
    800042ec:	ff06871b          	addw	a4,a3,-16
    800042f0:	9b3d                	and	a4,a4,-17
    800042f2:	2701                	sext.w	a4,a4
    800042f4:	c305                	beqz	a4,80004314 <sys_mmap+0xaa>
    800042f6:	ef06869b          	addw	a3,a3,-272
    800042fa:	9abd                	and	a3,a3,-17
    800042fc:	2681                	sext.w	a3,a3
    800042fe:	e2f5                	bnez	a3,800043e2 <sys_mmap+0x178>
    80004300:	f04a                	sd	s2,32(sp)

  // if(is_huge)
  //   page_size = HUGEPGSIZE;

  if(is_huge)
    length = HUGEPGROUNDUP(length);
    80004302:	00200737          	lui	a4,0x200
    80004306:	377d                	addw	a4,a4,-1 # 1fffff <_entry-0x7fe00001>
    80004308:	9fb9                	addw	a5,a5,a4
    8000430a:	ffe00737          	lui	a4,0xffe00
    8000430e:	8ff9                	and	a5,a5,a4
    80004310:	2781                	sext.w	a5,a5
    80004312:	a801                	j	80004322 <sys_mmap+0xb8>
    80004314:	f04a                	sd	s2,32(sp)
  else
    length = PGROUNDUP(length);
    80004316:	6705                	lui	a4,0x1
    80004318:	377d                	addw	a4,a4,-1 # fff <_entry-0x7ffff001>
    8000431a:	9fb9                	addw	a5,a5,a4
    8000431c:	777d                	lui	a4,0xfffff
    8000431e:	8ff9                	and	a5,a5,a4
    80004320:	2781                	sext.w	a5,a5
    80004322:	fcf42a23          	sw	a5,-44(s0)
  
  struct proc *p = myproc();
    80004326:	ffffe097          	auipc	ra,0xffffe
    8000432a:	05e080e7          	jalr	94(ra) # 80002384 <myproc>
    8000432e:	892a                	mv	s2,a0

  acquire(&mmaplock);
    80004330:	00025517          	auipc	a0,0x25
    80004334:	dc050513          	add	a0,a0,-576 # 800290f0 <mmaplock>
    80004338:	ffffd097          	auipc	ra,0xffffd
    8000433c:	07c080e7          	jalr	124(ra) # 800013b4 <acquire>
  {
    uint64 va = p->mmap_list[i];
    uint64 s = p->mmap_list[i+1];
    
    // mmap start area
    if(va <= addr && addr <va+s)
    80004340:	fd843603          	ld	a2,-40(s0)
      release(&mmaplock);
      return 0;
    }

    // mmap end area
    if(addr <= va && va <addr +length)
    80004344:	fd442883          	lw	a7,-44(s0)
    80004348:	01160833          	add	a6,a2,a7
    8000434c:	03890693          	add	a3,s2,56
    80004350:	09890513          	add	a0,s2,152
    80004354:	87b6                	mv	a5,a3
    80004356:	a031                	j	80004362 <sys_mmap+0xf8>
    80004358:	02e60663          	beq	a2,a4,80004384 <sys_mmap+0x11a>
  for(int i=0; i<12; i+=3)
    8000435c:	07e1                	add	a5,a5,24
    8000435e:	02a78f63          	beq	a5,a0,8000439c <sys_mmap+0x132>
    uint64 va = p->mmap_list[i];
    80004362:	6398                	ld	a4,0(a5)
    uint64 s = p->mmap_list[i+1];
    80004364:	678c                	ld	a1,8(a5)
    if(va <= addr && addr <va+s)
    80004366:	00e66f63          	bltu	a2,a4,80004384 <sys_mmap+0x11a>
    8000436a:	95ba                	add	a1,a1,a4
    8000436c:	feb676e3          	bgeu	a2,a1,80004358 <sys_mmap+0xee>
      release(&mmaplock);
    80004370:	00025517          	auipc	a0,0x25
    80004374:	d8050513          	add	a0,a0,-640 # 800290f0 <mmaplock>
    80004378:	ffffd097          	auipc	ra,0xffffd
    8000437c:	0f0080e7          	jalr	240(ra) # 80001468 <release>
      return 0;
    80004380:	7902                	ld	s2,32(sp)
    80004382:	a085                	j	800043e2 <sys_mmap+0x178>
    if(addr <= va && va <addr +length)
    80004384:	fd077ce3          	bgeu	a4,a6,8000435c <sys_mmap+0xf2>
    {
      //printf("mmap joongbok type 2\n");
      release(&mmaplock);
    80004388:	00025517          	auipc	a0,0x25
    8000438c:	d6850513          	add	a0,a0,-664 # 800290f0 <mmaplock>
    80004390:	ffffd097          	auipc	ra,0xffffd
    80004394:	0d8080e7          	jalr	216(ra) # 80001468 <release>
      return 0;
    80004398:	7902                	ld	s2,32(sp)
    8000439a:	a0a1                	j	800043e2 <sys_mmap+0x178>



  // search for empty mmap_list, if found, update
  // remember order : address-length-(prot | ishuge | flags)
  for(int i=0; i<12; i+=3)
    8000439c:	4781                	li	a5,0
    8000439e:	45b1                	li	a1,12
  {
    uint64 va = p->mmap_list[i];  
    if(va == 0)
    800043a0:	6298                	ld	a4,0(a3)
    800043a2:	c30d                	beqz	a4,800043c4 <sys_mmap+0x15a>
  for(int i=0; i<12; i+=3)
    800043a4:	278d                	addw	a5,a5,3
    800043a6:	06e1                	add	a3,a3,24
    800043a8:	feb79ce3          	bne	a5,a1,800043a0 <sys_mmap+0x136>
      p->mmap_list[i+2] = (prot | flags);
      break;
    }
  }
  // don't actually allocate PA
  release(&mmaplock);
    800043ac:	00025517          	auipc	a0,0x25
    800043b0:	d4450513          	add	a0,a0,-700 # 800290f0 <mmaplock>
    800043b4:	ffffd097          	auipc	ra,0xffffd
    800043b8:	0b4080e7          	jalr	180(ra) # 80001468 <release>
  //printf("returning addr : %p\n",addr);

  return addr;
    800043bc:	fd843483          	ld	s1,-40(s0)
    800043c0:	7902                	ld	s2,32(sp)
    800043c2:	a005                	j	800043e2 <sys_mmap+0x178>
      p->mmap_list[i] = addr;
    800043c4:	078e                	sll	a5,a5,0x3
    800043c6:	993e                	add	s2,s2,a5
    800043c8:	02c93c23          	sd	a2,56(s2)
      p->mmap_list[i+1] = length;
    800043cc:	05193023          	sd	a7,64(s2)
      p->mmap_list[i+2] = (prot | flags);
    800043d0:	fd042783          	lw	a5,-48(s0)
    800043d4:	fcc42703          	lw	a4,-52(s0)
    800043d8:	8fd9                	or	a5,a5,a4
    800043da:	04f93423          	sd	a5,72(s2)
      break;
    800043de:	b7f9                	j	800043ac <sys_mmap+0x142>
    return 0;
    800043e0:	4481                	li	s1,0
}
    800043e2:	8526                	mv	a0,s1
    800043e4:	70e2                	ld	ra,56(sp)
    800043e6:	7442                	ld	s0,48(sp)
    800043e8:	74a2                	ld	s1,40(sp)
    800043ea:	6121                	add	sp,sp,64
    800043ec:	8082                	ret

00000000800043ee <sys_munmap>:

uint64
sys_munmap(void)
{
    800043ee:	711d                	add	sp,sp,-96
    800043f0:	ec86                	sd	ra,88(sp)
    800043f2:	e8a2                	sd	s0,80(sp)
    800043f4:	ec5e                	sd	s7,24(sp)
    800043f6:	1080                	add	s0,sp,96
  // PA4: FILL HERE

  uint64 addr;
  argaddr(0, &addr);
    800043f8:	fa840593          	add	a1,s0,-88
    800043fc:	4501                	li	a0,0
    800043fe:	00000097          	auipc	ra,0x0
    80004402:	b60080e7          	jalr	-1184(ra) # 80003f5e <argaddr>

  // error1) addr not aligned/out of range

  // TODO : maxva - 10000000이 끝임. 시작이 아니라
  if(((addr%4096)!=0) || (addr < PHYSTOP) || (MAXVA - 0x10000000 < addr))
    80004406:	fa843783          	ld	a5,-88(s0)
    8000440a:	03479713          	sll	a4,a5,0x34
    8000440e:	10071e63          	bnez	a4,8000452a <sys_munmap+0x13c>
    80004412:	03475b93          	srl	s7,a4,0x34
    80004416:	573d                	li	a4,-17
    80004418:	076e                	sll	a4,a4,0x1b
    8000441a:	97ba                	add	a5,a5,a4
    8000441c:	7ed00713          	li	a4,2029
    80004420:	076e                	sll	a4,a4,0x1b
    80004422:	10f76663          	bltu	a4,a5,8000452e <sys_munmap+0x140>
    80004426:	e0ca                	sd	s2,64(sp)
    80004428:	fc4e                	sd	s3,56(sp)
    8000442a:	f852                	sd	s4,48(sp)
    8000442c:	f456                	sd	s5,40(sp)
  {
    //printf("OOR\n");
    return -1;
  }
  struct proc *p = myproc();
    8000442e:	ffffe097          	auipc	ra,0xffffe
    80004432:	f56080e7          	jalr	-170(ra) # 80002384 <myproc>
    80004436:	8a2a                	mv	s4,a0
  // for(int i=0; i<12; i+=3)
  // {
  //   printf("mmunmap called point : %p, %p, %p\n",p->mmap_list[i], p->mmap_list[i+1], p->mmap_list[i+2]);
  // }

  acquire(&mmaplock);
    80004438:	00025517          	auipc	a0,0x25
    8000443c:	cb850513          	add	a0,a0,-840 # 800290f0 <mmaplock>
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	f74080e7          	jalr	-140(ra) # 800013b4 <acquire>
  // remember order : address-length-(prot | ishuge | flags)
  int page_index=0;
  int map_exists = 0;
  for(int i=0; i<12; i+=3)
  {
    if(addr == p->mmap_list[i])
    80004448:	fa843903          	ld	s2,-88(s0)
    8000444c:	038a0793          	add	a5,s4,56
  for(int i=0; i<12; i+=3)
    80004450:	4981                	li	s3,0
    80004452:	46b1                	li	a3,12
    if(addr == p->mmap_list[i])
    80004454:	6398                	ld	a4,0(a5)
    80004456:	0d270e63          	beq	a4,s2,80004532 <sys_munmap+0x144>
  for(int i=0; i<12; i+=3)
    8000445a:	298d                	addw	s3,s3,3
    8000445c:	07e1                	add	a5,a5,24
    8000445e:	fed99be3          	bne	s3,a3,80004454 <sys_munmap+0x66>
  }

  if(!map_exists)
  {
    // no mapping exists
    release(&mmaplock);
    80004462:	00025517          	auipc	a0,0x25
    80004466:	c8e50513          	add	a0,a0,-882 # 800290f0 <mmaplock>
    8000446a:	ffffd097          	auipc	ra,0xffffd
    8000446e:	ffe080e7          	jalr	-2(ra) # 80001468 <release>
    return -1;
    80004472:	5bfd                	li	s7,-1
    80004474:	6906                	ld	s2,64(sp)
    80004476:	79e2                	ld	s3,56(sp)
    80004478:	7a42                	ld	s4,48(sp)
    8000447a:	7aa2                	ld	s5,40(sp)
    8000447c:	a04d                	j	8000451e <sys_munmap+0x130>
  
  if(HUGE_MASK & flags)
  {
    
    // fixed uvmunmap_huge for munmap right after mmap/auto free
    uvmunmap_huge(p->pagetable, addr, length/(4096*512),1);
    8000447e:	41fad61b          	sraw	a2,s5,0x1f
    80004482:	00b6561b          	srlw	a2,a2,0xb
    80004486:	0156063b          	addw	a2,a2,s5
    8000448a:	4685                	li	a3,1
    8000448c:	4156561b          	sraw	a2,a2,0x15
    80004490:	85ca                	mv	a1,s2
    80004492:	0b0a3503          	ld	a0,176(s4)
    80004496:	ffffd097          	auipc	ra,0xffffd
    8000449a:	734080e7          	jalr	1844(ra) # 80001bca <uvmunmap_huge>
    8000449e:	a8b1                	j	800044fa <sys_munmap+0x10c>
        // printf("page table exists for va %p, but not valid\n", a);
        continue;
        panic("munmap: not mapped");
      }
      if(PTE_FLAGS(*pte) == PTE_V)
        panic("munmap: not a leaf");
    800044a0:	00005517          	auipc	a0,0x5
    800044a4:	f2850513          	add	a0,a0,-216 # 800093c8 <etext+0x3c8>
    800044a8:	ffffc097          	auipc	ra,0xffffc
    800044ac:	0ee080e7          	jalr	238(ra) # 80000596 <panic>
    for(a = addr; a < addr + length; a += PGSIZE){
    800044b0:	995a                	add	s2,s2,s6
    800044b2:	fa843783          	ld	a5,-88(s0)
    800044b6:	97d6                	add	a5,a5,s5
    800044b8:	02f97e63          	bgeu	s2,a5,800044f4 <sys_munmap+0x106>
      if((pte = walk(p->pagetable, a, 0)) == 0)
    800044bc:	4601                	li	a2,0
    800044be:	85ca                	mv	a1,s2
    800044c0:	0b0a3503          	ld	a0,176(s4)
    800044c4:	ffffd097          	auipc	ra,0xffffd
    800044c8:	2d4080e7          	jalr	724(ra) # 80001798 <walk>
    800044cc:	84aa                	mv	s1,a0
    800044ce:	d16d                	beqz	a0,800044b0 <sys_munmap+0xc2>
      if((*pte & PTE_V) == 0)
    800044d0:	611c                	ld	a5,0(a0)
    800044d2:	0017f713          	and	a4,a5,1
    800044d6:	df69                	beqz	a4,800044b0 <sys_munmap+0xc2>
      if(PTE_FLAGS(*pte) == PTE_V)
    800044d8:	3ff7f713          	and	a4,a5,1023
    800044dc:	fd8702e3          	beq	a4,s8,800044a0 <sys_munmap+0xb2>

      // actually free
      // TODO : 여기는 이후 Fork등에선 free 안해야 할수도
      //TODO : fix this (do_free) for fork()
      uint64 pa = PTE2PA(*pte);
    800044e0:	00a7d513          	srl	a0,a5,0xa
      kfree((void*)pa);
    800044e4:	0532                	sll	a0,a0,0xc
    800044e6:	ffffd097          	auipc	ra,0xffffd
    800044ea:	8e2080e7          	jalr	-1822(ra) # 80000dc8 <kfree>
      
      //printf("uvmunmap for pte-%p : %p\n",pte,*pte);
      *pte = 0;
    800044ee:	0004b023          	sd	zero,0(s1)
    800044f2:	bf7d                	j	800044b0 <sys_munmap+0xc2>
    800044f4:	64a6                	ld	s1,72(sp)
    800044f6:	7b02                	ld	s6,32(sp)
    800044f8:	6c42                	ld	s8,16(sp)
    //uvmunmap(p->pagetable, addr, length/4096, 1);    
  }


  //unmmaping includes clearing out address
  p->mmap_list[page_index] = 0;
    800044fa:	0209bc23          	sd	zero,56(s3)
  p->mmap_list[page_index+1] = 0;
    800044fe:	0409b023          	sd	zero,64(s3)
  p->mmap_list[page_index+2] = 0;
    80004502:	0409b423          	sd	zero,72(s3)
  
  release(&mmaplock);
    80004506:	00025517          	auipc	a0,0x25
    8000450a:	bea50513          	add	a0,a0,-1046 # 800290f0 <mmaplock>
    8000450e:	ffffd097          	auipc	ra,0xffffd
    80004512:	f5a080e7          	jalr	-166(ra) # 80001468 <release>



  return 0;
    80004516:	6906                	ld	s2,64(sp)
    80004518:	79e2                	ld	s3,56(sp)
    8000451a:	7a42                	ld	s4,48(sp)
    8000451c:	7aa2                	ld	s5,40(sp)
}
    8000451e:	855e                	mv	a0,s7
    80004520:	60e6                	ld	ra,88(sp)
    80004522:	6446                	ld	s0,80(sp)
    80004524:	6be2                	ld	s7,24(sp)
    80004526:	6125                	add	sp,sp,96
    80004528:	8082                	ret
    return -1;
    8000452a:	5bfd                	li	s7,-1
    8000452c:	bfcd                	j	8000451e <sys_munmap+0x130>
    8000452e:	5bfd                	li	s7,-1
    80004530:	b7fd                	j	8000451e <sys_munmap+0x130>
  length = p->mmap_list[page_index+1];
    80004532:	098e                	sll	s3,s3,0x3
    80004534:	99d2                	add	s3,s3,s4
    80004536:	0409aa83          	lw	s5,64(s3)
  flags = p->mmap_list[page_index+2];
    8000453a:	0489b783          	ld	a5,72(s3)
  if(HUGE_MASK & flags)
    8000453e:	1007f793          	and	a5,a5,256
    80004542:	ff95                	bnez	a5,8000447e <sys_munmap+0x90>
    for(a = addr; a < addr + length; a += PGSIZE){
    80004544:	015907b3          	add	a5,s2,s5
    80004548:	faf979e3          	bgeu	s2,a5,800044fa <sys_munmap+0x10c>
    8000454c:	e4a6                	sd	s1,72(sp)
    8000454e:	f05a                	sd	s6,32(sp)
    80004550:	e862                	sd	s8,16(sp)
      if(PTE_FLAGS(*pte) == PTE_V)
    80004552:	4c05                	li	s8,1
    for(a = addr; a < addr + length; a += PGSIZE){
    80004554:	6b05                	lui	s6,0x1
    80004556:	b79d                	j	800044bc <sys_munmap+0xce>

0000000080004558 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80004558:	7179                	add	sp,sp,-48
    8000455a:	f406                	sd	ra,40(sp)
    8000455c:	f022                	sd	s0,32(sp)
    8000455e:	ec26                	sd	s1,24(sp)
    80004560:	e84a                	sd	s2,16(sp)
    80004562:	e44e                	sd	s3,8(sp)
    80004564:	e052                	sd	s4,0(sp)
    80004566:	1800                	add	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80004568:	00005597          	auipc	a1,0x5
    8000456c:	10858593          	add	a1,a1,264 # 80009670 <etext+0x670>
    80004570:	00025517          	auipc	a0,0x25
    80004574:	b9850513          	add	a0,a0,-1128 # 80029108 <bcache>
    80004578:	ffffd097          	auipc	ra,0xffffd
    8000457c:	dac080e7          	jalr	-596(ra) # 80001324 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80004580:	0002d797          	auipc	a5,0x2d
    80004584:	b8878793          	add	a5,a5,-1144 # 80031108 <bcache+0x8000>
    80004588:	0002d717          	auipc	a4,0x2d
    8000458c:	de870713          	add	a4,a4,-536 # 80031370 <bcache+0x8268>
    80004590:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80004594:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80004598:	00025497          	auipc	s1,0x25
    8000459c:	b8848493          	add	s1,s1,-1144 # 80029120 <bcache+0x18>
    b->next = bcache.head.next;
    800045a0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800045a2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800045a4:	00005a17          	auipc	s4,0x5
    800045a8:	0d4a0a13          	add	s4,s4,212 # 80009678 <etext+0x678>
    b->next = bcache.head.next;
    800045ac:	2b893783          	ld	a5,696(s2)
    800045b0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800045b2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800045b6:	85d2                	mv	a1,s4
    800045b8:	01048513          	add	a0,s1,16
    800045bc:	00001097          	auipc	ra,0x1
    800045c0:	4e8080e7          	jalr	1256(ra) # 80005aa4 <initsleeplock>
    bcache.head.next->prev = b;
    800045c4:	2b893783          	ld	a5,696(s2)
    800045c8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800045ca:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800045ce:	45848493          	add	s1,s1,1112
    800045d2:	fd349de3          	bne	s1,s3,800045ac <binit+0x54>
  }
}
    800045d6:	70a2                	ld	ra,40(sp)
    800045d8:	7402                	ld	s0,32(sp)
    800045da:	64e2                	ld	s1,24(sp)
    800045dc:	6942                	ld	s2,16(sp)
    800045de:	69a2                	ld	s3,8(sp)
    800045e0:	6a02                	ld	s4,0(sp)
    800045e2:	6145                	add	sp,sp,48
    800045e4:	8082                	ret

00000000800045e6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800045e6:	7179                	add	sp,sp,-48
    800045e8:	f406                	sd	ra,40(sp)
    800045ea:	f022                	sd	s0,32(sp)
    800045ec:	ec26                	sd	s1,24(sp)
    800045ee:	e84a                	sd	s2,16(sp)
    800045f0:	e44e                	sd	s3,8(sp)
    800045f2:	1800                	add	s0,sp,48
    800045f4:	892a                	mv	s2,a0
    800045f6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800045f8:	00025517          	auipc	a0,0x25
    800045fc:	b1050513          	add	a0,a0,-1264 # 80029108 <bcache>
    80004600:	ffffd097          	auipc	ra,0xffffd
    80004604:	db4080e7          	jalr	-588(ra) # 800013b4 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80004608:	0002d497          	auipc	s1,0x2d
    8000460c:	db84b483          	ld	s1,-584(s1) # 800313c0 <bcache+0x82b8>
    80004610:	0002d797          	auipc	a5,0x2d
    80004614:	d6078793          	add	a5,a5,-672 # 80031370 <bcache+0x8268>
    80004618:	02f48f63          	beq	s1,a5,80004656 <bread+0x70>
    8000461c:	873e                	mv	a4,a5
    8000461e:	a021                	j	80004626 <bread+0x40>
    80004620:	68a4                	ld	s1,80(s1)
    80004622:	02e48a63          	beq	s1,a4,80004656 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80004626:	449c                	lw	a5,8(s1)
    80004628:	ff279ce3          	bne	a5,s2,80004620 <bread+0x3a>
    8000462c:	44dc                	lw	a5,12(s1)
    8000462e:	ff3799e3          	bne	a5,s3,80004620 <bread+0x3a>
      b->refcnt++;
    80004632:	40bc                	lw	a5,64(s1)
    80004634:	2785                	addw	a5,a5,1
    80004636:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80004638:	00025517          	auipc	a0,0x25
    8000463c:	ad050513          	add	a0,a0,-1328 # 80029108 <bcache>
    80004640:	ffffd097          	auipc	ra,0xffffd
    80004644:	e28080e7          	jalr	-472(ra) # 80001468 <release>
      acquiresleep(&b->lock);
    80004648:	01048513          	add	a0,s1,16
    8000464c:	00001097          	auipc	ra,0x1
    80004650:	492080e7          	jalr	1170(ra) # 80005ade <acquiresleep>
      return b;
    80004654:	a8b9                	j	800046b2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004656:	0002d497          	auipc	s1,0x2d
    8000465a:	d624b483          	ld	s1,-670(s1) # 800313b8 <bcache+0x82b0>
    8000465e:	0002d797          	auipc	a5,0x2d
    80004662:	d1278793          	add	a5,a5,-750 # 80031370 <bcache+0x8268>
    80004666:	00f48863          	beq	s1,a5,80004676 <bread+0x90>
    8000466a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000466c:	40bc                	lw	a5,64(s1)
    8000466e:	cf81                	beqz	a5,80004686 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80004670:	64a4                	ld	s1,72(s1)
    80004672:	fee49de3          	bne	s1,a4,8000466c <bread+0x86>
  panic("bget: no buffers");
    80004676:	00005517          	auipc	a0,0x5
    8000467a:	00a50513          	add	a0,a0,10 # 80009680 <etext+0x680>
    8000467e:	ffffc097          	auipc	ra,0xffffc
    80004682:	f18080e7          	jalr	-232(ra) # 80000596 <panic>
      b->dev = dev;
    80004686:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000468a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000468e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80004692:	4785                	li	a5,1
    80004694:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80004696:	00025517          	auipc	a0,0x25
    8000469a:	a7250513          	add	a0,a0,-1422 # 80029108 <bcache>
    8000469e:	ffffd097          	auipc	ra,0xffffd
    800046a2:	dca080e7          	jalr	-566(ra) # 80001468 <release>
      acquiresleep(&b->lock);
    800046a6:	01048513          	add	a0,s1,16
    800046aa:	00001097          	auipc	ra,0x1
    800046ae:	434080e7          	jalr	1076(ra) # 80005ade <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800046b2:	409c                	lw	a5,0(s1)
    800046b4:	cb89                	beqz	a5,800046c6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800046b6:	8526                	mv	a0,s1
    800046b8:	70a2                	ld	ra,40(sp)
    800046ba:	7402                	ld	s0,32(sp)
    800046bc:	64e2                	ld	s1,24(sp)
    800046be:	6942                	ld	s2,16(sp)
    800046c0:	69a2                	ld	s3,8(sp)
    800046c2:	6145                	add	sp,sp,48
    800046c4:	8082                	ret
    virtio_disk_rw(b, 0);
    800046c6:	4581                	li	a1,0
    800046c8:	8526                	mv	a0,s1
    800046ca:	00003097          	auipc	ra,0x3
    800046ce:	11e080e7          	jalr	286(ra) # 800077e8 <virtio_disk_rw>
    b->valid = 1;
    800046d2:	4785                	li	a5,1
    800046d4:	c09c                	sw	a5,0(s1)
  return b;
    800046d6:	b7c5                	j	800046b6 <bread+0xd0>

00000000800046d8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800046d8:	1101                	add	sp,sp,-32
    800046da:	ec06                	sd	ra,24(sp)
    800046dc:	e822                	sd	s0,16(sp)
    800046de:	e426                	sd	s1,8(sp)
    800046e0:	1000                	add	s0,sp,32
    800046e2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800046e4:	0541                	add	a0,a0,16
    800046e6:	00001097          	auipc	ra,0x1
    800046ea:	492080e7          	jalr	1170(ra) # 80005b78 <holdingsleep>
    800046ee:	cd01                	beqz	a0,80004706 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800046f0:	4585                	li	a1,1
    800046f2:	8526                	mv	a0,s1
    800046f4:	00003097          	auipc	ra,0x3
    800046f8:	0f4080e7          	jalr	244(ra) # 800077e8 <virtio_disk_rw>
}
    800046fc:	60e2                	ld	ra,24(sp)
    800046fe:	6442                	ld	s0,16(sp)
    80004700:	64a2                	ld	s1,8(sp)
    80004702:	6105                	add	sp,sp,32
    80004704:	8082                	ret
    panic("bwrite");
    80004706:	00005517          	auipc	a0,0x5
    8000470a:	f9250513          	add	a0,a0,-110 # 80009698 <etext+0x698>
    8000470e:	ffffc097          	auipc	ra,0xffffc
    80004712:	e88080e7          	jalr	-376(ra) # 80000596 <panic>

0000000080004716 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80004716:	1101                	add	sp,sp,-32
    80004718:	ec06                	sd	ra,24(sp)
    8000471a:	e822                	sd	s0,16(sp)
    8000471c:	e426                	sd	s1,8(sp)
    8000471e:	e04a                	sd	s2,0(sp)
    80004720:	1000                	add	s0,sp,32
    80004722:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80004724:	01050913          	add	s2,a0,16
    80004728:	854a                	mv	a0,s2
    8000472a:	00001097          	auipc	ra,0x1
    8000472e:	44e080e7          	jalr	1102(ra) # 80005b78 <holdingsleep>
    80004732:	c925                	beqz	a0,800047a2 <brelse+0x8c>
    panic("brelse");

  releasesleep(&b->lock);
    80004734:	854a                	mv	a0,s2
    80004736:	00001097          	auipc	ra,0x1
    8000473a:	3fe080e7          	jalr	1022(ra) # 80005b34 <releasesleep>

  acquire(&bcache.lock);
    8000473e:	00025517          	auipc	a0,0x25
    80004742:	9ca50513          	add	a0,a0,-1590 # 80029108 <bcache>
    80004746:	ffffd097          	auipc	ra,0xffffd
    8000474a:	c6e080e7          	jalr	-914(ra) # 800013b4 <acquire>
  b->refcnt--;
    8000474e:	40bc                	lw	a5,64(s1)
    80004750:	37fd                	addw	a5,a5,-1
    80004752:	0007871b          	sext.w	a4,a5
    80004756:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80004758:	e71d                	bnez	a4,80004786 <brelse+0x70>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000475a:	68b8                	ld	a4,80(s1)
    8000475c:	64bc                	ld	a5,72(s1)
    8000475e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80004760:	68b8                	ld	a4,80(s1)
    80004762:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80004764:	0002d797          	auipc	a5,0x2d
    80004768:	9a478793          	add	a5,a5,-1628 # 80031108 <bcache+0x8000>
    8000476c:	2b87b703          	ld	a4,696(a5)
    80004770:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80004772:	0002d717          	auipc	a4,0x2d
    80004776:	bfe70713          	add	a4,a4,-1026 # 80031370 <bcache+0x8268>
    8000477a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000477c:	2b87b703          	ld	a4,696(a5)
    80004780:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80004782:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80004786:	00025517          	auipc	a0,0x25
    8000478a:	98250513          	add	a0,a0,-1662 # 80029108 <bcache>
    8000478e:	ffffd097          	auipc	ra,0xffffd
    80004792:	cda080e7          	jalr	-806(ra) # 80001468 <release>
}
    80004796:	60e2                	ld	ra,24(sp)
    80004798:	6442                	ld	s0,16(sp)
    8000479a:	64a2                	ld	s1,8(sp)
    8000479c:	6902                	ld	s2,0(sp)
    8000479e:	6105                	add	sp,sp,32
    800047a0:	8082                	ret
    panic("brelse");
    800047a2:	00005517          	auipc	a0,0x5
    800047a6:	efe50513          	add	a0,a0,-258 # 800096a0 <etext+0x6a0>
    800047aa:	ffffc097          	auipc	ra,0xffffc
    800047ae:	dec080e7          	jalr	-532(ra) # 80000596 <panic>

00000000800047b2 <bpin>:

void
bpin(struct buf *b) {
    800047b2:	1101                	add	sp,sp,-32
    800047b4:	ec06                	sd	ra,24(sp)
    800047b6:	e822                	sd	s0,16(sp)
    800047b8:	e426                	sd	s1,8(sp)
    800047ba:	1000                	add	s0,sp,32
    800047bc:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800047be:	00025517          	auipc	a0,0x25
    800047c2:	94a50513          	add	a0,a0,-1718 # 80029108 <bcache>
    800047c6:	ffffd097          	auipc	ra,0xffffd
    800047ca:	bee080e7          	jalr	-1042(ra) # 800013b4 <acquire>
  b->refcnt++;
    800047ce:	40bc                	lw	a5,64(s1)
    800047d0:	2785                	addw	a5,a5,1
    800047d2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800047d4:	00025517          	auipc	a0,0x25
    800047d8:	93450513          	add	a0,a0,-1740 # 80029108 <bcache>
    800047dc:	ffffd097          	auipc	ra,0xffffd
    800047e0:	c8c080e7          	jalr	-884(ra) # 80001468 <release>
}
    800047e4:	60e2                	ld	ra,24(sp)
    800047e6:	6442                	ld	s0,16(sp)
    800047e8:	64a2                	ld	s1,8(sp)
    800047ea:	6105                	add	sp,sp,32
    800047ec:	8082                	ret

00000000800047ee <bunpin>:

void
bunpin(struct buf *b) {
    800047ee:	1101                	add	sp,sp,-32
    800047f0:	ec06                	sd	ra,24(sp)
    800047f2:	e822                	sd	s0,16(sp)
    800047f4:	e426                	sd	s1,8(sp)
    800047f6:	1000                	add	s0,sp,32
    800047f8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800047fa:	00025517          	auipc	a0,0x25
    800047fe:	90e50513          	add	a0,a0,-1778 # 80029108 <bcache>
    80004802:	ffffd097          	auipc	ra,0xffffd
    80004806:	bb2080e7          	jalr	-1102(ra) # 800013b4 <acquire>
  b->refcnt--;
    8000480a:	40bc                	lw	a5,64(s1)
    8000480c:	37fd                	addw	a5,a5,-1
    8000480e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80004810:	00025517          	auipc	a0,0x25
    80004814:	8f850513          	add	a0,a0,-1800 # 80029108 <bcache>
    80004818:	ffffd097          	auipc	ra,0xffffd
    8000481c:	c50080e7          	jalr	-944(ra) # 80001468 <release>
}
    80004820:	60e2                	ld	ra,24(sp)
    80004822:	6442                	ld	s0,16(sp)
    80004824:	64a2                	ld	s1,8(sp)
    80004826:	6105                	add	sp,sp,32
    80004828:	8082                	ret

000000008000482a <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000482a:	1101                	add	sp,sp,-32
    8000482c:	ec06                	sd	ra,24(sp)
    8000482e:	e822                	sd	s0,16(sp)
    80004830:	e426                	sd	s1,8(sp)
    80004832:	e04a                	sd	s2,0(sp)
    80004834:	1000                	add	s0,sp,32
    80004836:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80004838:	00d5d59b          	srlw	a1,a1,0xd
    8000483c:	0002d797          	auipc	a5,0x2d
    80004840:	fa87a783          	lw	a5,-88(a5) # 800317e4 <sb+0x1c>
    80004844:	9dbd                	addw	a1,a1,a5
    80004846:	00000097          	auipc	ra,0x0
    8000484a:	da0080e7          	jalr	-608(ra) # 800045e6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000484e:	0074f713          	and	a4,s1,7
    80004852:	4785                	li	a5,1
    80004854:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80004858:	14ce                	sll	s1,s1,0x33
    8000485a:	90d9                	srl	s1,s1,0x36
    8000485c:	00950733          	add	a4,a0,s1
    80004860:	05874703          	lbu	a4,88(a4)
    80004864:	00e7f6b3          	and	a3,a5,a4
    80004868:	c69d                	beqz	a3,80004896 <bfree+0x6c>
    8000486a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000486c:	94aa                	add	s1,s1,a0
    8000486e:	fff7c793          	not	a5,a5
    80004872:	8f7d                	and	a4,a4,a5
    80004874:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80004878:	00001097          	auipc	ra,0x1
    8000487c:	148080e7          	jalr	328(ra) # 800059c0 <log_write>
  brelse(bp);
    80004880:	854a                	mv	a0,s2
    80004882:	00000097          	auipc	ra,0x0
    80004886:	e94080e7          	jalr	-364(ra) # 80004716 <brelse>
}
    8000488a:	60e2                	ld	ra,24(sp)
    8000488c:	6442                	ld	s0,16(sp)
    8000488e:	64a2                	ld	s1,8(sp)
    80004890:	6902                	ld	s2,0(sp)
    80004892:	6105                	add	sp,sp,32
    80004894:	8082                	ret
    panic("freeing free block");
    80004896:	00005517          	auipc	a0,0x5
    8000489a:	e1250513          	add	a0,a0,-494 # 800096a8 <etext+0x6a8>
    8000489e:	ffffc097          	auipc	ra,0xffffc
    800048a2:	cf8080e7          	jalr	-776(ra) # 80000596 <panic>

00000000800048a6 <balloc>:
{
    800048a6:	711d                	add	sp,sp,-96
    800048a8:	ec86                	sd	ra,88(sp)
    800048aa:	e8a2                	sd	s0,80(sp)
    800048ac:	e4a6                	sd	s1,72(sp)
    800048ae:	1080                	add	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800048b0:	0002d797          	auipc	a5,0x2d
    800048b4:	f1c7a783          	lw	a5,-228(a5) # 800317cc <sb+0x4>
    800048b8:	10078f63          	beqz	a5,800049d6 <balloc+0x130>
    800048bc:	e0ca                	sd	s2,64(sp)
    800048be:	fc4e                	sd	s3,56(sp)
    800048c0:	f852                	sd	s4,48(sp)
    800048c2:	f456                	sd	s5,40(sp)
    800048c4:	f05a                	sd	s6,32(sp)
    800048c6:	ec5e                	sd	s7,24(sp)
    800048c8:	e862                	sd	s8,16(sp)
    800048ca:	e466                	sd	s9,8(sp)
    800048cc:	8baa                	mv	s7,a0
    800048ce:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800048d0:	0002db17          	auipc	s6,0x2d
    800048d4:	ef8b0b13          	add	s6,s6,-264 # 800317c8 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800048d8:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800048da:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800048dc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800048de:	6c89                	lui	s9,0x2
    800048e0:	a061                	j	80004968 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800048e2:	97ca                	add	a5,a5,s2
    800048e4:	8e55                	or	a2,a2,a3
    800048e6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800048ea:	854a                	mv	a0,s2
    800048ec:	00001097          	auipc	ra,0x1
    800048f0:	0d4080e7          	jalr	212(ra) # 800059c0 <log_write>
        brelse(bp);
    800048f4:	854a                	mv	a0,s2
    800048f6:	00000097          	auipc	ra,0x0
    800048fa:	e20080e7          	jalr	-480(ra) # 80004716 <brelse>
  bp = bread(dev, bno);
    800048fe:	85a6                	mv	a1,s1
    80004900:	855e                	mv	a0,s7
    80004902:	00000097          	auipc	ra,0x0
    80004906:	ce4080e7          	jalr	-796(ra) # 800045e6 <bread>
    8000490a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000490c:	40000613          	li	a2,1024
    80004910:	4581                	li	a1,0
    80004912:	05850513          	add	a0,a0,88
    80004916:	ffffd097          	auipc	ra,0xffffd
    8000491a:	b9a080e7          	jalr	-1126(ra) # 800014b0 <memset>
  log_write(bp);
    8000491e:	854a                	mv	a0,s2
    80004920:	00001097          	auipc	ra,0x1
    80004924:	0a0080e7          	jalr	160(ra) # 800059c0 <log_write>
  brelse(bp);
    80004928:	854a                	mv	a0,s2
    8000492a:	00000097          	auipc	ra,0x0
    8000492e:	dec080e7          	jalr	-532(ra) # 80004716 <brelse>
}
    80004932:	6906                	ld	s2,64(sp)
    80004934:	79e2                	ld	s3,56(sp)
    80004936:	7a42                	ld	s4,48(sp)
    80004938:	7aa2                	ld	s5,40(sp)
    8000493a:	7b02                	ld	s6,32(sp)
    8000493c:	6be2                	ld	s7,24(sp)
    8000493e:	6c42                	ld	s8,16(sp)
    80004940:	6ca2                	ld	s9,8(sp)
}
    80004942:	8526                	mv	a0,s1
    80004944:	60e6                	ld	ra,88(sp)
    80004946:	6446                	ld	s0,80(sp)
    80004948:	64a6                	ld	s1,72(sp)
    8000494a:	6125                	add	sp,sp,96
    8000494c:	8082                	ret
    brelse(bp);
    8000494e:	854a                	mv	a0,s2
    80004950:	00000097          	auipc	ra,0x0
    80004954:	dc6080e7          	jalr	-570(ra) # 80004716 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80004958:	015c87bb          	addw	a5,s9,s5
    8000495c:	00078a9b          	sext.w	s5,a5
    80004960:	004b2703          	lw	a4,4(s6)
    80004964:	06eaf163          	bgeu	s5,a4,800049c6 <balloc+0x120>
    bp = bread(dev, BBLOCK(b, sb));
    80004968:	41fad79b          	sraw	a5,s5,0x1f
    8000496c:	0137d79b          	srlw	a5,a5,0x13
    80004970:	015787bb          	addw	a5,a5,s5
    80004974:	40d7d79b          	sraw	a5,a5,0xd
    80004978:	01cb2583          	lw	a1,28(s6)
    8000497c:	9dbd                	addw	a1,a1,a5
    8000497e:	855e                	mv	a0,s7
    80004980:	00000097          	auipc	ra,0x0
    80004984:	c66080e7          	jalr	-922(ra) # 800045e6 <bread>
    80004988:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000498a:	004b2503          	lw	a0,4(s6)
    8000498e:	000a849b          	sext.w	s1,s5
    80004992:	8762                	mv	a4,s8
    80004994:	faa4fde3          	bgeu	s1,a0,8000494e <balloc+0xa8>
      m = 1 << (bi % 8);
    80004998:	00777693          	and	a3,a4,7
    8000499c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800049a0:	41f7579b          	sraw	a5,a4,0x1f
    800049a4:	01d7d79b          	srlw	a5,a5,0x1d
    800049a8:	9fb9                	addw	a5,a5,a4
    800049aa:	4037d79b          	sraw	a5,a5,0x3
    800049ae:	00f90633          	add	a2,s2,a5
    800049b2:	05864603          	lbu	a2,88(a2)
    800049b6:	00c6f5b3          	and	a1,a3,a2
    800049ba:	d585                	beqz	a1,800048e2 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800049bc:	2705                	addw	a4,a4,1
    800049be:	2485                	addw	s1,s1,1
    800049c0:	fd471ae3          	bne	a4,s4,80004994 <balloc+0xee>
    800049c4:	b769                	j	8000494e <balloc+0xa8>
    800049c6:	6906                	ld	s2,64(sp)
    800049c8:	79e2                	ld	s3,56(sp)
    800049ca:	7a42                	ld	s4,48(sp)
    800049cc:	7aa2                	ld	s5,40(sp)
    800049ce:	7b02                	ld	s6,32(sp)
    800049d0:	6be2                	ld	s7,24(sp)
    800049d2:	6c42                	ld	s8,16(sp)
    800049d4:	6ca2                	ld	s9,8(sp)
  printf("balloc: out of blocks\n");
    800049d6:	00005517          	auipc	a0,0x5
    800049da:	cea50513          	add	a0,a0,-790 # 800096c0 <etext+0x6c0>
    800049de:	ffffc097          	auipc	ra,0xffffc
    800049e2:	c02080e7          	jalr	-1022(ra) # 800005e0 <printf>
  return 0;
    800049e6:	4481                	li	s1,0
    800049e8:	bfa9                	j	80004942 <balloc+0x9c>

00000000800049ea <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800049ea:	7179                	add	sp,sp,-48
    800049ec:	f406                	sd	ra,40(sp)
    800049ee:	f022                	sd	s0,32(sp)
    800049f0:	ec26                	sd	s1,24(sp)
    800049f2:	e84a                	sd	s2,16(sp)
    800049f4:	e44e                	sd	s3,8(sp)
    800049f6:	1800                	add	s0,sp,48
    800049f8:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800049fa:	47ad                	li	a5,11
    800049fc:	02b7e863          	bltu	a5,a1,80004a2c <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80004a00:	02059793          	sll	a5,a1,0x20
    80004a04:	01e7d593          	srl	a1,a5,0x1e
    80004a08:	00b504b3          	add	s1,a0,a1
    80004a0c:	0504a903          	lw	s2,80(s1)
    80004a10:	08091263          	bnez	s2,80004a94 <bmap+0xaa>
      addr = balloc(ip->dev);
    80004a14:	4108                	lw	a0,0(a0)
    80004a16:	00000097          	auipc	ra,0x0
    80004a1a:	e90080e7          	jalr	-368(ra) # 800048a6 <balloc>
    80004a1e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80004a22:	06090963          	beqz	s2,80004a94 <bmap+0xaa>
        return 0;
      ip->addrs[bn] = addr;
    80004a26:	0524a823          	sw	s2,80(s1)
    80004a2a:	a0ad                	j	80004a94 <bmap+0xaa>
    }
    return addr;
  }
  bn -= NDIRECT;
    80004a2c:	ff45849b          	addw	s1,a1,-12
    80004a30:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80004a34:	0ff00793          	li	a5,255
    80004a38:	08e7e863          	bltu	a5,a4,80004ac8 <bmap+0xde>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80004a3c:	08052903          	lw	s2,128(a0)
    80004a40:	00091f63          	bnez	s2,80004a5e <bmap+0x74>
      addr = balloc(ip->dev);
    80004a44:	4108                	lw	a0,0(a0)
    80004a46:	00000097          	auipc	ra,0x0
    80004a4a:	e60080e7          	jalr	-416(ra) # 800048a6 <balloc>
    80004a4e:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80004a52:	04090163          	beqz	s2,80004a94 <bmap+0xaa>
    80004a56:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80004a58:	0929a023          	sw	s2,128(s3)
    80004a5c:	a011                	j	80004a60 <bmap+0x76>
    80004a5e:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80004a60:	85ca                	mv	a1,s2
    80004a62:	0009a503          	lw	a0,0(s3)
    80004a66:	00000097          	auipc	ra,0x0
    80004a6a:	b80080e7          	jalr	-1152(ra) # 800045e6 <bread>
    80004a6e:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80004a70:	05850793          	add	a5,a0,88
    if((addr = a[bn]) == 0){
    80004a74:	02049713          	sll	a4,s1,0x20
    80004a78:	01e75593          	srl	a1,a4,0x1e
    80004a7c:	00b784b3          	add	s1,a5,a1
    80004a80:	0004a903          	lw	s2,0(s1)
    80004a84:	02090063          	beqz	s2,80004aa4 <bmap+0xba>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80004a88:	8552                	mv	a0,s4
    80004a8a:	00000097          	auipc	ra,0x0
    80004a8e:	c8c080e7          	jalr	-884(ra) # 80004716 <brelse>
    return addr;
    80004a92:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80004a94:	854a                	mv	a0,s2
    80004a96:	70a2                	ld	ra,40(sp)
    80004a98:	7402                	ld	s0,32(sp)
    80004a9a:	64e2                	ld	s1,24(sp)
    80004a9c:	6942                	ld	s2,16(sp)
    80004a9e:	69a2                	ld	s3,8(sp)
    80004aa0:	6145                	add	sp,sp,48
    80004aa2:	8082                	ret
      addr = balloc(ip->dev);
    80004aa4:	0009a503          	lw	a0,0(s3)
    80004aa8:	00000097          	auipc	ra,0x0
    80004aac:	dfe080e7          	jalr	-514(ra) # 800048a6 <balloc>
    80004ab0:	0005091b          	sext.w	s2,a0
      if(addr){
    80004ab4:	fc090ae3          	beqz	s2,80004a88 <bmap+0x9e>
        a[bn] = addr;
    80004ab8:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    80004abc:	8552                	mv	a0,s4
    80004abe:	00001097          	auipc	ra,0x1
    80004ac2:	f02080e7          	jalr	-254(ra) # 800059c0 <log_write>
    80004ac6:	b7c9                	j	80004a88 <bmap+0x9e>
    80004ac8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80004aca:	00005517          	auipc	a0,0x5
    80004ace:	c0e50513          	add	a0,a0,-1010 # 800096d8 <etext+0x6d8>
    80004ad2:	ffffc097          	auipc	ra,0xffffc
    80004ad6:	ac4080e7          	jalr	-1340(ra) # 80000596 <panic>

0000000080004ada <iget>:
{
    80004ada:	7179                	add	sp,sp,-48
    80004adc:	f406                	sd	ra,40(sp)
    80004ade:	f022                	sd	s0,32(sp)
    80004ae0:	ec26                	sd	s1,24(sp)
    80004ae2:	e84a                	sd	s2,16(sp)
    80004ae4:	e44e                	sd	s3,8(sp)
    80004ae6:	e052                	sd	s4,0(sp)
    80004ae8:	1800                	add	s0,sp,48
    80004aea:	89aa                	mv	s3,a0
    80004aec:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80004aee:	0002d517          	auipc	a0,0x2d
    80004af2:	cfa50513          	add	a0,a0,-774 # 800317e8 <itable>
    80004af6:	ffffd097          	auipc	ra,0xffffd
    80004afa:	8be080e7          	jalr	-1858(ra) # 800013b4 <acquire>
  empty = 0;
    80004afe:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004b00:	0002d497          	auipc	s1,0x2d
    80004b04:	d0048493          	add	s1,s1,-768 # 80031800 <itable+0x18>
    80004b08:	0002e697          	auipc	a3,0x2e
    80004b0c:	78868693          	add	a3,a3,1928 # 80033290 <log>
    80004b10:	a039                	j	80004b1e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004b12:	02090b63          	beqz	s2,80004b48 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80004b16:	08848493          	add	s1,s1,136
    80004b1a:	02d48a63          	beq	s1,a3,80004b4e <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80004b1e:	449c                	lw	a5,8(s1)
    80004b20:	fef059e3          	blez	a5,80004b12 <iget+0x38>
    80004b24:	4098                	lw	a4,0(s1)
    80004b26:	ff3716e3          	bne	a4,s3,80004b12 <iget+0x38>
    80004b2a:	40d8                	lw	a4,4(s1)
    80004b2c:	ff4713e3          	bne	a4,s4,80004b12 <iget+0x38>
      ip->ref++;
    80004b30:	2785                	addw	a5,a5,1
    80004b32:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80004b34:	0002d517          	auipc	a0,0x2d
    80004b38:	cb450513          	add	a0,a0,-844 # 800317e8 <itable>
    80004b3c:	ffffd097          	auipc	ra,0xffffd
    80004b40:	92c080e7          	jalr	-1748(ra) # 80001468 <release>
      return ip;
    80004b44:	8926                	mv	s2,s1
    80004b46:	a03d                	j	80004b74 <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80004b48:	f7f9                	bnez	a5,80004b16 <iget+0x3c>
      empty = ip;
    80004b4a:	8926                	mv	s2,s1
    80004b4c:	b7e9                	j	80004b16 <iget+0x3c>
  if(empty == 0)
    80004b4e:	02090c63          	beqz	s2,80004b86 <iget+0xac>
  ip->dev = dev;
    80004b52:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80004b56:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80004b5a:	4785                	li	a5,1
    80004b5c:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80004b60:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80004b64:	0002d517          	auipc	a0,0x2d
    80004b68:	c8450513          	add	a0,a0,-892 # 800317e8 <itable>
    80004b6c:	ffffd097          	auipc	ra,0xffffd
    80004b70:	8fc080e7          	jalr	-1796(ra) # 80001468 <release>
}
    80004b74:	854a                	mv	a0,s2
    80004b76:	70a2                	ld	ra,40(sp)
    80004b78:	7402                	ld	s0,32(sp)
    80004b7a:	64e2                	ld	s1,24(sp)
    80004b7c:	6942                	ld	s2,16(sp)
    80004b7e:	69a2                	ld	s3,8(sp)
    80004b80:	6a02                	ld	s4,0(sp)
    80004b82:	6145                	add	sp,sp,48
    80004b84:	8082                	ret
    panic("iget: no inodes");
    80004b86:	00005517          	auipc	a0,0x5
    80004b8a:	b6a50513          	add	a0,a0,-1174 # 800096f0 <etext+0x6f0>
    80004b8e:	ffffc097          	auipc	ra,0xffffc
    80004b92:	a08080e7          	jalr	-1528(ra) # 80000596 <panic>

0000000080004b96 <fsinit>:
fsinit(int dev) {
    80004b96:	7179                	add	sp,sp,-48
    80004b98:	f406                	sd	ra,40(sp)
    80004b9a:	f022                	sd	s0,32(sp)
    80004b9c:	ec26                	sd	s1,24(sp)
    80004b9e:	e84a                	sd	s2,16(sp)
    80004ba0:	e44e                	sd	s3,8(sp)
    80004ba2:	1800                	add	s0,sp,48
    80004ba4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80004ba6:	4585                	li	a1,1
    80004ba8:	00000097          	auipc	ra,0x0
    80004bac:	a3e080e7          	jalr	-1474(ra) # 800045e6 <bread>
    80004bb0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80004bb2:	0002d997          	auipc	s3,0x2d
    80004bb6:	c1698993          	add	s3,s3,-1002 # 800317c8 <sb>
    80004bba:	02000613          	li	a2,32
    80004bbe:	05850593          	add	a1,a0,88
    80004bc2:	854e                	mv	a0,s3
    80004bc4:	ffffd097          	auipc	ra,0xffffd
    80004bc8:	948080e7          	jalr	-1720(ra) # 8000150c <memmove>
  brelse(bp);
    80004bcc:	8526                	mv	a0,s1
    80004bce:	00000097          	auipc	ra,0x0
    80004bd2:	b48080e7          	jalr	-1208(ra) # 80004716 <brelse>
  if(sb.magic != FSMAGIC)
    80004bd6:	0009a703          	lw	a4,0(s3)
    80004bda:	102037b7          	lui	a5,0x10203
    80004bde:	04078793          	add	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80004be2:	02f71263          	bne	a4,a5,80004c06 <fsinit+0x70>
  initlog(dev, &sb);
    80004be6:	0002d597          	auipc	a1,0x2d
    80004bea:	be258593          	add	a1,a1,-1054 # 800317c8 <sb>
    80004bee:	854a                	mv	a0,s2
    80004bf0:	00001097          	auipc	ra,0x1
    80004bf4:	b60080e7          	jalr	-1184(ra) # 80005750 <initlog>
}
    80004bf8:	70a2                	ld	ra,40(sp)
    80004bfa:	7402                	ld	s0,32(sp)
    80004bfc:	64e2                	ld	s1,24(sp)
    80004bfe:	6942                	ld	s2,16(sp)
    80004c00:	69a2                	ld	s3,8(sp)
    80004c02:	6145                	add	sp,sp,48
    80004c04:	8082                	ret
    panic("invalid file system");
    80004c06:	00005517          	auipc	a0,0x5
    80004c0a:	afa50513          	add	a0,a0,-1286 # 80009700 <etext+0x700>
    80004c0e:	ffffc097          	auipc	ra,0xffffc
    80004c12:	988080e7          	jalr	-1656(ra) # 80000596 <panic>

0000000080004c16 <iinit>:
{
    80004c16:	7179                	add	sp,sp,-48
    80004c18:	f406                	sd	ra,40(sp)
    80004c1a:	f022                	sd	s0,32(sp)
    80004c1c:	ec26                	sd	s1,24(sp)
    80004c1e:	e84a                	sd	s2,16(sp)
    80004c20:	e44e                	sd	s3,8(sp)
    80004c22:	1800                	add	s0,sp,48
  initlock(&itable.lock, "itable");
    80004c24:	00005597          	auipc	a1,0x5
    80004c28:	af458593          	add	a1,a1,-1292 # 80009718 <etext+0x718>
    80004c2c:	0002d517          	auipc	a0,0x2d
    80004c30:	bbc50513          	add	a0,a0,-1092 # 800317e8 <itable>
    80004c34:	ffffc097          	auipc	ra,0xffffc
    80004c38:	6f0080e7          	jalr	1776(ra) # 80001324 <initlock>
  for(i = 0; i < NINODE; i++) {
    80004c3c:	0002d497          	auipc	s1,0x2d
    80004c40:	bd448493          	add	s1,s1,-1068 # 80031810 <itable+0x28>
    80004c44:	0002e997          	auipc	s3,0x2e
    80004c48:	65c98993          	add	s3,s3,1628 # 800332a0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80004c4c:	00005917          	auipc	s2,0x5
    80004c50:	ad490913          	add	s2,s2,-1324 # 80009720 <etext+0x720>
    80004c54:	85ca                	mv	a1,s2
    80004c56:	8526                	mv	a0,s1
    80004c58:	00001097          	auipc	ra,0x1
    80004c5c:	e4c080e7          	jalr	-436(ra) # 80005aa4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80004c60:	08848493          	add	s1,s1,136
    80004c64:	ff3498e3          	bne	s1,s3,80004c54 <iinit+0x3e>
}
    80004c68:	70a2                	ld	ra,40(sp)
    80004c6a:	7402                	ld	s0,32(sp)
    80004c6c:	64e2                	ld	s1,24(sp)
    80004c6e:	6942                	ld	s2,16(sp)
    80004c70:	69a2                	ld	s3,8(sp)
    80004c72:	6145                	add	sp,sp,48
    80004c74:	8082                	ret

0000000080004c76 <ialloc>:
{
    80004c76:	7139                	add	sp,sp,-64
    80004c78:	fc06                	sd	ra,56(sp)
    80004c7a:	f822                	sd	s0,48(sp)
    80004c7c:	0080                	add	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80004c7e:	0002d717          	auipc	a4,0x2d
    80004c82:	b5672703          	lw	a4,-1194(a4) # 800317d4 <sb+0xc>
    80004c86:	4785                	li	a5,1
    80004c88:	06e7f463          	bgeu	a5,a4,80004cf0 <ialloc+0x7a>
    80004c8c:	f426                	sd	s1,40(sp)
    80004c8e:	f04a                	sd	s2,32(sp)
    80004c90:	ec4e                	sd	s3,24(sp)
    80004c92:	e852                	sd	s4,16(sp)
    80004c94:	e456                	sd	s5,8(sp)
    80004c96:	e05a                	sd	s6,0(sp)
    80004c98:	8aaa                	mv	s5,a0
    80004c9a:	8b2e                	mv	s6,a1
    80004c9c:	4905                	li	s2,1
    bp = bread(dev, IBLOCK(inum, sb));
    80004c9e:	0002da17          	auipc	s4,0x2d
    80004ca2:	b2aa0a13          	add	s4,s4,-1238 # 800317c8 <sb>
    80004ca6:	00495593          	srl	a1,s2,0x4
    80004caa:	018a2783          	lw	a5,24(s4)
    80004cae:	9dbd                	addw	a1,a1,a5
    80004cb0:	8556                	mv	a0,s5
    80004cb2:	00000097          	auipc	ra,0x0
    80004cb6:	934080e7          	jalr	-1740(ra) # 800045e6 <bread>
    80004cba:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80004cbc:	05850993          	add	s3,a0,88
    80004cc0:	00f97793          	and	a5,s2,15
    80004cc4:	079a                	sll	a5,a5,0x6
    80004cc6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80004cc8:	00099783          	lh	a5,0(s3)
    80004ccc:	cf9d                	beqz	a5,80004d0a <ialloc+0x94>
    brelse(bp);
    80004cce:	00000097          	auipc	ra,0x0
    80004cd2:	a48080e7          	jalr	-1464(ra) # 80004716 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80004cd6:	0905                	add	s2,s2,1
    80004cd8:	00ca2703          	lw	a4,12(s4)
    80004cdc:	0009079b          	sext.w	a5,s2
    80004ce0:	fce7e3e3          	bltu	a5,a4,80004ca6 <ialloc+0x30>
    80004ce4:	74a2                	ld	s1,40(sp)
    80004ce6:	7902                	ld	s2,32(sp)
    80004ce8:	69e2                	ld	s3,24(sp)
    80004cea:	6a42                	ld	s4,16(sp)
    80004cec:	6aa2                	ld	s5,8(sp)
    80004cee:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80004cf0:	00005517          	auipc	a0,0x5
    80004cf4:	a3850513          	add	a0,a0,-1480 # 80009728 <etext+0x728>
    80004cf8:	ffffc097          	auipc	ra,0xffffc
    80004cfc:	8e8080e7          	jalr	-1816(ra) # 800005e0 <printf>
  return 0;
    80004d00:	4501                	li	a0,0
}
    80004d02:	70e2                	ld	ra,56(sp)
    80004d04:	7442                	ld	s0,48(sp)
    80004d06:	6121                	add	sp,sp,64
    80004d08:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80004d0a:	04000613          	li	a2,64
    80004d0e:	4581                	li	a1,0
    80004d10:	854e                	mv	a0,s3
    80004d12:	ffffc097          	auipc	ra,0xffffc
    80004d16:	79e080e7          	jalr	1950(ra) # 800014b0 <memset>
      dip->type = type;
    80004d1a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80004d1e:	8526                	mv	a0,s1
    80004d20:	00001097          	auipc	ra,0x1
    80004d24:	ca0080e7          	jalr	-864(ra) # 800059c0 <log_write>
      brelse(bp);
    80004d28:	8526                	mv	a0,s1
    80004d2a:	00000097          	auipc	ra,0x0
    80004d2e:	9ec080e7          	jalr	-1556(ra) # 80004716 <brelse>
      return iget(dev, inum);
    80004d32:	0009059b          	sext.w	a1,s2
    80004d36:	8556                	mv	a0,s5
    80004d38:	00000097          	auipc	ra,0x0
    80004d3c:	da2080e7          	jalr	-606(ra) # 80004ada <iget>
    80004d40:	74a2                	ld	s1,40(sp)
    80004d42:	7902                	ld	s2,32(sp)
    80004d44:	69e2                	ld	s3,24(sp)
    80004d46:	6a42                	ld	s4,16(sp)
    80004d48:	6aa2                	ld	s5,8(sp)
    80004d4a:	6b02                	ld	s6,0(sp)
    80004d4c:	bf5d                	j	80004d02 <ialloc+0x8c>

0000000080004d4e <iupdate>:
{
    80004d4e:	1101                	add	sp,sp,-32
    80004d50:	ec06                	sd	ra,24(sp)
    80004d52:	e822                	sd	s0,16(sp)
    80004d54:	e426                	sd	s1,8(sp)
    80004d56:	e04a                	sd	s2,0(sp)
    80004d58:	1000                	add	s0,sp,32
    80004d5a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004d5c:	415c                	lw	a5,4(a0)
    80004d5e:	0047d79b          	srlw	a5,a5,0x4
    80004d62:	0002d597          	auipc	a1,0x2d
    80004d66:	a7e5a583          	lw	a1,-1410(a1) # 800317e0 <sb+0x18>
    80004d6a:	9dbd                	addw	a1,a1,a5
    80004d6c:	4108                	lw	a0,0(a0)
    80004d6e:	00000097          	auipc	ra,0x0
    80004d72:	878080e7          	jalr	-1928(ra) # 800045e6 <bread>
    80004d76:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004d78:	05850793          	add	a5,a0,88
    80004d7c:	40d8                	lw	a4,4(s1)
    80004d7e:	8b3d                	and	a4,a4,15
    80004d80:	071a                	sll	a4,a4,0x6
    80004d82:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80004d84:	04449703          	lh	a4,68(s1)
    80004d88:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80004d8c:	04649703          	lh	a4,70(s1)
    80004d90:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80004d94:	04849703          	lh	a4,72(s1)
    80004d98:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80004d9c:	04a49703          	lh	a4,74(s1)
    80004da0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80004da4:	44f8                	lw	a4,76(s1)
    80004da6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80004da8:	03400613          	li	a2,52
    80004dac:	05048593          	add	a1,s1,80
    80004db0:	00c78513          	add	a0,a5,12
    80004db4:	ffffc097          	auipc	ra,0xffffc
    80004db8:	758080e7          	jalr	1880(ra) # 8000150c <memmove>
  log_write(bp);
    80004dbc:	854a                	mv	a0,s2
    80004dbe:	00001097          	auipc	ra,0x1
    80004dc2:	c02080e7          	jalr	-1022(ra) # 800059c0 <log_write>
  brelse(bp);
    80004dc6:	854a                	mv	a0,s2
    80004dc8:	00000097          	auipc	ra,0x0
    80004dcc:	94e080e7          	jalr	-1714(ra) # 80004716 <brelse>
}
    80004dd0:	60e2                	ld	ra,24(sp)
    80004dd2:	6442                	ld	s0,16(sp)
    80004dd4:	64a2                	ld	s1,8(sp)
    80004dd6:	6902                	ld	s2,0(sp)
    80004dd8:	6105                	add	sp,sp,32
    80004dda:	8082                	ret

0000000080004ddc <idup>:
{
    80004ddc:	1101                	add	sp,sp,-32
    80004dde:	ec06                	sd	ra,24(sp)
    80004de0:	e822                	sd	s0,16(sp)
    80004de2:	e426                	sd	s1,8(sp)
    80004de4:	1000                	add	s0,sp,32
    80004de6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004de8:	0002d517          	auipc	a0,0x2d
    80004dec:	a0050513          	add	a0,a0,-1536 # 800317e8 <itable>
    80004df0:	ffffc097          	auipc	ra,0xffffc
    80004df4:	5c4080e7          	jalr	1476(ra) # 800013b4 <acquire>
  ip->ref++;
    80004df8:	449c                	lw	a5,8(s1)
    80004dfa:	2785                	addw	a5,a5,1
    80004dfc:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80004dfe:	0002d517          	auipc	a0,0x2d
    80004e02:	9ea50513          	add	a0,a0,-1558 # 800317e8 <itable>
    80004e06:	ffffc097          	auipc	ra,0xffffc
    80004e0a:	662080e7          	jalr	1634(ra) # 80001468 <release>
}
    80004e0e:	8526                	mv	a0,s1
    80004e10:	60e2                	ld	ra,24(sp)
    80004e12:	6442                	ld	s0,16(sp)
    80004e14:	64a2                	ld	s1,8(sp)
    80004e16:	6105                	add	sp,sp,32
    80004e18:	8082                	ret

0000000080004e1a <ilock>:
{
    80004e1a:	1101                	add	sp,sp,-32
    80004e1c:	ec06                	sd	ra,24(sp)
    80004e1e:	e822                	sd	s0,16(sp)
    80004e20:	e426                	sd	s1,8(sp)
    80004e22:	1000                	add	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80004e24:	c10d                	beqz	a0,80004e46 <ilock+0x2c>
    80004e26:	84aa                	mv	s1,a0
    80004e28:	451c                	lw	a5,8(a0)
    80004e2a:	00f05e63          	blez	a5,80004e46 <ilock+0x2c>
  acquiresleep(&ip->lock);
    80004e2e:	0541                	add	a0,a0,16
    80004e30:	00001097          	auipc	ra,0x1
    80004e34:	cae080e7          	jalr	-850(ra) # 80005ade <acquiresleep>
  if(ip->valid == 0){
    80004e38:	40bc                	lw	a5,64(s1)
    80004e3a:	cf99                	beqz	a5,80004e58 <ilock+0x3e>
}
    80004e3c:	60e2                	ld	ra,24(sp)
    80004e3e:	6442                	ld	s0,16(sp)
    80004e40:	64a2                	ld	s1,8(sp)
    80004e42:	6105                	add	sp,sp,32
    80004e44:	8082                	ret
    80004e46:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80004e48:	00005517          	auipc	a0,0x5
    80004e4c:	8f850513          	add	a0,a0,-1800 # 80009740 <etext+0x740>
    80004e50:	ffffb097          	auipc	ra,0xffffb
    80004e54:	746080e7          	jalr	1862(ra) # 80000596 <panic>
    80004e58:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80004e5a:	40dc                	lw	a5,4(s1)
    80004e5c:	0047d79b          	srlw	a5,a5,0x4
    80004e60:	0002d597          	auipc	a1,0x2d
    80004e64:	9805a583          	lw	a1,-1664(a1) # 800317e0 <sb+0x18>
    80004e68:	9dbd                	addw	a1,a1,a5
    80004e6a:	4088                	lw	a0,0(s1)
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	77a080e7          	jalr	1914(ra) # 800045e6 <bread>
    80004e74:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80004e76:	05850593          	add	a1,a0,88
    80004e7a:	40dc                	lw	a5,4(s1)
    80004e7c:	8bbd                	and	a5,a5,15
    80004e7e:	079a                	sll	a5,a5,0x6
    80004e80:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80004e82:	00059783          	lh	a5,0(a1)
    80004e86:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80004e8a:	00259783          	lh	a5,2(a1)
    80004e8e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80004e92:	00459783          	lh	a5,4(a1)
    80004e96:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80004e9a:	00659783          	lh	a5,6(a1)
    80004e9e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80004ea2:	459c                	lw	a5,8(a1)
    80004ea4:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80004ea6:	03400613          	li	a2,52
    80004eaa:	05b1                	add	a1,a1,12
    80004eac:	05048513          	add	a0,s1,80
    80004eb0:	ffffc097          	auipc	ra,0xffffc
    80004eb4:	65c080e7          	jalr	1628(ra) # 8000150c <memmove>
    brelse(bp);
    80004eb8:	854a                	mv	a0,s2
    80004eba:	00000097          	auipc	ra,0x0
    80004ebe:	85c080e7          	jalr	-1956(ra) # 80004716 <brelse>
    ip->valid = 1;
    80004ec2:	4785                	li	a5,1
    80004ec4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80004ec6:	04449783          	lh	a5,68(s1)
    80004eca:	c399                	beqz	a5,80004ed0 <ilock+0xb6>
    80004ecc:	6902                	ld	s2,0(sp)
    80004ece:	b7bd                	j	80004e3c <ilock+0x22>
      panic("ilock: no type");
    80004ed0:	00005517          	auipc	a0,0x5
    80004ed4:	87850513          	add	a0,a0,-1928 # 80009748 <etext+0x748>
    80004ed8:	ffffb097          	auipc	ra,0xffffb
    80004edc:	6be080e7          	jalr	1726(ra) # 80000596 <panic>

0000000080004ee0 <iunlock>:
{
    80004ee0:	1101                	add	sp,sp,-32
    80004ee2:	ec06                	sd	ra,24(sp)
    80004ee4:	e822                	sd	s0,16(sp)
    80004ee6:	e426                	sd	s1,8(sp)
    80004ee8:	e04a                	sd	s2,0(sp)
    80004eea:	1000                	add	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80004eec:	c905                	beqz	a0,80004f1c <iunlock+0x3c>
    80004eee:	84aa                	mv	s1,a0
    80004ef0:	01050913          	add	s2,a0,16
    80004ef4:	854a                	mv	a0,s2
    80004ef6:	00001097          	auipc	ra,0x1
    80004efa:	c82080e7          	jalr	-894(ra) # 80005b78 <holdingsleep>
    80004efe:	cd19                	beqz	a0,80004f1c <iunlock+0x3c>
    80004f00:	449c                	lw	a5,8(s1)
    80004f02:	00f05d63          	blez	a5,80004f1c <iunlock+0x3c>
  releasesleep(&ip->lock);
    80004f06:	854a                	mv	a0,s2
    80004f08:	00001097          	auipc	ra,0x1
    80004f0c:	c2c080e7          	jalr	-980(ra) # 80005b34 <releasesleep>
}
    80004f10:	60e2                	ld	ra,24(sp)
    80004f12:	6442                	ld	s0,16(sp)
    80004f14:	64a2                	ld	s1,8(sp)
    80004f16:	6902                	ld	s2,0(sp)
    80004f18:	6105                	add	sp,sp,32
    80004f1a:	8082                	ret
    panic("iunlock");
    80004f1c:	00005517          	auipc	a0,0x5
    80004f20:	83c50513          	add	a0,a0,-1988 # 80009758 <etext+0x758>
    80004f24:	ffffb097          	auipc	ra,0xffffb
    80004f28:	672080e7          	jalr	1650(ra) # 80000596 <panic>

0000000080004f2c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80004f2c:	7179                	add	sp,sp,-48
    80004f2e:	f406                	sd	ra,40(sp)
    80004f30:	f022                	sd	s0,32(sp)
    80004f32:	ec26                	sd	s1,24(sp)
    80004f34:	e84a                	sd	s2,16(sp)
    80004f36:	e44e                	sd	s3,8(sp)
    80004f38:	1800                	add	s0,sp,48
    80004f3a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80004f3c:	05050493          	add	s1,a0,80
    80004f40:	08050913          	add	s2,a0,128
    80004f44:	a021                	j	80004f4c <itrunc+0x20>
    80004f46:	0491                	add	s1,s1,4
    80004f48:	01248d63          	beq	s1,s2,80004f62 <itrunc+0x36>
    if(ip->addrs[i]){
    80004f4c:	408c                	lw	a1,0(s1)
    80004f4e:	dde5                	beqz	a1,80004f46 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80004f50:	0009a503          	lw	a0,0(s3)
    80004f54:	00000097          	auipc	ra,0x0
    80004f58:	8d6080e7          	jalr	-1834(ra) # 8000482a <bfree>
      ip->addrs[i] = 0;
    80004f5c:	0004a023          	sw	zero,0(s1)
    80004f60:	b7dd                	j	80004f46 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80004f62:	0809a583          	lw	a1,128(s3)
    80004f66:	ed99                	bnez	a1,80004f84 <itrunc+0x58>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80004f68:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80004f6c:	854e                	mv	a0,s3
    80004f6e:	00000097          	auipc	ra,0x0
    80004f72:	de0080e7          	jalr	-544(ra) # 80004d4e <iupdate>
}
    80004f76:	70a2                	ld	ra,40(sp)
    80004f78:	7402                	ld	s0,32(sp)
    80004f7a:	64e2                	ld	s1,24(sp)
    80004f7c:	6942                	ld	s2,16(sp)
    80004f7e:	69a2                	ld	s3,8(sp)
    80004f80:	6145                	add	sp,sp,48
    80004f82:	8082                	ret
    80004f84:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80004f86:	0009a503          	lw	a0,0(s3)
    80004f8a:	fffff097          	auipc	ra,0xfffff
    80004f8e:	65c080e7          	jalr	1628(ra) # 800045e6 <bread>
    80004f92:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80004f94:	05850493          	add	s1,a0,88
    80004f98:	45850913          	add	s2,a0,1112
    80004f9c:	a021                	j	80004fa4 <itrunc+0x78>
    80004f9e:	0491                	add	s1,s1,4
    80004fa0:	01248b63          	beq	s1,s2,80004fb6 <itrunc+0x8a>
      if(a[j])
    80004fa4:	408c                	lw	a1,0(s1)
    80004fa6:	dde5                	beqz	a1,80004f9e <itrunc+0x72>
        bfree(ip->dev, a[j]);
    80004fa8:	0009a503          	lw	a0,0(s3)
    80004fac:	00000097          	auipc	ra,0x0
    80004fb0:	87e080e7          	jalr	-1922(ra) # 8000482a <bfree>
    80004fb4:	b7ed                	j	80004f9e <itrunc+0x72>
    brelse(bp);
    80004fb6:	8552                	mv	a0,s4
    80004fb8:	fffff097          	auipc	ra,0xfffff
    80004fbc:	75e080e7          	jalr	1886(ra) # 80004716 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80004fc0:	0809a583          	lw	a1,128(s3)
    80004fc4:	0009a503          	lw	a0,0(s3)
    80004fc8:	00000097          	auipc	ra,0x0
    80004fcc:	862080e7          	jalr	-1950(ra) # 8000482a <bfree>
    ip->addrs[NDIRECT] = 0;
    80004fd0:	0809a023          	sw	zero,128(s3)
    80004fd4:	6a02                	ld	s4,0(sp)
    80004fd6:	bf49                	j	80004f68 <itrunc+0x3c>

0000000080004fd8 <iput>:
{
    80004fd8:	1101                	add	sp,sp,-32
    80004fda:	ec06                	sd	ra,24(sp)
    80004fdc:	e822                	sd	s0,16(sp)
    80004fde:	e426                	sd	s1,8(sp)
    80004fe0:	1000                	add	s0,sp,32
    80004fe2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80004fe4:	0002d517          	auipc	a0,0x2d
    80004fe8:	80450513          	add	a0,a0,-2044 # 800317e8 <itable>
    80004fec:	ffffc097          	auipc	ra,0xffffc
    80004ff0:	3c8080e7          	jalr	968(ra) # 800013b4 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80004ff4:	4498                	lw	a4,8(s1)
    80004ff6:	4785                	li	a5,1
    80004ff8:	02f70263          	beq	a4,a5,8000501c <iput+0x44>
  ip->ref--;
    80004ffc:	449c                	lw	a5,8(s1)
    80004ffe:	37fd                	addw	a5,a5,-1
    80005000:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80005002:	0002c517          	auipc	a0,0x2c
    80005006:	7e650513          	add	a0,a0,2022 # 800317e8 <itable>
    8000500a:	ffffc097          	auipc	ra,0xffffc
    8000500e:	45e080e7          	jalr	1118(ra) # 80001468 <release>
}
    80005012:	60e2                	ld	ra,24(sp)
    80005014:	6442                	ld	s0,16(sp)
    80005016:	64a2                	ld	s1,8(sp)
    80005018:	6105                	add	sp,sp,32
    8000501a:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000501c:	40bc                	lw	a5,64(s1)
    8000501e:	dff9                	beqz	a5,80004ffc <iput+0x24>
    80005020:	04a49783          	lh	a5,74(s1)
    80005024:	ffe1                	bnez	a5,80004ffc <iput+0x24>
    80005026:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80005028:	01048913          	add	s2,s1,16
    8000502c:	854a                	mv	a0,s2
    8000502e:	00001097          	auipc	ra,0x1
    80005032:	ab0080e7          	jalr	-1360(ra) # 80005ade <acquiresleep>
    release(&itable.lock);
    80005036:	0002c517          	auipc	a0,0x2c
    8000503a:	7b250513          	add	a0,a0,1970 # 800317e8 <itable>
    8000503e:	ffffc097          	auipc	ra,0xffffc
    80005042:	42a080e7          	jalr	1066(ra) # 80001468 <release>
    itrunc(ip);
    80005046:	8526                	mv	a0,s1
    80005048:	00000097          	auipc	ra,0x0
    8000504c:	ee4080e7          	jalr	-284(ra) # 80004f2c <itrunc>
    ip->type = 0;
    80005050:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80005054:	8526                	mv	a0,s1
    80005056:	00000097          	auipc	ra,0x0
    8000505a:	cf8080e7          	jalr	-776(ra) # 80004d4e <iupdate>
    ip->valid = 0;
    8000505e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80005062:	854a                	mv	a0,s2
    80005064:	00001097          	auipc	ra,0x1
    80005068:	ad0080e7          	jalr	-1328(ra) # 80005b34 <releasesleep>
    acquire(&itable.lock);
    8000506c:	0002c517          	auipc	a0,0x2c
    80005070:	77c50513          	add	a0,a0,1916 # 800317e8 <itable>
    80005074:	ffffc097          	auipc	ra,0xffffc
    80005078:	340080e7          	jalr	832(ra) # 800013b4 <acquire>
    8000507c:	6902                	ld	s2,0(sp)
    8000507e:	bfbd                	j	80004ffc <iput+0x24>

0000000080005080 <iunlockput>:
{
    80005080:	1101                	add	sp,sp,-32
    80005082:	ec06                	sd	ra,24(sp)
    80005084:	e822                	sd	s0,16(sp)
    80005086:	e426                	sd	s1,8(sp)
    80005088:	1000                	add	s0,sp,32
    8000508a:	84aa                	mv	s1,a0
  iunlock(ip);
    8000508c:	00000097          	auipc	ra,0x0
    80005090:	e54080e7          	jalr	-428(ra) # 80004ee0 <iunlock>
  iput(ip);
    80005094:	8526                	mv	a0,s1
    80005096:	00000097          	auipc	ra,0x0
    8000509a:	f42080e7          	jalr	-190(ra) # 80004fd8 <iput>
}
    8000509e:	60e2                	ld	ra,24(sp)
    800050a0:	6442                	ld	s0,16(sp)
    800050a2:	64a2                	ld	s1,8(sp)
    800050a4:	6105                	add	sp,sp,32
    800050a6:	8082                	ret

00000000800050a8 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800050a8:	1141                	add	sp,sp,-16
    800050aa:	e422                	sd	s0,8(sp)
    800050ac:	0800                	add	s0,sp,16
  st->dev = ip->dev;
    800050ae:	411c                	lw	a5,0(a0)
    800050b0:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800050b2:	415c                	lw	a5,4(a0)
    800050b4:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800050b6:	04451783          	lh	a5,68(a0)
    800050ba:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800050be:	04a51783          	lh	a5,74(a0)
    800050c2:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800050c6:	04c56783          	lwu	a5,76(a0)
    800050ca:	e99c                	sd	a5,16(a1)
}
    800050cc:	6422                	ld	s0,8(sp)
    800050ce:	0141                	add	sp,sp,16
    800050d0:	8082                	ret

00000000800050d2 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800050d2:	457c                	lw	a5,76(a0)
    800050d4:	10d7e563          	bltu	a5,a3,800051de <readi+0x10c>
{
    800050d8:	7159                	add	sp,sp,-112
    800050da:	f486                	sd	ra,104(sp)
    800050dc:	f0a2                	sd	s0,96(sp)
    800050de:	eca6                	sd	s1,88(sp)
    800050e0:	e0d2                	sd	s4,64(sp)
    800050e2:	fc56                	sd	s5,56(sp)
    800050e4:	f85a                	sd	s6,48(sp)
    800050e6:	f45e                	sd	s7,40(sp)
    800050e8:	1880                	add	s0,sp,112
    800050ea:	8b2a                	mv	s6,a0
    800050ec:	8bae                	mv	s7,a1
    800050ee:	8a32                	mv	s4,a2
    800050f0:	84b6                	mv	s1,a3
    800050f2:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    800050f4:	9f35                	addw	a4,a4,a3
    return 0;
    800050f6:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    800050f8:	0cd76a63          	bltu	a4,a3,800051cc <readi+0xfa>
    800050fc:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    800050fe:	00e7f463          	bgeu	a5,a4,80005106 <readi+0x34>
    n = ip->size - off;
    80005102:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005106:	0a0a8963          	beqz	s5,800051b8 <readi+0xe6>
    8000510a:	e8ca                	sd	s2,80(sp)
    8000510c:	f062                	sd	s8,32(sp)
    8000510e:	ec66                	sd	s9,24(sp)
    80005110:	e86a                	sd	s10,16(sp)
    80005112:	e46e                	sd	s11,8(sp)
    80005114:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80005116:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    8000511a:	5c7d                	li	s8,-1
    8000511c:	a82d                	j	80005156 <readi+0x84>
    8000511e:	020d1d93          	sll	s11,s10,0x20
    80005122:	020ddd93          	srl	s11,s11,0x20
    80005126:	05890613          	add	a2,s2,88
    8000512a:	86ee                	mv	a3,s11
    8000512c:	963a                	add	a2,a2,a4
    8000512e:	85d2                	mv	a1,s4
    80005130:	855e                	mv	a0,s7
    80005132:	ffffe097          	auipc	ra,0xffffe
    80005136:	2bc080e7          	jalr	700(ra) # 800033ee <either_copyout>
    8000513a:	05850d63          	beq	a0,s8,80005194 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    8000513e:	854a                	mv	a0,s2
    80005140:	fffff097          	auipc	ra,0xfffff
    80005144:	5d6080e7          	jalr	1494(ra) # 80004716 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80005148:	013d09bb          	addw	s3,s10,s3
    8000514c:	009d04bb          	addw	s1,s10,s1
    80005150:	9a6e                	add	s4,s4,s11
    80005152:	0559fd63          	bgeu	s3,s5,800051ac <readi+0xda>
    uint addr = bmap(ip, off/BSIZE);
    80005156:	00a4d59b          	srlw	a1,s1,0xa
    8000515a:	855a                	mv	a0,s6
    8000515c:	00000097          	auipc	ra,0x0
    80005160:	88e080e7          	jalr	-1906(ra) # 800049ea <bmap>
    80005164:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80005168:	c9b1                	beqz	a1,800051bc <readi+0xea>
    bp = bread(ip->dev, addr);
    8000516a:	000b2503          	lw	a0,0(s6)
    8000516e:	fffff097          	auipc	ra,0xfffff
    80005172:	478080e7          	jalr	1144(ra) # 800045e6 <bread>
    80005176:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80005178:	3ff4f713          	and	a4,s1,1023
    8000517c:	40ec87bb          	subw	a5,s9,a4
    80005180:	413a86bb          	subw	a3,s5,s3
    80005184:	8d3e                	mv	s10,a5
    80005186:	2781                	sext.w	a5,a5
    80005188:	0006861b          	sext.w	a2,a3
    8000518c:	f8f679e3          	bgeu	a2,a5,8000511e <readi+0x4c>
    80005190:	8d36                	mv	s10,a3
    80005192:	b771                	j	8000511e <readi+0x4c>
      brelse(bp);
    80005194:	854a                	mv	a0,s2
    80005196:	fffff097          	auipc	ra,0xfffff
    8000519a:	580080e7          	jalr	1408(ra) # 80004716 <brelse>
      tot = -1;
    8000519e:	59fd                	li	s3,-1
      break;
    800051a0:	6946                	ld	s2,80(sp)
    800051a2:	7c02                	ld	s8,32(sp)
    800051a4:	6ce2                	ld	s9,24(sp)
    800051a6:	6d42                	ld	s10,16(sp)
    800051a8:	6da2                	ld	s11,8(sp)
    800051aa:	a831                	j	800051c6 <readi+0xf4>
    800051ac:	6946                	ld	s2,80(sp)
    800051ae:	7c02                	ld	s8,32(sp)
    800051b0:	6ce2                	ld	s9,24(sp)
    800051b2:	6d42                	ld	s10,16(sp)
    800051b4:	6da2                	ld	s11,8(sp)
    800051b6:	a801                	j	800051c6 <readi+0xf4>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800051b8:	89d6                	mv	s3,s5
    800051ba:	a031                	j	800051c6 <readi+0xf4>
    800051bc:	6946                	ld	s2,80(sp)
    800051be:	7c02                	ld	s8,32(sp)
    800051c0:	6ce2                	ld	s9,24(sp)
    800051c2:	6d42                	ld	s10,16(sp)
    800051c4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800051c6:	0009851b          	sext.w	a0,s3
    800051ca:	69a6                	ld	s3,72(sp)
}
    800051cc:	70a6                	ld	ra,104(sp)
    800051ce:	7406                	ld	s0,96(sp)
    800051d0:	64e6                	ld	s1,88(sp)
    800051d2:	6a06                	ld	s4,64(sp)
    800051d4:	7ae2                	ld	s5,56(sp)
    800051d6:	7b42                	ld	s6,48(sp)
    800051d8:	7ba2                	ld	s7,40(sp)
    800051da:	6165                	add	sp,sp,112
    800051dc:	8082                	ret
    return 0;
    800051de:	4501                	li	a0,0
}
    800051e0:	8082                	ret

00000000800051e2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800051e2:	457c                	lw	a5,76(a0)
    800051e4:	10d7ee63          	bltu	a5,a3,80005300 <writei+0x11e>
{
    800051e8:	7159                	add	sp,sp,-112
    800051ea:	f486                	sd	ra,104(sp)
    800051ec:	f0a2                	sd	s0,96(sp)
    800051ee:	e8ca                	sd	s2,80(sp)
    800051f0:	e0d2                	sd	s4,64(sp)
    800051f2:	fc56                	sd	s5,56(sp)
    800051f4:	f85a                	sd	s6,48(sp)
    800051f6:	f45e                	sd	s7,40(sp)
    800051f8:	1880                	add	s0,sp,112
    800051fa:	8aaa                	mv	s5,a0
    800051fc:	8bae                	mv	s7,a1
    800051fe:	8a32                	mv	s4,a2
    80005200:	8936                	mv	s2,a3
    80005202:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80005204:	00e687bb          	addw	a5,a3,a4
    80005208:	0ed7ee63          	bltu	a5,a3,80005304 <writei+0x122>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000520c:	00043737          	lui	a4,0x43
    80005210:	0ef76c63          	bltu	a4,a5,80005308 <writei+0x126>
    80005214:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005216:	0c0b0d63          	beqz	s6,800052f0 <writei+0x10e>
    8000521a:	eca6                	sd	s1,88(sp)
    8000521c:	f062                	sd	s8,32(sp)
    8000521e:	ec66                	sd	s9,24(sp)
    80005220:	e86a                	sd	s10,16(sp)
    80005222:	e46e                	sd	s11,8(sp)
    80005224:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80005226:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000522a:	5c7d                	li	s8,-1
    8000522c:	a091                	j	80005270 <writei+0x8e>
    8000522e:	020d1d93          	sll	s11,s10,0x20
    80005232:	020ddd93          	srl	s11,s11,0x20
    80005236:	05848513          	add	a0,s1,88
    8000523a:	86ee                	mv	a3,s11
    8000523c:	8652                	mv	a2,s4
    8000523e:	85de                	mv	a1,s7
    80005240:	953a                	add	a0,a0,a4
    80005242:	ffffe097          	auipc	ra,0xffffe
    80005246:	202080e7          	jalr	514(ra) # 80003444 <either_copyin>
    8000524a:	07850263          	beq	a0,s8,800052ae <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000524e:	8526                	mv	a0,s1
    80005250:	00000097          	auipc	ra,0x0
    80005254:	770080e7          	jalr	1904(ra) # 800059c0 <log_write>
    brelse(bp);
    80005258:	8526                	mv	a0,s1
    8000525a:	fffff097          	auipc	ra,0xfffff
    8000525e:	4bc080e7          	jalr	1212(ra) # 80004716 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80005262:	013d09bb          	addw	s3,s10,s3
    80005266:	012d093b          	addw	s2,s10,s2
    8000526a:	9a6e                	add	s4,s4,s11
    8000526c:	0569f663          	bgeu	s3,s6,800052b8 <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80005270:	00a9559b          	srlw	a1,s2,0xa
    80005274:	8556                	mv	a0,s5
    80005276:	fffff097          	auipc	ra,0xfffff
    8000527a:	774080e7          	jalr	1908(ra) # 800049ea <bmap>
    8000527e:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80005282:	c99d                	beqz	a1,800052b8 <writei+0xd6>
    bp = bread(ip->dev, addr);
    80005284:	000aa503          	lw	a0,0(s5)
    80005288:	fffff097          	auipc	ra,0xfffff
    8000528c:	35e080e7          	jalr	862(ra) # 800045e6 <bread>
    80005290:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80005292:	3ff97713          	and	a4,s2,1023
    80005296:	40ec87bb          	subw	a5,s9,a4
    8000529a:	413b06bb          	subw	a3,s6,s3
    8000529e:	8d3e                	mv	s10,a5
    800052a0:	2781                	sext.w	a5,a5
    800052a2:	0006861b          	sext.w	a2,a3
    800052a6:	f8f674e3          	bgeu	a2,a5,8000522e <writei+0x4c>
    800052aa:	8d36                	mv	s10,a3
    800052ac:	b749                	j	8000522e <writei+0x4c>
      brelse(bp);
    800052ae:	8526                	mv	a0,s1
    800052b0:	fffff097          	auipc	ra,0xfffff
    800052b4:	466080e7          	jalr	1126(ra) # 80004716 <brelse>
  }

  if(off > ip->size)
    800052b8:	04caa783          	lw	a5,76(s5)
    800052bc:	0327fc63          	bgeu	a5,s2,800052f4 <writei+0x112>
    ip->size = off;
    800052c0:	052aa623          	sw	s2,76(s5)
    800052c4:	64e6                	ld	s1,88(sp)
    800052c6:	7c02                	ld	s8,32(sp)
    800052c8:	6ce2                	ld	s9,24(sp)
    800052ca:	6d42                	ld	s10,16(sp)
    800052cc:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800052ce:	8556                	mv	a0,s5
    800052d0:	00000097          	auipc	ra,0x0
    800052d4:	a7e080e7          	jalr	-1410(ra) # 80004d4e <iupdate>

  return tot;
    800052d8:	0009851b          	sext.w	a0,s3
    800052dc:	69a6                	ld	s3,72(sp)
}
    800052de:	70a6                	ld	ra,104(sp)
    800052e0:	7406                	ld	s0,96(sp)
    800052e2:	6946                	ld	s2,80(sp)
    800052e4:	6a06                	ld	s4,64(sp)
    800052e6:	7ae2                	ld	s5,56(sp)
    800052e8:	7b42                	ld	s6,48(sp)
    800052ea:	7ba2                	ld	s7,40(sp)
    800052ec:	6165                	add	sp,sp,112
    800052ee:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800052f0:	89da                	mv	s3,s6
    800052f2:	bff1                	j	800052ce <writei+0xec>
    800052f4:	64e6                	ld	s1,88(sp)
    800052f6:	7c02                	ld	s8,32(sp)
    800052f8:	6ce2                	ld	s9,24(sp)
    800052fa:	6d42                	ld	s10,16(sp)
    800052fc:	6da2                	ld	s11,8(sp)
    800052fe:	bfc1                	j	800052ce <writei+0xec>
    return -1;
    80005300:	557d                	li	a0,-1
}
    80005302:	8082                	ret
    return -1;
    80005304:	557d                	li	a0,-1
    80005306:	bfe1                	j	800052de <writei+0xfc>
    return -1;
    80005308:	557d                	li	a0,-1
    8000530a:	bfd1                	j	800052de <writei+0xfc>

000000008000530c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000530c:	1141                	add	sp,sp,-16
    8000530e:	e406                	sd	ra,8(sp)
    80005310:	e022                	sd	s0,0(sp)
    80005312:	0800                	add	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80005314:	4639                	li	a2,14
    80005316:	ffffc097          	auipc	ra,0xffffc
    8000531a:	26a080e7          	jalr	618(ra) # 80001580 <strncmp>
}
    8000531e:	60a2                	ld	ra,8(sp)
    80005320:	6402                	ld	s0,0(sp)
    80005322:	0141                	add	sp,sp,16
    80005324:	8082                	ret

0000000080005326 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80005326:	7139                	add	sp,sp,-64
    80005328:	fc06                	sd	ra,56(sp)
    8000532a:	f822                	sd	s0,48(sp)
    8000532c:	f426                	sd	s1,40(sp)
    8000532e:	f04a                	sd	s2,32(sp)
    80005330:	ec4e                	sd	s3,24(sp)
    80005332:	e852                	sd	s4,16(sp)
    80005334:	0080                	add	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80005336:	04451703          	lh	a4,68(a0)
    8000533a:	4785                	li	a5,1
    8000533c:	00f71a63          	bne	a4,a5,80005350 <dirlookup+0x2a>
    80005340:	892a                	mv	s2,a0
    80005342:	89ae                	mv	s3,a1
    80005344:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80005346:	457c                	lw	a5,76(a0)
    80005348:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000534a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000534c:	e79d                	bnez	a5,8000537a <dirlookup+0x54>
    8000534e:	a8a5                	j	800053c6 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80005350:	00004517          	auipc	a0,0x4
    80005354:	41050513          	add	a0,a0,1040 # 80009760 <etext+0x760>
    80005358:	ffffb097          	auipc	ra,0xffffb
    8000535c:	23e080e7          	jalr	574(ra) # 80000596 <panic>
      panic("dirlookup read");
    80005360:	00004517          	auipc	a0,0x4
    80005364:	41850513          	add	a0,a0,1048 # 80009778 <etext+0x778>
    80005368:	ffffb097          	auipc	ra,0xffffb
    8000536c:	22e080e7          	jalr	558(ra) # 80000596 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005370:	24c1                	addw	s1,s1,16
    80005372:	04c92783          	lw	a5,76(s2)
    80005376:	04f4f763          	bgeu	s1,a5,800053c4 <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000537a:	4741                	li	a4,16
    8000537c:	86a6                	mv	a3,s1
    8000537e:	fc040613          	add	a2,s0,-64
    80005382:	4581                	li	a1,0
    80005384:	854a                	mv	a0,s2
    80005386:	00000097          	auipc	ra,0x0
    8000538a:	d4c080e7          	jalr	-692(ra) # 800050d2 <readi>
    8000538e:	47c1                	li	a5,16
    80005390:	fcf518e3          	bne	a0,a5,80005360 <dirlookup+0x3a>
    if(de.inum == 0)
    80005394:	fc045783          	lhu	a5,-64(s0)
    80005398:	dfe1                	beqz	a5,80005370 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    8000539a:	fc240593          	add	a1,s0,-62
    8000539e:	854e                	mv	a0,s3
    800053a0:	00000097          	auipc	ra,0x0
    800053a4:	f6c080e7          	jalr	-148(ra) # 8000530c <namecmp>
    800053a8:	f561                	bnez	a0,80005370 <dirlookup+0x4a>
      if(poff)
    800053aa:	000a0463          	beqz	s4,800053b2 <dirlookup+0x8c>
        *poff = off;
    800053ae:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    800053b2:	fc045583          	lhu	a1,-64(s0)
    800053b6:	00092503          	lw	a0,0(s2)
    800053ba:	fffff097          	auipc	ra,0xfffff
    800053be:	720080e7          	jalr	1824(ra) # 80004ada <iget>
    800053c2:	a011                	j	800053c6 <dirlookup+0xa0>
  return 0;
    800053c4:	4501                	li	a0,0
}
    800053c6:	70e2                	ld	ra,56(sp)
    800053c8:	7442                	ld	s0,48(sp)
    800053ca:	74a2                	ld	s1,40(sp)
    800053cc:	7902                	ld	s2,32(sp)
    800053ce:	69e2                	ld	s3,24(sp)
    800053d0:	6a42                	ld	s4,16(sp)
    800053d2:	6121                	add	sp,sp,64
    800053d4:	8082                	ret

00000000800053d6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800053d6:	711d                	add	sp,sp,-96
    800053d8:	ec86                	sd	ra,88(sp)
    800053da:	e8a2                	sd	s0,80(sp)
    800053dc:	e4a6                	sd	s1,72(sp)
    800053de:	e0ca                	sd	s2,64(sp)
    800053e0:	fc4e                	sd	s3,56(sp)
    800053e2:	f852                	sd	s4,48(sp)
    800053e4:	f456                	sd	s5,40(sp)
    800053e6:	f05a                	sd	s6,32(sp)
    800053e8:	ec5e                	sd	s7,24(sp)
    800053ea:	e862                	sd	s8,16(sp)
    800053ec:	e466                	sd	s9,8(sp)
    800053ee:	1080                	add	s0,sp,96
    800053f0:	84aa                	mv	s1,a0
    800053f2:	8b2e                	mv	s6,a1
    800053f4:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800053f6:	00054703          	lbu	a4,0(a0)
    800053fa:	02f00793          	li	a5,47
    800053fe:	02f70263          	beq	a4,a5,80005422 <namex+0x4c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80005402:	ffffd097          	auipc	ra,0xffffd
    80005406:	f82080e7          	jalr	-126(ra) # 80002384 <myproc>
    8000540a:	1b053503          	ld	a0,432(a0)
    8000540e:	00000097          	auipc	ra,0x0
    80005412:	9ce080e7          	jalr	-1586(ra) # 80004ddc <idup>
    80005416:	8a2a                	mv	s4,a0
  while(*path == '/')
    80005418:	02f00913          	li	s2,47
  if(len >= DIRSIZ)
    8000541c:	4c35                	li	s8,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000541e:	4b85                	li	s7,1
    80005420:	a875                	j	800054dc <namex+0x106>
    ip = iget(ROOTDEV, ROOTINO);
    80005422:	4585                	li	a1,1
    80005424:	4505                	li	a0,1
    80005426:	fffff097          	auipc	ra,0xfffff
    8000542a:	6b4080e7          	jalr	1716(ra) # 80004ada <iget>
    8000542e:	8a2a                	mv	s4,a0
    80005430:	b7e5                	j	80005418 <namex+0x42>
      iunlockput(ip);
    80005432:	8552                	mv	a0,s4
    80005434:	00000097          	auipc	ra,0x0
    80005438:	c4c080e7          	jalr	-948(ra) # 80005080 <iunlockput>
      return 0;
    8000543c:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000543e:	8552                	mv	a0,s4
    80005440:	60e6                	ld	ra,88(sp)
    80005442:	6446                	ld	s0,80(sp)
    80005444:	64a6                	ld	s1,72(sp)
    80005446:	6906                	ld	s2,64(sp)
    80005448:	79e2                	ld	s3,56(sp)
    8000544a:	7a42                	ld	s4,48(sp)
    8000544c:	7aa2                	ld	s5,40(sp)
    8000544e:	7b02                	ld	s6,32(sp)
    80005450:	6be2                	ld	s7,24(sp)
    80005452:	6c42                	ld	s8,16(sp)
    80005454:	6ca2                	ld	s9,8(sp)
    80005456:	6125                	add	sp,sp,96
    80005458:	8082                	ret
      iunlock(ip);
    8000545a:	8552                	mv	a0,s4
    8000545c:	00000097          	auipc	ra,0x0
    80005460:	a84080e7          	jalr	-1404(ra) # 80004ee0 <iunlock>
      return ip;
    80005464:	bfe9                	j	8000543e <namex+0x68>
      iunlockput(ip);
    80005466:	8552                	mv	a0,s4
    80005468:	00000097          	auipc	ra,0x0
    8000546c:	c18080e7          	jalr	-1000(ra) # 80005080 <iunlockput>
      return 0;
    80005470:	8a4e                	mv	s4,s3
    80005472:	b7f1                	j	8000543e <namex+0x68>
  len = path - s;
    80005474:	40998633          	sub	a2,s3,s1
    80005478:	00060c9b          	sext.w	s9,a2
  if(len >= DIRSIZ)
    8000547c:	099c5863          	bge	s8,s9,8000550c <namex+0x136>
    memmove(name, s, DIRSIZ);
    80005480:	4639                	li	a2,14
    80005482:	85a6                	mv	a1,s1
    80005484:	8556                	mv	a0,s5
    80005486:	ffffc097          	auipc	ra,0xffffc
    8000548a:	086080e7          	jalr	134(ra) # 8000150c <memmove>
    8000548e:	84ce                	mv	s1,s3
  while(*path == '/')
    80005490:	0004c783          	lbu	a5,0(s1)
    80005494:	01279763          	bne	a5,s2,800054a2 <namex+0xcc>
    path++;
    80005498:	0485                	add	s1,s1,1
  while(*path == '/')
    8000549a:	0004c783          	lbu	a5,0(s1)
    8000549e:	ff278de3          	beq	a5,s2,80005498 <namex+0xc2>
    ilock(ip);
    800054a2:	8552                	mv	a0,s4
    800054a4:	00000097          	auipc	ra,0x0
    800054a8:	976080e7          	jalr	-1674(ra) # 80004e1a <ilock>
    if(ip->type != T_DIR){
    800054ac:	044a1783          	lh	a5,68(s4)
    800054b0:	f97791e3          	bne	a5,s7,80005432 <namex+0x5c>
    if(nameiparent && *path == '\0'){
    800054b4:	000b0563          	beqz	s6,800054be <namex+0xe8>
    800054b8:	0004c783          	lbu	a5,0(s1)
    800054bc:	dfd9                	beqz	a5,8000545a <namex+0x84>
    if((next = dirlookup(ip, name, 0)) == 0){
    800054be:	4601                	li	a2,0
    800054c0:	85d6                	mv	a1,s5
    800054c2:	8552                	mv	a0,s4
    800054c4:	00000097          	auipc	ra,0x0
    800054c8:	e62080e7          	jalr	-414(ra) # 80005326 <dirlookup>
    800054cc:	89aa                	mv	s3,a0
    800054ce:	dd41                	beqz	a0,80005466 <namex+0x90>
    iunlockput(ip);
    800054d0:	8552                	mv	a0,s4
    800054d2:	00000097          	auipc	ra,0x0
    800054d6:	bae080e7          	jalr	-1106(ra) # 80005080 <iunlockput>
    ip = next;
    800054da:	8a4e                	mv	s4,s3
  while(*path == '/')
    800054dc:	0004c783          	lbu	a5,0(s1)
    800054e0:	01279763          	bne	a5,s2,800054ee <namex+0x118>
    path++;
    800054e4:	0485                	add	s1,s1,1
  while(*path == '/')
    800054e6:	0004c783          	lbu	a5,0(s1)
    800054ea:	ff278de3          	beq	a5,s2,800054e4 <namex+0x10e>
  if(*path == 0)
    800054ee:	cb9d                	beqz	a5,80005524 <namex+0x14e>
  while(*path != '/' && *path != 0)
    800054f0:	0004c783          	lbu	a5,0(s1)
    800054f4:	89a6                	mv	s3,s1
  len = path - s;
    800054f6:	4c81                	li	s9,0
    800054f8:	4601                	li	a2,0
  while(*path != '/' && *path != 0)
    800054fa:	01278963          	beq	a5,s2,8000550c <namex+0x136>
    800054fe:	dbbd                	beqz	a5,80005474 <namex+0x9e>
    path++;
    80005500:	0985                	add	s3,s3,1
  while(*path != '/' && *path != 0)
    80005502:	0009c783          	lbu	a5,0(s3)
    80005506:	ff279ce3          	bne	a5,s2,800054fe <namex+0x128>
    8000550a:	b7ad                	j	80005474 <namex+0x9e>
    memmove(name, s, len);
    8000550c:	2601                	sext.w	a2,a2
    8000550e:	85a6                	mv	a1,s1
    80005510:	8556                	mv	a0,s5
    80005512:	ffffc097          	auipc	ra,0xffffc
    80005516:	ffa080e7          	jalr	-6(ra) # 8000150c <memmove>
    name[len] = 0;
    8000551a:	9cd6                	add	s9,s9,s5
    8000551c:	000c8023          	sb	zero,0(s9) # 2000 <_entry-0x7fffe000>
    80005520:	84ce                	mv	s1,s3
    80005522:	b7bd                	j	80005490 <namex+0xba>
  if(nameiparent){
    80005524:	f00b0de3          	beqz	s6,8000543e <namex+0x68>
    iput(ip);
    80005528:	8552                	mv	a0,s4
    8000552a:	00000097          	auipc	ra,0x0
    8000552e:	aae080e7          	jalr	-1362(ra) # 80004fd8 <iput>
    return 0;
    80005532:	4a01                	li	s4,0
    80005534:	b729                	j	8000543e <namex+0x68>

0000000080005536 <dirlink>:
{
    80005536:	7139                	add	sp,sp,-64
    80005538:	fc06                	sd	ra,56(sp)
    8000553a:	f822                	sd	s0,48(sp)
    8000553c:	f04a                	sd	s2,32(sp)
    8000553e:	ec4e                	sd	s3,24(sp)
    80005540:	e852                	sd	s4,16(sp)
    80005542:	0080                	add	s0,sp,64
    80005544:	892a                	mv	s2,a0
    80005546:	8a2e                	mv	s4,a1
    80005548:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000554a:	4601                	li	a2,0
    8000554c:	00000097          	auipc	ra,0x0
    80005550:	dda080e7          	jalr	-550(ra) # 80005326 <dirlookup>
    80005554:	ed25                	bnez	a0,800055cc <dirlink+0x96>
    80005556:	f426                	sd	s1,40(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005558:	04c92483          	lw	s1,76(s2)
    8000555c:	c49d                	beqz	s1,8000558a <dirlink+0x54>
    8000555e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80005560:	4741                	li	a4,16
    80005562:	86a6                	mv	a3,s1
    80005564:	fc040613          	add	a2,s0,-64
    80005568:	4581                	li	a1,0
    8000556a:	854a                	mv	a0,s2
    8000556c:	00000097          	auipc	ra,0x0
    80005570:	b66080e7          	jalr	-1178(ra) # 800050d2 <readi>
    80005574:	47c1                	li	a5,16
    80005576:	06f51163          	bne	a0,a5,800055d8 <dirlink+0xa2>
    if(de.inum == 0)
    8000557a:	fc045783          	lhu	a5,-64(s0)
    8000557e:	c791                	beqz	a5,8000558a <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80005580:	24c1                	addw	s1,s1,16
    80005582:	04c92783          	lw	a5,76(s2)
    80005586:	fcf4ede3          	bltu	s1,a5,80005560 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    8000558a:	4639                	li	a2,14
    8000558c:	85d2                	mv	a1,s4
    8000558e:	fc240513          	add	a0,s0,-62
    80005592:	ffffc097          	auipc	ra,0xffffc
    80005596:	024080e7          	jalr	36(ra) # 800015b6 <strncpy>
  de.inum = inum;
    8000559a:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000559e:	4741                	li	a4,16
    800055a0:	86a6                	mv	a3,s1
    800055a2:	fc040613          	add	a2,s0,-64
    800055a6:	4581                	li	a1,0
    800055a8:	854a                	mv	a0,s2
    800055aa:	00000097          	auipc	ra,0x0
    800055ae:	c38080e7          	jalr	-968(ra) # 800051e2 <writei>
    800055b2:	1541                	add	a0,a0,-16
    800055b4:	00a03533          	snez	a0,a0
    800055b8:	40a00533          	neg	a0,a0
    800055bc:	74a2                	ld	s1,40(sp)
}
    800055be:	70e2                	ld	ra,56(sp)
    800055c0:	7442                	ld	s0,48(sp)
    800055c2:	7902                	ld	s2,32(sp)
    800055c4:	69e2                	ld	s3,24(sp)
    800055c6:	6a42                	ld	s4,16(sp)
    800055c8:	6121                	add	sp,sp,64
    800055ca:	8082                	ret
    iput(ip);
    800055cc:	00000097          	auipc	ra,0x0
    800055d0:	a0c080e7          	jalr	-1524(ra) # 80004fd8 <iput>
    return -1;
    800055d4:	557d                	li	a0,-1
    800055d6:	b7e5                	j	800055be <dirlink+0x88>
      panic("dirlink read");
    800055d8:	00004517          	auipc	a0,0x4
    800055dc:	1b050513          	add	a0,a0,432 # 80009788 <etext+0x788>
    800055e0:	ffffb097          	auipc	ra,0xffffb
    800055e4:	fb6080e7          	jalr	-74(ra) # 80000596 <panic>

00000000800055e8 <namei>:

struct inode*
namei(char *path)
{
    800055e8:	1101                	add	sp,sp,-32
    800055ea:	ec06                	sd	ra,24(sp)
    800055ec:	e822                	sd	s0,16(sp)
    800055ee:	1000                	add	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800055f0:	fe040613          	add	a2,s0,-32
    800055f4:	4581                	li	a1,0
    800055f6:	00000097          	auipc	ra,0x0
    800055fa:	de0080e7          	jalr	-544(ra) # 800053d6 <namex>
}
    800055fe:	60e2                	ld	ra,24(sp)
    80005600:	6442                	ld	s0,16(sp)
    80005602:	6105                	add	sp,sp,32
    80005604:	8082                	ret

0000000080005606 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80005606:	1141                	add	sp,sp,-16
    80005608:	e406                	sd	ra,8(sp)
    8000560a:	e022                	sd	s0,0(sp)
    8000560c:	0800                	add	s0,sp,16
    8000560e:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80005610:	4585                	li	a1,1
    80005612:	00000097          	auipc	ra,0x0
    80005616:	dc4080e7          	jalr	-572(ra) # 800053d6 <namex>
}
    8000561a:	60a2                	ld	ra,8(sp)
    8000561c:	6402                	ld	s0,0(sp)
    8000561e:	0141                	add	sp,sp,16
    80005620:	8082                	ret

0000000080005622 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80005622:	1101                	add	sp,sp,-32
    80005624:	ec06                	sd	ra,24(sp)
    80005626:	e822                	sd	s0,16(sp)
    80005628:	e426                	sd	s1,8(sp)
    8000562a:	e04a                	sd	s2,0(sp)
    8000562c:	1000                	add	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000562e:	0002e917          	auipc	s2,0x2e
    80005632:	c6290913          	add	s2,s2,-926 # 80033290 <log>
    80005636:	01892583          	lw	a1,24(s2)
    8000563a:	02892503          	lw	a0,40(s2)
    8000563e:	fffff097          	auipc	ra,0xfffff
    80005642:	fa8080e7          	jalr	-88(ra) # 800045e6 <bread>
    80005646:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80005648:	02c92603          	lw	a2,44(s2)
    8000564c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000564e:	00c05f63          	blez	a2,8000566c <write_head+0x4a>
    80005652:	0002e717          	auipc	a4,0x2e
    80005656:	c6e70713          	add	a4,a4,-914 # 800332c0 <log+0x30>
    8000565a:	87aa                	mv	a5,a0
    8000565c:	060a                	sll	a2,a2,0x2
    8000565e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80005660:	4314                	lw	a3,0(a4)
    80005662:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80005664:	0711                	add	a4,a4,4
    80005666:	0791                	add	a5,a5,4
    80005668:	fec79ce3          	bne	a5,a2,80005660 <write_head+0x3e>
  }
  bwrite(buf);
    8000566c:	8526                	mv	a0,s1
    8000566e:	fffff097          	auipc	ra,0xfffff
    80005672:	06a080e7          	jalr	106(ra) # 800046d8 <bwrite>
  brelse(buf);
    80005676:	8526                	mv	a0,s1
    80005678:	fffff097          	auipc	ra,0xfffff
    8000567c:	09e080e7          	jalr	158(ra) # 80004716 <brelse>
}
    80005680:	60e2                	ld	ra,24(sp)
    80005682:	6442                	ld	s0,16(sp)
    80005684:	64a2                	ld	s1,8(sp)
    80005686:	6902                	ld	s2,0(sp)
    80005688:	6105                	add	sp,sp,32
    8000568a:	8082                	ret

000000008000568c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000568c:	0002e797          	auipc	a5,0x2e
    80005690:	c307a783          	lw	a5,-976(a5) # 800332bc <log+0x2c>
    80005694:	0af05d63          	blez	a5,8000574e <install_trans+0xc2>
{
    80005698:	7139                	add	sp,sp,-64
    8000569a:	fc06                	sd	ra,56(sp)
    8000569c:	f822                	sd	s0,48(sp)
    8000569e:	f426                	sd	s1,40(sp)
    800056a0:	f04a                	sd	s2,32(sp)
    800056a2:	ec4e                	sd	s3,24(sp)
    800056a4:	e852                	sd	s4,16(sp)
    800056a6:	e456                	sd	s5,8(sp)
    800056a8:	e05a                	sd	s6,0(sp)
    800056aa:	0080                	add	s0,sp,64
    800056ac:	8b2a                	mv	s6,a0
    800056ae:	0002ea97          	auipc	s5,0x2e
    800056b2:	c12a8a93          	add	s5,s5,-1006 # 800332c0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800056b6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800056b8:	0002e997          	auipc	s3,0x2e
    800056bc:	bd898993          	add	s3,s3,-1064 # 80033290 <log>
    800056c0:	a00d                	j	800056e2 <install_trans+0x56>
    brelse(lbuf);
    800056c2:	854a                	mv	a0,s2
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	052080e7          	jalr	82(ra) # 80004716 <brelse>
    brelse(dbuf);
    800056cc:	8526                	mv	a0,s1
    800056ce:	fffff097          	auipc	ra,0xfffff
    800056d2:	048080e7          	jalr	72(ra) # 80004716 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800056d6:	2a05                	addw	s4,s4,1
    800056d8:	0a91                	add	s5,s5,4
    800056da:	02c9a783          	lw	a5,44(s3)
    800056de:	04fa5e63          	bge	s4,a5,8000573a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800056e2:	0189a583          	lw	a1,24(s3)
    800056e6:	014585bb          	addw	a1,a1,s4
    800056ea:	2585                	addw	a1,a1,1
    800056ec:	0289a503          	lw	a0,40(s3)
    800056f0:	fffff097          	auipc	ra,0xfffff
    800056f4:	ef6080e7          	jalr	-266(ra) # 800045e6 <bread>
    800056f8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800056fa:	000aa583          	lw	a1,0(s5)
    800056fe:	0289a503          	lw	a0,40(s3)
    80005702:	fffff097          	auipc	ra,0xfffff
    80005706:	ee4080e7          	jalr	-284(ra) # 800045e6 <bread>
    8000570a:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000570c:	40000613          	li	a2,1024
    80005710:	05890593          	add	a1,s2,88
    80005714:	05850513          	add	a0,a0,88
    80005718:	ffffc097          	auipc	ra,0xffffc
    8000571c:	df4080e7          	jalr	-524(ra) # 8000150c <memmove>
    bwrite(dbuf);  // write dst to disk
    80005720:	8526                	mv	a0,s1
    80005722:	fffff097          	auipc	ra,0xfffff
    80005726:	fb6080e7          	jalr	-74(ra) # 800046d8 <bwrite>
    if(recovering == 0)
    8000572a:	f80b1ce3          	bnez	s6,800056c2 <install_trans+0x36>
      bunpin(dbuf);
    8000572e:	8526                	mv	a0,s1
    80005730:	fffff097          	auipc	ra,0xfffff
    80005734:	0be080e7          	jalr	190(ra) # 800047ee <bunpin>
    80005738:	b769                	j	800056c2 <install_trans+0x36>
}
    8000573a:	70e2                	ld	ra,56(sp)
    8000573c:	7442                	ld	s0,48(sp)
    8000573e:	74a2                	ld	s1,40(sp)
    80005740:	7902                	ld	s2,32(sp)
    80005742:	69e2                	ld	s3,24(sp)
    80005744:	6a42                	ld	s4,16(sp)
    80005746:	6aa2                	ld	s5,8(sp)
    80005748:	6b02                	ld	s6,0(sp)
    8000574a:	6121                	add	sp,sp,64
    8000574c:	8082                	ret
    8000574e:	8082                	ret

0000000080005750 <initlog>:
{
    80005750:	7179                	add	sp,sp,-48
    80005752:	f406                	sd	ra,40(sp)
    80005754:	f022                	sd	s0,32(sp)
    80005756:	ec26                	sd	s1,24(sp)
    80005758:	e84a                	sd	s2,16(sp)
    8000575a:	e44e                	sd	s3,8(sp)
    8000575c:	1800                	add	s0,sp,48
    8000575e:	892a                	mv	s2,a0
    80005760:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80005762:	0002e497          	auipc	s1,0x2e
    80005766:	b2e48493          	add	s1,s1,-1234 # 80033290 <log>
    8000576a:	00004597          	auipc	a1,0x4
    8000576e:	02e58593          	add	a1,a1,46 # 80009798 <etext+0x798>
    80005772:	8526                	mv	a0,s1
    80005774:	ffffc097          	auipc	ra,0xffffc
    80005778:	bb0080e7          	jalr	-1104(ra) # 80001324 <initlock>
  log.start = sb->logstart;
    8000577c:	0149a583          	lw	a1,20(s3)
    80005780:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80005782:	0109a783          	lw	a5,16(s3)
    80005786:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80005788:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000578c:	854a                	mv	a0,s2
    8000578e:	fffff097          	auipc	ra,0xfffff
    80005792:	e58080e7          	jalr	-424(ra) # 800045e6 <bread>
  log.lh.n = lh->n;
    80005796:	4d30                	lw	a2,88(a0)
    80005798:	d4d0                	sw	a2,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000579a:	00c05f63          	blez	a2,800057b8 <initlog+0x68>
    8000579e:	87aa                	mv	a5,a0
    800057a0:	0002e717          	auipc	a4,0x2e
    800057a4:	b2070713          	add	a4,a4,-1248 # 800332c0 <log+0x30>
    800057a8:	060a                	sll	a2,a2,0x2
    800057aa:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800057ac:	4ff4                	lw	a3,92(a5)
    800057ae:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800057b0:	0791                	add	a5,a5,4
    800057b2:	0711                	add	a4,a4,4
    800057b4:	fec79ce3          	bne	a5,a2,800057ac <initlog+0x5c>
  brelse(buf);
    800057b8:	fffff097          	auipc	ra,0xfffff
    800057bc:	f5e080e7          	jalr	-162(ra) # 80004716 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800057c0:	4505                	li	a0,1
    800057c2:	00000097          	auipc	ra,0x0
    800057c6:	eca080e7          	jalr	-310(ra) # 8000568c <install_trans>
  log.lh.n = 0;
    800057ca:	0002e797          	auipc	a5,0x2e
    800057ce:	ae07a923          	sw	zero,-1294(a5) # 800332bc <log+0x2c>
  write_head(); // clear the log
    800057d2:	00000097          	auipc	ra,0x0
    800057d6:	e50080e7          	jalr	-432(ra) # 80005622 <write_head>
}
    800057da:	70a2                	ld	ra,40(sp)
    800057dc:	7402                	ld	s0,32(sp)
    800057de:	64e2                	ld	s1,24(sp)
    800057e0:	6942                	ld	s2,16(sp)
    800057e2:	69a2                	ld	s3,8(sp)
    800057e4:	6145                	add	sp,sp,48
    800057e6:	8082                	ret

00000000800057e8 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800057e8:	1101                	add	sp,sp,-32
    800057ea:	ec06                	sd	ra,24(sp)
    800057ec:	e822                	sd	s0,16(sp)
    800057ee:	e426                	sd	s1,8(sp)
    800057f0:	e04a                	sd	s2,0(sp)
    800057f2:	1000                	add	s0,sp,32
  acquire(&log.lock);
    800057f4:	0002e517          	auipc	a0,0x2e
    800057f8:	a9c50513          	add	a0,a0,-1380 # 80033290 <log>
    800057fc:	ffffc097          	auipc	ra,0xffffc
    80005800:	bb8080e7          	jalr	-1096(ra) # 800013b4 <acquire>
  while(1){
    if(log.committing){
    80005804:	0002e497          	auipc	s1,0x2e
    80005808:	a8c48493          	add	s1,s1,-1396 # 80033290 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000580c:	4979                	li	s2,30
    8000580e:	a039                	j	8000581c <begin_op+0x34>
      sleep(&log, &log.lock);
    80005810:	85a6                	mv	a1,s1
    80005812:	8526                	mv	a0,s1
    80005814:	ffffd097          	auipc	ra,0xffffd
    80005818:	7d2080e7          	jalr	2002(ra) # 80002fe6 <sleep>
    if(log.committing){
    8000581c:	50dc                	lw	a5,36(s1)
    8000581e:	fbed                	bnez	a5,80005810 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80005820:	5098                	lw	a4,32(s1)
    80005822:	2705                	addw	a4,a4,1
    80005824:	0027179b          	sllw	a5,a4,0x2
    80005828:	9fb9                	addw	a5,a5,a4
    8000582a:	0017979b          	sllw	a5,a5,0x1
    8000582e:	54d4                	lw	a3,44(s1)
    80005830:	9fb5                	addw	a5,a5,a3
    80005832:	00f95963          	bge	s2,a5,80005844 <begin_op+0x5c>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80005836:	85a6                	mv	a1,s1
    80005838:	8526                	mv	a0,s1
    8000583a:	ffffd097          	auipc	ra,0xffffd
    8000583e:	7ac080e7          	jalr	1964(ra) # 80002fe6 <sleep>
    80005842:	bfe9                	j	8000581c <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80005844:	0002e517          	auipc	a0,0x2e
    80005848:	a4c50513          	add	a0,a0,-1460 # 80033290 <log>
    8000584c:	d118                	sw	a4,32(a0)
      release(&log.lock);
    8000584e:	ffffc097          	auipc	ra,0xffffc
    80005852:	c1a080e7          	jalr	-998(ra) # 80001468 <release>
      break;
    }
  }
}
    80005856:	60e2                	ld	ra,24(sp)
    80005858:	6442                	ld	s0,16(sp)
    8000585a:	64a2                	ld	s1,8(sp)
    8000585c:	6902                	ld	s2,0(sp)
    8000585e:	6105                	add	sp,sp,32
    80005860:	8082                	ret

0000000080005862 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80005862:	7139                	add	sp,sp,-64
    80005864:	fc06                	sd	ra,56(sp)
    80005866:	f822                	sd	s0,48(sp)
    80005868:	f426                	sd	s1,40(sp)
    8000586a:	f04a                	sd	s2,32(sp)
    8000586c:	0080                	add	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000586e:	0002e497          	auipc	s1,0x2e
    80005872:	a2248493          	add	s1,s1,-1502 # 80033290 <log>
    80005876:	8526                	mv	a0,s1
    80005878:	ffffc097          	auipc	ra,0xffffc
    8000587c:	b3c080e7          	jalr	-1220(ra) # 800013b4 <acquire>
  log.outstanding -= 1;
    80005880:	509c                	lw	a5,32(s1)
    80005882:	37fd                	addw	a5,a5,-1
    80005884:	0007891b          	sext.w	s2,a5
    80005888:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000588a:	50dc                	lw	a5,36(s1)
    8000588c:	e7b9                	bnez	a5,800058da <end_op+0x78>
    panic("log.committing");
  if(log.outstanding == 0){
    8000588e:	06091163          	bnez	s2,800058f0 <end_op+0x8e>
    do_commit = 1;
    log.committing = 1;
    80005892:	0002e497          	auipc	s1,0x2e
    80005896:	9fe48493          	add	s1,s1,-1538 # 80033290 <log>
    8000589a:	4785                	li	a5,1
    8000589c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000589e:	8526                	mv	a0,s1
    800058a0:	ffffc097          	auipc	ra,0xffffc
    800058a4:	bc8080e7          	jalr	-1080(ra) # 80001468 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800058a8:	54dc                	lw	a5,44(s1)
    800058aa:	06f04763          	bgtz	a5,80005918 <end_op+0xb6>
    acquire(&log.lock);
    800058ae:	0002e497          	auipc	s1,0x2e
    800058b2:	9e248493          	add	s1,s1,-1566 # 80033290 <log>
    800058b6:	8526                	mv	a0,s1
    800058b8:	ffffc097          	auipc	ra,0xffffc
    800058bc:	afc080e7          	jalr	-1284(ra) # 800013b4 <acquire>
    log.committing = 0;
    800058c0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800058c4:	8526                	mv	a0,s1
    800058c6:	ffffd097          	auipc	ra,0xffffd
    800058ca:	784080e7          	jalr	1924(ra) # 8000304a <wakeup>
    release(&log.lock);
    800058ce:	8526                	mv	a0,s1
    800058d0:	ffffc097          	auipc	ra,0xffffc
    800058d4:	b98080e7          	jalr	-1128(ra) # 80001468 <release>
}
    800058d8:	a815                	j	8000590c <end_op+0xaa>
    800058da:	ec4e                	sd	s3,24(sp)
    800058dc:	e852                	sd	s4,16(sp)
    800058de:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800058e0:	00004517          	auipc	a0,0x4
    800058e4:	ec050513          	add	a0,a0,-320 # 800097a0 <etext+0x7a0>
    800058e8:	ffffb097          	auipc	ra,0xffffb
    800058ec:	cae080e7          	jalr	-850(ra) # 80000596 <panic>
    wakeup(&log);
    800058f0:	0002e497          	auipc	s1,0x2e
    800058f4:	9a048493          	add	s1,s1,-1632 # 80033290 <log>
    800058f8:	8526                	mv	a0,s1
    800058fa:	ffffd097          	auipc	ra,0xffffd
    800058fe:	750080e7          	jalr	1872(ra) # 8000304a <wakeup>
  release(&log.lock);
    80005902:	8526                	mv	a0,s1
    80005904:	ffffc097          	auipc	ra,0xffffc
    80005908:	b64080e7          	jalr	-1180(ra) # 80001468 <release>
}
    8000590c:	70e2                	ld	ra,56(sp)
    8000590e:	7442                	ld	s0,48(sp)
    80005910:	74a2                	ld	s1,40(sp)
    80005912:	7902                	ld	s2,32(sp)
    80005914:	6121                	add	sp,sp,64
    80005916:	8082                	ret
    80005918:	ec4e                	sd	s3,24(sp)
    8000591a:	e852                	sd	s4,16(sp)
    8000591c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000591e:	0002ea97          	auipc	s5,0x2e
    80005922:	9a2a8a93          	add	s5,s5,-1630 # 800332c0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80005926:	0002ea17          	auipc	s4,0x2e
    8000592a:	96aa0a13          	add	s4,s4,-1686 # 80033290 <log>
    8000592e:	018a2583          	lw	a1,24(s4)
    80005932:	012585bb          	addw	a1,a1,s2
    80005936:	2585                	addw	a1,a1,1
    80005938:	028a2503          	lw	a0,40(s4)
    8000593c:	fffff097          	auipc	ra,0xfffff
    80005940:	caa080e7          	jalr	-854(ra) # 800045e6 <bread>
    80005944:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80005946:	000aa583          	lw	a1,0(s5)
    8000594a:	028a2503          	lw	a0,40(s4)
    8000594e:	fffff097          	auipc	ra,0xfffff
    80005952:	c98080e7          	jalr	-872(ra) # 800045e6 <bread>
    80005956:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80005958:	40000613          	li	a2,1024
    8000595c:	05850593          	add	a1,a0,88
    80005960:	05848513          	add	a0,s1,88
    80005964:	ffffc097          	auipc	ra,0xffffc
    80005968:	ba8080e7          	jalr	-1112(ra) # 8000150c <memmove>
    bwrite(to);  // write the log
    8000596c:	8526                	mv	a0,s1
    8000596e:	fffff097          	auipc	ra,0xfffff
    80005972:	d6a080e7          	jalr	-662(ra) # 800046d8 <bwrite>
    brelse(from);
    80005976:	854e                	mv	a0,s3
    80005978:	fffff097          	auipc	ra,0xfffff
    8000597c:	d9e080e7          	jalr	-610(ra) # 80004716 <brelse>
    brelse(to);
    80005980:	8526                	mv	a0,s1
    80005982:	fffff097          	auipc	ra,0xfffff
    80005986:	d94080e7          	jalr	-620(ra) # 80004716 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000598a:	2905                	addw	s2,s2,1
    8000598c:	0a91                	add	s5,s5,4
    8000598e:	02ca2783          	lw	a5,44(s4)
    80005992:	f8f94ee3          	blt	s2,a5,8000592e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80005996:	00000097          	auipc	ra,0x0
    8000599a:	c8c080e7          	jalr	-884(ra) # 80005622 <write_head>
    install_trans(0); // Now install writes to home locations
    8000599e:	4501                	li	a0,0
    800059a0:	00000097          	auipc	ra,0x0
    800059a4:	cec080e7          	jalr	-788(ra) # 8000568c <install_trans>
    log.lh.n = 0;
    800059a8:	0002e797          	auipc	a5,0x2e
    800059ac:	9007aa23          	sw	zero,-1772(a5) # 800332bc <log+0x2c>
    write_head();    // Erase the transaction from the log
    800059b0:	00000097          	auipc	ra,0x0
    800059b4:	c72080e7          	jalr	-910(ra) # 80005622 <write_head>
    800059b8:	69e2                	ld	s3,24(sp)
    800059ba:	6a42                	ld	s4,16(sp)
    800059bc:	6aa2                	ld	s5,8(sp)
    800059be:	bdc5                	j	800058ae <end_op+0x4c>

00000000800059c0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800059c0:	1101                	add	sp,sp,-32
    800059c2:	ec06                	sd	ra,24(sp)
    800059c4:	e822                	sd	s0,16(sp)
    800059c6:	e426                	sd	s1,8(sp)
    800059c8:	e04a                	sd	s2,0(sp)
    800059ca:	1000                	add	s0,sp,32
    800059cc:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800059ce:	0002e917          	auipc	s2,0x2e
    800059d2:	8c290913          	add	s2,s2,-1854 # 80033290 <log>
    800059d6:	854a                	mv	a0,s2
    800059d8:	ffffc097          	auipc	ra,0xffffc
    800059dc:	9dc080e7          	jalr	-1572(ra) # 800013b4 <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800059e0:	02c92603          	lw	a2,44(s2)
    800059e4:	47f5                	li	a5,29
    800059e6:	06c7c563          	blt	a5,a2,80005a50 <log_write+0x90>
    800059ea:	0002e797          	auipc	a5,0x2e
    800059ee:	8c27a783          	lw	a5,-1854(a5) # 800332ac <log+0x1c>
    800059f2:	37fd                	addw	a5,a5,-1
    800059f4:	04f65e63          	bge	a2,a5,80005a50 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800059f8:	0002e797          	auipc	a5,0x2e
    800059fc:	8b87a783          	lw	a5,-1864(a5) # 800332b0 <log+0x20>
    80005a00:	06f05063          	blez	a5,80005a60 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80005a04:	4781                	li	a5,0
    80005a06:	06c05563          	blez	a2,80005a70 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005a0a:	44cc                	lw	a1,12(s1)
    80005a0c:	0002e717          	auipc	a4,0x2e
    80005a10:	8b470713          	add	a4,a4,-1868 # 800332c0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80005a14:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80005a16:	4314                	lw	a3,0(a4)
    80005a18:	04b68c63          	beq	a3,a1,80005a70 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80005a1c:	2785                	addw	a5,a5,1
    80005a1e:	0711                	add	a4,a4,4
    80005a20:	fef61be3          	bne	a2,a5,80005a16 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80005a24:	0621                	add	a2,a2,8
    80005a26:	060a                	sll	a2,a2,0x2
    80005a28:	0002e797          	auipc	a5,0x2e
    80005a2c:	86878793          	add	a5,a5,-1944 # 80033290 <log>
    80005a30:	97b2                	add	a5,a5,a2
    80005a32:	44d8                	lw	a4,12(s1)
    80005a34:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80005a36:	8526                	mv	a0,s1
    80005a38:	fffff097          	auipc	ra,0xfffff
    80005a3c:	d7a080e7          	jalr	-646(ra) # 800047b2 <bpin>
    log.lh.n++;
    80005a40:	0002e717          	auipc	a4,0x2e
    80005a44:	85070713          	add	a4,a4,-1968 # 80033290 <log>
    80005a48:	575c                	lw	a5,44(a4)
    80005a4a:	2785                	addw	a5,a5,1
    80005a4c:	d75c                	sw	a5,44(a4)
    80005a4e:	a82d                	j	80005a88 <log_write+0xc8>
    panic("too big a transaction");
    80005a50:	00004517          	auipc	a0,0x4
    80005a54:	d6050513          	add	a0,a0,-672 # 800097b0 <etext+0x7b0>
    80005a58:	ffffb097          	auipc	ra,0xffffb
    80005a5c:	b3e080e7          	jalr	-1218(ra) # 80000596 <panic>
    panic("log_write outside of trans");
    80005a60:	00004517          	auipc	a0,0x4
    80005a64:	d6850513          	add	a0,a0,-664 # 800097c8 <etext+0x7c8>
    80005a68:	ffffb097          	auipc	ra,0xffffb
    80005a6c:	b2e080e7          	jalr	-1234(ra) # 80000596 <panic>
  log.lh.block[i] = b->blockno;
    80005a70:	00878693          	add	a3,a5,8
    80005a74:	068a                	sll	a3,a3,0x2
    80005a76:	0002e717          	auipc	a4,0x2e
    80005a7a:	81a70713          	add	a4,a4,-2022 # 80033290 <log>
    80005a7e:	9736                	add	a4,a4,a3
    80005a80:	44d4                	lw	a3,12(s1)
    80005a82:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80005a84:	faf609e3          	beq	a2,a5,80005a36 <log_write+0x76>
  }
  release(&log.lock);
    80005a88:	0002e517          	auipc	a0,0x2e
    80005a8c:	80850513          	add	a0,a0,-2040 # 80033290 <log>
    80005a90:	ffffc097          	auipc	ra,0xffffc
    80005a94:	9d8080e7          	jalr	-1576(ra) # 80001468 <release>
}
    80005a98:	60e2                	ld	ra,24(sp)
    80005a9a:	6442                	ld	s0,16(sp)
    80005a9c:	64a2                	ld	s1,8(sp)
    80005a9e:	6902                	ld	s2,0(sp)
    80005aa0:	6105                	add	sp,sp,32
    80005aa2:	8082                	ret

0000000080005aa4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80005aa4:	1101                	add	sp,sp,-32
    80005aa6:	ec06                	sd	ra,24(sp)
    80005aa8:	e822                	sd	s0,16(sp)
    80005aaa:	e426                	sd	s1,8(sp)
    80005aac:	e04a                	sd	s2,0(sp)
    80005aae:	1000                	add	s0,sp,32
    80005ab0:	84aa                	mv	s1,a0
    80005ab2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80005ab4:	00004597          	auipc	a1,0x4
    80005ab8:	d3458593          	add	a1,a1,-716 # 800097e8 <etext+0x7e8>
    80005abc:	0521                	add	a0,a0,8
    80005abe:	ffffc097          	auipc	ra,0xffffc
    80005ac2:	866080e7          	jalr	-1946(ra) # 80001324 <initlock>
  lk->name = name;
    80005ac6:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80005aca:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005ace:	0204a423          	sw	zero,40(s1)
}
    80005ad2:	60e2                	ld	ra,24(sp)
    80005ad4:	6442                	ld	s0,16(sp)
    80005ad6:	64a2                	ld	s1,8(sp)
    80005ad8:	6902                	ld	s2,0(sp)
    80005ada:	6105                	add	sp,sp,32
    80005adc:	8082                	ret

0000000080005ade <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80005ade:	1101                	add	sp,sp,-32
    80005ae0:	ec06                	sd	ra,24(sp)
    80005ae2:	e822                	sd	s0,16(sp)
    80005ae4:	e426                	sd	s1,8(sp)
    80005ae6:	e04a                	sd	s2,0(sp)
    80005ae8:	1000                	add	s0,sp,32
    80005aea:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005aec:	00850913          	add	s2,a0,8
    80005af0:	854a                	mv	a0,s2
    80005af2:	ffffc097          	auipc	ra,0xffffc
    80005af6:	8c2080e7          	jalr	-1854(ra) # 800013b4 <acquire>
  while (lk->locked) {
    80005afa:	409c                	lw	a5,0(s1)
    80005afc:	cb89                	beqz	a5,80005b0e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80005afe:	85ca                	mv	a1,s2
    80005b00:	8526                	mv	a0,s1
    80005b02:	ffffd097          	auipc	ra,0xffffd
    80005b06:	4e4080e7          	jalr	1252(ra) # 80002fe6 <sleep>
  while (lk->locked) {
    80005b0a:	409c                	lw	a5,0(s1)
    80005b0c:	fbed                	bnez	a5,80005afe <acquiresleep+0x20>
  }
  lk->locked = 1;
    80005b0e:	4785                	li	a5,1
    80005b10:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80005b12:	ffffd097          	auipc	ra,0xffffd
    80005b16:	872080e7          	jalr	-1934(ra) # 80002384 <myproc>
    80005b1a:	591c                	lw	a5,48(a0)
    80005b1c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80005b1e:	854a                	mv	a0,s2
    80005b20:	ffffc097          	auipc	ra,0xffffc
    80005b24:	948080e7          	jalr	-1720(ra) # 80001468 <release>
}
    80005b28:	60e2                	ld	ra,24(sp)
    80005b2a:	6442                	ld	s0,16(sp)
    80005b2c:	64a2                	ld	s1,8(sp)
    80005b2e:	6902                	ld	s2,0(sp)
    80005b30:	6105                	add	sp,sp,32
    80005b32:	8082                	ret

0000000080005b34 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80005b34:	1101                	add	sp,sp,-32
    80005b36:	ec06                	sd	ra,24(sp)
    80005b38:	e822                	sd	s0,16(sp)
    80005b3a:	e426                	sd	s1,8(sp)
    80005b3c:	e04a                	sd	s2,0(sp)
    80005b3e:	1000                	add	s0,sp,32
    80005b40:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80005b42:	00850913          	add	s2,a0,8
    80005b46:	854a                	mv	a0,s2
    80005b48:	ffffc097          	auipc	ra,0xffffc
    80005b4c:	86c080e7          	jalr	-1940(ra) # 800013b4 <acquire>
  lk->locked = 0;
    80005b50:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80005b54:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80005b58:	8526                	mv	a0,s1
    80005b5a:	ffffd097          	auipc	ra,0xffffd
    80005b5e:	4f0080e7          	jalr	1264(ra) # 8000304a <wakeup>
  release(&lk->lk);
    80005b62:	854a                	mv	a0,s2
    80005b64:	ffffc097          	auipc	ra,0xffffc
    80005b68:	904080e7          	jalr	-1788(ra) # 80001468 <release>
}
    80005b6c:	60e2                	ld	ra,24(sp)
    80005b6e:	6442                	ld	s0,16(sp)
    80005b70:	64a2                	ld	s1,8(sp)
    80005b72:	6902                	ld	s2,0(sp)
    80005b74:	6105                	add	sp,sp,32
    80005b76:	8082                	ret

0000000080005b78 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80005b78:	7179                	add	sp,sp,-48
    80005b7a:	f406                	sd	ra,40(sp)
    80005b7c:	f022                	sd	s0,32(sp)
    80005b7e:	ec26                	sd	s1,24(sp)
    80005b80:	e84a                	sd	s2,16(sp)
    80005b82:	1800                	add	s0,sp,48
    80005b84:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80005b86:	00850913          	add	s2,a0,8
    80005b8a:	854a                	mv	a0,s2
    80005b8c:	ffffc097          	auipc	ra,0xffffc
    80005b90:	828080e7          	jalr	-2008(ra) # 800013b4 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80005b94:	409c                	lw	a5,0(s1)
    80005b96:	ef91                	bnez	a5,80005bb2 <holdingsleep+0x3a>
    80005b98:	4481                	li	s1,0
  release(&lk->lk);
    80005b9a:	854a                	mv	a0,s2
    80005b9c:	ffffc097          	auipc	ra,0xffffc
    80005ba0:	8cc080e7          	jalr	-1844(ra) # 80001468 <release>
  return r;
}
    80005ba4:	8526                	mv	a0,s1
    80005ba6:	70a2                	ld	ra,40(sp)
    80005ba8:	7402                	ld	s0,32(sp)
    80005baa:	64e2                	ld	s1,24(sp)
    80005bac:	6942                	ld	s2,16(sp)
    80005bae:	6145                	add	sp,sp,48
    80005bb0:	8082                	ret
    80005bb2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80005bb4:	0284a983          	lw	s3,40(s1)
    80005bb8:	ffffc097          	auipc	ra,0xffffc
    80005bbc:	7cc080e7          	jalr	1996(ra) # 80002384 <myproc>
    80005bc0:	5904                	lw	s1,48(a0)
    80005bc2:	413484b3          	sub	s1,s1,s3
    80005bc6:	0014b493          	seqz	s1,s1
    80005bca:	69a2                	ld	s3,8(sp)
    80005bcc:	b7f9                	j	80005b9a <holdingsleep+0x22>

0000000080005bce <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80005bce:	1141                	add	sp,sp,-16
    80005bd0:	e406                	sd	ra,8(sp)
    80005bd2:	e022                	sd	s0,0(sp)
    80005bd4:	0800                	add	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80005bd6:	00004597          	auipc	a1,0x4
    80005bda:	c2258593          	add	a1,a1,-990 # 800097f8 <etext+0x7f8>
    80005bde:	0002d517          	auipc	a0,0x2d
    80005be2:	7fa50513          	add	a0,a0,2042 # 800333d8 <ftable>
    80005be6:	ffffb097          	auipc	ra,0xffffb
    80005bea:	73e080e7          	jalr	1854(ra) # 80001324 <initlock>
}
    80005bee:	60a2                	ld	ra,8(sp)
    80005bf0:	6402                	ld	s0,0(sp)
    80005bf2:	0141                	add	sp,sp,16
    80005bf4:	8082                	ret

0000000080005bf6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80005bf6:	1101                	add	sp,sp,-32
    80005bf8:	ec06                	sd	ra,24(sp)
    80005bfa:	e822                	sd	s0,16(sp)
    80005bfc:	e426                	sd	s1,8(sp)
    80005bfe:	1000                	add	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80005c00:	0002d517          	auipc	a0,0x2d
    80005c04:	7d850513          	add	a0,a0,2008 # 800333d8 <ftable>
    80005c08:	ffffb097          	auipc	ra,0xffffb
    80005c0c:	7ac080e7          	jalr	1964(ra) # 800013b4 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005c10:	0002d497          	auipc	s1,0x2d
    80005c14:	7e048493          	add	s1,s1,2016 # 800333f0 <ftable+0x18>
    80005c18:	0002e717          	auipc	a4,0x2e
    80005c1c:	77870713          	add	a4,a4,1912 # 80034390 <disk>
    if(f->ref == 0){
    80005c20:	40dc                	lw	a5,4(s1)
    80005c22:	cf99                	beqz	a5,80005c40 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80005c24:	02848493          	add	s1,s1,40
    80005c28:	fee49ce3          	bne	s1,a4,80005c20 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80005c2c:	0002d517          	auipc	a0,0x2d
    80005c30:	7ac50513          	add	a0,a0,1964 # 800333d8 <ftable>
    80005c34:	ffffc097          	auipc	ra,0xffffc
    80005c38:	834080e7          	jalr	-1996(ra) # 80001468 <release>
  return 0;
    80005c3c:	4481                	li	s1,0
    80005c3e:	a819                	j	80005c54 <filealloc+0x5e>
      f->ref = 1;
    80005c40:	4785                	li	a5,1
    80005c42:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80005c44:	0002d517          	auipc	a0,0x2d
    80005c48:	79450513          	add	a0,a0,1940 # 800333d8 <ftable>
    80005c4c:	ffffc097          	auipc	ra,0xffffc
    80005c50:	81c080e7          	jalr	-2020(ra) # 80001468 <release>
}
    80005c54:	8526                	mv	a0,s1
    80005c56:	60e2                	ld	ra,24(sp)
    80005c58:	6442                	ld	s0,16(sp)
    80005c5a:	64a2                	ld	s1,8(sp)
    80005c5c:	6105                	add	sp,sp,32
    80005c5e:	8082                	ret

0000000080005c60 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80005c60:	1101                	add	sp,sp,-32
    80005c62:	ec06                	sd	ra,24(sp)
    80005c64:	e822                	sd	s0,16(sp)
    80005c66:	e426                	sd	s1,8(sp)
    80005c68:	1000                	add	s0,sp,32
    80005c6a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80005c6c:	0002d517          	auipc	a0,0x2d
    80005c70:	76c50513          	add	a0,a0,1900 # 800333d8 <ftable>
    80005c74:	ffffb097          	auipc	ra,0xffffb
    80005c78:	740080e7          	jalr	1856(ra) # 800013b4 <acquire>
  if(f->ref < 1)
    80005c7c:	40dc                	lw	a5,4(s1)
    80005c7e:	02f05263          	blez	a5,80005ca2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    80005c82:	2785                	addw	a5,a5,1
    80005c84:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80005c86:	0002d517          	auipc	a0,0x2d
    80005c8a:	75250513          	add	a0,a0,1874 # 800333d8 <ftable>
    80005c8e:	ffffb097          	auipc	ra,0xffffb
    80005c92:	7da080e7          	jalr	2010(ra) # 80001468 <release>
  return f;
}
    80005c96:	8526                	mv	a0,s1
    80005c98:	60e2                	ld	ra,24(sp)
    80005c9a:	6442                	ld	s0,16(sp)
    80005c9c:	64a2                	ld	s1,8(sp)
    80005c9e:	6105                	add	sp,sp,32
    80005ca0:	8082                	ret
    panic("filedup");
    80005ca2:	00004517          	auipc	a0,0x4
    80005ca6:	b5e50513          	add	a0,a0,-1186 # 80009800 <etext+0x800>
    80005caa:	ffffb097          	auipc	ra,0xffffb
    80005cae:	8ec080e7          	jalr	-1812(ra) # 80000596 <panic>

0000000080005cb2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80005cb2:	7139                	add	sp,sp,-64
    80005cb4:	fc06                	sd	ra,56(sp)
    80005cb6:	f822                	sd	s0,48(sp)
    80005cb8:	f426                	sd	s1,40(sp)
    80005cba:	0080                	add	s0,sp,64
    80005cbc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80005cbe:	0002d517          	auipc	a0,0x2d
    80005cc2:	71a50513          	add	a0,a0,1818 # 800333d8 <ftable>
    80005cc6:	ffffb097          	auipc	ra,0xffffb
    80005cca:	6ee080e7          	jalr	1774(ra) # 800013b4 <acquire>
  if(f->ref < 1)
    80005cce:	40dc                	lw	a5,4(s1)
    80005cd0:	04f05c63          	blez	a5,80005d28 <fileclose+0x76>
    panic("fileclose");
  if(--f->ref > 0){
    80005cd4:	37fd                	addw	a5,a5,-1
    80005cd6:	0007871b          	sext.w	a4,a5
    80005cda:	c0dc                	sw	a5,4(s1)
    80005cdc:	06e04263          	bgtz	a4,80005d40 <fileclose+0x8e>
    80005ce0:	f04a                	sd	s2,32(sp)
    80005ce2:	ec4e                	sd	s3,24(sp)
    80005ce4:	e852                	sd	s4,16(sp)
    80005ce6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80005ce8:	0004a903          	lw	s2,0(s1)
    80005cec:	0094ca83          	lbu	s5,9(s1)
    80005cf0:	0104ba03          	ld	s4,16(s1)
    80005cf4:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80005cf8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80005cfc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80005d00:	0002d517          	auipc	a0,0x2d
    80005d04:	6d850513          	add	a0,a0,1752 # 800333d8 <ftable>
    80005d08:	ffffb097          	auipc	ra,0xffffb
    80005d0c:	760080e7          	jalr	1888(ra) # 80001468 <release>

  if(ff.type == FD_PIPE){
    80005d10:	4785                	li	a5,1
    80005d12:	04f90463          	beq	s2,a5,80005d5a <fileclose+0xa8>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80005d16:	3979                	addw	s2,s2,-2
    80005d18:	4785                	li	a5,1
    80005d1a:	0527fb63          	bgeu	a5,s2,80005d70 <fileclose+0xbe>
    80005d1e:	7902                	ld	s2,32(sp)
    80005d20:	69e2                	ld	s3,24(sp)
    80005d22:	6a42                	ld	s4,16(sp)
    80005d24:	6aa2                	ld	s5,8(sp)
    80005d26:	a02d                	j	80005d50 <fileclose+0x9e>
    80005d28:	f04a                	sd	s2,32(sp)
    80005d2a:	ec4e                	sd	s3,24(sp)
    80005d2c:	e852                	sd	s4,16(sp)
    80005d2e:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80005d30:	00004517          	auipc	a0,0x4
    80005d34:	ad850513          	add	a0,a0,-1320 # 80009808 <etext+0x808>
    80005d38:	ffffb097          	auipc	ra,0xffffb
    80005d3c:	85e080e7          	jalr	-1954(ra) # 80000596 <panic>
    release(&ftable.lock);
    80005d40:	0002d517          	auipc	a0,0x2d
    80005d44:	69850513          	add	a0,a0,1688 # 800333d8 <ftable>
    80005d48:	ffffb097          	auipc	ra,0xffffb
    80005d4c:	720080e7          	jalr	1824(ra) # 80001468 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80005d50:	70e2                	ld	ra,56(sp)
    80005d52:	7442                	ld	s0,48(sp)
    80005d54:	74a2                	ld	s1,40(sp)
    80005d56:	6121                	add	sp,sp,64
    80005d58:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80005d5a:	85d6                	mv	a1,s5
    80005d5c:	8552                	mv	a0,s4
    80005d5e:	00000097          	auipc	ra,0x0
    80005d62:	3a2080e7          	jalr	930(ra) # 80006100 <pipeclose>
    80005d66:	7902                	ld	s2,32(sp)
    80005d68:	69e2                	ld	s3,24(sp)
    80005d6a:	6a42                	ld	s4,16(sp)
    80005d6c:	6aa2                	ld	s5,8(sp)
    80005d6e:	b7cd                	j	80005d50 <fileclose+0x9e>
    begin_op();
    80005d70:	00000097          	auipc	ra,0x0
    80005d74:	a78080e7          	jalr	-1416(ra) # 800057e8 <begin_op>
    iput(ff.ip);
    80005d78:	854e                	mv	a0,s3
    80005d7a:	fffff097          	auipc	ra,0xfffff
    80005d7e:	25e080e7          	jalr	606(ra) # 80004fd8 <iput>
    end_op();
    80005d82:	00000097          	auipc	ra,0x0
    80005d86:	ae0080e7          	jalr	-1312(ra) # 80005862 <end_op>
    80005d8a:	7902                	ld	s2,32(sp)
    80005d8c:	69e2                	ld	s3,24(sp)
    80005d8e:	6a42                	ld	s4,16(sp)
    80005d90:	6aa2                	ld	s5,8(sp)
    80005d92:	bf7d                	j	80005d50 <fileclose+0x9e>

0000000080005d94 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80005d94:	715d                	add	sp,sp,-80
    80005d96:	e486                	sd	ra,72(sp)
    80005d98:	e0a2                	sd	s0,64(sp)
    80005d9a:	fc26                	sd	s1,56(sp)
    80005d9c:	f44e                	sd	s3,40(sp)
    80005d9e:	0880                	add	s0,sp,80
    80005da0:	84aa                	mv	s1,a0
    80005da2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80005da4:	ffffc097          	auipc	ra,0xffffc
    80005da8:	5e0080e7          	jalr	1504(ra) # 80002384 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80005dac:	409c                	lw	a5,0(s1)
    80005dae:	37f9                	addw	a5,a5,-2
    80005db0:	4705                	li	a4,1
    80005db2:	04f76863          	bltu	a4,a5,80005e02 <filestat+0x6e>
    80005db6:	f84a                	sd	s2,48(sp)
    80005db8:	892a                	mv	s2,a0
    ilock(f->ip);
    80005dba:	6c88                	ld	a0,24(s1)
    80005dbc:	fffff097          	auipc	ra,0xfffff
    80005dc0:	05e080e7          	jalr	94(ra) # 80004e1a <ilock>
    stati(f->ip, &st);
    80005dc4:	fb840593          	add	a1,s0,-72
    80005dc8:	6c88                	ld	a0,24(s1)
    80005dca:	fffff097          	auipc	ra,0xfffff
    80005dce:	2de080e7          	jalr	734(ra) # 800050a8 <stati>
    iunlock(f->ip);
    80005dd2:	6c88                	ld	a0,24(s1)
    80005dd4:	fffff097          	auipc	ra,0xfffff
    80005dd8:	10c080e7          	jalr	268(ra) # 80004ee0 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80005ddc:	46e1                	li	a3,24
    80005dde:	fb840613          	add	a2,s0,-72
    80005de2:	85ce                	mv	a1,s3
    80005de4:	0b093503          	ld	a0,176(s2)
    80005de8:	ffffc097          	auipc	ra,0xffffc
    80005dec:	234080e7          	jalr	564(ra) # 8000201c <copyout>
    80005df0:	41f5551b          	sraw	a0,a0,0x1f
    80005df4:	7942                	ld	s2,48(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80005df6:	60a6                	ld	ra,72(sp)
    80005df8:	6406                	ld	s0,64(sp)
    80005dfa:	74e2                	ld	s1,56(sp)
    80005dfc:	79a2                	ld	s3,40(sp)
    80005dfe:	6161                	add	sp,sp,80
    80005e00:	8082                	ret
  return -1;
    80005e02:	557d                	li	a0,-1
    80005e04:	bfcd                	j	80005df6 <filestat+0x62>

0000000080005e06 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80005e06:	7179                	add	sp,sp,-48
    80005e08:	f406                	sd	ra,40(sp)
    80005e0a:	f022                	sd	s0,32(sp)
    80005e0c:	e84a                	sd	s2,16(sp)
    80005e0e:	1800                	add	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80005e10:	00854783          	lbu	a5,8(a0)
    80005e14:	cbc5                	beqz	a5,80005ec4 <fileread+0xbe>
    80005e16:	ec26                	sd	s1,24(sp)
    80005e18:	e44e                	sd	s3,8(sp)
    80005e1a:	84aa                	mv	s1,a0
    80005e1c:	89ae                	mv	s3,a1
    80005e1e:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80005e20:	411c                	lw	a5,0(a0)
    80005e22:	4705                	li	a4,1
    80005e24:	04e78963          	beq	a5,a4,80005e76 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005e28:	470d                	li	a4,3
    80005e2a:	04e78f63          	beq	a5,a4,80005e88 <fileread+0x82>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80005e2e:	4709                	li	a4,2
    80005e30:	08e79263          	bne	a5,a4,80005eb4 <fileread+0xae>
    ilock(f->ip);
    80005e34:	6d08                	ld	a0,24(a0)
    80005e36:	fffff097          	auipc	ra,0xfffff
    80005e3a:	fe4080e7          	jalr	-28(ra) # 80004e1a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80005e3e:	874a                	mv	a4,s2
    80005e40:	5094                	lw	a3,32(s1)
    80005e42:	864e                	mv	a2,s3
    80005e44:	4585                	li	a1,1
    80005e46:	6c88                	ld	a0,24(s1)
    80005e48:	fffff097          	auipc	ra,0xfffff
    80005e4c:	28a080e7          	jalr	650(ra) # 800050d2 <readi>
    80005e50:	892a                	mv	s2,a0
    80005e52:	00a05563          	blez	a0,80005e5c <fileread+0x56>
      f->off += r;
    80005e56:	509c                	lw	a5,32(s1)
    80005e58:	9fa9                	addw	a5,a5,a0
    80005e5a:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80005e5c:	6c88                	ld	a0,24(s1)
    80005e5e:	fffff097          	auipc	ra,0xfffff
    80005e62:	082080e7          	jalr	130(ra) # 80004ee0 <iunlock>
    80005e66:	64e2                	ld	s1,24(sp)
    80005e68:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80005e6a:	854a                	mv	a0,s2
    80005e6c:	70a2                	ld	ra,40(sp)
    80005e6e:	7402                	ld	s0,32(sp)
    80005e70:	6942                	ld	s2,16(sp)
    80005e72:	6145                	add	sp,sp,48
    80005e74:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80005e76:	6908                	ld	a0,16(a0)
    80005e78:	00000097          	auipc	ra,0x0
    80005e7c:	400080e7          	jalr	1024(ra) # 80006278 <piperead>
    80005e80:	892a                	mv	s2,a0
    80005e82:	64e2                	ld	s1,24(sp)
    80005e84:	69a2                	ld	s3,8(sp)
    80005e86:	b7d5                	j	80005e6a <fileread+0x64>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80005e88:	02451783          	lh	a5,36(a0)
    80005e8c:	03079693          	sll	a3,a5,0x30
    80005e90:	92c1                	srl	a3,a3,0x30
    80005e92:	4725                	li	a4,9
    80005e94:	02d76a63          	bltu	a4,a3,80005ec8 <fileread+0xc2>
    80005e98:	0792                	sll	a5,a5,0x4
    80005e9a:	0002d717          	auipc	a4,0x2d
    80005e9e:	49e70713          	add	a4,a4,1182 # 80033338 <devsw>
    80005ea2:	97ba                	add	a5,a5,a4
    80005ea4:	639c                	ld	a5,0(a5)
    80005ea6:	c78d                	beqz	a5,80005ed0 <fileread+0xca>
    r = devsw[f->major].read(1, addr, n);
    80005ea8:	4505                	li	a0,1
    80005eaa:	9782                	jalr	a5
    80005eac:	892a                	mv	s2,a0
    80005eae:	64e2                	ld	s1,24(sp)
    80005eb0:	69a2                	ld	s3,8(sp)
    80005eb2:	bf65                	j	80005e6a <fileread+0x64>
    panic("fileread");
    80005eb4:	00004517          	auipc	a0,0x4
    80005eb8:	96450513          	add	a0,a0,-1692 # 80009818 <etext+0x818>
    80005ebc:	ffffa097          	auipc	ra,0xffffa
    80005ec0:	6da080e7          	jalr	1754(ra) # 80000596 <panic>
    return -1;
    80005ec4:	597d                	li	s2,-1
    80005ec6:	b755                	j	80005e6a <fileread+0x64>
      return -1;
    80005ec8:	597d                	li	s2,-1
    80005eca:	64e2                	ld	s1,24(sp)
    80005ecc:	69a2                	ld	s3,8(sp)
    80005ece:	bf71                	j	80005e6a <fileread+0x64>
    80005ed0:	597d                	li	s2,-1
    80005ed2:	64e2                	ld	s1,24(sp)
    80005ed4:	69a2                	ld	s3,8(sp)
    80005ed6:	bf51                	j	80005e6a <fileread+0x64>

0000000080005ed8 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80005ed8:	00954783          	lbu	a5,9(a0)
    80005edc:	12078963          	beqz	a5,8000600e <filewrite+0x136>
{
    80005ee0:	715d                	add	sp,sp,-80
    80005ee2:	e486                	sd	ra,72(sp)
    80005ee4:	e0a2                	sd	s0,64(sp)
    80005ee6:	f84a                	sd	s2,48(sp)
    80005ee8:	f052                	sd	s4,32(sp)
    80005eea:	e85a                	sd	s6,16(sp)
    80005eec:	0880                	add	s0,sp,80
    80005eee:	892a                	mv	s2,a0
    80005ef0:	8b2e                	mv	s6,a1
    80005ef2:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80005ef4:	411c                	lw	a5,0(a0)
    80005ef6:	4705                	li	a4,1
    80005ef8:	02e78763          	beq	a5,a4,80005f26 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80005efc:	470d                	li	a4,3
    80005efe:	02e78a63          	beq	a5,a4,80005f32 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80005f02:	4709                	li	a4,2
    80005f04:	0ee79863          	bne	a5,a4,80005ff4 <filewrite+0x11c>
    80005f08:	f44e                	sd	s3,40(sp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80005f0a:	0cc05463          	blez	a2,80005fd2 <filewrite+0xfa>
    80005f0e:	fc26                	sd	s1,56(sp)
    80005f10:	ec56                	sd	s5,24(sp)
    80005f12:	e45e                	sd	s7,8(sp)
    80005f14:	e062                	sd	s8,0(sp)
    int i = 0;
    80005f16:	4981                	li	s3,0
      int n1 = n - i;
      if(n1 > max)
    80005f18:	6b85                	lui	s7,0x1
    80005f1a:	c00b8b93          	add	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80005f1e:	6c05                	lui	s8,0x1
    80005f20:	c00c0c1b          	addw	s8,s8,-1024 # c00 <_entry-0x7ffff400>
    80005f24:	a851                	j	80005fb8 <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80005f26:	6908                	ld	a0,16(a0)
    80005f28:	00000097          	auipc	ra,0x0
    80005f2c:	248080e7          	jalr	584(ra) # 80006170 <pipewrite>
    80005f30:	a85d                	j	80005fe6 <filewrite+0x10e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80005f32:	02451783          	lh	a5,36(a0)
    80005f36:	03079693          	sll	a3,a5,0x30
    80005f3a:	92c1                	srl	a3,a3,0x30
    80005f3c:	4725                	li	a4,9
    80005f3e:	0cd76a63          	bltu	a4,a3,80006012 <filewrite+0x13a>
    80005f42:	0792                	sll	a5,a5,0x4
    80005f44:	0002d717          	auipc	a4,0x2d
    80005f48:	3f470713          	add	a4,a4,1012 # 80033338 <devsw>
    80005f4c:	97ba                	add	a5,a5,a4
    80005f4e:	679c                	ld	a5,8(a5)
    80005f50:	c3f9                	beqz	a5,80006016 <filewrite+0x13e>
    ret = devsw[f->major].write(1, addr, n);
    80005f52:	4505                	li	a0,1
    80005f54:	9782                	jalr	a5
    80005f56:	a841                	j	80005fe6 <filewrite+0x10e>
      if(n1 > max)
    80005f58:	00048a9b          	sext.w	s5,s1
        n1 = max;

      begin_op();
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	88c080e7          	jalr	-1908(ra) # 800057e8 <begin_op>
      ilock(f->ip);
    80005f64:	01893503          	ld	a0,24(s2)
    80005f68:	fffff097          	auipc	ra,0xfffff
    80005f6c:	eb2080e7          	jalr	-334(ra) # 80004e1a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80005f70:	8756                	mv	a4,s5
    80005f72:	02092683          	lw	a3,32(s2)
    80005f76:	01698633          	add	a2,s3,s6
    80005f7a:	4585                	li	a1,1
    80005f7c:	01893503          	ld	a0,24(s2)
    80005f80:	fffff097          	auipc	ra,0xfffff
    80005f84:	262080e7          	jalr	610(ra) # 800051e2 <writei>
    80005f88:	84aa                	mv	s1,a0
    80005f8a:	00a05763          	blez	a0,80005f98 <filewrite+0xc0>
        f->off += r;
    80005f8e:	02092783          	lw	a5,32(s2)
    80005f92:	9fa9                	addw	a5,a5,a0
    80005f94:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80005f98:	01893503          	ld	a0,24(s2)
    80005f9c:	fffff097          	auipc	ra,0xfffff
    80005fa0:	f44080e7          	jalr	-188(ra) # 80004ee0 <iunlock>
      end_op();
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	8be080e7          	jalr	-1858(ra) # 80005862 <end_op>

      if(r != n1){
    80005fac:	029a9563          	bne	s5,s1,80005fd6 <filewrite+0xfe>
        // error from writei
        break;
      }
      i += r;
    80005fb0:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80005fb4:	0149da63          	bge	s3,s4,80005fc8 <filewrite+0xf0>
      int n1 = n - i;
    80005fb8:	413a04bb          	subw	s1,s4,s3
      if(n1 > max)
    80005fbc:	0004879b          	sext.w	a5,s1
    80005fc0:	f8fbdce3          	bge	s7,a5,80005f58 <filewrite+0x80>
    80005fc4:	84e2                	mv	s1,s8
    80005fc6:	bf49                	j	80005f58 <filewrite+0x80>
    80005fc8:	74e2                	ld	s1,56(sp)
    80005fca:	6ae2                	ld	s5,24(sp)
    80005fcc:	6ba2                	ld	s7,8(sp)
    80005fce:	6c02                	ld	s8,0(sp)
    80005fd0:	a039                	j	80005fde <filewrite+0x106>
    int i = 0;
    80005fd2:	4981                	li	s3,0
    80005fd4:	a029                	j	80005fde <filewrite+0x106>
    80005fd6:	74e2                	ld	s1,56(sp)
    80005fd8:	6ae2                	ld	s5,24(sp)
    80005fda:	6ba2                	ld	s7,8(sp)
    80005fdc:	6c02                	ld	s8,0(sp)
    }
    ret = (i == n ? n : -1);
    80005fde:	033a1e63          	bne	s4,s3,8000601a <filewrite+0x142>
    80005fe2:	8552                	mv	a0,s4
    80005fe4:	79a2                	ld	s3,40(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80005fe6:	60a6                	ld	ra,72(sp)
    80005fe8:	6406                	ld	s0,64(sp)
    80005fea:	7942                	ld	s2,48(sp)
    80005fec:	7a02                	ld	s4,32(sp)
    80005fee:	6b42                	ld	s6,16(sp)
    80005ff0:	6161                	add	sp,sp,80
    80005ff2:	8082                	ret
    80005ff4:	fc26                	sd	s1,56(sp)
    80005ff6:	f44e                	sd	s3,40(sp)
    80005ff8:	ec56                	sd	s5,24(sp)
    80005ffa:	e45e                	sd	s7,8(sp)
    80005ffc:	e062                	sd	s8,0(sp)
    panic("filewrite");
    80005ffe:	00004517          	auipc	a0,0x4
    80006002:	82a50513          	add	a0,a0,-2006 # 80009828 <etext+0x828>
    80006006:	ffffa097          	auipc	ra,0xffffa
    8000600a:	590080e7          	jalr	1424(ra) # 80000596 <panic>
    return -1;
    8000600e:	557d                	li	a0,-1
}
    80006010:	8082                	ret
      return -1;
    80006012:	557d                	li	a0,-1
    80006014:	bfc9                	j	80005fe6 <filewrite+0x10e>
    80006016:	557d                	li	a0,-1
    80006018:	b7f9                	j	80005fe6 <filewrite+0x10e>
    ret = (i == n ? n : -1);
    8000601a:	557d                	li	a0,-1
    8000601c:	79a2                	ld	s3,40(sp)
    8000601e:	b7e1                	j	80005fe6 <filewrite+0x10e>

0000000080006020 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80006020:	7179                	add	sp,sp,-48
    80006022:	f406                	sd	ra,40(sp)
    80006024:	f022                	sd	s0,32(sp)
    80006026:	ec26                	sd	s1,24(sp)
    80006028:	e052                	sd	s4,0(sp)
    8000602a:	1800                	add	s0,sp,48
    8000602c:	84aa                	mv	s1,a0
    8000602e:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80006030:	0005b023          	sd	zero,0(a1)
    80006034:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80006038:	00000097          	auipc	ra,0x0
    8000603c:	bbe080e7          	jalr	-1090(ra) # 80005bf6 <filealloc>
    80006040:	e088                	sd	a0,0(s1)
    80006042:	cd49                	beqz	a0,800060dc <pipealloc+0xbc>
    80006044:	00000097          	auipc	ra,0x0
    80006048:	bb2080e7          	jalr	-1102(ra) # 80005bf6 <filealloc>
    8000604c:	00aa3023          	sd	a0,0(s4)
    80006050:	c141                	beqz	a0,800060d0 <pipealloc+0xb0>
    80006052:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80006054:	ffffb097          	auipc	ra,0xffffb
    80006058:	fd2080e7          	jalr	-46(ra) # 80001026 <kalloc>
    8000605c:	892a                	mv	s2,a0
    8000605e:	c13d                	beqz	a0,800060c4 <pipealloc+0xa4>
    80006060:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80006062:	4985                	li	s3,1
    80006064:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80006068:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000606c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80006070:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80006074:	00003597          	auipc	a1,0x3
    80006078:	7c458593          	add	a1,a1,1988 # 80009838 <etext+0x838>
    8000607c:	ffffb097          	auipc	ra,0xffffb
    80006080:	2a8080e7          	jalr	680(ra) # 80001324 <initlock>
  (*f0)->type = FD_PIPE;
    80006084:	609c                	ld	a5,0(s1)
    80006086:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000608a:	609c                	ld	a5,0(s1)
    8000608c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80006090:	609c                	ld	a5,0(s1)
    80006092:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80006096:	609c                	ld	a5,0(s1)
    80006098:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000609c:	000a3783          	ld	a5,0(s4)
    800060a0:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800060a4:	000a3783          	ld	a5,0(s4)
    800060a8:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800060ac:	000a3783          	ld	a5,0(s4)
    800060b0:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800060b4:	000a3783          	ld	a5,0(s4)
    800060b8:	0127b823          	sd	s2,16(a5)
  return 0;
    800060bc:	4501                	li	a0,0
    800060be:	6942                	ld	s2,16(sp)
    800060c0:	69a2                	ld	s3,8(sp)
    800060c2:	a03d                	j	800060f0 <pipealloc+0xd0>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800060c4:	6088                	ld	a0,0(s1)
    800060c6:	c119                	beqz	a0,800060cc <pipealloc+0xac>
    800060c8:	6942                	ld	s2,16(sp)
    800060ca:	a029                	j	800060d4 <pipealloc+0xb4>
    800060cc:	6942                	ld	s2,16(sp)
    800060ce:	a039                	j	800060dc <pipealloc+0xbc>
    800060d0:	6088                	ld	a0,0(s1)
    800060d2:	c50d                	beqz	a0,800060fc <pipealloc+0xdc>
    fileclose(*f0);
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	bde080e7          	jalr	-1058(ra) # 80005cb2 <fileclose>
  if(*f1)
    800060dc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800060e0:	557d                	li	a0,-1
  if(*f1)
    800060e2:	c799                	beqz	a5,800060f0 <pipealloc+0xd0>
    fileclose(*f1);
    800060e4:	853e                	mv	a0,a5
    800060e6:	00000097          	auipc	ra,0x0
    800060ea:	bcc080e7          	jalr	-1076(ra) # 80005cb2 <fileclose>
  return -1;
    800060ee:	557d                	li	a0,-1
}
    800060f0:	70a2                	ld	ra,40(sp)
    800060f2:	7402                	ld	s0,32(sp)
    800060f4:	64e2                	ld	s1,24(sp)
    800060f6:	6a02                	ld	s4,0(sp)
    800060f8:	6145                	add	sp,sp,48
    800060fa:	8082                	ret
  return -1;
    800060fc:	557d                	li	a0,-1
    800060fe:	bfcd                	j	800060f0 <pipealloc+0xd0>

0000000080006100 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80006100:	1101                	add	sp,sp,-32
    80006102:	ec06                	sd	ra,24(sp)
    80006104:	e822                	sd	s0,16(sp)
    80006106:	e426                	sd	s1,8(sp)
    80006108:	e04a                	sd	s2,0(sp)
    8000610a:	1000                	add	s0,sp,32
    8000610c:	84aa                	mv	s1,a0
    8000610e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80006110:	ffffb097          	auipc	ra,0xffffb
    80006114:	2a4080e7          	jalr	676(ra) # 800013b4 <acquire>
  if(writable){
    80006118:	02090d63          	beqz	s2,80006152 <pipeclose+0x52>
    pi->writeopen = 0;
    8000611c:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80006120:	21848513          	add	a0,s1,536
    80006124:	ffffd097          	auipc	ra,0xffffd
    80006128:	f26080e7          	jalr	-218(ra) # 8000304a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    8000612c:	2204b783          	ld	a5,544(s1)
    80006130:	eb95                	bnez	a5,80006164 <pipeclose+0x64>
    release(&pi->lock);
    80006132:	8526                	mv	a0,s1
    80006134:	ffffb097          	auipc	ra,0xffffb
    80006138:	334080e7          	jalr	820(ra) # 80001468 <release>
    kfree((char*)pi);
    8000613c:	8526                	mv	a0,s1
    8000613e:	ffffb097          	auipc	ra,0xffffb
    80006142:	c8a080e7          	jalr	-886(ra) # 80000dc8 <kfree>
  } else
    release(&pi->lock);
}
    80006146:	60e2                	ld	ra,24(sp)
    80006148:	6442                	ld	s0,16(sp)
    8000614a:	64a2                	ld	s1,8(sp)
    8000614c:	6902                	ld	s2,0(sp)
    8000614e:	6105                	add	sp,sp,32
    80006150:	8082                	ret
    pi->readopen = 0;
    80006152:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80006156:	21c48513          	add	a0,s1,540
    8000615a:	ffffd097          	auipc	ra,0xffffd
    8000615e:	ef0080e7          	jalr	-272(ra) # 8000304a <wakeup>
    80006162:	b7e9                	j	8000612c <pipeclose+0x2c>
    release(&pi->lock);
    80006164:	8526                	mv	a0,s1
    80006166:	ffffb097          	auipc	ra,0xffffb
    8000616a:	302080e7          	jalr	770(ra) # 80001468 <release>
}
    8000616e:	bfe1                	j	80006146 <pipeclose+0x46>

0000000080006170 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80006170:	711d                	add	sp,sp,-96
    80006172:	ec86                	sd	ra,88(sp)
    80006174:	e8a2                	sd	s0,80(sp)
    80006176:	e4a6                	sd	s1,72(sp)
    80006178:	e0ca                	sd	s2,64(sp)
    8000617a:	fc4e                	sd	s3,56(sp)
    8000617c:	f852                	sd	s4,48(sp)
    8000617e:	f456                	sd	s5,40(sp)
    80006180:	1080                	add	s0,sp,96
    80006182:	84aa                	mv	s1,a0
    80006184:	8aae                	mv	s5,a1
    80006186:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80006188:	ffffc097          	auipc	ra,0xffffc
    8000618c:	1fc080e7          	jalr	508(ra) # 80002384 <myproc>
    80006190:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80006192:	8526                	mv	a0,s1
    80006194:	ffffb097          	auipc	ra,0xffffb
    80006198:	220080e7          	jalr	544(ra) # 800013b4 <acquire>
  while(i < n){
    8000619c:	0d405863          	blez	s4,8000626c <pipewrite+0xfc>
    800061a0:	f05a                	sd	s6,32(sp)
    800061a2:	ec5e                	sd	s7,24(sp)
    800061a4:	e862                	sd	s8,16(sp)
  int i = 0;
    800061a6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800061a8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800061aa:	21848c13          	add	s8,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800061ae:	21c48b93          	add	s7,s1,540
    800061b2:	a089                	j	800061f4 <pipewrite+0x84>
      release(&pi->lock);
    800061b4:	8526                	mv	a0,s1
    800061b6:	ffffb097          	auipc	ra,0xffffb
    800061ba:	2b2080e7          	jalr	690(ra) # 80001468 <release>
      return -1;
    800061be:	597d                	li	s2,-1
    800061c0:	7b02                	ld	s6,32(sp)
    800061c2:	6be2                	ld	s7,24(sp)
    800061c4:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800061c6:	854a                	mv	a0,s2
    800061c8:	60e6                	ld	ra,88(sp)
    800061ca:	6446                	ld	s0,80(sp)
    800061cc:	64a6                	ld	s1,72(sp)
    800061ce:	6906                	ld	s2,64(sp)
    800061d0:	79e2                	ld	s3,56(sp)
    800061d2:	7a42                	ld	s4,48(sp)
    800061d4:	7aa2                	ld	s5,40(sp)
    800061d6:	6125                	add	sp,sp,96
    800061d8:	8082                	ret
      wakeup(&pi->nread);
    800061da:	8562                	mv	a0,s8
    800061dc:	ffffd097          	auipc	ra,0xffffd
    800061e0:	e6e080e7          	jalr	-402(ra) # 8000304a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800061e4:	85a6                	mv	a1,s1
    800061e6:	855e                	mv	a0,s7
    800061e8:	ffffd097          	auipc	ra,0xffffd
    800061ec:	dfe080e7          	jalr	-514(ra) # 80002fe6 <sleep>
  while(i < n){
    800061f0:	05495f63          	bge	s2,s4,8000624e <pipewrite+0xde>
    if(pi->readopen == 0 || killed(pr)){
    800061f4:	2204a783          	lw	a5,544(s1)
    800061f8:	dfd5                	beqz	a5,800061b4 <pipewrite+0x44>
    800061fa:	854e                	mv	a0,s3
    800061fc:	ffffd097          	auipc	ra,0xffffd
    80006200:	092080e7          	jalr	146(ra) # 8000328e <killed>
    80006204:	f945                	bnez	a0,800061b4 <pipewrite+0x44>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80006206:	2184a783          	lw	a5,536(s1)
    8000620a:	21c4a703          	lw	a4,540(s1)
    8000620e:	2007879b          	addw	a5,a5,512
    80006212:	fcf704e3          	beq	a4,a5,800061da <pipewrite+0x6a>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80006216:	4685                	li	a3,1
    80006218:	01590633          	add	a2,s2,s5
    8000621c:	faf40593          	add	a1,s0,-81
    80006220:	0b09b503          	ld	a0,176(s3)
    80006224:	ffffc097          	auipc	ra,0xffffc
    80006228:	e84080e7          	jalr	-380(ra) # 800020a8 <copyin>
    8000622c:	05650263          	beq	a0,s6,80006270 <pipewrite+0x100>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80006230:	21c4a783          	lw	a5,540(s1)
    80006234:	0017871b          	addw	a4,a5,1
    80006238:	20e4ae23          	sw	a4,540(s1)
    8000623c:	1ff7f793          	and	a5,a5,511
    80006240:	97a6                	add	a5,a5,s1
    80006242:	faf44703          	lbu	a4,-81(s0)
    80006246:	00e78c23          	sb	a4,24(a5)
      i++;
    8000624a:	2905                	addw	s2,s2,1
    8000624c:	b755                	j	800061f0 <pipewrite+0x80>
    8000624e:	7b02                	ld	s6,32(sp)
    80006250:	6be2                	ld	s7,24(sp)
    80006252:	6c42                	ld	s8,16(sp)
  wakeup(&pi->nread);
    80006254:	21848513          	add	a0,s1,536
    80006258:	ffffd097          	auipc	ra,0xffffd
    8000625c:	df2080e7          	jalr	-526(ra) # 8000304a <wakeup>
  release(&pi->lock);
    80006260:	8526                	mv	a0,s1
    80006262:	ffffb097          	auipc	ra,0xffffb
    80006266:	206080e7          	jalr	518(ra) # 80001468 <release>
  return i;
    8000626a:	bfb1                	j	800061c6 <pipewrite+0x56>
  int i = 0;
    8000626c:	4901                	li	s2,0
    8000626e:	b7dd                	j	80006254 <pipewrite+0xe4>
    80006270:	7b02                	ld	s6,32(sp)
    80006272:	6be2                	ld	s7,24(sp)
    80006274:	6c42                	ld	s8,16(sp)
    80006276:	bff9                	j	80006254 <pipewrite+0xe4>

0000000080006278 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80006278:	715d                	add	sp,sp,-80
    8000627a:	e486                	sd	ra,72(sp)
    8000627c:	e0a2                	sd	s0,64(sp)
    8000627e:	fc26                	sd	s1,56(sp)
    80006280:	f84a                	sd	s2,48(sp)
    80006282:	f44e                	sd	s3,40(sp)
    80006284:	f052                	sd	s4,32(sp)
    80006286:	ec56                	sd	s5,24(sp)
    80006288:	0880                	add	s0,sp,80
    8000628a:	84aa                	mv	s1,a0
    8000628c:	892e                	mv	s2,a1
    8000628e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80006290:	ffffc097          	auipc	ra,0xffffc
    80006294:	0f4080e7          	jalr	244(ra) # 80002384 <myproc>
    80006298:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000629a:	8526                	mv	a0,s1
    8000629c:	ffffb097          	auipc	ra,0xffffb
    800062a0:	118080e7          	jalr	280(ra) # 800013b4 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800062a4:	2184a703          	lw	a4,536(s1)
    800062a8:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800062ac:	21848993          	add	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800062b0:	02f71963          	bne	a4,a5,800062e2 <piperead+0x6a>
    800062b4:	2244a783          	lw	a5,548(s1)
    800062b8:	cf95                	beqz	a5,800062f4 <piperead+0x7c>
    if(killed(pr)){
    800062ba:	8552                	mv	a0,s4
    800062bc:	ffffd097          	auipc	ra,0xffffd
    800062c0:	fd2080e7          	jalr	-46(ra) # 8000328e <killed>
    800062c4:	e10d                	bnez	a0,800062e6 <piperead+0x6e>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800062c6:	85a6                	mv	a1,s1
    800062c8:	854e                	mv	a0,s3
    800062ca:	ffffd097          	auipc	ra,0xffffd
    800062ce:	d1c080e7          	jalr	-740(ra) # 80002fe6 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800062d2:	2184a703          	lw	a4,536(s1)
    800062d6:	21c4a783          	lw	a5,540(s1)
    800062da:	fcf70de3          	beq	a4,a5,800062b4 <piperead+0x3c>
    800062de:	e85a                	sd	s6,16(sp)
    800062e0:	a819                	j	800062f6 <piperead+0x7e>
    800062e2:	e85a                	sd	s6,16(sp)
    800062e4:	a809                	j	800062f6 <piperead+0x7e>
      release(&pi->lock);
    800062e6:	8526                	mv	a0,s1
    800062e8:	ffffb097          	auipc	ra,0xffffb
    800062ec:	180080e7          	jalr	384(ra) # 80001468 <release>
      return -1;
    800062f0:	59fd                	li	s3,-1
    800062f2:	a0a5                	j	8000635a <piperead+0xe2>
    800062f4:	e85a                	sd	s6,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800062f6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800062f8:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800062fa:	05505463          	blez	s5,80006342 <piperead+0xca>
    if(pi->nread == pi->nwrite)
    800062fe:	2184a783          	lw	a5,536(s1)
    80006302:	21c4a703          	lw	a4,540(s1)
    80006306:	02f70e63          	beq	a4,a5,80006342 <piperead+0xca>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000630a:	0017871b          	addw	a4,a5,1
    8000630e:	20e4ac23          	sw	a4,536(s1)
    80006312:	1ff7f793          	and	a5,a5,511
    80006316:	97a6                	add	a5,a5,s1
    80006318:	0187c783          	lbu	a5,24(a5)
    8000631c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80006320:	4685                	li	a3,1
    80006322:	fbf40613          	add	a2,s0,-65
    80006326:	85ca                	mv	a1,s2
    80006328:	0b0a3503          	ld	a0,176(s4)
    8000632c:	ffffc097          	auipc	ra,0xffffc
    80006330:	cf0080e7          	jalr	-784(ra) # 8000201c <copyout>
    80006334:	01650763          	beq	a0,s6,80006342 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80006338:	2985                	addw	s3,s3,1
    8000633a:	0905                	add	s2,s2,1
    8000633c:	fd3a91e3          	bne	s5,s3,800062fe <piperead+0x86>
    80006340:	89d6                	mv	s3,s5
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80006342:	21c48513          	add	a0,s1,540
    80006346:	ffffd097          	auipc	ra,0xffffd
    8000634a:	d04080e7          	jalr	-764(ra) # 8000304a <wakeup>
  release(&pi->lock);
    8000634e:	8526                	mv	a0,s1
    80006350:	ffffb097          	auipc	ra,0xffffb
    80006354:	118080e7          	jalr	280(ra) # 80001468 <release>
    80006358:	6b42                	ld	s6,16(sp)
  return i;
}
    8000635a:	854e                	mv	a0,s3
    8000635c:	60a6                	ld	ra,72(sp)
    8000635e:	6406                	ld	s0,64(sp)
    80006360:	74e2                	ld	s1,56(sp)
    80006362:	7942                	ld	s2,48(sp)
    80006364:	79a2                	ld	s3,40(sp)
    80006366:	7a02                	ld	s4,32(sp)
    80006368:	6ae2                	ld	s5,24(sp)
    8000636a:	6161                	add	sp,sp,80
    8000636c:	8082                	ret

000000008000636e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000636e:	1141                	add	sp,sp,-16
    80006370:	e422                	sd	s0,8(sp)
    80006372:	0800                	add	s0,sp,16
    80006374:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80006376:	8905                	and	a0,a0,1
    80006378:	050e                	sll	a0,a0,0x3
      perm = PTE_X;
    if(flags & 0x2)
    8000637a:	8b89                	and	a5,a5,2
    8000637c:	c399                	beqz	a5,80006382 <flags2perm+0x14>
      perm |= PTE_W;
    8000637e:	00456513          	or	a0,a0,4
    return perm;
}
    80006382:	6422                	ld	s0,8(sp)
    80006384:	0141                	add	sp,sp,16
    80006386:	8082                	ret

0000000080006388 <exec>:

int
exec(char *path, char **argv)
{
    80006388:	de010113          	add	sp,sp,-544
    8000638c:	20113c23          	sd	ra,536(sp)
    80006390:	20813823          	sd	s0,528(sp)
    80006394:	20913423          	sd	s1,520(sp)
    80006398:	1400                	add	s0,sp,544
    8000639a:	84aa                	mv	s1,a0
    8000639c:	dea43823          	sd	a0,-528(s0)
    800063a0:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800063a4:	ffffc097          	auipc	ra,0xffffc
    800063a8:	fe0080e7          	jalr	-32(ra) # 80002384 <myproc>
    800063ac:	e0a43423          	sd	a0,-504(s0)

  begin_op();
    800063b0:	fffff097          	auipc	ra,0xfffff
    800063b4:	438080e7          	jalr	1080(ra) # 800057e8 <begin_op>

  if((ip = namei(path)) == 0){
    800063b8:	8526                	mv	a0,s1
    800063ba:	fffff097          	auipc	ra,0xfffff
    800063be:	22e080e7          	jalr	558(ra) # 800055e8 <namei>
    800063c2:	c135                	beqz	a0,80006426 <exec+0x9e>
    800063c4:	fbd2                	sd	s4,496(sp)
    800063c6:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800063c8:	fffff097          	auipc	ra,0xfffff
    800063cc:	a52080e7          	jalr	-1454(ra) # 80004e1a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800063d0:	04000713          	li	a4,64
    800063d4:	4681                	li	a3,0
    800063d6:	e5040613          	add	a2,s0,-432
    800063da:	4581                	li	a1,0
    800063dc:	8552                	mv	a0,s4
    800063de:	fffff097          	auipc	ra,0xfffff
    800063e2:	cf4080e7          	jalr	-780(ra) # 800050d2 <readi>
    800063e6:	04000793          	li	a5,64
    800063ea:	00f51a63          	bne	a0,a5,800063fe <exec+0x76>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800063ee:	e5042703          	lw	a4,-432(s0)
    800063f2:	464c47b7          	lui	a5,0x464c4
    800063f6:	57f78793          	add	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800063fa:	02f70c63          	beq	a4,a5,80006432 <exec+0xaa>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz, p);
  if(ip){
    iunlockput(ip);
    800063fe:	8552                	mv	a0,s4
    80006400:	fffff097          	auipc	ra,0xfffff
    80006404:	c80080e7          	jalr	-896(ra) # 80005080 <iunlockput>
    end_op();
    80006408:	fffff097          	auipc	ra,0xfffff
    8000640c:	45a080e7          	jalr	1114(ra) # 80005862 <end_op>
  }
  return -1;
    80006410:	557d                	li	a0,-1
    80006412:	7a5e                	ld	s4,496(sp)
}
    80006414:	21813083          	ld	ra,536(sp)
    80006418:	21013403          	ld	s0,528(sp)
    8000641c:	20813483          	ld	s1,520(sp)
    80006420:	22010113          	add	sp,sp,544
    80006424:	8082                	ret
    end_op();
    80006426:	fffff097          	auipc	ra,0xfffff
    8000642a:	43c080e7          	jalr	1084(ra) # 80005862 <end_op>
    return -1;
    8000642e:	557d                	li	a0,-1
    80006430:	b7d5                	j	80006414 <exec+0x8c>
    80006432:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80006434:	e0843503          	ld	a0,-504(s0)
    80006438:	ffffc097          	auipc	ra,0xffffc
    8000643c:	010080e7          	jalr	16(ra) # 80002448 <proc_pagetable>
    80006440:	8b2a                	mv	s6,a0
    80006442:	32050e63          	beqz	a0,8000677e <exec+0x3f6>
    80006446:	21213023          	sd	s2,512(sp)
    8000644a:	ffce                	sd	s3,504(sp)
    8000644c:	f7d6                	sd	s5,488(sp)
    8000644e:	efde                	sd	s7,472(sp)
    80006450:	ebe2                	sd	s8,464(sp)
    80006452:	e7e6                	sd	s9,456(sp)
    80006454:	e3ea                	sd	s10,448(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006456:	e7042d03          	lw	s10,-400(s0)
    8000645a:	e8845783          	lhu	a5,-376(s0)
    8000645e:	14078e63          	beqz	a5,800065ba <exec+0x232>
    80006462:	ff6e                	sd	s11,440(sp)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80006464:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80006466:	4d81                	li	s11,0
    if(ph.vaddr % PGSIZE != 0)
    80006468:	6c85                	lui	s9,0x1
    8000646a:	fffc8793          	add	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000646e:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80006472:	6a85                	lui	s5,0x1
    80006474:	a0b5                	j	800064e0 <exec+0x158>
      panic("loadseg: address should exist");
    80006476:	00003517          	auipc	a0,0x3
    8000647a:	3ca50513          	add	a0,a0,970 # 80009840 <etext+0x840>
    8000647e:	ffffa097          	auipc	ra,0xffffa
    80006482:	118080e7          	jalr	280(ra) # 80000596 <panic>
    if(sz - i < PGSIZE)
    80006486:	2481                	sext.w	s1,s1
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80006488:	8726                	mv	a4,s1
    8000648a:	012c06bb          	addw	a3,s8,s2
    8000648e:	4581                	li	a1,0
    80006490:	8552                	mv	a0,s4
    80006492:	fffff097          	auipc	ra,0xfffff
    80006496:	c40080e7          	jalr	-960(ra) # 800050d2 <readi>
    8000649a:	2501                	sext.w	a0,a0
    8000649c:	28a49f63          	bne	s1,a0,8000673a <exec+0x3b2>
  for(i = 0; i < sz; i += PGSIZE){
    800064a0:	012a893b          	addw	s2,s5,s2
    800064a4:	03397563          	bgeu	s2,s3,800064ce <exec+0x146>
    pa = walkaddr(pagetable, va + i);
    800064a8:	02091593          	sll	a1,s2,0x20
    800064ac:	9181                	srl	a1,a1,0x20
    800064ae:	95de                	add	a1,a1,s7
    800064b0:	855a                	mv	a0,s6
    800064b2:	ffffb097          	auipc	ra,0xffffb
    800064b6:	43c080e7          	jalr	1084(ra) # 800018ee <walkaddr>
    800064ba:	862a                	mv	a2,a0
    if(pa == 0)
    800064bc:	dd4d                	beqz	a0,80006476 <exec+0xee>
    if(sz - i < PGSIZE)
    800064be:	412984bb          	subw	s1,s3,s2
    800064c2:	0004879b          	sext.w	a5,s1
    800064c6:	fcfcf0e3          	bgeu	s9,a5,80006486 <exec+0xfe>
    800064ca:	84d6                	mv	s1,s5
    800064cc:	bf6d                	j	80006486 <exec+0xfe>
    sz = sz1;
    800064ce:	e0043903          	ld	s2,-512(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800064d2:	2d85                	addw	s11,s11,1
    800064d4:	038d0d1b          	addw	s10,s10,56
    800064d8:	e8845783          	lhu	a5,-376(s0)
    800064dc:	08fdd663          	bge	s11,a5,80006568 <exec+0x1e0>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800064e0:	2d01                	sext.w	s10,s10
    800064e2:	03800713          	li	a4,56
    800064e6:	86ea                	mv	a3,s10
    800064e8:	e1840613          	add	a2,s0,-488
    800064ec:	4581                	li	a1,0
    800064ee:	8552                	mv	a0,s4
    800064f0:	fffff097          	auipc	ra,0xfffff
    800064f4:	be2080e7          	jalr	-1054(ra) # 800050d2 <readi>
    800064f8:	03800793          	li	a5,56
    800064fc:	20f51763          	bne	a0,a5,8000670a <exec+0x382>
    if(ph.type != ELF_PROG_LOAD)
    80006500:	e1842783          	lw	a5,-488(s0)
    80006504:	4705                	li	a4,1
    80006506:	fce796e3          	bne	a5,a4,800064d2 <exec+0x14a>
    if(ph.memsz < ph.filesz)
    8000650a:	e4043483          	ld	s1,-448(s0)
    8000650e:	e3843783          	ld	a5,-456(s0)
    80006512:	20f4e063          	bltu	s1,a5,80006712 <exec+0x38a>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80006516:	e2843783          	ld	a5,-472(s0)
    8000651a:	94be                	add	s1,s1,a5
    8000651c:	1ef4ef63          	bltu	s1,a5,8000671a <exec+0x392>
    if(ph.vaddr % PGSIZE != 0)
    80006520:	de843703          	ld	a4,-536(s0)
    80006524:	8ff9                	and	a5,a5,a4
    80006526:	1e079e63          	bnez	a5,80006722 <exec+0x39a>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000652a:	e1c42503          	lw	a0,-484(s0)
    8000652e:	00000097          	auipc	ra,0x0
    80006532:	e40080e7          	jalr	-448(ra) # 8000636e <flags2perm>
    80006536:	86aa                	mv	a3,a0
    80006538:	8626                	mv	a2,s1
    8000653a:	85ca                	mv	a1,s2
    8000653c:	855a                	mv	a0,s6
    8000653e:	ffffc097          	auipc	ra,0xffffc
    80006542:	82c080e7          	jalr	-2004(ra) # 80001d6a <uvmalloc>
    80006546:	e0a43023          	sd	a0,-512(s0)
    8000654a:	1e050063          	beqz	a0,8000672a <exec+0x3a2>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000654e:	e2843b83          	ld	s7,-472(s0)
    80006552:	e2042c03          	lw	s8,-480(s0)
    80006556:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    8000655a:	00098463          	beqz	s3,80006562 <exec+0x1da>
    8000655e:	4901                	li	s2,0
    80006560:	b7a1                	j	800064a8 <exec+0x120>
    sz = sz1;
    80006562:	e0043903          	ld	s2,-512(s0)
    80006566:	b7b5                	j	800064d2 <exec+0x14a>
    80006568:	7dfa                	ld	s11,440(sp)
  iunlockput(ip);
    8000656a:	8552                	mv	a0,s4
    8000656c:	fffff097          	auipc	ra,0xfffff
    80006570:	b14080e7          	jalr	-1260(ra) # 80005080 <iunlockput>
  end_op();
    80006574:	fffff097          	auipc	ra,0xfffff
    80006578:	2ee080e7          	jalr	750(ra) # 80005862 <end_op>
  p = myproc();
    8000657c:	ffffc097          	auipc	ra,0xffffc
    80006580:	e08080e7          	jalr	-504(ra) # 80002384 <myproc>
    80006584:	e0a43423          	sd	a0,-504(s0)
  uint64 oldsz = p->sz;
    80006588:	0a853c03          	ld	s8,168(a0)
  sz = PGROUNDUP(sz);
    8000658c:	6985                	lui	s3,0x1
    8000658e:	19fd                	add	s3,s3,-1 # fff <_entry-0x7ffff001>
    80006590:	99ca                	add	s3,s3,s2
    80006592:	77fd                	lui	a5,0xfffff
    80006594:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80006598:	4691                	li	a3,4
    8000659a:	6609                	lui	a2,0x2
    8000659c:	964e                	add	a2,a2,s3
    8000659e:	85ce                	mv	a1,s3
    800065a0:	855a                	mv	a0,s6
    800065a2:	ffffb097          	auipc	ra,0xffffb
    800065a6:	7c8080e7          	jalr	1992(ra) # 80001d6a <uvmalloc>
    800065aa:	892a                	mv	s2,a0
    800065ac:	e0a43023          	sd	a0,-512(s0)
    800065b0:	e519                	bnez	a0,800065be <exec+0x236>
  if(pagetable)
    800065b2:	e1343023          	sd	s3,-512(s0)
    800065b6:	4a01                	li	s4,0
    800065b8:	a251                	j	8000673c <exec+0x3b4>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800065ba:	4901                	li	s2,0
    800065bc:	b77d                	j	8000656a <exec+0x1e2>
  uvmclear(pagetable, sz-2*PGSIZE);
    800065be:	75f9                	lui	a1,0xffffe
    800065c0:	95aa                	add	a1,a1,a0
    800065c2:	855a                	mv	a0,s6
    800065c4:	ffffc097          	auipc	ra,0xffffc
    800065c8:	a26080e7          	jalr	-1498(ra) # 80001fea <uvmclear>
  stackbase = sp - PGSIZE;
    800065cc:	7afd                	lui	s5,0xfffff
    800065ce:	9aca                	add	s5,s5,s2
  for(argc = 0; argv[argc]; argc++) {
    800065d0:	df843783          	ld	a5,-520(s0)
    800065d4:	6388                	ld	a0,0(a5)
    800065d6:	c52d                	beqz	a0,80006640 <exec+0x2b8>
    800065d8:	e9040993          	add	s3,s0,-368
    800065dc:	f9040b93          	add	s7,s0,-112
    800065e0:	4481                	li	s1,0
    sp -= strlen(argv[argc]) + 1;
    800065e2:	ffffb097          	auipc	ra,0xffffb
    800065e6:	042080e7          	jalr	66(ra) # 80001624 <strlen>
    800065ea:	0015079b          	addw	a5,a0,1
    800065ee:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800065f2:	ff07f913          	and	s2,a5,-16
    if(sp < stackbase)
    800065f6:	13596e63          	bltu	s2,s5,80006732 <exec+0x3aa>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800065fa:	df843c83          	ld	s9,-520(s0)
    800065fe:	000cba03          	ld	s4,0(s9)
    80006602:	8552                	mv	a0,s4
    80006604:	ffffb097          	auipc	ra,0xffffb
    80006608:	020080e7          	jalr	32(ra) # 80001624 <strlen>
    8000660c:	0015069b          	addw	a3,a0,1
    80006610:	8652                	mv	a2,s4
    80006612:	85ca                	mv	a1,s2
    80006614:	855a                	mv	a0,s6
    80006616:	ffffc097          	auipc	ra,0xffffc
    8000661a:	a06080e7          	jalr	-1530(ra) # 8000201c <copyout>
    8000661e:	10054c63          	bltz	a0,80006736 <exec+0x3ae>
    ustack[argc] = sp;
    80006622:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80006626:	0485                	add	s1,s1,1
    80006628:	008c8793          	add	a5,s9,8
    8000662c:	def43c23          	sd	a5,-520(s0)
    80006630:	008cb503          	ld	a0,8(s9)
    80006634:	c909                	beqz	a0,80006646 <exec+0x2be>
    if(argc >= MAXARG)
    80006636:	09a1                	add	s3,s3,8
    80006638:	fb7995e3          	bne	s3,s7,800065e2 <exec+0x25a>
  ip = 0;
    8000663c:	4a01                	li	s4,0
    8000663e:	a8fd                	j	8000673c <exec+0x3b4>
  sp = sz;
    80006640:	e0043903          	ld	s2,-512(s0)
  for(argc = 0; argv[argc]; argc++) {
    80006644:	4481                	li	s1,0
  ustack[argc] = 0;
    80006646:	00349793          	sll	a5,s1,0x3
    8000664a:	f9078793          	add	a5,a5,-112 # ffffffffffffef90 <end+0xffffffff7ffcaac0>
    8000664e:	97a2                	add	a5,a5,s0
    80006650:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80006654:	00148693          	add	a3,s1,1
    80006658:	068e                	sll	a3,a3,0x3
    8000665a:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000665e:	ff097913          	and	s2,s2,-16
  sz = sz1;
    80006662:	e0043983          	ld	s3,-512(s0)
  if(sp < stackbase)
    80006666:	f55966e3          	bltu	s2,s5,800065b2 <exec+0x22a>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000666a:	e9040613          	add	a2,s0,-368
    8000666e:	85ca                	mv	a1,s2
    80006670:	855a                	mv	a0,s6
    80006672:	ffffc097          	auipc	ra,0xffffc
    80006676:	9aa080e7          	jalr	-1622(ra) # 8000201c <copyout>
    8000667a:	10054463          	bltz	a0,80006782 <exec+0x3fa>
  p->trapframe->a1 = sp;
    8000667e:	e0843783          	ld	a5,-504(s0)
    80006682:	7fdc                	ld	a5,184(a5)
    80006684:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80006688:	df043783          	ld	a5,-528(s0)
    8000668c:	0007c703          	lbu	a4,0(a5)
    80006690:	cf11                	beqz	a4,800066ac <exec+0x324>
    80006692:	0785                	add	a5,a5,1
    if(*s == '/')
    80006694:	02f00693          	li	a3,47
    80006698:	a039                	j	800066a6 <exec+0x31e>
      last = s+1;
    8000669a:	def43823          	sd	a5,-528(s0)
  for(last=s=path; *s; s++)
    8000669e:	0785                	add	a5,a5,1
    800066a0:	fff7c703          	lbu	a4,-1(a5)
    800066a4:	c701                	beqz	a4,800066ac <exec+0x324>
    if(*s == '/')
    800066a6:	fed71ce3          	bne	a4,a3,8000669e <exec+0x316>
    800066aa:	bfc5                	j	8000669a <exec+0x312>
  safestrcpy(p->name, last, sizeof(p->name));
    800066ac:	4641                	li	a2,16
    800066ae:	df043583          	ld	a1,-528(s0)
    800066b2:	e0843983          	ld	s3,-504(s0)
    800066b6:	1b898513          	add	a0,s3,440
    800066ba:	ffffb097          	auipc	ra,0xffffb
    800066be:	f38080e7          	jalr	-200(ra) # 800015f2 <safestrcpy>
  oldpagetable = p->pagetable;
    800066c2:	864e                	mv	a2,s3
    800066c4:	0b09b503          	ld	a0,176(s3)
  p->pagetable = pagetable;
    800066c8:	0b69b823          	sd	s6,176(s3)
  p->sz = sz;
    800066cc:	e0043703          	ld	a4,-512(s0)
    800066d0:	0ae9b423          	sd	a4,168(s3)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800066d4:	0b89b783          	ld	a5,184(s3)
    800066d8:	e6843703          	ld	a4,-408(s0)
    800066dc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800066de:	0b89b783          	ld	a5,184(s3)
    800066e2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz, p);
    800066e6:	85e2                	mv	a1,s8
    800066e8:	ffffc097          	auipc	ra,0xffffc
    800066ec:	dfc080e7          	jalr	-516(ra) # 800024e4 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800066f0:	0004851b          	sext.w	a0,s1
    800066f4:	20013903          	ld	s2,512(sp)
    800066f8:	79fe                	ld	s3,504(sp)
    800066fa:	7a5e                	ld	s4,496(sp)
    800066fc:	7abe                	ld	s5,488(sp)
    800066fe:	7b1e                	ld	s6,480(sp)
    80006700:	6bfe                	ld	s7,472(sp)
    80006702:	6c5e                	ld	s8,464(sp)
    80006704:	6cbe                	ld	s9,456(sp)
    80006706:	6d1e                	ld	s10,448(sp)
    80006708:	b331                	j	80006414 <exec+0x8c>
    8000670a:	e1243023          	sd	s2,-512(s0)
    8000670e:	7dfa                	ld	s11,440(sp)
    80006710:	a035                	j	8000673c <exec+0x3b4>
    80006712:	e1243023          	sd	s2,-512(s0)
    80006716:	7dfa                	ld	s11,440(sp)
    80006718:	a015                	j	8000673c <exec+0x3b4>
    8000671a:	e1243023          	sd	s2,-512(s0)
    8000671e:	7dfa                	ld	s11,440(sp)
    80006720:	a831                	j	8000673c <exec+0x3b4>
    80006722:	e1243023          	sd	s2,-512(s0)
    80006726:	7dfa                	ld	s11,440(sp)
    80006728:	a811                	j	8000673c <exec+0x3b4>
    8000672a:	e1243023          	sd	s2,-512(s0)
    8000672e:	7dfa                	ld	s11,440(sp)
    80006730:	a031                	j	8000673c <exec+0x3b4>
  ip = 0;
    80006732:	4a01                	li	s4,0
    80006734:	a021                	j	8000673c <exec+0x3b4>
    80006736:	4a01                	li	s4,0
  if(pagetable)
    80006738:	a011                	j	8000673c <exec+0x3b4>
    8000673a:	7dfa                	ld	s11,440(sp)
    proc_freepagetable(pagetable, sz, p);
    8000673c:	e0843603          	ld	a2,-504(s0)
    80006740:	e0043583          	ld	a1,-512(s0)
    80006744:	855a                	mv	a0,s6
    80006746:	ffffc097          	auipc	ra,0xffffc
    8000674a:	d9e080e7          	jalr	-610(ra) # 800024e4 <proc_freepagetable>
  return -1;
    8000674e:	557d                	li	a0,-1
  if(ip){
    80006750:	000a1d63          	bnez	s4,8000676a <exec+0x3e2>
    80006754:	20013903          	ld	s2,512(sp)
    80006758:	79fe                	ld	s3,504(sp)
    8000675a:	7a5e                	ld	s4,496(sp)
    8000675c:	7abe                	ld	s5,488(sp)
    8000675e:	7b1e                	ld	s6,480(sp)
    80006760:	6bfe                	ld	s7,472(sp)
    80006762:	6c5e                	ld	s8,464(sp)
    80006764:	6cbe                	ld	s9,456(sp)
    80006766:	6d1e                	ld	s10,448(sp)
    80006768:	b175                	j	80006414 <exec+0x8c>
    8000676a:	20013903          	ld	s2,512(sp)
    8000676e:	79fe                	ld	s3,504(sp)
    80006770:	7abe                	ld	s5,488(sp)
    80006772:	7b1e                	ld	s6,480(sp)
    80006774:	6bfe                	ld	s7,472(sp)
    80006776:	6c5e                	ld	s8,464(sp)
    80006778:	6cbe                	ld	s9,456(sp)
    8000677a:	6d1e                	ld	s10,448(sp)
    8000677c:	b149                	j	800063fe <exec+0x76>
    8000677e:	7b1e                	ld	s6,480(sp)
    80006780:	b9bd                	j	800063fe <exec+0x76>
  sz = sz1;
    80006782:	e0043983          	ld	s3,-512(s0)
    80006786:	b535                	j	800065b2 <exec+0x22a>

0000000080006788 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80006788:	7179                	add	sp,sp,-48
    8000678a:	f406                	sd	ra,40(sp)
    8000678c:	f022                	sd	s0,32(sp)
    8000678e:	ec26                	sd	s1,24(sp)
    80006790:	e84a                	sd	s2,16(sp)
    80006792:	1800                	add	s0,sp,48
    80006794:	892e                	mv	s2,a1
    80006796:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80006798:	fdc40593          	add	a1,s0,-36
    8000679c:	ffffd097          	auipc	ra,0xffffd
    800067a0:	7a2080e7          	jalr	1954(ra) # 80003f3e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800067a4:	fdc42703          	lw	a4,-36(s0)
    800067a8:	47bd                	li	a5,15
    800067aa:	02e7eb63          	bltu	a5,a4,800067e0 <argfd+0x58>
    800067ae:	ffffc097          	auipc	ra,0xffffc
    800067b2:	bd6080e7          	jalr	-1066(ra) # 80002384 <myproc>
    800067b6:	fdc42703          	lw	a4,-36(s0)
    800067ba:	02670793          	add	a5,a4,38
    800067be:	078e                	sll	a5,a5,0x3
    800067c0:	953e                	add	a0,a0,a5
    800067c2:	611c                	ld	a5,0(a0)
    800067c4:	c385                	beqz	a5,800067e4 <argfd+0x5c>
    return -1;
  if(pfd)
    800067c6:	00090463          	beqz	s2,800067ce <argfd+0x46>
    *pfd = fd;
    800067ca:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800067ce:	4501                	li	a0,0
  if(pf)
    800067d0:	c091                	beqz	s1,800067d4 <argfd+0x4c>
    *pf = f;
    800067d2:	e09c                	sd	a5,0(s1)
}
    800067d4:	70a2                	ld	ra,40(sp)
    800067d6:	7402                	ld	s0,32(sp)
    800067d8:	64e2                	ld	s1,24(sp)
    800067da:	6942                	ld	s2,16(sp)
    800067dc:	6145                	add	sp,sp,48
    800067de:	8082                	ret
    return -1;
    800067e0:	557d                	li	a0,-1
    800067e2:	bfcd                	j	800067d4 <argfd+0x4c>
    800067e4:	557d                	li	a0,-1
    800067e6:	b7fd                	j	800067d4 <argfd+0x4c>

00000000800067e8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800067e8:	1101                	add	sp,sp,-32
    800067ea:	ec06                	sd	ra,24(sp)
    800067ec:	e822                	sd	s0,16(sp)
    800067ee:	e426                	sd	s1,8(sp)
    800067f0:	1000                	add	s0,sp,32
    800067f2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800067f4:	ffffc097          	auipc	ra,0xffffc
    800067f8:	b90080e7          	jalr	-1136(ra) # 80002384 <myproc>
    800067fc:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800067fe:	13050793          	add	a5,a0,304
    80006802:	4501                	li	a0,0
    80006804:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80006806:	6398                	ld	a4,0(a5)
    80006808:	cb19                	beqz	a4,8000681e <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    8000680a:	2505                	addw	a0,a0,1
    8000680c:	07a1                	add	a5,a5,8
    8000680e:	fed51ce3          	bne	a0,a3,80006806 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80006812:	557d                	li	a0,-1
}
    80006814:	60e2                	ld	ra,24(sp)
    80006816:	6442                	ld	s0,16(sp)
    80006818:	64a2                	ld	s1,8(sp)
    8000681a:	6105                	add	sp,sp,32
    8000681c:	8082                	ret
      p->ofile[fd] = f;
    8000681e:	02650793          	add	a5,a0,38
    80006822:	078e                	sll	a5,a5,0x3
    80006824:	963e                	add	a2,a2,a5
    80006826:	e204                	sd	s1,0(a2)
      return fd;
    80006828:	b7f5                	j	80006814 <fdalloc+0x2c>

000000008000682a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000682a:	715d                	add	sp,sp,-80
    8000682c:	e486                	sd	ra,72(sp)
    8000682e:	e0a2                	sd	s0,64(sp)
    80006830:	fc26                	sd	s1,56(sp)
    80006832:	f84a                	sd	s2,48(sp)
    80006834:	f44e                	sd	s3,40(sp)
    80006836:	ec56                	sd	s5,24(sp)
    80006838:	e85a                	sd	s6,16(sp)
    8000683a:	0880                	add	s0,sp,80
    8000683c:	8b2e                	mv	s6,a1
    8000683e:	89b2                	mv	s3,a2
    80006840:	8936                	mv	s2,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80006842:	fb040593          	add	a1,s0,-80
    80006846:	fffff097          	auipc	ra,0xfffff
    8000684a:	dc0080e7          	jalr	-576(ra) # 80005606 <nameiparent>
    8000684e:	84aa                	mv	s1,a0
    80006850:	14050e63          	beqz	a0,800069ac <create+0x182>
    return 0;

  ilock(dp);
    80006854:	ffffe097          	auipc	ra,0xffffe
    80006858:	5c6080e7          	jalr	1478(ra) # 80004e1a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000685c:	4601                	li	a2,0
    8000685e:	fb040593          	add	a1,s0,-80
    80006862:	8526                	mv	a0,s1
    80006864:	fffff097          	auipc	ra,0xfffff
    80006868:	ac2080e7          	jalr	-1342(ra) # 80005326 <dirlookup>
    8000686c:	8aaa                	mv	s5,a0
    8000686e:	c539                	beqz	a0,800068bc <create+0x92>
    iunlockput(dp);
    80006870:	8526                	mv	a0,s1
    80006872:	fffff097          	auipc	ra,0xfffff
    80006876:	80e080e7          	jalr	-2034(ra) # 80005080 <iunlockput>
    ilock(ip);
    8000687a:	8556                	mv	a0,s5
    8000687c:	ffffe097          	auipc	ra,0xffffe
    80006880:	59e080e7          	jalr	1438(ra) # 80004e1a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80006884:	4789                	li	a5,2
    80006886:	02fb1463          	bne	s6,a5,800068ae <create+0x84>
    8000688a:	044ad783          	lhu	a5,68(s5) # fffffffffffff044 <end+0xffffffff7ffcab74>
    8000688e:	37f9                	addw	a5,a5,-2
    80006890:	17c2                	sll	a5,a5,0x30
    80006892:	93c1                	srl	a5,a5,0x30
    80006894:	4705                	li	a4,1
    80006896:	00f76c63          	bltu	a4,a5,800068ae <create+0x84>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000689a:	8556                	mv	a0,s5
    8000689c:	60a6                	ld	ra,72(sp)
    8000689e:	6406                	ld	s0,64(sp)
    800068a0:	74e2                	ld	s1,56(sp)
    800068a2:	7942                	ld	s2,48(sp)
    800068a4:	79a2                	ld	s3,40(sp)
    800068a6:	6ae2                	ld	s5,24(sp)
    800068a8:	6b42                	ld	s6,16(sp)
    800068aa:	6161                	add	sp,sp,80
    800068ac:	8082                	ret
    iunlockput(ip);
    800068ae:	8556                	mv	a0,s5
    800068b0:	ffffe097          	auipc	ra,0xffffe
    800068b4:	7d0080e7          	jalr	2000(ra) # 80005080 <iunlockput>
    return 0;
    800068b8:	4a81                	li	s5,0
    800068ba:	b7c5                	j	8000689a <create+0x70>
    800068bc:	f052                	sd	s4,32(sp)
  if((ip = ialloc(dp->dev, type)) == 0){
    800068be:	85da                	mv	a1,s6
    800068c0:	4088                	lw	a0,0(s1)
    800068c2:	ffffe097          	auipc	ra,0xffffe
    800068c6:	3b4080e7          	jalr	948(ra) # 80004c76 <ialloc>
    800068ca:	8a2a                	mv	s4,a0
    800068cc:	c531                	beqz	a0,80006918 <create+0xee>
  ilock(ip);
    800068ce:	ffffe097          	auipc	ra,0xffffe
    800068d2:	54c080e7          	jalr	1356(ra) # 80004e1a <ilock>
  ip->major = major;
    800068d6:	053a1323          	sh	s3,70(s4)
  ip->minor = minor;
    800068da:	052a1423          	sh	s2,72(s4)
  ip->nlink = 1;
    800068de:	4905                	li	s2,1
    800068e0:	052a1523          	sh	s2,74(s4)
  iupdate(ip);
    800068e4:	8552                	mv	a0,s4
    800068e6:	ffffe097          	auipc	ra,0xffffe
    800068ea:	468080e7          	jalr	1128(ra) # 80004d4e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800068ee:	032b0d63          	beq	s6,s2,80006928 <create+0xfe>
  if(dirlink(dp, name, ip->inum) < 0)
    800068f2:	004a2603          	lw	a2,4(s4)
    800068f6:	fb040593          	add	a1,s0,-80
    800068fa:	8526                	mv	a0,s1
    800068fc:	fffff097          	auipc	ra,0xfffff
    80006900:	c3a080e7          	jalr	-966(ra) # 80005536 <dirlink>
    80006904:	08054163          	bltz	a0,80006986 <create+0x15c>
  iunlockput(dp);
    80006908:	8526                	mv	a0,s1
    8000690a:	ffffe097          	auipc	ra,0xffffe
    8000690e:	776080e7          	jalr	1910(ra) # 80005080 <iunlockput>
  return ip;
    80006912:	8ad2                	mv	s5,s4
    80006914:	7a02                	ld	s4,32(sp)
    80006916:	b751                	j	8000689a <create+0x70>
    iunlockput(dp);
    80006918:	8526                	mv	a0,s1
    8000691a:	ffffe097          	auipc	ra,0xffffe
    8000691e:	766080e7          	jalr	1894(ra) # 80005080 <iunlockput>
    return 0;
    80006922:	8ad2                	mv	s5,s4
    80006924:	7a02                	ld	s4,32(sp)
    80006926:	bf95                	j	8000689a <create+0x70>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80006928:	004a2603          	lw	a2,4(s4)
    8000692c:	00003597          	auipc	a1,0x3
    80006930:	f3458593          	add	a1,a1,-204 # 80009860 <etext+0x860>
    80006934:	8552                	mv	a0,s4
    80006936:	fffff097          	auipc	ra,0xfffff
    8000693a:	c00080e7          	jalr	-1024(ra) # 80005536 <dirlink>
    8000693e:	04054463          	bltz	a0,80006986 <create+0x15c>
    80006942:	40d0                	lw	a2,4(s1)
    80006944:	00003597          	auipc	a1,0x3
    80006948:	f2458593          	add	a1,a1,-220 # 80009868 <etext+0x868>
    8000694c:	8552                	mv	a0,s4
    8000694e:	fffff097          	auipc	ra,0xfffff
    80006952:	be8080e7          	jalr	-1048(ra) # 80005536 <dirlink>
    80006956:	02054863          	bltz	a0,80006986 <create+0x15c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000695a:	004a2603          	lw	a2,4(s4)
    8000695e:	fb040593          	add	a1,s0,-80
    80006962:	8526                	mv	a0,s1
    80006964:	fffff097          	auipc	ra,0xfffff
    80006968:	bd2080e7          	jalr	-1070(ra) # 80005536 <dirlink>
    8000696c:	00054d63          	bltz	a0,80006986 <create+0x15c>
    dp->nlink++;  // for ".."
    80006970:	04a4d783          	lhu	a5,74(s1)
    80006974:	2785                	addw	a5,a5,1
    80006976:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000697a:	8526                	mv	a0,s1
    8000697c:	ffffe097          	auipc	ra,0xffffe
    80006980:	3d2080e7          	jalr	978(ra) # 80004d4e <iupdate>
    80006984:	b751                	j	80006908 <create+0xde>
  ip->nlink = 0;
    80006986:	040a1523          	sh	zero,74(s4)
  iupdate(ip);
    8000698a:	8552                	mv	a0,s4
    8000698c:	ffffe097          	auipc	ra,0xffffe
    80006990:	3c2080e7          	jalr	962(ra) # 80004d4e <iupdate>
  iunlockput(ip);
    80006994:	8552                	mv	a0,s4
    80006996:	ffffe097          	auipc	ra,0xffffe
    8000699a:	6ea080e7          	jalr	1770(ra) # 80005080 <iunlockput>
  iunlockput(dp);
    8000699e:	8526                	mv	a0,s1
    800069a0:	ffffe097          	auipc	ra,0xffffe
    800069a4:	6e0080e7          	jalr	1760(ra) # 80005080 <iunlockput>
  return 0;
    800069a8:	7a02                	ld	s4,32(sp)
    800069aa:	bdc5                	j	8000689a <create+0x70>
    return 0;
    800069ac:	8aaa                	mv	s5,a0
    800069ae:	b5f5                	j	8000689a <create+0x70>

00000000800069b0 <sys_dup>:
{
    800069b0:	7179                	add	sp,sp,-48
    800069b2:	f406                	sd	ra,40(sp)
    800069b4:	f022                	sd	s0,32(sp)
    800069b6:	1800                	add	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800069b8:	fd840613          	add	a2,s0,-40
    800069bc:	4581                	li	a1,0
    800069be:	4501                	li	a0,0
    800069c0:	00000097          	auipc	ra,0x0
    800069c4:	dc8080e7          	jalr	-568(ra) # 80006788 <argfd>
    return -1;
    800069c8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800069ca:	02054763          	bltz	a0,800069f8 <sys_dup+0x48>
    800069ce:	ec26                	sd	s1,24(sp)
    800069d0:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800069d2:	fd843903          	ld	s2,-40(s0)
    800069d6:	854a                	mv	a0,s2
    800069d8:	00000097          	auipc	ra,0x0
    800069dc:	e10080e7          	jalr	-496(ra) # 800067e8 <fdalloc>
    800069e0:	84aa                	mv	s1,a0
    return -1;
    800069e2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800069e4:	00054f63          	bltz	a0,80006a02 <sys_dup+0x52>
  filedup(f);
    800069e8:	854a                	mv	a0,s2
    800069ea:	fffff097          	auipc	ra,0xfffff
    800069ee:	276080e7          	jalr	630(ra) # 80005c60 <filedup>
  return fd;
    800069f2:	87a6                	mv	a5,s1
    800069f4:	64e2                	ld	s1,24(sp)
    800069f6:	6942                	ld	s2,16(sp)
}
    800069f8:	853e                	mv	a0,a5
    800069fa:	70a2                	ld	ra,40(sp)
    800069fc:	7402                	ld	s0,32(sp)
    800069fe:	6145                	add	sp,sp,48
    80006a00:	8082                	ret
    80006a02:	64e2                	ld	s1,24(sp)
    80006a04:	6942                	ld	s2,16(sp)
    80006a06:	bfcd                	j	800069f8 <sys_dup+0x48>

0000000080006a08 <sys_read>:
{
    80006a08:	7179                	add	sp,sp,-48
    80006a0a:	f406                	sd	ra,40(sp)
    80006a0c:	f022                	sd	s0,32(sp)
    80006a0e:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80006a10:	fd840593          	add	a1,s0,-40
    80006a14:	4505                	li	a0,1
    80006a16:	ffffd097          	auipc	ra,0xffffd
    80006a1a:	548080e7          	jalr	1352(ra) # 80003f5e <argaddr>
  argint(2, &n);
    80006a1e:	fe440593          	add	a1,s0,-28
    80006a22:	4509                	li	a0,2
    80006a24:	ffffd097          	auipc	ra,0xffffd
    80006a28:	51a080e7          	jalr	1306(ra) # 80003f3e <argint>
  if(argfd(0, 0, &f) < 0)
    80006a2c:	fe840613          	add	a2,s0,-24
    80006a30:	4581                	li	a1,0
    80006a32:	4501                	li	a0,0
    80006a34:	00000097          	auipc	ra,0x0
    80006a38:	d54080e7          	jalr	-684(ra) # 80006788 <argfd>
    80006a3c:	87aa                	mv	a5,a0
    return -1;
    80006a3e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006a40:	0007cc63          	bltz	a5,80006a58 <sys_read+0x50>
  return fileread(f, p, n);
    80006a44:	fe442603          	lw	a2,-28(s0)
    80006a48:	fd843583          	ld	a1,-40(s0)
    80006a4c:	fe843503          	ld	a0,-24(s0)
    80006a50:	fffff097          	auipc	ra,0xfffff
    80006a54:	3b6080e7          	jalr	950(ra) # 80005e06 <fileread>
}
    80006a58:	70a2                	ld	ra,40(sp)
    80006a5a:	7402                	ld	s0,32(sp)
    80006a5c:	6145                	add	sp,sp,48
    80006a5e:	8082                	ret

0000000080006a60 <sys_write>:
{
    80006a60:	7179                	add	sp,sp,-48
    80006a62:	f406                	sd	ra,40(sp)
    80006a64:	f022                	sd	s0,32(sp)
    80006a66:	1800                	add	s0,sp,48
  argaddr(1, &p);
    80006a68:	fd840593          	add	a1,s0,-40
    80006a6c:	4505                	li	a0,1
    80006a6e:	ffffd097          	auipc	ra,0xffffd
    80006a72:	4f0080e7          	jalr	1264(ra) # 80003f5e <argaddr>
  argint(2, &n);
    80006a76:	fe440593          	add	a1,s0,-28
    80006a7a:	4509                	li	a0,2
    80006a7c:	ffffd097          	auipc	ra,0xffffd
    80006a80:	4c2080e7          	jalr	1218(ra) # 80003f3e <argint>
  if(argfd(0, 0, &f) < 0)
    80006a84:	fe840613          	add	a2,s0,-24
    80006a88:	4581                	li	a1,0
    80006a8a:	4501                	li	a0,0
    80006a8c:	00000097          	auipc	ra,0x0
    80006a90:	cfc080e7          	jalr	-772(ra) # 80006788 <argfd>
    80006a94:	87aa                	mv	a5,a0
    return -1;
    80006a96:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006a98:	0007cc63          	bltz	a5,80006ab0 <sys_write+0x50>
  return filewrite(f, p, n);
    80006a9c:	fe442603          	lw	a2,-28(s0)
    80006aa0:	fd843583          	ld	a1,-40(s0)
    80006aa4:	fe843503          	ld	a0,-24(s0)
    80006aa8:	fffff097          	auipc	ra,0xfffff
    80006aac:	430080e7          	jalr	1072(ra) # 80005ed8 <filewrite>
}
    80006ab0:	70a2                	ld	ra,40(sp)
    80006ab2:	7402                	ld	s0,32(sp)
    80006ab4:	6145                	add	sp,sp,48
    80006ab6:	8082                	ret

0000000080006ab8 <sys_close>:
{
    80006ab8:	1101                	add	sp,sp,-32
    80006aba:	ec06                	sd	ra,24(sp)
    80006abc:	e822                	sd	s0,16(sp)
    80006abe:	1000                	add	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80006ac0:	fe040613          	add	a2,s0,-32
    80006ac4:	fec40593          	add	a1,s0,-20
    80006ac8:	4501                	li	a0,0
    80006aca:	00000097          	auipc	ra,0x0
    80006ace:	cbe080e7          	jalr	-834(ra) # 80006788 <argfd>
    return -1;
    80006ad2:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80006ad4:	02054563          	bltz	a0,80006afe <sys_close+0x46>
  myproc()->ofile[fd] = 0;
    80006ad8:	ffffc097          	auipc	ra,0xffffc
    80006adc:	8ac080e7          	jalr	-1876(ra) # 80002384 <myproc>
    80006ae0:	fec42783          	lw	a5,-20(s0)
    80006ae4:	02678793          	add	a5,a5,38
    80006ae8:	078e                	sll	a5,a5,0x3
    80006aea:	953e                	add	a0,a0,a5
    80006aec:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80006af0:	fe043503          	ld	a0,-32(s0)
    80006af4:	fffff097          	auipc	ra,0xfffff
    80006af8:	1be080e7          	jalr	446(ra) # 80005cb2 <fileclose>
  return 0;
    80006afc:	4781                	li	a5,0
}
    80006afe:	853e                	mv	a0,a5
    80006b00:	60e2                	ld	ra,24(sp)
    80006b02:	6442                	ld	s0,16(sp)
    80006b04:	6105                	add	sp,sp,32
    80006b06:	8082                	ret

0000000080006b08 <sys_fstat>:
{
    80006b08:	1101                	add	sp,sp,-32
    80006b0a:	ec06                	sd	ra,24(sp)
    80006b0c:	e822                	sd	s0,16(sp)
    80006b0e:	1000                	add	s0,sp,32
  argaddr(1, &st);
    80006b10:	fe040593          	add	a1,s0,-32
    80006b14:	4505                	li	a0,1
    80006b16:	ffffd097          	auipc	ra,0xffffd
    80006b1a:	448080e7          	jalr	1096(ra) # 80003f5e <argaddr>
  if(argfd(0, 0, &f) < 0)
    80006b1e:	fe840613          	add	a2,s0,-24
    80006b22:	4581                	li	a1,0
    80006b24:	4501                	li	a0,0
    80006b26:	00000097          	auipc	ra,0x0
    80006b2a:	c62080e7          	jalr	-926(ra) # 80006788 <argfd>
    80006b2e:	87aa                	mv	a5,a0
    return -1;
    80006b30:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80006b32:	0007ca63          	bltz	a5,80006b46 <sys_fstat+0x3e>
  return filestat(f, st);
    80006b36:	fe043583          	ld	a1,-32(s0)
    80006b3a:	fe843503          	ld	a0,-24(s0)
    80006b3e:	fffff097          	auipc	ra,0xfffff
    80006b42:	256080e7          	jalr	598(ra) # 80005d94 <filestat>
}
    80006b46:	60e2                	ld	ra,24(sp)
    80006b48:	6442                	ld	s0,16(sp)
    80006b4a:	6105                	add	sp,sp,32
    80006b4c:	8082                	ret

0000000080006b4e <sys_link>:
{
    80006b4e:	7169                	add	sp,sp,-304
    80006b50:	f606                	sd	ra,296(sp)
    80006b52:	f222                	sd	s0,288(sp)
    80006b54:	1a00                	add	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006b56:	08000613          	li	a2,128
    80006b5a:	ed040593          	add	a1,s0,-304
    80006b5e:	4501                	li	a0,0
    80006b60:	ffffd097          	auipc	ra,0xffffd
    80006b64:	41e080e7          	jalr	1054(ra) # 80003f7e <argstr>
    return -1;
    80006b68:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006b6a:	12054663          	bltz	a0,80006c96 <sys_link+0x148>
    80006b6e:	08000613          	li	a2,128
    80006b72:	f5040593          	add	a1,s0,-176
    80006b76:	4505                	li	a0,1
    80006b78:	ffffd097          	auipc	ra,0xffffd
    80006b7c:	406080e7          	jalr	1030(ra) # 80003f7e <argstr>
    return -1;
    80006b80:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80006b82:	10054a63          	bltz	a0,80006c96 <sys_link+0x148>
    80006b86:	ee26                	sd	s1,280(sp)
  begin_op();
    80006b88:	fffff097          	auipc	ra,0xfffff
    80006b8c:	c60080e7          	jalr	-928(ra) # 800057e8 <begin_op>
  if((ip = namei(old)) == 0){
    80006b90:	ed040513          	add	a0,s0,-304
    80006b94:	fffff097          	auipc	ra,0xfffff
    80006b98:	a54080e7          	jalr	-1452(ra) # 800055e8 <namei>
    80006b9c:	84aa                	mv	s1,a0
    80006b9e:	c949                	beqz	a0,80006c30 <sys_link+0xe2>
  ilock(ip);
    80006ba0:	ffffe097          	auipc	ra,0xffffe
    80006ba4:	27a080e7          	jalr	634(ra) # 80004e1a <ilock>
  if(ip->type == T_DIR){
    80006ba8:	04449703          	lh	a4,68(s1)
    80006bac:	4785                	li	a5,1
    80006bae:	08f70863          	beq	a4,a5,80006c3e <sys_link+0xf0>
    80006bb2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80006bb4:	04a4d783          	lhu	a5,74(s1)
    80006bb8:	2785                	addw	a5,a5,1
    80006bba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006bbe:	8526                	mv	a0,s1
    80006bc0:	ffffe097          	auipc	ra,0xffffe
    80006bc4:	18e080e7          	jalr	398(ra) # 80004d4e <iupdate>
  iunlock(ip);
    80006bc8:	8526                	mv	a0,s1
    80006bca:	ffffe097          	auipc	ra,0xffffe
    80006bce:	316080e7          	jalr	790(ra) # 80004ee0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80006bd2:	fd040593          	add	a1,s0,-48
    80006bd6:	f5040513          	add	a0,s0,-176
    80006bda:	fffff097          	auipc	ra,0xfffff
    80006bde:	a2c080e7          	jalr	-1492(ra) # 80005606 <nameiparent>
    80006be2:	892a                	mv	s2,a0
    80006be4:	cd35                	beqz	a0,80006c60 <sys_link+0x112>
  ilock(dp);
    80006be6:	ffffe097          	auipc	ra,0xffffe
    80006bea:	234080e7          	jalr	564(ra) # 80004e1a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80006bee:	00092703          	lw	a4,0(s2)
    80006bf2:	409c                	lw	a5,0(s1)
    80006bf4:	06f71163          	bne	a4,a5,80006c56 <sys_link+0x108>
    80006bf8:	40d0                	lw	a2,4(s1)
    80006bfa:	fd040593          	add	a1,s0,-48
    80006bfe:	854a                	mv	a0,s2
    80006c00:	fffff097          	auipc	ra,0xfffff
    80006c04:	936080e7          	jalr	-1738(ra) # 80005536 <dirlink>
    80006c08:	04054763          	bltz	a0,80006c56 <sys_link+0x108>
  iunlockput(dp);
    80006c0c:	854a                	mv	a0,s2
    80006c0e:	ffffe097          	auipc	ra,0xffffe
    80006c12:	472080e7          	jalr	1138(ra) # 80005080 <iunlockput>
  iput(ip);
    80006c16:	8526                	mv	a0,s1
    80006c18:	ffffe097          	auipc	ra,0xffffe
    80006c1c:	3c0080e7          	jalr	960(ra) # 80004fd8 <iput>
  end_op();
    80006c20:	fffff097          	auipc	ra,0xfffff
    80006c24:	c42080e7          	jalr	-958(ra) # 80005862 <end_op>
  return 0;
    80006c28:	4781                	li	a5,0
    80006c2a:	64f2                	ld	s1,280(sp)
    80006c2c:	6952                	ld	s2,272(sp)
    80006c2e:	a0a5                	j	80006c96 <sys_link+0x148>
    end_op();
    80006c30:	fffff097          	auipc	ra,0xfffff
    80006c34:	c32080e7          	jalr	-974(ra) # 80005862 <end_op>
    return -1;
    80006c38:	57fd                	li	a5,-1
    80006c3a:	64f2                	ld	s1,280(sp)
    80006c3c:	a8a9                	j	80006c96 <sys_link+0x148>
    iunlockput(ip);
    80006c3e:	8526                	mv	a0,s1
    80006c40:	ffffe097          	auipc	ra,0xffffe
    80006c44:	440080e7          	jalr	1088(ra) # 80005080 <iunlockput>
    end_op();
    80006c48:	fffff097          	auipc	ra,0xfffff
    80006c4c:	c1a080e7          	jalr	-998(ra) # 80005862 <end_op>
    return -1;
    80006c50:	57fd                	li	a5,-1
    80006c52:	64f2                	ld	s1,280(sp)
    80006c54:	a089                	j	80006c96 <sys_link+0x148>
    iunlockput(dp);
    80006c56:	854a                	mv	a0,s2
    80006c58:	ffffe097          	auipc	ra,0xffffe
    80006c5c:	428080e7          	jalr	1064(ra) # 80005080 <iunlockput>
  ilock(ip);
    80006c60:	8526                	mv	a0,s1
    80006c62:	ffffe097          	auipc	ra,0xffffe
    80006c66:	1b8080e7          	jalr	440(ra) # 80004e1a <ilock>
  ip->nlink--;
    80006c6a:	04a4d783          	lhu	a5,74(s1)
    80006c6e:	37fd                	addw	a5,a5,-1
    80006c70:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80006c74:	8526                	mv	a0,s1
    80006c76:	ffffe097          	auipc	ra,0xffffe
    80006c7a:	0d8080e7          	jalr	216(ra) # 80004d4e <iupdate>
  iunlockput(ip);
    80006c7e:	8526                	mv	a0,s1
    80006c80:	ffffe097          	auipc	ra,0xffffe
    80006c84:	400080e7          	jalr	1024(ra) # 80005080 <iunlockput>
  end_op();
    80006c88:	fffff097          	auipc	ra,0xfffff
    80006c8c:	bda080e7          	jalr	-1062(ra) # 80005862 <end_op>
  return -1;
    80006c90:	57fd                	li	a5,-1
    80006c92:	64f2                	ld	s1,280(sp)
    80006c94:	6952                	ld	s2,272(sp)
}
    80006c96:	853e                	mv	a0,a5
    80006c98:	70b2                	ld	ra,296(sp)
    80006c9a:	7412                	ld	s0,288(sp)
    80006c9c:	6155                	add	sp,sp,304
    80006c9e:	8082                	ret

0000000080006ca0 <sys_unlink>:
{
    80006ca0:	7151                	add	sp,sp,-240
    80006ca2:	f586                	sd	ra,232(sp)
    80006ca4:	f1a2                	sd	s0,224(sp)
    80006ca6:	1980                	add	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80006ca8:	08000613          	li	a2,128
    80006cac:	f3040593          	add	a1,s0,-208
    80006cb0:	4501                	li	a0,0
    80006cb2:	ffffd097          	auipc	ra,0xffffd
    80006cb6:	2cc080e7          	jalr	716(ra) # 80003f7e <argstr>
    80006cba:	1a054a63          	bltz	a0,80006e6e <sys_unlink+0x1ce>
    80006cbe:	eda6                	sd	s1,216(sp)
  begin_op();
    80006cc0:	fffff097          	auipc	ra,0xfffff
    80006cc4:	b28080e7          	jalr	-1240(ra) # 800057e8 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80006cc8:	fb040593          	add	a1,s0,-80
    80006ccc:	f3040513          	add	a0,s0,-208
    80006cd0:	fffff097          	auipc	ra,0xfffff
    80006cd4:	936080e7          	jalr	-1738(ra) # 80005606 <nameiparent>
    80006cd8:	84aa                	mv	s1,a0
    80006cda:	cd71                	beqz	a0,80006db6 <sys_unlink+0x116>
  ilock(dp);
    80006cdc:	ffffe097          	auipc	ra,0xffffe
    80006ce0:	13e080e7          	jalr	318(ra) # 80004e1a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80006ce4:	00003597          	auipc	a1,0x3
    80006ce8:	b7c58593          	add	a1,a1,-1156 # 80009860 <etext+0x860>
    80006cec:	fb040513          	add	a0,s0,-80
    80006cf0:	ffffe097          	auipc	ra,0xffffe
    80006cf4:	61c080e7          	jalr	1564(ra) # 8000530c <namecmp>
    80006cf8:	14050c63          	beqz	a0,80006e50 <sys_unlink+0x1b0>
    80006cfc:	00003597          	auipc	a1,0x3
    80006d00:	b6c58593          	add	a1,a1,-1172 # 80009868 <etext+0x868>
    80006d04:	fb040513          	add	a0,s0,-80
    80006d08:	ffffe097          	auipc	ra,0xffffe
    80006d0c:	604080e7          	jalr	1540(ra) # 8000530c <namecmp>
    80006d10:	14050063          	beqz	a0,80006e50 <sys_unlink+0x1b0>
    80006d14:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80006d16:	f2c40613          	add	a2,s0,-212
    80006d1a:	fb040593          	add	a1,s0,-80
    80006d1e:	8526                	mv	a0,s1
    80006d20:	ffffe097          	auipc	ra,0xffffe
    80006d24:	606080e7          	jalr	1542(ra) # 80005326 <dirlookup>
    80006d28:	892a                	mv	s2,a0
    80006d2a:	12050263          	beqz	a0,80006e4e <sys_unlink+0x1ae>
  ilock(ip);
    80006d2e:	ffffe097          	auipc	ra,0xffffe
    80006d32:	0ec080e7          	jalr	236(ra) # 80004e1a <ilock>
  if(ip->nlink < 1)
    80006d36:	04a91783          	lh	a5,74(s2)
    80006d3a:	08f05563          	blez	a5,80006dc4 <sys_unlink+0x124>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80006d3e:	04491703          	lh	a4,68(s2)
    80006d42:	4785                	li	a5,1
    80006d44:	08f70963          	beq	a4,a5,80006dd6 <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    80006d48:	4641                	li	a2,16
    80006d4a:	4581                	li	a1,0
    80006d4c:	fc040513          	add	a0,s0,-64
    80006d50:	ffffa097          	auipc	ra,0xffffa
    80006d54:	760080e7          	jalr	1888(ra) # 800014b0 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006d58:	4741                	li	a4,16
    80006d5a:	f2c42683          	lw	a3,-212(s0)
    80006d5e:	fc040613          	add	a2,s0,-64
    80006d62:	4581                	li	a1,0
    80006d64:	8526                	mv	a0,s1
    80006d66:	ffffe097          	auipc	ra,0xffffe
    80006d6a:	47c080e7          	jalr	1148(ra) # 800051e2 <writei>
    80006d6e:	47c1                	li	a5,16
    80006d70:	0af51b63          	bne	a0,a5,80006e26 <sys_unlink+0x186>
  if(ip->type == T_DIR){
    80006d74:	04491703          	lh	a4,68(s2)
    80006d78:	4785                	li	a5,1
    80006d7a:	0af70f63          	beq	a4,a5,80006e38 <sys_unlink+0x198>
  iunlockput(dp);
    80006d7e:	8526                	mv	a0,s1
    80006d80:	ffffe097          	auipc	ra,0xffffe
    80006d84:	300080e7          	jalr	768(ra) # 80005080 <iunlockput>
  ip->nlink--;
    80006d88:	04a95783          	lhu	a5,74(s2)
    80006d8c:	37fd                	addw	a5,a5,-1
    80006d8e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80006d92:	854a                	mv	a0,s2
    80006d94:	ffffe097          	auipc	ra,0xffffe
    80006d98:	fba080e7          	jalr	-70(ra) # 80004d4e <iupdate>
  iunlockput(ip);
    80006d9c:	854a                	mv	a0,s2
    80006d9e:	ffffe097          	auipc	ra,0xffffe
    80006da2:	2e2080e7          	jalr	738(ra) # 80005080 <iunlockput>
  end_op();
    80006da6:	fffff097          	auipc	ra,0xfffff
    80006daa:	abc080e7          	jalr	-1348(ra) # 80005862 <end_op>
  return 0;
    80006dae:	4501                	li	a0,0
    80006db0:	64ee                	ld	s1,216(sp)
    80006db2:	694e                	ld	s2,208(sp)
    80006db4:	a84d                	j	80006e66 <sys_unlink+0x1c6>
    end_op();
    80006db6:	fffff097          	auipc	ra,0xfffff
    80006dba:	aac080e7          	jalr	-1364(ra) # 80005862 <end_op>
    return -1;
    80006dbe:	557d                	li	a0,-1
    80006dc0:	64ee                	ld	s1,216(sp)
    80006dc2:	a055                	j	80006e66 <sys_unlink+0x1c6>
    80006dc4:	e5ce                	sd	s3,200(sp)
    panic("unlink: nlink < 1");
    80006dc6:	00003517          	auipc	a0,0x3
    80006dca:	aaa50513          	add	a0,a0,-1366 # 80009870 <etext+0x870>
    80006dce:	ffff9097          	auipc	ra,0xffff9
    80006dd2:	7c8080e7          	jalr	1992(ra) # 80000596 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006dd6:	04c92703          	lw	a4,76(s2)
    80006dda:	02000793          	li	a5,32
    80006dde:	f6e7f5e3          	bgeu	a5,a4,80006d48 <sys_unlink+0xa8>
    80006de2:	e5ce                	sd	s3,200(sp)
    80006de4:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80006de8:	4741                	li	a4,16
    80006dea:	86ce                	mv	a3,s3
    80006dec:	f1840613          	add	a2,s0,-232
    80006df0:	4581                	li	a1,0
    80006df2:	854a                	mv	a0,s2
    80006df4:	ffffe097          	auipc	ra,0xffffe
    80006df8:	2de080e7          	jalr	734(ra) # 800050d2 <readi>
    80006dfc:	47c1                	li	a5,16
    80006dfe:	00f51c63          	bne	a0,a5,80006e16 <sys_unlink+0x176>
    if(de.inum != 0)
    80006e02:	f1845783          	lhu	a5,-232(s0)
    80006e06:	e7b5                	bnez	a5,80006e72 <sys_unlink+0x1d2>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80006e08:	29c1                	addw	s3,s3,16
    80006e0a:	04c92783          	lw	a5,76(s2)
    80006e0e:	fcf9ede3          	bltu	s3,a5,80006de8 <sys_unlink+0x148>
    80006e12:	69ae                	ld	s3,200(sp)
    80006e14:	bf15                	j	80006d48 <sys_unlink+0xa8>
      panic("isdirempty: readi");
    80006e16:	00003517          	auipc	a0,0x3
    80006e1a:	a7250513          	add	a0,a0,-1422 # 80009888 <etext+0x888>
    80006e1e:	ffff9097          	auipc	ra,0xffff9
    80006e22:	778080e7          	jalr	1912(ra) # 80000596 <panic>
    80006e26:	e5ce                	sd	s3,200(sp)
    panic("unlink: writei");
    80006e28:	00003517          	auipc	a0,0x3
    80006e2c:	a7850513          	add	a0,a0,-1416 # 800098a0 <etext+0x8a0>
    80006e30:	ffff9097          	auipc	ra,0xffff9
    80006e34:	766080e7          	jalr	1894(ra) # 80000596 <panic>
    dp->nlink--;
    80006e38:	04a4d783          	lhu	a5,74(s1)
    80006e3c:	37fd                	addw	a5,a5,-1
    80006e3e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80006e42:	8526                	mv	a0,s1
    80006e44:	ffffe097          	auipc	ra,0xffffe
    80006e48:	f0a080e7          	jalr	-246(ra) # 80004d4e <iupdate>
    80006e4c:	bf0d                	j	80006d7e <sys_unlink+0xde>
    80006e4e:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80006e50:	8526                	mv	a0,s1
    80006e52:	ffffe097          	auipc	ra,0xffffe
    80006e56:	22e080e7          	jalr	558(ra) # 80005080 <iunlockput>
  end_op();
    80006e5a:	fffff097          	auipc	ra,0xfffff
    80006e5e:	a08080e7          	jalr	-1528(ra) # 80005862 <end_op>
  return -1;
    80006e62:	557d                	li	a0,-1
    80006e64:	64ee                	ld	s1,216(sp)
}
    80006e66:	70ae                	ld	ra,232(sp)
    80006e68:	740e                	ld	s0,224(sp)
    80006e6a:	616d                	add	sp,sp,240
    80006e6c:	8082                	ret
    return -1;
    80006e6e:	557d                	li	a0,-1
    80006e70:	bfdd                	j	80006e66 <sys_unlink+0x1c6>
    iunlockput(ip);
    80006e72:	854a                	mv	a0,s2
    80006e74:	ffffe097          	auipc	ra,0xffffe
    80006e78:	20c080e7          	jalr	524(ra) # 80005080 <iunlockput>
    goto bad;
    80006e7c:	694e                	ld	s2,208(sp)
    80006e7e:	69ae                	ld	s3,200(sp)
    80006e80:	bfc1                	j	80006e50 <sys_unlink+0x1b0>

0000000080006e82 <sys_open>:

uint64
sys_open(void)
{
    80006e82:	7131                	add	sp,sp,-192
    80006e84:	fd06                	sd	ra,184(sp)
    80006e86:	f922                	sd	s0,176(sp)
    80006e88:	0180                	add	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80006e8a:	f4c40593          	add	a1,s0,-180
    80006e8e:	4505                	li	a0,1
    80006e90:	ffffd097          	auipc	ra,0xffffd
    80006e94:	0ae080e7          	jalr	174(ra) # 80003f3e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006e98:	08000613          	li	a2,128
    80006e9c:	f5040593          	add	a1,s0,-176
    80006ea0:	4501                	li	a0,0
    80006ea2:	ffffd097          	auipc	ra,0xffffd
    80006ea6:	0dc080e7          	jalr	220(ra) # 80003f7e <argstr>
    80006eaa:	87aa                	mv	a5,a0
    return -1;
    80006eac:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80006eae:	0a07ce63          	bltz	a5,80006f6a <sys_open+0xe8>
    80006eb2:	f526                	sd	s1,168(sp)

  begin_op();
    80006eb4:	fffff097          	auipc	ra,0xfffff
    80006eb8:	934080e7          	jalr	-1740(ra) # 800057e8 <begin_op>

  if(omode & O_CREATE){
    80006ebc:	f4c42783          	lw	a5,-180(s0)
    80006ec0:	2007f793          	and	a5,a5,512
    80006ec4:	cfd5                	beqz	a5,80006f80 <sys_open+0xfe>
    ip = create(path, T_FILE, 0, 0);
    80006ec6:	4681                	li	a3,0
    80006ec8:	4601                	li	a2,0
    80006eca:	4589                	li	a1,2
    80006ecc:	f5040513          	add	a0,s0,-176
    80006ed0:	00000097          	auipc	ra,0x0
    80006ed4:	95a080e7          	jalr	-1702(ra) # 8000682a <create>
    80006ed8:	84aa                	mv	s1,a0
    if(ip == 0){
    80006eda:	cd41                	beqz	a0,80006f72 <sys_open+0xf0>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80006edc:	04449703          	lh	a4,68(s1)
    80006ee0:	478d                	li	a5,3
    80006ee2:	00f71763          	bne	a4,a5,80006ef0 <sys_open+0x6e>
    80006ee6:	0464d703          	lhu	a4,70(s1)
    80006eea:	47a5                	li	a5,9
    80006eec:	0ee7e163          	bltu	a5,a4,80006fce <sys_open+0x14c>
    80006ef0:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80006ef2:	fffff097          	auipc	ra,0xfffff
    80006ef6:	d04080e7          	jalr	-764(ra) # 80005bf6 <filealloc>
    80006efa:	892a                	mv	s2,a0
    80006efc:	c97d                	beqz	a0,80006ff2 <sys_open+0x170>
    80006efe:	ed4e                	sd	s3,152(sp)
    80006f00:	00000097          	auipc	ra,0x0
    80006f04:	8e8080e7          	jalr	-1816(ra) # 800067e8 <fdalloc>
    80006f08:	89aa                	mv	s3,a0
    80006f0a:	0c054e63          	bltz	a0,80006fe6 <sys_open+0x164>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80006f0e:	04449703          	lh	a4,68(s1)
    80006f12:	478d                	li	a5,3
    80006f14:	0ef70c63          	beq	a4,a5,8000700c <sys_open+0x18a>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80006f18:	4789                	li	a5,2
    80006f1a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80006f1e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80006f22:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80006f26:	f4c42783          	lw	a5,-180(s0)
    80006f2a:	0017c713          	xor	a4,a5,1
    80006f2e:	8b05                	and	a4,a4,1
    80006f30:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80006f34:	0037f713          	and	a4,a5,3
    80006f38:	00e03733          	snez	a4,a4
    80006f3c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80006f40:	4007f793          	and	a5,a5,1024
    80006f44:	c791                	beqz	a5,80006f50 <sys_open+0xce>
    80006f46:	04449703          	lh	a4,68(s1)
    80006f4a:	4789                	li	a5,2
    80006f4c:	0cf70763          	beq	a4,a5,8000701a <sys_open+0x198>
    itrunc(ip);
  }

  iunlock(ip);
    80006f50:	8526                	mv	a0,s1
    80006f52:	ffffe097          	auipc	ra,0xffffe
    80006f56:	f8e080e7          	jalr	-114(ra) # 80004ee0 <iunlock>
  end_op();
    80006f5a:	fffff097          	auipc	ra,0xfffff
    80006f5e:	908080e7          	jalr	-1784(ra) # 80005862 <end_op>

  return fd;
    80006f62:	854e                	mv	a0,s3
    80006f64:	74aa                	ld	s1,168(sp)
    80006f66:	790a                	ld	s2,160(sp)
    80006f68:	69ea                	ld	s3,152(sp)
}
    80006f6a:	70ea                	ld	ra,184(sp)
    80006f6c:	744a                	ld	s0,176(sp)
    80006f6e:	6129                	add	sp,sp,192
    80006f70:	8082                	ret
      end_op();
    80006f72:	fffff097          	auipc	ra,0xfffff
    80006f76:	8f0080e7          	jalr	-1808(ra) # 80005862 <end_op>
      return -1;
    80006f7a:	557d                	li	a0,-1
    80006f7c:	74aa                	ld	s1,168(sp)
    80006f7e:	b7f5                	j	80006f6a <sys_open+0xe8>
    if((ip = namei(path)) == 0){
    80006f80:	f5040513          	add	a0,s0,-176
    80006f84:	ffffe097          	auipc	ra,0xffffe
    80006f88:	664080e7          	jalr	1636(ra) # 800055e8 <namei>
    80006f8c:	84aa                	mv	s1,a0
    80006f8e:	c90d                	beqz	a0,80006fc0 <sys_open+0x13e>
    ilock(ip);
    80006f90:	ffffe097          	auipc	ra,0xffffe
    80006f94:	e8a080e7          	jalr	-374(ra) # 80004e1a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80006f98:	04449703          	lh	a4,68(s1)
    80006f9c:	4785                	li	a5,1
    80006f9e:	f2f71fe3          	bne	a4,a5,80006edc <sys_open+0x5a>
    80006fa2:	f4c42783          	lw	a5,-180(s0)
    80006fa6:	d7a9                	beqz	a5,80006ef0 <sys_open+0x6e>
      iunlockput(ip);
    80006fa8:	8526                	mv	a0,s1
    80006faa:	ffffe097          	auipc	ra,0xffffe
    80006fae:	0d6080e7          	jalr	214(ra) # 80005080 <iunlockput>
      end_op();
    80006fb2:	fffff097          	auipc	ra,0xfffff
    80006fb6:	8b0080e7          	jalr	-1872(ra) # 80005862 <end_op>
      return -1;
    80006fba:	557d                	li	a0,-1
    80006fbc:	74aa                	ld	s1,168(sp)
    80006fbe:	b775                	j	80006f6a <sys_open+0xe8>
      end_op();
    80006fc0:	fffff097          	auipc	ra,0xfffff
    80006fc4:	8a2080e7          	jalr	-1886(ra) # 80005862 <end_op>
      return -1;
    80006fc8:	557d                	li	a0,-1
    80006fca:	74aa                	ld	s1,168(sp)
    80006fcc:	bf79                	j	80006f6a <sys_open+0xe8>
    iunlockput(ip);
    80006fce:	8526                	mv	a0,s1
    80006fd0:	ffffe097          	auipc	ra,0xffffe
    80006fd4:	0b0080e7          	jalr	176(ra) # 80005080 <iunlockput>
    end_op();
    80006fd8:	fffff097          	auipc	ra,0xfffff
    80006fdc:	88a080e7          	jalr	-1910(ra) # 80005862 <end_op>
    return -1;
    80006fe0:	557d                	li	a0,-1
    80006fe2:	74aa                	ld	s1,168(sp)
    80006fe4:	b759                	j	80006f6a <sys_open+0xe8>
      fileclose(f);
    80006fe6:	854a                	mv	a0,s2
    80006fe8:	fffff097          	auipc	ra,0xfffff
    80006fec:	cca080e7          	jalr	-822(ra) # 80005cb2 <fileclose>
    80006ff0:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80006ff2:	8526                	mv	a0,s1
    80006ff4:	ffffe097          	auipc	ra,0xffffe
    80006ff8:	08c080e7          	jalr	140(ra) # 80005080 <iunlockput>
    end_op();
    80006ffc:	fffff097          	auipc	ra,0xfffff
    80007000:	866080e7          	jalr	-1946(ra) # 80005862 <end_op>
    return -1;
    80007004:	557d                	li	a0,-1
    80007006:	74aa                	ld	s1,168(sp)
    80007008:	790a                	ld	s2,160(sp)
    8000700a:	b785                	j	80006f6a <sys_open+0xe8>
    f->type = FD_DEVICE;
    8000700c:	00f92023          	sw	a5,0(s2)
    f->major = ip->major;
    80007010:	04649783          	lh	a5,70(s1)
    80007014:	02f91223          	sh	a5,36(s2)
    80007018:	b729                	j	80006f22 <sys_open+0xa0>
    itrunc(ip);
    8000701a:	8526                	mv	a0,s1
    8000701c:	ffffe097          	auipc	ra,0xffffe
    80007020:	f10080e7          	jalr	-240(ra) # 80004f2c <itrunc>
    80007024:	b735                	j	80006f50 <sys_open+0xce>

0000000080007026 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80007026:	7175                	add	sp,sp,-144
    80007028:	e506                	sd	ra,136(sp)
    8000702a:	e122                	sd	s0,128(sp)
    8000702c:	0900                	add	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000702e:	ffffe097          	auipc	ra,0xffffe
    80007032:	7ba080e7          	jalr	1978(ra) # 800057e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80007036:	08000613          	li	a2,128
    8000703a:	f7040593          	add	a1,s0,-144
    8000703e:	4501                	li	a0,0
    80007040:	ffffd097          	auipc	ra,0xffffd
    80007044:	f3e080e7          	jalr	-194(ra) # 80003f7e <argstr>
    80007048:	02054963          	bltz	a0,8000707a <sys_mkdir+0x54>
    8000704c:	4681                	li	a3,0
    8000704e:	4601                	li	a2,0
    80007050:	4585                	li	a1,1
    80007052:	f7040513          	add	a0,s0,-144
    80007056:	fffff097          	auipc	ra,0xfffff
    8000705a:	7d4080e7          	jalr	2004(ra) # 8000682a <create>
    8000705e:	cd11                	beqz	a0,8000707a <sys_mkdir+0x54>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80007060:	ffffe097          	auipc	ra,0xffffe
    80007064:	020080e7          	jalr	32(ra) # 80005080 <iunlockput>
  end_op();
    80007068:	ffffe097          	auipc	ra,0xffffe
    8000706c:	7fa080e7          	jalr	2042(ra) # 80005862 <end_op>
  return 0;
    80007070:	4501                	li	a0,0
}
    80007072:	60aa                	ld	ra,136(sp)
    80007074:	640a                	ld	s0,128(sp)
    80007076:	6149                	add	sp,sp,144
    80007078:	8082                	ret
    end_op();
    8000707a:	ffffe097          	auipc	ra,0xffffe
    8000707e:	7e8080e7          	jalr	2024(ra) # 80005862 <end_op>
    return -1;
    80007082:	557d                	li	a0,-1
    80007084:	b7fd                	j	80007072 <sys_mkdir+0x4c>

0000000080007086 <sys_mknod>:

uint64
sys_mknod(void)
{
    80007086:	7135                	add	sp,sp,-160
    80007088:	ed06                	sd	ra,152(sp)
    8000708a:	e922                	sd	s0,144(sp)
    8000708c:	1100                	add	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000708e:	ffffe097          	auipc	ra,0xffffe
    80007092:	75a080e7          	jalr	1882(ra) # 800057e8 <begin_op>
  argint(1, &major);
    80007096:	f6c40593          	add	a1,s0,-148
    8000709a:	4505                	li	a0,1
    8000709c:	ffffd097          	auipc	ra,0xffffd
    800070a0:	ea2080e7          	jalr	-350(ra) # 80003f3e <argint>
  argint(2, &minor);
    800070a4:	f6840593          	add	a1,s0,-152
    800070a8:	4509                	li	a0,2
    800070aa:	ffffd097          	auipc	ra,0xffffd
    800070ae:	e94080e7          	jalr	-364(ra) # 80003f3e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800070b2:	08000613          	li	a2,128
    800070b6:	f7040593          	add	a1,s0,-144
    800070ba:	4501                	li	a0,0
    800070bc:	ffffd097          	auipc	ra,0xffffd
    800070c0:	ec2080e7          	jalr	-318(ra) # 80003f7e <argstr>
    800070c4:	02054b63          	bltz	a0,800070fa <sys_mknod+0x74>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800070c8:	f6841683          	lh	a3,-152(s0)
    800070cc:	f6c41603          	lh	a2,-148(s0)
    800070d0:	458d                	li	a1,3
    800070d2:	f7040513          	add	a0,s0,-144
    800070d6:	fffff097          	auipc	ra,0xfffff
    800070da:	754080e7          	jalr	1876(ra) # 8000682a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800070de:	cd11                	beqz	a0,800070fa <sys_mknod+0x74>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800070e0:	ffffe097          	auipc	ra,0xffffe
    800070e4:	fa0080e7          	jalr	-96(ra) # 80005080 <iunlockput>
  end_op();
    800070e8:	ffffe097          	auipc	ra,0xffffe
    800070ec:	77a080e7          	jalr	1914(ra) # 80005862 <end_op>
  return 0;
    800070f0:	4501                	li	a0,0
}
    800070f2:	60ea                	ld	ra,152(sp)
    800070f4:	644a                	ld	s0,144(sp)
    800070f6:	610d                	add	sp,sp,160
    800070f8:	8082                	ret
    end_op();
    800070fa:	ffffe097          	auipc	ra,0xffffe
    800070fe:	768080e7          	jalr	1896(ra) # 80005862 <end_op>
    return -1;
    80007102:	557d                	li	a0,-1
    80007104:	b7fd                	j	800070f2 <sys_mknod+0x6c>

0000000080007106 <sys_chdir>:

uint64
sys_chdir(void)
{
    80007106:	7135                	add	sp,sp,-160
    80007108:	ed06                	sd	ra,152(sp)
    8000710a:	e922                	sd	s0,144(sp)
    8000710c:	e14a                	sd	s2,128(sp)
    8000710e:	1100                	add	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80007110:	ffffb097          	auipc	ra,0xffffb
    80007114:	274080e7          	jalr	628(ra) # 80002384 <myproc>
    80007118:	892a                	mv	s2,a0
  
  begin_op();
    8000711a:	ffffe097          	auipc	ra,0xffffe
    8000711e:	6ce080e7          	jalr	1742(ra) # 800057e8 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80007122:	08000613          	li	a2,128
    80007126:	f6040593          	add	a1,s0,-160
    8000712a:	4501                	li	a0,0
    8000712c:	ffffd097          	auipc	ra,0xffffd
    80007130:	e52080e7          	jalr	-430(ra) # 80003f7e <argstr>
    80007134:	04054d63          	bltz	a0,8000718e <sys_chdir+0x88>
    80007138:	e526                	sd	s1,136(sp)
    8000713a:	f6040513          	add	a0,s0,-160
    8000713e:	ffffe097          	auipc	ra,0xffffe
    80007142:	4aa080e7          	jalr	1194(ra) # 800055e8 <namei>
    80007146:	84aa                	mv	s1,a0
    80007148:	c131                	beqz	a0,8000718c <sys_chdir+0x86>
    end_op();
    return -1;
  }
  ilock(ip);
    8000714a:	ffffe097          	auipc	ra,0xffffe
    8000714e:	cd0080e7          	jalr	-816(ra) # 80004e1a <ilock>
  if(ip->type != T_DIR){
    80007152:	04449703          	lh	a4,68(s1)
    80007156:	4785                	li	a5,1
    80007158:	04f71163          	bne	a4,a5,8000719a <sys_chdir+0x94>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000715c:	8526                	mv	a0,s1
    8000715e:	ffffe097          	auipc	ra,0xffffe
    80007162:	d82080e7          	jalr	-638(ra) # 80004ee0 <iunlock>
  iput(p->cwd);
    80007166:	1b093503          	ld	a0,432(s2)
    8000716a:	ffffe097          	auipc	ra,0xffffe
    8000716e:	e6e080e7          	jalr	-402(ra) # 80004fd8 <iput>
  end_op();
    80007172:	ffffe097          	auipc	ra,0xffffe
    80007176:	6f0080e7          	jalr	1776(ra) # 80005862 <end_op>
  p->cwd = ip;
    8000717a:	1a993823          	sd	s1,432(s2)
  return 0;
    8000717e:	4501                	li	a0,0
    80007180:	64aa                	ld	s1,136(sp)
}
    80007182:	60ea                	ld	ra,152(sp)
    80007184:	644a                	ld	s0,144(sp)
    80007186:	690a                	ld	s2,128(sp)
    80007188:	610d                	add	sp,sp,160
    8000718a:	8082                	ret
    8000718c:	64aa                	ld	s1,136(sp)
    end_op();
    8000718e:	ffffe097          	auipc	ra,0xffffe
    80007192:	6d4080e7          	jalr	1748(ra) # 80005862 <end_op>
    return -1;
    80007196:	557d                	li	a0,-1
    80007198:	b7ed                	j	80007182 <sys_chdir+0x7c>
    iunlockput(ip);
    8000719a:	8526                	mv	a0,s1
    8000719c:	ffffe097          	auipc	ra,0xffffe
    800071a0:	ee4080e7          	jalr	-284(ra) # 80005080 <iunlockput>
    end_op();
    800071a4:	ffffe097          	auipc	ra,0xffffe
    800071a8:	6be080e7          	jalr	1726(ra) # 80005862 <end_op>
    return -1;
    800071ac:	557d                	li	a0,-1
    800071ae:	64aa                	ld	s1,136(sp)
    800071b0:	bfc9                	j	80007182 <sys_chdir+0x7c>

00000000800071b2 <sys_exec>:

uint64
sys_exec(void)
{
    800071b2:	7121                	add	sp,sp,-448
    800071b4:	ff06                	sd	ra,440(sp)
    800071b6:	fb22                	sd	s0,432(sp)
    800071b8:	0380                	add	s0,sp,448
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800071ba:	e4840593          	add	a1,s0,-440
    800071be:	4505                	li	a0,1
    800071c0:	ffffd097          	auipc	ra,0xffffd
    800071c4:	d9e080e7          	jalr	-610(ra) # 80003f5e <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800071c8:	08000613          	li	a2,128
    800071cc:	f5040593          	add	a1,s0,-176
    800071d0:	4501                	li	a0,0
    800071d2:	ffffd097          	auipc	ra,0xffffd
    800071d6:	dac080e7          	jalr	-596(ra) # 80003f7e <argstr>
    800071da:	87aa                	mv	a5,a0
    return -1;
    800071dc:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800071de:	0e07c263          	bltz	a5,800072c2 <sys_exec+0x110>
    800071e2:	f726                	sd	s1,424(sp)
    800071e4:	f34a                	sd	s2,416(sp)
    800071e6:	ef4e                	sd	s3,408(sp)
    800071e8:	eb52                	sd	s4,400(sp)
  }
  memset(argv, 0, sizeof(argv));
    800071ea:	10000613          	li	a2,256
    800071ee:	4581                	li	a1,0
    800071f0:	e5040513          	add	a0,s0,-432
    800071f4:	ffffa097          	auipc	ra,0xffffa
    800071f8:	2bc080e7          	jalr	700(ra) # 800014b0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800071fc:	e5040493          	add	s1,s0,-432
  memset(argv, 0, sizeof(argv));
    80007200:	89a6                	mv	s3,s1
    80007202:	4901                	li	s2,0
    if(i >= NELEM(argv)){
    80007204:	02000a13          	li	s4,32
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80007208:	00391513          	sll	a0,s2,0x3
    8000720c:	e4040593          	add	a1,s0,-448
    80007210:	e4843783          	ld	a5,-440(s0)
    80007214:	953e                	add	a0,a0,a5
    80007216:	ffffd097          	auipc	ra,0xffffd
    8000721a:	c8a080e7          	jalr	-886(ra) # 80003ea0 <fetchaddr>
    8000721e:	02054a63          	bltz	a0,80007252 <sys_exec+0xa0>
      goto bad;
    }
    if(uarg == 0){
    80007222:	e4043783          	ld	a5,-448(s0)
    80007226:	c7b9                	beqz	a5,80007274 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80007228:	ffffa097          	auipc	ra,0xffffa
    8000722c:	dfe080e7          	jalr	-514(ra) # 80001026 <kalloc>
    80007230:	85aa                	mv	a1,a0
    80007232:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80007236:	cd11                	beqz	a0,80007252 <sys_exec+0xa0>
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80007238:	6605                	lui	a2,0x1
    8000723a:	e4043503          	ld	a0,-448(s0)
    8000723e:	ffffd097          	auipc	ra,0xffffd
    80007242:	cb4080e7          	jalr	-844(ra) # 80003ef2 <fetchstr>
    80007246:	00054663          	bltz	a0,80007252 <sys_exec+0xa0>
    if(i >= NELEM(argv)){
    8000724a:	0905                	add	s2,s2,1
    8000724c:	09a1                	add	s3,s3,8
    8000724e:	fb491de3          	bne	s2,s4,80007208 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007252:	f5040913          	add	s2,s0,-176
    80007256:	6088                	ld	a0,0(s1)
    80007258:	c125                	beqz	a0,800072b8 <sys_exec+0x106>
    kfree(argv[i]);
    8000725a:	ffffa097          	auipc	ra,0xffffa
    8000725e:	b6e080e7          	jalr	-1170(ra) # 80000dc8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007262:	04a1                	add	s1,s1,8
    80007264:	ff2499e3          	bne	s1,s2,80007256 <sys_exec+0xa4>
  return -1;
    80007268:	557d                	li	a0,-1
    8000726a:	74ba                	ld	s1,424(sp)
    8000726c:	791a                	ld	s2,416(sp)
    8000726e:	69fa                	ld	s3,408(sp)
    80007270:	6a5a                	ld	s4,400(sp)
    80007272:	a881                	j	800072c2 <sys_exec+0x110>
      argv[i] = 0;
    80007274:	0009079b          	sext.w	a5,s2
    80007278:	078e                	sll	a5,a5,0x3
    8000727a:	fd078793          	add	a5,a5,-48
    8000727e:	97a2                	add	a5,a5,s0
    80007280:	e807b023          	sd	zero,-384(a5)
  int ret = exec(path, argv);
    80007284:	e5040593          	add	a1,s0,-432
    80007288:	f5040513          	add	a0,s0,-176
    8000728c:	fffff097          	auipc	ra,0xfffff
    80007290:	0fc080e7          	jalr	252(ra) # 80006388 <exec>
    80007294:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80007296:	f5040993          	add	s3,s0,-176
    8000729a:	6088                	ld	a0,0(s1)
    8000729c:	c901                	beqz	a0,800072ac <sys_exec+0xfa>
    kfree(argv[i]);
    8000729e:	ffffa097          	auipc	ra,0xffffa
    800072a2:	b2a080e7          	jalr	-1238(ra) # 80000dc8 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800072a6:	04a1                	add	s1,s1,8
    800072a8:	ff3499e3          	bne	s1,s3,8000729a <sys_exec+0xe8>
  return ret;
    800072ac:	854a                	mv	a0,s2
    800072ae:	74ba                	ld	s1,424(sp)
    800072b0:	791a                	ld	s2,416(sp)
    800072b2:	69fa                	ld	s3,408(sp)
    800072b4:	6a5a                	ld	s4,400(sp)
    800072b6:	a031                	j	800072c2 <sys_exec+0x110>
  return -1;
    800072b8:	557d                	li	a0,-1
    800072ba:	74ba                	ld	s1,424(sp)
    800072bc:	791a                	ld	s2,416(sp)
    800072be:	69fa                	ld	s3,408(sp)
    800072c0:	6a5a                	ld	s4,400(sp)
}
    800072c2:	70fa                	ld	ra,440(sp)
    800072c4:	745a                	ld	s0,432(sp)
    800072c6:	6139                	add	sp,sp,448
    800072c8:	8082                	ret

00000000800072ca <sys_pipe>:

uint64
sys_pipe(void)
{
    800072ca:	7139                	add	sp,sp,-64
    800072cc:	fc06                	sd	ra,56(sp)
    800072ce:	f822                	sd	s0,48(sp)
    800072d0:	f426                	sd	s1,40(sp)
    800072d2:	0080                	add	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800072d4:	ffffb097          	auipc	ra,0xffffb
    800072d8:	0b0080e7          	jalr	176(ra) # 80002384 <myproc>
    800072dc:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800072de:	fd840593          	add	a1,s0,-40
    800072e2:	4501                	li	a0,0
    800072e4:	ffffd097          	auipc	ra,0xffffd
    800072e8:	c7a080e7          	jalr	-902(ra) # 80003f5e <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800072ec:	fc840593          	add	a1,s0,-56
    800072f0:	fd040513          	add	a0,s0,-48
    800072f4:	fffff097          	auipc	ra,0xfffff
    800072f8:	d2c080e7          	jalr	-724(ra) # 80006020 <pipealloc>
    return -1;
    800072fc:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800072fe:	0c054763          	bltz	a0,800073cc <sys_pipe+0x102>
  fd0 = -1;
    80007302:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80007306:	fd043503          	ld	a0,-48(s0)
    8000730a:	fffff097          	auipc	ra,0xfffff
    8000730e:	4de080e7          	jalr	1246(ra) # 800067e8 <fdalloc>
    80007312:	fca42223          	sw	a0,-60(s0)
    80007316:	08054e63          	bltz	a0,800073b2 <sys_pipe+0xe8>
    8000731a:	fc843503          	ld	a0,-56(s0)
    8000731e:	fffff097          	auipc	ra,0xfffff
    80007322:	4ca080e7          	jalr	1226(ra) # 800067e8 <fdalloc>
    80007326:	fca42023          	sw	a0,-64(s0)
    8000732a:	06054a63          	bltz	a0,8000739e <sys_pipe+0xd4>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000732e:	4691                	li	a3,4
    80007330:	fc440613          	add	a2,s0,-60
    80007334:	fd843583          	ld	a1,-40(s0)
    80007338:	78c8                	ld	a0,176(s1)
    8000733a:	ffffb097          	auipc	ra,0xffffb
    8000733e:	ce2080e7          	jalr	-798(ra) # 8000201c <copyout>
    80007342:	02054063          	bltz	a0,80007362 <sys_pipe+0x98>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80007346:	4691                	li	a3,4
    80007348:	fc040613          	add	a2,s0,-64
    8000734c:	fd843583          	ld	a1,-40(s0)
    80007350:	0591                	add	a1,a1,4
    80007352:	78c8                	ld	a0,176(s1)
    80007354:	ffffb097          	auipc	ra,0xffffb
    80007358:	cc8080e7          	jalr	-824(ra) # 8000201c <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000735c:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000735e:	06055763          	bgez	a0,800073cc <sys_pipe+0x102>
    p->ofile[fd0] = 0;
    80007362:	fc442783          	lw	a5,-60(s0)
    80007366:	02678793          	add	a5,a5,38
    8000736a:	078e                	sll	a5,a5,0x3
    8000736c:	97a6                	add	a5,a5,s1
    8000736e:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80007372:	fc042783          	lw	a5,-64(s0)
    80007376:	02678793          	add	a5,a5,38
    8000737a:	078e                	sll	a5,a5,0x3
    8000737c:	94be                	add	s1,s1,a5
    8000737e:	0004b023          	sd	zero,0(s1)
    fileclose(rf);
    80007382:	fd043503          	ld	a0,-48(s0)
    80007386:	fffff097          	auipc	ra,0xfffff
    8000738a:	92c080e7          	jalr	-1748(ra) # 80005cb2 <fileclose>
    fileclose(wf);
    8000738e:	fc843503          	ld	a0,-56(s0)
    80007392:	fffff097          	auipc	ra,0xfffff
    80007396:	920080e7          	jalr	-1760(ra) # 80005cb2 <fileclose>
    return -1;
    8000739a:	57fd                	li	a5,-1
    8000739c:	a805                	j	800073cc <sys_pipe+0x102>
    if(fd0 >= 0)
    8000739e:	fc442783          	lw	a5,-60(s0)
    800073a2:	0007c863          	bltz	a5,800073b2 <sys_pipe+0xe8>
      p->ofile[fd0] = 0;
    800073a6:	02678793          	add	a5,a5,38
    800073aa:	078e                	sll	a5,a5,0x3
    800073ac:	97a6                	add	a5,a5,s1
    800073ae:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800073b2:	fd043503          	ld	a0,-48(s0)
    800073b6:	fffff097          	auipc	ra,0xfffff
    800073ba:	8fc080e7          	jalr	-1796(ra) # 80005cb2 <fileclose>
    fileclose(wf);
    800073be:	fc843503          	ld	a0,-56(s0)
    800073c2:	fffff097          	auipc	ra,0xfffff
    800073c6:	8f0080e7          	jalr	-1808(ra) # 80005cb2 <fileclose>
    return -1;
    800073ca:	57fd                	li	a5,-1
}
    800073cc:	853e                	mv	a0,a5
    800073ce:	70e2                	ld	ra,56(sp)
    800073d0:	7442                	ld	s0,48(sp)
    800073d2:	74a2                	ld	s1,40(sp)
    800073d4:	6121                	add	sp,sp,64
    800073d6:	8082                	ret
	...

00000000800073e0 <kernelvec>:
    800073e0:	7111                	add	sp,sp,-256
    800073e2:	e006                	sd	ra,0(sp)
    800073e4:	e40a                	sd	sp,8(sp)
    800073e6:	e80e                	sd	gp,16(sp)
    800073e8:	ec12                	sd	tp,24(sp)
    800073ea:	f016                	sd	t0,32(sp)
    800073ec:	f41a                	sd	t1,40(sp)
    800073ee:	f81e                	sd	t2,48(sp)
    800073f0:	fc22                	sd	s0,56(sp)
    800073f2:	e0a6                	sd	s1,64(sp)
    800073f4:	e4aa                	sd	a0,72(sp)
    800073f6:	e8ae                	sd	a1,80(sp)
    800073f8:	ecb2                	sd	a2,88(sp)
    800073fa:	f0b6                	sd	a3,96(sp)
    800073fc:	f4ba                	sd	a4,104(sp)
    800073fe:	f8be                	sd	a5,112(sp)
    80007400:	fcc2                	sd	a6,120(sp)
    80007402:	e146                	sd	a7,128(sp)
    80007404:	e54a                	sd	s2,136(sp)
    80007406:	e94e                	sd	s3,144(sp)
    80007408:	ed52                	sd	s4,152(sp)
    8000740a:	f156                	sd	s5,160(sp)
    8000740c:	f55a                	sd	s6,168(sp)
    8000740e:	f95e                	sd	s7,176(sp)
    80007410:	fd62                	sd	s8,184(sp)
    80007412:	e1e6                	sd	s9,192(sp)
    80007414:	e5ea                	sd	s10,200(sp)
    80007416:	e9ee                	sd	s11,208(sp)
    80007418:	edf2                	sd	t3,216(sp)
    8000741a:	f1f6                	sd	t4,224(sp)
    8000741c:	f5fa                	sd	t5,232(sp)
    8000741e:	f9fe                	sd	t6,240(sp)
    80007420:	94dfc0ef          	jal	80003d6c <kerneltrap>
    80007424:	6082                	ld	ra,0(sp)
    80007426:	6122                	ld	sp,8(sp)
    80007428:	61c2                	ld	gp,16(sp)
    8000742a:	7282                	ld	t0,32(sp)
    8000742c:	7322                	ld	t1,40(sp)
    8000742e:	73c2                	ld	t2,48(sp)
    80007430:	7462                	ld	s0,56(sp)
    80007432:	6486                	ld	s1,64(sp)
    80007434:	6526                	ld	a0,72(sp)
    80007436:	65c6                	ld	a1,80(sp)
    80007438:	6666                	ld	a2,88(sp)
    8000743a:	7686                	ld	a3,96(sp)
    8000743c:	7726                	ld	a4,104(sp)
    8000743e:	77c6                	ld	a5,112(sp)
    80007440:	7866                	ld	a6,120(sp)
    80007442:	688a                	ld	a7,128(sp)
    80007444:	692a                	ld	s2,136(sp)
    80007446:	69ca                	ld	s3,144(sp)
    80007448:	6a6a                	ld	s4,152(sp)
    8000744a:	7a8a                	ld	s5,160(sp)
    8000744c:	7b2a                	ld	s6,168(sp)
    8000744e:	7bca                	ld	s7,176(sp)
    80007450:	7c6a                	ld	s8,184(sp)
    80007452:	6c8e                	ld	s9,192(sp)
    80007454:	6d2e                	ld	s10,200(sp)
    80007456:	6dce                	ld	s11,208(sp)
    80007458:	6e6e                	ld	t3,216(sp)
    8000745a:	7e8e                	ld	t4,224(sp)
    8000745c:	7f2e                	ld	t5,232(sp)
    8000745e:	7fce                	ld	t6,240(sp)
    80007460:	6111                	add	sp,sp,256
    80007462:	10200073          	sret
    80007466:	00000013          	nop
    8000746a:	00000013          	nop
    8000746e:	0001                	nop

0000000080007470 <timervec>:
    80007470:	34051573          	csrrw	a0,mscratch,a0
    80007474:	e10c                	sd	a1,0(a0)
    80007476:	e510                	sd	a2,8(a0)
    80007478:	e914                	sd	a3,16(a0)
    8000747a:	6d0c                	ld	a1,24(a0)
    8000747c:	7110                	ld	a2,32(a0)
    8000747e:	6194                	ld	a3,0(a1)
    80007480:	96b2                	add	a3,a3,a2
    80007482:	e194                	sd	a3,0(a1)
    80007484:	4589                	li	a1,2
    80007486:	14459073          	csrw	sip,a1
    8000748a:	6914                	ld	a3,16(a0)
    8000748c:	6510                	ld	a2,8(a0)
    8000748e:	610c                	ld	a1,0(a0)
    80007490:	34051573          	csrrw	a0,mscratch,a0
    80007494:	30200073          	mret
	...

000000008000749a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000749a:	1141                	add	sp,sp,-16
    8000749c:	e422                	sd	s0,8(sp)
    8000749e:	0800                	add	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800074a0:	0c0007b7          	lui	a5,0xc000
    800074a4:	4705                	li	a4,1
    800074a6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800074a8:	0c0007b7          	lui	a5,0xc000
    800074ac:	c3d8                	sw	a4,4(a5)
}
    800074ae:	6422                	ld	s0,8(sp)
    800074b0:	0141                	add	sp,sp,16
    800074b2:	8082                	ret

00000000800074b4 <plicinithart>:

void
plicinithart(void)
{
    800074b4:	1141                	add	sp,sp,-16
    800074b6:	e406                	sd	ra,8(sp)
    800074b8:	e022                	sd	s0,0(sp)
    800074ba:	0800                	add	s0,sp,16
  int hart = cpuid();
    800074bc:	ffffb097          	auipc	ra,0xffffb
    800074c0:	e9c080e7          	jalr	-356(ra) # 80002358 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800074c4:	0085171b          	sllw	a4,a0,0x8
    800074c8:	0c0027b7          	lui	a5,0xc002
    800074cc:	97ba                	add	a5,a5,a4
    800074ce:	40200713          	li	a4,1026
    800074d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800074d6:	00d5151b          	sllw	a0,a0,0xd
    800074da:	0c2017b7          	lui	a5,0xc201
    800074de:	97aa                	add	a5,a5,a0
    800074e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800074e4:	60a2                	ld	ra,8(sp)
    800074e6:	6402                	ld	s0,0(sp)
    800074e8:	0141                	add	sp,sp,16
    800074ea:	8082                	ret

00000000800074ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800074ec:	1141                	add	sp,sp,-16
    800074ee:	e406                	sd	ra,8(sp)
    800074f0:	e022                	sd	s0,0(sp)
    800074f2:	0800                	add	s0,sp,16
  int hart = cpuid();
    800074f4:	ffffb097          	auipc	ra,0xffffb
    800074f8:	e64080e7          	jalr	-412(ra) # 80002358 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800074fc:	00d5151b          	sllw	a0,a0,0xd
    80007500:	0c2017b7          	lui	a5,0xc201
    80007504:	97aa                	add	a5,a5,a0
  return irq;
}
    80007506:	43c8                	lw	a0,4(a5)
    80007508:	60a2                	ld	ra,8(sp)
    8000750a:	6402                	ld	s0,0(sp)
    8000750c:	0141                	add	sp,sp,16
    8000750e:	8082                	ret

0000000080007510 <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80007510:	1101                	add	sp,sp,-32
    80007512:	ec06                	sd	ra,24(sp)
    80007514:	e822                	sd	s0,16(sp)
    80007516:	e426                	sd	s1,8(sp)
    80007518:	1000                	add	s0,sp,32
    8000751a:	84aa                	mv	s1,a0
  int hart = cpuid();
    8000751c:	ffffb097          	auipc	ra,0xffffb
    80007520:	e3c080e7          	jalr	-452(ra) # 80002358 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80007524:	00d5151b          	sllw	a0,a0,0xd
    80007528:	0c2017b7          	lui	a5,0xc201
    8000752c:	97aa                	add	a5,a5,a0
    8000752e:	c3c4                	sw	s1,4(a5)
}
    80007530:	60e2                	ld	ra,24(sp)
    80007532:	6442                	ld	s0,16(sp)
    80007534:	64a2                	ld	s1,8(sp)
    80007536:	6105                	add	sp,sp,32
    80007538:	8082                	ret

000000008000753a <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    8000753a:	1141                	add	sp,sp,-16
    8000753c:	e406                	sd	ra,8(sp)
    8000753e:	e022                	sd	s0,0(sp)
    80007540:	0800                	add	s0,sp,16
  if(i >= NUM)
    80007542:	479d                	li	a5,7
    80007544:	04a7cc63          	blt	a5,a0,8000759c <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80007548:	0002d797          	auipc	a5,0x2d
    8000754c:	e4878793          	add	a5,a5,-440 # 80034390 <disk>
    80007550:	97aa                	add	a5,a5,a0
    80007552:	0187c783          	lbu	a5,24(a5)
    80007556:	ebb9                	bnez	a5,800075ac <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80007558:	00451693          	sll	a3,a0,0x4
    8000755c:	0002d797          	auipc	a5,0x2d
    80007560:	e3478793          	add	a5,a5,-460 # 80034390 <disk>
    80007564:	6398                	ld	a4,0(a5)
    80007566:	9736                	add	a4,a4,a3
    80007568:	00073023          	sd	zero,0(a4)
  disk.desc[i].len = 0;
    8000756c:	6398                	ld	a4,0(a5)
    8000756e:	9736                	add	a4,a4,a3
    80007570:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80007574:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80007578:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    8000757c:	97aa                	add	a5,a5,a0
    8000757e:	4705                	li	a4,1
    80007580:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80007584:	0002d517          	auipc	a0,0x2d
    80007588:	e2450513          	add	a0,a0,-476 # 800343a8 <disk+0x18>
    8000758c:	ffffc097          	auipc	ra,0xffffc
    80007590:	abe080e7          	jalr	-1346(ra) # 8000304a <wakeup>
}
    80007594:	60a2                	ld	ra,8(sp)
    80007596:	6402                	ld	s0,0(sp)
    80007598:	0141                	add	sp,sp,16
    8000759a:	8082                	ret
    panic("free_desc 1");
    8000759c:	00002517          	auipc	a0,0x2
    800075a0:	31450513          	add	a0,a0,788 # 800098b0 <etext+0x8b0>
    800075a4:	ffff9097          	auipc	ra,0xffff9
    800075a8:	ff2080e7          	jalr	-14(ra) # 80000596 <panic>
    panic("free_desc 2");
    800075ac:	00002517          	auipc	a0,0x2
    800075b0:	31450513          	add	a0,a0,788 # 800098c0 <etext+0x8c0>
    800075b4:	ffff9097          	auipc	ra,0xffff9
    800075b8:	fe2080e7          	jalr	-30(ra) # 80000596 <panic>

00000000800075bc <virtio_disk_init>:
{
    800075bc:	1101                	add	sp,sp,-32
    800075be:	ec06                	sd	ra,24(sp)
    800075c0:	e822                	sd	s0,16(sp)
    800075c2:	e426                	sd	s1,8(sp)
    800075c4:	e04a                	sd	s2,0(sp)
    800075c6:	1000                	add	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800075c8:	00002597          	auipc	a1,0x2
    800075cc:	30858593          	add	a1,a1,776 # 800098d0 <etext+0x8d0>
    800075d0:	0002d517          	auipc	a0,0x2d
    800075d4:	ee850513          	add	a0,a0,-280 # 800344b8 <disk+0x128>
    800075d8:	ffffa097          	auipc	ra,0xffffa
    800075dc:	d4c080e7          	jalr	-692(ra) # 80001324 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800075e0:	100017b7          	lui	a5,0x10001
    800075e4:	4398                	lw	a4,0(a5)
    800075e6:	2701                	sext.w	a4,a4
    800075e8:	747277b7          	lui	a5,0x74727
    800075ec:	97678793          	add	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800075f0:	18f71c63          	bne	a4,a5,80007788 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800075f4:	100017b7          	lui	a5,0x10001
    800075f8:	0791                	add	a5,a5,4 # 10001004 <_entry-0x6fffeffc>
    800075fa:	439c                	lw	a5,0(a5)
    800075fc:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800075fe:	4709                	li	a4,2
    80007600:	18e79463          	bne	a5,a4,80007788 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80007604:	100017b7          	lui	a5,0x10001
    80007608:	07a1                	add	a5,a5,8 # 10001008 <_entry-0x6fffeff8>
    8000760a:	439c                	lw	a5,0(a5)
    8000760c:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000760e:	16e79d63          	bne	a5,a4,80007788 <virtio_disk_init+0x1cc>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80007612:	100017b7          	lui	a5,0x10001
    80007616:	47d8                	lw	a4,12(a5)
    80007618:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000761a:	554d47b7          	lui	a5,0x554d4
    8000761e:	55178793          	add	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80007622:	16f71363          	bne	a4,a5,80007788 <virtio_disk_init+0x1cc>
  *R(VIRTIO_MMIO_STATUS) = status;
    80007626:	100017b7          	lui	a5,0x10001
    8000762a:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000762e:	4705                	li	a4,1
    80007630:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80007632:	470d                	li	a4,3
    80007634:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80007636:	10001737          	lui	a4,0x10001
    8000763a:	4b14                	lw	a3,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000763c:	c7ffe737          	lui	a4,0xc7ffe
    80007640:	75f70713          	add	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fca28f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80007644:	8ef9                	and	a3,a3,a4
    80007646:	10001737          	lui	a4,0x10001
    8000764a:	d314                	sw	a3,32(a4)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000764c:	472d                	li	a4,11
    8000764e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80007650:	07078793          	add	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80007654:	439c                	lw	a5,0(a5)
    80007656:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000765a:	8ba1                	and	a5,a5,8
    8000765c:	12078e63          	beqz	a5,80007798 <virtio_disk_init+0x1dc>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80007660:	100017b7          	lui	a5,0x10001
    80007664:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80007668:	100017b7          	lui	a5,0x10001
    8000766c:	04478793          	add	a5,a5,68 # 10001044 <_entry-0x6fffefbc>
    80007670:	439c                	lw	a5,0(a5)
    80007672:	2781                	sext.w	a5,a5
    80007674:	12079a63          	bnez	a5,800077a8 <virtio_disk_init+0x1ec>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80007678:	100017b7          	lui	a5,0x10001
    8000767c:	03478793          	add	a5,a5,52 # 10001034 <_entry-0x6fffefcc>
    80007680:	439c                	lw	a5,0(a5)
    80007682:	2781                	sext.w	a5,a5
  if(max == 0)
    80007684:	12078a63          	beqz	a5,800077b8 <virtio_disk_init+0x1fc>
  if(max < NUM)
    80007688:	471d                	li	a4,7
    8000768a:	12f77f63          	bgeu	a4,a5,800077c8 <virtio_disk_init+0x20c>
  disk.desc = kalloc();
    8000768e:	ffffa097          	auipc	ra,0xffffa
    80007692:	998080e7          	jalr	-1640(ra) # 80001026 <kalloc>
    80007696:	0002d497          	auipc	s1,0x2d
    8000769a:	cfa48493          	add	s1,s1,-774 # 80034390 <disk>
    8000769e:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800076a0:	ffffa097          	auipc	ra,0xffffa
    800076a4:	986080e7          	jalr	-1658(ra) # 80001026 <kalloc>
    800076a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800076aa:	ffffa097          	auipc	ra,0xffffa
    800076ae:	97c080e7          	jalr	-1668(ra) # 80001026 <kalloc>
    800076b2:	87aa                	mv	a5,a0
    800076b4:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800076b6:	6088                	ld	a0,0(s1)
    800076b8:	12050063          	beqz	a0,800077d8 <virtio_disk_init+0x21c>
    800076bc:	0002d717          	auipc	a4,0x2d
    800076c0:	cdc73703          	ld	a4,-804(a4) # 80034398 <disk+0x8>
    800076c4:	10070a63          	beqz	a4,800077d8 <virtio_disk_init+0x21c>
    800076c8:	10078863          	beqz	a5,800077d8 <virtio_disk_init+0x21c>
  memset(disk.desc, 0, PGSIZE);
    800076cc:	6605                	lui	a2,0x1
    800076ce:	4581                	li	a1,0
    800076d0:	ffffa097          	auipc	ra,0xffffa
    800076d4:	de0080e7          	jalr	-544(ra) # 800014b0 <memset>
  memset(disk.avail, 0, PGSIZE);
    800076d8:	0002d497          	auipc	s1,0x2d
    800076dc:	cb848493          	add	s1,s1,-840 # 80034390 <disk>
    800076e0:	6605                	lui	a2,0x1
    800076e2:	4581                	li	a1,0
    800076e4:	6488                	ld	a0,8(s1)
    800076e6:	ffffa097          	auipc	ra,0xffffa
    800076ea:	dca080e7          	jalr	-566(ra) # 800014b0 <memset>
  memset(disk.used, 0, PGSIZE);
    800076ee:	6605                	lui	a2,0x1
    800076f0:	4581                	li	a1,0
    800076f2:	6888                	ld	a0,16(s1)
    800076f4:	ffffa097          	auipc	ra,0xffffa
    800076f8:	dbc080e7          	jalr	-580(ra) # 800014b0 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800076fc:	100017b7          	lui	a5,0x10001
    80007700:	4721                	li	a4,8
    80007702:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80007704:	4098                	lw	a4,0(s1)
    80007706:	100017b7          	lui	a5,0x10001
    8000770a:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    8000770e:	40d8                	lw	a4,4(s1)
    80007710:	100017b7          	lui	a5,0x10001
    80007714:	08e7a223          	sw	a4,132(a5) # 10001084 <_entry-0x6fffef7c>
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80007718:	649c                	ld	a5,8(s1)
    8000771a:	0007869b          	sext.w	a3,a5
    8000771e:	10001737          	lui	a4,0x10001
    80007722:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80007726:	9781                	sra	a5,a5,0x20
    80007728:	10001737          	lui	a4,0x10001
    8000772c:	08f72a23          	sw	a5,148(a4) # 10001094 <_entry-0x6fffef6c>
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80007730:	689c                	ld	a5,16(s1)
    80007732:	0007869b          	sext.w	a3,a5
    80007736:	10001737          	lui	a4,0x10001
    8000773a:	0ad72023          	sw	a3,160(a4) # 100010a0 <_entry-0x6fffef60>
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000773e:	9781                	sra	a5,a5,0x20
    80007740:	10001737          	lui	a4,0x10001
    80007744:	0af72223          	sw	a5,164(a4) # 100010a4 <_entry-0x6fffef5c>
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80007748:	10001737          	lui	a4,0x10001
    8000774c:	4785                	li	a5,1
    8000774e:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80007750:	00f48c23          	sb	a5,24(s1)
    80007754:	00f48ca3          	sb	a5,25(s1)
    80007758:	00f48d23          	sb	a5,26(s1)
    8000775c:	00f48da3          	sb	a5,27(s1)
    80007760:	00f48e23          	sb	a5,28(s1)
    80007764:	00f48ea3          	sb	a5,29(s1)
    80007768:	00f48f23          	sb	a5,30(s1)
    8000776c:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80007770:	00496913          	or	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80007774:	100017b7          	lui	a5,0x10001
    80007778:	0727a823          	sw	s2,112(a5) # 10001070 <_entry-0x6fffef90>
}
    8000777c:	60e2                	ld	ra,24(sp)
    8000777e:	6442                	ld	s0,16(sp)
    80007780:	64a2                	ld	s1,8(sp)
    80007782:	6902                	ld	s2,0(sp)
    80007784:	6105                	add	sp,sp,32
    80007786:	8082                	ret
    panic("could not find virtio disk");
    80007788:	00002517          	auipc	a0,0x2
    8000778c:	15850513          	add	a0,a0,344 # 800098e0 <etext+0x8e0>
    80007790:	ffff9097          	auipc	ra,0xffff9
    80007794:	e06080e7          	jalr	-506(ra) # 80000596 <panic>
    panic("virtio disk FEATURES_OK unset");
    80007798:	00002517          	auipc	a0,0x2
    8000779c:	16850513          	add	a0,a0,360 # 80009900 <etext+0x900>
    800077a0:	ffff9097          	auipc	ra,0xffff9
    800077a4:	df6080e7          	jalr	-522(ra) # 80000596 <panic>
    panic("virtio disk should not be ready");
    800077a8:	00002517          	auipc	a0,0x2
    800077ac:	17850513          	add	a0,a0,376 # 80009920 <etext+0x920>
    800077b0:	ffff9097          	auipc	ra,0xffff9
    800077b4:	de6080e7          	jalr	-538(ra) # 80000596 <panic>
    panic("virtio disk has no queue 0");
    800077b8:	00002517          	auipc	a0,0x2
    800077bc:	18850513          	add	a0,a0,392 # 80009940 <etext+0x940>
    800077c0:	ffff9097          	auipc	ra,0xffff9
    800077c4:	dd6080e7          	jalr	-554(ra) # 80000596 <panic>
    panic("virtio disk max queue too short");
    800077c8:	00002517          	auipc	a0,0x2
    800077cc:	19850513          	add	a0,a0,408 # 80009960 <etext+0x960>
    800077d0:	ffff9097          	auipc	ra,0xffff9
    800077d4:	dc6080e7          	jalr	-570(ra) # 80000596 <panic>
    panic("virtio disk kalloc");
    800077d8:	00002517          	auipc	a0,0x2
    800077dc:	1a850513          	add	a0,a0,424 # 80009980 <etext+0x980>
    800077e0:	ffff9097          	auipc	ra,0xffff9
    800077e4:	db6080e7          	jalr	-586(ra) # 80000596 <panic>

00000000800077e8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800077e8:	7159                	add	sp,sp,-112
    800077ea:	f486                	sd	ra,104(sp)
    800077ec:	f0a2                	sd	s0,96(sp)
    800077ee:	eca6                	sd	s1,88(sp)
    800077f0:	e8ca                	sd	s2,80(sp)
    800077f2:	e4ce                	sd	s3,72(sp)
    800077f4:	e0d2                	sd	s4,64(sp)
    800077f6:	fc56                	sd	s5,56(sp)
    800077f8:	f85a                	sd	s6,48(sp)
    800077fa:	f45e                	sd	s7,40(sp)
    800077fc:	f062                	sd	s8,32(sp)
    800077fe:	ec66                	sd	s9,24(sp)
    80007800:	1880                	add	s0,sp,112
    80007802:	8a2a                	mv	s4,a0
    80007804:	8bae                	mv	s7,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80007806:	00c52c83          	lw	s9,12(a0)
    8000780a:	001c9c9b          	sllw	s9,s9,0x1
    8000780e:	1c82                	sll	s9,s9,0x20
    80007810:	020cdc93          	srl	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80007814:	0002d517          	auipc	a0,0x2d
    80007818:	ca450513          	add	a0,a0,-860 # 800344b8 <disk+0x128>
    8000781c:	ffffa097          	auipc	ra,0xffffa
    80007820:	b98080e7          	jalr	-1128(ra) # 800013b4 <acquire>
  for(int i = 0; i < 3; i++){
    80007824:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80007826:	44a1                	li	s1,8
      disk.free[i] = 0;
    80007828:	0002db17          	auipc	s6,0x2d
    8000782c:	b68b0b13          	add	s6,s6,-1176 # 80034390 <disk>
  for(int i = 0; i < 3; i++){
    80007830:	4a8d                	li	s5,3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80007832:	0002dc17          	auipc	s8,0x2d
    80007836:	c86c0c13          	add	s8,s8,-890 # 800344b8 <disk+0x128>
    8000783a:	a0ad                	j	800078a4 <virtio_disk_rw+0xbc>
      disk.free[i] = 0;
    8000783c:	00fb0733          	add	a4,s6,a5
    80007840:	00070c23          	sb	zero,24(a4) # 10001018 <_entry-0x6fffefe8>
    idx[i] = alloc_desc();
    80007844:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80007846:	0207c563          	bltz	a5,80007870 <virtio_disk_rw+0x88>
  for(int i = 0; i < 3; i++){
    8000784a:	2905                	addw	s2,s2,1
    8000784c:	0611                	add	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000784e:	05590f63          	beq	s2,s5,800078ac <virtio_disk_rw+0xc4>
    idx[i] = alloc_desc();
    80007852:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80007854:	0002d717          	auipc	a4,0x2d
    80007858:	b3c70713          	add	a4,a4,-1220 # 80034390 <disk>
    8000785c:	87ce                	mv	a5,s3
    if(disk.free[i]){
    8000785e:	01874683          	lbu	a3,24(a4)
    80007862:	fee9                	bnez	a3,8000783c <virtio_disk_rw+0x54>
  for(int i = 0; i < NUM; i++){
    80007864:	2785                	addw	a5,a5,1
    80007866:	0705                	add	a4,a4,1
    80007868:	fe979be3          	bne	a5,s1,8000785e <virtio_disk_rw+0x76>
    idx[i] = alloc_desc();
    8000786c:	57fd                	li	a5,-1
    8000786e:	c19c                	sw	a5,0(a1)
      for(int j = 0; j < i; j++)
    80007870:	03205163          	blez	s2,80007892 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80007874:	f9042503          	lw	a0,-112(s0)
    80007878:	00000097          	auipc	ra,0x0
    8000787c:	cc2080e7          	jalr	-830(ra) # 8000753a <free_desc>
      for(int j = 0; j < i; j++)
    80007880:	4785                	li	a5,1
    80007882:	0127d863          	bge	a5,s2,80007892 <virtio_disk_rw+0xaa>
        free_desc(idx[j]);
    80007886:	f9442503          	lw	a0,-108(s0)
    8000788a:	00000097          	auipc	ra,0x0
    8000788e:	cb0080e7          	jalr	-848(ra) # 8000753a <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80007892:	85e2                	mv	a1,s8
    80007894:	0002d517          	auipc	a0,0x2d
    80007898:	b1450513          	add	a0,a0,-1260 # 800343a8 <disk+0x18>
    8000789c:	ffffb097          	auipc	ra,0xffffb
    800078a0:	74a080e7          	jalr	1866(ra) # 80002fe6 <sleep>
  for(int i = 0; i < 3; i++){
    800078a4:	f9040613          	add	a2,s0,-112
    800078a8:	894e                	mv	s2,s3
    800078aa:	b765                	j	80007852 <virtio_disk_rw+0x6a>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800078ac:	f9042503          	lw	a0,-112(s0)
    800078b0:	00451693          	sll	a3,a0,0x4

  if(write)
    800078b4:	0002d797          	auipc	a5,0x2d
    800078b8:	adc78793          	add	a5,a5,-1316 # 80034390 <disk>
    800078bc:	00a50713          	add	a4,a0,10
    800078c0:	0712                	sll	a4,a4,0x4
    800078c2:	973e                	add	a4,a4,a5
    800078c4:	01703633          	snez	a2,s7
    800078c8:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800078ca:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800078ce:	01973823          	sd	s9,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800078d2:	6398                	ld	a4,0(a5)
    800078d4:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800078d6:	0a868613          	add	a2,a3,168
    800078da:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800078dc:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800078de:	6390                	ld	a2,0(a5)
    800078e0:	00d605b3          	add	a1,a2,a3
    800078e4:	4741                	li	a4,16
    800078e6:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800078e8:	4805                	li	a6,1
    800078ea:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    800078ee:	f9442703          	lw	a4,-108(s0)
    800078f2:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800078f6:	0712                	sll	a4,a4,0x4
    800078f8:	963a                	add	a2,a2,a4
    800078fa:	058a0593          	add	a1,s4,88
    800078fe:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80007900:	0007b883          	ld	a7,0(a5)
    80007904:	9746                	add	a4,a4,a7
    80007906:	40000613          	li	a2,1024
    8000790a:	c710                	sw	a2,8(a4)
  if(write)
    8000790c:	001bb613          	seqz	a2,s7
    80007910:	0016161b          	sllw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80007914:	00166613          	or	a2,a2,1
    80007918:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    8000791c:	f9842583          	lw	a1,-104(s0)
    80007920:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80007924:	00250613          	add	a2,a0,2
    80007928:	0612                	sll	a2,a2,0x4
    8000792a:	963e                	add	a2,a2,a5
    8000792c:	577d                	li	a4,-1
    8000792e:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80007932:	0592                	sll	a1,a1,0x4
    80007934:	98ae                	add	a7,a7,a1
    80007936:	03068713          	add	a4,a3,48
    8000793a:	973e                	add	a4,a4,a5
    8000793c:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80007940:	6398                	ld	a4,0(a5)
    80007942:	972e                	add	a4,a4,a1
    80007944:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80007948:	4689                	li	a3,2
    8000794a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    8000794e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80007952:	010a2223          	sw	a6,4(s4)
  disk.info[idx[0]].b = b;
    80007956:	01463423          	sd	s4,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000795a:	6794                	ld	a3,8(a5)
    8000795c:	0026d703          	lhu	a4,2(a3)
    80007960:	8b1d                	and	a4,a4,7
    80007962:	0706                	sll	a4,a4,0x1
    80007964:	96ba                	add	a3,a3,a4
    80007966:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    8000796a:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    8000796e:	6798                	ld	a4,8(a5)
    80007970:	00275783          	lhu	a5,2(a4)
    80007974:	2785                	addw	a5,a5,1
    80007976:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000797a:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    8000797e:	100017b7          	lui	a5,0x10001
    80007982:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80007986:	004a2783          	lw	a5,4(s4)
    sleep(b, &disk.vdisk_lock);
    8000798a:	0002d917          	auipc	s2,0x2d
    8000798e:	b2e90913          	add	s2,s2,-1234 # 800344b8 <disk+0x128>
  while(b->disk == 1) {
    80007992:	4485                	li	s1,1
    80007994:	01079c63          	bne	a5,a6,800079ac <virtio_disk_rw+0x1c4>
    sleep(b, &disk.vdisk_lock);
    80007998:	85ca                	mv	a1,s2
    8000799a:	8552                	mv	a0,s4
    8000799c:	ffffb097          	auipc	ra,0xffffb
    800079a0:	64a080e7          	jalr	1610(ra) # 80002fe6 <sleep>
  while(b->disk == 1) {
    800079a4:	004a2783          	lw	a5,4(s4)
    800079a8:	fe9788e3          	beq	a5,s1,80007998 <virtio_disk_rw+0x1b0>
  }

  disk.info[idx[0]].b = 0;
    800079ac:	f9042903          	lw	s2,-112(s0)
    800079b0:	00290713          	add	a4,s2,2
    800079b4:	0712                	sll	a4,a4,0x4
    800079b6:	0002d797          	auipc	a5,0x2d
    800079ba:	9da78793          	add	a5,a5,-1574 # 80034390 <disk>
    800079be:	97ba                	add	a5,a5,a4
    800079c0:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800079c4:	0002d997          	auipc	s3,0x2d
    800079c8:	9cc98993          	add	s3,s3,-1588 # 80034390 <disk>
    800079cc:	00491713          	sll	a4,s2,0x4
    800079d0:	0009b783          	ld	a5,0(s3)
    800079d4:	97ba                	add	a5,a5,a4
    800079d6:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800079da:	854a                	mv	a0,s2
    800079dc:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800079e0:	00000097          	auipc	ra,0x0
    800079e4:	b5a080e7          	jalr	-1190(ra) # 8000753a <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800079e8:	8885                	and	s1,s1,1
    800079ea:	f0ed                	bnez	s1,800079cc <virtio_disk_rw+0x1e4>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800079ec:	0002d517          	auipc	a0,0x2d
    800079f0:	acc50513          	add	a0,a0,-1332 # 800344b8 <disk+0x128>
    800079f4:	ffffa097          	auipc	ra,0xffffa
    800079f8:	a74080e7          	jalr	-1420(ra) # 80001468 <release>
}
    800079fc:	70a6                	ld	ra,104(sp)
    800079fe:	7406                	ld	s0,96(sp)
    80007a00:	64e6                	ld	s1,88(sp)
    80007a02:	6946                	ld	s2,80(sp)
    80007a04:	69a6                	ld	s3,72(sp)
    80007a06:	6a06                	ld	s4,64(sp)
    80007a08:	7ae2                	ld	s5,56(sp)
    80007a0a:	7b42                	ld	s6,48(sp)
    80007a0c:	7ba2                	ld	s7,40(sp)
    80007a0e:	7c02                	ld	s8,32(sp)
    80007a10:	6ce2                	ld	s9,24(sp)
    80007a12:	6165                	add	sp,sp,112
    80007a14:	8082                	ret

0000000080007a16 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80007a16:	1101                	add	sp,sp,-32
    80007a18:	ec06                	sd	ra,24(sp)
    80007a1a:	e822                	sd	s0,16(sp)
    80007a1c:	e426                	sd	s1,8(sp)
    80007a1e:	1000                	add	s0,sp,32
  acquire(&disk.vdisk_lock);
    80007a20:	0002d497          	auipc	s1,0x2d
    80007a24:	97048493          	add	s1,s1,-1680 # 80034390 <disk>
    80007a28:	0002d517          	auipc	a0,0x2d
    80007a2c:	a9050513          	add	a0,a0,-1392 # 800344b8 <disk+0x128>
    80007a30:	ffffa097          	auipc	ra,0xffffa
    80007a34:	984080e7          	jalr	-1660(ra) # 800013b4 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80007a38:	100017b7          	lui	a5,0x10001
    80007a3c:	53b8                	lw	a4,96(a5)
    80007a3e:	8b0d                	and	a4,a4,3
    80007a40:	100017b7          	lui	a5,0x10001
    80007a44:	d3f8                	sw	a4,100(a5)

  __sync_synchronize();
    80007a46:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80007a4a:	689c                	ld	a5,16(s1)
    80007a4c:	0204d703          	lhu	a4,32(s1)
    80007a50:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80007a54:	04f70863          	beq	a4,a5,80007aa4 <virtio_disk_intr+0x8e>
    __sync_synchronize();
    80007a58:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80007a5c:	6898                	ld	a4,16(s1)
    80007a5e:	0204d783          	lhu	a5,32(s1)
    80007a62:	8b9d                	and	a5,a5,7
    80007a64:	078e                	sll	a5,a5,0x3
    80007a66:	97ba                	add	a5,a5,a4
    80007a68:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80007a6a:	00278713          	add	a4,a5,2
    80007a6e:	0712                	sll	a4,a4,0x4
    80007a70:	9726                	add	a4,a4,s1
    80007a72:	01074703          	lbu	a4,16(a4)
    80007a76:	e721                	bnez	a4,80007abe <virtio_disk_intr+0xa8>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80007a78:	0789                	add	a5,a5,2
    80007a7a:	0792                	sll	a5,a5,0x4
    80007a7c:	97a6                	add	a5,a5,s1
    80007a7e:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80007a80:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80007a84:	ffffb097          	auipc	ra,0xffffb
    80007a88:	5c6080e7          	jalr	1478(ra) # 8000304a <wakeup>

    disk.used_idx += 1;
    80007a8c:	0204d783          	lhu	a5,32(s1)
    80007a90:	2785                	addw	a5,a5,1
    80007a92:	17c2                	sll	a5,a5,0x30
    80007a94:	93c1                	srl	a5,a5,0x30
    80007a96:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80007a9a:	6898                	ld	a4,16(s1)
    80007a9c:	00275703          	lhu	a4,2(a4)
    80007aa0:	faf71ce3          	bne	a4,a5,80007a58 <virtio_disk_intr+0x42>
  }

  release(&disk.vdisk_lock);
    80007aa4:	0002d517          	auipc	a0,0x2d
    80007aa8:	a1450513          	add	a0,a0,-1516 # 800344b8 <disk+0x128>
    80007aac:	ffffa097          	auipc	ra,0xffffa
    80007ab0:	9bc080e7          	jalr	-1604(ra) # 80001468 <release>
}
    80007ab4:	60e2                	ld	ra,24(sp)
    80007ab6:	6442                	ld	s0,16(sp)
    80007ab8:	64a2                	ld	s1,8(sp)
    80007aba:	6105                	add	sp,sp,32
    80007abc:	8082                	ret
      panic("virtio_disk_intr status");
    80007abe:	00002517          	auipc	a0,0x2
    80007ac2:	eda50513          	add	a0,a0,-294 # 80009998 <etext+0x998>
    80007ac6:	ffff9097          	auipc	ra,0xffff9
    80007aca:	ad0080e7          	jalr	-1328(ra) # 80000596 <panic>

0000000080007ace <sys_ktest>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_ktest(void)
{
    80007ace:	1101                	add	sp,sp,-32
    80007ad0:	ec06                	sd	ra,24(sp)
    80007ad2:	e822                	sd	s0,16(sp)
    80007ad4:	1000                	add	s0,sp,32
  int n;
  uint64 pa;

  argint(0, &n);
    80007ad6:	fec40593          	add	a1,s0,-20
    80007ada:	4501                	li	a0,0
    80007adc:	ffffc097          	auipc	ra,0xffffc
    80007ae0:	462080e7          	jalr	1122(ra) # 80003f3e <argint>
  argaddr(1, &pa);
    80007ae4:	fe040593          	add	a1,s0,-32
    80007ae8:	4505                	li	a0,1
    80007aea:	ffffc097          	auipc	ra,0xffffc
    80007aee:	474080e7          	jalr	1140(ra) # 80003f5e <argaddr>
  switch (n)
    80007af2:	fec42783          	lw	a5,-20(s0)
    80007af6:	4709                	li	a4,2
    80007af8:	04e78563          	beq	a5,a4,80007b42 <sys_ktest+0x74>
    80007afc:	00f74f63          	blt	a4,a5,80007b1a <sys_ktest+0x4c>
    80007b00:	cb8d                	beqz	a5,80007b32 <sys_ktest+0x64>
    80007b02:	4705                	li	a4,1
    80007b04:	4501                	li	a0,0
    80007b06:	02e79a63          	bne	a5,a4,80007b3a <sys_ktest+0x6c>
  {
    case KT_KALLOC:       return (uint64) kalloc();
    case KT_KFREE:        kfree((void *)pa); return 0;
    80007b0a:	fe043503          	ld	a0,-32(s0)
    80007b0e:	ffff9097          	auipc	ra,0xffff9
    80007b12:	2ba080e7          	jalr	698(ra) # 80000dc8 <kfree>
    80007b16:	4501                	li	a0,0
    80007b18:	a00d                	j	80007b3a <sys_ktest+0x6c>
  switch (n)
    80007b1a:	470d                	li	a4,3
    80007b1c:	4501                	li	a0,0
    80007b1e:	00e79e63          	bne	a5,a4,80007b3a <sys_ktest+0x6c>
    case KT_KALLOC_HUGE:  return (uint64) kalloc_huge();
    case KT_KFREE_HUGE:   kfree_huge((void *)pa); return 0;
    80007b22:	fe043503          	ld	a0,-32(s0)
    80007b26:	ffff9097          	auipc	ra,0xffff9
    80007b2a:	6f8080e7          	jalr	1784(ra) # 8000121e <kfree_huge>
    80007b2e:	4501                	li	a0,0
    80007b30:	a029                	j	80007b3a <sys_ktest+0x6c>
    case KT_KALLOC:       return (uint64) kalloc();
    80007b32:	ffff9097          	auipc	ra,0xffff9
    80007b36:	4f4080e7          	jalr	1268(ra) # 80001026 <kalloc>
    default:              return 0;
  }
}
    80007b3a:	60e2                	ld	ra,24(sp)
    80007b3c:	6442                	ld	s0,16(sp)
    80007b3e:	6105                	add	sp,sp,32
    80007b40:	8082                	ret
    case KT_KALLOC_HUGE:  return (uint64) kalloc_huge();
    80007b42:	ffff9097          	auipc	ra,0xffff9
    80007b46:	622080e7          	jalr	1570(ra) # 80001164 <kalloc_huge>
    80007b4a:	bfc5                	j	80007b3a <sys_ktest+0x6c>
	...

0000000080008000 <_trampoline>:
    80008000:	14051073          	csrw	sscratch,a0
    80008004:	02000537          	lui	a0,0x2000
    80008008:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000800a:	0536                	sll	a0,a0,0xd
    8000800c:	02153423          	sd	ra,40(a0)
    80008010:	02253823          	sd	sp,48(a0)
    80008014:	02353c23          	sd	gp,56(a0)
    80008018:	04453023          	sd	tp,64(a0)
    8000801c:	04553423          	sd	t0,72(a0)
    80008020:	04653823          	sd	t1,80(a0)
    80008024:	04753c23          	sd	t2,88(a0)
    80008028:	f120                	sd	s0,96(a0)
    8000802a:	f524                	sd	s1,104(a0)
    8000802c:	fd2c                	sd	a1,120(a0)
    8000802e:	e150                	sd	a2,128(a0)
    80008030:	e554                	sd	a3,136(a0)
    80008032:	e958                	sd	a4,144(a0)
    80008034:	ed5c                	sd	a5,152(a0)
    80008036:	0b053023          	sd	a6,160(a0)
    8000803a:	0b153423          	sd	a7,168(a0)
    8000803e:	0b253823          	sd	s2,176(a0)
    80008042:	0b353c23          	sd	s3,184(a0)
    80008046:	0d453023          	sd	s4,192(a0)
    8000804a:	0d553423          	sd	s5,200(a0)
    8000804e:	0d653823          	sd	s6,208(a0)
    80008052:	0d753c23          	sd	s7,216(a0)
    80008056:	0f853023          	sd	s8,224(a0)
    8000805a:	0f953423          	sd	s9,232(a0)
    8000805e:	0fa53823          	sd	s10,240(a0)
    80008062:	0fb53c23          	sd	s11,248(a0)
    80008066:	11c53023          	sd	t3,256(a0)
    8000806a:	11d53423          	sd	t4,264(a0)
    8000806e:	11e53823          	sd	t5,272(a0)
    80008072:	11f53c23          	sd	t6,280(a0)
    80008076:	140022f3          	csrr	t0,sscratch
    8000807a:	06553823          	sd	t0,112(a0)
    8000807e:	00853103          	ld	sp,8(a0)
    80008082:	02053203          	ld	tp,32(a0)
    80008086:	01053283          	ld	t0,16(a0)
    8000808a:	00053303          	ld	t1,0(a0)
    8000808e:	12000073          	sfence.vma
    80008092:	18031073          	csrw	satp,t1
    80008096:	12000073          	sfence.vma
    8000809a:	8282                	jr	t0

000000008000809c <userret>:
    8000809c:	12000073          	sfence.vma
    800080a0:	18051073          	csrw	satp,a0
    800080a4:	12000073          	sfence.vma
    800080a8:	02000537          	lui	a0,0x2000
    800080ac:	357d                	addw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800080ae:	0536                	sll	a0,a0,0xd
    800080b0:	02853083          	ld	ra,40(a0)
    800080b4:	03053103          	ld	sp,48(a0)
    800080b8:	03853183          	ld	gp,56(a0)
    800080bc:	04053203          	ld	tp,64(a0)
    800080c0:	04853283          	ld	t0,72(a0)
    800080c4:	05053303          	ld	t1,80(a0)
    800080c8:	05853383          	ld	t2,88(a0)
    800080cc:	7120                	ld	s0,96(a0)
    800080ce:	7524                	ld	s1,104(a0)
    800080d0:	7d2c                	ld	a1,120(a0)
    800080d2:	6150                	ld	a2,128(a0)
    800080d4:	6554                	ld	a3,136(a0)
    800080d6:	6958                	ld	a4,144(a0)
    800080d8:	6d5c                	ld	a5,152(a0)
    800080da:	0a053803          	ld	a6,160(a0)
    800080de:	0a853883          	ld	a7,168(a0)
    800080e2:	0b053903          	ld	s2,176(a0)
    800080e6:	0b853983          	ld	s3,184(a0)
    800080ea:	0c053a03          	ld	s4,192(a0)
    800080ee:	0c853a83          	ld	s5,200(a0)
    800080f2:	0d053b03          	ld	s6,208(a0)
    800080f6:	0d853b83          	ld	s7,216(a0)
    800080fa:	0e053c03          	ld	s8,224(a0)
    800080fe:	0e853c83          	ld	s9,232(a0)
    80008102:	0f053d03          	ld	s10,240(a0)
    80008106:	0f853d83          	ld	s11,248(a0)
    8000810a:	10053e03          	ld	t3,256(a0)
    8000810e:	10853e83          	ld	t4,264(a0)
    80008112:	11053f03          	ld	t5,272(a0)
    80008116:	11853f83          	ld	t6,280(a0)
    8000811a:	7928                	ld	a0,112(a0)
    8000811c:	10200073          	sret
	...
