
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 14             	sub    $0x14,%esp
  static char buf[DIRSIZ+1];
  char *p;
  
  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   7:	83 ec 0c             	sub    $0xc,%esp
   a:	ff 75 08             	push   0x8(%ebp)
   d:	e8 c5 03 00 00       	call   3d7 <strlen>
  12:	83 c4 10             	add    $0x10,%esp
  15:	8b 55 08             	mov    0x8(%ebp),%edx
  18:	01 d0                	add    %edx,%eax
  1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1d:	eb 04                	jmp    23 <fmtname+0x23>
  1f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  26:	3b 45 08             	cmp    0x8(%ebp),%eax
  29:	72 0a                	jb     35 <fmtname+0x35>
  2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  2e:	0f b6 00             	movzbl (%eax),%eax
  31:	3c 2f                	cmp    $0x2f,%al
  33:	75 ea                	jne    1f <fmtname+0x1f>
    ;
  p++;
  35:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  
  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	ff 75 f4             	push   -0xc(%ebp)
  3f:	e8 93 03 00 00       	call   3d7 <strlen>
  44:	83 c4 10             	add    $0x10,%esp
  47:	83 f8 0d             	cmp    $0xd,%eax
  4a:	76 05                	jbe    51 <fmtname+0x51>
    return p;
  4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  4f:	eb 60                	jmp    b1 <fmtname+0xb1>
  memmove(buf, p, strlen(p));
  51:	83 ec 0c             	sub    $0xc,%esp
  54:	ff 75 f4             	push   -0xc(%ebp)
  57:	e8 7b 03 00 00       	call   3d7 <strlen>
  5c:	83 c4 10             	add    $0x10,%esp
  5f:	83 ec 04             	sub    $0x4,%esp
  62:	50                   	push   %eax
  63:	ff 75 f4             	push   -0xc(%ebp)
  66:	68 e8 0d 00 00       	push   $0xde8
  6b:	e8 e4 04 00 00       	call   554 <memmove>
  70:	83 c4 10             	add    $0x10,%esp
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  73:	83 ec 0c             	sub    $0xc,%esp
  76:	ff 75 f4             	push   -0xc(%ebp)
  79:	e8 59 03 00 00       	call   3d7 <strlen>
  7e:	83 c4 10             	add    $0x10,%esp
  81:	ba 0e 00 00 00       	mov    $0xe,%edx
  86:	89 d3                	mov    %edx,%ebx
  88:	29 c3                	sub    %eax,%ebx
  8a:	83 ec 0c             	sub    $0xc,%esp
  8d:	ff 75 f4             	push   -0xc(%ebp)
  90:	e8 42 03 00 00       	call   3d7 <strlen>
  95:	83 c4 10             	add    $0x10,%esp
  98:	05 e8 0d 00 00       	add    $0xde8,%eax
  9d:	83 ec 04             	sub    $0x4,%esp
  a0:	53                   	push   %ebx
  a1:	6a 20                	push   $0x20
  a3:	50                   	push   %eax
  a4:	e8 55 03 00 00       	call   3fe <memset>
  a9:	83 c4 10             	add    $0x10,%esp
  return buf;
  ac:	b8 e8 0d 00 00       	mov    $0xde8,%eax
}
  b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  b4:	c9                   	leave  
  b5:	c3                   	ret    

000000b6 <ls>:

