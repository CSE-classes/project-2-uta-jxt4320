
_ln:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	89 cb                	mov    %ecx,%ebx
  if(argc != 3){
  11:	83 3b 03             	cmpl   $0x3,(%ebx)
  14:	74 17                	je     2d <main+0x2d>
    printf(2, "Usage: ln old new\n");
  16:	83 ec 08             	sub    $0x8,%esp
  19:	68 16 08 00 00       	push   $0x816
  1e:	6a 02                	push   $0x2
  20:	e8 3a 04 00 00       	call   45f <printf>
  25:	83 c4 10             	add    $0x10,%esp
    exit();
  28:	e8 9e 02 00 00       	call   2cb <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2d:	8b 43 04             	mov    0x4(%ebx),%eax
  30:	83 c0 08             	add    $0x8,%eax
  33:	8b 10                	mov    (%eax),%edx
  35:	8b 43 04             	mov    0x4(%ebx),%eax
  38:	83 c0 04             	add    $0x4,%eax
  3b:	8b 00                	mov    (%eax),%eax
  3d:	83 ec 08             	sub    $0x8,%esp
  40:	52                   	push   %edx
  41:	50                   	push   %eax
  42:	e8 e4 02 00 00       	call   32b <link>
  47:	83 c4 10             	add    $0x10,%esp
  4a:	85 c0                	test   %eax,%eax
  4c:	79 21                	jns    6f <main+0x6f>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  4e:	8b 43 04             	mov    0x4(%ebx),%eax
  51:	83 c0 08             	add    $0x8,%eax
  54:	8b 10                	mov    (%eax),%edx
  56:	8b 43 04             	mov    0x4(%ebx),%eax
  59:	83 c0 04             	add    $0x4,%eax
  5c:	8b 00                	mov    (%eax),%eax
  5e:	52                   	push   %edx
  5f:	50                   	push   %eax
  60:	68 29 08 00 00       	push   $0x829
  65:	6a 02                	push   $0x2
  67:	e8 f3 03 00 00       	call   45f <printf>
  6c:	83 c4 10             	add    $0x10,%esp
  exit();
  6f:	e8 57 02 00 00       	call   2cb <exit>

00000074 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
  79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7c:	8b 55 10             	mov    0x10(%ebp),%edx
  7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  82:	89 cb                	mov    %ecx,%ebx
  84:	89 df                	mov    %ebx,%edi
  86:	89 d1                	mov    %edx,%ecx
  88:	fc                   	cld    
  89:	f3 aa                	rep stos %al,%es:(%edi)
  8b:	89 ca                	mov    %ecx,%edx
  8d:	89 fb                	mov    %edi,%ebx
  8f:	89 5d 08             	mov    %ebx,0x8(%ebp)
  92:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
  95:	90                   	nop
  96:	5b                   	pop    %ebx
  97:	5f                   	pop    %edi
  98:	5d                   	pop    %ebp
  99:	c3                   	ret    

0000009a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
  9a:	55                   	push   %ebp
  9b:	89 e5                	mov    %esp,%ebp
  9d:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
  a0:	8b 45 08             	mov    0x8(%ebp),%eax
  a3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
  a6:	90                   	nop
  a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  aa:	8d 42 01             	lea    0x1(%edx),%eax
  ad:	89 45 0c             	mov    %eax,0xc(%ebp)
  b0:	8b 45 08             	mov    0x8(%ebp),%eax
  b3:	8d 48 01             	lea    0x1(%eax),%ecx
  b6:	89 4d 08             	mov    %ecx,0x8(%ebp)
  b9:	0f b6 12             	movzbl (%edx),%edx
  bc:	88 10                	mov    %dl,(%eax)
  be:	0f b6 00             	movzbl (%eax),%eax
  c1:	84 c0                	test   %al,%al
  c3:	75 e2                	jne    a7 <strcpy+0xd>
    ;
  return os;
  c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strcmp>:

int
strcmp(const char *p, const char *q)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
  cd:	eb 08                	jmp    d7 <strcmp+0xd>
    p++, q++;
  cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  d3:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	0f b6 00             	movzbl (%eax),%eax
  dd:	84 c0                	test   %al,%al
  df:	74 10                	je     f1 <strcmp+0x27>
  e1:	8b 45 08             	mov    0x8(%ebp),%eax
  e4:	0f b6 10             	movzbl (%eax),%edx
  e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  ea:	0f b6 00             	movzbl (%eax),%eax
  ed:	38 c2                	cmp    %al,%dl
  ef:	74 de                	je     cf <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 00             	movzbl (%eax),%eax
  f7:	0f b6 d0             	movzbl %al,%edx
  fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  fd:	0f b6 00             	movzbl (%eax),%eax
 100:	0f b6 c8             	movzbl %al,%ecx
 103:	89 d0                	mov    %edx,%eax
 105:	29 c8                	sub    %ecx,%eax
}
 107:	5d                   	pop    %ebp
 108:	c3                   	ret    

