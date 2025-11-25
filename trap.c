#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "traps.h"
#include "spinlock.h"

struct gatedesc idt[256];
extern uint vectors[];  // in vectors.S
extern int page_allocator_type;  // 0 = DEFAULT, 1 = LAZY

struct spinlock tickslock;
uint ticks;

void
tvinit(void){
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);

  // System call gate
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
}

void
idtinit(void)
{
  lidt(idt, sizeof(idt));}


void
trap(struct trapframe *tf)
{
  // =============== SYSCALL HANDLING ===============
  if(tf->trapno == T_SYSCALL){
    if(myproc() && myproc()->killed)
      exit();
    if(myproc())
      myproc()->tf = tf;
    syscall();
    if(myproc() && myproc()->killed)
      exit();
    return;
  }

  // =============== LAZY PAGE FAULT HANDLING ===============
   if (page_allocator_type == 1 && tf->trapno == T_PGFLT) {
    uint addr = rcr2();         // faulting virtual address
    struct proc *p = myproc();

    // Kernel-mode page fault? That's a real bug → panic.
    if ((tf->cs & 3) != DPL_USER || p == 0) {
      panic("kernel page fault");
    }

    // Page-aligned address
    uint a = PGROUNDDOWN(addr);

    // If the page is above the program break or above KERNBASE,
    // it's not a lazily-allocatable region → kill the process.
    if (a >= p->sz || a >= KERNBASE) {
      cprintf("Unhandled page fault for va:0x%x!\n", addr);
      p->killed = 1;
      // don't return yet; we let the bottom-of-trap kill it cleanly
      goto trap_done;
    }

    // Valid lazy fault → allocate & map a zeroed page
    char *mem = kalloc();
    if (mem == 0) {
      cprintf("Lazy alloc OOM at va:0x%x\n", addr);
      p->killed = 1;
      goto trap_done;
    }

    memset(mem, 0, PGSIZE);

    if (mappages(p->pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W | PTE_U) < 0) {
      cprintf("mappages failed for va:0x%x\n", addr);
      kfree(mem);
      p->killed = 1;
      goto trap_done;
    }

    // Lazy page fault fully handled → just return to user space.
    return;
  }
  // =============== HARDWARE INTERRUPTS ===============
  switch(tf->trapno){

  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
    break;

  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
    break;

  case T_IRQ0 + IRQ_IDE+1:
    break;

  case T_IRQ0 + IRQ_KBD:
    kbdintr();
    lapiceoi();
    break;

  case T_IRQ0 + IRQ_COM1:
    uartintr();
    lapiceoi();
    break;

  case T_IRQ0 + IRQ_SPURIOUS:
  case T_IRQ0 + 7:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
    break;

  default:
    if(myproc() == 0 || (tf->cs & 3) == 0){
      // kernel mode unexpected trap
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }

    // user mode fault → kill the process
    cprintf("pid %d %s: trap %d err %d on cpu %d eip 0x%x addr 0x%x -- kill\n",
            myproc()->pid, myproc()->name,
            tf->trapno, tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
  }

  trap_done:
  // ========== same bottom-of-trap logic as original xv6 ==========

  // Force process exit if it has been killed and is in user space.
  if(myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();

  // Force process to give up CPU on clock tick.
  if(myproc() && myproc()->state == RUNNING &&
     tf->trapno == T_IRQ0 + IRQ_TIMER)
    yield();

  // Check again if killed after yielding.
  if(myproc() && myproc()->killed && (tf->cs & 3) == DPL_USER)
    exit();
}
