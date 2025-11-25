
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0)
   6:	eb 15                	jmp    1d <cat+0x1d>
    write(1, buf, n);
   8:	83 ec 04             	sub    $0x4,%esp
   b:	ff 75 f4             	push   -0xc(%ebp)
   e:	68 60 0b 00 00       	push   $0xb60
  13:	6a 01                	push   $0x1
  15:	e8 6c 03 00 00       	call   386 <write>
  1a:	83 c4 10             	add    $0x10,%esp
  while((n = read(fd, buf, sizeof(buf))) > 0)
  1d:	83 ec 04             	sub    $0x4,%esp
  20:	68 00 02 00 00       	push   $0x200
  25:	68 60 0b 00 00       	push   $0xb60
  2a:	ff 75 08             	push   0x8(%ebp)
  2d:	e8 4c 03 00 00       	call   37e <read>
  32:	83 c4 10             	add    $0x10,%esp
  35:	89 45 f4             	mov    %eax,-0xc(%ebp)
  38:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  3c:	7f ca                	jg     8 <cat+0x8>
  if(n < 0){
  3e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  42:	79 17                	jns    5b <cat+0x5b>
    printf(1, "cat: read error\n");
  44:	83 ec 08             	sub    $0x8,%esp
  47:	68 b1 08 00 00       	push   $0x8b1
  4c:	6a 01                	push   $0x1
  4e:	e8 a7 04 00 00       	call   4fa <printf>
  53:	83 c4 10             	add    $0x10,%esp
    exit();
  56:	e8 0b 03 00 00       	call   366 <exit>
  }
}
  5b:	90                   	nop
  5c:	c9                   	leave  
  5d:	c3                   	ret    

0000005e <main>:

int
main(int argc, char *argv[])
{
  5e:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  62:	83 e4 f0             	and    $0xfffffff0,%esp
  65:	ff 71 fc             	push   -0x4(%ecx)
  68:	55                   	push   %ebp
  69:	89 e5                	mov    %esp,%ebp
  6b:	53                   	push   %ebx
  6c:	51                   	push   %ecx
  6d:	83 ec 10             	sub    $0x10,%esp
  70:	89 cb                	mov    %ecx,%ebx
  int fd, i;

  if(argc <= 1){
  72:	83 3b 01             	cmpl   $0x1,(%ebx)
  75:	7f 12                	jg     89 <main+0x2b>
    cat(0);
  77:	83 ec 0c             	sub    $0xc,%esp
  7a:	6a 00                	push   $0x0
  7c:	e8 7f ff ff ff       	call   0 <cat>
  81:	83 c4 10             	add    $0x10,%esp
    exit();
  84:	e8 dd 02 00 00       	call   366 <exit>
  }

  for(i = 1; i < argc; i++){
  89:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
  90:	eb 71                	jmp    103 <main+0xa5>
    if((fd = open(argv[i], 0)) < 0){
  92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  9c:	8b 43 04             	mov    0x4(%ebx),%eax
  9f:	01 d0                	add    %edx,%eax
  a1:	8b 00                	mov    (%eax),%eax
  a3:	83 ec 08             	sub    $0x8,%esp
  a6:	6a 00                	push   $0x0
  a8:	50                   	push   %eax
  a9:	e8 f8 02 00 00       	call   3a6 <open>
  ae:	83 c4 10             	add    $0x10,%esp
  b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  b4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  b8:	79 29                	jns    e3 <main+0x85>
      printf(1, "cat: cannot open %s\n", argv[i]);
  ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  bd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  c4:	8b 43 04             	mov    0x4(%ebx),%eax
  c7:	01 d0                	add    %edx,%eax
  c9:	8b 00                	mov    (%eax),%eax
  cb:	83 ec 04             	sub    $0x4,%esp
  ce:	50                   	push   %eax
  cf:	68 c2 08 00 00       	push   $0x8c2
  d4:	6a 01                	push   $0x1
  d6:	e8 1f 04 00 00       	call   4fa <printf>
  db:	83 c4 10             	add    $0x10,%esp
      exit();
  de:	e8 83 02 00 00       	call   366 <exit>
    }
    cat(fd);
  e3:	83 ec 0c             	sub    $0xc,%esp
  e6:	ff 75 f0             	push   -0x10(%ebp)
  e9:	e8 12 ff ff ff       	call   0 <cat>
  ee:	83 c4 10             	add    $0x10,%esp
    close(fd);
  f1:	83 ec 0c             	sub    $0xc,%esp
  f4:	ff 75 f0             	push   -0x10(%ebp)
  f7:	e8 92 02 00 00       	call   38e <close>
  fc:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++){
  ff:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 103:	8b 45 f4             	mov    -0xc(%ebp),%eax
 106:	3b 03                	cmp    (%ebx),%eax
 108:	7c 88                	jl     92 <main+0x34>
  }
  exit();
 10a:	e8 57 02 00 00       	call   366 <exit>

0000010f <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 114:	8b 4d 08             	mov    0x8(%ebp),%ecx
 117:	8b 55 10             	mov    0x10(%ebp),%edx
 11a:	8b 45 0c             	mov    0xc(%ebp),%eax
 11d:	89 cb                	mov    %ecx,%ebx
 11f:	89 df                	mov    %ebx,%edi
 121:	89 d1                	mov    %edx,%ecx
 123:	fc                   	cld    
 124:	f3 aa                	rep stos %al,%es:(%edi)
 126:	89 ca                	mov    %ecx,%edx
 128:	89 fb                	mov    %edi,%ebx
 12a:	89 5d 08             	mov    %ebx,0x8(%ebp)
 12d:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 130:	90                   	nop
 131:	5b                   	pop    %ebx
 132:	5f                   	pop    %edi
 133:	5d                   	pop    %ebp
 134:	c3                   	ret    

00000135 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 135:	55                   	push   %ebp
 136:	89 e5                	mov    %esp,%ebp
 138:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 13b:	8b 45 08             	mov    0x8(%ebp),%eax
 13e:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 141:	90                   	nop
 142:	8b 55 0c             	mov    0xc(%ebp),%edx
 145:	8d 42 01             	lea    0x1(%edx),%eax
 148:	89 45 0c             	mov    %eax,0xc(%ebp)
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	8d 48 01             	lea    0x1(%eax),%ecx
 151:	89 4d 08             	mov    %ecx,0x8(%ebp)
 154:	0f b6 12             	movzbl (%edx),%edx
 157:	88 10                	mov    %dl,(%eax)
 159:	0f b6 00             	movzbl (%eax),%eax
 15c:	84 c0                	test   %al,%al
 15e:	75 e2                	jne    142 <strcpy+0xd>
    ;
  return os;
 160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 163:	c9                   	leave  
 164:	c3                   	ret    

00000165 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 168:	eb 08                	jmp    172 <strcmp+0xd>
    p++, q++;
 16a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 16e:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 172:	8b 45 08             	mov    0x8(%ebp),%eax
 175:	0f b6 00             	movzbl (%eax),%eax
 178:	84 c0                	test   %al,%al
 17a:	74 10                	je     18c <strcmp+0x27>
 17c:	8b 45 08             	mov    0x8(%ebp),%eax
 17f:	0f b6 10             	movzbl (%eax),%edx
 182:	8b 45 0c             	mov    0xc(%ebp),%eax
 185:	0f b6 00             	movzbl (%eax),%eax
 188:	38 c2                	cmp    %al,%dl
 18a:	74 de                	je     16a <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
 18f:	0f b6 00             	movzbl (%eax),%eax
 192:	0f b6 d0             	movzbl %al,%edx
 195:	8b 45 0c             	mov    0xc(%ebp),%eax
 198:	0f b6 00             	movzbl (%eax),%eax
 19b:	0f b6 c8             	movzbl %al,%ecx
 19e:	89 d0                	mov    %edx,%eax
 1a0:	29 c8                	sub    %ecx,%eax
}
 1a2:	5d                   	pop    %ebp
 1a3:	c3                   	ret    

