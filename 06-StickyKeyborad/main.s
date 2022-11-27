@ Program 6:  06-sticky-keyboard
@ https://www.armasm.com/docs/branches-and-conditionals/sticky-keyboard/
@
@ My keyboard sucks. Thanks Apple. The keys stick badly. (They don't really)
@ Write a program that takes a string and removes the duplicate letters. 
@
@   r0: input string address
@   r1: output string address
@   r2: tmp byte read
@   r3: last value we read

.include "write.s" 

.global _start 

_start:
    ldr     r0, =instr
    ldr     r1, =outstr
    mov     r3, #0              @ init r3

loop:
    ldrb    r2, [r0], #1        @ we load the value in r0 to r2 and 
                                @ stored the increased address in r0
    cmp     r2, #0              @ check if r2 has reach the null letter
    beq     exit
    cmp     r2, r3              @ to see if equal the last vlaue 
    beq     loop                @ if r2 equals to r3, move to next byte
    mov     r3, r2              @ update r3
    strb    r2, [r1], #1        @ store the letter into output string
    b       loop                @ keep processing

exit:
    nullwrite       outstr

    @ setup syscall exit
    mov     r7, #1
    mov     r0, #0
    svc     0

.data 
instr:      .ascii      "I jjjjust   waaaaant thhhis stuppppid " 
            .asciz      "tttthinggggg tooooo wwwwworrrrrrrk!!!!!!!\n"
outstr:     .fill       128, 1, 0     @ Reserve 128 bytes
