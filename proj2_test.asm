
_proj2_test:     file format elf32-i386


Disassembly of section .text:

00000000 <usage>:

#include "types.h"
#include "user.h"

void usage(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 08             	sub    $0x8,%esp
    printf(1, "Usage: proj2_lpatest 0|1 \n"
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 2c 0f 00 00       	push   $0xf2c
   e:	6a 01                	push   $0x1
  10:	e8 5d 0b 00 00       	call   b72 <printf>
  15:	83 c4 10             	add    $0x10,%esp
              "\t0: Default page allocator \n"
              "\t1: Lazy page allocator \n");
}
  18:	90                   	nop
  19:	c9                   	leave  
  1a:	c3                   	ret    

0000001b <main>:
  
int
main(int argc, char *argv[])
{
  1b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  1f:	83 e4 f0             	and    $0xfffffff0,%esp
  22:	ff 71 fc             	push   -0x4(%ecx)
  25:	55                   	push   %ebp
  26:	89 e5                	mov    %esp,%ebp
  28:	51                   	push   %ecx
  29:	83 ec 24             	sub    $0x24,%esp
  2c:	89 c8                	mov    %ecx,%eax
    int ret = 0;
  2e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    int a = 0;
  35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int size = 0;
  3c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    char * addr = (void *)0;
  43:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    char * cur_break = (void *)0;
  4a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    char * old_break = (void *)0;
  51:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)

    if (argc < 2)
  58:	83 38 01             	cmpl   $0x1,(%eax)
  5b:	7f 0a                	jg     67 <main+0x4c>
    {
        usage();
  5d:	e8 9e ff ff ff       	call   0 <usage>
        exit();
  62:	e8 77 09 00 00       	call   9de <exit>
    }

    if (argv[1][0] == '0')
  67:	8b 40 04             	mov    0x4(%eax),%eax
  6a:	83 c0 04             	add    $0x4,%eax
  6d:	8b 00                	mov    (%eax),%eax
  6f:	0f b6 00             	movzbl (%eax),%eax
  72:	3c 30                	cmp    $0x30,%al
  74:	75 1b                	jne    91 <main+0x76>
    {
        a = 0;
  76:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        printf(1, "\nUsing the DEFAULT page allocator ...\n");
  7d:	83 ec 08             	sub    $0x8,%esp
  80:	68 7c 0f 00 00       	push   $0xf7c
  85:	6a 01                	push   $0x1
  87:	e8 e6 0a 00 00       	call   b72 <printf>
  8c:	83 c4 10             	add    $0x10,%esp
  8f:	eb 19                	jmp    aa <main+0x8f>
    }
    else
    {
        a = 1;
  91:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        printf(1, "\nUsing the LAZY page allocator ...\n");
  98:	83 ec 08             	sub    $0x8,%esp
  9b:	68 a4 0f 00 00       	push   $0xfa4
  a0:	6a 01                	push   $0x1
  a2:	e8 cb 0a 00 00       	call   b72 <printf>
  a7:	83 c4 10             	add    $0x10,%esp
    }  

    ret = set_page_allocator(a);
  aa:	83 ec 0c             	sub    $0xc,%esp
  ad:	ff 75 f4             	push   -0xc(%ebp)
  b0:	e8 d1 09 00 00       	call   a86 <set_page_allocator>
  b5:	83 c4 10             	add    $0x10,%esp
  b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if ( ret == -1)
  bb:	83 7d f0 ff          	cmpl   $0xffffffff,-0x10(%ebp)
  bf:	75 1a                	jne    db <main+0xc0>
    {
    	printf(1, "\nImplement the LAZY page allocator before tests:%d\n", ret);
  c1:	83 ec 04             	sub    $0x4,%esp
  c4:	ff 75 f0             	push   -0x10(%ebp)
  c7:	68 c8 0f 00 00       	push   $0xfc8
  cc:	6a 01                	push   $0x1
  ce:	e8 9f 0a 00 00       	call   b72 <printf>
  d3:	83 c4 10             	add    $0x10,%esp
	exit();
  d6:	e8 03 09 00 00       	call   9de <exit>
    }

    //=========================
    size = 10;
  db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
    printf(1, "\n=========== TEST 1: sbrk(%d) ===========\n", size);
  e2:	83 ec 04             	sub    $0x4,%esp
  e5:	ff 75 ec             	push   -0x14(%ebp)
  e8:	68 fc 0f 00 00       	push   $0xffc
  ed:	6a 01                	push   $0x1
  ef:	e8 7e 0a 00 00       	call   b72 <printf>
  f4:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
  f7:	83 ec 0c             	sub    $0xc,%esp
  fa:	6a 00                	push   $0x0
  fc:	e8 65 09 00 00       	call   a66 <sbrk>
 101:	83 c4 10             	add    $0x10,%esp
 104:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Before sbrk(%d), break 0x%x ", size, cur_break);
 107:	ff 75 e4             	push   -0x1c(%ebp)
 10a:	ff 75 ec             	push   -0x14(%ebp)
 10d:	68 27 10 00 00       	push   $0x1027
 112:	6a 01                	push   $0x1
 114:	e8 59 0a 00 00       	call   b72 <printf>
 119:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 11c:	e8 5d 09 00 00       	call   a7e <print_free_frame_cnt>
    printf(1, "Calling sbrk(%d) ... \n", size);
 121:	83 ec 04             	sub    $0x4,%esp
 124:	ff 75 ec             	push   -0x14(%ebp)
 127:	68 44 10 00 00       	push   $0x1044
 12c:	6a 01                	push   $0x1
 12e:	e8 3f 0a 00 00       	call   b72 <printf>
 133:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 136:	83 ec 0c             	sub    $0xc,%esp
 139:	ff 75 ec             	push   -0x14(%ebp)
 13c:	e8 25 09 00 00       	call   a66 <sbrk>
 141:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 144:	83 ec 0c             	sub    $0xc,%esp
 147:	6a 00                	push   $0x0
 149:	e8 18 09 00 00       	call   a66 <sbrk>
 14e:	83 c4 10             	add    $0x10,%esp
 151:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After sbrk(%d), break 0x%x ", size, cur_break);
 154:	ff 75 e4             	push   -0x1c(%ebp)
 157:	ff 75 ec             	push   -0x14(%ebp)
 15a:	68 5b 10 00 00       	push   $0x105b
 15f:	6a 01                	push   $0x1
 161:	e8 0c 0a 00 00       	call   b72 <printf>
 166:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 169:	e8 10 09 00 00       	call   a7e <print_free_frame_cnt>


    printf(1, "\n=========== TEST 2: writing valid bytes ===========\n", addr);
 16e:	83 ec 04             	sub    $0x4,%esp
 171:	ff 75 e8             	push   -0x18(%ebp)
 174:	68 78 10 00 00       	push   $0x1078
 179:	6a 01                	push   $0x1
 17b:	e8 f2 09 00 00       	call   b72 <printf>
 180:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 183:	83 ec 0c             	sub    $0xc,%esp
 186:	6a 00                	push   $0x0
 188:	e8 d9 08 00 00       	call   a66 <sbrk>
 18d:	83 c4 10             	add    $0x10,%esp
 190:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Before the write, break 0x%x ", cur_break);
 193:	83 ec 04             	sub    $0x4,%esp
 196:	ff 75 e4             	push   -0x1c(%ebp)
 199:	68 ae 10 00 00       	push   $0x10ae
 19e:	6a 01                	push   $0x1
 1a0:	e8 cd 09 00 00       	call   b72 <printf>
 1a5:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 1a8:	e8 d1 08 00 00       	call   a7e <print_free_frame_cnt>
    addr = cur_break;
 1ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Writing byte 0x%x ...\n", addr);
 1b3:	83 ec 04             	sub    $0x4,%esp
 1b6:	ff 75 e8             	push   -0x18(%ebp)
 1b9:	68 cc 10 00 00       	push   $0x10cc
 1be:	6a 01                	push   $0x1
 1c0:	e8 ad 09 00 00       	call   b72 <printf>
 1c5:	83 c4 10             	add    $0x10,%esp
    *addr = 1;
 1c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 1cb:	c6 00 01             	movb   $0x1,(%eax)
    printf(1, "After the write, ");
 1ce:	83 ec 08             	sub    $0x8,%esp
 1d1:	68 e3 10 00 00       	push   $0x10e3
 1d6:	6a 01                	push   $0x1
 1d8:	e8 95 09 00 00       	call   b72 <printf>
 1dd:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 1e0:	e8 99 08 00 00       	call   a7e <print_free_frame_cnt>

    printf(1, "\nBefore the write, ");
 1e5:	83 ec 08             	sub    $0x8,%esp
 1e8:	68 f5 10 00 00       	push   $0x10f5
 1ed:	6a 01                	push   $0x1
 1ef:	e8 7e 09 00 00       	call   b72 <printf>
 1f4:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 1f7:	e8 82 08 00 00       	call   a7e <print_free_frame_cnt>
    addr = cur_break -  1;
 1fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 1ff:	83 e8 01             	sub    $0x1,%eax
 202:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Writing byte 0x%x ...\n", addr);
 205:	83 ec 04             	sub    $0x4,%esp
 208:	ff 75 e8             	push   -0x18(%ebp)
 20b:	68 cc 10 00 00       	push   $0x10cc
 210:	6a 01                	push   $0x1
 212:	e8 5b 09 00 00       	call   b72 <printf>
 217:	83 c4 10             	add    $0x10,%esp
    *addr = 1;
 21a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 21d:	c6 00 01             	movb   $0x1,(%eax)
    printf(1, "After the write, ");
 220:	83 ec 08             	sub    $0x8,%esp
 223:	68 e3 10 00 00       	push   $0x10e3
 228:	6a 01                	push   $0x1
 22a:	e8 43 09 00 00       	call   b72 <printf>
 22f:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 232:	e8 47 08 00 00       	call   a7e <print_free_frame_cnt>


    printf(1, "\n=========== TEST 3: sbrk(+) --> sbrk(-) --> write ===========\n", addr);
 237:	83 ec 04             	sub    $0x4,%esp
 23a:	ff 75 e8             	push   -0x18(%ebp)
 23d:	68 0c 11 00 00       	push   $0x110c
 242:	6a 01                	push   $0x1
 244:	e8 29 09 00 00       	call   b72 <printf>
 249:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 24c:	83 ec 0c             	sub    $0xc,%esp
 24f:	6a 00                	push   $0x0
 251:	e8 10 08 00 00       	call   a66 <sbrk>
 256:	83 c4 10             	add    $0x10,%esp
 259:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Before the sbrk(+), break 0x%x ", cur_break);
 25c:	83 ec 04             	sub    $0x4,%esp
 25f:	ff 75 e4             	push   -0x1c(%ebp)
 262:	68 4c 11 00 00       	push   $0x114c
 267:	6a 01                	push   $0x1
 269:	e8 04 09 00 00       	call   b72 <printf>
 26e:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 271:	e8 08 08 00 00       	call   a7e <print_free_frame_cnt>
    size = 0x10;
 276:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
    printf(1, "Calling sbrk(%d) ...\n", size);
 27d:	83 ec 04             	sub    $0x4,%esp
 280:	ff 75 ec             	push   -0x14(%ebp)
 283:	68 6c 11 00 00       	push   $0x116c
 288:	6a 01                	push   $0x1
 28a:	e8 e3 08 00 00       	call   b72 <printf>
 28f:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 292:	83 ec 0c             	sub    $0xc,%esp
 295:	ff 75 ec             	push   -0x14(%ebp)
 298:	e8 c9 07 00 00       	call   a66 <sbrk>
 29d:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 2a0:	83 ec 0c             	sub    $0xc,%esp
 2a3:	6a 00                	push   $0x0
 2a5:	e8 bc 07 00 00       	call   a66 <sbrk>
 2aa:	83 c4 10             	add    $0x10,%esp
 2ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After the sbrk(+), break 0x%x ", cur_break);
 2b0:	83 ec 04             	sub    $0x4,%esp
 2b3:	ff 75 e4             	push   -0x1c(%ebp)
 2b6:	68 84 11 00 00       	push   $0x1184
 2bb:	6a 01                	push   $0x1
 2bd:	e8 b0 08 00 00       	call   b72 <printf>
 2c2:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 2c5:	e8 b4 07 00 00       	call   a7e <print_free_frame_cnt>

    cur_break = sbrk(0);
 2ca:	83 ec 0c             	sub    $0xc,%esp
 2cd:	6a 00                	push   $0x0
 2cf:	e8 92 07 00 00       	call   a66 <sbrk>
 2d4:	83 c4 10             	add    $0x10,%esp
 2d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "\nBefore the sbrk(-), break 0x%x ", cur_break);
 2da:	83 ec 04             	sub    $0x4,%esp
 2dd:	ff 75 e4             	push   -0x1c(%ebp)
 2e0:	68 a4 11 00 00       	push   $0x11a4
 2e5:	6a 01                	push   $0x1
 2e7:	e8 86 08 00 00       	call   b72 <printf>
 2ec:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 2ef:	e8 8a 07 00 00       	call   a7e <print_free_frame_cnt>
    size = -1;
 2f4:	c7 45 ec ff ff ff ff 	movl   $0xffffffff,-0x14(%ebp)
    printf(1, "Calling sbrk(%d) ...\n", size);
 2fb:	83 ec 04             	sub    $0x4,%esp
 2fe:	ff 75 ec             	push   -0x14(%ebp)
 301:	68 6c 11 00 00       	push   $0x116c
 306:	6a 01                	push   $0x1
 308:	e8 65 08 00 00       	call   b72 <printf>
 30d:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 310:	83 ec 0c             	sub    $0xc,%esp
 313:	ff 75 ec             	push   -0x14(%ebp)
 316:	e8 4b 07 00 00       	call   a66 <sbrk>
 31b:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 31e:	83 ec 0c             	sub    $0xc,%esp
 321:	6a 00                	push   $0x0
 323:	e8 3e 07 00 00       	call   a66 <sbrk>
 328:	83 c4 10             	add    $0x10,%esp
 32b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After the sbrk(-), break 0x%x ", cur_break);
 32e:	83 ec 04             	sub    $0x4,%esp
 331:	ff 75 e4             	push   -0x1c(%ebp)
 334:	68 c8 11 00 00       	push   $0x11c8
 339:	6a 01                	push   $0x1
 33b:	e8 32 08 00 00       	call   b72 <printf>
 340:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 343:	e8 36 07 00 00       	call   a7e <print_free_frame_cnt>

    printf(1, "\nBefore the write, ");
 348:	83 ec 08             	sub    $0x8,%esp
 34b:	68 f5 10 00 00       	push   $0x10f5
 350:	6a 01                	push   $0x1
 352:	e8 1b 08 00 00       	call   b72 <printf>
 357:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 35a:	e8 1f 07 00 00       	call   a7e <print_free_frame_cnt>
    addr = cur_break;
 35f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 362:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Writing byte 0x%x ...\n", addr);
 365:	83 ec 04             	sub    $0x4,%esp
 368:	ff 75 e8             	push   -0x18(%ebp)
 36b:	68 cc 10 00 00       	push   $0x10cc
 370:	6a 01                	push   $0x1
 372:	e8 fb 07 00 00       	call   b72 <printf>
 377:	83 c4 10             	add    $0x10,%esp
    *addr = 1;
 37a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 37d:	c6 00 01             	movb   $0x1,(%eax)
    printf(1, "After the write, ");
 380:	83 ec 08             	sub    $0x8,%esp
 383:	68 e3 10 00 00       	push   $0x10e3
 388:	6a 01                	push   $0x1
 38a:	e8 e3 07 00 00       	call   b72 <printf>
 38f:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 392:	e8 e7 06 00 00       	call   a7e <print_free_frame_cnt>


    printf(1, "\n==========="
 397:	83 ec 08             	sub    $0x8,%esp
 39a:	68 e8 11 00 00       	push   $0x11e8
 39f:	6a 01                	push   $0x1
 3a1:	e8 cc 07 00 00       	call   b72 <printf>
 3a6:	83 c4 10             	add    $0x10,%esp
              "write in 1st/2nd pages --> "
              "sbrk(-1 page) --> "
              "sbrk(-1 page) --> "
              "sbrk(-1 page)"
              "===========\n");
    cur_break = sbrk(0);
 3a9:	83 ec 0c             	sub    $0xc,%esp
 3ac:	6a 00                	push   $0x0
 3ae:	e8 b3 06 00 00       	call   a66 <sbrk>
 3b3:	83 c4 10             	add    $0x10,%esp
 3b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    old_break = cur_break;
 3b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    printf(1, "Before the sbrk(3 pages), break 0x%x ", cur_break);
 3bf:	83 ec 04             	sub    $0x4,%esp
 3c2:	ff 75 e4             	push   -0x1c(%ebp)
 3c5:	68 68 12 00 00       	push   $0x1268
 3ca:	6a 01                	push   $0x1
 3cc:	e8 a1 07 00 00       	call   b72 <printf>
 3d1:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 3d4:	e8 a5 06 00 00       	call   a7e <print_free_frame_cnt>
    size = 4096 * 3;
 3d9:	c7 45 ec 00 30 00 00 	movl   $0x3000,-0x14(%ebp)
    printf(1, "Calling sbrk(%d) ...\n", size);
 3e0:	83 ec 04             	sub    $0x4,%esp
 3e3:	ff 75 ec             	push   -0x14(%ebp)
 3e6:	68 6c 11 00 00       	push   $0x116c
 3eb:	6a 01                	push   $0x1
 3ed:	e8 80 07 00 00       	call   b72 <printf>
 3f2:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 3f5:	83 ec 0c             	sub    $0xc,%esp
 3f8:	ff 75 ec             	push   -0x14(%ebp)
 3fb:	e8 66 06 00 00       	call   a66 <sbrk>
 400:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 403:	83 ec 0c             	sub    $0xc,%esp
 406:	6a 00                	push   $0x0
 408:	e8 59 06 00 00       	call   a66 <sbrk>
 40d:	83 c4 10             	add    $0x10,%esp
 410:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After the sbrk(3 pages), break 0x%x ", cur_break);
 413:	83 ec 04             	sub    $0x4,%esp
 416:	ff 75 e4             	push   -0x1c(%ebp)
 419:	68 90 12 00 00       	push   $0x1290
 41e:	6a 01                	push   $0x1
 420:	e8 4d 07 00 00       	call   b72 <printf>
 425:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 428:	e8 51 06 00 00       	call   a7e <print_free_frame_cnt>

    printf(1, "\nBefore the write (in 1st page), ");
 42d:	83 ec 08             	sub    $0x8,%esp
 430:	68 b8 12 00 00       	push   $0x12b8
 435:	6a 01                	push   $0x1
 437:	e8 36 07 00 00       	call   b72 <printf>
 43c:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 43f:	e8 3a 06 00 00       	call   a7e <print_free_frame_cnt>
    addr = old_break + 4096;
 444:	8b 45 e0             	mov    -0x20(%ebp),%eax
 447:	05 00 10 00 00       	add    $0x1000,%eax
 44c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Writing byte 0x%x ...\n", addr);
 44f:	83 ec 04             	sub    $0x4,%esp
 452:	ff 75 e8             	push   -0x18(%ebp)
 455:	68 cc 10 00 00       	push   $0x10cc
 45a:	6a 01                	push   $0x1
 45c:	e8 11 07 00 00       	call   b72 <printf>
 461:	83 c4 10             	add    $0x10,%esp
    *addr = 1;
 464:	8b 45 e8             	mov    -0x18(%ebp),%eax
 467:	c6 00 01             	movb   $0x1,(%eax)
    printf(1, "After the write, ");
 46a:	83 ec 08             	sub    $0x8,%esp
 46d:	68 e3 10 00 00       	push   $0x10e3
 472:	6a 01                	push   $0x1
 474:	e8 f9 06 00 00       	call   b72 <printf>
 479:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 47c:	e8 fd 05 00 00       	call   a7e <print_free_frame_cnt>

    printf(1, "\nBefore the write (in 2nd page), ");
 481:	83 ec 08             	sub    $0x8,%esp
 484:	68 dc 12 00 00       	push   $0x12dc
 489:	6a 01                	push   $0x1
 48b:	e8 e2 06 00 00       	call   b72 <printf>
 490:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 493:	e8 e6 05 00 00       	call   a7e <print_free_frame_cnt>
    addr = old_break + 2 * 4096;
 498:	8b 45 e0             	mov    -0x20(%ebp),%eax
 49b:	05 00 20 00 00       	add    $0x2000,%eax
 4a0:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Writing byte 0x%x ...\n", addr);
 4a3:	83 ec 04             	sub    $0x4,%esp
 4a6:	ff 75 e8             	push   -0x18(%ebp)
 4a9:	68 cc 10 00 00       	push   $0x10cc
 4ae:	6a 01                	push   $0x1
 4b0:	e8 bd 06 00 00       	call   b72 <printf>
 4b5:	83 c4 10             	add    $0x10,%esp
    *addr = 1;
 4b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4bb:	c6 00 01             	movb   $0x1,(%eax)
    printf(1, "After the write, ");
 4be:	83 ec 08             	sub    $0x8,%esp
 4c1:	68 e3 10 00 00       	push   $0x10e3
 4c6:	6a 01                	push   $0x1
 4c8:	e8 a5 06 00 00       	call   b72 <printf>
 4cd:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 4d0:	e8 a9 05 00 00       	call   a7e <print_free_frame_cnt>

    cur_break = sbrk(0);
 4d5:	83 ec 0c             	sub    $0xc,%esp
 4d8:	6a 00                	push   $0x0
 4da:	e8 87 05 00 00       	call   a66 <sbrk>
 4df:	83 c4 10             	add    $0x10,%esp
 4e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    old_break = cur_break;
 4e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    printf(1, "\nBefore the sbrk(-1 page), break 0x%x ", cur_break);
 4eb:	83 ec 04             	sub    $0x4,%esp
 4ee:	ff 75 e4             	push   -0x1c(%ebp)
 4f1:	68 00 13 00 00       	push   $0x1300
 4f6:	6a 01                	push   $0x1
 4f8:	e8 75 06 00 00       	call   b72 <printf>
 4fd:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 500:	e8 79 05 00 00       	call   a7e <print_free_frame_cnt>
    size = -4096;
 505:	c7 45 ec 00 f0 ff ff 	movl   $0xfffff000,-0x14(%ebp)
    printf(1, "Calling sbrk(%d) ...\n", size);
 50c:	83 ec 04             	sub    $0x4,%esp
 50f:	ff 75 ec             	push   -0x14(%ebp)
 512:	68 6c 11 00 00       	push   $0x116c
 517:	6a 01                	push   $0x1
 519:	e8 54 06 00 00       	call   b72 <printf>
 51e:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 521:	83 ec 0c             	sub    $0xc,%esp
 524:	ff 75 ec             	push   -0x14(%ebp)
 527:	e8 3a 05 00 00       	call   a66 <sbrk>
 52c:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 52f:	83 ec 0c             	sub    $0xc,%esp
 532:	6a 00                	push   $0x0
 534:	e8 2d 05 00 00       	call   a66 <sbrk>
 539:	83 c4 10             	add    $0x10,%esp
 53c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After the sbrk(-1 page), break 0x%x ", cur_break);
 53f:	83 ec 04             	sub    $0x4,%esp
 542:	ff 75 e4             	push   -0x1c(%ebp)
 545:	68 28 13 00 00       	push   $0x1328
 54a:	6a 01                	push   $0x1
 54c:	e8 21 06 00 00       	call   b72 <printf>
 551:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 554:	e8 25 05 00 00       	call   a7e <print_free_frame_cnt>

    cur_break = sbrk(0);
 559:	83 ec 0c             	sub    $0xc,%esp
 55c:	6a 00                	push   $0x0
 55e:	e8 03 05 00 00       	call   a66 <sbrk>
 563:	83 c4 10             	add    $0x10,%esp
 566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    old_break = cur_break;
 569:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56c:	89 45 e0             	mov    %eax,-0x20(%ebp)
    printf(1, "\nBefore the sbrk(-1 page), break 0x%x ", cur_break);
 56f:	83 ec 04             	sub    $0x4,%esp
 572:	ff 75 e4             	push   -0x1c(%ebp)
 575:	68 00 13 00 00       	push   $0x1300
 57a:	6a 01                	push   $0x1
 57c:	e8 f1 05 00 00       	call   b72 <printf>
 581:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 584:	e8 f5 04 00 00       	call   a7e <print_free_frame_cnt>
    size = -4096;
 589:	c7 45 ec 00 f0 ff ff 	movl   $0xfffff000,-0x14(%ebp)
    printf(1, "Calling sbrk(%d) ...\n", size);
 590:	83 ec 04             	sub    $0x4,%esp
 593:	ff 75 ec             	push   -0x14(%ebp)
 596:	68 6c 11 00 00       	push   $0x116c
 59b:	6a 01                	push   $0x1
 59d:	e8 d0 05 00 00       	call   b72 <printf>
 5a2:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 5a5:	83 ec 0c             	sub    $0xc,%esp
 5a8:	ff 75 ec             	push   -0x14(%ebp)
 5ab:	e8 b6 04 00 00       	call   a66 <sbrk>
 5b0:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 5b3:	83 ec 0c             	sub    $0xc,%esp
 5b6:	6a 00                	push   $0x0
 5b8:	e8 a9 04 00 00       	call   a66 <sbrk>
 5bd:	83 c4 10             	add    $0x10,%esp
 5c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After the sbrk(-1 page), break 0x%x ", cur_break);
 5c3:	83 ec 04             	sub    $0x4,%esp
 5c6:	ff 75 e4             	push   -0x1c(%ebp)
 5c9:	68 28 13 00 00       	push   $0x1328
 5ce:	6a 01                	push   $0x1
 5d0:	e8 9d 05 00 00       	call   b72 <printf>
 5d5:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 5d8:	e8 a1 04 00 00       	call   a7e <print_free_frame_cnt>

    cur_break = sbrk(0);
 5dd:	83 ec 0c             	sub    $0xc,%esp
 5e0:	6a 00                	push   $0x0
 5e2:	e8 7f 04 00 00       	call   a66 <sbrk>
 5e7:	83 c4 10             	add    $0x10,%esp
 5ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    old_break = cur_break;
 5ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
    printf(1, "\nBefore the sbrk(-1 page), break 0x%x ", cur_break);
 5f3:	83 ec 04             	sub    $0x4,%esp
 5f6:	ff 75 e4             	push   -0x1c(%ebp)
 5f9:	68 00 13 00 00       	push   $0x1300
 5fe:	6a 01                	push   $0x1
 600:	e8 6d 05 00 00       	call   b72 <printf>
 605:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 608:	e8 71 04 00 00       	call   a7e <print_free_frame_cnt>
    size = -4096;
 60d:	c7 45 ec 00 f0 ff ff 	movl   $0xfffff000,-0x14(%ebp)
    printf(1, "Calling sbrk(%d) ...\n", size);
 614:	83 ec 04             	sub    $0x4,%esp
 617:	ff 75 ec             	push   -0x14(%ebp)
 61a:	68 6c 11 00 00       	push   $0x116c
 61f:	6a 01                	push   $0x1
 621:	e8 4c 05 00 00       	call   b72 <printf>
 626:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 629:	83 ec 0c             	sub    $0xc,%esp
 62c:	ff 75 ec             	push   -0x14(%ebp)
 62f:	e8 32 04 00 00       	call   a66 <sbrk>
 634:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 637:	83 ec 0c             	sub    $0xc,%esp
 63a:	6a 00                	push   $0x0
 63c:	e8 25 04 00 00       	call   a66 <sbrk>
 641:	83 c4 10             	add    $0x10,%esp
 644:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After the sbrk(-1 page), break 0x%x ", cur_break);
 647:	83 ec 04             	sub    $0x4,%esp
 64a:	ff 75 e4             	push   -0x1c(%ebp)
 64d:	68 28 13 00 00       	push   $0x1328
 652:	6a 01                	push   $0x1
 654:	e8 19 05 00 00       	call   b72 <printf>
 659:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 65c:	e8 1d 04 00 00       	call   a7e <print_free_frame_cnt>


    printf(1, "\n=========== TEST 5: allocating too much memory ===========\n", size);
 661:	83 ec 04             	sub    $0x4,%esp
 664:	ff 75 ec             	push   -0x14(%ebp)
 667:	68 50 13 00 00       	push   $0x1350
 66c:	6a 01                	push   $0x1
 66e:	e8 ff 04 00 00       	call   b72 <printf>
 673:	83 c4 10             	add    $0x10,%esp
    size = 0x7FFFFFFF;
 676:	c7 45 ec ff ff ff 7f 	movl   $0x7fffffff,-0x14(%ebp)
    cur_break = sbrk(0);
 67d:	83 ec 0c             	sub    $0xc,%esp
 680:	6a 00                	push   $0x0
 682:	e8 df 03 00 00       	call   a66 <sbrk>
 687:	83 c4 10             	add    $0x10,%esp
 68a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Before sbrk(0x%x), break 0x%x ", size, cur_break);
 68d:	ff 75 e4             	push   -0x1c(%ebp)
 690:	ff 75 ec             	push   -0x14(%ebp)
 693:	68 90 13 00 00       	push   $0x1390
 698:	6a 01                	push   $0x1
 69a:	e8 d3 04 00 00       	call   b72 <printf>
 69f:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 6a2:	e8 d7 03 00 00       	call   a7e <print_free_frame_cnt>
    printf(1, "Calling sbrk(0x%x) ... \n", size);
 6a7:	83 ec 04             	sub    $0x4,%esp
 6aa:	ff 75 ec             	push   -0x14(%ebp)
 6ad:	68 af 13 00 00       	push   $0x13af
 6b2:	6a 01                	push   $0x1
 6b4:	e8 b9 04 00 00       	call   b72 <printf>
 6b9:	83 c4 10             	add    $0x10,%esp
    sbrk(size);
 6bc:	83 ec 0c             	sub    $0xc,%esp
 6bf:	ff 75 ec             	push   -0x14(%ebp)
 6c2:	e8 9f 03 00 00       	call   a66 <sbrk>
 6c7:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 6ca:	83 ec 0c             	sub    $0xc,%esp
 6cd:	6a 00                	push   $0x0
 6cf:	e8 92 03 00 00       	call   a66 <sbrk>
 6d4:	83 c4 10             	add    $0x10,%esp
 6d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "After sbrk(0x%x), break 0x%x ", size, cur_break);
 6da:	ff 75 e4             	push   -0x1c(%ebp)
 6dd:	ff 75 ec             	push   -0x14(%ebp)
 6e0:	68 c8 13 00 00       	push   $0x13c8
 6e5:	6a 01                	push   $0x1
 6e7:	e8 86 04 00 00       	call   b72 <printf>
 6ec:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 6ef:	e8 8a 03 00 00       	call   a7e <print_free_frame_cnt>

    
    printf(1, "\n=========== TEST 6: writing in an unallocated page above the progam break ===========\n", addr);
 6f4:	83 ec 04             	sub    $0x4,%esp
 6f7:	ff 75 e8             	push   -0x18(%ebp)
 6fa:	68 e8 13 00 00       	push   $0x13e8
 6ff:	6a 01                	push   $0x1
 701:	e8 6c 04 00 00       	call   b72 <printf>
 706:	83 c4 10             	add    $0x10,%esp
    cur_break = sbrk(0);
 709:	83 ec 0c             	sub    $0xc,%esp
 70c:	6a 00                	push   $0x0
 70e:	e8 53 03 00 00       	call   a66 <sbrk>
 713:	83 c4 10             	add    $0x10,%esp
 716:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    printf(1, "Before the write, break 0x%x ", cur_break);
 719:	83 ec 04             	sub    $0x4,%esp
 71c:	ff 75 e4             	push   -0x1c(%ebp)
 71f:	68 ae 10 00 00       	push   $0x10ae
 724:	6a 01                	push   $0x1
 726:	e8 47 04 00 00       	call   b72 <printf>
 72b:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt();
 72e:	e8 4b 03 00 00       	call   a7e <print_free_frame_cnt>
    addr = cur_break + 4096;
 733:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 736:	05 00 10 00 00       	add    $0x1000,%eax
 73b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    printf(1, "Writing byte 0x%x ...\n", addr);
 73e:	83 ec 04             	sub    $0x4,%esp
 741:	ff 75 e8             	push   -0x18(%ebp)
 744:	68 cc 10 00 00       	push   $0x10cc
 749:	6a 01                	push   $0x1
 74b:	e8 22 04 00 00       	call   b72 <printf>
 750:	83 c4 10             	add    $0x10,%esp
    *addr = 1;
 753:	8b 45 e8             	mov    -0x18(%ebp),%eax
 756:	c6 00 01             	movb   $0x1,(%eax)
    printf(1, "After the write, "); // shouldn't reach here
 759:	83 ec 08             	sub    $0x8,%esp
 75c:	68 e3 10 00 00       	push   $0x10e3
 761:	6a 01                	push   $0x1
 763:	e8 0a 04 00 00       	call   b72 <printf>
 768:	83 c4 10             	add    $0x10,%esp
    print_free_frame_cnt(); // shouldn't reach here
 76b:	e8 0e 03 00 00       	call   a7e <print_free_frame_cnt>

    printf(1, "\n");
 770:	83 ec 08             	sub    $0x8,%esp
 773:	68 40 14 00 00       	push   $0x1440
 778:	6a 01                	push   $0x1
 77a:	e8 f3 03 00 00       	call   b72 <printf>
 77f:	83 c4 10             	add    $0x10,%esp
    //=========================
    
    exit();
 782:	e8 57 02 00 00       	call   9de <exit>