void
ls(char *path)
{
  b6:	55                   	push   %ebp
  b7:	89 e5                	mov    %esp,%ebp
  b9:	57                   	push   %edi
  ba:	56                   	push   %esi
  bb:	53                   	push   %ebx
  bc:	81 ec 3c 02 00 00    	sub    $0x23c,%esp
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;
  
  if((fd = open(path, 0)) < 0){
  c2:	83 ec 08             	sub    $0x8,%esp
  c5:	6a 00                	push   $0x0
  c7:	ff 75 08             	push   0x8(%ebp)
  ca:	e8 0a 05 00 00       	call   5d9 <open>
  cf:	83 c4 10             	add    $0x10,%esp
  d2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  d9:	79 1a                	jns    f5 <ls+0x3f>
    printf(2, "ls: cannot open %s\n", path);
  db:	83 ec 04             	sub    $0x4,%esp
  de:	ff 75 08             	push   0x8(%ebp)
  e1:	68 e4 0a 00 00       	push   $0xae4
  e6:	6a 02                	push   $0x2
  e8:	e8 40 06 00 00       	call   72d <printf>
  ed:	83 c4 10             	add    $0x10,%esp
    return;
  f0:	e9 e1 01 00 00       	jmp    2d6 <ls+0x220>
  }
  
  if(fstat(fd, &st) < 0){
  f5:	83 ec 08             	sub    $0x8,%esp
  f8:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
  fe:	50                   	push   %eax
  ff:	ff 75 e4             	push   -0x1c(%ebp)
 102:	e8 ea 04 00 00       	call   5f1 <fstat>
 107:	83 c4 10             	add    $0x10,%esp
 10a:	85 c0                	test   %eax,%eax
 10c:	79 28                	jns    136 <ls+0x80>
    printf(2, "ls: cannot stat %s\n", path);
 10e:	83 ec 04             	sub    $0x4,%esp
 111:	ff 75 08             	push   0x8(%ebp)
 114:	68 f8 0a 00 00       	push   $0xaf8
 119:	6a 02                	push   $0x2
 11b:	e8 0d 06 00 00       	call   72d <printf>
 120:	83 c4 10             	add    $0x10,%esp
    close(fd);
 123:	83 ec 0c             	sub    $0xc,%esp
 126:	ff 75 e4             	push   -0x1c(%ebp)
 129:	e8 93 04 00 00       	call   5c1 <close>
 12e:	83 c4 10             	add    $0x10,%esp
    return;
 131:	e9 a0 01 00 00       	jmp    2d6 <ls+0x220>
  }
  
  switch(st.type){
 136:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 13d:	98                   	cwtl   
 13e:	83 f8 01             	cmp    $0x1,%eax
 141:	74 48                	je     18b <ls+0xd5>
 143:	83 f8 02             	cmp    $0x2,%eax
 146:	0f 85 7c 01 00 00    	jne    2c8 <ls+0x212>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
 14c:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 152:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 158:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 15f:	0f bf d8             	movswl %ax,%ebx
 162:	83 ec 0c             	sub    $0xc,%esp
 165:	ff 75 08             	push   0x8(%ebp)
 168:	e8 93 fe ff ff       	call   0 <fmtname>
 16d:	83 c4 10             	add    $0x10,%esp
 170:	83 ec 08             	sub    $0x8,%esp
 173:	57                   	push   %edi
 174:	56                   	push   %esi
 175:	53                   	push   %ebx
 176:	50                   	push   %eax
 177:	68 0c 0b 00 00       	push   $0xb0c
 17c:	6a 01                	push   $0x1
 17e:	e8 aa 05 00 00       	call   72d <printf>
 183:	83 c4 20             	add    $0x20,%esp
    break;
 186:	e9 3d 01 00 00       	jmp    2c8 <ls+0x212>
  
  case T_DIR:
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 18b:	83 ec 0c             	sub    $0xc,%esp
 18e:	ff 75 08             	push   0x8(%ebp)
 191:	e8 41 02 00 00       	call   3d7 <strlen>
 196:	83 c4 10             	add    $0x10,%esp
 199:	83 c0 10             	add    $0x10,%eax
 19c:	3d 00 02 00 00       	cmp    $0x200,%eax
 1a1:	76 17                	jbe    1ba <ls+0x104>
      printf(1, "ls: path too long\n");
 1a3:	83 ec 08             	sub    $0x8,%esp
 1a6:	68 19 0b 00 00       	push   $0xb19
 1ab:	6a 01                	push   $0x1
 1ad:	e8 7b 05 00 00       	call   72d <printf>
 1b2:	83 c4 10             	add    $0x10,%esp
      break;
 1b5:	e9 0e 01 00 00       	jmp    2c8 <ls+0x212>
    }
    strcpy(buf, path);
 1ba:	83 ec 08             	sub    $0x8,%esp
 1bd:	ff 75 08             	push   0x8(%ebp)
 1c0:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1c6:	50                   	push   %eax
 1c7:	e8 9c 01 00 00       	call   368 <strcpy>
 1cc:	83 c4 10             	add    $0x10,%esp
    p = buf+strlen(buf);
 1cf:	83 ec 0c             	sub    $0xc,%esp
 1d2:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 1d8:	50                   	push   %eax
 1d9:	e8 f9 01 00 00       	call   3d7 <strlen>
 1de:	83 c4 10             	add    $0x10,%esp
 1e1:	8d 95 e0 fd ff ff    	lea    -0x220(%ebp),%edx
 1e7:	01 d0                	add    %edx,%eax
 1e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    *p++ = '/';
 1ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
 1ef:	8d 50 01             	lea    0x1(%eax),%edx
 1f2:	89 55 e0             	mov    %edx,-0x20(%ebp)
 1f5:	c6 00 2f             	movb   $0x2f,(%eax)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1f8:	e9 aa 00 00 00       	jmp    2a7 <ls+0x1f1>
      if(de.inum == 0)
 1fd:	0f b7 85 d0 fd ff ff 	movzwl -0x230(%ebp),%eax
 204:	66 85 c0             	test   %ax,%ax
 207:	75 05                	jne    20e <ls+0x158>
        continue;
 209:	e9 99 00 00 00       	jmp    2a7 <ls+0x1f1>
      memmove(p, de.name, DIRSIZ);
 20e:	83 ec 04             	sub    $0x4,%esp
 211:	6a 0e                	push   $0xe
 213:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 219:	83 c0 02             	add    $0x2,%eax
 21c:	50                   	push   %eax
 21d:	ff 75 e0             	push   -0x20(%ebp)
 220:	e8 2f 03 00 00       	call   554 <memmove>
 225:	83 c4 10             	add    $0x10,%esp
      p[DIRSIZ] = 0;
 228:	8b 45 e0             	mov    -0x20(%ebp),%eax
 22b:	83 c0 0e             	add    $0xe,%eax
 22e:	c6 00 00             	movb   $0x0,(%eax)
      if(stat(buf, &st) < 0){
 231:	83 ec 08             	sub    $0x8,%esp
 234:	8d 85 bc fd ff ff    	lea    -0x244(%ebp),%eax
 23a:	50                   	push   %eax
 23b:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 241:	50                   	push   %eax
 242:	e8 73 02 00 00       	call   4ba <stat>
 247:	83 c4 10             	add    $0x10,%esp
 24a:	85 c0                	test   %eax,%eax
 24c:	79 1b                	jns    269 <ls+0x1b3>
        printf(1, "ls: cannot stat %s\n", buf);
 24e:	83 ec 04             	sub    $0x4,%esp
 251:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 257:	50                   	push   %eax
 258:	68 f8 0a 00 00       	push   $0xaf8
 25d:	6a 01                	push   $0x1
 25f:	e8 c9 04 00 00       	call   72d <printf>
 264:	83 c4 10             	add    $0x10,%esp
        continue;
 267:	eb 3e                	jmp    2a7 <ls+0x1f1>
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 269:	8b bd cc fd ff ff    	mov    -0x234(%ebp),%edi
 26f:	8b b5 c4 fd ff ff    	mov    -0x23c(%ebp),%esi
 275:	0f b7 85 bc fd ff ff 	movzwl -0x244(%ebp),%eax
 27c:	0f bf d8             	movswl %ax,%ebx
 27f:	83 ec 0c             	sub    $0xc,%esp
 282:	8d 85 e0 fd ff ff    	lea    -0x220(%ebp),%eax
 288:	50                   	push   %eax
 289:	e8 72 fd ff ff       	call   0 <fmtname>
 28e:	83 c4 10             	add    $0x10,%esp
 291:	83 ec 08             	sub    $0x8,%esp
 294:	57                   	push   %edi
 295:	56                   	push   %esi
 296:	53                   	push   %ebx
 297:	50                   	push   %eax
 298:	68 0c 0b 00 00       	push   $0xb0c
 29d:	6a 01                	push   $0x1
 29f:	e8 89 04 00 00       	call   72d <printf>
 2a4:	83 c4 20             	add    $0x20,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 2a7:	83 ec 04             	sub    $0x4,%esp
 2aa:	6a 10                	push   $0x10
 2ac:	8d 85 d0 fd ff ff    	lea    -0x230(%ebp),%eax
 2b2:	50                   	push   %eax
 2b3:	ff 75 e4             	push   -0x1c(%ebp)
 2b6:	e8 f6 02 00 00       	call   5b1 <read>
 2bb:	83 c4 10             	add    $0x10,%esp
 2be:	83 f8 10             	cmp    $0x10,%eax
 2c1:	0f 84 36 ff ff ff    	je     1fd <ls+0x147>
    }
    break;
 2c7:	90                   	nop
  }
  close(fd);
 2c8:	83 ec 0c             	sub    $0xc,%esp
 2cb:	ff 75 e4             	push   -0x1c(%ebp)
 2ce:	e8 ee 02 00 00       	call   5c1 <close>
 2d3:	83 c4 10             	add    $0x10,%esp
}
 2d6:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d9:	5b                   	pop    %ebx
 2da:	5e                   	pop    %esi
 2db:	5f                   	pop    %edi
 2dc:	5d                   	pop    %ebp
 2dd:	c3                   	ret    

