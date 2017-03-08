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
include Marvelous.asm
include Barframe.asm
include Healthbar.asm
include Good.asm
include Boo.asm

StepChart Arrow <265, 260, 450,offset RightRed>, <275, 260, 450,offset RightRed>, <285, 260, 450, offset RightRed>
		Arrow <295, 260, 450, offset RightRed>, <305, 260, 450, offset RightRed>, <315, 260, 450, offset RightRed> 
		Arrow <330, 120, 450, offset DownRed>, <340, 260, 450, offset RightRed>, <350, 50, 450, offset LeftRed>
		Arrow <360, 190, 450, offset UpRed>, <360, 120, 450, offset DownRed>, <370, 50, 450, offset LeftRed>	
		Arrow <380, 260, 450, offset RightRed>, <390, 190, 450, offset UpRed>, <400, 120, 450, offset DownRed>, <410, 50, 450, offset LeftRed>
		;;; 2ND column
		Arrow <420, 120, 450, offset DownRed>, <430, 260, 450, offset RightRed>, <440, 120, 450, offset DownRed>,<450, 50, 450, offset LeftRed> 
		Arrow <460, 190, 450, offset UpRed>,<470, 260, 450, offset RightRed>,<480, 260, 450, offset RightRed>,<485, 120, 450, offset DownRed>, <490, 50, 450, offset LeftRed>
		Arrow <500, 260, 450, offset RightRed>, <510, 50, 450, offset LeftRed>, <520, 190, 450, offset UpRed>, <520, 120, 450, offset DownRed>, <530, 50, 450, offset LeftRed>
		Arrow <540, 260, 450, offset RightRed>, <550, 190, 450, offset UpRed>, <560, 120, 450, offset DownRed>, <570, 50, 450, offset LeftRed>
		Arrow <580, 190, 450, offset UpRed>, <585, 50, 450, offset LeftRed>, <590, 120, 450, offset DownRed>,  <600, 190, 450, offset UpRed>, <610, 260, 450, offset RightRed>, <610, 120, 450, offset DownRed>
		Arrow <620, 190, 450, offset UpRed>, <620, 50, 450, offset LeftRed>, <630, 120, 450, offset DownRed>, <640, 120, 450, offset DownRed>, <650, 120, 450, offset DownRed>
		Arrow <660, 120, 450, offset DownRed>,<670, 260, 450, offset RightRed>,<680, 190, 450, offset UpRed>, <690, 120, 450, offset DownRed>
		Arrow <700, 50, 450, offset LeftRed>,<710, 190, 450, offset UpRed> , <720, 120, 450, offset DownRed>,<730, 50, 450, offset LeftRed>, <730, 260, 450, offset RightRed>

		Arrow <740, 190, 450, offset UpRed>,<750, 260, 450, offset RightRed> ,<760, 190, 450, offset UpRed>,<770, 260, 450, offset RightRed>
		Arrow <780, 190, 450, offset UpRed>,<790, 50, 450, offset LeftRed>,<800, 120, 450, offset DownRed>,<810, 50, 450, offset LeftRed>,<810, 260, 450, offset RightRed>
		Arrow <820, 190, 450, offset UpRed>,<825, 50, 450, offset LeftRed>,<830, 120, 450, offset DownRed>, <840, 190, 450, offset UpRed>,<850, 120, 450, offset DownRed>
		Arrow <860, 190, 450, offset UpRed>,<865, 260, 450, offset RightRed> ,<870, 120, 450, offset DownRed>, <880, 190, 450, offset UpRed>,<890, 120, 450, offset DownRed>
		Arrow <900, 190, 450, offset UpRed>,<905, 50, 450, offset LeftRed>,<910, 120, 450, offset DownRed>,<920, 260, 450, offset RightRed> ,<930, 120, 450, offset DownRed>
		Arrow <940, 190, 450, offset UpRed>, <945, 260, 450, offset RightRed>,<950, 120, 450, offset DownRed> ,<960, 50, 450, offset LeftRed>,<970, 120, 450, offset DownRed>
		Arrow <980, 260, 450, offset RightRed>,<990, 190, 450, offset UpRed>,<1000, 120, 450, offset DownRed> ,<1010, 190, 450, offset UpRed>
		Arrow <1020, 260, 450, offset RightRed>,<1030, 50, 450, offset LeftRed>,<1040, 120, 450, offset DownRed>,<1050, 260, 450, offset RightRed>
		Arrow <1060, 50, 450, offset LeftRed>, <1070, 120, 450, offset DownRed>,<1080, 190, 450, offset UpRed>,<1090, 120, 450, offset DownRed>
		Arrow <1100, 190, 450, offset UpRed>, <1110, 260, 450, offset RightRed>,<1120, 120, 450, offset DownRed>,<1130, 260, 450, offset RightRed>
		Arrow <1140, 190, 450, offset UpRed>,<1150, 50, 450, offset LeftRed>,<1160, 120, 450, offset DownRed>,<1170, 50, 450, offset LeftRed>

	


