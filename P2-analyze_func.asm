;-----------------------------------------------------------------------------------------------
; FILE:         analyze_func.asm
; DESCRIPTION:  NASM program for Linux, Intel, IA-32,
;               Shows parameters passing via registers. 
;
; ASSEMBLY:     nasm -f elf analyze_func.asm
; LINK:         ld -m elf_i386 -s -o analyze_func analyze_func.o cs219_io.o
; RUN:          ./analyze_func
;
; INPUT:        Integers (Coefficients and value [x] )
; OUTPUT:       f(x), the value of the polynomial at x
;               f'(x), the value of the derivative at x
;
; MODIFICATION HISTORY:
; Author:			            Date: 		    Version     Comments
; ----------------------	    ----------	    --------    --------------------
; Jefferson Phillips Retana	    2020-05-05	    1.0         Initial version. Just get and print values
; Jefferson Phillips Retana	    2020-05-07	    1.1         Presentation and edits in class
; Jefferson Phillips Retana	    2020-05-10	    1.2         Modification in procedure names
; Jefferson Phillips Retana	    2020-05-10	    1.3         Progress on display_fp_of_x
; Jefferson Phillips Retana	    2020-05-12	    2.0         Evaluation printing properly
; Jefferson Phillips Retana	    2020-05-13	    3.0         Display and evaluation fully working
; Jefferson Phillips Retana	    2020-05-13	    3.1         Final 3:00 am edits
;-----------------------------------------------------------------------------------------------

%include "cs219_io.mac"

segment .data                                   ; Initialized
formula db  'f(x) = a*x^2 + b*x + c'    , 0     ; Prompting formula
prompt  db  'Enter coefficient [a] : '  , 0     ; Getting coefficients
promptX db  'Enter input value [x] : '  , 0     ; Get coef x
SIZE    EQU 3                                   ; Size of the array
SIZE_P  EQU SIZE - 1                            ; Size of the array

f_x         db  'f(x)  = '  , 0
f_x_prime   db  "f'(x) = "  , 0
times_x2    db  "*x^2 + "   , 0
times_x     db  "*x + "     , 0

; The following strings are used to print out the evaluation of the functions
f_0     db  "f("    , 0
fp_0    db  "f'("   , 0
f_1     db ")  = "  , 0
fp_1    db ") = "   , 0
f_2     db "*("     , 0
f_3     db ")^2 + " , 0
f_4     db ") + "   , 0
f_5     db " = "    , 0

segment .bss                                ; Uninitialized
    array       resd    SIZE                ; Reserve Doublewords (4 bytes each)
    array_prime resd    SIZE_P              ; Reserve Doublewords
    chr         resb    1                   ; Reserve byte
    inp_x       resb    32                  ; Reserve for x

segment .text
    global _start

;-----------------------------------------------------------------------------------------------
; Procedure Name:	Start
; Description:		Code starts running here 
;-----------------------------------------------------------------------------------------------
_start:
    nwln                    ; New Line
    PutStr formula          ; Print out formula
    nwln                    ; New Line

    nwln                    ; New Line           
    call get_input          ; Get coefs into array

    nwln                    ; New Line
    call display_f_of_x     ; Print 
    call display_fp_of_x    ; Print the derivative
    
    nwln
    call eval_f_of_x        ; Evaluates the function f(x) = ?
    call eval_fp_of_x       ; Evaluates the function f'(x) = ?

done:
    nwln
    exit

;-----------------------------------------------------------------------------------------------
; Procedure Name:	get_input
; Description:		Read integers and puts in array
;-----------------------------------------------------------------------------------------------
get_input:
    mov [chr], byte 'a'     ; ACII value for number character
    mov EBX, array          ; store array address to register EBX
    mov ECX, SIZE           ; store array size to register ECX

array_loop:
    mov     AL, [chr]           ; chr needs to pass through register  
    mov     [prompt+19], AL     ; Write character to prompt1[15]
    PutStr  prompt              ; Print
    GetLInt EAX                 ; Read int 
    mov     [EBX], EAX          ; Copy value into array
    add     EBX, 4              ; Inc Address
    inc     byte [chr]          ; Increment ASCII value
    loop    array_loop          ; iterates SIZE times

    PutStr promptX          ; Print string to get X value
    GetLInt EAX             ; Get x
    mov [inp_x], EAX        ; Move x value into variable

    ret                     ; return to main

;-----------------------------------------------------------------------------------------------
;Procedure Name:	display_f_of_x
;Description:		Print the function stored in the array
;-----------------------------------------------------------------------------------------------
display_f_of_x:
    PutStr  f_x             ; Display array
    mov     EBX, array      ; EBX = pointer to array
    mov     ECX, SIZE       ; Size of array

    call display_num        ; Print 1st coef
    PutStr times_x2         ; Print  *x^2 + 
    call display_num        ; Print 2nd coef
    PutStr times_x          ; Print  *x + 
    call display_num        ; Print 3rd coef

    nwln                    ; New Line
    ret                     ; Return to main

