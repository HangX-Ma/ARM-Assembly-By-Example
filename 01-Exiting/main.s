@ Program 1:  Exiting
@ https://www.armasm.com/docs/getting-to-hello-world/exiting/

.global _start

@ Every program needs a _start label.  This is where the program 
@ will start. It does not need to be at the top of the file.  
@ Notice that a label is defined by text followed by a colon. 

_start:
    mov r7, #1  @ Setup service call 1 (exit)
    mov r0, #0  @ parameter is stored in r0-r5 in order for this syscall
    svc 0       @ supervisor call executed with command svc 0


@ -------------- HOW TO COMPILE AND RUN THIS PROGRAM --------------
@    as -o main.o main.s
@    ld -o main main.o
@    ./main
@ -----------------------------------------------------------------
@ If you want to see the returned code or the error code, do this
@    echo $?
