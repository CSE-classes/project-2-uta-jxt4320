
_proj2_shm:     file format elf32-i386


Disassembly of section .text:

00000000 <test_case1>:

#include "types.h"
#include "user.h"

void test_case1()
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 ec 18             	sub    $0x18,%esp
   //Once done the shared page is deleted
   //Thoughout the whole process, only one physical frame is used
   //Once the shared page deleted, the phyiscal frame number should be the same
   //as the beginning
   //
   printf(1, "\n**********Test 1***************\n");
   6:	83 ec 08             	sub    $0x8,%esp
   9:	68 80 0d 00 00       	push   $0xd80
   e:	6a 01                	push   $0x1
  10:	e8 b1 09 00 00       	call   9c6 <printf>
  15:	83 c4 10             	add    $0x10,%esp
   print_free_frame_cnt();
  18:	e8 b5 08 00 00       	call   8d2 <print_free_frame_cnt>
   
   //fork the first process
   int pid = fork();
  1d:	e8 08 08 00 00       	call   82a <fork>
  22:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
  25:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  29:	75 63                	jne    8e <test_case1+0x8e>
   {
       char *vaddr = shmget(0);
  2b:	83 ec 0c             	sub    $0xc,%esp
  2e:	6a 00                	push   $0x0
  30:	e8 ad 08 00 00       	call   8e2 <shmget>
  35:	83 c4 10             	add    $0x10,%esp
  38:	89 45 ec             	mov    %eax,-0x14(%ebp)
       printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, 0);
  3b:	e8 72 08 00 00       	call   8b2 <getpid>
  40:	83 ec 0c             	sub    $0xc,%esp
  43:	6a 00                	push   $0x0
  45:	ff 75 ec             	push   -0x14(%ebp)
  48:	50                   	push   %eax
  49:	68 a4 0d 00 00       	push   $0xda4
  4e:	6a 01                	push   $0x1
  50:	e8 71 09 00 00       	call   9c6 <printf>
  55:	83 c4 20             	add    $0x20,%esp
       strcpy(vaddr, "Hello world\n");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 d1 0d 00 00       	push   $0xdd1
  60:	ff 75 ec             	push   -0x14(%ebp)
  63:	e8 99 05 00 00       	call   601 <strcpy>
  68:	83 c4 10             	add    $0x10,%esp
       printf(1, "PID:%d: string stored in addr:0x%x is %s\n", getpid(), vaddr, vaddr);
  6b:	e8 42 08 00 00       	call   8b2 <getpid>
  70:	83 ec 0c             	sub    $0xc,%esp
  73:	ff 75 ec             	push   -0x14(%ebp)
  76:	ff 75 ec             	push   -0x14(%ebp)
  79:	50                   	push   %eax
  7a:	68 e0 0d 00 00       	push   $0xde0
  7f:	6a 01                	push   $0x1
  81:	e8 40 09 00 00       	call   9c6 <printf>
  86:	83 c4 20             	add    $0x20,%esp
       exit();
  89:	e8 a4 07 00 00       	call   832 <exit>
   }
   wait();
  8e:	e8 a7 07 00 00       	call   83a <wait>
   print_free_frame_cnt();
  93:	e8 3a 08 00 00       	call   8d2 <print_free_frame_cnt>

   //fork the second process
   pid = fork();
  98:	e8 8d 07 00 00       	call   82a <fork>
  9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
  a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  a4:	75 50                	jne    f6 <test_case1+0xf6>
   {
       char *vaddr = shmget(0);
  a6:	83 ec 0c             	sub    $0xc,%esp
  a9:	6a 00                	push   $0x0
  ab:	e8 32 08 00 00       	call   8e2 <shmget>
  b0:	83 c4 10             	add    $0x10,%esp
  b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
       printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, 0);
  b6:	e8 f7 07 00 00       	call   8b2 <getpid>
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	6a 00                	push   $0x0
  c0:	ff 75 f0             	push   -0x10(%ebp)
  c3:	50                   	push   %eax
  c4:	68 a4 0d 00 00       	push   $0xda4
  c9:	6a 01                	push   $0x1
  cb:	e8 f6 08 00 00       	call   9c6 <printf>
  d0:	83 c4 20             	add    $0x20,%esp
       printf(1, "PID:%d: string stored in addr:0x%x is %s\n", getpid(), vaddr, vaddr);
  d3:	e8 da 07 00 00       	call   8b2 <getpid>
  d8:	83 ec 0c             	sub    $0xc,%esp
  db:	ff 75 f0             	push   -0x10(%ebp)
  de:	ff 75 f0             	push   -0x10(%ebp)
  e1:	50                   	push   %eax
  e2:	68 e0 0d 00 00       	push   $0xde0
  e7:	6a 01                	push   $0x1
  e9:	e8 d8 08 00 00       	call   9c6 <printf>
  ee:	83 c4 20             	add    $0x20,%esp
       exit();
  f1:	e8 3c 07 00 00       	call   832 <exit>
   }
   wait();
  f6:	e8 3f 07 00 00       	call   83a <wait>
   print_free_frame_cnt();
  fb:	e8 d2 07 00 00       	call   8d2 <print_free_frame_cnt>

   //for the third one which delete the shared page 0
   pid = fork();
 100:	e8 25 07 00 00       	call   82a <fork>
 105:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 108:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 10c:	75 29                	jne    137 <test_case1+0x137>
   {
       printf(1, "PID:%d: delete shared page:%d\n", getpid(), 0);
 10e:	e8 9f 07 00 00       	call   8b2 <getpid>
 113:	6a 00                	push   $0x0
 115:	50                   	push   %eax
 116:	68 0c 0e 00 00       	push   $0xe0c
 11b:	6a 01                	push   $0x1
 11d:	e8 a4 08 00 00       	call   9c6 <printf>
 122:	83 c4 10             	add    $0x10,%esp
       shmdel(0);
 125:	83 ec 0c             	sub    $0xc,%esp
 128:	6a 00                	push   $0x0
 12a:	e8 bb 07 00 00       	call   8ea <shmdel>
 12f:	83 c4 10             	add    $0x10,%esp
       exit();
 132:	e8 fb 06 00 00       	call   832 <exit>
   }
   wait();
 137:	e8 fe 06 00 00       	call   83a <wait>
   print_free_frame_cnt();
 13c:	e8 91 07 00 00       	call   8d2 <print_free_frame_cnt>

   return;
 141:	90                   	nop
}
 142:	c9                   	leave  
 143:	c3                   	ret    

00000144 <test_case2>:

void test_case2()
{
 144:	55                   	push   %ebp
 145:	89 e5                	mov    %esp,%ebp
 147:	83 ec 18             	sub    $0x18,%esp
   //quickly deleted the shared page 0.
   //
   //We then fork the second process, which attaches to the same shared page 0. 
   //However, since the shared page has been deleted by the first process, the second process attaches
   //to a brand new shared page 0. It can not fetch the string written by the first process
   printf(1, "\n**********Test 2***************\n");
 14a:	83 ec 08             	sub    $0x8,%esp
 14d:	68 2c 0e 00 00       	push   $0xe2c
 152:	6a 01                	push   $0x1
 154:	e8 6d 08 00 00       	call   9c6 <printf>
 159:	83 c4 10             	add    $0x10,%esp
   print_free_frame_cnt();
 15c:	e8 71 07 00 00       	call   8d2 <print_free_frame_cnt>

   // fork the first process
   int pid = fork();
 161:	e8 c4 06 00 00       	call   82a <fork>
 166:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 169:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 16d:	75 70                	jne    1df <test_case2+0x9b>
   {
       char *vaddr = shmget(0);
 16f:	83 ec 0c             	sub    $0xc,%esp
 172:	6a 00                	push   $0x0
 174:	e8 69 07 00 00       	call   8e2 <shmget>
 179:	83 c4 10             	add    $0x10,%esp
 17c:	89 45 ec             	mov    %eax,-0x14(%ebp)
       printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, 0);
 17f:	e8 2e 07 00 00       	call   8b2 <getpid>
 184:	83 ec 0c             	sub    $0xc,%esp
 187:	6a 00                	push   $0x0
 189:	ff 75 ec             	push   -0x14(%ebp)
 18c:	50                   	push   %eax
 18d:	68 a4 0d 00 00       	push   $0xda4
 192:	6a 01                	push   $0x1
 194:	e8 2d 08 00 00       	call   9c6 <printf>
 199:	83 c4 20             	add    $0x20,%esp
       strcpy(vaddr, "Hello world\n");
 19c:	83 ec 08             	sub    $0x8,%esp
 19f:	68 d1 0d 00 00       	push   $0xdd1
 1a4:	ff 75 ec             	push   -0x14(%ebp)
 1a7:	e8 55 04 00 00       	call   601 <strcpy>
 1ac:	83 c4 10             	add    $0x10,%esp
       printf(1, "PID:%d: string stored in addr:0x%x is %s\n", getpid(), vaddr, vaddr);
 1af:	e8 fe 06 00 00       	call   8b2 <getpid>
 1b4:	83 ec 0c             	sub    $0xc,%esp
 1b7:	ff 75 ec             	push   -0x14(%ebp)
 1ba:	ff 75 ec             	push   -0x14(%ebp)
 1bd:	50                   	push   %eax
 1be:	68 e0 0d 00 00       	push   $0xde0
 1c3:	6a 01                	push   $0x1
 1c5:	e8 fc 07 00 00       	call   9c6 <printf>
 1ca:	83 c4 20             	add    $0x20,%esp
       // we delete the shared page
       shmdel(0);
 1cd:	83 ec 0c             	sub    $0xc,%esp
 1d0:	6a 00                	push   $0x0
 1d2:	e8 13 07 00 00       	call   8ea <shmdel>
 1d7:	83 c4 10             	add    $0x10,%esp
       exit();
 1da:	e8 53 06 00 00       	call   832 <exit>
   }
   wait();
 1df:	e8 56 06 00 00       	call   83a <wait>
   print_free_frame_cnt();
 1e4:	e8 e9 06 00 00       	call   8d2 <print_free_frame_cnt>

   // fork the second process
   pid = fork();
 1e9:	e8 3c 06 00 00       	call   82a <fork>
 1ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 1f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 1f5:	75 50                	jne    247 <test_case2+0x103>
   {
       char *vaddr = shmget(0);
 1f7:	83 ec 0c             	sub    $0xc,%esp
 1fa:	6a 00                	push   $0x0
 1fc:	e8 e1 06 00 00       	call   8e2 <shmget>
 201:	83 c4 10             	add    $0x10,%esp
 204:	89 45 f0             	mov    %eax,-0x10(%ebp)
       printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, 0);
 207:	e8 a6 06 00 00       	call   8b2 <getpid>
 20c:	83 ec 0c             	sub    $0xc,%esp
 20f:	6a 00                	push   $0x0
 211:	ff 75 f0             	push   -0x10(%ebp)
 214:	50                   	push   %eax
 215:	68 a4 0d 00 00       	push   $0xda4
 21a:	6a 01                	push   $0x1
 21c:	e8 a5 07 00 00       	call   9c6 <printf>
 221:	83 c4 20             	add    $0x20,%esp
       printf(1, "PID:%d: string stored in addr:0x%x is %s\n", getpid(), vaddr, vaddr);
 224:	e8 89 06 00 00       	call   8b2 <getpid>
 229:	83 ec 0c             	sub    $0xc,%esp
 22c:	ff 75 f0             	push   -0x10(%ebp)
 22f:	ff 75 f0             	push   -0x10(%ebp)
 232:	50                   	push   %eax
 233:	68 e0 0d 00 00       	push   $0xde0
 238:	6a 01                	push   $0x1
 23a:	e8 87 07 00 00       	call   9c6 <printf>
 23f:	83 c4 20             	add    $0x20,%esp
       exit();
 242:	e8 eb 05 00 00       	call   832 <exit>
   }
   wait();
 247:	e8 ee 05 00 00       	call   83a <wait>
   print_free_frame_cnt();
 24c:	e8 81 06 00 00       	call   8d2 <print_free_frame_cnt>

   // for the third process to deleted the shared page
   pid = fork();
 251:	e8 d4 05 00 00       	call   82a <fork>
 256:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 259:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 25d:	75 29                	jne    288 <test_case2+0x144>
   {
       printf(1, "PID:%d: delete shared page:%d\n", getpid(), 0);
 25f:	e8 4e 06 00 00       	call   8b2 <getpid>
 264:	6a 00                	push   $0x0
 266:	50                   	push   %eax
 267:	68 0c 0e 00 00       	push   $0xe0c
 26c:	6a 01                	push   $0x1
 26e:	e8 53 07 00 00       	call   9c6 <printf>
 273:	83 c4 10             	add    $0x10,%esp
       shmdel(0);
 276:	83 ec 0c             	sub    $0xc,%esp
 279:	6a 00                	push   $0x0
 27b:	e8 6a 06 00 00       	call   8ea <shmdel>
 280:	83 c4 10             	add    $0x10,%esp
       exit();
 283:	e8 aa 05 00 00       	call   832 <exit>
   }
   wait();
 288:	e8 ad 05 00 00       	call   83a <wait>
   print_free_frame_cnt();
 28d:	e8 40 06 00 00       	call   8d2 <print_free_frame_cnt>

   return;
 292:	90                   	nop
}
 293:	c9                   	leave  
 294:	c3                   	ret    

00000295 <test_case3>:

void test_case3()
{
 295:	55                   	push   %ebp
 296:	89 e5                	mov    %esp,%ebp
 298:	83 ec 18             	sub    $0x18,%esp
   //Before these two processes exit, the third process tries to delete the shared page
   //As the shared page are referenced by exisitng processes, it should not be released
   //
   //Finally, once those two processes exit, we delete the shared page again. This time, 
   //it should succeed.
   printf(1, "\n**********Test 3***************\n");
 29b:	83 ec 08             	sub    $0x8,%esp
 29e:	68 50 0e 00 00       	push   $0xe50
 2a3:	6a 01                	push   $0x1
 2a5:	e8 1c 07 00 00       	call   9c6 <printf>
 2aa:	83 c4 10             	add    $0x10,%esp
   print_free_frame_cnt();
 2ad:	e8 20 06 00 00       	call   8d2 <print_free_frame_cnt>

   // fork the first process
   int pid = fork();
 2b2:	e8 73 05 00 00       	call   82a <fork>
 2b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 2ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 2be:	75 70                	jne    330 <test_case3+0x9b>
   {
       char *vaddr = shmget(0);
 2c0:	83 ec 0c             	sub    $0xc,%esp
 2c3:	6a 00                	push   $0x0
 2c5:	e8 18 06 00 00       	call   8e2 <shmget>
 2ca:	83 c4 10             	add    $0x10,%esp
 2cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
       printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, 0);
 2d0:	e8 dd 05 00 00       	call   8b2 <getpid>
 2d5:	83 ec 0c             	sub    $0xc,%esp
 2d8:	6a 00                	push   $0x0
 2da:	ff 75 ec             	push   -0x14(%ebp)
 2dd:	50                   	push   %eax
 2de:	68 a4 0d 00 00       	push   $0xda4
 2e3:	6a 01                	push   $0x1
 2e5:	e8 dc 06 00 00       	call   9c6 <printf>
 2ea:	83 c4 20             	add    $0x20,%esp
       strcpy(vaddr, "Hello world\n");
 2ed:	83 ec 08             	sub    $0x8,%esp
 2f0:	68 d1 0d 00 00       	push   $0xdd1
 2f5:	ff 75 ec             	push   -0x14(%ebp)
 2f8:	e8 04 03 00 00       	call   601 <strcpy>
 2fd:	83 c4 10             	add    $0x10,%esp
       printf(1, "PID:%d: string stored in addr:0x%x is %s\n", getpid(), vaddr, vaddr);
 300:	e8 ad 05 00 00       	call   8b2 <getpid>
 305:	83 ec 0c             	sub    $0xc,%esp
 308:	ff 75 ec             	push   -0x14(%ebp)
 30b:	ff 75 ec             	push   -0x14(%ebp)
 30e:	50                   	push   %eax
 30f:	68 e0 0d 00 00       	push   $0xde0
 314:	6a 01                	push   $0x1
 316:	e8 ab 06 00 00       	call   9c6 <printf>
 31b:	83 c4 20             	add    $0x20,%esp
       sleep(10);
 31e:	83 ec 0c             	sub    $0xc,%esp
 321:	6a 0a                	push   $0xa
 323:	e8 9a 05 00 00       	call   8c2 <sleep>
 328:	83 c4 10             	add    $0x10,%esp
       exit();
 32b:	e8 02 05 00 00       	call   832 <exit>
   }

   // fork the second process
   pid = fork();
 330:	e8 f5 04 00 00       	call   82a <fork>
 335:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 338:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 33c:	75 5d                	jne    39b <test_case3+0x106>
   {
       char *vaddr = shmget(0);
 33e:	83 ec 0c             	sub    $0xc,%esp
 341:	6a 00                	push   $0x0
 343:	e8 9a 05 00 00       	call   8e2 <shmget>
 348:	83 c4 10             	add    $0x10,%esp
 34b:	89 45 f0             	mov    %eax,-0x10(%ebp)
       printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, 0);
 34e:	e8 5f 05 00 00       	call   8b2 <getpid>
 353:	83 ec 0c             	sub    $0xc,%esp
 356:	6a 00                	push   $0x0
 358:	ff 75 f0             	push   -0x10(%ebp)
 35b:	50                   	push   %eax
 35c:	68 a4 0d 00 00       	push   $0xda4
 361:	6a 01                	push   $0x1
 363:	e8 5e 06 00 00       	call   9c6 <printf>
 368:	83 c4 20             	add    $0x20,%esp
       printf(1, "PID:%d: string stored in addr:0x%x is %s\n", getpid(), vaddr, vaddr);
 36b:	e8 42 05 00 00       	call   8b2 <getpid>
 370:	83 ec 0c             	sub    $0xc,%esp
 373:	ff 75 f0             	push   -0x10(%ebp)
 376:	ff 75 f0             	push   -0x10(%ebp)
 379:	50                   	push   %eax
 37a:	68 e0 0d 00 00       	push   $0xde0
 37f:	6a 01                	push   $0x1
 381:	e8 40 06 00 00       	call   9c6 <printf>
 386:	83 c4 20             	add    $0x20,%esp
       sleep(10);
 389:	83 ec 0c             	sub    $0xc,%esp
 38c:	6a 0a                	push   $0xa
 38e:	e8 2f 05 00 00       	call   8c2 <sleep>
 393:	83 c4 10             	add    $0x10,%esp
       exit();
 396:	e8 97 04 00 00       	call   832 <exit>
   }

   // fork the third process trying to delete the shared page
   pid = fork();
 39b:	e8 8a 04 00 00       	call   82a <fork>
 3a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 3a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3a7:	75 29                	jne    3d2 <test_case3+0x13d>
   {
       printf(1, "PID:%d: delete shared page:%d\n", getpid(), 0);
 3a9:	e8 04 05 00 00       	call   8b2 <getpid>
 3ae:	6a 00                	push   $0x0
 3b0:	50                   	push   %eax
 3b1:	68 0c 0e 00 00       	push   $0xe0c
 3b6:	6a 01                	push   $0x1
 3b8:	e8 09 06 00 00       	call   9c6 <printf>
 3bd:	83 c4 10             	add    $0x10,%esp
       shmdel(0);
 3c0:	83 ec 0c             	sub    $0xc,%esp
 3c3:	6a 00                	push   $0x0
 3c5:	e8 20 05 00 00       	call   8ea <shmdel>
 3ca:	83 c4 10             	add    $0x10,%esp
       exit();
 3cd:	e8 60 04 00 00       	call   832 <exit>
   }
   wait();
 3d2:	e8 63 04 00 00       	call   83a <wait>
   wait();
 3d7:	e8 5e 04 00 00       	call   83a <wait>
   wait();
 3dc:	e8 59 04 00 00       	call   83a <wait>

   // fork the third process to delete the shared page again
   pid = fork();
 3e1:	e8 44 04 00 00       	call   82a <fork>
 3e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   if (pid == 0)
 3e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 3ed:	75 29                	jne    418 <test_case3+0x183>
   {
       printf(1, "PID:%d: delete shared page:%d again\n", getpid(), 0);
 3ef:	e8 be 04 00 00       	call   8b2 <getpid>
 3f4:	6a 00                	push   $0x0
 3f6:	50                   	push   %eax
 3f7:	68 74 0e 00 00       	push   $0xe74
 3fc:	6a 01                	push   $0x1
 3fe:	e8 c3 05 00 00       	call   9c6 <printf>
 403:	83 c4 10             	add    $0x10,%esp
       shmdel(0);
 406:	83 ec 0c             	sub    $0xc,%esp
 409:	6a 00                	push   $0x0
 40b:	e8 da 04 00 00       	call   8ea <shmdel>
 410:	83 c4 10             	add    $0x10,%esp
       exit();
 413:	e8 1a 04 00 00       	call   832 <exit>
   }
   wait();
 418:	e8 1d 04 00 00       	call   83a <wait>
   print_free_frame_cnt();
 41d:	e8 b0 04 00 00       	call   8d2 <print_free_frame_cnt>

   return;
 422:	90                   	nop
}
 423:	c9                   	leave  
 424:	c3                   	ret    