000002de <main>:

int
main(int argc, char *argv[])
{
 2de:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 2e2:	83 e4 f0             	and    $0xfffffff0,%esp
 2e5:	ff 71 fc             	push   -0x4(%ecx)
 2e8:	55                   	push   %ebp
 2e9:	89 e5                	mov    %esp,%ebp
 2eb:	53                   	push   %ebx
 2ec:	51                   	push   %ecx
 2ed:	83 ec 10             	sub    $0x10,%esp
 2f0:	89 cb                	mov    %ecx,%ebx
  int i;

  if(argc < 2){
 2f2:	83 3b 01             	cmpl   $0x1,(%ebx)
 2f5:	7f 15                	jg     30c <main+0x2e>
    ls(".");
 2f7:	83 ec 0c             	sub    $0xc,%esp
 2fa:	68 2c 0b 00 00       	push   $0xb2c
 2ff:	e8 b2 fd ff ff       	call   b6 <ls>
 304:	83 c4 10             	add    $0x10,%esp
    exit();
 307:	e8 8d 02 00 00       	call   599 <exit>
  }
  for(i=1; i<argc; i++)
 30c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
 313:	eb 21                	jmp    336 <main+0x58>
    ls(argv[i]);
 315:	8b 45 f4             	mov    -0xc(%ebp),%eax
 318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
 31f:	8b 43 04             	mov    0x4(%ebx),%eax
 322:	01 d0                	add    %edx,%eax
 324:	8b 00                	mov    (%eax),%eax
 326:	83 ec 0c             	sub    $0xc,%esp
 329:	50                   	push   %eax
 32a:	e8 87 fd ff ff       	call   b6 <ls>
 32f:	83 c4 10             	add    $0x10,%esp
  for(i=1; i<argc; i++)
 332:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 336:	8b 45 f4             	mov    -0xc(%ebp),%eax
 339:	3b 03                	cmp    (%ebx),%eax
 33b:	7c d8                	jl     315 <main+0x37>
  exit();
 33d:	e8 57 02 00 00       	call   599 <exit>

00000342 <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 342:	55                   	push   %ebp
 343:	89 e5                	mov    %esp,%ebp
 345:	57                   	push   %edi
 346:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 347:	8b 4d 08             	mov    0x8(%ebp),%ecx
 34a:	8b 55 10             	mov    0x10(%ebp),%edx
 34d:	8b 45 0c             	mov    0xc(%ebp),%eax
 350:	89 cb                	mov    %ecx,%ebx
 352:	89 df                	mov    %ebx,%edi
 354:	89 d1                	mov    %edx,%ecx
 356:	fc                   	cld    
 357:	f3 aa                	rep stos %al,%es:(%edi)
 359:	89 ca                	mov    %ecx,%edx
 35b:	89 fb                	mov    %edi,%ebx
 35d:	89 5d 08             	mov    %ebx,0x8(%ebp)
 360:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 363:	90                   	nop
 364:	5b                   	pop    %ebx
 365:	5f                   	pop    %edi
 366:	5d                   	pop    %ebp
 367:	c3                   	ret    

00000368 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 368:	55                   	push   %ebp
 369:	89 e5                	mov    %esp,%ebp
 36b:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 36e:	8b 45 08             	mov    0x8(%ebp),%eax
 371:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 374:	90                   	nop
 375:	8b 55 0c             	mov    0xc(%ebp),%edx
 378:	8d 42 01             	lea    0x1(%edx),%eax
 37b:	89 45 0c             	mov    %eax,0xc(%ebp)
 37e:	8b 45 08             	mov    0x8(%ebp),%eax
 381:	8d 48 01             	lea    0x1(%eax),%ecx
 384:	89 4d 08             	mov    %ecx,0x8(%ebp)
 387:	0f b6 12             	movzbl (%edx),%edx
 38a:	88 10                	mov    %dl,(%eax)
 38c:	0f b6 00             	movzbl (%eax),%eax
 38f:	84 c0                	test   %al,%al
 391:	75 e2                	jne    375 <strcpy+0xd>
    ;
  return os;
 393:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 396:	c9                   	leave  
 397:	c3                   	ret    

00000398 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 398:	55                   	push   %ebp
 399:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 39b:	eb 08                	jmp    3a5 <strcmp+0xd>
    p++, q++;
 39d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 3a1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 3a5:	8b 45 08             	mov    0x8(%ebp),%eax
 3a8:	0f b6 00             	movzbl (%eax),%eax
 3ab:	84 c0                	test   %al,%al
 3ad:	74 10                	je     3bf <strcmp+0x27>
 3af:	8b 45 08             	mov    0x8(%ebp),%eax
 3b2:	0f b6 10             	movzbl (%eax),%edx
 3b5:	8b 45 0c             	mov    0xc(%ebp),%eax
 3b8:	0f b6 00             	movzbl (%eax),%eax
 3bb:	38 c2                	cmp    %al,%dl
 3bd:	74 de                	je     39d <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 3bf:	8b 45 08             	mov    0x8(%ebp),%eax
 3c2:	0f b6 00             	movzbl (%eax),%eax
 3c5:	0f b6 d0             	movzbl %al,%edx
 3c8:	8b 45 0c             	mov    0xc(%ebp),%eax
 3cb:	0f b6 00             	movzbl (%eax),%eax
 3ce:	0f b6 c8             	movzbl %al,%ecx
 3d1:	89 d0                	mov    %edx,%eax
 3d3:	29 c8                	sub    %ecx,%eax
}
 3d5:	5d                   	pop    %ebp
 3d6:	c3                   	ret    

000003d7 <strlen>:

uint
strlen(char *s)
{
 3d7:	55                   	push   %ebp
 3d8:	89 e5                	mov    %esp,%ebp
 3da:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 3dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 3e4:	eb 04                	jmp    3ea <strlen+0x13>
 3e6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 3ea:	8b 55 fc             	mov    -0x4(%ebp),%edx
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
 3f0:	01 d0                	add    %edx,%eax
 3f2:	0f b6 00             	movzbl (%eax),%eax
 3f5:	84 c0                	test   %al,%al
 3f7:	75 ed                	jne    3e6 <strlen+0xf>
    ;
  return n;
 3f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 3fc:	c9                   	leave  
 3fd:	c3                   	ret    

000003fe <memset>:

void*
memset(void *dst, int c, uint n)
{
 3fe:	55                   	push   %ebp
 3ff:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 401:	8b 45 10             	mov    0x10(%ebp),%eax
 404:	50                   	push   %eax
 405:	ff 75 0c             	push   0xc(%ebp)
 408:	ff 75 08             	push   0x8(%ebp)
 40b:	e8 32 ff ff ff       	call   342 <stosb>
 410:	83 c4 0c             	add    $0xc,%esp
  return dst;
 413:	8b 45 08             	mov    0x8(%ebp),%eax
}
 416:	c9                   	leave  
 417:	c3                   	ret    

00000418 <strchr>:

char*
strchr(const char *s, char c)
{
 418:	55                   	push   %ebp
 419:	89 e5                	mov    %esp,%ebp
 41b:	83 ec 04             	sub    $0x4,%esp
 41e:	8b 45 0c             	mov    0xc(%ebp),%eax
 421:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 424:	eb 14                	jmp    43a <strchr+0x22>
    if(*s == c)
 426:	8b 45 08             	mov    0x8(%ebp),%eax
 429:	0f b6 00             	movzbl (%eax),%eax
 42c:	38 45 fc             	cmp    %al,-0x4(%ebp)
 42f:	75 05                	jne    436 <strchr+0x1e>
      return (char*)s;
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	eb 13                	jmp    449 <strchr+0x31>
  for(; *s; s++)
 436:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	0f b6 00             	movzbl (%eax),%eax
 440:	84 c0                	test   %al,%al
 442:	75 e2                	jne    426 <strchr+0xe>
  return 0;
 444:	b8 00 00 00 00       	mov    $0x0,%eax
}
 449:	c9                   	leave  
 44a:	c3                   	ret    

0000044b <gets>:

char*
gets(char *buf, int max)
{
 44b:	55                   	push   %ebp
 44c:	89 e5                	mov    %esp,%ebp
 44e:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 458:	eb 42                	jmp    49c <gets+0x51>
    cc = read(0, &c, 1);
 45a:	83 ec 04             	sub    $0x4,%esp
 45d:	6a 01                	push   $0x1
 45f:	8d 45 ef             	lea    -0x11(%ebp),%eax
 462:	50                   	push   %eax
 463:	6a 00                	push   $0x0
 465:	e8 47 01 00 00       	call   5b1 <read>
 46a:	83 c4 10             	add    $0x10,%esp
 46d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 470:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 474:	7e 33                	jle    4a9 <gets+0x5e>
      break;
    buf[i++] = c;
 476:	8b 45 f4             	mov    -0xc(%ebp),%eax
 479:	8d 50 01             	lea    0x1(%eax),%edx
 47c:	89 55 f4             	mov    %edx,-0xc(%ebp)
 47f:	89 c2                	mov    %eax,%edx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	01 c2                	add    %eax,%edx
 486:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 48a:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 48c:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 490:	3c 0a                	cmp    $0xa,%al
 492:	74 16                	je     4aa <gets+0x5f>
 494:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 498:	3c 0d                	cmp    $0xd,%al
 49a:	74 0e                	je     4aa <gets+0x5f>
  for(i=0; i+1 < max; ){
 49c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 49f:	83 c0 01             	add    $0x1,%eax
 4a2:	39 45 0c             	cmp    %eax,0xc(%ebp)
 4a5:	7f b3                	jg     45a <gets+0xf>
 4a7:	eb 01                	jmp    4aa <gets+0x5f>
      break;
 4a9:	90                   	nop
      break;
  }
  buf[i] = '\0';
 4aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
 4ad:	8b 45 08             	mov    0x8(%ebp),%eax
 4b0:	01 d0                	add    %edx,%eax
 4b2:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 4b5:	8b 45 08             	mov    0x8(%ebp),%eax
}
 4b8:	c9                   	leave  
 4b9:	c3                   	ret    

000004ba <stat>:

int
stat(char *n, struct stat *st)
{
 4ba:	55                   	push   %ebp
 4bb:	89 e5                	mov    %esp,%ebp
 4bd:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 4c0:	83 ec 08             	sub    $0x8,%esp
 4c3:	6a 00                	push   $0x0
 4c5:	ff 75 08             	push   0x8(%ebp)
 4c8:	e8 0c 01 00 00       	call   5d9 <open>
 4cd:	83 c4 10             	add    $0x10,%esp
 4d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 4d3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 4d7:	79 07                	jns    4e0 <stat+0x26>
    return -1;
 4d9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 4de:	eb 25                	jmp    505 <stat+0x4b>
  r = fstat(fd, st);
 4e0:	83 ec 08             	sub    $0x8,%esp
 4e3:	ff 75 0c             	push   0xc(%ebp)
 4e6:	ff 75 f4             	push   -0xc(%ebp)
 4e9:	e8 03 01 00 00       	call   5f1 <fstat>
 4ee:	83 c4 10             	add    $0x10,%esp
 4f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 4f4:	83 ec 0c             	sub    $0xc,%esp
 4f7:	ff 75 f4             	push   -0xc(%ebp)
 4fa:	e8 c2 00 00 00       	call   5c1 <close>
 4ff:	83 c4 10             	add    $0x10,%esp
  return r;
 502:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 505:	c9                   	leave  
 506:	c3                   	ret    

00000507 <atoi>:

int
atoi(const char *s)
{
 507:	55                   	push   %ebp
 508:	89 e5                	mov    %esp,%ebp
 50a:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 50d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 514:	eb 25                	jmp    53b <atoi+0x34>
    n = n*10 + *s++ - '0';
 516:	8b 55 fc             	mov    -0x4(%ebp),%edx
 519:	89 d0                	mov    %edx,%eax
 51b:	c1 e0 02             	shl    $0x2,%eax
 51e:	01 d0                	add    %edx,%eax
 520:	01 c0                	add    %eax,%eax
 522:	89 c1                	mov    %eax,%ecx
 524:	8b 45 08             	mov    0x8(%ebp),%eax
 527:	8d 50 01             	lea    0x1(%eax),%edx
 52a:	89 55 08             	mov    %edx,0x8(%ebp)
 52d:	0f b6 00             	movzbl (%eax),%eax
 530:	0f be c0             	movsbl %al,%eax
 533:	01 c8                	add    %ecx,%eax
 535:	83 e8 30             	sub    $0x30,%eax
 538:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 53b:	8b 45 08             	mov    0x8(%ebp),%eax
 53e:	0f b6 00             	movzbl (%eax),%eax
 541:	3c 2f                	cmp    $0x2f,%al
 543:	7e 0a                	jle    54f <atoi+0x48>
 545:	8b 45 08             	mov    0x8(%ebp),%eax
 548:	0f b6 00             	movzbl (%eax),%eax
 54b:	3c 39                	cmp    $0x39,%al
 54d:	7e c7                	jle    516 <atoi+0xf>
  return n;
 54f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 552:	c9                   	leave  
 553:	c3                   	ret    

00000554 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 554:	55                   	push   %ebp
 555:	89 e5                	mov    %esp,%ebp
 557:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 55a:	8b 45 08             	mov    0x8(%ebp),%eax
 55d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 560:	8b 45 0c             	mov    0xc(%ebp),%eax
 563:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 566:	eb 17                	jmp    57f <memmove+0x2b>
    *dst++ = *src++;
 568:	8b 55 f8             	mov    -0x8(%ebp),%edx
 56b:	8d 42 01             	lea    0x1(%edx),%eax
 56e:	89 45 f8             	mov    %eax,-0x8(%ebp)
 571:	8b 45 fc             	mov    -0x4(%ebp),%eax
 574:	8d 48 01             	lea    0x1(%eax),%ecx
 577:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 57a:	0f b6 12             	movzbl (%edx),%edx
 57d:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 57f:	8b 45 10             	mov    0x10(%ebp),%eax
 582:	8d 50 ff             	lea    -0x1(%eax),%edx
 585:	89 55 10             	mov    %edx,0x10(%ebp)
 588:	85 c0                	test   %eax,%eax
 58a:	7f dc                	jg     568 <memmove+0x14>
  return vdst;
 58c:	8b 45 08             	mov    0x8(%ebp),%eax
}
 58f:	c9                   	leave  
 590:	c3                   	ret    

00000591 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 591:	b8 01 00 00 00       	mov    $0x1,%eax
 596:	cd 40                	int    $0x40
 598:	c3                   	ret    

00000599 <exit>:
SYSCALL(exit)
 599:	b8 02 00 00 00       	mov    $0x2,%eax
 59e:	cd 40                	int    $0x40
 5a0:	c3                   	ret    

000005a1 <wait>:
SYSCALL(wait)
 5a1:	b8 03 00 00 00       	mov    $0x3,%eax
 5a6:	cd 40                	int    $0x40
 5a8:	c3                   	ret    

000005a9 <pipe>:
SYSCALL(pipe)
 5a9:	b8 04 00 00 00       	mov    $0x4,%eax
 5ae:	cd 40                	int    $0x40
 5b0:	c3                   	ret    

000005b1 <read>:
SYSCALL(read)
 5b1:	b8 05 00 00 00       	mov    $0x5,%eax
 5b6:	cd 40                	int    $0x40
 5b8:	c3                   	ret    

000005b9 <write>:
SYSCALL(write)
 5b9:	b8 10 00 00 00       	mov    $0x10,%eax
 5be:	cd 40                	int    $0x40
 5c0:	c3                   	ret    

000005c1 <close>:
SYSCALL(close)
 5c1:	b8 15 00 00 00       	mov    $0x15,%eax
 5c6:	cd 40                	int    $0x40
 5c8:	c3                   	ret    

000005c9 <kill>:
SYSCALL(kill)
 5c9:	b8 06 00 00 00       	mov    $0x6,%eax
 5ce:	cd 40                	int    $0x40
 5d0:	c3                   	ret    

000005d1 <exec>:
SYSCALL(exec)
 5d1:	b8 07 00 00 00       	mov    $0x7,%eax
 5d6:	cd 40                	int    $0x40
 5d8:	c3                   	ret    

000005d9 <open>:
SYSCALL(open)
 5d9:	b8 0f 00 00 00       	mov    $0xf,%eax
 5de:	cd 40                	int    $0x40
 5e0:	c3                   	ret    

000005e1 <mknod>:
SYSCALL(mknod)
 5e1:	b8 11 00 00 00       	mov    $0x11,%eax
 5e6:	cd 40                	int    $0x40
 5e8:	c3                   	ret    

000005e9 <unlink>:
SYSCALL(unlink)
 5e9:	b8 12 00 00 00       	mov    $0x12,%eax
 5ee:	cd 40                	int    $0x40
 5f0:	c3                   	ret    

000005f1 <fstat>:
SYSCALL(fstat)
 5f1:	b8 08 00 00 00       	mov    $0x8,%eax
 5f6:	cd 40                	int    $0x40
 5f8:	c3                   	ret    

000005f9 <link>:
SYSCALL(link)
 5f9:	b8 13 00 00 00       	mov    $0x13,%eax
 5fe:	cd 40                	int    $0x40
 600:	c3                   	ret    

00000601 <mkdir>:
SYSCALL(mkdir)
 601:	b8 14 00 00 00       	mov    $0x14,%eax
 606:	cd 40                	int    $0x40
 608:	c3                   	ret    

00000609 <chdir>:
SYSCALL(chdir)
 609:	b8 09 00 00 00       	mov    $0x9,%eax
 60e:	cd 40                	int    $0x40
 610:	c3                   	ret    

00000611 <dup>:
SYSCALL(dup)
 611:	b8 0a 00 00 00       	mov    $0xa,%eax
 616:	cd 40                	int    $0x40
 618:	c3                   	ret    

00000619 <getpid>:
SYSCALL(getpid)
 619:	b8 0b 00 00 00       	mov    $0xb,%eax
 61e:	cd 40                	int    $0x40
 620:	c3                   	ret    

00000621 <sbrk>:
SYSCALL(sbrk)
 621:	b8 0c 00 00 00       	mov    $0xc,%eax
 626:	cd 40                	int    $0x40
 628:	c3                   	ret    

00000629 <sleep>:
SYSCALL(sleep)
 629:	b8 0d 00 00 00       	mov    $0xd,%eax
 62e:	cd 40                	int    $0x40
 630:	c3                   	ret    

00000631 <uptime>:
SYSCALL(uptime)
 631:	b8 0e 00 00 00       	mov    $0xe,%eax
 636:	cd 40                	int    $0x40
 638:	c3                   	ret    

00000639 <print_free_frame_cnt>:
SYSCALL(print_free_frame_cnt)  //CS 3320 project 2
 639:	b8 17 00 00 00       	mov    $0x17,%eax
 63e:	cd 40                	int    $0x40
 640:	c3                   	ret    

00000641 <set_page_allocator>:
SYSCALL(set_page_allocator) // CS 3320 project 2
 641:	b8 18 00 00 00       	mov    $0x18,%eax
 646:	cd 40                	int    $0x40
 648:	c3                   	ret    

00000649 <shmget>:
SYSCALL(shmget) // CS 3320 project 2
 649:	b8 19 00 00 00       	mov    $0x19,%eax
 64e:	cd 40                	int    $0x40
 650:	c3                   	ret    

00000651 <shmdel>:
SYSCALL(shmdel) // CS3320 project 2
 651:	b8 1a 00 00 00       	mov    $0x1a,%eax
 656:	cd 40                	int    $0x40
 658:	c3                   	ret    

00000659 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 659:	55                   	push   %ebp
 65a:	89 e5                	mov    %esp,%ebp
 65c:	83 ec 18             	sub    $0x18,%esp
 65f:	8b 45 0c             	mov    0xc(%ebp),%eax
 662:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 665:	83 ec 04             	sub    $0x4,%esp
 668:	6a 01                	push   $0x1
 66a:	8d 45 f4             	lea    -0xc(%ebp),%eax
 66d:	50                   	push   %eax
 66e:	ff 75 08             	push   0x8(%ebp)
 671:	e8 43 ff ff ff       	call   5b9 <write>
 676:	83 c4 10             	add    $0x10,%esp
}
 679:	90                   	nop
 67a:	c9                   	leave  
 67b:	c3                   	ret    

0000067c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 67c:	55                   	push   %ebp
 67d:	89 e5                	mov    %esp,%ebp
 67f:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 682:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 689:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 68d:	74 17                	je     6a6 <printint+0x2a>
 68f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 693:	79 11                	jns    6a6 <printint+0x2a>
    neg = 1;
 695:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 69c:	8b 45 0c             	mov    0xc(%ebp),%eax
 69f:	f7 d8                	neg    %eax
 6a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6a4:	eb 06                	jmp    6ac <printint+0x30>
  } else {
    x = xx;
 6a6:	8b 45 0c             	mov    0xc(%ebp),%eax
 6a9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 6ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 6b3:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6b9:	ba 00 00 00 00       	mov    $0x0,%edx
 6be:	f7 f1                	div    %ecx
 6c0:	89 d1                	mov    %edx,%ecx
 6c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6c5:	8d 50 01             	lea    0x1(%eax),%edx
 6c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6cb:	0f b6 91 d4 0d 00 00 	movzbl 0xdd4(%ecx),%edx
 6d2:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 6d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
 6d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
 6dc:	ba 00 00 00 00       	mov    $0x0,%edx
 6e1:	f7 f1                	div    %ecx
 6e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
 6e6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 6ea:	75 c7                	jne    6b3 <printint+0x37>
  if(neg)
 6ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 6f0:	74 2d                	je     71f <printint+0xa3>
    buf[i++] = '-';
 6f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
 6f5:	8d 50 01             	lea    0x1(%eax),%edx
 6f8:	89 55 f4             	mov    %edx,-0xc(%ebp)
 6fb:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 700:	eb 1d                	jmp    71f <printint+0xa3>
    putc(fd, buf[i]);
 702:	8d 55 dc             	lea    -0x24(%ebp),%edx
 705:	8b 45 f4             	mov    -0xc(%ebp),%eax
 708:	01 d0                	add    %edx,%eax
 70a:	0f b6 00             	movzbl (%eax),%eax
 70d:	0f be c0             	movsbl %al,%eax
 710:	83 ec 08             	sub    $0x8,%esp
 713:	50                   	push   %eax
 714:	ff 75 08             	push   0x8(%ebp)
 717:	e8 3d ff ff ff       	call   659 <putc>
 71c:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 71f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 723:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 727:	79 d9                	jns    702 <printint+0x86>
}
 729:	90                   	nop
 72a:	90                   	nop
 72b:	c9                   	leave  
 72c:	c3                   	ret    