00000787 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 787:	55                   	push   %ebp
 788:	89 e5                	mov    %esp,%ebp
 78a:	57                   	push   %edi
 78b:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 78c:	8b 4d 08             	mov    0x8(%ebp),%ecx
 78f:	8b 55 10             	mov    0x10(%ebp),%edx
 792:	8b 45 0c             	mov    0xc(%ebp),%eax
 795:	89 cb                	mov    %ecx,%ebx
 797:	89 df                	mov    %ebx,%edi
 799:	89 d1                	mov    %edx,%ecx
 79b:	fc                   	cld    
 79c:	f3 aa                	rep stos %al,%es:(%edi)
 79e:	89 ca                	mov    %ecx,%edx
 7a0:	89 fb                	mov    %edi,%ebx
 7a2:	89 5d 08             	mov    %ebx,0x8(%ebp)
 7a5:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 7a8:	90                   	nop
 7a9:	5b                   	pop    %ebx
 7aa:	5f                   	pop    %edi
 7ab:	5d                   	pop    %ebp
 7ac:	c3                   	ret    

000007ad <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 7ad:	55                   	push   %ebp
 7ae:	89 e5                	mov    %esp,%ebp
 7b0:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 7b3:	8b 45 08             	mov    0x8(%ebp),%eax
 7b6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 7b9:	90                   	nop
 7ba:	8b 55 0c             	mov    0xc(%ebp),%edx
 7bd:	8d 42 01             	lea    0x1(%edx),%eax
 7c0:	89 45 0c             	mov    %eax,0xc(%ebp)
 7c3:	8b 45 08             	mov    0x8(%ebp),%eax
 7c6:	8d 48 01             	lea    0x1(%eax),%ecx
 7c9:	89 4d 08             	mov    %ecx,0x8(%ebp)
 7cc:	0f b6 12             	movzbl (%edx),%edx
 7cf:	88 10                	mov    %dl,(%eax)
 7d1:	0f b6 00             	movzbl (%eax),%eax
 7d4:	84 c0                	test   %al,%al
 7d6:	75 e2                	jne    7ba <strcpy+0xd>
    ;
  return os;
 7d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7db:	c9                   	leave  
 7dc:	c3                   	ret    