000001a4 <strlen>:

uint
strlen(char *s)
{
 1a4:	55                   	push   %ebp
 1a5:	89 e5                	mov    %esp,%ebp
 1a7:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 1aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 1b1:	eb 04                	jmp    1b7 <strlen+0x13>
 1b3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 1b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
 1ba:	8b 45 08             	mov    0x8(%ebp),%eax
 1bd:	01 d0                	add    %edx,%eax
 1bf:	0f b6 00             	movzbl (%eax),%eax
 1c2:	84 c0                	test   %al,%al
 1c4:	75 ed                	jne    1b3 <strlen+0xf>
    ;
  return n;
 1c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 1c9:	c9                   	leave  
 1ca:	c3                   	ret    

000001cb <memset>:

void*
memset(void *dst, int c, uint n)
{
 1cb:	55                   	push   %ebp
 1cc:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 1ce:	8b 45 10             	mov    0x10(%ebp),%eax
 1d1:	50                   	push   %eax
 1d2:	ff 75 0c             	push   0xc(%ebp)
 1d5:	ff 75 08             	push   0x8(%ebp)
 1d8:	e8 32 ff ff ff       	call   10f <stosb>
 1dd:	83 c4 0c             	add    $0xc,%esp
  return dst;
 1e0:	8b 45 08             	mov    0x8(%ebp),%eax
}
 1e3:	c9                   	leave  
 1e4:	c3                   	ret    

000001e5 <strchr>:

char*
strchr(const char *s, char c)
{
 1e5:	55                   	push   %ebp
 1e6:	89 e5                	mov    %esp,%ebp
 1e8:	83 ec 04             	sub    $0x4,%esp
 1eb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ee:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 1f1:	eb 14                	jmp    207 <strchr+0x22>
    if(*s == c)
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	0f b6 00             	movzbl (%eax),%eax
 1f9:	38 45 fc             	cmp    %al,-0x4(%ebp)
 1fc:	75 05                	jne    203 <strchr+0x1e>
      return (char*)s;
 1fe:	8b 45 08             	mov    0x8(%ebp),%eax
 201:	eb 13                	jmp    216 <strchr+0x31>
  for(; *s; s++)
 203:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 207:	8b 45 08             	mov    0x8(%ebp),%eax
 20a:	0f b6 00             	movzbl (%eax),%eax
 20d:	84 c0                	test   %al,%al
 20f:	75 e2                	jne    1f3 <strchr+0xe>
  return 0;
 211:	b8 00 00 00 00       	mov    $0x0,%eax
}
 216:	c9                   	leave  
 217:	c3                   	ret    

00000218 <gets>:

char*
gets(char *buf, int max)
{
 218:	55                   	push   %ebp
 219:	89 e5                	mov    %esp,%ebp
 21b:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 21e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 225:	eb 42                	jmp    269 <gets+0x51>
    cc = read(0, &c, 1);
 227:	83 ec 04             	sub    $0x4,%esp
 22a:	6a 01                	push   $0x1
 22c:	8d 45 ef             	lea    -0x11(%ebp),%eax
 22f:	50                   	push   %eax
 230:	6a 00                	push   $0x0
 232:	e8 47 01 00 00       	call   37e <read>
 237:	83 c4 10             	add    $0x10,%esp
 23a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 23d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 241:	7e 33                	jle    276 <gets+0x5e>
      break;
    buf[i++] = c;
 243:	8b 45 f4             	mov    -0xc(%ebp),%eax
 246:	8d 50 01             	lea    0x1(%eax),%edx
 249:	89 55 f4             	mov    %edx,-0xc(%ebp)
 24c:	89 c2                	mov    %eax,%edx
 24e:	8b 45 08             	mov    0x8(%ebp),%eax
 251:	01 c2                	add    %eax,%edx
 253:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 257:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 259:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 25d:	3c 0a                	cmp    $0xa,%al
 25f:	74 16                	je     277 <gets+0x5f>
 261:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 265:	3c 0d                	cmp    $0xd,%al
 267:	74 0e                	je     277 <gets+0x5f>
  for(i=0; i+1 < max; ){
 269:	8b 45 f4             	mov    -0xc(%ebp),%eax
 26c:	83 c0 01             	add    $0x1,%eax
 26f:	39 45 0c             	cmp    %eax,0xc(%ebp)
 272:	7f b3                	jg     227 <gets+0xf>
 274:	eb 01                	jmp    277 <gets+0x5f>
      break;
 276:	90                   	nop
      break;
  }
  buf[i] = '\0';
 277:	8b 55 f4             	mov    -0xc(%ebp),%edx
 27a:	8b 45 08             	mov    0x8(%ebp),%eax
 27d:	01 d0                	add    %edx,%eax
 27f:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 282:	8b 45 08             	mov    0x8(%ebp),%eax
}
 285:	c9                   	leave  
 286:	c3                   	ret    

00000287 <stat>:

int
stat(char *n, struct stat *st)
{
 287:	55                   	push   %ebp
 288:	89 e5                	mov    %esp,%ebp
 28a:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 28d:	83 ec 08             	sub    $0x8,%esp
 290:	6a 00                	push   $0x0
 292:	ff 75 08             	push   0x8(%ebp)
 295:	e8 0c 01 00 00       	call   3a6 <open>
 29a:	83 c4 10             	add    $0x10,%esp
 29d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 2a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2a4:	79 07                	jns    2ad <stat+0x26>
    return -1;
 2a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 2ab:	eb 25                	jmp    2d2 <stat+0x4b>
  r = fstat(fd, st);
 2ad:	83 ec 08             	sub    $0x8,%esp
 2b0:	ff 75 0c             	push   0xc(%ebp)
 2b3:	ff 75 f4             	push   -0xc(%ebp)
 2b6:	e8 03 01 00 00       	call   3be <fstat>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 2c1:	83 ec 0c             	sub    $0xc,%esp
 2c4:	ff 75 f4             	push   -0xc(%ebp)
 2c7:	e8 c2 00 00 00       	call   38e <close>
 2cc:	83 c4 10             	add    $0x10,%esp
  return r;
 2cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <atoi>:

int
atoi(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 2da:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 2e1:	eb 25                	jmp    308 <atoi+0x34>
    n = n*10 + *s++ - '0';
 2e3:	8b 55 fc             	mov    -0x4(%ebp),%edx
 2e6:	89 d0                	mov    %edx,%eax
 2e8:	c1 e0 02             	shl    $0x2,%eax
 2eb:	01 d0                	add    %edx,%eax
 2ed:	01 c0                	add    %eax,%eax
 2ef:	89 c1                	mov    %eax,%ecx
 2f1:	8b 45 08             	mov    0x8(%ebp),%eax
 2f4:	8d 50 01             	lea    0x1(%eax),%edx
 2f7:	89 55 08             	mov    %edx,0x8(%ebp)
 2fa:	0f b6 00             	movzbl (%eax),%eax
 2fd:	0f be c0             	movsbl %al,%eax
 300:	01 c8                	add    %ecx,%eax
 302:	83 e8 30             	sub    $0x30,%eax
 305:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 308:	8b 45 08             	mov    0x8(%ebp),%eax
 30b:	0f b6 00             	movzbl (%eax),%eax
 30e:	3c 2f                	cmp    $0x2f,%al
 310:	7e 0a                	jle    31c <atoi+0x48>
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	0f b6 00             	movzbl (%eax),%eax
 318:	3c 39                	cmp    $0x39,%al
 31a:	7e c7                	jle    2e3 <atoi+0xf>
  return n;
 31c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 31f:	c9                   	leave  
 320:	c3                   	ret    

00000321 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 32d:	8b 45 0c             	mov    0xc(%ebp),%eax
 330:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 333:	eb 17                	jmp    34c <memmove+0x2b>
    *dst++ = *src++;
 335:	8b 55 f8             	mov    -0x8(%ebp),%edx
 338:	8d 42 01             	lea    0x1(%edx),%eax
 33b:	89 45 f8             	mov    %eax,-0x8(%ebp)
 33e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 341:	8d 48 01             	lea    0x1(%eax),%ecx
 344:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 347:	0f b6 12             	movzbl (%edx),%edx
 34a:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 34c:	8b 45 10             	mov    0x10(%ebp),%eax
 34f:	8d 50 ff             	lea    -0x1(%eax),%edx
 352:	89 55 10             	mov    %edx,0x10(%ebp)
 355:	85 c0                	test   %eax,%eax
 357:	7f dc                	jg     335 <memmove+0x14>
  return vdst;
 359:	8b 45 08             	mov    0x8(%ebp),%eax
}
 35c:	c9                   	leave  
 35d:	c3                   	ret    

0000035e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 35e:	b8 01 00 00 00       	mov    $0x1,%eax
 363:	cd 40                	int    $0x40
 365:	c3                   	ret    

00000366 <exit>:
SYSCALL(exit)
 366:	b8 02 00 00 00       	mov    $0x2,%eax
 36b:	cd 40                	int    $0x40
 36d:	c3                   	ret    

0000036e <wait>:
SYSCALL(wait)
 36e:	b8 03 00 00 00       	mov    $0x3,%eax
 373:	cd 40                	int    $0x40
 375:	c3                   	ret    

00000376 <pipe>:
SYSCALL(pipe)
 376:	b8 04 00 00 00       	mov    $0x4,%eax
 37b:	cd 40                	int    $0x40
 37d:	c3                   	ret    

0000037e <read>:
SYSCALL(read)
 37e:	b8 05 00 00 00       	mov    $0x5,%eax
 383:	cd 40                	int    $0x40
 385:	c3                   	ret    

00000386 <write>:
SYSCALL(write)
 386:	b8 10 00 00 00       	mov    $0x10,%eax
 38b:	cd 40                	int    $0x40
 38d:	c3                   	ret    

0000038e <close>:
SYSCALL(close)
 38e:	b8 15 00 00 00       	mov    $0x15,%eax
 393:	cd 40                	int    $0x40
 395:	c3                   	ret    

00000396 <kill>:
SYSCALL(kill)
 396:	b8 06 00 00 00       	mov    $0x6,%eax
 39b:	cd 40                	int    $0x40
 39d:	c3                   	ret    

0000039e <exec>:
SYSCALL(exec)
 39e:	b8 07 00 00 00       	mov    $0x7,%eax
 3a3:	cd 40                	int    $0x40
 3a5:	c3                   	ret    

000003a6 <open>:
SYSCALL(open)
 3a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 3ab:	cd 40                	int    $0x40
 3ad:	c3                   	ret    

000003ae <mknod>:
SYSCALL(mknod)
 3ae:	b8 11 00 00 00       	mov    $0x11,%eax
 3b3:	cd 40                	int    $0x40
 3b5:	c3                   	ret    

000003b6 <unlink>:
SYSCALL(unlink)
 3b6:	b8 12 00 00 00       	mov    $0x12,%eax
 3bb:	cd 40                	int    $0x40
 3bd:	c3                   	ret    

000003be <fstat>:
SYSCALL(fstat)
 3be:	b8 08 00 00 00       	mov    $0x8,%eax
 3c3:	cd 40                	int    $0x40
 3c5:	c3                   	ret    

000003c6 <link>:
SYSCALL(link)
 3c6:	b8 13 00 00 00       	mov    $0x13,%eax
 3cb:	cd 40                	int    $0x40
 3cd:	c3                   	ret    

000003ce <mkdir>:
SYSCALL(mkdir)
 3ce:	b8 14 00 00 00       	mov    $0x14,%eax
 3d3:	cd 40                	int    $0x40
 3d5:	c3                   	ret    

000003d6 <chdir>:
SYSCALL(chdir)
 3d6:	b8 09 00 00 00       	mov    $0x9,%eax
 3db:	cd 40                	int    $0x40
 3dd:	c3                   	ret    

000003de <dup>:
SYSCALL(dup)
 3de:	b8 0a 00 00 00       	mov    $0xa,%eax
 3e3:	cd 40                	int    $0x40
 3e5:	c3                   	ret    

000003e6 <getpid>:
SYSCALL(getpid)
 3e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 3eb:	cd 40                	int    $0x40
 3ed:	c3                   	ret    

000003ee <sbrk>:
SYSCALL(sbrk)
 3ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 3f3:	cd 40                	int    $0x40
 3f5:	c3                   	ret    

000003f6 <sleep>:
SYSCALL(sleep)
 3f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 3fb:	cd 40                	int    $0x40
 3fd:	c3                   	ret    

000003fe <uptime>:
SYSCALL(uptime)
 3fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 403:	cd 40                	int    $0x40
 405:	c3                   	ret    

00000406 <print_free_frame_cnt>:
SYSCALL(print_free_frame_cnt)  //CS 3320 project 2
 406:	b8 17 00 00 00       	mov    $0x17,%eax
 40b:	cd 40                	int    $0x40
 40d:	c3                   	ret    

0000040e <set_page_allocator>:
SYSCALL(set_page_allocator) // CS 3320 project 2
 40e:	b8 18 00 00 00       	mov    $0x18,%eax
 413:	cd 40                	int    $0x40
 415:	c3                   	ret    

00000416 <shmget>:
SYSCALL(shmget) // CS 3320 project 2
 416:	b8 19 00 00 00       	mov    $0x19,%eax
 41b:	cd 40                	int    $0x40
 41d:	c3                   	ret    

0000041e <shmdel>:
SYSCALL(shmdel) // CS3320 project 2
 41e:	b8 1a 00 00 00       	mov    $0x1a,%eax
 423:	cd 40                	int    $0x40
 425:	c3                   	ret    

00000426 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 426:	55                   	push   %ebp
 427:	89 e5                	mov    %esp,%ebp
 429:	83 ec 18             	sub    $0x18,%esp
 42c:	8b 45 0c             	mov    0xc(%ebp),%eax
 42f:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 432:	83 ec 04             	sub    $0x4,%esp
 435:	6a 01                	push   $0x1
 437:	8d 45 f4             	lea    -0xc(%ebp),%eax
 43a:	50                   	push   %eax
 43b:	ff 75 08             	push   0x8(%ebp)
 43e:	e8 43 ff ff ff       	call   386 <write>
 443:	83 c4 10             	add    $0x10,%esp
}
 446:	90                   	nop
 447:	c9                   	leave  
 448:	c3                   	ret    

00000449 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 449:	55                   	push   %ebp
 44a:	89 e5                	mov    %esp,%ebp
 44c:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 44f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 456:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 45a:	74 17                	je     473 <printint+0x2a>
 45c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 460:	79 11                	jns    473 <printint+0x2a>
    neg = 1;
 462:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 469:	8b 45 0c             	mov    0xc(%ebp),%eax
 46c:	f7 d8                	neg    %eax
 46e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 471:	eb 06                	jmp    479 <printint+0x30>
  } else {
    x = xx;
 473:	8b 45 0c             	mov    0xc(%ebp),%eax
 476:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 479:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 480:	8b 4d 10             	mov    0x10(%ebp),%ecx
 483:	8b 45 ec             	mov    -0x14(%ebp),%eax
 486:	ba 00 00 00 00       	mov    $0x0,%edx
 48b:	f7 f1                	div    %ecx
 48d:	89 d1                	mov    %edx,%ecx
 48f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 492:	8d 50 01             	lea    0x1(%eax),%edx
 495:	89 55 f4             	mov    %edx,-0xc(%ebp)
 498:	0f b6 91 48 0b 00 00 	movzbl 0xb48(%ecx),%edx
 49f:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 4a3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 4a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 4a9:	ba 00 00 00 00       	mov    $0x0,%edx
 4ae:	f7 f1                	div    %ecx
 4b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
 4b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4b7:	75 c7                	jne    480 <printint+0x37>
  if(neg)
 4b9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 4bd:	74 2d                	je     4ec <printint+0xa3>
    buf[i++] = '-';
 4bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4c2:	8d 50 01             	lea    0x1(%eax),%edx
 4c5:	89 55 f4             	mov    %edx,-0xc(%ebp)
 4c8:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 4cd:	eb 1d                	jmp    4ec <printint+0xa3>
    putc(fd, buf[i]);
 4cf:	8d 55 dc             	lea    -0x24(%ebp),%edx
 4d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 4d5:	01 d0                	add    %edx,%eax
 4d7:	0f b6 00             	movzbl (%eax),%eax
 4da:	0f be c0             	movsbl %al,%eax
 4dd:	83 ec 08             	sub    $0x8,%esp
 4e0:	50                   	push   %eax
 4e1:	ff 75 08             	push   0x8(%ebp)
 4e4:	e8 3d ff ff ff       	call   426 <putc>
 4e9:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 4ec:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 4f0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4f4:	79 d9                	jns    4cf <printint+0x86>
}
 4f6:	90                   	nop
 4f7:	90                   	nop
 4f8:	c9                   	leave  
 4f9:	c3                   	ret    

