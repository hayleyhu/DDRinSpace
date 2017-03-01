; #########################################################################
;
;   game.asm - Assembly file for EECS205 Assignment 4/5
;
;
; #########################################################################

	  .586
	  .MODEL FLAT,STDCALL
	  .STACK 4096
	  option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc
include game.inc
include keys.inc


;; PlaySound
include winmm.inc
include windows.inc
includelib winmm.lib
;;Sleep function
include kernel32.inc
includelib kernel32.lib
;; wsprintf
include user32.inc
includelib user32.lib
; includelib msvcrt 

.DATA
PI_HALF = 102943           	;;  PI / 2
PI =  205887	



include DownArrowBlank.asm
include RightArrowYellow.asm
include background.asm
include LeftRed.asm
include DownRed.asm
include UpRed.asm
include RightRed.asm

StepChart Arrow <16, 260, 450,offset RightRed>, <27, 50, 450,offset LeftRed> 
ArrowOnScreen Arrow 10 DUP(<>)

SndPath BYTE "rsc/ddr_music.wav", 0
TitleString BYTE "Dance Dance Revolution in Space", 0
ScoreFormatStr BYTE "Score: ", 0
ScoreStr BYTE 256 DUP(0)
score DWORD ?
time DWORD ?
currIdx DWORD ?
; nextGoTime DWORD ?

.CODE	
;; Note: You will need to implement CheckIntersect!!!

GameInit PROC

	mov time, 0
	mov currIdx, 0
	; invoke BasicBlit, offset background, 320, 240
	invoke DrawStr, offset TitleString, 330, 40, 0ffh
	invoke DrawStr, offset ScoreFormatStr, 400, 20, 0ffh
	; invoke DrawStarField
	invoke RotateBlit, offset DownArrowBlank, 50, 60, PI_HALF		;left
	invoke BasicBlit, offset DownArrowBlank, 120, 60				;down 
	invoke RotateBlit, offset DownArrowBlank, 190, 60, PI_HALF*2 	;up
	invoke RotateBlit, offset DownArrowBlank, 260, 60, PI_HALF*3 	;right
	invoke PlaySound, offset SndPath, 0, SND_FILENAME OR SND_ASYNC
	xor eax, eax
	mov score, eax
	ret         ;; Do not delete this line!!!
GameInit ENDP


GamePlay PROC USES eax ebx ecx edx esi edi
	
	mov eax, currIdx
	mov edx, sizeof Arrow
	mul edx
	mov ebx, (Arrow PTR [StepChart + eax]).count

	cmp time, ebx
	jl notDraw
	mov ecx, (Arrow PTR [StepChart + eax]).x
	
	mov esi, (Arrow PTR [StepChart + eax]).bm
	;;; curr_y = start_y - (time - count)*10
	mov eax, time
	sub eax, (Arrow PTR [StepChart + eax]).count
	; mov ebx, 2
	; imul ebx
	mov edx, (Arrow PTR [StepChart + eax]).y
	sub edx, eax
	test edx, edx
	js notDraw
	invoke BasicBlit, esi, ecx, edx
	; inc currIdx
notDraw:
	inc time

	ret         ;; Do not delete this line!!!

GamePlay ENDP


DrawBackground PROC
	invoke DrawStr, offset TitleString, 330, 40, 0ffh
	invoke DrawStr, offset ScoreFormatStr, 400, 20, 0ffh
	; invoke DrawStarField
	invoke RotateBlit, offset DownArrowBlank, 50, 60, PI_HALF		;left
	invoke BasicBlit, offset DownArrowBlank, 120, 60				;down 
	invoke RotateBlit, offset DownArrowBlank, 190, 60, PI_HALF*2 	;up
	invoke RotateBlit, offset DownArrowBlank, 260, 60, PI_HALF*3 	;right
DrawBackground ENDP


Update PROC USES eax ebx ecx edx esi edi
	
	; mov eax, 0
	; mov edx, sizeof Arrow
	; mul edx
	; inc (Arrow PTR [StepChart + eax]).y

	; mov ecx, (Arrow PTR [StepChart + eax]).x
	; mov edx, (Arrow PTR [StepChart + eax]).y
	; invoke BasicBlit, (Arrow PTR [StepChart + eax]).bm, ecx, edx