00000109 <strlen>:

uint
strlen(char *s)
{
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 10f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 116:	eb 04                	jmp    11c <strlen+0x13>
 118:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 11c:	8b 55 fc             	mov    -0x4(%ebp),%edx
 11f:	8b 45 08             	mov    0x8(%ebp),%eax
 122:	01 d0                	add    %edx,%eax
 124:	0f b6 00             	movzbl (%eax),%eax
 127:	84 c0                	test   %al,%al
 129:	75 ed                	jne    118 <strlen+0xf>
    ;
  return n;
 12b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 12e:	c9                   	leave  
 12f:	c3                   	ret    

00000130 <memset>:

void*
memset(void *dst, int c, uint n)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 133:	8b 45 10             	mov    0x10(%ebp),%eax
 136:	50                   	push   %eax
 137:	ff 75 0c             	push   0xc(%ebp)
 13a:	ff 75 08             	push   0x8(%ebp)
 13d:	e8 32 ff ff ff       	call   74 <stosb>
 142:	83 c4 0c             	add    $0xc,%esp
  return dst;
 145:	8b 45 08             	mov    0x8(%ebp),%eax
}
 148:	c9                   	leave  
 149:	c3                   	ret    

0000014a <strchr>:

char*
strchr(const char *s, char c)
{
 14a:	55                   	push   %ebp
 14b:	89 e5                	mov    %esp,%ebp
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	8b 45 0c             	mov    0xc(%ebp),%eax
 153:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 156:	eb 14                	jmp    16c <strchr+0x22>
    if(*s == c)
 158:	8b 45 08             	mov    0x8(%ebp),%eax
 15b:	0f b6 00             	movzbl (%eax),%eax
 15e:	38 45 fc             	cmp    %al,-0x4(%ebp)
 161:	75 05                	jne    168 <strchr+0x1e>
      return (char*)s;
 163:	8b 45 08             	mov    0x8(%ebp),%eax
 166:	eb 13                	jmp    17b <strchr+0x31>
  for(; *s; s++)
 168:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16c:	8b 45 08             	mov    0x8(%ebp),%eax
 16f:	0f b6 00             	movzbl (%eax),%eax
 172:	84 c0                	test   %al,%al
 174:	75 e2                	jne    158 <strchr+0xe>
  return 0;
 176:	b8 00 00 00 00       	mov    $0x0,%eax
}
 17b:	c9                   	leave  
 17c:	c3                   	ret    

0000017d <gets>:

char*
gets(char *buf, int max)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 183:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 18a:	eb 42                	jmp    1ce <gets+0x51>
    cc = read(0, &c, 1);
 18c:	83 ec 04             	sub    $0x4,%esp
 18f:	6a 01                	push   $0x1
 191:	8d 45 ef             	lea    -0x11(%ebp),%eax
 194:	50                   	push   %eax
 195:	6a 00                	push   $0x0
 197:	e8 47 01 00 00       	call   2e3 <read>
 19c:	83 c4 10             	add    $0x10,%esp
 19f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 1a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 1a6:	7e 33                	jle    1db <gets+0x5e>
      break;
    buf[i++] = c;
 1a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1ab:	8d 50 01             	lea    0x1(%eax),%edx
 1ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
 1b1:	89 c2                	mov    %eax,%edx
 1b3:	8b 45 08             	mov    0x8(%ebp),%eax
 1b6:	01 c2                	add    %eax,%edx
 1b8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1bc:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 1be:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1c2:	3c 0a                	cmp    $0xa,%al
 1c4:	74 16                	je     1dc <gets+0x5f>
 1c6:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 1ca:	3c 0d                	cmp    $0xd,%al
 1cc:	74 0e                	je     1dc <gets+0x5f>
  for(i=0; i+1 < max; ){
 1ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
 1d1:	83 c0 01             	add    $0x1,%eax
 1d4:	39 45 0c             	cmp    %eax,0xc(%ebp)
 1d7:	7f b3                	jg     18c <gets+0xf>
 1d9:	eb 01                	jmp    1dc <gets+0x5f>
      break;
 1db:	90                   	nop
      break;
  }
  buf[i] = '\0';
 1dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
 1df:	8b 45 08             	mov    0x8(%ebp),%eax
 1e2:	01 d0                	add    %edx,%eax
 1e4:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 1e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1ea:	c9                   	leave  
 1eb:	c3                   	ret    