000007dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 7dd:	55                   	push   %ebp
 7de:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 7e0:	eb 08                	jmp    7ea <strcmp+0xd>
    p++, q++;
 7e2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 7e6:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 7ea:	8b 45 08             	mov    0x8(%ebp),%eax
 7ed:	0f b6 00             	movzbl (%eax),%eax
 7f0:	84 c0                	test   %al,%al
 7f2:	74 10                	je     804 <strcmp+0x27>
 7f4:	8b 45 08             	mov    0x8(%ebp),%eax
 7f7:	0f b6 10             	movzbl (%eax),%edx
 7fa:	8b 45 0c             	mov    0xc(%ebp),%eax
 7fd:	0f b6 00             	movzbl (%eax),%eax
 800:	38 c2                	cmp    %al,%dl
 802:	74 de                	je     7e2 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 804:	8b 45 08             	mov    0x8(%ebp),%eax
 807:	0f b6 00             	movzbl (%eax),%eax
 80a:	0f b6 d0             	movzbl %al,%edx
 80d:	8b 45 0c             	mov    0xc(%ebp),%eax
 810:	0f b6 00             	movzbl (%eax),%eax
 813:	0f b6 c8             	movzbl %al,%ecx
 816:	89 d0                	mov    %edx,%eax
 818:	29 c8                	sub    %ecx,%eax
}
 81a:	5d                   	pop    %ebp
 81b:	c3                   	ret    

