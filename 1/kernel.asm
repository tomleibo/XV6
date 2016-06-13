
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
80100015:	b8 00 b0 10 00       	mov    $0x10b000,%eax
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
80100028:	bc 70 d6 10 80       	mov    $0x8010d670,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 51 37 10 80       	mov    $0x80103751,%eax
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
80100037:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010003a:	c7 44 24 04 60 8d 10 	movl   $0x80108d60,0x4(%esp)
80100041:	80 
80100042:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100049:	e8 7f 54 00 00       	call   801054cd <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010004e:	c7 05 90 15 11 80 84 	movl   $0x80111584,0x80111590
80100055:	15 11 80 
  bcache.head.next = &bcache.head;
80100058:	c7 05 94 15 11 80 84 	movl   $0x80111584,0x80111594
8010005f:	15 11 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100062:	c7 45 f4 b4 d6 10 80 	movl   $0x8010d6b4,-0xc(%ebp)
80100069:	eb 3a                	jmp    801000a5 <binit+0x71>
    b->next = bcache.head.next;
8010006b:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100071:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100074:	89 50 10             	mov    %edx,0x10(%eax)
    b->prev = &bcache.head;
80100077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010007a:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
    b->dev = -1;
80100081:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100084:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
    bcache.head.next->prev = b;
8010008b:	a1 94 15 11 80       	mov    0x80111594,%eax
80100090:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100093:	89 50 0c             	mov    %edx,0xc(%eax)
    bcache.head.next = b;
80100096:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100099:	a3 94 15 11 80       	mov    %eax,0x80111594

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010009e:	81 45 f4 18 02 00 00 	addl   $0x218,-0xc(%ebp)
801000a5:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
801000ac:	72 bd                	jb     8010006b <binit+0x37>
    b->prev = &bcache.head;
    b->dev = -1;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000ae:	c9                   	leave  
801000af:	c3                   	ret    

801000b0 <bget>:
// Look through buffer cache for sector on device dev.
// If not found, allocate a buffer.
// In either case, return B_BUSY buffer.
static struct buf*
bget(uint dev, uint sector)
{
801000b0:	55                   	push   %ebp
801000b1:	89 e5                	mov    %esp,%ebp
801000b3:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  acquire(&bcache.lock);
801000b6:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801000bd:	e8 2c 54 00 00       	call   801054ee <acquire>

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000c2:	a1 94 15 11 80       	mov    0x80111594,%eax
801000c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
801000ca:	eb 63                	jmp    8010012f <bget+0x7f>
    if(b->dev == dev && b->sector == sector){
801000cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000cf:	8b 40 04             	mov    0x4(%eax),%eax
801000d2:	3b 45 08             	cmp    0x8(%ebp),%eax
801000d5:	75 4f                	jne    80100126 <bget+0x76>
801000d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000da:	8b 40 08             	mov    0x8(%eax),%eax
801000dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801000e0:	75 44                	jne    80100126 <bget+0x76>
      if(!(b->flags & B_BUSY)){
801000e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000e5:	8b 00                	mov    (%eax),%eax
801000e7:	83 e0 01             	and    $0x1,%eax
801000ea:	85 c0                	test   %eax,%eax
801000ec:	75 23                	jne    80100111 <bget+0x61>
        b->flags |= B_BUSY;
801000ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000f1:	8b 00                	mov    (%eax),%eax
801000f3:	83 c8 01             	or     $0x1,%eax
801000f6:	89 c2                	mov    %eax,%edx
801000f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801000fb:	89 10                	mov    %edx,(%eax)
        release(&bcache.lock);
801000fd:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
80100104:	e8 4c 54 00 00       	call   80105555 <release>
        return b;
80100109:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010010c:	e9 93 00 00 00       	jmp    801001a4 <bget+0xf4>
      }
      sleep(b, &bcache.lock);
80100111:	c7 44 24 04 80 d6 10 	movl   $0x8010d680,0x4(%esp)
80100118:	80 
80100119:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010011c:	89 04 24             	mov    %eax,(%esp)
8010011f:	e8 f8 4d 00 00       	call   80104f1c <sleep>
      goto loop;
80100124:	eb 9c                	jmp    801000c2 <bget+0x12>

  acquire(&bcache.lock);

 loop:
  // Is the sector already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
80100126:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100129:	8b 40 10             	mov    0x10(%eax),%eax
8010012c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010012f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100136:	75 94                	jne    801000cc <bget+0x1c>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100138:	a1 90 15 11 80       	mov    0x80111590,%eax
8010013d:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100140:	eb 4d                	jmp    8010018f <bget+0xdf>
    if((b->flags & B_BUSY) == 0 && (b->flags & B_DIRTY) == 0){
80100142:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100145:	8b 00                	mov    (%eax),%eax
80100147:	83 e0 01             	and    $0x1,%eax
8010014a:	85 c0                	test   %eax,%eax
8010014c:	75 38                	jne    80100186 <bget+0xd6>
8010014e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100151:	8b 00                	mov    (%eax),%eax
80100153:	83 e0 04             	and    $0x4,%eax
80100156:	85 c0                	test   %eax,%eax
80100158:	75 2c                	jne    80100186 <bget+0xd6>
      b->dev = dev;
8010015a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010015d:	8b 55 08             	mov    0x8(%ebp),%edx
80100160:	89 50 04             	mov    %edx,0x4(%eax)
      b->sector = sector;
80100163:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100166:	8b 55 0c             	mov    0xc(%ebp),%edx
80100169:	89 50 08             	mov    %edx,0x8(%eax)
      b->flags = B_BUSY;
8010016c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010016f:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
      release(&bcache.lock);
80100175:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010017c:	e8 d4 53 00 00       	call   80105555 <release>
      return b;
80100181:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100184:	eb 1e                	jmp    801001a4 <bget+0xf4>
  }

  // Not cached; recycle some non-busy and clean buffer.
  // "clean" because B_DIRTY and !B_BUSY means log.c
  // hasn't yet committed the changes to the buffer.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100186:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100189:	8b 40 0c             	mov    0xc(%eax),%eax
8010018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010018f:	81 7d f4 84 15 11 80 	cmpl   $0x80111584,-0xc(%ebp)
80100196:	75 aa                	jne    80100142 <bget+0x92>
      b->flags = B_BUSY;
      release(&bcache.lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100198:	c7 04 24 67 8d 10 80 	movl   $0x80108d67,(%esp)
8010019f:	e8 96 03 00 00       	call   8010053a <panic>
}
801001a4:	c9                   	leave  
801001a5:	c3                   	ret    

801001a6 <bread>:

// Return a B_BUSY buf with the contents of the indicated disk sector.
struct buf*
bread(uint dev, uint sector)
{
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  b = bget(dev, sector);
801001ac:	8b 45 0c             	mov    0xc(%ebp),%eax
801001af:	89 44 24 04          	mov    %eax,0x4(%esp)
801001b3:	8b 45 08             	mov    0x8(%ebp),%eax
801001b6:	89 04 24             	mov    %eax,(%esp)
801001b9:	e8 f2 fe ff ff       	call   801000b0 <bget>
801001be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!(b->flags & B_VALID))
801001c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001c4:	8b 00                	mov    (%eax),%eax
801001c6:	83 e0 02             	and    $0x2,%eax
801001c9:	85 c0                	test   %eax,%eax
801001cb:	75 0b                	jne    801001d8 <bread+0x32>
    iderw(b);
801001cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801001d0:	89 04 24             	mov    %eax,(%esp)
801001d3:	e8 03 26 00 00       	call   801027db <iderw>
  return b;
801001d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801001db:	c9                   	leave  
801001dc:	c3                   	ret    

801001dd <bwrite>:

// Write b's contents to disk.  Must be B_BUSY.
void
bwrite(struct buf *b)
{
801001dd:	55                   	push   %ebp
801001de:	89 e5                	mov    %esp,%ebp
801001e0:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
801001e3:	8b 45 08             	mov    0x8(%ebp),%eax
801001e6:	8b 00                	mov    (%eax),%eax
801001e8:	83 e0 01             	and    $0x1,%eax
801001eb:	85 c0                	test   %eax,%eax
801001ed:	75 0c                	jne    801001fb <bwrite+0x1e>
    panic("bwrite");
801001ef:	c7 04 24 78 8d 10 80 	movl   $0x80108d78,(%esp)
801001f6:	e8 3f 03 00 00       	call   8010053a <panic>
  b->flags |= B_DIRTY;
801001fb:	8b 45 08             	mov    0x8(%ebp),%eax
801001fe:	8b 00                	mov    (%eax),%eax
80100200:	83 c8 04             	or     $0x4,%eax
80100203:	89 c2                	mov    %eax,%edx
80100205:	8b 45 08             	mov    0x8(%ebp),%eax
80100208:	89 10                	mov    %edx,(%eax)
  iderw(b);
8010020a:	8b 45 08             	mov    0x8(%ebp),%eax
8010020d:	89 04 24             	mov    %eax,(%esp)
80100210:	e8 c6 25 00 00       	call   801027db <iderw>
}
80100215:	c9                   	leave  
80100216:	c3                   	ret    

80100217 <brelse>:

// Release a B_BUSY buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
80100217:	55                   	push   %ebp
80100218:	89 e5                	mov    %esp,%ebp
8010021a:	83 ec 18             	sub    $0x18,%esp
  if((b->flags & B_BUSY) == 0)
8010021d:	8b 45 08             	mov    0x8(%ebp),%eax
80100220:	8b 00                	mov    (%eax),%eax
80100222:	83 e0 01             	and    $0x1,%eax
80100225:	85 c0                	test   %eax,%eax
80100227:	75 0c                	jne    80100235 <brelse+0x1e>
    panic("brelse");
80100229:	c7 04 24 7f 8d 10 80 	movl   $0x80108d7f,(%esp)
80100230:	e8 05 03 00 00       	call   8010053a <panic>

  acquire(&bcache.lock);
80100235:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
8010023c:	e8 ad 52 00 00       	call   801054ee <acquire>

  b->next->prev = b->prev;
80100241:	8b 45 08             	mov    0x8(%ebp),%eax
80100244:	8b 40 10             	mov    0x10(%eax),%eax
80100247:	8b 55 08             	mov    0x8(%ebp),%edx
8010024a:	8b 52 0c             	mov    0xc(%edx),%edx
8010024d:	89 50 0c             	mov    %edx,0xc(%eax)
  b->prev->next = b->next;
80100250:	8b 45 08             	mov    0x8(%ebp),%eax
80100253:	8b 40 0c             	mov    0xc(%eax),%eax
80100256:	8b 55 08             	mov    0x8(%ebp),%edx
80100259:	8b 52 10             	mov    0x10(%edx),%edx
8010025c:	89 50 10             	mov    %edx,0x10(%eax)
  b->next = bcache.head.next;
8010025f:	8b 15 94 15 11 80    	mov    0x80111594,%edx
80100265:	8b 45 08             	mov    0x8(%ebp),%eax
80100268:	89 50 10             	mov    %edx,0x10(%eax)
  b->prev = &bcache.head;
8010026b:	8b 45 08             	mov    0x8(%ebp),%eax
8010026e:	c7 40 0c 84 15 11 80 	movl   $0x80111584,0xc(%eax)
  bcache.head.next->prev = b;
80100275:	a1 94 15 11 80       	mov    0x80111594,%eax
8010027a:	8b 55 08             	mov    0x8(%ebp),%edx
8010027d:	89 50 0c             	mov    %edx,0xc(%eax)
  bcache.head.next = b;
80100280:	8b 45 08             	mov    0x8(%ebp),%eax
80100283:	a3 94 15 11 80       	mov    %eax,0x80111594

  b->flags &= ~B_BUSY;
80100288:	8b 45 08             	mov    0x8(%ebp),%eax
8010028b:	8b 00                	mov    (%eax),%eax
8010028d:	83 e0 fe             	and    $0xfffffffe,%eax
80100290:	89 c2                	mov    %eax,%edx
80100292:	8b 45 08             	mov    0x8(%ebp),%eax
80100295:	89 10                	mov    %edx,(%eax)
  wakeup(b);
80100297:	8b 45 08             	mov    0x8(%ebp),%eax
8010029a:	89 04 24             	mov    %eax,(%esp)
8010029d:	e8 66 4d 00 00       	call   80105008 <wakeup>

  release(&bcache.lock);
801002a2:	c7 04 24 80 d6 10 80 	movl   $0x8010d680,(%esp)
801002a9:	e8 a7 52 00 00       	call   80105555 <release>
}
801002ae:	c9                   	leave  
801002af:	c3                   	ret    

801002b0 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
801002b0:	55                   	push   %ebp
801002b1:	89 e5                	mov    %esp,%ebp
801002b3:	83 ec 14             	sub    $0x14,%esp
801002b6:	8b 45 08             	mov    0x8(%ebp),%eax
801002b9:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801002bd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
801002c1:	89 c2                	mov    %eax,%edx
801002c3:	ec                   	in     (%dx),%al
801002c4:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
801002c7:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
801002cb:	c9                   	leave  
801002cc:	c3                   	ret    

801002cd <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
801002cd:	55                   	push   %ebp
801002ce:	89 e5                	mov    %esp,%ebp
801002d0:	83 ec 08             	sub    $0x8,%esp
801002d3:	8b 55 08             	mov    0x8(%ebp),%edx
801002d6:	8b 45 0c             	mov    0xc(%ebp),%eax
801002d9:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801002dd:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801002e0:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801002e4:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801002e8:	ee                   	out    %al,(%dx)
}
801002e9:	c9                   	leave  
801002ea:	c3                   	ret    

801002eb <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801002eb:	55                   	push   %ebp
801002ec:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801002ee:	fa                   	cli    
}
801002ef:	5d                   	pop    %ebp
801002f0:	c3                   	ret    

801002f1 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
801002f1:	55                   	push   %ebp
801002f2:	89 e5                	mov    %esp,%ebp
801002f4:	56                   	push   %esi
801002f5:	53                   	push   %ebx
801002f6:	83 ec 30             	sub    $0x30,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
801002f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801002fd:	74 1c                	je     8010031b <printint+0x2a>
801002ff:	8b 45 08             	mov    0x8(%ebp),%eax
80100302:	c1 e8 1f             	shr    $0x1f,%eax
80100305:	0f b6 c0             	movzbl %al,%eax
80100308:	89 45 10             	mov    %eax,0x10(%ebp)
8010030b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010030f:	74 0a                	je     8010031b <printint+0x2a>
    x = -xx;
80100311:	8b 45 08             	mov    0x8(%ebp),%eax
80100314:	f7 d8                	neg    %eax
80100316:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100319:	eb 06                	jmp    80100321 <printint+0x30>
  else
    x = xx;
8010031b:	8b 45 08             	mov    0x8(%ebp),%eax
8010031e:	89 45 f0             	mov    %eax,-0x10(%ebp)

  i = 0;
80100321:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
80100328:	8b 4d f4             	mov    -0xc(%ebp),%ecx
8010032b:	8d 41 01             	lea    0x1(%ecx),%eax
8010032e:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80100334:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100337:	ba 00 00 00 00       	mov    $0x0,%edx
8010033c:	f7 f3                	div    %ebx
8010033e:	89 d0                	mov    %edx,%eax
80100340:	0f b6 80 04 a0 10 80 	movzbl -0x7fef5ffc(%eax),%eax
80100347:	88 44 0d e0          	mov    %al,-0x20(%ebp,%ecx,1)
  }while((x /= base) != 0);
8010034b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010034e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100351:	ba 00 00 00 00       	mov    $0x0,%edx
80100356:	f7 f6                	div    %esi
80100358:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010035b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
8010035f:	75 c7                	jne    80100328 <printint+0x37>

  if(sign)
80100361:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80100365:	74 10                	je     80100377 <printint+0x86>
    buf[i++] = '-';
80100367:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010036a:	8d 50 01             	lea    0x1(%eax),%edx
8010036d:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100370:	c6 44 05 e0 2d       	movb   $0x2d,-0x20(%ebp,%eax,1)

  while(--i >= 0)
80100375:	eb 18                	jmp    8010038f <printint+0x9e>
80100377:	eb 16                	jmp    8010038f <printint+0x9e>
    consputc(buf[i]);
80100379:	8d 55 e0             	lea    -0x20(%ebp),%edx
8010037c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010037f:	01 d0                	add    %edx,%eax
80100381:	0f b6 00             	movzbl (%eax),%eax
80100384:	0f be c0             	movsbl %al,%eax
80100387:	89 04 24             	mov    %eax,(%esp)
8010038a:	e8 c1 03 00 00       	call   80100750 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
8010038f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100393:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100397:	79 e0                	jns    80100379 <printint+0x88>
    consputc(buf[i]);
}
80100399:	83 c4 30             	add    $0x30,%esp
8010039c:	5b                   	pop    %ebx
8010039d:	5e                   	pop    %esi
8010039e:	5d                   	pop    %ebp
8010039f:	c3                   	ret    

801003a0 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
801003a0:	55                   	push   %ebp
801003a1:	89 e5                	mov    %esp,%ebp
801003a3:	83 ec 38             	sub    $0x38,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
801003a6:	a1 14 c6 10 80       	mov    0x8010c614,%eax
801003ab:	89 45 e8             	mov    %eax,-0x18(%ebp)
  if(locking)
801003ae:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801003b2:	74 0c                	je     801003c0 <cprintf+0x20>
    acquire(&cons.lock);
801003b4:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
801003bb:	e8 2e 51 00 00       	call   801054ee <acquire>

  if (fmt == 0)
801003c0:	8b 45 08             	mov    0x8(%ebp),%eax
801003c3:	85 c0                	test   %eax,%eax
801003c5:	75 0c                	jne    801003d3 <cprintf+0x33>
    panic("null fmt");
801003c7:	c7 04 24 86 8d 10 80 	movl   $0x80108d86,(%esp)
801003ce:	e8 67 01 00 00       	call   8010053a <panic>

  argp = (uint*)(void*)(&fmt + 1);
801003d3:	8d 45 0c             	lea    0xc(%ebp),%eax
801003d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801003e0:	e9 21 01 00 00       	jmp    80100506 <cprintf+0x166>
    if(c != '%'){
801003e5:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
801003e9:	74 10                	je     801003fb <cprintf+0x5b>
      consputc(c);
801003eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801003ee:	89 04 24             	mov    %eax,(%esp)
801003f1:	e8 5a 03 00 00       	call   80100750 <consputc>
      continue;
801003f6:	e9 07 01 00 00       	jmp    80100502 <cprintf+0x162>
    }
    c = fmt[++i] & 0xff;
801003fb:	8b 55 08             	mov    0x8(%ebp),%edx
801003fe:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100402:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100405:	01 d0                	add    %edx,%eax
80100407:	0f b6 00             	movzbl (%eax),%eax
8010040a:	0f be c0             	movsbl %al,%eax
8010040d:	25 ff 00 00 00       	and    $0xff,%eax
80100412:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(c == 0)
80100415:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100419:	75 05                	jne    80100420 <cprintf+0x80>
      break;
8010041b:	e9 06 01 00 00       	jmp    80100526 <cprintf+0x186>
    switch(c){
80100420:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100423:	83 f8 70             	cmp    $0x70,%eax
80100426:	74 4f                	je     80100477 <cprintf+0xd7>
80100428:	83 f8 70             	cmp    $0x70,%eax
8010042b:	7f 13                	jg     80100440 <cprintf+0xa0>
8010042d:	83 f8 25             	cmp    $0x25,%eax
80100430:	0f 84 a6 00 00 00    	je     801004dc <cprintf+0x13c>
80100436:	83 f8 64             	cmp    $0x64,%eax
80100439:	74 14                	je     8010044f <cprintf+0xaf>
8010043b:	e9 aa 00 00 00       	jmp    801004ea <cprintf+0x14a>
80100440:	83 f8 73             	cmp    $0x73,%eax
80100443:	74 57                	je     8010049c <cprintf+0xfc>
80100445:	83 f8 78             	cmp    $0x78,%eax
80100448:	74 2d                	je     80100477 <cprintf+0xd7>
8010044a:	e9 9b 00 00 00       	jmp    801004ea <cprintf+0x14a>
    case 'd':
      printint(*argp++, 10, 1);
8010044f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100452:	8d 50 04             	lea    0x4(%eax),%edx
80100455:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100458:	8b 00                	mov    (%eax),%eax
8010045a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80100461:	00 
80100462:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80100469:	00 
8010046a:	89 04 24             	mov    %eax,(%esp)
8010046d:	e8 7f fe ff ff       	call   801002f1 <printint>
      break;
80100472:	e9 8b 00 00 00       	jmp    80100502 <cprintf+0x162>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
80100477:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010047a:	8d 50 04             	lea    0x4(%eax),%edx
8010047d:	89 55 f0             	mov    %edx,-0x10(%ebp)
80100480:	8b 00                	mov    (%eax),%eax
80100482:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100489:	00 
8010048a:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80100491:	00 
80100492:	89 04 24             	mov    %eax,(%esp)
80100495:	e8 57 fe ff ff       	call   801002f1 <printint>
      break;
8010049a:	eb 66                	jmp    80100502 <cprintf+0x162>
    case 's':
      if((s = (char*)*argp++) == 0)
8010049c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010049f:	8d 50 04             	lea    0x4(%eax),%edx
801004a2:	89 55 f0             	mov    %edx,-0x10(%ebp)
801004a5:	8b 00                	mov    (%eax),%eax
801004a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
801004aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
801004ae:	75 09                	jne    801004b9 <cprintf+0x119>
        s = "(null)";
801004b0:	c7 45 ec 8f 8d 10 80 	movl   $0x80108d8f,-0x14(%ebp)
      for(; *s; s++)
801004b7:	eb 17                	jmp    801004d0 <cprintf+0x130>
801004b9:	eb 15                	jmp    801004d0 <cprintf+0x130>
        consputc(*s);
801004bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004be:	0f b6 00             	movzbl (%eax),%eax
801004c1:	0f be c0             	movsbl %al,%eax
801004c4:	89 04 24             	mov    %eax,(%esp)
801004c7:	e8 84 02 00 00       	call   80100750 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801004cc:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
801004d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801004d3:	0f b6 00             	movzbl (%eax),%eax
801004d6:	84 c0                	test   %al,%al
801004d8:	75 e1                	jne    801004bb <cprintf+0x11b>
        consputc(*s);
      break;
801004da:	eb 26                	jmp    80100502 <cprintf+0x162>
    case '%':
      consputc('%');
801004dc:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004e3:	e8 68 02 00 00       	call   80100750 <consputc>
      break;
801004e8:	eb 18                	jmp    80100502 <cprintf+0x162>
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
801004ea:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
801004f1:	e8 5a 02 00 00       	call   80100750 <consputc>
      consputc(c);
801004f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801004f9:	89 04 24             	mov    %eax,(%esp)
801004fc:	e8 4f 02 00 00       	call   80100750 <consputc>
      break;
80100501:	90                   	nop

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100502:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100506:	8b 55 08             	mov    0x8(%ebp),%edx
80100509:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010050c:	01 d0                	add    %edx,%eax
8010050e:	0f b6 00             	movzbl (%eax),%eax
80100511:	0f be c0             	movsbl %al,%eax
80100514:	25 ff 00 00 00       	and    $0xff,%eax
80100519:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010051c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
80100520:	0f 85 bf fe ff ff    	jne    801003e5 <cprintf+0x45>
      consputc(c);
      break;
    }
  }

  if(locking)
80100526:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
8010052a:	74 0c                	je     80100538 <cprintf+0x198>
    release(&cons.lock);
8010052c:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100533:	e8 1d 50 00 00       	call   80105555 <release>
}
80100538:	c9                   	leave  
80100539:	c3                   	ret    

8010053a <panic>:

void
panic(char *s)
{
8010053a:	55                   	push   %ebp
8010053b:	89 e5                	mov    %esp,%ebp
8010053d:	83 ec 48             	sub    $0x48,%esp
  int i;
  uint pcs[10];
  
  cli();
80100540:	e8 a6 fd ff ff       	call   801002eb <cli>
  cons.locking = 0;
80100545:	c7 05 14 c6 10 80 00 	movl   $0x0,0x8010c614
8010054c:	00 00 00 
  cprintf("cpu%d: panic: ", cpu->id);
8010054f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80100555:	0f b6 00             	movzbl (%eax),%eax
80100558:	0f b6 c0             	movzbl %al,%eax
8010055b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010055f:	c7 04 24 96 8d 10 80 	movl   $0x80108d96,(%esp)
80100566:	e8 35 fe ff ff       	call   801003a0 <cprintf>
  cprintf(s);
8010056b:	8b 45 08             	mov    0x8(%ebp),%eax
8010056e:	89 04 24             	mov    %eax,(%esp)
80100571:	e8 2a fe ff ff       	call   801003a0 <cprintf>
  cprintf("\n");
80100576:	c7 04 24 a5 8d 10 80 	movl   $0x80108da5,(%esp)
8010057d:	e8 1e fe ff ff       	call   801003a0 <cprintf>
  getcallerpcs(&s, pcs);
80100582:	8d 45 cc             	lea    -0x34(%ebp),%eax
80100585:	89 44 24 04          	mov    %eax,0x4(%esp)
80100589:	8d 45 08             	lea    0x8(%ebp),%eax
8010058c:	89 04 24             	mov    %eax,(%esp)
8010058f:	e8 10 50 00 00       	call   801055a4 <getcallerpcs>
  for(i=0; i<10; i++)
80100594:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010059b:	eb 1b                	jmp    801005b8 <panic+0x7e>
    cprintf(" %p", pcs[i]);
8010059d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801005a0:	8b 44 85 cc          	mov    -0x34(%ebp,%eax,4),%eax
801005a4:	89 44 24 04          	mov    %eax,0x4(%esp)
801005a8:	c7 04 24 a7 8d 10 80 	movl   $0x80108da7,(%esp)
801005af:	e8 ec fd ff ff       	call   801003a0 <cprintf>
  cons.locking = 0;
  cprintf("cpu%d: panic: ", cpu->id);
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801005b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801005b8:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
801005bc:	7e df                	jle    8010059d <panic+0x63>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801005be:	c7 05 c0 c5 10 80 01 	movl   $0x1,0x8010c5c0
801005c5:	00 00 00 
  for(;;)
    ;
801005c8:	eb fe                	jmp    801005c8 <panic+0x8e>

801005ca <cgaputc>:
#define CRTPORT 0x3d4
static ushort *crt = (ushort*)P2V(0xb8000);  // CGA memory

static void
cgaputc(int c)
{
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	83 ec 28             	sub    $0x28,%esp
  int pos;
  
  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
801005d0:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801005d7:	00 
801005d8:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801005df:	e8 e9 fc ff ff       	call   801002cd <outb>
  pos = inb(CRTPORT+1) << 8;
801005e4:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
801005eb:	e8 c0 fc ff ff       	call   801002b0 <inb>
801005f0:	0f b6 c0             	movzbl %al,%eax
801005f3:	c1 e0 08             	shl    $0x8,%eax
801005f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  outb(CRTPORT, 15);
801005f9:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80100600:	00 
80100601:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100608:	e8 c0 fc ff ff       	call   801002cd <outb>
  pos |= inb(CRTPORT+1);
8010060d:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100614:	e8 97 fc ff ff       	call   801002b0 <inb>
80100619:	0f b6 c0             	movzbl %al,%eax
8010061c:	09 45 f4             	or     %eax,-0xc(%ebp)

  if(c == '\n')
8010061f:	83 7d 08 0a          	cmpl   $0xa,0x8(%ebp)
80100623:	75 30                	jne    80100655 <cgaputc+0x8b>
    pos += 80 - pos%80;
80100625:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80100628:	ba 67 66 66 66       	mov    $0x66666667,%edx
8010062d:	89 c8                	mov    %ecx,%eax
8010062f:	f7 ea                	imul   %edx
80100631:	c1 fa 05             	sar    $0x5,%edx
80100634:	89 c8                	mov    %ecx,%eax
80100636:	c1 f8 1f             	sar    $0x1f,%eax
80100639:	29 c2                	sub    %eax,%edx
8010063b:	89 d0                	mov    %edx,%eax
8010063d:	c1 e0 02             	shl    $0x2,%eax
80100640:	01 d0                	add    %edx,%eax
80100642:	c1 e0 04             	shl    $0x4,%eax
80100645:	29 c1                	sub    %eax,%ecx
80100647:	89 ca                	mov    %ecx,%edx
80100649:	b8 50 00 00 00       	mov    $0x50,%eax
8010064e:	29 d0                	sub    %edx,%eax
80100650:	01 45 f4             	add    %eax,-0xc(%ebp)
80100653:	eb 35                	jmp    8010068a <cgaputc+0xc0>
  else if(c == BACKSPACE){
80100655:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010065c:	75 0c                	jne    8010066a <cgaputc+0xa0>
    if(pos > 0) --pos;
8010065e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100662:	7e 26                	jle    8010068a <cgaputc+0xc0>
80100664:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
80100668:	eb 20                	jmp    8010068a <cgaputc+0xc0>
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010066a:	8b 0d 00 a0 10 80    	mov    0x8010a000,%ecx
80100670:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100673:	8d 50 01             	lea    0x1(%eax),%edx
80100676:	89 55 f4             	mov    %edx,-0xc(%ebp)
80100679:	01 c0                	add    %eax,%eax
8010067b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
8010067e:	8b 45 08             	mov    0x8(%ebp),%eax
80100681:	0f b6 c0             	movzbl %al,%eax
80100684:	80 cc 07             	or     $0x7,%ah
80100687:	66 89 02             	mov    %ax,(%edx)
  
  if((pos/80) >= 24){  // Scroll up.
8010068a:	81 7d f4 7f 07 00 00 	cmpl   $0x77f,-0xc(%ebp)
80100691:	7e 53                	jle    801006e6 <cgaputc+0x11c>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100693:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100698:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
8010069e:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006a3:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801006aa:	00 
801006ab:	89 54 24 04          	mov    %edx,0x4(%esp)
801006af:	89 04 24             	mov    %eax,(%esp)
801006b2:	e8 5f 51 00 00       	call   80105816 <memmove>
    pos -= 80;
801006b7:	83 6d f4 50          	subl   $0x50,-0xc(%ebp)
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801006bb:	b8 80 07 00 00       	mov    $0x780,%eax
801006c0:	2b 45 f4             	sub    -0xc(%ebp),%eax
801006c3:	8d 14 00             	lea    (%eax,%eax,1),%edx
801006c6:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801006cb:	8b 4d f4             	mov    -0xc(%ebp),%ecx
801006ce:	01 c9                	add    %ecx,%ecx
801006d0:	01 c8                	add    %ecx,%eax
801006d2:	89 54 24 08          	mov    %edx,0x8(%esp)
801006d6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801006dd:	00 
801006de:	89 04 24             	mov    %eax,(%esp)
801006e1:	e8 61 50 00 00       	call   80105747 <memset>
  }
  
  outb(CRTPORT, 14);
801006e6:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
801006ed:	00 
801006ee:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
801006f5:	e8 d3 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos>>8);
801006fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801006fd:	c1 f8 08             	sar    $0x8,%eax
80100700:	0f b6 c0             	movzbl %al,%eax
80100703:	89 44 24 04          	mov    %eax,0x4(%esp)
80100707:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
8010070e:	e8 ba fb ff ff       	call   801002cd <outb>
  outb(CRTPORT, 15);
80100713:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
8010071a:	00 
8010071b:	c7 04 24 d4 03 00 00 	movl   $0x3d4,(%esp)
80100722:	e8 a6 fb ff ff       	call   801002cd <outb>
  outb(CRTPORT+1, pos);
80100727:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010072a:	0f b6 c0             	movzbl %al,%eax
8010072d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100731:	c7 04 24 d5 03 00 00 	movl   $0x3d5,(%esp)
80100738:	e8 90 fb ff ff       	call   801002cd <outb>
  crt[pos] = ' ' | 0x0700;
8010073d:	a1 00 a0 10 80       	mov    0x8010a000,%eax
80100742:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100745:	01 d2                	add    %edx,%edx
80100747:	01 d0                	add    %edx,%eax
80100749:	66 c7 00 20 07       	movw   $0x720,(%eax)
}
8010074e:	c9                   	leave  
8010074f:	c3                   	ret    

80100750 <consputc>:

void
consputc(int c)
{
80100750:	55                   	push   %ebp
80100751:	89 e5                	mov    %esp,%ebp
80100753:	83 ec 18             	sub    $0x18,%esp
  if(panicked){
80100756:	a1 c0 c5 10 80       	mov    0x8010c5c0,%eax
8010075b:	85 c0                	test   %eax,%eax
8010075d:	74 07                	je     80100766 <consputc+0x16>
    cli();
8010075f:	e8 87 fb ff ff       	call   801002eb <cli>
    for(;;)
      ;
80100764:	eb fe                	jmp    80100764 <consputc+0x14>
  }

  if(c == BACKSPACE){
80100766:	81 7d 08 00 01 00 00 	cmpl   $0x100,0x8(%ebp)
8010076d:	75 26                	jne    80100795 <consputc+0x45>
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010076f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100776:	e8 25 6c 00 00       	call   801073a0 <uartputc>
8010077b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100782:	e8 19 6c 00 00       	call   801073a0 <uartputc>
80100787:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010078e:	e8 0d 6c 00 00       	call   801073a0 <uartputc>
80100793:	eb 0b                	jmp    801007a0 <consputc+0x50>
  } else
    uartputc(c);
80100795:	8b 45 08             	mov    0x8(%ebp),%eax
80100798:	89 04 24             	mov    %eax,(%esp)
8010079b:	e8 00 6c 00 00       	call   801073a0 <uartputc>
  cgaputc(c);
801007a0:	8b 45 08             	mov    0x8(%ebp),%eax
801007a3:	89 04 24             	mov    %eax,(%esp)
801007a6:	e8 1f fe ff ff       	call   801005ca <cgaputc>
}
801007ab:	c9                   	leave  
801007ac:	c3                   	ret    

801007ad <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007ad:	55                   	push   %ebp
801007ae:	89 e5                	mov    %esp,%ebp
801007b0:	83 ec 28             	sub    $0x28,%esp
  int c;

  acquire(&input.lock);
801007b3:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
801007ba:	e8 2f 4d 00 00       	call   801054ee <acquire>
  while((c = getc()) >= 0){
801007bf:	e9 37 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    switch(c){
801007c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801007c7:	83 f8 10             	cmp    $0x10,%eax
801007ca:	74 1e                	je     801007ea <consoleintr+0x3d>
801007cc:	83 f8 10             	cmp    $0x10,%eax
801007cf:	7f 0a                	jg     801007db <consoleintr+0x2e>
801007d1:	83 f8 08             	cmp    $0x8,%eax
801007d4:	74 64                	je     8010083a <consoleintr+0x8d>
801007d6:	e9 91 00 00 00       	jmp    8010086c <consoleintr+0xbf>
801007db:	83 f8 15             	cmp    $0x15,%eax
801007de:	74 2f                	je     8010080f <consoleintr+0x62>
801007e0:	83 f8 7f             	cmp    $0x7f,%eax
801007e3:	74 55                	je     8010083a <consoleintr+0x8d>
801007e5:	e9 82 00 00 00       	jmp    8010086c <consoleintr+0xbf>
    case C('P'):  // Process listing.
      procdump();
801007ea:	e8 cf 48 00 00       	call   801050be <procdump>
      break;
801007ef:	e9 07 01 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('U'):  // Kill line.
      while(input.e != input.w &&
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801007f4:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801007f9:	83 e8 01             	sub    $0x1,%eax
801007fc:	a3 5c 18 11 80       	mov    %eax,0x8011185c
        consputc(BACKSPACE);
80100801:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
80100808:	e8 43 ff ff ff       	call   80100750 <consputc>
8010080d:	eb 01                	jmp    80100810 <consoleintr+0x63>
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010080f:	90                   	nop
80100810:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100816:	a1 58 18 11 80       	mov    0x80111858,%eax
8010081b:	39 c2                	cmp    %eax,%edx
8010081d:	74 16                	je     80100835 <consoleintr+0x88>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
8010081f:	a1 5c 18 11 80       	mov    0x8011185c,%eax
80100824:	83 e8 01             	sub    $0x1,%eax
80100827:	83 e0 7f             	and    $0x7f,%eax
8010082a:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
    switch(c){
    case C('P'):  // Process listing.
      procdump();
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100831:	3c 0a                	cmp    $0xa,%al
80100833:	75 bf                	jne    801007f4 <consoleintr+0x47>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
        consputc(BACKSPACE);
      }
      break;
80100835:	e9 c1 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
8010083a:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
80100840:	a1 58 18 11 80       	mov    0x80111858,%eax
80100845:	39 c2                	cmp    %eax,%edx
80100847:	74 1e                	je     80100867 <consoleintr+0xba>
        input.e--;
80100849:	a1 5c 18 11 80       	mov    0x8011185c,%eax
8010084e:	83 e8 01             	sub    $0x1,%eax
80100851:	a3 5c 18 11 80       	mov    %eax,0x8011185c
        consputc(BACKSPACE);
80100856:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
8010085d:	e8 ee fe ff ff       	call   80100750 <consputc>
      }
      break;
80100862:	e9 94 00 00 00       	jmp    801008fb <consoleintr+0x14e>
80100867:	e9 8f 00 00 00       	jmp    801008fb <consoleintr+0x14e>
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
8010086c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100870:	0f 84 84 00 00 00    	je     801008fa <consoleintr+0x14d>
80100876:	8b 15 5c 18 11 80    	mov    0x8011185c,%edx
8010087c:	a1 54 18 11 80       	mov    0x80111854,%eax
80100881:	29 c2                	sub    %eax,%edx
80100883:	89 d0                	mov    %edx,%eax
80100885:	83 f8 7f             	cmp    $0x7f,%eax
80100888:	77 70                	ja     801008fa <consoleintr+0x14d>
        c = (c == '\r') ? '\n' : c;
8010088a:	83 7d f4 0d          	cmpl   $0xd,-0xc(%ebp)
8010088e:	74 05                	je     80100895 <consoleintr+0xe8>
80100890:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100893:	eb 05                	jmp    8010089a <consoleintr+0xed>
80100895:	b8 0a 00 00 00       	mov    $0xa,%eax
8010089a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        input.buf[input.e++ % INPUT_BUF] = c;
8010089d:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008a2:	8d 50 01             	lea    0x1(%eax),%edx
801008a5:	89 15 5c 18 11 80    	mov    %edx,0x8011185c
801008ab:	83 e0 7f             	and    $0x7f,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008b3:	88 82 d4 17 11 80    	mov    %al,-0x7feee82c(%edx)
        consputc(c);
801008b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801008bc:	89 04 24             	mov    %eax,(%esp)
801008bf:	e8 8c fe ff ff       	call   80100750 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c4:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
801008c8:	74 18                	je     801008e2 <consoleintr+0x135>
801008ca:	83 7d f4 04          	cmpl   $0x4,-0xc(%ebp)
801008ce:	74 12                	je     801008e2 <consoleintr+0x135>
801008d0:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008d5:	8b 15 54 18 11 80    	mov    0x80111854,%edx
801008db:	83 ea 80             	sub    $0xffffff80,%edx
801008de:	39 d0                	cmp    %edx,%eax
801008e0:	75 18                	jne    801008fa <consoleintr+0x14d>
          input.w = input.e;
801008e2:	a1 5c 18 11 80       	mov    0x8011185c,%eax
801008e7:	a3 58 18 11 80       	mov    %eax,0x80111858
          wakeup(&input.r);
801008ec:	c7 04 24 54 18 11 80 	movl   $0x80111854,(%esp)
801008f3:	e8 10 47 00 00       	call   80105008 <wakeup>
        }
      }
      break;
801008f8:	eb 00                	jmp    801008fa <consoleintr+0x14d>
801008fa:	90                   	nop
consoleintr(int (*getc)(void))
{
  int c;

  acquire(&input.lock);
  while((c = getc()) >= 0){
801008fb:	8b 45 08             	mov    0x8(%ebp),%eax
801008fe:	ff d0                	call   *%eax
80100900:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100903:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80100907:	0f 89 b7 fe ff ff    	jns    801007c4 <consoleintr+0x17>
        }
      }
      break;
    }
  }
  release(&input.lock);
8010090d:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100914:	e8 3c 4c 00 00       	call   80105555 <release>
}
80100919:	c9                   	leave  
8010091a:	c3                   	ret    

8010091b <consoleread>:

int
consoleread(struct inode *ip, char *dst, int n)
{
8010091b:	55                   	push   %ebp
8010091c:	89 e5                	mov    %esp,%ebp
8010091e:	83 ec 28             	sub    $0x28,%esp
  uint target;
  int c;

  iunlock(ip);
80100921:	8b 45 08             	mov    0x8(%ebp),%eax
80100924:	89 04 24             	mov    %eax,(%esp)
80100927:	e8 b7 10 00 00       	call   801019e3 <iunlock>
  target = n;
8010092c:	8b 45 10             	mov    0x10(%ebp),%eax
8010092f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  acquire(&input.lock);
80100932:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100939:	e8 b0 4b 00 00       	call   801054ee <acquire>
  while(n > 0){
8010093e:	e9 aa 00 00 00       	jmp    801009ed <consoleread+0xd2>
    while(input.r == input.w){
80100943:	eb 42                	jmp    80100987 <consoleread+0x6c>
      if(proc->killed){
80100945:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010094b:	8b 40 24             	mov    0x24(%eax),%eax
8010094e:	85 c0                	test   %eax,%eax
80100950:	74 21                	je     80100973 <consoleread+0x58>
        release(&input.lock);
80100952:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100959:	e8 f7 4b 00 00       	call   80105555 <release>
        ilock(ip);
8010095e:	8b 45 08             	mov    0x8(%ebp),%eax
80100961:	89 04 24             	mov    %eax,(%esp)
80100964:	e8 2c 0f 00 00       	call   80101895 <ilock>
        return -1;
80100969:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010096e:	e9 a5 00 00 00       	jmp    80100a18 <consoleread+0xfd>
      }
      sleep(&input.r, &input.lock);
80100973:	c7 44 24 04 a0 17 11 	movl   $0x801117a0,0x4(%esp)
8010097a:	80 
8010097b:	c7 04 24 54 18 11 80 	movl   $0x80111854,(%esp)
80100982:	e8 95 45 00 00       	call   80104f1c <sleep>

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
    while(input.r == input.w){
80100987:	8b 15 54 18 11 80    	mov    0x80111854,%edx
8010098d:	a1 58 18 11 80       	mov    0x80111858,%eax
80100992:	39 c2                	cmp    %eax,%edx
80100994:	74 af                	je     80100945 <consoleread+0x2a>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &input.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100996:	a1 54 18 11 80       	mov    0x80111854,%eax
8010099b:	8d 50 01             	lea    0x1(%eax),%edx
8010099e:	89 15 54 18 11 80    	mov    %edx,0x80111854
801009a4:	83 e0 7f             	and    $0x7f,%eax
801009a7:	0f b6 80 d4 17 11 80 	movzbl -0x7feee82c(%eax),%eax
801009ae:	0f be c0             	movsbl %al,%eax
801009b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(c == C('D')){  // EOF
801009b4:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
801009b8:	75 19                	jne    801009d3 <consoleread+0xb8>
      if(n < target){
801009ba:	8b 45 10             	mov    0x10(%ebp),%eax
801009bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801009c0:	73 0f                	jae    801009d1 <consoleread+0xb6>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
801009c2:	a1 54 18 11 80       	mov    0x80111854,%eax
801009c7:	83 e8 01             	sub    $0x1,%eax
801009ca:	a3 54 18 11 80       	mov    %eax,0x80111854
      }
      break;
801009cf:	eb 26                	jmp    801009f7 <consoleread+0xdc>
801009d1:	eb 24                	jmp    801009f7 <consoleread+0xdc>
    }
    *dst++ = c;
801009d3:	8b 45 0c             	mov    0xc(%ebp),%eax
801009d6:	8d 50 01             	lea    0x1(%eax),%edx
801009d9:	89 55 0c             	mov    %edx,0xc(%ebp)
801009dc:	8b 55 f0             	mov    -0x10(%ebp),%edx
801009df:	88 10                	mov    %dl,(%eax)
    --n;
801009e1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
    if(c == '\n')
801009e5:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
801009e9:	75 02                	jne    801009ed <consoleread+0xd2>
      break;
801009eb:	eb 0a                	jmp    801009f7 <consoleread+0xdc>
  int c;

  iunlock(ip);
  target = n;
  acquire(&input.lock);
  while(n > 0){
801009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801009f1:	0f 8f 4c ff ff ff    	jg     80100943 <consoleread+0x28>
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&input.lock);
801009f7:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
801009fe:	e8 52 4b 00 00       	call   80105555 <release>
  ilock(ip);
80100a03:	8b 45 08             	mov    0x8(%ebp),%eax
80100a06:	89 04 24             	mov    %eax,(%esp)
80100a09:	e8 87 0e 00 00       	call   80101895 <ilock>

  return target - n;
80100a0e:	8b 45 10             	mov    0x10(%ebp),%eax
80100a11:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a14:	29 c2                	sub    %eax,%edx
80100a16:	89 d0                	mov    %edx,%eax
}
80100a18:	c9                   	leave  
80100a19:	c3                   	ret    

80100a1a <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100a1a:	55                   	push   %ebp
80100a1b:	89 e5                	mov    %esp,%ebp
80100a1d:	83 ec 28             	sub    $0x28,%esp
  int i;

  iunlock(ip);
80100a20:	8b 45 08             	mov    0x8(%ebp),%eax
80100a23:	89 04 24             	mov    %eax,(%esp)
80100a26:	e8 b8 0f 00 00       	call   801019e3 <iunlock>
  acquire(&cons.lock);
80100a2b:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a32:	e8 b7 4a 00 00       	call   801054ee <acquire>
  for(i = 0; i < n; i++)
80100a37:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80100a3e:	eb 1d                	jmp    80100a5d <consolewrite+0x43>
    consputc(buf[i] & 0xff);
80100a40:	8b 55 f4             	mov    -0xc(%ebp),%edx
80100a43:	8b 45 0c             	mov    0xc(%ebp),%eax
80100a46:	01 d0                	add    %edx,%eax
80100a48:	0f b6 00             	movzbl (%eax),%eax
80100a4b:	0f be c0             	movsbl %al,%eax
80100a4e:	0f b6 c0             	movzbl %al,%eax
80100a51:	89 04 24             	mov    %eax,(%esp)
80100a54:	e8 f7 fc ff ff       	call   80100750 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
80100a59:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100a5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100a60:	3b 45 10             	cmp    0x10(%ebp),%eax
80100a63:	7c db                	jl     80100a40 <consolewrite+0x26>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
80100a65:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a6c:	e8 e4 4a 00 00       	call   80105555 <release>
  ilock(ip);
80100a71:	8b 45 08             	mov    0x8(%ebp),%eax
80100a74:	89 04 24             	mov    %eax,(%esp)
80100a77:	e8 19 0e 00 00       	call   80101895 <ilock>

  return n;
80100a7c:	8b 45 10             	mov    0x10(%ebp),%eax
}
80100a7f:	c9                   	leave  
80100a80:	c3                   	ret    

80100a81 <consoleinit>:

void
consoleinit(void)
{
80100a81:	55                   	push   %ebp
80100a82:	89 e5                	mov    %esp,%ebp
80100a84:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100a87:	c7 44 24 04 ab 8d 10 	movl   $0x80108dab,0x4(%esp)
80100a8e:	80 
80100a8f:	c7 04 24 e0 c5 10 80 	movl   $0x8010c5e0,(%esp)
80100a96:	e8 32 4a 00 00       	call   801054cd <initlock>
  initlock(&input.lock, "input");
80100a9b:	c7 44 24 04 b3 8d 10 	movl   $0x80108db3,0x4(%esp)
80100aa2:	80 
80100aa3:	c7 04 24 a0 17 11 80 	movl   $0x801117a0,(%esp)
80100aaa:	e8 1e 4a 00 00       	call   801054cd <initlock>

  devsw[CONSOLE].write = consolewrite;
80100aaf:	c7 05 0c 22 11 80 1a 	movl   $0x80100a1a,0x8011220c
80100ab6:	0a 10 80 
  devsw[CONSOLE].read = consoleread;
80100ab9:	c7 05 08 22 11 80 1b 	movl   $0x8010091b,0x80112208
80100ac0:	09 10 80 
  cons.locking = 1;
80100ac3:	c7 05 14 c6 10 80 01 	movl   $0x1,0x8010c614
80100aca:	00 00 00 

  picenable(IRQ_KBD);
80100acd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ad4:	e8 15 33 00 00       	call   80103dee <picenable>
  ioapicenable(IRQ_KBD, 0);
80100ad9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100ae0:	00 
80100ae1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80100ae8:	e8 aa 1e 00 00       	call   80102997 <ioapicenable>
}
80100aed:	c9                   	leave  
80100aee:	c3                   	ret    

80100aef <exec_exit>:

.globl exec_exit;
.globl exec_exit_end;

exec_exit:
	pushl %eax;
80100aef:	50                   	push   %eax
	movl $SYS_exit, %eax;
80100af0:	b8 02 00 00 00       	mov    $0x2,%eax
	int $T_SYSCALL;
80100af5:	cd 40                	int    $0x40
	ret;
80100af7:	c3                   	ret    

80100af8 <exec>:
extern int exec_exit(void);
extern int exec_exit_end(void);

int
exec(char *path, char **argv)
{
80100af8:	55                   	push   %ebp
80100af9:	89 e5                	mov    %esp,%ebp
80100afb:	81 ec 38 01 00 00    	sub    $0x138,%esp
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;

  begin_op();
80100b01:	e8 44 29 00 00       	call   8010344a <begin_op>
  if((ip = namei(path)) == 0){
80100b06:	8b 45 08             	mov    0x8(%ebp),%eax
80100b09:	89 04 24             	mov    %eax,(%esp)
80100b0c:	e8 2f 19 00 00       	call   80102440 <namei>
80100b11:	89 45 d8             	mov    %eax,-0x28(%ebp)
80100b14:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100b18:	75 0f                	jne    80100b29 <exec+0x31>
    end_op();
80100b1a:	e8 af 29 00 00       	call   801034ce <end_op>
    return -1;
80100b1f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b24:	e9 19 04 00 00       	jmp    80100f42 <exec+0x44a>
  }
  ilock(ip);
80100b29:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b2c:	89 04 24             	mov    %eax,(%esp)
80100b2f:	e8 61 0d 00 00       	call   80101895 <ilock>
  pgdir = 0;
80100b34:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) < sizeof(elf))
80100b3b:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
80100b42:	00 
80100b43:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80100b4a:	00 
80100b4b:	8d 85 08 ff ff ff    	lea    -0xf8(%ebp),%eax
80100b51:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b55:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100b58:	89 04 24             	mov    %eax,(%esp)
80100b5b:	e8 42 12 00 00       	call   80101da2 <readi>
80100b60:	83 f8 33             	cmp    $0x33,%eax
80100b63:	77 05                	ja     80100b6a <exec+0x72>
    goto bad;
80100b65:	e9 ac 03 00 00       	jmp    80100f16 <exec+0x41e>
  if(elf.magic != ELF_MAGIC)
80100b6a:	8b 85 08 ff ff ff    	mov    -0xf8(%ebp),%eax
80100b70:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
80100b75:	74 05                	je     80100b7c <exec+0x84>
    goto bad;
80100b77:	e9 9a 03 00 00       	jmp    80100f16 <exec+0x41e>

  if((pgdir = setupkvm()) == 0)
80100b7c:	e8 70 79 00 00       	call   801084f1 <setupkvm>
80100b81:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80100b84:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100b88:	75 05                	jne    80100b8f <exec+0x97>
    goto bad;
80100b8a:	e9 87 03 00 00       	jmp    80100f16 <exec+0x41e>

  // Load program into memory.
  sz = 0;
80100b8f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b96:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
80100b9d:	8b 85 24 ff ff ff    	mov    -0xdc(%ebp),%eax
80100ba3:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100ba6:	e9 cb 00 00 00       	jmp    80100c76 <exec+0x17e>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100bab:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100bae:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100bb5:	00 
80100bb6:	89 44 24 08          	mov    %eax,0x8(%esp)
80100bba:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
80100bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100bc7:	89 04 24             	mov    %eax,(%esp)
80100bca:	e8 d3 11 00 00       	call   80101da2 <readi>
80100bcf:	83 f8 20             	cmp    $0x20,%eax
80100bd2:	74 05                	je     80100bd9 <exec+0xe1>
      goto bad;
80100bd4:	e9 3d 03 00 00       	jmp    80100f16 <exec+0x41e>
    if(ph.type != ELF_PROG_LOAD)
80100bd9:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100bdf:	83 f8 01             	cmp    $0x1,%eax
80100be2:	74 05                	je     80100be9 <exec+0xf1>
      continue;
80100be4:	e9 80 00 00 00       	jmp    80100c69 <exec+0x171>
    if(ph.memsz < ph.filesz)
80100be9:	8b 95 fc fe ff ff    	mov    -0x104(%ebp),%edx
80100bef:	8b 85 f8 fe ff ff    	mov    -0x108(%ebp),%eax
80100bf5:	39 c2                	cmp    %eax,%edx
80100bf7:	73 05                	jae    80100bfe <exec+0x106>
      goto bad;
80100bf9:	e9 18 03 00 00       	jmp    80100f16 <exec+0x41e>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bfe:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
80100c04:	8b 85 fc fe ff ff    	mov    -0x104(%ebp),%eax
80100c0a:	01 d0                	add    %edx,%eax
80100c0c:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c10:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c13:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c17:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c1a:	89 04 24             	mov    %eax,(%esp)
80100c1d:	e8 9d 7c 00 00       	call   801088bf <allocuvm>
80100c22:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100c25:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100c29:	75 05                	jne    80100c30 <exec+0x138>
      goto bad;
80100c2b:	e9 e6 02 00 00       	jmp    80100f16 <exec+0x41e>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c30:	8b 8d f8 fe ff ff    	mov    -0x108(%ebp),%ecx
80100c36:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
80100c3c:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c42:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80100c46:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100c4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
80100c4d:	89 54 24 08          	mov    %edx,0x8(%esp)
80100c51:	89 44 24 04          	mov    %eax,0x4(%esp)
80100c55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100c58:	89 04 24             	mov    %eax,(%esp)
80100c5b:	e8 74 7b 00 00       	call   801087d4 <loaduvm>
80100c60:	85 c0                	test   %eax,%eax
80100c62:	79 05                	jns    80100c69 <exec+0x171>
      goto bad;
80100c64:	e9 ad 02 00 00       	jmp    80100f16 <exec+0x41e>
  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c69:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
80100c6d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80100c70:	83 c0 20             	add    $0x20,%eax
80100c73:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100c76:	0f b7 85 34 ff ff ff 	movzwl -0xcc(%ebp),%eax
80100c7d:	0f b7 c0             	movzwl %ax,%eax
80100c80:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80100c83:	0f 8f 22 ff ff ff    	jg     80100bab <exec+0xb3>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }

  uint sz_temp = sz;
80100c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100c8c:	89 45 d0             	mov    %eax,-0x30(%ebp)

  iunlockput(ip);
80100c8f:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100c92:	89 04 24             	mov    %eax,(%esp)
80100c95:	e8 7f 0e 00 00       	call   80101b19 <iunlockput>
  end_op();
80100c9a:	e8 2f 28 00 00       	call   801034ce <end_op>
  ip = 0;
80100c9f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100ca6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ca9:	05 ff 0f 00 00       	add    $0xfff,%eax
80100cae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80100cb3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cb9:	05 00 20 00 00       	add    $0x2000,%eax
80100cbe:	89 44 24 08          	mov    %eax,0x8(%esp)
80100cc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cc9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100ccc:	89 04 24             	mov    %eax,(%esp)
80100ccf:	e8 eb 7b 00 00       	call   801088bf <allocuvm>
80100cd4:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100cd7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80100cdb:	75 05                	jne    80100ce2 <exec+0x1ea>
    goto bad;
80100cdd:	e9 34 02 00 00       	jmp    80100f16 <exec+0x41e>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce2:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ce5:	2d 00 20 00 00       	sub    $0x2000,%eax
80100cea:	89 44 24 04          	mov    %eax,0x4(%esp)
80100cee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100cf1:	89 04 24             	mov    %eax,(%esp)
80100cf4:	e8 f6 7d 00 00       	call   80108aef <clearpteu>
  sp = sz;
80100cf9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100cfc:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100cff:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80100d06:	e9 9a 00 00 00       	jmp    80100da5 <exec+0x2ad>
    if(argc >= MAXARG)
80100d0b:	83 7d e4 1f          	cmpl   $0x1f,-0x1c(%ebp)
80100d0f:	76 05                	jbe    80100d16 <exec+0x21e>
      goto bad;
80100d11:	e9 00 02 00 00       	jmp    80100f16 <exec+0x41e>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d19:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d20:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d23:	01 d0                	add    %edx,%eax
80100d25:	8b 00                	mov    (%eax),%eax
80100d27:	89 04 24             	mov    %eax,(%esp)
80100d2a:	e8 82 4c 00 00       	call   801059b1 <strlen>
80100d2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100d32:	29 c2                	sub    %eax,%edx
80100d34:	89 d0                	mov    %edx,%eax
80100d36:	83 e8 01             	sub    $0x1,%eax
80100d39:	83 e0 fc             	and    $0xfffffffc,%eax
80100d3c:	89 45 dc             	mov    %eax,-0x24(%ebp)
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d42:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100d49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d4c:	01 d0                	add    %edx,%eax
80100d4e:	8b 00                	mov    (%eax),%eax
80100d50:	89 04 24             	mov    %eax,(%esp)
80100d53:	e8 59 4c 00 00       	call   801059b1 <strlen>
80100d58:	83 c0 01             	add    $0x1,%eax
80100d5b:	89 c2                	mov    %eax,%edx
80100d5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d60:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
80100d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d6a:	01 c8                	add    %ecx,%eax
80100d6c:	8b 00                	mov    (%eax),%eax
80100d6e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100d72:	89 44 24 08          	mov    %eax,0x8(%esp)
80100d76:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d79:	89 44 24 04          	mov    %eax,0x4(%esp)
80100d7d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100d80:	89 04 24             	mov    %eax,(%esp)
80100d83:	e8 2c 7f 00 00       	call   80108cb4 <copyout>
80100d88:	85 c0                	test   %eax,%eax
80100d8a:	79 05                	jns    80100d91 <exec+0x299>
      goto bad;
80100d8c:	e9 85 01 00 00       	jmp    80100f16 <exec+0x41e>
    ustack[3+argc] = sp;
80100d91:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100d94:	8d 50 03             	lea    0x3(%eax),%edx
80100d97:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100d9a:	89 84 95 3c ff ff ff 	mov    %eax,-0xc4(%ebp,%edx,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100da1:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80100da5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100da8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100daf:	8b 45 0c             	mov    0xc(%ebp),%eax
80100db2:	01 d0                	add    %edx,%eax
80100db4:	8b 00                	mov    (%eax),%eax
80100db6:	85 c0                	test   %eax,%eax
80100db8:	0f 85 4d ff ff ff    	jne    80100d0b <exec+0x213>
      goto bad;
    ustack[3+argc] = sp;
  }

  
  copyout(pgdir,sz_temp,exec_exit,exec_exit_end-exec_exit);
80100dbe:	ba f8 0a 10 80       	mov    $0x80100af8,%edx
80100dc3:	b8 ef 0a 10 80       	mov    $0x80100aef,%eax
80100dc8:	29 c2                	sub    %eax,%edx
80100dca:	89 d0                	mov    %edx,%eax
80100dcc:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100dd0:	c7 44 24 08 ef 0a 10 	movl   $0x80100aef,0x8(%esp)
80100dd7:	80 
80100dd8:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100ddb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ddf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100de2:	89 04 24             	mov    %eax,(%esp)
80100de5:	e8 ca 7e 00 00       	call   80108cb4 <copyout>

  ustack[3+argc] = 0;
80100dea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100ded:	83 c0 03             	add    $0x3,%eax
80100df0:	c7 84 85 3c ff ff ff 	movl   $0x0,-0xc4(%ebp,%eax,4)
80100df7:	00 00 00 00 

  ustack[0] = sz_temp;  // fake return PC
80100dfb:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100dfe:	89 85 3c ff ff ff    	mov    %eax,-0xc4(%ebp)
  ustack[1] = argc;
80100e04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e07:	89 85 40 ff ff ff    	mov    %eax,-0xc0(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100e0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e10:	83 c0 01             	add    $0x1,%eax
80100e13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80100e1a:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e1d:	29 d0                	sub    %edx,%eax
80100e1f:	89 85 44 ff ff ff    	mov    %eax,-0xbc(%ebp)

  sp -= (3+argc+1) * 4;
80100e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e28:	83 c0 04             	add    $0x4,%eax
80100e2b:	c1 e0 02             	shl    $0x2,%eax
80100e2e:	29 45 dc             	sub    %eax,-0x24(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100e31:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100e34:	83 c0 04             	add    $0x4,%eax
80100e37:	c1 e0 02             	shl    $0x2,%eax
80100e3a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100e3e:	8d 85 3c ff ff ff    	lea    -0xc4(%ebp),%eax
80100e44:	89 44 24 08          	mov    %eax,0x8(%esp)
80100e48:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100e4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100e4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100e52:	89 04 24             	mov    %eax,(%esp)
80100e55:	e8 5a 7e 00 00       	call   80108cb4 <copyout>
80100e5a:	85 c0                	test   %eax,%eax
80100e5c:	79 05                	jns    80100e63 <exec+0x36b>
    goto bad;
80100e5e:	e9 b3 00 00 00       	jmp    80100f16 <exec+0x41e>

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e63:	8b 45 08             	mov    0x8(%ebp),%eax
80100e66:	89 45 f4             	mov    %eax,-0xc(%ebp)
80100e69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
80100e6f:	eb 17                	jmp    80100e88 <exec+0x390>
    if(*s == '/')
80100e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e74:	0f b6 00             	movzbl (%eax),%eax
80100e77:	3c 2f                	cmp    $0x2f,%al
80100e79:	75 09                	jne    80100e84 <exec+0x38c>
      last = s+1;
80100e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e7e:	83 c0 01             	add    $0x1,%eax
80100e81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100e84:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80100e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100e8b:	0f b6 00             	movzbl (%eax),%eax
80100e8e:	84 c0                	test   %al,%al
80100e90:	75 df                	jne    80100e71 <exec+0x379>
    if(*s == '/')
      last = s+1;
  safestrcpy(proc->name, last, sizeof(proc->name));
80100e92:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100e98:	8d 50 6c             	lea    0x6c(%eax),%edx
80100e9b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ea2:	00 
80100ea3:	8b 45 f0             	mov    -0x10(%ebp),%eax
80100ea6:	89 44 24 04          	mov    %eax,0x4(%esp)
80100eaa:	89 14 24             	mov    %edx,(%esp)
80100ead:	e8 b5 4a 00 00       	call   80105967 <safestrcpy>
  
  // Commit to the user image.
  oldpgdir = proc->pgdir;
80100eb2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eb8:	8b 40 04             	mov    0x4(%eax),%eax
80100ebb:	89 45 cc             	mov    %eax,-0x34(%ebp)
  proc->pgdir = pgdir;
80100ebe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ec4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80100ec7:	89 50 04             	mov    %edx,0x4(%eax)
  proc->sz = sz;
80100eca:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100ed0:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100ed3:	89 10                	mov    %edx,(%eax)
  proc->tf->eip = elf.entry;  // main
80100ed5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100edb:	8b 40 18             	mov    0x18(%eax),%eax
80100ede:	8b 95 20 ff ff ff    	mov    -0xe0(%ebp),%edx
80100ee4:	89 50 38             	mov    %edx,0x38(%eax)
  proc->tf->esp = sp;
80100ee7:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100eed:	8b 40 18             	mov    0x18(%eax),%eax
80100ef0:	8b 55 dc             	mov    -0x24(%ebp),%edx
80100ef3:	89 50 44             	mov    %edx,0x44(%eax)
  switchuvm(proc);
80100ef6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80100efc:	89 04 24             	mov    %eax,(%esp)
80100eff:	e8 de 76 00 00       	call   801085e2 <switchuvm>
  freevm(oldpgdir);
80100f04:	8b 45 cc             	mov    -0x34(%ebp),%eax
80100f07:	89 04 24             	mov    %eax,(%esp)
80100f0a:	e8 46 7b 00 00       	call   80108a55 <freevm>
  return 0;
80100f0f:	b8 00 00 00 00       	mov    $0x0,%eax
80100f14:	eb 2c                	jmp    80100f42 <exec+0x44a>

 bad:
  if(pgdir)
80100f16:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
80100f1a:	74 0b                	je     80100f27 <exec+0x42f>
    freevm(pgdir);
80100f1c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 2e 7b 00 00       	call   80108a55 <freevm>
  if(ip){
80100f27:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
80100f2b:	74 10                	je     80100f3d <exec+0x445>
    iunlockput(ip);
80100f2d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80100f30:	89 04 24             	mov    %eax,(%esp)
80100f33:	e8 e1 0b 00 00       	call   80101b19 <iunlockput>
    end_op();
80100f38:	e8 91 25 00 00       	call   801034ce <end_op>
  }
  return -1;
80100f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f42:	c9                   	leave  
80100f43:	c3                   	ret    

80100f44 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100f44:	55                   	push   %ebp
80100f45:	89 e5                	mov    %esp,%ebp
80100f47:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100f4a:	c7 44 24 04 b9 8d 10 	movl   $0x80108db9,0x4(%esp)
80100f51:	80 
80100f52:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f59:	e8 6f 45 00 00       	call   801054cd <initlock>
}
80100f5e:	c9                   	leave  
80100f5f:	c3                   	ret    

80100f60 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	83 ec 28             	sub    $0x28,%esp
  struct file *f;

  acquire(&ftable.lock);
80100f66:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f6d:	e8 7c 45 00 00       	call   801054ee <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100f72:	c7 45 f4 94 18 11 80 	movl   $0x80111894,-0xc(%ebp)
80100f79:	eb 29                	jmp    80100fa4 <filealloc+0x44>
    if(f->ref == 0){
80100f7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f7e:	8b 40 04             	mov    0x4(%eax),%eax
80100f81:	85 c0                	test   %eax,%eax
80100f83:	75 1b                	jne    80100fa0 <filealloc+0x40>
      f->ref = 1;
80100f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f88:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
      release(&ftable.lock);
80100f8f:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100f96:	e8 ba 45 00 00       	call   80105555 <release>
      return f;
80100f9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80100f9e:	eb 1e                	jmp    80100fbe <filealloc+0x5e>
filealloc(void)
{
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100fa0:	83 45 f4 18          	addl   $0x18,-0xc(%ebp)
80100fa4:	81 7d f4 f4 21 11 80 	cmpl   $0x801121f4,-0xc(%ebp)
80100fab:	72 ce                	jb     80100f7b <filealloc+0x1b>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100fad:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fb4:	e8 9c 45 00 00       	call   80105555 <release>
  return 0;
80100fb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
80100fbe:	c9                   	leave  
80100fbf:	c3                   	ret    

80100fc0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100fc0:	55                   	push   %ebp
80100fc1:	89 e5                	mov    %esp,%ebp
80100fc3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ftable.lock);
80100fc6:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100fcd:	e8 1c 45 00 00       	call   801054ee <acquire>
  if(f->ref < 1)
80100fd2:	8b 45 08             	mov    0x8(%ebp),%eax
80100fd5:	8b 40 04             	mov    0x4(%eax),%eax
80100fd8:	85 c0                	test   %eax,%eax
80100fda:	7f 0c                	jg     80100fe8 <filedup+0x28>
    panic("filedup");
80100fdc:	c7 04 24 c0 8d 10 80 	movl   $0x80108dc0,(%esp)
80100fe3:	e8 52 f5 ff ff       	call   8010053a <panic>
  f->ref++;
80100fe8:	8b 45 08             	mov    0x8(%ebp),%eax
80100feb:	8b 40 04             	mov    0x4(%eax),%eax
80100fee:	8d 50 01             	lea    0x1(%eax),%edx
80100ff1:	8b 45 08             	mov    0x8(%ebp),%eax
80100ff4:	89 50 04             	mov    %edx,0x4(%eax)
  release(&ftable.lock);
80100ff7:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80100ffe:	e8 52 45 00 00       	call   80105555 <release>
  return f;
80101003:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101006:	c9                   	leave  
80101007:	c3                   	ret    

80101008 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80101008:	55                   	push   %ebp
80101009:	89 e5                	mov    %esp,%ebp
8010100b:	83 ec 38             	sub    $0x38,%esp
  struct file ff;

  acquire(&ftable.lock);
8010100e:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80101015:	e8 d4 44 00 00       	call   801054ee <acquire>
  if(f->ref < 1)
8010101a:	8b 45 08             	mov    0x8(%ebp),%eax
8010101d:	8b 40 04             	mov    0x4(%eax),%eax
80101020:	85 c0                	test   %eax,%eax
80101022:	7f 0c                	jg     80101030 <fileclose+0x28>
    panic("fileclose");
80101024:	c7 04 24 c8 8d 10 80 	movl   $0x80108dc8,(%esp)
8010102b:	e8 0a f5 ff ff       	call   8010053a <panic>
  if(--f->ref > 0){
80101030:	8b 45 08             	mov    0x8(%ebp),%eax
80101033:	8b 40 04             	mov    0x4(%eax),%eax
80101036:	8d 50 ff             	lea    -0x1(%eax),%edx
80101039:	8b 45 08             	mov    0x8(%ebp),%eax
8010103c:	89 50 04             	mov    %edx,0x4(%eax)
8010103f:	8b 45 08             	mov    0x8(%ebp),%eax
80101042:	8b 40 04             	mov    0x4(%eax),%eax
80101045:	85 c0                	test   %eax,%eax
80101047:	7e 11                	jle    8010105a <fileclose+0x52>
    release(&ftable.lock);
80101049:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
80101050:	e8 00 45 00 00       	call   80105555 <release>
80101055:	e9 82 00 00 00       	jmp    801010dc <fileclose+0xd4>
    return;
  }
  ff = *f;
8010105a:	8b 45 08             	mov    0x8(%ebp),%eax
8010105d:	8b 10                	mov    (%eax),%edx
8010105f:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101062:	8b 50 04             	mov    0x4(%eax),%edx
80101065:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101068:	8b 50 08             	mov    0x8(%eax),%edx
8010106b:	89 55 e8             	mov    %edx,-0x18(%ebp)
8010106e:	8b 50 0c             	mov    0xc(%eax),%edx
80101071:	89 55 ec             	mov    %edx,-0x14(%ebp)
80101074:	8b 50 10             	mov    0x10(%eax),%edx
80101077:	89 55 f0             	mov    %edx,-0x10(%ebp)
8010107a:	8b 40 14             	mov    0x14(%eax),%eax
8010107d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  f->ref = 0;
80101080:	8b 45 08             	mov    0x8(%ebp),%eax
80101083:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  f->type = FD_NONE;
8010108a:	8b 45 08             	mov    0x8(%ebp),%eax
8010108d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  release(&ftable.lock);
80101093:	c7 04 24 60 18 11 80 	movl   $0x80111860,(%esp)
8010109a:	e8 b6 44 00 00       	call   80105555 <release>
  
  if(ff.type == FD_PIPE)
8010109f:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a2:	83 f8 01             	cmp    $0x1,%eax
801010a5:	75 18                	jne    801010bf <fileclose+0xb7>
    pipeclose(ff.pipe, ff.writable);
801010a7:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
801010ab:	0f be d0             	movsbl %al,%edx
801010ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
801010b1:	89 54 24 04          	mov    %edx,0x4(%esp)
801010b5:	89 04 24             	mov    %eax,(%esp)
801010b8:	e8 e1 2f 00 00       	call   8010409e <pipeclose>
801010bd:	eb 1d                	jmp    801010dc <fileclose+0xd4>
  else if(ff.type == FD_INODE){
801010bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010c2:	83 f8 02             	cmp    $0x2,%eax
801010c5:	75 15                	jne    801010dc <fileclose+0xd4>
    begin_op();
801010c7:	e8 7e 23 00 00       	call   8010344a <begin_op>
    iput(ff.ip);
801010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801010cf:	89 04 24             	mov    %eax,(%esp)
801010d2:	e8 71 09 00 00       	call   80101a48 <iput>
    end_op();
801010d7:	e8 f2 23 00 00       	call   801034ce <end_op>
  }
}
801010dc:	c9                   	leave  
801010dd:	c3                   	ret    

801010de <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
801010de:	55                   	push   %ebp
801010df:	89 e5                	mov    %esp,%ebp
801010e1:	83 ec 18             	sub    $0x18,%esp
  if(f->type == FD_INODE){
801010e4:	8b 45 08             	mov    0x8(%ebp),%eax
801010e7:	8b 00                	mov    (%eax),%eax
801010e9:	83 f8 02             	cmp    $0x2,%eax
801010ec:	75 38                	jne    80101126 <filestat+0x48>
    ilock(f->ip);
801010ee:	8b 45 08             	mov    0x8(%ebp),%eax
801010f1:	8b 40 10             	mov    0x10(%eax),%eax
801010f4:	89 04 24             	mov    %eax,(%esp)
801010f7:	e8 99 07 00 00       	call   80101895 <ilock>
    stati(f->ip, st);
801010fc:	8b 45 08             	mov    0x8(%ebp),%eax
801010ff:	8b 40 10             	mov    0x10(%eax),%eax
80101102:	8b 55 0c             	mov    0xc(%ebp),%edx
80101105:	89 54 24 04          	mov    %edx,0x4(%esp)
80101109:	89 04 24             	mov    %eax,(%esp)
8010110c:	e8 4c 0c 00 00       	call   80101d5d <stati>
    iunlock(f->ip);
80101111:	8b 45 08             	mov    0x8(%ebp),%eax
80101114:	8b 40 10             	mov    0x10(%eax),%eax
80101117:	89 04 24             	mov    %eax,(%esp)
8010111a:	e8 c4 08 00 00       	call   801019e3 <iunlock>
    return 0;
8010111f:	b8 00 00 00 00       	mov    $0x0,%eax
80101124:	eb 05                	jmp    8010112b <filestat+0x4d>
  }
  return -1;
80101126:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010112b:	c9                   	leave  
8010112c:	c3                   	ret    

8010112d <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
8010112d:	55                   	push   %ebp
8010112e:	89 e5                	mov    %esp,%ebp
80101130:	83 ec 28             	sub    $0x28,%esp
  int r;

  if(f->readable == 0)
80101133:	8b 45 08             	mov    0x8(%ebp),%eax
80101136:	0f b6 40 08          	movzbl 0x8(%eax),%eax
8010113a:	84 c0                	test   %al,%al
8010113c:	75 0a                	jne    80101148 <fileread+0x1b>
    return -1;
8010113e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101143:	e9 9f 00 00 00       	jmp    801011e7 <fileread+0xba>
  if(f->type == FD_PIPE)
80101148:	8b 45 08             	mov    0x8(%ebp),%eax
8010114b:	8b 00                	mov    (%eax),%eax
8010114d:	83 f8 01             	cmp    $0x1,%eax
80101150:	75 1e                	jne    80101170 <fileread+0x43>
    return piperead(f->pipe, addr, n);
80101152:	8b 45 08             	mov    0x8(%ebp),%eax
80101155:	8b 40 0c             	mov    0xc(%eax),%eax
80101158:	8b 55 10             	mov    0x10(%ebp),%edx
8010115b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010115f:	8b 55 0c             	mov    0xc(%ebp),%edx
80101162:	89 54 24 04          	mov    %edx,0x4(%esp)
80101166:	89 04 24             	mov    %eax,(%esp)
80101169:	e8 b1 30 00 00       	call   8010421f <piperead>
8010116e:	eb 77                	jmp    801011e7 <fileread+0xba>
  if(f->type == FD_INODE){
80101170:	8b 45 08             	mov    0x8(%ebp),%eax
80101173:	8b 00                	mov    (%eax),%eax
80101175:	83 f8 02             	cmp    $0x2,%eax
80101178:	75 61                	jne    801011db <fileread+0xae>
    ilock(f->ip);
8010117a:	8b 45 08             	mov    0x8(%ebp),%eax
8010117d:	8b 40 10             	mov    0x10(%eax),%eax
80101180:	89 04 24             	mov    %eax,(%esp)
80101183:	e8 0d 07 00 00       	call   80101895 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80101188:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010118b:	8b 45 08             	mov    0x8(%ebp),%eax
8010118e:	8b 50 14             	mov    0x14(%eax),%edx
80101191:	8b 45 08             	mov    0x8(%ebp),%eax
80101194:	8b 40 10             	mov    0x10(%eax),%eax
80101197:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010119b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010119f:	8b 55 0c             	mov    0xc(%ebp),%edx
801011a2:	89 54 24 04          	mov    %edx,0x4(%esp)
801011a6:	89 04 24             	mov    %eax,(%esp)
801011a9:	e8 f4 0b 00 00       	call   80101da2 <readi>
801011ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
801011b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801011b5:	7e 11                	jle    801011c8 <fileread+0x9b>
      f->off += r;
801011b7:	8b 45 08             	mov    0x8(%ebp),%eax
801011ba:	8b 50 14             	mov    0x14(%eax),%edx
801011bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011c0:	01 c2                	add    %eax,%edx
801011c2:	8b 45 08             	mov    0x8(%ebp),%eax
801011c5:	89 50 14             	mov    %edx,0x14(%eax)
    iunlock(f->ip);
801011c8:	8b 45 08             	mov    0x8(%ebp),%eax
801011cb:	8b 40 10             	mov    0x10(%eax),%eax
801011ce:	89 04 24             	mov    %eax,(%esp)
801011d1:	e8 0d 08 00 00       	call   801019e3 <iunlock>
    return r;
801011d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801011d9:	eb 0c                	jmp    801011e7 <fileread+0xba>
  }
  panic("fileread");
801011db:	c7 04 24 d2 8d 10 80 	movl   $0x80108dd2,(%esp)
801011e2:	e8 53 f3 ff ff       	call   8010053a <panic>
}
801011e7:	c9                   	leave  
801011e8:	c3                   	ret    

801011e9 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
801011e9:	55                   	push   %ebp
801011ea:	89 e5                	mov    %esp,%ebp
801011ec:	53                   	push   %ebx
801011ed:	83 ec 24             	sub    $0x24,%esp
  int r;

  if(f->writable == 0)
801011f0:	8b 45 08             	mov    0x8(%ebp),%eax
801011f3:	0f b6 40 09          	movzbl 0x9(%eax),%eax
801011f7:	84 c0                	test   %al,%al
801011f9:	75 0a                	jne    80101205 <filewrite+0x1c>
    return -1;
801011fb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101200:	e9 20 01 00 00       	jmp    80101325 <filewrite+0x13c>
  if(f->type == FD_PIPE)
80101205:	8b 45 08             	mov    0x8(%ebp),%eax
80101208:	8b 00                	mov    (%eax),%eax
8010120a:	83 f8 01             	cmp    $0x1,%eax
8010120d:	75 21                	jne    80101230 <filewrite+0x47>
    return pipewrite(f->pipe, addr, n);
8010120f:	8b 45 08             	mov    0x8(%ebp),%eax
80101212:	8b 40 0c             	mov    0xc(%eax),%eax
80101215:	8b 55 10             	mov    0x10(%ebp),%edx
80101218:	89 54 24 08          	mov    %edx,0x8(%esp)
8010121c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010121f:	89 54 24 04          	mov    %edx,0x4(%esp)
80101223:	89 04 24             	mov    %eax,(%esp)
80101226:	e8 05 2f 00 00       	call   80104130 <pipewrite>
8010122b:	e9 f5 00 00 00       	jmp    80101325 <filewrite+0x13c>
  if(f->type == FD_INODE){
80101230:	8b 45 08             	mov    0x8(%ebp),%eax
80101233:	8b 00                	mov    (%eax),%eax
80101235:	83 f8 02             	cmp    $0x2,%eax
80101238:	0f 85 db 00 00 00    	jne    80101319 <filewrite+0x130>
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
8010123e:	c7 45 ec 00 1a 00 00 	movl   $0x1a00,-0x14(%ebp)
    int i = 0;
80101245:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while(i < n){
8010124c:	e9 a8 00 00 00       	jmp    801012f9 <filewrite+0x110>
      int n1 = n - i;
80101251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101254:	8b 55 10             	mov    0x10(%ebp),%edx
80101257:	29 c2                	sub    %eax,%edx
80101259:	89 d0                	mov    %edx,%eax
8010125b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(n1 > max)
8010125e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101261:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80101264:	7e 06                	jle    8010126c <filewrite+0x83>
        n1 = max;
80101266:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101269:	89 45 f0             	mov    %eax,-0x10(%ebp)

      begin_op();
8010126c:	e8 d9 21 00 00       	call   8010344a <begin_op>
      ilock(f->ip);
80101271:	8b 45 08             	mov    0x8(%ebp),%eax
80101274:	8b 40 10             	mov    0x10(%eax),%eax
80101277:	89 04 24             	mov    %eax,(%esp)
8010127a:	e8 16 06 00 00       	call   80101895 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
8010127f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80101282:	8b 45 08             	mov    0x8(%ebp),%eax
80101285:	8b 50 14             	mov    0x14(%eax),%edx
80101288:	8b 5d f4             	mov    -0xc(%ebp),%ebx
8010128b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010128e:	01 c3                	add    %eax,%ebx
80101290:	8b 45 08             	mov    0x8(%ebp),%eax
80101293:	8b 40 10             	mov    0x10(%eax),%eax
80101296:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010129a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010129e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801012a2:	89 04 24             	mov    %eax,(%esp)
801012a5:	e8 5c 0c 00 00       	call   80101f06 <writei>
801012aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
801012ad:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012b1:	7e 11                	jle    801012c4 <filewrite+0xdb>
        f->off += r;
801012b3:	8b 45 08             	mov    0x8(%ebp),%eax
801012b6:	8b 50 14             	mov    0x14(%eax),%edx
801012b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012bc:	01 c2                	add    %eax,%edx
801012be:	8b 45 08             	mov    0x8(%ebp),%eax
801012c1:	89 50 14             	mov    %edx,0x14(%eax)
      iunlock(f->ip);
801012c4:	8b 45 08             	mov    0x8(%ebp),%eax
801012c7:	8b 40 10             	mov    0x10(%eax),%eax
801012ca:	89 04 24             	mov    %eax,(%esp)
801012cd:	e8 11 07 00 00       	call   801019e3 <iunlock>
      end_op();
801012d2:	e8 f7 21 00 00       	call   801034ce <end_op>

      if(r < 0)
801012d7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
801012db:	79 02                	jns    801012df <filewrite+0xf6>
        break;
801012dd:	eb 26                	jmp    80101305 <filewrite+0x11c>
      if(r != n1)
801012df:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012e2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801012e5:	74 0c                	je     801012f3 <filewrite+0x10a>
        panic("short filewrite");
801012e7:	c7 04 24 db 8d 10 80 	movl   $0x80108ddb,(%esp)
801012ee:	e8 47 f2 ff ff       	call   8010053a <panic>
      i += r;
801012f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
801012f6:	01 45 f4             	add    %eax,-0xc(%ebp)
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((LOGSIZE-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
801012f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801012fc:	3b 45 10             	cmp    0x10(%ebp),%eax
801012ff:	0f 8c 4c ff ff ff    	jl     80101251 <filewrite+0x68>
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
80101305:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101308:	3b 45 10             	cmp    0x10(%ebp),%eax
8010130b:	75 05                	jne    80101312 <filewrite+0x129>
8010130d:	8b 45 10             	mov    0x10(%ebp),%eax
80101310:	eb 05                	jmp    80101317 <filewrite+0x12e>
80101312:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101317:	eb 0c                	jmp    80101325 <filewrite+0x13c>
  }
  panic("filewrite");
80101319:	c7 04 24 eb 8d 10 80 	movl   $0x80108deb,(%esp)
80101320:	e8 15 f2 ff ff       	call   8010053a <panic>
}
80101325:	83 c4 24             	add    $0x24,%esp
80101328:	5b                   	pop    %ebx
80101329:	5d                   	pop    %ebp
8010132a:	c3                   	ret    

8010132b <readsb>:
static void itrunc(struct inode*);

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
8010132b:	55                   	push   %ebp
8010132c:	89 e5                	mov    %esp,%ebp
8010132e:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, 1);
80101331:	8b 45 08             	mov    0x8(%ebp),%eax
80101334:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
8010133b:	00 
8010133c:	89 04 24             	mov    %eax,(%esp)
8010133f:	e8 62 ee ff ff       	call   801001a6 <bread>
80101344:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memmove(sb, bp->data, sizeof(*sb));
80101347:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010134a:	83 c0 18             	add    $0x18,%eax
8010134d:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80101354:	00 
80101355:	89 44 24 04          	mov    %eax,0x4(%esp)
80101359:	8b 45 0c             	mov    0xc(%ebp),%eax
8010135c:	89 04 24             	mov    %eax,(%esp)
8010135f:	e8 b2 44 00 00       	call   80105816 <memmove>
  brelse(bp);
80101364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101367:	89 04 24             	mov    %eax,(%esp)
8010136a:	e8 a8 ee ff ff       	call   80100217 <brelse>
}
8010136f:	c9                   	leave  
80101370:	c3                   	ret    

80101371 <bzero>:

// Zero a block.
static void
bzero(int dev, int bno)
{
80101371:	55                   	push   %ebp
80101372:	89 e5                	mov    %esp,%ebp
80101374:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  
  bp = bread(dev, bno);
80101377:	8b 55 0c             	mov    0xc(%ebp),%edx
8010137a:	8b 45 08             	mov    0x8(%ebp),%eax
8010137d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101381:	89 04 24             	mov    %eax,(%esp)
80101384:	e8 1d ee ff ff       	call   801001a6 <bread>
80101389:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(bp->data, 0, BSIZE);
8010138c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010138f:	83 c0 18             	add    $0x18,%eax
80101392:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101399:	00 
8010139a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801013a1:	00 
801013a2:	89 04 24             	mov    %eax,(%esp)
801013a5:	e8 9d 43 00 00       	call   80105747 <memset>
  log_write(bp);
801013aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013ad:	89 04 24             	mov    %eax,(%esp)
801013b0:	e8 a0 22 00 00       	call   80103655 <log_write>
  brelse(bp);
801013b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013b8:	89 04 24             	mov    %eax,(%esp)
801013bb:	e8 57 ee ff ff       	call   80100217 <brelse>
}
801013c0:	c9                   	leave  
801013c1:	c3                   	ret    

801013c2 <balloc>:
// Blocks. 

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
801013c2:	55                   	push   %ebp
801013c3:	89 e5                	mov    %esp,%ebp
801013c5:	83 ec 38             	sub    $0x38,%esp
  int b, bi, m;
  struct buf *bp;
  struct superblock sb;

  bp = 0;
801013c8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  readsb(dev, &sb);
801013cf:	8b 45 08             	mov    0x8(%ebp),%eax
801013d2:	8d 55 d8             	lea    -0x28(%ebp),%edx
801013d5:	89 54 24 04          	mov    %edx,0x4(%esp)
801013d9:	89 04 24             	mov    %eax,(%esp)
801013dc:	e8 4a ff ff ff       	call   8010132b <readsb>
  for(b = 0; b < sb.size; b += BPB){
801013e1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801013e8:	e9 07 01 00 00       	jmp    801014f4 <balloc+0x132>
    bp = bread(dev, BBLOCK(b, sb.ninodes));
801013ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801013f0:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801013f6:	85 c0                	test   %eax,%eax
801013f8:	0f 48 c2             	cmovs  %edx,%eax
801013fb:	c1 f8 0c             	sar    $0xc,%eax
801013fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101401:	c1 ea 03             	shr    $0x3,%edx
80101404:	01 d0                	add    %edx,%eax
80101406:	83 c0 03             	add    $0x3,%eax
80101409:	89 44 24 04          	mov    %eax,0x4(%esp)
8010140d:	8b 45 08             	mov    0x8(%ebp),%eax
80101410:	89 04 24             	mov    %eax,(%esp)
80101413:	e8 8e ed ff ff       	call   801001a6 <bread>
80101418:	89 45 ec             	mov    %eax,-0x14(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010141b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101422:	e9 9d 00 00 00       	jmp    801014c4 <balloc+0x102>
      m = 1 << (bi % 8);
80101427:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010142a:	99                   	cltd   
8010142b:	c1 ea 1d             	shr    $0x1d,%edx
8010142e:	01 d0                	add    %edx,%eax
80101430:	83 e0 07             	and    $0x7,%eax
80101433:	29 d0                	sub    %edx,%eax
80101435:	ba 01 00 00 00       	mov    $0x1,%edx
8010143a:	89 c1                	mov    %eax,%ecx
8010143c:	d3 e2                	shl    %cl,%edx
8010143e:	89 d0                	mov    %edx,%eax
80101440:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101443:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101446:	8d 50 07             	lea    0x7(%eax),%edx
80101449:	85 c0                	test   %eax,%eax
8010144b:	0f 48 c2             	cmovs  %edx,%eax
8010144e:	c1 f8 03             	sar    $0x3,%eax
80101451:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101454:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
80101459:	0f b6 c0             	movzbl %al,%eax
8010145c:	23 45 e8             	and    -0x18(%ebp),%eax
8010145f:	85 c0                	test   %eax,%eax
80101461:	75 5d                	jne    801014c0 <balloc+0xfe>
        bp->data[bi/8] |= m;  // Mark block in use.
80101463:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101466:	8d 50 07             	lea    0x7(%eax),%edx
80101469:	85 c0                	test   %eax,%eax
8010146b:	0f 48 c2             	cmovs  %edx,%eax
8010146e:	c1 f8 03             	sar    $0x3,%eax
80101471:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101474:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
80101479:	89 d1                	mov    %edx,%ecx
8010147b:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010147e:	09 ca                	or     %ecx,%edx
80101480:	89 d1                	mov    %edx,%ecx
80101482:	8b 55 ec             	mov    -0x14(%ebp),%edx
80101485:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
        log_write(bp);
80101489:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010148c:	89 04 24             	mov    %eax,(%esp)
8010148f:	e8 c1 21 00 00       	call   80103655 <log_write>
        brelse(bp);
80101494:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101497:	89 04 24             	mov    %eax,(%esp)
8010149a:	e8 78 ed ff ff       	call   80100217 <brelse>
        bzero(dev, b + bi);
8010149f:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014a2:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014a5:	01 c2                	add    %eax,%edx
801014a7:	8b 45 08             	mov    0x8(%ebp),%eax
801014aa:	89 54 24 04          	mov    %edx,0x4(%esp)
801014ae:	89 04 24             	mov    %eax,(%esp)
801014b1:	e8 bb fe ff ff       	call   80101371 <bzero>
        return b + bi;
801014b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014bc:	01 d0                	add    %edx,%eax
801014be:	eb 4e                	jmp    8010150e <balloc+0x14c>

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb.ninodes));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801014c0:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801014c4:	81 7d f0 ff 0f 00 00 	cmpl   $0xfff,-0x10(%ebp)
801014cb:	7f 15                	jg     801014e2 <balloc+0x120>
801014cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801014d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014d3:	01 d0                	add    %edx,%eax
801014d5:	89 c2                	mov    %eax,%edx
801014d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014da:	39 c2                	cmp    %eax,%edx
801014dc:	0f 82 45 ff ff ff    	jb     80101427 <balloc+0x65>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
801014e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
801014e5:	89 04 24             	mov    %eax,(%esp)
801014e8:	e8 2a ed ff ff       	call   80100217 <brelse>
  struct buf *bp;
  struct superblock sb;

  bp = 0;
  readsb(dev, &sb);
  for(b = 0; b < sb.size; b += BPB){
801014ed:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801014f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
801014f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
801014fa:	39 c2                	cmp    %eax,%edx
801014fc:	0f 82 eb fe ff ff    	jb     801013ed <balloc+0x2b>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
80101502:	c7 04 24 f5 8d 10 80 	movl   $0x80108df5,(%esp)
80101509:	e8 2c f0 ff ff       	call   8010053a <panic>
}
8010150e:	c9                   	leave  
8010150f:	c3                   	ret    

80101510 <bfree>:

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101510:	55                   	push   %ebp
80101511:	89 e5                	mov    %esp,%ebp
80101513:	83 ec 38             	sub    $0x38,%esp
  struct buf *bp;
  struct superblock sb;
  int bi, m;

  readsb(dev, &sb);
80101516:	8d 45 dc             	lea    -0x24(%ebp),%eax
80101519:	89 44 24 04          	mov    %eax,0x4(%esp)
8010151d:	8b 45 08             	mov    0x8(%ebp),%eax
80101520:	89 04 24             	mov    %eax,(%esp)
80101523:	e8 03 fe ff ff       	call   8010132b <readsb>
  bp = bread(dev, BBLOCK(b, sb.ninodes));
80101528:	8b 45 0c             	mov    0xc(%ebp),%eax
8010152b:	c1 e8 0c             	shr    $0xc,%eax
8010152e:	89 c2                	mov    %eax,%edx
80101530:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101533:	c1 e8 03             	shr    $0x3,%eax
80101536:	01 d0                	add    %edx,%eax
80101538:	8d 50 03             	lea    0x3(%eax),%edx
8010153b:	8b 45 08             	mov    0x8(%ebp),%eax
8010153e:	89 54 24 04          	mov    %edx,0x4(%esp)
80101542:	89 04 24             	mov    %eax,(%esp)
80101545:	e8 5c ec ff ff       	call   801001a6 <bread>
8010154a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  bi = b % BPB;
8010154d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101550:	25 ff 0f 00 00       	and    $0xfff,%eax
80101555:	89 45 f0             	mov    %eax,-0x10(%ebp)
  m = 1 << (bi % 8);
80101558:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010155b:	99                   	cltd   
8010155c:	c1 ea 1d             	shr    $0x1d,%edx
8010155f:	01 d0                	add    %edx,%eax
80101561:	83 e0 07             	and    $0x7,%eax
80101564:	29 d0                	sub    %edx,%eax
80101566:	ba 01 00 00 00       	mov    $0x1,%edx
8010156b:	89 c1                	mov    %eax,%ecx
8010156d:	d3 e2                	shl    %cl,%edx
8010156f:	89 d0                	mov    %edx,%eax
80101571:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((bp->data[bi/8] & m) == 0)
80101574:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101577:	8d 50 07             	lea    0x7(%eax),%edx
8010157a:	85 c0                	test   %eax,%eax
8010157c:	0f 48 c2             	cmovs  %edx,%eax
8010157f:	c1 f8 03             	sar    $0x3,%eax
80101582:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101585:	0f b6 44 02 18       	movzbl 0x18(%edx,%eax,1),%eax
8010158a:	0f b6 c0             	movzbl %al,%eax
8010158d:	23 45 ec             	and    -0x14(%ebp),%eax
80101590:	85 c0                	test   %eax,%eax
80101592:	75 0c                	jne    801015a0 <bfree+0x90>
    panic("freeing free block");
80101594:	c7 04 24 0b 8e 10 80 	movl   $0x80108e0b,(%esp)
8010159b:	e8 9a ef ff ff       	call   8010053a <panic>
  bp->data[bi/8] &= ~m;
801015a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801015a3:	8d 50 07             	lea    0x7(%eax),%edx
801015a6:	85 c0                	test   %eax,%eax
801015a8:	0f 48 c2             	cmovs  %edx,%eax
801015ab:	c1 f8 03             	sar    $0x3,%eax
801015ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015b1:	0f b6 54 02 18       	movzbl 0x18(%edx,%eax,1),%edx
801015b6:	8b 4d ec             	mov    -0x14(%ebp),%ecx
801015b9:	f7 d1                	not    %ecx
801015bb:	21 ca                	and    %ecx,%edx
801015bd:	89 d1                	mov    %edx,%ecx
801015bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
801015c2:	88 4c 02 18          	mov    %cl,0x18(%edx,%eax,1)
  log_write(bp);
801015c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015c9:	89 04 24             	mov    %eax,(%esp)
801015cc:	e8 84 20 00 00       	call   80103655 <log_write>
  brelse(bp);
801015d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801015d4:	89 04 24             	mov    %eax,(%esp)
801015d7:	e8 3b ec ff ff       	call   80100217 <brelse>
}
801015dc:	c9                   	leave  
801015dd:	c3                   	ret    

801015de <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(void)
{
801015de:	55                   	push   %ebp
801015df:	89 e5                	mov    %esp,%ebp
801015e1:	83 ec 18             	sub    $0x18,%esp
  initlock(&icache.lock, "icache");
801015e4:	c7 44 24 04 1e 8e 10 	movl   $0x80108e1e,0x4(%esp)
801015eb:	80 
801015ec:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801015f3:	e8 d5 3e 00 00       	call   801054cd <initlock>
}
801015f8:	c9                   	leave  
801015f9:	c3                   	ret    

801015fa <ialloc>:
//PAGEBREAK!
// Allocate a new inode with the given type on device dev.
// A free inode has a type of zero.
struct inode*
ialloc(uint dev, short type)
{
801015fa:	55                   	push   %ebp
801015fb:	89 e5                	mov    %esp,%ebp
801015fd:	83 ec 38             	sub    $0x38,%esp
80101600:	8b 45 0c             	mov    0xc(%ebp),%eax
80101603:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);
80101607:	8b 45 08             	mov    0x8(%ebp),%eax
8010160a:	8d 55 dc             	lea    -0x24(%ebp),%edx
8010160d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101611:	89 04 24             	mov    %eax,(%esp)
80101614:	e8 12 fd ff ff       	call   8010132b <readsb>

  for(inum = 1; inum < sb.ninodes; inum++){
80101619:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
80101620:	e9 98 00 00 00       	jmp    801016bd <ialloc+0xc3>
    bp = bread(dev, IBLOCK(inum));
80101625:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101628:	c1 e8 03             	shr    $0x3,%eax
8010162b:	83 c0 02             	add    $0x2,%eax
8010162e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101632:	8b 45 08             	mov    0x8(%ebp),%eax
80101635:	89 04 24             	mov    %eax,(%esp)
80101638:	e8 69 eb ff ff       	call   801001a6 <bread>
8010163d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    dip = (struct dinode*)bp->data + inum%IPB;
80101640:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101643:	8d 50 18             	lea    0x18(%eax),%edx
80101646:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101649:	83 e0 07             	and    $0x7,%eax
8010164c:	c1 e0 06             	shl    $0x6,%eax
8010164f:	01 d0                	add    %edx,%eax
80101651:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(dip->type == 0){  // a free inode
80101654:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101657:	0f b7 00             	movzwl (%eax),%eax
8010165a:	66 85 c0             	test   %ax,%ax
8010165d:	75 4f                	jne    801016ae <ialloc+0xb4>
      memset(dip, 0, sizeof(*dip));
8010165f:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
80101666:	00 
80101667:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010166e:	00 
8010166f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101672:	89 04 24             	mov    %eax,(%esp)
80101675:	e8 cd 40 00 00       	call   80105747 <memset>
      dip->type = type;
8010167a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010167d:	0f b7 55 d4          	movzwl -0x2c(%ebp),%edx
80101681:	66 89 10             	mov    %dx,(%eax)
      log_write(bp);   // mark it allocated on the disk
80101684:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101687:	89 04 24             	mov    %eax,(%esp)
8010168a:	e8 c6 1f 00 00       	call   80103655 <log_write>
      brelse(bp);
8010168f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101692:	89 04 24             	mov    %eax,(%esp)
80101695:	e8 7d eb ff ff       	call   80100217 <brelse>
      return iget(dev, inum);
8010169a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010169d:	89 44 24 04          	mov    %eax,0x4(%esp)
801016a1:	8b 45 08             	mov    0x8(%ebp),%eax
801016a4:	89 04 24             	mov    %eax,(%esp)
801016a7:	e8 e5 00 00 00       	call   80101791 <iget>
801016ac:	eb 29                	jmp    801016d7 <ialloc+0xdd>
    }
    brelse(bp);
801016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
801016b1:	89 04 24             	mov    %eax,(%esp)
801016b4:	e8 5e eb ff ff       	call   80100217 <brelse>
  struct dinode *dip;
  struct superblock sb;

  readsb(dev, &sb);

  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801016bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801016c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801016c3:	39 c2                	cmp    %eax,%edx
801016c5:	0f 82 5a ff ff ff    	jb     80101625 <ialloc+0x2b>
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801016cb:	c7 04 24 25 8e 10 80 	movl   $0x80108e25,(%esp)
801016d2:	e8 63 ee ff ff       	call   8010053a <panic>
}
801016d7:	c9                   	leave  
801016d8:	c3                   	ret    

801016d9 <iupdate>:

// Copy a modified in-memory inode to disk.
void
iupdate(struct inode *ip)
{
801016d9:	55                   	push   %ebp
801016da:	89 e5                	mov    %esp,%ebp
801016dc:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum));
801016df:	8b 45 08             	mov    0x8(%ebp),%eax
801016e2:	8b 40 04             	mov    0x4(%eax),%eax
801016e5:	c1 e8 03             	shr    $0x3,%eax
801016e8:	8d 50 02             	lea    0x2(%eax),%edx
801016eb:	8b 45 08             	mov    0x8(%ebp),%eax
801016ee:	8b 00                	mov    (%eax),%eax
801016f0:	89 54 24 04          	mov    %edx,0x4(%esp)
801016f4:	89 04 24             	mov    %eax,(%esp)
801016f7:	e8 aa ea ff ff       	call   801001a6 <bread>
801016fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101702:	8d 50 18             	lea    0x18(%eax),%edx
80101705:	8b 45 08             	mov    0x8(%ebp),%eax
80101708:	8b 40 04             	mov    0x4(%eax),%eax
8010170b:	83 e0 07             	and    $0x7,%eax
8010170e:	c1 e0 06             	shl    $0x6,%eax
80101711:	01 d0                	add    %edx,%eax
80101713:	89 45 f0             	mov    %eax,-0x10(%ebp)
  dip->type = ip->type;
80101716:	8b 45 08             	mov    0x8(%ebp),%eax
80101719:	0f b7 50 10          	movzwl 0x10(%eax),%edx
8010171d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101720:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
80101723:	8b 45 08             	mov    0x8(%ebp),%eax
80101726:	0f b7 50 12          	movzwl 0x12(%eax),%edx
8010172a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010172d:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101731:	8b 45 08             	mov    0x8(%ebp),%eax
80101734:	0f b7 50 14          	movzwl 0x14(%eax),%edx
80101738:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010173b:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010173f:	8b 45 08             	mov    0x8(%ebp),%eax
80101742:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101746:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101749:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
8010174d:	8b 45 08             	mov    0x8(%ebp),%eax
80101750:	8b 50 18             	mov    0x18(%eax),%edx
80101753:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101756:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101759:	8b 45 08             	mov    0x8(%ebp),%eax
8010175c:	8d 50 1c             	lea    0x1c(%eax),%edx
8010175f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101762:	83 c0 0c             	add    $0xc,%eax
80101765:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010176c:	00 
8010176d:	89 54 24 04          	mov    %edx,0x4(%esp)
80101771:	89 04 24             	mov    %eax,(%esp)
80101774:	e8 9d 40 00 00       	call   80105816 <memmove>
  log_write(bp);
80101779:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010177c:	89 04 24             	mov    %eax,(%esp)
8010177f:	e8 d1 1e 00 00       	call   80103655 <log_write>
  brelse(bp);
80101784:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101787:	89 04 24             	mov    %eax,(%esp)
8010178a:	e8 88 ea ff ff       	call   80100217 <brelse>
}
8010178f:	c9                   	leave  
80101790:	c3                   	ret    

80101791 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101791:	55                   	push   %ebp
80101792:	89 e5                	mov    %esp,%ebp
80101794:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101797:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010179e:	e8 4b 3d 00 00       	call   801054ee <acquire>

  // Is the inode already cached?
  empty = 0;
801017a3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801017aa:	c7 45 f4 94 22 11 80 	movl   $0x80112294,-0xc(%ebp)
801017b1:	eb 59                	jmp    8010180c <iget+0x7b>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017b6:	8b 40 08             	mov    0x8(%eax),%eax
801017b9:	85 c0                	test   %eax,%eax
801017bb:	7e 35                	jle    801017f2 <iget+0x61>
801017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017c0:	8b 00                	mov    (%eax),%eax
801017c2:	3b 45 08             	cmp    0x8(%ebp),%eax
801017c5:	75 2b                	jne    801017f2 <iget+0x61>
801017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017ca:	8b 40 04             	mov    0x4(%eax),%eax
801017cd:	3b 45 0c             	cmp    0xc(%ebp),%eax
801017d0:	75 20                	jne    801017f2 <iget+0x61>
      ip->ref++;
801017d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017d5:	8b 40 08             	mov    0x8(%eax),%eax
801017d8:	8d 50 01             	lea    0x1(%eax),%edx
801017db:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017de:	89 50 08             	mov    %edx,0x8(%eax)
      release(&icache.lock);
801017e1:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801017e8:	e8 68 3d 00 00       	call   80105555 <release>
      return ip;
801017ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017f0:	eb 6f                	jmp    80101861 <iget+0xd0>
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801017f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801017f6:	75 10                	jne    80101808 <iget+0x77>
801017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801017fb:	8b 40 08             	mov    0x8(%eax),%eax
801017fe:	85 c0                	test   %eax,%eax
80101800:	75 06                	jne    80101808 <iget+0x77>
      empty = ip;
80101802:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101805:	89 45 f0             	mov    %eax,-0x10(%ebp)

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101808:	83 45 f4 50          	addl   $0x50,-0xc(%ebp)
8010180c:	81 7d f4 34 32 11 80 	cmpl   $0x80113234,-0xc(%ebp)
80101813:	72 9e                	jb     801017b3 <iget+0x22>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101815:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80101819:	75 0c                	jne    80101827 <iget+0x96>
    panic("iget: no inodes");
8010181b:	c7 04 24 37 8e 10 80 	movl   $0x80108e37,(%esp)
80101822:	e8 13 ed ff ff       	call   8010053a <panic>

  ip = empty;
80101827:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010182a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  ip->dev = dev;
8010182d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101830:	8b 55 08             	mov    0x8(%ebp),%edx
80101833:	89 10                	mov    %edx,(%eax)
  ip->inum = inum;
80101835:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101838:	8b 55 0c             	mov    0xc(%ebp),%edx
8010183b:	89 50 04             	mov    %edx,0x4(%eax)
  ip->ref = 1;
8010183e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101841:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
  ip->flags = 0;
80101848:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010184b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  release(&icache.lock);
80101852:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101859:	e8 f7 3c 00 00       	call   80105555 <release>

  return ip;
8010185e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80101861:	c9                   	leave  
80101862:	c3                   	ret    

80101863 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101863:	55                   	push   %ebp
80101864:	89 e5                	mov    %esp,%ebp
80101866:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101869:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101870:	e8 79 3c 00 00       	call   801054ee <acquire>
  ip->ref++;
80101875:	8b 45 08             	mov    0x8(%ebp),%eax
80101878:	8b 40 08             	mov    0x8(%eax),%eax
8010187b:	8d 50 01             	lea    0x1(%eax),%edx
8010187e:	8b 45 08             	mov    0x8(%ebp),%eax
80101881:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101884:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
8010188b:	e8 c5 3c 00 00       	call   80105555 <release>
  return ip;
80101890:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101893:	c9                   	leave  
80101894:	c3                   	ret    

80101895 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101895:	55                   	push   %ebp
80101896:	89 e5                	mov    %esp,%ebp
80101898:	83 ec 28             	sub    $0x28,%esp
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
8010189b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010189f:	74 0a                	je     801018ab <ilock+0x16>
801018a1:	8b 45 08             	mov    0x8(%ebp),%eax
801018a4:	8b 40 08             	mov    0x8(%eax),%eax
801018a7:	85 c0                	test   %eax,%eax
801018a9:	7f 0c                	jg     801018b7 <ilock+0x22>
    panic("ilock");
801018ab:	c7 04 24 47 8e 10 80 	movl   $0x80108e47,(%esp)
801018b2:	e8 83 ec ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
801018b7:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018be:	e8 2b 3c 00 00       	call   801054ee <acquire>
  while(ip->flags & I_BUSY)
801018c3:	eb 13                	jmp    801018d8 <ilock+0x43>
    sleep(ip, &icache.lock);
801018c5:	c7 44 24 04 60 22 11 	movl   $0x80112260,0x4(%esp)
801018cc:	80 
801018cd:	8b 45 08             	mov    0x8(%ebp),%eax
801018d0:	89 04 24             	mov    %eax,(%esp)
801018d3:	e8 44 36 00 00       	call   80104f1c <sleep>

  if(ip == 0 || ip->ref < 1)
    panic("ilock");

  acquire(&icache.lock);
  while(ip->flags & I_BUSY)
801018d8:	8b 45 08             	mov    0x8(%ebp),%eax
801018db:	8b 40 0c             	mov    0xc(%eax),%eax
801018de:	83 e0 01             	and    $0x1,%eax
801018e1:	85 c0                	test   %eax,%eax
801018e3:	75 e0                	jne    801018c5 <ilock+0x30>
    sleep(ip, &icache.lock);
  ip->flags |= I_BUSY;
801018e5:	8b 45 08             	mov    0x8(%ebp),%eax
801018e8:	8b 40 0c             	mov    0xc(%eax),%eax
801018eb:	83 c8 01             	or     $0x1,%eax
801018ee:	89 c2                	mov    %eax,%edx
801018f0:	8b 45 08             	mov    0x8(%ebp),%eax
801018f3:	89 50 0c             	mov    %edx,0xc(%eax)
  release(&icache.lock);
801018f6:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
801018fd:	e8 53 3c 00 00       	call   80105555 <release>

  if(!(ip->flags & I_VALID)){
80101902:	8b 45 08             	mov    0x8(%ebp),%eax
80101905:	8b 40 0c             	mov    0xc(%eax),%eax
80101908:	83 e0 02             	and    $0x2,%eax
8010190b:	85 c0                	test   %eax,%eax
8010190d:	0f 85 ce 00 00 00    	jne    801019e1 <ilock+0x14c>
    bp = bread(ip->dev, IBLOCK(ip->inum));
80101913:	8b 45 08             	mov    0x8(%ebp),%eax
80101916:	8b 40 04             	mov    0x4(%eax),%eax
80101919:	c1 e8 03             	shr    $0x3,%eax
8010191c:	8d 50 02             	lea    0x2(%eax),%edx
8010191f:	8b 45 08             	mov    0x8(%ebp),%eax
80101922:	8b 00                	mov    (%eax),%eax
80101924:	89 54 24 04          	mov    %edx,0x4(%esp)
80101928:	89 04 24             	mov    %eax,(%esp)
8010192b:	e8 76 e8 ff ff       	call   801001a6 <bread>
80101930:	89 45 f4             	mov    %eax,-0xc(%ebp)
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101933:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101936:	8d 50 18             	lea    0x18(%eax),%edx
80101939:	8b 45 08             	mov    0x8(%ebp),%eax
8010193c:	8b 40 04             	mov    0x4(%eax),%eax
8010193f:	83 e0 07             	and    $0x7,%eax
80101942:	c1 e0 06             	shl    $0x6,%eax
80101945:	01 d0                	add    %edx,%eax
80101947:	89 45 f0             	mov    %eax,-0x10(%ebp)
    ip->type = dip->type;
8010194a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010194d:	0f b7 10             	movzwl (%eax),%edx
80101950:	8b 45 08             	mov    0x8(%ebp),%eax
80101953:	66 89 50 10          	mov    %dx,0x10(%eax)
    ip->major = dip->major;
80101957:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010195a:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010195e:	8b 45 08             	mov    0x8(%ebp),%eax
80101961:	66 89 50 12          	mov    %dx,0x12(%eax)
    ip->minor = dip->minor;
80101965:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101968:	0f b7 50 04          	movzwl 0x4(%eax),%edx
8010196c:	8b 45 08             	mov    0x8(%ebp),%eax
8010196f:	66 89 50 14          	mov    %dx,0x14(%eax)
    ip->nlink = dip->nlink;
80101973:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101976:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010197a:	8b 45 08             	mov    0x8(%ebp),%eax
8010197d:	66 89 50 16          	mov    %dx,0x16(%eax)
    ip->size = dip->size;
80101981:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101984:	8b 50 08             	mov    0x8(%eax),%edx
80101987:	8b 45 08             	mov    0x8(%ebp),%eax
8010198a:	89 50 18             	mov    %edx,0x18(%eax)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010198d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101990:	8d 50 0c             	lea    0xc(%eax),%edx
80101993:	8b 45 08             	mov    0x8(%ebp),%eax
80101996:	83 c0 1c             	add    $0x1c,%eax
80101999:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
801019a0:	00 
801019a1:	89 54 24 04          	mov    %edx,0x4(%esp)
801019a5:	89 04 24             	mov    %eax,(%esp)
801019a8:	e8 69 3e 00 00       	call   80105816 <memmove>
    brelse(bp);
801019ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801019b0:	89 04 24             	mov    %eax,(%esp)
801019b3:	e8 5f e8 ff ff       	call   80100217 <brelse>
    ip->flags |= I_VALID;
801019b8:	8b 45 08             	mov    0x8(%ebp),%eax
801019bb:	8b 40 0c             	mov    0xc(%eax),%eax
801019be:	83 c8 02             	or     $0x2,%eax
801019c1:	89 c2                	mov    %eax,%edx
801019c3:	8b 45 08             	mov    0x8(%ebp),%eax
801019c6:	89 50 0c             	mov    %edx,0xc(%eax)
    if(ip->type == 0)
801019c9:	8b 45 08             	mov    0x8(%ebp),%eax
801019cc:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801019d0:	66 85 c0             	test   %ax,%ax
801019d3:	75 0c                	jne    801019e1 <ilock+0x14c>
      panic("ilock: no type");
801019d5:	c7 04 24 4d 8e 10 80 	movl   $0x80108e4d,(%esp)
801019dc:	e8 59 eb ff ff       	call   8010053a <panic>
  }
}
801019e1:	c9                   	leave  
801019e2:	c3                   	ret    

801019e3 <iunlock>:

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801019e3:	55                   	push   %ebp
801019e4:	89 e5                	mov    %esp,%ebp
801019e6:	83 ec 18             	sub    $0x18,%esp
  if(ip == 0 || !(ip->flags & I_BUSY) || ip->ref < 1)
801019e9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801019ed:	74 17                	je     80101a06 <iunlock+0x23>
801019ef:	8b 45 08             	mov    0x8(%ebp),%eax
801019f2:	8b 40 0c             	mov    0xc(%eax),%eax
801019f5:	83 e0 01             	and    $0x1,%eax
801019f8:	85 c0                	test   %eax,%eax
801019fa:	74 0a                	je     80101a06 <iunlock+0x23>
801019fc:	8b 45 08             	mov    0x8(%ebp),%eax
801019ff:	8b 40 08             	mov    0x8(%eax),%eax
80101a02:	85 c0                	test   %eax,%eax
80101a04:	7f 0c                	jg     80101a12 <iunlock+0x2f>
    panic("iunlock");
80101a06:	c7 04 24 5c 8e 10 80 	movl   $0x80108e5c,(%esp)
80101a0d:	e8 28 eb ff ff       	call   8010053a <panic>

  acquire(&icache.lock);
80101a12:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a19:	e8 d0 3a 00 00       	call   801054ee <acquire>
  ip->flags &= ~I_BUSY;
80101a1e:	8b 45 08             	mov    0x8(%ebp),%eax
80101a21:	8b 40 0c             	mov    0xc(%eax),%eax
80101a24:	83 e0 fe             	and    $0xfffffffe,%eax
80101a27:	89 c2                	mov    %eax,%edx
80101a29:	8b 45 08             	mov    0x8(%ebp),%eax
80101a2c:	89 50 0c             	mov    %edx,0xc(%eax)
  wakeup(ip);
80101a2f:	8b 45 08             	mov    0x8(%ebp),%eax
80101a32:	89 04 24             	mov    %eax,(%esp)
80101a35:	e8 ce 35 00 00       	call   80105008 <wakeup>
  release(&icache.lock);
80101a3a:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a41:	e8 0f 3b 00 00       	call   80105555 <release>
}
80101a46:	c9                   	leave  
80101a47:	c3                   	ret    

80101a48 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
80101a48:	55                   	push   %ebp
80101a49:	89 e5                	mov    %esp,%ebp
80101a4b:	83 ec 18             	sub    $0x18,%esp
  acquire(&icache.lock);
80101a4e:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101a55:	e8 94 3a 00 00       	call   801054ee <acquire>
  if(ip->ref == 1 && (ip->flags & I_VALID) && ip->nlink == 0){
80101a5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5d:	8b 40 08             	mov    0x8(%eax),%eax
80101a60:	83 f8 01             	cmp    $0x1,%eax
80101a63:	0f 85 93 00 00 00    	jne    80101afc <iput+0xb4>
80101a69:	8b 45 08             	mov    0x8(%ebp),%eax
80101a6c:	8b 40 0c             	mov    0xc(%eax),%eax
80101a6f:	83 e0 02             	and    $0x2,%eax
80101a72:	85 c0                	test   %eax,%eax
80101a74:	0f 84 82 00 00 00    	je     80101afc <iput+0xb4>
80101a7a:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7d:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80101a81:	66 85 c0             	test   %ax,%ax
80101a84:	75 76                	jne    80101afc <iput+0xb4>
    // inode has no links and no other references: truncate and free.
    if(ip->flags & I_BUSY)
80101a86:	8b 45 08             	mov    0x8(%ebp),%eax
80101a89:	8b 40 0c             	mov    0xc(%eax),%eax
80101a8c:	83 e0 01             	and    $0x1,%eax
80101a8f:	85 c0                	test   %eax,%eax
80101a91:	74 0c                	je     80101a9f <iput+0x57>
      panic("iput busy");
80101a93:	c7 04 24 64 8e 10 80 	movl   $0x80108e64,(%esp)
80101a9a:	e8 9b ea ff ff       	call   8010053a <panic>
    ip->flags |= I_BUSY;
80101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101aa2:	8b 40 0c             	mov    0xc(%eax),%eax
80101aa5:	83 c8 01             	or     $0x1,%eax
80101aa8:	89 c2                	mov    %eax,%edx
80101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
80101aad:	89 50 0c             	mov    %edx,0xc(%eax)
    release(&icache.lock);
80101ab0:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101ab7:	e8 99 3a 00 00       	call   80105555 <release>
    itrunc(ip);
80101abc:	8b 45 08             	mov    0x8(%ebp),%eax
80101abf:	89 04 24             	mov    %eax,(%esp)
80101ac2:	e8 7d 01 00 00       	call   80101c44 <itrunc>
    ip->type = 0;
80101ac7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aca:	66 c7 40 10 00 00    	movw   $0x0,0x10(%eax)
    iupdate(ip);
80101ad0:	8b 45 08             	mov    0x8(%ebp),%eax
80101ad3:	89 04 24             	mov    %eax,(%esp)
80101ad6:	e8 fe fb ff ff       	call   801016d9 <iupdate>
    acquire(&icache.lock);
80101adb:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101ae2:	e8 07 3a 00 00       	call   801054ee <acquire>
    ip->flags = 0;
80101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
80101aea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    wakeup(ip);
80101af1:	8b 45 08             	mov    0x8(%ebp),%eax
80101af4:	89 04 24             	mov    %eax,(%esp)
80101af7:	e8 0c 35 00 00       	call   80105008 <wakeup>
  }
  ip->ref--;
80101afc:	8b 45 08             	mov    0x8(%ebp),%eax
80101aff:	8b 40 08             	mov    0x8(%eax),%eax
80101b02:	8d 50 ff             	lea    -0x1(%eax),%edx
80101b05:	8b 45 08             	mov    0x8(%ebp),%eax
80101b08:	89 50 08             	mov    %edx,0x8(%eax)
  release(&icache.lock);
80101b0b:	c7 04 24 60 22 11 80 	movl   $0x80112260,(%esp)
80101b12:	e8 3e 3a 00 00       	call   80105555 <release>
}
80101b17:	c9                   	leave  
80101b18:	c3                   	ret    

80101b19 <iunlockput>:

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101b19:	55                   	push   %ebp
80101b1a:	89 e5                	mov    %esp,%ebp
80101b1c:	83 ec 18             	sub    $0x18,%esp
  iunlock(ip);
80101b1f:	8b 45 08             	mov    0x8(%ebp),%eax
80101b22:	89 04 24             	mov    %eax,(%esp)
80101b25:	e8 b9 fe ff ff       	call   801019e3 <iunlock>
  iput(ip);
80101b2a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b2d:	89 04 24             	mov    %eax,(%esp)
80101b30:	e8 13 ff ff ff       	call   80101a48 <iput>
}
80101b35:	c9                   	leave  
80101b36:	c3                   	ret    

80101b37 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101b37:	55                   	push   %ebp
80101b38:	89 e5                	mov    %esp,%ebp
80101b3a:	53                   	push   %ebx
80101b3b:	83 ec 24             	sub    $0x24,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
80101b3e:	83 7d 0c 0b          	cmpl   $0xb,0xc(%ebp)
80101b42:	77 3e                	ja     80101b82 <bmap+0x4b>
    if((addr = ip->addrs[bn]) == 0)
80101b44:	8b 45 08             	mov    0x8(%ebp),%eax
80101b47:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b4a:	83 c2 04             	add    $0x4,%edx
80101b4d:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101b51:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b54:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b58:	75 20                	jne    80101b7a <bmap+0x43>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b5d:	8b 00                	mov    (%eax),%eax
80101b5f:	89 04 24             	mov    %eax,(%esp)
80101b62:	e8 5b f8 ff ff       	call   801013c2 <balloc>
80101b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
80101b6d:	8b 55 0c             	mov    0xc(%ebp),%edx
80101b70:	8d 4a 04             	lea    0x4(%edx),%ecx
80101b73:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101b76:	89 54 88 0c          	mov    %edx,0xc(%eax,%ecx,4)
    return addr;
80101b7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101b7d:	e9 bc 00 00 00       	jmp    80101c3e <bmap+0x107>
  }
  bn -= NDIRECT;
80101b82:	83 6d 0c 0c          	subl   $0xc,0xc(%ebp)

  if(bn < NINDIRECT){
80101b86:	83 7d 0c 7f          	cmpl   $0x7f,0xc(%ebp)
80101b8a:	0f 87 a2 00 00 00    	ja     80101c32 <bmap+0xfb>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101b90:	8b 45 08             	mov    0x8(%ebp),%eax
80101b93:	8b 40 4c             	mov    0x4c(%eax),%eax
80101b96:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101b99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101b9d:	75 19                	jne    80101bb8 <bmap+0x81>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101b9f:	8b 45 08             	mov    0x8(%ebp),%eax
80101ba2:	8b 00                	mov    (%eax),%eax
80101ba4:	89 04 24             	mov    %eax,(%esp)
80101ba7:	e8 16 f8 ff ff       	call   801013c2 <balloc>
80101bac:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101baf:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bb5:	89 50 4c             	mov    %edx,0x4c(%eax)
    bp = bread(ip->dev, addr);
80101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
80101bbb:	8b 00                	mov    (%eax),%eax
80101bbd:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101bc0:	89 54 24 04          	mov    %edx,0x4(%esp)
80101bc4:	89 04 24             	mov    %eax,(%esp)
80101bc7:	e8 da e5 ff ff       	call   801001a6 <bread>
80101bcc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    a = (uint*)bp->data;
80101bcf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101bd2:	83 c0 18             	add    $0x18,%eax
80101bd5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if((addr = a[bn]) == 0){
80101bd8:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bdb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101be5:	01 d0                	add    %edx,%eax
80101be7:	8b 00                	mov    (%eax),%eax
80101be9:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101bec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80101bf0:	75 30                	jne    80101c22 <bmap+0xeb>
      a[bn] = addr = balloc(ip->dev);
80101bf2:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bf5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101bff:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80101c02:	8b 45 08             	mov    0x8(%ebp),%eax
80101c05:	8b 00                	mov    (%eax),%eax
80101c07:	89 04 24             	mov    %eax,(%esp)
80101c0a:	e8 b3 f7 ff ff       	call   801013c2 <balloc>
80101c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80101c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c15:	89 03                	mov    %eax,(%ebx)
      log_write(bp);
80101c17:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c1a:	89 04 24             	mov    %eax,(%esp)
80101c1d:	e8 33 1a 00 00       	call   80103655 <log_write>
    }
    brelse(bp);
80101c22:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101c25:	89 04 24             	mov    %eax,(%esp)
80101c28:	e8 ea e5 ff ff       	call   80100217 <brelse>
    return addr;
80101c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101c30:	eb 0c                	jmp    80101c3e <bmap+0x107>
  }

  panic("bmap: out of range");
80101c32:	c7 04 24 6e 8e 10 80 	movl   $0x80108e6e,(%esp)
80101c39:	e8 fc e8 ff ff       	call   8010053a <panic>
}
80101c3e:	83 c4 24             	add    $0x24,%esp
80101c41:	5b                   	pop    %ebx
80101c42:	5d                   	pop    %ebp
80101c43:	c3                   	ret    

80101c44 <itrunc>:
// to it (no directory entries referring to it)
// and has no in-memory reference to it (is
// not an open file or current directory).
static void
itrunc(struct inode *ip)
{
80101c44:	55                   	push   %ebp
80101c45:	89 e5                	mov    %esp,%ebp
80101c47:	83 ec 28             	sub    $0x28,%esp
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101c51:	eb 44                	jmp    80101c97 <itrunc+0x53>
    if(ip->addrs[i]){
80101c53:	8b 45 08             	mov    0x8(%ebp),%eax
80101c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c59:	83 c2 04             	add    $0x4,%edx
80101c5c:	8b 44 90 0c          	mov    0xc(%eax,%edx,4),%eax
80101c60:	85 c0                	test   %eax,%eax
80101c62:	74 2f                	je     80101c93 <itrunc+0x4f>
      bfree(ip->dev, ip->addrs[i]);
80101c64:	8b 45 08             	mov    0x8(%ebp),%eax
80101c67:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c6a:	83 c2 04             	add    $0x4,%edx
80101c6d:	8b 54 90 0c          	mov    0xc(%eax,%edx,4),%edx
80101c71:	8b 45 08             	mov    0x8(%ebp),%eax
80101c74:	8b 00                	mov    (%eax),%eax
80101c76:	89 54 24 04          	mov    %edx,0x4(%esp)
80101c7a:	89 04 24             	mov    %eax,(%esp)
80101c7d:	e8 8e f8 ff ff       	call   80101510 <bfree>
      ip->addrs[i] = 0;
80101c82:	8b 45 08             	mov    0x8(%ebp),%eax
80101c85:	8b 55 f4             	mov    -0xc(%ebp),%edx
80101c88:	83 c2 04             	add    $0x4,%edx
80101c8b:	c7 44 90 0c 00 00 00 	movl   $0x0,0xc(%eax,%edx,4)
80101c92:	00 
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101c93:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80101c97:	83 7d f4 0b          	cmpl   $0xb,-0xc(%ebp)
80101c9b:	7e b6                	jle    80101c53 <itrunc+0xf>
      bfree(ip->dev, ip->addrs[i]);
      ip->addrs[i] = 0;
    }
  }
  
  if(ip->addrs[NDIRECT]){
80101c9d:	8b 45 08             	mov    0x8(%ebp),%eax
80101ca0:	8b 40 4c             	mov    0x4c(%eax),%eax
80101ca3:	85 c0                	test   %eax,%eax
80101ca5:	0f 84 9b 00 00 00    	je     80101d46 <itrunc+0x102>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101cab:	8b 45 08             	mov    0x8(%ebp),%eax
80101cae:	8b 50 4c             	mov    0x4c(%eax),%edx
80101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80101cb4:	8b 00                	mov    (%eax),%eax
80101cb6:	89 54 24 04          	mov    %edx,0x4(%esp)
80101cba:	89 04 24             	mov    %eax,(%esp)
80101cbd:	e8 e4 e4 ff ff       	call   801001a6 <bread>
80101cc2:	89 45 ec             	mov    %eax,-0x14(%ebp)
    a = (uint*)bp->data;
80101cc5:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101cc8:	83 c0 18             	add    $0x18,%eax
80101ccb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101cce:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80101cd5:	eb 3b                	jmp    80101d12 <itrunc+0xce>
      if(a[j])
80101cd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cda:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101ce1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101ce4:	01 d0                	add    %edx,%eax
80101ce6:	8b 00                	mov    (%eax),%eax
80101ce8:	85 c0                	test   %eax,%eax
80101cea:	74 22                	je     80101d0e <itrunc+0xca>
        bfree(ip->dev, a[j]);
80101cec:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101cef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80101cf6:	8b 45 e8             	mov    -0x18(%ebp),%eax
80101cf9:	01 d0                	add    %edx,%eax
80101cfb:	8b 10                	mov    (%eax),%edx
80101cfd:	8b 45 08             	mov    0x8(%ebp),%eax
80101d00:	8b 00                	mov    (%eax),%eax
80101d02:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d06:	89 04 24             	mov    %eax,(%esp)
80101d09:	e8 02 f8 ff ff       	call   80101510 <bfree>
  }
  
  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
80101d0e:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
80101d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101d15:	83 f8 7f             	cmp    $0x7f,%eax
80101d18:	76 bd                	jbe    80101cd7 <itrunc+0x93>
      if(a[j])
        bfree(ip->dev, a[j]);
    }
    brelse(bp);
80101d1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101d1d:	89 04 24             	mov    %eax,(%esp)
80101d20:	e8 f2 e4 ff ff       	call   80100217 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101d25:	8b 45 08             	mov    0x8(%ebp),%eax
80101d28:	8b 50 4c             	mov    0x4c(%eax),%edx
80101d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80101d2e:	8b 00                	mov    (%eax),%eax
80101d30:	89 54 24 04          	mov    %edx,0x4(%esp)
80101d34:	89 04 24             	mov    %eax,(%esp)
80101d37:	e8 d4 f7 ff ff       	call   80101510 <bfree>
    ip->addrs[NDIRECT] = 0;
80101d3c:	8b 45 08             	mov    0x8(%ebp),%eax
80101d3f:	c7 40 4c 00 00 00 00 	movl   $0x0,0x4c(%eax)
  }

  ip->size = 0;
80101d46:	8b 45 08             	mov    0x8(%ebp),%eax
80101d49:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
  iupdate(ip);
80101d50:	8b 45 08             	mov    0x8(%ebp),%eax
80101d53:	89 04 24             	mov    %eax,(%esp)
80101d56:	e8 7e f9 ff ff       	call   801016d9 <iupdate>
}
80101d5b:	c9                   	leave  
80101d5c:	c3                   	ret    

80101d5d <stati>:

// Copy stat information from inode.
void
stati(struct inode *ip, struct stat *st)
{
80101d5d:	55                   	push   %ebp
80101d5e:	89 e5                	mov    %esp,%ebp
  st->dev = ip->dev;
80101d60:	8b 45 08             	mov    0x8(%ebp),%eax
80101d63:	8b 00                	mov    (%eax),%eax
80101d65:	89 c2                	mov    %eax,%edx
80101d67:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d6a:	89 50 04             	mov    %edx,0x4(%eax)
  st->ino = ip->inum;
80101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
80101d70:	8b 50 04             	mov    0x4(%eax),%edx
80101d73:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d76:	89 50 08             	mov    %edx,0x8(%eax)
  st->type = ip->type;
80101d79:	8b 45 08             	mov    0x8(%ebp),%eax
80101d7c:	0f b7 50 10          	movzwl 0x10(%eax),%edx
80101d80:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d83:	66 89 10             	mov    %dx,(%eax)
  st->nlink = ip->nlink;
80101d86:	8b 45 08             	mov    0x8(%ebp),%eax
80101d89:	0f b7 50 16          	movzwl 0x16(%eax),%edx
80101d8d:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d90:	66 89 50 0c          	mov    %dx,0xc(%eax)
  st->size = ip->size;
80101d94:	8b 45 08             	mov    0x8(%ebp),%eax
80101d97:	8b 50 18             	mov    0x18(%eax),%edx
80101d9a:	8b 45 0c             	mov    0xc(%ebp),%eax
80101d9d:	89 50 10             	mov    %edx,0x10(%eax)
}
80101da0:	5d                   	pop    %ebp
80101da1:	c3                   	ret    

80101da2 <readi>:

//PAGEBREAK!
// Read data from inode.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101da2:	55                   	push   %ebp
80101da3:	89 e5                	mov    %esp,%ebp
80101da5:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101da8:	8b 45 08             	mov    0x8(%ebp),%eax
80101dab:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101daf:	66 83 f8 03          	cmp    $0x3,%ax
80101db3:	75 60                	jne    80101e15 <readi+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101db5:	8b 45 08             	mov    0x8(%ebp),%eax
80101db8:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dbc:	66 85 c0             	test   %ax,%ax
80101dbf:	78 20                	js     80101de1 <readi+0x3f>
80101dc1:	8b 45 08             	mov    0x8(%ebp),%eax
80101dc4:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dc8:	66 83 f8 09          	cmp    $0x9,%ax
80101dcc:	7f 13                	jg     80101de1 <readi+0x3f>
80101dce:	8b 45 08             	mov    0x8(%ebp),%eax
80101dd1:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101dd5:	98                   	cwtl   
80101dd6:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101ddd:	85 c0                	test   %eax,%eax
80101ddf:	75 0a                	jne    80101deb <readi+0x49>
      return -1;
80101de1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101de6:	e9 19 01 00 00       	jmp    80101f04 <readi+0x162>
    return devsw[ip->major].read(ip, dst, n);
80101deb:	8b 45 08             	mov    0x8(%ebp),%eax
80101dee:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101df2:	98                   	cwtl   
80101df3:	8b 04 c5 00 22 11 80 	mov    -0x7feede00(,%eax,8),%eax
80101dfa:	8b 55 14             	mov    0x14(%ebp),%edx
80101dfd:	89 54 24 08          	mov    %edx,0x8(%esp)
80101e01:	8b 55 0c             	mov    0xc(%ebp),%edx
80101e04:	89 54 24 04          	mov    %edx,0x4(%esp)
80101e08:	8b 55 08             	mov    0x8(%ebp),%edx
80101e0b:	89 14 24             	mov    %edx,(%esp)
80101e0e:	ff d0                	call   *%eax
80101e10:	e9 ef 00 00 00       	jmp    80101f04 <readi+0x162>
  }

  if(off > ip->size || off + n < off)
80101e15:	8b 45 08             	mov    0x8(%ebp),%eax
80101e18:	8b 40 18             	mov    0x18(%eax),%eax
80101e1b:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e1e:	72 0d                	jb     80101e2d <readi+0x8b>
80101e20:	8b 45 14             	mov    0x14(%ebp),%eax
80101e23:	8b 55 10             	mov    0x10(%ebp),%edx
80101e26:	01 d0                	add    %edx,%eax
80101e28:	3b 45 10             	cmp    0x10(%ebp),%eax
80101e2b:	73 0a                	jae    80101e37 <readi+0x95>
    return -1;
80101e2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e32:	e9 cd 00 00 00       	jmp    80101f04 <readi+0x162>
  if(off + n > ip->size)
80101e37:	8b 45 14             	mov    0x14(%ebp),%eax
80101e3a:	8b 55 10             	mov    0x10(%ebp),%edx
80101e3d:	01 c2                	add    %eax,%edx
80101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
80101e42:	8b 40 18             	mov    0x18(%eax),%eax
80101e45:	39 c2                	cmp    %eax,%edx
80101e47:	76 0c                	jbe    80101e55 <readi+0xb3>
    n = ip->size - off;
80101e49:	8b 45 08             	mov    0x8(%ebp),%eax
80101e4c:	8b 40 18             	mov    0x18(%eax),%eax
80101e4f:	2b 45 10             	sub    0x10(%ebp),%eax
80101e52:	89 45 14             	mov    %eax,0x14(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101e55:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101e5c:	e9 94 00 00 00       	jmp    80101ef5 <readi+0x153>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101e61:	8b 45 10             	mov    0x10(%ebp),%eax
80101e64:	c1 e8 09             	shr    $0x9,%eax
80101e67:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80101e6e:	89 04 24             	mov    %eax,(%esp)
80101e71:	e8 c1 fc ff ff       	call   80101b37 <bmap>
80101e76:	8b 55 08             	mov    0x8(%ebp),%edx
80101e79:	8b 12                	mov    (%edx),%edx
80101e7b:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e7f:	89 14 24             	mov    %edx,(%esp)
80101e82:	e8 1f e3 ff ff       	call   801001a6 <bread>
80101e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101e8a:	8b 45 10             	mov    0x10(%ebp),%eax
80101e8d:	25 ff 01 00 00       	and    $0x1ff,%eax
80101e92:	89 c2                	mov    %eax,%edx
80101e94:	b8 00 02 00 00       	mov    $0x200,%eax
80101e99:	29 d0                	sub    %edx,%eax
80101e9b:	89 c2                	mov    %eax,%edx
80101e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ea0:	8b 4d 14             	mov    0x14(%ebp),%ecx
80101ea3:	29 c1                	sub    %eax,%ecx
80101ea5:	89 c8                	mov    %ecx,%eax
80101ea7:	39 c2                	cmp    %eax,%edx
80101ea9:	0f 46 c2             	cmovbe %edx,%eax
80101eac:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dst, bp->data + off%BSIZE, m);
80101eaf:	8b 45 10             	mov    0x10(%ebp),%eax
80101eb2:	25 ff 01 00 00       	and    $0x1ff,%eax
80101eb7:	8d 50 10             	lea    0x10(%eax),%edx
80101eba:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101ebd:	01 d0                	add    %edx,%eax
80101ebf:	8d 50 08             	lea    0x8(%eax),%edx
80101ec2:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ec5:	89 44 24 08          	mov    %eax,0x8(%esp)
80101ec9:	89 54 24 04          	mov    %edx,0x4(%esp)
80101ecd:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ed0:	89 04 24             	mov    %eax,(%esp)
80101ed3:	e8 3e 39 00 00       	call   80105816 <memmove>
    brelse(bp);
80101ed8:	8b 45 f0             	mov    -0x10(%ebp),%eax
80101edb:	89 04 24             	mov    %eax,(%esp)
80101ede:	e8 34 e3 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101ee3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ee6:	01 45 f4             	add    %eax,-0xc(%ebp)
80101ee9:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101eec:	01 45 10             	add    %eax,0x10(%ebp)
80101eef:	8b 45 ec             	mov    -0x14(%ebp),%eax
80101ef2:	01 45 0c             	add    %eax,0xc(%ebp)
80101ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101ef8:	3b 45 14             	cmp    0x14(%ebp),%eax
80101efb:	0f 82 60 ff ff ff    	jb     80101e61 <readi+0xbf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101f01:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101f04:	c9                   	leave  
80101f05:	c3                   	ret    

80101f06 <writei>:

// PAGEBREAK!
// Write data to inode.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101f06:	55                   	push   %ebp
80101f07:	89 e5                	mov    %esp,%ebp
80101f09:	83 ec 28             	sub    $0x28,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101f0c:	8b 45 08             	mov    0x8(%ebp),%eax
80101f0f:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80101f13:	66 83 f8 03          	cmp    $0x3,%ax
80101f17:	75 60                	jne    80101f79 <writei+0x73>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101f19:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1c:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f20:	66 85 c0             	test   %ax,%ax
80101f23:	78 20                	js     80101f45 <writei+0x3f>
80101f25:	8b 45 08             	mov    0x8(%ebp),%eax
80101f28:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f2c:	66 83 f8 09          	cmp    $0x9,%ax
80101f30:	7f 13                	jg     80101f45 <writei+0x3f>
80101f32:	8b 45 08             	mov    0x8(%ebp),%eax
80101f35:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f39:	98                   	cwtl   
80101f3a:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80101f41:	85 c0                	test   %eax,%eax
80101f43:	75 0a                	jne    80101f4f <writei+0x49>
      return -1;
80101f45:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f4a:	e9 44 01 00 00       	jmp    80102093 <writei+0x18d>
    return devsw[ip->major].write(ip, src, n);
80101f4f:	8b 45 08             	mov    0x8(%ebp),%eax
80101f52:	0f b7 40 12          	movzwl 0x12(%eax),%eax
80101f56:	98                   	cwtl   
80101f57:	8b 04 c5 04 22 11 80 	mov    -0x7feeddfc(,%eax,8),%eax
80101f5e:	8b 55 14             	mov    0x14(%ebp),%edx
80101f61:	89 54 24 08          	mov    %edx,0x8(%esp)
80101f65:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f68:	89 54 24 04          	mov    %edx,0x4(%esp)
80101f6c:	8b 55 08             	mov    0x8(%ebp),%edx
80101f6f:	89 14 24             	mov    %edx,(%esp)
80101f72:	ff d0                	call   *%eax
80101f74:	e9 1a 01 00 00       	jmp    80102093 <writei+0x18d>
  }

  if(off > ip->size || off + n < off)
80101f79:	8b 45 08             	mov    0x8(%ebp),%eax
80101f7c:	8b 40 18             	mov    0x18(%eax),%eax
80101f7f:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f82:	72 0d                	jb     80101f91 <writei+0x8b>
80101f84:	8b 45 14             	mov    0x14(%ebp),%eax
80101f87:	8b 55 10             	mov    0x10(%ebp),%edx
80101f8a:	01 d0                	add    %edx,%eax
80101f8c:	3b 45 10             	cmp    0x10(%ebp),%eax
80101f8f:	73 0a                	jae    80101f9b <writei+0x95>
    return -1;
80101f91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f96:	e9 f8 00 00 00       	jmp    80102093 <writei+0x18d>
  if(off + n > MAXFILE*BSIZE)
80101f9b:	8b 45 14             	mov    0x14(%ebp),%eax
80101f9e:	8b 55 10             	mov    0x10(%ebp),%edx
80101fa1:	01 d0                	add    %edx,%eax
80101fa3:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101fa8:	76 0a                	jbe    80101fb4 <writei+0xae>
    return -1;
80101faa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101faf:	e9 df 00 00 00       	jmp    80102093 <writei+0x18d>

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101fb4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80101fbb:	e9 9f 00 00 00       	jmp    8010205f <writei+0x159>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101fc0:	8b 45 10             	mov    0x10(%ebp),%eax
80101fc3:	c1 e8 09             	shr    $0x9,%eax
80101fc6:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fca:	8b 45 08             	mov    0x8(%ebp),%eax
80101fcd:	89 04 24             	mov    %eax,(%esp)
80101fd0:	e8 62 fb ff ff       	call   80101b37 <bmap>
80101fd5:	8b 55 08             	mov    0x8(%ebp),%edx
80101fd8:	8b 12                	mov    (%edx),%edx
80101fda:	89 44 24 04          	mov    %eax,0x4(%esp)
80101fde:	89 14 24             	mov    %edx,(%esp)
80101fe1:	e8 c0 e1 ff ff       	call   801001a6 <bread>
80101fe6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101fe9:	8b 45 10             	mov    0x10(%ebp),%eax
80101fec:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ff1:	89 c2                	mov    %eax,%edx
80101ff3:	b8 00 02 00 00       	mov    $0x200,%eax
80101ff8:	29 d0                	sub    %edx,%eax
80101ffa:	89 c2                	mov    %eax,%edx
80101ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80101fff:	8b 4d 14             	mov    0x14(%ebp),%ecx
80102002:	29 c1                	sub    %eax,%ecx
80102004:	89 c8                	mov    %ecx,%eax
80102006:	39 c2                	cmp    %eax,%edx
80102008:	0f 46 c2             	cmovbe %edx,%eax
8010200b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(bp->data + off%BSIZE, src, m);
8010200e:	8b 45 10             	mov    0x10(%ebp),%eax
80102011:	25 ff 01 00 00       	and    $0x1ff,%eax
80102016:	8d 50 10             	lea    0x10(%eax),%edx
80102019:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010201c:	01 d0                	add    %edx,%eax
8010201e:	8d 50 08             	lea    0x8(%eax),%edx
80102021:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102024:	89 44 24 08          	mov    %eax,0x8(%esp)
80102028:	8b 45 0c             	mov    0xc(%ebp),%eax
8010202b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010202f:	89 14 24             	mov    %edx,(%esp)
80102032:	e8 df 37 00 00       	call   80105816 <memmove>
    log_write(bp);
80102037:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010203a:	89 04 24             	mov    %eax,(%esp)
8010203d:	e8 13 16 00 00       	call   80103655 <log_write>
    brelse(bp);
80102042:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102045:	89 04 24             	mov    %eax,(%esp)
80102048:	e8 ca e1 ff ff       	call   80100217 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010204d:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102050:	01 45 f4             	add    %eax,-0xc(%ebp)
80102053:	8b 45 ec             	mov    -0x14(%ebp),%eax
80102056:	01 45 10             	add    %eax,0x10(%ebp)
80102059:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010205c:	01 45 0c             	add    %eax,0xc(%ebp)
8010205f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102062:	3b 45 14             	cmp    0x14(%ebp),%eax
80102065:	0f 82 55 ff ff ff    	jb     80101fc0 <writei+0xba>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
8010206b:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
8010206f:	74 1f                	je     80102090 <writei+0x18a>
80102071:	8b 45 08             	mov    0x8(%ebp),%eax
80102074:	8b 40 18             	mov    0x18(%eax),%eax
80102077:	3b 45 10             	cmp    0x10(%ebp),%eax
8010207a:	73 14                	jae    80102090 <writei+0x18a>
    ip->size = off;
8010207c:	8b 45 08             	mov    0x8(%ebp),%eax
8010207f:	8b 55 10             	mov    0x10(%ebp),%edx
80102082:	89 50 18             	mov    %edx,0x18(%eax)
    iupdate(ip);
80102085:	8b 45 08             	mov    0x8(%ebp),%eax
80102088:	89 04 24             	mov    %eax,(%esp)
8010208b:	e8 49 f6 ff ff       	call   801016d9 <iupdate>
  }
  return n;
80102090:	8b 45 14             	mov    0x14(%ebp),%eax
}
80102093:	c9                   	leave  
80102094:	c3                   	ret    

80102095 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80102095:	55                   	push   %ebp
80102096:	89 e5                	mov    %esp,%ebp
80102098:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
8010209b:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801020a2:	00 
801020a3:	8b 45 0c             	mov    0xc(%ebp),%eax
801020a6:	89 44 24 04          	mov    %eax,0x4(%esp)
801020aa:	8b 45 08             	mov    0x8(%ebp),%eax
801020ad:	89 04 24             	mov    %eax,(%esp)
801020b0:	e8 04 38 00 00       	call   801058b9 <strncmp>
}
801020b5:	c9                   	leave  
801020b6:	c3                   	ret    

801020b7 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
801020b7:	55                   	push   %ebp
801020b8:	89 e5                	mov    %esp,%ebp
801020ba:	83 ec 38             	sub    $0x38,%esp
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
801020bd:	8b 45 08             	mov    0x8(%ebp),%eax
801020c0:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801020c4:	66 83 f8 01          	cmp    $0x1,%ax
801020c8:	74 0c                	je     801020d6 <dirlookup+0x1f>
    panic("dirlookup not DIR");
801020ca:	c7 04 24 81 8e 10 80 	movl   $0x80108e81,(%esp)
801020d1:	e8 64 e4 ff ff       	call   8010053a <panic>

  for(off = 0; off < dp->size; off += sizeof(de)){
801020d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801020dd:	e9 88 00 00 00       	jmp    8010216a <dirlookup+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020e2:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801020e9:	00 
801020ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801020ed:	89 44 24 08          	mov    %eax,0x8(%esp)
801020f1:	8d 45 e0             	lea    -0x20(%ebp),%eax
801020f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801020f8:	8b 45 08             	mov    0x8(%ebp),%eax
801020fb:	89 04 24             	mov    %eax,(%esp)
801020fe:	e8 9f fc ff ff       	call   80101da2 <readi>
80102103:	83 f8 10             	cmp    $0x10,%eax
80102106:	74 0c                	je     80102114 <dirlookup+0x5d>
      panic("dirlink read");
80102108:	c7 04 24 93 8e 10 80 	movl   $0x80108e93,(%esp)
8010210f:	e8 26 e4 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
80102114:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
80102118:	66 85 c0             	test   %ax,%ax
8010211b:	75 02                	jne    8010211f <dirlookup+0x68>
      continue;
8010211d:	eb 47                	jmp    80102166 <dirlookup+0xaf>
    if(namecmp(name, de.name) == 0){
8010211f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102122:	83 c0 02             	add    $0x2,%eax
80102125:	89 44 24 04          	mov    %eax,0x4(%esp)
80102129:	8b 45 0c             	mov    0xc(%ebp),%eax
8010212c:	89 04 24             	mov    %eax,(%esp)
8010212f:	e8 61 ff ff ff       	call   80102095 <namecmp>
80102134:	85 c0                	test   %eax,%eax
80102136:	75 2e                	jne    80102166 <dirlookup+0xaf>
      // entry matches path element
      if(poff)
80102138:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
8010213c:	74 08                	je     80102146 <dirlookup+0x8f>
        *poff = off;
8010213e:	8b 45 10             	mov    0x10(%ebp),%eax
80102141:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102144:	89 10                	mov    %edx,(%eax)
      inum = de.inum;
80102146:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010214a:	0f b7 c0             	movzwl %ax,%eax
8010214d:	89 45 f0             	mov    %eax,-0x10(%ebp)
      return iget(dp->dev, inum);
80102150:	8b 45 08             	mov    0x8(%ebp),%eax
80102153:	8b 00                	mov    (%eax),%eax
80102155:	8b 55 f0             	mov    -0x10(%ebp),%edx
80102158:	89 54 24 04          	mov    %edx,0x4(%esp)
8010215c:	89 04 24             	mov    %eax,(%esp)
8010215f:	e8 2d f6 ff ff       	call   80101791 <iget>
80102164:	eb 18                	jmp    8010217e <dirlookup+0xc7>
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80102166:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010216a:	8b 45 08             	mov    0x8(%ebp),%eax
8010216d:	8b 40 18             	mov    0x18(%eax),%eax
80102170:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80102173:	0f 87 69 ff ff ff    	ja     801020e2 <dirlookup+0x2b>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80102179:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010217e:	c9                   	leave  
8010217f:	c3                   	ret    

80102180 <dirlink>:

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80102180:	55                   	push   %ebp
80102181:	89 e5                	mov    %esp,%ebp
80102183:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80102186:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010218d:	00 
8010218e:	8b 45 0c             	mov    0xc(%ebp),%eax
80102191:	89 44 24 04          	mov    %eax,0x4(%esp)
80102195:	8b 45 08             	mov    0x8(%ebp),%eax
80102198:	89 04 24             	mov    %eax,(%esp)
8010219b:	e8 17 ff ff ff       	call   801020b7 <dirlookup>
801021a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801021a3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801021a7:	74 15                	je     801021be <dirlink+0x3e>
    iput(ip);
801021a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801021ac:	89 04 24             	mov    %eax,(%esp)
801021af:	e8 94 f8 ff ff       	call   80101a48 <iput>
    return -1;
801021b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801021b9:	e9 b7 00 00 00       	jmp    80102275 <dirlink+0xf5>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
801021be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801021c5:	eb 46                	jmp    8010220d <dirlink+0x8d>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801021c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801021ca:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801021d1:	00 
801021d2:	89 44 24 08          	mov    %eax,0x8(%esp)
801021d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801021d9:	89 44 24 04          	mov    %eax,0x4(%esp)
801021dd:	8b 45 08             	mov    0x8(%ebp),%eax
801021e0:	89 04 24             	mov    %eax,(%esp)
801021e3:	e8 ba fb ff ff       	call   80101da2 <readi>
801021e8:	83 f8 10             	cmp    $0x10,%eax
801021eb:	74 0c                	je     801021f9 <dirlink+0x79>
      panic("dirlink read");
801021ed:	c7 04 24 93 8e 10 80 	movl   $0x80108e93,(%esp)
801021f4:	e8 41 e3 ff ff       	call   8010053a <panic>
    if(de.inum == 0)
801021f9:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
801021fd:	66 85 c0             	test   %ax,%ax
80102200:	75 02                	jne    80102204 <dirlink+0x84>
      break;
80102202:	eb 16                	jmp    8010221a <dirlink+0x9a>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80102204:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102207:	83 c0 10             	add    $0x10,%eax
8010220a:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010220d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80102210:	8b 45 08             	mov    0x8(%ebp),%eax
80102213:	8b 40 18             	mov    0x18(%eax),%eax
80102216:	39 c2                	cmp    %eax,%edx
80102218:	72 ad                	jb     801021c7 <dirlink+0x47>
      panic("dirlink read");
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
8010221a:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80102221:	00 
80102222:	8b 45 0c             	mov    0xc(%ebp),%eax
80102225:	89 44 24 04          	mov    %eax,0x4(%esp)
80102229:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010222c:	83 c0 02             	add    $0x2,%eax
8010222f:	89 04 24             	mov    %eax,(%esp)
80102232:	e8 d8 36 00 00       	call   8010590f <strncpy>
  de.inum = inum;
80102237:	8b 45 10             	mov    0x10(%ebp),%eax
8010223a:	66 89 45 e0          	mov    %ax,-0x20(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010223e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102241:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80102248:	00 
80102249:	89 44 24 08          	mov    %eax,0x8(%esp)
8010224d:	8d 45 e0             	lea    -0x20(%ebp),%eax
80102250:	89 44 24 04          	mov    %eax,0x4(%esp)
80102254:	8b 45 08             	mov    0x8(%ebp),%eax
80102257:	89 04 24             	mov    %eax,(%esp)
8010225a:	e8 a7 fc ff ff       	call   80101f06 <writei>
8010225f:	83 f8 10             	cmp    $0x10,%eax
80102262:	74 0c                	je     80102270 <dirlink+0xf0>
    panic("dirlink");
80102264:	c7 04 24 a0 8e 10 80 	movl   $0x80108ea0,(%esp)
8010226b:	e8 ca e2 ff ff       	call   8010053a <panic>
  
  return 0;
80102270:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102275:	c9                   	leave  
80102276:	c3                   	ret    

80102277 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80102277:	55                   	push   %ebp
80102278:	89 e5                	mov    %esp,%ebp
8010227a:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int len;

  while(*path == '/')
8010227d:	eb 04                	jmp    80102283 <skipelem+0xc>
    path++;
8010227f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80102283:	8b 45 08             	mov    0x8(%ebp),%eax
80102286:	0f b6 00             	movzbl (%eax),%eax
80102289:	3c 2f                	cmp    $0x2f,%al
8010228b:	74 f2                	je     8010227f <skipelem+0x8>
    path++;
  if(*path == 0)
8010228d:	8b 45 08             	mov    0x8(%ebp),%eax
80102290:	0f b6 00             	movzbl (%eax),%eax
80102293:	84 c0                	test   %al,%al
80102295:	75 0a                	jne    801022a1 <skipelem+0x2a>
    return 0;
80102297:	b8 00 00 00 00       	mov    $0x0,%eax
8010229c:	e9 86 00 00 00       	jmp    80102327 <skipelem+0xb0>
  s = path;
801022a1:	8b 45 08             	mov    0x8(%ebp),%eax
801022a4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(*path != '/' && *path != 0)
801022a7:	eb 04                	jmp    801022ad <skipelem+0x36>
    path++;
801022a9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
801022ad:	8b 45 08             	mov    0x8(%ebp),%eax
801022b0:	0f b6 00             	movzbl (%eax),%eax
801022b3:	3c 2f                	cmp    $0x2f,%al
801022b5:	74 0a                	je     801022c1 <skipelem+0x4a>
801022b7:	8b 45 08             	mov    0x8(%ebp),%eax
801022ba:	0f b6 00             	movzbl (%eax),%eax
801022bd:	84 c0                	test   %al,%al
801022bf:	75 e8                	jne    801022a9 <skipelem+0x32>
    path++;
  len = path - s;
801022c1:	8b 55 08             	mov    0x8(%ebp),%edx
801022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022c7:	29 c2                	sub    %eax,%edx
801022c9:	89 d0                	mov    %edx,%eax
801022cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(len >= DIRSIZ)
801022ce:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
801022d2:	7e 1c                	jle    801022f0 <skipelem+0x79>
    memmove(name, s, DIRSIZ);
801022d4:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
801022db:	00 
801022dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022df:	89 44 24 04          	mov    %eax,0x4(%esp)
801022e3:	8b 45 0c             	mov    0xc(%ebp),%eax
801022e6:	89 04 24             	mov    %eax,(%esp)
801022e9:	e8 28 35 00 00       	call   80105816 <memmove>
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
801022ee:	eb 2a                	jmp    8010231a <skipelem+0xa3>
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
801022f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801022f3:	89 44 24 08          	mov    %eax,0x8(%esp)
801022f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801022fa:	89 44 24 04          	mov    %eax,0x4(%esp)
801022fe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102301:	89 04 24             	mov    %eax,(%esp)
80102304:	e8 0d 35 00 00       	call   80105816 <memmove>
    name[len] = 0;
80102309:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010230c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010230f:	01 d0                	add    %edx,%eax
80102311:	c6 00 00             	movb   $0x0,(%eax)
  }
  while(*path == '/')
80102314:	eb 04                	jmp    8010231a <skipelem+0xa3>
    path++;
80102316:	83 45 08 01          	addl   $0x1,0x8(%ebp)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
8010231a:	8b 45 08             	mov    0x8(%ebp),%eax
8010231d:	0f b6 00             	movzbl (%eax),%eax
80102320:	3c 2f                	cmp    $0x2f,%al
80102322:	74 f2                	je     80102316 <skipelem+0x9f>
    path++;
  return path;
80102324:	8b 45 08             	mov    0x8(%ebp),%eax
}
80102327:	c9                   	leave  
80102328:	c3                   	ret    

80102329 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80102329:	55                   	push   %ebp
8010232a:	89 e5                	mov    %esp,%ebp
8010232c:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip, *next;

  if(*path == '/')
8010232f:	8b 45 08             	mov    0x8(%ebp),%eax
80102332:	0f b6 00             	movzbl (%eax),%eax
80102335:	3c 2f                	cmp    $0x2f,%al
80102337:	75 1c                	jne    80102355 <namex+0x2c>
    ip = iget(ROOTDEV, ROOTINO);
80102339:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102340:	00 
80102341:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102348:	e8 44 f4 ff ff       	call   80101791 <iget>
8010234d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102350:	e9 af 00 00 00       	jmp    80102404 <namex+0xdb>
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);
80102355:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010235b:	8b 40 68             	mov    0x68(%eax),%eax
8010235e:	89 04 24             	mov    %eax,(%esp)
80102361:	e8 fd f4 ff ff       	call   80101863 <idup>
80102366:	89 45 f4             	mov    %eax,-0xc(%ebp)

  while((path = skipelem(path, name)) != 0){
80102369:	e9 96 00 00 00       	jmp    80102404 <namex+0xdb>
    ilock(ip);
8010236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102371:	89 04 24             	mov    %eax,(%esp)
80102374:	e8 1c f5 ff ff       	call   80101895 <ilock>
    if(ip->type != T_DIR){
80102379:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010237c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80102380:	66 83 f8 01          	cmp    $0x1,%ax
80102384:	74 15                	je     8010239b <namex+0x72>
      iunlockput(ip);
80102386:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102389:	89 04 24             	mov    %eax,(%esp)
8010238c:	e8 88 f7 ff ff       	call   80101b19 <iunlockput>
      return 0;
80102391:	b8 00 00 00 00       	mov    $0x0,%eax
80102396:	e9 a3 00 00 00       	jmp    8010243e <namex+0x115>
    }
    if(nameiparent && *path == '\0'){
8010239b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
8010239f:	74 1d                	je     801023be <namex+0x95>
801023a1:	8b 45 08             	mov    0x8(%ebp),%eax
801023a4:	0f b6 00             	movzbl (%eax),%eax
801023a7:	84 c0                	test   %al,%al
801023a9:	75 13                	jne    801023be <namex+0x95>
      // Stop one level early.
      iunlock(ip);
801023ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023ae:	89 04 24             	mov    %eax,(%esp)
801023b1:	e8 2d f6 ff ff       	call   801019e3 <iunlock>
      return ip;
801023b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023b9:	e9 80 00 00 00       	jmp    8010243e <namex+0x115>
    }
    if((next = dirlookup(ip, name, 0)) == 0){
801023be:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801023c5:	00 
801023c6:	8b 45 10             	mov    0x10(%ebp),%eax
801023c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801023cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023d0:	89 04 24             	mov    %eax,(%esp)
801023d3:	e8 df fc ff ff       	call   801020b7 <dirlookup>
801023d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
801023db:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801023df:	75 12                	jne    801023f3 <namex+0xca>
      iunlockput(ip);
801023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023e4:	89 04 24             	mov    %eax,(%esp)
801023e7:	e8 2d f7 ff ff       	call   80101b19 <iunlockput>
      return 0;
801023ec:	b8 00 00 00 00       	mov    $0x0,%eax
801023f1:	eb 4b                	jmp    8010243e <namex+0x115>
    }
    iunlockput(ip);
801023f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801023f6:	89 04 24             	mov    %eax,(%esp)
801023f9:	e8 1b f7 ff ff       	call   80101b19 <iunlockput>
    ip = next;
801023fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80102401:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(proc->cwd);

  while((path = skipelem(path, name)) != 0){
80102404:	8b 45 10             	mov    0x10(%ebp),%eax
80102407:	89 44 24 04          	mov    %eax,0x4(%esp)
8010240b:	8b 45 08             	mov    0x8(%ebp),%eax
8010240e:	89 04 24             	mov    %eax,(%esp)
80102411:	e8 61 fe ff ff       	call   80102277 <skipelem>
80102416:	89 45 08             	mov    %eax,0x8(%ebp)
80102419:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010241d:	0f 85 4b ff ff ff    	jne    8010236e <namex+0x45>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80102423:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102427:	74 12                	je     8010243b <namex+0x112>
    iput(ip);
80102429:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010242c:	89 04 24             	mov    %eax,(%esp)
8010242f:	e8 14 f6 ff ff       	call   80101a48 <iput>
    return 0;
80102434:	b8 00 00 00 00       	mov    $0x0,%eax
80102439:	eb 03                	jmp    8010243e <namex+0x115>
  }
  return ip;
8010243b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010243e:	c9                   	leave  
8010243f:	c3                   	ret    

80102440 <namei>:

struct inode*
namei(char *path)
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	83 ec 28             	sub    $0x28,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102446:	8d 45 ea             	lea    -0x16(%ebp),%eax
80102449:	89 44 24 08          	mov    %eax,0x8(%esp)
8010244d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102454:	00 
80102455:	8b 45 08             	mov    0x8(%ebp),%eax
80102458:	89 04 24             	mov    %eax,(%esp)
8010245b:	e8 c9 fe ff ff       	call   80102329 <namex>
}
80102460:	c9                   	leave  
80102461:	c3                   	ret    

80102462 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102462:	55                   	push   %ebp
80102463:	89 e5                	mov    %esp,%ebp
80102465:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 1, name);
80102468:	8b 45 0c             	mov    0xc(%ebp),%eax
8010246b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010246f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102476:	00 
80102477:	8b 45 08             	mov    0x8(%ebp),%eax
8010247a:	89 04 24             	mov    %eax,(%esp)
8010247d:	e8 a7 fe ff ff       	call   80102329 <namex>
}
80102482:	c9                   	leave  
80102483:	c3                   	ret    

80102484 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102484:	55                   	push   %ebp
80102485:	89 e5                	mov    %esp,%ebp
80102487:	83 ec 14             	sub    $0x14,%esp
8010248a:	8b 45 08             	mov    0x8(%ebp),%eax
8010248d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102491:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102495:	89 c2                	mov    %eax,%edx
80102497:	ec                   	in     (%dx),%al
80102498:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010249b:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010249f:	c9                   	leave  
801024a0:	c3                   	ret    

801024a1 <insl>:

static inline void
insl(int port, void *addr, int cnt)
{
801024a1:	55                   	push   %ebp
801024a2:	89 e5                	mov    %esp,%ebp
801024a4:	57                   	push   %edi
801024a5:	53                   	push   %ebx
  asm volatile("cld; rep insl" :
801024a6:	8b 55 08             	mov    0x8(%ebp),%edx
801024a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024ac:	8b 45 10             	mov    0x10(%ebp),%eax
801024af:	89 cb                	mov    %ecx,%ebx
801024b1:	89 df                	mov    %ebx,%edi
801024b3:	89 c1                	mov    %eax,%ecx
801024b5:	fc                   	cld    
801024b6:	f3 6d                	rep insl (%dx),%es:(%edi)
801024b8:	89 c8                	mov    %ecx,%eax
801024ba:	89 fb                	mov    %edi,%ebx
801024bc:	89 5d 0c             	mov    %ebx,0xc(%ebp)
801024bf:	89 45 10             	mov    %eax,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "memory", "cc");
}
801024c2:	5b                   	pop    %ebx
801024c3:	5f                   	pop    %edi
801024c4:	5d                   	pop    %ebp
801024c5:	c3                   	ret    

801024c6 <outb>:

static inline void
outb(ushort port, uchar data)
{
801024c6:	55                   	push   %ebp
801024c7:	89 e5                	mov    %esp,%ebp
801024c9:	83 ec 08             	sub    $0x8,%esp
801024cc:	8b 55 08             	mov    0x8(%ebp),%edx
801024cf:	8b 45 0c             	mov    0xc(%ebp),%eax
801024d2:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
801024d6:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801024d9:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
801024dd:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
801024e1:	ee                   	out    %al,(%dx)
}
801024e2:	c9                   	leave  
801024e3:	c3                   	ret    

801024e4 <outsl>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
}

static inline void
outsl(int port, const void *addr, int cnt)
{
801024e4:	55                   	push   %ebp
801024e5:	89 e5                	mov    %esp,%ebp
801024e7:	56                   	push   %esi
801024e8:	53                   	push   %ebx
  asm volatile("cld; rep outsl" :
801024e9:	8b 55 08             	mov    0x8(%ebp),%edx
801024ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801024ef:	8b 45 10             	mov    0x10(%ebp),%eax
801024f2:	89 cb                	mov    %ecx,%ebx
801024f4:	89 de                	mov    %ebx,%esi
801024f6:	89 c1                	mov    %eax,%ecx
801024f8:	fc                   	cld    
801024f9:	f3 6f                	rep outsl %ds:(%esi),(%dx)
801024fb:	89 c8                	mov    %ecx,%eax
801024fd:	89 f3                	mov    %esi,%ebx
801024ff:	89 5d 0c             	mov    %ebx,0xc(%ebp)
80102502:	89 45 10             	mov    %eax,0x10(%ebp)
               "=S" (addr), "=c" (cnt) :
               "d" (port), "0" (addr), "1" (cnt) :
               "cc");
}
80102505:	5b                   	pop    %ebx
80102506:	5e                   	pop    %esi
80102507:	5d                   	pop    %ebp
80102508:	c3                   	ret    

80102509 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80102509:	55                   	push   %ebp
8010250a:	89 e5                	mov    %esp,%ebp
8010250c:	83 ec 14             	sub    $0x14,%esp
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY) 
8010250f:	90                   	nop
80102510:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102517:	e8 68 ff ff ff       	call   80102484 <inb>
8010251c:	0f b6 c0             	movzbl %al,%eax
8010251f:	89 45 fc             	mov    %eax,-0x4(%ebp)
80102522:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102525:	25 c0 00 00 00       	and    $0xc0,%eax
8010252a:	83 f8 40             	cmp    $0x40,%eax
8010252d:	75 e1                	jne    80102510 <idewait+0x7>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010252f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80102533:	74 11                	je     80102546 <idewait+0x3d>
80102535:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102538:	83 e0 21             	and    $0x21,%eax
8010253b:	85 c0                	test   %eax,%eax
8010253d:	74 07                	je     80102546 <idewait+0x3d>
    return -1;
8010253f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102544:	eb 05                	jmp    8010254b <idewait+0x42>
  return 0;
80102546:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010254b:	c9                   	leave  
8010254c:	c3                   	ret    

8010254d <ideinit>:

void
ideinit(void)
{
8010254d:	55                   	push   %ebp
8010254e:	89 e5                	mov    %esp,%ebp
80102550:	83 ec 28             	sub    $0x28,%esp
  int i;

  initlock(&idelock, "ide");
80102553:	c7 44 24 04 a8 8e 10 	movl   $0x80108ea8,0x4(%esp)
8010255a:	80 
8010255b:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102562:	e8 66 2f 00 00       	call   801054cd <initlock>
  picenable(IRQ_IDE);
80102567:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
8010256e:	e8 7b 18 00 00       	call   80103dee <picenable>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102573:	a1 60 39 11 80       	mov    0x80113960,%eax
80102578:	83 e8 01             	sub    $0x1,%eax
8010257b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010257f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102586:	e8 0c 04 00 00       	call   80102997 <ioapicenable>
  idewait(0);
8010258b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102592:	e8 72 ff ff ff       	call   80102509 <idewait>
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
80102597:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
8010259e:	00 
8010259f:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025a6:	e8 1b ff ff ff       	call   801024c6 <outb>
  for(i=0; i<1000; i++){
801025ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801025b2:	eb 20                	jmp    801025d4 <ideinit+0x87>
    if(inb(0x1f7) != 0){
801025b4:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801025bb:	e8 c4 fe ff ff       	call   80102484 <inb>
801025c0:	84 c0                	test   %al,%al
801025c2:	74 0c                	je     801025d0 <ideinit+0x83>
      havedisk1 = 1;
801025c4:	c7 05 58 c6 10 80 01 	movl   $0x1,0x8010c658
801025cb:	00 00 00 
      break;
801025ce:	eb 0d                	jmp    801025dd <ideinit+0x90>
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);
  
  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
801025d0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801025d4:	81 7d f4 e7 03 00 00 	cmpl   $0x3e7,-0xc(%ebp)
801025db:	7e d7                	jle    801025b4 <ideinit+0x67>
      break;
    }
  }
  
  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
801025dd:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
801025e4:	00 
801025e5:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801025ec:	e8 d5 fe ff ff       	call   801024c6 <outb>
}
801025f1:	c9                   	leave  
801025f2:	c3                   	ret    

801025f3 <idestart>:

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801025f3:	55                   	push   %ebp
801025f4:	89 e5                	mov    %esp,%ebp
801025f6:	83 ec 18             	sub    $0x18,%esp
  if(b == 0)
801025f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801025fd:	75 0c                	jne    8010260b <idestart+0x18>
    panic("idestart");
801025ff:	c7 04 24 ac 8e 10 80 	movl   $0x80108eac,(%esp)
80102606:	e8 2f df ff ff       	call   8010053a <panic>

  idewait(0);
8010260b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102612:	e8 f2 fe ff ff       	call   80102509 <idewait>
  outb(0x3f6, 0);  // generate interrupt
80102617:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010261e:	00 
8010261f:	c7 04 24 f6 03 00 00 	movl   $0x3f6,(%esp)
80102626:	e8 9b fe ff ff       	call   801024c6 <outb>
  outb(0x1f2, 1);  // number of sectors
8010262b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102632:	00 
80102633:	c7 04 24 f2 01 00 00 	movl   $0x1f2,(%esp)
8010263a:	e8 87 fe ff ff       	call   801024c6 <outb>
  outb(0x1f3, b->sector & 0xff);
8010263f:	8b 45 08             	mov    0x8(%ebp),%eax
80102642:	8b 40 08             	mov    0x8(%eax),%eax
80102645:	0f b6 c0             	movzbl %al,%eax
80102648:	89 44 24 04          	mov    %eax,0x4(%esp)
8010264c:	c7 04 24 f3 01 00 00 	movl   $0x1f3,(%esp)
80102653:	e8 6e fe ff ff       	call   801024c6 <outb>
  outb(0x1f4, (b->sector >> 8) & 0xff);
80102658:	8b 45 08             	mov    0x8(%ebp),%eax
8010265b:	8b 40 08             	mov    0x8(%eax),%eax
8010265e:	c1 e8 08             	shr    $0x8,%eax
80102661:	0f b6 c0             	movzbl %al,%eax
80102664:	89 44 24 04          	mov    %eax,0x4(%esp)
80102668:	c7 04 24 f4 01 00 00 	movl   $0x1f4,(%esp)
8010266f:	e8 52 fe ff ff       	call   801024c6 <outb>
  outb(0x1f5, (b->sector >> 16) & 0xff);
80102674:	8b 45 08             	mov    0x8(%ebp),%eax
80102677:	8b 40 08             	mov    0x8(%eax),%eax
8010267a:	c1 e8 10             	shr    $0x10,%eax
8010267d:	0f b6 c0             	movzbl %al,%eax
80102680:	89 44 24 04          	mov    %eax,0x4(%esp)
80102684:	c7 04 24 f5 01 00 00 	movl   $0x1f5,(%esp)
8010268b:	e8 36 fe ff ff       	call   801024c6 <outb>
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((b->sector>>24)&0x0f));
80102690:	8b 45 08             	mov    0x8(%ebp),%eax
80102693:	8b 40 04             	mov    0x4(%eax),%eax
80102696:	83 e0 01             	and    $0x1,%eax
80102699:	c1 e0 04             	shl    $0x4,%eax
8010269c:	89 c2                	mov    %eax,%edx
8010269e:	8b 45 08             	mov    0x8(%ebp),%eax
801026a1:	8b 40 08             	mov    0x8(%eax),%eax
801026a4:	c1 e8 18             	shr    $0x18,%eax
801026a7:	83 e0 0f             	and    $0xf,%eax
801026aa:	09 d0                	or     %edx,%eax
801026ac:	83 c8 e0             	or     $0xffffffe0,%eax
801026af:	0f b6 c0             	movzbl %al,%eax
801026b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801026b6:	c7 04 24 f6 01 00 00 	movl   $0x1f6,(%esp)
801026bd:	e8 04 fe ff ff       	call   801024c6 <outb>
  if(b->flags & B_DIRTY){
801026c2:	8b 45 08             	mov    0x8(%ebp),%eax
801026c5:	8b 00                	mov    (%eax),%eax
801026c7:	83 e0 04             	and    $0x4,%eax
801026ca:	85 c0                	test   %eax,%eax
801026cc:	74 34                	je     80102702 <idestart+0x10f>
    outb(0x1f7, IDE_CMD_WRITE);
801026ce:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
801026d5:	00 
801026d6:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
801026dd:	e8 e4 fd ff ff       	call   801024c6 <outb>
    outsl(0x1f0, b->data, 512/4);
801026e2:	8b 45 08             	mov    0x8(%ebp),%eax
801026e5:	83 c0 18             	add    $0x18,%eax
801026e8:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801026ef:	00 
801026f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801026f4:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
801026fb:	e8 e4 fd ff ff       	call   801024e4 <outsl>
80102700:	eb 14                	jmp    80102716 <idestart+0x123>
  } else {
    outb(0x1f7, IDE_CMD_READ);
80102702:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80102709:	00 
8010270a:	c7 04 24 f7 01 00 00 	movl   $0x1f7,(%esp)
80102711:	e8 b0 fd ff ff       	call   801024c6 <outb>
  }
}
80102716:	c9                   	leave  
80102717:	c3                   	ret    

80102718 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102718:	55                   	push   %ebp
80102719:	89 e5                	mov    %esp,%ebp
8010271b:	83 ec 28             	sub    $0x28,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
8010271e:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102725:	e8 c4 2d 00 00       	call   801054ee <acquire>
  if((b = idequeue) == 0){
8010272a:	a1 54 c6 10 80       	mov    0x8010c654,%eax
8010272f:	89 45 f4             	mov    %eax,-0xc(%ebp)
80102732:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102736:	75 11                	jne    80102749 <ideintr+0x31>
    release(&idelock);
80102738:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
8010273f:	e8 11 2e 00 00       	call   80105555 <release>
    // cprintf("spurious IDE interrupt\n");
    return;
80102744:	e9 90 00 00 00       	jmp    801027d9 <ideintr+0xc1>
  }
  idequeue = b->qnext;
80102749:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010274c:	8b 40 14             	mov    0x14(%eax),%eax
8010274f:	a3 54 c6 10 80       	mov    %eax,0x8010c654

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102754:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102757:	8b 00                	mov    (%eax),%eax
80102759:	83 e0 04             	and    $0x4,%eax
8010275c:	85 c0                	test   %eax,%eax
8010275e:	75 2e                	jne    8010278e <ideintr+0x76>
80102760:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102767:	e8 9d fd ff ff       	call   80102509 <idewait>
8010276c:	85 c0                	test   %eax,%eax
8010276e:	78 1e                	js     8010278e <ideintr+0x76>
    insl(0x1f0, b->data, 512/4);
80102770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102773:	83 c0 18             	add    $0x18,%eax
80102776:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
8010277d:	00 
8010277e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102782:	c7 04 24 f0 01 00 00 	movl   $0x1f0,(%esp)
80102789:	e8 13 fd ff ff       	call   801024a1 <insl>
  
  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102791:	8b 00                	mov    (%eax),%eax
80102793:	83 c8 02             	or     $0x2,%eax
80102796:	89 c2                	mov    %eax,%edx
80102798:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010279b:	89 10                	mov    %edx,(%eax)
  b->flags &= ~B_DIRTY;
8010279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027a0:	8b 00                	mov    (%eax),%eax
801027a2:	83 e0 fb             	and    $0xfffffffb,%eax
801027a5:	89 c2                	mov    %eax,%edx
801027a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027aa:	89 10                	mov    %edx,(%eax)
  wakeup(b);
801027ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
801027af:	89 04 24             	mov    %eax,(%esp)
801027b2:	e8 51 28 00 00       	call   80105008 <wakeup>
  
  // Start disk on next buf in queue.
  if(idequeue != 0)
801027b7:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027bc:	85 c0                	test   %eax,%eax
801027be:	74 0d                	je     801027cd <ideintr+0xb5>
    idestart(idequeue);
801027c0:	a1 54 c6 10 80       	mov    0x8010c654,%eax
801027c5:	89 04 24             	mov    %eax,(%esp)
801027c8:	e8 26 fe ff ff       	call   801025f3 <idestart>

  release(&idelock);
801027cd:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801027d4:	e8 7c 2d 00 00       	call   80105555 <release>
}
801027d9:	c9                   	leave  
801027da:	c3                   	ret    

801027db <iderw>:
// Sync buf with disk. 
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801027db:	55                   	push   %ebp
801027dc:	89 e5                	mov    %esp,%ebp
801027de:	83 ec 28             	sub    $0x28,%esp
  struct buf **pp;

  if(!(b->flags & B_BUSY))
801027e1:	8b 45 08             	mov    0x8(%ebp),%eax
801027e4:	8b 00                	mov    (%eax),%eax
801027e6:	83 e0 01             	and    $0x1,%eax
801027e9:	85 c0                	test   %eax,%eax
801027eb:	75 0c                	jne    801027f9 <iderw+0x1e>
    panic("iderw: buf not busy");
801027ed:	c7 04 24 b5 8e 10 80 	movl   $0x80108eb5,(%esp)
801027f4:	e8 41 dd ff ff       	call   8010053a <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801027f9:	8b 45 08             	mov    0x8(%ebp),%eax
801027fc:	8b 00                	mov    (%eax),%eax
801027fe:	83 e0 06             	and    $0x6,%eax
80102801:	83 f8 02             	cmp    $0x2,%eax
80102804:	75 0c                	jne    80102812 <iderw+0x37>
    panic("iderw: nothing to do");
80102806:	c7 04 24 c9 8e 10 80 	movl   $0x80108ec9,(%esp)
8010280d:	e8 28 dd ff ff       	call   8010053a <panic>
  if(b->dev != 0 && !havedisk1)
80102812:	8b 45 08             	mov    0x8(%ebp),%eax
80102815:	8b 40 04             	mov    0x4(%eax),%eax
80102818:	85 c0                	test   %eax,%eax
8010281a:	74 15                	je     80102831 <iderw+0x56>
8010281c:	a1 58 c6 10 80       	mov    0x8010c658,%eax
80102821:	85 c0                	test   %eax,%eax
80102823:	75 0c                	jne    80102831 <iderw+0x56>
    panic("iderw: ide disk 1 not present");
80102825:	c7 04 24 de 8e 10 80 	movl   $0x80108ede,(%esp)
8010282c:	e8 09 dd ff ff       	call   8010053a <panic>

  acquire(&idelock);  //DOC:acquire-lock
80102831:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
80102838:	e8 b1 2c 00 00       	call   801054ee <acquire>

  // Append b to idequeue.
  b->qnext = 0;
8010283d:	8b 45 08             	mov    0x8(%ebp),%eax
80102840:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102847:	c7 45 f4 54 c6 10 80 	movl   $0x8010c654,-0xc(%ebp)
8010284e:	eb 0b                	jmp    8010285b <iderw+0x80>
80102850:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102853:	8b 00                	mov    (%eax),%eax
80102855:	83 c0 14             	add    $0x14,%eax
80102858:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010285b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010285e:	8b 00                	mov    (%eax),%eax
80102860:	85 c0                	test   %eax,%eax
80102862:	75 ec                	jne    80102850 <iderw+0x75>
    ;
  *pp = b;
80102864:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102867:	8b 55 08             	mov    0x8(%ebp),%edx
8010286a:	89 10                	mov    %edx,(%eax)
  
  // Start disk if necessary.
  if(idequeue == b)
8010286c:	a1 54 c6 10 80       	mov    0x8010c654,%eax
80102871:	3b 45 08             	cmp    0x8(%ebp),%eax
80102874:	75 0d                	jne    80102883 <iderw+0xa8>
    idestart(b);
80102876:	8b 45 08             	mov    0x8(%ebp),%eax
80102879:	89 04 24             	mov    %eax,(%esp)
8010287c:	e8 72 fd ff ff       	call   801025f3 <idestart>
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102881:	eb 15                	jmp    80102898 <iderw+0xbd>
80102883:	eb 13                	jmp    80102898 <iderw+0xbd>
    sleep(b, &idelock);
80102885:	c7 44 24 04 20 c6 10 	movl   $0x8010c620,0x4(%esp)
8010288c:	80 
8010288d:	8b 45 08             	mov    0x8(%ebp),%eax
80102890:	89 04 24             	mov    %eax,(%esp)
80102893:	e8 84 26 00 00       	call   80104f1c <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
  
  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102898:	8b 45 08             	mov    0x8(%ebp),%eax
8010289b:	8b 00                	mov    (%eax),%eax
8010289d:	83 e0 06             	and    $0x6,%eax
801028a0:	83 f8 02             	cmp    $0x2,%eax
801028a3:	75 e0                	jne    80102885 <iderw+0xaa>
    sleep(b, &idelock);
  }

  release(&idelock);
801028a5:	c7 04 24 20 c6 10 80 	movl   $0x8010c620,(%esp)
801028ac:	e8 a4 2c 00 00       	call   80105555 <release>
}
801028b1:	c9                   	leave  
801028b2:	c3                   	ret    

801028b3 <ioapicread>:
  uint data;
};

static uint
ioapicread(int reg)
{
801028b3:	55                   	push   %ebp
801028b4:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028b6:	a1 34 32 11 80       	mov    0x80113234,%eax
801028bb:	8b 55 08             	mov    0x8(%ebp),%edx
801028be:	89 10                	mov    %edx,(%eax)
  return ioapic->data;
801028c0:	a1 34 32 11 80       	mov    0x80113234,%eax
801028c5:	8b 40 10             	mov    0x10(%eax),%eax
}
801028c8:	5d                   	pop    %ebp
801028c9:	c3                   	ret    

801028ca <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
801028ca:	55                   	push   %ebp
801028cb:	89 e5                	mov    %esp,%ebp
  ioapic->reg = reg;
801028cd:	a1 34 32 11 80       	mov    0x80113234,%eax
801028d2:	8b 55 08             	mov    0x8(%ebp),%edx
801028d5:	89 10                	mov    %edx,(%eax)
  ioapic->data = data;
801028d7:	a1 34 32 11 80       	mov    0x80113234,%eax
801028dc:	8b 55 0c             	mov    0xc(%ebp),%edx
801028df:	89 50 10             	mov    %edx,0x10(%eax)
}
801028e2:	5d                   	pop    %ebp
801028e3:	c3                   	ret    

801028e4 <ioapicinit>:

void
ioapicinit(void)
{
801028e4:	55                   	push   %ebp
801028e5:	89 e5                	mov    %esp,%ebp
801028e7:	83 ec 28             	sub    $0x28,%esp
  int i, id, maxintr;

  if(!ismp)
801028ea:	a1 64 33 11 80       	mov    0x80113364,%eax
801028ef:	85 c0                	test   %eax,%eax
801028f1:	75 05                	jne    801028f8 <ioapicinit+0x14>
    return;
801028f3:	e9 9d 00 00 00       	jmp    80102995 <ioapicinit+0xb1>

  ioapic = (volatile struct ioapic*)IOAPIC;
801028f8:	c7 05 34 32 11 80 00 	movl   $0xfec00000,0x80113234
801028ff:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102902:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80102909:	e8 a5 ff ff ff       	call   801028b3 <ioapicread>
8010290e:	c1 e8 10             	shr    $0x10,%eax
80102911:	25 ff 00 00 00       	and    $0xff,%eax
80102916:	89 45 f0             	mov    %eax,-0x10(%ebp)
  id = ioapicread(REG_ID) >> 24;
80102919:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80102920:	e8 8e ff ff ff       	call   801028b3 <ioapicread>
80102925:	c1 e8 18             	shr    $0x18,%eax
80102928:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if(id != ioapicid)
8010292b:	0f b6 05 60 33 11 80 	movzbl 0x80113360,%eax
80102932:	0f b6 c0             	movzbl %al,%eax
80102935:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80102938:	74 0c                	je     80102946 <ioapicinit+0x62>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
8010293a:	c7 04 24 fc 8e 10 80 	movl   $0x80108efc,(%esp)
80102941:	e8 5a da ff ff       	call   801003a0 <cprintf>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102946:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010294d:	eb 3e                	jmp    8010298d <ioapicinit+0xa9>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
8010294f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102952:	83 c0 20             	add    $0x20,%eax
80102955:	0d 00 00 01 00       	or     $0x10000,%eax
8010295a:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010295d:	83 c2 08             	add    $0x8,%edx
80102960:	01 d2                	add    %edx,%edx
80102962:	89 44 24 04          	mov    %eax,0x4(%esp)
80102966:	89 14 24             	mov    %edx,(%esp)
80102969:	e8 5c ff ff ff       	call   801028ca <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
8010296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102971:	83 c0 08             	add    $0x8,%eax
80102974:	01 c0                	add    %eax,%eax
80102976:	83 c0 01             	add    $0x1,%eax
80102979:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102980:	00 
80102981:	89 04 24             	mov    %eax,(%esp)
80102984:	e8 41 ff ff ff       	call   801028ca <ioapicwrite>
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80102989:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010298d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102990:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80102993:	7e ba                	jle    8010294f <ioapicinit+0x6b>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
80102995:	c9                   	leave  
80102996:	c3                   	ret    

80102997 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102997:	55                   	push   %ebp
80102998:	89 e5                	mov    %esp,%ebp
8010299a:	83 ec 08             	sub    $0x8,%esp
  if(!ismp)
8010299d:	a1 64 33 11 80       	mov    0x80113364,%eax
801029a2:	85 c0                	test   %eax,%eax
801029a4:	75 02                	jne    801029a8 <ioapicenable+0x11>
    return;
801029a6:	eb 37                	jmp    801029df <ioapicenable+0x48>

  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801029a8:	8b 45 08             	mov    0x8(%ebp),%eax
801029ab:	83 c0 20             	add    $0x20,%eax
801029ae:	8b 55 08             	mov    0x8(%ebp),%edx
801029b1:	83 c2 08             	add    $0x8,%edx
801029b4:	01 d2                	add    %edx,%edx
801029b6:	89 44 24 04          	mov    %eax,0x4(%esp)
801029ba:	89 14 24             	mov    %edx,(%esp)
801029bd:	e8 08 ff ff ff       	call   801028ca <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801029c2:	8b 45 0c             	mov    0xc(%ebp),%eax
801029c5:	c1 e0 18             	shl    $0x18,%eax
801029c8:	8b 55 08             	mov    0x8(%ebp),%edx
801029cb:	83 c2 08             	add    $0x8,%edx
801029ce:	01 d2                	add    %edx,%edx
801029d0:	83 c2 01             	add    $0x1,%edx
801029d3:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d7:	89 14 24             	mov    %edx,(%esp)
801029da:	e8 eb fe ff ff       	call   801028ca <ioapicwrite>
}
801029df:	c9                   	leave  
801029e0:	c3                   	ret    

801029e1 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
801029e1:	55                   	push   %ebp
801029e2:	89 e5                	mov    %esp,%ebp
801029e4:	8b 45 08             	mov    0x8(%ebp),%eax
801029e7:	05 00 00 00 80       	add    $0x80000000,%eax
801029ec:	5d                   	pop    %ebp
801029ed:	c3                   	ret    

801029ee <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801029ee:	55                   	push   %ebp
801029ef:	89 e5                	mov    %esp,%ebp
801029f1:	83 ec 18             	sub    $0x18,%esp
  initlock(&kmem.lock, "kmem");
801029f4:	c7 44 24 04 2e 8f 10 	movl   $0x80108f2e,0x4(%esp)
801029fb:	80 
801029fc:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102a03:	e8 c5 2a 00 00       	call   801054cd <initlock>
  kmem.use_lock = 0;
80102a08:	c7 05 74 32 11 80 00 	movl   $0x0,0x80113274
80102a0f:	00 00 00 
  freerange(vstart, vend);
80102a12:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a15:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a19:	8b 45 08             	mov    0x8(%ebp),%eax
80102a1c:	89 04 24             	mov    %eax,(%esp)
80102a1f:	e8 26 00 00 00       	call   80102a4a <freerange>
}
80102a24:	c9                   	leave  
80102a25:	c3                   	ret    

80102a26 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102a26:	55                   	push   %ebp
80102a27:	89 e5                	mov    %esp,%ebp
80102a29:	83 ec 18             	sub    $0x18,%esp
  freerange(vstart, vend);
80102a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
80102a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a33:	8b 45 08             	mov    0x8(%ebp),%eax
80102a36:	89 04 24             	mov    %eax,(%esp)
80102a39:	e8 0c 00 00 00       	call   80102a4a <freerange>
  kmem.use_lock = 1;
80102a3e:	c7 05 74 32 11 80 01 	movl   $0x1,0x80113274
80102a45:	00 00 00 
}
80102a48:	c9                   	leave  
80102a49:	c3                   	ret    

80102a4a <freerange>:

void
freerange(void *vstart, void *vend)
{
80102a4a:	55                   	push   %ebp
80102a4b:	89 e5                	mov    %esp,%ebp
80102a4d:	83 ec 28             	sub    $0x28,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102a50:	8b 45 08             	mov    0x8(%ebp),%eax
80102a53:	05 ff 0f 00 00       	add    $0xfff,%eax
80102a58:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80102a5d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a60:	eb 12                	jmp    80102a74 <freerange+0x2a>
    kfree(p);
80102a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a65:	89 04 24             	mov    %eax,(%esp)
80102a68:	e8 16 00 00 00       	call   80102a83 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102a6d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80102a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102a77:	05 00 10 00 00       	add    $0x1000,%eax
80102a7c:	3b 45 0c             	cmp    0xc(%ebp),%eax
80102a7f:	76 e1                	jbe    80102a62 <freerange+0x18>
    kfree(p);
}
80102a81:	c9                   	leave  
80102a82:	c3                   	ret    

80102a83 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102a83:	55                   	push   %ebp
80102a84:	89 e5                	mov    %esp,%ebp
80102a86:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if((uint)v % PGSIZE || v < end || v2p(v) >= PHYSTOP)
80102a89:	8b 45 08             	mov    0x8(%ebp),%eax
80102a8c:	25 ff 0f 00 00       	and    $0xfff,%eax
80102a91:	85 c0                	test   %eax,%eax
80102a93:	75 1b                	jne    80102ab0 <kfree+0x2d>
80102a95:	81 7d 08 5c 6a 11 80 	cmpl   $0x80116a5c,0x8(%ebp)
80102a9c:	72 12                	jb     80102ab0 <kfree+0x2d>
80102a9e:	8b 45 08             	mov    0x8(%ebp),%eax
80102aa1:	89 04 24             	mov    %eax,(%esp)
80102aa4:	e8 38 ff ff ff       	call   801029e1 <v2p>
80102aa9:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102aae:	76 0c                	jbe    80102abc <kfree+0x39>
    panic("kfree");
80102ab0:	c7 04 24 33 8f 10 80 	movl   $0x80108f33,(%esp)
80102ab7:	e8 7e da ff ff       	call   8010053a <panic>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102abc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80102ac3:	00 
80102ac4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102acb:	00 
80102acc:	8b 45 08             	mov    0x8(%ebp),%eax
80102acf:	89 04 24             	mov    %eax,(%esp)
80102ad2:	e8 70 2c 00 00       	call   80105747 <memset>

  if(kmem.use_lock)
80102ad7:	a1 74 32 11 80       	mov    0x80113274,%eax
80102adc:	85 c0                	test   %eax,%eax
80102ade:	74 0c                	je     80102aec <kfree+0x69>
    acquire(&kmem.lock);
80102ae0:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102ae7:	e8 02 2a 00 00       	call   801054ee <acquire>
  r = (struct run*)v;
80102aec:	8b 45 08             	mov    0x8(%ebp),%eax
80102aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
  r->next = kmem.freelist;
80102af2:	8b 15 78 32 11 80    	mov    0x80113278,%edx
80102af8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102afb:	89 10                	mov    %edx,(%eax)
  kmem.freelist = r;
80102afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b00:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102b05:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b0a:	85 c0                	test   %eax,%eax
80102b0c:	74 0c                	je     80102b1a <kfree+0x97>
    release(&kmem.lock);
80102b0e:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b15:	e8 3b 2a 00 00       	call   80105555 <release>
}
80102b1a:	c9                   	leave  
80102b1b:	c3                   	ret    

80102b1c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102b1c:	55                   	push   %ebp
80102b1d:	89 e5                	mov    %esp,%ebp
80102b1f:	83 ec 28             	sub    $0x28,%esp
  struct run *r;

  if(kmem.use_lock)
80102b22:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b27:	85 c0                	test   %eax,%eax
80102b29:	74 0c                	je     80102b37 <kalloc+0x1b>
    acquire(&kmem.lock);
80102b2b:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b32:	e8 b7 29 00 00       	call   801054ee <acquire>
  r = kmem.freelist;
80102b37:	a1 78 32 11 80       	mov    0x80113278,%eax
80102b3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(r)
80102b3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80102b43:	74 0a                	je     80102b4f <kalloc+0x33>
    kmem.freelist = r->next;
80102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102b48:	8b 00                	mov    (%eax),%eax
80102b4a:	a3 78 32 11 80       	mov    %eax,0x80113278
  if(kmem.use_lock)
80102b4f:	a1 74 32 11 80       	mov    0x80113274,%eax
80102b54:	85 c0                	test   %eax,%eax
80102b56:	74 0c                	je     80102b64 <kalloc+0x48>
    release(&kmem.lock);
80102b58:	c7 04 24 40 32 11 80 	movl   $0x80113240,(%esp)
80102b5f:	e8 f1 29 00 00       	call   80105555 <release>
  return (char*)r;
80102b64:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80102b67:	c9                   	leave  
80102b68:	c3                   	ret    

80102b69 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102b69:	55                   	push   %ebp
80102b6a:	89 e5                	mov    %esp,%ebp
80102b6c:	83 ec 14             	sub    $0x14,%esp
80102b6f:	8b 45 08             	mov    0x8(%ebp),%eax
80102b72:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b76:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102b7a:	89 c2                	mov    %eax,%edx
80102b7c:	ec                   	in     (%dx),%al
80102b7d:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102b80:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102b84:	c9                   	leave  
80102b85:	c3                   	ret    

80102b86 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102b86:	55                   	push   %ebp
80102b87:	89 e5                	mov    %esp,%ebp
80102b89:	83 ec 14             	sub    $0x14,%esp
  static uchar *charcode[4] = {
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
80102b8c:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102b93:	e8 d1 ff ff ff       	call   80102b69 <inb>
80102b98:	0f b6 c0             	movzbl %al,%eax
80102b9b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((st & KBS_DIB) == 0)
80102b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80102ba1:	83 e0 01             	and    $0x1,%eax
80102ba4:	85 c0                	test   %eax,%eax
80102ba6:	75 0a                	jne    80102bb2 <kbdgetc+0x2c>
    return -1;
80102ba8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102bad:	e9 25 01 00 00       	jmp    80102cd7 <kbdgetc+0x151>
  data = inb(KBDATAP);
80102bb2:	c7 04 24 60 00 00 00 	movl   $0x60,(%esp)
80102bb9:	e8 ab ff ff ff       	call   80102b69 <inb>
80102bbe:	0f b6 c0             	movzbl %al,%eax
80102bc1:	89 45 fc             	mov    %eax,-0x4(%ebp)

  if(data == 0xE0){
80102bc4:	81 7d fc e0 00 00 00 	cmpl   $0xe0,-0x4(%ebp)
80102bcb:	75 17                	jne    80102be4 <kbdgetc+0x5e>
    shift |= E0ESC;
80102bcd:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bd2:	83 c8 40             	or     $0x40,%eax
80102bd5:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102bda:	b8 00 00 00 00       	mov    $0x0,%eax
80102bdf:	e9 f3 00 00 00       	jmp    80102cd7 <kbdgetc+0x151>
  } else if(data & 0x80){
80102be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102be7:	25 80 00 00 00       	and    $0x80,%eax
80102bec:	85 c0                	test   %eax,%eax
80102bee:	74 45                	je     80102c35 <kbdgetc+0xaf>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102bf0:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102bf5:	83 e0 40             	and    $0x40,%eax
80102bf8:	85 c0                	test   %eax,%eax
80102bfa:	75 08                	jne    80102c04 <kbdgetc+0x7e>
80102bfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102bff:	83 e0 7f             	and    $0x7f,%eax
80102c02:	eb 03                	jmp    80102c07 <kbdgetc+0x81>
80102c04:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c07:	89 45 fc             	mov    %eax,-0x4(%ebp)
    shift &= ~(shiftcode[data] | E0ESC);
80102c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c0d:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c12:	0f b6 00             	movzbl (%eax),%eax
80102c15:	83 c8 40             	or     $0x40,%eax
80102c18:	0f b6 c0             	movzbl %al,%eax
80102c1b:	f7 d0                	not    %eax
80102c1d:	89 c2                	mov    %eax,%edx
80102c1f:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c24:	21 d0                	and    %edx,%eax
80102c26:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
    return 0;
80102c2b:	b8 00 00 00 00       	mov    $0x0,%eax
80102c30:	e9 a2 00 00 00       	jmp    80102cd7 <kbdgetc+0x151>
  } else if(shift & E0ESC){
80102c35:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c3a:	83 e0 40             	and    $0x40,%eax
80102c3d:	85 c0                	test   %eax,%eax
80102c3f:	74 14                	je     80102c55 <kbdgetc+0xcf>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102c41:	81 4d fc 80 00 00 00 	orl    $0x80,-0x4(%ebp)
    shift &= ~E0ESC;
80102c48:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c4d:	83 e0 bf             	and    $0xffffffbf,%eax
80102c50:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  }

  shift |= shiftcode[data];
80102c55:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c58:	05 20 a0 10 80       	add    $0x8010a020,%eax
80102c5d:	0f b6 00             	movzbl (%eax),%eax
80102c60:	0f b6 d0             	movzbl %al,%edx
80102c63:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c68:	09 d0                	or     %edx,%eax
80102c6a:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  shift ^= togglecode[data];
80102c6f:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c72:	05 20 a1 10 80       	add    $0x8010a120,%eax
80102c77:	0f b6 00             	movzbl (%eax),%eax
80102c7a:	0f b6 d0             	movzbl %al,%edx
80102c7d:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c82:	31 d0                	xor    %edx,%eax
80102c84:	a3 5c c6 10 80       	mov    %eax,0x8010c65c
  c = charcode[shift & (CTL | SHIFT)][data];
80102c89:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102c8e:	83 e0 03             	and    $0x3,%eax
80102c91:	8b 14 85 20 a5 10 80 	mov    -0x7fef5ae0(,%eax,4),%edx
80102c98:	8b 45 fc             	mov    -0x4(%ebp),%eax
80102c9b:	01 d0                	add    %edx,%eax
80102c9d:	0f b6 00             	movzbl (%eax),%eax
80102ca0:	0f b6 c0             	movzbl %al,%eax
80102ca3:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(shift & CAPSLOCK){
80102ca6:	a1 5c c6 10 80       	mov    0x8010c65c,%eax
80102cab:	83 e0 08             	and    $0x8,%eax
80102cae:	85 c0                	test   %eax,%eax
80102cb0:	74 22                	je     80102cd4 <kbdgetc+0x14e>
    if('a' <= c && c <= 'z')
80102cb2:	83 7d f8 60          	cmpl   $0x60,-0x8(%ebp)
80102cb6:	76 0c                	jbe    80102cc4 <kbdgetc+0x13e>
80102cb8:	83 7d f8 7a          	cmpl   $0x7a,-0x8(%ebp)
80102cbc:	77 06                	ja     80102cc4 <kbdgetc+0x13e>
      c += 'A' - 'a';
80102cbe:	83 6d f8 20          	subl   $0x20,-0x8(%ebp)
80102cc2:	eb 10                	jmp    80102cd4 <kbdgetc+0x14e>
    else if('A' <= c && c <= 'Z')
80102cc4:	83 7d f8 40          	cmpl   $0x40,-0x8(%ebp)
80102cc8:	76 0a                	jbe    80102cd4 <kbdgetc+0x14e>
80102cca:	83 7d f8 5a          	cmpl   $0x5a,-0x8(%ebp)
80102cce:	77 04                	ja     80102cd4 <kbdgetc+0x14e>
      c += 'a' - 'A';
80102cd0:	83 45 f8 20          	addl   $0x20,-0x8(%ebp)
  }
  return c;
80102cd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
80102cd7:	c9                   	leave  
80102cd8:	c3                   	ret    

80102cd9 <kbdintr>:

void
kbdintr(void)
{
80102cd9:	55                   	push   %ebp
80102cda:	89 e5                	mov    %esp,%ebp
80102cdc:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102cdf:	c7 04 24 86 2b 10 80 	movl   $0x80102b86,(%esp)
80102ce6:	e8 c2 da ff ff       	call   801007ad <consoleintr>
}
80102ceb:	c9                   	leave  
80102cec:	c3                   	ret    

80102ced <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80102ced:	55                   	push   %ebp
80102cee:	89 e5                	mov    %esp,%ebp
80102cf0:	83 ec 14             	sub    $0x14,%esp
80102cf3:	8b 45 08             	mov    0x8(%ebp),%eax
80102cf6:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102cfa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80102cfe:	89 c2                	mov    %eax,%edx
80102d00:	ec                   	in     (%dx),%al
80102d01:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80102d04:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80102d08:	c9                   	leave  
80102d09:	c3                   	ret    

80102d0a <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80102d0a:	55                   	push   %ebp
80102d0b:	89 e5                	mov    %esp,%ebp
80102d0d:	83 ec 08             	sub    $0x8,%esp
80102d10:	8b 55 08             	mov    0x8(%ebp),%edx
80102d13:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d16:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80102d1a:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102d1d:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80102d21:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80102d25:	ee                   	out    %al,(%dx)
}
80102d26:	c9                   	leave  
80102d27:	c3                   	ret    

80102d28 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80102d28:	55                   	push   %ebp
80102d29:	89 e5                	mov    %esp,%ebp
80102d2b:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80102d2e:	9c                   	pushf  
80102d2f:	58                   	pop    %eax
80102d30:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
80102d33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80102d36:	c9                   	leave  
80102d37:	c3                   	ret    

80102d38 <lapicw>:

volatile uint *lapic;  // Initialized in mp.c

static void
lapicw(int index, int value)
{
80102d38:	55                   	push   %ebp
80102d39:	89 e5                	mov    %esp,%ebp
  lapic[index] = value;
80102d3b:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d40:	8b 55 08             	mov    0x8(%ebp),%edx
80102d43:	c1 e2 02             	shl    $0x2,%edx
80102d46:	01 c2                	add    %eax,%edx
80102d48:	8b 45 0c             	mov    0xc(%ebp),%eax
80102d4b:	89 02                	mov    %eax,(%edx)
  lapic[ID];  // wait for write to finish, by reading
80102d4d:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d52:	83 c0 20             	add    $0x20,%eax
80102d55:	8b 00                	mov    (%eax),%eax
}
80102d57:	5d                   	pop    %ebp
80102d58:	c3                   	ret    

80102d59 <lapicinit>:
//PAGEBREAK!

void
lapicinit(void)
{
80102d59:	55                   	push   %ebp
80102d5a:	89 e5                	mov    %esp,%ebp
80102d5c:	83 ec 08             	sub    $0x8,%esp
  if(!lapic) 
80102d5f:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102d64:	85 c0                	test   %eax,%eax
80102d66:	75 05                	jne    80102d6d <lapicinit+0x14>
    return;
80102d68:	e9 43 01 00 00       	jmp    80102eb0 <lapicinit+0x157>

  // Enable local APIC; set spurious interrupt vector.
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102d6d:	c7 44 24 04 3f 01 00 	movl   $0x13f,0x4(%esp)
80102d74:	00 
80102d75:	c7 04 24 3c 00 00 00 	movl   $0x3c,(%esp)
80102d7c:	e8 b7 ff ff ff       	call   80102d38 <lapicw>

  // The timer repeatedly counts down at bus frequency
  // from lapic[TICR] and then issues an interrupt.  
  // If xv6 cared more about precise timekeeping,
  // TICR would be calibrated using an external time source.
  lapicw(TDCR, X1);
80102d81:	c7 44 24 04 0b 00 00 	movl   $0xb,0x4(%esp)
80102d88:	00 
80102d89:	c7 04 24 f8 00 00 00 	movl   $0xf8,(%esp)
80102d90:	e8 a3 ff ff ff       	call   80102d38 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102d95:	c7 44 24 04 20 00 02 	movl   $0x20020,0x4(%esp)
80102d9c:	00 
80102d9d:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102da4:	e8 8f ff ff ff       	call   80102d38 <lapicw>
  lapicw(TICR, 10000000); 
80102da9:	c7 44 24 04 80 96 98 	movl   $0x989680,0x4(%esp)
80102db0:	00 
80102db1:	c7 04 24 e0 00 00 00 	movl   $0xe0,(%esp)
80102db8:	e8 7b ff ff ff       	call   80102d38 <lapicw>

  // Disable logical interrupt lines.
  lapicw(LINT0, MASKED);
80102dbd:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dc4:	00 
80102dc5:	c7 04 24 d4 00 00 00 	movl   $0xd4,(%esp)
80102dcc:	e8 67 ff ff ff       	call   80102d38 <lapicw>
  lapicw(LINT1, MASKED);
80102dd1:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102dd8:	00 
80102dd9:	c7 04 24 d8 00 00 00 	movl   $0xd8,(%esp)
80102de0:	e8 53 ff ff ff       	call   80102d38 <lapicw>

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
80102de5:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102dea:	83 c0 30             	add    $0x30,%eax
80102ded:	8b 00                	mov    (%eax),%eax
80102def:	c1 e8 10             	shr    $0x10,%eax
80102df2:	0f b6 c0             	movzbl %al,%eax
80102df5:	83 f8 03             	cmp    $0x3,%eax
80102df8:	76 14                	jbe    80102e0e <lapicinit+0xb5>
    lapicw(PCINT, MASKED);
80102dfa:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80102e01:	00 
80102e02:	c7 04 24 d0 00 00 00 	movl   $0xd0,(%esp)
80102e09:	e8 2a ff ff ff       	call   80102d38 <lapicw>

  // Map error interrupt to IRQ_ERROR.
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102e0e:	c7 44 24 04 33 00 00 	movl   $0x33,0x4(%esp)
80102e15:	00 
80102e16:	c7 04 24 dc 00 00 00 	movl   $0xdc,(%esp)
80102e1d:	e8 16 ff ff ff       	call   80102d38 <lapicw>

  // Clear error status register (requires back-to-back writes).
  lapicw(ESR, 0);
80102e22:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e29:	00 
80102e2a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e31:	e8 02 ff ff ff       	call   80102d38 <lapicw>
  lapicw(ESR, 0);
80102e36:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e3d:	00 
80102e3e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80102e45:	e8 ee fe ff ff       	call   80102d38 <lapicw>

  // Ack any outstanding interrupts.
  lapicw(EOI, 0);
80102e4a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e51:	00 
80102e52:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102e59:	e8 da fe ff ff       	call   80102d38 <lapicw>

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
80102e5e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102e65:	00 
80102e66:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102e6d:	e8 c6 fe ff ff       	call   80102d38 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
80102e72:	c7 44 24 04 00 85 08 	movl   $0x88500,0x4(%esp)
80102e79:	00 
80102e7a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102e81:	e8 b2 fe ff ff       	call   80102d38 <lapicw>
  while(lapic[ICRLO] & DELIVS)
80102e86:	90                   	nop
80102e87:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102e8c:	05 00 03 00 00       	add    $0x300,%eax
80102e91:	8b 00                	mov    (%eax),%eax
80102e93:	25 00 10 00 00       	and    $0x1000,%eax
80102e98:	85 c0                	test   %eax,%eax
80102e9a:	75 eb                	jne    80102e87 <lapicinit+0x12e>
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
80102e9c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102ea3:	00 
80102ea4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80102eab:	e8 88 fe ff ff       	call   80102d38 <lapicw>
}
80102eb0:	c9                   	leave  
80102eb1:	c3                   	ret    

80102eb2 <cpunum>:

int
cpunum(void)
{
80102eb2:	55                   	push   %ebp
80102eb3:	89 e5                	mov    %esp,%ebp
80102eb5:	83 ec 18             	sub    $0x18,%esp
  // Cannot call cpu when interrupts are enabled:
  // result not guaranteed to last long enough to be used!
  // Would prefer to panic but even printing is chancy here:
  // almost everything, including cprintf and panic, calls cpu,
  // often indirectly through acquire and release.
  if(readeflags()&FL_IF){
80102eb8:	e8 6b fe ff ff       	call   80102d28 <readeflags>
80102ebd:	25 00 02 00 00       	and    $0x200,%eax
80102ec2:	85 c0                	test   %eax,%eax
80102ec4:	74 25                	je     80102eeb <cpunum+0x39>
    static int n;
    if(n++ == 0)
80102ec6:	a1 60 c6 10 80       	mov    0x8010c660,%eax
80102ecb:	8d 50 01             	lea    0x1(%eax),%edx
80102ece:	89 15 60 c6 10 80    	mov    %edx,0x8010c660
80102ed4:	85 c0                	test   %eax,%eax
80102ed6:	75 13                	jne    80102eeb <cpunum+0x39>
      cprintf("cpu called from %x with interrupts enabled\n",
80102ed8:	8b 45 04             	mov    0x4(%ebp),%eax
80102edb:	89 44 24 04          	mov    %eax,0x4(%esp)
80102edf:	c7 04 24 3c 8f 10 80 	movl   $0x80108f3c,(%esp)
80102ee6:	e8 b5 d4 ff ff       	call   801003a0 <cprintf>
        __builtin_return_address(0));
  }

  if(lapic)
80102eeb:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ef0:	85 c0                	test   %eax,%eax
80102ef2:	74 0f                	je     80102f03 <cpunum+0x51>
    return lapic[ID]>>24;
80102ef4:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102ef9:	83 c0 20             	add    $0x20,%eax
80102efc:	8b 00                	mov    (%eax),%eax
80102efe:	c1 e8 18             	shr    $0x18,%eax
80102f01:	eb 05                	jmp    80102f08 <cpunum+0x56>
  return 0;
80102f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102f08:	c9                   	leave  
80102f09:	c3                   	ret    

80102f0a <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102f0a:	55                   	push   %ebp
80102f0b:	89 e5                	mov    %esp,%ebp
80102f0d:	83 ec 08             	sub    $0x8,%esp
  if(lapic)
80102f10:	a1 7c 32 11 80       	mov    0x8011327c,%eax
80102f15:	85 c0                	test   %eax,%eax
80102f17:	74 14                	je     80102f2d <lapiceoi+0x23>
    lapicw(EOI, 0);
80102f19:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80102f20:	00 
80102f21:	c7 04 24 2c 00 00 00 	movl   $0x2c,(%esp)
80102f28:	e8 0b fe ff ff       	call   80102d38 <lapicw>
}
80102f2d:	c9                   	leave  
80102f2e:	c3                   	ret    

80102f2f <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102f2f:	55                   	push   %ebp
80102f30:	89 e5                	mov    %esp,%ebp
}
80102f32:	5d                   	pop    %ebp
80102f33:	c3                   	ret    

80102f34 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102f34:	55                   	push   %ebp
80102f35:	89 e5                	mov    %esp,%ebp
80102f37:	83 ec 1c             	sub    $0x1c,%esp
80102f3a:	8b 45 08             	mov    0x8(%ebp),%eax
80102f3d:	88 45 ec             	mov    %al,-0x14(%ebp)
  ushort *wrv;
  
  // "The BSP must initialize CMOS shutdown code to 0AH
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
80102f40:	c7 44 24 04 0f 00 00 	movl   $0xf,0x4(%esp)
80102f47:	00 
80102f48:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80102f4f:	e8 b6 fd ff ff       	call   80102d0a <outb>
  outb(CMOS_PORT+1, 0x0A);
80102f54:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80102f5b:	00 
80102f5c:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
80102f63:	e8 a2 fd ff ff       	call   80102d0a <outb>
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
80102f68:	c7 45 f8 67 04 00 80 	movl   $0x80000467,-0x8(%ebp)
  wrv[0] = 0;
80102f6f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f72:	66 c7 00 00 00       	movw   $0x0,(%eax)
  wrv[1] = addr >> 4;
80102f77:	8b 45 f8             	mov    -0x8(%ebp),%eax
80102f7a:	8d 50 02             	lea    0x2(%eax),%edx
80102f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
80102f80:	c1 e8 04             	shr    $0x4,%eax
80102f83:	66 89 02             	mov    %ax,(%edx)

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102f86:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102f8a:	c1 e0 18             	shl    $0x18,%eax
80102f8d:	89 44 24 04          	mov    %eax,0x4(%esp)
80102f91:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102f98:	e8 9b fd ff ff       	call   80102d38 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102f9d:	c7 44 24 04 00 c5 00 	movl   $0xc500,0x4(%esp)
80102fa4:	00 
80102fa5:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fac:	e8 87 fd ff ff       	call   80102d38 <lapicw>
  microdelay(200);
80102fb1:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80102fb8:	e8 72 ff ff ff       	call   80102f2f <microdelay>
  lapicw(ICRLO, INIT | LEVEL);
80102fbd:	c7 44 24 04 00 85 00 	movl   $0x8500,0x4(%esp)
80102fc4:	00 
80102fc5:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80102fcc:	e8 67 fd ff ff       	call   80102d38 <lapicw>
  microdelay(100);    // should be 10ms, but too slow in Bochs!
80102fd1:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
80102fd8:	e8 52 ff ff ff       	call   80102f2f <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80102fdd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80102fe4:	eb 40                	jmp    80103026 <lapicstartap+0xf2>
    lapicw(ICRHI, apicid<<24);
80102fe6:	0f b6 45 ec          	movzbl -0x14(%ebp),%eax
80102fea:	c1 e0 18             	shl    $0x18,%eax
80102fed:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ff1:	c7 04 24 c4 00 00 00 	movl   $0xc4,(%esp)
80102ff8:	e8 3b fd ff ff       	call   80102d38 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
80102ffd:	8b 45 0c             	mov    0xc(%ebp),%eax
80103000:	c1 e8 0c             	shr    $0xc,%eax
80103003:	80 cc 06             	or     $0x6,%ah
80103006:	89 44 24 04          	mov    %eax,0x4(%esp)
8010300a:	c7 04 24 c0 00 00 00 	movl   $0xc0,(%esp)
80103011:	e8 22 fd ff ff       	call   80102d38 <lapicw>
    microdelay(200);
80103016:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
8010301d:	e8 0d ff ff ff       	call   80102f2f <microdelay>
  // Send startup IPI (twice!) to enter code.
  // Regular hardware is supposed to only accept a STARTUP
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
80103022:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80103026:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
8010302a:	7e ba                	jle    80102fe6 <lapicstartap+0xb2>
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
8010302c:	c9                   	leave  
8010302d:	c3                   	ret    

8010302e <cmos_read>:
#define DAY     0x07
#define MONTH   0x08
#define YEAR    0x09

static uint cmos_read(uint reg)
{
8010302e:	55                   	push   %ebp
8010302f:	89 e5                	mov    %esp,%ebp
80103031:	83 ec 08             	sub    $0x8,%esp
  outb(CMOS_PORT,  reg);
80103034:	8b 45 08             	mov    0x8(%ebp),%eax
80103037:	0f b6 c0             	movzbl %al,%eax
8010303a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010303e:	c7 04 24 70 00 00 00 	movl   $0x70,(%esp)
80103045:	e8 c0 fc ff ff       	call   80102d0a <outb>
  microdelay(200);
8010304a:	c7 04 24 c8 00 00 00 	movl   $0xc8,(%esp)
80103051:	e8 d9 fe ff ff       	call   80102f2f <microdelay>

  return inb(CMOS_RETURN);
80103056:	c7 04 24 71 00 00 00 	movl   $0x71,(%esp)
8010305d:	e8 8b fc ff ff       	call   80102ced <inb>
80103062:	0f b6 c0             	movzbl %al,%eax
}
80103065:	c9                   	leave  
80103066:	c3                   	ret    

80103067 <fill_rtcdate>:

static void fill_rtcdate(struct rtcdate *r)
{
80103067:	55                   	push   %ebp
80103068:	89 e5                	mov    %esp,%ebp
8010306a:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
8010306d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80103074:	e8 b5 ff ff ff       	call   8010302e <cmos_read>
80103079:	8b 55 08             	mov    0x8(%ebp),%edx
8010307c:	89 02                	mov    %eax,(%edx)
  r->minute = cmos_read(MINS);
8010307e:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80103085:	e8 a4 ff ff ff       	call   8010302e <cmos_read>
8010308a:	8b 55 08             	mov    0x8(%ebp),%edx
8010308d:	89 42 04             	mov    %eax,0x4(%edx)
  r->hour   = cmos_read(HOURS);
80103090:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80103097:	e8 92 ff ff ff       	call   8010302e <cmos_read>
8010309c:	8b 55 08             	mov    0x8(%ebp),%edx
8010309f:	89 42 08             	mov    %eax,0x8(%edx)
  r->day    = cmos_read(DAY);
801030a2:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
801030a9:	e8 80 ff ff ff       	call   8010302e <cmos_read>
801030ae:	8b 55 08             	mov    0x8(%ebp),%edx
801030b1:	89 42 0c             	mov    %eax,0xc(%edx)
  r->month  = cmos_read(MONTH);
801030b4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801030bb:	e8 6e ff ff ff       	call   8010302e <cmos_read>
801030c0:	8b 55 08             	mov    0x8(%ebp),%edx
801030c3:	89 42 10             	mov    %eax,0x10(%edx)
  r->year   = cmos_read(YEAR);
801030c6:	c7 04 24 09 00 00 00 	movl   $0x9,(%esp)
801030cd:	e8 5c ff ff ff       	call   8010302e <cmos_read>
801030d2:	8b 55 08             	mov    0x8(%ebp),%edx
801030d5:	89 42 14             	mov    %eax,0x14(%edx)
}
801030d8:	c9                   	leave  
801030d9:	c3                   	ret    

801030da <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void cmostime(struct rtcdate *r)
{
801030da:	55                   	push   %ebp
801030db:	89 e5                	mov    %esp,%ebp
801030dd:	83 ec 58             	sub    $0x58,%esp
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801030e0:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
801030e7:	e8 42 ff ff ff       	call   8010302e <cmos_read>
801030ec:	89 45 f4             	mov    %eax,-0xc(%ebp)

  bcd = (sb & (1 << 2)) == 0;
801030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801030f2:	83 e0 04             	and    $0x4,%eax
801030f5:	85 c0                	test   %eax,%eax
801030f7:	0f 94 c0             	sete   %al
801030fa:	0f b6 c0             	movzbl %al,%eax
801030fd:	89 45 f0             	mov    %eax,-0x10(%ebp)

  // make sure CMOS doesn't modify time while we read it
  for (;;) {
    fill_rtcdate(&t1);
80103100:	8d 45 d8             	lea    -0x28(%ebp),%eax
80103103:	89 04 24             	mov    %eax,(%esp)
80103106:	e8 5c ff ff ff       	call   80103067 <fill_rtcdate>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
8010310b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80103112:	e8 17 ff ff ff       	call   8010302e <cmos_read>
80103117:	25 80 00 00 00       	and    $0x80,%eax
8010311c:	85 c0                	test   %eax,%eax
8010311e:	74 02                	je     80103122 <cmostime+0x48>
        continue;
80103120:	eb 36                	jmp    80103158 <cmostime+0x7e>
    fill_rtcdate(&t2);
80103122:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103125:	89 04 24             	mov    %eax,(%esp)
80103128:	e8 3a ff ff ff       	call   80103067 <fill_rtcdate>
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
8010312d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
80103134:	00 
80103135:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103138:	89 44 24 04          	mov    %eax,0x4(%esp)
8010313c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010313f:	89 04 24             	mov    %eax,(%esp)
80103142:	e8 77 26 00 00       	call   801057be <memcmp>
80103147:	85 c0                	test   %eax,%eax
80103149:	75 0d                	jne    80103158 <cmostime+0x7e>
      break;
8010314b:	90                   	nop
  }

  // convert
  if (bcd) {
8010314c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103150:	0f 84 ac 00 00 00    	je     80103202 <cmostime+0x128>
80103156:	eb 02                	jmp    8010315a <cmostime+0x80>
    if (cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if (memcmp(&t1, &t2, sizeof(t1)) == 0)
      break;
  }
80103158:	eb a6                	jmp    80103100 <cmostime+0x26>

  // convert
  if (bcd) {
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010315a:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010315d:	c1 e8 04             	shr    $0x4,%eax
80103160:	89 c2                	mov    %eax,%edx
80103162:	89 d0                	mov    %edx,%eax
80103164:	c1 e0 02             	shl    $0x2,%eax
80103167:	01 d0                	add    %edx,%eax
80103169:	01 c0                	add    %eax,%eax
8010316b:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010316e:	83 e2 0f             	and    $0xf,%edx
80103171:	01 d0                	add    %edx,%eax
80103173:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(minute);
80103176:	8b 45 dc             	mov    -0x24(%ebp),%eax
80103179:	c1 e8 04             	shr    $0x4,%eax
8010317c:	89 c2                	mov    %eax,%edx
8010317e:	89 d0                	mov    %edx,%eax
80103180:	c1 e0 02             	shl    $0x2,%eax
80103183:	01 d0                	add    %edx,%eax
80103185:	01 c0                	add    %eax,%eax
80103187:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010318a:	83 e2 0f             	and    $0xf,%edx
8010318d:	01 d0                	add    %edx,%eax
8010318f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(hour  );
80103192:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103195:	c1 e8 04             	shr    $0x4,%eax
80103198:	89 c2                	mov    %eax,%edx
8010319a:	89 d0                	mov    %edx,%eax
8010319c:	c1 e0 02             	shl    $0x2,%eax
8010319f:	01 d0                	add    %edx,%eax
801031a1:	01 c0                	add    %eax,%eax
801031a3:	8b 55 e0             	mov    -0x20(%ebp),%edx
801031a6:	83 e2 0f             	and    $0xf,%edx
801031a9:	01 d0                	add    %edx,%eax
801031ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(day   );
801031ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801031b1:	c1 e8 04             	shr    $0x4,%eax
801031b4:	89 c2                	mov    %eax,%edx
801031b6:	89 d0                	mov    %edx,%eax
801031b8:	c1 e0 02             	shl    $0x2,%eax
801031bb:	01 d0                	add    %edx,%eax
801031bd:	01 c0                	add    %eax,%eax
801031bf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801031c2:	83 e2 0f             	and    $0xf,%edx
801031c5:	01 d0                	add    %edx,%eax
801031c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    CONV(month );
801031ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
801031cd:	c1 e8 04             	shr    $0x4,%eax
801031d0:	89 c2                	mov    %eax,%edx
801031d2:	89 d0                	mov    %edx,%eax
801031d4:	c1 e0 02             	shl    $0x2,%eax
801031d7:	01 d0                	add    %edx,%eax
801031d9:	01 c0                	add    %eax,%eax
801031db:	8b 55 e8             	mov    -0x18(%ebp),%edx
801031de:	83 e2 0f             	and    $0xf,%edx
801031e1:	01 d0                	add    %edx,%eax
801031e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    CONV(year  );
801031e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
801031e9:	c1 e8 04             	shr    $0x4,%eax
801031ec:	89 c2                	mov    %eax,%edx
801031ee:	89 d0                	mov    %edx,%eax
801031f0:	c1 e0 02             	shl    $0x2,%eax
801031f3:	01 d0                	add    %edx,%eax
801031f5:	01 c0                	add    %eax,%eax
801031f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
801031fa:	83 e2 0f             	and    $0xf,%edx
801031fd:	01 d0                	add    %edx,%eax
801031ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
#undef     CONV
  }

  *r = t1;
80103202:	8b 45 08             	mov    0x8(%ebp),%eax
80103205:	8b 55 d8             	mov    -0x28(%ebp),%edx
80103208:	89 10                	mov    %edx,(%eax)
8010320a:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010320d:	89 50 04             	mov    %edx,0x4(%eax)
80103210:	8b 55 e0             	mov    -0x20(%ebp),%edx
80103213:	89 50 08             	mov    %edx,0x8(%eax)
80103216:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103219:	89 50 0c             	mov    %edx,0xc(%eax)
8010321c:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010321f:	89 50 10             	mov    %edx,0x10(%eax)
80103222:	8b 55 ec             	mov    -0x14(%ebp),%edx
80103225:	89 50 14             	mov    %edx,0x14(%eax)
  r->year += 2000;
80103228:	8b 45 08             	mov    0x8(%ebp),%eax
8010322b:	8b 40 14             	mov    0x14(%eax),%eax
8010322e:	8d 90 d0 07 00 00    	lea    0x7d0(%eax),%edx
80103234:	8b 45 08             	mov    0x8(%ebp),%eax
80103237:	89 50 14             	mov    %edx,0x14(%eax)
}
8010323a:	c9                   	leave  
8010323b:	c3                   	ret    

8010323c <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(void)
{
8010323c:	55                   	push   %ebp
8010323d:	89 e5                	mov    %esp,%ebp
8010323f:	83 ec 28             	sub    $0x28,%esp
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80103242:	c7 44 24 04 68 8f 10 	movl   $0x80108f68,0x4(%esp)
80103249:	80 
8010324a:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103251:	e8 77 22 00 00       	call   801054cd <initlock>
  readsb(ROOTDEV, &sb);
80103256:	8d 45 e8             	lea    -0x18(%ebp),%eax
80103259:	89 44 24 04          	mov    %eax,0x4(%esp)
8010325d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103264:	e8 c2 e0 ff ff       	call   8010132b <readsb>
  log.start = sb.size - sb.nlog;
80103269:	8b 55 e8             	mov    -0x18(%ebp),%edx
8010326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010326f:	29 c2                	sub    %eax,%edx
80103271:	89 d0                	mov    %edx,%eax
80103273:	a3 b4 32 11 80       	mov    %eax,0x801132b4
  log.size = sb.nlog;
80103278:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010327b:	a3 b8 32 11 80       	mov    %eax,0x801132b8
  log.dev = ROOTDEV;
80103280:	c7 05 c4 32 11 80 01 	movl   $0x1,0x801132c4
80103287:	00 00 00 
  recover_from_log();
8010328a:	e8 9a 01 00 00       	call   80103429 <recover_from_log>
}
8010328f:	c9                   	leave  
80103290:	c3                   	ret    

80103291 <install_trans>:

// Copy committed blocks from log to their home location
static void 
install_trans(void)
{
80103291:	55                   	push   %ebp
80103292:	89 e5                	mov    %esp,%ebp
80103294:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103297:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010329e:	e9 8c 00 00 00       	jmp    8010332f <install_trans+0x9e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801032a3:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
801032a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032ac:	01 d0                	add    %edx,%eax
801032ae:	83 c0 01             	add    $0x1,%eax
801032b1:	89 c2                	mov    %eax,%edx
801032b3:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801032b8:	89 54 24 04          	mov    %edx,0x4(%esp)
801032bc:	89 04 24             	mov    %eax,(%esp)
801032bf:	e8 e2 ce ff ff       	call   801001a6 <bread>
801032c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *dbuf = bread(log.dev, log.lh.sector[tail]); // read dst
801032c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801032ca:	83 c0 10             	add    $0x10,%eax
801032cd:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801032d4:	89 c2                	mov    %eax,%edx
801032d6:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801032db:	89 54 24 04          	mov    %edx,0x4(%esp)
801032df:	89 04 24             	mov    %eax,(%esp)
801032e2:	e8 bf ce ff ff       	call   801001a6 <bread>
801032e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801032ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801032ed:	8d 50 18             	lea    0x18(%eax),%edx
801032f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
801032f3:	83 c0 18             	add    $0x18,%eax
801032f6:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801032fd:	00 
801032fe:	89 54 24 04          	mov    %edx,0x4(%esp)
80103302:	89 04 24             	mov    %eax,(%esp)
80103305:	e8 0c 25 00 00       	call   80105816 <memmove>
    bwrite(dbuf);  // write dst to disk
8010330a:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010330d:	89 04 24             	mov    %eax,(%esp)
80103310:	e8 c8 ce ff ff       	call   801001dd <bwrite>
    brelse(lbuf); 
80103315:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103318:	89 04 24             	mov    %eax,(%esp)
8010331b:	e8 f7 ce ff ff       	call   80100217 <brelse>
    brelse(dbuf);
80103320:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103323:	89 04 24             	mov    %eax,(%esp)
80103326:	e8 ec ce ff ff       	call   80100217 <brelse>
static void 
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010332b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
8010332f:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103334:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103337:	0f 8f 66 ff ff ff    	jg     801032a3 <install_trans+0x12>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf); 
    brelse(dbuf);
  }
}
8010333d:	c9                   	leave  
8010333e:	c3                   	ret    

8010333f <read_head>:

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
8010333f:	55                   	push   %ebp
80103340:	89 e5                	mov    %esp,%ebp
80103342:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
80103345:	a1 b4 32 11 80       	mov    0x801132b4,%eax
8010334a:	89 c2                	mov    %eax,%edx
8010334c:	a1 c4 32 11 80       	mov    0x801132c4,%eax
80103351:	89 54 24 04          	mov    %edx,0x4(%esp)
80103355:	89 04 24             	mov    %eax,(%esp)
80103358:	e8 49 ce ff ff       	call   801001a6 <bread>
8010335d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *lh = (struct logheader *) (buf->data);
80103360:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103363:	83 c0 18             	add    $0x18,%eax
80103366:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  log.lh.n = lh->n;
80103369:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010336c:	8b 00                	mov    (%eax),%eax
8010336e:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  for (i = 0; i < log.lh.n; i++) {
80103373:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
8010337a:	eb 1b                	jmp    80103397 <read_head+0x58>
    log.lh.sector[i] = lh->sector[i];
8010337c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010337f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103382:	8b 44 90 04          	mov    0x4(%eax,%edx,4),%eax
80103386:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103389:	83 c2 10             	add    $0x10,%edx
8010338c:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80103393:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103397:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010339c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010339f:	7f db                	jg     8010337c <read_head+0x3d>
    log.lh.sector[i] = lh->sector[i];
  }
  brelse(buf);
801033a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033a4:	89 04 24             	mov    %eax,(%esp)
801033a7:	e8 6b ce ff ff       	call   80100217 <brelse>
}
801033ac:	c9                   	leave  
801033ad:	c3                   	ret    

801033ae <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801033ae:	55                   	push   %ebp
801033af:	89 e5                	mov    %esp,%ebp
801033b1:	83 ec 28             	sub    $0x28,%esp
  struct buf *buf = bread(log.dev, log.start);
801033b4:	a1 b4 32 11 80       	mov    0x801132b4,%eax
801033b9:	89 c2                	mov    %eax,%edx
801033bb:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801033c0:	89 54 24 04          	mov    %edx,0x4(%esp)
801033c4:	89 04 24             	mov    %eax,(%esp)
801033c7:	e8 da cd ff ff       	call   801001a6 <bread>
801033cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  struct logheader *hb = (struct logheader *) (buf->data);
801033cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801033d2:	83 c0 18             	add    $0x18,%eax
801033d5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  int i;
  hb->n = log.lh.n;
801033d8:	8b 15 c8 32 11 80    	mov    0x801132c8,%edx
801033de:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033e1:	89 10                	mov    %edx,(%eax)
  for (i = 0; i < log.lh.n; i++) {
801033e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801033ea:	eb 1b                	jmp    80103407 <write_head+0x59>
    hb->sector[i] = log.lh.sector[i];
801033ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
801033ef:	83 c0 10             	add    $0x10,%eax
801033f2:	8b 0c 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%ecx
801033f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
801033fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801033ff:	89 4c 90 04          	mov    %ecx,0x4(%eax,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80103403:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103407:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010340c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010340f:	7f db                	jg     801033ec <write_head+0x3e>
    hb->sector[i] = log.lh.sector[i];
  }
  bwrite(buf);
80103411:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103414:	89 04 24             	mov    %eax,(%esp)
80103417:	e8 c1 cd ff ff       	call   801001dd <bwrite>
  brelse(buf);
8010341c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010341f:	89 04 24             	mov    %eax,(%esp)
80103422:	e8 f0 cd ff ff       	call   80100217 <brelse>
}
80103427:	c9                   	leave  
80103428:	c3                   	ret    

80103429 <recover_from_log>:

static void
recover_from_log(void)
{
80103429:	55                   	push   %ebp
8010342a:	89 e5                	mov    %esp,%ebp
8010342c:	83 ec 08             	sub    $0x8,%esp
  read_head();      
8010342f:	e8 0b ff ff ff       	call   8010333f <read_head>
  install_trans(); // if committed, copy from log to disk
80103434:	e8 58 fe ff ff       	call   80103291 <install_trans>
  log.lh.n = 0;
80103439:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
80103440:	00 00 00 
  write_head(); // clear the log
80103443:	e8 66 ff ff ff       	call   801033ae <write_head>
}
80103448:	c9                   	leave  
80103449:	c3                   	ret    

8010344a <begin_op>:

// called at the start of each FS system call.
void
begin_op(void)
{
8010344a:	55                   	push   %ebp
8010344b:	89 e5                	mov    %esp,%ebp
8010344d:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80103450:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103457:	e8 92 20 00 00       	call   801054ee <acquire>
  while(1){
    if(log.committing){
8010345c:	a1 c0 32 11 80       	mov    0x801132c0,%eax
80103461:	85 c0                	test   %eax,%eax
80103463:	74 16                	je     8010347b <begin_op+0x31>
      sleep(&log, &log.lock);
80103465:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
8010346c:	80 
8010346d:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103474:	e8 a3 1a 00 00       	call   80104f1c <sleep>
80103479:	eb 4f                	jmp    801034ca <begin_op+0x80>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010347b:	8b 0d c8 32 11 80    	mov    0x801132c8,%ecx
80103481:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103486:	8d 50 01             	lea    0x1(%eax),%edx
80103489:	89 d0                	mov    %edx,%eax
8010348b:	c1 e0 02             	shl    $0x2,%eax
8010348e:	01 d0                	add    %edx,%eax
80103490:	01 c0                	add    %eax,%eax
80103492:	01 c8                	add    %ecx,%eax
80103494:	83 f8 1e             	cmp    $0x1e,%eax
80103497:	7e 16                	jle    801034af <begin_op+0x65>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
80103499:	c7 44 24 04 80 32 11 	movl   $0x80113280,0x4(%esp)
801034a0:	80 
801034a1:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034a8:	e8 6f 1a 00 00       	call   80104f1c <sleep>
801034ad:	eb 1b                	jmp    801034ca <begin_op+0x80>
    } else {
      log.outstanding += 1;
801034af:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034b4:	83 c0 01             	add    $0x1,%eax
801034b7:	a3 bc 32 11 80       	mov    %eax,0x801132bc
      release(&log.lock);
801034bc:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034c3:	e8 8d 20 00 00       	call   80105555 <release>
      break;
801034c8:	eb 02                	jmp    801034cc <begin_op+0x82>
    }
  }
801034ca:	eb 90                	jmp    8010345c <begin_op+0x12>
}
801034cc:	c9                   	leave  
801034cd:	c3                   	ret    

801034ce <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
801034ce:	55                   	push   %ebp
801034cf:	89 e5                	mov    %esp,%ebp
801034d1:	83 ec 28             	sub    $0x28,%esp
  int do_commit = 0;
801034d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

  acquire(&log.lock);
801034db:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
801034e2:	e8 07 20 00 00       	call   801054ee <acquire>
  log.outstanding -= 1;
801034e7:	a1 bc 32 11 80       	mov    0x801132bc,%eax
801034ec:	83 e8 01             	sub    $0x1,%eax
801034ef:	a3 bc 32 11 80       	mov    %eax,0x801132bc
  if(log.committing)
801034f4:	a1 c0 32 11 80       	mov    0x801132c0,%eax
801034f9:	85 c0                	test   %eax,%eax
801034fb:	74 0c                	je     80103509 <end_op+0x3b>
    panic("log.committing");
801034fd:	c7 04 24 6c 8f 10 80 	movl   $0x80108f6c,(%esp)
80103504:	e8 31 d0 ff ff       	call   8010053a <panic>
  if(log.outstanding == 0){
80103509:	a1 bc 32 11 80       	mov    0x801132bc,%eax
8010350e:	85 c0                	test   %eax,%eax
80103510:	75 13                	jne    80103525 <end_op+0x57>
    do_commit = 1;
80103512:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
    log.committing = 1;
80103519:	c7 05 c0 32 11 80 01 	movl   $0x1,0x801132c0
80103520:	00 00 00 
80103523:	eb 0c                	jmp    80103531 <end_op+0x63>
  } else {
    // begin_op() may be waiting for log space.
    wakeup(&log);
80103525:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010352c:	e8 d7 1a 00 00       	call   80105008 <wakeup>
  }
  release(&log.lock);
80103531:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103538:	e8 18 20 00 00       	call   80105555 <release>

  if(do_commit){
8010353d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103541:	74 33                	je     80103576 <end_op+0xa8>
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
80103543:	e8 de 00 00 00       	call   80103626 <commit>
    acquire(&log.lock);
80103548:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010354f:	e8 9a 1f 00 00       	call   801054ee <acquire>
    log.committing = 0;
80103554:	c7 05 c0 32 11 80 00 	movl   $0x0,0x801132c0
8010355b:	00 00 00 
    wakeup(&log);
8010355e:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103565:	e8 9e 1a 00 00       	call   80105008 <wakeup>
    release(&log.lock);
8010356a:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103571:	e8 df 1f 00 00       	call   80105555 <release>
  }
}
80103576:	c9                   	leave  
80103577:	c3                   	ret    

80103578 <write_log>:

// Copy modified blocks from cache to log.
static void 
write_log(void)
{
80103578:	55                   	push   %ebp
80103579:	89 e5                	mov    %esp,%ebp
8010357b:	83 ec 28             	sub    $0x28,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010357e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80103585:	e9 8c 00 00 00       	jmp    80103616 <write_log+0x9e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
8010358a:	8b 15 b4 32 11 80    	mov    0x801132b4,%edx
80103590:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103593:	01 d0                	add    %edx,%eax
80103595:	83 c0 01             	add    $0x1,%eax
80103598:	89 c2                	mov    %eax,%edx
8010359a:	a1 c4 32 11 80       	mov    0x801132c4,%eax
8010359f:	89 54 24 04          	mov    %edx,0x4(%esp)
801035a3:	89 04 24             	mov    %eax,(%esp)
801035a6:	e8 fb cb ff ff       	call   801001a6 <bread>
801035ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct buf *from = bread(log.dev, log.lh.sector[tail]); // cache block
801035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
801035b1:	83 c0 10             	add    $0x10,%eax
801035b4:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801035bb:	89 c2                	mov    %eax,%edx
801035bd:	a1 c4 32 11 80       	mov    0x801132c4,%eax
801035c2:	89 54 24 04          	mov    %edx,0x4(%esp)
801035c6:	89 04 24             	mov    %eax,(%esp)
801035c9:	e8 d8 cb ff ff       	call   801001a6 <bread>
801035ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
    memmove(to->data, from->data, BSIZE);
801035d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035d4:	8d 50 18             	lea    0x18(%eax),%edx
801035d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035da:	83 c0 18             	add    $0x18,%eax
801035dd:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801035e4:	00 
801035e5:	89 54 24 04          	mov    %edx,0x4(%esp)
801035e9:	89 04 24             	mov    %eax,(%esp)
801035ec:	e8 25 22 00 00       	call   80105816 <memmove>
    bwrite(to);  // write the log
801035f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801035f4:	89 04 24             	mov    %eax,(%esp)
801035f7:	e8 e1 cb ff ff       	call   801001dd <bwrite>
    brelse(from); 
801035fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
801035ff:	89 04 24             	mov    %eax,(%esp)
80103602:	e8 10 cc ff ff       	call   80100217 <brelse>
    brelse(to);
80103607:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010360a:	89 04 24             	mov    %eax,(%esp)
8010360d:	e8 05 cc ff ff       	call   80100217 <brelse>
static void 
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80103612:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80103616:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010361b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010361e:	0f 8f 66 ff ff ff    	jg     8010358a <write_log+0x12>
    memmove(to->data, from->data, BSIZE);
    bwrite(to);  // write the log
    brelse(from); 
    brelse(to);
  }
}
80103624:	c9                   	leave  
80103625:	c3                   	ret    

80103626 <commit>:

static void
commit()
{
80103626:	55                   	push   %ebp
80103627:	89 e5                	mov    %esp,%ebp
80103629:	83 ec 08             	sub    $0x8,%esp
  if (log.lh.n > 0) {
8010362c:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103631:	85 c0                	test   %eax,%eax
80103633:	7e 1e                	jle    80103653 <commit+0x2d>
    write_log();     // Write modified blocks from cache to log
80103635:	e8 3e ff ff ff       	call   80103578 <write_log>
    write_head();    // Write header to disk -- the real commit
8010363a:	e8 6f fd ff ff       	call   801033ae <write_head>
    install_trans(); // Now install writes to home locations
8010363f:	e8 4d fc ff ff       	call   80103291 <install_trans>
    log.lh.n = 0; 
80103644:	c7 05 c8 32 11 80 00 	movl   $0x0,0x801132c8
8010364b:	00 00 00 
    write_head();    // Erase the transaction from the log
8010364e:	e8 5b fd ff ff       	call   801033ae <write_head>
  }
}
80103653:	c9                   	leave  
80103654:	c3                   	ret    

80103655 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80103655:	55                   	push   %ebp
80103656:	89 e5                	mov    %esp,%ebp
80103658:	83 ec 28             	sub    $0x28,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010365b:	a1 c8 32 11 80       	mov    0x801132c8,%eax
80103660:	83 f8 1d             	cmp    $0x1d,%eax
80103663:	7f 12                	jg     80103677 <log_write+0x22>
80103665:	a1 c8 32 11 80       	mov    0x801132c8,%eax
8010366a:	8b 15 b8 32 11 80    	mov    0x801132b8,%edx
80103670:	83 ea 01             	sub    $0x1,%edx
80103673:	39 d0                	cmp    %edx,%eax
80103675:	7c 0c                	jl     80103683 <log_write+0x2e>
    panic("too big a transaction");
80103677:	c7 04 24 7b 8f 10 80 	movl   $0x80108f7b,(%esp)
8010367e:	e8 b7 ce ff ff       	call   8010053a <panic>
  if (log.outstanding < 1)
80103683:	a1 bc 32 11 80       	mov    0x801132bc,%eax
80103688:	85 c0                	test   %eax,%eax
8010368a:	7f 0c                	jg     80103698 <log_write+0x43>
    panic("log_write outside of trans");
8010368c:	c7 04 24 91 8f 10 80 	movl   $0x80108f91,(%esp)
80103693:	e8 a2 ce ff ff       	call   8010053a <panic>

  acquire(&log.lock);
80103698:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
8010369f:	e8 4a 1e 00 00       	call   801054ee <acquire>
  for (i = 0; i < log.lh.n; i++) {
801036a4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801036ab:	eb 1f                	jmp    801036cc <log_write+0x77>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
801036ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801036b0:	83 c0 10             	add    $0x10,%eax
801036b3:	8b 04 85 8c 32 11 80 	mov    -0x7feecd74(,%eax,4),%eax
801036ba:	89 c2                	mov    %eax,%edx
801036bc:	8b 45 08             	mov    0x8(%ebp),%eax
801036bf:	8b 40 08             	mov    0x8(%eax),%eax
801036c2:	39 c2                	cmp    %eax,%edx
801036c4:	75 02                	jne    801036c8 <log_write+0x73>
      break;
801036c6:	eb 0e                	jmp    801036d6 <log_write+0x81>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
801036c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801036cc:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036d1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036d4:	7f d7                	jg     801036ad <log_write+0x58>
    if (log.lh.sector[i] == b->sector)   // log absorbtion
      break;
  }
  log.lh.sector[i] = b->sector;
801036d6:	8b 45 08             	mov    0x8(%ebp),%eax
801036d9:	8b 40 08             	mov    0x8(%eax),%eax
801036dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801036df:	83 c2 10             	add    $0x10,%edx
801036e2:	89 04 95 8c 32 11 80 	mov    %eax,-0x7feecd74(,%edx,4)
  if (i == log.lh.n)
801036e9:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801036f1:	75 0d                	jne    80103700 <log_write+0xab>
    log.lh.n++;
801036f3:	a1 c8 32 11 80       	mov    0x801132c8,%eax
801036f8:	83 c0 01             	add    $0x1,%eax
801036fb:	a3 c8 32 11 80       	mov    %eax,0x801132c8
  b->flags |= B_DIRTY; // prevent eviction
80103700:	8b 45 08             	mov    0x8(%ebp),%eax
80103703:	8b 00                	mov    (%eax),%eax
80103705:	83 c8 04             	or     $0x4,%eax
80103708:	89 c2                	mov    %eax,%edx
8010370a:	8b 45 08             	mov    0x8(%ebp),%eax
8010370d:	89 10                	mov    %edx,(%eax)
  release(&log.lock);
8010370f:	c7 04 24 80 32 11 80 	movl   $0x80113280,(%esp)
80103716:	e8 3a 1e 00 00       	call   80105555 <release>
}
8010371b:	c9                   	leave  
8010371c:	c3                   	ret    

8010371d <v2p>:
8010371d:	55                   	push   %ebp
8010371e:	89 e5                	mov    %esp,%ebp
80103720:	8b 45 08             	mov    0x8(%ebp),%eax
80103723:	05 00 00 00 80       	add    $0x80000000,%eax
80103728:	5d                   	pop    %ebp
80103729:	c3                   	ret    

8010372a <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
8010372a:	55                   	push   %ebp
8010372b:	89 e5                	mov    %esp,%ebp
8010372d:	8b 45 08             	mov    0x8(%ebp),%eax
80103730:	05 00 00 00 80       	add    $0x80000000,%eax
80103735:	5d                   	pop    %ebp
80103736:	c3                   	ret    

80103737 <xchg>:
  asm volatile("sti");
}

static inline uint
xchg(volatile uint *addr, uint newval)
{
80103737:	55                   	push   %ebp
80103738:	89 e5                	mov    %esp,%ebp
8010373a:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010373d:	8b 55 08             	mov    0x8(%ebp),%edx
80103740:	8b 45 0c             	mov    0xc(%ebp),%eax
80103743:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103746:	f0 87 02             	lock xchg %eax,(%edx)
80103749:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
8010374c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010374f:	c9                   	leave  
80103750:	c3                   	ret    

80103751 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80103751:	55                   	push   %ebp
80103752:	89 e5                	mov    %esp,%ebp
80103754:	83 e4 f0             	and    $0xfffffff0,%esp
80103757:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010375a:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80103761:	80 
80103762:	c7 04 24 5c 6a 11 80 	movl   $0x80116a5c,(%esp)
80103769:	e8 80 f2 ff ff       	call   801029ee <kinit1>
  kvmalloc();      // kernel page table
8010376e:	e8 3b 4e 00 00       	call   801085ae <kvmalloc>
  mpinit();        // collect info about this machine
80103773:	e8 46 04 00 00       	call   80103bbe <mpinit>
  lapicinit();
80103778:	e8 dc f5 ff ff       	call   80102d59 <lapicinit>
  seginit();       // set up segments
8010377d:	e8 bf 47 00 00       	call   80107f41 <seginit>
  cprintf("\ncpu%d: starting xv6\n\n", cpu->id);
80103782:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103788:	0f b6 00             	movzbl (%eax),%eax
8010378b:	0f b6 c0             	movzbl %al,%eax
8010378e:	89 44 24 04          	mov    %eax,0x4(%esp)
80103792:	c7 04 24 ac 8f 10 80 	movl   $0x80108fac,(%esp)
80103799:	e8 02 cc ff ff       	call   801003a0 <cprintf>
  picinit();       // interrupt controller
8010379e:	e8 79 06 00 00       	call   80103e1c <picinit>
  ioapicinit();    // another interrupt controller
801037a3:	e8 3c f1 ff ff       	call   801028e4 <ioapicinit>
  consoleinit();   // I/O devices & their interrupts
801037a8:	e8 d4 d2 ff ff       	call   80100a81 <consoleinit>
  uartinit();      // serial port
801037ad:	e8 de 3a 00 00       	call   80107290 <uartinit>
  pinit();         // process table
801037b2:	e8 6f 0b 00 00       	call   80104326 <pinit>
  tvinit();        // trap vectors
801037b7:	e8 6c 36 00 00       	call   80106e28 <tvinit>
  binit();         // buffer cache
801037bc:	e8 73 c8 ff ff       	call   80100034 <binit>
  fileinit();      // file table
801037c1:	e8 7e d7 ff ff       	call   80100f44 <fileinit>
  iinit();         // inode cache
801037c6:	e8 13 de ff ff       	call   801015de <iinit>
  ideinit();       // disk
801037cb:	e8 7d ed ff ff       	call   8010254d <ideinit>
  if(!ismp)
801037d0:	a1 64 33 11 80       	mov    0x80113364,%eax
801037d5:	85 c0                	test   %eax,%eax
801037d7:	75 05                	jne    801037de <main+0x8d>
    timerinit();   // uniprocessor timer
801037d9:	e8 95 35 00 00       	call   80106d73 <timerinit>
  startothers();   // start other processors
801037de:	e8 7f 00 00 00       	call   80103862 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
801037e3:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
801037ea:	8e 
801037eb:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
801037f2:	e8 2f f2 ff ff       	call   80102a26 <kinit2>
  userinit();      // first user process
801037f7:	e8 92 0c 00 00       	call   8010448e <userinit>
  // Finish setting up this processor in mpmain.
  mpmain();
801037fc:	e8 1a 00 00 00       	call   8010381b <mpmain>

80103801 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80103801:	55                   	push   %ebp
80103802:	89 e5                	mov    %esp,%ebp
80103804:	83 ec 08             	sub    $0x8,%esp
  switchkvm(); 
80103807:	e8 b9 4d 00 00       	call   801085c5 <switchkvm>
  seginit();
8010380c:	e8 30 47 00 00       	call   80107f41 <seginit>
  lapicinit();
80103811:	e8 43 f5 ff ff       	call   80102d59 <lapicinit>
  mpmain();
80103816:	e8 00 00 00 00       	call   8010381b <mpmain>

8010381b <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
8010381b:	55                   	push   %ebp
8010381c:	89 e5                	mov    %esp,%ebp
8010381e:	83 ec 18             	sub    $0x18,%esp
  cprintf("cpu%d: starting\n", cpu->id);
80103821:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103827:	0f b6 00             	movzbl (%eax),%eax
8010382a:	0f b6 c0             	movzbl %al,%eax
8010382d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103831:	c7 04 24 c3 8f 10 80 	movl   $0x80108fc3,(%esp)
80103838:	e8 63 cb ff ff       	call   801003a0 <cprintf>
  idtinit();       // load idt register
8010383d:	e8 5a 37 00 00       	call   80106f9c <idtinit>
  xchg(&cpu->started, 1); // tell startothers() we're up
80103842:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80103848:	05 a8 00 00 00       	add    $0xa8,%eax
8010384d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80103854:	00 
80103855:	89 04 24             	mov    %eax,(%esp)
80103858:	e8 da fe ff ff       	call   80103737 <xchg>
  scheduler();     // start running processes
8010385d:	e8 c9 14 00 00       	call   80104d2b <scheduler>

80103862 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80103862:	55                   	push   %ebp
80103863:	89 e5                	mov    %esp,%ebp
80103865:	53                   	push   %ebx
80103866:	83 ec 24             	sub    $0x24,%esp
  char *stack;

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
80103869:	c7 04 24 00 70 00 00 	movl   $0x7000,(%esp)
80103870:	e8 b5 fe ff ff       	call   8010372a <p2v>
80103875:	89 45 f0             	mov    %eax,-0x10(%ebp)
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103878:	b8 8a 00 00 00       	mov    $0x8a,%eax
8010387d:	89 44 24 08          	mov    %eax,0x8(%esp)
80103881:	c7 44 24 04 2c c5 10 	movl   $0x8010c52c,0x4(%esp)
80103888:	80 
80103889:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010388c:	89 04 24             	mov    %eax,(%esp)
8010388f:	e8 82 1f 00 00       	call   80105816 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103894:	c7 45 f4 80 33 11 80 	movl   $0x80113380,-0xc(%ebp)
8010389b:	e9 85 00 00 00       	jmp    80103925 <startothers+0xc3>
    if(c == cpus+cpunum())  // We've started already.
801038a0:	e8 0d f6 ff ff       	call   80102eb2 <cpunum>
801038a5:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
801038ab:	05 80 33 11 80       	add    $0x80113380,%eax
801038b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801038b3:	75 02                	jne    801038b7 <startothers+0x55>
      continue;
801038b5:	eb 67                	jmp    8010391e <startothers+0xbc>

    // Tell entryother.S what stack to use, where to enter, and what 
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801038b7:	e8 60 f2 ff ff       	call   80102b1c <kalloc>
801038bc:	89 45 ec             	mov    %eax,-0x14(%ebp)
    *(void**)(code-4) = stack + KSTACKSIZE;
801038bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038c2:	83 e8 04             	sub    $0x4,%eax
801038c5:	8b 55 ec             	mov    -0x14(%ebp),%edx
801038c8:	81 c2 00 10 00 00    	add    $0x1000,%edx
801038ce:	89 10                	mov    %edx,(%eax)
    *(void**)(code-8) = mpenter;
801038d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038d3:	83 e8 08             	sub    $0x8,%eax
801038d6:	c7 00 01 38 10 80    	movl   $0x80103801,(%eax)
    *(int**)(code-12) = (void *) v2p(entrypgdir);
801038dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038df:	8d 58 f4             	lea    -0xc(%eax),%ebx
801038e2:	c7 04 24 00 b0 10 80 	movl   $0x8010b000,(%esp)
801038e9:	e8 2f fe ff ff       	call   8010371d <v2p>
801038ee:	89 03                	mov    %eax,(%ebx)

    lapicstartap(c->id, v2p(code));
801038f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801038f3:	89 04 24             	mov    %eax,(%esp)
801038f6:	e8 22 fe ff ff       	call   8010371d <v2p>
801038fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
801038fe:	0f b6 12             	movzbl (%edx),%edx
80103901:	0f b6 d2             	movzbl %dl,%edx
80103904:	89 44 24 04          	mov    %eax,0x4(%esp)
80103908:	89 14 24             	mov    %edx,(%esp)
8010390b:	e8 24 f6 ff ff       	call   80102f34 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103910:	90                   	nop
80103911:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103914:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010391a:	85 c0                	test   %eax,%eax
8010391c:	74 f3                	je     80103911 <startothers+0xaf>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = p2v(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
8010391e:	81 45 f4 bc 00 00 00 	addl   $0xbc,-0xc(%ebp)
80103925:	a1 60 39 11 80       	mov    0x80113960,%eax
8010392a:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103930:	05 80 33 11 80       	add    $0x80113380,%eax
80103935:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80103938:	0f 87 62 ff ff ff    	ja     801038a0 <startothers+0x3e>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
      ;
  }
}
8010393e:	83 c4 24             	add    $0x24,%esp
80103941:	5b                   	pop    %ebx
80103942:	5d                   	pop    %ebp
80103943:	c3                   	ret    

80103944 <p2v>:
80103944:	55                   	push   %ebp
80103945:	89 e5                	mov    %esp,%ebp
80103947:	8b 45 08             	mov    0x8(%ebp),%eax
8010394a:	05 00 00 00 80       	add    $0x80000000,%eax
8010394f:	5d                   	pop    %ebp
80103950:	c3                   	ret    

80103951 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80103951:	55                   	push   %ebp
80103952:	89 e5                	mov    %esp,%ebp
80103954:	83 ec 14             	sub    $0x14,%esp
80103957:	8b 45 08             	mov    0x8(%ebp),%eax
8010395a:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010395e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80103962:	89 c2                	mov    %eax,%edx
80103964:	ec                   	in     (%dx),%al
80103965:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
80103968:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
8010396c:	c9                   	leave  
8010396d:	c3                   	ret    

8010396e <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
8010396e:	55                   	push   %ebp
8010396f:	89 e5                	mov    %esp,%ebp
80103971:	83 ec 08             	sub    $0x8,%esp
80103974:	8b 55 08             	mov    0x8(%ebp),%edx
80103977:	8b 45 0c             	mov    0xc(%ebp),%eax
8010397a:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
8010397e:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103981:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103985:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103989:	ee                   	out    %al,(%dx)
}
8010398a:	c9                   	leave  
8010398b:	c3                   	ret    

8010398c <mpbcpu>:
int ncpu;
uchar ioapicid;

int
mpbcpu(void)
{
8010398c:	55                   	push   %ebp
8010398d:	89 e5                	mov    %esp,%ebp
  return bcpu-cpus;
8010398f:	a1 64 c6 10 80       	mov    0x8010c664,%eax
80103994:	89 c2                	mov    %eax,%edx
80103996:	b8 80 33 11 80       	mov    $0x80113380,%eax
8010399b:	29 c2                	sub    %eax,%edx
8010399d:	89 d0                	mov    %edx,%eax
8010399f:	c1 f8 02             	sar    $0x2,%eax
801039a2:	69 c0 cf 46 7d 67    	imul   $0x677d46cf,%eax,%eax
}
801039a8:	5d                   	pop    %ebp
801039a9:	c3                   	ret    

801039aa <sum>:

static uchar
sum(uchar *addr, int len)
{
801039aa:	55                   	push   %ebp
801039ab:	89 e5                	mov    %esp,%ebp
801039ad:	83 ec 10             	sub    $0x10,%esp
  int i, sum;
  
  sum = 0;
801039b0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  for(i=0; i<len; i++)
801039b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801039be:	eb 15                	jmp    801039d5 <sum+0x2b>
    sum += addr[i];
801039c0:	8b 55 fc             	mov    -0x4(%ebp),%edx
801039c3:	8b 45 08             	mov    0x8(%ebp),%eax
801039c6:	01 d0                	add    %edx,%eax
801039c8:	0f b6 00             	movzbl (%eax),%eax
801039cb:	0f b6 c0             	movzbl %al,%eax
801039ce:	01 45 f8             	add    %eax,-0x8(%ebp)
sum(uchar *addr, int len)
{
  int i, sum;
  
  sum = 0;
  for(i=0; i<len; i++)
801039d1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801039d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
801039d8:	3b 45 0c             	cmp    0xc(%ebp),%eax
801039db:	7c e3                	jl     801039c0 <sum+0x16>
    sum += addr[i];
  return sum;
801039dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
801039e0:	c9                   	leave  
801039e1:	c3                   	ret    

801039e2 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
801039e2:	55                   	push   %ebp
801039e3:	89 e5                	mov    %esp,%ebp
801039e5:	83 ec 28             	sub    $0x28,%esp
  uchar *e, *p, *addr;

  addr = p2v(a);
801039e8:	8b 45 08             	mov    0x8(%ebp),%eax
801039eb:	89 04 24             	mov    %eax,(%esp)
801039ee:	e8 51 ff ff ff       	call   80103944 <p2v>
801039f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  e = addr+len;
801039f6:	8b 55 0c             	mov    0xc(%ebp),%edx
801039f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801039fc:	01 d0                	add    %edx,%eax
801039fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
  for(p = addr; p < e; p += sizeof(struct mp))
80103a01:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a04:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103a07:	eb 3f                	jmp    80103a48 <mpsearch1+0x66>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103a09:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103a10:	00 
80103a11:	c7 44 24 04 d4 8f 10 	movl   $0x80108fd4,0x4(%esp)
80103a18:	80 
80103a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a1c:	89 04 24             	mov    %eax,(%esp)
80103a1f:	e8 9a 1d 00 00       	call   801057be <memcmp>
80103a24:	85 c0                	test   %eax,%eax
80103a26:	75 1c                	jne    80103a44 <mpsearch1+0x62>
80103a28:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
80103a2f:	00 
80103a30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a33:	89 04 24             	mov    %eax,(%esp)
80103a36:	e8 6f ff ff ff       	call   801039aa <sum>
80103a3b:	84 c0                	test   %al,%al
80103a3d:	75 05                	jne    80103a44 <mpsearch1+0x62>
      return (struct mp*)p;
80103a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a42:	eb 11                	jmp    80103a55 <mpsearch1+0x73>
{
  uchar *e, *p, *addr;

  addr = p2v(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80103a44:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
80103a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a4b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103a4e:	72 b9                	jb     80103a09 <mpsearch1+0x27>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80103a50:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103a55:	c9                   	leave  
80103a56:	c3                   	ret    

80103a57 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80103a57:	55                   	push   %ebp
80103a58:	89 e5                	mov    %esp,%ebp
80103a5a:	83 ec 28             	sub    $0x28,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
80103a5d:	c7 45 f4 00 04 00 80 	movl   $0x80000400,-0xc(%ebp)
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103a64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a67:	83 c0 0f             	add    $0xf,%eax
80103a6a:	0f b6 00             	movzbl (%eax),%eax
80103a6d:	0f b6 c0             	movzbl %al,%eax
80103a70:	c1 e0 08             	shl    $0x8,%eax
80103a73:	89 c2                	mov    %eax,%edx
80103a75:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103a78:	83 c0 0e             	add    $0xe,%eax
80103a7b:	0f b6 00             	movzbl (%eax),%eax
80103a7e:	0f b6 c0             	movzbl %al,%eax
80103a81:	09 d0                	or     %edx,%eax
80103a83:	c1 e0 04             	shl    $0x4,%eax
80103a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103a89:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103a8d:	74 21                	je     80103ab0 <mpsearch+0x59>
    if((mp = mpsearch1(p, 1024)))
80103a8f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103a96:	00 
80103a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103a9a:	89 04 24             	mov    %eax,(%esp)
80103a9d:	e8 40 ff ff ff       	call   801039e2 <mpsearch1>
80103aa2:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103aa5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103aa9:	74 50                	je     80103afb <mpsearch+0xa4>
      return mp;
80103aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103aae:	eb 5f                	jmp    80103b0f <mpsearch+0xb8>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ab3:	83 c0 14             	add    $0x14,%eax
80103ab6:	0f b6 00             	movzbl (%eax),%eax
80103ab9:	0f b6 c0             	movzbl %al,%eax
80103abc:	c1 e0 08             	shl    $0x8,%eax
80103abf:	89 c2                	mov    %eax,%edx
80103ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ac4:	83 c0 13             	add    $0x13,%eax
80103ac7:	0f b6 00             	movzbl (%eax),%eax
80103aca:	0f b6 c0             	movzbl %al,%eax
80103acd:	09 d0                	or     %edx,%eax
80103acf:	c1 e0 0a             	shl    $0xa,%eax
80103ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if((mp = mpsearch1(p-1024, 1024)))
80103ad5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103ad8:	2d 00 04 00 00       	sub    $0x400,%eax
80103add:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
80103ae4:	00 
80103ae5:	89 04 24             	mov    %eax,(%esp)
80103ae8:	e8 f5 fe ff ff       	call   801039e2 <mpsearch1>
80103aed:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103af0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80103af4:	74 05                	je     80103afb <mpsearch+0xa4>
      return mp;
80103af6:	8b 45 ec             	mov    -0x14(%ebp),%eax
80103af9:	eb 14                	jmp    80103b0f <mpsearch+0xb8>
  }
  return mpsearch1(0xF0000, 0x10000);
80103afb:	c7 44 24 04 00 00 01 	movl   $0x10000,0x4(%esp)
80103b02:	00 
80103b03:	c7 04 24 00 00 0f 00 	movl   $0xf0000,(%esp)
80103b0a:	e8 d3 fe ff ff       	call   801039e2 <mpsearch1>
}
80103b0f:	c9                   	leave  
80103b10:	c3                   	ret    

80103b11 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80103b11:	55                   	push   %ebp
80103b12:	89 e5                	mov    %esp,%ebp
80103b14:	83 ec 28             	sub    $0x28,%esp
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103b17:	e8 3b ff ff ff       	call   80103a57 <mpsearch>
80103b1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103b1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103b23:	74 0a                	je     80103b2f <mpconfig+0x1e>
80103b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b28:	8b 40 04             	mov    0x4(%eax),%eax
80103b2b:	85 c0                	test   %eax,%eax
80103b2d:	75 0a                	jne    80103b39 <mpconfig+0x28>
    return 0;
80103b2f:	b8 00 00 00 00       	mov    $0x0,%eax
80103b34:	e9 83 00 00 00       	jmp    80103bbc <mpconfig+0xab>
  conf = (struct mpconf*) p2v((uint) mp->physaddr);
80103b39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103b3c:	8b 40 04             	mov    0x4(%eax),%eax
80103b3f:	89 04 24             	mov    %eax,(%esp)
80103b42:	e8 fd fd ff ff       	call   80103944 <p2v>
80103b47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103b4a:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80103b51:	00 
80103b52:	c7 44 24 04 d9 8f 10 	movl   $0x80108fd9,0x4(%esp)
80103b59:	80 
80103b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b5d:	89 04 24             	mov    %eax,(%esp)
80103b60:	e8 59 1c 00 00       	call   801057be <memcmp>
80103b65:	85 c0                	test   %eax,%eax
80103b67:	74 07                	je     80103b70 <mpconfig+0x5f>
    return 0;
80103b69:	b8 00 00 00 00       	mov    $0x0,%eax
80103b6e:	eb 4c                	jmp    80103bbc <mpconfig+0xab>
  if(conf->version != 1 && conf->version != 4)
80103b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b73:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b77:	3c 01                	cmp    $0x1,%al
80103b79:	74 12                	je     80103b8d <mpconfig+0x7c>
80103b7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b7e:	0f b6 40 06          	movzbl 0x6(%eax),%eax
80103b82:	3c 04                	cmp    $0x4,%al
80103b84:	74 07                	je     80103b8d <mpconfig+0x7c>
    return 0;
80103b86:	b8 00 00 00 00       	mov    $0x0,%eax
80103b8b:	eb 2f                	jmp    80103bbc <mpconfig+0xab>
  if(sum((uchar*)conf, conf->length) != 0)
80103b8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b90:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103b94:	0f b7 c0             	movzwl %ax,%eax
80103b97:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103b9e:	89 04 24             	mov    %eax,(%esp)
80103ba1:	e8 04 fe ff ff       	call   801039aa <sum>
80103ba6:	84 c0                	test   %al,%al
80103ba8:	74 07                	je     80103bb1 <mpconfig+0xa0>
    return 0;
80103baa:	b8 00 00 00 00       	mov    $0x0,%eax
80103baf:	eb 0b                	jmp    80103bbc <mpconfig+0xab>
  *pmp = mp;
80103bb1:	8b 45 08             	mov    0x8(%ebp),%eax
80103bb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80103bb7:	89 10                	mov    %edx,(%eax)
  return conf;
80103bb9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80103bbc:	c9                   	leave  
80103bbd:	c3                   	ret    

80103bbe <mpinit>:

void
mpinit(void)
{
80103bbe:	55                   	push   %ebp
80103bbf:	89 e5                	mov    %esp,%ebp
80103bc1:	83 ec 38             	sub    $0x38,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  bcpu = &cpus[0];
80103bc4:	c7 05 64 c6 10 80 80 	movl   $0x80113380,0x8010c664
80103bcb:	33 11 80 
  if((conf = mpconfig(&mp)) == 0)
80103bce:	8d 45 e0             	lea    -0x20(%ebp),%eax
80103bd1:	89 04 24             	mov    %eax,(%esp)
80103bd4:	e8 38 ff ff ff       	call   80103b11 <mpconfig>
80103bd9:	89 45 f0             	mov    %eax,-0x10(%ebp)
80103bdc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80103be0:	75 05                	jne    80103be7 <mpinit+0x29>
    return;
80103be2:	e9 9c 01 00 00       	jmp    80103d83 <mpinit+0x1c5>
  ismp = 1;
80103be7:	c7 05 64 33 11 80 01 	movl   $0x1,0x80113364
80103bee:	00 00 00 
  lapic = (uint*)conf->lapicaddr;
80103bf1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bf4:	8b 40 24             	mov    0x24(%eax),%eax
80103bf7:	a3 7c 32 11 80       	mov    %eax,0x8011327c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103bfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103bff:	83 c0 2c             	add    $0x2c,%eax
80103c02:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c08:	0f b7 40 04          	movzwl 0x4(%eax),%eax
80103c0c:	0f b7 d0             	movzwl %ax,%edx
80103c0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80103c12:	01 d0                	add    %edx,%eax
80103c14:	89 45 ec             	mov    %eax,-0x14(%ebp)
80103c17:	e9 f4 00 00 00       	jmp    80103d10 <mpinit+0x152>
    switch(*p){
80103c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c1f:	0f b6 00             	movzbl (%eax),%eax
80103c22:	0f b6 c0             	movzbl %al,%eax
80103c25:	83 f8 04             	cmp    $0x4,%eax
80103c28:	0f 87 bf 00 00 00    	ja     80103ced <mpinit+0x12f>
80103c2e:	8b 04 85 1c 90 10 80 	mov    -0x7fef6fe4(,%eax,4),%eax
80103c35:	ff e0                	jmp    *%eax
    case MPPROC:
      proc = (struct mpproc*)p;
80103c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103c3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
      if(ncpu != proc->apicid){
80103c3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c40:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c44:	0f b6 d0             	movzbl %al,%edx
80103c47:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c4c:	39 c2                	cmp    %eax,%edx
80103c4e:	74 2d                	je     80103c7d <mpinit+0xbf>
        cprintf("mpinit: ncpu=%d apicid=%d\n", ncpu, proc->apicid);
80103c50:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c53:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103c57:	0f b6 d0             	movzbl %al,%edx
80103c5a:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c5f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103c63:	89 44 24 04          	mov    %eax,0x4(%esp)
80103c67:	c7 04 24 de 8f 10 80 	movl   $0x80108fde,(%esp)
80103c6e:	e8 2d c7 ff ff       	call   801003a0 <cprintf>
        ismp = 0;
80103c73:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103c7a:	00 00 00 
      }
      if(proc->flags & MPBOOT)
80103c7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
80103c80:	0f b6 40 03          	movzbl 0x3(%eax),%eax
80103c84:	0f b6 c0             	movzbl %al,%eax
80103c87:	83 e0 02             	and    $0x2,%eax
80103c8a:	85 c0                	test   %eax,%eax
80103c8c:	74 15                	je     80103ca3 <mpinit+0xe5>
        bcpu = &cpus[ncpu];
80103c8e:	a1 60 39 11 80       	mov    0x80113960,%eax
80103c93:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80103c99:	05 80 33 11 80       	add    $0x80113380,%eax
80103c9e:	a3 64 c6 10 80       	mov    %eax,0x8010c664
      cpus[ncpu].id = ncpu;
80103ca3:	8b 15 60 39 11 80    	mov    0x80113960,%edx
80103ca9:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cae:	69 d2 bc 00 00 00    	imul   $0xbc,%edx,%edx
80103cb4:	81 c2 80 33 11 80    	add    $0x80113380,%edx
80103cba:	88 02                	mov    %al,(%edx)
      ncpu++;
80103cbc:	a1 60 39 11 80       	mov    0x80113960,%eax
80103cc1:	83 c0 01             	add    $0x1,%eax
80103cc4:	a3 60 39 11 80       	mov    %eax,0x80113960
      p += sizeof(struct mpproc);
80103cc9:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
      continue;
80103ccd:	eb 41                	jmp    80103d10 <mpinit+0x152>
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
80103ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      ioapicid = ioapic->apicno;
80103cd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103cd8:	0f b6 40 01          	movzbl 0x1(%eax),%eax
80103cdc:	a2 60 33 11 80       	mov    %al,0x80113360
      p += sizeof(struct mpioapic);
80103ce1:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ce5:	eb 29                	jmp    80103d10 <mpinit+0x152>
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103ce7:	83 45 f4 08          	addl   $0x8,-0xc(%ebp)
      continue;
80103ceb:	eb 23                	jmp    80103d10 <mpinit+0x152>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
80103ced:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103cf0:	0f b6 00             	movzbl (%eax),%eax
80103cf3:	0f b6 c0             	movzbl %al,%eax
80103cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
80103cfa:	c7 04 24 fc 8f 10 80 	movl   $0x80108ffc,(%esp)
80103d01:	e8 9a c6 ff ff       	call   801003a0 <cprintf>
      ismp = 0;
80103d06:	c7 05 64 33 11 80 00 	movl   $0x0,0x80113364
80103d0d:	00 00 00 
  bcpu = &cpus[0];
  if((conf = mpconfig(&mp)) == 0)
    return;
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103d10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103d13:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80103d16:	0f 82 00 ff ff ff    	jb     80103c1c <mpinit+0x5e>
    default:
      cprintf("mpinit: unknown config type %x\n", *p);
      ismp = 0;
    }
  }
  if(!ismp){
80103d1c:	a1 64 33 11 80       	mov    0x80113364,%eax
80103d21:	85 c0                	test   %eax,%eax
80103d23:	75 1d                	jne    80103d42 <mpinit+0x184>
    // Didn't like what we found; fall back to no MP.
    ncpu = 1;
80103d25:	c7 05 60 39 11 80 01 	movl   $0x1,0x80113960
80103d2c:	00 00 00 
    lapic = 0;
80103d2f:	c7 05 7c 32 11 80 00 	movl   $0x0,0x8011327c
80103d36:	00 00 00 
    ioapicid = 0;
80103d39:	c6 05 60 33 11 80 00 	movb   $0x0,0x80113360
    return;
80103d40:	eb 41                	jmp    80103d83 <mpinit+0x1c5>
  }

  if(mp->imcrp){
80103d42:	8b 45 e0             	mov    -0x20(%ebp),%eax
80103d45:	0f b6 40 0c          	movzbl 0xc(%eax),%eax
80103d49:	84 c0                	test   %al,%al
80103d4b:	74 36                	je     80103d83 <mpinit+0x1c5>
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
80103d4d:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
80103d54:	00 
80103d55:	c7 04 24 22 00 00 00 	movl   $0x22,(%esp)
80103d5c:	e8 0d fc ff ff       	call   8010396e <outb>
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103d61:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d68:	e8 e4 fb ff ff       	call   80103951 <inb>
80103d6d:	83 c8 01             	or     $0x1,%eax
80103d70:	0f b6 c0             	movzbl %al,%eax
80103d73:	89 44 24 04          	mov    %eax,0x4(%esp)
80103d77:	c7 04 24 23 00 00 00 	movl   $0x23,(%esp)
80103d7e:	e8 eb fb ff ff       	call   8010396e <outb>
  }
}
80103d83:	c9                   	leave  
80103d84:	c3                   	ret    

80103d85 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80103d85:	55                   	push   %ebp
80103d86:	89 e5                	mov    %esp,%ebp
80103d88:	83 ec 08             	sub    $0x8,%esp
80103d8b:	8b 55 08             	mov    0x8(%ebp),%edx
80103d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d91:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80103d95:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103d98:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80103d9c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80103da0:	ee                   	out    %al,(%dx)
}
80103da1:	c9                   	leave  
80103da2:	c3                   	ret    

80103da3 <picsetmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static ushort irqmask = 0xFFFF & ~(1<<IRQ_SLAVE);

static void
picsetmask(ushort mask)
{
80103da3:	55                   	push   %ebp
80103da4:	89 e5                	mov    %esp,%ebp
80103da6:	83 ec 0c             	sub    $0xc,%esp
80103da9:	8b 45 08             	mov    0x8(%ebp),%eax
80103dac:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  irqmask = mask;
80103db0:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103db4:	66 a3 00 c0 10 80    	mov    %ax,0x8010c000
  outb(IO_PIC1+1, mask);
80103dba:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dbe:	0f b6 c0             	movzbl %al,%eax
80103dc1:	89 44 24 04          	mov    %eax,0x4(%esp)
80103dc5:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103dcc:	e8 b4 ff ff ff       	call   80103d85 <outb>
  outb(IO_PIC2+1, mask >> 8);
80103dd1:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80103dd5:	66 c1 e8 08          	shr    $0x8,%ax
80103dd9:	0f b6 c0             	movzbl %al,%eax
80103ddc:	89 44 24 04          	mov    %eax,0x4(%esp)
80103de0:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103de7:	e8 99 ff ff ff       	call   80103d85 <outb>
}
80103dec:	c9                   	leave  
80103ded:	c3                   	ret    

80103dee <picenable>:

void
picenable(int irq)
{
80103dee:	55                   	push   %ebp
80103def:	89 e5                	mov    %esp,%ebp
80103df1:	83 ec 04             	sub    $0x4,%esp
  picsetmask(irqmask & ~(1<<irq));
80103df4:	8b 45 08             	mov    0x8(%ebp),%eax
80103df7:	ba 01 00 00 00       	mov    $0x1,%edx
80103dfc:	89 c1                	mov    %eax,%ecx
80103dfe:	d3 e2                	shl    %cl,%edx
80103e00:	89 d0                	mov    %edx,%eax
80103e02:	f7 d0                	not    %eax
80103e04:	89 c2                	mov    %eax,%edx
80103e06:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103e0d:	21 d0                	and    %edx,%eax
80103e0f:	0f b7 c0             	movzwl %ax,%eax
80103e12:	89 04 24             	mov    %eax,(%esp)
80103e15:	e8 89 ff ff ff       	call   80103da3 <picsetmask>
}
80103e1a:	c9                   	leave  
80103e1b:	c3                   	ret    

80103e1c <picinit>:

// Initialize the 8259A interrupt controllers.
void
picinit(void)
{
80103e1c:	55                   	push   %ebp
80103e1d:	89 e5                	mov    %esp,%ebp
80103e1f:	83 ec 08             	sub    $0x8,%esp
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
80103e22:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e29:	00 
80103e2a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e31:	e8 4f ff ff ff       	call   80103d85 <outb>
  outb(IO_PIC2+1, 0xFF);
80103e36:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
80103e3d:	00 
80103e3e:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103e45:	e8 3b ff ff ff       	call   80103d85 <outb>

  // ICW1:  0001g0hi
  //    g:  0 = edge triggering, 1 = level triggering
  //    h:  0 = cascaded PICs, 1 = master only
  //    i:  0 = no ICW4, 1 = ICW4 required
  outb(IO_PIC1, 0x11);
80103e4a:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103e51:	00 
80103e52:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103e59:	e8 27 ff ff ff       	call   80103d85 <outb>

  // ICW2:  Vector offset
  outb(IO_PIC1+1, T_IRQ0);
80103e5e:	c7 44 24 04 20 00 00 	movl   $0x20,0x4(%esp)
80103e65:	00 
80103e66:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e6d:	e8 13 ff ff ff       	call   80103d85 <outb>

  // ICW3:  (master PIC) bit mask of IR lines connected to slaves
  //        (slave PIC) 3-bit # of slave's connection to master
  outb(IO_PIC1+1, 1<<IRQ_SLAVE);
80103e72:	c7 44 24 04 04 00 00 	movl   $0x4,0x4(%esp)
80103e79:	00 
80103e7a:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e81:	e8 ff fe ff ff       	call   80103d85 <outb>
  //    m:  0 = slave PIC, 1 = master PIC
  //      (ignored when b is 0, as the master/slave role
  //      can be hardwired).
  //    a:  1 = Automatic EOI mode
  //    p:  0 = MCS-80/85 mode, 1 = intel x86 mode
  outb(IO_PIC1+1, 0x3);
80103e86:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103e8d:	00 
80103e8e:	c7 04 24 21 00 00 00 	movl   $0x21,(%esp)
80103e95:	e8 eb fe ff ff       	call   80103d85 <outb>

  // Set up slave (8259A-2)
  outb(IO_PIC2, 0x11);                  // ICW1
80103e9a:	c7 44 24 04 11 00 00 	movl   $0x11,0x4(%esp)
80103ea1:	00 
80103ea2:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103ea9:	e8 d7 fe ff ff       	call   80103d85 <outb>
  outb(IO_PIC2+1, T_IRQ0 + 8);      // ICW2
80103eae:	c7 44 24 04 28 00 00 	movl   $0x28,0x4(%esp)
80103eb5:	00 
80103eb6:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ebd:	e8 c3 fe ff ff       	call   80103d85 <outb>
  outb(IO_PIC2+1, IRQ_SLAVE);           // ICW3
80103ec2:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80103ec9:	00 
80103eca:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ed1:	e8 af fe ff ff       	call   80103d85 <outb>
  // NB Automatic EOI mode doesn't tend to work on the slave.
  // Linux source code says it's "to be investigated".
  outb(IO_PIC2+1, 0x3);                 // ICW4
80103ed6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
80103edd:	00 
80103ede:	c7 04 24 a1 00 00 00 	movl   $0xa1,(%esp)
80103ee5:	e8 9b fe ff ff       	call   80103d85 <outb>

  // OCW3:  0ef01prs
  //   ef:  0x = NOP, 10 = clear specific mask, 11 = set specific mask
  //    p:  0 = no polling, 1 = polling mode
  //   rs:  0x = NOP, 10 = read IRR, 11 = read ISR
  outb(IO_PIC1, 0x68);             // clear specific mask
80103eea:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103ef1:	00 
80103ef2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103ef9:	e8 87 fe ff ff       	call   80103d85 <outb>
  outb(IO_PIC1, 0x0a);             // read IRR by default
80103efe:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f05:	00 
80103f06:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80103f0d:	e8 73 fe ff ff       	call   80103d85 <outb>

  outb(IO_PIC2, 0x68);             // OCW3
80103f12:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
80103f19:	00 
80103f1a:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f21:	e8 5f fe ff ff       	call   80103d85 <outb>
  outb(IO_PIC2, 0x0a);             // OCW3
80103f26:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
80103f2d:	00 
80103f2e:	c7 04 24 a0 00 00 00 	movl   $0xa0,(%esp)
80103f35:	e8 4b fe ff ff       	call   80103d85 <outb>

  if(irqmask != 0xFFFF)
80103f3a:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f41:	66 83 f8 ff          	cmp    $0xffff,%ax
80103f45:	74 12                	je     80103f59 <picinit+0x13d>
    picsetmask(irqmask);
80103f47:	0f b7 05 00 c0 10 80 	movzwl 0x8010c000,%eax
80103f4e:	0f b7 c0             	movzwl %ax,%eax
80103f51:	89 04 24             	mov    %eax,(%esp)
80103f54:	e8 4a fe ff ff       	call   80103da3 <picsetmask>
}
80103f59:	c9                   	leave  
80103f5a:	c3                   	ret    

80103f5b <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103f5b:	55                   	push   %ebp
80103f5c:	89 e5                	mov    %esp,%ebp
80103f5e:	83 ec 28             	sub    $0x28,%esp
  struct pipe *p;

  p = 0;
80103f61:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  *f0 = *f1 = 0;
80103f68:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f6b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103f71:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f74:	8b 10                	mov    (%eax),%edx
80103f76:	8b 45 08             	mov    0x8(%ebp),%eax
80103f79:	89 10                	mov    %edx,(%eax)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80103f7b:	e8 e0 cf ff ff       	call   80100f60 <filealloc>
80103f80:	8b 55 08             	mov    0x8(%ebp),%edx
80103f83:	89 02                	mov    %eax,(%edx)
80103f85:	8b 45 08             	mov    0x8(%ebp),%eax
80103f88:	8b 00                	mov    (%eax),%eax
80103f8a:	85 c0                	test   %eax,%eax
80103f8c:	0f 84 c8 00 00 00    	je     8010405a <pipealloc+0xff>
80103f92:	e8 c9 cf ff ff       	call   80100f60 <filealloc>
80103f97:	8b 55 0c             	mov    0xc(%ebp),%edx
80103f9a:	89 02                	mov    %eax,(%edx)
80103f9c:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f9f:	8b 00                	mov    (%eax),%eax
80103fa1:	85 c0                	test   %eax,%eax
80103fa3:	0f 84 b1 00 00 00    	je     8010405a <pipealloc+0xff>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103fa9:	e8 6e eb ff ff       	call   80102b1c <kalloc>
80103fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
80103fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80103fb5:	75 05                	jne    80103fbc <pipealloc+0x61>
    goto bad;
80103fb7:	e9 9e 00 00 00       	jmp    8010405a <pipealloc+0xff>
  p->readopen = 1;
80103fbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fbf:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103fc6:	00 00 00 
  p->writeopen = 1;
80103fc9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fcc:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103fd3:	00 00 00 
  p->nwrite = 0;
80103fd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fd9:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103fe0:	00 00 00 
  p->nread = 0;
80103fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103fe6:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103fed:	00 00 00 
  initlock(&p->lock, "pipe");
80103ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80103ff3:	c7 44 24 04 30 90 10 	movl   $0x80109030,0x4(%esp)
80103ffa:	80 
80103ffb:	89 04 24             	mov    %eax,(%esp)
80103ffe:	e8 ca 14 00 00       	call   801054cd <initlock>
  (*f0)->type = FD_PIPE;
80104003:	8b 45 08             	mov    0x8(%ebp),%eax
80104006:	8b 00                	mov    (%eax),%eax
80104008:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
8010400e:	8b 45 08             	mov    0x8(%ebp),%eax
80104011:	8b 00                	mov    (%eax),%eax
80104013:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80104017:	8b 45 08             	mov    0x8(%ebp),%eax
8010401a:	8b 00                	mov    (%eax),%eax
8010401c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80104020:	8b 45 08             	mov    0x8(%ebp),%eax
80104023:	8b 00                	mov    (%eax),%eax
80104025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104028:	89 50 0c             	mov    %edx,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010402b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010402e:	8b 00                	mov    (%eax),%eax
80104030:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80104036:	8b 45 0c             	mov    0xc(%ebp),%eax
80104039:	8b 00                	mov    (%eax),%eax
8010403b:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
8010403f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104042:	8b 00                	mov    (%eax),%eax
80104044:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80104048:	8b 45 0c             	mov    0xc(%ebp),%eax
8010404b:	8b 00                	mov    (%eax),%eax
8010404d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104050:	89 50 0c             	mov    %edx,0xc(%eax)
  return 0;
80104053:	b8 00 00 00 00       	mov    $0x0,%eax
80104058:	eb 42                	jmp    8010409c <pipealloc+0x141>

//PAGEBREAK: 20
 bad:
  if(p)
8010405a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010405e:	74 0b                	je     8010406b <pipealloc+0x110>
    kfree((char*)p);
80104060:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104063:	89 04 24             	mov    %eax,(%esp)
80104066:	e8 18 ea ff ff       	call   80102a83 <kfree>
  if(*f0)
8010406b:	8b 45 08             	mov    0x8(%ebp),%eax
8010406e:	8b 00                	mov    (%eax),%eax
80104070:	85 c0                	test   %eax,%eax
80104072:	74 0d                	je     80104081 <pipealloc+0x126>
    fileclose(*f0);
80104074:	8b 45 08             	mov    0x8(%ebp),%eax
80104077:	8b 00                	mov    (%eax),%eax
80104079:	89 04 24             	mov    %eax,(%esp)
8010407c:	e8 87 cf ff ff       	call   80101008 <fileclose>
  if(*f1)
80104081:	8b 45 0c             	mov    0xc(%ebp),%eax
80104084:	8b 00                	mov    (%eax),%eax
80104086:	85 c0                	test   %eax,%eax
80104088:	74 0d                	je     80104097 <pipealloc+0x13c>
    fileclose(*f1);
8010408a:	8b 45 0c             	mov    0xc(%ebp),%eax
8010408d:	8b 00                	mov    (%eax),%eax
8010408f:	89 04 24             	mov    %eax,(%esp)
80104092:	e8 71 cf ff ff       	call   80101008 <fileclose>
  return -1;
80104097:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010409c:	c9                   	leave  
8010409d:	c3                   	ret    

8010409e <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
8010409e:	55                   	push   %ebp
8010409f:	89 e5                	mov    %esp,%ebp
801040a1:	83 ec 18             	sub    $0x18,%esp
  acquire(&p->lock);
801040a4:	8b 45 08             	mov    0x8(%ebp),%eax
801040a7:	89 04 24             	mov    %eax,(%esp)
801040aa:	e8 3f 14 00 00       	call   801054ee <acquire>
  if(writable){
801040af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
801040b3:	74 1f                	je     801040d4 <pipeclose+0x36>
    p->writeopen = 0;
801040b5:	8b 45 08             	mov    0x8(%ebp),%eax
801040b8:	c7 80 40 02 00 00 00 	movl   $0x0,0x240(%eax)
801040bf:	00 00 00 
    wakeup(&p->nread);
801040c2:	8b 45 08             	mov    0x8(%ebp),%eax
801040c5:	05 34 02 00 00       	add    $0x234,%eax
801040ca:	89 04 24             	mov    %eax,(%esp)
801040cd:	e8 36 0f 00 00       	call   80105008 <wakeup>
801040d2:	eb 1d                	jmp    801040f1 <pipeclose+0x53>
  } else {
    p->readopen = 0;
801040d4:	8b 45 08             	mov    0x8(%ebp),%eax
801040d7:	c7 80 3c 02 00 00 00 	movl   $0x0,0x23c(%eax)
801040de:	00 00 00 
    wakeup(&p->nwrite);
801040e1:	8b 45 08             	mov    0x8(%ebp),%eax
801040e4:	05 38 02 00 00       	add    $0x238,%eax
801040e9:	89 04 24             	mov    %eax,(%esp)
801040ec:	e8 17 0f 00 00       	call   80105008 <wakeup>
  }
  if(p->readopen == 0 && p->writeopen == 0){
801040f1:	8b 45 08             	mov    0x8(%ebp),%eax
801040f4:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
801040fa:	85 c0                	test   %eax,%eax
801040fc:	75 25                	jne    80104123 <pipeclose+0x85>
801040fe:	8b 45 08             	mov    0x8(%ebp),%eax
80104101:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
80104107:	85 c0                	test   %eax,%eax
80104109:	75 18                	jne    80104123 <pipeclose+0x85>
    release(&p->lock);
8010410b:	8b 45 08             	mov    0x8(%ebp),%eax
8010410e:	89 04 24             	mov    %eax,(%esp)
80104111:	e8 3f 14 00 00       	call   80105555 <release>
    kfree((char*)p);
80104116:	8b 45 08             	mov    0x8(%ebp),%eax
80104119:	89 04 24             	mov    %eax,(%esp)
8010411c:	e8 62 e9 ff ff       	call   80102a83 <kfree>
80104121:	eb 0b                	jmp    8010412e <pipeclose+0x90>
  } else
    release(&p->lock);
80104123:	8b 45 08             	mov    0x8(%ebp),%eax
80104126:	89 04 24             	mov    %eax,(%esp)
80104129:	e8 27 14 00 00       	call   80105555 <release>
}
8010412e:	c9                   	leave  
8010412f:	c3                   	ret    

80104130 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80104130:	55                   	push   %ebp
80104131:	89 e5                	mov    %esp,%ebp
80104133:	83 ec 28             	sub    $0x28,%esp
  int i;

  acquire(&p->lock);
80104136:	8b 45 08             	mov    0x8(%ebp),%eax
80104139:	89 04 24             	mov    %eax,(%esp)
8010413c:	e8 ad 13 00 00       	call   801054ee <acquire>
  for(i = 0; i < n; i++){
80104141:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104148:	e9 a6 00 00 00       	jmp    801041f3 <pipewrite+0xc3>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010414d:	eb 57                	jmp    801041a6 <pipewrite+0x76>
      if(p->readopen == 0 || proc->killed){
8010414f:	8b 45 08             	mov    0x8(%ebp),%eax
80104152:	8b 80 3c 02 00 00    	mov    0x23c(%eax),%eax
80104158:	85 c0                	test   %eax,%eax
8010415a:	74 0d                	je     80104169 <pipewrite+0x39>
8010415c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104162:	8b 40 24             	mov    0x24(%eax),%eax
80104165:	85 c0                	test   %eax,%eax
80104167:	74 15                	je     8010417e <pipewrite+0x4e>
        release(&p->lock);
80104169:	8b 45 08             	mov    0x8(%ebp),%eax
8010416c:	89 04 24             	mov    %eax,(%esp)
8010416f:	e8 e1 13 00 00       	call   80105555 <release>
        return -1;
80104174:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104179:	e9 9f 00 00 00       	jmp    8010421d <pipewrite+0xed>
      }
      wakeup(&p->nread);
8010417e:	8b 45 08             	mov    0x8(%ebp),%eax
80104181:	05 34 02 00 00       	add    $0x234,%eax
80104186:	89 04 24             	mov    %eax,(%esp)
80104189:	e8 7a 0e 00 00       	call   80105008 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010418e:	8b 45 08             	mov    0x8(%ebp),%eax
80104191:	8b 55 08             	mov    0x8(%ebp),%edx
80104194:	81 c2 38 02 00 00    	add    $0x238,%edx
8010419a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010419e:	89 14 24             	mov    %edx,(%esp)
801041a1:	e8 76 0d 00 00       	call   80104f1c <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801041a6:	8b 45 08             	mov    0x8(%ebp),%eax
801041a9:	8b 90 38 02 00 00    	mov    0x238(%eax),%edx
801041af:	8b 45 08             	mov    0x8(%ebp),%eax
801041b2:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801041b8:	05 00 02 00 00       	add    $0x200,%eax
801041bd:	39 c2                	cmp    %eax,%edx
801041bf:	74 8e                	je     8010414f <pipewrite+0x1f>
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801041c1:	8b 45 08             	mov    0x8(%ebp),%eax
801041c4:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801041ca:	8d 48 01             	lea    0x1(%eax),%ecx
801041cd:	8b 55 08             	mov    0x8(%ebp),%edx
801041d0:	89 8a 38 02 00 00    	mov    %ecx,0x238(%edx)
801041d6:	25 ff 01 00 00       	and    $0x1ff,%eax
801041db:	89 c1                	mov    %eax,%ecx
801041dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
801041e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801041e3:	01 d0                	add    %edx,%eax
801041e5:	0f b6 10             	movzbl (%eax),%edx
801041e8:	8b 45 08             	mov    0x8(%ebp),%eax
801041eb:	88 54 08 34          	mov    %dl,0x34(%eax,%ecx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801041ef:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801041f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801041f6:	3b 45 10             	cmp    0x10(%ebp),%eax
801041f9:	0f 8c 4e ff ff ff    	jl     8010414d <pipewrite+0x1d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801041ff:	8b 45 08             	mov    0x8(%ebp),%eax
80104202:	05 34 02 00 00       	add    $0x234,%eax
80104207:	89 04 24             	mov    %eax,(%esp)
8010420a:	e8 f9 0d 00 00       	call   80105008 <wakeup>
  release(&p->lock);
8010420f:	8b 45 08             	mov    0x8(%ebp),%eax
80104212:	89 04 24             	mov    %eax,(%esp)
80104215:	e8 3b 13 00 00       	call   80105555 <release>
  return n;
8010421a:	8b 45 10             	mov    0x10(%ebp),%eax
}
8010421d:	c9                   	leave  
8010421e:	c3                   	ret    

8010421f <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010421f:	55                   	push   %ebp
80104220:	89 e5                	mov    %esp,%ebp
80104222:	53                   	push   %ebx
80104223:	83 ec 24             	sub    $0x24,%esp
  int i;

  acquire(&p->lock);
80104226:	8b 45 08             	mov    0x8(%ebp),%eax
80104229:	89 04 24             	mov    %eax,(%esp)
8010422c:	e8 bd 12 00 00       	call   801054ee <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80104231:	eb 3a                	jmp    8010426d <piperead+0x4e>
    if(proc->killed){
80104233:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104239:	8b 40 24             	mov    0x24(%eax),%eax
8010423c:	85 c0                	test   %eax,%eax
8010423e:	74 15                	je     80104255 <piperead+0x36>
      release(&p->lock);
80104240:	8b 45 08             	mov    0x8(%ebp),%eax
80104243:	89 04 24             	mov    %eax,(%esp)
80104246:	e8 0a 13 00 00       	call   80105555 <release>
      return -1;
8010424b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104250:	e9 b5 00 00 00       	jmp    8010430a <piperead+0xeb>
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80104255:	8b 45 08             	mov    0x8(%ebp),%eax
80104258:	8b 55 08             	mov    0x8(%ebp),%edx
8010425b:	81 c2 34 02 00 00    	add    $0x234,%edx
80104261:	89 44 24 04          	mov    %eax,0x4(%esp)
80104265:	89 14 24             	mov    %edx,(%esp)
80104268:	e8 af 0c 00 00       	call   80104f1c <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010426d:	8b 45 08             	mov    0x8(%ebp),%eax
80104270:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
80104276:	8b 45 08             	mov    0x8(%ebp),%eax
80104279:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
8010427f:	39 c2                	cmp    %eax,%edx
80104281:	75 0d                	jne    80104290 <piperead+0x71>
80104283:	8b 45 08             	mov    0x8(%ebp),%eax
80104286:	8b 80 40 02 00 00    	mov    0x240(%eax),%eax
8010428c:	85 c0                	test   %eax,%eax
8010428e:	75 a3                	jne    80104233 <piperead+0x14>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80104290:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80104297:	eb 4b                	jmp    801042e4 <piperead+0xc5>
    if(p->nread == p->nwrite)
80104299:	8b 45 08             	mov    0x8(%ebp),%eax
8010429c:	8b 90 34 02 00 00    	mov    0x234(%eax),%edx
801042a2:	8b 45 08             	mov    0x8(%ebp),%eax
801042a5:	8b 80 38 02 00 00    	mov    0x238(%eax),%eax
801042ab:	39 c2                	cmp    %eax,%edx
801042ad:	75 02                	jne    801042b1 <piperead+0x92>
      break;
801042af:	eb 3b                	jmp    801042ec <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
801042b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
801042b4:	8b 45 0c             	mov    0xc(%ebp),%eax
801042b7:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
801042ba:	8b 45 08             	mov    0x8(%ebp),%eax
801042bd:	8b 80 34 02 00 00    	mov    0x234(%eax),%eax
801042c3:	8d 48 01             	lea    0x1(%eax),%ecx
801042c6:	8b 55 08             	mov    0x8(%ebp),%edx
801042c9:	89 8a 34 02 00 00    	mov    %ecx,0x234(%edx)
801042cf:	25 ff 01 00 00       	and    $0x1ff,%eax
801042d4:	89 c2                	mov    %eax,%edx
801042d6:	8b 45 08             	mov    0x8(%ebp),%eax
801042d9:	0f b6 44 10 34       	movzbl 0x34(%eax,%edx,1),%eax
801042de:	88 03                	mov    %al,(%ebx)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801042e0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801042e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801042e7:	3b 45 10             	cmp    0x10(%ebp),%eax
801042ea:	7c ad                	jl     80104299 <piperead+0x7a>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801042ec:	8b 45 08             	mov    0x8(%ebp),%eax
801042ef:	05 38 02 00 00       	add    $0x238,%eax
801042f4:	89 04 24             	mov    %eax,(%esp)
801042f7:	e8 0c 0d 00 00       	call   80105008 <wakeup>
  release(&p->lock);
801042fc:	8b 45 08             	mov    0x8(%ebp),%eax
801042ff:	89 04 24             	mov    %eax,(%esp)
80104302:	e8 4e 12 00 00       	call   80105555 <release>
  return i;
80104307:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010430a:	83 c4 24             	add    $0x24,%esp
8010430d:	5b                   	pop    %ebx
8010430e:	5d                   	pop    %ebp
8010430f:	c3                   	ret    

80104310 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80104310:	55                   	push   %ebp
80104311:	89 e5                	mov    %esp,%ebp
80104313:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104316:	9c                   	pushf  
80104317:	58                   	pop    %eax
80104318:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
8010431b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
8010431e:	c9                   	leave  
8010431f:	c3                   	ret    

80104320 <sti>:
  asm volatile("cli");
}

static inline void
sti(void)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
80104323:	fb                   	sti    
}
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    

80104326 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
80104326:	55                   	push   %ebp
80104327:	89 e5                	mov    %esp,%ebp
80104329:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
8010432c:	c7 44 24 04 38 90 10 	movl   $0x80109038,0x4(%esp)
80104333:	80 
80104334:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010433b:	e8 8d 11 00 00       	call   801054cd <initlock>
}
80104340:	c9                   	leave  
80104341:	c3                   	ret    

80104342 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80104342:	55                   	push   %ebp
80104343:	89 e5                	mov    %esp,%ebp
80104345:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
80104348:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010434f:	e8 9a 11 00 00       	call   801054ee <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104354:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010435b:	eb 53                	jmp    801043b0 <allocproc+0x6e>
    if(p->state == UNUSED)
8010435d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104360:	8b 40 0c             	mov    0xc(%eax),%eax
80104363:	85 c0                	test   %eax,%eax
80104365:	75 42                	jne    801043a9 <allocproc+0x67>
      goto found;
80104367:	90                   	nop
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80104368:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010436b:	c7 40 0c 01 00 00 00 	movl   $0x1,0xc(%eax)
  p->pid = nextpid++;
80104372:	a1 04 c0 10 80       	mov    0x8010c004,%eax
80104377:	8d 50 01             	lea    0x1(%eax),%edx
8010437a:	89 15 04 c0 10 80    	mov    %edx,0x8010c004
80104380:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104383:	89 42 10             	mov    %eax,0x10(%edx)
  release(&ptable.lock);
80104386:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010438d:	e8 c3 11 00 00       	call   80105555 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80104392:	e8 85 e7 ff ff       	call   80102b1c <kalloc>
80104397:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010439a:	89 42 08             	mov    %eax,0x8(%edx)
8010439d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043a0:	8b 40 08             	mov    0x8(%eax),%eax
801043a3:	85 c0                	test   %eax,%eax
801043a5:	75 3c                	jne    801043e3 <allocproc+0xa1>
801043a7:	eb 26                	jmp    801043cf <allocproc+0x8d>
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801043a9:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801043b0:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
801043b7:	72 a4                	jb     8010435d <allocproc+0x1b>
    if(p->state == UNUSED)
      goto found;
  release(&ptable.lock);
801043b9:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801043c0:	e8 90 11 00 00       	call   80105555 <release>
  return 0;
801043c5:	b8 00 00 00 00       	mov    $0x0,%eax
801043ca:	e9 bd 00 00 00       	jmp    8010448c <allocproc+0x14a>
  p->pid = nextpid++;
  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
801043cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043d2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return 0;
801043d9:	b8 00 00 00 00       	mov    $0x0,%eax
801043de:	e9 a9 00 00 00       	jmp    8010448c <allocproc+0x14a>
  }
  sp = p->kstack + KSTACKSIZE;
801043e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043e6:	8b 40 08             	mov    0x8(%eax),%eax
801043e9:	05 00 10 00 00       	add    $0x1000,%eax
801043ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  
  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801043f1:	83 6d f0 4c          	subl   $0x4c,-0x10(%ebp)
  p->tf = (struct trapframe*)sp;
801043f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801043f8:	8b 55 f0             	mov    -0x10(%ebp),%edx
801043fb:	89 50 18             	mov    %edx,0x18(%eax)
  
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
801043fe:	83 6d f0 04          	subl   $0x4,-0x10(%ebp)
  *(uint*)sp = (uint)trapret;
80104402:	ba e3 6d 10 80       	mov    $0x80106de3,%edx
80104407:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010440a:	89 10                	mov    %edx,(%eax)

  sp -= sizeof *p->context;
8010440c:	83 6d f0 14          	subl   $0x14,-0x10(%ebp)
  p->context = (struct context*)sp;
80104410:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104413:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104416:	89 50 1c             	mov    %edx,0x1c(%eax)
  memset(p->context, 0, sizeof *p->context);
80104419:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010441c:	8b 40 1c             	mov    0x1c(%eax),%eax
8010441f:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104426:	00 
80104427:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010442e:	00 
8010442f:	89 04 24             	mov    %eax,(%esp)
80104432:	e8 10 13 00 00       	call   80105747 <memset>
  p->context->eip = (uint)forkret;
80104437:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010443a:	8b 40 1c             	mov    0x1c(%eax),%eax
8010443d:	ba f0 4e 10 80       	mov    $0x80104ef0,%edx
80104442:	89 50 10             	mov    %edx,0x10(%eax)

  //
  p->ctime = ticks;
80104445:	a1 00 6a 11 80       	mov    0x80116a00,%eax
8010444a:	89 c2                	mov    %eax,%edx
8010444c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010444f:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  p->stime = 0;
80104455:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104458:	c7 80 88 00 00 00 00 	movl   $0x0,0x88(%eax)
8010445f:	00 00 00 
  p->retime = 0;
80104462:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104465:	c7 80 8c 00 00 00 00 	movl   $0x0,0x8c(%eax)
8010446c:	00 00 00 
  p->rutime = 0;
8010446f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104472:	c7 80 90 00 00 00 00 	movl   $0x0,0x90(%eax)
80104479:	00 00 00 
  p->priority = MEDIUM;
8010447c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010447f:	c7 80 94 00 00 00 02 	movl   $0x2,0x94(%eax)
80104486:	00 00 00 
  //

  return p;
80104489:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
8010448c:	c9                   	leave  
8010448d:	c3                   	ret    

8010448e <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
8010448e:	55                   	push   %ebp
8010448f:	89 e5                	mov    %esp,%ebp
80104491:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];
  
  p = allocproc();
80104494:	e8 a9 fe ff ff       	call   80104342 <allocproc>
80104499:	89 45 f4             	mov    %eax,-0xc(%ebp)
  initproc = p;
8010449c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010449f:	a3 68 c6 10 80       	mov    %eax,0x8010c668
  if((p->pgdir = setupkvm()) == 0)
801044a4:	e8 48 40 00 00       	call   801084f1 <setupkvm>
801044a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044ac:	89 42 04             	mov    %eax,0x4(%edx)
801044af:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044b2:	8b 40 04             	mov    0x4(%eax),%eax
801044b5:	85 c0                	test   %eax,%eax
801044b7:	75 0c                	jne    801044c5 <userinit+0x37>
    panic("userinit: out of memory?");
801044b9:	c7 04 24 3f 90 10 80 	movl   $0x8010903f,(%esp)
801044c0:	e8 75 c0 ff ff       	call   8010053a <panic>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801044c5:	ba 2c 00 00 00       	mov    $0x2c,%edx
801044ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044cd:	8b 40 04             	mov    0x4(%eax),%eax
801044d0:	89 54 24 08          	mov    %edx,0x8(%esp)
801044d4:	c7 44 24 04 00 c5 10 	movl   $0x8010c500,0x4(%esp)
801044db:	80 
801044dc:	89 04 24             	mov    %eax,(%esp)
801044df:	e8 65 42 00 00       	call   80108749 <inituvm>
  p->sz = PGSIZE;
801044e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044e7:	c7 00 00 10 00 00    	movl   $0x1000,(%eax)
  memset(p->tf, 0, sizeof(*p->tf));
801044ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801044f0:	8b 40 18             	mov    0x18(%eax),%eax
801044f3:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
801044fa:	00 
801044fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104502:	00 
80104503:	89 04 24             	mov    %eax,(%esp)
80104506:	e8 3c 12 00 00       	call   80105747 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010450b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010450e:	8b 40 18             	mov    0x18(%eax),%eax
80104511:	66 c7 40 3c 23 00    	movw   $0x23,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80104517:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010451a:	8b 40 18             	mov    0x18(%eax),%eax
8010451d:	66 c7 40 2c 2b 00    	movw   $0x2b,0x2c(%eax)
  p->tf->es = p->tf->ds;
80104523:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104526:	8b 40 18             	mov    0x18(%eax),%eax
80104529:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010452c:	8b 52 18             	mov    0x18(%edx),%edx
8010452f:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104533:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80104537:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010453a:	8b 40 18             	mov    0x18(%eax),%eax
8010453d:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104540:	8b 52 18             	mov    0x18(%edx),%edx
80104543:	0f b7 52 2c          	movzwl 0x2c(%edx),%edx
80104547:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010454b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010454e:	8b 40 18             	mov    0x18(%eax),%eax
80104551:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80104558:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010455b:	8b 40 18             	mov    0x18(%eax),%eax
8010455e:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80104565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104568:	8b 40 18             	mov    0x18(%eax),%eax
8010456b:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80104572:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104575:	83 c0 6c             	add    $0x6c,%eax
80104578:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010457f:	00 
80104580:	c7 44 24 04 58 90 10 	movl   $0x80109058,0x4(%esp)
80104587:	80 
80104588:	89 04 24             	mov    %eax,(%esp)
8010458b:	e8 d7 13 00 00       	call   80105967 <safestrcpy>
  p->cwd = namei("/");
80104590:	c7 04 24 61 90 10 80 	movl   $0x80109061,(%esp)
80104597:	e8 a4 de ff ff       	call   80102440 <namei>
8010459c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010459f:	89 42 68             	mov    %eax,0x68(%edx)

  p->state = RUNNABLE;
801045a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045a5:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  p->arrived_in_queue = ticks;
801045ac:	a1 00 6a 11 80       	mov    0x80116a00,%eax
801045b1:	89 c2                	mov    %eax,%edx
801045b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045b6:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
}
801045bc:	c9                   	leave  
801045bd:	c3                   	ret    

801045be <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801045be:	55                   	push   %ebp
801045bf:	89 e5                	mov    %esp,%ebp
801045c1:	83 ec 28             	sub    $0x28,%esp
  uint sz;
  
  sz = proc->sz;
801045c4:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045ca:	8b 00                	mov    (%eax),%eax
801045cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(n > 0){
801045cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801045d3:	7e 34                	jle    80104609 <growproc+0x4b>
    if((sz = allocuvm(proc->pgdir, sz, sz + n)) == 0)
801045d5:	8b 55 08             	mov    0x8(%ebp),%edx
801045d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801045db:	01 c2                	add    %eax,%edx
801045dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801045e3:	8b 40 04             	mov    0x4(%eax),%eax
801045e6:	89 54 24 08          	mov    %edx,0x8(%esp)
801045ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
801045ed:	89 54 24 04          	mov    %edx,0x4(%esp)
801045f1:	89 04 24             	mov    %eax,(%esp)
801045f4:	e8 c6 42 00 00       	call   801088bf <allocuvm>
801045f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801045fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80104600:	75 41                	jne    80104643 <growproc+0x85>
      return -1;
80104602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104607:	eb 58                	jmp    80104661 <growproc+0xa3>
  } else if(n < 0){
80104609:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
8010460d:	79 34                	jns    80104643 <growproc+0x85>
    if((sz = deallocuvm(proc->pgdir, sz, sz + n)) == 0)
8010460f:	8b 55 08             	mov    0x8(%ebp),%edx
80104612:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104615:	01 c2                	add    %eax,%edx
80104617:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010461d:	8b 40 04             	mov    0x4(%eax),%eax
80104620:	89 54 24 08          	mov    %edx,0x8(%esp)
80104624:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104627:	89 54 24 04          	mov    %edx,0x4(%esp)
8010462b:	89 04 24             	mov    %eax,(%esp)
8010462e:	e8 66 43 00 00       	call   80108999 <deallocuvm>
80104633:	89 45 f4             	mov    %eax,-0xc(%ebp)
80104636:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010463a:	75 07                	jne    80104643 <growproc+0x85>
      return -1;
8010463c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104641:	eb 1e                	jmp    80104661 <growproc+0xa3>
  }
  proc->sz = sz;
80104643:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104649:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010464c:	89 10                	mov    %edx,(%eax)
  switchuvm(proc);
8010464e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104654:	89 04 24             	mov    %eax,(%esp)
80104657:	e8 86 3f 00 00       	call   801085e2 <switchuvm>
  return 0;
8010465c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104661:	c9                   	leave  
80104662:	c3                   	ret    

80104663 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80104663:	55                   	push   %ebp
80104664:	89 e5                	mov    %esp,%ebp
80104666:	57                   	push   %edi
80104667:	56                   	push   %esi
80104668:	53                   	push   %ebx
80104669:	83 ec 2c             	sub    $0x2c,%esp
  int i, pid;
  struct proc *np;

  // Allocate process.
  if((np = allocproc()) == 0)
8010466c:	e8 d1 fc ff ff       	call   80104342 <allocproc>
80104671:	89 45 e0             	mov    %eax,-0x20(%ebp)
80104674:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104678:	75 0a                	jne    80104684 <fork+0x21>
    return -1;
8010467a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010467f:	e9 af 01 00 00       	jmp    80104833 <fork+0x1d0>

  // Copy process state from p.
  if((np->pgdir = copyuvm(proc->pgdir, proc->sz)) == 0){
80104684:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010468a:	8b 10                	mov    (%eax),%edx
8010468c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104692:	8b 40 04             	mov    0x4(%eax),%eax
80104695:	89 54 24 04          	mov    %edx,0x4(%esp)
80104699:	89 04 24             	mov    %eax,(%esp)
8010469c:	e8 94 44 00 00       	call   80108b35 <copyuvm>
801046a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
801046a4:	89 42 04             	mov    %eax,0x4(%edx)
801046a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046aa:	8b 40 04             	mov    0x4(%eax),%eax
801046ad:	85 c0                	test   %eax,%eax
801046af:	75 2c                	jne    801046dd <fork+0x7a>
    kfree(np->kstack);
801046b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046b4:	8b 40 08             	mov    0x8(%eax),%eax
801046b7:	89 04 24             	mov    %eax,(%esp)
801046ba:	e8 c4 e3 ff ff       	call   80102a83 <kfree>
    np->kstack = 0;
801046bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046c2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    np->state = UNUSED;
801046c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    return -1;
801046d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046d8:	e9 56 01 00 00       	jmp    80104833 <fork+0x1d0>
  }
  np->sz = proc->sz;
801046dd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801046e3:	8b 10                	mov    (%eax),%edx
801046e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046e8:	89 10                	mov    %edx,(%eax)
  np->parent = proc;
801046ea:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801046f1:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046f4:	89 50 14             	mov    %edx,0x14(%eax)
  *np->tf = *proc->tf;
801046f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801046fa:	8b 50 18             	mov    0x18(%eax),%edx
801046fd:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104703:	8b 40 18             	mov    0x18(%eax),%eax
80104706:	89 c3                	mov    %eax,%ebx
80104708:	b8 13 00 00 00       	mov    $0x13,%eax
8010470d:	89 d7                	mov    %edx,%edi
8010470f:	89 de                	mov    %ebx,%esi
80104711:	89 c1                	mov    %eax,%ecx
80104713:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
80104715:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104718:	8b 40 18             	mov    0x18(%eax),%eax
8010471b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
80104722:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80104729:	eb 3d                	jmp    80104768 <fork+0x105>
    if(proc->ofile[i])
8010472b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104731:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104734:	83 c2 08             	add    $0x8,%edx
80104737:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010473b:	85 c0                	test   %eax,%eax
8010473d:	74 25                	je     80104764 <fork+0x101>
      np->ofile[i] = filedup(proc->ofile[i]);
8010473f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104745:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80104748:	83 c2 08             	add    $0x8,%edx
8010474b:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
8010474f:	89 04 24             	mov    %eax,(%esp)
80104752:	e8 69 c8 ff ff       	call   80100fc0 <filedup>
80104757:	8b 55 e0             	mov    -0x20(%ebp),%edx
8010475a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010475d:	83 c1 08             	add    $0x8,%ecx
80104760:	89 44 8a 08          	mov    %eax,0x8(%edx,%ecx,4)
  *np->tf = *proc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
80104764:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
80104768:	83 7d e4 0f          	cmpl   $0xf,-0x1c(%ebp)
8010476c:	7e bd                	jle    8010472b <fork+0xc8>
    if(proc->ofile[i])
      np->ofile[i] = filedup(proc->ofile[i]);
  np->cwd = idup(proc->cwd);
8010476e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104774:	8b 40 68             	mov    0x68(%eax),%eax
80104777:	89 04 24             	mov    %eax,(%esp)
8010477a:	e8 e4 d0 ff ff       	call   80101863 <idup>
8010477f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80104782:	89 42 68             	mov    %eax,0x68(%edx)

  safestrcpy(np->name, proc->name, sizeof(proc->name));
80104785:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010478b:	8d 50 6c             	lea    0x6c(%eax),%edx
8010478e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104791:	83 c0 6c             	add    $0x6c,%eax
80104794:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
8010479b:	00 
8010479c:	89 54 24 04          	mov    %edx,0x4(%esp)
801047a0:	89 04 24             	mov    %eax,(%esp)
801047a3:	e8 bf 11 00 00       	call   80105967 <safestrcpy>
 
  pid = np->pid;
801047a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047ab:	8b 40 10             	mov    0x10(%eax),%eax
801047ae:	89 45 dc             	mov    %eax,-0x24(%ebp)

  // lock to force the compiler to emit the np->state write last.
  acquire(&ptable.lock);
801047b1:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801047b8:	e8 31 0d 00 00       	call   801054ee <acquire>
  np->state = RUNNABLE;
801047bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047c0:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  np->arrived_in_queue = ticks;
801047c7:	a1 00 6a 11 80       	mov    0x80116a00,%eax
801047cc:	89 c2                	mov    %eax,%edx
801047ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047d1:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)

  if (np->pid > 2) {
801047d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
801047da:	8b 40 10             	mov    0x10(%eax),%eax
801047dd:	83 f8 02             	cmp    $0x2,%eax
801047e0:	7e 42                	jle    80104824 <fork+0x1c1>
	  if (proc->pid == 2 || proc->pid == 1){
801047e2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047e8:	8b 40 10             	mov    0x10(%eax),%eax
801047eb:	83 f8 02             	cmp    $0x2,%eax
801047ee:	74 0e                	je     801047fe <fork+0x19b>
801047f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801047f6:	8b 40 10             	mov    0x10(%eax),%eax
801047f9:	83 f8 01             	cmp    $0x1,%eax
801047fc:	75 11                	jne    8010480f <fork+0x1ac>
	    np->gid=np->pid;
801047fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104801:	8b 50 10             	mov    0x10(%eax),%edx
80104804:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104807:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
8010480d:	eb 15                	jmp    80104824 <fork+0x1c1>
	  }
	  else{
	    np->gid=proc->gid;
8010480f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104815:	8b 90 9c 00 00 00    	mov    0x9c(%eax),%edx
8010481b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010481e:	89 90 9c 00 00 00    	mov    %edx,0x9c(%eax)
	  }
  }
  release(&ptable.lock);
80104824:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010482b:	e8 25 0d 00 00       	call   80105555 <release>
  
  return pid;
80104830:	8b 45 dc             	mov    -0x24(%ebp),%eax
}
80104833:	83 c4 2c             	add    $0x2c,%esp
80104836:	5b                   	pop    %ebx
80104837:	5e                   	pop    %esi
80104838:	5f                   	pop    %edi
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    

8010483b <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(int status)
{
8010483b:	55                   	push   %ebp
8010483c:	89 e5                	mov    %esp,%ebp
8010483e:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int fd;

  proc->ttime = ticks;
80104841:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104847:	8b 15 00 6a 11 80    	mov    0x80116a00,%edx
8010484d:	89 90 84 00 00 00    	mov    %edx,0x84(%eax)

  proc->status=status;
80104853:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104859:	8b 55 08             	mov    0x8(%ebp),%edx
8010485c:	89 50 7c             	mov    %edx,0x7c(%eax)
  if(proc == initproc)
8010485f:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104866:	a1 68 c6 10 80       	mov    0x8010c668,%eax
8010486b:	39 c2                	cmp    %eax,%edx
8010486d:	75 0c                	jne    8010487b <exit+0x40>
    panic("init exiting");
8010486f:	c7 04 24 63 90 10 80 	movl   $0x80109063,(%esp)
80104876:	e8 bf bc ff ff       	call   8010053a <panic>

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
8010487b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
80104882:	eb 44                	jmp    801048c8 <exit+0x8d>
    if(proc->ofile[fd]){
80104884:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010488a:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010488d:	83 c2 08             	add    $0x8,%edx
80104890:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80104894:	85 c0                	test   %eax,%eax
80104896:	74 2c                	je     801048c4 <exit+0x89>
      fileclose(proc->ofile[fd]);
80104898:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010489e:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048a1:	83 c2 08             	add    $0x8,%edx
801048a4:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
801048a8:	89 04 24             	mov    %eax,(%esp)
801048ab:	e8 58 c7 ff ff       	call   80101008 <fileclose>
      proc->ofile[fd] = 0;
801048b0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048b6:	8b 55 f0             	mov    -0x10(%ebp),%edx
801048b9:	83 c2 08             	add    $0x8,%edx
801048bc:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
801048c3:	00 
  proc->status=status;
  if(proc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
801048c4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
801048c8:	83 7d f0 0f          	cmpl   $0xf,-0x10(%ebp)
801048cc:	7e b6                	jle    80104884 <exit+0x49>
      fileclose(proc->ofile[fd]);
      proc->ofile[fd] = 0;
    }
  }

  begin_op();
801048ce:	e8 77 eb ff ff       	call   8010344a <begin_op>
  iput(proc->cwd);
801048d3:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048d9:	8b 40 68             	mov    0x68(%eax),%eax
801048dc:	89 04 24             	mov    %eax,(%esp)
801048df:	e8 64 d1 ff ff       	call   80101a48 <iput>
  end_op();
801048e4:	e8 e5 eb ff ff       	call   801034ce <end_op>
  proc->cwd = 0;
801048e9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801048ef:	c7 40 68 00 00 00 00 	movl   $0x0,0x68(%eax)

  acquire(&ptable.lock);
801048f6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801048fd:	e8 ec 0b 00 00       	call   801054ee <acquire>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);
80104902:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104908:	8b 40 14             	mov    0x14(%eax),%eax
8010490b:	89 04 24             	mov    %eax,(%esp)
8010490e:	e8 a4 06 00 00       	call   80104fb7 <wakeup1>

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104913:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010491a:	eb 3b                	jmp    80104957 <exit+0x11c>
    if(p->parent == proc){
8010491c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010491f:	8b 50 14             	mov    0x14(%eax),%edx
80104922:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104928:	39 c2                	cmp    %eax,%edx
8010492a:	75 24                	jne    80104950 <exit+0x115>
      p->parent = initproc;
8010492c:	8b 15 68 c6 10 80    	mov    0x8010c668,%edx
80104932:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104935:	89 50 14             	mov    %edx,0x14(%eax)
      if(p->state == ZOMBIE)
80104938:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010493b:	8b 40 0c             	mov    0xc(%eax),%eax
8010493e:	83 f8 05             	cmp    $0x5,%eax
80104941:	75 0d                	jne    80104950 <exit+0x115>
        wakeup1(initproc);
80104943:	a1 68 c6 10 80       	mov    0x8010c668,%eax
80104948:	89 04 24             	mov    %eax,(%esp)
8010494b:	e8 67 06 00 00       	call   80104fb7 <wakeup1>

  // Parent might be sleeping in wait().
  wakeup1(proc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104950:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104957:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
8010495e:	72 bc                	jb     8010491c <exit+0xe1>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  proc->state = ZOMBIE;
80104960:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104966:	c7 40 0c 05 00 00 00 	movl   $0x5,0xc(%eax)
  sched();
8010496d:	e8 88 04 00 00       	call   80104dfa <sched>
  panic("zombie exit");
80104972:	c7 04 24 70 90 10 80 	movl   $0x80109070,(%esp)
80104979:	e8 bc bb ff ff       	call   8010053a <panic>

8010497e <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(int* status)
{
8010497e:	55                   	push   %ebp
8010497f:	89 e5                	mov    %esp,%ebp
80104981:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104984:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010498b:	e8 5e 0b 00 00       	call   801054ee <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104990:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104997:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010499e:	e9 b2 00 00 00       	jmp    80104a55 <wait+0xd7>
      if(p->parent != proc)
801049a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049a6:	8b 50 14             	mov    0x14(%eax),%edx
801049a9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801049af:	39 c2                	cmp    %eax,%edx
801049b1:	74 05                	je     801049b8 <wait+0x3a>
        continue;
801049b3:	e9 96 00 00 00       	jmp    80104a4e <wait+0xd0>
      havekids = 1;
801049b8:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
801049bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049c2:	8b 40 0c             	mov    0xc(%eax),%eax
801049c5:	83 f8 05             	cmp    $0x5,%eax
801049c8:	0f 85 80 00 00 00    	jne    80104a4e <wait+0xd0>
        // Found one.
        pid = p->pid;
801049ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049d1:	8b 40 10             	mov    0x10(%eax),%eax
801049d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
801049d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049da:	8b 40 08             	mov    0x8(%eax),%eax
801049dd:	89 04 24             	mov    %eax,(%esp)
801049e0:	e8 9e e0 ff ff       	call   80102a83 <kfree>
        p->kstack = 0;
801049e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
801049ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049f2:	8b 40 04             	mov    0x4(%eax),%eax
801049f5:	89 04 24             	mov    %eax,(%esp)
801049f8:	e8 58 40 00 00       	call   80108a55 <freevm>
        p->state = UNUSED;
801049fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a0a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a14:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a1e:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a25:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
	if (status != 0) {
80104a2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80104a30:	74 0b                	je     80104a3d <wait+0xbf>
		*status = p->status;
80104a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a35:	8b 50 7c             	mov    0x7c(%eax),%edx
80104a38:	8b 45 08             	mov    0x8(%ebp),%eax
80104a3b:	89 10                	mov    %edx,(%eax)
	}
        release(&ptable.lock);
80104a3d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a44:	e8 0c 0b 00 00       	call   80105555 <release>
        return pid;
80104a49:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a4c:	eb 55                	jmp    80104aa3 <wait+0x125>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104a4e:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104a55:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
80104a5c:	0f 82 41 ff ff ff    	jb     801049a3 <wait+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104a62:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104a66:	74 0d                	je     80104a75 <wait+0xf7>
80104a68:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a6e:	8b 40 24             	mov    0x24(%eax),%eax
80104a71:	85 c0                	test   %eax,%eax
80104a73:	74 13                	je     80104a88 <wait+0x10a>
      release(&ptable.lock);
80104a75:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104a7c:	e8 d4 0a 00 00       	call   80105555 <release>
      return -1;
80104a81:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a86:	eb 1b                	jmp    80104aa3 <wait+0x125>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104a88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104a8e:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104a95:	80 
80104a96:	89 04 24             	mov    %eax,(%esp)
80104a99:	e8 7e 04 00 00       	call   80104f1c <sleep>
  }
80104a9e:	e9 ed fe ff ff       	jmp    80104990 <wait+0x12>
}
80104aa3:	c9                   	leave  
80104aa4:	c3                   	ret    

80104aa5 <waitpid>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
waitpid(int pid, int* status, int options)
{
80104aa5:	55                   	push   %ebp
80104aa6:	89 e5                	mov    %esp,%ebp
80104aa8:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80104aab:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ab2:	e8 37 0a 00 00       	call   801054ee <acquire>

  // Scan through table looking for a child process with given pid
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ab7:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104abe:	e9 fd 00 00 00       	jmp    80104bc0 <waitpid+0x11b>

    if(p->pid != pid)
80104ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ac6:	8b 40 10             	mov    0x10(%eax),%eax
80104ac9:	3b 45 08             	cmp    0x8(%ebp),%eax
80104acc:	74 0c                	je     80104ada <waitpid+0x35>
  struct proc *p;

  acquire(&ptable.lock);

  // Scan through table looking for a child process with given pid
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104ace:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104ad5:	e9 e6 00 00 00       	jmp    80104bc0 <waitpid+0x11b>

    if(p->pid != pid)
        continue;

    p->parent=proc;
80104ada:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae4:	89 50 14             	mov    %edx,0x14(%eax)

    if(options == 0){
80104ae7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80104aeb:	75 16                	jne    80104b03 <waitpid+0x5e>
            release(&ptable.lock);
80104aed:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104af4:	e8 5c 0a 00 00       	call   80105555 <release>
            return -1;
80104af9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104afe:	e9 db 00 00 00       	jmp    80104bde <waitpid+0x139>
    }

    for(;;){
        if(p->state == ZOMBIE){
80104b03:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b06:	8b 40 0c             	mov    0xc(%eax),%eax
80104b09:	83 f8 05             	cmp    $0x5,%eax
80104b0c:	75 77                	jne    80104b85 <waitpid+0xe0>
            // Found one.
            kfree(p->kstack);
80104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b11:	8b 40 08             	mov    0x8(%eax),%eax
80104b14:	89 04 24             	mov    %eax,(%esp)
80104b17:	e8 67 df ff ff       	call   80102a83 <kfree>
            p->kstack = 0;
80104b1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b1f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
            freevm(p->pgdir);
80104b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b29:	8b 40 04             	mov    0x4(%eax),%eax
80104b2c:	89 04 24             	mov    %eax,(%esp)
80104b2f:	e8 21 3f 00 00       	call   80108a55 <freevm>
            p->state = UNUSED;
80104b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b37:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
            p->pid = 0;
80104b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b41:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
            p->parent = 0;
80104b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b4b:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
            p->name[0] = 0;
80104b52:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b55:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
            p->killed = 0;
80104b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b5c:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
            if (status != 0) {
80104b63:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104b67:	74 0b                	je     80104b74 <waitpid+0xcf>
              *status = p->status;
80104b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b6c:	8b 50 7c             	mov    0x7c(%eax),%edx
80104b6f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104b72:	89 10                	mov    %edx,(%eax)
            }
            release(&ptable.lock);
80104b74:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b7b:	e8 d5 09 00 00       	call   80105555 <release>
            return pid;
80104b80:	8b 45 08             	mov    0x8(%ebp),%eax
80104b83:	eb 59                	jmp    80104bde <waitpid+0x139>
        } 

        if(proc->killed){
80104b85:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104b8b:	8b 40 24             	mov    0x24(%eax),%eax
80104b8e:	85 c0                	test   %eax,%eax
80104b90:	74 13                	je     80104ba5 <waitpid+0x100>
            release(&ptable.lock);
80104b92:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104b99:	e8 b7 09 00 00       	call   80105555 <release>
            return -1;
80104b9e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ba3:	eb 39                	jmp    80104bde <waitpid+0x139>
        }

        sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104ba5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104bab:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104bb2:	80 
80104bb3:	89 04 24             	mov    %eax,(%esp)
80104bb6:	e8 61 03 00 00       	call   80104f1c <sleep>
    }
80104bbb:	e9 43 ff ff ff       	jmp    80104b03 <waitpid+0x5e>
  struct proc *p;

  acquire(&ptable.lock);

  // Scan through table looking for a child process with given pid
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bc0:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
80104bc7:	0f 82 f6 fe ff ff    	jb     80104ac3 <waitpid+0x1e>
        sleep(proc, &ptable.lock);  //DOC: wait-sleep
    }
}

  // no process with given pid
  release(&ptable.lock);
80104bcd:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104bd4:	e8 7c 09 00 00       	call   80105555 <release>
  return -1;
80104bd9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax

}
80104bde:	c9                   	leave  
80104bdf:	c3                   	ret    

80104be0 <wait_stat>:

int
wait_stat(int* wtime, int* rtime, int* iotime, int* status)
{
80104be0:	55                   	push   %ebp
80104be1:	89 e5                	mov    %esp,%ebp
80104be3:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;
  int havekids, pid;

  acquire(&ptable.lock);
80104be6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104bed:	e8 fc 08 00 00       	call   801054ee <acquire>
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
80104bf2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104bf9:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104c00:	e9 d6 00 00 00       	jmp    80104cdb <wait_stat+0xfb>
      if(p->parent != proc)
80104c05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c08:	8b 50 14             	mov    0x14(%eax),%edx
80104c0b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104c11:	39 c2                	cmp    %eax,%edx
80104c13:	74 05                	je     80104c1a <wait_stat+0x3a>
        continue;
80104c15:	e9 ba 00 00 00       	jmp    80104cd4 <wait_stat+0xf4>
      havekids = 1;
80104c1a:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
      if(p->state == ZOMBIE){
80104c21:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c24:	8b 40 0c             	mov    0xc(%eax),%eax
80104c27:	83 f8 05             	cmp    $0x5,%eax
80104c2a:	0f 85 a4 00 00 00    	jne    80104cd4 <wait_stat+0xf4>
        // Found one.
        pid = p->pid;
80104c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c33:	8b 40 10             	mov    0x10(%eax),%eax
80104c36:	89 45 ec             	mov    %eax,-0x14(%ebp)
        kfree(p->kstack);
80104c39:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c3c:	8b 40 08             	mov    0x8(%eax),%eax
80104c3f:	89 04 24             	mov    %eax,(%esp)
80104c42:	e8 3c de ff ff       	call   80102a83 <kfree>
        p->kstack = 0;
80104c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c4a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        freevm(p->pgdir);
80104c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c54:	8b 40 04             	mov    0x4(%eax),%eax
80104c57:	89 04 24             	mov    %eax,(%esp)
80104c5a:	e8 f6 3d 00 00       	call   80108a55 <freevm>
        p->state = UNUSED;
80104c5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c62:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        p->pid = 0;
80104c69:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c6c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        p->parent = 0;
80104c73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c76:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        p->name[0] = 0;
80104c7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c80:	c6 40 6c 00          	movb   $0x0,0x6c(%eax)
        p->killed = 0;
80104c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c87:	c7 40 24 00 00 00 00 	movl   $0x0,0x24(%eax)
	*status = p->status;
80104c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c91:	8b 50 7c             	mov    0x7c(%eax),%edx
80104c94:	8b 45 14             	mov    0x14(%ebp),%eax
80104c97:	89 10                	mov    %edx,(%eax)
        *wtime = p->retime;
80104c99:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c9c:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
80104ca2:	8b 45 08             	mov    0x8(%ebp),%eax
80104ca5:	89 10                	mov    %edx,(%eax)
        *rtime = p->rutime;
80104ca7:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104caa:	8b 90 90 00 00 00    	mov    0x90(%eax),%edx
80104cb0:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cb3:	89 10                	mov    %edx,(%eax)
        *iotime = p->stime;
80104cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104cb8:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80104cbe:	8b 45 10             	mov    0x10(%ebp),%eax
80104cc1:	89 10                	mov    %edx,(%eax)
 
        release(&ptable.lock);
80104cc3:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104cca:	e8 86 08 00 00       	call   80105555 <release>
        return pid;
80104ccf:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cd2:	eb 55                	jmp    80104d29 <wait_stat+0x149>

  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for zombie children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104cd4:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104cdb:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
80104ce2:	0f 82 1d ff ff ff    	jb     80104c05 <wait_stat+0x25>
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || proc->killed){
80104ce8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104cec:	74 0d                	je     80104cfb <wait_stat+0x11b>
80104cee:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104cf4:	8b 40 24             	mov    0x24(%eax),%eax
80104cf7:	85 c0                	test   %eax,%eax
80104cf9:	74 13                	je     80104d0e <wait_stat+0x12e>
      release(&ptable.lock);
80104cfb:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d02:	e8 4e 08 00 00       	call   80105555 <release>
      return -1;
80104d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d0c:	eb 1b                	jmp    80104d29 <wait_stat+0x149>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(proc, &ptable.lock);  //DOC: wait-sleep
80104d0e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104d14:	c7 44 24 04 80 39 11 	movl   $0x80113980,0x4(%esp)
80104d1b:	80 
80104d1c:	89 04 24             	mov    %eax,(%esp)
80104d1f:	e8 f8 01 00 00       	call   80104f1c <sleep>
  }
80104d24:	e9 c9 fe ff ff       	jmp    80104bf2 <wait_stat+0x12>
}
80104d29:	c9                   	leave  
80104d2a:	c3                   	ret    

80104d2b <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80104d2b:	55                   	push   %ebp
80104d2c:	89 e5                	mov    %esp,%ebp
80104d2e:	83 ec 28             	sub    $0x28,%esp

 else if(strategy == 2 || strategy == 3) {

    	for(;;){

        sti();
80104d31:	e8 ea f5 ff ff       	call   80104320 <sti>

    		acquire(&ptable.lock);	  
80104d36:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104d3d:	e8 ac 07 00 00       	call   801054ee <acquire>
        int earliest_ticks;
        earliest_ticks = SHRT_MAX;
80104d42:	c7 45 ec ff 7f 00 00 	movl   $0x7fff,-0x14(%ebp)
        earliest_proc = 0;
80104d49:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d50:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
80104d57:	eb 34                	jmp    80104d8d <scheduler+0x62>
        
            if(p->state != RUNNABLE)
80104d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d5c:	8b 40 0c             	mov    0xc(%eax),%eax
80104d5f:	83 f8 03             	cmp    $0x3,%eax
80104d62:	74 02                	je     80104d66 <scheduler+0x3b>
              continue;
80104d64:	eb 20                	jmp    80104d86 <scheduler+0x5b>

            if(p->arrived_in_queue < earliest_ticks) {
80104d66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d69:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104d6f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
80104d72:	7d 12                	jge    80104d86 <scheduler+0x5b>
                earliest_ticks = p->arrived_in_queue;
80104d74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d77:	8b 80 98 00 00 00    	mov    0x98(%eax),%eax
80104d7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
                earliest_proc = p;
80104d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    		acquire(&ptable.lock);	  
        int earliest_ticks;
        earliest_ticks = SHRT_MAX;
        earliest_proc = 0;

        for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104d86:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80104d8d:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
80104d94:	72 c3                	jb     80104d59 <scheduler+0x2e>
                earliest_ticks = p->arrived_in_queue;
                earliest_proc = p;
            }
        }

        if(earliest_proc != 0){
80104d96:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80104d9a:	74 4d                	je     80104de9 <scheduler+0xbe>
            proc = earliest_proc;
80104d9c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104d9f:	65 a3 04 00 00 00    	mov    %eax,%gs:0x4
            switchuvm(earliest_proc);
80104da5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104da8:	89 04 24             	mov    %eax,(%esp)
80104dab:	e8 32 38 00 00       	call   801085e2 <switchuvm>
            earliest_proc->state = RUNNING;
80104db0:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104db3:	c7 40 0c 04 00 00 00 	movl   $0x4,0xc(%eax)
            swtch(&cpu->scheduler, proc->context);
80104dba:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104dc0:	8b 40 1c             	mov    0x1c(%eax),%eax
80104dc3:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80104dca:	83 c2 04             	add    $0x4,%edx
80104dcd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104dd1:	89 14 24             	mov    %edx,(%esp)
80104dd4:	e8 ff 0b 00 00       	call   801059d8 <swtch>
            switchkvm();
80104dd9:	e8 e7 37 00 00       	call   801085c5 <switchkvm>
            proc = 0;
80104dde:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
80104de5:	00 00 00 00 
        }

        release(&ptable.lock);
80104de9:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104df0:	e8 60 07 00 00       	call   80105555 <release>

    	}	
80104df5:	e9 37 ff ff ff       	jmp    80104d31 <scheduler+0x6>

80104dfa <sched>:

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state.
void
sched(void)
{
80104dfa:	55                   	push   %ebp
80104dfb:	89 e5                	mov    %esp,%ebp
80104dfd:	83 ec 28             	sub    $0x28,%esp
  int intena;

  if(!holding(&ptable.lock))
80104e00:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104e07:	e8 11 08 00 00       	call   8010561d <holding>
80104e0c:	85 c0                	test   %eax,%eax
80104e0e:	75 0c                	jne    80104e1c <sched+0x22>
    panic("sched ptable.lock");
80104e10:	c7 04 24 7c 90 10 80 	movl   $0x8010907c,(%esp)
80104e17:	e8 1e b7 ff ff       	call   8010053a <panic>
  if(cpu->ncli != 1)
80104e1c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e22:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
80104e28:	83 f8 01             	cmp    $0x1,%eax
80104e2b:	74 0c                	je     80104e39 <sched+0x3f>
    panic("sched locks");
80104e2d:	c7 04 24 8e 90 10 80 	movl   $0x8010908e,(%esp)
80104e34:	e8 01 b7 ff ff       	call   8010053a <panic>
  if(proc->state == RUNNING)
80104e39:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104e3f:	8b 40 0c             	mov    0xc(%eax),%eax
80104e42:	83 f8 04             	cmp    $0x4,%eax
80104e45:	75 0c                	jne    80104e53 <sched+0x59>
    panic("sched running");
80104e47:	c7 04 24 9a 90 10 80 	movl   $0x8010909a,(%esp)
80104e4e:	e8 e7 b6 ff ff       	call   8010053a <panic>
  if(readeflags()&FL_IF)
80104e53:	e8 b8 f4 ff ff       	call   80104310 <readeflags>
80104e58:	25 00 02 00 00       	and    $0x200,%eax
80104e5d:	85 c0                	test   %eax,%eax
80104e5f:	74 0c                	je     80104e6d <sched+0x73>
    panic("sched interruptible");
80104e61:	c7 04 24 a8 90 10 80 	movl   $0x801090a8,(%esp)
80104e68:	e8 cd b6 ff ff       	call   8010053a <panic>
  intena = cpu->intena;
80104e6d:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e73:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
80104e79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  swtch(&proc->context, cpu->scheduler);
80104e7c:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104e82:	8b 40 04             	mov    0x4(%eax),%eax
80104e85:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
80104e8c:	83 c2 1c             	add    $0x1c,%edx
80104e8f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e93:	89 14 24             	mov    %edx,(%esp)
80104e96:	e8 3d 0b 00 00       	call   801059d8 <swtch>
  cpu->intena = intena;
80104e9b:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80104ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104ea4:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80104eaa:	c9                   	leave  
80104eab:	c3                   	ret    

80104eac <yield>:

// Give up the CPU for one scheduling round.
void
yield(void)
{
80104eac:	55                   	push   %ebp
80104ead:	89 e5                	mov    %esp,%ebp
80104eaf:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104eb2:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104eb9:	e8 30 06 00 00       	call   801054ee <acquire>
  proc->state = RUNNABLE;
80104ebe:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ec4:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  proc->arrived_in_queue = ticks;
80104ecb:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104ed1:	8b 15 00 6a 11 80    	mov    0x80116a00,%edx
80104ed7:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
  sched();
80104edd:	e8 18 ff ff ff       	call   80104dfa <sched>
  release(&ptable.lock);
80104ee2:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104ee9:	e8 67 06 00 00       	call   80105555 <release>
}
80104eee:	c9                   	leave  
80104eef:	c3                   	ret    

80104ef0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80104ef0:	55                   	push   %ebp
80104ef1:	89 e5                	mov    %esp,%ebp
80104ef3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80104ef6:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104efd:	e8 53 06 00 00       	call   80105555 <release>

  if (first) {
80104f02:	a1 08 c0 10 80       	mov    0x8010c008,%eax
80104f07:	85 c0                	test   %eax,%eax
80104f09:	74 0f                	je     80104f1a <forkret+0x2a>
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot 
    // be run from main().
    first = 0;
80104f0b:	c7 05 08 c0 10 80 00 	movl   $0x0,0x8010c008
80104f12:	00 00 00 
    initlog();
80104f15:	e8 22 e3 ff ff       	call   8010323c <initlog>
  }
  
  // Return to "caller", actually trapret (see allocproc).
}
80104f1a:	c9                   	leave  
80104f1b:	c3                   	ret    

80104f1c <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80104f1c:	55                   	push   %ebp
80104f1d:	89 e5                	mov    %esp,%ebp
80104f1f:	83 ec 18             	sub    $0x18,%esp
  if(proc == 0)
80104f22:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f28:	85 c0                	test   %eax,%eax
80104f2a:	75 0c                	jne    80104f38 <sleep+0x1c>
    panic("sleep");
80104f2c:	c7 04 24 bc 90 10 80 	movl   $0x801090bc,(%esp)
80104f33:	e8 02 b6 ff ff       	call   8010053a <panic>

  if(lk == 0)
80104f38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80104f3c:	75 0c                	jne    80104f4a <sleep+0x2e>
    panic("sleep without lk");
80104f3e:	c7 04 24 c2 90 10 80 	movl   $0x801090c2,(%esp)
80104f45:	e8 f0 b5 ff ff       	call   8010053a <panic>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104f4a:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104f51:	74 17                	je     80104f6a <sleep+0x4e>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104f53:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104f5a:	e8 8f 05 00 00       	call   801054ee <acquire>
    release(lk);
80104f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
80104f62:	89 04 24             	mov    %eax,(%esp)
80104f65:	e8 eb 05 00 00       	call   80105555 <release>
  }

  // Go to sleep.
  proc->chan = chan;
80104f6a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f70:	8b 55 08             	mov    0x8(%ebp),%edx
80104f73:	89 50 20             	mov    %edx,0x20(%eax)
  proc->state = SLEEPING;
80104f76:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f7c:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80104f83:	e8 72 fe ff ff       	call   80104dfa <sched>

  // Tidy up.
  proc->chan = 0;
80104f88:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80104f8e:	c7 40 20 00 00 00 00 	movl   $0x0,0x20(%eax)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
80104f95:	81 7d 0c 80 39 11 80 	cmpl   $0x80113980,0xc(%ebp)
80104f9c:	74 17                	je     80104fb5 <sleep+0x99>
    release(&ptable.lock);
80104f9e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80104fa5:	e8 ab 05 00 00       	call   80105555 <release>
    acquire(lk);
80104faa:	8b 45 0c             	mov    0xc(%ebp),%eax
80104fad:	89 04 24             	mov    %eax,(%esp)
80104fb0:	e8 39 05 00 00       	call   801054ee <acquire>
  }
}
80104fb5:	c9                   	leave  
80104fb6:	c3                   	ret    

80104fb7 <wakeup1>:
//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
80104fb7:	55                   	push   %ebp
80104fb8:	89 e5                	mov    %esp,%ebp
80104fba:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104fbd:	c7 45 fc b4 39 11 80 	movl   $0x801139b4,-0x4(%ebp)
80104fc4:	eb 37                	jmp    80104ffd <wakeup1+0x46>
    if(p->state == SLEEPING && p->chan == chan){
80104fc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fc9:	8b 40 0c             	mov    0xc(%eax),%eax
80104fcc:	83 f8 02             	cmp    $0x2,%eax
80104fcf:	75 25                	jne    80104ff6 <wakeup1+0x3f>
80104fd1:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fd4:	8b 40 20             	mov    0x20(%eax),%eax
80104fd7:	3b 45 08             	cmp    0x8(%ebp),%eax
80104fda:	75 1a                	jne    80104ff6 <wakeup1+0x3f>
        p->state = RUNNABLE;
80104fdc:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104fdf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
        p->arrived_in_queue = ticks;
80104fe6:	a1 00 6a 11 80       	mov    0x80116a00,%eax
80104feb:	89 c2                	mov    %eax,%edx
80104fed:	8b 45 fc             	mov    -0x4(%ebp),%eax
80104ff0:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104ff6:	81 45 fc a0 00 00 00 	addl   $0xa0,-0x4(%ebp)
80104ffd:	81 7d fc b4 61 11 80 	cmpl   $0x801161b4,-0x4(%ebp)
80105004:	72 c0                	jb     80104fc6 <wakeup1+0xf>
    if(p->state == SLEEPING && p->chan == chan){
        p->state = RUNNABLE;
        p->arrived_in_queue = ticks;
    }
}
80105006:	c9                   	leave  
80105007:	c3                   	ret    

80105008 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80105008:	55                   	push   %ebp
80105009:	89 e5                	mov    %esp,%ebp
8010500b:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);
8010500e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105015:	e8 d4 04 00 00       	call   801054ee <acquire>
  wakeup1(chan);
8010501a:	8b 45 08             	mov    0x8(%ebp),%eax
8010501d:	89 04 24             	mov    %eax,(%esp)
80105020:	e8 92 ff ff ff       	call   80104fb7 <wakeup1>
  release(&ptable.lock);
80105025:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010502c:	e8 24 05 00 00       	call   80105555 <release>
}
80105031:	c9                   	leave  
80105032:	c3                   	ret    

80105033 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80105033:	55                   	push   %ebp
80105034:	89 e5                	mov    %esp,%ebp
80105036:	83 ec 28             	sub    $0x28,%esp
  struct proc *p;

  acquire(&ptable.lock);
80105039:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105040:	e8 a9 04 00 00       	call   801054ee <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105045:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010504c:	eb 54                	jmp    801050a2 <kill+0x6f>
    if(p->pid == pid){
8010504e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105051:	8b 40 10             	mov    0x10(%eax),%eax
80105054:	3b 45 08             	cmp    0x8(%ebp),%eax
80105057:	75 42                	jne    8010509b <kill+0x68>
      p->killed = 1;
80105059:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010505c:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING){
80105063:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105066:	8b 40 0c             	mov    0xc(%eax),%eax
80105069:	83 f8 02             	cmp    $0x2,%eax
8010506c:	75 1a                	jne    80105088 <kill+0x55>
          p->state = RUNNABLE;
8010506e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105071:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
          p->arrived_in_queue = ticks;
80105078:	a1 00 6a 11 80       	mov    0x80116a00,%eax
8010507d:	89 c2                	mov    %eax,%edx
8010507f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105082:	89 90 98 00 00 00    	mov    %edx,0x98(%eax)
      }
      release(&ptable.lock);
80105088:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010508f:	e8 c1 04 00 00       	call   80105555 <release>
      return 0;
80105094:	b8 00 00 00 00       	mov    $0x0,%eax
80105099:	eb 21                	jmp    801050bc <kill+0x89>
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010509b:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
801050a2:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
801050a9:	72 a3                	jb     8010504e <kill+0x1b>
      }
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
801050ab:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801050b2:	e8 9e 04 00 00       	call   80105555 <release>
  return -1;
801050b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801050bc:	c9                   	leave  
801050bd:	c3                   	ret    

801050be <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801050be:	55                   	push   %ebp
801050bf:	89 e5                	mov    %esp,%ebp
801050c1:	83 ec 58             	sub    $0x58,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801050c4:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
801050cb:	e9 d9 00 00 00       	jmp    801051a9 <procdump+0xeb>
    if(p->state == UNUSED)
801050d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050d3:	8b 40 0c             	mov    0xc(%eax),%eax
801050d6:	85 c0                	test   %eax,%eax
801050d8:	75 05                	jne    801050df <procdump+0x21>
      continue;
801050da:	e9 c3 00 00 00       	jmp    801051a2 <procdump+0xe4>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
801050df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050e2:	8b 40 0c             	mov    0xc(%eax),%eax
801050e5:	83 f8 05             	cmp    $0x5,%eax
801050e8:	77 23                	ja     8010510d <procdump+0x4f>
801050ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050ed:	8b 40 0c             	mov    0xc(%eax),%eax
801050f0:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
801050f7:	85 c0                	test   %eax,%eax
801050f9:	74 12                	je     8010510d <procdump+0x4f>
      state = states[p->state];
801050fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801050fe:	8b 40 0c             	mov    0xc(%eax),%eax
80105101:	8b 04 85 0c c0 10 80 	mov    -0x7fef3ff4(,%eax,4),%eax
80105108:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010510b:	eb 07                	jmp    80105114 <procdump+0x56>
    else
      state = "???";
8010510d:	c7 45 ec d3 90 10 80 	movl   $0x801090d3,-0x14(%ebp)
    cprintf("%d %s %s", p->pid, state, p->name);
80105114:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105117:	8d 50 6c             	lea    0x6c(%eax),%edx
8010511a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010511d:	8b 40 10             	mov    0x10(%eax),%eax
80105120:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105124:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105127:	89 54 24 08          	mov    %edx,0x8(%esp)
8010512b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010512f:	c7 04 24 d7 90 10 80 	movl   $0x801090d7,(%esp)
80105136:	e8 65 b2 ff ff       	call   801003a0 <cprintf>
    if(p->state == SLEEPING){
8010513b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010513e:	8b 40 0c             	mov    0xc(%eax),%eax
80105141:	83 f8 02             	cmp    $0x2,%eax
80105144:	75 50                	jne    80105196 <procdump+0xd8>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80105146:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105149:	8b 40 1c             	mov    0x1c(%eax),%eax
8010514c:	8b 40 0c             	mov    0xc(%eax),%eax
8010514f:	83 c0 08             	add    $0x8,%eax
80105152:	8d 55 c4             	lea    -0x3c(%ebp),%edx
80105155:	89 54 24 04          	mov    %edx,0x4(%esp)
80105159:	89 04 24             	mov    %eax,(%esp)
8010515c:	e8 43 04 00 00       	call   801055a4 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80105161:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80105168:	eb 1b                	jmp    80105185 <procdump+0xc7>
        cprintf(" %p", pc[i]);
8010516a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010516d:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105171:	89 44 24 04          	mov    %eax,0x4(%esp)
80105175:	c7 04 24 e0 90 10 80 	movl   $0x801090e0,(%esp)
8010517c:	e8 1f b2 ff ff       	call   801003a0 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80105181:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80105185:	83 7d f4 09          	cmpl   $0x9,-0xc(%ebp)
80105189:	7f 0b                	jg     80105196 <procdump+0xd8>
8010518b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010518e:	8b 44 85 c4          	mov    -0x3c(%ebp,%eax,4),%eax
80105192:	85 c0                	test   %eax,%eax
80105194:	75 d4                	jne    8010516a <procdump+0xac>
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80105196:	c7 04 24 e4 90 10 80 	movl   $0x801090e4,(%esp)
8010519d:	e8 fe b1 ff ff       	call   801003a0 <cprintf>
  int i;
  struct proc *p;
  char *state;
  uint pc[10];
  
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051a2:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
801051a9:	81 7d f0 b4 61 11 80 	cmpl   $0x801161b4,-0x10(%ebp)
801051b0:	0f 82 1a ff ff ff    	jb     801050d0 <procdump+0x12>
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
801051b6:	c9                   	leave  
801051b7:	c3                   	ret    

801051b8 <updateProcessesTimes>:

void
updateProcessesTimes(){
801051b8:	55                   	push   %ebp
801051b9:	89 e5                	mov    %esp,%ebp
801051bb:	83 ec 28             	sub    $0x28,%esp

  acquire(&ptable.lock);
801051be:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801051c5:	e8 24 03 00 00       	call   801054ee <acquire>
  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801051ca:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
801051d1:	eb 61                	jmp    80105234 <updateProcessesTimes+0x7c>
    switch(p->state){
801051d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051d6:	8b 40 0c             	mov    0xc(%eax),%eax
801051d9:	83 f8 05             	cmp    $0x5,%eax
801051dc:	77 4f                	ja     8010522d <updateProcessesTimes+0x75>
801051de:	8b 04 85 e8 90 10 80 	mov    -0x7fef6f18(,%eax,4),%eax
801051e5:	ff e0                	jmp    *%eax
      case RUNNABLE:
        p->retime++;
801051e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ea:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801051f0:	8d 50 01             	lea    0x1(%eax),%edx
801051f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051f6:	89 90 8c 00 00 00    	mov    %edx,0x8c(%eax)
        break;
801051fc:	eb 2f                	jmp    8010522d <updateProcessesTimes+0x75>
      case RUNNING:
        p->rutime++;
801051fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105201:	8b 80 90 00 00 00    	mov    0x90(%eax),%eax
80105207:	8d 50 01             	lea    0x1(%eax),%edx
8010520a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520d:	89 90 90 00 00 00    	mov    %edx,0x90(%eax)
        break;
80105213:	eb 18                	jmp    8010522d <updateProcessesTimes+0x75>
      case SLEEPING:
        p->stime++;
80105215:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105218:	8b 80 88 00 00 00    	mov    0x88(%eax),%eax
8010521e:	8d 50 01             	lea    0x1(%eax),%edx
80105221:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105224:	89 90 88 00 00 00    	mov    %edx,0x88(%eax)
        break;
8010522a:	eb 01                	jmp    8010522d <updateProcessesTimes+0x75>
      case UNUSED:
      case EMBRYO:
      case ZOMBIE:
      break;
8010522c:	90                   	nop
void
updateProcessesTimes(){

  acquire(&ptable.lock);
  struct proc* p;
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010522d:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80105234:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
8010523b:	72 96                	jb     801051d3 <updateProcessesTimes+0x1b>
      case EMBRYO:
      case ZOMBIE:
      break;
    }
  }
  release(&ptable.lock);
8010523d:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105244:	e8 0c 03 00 00       	call   80105555 <release>
}
80105249:	c9                   	leave  
8010524a:	c3                   	ret    

8010524b <set_priority>:

int set_priority(int priority){
8010524b:	55                   	push   %ebp
8010524c:	89 e5                	mov    %esp,%ebp
8010524e:	83 ec 10             	sub    $0x10,%esp
  int old_priority=proc->priority;
80105251:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105257:	8b 80 94 00 00 00    	mov    0x94(%eax),%eax
8010525d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  switch(priority){
80105260:	8b 45 08             	mov    0x8(%ebp),%eax
80105263:	83 e8 01             	sub    $0x1,%eax
80105266:	83 f8 02             	cmp    $0x2,%eax
80105269:	77 14                	ja     8010527f <set_priority+0x34>
    case HIGH:
    case MEDIUM:
    case LOW:
      proc->priority = priority;
8010526b:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105271:	8b 55 08             	mov    0x8(%ebp),%edx
80105274:	89 90 94 00 00 00    	mov    %edx,0x94(%eax)
      return old_priority;
8010527a:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010527d:	eb 05                	jmp    80105284 <set_priority+0x39>
  }
  
  return -1;
8010527f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105284:	c9                   	leave  
80105285:	c3                   	ret    

80105286 <canRemoveJob>:

int canRemoveJob(int gid) {
80105286:	55                   	push   %ebp
80105287:	89 e5                	mov    %esp,%ebp
80105289:	83 ec 28             	sub    $0x28,%esp
  int ans=1;
8010528c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  struct proc* p;
  acquire(&ptable.lock);
80105293:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010529a:	e8 4f 02 00 00       	call   801054ee <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010529f:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
801052a6:	eb 3f                	jmp    801052e7 <canRemoveJob+0x61>
	if (p->gid==gid && (p->state == SLEEPING || p->state == RUNNING || p->state == RUNNABLE)) {
801052a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052ab:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
801052b1:	3b 45 08             	cmp    0x8(%ebp),%eax
801052b4:	75 2a                	jne    801052e0 <canRemoveJob+0x5a>
801052b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052b9:	8b 40 0c             	mov    0xc(%eax),%eax
801052bc:	83 f8 02             	cmp    $0x2,%eax
801052bf:	74 16                	je     801052d7 <canRemoveJob+0x51>
801052c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052c4:	8b 40 0c             	mov    0xc(%eax),%eax
801052c7:	83 f8 04             	cmp    $0x4,%eax
801052ca:	74 0b                	je     801052d7 <canRemoveJob+0x51>
801052cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801052cf:	8b 40 0c             	mov    0xc(%eax),%eax
801052d2:	83 f8 03             	cmp    $0x3,%eax
801052d5:	75 09                	jne    801052e0 <canRemoveJob+0x5a>
		ans=0;
801052d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		break;
801052de:	eb 10                	jmp    801052f0 <canRemoveJob+0x6a>

int canRemoveJob(int gid) {
  int ans=1;
  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801052e0:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
801052e7:	81 7d f0 b4 61 11 80 	cmpl   $0x801161b4,-0x10(%ebp)
801052ee:	72 b8                	jb     801052a8 <canRemoveJob+0x22>
	if (p->gid==gid && (p->state == SLEEPING || p->state == RUNNING || p->state == RUNNABLE)) {
		ans=0;
		break;
	}
  }    
  release(&ptable.lock);
801052f0:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801052f7:	e8 59 02 00 00       	call   80105555 <release>
  return ans;
801052fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
801052ff:	c9                   	leave  
80105300:	c3                   	ret    

80105301 <jobs>:

int jobs(int gid){
80105301:	55                   	push   %ebp
80105302:	89 e5                	mov    %esp,%ebp
80105304:	83 ec 28             	sub    $0x28,%esp
  struct proc* p;
  acquire(&ptable.lock);
80105307:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010530e:	e8 db 01 00 00       	call   801054ee <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105313:	c7 45 f4 b4 39 11 80 	movl   $0x801139b4,-0xc(%ebp)
8010531a:	eb 69                	jmp    80105385 <jobs+0x84>
	if (p->gid==gid && p->pid > 2 && !(p->name[0] == 's' && p->name[1] == 'h' && strlen(p->name) == 2)) {
8010531c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010531f:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
80105325:	3b 45 08             	cmp    0x8(%ebp),%eax
80105328:	75 54                	jne    8010537e <jobs+0x7d>
8010532a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010532d:	8b 40 10             	mov    0x10(%eax),%eax
80105330:	83 f8 02             	cmp    $0x2,%eax
80105333:	7e 49                	jle    8010537e <jobs+0x7d>
80105335:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105338:	0f b6 40 6c          	movzbl 0x6c(%eax),%eax
8010533c:	3c 73                	cmp    $0x73,%al
8010533e:	75 1e                	jne    8010535e <jobs+0x5d>
80105340:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105343:	0f b6 40 6d          	movzbl 0x6d(%eax),%eax
80105347:	3c 68                	cmp    $0x68,%al
80105349:	75 13                	jne    8010535e <jobs+0x5d>
8010534b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010534e:	83 c0 6c             	add    $0x6c,%eax
80105351:	89 04 24             	mov    %eax,(%esp)
80105354:	e8 58 06 00 00       	call   801059b1 <strlen>
80105359:	83 f8 02             	cmp    $0x2,%eax
8010535c:	74 20                	je     8010537e <jobs+0x7d>
		cprintf("%d: %s\n",p->pid,p->name);
8010535e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105361:	8d 50 6c             	lea    0x6c(%eax),%edx
80105364:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105367:	8b 40 10             	mov    0x10(%eax),%eax
8010536a:	89 54 24 08          	mov    %edx,0x8(%esp)
8010536e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105372:	c7 04 24 00 91 10 80 	movl   $0x80109100,(%esp)
80105379:	e8 22 b0 ff ff       	call   801003a0 <cprintf>
}

int jobs(int gid){
  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010537e:	81 45 f4 a0 00 00 00 	addl   $0xa0,-0xc(%ebp)
80105385:	81 7d f4 b4 61 11 80 	cmpl   $0x801161b4,-0xc(%ebp)
8010538c:	72 8e                	jb     8010531c <jobs+0x1b>
	if (p->gid==gid && p->pid > 2 && !(p->name[0] == 's' && p->name[1] == 'h' && strlen(p->name) == 2)) {
		cprintf("%d: %s\n",p->pid,p->name);
	}
  }    
  release(&ptable.lock);
8010538e:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
80105395:	e8 bb 01 00 00       	call   80105555 <release>
  return 0;
8010539a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010539f:	c9                   	leave  
801053a0:	c3                   	ret    

801053a1 <gidpid>:

int gidpid(int gid,int min) {
801053a1:	55                   	push   %ebp
801053a2:	89 e5                	mov    %esp,%ebp
801053a4:	83 ec 28             	sub    $0x28,%esp
  int pid=-1;
801053a7:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  struct proc* p;
  acquire(&ptable.lock);
801053ae:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
801053b5:	e8 34 01 00 00       	call   801054ee <acquire>
//debug:	cprintf("in proc.c: requested gid: %d with min: %d\n",gid,min);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053ba:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
801053c1:	eb 3a                	jmp    801053fd <gidpid+0x5c>
	if (p->gid==gid && p->pid > min && (pid > p->pid || pid==-1)) {
801053c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053c6:	8b 80 9c 00 00 00    	mov    0x9c(%eax),%eax
801053cc:	3b 45 08             	cmp    0x8(%ebp),%eax
801053cf:	75 25                	jne    801053f6 <gidpid+0x55>
801053d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053d4:	8b 40 10             	mov    0x10(%eax),%eax
801053d7:	3b 45 0c             	cmp    0xc(%ebp),%eax
801053da:	7e 1a                	jle    801053f6 <gidpid+0x55>
801053dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053df:	8b 40 10             	mov    0x10(%eax),%eax
801053e2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801053e5:	7c 06                	jl     801053ed <gidpid+0x4c>
801053e7:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
801053eb:	75 09                	jne    801053f6 <gidpid+0x55>
		pid = p->pid;
801053ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053f0:	8b 40 10             	mov    0x10(%eax),%eax
801053f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
int gidpid(int gid,int min) {
  int pid=-1;
  struct proc* p;
  acquire(&ptable.lock);
//debug:	cprintf("in proc.c: requested gid: %d with min: %d\n",gid,min);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801053f6:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
801053fd:	81 7d f0 b4 61 11 80 	cmpl   $0x801161b4,-0x10(%ebp)
80105404:	72 bd                	jb     801053c3 <gidpid+0x22>
	if (p->gid==gid && p->pid > min && (pid > p->pid || pid==-1)) {
		pid = p->pid;
	}
  }    
  release(&ptable.lock);
80105406:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010540d:	e8 43 01 00 00       	call   80105555 <release>
  return pid;
80105412:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105415:	c9                   	leave  
80105416:	c3                   	ret    

80105417 <isShell>:

int isShell(int pid) {
80105417:	55                   	push   %ebp
80105418:	89 e5                	mov    %esp,%ebp
8010541a:	83 ec 28             	sub    $0x28,%esp
  int ans=0;
8010541d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  struct proc* p;
  acquire(&ptable.lock);
80105424:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010542b:	e8 be 00 00 00       	call   801054ee <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105430:	c7 45 f0 b4 39 11 80 	movl   $0x801139b4,-0x10(%ebp)
80105437:	eb 44                	jmp    8010547d <isShell+0x66>
	if (p->pid==pid) {
80105439:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010543c:	8b 40 10             	mov    0x10(%eax),%eax
8010543f:	3b 45 08             	cmp    0x8(%ebp),%eax
80105442:	75 32                	jne    80105476 <isShell+0x5f>
		if (p->name[0] == 's' && p->name[1] == 'h' && strlen(p->name) == 2) {
80105444:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105447:	0f b6 40 6c          	movzbl 0x6c(%eax),%eax
8010544b:	3c 73                	cmp    $0x73,%al
8010544d:	75 27                	jne    80105476 <isShell+0x5f>
8010544f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105452:	0f b6 40 6d          	movzbl 0x6d(%eax),%eax
80105456:	3c 68                	cmp    $0x68,%al
80105458:	75 1c                	jne    80105476 <isShell+0x5f>
8010545a:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010545d:	83 c0 6c             	add    $0x6c,%eax
80105460:	89 04 24             	mov    %eax,(%esp)
80105463:	e8 49 05 00 00       	call   801059b1 <strlen>
80105468:	83 f8 02             	cmp    $0x2,%eax
8010546b:	75 09                	jne    80105476 <isShell+0x5f>
			ans=1;
8010546d:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
			break;
80105474:	eb 10                	jmp    80105486 <isShell+0x6f>

int isShell(int pid) {
  int ans=0;
  struct proc* p;
  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80105476:	81 45 f0 a0 00 00 00 	addl   $0xa0,-0x10(%ebp)
8010547d:	81 7d f0 b4 61 11 80 	cmpl   $0x801161b4,-0x10(%ebp)
80105484:	72 b3                	jb     80105439 <isShell+0x22>
			ans=1;
			break;
		}
	}
  }    
  release(&ptable.lock);
80105486:	c7 04 24 80 39 11 80 	movl   $0x80113980,(%esp)
8010548d:	e8 c3 00 00 00       	call   80105555 <release>
  return ans;
80105492:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105495:	c9                   	leave  
80105496:	c3                   	ret    

80105497 <readeflags>:
  asm volatile("ltr %0" : : "r" (sel));
}

static inline uint
readeflags(void)
{
80105497:	55                   	push   %ebp
80105498:	89 e5                	mov    %esp,%ebp
8010549a:	83 ec 10             	sub    $0x10,%esp
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
8010549d:	9c                   	pushf  
8010549e:	58                   	pop    %eax
8010549f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return eflags;
801054a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054a5:	c9                   	leave  
801054a6:	c3                   	ret    

801054a7 <cli>:
  asm volatile("movw %0, %%gs" : : "r" (v));
}

static inline void
cli(void)
{
801054a7:	55                   	push   %ebp
801054a8:	89 e5                	mov    %esp,%ebp
  asm volatile("cli");
801054aa:	fa                   	cli    
}
801054ab:	5d                   	pop    %ebp
801054ac:	c3                   	ret    

801054ad <sti>:

static inline void
sti(void)
{
801054ad:	55                   	push   %ebp
801054ae:	89 e5                	mov    %esp,%ebp
  asm volatile("sti");
801054b0:	fb                   	sti    
}
801054b1:	5d                   	pop    %ebp
801054b2:	c3                   	ret    

801054b3 <xchg>:

static inline uint
xchg(volatile uint *addr, uint newval)
{
801054b3:	55                   	push   %ebp
801054b4:	89 e5                	mov    %esp,%ebp
801054b6:	83 ec 10             	sub    $0x10,%esp
  uint result;
  
  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801054b9:	8b 55 08             	mov    0x8(%ebp),%edx
801054bc:	8b 45 0c             	mov    0xc(%ebp),%eax
801054bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
801054c2:	f0 87 02             	lock xchg %eax,(%edx)
801054c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
               "+m" (*addr), "=a" (result) :
               "1" (newval) :
               "cc");
  return result;
801054c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801054cb:	c9                   	leave  
801054cc:	c3                   	ret    

801054cd <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801054cd:	55                   	push   %ebp
801054ce:	89 e5                	mov    %esp,%ebp
  lk->name = name;
801054d0:	8b 45 08             	mov    0x8(%ebp),%eax
801054d3:	8b 55 0c             	mov    0xc(%ebp),%edx
801054d6:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
801054d9:	8b 45 08             	mov    0x8(%ebp),%eax
801054dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
801054e2:	8b 45 08             	mov    0x8(%ebp),%eax
801054e5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801054ec:	5d                   	pop    %ebp
801054ed:	c3                   	ret    

801054ee <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
801054ee:	55                   	push   %ebp
801054ef:	89 e5                	mov    %esp,%ebp
801054f1:	83 ec 18             	sub    $0x18,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801054f4:	e8 4e 01 00 00       	call   80105647 <pushcli>
  if(holding(lk)){
801054f9:	8b 45 08             	mov    0x8(%ebp),%eax
801054fc:	89 04 24             	mov    %eax,(%esp)
801054ff:	e8 19 01 00 00       	call   8010561d <holding>
80105504:	85 c0                	test   %eax,%eax
80105506:	74 11                	je     80105519 <acquire+0x2b>
    // panic("acquire");
    panic(proc->name);
80105508:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010550e:	83 c0 6c             	add    $0x6c,%eax
80105511:	89 04 24             	mov    %eax,(%esp)
80105514:	e8 21 b0 ff ff       	call   8010053a <panic>
    

  // The xchg is atomic.
  // It also serializes, so that reads after acquire are not
  // reordered before it. 
  while(xchg(&lk->locked, 1) != 0)
80105519:	90                   	nop
8010551a:	8b 45 08             	mov    0x8(%ebp),%eax
8010551d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80105524:	00 
80105525:	89 04 24             	mov    %eax,(%esp)
80105528:	e8 86 ff ff ff       	call   801054b3 <xchg>
8010552d:	85 c0                	test   %eax,%eax
8010552f:	75 e9                	jne    8010551a <acquire+0x2c>
    ;

  // Record info about lock acquisition for debugging.
  lk->cpu = cpu;
80105531:	8b 45 08             	mov    0x8(%ebp),%eax
80105534:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
8010553b:	89 50 08             	mov    %edx,0x8(%eax)
  getcallerpcs(&lk, lk->pcs);
8010553e:	8b 45 08             	mov    0x8(%ebp),%eax
80105541:	83 c0 0c             	add    $0xc,%eax
80105544:	89 44 24 04          	mov    %eax,0x4(%esp)
80105548:	8d 45 08             	lea    0x8(%ebp),%eax
8010554b:	89 04 24             	mov    %eax,(%esp)
8010554e:	e8 51 00 00 00       	call   801055a4 <getcallerpcs>
}
80105553:	c9                   	leave  
80105554:	c3                   	ret    

80105555 <release>:

// Release the lock.
void
release(struct spinlock *lk)
{
80105555:	55                   	push   %ebp
80105556:	89 e5                	mov    %esp,%ebp
80105558:	83 ec 18             	sub    $0x18,%esp
  if(!holding(lk))
8010555b:	8b 45 08             	mov    0x8(%ebp),%eax
8010555e:	89 04 24             	mov    %eax,(%esp)
80105561:	e8 b7 00 00 00       	call   8010561d <holding>
80105566:	85 c0                	test   %eax,%eax
80105568:	75 0c                	jne    80105576 <release+0x21>
    panic("release");
8010556a:	c7 04 24 32 91 10 80 	movl   $0x80109132,(%esp)
80105571:	e8 c4 af ff ff       	call   8010053a <panic>

  lk->pcs[0] = 0;
80105576:	8b 45 08             	mov    0x8(%ebp),%eax
80105579:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
  lk->cpu = 0;
80105580:	8b 45 08             	mov    0x8(%ebp),%eax
80105583:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  // But the 2007 Intel 64 Architecture Memory Ordering White
  // Paper says that Intel 64 and IA-32 will not move a load
  // after a store. So lock->locked = 0 would work here.
  // The xchg being asm volatile ensures gcc emits it after
  // the above assignments (and after the critical section).
  xchg(&lk->locked, 0);
8010558a:	8b 45 08             	mov    0x8(%ebp),%eax
8010558d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105594:	00 
80105595:	89 04 24             	mov    %eax,(%esp)
80105598:	e8 16 ff ff ff       	call   801054b3 <xchg>

  popcli();
8010559d:	e8 e9 00 00 00       	call   8010568b <popcli>
}
801055a2:	c9                   	leave  
801055a3:	c3                   	ret    

801055a4 <getcallerpcs>:

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801055a4:	55                   	push   %ebp
801055a5:	89 e5                	mov    %esp,%ebp
801055a7:	83 ec 10             	sub    $0x10,%esp
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
801055aa:	8b 45 08             	mov    0x8(%ebp),%eax
801055ad:	83 e8 08             	sub    $0x8,%eax
801055b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
  for(i = 0; i < 10; i++){
801055b3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
801055ba:	eb 38                	jmp    801055f4 <getcallerpcs+0x50>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801055bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
801055c0:	74 38                	je     801055fa <getcallerpcs+0x56>
801055c2:	81 7d fc ff ff ff 7f 	cmpl   $0x7fffffff,-0x4(%ebp)
801055c9:	76 2f                	jbe    801055fa <getcallerpcs+0x56>
801055cb:	83 7d fc ff          	cmpl   $0xffffffff,-0x4(%ebp)
801055cf:	74 29                	je     801055fa <getcallerpcs+0x56>
      break;
    pcs[i] = ebp[1];     // saved %eip
801055d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055d4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801055db:	8b 45 0c             	mov    0xc(%ebp),%eax
801055de:	01 c2                	add    %eax,%edx
801055e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055e3:	8b 40 04             	mov    0x4(%eax),%eax
801055e6:	89 02                	mov    %eax,(%edx)
    ebp = (uint*)ebp[0]; // saved %ebp
801055e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
801055eb:	8b 00                	mov    (%eax),%eax
801055ed:	89 45 fc             	mov    %eax,-0x4(%ebp)
{
  uint *ebp;
  int i;
  
  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801055f0:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
801055f4:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
801055f8:	7e c2                	jle    801055bc <getcallerpcs+0x18>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801055fa:	eb 19                	jmp    80105615 <getcallerpcs+0x71>
    pcs[i] = 0;
801055fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
801055ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80105606:	8b 45 0c             	mov    0xc(%ebp),%eax
80105609:	01 d0                	add    %edx,%eax
8010560b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
80105611:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
80105615:	83 7d f8 09          	cmpl   $0x9,-0x8(%ebp)
80105619:	7e e1                	jle    801055fc <getcallerpcs+0x58>
    pcs[i] = 0;
}
8010561b:	c9                   	leave  
8010561c:	c3                   	ret    

8010561d <holding>:

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
8010561d:	55                   	push   %ebp
8010561e:	89 e5                	mov    %esp,%ebp
  return lock->locked && lock->cpu == cpu;
80105620:	8b 45 08             	mov    0x8(%ebp),%eax
80105623:	8b 00                	mov    (%eax),%eax
80105625:	85 c0                	test   %eax,%eax
80105627:	74 17                	je     80105640 <holding+0x23>
80105629:	8b 45 08             	mov    0x8(%ebp),%eax
8010562c:	8b 50 08             	mov    0x8(%eax),%edx
8010562f:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80105635:	39 c2                	cmp    %eax,%edx
80105637:	75 07                	jne    80105640 <holding+0x23>
80105639:	b8 01 00 00 00       	mov    $0x1,%eax
8010563e:	eb 05                	jmp    80105645 <holding+0x28>
80105640:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105645:	5d                   	pop    %ebp
80105646:	c3                   	ret    

80105647 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80105647:	55                   	push   %ebp
80105648:	89 e5                	mov    %esp,%ebp
8010564a:	83 ec 10             	sub    $0x10,%esp
  int eflags;
  
  eflags = readeflags();
8010564d:	e8 45 fe ff ff       	call   80105497 <readeflags>
80105652:	89 45 fc             	mov    %eax,-0x4(%ebp)
  cli();
80105655:	e8 4d fe ff ff       	call   801054a7 <cli>
  if(cpu->ncli++ == 0)
8010565a:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80105661:	8b 82 ac 00 00 00    	mov    0xac(%edx),%eax
80105667:	8d 48 01             	lea    0x1(%eax),%ecx
8010566a:	89 8a ac 00 00 00    	mov    %ecx,0xac(%edx)
80105670:	85 c0                	test   %eax,%eax
80105672:	75 15                	jne    80105689 <pushcli+0x42>
    cpu->intena = eflags & FL_IF;
80105674:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010567a:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010567d:	81 e2 00 02 00 00    	and    $0x200,%edx
80105683:	89 90 b0 00 00 00    	mov    %edx,0xb0(%eax)
}
80105689:	c9                   	leave  
8010568a:	c3                   	ret    

8010568b <popcli>:

void
popcli(void)
{
8010568b:	55                   	push   %ebp
8010568c:	89 e5                	mov    %esp,%ebp
8010568e:	83 ec 18             	sub    $0x18,%esp
  if(readeflags()&FL_IF)
80105691:	e8 01 fe ff ff       	call   80105497 <readeflags>
80105696:	25 00 02 00 00       	and    $0x200,%eax
8010569b:	85 c0                	test   %eax,%eax
8010569d:	74 0c                	je     801056ab <popcli+0x20>
    panic("popcli - interruptible");
8010569f:	c7 04 24 3a 91 10 80 	movl   $0x8010913a,(%esp)
801056a6:	e8 8f ae ff ff       	call   8010053a <panic>
  if(--cpu->ncli < 0)
801056ab:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056b1:	8b 90 ac 00 00 00    	mov    0xac(%eax),%edx
801056b7:	83 ea 01             	sub    $0x1,%edx
801056ba:	89 90 ac 00 00 00    	mov    %edx,0xac(%eax)
801056c0:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801056c6:	85 c0                	test   %eax,%eax
801056c8:	79 0c                	jns    801056d6 <popcli+0x4b>
    panic("popcli");
801056ca:	c7 04 24 51 91 10 80 	movl   $0x80109151,(%esp)
801056d1:	e8 64 ae ff ff       	call   8010053a <panic>
  if(cpu->ncli == 0 && cpu->intena)
801056d6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056dc:	8b 80 ac 00 00 00    	mov    0xac(%eax),%eax
801056e2:	85 c0                	test   %eax,%eax
801056e4:	75 15                	jne    801056fb <popcli+0x70>
801056e6:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801056ec:	8b 80 b0 00 00 00    	mov    0xb0(%eax),%eax
801056f2:	85 c0                	test   %eax,%eax
801056f4:	74 05                	je     801056fb <popcli+0x70>
    sti();
801056f6:	e8 b2 fd ff ff       	call   801054ad <sti>
}
801056fb:	c9                   	leave  
801056fc:	c3                   	ret    

801056fd <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
801056fd:	55                   	push   %ebp
801056fe:	89 e5                	mov    %esp,%ebp
80105700:	57                   	push   %edi
80105701:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
80105702:	8b 4d 08             	mov    0x8(%ebp),%ecx
80105705:	8b 55 10             	mov    0x10(%ebp),%edx
80105708:	8b 45 0c             	mov    0xc(%ebp),%eax
8010570b:	89 cb                	mov    %ecx,%ebx
8010570d:	89 df                	mov    %ebx,%edi
8010570f:	89 d1                	mov    %edx,%ecx
80105711:	fc                   	cld    
80105712:	f3 aa                	rep stos %al,%es:(%edi)
80105714:	89 ca                	mov    %ecx,%edx
80105716:	89 fb                	mov    %edi,%ebx
80105718:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010571b:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
8010571e:	5b                   	pop    %ebx
8010571f:	5f                   	pop    %edi
80105720:	5d                   	pop    %ebp
80105721:	c3                   	ret    

80105722 <stosl>:

static inline void
stosl(void *addr, int data, int cnt)
{
80105722:	55                   	push   %ebp
80105723:	89 e5                	mov    %esp,%ebp
80105725:	57                   	push   %edi
80105726:	53                   	push   %ebx
  asm volatile("cld; rep stosl" :
80105727:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010572a:	8b 55 10             	mov    0x10(%ebp),%edx
8010572d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105730:	89 cb                	mov    %ecx,%ebx
80105732:	89 df                	mov    %ebx,%edi
80105734:	89 d1                	mov    %edx,%ecx
80105736:	fc                   	cld    
80105737:	f3 ab                	rep stos %eax,%es:(%edi)
80105739:	89 ca                	mov    %ecx,%edx
8010573b:	89 fb                	mov    %edi,%ebx
8010573d:	89 5d 08             	mov    %ebx,0x8(%ebp)
80105740:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
80105743:	5b                   	pop    %ebx
80105744:	5f                   	pop    %edi
80105745:	5d                   	pop    %ebp
80105746:	c3                   	ret    

80105747 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80105747:	55                   	push   %ebp
80105748:	89 e5                	mov    %esp,%ebp
8010574a:	83 ec 0c             	sub    $0xc,%esp
  if ((int)dst%4 == 0 && n%4 == 0){
8010574d:	8b 45 08             	mov    0x8(%ebp),%eax
80105750:	83 e0 03             	and    $0x3,%eax
80105753:	85 c0                	test   %eax,%eax
80105755:	75 49                	jne    801057a0 <memset+0x59>
80105757:	8b 45 10             	mov    0x10(%ebp),%eax
8010575a:	83 e0 03             	and    $0x3,%eax
8010575d:	85 c0                	test   %eax,%eax
8010575f:	75 3f                	jne    801057a0 <memset+0x59>
    c &= 0xFF;
80105761:	81 65 0c ff 00 00 00 	andl   $0xff,0xc(%ebp)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80105768:	8b 45 10             	mov    0x10(%ebp),%eax
8010576b:	c1 e8 02             	shr    $0x2,%eax
8010576e:	89 c2                	mov    %eax,%edx
80105770:	8b 45 0c             	mov    0xc(%ebp),%eax
80105773:	c1 e0 18             	shl    $0x18,%eax
80105776:	89 c1                	mov    %eax,%ecx
80105778:	8b 45 0c             	mov    0xc(%ebp),%eax
8010577b:	c1 e0 10             	shl    $0x10,%eax
8010577e:	09 c1                	or     %eax,%ecx
80105780:	8b 45 0c             	mov    0xc(%ebp),%eax
80105783:	c1 e0 08             	shl    $0x8,%eax
80105786:	09 c8                	or     %ecx,%eax
80105788:	0b 45 0c             	or     0xc(%ebp),%eax
8010578b:	89 54 24 08          	mov    %edx,0x8(%esp)
8010578f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105793:	8b 45 08             	mov    0x8(%ebp),%eax
80105796:	89 04 24             	mov    %eax,(%esp)
80105799:	e8 84 ff ff ff       	call   80105722 <stosl>
8010579e:	eb 19                	jmp    801057b9 <memset+0x72>
  } else
    stosb(dst, c, n);
801057a0:	8b 45 10             	mov    0x10(%ebp),%eax
801057a3:	89 44 24 08          	mov    %eax,0x8(%esp)
801057a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801057aa:	89 44 24 04          	mov    %eax,0x4(%esp)
801057ae:	8b 45 08             	mov    0x8(%ebp),%eax
801057b1:	89 04 24             	mov    %eax,(%esp)
801057b4:	e8 44 ff ff ff       	call   801056fd <stosb>
  return dst;
801057b9:	8b 45 08             	mov    0x8(%ebp),%eax
}
801057bc:	c9                   	leave  
801057bd:	c3                   	ret    

801057be <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801057be:	55                   	push   %ebp
801057bf:	89 e5                	mov    %esp,%ebp
801057c1:	83 ec 10             	sub    $0x10,%esp
  const uchar *s1, *s2;
  
  s1 = v1;
801057c4:	8b 45 08             	mov    0x8(%ebp),%eax
801057c7:	89 45 fc             	mov    %eax,-0x4(%ebp)
  s2 = v2;
801057ca:	8b 45 0c             	mov    0xc(%ebp),%eax
801057cd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0){
801057d0:	eb 30                	jmp    80105802 <memcmp+0x44>
    if(*s1 != *s2)
801057d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057d5:	0f b6 10             	movzbl (%eax),%edx
801057d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057db:	0f b6 00             	movzbl (%eax),%eax
801057de:	38 c2                	cmp    %al,%dl
801057e0:	74 18                	je     801057fa <memcmp+0x3c>
      return *s1 - *s2;
801057e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
801057e5:	0f b6 00             	movzbl (%eax),%eax
801057e8:	0f b6 d0             	movzbl %al,%edx
801057eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
801057ee:	0f b6 00             	movzbl (%eax),%eax
801057f1:	0f b6 c0             	movzbl %al,%eax
801057f4:	29 c2                	sub    %eax,%edx
801057f6:	89 d0                	mov    %edx,%eax
801057f8:	eb 1a                	jmp    80105814 <memcmp+0x56>
    s1++, s2++;
801057fa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801057fe:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
{
  const uchar *s1, *s2;
  
  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80105802:	8b 45 10             	mov    0x10(%ebp),%eax
80105805:	8d 50 ff             	lea    -0x1(%eax),%edx
80105808:	89 55 10             	mov    %edx,0x10(%ebp)
8010580b:	85 c0                	test   %eax,%eax
8010580d:	75 c3                	jne    801057d2 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010580f:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105814:	c9                   	leave  
80105815:	c3                   	ret    

80105816 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80105816:	55                   	push   %ebp
80105817:	89 e5                	mov    %esp,%ebp
80105819:	83 ec 10             	sub    $0x10,%esp
  const char *s;
  char *d;

  s = src;
8010581c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010581f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  d = dst;
80105822:	8b 45 08             	mov    0x8(%ebp),%eax
80105825:	89 45 f8             	mov    %eax,-0x8(%ebp)
  if(s < d && s + n > d){
80105828:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010582b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010582e:	73 3d                	jae    8010586d <memmove+0x57>
80105830:	8b 45 10             	mov    0x10(%ebp),%eax
80105833:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105836:	01 d0                	add    %edx,%eax
80105838:	3b 45 f8             	cmp    -0x8(%ebp),%eax
8010583b:	76 30                	jbe    8010586d <memmove+0x57>
    s += n;
8010583d:	8b 45 10             	mov    0x10(%ebp),%eax
80105840:	01 45 fc             	add    %eax,-0x4(%ebp)
    d += n;
80105843:	8b 45 10             	mov    0x10(%ebp),%eax
80105846:	01 45 f8             	add    %eax,-0x8(%ebp)
    while(n-- > 0)
80105849:	eb 13                	jmp    8010585e <memmove+0x48>
      *--d = *--s;
8010584b:	83 6d f8 01          	subl   $0x1,-0x8(%ebp)
8010584f:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
80105853:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105856:	0f b6 10             	movzbl (%eax),%edx
80105859:	8b 45 f8             	mov    -0x8(%ebp),%eax
8010585c:	88 10                	mov    %dl,(%eax)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010585e:	8b 45 10             	mov    0x10(%ebp),%eax
80105861:	8d 50 ff             	lea    -0x1(%eax),%edx
80105864:	89 55 10             	mov    %edx,0x10(%ebp)
80105867:	85 c0                	test   %eax,%eax
80105869:	75 e0                	jne    8010584b <memmove+0x35>
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010586b:	eb 26                	jmp    80105893 <memmove+0x7d>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010586d:	eb 17                	jmp    80105886 <memmove+0x70>
      *d++ = *s++;
8010586f:	8b 45 f8             	mov    -0x8(%ebp),%eax
80105872:	8d 50 01             	lea    0x1(%eax),%edx
80105875:	89 55 f8             	mov    %edx,-0x8(%ebp)
80105878:	8b 55 fc             	mov    -0x4(%ebp),%edx
8010587b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010587e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
80105881:	0f b6 12             	movzbl (%edx),%edx
80105884:	88 10                	mov    %dl,(%eax)
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80105886:	8b 45 10             	mov    0x10(%ebp),%eax
80105889:	8d 50 ff             	lea    -0x1(%eax),%edx
8010588c:	89 55 10             	mov    %edx,0x10(%ebp)
8010588f:	85 c0                	test   %eax,%eax
80105891:	75 dc                	jne    8010586f <memmove+0x59>
      *d++ = *s++;

  return dst;
80105893:	8b 45 08             	mov    0x8(%ebp),%eax
}
80105896:	c9                   	leave  
80105897:	c3                   	ret    

80105898 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80105898:	55                   	push   %ebp
80105899:	89 e5                	mov    %esp,%ebp
8010589b:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
8010589e:	8b 45 10             	mov    0x10(%ebp),%eax
801058a1:	89 44 24 08          	mov    %eax,0x8(%esp)
801058a5:	8b 45 0c             	mov    0xc(%ebp),%eax
801058a8:	89 44 24 04          	mov    %eax,0x4(%esp)
801058ac:	8b 45 08             	mov    0x8(%ebp),%eax
801058af:	89 04 24             	mov    %eax,(%esp)
801058b2:	e8 5f ff ff ff       	call   80105816 <memmove>
}
801058b7:	c9                   	leave  
801058b8:	c3                   	ret    

801058b9 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
801058b9:	55                   	push   %ebp
801058ba:	89 e5                	mov    %esp,%ebp
  while(n > 0 && *p && *p == *q)
801058bc:	eb 0c                	jmp    801058ca <strncmp+0x11>
    n--, p++, q++;
801058be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
801058c2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
801058c6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801058ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058ce:	74 1a                	je     801058ea <strncmp+0x31>
801058d0:	8b 45 08             	mov    0x8(%ebp),%eax
801058d3:	0f b6 00             	movzbl (%eax),%eax
801058d6:	84 c0                	test   %al,%al
801058d8:	74 10                	je     801058ea <strncmp+0x31>
801058da:	8b 45 08             	mov    0x8(%ebp),%eax
801058dd:	0f b6 10             	movzbl (%eax),%edx
801058e0:	8b 45 0c             	mov    0xc(%ebp),%eax
801058e3:	0f b6 00             	movzbl (%eax),%eax
801058e6:	38 c2                	cmp    %al,%dl
801058e8:	74 d4                	je     801058be <strncmp+0x5>
    n--, p++, q++;
  if(n == 0)
801058ea:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801058ee:	75 07                	jne    801058f7 <strncmp+0x3e>
    return 0;
801058f0:	b8 00 00 00 00       	mov    $0x0,%eax
801058f5:	eb 16                	jmp    8010590d <strncmp+0x54>
  return (uchar)*p - (uchar)*q;
801058f7:	8b 45 08             	mov    0x8(%ebp),%eax
801058fa:	0f b6 00             	movzbl (%eax),%eax
801058fd:	0f b6 d0             	movzbl %al,%edx
80105900:	8b 45 0c             	mov    0xc(%ebp),%eax
80105903:	0f b6 00             	movzbl (%eax),%eax
80105906:	0f b6 c0             	movzbl %al,%eax
80105909:	29 c2                	sub    %eax,%edx
8010590b:	89 d0                	mov    %edx,%eax
}
8010590d:	5d                   	pop    %ebp
8010590e:	c3                   	ret    

8010590f <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
8010590f:	55                   	push   %ebp
80105910:	89 e5                	mov    %esp,%ebp
80105912:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
80105915:	8b 45 08             	mov    0x8(%ebp),%eax
80105918:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while(n-- > 0 && (*s++ = *t++) != 0)
8010591b:	90                   	nop
8010591c:	8b 45 10             	mov    0x10(%ebp),%eax
8010591f:	8d 50 ff             	lea    -0x1(%eax),%edx
80105922:	89 55 10             	mov    %edx,0x10(%ebp)
80105925:	85 c0                	test   %eax,%eax
80105927:	7e 1e                	jle    80105947 <strncpy+0x38>
80105929:	8b 45 08             	mov    0x8(%ebp),%eax
8010592c:	8d 50 01             	lea    0x1(%eax),%edx
8010592f:	89 55 08             	mov    %edx,0x8(%ebp)
80105932:	8b 55 0c             	mov    0xc(%ebp),%edx
80105935:	8d 4a 01             	lea    0x1(%edx),%ecx
80105938:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010593b:	0f b6 12             	movzbl (%edx),%edx
8010593e:	88 10                	mov    %dl,(%eax)
80105940:	0f b6 00             	movzbl (%eax),%eax
80105943:	84 c0                	test   %al,%al
80105945:	75 d5                	jne    8010591c <strncpy+0xd>
    ;
  while(n-- > 0)
80105947:	eb 0c                	jmp    80105955 <strncpy+0x46>
    *s++ = 0;
80105949:	8b 45 08             	mov    0x8(%ebp),%eax
8010594c:	8d 50 01             	lea    0x1(%eax),%edx
8010594f:	89 55 08             	mov    %edx,0x8(%ebp)
80105952:	c6 00 00             	movb   $0x0,(%eax)
  char *os;
  
  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
80105955:	8b 45 10             	mov    0x10(%ebp),%eax
80105958:	8d 50 ff             	lea    -0x1(%eax),%edx
8010595b:	89 55 10             	mov    %edx,0x10(%ebp)
8010595e:	85 c0                	test   %eax,%eax
80105960:	7f e7                	jg     80105949 <strncpy+0x3a>
    *s++ = 0;
  return os;
80105962:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80105965:	c9                   	leave  
80105966:	c3                   	ret    

80105967 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80105967:	55                   	push   %ebp
80105968:	89 e5                	mov    %esp,%ebp
8010596a:	83 ec 10             	sub    $0x10,%esp
  char *os;
  
  os = s;
8010596d:	8b 45 08             	mov    0x8(%ebp),%eax
80105970:	89 45 fc             	mov    %eax,-0x4(%ebp)
  if(n <= 0)
80105973:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105977:	7f 05                	jg     8010597e <safestrcpy+0x17>
    return os;
80105979:	8b 45 fc             	mov    -0x4(%ebp),%eax
8010597c:	eb 31                	jmp    801059af <safestrcpy+0x48>
  while(--n > 0 && (*s++ = *t++) != 0)
8010597e:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
80105982:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105986:	7e 1e                	jle    801059a6 <safestrcpy+0x3f>
80105988:	8b 45 08             	mov    0x8(%ebp),%eax
8010598b:	8d 50 01             	lea    0x1(%eax),%edx
8010598e:	89 55 08             	mov    %edx,0x8(%ebp)
80105991:	8b 55 0c             	mov    0xc(%ebp),%edx
80105994:	8d 4a 01             	lea    0x1(%edx),%ecx
80105997:	89 4d 0c             	mov    %ecx,0xc(%ebp)
8010599a:	0f b6 12             	movzbl (%edx),%edx
8010599d:	88 10                	mov    %dl,(%eax)
8010599f:	0f b6 00             	movzbl (%eax),%eax
801059a2:	84 c0                	test   %al,%al
801059a4:	75 d8                	jne    8010597e <safestrcpy+0x17>
    ;
  *s = 0;
801059a6:	8b 45 08             	mov    0x8(%ebp),%eax
801059a9:	c6 00 00             	movb   $0x0,(%eax)
  return os;
801059ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059af:	c9                   	leave  
801059b0:	c3                   	ret    

801059b1 <strlen>:

int
strlen(const char *s)
{
801059b1:	55                   	push   %ebp
801059b2:	89 e5                	mov    %esp,%ebp
801059b4:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
801059b7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
801059be:	eb 04                	jmp    801059c4 <strlen+0x13>
801059c0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
801059c4:	8b 55 fc             	mov    -0x4(%ebp),%edx
801059c7:	8b 45 08             	mov    0x8(%ebp),%eax
801059ca:	01 d0                	add    %edx,%eax
801059cc:	0f b6 00             	movzbl (%eax),%eax
801059cf:	84 c0                	test   %al,%al
801059d1:	75 ed                	jne    801059c0 <strlen+0xf>
    ;
  return n;
801059d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
801059d6:	c9                   	leave  
801059d7:	c3                   	ret    

801059d8 <swtch>:
# Save current register context in old
# and then load register context from new.

.globl swtch
swtch:
  movl 4(%esp), %eax
801059d8:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801059dc:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-save registers
  pushl %ebp
801059e0:	55                   	push   %ebp
  pushl %ebx
801059e1:	53                   	push   %ebx
  pushl %esi
801059e2:	56                   	push   %esi
  pushl %edi
801059e3:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801059e4:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801059e6:	89 d4                	mov    %edx,%esp

  # Load new callee-save registers
  popl %edi
801059e8:	5f                   	pop    %edi
  popl %esi
801059e9:	5e                   	pop    %esi
  popl %ebx
801059ea:	5b                   	pop    %ebx
  popl %ebp
801059eb:	5d                   	pop    %ebp
  ret
801059ec:	c3                   	ret    

801059ed <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801059ed:	55                   	push   %ebp
801059ee:	89 e5                	mov    %esp,%ebp
  if(addr >= proc->sz || addr+4 > proc->sz)
801059f0:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801059f6:	8b 00                	mov    (%eax),%eax
801059f8:	3b 45 08             	cmp    0x8(%ebp),%eax
801059fb:	76 12                	jbe    80105a0f <fetchint+0x22>
801059fd:	8b 45 08             	mov    0x8(%ebp),%eax
80105a00:	8d 50 04             	lea    0x4(%eax),%edx
80105a03:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a09:	8b 00                	mov    (%eax),%eax
80105a0b:	39 c2                	cmp    %eax,%edx
80105a0d:	76 07                	jbe    80105a16 <fetchint+0x29>
    return -1;
80105a0f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a14:	eb 0f                	jmp    80105a25 <fetchint+0x38>
  *ip = *(int*)(addr);
80105a16:	8b 45 08             	mov    0x8(%ebp),%eax
80105a19:	8b 10                	mov    (%eax),%edx
80105a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a1e:	89 10                	mov    %edx,(%eax)
  return 0;
80105a20:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105a25:	5d                   	pop    %ebp
80105a26:	c3                   	ret    

80105a27 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80105a27:	55                   	push   %ebp
80105a28:	89 e5                	mov    %esp,%ebp
80105a2a:	83 ec 10             	sub    $0x10,%esp
  char *s, *ep;

  if(addr >= proc->sz)
80105a2d:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a33:	8b 00                	mov    (%eax),%eax
80105a35:	3b 45 08             	cmp    0x8(%ebp),%eax
80105a38:	77 07                	ja     80105a41 <fetchstr+0x1a>
    return -1;
80105a3a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a3f:	eb 46                	jmp    80105a87 <fetchstr+0x60>
  *pp = (char*)addr;
80105a41:	8b 55 08             	mov    0x8(%ebp),%edx
80105a44:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a47:	89 10                	mov    %edx,(%eax)
  ep = (char*)proc->sz;
80105a49:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a4f:	8b 00                	mov    (%eax),%eax
80105a51:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(s = *pp; s < ep; s++)
80105a54:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a57:	8b 00                	mov    (%eax),%eax
80105a59:	89 45 fc             	mov    %eax,-0x4(%ebp)
80105a5c:	eb 1c                	jmp    80105a7a <fetchstr+0x53>
    if(*s == 0)
80105a5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a61:	0f b6 00             	movzbl (%eax),%eax
80105a64:	84 c0                	test   %al,%al
80105a66:	75 0e                	jne    80105a76 <fetchstr+0x4f>
      return s - *pp;
80105a68:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105a6b:	8b 45 0c             	mov    0xc(%ebp),%eax
80105a6e:	8b 00                	mov    (%eax),%eax
80105a70:	29 c2                	sub    %eax,%edx
80105a72:	89 d0                	mov    %edx,%eax
80105a74:	eb 11                	jmp    80105a87 <fetchstr+0x60>

  if(addr >= proc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)proc->sz;
  for(s = *pp; s < ep; s++)
80105a76:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105a7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105a7d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
80105a80:	72 dc                	jb     80105a5e <fetchstr+0x37>
    if(*s == 0)
      return s - *pp;
  return -1;
80105a82:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105a87:	c9                   	leave  
80105a88:	c3                   	ret    

80105a89 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80105a89:	55                   	push   %ebp
80105a8a:	89 e5                	mov    %esp,%ebp
80105a8c:	83 ec 08             	sub    $0x8,%esp
  return fetchint(proc->tf->esp + 4 + 4*n, ip);
80105a8f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105a95:	8b 40 18             	mov    0x18(%eax),%eax
80105a98:	8b 50 44             	mov    0x44(%eax),%edx
80105a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80105a9e:	c1 e0 02             	shl    $0x2,%eax
80105aa1:	01 d0                	add    %edx,%eax
80105aa3:	8d 50 04             	lea    0x4(%eax),%edx
80105aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
80105aa9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105aad:	89 14 24             	mov    %edx,(%esp)
80105ab0:	e8 38 ff ff ff       	call   801059ed <fetchint>
}
80105ab5:	c9                   	leave  
80105ab6:	c3                   	ret    

80105ab7 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size n bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80105ab7:	55                   	push   %ebp
80105ab8:	89 e5                	mov    %esp,%ebp
80105aba:	83 ec 18             	sub    $0x18,%esp
  int i;
  
  if(argint(n, &i) < 0)
80105abd:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105ac0:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ac4:	8b 45 08             	mov    0x8(%ebp),%eax
80105ac7:	89 04 24             	mov    %eax,(%esp)
80105aca:	e8 ba ff ff ff       	call   80105a89 <argint>
80105acf:	85 c0                	test   %eax,%eax
80105ad1:	79 07                	jns    80105ada <argptr+0x23>
    return -1;
80105ad3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ad8:	eb 3d                	jmp    80105b17 <argptr+0x60>
  if((uint)i >= proc->sz || (uint)i+size > proc->sz)
80105ada:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105add:	89 c2                	mov    %eax,%edx
80105adf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ae5:	8b 00                	mov    (%eax),%eax
80105ae7:	39 c2                	cmp    %eax,%edx
80105ae9:	73 16                	jae    80105b01 <argptr+0x4a>
80105aeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105aee:	89 c2                	mov    %eax,%edx
80105af0:	8b 45 10             	mov    0x10(%ebp),%eax
80105af3:	01 c2                	add    %eax,%edx
80105af5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105afb:	8b 00                	mov    (%eax),%eax
80105afd:	39 c2                	cmp    %eax,%edx
80105aff:	76 07                	jbe    80105b08 <argptr+0x51>
    return -1;
80105b01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b06:	eb 0f                	jmp    80105b17 <argptr+0x60>
  *pp = (char*)i;
80105b08:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b0b:	89 c2                	mov    %eax,%edx
80105b0d:	8b 45 0c             	mov    0xc(%ebp),%eax
80105b10:	89 10                	mov    %edx,(%eax)
  return 0;
80105b12:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105b17:	c9                   	leave  
80105b18:	c3                   	ret    

80105b19 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80105b19:	55                   	push   %ebp
80105b1a:	89 e5                	mov    %esp,%ebp
80105b1c:	83 ec 18             	sub    $0x18,%esp
  int addr;
  if(argint(n, &addr) < 0)
80105b1f:	8d 45 fc             	lea    -0x4(%ebp),%eax
80105b22:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b26:	8b 45 08             	mov    0x8(%ebp),%eax
80105b29:	89 04 24             	mov    %eax,(%esp)
80105b2c:	e8 58 ff ff ff       	call   80105a89 <argint>
80105b31:	85 c0                	test   %eax,%eax
80105b33:	79 07                	jns    80105b3c <argstr+0x23>
    return -1;
80105b35:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105b3a:	eb 12                	jmp    80105b4e <argstr+0x35>
  return fetchstr(addr, pp);
80105b3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
80105b42:	89 54 24 04          	mov    %edx,0x4(%esp)
80105b46:	89 04 24             	mov    %eax,(%esp)
80105b49:	e8 d9 fe ff ff       	call   80105a27 <fetchstr>
}
80105b4e:	c9                   	leave  
80105b4f:	c3                   	ret    

80105b50 <syscall>:
[SYS_isShell]   sys_isShell,
};

void
syscall(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
80105b53:	53                   	push   %ebx
80105b54:	83 ec 24             	sub    $0x24,%esp
  int num;

  num = proc->tf->eax;
80105b57:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b5d:	8b 40 18             	mov    0x18(%eax),%eax
80105b60:	8b 40 1c             	mov    0x1c(%eax),%eax
80105b63:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80105b66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105b6a:	7e 30                	jle    80105b9c <syscall+0x4c>
80105b6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b6f:	83 f8 1c             	cmp    $0x1c,%eax
80105b72:	77 28                	ja     80105b9c <syscall+0x4c>
80105b74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b77:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b7e:	85 c0                	test   %eax,%eax
80105b80:	74 1a                	je     80105b9c <syscall+0x4c>
    proc->tf->eax = syscalls[num]();
80105b82:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105b88:	8b 58 18             	mov    0x18(%eax),%ebx
80105b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105b8e:	8b 04 85 40 c0 10 80 	mov    -0x7fef3fc0(,%eax,4),%eax
80105b95:	ff d0                	call   *%eax
80105b97:	89 43 1c             	mov    %eax,0x1c(%ebx)
80105b9a:	eb 3d                	jmp    80105bd9 <syscall+0x89>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            proc->pid, proc->name, num);
80105b9c:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105ba2:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105ba5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax

  num = proc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    proc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80105bab:	8b 40 10             	mov    0x10(%eax),%eax
80105bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105bb1:	89 54 24 0c          	mov    %edx,0xc(%esp)
80105bb5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105bb9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bbd:	c7 04 24 58 91 10 80 	movl   $0x80109158,(%esp)
80105bc4:	e8 d7 a7 ff ff       	call   801003a0 <cprintf>
            proc->pid, proc->name, num);
    proc->tf->eax = -1;
80105bc9:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105bcf:	8b 40 18             	mov    0x18(%eax),%eax
80105bd2:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80105bd9:	83 c4 24             	add    $0x24,%esp
80105bdc:	5b                   	pop    %ebx
80105bdd:	5d                   	pop    %ebp
80105bde:	c3                   	ret    

80105bdf <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80105bdf:	55                   	push   %ebp
80105be0:	89 e5                	mov    %esp,%ebp
80105be2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80105be5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105be8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105bec:	8b 45 08             	mov    0x8(%ebp),%eax
80105bef:	89 04 24             	mov    %eax,(%esp)
80105bf2:	e8 92 fe ff ff       	call   80105a89 <argint>
80105bf7:	85 c0                	test   %eax,%eax
80105bf9:	79 07                	jns    80105c02 <argfd+0x23>
    return -1;
80105bfb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c00:	eb 50                	jmp    80105c52 <argfd+0x73>
  if(fd < 0 || fd >= NOFILE || (f=proc->ofile[fd]) == 0)
80105c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c05:	85 c0                	test   %eax,%eax
80105c07:	78 21                	js     80105c2a <argfd+0x4b>
80105c09:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105c0c:	83 f8 0f             	cmp    $0xf,%eax
80105c0f:	7f 19                	jg     80105c2a <argfd+0x4b>
80105c11:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c17:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c1a:	83 c2 08             	add    $0x8,%edx
80105c1d:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105c24:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105c28:	75 07                	jne    80105c31 <argfd+0x52>
    return -1;
80105c2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c2f:	eb 21                	jmp    80105c52 <argfd+0x73>
  if(pfd)
80105c31:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80105c35:	74 08                	je     80105c3f <argfd+0x60>
    *pfd = fd;
80105c37:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105c3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80105c3d:	89 10                	mov    %edx,(%eax)
  if(pf)
80105c3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80105c43:	74 08                	je     80105c4d <argfd+0x6e>
    *pf = f;
80105c45:	8b 45 10             	mov    0x10(%ebp),%eax
80105c48:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c4b:	89 10                	mov    %edx,(%eax)
  return 0;
80105c4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105c52:	c9                   	leave  
80105c53:	c3                   	ret    

80105c54 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80105c54:	55                   	push   %ebp
80105c55:	89 e5                	mov    %esp,%ebp
80105c57:	83 ec 10             	sub    $0x10,%esp
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
80105c61:	eb 30                	jmp    80105c93 <fdalloc+0x3f>
    if(proc->ofile[fd] == 0){
80105c63:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c69:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c6c:	83 c2 08             	add    $0x8,%edx
80105c6f:	8b 44 90 08          	mov    0x8(%eax,%edx,4),%eax
80105c73:	85 c0                	test   %eax,%eax
80105c75:	75 18                	jne    80105c8f <fdalloc+0x3b>
      proc->ofile[fd] = f;
80105c77:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105c7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
80105c80:	8d 4a 08             	lea    0x8(%edx),%ecx
80105c83:	8b 55 08             	mov    0x8(%ebp),%edx
80105c86:	89 54 88 08          	mov    %edx,0x8(%eax,%ecx,4)
      return fd;
80105c8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
80105c8d:	eb 0f                	jmp    80105c9e <fdalloc+0x4a>
static int
fdalloc(struct file *f)
{
  int fd;

  for(fd = 0; fd < NOFILE; fd++){
80105c8f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
80105c93:	83 7d fc 0f          	cmpl   $0xf,-0x4(%ebp)
80105c97:	7e ca                	jle    80105c63 <fdalloc+0xf>
    if(proc->ofile[fd] == 0){
      proc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80105c99:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c9e:	c9                   	leave  
80105c9f:	c3                   	ret    

80105ca0 <sys_dup>:

int
sys_dup(void)
{
80105ca0:	55                   	push   %ebp
80105ca1:	89 e5                	mov    %esp,%ebp
80105ca3:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int fd;
  
  if(argfd(0, 0, &f) < 0)
80105ca6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ca9:	89 44 24 08          	mov    %eax,0x8(%esp)
80105cad:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105cb4:	00 
80105cb5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105cbc:	e8 1e ff ff ff       	call   80105bdf <argfd>
80105cc1:	85 c0                	test   %eax,%eax
80105cc3:	79 07                	jns    80105ccc <sys_dup+0x2c>
    return -1;
80105cc5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105cca:	eb 29                	jmp    80105cf5 <sys_dup+0x55>
  if((fd=fdalloc(f)) < 0)
80105ccc:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105ccf:	89 04 24             	mov    %eax,(%esp)
80105cd2:	e8 7d ff ff ff       	call   80105c54 <fdalloc>
80105cd7:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105cda:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105cde:	79 07                	jns    80105ce7 <sys_dup+0x47>
    return -1;
80105ce0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ce5:	eb 0e                	jmp    80105cf5 <sys_dup+0x55>
  filedup(f);
80105ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105cea:	89 04 24             	mov    %eax,(%esp)
80105ced:	e8 ce b2 ff ff       	call   80100fc0 <filedup>
  return fd;
80105cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80105cf5:	c9                   	leave  
80105cf6:	c3                   	ret    

80105cf7 <sys_read>:

int
sys_read(void)
{
80105cf7:	55                   	push   %ebp
80105cf8:	89 e5                	mov    %esp,%ebp
80105cfa:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105cfd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d00:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d04:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d0b:	00 
80105d0c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d13:	e8 c7 fe ff ff       	call   80105bdf <argfd>
80105d18:	85 c0                	test   %eax,%eax
80105d1a:	78 35                	js     80105d51 <sys_read+0x5a>
80105d1c:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d1f:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d23:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105d2a:	e8 5a fd ff ff       	call   80105a89 <argint>
80105d2f:	85 c0                	test   %eax,%eax
80105d31:	78 1e                	js     80105d51 <sys_read+0x5a>
80105d33:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105d36:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d3a:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105d3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d41:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105d48:	e8 6a fd ff ff       	call   80105ab7 <argptr>
80105d4d:	85 c0                	test   %eax,%eax
80105d4f:	79 07                	jns    80105d58 <sys_read+0x61>
    return -1;
80105d51:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105d56:	eb 19                	jmp    80105d71 <sys_read+0x7a>
  return fileread(f, p, n);
80105d58:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105d5b:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d61:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105d65:	89 54 24 04          	mov    %edx,0x4(%esp)
80105d69:	89 04 24             	mov    %eax,(%esp)
80105d6c:	e8 bc b3 ff ff       	call   8010112d <fileread>
}
80105d71:	c9                   	leave  
80105d72:	c3                   	ret    

80105d73 <sys_write>:

int
sys_write(void)
{
80105d73:	55                   	push   %ebp
80105d74:	89 e5                	mov    %esp,%ebp
80105d76:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105d79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d7c:	89 44 24 08          	mov    %eax,0x8(%esp)
80105d80:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105d87:	00 
80105d88:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105d8f:	e8 4b fe ff ff       	call   80105bdf <argfd>
80105d94:	85 c0                	test   %eax,%eax
80105d96:	78 35                	js     80105dcd <sys_write+0x5a>
80105d98:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105d9b:	89 44 24 04          	mov    %eax,0x4(%esp)
80105d9f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105da6:	e8 de fc ff ff       	call   80105a89 <argint>
80105dab:	85 c0                	test   %eax,%eax
80105dad:	78 1e                	js     80105dcd <sys_write+0x5a>
80105daf:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105db2:	89 44 24 08          	mov    %eax,0x8(%esp)
80105db6:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105db9:	89 44 24 04          	mov    %eax,0x4(%esp)
80105dbd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105dc4:	e8 ee fc ff ff       	call   80105ab7 <argptr>
80105dc9:	85 c0                	test   %eax,%eax
80105dcb:	79 07                	jns    80105dd4 <sys_write+0x61>
    return -1;
80105dcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105dd2:	eb 19                	jmp    80105ded <sys_write+0x7a>
  return filewrite(f, p, n);
80105dd4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
80105dd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105dda:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ddd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80105de1:	89 54 24 04          	mov    %edx,0x4(%esp)
80105de5:	89 04 24             	mov    %eax,(%esp)
80105de8:	e8 fc b3 ff ff       	call   801011e9 <filewrite>
}
80105ded:	c9                   	leave  
80105dee:	c3                   	ret    

80105def <sys_close>:

int
sys_close(void)
{
80105def:	55                   	push   %ebp
80105df0:	89 e5                	mov    %esp,%ebp
80105df2:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;
  
  if(argfd(0, &fd, &f) < 0)
80105df5:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105df8:	89 44 24 08          	mov    %eax,0x8(%esp)
80105dfc:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105dff:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e03:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e0a:	e8 d0 fd ff ff       	call   80105bdf <argfd>
80105e0f:	85 c0                	test   %eax,%eax
80105e11:	79 07                	jns    80105e1a <sys_close+0x2b>
    return -1;
80105e13:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e18:	eb 24                	jmp    80105e3e <sys_close+0x4f>
  proc->ofile[fd] = 0;
80105e1a:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80105e20:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105e23:	83 c2 08             	add    $0x8,%edx
80105e26:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80105e2d:	00 
  fileclose(f);
80105e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105e31:	89 04 24             	mov    %eax,(%esp)
80105e34:	e8 cf b1 ff ff       	call   80101008 <fileclose>
  return 0;
80105e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
80105e3e:	c9                   	leave  
80105e3f:	c3                   	ret    

80105e40 <sys_fstat>:

int
sys_fstat(void)
{
80105e40:	55                   	push   %ebp
80105e41:	89 e5                	mov    %esp,%ebp
80105e43:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;
  
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105e46:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105e49:	89 44 24 08          	mov    %eax,0x8(%esp)
80105e4d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105e54:	00 
80105e55:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105e5c:	e8 7e fd ff ff       	call   80105bdf <argfd>
80105e61:	85 c0                	test   %eax,%eax
80105e63:	78 1f                	js     80105e84 <sys_fstat+0x44>
80105e65:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80105e6c:	00 
80105e6d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105e70:	89 44 24 04          	mov    %eax,0x4(%esp)
80105e74:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105e7b:	e8 37 fc ff ff       	call   80105ab7 <argptr>
80105e80:	85 c0                	test   %eax,%eax
80105e82:	79 07                	jns    80105e8b <sys_fstat+0x4b>
    return -1;
80105e84:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105e89:	eb 12                	jmp    80105e9d <sys_fstat+0x5d>
  return filestat(f, st);
80105e8b:	8b 55 f0             	mov    -0x10(%ebp),%edx
80105e8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105e91:	89 54 24 04          	mov    %edx,0x4(%esp)
80105e95:	89 04 24             	mov    %eax,(%esp)
80105e98:	e8 41 b2 ff ff       	call   801010de <filestat>
}
80105e9d:	c9                   	leave  
80105e9e:	c3                   	ret    

80105e9f <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80105e9f:	55                   	push   %ebp
80105ea0:	89 e5                	mov    %esp,%ebp
80105ea2:	83 ec 38             	sub    $0x38,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105ea5:	8d 45 d8             	lea    -0x28(%ebp),%eax
80105ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
80105eac:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105eb3:	e8 61 fc ff ff       	call   80105b19 <argstr>
80105eb8:	85 c0                	test   %eax,%eax
80105eba:	78 17                	js     80105ed3 <sys_link+0x34>
80105ebc:	8d 45 dc             	lea    -0x24(%ebp),%eax
80105ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
80105ec3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105eca:	e8 4a fc ff ff       	call   80105b19 <argstr>
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	79 0a                	jns    80105edd <sys_link+0x3e>
    return -1;
80105ed3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ed8:	e9 42 01 00 00       	jmp    8010601f <sys_link+0x180>

  begin_op();
80105edd:	e8 68 d5 ff ff       	call   8010344a <begin_op>
  if((ip = namei(old)) == 0){
80105ee2:	8b 45 d8             	mov    -0x28(%ebp),%eax
80105ee5:	89 04 24             	mov    %eax,(%esp)
80105ee8:	e8 53 c5 ff ff       	call   80102440 <namei>
80105eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
80105ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80105ef4:	75 0f                	jne    80105f05 <sys_link+0x66>
    end_op();
80105ef6:	e8 d3 d5 ff ff       	call   801034ce <end_op>
    return -1;
80105efb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f00:	e9 1a 01 00 00       	jmp    8010601f <sys_link+0x180>
  }

  ilock(ip);
80105f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f08:	89 04 24             	mov    %eax,(%esp)
80105f0b:	e8 85 b9 ff ff       	call   80101895 <ilock>
  if(ip->type == T_DIR){
80105f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f13:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80105f17:	66 83 f8 01          	cmp    $0x1,%ax
80105f1b:	75 1a                	jne    80105f37 <sys_link+0x98>
    iunlockput(ip);
80105f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f20:	89 04 24             	mov    %eax,(%esp)
80105f23:	e8 f1 bb ff ff       	call   80101b19 <iunlockput>
    end_op();
80105f28:	e8 a1 d5 ff ff       	call   801034ce <end_op>
    return -1;
80105f2d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105f32:	e9 e8 00 00 00       	jmp    8010601f <sys_link+0x180>
  }

  ip->nlink++;
80105f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f3a:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105f3e:	8d 50 01             	lea    0x1(%eax),%edx
80105f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f44:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f4b:	89 04 24             	mov    %eax,(%esp)
80105f4e:	e8 86 b7 ff ff       	call   801016d9 <iupdate>
  iunlock(ip);
80105f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f56:	89 04 24             	mov    %eax,(%esp)
80105f59:	e8 85 ba ff ff       	call   801019e3 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80105f5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105f61:	8d 55 e2             	lea    -0x1e(%ebp),%edx
80105f64:	89 54 24 04          	mov    %edx,0x4(%esp)
80105f68:	89 04 24             	mov    %eax,(%esp)
80105f6b:	e8 f2 c4 ff ff       	call   80102462 <nameiparent>
80105f70:	89 45 f0             	mov    %eax,-0x10(%ebp)
80105f73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80105f77:	75 02                	jne    80105f7b <sys_link+0xdc>
    goto bad;
80105f79:	eb 68                	jmp    80105fe3 <sys_link+0x144>
  ilock(dp);
80105f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f7e:	89 04 24             	mov    %eax,(%esp)
80105f81:	e8 0f b9 ff ff       	call   80101895 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105f89:	8b 10                	mov    (%eax),%edx
80105f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f8e:	8b 00                	mov    (%eax),%eax
80105f90:	39 c2                	cmp    %eax,%edx
80105f92:	75 20                	jne    80105fb4 <sys_link+0x115>
80105f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105f97:	8b 40 04             	mov    0x4(%eax),%eax
80105f9a:	89 44 24 08          	mov    %eax,0x8(%esp)
80105f9e:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80105fa1:	89 44 24 04          	mov    %eax,0x4(%esp)
80105fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fa8:	89 04 24             	mov    %eax,(%esp)
80105fab:	e8 d0 c1 ff ff       	call   80102180 <dirlink>
80105fb0:	85 c0                	test   %eax,%eax
80105fb2:	79 0d                	jns    80105fc1 <sys_link+0x122>
    iunlockput(dp);
80105fb4:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fb7:	89 04 24             	mov    %eax,(%esp)
80105fba:	e8 5a bb ff ff       	call   80101b19 <iunlockput>
    goto bad;
80105fbf:	eb 22                	jmp    80105fe3 <sys_link+0x144>
  }
  iunlockput(dp);
80105fc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105fc4:	89 04 24             	mov    %eax,(%esp)
80105fc7:	e8 4d bb ff ff       	call   80101b19 <iunlockput>
  iput(ip);
80105fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fcf:	89 04 24             	mov    %eax,(%esp)
80105fd2:	e8 71 ba ff ff       	call   80101a48 <iput>

  end_op();
80105fd7:	e8 f2 d4 ff ff       	call   801034ce <end_op>

  return 0;
80105fdc:	b8 00 00 00 00       	mov    $0x0,%eax
80105fe1:	eb 3c                	jmp    8010601f <sys_link+0x180>

bad:
  ilock(ip);
80105fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105fe6:	89 04 24             	mov    %eax,(%esp)
80105fe9:	e8 a7 b8 ff ff       	call   80101895 <ilock>
  ip->nlink--;
80105fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ff1:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80105ff5:	8d 50 ff             	lea    -0x1(%eax),%edx
80105ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105ffb:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
80105fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106002:	89 04 24             	mov    %eax,(%esp)
80106005:	e8 cf b6 ff ff       	call   801016d9 <iupdate>
  iunlockput(ip);
8010600a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010600d:	89 04 24             	mov    %eax,(%esp)
80106010:	e8 04 bb ff ff       	call   80101b19 <iunlockput>
  end_op();
80106015:	e8 b4 d4 ff ff       	call   801034ce <end_op>
  return -1;
8010601a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010601f:	c9                   	leave  
80106020:	c3                   	ret    

80106021 <isdirempty>:

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
80106021:	55                   	push   %ebp
80106022:	89 e5                	mov    %esp,%ebp
80106024:	83 ec 38             	sub    $0x38,%esp
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106027:	c7 45 f4 20 00 00 00 	movl   $0x20,-0xc(%ebp)
8010602e:	eb 4b                	jmp    8010607b <isdirempty+0x5a>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80106030:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106033:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
8010603a:	00 
8010603b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010603f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106042:	89 44 24 04          	mov    %eax,0x4(%esp)
80106046:	8b 45 08             	mov    0x8(%ebp),%eax
80106049:	89 04 24             	mov    %eax,(%esp)
8010604c:	e8 51 bd ff ff       	call   80101da2 <readi>
80106051:	83 f8 10             	cmp    $0x10,%eax
80106054:	74 0c                	je     80106062 <isdirempty+0x41>
      panic("isdirempty: readi");
80106056:	c7 04 24 74 91 10 80 	movl   $0x80109174,(%esp)
8010605d:	e8 d8 a4 ff ff       	call   8010053a <panic>
    if(de.inum != 0)
80106062:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80106066:	66 85 c0             	test   %ax,%ax
80106069:	74 07                	je     80106072 <isdirempty+0x51>
      return 0;
8010606b:	b8 00 00 00 00       	mov    $0x0,%eax
80106070:	eb 1b                	jmp    8010608d <isdirempty+0x6c>
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80106072:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106075:	83 c0 10             	add    $0x10,%eax
80106078:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010607b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010607e:	8b 45 08             	mov    0x8(%ebp),%eax
80106081:	8b 40 18             	mov    0x18(%eax),%eax
80106084:	39 c2                	cmp    %eax,%edx
80106086:	72 a8                	jb     80106030 <isdirempty+0xf>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
    if(de.inum != 0)
      return 0;
  }
  return 1;
80106088:	b8 01 00 00 00       	mov    $0x1,%eax
}
8010608d:	c9                   	leave  
8010608e:	c3                   	ret    

8010608f <sys_unlink>:

//PAGEBREAK!
int
sys_unlink(void)
{
8010608f:	55                   	push   %ebp
80106090:	89 e5                	mov    %esp,%ebp
80106092:	83 ec 48             	sub    $0x48,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80106095:	8d 45 cc             	lea    -0x34(%ebp),%eax
80106098:	89 44 24 04          	mov    %eax,0x4(%esp)
8010609c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801060a3:	e8 71 fa ff ff       	call   80105b19 <argstr>
801060a8:	85 c0                	test   %eax,%eax
801060aa:	79 0a                	jns    801060b6 <sys_unlink+0x27>
    return -1;
801060ac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060b1:	e9 af 01 00 00       	jmp    80106265 <sys_unlink+0x1d6>

  begin_op();
801060b6:	e8 8f d3 ff ff       	call   8010344a <begin_op>
  if((dp = nameiparent(path, name)) == 0){
801060bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
801060be:	8d 55 d2             	lea    -0x2e(%ebp),%edx
801060c1:	89 54 24 04          	mov    %edx,0x4(%esp)
801060c5:	89 04 24             	mov    %eax,(%esp)
801060c8:	e8 95 c3 ff ff       	call   80102462 <nameiparent>
801060cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
801060d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801060d4:	75 0f                	jne    801060e5 <sys_unlink+0x56>
    end_op();
801060d6:	e8 f3 d3 ff ff       	call   801034ce <end_op>
    return -1;
801060db:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801060e0:	e9 80 01 00 00       	jmp    80106265 <sys_unlink+0x1d6>
  }

  ilock(dp);
801060e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801060e8:	89 04 24             	mov    %eax,(%esp)
801060eb:	e8 a5 b7 ff ff       	call   80101895 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801060f0:	c7 44 24 04 86 91 10 	movl   $0x80109186,0x4(%esp)
801060f7:	80 
801060f8:	8d 45 d2             	lea    -0x2e(%ebp),%eax
801060fb:	89 04 24             	mov    %eax,(%esp)
801060fe:	e8 92 bf ff ff       	call   80102095 <namecmp>
80106103:	85 c0                	test   %eax,%eax
80106105:	0f 84 45 01 00 00    	je     80106250 <sys_unlink+0x1c1>
8010610b:	c7 44 24 04 88 91 10 	movl   $0x80109188,0x4(%esp)
80106112:	80 
80106113:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106116:	89 04 24             	mov    %eax,(%esp)
80106119:	e8 77 bf ff ff       	call   80102095 <namecmp>
8010611e:	85 c0                	test   %eax,%eax
80106120:	0f 84 2a 01 00 00    	je     80106250 <sys_unlink+0x1c1>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80106126:	8d 45 c8             	lea    -0x38(%ebp),%eax
80106129:	89 44 24 08          	mov    %eax,0x8(%esp)
8010612d:	8d 45 d2             	lea    -0x2e(%ebp),%eax
80106130:	89 44 24 04          	mov    %eax,0x4(%esp)
80106134:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106137:	89 04 24             	mov    %eax,(%esp)
8010613a:	e8 78 bf ff ff       	call   801020b7 <dirlookup>
8010613f:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106142:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106146:	75 05                	jne    8010614d <sys_unlink+0xbe>
    goto bad;
80106148:	e9 03 01 00 00       	jmp    80106250 <sys_unlink+0x1c1>
  ilock(ip);
8010614d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106150:	89 04 24             	mov    %eax,(%esp)
80106153:	e8 3d b7 ff ff       	call   80101895 <ilock>

  if(ip->nlink < 1)
80106158:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010615b:	0f b7 40 16          	movzwl 0x16(%eax),%eax
8010615f:	66 85 c0             	test   %ax,%ax
80106162:	7f 0c                	jg     80106170 <sys_unlink+0xe1>
    panic("unlink: nlink < 1");
80106164:	c7 04 24 8b 91 10 80 	movl   $0x8010918b,(%esp)
8010616b:	e8 ca a3 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR && !isdirempty(ip)){
80106170:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106173:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106177:	66 83 f8 01          	cmp    $0x1,%ax
8010617b:	75 1f                	jne    8010619c <sys_unlink+0x10d>
8010617d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106180:	89 04 24             	mov    %eax,(%esp)
80106183:	e8 99 fe ff ff       	call   80106021 <isdirempty>
80106188:	85 c0                	test   %eax,%eax
8010618a:	75 10                	jne    8010619c <sys_unlink+0x10d>
    iunlockput(ip);
8010618c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010618f:	89 04 24             	mov    %eax,(%esp)
80106192:	e8 82 b9 ff ff       	call   80101b19 <iunlockput>
    goto bad;
80106197:	e9 b4 00 00 00       	jmp    80106250 <sys_unlink+0x1c1>
  }

  memset(&de, 0, sizeof(de));
8010619c:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801061a3:	00 
801061a4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801061ab:	00 
801061ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061af:	89 04 24             	mov    %eax,(%esp)
801061b2:	e8 90 f5 ff ff       	call   80105747 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801061b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
801061ba:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
801061c1:	00 
801061c2:	89 44 24 08          	mov    %eax,0x8(%esp)
801061c6:	8d 45 e0             	lea    -0x20(%ebp),%eax
801061c9:	89 44 24 04          	mov    %eax,0x4(%esp)
801061cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061d0:	89 04 24             	mov    %eax,(%esp)
801061d3:	e8 2e bd ff ff       	call   80101f06 <writei>
801061d8:	83 f8 10             	cmp    $0x10,%eax
801061db:	74 0c                	je     801061e9 <sys_unlink+0x15a>
    panic("unlink: writei");
801061dd:	c7 04 24 9d 91 10 80 	movl   $0x8010919d,(%esp)
801061e4:	e8 51 a3 ff ff       	call   8010053a <panic>
  if(ip->type == T_DIR){
801061e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801061ec:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801061f0:	66 83 f8 01          	cmp    $0x1,%ax
801061f4:	75 1c                	jne    80106212 <sys_unlink+0x183>
    dp->nlink--;
801061f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801061f9:	0f b7 40 16          	movzwl 0x16(%eax),%eax
801061fd:	8d 50 ff             	lea    -0x1(%eax),%edx
80106200:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106203:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106207:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010620a:	89 04 24             	mov    %eax,(%esp)
8010620d:	e8 c7 b4 ff ff       	call   801016d9 <iupdate>
  }
  iunlockput(dp);
80106212:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106215:	89 04 24             	mov    %eax,(%esp)
80106218:	e8 fc b8 ff ff       	call   80101b19 <iunlockput>

  ip->nlink--;
8010621d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106220:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106224:	8d 50 ff             	lea    -0x1(%eax),%edx
80106227:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010622a:	66 89 50 16          	mov    %dx,0x16(%eax)
  iupdate(ip);
8010622e:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106231:	89 04 24             	mov    %eax,(%esp)
80106234:	e8 a0 b4 ff ff       	call   801016d9 <iupdate>
  iunlockput(ip);
80106239:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010623c:	89 04 24             	mov    %eax,(%esp)
8010623f:	e8 d5 b8 ff ff       	call   80101b19 <iunlockput>

  end_op();
80106244:	e8 85 d2 ff ff       	call   801034ce <end_op>

  return 0;
80106249:	b8 00 00 00 00       	mov    $0x0,%eax
8010624e:	eb 15                	jmp    80106265 <sys_unlink+0x1d6>

bad:
  iunlockput(dp);
80106250:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106253:	89 04 24             	mov    %eax,(%esp)
80106256:	e8 be b8 ff ff       	call   80101b19 <iunlockput>
  end_op();
8010625b:	e8 6e d2 ff ff       	call   801034ce <end_op>
  return -1;
80106260:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106265:	c9                   	leave  
80106266:	c3                   	ret    

80106267 <create>:

static struct inode*
create(char *path, short type, short major, short minor)
{
80106267:	55                   	push   %ebp
80106268:	89 e5                	mov    %esp,%ebp
8010626a:	83 ec 48             	sub    $0x48,%esp
8010626d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106270:	8b 55 10             	mov    0x10(%ebp),%edx
80106273:	8b 45 14             	mov    0x14(%ebp),%eax
80106276:	66 89 4d d4          	mov    %cx,-0x2c(%ebp)
8010627a:	66 89 55 d0          	mov    %dx,-0x30(%ebp)
8010627e:	66 89 45 cc          	mov    %ax,-0x34(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80106282:	8d 45 de             	lea    -0x22(%ebp),%eax
80106285:	89 44 24 04          	mov    %eax,0x4(%esp)
80106289:	8b 45 08             	mov    0x8(%ebp),%eax
8010628c:	89 04 24             	mov    %eax,(%esp)
8010628f:	e8 ce c1 ff ff       	call   80102462 <nameiparent>
80106294:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106297:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010629b:	75 0a                	jne    801062a7 <create+0x40>
    return 0;
8010629d:	b8 00 00 00 00       	mov    $0x0,%eax
801062a2:	e9 7e 01 00 00       	jmp    80106425 <create+0x1be>
  ilock(dp);
801062a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062aa:	89 04 24             	mov    %eax,(%esp)
801062ad:	e8 e3 b5 ff ff       	call   80101895 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801062b2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801062b5:	89 44 24 08          	mov    %eax,0x8(%esp)
801062b9:	8d 45 de             	lea    -0x22(%ebp),%eax
801062bc:	89 44 24 04          	mov    %eax,0x4(%esp)
801062c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062c3:	89 04 24             	mov    %eax,(%esp)
801062c6:	e8 ec bd ff ff       	call   801020b7 <dirlookup>
801062cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
801062ce:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801062d2:	74 47                	je     8010631b <create+0xb4>
    iunlockput(dp);
801062d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801062d7:	89 04 24             	mov    %eax,(%esp)
801062da:	e8 3a b8 ff ff       	call   80101b19 <iunlockput>
    ilock(ip);
801062df:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062e2:	89 04 24             	mov    %eax,(%esp)
801062e5:	e8 ab b5 ff ff       	call   80101895 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801062ea:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
801062ef:	75 15                	jne    80106306 <create+0x9f>
801062f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
801062f4:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801062f8:	66 83 f8 02          	cmp    $0x2,%ax
801062fc:	75 08                	jne    80106306 <create+0x9f>
      return ip;
801062fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106301:	e9 1f 01 00 00       	jmp    80106425 <create+0x1be>
    iunlockput(ip);
80106306:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106309:	89 04 24             	mov    %eax,(%esp)
8010630c:	e8 08 b8 ff ff       	call   80101b19 <iunlockput>
    return 0;
80106311:	b8 00 00 00 00       	mov    $0x0,%eax
80106316:	e9 0a 01 00 00       	jmp    80106425 <create+0x1be>
  }

  if((ip = ialloc(dp->dev, type)) == 0)
8010631b:	0f bf 55 d4          	movswl -0x2c(%ebp),%edx
8010631f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106322:	8b 00                	mov    (%eax),%eax
80106324:	89 54 24 04          	mov    %edx,0x4(%esp)
80106328:	89 04 24             	mov    %eax,(%esp)
8010632b:	e8 ca b2 ff ff       	call   801015fa <ialloc>
80106330:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106333:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106337:	75 0c                	jne    80106345 <create+0xde>
    panic("create: ialloc");
80106339:	c7 04 24 ac 91 10 80 	movl   $0x801091ac,(%esp)
80106340:	e8 f5 a1 ff ff       	call   8010053a <panic>

  ilock(ip);
80106345:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106348:	89 04 24             	mov    %eax,(%esp)
8010634b:	e8 45 b5 ff ff       	call   80101895 <ilock>
  ip->major = major;
80106350:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106353:	0f b7 55 d0          	movzwl -0x30(%ebp),%edx
80106357:	66 89 50 12          	mov    %dx,0x12(%eax)
  ip->minor = minor;
8010635b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010635e:	0f b7 55 cc          	movzwl -0x34(%ebp),%edx
80106362:	66 89 50 14          	mov    %dx,0x14(%eax)
  ip->nlink = 1;
80106366:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106369:	66 c7 40 16 01 00    	movw   $0x1,0x16(%eax)
  iupdate(ip);
8010636f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106372:	89 04 24             	mov    %eax,(%esp)
80106375:	e8 5f b3 ff ff       	call   801016d9 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
8010637a:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
8010637f:	75 6a                	jne    801063eb <create+0x184>
    dp->nlink++;  // for ".."
80106381:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106384:	0f b7 40 16          	movzwl 0x16(%eax),%eax
80106388:	8d 50 01             	lea    0x1(%eax),%edx
8010638b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010638e:	66 89 50 16          	mov    %dx,0x16(%eax)
    iupdate(dp);
80106392:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106395:	89 04 24             	mov    %eax,(%esp)
80106398:	e8 3c b3 ff ff       	call   801016d9 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010639d:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063a0:	8b 40 04             	mov    0x4(%eax),%eax
801063a3:	89 44 24 08          	mov    %eax,0x8(%esp)
801063a7:	c7 44 24 04 86 91 10 	movl   $0x80109186,0x4(%esp)
801063ae:	80 
801063af:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063b2:	89 04 24             	mov    %eax,(%esp)
801063b5:	e8 c6 bd ff ff       	call   80102180 <dirlink>
801063ba:	85 c0                	test   %eax,%eax
801063bc:	78 21                	js     801063df <create+0x178>
801063be:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063c1:	8b 40 04             	mov    0x4(%eax),%eax
801063c4:	89 44 24 08          	mov    %eax,0x8(%esp)
801063c8:	c7 44 24 04 88 91 10 	movl   $0x80109188,0x4(%esp)
801063cf:	80 
801063d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063d3:	89 04 24             	mov    %eax,(%esp)
801063d6:	e8 a5 bd ff ff       	call   80102180 <dirlink>
801063db:	85 c0                	test   %eax,%eax
801063dd:	79 0c                	jns    801063eb <create+0x184>
      panic("create dots");
801063df:	c7 04 24 bb 91 10 80 	movl   $0x801091bb,(%esp)
801063e6:	e8 4f a1 ff ff       	call   8010053a <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
801063eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801063ee:	8b 40 04             	mov    0x4(%eax),%eax
801063f1:	89 44 24 08          	mov    %eax,0x8(%esp)
801063f5:	8d 45 de             	lea    -0x22(%ebp),%eax
801063f8:	89 44 24 04          	mov    %eax,0x4(%esp)
801063fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801063ff:	89 04 24             	mov    %eax,(%esp)
80106402:	e8 79 bd ff ff       	call   80102180 <dirlink>
80106407:	85 c0                	test   %eax,%eax
80106409:	79 0c                	jns    80106417 <create+0x1b0>
    panic("create: dirlink");
8010640b:	c7 04 24 c7 91 10 80 	movl   $0x801091c7,(%esp)
80106412:	e8 23 a1 ff ff       	call   8010053a <panic>

  iunlockput(dp);
80106417:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010641a:	89 04 24             	mov    %eax,(%esp)
8010641d:	e8 f7 b6 ff ff       	call   80101b19 <iunlockput>

  return ip;
80106422:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
80106425:	c9                   	leave  
80106426:	c3                   	ret    

80106427 <sys_open>:

int
sys_open(void)
{
80106427:	55                   	push   %ebp
80106428:	89 e5                	mov    %esp,%ebp
8010642a:	83 ec 38             	sub    $0x38,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010642d:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106430:	89 44 24 04          	mov    %eax,0x4(%esp)
80106434:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010643b:	e8 d9 f6 ff ff       	call   80105b19 <argstr>
80106440:	85 c0                	test   %eax,%eax
80106442:	78 17                	js     8010645b <sys_open+0x34>
80106444:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106447:	89 44 24 04          	mov    %eax,0x4(%esp)
8010644b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106452:	e8 32 f6 ff ff       	call   80105a89 <argint>
80106457:	85 c0                	test   %eax,%eax
80106459:	79 0a                	jns    80106465 <sys_open+0x3e>
    return -1;
8010645b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106460:	e9 5c 01 00 00       	jmp    801065c1 <sys_open+0x19a>

  begin_op();
80106465:	e8 e0 cf ff ff       	call   8010344a <begin_op>

  if(omode & O_CREATE){
8010646a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010646d:	25 00 02 00 00       	and    $0x200,%eax
80106472:	85 c0                	test   %eax,%eax
80106474:	74 3b                	je     801064b1 <sys_open+0x8a>
    ip = create(path, T_FILE, 0, 0);
80106476:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106479:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
80106480:	00 
80106481:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80106488:	00 
80106489:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
80106490:	00 
80106491:	89 04 24             	mov    %eax,(%esp)
80106494:	e8 ce fd ff ff       	call   80106267 <create>
80106499:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(ip == 0){
8010649c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064a0:	75 6b                	jne    8010650d <sys_open+0xe6>
      end_op();
801064a2:	e8 27 d0 ff ff       	call   801034ce <end_op>
      return -1;
801064a7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064ac:	e9 10 01 00 00       	jmp    801065c1 <sys_open+0x19a>
    }
  } else {
    if((ip = namei(path)) == 0){
801064b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
801064b4:	89 04 24             	mov    %eax,(%esp)
801064b7:	e8 84 bf ff ff       	call   80102440 <namei>
801064bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
801064bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801064c3:	75 0f                	jne    801064d4 <sys_open+0xad>
      end_op();
801064c5:	e8 04 d0 ff ff       	call   801034ce <end_op>
      return -1;
801064ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801064cf:	e9 ed 00 00 00       	jmp    801065c1 <sys_open+0x19a>
    }
    ilock(ip);
801064d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064d7:	89 04 24             	mov    %eax,(%esp)
801064da:	e8 b6 b3 ff ff       	call   80101895 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
801064df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064e2:	0f b7 40 10          	movzwl 0x10(%eax),%eax
801064e6:	66 83 f8 01          	cmp    $0x1,%ax
801064ea:	75 21                	jne    8010650d <sys_open+0xe6>
801064ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801064ef:	85 c0                	test   %eax,%eax
801064f1:	74 1a                	je     8010650d <sys_open+0xe6>
      iunlockput(ip);
801064f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801064f6:	89 04 24             	mov    %eax,(%esp)
801064f9:	e8 1b b6 ff ff       	call   80101b19 <iunlockput>
      end_op();
801064fe:	e8 cb cf ff ff       	call   801034ce <end_op>
      return -1;
80106503:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106508:	e9 b4 00 00 00       	jmp    801065c1 <sys_open+0x19a>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010650d:	e8 4e aa ff ff       	call   80100f60 <filealloc>
80106512:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106515:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106519:	74 14                	je     8010652f <sys_open+0x108>
8010651b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010651e:	89 04 24             	mov    %eax,(%esp)
80106521:	e8 2e f7 ff ff       	call   80105c54 <fdalloc>
80106526:	89 45 ec             	mov    %eax,-0x14(%ebp)
80106529:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010652d:	79 28                	jns    80106557 <sys_open+0x130>
    if(f)
8010652f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106533:	74 0b                	je     80106540 <sys_open+0x119>
      fileclose(f);
80106535:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106538:	89 04 24             	mov    %eax,(%esp)
8010653b:	e8 c8 aa ff ff       	call   80101008 <fileclose>
    iunlockput(ip);
80106540:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106543:	89 04 24             	mov    %eax,(%esp)
80106546:	e8 ce b5 ff ff       	call   80101b19 <iunlockput>
    end_op();
8010654b:	e8 7e cf ff ff       	call   801034ce <end_op>
    return -1;
80106550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106555:	eb 6a                	jmp    801065c1 <sys_open+0x19a>
  }
  iunlock(ip);
80106557:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010655a:	89 04 24             	mov    %eax,(%esp)
8010655d:	e8 81 b4 ff ff       	call   801019e3 <iunlock>
  end_op();
80106562:	e8 67 cf ff ff       	call   801034ce <end_op>

  f->type = FD_INODE;
80106567:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010656a:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
  f->ip = ip;
80106570:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106573:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106576:	89 50 10             	mov    %edx,0x10(%eax)
  f->off = 0;
80106579:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010657c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
  f->readable = !(omode & O_WRONLY);
80106583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106586:	83 e0 01             	and    $0x1,%eax
80106589:	85 c0                	test   %eax,%eax
8010658b:	0f 94 c0             	sete   %al
8010658e:	89 c2                	mov    %eax,%edx
80106590:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106593:	88 50 08             	mov    %dl,0x8(%eax)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80106596:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106599:	83 e0 01             	and    $0x1,%eax
8010659c:	85 c0                	test   %eax,%eax
8010659e:	75 0a                	jne    801065aa <sys_open+0x183>
801065a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801065a3:	83 e0 02             	and    $0x2,%eax
801065a6:	85 c0                	test   %eax,%eax
801065a8:	74 07                	je     801065b1 <sys_open+0x18a>
801065aa:	b8 01 00 00 00       	mov    $0x1,%eax
801065af:	eb 05                	jmp    801065b6 <sys_open+0x18f>
801065b1:	b8 00 00 00 00       	mov    $0x0,%eax
801065b6:	89 c2                	mov    %eax,%edx
801065b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065bb:	88 50 09             	mov    %dl,0x9(%eax)
  return fd;
801065be:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
801065c1:	c9                   	leave  
801065c2:	c3                   	ret    

801065c3 <sys_mkdir>:

int
sys_mkdir(void)
{
801065c3:	55                   	push   %ebp
801065c4:	89 e5                	mov    %esp,%ebp
801065c6:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801065c9:	e8 7c ce ff ff       	call   8010344a <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801065ce:	8d 45 f0             	lea    -0x10(%ebp),%eax
801065d1:	89 44 24 04          	mov    %eax,0x4(%esp)
801065d5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801065dc:	e8 38 f5 ff ff       	call   80105b19 <argstr>
801065e1:	85 c0                	test   %eax,%eax
801065e3:	78 2c                	js     80106611 <sys_mkdir+0x4e>
801065e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801065e8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
801065ef:	00 
801065f0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801065f7:	00 
801065f8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801065ff:	00 
80106600:	89 04 24             	mov    %eax,(%esp)
80106603:	e8 5f fc ff ff       	call   80106267 <create>
80106608:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010660b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010660f:	75 0c                	jne    8010661d <sys_mkdir+0x5a>
    end_op();
80106611:	e8 b8 ce ff ff       	call   801034ce <end_op>
    return -1;
80106616:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010661b:	eb 15                	jmp    80106632 <sys_mkdir+0x6f>
  }
  iunlockput(ip);
8010661d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106620:	89 04 24             	mov    %eax,(%esp)
80106623:	e8 f1 b4 ff ff       	call   80101b19 <iunlockput>
  end_op();
80106628:	e8 a1 ce ff ff       	call   801034ce <end_op>
  return 0;
8010662d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106632:	c9                   	leave  
80106633:	c3                   	ret    

80106634 <sys_mknod>:

int
sys_mknod(void)
{
80106634:	55                   	push   %ebp
80106635:	89 e5                	mov    %esp,%ebp
80106637:	83 ec 38             	sub    $0x38,%esp
  struct inode *ip;
  char *path;
  int len;
  int major, minor;
  
  begin_op();
8010663a:	e8 0b ce ff ff       	call   8010344a <begin_op>
  if((len=argstr(0, &path)) < 0 ||
8010663f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106642:	89 44 24 04          	mov    %eax,0x4(%esp)
80106646:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010664d:	e8 c7 f4 ff ff       	call   80105b19 <argstr>
80106652:	89 45 f4             	mov    %eax,-0xc(%ebp)
80106655:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106659:	78 5e                	js     801066b9 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
8010665b:	8d 45 e8             	lea    -0x18(%ebp),%eax
8010665e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106662:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106669:	e8 1b f4 ff ff       	call   80105a89 <argint>
  char *path;
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
8010666e:	85 c0                	test   %eax,%eax
80106670:	78 47                	js     801066b9 <sys_mknod+0x85>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106672:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80106675:	89 44 24 04          	mov    %eax,0x4(%esp)
80106679:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106680:	e8 04 f4 ff ff       	call   80105a89 <argint>
  int len;
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80106685:	85 c0                	test   %eax,%eax
80106687:	78 30                	js     801066b9 <sys_mknod+0x85>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80106689:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010668c:	0f bf c8             	movswl %ax,%ecx
8010668f:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106692:	0f bf d0             	movswl %ax,%edx
80106695:	8b 45 ec             	mov    -0x14(%ebp),%eax
  int major, minor;
  
  begin_op();
  if((len=argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80106698:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010669c:	89 54 24 08          	mov    %edx,0x8(%esp)
801066a0:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801066a7:	00 
801066a8:	89 04 24             	mov    %eax,(%esp)
801066ab:	e8 b7 fb ff ff       	call   80106267 <create>
801066b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
801066b3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801066b7:	75 0c                	jne    801066c5 <sys_mknod+0x91>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
801066b9:	e8 10 ce ff ff       	call   801034ce <end_op>
    return -1;
801066be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801066c3:	eb 15                	jmp    801066da <sys_mknod+0xa6>
  }
  iunlockput(ip);
801066c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
801066c8:	89 04 24             	mov    %eax,(%esp)
801066cb:	e8 49 b4 ff ff       	call   80101b19 <iunlockput>
  end_op();
801066d0:	e8 f9 cd ff ff       	call   801034ce <end_op>
  return 0;
801066d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
801066da:	c9                   	leave  
801066db:	c3                   	ret    

801066dc <sys_chdir>:

int
sys_chdir(void)
{
801066dc:	55                   	push   %ebp
801066dd:	89 e5                	mov    %esp,%ebp
801066df:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801066e2:	e8 63 cd ff ff       	call   8010344a <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801066e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801066ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801066ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801066f5:	e8 1f f4 ff ff       	call   80105b19 <argstr>
801066fa:	85 c0                	test   %eax,%eax
801066fc:	78 14                	js     80106712 <sys_chdir+0x36>
801066fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106701:	89 04 24             	mov    %eax,(%esp)
80106704:	e8 37 bd ff ff       	call   80102440 <namei>
80106709:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010670c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80106710:	75 0c                	jne    8010671e <sys_chdir+0x42>
    end_op();
80106712:	e8 b7 cd ff ff       	call   801034ce <end_op>
    return -1;
80106717:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010671c:	eb 61                	jmp    8010677f <sys_chdir+0xa3>
  }
  ilock(ip);
8010671e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106721:	89 04 24             	mov    %eax,(%esp)
80106724:	e8 6c b1 ff ff       	call   80101895 <ilock>
  if(ip->type != T_DIR){
80106729:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010672c:	0f b7 40 10          	movzwl 0x10(%eax),%eax
80106730:	66 83 f8 01          	cmp    $0x1,%ax
80106734:	74 17                	je     8010674d <sys_chdir+0x71>
    iunlockput(ip);
80106736:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106739:	89 04 24             	mov    %eax,(%esp)
8010673c:	e8 d8 b3 ff ff       	call   80101b19 <iunlockput>
    end_op();
80106741:	e8 88 cd ff ff       	call   801034ce <end_op>
    return -1;
80106746:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010674b:	eb 32                	jmp    8010677f <sys_chdir+0xa3>
  }
  iunlock(ip);
8010674d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106750:	89 04 24             	mov    %eax,(%esp)
80106753:	e8 8b b2 ff ff       	call   801019e3 <iunlock>
  iput(proc->cwd);
80106758:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010675e:	8b 40 68             	mov    0x68(%eax),%eax
80106761:	89 04 24             	mov    %eax,(%esp)
80106764:	e8 df b2 ff ff       	call   80101a48 <iput>
  end_op();
80106769:	e8 60 cd ff ff       	call   801034ce <end_op>
  proc->cwd = ip;
8010676e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106774:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106777:	89 50 68             	mov    %edx,0x68(%eax)
  return 0;
8010677a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010677f:	c9                   	leave  
80106780:	c3                   	ret    

80106781 <sys_exec>:

int
sys_exec(void)
{
80106781:	55                   	push   %ebp
80106782:	89 e5                	mov    %esp,%ebp
80106784:	81 ec a8 00 00 00    	sub    $0xa8,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010678a:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010678d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106791:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106798:	e8 7c f3 ff ff       	call   80105b19 <argstr>
8010679d:	85 c0                	test   %eax,%eax
8010679f:	78 1a                	js     801067bb <sys_exec+0x3a>
801067a1:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
801067a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801067ab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801067b2:	e8 d2 f2 ff ff       	call   80105a89 <argint>
801067b7:	85 c0                	test   %eax,%eax
801067b9:	79 0a                	jns    801067c5 <sys_exec+0x44>
    return -1;
801067bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067c0:	e9 c8 00 00 00       	jmp    8010688d <sys_exec+0x10c>
  }
  memset(argv, 0, sizeof(argv));
801067c5:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801067cc:	00 
801067cd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801067d4:	00 
801067d5:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
801067db:	89 04 24             	mov    %eax,(%esp)
801067de:	e8 64 ef ff ff       	call   80105747 <memset>
  for(i=0;; i++){
801067e3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if(i >= NELEM(argv))
801067ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ed:	83 f8 1f             	cmp    $0x1f,%eax
801067f0:	76 0a                	jbe    801067fc <sys_exec+0x7b>
      return -1;
801067f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067f7:	e9 91 00 00 00       	jmp    8010688d <sys_exec+0x10c>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801067fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
801067ff:	c1 e0 02             	shl    $0x2,%eax
80106802:	89 c2                	mov    %eax,%edx
80106804:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
8010680a:	01 c2                	add    %eax,%edx
8010680c:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80106812:	89 44 24 04          	mov    %eax,0x4(%esp)
80106816:	89 14 24             	mov    %edx,(%esp)
80106819:	e8 cf f1 ff ff       	call   801059ed <fetchint>
8010681e:	85 c0                	test   %eax,%eax
80106820:	79 07                	jns    80106829 <sys_exec+0xa8>
      return -1;
80106822:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106827:	eb 64                	jmp    8010688d <sys_exec+0x10c>
    if(uarg == 0){
80106829:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010682f:	85 c0                	test   %eax,%eax
80106831:	75 26                	jne    80106859 <sys_exec+0xd8>
      argv[i] = 0;
80106833:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106836:	c7 84 85 70 ff ff ff 	movl   $0x0,-0x90(%ebp,%eax,4)
8010683d:	00 00 00 00 
      break;
80106841:	90                   	nop
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80106842:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106845:	8d 95 70 ff ff ff    	lea    -0x90(%ebp),%edx
8010684b:	89 54 24 04          	mov    %edx,0x4(%esp)
8010684f:	89 04 24             	mov    %eax,(%esp)
80106852:	e8 a1 a2 ff ff       	call   80100af8 <exec>
80106857:	eb 34                	jmp    8010688d <sys_exec+0x10c>
      return -1;
    if(uarg == 0){
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80106859:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
8010685f:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106862:	c1 e2 02             	shl    $0x2,%edx
80106865:	01 c2                	add    %eax,%edx
80106867:	8b 85 68 ff ff ff    	mov    -0x98(%ebp),%eax
8010686d:	89 54 24 04          	mov    %edx,0x4(%esp)
80106871:	89 04 24             	mov    %eax,(%esp)
80106874:	e8 ae f1 ff ff       	call   80105a27 <fetchstr>
80106879:	85 c0                	test   %eax,%eax
8010687b:	79 07                	jns    80106884 <sys_exec+0x103>
      return -1;
8010687d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106882:	eb 09                	jmp    8010688d <sys_exec+0x10c>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80106884:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
80106888:	e9 5d ff ff ff       	jmp    801067ea <sys_exec+0x69>
  return exec(path, argv);
}
8010688d:	c9                   	leave  
8010688e:	c3                   	ret    

8010688f <sys_pipe>:

int
sys_pipe(void)
{
8010688f:	55                   	push   %ebp
80106890:	89 e5                	mov    %esp,%ebp
80106892:	83 ec 38             	sub    $0x38,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80106895:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
8010689c:	00 
8010689d:	8d 45 ec             	lea    -0x14(%ebp),%eax
801068a0:	89 44 24 04          	mov    %eax,0x4(%esp)
801068a4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801068ab:	e8 07 f2 ff ff       	call   80105ab7 <argptr>
801068b0:	85 c0                	test   %eax,%eax
801068b2:	79 0a                	jns    801068be <sys_pipe+0x2f>
    return -1;
801068b4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068b9:	e9 9b 00 00 00       	jmp    80106959 <sys_pipe+0xca>
  if(pipealloc(&rf, &wf) < 0)
801068be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801068c1:	89 44 24 04          	mov    %eax,0x4(%esp)
801068c5:	8d 45 e8             	lea    -0x18(%ebp),%eax
801068c8:	89 04 24             	mov    %eax,(%esp)
801068cb:	e8 8b d6 ff ff       	call   80103f5b <pipealloc>
801068d0:	85 c0                	test   %eax,%eax
801068d2:	79 07                	jns    801068db <sys_pipe+0x4c>
    return -1;
801068d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801068d9:	eb 7e                	jmp    80106959 <sys_pipe+0xca>
  fd0 = -1;
801068db:	c7 45 f4 ff ff ff ff 	movl   $0xffffffff,-0xc(%ebp)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801068e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
801068e5:	89 04 24             	mov    %eax,(%esp)
801068e8:	e8 67 f3 ff ff       	call   80105c54 <fdalloc>
801068ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
801068f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
801068f4:	78 14                	js     8010690a <sys_pipe+0x7b>
801068f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068f9:	89 04 24             	mov    %eax,(%esp)
801068fc:	e8 53 f3 ff ff       	call   80105c54 <fdalloc>
80106901:	89 45 f0             	mov    %eax,-0x10(%ebp)
80106904:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80106908:	79 37                	jns    80106941 <sys_pipe+0xb2>
    if(fd0 >= 0)
8010690a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
8010690e:	78 14                	js     80106924 <sys_pipe+0x95>
      proc->ofile[fd0] = 0;
80106910:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106916:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106919:	83 c2 08             	add    $0x8,%edx
8010691c:	c7 44 90 08 00 00 00 	movl   $0x0,0x8(%eax,%edx,4)
80106923:	00 
    fileclose(rf);
80106924:	8b 45 e8             	mov    -0x18(%ebp),%eax
80106927:	89 04 24             	mov    %eax,(%esp)
8010692a:	e8 d9 a6 ff ff       	call   80101008 <fileclose>
    fileclose(wf);
8010692f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106932:	89 04 24             	mov    %eax,(%esp)
80106935:	e8 ce a6 ff ff       	call   80101008 <fileclose>
    return -1;
8010693a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010693f:	eb 18                	jmp    80106959 <sys_pipe+0xca>
  }
  fd[0] = fd0;
80106941:	8b 45 ec             	mov    -0x14(%ebp),%eax
80106944:	8b 55 f4             	mov    -0xc(%ebp),%edx
80106947:	89 10                	mov    %edx,(%eax)
  fd[1] = fd1;
80106949:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010694c:	8d 50 04             	lea    0x4(%eax),%edx
8010694f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106952:	89 02                	mov    %eax,(%edx)
  return 0;
80106954:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106959:	c9                   	leave  
8010695a:	c3                   	ret    

8010695b <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
8010695b:	55                   	push   %ebp
8010695c:	89 e5                	mov    %esp,%ebp
8010695e:	83 ec 08             	sub    $0x8,%esp
  return fork();
80106961:	e8 fd dc ff ff       	call   80104663 <fork>
}
80106966:	c9                   	leave  
80106967:	c3                   	ret    

80106968 <sys_exit>:

int
sys_exit(void)
{
80106968:	55                   	push   %ebp
80106969:	89 e5                	mov    %esp,%ebp
8010696b:	83 ec 28             	sub    $0x28,%esp
 int status;

  if(argint(0, &status) < 0)
8010696e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106971:	89 44 24 04          	mov    %eax,0x4(%esp)
80106975:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010697c:	e8 08 f1 ff ff       	call   80105a89 <argint>
80106981:	85 c0                	test   %eax,%eax
80106983:	79 07                	jns    8010698c <sys_exit+0x24>
    return -1;
80106985:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010698a:	eb 10                	jmp    8010699c <sys_exit+0x34>
  exit(status);
8010698c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010698f:	89 04 24             	mov    %eax,(%esp)
80106992:	e8 a4 de ff ff       	call   8010483b <exit>
  return 0;  // not reached
80106997:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010699c:	c9                   	leave  
8010699d:	c3                   	ret    

8010699e <sys_wait>:

int
sys_wait(void)
{
8010699e:	55                   	push   %ebp
8010699f:	89 e5                	mov    %esp,%ebp
801069a1:	83 ec 28             	sub    $0x28,%esp
  char *status;
  if(argptr(0, &status,sizeof(int)) < 0)
801069a4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801069ab:	00 
801069ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069af:	89 44 24 04          	mov    %eax,0x4(%esp)
801069b3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069ba:	e8 f8 f0 ff ff       	call   80105ab7 <argptr>
801069bf:	85 c0                	test   %eax,%eax
801069c1:	79 07                	jns    801069ca <sys_wait+0x2c>
    return -1;
801069c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801069c8:	eb 0b                	jmp    801069d5 <sys_wait+0x37>
  return wait((int*)status);
801069ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
801069cd:	89 04 24             	mov    %eax,(%esp)
801069d0:	e8 a9 df ff ff       	call   8010497e <wait>
}
801069d5:	c9                   	leave  
801069d6:	c3                   	ret    

801069d7 <sys_waitpid>:

int
sys_waitpid(void)
{
801069d7:	55                   	push   %ebp
801069d8:	89 e5                	mov    %esp,%ebp
801069da:	83 ec 28             	sub    $0x28,%esp
  int pid;
  char *status;
  int options;

  if((argint(0, &pid) < 0) || (argptr(1, &status,sizeof(int)) < 0) || (argint(2, &options) < 0))
801069dd:	8d 45 f4             	lea    -0xc(%ebp),%eax
801069e0:	89 44 24 04          	mov    %eax,0x4(%esp)
801069e4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801069eb:	e8 99 f0 ff ff       	call   80105a89 <argint>
801069f0:	85 c0                	test   %eax,%eax
801069f2:	78 36                	js     80106a2a <sys_waitpid+0x53>
801069f4:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
801069fb:	00 
801069fc:	8d 45 f0             	lea    -0x10(%ebp),%eax
801069ff:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a03:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a0a:	e8 a8 f0 ff ff       	call   80105ab7 <argptr>
80106a0f:	85 c0                	test   %eax,%eax
80106a11:	78 17                	js     80106a2a <sys_waitpid+0x53>
80106a13:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a16:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a1a:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106a21:	e8 63 f0 ff ff       	call   80105a89 <argint>
80106a26:	85 c0                	test   %eax,%eax
80106a28:	79 07                	jns    80106a31 <sys_waitpid+0x5a>
    return -1;
80106a2a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106a2f:	eb 19                	jmp    80106a4a <sys_waitpid+0x73>

  return waitpid(pid,(int*)status,options);
80106a31:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106a34:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106a37:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106a3a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106a3e:	89 54 24 04          	mov    %edx,0x4(%esp)
80106a42:	89 04 24             	mov    %eax,(%esp)
80106a45:	e8 5b e0 ff ff       	call   80104aa5 <waitpid>
}
80106a4a:	c9                   	leave  
80106a4b:	c3                   	ret    

80106a4c <sys_wait_stat>:

int
sys_wait_stat(void)
{
80106a4c:	55                   	push   %ebp
80106a4d:	89 e5                	mov    %esp,%ebp
80106a4f:	53                   	push   %ebx
80106a50:	83 ec 24             	sub    $0x24,%esp
  char *wtime;
  char *rtime;
  char *iotime;
  char *status;

  if( (argptr(0, &wtime,sizeof(int)) < 0) || (argptr(1, &rtime,sizeof(int)) < 0) || (argptr(2, &iotime,sizeof(int)) < 0) || (argptr(3, &status,sizeof(int)) < 0))
80106a53:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106a5a:	00 
80106a5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106a69:	e8 49 f0 ff ff       	call   80105ab7 <argptr>
80106a6e:	85 c0                	test   %eax,%eax
80106a70:	78 5d                	js     80106acf <sys_wait_stat+0x83>
80106a72:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106a79:	00 
80106a7a:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106a7d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106a81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106a88:	e8 2a f0 ff ff       	call   80105ab7 <argptr>
80106a8d:	85 c0                	test   %eax,%eax
80106a8f:	78 3e                	js     80106acf <sys_wait_stat+0x83>
80106a91:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106a98:	00 
80106a99:	8d 45 ec             	lea    -0x14(%ebp),%eax
80106a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106aa0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80106aa7:	e8 0b f0 ff ff       	call   80105ab7 <argptr>
80106aac:	85 c0                	test   %eax,%eax
80106aae:	78 1f                	js     80106acf <sys_wait_stat+0x83>
80106ab0:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80106ab7:	00 
80106ab8:	8d 45 e8             	lea    -0x18(%ebp),%eax
80106abb:	89 44 24 04          	mov    %eax,0x4(%esp)
80106abf:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
80106ac6:	e8 ec ef ff ff       	call   80105ab7 <argptr>
80106acb:	85 c0                	test   %eax,%eax
80106acd:	79 07                	jns    80106ad6 <sys_wait_stat+0x8a>
    return -1;
80106acf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ad4:	eb 20                	jmp    80106af6 <sys_wait_stat+0xaa>

  return wait_stat((int*)wtime,(int*)rtime,(int*)iotime,(int*)status);
80106ad6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
80106ad9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
80106adc:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ae2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80106ae6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106aea:	89 54 24 04          	mov    %edx,0x4(%esp)
80106aee:	89 04 24             	mov    %eax,(%esp)
80106af1:	e8 ea e0 ff ff       	call   80104be0 <wait_stat>
}
80106af6:	83 c4 24             	add    $0x24,%esp
80106af9:	5b                   	pop    %ebx
80106afa:	5d                   	pop    %ebp
80106afb:	c3                   	ret    

80106afc <sys_kill>:

int
sys_kill(void)
{
80106afc:	55                   	push   %ebp
80106afd:	89 e5                	mov    %esp,%ebp
80106aff:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80106b02:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106b05:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b10:	e8 74 ef ff ff       	call   80105a89 <argint>
80106b15:	85 c0                	test   %eax,%eax
80106b17:	79 07                	jns    80106b20 <sys_kill+0x24>
    return -1;
80106b19:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b1e:	eb 0b                	jmp    80106b2b <sys_kill+0x2f>
  return kill(pid);
80106b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106b23:	89 04 24             	mov    %eax,(%esp)
80106b26:	e8 08 e5 ff ff       	call   80105033 <kill>
}
80106b2b:	c9                   	leave  
80106b2c:	c3                   	ret    

80106b2d <sys_getpid>:

int
sys_getpid(void)
{
80106b2d:	55                   	push   %ebp
80106b2e:	89 e5                	mov    %esp,%ebp
  return proc->pid;
80106b30:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b36:	8b 40 10             	mov    0x10(%eax),%eax
}
80106b39:	5d                   	pop    %ebp
80106b3a:	c3                   	ret    

80106b3b <sys_sbrk>:

int
sys_sbrk(void)
{
80106b3b:	55                   	push   %ebp
80106b3c:	89 e5                	mov    %esp,%ebp
80106b3e:	83 ec 28             	sub    $0x28,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80106b41:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b44:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b48:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b4f:	e8 35 ef ff ff       	call   80105a89 <argint>
80106b54:	85 c0                	test   %eax,%eax
80106b56:	79 07                	jns    80106b5f <sys_sbrk+0x24>
    return -1;
80106b58:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b5d:	eb 24                	jmp    80106b83 <sys_sbrk+0x48>
  addr = proc->sz;
80106b5f:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106b65:	8b 00                	mov    (%eax),%eax
80106b67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(growproc(n) < 0)
80106b6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106b6d:	89 04 24             	mov    %eax,(%esp)
80106b70:	e8 49 da ff ff       	call   801045be <growproc>
80106b75:	85 c0                	test   %eax,%eax
80106b77:	79 07                	jns    80106b80 <sys_sbrk+0x45>
    return -1;
80106b79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106b7e:	eb 03                	jmp    80106b83 <sys_sbrk+0x48>
  return addr;
80106b80:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106b83:	c9                   	leave  
80106b84:	c3                   	ret    

80106b85 <sys_sleep>:

int
sys_sleep(void)
{
80106b85:	55                   	push   %ebp
80106b86:	89 e5                	mov    %esp,%ebp
80106b88:	83 ec 28             	sub    $0x28,%esp
  int n;
  uint ticks0;
  
  if(argint(0, &n) < 0)
80106b8b:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106b8e:	89 44 24 04          	mov    %eax,0x4(%esp)
80106b92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106b99:	e8 eb ee ff ff       	call   80105a89 <argint>
80106b9e:	85 c0                	test   %eax,%eax
80106ba0:	79 07                	jns    80106ba9 <sys_sleep+0x24>
    return -1;
80106ba2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106ba7:	eb 6c                	jmp    80106c15 <sys_sleep+0x90>
  acquire(&tickslock);
80106ba9:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80106bb0:	e8 39 e9 ff ff       	call   801054ee <acquire>
  ticks0 = ticks;
80106bb5:	a1 00 6a 11 80       	mov    0x80116a00,%eax
80106bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(ticks - ticks0 < n){
80106bbd:	eb 34                	jmp    80106bf3 <sys_sleep+0x6e>
    if(proc->killed){
80106bbf:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106bc5:	8b 40 24             	mov    0x24(%eax),%eax
80106bc8:	85 c0                	test   %eax,%eax
80106bca:	74 13                	je     80106bdf <sys_sleep+0x5a>
      release(&tickslock);
80106bcc:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80106bd3:	e8 7d e9 ff ff       	call   80105555 <release>
      return -1;
80106bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106bdd:	eb 36                	jmp    80106c15 <sys_sleep+0x90>
    }
    sleep(&ticks, &tickslock);
80106bdf:	c7 44 24 04 c0 61 11 	movl   $0x801161c0,0x4(%esp)
80106be6:	80 
80106be7:	c7 04 24 00 6a 11 80 	movl   $0x80116a00,(%esp)
80106bee:	e8 29 e3 ff ff       	call   80104f1c <sleep>
  
  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80106bf3:	a1 00 6a 11 80       	mov    0x80116a00,%eax
80106bf8:	2b 45 f4             	sub    -0xc(%ebp),%eax
80106bfb:	89 c2                	mov    %eax,%edx
80106bfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
80106c00:	39 c2                	cmp    %eax,%edx
80106c02:	72 bb                	jb     80106bbf <sys_sleep+0x3a>
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
80106c04:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80106c0b:	e8 45 e9 ff ff       	call   80105555 <release>
  return 0;
80106c10:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106c15:	c9                   	leave  
80106c16:	c3                   	ret    

80106c17 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80106c17:	55                   	push   %ebp
80106c18:	89 e5                	mov    %esp,%ebp
80106c1a:	83 ec 28             	sub    $0x28,%esp
  uint xticks;
  
  acquire(&tickslock);
80106c1d:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80106c24:	e8 c5 e8 ff ff       	call   801054ee <acquire>
  xticks = ticks;
80106c29:	a1 00 6a 11 80       	mov    0x80116a00,%eax
80106c2e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  release(&tickslock);
80106c31:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80106c38:	e8 18 e9 ff ff       	call   80105555 <release>
  return xticks;
80106c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
80106c40:	c9                   	leave  
80106c41:	c3                   	ret    

80106c42 <sys_set_priority>:

int
sys_set_priority(void)
{
80106c42:	55                   	push   %ebp
80106c43:	89 e5                	mov    %esp,%ebp
80106c45:	83 ec 28             	sub    $0x28,%esp
 int priority;

  if(argint(0, &priority) < 0)
80106c48:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c4b:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c4f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c56:	e8 2e ee ff ff       	call   80105a89 <argint>
80106c5b:	85 c0                	test   %eax,%eax
80106c5d:	79 07                	jns    80106c66 <sys_set_priority+0x24>
    return -1;
80106c5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c64:	eb 0b                	jmp    80106c71 <sys_set_priority+0x2f>
  return set_priority(priority);
80106c66:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c69:	89 04 24             	mov    %eax,(%esp)
80106c6c:	e8 da e5 ff ff       	call   8010524b <set_priority>
}
80106c71:	c9                   	leave  
80106c72:	c3                   	ret    

80106c73 <sys_jobs>:

int 
sys_jobs(void)
{
80106c73:	55                   	push   %ebp
80106c74:	89 e5                	mov    %esp,%ebp
80106c76:	83 ec 28             	sub    $0x28,%esp
int gid;
  if(argint(0, &gid) < 0)
80106c79:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c80:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106c87:	e8 fd ed ff ff       	call   80105a89 <argint>
80106c8c:	85 c0                	test   %eax,%eax
80106c8e:	79 07                	jns    80106c97 <sys_jobs+0x24>
    return -1; 
80106c90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106c95:	eb 0b                	jmp    80106ca2 <sys_jobs+0x2f>
  return jobs(gid);
80106c97:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106c9a:	89 04 24             	mov    %eax,(%esp)
80106c9d:	e8 5f e6 ff ff       	call   80105301 <jobs>
}
80106ca2:	c9                   	leave  
80106ca3:	c3                   	ret    

80106ca4 <sys_canRemoveJob>:

int
sys_canRemoveJob(void)
{
80106ca4:	55                   	push   %ebp
80106ca5:	89 e5                	mov    %esp,%ebp
80106ca7:	83 ec 28             	sub    $0x28,%esp
 int gid;
  if(argint(0, &gid) < 0)
80106caa:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cad:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cb1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106cb8:	e8 cc ed ff ff       	call   80105a89 <argint>
80106cbd:	85 c0                	test   %eax,%eax
80106cbf:	79 07                	jns    80106cc8 <sys_canRemoveJob+0x24>
    return -1;
80106cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106cc6:	eb 0b                	jmp    80106cd3 <sys_canRemoveJob+0x2f>
  return canRemoveJob(gid);
80106cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ccb:	89 04 24             	mov    %eax,(%esp)
80106cce:	e8 b3 e5 ff ff       	call   80105286 <canRemoveJob>

}
80106cd3:	c9                   	leave  
80106cd4:	c3                   	ret    

80106cd5 <sys_gidpid>:

int
sys_gidpid(void)
{
80106cd5:	55                   	push   %ebp
80106cd6:	89 e5                	mov    %esp,%ebp
80106cd8:	83 ec 28             	sub    $0x28,%esp
  int gid;
  int min;
  if (argint(0, &gid) < 0 || argint(1,&min) < 0) 
80106cdb:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106cde:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ce2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106ce9:	e8 9b ed ff ff       	call   80105a89 <argint>
80106cee:	85 c0                	test   %eax,%eax
80106cf0:	78 17                	js     80106d09 <sys_gidpid+0x34>
80106cf2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80106cf5:	89 44 24 04          	mov    %eax,0x4(%esp)
80106cf9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80106d00:	e8 84 ed ff ff       	call   80105a89 <argint>
80106d05:	85 c0                	test   %eax,%eax
80106d07:	79 07                	jns    80106d10 <sys_gidpid+0x3b>
    return -1;
80106d09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d0e:	eb 12                	jmp    80106d22 <sys_gidpid+0x4d>
  return gidpid(gid,min);
80106d10:	8b 55 f0             	mov    -0x10(%ebp),%edx
80106d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d16:	89 54 24 04          	mov    %edx,0x4(%esp)
80106d1a:	89 04 24             	mov    %eax,(%esp)
80106d1d:	e8 7f e6 ff ff       	call   801053a1 <gidpid>
}
80106d22:	c9                   	leave  
80106d23:	c3                   	ret    

80106d24 <sys_isShell>:

int 
sys_isShell(void)
{
80106d24:	55                   	push   %ebp
80106d25:	89 e5                	mov    %esp,%ebp
80106d27:	83 ec 28             	sub    $0x28,%esp
  int pid;
  if (argint(0,&pid) < 0)
80106d2a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80106d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
80106d31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106d38:	e8 4c ed ff ff       	call   80105a89 <argint>
80106d3d:	85 c0                	test   %eax,%eax
80106d3f:	79 07                	jns    80106d48 <sys_isShell+0x24>
	return -1;
80106d41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106d46:	eb 0b                	jmp    80106d53 <sys_isShell+0x2f>
  return isShell(pid);
80106d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106d4b:	89 04 24             	mov    %eax,(%esp)
80106d4e:	e8 c4 e6 ff ff       	call   80105417 <isShell>
}
80106d53:	c9                   	leave  
80106d54:	c3                   	ret    

80106d55 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80106d55:	55                   	push   %ebp
80106d56:	89 e5                	mov    %esp,%ebp
80106d58:	83 ec 08             	sub    $0x8,%esp
80106d5b:	8b 55 08             	mov    0x8(%ebp),%edx
80106d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d61:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80106d65:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106d68:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80106d6c:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
80106d70:	ee                   	out    %al,(%dx)
}
80106d71:	c9                   	leave  
80106d72:	c3                   	ret    

80106d73 <timerinit>:
#define TIMER_RATEGEN   0x04    // mode 2, rate generator
#define TIMER_16BIT     0x30    // r/w counter 16 bits, LSB first

void
timerinit(void)
{
80106d73:	55                   	push   %ebp
80106d74:	89 e5                	mov    %esp,%ebp
80106d76:	83 ec 18             	sub    $0x18,%esp
  // Interrupt 100 times/sec.
  outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
80106d79:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
80106d80:	00 
80106d81:	c7 04 24 43 00 00 00 	movl   $0x43,(%esp)
80106d88:	e8 c8 ff ff ff       	call   80106d55 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) % 256);
80106d8d:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
80106d94:	00 
80106d95:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106d9c:	e8 b4 ff ff ff       	call   80106d55 <outb>
  outb(IO_TIMER1, TIMER_DIV(100) / 256);
80106da1:	c7 44 24 04 2e 00 00 	movl   $0x2e,0x4(%esp)
80106da8:	00 
80106da9:	c7 04 24 40 00 00 00 	movl   $0x40,(%esp)
80106db0:	e8 a0 ff ff ff       	call   80106d55 <outb>
  picenable(IRQ_TIMER);
80106db5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80106dbc:	e8 2d d0 ff ff       	call   80103dee <picenable>
}
80106dc1:	c9                   	leave  
80106dc2:	c3                   	ret    

80106dc3 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80106dc3:	1e                   	push   %ds
  pushl %es
80106dc4:	06                   	push   %es
  pushl %fs
80106dc5:	0f a0                	push   %fs
  pushl %gs
80106dc7:	0f a8                	push   %gs
  pushal
80106dc9:	60                   	pusha  
  
  # Set up data and per-cpu segments.
  movw $(SEG_KDATA<<3), %ax
80106dca:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80106dce:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80106dd0:	8e c0                	mov    %eax,%es
  movw $(SEG_KCPU<<3), %ax
80106dd2:	66 b8 18 00          	mov    $0x18,%ax
  movw %ax, %fs
80106dd6:	8e e0                	mov    %eax,%fs
  movw %ax, %gs
80106dd8:	8e e8                	mov    %eax,%gs

  # Call trap(tf), where tf=%esp
  pushl %esp
80106dda:	54                   	push   %esp
  call trap
80106ddb:	e8 d8 01 00 00       	call   80106fb8 <trap>
  addl $4, %esp
80106de0:	83 c4 04             	add    $0x4,%esp

80106de3 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80106de3:	61                   	popa   
  popl %gs
80106de4:	0f a9                	pop    %gs
  popl %fs
80106de6:	0f a1                	pop    %fs
  popl %es
80106de8:	07                   	pop    %es
  popl %ds
80106de9:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80106dea:	83 c4 08             	add    $0x8,%esp
  iret
80106ded:	cf                   	iret   

80106dee <lidt>:

struct gatedesc;

static inline void
lidt(struct gatedesc *p, int size)
{
80106dee:	55                   	push   %ebp
80106def:	89 e5                	mov    %esp,%ebp
80106df1:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80106df4:	8b 45 0c             	mov    0xc(%ebp),%eax
80106df7:	83 e8 01             	sub    $0x1,%eax
80106dfa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80106dfe:	8b 45 08             	mov    0x8(%ebp),%eax
80106e01:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80106e05:	8b 45 08             	mov    0x8(%ebp),%eax
80106e08:	c1 e8 10             	shr    $0x10,%eax
80106e0b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
80106e0f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80106e12:	0f 01 18             	lidtl  (%eax)
}
80106e15:	c9                   	leave  
80106e16:	c3                   	ret    

80106e17 <rcr2>:
  return result;
}

static inline uint
rcr2(void)
{
80106e17:	55                   	push   %ebp
80106e18:	89 e5                	mov    %esp,%ebp
80106e1a:	83 ec 10             	sub    $0x10,%esp
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80106e1d:	0f 20 d0             	mov    %cr2,%eax
80106e20:	89 45 fc             	mov    %eax,-0x4(%ebp)
  return val;
80106e23:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
80106e26:	c9                   	leave  
80106e27:	c3                   	ret    

80106e28 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80106e28:	55                   	push   %ebp
80106e29:	89 e5                	mov    %esp,%ebp
80106e2b:	83 ec 28             	sub    $0x28,%esp
  int i;

  for(i = 0; i < 256; i++)
80106e2e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80106e35:	e9 c3 00 00 00       	jmp    80106efd <tvinit+0xd5>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80106e3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e3d:	8b 04 85 b4 c0 10 80 	mov    -0x7fef3f4c(,%eax,4),%eax
80106e44:	89 c2                	mov    %eax,%edx
80106e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e49:	66 89 14 c5 00 62 11 	mov    %dx,-0x7fee9e00(,%eax,8)
80106e50:	80 
80106e51:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e54:	66 c7 04 c5 02 62 11 	movw   $0x8,-0x7fee9dfe(,%eax,8)
80106e5b:	80 08 00 
80106e5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e61:	0f b6 14 c5 04 62 11 	movzbl -0x7fee9dfc(,%eax,8),%edx
80106e68:	80 
80106e69:	83 e2 e0             	and    $0xffffffe0,%edx
80106e6c:	88 14 c5 04 62 11 80 	mov    %dl,-0x7fee9dfc(,%eax,8)
80106e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e76:	0f b6 14 c5 04 62 11 	movzbl -0x7fee9dfc(,%eax,8),%edx
80106e7d:	80 
80106e7e:	83 e2 1f             	and    $0x1f,%edx
80106e81:	88 14 c5 04 62 11 80 	mov    %dl,-0x7fee9dfc(,%eax,8)
80106e88:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106e8b:	0f b6 14 c5 05 62 11 	movzbl -0x7fee9dfb(,%eax,8),%edx
80106e92:	80 
80106e93:	83 e2 f0             	and    $0xfffffff0,%edx
80106e96:	83 ca 0e             	or     $0xe,%edx
80106e99:	88 14 c5 05 62 11 80 	mov    %dl,-0x7fee9dfb(,%eax,8)
80106ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ea3:	0f b6 14 c5 05 62 11 	movzbl -0x7fee9dfb(,%eax,8),%edx
80106eaa:	80 
80106eab:	83 e2 ef             	and    $0xffffffef,%edx
80106eae:	88 14 c5 05 62 11 80 	mov    %dl,-0x7fee9dfb(,%eax,8)
80106eb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106eb8:	0f b6 14 c5 05 62 11 	movzbl -0x7fee9dfb(,%eax,8),%edx
80106ebf:	80 
80106ec0:	83 e2 9f             	and    $0xffffff9f,%edx
80106ec3:	88 14 c5 05 62 11 80 	mov    %dl,-0x7fee9dfb(,%eax,8)
80106eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ecd:	0f b6 14 c5 05 62 11 	movzbl -0x7fee9dfb(,%eax,8),%edx
80106ed4:	80 
80106ed5:	83 ca 80             	or     $0xffffff80,%edx
80106ed8:	88 14 c5 05 62 11 80 	mov    %dl,-0x7fee9dfb(,%eax,8)
80106edf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ee2:	8b 04 85 b4 c0 10 80 	mov    -0x7fef3f4c(,%eax,4),%eax
80106ee9:	c1 e8 10             	shr    $0x10,%eax
80106eec:	89 c2                	mov    %eax,%edx
80106eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80106ef1:	66 89 14 c5 06 62 11 	mov    %dx,-0x7fee9dfa(,%eax,8)
80106ef8:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80106ef9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80106efd:	81 7d f4 ff 00 00 00 	cmpl   $0xff,-0xc(%ebp)
80106f04:	0f 8e 30 ff ff ff    	jle    80106e3a <tvinit+0x12>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80106f0a:	a1 b4 c1 10 80       	mov    0x8010c1b4,%eax
80106f0f:	66 a3 00 64 11 80    	mov    %ax,0x80116400
80106f15:	66 c7 05 02 64 11 80 	movw   $0x8,0x80116402
80106f1c:	08 00 
80106f1e:	0f b6 05 04 64 11 80 	movzbl 0x80116404,%eax
80106f25:	83 e0 e0             	and    $0xffffffe0,%eax
80106f28:	a2 04 64 11 80       	mov    %al,0x80116404
80106f2d:	0f b6 05 04 64 11 80 	movzbl 0x80116404,%eax
80106f34:	83 e0 1f             	and    $0x1f,%eax
80106f37:	a2 04 64 11 80       	mov    %al,0x80116404
80106f3c:	0f b6 05 05 64 11 80 	movzbl 0x80116405,%eax
80106f43:	83 c8 0f             	or     $0xf,%eax
80106f46:	a2 05 64 11 80       	mov    %al,0x80116405
80106f4b:	0f b6 05 05 64 11 80 	movzbl 0x80116405,%eax
80106f52:	83 e0 ef             	and    $0xffffffef,%eax
80106f55:	a2 05 64 11 80       	mov    %al,0x80116405
80106f5a:	0f b6 05 05 64 11 80 	movzbl 0x80116405,%eax
80106f61:	83 c8 60             	or     $0x60,%eax
80106f64:	a2 05 64 11 80       	mov    %al,0x80116405
80106f69:	0f b6 05 05 64 11 80 	movzbl 0x80116405,%eax
80106f70:	83 c8 80             	or     $0xffffff80,%eax
80106f73:	a2 05 64 11 80       	mov    %al,0x80116405
80106f78:	a1 b4 c1 10 80       	mov    0x8010c1b4,%eax
80106f7d:	c1 e8 10             	shr    $0x10,%eax
80106f80:	66 a3 06 64 11 80    	mov    %ax,0x80116406
  
  initlock(&tickslock, "time");
80106f86:	c7 44 24 04 d8 91 10 	movl   $0x801091d8,0x4(%esp)
80106f8d:	80 
80106f8e:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80106f95:	e8 33 e5 ff ff       	call   801054cd <initlock>
}
80106f9a:	c9                   	leave  
80106f9b:	c3                   	ret    

80106f9c <idtinit>:

void
idtinit(void)
{
80106f9c:	55                   	push   %ebp
80106f9d:	89 e5                	mov    %esp,%ebp
80106f9f:	83 ec 08             	sub    $0x8,%esp
  lidt(idt, sizeof(idt));
80106fa2:	c7 44 24 04 00 08 00 	movl   $0x800,0x4(%esp)
80106fa9:	00 
80106faa:	c7 04 24 00 62 11 80 	movl   $0x80116200,(%esp)
80106fb1:	e8 38 fe ff ff       	call   80106dee <lidt>
}
80106fb6:	c9                   	leave  
80106fb7:	c3                   	ret    

80106fb8 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80106fb8:	55                   	push   %ebp
80106fb9:	89 e5                	mov    %esp,%ebp
80106fbb:	57                   	push   %edi
80106fbc:	56                   	push   %esi
80106fbd:	53                   	push   %ebx
80106fbe:	83 ec 3c             	sub    $0x3c,%esp
  if(tf->trapno == T_SYSCALL){
80106fc1:	8b 45 08             	mov    0x8(%ebp),%eax
80106fc4:	8b 40 30             	mov    0x30(%eax),%eax
80106fc7:	83 f8 40             	cmp    $0x40,%eax
80106fca:	75 4d                	jne    80107019 <trap+0x61>
    if(proc->killed)
80106fcc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106fd2:	8b 40 24             	mov    0x24(%eax),%eax
80106fd5:	85 c0                	test   %eax,%eax
80106fd7:	74 0c                	je     80106fe5 <trap+0x2d>
      exit(137);
80106fd9:	c7 04 24 89 00 00 00 	movl   $0x89,(%esp)
80106fe0:	e8 56 d8 ff ff       	call   8010483b <exit>
    proc->tf = tf;
80106fe5:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106feb:	8b 55 08             	mov    0x8(%ebp),%edx
80106fee:	89 50 18             	mov    %edx,0x18(%eax)
    syscall();
80106ff1:	e8 5a eb ff ff       	call   80105b50 <syscall>
    if(proc->killed)
80106ff6:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80106ffc:	8b 40 24             	mov    0x24(%eax),%eax
80106fff:	85 c0                	test   %eax,%eax
80107001:	74 11                	je     80107014 <trap+0x5c>
      exit(137);
80107003:	c7 04 24 89 00 00 00 	movl   $0x89,(%esp)
8010700a:	e8 2c d8 ff ff       	call   8010483b <exit>
    return;
8010700f:	e9 39 02 00 00       	jmp    8010724d <trap+0x295>
80107014:	e9 34 02 00 00       	jmp    8010724d <trap+0x295>
  }

  switch(tf->trapno){
80107019:	8b 45 08             	mov    0x8(%ebp),%eax
8010701c:	8b 40 30             	mov    0x30(%eax),%eax
8010701f:	83 e8 20             	sub    $0x20,%eax
80107022:	83 f8 1f             	cmp    $0x1f,%eax
80107025:	0f 87 c1 00 00 00    	ja     801070ec <trap+0x134>
8010702b:	8b 04 85 80 92 10 80 	mov    -0x7fef6d80(,%eax,4),%eax
80107032:	ff e0                	jmp    *%eax
  case T_IRQ0 + IRQ_TIMER:
    if(cpu->id == 0){
80107034:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
8010703a:	0f b6 00             	movzbl (%eax),%eax
8010703d:	84 c0                	test   %al,%al
8010703f:	75 36                	jne    80107077 <trap+0xbf>
      acquire(&tickslock);
80107041:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80107048:	e8 a1 e4 ff ff       	call   801054ee <acquire>
      updateProcessesTimes();
8010704d:	e8 66 e1 ff ff       	call   801051b8 <updateProcessesTimes>
      ticks++;
80107052:	a1 00 6a 11 80       	mov    0x80116a00,%eax
80107057:	83 c0 01             	add    $0x1,%eax
8010705a:	a3 00 6a 11 80       	mov    %eax,0x80116a00
      wakeup(&ticks);
8010705f:	c7 04 24 00 6a 11 80 	movl   $0x80116a00,(%esp)
80107066:	e8 9d df ff ff       	call   80105008 <wakeup>
      release(&tickslock);
8010706b:	c7 04 24 c0 61 11 80 	movl   $0x801161c0,(%esp)
80107072:	e8 de e4 ff ff       	call   80105555 <release>
    }
    lapiceoi();
80107077:	e8 8e be ff ff       	call   80102f0a <lapiceoi>
    break;
8010707c:	e9 41 01 00 00       	jmp    801071c2 <trap+0x20a>
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80107081:	e8 92 b6 ff ff       	call   80102718 <ideintr>
    lapiceoi();
80107086:	e8 7f be ff ff       	call   80102f0a <lapiceoi>
    break;
8010708b:	e9 32 01 00 00       	jmp    801071c2 <trap+0x20a>
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80107090:	e8 44 bc ff ff       	call   80102cd9 <kbdintr>
    lapiceoi();
80107095:	e8 70 be ff ff       	call   80102f0a <lapiceoi>
    break;
8010709a:	e9 23 01 00 00       	jmp    801071c2 <trap+0x20a>
  case T_IRQ0 + IRQ_COM1:
    uartintr();
8010709f:	e8 9e 03 00 00       	call   80107442 <uartintr>
    lapiceoi();
801070a4:	e8 61 be ff ff       	call   80102f0a <lapiceoi>
    break;
801070a9:	e9 14 01 00 00       	jmp    801071c2 <trap+0x20a>
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801070ae:	8b 45 08             	mov    0x8(%ebp),%eax
801070b1:	8b 48 38             	mov    0x38(%eax),%ecx
            cpu->id, tf->cs, tf->eip);
801070b4:	8b 45 08             	mov    0x8(%ebp),%eax
801070b7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801070bb:	0f b7 d0             	movzwl %ax,%edx
            cpu->id, tf->cs, tf->eip);
801070be:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801070c4:	0f b6 00             	movzbl (%eax),%eax
    uartintr();
    lapiceoi();
    break;
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
801070c7:	0f b6 c0             	movzbl %al,%eax
801070ca:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
801070ce:	89 54 24 08          	mov    %edx,0x8(%esp)
801070d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801070d6:	c7 04 24 e0 91 10 80 	movl   $0x801091e0,(%esp)
801070dd:	e8 be 92 ff ff       	call   801003a0 <cprintf>
            cpu->id, tf->cs, tf->eip);
    lapiceoi();
801070e2:	e8 23 be ff ff       	call   80102f0a <lapiceoi>
    break;
801070e7:	e9 d6 00 00 00       	jmp    801071c2 <trap+0x20a>
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
801070ec:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801070f2:	85 c0                	test   %eax,%eax
801070f4:	74 11                	je     80107107 <trap+0x14f>
801070f6:	8b 45 08             	mov    0x8(%ebp),%eax
801070f9:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801070fd:	0f b7 c0             	movzwl %ax,%eax
80107100:	83 e0 03             	and    $0x3,%eax
80107103:	85 c0                	test   %eax,%eax
80107105:	75 46                	jne    8010714d <trap+0x195>
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80107107:	e8 0b fd ff ff       	call   80106e17 <rcr2>
8010710c:	8b 55 08             	mov    0x8(%ebp),%edx
8010710f:	8b 5a 38             	mov    0x38(%edx),%ebx
              tf->trapno, cpu->id, tf->eip, rcr2());
80107112:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80107119:	0f b6 12             	movzbl (%edx),%edx
   
  //PAGEBREAK: 13
  default:
    if(proc == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
8010711c:	0f b6 ca             	movzbl %dl,%ecx
8010711f:	8b 55 08             	mov    0x8(%ebp),%edx
80107122:	8b 52 30             	mov    0x30(%edx),%edx
80107125:	89 44 24 10          	mov    %eax,0x10(%esp)
80107129:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010712d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80107131:	89 54 24 04          	mov    %edx,0x4(%esp)
80107135:	c7 04 24 04 92 10 80 	movl   $0x80109204,(%esp)
8010713c:	e8 5f 92 ff ff       	call   801003a0 <cprintf>
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
80107141:	c7 04 24 36 92 10 80 	movl   $0x80109236,(%esp)
80107148:	e8 ed 93 ff ff       	call   8010053a <panic>
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010714d:	e8 c5 fc ff ff       	call   80106e17 <rcr2>
80107152:	89 c2                	mov    %eax,%edx
80107154:	8b 45 08             	mov    0x8(%ebp),%eax
80107157:	8b 78 38             	mov    0x38(%eax),%edi
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
8010715a:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
80107160:	0f b6 00             	movzbl (%eax),%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107163:	0f b6 f0             	movzbl %al,%esi
80107166:	8b 45 08             	mov    0x8(%ebp),%eax
80107169:	8b 58 34             	mov    0x34(%eax),%ebx
8010716c:	8b 45 08             	mov    0x8(%ebp),%eax
8010716f:	8b 48 30             	mov    0x30(%eax),%ecx
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
80107172:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107178:	83 c0 6c             	add    $0x6c,%eax
8010717b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010717e:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpu->id, tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80107184:	8b 40 10             	mov    0x10(%eax),%eax
80107187:	89 54 24 1c          	mov    %edx,0x1c(%esp)
8010718b:	89 7c 24 18          	mov    %edi,0x18(%esp)
8010718f:	89 74 24 14          	mov    %esi,0x14(%esp)
80107193:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80107197:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
8010719b:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010719e:	89 74 24 08          	mov    %esi,0x8(%esp)
801071a2:	89 44 24 04          	mov    %eax,0x4(%esp)
801071a6:	c7 04 24 3c 92 10 80 	movl   $0x8010923c,(%esp)
801071ad:	e8 ee 91 ff ff       	call   801003a0 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            proc->pid, proc->name, tf->trapno, tf->err, cpu->id, tf->eip, 
            rcr2());
    proc->killed = 1;
801071b2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071b8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801071bf:	eb 01                	jmp    801071c2 <trap+0x20a>
    ideintr();
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
801071c1:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running 
  // until it gets to the regular system call return.)
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
801071c2:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071c8:	85 c0                	test   %eax,%eax
801071ca:	74 2b                	je     801071f7 <trap+0x23f>
801071cc:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
801071d2:	8b 40 24             	mov    0x24(%eax),%eax
801071d5:	85 c0                	test   %eax,%eax
801071d7:	74 1e                	je     801071f7 <trap+0x23f>
801071d9:	8b 45 08             	mov    0x8(%ebp),%eax
801071dc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
801071e0:	0f b7 c0             	movzwl %ax,%eax
801071e3:	83 e0 03             	and    $0x3,%eax
801071e6:	83 f8 03             	cmp    $0x3,%eax
801071e9:	75 0c                	jne    801071f7 <trap+0x23f>
    exit(137);
801071eb:	c7 04 24 89 00 00 00 	movl   $0x89,(%esp)
801071f2:	e8 44 d6 ff ff       	call   8010483b <exit>
    	if(proc && proc->state == RUNNING && tf->trapno == T_IRQ0+IRQ_TIMER)
        	yield();
  }

  // Check if the process has been killed since we yielded
if (ticks%QUANTA==0){
801071f7:	8b 0d 00 6a 11 80    	mov    0x80116a00,%ecx
801071fd:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
80107202:	89 c8                	mov    %ecx,%eax
80107204:	f7 e2                	mul    %edx
80107206:	c1 ea 02             	shr    $0x2,%edx
80107209:	89 d0                	mov    %edx,%eax
8010720b:	c1 e0 02             	shl    $0x2,%eax
8010720e:	01 d0                	add    %edx,%eax
80107210:	29 c1                	sub    %eax,%ecx
80107212:	89 ca                	mov    %ecx,%edx
80107214:	85 d2                	test   %edx,%edx
80107216:	75 35                	jne    8010724d <trap+0x295>
  if(proc && proc->killed && (tf->cs&3) == DPL_USER)
80107218:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
8010721e:	85 c0                	test   %eax,%eax
80107220:	74 2b                	je     8010724d <trap+0x295>
80107222:	65 a1 04 00 00 00    	mov    %gs:0x4,%eax
80107228:	8b 40 24             	mov    0x24(%eax),%eax
8010722b:	85 c0                	test   %eax,%eax
8010722d:	74 1e                	je     8010724d <trap+0x295>
8010722f:	8b 45 08             	mov    0x8(%ebp),%eax
80107232:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
80107236:	0f b7 c0             	movzwl %ax,%eax
80107239:	83 e0 03             	and    $0x3,%eax
8010723c:	83 f8 03             	cmp    $0x3,%eax
8010723f:	75 0c                	jne    8010724d <trap+0x295>
    exit(137);
80107241:	c7 04 24 89 00 00 00 	movl   $0x89,(%esp)
80107248:	e8 ee d5 ff ff       	call   8010483b <exit>
}
}
8010724d:	83 c4 3c             	add    $0x3c,%esp
80107250:	5b                   	pop    %ebx
80107251:	5e                   	pop    %esi
80107252:	5f                   	pop    %edi
80107253:	5d                   	pop    %ebp
80107254:	c3                   	ret    

80107255 <inb>:
// Routines to let C code use special x86 instructions.

static inline uchar
inb(ushort port)
{
80107255:	55                   	push   %ebp
80107256:	89 e5                	mov    %esp,%ebp
80107258:	83 ec 14             	sub    $0x14,%esp
8010725b:	8b 45 08             	mov    0x8(%ebp),%eax
8010725e:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80107262:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
80107266:	89 c2                	mov    %eax,%edx
80107268:	ec                   	in     (%dx),%al
80107269:	88 45 ff             	mov    %al,-0x1(%ebp)
  return data;
8010726c:	0f b6 45 ff          	movzbl -0x1(%ebp),%eax
}
80107270:	c9                   	leave  
80107271:	c3                   	ret    

80107272 <outb>:
               "memory", "cc");
}

static inline void
outb(ushort port, uchar data)
{
80107272:	55                   	push   %ebp
80107273:	89 e5                	mov    %esp,%ebp
80107275:	83 ec 08             	sub    $0x8,%esp
80107278:	8b 55 08             	mov    0x8(%ebp),%edx
8010727b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010727e:	66 89 55 fc          	mov    %dx,-0x4(%ebp)
80107282:	88 45 f8             	mov    %al,-0x8(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80107285:	0f b6 45 f8          	movzbl -0x8(%ebp),%eax
80107289:	0f b7 55 fc          	movzwl -0x4(%ebp),%edx
8010728d:	ee                   	out    %al,(%dx)
}
8010728e:	c9                   	leave  
8010728f:	c3                   	ret    

80107290 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80107290:	55                   	push   %ebp
80107291:	89 e5                	mov    %esp,%ebp
80107293:	83 ec 28             	sub    $0x28,%esp
  char *p;

  // Turn off the FIFO
  outb(COM1+2, 0);
80107296:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010729d:	00 
8010729e:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
801072a5:	e8 c8 ff ff ff       	call   80107272 <outb>
  
  // 9600 baud, 8 data bits, 1 stop bit, parity off.
  outb(COM1+3, 0x80);    // Unlock divisor
801072aa:	c7 44 24 04 80 00 00 	movl   $0x80,0x4(%esp)
801072b1:	00 
801072b2:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801072b9:	e8 b4 ff ff ff       	call   80107272 <outb>
  outb(COM1+0, 115200/9600);
801072be:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
801072c5:	00 
801072c6:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801072cd:	e8 a0 ff ff ff       	call   80107272 <outb>
  outb(COM1+1, 0);
801072d2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801072d9:	00 
801072da:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
801072e1:	e8 8c ff ff ff       	call   80107272 <outb>
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
801072e6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
801072ed:	00 
801072ee:	c7 04 24 fb 03 00 00 	movl   $0x3fb,(%esp)
801072f5:	e8 78 ff ff ff       	call   80107272 <outb>
  outb(COM1+4, 0);
801072fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107301:	00 
80107302:	c7 04 24 fc 03 00 00 	movl   $0x3fc,(%esp)
80107309:	e8 64 ff ff ff       	call   80107272 <outb>
  outb(COM1+1, 0x01);    // Enable receive interrupts.
8010730e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80107315:	00 
80107316:	c7 04 24 f9 03 00 00 	movl   $0x3f9,(%esp)
8010731d:	e8 50 ff ff ff       	call   80107272 <outb>

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80107322:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
80107329:	e8 27 ff ff ff       	call   80107255 <inb>
8010732e:	3c ff                	cmp    $0xff,%al
80107330:	75 02                	jne    80107334 <uartinit+0xa4>
    return;
80107332:	eb 6a                	jmp    8010739e <uartinit+0x10e>
  uart = 1;
80107334:	c7 05 6c c6 10 80 01 	movl   $0x1,0x8010c66c
8010733b:	00 00 00 

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
8010733e:	c7 04 24 fa 03 00 00 	movl   $0x3fa,(%esp)
80107345:	e8 0b ff ff ff       	call   80107255 <inb>
  inb(COM1+0);
8010734a:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107351:	e8 ff fe ff ff       	call   80107255 <inb>
  picenable(IRQ_COM1);
80107356:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
8010735d:	e8 8c ca ff ff       	call   80103dee <picenable>
  ioapicenable(IRQ_COM1, 0);
80107362:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80107369:	00 
8010736a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80107371:	e8 21 b6 ff ff       	call   80102997 <ioapicenable>
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107376:	c7 45 f4 00 93 10 80 	movl   $0x80109300,-0xc(%ebp)
8010737d:	eb 15                	jmp    80107394 <uartinit+0x104>
    uartputc(*p);
8010737f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107382:	0f b6 00             	movzbl (%eax),%eax
80107385:	0f be c0             	movsbl %al,%eax
80107388:	89 04 24             	mov    %eax,(%esp)
8010738b:	e8 10 00 00 00       	call   801073a0 <uartputc>
  inb(COM1+0);
  picenable(IRQ_COM1);
  ioapicenable(IRQ_COM1, 0);
  
  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80107390:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80107394:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107397:	0f b6 00             	movzbl (%eax),%eax
8010739a:	84 c0                	test   %al,%al
8010739c:	75 e1                	jne    8010737f <uartinit+0xef>
    uartputc(*p);
}
8010739e:	c9                   	leave  
8010739f:	c3                   	ret    

801073a0 <uartputc>:

void
uartputc(int c)
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	83 ec 28             	sub    $0x28,%esp
  int i;

  if(!uart)
801073a6:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
801073ab:	85 c0                	test   %eax,%eax
801073ad:	75 02                	jne    801073b1 <uartputc+0x11>
    return;
801073af:	eb 4b                	jmp    801073fc <uartputc+0x5c>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801073b1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801073b8:	eb 10                	jmp    801073ca <uartputc+0x2a>
    microdelay(10);
801073ba:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
801073c1:	e8 69 bb ff ff       	call   80102f2f <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801073c6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
801073ca:	83 7d f4 7f          	cmpl   $0x7f,-0xc(%ebp)
801073ce:	7f 16                	jg     801073e6 <uartputc+0x46>
801073d0:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
801073d7:	e8 79 fe ff ff       	call   80107255 <inb>
801073dc:	0f b6 c0             	movzbl %al,%eax
801073df:	83 e0 20             	and    $0x20,%eax
801073e2:	85 c0                	test   %eax,%eax
801073e4:	74 d4                	je     801073ba <uartputc+0x1a>
    microdelay(10);
  outb(COM1+0, c);
801073e6:	8b 45 08             	mov    0x8(%ebp),%eax
801073e9:	0f b6 c0             	movzbl %al,%eax
801073ec:	89 44 24 04          	mov    %eax,0x4(%esp)
801073f0:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
801073f7:	e8 76 fe ff ff       	call   80107272 <outb>
}
801073fc:	c9                   	leave  
801073fd:	c3                   	ret    

801073fe <uartgetc>:

static int
uartgetc(void)
{
801073fe:	55                   	push   %ebp
801073ff:	89 e5                	mov    %esp,%ebp
80107401:	83 ec 04             	sub    $0x4,%esp
  if(!uart)
80107404:	a1 6c c6 10 80       	mov    0x8010c66c,%eax
80107409:	85 c0                	test   %eax,%eax
8010740b:	75 07                	jne    80107414 <uartgetc+0x16>
    return -1;
8010740d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80107412:	eb 2c                	jmp    80107440 <uartgetc+0x42>
  if(!(inb(COM1+5) & 0x01))
80107414:	c7 04 24 fd 03 00 00 	movl   $0x3fd,(%esp)
8010741b:	e8 35 fe ff ff       	call   80107255 <inb>
80107420:	0f b6 c0             	movzbl %al,%eax
80107423:	83 e0 01             	and    $0x1,%eax
80107426:	85 c0                	test   %eax,%eax
80107428:	75 07                	jne    80107431 <uartgetc+0x33>
    return -1;
8010742a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010742f:	eb 0f                	jmp    80107440 <uartgetc+0x42>
  return inb(COM1+0);
80107431:	c7 04 24 f8 03 00 00 	movl   $0x3f8,(%esp)
80107438:	e8 18 fe ff ff       	call   80107255 <inb>
8010743d:	0f b6 c0             	movzbl %al,%eax
}
80107440:	c9                   	leave  
80107441:	c3                   	ret    

80107442 <uartintr>:

void
uartintr(void)
{
80107442:	55                   	push   %ebp
80107443:	89 e5                	mov    %esp,%ebp
80107445:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80107448:	c7 04 24 fe 73 10 80 	movl   $0x801073fe,(%esp)
8010744f:	e8 59 93 ff ff       	call   801007ad <consoleintr>
}
80107454:	c9                   	leave  
80107455:	c3                   	ret    

80107456 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80107456:	6a 00                	push   $0x0
  pushl $0
80107458:	6a 00                	push   $0x0
  jmp alltraps
8010745a:	e9 64 f9 ff ff       	jmp    80106dc3 <alltraps>

8010745f <vector1>:
.globl vector1
vector1:
  pushl $0
8010745f:	6a 00                	push   $0x0
  pushl $1
80107461:	6a 01                	push   $0x1
  jmp alltraps
80107463:	e9 5b f9 ff ff       	jmp    80106dc3 <alltraps>

80107468 <vector2>:
.globl vector2
vector2:
  pushl $0
80107468:	6a 00                	push   $0x0
  pushl $2
8010746a:	6a 02                	push   $0x2
  jmp alltraps
8010746c:	e9 52 f9 ff ff       	jmp    80106dc3 <alltraps>

80107471 <vector3>:
.globl vector3
vector3:
  pushl $0
80107471:	6a 00                	push   $0x0
  pushl $3
80107473:	6a 03                	push   $0x3
  jmp alltraps
80107475:	e9 49 f9 ff ff       	jmp    80106dc3 <alltraps>

8010747a <vector4>:
.globl vector4
vector4:
  pushl $0
8010747a:	6a 00                	push   $0x0
  pushl $4
8010747c:	6a 04                	push   $0x4
  jmp alltraps
8010747e:	e9 40 f9 ff ff       	jmp    80106dc3 <alltraps>

80107483 <vector5>:
.globl vector5
vector5:
  pushl $0
80107483:	6a 00                	push   $0x0
  pushl $5
80107485:	6a 05                	push   $0x5
  jmp alltraps
80107487:	e9 37 f9 ff ff       	jmp    80106dc3 <alltraps>

8010748c <vector6>:
.globl vector6
vector6:
  pushl $0
8010748c:	6a 00                	push   $0x0
  pushl $6
8010748e:	6a 06                	push   $0x6
  jmp alltraps
80107490:	e9 2e f9 ff ff       	jmp    80106dc3 <alltraps>

80107495 <vector7>:
.globl vector7
vector7:
  pushl $0
80107495:	6a 00                	push   $0x0
  pushl $7
80107497:	6a 07                	push   $0x7
  jmp alltraps
80107499:	e9 25 f9 ff ff       	jmp    80106dc3 <alltraps>

8010749e <vector8>:
.globl vector8
vector8:
  pushl $8
8010749e:	6a 08                	push   $0x8
  jmp alltraps
801074a0:	e9 1e f9 ff ff       	jmp    80106dc3 <alltraps>

801074a5 <vector9>:
.globl vector9
vector9:
  pushl $0
801074a5:	6a 00                	push   $0x0
  pushl $9
801074a7:	6a 09                	push   $0x9
  jmp alltraps
801074a9:	e9 15 f9 ff ff       	jmp    80106dc3 <alltraps>

801074ae <vector10>:
.globl vector10
vector10:
  pushl $10
801074ae:	6a 0a                	push   $0xa
  jmp alltraps
801074b0:	e9 0e f9 ff ff       	jmp    80106dc3 <alltraps>

801074b5 <vector11>:
.globl vector11
vector11:
  pushl $11
801074b5:	6a 0b                	push   $0xb
  jmp alltraps
801074b7:	e9 07 f9 ff ff       	jmp    80106dc3 <alltraps>

801074bc <vector12>:
.globl vector12
vector12:
  pushl $12
801074bc:	6a 0c                	push   $0xc
  jmp alltraps
801074be:	e9 00 f9 ff ff       	jmp    80106dc3 <alltraps>

801074c3 <vector13>:
.globl vector13
vector13:
  pushl $13
801074c3:	6a 0d                	push   $0xd
  jmp alltraps
801074c5:	e9 f9 f8 ff ff       	jmp    80106dc3 <alltraps>

801074ca <vector14>:
.globl vector14
vector14:
  pushl $14
801074ca:	6a 0e                	push   $0xe
  jmp alltraps
801074cc:	e9 f2 f8 ff ff       	jmp    80106dc3 <alltraps>

801074d1 <vector15>:
.globl vector15
vector15:
  pushl $0
801074d1:	6a 00                	push   $0x0
  pushl $15
801074d3:	6a 0f                	push   $0xf
  jmp alltraps
801074d5:	e9 e9 f8 ff ff       	jmp    80106dc3 <alltraps>

801074da <vector16>:
.globl vector16
vector16:
  pushl $0
801074da:	6a 00                	push   $0x0
  pushl $16
801074dc:	6a 10                	push   $0x10
  jmp alltraps
801074de:	e9 e0 f8 ff ff       	jmp    80106dc3 <alltraps>

801074e3 <vector17>:
.globl vector17
vector17:
  pushl $17
801074e3:	6a 11                	push   $0x11
  jmp alltraps
801074e5:	e9 d9 f8 ff ff       	jmp    80106dc3 <alltraps>

801074ea <vector18>:
.globl vector18
vector18:
  pushl $0
801074ea:	6a 00                	push   $0x0
  pushl $18
801074ec:	6a 12                	push   $0x12
  jmp alltraps
801074ee:	e9 d0 f8 ff ff       	jmp    80106dc3 <alltraps>

801074f3 <vector19>:
.globl vector19
vector19:
  pushl $0
801074f3:	6a 00                	push   $0x0
  pushl $19
801074f5:	6a 13                	push   $0x13
  jmp alltraps
801074f7:	e9 c7 f8 ff ff       	jmp    80106dc3 <alltraps>

801074fc <vector20>:
.globl vector20
vector20:
  pushl $0
801074fc:	6a 00                	push   $0x0
  pushl $20
801074fe:	6a 14                	push   $0x14
  jmp alltraps
80107500:	e9 be f8 ff ff       	jmp    80106dc3 <alltraps>

80107505 <vector21>:
.globl vector21
vector21:
  pushl $0
80107505:	6a 00                	push   $0x0
  pushl $21
80107507:	6a 15                	push   $0x15
  jmp alltraps
80107509:	e9 b5 f8 ff ff       	jmp    80106dc3 <alltraps>

8010750e <vector22>:
.globl vector22
vector22:
  pushl $0
8010750e:	6a 00                	push   $0x0
  pushl $22
80107510:	6a 16                	push   $0x16
  jmp alltraps
80107512:	e9 ac f8 ff ff       	jmp    80106dc3 <alltraps>

80107517 <vector23>:
.globl vector23
vector23:
  pushl $0
80107517:	6a 00                	push   $0x0
  pushl $23
80107519:	6a 17                	push   $0x17
  jmp alltraps
8010751b:	e9 a3 f8 ff ff       	jmp    80106dc3 <alltraps>

80107520 <vector24>:
.globl vector24
vector24:
  pushl $0
80107520:	6a 00                	push   $0x0
  pushl $24
80107522:	6a 18                	push   $0x18
  jmp alltraps
80107524:	e9 9a f8 ff ff       	jmp    80106dc3 <alltraps>

80107529 <vector25>:
.globl vector25
vector25:
  pushl $0
80107529:	6a 00                	push   $0x0
  pushl $25
8010752b:	6a 19                	push   $0x19
  jmp alltraps
8010752d:	e9 91 f8 ff ff       	jmp    80106dc3 <alltraps>

80107532 <vector26>:
.globl vector26
vector26:
  pushl $0
80107532:	6a 00                	push   $0x0
  pushl $26
80107534:	6a 1a                	push   $0x1a
  jmp alltraps
80107536:	e9 88 f8 ff ff       	jmp    80106dc3 <alltraps>

8010753b <vector27>:
.globl vector27
vector27:
  pushl $0
8010753b:	6a 00                	push   $0x0
  pushl $27
8010753d:	6a 1b                	push   $0x1b
  jmp alltraps
8010753f:	e9 7f f8 ff ff       	jmp    80106dc3 <alltraps>

80107544 <vector28>:
.globl vector28
vector28:
  pushl $0
80107544:	6a 00                	push   $0x0
  pushl $28
80107546:	6a 1c                	push   $0x1c
  jmp alltraps
80107548:	e9 76 f8 ff ff       	jmp    80106dc3 <alltraps>

8010754d <vector29>:
.globl vector29
vector29:
  pushl $0
8010754d:	6a 00                	push   $0x0
  pushl $29
8010754f:	6a 1d                	push   $0x1d
  jmp alltraps
80107551:	e9 6d f8 ff ff       	jmp    80106dc3 <alltraps>

80107556 <vector30>:
.globl vector30
vector30:
  pushl $0
80107556:	6a 00                	push   $0x0
  pushl $30
80107558:	6a 1e                	push   $0x1e
  jmp alltraps
8010755a:	e9 64 f8 ff ff       	jmp    80106dc3 <alltraps>

8010755f <vector31>:
.globl vector31
vector31:
  pushl $0
8010755f:	6a 00                	push   $0x0
  pushl $31
80107561:	6a 1f                	push   $0x1f
  jmp alltraps
80107563:	e9 5b f8 ff ff       	jmp    80106dc3 <alltraps>

80107568 <vector32>:
.globl vector32
vector32:
  pushl $0
80107568:	6a 00                	push   $0x0
  pushl $32
8010756a:	6a 20                	push   $0x20
  jmp alltraps
8010756c:	e9 52 f8 ff ff       	jmp    80106dc3 <alltraps>

80107571 <vector33>:
.globl vector33
vector33:
  pushl $0
80107571:	6a 00                	push   $0x0
  pushl $33
80107573:	6a 21                	push   $0x21
  jmp alltraps
80107575:	e9 49 f8 ff ff       	jmp    80106dc3 <alltraps>

8010757a <vector34>:
.globl vector34
vector34:
  pushl $0
8010757a:	6a 00                	push   $0x0
  pushl $34
8010757c:	6a 22                	push   $0x22
  jmp alltraps
8010757e:	e9 40 f8 ff ff       	jmp    80106dc3 <alltraps>

80107583 <vector35>:
.globl vector35
vector35:
  pushl $0
80107583:	6a 00                	push   $0x0
  pushl $35
80107585:	6a 23                	push   $0x23
  jmp alltraps
80107587:	e9 37 f8 ff ff       	jmp    80106dc3 <alltraps>

8010758c <vector36>:
.globl vector36
vector36:
  pushl $0
8010758c:	6a 00                	push   $0x0
  pushl $36
8010758e:	6a 24                	push   $0x24
  jmp alltraps
80107590:	e9 2e f8 ff ff       	jmp    80106dc3 <alltraps>

80107595 <vector37>:
.globl vector37
vector37:
  pushl $0
80107595:	6a 00                	push   $0x0
  pushl $37
80107597:	6a 25                	push   $0x25
  jmp alltraps
80107599:	e9 25 f8 ff ff       	jmp    80106dc3 <alltraps>

8010759e <vector38>:
.globl vector38
vector38:
  pushl $0
8010759e:	6a 00                	push   $0x0
  pushl $38
801075a0:	6a 26                	push   $0x26
  jmp alltraps
801075a2:	e9 1c f8 ff ff       	jmp    80106dc3 <alltraps>

801075a7 <vector39>:
.globl vector39
vector39:
  pushl $0
801075a7:	6a 00                	push   $0x0
  pushl $39
801075a9:	6a 27                	push   $0x27
  jmp alltraps
801075ab:	e9 13 f8 ff ff       	jmp    80106dc3 <alltraps>

801075b0 <vector40>:
.globl vector40
vector40:
  pushl $0
801075b0:	6a 00                	push   $0x0
  pushl $40
801075b2:	6a 28                	push   $0x28
  jmp alltraps
801075b4:	e9 0a f8 ff ff       	jmp    80106dc3 <alltraps>

801075b9 <vector41>:
.globl vector41
vector41:
  pushl $0
801075b9:	6a 00                	push   $0x0
  pushl $41
801075bb:	6a 29                	push   $0x29
  jmp alltraps
801075bd:	e9 01 f8 ff ff       	jmp    80106dc3 <alltraps>

801075c2 <vector42>:
.globl vector42
vector42:
  pushl $0
801075c2:	6a 00                	push   $0x0
  pushl $42
801075c4:	6a 2a                	push   $0x2a
  jmp alltraps
801075c6:	e9 f8 f7 ff ff       	jmp    80106dc3 <alltraps>

801075cb <vector43>:
.globl vector43
vector43:
  pushl $0
801075cb:	6a 00                	push   $0x0
  pushl $43
801075cd:	6a 2b                	push   $0x2b
  jmp alltraps
801075cf:	e9 ef f7 ff ff       	jmp    80106dc3 <alltraps>

801075d4 <vector44>:
.globl vector44
vector44:
  pushl $0
801075d4:	6a 00                	push   $0x0
  pushl $44
801075d6:	6a 2c                	push   $0x2c
  jmp alltraps
801075d8:	e9 e6 f7 ff ff       	jmp    80106dc3 <alltraps>

801075dd <vector45>:
.globl vector45
vector45:
  pushl $0
801075dd:	6a 00                	push   $0x0
  pushl $45
801075df:	6a 2d                	push   $0x2d
  jmp alltraps
801075e1:	e9 dd f7 ff ff       	jmp    80106dc3 <alltraps>

801075e6 <vector46>:
.globl vector46
vector46:
  pushl $0
801075e6:	6a 00                	push   $0x0
  pushl $46
801075e8:	6a 2e                	push   $0x2e
  jmp alltraps
801075ea:	e9 d4 f7 ff ff       	jmp    80106dc3 <alltraps>

801075ef <vector47>:
.globl vector47
vector47:
  pushl $0
801075ef:	6a 00                	push   $0x0
  pushl $47
801075f1:	6a 2f                	push   $0x2f
  jmp alltraps
801075f3:	e9 cb f7 ff ff       	jmp    80106dc3 <alltraps>

801075f8 <vector48>:
.globl vector48
vector48:
  pushl $0
801075f8:	6a 00                	push   $0x0
  pushl $48
801075fa:	6a 30                	push   $0x30
  jmp alltraps
801075fc:	e9 c2 f7 ff ff       	jmp    80106dc3 <alltraps>

80107601 <vector49>:
.globl vector49
vector49:
  pushl $0
80107601:	6a 00                	push   $0x0
  pushl $49
80107603:	6a 31                	push   $0x31
  jmp alltraps
80107605:	e9 b9 f7 ff ff       	jmp    80106dc3 <alltraps>

8010760a <vector50>:
.globl vector50
vector50:
  pushl $0
8010760a:	6a 00                	push   $0x0
  pushl $50
8010760c:	6a 32                	push   $0x32
  jmp alltraps
8010760e:	e9 b0 f7 ff ff       	jmp    80106dc3 <alltraps>

80107613 <vector51>:
.globl vector51
vector51:
  pushl $0
80107613:	6a 00                	push   $0x0
  pushl $51
80107615:	6a 33                	push   $0x33
  jmp alltraps
80107617:	e9 a7 f7 ff ff       	jmp    80106dc3 <alltraps>

8010761c <vector52>:
.globl vector52
vector52:
  pushl $0
8010761c:	6a 00                	push   $0x0
  pushl $52
8010761e:	6a 34                	push   $0x34
  jmp alltraps
80107620:	e9 9e f7 ff ff       	jmp    80106dc3 <alltraps>

80107625 <vector53>:
.globl vector53
vector53:
  pushl $0
80107625:	6a 00                	push   $0x0
  pushl $53
80107627:	6a 35                	push   $0x35
  jmp alltraps
80107629:	e9 95 f7 ff ff       	jmp    80106dc3 <alltraps>

8010762e <vector54>:
.globl vector54
vector54:
  pushl $0
8010762e:	6a 00                	push   $0x0
  pushl $54
80107630:	6a 36                	push   $0x36
  jmp alltraps
80107632:	e9 8c f7 ff ff       	jmp    80106dc3 <alltraps>

80107637 <vector55>:
.globl vector55
vector55:
  pushl $0
80107637:	6a 00                	push   $0x0
  pushl $55
80107639:	6a 37                	push   $0x37
  jmp alltraps
8010763b:	e9 83 f7 ff ff       	jmp    80106dc3 <alltraps>

80107640 <vector56>:
.globl vector56
vector56:
  pushl $0
80107640:	6a 00                	push   $0x0
  pushl $56
80107642:	6a 38                	push   $0x38
  jmp alltraps
80107644:	e9 7a f7 ff ff       	jmp    80106dc3 <alltraps>

80107649 <vector57>:
.globl vector57
vector57:
  pushl $0
80107649:	6a 00                	push   $0x0
  pushl $57
8010764b:	6a 39                	push   $0x39
  jmp alltraps
8010764d:	e9 71 f7 ff ff       	jmp    80106dc3 <alltraps>

80107652 <vector58>:
.globl vector58
vector58:
  pushl $0
80107652:	6a 00                	push   $0x0
  pushl $58
80107654:	6a 3a                	push   $0x3a
  jmp alltraps
80107656:	e9 68 f7 ff ff       	jmp    80106dc3 <alltraps>

8010765b <vector59>:
.globl vector59
vector59:
  pushl $0
8010765b:	6a 00                	push   $0x0
  pushl $59
8010765d:	6a 3b                	push   $0x3b
  jmp alltraps
8010765f:	e9 5f f7 ff ff       	jmp    80106dc3 <alltraps>

80107664 <vector60>:
.globl vector60
vector60:
  pushl $0
80107664:	6a 00                	push   $0x0
  pushl $60
80107666:	6a 3c                	push   $0x3c
  jmp alltraps
80107668:	e9 56 f7 ff ff       	jmp    80106dc3 <alltraps>

8010766d <vector61>:
.globl vector61
vector61:
  pushl $0
8010766d:	6a 00                	push   $0x0
  pushl $61
8010766f:	6a 3d                	push   $0x3d
  jmp alltraps
80107671:	e9 4d f7 ff ff       	jmp    80106dc3 <alltraps>

80107676 <vector62>:
.globl vector62
vector62:
  pushl $0
80107676:	6a 00                	push   $0x0
  pushl $62
80107678:	6a 3e                	push   $0x3e
  jmp alltraps
8010767a:	e9 44 f7 ff ff       	jmp    80106dc3 <alltraps>

8010767f <vector63>:
.globl vector63
vector63:
  pushl $0
8010767f:	6a 00                	push   $0x0
  pushl $63
80107681:	6a 3f                	push   $0x3f
  jmp alltraps
80107683:	e9 3b f7 ff ff       	jmp    80106dc3 <alltraps>

80107688 <vector64>:
.globl vector64
vector64:
  pushl $0
80107688:	6a 00                	push   $0x0
  pushl $64
8010768a:	6a 40                	push   $0x40
  jmp alltraps
8010768c:	e9 32 f7 ff ff       	jmp    80106dc3 <alltraps>

80107691 <vector65>:
.globl vector65
vector65:
  pushl $0
80107691:	6a 00                	push   $0x0
  pushl $65
80107693:	6a 41                	push   $0x41
  jmp alltraps
80107695:	e9 29 f7 ff ff       	jmp    80106dc3 <alltraps>

8010769a <vector66>:
.globl vector66
vector66:
  pushl $0
8010769a:	6a 00                	push   $0x0
  pushl $66
8010769c:	6a 42                	push   $0x42
  jmp alltraps
8010769e:	e9 20 f7 ff ff       	jmp    80106dc3 <alltraps>

801076a3 <vector67>:
.globl vector67
vector67:
  pushl $0
801076a3:	6a 00                	push   $0x0
  pushl $67
801076a5:	6a 43                	push   $0x43
  jmp alltraps
801076a7:	e9 17 f7 ff ff       	jmp    80106dc3 <alltraps>

801076ac <vector68>:
.globl vector68
vector68:
  pushl $0
801076ac:	6a 00                	push   $0x0
  pushl $68
801076ae:	6a 44                	push   $0x44
  jmp alltraps
801076b0:	e9 0e f7 ff ff       	jmp    80106dc3 <alltraps>

801076b5 <vector69>:
.globl vector69
vector69:
  pushl $0
801076b5:	6a 00                	push   $0x0
  pushl $69
801076b7:	6a 45                	push   $0x45
  jmp alltraps
801076b9:	e9 05 f7 ff ff       	jmp    80106dc3 <alltraps>

801076be <vector70>:
.globl vector70
vector70:
  pushl $0
801076be:	6a 00                	push   $0x0
  pushl $70
801076c0:	6a 46                	push   $0x46
  jmp alltraps
801076c2:	e9 fc f6 ff ff       	jmp    80106dc3 <alltraps>

801076c7 <vector71>:
.globl vector71
vector71:
  pushl $0
801076c7:	6a 00                	push   $0x0
  pushl $71
801076c9:	6a 47                	push   $0x47
  jmp alltraps
801076cb:	e9 f3 f6 ff ff       	jmp    80106dc3 <alltraps>

801076d0 <vector72>:
.globl vector72
vector72:
  pushl $0
801076d0:	6a 00                	push   $0x0
  pushl $72
801076d2:	6a 48                	push   $0x48
  jmp alltraps
801076d4:	e9 ea f6 ff ff       	jmp    80106dc3 <alltraps>

801076d9 <vector73>:
.globl vector73
vector73:
  pushl $0
801076d9:	6a 00                	push   $0x0
  pushl $73
801076db:	6a 49                	push   $0x49
  jmp alltraps
801076dd:	e9 e1 f6 ff ff       	jmp    80106dc3 <alltraps>

801076e2 <vector74>:
.globl vector74
vector74:
  pushl $0
801076e2:	6a 00                	push   $0x0
  pushl $74
801076e4:	6a 4a                	push   $0x4a
  jmp alltraps
801076e6:	e9 d8 f6 ff ff       	jmp    80106dc3 <alltraps>

801076eb <vector75>:
.globl vector75
vector75:
  pushl $0
801076eb:	6a 00                	push   $0x0
  pushl $75
801076ed:	6a 4b                	push   $0x4b
  jmp alltraps
801076ef:	e9 cf f6 ff ff       	jmp    80106dc3 <alltraps>

801076f4 <vector76>:
.globl vector76
vector76:
  pushl $0
801076f4:	6a 00                	push   $0x0
  pushl $76
801076f6:	6a 4c                	push   $0x4c
  jmp alltraps
801076f8:	e9 c6 f6 ff ff       	jmp    80106dc3 <alltraps>

801076fd <vector77>:
.globl vector77
vector77:
  pushl $0
801076fd:	6a 00                	push   $0x0
  pushl $77
801076ff:	6a 4d                	push   $0x4d
  jmp alltraps
80107701:	e9 bd f6 ff ff       	jmp    80106dc3 <alltraps>

80107706 <vector78>:
.globl vector78
vector78:
  pushl $0
80107706:	6a 00                	push   $0x0
  pushl $78
80107708:	6a 4e                	push   $0x4e
  jmp alltraps
8010770a:	e9 b4 f6 ff ff       	jmp    80106dc3 <alltraps>

8010770f <vector79>:
.globl vector79
vector79:
  pushl $0
8010770f:	6a 00                	push   $0x0
  pushl $79
80107711:	6a 4f                	push   $0x4f
  jmp alltraps
80107713:	e9 ab f6 ff ff       	jmp    80106dc3 <alltraps>

80107718 <vector80>:
.globl vector80
vector80:
  pushl $0
80107718:	6a 00                	push   $0x0
  pushl $80
8010771a:	6a 50                	push   $0x50
  jmp alltraps
8010771c:	e9 a2 f6 ff ff       	jmp    80106dc3 <alltraps>

80107721 <vector81>:
.globl vector81
vector81:
  pushl $0
80107721:	6a 00                	push   $0x0
  pushl $81
80107723:	6a 51                	push   $0x51
  jmp alltraps
80107725:	e9 99 f6 ff ff       	jmp    80106dc3 <alltraps>

8010772a <vector82>:
.globl vector82
vector82:
  pushl $0
8010772a:	6a 00                	push   $0x0
  pushl $82
8010772c:	6a 52                	push   $0x52
  jmp alltraps
8010772e:	e9 90 f6 ff ff       	jmp    80106dc3 <alltraps>

80107733 <vector83>:
.globl vector83
vector83:
  pushl $0
80107733:	6a 00                	push   $0x0
  pushl $83
80107735:	6a 53                	push   $0x53
  jmp alltraps
80107737:	e9 87 f6 ff ff       	jmp    80106dc3 <alltraps>

8010773c <vector84>:
.globl vector84
vector84:
  pushl $0
8010773c:	6a 00                	push   $0x0
  pushl $84
8010773e:	6a 54                	push   $0x54
  jmp alltraps
80107740:	e9 7e f6 ff ff       	jmp    80106dc3 <alltraps>

80107745 <vector85>:
.globl vector85
vector85:
  pushl $0
80107745:	6a 00                	push   $0x0
  pushl $85
80107747:	6a 55                	push   $0x55
  jmp alltraps
80107749:	e9 75 f6 ff ff       	jmp    80106dc3 <alltraps>

8010774e <vector86>:
.globl vector86
vector86:
  pushl $0
8010774e:	6a 00                	push   $0x0
  pushl $86
80107750:	6a 56                	push   $0x56
  jmp alltraps
80107752:	e9 6c f6 ff ff       	jmp    80106dc3 <alltraps>

80107757 <vector87>:
.globl vector87
vector87:
  pushl $0
80107757:	6a 00                	push   $0x0
  pushl $87
80107759:	6a 57                	push   $0x57
  jmp alltraps
8010775b:	e9 63 f6 ff ff       	jmp    80106dc3 <alltraps>

80107760 <vector88>:
.globl vector88
vector88:
  pushl $0
80107760:	6a 00                	push   $0x0
  pushl $88
80107762:	6a 58                	push   $0x58
  jmp alltraps
80107764:	e9 5a f6 ff ff       	jmp    80106dc3 <alltraps>

80107769 <vector89>:
.globl vector89
vector89:
  pushl $0
80107769:	6a 00                	push   $0x0
  pushl $89
8010776b:	6a 59                	push   $0x59
  jmp alltraps
8010776d:	e9 51 f6 ff ff       	jmp    80106dc3 <alltraps>

80107772 <vector90>:
.globl vector90
vector90:
  pushl $0
80107772:	6a 00                	push   $0x0
  pushl $90
80107774:	6a 5a                	push   $0x5a
  jmp alltraps
80107776:	e9 48 f6 ff ff       	jmp    80106dc3 <alltraps>

8010777b <vector91>:
.globl vector91
vector91:
  pushl $0
8010777b:	6a 00                	push   $0x0
  pushl $91
8010777d:	6a 5b                	push   $0x5b
  jmp alltraps
8010777f:	e9 3f f6 ff ff       	jmp    80106dc3 <alltraps>

80107784 <vector92>:
.globl vector92
vector92:
  pushl $0
80107784:	6a 00                	push   $0x0
  pushl $92
80107786:	6a 5c                	push   $0x5c
  jmp alltraps
80107788:	e9 36 f6 ff ff       	jmp    80106dc3 <alltraps>

8010778d <vector93>:
.globl vector93
vector93:
  pushl $0
8010778d:	6a 00                	push   $0x0
  pushl $93
8010778f:	6a 5d                	push   $0x5d
  jmp alltraps
80107791:	e9 2d f6 ff ff       	jmp    80106dc3 <alltraps>

80107796 <vector94>:
.globl vector94
vector94:
  pushl $0
80107796:	6a 00                	push   $0x0
  pushl $94
80107798:	6a 5e                	push   $0x5e
  jmp alltraps
8010779a:	e9 24 f6 ff ff       	jmp    80106dc3 <alltraps>

8010779f <vector95>:
.globl vector95
vector95:
  pushl $0
8010779f:	6a 00                	push   $0x0
  pushl $95
801077a1:	6a 5f                	push   $0x5f
  jmp alltraps
801077a3:	e9 1b f6 ff ff       	jmp    80106dc3 <alltraps>

801077a8 <vector96>:
.globl vector96
vector96:
  pushl $0
801077a8:	6a 00                	push   $0x0
  pushl $96
801077aa:	6a 60                	push   $0x60
  jmp alltraps
801077ac:	e9 12 f6 ff ff       	jmp    80106dc3 <alltraps>

801077b1 <vector97>:
.globl vector97
vector97:
  pushl $0
801077b1:	6a 00                	push   $0x0
  pushl $97
801077b3:	6a 61                	push   $0x61
  jmp alltraps
801077b5:	e9 09 f6 ff ff       	jmp    80106dc3 <alltraps>

801077ba <vector98>:
.globl vector98
vector98:
  pushl $0
801077ba:	6a 00                	push   $0x0
  pushl $98
801077bc:	6a 62                	push   $0x62
  jmp alltraps
801077be:	e9 00 f6 ff ff       	jmp    80106dc3 <alltraps>

801077c3 <vector99>:
.globl vector99
vector99:
  pushl $0
801077c3:	6a 00                	push   $0x0
  pushl $99
801077c5:	6a 63                	push   $0x63
  jmp alltraps
801077c7:	e9 f7 f5 ff ff       	jmp    80106dc3 <alltraps>

801077cc <vector100>:
.globl vector100
vector100:
  pushl $0
801077cc:	6a 00                	push   $0x0
  pushl $100
801077ce:	6a 64                	push   $0x64
  jmp alltraps
801077d0:	e9 ee f5 ff ff       	jmp    80106dc3 <alltraps>

801077d5 <vector101>:
.globl vector101
vector101:
  pushl $0
801077d5:	6a 00                	push   $0x0
  pushl $101
801077d7:	6a 65                	push   $0x65
  jmp alltraps
801077d9:	e9 e5 f5 ff ff       	jmp    80106dc3 <alltraps>

801077de <vector102>:
.globl vector102
vector102:
  pushl $0
801077de:	6a 00                	push   $0x0
  pushl $102
801077e0:	6a 66                	push   $0x66
  jmp alltraps
801077e2:	e9 dc f5 ff ff       	jmp    80106dc3 <alltraps>

801077e7 <vector103>:
.globl vector103
vector103:
  pushl $0
801077e7:	6a 00                	push   $0x0
  pushl $103
801077e9:	6a 67                	push   $0x67
  jmp alltraps
801077eb:	e9 d3 f5 ff ff       	jmp    80106dc3 <alltraps>

801077f0 <vector104>:
.globl vector104
vector104:
  pushl $0
801077f0:	6a 00                	push   $0x0
  pushl $104
801077f2:	6a 68                	push   $0x68
  jmp alltraps
801077f4:	e9 ca f5 ff ff       	jmp    80106dc3 <alltraps>

801077f9 <vector105>:
.globl vector105
vector105:
  pushl $0
801077f9:	6a 00                	push   $0x0
  pushl $105
801077fb:	6a 69                	push   $0x69
  jmp alltraps
801077fd:	e9 c1 f5 ff ff       	jmp    80106dc3 <alltraps>

80107802 <vector106>:
.globl vector106
vector106:
  pushl $0
80107802:	6a 00                	push   $0x0
  pushl $106
80107804:	6a 6a                	push   $0x6a
  jmp alltraps
80107806:	e9 b8 f5 ff ff       	jmp    80106dc3 <alltraps>

8010780b <vector107>:
.globl vector107
vector107:
  pushl $0
8010780b:	6a 00                	push   $0x0
  pushl $107
8010780d:	6a 6b                	push   $0x6b
  jmp alltraps
8010780f:	e9 af f5 ff ff       	jmp    80106dc3 <alltraps>

80107814 <vector108>:
.globl vector108
vector108:
  pushl $0
80107814:	6a 00                	push   $0x0
  pushl $108
80107816:	6a 6c                	push   $0x6c
  jmp alltraps
80107818:	e9 a6 f5 ff ff       	jmp    80106dc3 <alltraps>

8010781d <vector109>:
.globl vector109
vector109:
  pushl $0
8010781d:	6a 00                	push   $0x0
  pushl $109
8010781f:	6a 6d                	push   $0x6d
  jmp alltraps
80107821:	e9 9d f5 ff ff       	jmp    80106dc3 <alltraps>

80107826 <vector110>:
.globl vector110
vector110:
  pushl $0
80107826:	6a 00                	push   $0x0
  pushl $110
80107828:	6a 6e                	push   $0x6e
  jmp alltraps
8010782a:	e9 94 f5 ff ff       	jmp    80106dc3 <alltraps>

8010782f <vector111>:
.globl vector111
vector111:
  pushl $0
8010782f:	6a 00                	push   $0x0
  pushl $111
80107831:	6a 6f                	push   $0x6f
  jmp alltraps
80107833:	e9 8b f5 ff ff       	jmp    80106dc3 <alltraps>

80107838 <vector112>:
.globl vector112
vector112:
  pushl $0
80107838:	6a 00                	push   $0x0
  pushl $112
8010783a:	6a 70                	push   $0x70
  jmp alltraps
8010783c:	e9 82 f5 ff ff       	jmp    80106dc3 <alltraps>

80107841 <vector113>:
.globl vector113
vector113:
  pushl $0
80107841:	6a 00                	push   $0x0
  pushl $113
80107843:	6a 71                	push   $0x71
  jmp alltraps
80107845:	e9 79 f5 ff ff       	jmp    80106dc3 <alltraps>

8010784a <vector114>:
.globl vector114
vector114:
  pushl $0
8010784a:	6a 00                	push   $0x0
  pushl $114
8010784c:	6a 72                	push   $0x72
  jmp alltraps
8010784e:	e9 70 f5 ff ff       	jmp    80106dc3 <alltraps>

80107853 <vector115>:
.globl vector115
vector115:
  pushl $0
80107853:	6a 00                	push   $0x0
  pushl $115
80107855:	6a 73                	push   $0x73
  jmp alltraps
80107857:	e9 67 f5 ff ff       	jmp    80106dc3 <alltraps>

8010785c <vector116>:
.globl vector116
vector116:
  pushl $0
8010785c:	6a 00                	push   $0x0
  pushl $116
8010785e:	6a 74                	push   $0x74
  jmp alltraps
80107860:	e9 5e f5 ff ff       	jmp    80106dc3 <alltraps>

80107865 <vector117>:
.globl vector117
vector117:
  pushl $0
80107865:	6a 00                	push   $0x0
  pushl $117
80107867:	6a 75                	push   $0x75
  jmp alltraps
80107869:	e9 55 f5 ff ff       	jmp    80106dc3 <alltraps>

8010786e <vector118>:
.globl vector118
vector118:
  pushl $0
8010786e:	6a 00                	push   $0x0
  pushl $118
80107870:	6a 76                	push   $0x76
  jmp alltraps
80107872:	e9 4c f5 ff ff       	jmp    80106dc3 <alltraps>

80107877 <vector119>:
.globl vector119
vector119:
  pushl $0
80107877:	6a 00                	push   $0x0
  pushl $119
80107879:	6a 77                	push   $0x77
  jmp alltraps
8010787b:	e9 43 f5 ff ff       	jmp    80106dc3 <alltraps>

80107880 <vector120>:
.globl vector120
vector120:
  pushl $0
80107880:	6a 00                	push   $0x0
  pushl $120
80107882:	6a 78                	push   $0x78
  jmp alltraps
80107884:	e9 3a f5 ff ff       	jmp    80106dc3 <alltraps>

80107889 <vector121>:
.globl vector121
vector121:
  pushl $0
80107889:	6a 00                	push   $0x0
  pushl $121
8010788b:	6a 79                	push   $0x79
  jmp alltraps
8010788d:	e9 31 f5 ff ff       	jmp    80106dc3 <alltraps>

80107892 <vector122>:
.globl vector122
vector122:
  pushl $0
80107892:	6a 00                	push   $0x0
  pushl $122
80107894:	6a 7a                	push   $0x7a
  jmp alltraps
80107896:	e9 28 f5 ff ff       	jmp    80106dc3 <alltraps>

8010789b <vector123>:
.globl vector123
vector123:
  pushl $0
8010789b:	6a 00                	push   $0x0
  pushl $123
8010789d:	6a 7b                	push   $0x7b
  jmp alltraps
8010789f:	e9 1f f5 ff ff       	jmp    80106dc3 <alltraps>

801078a4 <vector124>:
.globl vector124
vector124:
  pushl $0
801078a4:	6a 00                	push   $0x0
  pushl $124
801078a6:	6a 7c                	push   $0x7c
  jmp alltraps
801078a8:	e9 16 f5 ff ff       	jmp    80106dc3 <alltraps>

801078ad <vector125>:
.globl vector125
vector125:
  pushl $0
801078ad:	6a 00                	push   $0x0
  pushl $125
801078af:	6a 7d                	push   $0x7d
  jmp alltraps
801078b1:	e9 0d f5 ff ff       	jmp    80106dc3 <alltraps>

801078b6 <vector126>:
.globl vector126
vector126:
  pushl $0
801078b6:	6a 00                	push   $0x0
  pushl $126
801078b8:	6a 7e                	push   $0x7e
  jmp alltraps
801078ba:	e9 04 f5 ff ff       	jmp    80106dc3 <alltraps>

801078bf <vector127>:
.globl vector127
vector127:
  pushl $0
801078bf:	6a 00                	push   $0x0
  pushl $127
801078c1:	6a 7f                	push   $0x7f
  jmp alltraps
801078c3:	e9 fb f4 ff ff       	jmp    80106dc3 <alltraps>

801078c8 <vector128>:
.globl vector128
vector128:
  pushl $0
801078c8:	6a 00                	push   $0x0
  pushl $128
801078ca:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801078cf:	e9 ef f4 ff ff       	jmp    80106dc3 <alltraps>

801078d4 <vector129>:
.globl vector129
vector129:
  pushl $0
801078d4:	6a 00                	push   $0x0
  pushl $129
801078d6:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801078db:	e9 e3 f4 ff ff       	jmp    80106dc3 <alltraps>

801078e0 <vector130>:
.globl vector130
vector130:
  pushl $0
801078e0:	6a 00                	push   $0x0
  pushl $130
801078e2:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801078e7:	e9 d7 f4 ff ff       	jmp    80106dc3 <alltraps>

801078ec <vector131>:
.globl vector131
vector131:
  pushl $0
801078ec:	6a 00                	push   $0x0
  pushl $131
801078ee:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801078f3:	e9 cb f4 ff ff       	jmp    80106dc3 <alltraps>

801078f8 <vector132>:
.globl vector132
vector132:
  pushl $0
801078f8:	6a 00                	push   $0x0
  pushl $132
801078fa:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801078ff:	e9 bf f4 ff ff       	jmp    80106dc3 <alltraps>

80107904 <vector133>:
.globl vector133
vector133:
  pushl $0
80107904:	6a 00                	push   $0x0
  pushl $133
80107906:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010790b:	e9 b3 f4 ff ff       	jmp    80106dc3 <alltraps>

80107910 <vector134>:
.globl vector134
vector134:
  pushl $0
80107910:	6a 00                	push   $0x0
  pushl $134
80107912:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80107917:	e9 a7 f4 ff ff       	jmp    80106dc3 <alltraps>

8010791c <vector135>:
.globl vector135
vector135:
  pushl $0
8010791c:	6a 00                	push   $0x0
  pushl $135
8010791e:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80107923:	e9 9b f4 ff ff       	jmp    80106dc3 <alltraps>

80107928 <vector136>:
.globl vector136
vector136:
  pushl $0
80107928:	6a 00                	push   $0x0
  pushl $136
8010792a:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010792f:	e9 8f f4 ff ff       	jmp    80106dc3 <alltraps>

80107934 <vector137>:
.globl vector137
vector137:
  pushl $0
80107934:	6a 00                	push   $0x0
  pushl $137
80107936:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010793b:	e9 83 f4 ff ff       	jmp    80106dc3 <alltraps>

80107940 <vector138>:
.globl vector138
vector138:
  pushl $0
80107940:	6a 00                	push   $0x0
  pushl $138
80107942:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80107947:	e9 77 f4 ff ff       	jmp    80106dc3 <alltraps>

8010794c <vector139>:
.globl vector139
vector139:
  pushl $0
8010794c:	6a 00                	push   $0x0
  pushl $139
8010794e:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80107953:	e9 6b f4 ff ff       	jmp    80106dc3 <alltraps>

80107958 <vector140>:
.globl vector140
vector140:
  pushl $0
80107958:	6a 00                	push   $0x0
  pushl $140
8010795a:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010795f:	e9 5f f4 ff ff       	jmp    80106dc3 <alltraps>

80107964 <vector141>:
.globl vector141
vector141:
  pushl $0
80107964:	6a 00                	push   $0x0
  pushl $141
80107966:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010796b:	e9 53 f4 ff ff       	jmp    80106dc3 <alltraps>

80107970 <vector142>:
.globl vector142
vector142:
  pushl $0
80107970:	6a 00                	push   $0x0
  pushl $142
80107972:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80107977:	e9 47 f4 ff ff       	jmp    80106dc3 <alltraps>

8010797c <vector143>:
.globl vector143
vector143:
  pushl $0
8010797c:	6a 00                	push   $0x0
  pushl $143
8010797e:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80107983:	e9 3b f4 ff ff       	jmp    80106dc3 <alltraps>

80107988 <vector144>:
.globl vector144
vector144:
  pushl $0
80107988:	6a 00                	push   $0x0
  pushl $144
8010798a:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010798f:	e9 2f f4 ff ff       	jmp    80106dc3 <alltraps>

80107994 <vector145>:
.globl vector145
vector145:
  pushl $0
80107994:	6a 00                	push   $0x0
  pushl $145
80107996:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010799b:	e9 23 f4 ff ff       	jmp    80106dc3 <alltraps>

801079a0 <vector146>:
.globl vector146
vector146:
  pushl $0
801079a0:	6a 00                	push   $0x0
  pushl $146
801079a2:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801079a7:	e9 17 f4 ff ff       	jmp    80106dc3 <alltraps>

801079ac <vector147>:
.globl vector147
vector147:
  pushl $0
801079ac:	6a 00                	push   $0x0
  pushl $147
801079ae:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801079b3:	e9 0b f4 ff ff       	jmp    80106dc3 <alltraps>

801079b8 <vector148>:
.globl vector148
vector148:
  pushl $0
801079b8:	6a 00                	push   $0x0
  pushl $148
801079ba:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801079bf:	e9 ff f3 ff ff       	jmp    80106dc3 <alltraps>

801079c4 <vector149>:
.globl vector149
vector149:
  pushl $0
801079c4:	6a 00                	push   $0x0
  pushl $149
801079c6:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801079cb:	e9 f3 f3 ff ff       	jmp    80106dc3 <alltraps>

801079d0 <vector150>:
.globl vector150
vector150:
  pushl $0
801079d0:	6a 00                	push   $0x0
  pushl $150
801079d2:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801079d7:	e9 e7 f3 ff ff       	jmp    80106dc3 <alltraps>

801079dc <vector151>:
.globl vector151
vector151:
  pushl $0
801079dc:	6a 00                	push   $0x0
  pushl $151
801079de:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801079e3:	e9 db f3 ff ff       	jmp    80106dc3 <alltraps>

801079e8 <vector152>:
.globl vector152
vector152:
  pushl $0
801079e8:	6a 00                	push   $0x0
  pushl $152
801079ea:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801079ef:	e9 cf f3 ff ff       	jmp    80106dc3 <alltraps>

801079f4 <vector153>:
.globl vector153
vector153:
  pushl $0
801079f4:	6a 00                	push   $0x0
  pushl $153
801079f6:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801079fb:	e9 c3 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a00 <vector154>:
.globl vector154
vector154:
  pushl $0
80107a00:	6a 00                	push   $0x0
  pushl $154
80107a02:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80107a07:	e9 b7 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a0c <vector155>:
.globl vector155
vector155:
  pushl $0
80107a0c:	6a 00                	push   $0x0
  pushl $155
80107a0e:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80107a13:	e9 ab f3 ff ff       	jmp    80106dc3 <alltraps>

80107a18 <vector156>:
.globl vector156
vector156:
  pushl $0
80107a18:	6a 00                	push   $0x0
  pushl $156
80107a1a:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80107a1f:	e9 9f f3 ff ff       	jmp    80106dc3 <alltraps>

80107a24 <vector157>:
.globl vector157
vector157:
  pushl $0
80107a24:	6a 00                	push   $0x0
  pushl $157
80107a26:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80107a2b:	e9 93 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a30 <vector158>:
.globl vector158
vector158:
  pushl $0
80107a30:	6a 00                	push   $0x0
  pushl $158
80107a32:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80107a37:	e9 87 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a3c <vector159>:
.globl vector159
vector159:
  pushl $0
80107a3c:	6a 00                	push   $0x0
  pushl $159
80107a3e:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80107a43:	e9 7b f3 ff ff       	jmp    80106dc3 <alltraps>

80107a48 <vector160>:
.globl vector160
vector160:
  pushl $0
80107a48:	6a 00                	push   $0x0
  pushl $160
80107a4a:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80107a4f:	e9 6f f3 ff ff       	jmp    80106dc3 <alltraps>

80107a54 <vector161>:
.globl vector161
vector161:
  pushl $0
80107a54:	6a 00                	push   $0x0
  pushl $161
80107a56:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80107a5b:	e9 63 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a60 <vector162>:
.globl vector162
vector162:
  pushl $0
80107a60:	6a 00                	push   $0x0
  pushl $162
80107a62:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80107a67:	e9 57 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a6c <vector163>:
.globl vector163
vector163:
  pushl $0
80107a6c:	6a 00                	push   $0x0
  pushl $163
80107a6e:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80107a73:	e9 4b f3 ff ff       	jmp    80106dc3 <alltraps>

80107a78 <vector164>:
.globl vector164
vector164:
  pushl $0
80107a78:	6a 00                	push   $0x0
  pushl $164
80107a7a:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80107a7f:	e9 3f f3 ff ff       	jmp    80106dc3 <alltraps>

80107a84 <vector165>:
.globl vector165
vector165:
  pushl $0
80107a84:	6a 00                	push   $0x0
  pushl $165
80107a86:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80107a8b:	e9 33 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a90 <vector166>:
.globl vector166
vector166:
  pushl $0
80107a90:	6a 00                	push   $0x0
  pushl $166
80107a92:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80107a97:	e9 27 f3 ff ff       	jmp    80106dc3 <alltraps>

80107a9c <vector167>:
.globl vector167
vector167:
  pushl $0
80107a9c:	6a 00                	push   $0x0
  pushl $167
80107a9e:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80107aa3:	e9 1b f3 ff ff       	jmp    80106dc3 <alltraps>

80107aa8 <vector168>:
.globl vector168
vector168:
  pushl $0
80107aa8:	6a 00                	push   $0x0
  pushl $168
80107aaa:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80107aaf:	e9 0f f3 ff ff       	jmp    80106dc3 <alltraps>

80107ab4 <vector169>:
.globl vector169
vector169:
  pushl $0
80107ab4:	6a 00                	push   $0x0
  pushl $169
80107ab6:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80107abb:	e9 03 f3 ff ff       	jmp    80106dc3 <alltraps>

80107ac0 <vector170>:
.globl vector170
vector170:
  pushl $0
80107ac0:	6a 00                	push   $0x0
  pushl $170
80107ac2:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80107ac7:	e9 f7 f2 ff ff       	jmp    80106dc3 <alltraps>

80107acc <vector171>:
.globl vector171
vector171:
  pushl $0
80107acc:	6a 00                	push   $0x0
  pushl $171
80107ace:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80107ad3:	e9 eb f2 ff ff       	jmp    80106dc3 <alltraps>

80107ad8 <vector172>:
.globl vector172
vector172:
  pushl $0
80107ad8:	6a 00                	push   $0x0
  pushl $172
80107ada:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
80107adf:	e9 df f2 ff ff       	jmp    80106dc3 <alltraps>

80107ae4 <vector173>:
.globl vector173
vector173:
  pushl $0
80107ae4:	6a 00                	push   $0x0
  pushl $173
80107ae6:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80107aeb:	e9 d3 f2 ff ff       	jmp    80106dc3 <alltraps>

80107af0 <vector174>:
.globl vector174
vector174:
  pushl $0
80107af0:	6a 00                	push   $0x0
  pushl $174
80107af2:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80107af7:	e9 c7 f2 ff ff       	jmp    80106dc3 <alltraps>

80107afc <vector175>:
.globl vector175
vector175:
  pushl $0
80107afc:	6a 00                	push   $0x0
  pushl $175
80107afe:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80107b03:	e9 bb f2 ff ff       	jmp    80106dc3 <alltraps>

80107b08 <vector176>:
.globl vector176
vector176:
  pushl $0
80107b08:	6a 00                	push   $0x0
  pushl $176
80107b0a:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
80107b0f:	e9 af f2 ff ff       	jmp    80106dc3 <alltraps>

80107b14 <vector177>:
.globl vector177
vector177:
  pushl $0
80107b14:	6a 00                	push   $0x0
  pushl $177
80107b16:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80107b1b:	e9 a3 f2 ff ff       	jmp    80106dc3 <alltraps>

80107b20 <vector178>:
.globl vector178
vector178:
  pushl $0
80107b20:	6a 00                	push   $0x0
  pushl $178
80107b22:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80107b27:	e9 97 f2 ff ff       	jmp    80106dc3 <alltraps>

80107b2c <vector179>:
.globl vector179
vector179:
  pushl $0
80107b2c:	6a 00                	push   $0x0
  pushl $179
80107b2e:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80107b33:	e9 8b f2 ff ff       	jmp    80106dc3 <alltraps>

80107b38 <vector180>:
.globl vector180
vector180:
  pushl $0
80107b38:	6a 00                	push   $0x0
  pushl $180
80107b3a:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80107b3f:	e9 7f f2 ff ff       	jmp    80106dc3 <alltraps>

80107b44 <vector181>:
.globl vector181
vector181:
  pushl $0
80107b44:	6a 00                	push   $0x0
  pushl $181
80107b46:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80107b4b:	e9 73 f2 ff ff       	jmp    80106dc3 <alltraps>

80107b50 <vector182>:
.globl vector182
vector182:
  pushl $0
80107b50:	6a 00                	push   $0x0
  pushl $182
80107b52:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80107b57:	e9 67 f2 ff ff       	jmp    80106dc3 <alltraps>

80107b5c <vector183>:
.globl vector183
vector183:
  pushl $0
80107b5c:	6a 00                	push   $0x0
  pushl $183
80107b5e:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80107b63:	e9 5b f2 ff ff       	jmp    80106dc3 <alltraps>

80107b68 <vector184>:
.globl vector184
vector184:
  pushl $0
80107b68:	6a 00                	push   $0x0
  pushl $184
80107b6a:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80107b6f:	e9 4f f2 ff ff       	jmp    80106dc3 <alltraps>

80107b74 <vector185>:
.globl vector185
vector185:
  pushl $0
80107b74:	6a 00                	push   $0x0
  pushl $185
80107b76:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80107b7b:	e9 43 f2 ff ff       	jmp    80106dc3 <alltraps>

80107b80 <vector186>:
.globl vector186
vector186:
  pushl $0
80107b80:	6a 00                	push   $0x0
  pushl $186
80107b82:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80107b87:	e9 37 f2 ff ff       	jmp    80106dc3 <alltraps>

80107b8c <vector187>:
.globl vector187
vector187:
  pushl $0
80107b8c:	6a 00                	push   $0x0
  pushl $187
80107b8e:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80107b93:	e9 2b f2 ff ff       	jmp    80106dc3 <alltraps>

80107b98 <vector188>:
.globl vector188
vector188:
  pushl $0
80107b98:	6a 00                	push   $0x0
  pushl $188
80107b9a:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80107b9f:	e9 1f f2 ff ff       	jmp    80106dc3 <alltraps>

80107ba4 <vector189>:
.globl vector189
vector189:
  pushl $0
80107ba4:	6a 00                	push   $0x0
  pushl $189
80107ba6:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80107bab:	e9 13 f2 ff ff       	jmp    80106dc3 <alltraps>

80107bb0 <vector190>:
.globl vector190
vector190:
  pushl $0
80107bb0:	6a 00                	push   $0x0
  pushl $190
80107bb2:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80107bb7:	e9 07 f2 ff ff       	jmp    80106dc3 <alltraps>

80107bbc <vector191>:
.globl vector191
vector191:
  pushl $0
80107bbc:	6a 00                	push   $0x0
  pushl $191
80107bbe:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80107bc3:	e9 fb f1 ff ff       	jmp    80106dc3 <alltraps>

80107bc8 <vector192>:
.globl vector192
vector192:
  pushl $0
80107bc8:	6a 00                	push   $0x0
  pushl $192
80107bca:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80107bcf:	e9 ef f1 ff ff       	jmp    80106dc3 <alltraps>

80107bd4 <vector193>:
.globl vector193
vector193:
  pushl $0
80107bd4:	6a 00                	push   $0x0
  pushl $193
80107bd6:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80107bdb:	e9 e3 f1 ff ff       	jmp    80106dc3 <alltraps>

80107be0 <vector194>:
.globl vector194
vector194:
  pushl $0
80107be0:	6a 00                	push   $0x0
  pushl $194
80107be2:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80107be7:	e9 d7 f1 ff ff       	jmp    80106dc3 <alltraps>

80107bec <vector195>:
.globl vector195
vector195:
  pushl $0
80107bec:	6a 00                	push   $0x0
  pushl $195
80107bee:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80107bf3:	e9 cb f1 ff ff       	jmp    80106dc3 <alltraps>

80107bf8 <vector196>:
.globl vector196
vector196:
  pushl $0
80107bf8:	6a 00                	push   $0x0
  pushl $196
80107bfa:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80107bff:	e9 bf f1 ff ff       	jmp    80106dc3 <alltraps>

80107c04 <vector197>:
.globl vector197
vector197:
  pushl $0
80107c04:	6a 00                	push   $0x0
  pushl $197
80107c06:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80107c0b:	e9 b3 f1 ff ff       	jmp    80106dc3 <alltraps>

80107c10 <vector198>:
.globl vector198
vector198:
  pushl $0
80107c10:	6a 00                	push   $0x0
  pushl $198
80107c12:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80107c17:	e9 a7 f1 ff ff       	jmp    80106dc3 <alltraps>

80107c1c <vector199>:
.globl vector199
vector199:
  pushl $0
80107c1c:	6a 00                	push   $0x0
  pushl $199
80107c1e:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80107c23:	e9 9b f1 ff ff       	jmp    80106dc3 <alltraps>

80107c28 <vector200>:
.globl vector200
vector200:
  pushl $0
80107c28:	6a 00                	push   $0x0
  pushl $200
80107c2a:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80107c2f:	e9 8f f1 ff ff       	jmp    80106dc3 <alltraps>

80107c34 <vector201>:
.globl vector201
vector201:
  pushl $0
80107c34:	6a 00                	push   $0x0
  pushl $201
80107c36:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80107c3b:	e9 83 f1 ff ff       	jmp    80106dc3 <alltraps>

80107c40 <vector202>:
.globl vector202
vector202:
  pushl $0
80107c40:	6a 00                	push   $0x0
  pushl $202
80107c42:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80107c47:	e9 77 f1 ff ff       	jmp    80106dc3 <alltraps>

80107c4c <vector203>:
.globl vector203
vector203:
  pushl $0
80107c4c:	6a 00                	push   $0x0
  pushl $203
80107c4e:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80107c53:	e9 6b f1 ff ff       	jmp    80106dc3 <alltraps>

80107c58 <vector204>:
.globl vector204
vector204:
  pushl $0
80107c58:	6a 00                	push   $0x0
  pushl $204
80107c5a:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80107c5f:	e9 5f f1 ff ff       	jmp    80106dc3 <alltraps>

80107c64 <vector205>:
.globl vector205
vector205:
  pushl $0
80107c64:	6a 00                	push   $0x0
  pushl $205
80107c66:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80107c6b:	e9 53 f1 ff ff       	jmp    80106dc3 <alltraps>

80107c70 <vector206>:
.globl vector206
vector206:
  pushl $0
80107c70:	6a 00                	push   $0x0
  pushl $206
80107c72:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80107c77:	e9 47 f1 ff ff       	jmp    80106dc3 <alltraps>

80107c7c <vector207>:
.globl vector207
vector207:
  pushl $0
80107c7c:	6a 00                	push   $0x0
  pushl $207
80107c7e:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80107c83:	e9 3b f1 ff ff       	jmp    80106dc3 <alltraps>

80107c88 <vector208>:
.globl vector208
vector208:
  pushl $0
80107c88:	6a 00                	push   $0x0
  pushl $208
80107c8a:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80107c8f:	e9 2f f1 ff ff       	jmp    80106dc3 <alltraps>

80107c94 <vector209>:
.globl vector209
vector209:
  pushl $0
80107c94:	6a 00                	push   $0x0
  pushl $209
80107c96:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80107c9b:	e9 23 f1 ff ff       	jmp    80106dc3 <alltraps>

80107ca0 <vector210>:
.globl vector210
vector210:
  pushl $0
80107ca0:	6a 00                	push   $0x0
  pushl $210
80107ca2:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80107ca7:	e9 17 f1 ff ff       	jmp    80106dc3 <alltraps>

80107cac <vector211>:
.globl vector211
vector211:
  pushl $0
80107cac:	6a 00                	push   $0x0
  pushl $211
80107cae:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80107cb3:	e9 0b f1 ff ff       	jmp    80106dc3 <alltraps>

80107cb8 <vector212>:
.globl vector212
vector212:
  pushl $0
80107cb8:	6a 00                	push   $0x0
  pushl $212
80107cba:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80107cbf:	e9 ff f0 ff ff       	jmp    80106dc3 <alltraps>

80107cc4 <vector213>:
.globl vector213
vector213:
  pushl $0
80107cc4:	6a 00                	push   $0x0
  pushl $213
80107cc6:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80107ccb:	e9 f3 f0 ff ff       	jmp    80106dc3 <alltraps>

80107cd0 <vector214>:
.globl vector214
vector214:
  pushl $0
80107cd0:	6a 00                	push   $0x0
  pushl $214
80107cd2:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80107cd7:	e9 e7 f0 ff ff       	jmp    80106dc3 <alltraps>

80107cdc <vector215>:
.globl vector215
vector215:
  pushl $0
80107cdc:	6a 00                	push   $0x0
  pushl $215
80107cde:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80107ce3:	e9 db f0 ff ff       	jmp    80106dc3 <alltraps>

80107ce8 <vector216>:
.globl vector216
vector216:
  pushl $0
80107ce8:	6a 00                	push   $0x0
  pushl $216
80107cea:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80107cef:	e9 cf f0 ff ff       	jmp    80106dc3 <alltraps>

80107cf4 <vector217>:
.globl vector217
vector217:
  pushl $0
80107cf4:	6a 00                	push   $0x0
  pushl $217
80107cf6:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80107cfb:	e9 c3 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d00 <vector218>:
.globl vector218
vector218:
  pushl $0
80107d00:	6a 00                	push   $0x0
  pushl $218
80107d02:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80107d07:	e9 b7 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d0c <vector219>:
.globl vector219
vector219:
  pushl $0
80107d0c:	6a 00                	push   $0x0
  pushl $219
80107d0e:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80107d13:	e9 ab f0 ff ff       	jmp    80106dc3 <alltraps>

80107d18 <vector220>:
.globl vector220
vector220:
  pushl $0
80107d18:	6a 00                	push   $0x0
  pushl $220
80107d1a:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80107d1f:	e9 9f f0 ff ff       	jmp    80106dc3 <alltraps>

80107d24 <vector221>:
.globl vector221
vector221:
  pushl $0
80107d24:	6a 00                	push   $0x0
  pushl $221
80107d26:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80107d2b:	e9 93 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d30 <vector222>:
.globl vector222
vector222:
  pushl $0
80107d30:	6a 00                	push   $0x0
  pushl $222
80107d32:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80107d37:	e9 87 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d3c <vector223>:
.globl vector223
vector223:
  pushl $0
80107d3c:	6a 00                	push   $0x0
  pushl $223
80107d3e:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80107d43:	e9 7b f0 ff ff       	jmp    80106dc3 <alltraps>

80107d48 <vector224>:
.globl vector224
vector224:
  pushl $0
80107d48:	6a 00                	push   $0x0
  pushl $224
80107d4a:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80107d4f:	e9 6f f0 ff ff       	jmp    80106dc3 <alltraps>

80107d54 <vector225>:
.globl vector225
vector225:
  pushl $0
80107d54:	6a 00                	push   $0x0
  pushl $225
80107d56:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80107d5b:	e9 63 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d60 <vector226>:
.globl vector226
vector226:
  pushl $0
80107d60:	6a 00                	push   $0x0
  pushl $226
80107d62:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80107d67:	e9 57 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d6c <vector227>:
.globl vector227
vector227:
  pushl $0
80107d6c:	6a 00                	push   $0x0
  pushl $227
80107d6e:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80107d73:	e9 4b f0 ff ff       	jmp    80106dc3 <alltraps>

80107d78 <vector228>:
.globl vector228
vector228:
  pushl $0
80107d78:	6a 00                	push   $0x0
  pushl $228
80107d7a:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80107d7f:	e9 3f f0 ff ff       	jmp    80106dc3 <alltraps>

80107d84 <vector229>:
.globl vector229
vector229:
  pushl $0
80107d84:	6a 00                	push   $0x0
  pushl $229
80107d86:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80107d8b:	e9 33 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d90 <vector230>:
.globl vector230
vector230:
  pushl $0
80107d90:	6a 00                	push   $0x0
  pushl $230
80107d92:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80107d97:	e9 27 f0 ff ff       	jmp    80106dc3 <alltraps>

80107d9c <vector231>:
.globl vector231
vector231:
  pushl $0
80107d9c:	6a 00                	push   $0x0
  pushl $231
80107d9e:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80107da3:	e9 1b f0 ff ff       	jmp    80106dc3 <alltraps>

80107da8 <vector232>:
.globl vector232
vector232:
  pushl $0
80107da8:	6a 00                	push   $0x0
  pushl $232
80107daa:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80107daf:	e9 0f f0 ff ff       	jmp    80106dc3 <alltraps>

80107db4 <vector233>:
.globl vector233
vector233:
  pushl $0
80107db4:	6a 00                	push   $0x0
  pushl $233
80107db6:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80107dbb:	e9 03 f0 ff ff       	jmp    80106dc3 <alltraps>

80107dc0 <vector234>:
.globl vector234
vector234:
  pushl $0
80107dc0:	6a 00                	push   $0x0
  pushl $234
80107dc2:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80107dc7:	e9 f7 ef ff ff       	jmp    80106dc3 <alltraps>

80107dcc <vector235>:
.globl vector235
vector235:
  pushl $0
80107dcc:	6a 00                	push   $0x0
  pushl $235
80107dce:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80107dd3:	e9 eb ef ff ff       	jmp    80106dc3 <alltraps>

80107dd8 <vector236>:
.globl vector236
vector236:
  pushl $0
80107dd8:	6a 00                	push   $0x0
  pushl $236
80107dda:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80107ddf:	e9 df ef ff ff       	jmp    80106dc3 <alltraps>

80107de4 <vector237>:
.globl vector237
vector237:
  pushl $0
80107de4:	6a 00                	push   $0x0
  pushl $237
80107de6:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80107deb:	e9 d3 ef ff ff       	jmp    80106dc3 <alltraps>

80107df0 <vector238>:
.globl vector238
vector238:
  pushl $0
80107df0:	6a 00                	push   $0x0
  pushl $238
80107df2:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80107df7:	e9 c7 ef ff ff       	jmp    80106dc3 <alltraps>

80107dfc <vector239>:
.globl vector239
vector239:
  pushl $0
80107dfc:	6a 00                	push   $0x0
  pushl $239
80107dfe:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80107e03:	e9 bb ef ff ff       	jmp    80106dc3 <alltraps>

80107e08 <vector240>:
.globl vector240
vector240:
  pushl $0
80107e08:	6a 00                	push   $0x0
  pushl $240
80107e0a:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80107e0f:	e9 af ef ff ff       	jmp    80106dc3 <alltraps>

80107e14 <vector241>:
.globl vector241
vector241:
  pushl $0
80107e14:	6a 00                	push   $0x0
  pushl $241
80107e16:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80107e1b:	e9 a3 ef ff ff       	jmp    80106dc3 <alltraps>

80107e20 <vector242>:
.globl vector242
vector242:
  pushl $0
80107e20:	6a 00                	push   $0x0
  pushl $242
80107e22:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80107e27:	e9 97 ef ff ff       	jmp    80106dc3 <alltraps>

80107e2c <vector243>:
.globl vector243
vector243:
  pushl $0
80107e2c:	6a 00                	push   $0x0
  pushl $243
80107e2e:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80107e33:	e9 8b ef ff ff       	jmp    80106dc3 <alltraps>

80107e38 <vector244>:
.globl vector244
vector244:
  pushl $0
80107e38:	6a 00                	push   $0x0
  pushl $244
80107e3a:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80107e3f:	e9 7f ef ff ff       	jmp    80106dc3 <alltraps>

80107e44 <vector245>:
.globl vector245
vector245:
  pushl $0
80107e44:	6a 00                	push   $0x0
  pushl $245
80107e46:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80107e4b:	e9 73 ef ff ff       	jmp    80106dc3 <alltraps>

80107e50 <vector246>:
.globl vector246
vector246:
  pushl $0
80107e50:	6a 00                	push   $0x0
  pushl $246
80107e52:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80107e57:	e9 67 ef ff ff       	jmp    80106dc3 <alltraps>

80107e5c <vector247>:
.globl vector247
vector247:
  pushl $0
80107e5c:	6a 00                	push   $0x0
  pushl $247
80107e5e:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80107e63:	e9 5b ef ff ff       	jmp    80106dc3 <alltraps>

80107e68 <vector248>:
.globl vector248
vector248:
  pushl $0
80107e68:	6a 00                	push   $0x0
  pushl $248
80107e6a:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80107e6f:	e9 4f ef ff ff       	jmp    80106dc3 <alltraps>

80107e74 <vector249>:
.globl vector249
vector249:
  pushl $0
80107e74:	6a 00                	push   $0x0
  pushl $249
80107e76:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80107e7b:	e9 43 ef ff ff       	jmp    80106dc3 <alltraps>

80107e80 <vector250>:
.globl vector250
vector250:
  pushl $0
80107e80:	6a 00                	push   $0x0
  pushl $250
80107e82:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80107e87:	e9 37 ef ff ff       	jmp    80106dc3 <alltraps>

80107e8c <vector251>:
.globl vector251
vector251:
  pushl $0
80107e8c:	6a 00                	push   $0x0
  pushl $251
80107e8e:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80107e93:	e9 2b ef ff ff       	jmp    80106dc3 <alltraps>

80107e98 <vector252>:
.globl vector252
vector252:
  pushl $0
80107e98:	6a 00                	push   $0x0
  pushl $252
80107e9a:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80107e9f:	e9 1f ef ff ff       	jmp    80106dc3 <alltraps>

80107ea4 <vector253>:
.globl vector253
vector253:
  pushl $0
80107ea4:	6a 00                	push   $0x0
  pushl $253
80107ea6:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80107eab:	e9 13 ef ff ff       	jmp    80106dc3 <alltraps>

80107eb0 <vector254>:
.globl vector254
vector254:
  pushl $0
80107eb0:	6a 00                	push   $0x0
  pushl $254
80107eb2:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80107eb7:	e9 07 ef ff ff       	jmp    80106dc3 <alltraps>

80107ebc <vector255>:
.globl vector255
vector255:
  pushl $0
80107ebc:	6a 00                	push   $0x0
  pushl $255
80107ebe:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80107ec3:	e9 fb ee ff ff       	jmp    80106dc3 <alltraps>

80107ec8 <lgdt>:

struct segdesc;

static inline void
lgdt(struct segdesc *p, int size)
{
80107ec8:	55                   	push   %ebp
80107ec9:	89 e5                	mov    %esp,%ebp
80107ecb:	83 ec 10             	sub    $0x10,%esp
  volatile ushort pd[3];

  pd[0] = size-1;
80107ece:	8b 45 0c             	mov    0xc(%ebp),%eax
80107ed1:	83 e8 01             	sub    $0x1,%eax
80107ed4:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80107ed8:	8b 45 08             	mov    0x8(%ebp),%eax
80107edb:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80107edf:	8b 45 08             	mov    0x8(%ebp),%eax
80107ee2:	c1 e8 10             	shr    $0x10,%eax
80107ee5:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80107ee9:	8d 45 fa             	lea    -0x6(%ebp),%eax
80107eec:	0f 01 10             	lgdtl  (%eax)
}
80107eef:	c9                   	leave  
80107ef0:	c3                   	ret    

80107ef1 <ltr>:
  asm volatile("lidt (%0)" : : "r" (pd));
}

static inline void
ltr(ushort sel)
{
80107ef1:	55                   	push   %ebp
80107ef2:	89 e5                	mov    %esp,%ebp
80107ef4:	83 ec 04             	sub    $0x4,%esp
80107ef7:	8b 45 08             	mov    0x8(%ebp),%eax
80107efa:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("ltr %0" : : "r" (sel));
80107efe:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f02:	0f 00 d8             	ltr    %ax
}
80107f05:	c9                   	leave  
80107f06:	c3                   	ret    

80107f07 <loadgs>:
  return eflags;
}

static inline void
loadgs(ushort v)
{
80107f07:	55                   	push   %ebp
80107f08:	89 e5                	mov    %esp,%ebp
80107f0a:	83 ec 04             	sub    $0x4,%esp
80107f0d:	8b 45 08             	mov    0x8(%ebp),%eax
80107f10:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  asm volatile("movw %0, %%gs" : : "r" (v));
80107f14:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
80107f18:	8e e8                	mov    %eax,%gs
}
80107f1a:	c9                   	leave  
80107f1b:	c3                   	ret    

80107f1c <lcr3>:
  return val;
}

static inline void
lcr3(uint val) 
{
80107f1c:	55                   	push   %ebp
80107f1d:	89 e5                	mov    %esp,%ebp
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107f1f:	8b 45 08             	mov    0x8(%ebp),%eax
80107f22:	0f 22 d8             	mov    %eax,%cr3
}
80107f25:	5d                   	pop    %ebp
80107f26:	c3                   	ret    

80107f27 <v2p>:
#define KERNBASE 0x80000000         // First kernel virtual address
#define KERNLINK (KERNBASE+EXTMEM)  // Address where kernel is linked

#ifndef __ASSEMBLER__

static inline uint v2p(void *a) { return ((uint) (a))  - KERNBASE; }
80107f27:	55                   	push   %ebp
80107f28:	89 e5                	mov    %esp,%ebp
80107f2a:	8b 45 08             	mov    0x8(%ebp),%eax
80107f2d:	05 00 00 00 80       	add    $0x80000000,%eax
80107f32:	5d                   	pop    %ebp
80107f33:	c3                   	ret    

80107f34 <p2v>:
static inline void *p2v(uint a) { return (void *) ((a) + KERNBASE); }
80107f34:	55                   	push   %ebp
80107f35:	89 e5                	mov    %esp,%ebp
80107f37:	8b 45 08             	mov    0x8(%ebp),%eax
80107f3a:	05 00 00 00 80       	add    $0x80000000,%eax
80107f3f:	5d                   	pop    %ebp
80107f40:	c3                   	ret    

80107f41 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80107f41:	55                   	push   %ebp
80107f42:	89 e5                	mov    %esp,%ebp
80107f44:	53                   	push   %ebx
80107f45:	83 ec 24             	sub    $0x24,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpunum()];
80107f48:	e8 65 af ff ff       	call   80102eb2 <cpunum>
80107f4d:	69 c0 bc 00 00 00    	imul   $0xbc,%eax,%eax
80107f53:	05 80 33 11 80       	add    $0x80113380,%eax
80107f58:	89 45 f4             	mov    %eax,-0xc(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80107f5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f5e:	66 c7 40 78 ff ff    	movw   $0xffff,0x78(%eax)
80107f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f67:	66 c7 40 7a 00 00    	movw   $0x0,0x7a(%eax)
80107f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f70:	c6 40 7c 00          	movb   $0x0,0x7c(%eax)
80107f74:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f77:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f7b:	83 e2 f0             	and    $0xfffffff0,%edx
80107f7e:	83 ca 0a             	or     $0xa,%edx
80107f81:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f87:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f8b:	83 ca 10             	or     $0x10,%edx
80107f8e:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107f94:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107f98:	83 e2 9f             	and    $0xffffff9f,%edx
80107f9b:	88 50 7d             	mov    %dl,0x7d(%eax)
80107f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fa1:	0f b6 50 7d          	movzbl 0x7d(%eax),%edx
80107fa5:	83 ca 80             	or     $0xffffff80,%edx
80107fa8:	88 50 7d             	mov    %dl,0x7d(%eax)
80107fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fae:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fb2:	83 ca 0f             	or     $0xf,%edx
80107fb5:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fbb:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fbf:	83 e2 ef             	and    $0xffffffef,%edx
80107fc2:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fc8:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fcc:	83 e2 df             	and    $0xffffffdf,%edx
80107fcf:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fd5:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fd9:	83 ca 40             	or     $0x40,%edx
80107fdc:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fe2:	0f b6 50 7e          	movzbl 0x7e(%eax),%edx
80107fe6:	83 ca 80             	or     $0xffffff80,%edx
80107fe9:	88 50 7e             	mov    %dl,0x7e(%eax)
80107fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107fef:	c6 40 7f 00          	movb   $0x0,0x7f(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80107ff3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80107ff6:	66 c7 80 80 00 00 00 	movw   $0xffff,0x80(%eax)
80107ffd:	ff ff 
80107fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108002:	66 c7 80 82 00 00 00 	movw   $0x0,0x82(%eax)
80108009:	00 00 
8010800b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010800e:	c6 80 84 00 00 00 00 	movb   $0x0,0x84(%eax)
80108015:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108018:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010801f:	83 e2 f0             	and    $0xfffffff0,%edx
80108022:	83 ca 02             	or     $0x2,%edx
80108025:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010802b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010802e:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108035:	83 ca 10             	or     $0x10,%edx
80108038:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
8010803e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108041:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
80108048:	83 e2 9f             	and    $0xffffff9f,%edx
8010804b:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108051:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108054:	0f b6 90 85 00 00 00 	movzbl 0x85(%eax),%edx
8010805b:	83 ca 80             	or     $0xffffff80,%edx
8010805e:	88 90 85 00 00 00    	mov    %dl,0x85(%eax)
80108064:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108067:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
8010806e:	83 ca 0f             	or     $0xf,%edx
80108071:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
80108077:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010807a:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108081:	83 e2 ef             	and    $0xffffffef,%edx
80108084:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010808a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010808d:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
80108094:	83 e2 df             	and    $0xffffffdf,%edx
80108097:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
8010809d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080a0:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080a7:	83 ca 40             	or     $0x40,%edx
801080aa:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080b3:	0f b6 90 86 00 00 00 	movzbl 0x86(%eax),%edx
801080ba:	83 ca 80             	or     $0xffffff80,%edx
801080bd:	88 90 86 00 00 00    	mov    %dl,0x86(%eax)
801080c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080c6:	c6 80 87 00 00 00 00 	movb   $0x0,0x87(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801080cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080d0:	66 c7 80 90 00 00 00 	movw   $0xffff,0x90(%eax)
801080d7:	ff ff 
801080d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080dc:	66 c7 80 92 00 00 00 	movw   $0x0,0x92(%eax)
801080e3:	00 00 
801080e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080e8:	c6 80 94 00 00 00 00 	movb   $0x0,0x94(%eax)
801080ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
801080f2:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
801080f9:	83 e2 f0             	and    $0xfffffff0,%edx
801080fc:	83 ca 0a             	or     $0xa,%edx
801080ff:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108105:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108108:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
8010810f:	83 ca 10             	or     $0x10,%edx
80108112:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
80108118:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010811b:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108122:	83 ca 60             	or     $0x60,%edx
80108125:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010812b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010812e:	0f b6 90 95 00 00 00 	movzbl 0x95(%eax),%edx
80108135:	83 ca 80             	or     $0xffffff80,%edx
80108138:	88 90 95 00 00 00    	mov    %dl,0x95(%eax)
8010813e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108141:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108148:	83 ca 0f             	or     $0xf,%edx
8010814b:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108151:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108154:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010815b:	83 e2 ef             	and    $0xffffffef,%edx
8010815e:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108164:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108167:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
8010816e:	83 e2 df             	and    $0xffffffdf,%edx
80108171:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
80108177:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010817a:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108181:	83 ca 40             	or     $0x40,%edx
80108184:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010818a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010818d:	0f b6 90 96 00 00 00 	movzbl 0x96(%eax),%edx
80108194:	83 ca 80             	or     $0xffffff80,%edx
80108197:	88 90 96 00 00 00    	mov    %dl,0x96(%eax)
8010819d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081a0:	c6 80 97 00 00 00 00 	movb   $0x0,0x97(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801081a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081aa:	66 c7 80 98 00 00 00 	movw   $0xffff,0x98(%eax)
801081b1:	ff ff 
801081b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081b6:	66 c7 80 9a 00 00 00 	movw   $0x0,0x9a(%eax)
801081bd:	00 00 
801081bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081c2:	c6 80 9c 00 00 00 00 	movb   $0x0,0x9c(%eax)
801081c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081cc:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081d3:	83 e2 f0             	and    $0xfffffff0,%edx
801081d6:	83 ca 02             	or     $0x2,%edx
801081d9:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081df:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081e2:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081e9:	83 ca 10             	or     $0x10,%edx
801081ec:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
801081f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801081f5:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
801081fc:	83 ca 60             	or     $0x60,%edx
801081ff:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108205:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108208:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010820f:	83 ca 80             	or     $0xffffff80,%edx
80108212:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
80108218:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010821b:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108222:	83 ca 0f             	or     $0xf,%edx
80108225:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010822b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010822e:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108235:	83 e2 ef             	and    $0xffffffef,%edx
80108238:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
8010823e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108241:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
80108248:	83 e2 df             	and    $0xffffffdf,%edx
8010824b:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108251:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108254:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010825b:	83 ca 40             	or     $0x40,%edx
8010825e:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108264:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108267:	0f b6 90 9e 00 00 00 	movzbl 0x9e(%eax),%edx
8010826e:	83 ca 80             	or     $0xffffff80,%edx
80108271:	88 90 9e 00 00 00    	mov    %dl,0x9e(%eax)
80108277:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010827a:	c6 80 9f 00 00 00 00 	movb   $0x0,0x9f(%eax)

  // Map cpu, and curproc
  c->gdt[SEG_KCPU] = SEG(STA_W, &c->cpu, 8, 0);
80108281:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108284:	05 b4 00 00 00       	add    $0xb4,%eax
80108289:	89 c3                	mov    %eax,%ebx
8010828b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010828e:	05 b4 00 00 00       	add    $0xb4,%eax
80108293:	c1 e8 10             	shr    $0x10,%eax
80108296:	89 c1                	mov    %eax,%ecx
80108298:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010829b:	05 b4 00 00 00       	add    $0xb4,%eax
801082a0:	c1 e8 18             	shr    $0x18,%eax
801082a3:	89 c2                	mov    %eax,%edx
801082a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082a8:	66 c7 80 88 00 00 00 	movw   $0x0,0x88(%eax)
801082af:	00 00 
801082b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082b4:	66 89 98 8a 00 00 00 	mov    %bx,0x8a(%eax)
801082bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082be:	88 88 8c 00 00 00    	mov    %cl,0x8c(%eax)
801082c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082c7:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082ce:	83 e1 f0             	and    $0xfffffff0,%ecx
801082d1:	83 c9 02             	or     $0x2,%ecx
801082d4:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082da:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082dd:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082e4:	83 c9 10             	or     $0x10,%ecx
801082e7:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
801082ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
801082f0:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
801082f7:	83 e1 9f             	and    $0xffffff9f,%ecx
801082fa:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108300:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108303:	0f b6 88 8d 00 00 00 	movzbl 0x8d(%eax),%ecx
8010830a:	83 c9 80             	or     $0xffffff80,%ecx
8010830d:	88 88 8d 00 00 00    	mov    %cl,0x8d(%eax)
80108313:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108316:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
8010831d:	83 e1 f0             	and    $0xfffffff0,%ecx
80108320:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108326:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108329:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108330:	83 e1 ef             	and    $0xffffffef,%ecx
80108333:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108339:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010833c:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108343:	83 e1 df             	and    $0xffffffdf,%ecx
80108346:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010834c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010834f:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108356:	83 c9 40             	or     $0x40,%ecx
80108359:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
8010835f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108362:	0f b6 88 8e 00 00 00 	movzbl 0x8e(%eax),%ecx
80108369:	83 c9 80             	or     $0xffffff80,%ecx
8010836c:	88 88 8e 00 00 00    	mov    %cl,0x8e(%eax)
80108372:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108375:	88 90 8f 00 00 00    	mov    %dl,0x8f(%eax)

  lgdt(c->gdt, sizeof(c->gdt));
8010837b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010837e:	83 c0 70             	add    $0x70,%eax
80108381:	c7 44 24 04 38 00 00 	movl   $0x38,0x4(%esp)
80108388:	00 
80108389:	89 04 24             	mov    %eax,(%esp)
8010838c:	e8 37 fb ff ff       	call   80107ec8 <lgdt>
  loadgs(SEG_KCPU << 3);
80108391:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
80108398:	e8 6a fb ff ff       	call   80107f07 <loadgs>
  
  // Initialize cpu-local storage.
  cpu = c;
8010839d:	8b 45 f4             	mov    -0xc(%ebp),%eax
801083a0:	65 a3 00 00 00 00    	mov    %eax,%gs:0x0
  proc = 0;
801083a6:	65 c7 05 04 00 00 00 	movl   $0x0,%gs:0x4
801083ad:	00 00 00 00 
}
801083b1:	83 c4 24             	add    $0x24,%esp
801083b4:	5b                   	pop    %ebx
801083b5:	5d                   	pop    %ebp
801083b6:	c3                   	ret    

801083b7 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801083b7:	55                   	push   %ebp
801083b8:	89 e5                	mov    %esp,%ebp
801083ba:	83 ec 28             	sub    $0x28,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801083bd:	8b 45 0c             	mov    0xc(%ebp),%eax
801083c0:	c1 e8 16             	shr    $0x16,%eax
801083c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
801083ca:	8b 45 08             	mov    0x8(%ebp),%eax
801083cd:	01 d0                	add    %edx,%eax
801083cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  if(*pde & PTE_P){
801083d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083d5:	8b 00                	mov    (%eax),%eax
801083d7:	83 e0 01             	and    $0x1,%eax
801083da:	85 c0                	test   %eax,%eax
801083dc:	74 17                	je     801083f5 <walkpgdir+0x3e>
    pgtab = (pte_t*)p2v(PTE_ADDR(*pde));
801083de:	8b 45 f0             	mov    -0x10(%ebp),%eax
801083e1:	8b 00                	mov    (%eax),%eax
801083e3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801083e8:	89 04 24             	mov    %eax,(%esp)
801083eb:	e8 44 fb ff ff       	call   80107f34 <p2v>
801083f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
801083f3:	eb 4b                	jmp    80108440 <walkpgdir+0x89>
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
801083f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801083f9:	74 0e                	je     80108409 <walkpgdir+0x52>
801083fb:	e8 1c a7 ff ff       	call   80102b1c <kalloc>
80108400:	89 45 f4             	mov    %eax,-0xc(%ebp)
80108403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108407:	75 07                	jne    80108410 <walkpgdir+0x59>
      return 0;
80108409:	b8 00 00 00 00       	mov    $0x0,%eax
8010840e:	eb 47                	jmp    80108457 <walkpgdir+0xa0>
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
80108410:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108417:	00 
80108418:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010841f:	00 
80108420:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108423:	89 04 24             	mov    %eax,(%esp)
80108426:	e8 1c d3 ff ff       	call   80105747 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table 
    // entries, if necessary.
    *pde = v2p(pgtab) | PTE_P | PTE_W | PTE_U;
8010842b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010842e:	89 04 24             	mov    %eax,(%esp)
80108431:	e8 f1 fa ff ff       	call   80107f27 <v2p>
80108436:	83 c8 07             	or     $0x7,%eax
80108439:	89 c2                	mov    %eax,%edx
8010843b:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010843e:	89 10                	mov    %edx,(%eax)
  }
  return &pgtab[PTX(va)];
80108440:	8b 45 0c             	mov    0xc(%ebp),%eax
80108443:	c1 e8 0c             	shr    $0xc,%eax
80108446:	25 ff 03 00 00       	and    $0x3ff,%eax
8010844b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108452:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108455:	01 d0                	add    %edx,%eax
}
80108457:	c9                   	leave  
80108458:	c3                   	ret    

80108459 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80108459:	55                   	push   %ebp
8010845a:	89 e5                	mov    %esp,%ebp
8010845c:	83 ec 28             	sub    $0x28,%esp
  char *a, *last;
  pte_t *pte;
  
  a = (char*)PGROUNDDOWN((uint)va);
8010845f:	8b 45 0c             	mov    0xc(%ebp),%eax
80108462:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108467:	89 45 f4             	mov    %eax,-0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
8010846a:	8b 55 0c             	mov    0xc(%ebp),%edx
8010846d:	8b 45 10             	mov    0x10(%ebp),%eax
80108470:	01 d0                	add    %edx,%eax
80108472:	83 e8 01             	sub    $0x1,%eax
80108475:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010847a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
8010847d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
80108484:	00 
80108485:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108488:	89 44 24 04          	mov    %eax,0x4(%esp)
8010848c:	8b 45 08             	mov    0x8(%ebp),%eax
8010848f:	89 04 24             	mov    %eax,(%esp)
80108492:	e8 20 ff ff ff       	call   801083b7 <walkpgdir>
80108497:	89 45 ec             	mov    %eax,-0x14(%ebp)
8010849a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
8010849e:	75 07                	jne    801084a7 <mappages+0x4e>
      return -1;
801084a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801084a5:	eb 48                	jmp    801084ef <mappages+0x96>
    if(*pte & PTE_P)
801084a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084aa:	8b 00                	mov    (%eax),%eax
801084ac:	83 e0 01             	and    $0x1,%eax
801084af:	85 c0                	test   %eax,%eax
801084b1:	74 0c                	je     801084bf <mappages+0x66>
      panic("remap");
801084b3:	c7 04 24 08 93 10 80 	movl   $0x80109308,(%esp)
801084ba:	e8 7b 80 ff ff       	call   8010053a <panic>
    *pte = pa | perm | PTE_P;
801084bf:	8b 45 18             	mov    0x18(%ebp),%eax
801084c2:	0b 45 14             	or     0x14(%ebp),%eax
801084c5:	83 c8 01             	or     $0x1,%eax
801084c8:	89 c2                	mov    %eax,%edx
801084ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
801084cd:	89 10                	mov    %edx,(%eax)
    if(a == last)
801084cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
801084d2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
801084d5:	75 08                	jne    801084df <mappages+0x86>
      break;
801084d7:	90                   	nop
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801084d8:	b8 00 00 00 00       	mov    $0x0,%eax
801084dd:	eb 10                	jmp    801084ef <mappages+0x96>
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
    if(a == last)
      break;
    a += PGSIZE;
801084df:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
    pa += PGSIZE;
801084e6:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  }
801084ed:	eb 8e                	jmp    8010847d <mappages+0x24>
  return 0;
}
801084ef:	c9                   	leave  
801084f0:	c3                   	ret    

801084f1 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
801084f1:	55                   	push   %ebp
801084f2:	89 e5                	mov    %esp,%ebp
801084f4:	53                   	push   %ebx
801084f5:	83 ec 34             	sub    $0x34,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
801084f8:	e8 1f a6 ff ff       	call   80102b1c <kalloc>
801084fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108500:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108504:	75 0a                	jne    80108510 <setupkvm+0x1f>
    return 0;
80108506:	b8 00 00 00 00       	mov    $0x0,%eax
8010850b:	e9 98 00 00 00       	jmp    801085a8 <setupkvm+0xb7>
  memset(pgdir, 0, PGSIZE);
80108510:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108517:	00 
80108518:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010851f:	00 
80108520:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108523:	89 04 24             	mov    %eax,(%esp)
80108526:	e8 1c d2 ff ff       	call   80105747 <memset>
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
8010852b:	c7 04 24 00 00 00 0e 	movl   $0xe000000,(%esp)
80108532:	e8 fd f9 ff ff       	call   80107f34 <p2v>
80108537:	3d 00 00 00 fe       	cmp    $0xfe000000,%eax
8010853c:	76 0c                	jbe    8010854a <setupkvm+0x59>
    panic("PHYSTOP too high");
8010853e:	c7 04 24 0e 93 10 80 	movl   $0x8010930e,(%esp)
80108545:	e8 f0 7f ff ff       	call   8010053a <panic>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010854a:	c7 45 f4 c0 c4 10 80 	movl   $0x8010c4c0,-0xc(%ebp)
80108551:	eb 49                	jmp    8010859c <setupkvm+0xab>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
80108553:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108556:	8b 48 0c             	mov    0xc(%eax),%ecx
80108559:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010855c:	8b 50 04             	mov    0x4(%eax),%edx
8010855f:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108562:	8b 58 08             	mov    0x8(%eax),%ebx
80108565:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108568:	8b 40 04             	mov    0x4(%eax),%eax
8010856b:	29 c3                	sub    %eax,%ebx
8010856d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108570:	8b 00                	mov    (%eax),%eax
80108572:	89 4c 24 10          	mov    %ecx,0x10(%esp)
80108576:	89 54 24 0c          	mov    %edx,0xc(%esp)
8010857a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
8010857e:	89 44 24 04          	mov    %eax,0x4(%esp)
80108582:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108585:	89 04 24             	mov    %eax,(%esp)
80108588:	e8 cc fe ff ff       	call   80108459 <mappages>
8010858d:	85 c0                	test   %eax,%eax
8010858f:	79 07                	jns    80108598 <setupkvm+0xa7>
                (uint)k->phys_start, k->perm) < 0)
      return 0;
80108591:	b8 00 00 00 00       	mov    $0x0,%eax
80108596:	eb 10                	jmp    801085a8 <setupkvm+0xb7>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (p2v(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80108598:	83 45 f4 10          	addl   $0x10,-0xc(%ebp)
8010859c:	81 7d f4 00 c5 10 80 	cmpl   $0x8010c500,-0xc(%ebp)
801085a3:	72 ae                	jb     80108553 <setupkvm+0x62>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start, 
                (uint)k->phys_start, k->perm) < 0)
      return 0;
  return pgdir;
801085a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
801085a8:	83 c4 34             	add    $0x34,%esp
801085ab:	5b                   	pop    %ebx
801085ac:	5d                   	pop    %ebp
801085ad:	c3                   	ret    

801085ae <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
801085ae:	55                   	push   %ebp
801085af:	89 e5                	mov    %esp,%ebp
801085b1:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801085b4:	e8 38 ff ff ff       	call   801084f1 <setupkvm>
801085b9:	a3 58 6a 11 80       	mov    %eax,0x80116a58
  switchkvm();
801085be:	e8 02 00 00 00       	call   801085c5 <switchkvm>
}
801085c3:	c9                   	leave  
801085c4:	c3                   	ret    

801085c5 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801085c5:	55                   	push   %ebp
801085c6:	89 e5                	mov    %esp,%ebp
801085c8:	83 ec 04             	sub    $0x4,%esp
  lcr3(v2p(kpgdir));   // switch to the kernel page table
801085cb:	a1 58 6a 11 80       	mov    0x80116a58,%eax
801085d0:	89 04 24             	mov    %eax,(%esp)
801085d3:	e8 4f f9 ff ff       	call   80107f27 <v2p>
801085d8:	89 04 24             	mov    %eax,(%esp)
801085db:	e8 3c f9 ff ff       	call   80107f1c <lcr3>
}
801085e0:	c9                   	leave  
801085e1:	c3                   	ret    

801085e2 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801085e2:	55                   	push   %ebp
801085e3:	89 e5                	mov    %esp,%ebp
801085e5:	53                   	push   %ebx
801085e6:	83 ec 14             	sub    $0x14,%esp
  pushcli();
801085e9:	e8 59 d0 ff ff       	call   80105647 <pushcli>
  cpu->gdt[SEG_TSS] = SEG16(STS_T32A, &cpu->ts, sizeof(cpu->ts)-1, 0);
801085ee:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801085f4:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
801085fb:	83 c2 08             	add    $0x8,%edx
801085fe:	89 d3                	mov    %edx,%ebx
80108600:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108607:	83 c2 08             	add    $0x8,%edx
8010860a:	c1 ea 10             	shr    $0x10,%edx
8010860d:	89 d1                	mov    %edx,%ecx
8010860f:	65 8b 15 00 00 00 00 	mov    %gs:0x0,%edx
80108616:	83 c2 08             	add    $0x8,%edx
80108619:	c1 ea 18             	shr    $0x18,%edx
8010861c:	66 c7 80 a0 00 00 00 	movw   $0x67,0xa0(%eax)
80108623:	67 00 
80108625:	66 89 98 a2 00 00 00 	mov    %bx,0xa2(%eax)
8010862c:	88 88 a4 00 00 00    	mov    %cl,0xa4(%eax)
80108632:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
80108639:	83 e1 f0             	and    $0xfffffff0,%ecx
8010863c:	83 c9 09             	or     $0x9,%ecx
8010863f:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108645:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010864c:	83 c9 10             	or     $0x10,%ecx
8010864f:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108655:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010865c:	83 e1 9f             	and    $0xffffff9f,%ecx
8010865f:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108665:	0f b6 88 a5 00 00 00 	movzbl 0xa5(%eax),%ecx
8010866c:	83 c9 80             	or     $0xffffff80,%ecx
8010866f:	88 88 a5 00 00 00    	mov    %cl,0xa5(%eax)
80108675:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010867c:	83 e1 f0             	and    $0xfffffff0,%ecx
8010867f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108685:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010868c:	83 e1 ef             	and    $0xffffffef,%ecx
8010868f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
80108695:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
8010869c:	83 e1 df             	and    $0xffffffdf,%ecx
8010869f:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801086a5:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801086ac:	83 c9 40             	or     $0x40,%ecx
801086af:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801086b5:	0f b6 88 a6 00 00 00 	movzbl 0xa6(%eax),%ecx
801086bc:	83 e1 7f             	and    $0x7f,%ecx
801086bf:	88 88 a6 00 00 00    	mov    %cl,0xa6(%eax)
801086c5:	88 90 a7 00 00 00    	mov    %dl,0xa7(%eax)
  cpu->gdt[SEG_TSS].s = 0;
801086cb:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086d1:	0f b6 90 a5 00 00 00 	movzbl 0xa5(%eax),%edx
801086d8:	83 e2 ef             	and    $0xffffffef,%edx
801086db:	88 90 a5 00 00 00    	mov    %dl,0xa5(%eax)
  cpu->ts.ss0 = SEG_KDATA << 3;
801086e1:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086e7:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  cpu->ts.esp0 = (uint)proc->kstack + KSTACKSIZE;
801086ed:	65 a1 00 00 00 00    	mov    %gs:0x0,%eax
801086f3:	65 8b 15 04 00 00 00 	mov    %gs:0x4,%edx
801086fa:	8b 52 08             	mov    0x8(%edx),%edx
801086fd:	81 c2 00 10 00 00    	add    $0x1000,%edx
80108703:	89 50 0c             	mov    %edx,0xc(%eax)
  ltr(SEG_TSS << 3);
80108706:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
8010870d:	e8 df f7 ff ff       	call   80107ef1 <ltr>
  if(p->pgdir == 0)
80108712:	8b 45 08             	mov    0x8(%ebp),%eax
80108715:	8b 40 04             	mov    0x4(%eax),%eax
80108718:	85 c0                	test   %eax,%eax
8010871a:	75 0c                	jne    80108728 <switchuvm+0x146>
    panic("switchuvm: no pgdir");
8010871c:	c7 04 24 1f 93 10 80 	movl   $0x8010931f,(%esp)
80108723:	e8 12 7e ff ff       	call   8010053a <panic>
  lcr3(v2p(p->pgdir));  // switch to new address space
80108728:	8b 45 08             	mov    0x8(%ebp),%eax
8010872b:	8b 40 04             	mov    0x4(%eax),%eax
8010872e:	89 04 24             	mov    %eax,(%esp)
80108731:	e8 f1 f7 ff ff       	call   80107f27 <v2p>
80108736:	89 04 24             	mov    %eax,(%esp)
80108739:	e8 de f7 ff ff       	call   80107f1c <lcr3>
  popcli();
8010873e:	e8 48 cf ff ff       	call   8010568b <popcli>
}
80108743:	83 c4 14             	add    $0x14,%esp
80108746:	5b                   	pop    %ebx
80108747:	5d                   	pop    %ebp
80108748:	c3                   	ret    

80108749 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80108749:	55                   	push   %ebp
8010874a:	89 e5                	mov    %esp,%ebp
8010874c:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  
  if(sz >= PGSIZE)
8010874f:	81 7d 10 ff 0f 00 00 	cmpl   $0xfff,0x10(%ebp)
80108756:	76 0c                	jbe    80108764 <inituvm+0x1b>
    panic("inituvm: more than a page");
80108758:	c7 04 24 33 93 10 80 	movl   $0x80109333,(%esp)
8010875f:	e8 d6 7d ff ff       	call   8010053a <panic>
  mem = kalloc();
80108764:	e8 b3 a3 ff ff       	call   80102b1c <kalloc>
80108769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  memset(mem, 0, PGSIZE);
8010876c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108773:	00 
80108774:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010877b:	00 
8010877c:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010877f:	89 04 24             	mov    %eax,(%esp)
80108782:	e8 c0 cf ff ff       	call   80105747 <memset>
  mappages(pgdir, 0, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108787:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010878a:	89 04 24             	mov    %eax,(%esp)
8010878d:	e8 95 f7 ff ff       	call   80107f27 <v2p>
80108792:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108799:	00 
8010879a:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010879e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801087a5:	00 
801087a6:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801087ad:	00 
801087ae:	8b 45 08             	mov    0x8(%ebp),%eax
801087b1:	89 04 24             	mov    %eax,(%esp)
801087b4:	e8 a0 fc ff ff       	call   80108459 <mappages>
  memmove(mem, init, sz);
801087b9:	8b 45 10             	mov    0x10(%ebp),%eax
801087bc:	89 44 24 08          	mov    %eax,0x8(%esp)
801087c0:	8b 45 0c             	mov    0xc(%ebp),%eax
801087c3:	89 44 24 04          	mov    %eax,0x4(%esp)
801087c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
801087ca:	89 04 24             	mov    %eax,(%esp)
801087cd:	e8 44 d0 ff ff       	call   80105816 <memmove>
}
801087d2:	c9                   	leave  
801087d3:	c3                   	ret    

801087d4 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
801087d4:	55                   	push   %ebp
801087d5:	89 e5                	mov    %esp,%ebp
801087d7:	53                   	push   %ebx
801087d8:	83 ec 24             	sub    $0x24,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
801087db:	8b 45 0c             	mov    0xc(%ebp),%eax
801087de:	25 ff 0f 00 00       	and    $0xfff,%eax
801087e3:	85 c0                	test   %eax,%eax
801087e5:	74 0c                	je     801087f3 <loaduvm+0x1f>
    panic("loaduvm: addr must be page aligned");
801087e7:	c7 04 24 50 93 10 80 	movl   $0x80109350,(%esp)
801087ee:	e8 47 7d ff ff       	call   8010053a <panic>
  for(i = 0; i < sz; i += PGSIZE){
801087f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
801087fa:	e9 a9 00 00 00       	jmp    801088a8 <loaduvm+0xd4>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801087ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108802:	8b 55 0c             	mov    0xc(%ebp),%edx
80108805:	01 d0                	add    %edx,%eax
80108807:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010880e:	00 
8010880f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108813:	8b 45 08             	mov    0x8(%ebp),%eax
80108816:	89 04 24             	mov    %eax,(%esp)
80108819:	e8 99 fb ff ff       	call   801083b7 <walkpgdir>
8010881e:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108821:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108825:	75 0c                	jne    80108833 <loaduvm+0x5f>
      panic("loaduvm: address should exist");
80108827:	c7 04 24 73 93 10 80 	movl   $0x80109373,(%esp)
8010882e:	e8 07 7d ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108833:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108836:	8b 00                	mov    (%eax),%eax
80108838:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010883d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(sz - i < PGSIZE)
80108840:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108843:	8b 55 18             	mov    0x18(%ebp),%edx
80108846:	29 c2                	sub    %eax,%edx
80108848:	89 d0                	mov    %edx,%eax
8010884a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010884f:	77 0f                	ja     80108860 <loaduvm+0x8c>
      n = sz - i;
80108851:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108854:	8b 55 18             	mov    0x18(%ebp),%edx
80108857:	29 c2                	sub    %eax,%edx
80108859:	89 d0                	mov    %edx,%eax
8010885b:	89 45 f0             	mov    %eax,-0x10(%ebp)
8010885e:	eb 07                	jmp    80108867 <loaduvm+0x93>
    else
      n = PGSIZE;
80108860:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
    if(readi(ip, p2v(pa), offset+i, n) != n)
80108867:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010886a:	8b 55 14             	mov    0x14(%ebp),%edx
8010886d:	8d 1c 02             	lea    (%edx,%eax,1),%ebx
80108870:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108873:	89 04 24             	mov    %eax,(%esp)
80108876:	e8 b9 f6 ff ff       	call   80107f34 <p2v>
8010887b:	8b 55 f0             	mov    -0x10(%ebp),%edx
8010887e:	89 54 24 0c          	mov    %edx,0xc(%esp)
80108882:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80108886:	89 44 24 04          	mov    %eax,0x4(%esp)
8010888a:	8b 45 10             	mov    0x10(%ebp),%eax
8010888d:	89 04 24             	mov    %eax,(%esp)
80108890:	e8 0d 95 ff ff       	call   80101da2 <readi>
80108895:	3b 45 f0             	cmp    -0x10(%ebp),%eax
80108898:	74 07                	je     801088a1 <loaduvm+0xcd>
      return -1;
8010889a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010889f:	eb 18                	jmp    801088b9 <loaduvm+0xe5>
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
801088a1:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
801088a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801088ab:	3b 45 18             	cmp    0x18(%ebp),%eax
801088ae:	0f 82 4b ff ff ff    	jb     801087ff <loaduvm+0x2b>
    else
      n = PGSIZE;
    if(readi(ip, p2v(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
801088b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
801088b9:	83 c4 24             	add    $0x24,%esp
801088bc:	5b                   	pop    %ebx
801088bd:	5d                   	pop    %ebp
801088be:	c3                   	ret    

801088bf <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801088bf:	55                   	push   %ebp
801088c0:	89 e5                	mov    %esp,%ebp
801088c2:	83 ec 38             	sub    $0x38,%esp
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
801088c5:	8b 45 10             	mov    0x10(%ebp),%eax
801088c8:	85 c0                	test   %eax,%eax
801088ca:	79 0a                	jns    801088d6 <allocuvm+0x17>
    return 0;
801088cc:	b8 00 00 00 00       	mov    $0x0,%eax
801088d1:	e9 c1 00 00 00       	jmp    80108997 <allocuvm+0xd8>
  if(newsz < oldsz)
801088d6:	8b 45 10             	mov    0x10(%ebp),%eax
801088d9:	3b 45 0c             	cmp    0xc(%ebp),%eax
801088dc:	73 08                	jae    801088e6 <allocuvm+0x27>
    return oldsz;
801088de:	8b 45 0c             	mov    0xc(%ebp),%eax
801088e1:	e9 b1 00 00 00       	jmp    80108997 <allocuvm+0xd8>

  a = PGROUNDUP(oldsz);
801088e6:	8b 45 0c             	mov    0xc(%ebp),%eax
801088e9:	05 ff 0f 00 00       	add    $0xfff,%eax
801088ee:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801088f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a < newsz; a += PGSIZE){
801088f6:	e9 8d 00 00 00       	jmp    80108988 <allocuvm+0xc9>
    mem = kalloc();
801088fb:	e8 1c a2 ff ff       	call   80102b1c <kalloc>
80108900:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(mem == 0){
80108903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108907:	75 2c                	jne    80108935 <allocuvm+0x76>
      cprintf("allocuvm out of memory\n");
80108909:	c7 04 24 91 93 10 80 	movl   $0x80109391,(%esp)
80108910:	e8 8b 7a ff ff       	call   801003a0 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80108915:	8b 45 0c             	mov    0xc(%ebp),%eax
80108918:	89 44 24 08          	mov    %eax,0x8(%esp)
8010891c:	8b 45 10             	mov    0x10(%ebp),%eax
8010891f:	89 44 24 04          	mov    %eax,0x4(%esp)
80108923:	8b 45 08             	mov    0x8(%ebp),%eax
80108926:	89 04 24             	mov    %eax,(%esp)
80108929:	e8 6b 00 00 00       	call   80108999 <deallocuvm>
      return 0;
8010892e:	b8 00 00 00 00       	mov    $0x0,%eax
80108933:	eb 62                	jmp    80108997 <allocuvm+0xd8>
    }
    memset(mem, 0, PGSIZE);
80108935:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010893c:	00 
8010893d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80108944:	00 
80108945:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108948:	89 04 24             	mov    %eax,(%esp)
8010894b:	e8 f7 cd ff ff       	call   80105747 <memset>
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
80108950:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108953:	89 04 24             	mov    %eax,(%esp)
80108956:	e8 cc f5 ff ff       	call   80107f27 <v2p>
8010895b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010895e:	c7 44 24 10 06 00 00 	movl   $0x6,0x10(%esp)
80108965:	00 
80108966:	89 44 24 0c          	mov    %eax,0xc(%esp)
8010896a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108971:	00 
80108972:	89 54 24 04          	mov    %edx,0x4(%esp)
80108976:	8b 45 08             	mov    0x8(%ebp),%eax
80108979:	89 04 24             	mov    %eax,(%esp)
8010897c:	e8 d8 fa ff ff       	call   80108459 <mappages>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80108981:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108988:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010898b:	3b 45 10             	cmp    0x10(%ebp),%eax
8010898e:	0f 82 67 ff ff ff    	jb     801088fb <allocuvm+0x3c>
      return 0;
    }
    memset(mem, 0, PGSIZE);
    mappages(pgdir, (char*)a, PGSIZE, v2p(mem), PTE_W|PTE_U);
  }
  return newsz;
80108994:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108997:	c9                   	leave  
80108998:	c3                   	ret    

80108999 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80108999:	55                   	push   %ebp
8010899a:	89 e5                	mov    %esp,%ebp
8010899c:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
8010899f:	8b 45 10             	mov    0x10(%ebp),%eax
801089a2:	3b 45 0c             	cmp    0xc(%ebp),%eax
801089a5:	72 08                	jb     801089af <deallocuvm+0x16>
    return oldsz;
801089a7:	8b 45 0c             	mov    0xc(%ebp),%eax
801089aa:	e9 a4 00 00 00       	jmp    80108a53 <deallocuvm+0xba>

  a = PGROUNDUP(newsz);
801089af:	8b 45 10             	mov    0x10(%ebp),%eax
801089b2:	05 ff 0f 00 00       	add    $0xfff,%eax
801089b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801089bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  for(; a  < oldsz; a += PGSIZE){
801089bf:	e9 80 00 00 00       	jmp    80108a44 <deallocuvm+0xab>
    pte = walkpgdir(pgdir, (char*)a, 0);
801089c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
801089c7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801089ce:	00 
801089cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801089d3:	8b 45 08             	mov    0x8(%ebp),%eax
801089d6:	89 04 24             	mov    %eax,(%esp)
801089d9:	e8 d9 f9 ff ff       	call   801083b7 <walkpgdir>
801089de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(!pte)
801089e1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
801089e5:	75 09                	jne    801089f0 <deallocuvm+0x57>
      a += (NPTENTRIES - 1) * PGSIZE;
801089e7:	81 45 f4 00 f0 3f 00 	addl   $0x3ff000,-0xc(%ebp)
801089ee:	eb 4d                	jmp    80108a3d <deallocuvm+0xa4>
    else if((*pte & PTE_P) != 0){
801089f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089f3:	8b 00                	mov    (%eax),%eax
801089f5:	83 e0 01             	and    $0x1,%eax
801089f8:	85 c0                	test   %eax,%eax
801089fa:	74 41                	je     80108a3d <deallocuvm+0xa4>
      pa = PTE_ADDR(*pte);
801089fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801089ff:	8b 00                	mov    (%eax),%eax
80108a01:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108a06:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(pa == 0)
80108a09:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108a0d:	75 0c                	jne    80108a1b <deallocuvm+0x82>
        panic("kfree");
80108a0f:	c7 04 24 a9 93 10 80 	movl   $0x801093a9,(%esp)
80108a16:	e8 1f 7b ff ff       	call   8010053a <panic>
      char *v = p2v(pa);
80108a1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108a1e:	89 04 24             	mov    %eax,(%esp)
80108a21:	e8 0e f5 ff ff       	call   80107f34 <p2v>
80108a26:	89 45 e8             	mov    %eax,-0x18(%ebp)
      kfree(v);
80108a29:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108a2c:	89 04 24             	mov    %eax,(%esp)
80108a2f:	e8 4f a0 ff ff       	call   80102a83 <kfree>
      *pte = 0;
80108a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108a37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80108a3d:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a47:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108a4a:	0f 82 74 ff ff ff    	jb     801089c4 <deallocuvm+0x2b>
      char *v = p2v(pa);
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
80108a50:	8b 45 10             	mov    0x10(%ebp),%eax
}
80108a53:	c9                   	leave  
80108a54:	c3                   	ret    

80108a55 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80108a55:	55                   	push   %ebp
80108a56:	89 e5                	mov    %esp,%ebp
80108a58:	83 ec 28             	sub    $0x28,%esp
  uint i;

  if(pgdir == 0)
80108a5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80108a5f:	75 0c                	jne    80108a6d <freevm+0x18>
    panic("freevm: no pgdir");
80108a61:	c7 04 24 af 93 10 80 	movl   $0x801093af,(%esp)
80108a68:	e8 cd 7a ff ff       	call   8010053a <panic>
  deallocuvm(pgdir, KERNBASE, 0);
80108a6d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108a74:	00 
80108a75:	c7 44 24 04 00 00 00 	movl   $0x80000000,0x4(%esp)
80108a7c:	80 
80108a7d:	8b 45 08             	mov    0x8(%ebp),%eax
80108a80:	89 04 24             	mov    %eax,(%esp)
80108a83:	e8 11 ff ff ff       	call   80108999 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
80108a88:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108a8f:	eb 48                	jmp    80108ad9 <freevm+0x84>
    if(pgdir[i] & PTE_P){
80108a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108a94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108a9b:	8b 45 08             	mov    0x8(%ebp),%eax
80108a9e:	01 d0                	add    %edx,%eax
80108aa0:	8b 00                	mov    (%eax),%eax
80108aa2:	83 e0 01             	and    $0x1,%eax
80108aa5:	85 c0                	test   %eax,%eax
80108aa7:	74 2c                	je     80108ad5 <freevm+0x80>
      char * v = p2v(PTE_ADDR(pgdir[i]));
80108aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108aac:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
80108ab3:	8b 45 08             	mov    0x8(%ebp),%eax
80108ab6:	01 d0                	add    %edx,%eax
80108ab8:	8b 00                	mov    (%eax),%eax
80108aba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108abf:	89 04 24             	mov    %eax,(%esp)
80108ac2:	e8 6d f4 ff ff       	call   80107f34 <p2v>
80108ac7:	89 45 f0             	mov    %eax,-0x10(%ebp)
      kfree(v);
80108aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108acd:	89 04 24             	mov    %eax,(%esp)
80108ad0:	e8 ae 9f ff ff       	call   80102a83 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80108ad5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
80108ad9:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
80108ae0:	76 af                	jbe    80108a91 <freevm+0x3c>
    if(pgdir[i] & PTE_P){
      char * v = p2v(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80108ae2:	8b 45 08             	mov    0x8(%ebp),%eax
80108ae5:	89 04 24             	mov    %eax,(%esp)
80108ae8:	e8 96 9f ff ff       	call   80102a83 <kfree>
}
80108aed:	c9                   	leave  
80108aee:	c3                   	ret    

80108aef <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80108aef:	55                   	push   %ebp
80108af0:	89 e5                	mov    %esp,%ebp
80108af2:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108af5:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108afc:	00 
80108afd:	8b 45 0c             	mov    0xc(%ebp),%eax
80108b00:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b04:	8b 45 08             	mov    0x8(%ebp),%eax
80108b07:	89 04 24             	mov    %eax,(%esp)
80108b0a:	e8 a8 f8 ff ff       	call   801083b7 <walkpgdir>
80108b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(pte == 0)
80108b12:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
80108b16:	75 0c                	jne    80108b24 <clearpteu+0x35>
    panic("clearpteu");
80108b18:	c7 04 24 c0 93 10 80 	movl   $0x801093c0,(%esp)
80108b1f:	e8 16 7a ff ff       	call   8010053a <panic>
  *pte &= ~PTE_U;
80108b24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b27:	8b 00                	mov    (%eax),%eax
80108b29:	83 e0 fb             	and    $0xfffffffb,%eax
80108b2c:	89 c2                	mov    %eax,%edx
80108b2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b31:	89 10                	mov    %edx,(%eax)
}
80108b33:	c9                   	leave  
80108b34:	c3                   	ret    

80108b35 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80108b35:	55                   	push   %ebp
80108b36:	89 e5                	mov    %esp,%ebp
80108b38:	53                   	push   %ebx
80108b39:	83 ec 44             	sub    $0x44,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80108b3c:	e8 b0 f9 ff ff       	call   801084f1 <setupkvm>
80108b41:	89 45 f0             	mov    %eax,-0x10(%ebp)
80108b44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
80108b48:	75 0a                	jne    80108b54 <copyuvm+0x1f>
    return 0;
80108b4a:	b8 00 00 00 00       	mov    $0x0,%eax
80108b4f:	e9 fd 00 00 00       	jmp    80108c51 <copyuvm+0x11c>
  for(i = 0; i < sz; i += PGSIZE){
80108b54:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
80108b5b:	e9 d0 00 00 00       	jmp    80108c30 <copyuvm+0xfb>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80108b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108b63:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108b6a:	00 
80108b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
80108b6f:	8b 45 08             	mov    0x8(%ebp),%eax
80108b72:	89 04 24             	mov    %eax,(%esp)
80108b75:	e8 3d f8 ff ff       	call   801083b7 <walkpgdir>
80108b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
80108b7d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
80108b81:	75 0c                	jne    80108b8f <copyuvm+0x5a>
      panic("copyuvm: pte should exist");
80108b83:	c7 04 24 ca 93 10 80 	movl   $0x801093ca,(%esp)
80108b8a:	e8 ab 79 ff ff       	call   8010053a <panic>
    if(!(*pte & PTE_P))
80108b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108b92:	8b 00                	mov    (%eax),%eax
80108b94:	83 e0 01             	and    $0x1,%eax
80108b97:	85 c0                	test   %eax,%eax
80108b99:	75 0c                	jne    80108ba7 <copyuvm+0x72>
      panic("copyuvm: page not present");
80108b9b:	c7 04 24 e4 93 10 80 	movl   $0x801093e4,(%esp)
80108ba2:	e8 93 79 ff ff       	call   8010053a <panic>
    pa = PTE_ADDR(*pte);
80108ba7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108baa:	8b 00                	mov    (%eax),%eax
80108bac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108bb1:	89 45 e8             	mov    %eax,-0x18(%ebp)
    flags = PTE_FLAGS(*pte);
80108bb4:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108bb7:	8b 00                	mov    (%eax),%eax
80108bb9:	25 ff 0f 00 00       	and    $0xfff,%eax
80108bbe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80108bc1:	e8 56 9f ff ff       	call   80102b1c <kalloc>
80108bc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
80108bc9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80108bcd:	75 02                	jne    80108bd1 <copyuvm+0x9c>
      goto bad;
80108bcf:	eb 70                	jmp    80108c41 <copyuvm+0x10c>
    memmove(mem, (char*)p2v(pa), PGSIZE);
80108bd1:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108bd4:	89 04 24             	mov    %eax,(%esp)
80108bd7:	e8 58 f3 ff ff       	call   80107f34 <p2v>
80108bdc:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108be3:	00 
80108be4:	89 44 24 04          	mov    %eax,0x4(%esp)
80108be8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108beb:	89 04 24             	mov    %eax,(%esp)
80108bee:	e8 23 cc ff ff       	call   80105816 <memmove>
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
80108bf3:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80108bf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
80108bf9:	89 04 24             	mov    %eax,(%esp)
80108bfc:	e8 26 f3 ff ff       	call   80107f27 <v2p>
80108c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
80108c04:	89 5c 24 10          	mov    %ebx,0x10(%esp)
80108c08:	89 44 24 0c          	mov    %eax,0xc(%esp)
80108c0c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80108c13:	00 
80108c14:	89 54 24 04          	mov    %edx,0x4(%esp)
80108c18:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c1b:	89 04 24             	mov    %eax,(%esp)
80108c1e:	e8 36 f8 ff ff       	call   80108459 <mappages>
80108c23:	85 c0                	test   %eax,%eax
80108c25:	79 02                	jns    80108c29 <copyuvm+0xf4>
      goto bad;
80108c27:	eb 18                	jmp    80108c41 <copyuvm+0x10c>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80108c29:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
80108c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c33:	3b 45 0c             	cmp    0xc(%ebp),%eax
80108c36:	0f 82 24 ff ff ff    	jb     80108b60 <copyuvm+0x2b>
      goto bad;
    memmove(mem, (char*)p2v(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, v2p(mem), flags) < 0)
      goto bad;
  }
  return d;
80108c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c3f:	eb 10                	jmp    80108c51 <copyuvm+0x11c>

bad:
  freevm(d);
80108c41:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108c44:	89 04 24             	mov    %eax,(%esp)
80108c47:	e8 09 fe ff ff       	call   80108a55 <freevm>
  return 0;
80108c4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108c51:	83 c4 44             	add    $0x44,%esp
80108c54:	5b                   	pop    %ebx
80108c55:	5d                   	pop    %ebp
80108c56:	c3                   	ret    

80108c57 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80108c57:	55                   	push   %ebp
80108c58:	89 e5                	mov    %esp,%ebp
80108c5a:	83 ec 28             	sub    $0x28,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80108c5d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80108c64:	00 
80108c65:	8b 45 0c             	mov    0xc(%ebp),%eax
80108c68:	89 44 24 04          	mov    %eax,0x4(%esp)
80108c6c:	8b 45 08             	mov    0x8(%ebp),%eax
80108c6f:	89 04 24             	mov    %eax,(%esp)
80108c72:	e8 40 f7 ff ff       	call   801083b7 <walkpgdir>
80108c77:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if((*pte & PTE_P) == 0)
80108c7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c7d:	8b 00                	mov    (%eax),%eax
80108c7f:	83 e0 01             	and    $0x1,%eax
80108c82:	85 c0                	test   %eax,%eax
80108c84:	75 07                	jne    80108c8d <uva2ka+0x36>
    return 0;
80108c86:	b8 00 00 00 00       	mov    $0x0,%eax
80108c8b:	eb 25                	jmp    80108cb2 <uva2ka+0x5b>
  if((*pte & PTE_U) == 0)
80108c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108c90:	8b 00                	mov    (%eax),%eax
80108c92:	83 e0 04             	and    $0x4,%eax
80108c95:	85 c0                	test   %eax,%eax
80108c97:	75 07                	jne    80108ca0 <uva2ka+0x49>
    return 0;
80108c99:	b8 00 00 00 00       	mov    $0x0,%eax
80108c9e:	eb 12                	jmp    80108cb2 <uva2ka+0x5b>
  return (char*)p2v(PTE_ADDR(*pte));
80108ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108ca3:	8b 00                	mov    (%eax),%eax
80108ca5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108caa:	89 04 24             	mov    %eax,(%esp)
80108cad:	e8 82 f2 ff ff       	call   80107f34 <p2v>
}
80108cb2:	c9                   	leave  
80108cb3:	c3                   	ret    

80108cb4 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80108cb4:	55                   	push   %ebp
80108cb5:	89 e5                	mov    %esp,%ebp
80108cb7:	83 ec 28             	sub    $0x28,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
80108cba:	8b 45 10             	mov    0x10(%ebp),%eax
80108cbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  while(len > 0){
80108cc0:	e9 87 00 00 00       	jmp    80108d4c <copyout+0x98>
    va0 = (uint)PGROUNDDOWN(va);
80108cc5:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cc8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80108ccd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80108cd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80108cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80108cda:	89 04 24             	mov    %eax,(%esp)
80108cdd:	e8 75 ff ff ff       	call   80108c57 <uva2ka>
80108ce2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    if(pa0 == 0)
80108ce5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
80108ce9:	75 07                	jne    80108cf2 <copyout+0x3e>
      return -1;
80108ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80108cf0:	eb 69                	jmp    80108d5b <copyout+0xa7>
    n = PGSIZE - (va - va0);
80108cf2:	8b 45 0c             	mov    0xc(%ebp),%eax
80108cf5:	8b 55 ec             	mov    -0x14(%ebp),%edx
80108cf8:	29 c2                	sub    %eax,%edx
80108cfa:	89 d0                	mov    %edx,%eax
80108cfc:	05 00 10 00 00       	add    $0x1000,%eax
80108d01:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(n > len)
80108d04:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d07:	3b 45 14             	cmp    0x14(%ebp),%eax
80108d0a:	76 06                	jbe    80108d12 <copyout+0x5e>
      n = len;
80108d0c:	8b 45 14             	mov    0x14(%ebp),%eax
80108d0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memmove(pa0 + (va - va0), buf, n);
80108d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d15:	8b 55 0c             	mov    0xc(%ebp),%edx
80108d18:	29 c2                	sub    %eax,%edx
80108d1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
80108d1d:	01 c2                	add    %eax,%edx
80108d1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d22:	89 44 24 08          	mov    %eax,0x8(%esp)
80108d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
80108d29:	89 44 24 04          	mov    %eax,0x4(%esp)
80108d2d:	89 14 24             	mov    %edx,(%esp)
80108d30:	e8 e1 ca ff ff       	call   80105816 <memmove>
    len -= n;
80108d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d38:	29 45 14             	sub    %eax,0x14(%ebp)
    buf += n;
80108d3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80108d3e:	01 45 f4             	add    %eax,-0xc(%ebp)
    va = va0 + PGSIZE;
80108d41:	8b 45 ec             	mov    -0x14(%ebp),%eax
80108d44:	05 00 10 00 00       	add    $0x1000,%eax
80108d49:	89 45 0c             	mov    %eax,0xc(%ebp)
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80108d4c:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80108d50:	0f 85 6f ff ff ff    	jne    80108cc5 <copyout+0x11>
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80108d56:	b8 00 00 00 00       	mov    $0x0,%eax
}
80108d5b:	c9                   	leave  
80108d5c:	c3                   	ret    