Update ENDP

; ClearBlock PROC USES centerX:DWORD, centerY:DWORD, width:DWORD, height:DWORD, color:BYTE
	
; ClearBlock ENDP

; Memset PROC USES edi, ecx dst:PTR DWORD, size:DWORD, val:DWORD
; 	cld
; 	mov edi, dst
; 	mov eax, val
; 	mov ecx, size
; 	rep STOSB
; 	mov eax, size
; 	ret
; Memset ENDP


CheckIntersect PROC USES ebx ecx edx edi esi oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 
	LOCAL l1x:DWORD, l1y:DWORD, r1x:DWORD, r1y:DWORD, l2x:DWORD, l2y:DWORD, r2x:DWORD, r2y:DWORD
; l1 = (one.x - bitmap.width / 2, one.y - bitmap.height / 2)    Upperleft of one: (eax, edx)
; r1 = (one.x + bitmap.width / 2, one.y + bitmap.height / 2)	Bottomright of one: (edi, esi)
; l2 = (two.x - bitmap.width / 2, two.y - bitmap.height / 2)    Upperleft of two
; r2 = (two.x + bitmap.width / 2, two.y + bitmap.height / 2)	Bottomright of two
	mov eax, 1

	mov esi, oneBitmap
	mov ebx, (EECS205BITMAP PTR[esi]).dwWidth
	shr ebx, 1
	mov ecx, (EECS205BITMAP PTR[esi]).dwHeight
	shr ecx, 1
	
	mov edi, oneX
	sub edi, ebx
	mov l1x, edi
	mov edi, oneY
	sub edi, ecx
	mov l1y, edi

	mov edi, oneX
	add edi, ebx
	mov r1x, edi
	mov edi, oneY
	add edi, ecx
	mov r1y, edi

	mov esi, twoBitmap
	mov ebx, (EECS205BITMAP PTR[esi]).dwWidth
	shr ebx, 1
	mov ecx, twoBitmap
	mov ecx, (EECS205BITMAP PTR[esi]).dwHeight
	shr ecx, 1

	mov edi, twoX
	sub edi, ebx
	mov l2x, edi
	mov edi, twoY
	sub edi, ecx
	mov l2y, edi

	mov edi, twoX
	add edi, ebx
	mov r2x, edi
	mov edi, twoY
	add edi, ecx
	mov r2y, edi
; if (l1.x > r2.x || l2.x > r1.x) return false
; if (l1.y < r2.y || l2.y < r1.y) return false
	mov edi, l1x
	cmp edi, r2x
	jg turnFalse
	mov edi, l2x
	cmp edi, r1x
	jg turnFalse
	mov edi, l1y
	cmp edi, r2y
	jl turnFalse
	mov edi, l2y
	cmp edi, r1y
	jl turnFalse
	jmp result
turnFalse:
	xor eax, eax
result:
	ret
CheckIntersect ENDP

PressSparks PROC USES edx

Switch:
	mov edx, KeyPress
	cmp edx, 025h
	je LeftSpark
	cmp edx, 027h
	je RightSpark
	cmp edx, 026h
	je UpSpark
	cmp edx, 028h
	je DownSpark
	jmp result
LeftSpark:
	invoke Sleep, 500
	invoke RotateBlit, offset RightArrowYellow, 50, 60, PI_HALF*2
	
	invoke RotateBlit, offset DownArrowBlank, 50, 60, PI_HALF
	jmp result
DownSpark:
	invoke RotateBlit, offset RightArrowYellow, 120, 60, PI_HALF
	invoke Sleep, 500
	invoke BasicBlit, offset DownArrowBlank, 120, 60
	jmp result
UpSpark:
	invoke RotateBlit, offset RightArrowYellow, 190, 60, PI_HALF*3
	invoke Sleep, 500
	invoke RotateBlit, offset DownArrowBlank, 190, 60, PI_HALF*2
	jmp result
RightSpark:
	invoke RotateBlit, offset RightArrowYellow, 260, 60, 0
	invoke Sleep, 500
	invoke RotateBlit, offset DownArrowBlank, 260, 60, PI_HALF*3
result:

	ret
PressSparks ENDP






END