StepChartEnd Arrow <200, 200, 450, offset LeftRed>

SndPath BYTE "rsc/ddr_music.wav", 0
TitleString BYTE "Dance Dance Revolution in Space", 0
DeadString BYTE "You Lost!",0
PauseString BYTE "Release ENTER to continue",0
NormalString BYTE "Press and hold ENTER to pause",0
FinishString BYTE "You Won! Your score is: %d",0
outStr BYTE 256 DUP(0)

score DWORD 441
time DWORD ?
iterator DWORD ?
nextIdx DWORD 0
PauseFlag DWORD 0

.CODE	

GameInit PROC

	mov time, 0
	; mov iterator, 0
	; invoke BasicBlit, offset background, 320, 240
	invoke DrawStr, offset TitleString, 330, 40, 0ffh
	invoke PlaySound, offset SndPath, 0, SND_FILENAME OR SND_ASYNC			;Advanced Feature: Music

EXIT:
	ret         ;; Do not delete this line!!!
GameInit ENDP


GamePlay PROC USES eax ecx esi edi
	
;DrawBackground
	cld
	xor eax, eax
	mov edi, ScreenBitsPtr
	mov ecx, 640*480
	rep stosb
	invoke DrawStr, offset TitleString, 330, 40, 0ffh
	cmp score, 541
	jg DEAD
	cmp PauseFlag, 1
	jne NOPAUSE
	invoke pausedState
	jmp EXIT

NOPAUSE:
	cmp time, 1400
	jg FINISHED

	cmp KeyPress, VK_RETURN 
	jne Continue
	mov PauseFlag, 1
Continue:
	invoke DrawStarField, time              						;Advanced Feature: Scrolling background
	invoke DrawStr, offset NormalString, 330, 80, 0ffh
	invoke RotateBlit, offset DownArrowBlank, 50, 60, PI_HALF		;left
	invoke BasicBlit, offset DownArrowBlank, 120, 60				;down 
	invoke RotateBlit, offset DownArrowBlank, 190, 60, PI_HALF*2 	;up
	invoke RotateBlit, offset DownArrowBlank, 260, 60, PI_HALF*3 	;right
	invoke BasicBlit, offset Healthbar, 600, score
	invoke BasicBlit, offset Barframe, 600, 341

;Loop over all arrows
	mov eax, nextIdx
	mov iterator, eax
	jmp eval
body:	
	invoke PressSparks