00000425 <test_case4>:

void test_case4()
{
 425:	55                   	push   %ebp
 426:	89 e5                	mov    %esp,%ebp
 428:	53                   	push   %ebx
 429:	83 ec 24             	sub    $0x24,%esp
   // Some corner test cases
   // for example, we only support at most 10 shared pages
   // A shared page should be deleted twice
   printf(1, "\n**********Test 4***************\n");
 42c:	83 ec 08             	sub    $0x8,%esp
 42f:	68 9c 0e 00 00       	push   $0xe9c
 434:	6a 01                	push   $0x1
 436:	e8 8b 05 00 00       	call   9c6 <printf>
 43b:	83 c4 10             	add    $0x10,%esp
   print_free_frame_cnt();
 43e:	e8 8f 04 00 00       	call   8d2 <print_free_frame_cnt>

   //fork the first process
   int pid = fork();
 443:	e8 e2 03 00 00       	call   82a <fork>
 448:	89 45 ec             	mov    %eax,-0x14(%ebp)
   if (pid == 0)
 44b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 44f:	75 47                	jne    498 <test_case4+0x73>
   {
       char *vaddr;
       int i;
       for(i=0;i<=10;i++)
 451:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 458:	eb 33                	jmp    48d <test_case4+0x68>
       {
           vaddr = shmget(i);
 45a:	83 ec 0c             	sub    $0xc,%esp
 45d:	ff 75 f4             	push   -0xc(%ebp)
 460:	e8 7d 04 00 00       	call   8e2 <shmget>
 465:	83 c4 10             	add    $0x10,%esp
 468:	89 45 e4             	mov    %eax,-0x1c(%ebp)
       	   printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, i);
 46b:	e8 42 04 00 00       	call   8b2 <getpid>
 470:	83 ec 0c             	sub    $0xc,%esp
 473:	ff 75 f4             	push   -0xc(%ebp)
 476:	ff 75 e4             	push   -0x1c(%ebp)
 479:	50                   	push   %eax
 47a:	68 a4 0d 00 00       	push   $0xda4
 47f:	6a 01                	push   $0x1
 481:	e8 40 05 00 00       	call   9c6 <printf>
 486:	83 c4 20             	add    $0x20,%esp
       for(i=0;i<=10;i++)
 489:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
 48d:	83 7d f4 0a          	cmpl   $0xa,-0xc(%ebp)
 491:	7e c7                	jle    45a <test_case4+0x35>
       }
       exit();
 493:	e8 9a 03 00 00       	call   832 <exit>
   }
   wait();
 498:	e8 9d 03 00 00       	call   83a <wait>
   print_free_frame_cnt();
 49d:	e8 30 04 00 00       	call   8d2 <print_free_frame_cnt>

   //fork the second process
   pid = fork();
 4a2:	e8 83 03 00 00       	call   82a <fork>
 4a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
   if (pid == 0)
 4aa:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 4ae:	75 4b                	jne    4fb <test_case4+0xd6>
   {
       int i;
       for(i=0;i<=10;i++)
 4b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 4b7:	eb 2a                	jmp    4e3 <test_case4+0xbe>
       {
           printf(1, "PID:%d: delete shared page:%d\n", getpid(), i);
 4b9:	e8 f4 03 00 00       	call   8b2 <getpid>
 4be:	ff 75 f0             	push   -0x10(%ebp)
 4c1:	50                   	push   %eax
 4c2:	68 0c 0e 00 00       	push   $0xe0c
 4c7:	6a 01                	push   $0x1
 4c9:	e8 f8 04 00 00       	call   9c6 <printf>
 4ce:	83 c4 10             	add    $0x10,%esp
	   shmdel(i);
 4d1:	83 ec 0c             	sub    $0xc,%esp
 4d4:	ff 75 f0             	push   -0x10(%ebp)
 4d7:	e8 0e 04 00 00       	call   8ea <shmdel>
 4dc:	83 c4 10             	add    $0x10,%esp
       for(i=0;i<=10;i++)
 4df:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 4e3:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
 4e7:	7e d0                	jle    4b9 <test_case4+0x94>
       }
       // double deletion
       shmdel(0);
 4e9:	83 ec 0c             	sub    $0xc,%esp
 4ec:	6a 00                	push   $0x0
 4ee:	e8 f7 03 00 00       	call   8ea <shmdel>
 4f3:	83 c4 10             	add    $0x10,%esp
       exit();
 4f6:	e8 37 03 00 00       	call   832 <exit>
   }
   wait();
 4fb:	e8 3a 03 00 00       	call   83a <wait>
   print_free_frame_cnt();
 500:	e8 cd 03 00 00       	call   8d2 <print_free_frame_cnt>

   // for the third process
   pid = fork();
 505:	e8 20 03 00 00       	call   82a <fork>
 50a:	89 45 ec             	mov    %eax,-0x14(%ebp)
   if (pid == 0)
 50d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 511:	0f 85 95 00 00 00    	jne    5ac <test_case4+0x187>
   {
       char *vaddr;
       vaddr = shmget(0);
 517:	83 ec 0c             	sub    $0xc,%esp
 51a:	6a 00                	push   $0x0
 51c:	e8 c1 03 00 00       	call   8e2 <shmget>
 521:	83 c4 10             	add    $0x10,%esp
 524:	89 45 e8             	mov    %eax,-0x18(%ebp)
       printf(1, "PID:%d: return addr:0x%x for shared page:%d\n", getpid(), vaddr, 0);
 527:	e8 86 03 00 00       	call   8b2 <getpid>
 52c:	83 ec 0c             	sub    $0xc,%esp
 52f:	6a 00                	push   $0x0
 531:	ff 75 e8             	push   -0x18(%ebp)
 534:	50                   	push   %eax
 535:	68 a4 0d 00 00       	push   $0xda4
 53a:	6a 01                	push   $0x1
 53c:	e8 85 04 00 00       	call   9c6 <printf>
 541:	83 c4 20             	add    $0x20,%esp
       vaddr[0] = 'a';
 544:	8b 45 e8             	mov    -0x18(%ebp),%eax
 547:	c6 00 61             	movb   $0x61,(%eax)
       printf(1, "PID:%d: char stored at addr:0x%x is %c\n", getpid(), vaddr, vaddr[0]);
 54a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 54d:	0f b6 00             	movzbl (%eax),%eax
 550:	0f be d8             	movsbl %al,%ebx
 553:	e8 5a 03 00 00       	call   8b2 <getpid>
 558:	83 ec 0c             	sub    $0xc,%esp
 55b:	53                   	push   %ebx
 55c:	ff 75 e8             	push   -0x18(%ebp)
 55f:	50                   	push   %eax
 560:	68 c0 0e 00 00       	push   $0xec0
 565:	6a 01                	push   $0x1
 567:	e8 5a 04 00 00       	call   9c6 <printf>
 56c:	83 c4 20             	add    $0x20,%esp
       shmdel(0);
 56f:	83 ec 0c             	sub    $0xc,%esp
 572:	6a 00                	push   $0x0
 574:	e8 71 03 00 00       	call   8ea <shmdel>
 579:	83 c4 10             	add    $0x10,%esp
       vaddr[0] = 'b';
 57c:	8b 45 e8             	mov    -0x18(%ebp),%eax
 57f:	c6 00 62             	movb   $0x62,(%eax)
       printf(1, "PID:%d: char stored at addr:0x%x is %c\n", getpid(), vaddr, vaddr[0]);
 582:	8b 45 e8             	mov    -0x18(%ebp),%eax
 585:	0f b6 00             	movzbl (%eax),%eax
 588:	0f be d8             	movsbl %al,%ebx
 58b:	e8 22 03 00 00       	call   8b2 <getpid>
 590:	83 ec 0c             	sub    $0xc,%esp
 593:	53                   	push   %ebx
 594:	ff 75 e8             	push   -0x18(%ebp)
 597:	50                   	push   %eax
 598:	68 c0 0e 00 00       	push   $0xec0
 59d:	6a 01                	push   $0x1
 59f:	e8 22 04 00 00       	call   9c6 <printf>
 5a4:	83 c4 20             	add    $0x20,%esp
       exit();
 5a7:	e8 86 02 00 00       	call   832 <exit>
   }
   wait();
 5ac:	e8 89 02 00 00       	call   83a <wait>
   print_free_frame_cnt();
 5b1:	e8 1c 03 00 00       	call   8d2 <print_free_frame_cnt>

   return;
 5b6:	90                   	nop
}
 5b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ba:	c9                   	leave  
 5bb:	c3                   	ret    