000004fa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 4fa:	55                   	push   %ebp
 4fb:	89 e5                	mov    %esp,%ebp
 4fd:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 500:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 507:	8d 45 0c             	lea    0xc(%ebp),%eax
 50a:	83 c0 04             	add    $0x4,%eax
 50d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 510:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 517:	e9 59 01 00 00       	jmp    675 <printf+0x17b>
    c = fmt[i] & 0xff;
 51c:	8b 55 0c             	mov    0xc(%ebp),%edx
 51f:	8b 45 f0             	mov    -0x10(%ebp),%eax
 522:	01 d0                	add    %edx,%eax
 524:	0f b6 00             	movzbl (%eax),%eax
 527:	0f be c0             	movsbl %al,%eax
 52a:	25 ff 00 00 00       	and    $0xff,%eax
 52f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 532:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 536:	75 2c                	jne    564 <printf+0x6a>
      if(c == '%'){
 538:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 53c:	75 0c                	jne    54a <printf+0x50>
        state = '%';
 53e:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 545:	e9 27 01 00 00       	jmp    671 <printf+0x177>
      } else {
        putc(fd, c);
 54a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 54d:	0f be c0             	movsbl %al,%eax
 550:	83 ec 08             	sub    $0x8,%esp
 553:	50                   	push   %eax
 554:	ff 75 08             	push   0x8(%ebp)
 557:	e8 ca fe ff ff       	call   426 <putc>
 55c:	83 c4 10             	add    $0x10,%esp
 55f:	e9 0d 01 00 00       	jmp    671 <printf+0x177>
      }
    } else if(state == '%'){
 564:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 568:	0f 85 03 01 00 00    	jne    671 <printf+0x177>
      if(c == 'd'){
 56e:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 572:	75 1e                	jne    592 <printf+0x98>
        printint(fd, *ap, 10, 1);
 574:	8b 45 e8             	mov    -0x18(%ebp),%eax
 577:	8b 00                	mov    (%eax),%eax
 579:	6a 01                	push   $0x1
 57b:	6a 0a                	push   $0xa
 57d:	50                   	push   %eax
 57e:	ff 75 08             	push   0x8(%ebp)
 581:	e8 c3 fe ff ff       	call   449 <printint>
 586:	83 c4 10             	add    $0x10,%esp
        ap++;
 589:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 58d:	e9 d8 00 00 00       	jmp    66a <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 592:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 596:	74 06                	je     59e <printf+0xa4>
 598:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 59c:	75 1e                	jne    5bc <printf+0xc2>
        printint(fd, *ap, 16, 0);
 59e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5a1:	8b 00                	mov    (%eax),%eax
 5a3:	6a 00                	push   $0x0
 5a5:	6a 10                	push   $0x10
 5a7:	50                   	push   %eax
 5a8:	ff 75 08             	push   0x8(%ebp)
 5ab:	e8 99 fe ff ff       	call   449 <printint>
 5b0:	83 c4 10             	add    $0x10,%esp
        ap++;
 5b3:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 5b7:	e9 ae 00 00 00       	jmp    66a <printf+0x170>
      } else if(c == 's'){
 5bc:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 5c0:	75 43                	jne    605 <printf+0x10b>
        s = (char*)*ap;
 5c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
 5c5:	8b 00                	mov    (%eax),%eax
 5c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 5ca:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 5ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 5d2:	75 25                	jne    5f9 <printf+0xff>
          s = "(null)";
 5d4:	c7 45 f4 d7 08 00 00 	movl   $0x8d7,-0xc(%ebp)
        while(*s != 0){
 5db:	eb 1c                	jmp    5f9 <printf+0xff>
          putc(fd, *s);
 5dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5e0:	0f b6 00             	movzbl (%eax),%eax
 5e3:	0f be c0             	movsbl %al,%eax
 5e6:	83 ec 08             	sub    $0x8,%esp
 5e9:	50                   	push   %eax
 5ea:	ff 75 08             	push   0x8(%ebp)
 5ed:	e8 34 fe ff ff       	call   426 <putc>
 5f2:	83 c4 10             	add    $0x10,%esp
          s++;
 5f5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 5f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 5fc:	0f b6 00             	movzbl (%eax),%eax
 5ff:	84 c0                	test   %al,%al
 601:	75 da                	jne    5dd <printf+0xe3>
 603:	eb 65                	jmp    66a <printf+0x170>
        }
      } else if(c == 'c'){
 605:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 609:	75 1d                	jne    628 <printf+0x12e>
        putc(fd, *ap);
 60b:	8b 45 e8             	mov    -0x18(%ebp),%eax
 60e:	8b 00                	mov    (%eax),%eax
 610:	0f be c0             	movsbl %al,%eax
 613:	83 ec 08             	sub    $0x8,%esp
 616:	50                   	push   %eax
 617:	ff 75 08             	push   0x8(%ebp)
 61a:	e8 07 fe ff ff       	call   426 <putc>
 61f:	83 c4 10             	add    $0x10,%esp
        ap++;
 622:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 626:	eb 42                	jmp    66a <printf+0x170>
      } else if(c == '%'){
 628:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 62c:	75 17                	jne    645 <printf+0x14b>
        putc(fd, c);
 62e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 631:	0f be c0             	movsbl %al,%eax
 634:	83 ec 08             	sub    $0x8,%esp
 637:	50                   	push   %eax
 638:	ff 75 08             	push   0x8(%ebp)
 63b:	e8 e6 fd ff ff       	call   426 <putc>
 640:	83 c4 10             	add    $0x10,%esp
 643:	eb 25                	jmp    66a <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 645:	83 ec 08             	sub    $0x8,%esp
 648:	6a 25                	push   $0x25
 64a:	ff 75 08             	push   0x8(%ebp)
 64d:	e8 d4 fd ff ff       	call   426 <putc>
 652:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 655:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 658:	0f be c0             	movsbl %al,%eax
 65b:	83 ec 08             	sub    $0x8,%esp
 65e:	50                   	push   %eax
 65f:	ff 75 08             	push   0x8(%ebp)
 662:	e8 bf fd ff ff       	call   426 <putc>
 667:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 66a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 671:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 675:	8b 55 0c             	mov    0xc(%ebp),%edx
 678:	8b 45 f0             	mov    -0x10(%ebp),%eax
 67b:	01 d0                	add    %edx,%eax
 67d:	0f b6 00             	movzbl (%eax),%eax
 680:	84 c0                	test   %al,%al
 682:	0f 85 94 fe ff ff    	jne    51c <printf+0x22>
    }
  }
}
 688:	90                   	nop
 689:	90                   	nop
 68a:	c9                   	leave  
 68b:	c3                   	ret    

