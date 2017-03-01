; #########################################################################
;
;   trig.asm - Assembly file for EECS205 Assignment 3
;
;	Yue Hu, yhn490
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include trig.inc

.DATA

;;  These are some useful constants (fixed point values that correspond to important angles)
PI_HALF = 102943           	;;  PI / 2
PI =  205887	                ;;  PI 
TWO_PI	= 411774                ;;  2 * PI 
PI_INC_RECIP =  5340353        	;;  (256/PI)<<32    Use reciprocal to find the table entry for a given angle
NEG_ONE = 4294901760	                        ;;  (It is easier to use than divison would be)


	;; If you need to, you can place global variables here
.CODE
FixedSin PROC USES ebx edx ecx angle:FXPT
;; Fixedsin(x) 
;; if 0<=x<=Pi/2 : Fixedsin(x)  = lookup(x*256/Pi)
;; else if Pi/2<x<=Pi: Fixedsin(x) =  Fixedsin(Pi-x)
;; else if Pi<x: Fixedsin(x) = -Fixedsin(x-Pi)
;; else: x<0: Fixedsin(x) = -Fixedsin(x+Pi)
	mov ebx, angle
	cmp ebx,0
	jl less_then_zero
	cmp ebx, PI_HALF
	jng zero_and_half_pi
	cmp ebx, PI
	jl half_and_pi
	; jmp result
;; Pi<=x
	sub ebx, PI
	invoke FixedSin, ebx
	mov ebx, NEG_ONE
	imul ebx
	shr eax,16
	shl edx,16
	or eax, edx
	jmp result
less_then_zero:
	add ebx, TWO_PI
	invoke FixedSin, ebx
	jmp result
zero_and_half_pi:
	mov eax, angle
	mov ebx, PI_INC_RECIP
	mul ebx
	and edx, 127
	shl edx, 1      ;;SINTAB is WORD-sized
	movzx eax, [SINTAB + edx]
	jmp result
half_and_pi:
	mov ebx, PI
	sub ebx, angle
	invoke FixedSin, ebx

	
result:
	ret			; Don't delete this line!!!
FixedSin ENDP 


	
FixedCos PROC angle:FXPT
	xor eax, eax
	mov eax, angle
	add eax, PI_HALF
	invoke FixedSin, eax
	ret			; Don't delete this line!!!	
FixedCos ENDP	

END