0000072d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 72d:	55                   	push   %ebp
 72e:	89 e5                	mov    %esp,%ebp
 730:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 733:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 73a:	8d 45 0c             	lea    0xc(%ebp),%eax
 73d:	83 c0 04             	add    $0x4,%eax
 740:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 743:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 74a:	e9 59 01 00 00       	jmp    8a8 <printf+0x17b>
    c = fmt[i] & 0xff;
 74f:	8b 55 0c             	mov    0xc(%ebp),%edx
 752:	8b 45 f0             	mov    -0x10(%ebp),%eax
 755:	01 d0                	add    %edx,%eax
 757:	0f b6 00             	movzbl (%eax),%eax
 75a:	0f be c0             	movsbl %al,%eax
 75d:	25 ff 00 00 00       	and    $0xff,%eax
 762:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 765:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 769:	75 2c                	jne    797 <printf+0x6a>
      if(c == '%'){
 76b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 76f:	75 0c                	jne    77d <printf+0x50>
        state = '%';
 771:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 778:	e9 27 01 00 00       	jmp    8a4 <printf+0x177>
      } else {
        putc(fd, c);
 77d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 780:	0f be c0             	movsbl %al,%eax
 783:	83 ec 08             	sub    $0x8,%esp
 786:	50                   	push   %eax
 787:	ff 75 08             	push   0x8(%ebp)
 78a:	e8 ca fe ff ff       	call   659 <putc>
 78f:	83 c4 10             	add    $0x10,%esp
 792:	e9 0d 01 00 00       	jmp    8a4 <printf+0x177>
      }
    } else if(state == '%'){
 797:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 79b:	0f 85 03 01 00 00    	jne    8a4 <printf+0x177>
      if(c == 'd'){
 7a1:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 7a5:	75 1e                	jne    7c5 <printf+0x98>
        printint(fd, *ap, 10, 1);
 7a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7aa:	8b 00                	mov    (%eax),%eax
 7ac:	6a 01                	push   $0x1
 7ae:	6a 0a                	push   $0xa
 7b0:	50                   	push   %eax
 7b1:	ff 75 08             	push   0x8(%ebp)
 7b4:	e8 c3 fe ff ff       	call   67c <printint>
 7b9:	83 c4 10             	add    $0x10,%esp
        ap++;
 7bc:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7c0:	e9 d8 00 00 00       	jmp    89d <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 7c5:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 7c9:	74 06                	je     7d1 <printf+0xa4>
 7cb:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 7cf:	75 1e                	jne    7ef <printf+0xc2>
        printint(fd, *ap, 16, 0);
 7d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7d4:	8b 00                	mov    (%eax),%eax
 7d6:	6a 00                	push   $0x0
 7d8:	6a 10                	push   $0x10
 7da:	50                   	push   %eax
 7db:	ff 75 08             	push   0x8(%ebp)
 7de:	e8 99 fe ff ff       	call   67c <printint>
 7e3:	83 c4 10             	add    $0x10,%esp
        ap++;
 7e6:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 7ea:	e9 ae 00 00 00       	jmp    89d <printf+0x170>
      } else if(c == 's'){
 7ef:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 7f3:	75 43                	jne    838 <printf+0x10b>
        s = (char*)*ap;
 7f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
 7f8:	8b 00                	mov    (%eax),%eax
 7fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 7fd:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 801:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 805:	75 25                	jne    82c <printf+0xff>
          s = "(null)";
 807:	c7 45 f4 2e 0b 00 00 	movl   $0xb2e,-0xc(%ebp)
        while(*s != 0){
 80e:	eb 1c                	jmp    82c <printf+0xff>
          putc(fd, *s);
 810:	8b 45 f4             	mov    -0xc(%ebp),%eax
 813:	0f b6 00             	movzbl (%eax),%eax
 816:	0f be c0             	movsbl %al,%eax
 819:	83 ec 08             	sub    $0x8,%esp
 81c:	50                   	push   %eax
 81d:	ff 75 08             	push   0x8(%ebp)
 820:	e8 34 fe ff ff       	call   659 <putc>
 825:	83 c4 10             	add    $0x10,%esp
          s++;
 828:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 82c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 82f:	0f b6 00             	movzbl (%eax),%eax
 832:	84 c0                	test   %al,%al
 834:	75 da                	jne    810 <printf+0xe3>
 836:	eb 65                	jmp    89d <printf+0x170>
        }
      } else if(c == 'c'){
 838:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 83c:	75 1d                	jne    85b <printf+0x12e>
        putc(fd, *ap);
 83e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 841:	8b 00                	mov    (%eax),%eax
 843:	0f be c0             	movsbl %al,%eax
 846:	83 ec 08             	sub    $0x8,%esp
 849:	50                   	push   %eax
 84a:	ff 75 08             	push   0x8(%ebp)
 84d:	e8 07 fe ff ff       	call   659 <putc>
 852:	83 c4 10             	add    $0x10,%esp
        ap++;
 855:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 859:	eb 42                	jmp    89d <printf+0x170>
      } else if(c == '%'){
 85b:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 85f:	75 17                	jne    878 <printf+0x14b>
        putc(fd, c);
 861:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 864:	0f be c0             	movsbl %al,%eax
 867:	83 ec 08             	sub    $0x8,%esp
 86a:	50                   	push   %eax
 86b:	ff 75 08             	push   0x8(%ebp)
 86e:	e8 e6 fd ff ff       	call   659 <putc>
 873:	83 c4 10             	add    $0x10,%esp
 876:	eb 25                	jmp    89d <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 878:	83 ec 08             	sub    $0x8,%esp
 87b:	6a 25                	push   $0x25
 87d:	ff 75 08             	push   0x8(%ebp)
 880:	e8 d4 fd ff ff       	call   659 <putc>
 885:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 888:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 88b:	0f be c0             	movsbl %al,%eax
 88e:	83 ec 08             	sub    $0x8,%esp
 891:	50                   	push   %eax
 892:	ff 75 08             	push   0x8(%ebp)
 895:	e8 bf fd ff ff       	call   659 <putc>
 89a:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 89d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 8a4:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 8a8:	8b 55 0c             	mov    0xc(%ebp),%edx
 8ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
 8ae:	01 d0                	add    %edx,%eax
 8b0:	0f b6 00             	movzbl (%eax),%eax
 8b3:	84 c0                	test   %al,%al
 8b5:	0f 85 94 fe ff ff    	jne    74f <printf+0x22>
    }
  }
}
 8bb:	90                   	nop
 8bc:	90                   	nop
 8bd:	c9                   	leave  
 8be:	c3                   	ret    