0000068c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 68c:	55                   	push   %ebp
 68d:	89 e5                	mov    %esp,%ebp
 68f:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 692:	8b 45 08             	mov    0x8(%ebp),%eax
 695:	83 e8 08             	sub    $0x8,%eax
 698:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 69b:	a1 68 0d 00 00       	mov    0xd68,%eax
 6a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6a3:	eb 24                	jmp    6c9 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6a8:	8b 00                	mov    (%eax),%eax
 6aa:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 6ad:	72 12                	jb     6c1 <free+0x35>
 6af:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6b5:	77 24                	ja     6db <free+0x4f>
 6b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ba:	8b 00                	mov    (%eax),%eax
 6bc:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6bf:	72 1a                	jb     6db <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6c4:	8b 00                	mov    (%eax),%eax
 6c6:	89 45 fc             	mov    %eax,-0x4(%ebp)
 6c9:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6cc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 6cf:	76 d4                	jbe    6a5 <free+0x19>
 6d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6d4:	8b 00                	mov    (%eax),%eax
 6d6:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 6d9:	73 ca                	jae    6a5 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6db:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6de:	8b 40 04             	mov    0x4(%eax),%eax
 6e1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 6e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6eb:	01 c2                	add    %eax,%edx
 6ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6f0:	8b 00                	mov    (%eax),%eax
 6f2:	39 c2                	cmp    %eax,%edx
 6f4:	75 24                	jne    71a <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 6f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
 6f9:	8b 50 04             	mov    0x4(%eax),%edx
 6fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
 6ff:	8b 00                	mov    (%eax),%eax
 701:	8b 40 04             	mov    0x4(%eax),%eax
 704:	01 c2                	add    %eax,%edx
 706:	8b 45 f8             	mov    -0x8(%ebp),%eax
 709:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 70c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 70f:	8b 00                	mov    (%eax),%eax
 711:	8b 10                	mov    (%eax),%edx
 713:	8b 45 f8             	mov    -0x8(%ebp),%eax
 716:	89 10                	mov    %edx,(%eax)
 718:	eb 0a                	jmp    724 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 71a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 71d:	8b 10                	mov    (%eax),%edx
 71f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 722:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 724:	8b 45 fc             	mov    -0x4(%ebp),%eax
 727:	8b 40 04             	mov    0x4(%eax),%eax
 72a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 731:	8b 45 fc             	mov    -0x4(%ebp),%eax
 734:	01 d0                	add    %edx,%eax
 736:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 739:	75 20                	jne    75b <free+0xcf>
    p->s.size += bp->s.size;
 73b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 73e:	8b 50 04             	mov    0x4(%eax),%edx
 741:	8b 45 f8             	mov    -0x8(%ebp),%eax
 744:	8b 40 04             	mov    0x4(%eax),%eax
 747:	01 c2                	add    %eax,%edx
 749:	8b 45 fc             	mov    -0x4(%ebp),%eax
 74c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 74f:	8b 45 f8             	mov    -0x8(%ebp),%eax
 752:	8b 10                	mov    (%eax),%edx
 754:	8b 45 fc             	mov    -0x4(%ebp),%eax
 757:	89 10                	mov    %edx,(%eax)
 759:	eb 08                	jmp    763 <free+0xd7>
  } else
    p->s.ptr = bp;
 75b:	8b 45 fc             	mov    -0x4(%ebp),%eax
 75e:	8b 55 f8             	mov    -0x8(%ebp),%edx
 761:	89 10                	mov    %edx,(%eax)
  freep = p;
 763:	8b 45 fc             	mov    -0x4(%ebp),%eax
 766:	a3 68 0d 00 00       	mov    %eax,0xd68
}
 76b:	90                   	nop
 76c:	c9                   	leave  
 76d:	c3                   	ret    

