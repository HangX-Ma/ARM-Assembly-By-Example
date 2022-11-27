@ Program 5:  Hello World Revisited
@
@ Write a program displays "Hello World!" and exits with the error code 0. 
@ For the writing of the string, use a macro that prints using a null 
@ terminated string.

.include    "write.s"

.global _start 

_start:
    nullwrite       hello

    @ Setup syscall exit
    mov     r7, #1
    mov     r0, #0
    svc     0

.data
    hello:      .asciz      "Hello World\n"
    @ hello:      .ascii      "Hello World\n\0"

