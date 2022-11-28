@ Program 20: Here to There
@ https://www.armasm.com/docs/fpu/here-to-there/
@
@ For this exercise, you are given two points. Find the distance between the two 
@ points and then output the parts of the equation.
@
@   Registers: 
@       r4: raw 32-bit float result 
@       r5: current number
@       r9: output buffer  
@
@       s0 - s3: base points 
@       s4: x calculations 
@       s5: y calculations 

@   | Sign (+/-) |  Exponent  | Fraction |
@   |   bit 31   | bits 23-30 | bit 0-22 |


.include "write.s" 

.global _start 

_start: 
    ldr         r0, =points         @ load address to points 
    vldm        r0, {s0 - s3}       @ load all of the points at once 

    @ calculate deltaX
    vsub.f32    s0, s2, s0          @ x2 - x1
    vmul.f32    s0, s0, s0          @ x^2

    @ calculate deltaY
    vsub.f32    s1, s3, s1          @ y2 - y1
    vmul.f32    s1, s1, s1          @ y^2

    @ x^2 + y^2
    vadd.f32    s0, s1, s0          @ x^2 + y^2

    @ sqrt
    vsqrt.f32   s0, s0              @ sqrt(sum)

    @ move result to regular registers to process 
    vmov        r4, s0

    @ write sign template 
    nullwrite   sign    

    @ prepare buffer for +/- sign
    ldr         r9, =buf
    @ first mask off first bit for + or - 
    tst         r4, #0x80000000     @ check the 31 bit
    beq         strpos              @ if 0 then the number is positive
    mov         r0, #'-'            @ init neg sign 
    b           writesign
strpos:
    mov         r0, #'+'            @ init pos sign 
writesign:
    strb        r0, [r9], #1        @ store sign in buf 
    mov         r0, #0x000a         @ prepare line return
    strh        r0, [r9]            @ store line feed
    nullwrite   buf                 @ write sign and go to next line

    @ write exponent template 
    nullwrite   expo 

    @ prepare buffer for exponent 
    ldr         r9, =buf

    @ mask off exponent bytes 
    ldr         r5, =0x7f800000     @ 0bx 0111 1111 1
    and         r5, r4, r5          @ check the 31 bit
    lsr         r5, #23             @ shift expo to base position 
    sub         r5, #127            @ subtract bias 

    mov         r0, r5              @ move number to r0
    ldr         r1, =buf            @ move buffer to r1 
    bl          itoa                @ call itoa

    @ write expo number 
    nullwrite   buf

    @ write line ending 
    ldr         r9, =buf         @ output address
    mov         r0, #0x000a         @ prepare line return
    strh        r0, [r9]            @ store line feed
    nullwrite   buf                 @ write sign and go to next line

    @ write fraction template 
    nullwrite   frac 

    @ for the fractions, 1 will always be written as the fraction will always be 
    @ 1.xxxxxxx Lets set up the first round (1) and then use it as a base. 
    @ r4: raw number 
    @ r5: number to output 
    @ r6: mask bit 
    @ r7: used for write macro   
    @ r9: buf address with offset 

    mov         r5, #1              @ set base 
    ldr         r9, =buf            @ reset output address 
    mov         r0, #0x20           @ 0x20 = space
    strb        r0, [r9], #1        @ store space and offset.

    @ setup itoa 
    mov         r0, r5              @ number to convert 
    mov         r1, r9              @ address to buffer 
    bl          itoa 

    nullwrite   buf                 @ write space and number 

    @ Setup loop 
    mov         r6, #1              @ load mask bit
    lsl         r6, #22             @ move mask bit to position 22 
    lsl         r5, #1              @ move output number to first possible 
                                    @ denom (1/2) 

fracloop:
    cmp         r6, #0              @ see if we still need to mask bits 
    beq         exit 
    tst         r4, r6              @ check if the bit is set
    beq         fracincr
    @ write digit if bit present 
    @ setup itoa 
    mov         r0, r5              @ move value to r0 
    mov         r1, r9              @ noop, for clarity 
    bl          itoa 
    nullwrite   buf 

fracincr:
    lsr         r6, #1              @ move right a bit of the mask
    lsl         r5, #1              @ multiply r5 with 2
    b           fracloop

exit:
    @ write final line ending 
    ldr         r9, =buf            @ reset buffer address 
    mov         r0, #0x000a         @ prepare line return
    strh        r0, [r9]            @ store line feed
    nullwrite   buf                 @ write sign and go to next line

    @ setup exit 
    mov         r7, #1              @ 1 = exit 
    mov         r0, #0              @ 0 = no error 
    svc         0 

.data 
points:     .single         4.0     @ x1
            .single         5.0     @ y1
            .single         2.0     @ x2
            .single         1.0     @ y2

sign:       .asciz          "Sign: "            @ Sign template
expo:       .asciz          "Exponent: "        @ exponent template
frac:       .asciz          "Fraction (1/x):"   @ fraction template
buf:        .fill           64          @ output buffer for other text 
