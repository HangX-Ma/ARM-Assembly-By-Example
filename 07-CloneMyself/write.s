@@@@@@
@   Outputs a null terminated string to stdout
@
@   r0  -   output str address
@   r1  -   search address
@   r2  -   tmp search bit 
@   r3  -   str length 
@
@   labels: 
@       1: Length loop 
@       2: Output syscall 
@@@@@@

.macro      nullwrite       outstr
    
    ldr     r0, =\outstr    @ load address of outstr
    mov     r1, r0          @ copy address for len calc later 
1:
    ldrb    r2, [r1]        @ load first char
    cmp     r2, #0          @ compare content in r2 with null
    beq     2f              @ brach forward to label 2
    add     r1, #1          @ increase address to access next char
    b       1b              @ branch backward to label 1
2:
    sub     r3, r1, r0      @ store r1 - r0 result in r3, this is data length

    @ Setup syscall write
    mov     r7, #4          @ 4 = write
    mov     r0, #1          @ 1 = stdout
    ldr     r1, =\outstr    @ get start address
    mov     r2, r3          @ data length
    svc     0

.endm
