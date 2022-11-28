@       converts an unsigned ASCII number to int
@
@       preserves r4 
@
@       Input
@           r0: address of null terminated input str 
@       Used
@           r4: total
@           r5: 10 constant for mul
@           r6: current num 
@           r7: current address
@       Output
@           r0: total 
@

.global atoi

atoi:
    push    {r4-r7}         @ push registers that we use 
    mov     r4, #0          @ init r4
    mov     r5, #10         @ init r5 as a base number
    mov     r7, r0          @ copy address into r7

loop:
    ldrb    r6, [r7], #1    @ load byte and increase address
    cmp     r6, #0          @ check if we have accessed a null char
    beq     exit
    mul     r4, r5, r4      @ multiply 10 for next digit (because of litte endian)
    sub     r6, r6, #'0'    @ subtract the value of ASCII zero to char 
    add     r4, r4, r6      @ add to total
    b       loop
exit:
    mov     r0, r4          @ load result into r0
    pop     {r4-r7}         @ recover registers values
    bx      lr              @ return to callee