0000076e <morecore>:

static Header*
morecore(uint nu)
{
 76e:	55                   	push   %ebp
 76f:	89 e5                	mov    %esp,%ebp
 771:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 774:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 77b:	77 07                	ja     784 <morecore+0x16>
    nu = 4096;
 77d:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 784:	8b 45 08             	mov    0x8(%ebp),%eax
 787:	c1 e0 03             	shl    $0x3,%eax
 78a:	83 ec 0c             	sub    $0xc,%esp
 78d:	50                   	push   %eax
 78e:	e8 5b fc ff ff       	call   3ee <sbrk>
 793:	83 c4 10             	add    $0x10,%esp
 796:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 799:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 79d:	75 07                	jne    7a6 <morecore+0x38>
    return 0;
 79f:	b8 00 00 00 00       	mov    $0x0,%eax
 7a4:	eb 26                	jmp    7cc <morecore+0x5e>
  hp = (Header*)p;
 7a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
 7a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 7ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7af:	8b 55 08             	mov    0x8(%ebp),%edx
 7b2:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 7b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7b8:	83 c0 08             	add    $0x8,%eax
 7bb:	83 ec 0c             	sub    $0xc,%esp
 7be:	50                   	push   %eax
 7bf:	e8 c8 fe ff ff       	call   68c <free>
 7c4:	83 c4 10             	add    $0x10,%esp
  return freep;
 7c7:	a1 68 0d 00 00       	mov    0xd68,%eax
}
 7cc:	c9                   	leave  
 7cd:	c3                   	ret    