000008bf <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8bf:	55                   	push   %ebp
 8c0:	89 e5                	mov    %esp,%ebp
 8c2:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c5:	8b 45 08             	mov    0x8(%ebp),%eax
 8c8:	83 e8 08             	sub    $0x8,%eax
 8cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8ce:	a1 00 0e 00 00       	mov    0xe00,%eax
 8d3:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8d6:	eb 24                	jmp    8fc <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8db:	8b 00                	mov    (%eax),%eax
 8dd:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 8e0:	72 12                	jb     8f4 <free+0x35>
 8e2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8e5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 8e8:	77 24                	ja     90e <free+0x4f>
 8ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8ed:	8b 00                	mov    (%eax),%eax
 8ef:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 8f2:	72 1a                	jb     90e <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f4:	8b 45 fc             	mov    -0x4(%ebp),%eax
 8f7:	8b 00                	mov    (%eax),%eax
 8f9:	89 45 fc             	mov    %eax,-0x4(%ebp)
 8fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
 8ff:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 902:	76 d4                	jbe    8d8 <free+0x19>
 904:	8b 45 fc             	mov    -0x4(%ebp),%eax
 907:	8b 00                	mov    (%eax),%eax
 909:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 90c:	73 ca                	jae    8d8 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 90e:	8b 45 f8             	mov    -0x8(%ebp),%eax
 911:	8b 40 04             	mov    0x4(%eax),%eax
 914:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 91b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 91e:	01 c2                	add    %eax,%edx
 920:	8b 45 fc             	mov    -0x4(%ebp),%eax
 923:	8b 00                	mov    (%eax),%eax
 925:	39 c2                	cmp    %eax,%edx
 927:	75 24                	jne    94d <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 929:	8b 45 f8             	mov    -0x8(%ebp),%eax
 92c:	8b 50 04             	mov    0x4(%eax),%edx
 92f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 932:	8b 00                	mov    (%eax),%eax
 934:	8b 40 04             	mov    0x4(%eax),%eax
 937:	01 c2                	add    %eax,%edx
 939:	8b 45 f8             	mov    -0x8(%ebp),%eax
 93c:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 93f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 942:	8b 00                	mov    (%eax),%eax
 944:	8b 10                	mov    (%eax),%edx
 946:	8b 45 f8             	mov    -0x8(%ebp),%eax
 949:	89 10                	mov    %edx,(%eax)
 94b:	eb 0a                	jmp    957 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 94d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 950:	8b 10                	mov    (%eax),%edx
 952:	8b 45 f8             	mov    -0x8(%ebp),%eax
 955:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 957:	8b 45 fc             	mov    -0x4(%ebp),%eax
 95a:	8b 40 04             	mov    0x4(%eax),%eax
 95d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 964:	8b 45 fc             	mov    -0x4(%ebp),%eax
 967:	01 d0                	add    %edx,%eax
 969:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 96c:	75 20                	jne    98e <free+0xcf>
    p->s.size += bp->s.size;
 96e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 971:	8b 50 04             	mov    0x4(%eax),%edx
 974:	8b 45 f8             	mov    -0x8(%ebp),%eax
 977:	8b 40 04             	mov    0x4(%eax),%eax
 97a:	01 c2                	add    %eax,%edx
 97c:	8b 45 fc             	mov    -0x4(%ebp),%eax
 97f:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 982:	8b 45 f8             	mov    -0x8(%ebp),%eax
 985:	8b 10                	mov    (%eax),%edx
 987:	8b 45 fc             	mov    -0x4(%ebp),%eax
 98a:	89 10                	mov    %edx,(%eax)
 98c:	eb 08                	jmp    996 <free+0xd7>
  } else
    p->s.ptr = bp;
 98e:	8b 45 fc             	mov    -0x4(%ebp),%eax
 991:	8b 55 f8             	mov    -0x8(%ebp),%edx
 994:	89 10                	mov    %edx,(%eax)
  freep = p;
 996:	8b 45 fc             	mov    -0x4(%ebp),%eax
 999:	a3 00 0e 00 00       	mov    %eax,0xe00
}
 99e:	90                   	nop
 99f:	c9                   	leave  
 9a0:	c3                   	ret    