000001ec <stat>:

int
stat(char *n, struct stat *st)
{
 1ec:	55                   	push   %ebp
 1ed:	89 e5                	mov    %esp,%ebp
 1ef:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	6a 00                	push   $0x0
 1f7:	ff 75 08             	push   0x8(%ebp)
 1fa:	e8 0c 01 00 00       	call   30b <open>
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 205:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 209:	79 07                	jns    212 <stat+0x26>
    return -1;
 20b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 210:	eb 25                	jmp    237 <stat+0x4b>
  r = fstat(fd, st);
 212:	83 ec 08             	sub    $0x8,%esp
 215:	ff 75 0c             	push   0xc(%ebp)
 218:	ff 75 f4             	push   -0xc(%ebp)
 21b:	e8 03 01 00 00       	call   323 <fstat>
 220:	83 c4 10             	add    $0x10,%esp
 223:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 226:	83 ec 0c             	sub    $0xc,%esp
 229:	ff 75 f4             	push   -0xc(%ebp)
 22c:	e8 c2 00 00 00       	call   2f3 <close>
 231:	83 c4 10             	add    $0x10,%esp
  return r;
 234:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 237:	c9                   	leave  
 238:	c3                   	ret    

00000239 <atoi>:

int
atoi(const char *s)
{
 239:	55                   	push   %ebp
 23a:	89 e5                	mov    %esp,%ebp
 23c:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 23f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 246:	eb 25                	jmp    26d <atoi+0x34>
    n = n*10 + *s++ - '0';
 248:	8b 55 fc             	mov    -0x4(%ebp),%edx
 24b:	89 d0                	mov    %edx,%eax
 24d:	c1 e0 02             	shl    $0x2,%eax
 250:	01 d0                	add    %edx,%eax
 252:	01 c0                	add    %eax,%eax
 254:	89 c1                	mov    %eax,%ecx
 256:	8b 45 08             	mov    0x8(%ebp),%eax
 259:	8d 50 01             	lea    0x1(%eax),%edx
 25c:	89 55 08             	mov    %edx,0x8(%ebp)
 25f:	0f b6 00             	movzbl (%eax),%eax
 262:	0f be c0             	movsbl %al,%eax
 265:	01 c8                	add    %ecx,%eax
 267:	83 e8 30             	sub    $0x30,%eax
 26a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 26d:	8b 45 08             	mov    0x8(%ebp),%eax
 270:	0f b6 00             	movzbl (%eax),%eax
 273:	3c 2f                	cmp    $0x2f,%al
 275:	7e 0a                	jle    281 <atoi+0x48>
 277:	8b 45 08             	mov    0x8(%ebp),%eax
 27a:	0f b6 00             	movzbl (%eax),%eax
 27d:	3c 39                	cmp    $0x39,%al
 27f:	7e c7                	jle    248 <atoi+0xf>
  return n;
 281:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 284:	c9                   	leave  
 285:	c3                   	ret    

00000286 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 286:	55                   	push   %ebp
 287:	89 e5                	mov    %esp,%ebp
 289:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 28c:	8b 45 08             	mov    0x8(%ebp),%eax
 28f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 292:	8b 45 0c             	mov    0xc(%ebp),%eax
 295:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 298:	eb 17                	jmp    2b1 <memmove+0x2b>
    *dst++ = *src++;
 29a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 29d:	8d 42 01             	lea    0x1(%edx),%eax
 2a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
 2a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
 2a6:	8d 48 01             	lea    0x1(%eax),%ecx
 2a9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 2ac:	0f b6 12             	movzbl (%edx),%edx
 2af:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 2b1:	8b 45 10             	mov    0x10(%ebp),%eax
 2b4:	8d 50 ff             	lea    -0x1(%eax),%edx
 2b7:	89 55 10             	mov    %edx,0x10(%ebp)
 2ba:	85 c0                	test   %eax,%eax
 2bc:	7f dc                	jg     29a <memmove+0x14>
  return vdst;
 2be:	8b 45 08             	mov    0x8(%ebp),%eax
}
 2c1:	c9                   	leave  
 2c2:	c3                   	ret    

000002c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c3:	b8 01 00 00 00       	mov    $0x1,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exit>:
SYSCALL(exit)
 2cb:	b8 02 00 00 00       	mov    $0x2,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <wait>:
SYSCALL(wait)
 2d3:	b8 03 00 00 00       	mov    $0x3,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <pipe>:
SYSCALL(pipe)
 2db:	b8 04 00 00 00       	mov    $0x4,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <read>:
SYSCALL(read)
 2e3:	b8 05 00 00 00       	mov    $0x5,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <write>:
SYSCALL(write)
 2eb:	b8 10 00 00 00       	mov    $0x10,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <close>:
SYSCALL(close)
 2f3:	b8 15 00 00 00       	mov    $0x15,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <kill>:
SYSCALL(kill)
 2fb:	b8 06 00 00 00       	mov    $0x6,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <exec>:
SYSCALL(exec)
 303:	b8 07 00 00 00       	mov    $0x7,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <open>:
SYSCALL(open)
 30b:	b8 0f 00 00 00       	mov    $0xf,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <mknod>:
SYSCALL(mknod)
 313:	b8 11 00 00 00       	mov    $0x11,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <unlink>:
SYSCALL(unlink)
 31b:	b8 12 00 00 00       	mov    $0x12,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <fstat>:
SYSCALL(fstat)
 323:	b8 08 00 00 00       	mov    $0x8,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <link>:
SYSCALL(link)
 32b:	b8 13 00 00 00       	mov    $0x13,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <mkdir>:
SYSCALL(mkdir)
 333:	b8 14 00 00 00       	mov    $0x14,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <chdir>:
SYSCALL(chdir)
 33b:	b8 09 00 00 00       	mov    $0x9,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <dup>:
SYSCALL(dup)
 343:	b8 0a 00 00 00       	mov    $0xa,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <getpid>:
SYSCALL(getpid)
 34b:	b8 0b 00 00 00       	mov    $0xb,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <sbrk>:
SYSCALL(sbrk)
 353:	b8 0c 00 00 00       	mov    $0xc,%eax
 358:	cd 40                	int    $0x40
 35a:	c3                   	ret    

0000035b <sleep>:
SYSCALL(sleep)
 35b:	b8 0d 00 00 00       	mov    $0xd,%eax
 360:	cd 40                	int    $0x40
 362:	c3                   	ret    

00000363 <uptime>:
SYSCALL(uptime)
 363:	b8 0e 00 00 00       	mov    $0xe,%eax
 368:	cd 40                	int    $0x40
 36a:	c3                   	ret    

0000036b <print_free_frame_cnt>:
SYSCALL(print_free_frame_cnt)  //CS 3320 project 2
 36b:	b8 17 00 00 00       	mov    $0x17,%eax
 370:	cd 40                	int    $0x40
 372:	c3                   	ret    

00000373 <set_page_allocator>:
SYSCALL(set_page_allocator) // CS 3320 project 2
 373:	b8 18 00 00 00       	mov    $0x18,%eax
 378:	cd 40                	int    $0x40
 37a:	c3                   	ret    

0000037b <shmget>:
SYSCALL(shmget) // CS 3320 project 2
 37b:	b8 19 00 00 00       	mov    $0x19,%eax
 380:	cd 40                	int    $0x40
 382:	c3                   	ret    

00000383 <shmdel>:
SYSCALL(shmdel) // CS3320 project 2
 383:	b8 1a 00 00 00       	mov    $0x1a,%eax
 388:	cd 40                	int    $0x40
 38a:	c3                   	ret    

0000038b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 38b:	55                   	push   %ebp
 38c:	89 e5                	mov    %esp,%ebp
 38e:	83 ec 18             	sub    $0x18,%esp
 391:	8b 45 0c             	mov    0xc(%ebp),%eax
 394:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 397:	83 ec 04             	sub    $0x4,%esp
 39a:	6a 01                	push   $0x1
 39c:	8d 45 f4             	lea    -0xc(%ebp),%eax
 39f:	50                   	push   %eax
 3a0:	ff 75 08             	push   0x8(%ebp)
 3a3:	e8 43 ff ff ff       	call   2eb <write>
 3a8:	83 c4 10             	add    $0x10,%esp
}
 3ab:	90                   	nop
 3ac:	c9                   	leave  
 3ad:	c3                   	ret    