0000081c <strlen>:

uint
strlen(char *s)
{
 81c:	55                   	push   %ebp
 81d:	89 e5                	mov    %esp,%ebp
 81f:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 829:	eb 04                	jmp    82f <strlen+0x13>
 82b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 82f:	8b 55 fc             	mov    -0x4(%ebp),%edx
 832:	8b 45 08             	mov    0x8(%ebp),%eax
 835:	01 d0                	add    %edx,%eax
 837:	0f b6 00             	movzbl (%eax),%eax
 83a:	84 c0                	test   %al,%al
 83c:	75 ed                	jne    82b <strlen+0xf>
    ;
  return n;
 83e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 841:	c9                   	leave  
 842:	c3                   	ret    

00000843 <memset>:

void*
memset(void *dst, int c, uint n)
{
 843:	55                   	push   %ebp
 844:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 846:	8b 45 10             	mov    0x10(%ebp),%eax
 849:	50                   	push   %eax
 84a:	ff 75 0c             	push   0xc(%ebp)
 84d:	ff 75 08             	push   0x8(%ebp)
 850:	e8 32 ff ff ff       	call   787 <stosb>
 855:	83 c4 0c             	add    $0xc,%esp
  return dst;
 858:	8b 45 08             	mov    0x8(%ebp),%eax
}
 85b:	c9                   	leave  
 85c:	c3                   	ret    

0000085d <strchr>:

char*
strchr(const char *s, char c)
{
 85d:	55                   	push   %ebp
 85e:	89 e5                	mov    %esp,%ebp
 860:	83 ec 04             	sub    $0x4,%esp
 863:	8b 45 0c             	mov    0xc(%ebp),%eax
 866:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 869:	eb 14                	jmp    87f <strchr+0x22>
    if(*s == c)
 86b:	8b 45 08             	mov    0x8(%ebp),%eax
 86e:	0f b6 00             	movzbl (%eax),%eax
 871:	38 45 fc             	cmp    %al,-0x4(%ebp)
 874:	75 05                	jne    87b <strchr+0x1e>
      return (char*)s;
 876:	8b 45 08             	mov    0x8(%ebp),%eax
 879:	eb 13                	jmp    88e <strchr+0x31>
  for(; *s; s++)
 87b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 87f:	8b 45 08             	mov    0x8(%ebp),%eax
 882:	0f b6 00             	movzbl (%eax),%eax
 885:	84 c0                	test   %al,%al
 887:	75 e2                	jne    86b <strchr+0xe>
  return 0;
 889:	b8 00 00 00 00       	mov    $0x0,%eax
}
 88e:	c9                   	leave  
 88f:	c3                   	ret    

00000890 <gets>:

char*
gets(char *buf, int max)
{
 890:	55                   	push   %ebp
 891:	89 e5                	mov    %esp,%ebp
 893:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 896:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 89d:	eb 42                	jmp    8e1 <gets+0x51>
    cc = read(0, &c, 1);
 89f:	83 ec 04             	sub    $0x4,%esp
 8a2:	6a 01                	push   $0x1
 8a4:	8d 45 ef             	lea    -0x11(%ebp),%eax
 8a7:	50                   	push   %eax
 8a8:	6a 00                	push   $0x0
 8aa:	e8 47 01 00 00       	call   9f6 <read>
 8af:	83 c4 10             	add    $0x10,%esp
 8b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 8b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 8b9:	7e 33                	jle    8ee <gets+0x5e>
      break;
    buf[i++] = c;
 8bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8be:	8d 50 01             	lea    0x1(%eax),%edx
 8c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
 8c4:	89 c2                	mov    %eax,%edx
 8c6:	8b 45 08             	mov    0x8(%ebp),%eax
 8c9:	01 c2                	add    %eax,%edx
 8cb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8cf:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 8d1:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8d5:	3c 0a                	cmp    $0xa,%al
 8d7:	74 16                	je     8ef <gets+0x5f>
 8d9:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 8dd:	3c 0d                	cmp    $0xd,%al
 8df:	74 0e                	je     8ef <gets+0x5f>
  for(i=0; i+1 < max; ){
 8e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8e4:	83 c0 01             	add    $0x1,%eax
 8e7:	39 45 0c             	cmp    %eax,0xc(%ebp)
 8ea:	7f b3                	jg     89f <gets+0xf>
 8ec:	eb 01                	jmp    8ef <gets+0x5f>
      break;
 8ee:	90                   	nop
      break;
  }
  buf[i] = '\0';
 8ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
 8f2:	8b 45 08             	mov    0x8(%ebp),%eax
 8f5:	01 d0                	add    %edx,%eax
 8f7:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 8fa:	8b 45 08             	mov    0x8(%ebp),%eax
}
 8fd:	c9                   	leave  
 8fe:	c3                   	ret    

000008ff <stat>:

int
stat(char *n, struct stat *st)
{
 8ff:	55                   	push   %ebp
 900:	89 e5                	mov    %esp,%ebp
 902:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 905:	83 ec 08             	sub    $0x8,%esp
 908:	6a 00                	push   $0x0
 90a:	ff 75 08             	push   0x8(%ebp)
 90d:	e8 0c 01 00 00       	call   a1e <open>
 912:	83 c4 10             	add    $0x10,%esp
 915:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 918:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 91c:	79 07                	jns    925 <stat+0x26>
    return -1;
 91e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 923:	eb 25                	jmp    94a <stat+0x4b>
  r = fstat(fd, st);
 925:	83 ec 08             	sub    $0x8,%esp
 928:	ff 75 0c             	push   0xc(%ebp)
 92b:	ff 75 f4             	push   -0xc(%ebp)
 92e:	e8 03 01 00 00       	call   a36 <fstat>
 933:	83 c4 10             	add    $0x10,%esp
 936:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 939:	83 ec 0c             	sub    $0xc,%esp
 93c:	ff 75 f4             	push   -0xc(%ebp)
 93f:	e8 c2 00 00 00       	call   a06 <close>
 944:	83 c4 10             	add    $0x10,%esp
  return r;
 947:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 94a:	c9                   	leave  
 94b:	c3                   	ret    

0000094c <atoi>:

int
atoi(const char *s)
{
 94c:	55                   	push   %ebp
 94d:	89 e5                	mov    %esp,%ebp
 94f:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 952:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 959:	eb 25                	jmp    980 <atoi+0x34>
    n = n*10 + *s++ - '0';
 95b:	8b 55 fc             	mov    -0x4(%ebp),%edx
 95e:	89 d0                	mov    %edx,%eax
 960:	c1 e0 02             	shl    $0x2,%eax
 963:	01 d0                	add    %edx,%eax
 965:	01 c0                	add    %eax,%eax
 967:	89 c1                	mov    %eax,%ecx
 969:	8b 45 08             	mov    0x8(%ebp),%eax
 96c:	8d 50 01             	lea    0x1(%eax),%edx
 96f:	89 55 08             	mov    %edx,0x8(%ebp)
 972:	0f b6 00             	movzbl (%eax),%eax
 975:	0f be c0             	movsbl %al,%eax
 978:	01 c8                	add    %ecx,%eax
 97a:	83 e8 30             	sub    $0x30,%eax
 97d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 980:	8b 45 08             	mov    0x8(%ebp),%eax
 983:	0f b6 00             	movzbl (%eax),%eax
 986:	3c 2f                	cmp    $0x2f,%al
 988:	7e 0a                	jle    994 <atoi+0x48>
 98a:	8b 45 08             	mov    0x8(%ebp),%eax
 98d:	0f b6 00             	movzbl (%eax),%eax
 990:	3c 39                	cmp    $0x39,%al
 992:	7e c7                	jle    95b <atoi+0xf>
  return n;
 994:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 997:	c9                   	leave  
 998:	c3                   	ret    

00000999 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 999:	55                   	push   %ebp
 99a:	89 e5                	mov    %esp,%ebp
 99c:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 99f:	8b 45 08             	mov    0x8(%ebp),%eax
 9a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 9a5:	8b 45 0c             	mov    0xc(%ebp),%eax
 9a8:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 9ab:	eb 17                	jmp    9c4 <memmove+0x2b>
    *dst++ = *src++;
 9ad:	8b 55 f8             	mov    -0x8(%ebp),%edx
 9b0:	8d 42 01             	lea    0x1(%edx),%eax
 9b3:	89 45 f8             	mov    %eax,-0x8(%ebp)
 9b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 9b9:	8d 48 01             	lea    0x1(%eax),%ecx
 9bc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 9bf:	0f b6 12             	movzbl (%edx),%edx
 9c2:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 9c4:	8b 45 10             	mov    0x10(%ebp),%eax
 9c7:	8d 50 ff             	lea    -0x1(%eax),%edx
 9ca:	89 55 10             	mov    %edx,0x10(%ebp)
 9cd:	85 c0                	test   %eax,%eax
 9cf:	7f dc                	jg     9ad <memmove+0x14>
  return vdst;
 9d1:	8b 45 08             	mov    0x8(%ebp),%eax
}
 9d4:	c9                   	leave  
 9d5:	c3                   	ret    

000009d6 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 9d6:	b8 01 00 00 00       	mov    $0x1,%eax
 9db:	cd 40                	int    $0x40
 9dd:	c3                   	ret    

000009de <exit>:
SYSCALL(exit)
 9de:	b8 02 00 00 00       	mov    $0x2,%eax
 9e3:	cd 40                	int    $0x40
 9e5:	c3                   	ret    

000009e6 <wait>:
SYSCALL(wait)
 9e6:	b8 03 00 00 00       	mov    $0x3,%eax
 9eb:	cd 40                	int    $0x40
 9ed:	c3                   	ret    

000009ee <pipe>:
SYSCALL(pipe)
 9ee:	b8 04 00 00 00       	mov    $0x4,%eax
 9f3:	cd 40                	int    $0x40
 9f5:	c3                   	ret    

000009f6 <read>:
SYSCALL(read)
 9f6:	b8 05 00 00 00       	mov    $0x5,%eax
 9fb:	cd 40                	int    $0x40
 9fd:	c3                   	ret    

000009fe <write>:
SYSCALL(write)
 9fe:	b8 10 00 00 00       	mov    $0x10,%eax
 a03:	cd 40                	int    $0x40
 a05:	c3                   	ret    

00000a06 <close>:
SYSCALL(close)
 a06:	b8 15 00 00 00       	mov    $0x15,%eax
 a0b:	cd 40                	int    $0x40
 a0d:	c3                   	ret    

00000a0e <kill>:
SYSCALL(kill)
 a0e:	b8 06 00 00 00       	mov    $0x6,%eax
 a13:	cd 40                	int    $0x40
 a15:	c3                   	ret    

00000a16 <exec>:
SYSCALL(exec)
 a16:	b8 07 00 00 00       	mov    $0x7,%eax
 a1b:	cd 40                	int    $0x40
 a1d:	c3                   	ret    

00000a1e <open>:
SYSCALL(open)
 a1e:	b8 0f 00 00 00       	mov    $0xf,%eax
 a23:	cd 40                	int    $0x40
 a25:	c3                   	ret    

00000a26 <mknod>:
SYSCALL(mknod)
 a26:	b8 11 00 00 00       	mov    $0x11,%eax
 a2b:	cd 40                	int    $0x40
 a2d:	c3                   	ret    

00000a2e <unlink>:
SYSCALL(unlink)
 a2e:	b8 12 00 00 00       	mov    $0x12,%eax
 a33:	cd 40                	int    $0x40
 a35:	c3                   	ret    

00000a36 <fstat>:
SYSCALL(fstat)
 a36:	b8 08 00 00 00       	mov    $0x8,%eax
 a3b:	cd 40                	int    $0x40
 a3d:	c3                   	ret    

00000a3e <link>:
SYSCALL(link)
 a3e:	b8 13 00 00 00       	mov    $0x13,%eax
 a43:	cd 40                	int    $0x40
 a45:	c3                   	ret    

00000a46 <mkdir>:
SYSCALL(mkdir)
 a46:	b8 14 00 00 00       	mov    $0x14,%eax
 a4b:	cd 40                	int    $0x40
 a4d:	c3                   	ret    

00000a4e <chdir>:
SYSCALL(chdir)
 a4e:	b8 09 00 00 00       	mov    $0x9,%eax
 a53:	cd 40                	int    $0x40
 a55:	c3                   	ret    

00000a56 <dup>:
SYSCALL(dup)
 a56:	b8 0a 00 00 00       	mov    $0xa,%eax
 a5b:	cd 40                	int    $0x40
 a5d:	c3                   	ret    

00000a5e <getpid>:
SYSCALL(getpid)
 a5e:	b8 0b 00 00 00       	mov    $0xb,%eax
 a63:	cd 40                	int    $0x40
 a65:	c3                   	ret    

00000a66 <sbrk>:
SYSCALL(sbrk)
 a66:	b8 0c 00 00 00       	mov    $0xc,%eax
 a6b:	cd 40                	int    $0x40
 a6d:	c3                   	ret    

00000a6e <sleep>:
SYSCALL(sleep)
 a6e:	b8 0d 00 00 00       	mov    $0xd,%eax
 a73:	cd 40                	int    $0x40
 a75:	c3                   	ret    

00000a76 <uptime>:
SYSCALL(uptime)
 a76:	b8 0e 00 00 00       	mov    $0xe,%eax
 a7b:	cd 40                	int    $0x40
 a7d:	c3                   	ret    

00000a7e <print_free_frame_cnt>:
SYSCALL(print_free_frame_cnt)  //CS 3320 project 2
 a7e:	b8 17 00 00 00       	mov    $0x17,%eax
 a83:	cd 40                	int    $0x40
 a85:	c3                   	ret    

00000a86 <set_page_allocator>:
SYSCALL(set_page_allocator) // CS 3320 project 2
 a86:	b8 18 00 00 00       	mov    $0x18,%eax
 a8b:	cd 40                	int    $0x40
 a8d:	c3                   	ret    

00000a8e <shmget>:
SYSCALL(shmget) // CS 3320 project 2
 a8e:	b8 19 00 00 00       	mov    $0x19,%eax
 a93:	cd 40                	int    $0x40
 a95:	c3                   	ret    

00000a96 <shmdel>:
SYSCALL(shmdel) // CS3320 project 2
 a96:	b8 1a 00 00 00       	mov    $0x1a,%eax
 a9b:	cd 40                	int    $0x40
 a9d:	c3                   	ret    

00000a9e <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 a9e:	55                   	push   %ebp
 a9f:	89 e5                	mov    %esp,%ebp
 aa1:	83 ec 18             	sub    $0x18,%esp
 aa4:	8b 45 0c             	mov    0xc(%ebp),%eax
 aa7:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 aaa:	83 ec 04             	sub    $0x4,%esp
 aad:	6a 01                	push   $0x1
 aaf:	8d 45 f4             	lea    -0xc(%ebp),%eax
 ab2:	50                   	push   %eax
 ab3:	ff 75 08             	push   0x8(%ebp)
 ab6:	e8 43 ff ff ff       	call   9fe <write>
 abb:	83 c4 10             	add    $0x10,%esp
}
 abe:	90                   	nop
 abf:	c9                   	leave  
 ac0:	c3                   	ret    

00000ac1 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 ac1:	55                   	push   %ebp
 ac2:	89 e5                	mov    %esp,%ebp
 ac4:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 ac7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 ace:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 ad2:	74 17                	je     aeb <printint+0x2a>
 ad4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 ad8:	79 11                	jns    aeb <printint+0x2a>
    neg = 1;
 ada:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
 ae4:	f7 d8                	neg    %eax
 ae6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 ae9:	eb 06                	jmp    af1 <printint+0x30>
  } else {
    x = xx;
 aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
 aee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 af1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 af8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
 afe:	ba 00 00 00 00       	mov    $0x0,%edx
 b03:	f7 f1                	div    %ecx
 b05:	89 d1                	mov    %edx,%ecx
 b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b0a:	8d 50 01             	lea    0x1(%eax),%edx
 b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 b10:	0f b6 91 b0 16 00 00 	movzbl 0x16b0(%ecx),%edx
 b17:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 b1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
 b21:	ba 00 00 00 00       	mov    $0x0,%edx
 b26:	f7 f1                	div    %ecx
 b28:	89 45 ec             	mov    %eax,-0x14(%ebp)
 b2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 b2f:	75 c7                	jne    af8 <printint+0x37>
  if(neg)
 b31:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 b35:	74 2d                	je     b64 <printint+0xa3>
    buf[i++] = '-';
 b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b3a:	8d 50 01             	lea    0x1(%eax),%edx
 b3d:	89 55 f4             	mov    %edx,-0xc(%ebp)
 b40:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 b45:	eb 1d                	jmp    b64 <printint+0xa3>
    putc(fd, buf[i]);
 b47:	8d 55 dc             	lea    -0x24(%ebp),%edx
 b4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 b4d:	01 d0                	add    %edx,%eax
 b4f:	0f b6 00             	movzbl (%eax),%eax
 b52:	0f be c0             	movsbl %al,%eax
 b55:	83 ec 08             	sub    $0x8,%esp
 b58:	50                   	push   %eax
 b59:	ff 75 08             	push   0x8(%ebp)
 b5c:	e8 3d ff ff ff       	call   a9e <putc>
 b61:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 b64:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 b68:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 b6c:	79 d9                	jns    b47 <printint+0x86>
}
 b6e:	90                   	nop
 b6f:	90                   	nop
 b70:	c9                   	leave  
 b71:	c3                   	ret    

