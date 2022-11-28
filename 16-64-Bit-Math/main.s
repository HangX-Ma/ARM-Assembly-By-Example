@ Program 16: 64-bit Math
@ https://www.armasm.com/docs/bit-operations/64-bit-math/
@
@ Multiply two 32-bit numbers. Take the result and write an integer to ASCII 
@ program that reads 64 bit numbers using this shift/long division method.

@   Reigisters:
@       r4: 64-low
@       r5: 64-high
@       r6: working number
@       r7: number to write 
@       r8: output memory
@       r9: inner loop counter
@       r10: digit counter


.global _start 

_start: 
    ldr     r0, =0xbf85be21     @ pseudo instruction load 1
    ldr     r1, =0xce0a6a80     @ pseudo instruction load 2
    umull   r4, r5, r0, r1      @ multipy r0 and r1, 64-low in r4, 64-high in r5

    ldr     r8, =output         @ load output address
    add     r8, #20             @ take the address and add the length -1 as 
                                @ it's zero indexed 

    mov     r7, #'\n'           @ load line ending
    strb    r7, [r8], #-1       @ store line ending and decrement 

    mov     r10, #0             @ init r10

outer:
    add     r10, #1             @ add one to counter
    cmp     r10, #20            @ maximum digital number
    bgt     write
    mov     r6, #0              @ init r6
    mov     r9, #0              @ init r9

loop:
    add     r9, #1              @ add one to counter
    cmp     r9, #64             @ maximum bit number
    bgt     store               @ store number if we reach the end 
    lsl     r6, #1              @ shift working number
    lsls    r5, #1              @ shift top half of number
    adc     r6, #0              @ add 0 + carry to working number
    lsls    r4, #1              @ shift bottom half of number
    adc     r5, #0              @ add 0 + carry to top half 
    cmp     r6, #10             @ this will always be two ops. either subs and 
                                @ store result and mov or cmp and sub. 
    blt     loop                @ if working < 10, go to next loop
    sub     r6, r6, #10             @ substract 10
    add     r4, #1              @ add 1 to bottom to set up for next loop 
    b       loop

store:
    add     r7, r6, #'0'        @ ASCII convertion
    strb    r7, [r8], #-1       @ store and increment output address 
    b        outer              @ go back to outer loop 

write:
    @ setup write syscall
    mov     r7, #4              @ 4 = write
    mov     r0, #1              @ 1 = stdout
    ldr     r1, =output         @ output memory data address
    mov     r2, #21             @ length
    svc     0

exit:
    mov     r7, #1              @ 1 = exit
    mov     r0, #1              @ 0 = no error
    svc     0

.data
output:     .fill       21      @ max 64-bit unsigned is 20 digits long + 1 for \n