000003ae <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3ae:	55                   	push   %ebp
 3af:	89 e5                	mov    %esp,%ebp
 3b1:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3b4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 3bb:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3bf:	74 17                	je     3d8 <printint+0x2a>
 3c1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 3c5:	79 11                	jns    3d8 <printint+0x2a>
    neg = 1;
 3c7:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 3ce:	8b 45 0c             	mov    0xc(%ebp),%eax
 3d1:	f7 d8                	neg    %eax
 3d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 3d6:	eb 06                	jmp    3de <printint+0x30>
  } else {
    x = xx;
 3d8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3db:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 3de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 3e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
 3e8:	8b 45 ec             	mov    -0x14(%ebp),%eax
 3eb:	ba 00 00 00 00       	mov    $0x0,%edx
 3f0:	f7 f1                	div    %ecx
 3f2:	89 d1                	mov    %edx,%ecx
 3f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 3f7:	8d 50 01             	lea    0x1(%eax),%edx
 3fa:	89 55 f4             	mov    %edx,-0xc(%ebp)
 3fd:	0f b6 91 8c 0a 00 00 	movzbl 0xa8c(%ecx),%edx
 404:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 408:	8b 4d 10             	mov    0x10(%ebp),%ecx
 40b:	8b 45 ec             	mov    -0x14(%ebp),%eax
 40e:	ba 00 00 00 00       	mov    $0x0,%edx
 413:	f7 f1                	div    %ecx
 415:	89 45 ec             	mov    %eax,-0x14(%ebp)
 418:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 41c:	75 c7                	jne    3e5 <printint+0x37>
  if(neg)
 41e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 422:	74 2d                	je     451 <printint+0xa3>
    buf[i++] = '-';
 424:	8b 45 f4             	mov    -0xc(%ebp),%eax
 427:	8d 50 01             	lea    0x1(%eax),%edx
 42a:	89 55 f4             	mov    %edx,-0xc(%ebp)
 42d:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 432:	eb 1d                	jmp    451 <printint+0xa3>
    putc(fd, buf[i]);
 434:	8d 55 dc             	lea    -0x24(%ebp),%edx
 437:	8b 45 f4             	mov    -0xc(%ebp),%eax
 43a:	01 d0                	add    %edx,%eax
 43c:	0f b6 00             	movzbl (%eax),%eax
 43f:	0f be c0             	movsbl %al,%eax
 442:	83 ec 08             	sub    $0x8,%esp
 445:	50                   	push   %eax
 446:	ff 75 08             	push   0x8(%ebp)
 449:	e8 3d ff ff ff       	call   38b <putc>
 44e:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 451:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 455:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 459:	79 d9                	jns    434 <printint+0x86>
}
 45b:	90                   	nop
 45c:	90                   	nop
 45d:	c9                   	leave  
 45e:	c3                   	ret    

