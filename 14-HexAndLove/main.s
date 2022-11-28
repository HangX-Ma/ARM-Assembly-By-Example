@ Program 14: Hex and Love
@ https://www.armasm.com/docs/bit-operations/hex-and-love/
@
@ I have a bunch of colors saved from my web programing and I would like to 
@ take those rgb values and convert them to #rrggbb values. Write a program 
@ that takes sets of three rgb values and converts them into the #rrggbb hex 
@ representation.
@ 
@ Note: The red color will never be 0.
@
@   Registers:
@       r4: input address 
@       r5: output address
@       r6: hexstr
@       r7: reserved for syscalls 
@       r8: current input byte 
@       r9: byte half 
@       r10: hexletter 
@       r11: inner loop counter 

.global _start 

_start: 
    ldr     r4, =input          @ load input string address
    ldr     r6, =hexstr         @ load hexstr address
    ldrb    r8, [r4], #1        @ load first byte

loop:
    cmp     r8, #0              @ check if r8 is null
    beq     exit                @ all bytes have been converted to hex base
    ldr     r5, =outstr         @ load outstr address
    mov     r11, #0             @ reset inner loop counter 

inner_loop:
                                @   The order looks backwards because of the endiness 
                                @   The first hex should be D4E4BC 
                                @   In memory, it should be backwards: D4E4BC
                                @   So when we take the number and convert it to ASCII, 
                                @   The higher half needs to be written first 
    cmp     r11, #3             @ 3 byte a group
    bge     write
    @ process higher half byte
    and     r9, r8, #0xF0       @ load the higher half byte in r9
    lsr     r9, r9, #4          @ move to least significant bits
    ldrb    r10, [r6, r9]       @ load hexstr + offset to get letter
    strb    r10, [r5], #1       @ store hex letter into at specific output address
    @ process lower half byte
    and     r9, r8, #0x0F       @ load the lower half byte in r9
    ldrb    r10, [r6, r9]       @ load hexstr + offset to get letter
    strb    r10, [r5], #1       @ store hex letter into at specific output address
    ldrb    r8, [r4], #1        @ load next byte to convert
    add     r11, #1             @ increment counter 
    b       inner_loop
write:
    mov     r10, #'\n'          @ get a new line
    strb    r10, [r5]

    @ setup write syscall
    mov     r7, #4              @ 4 = write
    mov     r0, #1              @ 1 = stdout
    ldr     r1, =outstr         @ output address
    mov     r2, #7              @ 7 = length (6 hex + line ending) 
    svc     0

    b       loop

exit: 
    @ setup exit 
    mov     r7, #1          @ 1 = exit 
    mov     r0, #0          @ 0 = no error 
    svc     0

.data
hexstr:     .ascii      "0123456789ABCDEF"

input:      .byte       212, 228, 188
            .byte       150, 172, 183
            .byte       54, 85, 143
            .byte       64, 55, 110
            .byte       72, 35, 60
            .byte       0   

outstr:     .fill       7, 1, 0
