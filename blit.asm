; #########################################################################
;
;   blit.asm - Assembly file for EECS205 Assignment 3
;
;  Yue Hu, yhn490
; #########################################################################

      .586
      .MODEL FLAT,STDCALL
      .STACK 4096
      option casemap :none  ; case sensitive

include stars.inc
include lines.inc
include trig.inc
include blit.inc


.DATA
	;; If you need to, you can place global variables here
	
.CODE

DrawPixel PROC USES ebx ecx edx x:DWORD, y:DWORD, color:DWORD
;; ScreenBitsPtr[x+y*640] = color
	mov eax, 640
	mov ecx, y
	imul ecx
	add eax, x
	mov edx, color
	mov ebx, ScreenBitsPtr
	mov BYTE PTR [ebx+eax], dl
	ret 			; Don't delete this line!!!
DrawPixel ENDP


BasicBlit PROC USES ebx edx esi edi ptrBitmap:PTR EECS205BITMAP , xcenter:DWORD, ycenter:DWORD
	LOCAL x_start: DWORD, x_end: DWORD, y_end: DWORD, 
			transp_col:BYTE
;; half_w = ptrBitmap.dwWidth >> 1
;; x_start = xcenter - half_w 
;; x_end = xcenter + half_w   
;; half_h = ptrBitmap.dwHeight >> 1
;; y = ycenter - half_h               --------------edi=y
;; y_end = ycenter + half_h
;; i = ptrBitmap.lpBytes              --------------esi=i
;; transp_col = ptrBitmap.bTransparent--------------bl=transp_col                        
	mov eax, ptrBitmap
	mov eax, (EECS205BITMAP PTR[eax]).dwWidth
	sar eax, 1
	mov ebx, xcenter
	sub ebx, eax
	mov x_start, ebx
	mov ebx, xcenter
	add ebx, eax
	mov x_end, ebx
	mov eax, ptrBitmap
	mov eax, (EECS205BITMAP PTR[eax]).dwHeight
	sar eax, 1
	mov edi, ycenter
	sub edi, eax
	mov ebx, ycenter
	add ebx, eax
	mov y_end, ebx
	mov eax, ptrBitmap
	mov esi, (EECS205BITMAP PTR[eax]).lpBytes
	mov bl, (EECS205BITMAP PTR[eax]).bTransparent
;; for (; y<y_end and y<480; y++):
;;		if (y<0 ): i+=640; continue; 
;;		for (x=x_start; x<x_end; x++): -------------edx=x           
;;			if (x<0 or x>639): i++; continue; 
;;			col = [i]                  -------------al=col
;;			if (col!=transp_col): DrawPixel(x,y,col)
;;			i++;
y_eval:
	cmp edi, y_end
	jnl result
	cmp edi, 480
	jnl result
y_body:
	cmp edi,0
	jl skipy
;x_init:
	mov edx, x_start
x_eval:
	cmp edx, x_end
	jnl yinc
;x_body:
	cmp edx, 0
	jl xinc
	cmp edx, 640
	jnl xinc
	xor eax, eax
	mov al, [esi]
	cmp al, bl
	je xinc
	mov ecx, edx
	invoke DrawPixel, edx, edi, eax
xinc:
	
	inc edx ;x++
	inc esi ;i++
	jmp x_eval

skipy:
	add esi, 640
yinc:
	inc edi ;y++
	jmp y_eval
result:
	ret 			; Don't delete this line!!!	
BasicBlit ENDP


Fx2Int PROC x:FXPT
	mov eax, x
	shr eax, 16
	ret
Fx2Int ENDP


Int2Fx PROC x:DWORD
	mov eax, x
	shl eax, 16
	ret
Int2Fx ENDP


IntTimesFx PROC USES ebx edx x:DWORD, y:FXPT 
	invoke Int2Fx, x
	mov ebx, y
	imul ebx
	mov eax, edx
	ret
IntTimesFx ENDP


IntTimesFxOver2 PROC USES ebx edx x:DWORD, y:FXPT 
	invoke Int2Fx, x
	mov ebx, y
	imul ebx
	sar edx, 1
	mov eax, edx
	ret
IntTimesFxOver2 ENDP

RotateBlit PROC USES ebx ecx edx edi esi lpBmp:PTR EECS205BITMAP, xcenter:DWORD, ycenter:DWORD, angle:FXPT
	LOCAL shiftX:DWORD, shiftY:DWORD, dstWidth:DWORD, dstHeight:DWORD, cosa:FXPT, sina:FXPT
	LOCAL dstX: DWORD, dstY:DWORD, srcX:DWORD, srcY:DWORD
	LOCAL lpBytes: DWORD, transp_col:BYTE, color:DWORD
