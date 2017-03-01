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

DrawStarField proc

	;; Place your code here
	INVOKE DrawStar,1,1
	INVOKE DrawStar,41,31
	INVOKE DrawStar,81,61
	INVOKE DrawStar,121,91
	INVOKE DrawStar,161,121
	INVOKE DrawStar,201,151
	INVOKE DrawStar,241,181
	INVOKE DrawStar,281,211
	INVOKE DrawStar,321,241
	INVOKE DrawStar,361,271
	INVOKE DrawStar,401,301
	INVOKE DrawStar,441,331
	INVOKE DrawStar,481,361
	INVOKE DrawStar,521,391
	INVOKE DrawStar,561,421
	INVOKE DrawStar,601,451
	

	ret  			; Careful! Don't remove this line
DrawStarField endp



END
