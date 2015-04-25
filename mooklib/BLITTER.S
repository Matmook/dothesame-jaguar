;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Blitter 68k Manager
; mbarreteau
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; simple bloc copy
; a0 : addess of source bitmap
; a1 : current of destination bitmap
; d0 : bloc size
; d1 : xdest
; d2 : ydest
; d3 : source flag
; d4 : destination flag
; d5 : width
blitter_copy_bloc:
	movem.l d0-d6/a0-a1,-(sp)
	;wait_blitter	d4

	; define source informations
	move.l	a0,A2_BASE		
	;move.l	#PIXEL16|PITCH1|WID4,A2_FLAGS	; Blitter FLAG
	move.l	d3,A2_FLAGS	; Blitter FLAG
	move.l	#0,A2_STEP	
	move.l	#0,A2_PIXEL
	
	; define destination informations
	move.l	a1,A1_BASE
	;move.l	#PIXEL16|PITCH1|WID112,A1_FLAGS	; Blitter FLAG
	move.l	d4,A1_FLAGS	; Blitter FLAG
	
	swap	d2
	move.w	d1,d2
	move.l	d2,A1_PIXEL
	
	move.l	#0,A1_FPIXEL	

	move.l	#0,d1	
	swap	d1
	move.l	d5,d6
	sub.l	d0,d6
	;move.w	#112-4,d1
	move.w	d6,d1
	move.l	d1,A1_STEP	
	
	move.l	#0,A1_FSTEP
	move.l	#0,A1_INC
	move.l	#0,A1_FINC
	
	move.l	d0,d1
	swap	d1
	move.w	d0,d1
	move.l	d1,B_COUNT
	move.l	#UPDA1|UPDA2|LFU_REPLACE|SRCEN,B_CMD	
	wait_blitter	d4

	movem.l 	(sp)+,d0-d6/a0-a1
	rts
_blitter_copy_bloc:

; need blank line for aln