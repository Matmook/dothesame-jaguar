
	; police definition
	move.l		#police_8x8,a0
	move.l		#font8x8,(a0) ;FONT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID8,FONT_BLITTER_FLAG(a0)
	move.l		#$00080008,FONT_BCOUNT(a0)
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)
	
	; police definition
	move.l		#police_kromasky,a0
	move.l		#kromaskyfont,(a0) ;FONT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID16,FONT_BLITTER_FLAG(a0)
	move.l		#$00100010,FONT_BCOUNT(a0)	
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)
	
	; police context definition
	move.l		#police_context,a0
	move.l		#text_bitmap,(a0) ; FONT_CONTEXT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID320,FONT_CONTEXT_BLITTER_FLAG(a0)
	move.l		#(320-16),FONT_CONTEXT_NEXTLINE(a0)	
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)

	; police webscore definition
	move.l		#panel_context,a0
	move.l		#background+768000,(a0) ; FONT_CONTEXT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID320,FONT_CONTEXT_BLITTER_FLAG(a0)
	move.l		#(320-16),FONT_CONTEXT_NEXTLINE(a0)		
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)
	
	; police context definition
	move.l		#score_context,a0
	move.l		#score_bitmap,(a0) ; FONT_CONTEXT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID192,FONT_CONTEXT_BLITTER_FLAG(a0)
	move.l		#(192-16),FONT_CONTEXT_NEXTLINE(a0)		
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)

	; now do some depacking (depack earth and logo)
	jsr		Install_unpack_rout
	
	move.l	#lz77_backg,a0
	move.l	#background,a1
	moveq	#0,d0
	jsr		Unpack	

	
	; compute cos, sin and curve (Thanks GT!)
	;jsr		compute_cos_and_sin_table
	;jsr		compute_curve
	
	move.l	#$014000F0,d0 ; center a 320x240 window on screen
	jsr		scrn_compute_visual_center
	
	.include "gamesrc/animdata.s" ; prepare all animation (in a separate file 'cause it's big).
	
	; always start with game_part_team_init
	move.l	#game_part_team_init,current_process 
	