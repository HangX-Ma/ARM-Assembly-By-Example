@ Program 3:  Find the Otter 
@ https://www.armasm.com/docs/registers-and-memory/find-the-otter/
@
@ Reads pre-loaded values in the registers and writes 
@ OTTER to STDOUT 

.global _start 

_start: 
    @@@@@@@@@@@@@@@@ Begin Register Preload 
    mov     r0, #'P' 
    mov     r1, #'O'
    mov     r2, #'I'
    mov     r3, #'U'
    mov     r4, #'Y'
    mov     r5, #'T'
    mov     r6, #'R'
    mov     r7, #'E'
    mov     r8, #'W'
    mov     r9, #'Q'
    @@@@@@@@@@@@@@@@ End Register Preload 

    @ Write your program here!!! 

    ldr     r10, =outstr        @ load outstr address into the r10
    strb    r1, [r10]           @ store one byte 'O' into outstr
    add     r10, #1             @ move to next byte address
    strb    r5, [r10]           @ store one byte 'T' into outstr
    add     r10, #1             @ move to next byte address
    strb    r5, [r10]           @ store anther byte 'T' into outstr
    add     r10, #1             @ move to next byte address
    strb    r7, [r10]           @ store one byte 'E' into outstr
    add     r10, #1             @ move to next byte address
    strb    r6, [r10]           @ store one byte 'R' into outstr

    @ Setup write syscall
    mov     r7, #4              @ 4 = write
    mov     r0, #1              @ 1 = stdout
    ldr     r1, =outstr         @ load output address
    mov     r2, #6              @ string length
    svc     0

    @ setup exit call
    mov     r7, #1              @ 1 = exit
    mov     r0, #0              @ 0 success
    svc     0

.data
outstr:         .ascii          "     \n"