;-----------------------------------------------------------------------------------------------
;Procedure Name:	display_fp_of_x
;Description:		Print the function stored in the array
;-----------------------------------------------------------------------------------------------
display_fp_of_x:
    call calc_prime         ; Calculate the derivative and store it in array_prime

    PutStr  f_x_prime           ; Display array
    mov     EBX, array_prime    ; EBX = pointer to array
    mov     ECX, SIZE_P         ; Size of array

    call display_num        ; Print 2nd coef
    PutStr times_x          ; Print  *x + 
    call display_num        ; Print 3rd coef

    nwln                    ; New Line
    ret                     ; Return to main

;-----------------------------------------------------------------------------------------------
;Procedure Name:	display_num
;Description:		Print the number stored in EBX
;-----------------------------------------------------------------------------------------------
display_num:
    PutLInt [EBX]           ; Display value at array[i]
    add     EBX, 4          ; Increment array pointer

    ret                     ; Ret to show array

;-----------------------------------------------------------------------------------------------
; Procedure Name:	calc_prime
; Description:		Calculate the derivative and store it in array_prime
;-----------------------------------------------------------------------------------------------
calc_prime:
    mov EBX, [array]        ; Store first value (a) to register EBX
    mov ECX, array_prime    ; Store array_prime address into ECX

    mov EAX, 2              ; Store 2 in EAX
    mul EBX                 ; EAX *= EBX
    mov [ECX], EAX          ; Move result into ECX, hence, into array

    add ECX, 4              ; Increment Address
    mov EBX, [array+4]      ; Store second value into EBX
    mov [ECX], EBX          ; Copy value into array

    ret

;-----------------------------------------------------------------------------------------------
; Procedure Name:	eval_f_of_x
; Description:		Evaluates the function f(x) = ?
;-----------------------------------------------------------------------------------------------
eval_f_of_x:
    mov EBX, array          ; EBX = pointer to array

    PutStr  f_0             ; Display array
    PutLInt [inp_x]         ; Put X
    PutStr  f_1             ; Display array

    call display_num        ; Print 1st coef
    PutStr f_2              ; Print *( 
    PutLInt [inp_x]         ; Put X
    PutStr f_3              ; Print  *( 

    call display_num        ; Print 2nd coef
    PutStr f_2              ; Print *( 
    PutLInt [inp_x]         ; Put X
    PutStr f_4              ; Print ") + " 

    call display_num        ; Print 3rd coef
    PutStr f_5              ; Print ") + "

compute_result:
    mov EDX, [array]        ; Store a in EDX 

    mov EAX, [inp_x]        ; Store X in EAX
    mov ECX, [inp_x]        ; Store X in ECX
    mul EDX                 ; EAX *= EDX which is a*x
    mul ECX                 ; EAX *= ECX which is x^2
    mov ECX, EAX            ; Move result to ECX

    mov EAX, [inp_x]        ; EAX = x
    mov EDX, [array+4]      ; EDX = b
    mul EDX                 ; EAX *= EDX  
    add ECX, EAX            ; add to ECX

    mov EDX, [array+8]      ; EDX = c
    add ECX , EDX           ; add to ECX

    PutLInt ECX             ; Print Result 
    
    nwln                    ; New Line
    ret

;-----------------------------------------------------------------------------------------------
; Procedure Name:	eval_fp_of_x
; Description:		Evaluates the function f'(x) = ?
;-----------------------------------------------------------------------------------------------
eval_fp_of_x:
    mov     EBX, array_prime    ; EBX = pointer to array
    mov     ECX, SIZE_P         ; Size of array

    PutStr  fp_0                ; Display array
    PutLInt [inp_x]             ; Put X
    PutStr  fp_1                ; Display array

    call display_num            ; Print 1st coef
    PutStr f_2                  ; Print *( 
    PutLInt [inp_x]             ; Put X
    PutStr f_4                  ; Print ") + " 

    call display_num            ; Print 3rd coef
    PutStr f_5                  ; Print ") + " 

compute_p_result:
    mov EAX, [inp_x]            ; EAX = x
    mov EDX, [array_prime]      ; EDX = a
    mul EDX                     ; EAX *= EDX  
    mov ECX, EAX                ; add to ECX

    mov EDX, [array_prime + 4]  ; EDX = b
    add ECX , EDX               ; add to ECX

    PutLInt ECX                 ; Print Result 
    
    nwln                        ; New line
    ret