; if time < count: notDraw
	mov eax, iterator
	mov ebx, (Arrow PTR [StepChart + eax]).count	
	sub ebx, time
	test ebx, ebx
	jns endloop  ;;; not the time to show up yet
	mov eax, 7
	imul ebx
	mov ebx, eax
	; ebx = 7*(count-time)
	mov eax, iterator
	mov ecx, (Arrow PTR [StepChart + eax]).x
	mov edx, (Arrow PTR [StepChart + eax]).y
	add edx, ebx
	; edx = start_y + 3*(count-time)
	cmp edx, 50
	jl notDraw
	
	mov esi, (Arrow PTR [StepChart + eax]).bm
	invoke BasicBlit, esi, ecx, edx
	cmp edx, 80
	jnl notCheckCaught
	mov eax, iterator
	; mov esi, (Arrow PTR [StepChart + eax]).caught
	invoke Passthrough, eax
	
	; mov esi, iterator
	; mov (Arrow PTR [StepChart + esi]).caught, eax
	jmp notCheckCaught
notDraw:
	
	cmp edx, 44
	
	jl notCheckCaught
	mov eax, iterator
	mov nextIdx, eax
	xor esi, esi

	cmp esi, (Arrow PTR [StepChart + eax]).caught
	jne notCheckCaught
	invoke BasicBlit, offset Boo, 400, 400
	add score, 10 ;; punishment because of missed arrow. score += 2 if caught == 0
notCheckCaught:
	add iterator, TYPE StepChart
eval:
	mov eax, offset StepChartEnd
	sub eax, offset StepChart
	cmp iterator, eax
	jl body
endloop:	
	inc time
	jmp EXIT
DEAD:
	invoke deadState
	jmp EXIT
FINISHED:
	invoke finishState
EXIT:	
	ret         ;; Do not delete this line!!!

GamePlay ENDP


pausedState PROC 
	 
	invoke DrawStr, offset PauseString, 330, 80, 0ffh
	; invoke BasicBlit, offset Good, 400, 400
	; invoke PlaySound,NULL,NULL,SND_ASYNC
	cmp KeyPress, VK_RETURN
	je EndPause
	mov PauseFlag, 0
EndPause:
	ret
pausedState ENDP

deadState PROC 
	invoke DrawStr, offset DeadString, 330, 80, 0ffh
	ret
deadState ENDP

finishState PROC

	mov eax, 700
	sub eax, 541
	shl eax, 2
	push eax
	push offset FinishString
	push offset outStr
	call wsprintf
	add esp,12 
	invoke DrawStr,offset outStr,330,80,255
	ret
finishState ENDP

 
Passthrough PROC USES eax ebx edx pos: DWORD
	mov eax, pos
	mov ebx,(Arrow PTR [StepChart + eax]).caught
	cmp ebx, 1
	je exit
	mov edx, (Arrow PTR [StepChart + eax]).x
	cmp edx, 50
	jg L1
	cmp KeyPress, VK_LEFT
	jne result
	jmp addScore
L1:

	cmp edx, 120
	jg L2 
	cmp KeyPress, VK_DOWN
	jne result
	jmp addScore
L2:
	cmp edx, 190
	jg L3 
	cmp KeyPress, VK_RIGHT
	jne result
	jmp addScore
L3:
	cmp edx, 260
	jg result
	cmp KeyPress, VK_RIGHT 
	jne result

addScore:

	mov (Arrow PTR [StepChart + eax]).caught, 1
	sub score, 4
	mov ebx, (Arrow PTR [StepChart + eax]).y
	cmp ebx, 65
	jnl good 
	sub score, 2                         			;;;Advanced Feature: multiple score values
	invoke BasicBlit, offset Marvelous, 400,400
	jmp result
good:
	invoke BasicBlit, offset Good, 400, 400
	jmp result
result:
	; cmp score, 341
	; jnl exit
	; mov score, 341
exit:
	
	ret
Passthrough ENDP

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
	invoke RotateBlit, offset DownArrowBlank, 50, 65, PI_HALF
	jmp result
DownSpark:
	invoke BasicBlit, offset DownArrowBlank, 120, 65
	jmp result
UpSpark:
	invoke RotateBlit, offset DownArrowBlank, 190, 65, PI_HALF*2 	;up
	jmp result
RightSpark:	
	invoke RotateBlit, offset DownArrowBlank, 260, 65, PI_HALF*3 
	jmp result
result:

	ret
PressSparks ENDP


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








END