0000045f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 45f:	55                   	push   %ebp
 460:	89 e5                	mov    %esp,%ebp
 462:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 465:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 46c:	8d 45 0c             	lea    0xc(%ebp),%eax
 46f:	83 c0 04             	add    $0x4,%eax
 472:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 475:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 47c:	e9 59 01 00 00       	jmp    5da <printf+0x17b>
    c = fmt[i] & 0xff;
 481:	8b 55 0c             	mov    0xc(%ebp),%edx
 484:	8b 45 f0             	mov    -0x10(%ebp),%eax
 487:	01 d0                	add    %edx,%eax
 489:	0f b6 00             	movzbl (%eax),%eax
 48c:	0f be c0             	movsbl %al,%eax
 48f:	25 ff 00 00 00       	and    $0xff,%eax
 494:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 497:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 49b:	75 2c                	jne    4c9 <printf+0x6a>
      if(c == '%'){
 49d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 4a1:	75 0c                	jne    4af <printf+0x50>
        state = '%';
 4a3:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 4aa:	e9 27 01 00 00       	jmp    5d6 <printf+0x177>
      } else {
        putc(fd, c);
 4af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4b2:	0f be c0             	movsbl %al,%eax
 4b5:	83 ec 08             	sub    $0x8,%esp
 4b8:	50                   	push   %eax
 4b9:	ff 75 08             	push   0x8(%ebp)
 4bc:	e8 ca fe ff ff       	call   38b <putc>
 4c1:	83 c4 10             	add    $0x10,%esp
 4c4:	e9 0d 01 00 00       	jmp    5d6 <printf+0x177>
      }
    } else if(state == '%'){
 4c9:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 4cd:	0f 85 03 01 00 00    	jne    5d6 <printf+0x177>
      if(c == 'd'){
 4d3:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 4d7:	75 1e                	jne    4f7 <printf+0x98>
        printint(fd, *ap, 10, 1);
 4d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
 4dc:	8b 00                	mov    (%eax),%eax
 4de:	6a 01                	push   $0x1
 4e0:	6a 0a                	push   $0xa
 4e2:	50                   	push   %eax
 4e3:	ff 75 08             	push   0x8(%ebp)
 4e6:	e8 c3 fe ff ff       	call   3ae <printint>
 4eb:	83 c4 10             	add    $0x10,%esp
        ap++;
 4ee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 4f2:	e9 d8 00 00 00       	jmp    5cf <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 4f7:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 4fb:	74 06                	je     503 <printf+0xa4>
 4fd:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 501:	75 1e                	jne    521 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 503:	8b 45 e8             	mov    -0x18(%ebp),%eax
 506:	8b 00                	mov    (%eax),%eax
 508:	6a 00                	push   $0x0
 50a:	6a 10                	push   $0x10
 50c:	50                   	push   %eax
 50d:	ff 75 08             	push   0x8(%ebp)
 510:	e8 99 fe ff ff       	call   3ae <printint>
 515:	83 c4 10             	add    $0x10,%esp
        ap++;
 518:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 51c:	e9 ae 00 00 00       	jmp    5cf <printf+0x170>
      } else if(c == 's'){
 521:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 525:	75 43                	jne    56a <printf+0x10b>
        s = (char*)*ap;
 527:	8b 45 e8             	mov    -0x18(%ebp),%eax
 52a:	8b 00                	mov    (%eax),%eax
 52c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 52f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 533:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 537:	75 25                	jne    55e <printf+0xff>
          s = "(null)";
 539:	c7 45 f4 3d 08 00 00 	movl   $0x83d,-0xc(%ebp)
        while(*s != 0){
 540:	eb 1c                	jmp    55e <printf+0xff>
          putc(fd, *s);
 542:	8b 45 f4             	mov    -0xc(%ebp),%eax
 545:	0f b6 00             	movzbl (%eax),%eax
 548:	0f be c0             	movsbl %al,%eax
 54b:	83 ec 08             	sub    $0x8,%esp
 54e:	50                   	push   %eax
 54f:	ff 75 08             	push   0x8(%ebp)
 552:	e8 34 fe ff ff       	call   38b <putc>
 557:	83 c4 10             	add    $0x10,%esp
          s++;
 55a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 55e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 561:	0f b6 00             	movzbl (%eax),%eax
 564:	84 c0                	test   %al,%al
 566:	75 da                	jne    542 <printf+0xe3>
 568:	eb 65                	jmp    5cf <printf+0x170>
        }
      } else if(c == 'c'){
 56a:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 56e:	75 1d                	jne    58d <printf+0x12e>
        putc(fd, *ap);
 570:	8b 45 e8             	mov    -0x18(%ebp),%eax
 573:	8b 00                	mov    (%eax),%eax
 575:	0f be c0             	movsbl %al,%eax
 578:	83 ec 08             	sub    $0x8,%esp
 57b:	50                   	push   %eax
 57c:	ff 75 08             	push   0x8(%ebp)
 57f:	e8 07 fe ff ff       	call   38b <putc>
 584:	83 c4 10             	add    $0x10,%esp
        ap++;
 587:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58b:	eb 42                	jmp    5cf <printf+0x170>
      } else if(c == '%'){
 58d:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 591:	75 17                	jne    5aa <printf+0x14b>
        putc(fd, c);
 593:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 596:	0f be c0             	movsbl %al,%eax
 599:	83 ec 08             	sub    $0x8,%esp
 59c:	50                   	push   %eax
 59d:	ff 75 08             	push   0x8(%ebp)
 5a0:	e8 e6 fd ff ff       	call   38b <putc>
 5a5:	83 c4 10             	add    $0x10,%esp
 5a8:	eb 25                	jmp    5cf <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5aa:	83 ec 08             	sub    $0x8,%esp
 5ad:	6a 25                	push   $0x25
 5af:	ff 75 08             	push   0x8(%ebp)
 5b2:	e8 d4 fd ff ff       	call   38b <putc>
 5b7:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 5ba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5bd:	0f be c0             	movsbl %al,%eax
 5c0:	83 ec 08             	sub    $0x8,%esp
 5c3:	50                   	push   %eax
 5c4:	ff 75 08             	push   0x8(%ebp)
 5c7:	e8 bf fd ff ff       	call   38b <putc>
 5cc:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 5cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 5d6:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 5da:	8b 55 0c             	mov    0xc(%ebp),%edx
 5dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
 5e0:	01 d0                	add    %edx,%eax
 5e2:	0f b6 00             	movzbl (%eax),%eax
 5e5:	84 c0                	test   %al,%al
 5e7:	0f 85 94 fe ff ff    	jne    481 <printf+0x22>
    }
  }
}
 5ed:	90                   	nop
 5ee:	90                   	nop
 5ef:	c9                   	leave  
 5f0:	c3                   	ret    

