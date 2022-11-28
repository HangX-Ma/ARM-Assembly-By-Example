@ Program 17: Add the Arguments
@ https://www.armasm.com/docs/working-in-linux/add-the-arguments/
@
@ The next couple of exercises are all going to be doing the same thing. 
@ Reading inputs, adding them together, and then outputting the result. 
@ For this, you will first need to create an ASCII to integer function. 
@ (Unsigned integer is fine) Create this in an outside file so you can reuse it.
@
@ Registers
@   r4: total 
.global _start

_start:
    add     sp, #8          @ After initialization, sp points to base+0x0000.
                            @ Agruments's address start at base+0x0008
    mov     r4, #0          @ init r4
    
loop:
    @ setup atoi 
    pop     {r0}            @ load content into r0 from stack
    cmp     r0, #0          @ check if it is a null char
    beq     exit
    bl      atoi            @ call atoi
    add     r4, r4, r0      @ collect result in r0
    b       loop 
exit:
    @ setup itoa
    mov     r0, r4          @ copy r4 to r0
    ldr     r1, =output     @ load output address to r1 
    bl      itoa            @ call itoa

    @ write output 
    mov     r7, #4          @ 4 = write 
    mov     r0, #1          @ 1 = stdout 
    ldr     r1, =output     @ load output address 
    mov     r2, #11         @ 11 = length 
    svc     0 

    @ setup exit 
    mov     r7, #1          @ 1 = exit 
    mov     r0, #0          @ 0 = no error
    svc     0

.data
output:     .fill       11 