000009a1 <morecore>:

static Header*
morecore(uint nu)
{
 9a1:	55                   	push   %ebp
 9a2:	89 e5                	mov    %esp,%ebp
 9a4:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 9a7:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 9ae:	77 07                	ja     9b7 <morecore+0x16>
    nu = 4096;
 9b0:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 9b7:	8b 45 08             	mov    0x8(%ebp),%eax
 9ba:	c1 e0 03             	shl    $0x3,%eax
 9bd:	83 ec 0c             	sub    $0xc,%esp
 9c0:	50                   	push   %eax
 9c1:	e8 5b fc ff ff       	call   621 <sbrk>
 9c6:	83 c4 10             	add    $0x10,%esp
 9c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 9cc:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 9d0:	75 07                	jne    9d9 <morecore+0x38>
    return 0;
 9d2:	b8 00 00 00 00       	mov    $0x0,%eax
 9d7:	eb 26                	jmp    9ff <morecore+0x5e>
  hp = (Header*)p;
 9d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 9df:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9e2:	8b 55 08             	mov    0x8(%ebp),%edx
 9e5:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 9e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9eb:	83 c0 08             	add    $0x8,%eax
 9ee:	83 ec 0c             	sub    $0xc,%esp
 9f1:	50                   	push   %eax
 9f2:	e8 c8 fe ff ff       	call   8bf <free>
 9f7:	83 c4 10             	add    $0x10,%esp
  return freep;
 9fa:	a1 00 0e 00 00       	mov    0xe00,%eax
}
 9ff:	c9                   	leave  
 a00:	c3                   	ret    

