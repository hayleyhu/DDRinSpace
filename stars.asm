; #########################################################################
;
;   stars.asm - Assembly file for EECS205 Assignment 1
;   Author: Yue Hu
;   NetID: yhn490
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive


include stars.inc

.DATA

	;; If you need to, you can place global variables here

.CODE

DrawStarField proc USES eax ebx ecx edx edi time:DWORD

	;; Place your code here
	;; for i from 0 to 15:
	;;   invoke DrawStar, (i*40+1), (i*30+time)%480
	mov ebx, 1
	mov eax, time
	mov ecx, 0
	jmp eval
body:
	invoke DrawStar, ebx, eax
	add ebx, 40
	add eax, 30
	xor edx, edx
	mov edi, 480
	idiv edi
	mov eax, edx
	inc ecx
eval:
	cmp ecx, 15
	jng body
	

	ret  			; Careful! Don't remove this line
DrawStarField endp



END
