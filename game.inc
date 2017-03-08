; #########################################################################
;
;   game.inc - Includes for EECS205 Assignment 4/5
;
;
; #########################################################################

;; Library Definitions
MouseInfo STRUCT
 horiz DWORD ?
 vert  DWORD ?
 buttons DWORD ?
MouseInfo ENDS

MK_CONTROL  = 0008h  ;; The CTRL key is down.
MK_LBUTTON  = 0001h  ;; The left mouse button is down.
MK_MBUTTON  = 0010h  ;; The middle mouse button is down.
MK_RBUTTON  = 0002h  ;; The right mouse button is down.
MK_SHIFT    = 0004h  ;; The SHIFT key is down.
MK_XBUTTON1 = 0020h  ;; The first X button is down.
MK_XBUTTON2 = 0040h  ;; The second X button is down.

;; Library Functions
BlackStarField	PROTO
DrawStr PROTO myStr:PTR BYTE, x:DWORD, y:DWORD, color:DWORD

;; Library Data
EXTERNDEF StarBitmap:EECS205BITMAP
EXTERNDEF MouseStatus:MouseInfo
EXTERNDEF KeyUp:DWORD
EXTERNDEF KeyDown:DWORD
EXTERNDEF KeyPress:DWORD
; EXTERNDEF ArrowBlank:EECS205BITMAP

;; User Defined Functions
GameInit PROTO
GamePlay PROTO
CheckIntersect PROTO oneX:DWORD, oneY:DWORD, oneBitmap:PTR EECS205BITMAP, twoX:DWORD, twoY:DWORD, twoBitmap:PTR EECS205BITMAP 
PressSparks PROTO
Update PROTO
DrawBackground PROTO
Passthrough PROTO pos:DWORD
normalState PROTO
pausedState PROTO
deadState PROTO
finishState PROTO

;; STRUCT
_GAME STRUCT
 currentPos DWORD ?
 position DWORD ?
 timeScore DWORD ?
 bonusObj DWORD ?
 boostTime DWORD ?
 paused DWORD ?
 gameStarted DWORD ?
_GAME ENDS

GAME TYPEDEF _GAME

_Arrow STRUCT
 count DWORD ?
 x  DWORD ?
 y  DWORD ?
 bm DWORD ?
 caught DWORD 0
_Arrow ENDS

Arrow TYPEDEF _Arrow