000005f1 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5f1:	55                   	push   %ebp
 5f2:	89 e5                	mov    %esp,%ebp
 5f4:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5f7:	8b 45 08             	mov    0x8(%ebp),%eax
 5fa:	83 e8 08             	sub    $0x8,%eax
 5fd:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 600:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 605:	89 45 fc             	mov    %eax,-0x4(%ebp)
 608:	eb 24                	jmp    62e <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 60a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 60d:	8b 00                	mov    (%eax),%eax
 60f:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 612:	72 12                	jb     626 <free+0x35>
 614:	8b 45 f8             	mov    -0x8(%ebp),%eax
 617:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 61a:	77 24                	ja     640 <free+0x4f>
 61c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 61f:	8b 00                	mov    (%eax),%eax
 621:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 624:	72 1a                	jb     640 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 626:	8b 45 fc             	mov    -0x4(%ebp),%eax
 629:	8b 00                	mov    (%eax),%eax
 62b:	89 45 fc             	mov    %eax,-0x4(%ebp)
 62e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 631:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 634:	76 d4                	jbe    60a <free+0x19>
 636:	8b 45 fc             	mov    -0x4(%ebp),%eax
 639:	8b 00                	mov    (%eax),%eax
 63b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 63e:	73 ca                	jae    60a <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 640:	8b 45 f8             	mov    -0x8(%ebp),%eax
 643:	8b 40 04             	mov    0x4(%eax),%eax
 646:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 64d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 650:	01 c2                	add    %eax,%edx
 652:	8b 45 fc             	mov    -0x4(%ebp),%eax
 655:	8b 00                	mov    (%eax),%eax
 657:	39 c2                	cmp    %eax,%edx
 659:	75 24                	jne    67f <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 65b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 65e:	8b 50 04             	mov    0x4(%eax),%edx
 661:	8b 45 fc             	mov    -0x4(%ebp),%eax
 664:	8b 00                	mov    (%eax),%eax
 666:	8b 40 04             	mov    0x4(%eax),%eax
 669:	01 c2                	add    %eax,%edx
 66b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 66e:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 671:	8b 45 fc             	mov    -0x4(%ebp),%eax
 674:	8b 00                	mov    (%eax),%eax
 676:	8b 10                	mov    (%eax),%edx
 678:	8b 45 f8             	mov    -0x8(%ebp),%eax
 67b:	89 10                	mov    %edx,(%eax)
 67d:	eb 0a                	jmp    689 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 67f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 682:	8b 10                	mov    (%eax),%edx
 684:	8b 45 f8             	mov    -0x8(%ebp),%eax
 687:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 689:	8b 45 fc             	mov    -0x4(%ebp),%eax
 68c:	8b 40 04             	mov    0x4(%eax),%eax
 68f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 696:	8b 45 fc             	mov    -0x4(%ebp),%eax
 699:	01 d0                	add    %edx,%eax
 69b:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 69e:	75 20                	jne    6c0 <free+0xcf>
    p->s.size += bp->s.size;
 6a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a3:	8b 50 04             	mov    0x4(%eax),%edx
 6a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6a9:	8b 40 04             	mov    0x4(%eax),%eax
 6ac:	01 c2                	add    %eax,%edx
 6ae:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6b1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b7:	8b 10                	mov    (%eax),%edx
 6b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6bc:	89 10                	mov    %edx,(%eax)
 6be:	eb 08                	jmp    6c8 <free+0xd7>
  } else
    p->s.ptr = bp;
 6c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c3:	8b 55 f8             	mov    -0x8(%ebp),%edx
 6c6:	89 10                	mov    %edx,(%eax)
  freep = p;
 6c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6cb:	a3 a8 0a 00 00       	mov    %eax,0xaa8
}
 6d0:	90                   	nop
 6d1:	c9                   	leave  
 6d2:	c3                   	ret    