000007ce <malloc>:

void*
malloc(uint nbytes)
{
 7ce:	55                   	push   %ebp
 7cf:	89 e5                	mov    %esp,%ebp
 7d1:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d4:	8b 45 08             	mov    0x8(%ebp),%eax
 7d7:	83 c0 07             	add    $0x7,%eax
 7da:	c1 e8 03             	shr    $0x3,%eax
 7dd:	83 c0 01             	add    $0x1,%eax
 7e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 7e3:	a1 68 0d 00 00       	mov    0xd68,%eax
 7e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
 7eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 7ef:	75 23                	jne    814 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 7f1:	c7 45 f0 60 0d 00 00 	movl   $0xd60,-0x10(%ebp)
 7f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 7fb:	a3 68 0d 00 00       	mov    %eax,0xd68
 800:	a1 68 0d 00 00       	mov    0xd68,%eax
 805:	a3 60 0d 00 00       	mov    %eax,0xd60
    base.s.size = 0;
 80a:	c7 05 64 0d 00 00 00 	movl   $0x0,0xd64
 811:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 814:	8b 45 f0             	mov    -0x10(%ebp),%eax
 817:	8b 00                	mov    (%eax),%eax
 819:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 81c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 81f:	8b 40 04             	mov    0x4(%eax),%eax
 822:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 825:	77 4d                	ja     874 <malloc+0xa6>
      if(p->s.size == nunits)
 827:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82a:	8b 40 04             	mov    0x4(%eax),%eax
 82d:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 830:	75 0c                	jne    83e <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 832:	8b 45 f4             	mov    -0xc(%ebp),%eax
 835:	8b 10                	mov    (%eax),%edx
 837:	8b 45 f0             	mov    -0x10(%ebp),%eax
 83a:	89 10                	mov    %edx,(%eax)
 83c:	eb 26                	jmp    864 <malloc+0x96>
      else {
        p->s.size -= nunits;
 83e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 841:	8b 40 04             	mov    0x4(%eax),%eax
 844:	2b 45 ec             	sub    -0x14(%ebp),%eax
 847:	89 c2                	mov    %eax,%edx
 849:	8b 45 f4             	mov    -0xc(%ebp),%eax
 84c:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 84f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 852:	8b 40 04             	mov    0x4(%eax),%eax
 855:	c1 e0 03             	shl    $0x3,%eax
 858:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 85b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 85e:	8b 55 ec             	mov    -0x14(%ebp),%edx
 861:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 864:	8b 45 f0             	mov    -0x10(%ebp),%eax
 867:	a3 68 0d 00 00       	mov    %eax,0xd68
      return (void*)(p + 1);
 86c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 86f:	83 c0 08             	add    $0x8,%eax
 872:	eb 3b                	jmp    8af <malloc+0xe1>
    }
    if(p == freep)
 874:	a1 68 0d 00 00       	mov    0xd68,%eax
 879:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 87c:	75 1e                	jne    89c <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 87e:	83 ec 0c             	sub    $0xc,%esp
 881:	ff 75 ec             	push   -0x14(%ebp)
 884:	e8 e5 fe ff ff       	call   76e <morecore>
 889:	83 c4 10             	add    $0x10,%esp
 88c:	89 45 f4             	mov    %eax,-0xc(%ebp)
 88f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 893:	75 07                	jne    89c <malloc+0xce>
        return 0;
 895:	b8 00 00 00 00       	mov    $0x0,%eax
 89a:	eb 13                	jmp    8af <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 89c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 89f:	89 45 f0             	mov    %eax,-0x10(%ebp)
 8a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 8a5:	8b 00                	mov    (%eax),%eax
 8a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 8aa:	e9 6d ff ff ff       	jmp    81c <malloc+0x4e>
  }
}
 8af:	c9                   	leave  
 8b0:	c3                   	ret    