; cosa = FixedCos(angle) 
; sina = FixedSin(angle) 
	invoke FixedCos, angle
	mov cosa, eax
	invoke FixedSin, angle
	mov sina, eax
; esi = lpBitmap
	mov esi, lpBmp

; /* Note: Probably easiest to convert ints to fixed and then multiply two fixed point values */
; shiftX = (EECS205BITMAP PTR [esi]).dwWidth * cosa / 2   - (EECS205BITMAP PTR [esi]).dwHeight * sina / 2
;                        -------------edx                                -------------edi
; shiftY = (EECS205BITMAP PTR [esi]).dwHeight * cosa / 2 +  (EECS205BITMAP PTR [esi]).dwWidth * sina / 2
	mov eax, (EECS205BITMAP PTR[esi]).lpBytes
	mov lpBytes, eax
	mov al, (EECS205BITMAP PTR[esi]).bTransparent
	mov transp_col, al
	mov edx, (EECS205BITMAP PTR[esi]).dwWidth
	mov edi, (EECS205BITMAP PTR[esi]).dwHeight

	invoke IntTimesFxOver2, edx, cosa
	mov shiftX, eax
	
	invoke IntTimesFxOver2, edi, sina
	sub shiftX, eax

	invoke IntTimesFxOver2, edi, cosa
	mov shiftY, eax
	invoke IntTimesFxOver2, edx, sina
	add shiftY, eax

	;;;for loop
; dstWidth= (EECS205BITMAP PTR [esi]).dwWidth +  (EECS205BITMAP PTR esi]).dwHeight
; dstHeight= dstWidth 
	mov dstWidth, edx
	add dstWidth, edi
	mov eax, dstWidth  
	mov dstHeight, eax

	mov dstX, eax
	neg dstX
dstX_eval:
	mov eax, dstWidth
	cmp dstX, eax
	jnl result
	
;dstX_body
	mov eax, dstHeight
	mov dstY, eax
	neg dstY
dstY_eval:
	mov eax, dstHeight
	cmp dstY, eax
	jnl dstX_inc

;	srcX = dstX*cosa + dstY*sina
;  	srcY = dstY*cosa – dstX*sina
	invoke IntTimesFx, dstX, cosa
	mov srcX, eax
	invoke IntTimesFx, dstY, sina
	add srcX, eax
	invoke IntTimesFx, dstY, cosa
	mov srcY, eax
	invoke IntTimesFx, dstX, sina
	sub srcY, eax


; if (srcX >= 0 && srcX < (EECS205BITMAP PTR [esi]).dwWidth &&
; 	srcY >= 0 && srcY < (EECS205BITMAP PTR [esi]).dwHeight && 
; 	(xcenter+dstX- shiftX) >= 0 && (xcenter+dstX -shiftX) < 639 
; 	&& (ycenter+dstY -shiftY) >= 0 && (ycenter+dstY -shiftY) < 479 
; 	&& bitmap pixel (srcX,srcY) is not transparent)
	mov edx, (EECS205BITMAP PTR[esi]).dwWidth
	mov edi, (EECS205BITMAP PTR[esi]).dwHeight
	cmp srcX, 0
	jl dstY_inc
	cmp srcX, edx
	jnl dstY_inc
	cmp srcY, 0
	jl dstY_inc
	cmp srcY, edi
	jnl dstY_inc

	mov ecx, xcenter
	add ecx, dstX
	sub ecx, shiftX
	cmp ecx, 0
	jl dstY_inc
	cmp ecx, 639
	jnl dstY_inc
	

	mov edi, ycenter
	add edi, dstY
	sub edi, shiftY
	cmp edi, 0
	jl dstY_inc
	cmp edi, 479
	jnl dstY_inc

	mov eax, (EECS205BITMAP PTR[esi]).dwWidth
	imul srcY
	add eax, srcX
	add eax, lpBytes
	mov bl, BYTE PTR[eax]
	cmp bl, transp_col
	je dstY_inc
	and ebx, 0ffh
	invoke DrawPixel, ecx, edi, ebx

dstY_inc:
	inc dstY
	jmp dstY_eval

dstX_inc:
	inc dstX
	jmp dstX_eval                                                  
	

result:
	ret 			; Don't delete this line!!!		
RotateBlit ENDP



END