000006d3 <morecore>:

static Header*
morecore(uint nu)
{
 6d3:	55                   	push   %ebp
 6d4:	89 e5                	mov    %esp,%ebp
 6d6:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 6d9:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 6e0:	77 07                	ja     6e9 <morecore+0x16>
    nu = 4096;
 6e2:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 6e9:	8b 45 08             	mov    0x8(%ebp),%eax
 6ec:	c1 e0 03             	shl    $0x3,%eax
 6ef:	83 ec 0c             	sub    $0xc,%esp
 6f2:	50                   	push   %eax
 6f3:	e8 5b fc ff ff       	call   353 <sbrk>
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 6fe:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 702:	75 07                	jne    70b <morecore+0x38>
    return 0;
 704:	b8 00 00 00 00       	mov    $0x0,%eax
 709:	eb 26                	jmp    731 <morecore+0x5e>
  hp = (Header*)p;
 70b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 70e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 711:	8b 45 f0             	mov    -0x10(%ebp),%eax
 714:	8b 55 08             	mov    0x8(%ebp),%edx
 717:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 71a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 71d:	83 c0 08             	add    $0x8,%eax
 720:	83 ec 0c             	sub    $0xc,%esp
 723:	50                   	push   %eax
 724:	e8 c8 fe ff ff       	call   5f1 <free>
 729:	83 c4 10             	add    $0x10,%esp
  return freep;
 72c:	a1 a8 0a 00 00       	mov    0xaa8,%eax
}
 731:	c9                   	leave  
 732:	c3                   	ret    

