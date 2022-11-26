@ Program 2:  Hello world

.global _start

@ Every program needs a _start label.  This is where the program 
@ will start. It does not need to be at the top of the file.  
@ Notice that a label is defined by text followed by a colon. 

@ [syscall table] https://syscalls.w3challs.com/?arch=arm_strong

_start:
    mov r7, #4          @ Setup service call 4 (write)
    mov r0, #1          @ 1 = stdout
    ldr r1, =hello      @ LDR load address of hello world string. We use '=' here, 
                        @ but if you ignore '=', LDR will obtain the value stored
                        @ in the address that label `hello` points to.
    mov r2, #13         @ string length = 13
    svc 0

    mov r7, #1          @ Setup service call 1 (exit)
    mov r0, #0          @ parameter is stored in r0-r5 in order for this syscall
    svc 0               @ supervisor call executed with command svc 0

@ .data is a section in elf file format 
@ FOMAT: label:?     .datatype       data 
.data

@ The next line labels the location our string starts as `hello`
hello:      .ascii      "Hello World!\n"

@ -------------- HOW TO COMPILE AND RUN THIS PROGRAM --------------
@    as -o main.o main.s
@    ld -o main main.o
@    ./main
@ -----------------------------------------------------------------
@ If you want to see the returned code or the error code, do this
@    echo $?