00000b72 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 b72:	55                   	push   %ebp
 b73:	89 e5                	mov    %esp,%ebp
 b75:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 b78:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 b7f:	8d 45 0c             	lea    0xc(%ebp),%eax
 b82:	83 c0 04             	add    $0x4,%eax
 b85:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 b88:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 b8f:	e9 59 01 00 00       	jmp    ced <printf+0x17b>
    c = fmt[i] & 0xff;
 b94:	8b 55 0c             	mov    0xc(%ebp),%edx
 b97:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b9a:	01 d0                	add    %edx,%eax
 b9c:	0f b6 00             	movzbl (%eax),%eax
 b9f:	0f be c0             	movsbl %al,%eax
 ba2:	25 ff 00 00 00       	and    $0xff,%eax
 ba7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 baa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 bae:	75 2c                	jne    bdc <printf+0x6a>
      if(c == '%'){
 bb0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 bb4:	75 0c                	jne    bc2 <printf+0x50>
        state = '%';
 bb6:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 bbd:	e9 27 01 00 00       	jmp    ce9 <printf+0x177>
      } else {
        putc(fd, c);
 bc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 bc5:	0f be c0             	movsbl %al,%eax
 bc8:	83 ec 08             	sub    $0x8,%esp
 bcb:	50                   	push   %eax
 bcc:	ff 75 08             	push   0x8(%ebp)
 bcf:	e8 ca fe ff ff       	call   a9e <putc>
 bd4:	83 c4 10             	add    $0x10,%esp
 bd7:	e9 0d 01 00 00       	jmp    ce9 <printf+0x177>
      }
    } else if(state == '%'){
 bdc:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 be0:	0f 85 03 01 00 00    	jne    ce9 <printf+0x177>
      if(c == 'd'){
 be6:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 bea:	75 1e                	jne    c0a <printf+0x98>
        printint(fd, *ap, 10, 1);
 bec:	8b 45 e8             	mov    -0x18(%ebp),%eax
 bef:	8b 00                	mov    (%eax),%eax
 bf1:	6a 01                	push   $0x1
 bf3:	6a 0a                	push   $0xa
 bf5:	50                   	push   %eax
 bf6:	ff 75 08             	push   0x8(%ebp)
 bf9:	e8 c3 fe ff ff       	call   ac1 <printint>
 bfe:	83 c4 10             	add    $0x10,%esp
        ap++;
 c01:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c05:	e9 d8 00 00 00       	jmp    ce2 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 c0a:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 c0e:	74 06                	je     c16 <printf+0xa4>
 c10:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 c14:	75 1e                	jne    c34 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 c16:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c19:	8b 00                	mov    (%eax),%eax
 c1b:	6a 00                	push   $0x0
 c1d:	6a 10                	push   $0x10
 c1f:	50                   	push   %eax
 c20:	ff 75 08             	push   0x8(%ebp)
 c23:	e8 99 fe ff ff       	call   ac1 <printint>
 c28:	83 c4 10             	add    $0x10,%esp
        ap++;
 c2b:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c2f:	e9 ae 00 00 00       	jmp    ce2 <printf+0x170>
      } else if(c == 's'){
 c34:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 c38:	75 43                	jne    c7d <printf+0x10b>
        s = (char*)*ap;
 c3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c3d:	8b 00                	mov    (%eax),%eax
 c3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 c42:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 c46:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 c4a:	75 25                	jne    c71 <printf+0xff>
          s = "(null)";
 c4c:	c7 45 f4 42 14 00 00 	movl   $0x1442,-0xc(%ebp)
        while(*s != 0){
 c53:	eb 1c                	jmp    c71 <printf+0xff>
          putc(fd, *s);
 c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c58:	0f b6 00             	movzbl (%eax),%eax
 c5b:	0f be c0             	movsbl %al,%eax
 c5e:	83 ec 08             	sub    $0x8,%esp
 c61:	50                   	push   %eax
 c62:	ff 75 08             	push   0x8(%ebp)
 c65:	e8 34 fe ff ff       	call   a9e <putc>
 c6a:	83 c4 10             	add    $0x10,%esp
          s++;
 c6d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c74:	0f b6 00             	movzbl (%eax),%eax
 c77:	84 c0                	test   %al,%al
 c79:	75 da                	jne    c55 <printf+0xe3>
 c7b:	eb 65                	jmp    ce2 <printf+0x170>
        }
      } else if(c == 'c'){
 c7d:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 c81:	75 1d                	jne    ca0 <printf+0x12e>
        putc(fd, *ap);
 c83:	8b 45 e8             	mov    -0x18(%ebp),%eax
 c86:	8b 00                	mov    (%eax),%eax
 c88:	0f be c0             	movsbl %al,%eax
 c8b:	83 ec 08             	sub    $0x8,%esp
 c8e:	50                   	push   %eax
 c8f:	ff 75 08             	push   0x8(%ebp)
 c92:	e8 07 fe ff ff       	call   a9e <putc>
 c97:	83 c4 10             	add    $0x10,%esp
        ap++;
 c9a:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 c9e:	eb 42                	jmp    ce2 <printf+0x170>
      } else if(c == '%'){
 ca0:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 ca4:	75 17                	jne    cbd <printf+0x14b>
        putc(fd, c);
 ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 ca9:	0f be c0             	movsbl %al,%eax
 cac:	83 ec 08             	sub    $0x8,%esp
 caf:	50                   	push   %eax
 cb0:	ff 75 08             	push   0x8(%ebp)
 cb3:	e8 e6 fd ff ff       	call   a9e <putc>
 cb8:	83 c4 10             	add    $0x10,%esp
 cbb:	eb 25                	jmp    ce2 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 cbd:	83 ec 08             	sub    $0x8,%esp
 cc0:	6a 25                	push   $0x25
 cc2:	ff 75 08             	push   0x8(%ebp)
 cc5:	e8 d4 fd ff ff       	call   a9e <putc>
 cca:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 ccd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 cd0:	0f be c0             	movsbl %al,%eax
 cd3:	83 ec 08             	sub    $0x8,%esp
 cd6:	50                   	push   %eax
 cd7:	ff 75 08             	push   0x8(%ebp)
 cda:	e8 bf fd ff ff       	call   a9e <putc>
 cdf:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 ce2:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 ce9:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 ced:	8b 55 0c             	mov    0xc(%ebp),%edx
 cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cf3:	01 d0                	add    %edx,%eax
 cf5:	0f b6 00             	movzbl (%eax),%eax
 cf8:	84 c0                	test   %al,%al
 cfa:	0f 85 94 fe ff ff    	jne    b94 <printf+0x22>
    }
  }
}
 d00:	90                   	nop
 d01:	90                   	nop
 d02:	c9                   	leave  
 d03:	c3                   	ret    

