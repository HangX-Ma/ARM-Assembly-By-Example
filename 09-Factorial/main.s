@ Program 9: Factorials
@
@ The two “standard” recursion formulas used in programming are the Fibonacci 
@ series and factorials. Write a program that calculates 9! and prints the 
@ number to stdout.
@
@   Registers:     
@       r0: total 
@       r1: current number 
@       r12 - frame base pointer 

@ Factorial beginning number 
.equ    maxnum, 9

.global _start 

_start:
    mov     r0, #maxnum     @ load initial maxnum into r0
    mov     r12, sp         @ set stack base to current stack pointer
    push    {r0}            @ push param0 into stack, stack address -4
    bl      factorial       @ first factorial callee

    @ itoa
    mov     r0, r0          @ move total to r0 (noop)
    ldr     r1, =outstr     @ get outstr address
    bl      itoa            @ jump to itoa

    @ write number
    mov     r7, #4          @ 4 = write
    mov     r0, #1          @ 1 = stdout
    mov     r1, r1          @ no op but here for clarity
    mov     r2, #11         @ length
    svc     0

    @ exit
    mov     r7, #1          @ 1 = exit
    mov     r0, #0          @ no error
    svc     0

@   Factorial sub routine 
@ 
@   registers:
@       r0: input number, running total 
@       r1: copy of input for return  
@   returns: 
@       r0: total 
factorial: 
    @ After we use `bl` to call this function, the returned
    @ address in current PC will be copied into the R14(LR).
    push    {lr}            @ save address to return to
    push    {r12}           @ save address of base point

    @ move base point to sp to start a new base frame
    mov     r12, sp         @ set base to stack pointer
    ldr     r0, [r12, #8]   @ push {lr} and push {r12} decrease the address
                            @ 8 bytes, so the param0's address is 8 bytes
                            @ larger than current base. We load param0 into r0
    @ check x == 1 ?
    cmp     r0, #1          @ see if we have reached 1
    beq     fexit
    @ else x * factorial(x - 1)
    push    {r0}            @ save x: [bp - 4]
    sub     r0, #1          @ subtract 1 for next fac call
    push    {r0}            @ save x - 1: [bp - 8]
    bl      factorial
    @ callee returned here
    ldr     r1, [r12, #-4]  @ get x from stack
    mul     r0, r1, r0      @ first return, r0 is 1
    b       fexit
fexit:
    mov     sp, r12         @ recover base point, so we don't need to care about 
                            @ how much data we have pushed, we only deal with the
                            @ relavant address relationship.

    pop     {r12}           @ pop out old base point
    pop     {lr}            @ pop out address to return to
    bx      lr              @ return to callee
.data
outstr:     .fill   11      @ 11 needed for str