00000a01 <malloc>:

void*
malloc(uint nbytes)
{
 a01:	55                   	push   %ebp
 a02:	89 e5                	mov    %esp,%ebp
 a04:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a07:	8b 45 08             	mov    0x8(%ebp),%eax
 a0a:	83 c0 07             	add    $0x7,%eax
 a0d:	c1 e8 03             	shr    $0x3,%eax
 a10:	83 c0 01             	add    $0x1,%eax
 a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 a16:	a1 00 0e 00 00       	mov    0xe00,%eax
 a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 a1e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 a22:	75 23                	jne    a47 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 a24:	c7 45 f0 f8 0d 00 00 	movl   $0xdf8,-0x10(%ebp)
 a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a2e:	a3 00 0e 00 00       	mov    %eax,0xe00
 a33:	a1 00 0e 00 00       	mov    0xe00,%eax
 a38:	a3 f8 0d 00 00       	mov    %eax,0xdf8
    base.s.size = 0;
 a3d:	c7 05 fc 0d 00 00 00 	movl   $0x0,0xdfc
 a44:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a47:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a4a:	8b 00                	mov    (%eax),%eax
 a4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a52:	8b 40 04             	mov    0x4(%eax),%eax
 a55:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a58:	77 4d                	ja     aa7 <malloc+0xa6>
      if(p->s.size == nunits)
 a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a5d:	8b 40 04             	mov    0x4(%eax),%eax
 a60:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 a63:	75 0c                	jne    a71 <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a68:	8b 10                	mov    (%eax),%edx
 a6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a6d:	89 10                	mov    %edx,(%eax)
 a6f:	eb 26                	jmp    a97 <malloc+0x96>
      else {
        p->s.size -= nunits;
 a71:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a74:	8b 40 04             	mov    0x4(%eax),%eax
 a77:	2b 45 ec             	sub    -0x14(%ebp),%eax
 a7a:	89 c2                	mov    %eax,%edx
 a7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a7f:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 a82:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a85:	8b 40 04             	mov    0x4(%eax),%eax
 a88:	c1 e0 03             	shl    $0x3,%eax
 a8b:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 a91:	8b 55 ec             	mov    -0x14(%ebp),%edx
 a94:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 a97:	8b 45 f0             	mov    -0x10(%ebp),%eax
 a9a:	a3 00 0e 00 00       	mov    %eax,0xe00
      return (void*)(p + 1);
 a9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aa2:	83 c0 08             	add    $0x8,%eax
 aa5:	eb 3b                	jmp    ae2 <malloc+0xe1>
    }
    if(p == freep)
 aa7:	a1 00 0e 00 00       	mov    0xe00,%eax
 aac:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 aaf:	75 1e                	jne    acf <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 ab1:	83 ec 0c             	sub    $0xc,%esp
 ab4:	ff 75 ec             	push   -0x14(%ebp)
 ab7:	e8 e5 fe ff ff       	call   9a1 <morecore>
 abc:	83 c4 10             	add    $0x10,%esp
 abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
 ac2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 ac6:	75 07                	jne    acf <malloc+0xce>
        return 0;
 ac8:	b8 00 00 00 00       	mov    $0x0,%eax
 acd:	eb 13                	jmp    ae2 <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad2:	89 45 f0             	mov    %eax,-0x10(%ebp)
 ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ad8:	8b 00                	mov    (%eax),%eax
 ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 add:	e9 6d ff ff ff       	jmp    a4f <malloc+0x4e>
  }
}
 ae2:	c9                   	leave  
 ae3:	c3                   	ret    