00000d04 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 d04:	55                   	push   %ebp
 d05:	89 e5                	mov    %esp,%ebp
 d07:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 d0a:	8b 45 08             	mov    0x8(%ebp),%eax
 d0d:	83 e8 08             	sub    $0x8,%eax
 d10:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d13:	a1 cc 16 00 00       	mov    0x16cc,%eax
 d18:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d1b:	eb 24                	jmp    d41 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d20:	8b 00                	mov    (%eax),%eax
 d22:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 d25:	72 12                	jb     d39 <free+0x35>
 d27:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d2a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d2d:	77 24                	ja     d53 <free+0x4f>
 d2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d32:	8b 00                	mov    (%eax),%eax
 d34:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 d37:	72 1a                	jb     d53 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 d39:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d3c:	8b 00                	mov    (%eax),%eax
 d3e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 d41:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d44:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 d47:	76 d4                	jbe    d1d <free+0x19>
 d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d4c:	8b 00                	mov    (%eax),%eax
 d4e:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 d51:	73 ca                	jae    d1d <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 d53:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d56:	8b 40 04             	mov    0x4(%eax),%eax
 d59:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 d60:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d63:	01 c2                	add    %eax,%edx
 d65:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d68:	8b 00                	mov    (%eax),%eax
 d6a:	39 c2                	cmp    %eax,%edx
 d6c:	75 24                	jne    d92 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 d6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d71:	8b 50 04             	mov    0x4(%eax),%edx
 d74:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d77:	8b 00                	mov    (%eax),%eax
 d79:	8b 40 04             	mov    0x4(%eax),%eax
 d7c:	01 c2                	add    %eax,%edx
 d7e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d81:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d87:	8b 00                	mov    (%eax),%eax
 d89:	8b 10                	mov    (%eax),%edx
 d8b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d8e:	89 10                	mov    %edx,(%eax)
 d90:	eb 0a                	jmp    d9c <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 d92:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d95:	8b 10                	mov    (%eax),%edx
 d97:	8b 45 f8             	mov    -0x8(%ebp),%eax
 d9a:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 d9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 d9f:	8b 40 04             	mov    0x4(%eax),%eax
 da2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dac:	01 d0                	add    %edx,%eax
 dae:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 db1:	75 20                	jne    dd3 <free+0xcf>
    p->s.size += bp->s.size;
 db3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 db6:	8b 50 04             	mov    0x4(%eax),%edx
 db9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dbc:	8b 40 04             	mov    0x4(%eax),%eax
 dbf:	01 c2                	add    %eax,%edx
 dc1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dc4:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 dc7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 dca:	8b 10                	mov    (%eax),%edx
 dcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dcf:	89 10                	mov    %edx,(%eax)
 dd1:	eb 08                	jmp    ddb <free+0xd7>
  } else
    p->s.ptr = bp;
 dd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dd6:	8b 55 f8             	mov    -0x8(%ebp),%edx
 dd9:	89 10                	mov    %edx,(%eax)
  freep = p;
 ddb:	8b 45 fc             	mov    -0x4(%ebp),%eax
 dde:	a3 cc 16 00 00       	mov    %eax,0x16cc
}
 de3:	90                   	nop
 de4:	c9                   	leave  
 de5:	c3                   	ret    

