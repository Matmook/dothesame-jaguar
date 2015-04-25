; a0 : addess of font struct
; a1 : addess of font context struct
; a2 : address of texte
; d0 : ydest / xdest
font_draw_word:
	movem.l 	d0-d2/a0-a2,-(sp)

.draw_char:	
	; define source informations
	move.l	(a0),A2_BASE			; FONT_BITMAP(a0)
	move.l	FONT_BLITTER_FLAG(a0),A2_FLAGS	; ex : #PIXEL16|PITCH1|WID8
	move.l	#0,A2_STEP		
	; define destination informations
	move.l	(a1),A1_BASE	; FONT_CONTEXT_BITMAP(a1)
	move.l	FONT_CONTEXT_BLITTER_FLAG(a1),A1_FLAGS	; ex : #PIXEL16|PITCH1|WID320			
	
	move.l	#0,A1_FPIXEL		
	move.l	FONT_CONTEXT_NEXTLINE(a1),A1_STEP

	move.l	#0,A1_FSTEP
	move.l	#0,A1_INC
	move.l	#0,A1_FINC	
	
	move.l	FONT_BCOUNT(a0),B_COUNT	
	move.l	FONT_BCOUNT(a0),d2	
	
	clr.l	d1
	move.b	(a2)+,d1
	cmp.b	#13,d1					; is there a Carrier Return chr(13)
	beq.s	.no_more_char
	sub.w	FONT_CONTEXT_CHAR_PATCH(a1),d1					; char patch
	mulu	d2,d1
	swap	d1	
	
	move.l	d1,A2_PIXEL
	move.l	d0,A1_PIXEL	
	move.l	#UPDA1|UPDA2|LFU_REPLACE|SRCEN,B_CMD	

	add.w	d2,d0
	bra	.draw_char
.no_more_char	:
	movem.l 	(sp)+,d0-d2/a0-a2
	rts
_font_draw_word:

