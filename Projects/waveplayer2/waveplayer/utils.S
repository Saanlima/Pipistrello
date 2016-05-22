
	.text
	.globl	enable_interrupts
	.ent	enable_interrupts
	.align	2
enable_interrupts:	
	#Make space on stack for a temporary
	addi	r1, r1, -4
	#Save register r12
	swi	r12, r1, 0
	#Read the MSR register
	mfs	r12, rmsr
	#Set the interrupt enable bit
	ori	r12, r12, 2
	#Save the MSR register
	mts	rmsr, r12
	#Load register r12
	lwi	r12, r1, 0
	#Return
	rtsd	r15, 8
	#Update stack in the delay slot
	addi	r1, r1, 4
	.end	enable_interrupts


	.text
	.globl	disable_interrupts
	.ent	disable_interrupts
	.align	2
disable_interrupts:	
	#Make space on stack for a temporary
	addi	r1, r1, -4
	#Save register r12
	swi	r12, r1, 0
	#Read the MSR register
	mfs	r12, rmsr
	#Clear the interrupt enable bit
	andi	r12, r12, ~2
	#Save the MSR register
	mts	rmsr, r12
	#Load register r12
	lwi	r12, r1, 0
	#Return
	rtsd	r15, 8
	#Update stack in the delay slot
	addi	r1, r1, 4
	.end	disable_interrupts


  .text
  .globl  enable_dcache
  .ent  enable_dcache
  .align  2
enable_dcache:  
  #Make space on stack for a temporary
  addi  r1, r1, -4
  #Read the MSR register
  mfs  r8, rmsr
  #Set the interrupt enable bit
  ori  r8, r8, 128
  #Save the MSR register
  mts  rmsr, r8
  #Return
  rtsd  r15, 8
  #Update stack in the delay slot
  addi  r1, r1, 4
  .end  enable_dcache

  
  .text
  .globl  enable_icache
  .ent  enable_icache
  .align  2
enable_icache:  
  #Make space on stack for a temporary
  addi  r1, r1, -4
  #Read the MSR register
  mfs  r8, rmsr
  #Set the interrupt enable bit
  ori  r8, r8, 32
  #Save the MSR register
  mts  rmsr, r8
  #Return
  rtsd  r15, 8
  #Update stack in the delay slot
  addi  r1, r1, 4
  .end  enable_icache

  
#define DCACHE_LINE_LEN  4
#define DCACHE_BYTE_SIZE 65536
    
  .text
  .globl  flush_dcache
  .ent  flush_dcache
  .align  2
flush_dcache:
  andi    r5, r5, -(4 * DCACHE_LINE_LEN)  /* Align to cache line */
  addik  r6, r5, DCACHE_BYTE_SIZE         /* Compute end */
  andi    r6, r6, -(4 * DCACHE_LINE_LEN)  /* Align to cache line */
L_start:
  wdc.flush r5, r0                        /* Flush the Cache */
  cmpu  r18, r5, r6                       /* Are we at the end? */
  blei  r18, L_done                                     
  brid  L_start                           /* Branch to the beginning of the loop */
  addik  r5, r5, (DCACHE_LINE_LEN * 4)    /* Increment the addrees by 4 (delay slot) */
L_done:  
  rtsd  r15, 8                            /* Return */
  nop
  .end  flush_dcache

  
  