000005bc <main>:

int
main(int argc, char *argv[])
{
 5bc:	55                   	push   %ebp
 5bd:	89 e5                	mov    %esp,%ebp
 5bf:	83 e4 f0             	and    $0xfffffff0,%esp

   // test 1
   test_case1();
 5c2:	e8 39 fa ff ff       	call   0 <test_case1>

   // test 2
   test_case2();
 5c7:	e8 78 fb ff ff       	call   144 <test_case2>

   // test 3
   test_case3();
 5cc:	e8 c4 fc ff ff       	call   295 <test_case3>

   // test 4
   test_case4();
 5d1:	e8 4f fe ff ff       	call   425 <test_case4>
   exit();   
 5d6:	e8 57 02 00 00       	call   832 <exit>

000005db <stosb>:
               "cc");
}

static inline void
stosb(void *addr, int data, int cnt)
{
 5db:	55                   	push   %ebp
 5dc:	89 e5                	mov    %esp,%ebp
 5de:	57                   	push   %edi
 5df:	53                   	push   %ebx
  asm volatile("cld; rep stosb" :
 5e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
 5e3:	8b 55 10             	mov    0x10(%ebp),%edx
 5e6:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e9:	89 cb                	mov    %ecx,%ebx
 5eb:	89 df                	mov    %ebx,%edi
 5ed:	89 d1                	mov    %edx,%ecx
 5ef:	fc                   	cld    
 5f0:	f3 aa                	rep stos %al,%es:(%edi)
 5f2:	89 ca                	mov    %ecx,%edx
 5f4:	89 fb                	mov    %edi,%ebx
 5f6:	89 5d 08             	mov    %ebx,0x8(%ebp)
 5f9:	89 55 10             	mov    %edx,0x10(%ebp)
               "=D" (addr), "=c" (cnt) :
               "0" (addr), "1" (cnt), "a" (data) :
               "memory", "cc");
}
 5fc:	90                   	nop
 5fd:	5b                   	pop    %ebx
 5fe:	5f                   	pop    %edi
 5ff:	5d                   	pop    %ebp
 600:	c3                   	ret    

00000601 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 601:	55                   	push   %ebp
 602:	89 e5                	mov    %esp,%ebp
 604:	83 ec 10             	sub    $0x10,%esp
  char *os;

  os = s;
 607:	8b 45 08             	mov    0x8(%ebp),%eax
 60a:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while((*s++ = *t++) != 0)
 60d:	90                   	nop
 60e:	8b 55 0c             	mov    0xc(%ebp),%edx
 611:	8d 42 01             	lea    0x1(%edx),%eax
 614:	89 45 0c             	mov    %eax,0xc(%ebp)
 617:	8b 45 08             	mov    0x8(%ebp),%eax
 61a:	8d 48 01             	lea    0x1(%eax),%ecx
 61d:	89 4d 08             	mov    %ecx,0x8(%ebp)
 620:	0f b6 12             	movzbl (%edx),%edx
 623:	88 10                	mov    %dl,(%eax)
 625:	0f b6 00             	movzbl (%eax),%eax
 628:	84 c0                	test   %al,%al
 62a:	75 e2                	jne    60e <strcpy+0xd>
    ;
  return os;
 62c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 62f:	c9                   	leave  
 630:	c3                   	ret    

00000631 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 631:	55                   	push   %ebp
 632:	89 e5                	mov    %esp,%ebp
  while(*p && *p == *q)
 634:	eb 08                	jmp    63e <strcmp+0xd>
    p++, q++;
 636:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 63a:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
  while(*p && *p == *q)
 63e:	8b 45 08             	mov    0x8(%ebp),%eax
 641:	0f b6 00             	movzbl (%eax),%eax
 644:	84 c0                	test   %al,%al
 646:	74 10                	je     658 <strcmp+0x27>
 648:	8b 45 08             	mov    0x8(%ebp),%eax
 64b:	0f b6 10             	movzbl (%eax),%edx
 64e:	8b 45 0c             	mov    0xc(%ebp),%eax
 651:	0f b6 00             	movzbl (%eax),%eax
 654:	38 c2                	cmp    %al,%dl
 656:	74 de                	je     636 <strcmp+0x5>
  return (uchar)*p - (uchar)*q;
 658:	8b 45 08             	mov    0x8(%ebp),%eax
 65b:	0f b6 00             	movzbl (%eax),%eax
 65e:	0f b6 d0             	movzbl %al,%edx
 661:	8b 45 0c             	mov    0xc(%ebp),%eax
 664:	0f b6 00             	movzbl (%eax),%eax
 667:	0f b6 c8             	movzbl %al,%ecx
 66a:	89 d0                	mov    %edx,%eax
 66c:	29 c8                	sub    %ecx,%eax
}
 66e:	5d                   	pop    %ebp
 66f:	c3                   	ret    

00000670 <strlen>:

uint
strlen(char *s)
{
 670:	55                   	push   %ebp
 671:	89 e5                	mov    %esp,%ebp
 673:	83 ec 10             	sub    $0x10,%esp
  int n;

  for(n = 0; s[n]; n++)
 676:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
 67d:	eb 04                	jmp    683 <strlen+0x13>
 67f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 683:	8b 55 fc             	mov    -0x4(%ebp),%edx
 686:	8b 45 08             	mov    0x8(%ebp),%eax
 689:	01 d0                	add    %edx,%eax
 68b:	0f b6 00             	movzbl (%eax),%eax
 68e:	84 c0                	test   %al,%al
 690:	75 ed                	jne    67f <strlen+0xf>
    ;
  return n;
 692:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 695:	c9                   	leave  
 696:	c3                   	ret    

00000697 <memset>:

void*
memset(void *dst, int c, uint n)
{
 697:	55                   	push   %ebp
 698:	89 e5                	mov    %esp,%ebp
  stosb(dst, c, n);
 69a:	8b 45 10             	mov    0x10(%ebp),%eax
 69d:	50                   	push   %eax
 69e:	ff 75 0c             	push   0xc(%ebp)
 6a1:	ff 75 08             	push   0x8(%ebp)
 6a4:	e8 32 ff ff ff       	call   5db <stosb>
 6a9:	83 c4 0c             	add    $0xc,%esp
  return dst;
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
}
 6af:	c9                   	leave  
 6b0:	c3                   	ret    

000006b1 <strchr>:

char*
strchr(const char *s, char c)
{
 6b1:	55                   	push   %ebp
 6b2:	89 e5                	mov    %esp,%ebp
 6b4:	83 ec 04             	sub    $0x4,%esp
 6b7:	8b 45 0c             	mov    0xc(%ebp),%eax
 6ba:	88 45 fc             	mov    %al,-0x4(%ebp)
  for(; *s; s++)
 6bd:	eb 14                	jmp    6d3 <strchr+0x22>
    if(*s == c)
 6bf:	8b 45 08             	mov    0x8(%ebp),%eax
 6c2:	0f b6 00             	movzbl (%eax),%eax
 6c5:	38 45 fc             	cmp    %al,-0x4(%ebp)
 6c8:	75 05                	jne    6cf <strchr+0x1e>
      return (char*)s;
 6ca:	8b 45 08             	mov    0x8(%ebp),%eax
 6cd:	eb 13                	jmp    6e2 <strchr+0x31>
  for(; *s; s++)
 6cf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 6d3:	8b 45 08             	mov    0x8(%ebp),%eax
 6d6:	0f b6 00             	movzbl (%eax),%eax
 6d9:	84 c0                	test   %al,%al
 6db:	75 e2                	jne    6bf <strchr+0xe>
  return 0;
 6dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
 6e2:	c9                   	leave  
 6e3:	c3                   	ret    

000006e4 <gets>:

char*
gets(char *buf, int max)
{
 6e4:	55                   	push   %ebp
 6e5:	89 e5                	mov    %esp,%ebp
 6e7:	83 ec 18             	sub    $0x18,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 6ea:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
 6f1:	eb 42                	jmp    735 <gets+0x51>
    cc = read(0, &c, 1);
 6f3:	83 ec 04             	sub    $0x4,%esp
 6f6:	6a 01                	push   $0x1
 6f8:	8d 45 ef             	lea    -0x11(%ebp),%eax
 6fb:	50                   	push   %eax
 6fc:	6a 00                	push   $0x0
 6fe:	e8 47 01 00 00       	call   84a <read>
 703:	83 c4 10             	add    $0x10,%esp
 706:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(cc < 1)
 709:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 70d:	7e 33                	jle    742 <gets+0x5e>
      break;
    buf[i++] = c;
 70f:	8b 45 f4             	mov    -0xc(%ebp),%eax
 712:	8d 50 01             	lea    0x1(%eax),%edx
 715:	89 55 f4             	mov    %edx,-0xc(%ebp)
 718:	89 c2                	mov    %eax,%edx
 71a:	8b 45 08             	mov    0x8(%ebp),%eax
 71d:	01 c2                	add    %eax,%edx
 71f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 723:	88 02                	mov    %al,(%edx)
    if(c == '\n' || c == '\r')
 725:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 729:	3c 0a                	cmp    $0xa,%al
 72b:	74 16                	je     743 <gets+0x5f>
 72d:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
 731:	3c 0d                	cmp    $0xd,%al
 733:	74 0e                	je     743 <gets+0x5f>
  for(i=0; i+1 < max; ){
 735:	8b 45 f4             	mov    -0xc(%ebp),%eax
 738:	83 c0 01             	add    $0x1,%eax
 73b:	39 45 0c             	cmp    %eax,0xc(%ebp)
 73e:	7f b3                	jg     6f3 <gets+0xf>
 740:	eb 01                	jmp    743 <gets+0x5f>
      break;
 742:	90                   	nop
      break;
  }
  buf[i] = '\0';
 743:	8b 55 f4             	mov    -0xc(%ebp),%edx
 746:	8b 45 08             	mov    0x8(%ebp),%eax
 749:	01 d0                	add    %edx,%eax
 74b:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
 74e:	8b 45 08             	mov    0x8(%ebp),%eax
}
 751:	c9                   	leave  
 752:	c3                   	ret    

00000753 <stat>:

int
stat(char *n, struct stat *st)
{
 753:	55                   	push   %ebp
 754:	89 e5                	mov    %esp,%ebp
 756:	83 ec 18             	sub    $0x18,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 759:	83 ec 08             	sub    $0x8,%esp
 75c:	6a 00                	push   $0x0
 75e:	ff 75 08             	push   0x8(%ebp)
 761:	e8 0c 01 00 00       	call   872 <open>
 766:	83 c4 10             	add    $0x10,%esp
 769:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(fd < 0)
 76c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 770:	79 07                	jns    779 <stat+0x26>
    return -1;
 772:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 777:	eb 25                	jmp    79e <stat+0x4b>
  r = fstat(fd, st);
 779:	83 ec 08             	sub    $0x8,%esp
 77c:	ff 75 0c             	push   0xc(%ebp)
 77f:	ff 75 f4             	push   -0xc(%ebp)
 782:	e8 03 01 00 00       	call   88a <fstat>
 787:	83 c4 10             	add    $0x10,%esp
 78a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  close(fd);
 78d:	83 ec 0c             	sub    $0xc,%esp
 790:	ff 75 f4             	push   -0xc(%ebp)
 793:	e8 c2 00 00 00       	call   85a <close>
 798:	83 c4 10             	add    $0x10,%esp
  return r;
 79b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
 79e:	c9                   	leave  
 79f:	c3                   	ret    

000007a0 <atoi>:

int
atoi(const char *s)
{
 7a0:	55                   	push   %ebp
 7a1:	89 e5                	mov    %esp,%ebp
 7a3:	83 ec 10             	sub    $0x10,%esp
  int n;

  n = 0;
 7a6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7ad:	eb 25                	jmp    7d4 <atoi+0x34>
    n = n*10 + *s++ - '0';
 7af:	8b 55 fc             	mov    -0x4(%ebp),%edx
 7b2:	89 d0                	mov    %edx,%eax
 7b4:	c1 e0 02             	shl    $0x2,%eax
 7b7:	01 d0                	add    %edx,%eax
 7b9:	01 c0                	add    %eax,%eax
 7bb:	89 c1                	mov    %eax,%ecx
 7bd:	8b 45 08             	mov    0x8(%ebp),%eax
 7c0:	8d 50 01             	lea    0x1(%eax),%edx
 7c3:	89 55 08             	mov    %edx,0x8(%ebp)
 7c6:	0f b6 00             	movzbl (%eax),%eax
 7c9:	0f be c0             	movsbl %al,%eax
 7cc:	01 c8                	add    %ecx,%eax
 7ce:	83 e8 30             	sub    $0x30,%eax
 7d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
  while('0' <= *s && *s <= '9')
 7d4:	8b 45 08             	mov    0x8(%ebp),%eax
 7d7:	0f b6 00             	movzbl (%eax),%eax
 7da:	3c 2f                	cmp    $0x2f,%al
 7dc:	7e 0a                	jle    7e8 <atoi+0x48>
 7de:	8b 45 08             	mov    0x8(%ebp),%eax
 7e1:	0f b6 00             	movzbl (%eax),%eax
 7e4:	3c 39                	cmp    $0x39,%al
 7e6:	7e c7                	jle    7af <atoi+0xf>
  return n;
 7e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
 7eb:	c9                   	leave  
 7ec:	c3                   	ret    

000007ed <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 7ed:	55                   	push   %ebp
 7ee:	89 e5                	mov    %esp,%ebp
 7f0:	83 ec 10             	sub    $0x10,%esp
  char *dst, *src;
  
  dst = vdst;
 7f3:	8b 45 08             	mov    0x8(%ebp),%eax
 7f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
  src = vsrc;
 7f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 7fc:	89 45 f8             	mov    %eax,-0x8(%ebp)
  while(n-- > 0)
 7ff:	eb 17                	jmp    818 <memmove+0x2b>
    *dst++ = *src++;
 801:	8b 55 f8             	mov    -0x8(%ebp),%edx
 804:	8d 42 01             	lea    0x1(%edx),%eax
 807:	89 45 f8             	mov    %eax,-0x8(%ebp)
 80a:	8b 45 fc             	mov    -0x4(%ebp),%eax
 80d:	8d 48 01             	lea    0x1(%eax),%ecx
 810:	89 4d fc             	mov    %ecx,-0x4(%ebp)
 813:	0f b6 12             	movzbl (%edx),%edx
 816:	88 10                	mov    %dl,(%eax)
  while(n-- > 0)
 818:	8b 45 10             	mov    0x10(%ebp),%eax
 81b:	8d 50 ff             	lea    -0x1(%eax),%edx
 81e:	89 55 10             	mov    %edx,0x10(%ebp)
 821:	85 c0                	test   %eax,%eax
 823:	7f dc                	jg     801 <memmove+0x14>
  return vdst;
 825:	8b 45 08             	mov    0x8(%ebp),%eax
}
 828:	c9                   	leave  
 829:	c3                   	ret    

0000082a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 82a:	b8 01 00 00 00       	mov    $0x1,%eax
 82f:	cd 40                	int    $0x40
 831:	c3                   	ret    

00000832 <exit>:
SYSCALL(exit)
 832:	b8 02 00 00 00       	mov    $0x2,%eax
 837:	cd 40                	int    $0x40
 839:	c3                   	ret    

0000083a <wait>:
SYSCALL(wait)
 83a:	b8 03 00 00 00       	mov    $0x3,%eax
 83f:	cd 40                	int    $0x40
 841:	c3                   	ret    

00000842 <pipe>:
SYSCALL(pipe)
 842:	b8 04 00 00 00       	mov    $0x4,%eax
 847:	cd 40                	int    $0x40
 849:	c3                   	ret    

0000084a <read>:
SYSCALL(read)
 84a:	b8 05 00 00 00       	mov    $0x5,%eax
 84f:	cd 40                	int    $0x40
 851:	c3                   	ret    

00000852 <write>:
SYSCALL(write)
 852:	b8 10 00 00 00       	mov    $0x10,%eax
 857:	cd 40                	int    $0x40
 859:	c3                   	ret    

0000085a <close>:
SYSCALL(close)
 85a:	b8 15 00 00 00       	mov    $0x15,%eax
 85f:	cd 40                	int    $0x40
 861:	c3                   	ret    

00000862 <kill>:
SYSCALL(kill)
 862:	b8 06 00 00 00       	mov    $0x6,%eax
 867:	cd 40                	int    $0x40
 869:	c3                   	ret    

0000086a <exec>:
SYSCALL(exec)
 86a:	b8 07 00 00 00       	mov    $0x7,%eax
 86f:	cd 40                	int    $0x40
 871:	c3                   	ret    

00000872 <open>:
SYSCALL(open)
 872:	b8 0f 00 00 00       	mov    $0xf,%eax
 877:	cd 40                	int    $0x40
 879:	c3                   	ret    

0000087a <mknod>:
SYSCALL(mknod)
 87a:	b8 11 00 00 00       	mov    $0x11,%eax
 87f:	cd 40                	int    $0x40
 881:	c3                   	ret    

00000882 <unlink>:
SYSCALL(unlink)
 882:	b8 12 00 00 00       	mov    $0x12,%eax
 887:	cd 40                	int    $0x40
 889:	c3                   	ret    

0000088a <fstat>:
SYSCALL(fstat)
 88a:	b8 08 00 00 00       	mov    $0x8,%eax
 88f:	cd 40                	int    $0x40
 891:	c3                   	ret    

00000892 <link>:
SYSCALL(link)
 892:	b8 13 00 00 00       	mov    $0x13,%eax
 897:	cd 40                	int    $0x40
 899:	c3                   	ret    

0000089a <mkdir>:
SYSCALL(mkdir)
 89a:	b8 14 00 00 00       	mov    $0x14,%eax
 89f:	cd 40                	int    $0x40
 8a1:	c3                   	ret    

000008a2 <chdir>:
SYSCALL(chdir)
 8a2:	b8 09 00 00 00       	mov    $0x9,%eax
 8a7:	cd 40                	int    $0x40
 8a9:	c3                   	ret    

000008aa <dup>:
SYSCALL(dup)
 8aa:	b8 0a 00 00 00       	mov    $0xa,%eax
 8af:	cd 40                	int    $0x40
 8b1:	c3                   	ret    

000008b2 <getpid>:
SYSCALL(getpid)
 8b2:	b8 0b 00 00 00       	mov    $0xb,%eax
 8b7:	cd 40                	int    $0x40
 8b9:	c3                   	ret    

000008ba <sbrk>:
SYSCALL(sbrk)
 8ba:	b8 0c 00 00 00       	mov    $0xc,%eax
 8bf:	cd 40                	int    $0x40
 8c1:	c3                   	ret    

000008c2 <sleep>:
SYSCALL(sleep)
 8c2:	b8 0d 00 00 00       	mov    $0xd,%eax
 8c7:	cd 40                	int    $0x40
 8c9:	c3                   	ret    

000008ca <uptime>:
SYSCALL(uptime)
 8ca:	b8 0e 00 00 00       	mov    $0xe,%eax
 8cf:	cd 40                	int    $0x40
 8d1:	c3                   	ret    

000008d2 <print_free_frame_cnt>:
SYSCALL(print_free_frame_cnt)  //CS 3320 project 2
 8d2:	b8 17 00 00 00       	mov    $0x17,%eax
 8d7:	cd 40                	int    $0x40
 8d9:	c3                   	ret    

000008da <set_page_allocator>:
SYSCALL(set_page_allocator) // CS 3320 project 2
 8da:	b8 18 00 00 00       	mov    $0x18,%eax
 8df:	cd 40                	int    $0x40
 8e1:	c3                   	ret    

000008e2 <shmget>:
SYSCALL(shmget) // CS 3320 project 2
 8e2:	b8 19 00 00 00       	mov    $0x19,%eax
 8e7:	cd 40                	int    $0x40
 8e9:	c3                   	ret    

000008ea <shmdel>:
SYSCALL(shmdel) // CS3320 project 2
 8ea:	b8 1a 00 00 00       	mov    $0x1a,%eax
 8ef:	cd 40                	int    $0x40
 8f1:	c3                   	ret    

000008f2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 8f2:	55                   	push   %ebp
 8f3:	89 e5                	mov    %esp,%ebp
 8f5:	83 ec 18             	sub    $0x18,%esp
 8f8:	8b 45 0c             	mov    0xc(%ebp),%eax
 8fb:	88 45 f4             	mov    %al,-0xc(%ebp)
  write(fd, &c, 1);
 8fe:	83 ec 04             	sub    $0x4,%esp
 901:	6a 01                	push   $0x1
 903:	8d 45 f4             	lea    -0xc(%ebp),%eax
 906:	50                   	push   %eax
 907:	ff 75 08             	push   0x8(%ebp)
 90a:	e8 43 ff ff ff       	call   852 <write>
 90f:	83 c4 10             	add    $0x10,%esp
}
 912:	90                   	nop
 913:	c9                   	leave  
 914:	c3                   	ret    

00000915 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 915:	55                   	push   %ebp
 916:	89 e5                	mov    %esp,%ebp
 918:	83 ec 28             	sub    $0x28,%esp
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 91b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  if(sgn && xx < 0){
 922:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 926:	74 17                	je     93f <printint+0x2a>
 928:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
 92c:	79 11                	jns    93f <printint+0x2a>
    neg = 1;
 92e:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
    x = -xx;
 935:	8b 45 0c             	mov    0xc(%ebp),%eax
 938:	f7 d8                	neg    %eax
 93a:	89 45 ec             	mov    %eax,-0x14(%ebp)
 93d:	eb 06                	jmp    945 <printint+0x30>
  } else {
    x = xx;
 93f:	8b 45 0c             	mov    0xc(%ebp),%eax
 942:	89 45 ec             	mov    %eax,-0x14(%ebp)
  }

  i = 0;
 945:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  do{
    buf[i++] = digits[x % base];
 94c:	8b 4d 10             	mov    0x10(%ebp),%ecx
 94f:	8b 45 ec             	mov    -0x14(%ebp),%eax
 952:	ba 00 00 00 00       	mov    $0x0,%edx
 957:	f7 f1                	div    %ecx
 959:	89 d1                	mov    %edx,%ecx
 95b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 95e:	8d 50 01             	lea    0x1(%eax),%edx
 961:	89 55 f4             	mov    %edx,-0xc(%ebp)
 964:	0f b6 91 b0 11 00 00 	movzbl 0x11b0(%ecx),%edx
 96b:	88 54 05 dc          	mov    %dl,-0x24(%ebp,%eax,1)
  }while((x /= base) != 0);
 96f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 972:	8b 45 ec             	mov    -0x14(%ebp),%eax
 975:	ba 00 00 00 00       	mov    $0x0,%edx
 97a:	f7 f1                	div    %ecx
 97c:	89 45 ec             	mov    %eax,-0x14(%ebp)
 97f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 983:	75 c7                	jne    94c <printint+0x37>
  if(neg)
 985:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 989:	74 2d                	je     9b8 <printint+0xa3>
    buf[i++] = '-';
 98b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 98e:	8d 50 01             	lea    0x1(%eax),%edx
 991:	89 55 f4             	mov    %edx,-0xc(%ebp)
 994:	c6 44 05 dc 2d       	movb   $0x2d,-0x24(%ebp,%eax,1)

  while(--i >= 0)
 999:	eb 1d                	jmp    9b8 <printint+0xa3>
    putc(fd, buf[i]);
 99b:	8d 55 dc             	lea    -0x24(%ebp),%edx
 99e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 9a1:	01 d0                	add    %edx,%eax
 9a3:	0f b6 00             	movzbl (%eax),%eax
 9a6:	0f be c0             	movsbl %al,%eax
 9a9:	83 ec 08             	sub    $0x8,%esp
 9ac:	50                   	push   %eax
 9ad:	ff 75 08             	push   0x8(%ebp)
 9b0:	e8 3d ff ff ff       	call   8f2 <putc>
 9b5:	83 c4 10             	add    $0x10,%esp
  while(--i >= 0)
 9b8:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
 9bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 9c0:	79 d9                	jns    99b <printint+0x86>
}
 9c2:	90                   	nop
 9c3:	90                   	nop
 9c4:	c9                   	leave  
 9c5:	c3                   	ret    

000009c6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 9c6:	55                   	push   %ebp
 9c7:	89 e5                	mov    %esp,%ebp
 9c9:	83 ec 28             	sub    $0x28,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 9cc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  ap = (uint*)(void*)&fmt + 1;
 9d3:	8d 45 0c             	lea    0xc(%ebp),%eax
 9d6:	83 c0 04             	add    $0x4,%eax
 9d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  for(i = 0; fmt[i]; i++){
 9dc:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
 9e3:	e9 59 01 00 00       	jmp    b41 <printf+0x17b>
    c = fmt[i] & 0xff;
 9e8:	8b 55 0c             	mov    0xc(%ebp),%edx
 9eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
 9ee:	01 d0                	add    %edx,%eax
 9f0:	0f b6 00             	movzbl (%eax),%eax
 9f3:	0f be c0             	movsbl %al,%eax
 9f6:	25 ff 00 00 00       	and    $0xff,%eax
 9fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(state == 0){
 9fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
 a02:	75 2c                	jne    a30 <printf+0x6a>
      if(c == '%'){
 a04:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 a08:	75 0c                	jne    a16 <printf+0x50>
        state = '%';
 a0a:	c7 45 ec 25 00 00 00 	movl   $0x25,-0x14(%ebp)
 a11:	e9 27 01 00 00       	jmp    b3d <printf+0x177>
      } else {
        putc(fd, c);
 a16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 a19:	0f be c0             	movsbl %al,%eax
 a1c:	83 ec 08             	sub    $0x8,%esp
 a1f:	50                   	push   %eax
 a20:	ff 75 08             	push   0x8(%ebp)
 a23:	e8 ca fe ff ff       	call   8f2 <putc>
 a28:	83 c4 10             	add    $0x10,%esp
 a2b:	e9 0d 01 00 00       	jmp    b3d <printf+0x177>
      }
    } else if(state == '%'){
 a30:	83 7d ec 25          	cmpl   $0x25,-0x14(%ebp)
 a34:	0f 85 03 01 00 00    	jne    b3d <printf+0x177>
      if(c == 'd'){
 a3a:	83 7d e4 64          	cmpl   $0x64,-0x1c(%ebp)
 a3e:	75 1e                	jne    a5e <printf+0x98>
        printint(fd, *ap, 10, 1);
 a40:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a43:	8b 00                	mov    (%eax),%eax
 a45:	6a 01                	push   $0x1
 a47:	6a 0a                	push   $0xa
 a49:	50                   	push   %eax
 a4a:	ff 75 08             	push   0x8(%ebp)
 a4d:	e8 c3 fe ff ff       	call   915 <printint>
 a52:	83 c4 10             	add    $0x10,%esp
        ap++;
 a55:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a59:	e9 d8 00 00 00       	jmp    b36 <printf+0x170>
      } else if(c == 'x' || c == 'p'){
 a5e:	83 7d e4 78          	cmpl   $0x78,-0x1c(%ebp)
 a62:	74 06                	je     a6a <printf+0xa4>
 a64:	83 7d e4 70          	cmpl   $0x70,-0x1c(%ebp)
 a68:	75 1e                	jne    a88 <printf+0xc2>
        printint(fd, *ap, 16, 0);
 a6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a6d:	8b 00                	mov    (%eax),%eax
 a6f:	6a 00                	push   $0x0
 a71:	6a 10                	push   $0x10
 a73:	50                   	push   %eax
 a74:	ff 75 08             	push   0x8(%ebp)
 a77:	e8 99 fe ff ff       	call   915 <printint>
 a7c:	83 c4 10             	add    $0x10,%esp
        ap++;
 a7f:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 a83:	e9 ae 00 00 00       	jmp    b36 <printf+0x170>
      } else if(c == 's'){
 a88:	83 7d e4 73          	cmpl   $0x73,-0x1c(%ebp)
 a8c:	75 43                	jne    ad1 <printf+0x10b>
        s = (char*)*ap;
 a8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
 a91:	8b 00                	mov    (%eax),%eax
 a93:	89 45 f4             	mov    %eax,-0xc(%ebp)
        ap++;
 a96:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
        if(s == 0)
 a9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 a9e:	75 25                	jne    ac5 <printf+0xff>
          s = "(null)";
 aa0:	c7 45 f4 e8 0e 00 00 	movl   $0xee8,-0xc(%ebp)
        while(*s != 0){
 aa7:	eb 1c                	jmp    ac5 <printf+0xff>
          putc(fd, *s);
 aa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
 aac:	0f b6 00             	movzbl (%eax),%eax
 aaf:	0f be c0             	movsbl %al,%eax
 ab2:	83 ec 08             	sub    $0x8,%esp
 ab5:	50                   	push   %eax
 ab6:	ff 75 08             	push   0x8(%ebp)
 ab9:	e8 34 fe ff ff       	call   8f2 <putc>
 abe:	83 c4 10             	add    $0x10,%esp
          s++;
 ac1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while(*s != 0){
 ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ac8:	0f b6 00             	movzbl (%eax),%eax
 acb:	84 c0                	test   %al,%al
 acd:	75 da                	jne    aa9 <printf+0xe3>
 acf:	eb 65                	jmp    b36 <printf+0x170>
        }
      } else if(c == 'c'){
 ad1:	83 7d e4 63          	cmpl   $0x63,-0x1c(%ebp)
 ad5:	75 1d                	jne    af4 <printf+0x12e>
        putc(fd, *ap);
 ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
 ada:	8b 00                	mov    (%eax),%eax
 adc:	0f be c0             	movsbl %al,%eax
 adf:	83 ec 08             	sub    $0x8,%esp
 ae2:	50                   	push   %eax
 ae3:	ff 75 08             	push   0x8(%ebp)
 ae6:	e8 07 fe ff ff       	call   8f2 <putc>
 aeb:	83 c4 10             	add    $0x10,%esp
        ap++;
 aee:	83 45 e8 04          	addl   $0x4,-0x18(%ebp)
 af2:	eb 42                	jmp    b36 <printf+0x170>
      } else if(c == '%'){
 af4:	83 7d e4 25          	cmpl   $0x25,-0x1c(%ebp)
 af8:	75 17                	jne    b11 <printf+0x14b>
        putc(fd, c);
 afa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 afd:	0f be c0             	movsbl %al,%eax
 b00:	83 ec 08             	sub    $0x8,%esp
 b03:	50                   	push   %eax
 b04:	ff 75 08             	push   0x8(%ebp)
 b07:	e8 e6 fd ff ff       	call   8f2 <putc>
 b0c:	83 c4 10             	add    $0x10,%esp
 b0f:	eb 25                	jmp    b36 <printf+0x170>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 b11:	83 ec 08             	sub    $0x8,%esp
 b14:	6a 25                	push   $0x25
 b16:	ff 75 08             	push   0x8(%ebp)
 b19:	e8 d4 fd ff ff       	call   8f2 <putc>
 b1e:	83 c4 10             	add    $0x10,%esp
        putc(fd, c);
 b21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 b24:	0f be c0             	movsbl %al,%eax
 b27:	83 ec 08             	sub    $0x8,%esp
 b2a:	50                   	push   %eax
 b2b:	ff 75 08             	push   0x8(%ebp)
 b2e:	e8 bf fd ff ff       	call   8f2 <putc>
 b33:	83 c4 10             	add    $0x10,%esp
      }
      state = 0;
 b36:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  for(i = 0; fmt[i]; i++){
 b3d:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
 b41:	8b 55 0c             	mov    0xc(%ebp),%edx
 b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
 b47:	01 d0                	add    %edx,%eax
 b49:	0f b6 00             	movzbl (%eax),%eax
 b4c:	84 c0                	test   %al,%al
 b4e:	0f 85 94 fe ff ff    	jne    9e8 <printf+0x22>
    }
  }
}
 b54:	90                   	nop
 b55:	90                   	nop
 b56:	c9                   	leave  
 b57:	c3                   	ret    

00000b58 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 b58:	55                   	push   %ebp
 b59:	89 e5                	mov    %esp,%ebp
 b5b:	83 ec 10             	sub    $0x10,%esp
  Header *bp, *p;

  bp = (Header*)ap - 1;
 b5e:	8b 45 08             	mov    0x8(%ebp),%eax
 b61:	83 e8 08             	sub    $0x8,%eax
 b64:	89 45 f8             	mov    %eax,-0x8(%ebp)
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b67:	a1 cc 11 00 00       	mov    0x11cc,%eax
 b6c:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b6f:	eb 24                	jmp    b95 <free+0x3d>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b71:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b74:	8b 00                	mov    (%eax),%eax
 b76:	39 45 fc             	cmp    %eax,-0x4(%ebp)
 b79:	72 12                	jb     b8d <free+0x35>
 b7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b7e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b81:	77 24                	ja     ba7 <free+0x4f>
 b83:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b86:	8b 00                	mov    (%eax),%eax
 b88:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 b8b:	72 1a                	jb     ba7 <free+0x4f>
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 b90:	8b 00                	mov    (%eax),%eax
 b92:	89 45 fc             	mov    %eax,-0x4(%ebp)
 b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
 b98:	3b 45 fc             	cmp    -0x4(%ebp),%eax
 b9b:	76 d4                	jbe    b71 <free+0x19>
 b9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
 ba0:	8b 00                	mov    (%eax),%eax
 ba2:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 ba5:	73 ca                	jae    b71 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 ba7:	8b 45 f8             	mov    -0x8(%ebp),%eax
 baa:	8b 40 04             	mov    0x4(%eax),%eax
 bad:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bb4:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bb7:	01 c2                	add    %eax,%edx
 bb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bbc:	8b 00                	mov    (%eax),%eax
 bbe:	39 c2                	cmp    %eax,%edx
 bc0:	75 24                	jne    be6 <free+0x8e>
    bp->s.size += p->s.ptr->s.size;
 bc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bc5:	8b 50 04             	mov    0x4(%eax),%edx
 bc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bcb:	8b 00                	mov    (%eax),%eax
 bcd:	8b 40 04             	mov    0x4(%eax),%eax
 bd0:	01 c2                	add    %eax,%edx
 bd2:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bd5:	89 50 04             	mov    %edx,0x4(%eax)
    bp->s.ptr = p->s.ptr->s.ptr;
 bd8:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bdb:	8b 00                	mov    (%eax),%eax
 bdd:	8b 10                	mov    (%eax),%edx
 bdf:	8b 45 f8             	mov    -0x8(%ebp),%eax
 be2:	89 10                	mov    %edx,(%eax)
 be4:	eb 0a                	jmp    bf0 <free+0x98>
  } else
    bp->s.ptr = p->s.ptr;
 be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
 be9:	8b 10                	mov    (%eax),%edx
 beb:	8b 45 f8             	mov    -0x8(%ebp),%eax
 bee:	89 10                	mov    %edx,(%eax)
  if(p + p->s.size == bp){
 bf0:	8b 45 fc             	mov    -0x4(%ebp),%eax
 bf3:	8b 40 04             	mov    0x4(%eax),%eax
 bf6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
 bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c00:	01 d0                	add    %edx,%eax
 c02:	39 45 f8             	cmp    %eax,-0x8(%ebp)
 c05:	75 20                	jne    c27 <free+0xcf>
    p->s.size += bp->s.size;
 c07:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c0a:	8b 50 04             	mov    0x4(%eax),%edx
 c0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c10:	8b 40 04             	mov    0x4(%eax),%eax
 c13:	01 c2                	add    %eax,%edx
 c15:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c18:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 c1b:	8b 45 f8             	mov    -0x8(%ebp),%eax
 c1e:	8b 10                	mov    (%eax),%edx
 c20:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c23:	89 10                	mov    %edx,(%eax)
 c25:	eb 08                	jmp    c2f <free+0xd7>
  } else
    p->s.ptr = bp;
 c27:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c2a:	8b 55 f8             	mov    -0x8(%ebp),%edx
 c2d:	89 10                	mov    %edx,(%eax)
  freep = p;
 c2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
 c32:	a3 cc 11 00 00       	mov    %eax,0x11cc
}
 c37:	90                   	nop
 c38:	c9                   	leave  
 c39:	c3                   	ret    

00000c3a <morecore>:

static Header*
morecore(uint nu)
{
 c3a:	55                   	push   %ebp
 c3b:	89 e5                	mov    %esp,%ebp
 c3d:	83 ec 18             	sub    $0x18,%esp
  char *p;
  Header *hp;

  if(nu < 4096)
 c40:	81 7d 08 ff 0f 00 00 	cmpl   $0xfff,0x8(%ebp)
 c47:	77 07                	ja     c50 <morecore+0x16>
    nu = 4096;
 c49:	c7 45 08 00 10 00 00 	movl   $0x1000,0x8(%ebp)
  p = sbrk(nu * sizeof(Header));
 c50:	8b 45 08             	mov    0x8(%ebp),%eax
 c53:	c1 e0 03             	shl    $0x3,%eax
 c56:	83 ec 0c             	sub    $0xc,%esp
 c59:	50                   	push   %eax
 c5a:	e8 5b fc ff ff       	call   8ba <sbrk>
 c5f:	83 c4 10             	add    $0x10,%esp
 c62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(p == (char*)-1)
 c65:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
 c69:	75 07                	jne    c72 <morecore+0x38>
    return 0;
 c6b:	b8 00 00 00 00       	mov    $0x0,%eax
 c70:	eb 26                	jmp    c98 <morecore+0x5e>
  hp = (Header*)p;
 c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
 c75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  hp->s.size = nu;
 c78:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c7b:	8b 55 08             	mov    0x8(%ebp),%edx
 c7e:	89 50 04             	mov    %edx,0x4(%eax)
  free((void*)(hp + 1));
 c81:	8b 45 f0             	mov    -0x10(%ebp),%eax
 c84:	83 c0 08             	add    $0x8,%eax
 c87:	83 ec 0c             	sub    $0xc,%esp
 c8a:	50                   	push   %eax
 c8b:	e8 c8 fe ff ff       	call   b58 <free>
 c90:	83 c4 10             	add    $0x10,%esp
  return freep;
 c93:	a1 cc 11 00 00       	mov    0x11cc,%eax
}
 c98:	c9                   	leave  
 c99:	c3                   	ret    

