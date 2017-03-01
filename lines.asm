; #########################################################################
;
;   lines.asm - Assembly file for EECS205 Assignment 2
;
;   Yue Hu, yhn490
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc

.DATA

	;; If you need to, you can place global variables here
	
.CODE
	

DiffAbs PROC x1:DWORD, x0:DWORD
	mov eax, x1
	sub eax, x0
	cmp eax, 0
	jg result
	neg eax
result:
	ret
DiffAbs ENDP



DrawLine PROC USES ebx ecx edx x0:DWORD, y0:DWORD, x1:DWORD, y1:DWORD, color:DWORD
	LOCAL inc_x:DWORD, inc_y:DWORD, error:DWORD, delta_x: DWORD, delta_y:DWORD
	
	invoke DiffAbs, x1, x0
	mov delta_x, eax			;delta_x = abs(x1-x0)	
	invoke DiffAbs, y1, y0
	mov delta_y, eax			;delta_y = abs(y1-y0)

	mov inc_x, 1
	mov eax, x1
	cmp x0, eax
	jl conti1
	neg inc_x				;if x0>=x1: inc_x=-1
conti1:				;x0<x1
	mov inc_y, 1
	mov eax, y1
	cmp y0, eax
	jl conti2  
	neg inc_y				;if y0>=y1: inc_y=-1
conti2:       ;y0<y1
	mov eax, delta_y
	cmp delta_x, eax
	jng negerror
	mov eax, delta_x				;if delta_x>delta_y: error=delta_x/2
	sar eax, 1          
	mov error, eax			;error = delta_x >> 1
	jmp initialization
negerror:	 				;if delta_x<=delta_y: error=-delta_y/2
	mov eax, delta_y
	neg eax
	sar eax, 1
	mov error, eax    
initialization: 
	mov ebx, x0             ;ebx = curr_x = x0
	mov ecx, y0             ;ecx = curr_y = y0
	invoke DrawPixel, ebx, ecx, color
	jmp eval
do:
 	invoke DrawPixel, ebx, ecx, color

 	mov edx, error         ;edx = prev_error = error
 	mov eax, delta_x
 	neg eax                 ;eax = -delta_x
 	cmp edx, eax
 	jng conti3
 	mov eax, delta_y			;if prev_error>-delta_x
 	sub error, eax				;error = error - delta_y
 	add ebx, inc_x				;curr_x = curr_x + inc_x
conti3:      ;prev_error <= -delta_x
 	cmp edx, delta_y
	jnl eval
	mov eax, delta_x			;if prev_error<-delta_y
	add error, eax 				;error = error + delta_x
	add ecx, inc_y				;curr_y = curr_y + inc_y
eval:       ;if prev_error >= delta_y
	cmp ebx, x1
	jne do
	cmp ecx, y1
	jne do

	ret        	
DrawLine ENDP




END
