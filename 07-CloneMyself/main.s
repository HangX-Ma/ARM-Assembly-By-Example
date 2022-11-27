@ Program 7: Cloning Myself
@
@ Having lived through quarantine, I have decided that I would like the last year 
@ or so of my life back. In order to do this, I am going to clone myself and then 
@ transfer my brain into a new body. However, since replication errors are a thing, 
@ write a program that will show the expected pairs so I can double check.
@ 
@ In DNA strings, symbols “A” and “T” are complements of each other, as “C” and “G”.
@
@   Registers:
@       r0: input address
@       r1: search register
@       r2: tmp read byte

.include "write.s" 

.global _start 

_start: 
    ldr     r0, =instr      @ load string address
loop:
    ldrb    r1, [r0]        @ load first char
    cmp     r1, #0          @ check if we get a null char
    beq     exit            @ null char means copying has been completed
    cmp     r1, #'A'
    moveq   r2, #'T'
    beq     write           @ CPSR only update when command with -s suffix and cmp
    cmp     r1, #'T'
    moveq   r2, #'A'
    beq     write
    cmp     r1, #'C'
    moveq   r2, #'G'
    beq     write
    mov     r2, #'C'        @ if no other instr and increament
write:
    strb    r2, [r0], #1    @ store the value to where the instr located 
                            @ and increase address to next
    b       loop
exit:
    nullwrite       instr   @ write with nullwrite macro 

    ldr     r0, =instr
    mov     r1, #0x000a     @ store a new line + \0 into r1 register
                            @ arm is default in little endian
    strh    r1, [r0]        @ store to memory 
    
    nullwrite       instr


    @ setup syscall exit
    mov     r7, #1
    mov     r0, #0
    svc     0


.data 
instr:      .ascii      "GTATCGATCGATCGATCGATTATATTTTCGACGAGATTTAAATATATATA"
            .asciz      "TATACGAGAGAATACAGATAGACAGATTA"