00000de6 <morecore>:

static Header*
morecore(uint nu)
{
 de6:	55                   	push   %ebp
 de7:	89 e5                	mov    %esp,%ebp
 de9:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 dec:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 df3:	77 07                	ja     dfc <morecore+0x16>
    nu = 4096;
 df5:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 dfc:	8b 45 08             	mov    0x8(%ebp),%eax
 dff:	c1 e0 03             	shl    $0x3,%eax
 e02:	83 ec 0c             	sub    $0xc,%esp
 e05:	50                   	push   %eax
 e06:	e8 5b fc ff ff       	call   a66 <sbrk>
 e0b:	83 c4 10             	add    $0x10,%esp
 e0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 e11:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 e15:	75 07                	jne    e1e <morecore+0x38>
    return 0;
 e17:	b8 00 00 00 00       	mov    $0x0,%eax
 e1c:	eb 26                	jmp    e44 <morecore+0x5e>
  hp = (Header*)p;
 e1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e21:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 e24:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e27:	8b 55 08             	mov    0x8(%ebp),%edx
 e2a:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 e2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e30:	83 c0 08             	add    $0x8,%eax
 e33:	83 ec 0c             	sub    $0xc,%esp
 e36:	50                   	push   %eax
 e37:	e8 c8 fe ff ff       	call   d04 <free>
 e3c:	83 c4 10             	add    $0x10,%esp
  return freep;
 e3f:	a1 cc 16 00 00       	mov    0x16cc,%eax
}
 e44:	c9                   	leave  
 e45:	c3                   	ret    