00000c9a <malloc>:

void*
malloc(uint nbytes)
{
 c9a:	55                   	push   %ebp
 c9b:	89 e5                	mov    %esp,%ebp
 c9d:	83 ec 18             	sub    $0x18,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ca0:	8b 45 08             	mov    0x8(%ebp),%eax
 ca3:	83 c0 07             	add    $0x7,%eax
 ca6:	c1 e8 03             	shr    $0x3,%eax
 ca9:	83 c0 01             	add    $0x1,%eax
 cac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  if((prevp = freep) == 0){
 caf:	a1 cc 11 00 00       	mov    0x11cc,%eax
 cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
 cb7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
 cbb:	75 23                	jne    ce0 <malloc+0x46>
    base.s.ptr = freep = prevp = &base;
 cbd:	c7 45 f0 c4 11 00 00 	movl   $0x11c4,-0x10(%ebp)
 cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
 cc7:	a3 cc 11 00 00       	mov    %eax,0x11cc
 ccc:	a1 cc 11 00 00       	mov    0x11cc,%eax
 cd1:	a3 c4 11 00 00       	mov    %eax,0x11c4
    base.s.size = 0;
 cd6:	c7 05 c8 11 00 00 00 	movl   $0x0,0x11c8
 cdd:	00 00 00 
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ce0:	8b 45 f0             	mov    -0x10(%ebp),%eax
 ce3:	8b 00                	mov    (%eax),%eax
 ce5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 ce8:	8b 45 f4             	mov    -0xc(%ebp),%eax
 ceb:	8b 40 04             	mov    0x4(%eax),%eax
 cee:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 cf1:	77 4d                	ja     d40 <malloc+0xa6>
      if(p->s.size == nunits)
 cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
 cf6:	8b 40 04             	mov    0x4(%eax),%eax
 cf9:	39 45 ec             	cmp    %eax,-0x14(%ebp)
 cfc:	75 0c                	jne    d0a <malloc+0x70>
        prevp->s.ptr = p->s.ptr;
 cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d01:	8b 10                	mov    (%eax),%edx
 d03:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d06:	89 10                	mov    %edx,(%eax)
 d08:	eb 26                	jmp    d30 <malloc+0x96>
      else {
        p->s.size -= nunits;
 d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d0d:	8b 40 04             	mov    0x4(%eax),%eax
 d10:	2b 45 ec             	sub    -0x14(%ebp),%eax
 d13:	89 c2                	mov    %eax,%edx
 d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d18:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 d1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d1e:	8b 40 04             	mov    0x4(%eax),%eax
 d21:	c1 e0 03             	shl    $0x3,%eax
 d24:	01 45 f4             	add    %eax,-0xc(%ebp)
        p->s.size = nunits;
 d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d2a:	8b 55 ec             	mov    -0x14(%ebp),%edx
 d2d:	89 50 04             	mov    %edx,0x4(%eax)
      }
      freep = prevp;
 d30:	8b 45 f0             	mov    -0x10(%ebp),%eax
 d33:	a3 cc 11 00 00       	mov    %eax,0x11cc
      return (void*)(p + 1);
 d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d3b:	83 c0 08             	add    $0x8,%eax
 d3e:	eb 3b                	jmp    d7b <malloc+0xe1>
    }
    if(p == freep)
 d40:	a1 cc 11 00 00       	mov    0x11cc,%eax
 d45:	39 45 f4             	cmp    %eax,-0xc(%ebp)
 d48:	75 1e                	jne    d68 <malloc+0xce>
      if((p = morecore(nunits)) == 0)
 d4a:	83 ec 0c             	sub    $0xc,%esp
 d4d:	ff 75 ec             	push   -0x14(%ebp)
 d50:	e8 e5 fe ff ff       	call   c3a <morecore>
 d55:	83 c4 10             	add    $0x10,%esp
 d58:	89 45 f4             	mov    %eax,-0xc(%ebp)
 d5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
 d5f:	75 07                	jne    d68 <malloc+0xce>
        return 0;
 d61:	b8 00 00 00 00       	mov    $0x0,%eax
 d66:	eb 13                	jmp    d7b <malloc+0xe1>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
 d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
 d71:	8b 00                	mov    (%eax),%eax
 d73:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(p->s.size >= nunits){
 d76:	e9 6d ff ff ff       	jmp    ce8 <malloc+0x4e>
  }
}
 d7b:	c9                   	leave  
 d7c:	c3                   	ret    