00000733 <malloc>:

void*
malloc(uint nbytes)
{
 733:	55                   	push   %ebp
 734:	89 e5                	mov    %esp,%ebp
 736:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 739:	8b 45 08             	mov    0x8(%ebp),%eax
 73c:	83 c0 07             	add    $0x7,%eax
 73f:	c1 e8 03             	shr    $0x3,%eax
 742:	83 c0 01             	add    $0x1,%eax
 745:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 748:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 74d:	89 45 f0             	mov    %eax,-0x10(%ebp)
 750:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 754:	75 23                	jne    779 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 756:	c7 45 f0 a0 0a 00 00 	movl   $0xaa0,-0x10(%ebp)
 75d:	8b 45 f0             	mov    -0x10(%ebp),%eax
 760:	a3 a8 0a 00 00       	mov    %eax,0xaa8
 765:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 76a:	a3 a0 0a 00 00       	mov    %eax,0xaa0
    base.s.size = 0;
 76f:	c7 05 a4 0a 00 00 00 	movl   $0x0,0xaa4
 776:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 779:	8b 45 f0             	mov    -0x10(%ebp),%eax
 77c:	8b 00                	mov    (%eax),%eax
 77e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 781:	8b 45 f4             	mov    -0xc(%ebp),%eax
 784:	8b 40 04             	mov    0x4(%eax),%eax
 787:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 78a:	77 4d                	ja     7d9 <malloc+0xa6>
      if(p->s.size == nunits)
 78c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 78f:	8b 40 04             	mov    0x4(%eax),%eax
 792:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 795:	75 0c                	jne    7a3 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 797:	8b 45 f4             	mov    -0xc(%ebp),%eax
 79a:	8b 10                	mov    (%eax),%edx
 79c:	8b 45 f0             	mov    -0x10(%ebp),%eax
 79f:	89 10                	mov    %edx,(%eax)
 7a1:	eb 26                	jmp    7c9 <malloc+0x96>
      else {
        p->s.size -= nunits;
 7a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a6:	8b 40 04             	mov    0x4(%eax),%eax
 7a9:	2b 45 ec             	sub    -0x14(%ebp),%eax
 7ac:	89 c2                	mov    %eax,%edx
 7ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b1:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7b7:	8b 40 04             	mov    0x4(%eax),%eax
 7ba:	c1 e0 03             	shl    $0x3,%eax
 7bd:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 7c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7c3:	8b 55 ec             	mov    -0x14(%ebp),%edx
 7c6:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 7c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7cc:	a3 a8 0a 00 00       	mov    %eax,0xaa8
      return (void*)(p + 1);
 7d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7d4:	83 c0 08             	add    $0x8,%eax
 7d7:	eb 3b                	jmp    814 <malloc+0xe1>
    }
    if(p == freep)
 7d9:	a1 a8 0a 00 00       	mov    0xaa8,%eax
 7de:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 7e1:	75 1e                	jne    801 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 7e3:	83 ec 0c             	sub    $0xc,%esp
 7e6:	ff 75 ec             	push   -0x14(%ebp)
 7e9:	e8 e5 fe ff ff       	call   6d3 <morecore>
 7ee:	83 c4 10             	add    $0x10,%esp
 7f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
 7f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 7f8:	75 07                	jne    801 <malloc+0xce>
        return 0;
 7fa:	b8 00 00 00 00       	mov    $0x0,%eax
 7ff:	eb 13                	jmp    814 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 801:	8b 45 f4             	mov    -0xc(%ebp),%eax
 804:	89 45 f0             	mov    %eax,-0x10(%ebp)
 807:	8b 45 f4             	mov    -0xc(%ebp),%eax
 80a:	8b 00                	mov    (%eax),%eax
 80c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 80f:	e9 6d ff ff ff       	jmp    781 <malloc+0x4e>
  }
}
 814:	c9                   	leave  
 815:	c3                   	ret    