00000e46 <malloc>:

void*
malloc(uint nbytes)
{
 e46:	55                   	push   %ebp
 e47:	89 e5                	mov    %esp,%ebp
 e49:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e4c:	8b 45 08             	mov    0x8(%ebp),%eax
 e4f:	83 c0 07             	add    $0x7,%eax
 e52:	c1 e8 03             	shr    $0x3,%eax
 e55:	83 c0 01             	add    $0x1,%eax
 e58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 e5b:	a1 cc 16 00 00       	mov    0x16cc,%eax
 e60:	89 45 f0             	mov    %eax,-0x10(%ebp)
 e63:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 e67:	75 23                	jne    e8c <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 e69:	c7 45 f0 c4 16 00 00 	movl   $0x16c4,-0x10(%ebp)
 e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e73:	a3 cc 16 00 00       	mov    %eax,0x16cc
 e78:	a1 cc 16 00 00       	mov    0x16cc,%eax
 e7d:	a3 c4 16 00 00       	mov    %eax,0x16c4
    base.s.size = 0;
 e82:	c7 05 c8 16 00 00 00 	movl   $0x0,0x16c8
 e89:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 e8f:	8b 00                	mov    (%eax),%eax
 e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
 e97:	8b 40 04             	mov    0x4(%eax),%eax
 e9a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 e9d:	77 4d                	ja     eec <malloc+0xa6>
      if(p->s.size == nunits)
 e9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ea2:	8b 40 04             	mov    0x4(%eax),%eax
 ea5:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 ea8:	75 0c                	jne    eb6 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ead:	8b 10                	mov    (%eax),%edx
 eaf:	8b 45 f0             	mov    -0x10(%ebp),%eax
 eb2:	89 10                	mov    %edx,(%eax)
 eb4:	eb 26                	jmp    edc <malloc+0x96>
      else {
        p->s.size -= nunits;
 eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eb9:	8b 40 04             	mov    0x4(%eax),%eax
 ebc:	2b 45 ec             	sub    -0x14(%ebp),%eax
 ebf:	89 c2                	mov    %eax,%edx
 ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ec4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
 eca:	8b 40 04             	mov    0x4(%eax),%eax
 ecd:	c1 e0 03             	shl    $0x3,%eax
 ed0:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ed6:	8b 55 ec             	mov    -0x14(%ebp),%edx
 ed9:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 edc:	8b 45 f0             	mov    -0x10(%ebp),%eax
 edf:	a3 cc 16 00 00       	mov    %eax,0x16cc
      return (void*)(p + 1);
 ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ee7:	83 c0 08             	add    $0x8,%eax
 eea:	eb 3b                	jmp    f27 <malloc+0xe1>
    }
    if(p == freep)
 eec:	a1 cc 16 00 00       	mov    0x16cc,%eax
 ef1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 ef4:	75 1e                	jne    f14 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ef6:	83 ec 0c             	sub    $0xc,%esp
 ef9:	ff 75 ec             	push   -0x14(%ebp)
 efc:	e8 e5 fe ff ff       	call   de6 <morecore>
 f01:	83 c4 10             	add    $0x10,%esp
 f04:	89 45 f4             	mov    %eax,-0xc(%ebp)
 f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 f0b:	75 07                	jne    f14 <malloc+0xce>
        return 0;
 f0d:	b8 00 00 00 00       	mov    $0x0,%eax
 f12:	eb 13                	jmp    f27 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f14:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f17:	89 45 f0             	mov    %eax,-0x10(%ebp)
 f1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 f1d:	8b 00                	mov    (%eax),%eax
 f1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 f22:	e9 6d ff ff ff       	jmp    e94 <malloc+0x4e>
  }
}
 f27:	c9                   	leave  
 f28:	c3                   	ret    
