
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 60 51 11 80       	mov    $0x80115160,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 b9 38 10 80       	mov    $0x801038b9,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	83 ec 08             	sub    $0x8,%esp
8010003d:	68 0c 88 10 80       	push   $0x8010880c
80100042:	68 c0 b5 10 80       	push   $0x8010b5c0
80100047:	e8 5c 50 00 00       	call   801050a8 <initlock>
8010004c:	83 c4 10             	add    $0x10,%esp

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004f:	c7 05 d0 f4 10 80 c4 	movl   $0x8010f4c4,0x8010f4d0
80100056:	f4 10 80 
  bcache.head.next = &bcache.head;
80100059:	c7 05 d4 f4 10 80 c4 	movl   $0x8010f4c4,0x8010f4d4
80100060:	f4 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100063:	c7 45 f4 f4 b5 10 80 	movl   $0x8010b5f4,-0xc(%ebp)
8010006a:	eb 3a                	jmp    801000a6 <binit+0x72>
    b->next = bcache.head.next;
8010006c:	8b 15 d4 f4 10 80    	mov    0x8010f4d4,%edx
80100072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100075:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100078:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007b:	c7 40 0c c4 f4 10 80 	movl   $0x8010f4c4,0xc(%eax)
    b->dev = -1;
80100082:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100085:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008c:	a1 d4 f4 10 80       	mov    0x8010f4d4,%eax
80100091:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100094:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100097:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010009a:	a3 d4 f4 10 80       	mov    %eax,0x8010f4d4
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009f:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a6:	b8 c4 f4 10 80       	mov    $0x8010f4c4,%eax
801000ab:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801000ae:	72 bc                	jb     8010006c <binit+0x38>
  }
}
801000b0:	90                   	nop
801000b1:	90                   	nop
801000b2:	c9                   	leave  
801000b3:	c3                   	ret    

801000b4 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint blockno)
{
801000b4:	55                   	push   %ebp
801000b5:	89 e5                	mov    %esp,%ebp
801000b7:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000ba:	83 ec 0c             	sub    $0xc,%esp
801000bd:	68 c0 b5 10 80       	push   $0x8010b5c0
801000c2:	e8 03 50 00 00       	call   801050ca <acquire>
801000c7:	83 c4 10             	add    $0x10,%esp

 loop:
  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000ca:	a1 d4 f4 10 80       	mov    0x8010f4d4,%eax
801000cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000d2:	eb 67                	jmp    8010013b <bget+0x87>
    if(b->dev == dev && b->blockno == blockno){
801000d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000d7:	8b 40 04             	mov    0x4(%eax),%eax
801000da:	39 45 08             	cmp    %eax,0x8(%ebp)
801000dd:	75 53                	jne    80100132 <bget+0x7e>
801000df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e2:	8b 40 08             	mov    0x8(%eax),%eax
801000e5:	39 45 0c             	cmp    %eax,0xc(%ebp)
801000e8:	75 48                	jne    80100132 <bget+0x7e>
      if(!(b->flags & B_BUSY)){
801000ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000ed:	8b 00                	mov    (%eax),%eax
801000ef:	83 e0 01             	and    $0x1,%eax
801000f2:	85 c0                	test   %eax,%eax
801000f4:	75 27                	jne    8010011d <bget+0x69>
        b->flags |= B_BUSY;
801000f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f9:	8b 00                	mov    (%eax),%eax
801000fb:	83 c8 01             	or     $0x1,%eax
801000fe:	89 c2                	mov    %eax,%edx
80100100:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100103:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
80100105:	83 ec 0c             	sub    $0xc,%esp
80100108:	68 c0 b5 10 80       	push   $0x8010b5c0
8010010d:	e8 1f 50 00 00       	call   80105131 <release>
80100112:	83 c4 10             	add    $0x10,%esp
        return b;
80100115:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100118:	e9 98 00 00 00       	jmp    801001b5 <bget+0x101>
      }
      sleep(b, &bcache.lock);
8010011d:	83 ec 08             	sub    $0x8,%esp
80100120:	68 c0 b5 10 80       	push   $0x8010b5c0
80100125:	ff 75 f4             	push   -0xc(%ebp)
80100128:	e8 a2 4c 00 00       	call   80104dcf <sleep>
8010012d:	83 c4 10             	add    $0x10,%esp
      goto loop;
80100130:	eb 98                	jmp    801000ca <bget+0x16>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100132:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100135:	8b 40 10             	mov    0x10(%eax),%eax
80100138:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010013b:	81 7d f4 c4 f4 10 80 	cmpl   $0x8010f4c4,-0xc(%ebp)
80100142:	75 90                	jne    801000d4 <bget+0x20>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100144:	a1 d0 f4 10 80       	mov    0x8010f4d0,%eax
80100149:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010014c:	eb 51                	jmp    8010019f <bget+0xeb>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 01             	and    $0x1,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 3c                	jne    80100196 <bget+0xe2>
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 00                	mov    (%eax),%eax
8010015f:	83 e0 04             	and    $0x4,%eax
80100162:	85 c0                	test   %eax,%eax
80100164:	75 30                	jne    80100196 <bget+0xe2>
      b->dev = dev;
80100166:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100169:	8b 55 08             	mov    0x8(%ebp),%edx
8010016c:	89 50 04             	mov    %edx,0x4(%eax)
      b->blockno = blockno;
8010016f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100172:	8b 55 0c             	mov    0xc(%ebp),%edx
80100175:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
80100178:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010017b:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100181:	83 ec 0c             	sub    $0xc,%esp
80100184:	68 c0 b5 10 80       	push   $0x8010b5c0
80100189:	e8 a3 4f 00 00       	call   80105131 <release>
8010018e:	83 c4 10             	add    $0x10,%esp
      return b;
80100191:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100194:	eb 1f                	jmp    801001b5 <bget+0x101>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100196:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100199:	8b 40 0c             	mov    0xc(%eax),%eax
8010019c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010019f:	81 7d f4 c4 f4 10 80 	cmpl   $0x8010f4c4,-0xc(%ebp)
801001a6:	75 a6                	jne    8010014e <bget+0x9a>
    }
  }
  panic("bget: no buffers");
801001a8:	83 ec 0c             	sub    $0xc,%esp
801001ab:	68 13 88 10 80       	push   $0x80108813
801001b0:	e8 c6 03 00 00       	call   8010057b <panic>
}
801001b5:	c9                   	leave  
801001b6:	c3                   	ret    

801001b7 <bread>:

// Return a B_BUSY buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801001b7:	55                   	push   %ebp
801001b8:	89 e5                	mov    %esp,%ebp
801001ba:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  b = bget(dev, blockno);
801001bd:	83 ec 08             	sub    $0x8,%esp
801001c0:	ff 75 0c             	push   0xc(%ebp)
801001c3:	ff 75 08             	push   0x8(%ebp)
801001c6:	e8 e9 fe ff ff       	call   801000b4 <bget>
801001cb:	83 c4 10             	add    $0x10,%esp
801001ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID)) {
801001d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d4:	8b 00                	mov    (%eax),%eax
801001d6:	83 e0 02             	and    $0x2,%eax
801001d9:	85 c0                	test   %eax,%eax
801001db:	75 0e                	jne    801001eb <bread+0x34>
    iderw(b);
801001dd:	83 ec 0c             	sub    $0xc,%esp
801001e0:	ff 75 f4             	push   -0xc(%ebp)
801001e3:	e8 37 27 00 00       	call   8010291f <iderw>
801001e8:	83 c4 10             	add    $0x10,%esp
  }
  return b;
801001eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001ee:	c9                   	leave  
801001ef:	c3                   	ret    

801001f0 <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
801001f6:	8b 45 08             	mov    0x8(%ebp),%eax
801001f9:	8b 00                	mov    (%eax),%eax
801001fb:	83 e0 01             	and    $0x1,%eax
801001fe:	85 c0                	test   %eax,%eax
80100200:	75 0d                	jne    8010020f <bwrite+0x1f>
    panic("bwrite");
80100202:	83 ec 0c             	sub    $0xc,%esp
80100205:	68 24 88 10 80       	push   $0x80108824
8010020a:	e8 6c 03 00 00       	call   8010057b <panic>
  b->flags |= B_DIRTY;
8010020f:	8b 45 08             	mov    0x8(%ebp),%eax
80100212:	8b 00                	mov    (%eax),%eax
80100214:	83 c8 04             	or     $0x4,%eax
80100217:	89 c2                	mov    %eax,%edx
80100219:	8b 45 08             	mov    0x8(%ebp),%eax
8010021c:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010021e:	83 ec 0c             	sub    $0xc,%esp
80100221:	ff 75 08             	push   0x8(%ebp)
80100224:	e8 f6 26 00 00       	call   8010291f <iderw>
80100229:	83 c4 10             	add    $0x10,%esp
}
8010022c:	90                   	nop
8010022d:	c9                   	leave  
8010022e:	c3                   	ret    

8010022f <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
8010022f:	55                   	push   %ebp
80100230:	89 e5                	mov    %esp,%ebp
80100232:	83 ec 08             	sub    $0x8,%esp
  if((b->flags & B_BUSY) == 0)
80100235:	8b 45 08             	mov    0x8(%ebp),%eax
80100238:	8b 00                	mov    (%eax),%eax
8010023a:	83 e0 01             	and    $0x1,%eax
8010023d:	85 c0                	test   %eax,%eax
8010023f:	75 0d                	jne    8010024e <brelse+0x1f>
    panic("brelse");
80100241:	83 ec 0c             	sub    $0xc,%esp
80100244:	68 2b 88 10 80       	push   $0x8010882b
80100249:	e8 2d 03 00 00       	call   8010057b <panic>

  acquire(&bcache.lock);
8010024e:	83 ec 0c             	sub    $0xc,%esp
80100251:	68 c0 b5 10 80       	push   $0x8010b5c0
80100256:	e8 6f 4e 00 00       	call   801050ca <acquire>
8010025b:	83 c4 10             	add    $0x10,%esp

  b->next->prev = b->prev;
8010025e:	8b 45 08             	mov    0x8(%ebp),%eax
80100261:	8b 40 10             	mov    0x10(%eax),%eax
80100264:	8b 55 08             	mov    0x8(%ebp),%edx
80100267:	8b 52 0c             	mov    0xc(%edx),%edx
8010026a:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
8010026d:	8b 45 08             	mov    0x8(%ebp),%eax
80100270:	8b 40 0c             	mov    0xc(%eax),%eax
80100273:	8b 55 08             	mov    0x8(%ebp),%edx
80100276:	8b 52 10             	mov    0x10(%edx),%edx
80100279:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010027c:	8b 15 d4 f4 10 80    	mov    0x8010f4d4,%edx
80100282:	8b 45 08             	mov    0x8(%ebp),%eax
80100285:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	c7 40 0c c4 f4 10 80 	movl   $0x8010f4c4,0xc(%eax)
  bcache.head.next->prev = b;
80100292:	a1 d4 f4 10 80       	mov    0x8010f4d4,%eax
80100297:	8b 55 08             	mov    0x8(%ebp),%edx
8010029a:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
8010029d:	8b 45 08             	mov    0x8(%ebp),%eax
801002a0:	a3 d4 f4 10 80       	mov    %eax,0x8010f4d4

  b->flags &= ~B_BUSY;
801002a5:	8b 45 08             	mov    0x8(%ebp),%eax
801002a8:	8b 00                	mov    (%eax),%eax
801002aa:	83 e0 fe             	and    $0xfffffffe,%eax
801002ad:	89 c2                	mov    %eax,%edx
801002af:	8b 45 08             	mov    0x8(%ebp),%eax
801002b2:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801002b4:	83 ec 0c             	sub    $0xc,%esp
801002b7:	ff 75 08             	push   0x8(%ebp)
801002ba:	e8 fc 4b 00 00       	call   80104ebb <wakeup>
801002bf:	83 c4 10             	add    $0x10,%esp

  release(&bcache.lock);
801002c2:	83 ec 0c             	sub    $0xc,%esp
801002c5:	68 c0 b5 10 80       	push   $0x8010b5c0
801002ca:	e8 62 4e 00 00       	call   80105131 <release>
801002cf:	83 c4 10             	add    $0x10,%esp
}
801002d2:	90                   	nop
801002d3:	c9                   	leave  
801002d4:	c3                   	ret    

801002d5 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002d5:	55                   	push   %ebp
801002d6:	89 e5                	mov    %esp,%ebp
801002d8:	83 ec 14             	sub    $0x14,%esp
801002db:	8b 45 08             	mov    0x8(%ebp),%eax
801002de:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002e2:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002e6:	89 c2                	mov    %eax,%edx
801002e8:	ec                   	in     (%dx),%al
801002e9:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002ec:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002f0:	c9                   	leave  
801002f1:	c3                   	ret    

801002f2 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002f2:	55                   	push   %ebp
801002f3:	89 e5                	mov    %esp,%ebp
801002f5:	83 ec 08             	sub    $0x8,%esp
801002f8:	8b 45 08             	mov    0x8(%ebp),%eax
801002fb:	8b 55 0c             	mov    0xc(%ebp),%edx
801002fe:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80100302:	89 d0                	mov    %edx,%eax
80100304:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100307:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
8010030b:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010030f:	ee                   	out    %al,(%dx)
}
80100310:	90                   	nop
80100311:	c9                   	leave  
80100312:	c3                   	ret    

80100313 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
80100313:	55                   	push   %ebp
80100314:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80100316:	fa                   	cli    
}
80100317:	90                   	nop
80100318:	5d                   	pop    %ebp
80100319:	c3                   	ret    

8010031a <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010031a:	55                   	push   %ebp
8010031b:	89 e5                	mov    %esp,%ebp
8010031d:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100320:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100324:	74 1c                	je     80100342 <printint+0x28>
80100326:	8b 45 08             	mov    0x8(%ebp),%eax
80100329:	c1 e8 1f             	shr    $0x1f,%eax
8010032c:	0f b6 c0             	movzbl %al,%eax
8010032f:	89 45 10             	mov    %eax,0x10(%ebp)
80100332:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100336:	74 0a                	je     80100342 <printint+0x28>
    x = -xx;
80100338:	8b 45 08             	mov    0x8(%ebp),%eax
8010033b:	f7 d8                	neg    %eax
8010033d:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100340:	eb 06                	jmp    80100348 <printint+0x2e>
  else
    x = xx;
80100342:	8b 45 08             	mov    0x8(%ebp),%eax
80100345:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100348:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
8010034f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100352:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100355:	ba 00 00 00 00       	mov    $0x0,%edx
8010035a:	f7 f1                	div    %ecx
8010035c:	89 d1                	mov    %edx,%ecx
8010035e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100361:	8d 50 01             	lea    0x1(%eax),%edx
80100364:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100367:	0f b6 91 04 90 10 80 	movzbl -0x7fef6ffc(%ecx),%edx
8010036e:	88 54 05 e0          	mov    %dl,-0x20(%ebp,%eax,1)
  }while((x /= base) != 0);
80100372:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100375:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100378:	ba 00 00 00 00       	mov    $0x0,%edx
8010037d:	f7 f1                	div    %ecx
8010037f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100382:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100386:	75 c7                	jne    8010034f <printint+0x35>

  if(sign)
80100388:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010038c:	74 2a                	je     801003b8 <printint+0x9e>
    buf[i++] = '-';
8010038e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100391:	8d 50 01             	lea    0x1(%eax),%edx
80100394:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100397:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
8010039c:	eb 1a                	jmp    801003b8 <printint+0x9e>
    consputc(buf[i]);
8010039e:	8d 55 e0             	lea    -0x20(%ebp),%edx
801003a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801003a4:	01 d0                	add    %edx,%eax
801003a6:	0f b6 00             	movzbl (%eax),%eax
801003a9:	0f be c0             	movsbl %al,%eax
801003ac:	83 ec 0c             	sub    $0xc,%esp
801003af:	50                   	push   %eax
801003b0:	e8 00 04 00 00       	call   801007b5 <consputc>
801003b5:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
801003b8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801003bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801003c0:	79 dc                	jns    8010039e <printint+0x84>
}
801003c2:	90                   	nop
801003c3:	90                   	nop
801003c4:	c9                   	leave  
801003c5:	c3                   	ret    

801003c6 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003c6:	55                   	push   %ebp
801003c7:	89 e5                	mov    %esp,%ebp
801003c9:	83 ec 28             	sub    $0x28,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003cc:	a1 b4 f7 10 80       	mov    0x8010f7b4,%eax
801003d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003d8:	74 10                	je     801003ea <cprintf+0x24>
    acquire(&cons.lock);
801003da:	83 ec 0c             	sub    $0xc,%esp
801003dd:	68 80 f7 10 80       	push   $0x8010f780
801003e2:	e8 e3 4c 00 00       	call   801050ca <acquire>
801003e7:	83 c4 10             	add    $0x10,%esp

  if (fmt == 0)
801003ea:	8b 45 08             	mov    0x8(%ebp),%eax
801003ed:	85 c0                	test   %eax,%eax
801003ef:	75 0d                	jne    801003fe <cprintf+0x38>
    panic("null fmt");
801003f1:	83 ec 0c             	sub    $0xc,%esp
801003f4:	68 32 88 10 80       	push   $0x80108832
801003f9:	e8 7d 01 00 00       	call   8010057b <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003fe:	8d 45 0c             	lea    0xc(%ebp),%eax
80100401:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100404:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010040b:	e9 2f 01 00 00       	jmp    8010053f <cprintf+0x179>
    if(c != '%'){
80100410:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100414:	74 13                	je     80100429 <cprintf+0x63>
      consputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	ff 75 e4             	push   -0x1c(%ebp)
8010041c:	e8 94 03 00 00       	call   801007b5 <consputc>
80100421:	83 c4 10             	add    $0x10,%esp
      continue;
80100424:	e9 12 01 00 00       	jmp    8010053b <cprintf+0x175>
    }
    c = fmt[++i] & 0xff;
80100429:	8b 55 08             	mov    0x8(%ebp),%edx
8010042c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100430:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100433:	01 d0                	add    %edx,%eax
80100435:	0f b6 00             	movzbl (%eax),%eax
80100438:	0f be c0             	movsbl %al,%eax
8010043b:	25 ff 00 00 00       	and    $0xff,%eax
80100440:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100443:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100447:	0f 84 14 01 00 00    	je     80100561 <cprintf+0x19b>
      break;
    switch(c){
8010044d:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100451:	74 5e                	je     801004b1 <cprintf+0xeb>
80100453:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
80100457:	0f 8f c2 00 00 00    	jg     8010051f <cprintf+0x159>
8010045d:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100461:	74 6b                	je     801004ce <cprintf+0x108>
80100463:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
80100467:	0f 8f b2 00 00 00    	jg     8010051f <cprintf+0x159>
8010046d:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100471:	74 3e                	je     801004b1 <cprintf+0xeb>
80100473:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
80100477:	0f 8f a2 00 00 00    	jg     8010051f <cprintf+0x159>
8010047d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
80100481:	0f 84 89 00 00 00    	je     80100510 <cprintf+0x14a>
80100487:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
8010048b:	0f 85 8e 00 00 00    	jne    8010051f <cprintf+0x159>
    case 'd':
      printint(*argp++, 10, 1);
80100491:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100494:	8d 50 04             	lea    0x4(%eax),%edx
80100497:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010049a:	8b 00                	mov    (%eax),%eax
8010049c:	83 ec 04             	sub    $0x4,%esp
8010049f:	6a 01                	push   $0x1
801004a1:	6a 0a                	push   $0xa
801004a3:	50                   	push   %eax
801004a4:	e8 71 fe ff ff       	call   8010031a <printint>
801004a9:	83 c4 10             	add    $0x10,%esp
      break;
801004ac:	e9 8a 00 00 00       	jmp    8010053b <cprintf+0x175>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
801004b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004b4:	8d 50 04             	lea    0x4(%eax),%edx
801004b7:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004ba:	8b 00                	mov    (%eax),%eax
801004bc:	83 ec 04             	sub    $0x4,%esp
801004bf:	6a 00                	push   $0x0
801004c1:	6a 10                	push   $0x10
801004c3:	50                   	push   %eax
801004c4:	e8 51 fe ff ff       	call   8010031a <printint>
801004c9:	83 c4 10             	add    $0x10,%esp
      break;
801004cc:	eb 6d                	jmp    8010053b <cprintf+0x175>
    case 's':
      if((s = (char*)*argp++) == 0)
801004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801004d1:	8d 50 04             	lea    0x4(%eax),%edx
801004d4:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004d7:	8b 00                	mov    (%eax),%eax
801004d9:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004e0:	75 22                	jne    80100504 <cprintf+0x13e>
        s = "(null)";
801004e2:	c7 45 ec 3b 88 10 80 	movl   $0x8010883b,-0x14(%ebp)
      for(; *s; s++)
801004e9:	eb 19                	jmp    80100504 <cprintf+0x13e>
        consputc(*s);
801004eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004ee:	0f b6 00             	movzbl (%eax),%eax
801004f1:	0f be c0             	movsbl %al,%eax
801004f4:	83 ec 0c             	sub    $0xc,%esp
801004f7:	50                   	push   %eax
801004f8:	e8 b8 02 00 00       	call   801007b5 <consputc>
801004fd:	83 c4 10             	add    $0x10,%esp
      for(; *s; s++)
80100500:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100504:	8b 45 ec             	mov    -0x14(%ebp),%eax
80100507:	0f b6 00             	movzbl (%eax),%eax
8010050a:	84 c0                	test   %al,%al
8010050c:	75 dd                	jne    801004eb <cprintf+0x125>
      break;
8010050e:	eb 2b                	jmp    8010053b <cprintf+0x175>
    case '%':
      consputc('%');
80100510:	83 ec 0c             	sub    $0xc,%esp
80100513:	6a 25                	push   $0x25
80100515:	e8 9b 02 00 00       	call   801007b5 <consputc>
8010051a:	83 c4 10             	add    $0x10,%esp
      break;
8010051d:	eb 1c                	jmp    8010053b <cprintf+0x175>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
8010051f:	83 ec 0c             	sub    $0xc,%esp
80100522:	6a 25                	push   $0x25
80100524:	e8 8c 02 00 00       	call   801007b5 <consputc>
80100529:	83 c4 10             	add    $0x10,%esp
      consputc(c);
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	ff 75 e4             	push   -0x1c(%ebp)
80100532:	e8 7e 02 00 00       	call   801007b5 <consputc>
80100537:	83 c4 10             	add    $0x10,%esp
      break;
8010053a:	90                   	nop
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010053b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010053f:	8b 55 08             	mov    0x8(%ebp),%edx
80100542:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100545:	01 d0                	add    %edx,%eax
80100547:	0f b6 00             	movzbl (%eax),%eax
8010054a:	0f be c0             	movsbl %al,%eax
8010054d:	25 ff 00 00 00       	and    $0xff,%eax
80100552:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100555:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100559:	0f 85 b1 fe ff ff    	jne    80100410 <cprintf+0x4a>
8010055f:	eb 01                	jmp    80100562 <cprintf+0x19c>
      break;
80100561:	90                   	nop
    }
  }

  if(locking)
80100562:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80100566:	74 10                	je     80100578 <cprintf+0x1b2>
    release(&cons.lock);
80100568:	83 ec 0c             	sub    $0xc,%esp
8010056b:	68 80 f7 10 80       	push   $0x8010f780
80100570:	e8 bc 4b 00 00       	call   80105131 <release>
80100575:	83 c4 10             	add    $0x10,%esp
}
80100578:	90                   	nop
80100579:	c9                   	leave  
8010057a:	c3                   	ret    

8010057b <panic>:

void
panic(char *s)
{
8010057b:	55                   	push   %ebp
8010057c:	89 e5                	mov    %esp,%ebp
8010057e:	83 ec 38             	sub    $0x38,%esp
  int i;
  uint pcs[10];
  
  cli();
80100581:	e8 8d fd ff ff       	call   80100313 <cli>
  cons.locking = 0;
80100586:	c7 05 b4 f7 10 80 00 	movl   $0x0,0x8010f7b4
8010058d:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
80100590:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100596:	0f b6 00             	movzbl (%eax),%eax
80100599:	0f b6 c0             	movzbl %al,%eax
8010059c:	83 ec 08             	sub    $0x8,%esp
8010059f:	50                   	push   %eax
801005a0:	68 42 88 10 80       	push   $0x80108842
801005a5:	e8 1c fe ff ff       	call   801003c6 <cprintf>
801005aa:	83 c4 10             	add    $0x10,%esp
  cprintf(s);
801005ad:	8b 45 08             	mov    0x8(%ebp),%eax
801005b0:	83 ec 0c             	sub    $0xc,%esp
801005b3:	50                   	push   %eax
801005b4:	e8 0d fe ff ff       	call   801003c6 <cprintf>
801005b9:	83 c4 10             	add    $0x10,%esp
  cprintf("\n");
801005bc:	83 ec 0c             	sub    $0xc,%esp
801005bf:	68 51 88 10 80       	push   $0x80108851
801005c4:	e8 fd fd ff ff       	call   801003c6 <cprintf>
801005c9:	83 c4 10             	add    $0x10,%esp
  getcallerpcs(&s, pcs);
801005cc:	83 ec 08             	sub    $0x8,%esp
801005cf:	8d 45 cc             	lea    -0x34(%ebp),%eax
801005d2:	50                   	push   %eax
801005d3:	8d 45 08             	lea    0x8(%ebp),%eax
801005d6:	50                   	push   %eax
801005d7:	e8 a7 4b 00 00       	call   80105183 <getcallerpcs>
801005dc:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
801005df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801005e6:	eb 1c                	jmp    80100604 <panic+0x89>
    cprintf(" %p", pcs[i]);
801005e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005eb:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005ef:	83 ec 08             	sub    $0x8,%esp
801005f2:	50                   	push   %eax
801005f3:	68 53 88 10 80       	push   $0x80108853
801005f8:	e8 c9 fd ff ff       	call   801003c6 <cprintf>
801005fd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
80100600:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100604:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80100608:	7e de                	jle    801005e8 <panic+0x6d>
  panicked = 1; // freeze other CPU
8010060a:	c7 05 6c f7 10 80 01 	movl   $0x1,0x8010f76c
80100611:	00 00 00 
  for(;;)
80100614:	eb fe                	jmp    80100614 <panic+0x99>

80100616 <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
80100616:	55                   	push   %ebp
80100617:	89 e5                	mov    %esp,%ebp
80100619:	53                   	push   %ebx
8010061a:	83 ec 14             	sub    $0x14,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
8010061d:	6a 0e                	push   $0xe
8010061f:	68 d4 03 00 00       	push   $0x3d4
80100624:	e8 c9 fc ff ff       	call   801002f2 <outb>
80100629:	83 c4 08             	add    $0x8,%esp
  pos = inb(CRTPORT+1) << 8;
8010062c:	68 d5 03 00 00       	push   $0x3d5
80100631:	e8 9f fc ff ff       	call   801002d5 <inb>
80100636:	83 c4 04             	add    $0x4,%esp
80100639:	0f b6 c0             	movzbl %al,%eax
8010063c:	c1 e0 08             	shl    $0x8,%eax
8010063f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
80100642:	6a 0f                	push   $0xf
80100644:	68 d4 03 00 00       	push   $0x3d4
80100649:	e8 a4 fc ff ff       	call   801002f2 <outb>
8010064e:	83 c4 08             	add    $0x8,%esp
  pos |= inb(CRTPORT+1);
80100651:	68 d5 03 00 00       	push   $0x3d5
80100656:	e8 7a fc ff ff       	call   801002d5 <inb>
8010065b:	83 c4 04             	add    $0x4,%esp
8010065e:	0f b6 c0             	movzbl %al,%eax
80100661:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
80100664:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100668:	75 34                	jne    8010069e <cgaputc+0x88>
    pos += 80 - pos%80;
8010066a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010066d:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100672:	89 c8                	mov    %ecx,%eax
80100674:	f7 ea                	imul   %edx
80100676:	89 d0                	mov    %edx,%eax
80100678:	c1 f8 05             	sar    $0x5,%eax
8010067b:	89 cb                	mov    %ecx,%ebx
8010067d:	c1 fb 1f             	sar    $0x1f,%ebx
80100680:	29 d8                	sub    %ebx,%eax
80100682:	89 c2                	mov    %eax,%edx
80100684:	89 d0                	mov    %edx,%eax
80100686:	c1 e0 02             	shl    $0x2,%eax
80100689:	01 d0                	add    %edx,%eax
8010068b:	c1 e0 04             	shl    $0x4,%eax
8010068e:	29 c1                	sub    %eax,%ecx
80100690:	89 ca                	mov    %ecx,%edx
80100692:	b8 50 00 00 00       	mov    $0x50,%eax
80100697:	29 d0                	sub    %edx,%eax
80100699:	01 45 f4             	add    %eax,-0xc(%ebp)
8010069c:	eb 38                	jmp    801006d6 <cgaputc+0xc0>
  else if(c == BACKSPACE){
8010069e:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801006a5:	75 0c                	jne    801006b3 <cgaputc+0x9d>
    if(pos > 0) --pos;
801006a7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006ab:	7e 29                	jle    801006d6 <cgaputc+0xc0>
801006ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
801006b1:	eb 23                	jmp    801006d6 <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801006b3:	8b 45 08             	mov    0x8(%ebp),%eax
801006b6:	0f b6 c0             	movzbl %al,%eax
801006b9:	80 cc 07             	or     $0x7,%ah
801006bc:	89 c1                	mov    %eax,%ecx
801006be:	8b 1d 00 90 10 80    	mov    0x80109000,%ebx
801006c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006c7:	8d 50 01             	lea    0x1(%eax),%edx
801006ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
801006cd:	01 c0                	add    %eax,%eax
801006cf:	01 d8                	add    %ebx,%eax
801006d1:	89 ca                	mov    %ecx,%edx
801006d3:	66 89 10             	mov    %dx,(%eax)

  if(pos < 0 || pos > 25*80)
801006d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801006da:	78 09                	js     801006e5 <cgaputc+0xcf>
801006dc:	81 7d f4 d0 07 00 00 	cmpl   $0x7d0,-0xc(%ebp)
801006e3:	7e 0d                	jle    801006f2 <cgaputc+0xdc>
    panic("pos under/overflow");
801006e5:	83 ec 0c             	sub    $0xc,%esp
801006e8:	68 57 88 10 80       	push   $0x80108857
801006ed:	e8 89 fe ff ff       	call   8010057b <panic>
  
  if((pos/80) >= 24){  // Scroll up.
801006f2:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
801006f9:	7e 4d                	jle    80100748 <cgaputc+0x132>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801006fb:	a1 00 90 10 80       	mov    0x80109000,%eax
80100700:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
80100706:	a1 00 90 10 80       	mov    0x80109000,%eax
8010070b:	83 ec 04             	sub    $0x4,%esp
8010070e:	68 60 0e 00 00       	push   $0xe60
80100713:	52                   	push   %edx
80100714:	50                   	push   %eax
80100715:	e8 d2 4c 00 00       	call   801053ec <memmove>
8010071a:	83 c4 10             	add    $0x10,%esp
    pos -= 80;
8010071d:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100721:	b8 80 07 00 00       	mov    $0x780,%eax
80100726:	2b 45 f4             	sub    -0xc(%ebp),%eax
80100729:	8d 14 00             	lea    (%eax,%eax,1),%edx
8010072c:	8b 0d 00 90 10 80    	mov    0x80109000,%ecx
80100732:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100735:	01 c0                	add    %eax,%eax
80100737:	01 c8                	add    %ecx,%eax
80100739:	83 ec 04             	sub    $0x4,%esp
8010073c:	52                   	push   %edx
8010073d:	6a 00                	push   $0x0
8010073f:	50                   	push   %eax
80100740:	e8 e8 4b 00 00       	call   8010532d <memset>
80100745:	83 c4 10             	add    $0x10,%esp
  }
  
  outb(CRTPORT, 14);
80100748:	83 ec 08             	sub    $0x8,%esp
8010074b:	6a 0e                	push   $0xe
8010074d:	68 d4 03 00 00       	push   $0x3d4
80100752:	e8 9b fb ff ff       	call   801002f2 <outb>
80100757:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos>>8);
8010075a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010075d:	c1 f8 08             	sar    $0x8,%eax
80100760:	0f b6 c0             	movzbl %al,%eax
80100763:	83 ec 08             	sub    $0x8,%esp
80100766:	50                   	push   %eax
80100767:	68 d5 03 00 00       	push   $0x3d5
8010076c:	e8 81 fb ff ff       	call   801002f2 <outb>
80100771:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT, 15);
80100774:	83 ec 08             	sub    $0x8,%esp
80100777:	6a 0f                	push   $0xf
80100779:	68 d4 03 00 00       	push   $0x3d4
8010077e:	e8 6f fb ff ff       	call   801002f2 <outb>
80100783:	83 c4 10             	add    $0x10,%esp
  outb(CRTPORT+1, pos);
80100786:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100789:	0f b6 c0             	movzbl %al,%eax
8010078c:	83 ec 08             	sub    $0x8,%esp
8010078f:	50                   	push   %eax
80100790:	68 d5 03 00 00       	push   $0x3d5
80100795:	e8 58 fb ff ff       	call   801002f2 <outb>
8010079a:	83 c4 10             	add    $0x10,%esp
  crt[pos] = ' ' | 0x0700;
8010079d:	8b 15 00 90 10 80    	mov    0x80109000,%edx
801007a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007a6:	01 c0                	add    %eax,%eax
801007a8:	01 d0                	add    %edx,%eax
801007aa:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
801007af:	90                   	nop
801007b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801007b3:	c9                   	leave  
801007b4:	c3                   	ret    

801007b5 <consputc>:

void
consputc(int c)
{
801007b5:	55                   	push   %ebp
801007b6:	89 e5                	mov    %esp,%ebp
801007b8:	83 ec 08             	sub    $0x8,%esp
  if(panicked){
801007bb:	a1 6c f7 10 80       	mov    0x8010f76c,%eax
801007c0:	85 c0                	test   %eax,%eax
801007c2:	74 07                	je     801007cb <consputc+0x16>
    cli();
801007c4:	e8 4a fb ff ff       	call   80100313 <cli>
    for(;;)
801007c9:	eb fe                	jmp    801007c9 <consputc+0x14>
      ;
  }

  if(c == BACKSPACE){
801007cb:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
801007d2:	75 29                	jne    801007fd <consputc+0x48>
    uartputc('\b'); uartputc(' '); uartputc('\b');
801007d4:	83 ec 0c             	sub    $0xc,%esp
801007d7:	6a 08                	push   $0x8
801007d9:	e8 b8 66 00 00       	call   80106e96 <uartputc>
801007de:	83 c4 10             	add    $0x10,%esp
801007e1:	83 ec 0c             	sub    $0xc,%esp
801007e4:	6a 20                	push   $0x20
801007e6:	e8 ab 66 00 00       	call   80106e96 <uartputc>
801007eb:	83 c4 10             	add    $0x10,%esp
801007ee:	83 ec 0c             	sub    $0xc,%esp
801007f1:	6a 08                	push   $0x8
801007f3:	e8 9e 66 00 00       	call   80106e96 <uartputc>
801007f8:	83 c4 10             	add    $0x10,%esp
801007fb:	eb 0e                	jmp    8010080b <consputc+0x56>
  } else
    uartputc(c);
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	ff 75 08             	push   0x8(%ebp)
80100803:	e8 8e 66 00 00       	call   80106e96 <uartputc>
80100808:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
8010080b:	83 ec 0c             	sub    $0xc,%esp
8010080e:	ff 75 08             	push   0x8(%ebp)
80100811:	e8 00 fe ff ff       	call   80100616 <cgaputc>
80100816:	83 c4 10             	add    $0x10,%esp
}
80100819:	90                   	nop
8010081a:	c9                   	leave  
8010081b:	c3                   	ret    

8010081c <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
8010081c:	55                   	push   %ebp
8010081d:	89 e5                	mov    %esp,%ebp
8010081f:	83 ec 18             	sub    $0x18,%esp
  int c, doprocdump = 0;
80100822:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&cons.lock);
80100829:	83 ec 0c             	sub    $0xc,%esp
8010082c:	68 80 f7 10 80       	push   $0x8010f780
80100831:	e8 94 48 00 00       	call   801050ca <acquire>
80100836:	83 c4 10             	add    $0x10,%esp
  while((c = getc()) >= 0){
80100839:	e9 50 01 00 00       	jmp    8010098e <consoleintr+0x172>
    switch(c){
8010083e:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
80100842:	0f 84 81 00 00 00    	je     801008c9 <consoleintr+0xad>
80100848:	83 7d f0 7f          	cmpl   $0x7f,-0x10(%ebp)
8010084c:	0f 8f ac 00 00 00    	jg     801008fe <consoleintr+0xe2>
80100852:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
80100856:	74 43                	je     8010089b <consoleintr+0x7f>
80100858:	83 7d f0 15          	cmpl   $0x15,-0x10(%ebp)
8010085c:	0f 8f 9c 00 00 00    	jg     801008fe <consoleintr+0xe2>
80100862:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
80100866:	74 61                	je     801008c9 <consoleintr+0xad>
80100868:	83 7d f0 10          	cmpl   $0x10,-0x10(%ebp)
8010086c:	0f 85 8c 00 00 00    	jne    801008fe <consoleintr+0xe2>
    case C('P'):  // Process listing.
      doprocdump = 1;   // procdump() locks cons.lock indirectly; invoke later
80100872:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
      break;
80100879:	e9 10 01 00 00       	jmp    8010098e <consoleintr+0x172>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
8010087e:	a1 68 f7 10 80       	mov    0x8010f768,%eax
80100883:	83 e8 01             	sub    $0x1,%eax
80100886:	a3 68 f7 10 80       	mov    %eax,0x8010f768
        consputc(BACKSPACE);
8010088b:	83 ec 0c             	sub    $0xc,%esp
8010088e:	68 00 01 00 00       	push   $0x100
80100893:	e8 1d ff ff ff       	call   801007b5 <consputc>
80100898:	83 c4 10             	add    $0x10,%esp
      while(input.e != input.w &&
8010089b:	8b 15 68 f7 10 80    	mov    0x8010f768,%edx
801008a1:	a1 64 f7 10 80       	mov    0x8010f764,%eax
801008a6:	39 c2                	cmp    %eax,%edx
801008a8:	0f 84 e0 00 00 00    	je     8010098e <consoleintr+0x172>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008ae:	a1 68 f7 10 80       	mov    0x8010f768,%eax
801008b3:	83 e8 01             	sub    $0x1,%eax
801008b6:	83 e0 7f             	and    $0x7f,%eax
801008b9:	0f b6 80 e0 f6 10 80 	movzbl -0x7fef0920(%eax),%eax
      while(input.e != input.w &&
801008c0:	3c 0a                	cmp    $0xa,%al
801008c2:	75 ba                	jne    8010087e <consoleintr+0x62>
      }
      break;
801008c4:	e9 c5 00 00 00       	jmp    8010098e <consoleintr+0x172>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801008c9:	8b 15 68 f7 10 80    	mov    0x8010f768,%edx
801008cf:	a1 64 f7 10 80       	mov    0x8010f764,%eax
801008d4:	39 c2                	cmp    %eax,%edx
801008d6:	0f 84 b2 00 00 00    	je     8010098e <consoleintr+0x172>
        input.e--;
801008dc:	a1 68 f7 10 80       	mov    0x8010f768,%eax
801008e1:	83 e8 01             	sub    $0x1,%eax
801008e4:	a3 68 f7 10 80       	mov    %eax,0x8010f768
        consputc(BACKSPACE);
801008e9:	83 ec 0c             	sub    $0xc,%esp
801008ec:	68 00 01 00 00       	push   $0x100
801008f1:	e8 bf fe ff ff       	call   801007b5 <consputc>
801008f6:	83 c4 10             	add    $0x10,%esp
      }
      break;
801008f9:	e9 90 00 00 00       	jmp    8010098e <consoleintr+0x172>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008fe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80100902:	0f 84 85 00 00 00    	je     8010098d <consoleintr+0x171>
80100908:	a1 68 f7 10 80       	mov    0x8010f768,%eax
8010090d:	8b 15 60 f7 10 80    	mov    0x8010f760,%edx
80100913:	29 d0                	sub    %edx,%eax
80100915:	83 f8 7f             	cmp    $0x7f,%eax
80100918:	77 73                	ja     8010098d <consoleintr+0x171>
        c = (c == '\r') ? '\n' : c;
8010091a:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
8010091e:	74 05                	je     80100925 <consoleintr+0x109>
80100920:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100923:	eb 05                	jmp    8010092a <consoleintr+0x10e>
80100925:	b8 0a 00 00 00       	mov    $0xa,%eax
8010092a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010092d:	a1 68 f7 10 80       	mov    0x8010f768,%eax
80100932:	8d 50 01             	lea    0x1(%eax),%edx
80100935:	89 15 68 f7 10 80    	mov    %edx,0x8010f768
8010093b:	83 e0 7f             	and    $0x7f,%eax
8010093e:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100941:	88 90 e0 f6 10 80    	mov    %dl,-0x7fef0920(%eax)
        consputc(c);
80100947:	83 ec 0c             	sub    $0xc,%esp
8010094a:	ff 75 f0             	push   -0x10(%ebp)
8010094d:	e8 63 fe ff ff       	call   801007b5 <consputc>
80100952:	83 c4 10             	add    $0x10,%esp
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100955:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100959:	74 18                	je     80100973 <consoleintr+0x157>
8010095b:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
8010095f:	74 12                	je     80100973 <consoleintr+0x157>
80100961:	a1 68 f7 10 80       	mov    0x8010f768,%eax
80100966:	8b 15 60 f7 10 80    	mov    0x8010f760,%edx
8010096c:	83 ea 80             	sub    $0xffffff80,%edx
8010096f:	39 d0                	cmp    %edx,%eax
80100971:	75 1a                	jne    8010098d <consoleintr+0x171>
          input.w = input.e;
80100973:	a1 68 f7 10 80       	mov    0x8010f768,%eax
80100978:	a3 64 f7 10 80       	mov    %eax,0x8010f764
          wakeup(&input.r);
8010097d:	83 ec 0c             	sub    $0xc,%esp
80100980:	68 60 f7 10 80       	push   $0x8010f760
80100985:	e8 31 45 00 00       	call   80104ebb <wakeup>
8010098a:	83 c4 10             	add    $0x10,%esp
        }
      }
      break;
8010098d:	90                   	nop
  while((c = getc()) >= 0){
8010098e:	8b 45 08             	mov    0x8(%ebp),%eax
80100991:	ff d0                	call   *%eax
80100993:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100996:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010099a:	0f 89 9e fe ff ff    	jns    8010083e <consoleintr+0x22>
    }
  }
  release(&cons.lock);
801009a0:	83 ec 0c             	sub    $0xc,%esp
801009a3:	68 80 f7 10 80       	push   $0x8010f780
801009a8:	e8 84 47 00 00       	call   80105131 <release>
801009ad:	83 c4 10             	add    $0x10,%esp
  if(doprocdump) {
801009b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801009b4:	74 05                	je     801009bb <consoleintr+0x19f>
    procdump();  // now call procdump() wo. cons.lock held
801009b6:	e8 bb 45 00 00       	call   80104f76 <procdump>
  }
}
801009bb:	90                   	nop
801009bc:	c9                   	leave  
801009bd:	c3                   	ret    

801009be <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
801009be:	55                   	push   %ebp
801009bf:	89 e5                	mov    %esp,%ebp
801009c1:	83 ec 18             	sub    $0x18,%esp
  uint target;
  int c;

  iunlock(ip);
801009c4:	83 ec 0c             	sub    $0xc,%esp
801009c7:	ff 75 08             	push   0x8(%ebp)
801009ca:	e8 16 11 00 00       	call   80101ae5 <iunlock>
801009cf:	83 c4 10             	add    $0x10,%esp
  target = n;
801009d2:	8b 45 10             	mov    0x10(%ebp),%eax
801009d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&cons.lock);
801009d8:	83 ec 0c             	sub    $0xc,%esp
801009db:	68 80 f7 10 80       	push   $0x8010f780
801009e0:	e8 e5 46 00 00       	call   801050ca <acquire>
801009e5:	83 c4 10             	add    $0x10,%esp
  while(n > 0){
801009e8:	e9 ac 00 00 00       	jmp    80100a99 <consoleread+0xdb>
    while(input.r == input.w){
      if(proc->killed){
801009ed:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801009f3:	8b 40 24             	mov    0x24(%eax),%eax
801009f6:	85 c0                	test   %eax,%eax
801009f8:	74 28                	je     80100a22 <consoleread+0x64>
        release(&cons.lock);
801009fa:	83 ec 0c             	sub    $0xc,%esp
801009fd:	68 80 f7 10 80       	push   $0x8010f780
80100a02:	e8 2a 47 00 00       	call   80105131 <release>
80100a07:	83 c4 10             	add    $0x10,%esp
        ilock(ip);
80100a0a:	83 ec 0c             	sub    $0xc,%esp
80100a0d:	ff 75 08             	push   0x8(%ebp)
80100a10:	e8 72 0f 00 00       	call   80101987 <ilock>
80100a15:	83 c4 10             	add    $0x10,%esp
        return -1;
80100a18:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100a1d:	e9 a9 00 00 00       	jmp    80100acb <consoleread+0x10d>
      }
      sleep(&input.r, &cons.lock);
80100a22:	83 ec 08             	sub    $0x8,%esp
80100a25:	68 80 f7 10 80       	push   $0x8010f780
80100a2a:	68 60 f7 10 80       	push   $0x8010f760
80100a2f:	e8 9b 43 00 00       	call   80104dcf <sleep>
80100a34:	83 c4 10             	add    $0x10,%esp
    while(input.r == input.w){
80100a37:	8b 15 60 f7 10 80    	mov    0x8010f760,%edx
80100a3d:	a1 64 f7 10 80       	mov    0x8010f764,%eax
80100a42:	39 c2                	cmp    %eax,%edx
80100a44:	74 a7                	je     801009ed <consoleread+0x2f>
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100a46:	a1 60 f7 10 80       	mov    0x8010f760,%eax
80100a4b:	8d 50 01             	lea    0x1(%eax),%edx
80100a4e:	89 15 60 f7 10 80    	mov    %edx,0x8010f760
80100a54:	83 e0 7f             	and    $0x7f,%eax
80100a57:	0f b6 80 e0 f6 10 80 	movzbl -0x7fef0920(%eax),%eax
80100a5e:	0f be c0             	movsbl %al,%eax
80100a61:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
80100a64:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
80100a68:	75 17                	jne    80100a81 <consoleread+0xc3>
      if(n < target){
80100a6a:	8b 45 10             	mov    0x10(%ebp),%eax
80100a6d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80100a70:	76 2f                	jbe    80100aa1 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100a72:	a1 60 f7 10 80       	mov    0x8010f760,%eax
80100a77:	83 e8 01             	sub    $0x1,%eax
80100a7a:	a3 60 f7 10 80       	mov    %eax,0x8010f760
      }
      break;
80100a7f:	eb 20                	jmp    80100aa1 <consoleread+0xe3>
    }
    *dst++ = c;
80100a81:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a84:	8d 50 01             	lea    0x1(%eax),%edx
80100a87:	89 55 0c             	mov    %edx,0xc(%ebp)
80100a8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80100a8d:	88 10                	mov    %dl,(%eax)
    --n;
80100a8f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
80100a93:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
80100a97:	74 0b                	je     80100aa4 <consoleread+0xe6>
  while(n > 0){
80100a99:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100a9d:	7f 98                	jg     80100a37 <consoleread+0x79>
80100a9f:	eb 04                	jmp    80100aa5 <consoleread+0xe7>
      break;
80100aa1:	90                   	nop
80100aa2:	eb 01                	jmp    80100aa5 <consoleread+0xe7>
      break;
80100aa4:	90                   	nop
  }
  release(&cons.lock);
80100aa5:	83 ec 0c             	sub    $0xc,%esp
80100aa8:	68 80 f7 10 80       	push   $0x8010f780
80100aad:	e8 7f 46 00 00       	call   80105131 <release>
80100ab2:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100ab5:	83 ec 0c             	sub    $0xc,%esp
80100ab8:	ff 75 08             	push   0x8(%ebp)
80100abb:	e8 c7 0e 00 00       	call   80101987 <ilock>
80100ac0:	83 c4 10             	add    $0x10,%esp

  return target - n;
80100ac3:	8b 55 10             	mov    0x10(%ebp),%edx
80100ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ac9:	29 d0                	sub    %edx,%eax
}
80100acb:	c9                   	leave  
80100acc:	c3                   	ret    

80100acd <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100acd:	55                   	push   %ebp
80100ace:	89 e5                	mov    %esp,%ebp
80100ad0:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100ad3:	83 ec 0c             	sub    $0xc,%esp
80100ad6:	ff 75 08             	push   0x8(%ebp)
80100ad9:	e8 07 10 00 00       	call   80101ae5 <iunlock>
80100ade:	83 c4 10             	add    $0x10,%esp
  acquire(&cons.lock);
80100ae1:	83 ec 0c             	sub    $0xc,%esp
80100ae4:	68 80 f7 10 80       	push   $0x8010f780
80100ae9:	e8 dc 45 00 00       	call   801050ca <acquire>
80100aee:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100af1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100af8:	eb 21                	jmp    80100b1b <consolewrite+0x4e>
    consputc(buf[i] & 0xff);
80100afa:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100afd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100b00:	01 d0                	add    %edx,%eax
80100b02:	0f b6 00             	movzbl (%eax),%eax
80100b05:	0f be c0             	movsbl %al,%eax
80100b08:	0f b6 c0             	movzbl %al,%eax
80100b0b:	83 ec 0c             	sub    $0xc,%esp
80100b0e:	50                   	push   %eax
80100b0f:	e8 a1 fc ff ff       	call   801007b5 <consputc>
80100b14:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++)
80100b17:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100b1e:	3b 45 10             	cmp    0x10(%ebp),%eax
80100b21:	7c d7                	jl     80100afa <consolewrite+0x2d>
  release(&cons.lock);
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	68 80 f7 10 80       	push   $0x8010f780
80100b2b:	e8 01 46 00 00       	call   80105131 <release>
80100b30:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80100b33:	83 ec 0c             	sub    $0xc,%esp
80100b36:	ff 75 08             	push   0x8(%ebp)
80100b39:	e8 49 0e 00 00       	call   80101987 <ilock>
80100b3e:	83 c4 10             	add    $0x10,%esp

  return n;
80100b41:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100b44:	c9                   	leave  
80100b45:	c3                   	ret    

80100b46 <consoleinit>:

void
consoleinit(void)
{
80100b46:	55                   	push   %ebp
80100b47:	89 e5                	mov    %esp,%ebp
80100b49:	83 ec 08             	sub    $0x8,%esp
  initlock(&cons.lock, "console");
80100b4c:	83 ec 08             	sub    $0x8,%esp
80100b4f:	68 6a 88 10 80       	push   $0x8010886a
80100b54:	68 80 f7 10 80       	push   $0x8010f780
80100b59:	e8 4a 45 00 00       	call   801050a8 <initlock>
80100b5e:	83 c4 10             	add    $0x10,%esp

  devsw[CONSOLE].write = consolewrite;
80100b61:	c7 05 cc f7 10 80 cd 	movl   $0x80100acd,0x8010f7cc
80100b68:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100b6b:	c7 05 c8 f7 10 80 be 	movl   $0x801009be,0x8010f7c8
80100b72:	09 10 80 
  cons.locking = 1;
80100b75:	c7 05 b4 f7 10 80 01 	movl   $0x1,0x8010f7b4
80100b7c:	00 00 00 

  picenable(IRQ_KBD);
80100b7f:	83 ec 0c             	sub    $0xc,%esp
80100b82:	6a 01                	push   $0x1
80100b84:	e8 e9 33 00 00       	call   80103f72 <picenable>
80100b89:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_KBD, 0);
80100b8c:	83 ec 08             	sub    $0x8,%esp
80100b8f:	6a 00                	push   $0x0
80100b91:	6a 01                	push   $0x1
80100b93:	e8 54 1f 00 00       	call   80102aec <ioapicenable>
80100b98:	83 c4 10             	add    $0x10,%esp
}
80100b9b:	90                   	nop
80100b9c:	c9                   	leave  
80100b9d:	c3                   	ret    

80100b9e <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100b9e:	55                   	push   %ebp
80100b9f:	89 e5                	mov    %esp,%ebp
80100ba1:	81 ec 18 01 00 00    	sub    $0x118,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100ba7:	e8 ca 29 00 00       	call   80103576 <begin_op>
  if((ip = namei(path)) == 0){
80100bac:	83 ec 0c             	sub    $0xc,%esp
80100baf:	ff 75 08             	push   0x8(%ebp)
80100bb2:	e8 81 19 00 00       	call   80102538 <namei>
80100bb7:	83 c4 10             	add    $0x10,%esp
80100bba:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100bbd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100bc1:	75 0f                	jne    80100bd2 <exec+0x34>
    end_op();
80100bc3:	e8 3a 2a 00 00       	call   80103602 <end_op>
    return -1;
80100bc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bcd:	e9 ce 03 00 00       	jmp    80100fa0 <exec+0x402>
  }
  ilock(ip);
80100bd2:	83 ec 0c             	sub    $0xc,%esp
80100bd5:	ff 75 d8             	push   -0x28(%ebp)
80100bd8:	e8 aa 0d 00 00       	call   80101987 <ilock>
80100bdd:	83 c4 10             	add    $0x10,%esp
  pgdir = 0;
80100be0:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100be7:	6a 34                	push   $0x34
80100be9:	6a 00                	push   $0x0
80100beb:	8d 85 0c ff ff ff    	lea    -0xf4(%ebp),%eax
80100bf1:	50                   	push   %eax
80100bf2:	ff 75 d8             	push   -0x28(%ebp)
80100bf5:	e8 f6 12 00 00       	call   80101ef0 <readi>
80100bfa:	83 c4 10             	add    $0x10,%esp
80100bfd:	83 f8 33             	cmp    $0x33,%eax
80100c00:	0f 86 49 03 00 00    	jbe    80100f4f <exec+0x3b1>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100c06:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c0c:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100c11:	0f 85 3b 03 00 00    	jne    80100f52 <exec+0x3b4>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100c17:	e8 cf 73 00 00       	call   80107feb <setupkvm>
80100c1c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100c1f:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100c23:	0f 84 2c 03 00 00    	je     80100f55 <exec+0x3b7>
    goto bad;

  // Load program into memory.
  sz = 0;
80100c29:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c30:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100c37:	8b 85 28 ff ff ff    	mov    -0xd8(%ebp),%eax
80100c3d:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c40:	e9 ab 00 00 00       	jmp    80100cf0 <exec+0x152>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c45:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c48:	6a 20                	push   $0x20
80100c4a:	50                   	push   %eax
80100c4b:	8d 85 ec fe ff ff    	lea    -0x114(%ebp),%eax
80100c51:	50                   	push   %eax
80100c52:	ff 75 d8             	push   -0x28(%ebp)
80100c55:	e8 96 12 00 00       	call   80101ef0 <readi>
80100c5a:	83 c4 10             	add    $0x10,%esp
80100c5d:	83 f8 20             	cmp    $0x20,%eax
80100c60:	0f 85 f2 02 00 00    	jne    80100f58 <exec+0x3ba>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100c66:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100c6c:	83 f8 01             	cmp    $0x1,%eax
80100c6f:	75 71                	jne    80100ce2 <exec+0x144>
      continue;
    if(ph.memsz < ph.filesz)
80100c71:	8b 95 00 ff ff ff    	mov    -0x100(%ebp),%edx
80100c77:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c7d:	39 c2                	cmp    %eax,%edx
80100c7f:	0f 82 d6 02 00 00    	jb     80100f5b <exec+0x3bd>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100c85:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100c8b:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
80100c91:	01 d0                	add    %edx,%eax
80100c93:	83 ec 04             	sub    $0x4,%esp
80100c96:	50                   	push   %eax
80100c97:	ff 75 e0             	push   -0x20(%ebp)
80100c9a:	ff 75 d4             	push   -0x2c(%ebp)
80100c9d:	e8 f1 76 00 00       	call   80108393 <allocuvm>
80100ca2:	83 c4 10             	add    $0x10,%esp
80100ca5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100ca8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cac:	0f 84 ac 02 00 00    	je     80100f5e <exec+0x3c0>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100cb2:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100cb8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100cbe:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100cc4:	83 ec 0c             	sub    $0xc,%esp
80100cc7:	52                   	push   %edx
80100cc8:	50                   	push   %eax
80100cc9:	ff 75 d8             	push   -0x28(%ebp)
80100ccc:	51                   	push   %ecx
80100ccd:	ff 75 d4             	push   -0x2c(%ebp)
80100cd0:	e8 e7 75 00 00       	call   801082bc <loaduvm>
80100cd5:	83 c4 20             	add    $0x20,%esp
80100cd8:	85 c0                	test   %eax,%eax
80100cda:	0f 88 81 02 00 00    	js     80100f61 <exec+0x3c3>
80100ce0:	eb 01                	jmp    80100ce3 <exec+0x145>
      continue;
80100ce2:	90                   	nop
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ce3:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100ce7:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100cea:	83 c0 20             	add    $0x20,%eax
80100ced:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100cf0:	0f b7 85 38 ff ff ff 	movzwl -0xc8(%ebp),%eax
80100cf7:	0f b7 c0             	movzwl %ax,%eax
80100cfa:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80100cfd:	0f 8c 42 ff ff ff    	jl     80100c45 <exec+0xa7>
      goto bad;
  }
  iunlockput(ip);
80100d03:	83 ec 0c             	sub    $0xc,%esp
80100d06:	ff 75 d8             	push   -0x28(%ebp)
80100d09:	e8 39 0f 00 00       	call   80101c47 <iunlockput>
80100d0e:	83 c4 10             	add    $0x10,%esp
  end_op();
80100d11:	e8 ec 28 00 00       	call   80103602 <end_op>
  ip = 0;
80100d16:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d20:	05 ff 0f 00 00       	add    $0xfff,%eax
80100d25:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100d2a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d30:	05 00 20 00 00       	add    $0x2000,%eax
80100d35:	83 ec 04             	sub    $0x4,%esp
80100d38:	50                   	push   %eax
80100d39:	ff 75 e0             	push   -0x20(%ebp)
80100d3c:	ff 75 d4             	push   -0x2c(%ebp)
80100d3f:	e8 4f 76 00 00       	call   80108393 <allocuvm>
80100d44:	83 c4 10             	add    $0x10,%esp
80100d47:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d4a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100d4e:	0f 84 10 02 00 00    	je     80100f64 <exec+0x3c6>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100d54:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d57:	2d 00 20 00 00       	sub    $0x2000,%eax
80100d5c:	83 ec 08             	sub    $0x8,%esp
80100d5f:	50                   	push   %eax
80100d60:	ff 75 d4             	push   -0x2c(%ebp)
80100d63:	e8 4f 78 00 00       	call   801085b7 <clearpteu>
80100d68:	83 c4 10             	add    $0x10,%esp
  sp = sz;
80100d6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d6e:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d78:	e9 96 00 00 00       	jmp    80100e13 <exec+0x275>
    if(argc >= MAXARG)
80100d7d:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d81:	0f 87 e0 01 00 00    	ja     80100f67 <exec+0x3c9>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d8a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d91:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d94:	01 d0                	add    %edx,%eax
80100d96:	8b 00                	mov    (%eax),%eax
80100d98:	83 ec 0c             	sub    $0xc,%esp
80100d9b:	50                   	push   %eax
80100d9c:	e8 da 47 00 00       	call   8010557b <strlen>
80100da1:	83 c4 10             	add    $0x10,%esp
80100da4:	89 c2                	mov    %eax,%edx
80100da6:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100da9:	29 d0                	sub    %edx,%eax
80100dab:	83 e8 01             	sub    $0x1,%eax
80100dae:	83 e0 fc             	and    $0xfffffffc,%eax
80100db1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100db4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100db7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
80100dc1:	01 d0                	add    %edx,%eax
80100dc3:	8b 00                	mov    (%eax),%eax
80100dc5:	83 ec 0c             	sub    $0xc,%esp
80100dc8:	50                   	push   %eax
80100dc9:	e8 ad 47 00 00       	call   8010557b <strlen>
80100dce:	83 c4 10             	add    $0x10,%esp
80100dd1:	83 c0 01             	add    $0x1,%eax
80100dd4:	89 c2                	mov    %eax,%edx
80100dd6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100dd9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100de0:	8b 45 0c             	mov    0xc(%ebp),%eax
80100de3:	01 c8                	add    %ecx,%eax
80100de5:	8b 00                	mov    (%eax),%eax
80100de7:	52                   	push   %edx
80100de8:	50                   	push   %eax
80100de9:	ff 75 dc             	push   -0x24(%ebp)
80100dec:	ff 75 d4             	push   -0x2c(%ebp)
80100def:	e8 79 79 00 00       	call   8010876d <copyout>
80100df4:	83 c4 10             	add    $0x10,%esp
80100df7:	85 c0                	test   %eax,%eax
80100df9:	0f 88 6b 01 00 00    	js     80100f6a <exec+0x3cc>
      goto bad;
    ustack[3+argc] = sp;
80100dff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e02:	8d 50 03             	lea    0x3(%eax),%edx
80100e05:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e08:	89 84 95 40 ff ff ff 	mov    %eax,-0xc0(%ebp,%edx,4)
  for(argc = 0; argv[argc]; argc++) {
80100e0f:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100e13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e16:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e1d:	8b 45 0c             	mov    0xc(%ebp),%eax
80100e20:	01 d0                	add    %edx,%eax
80100e22:	8b 00                	mov    (%eax),%eax
80100e24:	85 c0                	test   %eax,%eax
80100e26:	0f 85 51 ff ff ff    	jne    80100d7d <exec+0x1df>
  }
  ustack[3+argc] = 0;
80100e2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e2f:	83 c0 03             	add    $0x3,%eax
80100e32:	c7 84 85 40 ff ff ff 	movl   $0x0,-0xc0(%ebp,%eax,4)
80100e39:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100e3d:	c7 85 40 ff ff ff ff 	movl   $0xffffffff,-0xc0(%ebp)
80100e44:	ff ff ff 
  ustack[1] = argc;
80100e47:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e4a:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e53:	83 c0 01             	add    $0x1,%eax
80100e56:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e60:	29 d0                	sub    %edx,%eax
80100e62:	89 85 48 ff ff ff    	mov    %eax,-0xb8(%ebp)

  sp -= (3+argc+1) * 4;
80100e68:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e6b:	83 c0 04             	add    $0x4,%eax
80100e6e:	c1 e0 02             	shl    $0x2,%eax
80100e71:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e77:	83 c0 04             	add    $0x4,%eax
80100e7a:	c1 e0 02             	shl    $0x2,%eax
80100e7d:	50                   	push   %eax
80100e7e:	8d 85 40 ff ff ff    	lea    -0xc0(%ebp),%eax
80100e84:	50                   	push   %eax
80100e85:	ff 75 dc             	push   -0x24(%ebp)
80100e88:	ff 75 d4             	push   -0x2c(%ebp)
80100e8b:	e8 dd 78 00 00       	call   8010876d <copyout>
80100e90:	83 c4 10             	add    $0x10,%esp
80100e93:	85 c0                	test   %eax,%eax
80100e95:	0f 88 d2 00 00 00    	js     80100f6d <exec+0x3cf>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e9b:	8b 45 08             	mov    0x8(%ebp),%eax
80100e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ea4:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100ea7:	eb 17                	jmp    80100ec0 <exec+0x322>
    if(*s == '/')
80100ea9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eac:	0f b6 00             	movzbl (%eax),%eax
80100eaf:	3c 2f                	cmp    $0x2f,%al
80100eb1:	75 09                	jne    80100ebc <exec+0x31e>
      last = s+1;
80100eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100eb6:	83 c0 01             	add    $0x1,%eax
80100eb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(last=s=path; *s; s++)
80100ebc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100ec3:	0f b6 00             	movzbl (%eax),%eax
80100ec6:	84 c0                	test   %al,%al
80100ec8:	75 df                	jne    80100ea9 <exec+0x30b>
  safestrcpy(proc->name, last, sizeof(proc->name));
80100eca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed0:	83 c0 6c             	add    $0x6c,%eax
80100ed3:	83 ec 04             	sub    $0x4,%esp
80100ed6:	6a 10                	push   $0x10
80100ed8:	ff 75 f0             	push   -0x10(%ebp)
80100edb:	50                   	push   %eax
80100edc:	e8 4f 46 00 00       	call   80105530 <safestrcpy>
80100ee1:	83 c4 10             	add    $0x10,%esp

  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100ee4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eea:	8b 40 04             	mov    0x4(%eax),%eax
80100eed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  proc->pgdir = pgdir;
80100ef0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ef6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ef9:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100efc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f02:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100f05:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100f07:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f0d:	8b 40 18             	mov    0x18(%eax),%eax
80100f10:	8b 95 24 ff ff ff    	mov    -0xdc(%ebp),%edx
80100f16:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100f19:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f1f:	8b 40 18             	mov    0x18(%eax),%eax
80100f22:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100f25:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100f28:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100f2e:	83 ec 0c             	sub    $0xc,%esp
80100f31:	50                   	push   %eax
80100f32:	e8 9b 71 00 00       	call   801080d2 <switchuvm>
80100f37:	83 c4 10             	add    $0x10,%esp
  freevm(oldpgdir);
80100f3a:	83 ec 0c             	sub    $0xc,%esp
80100f3d:	ff 75 d0             	push   -0x30(%ebp)
80100f40:	e8 d2 75 00 00       	call   80108517 <freevm>
80100f45:	83 c4 10             	add    $0x10,%esp
  return 0;
80100f48:	b8 00 00 00 00       	mov    $0x0,%eax
80100f4d:	eb 51                	jmp    80100fa0 <exec+0x402>
    goto bad;
80100f4f:	90                   	nop
80100f50:	eb 1c                	jmp    80100f6e <exec+0x3d0>
    goto bad;
80100f52:	90                   	nop
80100f53:	eb 19                	jmp    80100f6e <exec+0x3d0>
    goto bad;
80100f55:	90                   	nop
80100f56:	eb 16                	jmp    80100f6e <exec+0x3d0>
      goto bad;
80100f58:	90                   	nop
80100f59:	eb 13                	jmp    80100f6e <exec+0x3d0>
      goto bad;
80100f5b:	90                   	nop
80100f5c:	eb 10                	jmp    80100f6e <exec+0x3d0>
      goto bad;
80100f5e:	90                   	nop
80100f5f:	eb 0d                	jmp    80100f6e <exec+0x3d0>
      goto bad;
80100f61:	90                   	nop
80100f62:	eb 0a                	jmp    80100f6e <exec+0x3d0>
    goto bad;
80100f64:	90                   	nop
80100f65:	eb 07                	jmp    80100f6e <exec+0x3d0>
      goto bad;
80100f67:	90                   	nop
80100f68:	eb 04                	jmp    80100f6e <exec+0x3d0>
      goto bad;
80100f6a:	90                   	nop
80100f6b:	eb 01                	jmp    80100f6e <exec+0x3d0>
    goto bad;
80100f6d:	90                   	nop

 bad:
  if(pgdir)
80100f6e:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f72:	74 0e                	je     80100f82 <exec+0x3e4>
    freevm(pgdir);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 75 d4             	push   -0x2c(%ebp)
80100f7a:	e8 98 75 00 00       	call   80108517 <freevm>
80100f7f:	83 c4 10             	add    $0x10,%esp
  if(ip){
80100f82:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f86:	74 13                	je     80100f9b <exec+0x3fd>
    iunlockput(ip);
80100f88:	83 ec 0c             	sub    $0xc,%esp
80100f8b:	ff 75 d8             	push   -0x28(%ebp)
80100f8e:	e8 b4 0c 00 00       	call   80101c47 <iunlockput>
80100f93:	83 c4 10             	add    $0x10,%esp
    end_op();
80100f96:	e8 67 26 00 00       	call   80103602 <end_op>
  }
  return -1;
80100f9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100fa0:	c9                   	leave  
80100fa1:	c3                   	ret    

80100fa2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100fa2:	55                   	push   %ebp
80100fa3:	89 e5                	mov    %esp,%ebp
80100fa5:	83 ec 08             	sub    $0x8,%esp
  initlock(&ftable.lock, "ftable");
80100fa8:	83 ec 08             	sub    $0x8,%esp
80100fab:	68 72 88 10 80       	push   $0x80108872
80100fb0:	68 20 f8 10 80       	push   $0x8010f820
80100fb5:	e8 ee 40 00 00       	call   801050a8 <initlock>
80100fba:	83 c4 10             	add    $0x10,%esp
}
80100fbd:	90                   	nop
80100fbe:	c9                   	leave  
80100fbf:	c3                   	ret    

80100fc0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	83 ec 18             	sub    $0x18,%esp
  struct file *f;

  acquire(&ftable.lock);
80100fc6:	83 ec 0c             	sub    $0xc,%esp
80100fc9:	68 20 f8 10 80       	push   $0x8010f820
80100fce:	e8 f7 40 00 00       	call   801050ca <acquire>
80100fd3:	83 c4 10             	add    $0x10,%esp
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fd6:	c7 45 f4 54 f8 10 80 	movl   $0x8010f854,-0xc(%ebp)
80100fdd:	eb 2d                	jmp    8010100c <filealloc+0x4c>
    if(f->ref == 0){
80100fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fe2:	8b 40 04             	mov    0x4(%eax),%eax
80100fe5:	85 c0                	test   %eax,%eax
80100fe7:	75 1f                	jne    80101008 <filealloc+0x48>
      f->ref = 1;
80100fe9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100fec:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100ff3:	83 ec 0c             	sub    $0xc,%esp
80100ff6:	68 20 f8 10 80       	push   $0x8010f820
80100ffb:	e8 31 41 00 00       	call   80105131 <release>
80101000:	83 c4 10             	add    $0x10,%esp
      return f;
80101003:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101006:	eb 23                	jmp    8010102b <filealloc+0x6b>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80101008:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
8010100c:	b8 b4 01 11 80       	mov    $0x801101b4,%eax
80101011:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80101014:	72 c9                	jb     80100fdf <filealloc+0x1f>
    }
  }
  release(&ftable.lock);
80101016:	83 ec 0c             	sub    $0xc,%esp
80101019:	68 20 f8 10 80       	push   $0x8010f820
8010101e:	e8 0e 41 00 00       	call   80105131 <release>
80101023:	83 c4 10             	add    $0x10,%esp
  return 0;
80101026:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010102b:	c9                   	leave  
8010102c:	c3                   	ret    

8010102d <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
8010102d:	55                   	push   %ebp
8010102e:	89 e5                	mov    %esp,%ebp
80101030:	83 ec 08             	sub    $0x8,%esp
  acquire(&ftable.lock);
80101033:	83 ec 0c             	sub    $0xc,%esp
80101036:	68 20 f8 10 80       	push   $0x8010f820
8010103b:	e8 8a 40 00 00       	call   801050ca <acquire>
80101040:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101043:	8b 45 08             	mov    0x8(%ebp),%eax
80101046:	8b 40 04             	mov    0x4(%eax),%eax
80101049:	85 c0                	test   %eax,%eax
8010104b:	7f 0d                	jg     8010105a <filedup+0x2d>
    panic("filedup");
8010104d:	83 ec 0c             	sub    $0xc,%esp
80101050:	68 79 88 10 80       	push   $0x80108879
80101055:	e8 21 f5 ff ff       	call   8010057b <panic>
  f->ref++;
8010105a:	8b 45 08             	mov    0x8(%ebp),%eax
8010105d:	8b 40 04             	mov    0x4(%eax),%eax
80101060:	8d 50 01             	lea    0x1(%eax),%edx
80101063:	8b 45 08             	mov    0x8(%ebp),%eax
80101066:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80101069:	83 ec 0c             	sub    $0xc,%esp
8010106c:	68 20 f8 10 80       	push   $0x8010f820
80101071:	e8 bb 40 00 00       	call   80105131 <release>
80101076:	83 c4 10             	add    $0x10,%esp
  return f;
80101079:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010107c:	c9                   	leave  
8010107d:	c3                   	ret    

8010107e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
8010107e:	55                   	push   %ebp
8010107f:	89 e5                	mov    %esp,%ebp
80101081:	83 ec 28             	sub    $0x28,%esp
  struct file ff;

  acquire(&ftable.lock);
80101084:	83 ec 0c             	sub    $0xc,%esp
80101087:	68 20 f8 10 80       	push   $0x8010f820
8010108c:	e8 39 40 00 00       	call   801050ca <acquire>
80101091:	83 c4 10             	add    $0x10,%esp
  if(f->ref < 1)
80101094:	8b 45 08             	mov    0x8(%ebp),%eax
80101097:	8b 40 04             	mov    0x4(%eax),%eax
8010109a:	85 c0                	test   %eax,%eax
8010109c:	7f 0d                	jg     801010ab <fileclose+0x2d>
    panic("fileclose");
8010109e:	83 ec 0c             	sub    $0xc,%esp
801010a1:	68 81 88 10 80       	push   $0x80108881
801010a6:	e8 d0 f4 ff ff       	call   8010057b <panic>
  if(--f->ref > 0){
801010ab:	8b 45 08             	mov    0x8(%ebp),%eax
801010ae:	8b 40 04             	mov    0x4(%eax),%eax
801010b1:	8d 50 ff             	lea    -0x1(%eax),%edx
801010b4:	8b 45 08             	mov    0x8(%ebp),%eax
801010b7:	89 50 04             	mov    %edx,0x4(%eax)
801010ba:	8b 45 08             	mov    0x8(%ebp),%eax
801010bd:	8b 40 04             	mov    0x4(%eax),%eax
801010c0:	85 c0                	test   %eax,%eax
801010c2:	7e 15                	jle    801010d9 <fileclose+0x5b>
    release(&ftable.lock);
801010c4:	83 ec 0c             	sub    $0xc,%esp
801010c7:	68 20 f8 10 80       	push   $0x8010f820
801010cc:	e8 60 40 00 00       	call   80105131 <release>
801010d1:	83 c4 10             	add    $0x10,%esp
801010d4:	e9 8b 00 00 00       	jmp    80101164 <fileclose+0xe6>
    return;
  }
  ff = *f;
801010d9:	8b 45 08             	mov    0x8(%ebp),%eax
801010dc:	8b 10                	mov    (%eax),%edx
801010de:	89 55 e0             	mov    %edx,-0x20(%ebp)
801010e1:	8b 50 04             	mov    0x4(%eax),%edx
801010e4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801010e7:	8b 50 08             	mov    0x8(%eax),%edx
801010ea:	89 55 e8             	mov    %edx,-0x18(%ebp)
801010ed:	8b 50 0c             	mov    0xc(%eax),%edx
801010f0:	89 55 ec             	mov    %edx,-0x14(%ebp)
801010f3:	8b 50 10             	mov    0x10(%eax),%edx
801010f6:	89 55 f0             	mov    %edx,-0x10(%ebp)
801010f9:	8b 40 14             	mov    0x14(%eax),%eax
801010fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
801010ff:	8b 45 08             	mov    0x8(%ebp),%eax
80101102:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
80101109:	8b 45 08             	mov    0x8(%ebp),%eax
8010110c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101112:	83 ec 0c             	sub    $0xc,%esp
80101115:	68 20 f8 10 80       	push   $0x8010f820
8010111a:	e8 12 40 00 00       	call   80105131 <release>
8010111f:	83 c4 10             	add    $0x10,%esp
  
  if(ff.type == FD_PIPE)
80101122:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101125:	83 f8 01             	cmp    $0x1,%eax
80101128:	75 19                	jne    80101143 <fileclose+0xc5>
    pipeclose(ff.pipe, ff.writable);
8010112a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
8010112e:	0f be d0             	movsbl %al,%edx
80101131:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101134:	83 ec 08             	sub    $0x8,%esp
80101137:	52                   	push   %edx
80101138:	50                   	push   %eax
80101139:	e8 9c 30 00 00       	call   801041da <pipeclose>
8010113e:	83 c4 10             	add    $0x10,%esp
80101141:	eb 21                	jmp    80101164 <fileclose+0xe6>
  else if(ff.type == FD_INODE){
80101143:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101146:	83 f8 02             	cmp    $0x2,%eax
80101149:	75 19                	jne    80101164 <fileclose+0xe6>
    begin_op();
8010114b:	e8 26 24 00 00       	call   80103576 <begin_op>
    iput(ff.ip);
80101150:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101153:	83 ec 0c             	sub    $0xc,%esp
80101156:	50                   	push   %eax
80101157:	e8 fb 09 00 00       	call   80101b57 <iput>
8010115c:	83 c4 10             	add    $0x10,%esp
    end_op();
8010115f:	e8 9e 24 00 00       	call   80103602 <end_op>
  }
}
80101164:	c9                   	leave  
80101165:	c3                   	ret    

80101166 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101166:	55                   	push   %ebp
80101167:	89 e5                	mov    %esp,%ebp
80101169:	83 ec 08             	sub    $0x8,%esp
  if(f->type == FD_INODE){
8010116c:	8b 45 08             	mov    0x8(%ebp),%eax
8010116f:	8b 00                	mov    (%eax),%eax
80101171:	83 f8 02             	cmp    $0x2,%eax
80101174:	75 40                	jne    801011b6 <filestat+0x50>
    ilock(f->ip);
80101176:	8b 45 08             	mov    0x8(%ebp),%eax
80101179:	8b 40 10             	mov    0x10(%eax),%eax
8010117c:	83 ec 0c             	sub    $0xc,%esp
8010117f:	50                   	push   %eax
80101180:	e8 02 08 00 00       	call   80101987 <ilock>
80101185:	83 c4 10             	add    $0x10,%esp
    stati(f->ip, st);
80101188:	8b 45 08             	mov    0x8(%ebp),%eax
8010118b:	8b 40 10             	mov    0x10(%eax),%eax
8010118e:	83 ec 08             	sub    $0x8,%esp
80101191:	ff 75 0c             	push   0xc(%ebp)
80101194:	50                   	push   %eax
80101195:	e8 10 0d 00 00       	call   80101eaa <stati>
8010119a:	83 c4 10             	add    $0x10,%esp
    iunlock(f->ip);
8010119d:	8b 45 08             	mov    0x8(%ebp),%eax
801011a0:	8b 40 10             	mov    0x10(%eax),%eax
801011a3:	83 ec 0c             	sub    $0xc,%esp
801011a6:	50                   	push   %eax
801011a7:	e8 39 09 00 00       	call   80101ae5 <iunlock>
801011ac:	83 c4 10             	add    $0x10,%esp
    return 0;
801011af:	b8 00 00 00 00       	mov    $0x0,%eax
801011b4:	eb 05                	jmp    801011bb <filestat+0x55>
  }
  return -1;
801011b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801011bb:	c9                   	leave  
801011bc:	c3                   	ret    

801011bd <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801011bd:	55                   	push   %ebp
801011be:	89 e5                	mov    %esp,%ebp
801011c0:	83 ec 18             	sub    $0x18,%esp
  int r;

  if(f->readable == 0)
801011c3:	8b 45 08             	mov    0x8(%ebp),%eax
801011c6:	0f b6 40 08          	movzbl 0x8(%eax),%eax
801011ca:	84 c0                	test   %al,%al
801011cc:	75 0a                	jne    801011d8 <fileread+0x1b>
    return -1;
801011ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801011d3:	e9 9b 00 00 00       	jmp    80101273 <fileread+0xb6>
  if(f->type == FD_PIPE)
801011d8:	8b 45 08             	mov    0x8(%ebp),%eax
801011db:	8b 00                	mov    (%eax),%eax
801011dd:	83 f8 01             	cmp    $0x1,%eax
801011e0:	75 1a                	jne    801011fc <fileread+0x3f>
    return piperead(f->pipe, addr, n);
801011e2:	8b 45 08             	mov    0x8(%ebp),%eax
801011e5:	8b 40 0c             	mov    0xc(%eax),%eax
801011e8:	83 ec 04             	sub    $0x4,%esp
801011eb:	ff 75 10             	push   0x10(%ebp)
801011ee:	ff 75 0c             	push   0xc(%ebp)
801011f1:	50                   	push   %eax
801011f2:	e8 91 31 00 00       	call   80104388 <piperead>
801011f7:	83 c4 10             	add    $0x10,%esp
801011fa:	eb 77                	jmp    80101273 <fileread+0xb6>
  if(f->type == FD_INODE){
801011fc:	8b 45 08             	mov    0x8(%ebp),%eax
801011ff:	8b 00                	mov    (%eax),%eax
80101201:	83 f8 02             	cmp    $0x2,%eax
80101204:	75 60                	jne    80101266 <fileread+0xa9>
    ilock(f->ip);
80101206:	8b 45 08             	mov    0x8(%ebp),%eax
80101209:	8b 40 10             	mov    0x10(%eax),%eax
8010120c:	83 ec 0c             	sub    $0xc,%esp
8010120f:	50                   	push   %eax
80101210:	e8 72 07 00 00       	call   80101987 <ilock>
80101215:	83 c4 10             	add    $0x10,%esp
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101218:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010121b:	8b 45 08             	mov    0x8(%ebp),%eax
8010121e:	8b 50 14             	mov    0x14(%eax),%edx
80101221:	8b 45 08             	mov    0x8(%ebp),%eax
80101224:	8b 40 10             	mov    0x10(%eax),%eax
80101227:	51                   	push   %ecx
80101228:	52                   	push   %edx
80101229:	ff 75 0c             	push   0xc(%ebp)
8010122c:	50                   	push   %eax
8010122d:	e8 be 0c 00 00       	call   80101ef0 <readi>
80101232:	83 c4 10             	add    $0x10,%esp
80101235:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101238:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010123c:	7e 11                	jle    8010124f <fileread+0x92>
      f->off += r;
8010123e:	8b 45 08             	mov    0x8(%ebp),%eax
80101241:	8b 50 14             	mov    0x14(%eax),%edx
80101244:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101247:	01 c2                	add    %eax,%edx
80101249:	8b 45 08             	mov    0x8(%ebp),%eax
8010124c:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
8010124f:	8b 45 08             	mov    0x8(%ebp),%eax
80101252:	8b 40 10             	mov    0x10(%eax),%eax
80101255:	83 ec 0c             	sub    $0xc,%esp
80101258:	50                   	push   %eax
80101259:	e8 87 08 00 00       	call   80101ae5 <iunlock>
8010125e:	83 c4 10             	add    $0x10,%esp
    return r;
80101261:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101264:	eb 0d                	jmp    80101273 <fileread+0xb6>
  }
  panic("fileread");
80101266:	83 ec 0c             	sub    $0xc,%esp
80101269:	68 8b 88 10 80       	push   $0x8010888b
8010126e:	e8 08 f3 ff ff       	call   8010057b <panic>
}
80101273:	c9                   	leave  
80101274:	c3                   	ret    

80101275 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101275:	55                   	push   %ebp
80101276:	89 e5                	mov    %esp,%ebp
80101278:	53                   	push   %ebx
80101279:	83 ec 14             	sub    $0x14,%esp
  int r;

  if(f->writable == 0)
8010127c:	8b 45 08             	mov    0x8(%ebp),%eax
8010127f:	0f b6 40 09          	movzbl 0x9(%eax),%eax
80101283:	84 c0                	test   %al,%al
80101285:	75 0a                	jne    80101291 <filewrite+0x1c>
    return -1;
80101287:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010128c:	e9 1b 01 00 00       	jmp    801013ac <filewrite+0x137>
  if(f->type == FD_PIPE)
80101291:	8b 45 08             	mov    0x8(%ebp),%eax
80101294:	8b 00                	mov    (%eax),%eax
80101296:	83 f8 01             	cmp    $0x1,%eax
80101299:	75 1d                	jne    801012b8 <filewrite+0x43>
    return pipewrite(f->pipe, addr, n);
8010129b:	8b 45 08             	mov    0x8(%ebp),%eax
8010129e:	8b 40 0c             	mov    0xc(%eax),%eax
801012a1:	83 ec 04             	sub    $0x4,%esp
801012a4:	ff 75 10             	push   0x10(%ebp)
801012a7:	ff 75 0c             	push   0xc(%ebp)
801012aa:	50                   	push   %eax
801012ab:	e8 d5 2f 00 00       	call   80104285 <pipewrite>
801012b0:	83 c4 10             	add    $0x10,%esp
801012b3:	e9 f4 00 00 00       	jmp    801013ac <filewrite+0x137>
  if(f->type == FD_INODE){
801012b8:	8b 45 08             	mov    0x8(%ebp),%eax
801012bb:	8b 00                	mov    (%eax),%eax
801012bd:	83 f8 02             	cmp    $0x2,%eax
801012c0:	0f 85 d9 00 00 00    	jne    8010139f <filewrite+0x12a>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
801012c6:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
801012cd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
801012d4:	e9 a3 00 00 00       	jmp    8010137c <filewrite+0x107>
      int n1 = n - i;
801012d9:	8b 45 10             	mov    0x10(%ebp),%eax
801012dc:	2b 45 f4             	sub    -0xc(%ebp),%eax
801012df:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
801012e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801012e5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
801012e8:	7e 06                	jle    801012f0 <filewrite+0x7b>
        n1 = max;
801012ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
801012ed:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
801012f0:	e8 81 22 00 00       	call   80103576 <begin_op>
      ilock(f->ip);
801012f5:	8b 45 08             	mov    0x8(%ebp),%eax
801012f8:	8b 40 10             	mov    0x10(%eax),%eax
801012fb:	83 ec 0c             	sub    $0xc,%esp
801012fe:	50                   	push   %eax
801012ff:	e8 83 06 00 00       	call   80101987 <ilock>
80101304:	83 c4 10             	add    $0x10,%esp
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101307:	8b 4d f0             	mov    -0x10(%ebp),%ecx
8010130a:	8b 45 08             	mov    0x8(%ebp),%eax
8010130d:	8b 50 14             	mov    0x14(%eax),%edx
80101310:	8b 5d f4             	mov    -0xc(%ebp),%ebx
80101313:	8b 45 0c             	mov    0xc(%ebp),%eax
80101316:	01 c3                	add    %eax,%ebx
80101318:	8b 45 08             	mov    0x8(%ebp),%eax
8010131b:	8b 40 10             	mov    0x10(%eax),%eax
8010131e:	51                   	push   %ecx
8010131f:	52                   	push   %edx
80101320:	53                   	push   %ebx
80101321:	50                   	push   %eax
80101322:	e8 1e 0d 00 00       	call   80102045 <writei>
80101327:	83 c4 10             	add    $0x10,%esp
8010132a:	89 45 e8             	mov    %eax,-0x18(%ebp)
8010132d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80101331:	7e 11                	jle    80101344 <filewrite+0xcf>
        f->off += r;
80101333:	8b 45 08             	mov    0x8(%ebp),%eax
80101336:	8b 50 14             	mov    0x14(%eax),%edx
80101339:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010133c:	01 c2                	add    %eax,%edx
8010133e:	8b 45 08             	mov    0x8(%ebp),%eax
80101341:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
80101344:	8b 45 08             	mov    0x8(%ebp),%eax
80101347:	8b 40 10             	mov    0x10(%eax),%eax
8010134a:	83 ec 0c             	sub    $0xc,%esp
8010134d:	50                   	push   %eax
8010134e:	e8 92 07 00 00       	call   80101ae5 <iunlock>
80101353:	83 c4 10             	add    $0x10,%esp
      end_op();
80101356:	e8 a7 22 00 00       	call   80103602 <end_op>

      if(r < 0)
8010135b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010135f:	78 29                	js     8010138a <filewrite+0x115>
        break;
      if(r != n1)
80101361:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101364:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80101367:	74 0d                	je     80101376 <filewrite+0x101>
        panic("short filewrite");
80101369:	83 ec 0c             	sub    $0xc,%esp
8010136c:	68 94 88 10 80       	push   $0x80108894
80101371:	e8 05 f2 ff ff       	call   8010057b <panic>
      i += r;
80101376:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101379:	01 45 f4             	add    %eax,-0xc(%ebp)
    while(i < n){
8010137c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010137f:	3b 45 10             	cmp    0x10(%ebp),%eax
80101382:	0f 8c 51 ff ff ff    	jl     801012d9 <filewrite+0x64>
80101388:	eb 01                	jmp    8010138b <filewrite+0x116>
        break;
8010138a:	90                   	nop
    }
    return i == n ? n : -1;
8010138b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138e:	3b 45 10             	cmp    0x10(%ebp),%eax
80101391:	75 05                	jne    80101398 <filewrite+0x123>
80101393:	8b 45 10             	mov    0x10(%ebp),%eax
80101396:	eb 14                	jmp    801013ac <filewrite+0x137>
80101398:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010139d:	eb 0d                	jmp    801013ac <filewrite+0x137>
  }
  panic("filewrite");
8010139f:	83 ec 0c             	sub    $0xc,%esp
801013a2:	68 a4 88 10 80       	push   $0x801088a4
801013a7:	e8 cf f1 ff ff       	call   8010057b <panic>
}
801013ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013af:	c9                   	leave  
801013b0:	c3                   	ret    

801013b1 <readsb>:
struct superblock sb;   // there should be one per dev, but we run with one dev

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b1:	55                   	push   %ebp
801013b2:	89 e5                	mov    %esp,%ebp
801013b4:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
801013b7:	8b 45 08             	mov    0x8(%ebp),%eax
801013ba:	83 ec 08             	sub    $0x8,%esp
801013bd:	6a 01                	push   $0x1
801013bf:	50                   	push   %eax
801013c0:	e8 f2 ed ff ff       	call   801001b7 <bread>
801013c5:	83 c4 10             	add    $0x10,%esp
801013c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
801013cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ce:	83 c0 18             	add    $0x18,%eax
801013d1:	83 ec 04             	sub    $0x4,%esp
801013d4:	6a 1c                	push   $0x1c
801013d6:	50                   	push   %eax
801013d7:	ff 75 0c             	push   0xc(%ebp)
801013da:	e8 0d 40 00 00       	call   801053ec <memmove>
801013df:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
801013e2:	83 ec 0c             	sub    $0xc,%esp
801013e5:	ff 75 f4             	push   -0xc(%ebp)
801013e8:	e8 42 ee ff ff       	call   8010022f <brelse>
801013ed:	83 c4 10             	add    $0x10,%esp
}
801013f0:	90                   	nop
801013f1:	c9                   	leave  
801013f2:	c3                   	ret    

801013f3 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
801013f3:	55                   	push   %ebp
801013f4:	89 e5                	mov    %esp,%ebp
801013f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
801013f9:	8b 55 0c             	mov    0xc(%ebp),%edx
801013fc:	8b 45 08             	mov    0x8(%ebp),%eax
801013ff:	83 ec 08             	sub    $0x8,%esp
80101402:	52                   	push   %edx
80101403:	50                   	push   %eax
80101404:	e8 ae ed ff ff       	call   801001b7 <bread>
80101409:	83 c4 10             	add    $0x10,%esp
8010140c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010140f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101412:	83 c0 18             	add    $0x18,%eax
80101415:	83 ec 04             	sub    $0x4,%esp
80101418:	68 00 02 00 00       	push   $0x200
8010141d:	6a 00                	push   $0x0
8010141f:	50                   	push   %eax
80101420:	e8 08 3f 00 00       	call   8010532d <memset>
80101425:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
80101428:	83 ec 0c             	sub    $0xc,%esp
8010142b:	ff 75 f4             	push   -0xc(%ebp)
8010142e:	e8 7c 23 00 00       	call   801037af <log_write>
80101433:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
80101436:	83 ec 0c             	sub    $0xc,%esp
80101439:	ff 75 f4             	push   -0xc(%ebp)
8010143c:	e8 ee ed ff ff       	call   8010022f <brelse>
80101441:	83 c4 10             	add    $0x10,%esp
}
80101444:	90                   	nop
80101445:	c9                   	leave  
80101446:	c3                   	ret    

80101447 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101447:	55                   	push   %ebp
80101448:	89 e5                	mov    %esp,%ebp
8010144a:	83 ec 18             	sub    $0x18,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
8010144d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101454:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010145b:	e9 0b 01 00 00       	jmp    8010156b <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
80101460:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101463:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80101469:	85 c0                	test   %eax,%eax
8010146b:	0f 48 c2             	cmovs  %edx,%eax
8010146e:	c1 f8 0c             	sar    $0xc,%eax
80101471:	89 c2                	mov    %eax,%edx
80101473:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80101478:	01 d0                	add    %edx,%eax
8010147a:	83 ec 08             	sub    $0x8,%esp
8010147d:	50                   	push   %eax
8010147e:	ff 75 08             	push   0x8(%ebp)
80101481:	e8 31 ed ff ff       	call   801001b7 <bread>
80101486:	83 c4 10             	add    $0x10,%esp
80101489:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010148c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101493:	e9 9e 00 00 00       	jmp    80101536 <balloc+0xef>
      m = 1 << (bi % 8);
80101498:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010149b:	83 e0 07             	and    $0x7,%eax
8010149e:	ba 01 00 00 00       	mov    $0x1,%edx
801014a3:	89 c1                	mov    %eax,%ecx
801014a5:	d3 e2                	shl    %cl,%edx
801014a7:	89 d0                	mov    %edx,%eax
801014a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801014ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014af:	8d 50 07             	lea    0x7(%eax),%edx
801014b2:	85 c0                	test   %eax,%eax
801014b4:	0f 48 c2             	cmovs  %edx,%eax
801014b7:	c1 f8 03             	sar    $0x3,%eax
801014ba:	89 c2                	mov    %eax,%edx
801014bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014bf:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801014c4:	0f b6 c0             	movzbl %al,%eax
801014c7:	23 45 e8             	and    -0x18(%ebp),%eax
801014ca:	85 c0                	test   %eax,%eax
801014cc:	75 64                	jne    80101532 <balloc+0xeb>
        bp->data[bi/8] |= m;  // Mark block in use.
801014ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d1:	8d 50 07             	lea    0x7(%eax),%edx
801014d4:	85 c0                	test   %eax,%eax
801014d6:	0f 48 c2             	cmovs  %edx,%eax
801014d9:	c1 f8 03             	sar    $0x3,%eax
801014dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014df:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801014e4:	89 d1                	mov    %edx,%ecx
801014e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
801014e9:	09 ca                	or     %ecx,%edx
801014eb:	89 d1                	mov    %edx,%ecx
801014ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
801014f0:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
801014f4:	83 ec 0c             	sub    $0xc,%esp
801014f7:	ff 75 ec             	push   -0x14(%ebp)
801014fa:	e8 b0 22 00 00       	call   801037af <log_write>
801014ff:	83 c4 10             	add    $0x10,%esp
        brelse(bp);
80101502:	83 ec 0c             	sub    $0xc,%esp
80101505:	ff 75 ec             	push   -0x14(%ebp)
80101508:	e8 22 ed ff ff       	call   8010022f <brelse>
8010150d:	83 c4 10             	add    $0x10,%esp
        bzero(dev, b + bi);
80101510:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101513:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101516:	01 c2                	add    %eax,%edx
80101518:	8b 45 08             	mov    0x8(%ebp),%eax
8010151b:	83 ec 08             	sub    $0x8,%esp
8010151e:	52                   	push   %edx
8010151f:	50                   	push   %eax
80101520:	e8 ce fe ff ff       	call   801013f3 <bzero>
80101525:	83 c4 10             	add    $0x10,%esp
        return b + bi;
80101528:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010152b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010152e:	01 d0                	add    %edx,%eax
80101530:	eb 57                	jmp    80101589 <balloc+0x142>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101532:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101536:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
8010153d:	7f 17                	jg     80101556 <balloc+0x10f>
8010153f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101542:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101545:	01 d0                	add    %edx,%eax
80101547:	89 c2                	mov    %eax,%edx
80101549:	a1 c0 01 11 80       	mov    0x801101c0,%eax
8010154e:	39 c2                	cmp    %eax,%edx
80101550:	0f 82 42 ff ff ff    	jb     80101498 <balloc+0x51>
      }
    }
    brelse(bp);
80101556:	83 ec 0c             	sub    $0xc,%esp
80101559:	ff 75 ec             	push   -0x14(%ebp)
8010155c:	e8 ce ec ff ff       	call   8010022f <brelse>
80101561:	83 c4 10             	add    $0x10,%esp
  for(b = 0; b < sb.size; b += BPB){
80101564:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010156b:	8b 15 c0 01 11 80    	mov    0x801101c0,%edx
80101571:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101574:	39 c2                	cmp    %eax,%edx
80101576:	0f 87 e4 fe ff ff    	ja     80101460 <balloc+0x19>
  }
  panic("balloc: out of blocks");
8010157c:	83 ec 0c             	sub    $0xc,%esp
8010157f:	68 b0 88 10 80       	push   $0x801088b0
80101584:	e8 f2 ef ff ff       	call   8010057b <panic>
}
80101589:	c9                   	leave  
8010158a:	c3                   	ret    

8010158b <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
8010158b:	55                   	push   %ebp
8010158c:	89 e5                	mov    %esp,%ebp
8010158e:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
80101591:	83 ec 08             	sub    $0x8,%esp
80101594:	68 c0 01 11 80       	push   $0x801101c0
80101599:	ff 75 08             	push   0x8(%ebp)
8010159c:	e8 10 fe ff ff       	call   801013b1 <readsb>
801015a1:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
801015a4:	8b 45 0c             	mov    0xc(%ebp),%eax
801015a7:	c1 e8 0c             	shr    $0xc,%eax
801015aa:	89 c2                	mov    %eax,%edx
801015ac:	a1 d8 01 11 80       	mov    0x801101d8,%eax
801015b1:	01 c2                	add    %eax,%edx
801015b3:	8b 45 08             	mov    0x8(%ebp),%eax
801015b6:	83 ec 08             	sub    $0x8,%esp
801015b9:	52                   	push   %edx
801015ba:	50                   	push   %eax
801015bb:	e8 f7 eb ff ff       	call   801001b7 <bread>
801015c0:	83 c4 10             	add    $0x10,%esp
801015c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
801015c6:	8b 45 0c             	mov    0xc(%ebp),%eax
801015c9:	25 ff 0f 00 00       	and    $0xfff,%eax
801015ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
801015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015d4:	83 e0 07             	and    $0x7,%eax
801015d7:	ba 01 00 00 00       	mov    $0x1,%edx
801015dc:	89 c1                	mov    %eax,%ecx
801015de:	d3 e2                	shl    %cl,%edx
801015e0:	89 d0                	mov    %edx,%eax
801015e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
801015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015e8:	8d 50 07             	lea    0x7(%eax),%edx
801015eb:	85 c0                	test   %eax,%eax
801015ed:	0f 48 c2             	cmovs  %edx,%eax
801015f0:	c1 f8 03             	sar    $0x3,%eax
801015f3:	89 c2                	mov    %eax,%edx
801015f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015f8:	0f b6 44 10 18       	movzbl 0x18(%eax,%edx,1),%eax
801015fd:	0f b6 c0             	movzbl %al,%eax
80101600:	23 45 ec             	and    -0x14(%ebp),%eax
80101603:	85 c0                	test   %eax,%eax
80101605:	75 0d                	jne    80101614 <bfree+0x89>
    panic("freeing free block");
80101607:	83 ec 0c             	sub    $0xc,%esp
8010160a:	68 c6 88 10 80       	push   $0x801088c6
8010160f:	e8 67 ef ff ff       	call   8010057b <panic>
  bp->data[bi/8] &= ~m;
80101614:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101617:	8d 50 07             	lea    0x7(%eax),%edx
8010161a:	85 c0                	test   %eax,%eax
8010161c:	0f 48 c2             	cmovs  %edx,%eax
8010161f:	c1 f8 03             	sar    $0x3,%eax
80101622:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101625:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
8010162a:	89 d1                	mov    %edx,%ecx
8010162c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010162f:	f7 d2                	not    %edx
80101631:	21 ca                	and    %ecx,%edx
80101633:	89 d1                	mov    %edx,%ecx
80101635:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101638:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
8010163c:	83 ec 0c             	sub    $0xc,%esp
8010163f:	ff 75 f4             	push   -0xc(%ebp)
80101642:	e8 68 21 00 00       	call   801037af <log_write>
80101647:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010164a:	83 ec 0c             	sub    $0xc,%esp
8010164d:	ff 75 f4             	push   -0xc(%ebp)
80101650:	e8 da eb ff ff       	call   8010022f <brelse>
80101655:	83 c4 10             	add    $0x10,%esp
}
80101658:	90                   	nop
80101659:	c9                   	leave  
8010165a:	c3                   	ret    

8010165b <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
8010165b:	55                   	push   %ebp
8010165c:	89 e5                	mov    %esp,%ebp
8010165e:	57                   	push   %edi
8010165f:	56                   	push   %esi
80101660:	53                   	push   %ebx
80101661:	83 ec 1c             	sub    $0x1c,%esp
  initlock(&icache.lock, "icache");
80101664:	83 ec 08             	sub    $0x8,%esp
80101667:	68 d9 88 10 80       	push   $0x801088d9
8010166c:	68 e0 01 11 80       	push   $0x801101e0
80101671:	e8 32 3a 00 00       	call   801050a8 <initlock>
80101676:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80101679:	83 ec 08             	sub    $0x8,%esp
8010167c:	68 c0 01 11 80       	push   $0x801101c0
80101681:	ff 75 08             	push   0x8(%ebp)
80101684:	e8 28 fd ff ff       	call   801013b1 <readsb>
80101689:	83 c4 10             	add    $0x10,%esp
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d inodestart %d bmap start %d\n", sb.size,
8010168c:	a1 d8 01 11 80       	mov    0x801101d8,%eax
80101691:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101694:	8b 3d d4 01 11 80    	mov    0x801101d4,%edi
8010169a:	8b 35 d0 01 11 80    	mov    0x801101d0,%esi
801016a0:	8b 1d cc 01 11 80    	mov    0x801101cc,%ebx
801016a6:	8b 0d c8 01 11 80    	mov    0x801101c8,%ecx
801016ac:	8b 15 c4 01 11 80    	mov    0x801101c4,%edx
801016b2:	a1 c0 01 11 80       	mov    0x801101c0,%eax
801016b7:	ff 75 e4             	push   -0x1c(%ebp)
801016ba:	57                   	push   %edi
801016bb:	56                   	push   %esi
801016bc:	53                   	push   %ebx
801016bd:	51                   	push   %ecx
801016be:	52                   	push   %edx
801016bf:	50                   	push   %eax
801016c0:	68 e0 88 10 80       	push   $0x801088e0
801016c5:	e8 fc ec ff ff       	call   801003c6 <cprintf>
801016ca:	83 c4 20             	add    $0x20,%esp
          sb.nblocks, sb.ninodes, sb.nlog, sb.logstart, sb.inodestart, sb.bmapstart);
}
801016cd:	90                   	nop
801016ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
801016d1:	5b                   	pop    %ebx
801016d2:	5e                   	pop    %esi
801016d3:	5f                   	pop    %edi
801016d4:	5d                   	pop    %ebp
801016d5:	c3                   	ret    

801016d6 <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801016d6:	55                   	push   %ebp
801016d7:	89 e5                	mov    %esp,%ebp
801016d9:	83 ec 28             	sub    $0x28,%esp
801016dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801016df:	66 89 45 e4          	mov    %ax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
801016e3:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
801016ea:	e9 9e 00 00 00       	jmp    8010178d <ialloc+0xb7>
    bp = bread(dev, IBLOCK(inum, sb));
801016ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801016f2:	c1 e8 03             	shr    $0x3,%eax
801016f5:	89 c2                	mov    %eax,%edx
801016f7:	a1 d4 01 11 80       	mov    0x801101d4,%eax
801016fc:	01 d0                	add    %edx,%eax
801016fe:	83 ec 08             	sub    $0x8,%esp
80101701:	50                   	push   %eax
80101702:	ff 75 08             	push   0x8(%ebp)
80101705:	e8 ad ea ff ff       	call   801001b7 <bread>
8010170a:	83 c4 10             	add    $0x10,%esp
8010170d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101710:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101713:	8d 50 18             	lea    0x18(%eax),%edx
80101716:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101719:	83 e0 07             	and    $0x7,%eax
8010171c:	c1 e0 06             	shl    $0x6,%eax
8010171f:	01 d0                	add    %edx,%eax
80101721:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101724:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101727:	0f b7 00             	movzwl (%eax),%eax
8010172a:	66 85 c0             	test   %ax,%ax
8010172d:	75 4c                	jne    8010177b <ialloc+0xa5>
      memset(dip, 0, sizeof(*dip));
8010172f:	83 ec 04             	sub    $0x4,%esp
80101732:	6a 40                	push   $0x40
80101734:	6a 00                	push   $0x0
80101736:	ff 75 ec             	push   -0x14(%ebp)
80101739:	e8 ef 3b 00 00       	call   8010532d <memset>
8010173e:	83 c4 10             	add    $0x10,%esp
      dip->type = type;
80101741:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101744:	0f b7 55 e4          	movzwl -0x1c(%ebp),%edx
80101748:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
8010174b:	83 ec 0c             	sub    $0xc,%esp
8010174e:	ff 75 f0             	push   -0x10(%ebp)
80101751:	e8 59 20 00 00       	call   801037af <log_write>
80101756:	83 c4 10             	add    $0x10,%esp
      brelse(bp);
80101759:	83 ec 0c             	sub    $0xc,%esp
8010175c:	ff 75 f0             	push   -0x10(%ebp)
8010175f:	e8 cb ea ff ff       	call   8010022f <brelse>
80101764:	83 c4 10             	add    $0x10,%esp
      return iget(dev, inum);
80101767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010176a:	83 ec 08             	sub    $0x8,%esp
8010176d:	50                   	push   %eax
8010176e:	ff 75 08             	push   0x8(%ebp)
80101771:	e8 f8 00 00 00       	call   8010186e <iget>
80101776:	83 c4 10             	add    $0x10,%esp
80101779:	eb 30                	jmp    801017ab <ialloc+0xd5>
    }
    brelse(bp);
8010177b:	83 ec 0c             	sub    $0xc,%esp
8010177e:	ff 75 f0             	push   -0x10(%ebp)
80101781:	e8 a9 ea ff ff       	call   8010022f <brelse>
80101786:	83 c4 10             	add    $0x10,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101789:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010178d:	8b 15 c8 01 11 80    	mov    0x801101c8,%edx
80101793:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101796:	39 c2                	cmp    %eax,%edx
80101798:	0f 87 51 ff ff ff    	ja     801016ef <ialloc+0x19>
  }
  panic("ialloc: no inodes");
8010179e:	83 ec 0c             	sub    $0xc,%esp
801017a1:	68 33 89 10 80       	push   $0x80108933
801017a6:	e8 d0 ed ff ff       	call   8010057b <panic>
}
801017ab:	c9                   	leave  
801017ac:	c3                   	ret    

801017ad <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801017ad:	55                   	push   %ebp
801017ae:	89 e5                	mov    %esp,%ebp
801017b0:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017b3:	8b 45 08             	mov    0x8(%ebp),%eax
801017b6:	8b 40 04             	mov    0x4(%eax),%eax
801017b9:	c1 e8 03             	shr    $0x3,%eax
801017bc:	89 c2                	mov    %eax,%edx
801017be:	a1 d4 01 11 80       	mov    0x801101d4,%eax
801017c3:	01 c2                	add    %eax,%edx
801017c5:	8b 45 08             	mov    0x8(%ebp),%eax
801017c8:	8b 00                	mov    (%eax),%eax
801017ca:	83 ec 08             	sub    $0x8,%esp
801017cd:	52                   	push   %edx
801017ce:	50                   	push   %eax
801017cf:	e8 e3 e9 ff ff       	call   801001b7 <bread>
801017d4:	83 c4 10             	add    $0x10,%esp
801017d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801017da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017dd:	8d 50 18             	lea    0x18(%eax),%edx
801017e0:	8b 45 08             	mov    0x8(%ebp),%eax
801017e3:	8b 40 04             	mov    0x4(%eax),%eax
801017e6:	83 e0 07             	and    $0x7,%eax
801017e9:	c1 e0 06             	shl    $0x6,%eax
801017ec:	01 d0                	add    %edx,%eax
801017ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
801017f1:	8b 45 08             	mov    0x8(%ebp),%eax
801017f4:	0f b7 50 10          	movzwl 0x10(%eax),%edx
801017f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801017fb:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017fe:	8b 45 08             	mov    0x8(%ebp),%eax
80101801:	0f b7 50 12          	movzwl 0x12(%eax),%edx
80101805:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101808:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
8010180c:	8b 45 08             	mov    0x8(%ebp),%eax
8010180f:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101813:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101816:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010181a:	8b 45 08             	mov    0x8(%ebp),%eax
8010181d:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101821:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101824:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101828:	8b 45 08             	mov    0x8(%ebp),%eax
8010182b:	8b 50 18             	mov    0x18(%eax),%edx
8010182e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101831:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101834:	8b 45 08             	mov    0x8(%ebp),%eax
80101837:	8d 50 1c             	lea    0x1c(%eax),%edx
8010183a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010183d:	83 c0 0c             	add    $0xc,%eax
80101840:	83 ec 04             	sub    $0x4,%esp
80101843:	6a 34                	push   $0x34
80101845:	52                   	push   %edx
80101846:	50                   	push   %eax
80101847:	e8 a0 3b 00 00       	call   801053ec <memmove>
8010184c:	83 c4 10             	add    $0x10,%esp
  log_write(bp);
8010184f:	83 ec 0c             	sub    $0xc,%esp
80101852:	ff 75 f4             	push   -0xc(%ebp)
80101855:	e8 55 1f 00 00       	call   801037af <log_write>
8010185a:	83 c4 10             	add    $0x10,%esp
  brelse(bp);
8010185d:	83 ec 0c             	sub    $0xc,%esp
80101860:	ff 75 f4             	push   -0xc(%ebp)
80101863:	e8 c7 e9 ff ff       	call   8010022f <brelse>
80101868:	83 c4 10             	add    $0x10,%esp
}
8010186b:	90                   	nop
8010186c:	c9                   	leave  
8010186d:	c3                   	ret    

8010186e <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010186e:	55                   	push   %ebp
8010186f:	89 e5                	mov    %esp,%ebp
80101871:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101874:	83 ec 0c             	sub    $0xc,%esp
80101877:	68 e0 01 11 80       	push   $0x801101e0
8010187c:	e8 49 38 00 00       	call   801050ca <acquire>
80101881:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
80101884:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010188b:	c7 45 f4 14 02 11 80 	movl   $0x80110214,-0xc(%ebp)
80101892:	eb 5d                	jmp    801018f1 <iget+0x83>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101894:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101897:	8b 40 08             	mov    0x8(%eax),%eax
8010189a:	85 c0                	test   %eax,%eax
8010189c:	7e 39                	jle    801018d7 <iget+0x69>
8010189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018a1:	8b 00                	mov    (%eax),%eax
801018a3:	39 45 08             	cmp    %eax,0x8(%ebp)
801018a6:	75 2f                	jne    801018d7 <iget+0x69>
801018a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ab:	8b 40 04             	mov    0x4(%eax),%eax
801018ae:	39 45 0c             	cmp    %eax,0xc(%ebp)
801018b1:	75 24                	jne    801018d7 <iget+0x69>
      ip->ref++;
801018b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018b6:	8b 40 08             	mov    0x8(%eax),%eax
801018b9:	8d 50 01             	lea    0x1(%eax),%edx
801018bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018bf:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801018c2:	83 ec 0c             	sub    $0xc,%esp
801018c5:	68 e0 01 11 80       	push   $0x801101e0
801018ca:	e8 62 38 00 00       	call   80105131 <release>
801018cf:	83 c4 10             	add    $0x10,%esp
      return ip;
801018d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018d5:	eb 74                	jmp    8010194b <iget+0xdd>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801018d7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018db:	75 10                	jne    801018ed <iget+0x7f>
801018dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018e0:	8b 40 08             	mov    0x8(%eax),%eax
801018e3:	85 c0                	test   %eax,%eax
801018e5:	75 06                	jne    801018ed <iget+0x7f>
      empty = ip;
801018e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801018ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801018ed:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
801018f1:	81 7d f4 b4 11 11 80 	cmpl   $0x801111b4,-0xc(%ebp)
801018f8:	72 9a                	jb     80101894 <iget+0x26>
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801018fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801018fe:	75 0d                	jne    8010190d <iget+0x9f>
    panic("iget: no inodes");
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 45 89 10 80       	push   $0x80108945
80101908:	e8 6e ec ff ff       	call   8010057b <panic>

  ip = empty;
8010190d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101910:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
80101913:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101916:	8b 55 08             	mov    0x8(%ebp),%edx
80101919:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
8010191b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010191e:	8b 55 0c             	mov    0xc(%ebp),%edx
80101921:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
80101924:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101927:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
8010192e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101931:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101938:	83 ec 0c             	sub    $0xc,%esp
8010193b:	68 e0 01 11 80       	push   $0x801101e0
80101940:	e8 ec 37 00 00       	call   80105131 <release>
80101945:	83 c4 10             	add    $0x10,%esp

  return ip;
80101948:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010194b:	c9                   	leave  
8010194c:	c3                   	ret    

8010194d <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
8010194d:	55                   	push   %ebp
8010194e:	89 e5                	mov    %esp,%ebp
80101950:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101953:	83 ec 0c             	sub    $0xc,%esp
80101956:	68 e0 01 11 80       	push   $0x801101e0
8010195b:	e8 6a 37 00 00       	call   801050ca <acquire>
80101960:	83 c4 10             	add    $0x10,%esp
  ip->ref++;
80101963:	8b 45 08             	mov    0x8(%ebp),%eax
80101966:	8b 40 08             	mov    0x8(%eax),%eax
80101969:	8d 50 01             	lea    0x1(%eax),%edx
8010196c:	8b 45 08             	mov    0x8(%ebp),%eax
8010196f:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101972:	83 ec 0c             	sub    $0xc,%esp
80101975:	68 e0 01 11 80       	push   $0x801101e0
8010197a:	e8 b2 37 00 00       	call   80105131 <release>
8010197f:	83 c4 10             	add    $0x10,%esp
  return ip;
80101982:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101985:	c9                   	leave  
80101986:	c3                   	ret    

80101987 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101987:	55                   	push   %ebp
80101988:	89 e5                	mov    %esp,%ebp
8010198a:	83 ec 18             	sub    $0x18,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010198d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101991:	74 0a                	je     8010199d <ilock+0x16>
80101993:	8b 45 08             	mov    0x8(%ebp),%eax
80101996:	8b 40 08             	mov    0x8(%eax),%eax
80101999:	85 c0                	test   %eax,%eax
8010199b:	7f 0d                	jg     801019aa <ilock+0x23>
    panic("ilock");
8010199d:	83 ec 0c             	sub    $0xc,%esp
801019a0:	68 55 89 10 80       	push   $0x80108955
801019a5:	e8 d1 eb ff ff       	call   8010057b <panic>

  acquire(&icache.lock);
801019aa:	83 ec 0c             	sub    $0xc,%esp
801019ad:	68 e0 01 11 80       	push   $0x801101e0
801019b2:	e8 13 37 00 00       	call   801050ca <acquire>
801019b7:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019ba:	eb 13                	jmp    801019cf <ilock+0x48>
    sleep(ip, &icache.lock);
801019bc:	83 ec 08             	sub    $0x8,%esp
801019bf:	68 e0 01 11 80       	push   $0x801101e0
801019c4:	ff 75 08             	push   0x8(%ebp)
801019c7:	e8 03 34 00 00       	call   80104dcf <sleep>
801019cc:	83 c4 10             	add    $0x10,%esp
  while(ip->flags & I_BUSY)
801019cf:	8b 45 08             	mov    0x8(%ebp),%eax
801019d2:	8b 40 0c             	mov    0xc(%eax),%eax
801019d5:	83 e0 01             	and    $0x1,%eax
801019d8:	85 c0                	test   %eax,%eax
801019da:	75 e0                	jne    801019bc <ilock+0x35>
  ip->flags |= I_BUSY;
801019dc:	8b 45 08             	mov    0x8(%ebp),%eax
801019df:	8b 40 0c             	mov    0xc(%eax),%eax
801019e2:	83 c8 01             	or     $0x1,%eax
801019e5:	89 c2                	mov    %eax,%edx
801019e7:	8b 45 08             	mov    0x8(%ebp),%eax
801019ea:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801019ed:	83 ec 0c             	sub    $0xc,%esp
801019f0:	68 e0 01 11 80       	push   $0x801101e0
801019f5:	e8 37 37 00 00       	call   80105131 <release>
801019fa:	83 c4 10             	add    $0x10,%esp

  if(!(ip->flags & I_VALID)){
801019fd:	8b 45 08             	mov    0x8(%ebp),%eax
80101a00:	8b 40 0c             	mov    0xc(%eax),%eax
80101a03:	83 e0 02             	and    $0x2,%eax
80101a06:	85 c0                	test   %eax,%eax
80101a08:	0f 85 d4 00 00 00    	jne    80101ae2 <ilock+0x15b>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a11:	8b 40 04             	mov    0x4(%eax),%eax
80101a14:	c1 e8 03             	shr    $0x3,%eax
80101a17:	89 c2                	mov    %eax,%edx
80101a19:	a1 d4 01 11 80       	mov    0x801101d4,%eax
80101a1e:	01 c2                	add    %eax,%edx
80101a20:	8b 45 08             	mov    0x8(%ebp),%eax
80101a23:	8b 00                	mov    (%eax),%eax
80101a25:	83 ec 08             	sub    $0x8,%esp
80101a28:	52                   	push   %edx
80101a29:	50                   	push   %eax
80101a2a:	e8 88 e7 ff ff       	call   801001b7 <bread>
80101a2f:	83 c4 10             	add    $0x10,%esp
80101a32:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101a38:	8d 50 18             	lea    0x18(%eax),%edx
80101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
80101a3e:	8b 40 04             	mov    0x4(%eax),%eax
80101a41:	83 e0 07             	and    $0x7,%eax
80101a44:	c1 e0 06             	shl    $0x6,%eax
80101a47:	01 d0                	add    %edx,%eax
80101a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
80101a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a4f:	0f b7 10             	movzwl (%eax),%edx
80101a52:	8b 45 08             	mov    0x8(%ebp),%eax
80101a55:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101a59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a5c:	0f b7 50 02          	movzwl 0x2(%eax),%edx
80101a60:	8b 45 08             	mov    0x8(%ebp),%eax
80101a63:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101a67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a6a:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101a6e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a71:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101a75:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a78:	0f b7 50 06          	movzwl 0x6(%eax),%edx
80101a7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7f:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a86:	8b 50 08             	mov    0x8(%eax),%edx
80101a89:	8b 45 08             	mov    0x8(%ebp),%eax
80101a8c:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101a92:	8d 50 0c             	lea    0xc(%eax),%edx
80101a95:	8b 45 08             	mov    0x8(%ebp),%eax
80101a98:	83 c0 1c             	add    $0x1c,%eax
80101a9b:	83 ec 04             	sub    $0x4,%esp
80101a9e:	6a 34                	push   $0x34
80101aa0:	52                   	push   %edx
80101aa1:	50                   	push   %eax
80101aa2:	e8 45 39 00 00       	call   801053ec <memmove>
80101aa7:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80101aaa:	83 ec 0c             	sub    $0xc,%esp
80101aad:	ff 75 f4             	push   -0xc(%ebp)
80101ab0:	e8 7a e7 ff ff       	call   8010022f <brelse>
80101ab5:	83 c4 10             	add    $0x10,%esp
    ip->flags |= I_VALID;
80101ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80101abb:	8b 40 0c             	mov    0xc(%eax),%eax
80101abe:	83 c8 02             	or     $0x2,%eax
80101ac1:	89 c2                	mov    %eax,%edx
80101ac3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ac6:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
80101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
80101acc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101ad0:	66 85 c0             	test   %ax,%ax
80101ad3:	75 0d                	jne    80101ae2 <ilock+0x15b>
      panic("ilock: no type");
80101ad5:	83 ec 0c             	sub    $0xc,%esp
80101ad8:	68 5b 89 10 80       	push   $0x8010895b
80101add:	e8 99 ea ff ff       	call   8010057b <panic>
  }
}
80101ae2:	90                   	nop
80101ae3:	c9                   	leave  
80101ae4:	c3                   	ret    

80101ae5 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101ae5:	55                   	push   %ebp
80101ae6:	89 e5                	mov    %esp,%ebp
80101ae8:	83 ec 08             	sub    $0x8,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
80101aeb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80101aef:	74 17                	je     80101b08 <iunlock+0x23>
80101af1:	8b 45 08             	mov    0x8(%ebp),%eax
80101af4:	8b 40 0c             	mov    0xc(%eax),%eax
80101af7:	83 e0 01             	and    $0x1,%eax
80101afa:	85 c0                	test   %eax,%eax
80101afc:	74 0a                	je     80101b08 <iunlock+0x23>
80101afe:	8b 45 08             	mov    0x8(%ebp),%eax
80101b01:	8b 40 08             	mov    0x8(%eax),%eax
80101b04:	85 c0                	test   %eax,%eax
80101b06:	7f 0d                	jg     80101b15 <iunlock+0x30>
    panic("iunlock");
80101b08:	83 ec 0c             	sub    $0xc,%esp
80101b0b:	68 6a 89 10 80       	push   $0x8010896a
80101b10:	e8 66 ea ff ff       	call   8010057b <panic>

  acquire(&icache.lock);
80101b15:	83 ec 0c             	sub    $0xc,%esp
80101b18:	68 e0 01 11 80       	push   $0x801101e0
80101b1d:	e8 a8 35 00 00       	call   801050ca <acquire>
80101b22:	83 c4 10             	add    $0x10,%esp
  ip->flags &= ~I_BUSY;
80101b25:	8b 45 08             	mov    0x8(%ebp),%eax
80101b28:	8b 40 0c             	mov    0xc(%eax),%eax
80101b2b:	83 e0 fe             	and    $0xfffffffe,%eax
80101b2e:	89 c2                	mov    %eax,%edx
80101b30:	8b 45 08             	mov    0x8(%ebp),%eax
80101b33:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101b36:	83 ec 0c             	sub    $0xc,%esp
80101b39:	ff 75 08             	push   0x8(%ebp)
80101b3c:	e8 7a 33 00 00       	call   80104ebb <wakeup>
80101b41:	83 c4 10             	add    $0x10,%esp
  release(&icache.lock);
80101b44:	83 ec 0c             	sub    $0xc,%esp
80101b47:	68 e0 01 11 80       	push   $0x801101e0
80101b4c:	e8 e0 35 00 00       	call   80105131 <release>
80101b51:	83 c4 10             	add    $0x10,%esp
}
80101b54:	90                   	nop
80101b55:	c9                   	leave  
80101b56:	c3                   	ret    

80101b57 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101b57:	55                   	push   %ebp
80101b58:	89 e5                	mov    %esp,%ebp
80101b5a:	83 ec 08             	sub    $0x8,%esp
  acquire(&icache.lock);
80101b5d:	83 ec 0c             	sub    $0xc,%esp
80101b60:	68 e0 01 11 80       	push   $0x801101e0
80101b65:	e8 60 35 00 00       	call   801050ca <acquire>
80101b6a:	83 c4 10             	add    $0x10,%esp
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101b6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b70:	8b 40 08             	mov    0x8(%eax),%eax
80101b73:	83 f8 01             	cmp    $0x1,%eax
80101b76:	0f 85 a9 00 00 00    	jne    80101c25 <iput+0xce>
80101b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b7f:	8b 40 0c             	mov    0xc(%eax),%eax
80101b82:	83 e0 02             	and    $0x2,%eax
80101b85:	85 c0                	test   %eax,%eax
80101b87:	0f 84 98 00 00 00    	je     80101c25 <iput+0xce>
80101b8d:	8b 45 08             	mov    0x8(%ebp),%eax
80101b90:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101b94:	66 85 c0             	test   %ax,%ax
80101b97:	0f 85 88 00 00 00    	jne    80101c25 <iput+0xce>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101b9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba0:	8b 40 0c             	mov    0xc(%eax),%eax
80101ba3:	83 e0 01             	and    $0x1,%eax
80101ba6:	85 c0                	test   %eax,%eax
80101ba8:	74 0d                	je     80101bb7 <iput+0x60>
      panic("iput busy");
80101baa:	83 ec 0c             	sub    $0xc,%esp
80101bad:	68 72 89 10 80       	push   $0x80108972
80101bb2:	e8 c4 e9 ff ff       	call   8010057b <panic>
    ip->flags |= I_BUSY;
80101bb7:	8b 45 08             	mov    0x8(%ebp),%eax
80101bba:	8b 40 0c             	mov    0xc(%eax),%eax
80101bbd:	83 c8 01             	or     $0x1,%eax
80101bc0:	89 c2                	mov    %eax,%edx
80101bc2:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc5:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101bc8:	83 ec 0c             	sub    $0xc,%esp
80101bcb:	68 e0 01 11 80       	push   $0x801101e0
80101bd0:	e8 5c 35 00 00       	call   80105131 <release>
80101bd5:	83 c4 10             	add    $0x10,%esp
    itrunc(ip);
80101bd8:	83 ec 0c             	sub    $0xc,%esp
80101bdb:	ff 75 08             	push   0x8(%ebp)
80101bde:	e8 a3 01 00 00       	call   80101d86 <itrunc>
80101be3:	83 c4 10             	add    $0x10,%esp
    ip->type = 0;
80101be6:	8b 45 08             	mov    0x8(%ebp),%eax
80101be9:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101bef:	83 ec 0c             	sub    $0xc,%esp
80101bf2:	ff 75 08             	push   0x8(%ebp)
80101bf5:	e8 b3 fb ff ff       	call   801017ad <iupdate>
80101bfa:	83 c4 10             	add    $0x10,%esp
    acquire(&icache.lock);
80101bfd:	83 ec 0c             	sub    $0xc,%esp
80101c00:	68 e0 01 11 80       	push   $0x801101e0
80101c05:	e8 c0 34 00 00       	call   801050ca <acquire>
80101c0a:	83 c4 10             	add    $0x10,%esp
    ip->flags = 0;
80101c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101c17:	83 ec 0c             	sub    $0xc,%esp
80101c1a:	ff 75 08             	push   0x8(%ebp)
80101c1d:	e8 99 32 00 00       	call   80104ebb <wakeup>
80101c22:	83 c4 10             	add    $0x10,%esp
  }
  ip->ref--;
80101c25:	8b 45 08             	mov    0x8(%ebp),%eax
80101c28:	8b 40 08             	mov    0x8(%eax),%eax
80101c2b:	8d 50 ff             	lea    -0x1(%eax),%edx
80101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c31:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101c34:	83 ec 0c             	sub    $0xc,%esp
80101c37:	68 e0 01 11 80       	push   $0x801101e0
80101c3c:	e8 f0 34 00 00       	call   80105131 <release>
80101c41:	83 c4 10             	add    $0x10,%esp
}
80101c44:	90                   	nop
80101c45:	c9                   	leave  
80101c46:	c3                   	ret    

80101c47 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101c47:	55                   	push   %ebp
80101c48:	89 e5                	mov    %esp,%ebp
80101c4a:	83 ec 08             	sub    $0x8,%esp
  iunlock(ip);
80101c4d:	83 ec 0c             	sub    $0xc,%esp
80101c50:	ff 75 08             	push   0x8(%ebp)
80101c53:	e8 8d fe ff ff       	call   80101ae5 <iunlock>
80101c58:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80101c5b:	83 ec 0c             	sub    $0xc,%esp
80101c5e:	ff 75 08             	push   0x8(%ebp)
80101c61:	e8 f1 fe ff ff       	call   80101b57 <iput>
80101c66:	83 c4 10             	add    $0x10,%esp
}
80101c69:	90                   	nop
80101c6a:	c9                   	leave  
80101c6b:	c3                   	ret    

80101c6c <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101c6c:	55                   	push   %ebp
80101c6d:	89 e5                	mov    %esp,%ebp
80101c6f:	83 ec 18             	sub    $0x18,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101c72:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101c76:	77 42                	ja     80101cba <bmap+0x4e>
    if((addr = ip->addrs[bn]) == 0)
80101c78:	8b 45 08             	mov    0x8(%ebp),%eax
80101c7b:	8b 55 0c             	mov    0xc(%ebp),%edx
80101c7e:	83 c2 04             	add    $0x4,%edx
80101c81:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c85:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c88:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101c8c:	75 24                	jne    80101cb2 <bmap+0x46>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101c8e:	8b 45 08             	mov    0x8(%ebp),%eax
80101c91:	8b 00                	mov    (%eax),%eax
80101c93:	83 ec 0c             	sub    $0xc,%esp
80101c96:	50                   	push   %eax
80101c97:	e8 ab f7 ff ff       	call   80101447 <balloc>
80101c9c:	83 c4 10             	add    $0x10,%esp
80101c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca5:	8b 55 0c             	mov    0xc(%ebp),%edx
80101ca8:	8d 4a 04             	lea    0x4(%edx),%ecx
80101cab:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cae:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101cb5:	e9 ca 00 00 00       	jmp    80101d84 <bmap+0x118>
  }
  bn -= NDIRECT;
80101cba:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101cbe:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101cc2:	0f 87 af 00 00 00    	ja     80101d77 <bmap+0x10b>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ccb:	8b 40 4c             	mov    0x4c(%eax),%eax
80101cce:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101cd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101cd5:	75 1d                	jne    80101cf4 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80101cda:	8b 00                	mov    (%eax),%eax
80101cdc:	83 ec 0c             	sub    $0xc,%esp
80101cdf:	50                   	push   %eax
80101ce0:	e8 62 f7 ff ff       	call   80101447 <balloc>
80101ce5:	83 c4 10             	add    $0x10,%esp
80101ce8:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
80101cee:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101cf1:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101cf4:	8b 45 08             	mov    0x8(%ebp),%eax
80101cf7:	8b 00                	mov    (%eax),%eax
80101cf9:	83 ec 08             	sub    $0x8,%esp
80101cfc:	ff 75 f4             	push   -0xc(%ebp)
80101cff:	50                   	push   %eax
80101d00:	e8 b2 e4 ff ff       	call   801001b7 <bread>
80101d05:	83 c4 10             	add    $0x10,%esp
80101d08:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d0e:	83 c0 18             	add    $0x18,%eax
80101d11:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101d14:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d17:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d21:	01 d0                	add    %edx,%eax
80101d23:	8b 00                	mov    (%eax),%eax
80101d25:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101d2c:	75 36                	jne    80101d64 <bmap+0xf8>
      a[bn] = addr = balloc(ip->dev);
80101d2e:	8b 45 08             	mov    0x8(%ebp),%eax
80101d31:	8b 00                	mov    (%eax),%eax
80101d33:	83 ec 0c             	sub    $0xc,%esp
80101d36:	50                   	push   %eax
80101d37:	e8 0b f7 ff ff       	call   80101447 <balloc>
80101d3c:	83 c4 10             	add    $0x10,%esp
80101d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101d42:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d45:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101d4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d4f:	01 c2                	add    %eax,%edx
80101d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d54:	89 02                	mov    %eax,(%edx)
      log_write(bp);
80101d56:	83 ec 0c             	sub    $0xc,%esp
80101d59:	ff 75 f0             	push   -0x10(%ebp)
80101d5c:	e8 4e 1a 00 00       	call   801037af <log_write>
80101d61:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101d64:	83 ec 0c             	sub    $0xc,%esp
80101d67:	ff 75 f0             	push   -0x10(%ebp)
80101d6a:	e8 c0 e4 ff ff       	call   8010022f <brelse>
80101d6f:	83 c4 10             	add    $0x10,%esp
    return addr;
80101d72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101d75:	eb 0d                	jmp    80101d84 <bmap+0x118>
  }

  panic("bmap: out of range");
80101d77:	83 ec 0c             	sub    $0xc,%esp
80101d7a:	68 7c 89 10 80       	push   $0x8010897c
80101d7f:	e8 f7 e7 ff ff       	call   8010057b <panic>
}
80101d84:	c9                   	leave  
80101d85:	c3                   	ret    

80101d86 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101d86:	55                   	push   %ebp
80101d87:	89 e5                	mov    %esp,%ebp
80101d89:	83 ec 18             	sub    $0x18,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101d8c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101d93:	eb 45                	jmp    80101dda <itrunc+0x54>
    if(ip->addrs[i]){
80101d95:	8b 45 08             	mov    0x8(%ebp),%eax
80101d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101d9b:	83 c2 04             	add    $0x4,%edx
80101d9e:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101da2:	85 c0                	test   %eax,%eax
80101da4:	74 30                	je     80101dd6 <itrunc+0x50>
      bfree(ip->dev, ip->addrs[i]);
80101da6:	8b 45 08             	mov    0x8(%ebp),%eax
80101da9:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dac:	83 c2 04             	add    $0x4,%edx
80101daf:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101db3:	8b 55 08             	mov    0x8(%ebp),%edx
80101db6:	8b 12                	mov    (%edx),%edx
80101db8:	83 ec 08             	sub    $0x8,%esp
80101dbb:	50                   	push   %eax
80101dbc:	52                   	push   %edx
80101dbd:	e8 c9 f7 ff ff       	call   8010158b <bfree>
80101dc2:	83 c4 10             	add    $0x10,%esp
      ip->addrs[i] = 0;
80101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101dcb:	83 c2 04             	add    $0x4,%edx
80101dce:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101dd5:	00 
  for(i = 0; i < NDIRECT; i++){
80101dd6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101dda:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101dde:	7e b5                	jle    80101d95 <itrunc+0xf>
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101de0:	8b 45 08             	mov    0x8(%ebp),%eax
80101de3:	8b 40 4c             	mov    0x4c(%eax),%eax
80101de6:	85 c0                	test   %eax,%eax
80101de8:	0f 84 a1 00 00 00    	je     80101e8f <itrunc+0x109>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101dee:	8b 45 08             	mov    0x8(%ebp),%eax
80101df1:	8b 50 4c             	mov    0x4c(%eax),%edx
80101df4:	8b 45 08             	mov    0x8(%ebp),%eax
80101df7:	8b 00                	mov    (%eax),%eax
80101df9:	83 ec 08             	sub    $0x8,%esp
80101dfc:	52                   	push   %edx
80101dfd:	50                   	push   %eax
80101dfe:	e8 b4 e3 ff ff       	call   801001b7 <bread>
80101e03:	83 c4 10             	add    $0x10,%esp
80101e06:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101e0c:	83 c0 18             	add    $0x18,%eax
80101e0f:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101e12:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101e19:	eb 3c                	jmp    80101e57 <itrunc+0xd1>
      if(a[j])
80101e1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e25:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e28:	01 d0                	add    %edx,%eax
80101e2a:	8b 00                	mov    (%eax),%eax
80101e2c:	85 c0                	test   %eax,%eax
80101e2e:	74 23                	je     80101e53 <itrunc+0xcd>
        bfree(ip->dev, a[j]);
80101e30:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e33:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101e3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101e3d:	01 d0                	add    %edx,%eax
80101e3f:	8b 00                	mov    (%eax),%eax
80101e41:	8b 55 08             	mov    0x8(%ebp),%edx
80101e44:	8b 12                	mov    (%edx),%edx
80101e46:	83 ec 08             	sub    $0x8,%esp
80101e49:	50                   	push   %eax
80101e4a:	52                   	push   %edx
80101e4b:	e8 3b f7 ff ff       	call   8010158b <bfree>
80101e50:	83 c4 10             	add    $0x10,%esp
    for(j = 0; j < NINDIRECT; j++){
80101e53:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101e57:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101e5a:	83 f8 7f             	cmp    $0x7f,%eax
80101e5d:	76 bc                	jbe    80101e1b <itrunc+0x95>
    }
    brelse(bp);
80101e5f:	83 ec 0c             	sub    $0xc,%esp
80101e62:	ff 75 ec             	push   -0x14(%ebp)
80101e65:	e8 c5 e3 ff ff       	call   8010022f <brelse>
80101e6a:	83 c4 10             	add    $0x10,%esp
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101e6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101e70:	8b 40 4c             	mov    0x4c(%eax),%eax
80101e73:	8b 55 08             	mov    0x8(%ebp),%edx
80101e76:	8b 12                	mov    (%edx),%edx
80101e78:	83 ec 08             	sub    $0x8,%esp
80101e7b:	50                   	push   %eax
80101e7c:	52                   	push   %edx
80101e7d:	e8 09 f7 ff ff       	call   8010158b <bfree>
80101e82:	83 c4 10             	add    $0x10,%esp
    ip->addrs[NDIRECT] = 0;
80101e85:	8b 45 08             	mov    0x8(%ebp),%eax
80101e88:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101e8f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e92:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101e99:	83 ec 0c             	sub    $0xc,%esp
80101e9c:	ff 75 08             	push   0x8(%ebp)
80101e9f:	e8 09 f9 ff ff       	call   801017ad <iupdate>
80101ea4:	83 c4 10             	add    $0x10,%esp
}
80101ea7:	90                   	nop
80101ea8:	c9                   	leave  
80101ea9:	c3                   	ret    

80101eaa <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101eaa:	55                   	push   %ebp
80101eab:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101ead:	8b 45 08             	mov    0x8(%ebp),%eax
80101eb0:	8b 00                	mov    (%eax),%eax
80101eb2:	89 c2                	mov    %eax,%edx
80101eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eb7:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101eba:	8b 45 08             	mov    0x8(%ebp),%eax
80101ebd:	8b 50 04             	mov    0x4(%eax),%edx
80101ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec3:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101ec6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ec9:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed0:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101ed3:	8b 45 08             	mov    0x8(%ebp),%eax
80101ed6:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101eda:	8b 45 0c             	mov    0xc(%ebp),%eax
80101edd:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101ee1:	8b 45 08             	mov    0x8(%ebp),%eax
80101ee4:	8b 50 18             	mov    0x18(%eax),%edx
80101ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
80101eea:	89 50 10             	mov    %edx,0x10(%eax)
}
80101eed:	90                   	nop
80101eee:	5d                   	pop    %ebp
80101eef:	c3                   	ret    

80101ef0 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101ef0:	55                   	push   %ebp
80101ef1:	89 e5                	mov    %esp,%ebp
80101ef3:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80101ef9:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101efd:	66 83 f8 03          	cmp    $0x3,%ax
80101f01:	75 5c                	jne    80101f5f <readi+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101f03:	8b 45 08             	mov    0x8(%ebp),%eax
80101f06:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f0a:	66 85 c0             	test   %ax,%ax
80101f0d:	78 20                	js     80101f2f <readi+0x3f>
80101f0f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f12:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f16:	66 83 f8 09          	cmp    $0x9,%ax
80101f1a:	7f 13                	jg     80101f2f <readi+0x3f>
80101f1c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1f:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f23:	98                   	cwtl   
80101f24:	8b 04 c5 c0 f7 10 80 	mov    -0x7fef0840(,%eax,8),%eax
80101f2b:	85 c0                	test   %eax,%eax
80101f2d:	75 0a                	jne    80101f39 <readi+0x49>
      return -1;
80101f2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f34:	e9 0a 01 00 00       	jmp    80102043 <readi+0x153>
    return devsw[ip->major].read(ip, dst, n);
80101f39:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f40:	98                   	cwtl   
80101f41:	8b 04 c5 c0 f7 10 80 	mov    -0x7fef0840(,%eax,8),%eax
80101f48:	8b 55 14             	mov    0x14(%ebp),%edx
80101f4b:	83 ec 04             	sub    $0x4,%esp
80101f4e:	52                   	push   %edx
80101f4f:	ff 75 0c             	push   0xc(%ebp)
80101f52:	ff 75 08             	push   0x8(%ebp)
80101f55:	ff d0                	call   *%eax
80101f57:	83 c4 10             	add    $0x10,%esp
80101f5a:	e9 e4 00 00 00       	jmp    80102043 <readi+0x153>
  }

  if(off > ip->size || off + n < off)
80101f5f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f62:	8b 40 18             	mov    0x18(%eax),%eax
80101f65:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f68:	77 0d                	ja     80101f77 <readi+0x87>
80101f6a:	8b 55 10             	mov    0x10(%ebp),%edx
80101f6d:	8b 45 14             	mov    0x14(%ebp),%eax
80101f70:	01 d0                	add    %edx,%eax
80101f72:	39 45 10             	cmp    %eax,0x10(%ebp)
80101f75:	76 0a                	jbe    80101f81 <readi+0x91>
    return -1;
80101f77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f7c:	e9 c2 00 00 00       	jmp    80102043 <readi+0x153>
  if(off + n > ip->size)
80101f81:	8b 55 10             	mov    0x10(%ebp),%edx
80101f84:	8b 45 14             	mov    0x14(%ebp),%eax
80101f87:	01 c2                	add    %eax,%edx
80101f89:	8b 45 08             	mov    0x8(%ebp),%eax
80101f8c:	8b 40 18             	mov    0x18(%eax),%eax
80101f8f:	39 c2                	cmp    %eax,%edx
80101f91:	76 0c                	jbe    80101f9f <readi+0xaf>
    n = ip->size - off;
80101f93:	8b 45 08             	mov    0x8(%ebp),%eax
80101f96:	8b 40 18             	mov    0x18(%eax),%eax
80101f99:	2b 45 10             	sub    0x10(%ebp),%eax
80101f9c:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101f9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fa6:	e9 89 00 00 00       	jmp    80102034 <readi+0x144>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fab:	8b 45 10             	mov    0x10(%ebp),%eax
80101fae:	c1 e8 09             	shr    $0x9,%eax
80101fb1:	83 ec 08             	sub    $0x8,%esp
80101fb4:	50                   	push   %eax
80101fb5:	ff 75 08             	push   0x8(%ebp)
80101fb8:	e8 af fc ff ff       	call   80101c6c <bmap>
80101fbd:	83 c4 10             	add    $0x10,%esp
80101fc0:	8b 55 08             	mov    0x8(%ebp),%edx
80101fc3:	8b 12                	mov    (%edx),%edx
80101fc5:	83 ec 08             	sub    $0x8,%esp
80101fc8:	50                   	push   %eax
80101fc9:	52                   	push   %edx
80101fca:	e8 e8 e1 ff ff       	call   801001b7 <bread>
80101fcf:	83 c4 10             	add    $0x10,%esp
80101fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fd5:	8b 45 10             	mov    0x10(%ebp),%eax
80101fd8:	25 ff 01 00 00       	and    $0x1ff,%eax
80101fdd:	ba 00 02 00 00       	mov    $0x200,%edx
80101fe2:	29 c2                	sub    %eax,%edx
80101fe4:	8b 45 14             	mov    0x14(%ebp),%eax
80101fe7:	2b 45 f4             	sub    -0xc(%ebp),%eax
80101fea:	39 c2                	cmp    %eax,%edx
80101fec:	0f 46 c2             	cmovbe %edx,%eax
80101fef:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101ff2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ff5:	8d 50 18             	lea    0x18(%eax),%edx
80101ff8:	8b 45 10             	mov    0x10(%ebp),%eax
80101ffb:	25 ff 01 00 00       	and    $0x1ff,%eax
80102000:	01 d0                	add    %edx,%eax
80102002:	83 ec 04             	sub    $0x4,%esp
80102005:	ff 75 ec             	push   -0x14(%ebp)
80102008:	50                   	push   %eax
80102009:	ff 75 0c             	push   0xc(%ebp)
8010200c:	e8 db 33 00 00       	call   801053ec <memmove>
80102011:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102014:	83 ec 0c             	sub    $0xc,%esp
80102017:	ff 75 f0             	push   -0x10(%ebp)
8010201a:	e8 10 e2 ff ff       	call   8010022f <brelse>
8010201f:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80102022:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102025:	01 45 f4             	add    %eax,-0xc(%ebp)
80102028:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010202b:	01 45 10             	add    %eax,0x10(%ebp)
8010202e:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102031:	01 45 0c             	add    %eax,0xc(%ebp)
80102034:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102037:	3b 45 14             	cmp    0x14(%ebp),%eax
8010203a:	0f 82 6b ff ff ff    	jb     80101fab <readi+0xbb>
  }
  return n;
80102040:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102043:	c9                   	leave  
80102044:	c3                   	ret    

80102045 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80102045:	55                   	push   %ebp
80102046:	89 e5                	mov    %esp,%ebp
80102048:	83 ec 18             	sub    $0x18,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
8010204b:	8b 45 08             	mov    0x8(%ebp),%eax
8010204e:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102052:	66 83 f8 03          	cmp    $0x3,%ax
80102056:	75 5c                	jne    801020b4 <writei+0x6f>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80102058:	8b 45 08             	mov    0x8(%ebp),%eax
8010205b:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010205f:	66 85 c0             	test   %ax,%ax
80102062:	78 20                	js     80102084 <writei+0x3f>
80102064:	8b 45 08             	mov    0x8(%ebp),%eax
80102067:	0f b7 40 12          	movzwl 0x12(%eax),%eax
8010206b:	66 83 f8 09          	cmp    $0x9,%ax
8010206f:	7f 13                	jg     80102084 <writei+0x3f>
80102071:	8b 45 08             	mov    0x8(%ebp),%eax
80102074:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102078:	98                   	cwtl   
80102079:	8b 04 c5 c4 f7 10 80 	mov    -0x7fef083c(,%eax,8),%eax
80102080:	85 c0                	test   %eax,%eax
80102082:	75 0a                	jne    8010208e <writei+0x49>
      return -1;
80102084:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102089:	e9 3b 01 00 00       	jmp    801021c9 <writei+0x184>
    return devsw[ip->major].write(ip, src, n);
8010208e:	8b 45 08             	mov    0x8(%ebp),%eax
80102091:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80102095:	98                   	cwtl   
80102096:	8b 04 c5 c4 f7 10 80 	mov    -0x7fef083c(,%eax,8),%eax
8010209d:	8b 55 14             	mov    0x14(%ebp),%edx
801020a0:	83 ec 04             	sub    $0x4,%esp
801020a3:	52                   	push   %edx
801020a4:	ff 75 0c             	push   0xc(%ebp)
801020a7:	ff 75 08             	push   0x8(%ebp)
801020aa:	ff d0                	call   *%eax
801020ac:	83 c4 10             	add    $0x10,%esp
801020af:	e9 15 01 00 00       	jmp    801021c9 <writei+0x184>
  }

  if(off > ip->size || off + n < off)
801020b4:	8b 45 08             	mov    0x8(%ebp),%eax
801020b7:	8b 40 18             	mov    0x18(%eax),%eax
801020ba:	39 45 10             	cmp    %eax,0x10(%ebp)
801020bd:	77 0d                	ja     801020cc <writei+0x87>
801020bf:	8b 55 10             	mov    0x10(%ebp),%edx
801020c2:	8b 45 14             	mov    0x14(%ebp),%eax
801020c5:	01 d0                	add    %edx,%eax
801020c7:	39 45 10             	cmp    %eax,0x10(%ebp)
801020ca:	76 0a                	jbe    801020d6 <writei+0x91>
    return -1;
801020cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020d1:	e9 f3 00 00 00       	jmp    801021c9 <writei+0x184>
  if(off + n > MAXFILE*BSIZE)
801020d6:	8b 55 10             	mov    0x10(%ebp),%edx
801020d9:	8b 45 14             	mov    0x14(%ebp),%eax
801020dc:	01 d0                	add    %edx,%eax
801020de:	3d 00 18 01 00       	cmp    $0x11800,%eax
801020e3:	76 0a                	jbe    801020ef <writei+0xaa>
    return -1;
801020e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801020ea:	e9 da 00 00 00       	jmp    801021c9 <writei+0x184>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801020ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020f6:	e9 97 00 00 00       	jmp    80102192 <writei+0x14d>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801020fb:	8b 45 10             	mov    0x10(%ebp),%eax
801020fe:	c1 e8 09             	shr    $0x9,%eax
80102101:	83 ec 08             	sub    $0x8,%esp
80102104:	50                   	push   %eax
80102105:	ff 75 08             	push   0x8(%ebp)
80102108:	e8 5f fb ff ff       	call   80101c6c <bmap>
8010210d:	83 c4 10             	add    $0x10,%esp
80102110:	8b 55 08             	mov    0x8(%ebp),%edx
80102113:	8b 12                	mov    (%edx),%edx
80102115:	83 ec 08             	sub    $0x8,%esp
80102118:	50                   	push   %eax
80102119:	52                   	push   %edx
8010211a:	e8 98 e0 ff ff       	call   801001b7 <bread>
8010211f:	83 c4 10             	add    $0x10,%esp
80102122:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80102125:	8b 45 10             	mov    0x10(%ebp),%eax
80102128:	25 ff 01 00 00       	and    $0x1ff,%eax
8010212d:	ba 00 02 00 00       	mov    $0x200,%edx
80102132:	29 c2                	sub    %eax,%edx
80102134:	8b 45 14             	mov    0x14(%ebp),%eax
80102137:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010213a:	39 c2                	cmp    %eax,%edx
8010213c:	0f 46 c2             	cmovbe %edx,%eax
8010213f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
80102142:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102145:	8d 50 18             	lea    0x18(%eax),%edx
80102148:	8b 45 10             	mov    0x10(%ebp),%eax
8010214b:	25 ff 01 00 00       	and    $0x1ff,%eax
80102150:	01 d0                	add    %edx,%eax
80102152:	83 ec 04             	sub    $0x4,%esp
80102155:	ff 75 ec             	push   -0x14(%ebp)
80102158:	ff 75 0c             	push   0xc(%ebp)
8010215b:	50                   	push   %eax
8010215c:	e8 8b 32 00 00       	call   801053ec <memmove>
80102161:	83 c4 10             	add    $0x10,%esp
    log_write(bp);
80102164:	83 ec 0c             	sub    $0xc,%esp
80102167:	ff 75 f0             	push   -0x10(%ebp)
8010216a:	e8 40 16 00 00       	call   801037af <log_write>
8010216f:	83 c4 10             	add    $0x10,%esp
    brelse(bp);
80102172:	83 ec 0c             	sub    $0xc,%esp
80102175:	ff 75 f0             	push   -0x10(%ebp)
80102178:	e8 b2 e0 ff ff       	call   8010022f <brelse>
8010217d:	83 c4 10             	add    $0x10,%esp
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80102180:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102183:	01 45 f4             	add    %eax,-0xc(%ebp)
80102186:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102189:	01 45 10             	add    %eax,0x10(%ebp)
8010218c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010218f:	01 45 0c             	add    %eax,0xc(%ebp)
80102192:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102195:	3b 45 14             	cmp    0x14(%ebp),%eax
80102198:	0f 82 5d ff ff ff    	jb     801020fb <writei+0xb6>
  }

  if(n > 0 && off > ip->size){
8010219e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801021a2:	74 22                	je     801021c6 <writei+0x181>
801021a4:	8b 45 08             	mov    0x8(%ebp),%eax
801021a7:	8b 40 18             	mov    0x18(%eax),%eax
801021aa:	39 45 10             	cmp    %eax,0x10(%ebp)
801021ad:	76 17                	jbe    801021c6 <writei+0x181>
    ip->size = off;
801021af:	8b 45 08             	mov    0x8(%ebp),%eax
801021b2:	8b 55 10             	mov    0x10(%ebp),%edx
801021b5:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
801021b8:	83 ec 0c             	sub    $0xc,%esp
801021bb:	ff 75 08             	push   0x8(%ebp)
801021be:	e8 ea f5 ff ff       	call   801017ad <iupdate>
801021c3:	83 c4 10             	add    $0x10,%esp
  }
  return n;
801021c6:	8b 45 14             	mov    0x14(%ebp),%eax
}
801021c9:	c9                   	leave  
801021ca:	c3                   	ret    

801021cb <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
801021cb:	55                   	push   %ebp
801021cc:	89 e5                	mov    %esp,%ebp
801021ce:	83 ec 08             	sub    $0x8,%esp
  return strncmp(s, t, DIRSIZ);
801021d1:	83 ec 04             	sub    $0x4,%esp
801021d4:	6a 0e                	push   $0xe
801021d6:	ff 75 0c             	push   0xc(%ebp)
801021d9:	ff 75 08             	push   0x8(%ebp)
801021dc:	e8 a1 32 00 00       	call   80105482 <strncmp>
801021e1:	83 c4 10             	add    $0x10,%esp
}
801021e4:	c9                   	leave  
801021e5:	c3                   	ret    

801021e6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801021e6:	55                   	push   %ebp
801021e7:	89 e5                	mov    %esp,%ebp
801021e9:	83 ec 28             	sub    $0x28,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801021ec:	8b 45 08             	mov    0x8(%ebp),%eax
801021ef:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801021f3:	66 83 f8 01          	cmp    $0x1,%ax
801021f7:	74 0d                	je     80102206 <dirlookup+0x20>
    panic("dirlookup not DIR");
801021f9:	83 ec 0c             	sub    $0xc,%esp
801021fc:	68 8f 89 10 80       	push   $0x8010898f
80102201:	e8 75 e3 ff ff       	call   8010057b <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
80102206:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010220d:	eb 7b                	jmp    8010228a <dirlookup+0xa4>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010220f:	6a 10                	push   $0x10
80102211:	ff 75 f4             	push   -0xc(%ebp)
80102214:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102217:	50                   	push   %eax
80102218:	ff 75 08             	push   0x8(%ebp)
8010221b:	e8 d0 fc ff ff       	call   80101ef0 <readi>
80102220:	83 c4 10             	add    $0x10,%esp
80102223:	83 f8 10             	cmp    $0x10,%eax
80102226:	74 0d                	je     80102235 <dirlookup+0x4f>
      panic("dirlink read");
80102228:	83 ec 0c             	sub    $0xc,%esp
8010222b:	68 a1 89 10 80       	push   $0x801089a1
80102230:	e8 46 e3 ff ff       	call   8010057b <panic>
    if(de.inum == 0)
80102235:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102239:	66 85 c0             	test   %ax,%ax
8010223c:	74 47                	je     80102285 <dirlookup+0x9f>
      continue;
    if(namecmp(name, de.name) == 0){
8010223e:	83 ec 08             	sub    $0x8,%esp
80102241:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102244:	83 c0 02             	add    $0x2,%eax
80102247:	50                   	push   %eax
80102248:	ff 75 0c             	push   0xc(%ebp)
8010224b:	e8 7b ff ff ff       	call   801021cb <namecmp>
80102250:	83 c4 10             	add    $0x10,%esp
80102253:	85 c0                	test   %eax,%eax
80102255:	75 2f                	jne    80102286 <dirlookup+0xa0>
      // entry matches path element
      if(poff)
80102257:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010225b:	74 08                	je     80102265 <dirlookup+0x7f>
        *poff = off;
8010225d:	8b 45 10             	mov    0x10(%ebp),%eax
80102260:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102263:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102265:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102269:	0f b7 c0             	movzwl %ax,%eax
8010226c:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
8010226f:	8b 45 08             	mov    0x8(%ebp),%eax
80102272:	8b 00                	mov    (%eax),%eax
80102274:	83 ec 08             	sub    $0x8,%esp
80102277:	ff 75 f0             	push   -0x10(%ebp)
8010227a:	50                   	push   %eax
8010227b:	e8 ee f5 ff ff       	call   8010186e <iget>
80102280:	83 c4 10             	add    $0x10,%esp
80102283:	eb 19                	jmp    8010229e <dirlookup+0xb8>
      continue;
80102285:	90                   	nop
  for(off = 0; off < dp->size; off += sizeof(de)){
80102286:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010228a:	8b 45 08             	mov    0x8(%ebp),%eax
8010228d:	8b 40 18             	mov    0x18(%eax),%eax
80102290:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80102293:	0f 82 76 ff ff ff    	jb     8010220f <dirlookup+0x29>
    }
  }

  return 0;
80102299:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010229e:	c9                   	leave  
8010229f:	c3                   	ret    

801022a0 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
801022a0:	55                   	push   %ebp
801022a1:	89 e5                	mov    %esp,%ebp
801022a3:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
801022a6:	83 ec 04             	sub    $0x4,%esp
801022a9:	6a 00                	push   $0x0
801022ab:	ff 75 0c             	push   0xc(%ebp)
801022ae:	ff 75 08             	push   0x8(%ebp)
801022b1:	e8 30 ff ff ff       	call   801021e6 <dirlookup>
801022b6:	83 c4 10             	add    $0x10,%esp
801022b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801022bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801022c0:	74 18                	je     801022da <dirlink+0x3a>
    iput(ip);
801022c2:	83 ec 0c             	sub    $0xc,%esp
801022c5:	ff 75 f0             	push   -0x10(%ebp)
801022c8:	e8 8a f8 ff ff       	call   80101b57 <iput>
801022cd:	83 c4 10             	add    $0x10,%esp
    return -1;
801022d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801022d5:	e9 9c 00 00 00       	jmp    80102376 <dirlink+0xd6>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801022da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801022e1:	eb 39                	jmp    8010231c <dirlink+0x7c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022e6:	6a 10                	push   $0x10
801022e8:	50                   	push   %eax
801022e9:	8d 45 e0             	lea    -0x20(%ebp),%eax
801022ec:	50                   	push   %eax
801022ed:	ff 75 08             	push   0x8(%ebp)
801022f0:	e8 fb fb ff ff       	call   80101ef0 <readi>
801022f5:	83 c4 10             	add    $0x10,%esp
801022f8:	83 f8 10             	cmp    $0x10,%eax
801022fb:	74 0d                	je     8010230a <dirlink+0x6a>
      panic("dirlink read");
801022fd:	83 ec 0c             	sub    $0xc,%esp
80102300:	68 a1 89 10 80       	push   $0x801089a1
80102305:	e8 71 e2 ff ff       	call   8010057b <panic>
    if(de.inum == 0)
8010230a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010230e:	66 85 c0             	test   %ax,%ax
80102311:	74 18                	je     8010232b <dirlink+0x8b>
  for(off = 0; off < dp->size; off += sizeof(de)){
80102313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102316:	83 c0 10             	add    $0x10,%eax
80102319:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010231c:	8b 45 08             	mov    0x8(%ebp),%eax
8010231f:	8b 50 18             	mov    0x18(%eax),%edx
80102322:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102325:	39 c2                	cmp    %eax,%edx
80102327:	77 ba                	ja     801022e3 <dirlink+0x43>
80102329:	eb 01                	jmp    8010232c <dirlink+0x8c>
      break;
8010232b:	90                   	nop
  }

  strncpy(de.name, name, DIRSIZ);
8010232c:	83 ec 04             	sub    $0x4,%esp
8010232f:	6a 0e                	push   $0xe
80102331:	ff 75 0c             	push   0xc(%ebp)
80102334:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102337:	83 c0 02             	add    $0x2,%eax
8010233a:	50                   	push   %eax
8010233b:	e8 98 31 00 00       	call   801054d8 <strncpy>
80102340:	83 c4 10             	add    $0x10,%esp
  de.inum = inum;
80102343:	8b 45 10             	mov    0x10(%ebp),%eax
80102346:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010234a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010234d:	6a 10                	push   $0x10
8010234f:	50                   	push   %eax
80102350:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102353:	50                   	push   %eax
80102354:	ff 75 08             	push   0x8(%ebp)
80102357:	e8 e9 fc ff ff       	call   80102045 <writei>
8010235c:	83 c4 10             	add    $0x10,%esp
8010235f:	83 f8 10             	cmp    $0x10,%eax
80102362:	74 0d                	je     80102371 <dirlink+0xd1>
    panic("dirlink");
80102364:	83 ec 0c             	sub    $0xc,%esp
80102367:	68 ae 89 10 80       	push   $0x801089ae
8010236c:	e8 0a e2 ff ff       	call   8010057b <panic>
  
  return 0;
80102371:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102376:	c9                   	leave  
80102377:	c3                   	ret    

80102378 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102378:	55                   	push   %ebp
80102379:	89 e5                	mov    %esp,%ebp
8010237b:	83 ec 18             	sub    $0x18,%esp
  char *s;
  int len;

  while(*path == '/')
8010237e:	eb 04                	jmp    80102384 <skipelem+0xc>
    path++;
80102380:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102384:	8b 45 08             	mov    0x8(%ebp),%eax
80102387:	0f b6 00             	movzbl (%eax),%eax
8010238a:	3c 2f                	cmp    $0x2f,%al
8010238c:	74 f2                	je     80102380 <skipelem+0x8>
  if(*path == 0)
8010238e:	8b 45 08             	mov    0x8(%ebp),%eax
80102391:	0f b6 00             	movzbl (%eax),%eax
80102394:	84 c0                	test   %al,%al
80102396:	75 07                	jne    8010239f <skipelem+0x27>
    return 0;
80102398:	b8 00 00 00 00       	mov    $0x0,%eax
8010239d:	eb 77                	jmp    80102416 <skipelem+0x9e>
  s = path;
8010239f:	8b 45 08             	mov    0x8(%ebp),%eax
801023a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801023a5:	eb 04                	jmp    801023ab <skipelem+0x33>
    path++;
801023a7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path != '/' && *path != 0)
801023ab:	8b 45 08             	mov    0x8(%ebp),%eax
801023ae:	0f b6 00             	movzbl (%eax),%eax
801023b1:	3c 2f                	cmp    $0x2f,%al
801023b3:	74 0a                	je     801023bf <skipelem+0x47>
801023b5:	8b 45 08             	mov    0x8(%ebp),%eax
801023b8:	0f b6 00             	movzbl (%eax),%eax
801023bb:	84 c0                	test   %al,%al
801023bd:	75 e8                	jne    801023a7 <skipelem+0x2f>
  len = path - s;
801023bf:	8b 45 08             	mov    0x8(%ebp),%eax
801023c2:	2b 45 f4             	sub    -0xc(%ebp),%eax
801023c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801023c8:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801023cc:	7e 15                	jle    801023e3 <skipelem+0x6b>
    memmove(name, s, DIRSIZ);
801023ce:	83 ec 04             	sub    $0x4,%esp
801023d1:	6a 0e                	push   $0xe
801023d3:	ff 75 f4             	push   -0xc(%ebp)
801023d6:	ff 75 0c             	push   0xc(%ebp)
801023d9:	e8 0e 30 00 00       	call   801053ec <memmove>
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	eb 26                	jmp    80102409 <skipelem+0x91>
  else {
    memmove(name, s, len);
801023e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801023e6:	83 ec 04             	sub    $0x4,%esp
801023e9:	50                   	push   %eax
801023ea:	ff 75 f4             	push   -0xc(%ebp)
801023ed:	ff 75 0c             	push   0xc(%ebp)
801023f0:	e8 f7 2f 00 00       	call   801053ec <memmove>
801023f5:	83 c4 10             	add    $0x10,%esp
    name[len] = 0;
801023f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801023fb:	8b 45 0c             	mov    0xc(%ebp),%eax
801023fe:	01 d0                	add    %edx,%eax
80102400:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102403:	eb 04                	jmp    80102409 <skipelem+0x91>
    path++;
80102405:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
80102409:	8b 45 08             	mov    0x8(%ebp),%eax
8010240c:	0f b6 00             	movzbl (%eax),%eax
8010240f:	3c 2f                	cmp    $0x2f,%al
80102411:	74 f2                	je     80102405 <skipelem+0x8d>
  return path;
80102413:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102416:	c9                   	leave  
80102417:	c3                   	ret    

80102418 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102418:	55                   	push   %ebp
80102419:	89 e5                	mov    %esp,%ebp
8010241b:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010241e:	8b 45 08             	mov    0x8(%ebp),%eax
80102421:	0f b6 00             	movzbl (%eax),%eax
80102424:	3c 2f                	cmp    $0x2f,%al
80102426:	75 17                	jne    8010243f <namex+0x27>
    ip = iget(ROOTDEV, ROOTINO);
80102428:	83 ec 08             	sub    $0x8,%esp
8010242b:	6a 01                	push   $0x1
8010242d:	6a 01                	push   $0x1
8010242f:	e8 3a f4 ff ff       	call   8010186e <iget>
80102434:	83 c4 10             	add    $0x10,%esp
80102437:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010243a:	e9 bb 00 00 00       	jmp    801024fa <namex+0xe2>
  else
    ip = idup(proc->cwd);
8010243f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80102445:	8b 40 68             	mov    0x68(%eax),%eax
80102448:	83 ec 0c             	sub    $0xc,%esp
8010244b:	50                   	push   %eax
8010244c:	e8 fc f4 ff ff       	call   8010194d <idup>
80102451:	83 c4 10             	add    $0x10,%esp
80102454:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102457:	e9 9e 00 00 00       	jmp    801024fa <namex+0xe2>
    ilock(ip);
8010245c:	83 ec 0c             	sub    $0xc,%esp
8010245f:	ff 75 f4             	push   -0xc(%ebp)
80102462:	e8 20 f5 ff ff       	call   80101987 <ilock>
80102467:	83 c4 10             	add    $0x10,%esp
    if(ip->type != T_DIR){
8010246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010246d:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102471:	66 83 f8 01          	cmp    $0x1,%ax
80102475:	74 18                	je     8010248f <namex+0x77>
      iunlockput(ip);
80102477:	83 ec 0c             	sub    $0xc,%esp
8010247a:	ff 75 f4             	push   -0xc(%ebp)
8010247d:	e8 c5 f7 ff ff       	call   80101c47 <iunlockput>
80102482:	83 c4 10             	add    $0x10,%esp
      return 0;
80102485:	b8 00 00 00 00       	mov    $0x0,%eax
8010248a:	e9 a7 00 00 00       	jmp    80102536 <namex+0x11e>
    }
    if(nameiparent && *path == '\0'){
8010248f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102493:	74 20                	je     801024b5 <namex+0x9d>
80102495:	8b 45 08             	mov    0x8(%ebp),%eax
80102498:	0f b6 00             	movzbl (%eax),%eax
8010249b:	84 c0                	test   %al,%al
8010249d:	75 16                	jne    801024b5 <namex+0x9d>
      // Stop one level early.
      iunlock(ip);
8010249f:	83 ec 0c             	sub    $0xc,%esp
801024a2:	ff 75 f4             	push   -0xc(%ebp)
801024a5:	e8 3b f6 ff ff       	call   80101ae5 <iunlock>
801024aa:	83 c4 10             	add    $0x10,%esp
      return ip;
801024ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801024b0:	e9 81 00 00 00       	jmp    80102536 <namex+0x11e>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801024b5:	83 ec 04             	sub    $0x4,%esp
801024b8:	6a 00                	push   $0x0
801024ba:	ff 75 10             	push   0x10(%ebp)
801024bd:	ff 75 f4             	push   -0xc(%ebp)
801024c0:	e8 21 fd ff ff       	call   801021e6 <dirlookup>
801024c5:	83 c4 10             	add    $0x10,%esp
801024c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801024cb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801024cf:	75 15                	jne    801024e6 <namex+0xce>
      iunlockput(ip);
801024d1:	83 ec 0c             	sub    $0xc,%esp
801024d4:	ff 75 f4             	push   -0xc(%ebp)
801024d7:	e8 6b f7 ff ff       	call   80101c47 <iunlockput>
801024dc:	83 c4 10             	add    $0x10,%esp
      return 0;
801024df:	b8 00 00 00 00       	mov    $0x0,%eax
801024e4:	eb 50                	jmp    80102536 <namex+0x11e>
    }
    iunlockput(ip);
801024e6:	83 ec 0c             	sub    $0xc,%esp
801024e9:	ff 75 f4             	push   -0xc(%ebp)
801024ec:	e8 56 f7 ff ff       	call   80101c47 <iunlockput>
801024f1:	83 c4 10             	add    $0x10,%esp
    ip = next;
801024f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801024f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while((path = skipelem(path, name)) != 0){
801024fa:	83 ec 08             	sub    $0x8,%esp
801024fd:	ff 75 10             	push   0x10(%ebp)
80102500:	ff 75 08             	push   0x8(%ebp)
80102503:	e8 70 fe ff ff       	call   80102378 <skipelem>
80102508:	83 c4 10             	add    $0x10,%esp
8010250b:	89 45 08             	mov    %eax,0x8(%ebp)
8010250e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102512:	0f 85 44 ff ff ff    	jne    8010245c <namex+0x44>
  }
  if(nameiparent){
80102518:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010251c:	74 15                	je     80102533 <namex+0x11b>
    iput(ip);
8010251e:	83 ec 0c             	sub    $0xc,%esp
80102521:	ff 75 f4             	push   -0xc(%ebp)
80102524:	e8 2e f6 ff ff       	call   80101b57 <iput>
80102529:	83 c4 10             	add    $0x10,%esp
    return 0;
8010252c:	b8 00 00 00 00       	mov    $0x0,%eax
80102531:	eb 03                	jmp    80102536 <namex+0x11e>
  }
  return ip;
80102533:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102536:	c9                   	leave  
80102537:	c3                   	ret    

80102538 <namei>:

struct inode*
namei(char *path)
{
80102538:	55                   	push   %ebp
80102539:	89 e5                	mov    %esp,%ebp
8010253b:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
8010253e:	83 ec 04             	sub    $0x4,%esp
80102541:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102544:	50                   	push   %eax
80102545:	6a 00                	push   $0x0
80102547:	ff 75 08             	push   0x8(%ebp)
8010254a:	e8 c9 fe ff ff       	call   80102418 <namex>
8010254f:	83 c4 10             	add    $0x10,%esp
}
80102552:	c9                   	leave  
80102553:	c3                   	ret    

80102554 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102554:	55                   	push   %ebp
80102555:	89 e5                	mov    %esp,%ebp
80102557:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
8010255a:	83 ec 04             	sub    $0x4,%esp
8010255d:	ff 75 0c             	push   0xc(%ebp)
80102560:	6a 01                	push   $0x1
80102562:	ff 75 08             	push   0x8(%ebp)
80102565:	e8 ae fe ff ff       	call   80102418 <namex>
8010256a:	83 c4 10             	add    $0x10,%esp
}
8010256d:	c9                   	leave  
8010256e:	c3                   	ret    

8010256f <inb>:
{
8010256f:	55                   	push   %ebp
80102570:	89 e5                	mov    %esp,%ebp
80102572:	83 ec 14             	sub    $0x14,%esp
80102575:	8b 45 08             	mov    0x8(%ebp),%eax
80102578:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010257c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102580:	89 c2                	mov    %eax,%edx
80102582:	ec                   	in     (%dx),%al
80102583:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102586:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010258a:	c9                   	leave  
8010258b:	c3                   	ret    

8010258c <insl>:
{
8010258c:	55                   	push   %ebp
8010258d:	89 e5                	mov    %esp,%ebp
8010258f:	57                   	push   %edi
80102590:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
80102591:	8b 55 08             	mov    0x8(%ebp),%edx
80102594:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102597:	8b 45 10             	mov    0x10(%ebp),%eax
8010259a:	89 cb                	mov    %ecx,%ebx
8010259c:	89 df                	mov    %ebx,%edi
8010259e:	89 c1                	mov    %eax,%ecx
801025a0:	fc                   	cld    
801025a1:	f3 6d                	rep insl (%dx),%es:(%edi)
801025a3:	89 c8                	mov    %ecx,%eax
801025a5:	89 fb                	mov    %edi,%ebx
801025a7:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025aa:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025ad:	90                   	nop
801025ae:	5b                   	pop    %ebx
801025af:	5f                   	pop    %edi
801025b0:	5d                   	pop    %ebp
801025b1:	c3                   	ret    

801025b2 <outb>:
{
801025b2:	55                   	push   %ebp
801025b3:	89 e5                	mov    %esp,%ebp
801025b5:	83 ec 08             	sub    $0x8,%esp
801025b8:	8b 45 08             	mov    0x8(%ebp),%eax
801025bb:	8b 55 0c             	mov    0xc(%ebp),%edx
801025be:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
801025c2:	89 d0                	mov    %edx,%eax
801025c4:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801025c7:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801025cb:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801025cf:	ee                   	out    %al,(%dx)
}
801025d0:	90                   	nop
801025d1:	c9                   	leave  
801025d2:	c3                   	ret    

801025d3 <outsl>:
{
801025d3:	55                   	push   %ebp
801025d4:	89 e5                	mov    %esp,%ebp
801025d6:	56                   	push   %esi
801025d7:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801025d8:	8b 55 08             	mov    0x8(%ebp),%edx
801025db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801025de:	8b 45 10             	mov    0x10(%ebp),%eax
801025e1:	89 cb                	mov    %ecx,%ebx
801025e3:	89 de                	mov    %ebx,%esi
801025e5:	89 c1                	mov    %eax,%ecx
801025e7:	fc                   	cld    
801025e8:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801025ea:	89 c8                	mov    %ecx,%eax
801025ec:	89 f3                	mov    %esi,%ebx
801025ee:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801025f1:	89 45 10             	mov    %eax,0x10(%ebp)
}
801025f4:	90                   	nop
801025f5:	5b                   	pop    %ebx
801025f6:	5e                   	pop    %esi
801025f7:	5d                   	pop    %ebp
801025f8:	c3                   	ret    

801025f9 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
801025f9:	55                   	push   %ebp
801025fa:	89 e5                	mov    %esp,%ebp
801025fc:	83 ec 10             	sub    $0x10,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
801025ff:	90                   	nop
80102600:	68 f7 01 00 00       	push   $0x1f7
80102605:	e8 65 ff ff ff       	call   8010256f <inb>
8010260a:	83 c4 04             	add    $0x4,%esp
8010260d:	0f b6 c0             	movzbl %al,%eax
80102610:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102613:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102616:	25 c0 00 00 00       	and    $0xc0,%eax
8010261b:	83 f8 40             	cmp    $0x40,%eax
8010261e:	75 e0                	jne    80102600 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80102620:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102624:	74 11                	je     80102637 <idewait+0x3e>
80102626:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102629:	83 e0 21             	and    $0x21,%eax
8010262c:	85 c0                	test   %eax,%eax
8010262e:	74 07                	je     80102637 <idewait+0x3e>
    return -1;
80102630:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102635:	eb 05                	jmp    8010263c <idewait+0x43>
  return 0;
80102637:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010263c:	c9                   	leave  
8010263d:	c3                   	ret    

8010263e <ideinit>:

void
ideinit(void)
{
8010263e:	55                   	push   %ebp
8010263f:	89 e5                	mov    %esp,%ebp
80102641:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  initlock(&idelock, "ide");
80102644:	83 ec 08             	sub    $0x8,%esp
80102647:	68 b6 89 10 80       	push   $0x801089b6
8010264c:	68 c0 11 11 80       	push   $0x801111c0
80102651:	e8 52 2a 00 00       	call   801050a8 <initlock>
80102656:	83 c4 10             	add    $0x10,%esp
  picenable(IRQ_IDE);
80102659:	83 ec 0c             	sub    $0xc,%esp
8010265c:	6a 0e                	push   $0xe
8010265e:	e8 0f 19 00 00       	call   80103f72 <picenable>
80102663:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_IDE, ncpu - 1);
80102666:	a1 44 19 11 80       	mov    0x80111944,%eax
8010266b:	83 e8 01             	sub    $0x1,%eax
8010266e:	83 ec 08             	sub    $0x8,%esp
80102671:	50                   	push   %eax
80102672:	6a 0e                	push   $0xe
80102674:	e8 73 04 00 00       	call   80102aec <ioapicenable>
80102679:	83 c4 10             	add    $0x10,%esp
  idewait(0);
8010267c:	83 ec 0c             	sub    $0xc,%esp
8010267f:	6a 00                	push   $0x0
80102681:	e8 73 ff ff ff       	call   801025f9 <idewait>
80102686:	83 c4 10             	add    $0x10,%esp
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102689:	83 ec 08             	sub    $0x8,%esp
8010268c:	68 f0 00 00 00       	push   $0xf0
80102691:	68 f6 01 00 00       	push   $0x1f6
80102696:	e8 17 ff ff ff       	call   801025b2 <outb>
8010269b:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<1000; i++){
8010269e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801026a5:	eb 24                	jmp    801026cb <ideinit+0x8d>
    if(inb(0x1f7) != 0){
801026a7:	83 ec 0c             	sub    $0xc,%esp
801026aa:	68 f7 01 00 00       	push   $0x1f7
801026af:	e8 bb fe ff ff       	call   8010256f <inb>
801026b4:	83 c4 10             	add    $0x10,%esp
801026b7:	84 c0                	test   %al,%al
801026b9:	74 0c                	je     801026c7 <ideinit+0x89>
      havedisk1 = 1;
801026bb:	c7 05 f8 11 11 80 01 	movl   $0x1,0x801111f8
801026c2:	00 00 00 
      break;
801026c5:	eb 0d                	jmp    801026d4 <ideinit+0x96>
  for(i=0; i<1000; i++){
801026c7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801026cb:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801026d2:	7e d3                	jle    801026a7 <ideinit+0x69>
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801026d4:	83 ec 08             	sub    $0x8,%esp
801026d7:	68 e0 00 00 00       	push   $0xe0
801026dc:	68 f6 01 00 00       	push   $0x1f6
801026e1:	e8 cc fe ff ff       	call   801025b2 <outb>
801026e6:	83 c4 10             	add    $0x10,%esp
}
801026e9:	90                   	nop
801026ea:	c9                   	leave  
801026eb:	c3                   	ret    

801026ec <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801026ec:	55                   	push   %ebp
801026ed:	89 e5                	mov    %esp,%ebp
801026ef:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801026f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801026f6:	75 0d                	jne    80102705 <idestart+0x19>
    panic("idestart");
801026f8:	83 ec 0c             	sub    $0xc,%esp
801026fb:	68 ba 89 10 80       	push   $0x801089ba
80102700:	e8 76 de ff ff       	call   8010057b <panic>
  if(b->blockno >= FSSIZE)
80102705:	8b 45 08             	mov    0x8(%ebp),%eax
80102708:	8b 40 08             	mov    0x8(%eax),%eax
8010270b:	3d e7 03 00 00       	cmp    $0x3e7,%eax
80102710:	76 0d                	jbe    8010271f <idestart+0x33>
    panic("incorrect blockno");
80102712:	83 ec 0c             	sub    $0xc,%esp
80102715:	68 c3 89 10 80       	push   $0x801089c3
8010271a:	e8 5c de ff ff       	call   8010057b <panic>
  int sector_per_block =  BSIZE/SECTOR_SIZE;
8010271f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  int sector = b->blockno * sector_per_block;
80102726:	8b 45 08             	mov    0x8(%ebp),%eax
80102729:	8b 50 08             	mov    0x8(%eax),%edx
8010272c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010272f:	0f af c2             	imul   %edx,%eax
80102732:	89 45 f0             	mov    %eax,-0x10(%ebp)

  if (sector_per_block > 7) panic("idestart");
80102735:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80102739:	7e 0d                	jle    80102748 <idestart+0x5c>
8010273b:	83 ec 0c             	sub    $0xc,%esp
8010273e:	68 ba 89 10 80       	push   $0x801089ba
80102743:	e8 33 de ff ff       	call   8010057b <panic>
  
  idewait(0);
80102748:	83 ec 0c             	sub    $0xc,%esp
8010274b:	6a 00                	push   $0x0
8010274d:	e8 a7 fe ff ff       	call   801025f9 <idewait>
80102752:	83 c4 10             	add    $0x10,%esp
  outb(0x3f6, 0);  // generate interrupt
80102755:	83 ec 08             	sub    $0x8,%esp
80102758:	6a 00                	push   $0x0
8010275a:	68 f6 03 00 00       	push   $0x3f6
8010275f:	e8 4e fe ff ff       	call   801025b2 <outb>
80102764:	83 c4 10             	add    $0x10,%esp
  outb(0x1f2, sector_per_block);  // number of sectors
80102767:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010276a:	0f b6 c0             	movzbl %al,%eax
8010276d:	83 ec 08             	sub    $0x8,%esp
80102770:	50                   	push   %eax
80102771:	68 f2 01 00 00       	push   $0x1f2
80102776:	e8 37 fe ff ff       	call   801025b2 <outb>
8010277b:	83 c4 10             	add    $0x10,%esp
  outb(0x1f3, sector & 0xff);
8010277e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102781:	0f b6 c0             	movzbl %al,%eax
80102784:	83 ec 08             	sub    $0x8,%esp
80102787:	50                   	push   %eax
80102788:	68 f3 01 00 00       	push   $0x1f3
8010278d:	e8 20 fe ff ff       	call   801025b2 <outb>
80102792:	83 c4 10             	add    $0x10,%esp
  outb(0x1f4, (sector >> 8) & 0xff);
80102795:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102798:	c1 f8 08             	sar    $0x8,%eax
8010279b:	0f b6 c0             	movzbl %al,%eax
8010279e:	83 ec 08             	sub    $0x8,%esp
801027a1:	50                   	push   %eax
801027a2:	68 f4 01 00 00       	push   $0x1f4
801027a7:	e8 06 fe ff ff       	call   801025b2 <outb>
801027ac:	83 c4 10             	add    $0x10,%esp
  outb(0x1f5, (sector >> 16) & 0xff);
801027af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027b2:	c1 f8 10             	sar    $0x10,%eax
801027b5:	0f b6 c0             	movzbl %al,%eax
801027b8:	83 ec 08             	sub    $0x8,%esp
801027bb:	50                   	push   %eax
801027bc:	68 f5 01 00 00       	push   $0x1f5
801027c1:	e8 ec fd ff ff       	call   801025b2 <outb>
801027c6:	83 c4 10             	add    $0x10,%esp
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801027c9:	8b 45 08             	mov    0x8(%ebp),%eax
801027cc:	8b 40 04             	mov    0x4(%eax),%eax
801027cf:	c1 e0 04             	shl    $0x4,%eax
801027d2:	83 e0 10             	and    $0x10,%eax
801027d5:	89 c2                	mov    %eax,%edx
801027d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801027da:	c1 f8 18             	sar    $0x18,%eax
801027dd:	83 e0 0f             	and    $0xf,%eax
801027e0:	09 d0                	or     %edx,%eax
801027e2:	83 c8 e0             	or     $0xffffffe0,%eax
801027e5:	0f b6 c0             	movzbl %al,%eax
801027e8:	83 ec 08             	sub    $0x8,%esp
801027eb:	50                   	push   %eax
801027ec:	68 f6 01 00 00       	push   $0x1f6
801027f1:	e8 bc fd ff ff       	call   801025b2 <outb>
801027f6:	83 c4 10             	add    $0x10,%esp
  if(b->flags & B_DIRTY){
801027f9:	8b 45 08             	mov    0x8(%ebp),%eax
801027fc:	8b 00                	mov    (%eax),%eax
801027fe:	83 e0 04             	and    $0x4,%eax
80102801:	85 c0                	test   %eax,%eax
80102803:	74 30                	je     80102835 <idestart+0x149>
    outb(0x1f7, IDE_CMD_WRITE);
80102805:	83 ec 08             	sub    $0x8,%esp
80102808:	6a 30                	push   $0x30
8010280a:	68 f7 01 00 00       	push   $0x1f7
8010280f:	e8 9e fd ff ff       	call   801025b2 <outb>
80102814:	83 c4 10             	add    $0x10,%esp
    outsl(0x1f0, b->data, BSIZE/4);
80102817:	8b 45 08             	mov    0x8(%ebp),%eax
8010281a:	83 c0 18             	add    $0x18,%eax
8010281d:	83 ec 04             	sub    $0x4,%esp
80102820:	68 80 00 00 00       	push   $0x80
80102825:	50                   	push   %eax
80102826:	68 f0 01 00 00       	push   $0x1f0
8010282b:	e8 a3 fd ff ff       	call   801025d3 <outsl>
80102830:	83 c4 10             	add    $0x10,%esp
  } else {
    outb(0x1f7, IDE_CMD_READ);
  }
}
80102833:	eb 12                	jmp    80102847 <idestart+0x15b>
    outb(0x1f7, IDE_CMD_READ);
80102835:	83 ec 08             	sub    $0x8,%esp
80102838:	6a 20                	push   $0x20
8010283a:	68 f7 01 00 00       	push   $0x1f7
8010283f:	e8 6e fd ff ff       	call   801025b2 <outb>
80102844:	83 c4 10             	add    $0x10,%esp
}
80102847:	90                   	nop
80102848:	c9                   	leave  
80102849:	c3                   	ret    

8010284a <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
8010284a:	55                   	push   %ebp
8010284b:	89 e5                	mov    %esp,%ebp
8010284d:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102850:	83 ec 0c             	sub    $0xc,%esp
80102853:	68 c0 11 11 80       	push   $0x801111c0
80102858:	e8 6d 28 00 00       	call   801050ca <acquire>
8010285d:	83 c4 10             	add    $0x10,%esp
  if((b = idequeue) == 0){
80102860:	a1 f4 11 11 80       	mov    0x801111f4,%eax
80102865:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102868:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010286c:	75 15                	jne    80102883 <ideintr+0x39>
    release(&idelock);
8010286e:	83 ec 0c             	sub    $0xc,%esp
80102871:	68 c0 11 11 80       	push   $0x801111c0
80102876:	e8 b6 28 00 00       	call   80105131 <release>
8010287b:	83 c4 10             	add    $0x10,%esp
    // cprintf("spurious IDE interrupt\n");
    return;
8010287e:	e9 9a 00 00 00       	jmp    8010291d <ideintr+0xd3>
  }
  idequeue = b->qnext;
80102883:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102886:	8b 40 14             	mov    0x14(%eax),%eax
80102889:	a3 f4 11 11 80       	mov    %eax,0x801111f4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
8010288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102891:	8b 00                	mov    (%eax),%eax
80102893:	83 e0 04             	and    $0x4,%eax
80102896:	85 c0                	test   %eax,%eax
80102898:	75 2d                	jne    801028c7 <ideintr+0x7d>
8010289a:	83 ec 0c             	sub    $0xc,%esp
8010289d:	6a 01                	push   $0x1
8010289f:	e8 55 fd ff ff       	call   801025f9 <idewait>
801028a4:	83 c4 10             	add    $0x10,%esp
801028a7:	85 c0                	test   %eax,%eax
801028a9:	78 1c                	js     801028c7 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);
801028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ae:	83 c0 18             	add    $0x18,%eax
801028b1:	83 ec 04             	sub    $0x4,%esp
801028b4:	68 80 00 00 00       	push   $0x80
801028b9:	50                   	push   %eax
801028ba:	68 f0 01 00 00       	push   $0x1f0
801028bf:	e8 c8 fc ff ff       	call   8010258c <insl>
801028c4:	83 c4 10             	add    $0x10,%esp
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
801028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028ca:	8b 00                	mov    (%eax),%eax
801028cc:	83 c8 02             	or     $0x2,%eax
801028cf:	89 c2                	mov    %eax,%edx
801028d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d4:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
801028d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028d9:	8b 00                	mov    (%eax),%eax
801028db:	83 e0 fb             	and    $0xfffffffb,%eax
801028de:	89 c2                	mov    %eax,%edx
801028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801028e3:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801028e5:	83 ec 0c             	sub    $0xc,%esp
801028e8:	ff 75 f4             	push   -0xc(%ebp)
801028eb:	e8 cb 25 00 00       	call   80104ebb <wakeup>
801028f0:	83 c4 10             	add    $0x10,%esp
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801028f3:	a1 f4 11 11 80       	mov    0x801111f4,%eax
801028f8:	85 c0                	test   %eax,%eax
801028fa:	74 11                	je     8010290d <ideintr+0xc3>
    idestart(idequeue);
801028fc:	a1 f4 11 11 80       	mov    0x801111f4,%eax
80102901:	83 ec 0c             	sub    $0xc,%esp
80102904:	50                   	push   %eax
80102905:	e8 e2 fd ff ff       	call   801026ec <idestart>
8010290a:	83 c4 10             	add    $0x10,%esp

  release(&idelock);
8010290d:	83 ec 0c             	sub    $0xc,%esp
80102910:	68 c0 11 11 80       	push   $0x801111c0
80102915:	e8 17 28 00 00       	call   80105131 <release>
8010291a:	83 c4 10             	add    $0x10,%esp
}
8010291d:	c9                   	leave  
8010291e:	c3                   	ret    

8010291f <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
8010291f:	55                   	push   %ebp
80102920:	89 e5                	mov    %esp,%ebp
80102922:	83 ec 18             	sub    $0x18,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
80102925:	8b 45 08             	mov    0x8(%ebp),%eax
80102928:	8b 00                	mov    (%eax),%eax
8010292a:	83 e0 01             	and    $0x1,%eax
8010292d:	85 c0                	test   %eax,%eax
8010292f:	75 0d                	jne    8010293e <iderw+0x1f>
    panic("iderw: buf not busy");
80102931:	83 ec 0c             	sub    $0xc,%esp
80102934:	68 d5 89 10 80       	push   $0x801089d5
80102939:	e8 3d dc ff ff       	call   8010057b <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010293e:	8b 45 08             	mov    0x8(%ebp),%eax
80102941:	8b 00                	mov    (%eax),%eax
80102943:	83 e0 06             	and    $0x6,%eax
80102946:	83 f8 02             	cmp    $0x2,%eax
80102949:	75 0d                	jne    80102958 <iderw+0x39>
    panic("iderw: nothing to do");
8010294b:	83 ec 0c             	sub    $0xc,%esp
8010294e:	68 e9 89 10 80       	push   $0x801089e9
80102953:	e8 23 dc ff ff       	call   8010057b <panic>
  if(b->dev != 0 && !havedisk1)
80102958:	8b 45 08             	mov    0x8(%ebp),%eax
8010295b:	8b 40 04             	mov    0x4(%eax),%eax
8010295e:	85 c0                	test   %eax,%eax
80102960:	74 16                	je     80102978 <iderw+0x59>
80102962:	a1 f8 11 11 80       	mov    0x801111f8,%eax
80102967:	85 c0                	test   %eax,%eax
80102969:	75 0d                	jne    80102978 <iderw+0x59>
    panic("iderw: ide disk 1 not present");
8010296b:	83 ec 0c             	sub    $0xc,%esp
8010296e:	68 fe 89 10 80       	push   $0x801089fe
80102973:	e8 03 dc ff ff       	call   8010057b <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102978:	83 ec 0c             	sub    $0xc,%esp
8010297b:	68 c0 11 11 80       	push   $0x801111c0
80102980:	e8 45 27 00 00       	call   801050ca <acquire>
80102985:	83 c4 10             	add    $0x10,%esp

  // Append b to idequeue.
  b->qnext = 0;
80102988:	8b 45 08             	mov    0x8(%ebp),%eax
8010298b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102992:	c7 45 f4 f4 11 11 80 	movl   $0x801111f4,-0xc(%ebp)
80102999:	eb 0b                	jmp    801029a6 <iderw+0x87>
8010299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010299e:	8b 00                	mov    (%eax),%eax
801029a0:	83 c0 14             	add    $0x14,%eax
801029a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029a9:	8b 00                	mov    (%eax),%eax
801029ab:	85 c0                	test   %eax,%eax
801029ad:	75 ec                	jne    8010299b <iderw+0x7c>
    ;
  *pp = b;
801029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801029b2:	8b 55 08             	mov    0x8(%ebp),%edx
801029b5:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
801029b7:	a1 f4 11 11 80       	mov    0x801111f4,%eax
801029bc:	39 45 08             	cmp    %eax,0x8(%ebp)
801029bf:	75 23                	jne    801029e4 <iderw+0xc5>
    idestart(b);
801029c1:	83 ec 0c             	sub    $0xc,%esp
801029c4:	ff 75 08             	push   0x8(%ebp)
801029c7:	e8 20 fd ff ff       	call   801026ec <idestart>
801029cc:	83 c4 10             	add    $0x10,%esp
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029cf:	eb 13                	jmp    801029e4 <iderw+0xc5>
    sleep(b, &idelock);
801029d1:	83 ec 08             	sub    $0x8,%esp
801029d4:	68 c0 11 11 80       	push   $0x801111c0
801029d9:	ff 75 08             	push   0x8(%ebp)
801029dc:	e8 ee 23 00 00       	call   80104dcf <sleep>
801029e1:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801029e4:	8b 45 08             	mov    0x8(%ebp),%eax
801029e7:	8b 00                	mov    (%eax),%eax
801029e9:	83 e0 06             	and    $0x6,%eax
801029ec:	83 f8 02             	cmp    $0x2,%eax
801029ef:	75 e0                	jne    801029d1 <iderw+0xb2>
  }

  release(&idelock);
801029f1:	83 ec 0c             	sub    $0xc,%esp
801029f4:	68 c0 11 11 80       	push   $0x801111c0
801029f9:	e8 33 27 00 00       	call   80105131 <release>
801029fe:	83 c4 10             	add    $0x10,%esp
}
80102a01:	90                   	nop
80102a02:	c9                   	leave  
80102a03:	c3                   	ret    

80102a04 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
80102a04:	55                   	push   %ebp
80102a05:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a07:	a1 fc 11 11 80       	mov    0x801111fc,%eax
80102a0c:	8b 55 08             	mov    0x8(%ebp),%edx
80102a0f:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
80102a11:	a1 fc 11 11 80       	mov    0x801111fc,%eax
80102a16:	8b 40 10             	mov    0x10(%eax),%eax
}
80102a19:	5d                   	pop    %ebp
80102a1a:	c3                   	ret    

80102a1b <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
80102a1b:	55                   	push   %ebp
80102a1c:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
80102a1e:	a1 fc 11 11 80       	mov    0x801111fc,%eax
80102a23:	8b 55 08             	mov    0x8(%ebp),%edx
80102a26:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
80102a28:	a1 fc 11 11 80       	mov    0x801111fc,%eax
80102a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
80102a30:	89 50 10             	mov    %edx,0x10(%eax)
}
80102a33:	90                   	nop
80102a34:	5d                   	pop    %ebp
80102a35:	c3                   	ret    

80102a36 <ioapicinit>:

void
ioapicinit(void)
{
80102a36:	55                   	push   %ebp
80102a37:	89 e5                	mov    %esp,%ebp
80102a39:	83 ec 18             	sub    $0x18,%esp
  int i, id, maxintr;

  if(!ismp)
80102a3c:	a1 40 19 11 80       	mov    0x80111940,%eax
80102a41:	85 c0                	test   %eax,%eax
80102a43:	0f 84 a0 00 00 00    	je     80102ae9 <ioapicinit+0xb3>
    return;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102a49:	c7 05 fc 11 11 80 00 	movl   $0xfec00000,0x801111fc
80102a50:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102a53:	6a 01                	push   $0x1
80102a55:	e8 aa ff ff ff       	call   80102a04 <ioapicread>
80102a5a:	83 c4 04             	add    $0x4,%esp
80102a5d:	c1 e8 10             	shr    $0x10,%eax
80102a60:	25 ff 00 00 00       	and    $0xff,%eax
80102a65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102a68:	6a 00                	push   $0x0
80102a6a:	e8 95 ff ff ff       	call   80102a04 <ioapicread>
80102a6f:	83 c4 04             	add    $0x4,%esp
80102a72:	c1 e8 18             	shr    $0x18,%eax
80102a75:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
80102a78:	0f b6 05 48 19 11 80 	movzbl 0x80111948,%eax
80102a7f:	0f b6 c0             	movzbl %al,%eax
80102a82:	39 45 ec             	cmp    %eax,-0x14(%ebp)
80102a85:	74 10                	je     80102a97 <ioapicinit+0x61>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102a87:	83 ec 0c             	sub    $0xc,%esp
80102a8a:	68 1c 8a 10 80       	push   $0x80108a1c
80102a8f:	e8 32 d9 ff ff       	call   801003c6 <cprintf>
80102a94:	83 c4 10             	add    $0x10,%esp

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102a97:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80102a9e:	eb 3f                	jmp    80102adf <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102aa3:	83 c0 20             	add    $0x20,%eax
80102aa6:	0d 00 00 01 00       	or     $0x10000,%eax
80102aab:	89 c2                	mov    %eax,%edx
80102aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ab0:	83 c0 08             	add    $0x8,%eax
80102ab3:	01 c0                	add    %eax,%eax
80102ab5:	83 ec 08             	sub    $0x8,%esp
80102ab8:	52                   	push   %edx
80102ab9:	50                   	push   %eax
80102aba:	e8 5c ff ff ff       	call   80102a1b <ioapicwrite>
80102abf:	83 c4 10             	add    $0x10,%esp
    ioapicwrite(REG_TABLE+2*i+1, 0);
80102ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ac5:	83 c0 08             	add    $0x8,%eax
80102ac8:	01 c0                	add    %eax,%eax
80102aca:	83 c0 01             	add    $0x1,%eax
80102acd:	83 ec 08             	sub    $0x8,%esp
80102ad0:	6a 00                	push   $0x0
80102ad2:	50                   	push   %eax
80102ad3:	e8 43 ff ff ff       	call   80102a1b <ioapicwrite>
80102ad8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i <= maxintr; i++){
80102adb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80102adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ae2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102ae5:	7e b9                	jle    80102aa0 <ioapicinit+0x6a>
80102ae7:	eb 01                	jmp    80102aea <ioapicinit+0xb4>
    return;
80102ae9:	90                   	nop
  }
}
80102aea:	c9                   	leave  
80102aeb:	c3                   	ret    

80102aec <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102aec:	55                   	push   %ebp
80102aed:	89 e5                	mov    %esp,%ebp
  if(!ismp)
80102aef:	a1 40 19 11 80       	mov    0x80111940,%eax
80102af4:	85 c0                	test   %eax,%eax
80102af6:	74 39                	je     80102b31 <ioapicenable+0x45>
    return;

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102af8:	8b 45 08             	mov    0x8(%ebp),%eax
80102afb:	83 c0 20             	add    $0x20,%eax
80102afe:	89 c2                	mov    %eax,%edx
80102b00:	8b 45 08             	mov    0x8(%ebp),%eax
80102b03:	83 c0 08             	add    $0x8,%eax
80102b06:	01 c0                	add    %eax,%eax
80102b08:	52                   	push   %edx
80102b09:	50                   	push   %eax
80102b0a:	e8 0c ff ff ff       	call   80102a1b <ioapicwrite>
80102b0f:	83 c4 08             	add    $0x8,%esp
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102b12:	8b 45 0c             	mov    0xc(%ebp),%eax
80102b15:	c1 e0 18             	shl    $0x18,%eax
80102b18:	89 c2                	mov    %eax,%edx
80102b1a:	8b 45 08             	mov    0x8(%ebp),%eax
80102b1d:	83 c0 08             	add    $0x8,%eax
80102b20:	01 c0                	add    %eax,%eax
80102b22:	83 c0 01             	add    $0x1,%eax
80102b25:	52                   	push   %edx
80102b26:	50                   	push   %eax
80102b27:	e8 ef fe ff ff       	call   80102a1b <ioapicwrite>
80102b2c:	83 c4 08             	add    $0x8,%esp
80102b2f:	eb 01                	jmp    80102b32 <ioapicenable+0x46>
    return;
80102b31:	90                   	nop
}
80102b32:	c9                   	leave  
80102b33:	c3                   	ret    

80102b34 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80102b34:	55                   	push   %ebp
80102b35:	89 e5                	mov    %esp,%ebp
80102b37:	8b 45 08             	mov    0x8(%ebp),%eax
80102b3a:	05 00 00 00 80       	add    $0x80000000,%eax
80102b3f:	5d                   	pop    %ebp
80102b40:	c3                   	ret    

80102b41 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
80102b41:	55                   	push   %ebp
80102b42:	89 e5                	mov    %esp,%ebp
80102b44:	83 ec 08             	sub    $0x8,%esp
  initlock(&kmem.lock, "kmem");
80102b47:	83 ec 08             	sub    $0x8,%esp
80102b4a:	68 4e 8a 10 80       	push   $0x80108a4e
80102b4f:	68 20 12 11 80       	push   $0x80111220
80102b54:	e8 4f 25 00 00       	call   801050a8 <initlock>
80102b59:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
80102b5c:	c7 05 54 12 11 80 00 	movl   $0x0,0x80111254
80102b63:	00 00 00 
  freerange(vstart, vend);
80102b66:	83 ec 08             	sub    $0x8,%esp
80102b69:	ff 75 0c             	push   0xc(%ebp)
80102b6c:	ff 75 08             	push   0x8(%ebp)
80102b6f:	e8 2a 00 00 00       	call   80102b9e <freerange>
80102b74:	83 c4 10             	add    $0x10,%esp
}
80102b77:	90                   	nop
80102b78:	c9                   	leave  
80102b79:	c3                   	ret    

80102b7a <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102b7a:	55                   	push   %ebp
80102b7b:	89 e5                	mov    %esp,%ebp
80102b7d:	83 ec 08             	sub    $0x8,%esp
  freerange(vstart, vend);
80102b80:	83 ec 08             	sub    $0x8,%esp
80102b83:	ff 75 0c             	push   0xc(%ebp)
80102b86:	ff 75 08             	push   0x8(%ebp)
80102b89:	e8 10 00 00 00       	call   80102b9e <freerange>
80102b8e:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 1;
80102b91:	c7 05 54 12 11 80 01 	movl   $0x1,0x80111254
80102b98:	00 00 00 
}
80102b9b:	90                   	nop
80102b9c:	c9                   	leave  
80102b9d:	c3                   	ret    

80102b9e <freerange>:

void
freerange(void *vstart, void *vend)
{
80102b9e:	55                   	push   %ebp
80102b9f:	89 e5                	mov    %esp,%ebp
80102ba1:	83 ec 18             	sub    $0x18,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102ba4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ba7:	05 ff 0f 00 00       	add    $0xfff,%eax
80102bac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102bb1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bb4:	eb 15                	jmp    80102bcb <freerange+0x2d>
    kfree(p);
80102bb6:	83 ec 0c             	sub    $0xc,%esp
80102bb9:	ff 75 f4             	push   -0xc(%ebp)
80102bbc:	e8 1b 00 00 00       	call   80102bdc <kfree>
80102bc1:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102bc4:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102bce:	05 00 10 00 00       	add    $0x1000,%eax
80102bd3:	39 45 0c             	cmp    %eax,0xc(%ebp)
80102bd6:	73 de                	jae    80102bb6 <freerange+0x18>
}
80102bd8:	90                   	nop
80102bd9:	90                   	nop
80102bda:	c9                   	leave  
80102bdb:	c3                   	ret    

80102bdc <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102bdc:	55                   	push   %ebp
80102bdd:	89 e5                	mov    %esp,%ebp
80102bdf:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102be2:	8b 45 08             	mov    0x8(%ebp),%eax
80102be5:	25 ff 0f 00 00       	and    $0xfff,%eax
80102bea:	85 c0                	test   %eax,%eax
80102bec:	75 1b                	jne    80102c09 <kfree+0x2d>
80102bee:	81 7d 08 60 51 11 80 	cmpl   $0x80115160,0x8(%ebp)
80102bf5:	72 12                	jb     80102c09 <kfree+0x2d>
80102bf7:	ff 75 08             	push   0x8(%ebp)
80102bfa:	e8 35 ff ff ff       	call   80102b34 <v2p>
80102bff:	83 c4 04             	add    $0x4,%esp
80102c02:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102c07:	76 0d                	jbe    80102c16 <kfree+0x3a>
    panic("kfree");
80102c09:	83 ec 0c             	sub    $0xc,%esp
80102c0c:	68 53 8a 10 80       	push   $0x80108a53
80102c11:	e8 65 d9 ff ff       	call   8010057b <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102c16:	83 ec 04             	sub    $0x4,%esp
80102c19:	68 00 10 00 00       	push   $0x1000
80102c1e:	6a 01                	push   $0x1
80102c20:	ff 75 08             	push   0x8(%ebp)
80102c23:	e8 05 27 00 00       	call   8010532d <memset>
80102c28:	83 c4 10             	add    $0x10,%esp

  if(kmem.use_lock)
80102c2b:	a1 54 12 11 80       	mov    0x80111254,%eax
80102c30:	85 c0                	test   %eax,%eax
80102c32:	74 10                	je     80102c44 <kfree+0x68>
    acquire(&kmem.lock);
80102c34:	83 ec 0c             	sub    $0xc,%esp
80102c37:	68 20 12 11 80       	push   $0x80111220
80102c3c:	e8 89 24 00 00       	call   801050ca <acquire>
80102c41:	83 c4 10             	add    $0x10,%esp
  r = (struct run*)v;
80102c44:	8b 45 08             	mov    0x8(%ebp),%eax
80102c47:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102c4a:	8b 15 58 12 11 80    	mov    0x80111258,%edx
80102c50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c53:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102c58:	a3 58 12 11 80       	mov    %eax,0x80111258
  free_frame_cnt++;         // CS 3320: project 2
80102c5d:	a1 00 12 11 80       	mov    0x80111200,%eax
80102c62:	83 c0 01             	add    $0x1,%eax
80102c65:	a3 00 12 11 80       	mov    %eax,0x80111200
  if(kmem.use_lock)
80102c6a:	a1 54 12 11 80       	mov    0x80111254,%eax
80102c6f:	85 c0                	test   %eax,%eax
80102c71:	74 10                	je     80102c83 <kfree+0xa7>
    release(&kmem.lock);
80102c73:	83 ec 0c             	sub    $0xc,%esp
80102c76:	68 20 12 11 80       	push   $0x80111220
80102c7b:	e8 b1 24 00 00       	call   80105131 <release>
80102c80:	83 c4 10             	add    $0x10,%esp
}
80102c83:	90                   	nop
80102c84:	c9                   	leave  
80102c85:	c3                   	ret    

80102c86 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102c86:	55                   	push   %ebp
80102c87:	89 e5                	mov    %esp,%ebp
80102c89:	83 ec 18             	sub    $0x18,%esp
  struct run *r;

  if(kmem.use_lock)
80102c8c:	a1 54 12 11 80       	mov    0x80111254,%eax
80102c91:	85 c0                	test   %eax,%eax
80102c93:	74 10                	je     80102ca5 <kalloc+0x1f>
    acquire(&kmem.lock);
80102c95:	83 ec 0c             	sub    $0xc,%esp
80102c98:	68 20 12 11 80       	push   $0x80111220
80102c9d:	e8 28 24 00 00       	call   801050ca <acquire>
80102ca2:	83 c4 10             	add    $0x10,%esp
  r = kmem.freelist;
80102ca5:	a1 58 12 11 80       	mov    0x80111258,%eax
80102caa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102cad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102cb1:	74 17                	je     80102cca <kalloc+0x44>
  {
    free_frame_cnt--;     // CS 3320: project 2
80102cb3:	a1 00 12 11 80       	mov    0x80111200,%eax
80102cb8:	83 e8 01             	sub    $0x1,%eax
80102cbb:	a3 00 12 11 80       	mov    %eax,0x80111200
    kmem.freelist = r->next;
80102cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102cc3:	8b 00                	mov    (%eax),%eax
80102cc5:	a3 58 12 11 80       	mov    %eax,0x80111258
  }
  if(kmem.use_lock)
80102cca:	a1 54 12 11 80       	mov    0x80111254,%eax
80102ccf:	85 c0                	test   %eax,%eax
80102cd1:	74 10                	je     80102ce3 <kalloc+0x5d>
    release(&kmem.lock);
80102cd3:	83 ec 0c             	sub    $0xc,%esp
80102cd6:	68 20 12 11 80       	push   $0x80111220
80102cdb:	e8 51 24 00 00       	call   80105131 <release>
80102ce0:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
80102ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102ce6:	c9                   	leave  
80102ce7:	c3                   	ret    

80102ce8 <inb>:
{
80102ce8:	55                   	push   %ebp
80102ce9:	89 e5                	mov    %esp,%ebp
80102ceb:	83 ec 14             	sub    $0x14,%esp
80102cee:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf1:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cf5:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cf9:	89 c2                	mov    %eax,%edx
80102cfb:	ec                   	in     (%dx),%al
80102cfc:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102cff:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d03:	c9                   	leave  
80102d04:	c3                   	ret    

80102d05 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102d05:	55                   	push   %ebp
80102d06:	89 e5                	mov    %esp,%ebp
80102d08:	83 ec 10             	sub    $0x10,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102d0b:	6a 64                	push   $0x64
80102d0d:	e8 d6 ff ff ff       	call   80102ce8 <inb>
80102d12:	83 c4 04             	add    $0x4,%esp
80102d15:	0f b6 c0             	movzbl %al,%eax
80102d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102d1e:	83 e0 01             	and    $0x1,%eax
80102d21:	85 c0                	test   %eax,%eax
80102d23:	75 0a                	jne    80102d2f <kbdgetc+0x2a>
    return -1;
80102d25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d2a:	e9 23 01 00 00       	jmp    80102e52 <kbdgetc+0x14d>
  data = inb(KBDATAP);
80102d2f:	6a 60                	push   $0x60
80102d31:	e8 b2 ff ff ff       	call   80102ce8 <inb>
80102d36:	83 c4 04             	add    $0x4,%esp
80102d39:	0f b6 c0             	movzbl %al,%eax
80102d3c:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102d3f:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102d46:	75 17                	jne    80102d5f <kbdgetc+0x5a>
    shift |= E0ESC;
80102d48:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102d4d:	83 c8 40             	or     $0x40,%eax
80102d50:	a3 5c 12 11 80       	mov    %eax,0x8011125c
    return 0;
80102d55:	b8 00 00 00 00       	mov    $0x0,%eax
80102d5a:	e9 f3 00 00 00       	jmp    80102e52 <kbdgetc+0x14d>
  } else if(data & 0x80){
80102d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d62:	25 80 00 00 00       	and    $0x80,%eax
80102d67:	85 c0                	test   %eax,%eax
80102d69:	74 45                	je     80102db0 <kbdgetc+0xab>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102d6b:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102d70:	83 e0 40             	and    $0x40,%eax
80102d73:	85 c0                	test   %eax,%eax
80102d75:	75 08                	jne    80102d7f <kbdgetc+0x7a>
80102d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d7a:	83 e0 7f             	and    $0x7f,%eax
80102d7d:	eb 03                	jmp    80102d82 <kbdgetc+0x7d>
80102d7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d82:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102d85:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102d88:	05 20 90 10 80       	add    $0x80109020,%eax
80102d8d:	0f b6 00             	movzbl (%eax),%eax
80102d90:	83 c8 40             	or     $0x40,%eax
80102d93:	0f b6 c0             	movzbl %al,%eax
80102d96:	f7 d0                	not    %eax
80102d98:	89 c2                	mov    %eax,%edx
80102d9a:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102d9f:	21 d0                	and    %edx,%eax
80102da1:	a3 5c 12 11 80       	mov    %eax,0x8011125c
    return 0;
80102da6:	b8 00 00 00 00       	mov    $0x0,%eax
80102dab:	e9 a2 00 00 00       	jmp    80102e52 <kbdgetc+0x14d>
  } else if(shift & E0ESC){
80102db0:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102db5:	83 e0 40             	and    $0x40,%eax
80102db8:	85 c0                	test   %eax,%eax
80102dba:	74 14                	je     80102dd0 <kbdgetc+0xcb>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102dbc:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102dc3:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102dc8:	83 e0 bf             	and    $0xffffffbf,%eax
80102dcb:	a3 5c 12 11 80       	mov    %eax,0x8011125c
  }

  shift |= shiftcode[data];
80102dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102dd3:	05 20 90 10 80       	add    $0x80109020,%eax
80102dd8:	0f b6 00             	movzbl (%eax),%eax
80102ddb:	0f b6 d0             	movzbl %al,%edx
80102dde:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102de3:	09 d0                	or     %edx,%eax
80102de5:	a3 5c 12 11 80       	mov    %eax,0x8011125c
  shift ^= togglecode[data];
80102dea:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102ded:	05 20 91 10 80       	add    $0x80109120,%eax
80102df2:	0f b6 00             	movzbl (%eax),%eax
80102df5:	0f b6 d0             	movzbl %al,%edx
80102df8:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102dfd:	31 d0                	xor    %edx,%eax
80102dff:	a3 5c 12 11 80       	mov    %eax,0x8011125c
  c = charcode[shift & (CTL | SHIFT)][data];
80102e04:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102e09:	83 e0 03             	and    $0x3,%eax
80102e0c:	8b 14 85 20 95 10 80 	mov    -0x7fef6ae0(,%eax,4),%edx
80102e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102e16:	01 d0                	add    %edx,%eax
80102e18:	0f b6 00             	movzbl (%eax),%eax
80102e1b:	0f b6 c0             	movzbl %al,%eax
80102e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102e21:	a1 5c 12 11 80       	mov    0x8011125c,%eax
80102e26:	83 e0 08             	and    $0x8,%eax
80102e29:	85 c0                	test   %eax,%eax
80102e2b:	74 22                	je     80102e4f <kbdgetc+0x14a>
    if('a' <= c && c <= 'z')
80102e2d:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102e31:	76 0c                	jbe    80102e3f <kbdgetc+0x13a>
80102e33:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102e37:	77 06                	ja     80102e3f <kbdgetc+0x13a>
      c += 'A' - 'a';
80102e39:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102e3d:	eb 10                	jmp    80102e4f <kbdgetc+0x14a>
    else if('A' <= c && c <= 'Z')
80102e3f:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102e43:	76 0a                	jbe    80102e4f <kbdgetc+0x14a>
80102e45:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102e49:	77 04                	ja     80102e4f <kbdgetc+0x14a>
      c += 'a' - 'A';
80102e4b:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102e52:	c9                   	leave  
80102e53:	c3                   	ret    

80102e54 <kbdintr>:

void
kbdintr(void)
{
80102e54:	55                   	push   %ebp
80102e55:	89 e5                	mov    %esp,%ebp
80102e57:	83 ec 08             	sub    $0x8,%esp
  consoleintr(kbdgetc);
80102e5a:	83 ec 0c             	sub    $0xc,%esp
80102e5d:	68 05 2d 10 80       	push   $0x80102d05
80102e62:	e8 b5 d9 ff ff       	call   8010081c <consoleintr>
80102e67:	83 c4 10             	add    $0x10,%esp
}
80102e6a:	90                   	nop
80102e6b:	c9                   	leave  
80102e6c:	c3                   	ret    

80102e6d <inb>:
{
80102e6d:	55                   	push   %ebp
80102e6e:	89 e5                	mov    %esp,%ebp
80102e70:	83 ec 14             	sub    $0x14,%esp
80102e73:	8b 45 08             	mov    0x8(%ebp),%eax
80102e76:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102e7a:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102e7e:	89 c2                	mov    %eax,%edx
80102e80:	ec                   	in     (%dx),%al
80102e81:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102e84:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102e88:	c9                   	leave  
80102e89:	c3                   	ret    

80102e8a <outb>:
{
80102e8a:	55                   	push   %ebp
80102e8b:	89 e5                	mov    %esp,%ebp
80102e8d:	83 ec 08             	sub    $0x8,%esp
80102e90:	8b 45 08             	mov    0x8(%ebp),%eax
80102e93:	8b 55 0c             	mov    0xc(%ebp),%edx
80102e96:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80102e9a:	89 d0                	mov    %edx,%eax
80102e9c:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102e9f:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102ea3:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102ea7:	ee                   	out    %al,(%dx)
}
80102ea8:	90                   	nop
80102ea9:	c9                   	leave  
80102eaa:	c3                   	ret    

80102eab <readeflags>:
{
80102eab:	55                   	push   %ebp
80102eac:	89 e5                	mov    %esp,%ebp
80102eae:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102eb1:	9c                   	pushf  
80102eb2:	58                   	pop    %eax
80102eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102eb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102eb9:	c9                   	leave  
80102eba:	c3                   	ret    

80102ebb <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102ebb:	55                   	push   %ebp
80102ebc:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102ebe:	8b 15 60 12 11 80    	mov    0x80111260,%edx
80102ec4:	8b 45 08             	mov    0x8(%ebp),%eax
80102ec7:	c1 e0 02             	shl    $0x2,%eax
80102eca:	01 c2                	add    %eax,%edx
80102ecc:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ecf:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102ed1:	a1 60 12 11 80       	mov    0x80111260,%eax
80102ed6:	83 c0 20             	add    $0x20,%eax
80102ed9:	8b 00                	mov    (%eax),%eax
}
80102edb:	90                   	nop
80102edc:	5d                   	pop    %ebp
80102edd:	c3                   	ret    

80102ede <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102ede:	55                   	push   %ebp
80102edf:	89 e5                	mov    %esp,%ebp
  if(!lapic) 
80102ee1:	a1 60 12 11 80       	mov    0x80111260,%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	0f 84 0c 01 00 00    	je     80102ffa <lapicinit+0x11c>
    return;

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102eee:	68 3f 01 00 00       	push   $0x13f
80102ef3:	6a 3c                	push   $0x3c
80102ef5:	e8 c1 ff ff ff       	call   80102ebb <lapicw>
80102efa:	83 c4 08             	add    $0x8,%esp

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102efd:	6a 0b                	push   $0xb
80102eff:	68 f8 00 00 00       	push   $0xf8
80102f04:	e8 b2 ff ff ff       	call   80102ebb <lapicw>
80102f09:	83 c4 08             	add    $0x8,%esp
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102f0c:	68 20 00 02 00       	push   $0x20020
80102f11:	68 c8 00 00 00       	push   $0xc8
80102f16:	e8 a0 ff ff ff       	call   80102ebb <lapicw>
80102f1b:	83 c4 08             	add    $0x8,%esp
  lapicw(TICR, 10000000); 
80102f1e:	68 80 96 98 00       	push   $0x989680
80102f23:	68 e0 00 00 00       	push   $0xe0
80102f28:	e8 8e ff ff ff       	call   80102ebb <lapicw>
80102f2d:	83 c4 08             	add    $0x8,%esp

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102f30:	68 00 00 01 00       	push   $0x10000
80102f35:	68 d4 00 00 00       	push   $0xd4
80102f3a:	e8 7c ff ff ff       	call   80102ebb <lapicw>
80102f3f:	83 c4 08             	add    $0x8,%esp
  lapicw(LINT1, MASKED);
80102f42:	68 00 00 01 00       	push   $0x10000
80102f47:	68 d8 00 00 00       	push   $0xd8
80102f4c:	e8 6a ff ff ff       	call   80102ebb <lapicw>
80102f51:	83 c4 08             	add    $0x8,%esp

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102f54:	a1 60 12 11 80       	mov    0x80111260,%eax
80102f59:	83 c0 30             	add    $0x30,%eax
80102f5c:	8b 00                	mov    (%eax),%eax
80102f5e:	c1 e8 10             	shr    $0x10,%eax
80102f61:	25 fc 00 00 00       	and    $0xfc,%eax
80102f66:	85 c0                	test   %eax,%eax
80102f68:	74 12                	je     80102f7c <lapicinit+0x9e>
    lapicw(PCINT, MASKED);
80102f6a:	68 00 00 01 00       	push   $0x10000
80102f6f:	68 d0 00 00 00       	push   $0xd0
80102f74:	e8 42 ff ff ff       	call   80102ebb <lapicw>
80102f79:	83 c4 08             	add    $0x8,%esp

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102f7c:	6a 33                	push   $0x33
80102f7e:	68 dc 00 00 00       	push   $0xdc
80102f83:	e8 33 ff ff ff       	call   80102ebb <lapicw>
80102f88:	83 c4 08             	add    $0x8,%esp

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102f8b:	6a 00                	push   $0x0
80102f8d:	68 a0 00 00 00       	push   $0xa0
80102f92:	e8 24 ff ff ff       	call   80102ebb <lapicw>
80102f97:	83 c4 08             	add    $0x8,%esp
  lapicw(ESR, 0);
80102f9a:	6a 00                	push   $0x0
80102f9c:	68 a0 00 00 00       	push   $0xa0
80102fa1:	e8 15 ff ff ff       	call   80102ebb <lapicw>
80102fa6:	83 c4 08             	add    $0x8,%esp

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102fa9:	6a 00                	push   $0x0
80102fab:	6a 2c                	push   $0x2c
80102fad:	e8 09 ff ff ff       	call   80102ebb <lapicw>
80102fb2:	83 c4 08             	add    $0x8,%esp

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102fb5:	6a 00                	push   $0x0
80102fb7:	68 c4 00 00 00       	push   $0xc4
80102fbc:	e8 fa fe ff ff       	call   80102ebb <lapicw>
80102fc1:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102fc4:	68 00 85 08 00       	push   $0x88500
80102fc9:	68 c0 00 00 00       	push   $0xc0
80102fce:	e8 e8 fe ff ff       	call   80102ebb <lapicw>
80102fd3:	83 c4 08             	add    $0x8,%esp
  while(lapic[ICRLO] & DELIVS)
80102fd6:	90                   	nop
80102fd7:	a1 60 12 11 80       	mov    0x80111260,%eax
80102fdc:	05 00 03 00 00       	add    $0x300,%eax
80102fe1:	8b 00                	mov    (%eax),%eax
80102fe3:	25 00 10 00 00       	and    $0x1000,%eax
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	75 eb                	jne    80102fd7 <lapicinit+0xf9>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102fec:	6a 00                	push   $0x0
80102fee:	6a 20                	push   $0x20
80102ff0:	e8 c6 fe ff ff       	call   80102ebb <lapicw>
80102ff5:	83 c4 08             	add    $0x8,%esp
80102ff8:	eb 01                	jmp    80102ffb <lapicinit+0x11d>
    return;
80102ffa:	90                   	nop
}
80102ffb:	c9                   	leave  
80102ffc:	c3                   	ret    

80102ffd <cpunum>:

int
cpunum(void)
{
80102ffd:	55                   	push   %ebp
80102ffe:	89 e5                	mov    %esp,%ebp
80103000:	83 ec 08             	sub    $0x8,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80103003:	e8 a3 fe ff ff       	call   80102eab <readeflags>
80103008:	25 00 02 00 00       	and    $0x200,%eax
8010300d:	85 c0                	test   %eax,%eax
8010300f:	74 26                	je     80103037 <cpunum+0x3a>
    static int n;
    if(n++ == 0)
80103011:	a1 64 12 11 80       	mov    0x80111264,%eax
80103016:	8d 50 01             	lea    0x1(%eax),%edx
80103019:	89 15 64 12 11 80    	mov    %edx,0x80111264
8010301f:	85 c0                	test   %eax,%eax
80103021:	75 14                	jne    80103037 <cpunum+0x3a>
      cprintf("cpu called from %x with interrupts enabled\n",
80103023:	8b 45 04             	mov    0x4(%ebp),%eax
80103026:	83 ec 08             	sub    $0x8,%esp
80103029:	50                   	push   %eax
8010302a:	68 5c 8a 10 80       	push   $0x80108a5c
8010302f:	e8 92 d3 ff ff       	call   801003c6 <cprintf>
80103034:	83 c4 10             	add    $0x10,%esp
        __builtin_return_address(0));
  }

  if(lapic)
80103037:	a1 60 12 11 80       	mov    0x80111260,%eax
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 0f                	je     8010304f <cpunum+0x52>
    return lapic[ID]>>24;
80103040:	a1 60 12 11 80       	mov    0x80111260,%eax
80103045:	83 c0 20             	add    $0x20,%eax
80103048:	8b 00                	mov    (%eax),%eax
8010304a:	c1 e8 18             	shr    $0x18,%eax
8010304d:	eb 05                	jmp    80103054 <cpunum+0x57>
  return 0;
8010304f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103054:	c9                   	leave  
80103055:	c3                   	ret    

80103056 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80103056:	55                   	push   %ebp
80103057:	89 e5                	mov    %esp,%ebp
  if(lapic)
80103059:	a1 60 12 11 80       	mov    0x80111260,%eax
8010305e:	85 c0                	test   %eax,%eax
80103060:	74 0c                	je     8010306e <lapiceoi+0x18>
    lapicw(EOI, 0);
80103062:	6a 00                	push   $0x0
80103064:	6a 2c                	push   $0x2c
80103066:	e8 50 fe ff ff       	call   80102ebb <lapicw>
8010306b:	83 c4 08             	add    $0x8,%esp
}
8010306e:	90                   	nop
8010306f:	c9                   	leave  
80103070:	c3                   	ret    

80103071 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80103071:	55                   	push   %ebp
80103072:	89 e5                	mov    %esp,%ebp
}
80103074:	90                   	nop
80103075:	5d                   	pop    %ebp
80103076:	c3                   	ret    

80103077 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80103077:	55                   	push   %ebp
80103078:	89 e5                	mov    %esp,%ebp
8010307a:	83 ec 14             	sub    $0x14,%esp
8010307d:	8b 45 08             	mov    0x8(%ebp),%eax
80103080:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80103083:	6a 0f                	push   $0xf
80103085:	6a 70                	push   $0x70
80103087:	e8 fe fd ff ff       	call   80102e8a <outb>
8010308c:	83 c4 08             	add    $0x8,%esp
  outb(CMOS_PORT+1, 0x0A);
8010308f:	6a 0a                	push   $0xa
80103091:	6a 71                	push   $0x71
80103093:	e8 f2 fd ff ff       	call   80102e8a <outb>
80103098:	83 c4 08             	add    $0x8,%esp
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
8010309b:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
801030a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030a5:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
801030aa:	8b 45 0c             	mov    0xc(%ebp),%eax
801030ad:	c1 e8 04             	shr    $0x4,%eax
801030b0:	89 c2                	mov    %eax,%edx
801030b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
801030b5:	83 c0 02             	add    $0x2,%eax
801030b8:	66 89 10             	mov    %dx,(%eax)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801030bb:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
801030bf:	c1 e0 18             	shl    $0x18,%eax
801030c2:	50                   	push   %eax
801030c3:	68 c4 00 00 00       	push   $0xc4
801030c8:	e8 ee fd ff ff       	call   80102ebb <lapicw>
801030cd:	83 c4 08             	add    $0x8,%esp
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801030d0:	68 00 c5 00 00       	push   $0xc500
801030d5:	68 c0 00 00 00       	push   $0xc0
801030da:	e8 dc fd ff ff       	call   80102ebb <lapicw>
801030df:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
801030e2:	68 c8 00 00 00       	push   $0xc8
801030e7:	e8 85 ff ff ff       	call   80103071 <microdelay>
801030ec:	83 c4 04             	add    $0x4,%esp
  lapicw(ICRLO, INIT | LEVEL);
801030ef:	68 00 85 00 00       	push   $0x8500
801030f4:	68 c0 00 00 00       	push   $0xc0
801030f9:	e8 bd fd ff ff       	call   80102ebb <lapicw>
801030fe:	83 c4 08             	add    $0x8,%esp
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80103101:	6a 64                	push   $0x64
80103103:	e8 69 ff ff ff       	call   80103071 <microdelay>
80103108:	83 c4 04             	add    $0x4,%esp
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
8010310b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103112:	eb 3d                	jmp    80103151 <lapicstartap+0xda>
    lapicw(ICRHI, apicid<<24);
80103114:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80103118:	c1 e0 18             	shl    $0x18,%eax
8010311b:	50                   	push   %eax
8010311c:	68 c4 00 00 00       	push   $0xc4
80103121:	e8 95 fd ff ff       	call   80102ebb <lapicw>
80103126:	83 c4 08             	add    $0x8,%esp
    lapicw(ICRLO, STARTUP | (addr>>12));
80103129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010312c:	c1 e8 0c             	shr    $0xc,%eax
8010312f:	80 cc 06             	or     $0x6,%ah
80103132:	50                   	push   %eax
80103133:	68 c0 00 00 00       	push   $0xc0
80103138:	e8 7e fd ff ff       	call   80102ebb <lapicw>
8010313d:	83 c4 08             	add    $0x8,%esp
    microdelay(200);
80103140:	68 c8 00 00 00       	push   $0xc8
80103145:	e8 27 ff ff ff       	call   80103071 <microdelay>
8010314a:	83 c4 04             	add    $0x4,%esp
  for(i = 0; i < 2; i++){
8010314d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103151:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
80103155:	7e bd                	jle    80103114 <lapicstartap+0x9d>
  }
}
80103157:	90                   	nop
80103158:	90                   	nop
80103159:	c9                   	leave  
8010315a:	c3                   	ret    

8010315b <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010315b:	55                   	push   %ebp
8010315c:	89 e5                	mov    %esp,%ebp
  outb(CMOS_PORT,  reg);
8010315e:	8b 45 08             	mov    0x8(%ebp),%eax
80103161:	0f b6 c0             	movzbl %al,%eax
80103164:	50                   	push   %eax
80103165:	6a 70                	push   $0x70
80103167:	e8 1e fd ff ff       	call   80102e8a <outb>
8010316c:	83 c4 08             	add    $0x8,%esp
  microdelay(200);
8010316f:	68 c8 00 00 00       	push   $0xc8
80103174:	e8 f8 fe ff ff       	call   80103071 <microdelay>
80103179:	83 c4 04             	add    $0x4,%esp

  return inb(CMOS_RETURN);
8010317c:	6a 71                	push   $0x71
8010317e:	e8 ea fc ff ff       	call   80102e6d <inb>
80103183:	83 c4 04             	add    $0x4,%esp
80103186:	0f b6 c0             	movzbl %al,%eax
}
80103189:	c9                   	leave  
8010318a:	c3                   	ret    

8010318b <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
8010318b:	55                   	push   %ebp
8010318c:	89 e5                	mov    %esp,%ebp
  r->second = cmos_read(SECS);
8010318e:	6a 00                	push   $0x0
80103190:	e8 c6 ff ff ff       	call   8010315b <cmos_read>
80103195:	83 c4 04             	add    $0x4,%esp
80103198:	8b 55 08             	mov    0x8(%ebp),%edx
8010319b:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010319d:	6a 02                	push   $0x2
8010319f:	e8 b7 ff ff ff       	call   8010315b <cmos_read>
801031a4:	83 c4 04             	add    $0x4,%esp
801031a7:	8b 55 08             	mov    0x8(%ebp),%edx
801031aa:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
801031ad:	6a 04                	push   $0x4
801031af:	e8 a7 ff ff ff       	call   8010315b <cmos_read>
801031b4:	83 c4 04             	add    $0x4,%esp
801031b7:	8b 55 08             	mov    0x8(%ebp),%edx
801031ba:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801031bd:	6a 07                	push   $0x7
801031bf:	e8 97 ff ff ff       	call   8010315b <cmos_read>
801031c4:	83 c4 04             	add    $0x4,%esp
801031c7:	8b 55 08             	mov    0x8(%ebp),%edx
801031ca:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801031cd:	6a 08                	push   $0x8
801031cf:	e8 87 ff ff ff       	call   8010315b <cmos_read>
801031d4:	83 c4 04             	add    $0x4,%esp
801031d7:	8b 55 08             	mov    0x8(%ebp),%edx
801031da:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801031dd:	6a 09                	push   $0x9
801031df:	e8 77 ff ff ff       	call   8010315b <cmos_read>
801031e4:	83 c4 04             	add    $0x4,%esp
801031e7:	8b 55 08             	mov    0x8(%ebp),%edx
801031ea:	89 42 14             	mov    %eax,0x14(%edx)
}
801031ed:	90                   	nop
801031ee:	c9                   	leave  
801031ef:	c3                   	ret    

801031f0 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	83 ec 48             	sub    $0x48,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801031f6:	6a 0b                	push   $0xb
801031f8:	e8 5e ff ff ff       	call   8010315b <cmos_read>
801031fd:	83 c4 04             	add    $0x4,%esp
80103200:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
80103203:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103206:	83 e0 04             	and    $0x4,%eax
80103209:	85 c0                	test   %eax,%eax
8010320b:	0f 94 c0             	sete   %al
8010320e:	0f b6 c0             	movzbl %al,%eax
80103211:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103214:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103217:	50                   	push   %eax
80103218:	e8 6e ff ff ff       	call   8010318b <fill_rtcdate>
8010321d:	83 c4 04             	add    $0x4,%esp
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
80103220:	6a 0a                	push   $0xa
80103222:	e8 34 ff ff ff       	call   8010315b <cmos_read>
80103227:	83 c4 04             	add    $0x4,%esp
8010322a:	25 80 00 00 00       	and    $0x80,%eax
8010322f:	85 c0                	test   %eax,%eax
80103231:	75 27                	jne    8010325a <cmostime+0x6a>
        continue;
    fill_rtcdate(&t2);
80103233:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103236:	50                   	push   %eax
80103237:	e8 4f ff ff ff       	call   8010318b <fill_rtcdate>
8010323c:	83 c4 04             	add    $0x4,%esp
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010323f:	83 ec 04             	sub    $0x4,%esp
80103242:	6a 18                	push   $0x18
80103244:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103247:	50                   	push   %eax
80103248:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010324b:	50                   	push   %eax
8010324c:	e8 43 21 00 00       	call   80105394 <memcmp>
80103251:	83 c4 10             	add    $0x10,%esp
80103254:	85 c0                	test   %eax,%eax
80103256:	74 05                	je     8010325d <cmostime+0x6d>
80103258:	eb ba                	jmp    80103214 <cmostime+0x24>
        continue;
8010325a:	90                   	nop
    fill_rtcdate(&t1);
8010325b:	eb b7                	jmp    80103214 <cmostime+0x24>
      break;
8010325d:	90                   	nop
  }

  // convert
  if (bcd) {
8010325e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103262:	0f 84 b4 00 00 00    	je     8010331c <cmostime+0x12c>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80103268:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010326b:	c1 e8 04             	shr    $0x4,%eax
8010326e:	89 c2                	mov    %eax,%edx
80103270:	89 d0                	mov    %edx,%eax
80103272:	c1 e0 02             	shl    $0x2,%eax
80103275:	01 d0                	add    %edx,%eax
80103277:	01 c0                	add    %eax,%eax
80103279:	89 c2                	mov    %eax,%edx
8010327b:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010327e:	83 e0 0f             	and    $0xf,%eax
80103281:	01 d0                	add    %edx,%eax
80103283:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103286:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103289:	c1 e8 04             	shr    $0x4,%eax
8010328c:	89 c2                	mov    %eax,%edx
8010328e:	89 d0                	mov    %edx,%eax
80103290:	c1 e0 02             	shl    $0x2,%eax
80103293:	01 d0                	add    %edx,%eax
80103295:	01 c0                	add    %eax,%eax
80103297:	89 c2                	mov    %eax,%edx
80103299:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010329c:	83 e0 0f             	and    $0xf,%eax
8010329f:	01 d0                	add    %edx,%eax
801032a1:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
801032a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032a7:	c1 e8 04             	shr    $0x4,%eax
801032aa:	89 c2                	mov    %eax,%edx
801032ac:	89 d0                	mov    %edx,%eax
801032ae:	c1 e0 02             	shl    $0x2,%eax
801032b1:	01 d0                	add    %edx,%eax
801032b3:	01 c0                	add    %eax,%eax
801032b5:	89 c2                	mov    %eax,%edx
801032b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801032ba:	83 e0 0f             	and    $0xf,%eax
801032bd:	01 d0                	add    %edx,%eax
801032bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801032c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032c5:	c1 e8 04             	shr    $0x4,%eax
801032c8:	89 c2                	mov    %eax,%edx
801032ca:	89 d0                	mov    %edx,%eax
801032cc:	c1 e0 02             	shl    $0x2,%eax
801032cf:	01 d0                	add    %edx,%eax
801032d1:	01 c0                	add    %eax,%eax
801032d3:	89 c2                	mov    %eax,%edx
801032d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801032d8:	83 e0 0f             	and    $0xf,%eax
801032db:	01 d0                	add    %edx,%eax
801032dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801032e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032e3:	c1 e8 04             	shr    $0x4,%eax
801032e6:	89 c2                	mov    %eax,%edx
801032e8:	89 d0                	mov    %edx,%eax
801032ea:	c1 e0 02             	shl    $0x2,%eax
801032ed:	01 d0                	add    %edx,%eax
801032ef:	01 c0                	add    %eax,%eax
801032f1:	89 c2                	mov    %eax,%edx
801032f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801032f6:	83 e0 0f             	and    $0xf,%eax
801032f9:	01 d0                	add    %edx,%eax
801032fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801032fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103301:	c1 e8 04             	shr    $0x4,%eax
80103304:	89 c2                	mov    %eax,%edx
80103306:	89 d0                	mov    %edx,%eax
80103308:	c1 e0 02             	shl    $0x2,%eax
8010330b:	01 d0                	add    %edx,%eax
8010330d:	01 c0                	add    %eax,%eax
8010330f:	89 c2                	mov    %eax,%edx
80103311:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103314:	83 e0 0f             	and    $0xf,%eax
80103317:	01 d0                	add    %edx,%eax
80103319:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
8010331c:	8b 45 08             	mov    0x8(%ebp),%eax
8010331f:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103322:	89 10                	mov    %edx,(%eax)
80103324:	8b 55 dc             	mov    -0x24(%ebp),%edx
80103327:	89 50 04             	mov    %edx,0x4(%eax)
8010332a:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010332d:	89 50 08             	mov    %edx,0x8(%eax)
80103330:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103333:	89 50 0c             	mov    %edx,0xc(%eax)
80103336:	8b 55 e8             	mov    -0x18(%ebp),%edx
80103339:	89 50 10             	mov    %edx,0x10(%eax)
8010333c:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010333f:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103342:	8b 45 08             	mov    0x8(%ebp),%eax
80103345:	8b 40 14             	mov    0x14(%eax),%eax
80103348:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
8010334e:	8b 45 08             	mov    0x8(%ebp),%eax
80103351:	89 50 14             	mov    %edx,0x14(%eax)
}
80103354:	90                   	nop
80103355:	c9                   	leave  
80103356:	c3                   	ret    

80103357 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80103357:	55                   	push   %ebp
80103358:	89 e5                	mov    %esp,%ebp
8010335a:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
8010335d:	83 ec 08             	sub    $0x8,%esp
80103360:	68 88 8a 10 80       	push   $0x80108a88
80103365:	68 80 12 11 80       	push   $0x80111280
8010336a:	e8 39 1d 00 00       	call   801050a8 <initlock>
8010336f:	83 c4 10             	add    $0x10,%esp
  readsb(dev, &sb);
80103372:	83 ec 08             	sub    $0x8,%esp
80103375:	8d 45 dc             	lea    -0x24(%ebp),%eax
80103378:	50                   	push   %eax
80103379:	ff 75 08             	push   0x8(%ebp)
8010337c:	e8 30 e0 ff ff       	call   801013b1 <readsb>
80103381:	83 c4 10             	add    $0x10,%esp
  log.start = sb.logstart;
80103384:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103387:	a3 b4 12 11 80       	mov    %eax,0x801112b4
  log.size = sb.nlog;
8010338c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010338f:	a3 b8 12 11 80       	mov    %eax,0x801112b8
  log.dev = dev;
80103394:	8b 45 08             	mov    0x8(%ebp),%eax
80103397:	a3 c4 12 11 80       	mov    %eax,0x801112c4
  recover_from_log();
8010339c:	e8 b3 01 00 00       	call   80103554 <recover_from_log>
}
801033a1:	90                   	nop
801033a2:	c9                   	leave  
801033a3:	c3                   	ret    

801033a4 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
801033a4:	55                   	push   %ebp
801033a5:	89 e5                	mov    %esp,%ebp
801033a7:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801033aa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033b1:	e9 95 00 00 00       	jmp    8010344b <install_trans+0xa7>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801033b6:	8b 15 b4 12 11 80    	mov    0x801112b4,%edx
801033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033bf:	01 d0                	add    %edx,%eax
801033c1:	83 c0 01             	add    $0x1,%eax
801033c4:	89 c2                	mov    %eax,%edx
801033c6:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801033cb:	83 ec 08             	sub    $0x8,%esp
801033ce:	52                   	push   %edx
801033cf:	50                   	push   %eax
801033d0:	e8 e2 cd ff ff       	call   801001b7 <bread>
801033d5:	83 c4 10             	add    $0x10,%esp
801033d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801033db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033de:	83 c0 10             	add    $0x10,%eax
801033e1:	8b 04 85 8c 12 11 80 	mov    -0x7feeed74(,%eax,4),%eax
801033e8:	89 c2                	mov    %eax,%edx
801033ea:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801033ef:	83 ec 08             	sub    $0x8,%esp
801033f2:	52                   	push   %edx
801033f3:	50                   	push   %eax
801033f4:	e8 be cd ff ff       	call   801001b7 <bread>
801033f9:	83 c4 10             	add    $0x10,%esp
801033fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801033ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103402:	8d 50 18             	lea    0x18(%eax),%edx
80103405:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103408:	83 c0 18             	add    $0x18,%eax
8010340b:	83 ec 04             	sub    $0x4,%esp
8010340e:	68 00 02 00 00       	push   $0x200
80103413:	52                   	push   %edx
80103414:	50                   	push   %eax
80103415:	e8 d2 1f 00 00       	call   801053ec <memmove>
8010341a:	83 c4 10             	add    $0x10,%esp
    bwrite(dbuf);  // write dst to disk
8010341d:	83 ec 0c             	sub    $0xc,%esp
80103420:	ff 75 ec             	push   -0x14(%ebp)
80103423:	e8 c8 cd ff ff       	call   801001f0 <bwrite>
80103428:	83 c4 10             	add    $0x10,%esp
    brelse(lbuf); 
8010342b:	83 ec 0c             	sub    $0xc,%esp
8010342e:	ff 75 f0             	push   -0x10(%ebp)
80103431:	e8 f9 cd ff ff       	call   8010022f <brelse>
80103436:	83 c4 10             	add    $0x10,%esp
    brelse(dbuf);
80103439:	83 ec 0c             	sub    $0xc,%esp
8010343c:	ff 75 ec             	push   -0x14(%ebp)
8010343f:	e8 eb cd ff ff       	call   8010022f <brelse>
80103444:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103447:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010344b:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80103450:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103453:	0f 8c 5d ff ff ff    	jl     801033b6 <install_trans+0x12>
  }
}
80103459:	90                   	nop
8010345a:	90                   	nop
8010345b:	c9                   	leave  
8010345c:	c3                   	ret    

8010345d <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010345d:	55                   	push   %ebp
8010345e:	89 e5                	mov    %esp,%ebp
80103460:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
80103463:	a1 b4 12 11 80       	mov    0x801112b4,%eax
80103468:	89 c2                	mov    %eax,%edx
8010346a:	a1 c4 12 11 80       	mov    0x801112c4,%eax
8010346f:	83 ec 08             	sub    $0x8,%esp
80103472:	52                   	push   %edx
80103473:	50                   	push   %eax
80103474:	e8 3e cd ff ff       	call   801001b7 <bread>
80103479:	83 c4 10             	add    $0x10,%esp
8010347c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
8010347f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103482:	83 c0 18             	add    $0x18,%eax
80103485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103488:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010348b:	8b 00                	mov    (%eax),%eax
8010348d:	a3 c8 12 11 80       	mov    %eax,0x801112c8
  for (i = 0; i < log.lh.n; i++) {
80103492:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103499:	eb 1b                	jmp    801034b6 <read_head+0x59>
    log.lh.block[i] = lh->block[i];
8010349b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010349e:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034a1:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
801034a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801034a8:	83 c2 10             	add    $0x10,%edx
801034ab:	89 04 95 8c 12 11 80 	mov    %eax,-0x7feeed74(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
801034b2:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801034b6:	a1 c8 12 11 80       	mov    0x801112c8,%eax
801034bb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
801034be:	7c db                	jl     8010349b <read_head+0x3e>
  }
  brelse(buf);
801034c0:	83 ec 0c             	sub    $0xc,%esp
801034c3:	ff 75 f0             	push   -0x10(%ebp)
801034c6:	e8 64 cd ff ff       	call   8010022f <brelse>
801034cb:	83 c4 10             	add    $0x10,%esp
}
801034ce:	90                   	nop
801034cf:	c9                   	leave  
801034d0:	c3                   	ret    

801034d1 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801034d1:	55                   	push   %ebp
801034d2:	89 e5                	mov    %esp,%ebp
801034d4:	83 ec 18             	sub    $0x18,%esp
  struct buf *buf = bread(log.dev, log.start);
801034d7:	a1 b4 12 11 80       	mov    0x801112b4,%eax
801034dc:	89 c2                	mov    %eax,%edx
801034de:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801034e3:	83 ec 08             	sub    $0x8,%esp
801034e6:	52                   	push   %edx
801034e7:	50                   	push   %eax
801034e8:	e8 ca cc ff ff       	call   801001b7 <bread>
801034ed:	83 c4 10             	add    $0x10,%esp
801034f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801034f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801034f6:	83 c0 18             	add    $0x18,%eax
801034f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801034fc:	8b 15 c8 12 11 80    	mov    0x801112c8,%edx
80103502:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103505:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
80103507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010350e:	eb 1b                	jmp    8010352b <write_head+0x5a>
    hb->block[i] = log.lh.block[i];
80103510:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103513:	83 c0 10             	add    $0x10,%eax
80103516:	8b 0c 85 8c 12 11 80 	mov    -0x7feeed74(,%eax,4),%ecx
8010351d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103520:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103523:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80103527:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010352b:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80103530:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103533:	7c db                	jl     80103510 <write_head+0x3f>
  }
  bwrite(buf);
80103535:	83 ec 0c             	sub    $0xc,%esp
80103538:	ff 75 f0             	push   -0x10(%ebp)
8010353b:	e8 b0 cc ff ff       	call   801001f0 <bwrite>
80103540:	83 c4 10             	add    $0x10,%esp
  brelse(buf);
80103543:	83 ec 0c             	sub    $0xc,%esp
80103546:	ff 75 f0             	push   -0x10(%ebp)
80103549:	e8 e1 cc ff ff       	call   8010022f <brelse>
8010354e:	83 c4 10             	add    $0x10,%esp
}
80103551:	90                   	nop
80103552:	c9                   	leave  
80103553:	c3                   	ret    

80103554 <recover_from_log>:

static void
recover_from_log(void)
{
80103554:	55                   	push   %ebp
80103555:	89 e5                	mov    %esp,%ebp
80103557:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010355a:	e8 fe fe ff ff       	call   8010345d <read_head>
  install_trans(); // if committed, copy from log to disk
8010355f:	e8 40 fe ff ff       	call   801033a4 <install_trans>
  log.lh.n = 0;
80103564:	c7 05 c8 12 11 80 00 	movl   $0x0,0x801112c8
8010356b:	00 00 00 
  write_head(); // clear the log
8010356e:	e8 5e ff ff ff       	call   801034d1 <write_head>
}
80103573:	90                   	nop
80103574:	c9                   	leave  
80103575:	c3                   	ret    

80103576 <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
80103576:	55                   	push   %ebp
80103577:	89 e5                	mov    %esp,%ebp
80103579:	83 ec 08             	sub    $0x8,%esp
  acquire(&log.lock);
8010357c:	83 ec 0c             	sub    $0xc,%esp
8010357f:	68 80 12 11 80       	push   $0x80111280
80103584:	e8 41 1b 00 00       	call   801050ca <acquire>
80103589:	83 c4 10             	add    $0x10,%esp
  while(1){
    if(log.committing){
8010358c:	a1 c0 12 11 80       	mov    0x801112c0,%eax
80103591:	85 c0                	test   %eax,%eax
80103593:	74 17                	je     801035ac <begin_op+0x36>
      sleep(&log, &log.lock);
80103595:	83 ec 08             	sub    $0x8,%esp
80103598:	68 80 12 11 80       	push   $0x80111280
8010359d:	68 80 12 11 80       	push   $0x80111280
801035a2:	e8 28 18 00 00       	call   80104dcf <sleep>
801035a7:	83 c4 10             	add    $0x10,%esp
801035aa:	eb e0                	jmp    8010358c <begin_op+0x16>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
801035ac:	8b 0d c8 12 11 80    	mov    0x801112c8,%ecx
801035b2:	a1 bc 12 11 80       	mov    0x801112bc,%eax
801035b7:	8d 50 01             	lea    0x1(%eax),%edx
801035ba:	89 d0                	mov    %edx,%eax
801035bc:	c1 e0 02             	shl    $0x2,%eax
801035bf:	01 d0                	add    %edx,%eax
801035c1:	01 c0                	add    %eax,%eax
801035c3:	01 c8                	add    %ecx,%eax
801035c5:	83 f8 1e             	cmp    $0x1e,%eax
801035c8:	7e 17                	jle    801035e1 <begin_op+0x6b>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
801035ca:	83 ec 08             	sub    $0x8,%esp
801035cd:	68 80 12 11 80       	push   $0x80111280
801035d2:	68 80 12 11 80       	push   $0x80111280
801035d7:	e8 f3 17 00 00       	call   80104dcf <sleep>
801035dc:	83 c4 10             	add    $0x10,%esp
801035df:	eb ab                	jmp    8010358c <begin_op+0x16>
    } else {
      log.outstanding += 1;
801035e1:	a1 bc 12 11 80       	mov    0x801112bc,%eax
801035e6:	83 c0 01             	add    $0x1,%eax
801035e9:	a3 bc 12 11 80       	mov    %eax,0x801112bc
      release(&log.lock);
801035ee:	83 ec 0c             	sub    $0xc,%esp
801035f1:	68 80 12 11 80       	push   $0x80111280
801035f6:	e8 36 1b 00 00       	call   80105131 <release>
801035fb:	83 c4 10             	add    $0x10,%esp
      break;
801035fe:	90                   	nop
    }
  }
}
801035ff:	90                   	nop
80103600:	c9                   	leave  
80103601:	c3                   	ret    

80103602 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80103602:	55                   	push   %ebp
80103603:	89 e5                	mov    %esp,%ebp
80103605:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;
80103608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
8010360f:	83 ec 0c             	sub    $0xc,%esp
80103612:	68 80 12 11 80       	push   $0x80111280
80103617:	e8 ae 1a 00 00       	call   801050ca <acquire>
8010361c:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
8010361f:	a1 bc 12 11 80       	mov    0x801112bc,%eax
80103624:	83 e8 01             	sub    $0x1,%eax
80103627:	a3 bc 12 11 80       	mov    %eax,0x801112bc
  if(log.committing)
8010362c:	a1 c0 12 11 80       	mov    0x801112c0,%eax
80103631:	85 c0                	test   %eax,%eax
80103633:	74 0d                	je     80103642 <end_op+0x40>
    panic("log.committing");
80103635:	83 ec 0c             	sub    $0xc,%esp
80103638:	68 8c 8a 10 80       	push   $0x80108a8c
8010363d:	e8 39 cf ff ff       	call   8010057b <panic>
  if(log.outstanding == 0){
80103642:	a1 bc 12 11 80       	mov    0x801112bc,%eax
80103647:	85 c0                	test   %eax,%eax
80103649:	75 13                	jne    8010365e <end_op+0x5c>
    do_commit = 1;
8010364b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103652:	c7 05 c0 12 11 80 01 	movl   $0x1,0x801112c0
80103659:	00 00 00 
8010365c:	eb 10                	jmp    8010366e <end_op+0x6c>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
8010365e:	83 ec 0c             	sub    $0xc,%esp
80103661:	68 80 12 11 80       	push   $0x80111280
80103666:	e8 50 18 00 00       	call   80104ebb <wakeup>
8010366b:	83 c4 10             	add    $0x10,%esp
  }
  release(&log.lock);
8010366e:	83 ec 0c             	sub    $0xc,%esp
80103671:	68 80 12 11 80       	push   $0x80111280
80103676:	e8 b6 1a 00 00       	call   80105131 <release>
8010367b:	83 c4 10             	add    $0x10,%esp

  if(do_commit){
8010367e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103682:	74 3f                	je     801036c3 <end_op+0xc1>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103684:	e8 f6 00 00 00       	call   8010377f <commit>
    acquire(&log.lock);
80103689:	83 ec 0c             	sub    $0xc,%esp
8010368c:	68 80 12 11 80       	push   $0x80111280
80103691:	e8 34 1a 00 00       	call   801050ca <acquire>
80103696:	83 c4 10             	add    $0x10,%esp
    log.committing = 0;
80103699:	c7 05 c0 12 11 80 00 	movl   $0x0,0x801112c0
801036a0:	00 00 00 
    wakeup(&log);
801036a3:	83 ec 0c             	sub    $0xc,%esp
801036a6:	68 80 12 11 80       	push   $0x80111280
801036ab:	e8 0b 18 00 00       	call   80104ebb <wakeup>
801036b0:	83 c4 10             	add    $0x10,%esp
    release(&log.lock);
801036b3:	83 ec 0c             	sub    $0xc,%esp
801036b6:	68 80 12 11 80       	push   $0x80111280
801036bb:	e8 71 1a 00 00       	call   80105131 <release>
801036c0:	83 c4 10             	add    $0x10,%esp
  }
}
801036c3:	90                   	nop
801036c4:	c9                   	leave  
801036c5:	c3                   	ret    

801036c6 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
801036c6:	55                   	push   %ebp
801036c7:	89 e5                	mov    %esp,%ebp
801036c9:	83 ec 18             	sub    $0x18,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801036cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036d3:	e9 95 00 00 00       	jmp    8010376d <write_log+0xa7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
801036d8:	8b 15 b4 12 11 80    	mov    0x801112b4,%edx
801036de:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036e1:	01 d0                	add    %edx,%eax
801036e3:	83 c0 01             	add    $0x1,%eax
801036e6:	89 c2                	mov    %eax,%edx
801036e8:	a1 c4 12 11 80       	mov    0x801112c4,%eax
801036ed:	83 ec 08             	sub    $0x8,%esp
801036f0:	52                   	push   %edx
801036f1:	50                   	push   %eax
801036f2:	e8 c0 ca ff ff       	call   801001b7 <bread>
801036f7:	83 c4 10             	add    $0x10,%esp
801036fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
801036fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103700:	83 c0 10             	add    $0x10,%eax
80103703:	8b 04 85 8c 12 11 80 	mov    -0x7feeed74(,%eax,4),%eax
8010370a:	89 c2                	mov    %eax,%edx
8010370c:	a1 c4 12 11 80       	mov    0x801112c4,%eax
80103711:	83 ec 08             	sub    $0x8,%esp
80103714:	52                   	push   %edx
80103715:	50                   	push   %eax
80103716:	e8 9c ca ff ff       	call   801001b7 <bread>
8010371b:	83 c4 10             	add    $0x10,%esp
8010371e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
80103721:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103724:	8d 50 18             	lea    0x18(%eax),%edx
80103727:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010372a:	83 c0 18             	add    $0x18,%eax
8010372d:	83 ec 04             	sub    $0x4,%esp
80103730:	68 00 02 00 00       	push   $0x200
80103735:	52                   	push   %edx
80103736:	50                   	push   %eax
80103737:	e8 b0 1c 00 00       	call   801053ec <memmove>
8010373c:	83 c4 10             	add    $0x10,%esp
    bwrite(to);  // write the log
8010373f:	83 ec 0c             	sub    $0xc,%esp
80103742:	ff 75 f0             	push   -0x10(%ebp)
80103745:	e8 a6 ca ff ff       	call   801001f0 <bwrite>
8010374a:	83 c4 10             	add    $0x10,%esp
    brelse(from); 
8010374d:	83 ec 0c             	sub    $0xc,%esp
80103750:	ff 75 ec             	push   -0x14(%ebp)
80103753:	e8 d7 ca ff ff       	call   8010022f <brelse>
80103758:	83 c4 10             	add    $0x10,%esp
    brelse(to);
8010375b:	83 ec 0c             	sub    $0xc,%esp
8010375e:	ff 75 f0             	push   -0x10(%ebp)
80103761:	e8 c9 ca ff ff       	call   8010022f <brelse>
80103766:	83 c4 10             	add    $0x10,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80103769:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010376d:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80103772:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103775:	0f 8c 5d ff ff ff    	jl     801036d8 <write_log+0x12>
  }
}
8010377b:	90                   	nop
8010377c:	90                   	nop
8010377d:	c9                   	leave  
8010377e:	c3                   	ret    

8010377f <commit>:

static void
commit()
{
8010377f:	55                   	push   %ebp
80103780:	89 e5                	mov    %esp,%ebp
80103782:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
80103785:	a1 c8 12 11 80       	mov    0x801112c8,%eax
8010378a:	85 c0                	test   %eax,%eax
8010378c:	7e 1e                	jle    801037ac <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
8010378e:	e8 33 ff ff ff       	call   801036c6 <write_log>
    write_head();    // Write header to disk -- the real commit
80103793:	e8 39 fd ff ff       	call   801034d1 <write_head>
    install_trans(); // Now install writes to home locations
80103798:	e8 07 fc ff ff       	call   801033a4 <install_trans>
    log.lh.n = 0; 
8010379d:	c7 05 c8 12 11 80 00 	movl   $0x0,0x801112c8
801037a4:	00 00 00 
    write_head();    // Erase the transaction from the log
801037a7:	e8 25 fd ff ff       	call   801034d1 <write_head>
  }
}
801037ac:	90                   	nop
801037ad:	c9                   	leave  
801037ae:	c3                   	ret    

801037af <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
801037af:	55                   	push   %ebp
801037b0:	89 e5                	mov    %esp,%ebp
801037b2:	83 ec 18             	sub    $0x18,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
801037b5:	a1 c8 12 11 80       	mov    0x801112c8,%eax
801037ba:	83 f8 1d             	cmp    $0x1d,%eax
801037bd:	7f 12                	jg     801037d1 <log_write+0x22>
801037bf:	a1 c8 12 11 80       	mov    0x801112c8,%eax
801037c4:	8b 15 b8 12 11 80    	mov    0x801112b8,%edx
801037ca:	83 ea 01             	sub    $0x1,%edx
801037cd:	39 d0                	cmp    %edx,%eax
801037cf:	7c 0d                	jl     801037de <log_write+0x2f>
    panic("too big a transaction");
801037d1:	83 ec 0c             	sub    $0xc,%esp
801037d4:	68 9b 8a 10 80       	push   $0x80108a9b
801037d9:	e8 9d cd ff ff       	call   8010057b <panic>
  if (log.outstanding < 1)
801037de:	a1 bc 12 11 80       	mov    0x801112bc,%eax
801037e3:	85 c0                	test   %eax,%eax
801037e5:	7f 0d                	jg     801037f4 <log_write+0x45>
    panic("log_write outside of trans");
801037e7:	83 ec 0c             	sub    $0xc,%esp
801037ea:	68 b1 8a 10 80       	push   $0x80108ab1
801037ef:	e8 87 cd ff ff       	call   8010057b <panic>

  acquire(&log.lock);
801037f4:	83 ec 0c             	sub    $0xc,%esp
801037f7:	68 80 12 11 80       	push   $0x80111280
801037fc:	e8 c9 18 00 00       	call   801050ca <acquire>
80103801:	83 c4 10             	add    $0x10,%esp
  for (i = 0; i < log.lh.n; i++) {
80103804:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010380b:	eb 1d                	jmp    8010382a <log_write+0x7b>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
8010380d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103810:	83 c0 10             	add    $0x10,%eax
80103813:	8b 04 85 8c 12 11 80 	mov    -0x7feeed74(,%eax,4),%eax
8010381a:	89 c2                	mov    %eax,%edx
8010381c:	8b 45 08             	mov    0x8(%ebp),%eax
8010381f:	8b 40 08             	mov    0x8(%eax),%eax
80103822:	39 c2                	cmp    %eax,%edx
80103824:	74 10                	je     80103836 <log_write+0x87>
  for (i = 0; i < log.lh.n; i++) {
80103826:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010382a:	a1 c8 12 11 80       	mov    0x801112c8,%eax
8010382f:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103832:	7c d9                	jl     8010380d <log_write+0x5e>
80103834:	eb 01                	jmp    80103837 <log_write+0x88>
      break;
80103836:	90                   	nop
  }
  log.lh.block[i] = b->blockno;
80103837:	8b 45 08             	mov    0x8(%ebp),%eax
8010383a:	8b 40 08             	mov    0x8(%eax),%eax
8010383d:	89 c2                	mov    %eax,%edx
8010383f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103842:	83 c0 10             	add    $0x10,%eax
80103845:	89 14 85 8c 12 11 80 	mov    %edx,-0x7feeed74(,%eax,4)
  if (i == log.lh.n)
8010384c:	a1 c8 12 11 80       	mov    0x801112c8,%eax
80103851:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103854:	75 0d                	jne    80103863 <log_write+0xb4>
    log.lh.n++;
80103856:	a1 c8 12 11 80       	mov    0x801112c8,%eax
8010385b:	83 c0 01             	add    $0x1,%eax
8010385e:	a3 c8 12 11 80       	mov    %eax,0x801112c8
  b->flags |= B_DIRTY; // prevent eviction
80103863:	8b 45 08             	mov    0x8(%ebp),%eax
80103866:	8b 00                	mov    (%eax),%eax
80103868:	83 c8 04             	or     $0x4,%eax
8010386b:	89 c2                	mov    %eax,%edx
8010386d:	8b 45 08             	mov    0x8(%ebp),%eax
80103870:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
80103872:	83 ec 0c             	sub    $0xc,%esp
80103875:	68 80 12 11 80       	push   $0x80111280
8010387a:	e8 b2 18 00 00       	call   80105131 <release>
8010387f:	83 c4 10             	add    $0x10,%esp
}
80103882:	90                   	nop
80103883:	c9                   	leave  
80103884:	c3                   	ret    

80103885 <v2p>:
80103885:	55                   	push   %ebp
80103886:	89 e5                	mov    %esp,%ebp
80103888:	8b 45 08             	mov    0x8(%ebp),%eax
8010388b:	05 00 00 00 80       	add    $0x80000000,%eax
80103890:	5d                   	pop    %ebp
80103891:	c3                   	ret    

80103892 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80103892:	55                   	push   %ebp
80103893:	89 e5                	mov    %esp,%ebp
80103895:	8b 45 08             	mov    0x8(%ebp),%eax
80103898:	05 00 00 00 80       	add    $0x80000000,%eax
8010389d:	5d                   	pop    %ebp
8010389e:	c3                   	ret    

8010389f <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
8010389f:	55                   	push   %ebp
801038a0:	89 e5                	mov    %esp,%ebp
801038a2:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801038a5:	8b 55 08             	mov    0x8(%ebp),%edx
801038a8:	8b 45 0c             	mov    0xc(%ebp),%eax
801038ab:	8b 4d 08             	mov    0x8(%ebp),%ecx
801038ae:	f0 87 02             	lock xchg %eax,(%edx)
801038b1:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801038b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801038b7:	c9                   	leave  
801038b8:	c3                   	ret    

801038b9 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
801038b9:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801038bd:	83 e4 f0             	and    $0xfffffff0,%esp
801038c0:	ff 71 fc             	push   -0x4(%ecx)
801038c3:	55                   	push   %ebp
801038c4:	89 e5                	mov    %esp,%ebp
801038c6:	51                   	push   %ecx
801038c7:	83 ec 04             	sub    $0x4,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801038ca:	83 ec 08             	sub    $0x8,%esp
801038cd:	68 00 00 40 80       	push   $0x80400000
801038d2:	68 60 51 11 80       	push   $0x80115160
801038d7:	e8 65 f2 ff ff       	call   80102b41 <kinit1>
801038dc:	83 c4 10             	add    $0x10,%esp
  kvmalloc();      // kernel page table
801038df:	e8 b9 47 00 00       	call   8010809d <kvmalloc>
  mpinit();        // collect info about this machine
801038e4:	e8 3a 04 00 00       	call   80103d23 <mpinit>
  lapicinit();
801038e9:	e8 f0 f5 ff ff       	call   80102ede <lapicinit>
  seginit();       // set up segments
801038ee:	e8 53 41 00 00       	call   80107a46 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
801038f3:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801038f9:	0f b6 00             	movzbl (%eax),%eax
801038fc:	0f b6 c0             	movzbl %al,%eax
801038ff:	83 ec 08             	sub    $0x8,%esp
80103902:	50                   	push   %eax
80103903:	68 cc 8a 10 80       	push   $0x80108acc
80103908:	e8 b9 ca ff ff       	call   801003c6 <cprintf>
8010390d:	83 c4 10             	add    $0x10,%esp
  picinit();       // interrupt controller
80103910:	e8 8a 06 00 00       	call   80103f9f <picinit>
  ioapicinit();    // another interrupt controller
80103915:	e8 1c f1 ff ff       	call   80102a36 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
8010391a:	e8 27 d2 ff ff       	call   80100b46 <consoleinit>
  uartinit();      // serial port
8010391f:	e8 7e 34 00 00       	call   80106da2 <uartinit>
  pinit();         // process table
80103924:	e8 7a 0b 00 00       	call   801044a3 <pinit>
  tvinit();        // trap vectors
80103929:	e8 fe 2e 00 00       	call   8010682c <tvinit>
  binit();         // buffer cache
8010392e:	e8 01 c7 ff ff       	call   80100034 <binit>
  fileinit();      // file table
80103933:	e8 6a d6 ff ff       	call   80100fa2 <fileinit>
  ideinit();       // disk
80103938:	e8 01 ed ff ff       	call   8010263e <ideinit>
  if(!ismp)
8010393d:	a1 40 19 11 80       	mov    0x80111940,%eax
80103942:	85 c0                	test   %eax,%eax
80103944:	75 05                	jne    8010394b <main+0x92>
    timerinit();   // uniprocessor timer
80103946:	e8 3e 2e 00 00       	call   80106789 <timerinit>
  startothers();   // start other processors
8010394b:	e8 7f 00 00 00       	call   801039cf <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103950:	83 ec 08             	sub    $0x8,%esp
80103953:	68 00 00 00 8e       	push   $0x8e000000
80103958:	68 00 00 40 80       	push   $0x80400000
8010395d:	e8 18 f2 ff ff       	call   80102b7a <kinit2>
80103962:	83 c4 10             	add    $0x10,%esp
  userinit();      // first user process
80103965:	e8 98 0c 00 00       	call   80104602 <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
8010396a:	e8 1a 00 00 00       	call   80103989 <mpmain>

8010396f <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
8010396f:	55                   	push   %ebp
80103970:	89 e5                	mov    %esp,%ebp
80103972:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103975:	e8 3b 47 00 00       	call   801080b5 <switchkvm>
  seginit();
8010397a:	e8 c7 40 00 00       	call   80107a46 <seginit>
  lapicinit();
8010397f:	e8 5a f5 ff ff       	call   80102ede <lapicinit>
  mpmain();
80103984:	e8 00 00 00 00       	call   80103989 <mpmain>

80103989 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80103989:	55                   	push   %ebp
8010398a:	89 e5                	mov    %esp,%ebp
8010398c:	83 ec 08             	sub    $0x8,%esp
  cprintf("cpu%d: starting\n", cpu->id);
8010398f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103995:	0f b6 00             	movzbl (%eax),%eax
80103998:	0f b6 c0             	movzbl %al,%eax
8010399b:	83 ec 08             	sub    $0x8,%esp
8010399e:	50                   	push   %eax
8010399f:	68 e3 8a 10 80       	push   $0x80108ae3
801039a4:	e8 1d ca ff ff       	call   801003c6 <cprintf>
801039a9:	83 c4 10             	add    $0x10,%esp
  idtinit();       // load idt register
801039ac:	e8 f1 2f 00 00       	call   801069a2 <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
801039b1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801039b7:	05 a8 00 00 00       	add    $0xa8,%eax
801039bc:	83 ec 08             	sub    $0x8,%esp
801039bf:	6a 01                	push   $0x1
801039c1:	50                   	push   %eax
801039c2:	e8 d8 fe ff ff       	call   8010389f <xchg>
801039c7:	83 c4 10             	add    $0x10,%esp
  scheduler();     // start running processes
801039ca:	e8 fa 11 00 00       	call   80104bc9 <scheduler>

801039cf <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801039cf:	55                   	push   %ebp
801039d0:	89 e5                	mov    %esp,%ebp
801039d2:	83 ec 18             	sub    $0x18,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
801039d5:	68 00 70 00 00       	push   $0x7000
801039da:	e8 b3 fe ff ff       	call   80103892 <p2v>
801039df:	83 c4 04             	add    $0x4,%esp
801039e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801039e5:	b8 8a 00 00 00       	mov    $0x8a,%eax
801039ea:	83 ec 04             	sub    $0x4,%esp
801039ed:	50                   	push   %eax
801039ee:	68 2c b5 10 80       	push   $0x8010b52c
801039f3:	ff 75 f0             	push   -0x10(%ebp)
801039f6:	e8 f1 19 00 00       	call   801053ec <memmove>
801039fb:	83 c4 10             	add    $0x10,%esp

  for(c = cpus; c < cpus+ncpu; c++){
801039fe:	c7 45 f4 60 13 11 80 	movl   $0x80111360,-0xc(%ebp)
80103a05:	e9 8e 00 00 00       	jmp    80103a98 <startothers+0xc9>
    if(c == cpus+cpunum())  // We've started already.
80103a0a:	e8 ee f5 ff ff       	call   80102ffd <cpunum>
80103a0f:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103a15:	05 60 13 11 80       	add    $0x80111360,%eax
80103a1a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103a1d:	74 71                	je     80103a90 <startothers+0xc1>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80103a1f:	e8 62 f2 ff ff       	call   80102c86 <kalloc>
80103a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
80103a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a2a:	83 e8 04             	sub    $0x4,%eax
80103a2d:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103a30:	81 c2 00 10 00 00    	add    $0x1000,%edx
80103a36:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
80103a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a3b:	83 e8 08             	sub    $0x8,%eax
80103a3e:	c7 00 6f 39 10 80    	movl   $0x8010396f,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
80103a44:	83 ec 0c             	sub    $0xc,%esp
80103a47:	68 00 a0 10 80       	push   $0x8010a000
80103a4c:	e8 34 fe ff ff       	call   80103885 <v2p>
80103a51:	83 c4 10             	add    $0x10,%esp
80103a54:	8b 55 f0             	mov    -0x10(%ebp),%edx
80103a57:	83 ea 0c             	sub    $0xc,%edx
80103a5a:	89 02                	mov    %eax,(%edx)

    lapicstartap(c->id, v2p(code));
80103a5c:	83 ec 0c             	sub    $0xc,%esp
80103a5f:	ff 75 f0             	push   -0x10(%ebp)
80103a62:	e8 1e fe ff ff       	call   80103885 <v2p>
80103a67:	83 c4 10             	add    $0x10,%esp
80103a6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103a6d:	0f b6 12             	movzbl (%edx),%edx
80103a70:	0f b6 d2             	movzbl %dl,%edx
80103a73:	83 ec 08             	sub    $0x8,%esp
80103a76:	50                   	push   %eax
80103a77:	52                   	push   %edx
80103a78:	e8 fa f5 ff ff       	call   80103077 <lapicstartap>
80103a7d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103a80:	90                   	nop
80103a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a84:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80103a8a:	85 c0                	test   %eax,%eax
80103a8c:	74 f3                	je     80103a81 <startothers+0xb2>
80103a8e:	eb 01                	jmp    80103a91 <startothers+0xc2>
      continue;
80103a90:	90                   	nop
  for(c = cpus; c < cpus+ncpu; c++){
80103a91:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103a98:	a1 44 19 11 80       	mov    0x80111944,%eax
80103a9d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103aa3:	05 60 13 11 80       	add    $0x80111360,%eax
80103aa8:	39 45 f4             	cmp    %eax,-0xc(%ebp)
80103aab:	0f 82 59 ff ff ff    	jb     80103a0a <startothers+0x3b>
      ;
  }
}
80103ab1:	90                   	nop
80103ab2:	90                   	nop
80103ab3:	c9                   	leave  
80103ab4:	c3                   	ret    

80103ab5 <p2v>:
80103ab5:	55                   	push   %ebp
80103ab6:	89 e5                	mov    %esp,%ebp
80103ab8:	8b 45 08             	mov    0x8(%ebp),%eax
80103abb:	05 00 00 00 80       	add    $0x80000000,%eax
80103ac0:	5d                   	pop    %ebp
80103ac1:	c3                   	ret    

80103ac2 <inb>:
{
80103ac2:	55                   	push   %ebp
80103ac3:	89 e5                	mov    %esp,%ebp
80103ac5:	83 ec 14             	sub    $0x14,%esp
80103ac8:	8b 45 08             	mov    0x8(%ebp),%eax
80103acb:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103acf:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103ad3:	89 c2                	mov    %eax,%edx
80103ad5:	ec                   	in     (%dx),%al
80103ad6:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103ad9:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80103add:	c9                   	leave  
80103ade:	c3                   	ret    

80103adf <outb>:
{
80103adf:	55                   	push   %ebp
80103ae0:	89 e5                	mov    %esp,%ebp
80103ae2:	83 ec 08             	sub    $0x8,%esp
80103ae5:	8b 45 08             	mov    0x8(%ebp),%eax
80103ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
80103aeb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103aef:	89 d0                	mov    %edx,%eax
80103af1:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103af4:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103af8:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103afc:	ee                   	out    %al,(%dx)
}
80103afd:	90                   	nop
80103afe:	c9                   	leave  
80103aff:	c3                   	ret    

80103b00 <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
80103b00:	55                   	push   %ebp
80103b01:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
80103b03:	a1 4c 19 11 80       	mov    0x8011194c,%eax
80103b08:	2d 60 13 11 80       	sub    $0x80111360,%eax
80103b0d:	c1 f8 02             	sar    $0x2,%eax
80103b10:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
80103b16:	5d                   	pop    %ebp
80103b17:	c3                   	ret    

80103b18 <sum>:

static uchar
sum(uchar *addr, int len)
{
80103b18:	55                   	push   %ebp
80103b19:	89 e5                	mov    %esp,%ebp
80103b1b:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
80103b1e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80103b2c:	eb 15                	jmp    80103b43 <sum+0x2b>
    sum += addr[i];
80103b2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80103b31:	8b 45 08             	mov    0x8(%ebp),%eax
80103b34:	01 d0                	add    %edx,%eax
80103b36:	0f b6 00             	movzbl (%eax),%eax
80103b39:	0f b6 c0             	movzbl %al,%eax
80103b3c:	01 45 f8             	add    %eax,-0x8(%ebp)
  for(i=0; i<len; i++)
80103b3f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103b43:	8b 45 fc             	mov    -0x4(%ebp),%eax
80103b46:	3b 45 0c             	cmp    0xc(%ebp),%eax
80103b49:	7c e3                	jl     80103b2e <sum+0x16>
  return sum;
80103b4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80103b4e:	c9                   	leave  
80103b4f:	c3                   	ret    

80103b50 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103b50:	55                   	push   %ebp
80103b51:	89 e5                	mov    %esp,%ebp
80103b53:	83 ec 18             	sub    $0x18,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
80103b56:	ff 75 08             	push   0x8(%ebp)
80103b59:	e8 57 ff ff ff       	call   80103ab5 <p2v>
80103b5e:	83 c4 04             	add    $0x4,%esp
80103b61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
80103b64:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b67:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b6a:	01 d0                	add    %edx,%eax
80103b6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b72:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b75:	eb 36                	jmp    80103bad <mpsearch1+0x5d>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103b77:	83 ec 04             	sub    $0x4,%esp
80103b7a:	6a 04                	push   $0x4
80103b7c:	68 f4 8a 10 80       	push   $0x80108af4
80103b81:	ff 75 f4             	push   -0xc(%ebp)
80103b84:	e8 0b 18 00 00       	call   80105394 <memcmp>
80103b89:	83 c4 10             	add    $0x10,%esp
80103b8c:	85 c0                	test   %eax,%eax
80103b8e:	75 19                	jne    80103ba9 <mpsearch1+0x59>
80103b90:	83 ec 08             	sub    $0x8,%esp
80103b93:	6a 10                	push   $0x10
80103b95:	ff 75 f4             	push   -0xc(%ebp)
80103b98:	e8 7b ff ff ff       	call   80103b18 <sum>
80103b9d:	83 c4 10             	add    $0x10,%esp
80103ba0:	84 c0                	test   %al,%al
80103ba2:	75 05                	jne    80103ba9 <mpsearch1+0x59>
      return (struct mp*)p;
80103ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ba7:	eb 11                	jmp    80103bba <mpsearch1+0x6a>
  for(p = addr; p < e; p += sizeof(struct mp))
80103ba9:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103bad:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bb0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103bb3:	72 c2                	jb     80103b77 <mpsearch1+0x27>
  return 0;
80103bb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103bba:	c9                   	leave  
80103bbb:	c3                   	ret    

80103bbc <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103bbc:	55                   	push   %ebp
80103bbd:	89 e5                	mov    %esp,%ebp
80103bbf:	83 ec 18             	sub    $0x18,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103bc2:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103bc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bcc:	83 c0 0f             	add    $0xf,%eax
80103bcf:	0f b6 00             	movzbl (%eax),%eax
80103bd2:	0f b6 c0             	movzbl %al,%eax
80103bd5:	c1 e0 08             	shl    $0x8,%eax
80103bd8:	89 c2                	mov    %eax,%edx
80103bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103bdd:	83 c0 0e             	add    $0xe,%eax
80103be0:	0f b6 00             	movzbl (%eax),%eax
80103be3:	0f b6 c0             	movzbl %al,%eax
80103be6:	09 d0                	or     %edx,%eax
80103be8:	c1 e0 04             	shl    $0x4,%eax
80103beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103bf2:	74 21                	je     80103c15 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103bf4:	83 ec 08             	sub    $0x8,%esp
80103bf7:	68 00 04 00 00       	push   $0x400
80103bfc:	ff 75 f0             	push   -0x10(%ebp)
80103bff:	e8 4c ff ff ff       	call   80103b50 <mpsearch1>
80103c04:	83 c4 10             	add    $0x10,%esp
80103c07:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c0a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c0e:	74 51                	je     80103c61 <mpsearch+0xa5>
      return mp;
80103c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c13:	eb 61                	jmp    80103c76 <mpsearch+0xba>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c18:	83 c0 14             	add    $0x14,%eax
80103c1b:	0f b6 00             	movzbl (%eax),%eax
80103c1e:	0f b6 c0             	movzbl %al,%eax
80103c21:	c1 e0 08             	shl    $0x8,%eax
80103c24:	89 c2                	mov    %eax,%edx
80103c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c29:	83 c0 13             	add    $0x13,%eax
80103c2c:	0f b6 00             	movzbl (%eax),%eax
80103c2f:	0f b6 c0             	movzbl %al,%eax
80103c32:	09 d0                	or     %edx,%eax
80103c34:	c1 e0 0a             	shl    $0xa,%eax
80103c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c3d:	2d 00 04 00 00       	sub    $0x400,%eax
80103c42:	83 ec 08             	sub    $0x8,%esp
80103c45:	68 00 04 00 00       	push   $0x400
80103c4a:	50                   	push   %eax
80103c4b:	e8 00 ff ff ff       	call   80103b50 <mpsearch1>
80103c50:	83 c4 10             	add    $0x10,%esp
80103c53:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c56:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103c5a:	74 05                	je     80103c61 <mpsearch+0xa5>
      return mp;
80103c5c:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103c5f:	eb 15                	jmp    80103c76 <mpsearch+0xba>
  }
  return mpsearch1(0xF0000, 0x10000);
80103c61:	83 ec 08             	sub    $0x8,%esp
80103c64:	68 00 00 01 00       	push   $0x10000
80103c69:	68 00 00 0f 00       	push   $0xf0000
80103c6e:	e8 dd fe ff ff       	call   80103b50 <mpsearch1>
80103c73:	83 c4 10             	add    $0x10,%esp
}
80103c76:	c9                   	leave  
80103c77:	c3                   	ret    

80103c78 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103c78:	55                   	push   %ebp
80103c79:	89 e5                	mov    %esp,%ebp
80103c7b:	83 ec 18             	sub    $0x18,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103c7e:	e8 39 ff ff ff       	call   80103bbc <mpsearch>
80103c83:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c86:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103c8a:	74 0a                	je     80103c96 <mpconfig+0x1e>
80103c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c8f:	8b 40 04             	mov    0x4(%eax),%eax
80103c92:	85 c0                	test   %eax,%eax
80103c94:	75 0a                	jne    80103ca0 <mpconfig+0x28>
    return 0;
80103c96:	b8 00 00 00 00       	mov    $0x0,%eax
80103c9b:	e9 81 00 00 00       	jmp    80103d21 <mpconfig+0xa9>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ca3:	8b 40 04             	mov    0x4(%eax),%eax
80103ca6:	83 ec 0c             	sub    $0xc,%esp
80103ca9:	50                   	push   %eax
80103caa:	e8 06 fe ff ff       	call   80103ab5 <p2v>
80103caf:	83 c4 10             	add    $0x10,%esp
80103cb2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103cb5:	83 ec 04             	sub    $0x4,%esp
80103cb8:	6a 04                	push   $0x4
80103cba:	68 f9 8a 10 80       	push   $0x80108af9
80103cbf:	ff 75 f0             	push   -0x10(%ebp)
80103cc2:	e8 cd 16 00 00       	call   80105394 <memcmp>
80103cc7:	83 c4 10             	add    $0x10,%esp
80103cca:	85 c0                	test   %eax,%eax
80103ccc:	74 07                	je     80103cd5 <mpconfig+0x5d>
    return 0;
80103cce:	b8 00 00 00 00       	mov    $0x0,%eax
80103cd3:	eb 4c                	jmp    80103d21 <mpconfig+0xa9>
  if(conf->version != 1 && conf->version != 4)
80103cd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cd8:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103cdc:	3c 01                	cmp    $0x1,%al
80103cde:	74 12                	je     80103cf2 <mpconfig+0x7a>
80103ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ce3:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103ce7:	3c 04                	cmp    $0x4,%al
80103ce9:	74 07                	je     80103cf2 <mpconfig+0x7a>
    return 0;
80103ceb:	b8 00 00 00 00       	mov    $0x0,%eax
80103cf0:	eb 2f                	jmp    80103d21 <mpconfig+0xa9>
  if(sum((uchar*)conf, conf->length) != 0)
80103cf2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103cf5:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103cf9:	0f b7 c0             	movzwl %ax,%eax
80103cfc:	83 ec 08             	sub    $0x8,%esp
80103cff:	50                   	push   %eax
80103d00:	ff 75 f0             	push   -0x10(%ebp)
80103d03:	e8 10 fe ff ff       	call   80103b18 <sum>
80103d08:	83 c4 10             	add    $0x10,%esp
80103d0b:	84 c0                	test   %al,%al
80103d0d:	74 07                	je     80103d16 <mpconfig+0x9e>
    return 0;
80103d0f:	b8 00 00 00 00       	mov    $0x0,%eax
80103d14:	eb 0b                	jmp    80103d21 <mpconfig+0xa9>
  *pmp = mp;
80103d16:	8b 45 08             	mov    0x8(%ebp),%eax
80103d19:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103d1c:	89 10                	mov    %edx,(%eax)
  return conf;
80103d1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103d21:	c9                   	leave  
80103d22:	c3                   	ret    

80103d23 <mpinit>:

void
mpinit(void)
{
80103d23:	55                   	push   %ebp
80103d24:	89 e5                	mov    %esp,%ebp
80103d26:	83 ec 28             	sub    $0x28,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103d29:	c7 05 4c 19 11 80 60 	movl   $0x80111360,0x8011194c
80103d30:	13 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103d33:	83 ec 0c             	sub    $0xc,%esp
80103d36:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103d39:	50                   	push   %eax
80103d3a:	e8 39 ff ff ff       	call   80103c78 <mpconfig>
80103d3f:	83 c4 10             	add    $0x10,%esp
80103d42:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103d45:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103d49:	0f 84 ba 01 00 00    	je     80103f09 <mpinit+0x1e6>
    return;
  ismp = 1;
80103d4f:	c7 05 40 19 11 80 01 	movl   $0x1,0x80111940
80103d56:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103d59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d5c:	8b 40 24             	mov    0x24(%eax),%eax
80103d5f:	a3 60 12 11 80       	mov    %eax,0x80111260
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d64:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d67:	83 c0 2c             	add    $0x2c,%eax
80103d6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103d6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d70:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103d74:	0f b7 d0             	movzwl %ax,%edx
80103d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103d7a:	01 d0                	add    %edx,%eax
80103d7c:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103d7f:	e9 16 01 00 00       	jmp    80103e9a <mpinit+0x177>
    switch(*p){
80103d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d87:	0f b6 00             	movzbl (%eax),%eax
80103d8a:	0f b6 c0             	movzbl %al,%eax
80103d8d:	83 f8 04             	cmp    $0x4,%eax
80103d90:	0f 8f e0 00 00 00    	jg     80103e76 <mpinit+0x153>
80103d96:	83 f8 03             	cmp    $0x3,%eax
80103d99:	0f 8d d1 00 00 00    	jge    80103e70 <mpinit+0x14d>
80103d9f:	83 f8 02             	cmp    $0x2,%eax
80103da2:	0f 84 b0 00 00 00    	je     80103e58 <mpinit+0x135>
80103da8:	83 f8 02             	cmp    $0x2,%eax
80103dab:	0f 8f c5 00 00 00    	jg     80103e76 <mpinit+0x153>
80103db1:	85 c0                	test   %eax,%eax
80103db3:	74 0e                	je     80103dc3 <mpinit+0xa0>
80103db5:	83 f8 01             	cmp    $0x1,%eax
80103db8:	0f 84 b2 00 00 00    	je     80103e70 <mpinit+0x14d>
80103dbe:	e9 b3 00 00 00       	jmp    80103e76 <mpinit+0x153>
    case MPPROC:
      proc = (struct mpproc*)p;
80103dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103dc6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(ncpu != proc->apicid){
80103dc9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103dcc:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103dd0:	0f b6 d0             	movzbl %al,%edx
80103dd3:	a1 44 19 11 80       	mov    0x80111944,%eax
80103dd8:	39 c2                	cmp    %eax,%edx
80103dda:	74 2b                	je     80103e07 <mpinit+0xe4>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103ddc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103ddf:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103de3:	0f b6 d0             	movzbl %al,%edx
80103de6:	a1 44 19 11 80       	mov    0x80111944,%eax
80103deb:	83 ec 04             	sub    $0x4,%esp
80103dee:	52                   	push   %edx
80103def:	50                   	push   %eax
80103df0:	68 fe 8a 10 80       	push   $0x80108afe
80103df5:	e8 cc c5 ff ff       	call   801003c6 <cprintf>
80103dfa:	83 c4 10             	add    $0x10,%esp
        ismp = 0;
80103dfd:	c7 05 40 19 11 80 00 	movl   $0x0,0x80111940
80103e04:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103e0a:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103e0e:	0f b6 c0             	movzbl %al,%eax
80103e11:	83 e0 02             	and    $0x2,%eax
80103e14:	85 c0                	test   %eax,%eax
80103e16:	74 15                	je     80103e2d <mpinit+0x10a>
        bcpu = &cpus[ncpu];
80103e18:	a1 44 19 11 80       	mov    0x80111944,%eax
80103e1d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e23:	05 60 13 11 80       	add    $0x80111360,%eax
80103e28:	a3 4c 19 11 80       	mov    %eax,0x8011194c
      cpus[ncpu].id = ncpu;
80103e2d:	8b 15 44 19 11 80    	mov    0x80111944,%edx
80103e33:	a1 44 19 11 80       	mov    0x80111944,%eax
80103e38:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103e3e:	05 60 13 11 80       	add    $0x80111360,%eax
80103e43:	88 10                	mov    %dl,(%eax)
      ncpu++;
80103e45:	a1 44 19 11 80       	mov    0x80111944,%eax
80103e4a:	83 c0 01             	add    $0x1,%eax
80103e4d:	a3 44 19 11 80       	mov    %eax,0x80111944
      p += sizeof(struct mpproc);
80103e52:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103e56:	eb 42                	jmp    80103e9a <mpinit+0x177>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
      ioapicid = ioapic->apicno;
80103e5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103e61:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103e65:	a2 48 19 11 80       	mov    %al,0x80111948
      p += sizeof(struct mpioapic);
80103e6a:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e6e:	eb 2a                	jmp    80103e9a <mpinit+0x177>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103e70:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103e74:	eb 24                	jmp    80103e9a <mpinit+0x177>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e79:	0f b6 00             	movzbl (%eax),%eax
80103e7c:	0f b6 c0             	movzbl %al,%eax
80103e7f:	83 ec 08             	sub    $0x8,%esp
80103e82:	50                   	push   %eax
80103e83:	68 1c 8b 10 80       	push   $0x80108b1c
80103e88:	e8 39 c5 ff ff       	call   801003c6 <cprintf>
80103e8d:	83 c4 10             	add    $0x10,%esp
      ismp = 0;
80103e90:	c7 05 40 19 11 80 00 	movl   $0x0,0x80111940
80103e97:	00 00 00 
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103e9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103e9d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103ea0:	0f 82 de fe ff ff    	jb     80103d84 <mpinit+0x61>
    }
  }
  if(!ismp){
80103ea6:	a1 40 19 11 80       	mov    0x80111940,%eax
80103eab:	85 c0                	test   %eax,%eax
80103ead:	75 1d                	jne    80103ecc <mpinit+0x1a9>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103eaf:	c7 05 44 19 11 80 01 	movl   $0x1,0x80111944
80103eb6:	00 00 00 
    lapic = 0;
80103eb9:	c7 05 60 12 11 80 00 	movl   $0x0,0x80111260
80103ec0:	00 00 00 
    ioapicid = 0;
80103ec3:	c6 05 48 19 11 80 00 	movb   $0x0,0x80111948
    return;
80103eca:	eb 3e                	jmp    80103f0a <mpinit+0x1e7>
  }

  if(mp->imcrp){
80103ecc:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103ecf:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103ed3:	84 c0                	test   %al,%al
80103ed5:	74 33                	je     80103f0a <mpinit+0x1e7>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103ed7:	83 ec 08             	sub    $0x8,%esp
80103eda:	6a 70                	push   $0x70
80103edc:	6a 22                	push   $0x22
80103ede:	e8 fc fb ff ff       	call   80103adf <outb>
80103ee3:	83 c4 10             	add    $0x10,%esp
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103ee6:	83 ec 0c             	sub    $0xc,%esp
80103ee9:	6a 23                	push   $0x23
80103eeb:	e8 d2 fb ff ff       	call   80103ac2 <inb>
80103ef0:	83 c4 10             	add    $0x10,%esp
80103ef3:	83 c8 01             	or     $0x1,%eax
80103ef6:	0f b6 c0             	movzbl %al,%eax
80103ef9:	83 ec 08             	sub    $0x8,%esp
80103efc:	50                   	push   %eax
80103efd:	6a 23                	push   $0x23
80103eff:	e8 db fb ff ff       	call   80103adf <outb>
80103f04:	83 c4 10             	add    $0x10,%esp
80103f07:	eb 01                	jmp    80103f0a <mpinit+0x1e7>
    return;
80103f09:	90                   	nop
  }
}
80103f0a:	c9                   	leave  
80103f0b:	c3                   	ret    

80103f0c <outb>:
{
80103f0c:	55                   	push   %ebp
80103f0d:	89 e5                	mov    %esp,%ebp
80103f0f:	83 ec 08             	sub    $0x8,%esp
80103f12:	8b 45 08             	mov    0x8(%ebp),%eax
80103f15:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f18:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80103f1c:	89 d0                	mov    %edx,%eax
80103f1e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103f21:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103f25:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103f29:	ee                   	out    %al,(%dx)
}
80103f2a:	90                   	nop
80103f2b:	c9                   	leave  
80103f2c:	c3                   	ret    

80103f2d <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103f2d:	55                   	push   %ebp
80103f2e:	89 e5                	mov    %esp,%ebp
80103f30:	83 ec 04             	sub    $0x4,%esp
80103f33:	8b 45 08             	mov    0x8(%ebp),%eax
80103f36:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103f3a:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f3e:	66 a3 00 b0 10 80    	mov    %ax,0x8010b000
  outb(IO_PIC1+1, mask);
80103f44:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f48:	0f b6 c0             	movzbl %al,%eax
80103f4b:	50                   	push   %eax
80103f4c:	6a 21                	push   $0x21
80103f4e:	e8 b9 ff ff ff       	call   80103f0c <outb>
80103f53:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, mask >> 8);
80103f56:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103f5a:	66 c1 e8 08          	shr    $0x8,%ax
80103f5e:	0f b6 c0             	movzbl %al,%eax
80103f61:	50                   	push   %eax
80103f62:	68 a1 00 00 00       	push   $0xa1
80103f67:	e8 a0 ff ff ff       	call   80103f0c <outb>
80103f6c:	83 c4 08             	add    $0x8,%esp
}
80103f6f:	90                   	nop
80103f70:	c9                   	leave  
80103f71:	c3                   	ret    

80103f72 <picenable>:

void
picenable(int irq)
{
80103f72:	55                   	push   %ebp
80103f73:	89 e5                	mov    %esp,%ebp
  picsetmask(irqmask & ~(1<<irq));
80103f75:	8b 45 08             	mov    0x8(%ebp),%eax
80103f78:	ba 01 00 00 00       	mov    $0x1,%edx
80103f7d:	89 c1                	mov    %eax,%ecx
80103f7f:	d3 e2                	shl    %cl,%edx
80103f81:	89 d0                	mov    %edx,%eax
80103f83:	f7 d0                	not    %eax
80103f85:	89 c2                	mov    %eax,%edx
80103f87:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80103f8e:	21 d0                	and    %edx,%eax
80103f90:	0f b7 c0             	movzwl %ax,%eax
80103f93:	50                   	push   %eax
80103f94:	e8 94 ff ff ff       	call   80103f2d <picsetmask>
80103f99:	83 c4 04             	add    $0x4,%esp
}
80103f9c:	90                   	nop
80103f9d:	c9                   	leave  
80103f9e:	c3                   	ret    

80103f9f <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103f9f:	55                   	push   %ebp
80103fa0:	89 e5                	mov    %esp,%ebp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103fa2:	68 ff 00 00 00       	push   $0xff
80103fa7:	6a 21                	push   $0x21
80103fa9:	e8 5e ff ff ff       	call   80103f0c <outb>
80103fae:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, 0xFF);
80103fb1:	68 ff 00 00 00       	push   $0xff
80103fb6:	68 a1 00 00 00       	push   $0xa1
80103fbb:	e8 4c ff ff ff       	call   80103f0c <outb>
80103fc0:	83 c4 08             	add    $0x8,%esp

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103fc3:	6a 11                	push   $0x11
80103fc5:	6a 20                	push   $0x20
80103fc7:	e8 40 ff ff ff       	call   80103f0c <outb>
80103fcc:	83 c4 08             	add    $0x8,%esp

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103fcf:	6a 20                	push   $0x20
80103fd1:	6a 21                	push   $0x21
80103fd3:	e8 34 ff ff ff       	call   80103f0c <outb>
80103fd8:	83 c4 08             	add    $0x8,%esp

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103fdb:	6a 04                	push   $0x4
80103fdd:	6a 21                	push   $0x21
80103fdf:	e8 28 ff ff ff       	call   80103f0c <outb>
80103fe4:	83 c4 08             	add    $0x8,%esp
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103fe7:	6a 03                	push   $0x3
80103fe9:	6a 21                	push   $0x21
80103feb:	e8 1c ff ff ff       	call   80103f0c <outb>
80103ff0:	83 c4 08             	add    $0x8,%esp

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103ff3:	6a 11                	push   $0x11
80103ff5:	68 a0 00 00 00       	push   $0xa0
80103ffa:	e8 0d ff ff ff       	call   80103f0c <outb>
80103fff:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80104002:	6a 28                	push   $0x28
80104004:	68 a1 00 00 00       	push   $0xa1
80104009:	e8 fe fe ff ff       	call   80103f0c <outb>
8010400e:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80104011:	6a 02                	push   $0x2
80104013:	68 a1 00 00 00       	push   $0xa1
80104018:	e8 ef fe ff ff       	call   80103f0c <outb>
8010401d:	83 c4 08             	add    $0x8,%esp
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80104020:	6a 03                	push   $0x3
80104022:	68 a1 00 00 00       	push   $0xa1
80104027:	e8 e0 fe ff ff       	call   80103f0c <outb>
8010402c:	83 c4 08             	add    $0x8,%esp

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
8010402f:	6a 68                	push   $0x68
80104031:	6a 20                	push   $0x20
80104033:	e8 d4 fe ff ff       	call   80103f0c <outb>
80104038:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC1, 0x0a);             // read IRR by default
8010403b:	6a 0a                	push   $0xa
8010403d:	6a 20                	push   $0x20
8010403f:	e8 c8 fe ff ff       	call   80103f0c <outb>
80104044:	83 c4 08             	add    $0x8,%esp

  outb(IO_PIC2, 0x68);             // OCW3
80104047:	6a 68                	push   $0x68
80104049:	68 a0 00 00 00       	push   $0xa0
8010404e:	e8 b9 fe ff ff       	call   80103f0c <outb>
80104053:	83 c4 08             	add    $0x8,%esp
  outb(IO_PIC2, 0x0a);             // OCW3
80104056:	6a 0a                	push   $0xa
80104058:	68 a0 00 00 00       	push   $0xa0
8010405d:	e8 aa fe ff ff       	call   80103f0c <outb>
80104062:	83 c4 08             	add    $0x8,%esp

  if(irqmask != 0xFFFF)
80104065:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
8010406c:	66 83 f8 ff          	cmp    $0xffff,%ax
80104070:	74 13                	je     80104085 <picinit+0xe6>
    picsetmask(irqmask);
80104072:	0f b7 05 00 b0 10 80 	movzwl 0x8010b000,%eax
80104079:	0f b7 c0             	movzwl %ax,%eax
8010407c:	50                   	push   %eax
8010407d:	e8 ab fe ff ff       	call   80103f2d <picsetmask>
80104082:	83 c4 04             	add    $0x4,%esp
}
80104085:	90                   	nop
80104086:	c9                   	leave  
80104087:	c3                   	ret    

80104088 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80104088:	55                   	push   %ebp
80104089:	89 e5                	mov    %esp,%ebp
8010408b:	83 ec 18             	sub    $0x18,%esp
  struct pipe *p;

  p = 0;
8010408e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80104095:	8b 45 0c             	mov    0xc(%ebp),%eax
80104098:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
8010409e:	8b 45 0c             	mov    0xc(%ebp),%eax
801040a1:	8b 10                	mov    (%eax),%edx
801040a3:	8b 45 08             	mov    0x8(%ebp),%eax
801040a6:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801040a8:	e8 13 cf ff ff       	call   80100fc0 <filealloc>
801040ad:	8b 55 08             	mov    0x8(%ebp),%edx
801040b0:	89 02                	mov    %eax,(%edx)
801040b2:	8b 45 08             	mov    0x8(%ebp),%eax
801040b5:	8b 00                	mov    (%eax),%eax
801040b7:	85 c0                	test   %eax,%eax
801040b9:	0f 84 c8 00 00 00    	je     80104187 <pipealloc+0xff>
801040bf:	e8 fc ce ff ff       	call   80100fc0 <filealloc>
801040c4:	8b 55 0c             	mov    0xc(%ebp),%edx
801040c7:	89 02                	mov    %eax,(%edx)
801040c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801040cc:	8b 00                	mov    (%eax),%eax
801040ce:	85 c0                	test   %eax,%eax
801040d0:	0f 84 b1 00 00 00    	je     80104187 <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801040d6:	e8 ab eb ff ff       	call   80102c86 <kalloc>
801040db:	89 45 f4             	mov    %eax,-0xc(%ebp)
801040de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801040e2:	0f 84 a2 00 00 00    	je     8010418a <pipealloc+0x102>
    goto bad;
  p->readopen = 1;
801040e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040eb:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801040f2:	00 00 00 
  p->writeopen = 1;
801040f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801040f8:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801040ff:	00 00 00 
  p->nwrite = 0;
80104102:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104105:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010410c:	00 00 00 
  p->nread = 0;
8010410f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104112:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80104119:	00 00 00 
  initlock(&p->lock, "pipe");
8010411c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010411f:	83 ec 08             	sub    $0x8,%esp
80104122:	68 3c 8b 10 80       	push   $0x80108b3c
80104127:	50                   	push   %eax
80104128:	e8 7b 0f 00 00       	call   801050a8 <initlock>
8010412d:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80104130:	8b 45 08             	mov    0x8(%ebp),%eax
80104133:	8b 00                	mov    (%eax),%eax
80104135:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010413b:	8b 45 08             	mov    0x8(%ebp),%eax
8010413e:	8b 00                	mov    (%eax),%eax
80104140:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104144:	8b 45 08             	mov    0x8(%ebp),%eax
80104147:	8b 00                	mov    (%eax),%eax
80104149:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
8010414d:	8b 45 08             	mov    0x8(%ebp),%eax
80104150:	8b 00                	mov    (%eax),%eax
80104152:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104155:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
80104158:	8b 45 0c             	mov    0xc(%ebp),%eax
8010415b:	8b 00                	mov    (%eax),%eax
8010415d:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104163:	8b 45 0c             	mov    0xc(%ebp),%eax
80104166:	8b 00                	mov    (%eax),%eax
80104168:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010416c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010416f:	8b 00                	mov    (%eax),%eax
80104171:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104175:	8b 45 0c             	mov    0xc(%ebp),%eax
80104178:	8b 00                	mov    (%eax),%eax
8010417a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010417d:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104180:	b8 00 00 00 00       	mov    $0x0,%eax
80104185:	eb 51                	jmp    801041d8 <pipealloc+0x150>
    goto bad;
80104187:	90                   	nop
80104188:	eb 01                	jmp    8010418b <pipealloc+0x103>
    goto bad;
8010418a:	90                   	nop

//PAGEBREAK: 20
 bad:
  if(p)
8010418b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010418f:	74 0e                	je     8010419f <pipealloc+0x117>
    kfree((char*)p);
80104191:	83 ec 0c             	sub    $0xc,%esp
80104194:	ff 75 f4             	push   -0xc(%ebp)
80104197:	e8 40 ea ff ff       	call   80102bdc <kfree>
8010419c:	83 c4 10             	add    $0x10,%esp
  if(*f0)
8010419f:	8b 45 08             	mov    0x8(%ebp),%eax
801041a2:	8b 00                	mov    (%eax),%eax
801041a4:	85 c0                	test   %eax,%eax
801041a6:	74 11                	je     801041b9 <pipealloc+0x131>
    fileclose(*f0);
801041a8:	8b 45 08             	mov    0x8(%ebp),%eax
801041ab:	8b 00                	mov    (%eax),%eax
801041ad:	83 ec 0c             	sub    $0xc,%esp
801041b0:	50                   	push   %eax
801041b1:	e8 c8 ce ff ff       	call   8010107e <fileclose>
801041b6:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801041b9:	8b 45 0c             	mov    0xc(%ebp),%eax
801041bc:	8b 00                	mov    (%eax),%eax
801041be:	85 c0                	test   %eax,%eax
801041c0:	74 11                	je     801041d3 <pipealloc+0x14b>
    fileclose(*f1);
801041c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801041c5:	8b 00                	mov    (%eax),%eax
801041c7:	83 ec 0c             	sub    $0xc,%esp
801041ca:	50                   	push   %eax
801041cb:	e8 ae ce ff ff       	call   8010107e <fileclose>
801041d0:	83 c4 10             	add    $0x10,%esp
  return -1;
801041d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041d8:	c9                   	leave  
801041d9:	c3                   	ret    

801041da <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801041da:	55                   	push   %ebp
801041db:	89 e5                	mov    %esp,%ebp
801041dd:	83 ec 08             	sub    $0x8,%esp
  acquire(&p->lock);
801041e0:	8b 45 08             	mov    0x8(%ebp),%eax
801041e3:	83 ec 0c             	sub    $0xc,%esp
801041e6:	50                   	push   %eax
801041e7:	e8 de 0e 00 00       	call   801050ca <acquire>
801041ec:	83 c4 10             	add    $0x10,%esp
  if(writable){
801041ef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801041f3:	74 23                	je     80104218 <pipeclose+0x3e>
    p->writeopen = 0;
801041f5:	8b 45 08             	mov    0x8(%ebp),%eax
801041f8:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801041ff:	00 00 00 
    wakeup(&p->nread);
80104202:	8b 45 08             	mov    0x8(%ebp),%eax
80104205:	05 34 02 00 00       	add    $0x234,%eax
8010420a:	83 ec 0c             	sub    $0xc,%esp
8010420d:	50                   	push   %eax
8010420e:	e8 a8 0c 00 00       	call   80104ebb <wakeup>
80104213:	83 c4 10             	add    $0x10,%esp
80104216:	eb 21                	jmp    80104239 <pipeclose+0x5f>
  } else {
    p->readopen = 0;
80104218:	8b 45 08             	mov    0x8(%ebp),%eax
8010421b:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
80104222:	00 00 00 
    wakeup(&p->nwrite);
80104225:	8b 45 08             	mov    0x8(%ebp),%eax
80104228:	05 38 02 00 00       	add    $0x238,%eax
8010422d:	83 ec 0c             	sub    $0xc,%esp
80104230:	50                   	push   %eax
80104231:	e8 85 0c 00 00       	call   80104ebb <wakeup>
80104236:	83 c4 10             	add    $0x10,%esp
  }
  if(p->readopen == 0 && p->writeopen == 0){
80104239:	8b 45 08             	mov    0x8(%ebp),%eax
8010423c:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104242:	85 c0                	test   %eax,%eax
80104244:	75 2c                	jne    80104272 <pipeclose+0x98>
80104246:	8b 45 08             	mov    0x8(%ebp),%eax
80104249:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010424f:	85 c0                	test   %eax,%eax
80104251:	75 1f                	jne    80104272 <pipeclose+0x98>
    release(&p->lock);
80104253:	8b 45 08             	mov    0x8(%ebp),%eax
80104256:	83 ec 0c             	sub    $0xc,%esp
80104259:	50                   	push   %eax
8010425a:	e8 d2 0e 00 00       	call   80105131 <release>
8010425f:	83 c4 10             	add    $0x10,%esp
    kfree((char*)p);
80104262:	83 ec 0c             	sub    $0xc,%esp
80104265:	ff 75 08             	push   0x8(%ebp)
80104268:	e8 6f e9 ff ff       	call   80102bdc <kfree>
8010426d:	83 c4 10             	add    $0x10,%esp
80104270:	eb 10                	jmp    80104282 <pipeclose+0xa8>
  } else
    release(&p->lock);
80104272:	8b 45 08             	mov    0x8(%ebp),%eax
80104275:	83 ec 0c             	sub    $0xc,%esp
80104278:	50                   	push   %eax
80104279:	e8 b3 0e 00 00       	call   80105131 <release>
8010427e:	83 c4 10             	add    $0x10,%esp
}
80104281:	90                   	nop
80104282:	90                   	nop
80104283:	c9                   	leave  
80104284:	c3                   	ret    

80104285 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104285:	55                   	push   %ebp
80104286:	89 e5                	mov    %esp,%ebp
80104288:	53                   	push   %ebx
80104289:	83 ec 14             	sub    $0x14,%esp
  int i;

  acquire(&p->lock);
8010428c:	8b 45 08             	mov    0x8(%ebp),%eax
8010428f:	83 ec 0c             	sub    $0xc,%esp
80104292:	50                   	push   %eax
80104293:	e8 32 0e 00 00       	call   801050ca <acquire>
80104298:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < n; i++){
8010429b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801042a2:	e9 ae 00 00 00       	jmp    80104355 <pipewrite+0xd0>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || proc->killed){
801042a7:	8b 45 08             	mov    0x8(%ebp),%eax
801042aa:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801042b0:	85 c0                	test   %eax,%eax
801042b2:	74 0d                	je     801042c1 <pipewrite+0x3c>
801042b4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801042ba:	8b 40 24             	mov    0x24(%eax),%eax
801042bd:	85 c0                	test   %eax,%eax
801042bf:	74 19                	je     801042da <pipewrite+0x55>
        release(&p->lock);
801042c1:	8b 45 08             	mov    0x8(%ebp),%eax
801042c4:	83 ec 0c             	sub    $0xc,%esp
801042c7:	50                   	push   %eax
801042c8:	e8 64 0e 00 00       	call   80105131 <release>
801042cd:	83 c4 10             	add    $0x10,%esp
        return -1;
801042d0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801042d5:	e9 a9 00 00 00       	jmp    80104383 <pipewrite+0xfe>
      }
      wakeup(&p->nread);
801042da:	8b 45 08             	mov    0x8(%ebp),%eax
801042dd:	05 34 02 00 00       	add    $0x234,%eax
801042e2:	83 ec 0c             	sub    $0xc,%esp
801042e5:	50                   	push   %eax
801042e6:	e8 d0 0b 00 00       	call   80104ebb <wakeup>
801042eb:	83 c4 10             	add    $0x10,%esp
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801042ee:	8b 45 08             	mov    0x8(%ebp),%eax
801042f1:	8b 55 08             	mov    0x8(%ebp),%edx
801042f4:	81 c2 38 02 00 00    	add    $0x238,%edx
801042fa:	83 ec 08             	sub    $0x8,%esp
801042fd:	50                   	push   %eax
801042fe:	52                   	push   %edx
801042ff:	e8 cb 0a 00 00       	call   80104dcf <sleep>
80104304:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80104307:	8b 45 08             	mov    0x8(%ebp),%eax
8010430a:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
80104310:	8b 45 08             	mov    0x8(%ebp),%eax
80104313:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104319:	05 00 02 00 00       	add    $0x200,%eax
8010431e:	39 c2                	cmp    %eax,%edx
80104320:	74 85                	je     801042a7 <pipewrite+0x22>
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80104322:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104325:	8b 45 0c             	mov    0xc(%ebp),%eax
80104328:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010432b:	8b 45 08             	mov    0x8(%ebp),%eax
8010432e:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
80104334:	8d 48 01             	lea    0x1(%eax),%ecx
80104337:	8b 55 08             	mov    0x8(%ebp),%edx
8010433a:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
80104340:	25 ff 01 00 00       	and    $0x1ff,%eax
80104345:	89 c1                	mov    %eax,%ecx
80104347:	0f b6 13             	movzbl (%ebx),%edx
8010434a:	8b 45 08             	mov    0x8(%ebp),%eax
8010434d:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
  for(i = 0; i < n; i++){
80104351:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104355:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104358:	3b 45 10             	cmp    0x10(%ebp),%eax
8010435b:	7c aa                	jl     80104307 <pipewrite+0x82>
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
8010435d:	8b 45 08             	mov    0x8(%ebp),%eax
80104360:	05 34 02 00 00       	add    $0x234,%eax
80104365:	83 ec 0c             	sub    $0xc,%esp
80104368:	50                   	push   %eax
80104369:	e8 4d 0b 00 00       	call   80104ebb <wakeup>
8010436e:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104371:	8b 45 08             	mov    0x8(%ebp),%eax
80104374:	83 ec 0c             	sub    $0xc,%esp
80104377:	50                   	push   %eax
80104378:	e8 b4 0d 00 00       	call   80105131 <release>
8010437d:	83 c4 10             	add    $0x10,%esp
  return n;
80104380:	8b 45 10             	mov    0x10(%ebp),%eax
}
80104383:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104386:	c9                   	leave  
80104387:	c3                   	ret    

80104388 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80104388:	55                   	push   %ebp
80104389:	89 e5                	mov    %esp,%ebp
8010438b:	83 ec 18             	sub    $0x18,%esp
  int i;

  acquire(&p->lock);
8010438e:	8b 45 08             	mov    0x8(%ebp),%eax
80104391:	83 ec 0c             	sub    $0xc,%esp
80104394:	50                   	push   %eax
80104395:	e8 30 0d 00 00       	call   801050ca <acquire>
8010439a:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010439d:	eb 3f                	jmp    801043de <piperead+0x56>
    if(proc->killed){
8010439f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801043a5:	8b 40 24             	mov    0x24(%eax),%eax
801043a8:	85 c0                	test   %eax,%eax
801043aa:	74 19                	je     801043c5 <piperead+0x3d>
      release(&p->lock);
801043ac:	8b 45 08             	mov    0x8(%ebp),%eax
801043af:	83 ec 0c             	sub    $0xc,%esp
801043b2:	50                   	push   %eax
801043b3:	e8 79 0d 00 00       	call   80105131 <release>
801043b8:	83 c4 10             	add    $0x10,%esp
      return -1;
801043bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801043c0:	e9 be 00 00 00       	jmp    80104483 <piperead+0xfb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801043c5:	8b 45 08             	mov    0x8(%ebp),%eax
801043c8:	8b 55 08             	mov    0x8(%ebp),%edx
801043cb:	81 c2 34 02 00 00    	add    $0x234,%edx
801043d1:	83 ec 08             	sub    $0x8,%esp
801043d4:	50                   	push   %eax
801043d5:	52                   	push   %edx
801043d6:	e8 f4 09 00 00       	call   80104dcf <sleep>
801043db:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801043de:	8b 45 08             	mov    0x8(%ebp),%eax
801043e1:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801043e7:	8b 45 08             	mov    0x8(%ebp),%eax
801043ea:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801043f0:	39 c2                	cmp    %eax,%edx
801043f2:	75 0d                	jne    80104401 <piperead+0x79>
801043f4:	8b 45 08             	mov    0x8(%ebp),%eax
801043f7:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
801043fd:	85 c0                	test   %eax,%eax
801043ff:	75 9e                	jne    8010439f <piperead+0x17>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104401:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104408:	eb 48                	jmp    80104452 <piperead+0xca>
    if(p->nread == p->nwrite)
8010440a:	8b 45 08             	mov    0x8(%ebp),%eax
8010440d:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104413:	8b 45 08             	mov    0x8(%ebp),%eax
80104416:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010441c:	39 c2                	cmp    %eax,%edx
8010441e:	74 3c                	je     8010445c <piperead+0xd4>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80104420:	8b 45 08             	mov    0x8(%ebp),%eax
80104423:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
80104429:	8d 48 01             	lea    0x1(%eax),%ecx
8010442c:	8b 55 08             	mov    0x8(%ebp),%edx
8010442f:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
80104435:	25 ff 01 00 00       	and    $0x1ff,%eax
8010443a:	89 c1                	mov    %eax,%ecx
8010443c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010443f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104442:	01 c2                	add    %eax,%edx
80104444:	8b 45 08             	mov    0x8(%ebp),%eax
80104447:	0f b6 44 08 34       	movzbl 0x34(%eax,%ecx,1),%eax
8010444c:	88 02                	mov    %al,(%edx)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010444e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80104452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104455:	3b 45 10             	cmp    0x10(%ebp),%eax
80104458:	7c b0                	jl     8010440a <piperead+0x82>
8010445a:	eb 01                	jmp    8010445d <piperead+0xd5>
      break;
8010445c:	90                   	nop
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010445d:	8b 45 08             	mov    0x8(%ebp),%eax
80104460:	05 38 02 00 00       	add    $0x238,%eax
80104465:	83 ec 0c             	sub    $0xc,%esp
80104468:	50                   	push   %eax
80104469:	e8 4d 0a 00 00       	call   80104ebb <wakeup>
8010446e:	83 c4 10             	add    $0x10,%esp
  release(&p->lock);
80104471:	8b 45 08             	mov    0x8(%ebp),%eax
80104474:	83 ec 0c             	sub    $0xc,%esp
80104477:	50                   	push   %eax
80104478:	e8 b4 0c 00 00       	call   80105131 <release>
8010447d:	83 c4 10             	add    $0x10,%esp
  return i;
80104480:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104483:	c9                   	leave  
80104484:	c3                   	ret    

80104485 <readeflags>:
{
80104485:	55                   	push   %ebp
80104486:	89 e5                	mov    %esp,%ebp
80104488:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010448b:	9c                   	pushf  
8010448c:	58                   	pop    %eax
8010448d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80104490:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80104493:	c9                   	leave  
80104494:	c3                   	ret    

80104495 <sti>:
{
80104495:	55                   	push   %ebp
80104496:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104498:	fb                   	sti    
}
80104499:	90                   	nop
8010449a:	5d                   	pop    %ebp
8010449b:	c3                   	ret    

8010449c <halt>:
}

// CS550: to solve the 100%-CPU-utilization-when-idling problem - "hlt" instruction puts CPU to sleep
static inline void
halt()
{
8010449c:	55                   	push   %ebp
8010449d:	89 e5                	mov    %esp,%ebp
    asm volatile("hlt" : : :"memory");
8010449f:	f4                   	hlt    
}
801044a0:	90                   	nop
801044a1:	5d                   	pop    %ebp
801044a2:	c3                   	ret    

801044a3 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801044a3:	55                   	push   %ebp
801044a4:	89 e5                	mov    %esp,%ebp
801044a6:	83 ec 08             	sub    $0x8,%esp
  initlock(&ptable.lock, "ptable");
801044a9:	83 ec 08             	sub    $0x8,%esp
801044ac:	68 41 8b 10 80       	push   $0x80108b41
801044b1:	68 80 19 11 80       	push   $0x80111980
801044b6:	e8 ed 0b 00 00       	call   801050a8 <initlock>
801044bb:	83 c4 10             	add    $0x10,%esp
}
801044be:	90                   	nop
801044bf:	c9                   	leave  
801044c0:	c3                   	ret    

801044c1 <mycpu>:
// Return the current CPU structure.

// Return the current CPU structure (single-CPU kernel version).
struct cpu*
mycpu(void)
{
801044c1:	55                   	push   %ebp
801044c2:	89 e5                	mov    %esp,%ebp
  // Only one CPU: always index 0
  return &cpus[0];
801044c4:	b8 60 13 11 80       	mov    $0x80111360,%eax
}
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    

801044cb <cpuid>:

// Return current CPU id (single-CPU, always 0).
int
cpuid(void)
{
801044cb:	55                   	push   %ebp
801044cc:	89 e5                	mov    %esp,%ebp
  return 0;
801044ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044d3:	5d                   	pop    %ebp
801044d4:	c3                   	ret    

801044d5 <myproc>:


// Return the currently running process on this CPU.
struct proc*
myproc(void)
{
801044d5:	55                   	push   %ebp
801044d6:	89 e5                	mov    %esp,%ebp
801044d8:	83 ec 18             	sub    $0x18,%esp
  struct cpu *c;
  struct proc *p;

  pushcli();        // disable interrupts
801044db:	e8 48 0d 00 00       	call   80105228 <pushcli>
  c = mycpu();
801044e0:	e8 dc ff ff ff       	call   801044c1 <mycpu>
801044e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  p = c->proc;
801044e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044eb:	8b 80 b8 00 00 00    	mov    0xb8(%eax),%eax
801044f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  popcli();         // re-enable interrupts
801044f4:	e8 73 0d 00 00       	call   8010526c <popcli>

  return p;
801044f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801044fc:	c9                   	leave  
801044fd:	c3                   	ret    

801044fe <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801044fe:	55                   	push   %ebp
801044ff:	89 e5                	mov    %esp,%ebp
80104501:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104504:	83 ec 0c             	sub    $0xc,%esp
80104507:	68 80 19 11 80       	push   $0x80111980
8010450c:	e8 b9 0b 00 00       	call   801050ca <acquire>
80104511:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104514:	c7 45 f4 b4 19 11 80 	movl   $0x801119b4,-0xc(%ebp)
8010451b:	eb 0e                	jmp    8010452b <allocproc+0x2d>
    if(p->state == UNUSED)
8010451d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104520:	8b 40 0c             	mov    0xc(%eax),%eax
80104523:	85 c0                	test   %eax,%eax
80104525:	74 27                	je     8010454e <allocproc+0x50>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104527:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
8010452b:	81 7d f4 b4 38 11 80 	cmpl   $0x801138b4,-0xc(%ebp)
80104532:	72 e9                	jb     8010451d <allocproc+0x1f>
      goto found;
  release(&ptable.lock);
80104534:	83 ec 0c             	sub    $0xc,%esp
80104537:	68 80 19 11 80       	push   $0x80111980
8010453c:	e8 f0 0b 00 00       	call   80105131 <release>
80104541:	83 c4 10             	add    $0x10,%esp
  return 0;
80104544:	b8 00 00 00 00       	mov    $0x0,%eax
80104549:	e9 b2 00 00 00       	jmp    80104600 <allocproc+0x102>
      goto found;
8010454e:	90                   	nop

found:
  p->state = EMBRYO;
8010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104552:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104559:	a1 04 b0 10 80       	mov    0x8010b004,%eax
8010455e:	8d 50 01             	lea    0x1(%eax),%edx
80104561:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
80104567:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010456a:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
8010456d:	83 ec 0c             	sub    $0xc,%esp
80104570:	68 80 19 11 80       	push   $0x80111980
80104575:	e8 b7 0b 00 00       	call   80105131 <release>
8010457a:	83 c4 10             	add    $0x10,%esp

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010457d:	e8 04 e7 ff ff       	call   80102c86 <kalloc>
80104582:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104585:	89 42 08             	mov    %eax,0x8(%edx)
80104588:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010458b:	8b 40 08             	mov    0x8(%eax),%eax
8010458e:	85 c0                	test   %eax,%eax
80104590:	75 11                	jne    801045a3 <allocproc+0xa5>
    p->state = UNUSED;
80104592:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104595:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
8010459c:	b8 00 00 00 00       	mov    $0x0,%eax
801045a1:	eb 5d                	jmp    80104600 <allocproc+0x102>
  }
  sp = p->kstack + KSTACKSIZE;
801045a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a6:	8b 40 08             	mov    0x8(%eax),%eax
801045a9:	05 00 10 00 00       	add    $0x1000,%eax
801045ae:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801045b1:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801045b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045bb:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801045be:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
801045c2:	ba e6 67 10 80       	mov    $0x801067e6,%edx
801045c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801045ca:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
801045cc:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
801045d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045d3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801045d6:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
801045d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045dc:	8b 40 1c             	mov    0x1c(%eax),%eax
801045df:	83 ec 04             	sub    $0x4,%esp
801045e2:	6a 14                	push   $0x14
801045e4:	6a 00                	push   $0x0
801045e6:	50                   	push   %eax
801045e7:	e8 41 0d 00 00       	call   8010532d <memset>
801045ec:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
801045ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045f2:	8b 40 1c             	mov    0x1c(%eax),%eax
801045f5:	ba 89 4d 10 80       	mov    $0x80104d89,%edx
801045fa:	89 50 10             	mov    %edx,0x10(%eax)

  return p;
801045fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80104600:	c9                   	leave  
80104601:	c3                   	ret    

80104602 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
80104602:	55                   	push   %ebp
80104603:	89 e5                	mov    %esp,%ebp
80104605:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104608:	e8 f1 fe ff ff       	call   801044fe <allocproc>
8010460d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
80104610:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104613:	a3 b4 38 11 80       	mov    %eax,0x801138b4
  if((p->pgdir = setupkvm()) == 0)
80104618:	e8 ce 39 00 00       	call   80107feb <setupkvm>
8010461d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104620:	89 42 04             	mov    %eax,0x4(%edx)
80104623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104626:	8b 40 04             	mov    0x4(%eax),%eax
80104629:	85 c0                	test   %eax,%eax
8010462b:	75 0d                	jne    8010463a <userinit+0x38>
    panic("userinit: out of memory?");
8010462d:	83 ec 0c             	sub    $0xc,%esp
80104630:	68 48 8b 10 80       	push   $0x80108b48
80104635:	e8 41 bf ff ff       	call   8010057b <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010463a:	ba 2c 00 00 00       	mov    $0x2c,%edx
8010463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104642:	8b 40 04             	mov    0x4(%eax),%eax
80104645:	83 ec 04             	sub    $0x4,%esp
80104648:	52                   	push   %edx
80104649:	68 00 b5 10 80       	push   $0x8010b500
8010464e:	50                   	push   %eax
8010464f:	e8 f2 3b 00 00       	call   80108246 <inituvm>
80104654:	83 c4 10             	add    $0x10,%esp
  p->sz = PGSIZE;
80104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010465a:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
80104660:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104663:	8b 40 18             	mov    0x18(%eax),%eax
80104666:	83 ec 04             	sub    $0x4,%esp
80104669:	6a 4c                	push   $0x4c
8010466b:	6a 00                	push   $0x0
8010466d:	50                   	push   %eax
8010466e:	e8 ba 0c 00 00       	call   8010532d <memset>
80104673:	83 c4 10             	add    $0x10,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80104676:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104679:	8b 40 18             	mov    0x18(%eax),%eax
8010467c:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104682:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104685:	8b 40 18             	mov    0x18(%eax),%eax
80104688:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
8010468e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104691:	8b 50 18             	mov    0x18(%eax),%edx
80104694:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104697:	8b 40 18             	mov    0x18(%eax),%eax
8010469a:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
8010469e:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
801046a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046a5:	8b 50 18             	mov    0x18(%eax),%edx
801046a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046ab:	8b 40 18             	mov    0x18(%eax),%eax
801046ae:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
801046b2:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
801046b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046b9:	8b 40 18             	mov    0x18(%eax),%eax
801046bc:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801046c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046c6:	8b 40 18             	mov    0x18(%eax),%eax
801046c9:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801046d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046d3:	8b 40 18             	mov    0x18(%eax),%eax
801046d6:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
801046dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801046e0:	83 c0 6c             	add    $0x6c,%eax
801046e3:	83 ec 04             	sub    $0x4,%esp
801046e6:	6a 10                	push   $0x10
801046e8:	68 61 8b 10 80       	push   $0x80108b61
801046ed:	50                   	push   %eax
801046ee:	e8 3d 0e 00 00       	call   80105530 <safestrcpy>
801046f3:	83 c4 10             	add    $0x10,%esp
  p->cwd = namei("/");
801046f6:	83 ec 0c             	sub    $0xc,%esp
801046f9:	68 6a 8b 10 80       	push   $0x80108b6a
801046fe:	e8 35 de ff ff       	call   80102538 <namei>
80104703:	83 c4 10             	add    $0x10,%esp
80104706:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104709:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
8010470c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010470f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
}
80104716:	90                   	nop
80104717:	c9                   	leave  
80104718:	c3                   	ret    

80104719 <growproc>:

// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
int
growproc(int n)
{
80104719:	55                   	push   %ebp
8010471a:	89 e5                	mov    %esp,%ebp
8010471c:	83 ec 18             	sub    $0x18,%esp
  uint sz;

  sz = proc->sz;
8010471f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104725:	8b 00                	mov    (%eax),%eax
80104727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
8010472a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010472e:	7e 55                	jle    80104785 <growproc+0x6c>
    if(page_allocator_type == 0){
80104730:	a1 60 19 11 80       	mov    0x80111960,%eax
80104735:	85 c0                	test   %eax,%eax
80104737:	75 31                	jne    8010476a <growproc+0x51>
      // DEFAULT allocator: allocate physical pages immediately
      if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
80104739:	8b 55 08             	mov    0x8(%ebp),%edx
8010473c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010473f:	01 c2                	add    %eax,%edx
80104741:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104747:	8b 40 04             	mov    0x4(%eax),%eax
8010474a:	83 ec 04             	sub    $0x4,%esp
8010474d:	52                   	push   %edx
8010474e:	ff 75 f4             	push   -0xc(%ebp)
80104751:	50                   	push   %eax
80104752:	e8 3c 3c 00 00       	call   80108393 <allocuvm>
80104757:	83 c4 10             	add    $0x10,%esp
8010475a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010475d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104761:	75 59                	jne    801047bc <growproc+0xa3>
        return -1;
80104763:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104768:	eb 74                	jmp    801047de <growproc+0xc5>
    } else {
      // LAZY allocator: only grow the virtual size, no physical pages yet
      if(sz + n >= KERNBASE)
8010476a:	8b 55 08             	mov    0x8(%ebp),%edx
8010476d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104770:	01 d0                	add    %edx,%eax
80104772:	85 c0                	test   %eax,%eax
80104774:	79 07                	jns    8010477d <growproc+0x64>
        return -1;
80104776:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010477b:	eb 61                	jmp    801047de <growproc+0xc5>
      sz += n;
8010477d:	8b 45 08             	mov    0x8(%ebp),%eax
80104780:	01 45 f4             	add    %eax,-0xc(%ebp)
80104783:	eb 37                	jmp    801047bc <growproc+0xa3>
    }
  } else if(n < 0){
80104785:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104789:	79 31                	jns    801047bc <growproc+0xa3>
    // shrinking is always eager: free pages immediately
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010478b:	8b 55 08             	mov    0x8(%ebp),%edx
8010478e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104791:	01 c2                	add    %eax,%edx
80104793:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104799:	8b 40 04             	mov    0x4(%eax),%eax
8010479c:	83 ec 04             	sub    $0x4,%esp
8010479f:	52                   	push   %edx
801047a0:	ff 75 f4             	push   -0xc(%ebp)
801047a3:	50                   	push   %eax
801047a4:	e8 b1 3c 00 00       	call   8010845a <deallocuvm>
801047a9:	83 c4 10             	add    $0x10,%esp
801047ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
801047af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801047b3:	75 07                	jne    801047bc <growproc+0xa3>
      return -1;
801047b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047ba:	eb 22                	jmp    801047de <growproc+0xc5>
  }

  proc->sz = sz;
801047bc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047c5:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
801047c7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047cd:	83 ec 0c             	sub    $0xc,%esp
801047d0:	50                   	push   %eax
801047d1:	e8 fc 38 00 00       	call   801080d2 <switchuvm>
801047d6:	83 c4 10             	add    $0x10,%esp
  return 0;
801047d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801047de:	c9                   	leave  
801047df:	c3                   	ret    

801047e0 <fork>:


// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
801047e0:	55                   	push   %ebp
801047e1:	89 e5                	mov    %esp,%ebp
801047e3:	57                   	push   %edi
801047e4:	56                   	push   %esi
801047e5:	53                   	push   %ebx
801047e6:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
801047e9:	e8 10 fd ff ff       	call   801044fe <allocproc>
801047ee:	89 45 e0             	mov    %eax,-0x20(%ebp)
801047f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801047f5:	75 0a                	jne    80104801 <fork+0x21>
    return -1;
801047f7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047fc:	e9 64 01 00 00       	jmp    80104965 <fork+0x185>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104801:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104807:	8b 10                	mov    (%eax),%edx
80104809:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010480f:	8b 40 04             	mov    0x4(%eax),%eax
80104812:	83 ec 08             	sub    $0x8,%esp
80104815:	52                   	push   %edx
80104816:	50                   	push   %eax
80104817:	e8 dc 3d 00 00       	call   801085f8 <copyuvm>
8010481c:	83 c4 10             	add    $0x10,%esp
8010481f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104822:	89 42 04             	mov    %eax,0x4(%edx)
80104825:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104828:	8b 40 04             	mov    0x4(%eax),%eax
8010482b:	85 c0                	test   %eax,%eax
8010482d:	75 30                	jne    8010485f <fork+0x7f>
    kfree(np->kstack);
8010482f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104832:	8b 40 08             	mov    0x8(%eax),%eax
80104835:	83 ec 0c             	sub    $0xc,%esp
80104838:	50                   	push   %eax
80104839:	e8 9e e3 ff ff       	call   80102bdc <kfree>
8010483e:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80104841:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104844:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
8010484b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010484e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
80104855:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010485a:	e9 06 01 00 00       	jmp    80104965 <fork+0x185>
  }
  np->sz = proc->sz;
8010485f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104865:	8b 10                	mov    (%eax),%edx
80104867:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010486a:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
8010486c:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104873:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104876:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
80104879:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010487f:	8b 48 18             	mov    0x18(%eax),%ecx
80104882:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104885:	8b 40 18             	mov    0x18(%eax),%eax
80104888:	89 c2                	mov    %eax,%edx
8010488a:	89 cb                	mov    %ecx,%ebx
8010488c:	b8 13 00 00 00       	mov    $0x13,%eax
80104891:	89 d7                	mov    %edx,%edi
80104893:	89 de                	mov    %ebx,%esi
80104895:	89 c1                	mov    %eax,%ecx
80104897:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104899:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010489c:	8b 40 18             	mov    0x18(%eax),%eax
8010489f:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
801048a6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801048ad:	eb 41                	jmp    801048f0 <fork+0x110>
    if(proc->ofile[i])
801048af:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048b8:	83 c2 08             	add    $0x8,%edx
801048bb:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048bf:	85 c0                	test   %eax,%eax
801048c1:	74 29                	je     801048ec <fork+0x10c>
      np->ofile[i] = filedup(proc->ofile[i]);
801048c3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048c9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801048cc:	83 c2 08             	add    $0x8,%edx
801048cf:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048d3:	83 ec 0c             	sub    $0xc,%esp
801048d6:	50                   	push   %eax
801048d7:	e8 51 c7 ff ff       	call   8010102d <filedup>
801048dc:	83 c4 10             	add    $0x10,%esp
801048df:	8b 55 e0             	mov    -0x20(%ebp),%edx
801048e2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801048e5:	83 c1 08             	add    $0x8,%ecx
801048e8:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  for(i = 0; i < NOFILE; i++)
801048ec:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801048f0:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
801048f4:	7e b9                	jle    801048af <fork+0xcf>
  np->cwd = idup(proc->cwd);
801048f6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048fc:	8b 40 68             	mov    0x68(%eax),%eax
801048ff:	83 ec 0c             	sub    $0xc,%esp
80104902:	50                   	push   %eax
80104903:	e8 45 d0 ff ff       	call   8010194d <idup>
80104908:	83 c4 10             	add    $0x10,%esp
8010490b:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010490e:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104911:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104917:	8d 50 6c             	lea    0x6c(%eax),%edx
8010491a:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010491d:	83 c0 6c             	add    $0x6c,%eax
80104920:	83 ec 04             	sub    $0x4,%esp
80104923:	6a 10                	push   $0x10
80104925:	52                   	push   %edx
80104926:	50                   	push   %eax
80104927:	e8 04 0c 00 00       	call   80105530 <safestrcpy>
8010492c:	83 c4 10             	add    $0x10,%esp
 
  pid = np->pid;
8010492f:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104932:	8b 40 10             	mov    0x10(%eax),%eax
80104935:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
80104938:	83 ec 0c             	sub    $0xc,%esp
8010493b:	68 80 19 11 80       	push   $0x80111980
80104940:	e8 85 07 00 00       	call   801050ca <acquire>
80104945:	83 c4 10             	add    $0x10,%esp
  np->state = RUNNABLE;
80104948:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010494b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  release(&ptable.lock);
80104952:	83 ec 0c             	sub    $0xc,%esp
80104955:	68 80 19 11 80       	push   $0x80111980
8010495a:	e8 d2 07 00 00       	call   80105131 <release>
8010495f:	83 c4 10             	add    $0x10,%esp
  
  return pid;
80104962:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104965:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104968:	5b                   	pop    %ebx
80104969:	5e                   	pop    %esi
8010496a:	5f                   	pop    %edi
8010496b:	5d                   	pop    %ebp
8010496c:	c3                   	ret    

8010496d <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
8010496d:	55                   	push   %ebp
8010496e:	89 e5                	mov    %esp,%ebp
80104970:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int fd;

  if(proc == initproc)
80104973:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
8010497a:	a1 b4 38 11 80       	mov    0x801138b4,%eax
8010497f:	39 c2                	cmp    %eax,%edx
80104981:	75 0d                	jne    80104990 <exit+0x23>
    panic("init exiting");
80104983:	83 ec 0c             	sub    $0xc,%esp
80104986:	68 6c 8b 10 80       	push   $0x80108b6c
8010498b:	e8 eb bb ff ff       	call   8010057b <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80104990:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104997:	eb 48                	jmp    801049e1 <exit+0x74>
    if(proc->ofile[fd]){
80104999:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010499f:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049a2:	83 c2 08             	add    $0x8,%edx
801049a5:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049a9:	85 c0                	test   %eax,%eax
801049ab:	74 30                	je     801049dd <exit+0x70>
      fileclose(proc->ofile[fd]);
801049ad:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049b3:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049b6:	83 c2 08             	add    $0x8,%edx
801049b9:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801049bd:	83 ec 0c             	sub    $0xc,%esp
801049c0:	50                   	push   %eax
801049c1:	e8 b8 c6 ff ff       	call   8010107e <fileclose>
801049c6:	83 c4 10             	add    $0x10,%esp
      proc->ofile[fd] = 0;
801049c9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
801049d2:	83 c2 08             	add    $0x8,%edx
801049d5:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801049dc:	00 
  for(fd = 0; fd < NOFILE; fd++){
801049dd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801049e1:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801049e5:	7e b2                	jle    80104999 <exit+0x2c>
    }
  }

  begin_op();
801049e7:	e8 8a eb ff ff       	call   80103576 <begin_op>
  iput(proc->cwd);
801049ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049f2:	8b 40 68             	mov    0x68(%eax),%eax
801049f5:	83 ec 0c             	sub    $0xc,%esp
801049f8:	50                   	push   %eax
801049f9:	e8 59 d1 ff ff       	call   80101b57 <iput>
801049fe:	83 c4 10             	add    $0x10,%esp
  end_op();
80104a01:	e8 fc eb ff ff       	call   80103602 <end_op>
  proc->cwd = 0;
80104a06:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a0c:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
80104a13:	83 ec 0c             	sub    $0xc,%esp
80104a16:	68 80 19 11 80       	push   $0x80111980
80104a1b:	e8 aa 06 00 00       	call   801050ca <acquire>
80104a20:	83 c4 10             	add    $0x10,%esp

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104a23:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a29:	8b 40 14             	mov    0x14(%eax),%eax
80104a2c:	83 ec 0c             	sub    $0xc,%esp
80104a2f:	50                   	push   %eax
80104a30:	e8 46 04 00 00       	call   80104e7b <wakeup1>
80104a35:	83 c4 10             	add    $0x10,%esp

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a38:	c7 45 f4 b4 19 11 80 	movl   $0x801119b4,-0xc(%ebp)
80104a3f:	eb 3c                	jmp    80104a7d <exit+0x110>
    if(p->parent == proc){
80104a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a44:	8b 50 14             	mov    0x14(%eax),%edx
80104a47:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a4d:	39 c2                	cmp    %eax,%edx
80104a4f:	75 28                	jne    80104a79 <exit+0x10c>
      p->parent = initproc;
80104a51:	8b 15 b4 38 11 80    	mov    0x801138b4,%edx
80104a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a5a:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a60:	8b 40 0c             	mov    0xc(%eax),%eax
80104a63:	83 f8 05             	cmp    $0x5,%eax
80104a66:	75 11                	jne    80104a79 <exit+0x10c>
        wakeup1(initproc);
80104a68:	a1 b4 38 11 80       	mov    0x801138b4,%eax
80104a6d:	83 ec 0c             	sub    $0xc,%esp
80104a70:	50                   	push   %eax
80104a71:	e8 05 04 00 00       	call   80104e7b <wakeup1>
80104a76:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a79:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104a7d:	81 7d f4 b4 38 11 80 	cmpl   $0x801138b4,-0xc(%ebp)
80104a84:	72 bb                	jb     80104a41 <exit+0xd4>
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104a86:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8c:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
80104a93:	e8 fa 01 00 00       	call   80104c92 <sched>
  panic("zombie exit");
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	68 79 8b 10 80       	push   $0x80108b79
80104aa0:	e8 d6 ba ff ff       	call   8010057b <panic>

80104aa5 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80104aa5:	55                   	push   %ebp
80104aa6:	89 e5                	mov    %esp,%ebp
80104aa8:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104aab:	83 ec 0c             	sub    $0xc,%esp
80104aae:	68 80 19 11 80       	push   $0x80111980
80104ab3:	e8 12 06 00 00       	call   801050ca <acquire>
80104ab8:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104abb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ac2:	c7 45 f4 b4 19 11 80 	movl   $0x801119b4,-0xc(%ebp)
80104ac9:	e9 a6 00 00 00       	jmp    80104b74 <wait+0xcf>
      if(p->parent != proc)
80104ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ad1:	8b 50 14             	mov    0x14(%eax),%edx
80104ad4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ada:	39 c2                	cmp    %eax,%edx
80104adc:	0f 85 8d 00 00 00    	jne    80104b6f <wait+0xca>
        continue;
      havekids = 1;
80104ae2:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104aec:	8b 40 0c             	mov    0xc(%eax),%eax
80104aef:	83 f8 05             	cmp    $0x5,%eax
80104af2:	75 7c                	jne    80104b70 <wait+0xcb>
        // Found one.
        pid = p->pid;
80104af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af7:	8b 40 10             	mov    0x10(%eax),%eax
80104afa:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b00:	8b 40 08             	mov    0x8(%eax),%eax
80104b03:	83 ec 0c             	sub    $0xc,%esp
80104b06:	50                   	push   %eax
80104b07:	e8 d0 e0 ff ff       	call   80102bdc <kfree>
80104b0c:	83 c4 10             	add    $0x10,%esp
        p->kstack = 0;
80104b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b12:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1c:	8b 40 04             	mov    0x4(%eax),%eax
80104b1f:	83 ec 0c             	sub    $0xc,%esp
80104b22:	50                   	push   %eax
80104b23:	e8 ef 39 00 00       	call   80108517 <freevm>
80104b28:	83 c4 10             	add    $0x10,%esp
        p->state = UNUSED;
80104b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b2e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b38:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b42:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4c:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b53:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
        release(&ptable.lock);
80104b5a:	83 ec 0c             	sub    $0xc,%esp
80104b5d:	68 80 19 11 80       	push   $0x80111980
80104b62:	e8 ca 05 00 00       	call   80105131 <release>
80104b67:	83 c4 10             	add    $0x10,%esp
        return pid;
80104b6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b6d:	eb 58                	jmp    80104bc7 <wait+0x122>
        continue;
80104b6f:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104b70:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104b74:	81 7d f4 b4 38 11 80 	cmpl   $0x801138b4,-0xc(%ebp)
80104b7b:	0f 82 4d ff ff ff    	jb     80104ace <wait+0x29>
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104b81:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104b85:	74 0d                	je     80104b94 <wait+0xef>
80104b87:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b8d:	8b 40 24             	mov    0x24(%eax),%eax
80104b90:	85 c0                	test   %eax,%eax
80104b92:	74 17                	je     80104bab <wait+0x106>
      release(&ptable.lock);
80104b94:	83 ec 0c             	sub    $0xc,%esp
80104b97:	68 80 19 11 80       	push   $0x80111980
80104b9c:	e8 90 05 00 00       	call   80105131 <release>
80104ba1:	83 c4 10             	add    $0x10,%esp
      return -1;
80104ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba9:	eb 1c                	jmp    80104bc7 <wait+0x122>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104bab:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bb1:	83 ec 08             	sub    $0x8,%esp
80104bb4:	68 80 19 11 80       	push   $0x80111980
80104bb9:	50                   	push   %eax
80104bba:	e8 10 02 00 00       	call   80104dcf <sleep>
80104bbf:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80104bc2:	e9 f4 fe ff ff       	jmp    80104abb <wait+0x16>
  }
}
80104bc7:	c9                   	leave  
80104bc8:	c3                   	ret    

80104bc9 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104bc9:	55                   	push   %ebp
80104bca:	89 e5                	mov    %esp,%ebp
80104bcc:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;
  int ran = 0; // CS550: to solve the 100%-CPU-utilization-when-idling problem
80104bcf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

  for(;;){
    // Enable interrupts on this processor.
    sti();
80104bd6:	e8 ba f8 ff ff       	call   80104495 <sti>

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80104bdb:	83 ec 0c             	sub    $0xc,%esp
80104bde:	68 80 19 11 80       	push   $0x80111980
80104be3:	e8 e2 04 00 00       	call   801050ca <acquire>
80104be8:	83 c4 10             	add    $0x10,%esp
    ran = 0;
80104beb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf2:	c7 45 f4 b4 19 11 80 	movl   $0x801119b4,-0xc(%ebp)
80104bf9:	eb 6a                	jmp    80104c65 <scheduler+0x9c>
      if(p->state != RUNNABLE)
80104bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bfe:	8b 40 0c             	mov    0xc(%eax),%eax
80104c01:	83 f8 03             	cmp    $0x3,%eax
80104c04:	75 5a                	jne    80104c60 <scheduler+0x97>
        continue;

      ran = 1;
80104c06:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      proc = p;
80104c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c10:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
      switchuvm(p);
80104c16:	83 ec 0c             	sub    $0xc,%esp
80104c19:	ff 75 f4             	push   -0xc(%ebp)
80104c1c:	e8 b1 34 00 00       	call   801080d2 <switchuvm>
80104c21:	83 c4 10             	add    $0x10,%esp
      p->state = RUNNING;
80104c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c27:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
      swtch(&cpu->scheduler, proc->context);
80104c2e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c34:	8b 40 1c             	mov    0x1c(%eax),%eax
80104c37:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104c3e:	83 c2 04             	add    $0x4,%edx
80104c41:	83 ec 08             	sub    $0x8,%esp
80104c44:	50                   	push   %eax
80104c45:	52                   	push   %edx
80104c46:	e8 57 09 00 00       	call   801055a2 <swtch>
80104c4b:	83 c4 10             	add    $0x10,%esp
      switchkvm();
80104c4e:	e8 62 34 00 00       	call   801080b5 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      proc = 0;
80104c53:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104c5a:	00 00 00 00 
80104c5e:	eb 01                	jmp    80104c61 <scheduler+0x98>
        continue;
80104c60:	90                   	nop
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104c61:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104c65:	81 7d f4 b4 38 11 80 	cmpl   $0x801138b4,-0xc(%ebp)
80104c6c:	72 8d                	jb     80104bfb <scheduler+0x32>
    }
    release(&ptable.lock);
80104c6e:	83 ec 0c             	sub    $0xc,%esp
80104c71:	68 80 19 11 80       	push   $0x80111980
80104c76:	e8 b6 04 00 00       	call   80105131 <release>
80104c7b:	83 c4 10             	add    $0x10,%esp

    if (ran == 0){
80104c7e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104c82:	0f 85 4e ff ff ff    	jne    80104bd6 <scheduler+0xd>
        halt();
80104c88:	e8 0f f8 ff ff       	call   8010449c <halt>
    sti();
80104c8d:	e9 44 ff ff ff       	jmp    80104bd6 <scheduler+0xd>

80104c92 <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104c92:	55                   	push   %ebp
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	83 ec 18             	sub    $0x18,%esp
  int intena;

  if(!holding(&ptable.lock))
80104c98:	83 ec 0c             	sub    $0xc,%esp
80104c9b:	68 80 19 11 80       	push   $0x80111980
80104ca0:	e8 59 05 00 00       	call   801051fe <holding>
80104ca5:	83 c4 10             	add    $0x10,%esp
80104ca8:	85 c0                	test   %eax,%eax
80104caa:	75 0d                	jne    80104cb9 <sched+0x27>
    panic("sched ptable.lock");
80104cac:	83 ec 0c             	sub    $0xc,%esp
80104caf:	68 85 8b 10 80       	push   $0x80108b85
80104cb4:	e8 c2 b8 ff ff       	call   8010057b <panic>
  if(cpu->ncli != 1)
80104cb9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104cbf:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104cc5:	83 f8 01             	cmp    $0x1,%eax
80104cc8:	74 0d                	je     80104cd7 <sched+0x45>
    panic("sched locks");
80104cca:	83 ec 0c             	sub    $0xc,%esp
80104ccd:	68 97 8b 10 80       	push   $0x80108b97
80104cd2:	e8 a4 b8 ff ff       	call   8010057b <panic>
  if(proc->state == RUNNING)
80104cd7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cdd:	8b 40 0c             	mov    0xc(%eax),%eax
80104ce0:	83 f8 04             	cmp    $0x4,%eax
80104ce3:	75 0d                	jne    80104cf2 <sched+0x60>
    panic("sched running");
80104ce5:	83 ec 0c             	sub    $0xc,%esp
80104ce8:	68 a3 8b 10 80       	push   $0x80108ba3
80104ced:	e8 89 b8 ff ff       	call   8010057b <panic>
  if(readeflags()&FL_IF)
80104cf2:	e8 8e f7 ff ff       	call   80104485 <readeflags>
80104cf7:	25 00 02 00 00       	and    $0x200,%eax
80104cfc:	85 c0                	test   %eax,%eax
80104cfe:	74 0d                	je     80104d0d <sched+0x7b>
    panic("sched interruptible");
80104d00:	83 ec 0c             	sub    $0xc,%esp
80104d03:	68 b1 8b 10 80       	push   $0x80108bb1
80104d08:	e8 6e b8 ff ff       	call   8010057b <panic>
  intena = cpu->intena;
80104d0d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d13:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104d19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104d1c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d22:	8b 40 04             	mov    0x4(%eax),%eax
80104d25:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104d2c:	83 c2 1c             	add    $0x1c,%edx
80104d2f:	83 ec 08             	sub    $0x8,%esp
80104d32:	50                   	push   %eax
80104d33:	52                   	push   %edx
80104d34:	e8 69 08 00 00       	call   801055a2 <swtch>
80104d39:	83 c4 10             	add    $0x10,%esp
  cpu->intena = intena;
80104d3c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104d42:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104d45:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104d4b:	90                   	nop
80104d4c:	c9                   	leave  
80104d4d:	c3                   	ret    

80104d4e <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104d4e:	55                   	push   %ebp
80104d4f:	89 e5                	mov    %esp,%ebp
80104d51:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104d54:	83 ec 0c             	sub    $0xc,%esp
80104d57:	68 80 19 11 80       	push   $0x80111980
80104d5c:	e8 69 03 00 00       	call   801050ca <acquire>
80104d61:	83 c4 10             	add    $0x10,%esp
  proc->state = RUNNABLE;
80104d64:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d6a:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80104d71:	e8 1c ff ff ff       	call   80104c92 <sched>
  release(&ptable.lock);
80104d76:	83 ec 0c             	sub    $0xc,%esp
80104d79:	68 80 19 11 80       	push   $0x80111980
80104d7e:	e8 ae 03 00 00       	call   80105131 <release>
80104d83:	83 c4 10             	add    $0x10,%esp
}
80104d86:	90                   	nop
80104d87:	c9                   	leave  
80104d88:	c3                   	ret    

80104d89 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104d89:	55                   	push   %ebp
80104d8a:	89 e5                	mov    %esp,%ebp
80104d8c:	83 ec 08             	sub    $0x8,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104d8f:	83 ec 0c             	sub    $0xc,%esp
80104d92:	68 80 19 11 80       	push   $0x80111980
80104d97:	e8 95 03 00 00       	call   80105131 <release>
80104d9c:	83 c4 10             	add    $0x10,%esp

  if (first) {
80104d9f:	a1 08 b0 10 80       	mov    0x8010b008,%eax
80104da4:	85 c0                	test   %eax,%eax
80104da6:	74 24                	je     80104dcc <forkret+0x43>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104da8:	c7 05 08 b0 10 80 00 	movl   $0x0,0x8010b008
80104daf:	00 00 00 
    iinit(ROOTDEV);
80104db2:	83 ec 0c             	sub    $0xc,%esp
80104db5:	6a 01                	push   $0x1
80104db7:	e8 9f c8 ff ff       	call   8010165b <iinit>
80104dbc:	83 c4 10             	add    $0x10,%esp
    initlog(ROOTDEV);
80104dbf:	83 ec 0c             	sub    $0xc,%esp
80104dc2:	6a 01                	push   $0x1
80104dc4:	e8 8e e5 ff ff       	call   80103357 <initlog>
80104dc9:	83 c4 10             	add    $0x10,%esp
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104dcc:	90                   	nop
80104dcd:	c9                   	leave  
80104dce:	c3                   	ret    

80104dcf <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104dcf:	55                   	push   %ebp
80104dd0:	89 e5                	mov    %esp,%ebp
80104dd2:	83 ec 08             	sub    $0x8,%esp
  if(proc == 0)
80104dd5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	75 0d                	jne    80104dec <sleep+0x1d>
    panic("sleep");
80104ddf:	83 ec 0c             	sub    $0xc,%esp
80104de2:	68 c5 8b 10 80       	push   $0x80108bc5
80104de7:	e8 8f b7 ff ff       	call   8010057b <panic>

  if(lk == 0)
80104dec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104df0:	75 0d                	jne    80104dff <sleep+0x30>
    panic("sleep without lk");
80104df2:	83 ec 0c             	sub    $0xc,%esp
80104df5:	68 cb 8b 10 80       	push   $0x80108bcb
80104dfa:	e8 7c b7 ff ff       	call   8010057b <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104dff:	81 7d 0c 80 19 11 80 	cmpl   $0x80111980,0xc(%ebp)
80104e06:	74 1e                	je     80104e26 <sleep+0x57>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104e08:	83 ec 0c             	sub    $0xc,%esp
80104e0b:	68 80 19 11 80       	push   $0x80111980
80104e10:	e8 b5 02 00 00       	call   801050ca <acquire>
80104e15:	83 c4 10             	add    $0x10,%esp
    release(lk);
80104e18:	83 ec 0c             	sub    $0xc,%esp
80104e1b:	ff 75 0c             	push   0xc(%ebp)
80104e1e:	e8 0e 03 00 00       	call   80105131 <release>
80104e23:	83 c4 10             	add    $0x10,%esp
  }

  // Go to sleep.
  proc->chan = chan;
80104e26:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e2c:	8b 55 08             	mov    0x8(%ebp),%edx
80104e2f:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104e32:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e38:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104e3f:	e8 4e fe ff ff       	call   80104c92 <sched>

  // Tidy up.
  proc->chan = 0;
80104e44:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e4a:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104e51:	81 7d 0c 80 19 11 80 	cmpl   $0x80111980,0xc(%ebp)
80104e58:	74 1e                	je     80104e78 <sleep+0xa9>
    release(&ptable.lock);
80104e5a:	83 ec 0c             	sub    $0xc,%esp
80104e5d:	68 80 19 11 80       	push   $0x80111980
80104e62:	e8 ca 02 00 00       	call   80105131 <release>
80104e67:	83 c4 10             	add    $0x10,%esp
    acquire(lk);
80104e6a:	83 ec 0c             	sub    $0xc,%esp
80104e6d:	ff 75 0c             	push   0xc(%ebp)
80104e70:	e8 55 02 00 00       	call   801050ca <acquire>
80104e75:	83 c4 10             	add    $0x10,%esp
  }
}
80104e78:	90                   	nop
80104e79:	c9                   	leave  
80104e7a:	c3                   	ret    

80104e7b <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104e7b:	55                   	push   %ebp
80104e7c:	89 e5                	mov    %esp,%ebp
80104e7e:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104e81:	c7 45 fc b4 19 11 80 	movl   $0x801119b4,-0x4(%ebp)
80104e88:	eb 24                	jmp    80104eae <wakeup1+0x33>
    if(p->state == SLEEPING && p->chan == chan)
80104e8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e8d:	8b 40 0c             	mov    0xc(%eax),%eax
80104e90:	83 f8 02             	cmp    $0x2,%eax
80104e93:	75 15                	jne    80104eaa <wakeup1+0x2f>
80104e95:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104e98:	8b 40 20             	mov    0x20(%eax),%eax
80104e9b:	39 45 08             	cmp    %eax,0x8(%ebp)
80104e9e:	75 0a                	jne    80104eaa <wakeup1+0x2f>
      p->state = RUNNABLE;
80104ea0:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ea3:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104eaa:	83 45 fc 7c          	addl   $0x7c,-0x4(%ebp)
80104eae:	81 7d fc b4 38 11 80 	cmpl   $0x801138b4,-0x4(%ebp)
80104eb5:	72 d3                	jb     80104e8a <wakeup1+0xf>
}
80104eb7:	90                   	nop
80104eb8:	90                   	nop
80104eb9:	c9                   	leave  
80104eba:	c3                   	ret    

80104ebb <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104ebb:	55                   	push   %ebp
80104ebc:	89 e5                	mov    %esp,%ebp
80104ebe:	83 ec 08             	sub    $0x8,%esp
  acquire(&ptable.lock);
80104ec1:	83 ec 0c             	sub    $0xc,%esp
80104ec4:	68 80 19 11 80       	push   $0x80111980
80104ec9:	e8 fc 01 00 00       	call   801050ca <acquire>
80104ece:	83 c4 10             	add    $0x10,%esp
  wakeup1(chan);
80104ed1:	83 ec 0c             	sub    $0xc,%esp
80104ed4:	ff 75 08             	push   0x8(%ebp)
80104ed7:	e8 9f ff ff ff       	call   80104e7b <wakeup1>
80104edc:	83 c4 10             	add    $0x10,%esp
  release(&ptable.lock);
80104edf:	83 ec 0c             	sub    $0xc,%esp
80104ee2:	68 80 19 11 80       	push   $0x80111980
80104ee7:	e8 45 02 00 00       	call   80105131 <release>
80104eec:	83 c4 10             	add    $0x10,%esp
}
80104eef:	90                   	nop
80104ef0:	c9                   	leave  
80104ef1:	c3                   	ret    

80104ef2 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104ef2:	55                   	push   %ebp
80104ef3:	89 e5                	mov    %esp,%ebp
80104ef5:	83 ec 18             	sub    $0x18,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104ef8:	83 ec 0c             	sub    $0xc,%esp
80104efb:	68 80 19 11 80       	push   $0x80111980
80104f00:	e8 c5 01 00 00       	call   801050ca <acquire>
80104f05:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f08:	c7 45 f4 b4 19 11 80 	movl   $0x801119b4,-0xc(%ebp)
80104f0f:	eb 45                	jmp    80104f56 <kill+0x64>
    if(p->pid == pid){
80104f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f14:	8b 40 10             	mov    0x10(%eax),%eax
80104f17:	39 45 08             	cmp    %eax,0x8(%ebp)
80104f1a:	75 36                	jne    80104f52 <kill+0x60>
      p->killed = 1;
80104f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f1f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f29:	8b 40 0c             	mov    0xc(%eax),%eax
80104f2c:	83 f8 02             	cmp    $0x2,%eax
80104f2f:	75 0a                	jne    80104f3b <kill+0x49>
        p->state = RUNNABLE;
80104f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f34:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104f3b:	83 ec 0c             	sub    $0xc,%esp
80104f3e:	68 80 19 11 80       	push   $0x80111980
80104f43:	e8 e9 01 00 00       	call   80105131 <release>
80104f48:	83 c4 10             	add    $0x10,%esp
      return 0;
80104f4b:	b8 00 00 00 00       	mov    $0x0,%eax
80104f50:	eb 22                	jmp    80104f74 <kill+0x82>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f52:	83 45 f4 7c          	addl   $0x7c,-0xc(%ebp)
80104f56:	81 7d f4 b4 38 11 80 	cmpl   $0x801138b4,-0xc(%ebp)
80104f5d:	72 b2                	jb     80104f11 <kill+0x1f>
    }
  }
  release(&ptable.lock);
80104f5f:	83 ec 0c             	sub    $0xc,%esp
80104f62:	68 80 19 11 80       	push   $0x80111980
80104f67:	e8 c5 01 00 00       	call   80105131 <release>
80104f6c:	83 c4 10             	add    $0x10,%esp
  return -1;
80104f6f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f74:	c9                   	leave  
80104f75:	c3                   	ret    

80104f76 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104f76:	55                   	push   %ebp
80104f77:	89 e5                	mov    %esp,%ebp
80104f79:	83 ec 48             	sub    $0x48,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104f7c:	c7 45 f0 b4 19 11 80 	movl   $0x801119b4,-0x10(%ebp)
80104f83:	e9 d7 00 00 00       	jmp    8010505f <procdump+0xe9>
    if(p->state == UNUSED)
80104f88:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f8b:	8b 40 0c             	mov    0xc(%eax),%eax
80104f8e:	85 c0                	test   %eax,%eax
80104f90:	0f 84 c4 00 00 00    	je     8010505a <procdump+0xe4>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104f96:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104f99:	8b 40 0c             	mov    0xc(%eax),%eax
80104f9c:	83 f8 05             	cmp    $0x5,%eax
80104f9f:	77 23                	ja     80104fc4 <procdump+0x4e>
80104fa1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fa4:	8b 40 0c             	mov    0xc(%eax),%eax
80104fa7:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104fae:	85 c0                	test   %eax,%eax
80104fb0:	74 12                	je     80104fc4 <procdump+0x4e>
      state = states[p->state];
80104fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fb5:	8b 40 0c             	mov    0xc(%eax),%eax
80104fb8:	8b 04 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%eax
80104fbf:	89 45 ec             	mov    %eax,-0x14(%ebp)
80104fc2:	eb 07                	jmp    80104fcb <procdump+0x55>
    else
      state = "???";
80104fc4:	c7 45 ec dc 8b 10 80 	movl   $0x80108bdc,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80104fcb:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fce:	8d 50 6c             	lea    0x6c(%eax),%edx
80104fd1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fd4:	8b 40 10             	mov    0x10(%eax),%eax
80104fd7:	52                   	push   %edx
80104fd8:	ff 75 ec             	push   -0x14(%ebp)
80104fdb:	50                   	push   %eax
80104fdc:	68 e0 8b 10 80       	push   $0x80108be0
80104fe1:	e8 e0 b3 ff ff       	call   801003c6 <cprintf>
80104fe6:	83 c4 10             	add    $0x10,%esp
    if(p->state == SLEEPING){
80104fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104fec:	8b 40 0c             	mov    0xc(%eax),%eax
80104fef:	83 f8 02             	cmp    $0x2,%eax
80104ff2:	75 54                	jne    80105048 <procdump+0xd2>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104ff4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ff7:	8b 40 1c             	mov    0x1c(%eax),%eax
80104ffa:	8b 40 0c             	mov    0xc(%eax),%eax
80104ffd:	83 c0 08             	add    $0x8,%eax
80105000:	89 c2                	mov    %eax,%edx
80105002:	83 ec 08             	sub    $0x8,%esp
80105005:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105008:	50                   	push   %eax
80105009:	52                   	push   %edx
8010500a:	e8 74 01 00 00       	call   80105183 <getcallerpcs>
8010500f:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105012:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105019:	eb 1c                	jmp    80105037 <procdump+0xc1>
        cprintf(" %p", pc[i]);
8010501b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010501e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105022:	83 ec 08             	sub    $0x8,%esp
80105025:	50                   	push   %eax
80105026:	68 e9 8b 10 80       	push   $0x80108be9
8010502b:	e8 96 b3 ff ff       	call   801003c6 <cprintf>
80105030:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80105033:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105037:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
8010503b:	7f 0b                	jg     80105048 <procdump+0xd2>
8010503d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105040:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105044:	85 c0                	test   %eax,%eax
80105046:	75 d3                	jne    8010501b <procdump+0xa5>
    }
    cprintf("\n");
80105048:	83 ec 0c             	sub    $0xc,%esp
8010504b:	68 ed 8b 10 80       	push   $0x80108bed
80105050:	e8 71 b3 ff ff       	call   801003c6 <cprintf>
80105055:	83 c4 10             	add    $0x10,%esp
80105058:	eb 01                	jmp    8010505b <procdump+0xe5>
      continue;
8010505a:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010505b:	83 45 f0 7c          	addl   $0x7c,-0x10(%ebp)
8010505f:	81 7d f0 b4 38 11 80 	cmpl   $0x801138b4,-0x10(%ebp)
80105066:	0f 82 1c ff ff ff    	jb     80104f88 <procdump+0x12>
  }
}
8010506c:	90                   	nop
8010506d:	90                   	nop
8010506e:	c9                   	leave  
8010506f:	c3                   	ret    

80105070 <readeflags>:
{
80105070:	55                   	push   %ebp
80105071:	89 e5                	mov    %esp,%ebp
80105073:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80105076:	9c                   	pushf  
80105077:	58                   	pop    %eax
80105078:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010507b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010507e:	c9                   	leave  
8010507f:	c3                   	ret    

80105080 <cli>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
80105083:	fa                   	cli    
}
80105084:	90                   	nop
80105085:	5d                   	pop    %ebp
80105086:	c3                   	ret    

80105087 <sti>:
{
80105087:	55                   	push   %ebp
80105088:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
8010508a:	fb                   	sti    
}
8010508b:	90                   	nop
8010508c:	5d                   	pop    %ebp
8010508d:	c3                   	ret    

8010508e <xchg>:
{
8010508e:	55                   	push   %ebp
8010508f:	89 e5                	mov    %esp,%ebp
80105091:	83 ec 10             	sub    $0x10,%esp
  asm volatile("lock; xchgl %0, %1" :
80105094:	8b 55 08             	mov    0x8(%ebp),%edx
80105097:	8b 45 0c             	mov    0xc(%ebp),%eax
8010509a:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010509d:	f0 87 02             	lock xchg %eax,(%edx)
801050a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return result;
801050a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801050a6:	c9                   	leave  
801050a7:	c3                   	ret    

801050a8 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801050a8:	55                   	push   %ebp
801050a9:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801050ab:	8b 45 08             	mov    0x8(%ebp),%eax
801050ae:	8b 55 0c             	mov    0xc(%ebp),%edx
801050b1:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801050b4:	8b 45 08             	mov    0x8(%ebp),%eax
801050b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801050bd:	8b 45 08             	mov    0x8(%ebp),%eax
801050c0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801050c7:	90                   	nop
801050c8:	5d                   	pop    %ebp
801050c9:	c3                   	ret    

801050ca <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801050ca:	55                   	push   %ebp
801050cb:	89 e5                	mov    %esp,%ebp
801050cd:	83 ec 08             	sub    $0x8,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801050d0:	e8 53 01 00 00       	call   80105228 <pushcli>
  if(holding(lk))
801050d5:	8b 45 08             	mov    0x8(%ebp),%eax
801050d8:	83 ec 0c             	sub    $0xc,%esp
801050db:	50                   	push   %eax
801050dc:	e8 1d 01 00 00       	call   801051fe <holding>
801050e1:	83 c4 10             	add    $0x10,%esp
801050e4:	85 c0                	test   %eax,%eax
801050e6:	74 0d                	je     801050f5 <acquire+0x2b>
    panic("acquire");
801050e8:	83 ec 0c             	sub    $0xc,%esp
801050eb:	68 19 8c 10 80       	push   $0x80108c19
801050f0:	e8 86 b4 ff ff       	call   8010057b <panic>

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
801050f5:	90                   	nop
801050f6:	8b 45 08             	mov    0x8(%ebp),%eax
801050f9:	83 ec 08             	sub    $0x8,%esp
801050fc:	6a 01                	push   $0x1
801050fe:	50                   	push   %eax
801050ff:	e8 8a ff ff ff       	call   8010508e <xchg>
80105104:	83 c4 10             	add    $0x10,%esp
80105107:	85 c0                	test   %eax,%eax
80105109:	75 eb                	jne    801050f6 <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
8010510b:	8b 45 08             	mov    0x8(%ebp),%eax
8010510e:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105115:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
80105118:	8b 45 08             	mov    0x8(%ebp),%eax
8010511b:	83 c0 0c             	add    $0xc,%eax
8010511e:	83 ec 08             	sub    $0x8,%esp
80105121:	50                   	push   %eax
80105122:	8d 45 08             	lea    0x8(%ebp),%eax
80105125:	50                   	push   %eax
80105126:	e8 58 00 00 00       	call   80105183 <getcallerpcs>
8010512b:	83 c4 10             	add    $0x10,%esp
}
8010512e:	90                   	nop
8010512f:	c9                   	leave  
80105130:	c3                   	ret    

80105131 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105131:	55                   	push   %ebp
80105132:	89 e5                	mov    %esp,%ebp
80105134:	83 ec 08             	sub    $0x8,%esp
  if(!holding(lk))
80105137:	83 ec 0c             	sub    $0xc,%esp
8010513a:	ff 75 08             	push   0x8(%ebp)
8010513d:	e8 bc 00 00 00       	call   801051fe <holding>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	85 c0                	test   %eax,%eax
80105147:	75 0d                	jne    80105156 <release+0x25>
    panic("release");
80105149:	83 ec 0c             	sub    $0xc,%esp
8010514c:	68 21 8c 10 80       	push   $0x80108c21
80105151:	e8 25 b4 ff ff       	call   8010057b <panic>

  lk->pcs[0] = 0;
80105156:	8b 45 08             	mov    0x8(%ebp),%eax
80105159:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105160:	8b 45 08             	mov    0x8(%ebp),%eax
80105163:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010516a:	8b 45 08             	mov    0x8(%ebp),%eax
8010516d:	83 ec 08             	sub    $0x8,%esp
80105170:	6a 00                	push   $0x0
80105172:	50                   	push   %eax
80105173:	e8 16 ff ff ff       	call   8010508e <xchg>
80105178:	83 c4 10             	add    $0x10,%esp

  popcli();
8010517b:	e8 ec 00 00 00       	call   8010526c <popcli>
}
80105180:	90                   	nop
80105181:	c9                   	leave  
80105182:	c3                   	ret    

80105183 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80105183:	55                   	push   %ebp
80105184:	89 e5                	mov    %esp,%ebp
80105186:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
80105189:	8b 45 08             	mov    0x8(%ebp),%eax
8010518c:	83 e8 08             	sub    $0x8,%eax
8010518f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
80105192:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
80105199:	eb 38                	jmp    801051d3 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
8010519b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
8010519f:	74 53                	je     801051f4 <getcallerpcs+0x71>
801051a1:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801051a8:	76 4a                	jbe    801051f4 <getcallerpcs+0x71>
801051aa:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801051ae:	74 44                	je     801051f4 <getcallerpcs+0x71>
      break;
    pcs[i] = ebp[1];     // saved %eip
801051b0:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051b3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801051bd:	01 c2                	add    %eax,%edx
801051bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051c2:	8b 40 04             	mov    0x4(%eax),%eax
801051c5:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801051c7:	8b 45 fc             	mov    -0x4(%ebp),%eax
801051ca:	8b 00                	mov    (%eax),%eax
801051cc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801051cf:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051d3:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051d7:	7e c2                	jle    8010519b <getcallerpcs+0x18>
  }
  for(; i < 10; i++)
801051d9:	eb 19                	jmp    801051f4 <getcallerpcs+0x71>
    pcs[i] = 0;
801051db:	8b 45 f8             	mov    -0x8(%ebp),%eax
801051de:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801051e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801051e8:	01 d0                	add    %edx,%eax
801051ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
801051f0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801051f4:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801051f8:	7e e1                	jle    801051db <getcallerpcs+0x58>
}
801051fa:	90                   	nop
801051fb:	90                   	nop
801051fc:	c9                   	leave  
801051fd:	c3                   	ret    

801051fe <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801051fe:	55                   	push   %ebp
801051ff:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105201:	8b 45 08             	mov    0x8(%ebp),%eax
80105204:	8b 00                	mov    (%eax),%eax
80105206:	85 c0                	test   %eax,%eax
80105208:	74 17                	je     80105221 <holding+0x23>
8010520a:	8b 45 08             	mov    0x8(%ebp),%eax
8010520d:	8b 50 08             	mov    0x8(%eax),%edx
80105210:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105216:	39 c2                	cmp    %eax,%edx
80105218:	75 07                	jne    80105221 <holding+0x23>
8010521a:	b8 01 00 00 00       	mov    $0x1,%eax
8010521f:	eb 05                	jmp    80105226 <holding+0x28>
80105221:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105226:	5d                   	pop    %ebp
80105227:	c3                   	ret    

80105228 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105228:	55                   	push   %ebp
80105229:	89 e5                	mov    %esp,%ebp
8010522b:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010522e:	e8 3d fe ff ff       	call   80105070 <readeflags>
80105233:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105236:	e8 45 fe ff ff       	call   80105080 <cli>
  if(cpu->ncli++ == 0)
8010523b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105241:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105247:	8d 4a 01             	lea    0x1(%edx),%ecx
8010524a:	89 88 ac 00 00 00    	mov    %ecx,0xac(%eax)
80105250:	85 d2                	test   %edx,%edx
80105252:	75 15                	jne    80105269 <pushcli+0x41>
    cpu->intena = eflags & FL_IF;
80105254:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010525a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010525d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105263:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105269:	90                   	nop
8010526a:	c9                   	leave  
8010526b:	c3                   	ret    

8010526c <popcli>:

void
popcli(void)
{
8010526c:	55                   	push   %ebp
8010526d:	89 e5                	mov    %esp,%ebp
8010526f:	83 ec 08             	sub    $0x8,%esp
  if(readeflags()&FL_IF)
80105272:	e8 f9 fd ff ff       	call   80105070 <readeflags>
80105277:	25 00 02 00 00       	and    $0x200,%eax
8010527c:	85 c0                	test   %eax,%eax
8010527e:	74 0d                	je     8010528d <popcli+0x21>
    panic("popcli - interruptible");
80105280:	83 ec 0c             	sub    $0xc,%esp
80105283:	68 29 8c 10 80       	push   $0x80108c29
80105288:	e8 ee b2 ff ff       	call   8010057b <panic>
  if(--cpu->ncli < 0)
8010528d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105293:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
80105299:	83 ea 01             	sub    $0x1,%edx
8010529c:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801052a2:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801052a8:	85 c0                	test   %eax,%eax
801052aa:	79 0d                	jns    801052b9 <popcli+0x4d>
    panic("popcli");
801052ac:	83 ec 0c             	sub    $0xc,%esp
801052af:	68 40 8c 10 80       	push   $0x80108c40
801052b4:	e8 c2 b2 ff ff       	call   8010057b <panic>
  if(cpu->ncli == 0 && cpu->intena)
801052b9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052bf:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801052c5:	85 c0                	test   %eax,%eax
801052c7:	75 15                	jne    801052de <popcli+0x72>
801052c9:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801052cf:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801052d5:	85 c0                	test   %eax,%eax
801052d7:	74 05                	je     801052de <popcli+0x72>
    sti();
801052d9:	e8 a9 fd ff ff       	call   80105087 <sti>
}
801052de:	90                   	nop
801052df:	c9                   	leave  
801052e0:	c3                   	ret    

801052e1 <stosb>:
{
801052e1:	55                   	push   %ebp
801052e2:	89 e5                	mov    %esp,%ebp
801052e4:	57                   	push   %edi
801052e5:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
801052e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
801052e9:	8b 55 10             	mov    0x10(%ebp),%edx
801052ec:	8b 45 0c             	mov    0xc(%ebp),%eax
801052ef:	89 cb                	mov    %ecx,%ebx
801052f1:	89 df                	mov    %ebx,%edi
801052f3:	89 d1                	mov    %edx,%ecx
801052f5:	fc                   	cld    
801052f6:	f3 aa                	rep stos %al,%es:(%edi)
801052f8:	89 ca                	mov    %ecx,%edx
801052fa:	89 fb                	mov    %edi,%ebx
801052fc:	89 5d 08             	mov    %ebx,0x8(%ebp)
801052ff:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105302:	90                   	nop
80105303:	5b                   	pop    %ebx
80105304:	5f                   	pop    %edi
80105305:	5d                   	pop    %ebp
80105306:	c3                   	ret    

80105307 <stosl>:
{
80105307:	55                   	push   %ebp
80105308:	89 e5                	mov    %esp,%ebp
8010530a:	57                   	push   %edi
8010530b:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
8010530c:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010530f:	8b 55 10             	mov    0x10(%ebp),%edx
80105312:	8b 45 0c             	mov    0xc(%ebp),%eax
80105315:	89 cb                	mov    %ecx,%ebx
80105317:	89 df                	mov    %ebx,%edi
80105319:	89 d1                	mov    %edx,%ecx
8010531b:	fc                   	cld    
8010531c:	f3 ab                	rep stos %eax,%es:(%edi)
8010531e:	89 ca                	mov    %ecx,%edx
80105320:	89 fb                	mov    %edi,%ebx
80105322:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105325:	89 55 10             	mov    %edx,0x10(%ebp)
}
80105328:	90                   	nop
80105329:	5b                   	pop    %ebx
8010532a:	5f                   	pop    %edi
8010532b:	5d                   	pop    %ebp
8010532c:	c3                   	ret    

8010532d <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
8010532d:	55                   	push   %ebp
8010532e:	89 e5                	mov    %esp,%ebp
  if ((int)dst%4 == 0 && n%4 == 0){
80105330:	8b 45 08             	mov    0x8(%ebp),%eax
80105333:	83 e0 03             	and    $0x3,%eax
80105336:	85 c0                	test   %eax,%eax
80105338:	75 43                	jne    8010537d <memset+0x50>
8010533a:	8b 45 10             	mov    0x10(%ebp),%eax
8010533d:	83 e0 03             	and    $0x3,%eax
80105340:	85 c0                	test   %eax,%eax
80105342:	75 39                	jne    8010537d <memset+0x50>
    c &= 0xFF;
80105344:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010534b:	8b 45 10             	mov    0x10(%ebp),%eax
8010534e:	c1 e8 02             	shr    $0x2,%eax
80105351:	89 c2                	mov    %eax,%edx
80105353:	8b 45 0c             	mov    0xc(%ebp),%eax
80105356:	c1 e0 18             	shl    $0x18,%eax
80105359:	89 c1                	mov    %eax,%ecx
8010535b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010535e:	c1 e0 10             	shl    $0x10,%eax
80105361:	09 c1                	or     %eax,%ecx
80105363:	8b 45 0c             	mov    0xc(%ebp),%eax
80105366:	c1 e0 08             	shl    $0x8,%eax
80105369:	09 c8                	or     %ecx,%eax
8010536b:	0b 45 0c             	or     0xc(%ebp),%eax
8010536e:	52                   	push   %edx
8010536f:	50                   	push   %eax
80105370:	ff 75 08             	push   0x8(%ebp)
80105373:	e8 8f ff ff ff       	call   80105307 <stosl>
80105378:	83 c4 0c             	add    $0xc,%esp
8010537b:	eb 12                	jmp    8010538f <memset+0x62>
  } else
    stosb(dst, c, n);
8010537d:	8b 45 10             	mov    0x10(%ebp),%eax
80105380:	50                   	push   %eax
80105381:	ff 75 0c             	push   0xc(%ebp)
80105384:	ff 75 08             	push   0x8(%ebp)
80105387:	e8 55 ff ff ff       	call   801052e1 <stosb>
8010538c:	83 c4 0c             	add    $0xc,%esp
  return dst;
8010538f:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105392:	c9                   	leave  
80105393:	c3                   	ret    

80105394 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80105394:	55                   	push   %ebp
80105395:	89 e5                	mov    %esp,%ebp
80105397:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
8010539a:	8b 45 08             	mov    0x8(%ebp),%eax
8010539d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801053a0:	8b 45 0c             	mov    0xc(%ebp),%eax
801053a3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801053a6:	eb 30                	jmp    801053d8 <memcmp+0x44>
    if(*s1 != *s2)
801053a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053ab:	0f b6 10             	movzbl (%eax),%edx
801053ae:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053b1:	0f b6 00             	movzbl (%eax),%eax
801053b4:	38 c2                	cmp    %al,%dl
801053b6:	74 18                	je     801053d0 <memcmp+0x3c>
      return *s1 - *s2;
801053b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801053bb:	0f b6 00             	movzbl (%eax),%eax
801053be:	0f b6 d0             	movzbl %al,%edx
801053c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801053c4:	0f b6 00             	movzbl (%eax),%eax
801053c7:	0f b6 c8             	movzbl %al,%ecx
801053ca:	89 d0                	mov    %edx,%eax
801053cc:	29 c8                	sub    %ecx,%eax
801053ce:	eb 1a                	jmp    801053ea <memcmp+0x56>
    s1++, s2++;
801053d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801053d4:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  while(n-- > 0){
801053d8:	8b 45 10             	mov    0x10(%ebp),%eax
801053db:	8d 50 ff             	lea    -0x1(%eax),%edx
801053de:	89 55 10             	mov    %edx,0x10(%ebp)
801053e1:	85 c0                	test   %eax,%eax
801053e3:	75 c3                	jne    801053a8 <memcmp+0x14>
  }

  return 0;
801053e5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801053ea:	c9                   	leave  
801053eb:	c3                   	ret    

801053ec <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
801053ec:	55                   	push   %ebp
801053ed:	89 e5                	mov    %esp,%ebp
801053ef:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
801053f2:	8b 45 0c             	mov    0xc(%ebp),%eax
801053f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
801053f8:	8b 45 08             	mov    0x8(%ebp),%eax
801053fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
801053fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105401:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105404:	73 54                	jae    8010545a <memmove+0x6e>
80105406:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105409:	8b 45 10             	mov    0x10(%ebp),%eax
8010540c:	01 d0                	add    %edx,%eax
8010540e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
80105411:	73 47                	jae    8010545a <memmove+0x6e>
    s += n;
80105413:	8b 45 10             	mov    0x10(%ebp),%eax
80105416:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105419:	8b 45 10             	mov    0x10(%ebp),%eax
8010541c:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
8010541f:	eb 13                	jmp    80105434 <memmove+0x48>
      *--d = *--s;
80105421:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105425:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
80105429:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010542c:	0f b6 10             	movzbl (%eax),%edx
8010542f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105432:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
80105434:	8b 45 10             	mov    0x10(%ebp),%eax
80105437:	8d 50 ff             	lea    -0x1(%eax),%edx
8010543a:	89 55 10             	mov    %edx,0x10(%ebp)
8010543d:	85 c0                	test   %eax,%eax
8010543f:	75 e0                	jne    80105421 <memmove+0x35>
  if(s < d && s + n > d){
80105441:	eb 24                	jmp    80105467 <memmove+0x7b>
  } else
    while(n-- > 0)
      *d++ = *s++;
80105443:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105446:	8d 42 01             	lea    0x1(%edx),%eax
80105449:	89 45 fc             	mov    %eax,-0x4(%ebp)
8010544c:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010544f:	8d 48 01             	lea    0x1(%eax),%ecx
80105452:	89 4d f8             	mov    %ecx,-0x8(%ebp)
80105455:	0f b6 12             	movzbl (%edx),%edx
80105458:	88 10                	mov    %dl,(%eax)
    while(n-- > 0)
8010545a:	8b 45 10             	mov    0x10(%ebp),%eax
8010545d:	8d 50 ff             	lea    -0x1(%eax),%edx
80105460:	89 55 10             	mov    %edx,0x10(%ebp)
80105463:	85 c0                	test   %eax,%eax
80105465:	75 dc                	jne    80105443 <memmove+0x57>

  return dst;
80105467:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010546a:	c9                   	leave  
8010546b:	c3                   	ret    

8010546c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
8010546c:	55                   	push   %ebp
8010546d:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
8010546f:	ff 75 10             	push   0x10(%ebp)
80105472:	ff 75 0c             	push   0xc(%ebp)
80105475:	ff 75 08             	push   0x8(%ebp)
80105478:	e8 6f ff ff ff       	call   801053ec <memmove>
8010547d:	83 c4 0c             	add    $0xc,%esp
}
80105480:	c9                   	leave  
80105481:	c3                   	ret    

80105482 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80105482:	55                   	push   %ebp
80105483:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
80105485:	eb 0c                	jmp    80105493 <strncmp+0x11>
    n--, p++, q++;
80105487:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010548b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
8010548f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(n > 0 && *p && *p == *q)
80105493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105497:	74 1a                	je     801054b3 <strncmp+0x31>
80105499:	8b 45 08             	mov    0x8(%ebp),%eax
8010549c:	0f b6 00             	movzbl (%eax),%eax
8010549f:	84 c0                	test   %al,%al
801054a1:	74 10                	je     801054b3 <strncmp+0x31>
801054a3:	8b 45 08             	mov    0x8(%ebp),%eax
801054a6:	0f b6 10             	movzbl (%eax),%edx
801054a9:	8b 45 0c             	mov    0xc(%ebp),%eax
801054ac:	0f b6 00             	movzbl (%eax),%eax
801054af:	38 c2                	cmp    %al,%dl
801054b1:	74 d4                	je     80105487 <strncmp+0x5>
  if(n == 0)
801054b3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801054b7:	75 07                	jne    801054c0 <strncmp+0x3e>
    return 0;
801054b9:	b8 00 00 00 00       	mov    $0x0,%eax
801054be:	eb 16                	jmp    801054d6 <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801054c0:	8b 45 08             	mov    0x8(%ebp),%eax
801054c3:	0f b6 00             	movzbl (%eax),%eax
801054c6:	0f b6 d0             	movzbl %al,%edx
801054c9:	8b 45 0c             	mov    0xc(%ebp),%eax
801054cc:	0f b6 00             	movzbl (%eax),%eax
801054cf:	0f b6 c8             	movzbl %al,%ecx
801054d2:	89 d0                	mov    %edx,%eax
801054d4:	29 c8                	sub    %ecx,%eax
}
801054d6:	5d                   	pop    %ebp
801054d7:	c3                   	ret    

801054d8 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801054d8:	55                   	push   %ebp
801054d9:	89 e5                	mov    %esp,%ebp
801054db:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
801054de:	8b 45 08             	mov    0x8(%ebp),%eax
801054e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
801054e4:	90                   	nop
801054e5:	8b 45 10             	mov    0x10(%ebp),%eax
801054e8:	8d 50 ff             	lea    -0x1(%eax),%edx
801054eb:	89 55 10             	mov    %edx,0x10(%ebp)
801054ee:	85 c0                	test   %eax,%eax
801054f0:	7e 2c                	jle    8010551e <strncpy+0x46>
801054f2:	8b 55 0c             	mov    0xc(%ebp),%edx
801054f5:	8d 42 01             	lea    0x1(%edx),%eax
801054f8:	89 45 0c             	mov    %eax,0xc(%ebp)
801054fb:	8b 45 08             	mov    0x8(%ebp),%eax
801054fe:	8d 48 01             	lea    0x1(%eax),%ecx
80105501:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105504:	0f b6 12             	movzbl (%edx),%edx
80105507:	88 10                	mov    %dl,(%eax)
80105509:	0f b6 00             	movzbl (%eax),%eax
8010550c:	84 c0                	test   %al,%al
8010550e:	75 d5                	jne    801054e5 <strncpy+0xd>
    ;
  while(n-- > 0)
80105510:	eb 0c                	jmp    8010551e <strncpy+0x46>
    *s++ = 0;
80105512:	8b 45 08             	mov    0x8(%ebp),%eax
80105515:	8d 50 01             	lea    0x1(%eax),%edx
80105518:	89 55 08             	mov    %edx,0x8(%ebp)
8010551b:	c6 00 00             	movb   $0x0,(%eax)
  while(n-- > 0)
8010551e:	8b 45 10             	mov    0x10(%ebp),%eax
80105521:	8d 50 ff             	lea    -0x1(%eax),%edx
80105524:	89 55 10             	mov    %edx,0x10(%ebp)
80105527:	85 c0                	test   %eax,%eax
80105529:	7f e7                	jg     80105512 <strncpy+0x3a>
  return os;
8010552b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010552e:	c9                   	leave  
8010552f:	c3                   	ret    

80105530 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105530:	55                   	push   %ebp
80105531:	89 e5                	mov    %esp,%ebp
80105533:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105536:	8b 45 08             	mov    0x8(%ebp),%eax
80105539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
8010553c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105540:	7f 05                	jg     80105547 <safestrcpy+0x17>
    return os;
80105542:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105545:	eb 32                	jmp    80105579 <safestrcpy+0x49>
  while(--n > 0 && (*s++ = *t++) != 0)
80105547:	90                   	nop
80105548:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
8010554c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105550:	7e 1e                	jle    80105570 <safestrcpy+0x40>
80105552:	8b 55 0c             	mov    0xc(%ebp),%edx
80105555:	8d 42 01             	lea    0x1(%edx),%eax
80105558:	89 45 0c             	mov    %eax,0xc(%ebp)
8010555b:	8b 45 08             	mov    0x8(%ebp),%eax
8010555e:	8d 48 01             	lea    0x1(%eax),%ecx
80105561:	89 4d 08             	mov    %ecx,0x8(%ebp)
80105564:	0f b6 12             	movzbl (%edx),%edx
80105567:	88 10                	mov    %dl,(%eax)
80105569:	0f b6 00             	movzbl (%eax),%eax
8010556c:	84 c0                	test   %al,%al
8010556e:	75 d8                	jne    80105548 <safestrcpy+0x18>
    ;
  *s = 0;
80105570:	8b 45 08             	mov    0x8(%ebp),%eax
80105573:	c6 00 00             	movb   $0x0,(%eax)
  return os;
80105576:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105579:	c9                   	leave  
8010557a:	c3                   	ret    

8010557b <strlen>:

int
strlen(const char *s)
{
8010557b:	55                   	push   %ebp
8010557c:	89 e5                	mov    %esp,%ebp
8010557e:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
80105581:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105588:	eb 04                	jmp    8010558e <strlen+0x13>
8010558a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
8010558e:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105591:	8b 45 08             	mov    0x8(%ebp),%eax
80105594:	01 d0                	add    %edx,%eax
80105596:	0f b6 00             	movzbl (%eax),%eax
80105599:	84 c0                	test   %al,%al
8010559b:	75 ed                	jne    8010558a <strlen+0xf>
    ;
  return n;
8010559d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801055a0:	c9                   	leave  
801055a1:	c3                   	ret    

801055a2 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801055a2:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801055a6:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801055aa:	55                   	push   %ebp
  pushl %ebx
801055ab:	53                   	push   %ebx
  pushl %esi
801055ac:	56                   	push   %esi
  pushl %edi
801055ad:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801055ae:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801055b0:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801055b2:	5f                   	pop    %edi
  popl %esi
801055b3:	5e                   	pop    %esi
  popl %ebx
801055b4:	5b                   	pop    %ebx
  popl %ebp
801055b5:	5d                   	pop    %ebp
  ret
801055b6:	c3                   	ret    

801055b7 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801055b7:	55                   	push   %ebp
801055b8:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801055ba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055c0:	8b 00                	mov    (%eax),%eax
801055c2:	39 45 08             	cmp    %eax,0x8(%ebp)
801055c5:	73 12                	jae    801055d9 <fetchint+0x22>
801055c7:	8b 45 08             	mov    0x8(%ebp),%eax
801055ca:	8d 50 04             	lea    0x4(%eax),%edx
801055cd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055d3:	8b 00                	mov    (%eax),%eax
801055d5:	39 c2                	cmp    %eax,%edx
801055d7:	76 07                	jbe    801055e0 <fetchint+0x29>
    return -1;
801055d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055de:	eb 0f                	jmp    801055ef <fetchint+0x38>
  *ip = *(int*)(addr);
801055e0:	8b 45 08             	mov    0x8(%ebp),%eax
801055e3:	8b 10                	mov    (%eax),%edx
801055e5:	8b 45 0c             	mov    0xc(%ebp),%eax
801055e8:	89 10                	mov    %edx,(%eax)
  return 0;
801055ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801055ef:	5d                   	pop    %ebp
801055f0:	c3                   	ret    

801055f1 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
801055f1:	55                   	push   %ebp
801055f2:	89 e5                	mov    %esp,%ebp
801055f4:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
801055f7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801055fd:	8b 00                	mov    (%eax),%eax
801055ff:	39 45 08             	cmp    %eax,0x8(%ebp)
80105602:	72 07                	jb     8010560b <fetchstr+0x1a>
    return -1;
80105604:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105609:	eb 44                	jmp    8010564f <fetchstr+0x5e>
  *pp = (char*)addr;
8010560b:	8b 55 08             	mov    0x8(%ebp),%edx
8010560e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105611:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105613:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105619:	8b 00                	mov    (%eax),%eax
8010561b:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
8010561e:	8b 45 0c             	mov    0xc(%ebp),%eax
80105621:	8b 00                	mov    (%eax),%eax
80105623:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105626:	eb 1a                	jmp    80105642 <fetchstr+0x51>
    if(*s == 0)
80105628:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010562b:	0f b6 00             	movzbl (%eax),%eax
8010562e:	84 c0                	test   %al,%al
80105630:	75 0c                	jne    8010563e <fetchstr+0x4d>
      return s - *pp;
80105632:	8b 45 0c             	mov    0xc(%ebp),%eax
80105635:	8b 10                	mov    (%eax),%edx
80105637:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010563a:	29 d0                	sub    %edx,%eax
8010563c:	eb 11                	jmp    8010564f <fetchstr+0x5e>
  for(s = *pp; s < ep; s++)
8010563e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105642:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105645:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105648:	72 de                	jb     80105628 <fetchstr+0x37>
  return -1;
8010564a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010564f:	c9                   	leave  
80105650:	c3                   	ret    

80105651 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105651:	55                   	push   %ebp
80105652:	89 e5                	mov    %esp,%ebp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105654:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010565a:	8b 40 18             	mov    0x18(%eax),%eax
8010565d:	8b 50 44             	mov    0x44(%eax),%edx
80105660:	8b 45 08             	mov    0x8(%ebp),%eax
80105663:	c1 e0 02             	shl    $0x2,%eax
80105666:	01 d0                	add    %edx,%eax
80105668:	83 c0 04             	add    $0x4,%eax
8010566b:	ff 75 0c             	push   0xc(%ebp)
8010566e:	50                   	push   %eax
8010566f:	e8 43 ff ff ff       	call   801055b7 <fetchint>
80105674:	83 c4 08             	add    $0x8,%esp
}
80105677:	c9                   	leave  
80105678:	c3                   	ret    

80105679 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105679:	55                   	push   %ebp
8010567a:	89 e5                	mov    %esp,%ebp
8010567c:	83 ec 10             	sub    $0x10,%esp
  int i;
  
  if(argint(n, &i) < 0)
8010567f:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105682:	50                   	push   %eax
80105683:	ff 75 08             	push   0x8(%ebp)
80105686:	e8 c6 ff ff ff       	call   80105651 <argint>
8010568b:	83 c4 08             	add    $0x8,%esp
8010568e:	85 c0                	test   %eax,%eax
80105690:	79 07                	jns    80105699 <argptr+0x20>
    return -1;
80105692:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105697:	eb 3b                	jmp    801056d4 <argptr+0x5b>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105699:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010569f:	8b 00                	mov    (%eax),%eax
801056a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
801056a4:	39 d0                	cmp    %edx,%eax
801056a6:	76 16                	jbe    801056be <argptr+0x45>
801056a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056ab:	89 c2                	mov    %eax,%edx
801056ad:	8b 45 10             	mov    0x10(%ebp),%eax
801056b0:	01 c2                	add    %eax,%edx
801056b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801056b8:	8b 00                	mov    (%eax),%eax
801056ba:	39 c2                	cmp    %eax,%edx
801056bc:	76 07                	jbe    801056c5 <argptr+0x4c>
    return -1;
801056be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056c3:	eb 0f                	jmp    801056d4 <argptr+0x5b>
  *pp = (char*)i;
801056c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056c8:	89 c2                	mov    %eax,%edx
801056ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801056cd:	89 10                	mov    %edx,(%eax)
  return 0;
801056cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
801056d4:	c9                   	leave  
801056d5:	c3                   	ret    

801056d6 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801056d6:	55                   	push   %ebp
801056d7:	89 e5                	mov    %esp,%ebp
801056d9:	83 ec 10             	sub    $0x10,%esp
  int addr;
  if(argint(n, &addr) < 0)
801056dc:	8d 45 fc             	lea    -0x4(%ebp),%eax
801056df:	50                   	push   %eax
801056e0:	ff 75 08             	push   0x8(%ebp)
801056e3:	e8 69 ff ff ff       	call   80105651 <argint>
801056e8:	83 c4 08             	add    $0x8,%esp
801056eb:	85 c0                	test   %eax,%eax
801056ed:	79 07                	jns    801056f6 <argstr+0x20>
    return -1;
801056ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801056f4:	eb 0f                	jmp    80105705 <argstr+0x2f>
  return fetchstr(addr, pp);
801056f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
801056f9:	ff 75 0c             	push   0xc(%ebp)
801056fc:	50                   	push   %eax
801056fd:	e8 ef fe ff ff       	call   801055f1 <fetchstr>
80105702:	83 c4 08             	add    $0x8,%esp
}
80105705:	c9                   	leave  
80105706:	c3                   	ret    

80105707 <syscall>:
[SYS_shmdel] sys_shmdel,                                // CS 3320 project 2
};

void
syscall(void)
{
80105707:	55                   	push   %ebp
80105708:	89 e5                	mov    %esp,%ebp
8010570a:	83 ec 18             	sub    $0x18,%esp
  int num;

  num = proc->tf->eax;
8010570d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105713:	8b 40 18             	mov    0x18(%eax),%eax
80105716:	8b 40 1c             	mov    0x1c(%eax),%eax
80105719:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
8010571c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105720:	7e 32                	jle    80105754 <syscall+0x4d>
80105722:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105725:	83 f8 1a             	cmp    $0x1a,%eax
80105728:	77 2a                	ja     80105754 <syscall+0x4d>
8010572a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010572d:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105734:	85 c0                	test   %eax,%eax
80105736:	74 1c                	je     80105754 <syscall+0x4d>
    proc->tf->eax = syscalls[num]();
80105738:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010573b:	8b 04 85 40 b0 10 80 	mov    -0x7fef4fc0(,%eax,4),%eax
80105742:	ff d0                	call   *%eax
80105744:	89 c2                	mov    %eax,%edx
80105746:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010574c:	8b 40 18             	mov    0x18(%eax),%eax
8010574f:	89 50 1c             	mov    %edx,0x1c(%eax)
80105752:	eb 35                	jmp    80105789 <syscall+0x82>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105754:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010575a:	8d 50 6c             	lea    0x6c(%eax),%edx
8010575d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
    cprintf("%d %s: unknown sys call %d\n",
80105763:	8b 40 10             	mov    0x10(%eax),%eax
80105766:	ff 75 f4             	push   -0xc(%ebp)
80105769:	52                   	push   %edx
8010576a:	50                   	push   %eax
8010576b:	68 47 8c 10 80       	push   $0x80108c47
80105770:	e8 51 ac ff ff       	call   801003c6 <cprintf>
80105775:	83 c4 10             	add    $0x10,%esp
    proc->tf->eax = -1;
80105778:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010577e:	8b 40 18             	mov    0x18(%eax),%eax
80105781:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105788:	90                   	nop
80105789:	90                   	nop
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    

8010578c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010578c:	55                   	push   %ebp
8010578d:	89 e5                	mov    %esp,%ebp
8010578f:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105792:	83 ec 08             	sub    $0x8,%esp
80105795:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105798:	50                   	push   %eax
80105799:	ff 75 08             	push   0x8(%ebp)
8010579c:	e8 b0 fe ff ff       	call   80105651 <argint>
801057a1:	83 c4 10             	add    $0x10,%esp
801057a4:	85 c0                	test   %eax,%eax
801057a6:	79 07                	jns    801057af <argfd+0x23>
    return -1;
801057a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057ad:	eb 50                	jmp    801057ff <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
801057af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b2:	85 c0                	test   %eax,%eax
801057b4:	78 21                	js     801057d7 <argfd+0x4b>
801057b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801057b9:	83 f8 0f             	cmp    $0xf,%eax
801057bc:	7f 19                	jg     801057d7 <argfd+0x4b>
801057be:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801057c4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057c7:	83 c2 08             	add    $0x8,%edx
801057ca:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801057ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
801057d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801057d5:	75 07                	jne    801057de <argfd+0x52>
    return -1;
801057d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801057dc:	eb 21                	jmp    801057ff <argfd+0x73>
  if(pfd)
801057de:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801057e2:	74 08                	je     801057ec <argfd+0x60>
    *pfd = fd;
801057e4:	8b 55 f0             	mov    -0x10(%ebp),%edx
801057e7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057ea:	89 10                	mov    %edx,(%eax)
  if(pf)
801057ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801057f0:	74 08                	je     801057fa <argfd+0x6e>
    *pf = f;
801057f2:	8b 45 10             	mov    0x10(%ebp),%eax
801057f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801057f8:	89 10                	mov    %edx,(%eax)
  return 0;
801057fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
801057ff:	c9                   	leave  
80105800:	c3                   	ret    

80105801 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105801:	55                   	push   %ebp
80105802:	89 e5                	mov    %esp,%ebp
80105804:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105807:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
8010580e:	eb 30                	jmp    80105840 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105810:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105816:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105819:	83 c2 08             	add    $0x8,%edx
8010581c:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105820:	85 c0                	test   %eax,%eax
80105822:	75 18                	jne    8010583c <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105824:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010582a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010582d:	8d 4a 08             	lea    0x8(%edx),%ecx
80105830:	8b 55 08             	mov    0x8(%ebp),%edx
80105833:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105837:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010583a:	eb 0f                	jmp    8010584b <fdalloc+0x4a>
  for(fd = 0; fd < NOFILE; fd++){
8010583c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105840:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105844:	7e ca                	jle    80105810 <fdalloc+0xf>
    }
  }
  return -1;
80105846:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010584b:	c9                   	leave  
8010584c:	c3                   	ret    

8010584d <sys_dup>:

int
sys_dup(void)
{
8010584d:	55                   	push   %ebp
8010584e:	89 e5                	mov    %esp,%ebp
80105850:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105853:	83 ec 04             	sub    $0x4,%esp
80105856:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105859:	50                   	push   %eax
8010585a:	6a 00                	push   $0x0
8010585c:	6a 00                	push   $0x0
8010585e:	e8 29 ff ff ff       	call   8010578c <argfd>
80105863:	83 c4 10             	add    $0x10,%esp
80105866:	85 c0                	test   %eax,%eax
80105868:	79 07                	jns    80105871 <sys_dup+0x24>
    return -1;
8010586a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010586f:	eb 31                	jmp    801058a2 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105871:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105874:	83 ec 0c             	sub    $0xc,%esp
80105877:	50                   	push   %eax
80105878:	e8 84 ff ff ff       	call   80105801 <fdalloc>
8010587d:	83 c4 10             	add    $0x10,%esp
80105880:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105887:	79 07                	jns    80105890 <sys_dup+0x43>
    return -1;
80105889:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010588e:	eb 12                	jmp    801058a2 <sys_dup+0x55>
  filedup(f);
80105890:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105893:	83 ec 0c             	sub    $0xc,%esp
80105896:	50                   	push   %eax
80105897:	e8 91 b7 ff ff       	call   8010102d <filedup>
8010589c:	83 c4 10             	add    $0x10,%esp
  return fd;
8010589f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801058a2:	c9                   	leave  
801058a3:	c3                   	ret    

801058a4 <sys_read>:

int
sys_read(void)
{
801058a4:	55                   	push   %ebp
801058a5:	89 e5                	mov    %esp,%ebp
801058a7:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801058aa:	83 ec 04             	sub    $0x4,%esp
801058ad:	8d 45 f4             	lea    -0xc(%ebp),%eax
801058b0:	50                   	push   %eax
801058b1:	6a 00                	push   $0x0
801058b3:	6a 00                	push   $0x0
801058b5:	e8 d2 fe ff ff       	call   8010578c <argfd>
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	85 c0                	test   %eax,%eax
801058bf:	78 2e                	js     801058ef <sys_read+0x4b>
801058c1:	83 ec 08             	sub    $0x8,%esp
801058c4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801058c7:	50                   	push   %eax
801058c8:	6a 02                	push   $0x2
801058ca:	e8 82 fd ff ff       	call   80105651 <argint>
801058cf:	83 c4 10             	add    $0x10,%esp
801058d2:	85 c0                	test   %eax,%eax
801058d4:	78 19                	js     801058ef <sys_read+0x4b>
801058d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801058d9:	83 ec 04             	sub    $0x4,%esp
801058dc:	50                   	push   %eax
801058dd:	8d 45 ec             	lea    -0x14(%ebp),%eax
801058e0:	50                   	push   %eax
801058e1:	6a 01                	push   $0x1
801058e3:	e8 91 fd ff ff       	call   80105679 <argptr>
801058e8:	83 c4 10             	add    $0x10,%esp
801058eb:	85 c0                	test   %eax,%eax
801058ed:	79 07                	jns    801058f6 <sys_read+0x52>
    return -1;
801058ef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058f4:	eb 17                	jmp    8010590d <sys_read+0x69>
  return fileread(f, p, n);
801058f6:	8b 4d f0             	mov    -0x10(%ebp),%ecx
801058f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
801058fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801058ff:	83 ec 04             	sub    $0x4,%esp
80105902:	51                   	push   %ecx
80105903:	52                   	push   %edx
80105904:	50                   	push   %eax
80105905:	e8 b3 b8 ff ff       	call   801011bd <fileread>
8010590a:	83 c4 10             	add    $0x10,%esp
}
8010590d:	c9                   	leave  
8010590e:	c3                   	ret    

8010590f <sys_write>:

int
sys_write(void)
{
8010590f:	55                   	push   %ebp
80105910:	89 e5                	mov    %esp,%ebp
80105912:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105915:	83 ec 04             	sub    $0x4,%esp
80105918:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010591b:	50                   	push   %eax
8010591c:	6a 00                	push   $0x0
8010591e:	6a 00                	push   $0x0
80105920:	e8 67 fe ff ff       	call   8010578c <argfd>
80105925:	83 c4 10             	add    $0x10,%esp
80105928:	85 c0                	test   %eax,%eax
8010592a:	78 2e                	js     8010595a <sys_write+0x4b>
8010592c:	83 ec 08             	sub    $0x8,%esp
8010592f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105932:	50                   	push   %eax
80105933:	6a 02                	push   $0x2
80105935:	e8 17 fd ff ff       	call   80105651 <argint>
8010593a:	83 c4 10             	add    $0x10,%esp
8010593d:	85 c0                	test   %eax,%eax
8010593f:	78 19                	js     8010595a <sys_write+0x4b>
80105941:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105944:	83 ec 04             	sub    $0x4,%esp
80105947:	50                   	push   %eax
80105948:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010594b:	50                   	push   %eax
8010594c:	6a 01                	push   $0x1
8010594e:	e8 26 fd ff ff       	call   80105679 <argptr>
80105953:	83 c4 10             	add    $0x10,%esp
80105956:	85 c0                	test   %eax,%eax
80105958:	79 07                	jns    80105961 <sys_write+0x52>
    return -1;
8010595a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010595f:	eb 17                	jmp    80105978 <sys_write+0x69>
  return filewrite(f, p, n);
80105961:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105964:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105967:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010596a:	83 ec 04             	sub    $0x4,%esp
8010596d:	51                   	push   %ecx
8010596e:	52                   	push   %edx
8010596f:	50                   	push   %eax
80105970:	e8 00 b9 ff ff       	call   80101275 <filewrite>
80105975:	83 c4 10             	add    $0x10,%esp
}
80105978:	c9                   	leave  
80105979:	c3                   	ret    

8010597a <sys_close>:

int
sys_close(void)
{
8010597a:	55                   	push   %ebp
8010597b:	89 e5                	mov    %esp,%ebp
8010597d:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105980:	83 ec 04             	sub    $0x4,%esp
80105983:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105986:	50                   	push   %eax
80105987:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010598a:	50                   	push   %eax
8010598b:	6a 00                	push   $0x0
8010598d:	e8 fa fd ff ff       	call   8010578c <argfd>
80105992:	83 c4 10             	add    $0x10,%esp
80105995:	85 c0                	test   %eax,%eax
80105997:	79 07                	jns    801059a0 <sys_close+0x26>
    return -1;
80105999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010599e:	eb 28                	jmp    801059c8 <sys_close+0x4e>
  proc->ofile[fd] = 0;
801059a0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
801059a9:	83 c2 08             	add    $0x8,%edx
801059ac:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801059b3:	00 
  fileclose(f);
801059b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
801059b7:	83 ec 0c             	sub    $0xc,%esp
801059ba:	50                   	push   %eax
801059bb:	e8 be b6 ff ff       	call   8010107e <fileclose>
801059c0:	83 c4 10             	add    $0x10,%esp
  return 0;
801059c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
801059c8:	c9                   	leave  
801059c9:	c3                   	ret    

801059ca <sys_fstat>:

int
sys_fstat(void)
{
801059ca:	55                   	push   %ebp
801059cb:	89 e5                	mov    %esp,%ebp
801059cd:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
801059d0:	83 ec 04             	sub    $0x4,%esp
801059d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
801059d6:	50                   	push   %eax
801059d7:	6a 00                	push   $0x0
801059d9:	6a 00                	push   $0x0
801059db:	e8 ac fd ff ff       	call   8010578c <argfd>
801059e0:	83 c4 10             	add    $0x10,%esp
801059e3:	85 c0                	test   %eax,%eax
801059e5:	78 17                	js     801059fe <sys_fstat+0x34>
801059e7:	83 ec 04             	sub    $0x4,%esp
801059ea:	6a 14                	push   $0x14
801059ec:	8d 45 f0             	lea    -0x10(%ebp),%eax
801059ef:	50                   	push   %eax
801059f0:	6a 01                	push   $0x1
801059f2:	e8 82 fc ff ff       	call   80105679 <argptr>
801059f7:	83 c4 10             	add    $0x10,%esp
801059fa:	85 c0                	test   %eax,%eax
801059fc:	79 07                	jns    80105a05 <sys_fstat+0x3b>
    return -1;
801059fe:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a03:	eb 13                	jmp    80105a18 <sys_fstat+0x4e>
  return filestat(f, st);
80105a05:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a0b:	83 ec 08             	sub    $0x8,%esp
80105a0e:	52                   	push   %edx
80105a0f:	50                   	push   %eax
80105a10:	e8 51 b7 ff ff       	call   80101166 <filestat>
80105a15:	83 c4 10             	add    $0x10,%esp
}
80105a18:	c9                   	leave  
80105a19:	c3                   	ret    

80105a1a <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105a1a:	55                   	push   %ebp
80105a1b:	89 e5                	mov    %esp,%ebp
80105a1d:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105a20:	83 ec 08             	sub    $0x8,%esp
80105a23:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105a26:	50                   	push   %eax
80105a27:	6a 00                	push   $0x0
80105a29:	e8 a8 fc ff ff       	call   801056d6 <argstr>
80105a2e:	83 c4 10             	add    $0x10,%esp
80105a31:	85 c0                	test   %eax,%eax
80105a33:	78 15                	js     80105a4a <sys_link+0x30>
80105a35:	83 ec 08             	sub    $0x8,%esp
80105a38:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105a3b:	50                   	push   %eax
80105a3c:	6a 01                	push   $0x1
80105a3e:	e8 93 fc ff ff       	call   801056d6 <argstr>
80105a43:	83 c4 10             	add    $0x10,%esp
80105a46:	85 c0                	test   %eax,%eax
80105a48:	79 0a                	jns    80105a54 <sys_link+0x3a>
    return -1;
80105a4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a4f:	e9 68 01 00 00       	jmp    80105bbc <sys_link+0x1a2>

  begin_op();
80105a54:	e8 1d db ff ff       	call   80103576 <begin_op>
  if((ip = namei(old)) == 0){
80105a59:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105a5c:	83 ec 0c             	sub    $0xc,%esp
80105a5f:	50                   	push   %eax
80105a60:	e8 d3 ca ff ff       	call   80102538 <namei>
80105a65:	83 c4 10             	add    $0x10,%esp
80105a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105a6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105a6f:	75 0f                	jne    80105a80 <sys_link+0x66>
    end_op();
80105a71:	e8 8c db ff ff       	call   80103602 <end_op>
    return -1;
80105a76:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a7b:	e9 3c 01 00 00       	jmp    80105bbc <sys_link+0x1a2>
  }

  ilock(ip);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	ff 75 f4             	push   -0xc(%ebp)
80105a86:	e8 fc be ff ff       	call   80101987 <ilock>
80105a8b:	83 c4 10             	add    $0x10,%esp
  if(ip->type == T_DIR){
80105a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105a91:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105a95:	66 83 f8 01          	cmp    $0x1,%ax
80105a99:	75 1d                	jne    80105ab8 <sys_link+0x9e>
    iunlockput(ip);
80105a9b:	83 ec 0c             	sub    $0xc,%esp
80105a9e:	ff 75 f4             	push   -0xc(%ebp)
80105aa1:	e8 a1 c1 ff ff       	call   80101c47 <iunlockput>
80105aa6:	83 c4 10             	add    $0x10,%esp
    end_op();
80105aa9:	e8 54 db ff ff       	call   80103602 <end_op>
    return -1;
80105aae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ab3:	e9 04 01 00 00       	jmp    80105bbc <sys_link+0x1a2>
  }

  ip->nlink++;
80105ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105abb:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105abf:	83 c0 01             	add    $0x1,%eax
80105ac2:	89 c2                	mov    %eax,%edx
80105ac4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ac7:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105acb:	83 ec 0c             	sub    $0xc,%esp
80105ace:	ff 75 f4             	push   -0xc(%ebp)
80105ad1:	e8 d7 bc ff ff       	call   801017ad <iupdate>
80105ad6:	83 c4 10             	add    $0x10,%esp
  iunlock(ip);
80105ad9:	83 ec 0c             	sub    $0xc,%esp
80105adc:	ff 75 f4             	push   -0xc(%ebp)
80105adf:	e8 01 c0 ff ff       	call   80101ae5 <iunlock>
80105ae4:	83 c4 10             	add    $0x10,%esp

  if((dp = nameiparent(new, name)) == 0)
80105ae7:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105aea:	83 ec 08             	sub    $0x8,%esp
80105aed:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105af0:	52                   	push   %edx
80105af1:	50                   	push   %eax
80105af2:	e8 5d ca ff ff       	call   80102554 <nameiparent>
80105af7:	83 c4 10             	add    $0x10,%esp
80105afa:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105afd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105b01:	74 71                	je     80105b74 <sys_link+0x15a>
    goto bad;
  ilock(dp);
80105b03:	83 ec 0c             	sub    $0xc,%esp
80105b06:	ff 75 f0             	push   -0x10(%ebp)
80105b09:	e8 79 be ff ff       	call   80101987 <ilock>
80105b0e:	83 c4 10             	add    $0x10,%esp
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105b11:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105b14:	8b 10                	mov    (%eax),%edx
80105b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b19:	8b 00                	mov    (%eax),%eax
80105b1b:	39 c2                	cmp    %eax,%edx
80105b1d:	75 1d                	jne    80105b3c <sys_link+0x122>
80105b1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b22:	8b 40 04             	mov    0x4(%eax),%eax
80105b25:	83 ec 04             	sub    $0x4,%esp
80105b28:	50                   	push   %eax
80105b29:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105b2c:	50                   	push   %eax
80105b2d:	ff 75 f0             	push   -0x10(%ebp)
80105b30:	e8 6b c7 ff ff       	call   801022a0 <dirlink>
80105b35:	83 c4 10             	add    $0x10,%esp
80105b38:	85 c0                	test   %eax,%eax
80105b3a:	79 10                	jns    80105b4c <sys_link+0x132>
    iunlockput(dp);
80105b3c:	83 ec 0c             	sub    $0xc,%esp
80105b3f:	ff 75 f0             	push   -0x10(%ebp)
80105b42:	e8 00 c1 ff ff       	call   80101c47 <iunlockput>
80105b47:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105b4a:	eb 29                	jmp    80105b75 <sys_link+0x15b>
  }
  iunlockput(dp);
80105b4c:	83 ec 0c             	sub    $0xc,%esp
80105b4f:	ff 75 f0             	push   -0x10(%ebp)
80105b52:	e8 f0 c0 ff ff       	call   80101c47 <iunlockput>
80105b57:	83 c4 10             	add    $0x10,%esp
  iput(ip);
80105b5a:	83 ec 0c             	sub    $0xc,%esp
80105b5d:	ff 75 f4             	push   -0xc(%ebp)
80105b60:	e8 f2 bf ff ff       	call   80101b57 <iput>
80105b65:	83 c4 10             	add    $0x10,%esp

  end_op();
80105b68:	e8 95 da ff ff       	call   80103602 <end_op>

  return 0;
80105b6d:	b8 00 00 00 00       	mov    $0x0,%eax
80105b72:	eb 48                	jmp    80105bbc <sys_link+0x1a2>
    goto bad;
80105b74:	90                   	nop

bad:
  ilock(ip);
80105b75:	83 ec 0c             	sub    $0xc,%esp
80105b78:	ff 75 f4             	push   -0xc(%ebp)
80105b7b:	e8 07 be ff ff       	call   80101987 <ilock>
80105b80:	83 c4 10             	add    $0x10,%esp
  ip->nlink--;
80105b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b86:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105b8a:	83 e8 01             	sub    $0x1,%eax
80105b8d:	89 c2                	mov    %eax,%edx
80105b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b92:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105b96:	83 ec 0c             	sub    $0xc,%esp
80105b99:	ff 75 f4             	push   -0xc(%ebp)
80105b9c:	e8 0c bc ff ff       	call   801017ad <iupdate>
80105ba1:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105ba4:	83 ec 0c             	sub    $0xc,%esp
80105ba7:	ff 75 f4             	push   -0xc(%ebp)
80105baa:	e8 98 c0 ff ff       	call   80101c47 <iunlockput>
80105baf:	83 c4 10             	add    $0x10,%esp
  end_op();
80105bb2:	e8 4b da ff ff       	call   80103602 <end_op>
  return -1;
80105bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bbc:	c9                   	leave  
80105bbd:	c3                   	ret    

80105bbe <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80105bbe:	55                   	push   %ebp
80105bbf:	89 e5                	mov    %esp,%ebp
80105bc1:	83 ec 28             	sub    $0x28,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105bc4:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
80105bcb:	eb 40                	jmp    80105c0d <isdirempty+0x4f>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105bd0:	6a 10                	push   $0x10
80105bd2:	50                   	push   %eax
80105bd3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105bd6:	50                   	push   %eax
80105bd7:	ff 75 08             	push   0x8(%ebp)
80105bda:	e8 11 c3 ff ff       	call   80101ef0 <readi>
80105bdf:	83 c4 10             	add    $0x10,%esp
80105be2:	83 f8 10             	cmp    $0x10,%eax
80105be5:	74 0d                	je     80105bf4 <isdirempty+0x36>
      panic("isdirempty: readi");
80105be7:	83 ec 0c             	sub    $0xc,%esp
80105bea:	68 63 8c 10 80       	push   $0x80108c63
80105bef:	e8 87 a9 ff ff       	call   8010057b <panic>
    if(de.inum != 0)
80105bf4:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80105bf8:	66 85 c0             	test   %ax,%ax
80105bfb:	74 07                	je     80105c04 <isdirempty+0x46>
      return 0;
80105bfd:	b8 00 00 00 00       	mov    $0x0,%eax
80105c02:	eb 1b                	jmp    80105c1f <isdirempty+0x61>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c07:	83 c0 10             	add    $0x10,%eax
80105c0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c0d:	8b 45 08             	mov    0x8(%ebp),%eax
80105c10:	8b 50 18             	mov    0x18(%eax),%edx
80105c13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c16:	39 c2                	cmp    %eax,%edx
80105c18:	77 b3                	ja     80105bcd <isdirempty+0xf>
  }
  return 1;
80105c1a:	b8 01 00 00 00       	mov    $0x1,%eax
}
80105c1f:	c9                   	leave  
80105c20:	c3                   	ret    

80105c21 <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
80105c21:	55                   	push   %ebp
80105c22:	89 e5                	mov    %esp,%ebp
80105c24:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80105c27:	83 ec 08             	sub    $0x8,%esp
80105c2a:	8d 45 cc             	lea    -0x34(%ebp),%eax
80105c2d:	50                   	push   %eax
80105c2e:	6a 00                	push   $0x0
80105c30:	e8 a1 fa ff ff       	call   801056d6 <argstr>
80105c35:	83 c4 10             	add    $0x10,%esp
80105c38:	85 c0                	test   %eax,%eax
80105c3a:	79 0a                	jns    80105c46 <sys_unlink+0x25>
    return -1;
80105c3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c41:	e9 bf 01 00 00       	jmp    80105e05 <sys_unlink+0x1e4>

  begin_op();
80105c46:	e8 2b d9 ff ff       	call   80103576 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105c4b:	8b 45 cc             	mov    -0x34(%ebp),%eax
80105c4e:	83 ec 08             	sub    $0x8,%esp
80105c51:	8d 55 d2             	lea    -0x2e(%ebp),%edx
80105c54:	52                   	push   %edx
80105c55:	50                   	push   %eax
80105c56:	e8 f9 c8 ff ff       	call   80102554 <nameiparent>
80105c5b:	83 c4 10             	add    $0x10,%esp
80105c5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c61:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c65:	75 0f                	jne    80105c76 <sys_unlink+0x55>
    end_op();
80105c67:	e8 96 d9 ff ff       	call   80103602 <end_op>
    return -1;
80105c6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c71:	e9 8f 01 00 00       	jmp    80105e05 <sys_unlink+0x1e4>
  }

  ilock(dp);
80105c76:	83 ec 0c             	sub    $0xc,%esp
80105c79:	ff 75 f4             	push   -0xc(%ebp)
80105c7c:	e8 06 bd ff ff       	call   80101987 <ilock>
80105c81:	83 c4 10             	add    $0x10,%esp

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105c84:	83 ec 08             	sub    $0x8,%esp
80105c87:	68 75 8c 10 80       	push   $0x80108c75
80105c8c:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105c8f:	50                   	push   %eax
80105c90:	e8 36 c5 ff ff       	call   801021cb <namecmp>
80105c95:	83 c4 10             	add    $0x10,%esp
80105c98:	85 c0                	test   %eax,%eax
80105c9a:	0f 84 49 01 00 00    	je     80105de9 <sys_unlink+0x1c8>
80105ca0:	83 ec 08             	sub    $0x8,%esp
80105ca3:	68 77 8c 10 80       	push   $0x80108c77
80105ca8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cab:	50                   	push   %eax
80105cac:	e8 1a c5 ff ff       	call   801021cb <namecmp>
80105cb1:	83 c4 10             	add    $0x10,%esp
80105cb4:	85 c0                	test   %eax,%eax
80105cb6:	0f 84 2d 01 00 00    	je     80105de9 <sys_unlink+0x1c8>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80105cbc:	83 ec 04             	sub    $0x4,%esp
80105cbf:	8d 45 c8             	lea    -0x38(%ebp),%eax
80105cc2:	50                   	push   %eax
80105cc3:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80105cc6:	50                   	push   %eax
80105cc7:	ff 75 f4             	push   -0xc(%ebp)
80105cca:	e8 17 c5 ff ff       	call   801021e6 <dirlookup>
80105ccf:	83 c4 10             	add    $0x10,%esp
80105cd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105cd5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105cd9:	0f 84 0d 01 00 00    	je     80105dec <sys_unlink+0x1cb>
    goto bad;
  ilock(ip);
80105cdf:	83 ec 0c             	sub    $0xc,%esp
80105ce2:	ff 75 f0             	push   -0x10(%ebp)
80105ce5:	e8 9d bc ff ff       	call   80101987 <ilock>
80105cea:	83 c4 10             	add    $0x10,%esp

  if(ip->nlink < 1)
80105ced:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cf0:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105cf4:	66 85 c0             	test   %ax,%ax
80105cf7:	7f 0d                	jg     80105d06 <sys_unlink+0xe5>
    panic("unlink: nlink < 1");
80105cf9:	83 ec 0c             	sub    $0xc,%esp
80105cfc:	68 7a 8c 10 80       	push   $0x80108c7a
80105d01:	e8 75 a8 ff ff       	call   8010057b <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d09:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d0d:	66 83 f8 01          	cmp    $0x1,%ax
80105d11:	75 25                	jne    80105d38 <sys_unlink+0x117>
80105d13:	83 ec 0c             	sub    $0xc,%esp
80105d16:	ff 75 f0             	push   -0x10(%ebp)
80105d19:	e8 a0 fe ff ff       	call   80105bbe <isdirempty>
80105d1e:	83 c4 10             	add    $0x10,%esp
80105d21:	85 c0                	test   %eax,%eax
80105d23:	75 13                	jne    80105d38 <sys_unlink+0x117>
    iunlockput(ip);
80105d25:	83 ec 0c             	sub    $0xc,%esp
80105d28:	ff 75 f0             	push   -0x10(%ebp)
80105d2b:	e8 17 bf ff ff       	call   80101c47 <iunlockput>
80105d30:	83 c4 10             	add    $0x10,%esp
    goto bad;
80105d33:	e9 b5 00 00 00       	jmp    80105ded <sys_unlink+0x1cc>
  }

  memset(&de, 0, sizeof(de));
80105d38:	83 ec 04             	sub    $0x4,%esp
80105d3b:	6a 10                	push   $0x10
80105d3d:	6a 00                	push   $0x0
80105d3f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d42:	50                   	push   %eax
80105d43:	e8 e5 f5 ff ff       	call   8010532d <memset>
80105d48:	83 c4 10             	add    $0x10,%esp
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105d4b:	8b 45 c8             	mov    -0x38(%ebp),%eax
80105d4e:	6a 10                	push   $0x10
80105d50:	50                   	push   %eax
80105d51:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105d54:	50                   	push   %eax
80105d55:	ff 75 f4             	push   -0xc(%ebp)
80105d58:	e8 e8 c2 ff ff       	call   80102045 <writei>
80105d5d:	83 c4 10             	add    $0x10,%esp
80105d60:	83 f8 10             	cmp    $0x10,%eax
80105d63:	74 0d                	je     80105d72 <sys_unlink+0x151>
    panic("unlink: writei");
80105d65:	83 ec 0c             	sub    $0xc,%esp
80105d68:	68 8c 8c 10 80       	push   $0x80108c8c
80105d6d:	e8 09 a8 ff ff       	call   8010057b <panic>
  if(ip->type == T_DIR){
80105d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d75:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105d79:	66 83 f8 01          	cmp    $0x1,%ax
80105d7d:	75 21                	jne    80105da0 <sys_unlink+0x17f>
    dp->nlink--;
80105d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d82:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105d86:	83 e8 01             	sub    $0x1,%eax
80105d89:	89 c2                	mov    %eax,%edx
80105d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d8e:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105d92:	83 ec 0c             	sub    $0xc,%esp
80105d95:	ff 75 f4             	push   -0xc(%ebp)
80105d98:	e8 10 ba ff ff       	call   801017ad <iupdate>
80105d9d:	83 c4 10             	add    $0x10,%esp
  }
  iunlockput(dp);
80105da0:	83 ec 0c             	sub    $0xc,%esp
80105da3:	ff 75 f4             	push   -0xc(%ebp)
80105da6:	e8 9c be ff ff       	call   80101c47 <iunlockput>
80105dab:	83 c4 10             	add    $0x10,%esp

  ip->nlink--;
80105dae:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105db5:	83 e8 01             	sub    $0x1,%eax
80105db8:	89 c2                	mov    %eax,%edx
80105dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105dbd:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105dc1:	83 ec 0c             	sub    $0xc,%esp
80105dc4:	ff 75 f0             	push   -0x10(%ebp)
80105dc7:	e8 e1 b9 ff ff       	call   801017ad <iupdate>
80105dcc:	83 c4 10             	add    $0x10,%esp
  iunlockput(ip);
80105dcf:	83 ec 0c             	sub    $0xc,%esp
80105dd2:	ff 75 f0             	push   -0x10(%ebp)
80105dd5:	e8 6d be ff ff       	call   80101c47 <iunlockput>
80105dda:	83 c4 10             	add    $0x10,%esp

  end_op();
80105ddd:	e8 20 d8 ff ff       	call   80103602 <end_op>

  return 0;
80105de2:	b8 00 00 00 00       	mov    $0x0,%eax
80105de7:	eb 1c                	jmp    80105e05 <sys_unlink+0x1e4>
    goto bad;
80105de9:	90                   	nop
80105dea:	eb 01                	jmp    80105ded <sys_unlink+0x1cc>
    goto bad;
80105dec:	90                   	nop

bad:
  iunlockput(dp);
80105ded:	83 ec 0c             	sub    $0xc,%esp
80105df0:	ff 75 f4             	push   -0xc(%ebp)
80105df3:	e8 4f be ff ff       	call   80101c47 <iunlockput>
80105df8:	83 c4 10             	add    $0x10,%esp
  end_op();
80105dfb:	e8 02 d8 ff ff       	call   80103602 <end_op>
  return -1;
80105e00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105e05:	c9                   	leave  
80105e06:	c3                   	ret    

80105e07 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80105e07:	55                   	push   %ebp
80105e08:	89 e5                	mov    %esp,%ebp
80105e0a:	83 ec 38             	sub    $0x38,%esp
80105e0d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80105e10:	8b 55 10             	mov    0x10(%ebp),%edx
80105e13:	8b 45 14             	mov    0x14(%ebp),%eax
80105e16:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
80105e1a:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
80105e1e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80105e22:	83 ec 08             	sub    $0x8,%esp
80105e25:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e28:	50                   	push   %eax
80105e29:	ff 75 08             	push   0x8(%ebp)
80105e2c:	e8 23 c7 ff ff       	call   80102554 <nameiparent>
80105e31:	83 c4 10             	add    $0x10,%esp
80105e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105e37:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105e3b:	75 0a                	jne    80105e47 <create+0x40>
    return 0;
80105e3d:	b8 00 00 00 00       	mov    $0x0,%eax
80105e42:	e9 90 01 00 00       	jmp    80105fd7 <create+0x1d0>
  ilock(dp);
80105e47:	83 ec 0c             	sub    $0xc,%esp
80105e4a:	ff 75 f4             	push   -0xc(%ebp)
80105e4d:	e8 35 bb ff ff       	call   80101987 <ilock>
80105e52:	83 c4 10             	add    $0x10,%esp

  if((ip = dirlookup(dp, name, &off)) != 0){
80105e55:	83 ec 04             	sub    $0x4,%esp
80105e58:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105e5b:	50                   	push   %eax
80105e5c:	8d 45 de             	lea    -0x22(%ebp),%eax
80105e5f:	50                   	push   %eax
80105e60:	ff 75 f4             	push   -0xc(%ebp)
80105e63:	e8 7e c3 ff ff       	call   801021e6 <dirlookup>
80105e68:	83 c4 10             	add    $0x10,%esp
80105e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105e6e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105e72:	74 50                	je     80105ec4 <create+0xbd>
    iunlockput(dp);
80105e74:	83 ec 0c             	sub    $0xc,%esp
80105e77:	ff 75 f4             	push   -0xc(%ebp)
80105e7a:	e8 c8 bd ff ff       	call   80101c47 <iunlockput>
80105e7f:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
80105e82:	83 ec 0c             	sub    $0xc,%esp
80105e85:	ff 75 f0             	push   -0x10(%ebp)
80105e88:	e8 fa ba ff ff       	call   80101987 <ilock>
80105e8d:	83 c4 10             	add    $0x10,%esp
    if(type == T_FILE && ip->type == T_FILE)
80105e90:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80105e95:	75 15                	jne    80105eac <create+0xa5>
80105e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e9a:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105e9e:	66 83 f8 02          	cmp    $0x2,%ax
80105ea2:	75 08                	jne    80105eac <create+0xa5>
      return ip;
80105ea4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ea7:	e9 2b 01 00 00       	jmp    80105fd7 <create+0x1d0>
    iunlockput(ip);
80105eac:	83 ec 0c             	sub    $0xc,%esp
80105eaf:	ff 75 f0             	push   -0x10(%ebp)
80105eb2:	e8 90 bd ff ff       	call   80101c47 <iunlockput>
80105eb7:	83 c4 10             	add    $0x10,%esp
    return 0;
80105eba:	b8 00 00 00 00       	mov    $0x0,%eax
80105ebf:	e9 13 01 00 00       	jmp    80105fd7 <create+0x1d0>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80105ec4:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
80105ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ecb:	8b 00                	mov    (%eax),%eax
80105ecd:	83 ec 08             	sub    $0x8,%esp
80105ed0:	52                   	push   %edx
80105ed1:	50                   	push   %eax
80105ed2:	e8 ff b7 ff ff       	call   801016d6 <ialloc>
80105ed7:	83 c4 10             	add    $0x10,%esp
80105eda:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105edd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105ee1:	75 0d                	jne    80105ef0 <create+0xe9>
    panic("create: ialloc");
80105ee3:	83 ec 0c             	sub    $0xc,%esp
80105ee6:	68 9b 8c 10 80       	push   $0x80108c9b
80105eeb:	e8 8b a6 ff ff       	call   8010057b <panic>

  ilock(ip);
80105ef0:	83 ec 0c             	sub    $0xc,%esp
80105ef3:	ff 75 f0             	push   -0x10(%ebp)
80105ef6:	e8 8c ba ff ff       	call   80101987 <ilock>
80105efb:	83 c4 10             	add    $0x10,%esp
  ip->major = major;
80105efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f01:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80105f05:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
80105f09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f0c:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80105f10:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80105f14:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f17:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
80105f1d:	83 ec 0c             	sub    $0xc,%esp
80105f20:	ff 75 f0             	push   -0x10(%ebp)
80105f23:	e8 85 b8 ff ff       	call   801017ad <iupdate>
80105f28:	83 c4 10             	add    $0x10,%esp

  if(type == T_DIR){  // Create . and .. entries.
80105f2b:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80105f30:	75 6a                	jne    80105f9c <create+0x195>
    dp->nlink++;  // for ".."
80105f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f35:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f39:	83 c0 01             	add    $0x1,%eax
80105f3c:	89 c2                	mov    %eax,%edx
80105f3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f41:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80105f45:	83 ec 0c             	sub    $0xc,%esp
80105f48:	ff 75 f4             	push   -0xc(%ebp)
80105f4b:	e8 5d b8 ff ff       	call   801017ad <iupdate>
80105f50:	83 c4 10             	add    $0x10,%esp
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80105f53:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f56:	8b 40 04             	mov    0x4(%eax),%eax
80105f59:	83 ec 04             	sub    $0x4,%esp
80105f5c:	50                   	push   %eax
80105f5d:	68 75 8c 10 80       	push   $0x80108c75
80105f62:	ff 75 f0             	push   -0x10(%ebp)
80105f65:	e8 36 c3 ff ff       	call   801022a0 <dirlink>
80105f6a:	83 c4 10             	add    $0x10,%esp
80105f6d:	85 c0                	test   %eax,%eax
80105f6f:	78 1e                	js     80105f8f <create+0x188>
80105f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f74:	8b 40 04             	mov    0x4(%eax),%eax
80105f77:	83 ec 04             	sub    $0x4,%esp
80105f7a:	50                   	push   %eax
80105f7b:	68 77 8c 10 80       	push   $0x80108c77
80105f80:	ff 75 f0             	push   -0x10(%ebp)
80105f83:	e8 18 c3 ff ff       	call   801022a0 <dirlink>
80105f88:	83 c4 10             	add    $0x10,%esp
80105f8b:	85 c0                	test   %eax,%eax
80105f8d:	79 0d                	jns    80105f9c <create+0x195>
      panic("create dots");
80105f8f:	83 ec 0c             	sub    $0xc,%esp
80105f92:	68 aa 8c 10 80       	push   $0x80108caa
80105f97:	e8 df a5 ff ff       	call   8010057b <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
80105f9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f9f:	8b 40 04             	mov    0x4(%eax),%eax
80105fa2:	83 ec 04             	sub    $0x4,%esp
80105fa5:	50                   	push   %eax
80105fa6:	8d 45 de             	lea    -0x22(%ebp),%eax
80105fa9:	50                   	push   %eax
80105faa:	ff 75 f4             	push   -0xc(%ebp)
80105fad:	e8 ee c2 ff ff       	call   801022a0 <dirlink>
80105fb2:	83 c4 10             	add    $0x10,%esp
80105fb5:	85 c0                	test   %eax,%eax
80105fb7:	79 0d                	jns    80105fc6 <create+0x1bf>
    panic("create: dirlink");
80105fb9:	83 ec 0c             	sub    $0xc,%esp
80105fbc:	68 b6 8c 10 80       	push   $0x80108cb6
80105fc1:	e8 b5 a5 ff ff       	call   8010057b <panic>

  iunlockput(dp);
80105fc6:	83 ec 0c             	sub    $0xc,%esp
80105fc9:	ff 75 f4             	push   -0xc(%ebp)
80105fcc:	e8 76 bc ff ff       	call   80101c47 <iunlockput>
80105fd1:	83 c4 10             	add    $0x10,%esp

  return ip;
80105fd4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80105fd7:	c9                   	leave  
80105fd8:	c3                   	ret    

80105fd9 <sys_open>:

int
sys_open(void)
{
80105fd9:	55                   	push   %ebp
80105fda:	89 e5                	mov    %esp,%ebp
80105fdc:	83 ec 28             	sub    $0x28,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105fdf:	83 ec 08             	sub    $0x8,%esp
80105fe2:	8d 45 e8             	lea    -0x18(%ebp),%eax
80105fe5:	50                   	push   %eax
80105fe6:	6a 00                	push   $0x0
80105fe8:	e8 e9 f6 ff ff       	call   801056d6 <argstr>
80105fed:	83 c4 10             	add    $0x10,%esp
80105ff0:	85 c0                	test   %eax,%eax
80105ff2:	78 15                	js     80106009 <sys_open+0x30>
80105ff4:	83 ec 08             	sub    $0x8,%esp
80105ff7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105ffa:	50                   	push   %eax
80105ffb:	6a 01                	push   $0x1
80105ffd:	e8 4f f6 ff ff       	call   80105651 <argint>
80106002:	83 c4 10             	add    $0x10,%esp
80106005:	85 c0                	test   %eax,%eax
80106007:	79 0a                	jns    80106013 <sys_open+0x3a>
    return -1;
80106009:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010600e:	e9 61 01 00 00       	jmp    80106174 <sys_open+0x19b>

  begin_op();
80106013:	e8 5e d5 ff ff       	call   80103576 <begin_op>

  if(omode & O_CREATE){
80106018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010601b:	25 00 02 00 00       	and    $0x200,%eax
80106020:	85 c0                	test   %eax,%eax
80106022:	74 2a                	je     8010604e <sys_open+0x75>
    ip = create(path, T_FILE, 0, 0);
80106024:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106027:	6a 00                	push   $0x0
80106029:	6a 00                	push   $0x0
8010602b:	6a 02                	push   $0x2
8010602d:	50                   	push   %eax
8010602e:	e8 d4 fd ff ff       	call   80105e07 <create>
80106033:	83 c4 10             	add    $0x10,%esp
80106036:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
80106039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010603d:	75 75                	jne    801060b4 <sys_open+0xdb>
      end_op();
8010603f:	e8 be d5 ff ff       	call   80103602 <end_op>
      return -1;
80106044:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106049:	e9 26 01 00 00       	jmp    80106174 <sys_open+0x19b>
    }
  } else {
    if((ip = namei(path)) == 0){
8010604e:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106051:	83 ec 0c             	sub    $0xc,%esp
80106054:	50                   	push   %eax
80106055:	e8 de c4 ff ff       	call   80102538 <namei>
8010605a:	83 c4 10             	add    $0x10,%esp
8010605d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106060:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106064:	75 0f                	jne    80106075 <sys_open+0x9c>
      end_op();
80106066:	e8 97 d5 ff ff       	call   80103602 <end_op>
      return -1;
8010606b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106070:	e9 ff 00 00 00       	jmp    80106174 <sys_open+0x19b>
    }
    ilock(ip);
80106075:	83 ec 0c             	sub    $0xc,%esp
80106078:	ff 75 f4             	push   -0xc(%ebp)
8010607b:	e8 07 b9 ff ff       	call   80101987 <ilock>
80106080:	83 c4 10             	add    $0x10,%esp
    if(ip->type == T_DIR && omode != O_RDONLY){
80106083:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106086:	0f b7 40 10          	movzwl 0x10(%eax),%eax
8010608a:	66 83 f8 01          	cmp    $0x1,%ax
8010608e:	75 24                	jne    801060b4 <sys_open+0xdb>
80106090:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106093:	85 c0                	test   %eax,%eax
80106095:	74 1d                	je     801060b4 <sys_open+0xdb>
      iunlockput(ip);
80106097:	83 ec 0c             	sub    $0xc,%esp
8010609a:	ff 75 f4             	push   -0xc(%ebp)
8010609d:	e8 a5 bb ff ff       	call   80101c47 <iunlockput>
801060a2:	83 c4 10             	add    $0x10,%esp
      end_op();
801060a5:	e8 58 d5 ff ff       	call   80103602 <end_op>
      return -1;
801060aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060af:	e9 c0 00 00 00       	jmp    80106174 <sys_open+0x19b>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
801060b4:	e8 07 af ff ff       	call   80100fc0 <filealloc>
801060b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
801060bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060c0:	74 17                	je     801060d9 <sys_open+0x100>
801060c2:	83 ec 0c             	sub    $0xc,%esp
801060c5:	ff 75 f0             	push   -0x10(%ebp)
801060c8:	e8 34 f7 ff ff       	call   80105801 <fdalloc>
801060cd:	83 c4 10             	add    $0x10,%esp
801060d0:	89 45 ec             	mov    %eax,-0x14(%ebp)
801060d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801060d7:	79 2e                	jns    80106107 <sys_open+0x12e>
    if(f)
801060d9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801060dd:	74 0e                	je     801060ed <sys_open+0x114>
      fileclose(f);
801060df:	83 ec 0c             	sub    $0xc,%esp
801060e2:	ff 75 f0             	push   -0x10(%ebp)
801060e5:	e8 94 af ff ff       	call   8010107e <fileclose>
801060ea:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801060ed:	83 ec 0c             	sub    $0xc,%esp
801060f0:	ff 75 f4             	push   -0xc(%ebp)
801060f3:	e8 4f bb ff ff       	call   80101c47 <iunlockput>
801060f8:	83 c4 10             	add    $0x10,%esp
    end_op();
801060fb:	e8 02 d5 ff ff       	call   80103602 <end_op>
    return -1;
80106100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106105:	eb 6d                	jmp    80106174 <sys_open+0x19b>
  }
  iunlock(ip);
80106107:	83 ec 0c             	sub    $0xc,%esp
8010610a:	ff 75 f4             	push   -0xc(%ebp)
8010610d:	e8 d3 b9 ff ff       	call   80101ae5 <iunlock>
80106112:	83 c4 10             	add    $0x10,%esp
  end_op();
80106115:	e8 e8 d4 ff ff       	call   80103602 <end_op>

  f->type = FD_INODE;
8010611a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010611d:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106123:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106126:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106129:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
8010612c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010612f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106136:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106139:	83 e0 01             	and    $0x1,%eax
8010613c:	85 c0                	test   %eax,%eax
8010613e:	0f 94 c0             	sete   %al
80106141:	89 c2                	mov    %eax,%edx
80106143:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106146:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106149:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010614c:	83 e0 01             	and    $0x1,%eax
8010614f:	85 c0                	test   %eax,%eax
80106151:	75 0a                	jne    8010615d <sys_open+0x184>
80106153:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106156:	83 e0 02             	and    $0x2,%eax
80106159:	85 c0                	test   %eax,%eax
8010615b:	74 07                	je     80106164 <sys_open+0x18b>
8010615d:	b8 01 00 00 00       	mov    $0x1,%eax
80106162:	eb 05                	jmp    80106169 <sys_open+0x190>
80106164:	b8 00 00 00 00       	mov    $0x0,%eax
80106169:	89 c2                	mov    %eax,%edx
8010616b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010616e:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
80106171:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
80106174:	c9                   	leave  
80106175:	c3                   	ret    

80106176 <sys_mkdir>:

int
sys_mkdir(void)
{
80106176:	55                   	push   %ebp
80106177:	89 e5                	mov    %esp,%ebp
80106179:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
8010617c:	e8 f5 d3 ff ff       	call   80103576 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80106181:	83 ec 08             	sub    $0x8,%esp
80106184:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106187:	50                   	push   %eax
80106188:	6a 00                	push   $0x0
8010618a:	e8 47 f5 ff ff       	call   801056d6 <argstr>
8010618f:	83 c4 10             	add    $0x10,%esp
80106192:	85 c0                	test   %eax,%eax
80106194:	78 1b                	js     801061b1 <sys_mkdir+0x3b>
80106196:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106199:	6a 00                	push   $0x0
8010619b:	6a 00                	push   $0x0
8010619d:	6a 01                	push   $0x1
8010619f:	50                   	push   %eax
801061a0:	e8 62 fc ff ff       	call   80105e07 <create>
801061a5:	83 c4 10             	add    $0x10,%esp
801061a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061af:	75 0c                	jne    801061bd <sys_mkdir+0x47>
    end_op();
801061b1:	e8 4c d4 ff ff       	call   80103602 <end_op>
    return -1;
801061b6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801061bb:	eb 18                	jmp    801061d5 <sys_mkdir+0x5f>
  }
  iunlockput(ip);
801061bd:	83 ec 0c             	sub    $0xc,%esp
801061c0:	ff 75 f4             	push   -0xc(%ebp)
801061c3:	e8 7f ba ff ff       	call   80101c47 <iunlockput>
801061c8:	83 c4 10             	add    $0x10,%esp
  end_op();
801061cb:	e8 32 d4 ff ff       	call   80103602 <end_op>
  return 0;
801061d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
801061d5:	c9                   	leave  
801061d6:	c3                   	ret    

801061d7 <sys_mknod>:

int
sys_mknod(void)
{
801061d7:	55                   	push   %ebp
801061d8:	89 e5                	mov    %esp,%ebp
801061da:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
801061dd:	e8 94 d3 ff ff       	call   80103576 <begin_op>
  if((len=argstr(0, &path)) < 0 ||
801061e2:	83 ec 08             	sub    $0x8,%esp
801061e5:	8d 45 ec             	lea    -0x14(%ebp),%eax
801061e8:	50                   	push   %eax
801061e9:	6a 00                	push   $0x0
801061eb:	e8 e6 f4 ff ff       	call   801056d6 <argstr>
801061f0:	83 c4 10             	add    $0x10,%esp
801061f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
801061f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801061fa:	78 4f                	js     8010624b <sys_mknod+0x74>
     argint(1, &major) < 0 ||
801061fc:	83 ec 08             	sub    $0x8,%esp
801061ff:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106202:	50                   	push   %eax
80106203:	6a 01                	push   $0x1
80106205:	e8 47 f4 ff ff       	call   80105651 <argint>
8010620a:	83 c4 10             	add    $0x10,%esp
  if((len=argstr(0, &path)) < 0 ||
8010620d:	85 c0                	test   %eax,%eax
8010620f:	78 3a                	js     8010624b <sys_mknod+0x74>
     argint(2, &minor) < 0 ||
80106211:	83 ec 08             	sub    $0x8,%esp
80106214:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106217:	50                   	push   %eax
80106218:	6a 02                	push   $0x2
8010621a:	e8 32 f4 ff ff       	call   80105651 <argint>
8010621f:	83 c4 10             	add    $0x10,%esp
     argint(1, &major) < 0 ||
80106222:	85 c0                	test   %eax,%eax
80106224:	78 25                	js     8010624b <sys_mknod+0x74>
     (ip = create(path, T_DEV, major, minor)) == 0){
80106226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106229:	0f bf c8             	movswl %ax,%ecx
8010622c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010622f:	0f bf d0             	movswl %ax,%edx
80106232:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106235:	51                   	push   %ecx
80106236:	52                   	push   %edx
80106237:	6a 03                	push   $0x3
80106239:	50                   	push   %eax
8010623a:	e8 c8 fb ff ff       	call   80105e07 <create>
8010623f:	83 c4 10             	add    $0x10,%esp
80106242:	89 45 f0             	mov    %eax,-0x10(%ebp)
     argint(2, &minor) < 0 ||
80106245:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106249:	75 0c                	jne    80106257 <sys_mknod+0x80>
    end_op();
8010624b:	e8 b2 d3 ff ff       	call   80103602 <end_op>
    return -1;
80106250:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106255:	eb 18                	jmp    8010626f <sys_mknod+0x98>
  }
  iunlockput(ip);
80106257:	83 ec 0c             	sub    $0xc,%esp
8010625a:	ff 75 f0             	push   -0x10(%ebp)
8010625d:	e8 e5 b9 ff ff       	call   80101c47 <iunlockput>
80106262:	83 c4 10             	add    $0x10,%esp
  end_op();
80106265:	e8 98 d3 ff ff       	call   80103602 <end_op>
  return 0;
8010626a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010626f:	c9                   	leave  
80106270:	c3                   	ret    

80106271 <sys_chdir>:

int
sys_chdir(void)
{
80106271:	55                   	push   %ebp
80106272:	89 e5                	mov    %esp,%ebp
80106274:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80106277:	e8 fa d2 ff ff       	call   80103576 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
8010627c:	83 ec 08             	sub    $0x8,%esp
8010627f:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106282:	50                   	push   %eax
80106283:	6a 00                	push   $0x0
80106285:	e8 4c f4 ff ff       	call   801056d6 <argstr>
8010628a:	83 c4 10             	add    $0x10,%esp
8010628d:	85 c0                	test   %eax,%eax
8010628f:	78 18                	js     801062a9 <sys_chdir+0x38>
80106291:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106294:	83 ec 0c             	sub    $0xc,%esp
80106297:	50                   	push   %eax
80106298:	e8 9b c2 ff ff       	call   80102538 <namei>
8010629d:	83 c4 10             	add    $0x10,%esp
801062a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801062a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801062a7:	75 0c                	jne    801062b5 <sys_chdir+0x44>
    end_op();
801062a9:	e8 54 d3 ff ff       	call   80103602 <end_op>
    return -1;
801062ae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062b3:	eb 6e                	jmp    80106323 <sys_chdir+0xb2>
  }
  ilock(ip);
801062b5:	83 ec 0c             	sub    $0xc,%esp
801062b8:	ff 75 f4             	push   -0xc(%ebp)
801062bb:	e8 c7 b6 ff ff       	call   80101987 <ilock>
801062c0:	83 c4 10             	add    $0x10,%esp
  if(ip->type != T_DIR){
801062c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c6:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062ca:	66 83 f8 01          	cmp    $0x1,%ax
801062ce:	74 1a                	je     801062ea <sys_chdir+0x79>
    iunlockput(ip);
801062d0:	83 ec 0c             	sub    $0xc,%esp
801062d3:	ff 75 f4             	push   -0xc(%ebp)
801062d6:	e8 6c b9 ff ff       	call   80101c47 <iunlockput>
801062db:	83 c4 10             	add    $0x10,%esp
    end_op();
801062de:	e8 1f d3 ff ff       	call   80103602 <end_op>
    return -1;
801062e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801062e8:	eb 39                	jmp    80106323 <sys_chdir+0xb2>
  }
  iunlock(ip);
801062ea:	83 ec 0c             	sub    $0xc,%esp
801062ed:	ff 75 f4             	push   -0xc(%ebp)
801062f0:	e8 f0 b7 ff ff       	call   80101ae5 <iunlock>
801062f5:	83 c4 10             	add    $0x10,%esp
  iput(proc->cwd);
801062f8:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801062fe:	8b 40 68             	mov    0x68(%eax),%eax
80106301:	83 ec 0c             	sub    $0xc,%esp
80106304:	50                   	push   %eax
80106305:	e8 4d b8 ff ff       	call   80101b57 <iput>
8010630a:	83 c4 10             	add    $0x10,%esp
  end_op();
8010630d:	e8 f0 d2 ff ff       	call   80103602 <end_op>
  proc->cwd = ip;
80106312:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106318:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010631b:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010631e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106323:	c9                   	leave  
80106324:	c3                   	ret    

80106325 <sys_exec>:

int
sys_exec(void)
{
80106325:	55                   	push   %ebp
80106326:	89 e5                	mov    %esp,%ebp
80106328:	81 ec 98 00 00 00    	sub    $0x98,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010632e:	83 ec 08             	sub    $0x8,%esp
80106331:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106334:	50                   	push   %eax
80106335:	6a 00                	push   $0x0
80106337:	e8 9a f3 ff ff       	call   801056d6 <argstr>
8010633c:	83 c4 10             	add    $0x10,%esp
8010633f:	85 c0                	test   %eax,%eax
80106341:	78 18                	js     8010635b <sys_exec+0x36>
80106343:	83 ec 08             	sub    $0x8,%esp
80106346:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
8010634c:	50                   	push   %eax
8010634d:	6a 01                	push   $0x1
8010634f:	e8 fd f2 ff ff       	call   80105651 <argint>
80106354:	83 c4 10             	add    $0x10,%esp
80106357:	85 c0                	test   %eax,%eax
80106359:	79 0a                	jns    80106365 <sys_exec+0x40>
    return -1;
8010635b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106360:	e9 c6 00 00 00       	jmp    8010642b <sys_exec+0x106>
  }
  memset(argv, 0, sizeof(argv));
80106365:	83 ec 04             	sub    $0x4,%esp
80106368:	68 80 00 00 00       	push   $0x80
8010636d:	6a 00                	push   $0x0
8010636f:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80106375:	50                   	push   %eax
80106376:	e8 b2 ef ff ff       	call   8010532d <memset>
8010637b:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
8010637e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
80106385:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106388:	83 f8 1f             	cmp    $0x1f,%eax
8010638b:	76 0a                	jbe    80106397 <sys_exec+0x72>
      return -1;
8010638d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106392:	e9 94 00 00 00       	jmp    8010642b <sys_exec+0x106>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80106397:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010639a:	c1 e0 02             	shl    $0x2,%eax
8010639d:	89 c2                	mov    %eax,%edx
8010639f:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
801063a5:	01 c2                	add    %eax,%edx
801063a7:	83 ec 08             	sub    $0x8,%esp
801063aa:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801063b0:	50                   	push   %eax
801063b1:	52                   	push   %edx
801063b2:	e8 00 f2 ff ff       	call   801055b7 <fetchint>
801063b7:	83 c4 10             	add    $0x10,%esp
801063ba:	85 c0                	test   %eax,%eax
801063bc:	79 07                	jns    801063c5 <sys_exec+0xa0>
      return -1;
801063be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063c3:	eb 66                	jmp    8010642b <sys_exec+0x106>
    if(uarg == 0){
801063c5:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
801063cb:	85 c0                	test   %eax,%eax
801063cd:	75 27                	jne    801063f6 <sys_exec+0xd1>
      argv[i] = 0;
801063cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063d2:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
801063d9:	00 00 00 00 
      break;
801063dd:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801063de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063e1:	83 ec 08             	sub    $0x8,%esp
801063e4:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801063ea:	52                   	push   %edx
801063eb:	50                   	push   %eax
801063ec:	e8 ad a7 ff ff       	call   80100b9e <exec>
801063f1:	83 c4 10             	add    $0x10,%esp
801063f4:	eb 35                	jmp    8010642b <sys_exec+0x106>
    if(fetchstr(uarg, &argv[i]) < 0)
801063f6:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
801063fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ff:	c1 e0 02             	shl    $0x2,%eax
80106402:	01 c2                	add    %eax,%edx
80106404:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010640a:	83 ec 08             	sub    $0x8,%esp
8010640d:	52                   	push   %edx
8010640e:	50                   	push   %eax
8010640f:	e8 dd f1 ff ff       	call   801055f1 <fetchstr>
80106414:	83 c4 10             	add    $0x10,%esp
80106417:	85 c0                	test   %eax,%eax
80106419:	79 07                	jns    80106422 <sys_exec+0xfd>
      return -1;
8010641b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106420:	eb 09                	jmp    8010642b <sys_exec+0x106>
  for(i=0;; i++){
80106422:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
    if(i >= NELEM(argv))
80106426:	e9 5a ff ff ff       	jmp    80106385 <sys_exec+0x60>
}
8010642b:	c9                   	leave  
8010642c:	c3                   	ret    

8010642d <sys_pipe>:

int
sys_pipe(void)
{
8010642d:	55                   	push   %ebp
8010642e:	89 e5                	mov    %esp,%ebp
80106430:	83 ec 28             	sub    $0x28,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106433:	83 ec 04             	sub    $0x4,%esp
80106436:	6a 08                	push   $0x8
80106438:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010643b:	50                   	push   %eax
8010643c:	6a 00                	push   $0x0
8010643e:	e8 36 f2 ff ff       	call   80105679 <argptr>
80106443:	83 c4 10             	add    $0x10,%esp
80106446:	85 c0                	test   %eax,%eax
80106448:	79 0a                	jns    80106454 <sys_pipe+0x27>
    return -1;
8010644a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010644f:	e9 af 00 00 00       	jmp    80106503 <sys_pipe+0xd6>
  if(pipealloc(&rf, &wf) < 0)
80106454:	83 ec 08             	sub    $0x8,%esp
80106457:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010645a:	50                   	push   %eax
8010645b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010645e:	50                   	push   %eax
8010645f:	e8 24 dc ff ff       	call   80104088 <pipealloc>
80106464:	83 c4 10             	add    $0x10,%esp
80106467:	85 c0                	test   %eax,%eax
80106469:	79 0a                	jns    80106475 <sys_pipe+0x48>
    return -1;
8010646b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106470:	e9 8e 00 00 00       	jmp    80106503 <sys_pipe+0xd6>
  fd0 = -1;
80106475:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010647c:	8b 45 e8             	mov    -0x18(%ebp),%eax
8010647f:	83 ec 0c             	sub    $0xc,%esp
80106482:	50                   	push   %eax
80106483:	e8 79 f3 ff ff       	call   80105801 <fdalloc>
80106488:	83 c4 10             	add    $0x10,%esp
8010648b:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010648e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106492:	78 18                	js     801064ac <sys_pipe+0x7f>
80106494:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106497:	83 ec 0c             	sub    $0xc,%esp
8010649a:	50                   	push   %eax
8010649b:	e8 61 f3 ff ff       	call   80105801 <fdalloc>
801064a0:	83 c4 10             	add    $0x10,%esp
801064a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
801064a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801064aa:	79 3f                	jns    801064eb <sys_pipe+0xbe>
    if(fd0 >= 0)
801064ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064b0:	78 14                	js     801064c6 <sys_pipe+0x99>
      proc->ofile[fd0] = 0;
801064b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801064b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064bb:	83 c2 08             	add    $0x8,%edx
801064be:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801064c5:	00 
    fileclose(rf);
801064c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064c9:	83 ec 0c             	sub    $0xc,%esp
801064cc:	50                   	push   %eax
801064cd:	e8 ac ab ff ff       	call   8010107e <fileclose>
801064d2:	83 c4 10             	add    $0x10,%esp
    fileclose(wf);
801064d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064d8:	83 ec 0c             	sub    $0xc,%esp
801064db:	50                   	push   %eax
801064dc:	e8 9d ab ff ff       	call   8010107e <fileclose>
801064e1:	83 c4 10             	add    $0x10,%esp
    return -1;
801064e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064e9:	eb 18                	jmp    80106503 <sys_pipe+0xd6>
  }
  fd[0] = fd0;
801064eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064ee:	8b 55 f4             	mov    -0xc(%ebp),%edx
801064f1:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
801064f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
801064f6:	8d 50 04             	lea    0x4(%eax),%edx
801064f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801064fc:	89 02                	mov    %eax,(%edx)
  return 0;
801064fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106503:	c9                   	leave  
80106504:	c3                   	ret    

80106505 <sys_fork>:
extern uint ticks;


int
sys_fork(void)
{
80106505:	55                   	push   %ebp
80106506:	89 e5                	mov    %esp,%ebp
80106508:	83 ec 08             	sub    $0x8,%esp
  return fork();
8010650b:	e8 d0 e2 ff ff       	call   801047e0 <fork>
}
80106510:	c9                   	leave  
80106511:	c3                   	ret    

80106512 <sys_exit>:

int
sys_exit(void)
{
80106512:	55                   	push   %ebp
80106513:	89 e5                	mov    %esp,%ebp
80106515:	83 ec 08             	sub    $0x8,%esp
  exit();
80106518:	e8 50 e4 ff ff       	call   8010496d <exit>
  return 0;  // not reached
8010651d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106522:	c9                   	leave  
80106523:	c3                   	ret    

80106524 <sys_wait>:

int
sys_wait(void)
{
80106524:	55                   	push   %ebp
80106525:	89 e5                	mov    %esp,%ebp
80106527:	83 ec 08             	sub    $0x8,%esp
  return wait();
8010652a:	e8 76 e5 ff ff       	call   80104aa5 <wait>
}
8010652f:	c9                   	leave  
80106530:	c3                   	ret    

80106531 <sys_kill>:

int
sys_kill(void)
{
80106531:	55                   	push   %ebp
80106532:	89 e5                	mov    %esp,%ebp
80106534:	83 ec 18             	sub    $0x18,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106537:	83 ec 08             	sub    $0x8,%esp
8010653a:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010653d:	50                   	push   %eax
8010653e:	6a 00                	push   $0x0
80106540:	e8 0c f1 ff ff       	call   80105651 <argint>
80106545:	83 c4 10             	add    $0x10,%esp
80106548:	85 c0                	test   %eax,%eax
8010654a:	79 07                	jns    80106553 <sys_kill+0x22>
    return -1;
8010654c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106551:	eb 0f                	jmp    80106562 <sys_kill+0x31>
  return kill(pid);
80106553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106556:	83 ec 0c             	sub    $0xc,%esp
80106559:	50                   	push   %eax
8010655a:	e8 93 e9 ff ff       	call   80104ef2 <kill>
8010655f:	83 c4 10             	add    $0x10,%esp
}
80106562:	c9                   	leave  
80106563:	c3                   	ret    

80106564 <sys_getpid>:

int
sys_getpid(void)
{
80106564:	55                   	push   %ebp
80106565:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106567:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010656d:	8b 40 10             	mov    0x10(%eax),%eax
}
80106570:	5d                   	pop    %ebp
80106571:	c3                   	ret    

80106572 <sys_sbrk>:

int
sys_sbrk(void)
{
80106572:	55                   	push   %ebp
80106573:	89 e5                	mov    %esp,%ebp
80106575:	83 ec 18             	sub    $0x18,%esp
  int n;
  if(argint(0, &n) < 0)
80106578:	83 ec 08             	sub    $0x8,%esp
8010657b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010657e:	50                   	push   %eax
8010657f:	6a 00                	push   $0x0
80106581:	e8 cb f0 ff ff       	call   80105651 <argint>
80106586:	83 c4 10             	add    $0x10,%esp
80106589:	85 c0                	test   %eax,%eax
8010658b:	79 07                	jns    80106594 <sys_sbrk+0x22>
    return -1;
8010658d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106592:	eb 28                	jmp    801065bc <sys_sbrk+0x4a>

  int oldsz = proc->sz;
80106594:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010659a:	8b 00                	mov    (%eax),%eax
8010659c:	89 45 f4             	mov    %eax,-0xc(%ebp)

  if(growproc(n) < 0)
8010659f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065a2:	83 ec 0c             	sub    $0xc,%esp
801065a5:	50                   	push   %eax
801065a6:	e8 6e e1 ff ff       	call   80104719 <growproc>
801065ab:	83 c4 10             	add    $0x10,%esp
801065ae:	85 c0                	test   %eax,%eax
801065b0:	79 07                	jns    801065b9 <sys_sbrk+0x47>
    return -1;
801065b2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065b7:	eb 03                	jmp    801065bc <sys_sbrk+0x4a>

  return oldsz;
801065b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801065bc:	c9                   	leave  
801065bd:	c3                   	ret    

801065be <sys_sleep>:

int
sys_sleep(void)
{
801065be:	55                   	push   %ebp
801065bf:	89 e5                	mov    %esp,%ebp
801065c1:	83 ec 18             	sub    $0x18,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
801065c4:	83 ec 08             	sub    $0x8,%esp
801065c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065ca:	50                   	push   %eax
801065cb:	6a 00                	push   $0x0
801065cd:	e8 7f f0 ff ff       	call   80105651 <argint>
801065d2:	83 c4 10             	add    $0x10,%esp
801065d5:	85 c0                	test   %eax,%eax
801065d7:	79 07                	jns    801065e0 <sys_sleep+0x22>
    return -1;
801065d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801065de:	eb 77                	jmp    80106657 <sys_sleep+0x99>
  acquire(&tickslock);
801065e0:	83 ec 0c             	sub    $0xc,%esp
801065e3:	68 c0 40 11 80       	push   $0x801140c0
801065e8:	e8 dd ea ff ff       	call   801050ca <acquire>
801065ed:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
801065f0:	a1 f4 40 11 80       	mov    0x801140f4,%eax
801065f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
801065f8:	eb 39                	jmp    80106633 <sys_sleep+0x75>
    if(proc->killed){
801065fa:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106600:	8b 40 24             	mov    0x24(%eax),%eax
80106603:	85 c0                	test   %eax,%eax
80106605:	74 17                	je     8010661e <sys_sleep+0x60>
      release(&tickslock);
80106607:	83 ec 0c             	sub    $0xc,%esp
8010660a:	68 c0 40 11 80       	push   $0x801140c0
8010660f:	e8 1d eb ff ff       	call   80105131 <release>
80106614:	83 c4 10             	add    $0x10,%esp
      return -1;
80106617:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010661c:	eb 39                	jmp    80106657 <sys_sleep+0x99>
    }
    sleep(&ticks, &tickslock);
8010661e:	83 ec 08             	sub    $0x8,%esp
80106621:	68 c0 40 11 80       	push   $0x801140c0
80106626:	68 f4 40 11 80       	push   $0x801140f4
8010662b:	e8 9f e7 ff ff       	call   80104dcf <sleep>
80106630:	83 c4 10             	add    $0x10,%esp
  while(ticks - ticks0 < n){
80106633:	a1 f4 40 11 80       	mov    0x801140f4,%eax
80106638:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010663b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010663e:	39 d0                	cmp    %edx,%eax
80106640:	72 b8                	jb     801065fa <sys_sleep+0x3c>
  }
  release(&tickslock);
80106642:	83 ec 0c             	sub    $0xc,%esp
80106645:	68 c0 40 11 80       	push   $0x801140c0
8010664a:	e8 e2 ea ff ff       	call   80105131 <release>
8010664f:	83 c4 10             	add    $0x10,%esp
  return 0;
80106652:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106657:	c9                   	leave  
80106658:	c3                   	ret    

80106659 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106659:	55                   	push   %ebp
8010665a:	89 e5                	mov    %esp,%ebp
8010665c:	83 ec 18             	sub    $0x18,%esp
  uint xticks;
  
  acquire(&tickslock);
8010665f:	83 ec 0c             	sub    $0xc,%esp
80106662:	68 c0 40 11 80       	push   $0x801140c0
80106667:	e8 5e ea ff ff       	call   801050ca <acquire>
8010666c:	83 c4 10             	add    $0x10,%esp
  xticks = ticks;
8010666f:	a1 f4 40 11 80       	mov    0x801140f4,%eax
80106674:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106677:	83 ec 0c             	sub    $0xc,%esp
8010667a:	68 c0 40 11 80       	push   $0x801140c0
8010667f:	e8 ad ea ff ff       	call   80105131 <release>
80106684:	83 c4 10             	add    $0x10,%esp
  return xticks;
80106687:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010668a:	c9                   	leave  
8010668b:	c3                   	ret    

8010668c <sys_print_free_frame_cnt>:

// CS 3320 print out free frames
int sys_print_free_frame_cnt(void)
{
8010668c:	55                   	push   %ebp
8010668d:	89 e5                	mov    %esp,%ebp
8010668f:	83 ec 08             	sub    $0x8,%esp
    cprintf("free-frames %d\n", free_frame_cnt);
80106692:	a1 00 12 11 80       	mov    0x80111200,%eax
80106697:	83 ec 08             	sub    $0x8,%esp
8010669a:	50                   	push   %eax
8010669b:	68 c8 8c 10 80       	push   $0x80108cc8
801066a0:	e8 21 9d ff ff       	call   801003c6 <cprintf>
801066a5:	83 c4 10             	add    $0x10,%esp
    return 0;
801066a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066ad:	c9                   	leave  
801066ae:	c3                   	ret    

801066af <sys_set_page_allocator>:
// CS 3320 set page allocator
extern int page_allocator_type;

int
sys_set_page_allocator(void)
{
801066af:	55                   	push   %ebp
801066b0:	89 e5                	mov    %esp,%ebp
801066b2:	83 ec 18             	sub    $0x18,%esp
  int a;

  // get the argument from user space
  if(argint(0, &a) < 0)
801066b5:	83 ec 08             	sub    $0x8,%esp
801066b8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801066bb:	50                   	push   %eax
801066bc:	6a 00                	push   $0x0
801066be:	e8 8e ef ff ff       	call   80105651 <argint>
801066c3:	83 c4 10             	add    $0x10,%esp
801066c6:	85 c0                	test   %eax,%eax
801066c8:	79 07                	jns    801066d1 <sys_set_page_allocator+0x22>
    return -1;
801066ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066cf:	eb 23                	jmp    801066f4 <sys_set_page_allocator+0x45>

  // we only support 0 (DEFAULT) and 1 (LAZY)
  if(a != 0 && a != 1)
801066d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066d4:	85 c0                	test   %eax,%eax
801066d6:	74 0f                	je     801066e7 <sys_set_page_allocator+0x38>
801066d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066db:	83 f8 01             	cmp    $0x1,%eax
801066de:	74 07                	je     801066e7 <sys_set_page_allocator+0x38>
    return -1;
801066e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066e5:	eb 0d                	jmp    801066f4 <sys_set_page_allocator+0x45>

  page_allocator_type = a;
801066e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801066ea:	a3 60 19 11 80       	mov    %eax,0x80111960
  return 0;
801066ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066f4:	c9                   	leave  
801066f5:	c3                   	ret    

801066f6 <sys_shmget>:

// CS 3320 shared memory
int sys_shmget(void)
{
801066f6:	55                   	push   %ebp
801066f7:	89 e5                	mov    %esp,%ebp
801066f9:	83 ec 18             	sub    $0x18,%esp
    int shm_id;
    if(argint(0, &shm_id) < 0){
801066fc:	83 ec 08             	sub    $0x8,%esp
801066ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106702:	50                   	push   %eax
80106703:	6a 00                	push   $0x0
80106705:	e8 47 ef ff ff       	call   80105651 <argint>
8010670a:	83 c4 10             	add    $0x10,%esp
8010670d:	85 c0                	test   %eax,%eax
8010670f:	79 07                	jns    80106718 <sys_shmget+0x22>
        return -1;
80106711:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106716:	eb 15                	jmp    8010672d <sys_shmget+0x37>
    }
    cprintf("Your shared memory mechanism has not been implemented!\n");    
80106718:	83 ec 0c             	sub    $0xc,%esp
8010671b:	68 d8 8c 10 80       	push   $0x80108cd8
80106720:	e8 a1 9c ff ff       	call   801003c6 <cprintf>
80106725:	83 c4 10             	add    $0x10,%esp
    return 0;
80106728:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010672d:	c9                   	leave  
8010672e:	c3                   	ret    

8010672f <sys_shmdel>:

// delete a shared page
int sys_shmdel(void)
{
8010672f:	55                   	push   %ebp
80106730:	89 e5                	mov    %esp,%ebp
80106732:	83 ec 18             	sub    $0x18,%esp
    int shm_id;
    if(argint(0, &shm_id) < 0){
80106735:	83 ec 08             	sub    $0x8,%esp
80106738:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010673b:	50                   	push   %eax
8010673c:	6a 00                	push   $0x0
8010673e:	e8 0e ef ff ff       	call   80105651 <argint>
80106743:	83 c4 10             	add    $0x10,%esp
80106746:	85 c0                	test   %eax,%eax
80106748:	79 07                	jns    80106751 <sys_shmdel+0x22>
        return -1;
8010674a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674f:	eb 15                	jmp    80106766 <sys_shmdel+0x37>
    }
    cprintf("Your shared memory mechanims has not been implemented!\n");
80106751:	83 ec 0c             	sub    $0xc,%esp
80106754:	68 10 8d 10 80       	push   $0x80108d10
80106759:	e8 68 9c ff ff       	call   801003c6 <cprintf>
8010675e:	83 c4 10             	add    $0x10,%esp
    return 0;
80106761:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106766:	c9                   	leave  
80106767:	c3                   	ret    

80106768 <outb>:
{
80106768:	55                   	push   %ebp
80106769:	89 e5                	mov    %esp,%ebp
8010676b:	83 ec 08             	sub    $0x8,%esp
8010676e:	8b 45 08             	mov    0x8(%ebp),%eax
80106771:	8b 55 0c             	mov    0xc(%ebp),%edx
80106774:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106778:	89 d0                	mov    %edx,%eax
8010677a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010677d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106781:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106785:	ee                   	out    %al,(%dx)
}
80106786:	90                   	nop
80106787:	c9                   	leave  
80106788:	c3                   	ret    

80106789 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106789:	55                   	push   %ebp
8010678a:	89 e5                	mov    %esp,%ebp
8010678c:	83 ec 08             	sub    $0x8,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
8010678f:	6a 34                	push   $0x34
80106791:	6a 43                	push   $0x43
80106793:	e8 d0 ff ff ff       	call   80106768 <outb>
80106798:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
8010679b:	68 9c 00 00 00       	push   $0x9c
801067a0:	6a 40                	push   $0x40
801067a2:	e8 c1 ff ff ff       	call   80106768 <outb>
801067a7:	83 c4 08             	add    $0x8,%esp
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
801067aa:	6a 2e                	push   $0x2e
801067ac:	6a 40                	push   $0x40
801067ae:	e8 b5 ff ff ff       	call   80106768 <outb>
801067b3:	83 c4 08             	add    $0x8,%esp
  picenable(IRQ_TIMER);
801067b6:	83 ec 0c             	sub    $0xc,%esp
801067b9:	6a 00                	push   $0x0
801067bb:	e8 b2 d7 ff ff       	call   80103f72 <picenable>
801067c0:	83 c4 10             	add    $0x10,%esp
}
801067c3:	90                   	nop
801067c4:	c9                   	leave  
801067c5:	c3                   	ret    

801067c6 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801067c6:	1e                   	push   %ds
  pushl %es
801067c7:	06                   	push   %es
  pushl %fs
801067c8:	0f a0                	push   %fs
  pushl %gs
801067ca:	0f a8                	push   %gs
  pushal
801067cc:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
801067cd:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801067d1:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801067d3:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
801067d5:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
801067d9:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
801067db:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
801067dd:	54                   	push   %esp
  call trap
801067de:	e8 d7 01 00 00       	call   801069ba <trap>
  addl $4, %esp
801067e3:	83 c4 04             	add    $0x4,%esp

801067e6 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801067e6:	61                   	popa   
  popl %gs
801067e7:	0f a9                	pop    %gs
  popl %fs
801067e9:	0f a1                	pop    %fs
  popl %es
801067eb:	07                   	pop    %es
  popl %ds
801067ec:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801067ed:	83 c4 08             	add    $0x8,%esp
  iret
801067f0:	cf                   	iret   

801067f1 <lidt>:
{
801067f1:	55                   	push   %ebp
801067f2:	89 e5                	mov    %esp,%ebp
801067f4:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801067f7:	8b 45 0c             	mov    0xc(%ebp),%eax
801067fa:	83 e8 01             	sub    $0x1,%eax
801067fd:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106801:	8b 45 08             	mov    0x8(%ebp),%eax
80106804:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106808:	8b 45 08             	mov    0x8(%ebp),%eax
8010680b:	c1 e8 10             	shr    $0x10,%eax
8010680e:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80106812:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106815:	0f 01 18             	lidtl  (%eax)
}
80106818:	90                   	nop
80106819:	c9                   	leave  
8010681a:	c3                   	ret    

8010681b <rcr2>:
{
8010681b:	55                   	push   %ebp
8010681c:	89 e5                	mov    %esp,%ebp
8010681e:	83 ec 10             	sub    $0x10,%esp
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106821:	0f 20 d0             	mov    %cr2,%eax
80106824:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106827:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010682a:	c9                   	leave  
8010682b:	c3                   	ret    

8010682c <tvinit>:

struct spinlock tickslock;
uint ticks;

void
tvinit(void){
8010682c:	55                   	push   %ebp
8010682d:	89 e5                	mov    %esp,%ebp
8010682f:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
80106832:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106839:	e9 c3 00 00 00       	jmp    80106901 <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
8010683e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106841:	8b 04 85 ac b0 10 80 	mov    -0x7fef4f54(,%eax,4),%eax
80106848:	89 c2                	mov    %eax,%edx
8010684a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010684d:	66 89 14 c5 c0 38 11 	mov    %dx,-0x7feec740(,%eax,8)
80106854:	80 
80106855:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106858:	66 c7 04 c5 c2 38 11 	movw   $0x8,-0x7feec73e(,%eax,8)
8010685f:	80 08 00 
80106862:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106865:	0f b6 14 c5 c4 38 11 	movzbl -0x7feec73c(,%eax,8),%edx
8010686c:	80 
8010686d:	83 e2 e0             	and    $0xffffffe0,%edx
80106870:	88 14 c5 c4 38 11 80 	mov    %dl,-0x7feec73c(,%eax,8)
80106877:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010687a:	0f b6 14 c5 c4 38 11 	movzbl -0x7feec73c(,%eax,8),%edx
80106881:	80 
80106882:	83 e2 1f             	and    $0x1f,%edx
80106885:	88 14 c5 c4 38 11 80 	mov    %dl,-0x7feec73c(,%eax,8)
8010688c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010688f:	0f b6 14 c5 c5 38 11 	movzbl -0x7feec73b(,%eax,8),%edx
80106896:	80 
80106897:	83 e2 f0             	and    $0xfffffff0,%edx
8010689a:	83 ca 0e             	or     $0xe,%edx
8010689d:	88 14 c5 c5 38 11 80 	mov    %dl,-0x7feec73b(,%eax,8)
801068a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068a7:	0f b6 14 c5 c5 38 11 	movzbl -0x7feec73b(,%eax,8),%edx
801068ae:	80 
801068af:	83 e2 ef             	and    $0xffffffef,%edx
801068b2:	88 14 c5 c5 38 11 80 	mov    %dl,-0x7feec73b(,%eax,8)
801068b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068bc:	0f b6 14 c5 c5 38 11 	movzbl -0x7feec73b(,%eax,8),%edx
801068c3:	80 
801068c4:	83 e2 9f             	and    $0xffffff9f,%edx
801068c7:	88 14 c5 c5 38 11 80 	mov    %dl,-0x7feec73b(,%eax,8)
801068ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068d1:	0f b6 14 c5 c5 38 11 	movzbl -0x7feec73b(,%eax,8),%edx
801068d8:	80 
801068d9:	83 ca 80             	or     $0xffffff80,%edx
801068dc:	88 14 c5 c5 38 11 80 	mov    %dl,-0x7feec73b(,%eax,8)
801068e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068e6:	8b 04 85 ac b0 10 80 	mov    -0x7fef4f54(,%eax,4),%eax
801068ed:	c1 e8 10             	shr    $0x10,%eax
801068f0:	89 c2                	mov    %eax,%edx
801068f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801068f5:	66 89 14 c5 c6 38 11 	mov    %dx,-0x7feec73a(,%eax,8)
801068fc:	80 
  for(i = 0; i < 256; i++)
801068fd:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106901:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106908:	0f 8e 30 ff ff ff    	jle    8010683e <tvinit+0x12>

  // System call gate
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010690e:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
80106913:	66 a3 c0 3a 11 80    	mov    %ax,0x80113ac0
80106919:	66 c7 05 c2 3a 11 80 	movw   $0x8,0x80113ac2
80106920:	08 00 
80106922:	0f b6 05 c4 3a 11 80 	movzbl 0x80113ac4,%eax
80106929:	83 e0 e0             	and    $0xffffffe0,%eax
8010692c:	a2 c4 3a 11 80       	mov    %al,0x80113ac4
80106931:	0f b6 05 c4 3a 11 80 	movzbl 0x80113ac4,%eax
80106938:	83 e0 1f             	and    $0x1f,%eax
8010693b:	a2 c4 3a 11 80       	mov    %al,0x80113ac4
80106940:	0f b6 05 c5 3a 11 80 	movzbl 0x80113ac5,%eax
80106947:	83 c8 0f             	or     $0xf,%eax
8010694a:	a2 c5 3a 11 80       	mov    %al,0x80113ac5
8010694f:	0f b6 05 c5 3a 11 80 	movzbl 0x80113ac5,%eax
80106956:	83 e0 ef             	and    $0xffffffef,%eax
80106959:	a2 c5 3a 11 80       	mov    %al,0x80113ac5
8010695e:	0f b6 05 c5 3a 11 80 	movzbl 0x80113ac5,%eax
80106965:	83 c8 60             	or     $0x60,%eax
80106968:	a2 c5 3a 11 80       	mov    %al,0x80113ac5
8010696d:	0f b6 05 c5 3a 11 80 	movzbl 0x80113ac5,%eax
80106974:	83 c8 80             	or     $0xffffff80,%eax
80106977:	a2 c5 3a 11 80       	mov    %al,0x80113ac5
8010697c:	a1 ac b1 10 80       	mov    0x8010b1ac,%eax
80106981:	c1 e8 10             	shr    $0x10,%eax
80106984:	66 a3 c6 3a 11 80    	mov    %ax,0x80113ac6

  initlock(&tickslock, "time");
8010698a:	83 ec 08             	sub    $0x8,%esp
8010698d:	68 48 8d 10 80       	push   $0x80108d48
80106992:	68 c0 40 11 80       	push   $0x801140c0
80106997:	e8 0c e7 ff ff       	call   801050a8 <initlock>
8010699c:	83 c4 10             	add    $0x10,%esp
}
8010699f:	90                   	nop
801069a0:	c9                   	leave  
801069a1:	c3                   	ret    

801069a2 <idtinit>:

void
idtinit(void)
{
801069a2:	55                   	push   %ebp
801069a3:	89 e5                	mov    %esp,%ebp
  lidt(idt, sizeof(idt));}
801069a5:	68 00 08 00 00       	push   $0x800
801069aa:	68 c0 38 11 80       	push   $0x801138c0
801069af:	e8 3d fe ff ff       	call   801067f1 <lidt>
801069b4:	83 c4 08             	add    $0x8,%esp
801069b7:	90                   	nop
801069b8:	c9                   	leave  
801069b9:	c3                   	ret    

801069ba <trap>:


void
trap(struct trapframe *tf)
{
801069ba:	55                   	push   %ebp
801069bb:	89 e5                	mov    %esp,%ebp
801069bd:	57                   	push   %edi
801069be:	56                   	push   %esi
801069bf:	53                   	push   %ebx
801069c0:	83 ec 2c             	sub    $0x2c,%esp
  // =============== SYSCALL HANDLING ===============
  if(tf->trapno == T_SYSCALL){
801069c3:	8b 45 08             	mov    0x8(%ebp),%eax
801069c6:	8b 40 30             	mov    0x30(%eax),%eax
801069c9:	83 f8 40             	cmp    $0x40,%eax
801069cc:	75 5a                	jne    80106a28 <trap+0x6e>
    if(myproc() && myproc()->killed)
801069ce:	e8 02 db ff ff       	call   801044d5 <myproc>
801069d3:	85 c0                	test   %eax,%eax
801069d5:	74 11                	je     801069e8 <trap+0x2e>
801069d7:	e8 f9 da ff ff       	call   801044d5 <myproc>
801069dc:	8b 40 24             	mov    0x24(%eax),%eax
801069df:	85 c0                	test   %eax,%eax
801069e1:	74 05                	je     801069e8 <trap+0x2e>
      exit();
801069e3:	e8 85 df ff ff       	call   8010496d <exit>
    if(myproc())
801069e8:	e8 e8 da ff ff       	call   801044d5 <myproc>
801069ed:	85 c0                	test   %eax,%eax
801069ef:	74 0b                	je     801069fc <trap+0x42>
      myproc()->tf = tf;
801069f1:	e8 df da ff ff       	call   801044d5 <myproc>
801069f6:	8b 55 08             	mov    0x8(%ebp),%edx
801069f9:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
801069fc:	e8 06 ed ff ff       	call   80105707 <syscall>
    if(myproc() && myproc()->killed)
80106a01:	e8 cf da ff ff       	call   801044d5 <myproc>
80106a06:	85 c0                	test   %eax,%eax
80106a08:	0f 84 4a 03 00 00    	je     80106d58 <trap+0x39e>
80106a0e:	e8 c2 da ff ff       	call   801044d5 <myproc>
80106a13:	8b 40 24             	mov    0x24(%eax),%eax
80106a16:	85 c0                	test   %eax,%eax
80106a18:	0f 84 3a 03 00 00    	je     80106d58 <trap+0x39e>
      exit();
80106a1e:	e8 4a df ff ff       	call   8010496d <exit>
    return;
80106a23:	e9 30 03 00 00       	jmp    80106d58 <trap+0x39e>
  }

  // =============== LAZY PAGE FAULT HANDLING ===============
   if (page_allocator_type == 1 && tf->trapno == T_PGFLT) {
80106a28:	a1 60 19 11 80       	mov    0x80111960,%eax
80106a2d:	83 f8 01             	cmp    $0x1,%eax
80106a30:	0f 85 26 01 00 00    	jne    80106b5c <trap+0x1a2>
80106a36:	8b 45 08             	mov    0x8(%ebp),%eax
80106a39:	8b 40 30             	mov    0x30(%eax),%eax
80106a3c:	83 f8 0e             	cmp    $0xe,%eax
80106a3f:	0f 85 17 01 00 00    	jne    80106b5c <trap+0x1a2>
    uint addr = rcr2();         // faulting virtual address
80106a45:	e8 d1 fd ff ff       	call   8010681b <rcr2>
80106a4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    struct proc *p = myproc();
80106a4d:	e8 83 da ff ff       	call   801044d5 <myproc>
80106a52:	89 45 e0             	mov    %eax,-0x20(%ebp)

    // Kernel-mode page fault? That's a real bug → panic.
    if ((tf->cs & 3) != DPL_USER || p == 0) {
80106a55:	8b 45 08             	mov    0x8(%ebp),%eax
80106a58:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106a5c:	0f b7 c0             	movzwl %ax,%eax
80106a5f:	83 e0 03             	and    $0x3,%eax
80106a62:	83 f8 03             	cmp    $0x3,%eax
80106a65:	75 06                	jne    80106a6d <trap+0xb3>
80106a67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80106a6b:	75 0d                	jne    80106a7a <trap+0xc0>
      panic("kernel page fault");
80106a6d:	83 ec 0c             	sub    $0xc,%esp
80106a70:	68 4d 8d 10 80       	push   $0x80108d4d
80106a75:	e8 01 9b ff ff       	call   8010057b <panic>
    }

    // Page-aligned address
    uint a = PGROUNDDOWN(addr);
80106a7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106a7d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106a82:	89 45 dc             	mov    %eax,-0x24(%ebp)

    // If the page is above the program break or above KERNBASE,
    // it's not a lazily-allocatable region → kill the process.
    if (a >= p->sz || a >= KERNBASE) {
80106a85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106a88:	8b 00                	mov    (%eax),%eax
80106a8a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
80106a8d:	73 07                	jae    80106a96 <trap+0xdc>
80106a8f:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106a92:	85 c0                	test   %eax,%eax
80106a94:	79 22                	jns    80106ab8 <trap+0xfe>
      cprintf("Unhandled page fault for va:0x%x!\n", addr);
80106a96:	83 ec 08             	sub    $0x8,%esp
80106a99:	ff 75 e4             	push   -0x1c(%ebp)
80106a9c:	68 60 8d 10 80       	push   $0x80108d60
80106aa1:	e8 20 99 ff ff       	call   801003c6 <cprintf>
80106aa6:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
80106aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106aac:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // don't return yet; we let the bottom-of-trap kill it cleanly
      goto trap_done;
80106ab3:	e9 20 02 00 00       	jmp    80106cd8 <trap+0x31e>
    }

    // Valid lazy fault → allocate & map a zeroed page
    char *mem = kalloc();
80106ab8:	e8 c9 c1 ff ff       	call   80102c86 <kalloc>
80106abd:	89 45 d8             	mov    %eax,-0x28(%ebp)
    if (mem == 0) {
80106ac0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80106ac4:	75 22                	jne    80106ae8 <trap+0x12e>
      cprintf("Lazy alloc OOM at va:0x%x\n", addr);
80106ac6:	83 ec 08             	sub    $0x8,%esp
80106ac9:	ff 75 e4             	push   -0x1c(%ebp)
80106acc:	68 83 8d 10 80       	push   $0x80108d83
80106ad1:	e8 f0 98 ff ff       	call   801003c6 <cprintf>
80106ad6:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
80106ad9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106adc:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      goto trap_done;
80106ae3:	e9 f0 01 00 00       	jmp    80106cd8 <trap+0x31e>
    }

    memset(mem, 0, PGSIZE);
80106ae8:	83 ec 04             	sub    $0x4,%esp
80106aeb:	68 00 10 00 00       	push   $0x1000
80106af0:	6a 00                	push   $0x0
80106af2:	ff 75 d8             	push   -0x28(%ebp)
80106af5:	e8 33 e8 ff ff       	call   8010532d <memset>
80106afa:	83 c4 10             	add    $0x10,%esp

    if (mappages(p->pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
80106afd:	8b 45 d8             	mov    -0x28(%ebp),%eax
80106b00:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
80106b06:	8b 55 dc             	mov    -0x24(%ebp),%edx
80106b09:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b0c:	8b 40 04             	mov    0x4(%eax),%eax
80106b0f:	83 ec 0c             	sub    $0xc,%esp
80106b12:	6a 06                	push   $0x6
80106b14:	51                   	push   %ecx
80106b15:	68 00 10 00 00       	push   $0x1000
80106b1a:	52                   	push   %edx
80106b1b:	50                   	push   %eax
80106b1c:	e8 3a 14 00 00       	call   80107f5b <mappages>
80106b21:	83 c4 20             	add    $0x20,%esp
80106b24:	85 c0                	test   %eax,%eax
80106b26:	0f 89 2f 02 00 00    	jns    80106d5b <trap+0x3a1>
      cprintf("mappages failed for va:0x%x\n", addr);
80106b2c:	83 ec 08             	sub    $0x8,%esp
80106b2f:	ff 75 e4             	push   -0x1c(%ebp)
80106b32:	68 9e 8d 10 80       	push   $0x80108d9e
80106b37:	e8 8a 98 ff ff       	call   801003c6 <cprintf>
80106b3c:	83 c4 10             	add    $0x10,%esp
      kfree(mem);
80106b3f:	83 ec 0c             	sub    $0xc,%esp
80106b42:	ff 75 d8             	push   -0x28(%ebp)
80106b45:	e8 92 c0 ff ff       	call   80102bdc <kfree>
80106b4a:	83 c4 10             	add    $0x10,%esp
      p->killed = 1;
80106b4d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106b50:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      goto trap_done;
80106b57:	e9 7c 01 00 00       	jmp    80106cd8 <trap+0x31e>

    // Lazy page fault fully handled → just return to user space.
    return;
  }
  // =============== HARDWARE INTERRUPTS ===============
  switch(tf->trapno){
80106b5c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b5f:	8b 40 30             	mov    0x30(%eax),%eax
80106b62:	83 e8 20             	sub    $0x20,%eax
80106b65:	83 f8 1f             	cmp    $0x1f,%eax
80106b68:	0f 87 b5 00 00 00    	ja     80106c23 <trap+0x269>
80106b6e:	8b 04 85 58 8e 10 80 	mov    -0x7fef71a8(,%eax,4),%eax
80106b75:	ff e0                	jmp    *%eax

  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80106b77:	e8 4f d9 ff ff       	call   801044cb <cpuid>
80106b7c:	85 c0                	test   %eax,%eax
80106b7e:	75 3d                	jne    80106bbd <trap+0x203>
      acquire(&tickslock);
80106b80:	83 ec 0c             	sub    $0xc,%esp
80106b83:	68 c0 40 11 80       	push   $0x801140c0
80106b88:	e8 3d e5 ff ff       	call   801050ca <acquire>
80106b8d:	83 c4 10             	add    $0x10,%esp
      ticks++;
80106b90:	a1 f4 40 11 80       	mov    0x801140f4,%eax
80106b95:	83 c0 01             	add    $0x1,%eax
80106b98:	a3 f4 40 11 80       	mov    %eax,0x801140f4
      wakeup(&ticks);
80106b9d:	83 ec 0c             	sub    $0xc,%esp
80106ba0:	68 f4 40 11 80       	push   $0x801140f4
80106ba5:	e8 11 e3 ff ff       	call   80104ebb <wakeup>
80106baa:	83 c4 10             	add    $0x10,%esp
      release(&tickslock);
80106bad:	83 ec 0c             	sub    $0xc,%esp
80106bb0:	68 c0 40 11 80       	push   $0x801140c0
80106bb5:	e8 77 e5 ff ff       	call   80105131 <release>
80106bba:	83 c4 10             	add    $0x10,%esp
    }
    lapiceoi();
80106bbd:	e8 94 c4 ff ff       	call   80103056 <lapiceoi>
    break;
80106bc2:	e9 11 01 00 00       	jmp    80106cd8 <trap+0x31e>

  case T_IRQ0 + IRQ_IDE:
    ideintr();
80106bc7:	e8 7e bc ff ff       	call   8010284a <ideintr>
    lapiceoi();
80106bcc:	e8 85 c4 ff ff       	call   80103056 <lapiceoi>
    break;
80106bd1:	e9 02 01 00 00       	jmp    80106cd8 <trap+0x31e>

  case T_IRQ0 + IRQ_IDE+1:
    break;

  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80106bd6:	e8 79 c2 ff ff       	call   80102e54 <kbdintr>
    lapiceoi();
80106bdb:	e8 76 c4 ff ff       	call   80103056 <lapiceoi>
    break;
80106be0:	e9 f3 00 00 00       	jmp    80106cd8 <trap+0x31e>

  case T_IRQ0 + IRQ_COM1:
    uartintr();
80106be5:	e8 54 03 00 00       	call   80106f3e <uartintr>
    lapiceoi();
80106bea:	e8 67 c4 ff ff       	call   80103056 <lapiceoi>
    break;
80106bef:	e9 e4 00 00 00       	jmp    80106cd8 <trap+0x31e>

  case T_IRQ0 + IRQ_SPURIOUS:
  case T_IRQ0 + 7:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106bf4:	8b 45 08             	mov    0x8(%ebp),%eax
80106bf7:	8b 70 38             	mov    0x38(%eax),%esi
            cpuid(), tf->cs, tf->eip);
80106bfa:	8b 45 08             	mov    0x8(%ebp),%eax
80106bfd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80106c01:	0f b7 d8             	movzwl %ax,%ebx
80106c04:	e8 c2 d8 ff ff       	call   801044cb <cpuid>
80106c09:	56                   	push   %esi
80106c0a:	53                   	push   %ebx
80106c0b:	50                   	push   %eax
80106c0c:	68 bc 8d 10 80       	push   $0x80108dbc
80106c11:	e8 b0 97 ff ff       	call   801003c6 <cprintf>
80106c16:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
80106c19:	e8 38 c4 ff ff       	call   80103056 <lapiceoi>
    break;
80106c1e:	e9 b5 00 00 00       	jmp    80106cd8 <trap+0x31e>

  default:
    if(myproc() == 0 || (tf->cs & 3) == 0){
80106c23:	e8 ad d8 ff ff       	call   801044d5 <myproc>
80106c28:	85 c0                	test   %eax,%eax
80106c2a:	74 11                	je     80106c3d <trap+0x283>
80106c2c:	8b 45 08             	mov    0x8(%ebp),%eax
80106c2f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106c33:	0f b7 c0             	movzwl %ax,%eax
80106c36:	83 e0 03             	and    $0x3,%eax
80106c39:	85 c0                	test   %eax,%eax
80106c3b:	75 39                	jne    80106c76 <trap+0x2bc>
      // kernel mode unexpected trap
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106c3d:	e8 d9 fb ff ff       	call   8010681b <rcr2>
80106c42:	89 c3                	mov    %eax,%ebx
80106c44:	8b 45 08             	mov    0x8(%ebp),%eax
80106c47:	8b 70 38             	mov    0x38(%eax),%esi
80106c4a:	e8 7c d8 ff ff       	call   801044cb <cpuid>
80106c4f:	8b 55 08             	mov    0x8(%ebp),%edx
80106c52:	8b 52 30             	mov    0x30(%edx),%edx
80106c55:	83 ec 0c             	sub    $0xc,%esp
80106c58:	53                   	push   %ebx
80106c59:	56                   	push   %esi
80106c5a:	50                   	push   %eax
80106c5b:	52                   	push   %edx
80106c5c:	68 e0 8d 10 80       	push   $0x80108de0
80106c61:	e8 60 97 ff ff       	call   801003c6 <cprintf>
80106c66:	83 c4 20             	add    $0x20,%esp
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80106c69:	83 ec 0c             	sub    $0xc,%esp
80106c6c:	68 12 8e 10 80       	push   $0x80108e12
80106c71:	e8 05 99 ff ff       	call   8010057b <panic>
    }

    // user mode fault → kill the process
    cprintf("pid %d %s: trap %d err %d on cpu %d eip 0x%x addr 0x%x -- kill\n",
80106c76:	e8 a0 fb ff ff       	call   8010681b <rcr2>
80106c7b:	89 c6                	mov    %eax,%esi
80106c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c80:	8b 40 38             	mov    0x38(%eax),%eax
80106c83:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80106c86:	e8 40 d8 ff ff       	call   801044cb <cpuid>
80106c8b:	89 c3                	mov    %eax,%ebx
80106c8d:	8b 45 08             	mov    0x8(%ebp),%eax
80106c90:	8b 48 34             	mov    0x34(%eax),%ecx
80106c93:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80106c96:	8b 45 08             	mov    0x8(%ebp),%eax
80106c99:	8b 78 30             	mov    0x30(%eax),%edi
            myproc()->pid, myproc()->name,
80106c9c:	e8 34 d8 ff ff       	call   801044d5 <myproc>
80106ca1:	8d 50 6c             	lea    0x6c(%eax),%edx
80106ca4:	89 55 cc             	mov    %edx,-0x34(%ebp)
80106ca7:	e8 29 d8 ff ff       	call   801044d5 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d eip 0x%x addr 0x%x -- kill\n",
80106cac:	8b 40 10             	mov    0x10(%eax),%eax
80106caf:	56                   	push   %esi
80106cb0:	ff 75 d4             	push   -0x2c(%ebp)
80106cb3:	53                   	push   %ebx
80106cb4:	ff 75 d0             	push   -0x30(%ebp)
80106cb7:	57                   	push   %edi
80106cb8:	ff 75 cc             	push   -0x34(%ebp)
80106cbb:	50                   	push   %eax
80106cbc:	68 18 8e 10 80       	push   $0x80108e18
80106cc1:	e8 00 97 ff ff       	call   801003c6 <cprintf>
80106cc6:	83 c4 20             	add    $0x20,%esp
            tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80106cc9:	e8 07 d8 ff ff       	call   801044d5 <myproc>
80106cce:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80106cd5:	eb 01                	jmp    80106cd8 <trap+0x31e>
    break;
80106cd7:	90                   	nop

  trap_done:
  // ========== same bottom-of-trap logic as original xv6 ==========

  // Force process exit if it has been killed and is in user space.
  if(myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106cd8:	e8 f8 d7 ff ff       	call   801044d5 <myproc>
80106cdd:	85 c0                	test   %eax,%eax
80106cdf:	74 23                	je     80106d04 <trap+0x34a>
80106ce1:	e8 ef d7 ff ff       	call   801044d5 <myproc>
80106ce6:	8b 40 24             	mov    0x24(%eax),%eax
80106ce9:	85 c0                	test   %eax,%eax
80106ceb:	74 17                	je     80106d04 <trap+0x34a>
80106ced:	8b 45 08             	mov    0x8(%ebp),%eax
80106cf0:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106cf4:	0f b7 c0             	movzwl %ax,%eax
80106cf7:	83 e0 03             	and    $0x3,%eax
80106cfa:	83 f8 03             	cmp    $0x3,%eax
80106cfd:	75 05                	jne    80106d04 <trap+0x34a>
    exit();
80106cff:	e8 69 dc ff ff       	call   8010496d <exit>

  // Force process to give up CPU on clock tick.
  if(myproc() && myproc()->state == RUNNING &&
80106d04:	e8 cc d7 ff ff       	call   801044d5 <myproc>
80106d09:	85 c0                	test   %eax,%eax
80106d0b:	74 1d                	je     80106d2a <trap+0x370>
80106d0d:	e8 c3 d7 ff ff       	call   801044d5 <myproc>
80106d12:	8b 40 0c             	mov    0xc(%eax),%eax
80106d15:	83 f8 04             	cmp    $0x4,%eax
80106d18:	75 10                	jne    80106d2a <trap+0x370>
     tf->trapno == T_IRQ0 + IRQ_TIMER)
80106d1a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d1d:	8b 40 30             	mov    0x30(%eax),%eax
  if(myproc() && myproc()->state == RUNNING &&
80106d20:	83 f8 20             	cmp    $0x20,%eax
80106d23:	75 05                	jne    80106d2a <trap+0x370>
    yield();
80106d25:	e8 24 e0 ff ff       	call   80104d4e <yield>

  // Check again if killed after yielding.
  if(myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
80106d2a:	e8 a6 d7 ff ff       	call   801044d5 <myproc>
80106d2f:	85 c0                	test   %eax,%eax
80106d31:	74 29                	je     80106d5c <trap+0x3a2>
80106d33:	e8 9d d7 ff ff       	call   801044d5 <myproc>
80106d38:	8b 40 24             	mov    0x24(%eax),%eax
80106d3b:	85 c0                	test   %eax,%eax
80106d3d:	74 1d                	je     80106d5c <trap+0x3a2>
80106d3f:	8b 45 08             	mov    0x8(%ebp),%eax
80106d42:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80106d46:	0f b7 c0             	movzwl %ax,%eax
80106d49:	83 e0 03             	and    $0x3,%eax
80106d4c:	83 f8 03             	cmp    $0x3,%eax
80106d4f:	75 0b                	jne    80106d5c <trap+0x3a2>
    exit();
80106d51:	e8 17 dc ff ff       	call   8010496d <exit>
80106d56:	eb 04                	jmp    80106d5c <trap+0x3a2>
    return;
80106d58:	90                   	nop
80106d59:	eb 01                	jmp    80106d5c <trap+0x3a2>
    return;
80106d5b:	90                   	nop
}
80106d5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d5f:	5b                   	pop    %ebx
80106d60:	5e                   	pop    %esi
80106d61:	5f                   	pop    %edi
80106d62:	5d                   	pop    %ebp
80106d63:	c3                   	ret    

80106d64 <inb>:
{
80106d64:	55                   	push   %ebp
80106d65:	89 e5                	mov    %esp,%ebp
80106d67:	83 ec 14             	sub    $0x14,%esp
80106d6a:	8b 45 08             	mov    0x8(%ebp),%eax
80106d6d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106d71:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80106d75:	89 c2                	mov    %eax,%edx
80106d77:	ec                   	in     (%dx),%al
80106d78:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80106d7b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80106d7f:	c9                   	leave  
80106d80:	c3                   	ret    

80106d81 <outb>:
{
80106d81:	55                   	push   %ebp
80106d82:	89 e5                	mov    %esp,%ebp
80106d84:	83 ec 08             	sub    $0x8,%esp
80106d87:	8b 45 08             	mov    0x8(%ebp),%eax
80106d8a:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d8d:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
80106d91:	89 d0                	mov    %edx,%eax
80106d93:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d96:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d9a:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d9e:	ee                   	out    %al,(%dx)
}
80106d9f:	90                   	nop
80106da0:	c9                   	leave  
80106da1:	c3                   	ret    

80106da2 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80106da2:	55                   	push   %ebp
80106da3:	89 e5                	mov    %esp,%ebp
80106da5:	83 ec 18             	sub    $0x18,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80106da8:	6a 00                	push   $0x0
80106daa:	68 fa 03 00 00       	push   $0x3fa
80106daf:	e8 cd ff ff ff       	call   80106d81 <outb>
80106db4:	83 c4 08             	add    $0x8,%esp
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
80106db7:	68 80 00 00 00       	push   $0x80
80106dbc:	68 fb 03 00 00       	push   $0x3fb
80106dc1:	e8 bb ff ff ff       	call   80106d81 <outb>
80106dc6:	83 c4 08             	add    $0x8,%esp
  outb(COM1+0, 115200/9600);
80106dc9:	6a 0c                	push   $0xc
80106dcb:	68 f8 03 00 00       	push   $0x3f8
80106dd0:	e8 ac ff ff ff       	call   80106d81 <outb>
80106dd5:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0);
80106dd8:	6a 00                	push   $0x0
80106dda:	68 f9 03 00 00       	push   $0x3f9
80106ddf:	e8 9d ff ff ff       	call   80106d81 <outb>
80106de4:	83 c4 08             	add    $0x8,%esp
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
80106de7:	6a 03                	push   $0x3
80106de9:	68 fb 03 00 00       	push   $0x3fb
80106dee:	e8 8e ff ff ff       	call   80106d81 <outb>
80106df3:	83 c4 08             	add    $0x8,%esp
  outb(COM1+4, 0);
80106df6:	6a 00                	push   $0x0
80106df8:	68 fc 03 00 00       	push   $0x3fc
80106dfd:	e8 7f ff ff ff       	call   80106d81 <outb>
80106e02:	83 c4 08             	add    $0x8,%esp
  outb(COM1+1, 0x01);    // Enable receive interrupts.
80106e05:	6a 01                	push   $0x1
80106e07:	68 f9 03 00 00       	push   $0x3f9
80106e0c:	e8 70 ff ff ff       	call   80106d81 <outb>
80106e11:	83 c4 08             	add    $0x8,%esp

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80106e14:	68 fd 03 00 00       	push   $0x3fd
80106e19:	e8 46 ff ff ff       	call   80106d64 <inb>
80106e1e:	83 c4 04             	add    $0x4,%esp
80106e21:	3c ff                	cmp    $0xff,%al
80106e23:	74 6e                	je     80106e93 <uartinit+0xf1>
    return;
  uart = 1;
80106e25:	c7 05 f8 40 11 80 01 	movl   $0x1,0x801140f8
80106e2c:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
80106e2f:	68 fa 03 00 00       	push   $0x3fa
80106e34:	e8 2b ff ff ff       	call   80106d64 <inb>
80106e39:	83 c4 04             	add    $0x4,%esp
  inb(COM1+0);
80106e3c:	68 f8 03 00 00       	push   $0x3f8
80106e41:	e8 1e ff ff ff       	call   80106d64 <inb>
80106e46:	83 c4 04             	add    $0x4,%esp
  picenable(IRQ_COM1);
80106e49:	83 ec 0c             	sub    $0xc,%esp
80106e4c:	6a 04                	push   $0x4
80106e4e:	e8 1f d1 ff ff       	call   80103f72 <picenable>
80106e53:	83 c4 10             	add    $0x10,%esp
  ioapicenable(IRQ_COM1, 0);
80106e56:	83 ec 08             	sub    $0x8,%esp
80106e59:	6a 00                	push   $0x0
80106e5b:	6a 04                	push   $0x4
80106e5d:	e8 8a bc ff ff       	call   80102aec <ioapicenable>
80106e62:	83 c4 10             	add    $0x10,%esp
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80106e65:	c7 45 f4 d8 8e 10 80 	movl   $0x80108ed8,-0xc(%ebp)
80106e6c:	eb 19                	jmp    80106e87 <uartinit+0xe5>
    uartputc(*p);
80106e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e71:	0f b6 00             	movzbl (%eax),%eax
80106e74:	0f be c0             	movsbl %al,%eax
80106e77:	83 ec 0c             	sub    $0xc,%esp
80106e7a:	50                   	push   %eax
80106e7b:	e8 16 00 00 00       	call   80106e96 <uartputc>
80106e80:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106e83:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106e87:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e8a:	0f b6 00             	movzbl (%eax),%eax
80106e8d:	84 c0                	test   %al,%al
80106e8f:	75 dd                	jne    80106e6e <uartinit+0xcc>
80106e91:	eb 01                	jmp    80106e94 <uartinit+0xf2>
    return;
80106e93:	90                   	nop
}
80106e94:	c9                   	leave  
80106e95:	c3                   	ret    

80106e96 <uartputc>:

void
uartputc(int c)
{
80106e96:	55                   	push   %ebp
80106e97:	89 e5                	mov    %esp,%ebp
80106e99:	83 ec 18             	sub    $0x18,%esp
  int i;

  if(!uart)
80106e9c:	a1 f8 40 11 80       	mov    0x801140f8,%eax
80106ea1:	85 c0                	test   %eax,%eax
80106ea3:	74 53                	je     80106ef8 <uartputc+0x62>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ea5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106eac:	eb 11                	jmp    80106ebf <uartputc+0x29>
    microdelay(10);
80106eae:	83 ec 0c             	sub    $0xc,%esp
80106eb1:	6a 0a                	push   $0xa
80106eb3:	e8 b9 c1 ff ff       	call   80103071 <microdelay>
80106eb8:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80106ebb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106ebf:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
80106ec3:	7f 1a                	jg     80106edf <uartputc+0x49>
80106ec5:	83 ec 0c             	sub    $0xc,%esp
80106ec8:	68 fd 03 00 00       	push   $0x3fd
80106ecd:	e8 92 fe ff ff       	call   80106d64 <inb>
80106ed2:	83 c4 10             	add    $0x10,%esp
80106ed5:	0f b6 c0             	movzbl %al,%eax
80106ed8:	83 e0 20             	and    $0x20,%eax
80106edb:	85 c0                	test   %eax,%eax
80106edd:	74 cf                	je     80106eae <uartputc+0x18>
  outb(COM1+0, c);
80106edf:	8b 45 08             	mov    0x8(%ebp),%eax
80106ee2:	0f b6 c0             	movzbl %al,%eax
80106ee5:	83 ec 08             	sub    $0x8,%esp
80106ee8:	50                   	push   %eax
80106ee9:	68 f8 03 00 00       	push   $0x3f8
80106eee:	e8 8e fe ff ff       	call   80106d81 <outb>
80106ef3:	83 c4 10             	add    $0x10,%esp
80106ef6:	eb 01                	jmp    80106ef9 <uartputc+0x63>
    return;
80106ef8:	90                   	nop
}
80106ef9:	c9                   	leave  
80106efa:	c3                   	ret    

80106efb <uartgetc>:

static int
uartgetc(void)
{
80106efb:	55                   	push   %ebp
80106efc:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106efe:	a1 f8 40 11 80       	mov    0x801140f8,%eax
80106f03:	85 c0                	test   %eax,%eax
80106f05:	75 07                	jne    80106f0e <uartgetc+0x13>
    return -1;
80106f07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f0c:	eb 2e                	jmp    80106f3c <uartgetc+0x41>
  if(!(inb(COM1+5) & 0x01))
80106f0e:	68 fd 03 00 00       	push   $0x3fd
80106f13:	e8 4c fe ff ff       	call   80106d64 <inb>
80106f18:	83 c4 04             	add    $0x4,%esp
80106f1b:	0f b6 c0             	movzbl %al,%eax
80106f1e:	83 e0 01             	and    $0x1,%eax
80106f21:	85 c0                	test   %eax,%eax
80106f23:	75 07                	jne    80106f2c <uartgetc+0x31>
    return -1;
80106f25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106f2a:	eb 10                	jmp    80106f3c <uartgetc+0x41>
  return inb(COM1+0);
80106f2c:	68 f8 03 00 00       	push   $0x3f8
80106f31:	e8 2e fe ff ff       	call   80106d64 <inb>
80106f36:	83 c4 04             	add    $0x4,%esp
80106f39:	0f b6 c0             	movzbl %al,%eax
}
80106f3c:	c9                   	leave  
80106f3d:	c3                   	ret    

80106f3e <uartintr>:

void
uartintr(void)
{
80106f3e:	55                   	push   %ebp
80106f3f:	89 e5                	mov    %esp,%ebp
80106f41:	83 ec 08             	sub    $0x8,%esp
  consoleintr(uartgetc);
80106f44:	83 ec 0c             	sub    $0xc,%esp
80106f47:	68 fb 6e 10 80       	push   $0x80106efb
80106f4c:	e8 cb 98 ff ff       	call   8010081c <consoleintr>
80106f51:	83 c4 10             	add    $0x10,%esp
}
80106f54:	90                   	nop
80106f55:	c9                   	leave  
80106f56:	c3                   	ret    

80106f57 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106f57:	6a 00                	push   $0x0
  pushl $0
80106f59:	6a 00                	push   $0x0
  jmp alltraps
80106f5b:	e9 66 f8 ff ff       	jmp    801067c6 <alltraps>

80106f60 <vector1>:
.globl vector1
vector1:
  pushl $0
80106f60:	6a 00                	push   $0x0
  pushl $1
80106f62:	6a 01                	push   $0x1
  jmp alltraps
80106f64:	e9 5d f8 ff ff       	jmp    801067c6 <alltraps>

80106f69 <vector2>:
.globl vector2
vector2:
  pushl $0
80106f69:	6a 00                	push   $0x0
  pushl $2
80106f6b:	6a 02                	push   $0x2
  jmp alltraps
80106f6d:	e9 54 f8 ff ff       	jmp    801067c6 <alltraps>

80106f72 <vector3>:
.globl vector3
vector3:
  pushl $0
80106f72:	6a 00                	push   $0x0
  pushl $3
80106f74:	6a 03                	push   $0x3
  jmp alltraps
80106f76:	e9 4b f8 ff ff       	jmp    801067c6 <alltraps>

80106f7b <vector4>:
.globl vector4
vector4:
  pushl $0
80106f7b:	6a 00                	push   $0x0
  pushl $4
80106f7d:	6a 04                	push   $0x4
  jmp alltraps
80106f7f:	e9 42 f8 ff ff       	jmp    801067c6 <alltraps>

80106f84 <vector5>:
.globl vector5
vector5:
  pushl $0
80106f84:	6a 00                	push   $0x0
  pushl $5
80106f86:	6a 05                	push   $0x5
  jmp alltraps
80106f88:	e9 39 f8 ff ff       	jmp    801067c6 <alltraps>

80106f8d <vector6>:
.globl vector6
vector6:
  pushl $0
80106f8d:	6a 00                	push   $0x0
  pushl $6
80106f8f:	6a 06                	push   $0x6
  jmp alltraps
80106f91:	e9 30 f8 ff ff       	jmp    801067c6 <alltraps>

80106f96 <vector7>:
.globl vector7
vector7:
  pushl $0
80106f96:	6a 00                	push   $0x0
  pushl $7
80106f98:	6a 07                	push   $0x7
  jmp alltraps
80106f9a:	e9 27 f8 ff ff       	jmp    801067c6 <alltraps>

80106f9f <vector8>:
.globl vector8
vector8:
  pushl $8
80106f9f:	6a 08                	push   $0x8
  jmp alltraps
80106fa1:	e9 20 f8 ff ff       	jmp    801067c6 <alltraps>

80106fa6 <vector9>:
.globl vector9
vector9:
  pushl $0
80106fa6:	6a 00                	push   $0x0
  pushl $9
80106fa8:	6a 09                	push   $0x9
  jmp alltraps
80106faa:	e9 17 f8 ff ff       	jmp    801067c6 <alltraps>

80106faf <vector10>:
.globl vector10
vector10:
  pushl $10
80106faf:	6a 0a                	push   $0xa
  jmp alltraps
80106fb1:	e9 10 f8 ff ff       	jmp    801067c6 <alltraps>

80106fb6 <vector11>:
.globl vector11
vector11:
  pushl $11
80106fb6:	6a 0b                	push   $0xb
  jmp alltraps
80106fb8:	e9 09 f8 ff ff       	jmp    801067c6 <alltraps>

80106fbd <vector12>:
.globl vector12
vector12:
  pushl $12
80106fbd:	6a 0c                	push   $0xc
  jmp alltraps
80106fbf:	e9 02 f8 ff ff       	jmp    801067c6 <alltraps>

80106fc4 <vector13>:
.globl vector13
vector13:
  pushl $13
80106fc4:	6a 0d                	push   $0xd
  jmp alltraps
80106fc6:	e9 fb f7 ff ff       	jmp    801067c6 <alltraps>

80106fcb <vector14>:
.globl vector14
vector14:
  pushl $14
80106fcb:	6a 0e                	push   $0xe
  jmp alltraps
80106fcd:	e9 f4 f7 ff ff       	jmp    801067c6 <alltraps>

80106fd2 <vector15>:
.globl vector15
vector15:
  pushl $0
80106fd2:	6a 00                	push   $0x0
  pushl $15
80106fd4:	6a 0f                	push   $0xf
  jmp alltraps
80106fd6:	e9 eb f7 ff ff       	jmp    801067c6 <alltraps>

80106fdb <vector16>:
.globl vector16
vector16:
  pushl $0
80106fdb:	6a 00                	push   $0x0
  pushl $16
80106fdd:	6a 10                	push   $0x10
  jmp alltraps
80106fdf:	e9 e2 f7 ff ff       	jmp    801067c6 <alltraps>

80106fe4 <vector17>:
.globl vector17
vector17:
  pushl $17
80106fe4:	6a 11                	push   $0x11
  jmp alltraps
80106fe6:	e9 db f7 ff ff       	jmp    801067c6 <alltraps>

80106feb <vector18>:
.globl vector18
vector18:
  pushl $0
80106feb:	6a 00                	push   $0x0
  pushl $18
80106fed:	6a 12                	push   $0x12
  jmp alltraps
80106fef:	e9 d2 f7 ff ff       	jmp    801067c6 <alltraps>

80106ff4 <vector19>:
.globl vector19
vector19:
  pushl $0
80106ff4:	6a 00                	push   $0x0
  pushl $19
80106ff6:	6a 13                	push   $0x13
  jmp alltraps
80106ff8:	e9 c9 f7 ff ff       	jmp    801067c6 <alltraps>

80106ffd <vector20>:
.globl vector20
vector20:
  pushl $0
80106ffd:	6a 00                	push   $0x0
  pushl $20
80106fff:	6a 14                	push   $0x14
  jmp alltraps
80107001:	e9 c0 f7 ff ff       	jmp    801067c6 <alltraps>

80107006 <vector21>:
.globl vector21
vector21:
  pushl $0
80107006:	6a 00                	push   $0x0
  pushl $21
80107008:	6a 15                	push   $0x15
  jmp alltraps
8010700a:	e9 b7 f7 ff ff       	jmp    801067c6 <alltraps>

8010700f <vector22>:
.globl vector22
vector22:
  pushl $0
8010700f:	6a 00                	push   $0x0
  pushl $22
80107011:	6a 16                	push   $0x16
  jmp alltraps
80107013:	e9 ae f7 ff ff       	jmp    801067c6 <alltraps>

80107018 <vector23>:
.globl vector23
vector23:
  pushl $0
80107018:	6a 00                	push   $0x0
  pushl $23
8010701a:	6a 17                	push   $0x17
  jmp alltraps
8010701c:	e9 a5 f7 ff ff       	jmp    801067c6 <alltraps>

80107021 <vector24>:
.globl vector24
vector24:
  pushl $0
80107021:	6a 00                	push   $0x0
  pushl $24
80107023:	6a 18                	push   $0x18
  jmp alltraps
80107025:	e9 9c f7 ff ff       	jmp    801067c6 <alltraps>

8010702a <vector25>:
.globl vector25
vector25:
  pushl $0
8010702a:	6a 00                	push   $0x0
  pushl $25
8010702c:	6a 19                	push   $0x19
  jmp alltraps
8010702e:	e9 93 f7 ff ff       	jmp    801067c6 <alltraps>

80107033 <vector26>:
.globl vector26
vector26:
  pushl $0
80107033:	6a 00                	push   $0x0
  pushl $26
80107035:	6a 1a                	push   $0x1a
  jmp alltraps
80107037:	e9 8a f7 ff ff       	jmp    801067c6 <alltraps>

8010703c <vector27>:
.globl vector27
vector27:
  pushl $0
8010703c:	6a 00                	push   $0x0
  pushl $27
8010703e:	6a 1b                	push   $0x1b
  jmp alltraps
80107040:	e9 81 f7 ff ff       	jmp    801067c6 <alltraps>

80107045 <vector28>:
.globl vector28
vector28:
  pushl $0
80107045:	6a 00                	push   $0x0
  pushl $28
80107047:	6a 1c                	push   $0x1c
  jmp alltraps
80107049:	e9 78 f7 ff ff       	jmp    801067c6 <alltraps>

8010704e <vector29>:
.globl vector29
vector29:
  pushl $0
8010704e:	6a 00                	push   $0x0
  pushl $29
80107050:	6a 1d                	push   $0x1d
  jmp alltraps
80107052:	e9 6f f7 ff ff       	jmp    801067c6 <alltraps>

80107057 <vector30>:
.globl vector30
vector30:
  pushl $0
80107057:	6a 00                	push   $0x0
  pushl $30
80107059:	6a 1e                	push   $0x1e
  jmp alltraps
8010705b:	e9 66 f7 ff ff       	jmp    801067c6 <alltraps>

80107060 <vector31>:
.globl vector31
vector31:
  pushl $0
80107060:	6a 00                	push   $0x0
  pushl $31
80107062:	6a 1f                	push   $0x1f
  jmp alltraps
80107064:	e9 5d f7 ff ff       	jmp    801067c6 <alltraps>

80107069 <vector32>:
.globl vector32
vector32:
  pushl $0
80107069:	6a 00                	push   $0x0
  pushl $32
8010706b:	6a 20                	push   $0x20
  jmp alltraps
8010706d:	e9 54 f7 ff ff       	jmp    801067c6 <alltraps>

80107072 <vector33>:
.globl vector33
vector33:
  pushl $0
80107072:	6a 00                	push   $0x0
  pushl $33
80107074:	6a 21                	push   $0x21
  jmp alltraps
80107076:	e9 4b f7 ff ff       	jmp    801067c6 <alltraps>

8010707b <vector34>:
.globl vector34
vector34:
  pushl $0
8010707b:	6a 00                	push   $0x0
  pushl $34
8010707d:	6a 22                	push   $0x22
  jmp alltraps
8010707f:	e9 42 f7 ff ff       	jmp    801067c6 <alltraps>

80107084 <vector35>:
.globl vector35
vector35:
  pushl $0
80107084:	6a 00                	push   $0x0
  pushl $35
80107086:	6a 23                	push   $0x23
  jmp alltraps
80107088:	e9 39 f7 ff ff       	jmp    801067c6 <alltraps>

8010708d <vector36>:
.globl vector36
vector36:
  pushl $0
8010708d:	6a 00                	push   $0x0
  pushl $36
8010708f:	6a 24                	push   $0x24
  jmp alltraps
80107091:	e9 30 f7 ff ff       	jmp    801067c6 <alltraps>

80107096 <vector37>:
.globl vector37
vector37:
  pushl $0
80107096:	6a 00                	push   $0x0
  pushl $37
80107098:	6a 25                	push   $0x25
  jmp alltraps
8010709a:	e9 27 f7 ff ff       	jmp    801067c6 <alltraps>

8010709f <vector38>:
.globl vector38
vector38:
  pushl $0
8010709f:	6a 00                	push   $0x0
  pushl $38
801070a1:	6a 26                	push   $0x26
  jmp alltraps
801070a3:	e9 1e f7 ff ff       	jmp    801067c6 <alltraps>

801070a8 <vector39>:
.globl vector39
vector39:
  pushl $0
801070a8:	6a 00                	push   $0x0
  pushl $39
801070aa:	6a 27                	push   $0x27
  jmp alltraps
801070ac:	e9 15 f7 ff ff       	jmp    801067c6 <alltraps>

801070b1 <vector40>:
.globl vector40
vector40:
  pushl $0
801070b1:	6a 00                	push   $0x0
  pushl $40
801070b3:	6a 28                	push   $0x28
  jmp alltraps
801070b5:	e9 0c f7 ff ff       	jmp    801067c6 <alltraps>

801070ba <vector41>:
.globl vector41
vector41:
  pushl $0
801070ba:	6a 00                	push   $0x0
  pushl $41
801070bc:	6a 29                	push   $0x29
  jmp alltraps
801070be:	e9 03 f7 ff ff       	jmp    801067c6 <alltraps>

801070c3 <vector42>:
.globl vector42
vector42:
  pushl $0
801070c3:	6a 00                	push   $0x0
  pushl $42
801070c5:	6a 2a                	push   $0x2a
  jmp alltraps
801070c7:	e9 fa f6 ff ff       	jmp    801067c6 <alltraps>

801070cc <vector43>:
.globl vector43
vector43:
  pushl $0
801070cc:	6a 00                	push   $0x0
  pushl $43
801070ce:	6a 2b                	push   $0x2b
  jmp alltraps
801070d0:	e9 f1 f6 ff ff       	jmp    801067c6 <alltraps>

801070d5 <vector44>:
.globl vector44
vector44:
  pushl $0
801070d5:	6a 00                	push   $0x0
  pushl $44
801070d7:	6a 2c                	push   $0x2c
  jmp alltraps
801070d9:	e9 e8 f6 ff ff       	jmp    801067c6 <alltraps>

801070de <vector45>:
.globl vector45
vector45:
  pushl $0
801070de:	6a 00                	push   $0x0
  pushl $45
801070e0:	6a 2d                	push   $0x2d
  jmp alltraps
801070e2:	e9 df f6 ff ff       	jmp    801067c6 <alltraps>

801070e7 <vector46>:
.globl vector46
vector46:
  pushl $0
801070e7:	6a 00                	push   $0x0
  pushl $46
801070e9:	6a 2e                	push   $0x2e
  jmp alltraps
801070eb:	e9 d6 f6 ff ff       	jmp    801067c6 <alltraps>

801070f0 <vector47>:
.globl vector47
vector47:
  pushl $0
801070f0:	6a 00                	push   $0x0
  pushl $47
801070f2:	6a 2f                	push   $0x2f
  jmp alltraps
801070f4:	e9 cd f6 ff ff       	jmp    801067c6 <alltraps>

801070f9 <vector48>:
.globl vector48
vector48:
  pushl $0
801070f9:	6a 00                	push   $0x0
  pushl $48
801070fb:	6a 30                	push   $0x30
  jmp alltraps
801070fd:	e9 c4 f6 ff ff       	jmp    801067c6 <alltraps>

80107102 <vector49>:
.globl vector49
vector49:
  pushl $0
80107102:	6a 00                	push   $0x0
  pushl $49
80107104:	6a 31                	push   $0x31
  jmp alltraps
80107106:	e9 bb f6 ff ff       	jmp    801067c6 <alltraps>

8010710b <vector50>:
.globl vector50
vector50:
  pushl $0
8010710b:	6a 00                	push   $0x0
  pushl $50
8010710d:	6a 32                	push   $0x32
  jmp alltraps
8010710f:	e9 b2 f6 ff ff       	jmp    801067c6 <alltraps>

80107114 <vector51>:
.globl vector51
vector51:
  pushl $0
80107114:	6a 00                	push   $0x0
  pushl $51
80107116:	6a 33                	push   $0x33
  jmp alltraps
80107118:	e9 a9 f6 ff ff       	jmp    801067c6 <alltraps>

8010711d <vector52>:
.globl vector52
vector52:
  pushl $0
8010711d:	6a 00                	push   $0x0
  pushl $52
8010711f:	6a 34                	push   $0x34
  jmp alltraps
80107121:	e9 a0 f6 ff ff       	jmp    801067c6 <alltraps>

80107126 <vector53>:
.globl vector53
vector53:
  pushl $0
80107126:	6a 00                	push   $0x0
  pushl $53
80107128:	6a 35                	push   $0x35
  jmp alltraps
8010712a:	e9 97 f6 ff ff       	jmp    801067c6 <alltraps>

8010712f <vector54>:
.globl vector54
vector54:
  pushl $0
8010712f:	6a 00                	push   $0x0
  pushl $54
80107131:	6a 36                	push   $0x36
  jmp alltraps
80107133:	e9 8e f6 ff ff       	jmp    801067c6 <alltraps>

80107138 <vector55>:
.globl vector55
vector55:
  pushl $0
80107138:	6a 00                	push   $0x0
  pushl $55
8010713a:	6a 37                	push   $0x37
  jmp alltraps
8010713c:	e9 85 f6 ff ff       	jmp    801067c6 <alltraps>

80107141 <vector56>:
.globl vector56
vector56:
  pushl $0
80107141:	6a 00                	push   $0x0
  pushl $56
80107143:	6a 38                	push   $0x38
  jmp alltraps
80107145:	e9 7c f6 ff ff       	jmp    801067c6 <alltraps>

8010714a <vector57>:
.globl vector57
vector57:
  pushl $0
8010714a:	6a 00                	push   $0x0
  pushl $57
8010714c:	6a 39                	push   $0x39
  jmp alltraps
8010714e:	e9 73 f6 ff ff       	jmp    801067c6 <alltraps>

80107153 <vector58>:
.globl vector58
vector58:
  pushl $0
80107153:	6a 00                	push   $0x0
  pushl $58
80107155:	6a 3a                	push   $0x3a
  jmp alltraps
80107157:	e9 6a f6 ff ff       	jmp    801067c6 <alltraps>

8010715c <vector59>:
.globl vector59
vector59:
  pushl $0
8010715c:	6a 00                	push   $0x0
  pushl $59
8010715e:	6a 3b                	push   $0x3b
  jmp alltraps
80107160:	e9 61 f6 ff ff       	jmp    801067c6 <alltraps>

80107165 <vector60>:
.globl vector60
vector60:
  pushl $0
80107165:	6a 00                	push   $0x0
  pushl $60
80107167:	6a 3c                	push   $0x3c
  jmp alltraps
80107169:	e9 58 f6 ff ff       	jmp    801067c6 <alltraps>

8010716e <vector61>:
.globl vector61
vector61:
  pushl $0
8010716e:	6a 00                	push   $0x0
  pushl $61
80107170:	6a 3d                	push   $0x3d
  jmp alltraps
80107172:	e9 4f f6 ff ff       	jmp    801067c6 <alltraps>

80107177 <vector62>:
.globl vector62
vector62:
  pushl $0
80107177:	6a 00                	push   $0x0
  pushl $62
80107179:	6a 3e                	push   $0x3e
  jmp alltraps
8010717b:	e9 46 f6 ff ff       	jmp    801067c6 <alltraps>

80107180 <vector63>:
.globl vector63
vector63:
  pushl $0
80107180:	6a 00                	push   $0x0
  pushl $63
80107182:	6a 3f                	push   $0x3f
  jmp alltraps
80107184:	e9 3d f6 ff ff       	jmp    801067c6 <alltraps>

80107189 <vector64>:
.globl vector64
vector64:
  pushl $0
80107189:	6a 00                	push   $0x0
  pushl $64
8010718b:	6a 40                	push   $0x40
  jmp alltraps
8010718d:	e9 34 f6 ff ff       	jmp    801067c6 <alltraps>

80107192 <vector65>:
.globl vector65
vector65:
  pushl $0
80107192:	6a 00                	push   $0x0
  pushl $65
80107194:	6a 41                	push   $0x41
  jmp alltraps
80107196:	e9 2b f6 ff ff       	jmp    801067c6 <alltraps>

8010719b <vector66>:
.globl vector66
vector66:
  pushl $0
8010719b:	6a 00                	push   $0x0
  pushl $66
8010719d:	6a 42                	push   $0x42
  jmp alltraps
8010719f:	e9 22 f6 ff ff       	jmp    801067c6 <alltraps>

801071a4 <vector67>:
.globl vector67
vector67:
  pushl $0
801071a4:	6a 00                	push   $0x0
  pushl $67
801071a6:	6a 43                	push   $0x43
  jmp alltraps
801071a8:	e9 19 f6 ff ff       	jmp    801067c6 <alltraps>

801071ad <vector68>:
.globl vector68
vector68:
  pushl $0
801071ad:	6a 00                	push   $0x0
  pushl $68
801071af:	6a 44                	push   $0x44
  jmp alltraps
801071b1:	e9 10 f6 ff ff       	jmp    801067c6 <alltraps>

801071b6 <vector69>:
.globl vector69
vector69:
  pushl $0
801071b6:	6a 00                	push   $0x0
  pushl $69
801071b8:	6a 45                	push   $0x45
  jmp alltraps
801071ba:	e9 07 f6 ff ff       	jmp    801067c6 <alltraps>

801071bf <vector70>:
.globl vector70
vector70:
  pushl $0
801071bf:	6a 00                	push   $0x0
  pushl $70
801071c1:	6a 46                	push   $0x46
  jmp alltraps
801071c3:	e9 fe f5 ff ff       	jmp    801067c6 <alltraps>

801071c8 <vector71>:
.globl vector71
vector71:
  pushl $0
801071c8:	6a 00                	push   $0x0
  pushl $71
801071ca:	6a 47                	push   $0x47
  jmp alltraps
801071cc:	e9 f5 f5 ff ff       	jmp    801067c6 <alltraps>

801071d1 <vector72>:
.globl vector72
vector72:
  pushl $0
801071d1:	6a 00                	push   $0x0
  pushl $72
801071d3:	6a 48                	push   $0x48
  jmp alltraps
801071d5:	e9 ec f5 ff ff       	jmp    801067c6 <alltraps>

801071da <vector73>:
.globl vector73
vector73:
  pushl $0
801071da:	6a 00                	push   $0x0
  pushl $73
801071dc:	6a 49                	push   $0x49
  jmp alltraps
801071de:	e9 e3 f5 ff ff       	jmp    801067c6 <alltraps>

801071e3 <vector74>:
.globl vector74
vector74:
  pushl $0
801071e3:	6a 00                	push   $0x0
  pushl $74
801071e5:	6a 4a                	push   $0x4a
  jmp alltraps
801071e7:	e9 da f5 ff ff       	jmp    801067c6 <alltraps>

801071ec <vector75>:
.globl vector75
vector75:
  pushl $0
801071ec:	6a 00                	push   $0x0
  pushl $75
801071ee:	6a 4b                	push   $0x4b
  jmp alltraps
801071f0:	e9 d1 f5 ff ff       	jmp    801067c6 <alltraps>

801071f5 <vector76>:
.globl vector76
vector76:
  pushl $0
801071f5:	6a 00                	push   $0x0
  pushl $76
801071f7:	6a 4c                	push   $0x4c
  jmp alltraps
801071f9:	e9 c8 f5 ff ff       	jmp    801067c6 <alltraps>

801071fe <vector77>:
.globl vector77
vector77:
  pushl $0
801071fe:	6a 00                	push   $0x0
  pushl $77
80107200:	6a 4d                	push   $0x4d
  jmp alltraps
80107202:	e9 bf f5 ff ff       	jmp    801067c6 <alltraps>

80107207 <vector78>:
.globl vector78
vector78:
  pushl $0
80107207:	6a 00                	push   $0x0
  pushl $78
80107209:	6a 4e                	push   $0x4e
  jmp alltraps
8010720b:	e9 b6 f5 ff ff       	jmp    801067c6 <alltraps>

80107210 <vector79>:
.globl vector79
vector79:
  pushl $0
80107210:	6a 00                	push   $0x0
  pushl $79
80107212:	6a 4f                	push   $0x4f
  jmp alltraps
80107214:	e9 ad f5 ff ff       	jmp    801067c6 <alltraps>

80107219 <vector80>:
.globl vector80
vector80:
  pushl $0
80107219:	6a 00                	push   $0x0
  pushl $80
8010721b:	6a 50                	push   $0x50
  jmp alltraps
8010721d:	e9 a4 f5 ff ff       	jmp    801067c6 <alltraps>

80107222 <vector81>:
.globl vector81
vector81:
  pushl $0
80107222:	6a 00                	push   $0x0
  pushl $81
80107224:	6a 51                	push   $0x51
  jmp alltraps
80107226:	e9 9b f5 ff ff       	jmp    801067c6 <alltraps>

8010722b <vector82>:
.globl vector82
vector82:
  pushl $0
8010722b:	6a 00                	push   $0x0
  pushl $82
8010722d:	6a 52                	push   $0x52
  jmp alltraps
8010722f:	e9 92 f5 ff ff       	jmp    801067c6 <alltraps>

80107234 <vector83>:
.globl vector83
vector83:
  pushl $0
80107234:	6a 00                	push   $0x0
  pushl $83
80107236:	6a 53                	push   $0x53
  jmp alltraps
80107238:	e9 89 f5 ff ff       	jmp    801067c6 <alltraps>

8010723d <vector84>:
.globl vector84
vector84:
  pushl $0
8010723d:	6a 00                	push   $0x0
  pushl $84
8010723f:	6a 54                	push   $0x54
  jmp alltraps
80107241:	e9 80 f5 ff ff       	jmp    801067c6 <alltraps>

80107246 <vector85>:
.globl vector85
vector85:
  pushl $0
80107246:	6a 00                	push   $0x0
  pushl $85
80107248:	6a 55                	push   $0x55
  jmp alltraps
8010724a:	e9 77 f5 ff ff       	jmp    801067c6 <alltraps>

8010724f <vector86>:
.globl vector86
vector86:
  pushl $0
8010724f:	6a 00                	push   $0x0
  pushl $86
80107251:	6a 56                	push   $0x56
  jmp alltraps
80107253:	e9 6e f5 ff ff       	jmp    801067c6 <alltraps>

80107258 <vector87>:
.globl vector87
vector87:
  pushl $0
80107258:	6a 00                	push   $0x0
  pushl $87
8010725a:	6a 57                	push   $0x57
  jmp alltraps
8010725c:	e9 65 f5 ff ff       	jmp    801067c6 <alltraps>

80107261 <vector88>:
.globl vector88
vector88:
  pushl $0
80107261:	6a 00                	push   $0x0
  pushl $88
80107263:	6a 58                	push   $0x58
  jmp alltraps
80107265:	e9 5c f5 ff ff       	jmp    801067c6 <alltraps>

8010726a <vector89>:
.globl vector89
vector89:
  pushl $0
8010726a:	6a 00                	push   $0x0
  pushl $89
8010726c:	6a 59                	push   $0x59
  jmp alltraps
8010726e:	e9 53 f5 ff ff       	jmp    801067c6 <alltraps>

80107273 <vector90>:
.globl vector90
vector90:
  pushl $0
80107273:	6a 00                	push   $0x0
  pushl $90
80107275:	6a 5a                	push   $0x5a
  jmp alltraps
80107277:	e9 4a f5 ff ff       	jmp    801067c6 <alltraps>

8010727c <vector91>:
.globl vector91
vector91:
  pushl $0
8010727c:	6a 00                	push   $0x0
  pushl $91
8010727e:	6a 5b                	push   $0x5b
  jmp alltraps
80107280:	e9 41 f5 ff ff       	jmp    801067c6 <alltraps>

80107285 <vector92>:
.globl vector92
vector92:
  pushl $0
80107285:	6a 00                	push   $0x0
  pushl $92
80107287:	6a 5c                	push   $0x5c
  jmp alltraps
80107289:	e9 38 f5 ff ff       	jmp    801067c6 <alltraps>

8010728e <vector93>:
.globl vector93
vector93:
  pushl $0
8010728e:	6a 00                	push   $0x0
  pushl $93
80107290:	6a 5d                	push   $0x5d
  jmp alltraps
80107292:	e9 2f f5 ff ff       	jmp    801067c6 <alltraps>

80107297 <vector94>:
.globl vector94
vector94:
  pushl $0
80107297:	6a 00                	push   $0x0
  pushl $94
80107299:	6a 5e                	push   $0x5e
  jmp alltraps
8010729b:	e9 26 f5 ff ff       	jmp    801067c6 <alltraps>

801072a0 <vector95>:
.globl vector95
vector95:
  pushl $0
801072a0:	6a 00                	push   $0x0
  pushl $95
801072a2:	6a 5f                	push   $0x5f
  jmp alltraps
801072a4:	e9 1d f5 ff ff       	jmp    801067c6 <alltraps>

801072a9 <vector96>:
.globl vector96
vector96:
  pushl $0
801072a9:	6a 00                	push   $0x0
  pushl $96
801072ab:	6a 60                	push   $0x60
  jmp alltraps
801072ad:	e9 14 f5 ff ff       	jmp    801067c6 <alltraps>

801072b2 <vector97>:
.globl vector97
vector97:
  pushl $0
801072b2:	6a 00                	push   $0x0
  pushl $97
801072b4:	6a 61                	push   $0x61
  jmp alltraps
801072b6:	e9 0b f5 ff ff       	jmp    801067c6 <alltraps>

801072bb <vector98>:
.globl vector98
vector98:
  pushl $0
801072bb:	6a 00                	push   $0x0
  pushl $98
801072bd:	6a 62                	push   $0x62
  jmp alltraps
801072bf:	e9 02 f5 ff ff       	jmp    801067c6 <alltraps>

801072c4 <vector99>:
.globl vector99
vector99:
  pushl $0
801072c4:	6a 00                	push   $0x0
  pushl $99
801072c6:	6a 63                	push   $0x63
  jmp alltraps
801072c8:	e9 f9 f4 ff ff       	jmp    801067c6 <alltraps>

801072cd <vector100>:
.globl vector100
vector100:
  pushl $0
801072cd:	6a 00                	push   $0x0
  pushl $100
801072cf:	6a 64                	push   $0x64
  jmp alltraps
801072d1:	e9 f0 f4 ff ff       	jmp    801067c6 <alltraps>

801072d6 <vector101>:
.globl vector101
vector101:
  pushl $0
801072d6:	6a 00                	push   $0x0
  pushl $101
801072d8:	6a 65                	push   $0x65
  jmp alltraps
801072da:	e9 e7 f4 ff ff       	jmp    801067c6 <alltraps>

801072df <vector102>:
.globl vector102
vector102:
  pushl $0
801072df:	6a 00                	push   $0x0
  pushl $102
801072e1:	6a 66                	push   $0x66
  jmp alltraps
801072e3:	e9 de f4 ff ff       	jmp    801067c6 <alltraps>

801072e8 <vector103>:
.globl vector103
vector103:
  pushl $0
801072e8:	6a 00                	push   $0x0
  pushl $103
801072ea:	6a 67                	push   $0x67
  jmp alltraps
801072ec:	e9 d5 f4 ff ff       	jmp    801067c6 <alltraps>

801072f1 <vector104>:
.globl vector104
vector104:
  pushl $0
801072f1:	6a 00                	push   $0x0
  pushl $104
801072f3:	6a 68                	push   $0x68
  jmp alltraps
801072f5:	e9 cc f4 ff ff       	jmp    801067c6 <alltraps>

801072fa <vector105>:
.globl vector105
vector105:
  pushl $0
801072fa:	6a 00                	push   $0x0
  pushl $105
801072fc:	6a 69                	push   $0x69
  jmp alltraps
801072fe:	e9 c3 f4 ff ff       	jmp    801067c6 <alltraps>

80107303 <vector106>:
.globl vector106
vector106:
  pushl $0
80107303:	6a 00                	push   $0x0
  pushl $106
80107305:	6a 6a                	push   $0x6a
  jmp alltraps
80107307:	e9 ba f4 ff ff       	jmp    801067c6 <alltraps>

8010730c <vector107>:
.globl vector107
vector107:
  pushl $0
8010730c:	6a 00                	push   $0x0
  pushl $107
8010730e:	6a 6b                	push   $0x6b
  jmp alltraps
80107310:	e9 b1 f4 ff ff       	jmp    801067c6 <alltraps>

80107315 <vector108>:
.globl vector108
vector108:
  pushl $0
80107315:	6a 00                	push   $0x0
  pushl $108
80107317:	6a 6c                	push   $0x6c
  jmp alltraps
80107319:	e9 a8 f4 ff ff       	jmp    801067c6 <alltraps>

8010731e <vector109>:
.globl vector109
vector109:
  pushl $0
8010731e:	6a 00                	push   $0x0
  pushl $109
80107320:	6a 6d                	push   $0x6d
  jmp alltraps
80107322:	e9 9f f4 ff ff       	jmp    801067c6 <alltraps>

80107327 <vector110>:
.globl vector110
vector110:
  pushl $0
80107327:	6a 00                	push   $0x0
  pushl $110
80107329:	6a 6e                	push   $0x6e
  jmp alltraps
8010732b:	e9 96 f4 ff ff       	jmp    801067c6 <alltraps>

80107330 <vector111>:
.globl vector111
vector111:
  pushl $0
80107330:	6a 00                	push   $0x0
  pushl $111
80107332:	6a 6f                	push   $0x6f
  jmp alltraps
80107334:	e9 8d f4 ff ff       	jmp    801067c6 <alltraps>

80107339 <vector112>:
.globl vector112
vector112:
  pushl $0
80107339:	6a 00                	push   $0x0
  pushl $112
8010733b:	6a 70                	push   $0x70
  jmp alltraps
8010733d:	e9 84 f4 ff ff       	jmp    801067c6 <alltraps>

80107342 <vector113>:
.globl vector113
vector113:
  pushl $0
80107342:	6a 00                	push   $0x0
  pushl $113
80107344:	6a 71                	push   $0x71
  jmp alltraps
80107346:	e9 7b f4 ff ff       	jmp    801067c6 <alltraps>

8010734b <vector114>:
.globl vector114
vector114:
  pushl $0
8010734b:	6a 00                	push   $0x0
  pushl $114
8010734d:	6a 72                	push   $0x72
  jmp alltraps
8010734f:	e9 72 f4 ff ff       	jmp    801067c6 <alltraps>

80107354 <vector115>:
.globl vector115
vector115:
  pushl $0
80107354:	6a 00                	push   $0x0
  pushl $115
80107356:	6a 73                	push   $0x73
  jmp alltraps
80107358:	e9 69 f4 ff ff       	jmp    801067c6 <alltraps>

8010735d <vector116>:
.globl vector116
vector116:
  pushl $0
8010735d:	6a 00                	push   $0x0
  pushl $116
8010735f:	6a 74                	push   $0x74
  jmp alltraps
80107361:	e9 60 f4 ff ff       	jmp    801067c6 <alltraps>

80107366 <vector117>:
.globl vector117
vector117:
  pushl $0
80107366:	6a 00                	push   $0x0
  pushl $117
80107368:	6a 75                	push   $0x75
  jmp alltraps
8010736a:	e9 57 f4 ff ff       	jmp    801067c6 <alltraps>

8010736f <vector118>:
.globl vector118
vector118:
  pushl $0
8010736f:	6a 00                	push   $0x0
  pushl $118
80107371:	6a 76                	push   $0x76
  jmp alltraps
80107373:	e9 4e f4 ff ff       	jmp    801067c6 <alltraps>

80107378 <vector119>:
.globl vector119
vector119:
  pushl $0
80107378:	6a 00                	push   $0x0
  pushl $119
8010737a:	6a 77                	push   $0x77
  jmp alltraps
8010737c:	e9 45 f4 ff ff       	jmp    801067c6 <alltraps>

80107381 <vector120>:
.globl vector120
vector120:
  pushl $0
80107381:	6a 00                	push   $0x0
  pushl $120
80107383:	6a 78                	push   $0x78
  jmp alltraps
80107385:	e9 3c f4 ff ff       	jmp    801067c6 <alltraps>

8010738a <vector121>:
.globl vector121
vector121:
  pushl $0
8010738a:	6a 00                	push   $0x0
  pushl $121
8010738c:	6a 79                	push   $0x79
  jmp alltraps
8010738e:	e9 33 f4 ff ff       	jmp    801067c6 <alltraps>

80107393 <vector122>:
.globl vector122
vector122:
  pushl $0
80107393:	6a 00                	push   $0x0
  pushl $122
80107395:	6a 7a                	push   $0x7a
  jmp alltraps
80107397:	e9 2a f4 ff ff       	jmp    801067c6 <alltraps>

8010739c <vector123>:
.globl vector123
vector123:
  pushl $0
8010739c:	6a 00                	push   $0x0
  pushl $123
8010739e:	6a 7b                	push   $0x7b
  jmp alltraps
801073a0:	e9 21 f4 ff ff       	jmp    801067c6 <alltraps>

801073a5 <vector124>:
.globl vector124
vector124:
  pushl $0
801073a5:	6a 00                	push   $0x0
  pushl $124
801073a7:	6a 7c                	push   $0x7c
  jmp alltraps
801073a9:	e9 18 f4 ff ff       	jmp    801067c6 <alltraps>

801073ae <vector125>:
.globl vector125
vector125:
  pushl $0
801073ae:	6a 00                	push   $0x0
  pushl $125
801073b0:	6a 7d                	push   $0x7d
  jmp alltraps
801073b2:	e9 0f f4 ff ff       	jmp    801067c6 <alltraps>

801073b7 <vector126>:
.globl vector126
vector126:
  pushl $0
801073b7:	6a 00                	push   $0x0
  pushl $126
801073b9:	6a 7e                	push   $0x7e
  jmp alltraps
801073bb:	e9 06 f4 ff ff       	jmp    801067c6 <alltraps>

801073c0 <vector127>:
.globl vector127
vector127:
  pushl $0
801073c0:	6a 00                	push   $0x0
  pushl $127
801073c2:	6a 7f                	push   $0x7f
  jmp alltraps
801073c4:	e9 fd f3 ff ff       	jmp    801067c6 <alltraps>

801073c9 <vector128>:
.globl vector128
vector128:
  pushl $0
801073c9:	6a 00                	push   $0x0
  pushl $128
801073cb:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801073d0:	e9 f1 f3 ff ff       	jmp    801067c6 <alltraps>

801073d5 <vector129>:
.globl vector129
vector129:
  pushl $0
801073d5:	6a 00                	push   $0x0
  pushl $129
801073d7:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801073dc:	e9 e5 f3 ff ff       	jmp    801067c6 <alltraps>

801073e1 <vector130>:
.globl vector130
vector130:
  pushl $0
801073e1:	6a 00                	push   $0x0
  pushl $130
801073e3:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801073e8:	e9 d9 f3 ff ff       	jmp    801067c6 <alltraps>

801073ed <vector131>:
.globl vector131
vector131:
  pushl $0
801073ed:	6a 00                	push   $0x0
  pushl $131
801073ef:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801073f4:	e9 cd f3 ff ff       	jmp    801067c6 <alltraps>

801073f9 <vector132>:
.globl vector132
vector132:
  pushl $0
801073f9:	6a 00                	push   $0x0
  pushl $132
801073fb:	68 84 00 00 00       	push   $0x84
  jmp alltraps
80107400:	e9 c1 f3 ff ff       	jmp    801067c6 <alltraps>

80107405 <vector133>:
.globl vector133
vector133:
  pushl $0
80107405:	6a 00                	push   $0x0
  pushl $133
80107407:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010740c:	e9 b5 f3 ff ff       	jmp    801067c6 <alltraps>

80107411 <vector134>:
.globl vector134
vector134:
  pushl $0
80107411:	6a 00                	push   $0x0
  pushl $134
80107413:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107418:	e9 a9 f3 ff ff       	jmp    801067c6 <alltraps>

8010741d <vector135>:
.globl vector135
vector135:
  pushl $0
8010741d:	6a 00                	push   $0x0
  pushl $135
8010741f:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107424:	e9 9d f3 ff ff       	jmp    801067c6 <alltraps>

80107429 <vector136>:
.globl vector136
vector136:
  pushl $0
80107429:	6a 00                	push   $0x0
  pushl $136
8010742b:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80107430:	e9 91 f3 ff ff       	jmp    801067c6 <alltraps>

80107435 <vector137>:
.globl vector137
vector137:
  pushl $0
80107435:	6a 00                	push   $0x0
  pushl $137
80107437:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010743c:	e9 85 f3 ff ff       	jmp    801067c6 <alltraps>

80107441 <vector138>:
.globl vector138
vector138:
  pushl $0
80107441:	6a 00                	push   $0x0
  pushl $138
80107443:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107448:	e9 79 f3 ff ff       	jmp    801067c6 <alltraps>

8010744d <vector139>:
.globl vector139
vector139:
  pushl $0
8010744d:	6a 00                	push   $0x0
  pushl $139
8010744f:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107454:	e9 6d f3 ff ff       	jmp    801067c6 <alltraps>

80107459 <vector140>:
.globl vector140
vector140:
  pushl $0
80107459:	6a 00                	push   $0x0
  pushl $140
8010745b:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80107460:	e9 61 f3 ff ff       	jmp    801067c6 <alltraps>

80107465 <vector141>:
.globl vector141
vector141:
  pushl $0
80107465:	6a 00                	push   $0x0
  pushl $141
80107467:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010746c:	e9 55 f3 ff ff       	jmp    801067c6 <alltraps>

80107471 <vector142>:
.globl vector142
vector142:
  pushl $0
80107471:	6a 00                	push   $0x0
  pushl $142
80107473:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107478:	e9 49 f3 ff ff       	jmp    801067c6 <alltraps>

8010747d <vector143>:
.globl vector143
vector143:
  pushl $0
8010747d:	6a 00                	push   $0x0
  pushl $143
8010747f:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107484:	e9 3d f3 ff ff       	jmp    801067c6 <alltraps>

80107489 <vector144>:
.globl vector144
vector144:
  pushl $0
80107489:	6a 00                	push   $0x0
  pushl $144
8010748b:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80107490:	e9 31 f3 ff ff       	jmp    801067c6 <alltraps>

80107495 <vector145>:
.globl vector145
vector145:
  pushl $0
80107495:	6a 00                	push   $0x0
  pushl $145
80107497:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010749c:	e9 25 f3 ff ff       	jmp    801067c6 <alltraps>

801074a1 <vector146>:
.globl vector146
vector146:
  pushl $0
801074a1:	6a 00                	push   $0x0
  pushl $146
801074a3:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801074a8:	e9 19 f3 ff ff       	jmp    801067c6 <alltraps>

801074ad <vector147>:
.globl vector147
vector147:
  pushl $0
801074ad:	6a 00                	push   $0x0
  pushl $147
801074af:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801074b4:	e9 0d f3 ff ff       	jmp    801067c6 <alltraps>

801074b9 <vector148>:
.globl vector148
vector148:
  pushl $0
801074b9:	6a 00                	push   $0x0
  pushl $148
801074bb:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801074c0:	e9 01 f3 ff ff       	jmp    801067c6 <alltraps>

801074c5 <vector149>:
.globl vector149
vector149:
  pushl $0
801074c5:	6a 00                	push   $0x0
  pushl $149
801074c7:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801074cc:	e9 f5 f2 ff ff       	jmp    801067c6 <alltraps>

801074d1 <vector150>:
.globl vector150
vector150:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $150
801074d3:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801074d8:	e9 e9 f2 ff ff       	jmp    801067c6 <alltraps>

801074dd <vector151>:
.globl vector151
vector151:
  pushl $0
801074dd:	6a 00                	push   $0x0
  pushl $151
801074df:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801074e4:	e9 dd f2 ff ff       	jmp    801067c6 <alltraps>

801074e9 <vector152>:
.globl vector152
vector152:
  pushl $0
801074e9:	6a 00                	push   $0x0
  pushl $152
801074eb:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801074f0:	e9 d1 f2 ff ff       	jmp    801067c6 <alltraps>

801074f5 <vector153>:
.globl vector153
vector153:
  pushl $0
801074f5:	6a 00                	push   $0x0
  pushl $153
801074f7:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801074fc:	e9 c5 f2 ff ff       	jmp    801067c6 <alltraps>

80107501 <vector154>:
.globl vector154
vector154:
  pushl $0
80107501:	6a 00                	push   $0x0
  pushl $154
80107503:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107508:	e9 b9 f2 ff ff       	jmp    801067c6 <alltraps>

8010750d <vector155>:
.globl vector155
vector155:
  pushl $0
8010750d:	6a 00                	push   $0x0
  pushl $155
8010750f:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107514:	e9 ad f2 ff ff       	jmp    801067c6 <alltraps>

80107519 <vector156>:
.globl vector156
vector156:
  pushl $0
80107519:	6a 00                	push   $0x0
  pushl $156
8010751b:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107520:	e9 a1 f2 ff ff       	jmp    801067c6 <alltraps>

80107525 <vector157>:
.globl vector157
vector157:
  pushl $0
80107525:	6a 00                	push   $0x0
  pushl $157
80107527:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010752c:	e9 95 f2 ff ff       	jmp    801067c6 <alltraps>

80107531 <vector158>:
.globl vector158
vector158:
  pushl $0
80107531:	6a 00                	push   $0x0
  pushl $158
80107533:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107538:	e9 89 f2 ff ff       	jmp    801067c6 <alltraps>

8010753d <vector159>:
.globl vector159
vector159:
  pushl $0
8010753d:	6a 00                	push   $0x0
  pushl $159
8010753f:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107544:	e9 7d f2 ff ff       	jmp    801067c6 <alltraps>

80107549 <vector160>:
.globl vector160
vector160:
  pushl $0
80107549:	6a 00                	push   $0x0
  pushl $160
8010754b:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107550:	e9 71 f2 ff ff       	jmp    801067c6 <alltraps>

80107555 <vector161>:
.globl vector161
vector161:
  pushl $0
80107555:	6a 00                	push   $0x0
  pushl $161
80107557:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010755c:	e9 65 f2 ff ff       	jmp    801067c6 <alltraps>

80107561 <vector162>:
.globl vector162
vector162:
  pushl $0
80107561:	6a 00                	push   $0x0
  pushl $162
80107563:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107568:	e9 59 f2 ff ff       	jmp    801067c6 <alltraps>

8010756d <vector163>:
.globl vector163
vector163:
  pushl $0
8010756d:	6a 00                	push   $0x0
  pushl $163
8010756f:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107574:	e9 4d f2 ff ff       	jmp    801067c6 <alltraps>

80107579 <vector164>:
.globl vector164
vector164:
  pushl $0
80107579:	6a 00                	push   $0x0
  pushl $164
8010757b:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107580:	e9 41 f2 ff ff       	jmp    801067c6 <alltraps>

80107585 <vector165>:
.globl vector165
vector165:
  pushl $0
80107585:	6a 00                	push   $0x0
  pushl $165
80107587:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010758c:	e9 35 f2 ff ff       	jmp    801067c6 <alltraps>

80107591 <vector166>:
.globl vector166
vector166:
  pushl $0
80107591:	6a 00                	push   $0x0
  pushl $166
80107593:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107598:	e9 29 f2 ff ff       	jmp    801067c6 <alltraps>

8010759d <vector167>:
.globl vector167
vector167:
  pushl $0
8010759d:	6a 00                	push   $0x0
  pushl $167
8010759f:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801075a4:	e9 1d f2 ff ff       	jmp    801067c6 <alltraps>

801075a9 <vector168>:
.globl vector168
vector168:
  pushl $0
801075a9:	6a 00                	push   $0x0
  pushl $168
801075ab:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801075b0:	e9 11 f2 ff ff       	jmp    801067c6 <alltraps>

801075b5 <vector169>:
.globl vector169
vector169:
  pushl $0
801075b5:	6a 00                	push   $0x0
  pushl $169
801075b7:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801075bc:	e9 05 f2 ff ff       	jmp    801067c6 <alltraps>

801075c1 <vector170>:
.globl vector170
vector170:
  pushl $0
801075c1:	6a 00                	push   $0x0
  pushl $170
801075c3:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801075c8:	e9 f9 f1 ff ff       	jmp    801067c6 <alltraps>

801075cd <vector171>:
.globl vector171
vector171:
  pushl $0
801075cd:	6a 00                	push   $0x0
  pushl $171
801075cf:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801075d4:	e9 ed f1 ff ff       	jmp    801067c6 <alltraps>

801075d9 <vector172>:
.globl vector172
vector172:
  pushl $0
801075d9:	6a 00                	push   $0x0
  pushl $172
801075db:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801075e0:	e9 e1 f1 ff ff       	jmp    801067c6 <alltraps>

801075e5 <vector173>:
.globl vector173
vector173:
  pushl $0
801075e5:	6a 00                	push   $0x0
  pushl $173
801075e7:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801075ec:	e9 d5 f1 ff ff       	jmp    801067c6 <alltraps>

801075f1 <vector174>:
.globl vector174
vector174:
  pushl $0
801075f1:	6a 00                	push   $0x0
  pushl $174
801075f3:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801075f8:	e9 c9 f1 ff ff       	jmp    801067c6 <alltraps>

801075fd <vector175>:
.globl vector175
vector175:
  pushl $0
801075fd:	6a 00                	push   $0x0
  pushl $175
801075ff:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107604:	e9 bd f1 ff ff       	jmp    801067c6 <alltraps>

80107609 <vector176>:
.globl vector176
vector176:
  pushl $0
80107609:	6a 00                	push   $0x0
  pushl $176
8010760b:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107610:	e9 b1 f1 ff ff       	jmp    801067c6 <alltraps>

80107615 <vector177>:
.globl vector177
vector177:
  pushl $0
80107615:	6a 00                	push   $0x0
  pushl $177
80107617:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010761c:	e9 a5 f1 ff ff       	jmp    801067c6 <alltraps>

80107621 <vector178>:
.globl vector178
vector178:
  pushl $0
80107621:	6a 00                	push   $0x0
  pushl $178
80107623:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107628:	e9 99 f1 ff ff       	jmp    801067c6 <alltraps>

8010762d <vector179>:
.globl vector179
vector179:
  pushl $0
8010762d:	6a 00                	push   $0x0
  pushl $179
8010762f:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107634:	e9 8d f1 ff ff       	jmp    801067c6 <alltraps>

80107639 <vector180>:
.globl vector180
vector180:
  pushl $0
80107639:	6a 00                	push   $0x0
  pushl $180
8010763b:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107640:	e9 81 f1 ff ff       	jmp    801067c6 <alltraps>

80107645 <vector181>:
.globl vector181
vector181:
  pushl $0
80107645:	6a 00                	push   $0x0
  pushl $181
80107647:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010764c:	e9 75 f1 ff ff       	jmp    801067c6 <alltraps>

80107651 <vector182>:
.globl vector182
vector182:
  pushl $0
80107651:	6a 00                	push   $0x0
  pushl $182
80107653:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107658:	e9 69 f1 ff ff       	jmp    801067c6 <alltraps>

8010765d <vector183>:
.globl vector183
vector183:
  pushl $0
8010765d:	6a 00                	push   $0x0
  pushl $183
8010765f:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107664:	e9 5d f1 ff ff       	jmp    801067c6 <alltraps>

80107669 <vector184>:
.globl vector184
vector184:
  pushl $0
80107669:	6a 00                	push   $0x0
  pushl $184
8010766b:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107670:	e9 51 f1 ff ff       	jmp    801067c6 <alltraps>

80107675 <vector185>:
.globl vector185
vector185:
  pushl $0
80107675:	6a 00                	push   $0x0
  pushl $185
80107677:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010767c:	e9 45 f1 ff ff       	jmp    801067c6 <alltraps>

80107681 <vector186>:
.globl vector186
vector186:
  pushl $0
80107681:	6a 00                	push   $0x0
  pushl $186
80107683:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107688:	e9 39 f1 ff ff       	jmp    801067c6 <alltraps>

8010768d <vector187>:
.globl vector187
vector187:
  pushl $0
8010768d:	6a 00                	push   $0x0
  pushl $187
8010768f:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107694:	e9 2d f1 ff ff       	jmp    801067c6 <alltraps>

80107699 <vector188>:
.globl vector188
vector188:
  pushl $0
80107699:	6a 00                	push   $0x0
  pushl $188
8010769b:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801076a0:	e9 21 f1 ff ff       	jmp    801067c6 <alltraps>

801076a5 <vector189>:
.globl vector189
vector189:
  pushl $0
801076a5:	6a 00                	push   $0x0
  pushl $189
801076a7:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801076ac:	e9 15 f1 ff ff       	jmp    801067c6 <alltraps>

801076b1 <vector190>:
.globl vector190
vector190:
  pushl $0
801076b1:	6a 00                	push   $0x0
  pushl $190
801076b3:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801076b8:	e9 09 f1 ff ff       	jmp    801067c6 <alltraps>

801076bd <vector191>:
.globl vector191
vector191:
  pushl $0
801076bd:	6a 00                	push   $0x0
  pushl $191
801076bf:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801076c4:	e9 fd f0 ff ff       	jmp    801067c6 <alltraps>

801076c9 <vector192>:
.globl vector192
vector192:
  pushl $0
801076c9:	6a 00                	push   $0x0
  pushl $192
801076cb:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801076d0:	e9 f1 f0 ff ff       	jmp    801067c6 <alltraps>

801076d5 <vector193>:
.globl vector193
vector193:
  pushl $0
801076d5:	6a 00                	push   $0x0
  pushl $193
801076d7:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801076dc:	e9 e5 f0 ff ff       	jmp    801067c6 <alltraps>

801076e1 <vector194>:
.globl vector194
vector194:
  pushl $0
801076e1:	6a 00                	push   $0x0
  pushl $194
801076e3:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801076e8:	e9 d9 f0 ff ff       	jmp    801067c6 <alltraps>

801076ed <vector195>:
.globl vector195
vector195:
  pushl $0
801076ed:	6a 00                	push   $0x0
  pushl $195
801076ef:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801076f4:	e9 cd f0 ff ff       	jmp    801067c6 <alltraps>

801076f9 <vector196>:
.globl vector196
vector196:
  pushl $0
801076f9:	6a 00                	push   $0x0
  pushl $196
801076fb:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107700:	e9 c1 f0 ff ff       	jmp    801067c6 <alltraps>

80107705 <vector197>:
.globl vector197
vector197:
  pushl $0
80107705:	6a 00                	push   $0x0
  pushl $197
80107707:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010770c:	e9 b5 f0 ff ff       	jmp    801067c6 <alltraps>

80107711 <vector198>:
.globl vector198
vector198:
  pushl $0
80107711:	6a 00                	push   $0x0
  pushl $198
80107713:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107718:	e9 a9 f0 ff ff       	jmp    801067c6 <alltraps>

8010771d <vector199>:
.globl vector199
vector199:
  pushl $0
8010771d:	6a 00                	push   $0x0
  pushl $199
8010771f:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107724:	e9 9d f0 ff ff       	jmp    801067c6 <alltraps>

80107729 <vector200>:
.globl vector200
vector200:
  pushl $0
80107729:	6a 00                	push   $0x0
  pushl $200
8010772b:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107730:	e9 91 f0 ff ff       	jmp    801067c6 <alltraps>

80107735 <vector201>:
.globl vector201
vector201:
  pushl $0
80107735:	6a 00                	push   $0x0
  pushl $201
80107737:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010773c:	e9 85 f0 ff ff       	jmp    801067c6 <alltraps>

80107741 <vector202>:
.globl vector202
vector202:
  pushl $0
80107741:	6a 00                	push   $0x0
  pushl $202
80107743:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107748:	e9 79 f0 ff ff       	jmp    801067c6 <alltraps>

8010774d <vector203>:
.globl vector203
vector203:
  pushl $0
8010774d:	6a 00                	push   $0x0
  pushl $203
8010774f:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107754:	e9 6d f0 ff ff       	jmp    801067c6 <alltraps>

80107759 <vector204>:
.globl vector204
vector204:
  pushl $0
80107759:	6a 00                	push   $0x0
  pushl $204
8010775b:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107760:	e9 61 f0 ff ff       	jmp    801067c6 <alltraps>

80107765 <vector205>:
.globl vector205
vector205:
  pushl $0
80107765:	6a 00                	push   $0x0
  pushl $205
80107767:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010776c:	e9 55 f0 ff ff       	jmp    801067c6 <alltraps>

80107771 <vector206>:
.globl vector206
vector206:
  pushl $0
80107771:	6a 00                	push   $0x0
  pushl $206
80107773:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107778:	e9 49 f0 ff ff       	jmp    801067c6 <alltraps>

8010777d <vector207>:
.globl vector207
vector207:
  pushl $0
8010777d:	6a 00                	push   $0x0
  pushl $207
8010777f:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107784:	e9 3d f0 ff ff       	jmp    801067c6 <alltraps>

80107789 <vector208>:
.globl vector208
vector208:
  pushl $0
80107789:	6a 00                	push   $0x0
  pushl $208
8010778b:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107790:	e9 31 f0 ff ff       	jmp    801067c6 <alltraps>

80107795 <vector209>:
.globl vector209
vector209:
  pushl $0
80107795:	6a 00                	push   $0x0
  pushl $209
80107797:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
8010779c:	e9 25 f0 ff ff       	jmp    801067c6 <alltraps>

801077a1 <vector210>:
.globl vector210
vector210:
  pushl $0
801077a1:	6a 00                	push   $0x0
  pushl $210
801077a3:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801077a8:	e9 19 f0 ff ff       	jmp    801067c6 <alltraps>

801077ad <vector211>:
.globl vector211
vector211:
  pushl $0
801077ad:	6a 00                	push   $0x0
  pushl $211
801077af:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801077b4:	e9 0d f0 ff ff       	jmp    801067c6 <alltraps>

801077b9 <vector212>:
.globl vector212
vector212:
  pushl $0
801077b9:	6a 00                	push   $0x0
  pushl $212
801077bb:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801077c0:	e9 01 f0 ff ff       	jmp    801067c6 <alltraps>

801077c5 <vector213>:
.globl vector213
vector213:
  pushl $0
801077c5:	6a 00                	push   $0x0
  pushl $213
801077c7:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801077cc:	e9 f5 ef ff ff       	jmp    801067c6 <alltraps>

801077d1 <vector214>:
.globl vector214
vector214:
  pushl $0
801077d1:	6a 00                	push   $0x0
  pushl $214
801077d3:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801077d8:	e9 e9 ef ff ff       	jmp    801067c6 <alltraps>

801077dd <vector215>:
.globl vector215
vector215:
  pushl $0
801077dd:	6a 00                	push   $0x0
  pushl $215
801077df:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801077e4:	e9 dd ef ff ff       	jmp    801067c6 <alltraps>

801077e9 <vector216>:
.globl vector216
vector216:
  pushl $0
801077e9:	6a 00                	push   $0x0
  pushl $216
801077eb:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801077f0:	e9 d1 ef ff ff       	jmp    801067c6 <alltraps>

801077f5 <vector217>:
.globl vector217
vector217:
  pushl $0
801077f5:	6a 00                	push   $0x0
  pushl $217
801077f7:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
801077fc:	e9 c5 ef ff ff       	jmp    801067c6 <alltraps>

80107801 <vector218>:
.globl vector218
vector218:
  pushl $0
80107801:	6a 00                	push   $0x0
  pushl $218
80107803:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107808:	e9 b9 ef ff ff       	jmp    801067c6 <alltraps>

8010780d <vector219>:
.globl vector219
vector219:
  pushl $0
8010780d:	6a 00                	push   $0x0
  pushl $219
8010780f:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107814:	e9 ad ef ff ff       	jmp    801067c6 <alltraps>

80107819 <vector220>:
.globl vector220
vector220:
  pushl $0
80107819:	6a 00                	push   $0x0
  pushl $220
8010781b:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107820:	e9 a1 ef ff ff       	jmp    801067c6 <alltraps>

80107825 <vector221>:
.globl vector221
vector221:
  pushl $0
80107825:	6a 00                	push   $0x0
  pushl $221
80107827:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010782c:	e9 95 ef ff ff       	jmp    801067c6 <alltraps>

80107831 <vector222>:
.globl vector222
vector222:
  pushl $0
80107831:	6a 00                	push   $0x0
  pushl $222
80107833:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107838:	e9 89 ef ff ff       	jmp    801067c6 <alltraps>

8010783d <vector223>:
.globl vector223
vector223:
  pushl $0
8010783d:	6a 00                	push   $0x0
  pushl $223
8010783f:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107844:	e9 7d ef ff ff       	jmp    801067c6 <alltraps>

80107849 <vector224>:
.globl vector224
vector224:
  pushl $0
80107849:	6a 00                	push   $0x0
  pushl $224
8010784b:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107850:	e9 71 ef ff ff       	jmp    801067c6 <alltraps>

80107855 <vector225>:
.globl vector225
vector225:
  pushl $0
80107855:	6a 00                	push   $0x0
  pushl $225
80107857:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010785c:	e9 65 ef ff ff       	jmp    801067c6 <alltraps>

80107861 <vector226>:
.globl vector226
vector226:
  pushl $0
80107861:	6a 00                	push   $0x0
  pushl $226
80107863:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107868:	e9 59 ef ff ff       	jmp    801067c6 <alltraps>

8010786d <vector227>:
.globl vector227
vector227:
  pushl $0
8010786d:	6a 00                	push   $0x0
  pushl $227
8010786f:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107874:	e9 4d ef ff ff       	jmp    801067c6 <alltraps>

80107879 <vector228>:
.globl vector228
vector228:
  pushl $0
80107879:	6a 00                	push   $0x0
  pushl $228
8010787b:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107880:	e9 41 ef ff ff       	jmp    801067c6 <alltraps>

80107885 <vector229>:
.globl vector229
vector229:
  pushl $0
80107885:	6a 00                	push   $0x0
  pushl $229
80107887:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010788c:	e9 35 ef ff ff       	jmp    801067c6 <alltraps>

80107891 <vector230>:
.globl vector230
vector230:
  pushl $0
80107891:	6a 00                	push   $0x0
  pushl $230
80107893:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107898:	e9 29 ef ff ff       	jmp    801067c6 <alltraps>

8010789d <vector231>:
.globl vector231
vector231:
  pushl $0
8010789d:	6a 00                	push   $0x0
  pushl $231
8010789f:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801078a4:	e9 1d ef ff ff       	jmp    801067c6 <alltraps>

801078a9 <vector232>:
.globl vector232
vector232:
  pushl $0
801078a9:	6a 00                	push   $0x0
  pushl $232
801078ab:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801078b0:	e9 11 ef ff ff       	jmp    801067c6 <alltraps>

801078b5 <vector233>:
.globl vector233
vector233:
  pushl $0
801078b5:	6a 00                	push   $0x0
  pushl $233
801078b7:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801078bc:	e9 05 ef ff ff       	jmp    801067c6 <alltraps>

801078c1 <vector234>:
.globl vector234
vector234:
  pushl $0
801078c1:	6a 00                	push   $0x0
  pushl $234
801078c3:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801078c8:	e9 f9 ee ff ff       	jmp    801067c6 <alltraps>

801078cd <vector235>:
.globl vector235
vector235:
  pushl $0
801078cd:	6a 00                	push   $0x0
  pushl $235
801078cf:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801078d4:	e9 ed ee ff ff       	jmp    801067c6 <alltraps>

801078d9 <vector236>:
.globl vector236
vector236:
  pushl $0
801078d9:	6a 00                	push   $0x0
  pushl $236
801078db:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801078e0:	e9 e1 ee ff ff       	jmp    801067c6 <alltraps>

801078e5 <vector237>:
.globl vector237
vector237:
  pushl $0
801078e5:	6a 00                	push   $0x0
  pushl $237
801078e7:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801078ec:	e9 d5 ee ff ff       	jmp    801067c6 <alltraps>

801078f1 <vector238>:
.globl vector238
vector238:
  pushl $0
801078f1:	6a 00                	push   $0x0
  pushl $238
801078f3:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
801078f8:	e9 c9 ee ff ff       	jmp    801067c6 <alltraps>

801078fd <vector239>:
.globl vector239
vector239:
  pushl $0
801078fd:	6a 00                	push   $0x0
  pushl $239
801078ff:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107904:	e9 bd ee ff ff       	jmp    801067c6 <alltraps>

80107909 <vector240>:
.globl vector240
vector240:
  pushl $0
80107909:	6a 00                	push   $0x0
  pushl $240
8010790b:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107910:	e9 b1 ee ff ff       	jmp    801067c6 <alltraps>

80107915 <vector241>:
.globl vector241
vector241:
  pushl $0
80107915:	6a 00                	push   $0x0
  pushl $241
80107917:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010791c:	e9 a5 ee ff ff       	jmp    801067c6 <alltraps>

80107921 <vector242>:
.globl vector242
vector242:
  pushl $0
80107921:	6a 00                	push   $0x0
  pushl $242
80107923:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107928:	e9 99 ee ff ff       	jmp    801067c6 <alltraps>

8010792d <vector243>:
.globl vector243
vector243:
  pushl $0
8010792d:	6a 00                	push   $0x0
  pushl $243
8010792f:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107934:	e9 8d ee ff ff       	jmp    801067c6 <alltraps>

80107939 <vector244>:
.globl vector244
vector244:
  pushl $0
80107939:	6a 00                	push   $0x0
  pushl $244
8010793b:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107940:	e9 81 ee ff ff       	jmp    801067c6 <alltraps>

80107945 <vector245>:
.globl vector245
vector245:
  pushl $0
80107945:	6a 00                	push   $0x0
  pushl $245
80107947:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010794c:	e9 75 ee ff ff       	jmp    801067c6 <alltraps>

80107951 <vector246>:
.globl vector246
vector246:
  pushl $0
80107951:	6a 00                	push   $0x0
  pushl $246
80107953:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107958:	e9 69 ee ff ff       	jmp    801067c6 <alltraps>

8010795d <vector247>:
.globl vector247
vector247:
  pushl $0
8010795d:	6a 00                	push   $0x0
  pushl $247
8010795f:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107964:	e9 5d ee ff ff       	jmp    801067c6 <alltraps>

80107969 <vector248>:
.globl vector248
vector248:
  pushl $0
80107969:	6a 00                	push   $0x0
  pushl $248
8010796b:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107970:	e9 51 ee ff ff       	jmp    801067c6 <alltraps>

80107975 <vector249>:
.globl vector249
vector249:
  pushl $0
80107975:	6a 00                	push   $0x0
  pushl $249
80107977:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010797c:	e9 45 ee ff ff       	jmp    801067c6 <alltraps>

80107981 <vector250>:
.globl vector250
vector250:
  pushl $0
80107981:	6a 00                	push   $0x0
  pushl $250
80107983:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107988:	e9 39 ee ff ff       	jmp    801067c6 <alltraps>

8010798d <vector251>:
.globl vector251
vector251:
  pushl $0
8010798d:	6a 00                	push   $0x0
  pushl $251
8010798f:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107994:	e9 2d ee ff ff       	jmp    801067c6 <alltraps>

80107999 <vector252>:
.globl vector252
vector252:
  pushl $0
80107999:	6a 00                	push   $0x0
  pushl $252
8010799b:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801079a0:	e9 21 ee ff ff       	jmp    801067c6 <alltraps>

801079a5 <vector253>:
.globl vector253
vector253:
  pushl $0
801079a5:	6a 00                	push   $0x0
  pushl $253
801079a7:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801079ac:	e9 15 ee ff ff       	jmp    801067c6 <alltraps>

801079b1 <vector254>:
.globl vector254
vector254:
  pushl $0
801079b1:	6a 00                	push   $0x0
  pushl $254
801079b3:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801079b8:	e9 09 ee ff ff       	jmp    801067c6 <alltraps>

801079bd <vector255>:
.globl vector255
vector255:
  pushl $0
801079bd:	6a 00                	push   $0x0
  pushl $255
801079bf:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801079c4:	e9 fd ed ff ff       	jmp    801067c6 <alltraps>

801079c9 <lgdt>:
{
801079c9:	55                   	push   %ebp
801079ca:	89 e5                	mov    %esp,%ebp
801079cc:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
801079cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801079d2:	83 e8 01             	sub    $0x1,%eax
801079d5:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801079d9:	8b 45 08             	mov    0x8(%ebp),%eax
801079dc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801079e0:	8b 45 08             	mov    0x8(%ebp),%eax
801079e3:	c1 e8 10             	shr    $0x10,%eax
801079e6:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
801079ea:	8d 45 fa             	lea    -0x6(%ebp),%eax
801079ed:	0f 01 10             	lgdtl  (%eax)
}
801079f0:	90                   	nop
801079f1:	c9                   	leave  
801079f2:	c3                   	ret    

801079f3 <ltr>:
{
801079f3:	55                   	push   %ebp
801079f4:	89 e5                	mov    %esp,%ebp
801079f6:	83 ec 04             	sub    $0x4,%esp
801079f9:	8b 45 08             	mov    0x8(%ebp),%eax
801079fc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107a00:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107a04:	0f 00 d8             	ltr    %ax
}
80107a07:	90                   	nop
80107a08:	c9                   	leave  
80107a09:	c3                   	ret    

80107a0a <loadgs>:
{
80107a0a:	55                   	push   %ebp
80107a0b:	89 e5                	mov    %esp,%ebp
80107a0d:	83 ec 04             	sub    $0x4,%esp
80107a10:	8b 45 08             	mov    0x8(%ebp),%eax
80107a13:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107a17:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107a1b:	8e e8                	mov    %eax,%gs
}
80107a1d:	90                   	nop
80107a1e:	c9                   	leave  
80107a1f:	c3                   	ret    

80107a20 <lcr3>:
{
80107a20:	55                   	push   %ebp
80107a21:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107a23:	8b 45 08             	mov    0x8(%ebp),%eax
80107a26:	0f 22 d8             	mov    %eax,%cr3
}
80107a29:	90                   	nop
80107a2a:	5d                   	pop    %ebp
80107a2b:	c3                   	ret    

80107a2c <v2p>:
static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107a2c:	55                   	push   %ebp
80107a2d:	89 e5                	mov    %esp,%ebp
80107a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80107a32:	05 00 00 00 80       	add    $0x80000000,%eax
80107a37:	5d                   	pop    %ebp
80107a38:	c3                   	ret    

80107a39 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107a39:	55                   	push   %ebp
80107a3a:	89 e5                	mov    %esp,%ebp
80107a3c:	8b 45 08             	mov    0x8(%ebp),%eax
80107a3f:	05 00 00 00 80       	add    $0x80000000,%eax
80107a44:	5d                   	pop    %ebp
80107a45:	c3                   	ret    

80107a46 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107a46:	55                   	push   %ebp
80107a47:	89 e5                	mov    %esp,%ebp
80107a49:	53                   	push   %ebx
80107a4a:	83 ec 14             	sub    $0x14,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107a4d:	e8 ab b5 ff ff       	call   80102ffd <cpunum>
80107a52:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107a58:	05 60 13 11 80       	add    $0x80111360,%eax
80107a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a63:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a6c:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a75:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a7c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a80:	83 e2 f0             	and    $0xfffffff0,%edx
80107a83:	83 ca 0a             	or     $0xa,%edx
80107a86:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a8c:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a90:	83 ca 10             	or     $0x10,%edx
80107a93:	88 50 7d             	mov    %dl,0x7d(%eax)
80107a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107a99:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107a9d:	83 e2 9f             	and    $0xffffff9f,%edx
80107aa0:	88 50 7d             	mov    %dl,0x7d(%eax)
80107aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107aa6:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107aaa:	83 ca 80             	or     $0xffffff80,%edx
80107aad:	88 50 7d             	mov    %dl,0x7d(%eax)
80107ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ab3:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ab7:	83 ca 0f             	or     $0xf,%edx
80107aba:	88 50 7e             	mov    %dl,0x7e(%eax)
80107abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ac0:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ac4:	83 e2 ef             	and    $0xffffffef,%edx
80107ac7:	88 50 7e             	mov    %dl,0x7e(%eax)
80107aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107acd:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ad1:	83 e2 df             	and    $0xffffffdf,%edx
80107ad4:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ada:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107ade:	83 ca 40             	or     $0x40,%edx
80107ae1:	88 50 7e             	mov    %dl,0x7e(%eax)
80107ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ae7:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107aeb:	83 ca 80             	or     $0xffffff80,%edx
80107aee:	88 50 7e             	mov    %dl,0x7e(%eax)
80107af1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107af4:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107afb:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107b02:	ff ff 
80107b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b07:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80107b0e:	00 00 
80107b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b13:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80107b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b1d:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b24:	83 e2 f0             	and    $0xfffffff0,%edx
80107b27:	83 ca 02             	or     $0x2,%edx
80107b2a:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b33:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b3a:	83 ca 10             	or     $0x10,%edx
80107b3d:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b46:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b4d:	83 e2 9f             	and    $0xffffff9f,%edx
80107b50:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b59:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80107b60:	83 ca 80             	or     $0xffffff80,%edx
80107b63:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80107b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b6c:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b73:	83 ca 0f             	or     $0xf,%edx
80107b76:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b7f:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b86:	83 e2 ef             	and    $0xffffffef,%edx
80107b89:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107b92:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107b99:	83 e2 df             	and    $0xffffffdf,%edx
80107b9c:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107ba2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ba5:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107bac:	83 ca 40             	or     $0x40,%edx
80107baf:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bb8:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80107bbf:	83 ca 80             	or     $0xffffff80,%edx
80107bc2:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80107bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bcb:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80107bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bd5:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
80107bdc:	ff ff 
80107bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107be1:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
80107be8:	00 00 
80107bea:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bed:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
80107bf4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107bf7:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107bfe:	83 e2 f0             	and    $0xfffffff0,%edx
80107c01:	83 ca 0a             	or     $0xa,%edx
80107c04:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c0d:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c14:	83 ca 10             	or     $0x10,%edx
80107c17:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c20:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c27:	83 ca 60             	or     $0x60,%edx
80107c2a:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c33:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80107c3a:	83 ca 80             	or     $0xffffff80,%edx
80107c3d:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80107c43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c46:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c4d:	83 ca 0f             	or     $0xf,%edx
80107c50:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c59:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c60:	83 e2 ef             	and    $0xffffffef,%edx
80107c63:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c6c:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c73:	83 e2 df             	and    $0xffffffdf,%edx
80107c76:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c7f:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c86:	83 ca 40             	or     $0x40,%edx
80107c89:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107c92:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80107c99:	83 ca 80             	or     $0xffffff80,%edx
80107c9c:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80107ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ca5:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80107cac:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107caf:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
80107cb6:	ff ff 
80107cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cbb:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
80107cc2:	00 00 
80107cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cc7:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
80107cce:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cd1:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cd8:	83 e2 f0             	and    $0xfffffff0,%edx
80107cdb:	83 ca 02             	or     $0x2,%edx
80107cde:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107ce4:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ce7:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107cee:	83 ca 10             	or     $0x10,%edx
80107cf1:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107cf7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107cfa:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107d01:	83 ca 60             	or     $0x60,%edx
80107d04:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d0d:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
80107d14:	83 ca 80             	or     $0xffffff80,%edx
80107d17:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80107d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d20:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d27:	83 ca 0f             	or     $0xf,%edx
80107d2a:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d33:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d3a:	83 e2 ef             	and    $0xffffffef,%edx
80107d3d:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d46:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d4d:	83 e2 df             	and    $0xffffffdf,%edx
80107d50:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d59:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d60:	83 ca 40             	or     $0x40,%edx
80107d63:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d6c:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80107d73:	83 ca 80             	or     $0xffffff80,%edx
80107d76:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80107d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d7f:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80107d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d89:	05 b4 00 00 00       	add    $0xb4,%eax
80107d8e:	89 c3                	mov    %eax,%ebx
80107d90:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107d93:	05 b4 00 00 00       	add    $0xb4,%eax
80107d98:	c1 e8 10             	shr    $0x10,%eax
80107d9b:	89 c2                	mov    %eax,%edx
80107d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107da0:	05 b4 00 00 00       	add    $0xb4,%eax
80107da5:	c1 e8 18             	shr    $0x18,%eax
80107da8:	89 c1                	mov    %eax,%ecx
80107daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dad:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
80107db4:	00 00 
80107db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107db9:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
80107dc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dc3:	88 90 8c 00 00 00    	mov    %dl,0x8c(%eax)
80107dc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107dcc:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107dd3:	83 e2 f0             	and    $0xfffffff0,%edx
80107dd6:	83 ca 02             	or     $0x2,%edx
80107dd9:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107de2:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107de9:	83 ca 10             	or     $0x10,%edx
80107dec:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107df2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107df5:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107dfc:	83 e2 9f             	and    $0xffffff9f,%edx
80107dff:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e08:	0f b6 90 8d 00 00 00 	movzbl 0x8d(%eax),%edx
80107e0f:	83 ca 80             	or     $0xffffff80,%edx
80107e12:	88 90 8d 00 00 00    	mov    %dl,0x8d(%eax)
80107e18:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e1b:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e22:	83 e2 f0             	and    $0xfffffff0,%edx
80107e25:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e2e:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e35:	83 e2 ef             	and    $0xffffffef,%edx
80107e38:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e41:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e48:	83 e2 df             	and    $0xffffffdf,%edx
80107e4b:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e54:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e5b:	83 ca 40             	or     $0x40,%edx
80107e5e:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e67:	0f b6 90 8e 00 00 00 	movzbl 0x8e(%eax),%edx
80107e6e:	83 ca 80             	or     $0xffffff80,%edx
80107e71:	88 90 8e 00 00 00    	mov    %dl,0x8e(%eax)
80107e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e7a:	88 88 8f 00 00 00    	mov    %cl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
80107e80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107e83:	83 c0 70             	add    $0x70,%eax
80107e86:	83 ec 08             	sub    $0x8,%esp
80107e89:	6a 38                	push   $0x38
80107e8b:	50                   	push   %eax
80107e8c:	e8 38 fb ff ff       	call   801079c9 <lgdt>
80107e91:	83 c4 10             	add    $0x10,%esp
  loadgs(SEG_KCPU << 3);
80107e94:	83 ec 0c             	sub    $0xc,%esp
80107e97:	6a 18                	push   $0x18
80107e99:	e8 6c fb ff ff       	call   80107a0a <loadgs>
80107e9e:	83 c4 10             	add    $0x10,%esp
  
  // Initialize cpu-local storage.
  cpu = c;
80107ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ea4:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
80107eaa:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80107eb1:	00 00 00 00 
}
80107eb5:	90                   	nop
80107eb6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80107eb9:	c9                   	leave  
80107eba:	c3                   	ret    

80107ebb <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80107ebb:	55                   	push   %ebp
80107ebc:	89 e5                	mov    %esp,%ebp
80107ebe:	83 ec 18             	sub    $0x18,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80107ec1:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ec4:	c1 e8 16             	shr    $0x16,%eax
80107ec7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107ece:	8b 45 08             	mov    0x8(%ebp),%eax
80107ed1:	01 d0                	add    %edx,%eax
80107ed3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
80107ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ed9:	8b 00                	mov    (%eax),%eax
80107edb:	83 e0 01             	and    $0x1,%eax
80107ede:	85 c0                	test   %eax,%eax
80107ee0:	74 18                	je     80107efa <walkpgdir+0x3f>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
80107ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107ee5:	8b 00                	mov    (%eax),%eax
80107ee7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107eec:	50                   	push   %eax
80107eed:	e8 47 fb ff ff       	call   80107a39 <p2v>
80107ef2:	83 c4 04             	add    $0x4,%esp
80107ef5:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107ef8:	eb 48                	jmp    80107f42 <walkpgdir+0x87>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80107efa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80107efe:	74 0e                	je     80107f0e <walkpgdir+0x53>
80107f00:	e8 81 ad ff ff       	call   80102c86 <kalloc>
80107f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
80107f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80107f0c:	75 07                	jne    80107f15 <walkpgdir+0x5a>
      return 0;
80107f0e:	b8 00 00 00 00       	mov    $0x0,%eax
80107f13:	eb 44                	jmp    80107f59 <walkpgdir+0x9e>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80107f15:	83 ec 04             	sub    $0x4,%esp
80107f18:	68 00 10 00 00       	push   $0x1000
80107f1d:	6a 00                	push   $0x0
80107f1f:	ff 75 f4             	push   -0xc(%ebp)
80107f22:	e8 06 d4 ff ff       	call   8010532d <memset>
80107f27:	83 c4 10             	add    $0x10,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
80107f2a:	83 ec 0c             	sub    $0xc,%esp
80107f2d:	ff 75 f4             	push   -0xc(%ebp)
80107f30:	e8 f7 fa ff ff       	call   80107a2c <v2p>
80107f35:	83 c4 10             	add    $0x10,%esp
80107f38:	83 c8 07             	or     $0x7,%eax
80107f3b:	89 c2                	mov    %eax,%edx
80107f3d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80107f40:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80107f42:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f45:	c1 e8 0c             	shr    $0xc,%eax
80107f48:	25 ff 03 00 00       	and    $0x3ff,%eax
80107f4d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80107f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f57:	01 d0                	add    %edx,%eax
}
80107f59:	c9                   	leave  
80107f5a:	c3                   	ret    

80107f5b <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80107f5b:	55                   	push   %ebp
80107f5c:	89 e5                	mov    %esp,%ebp
80107f5e:	83 ec 18             	sub    $0x18,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
80107f61:	8b 45 0c             	mov    0xc(%ebp),%eax
80107f64:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f69:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80107f6c:	8b 55 0c             	mov    0xc(%ebp),%edx
80107f6f:	8b 45 10             	mov    0x10(%ebp),%eax
80107f72:	01 d0                	add    %edx,%eax
80107f74:	83 e8 01             	sub    $0x1,%eax
80107f77:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80107f7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107f7f:	83 ec 04             	sub    $0x4,%esp
80107f82:	6a 01                	push   $0x1
80107f84:	ff 75 f4             	push   -0xc(%ebp)
80107f87:	ff 75 08             	push   0x8(%ebp)
80107f8a:	e8 2c ff ff ff       	call   80107ebb <walkpgdir>
80107f8f:	83 c4 10             	add    $0x10,%esp
80107f92:	89 45 ec             	mov    %eax,-0x14(%ebp)
80107f95:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80107f99:	75 07                	jne    80107fa2 <mappages+0x47>
      return -1;
80107f9b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107fa0:	eb 47                	jmp    80107fe9 <mappages+0x8e>
    if(*pte & PTE_P)
80107fa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fa5:	8b 00                	mov    (%eax),%eax
80107fa7:	83 e0 01             	and    $0x1,%eax
80107faa:	85 c0                	test   %eax,%eax
80107fac:	74 0d                	je     80107fbb <mappages+0x60>
      panic("remap");
80107fae:	83 ec 0c             	sub    $0xc,%esp
80107fb1:	68 e0 8e 10 80       	push   $0x80108ee0
80107fb6:	e8 c0 85 ff ff       	call   8010057b <panic>
    *pte = pa | perm | PTE_P;
80107fbb:	8b 45 18             	mov    0x18(%ebp),%eax
80107fbe:	0b 45 14             	or     0x14(%ebp),%eax
80107fc1:	83 c8 01             	or     $0x1,%eax
80107fc4:	89 c2                	mov    %eax,%edx
80107fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80107fc9:	89 10                	mov    %edx,(%eax)
    if(a == last)
80107fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80107fd1:	74 10                	je     80107fe3 <mappages+0x88>
      break;
    a += PGSIZE;
80107fd3:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
80107fda:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80107fe1:	eb 9c                	jmp    80107f7f <mappages+0x24>
      break;
80107fe3:	90                   	nop
  }
  return 0;
80107fe4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80107fe9:	c9                   	leave  
80107fea:	c3                   	ret    

80107feb <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80107feb:	55                   	push   %ebp
80107fec:	89 e5                	mov    %esp,%ebp
80107fee:	53                   	push   %ebx
80107fef:	83 ec 14             	sub    $0x14,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80107ff2:	e8 8f ac ff ff       	call   80102c86 <kalloc>
80107ff7:	89 45 f0             	mov    %eax,-0x10(%ebp)
80107ffa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80107ffe:	75 0a                	jne    8010800a <setupkvm+0x1f>
    return 0;
80108000:	b8 00 00 00 00       	mov    $0x0,%eax
80108005:	e9 8e 00 00 00       	jmp    80108098 <setupkvm+0xad>
  memset(pgdir, 0, PGSIZE);
8010800a:	83 ec 04             	sub    $0x4,%esp
8010800d:	68 00 10 00 00       	push   $0x1000
80108012:	6a 00                	push   $0x0
80108014:	ff 75 f0             	push   -0x10(%ebp)
80108017:	e8 11 d3 ff ff       	call   8010532d <memset>
8010801c:	83 c4 10             	add    $0x10,%esp
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010801f:	83 ec 0c             	sub    $0xc,%esp
80108022:	68 00 00 00 0e       	push   $0xe000000
80108027:	e8 0d fa ff ff       	call   80107a39 <p2v>
8010802c:	83 c4 10             	add    $0x10,%esp
8010802f:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
80108034:	76 0d                	jbe    80108043 <setupkvm+0x58>
    panic("PHYSTOP too high");
80108036:	83 ec 0c             	sub    $0xc,%esp
80108039:	68 e6 8e 10 80       	push   $0x80108ee6
8010803e:	e8 38 85 ff ff       	call   8010057b <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108043:	c7 45 f4 c0 b4 10 80 	movl   $0x8010b4c0,-0xc(%ebp)
8010804a:	eb 40                	jmp    8010808c <setupkvm+0xa1>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
8010804c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010804f:	8b 48 0c             	mov    0xc(%eax),%ecx
                (uint)k->phys_start, k->perm) < 0)
80108052:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108055:	8b 50 04             	mov    0x4(%eax),%edx
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108058:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010805b:	8b 58 08             	mov    0x8(%eax),%ebx
8010805e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108061:	8b 40 04             	mov    0x4(%eax),%eax
80108064:	29 c3                	sub    %eax,%ebx
80108066:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108069:	8b 00                	mov    (%eax),%eax
8010806b:	83 ec 0c             	sub    $0xc,%esp
8010806e:	51                   	push   %ecx
8010806f:	52                   	push   %edx
80108070:	53                   	push   %ebx
80108071:	50                   	push   %eax
80108072:	ff 75 f0             	push   -0x10(%ebp)
80108075:	e8 e1 fe ff ff       	call   80107f5b <mappages>
8010807a:	83 c4 20             	add    $0x20,%esp
8010807d:	85 c0                	test   %eax,%eax
8010807f:	79 07                	jns    80108088 <setupkvm+0x9d>
      return 0;
80108081:	b8 00 00 00 00       	mov    $0x0,%eax
80108086:	eb 10                	jmp    80108098 <setupkvm+0xad>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108088:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010808c:	81 7d f4 00 b5 10 80 	cmpl   $0x8010b500,-0xc(%ebp)
80108093:	72 b7                	jb     8010804c <setupkvm+0x61>
  return pgdir;
80108095:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80108098:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010809b:	c9                   	leave  
8010809c:	c3                   	ret    

8010809d <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
8010809d:	55                   	push   %ebp
8010809e:	89 e5                	mov    %esp,%ebp
801080a0:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801080a3:	e8 43 ff ff ff       	call   80107feb <setupkvm>
801080a8:	a3 00 41 11 80       	mov    %eax,0x80114100
  switchkvm();
801080ad:	e8 03 00 00 00       	call   801080b5 <switchkvm>
}
801080b2:	90                   	nop
801080b3:	c9                   	leave  
801080b4:	c3                   	ret    

801080b5 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801080b5:	55                   	push   %ebp
801080b6:	89 e5                	mov    %esp,%ebp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801080b8:	a1 00 41 11 80       	mov    0x80114100,%eax
801080bd:	50                   	push   %eax
801080be:	e8 69 f9 ff ff       	call   80107a2c <v2p>
801080c3:	83 c4 04             	add    $0x4,%esp
801080c6:	50                   	push   %eax
801080c7:	e8 54 f9 ff ff       	call   80107a20 <lcr3>
801080cc:	83 c4 04             	add    $0x4,%esp
}
801080cf:	90                   	nop
801080d0:	c9                   	leave  
801080d1:	c3                   	ret    

801080d2 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801080d2:	55                   	push   %ebp
801080d3:	89 e5                	mov    %esp,%ebp
801080d5:	56                   	push   %esi
801080d6:	53                   	push   %ebx
  pushcli();
801080d7:	e8 4c d1 ff ff       	call   80105228 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801080dc:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801080e2:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080e9:	83 c2 08             	add    $0x8,%edx
801080ec:	89 d6                	mov    %edx,%esi
801080ee:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801080f5:	83 c2 08             	add    $0x8,%edx
801080f8:	c1 ea 10             	shr    $0x10,%edx
801080fb:	89 d3                	mov    %edx,%ebx
801080fd:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108104:	83 c2 08             	add    $0x8,%edx
80108107:	c1 ea 18             	shr    $0x18,%edx
8010810a:	89 d1                	mov    %edx,%ecx
8010810c:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108113:	67 00 
80108115:	66 89 b0 a2 00 00 00 	mov    %si,0xa2(%eax)
8010811c:	88 98 a4 00 00 00    	mov    %bl,0xa4(%eax)
80108122:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
80108129:	83 e2 f0             	and    $0xfffffff0,%edx
8010812c:	83 ca 09             	or     $0x9,%edx
8010812f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108135:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010813c:	83 ca 10             	or     $0x10,%edx
8010813f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108145:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010814c:	83 e2 9f             	and    $0xffffff9f,%edx
8010814f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108155:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
8010815c:	83 ca 80             	or     $0xffffff80,%edx
8010815f:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
80108165:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010816c:	83 e2 f0             	and    $0xfffffff0,%edx
8010816f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108175:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010817c:	83 e2 ef             	and    $0xffffffef,%edx
8010817f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108185:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010818c:	83 e2 df             	and    $0xffffffdf,%edx
8010818f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
80108195:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
8010819c:	83 ca 40             	or     $0x40,%edx
8010819f:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081a5:	0f b6 90 a6 00 00 00 	movzbl 0xa6(%eax),%edx
801081ac:	83 e2 7f             	and    $0x7f,%edx
801081af:	88 90 a6 00 00 00    	mov    %dl,0xa6(%eax)
801081b5:	88 88 a7 00 00 00    	mov    %cl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801081bb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081c1:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801081c8:	83 e2 ef             	and    $0xffffffef,%edx
801081cb:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801081d1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081d7:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801081dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801081e3:	8b 40 08             	mov    0x8(%eax),%eax
801081e6:	89 c2                	mov    %eax,%edx
801081e8:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801081ee:	81 c2 00 10 00 00    	add    $0x1000,%edx
801081f4:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
801081f7:	83 ec 0c             	sub    $0xc,%esp
801081fa:	6a 30                	push   $0x30
801081fc:	e8 f2 f7 ff ff       	call   801079f3 <ltr>
80108201:	83 c4 10             	add    $0x10,%esp
  if(p->pgdir == 0)
80108204:	8b 45 08             	mov    0x8(%ebp),%eax
80108207:	8b 40 04             	mov    0x4(%eax),%eax
8010820a:	85 c0                	test   %eax,%eax
8010820c:	75 0d                	jne    8010821b <switchuvm+0x149>
    panic("switchuvm: no pgdir");
8010820e:	83 ec 0c             	sub    $0xc,%esp
80108211:	68 f7 8e 10 80       	push   $0x80108ef7
80108216:	e8 60 83 ff ff       	call   8010057b <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
8010821b:	8b 45 08             	mov    0x8(%ebp),%eax
8010821e:	8b 40 04             	mov    0x4(%eax),%eax
80108221:	83 ec 0c             	sub    $0xc,%esp
80108224:	50                   	push   %eax
80108225:	e8 02 f8 ff ff       	call   80107a2c <v2p>
8010822a:	83 c4 10             	add    $0x10,%esp
8010822d:	83 ec 0c             	sub    $0xc,%esp
80108230:	50                   	push   %eax
80108231:	e8 ea f7 ff ff       	call   80107a20 <lcr3>
80108236:	83 c4 10             	add    $0x10,%esp
  popcli();
80108239:	e8 2e d0 ff ff       	call   8010526c <popcli>
}
8010823e:	90                   	nop
8010823f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80108242:	5b                   	pop    %ebx
80108243:	5e                   	pop    %esi
80108244:	5d                   	pop    %ebp
80108245:	c3                   	ret    

80108246 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108246:	55                   	push   %ebp
80108247:	89 e5                	mov    %esp,%ebp
80108249:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010824c:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108253:	76 0d                	jbe    80108262 <inituvm+0x1c>
    panic("inituvm: more than a page");
80108255:	83 ec 0c             	sub    $0xc,%esp
80108258:	68 0b 8f 10 80       	push   $0x80108f0b
8010825d:	e8 19 83 ff ff       	call   8010057b <panic>
  mem = kalloc();
80108262:	e8 1f aa ff ff       	call   80102c86 <kalloc>
80108267:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010826a:	83 ec 04             	sub    $0x4,%esp
8010826d:	68 00 10 00 00       	push   $0x1000
80108272:	6a 00                	push   $0x0
80108274:	ff 75 f4             	push   -0xc(%ebp)
80108277:	e8 b1 d0 ff ff       	call   8010532d <memset>
8010827c:	83 c4 10             	add    $0x10,%esp
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010827f:	83 ec 0c             	sub    $0xc,%esp
80108282:	ff 75 f4             	push   -0xc(%ebp)
80108285:	e8 a2 f7 ff ff       	call   80107a2c <v2p>
8010828a:	83 c4 10             	add    $0x10,%esp
8010828d:	83 ec 0c             	sub    $0xc,%esp
80108290:	6a 06                	push   $0x6
80108292:	50                   	push   %eax
80108293:	68 00 10 00 00       	push   $0x1000
80108298:	6a 00                	push   $0x0
8010829a:	ff 75 08             	push   0x8(%ebp)
8010829d:	e8 b9 fc ff ff       	call   80107f5b <mappages>
801082a2:	83 c4 20             	add    $0x20,%esp
  memmove(mem, init, sz);
801082a5:	83 ec 04             	sub    $0x4,%esp
801082a8:	ff 75 10             	push   0x10(%ebp)
801082ab:	ff 75 0c             	push   0xc(%ebp)
801082ae:	ff 75 f4             	push   -0xc(%ebp)
801082b1:	e8 36 d1 ff ff       	call   801053ec <memmove>
801082b6:	83 c4 10             	add    $0x10,%esp
}
801082b9:	90                   	nop
801082ba:	c9                   	leave  
801082bb:	c3                   	ret    

801082bc <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801082bc:	55                   	push   %ebp
801082bd:	89 e5                	mov    %esp,%ebp
801082bf:	53                   	push   %ebx
801082c0:	83 ec 14             	sub    $0x14,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801082c3:	8b 45 0c             	mov    0xc(%ebp),%eax
801082c6:	25 ff 0f 00 00       	and    $0xfff,%eax
801082cb:	85 c0                	test   %eax,%eax
801082cd:	74 0d                	je     801082dc <loaduvm+0x20>
    panic("loaduvm: addr must be page aligned");
801082cf:	83 ec 0c             	sub    $0xc,%esp
801082d2:	68 28 8f 10 80       	push   $0x80108f28
801082d7:	e8 9f 82 ff ff       	call   8010057b <panic>
  for(i = 0; i < sz; i += PGSIZE){
801082dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801082e3:	e9 95 00 00 00       	jmp    8010837d <loaduvm+0xc1>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801082e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801082eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082ee:	01 d0                	add    %edx,%eax
801082f0:	83 ec 04             	sub    $0x4,%esp
801082f3:	6a 00                	push   $0x0
801082f5:	50                   	push   %eax
801082f6:	ff 75 08             	push   0x8(%ebp)
801082f9:	e8 bd fb ff ff       	call   80107ebb <walkpgdir>
801082fe:	83 c4 10             	add    $0x10,%esp
80108301:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108304:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108308:	75 0d                	jne    80108317 <loaduvm+0x5b>
      panic("loaduvm: address should exist");
8010830a:	83 ec 0c             	sub    $0xc,%esp
8010830d:	68 4b 8f 10 80       	push   $0x80108f4b
80108312:	e8 64 82 ff ff       	call   8010057b <panic>
    pa = PTE_ADDR(*pte);
80108317:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010831a:	8b 00                	mov    (%eax),%eax
8010831c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108321:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108324:	8b 45 18             	mov    0x18(%ebp),%eax
80108327:	2b 45 f4             	sub    -0xc(%ebp),%eax
8010832a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010832f:	77 0b                	ja     8010833c <loaduvm+0x80>
      n = sz - i;
80108331:	8b 45 18             	mov    0x18(%ebp),%eax
80108334:	2b 45 f4             	sub    -0xc(%ebp),%eax
80108337:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010833a:	eb 07                	jmp    80108343 <loaduvm+0x87>
    else
      n = PGSIZE;
8010833c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108343:	8b 55 14             	mov    0x14(%ebp),%edx
80108346:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108349:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
8010834c:	83 ec 0c             	sub    $0xc,%esp
8010834f:	ff 75 e8             	push   -0x18(%ebp)
80108352:	e8 e2 f6 ff ff       	call   80107a39 <p2v>
80108357:	83 c4 10             	add    $0x10,%esp
8010835a:	ff 75 f0             	push   -0x10(%ebp)
8010835d:	53                   	push   %ebx
8010835e:	50                   	push   %eax
8010835f:	ff 75 10             	push   0x10(%ebp)
80108362:	e8 89 9b ff ff       	call   80101ef0 <readi>
80108367:	83 c4 10             	add    $0x10,%esp
8010836a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
8010836d:	74 07                	je     80108376 <loaduvm+0xba>
      return -1;
8010836f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108374:	eb 18                	jmp    8010838e <loaduvm+0xd2>
  for(i = 0; i < sz; i += PGSIZE){
80108376:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
8010837d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108380:	3b 45 18             	cmp    0x18(%ebp),%eax
80108383:	0f 82 5f ff ff ff    	jb     801082e8 <loaduvm+0x2c>
  }
  return 0;
80108389:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010838e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108391:	c9                   	leave  
80108392:	c3                   	ret    

80108393 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108393:	55                   	push   %ebp
80108394:	89 e5                	mov    %esp,%ebp
80108396:	83 ec 18             	sub    $0x18,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80108399:	8b 45 10             	mov    0x10(%ebp),%eax
8010839c:	85 c0                	test   %eax,%eax
8010839e:	79 0a                	jns    801083aa <allocuvm+0x17>
    return 0;
801083a0:	b8 00 00 00 00       	mov    $0x0,%eax
801083a5:	e9 ae 00 00 00       	jmp    80108458 <allocuvm+0xc5>
  if(newsz < oldsz)
801083aa:	8b 45 10             	mov    0x10(%ebp),%eax
801083ad:	3b 45 0c             	cmp    0xc(%ebp),%eax
801083b0:	73 08                	jae    801083ba <allocuvm+0x27>
    return oldsz;
801083b2:	8b 45 0c             	mov    0xc(%ebp),%eax
801083b5:	e9 9e 00 00 00       	jmp    80108458 <allocuvm+0xc5>

  a = PGROUNDUP(oldsz);
801083ba:	8b 45 0c             	mov    0xc(%ebp),%eax
801083bd:	05 ff 0f 00 00       	add    $0xfff,%eax
801083c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801083ca:	eb 7d                	jmp    80108449 <allocuvm+0xb6>
    mem = kalloc();
801083cc:	e8 b5 a8 ff ff       	call   80102c86 <kalloc>
801083d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
801083d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801083d8:	75 2b                	jne    80108405 <allocuvm+0x72>
      cprintf("allocuvm out of memory\n");
801083da:	83 ec 0c             	sub    $0xc,%esp
801083dd:	68 69 8f 10 80       	push   $0x80108f69
801083e2:	e8 df 7f ff ff       	call   801003c6 <cprintf>
801083e7:	83 c4 10             	add    $0x10,%esp
      deallocuvm(pgdir, newsz, oldsz);
801083ea:	83 ec 04             	sub    $0x4,%esp
801083ed:	ff 75 0c             	push   0xc(%ebp)
801083f0:	ff 75 10             	push   0x10(%ebp)
801083f3:	ff 75 08             	push   0x8(%ebp)
801083f6:	e8 5f 00 00 00       	call   8010845a <deallocuvm>
801083fb:	83 c4 10             	add    $0x10,%esp
      return 0;
801083fe:	b8 00 00 00 00       	mov    $0x0,%eax
80108403:	eb 53                	jmp    80108458 <allocuvm+0xc5>
    }
    memset(mem, 0, PGSIZE);
80108405:	83 ec 04             	sub    $0x4,%esp
80108408:	68 00 10 00 00       	push   $0x1000
8010840d:	6a 00                	push   $0x0
8010840f:	ff 75 f0             	push   -0x10(%ebp)
80108412:	e8 16 cf ff ff       	call   8010532d <memset>
80108417:	83 c4 10             	add    $0x10,%esp
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
8010841a:	83 ec 0c             	sub    $0xc,%esp
8010841d:	ff 75 f0             	push   -0x10(%ebp)
80108420:	e8 07 f6 ff ff       	call   80107a2c <v2p>
80108425:	83 c4 10             	add    $0x10,%esp
80108428:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010842b:	83 ec 0c             	sub    $0xc,%esp
8010842e:	6a 06                	push   $0x6
80108430:	50                   	push   %eax
80108431:	68 00 10 00 00       	push   $0x1000
80108436:	52                   	push   %edx
80108437:	ff 75 08             	push   0x8(%ebp)
8010843a:	e8 1c fb ff ff       	call   80107f5b <mappages>
8010843f:	83 c4 20             	add    $0x20,%esp
  for(; a < newsz; a += PGSIZE){
80108442:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108449:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010844c:	3b 45 10             	cmp    0x10(%ebp),%eax
8010844f:	0f 82 77 ff ff ff    	jb     801083cc <allocuvm+0x39>
  }
  return newsz;
80108455:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108458:	c9                   	leave  
80108459:	c3                   	ret    

8010845a <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
8010845a:	55                   	push   %ebp
8010845b:	89 e5                	mov    %esp,%ebp
8010845d:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80108460:	8b 45 10             	mov    0x10(%ebp),%eax
80108463:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108466:	72 08                	jb     80108470 <deallocuvm+0x16>
    return oldsz;
80108468:	8b 45 0c             	mov    0xc(%ebp),%eax
8010846b:	e9 a5 00 00 00       	jmp    80108515 <deallocuvm+0xbb>

  a = PGROUNDUP(newsz);
80108470:	8b 45 10             	mov    0x10(%ebp),%eax
80108473:	05 ff 0f 00 00       	add    $0xfff,%eax
80108478:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010847d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80108480:	e9 81 00 00 00       	jmp    80108506 <deallocuvm+0xac>
    pte = walkpgdir(pgdir, (char*)a, 0);
80108485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108488:	83 ec 04             	sub    $0x4,%esp
8010848b:	6a 00                	push   $0x0
8010848d:	50                   	push   %eax
8010848e:	ff 75 08             	push   0x8(%ebp)
80108491:	e8 25 fa ff ff       	call   80107ebb <walkpgdir>
80108496:	83 c4 10             	add    $0x10,%esp
80108499:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
8010849c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801084a0:	75 09                	jne    801084ab <deallocuvm+0x51>
      a += (NPTENTRIES - 1) * PGSIZE;
801084a2:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801084a9:	eb 54                	jmp    801084ff <deallocuvm+0xa5>
    else if((*pte & PTE_P) != 0){
801084ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084ae:	8b 00                	mov    (%eax),%eax
801084b0:	83 e0 01             	and    $0x1,%eax
801084b3:	85 c0                	test   %eax,%eax
801084b5:	74 48                	je     801084ff <deallocuvm+0xa5>
      pa = PTE_ADDR(*pte);
801084b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084ba:	8b 00                	mov    (%eax),%eax
801084bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801084c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
801084c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801084c8:	75 0d                	jne    801084d7 <deallocuvm+0x7d>
        panic("kfree");
801084ca:	83 ec 0c             	sub    $0xc,%esp
801084cd:	68 81 8f 10 80       	push   $0x80108f81
801084d2:	e8 a4 80 ff ff       	call   8010057b <panic>
      char *v = p2v(pa);
801084d7:	83 ec 0c             	sub    $0xc,%esp
801084da:	ff 75 ec             	push   -0x14(%ebp)
801084dd:	e8 57 f5 ff ff       	call   80107a39 <p2v>
801084e2:	83 c4 10             	add    $0x10,%esp
801084e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
801084e8:	83 ec 0c             	sub    $0xc,%esp
801084eb:	ff 75 e8             	push   -0x18(%ebp)
801084ee:	e8 e9 a6 ff ff       	call   80102bdc <kfree>
801084f3:	83 c4 10             	add    $0x10,%esp
      *pte = 0;
801084f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801084f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
801084ff:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108506:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108509:	3b 45 0c             	cmp    0xc(%ebp),%eax
8010850c:	0f 82 73 ff ff ff    	jb     80108485 <deallocuvm+0x2b>
    }
  }
  return newsz;
80108512:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108515:	c9                   	leave  
80108516:	c3                   	ret    

80108517 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108517:	55                   	push   %ebp
80108518:	89 e5                	mov    %esp,%ebp
8010851a:	83 ec 18             	sub    $0x18,%esp
  uint i;

  if(pgdir == 0)
8010851d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108521:	75 0d                	jne    80108530 <freevm+0x19>
    panic("freevm: no pgdir");
80108523:	83 ec 0c             	sub    $0xc,%esp
80108526:	68 87 8f 10 80       	push   $0x80108f87
8010852b:	e8 4b 80 ff ff       	call   8010057b <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108530:	83 ec 04             	sub    $0x4,%esp
80108533:	6a 00                	push   $0x0
80108535:	68 00 00 00 80       	push   $0x80000000
8010853a:	ff 75 08             	push   0x8(%ebp)
8010853d:	e8 18 ff ff ff       	call   8010845a <deallocuvm>
80108542:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108545:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010854c:	eb 4f                	jmp    8010859d <freevm+0x86>
    if(pgdir[i] & PTE_P){
8010854e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108551:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108558:	8b 45 08             	mov    0x8(%ebp),%eax
8010855b:	01 d0                	add    %edx,%eax
8010855d:	8b 00                	mov    (%eax),%eax
8010855f:	83 e0 01             	and    $0x1,%eax
80108562:	85 c0                	test   %eax,%eax
80108564:	74 33                	je     80108599 <freevm+0x82>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108566:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108569:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108570:	8b 45 08             	mov    0x8(%ebp),%eax
80108573:	01 d0                	add    %edx,%eax
80108575:	8b 00                	mov    (%eax),%eax
80108577:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010857c:	83 ec 0c             	sub    $0xc,%esp
8010857f:	50                   	push   %eax
80108580:	e8 b4 f4 ff ff       	call   80107a39 <p2v>
80108585:	83 c4 10             	add    $0x10,%esp
80108588:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
8010858b:	83 ec 0c             	sub    $0xc,%esp
8010858e:	ff 75 f0             	push   -0x10(%ebp)
80108591:	e8 46 a6 ff ff       	call   80102bdc <kfree>
80108596:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80108599:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010859d:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
801085a4:	76 a8                	jbe    8010854e <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801085a6:	83 ec 0c             	sub    $0xc,%esp
801085a9:	ff 75 08             	push   0x8(%ebp)
801085ac:	e8 2b a6 ff ff       	call   80102bdc <kfree>
801085b1:	83 c4 10             	add    $0x10,%esp
}
801085b4:	90                   	nop
801085b5:	c9                   	leave  
801085b6:	c3                   	ret    

801085b7 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801085b7:	55                   	push   %ebp
801085b8:	89 e5                	mov    %esp,%ebp
801085ba:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801085bd:	83 ec 04             	sub    $0x4,%esp
801085c0:	6a 00                	push   $0x0
801085c2:	ff 75 0c             	push   0xc(%ebp)
801085c5:	ff 75 08             	push   0x8(%ebp)
801085c8:	e8 ee f8 ff ff       	call   80107ebb <walkpgdir>
801085cd:	83 c4 10             	add    $0x10,%esp
801085d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
801085d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801085d7:	75 0d                	jne    801085e6 <clearpteu+0x2f>
    panic("clearpteu");
801085d9:	83 ec 0c             	sub    $0xc,%esp
801085dc:	68 98 8f 10 80       	push   $0x80108f98
801085e1:	e8 95 7f ff ff       	call   8010057b <panic>
  *pte &= ~PTE_U;
801085e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085e9:	8b 00                	mov    (%eax),%eax
801085eb:	83 e0 fb             	and    $0xfffffffb,%eax
801085ee:	89 c2                	mov    %eax,%edx
801085f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801085f3:	89 10                	mov    %edx,(%eax)
}
801085f5:	90                   	nop
801085f6:	c9                   	leave  
801085f7:	c3                   	ret    

801085f8 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801085f8:	55                   	push   %ebp
801085f9:	89 e5                	mov    %esp,%ebp
801085fb:	53                   	push   %ebx
801085fc:	83 ec 24             	sub    $0x24,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801085ff:	e8 e7 f9 ff ff       	call   80107feb <setupkvm>
80108604:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108607:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010860b:	75 0a                	jne    80108617 <copyuvm+0x1f>
    return 0;
8010860d:	b8 00 00 00 00       	mov    $0x0,%eax
80108612:	e9 f6 00 00 00       	jmp    8010870d <copyuvm+0x115>
  for(i = 0; i < sz; i += PGSIZE){
80108617:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010861e:	e9 c2 00 00 00       	jmp    801086e5 <copyuvm+0xed>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108623:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108626:	83 ec 04             	sub    $0x4,%esp
80108629:	6a 00                	push   $0x0
8010862b:	50                   	push   %eax
8010862c:	ff 75 08             	push   0x8(%ebp)
8010862f:	e8 87 f8 ff ff       	call   80107ebb <walkpgdir>
80108634:	83 c4 10             	add    $0x10,%esp
80108637:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010863a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010863e:	75 0d                	jne    8010864d <copyuvm+0x55>
      panic("copyuvm: pte should exist");
80108640:	83 ec 0c             	sub    $0xc,%esp
80108643:	68 a2 8f 10 80       	push   $0x80108fa2
80108648:	e8 2e 7f ff ff       	call   8010057b <panic>
    if(!(*pte & PTE_P))
8010864d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108650:	8b 00                	mov    (%eax),%eax
80108652:	83 e0 01             	and    $0x1,%eax
80108655:	85 c0                	test   %eax,%eax
80108657:	75 0d                	jne    80108666 <copyuvm+0x6e>
      panic("copyuvm: page not present");
80108659:	83 ec 0c             	sub    $0xc,%esp
8010865c:	68 bc 8f 10 80       	push   $0x80108fbc
80108661:	e8 15 7f ff ff       	call   8010057b <panic>
    pa = PTE_ADDR(*pte);
80108666:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108669:	8b 00                	mov    (%eax),%eax
8010866b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108670:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108673:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108676:	8b 00                	mov    (%eax),%eax
80108678:	25 ff 0f 00 00       	and    $0xfff,%eax
8010867d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108680:	e8 01 a6 ff ff       	call   80102c86 <kalloc>
80108685:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108688:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010868c:	74 68                	je     801086f6 <copyuvm+0xfe>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
8010868e:	83 ec 0c             	sub    $0xc,%esp
80108691:	ff 75 e8             	push   -0x18(%ebp)
80108694:	e8 a0 f3 ff ff       	call   80107a39 <p2v>
80108699:	83 c4 10             	add    $0x10,%esp
8010869c:	83 ec 04             	sub    $0x4,%esp
8010869f:	68 00 10 00 00       	push   $0x1000
801086a4:	50                   	push   %eax
801086a5:	ff 75 e0             	push   -0x20(%ebp)
801086a8:	e8 3f cd ff ff       	call   801053ec <memmove>
801086ad:	83 c4 10             	add    $0x10,%esp
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
801086b0:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801086b3:	83 ec 0c             	sub    $0xc,%esp
801086b6:	ff 75 e0             	push   -0x20(%ebp)
801086b9:	e8 6e f3 ff ff       	call   80107a2c <v2p>
801086be:	83 c4 10             	add    $0x10,%esp
801086c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801086c4:	83 ec 0c             	sub    $0xc,%esp
801086c7:	53                   	push   %ebx
801086c8:	50                   	push   %eax
801086c9:	68 00 10 00 00       	push   $0x1000
801086ce:	52                   	push   %edx
801086cf:	ff 75 f0             	push   -0x10(%ebp)
801086d2:	e8 84 f8 ff ff       	call   80107f5b <mappages>
801086d7:	83 c4 20             	add    $0x20,%esp
801086da:	85 c0                	test   %eax,%eax
801086dc:	78 1b                	js     801086f9 <copyuvm+0x101>
  for(i = 0; i < sz; i += PGSIZE){
801086de:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801086e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801086e8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801086eb:	0f 82 32 ff ff ff    	jb     80108623 <copyuvm+0x2b>
      goto bad;
  }
  return d;
801086f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801086f4:	eb 17                	jmp    8010870d <copyuvm+0x115>
      goto bad;
801086f6:	90                   	nop
801086f7:	eb 01                	jmp    801086fa <copyuvm+0x102>
      goto bad;
801086f9:	90                   	nop

bad:
  freevm(d);
801086fa:	83 ec 0c             	sub    $0xc,%esp
801086fd:	ff 75 f0             	push   -0x10(%ebp)
80108700:	e8 12 fe ff ff       	call   80108517 <freevm>
80108705:	83 c4 10             	add    $0x10,%esp
  return 0;
80108708:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010870d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80108710:	c9                   	leave  
80108711:	c3                   	ret    

80108712 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108712:	55                   	push   %ebp
80108713:	89 e5                	mov    %esp,%ebp
80108715:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108718:	83 ec 04             	sub    $0x4,%esp
8010871b:	6a 00                	push   $0x0
8010871d:	ff 75 0c             	push   0xc(%ebp)
80108720:	ff 75 08             	push   0x8(%ebp)
80108723:	e8 93 f7 ff ff       	call   80107ebb <walkpgdir>
80108728:	83 c4 10             	add    $0x10,%esp
8010872b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
8010872e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108731:	8b 00                	mov    (%eax),%eax
80108733:	83 e0 01             	and    $0x1,%eax
80108736:	85 c0                	test   %eax,%eax
80108738:	75 07                	jne    80108741 <uva2ka+0x2f>
    return 0;
8010873a:	b8 00 00 00 00       	mov    $0x0,%eax
8010873f:	eb 2a                	jmp    8010876b <uva2ka+0x59>
  if((*pte & PTE_U) == 0)
80108741:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108744:	8b 00                	mov    (%eax),%eax
80108746:	83 e0 04             	and    $0x4,%eax
80108749:	85 c0                	test   %eax,%eax
8010874b:	75 07                	jne    80108754 <uva2ka+0x42>
    return 0;
8010874d:	b8 00 00 00 00       	mov    $0x0,%eax
80108752:	eb 17                	jmp    8010876b <uva2ka+0x59>
  return (char*)p2v(PTE_ADDR(*pte));
80108754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108757:	8b 00                	mov    (%eax),%eax
80108759:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010875e:	83 ec 0c             	sub    $0xc,%esp
80108761:	50                   	push   %eax
80108762:	e8 d2 f2 ff ff       	call   80107a39 <p2v>
80108767:	83 c4 10             	add    $0x10,%esp
8010876a:	90                   	nop
}
8010876b:	c9                   	leave  
8010876c:	c3                   	ret    

8010876d <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
8010876d:	55                   	push   %ebp
8010876e:	89 e5                	mov    %esp,%ebp
80108770:	83 ec 18             	sub    $0x18,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108773:	8b 45 10             	mov    0x10(%ebp),%eax
80108776:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108779:	eb 7f                	jmp    801087fa <copyout+0x8d>
    va0 = (uint)PGROUNDDOWN(va);
8010877b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010877e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108783:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108786:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108789:	83 ec 08             	sub    $0x8,%esp
8010878c:	50                   	push   %eax
8010878d:	ff 75 08             	push   0x8(%ebp)
80108790:	e8 7d ff ff ff       	call   80108712 <uva2ka>
80108795:	83 c4 10             	add    $0x10,%esp
80108798:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
8010879b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010879f:	75 07                	jne    801087a8 <copyout+0x3b>
      return -1;
801087a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801087a6:	eb 61                	jmp    80108809 <copyout+0x9c>
    n = PGSIZE - (va - va0);
801087a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087ab:	2b 45 0c             	sub    0xc(%ebp),%eax
801087ae:	05 00 10 00 00       	add    $0x1000,%eax
801087b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
801087b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087b9:	3b 45 14             	cmp    0x14(%ebp),%eax
801087bc:	76 06                	jbe    801087c4 <copyout+0x57>
      n = len;
801087be:	8b 45 14             	mov    0x14(%ebp),%eax
801087c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
801087c4:	8b 45 0c             	mov    0xc(%ebp),%eax
801087c7:	2b 45 ec             	sub    -0x14(%ebp),%eax
801087ca:	89 c2                	mov    %eax,%edx
801087cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
801087cf:	01 d0                	add    %edx,%eax
801087d1:	83 ec 04             	sub    $0x4,%esp
801087d4:	ff 75 f0             	push   -0x10(%ebp)
801087d7:	ff 75 f4             	push   -0xc(%ebp)
801087da:	50                   	push   %eax
801087db:	e8 0c cc ff ff       	call   801053ec <memmove>
801087e0:	83 c4 10             	add    $0x10,%esp
    len -= n;
801087e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087e6:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
801087e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801087ec:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
801087ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
801087f2:	05 00 10 00 00       	add    $0x1000,%eax
801087f7:	89 45 0c             	mov    %eax,0xc(%ebp)
  while(len > 0){
801087fa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801087fe:	0f 85 77 ff ff ff    	jne    8010877b <copyout+0xe>
  }
  return 0;
80108804:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108809:	c9                   	leave  
8010880a:	c3                   	ret    
