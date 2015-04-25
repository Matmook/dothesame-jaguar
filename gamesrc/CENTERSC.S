;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; CENTER SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_center_screen_init:	

	; hide all
	
	move.l	#sprite_title_dtslogo,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)	
	move.l	#sprite_title_lowmask,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	move.l	#sprite_title_text,a1	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	move.l	#sprite_title_start,a1	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)	
	move.l	#sprite_title_greetings,a1	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)	
	
	wait_end_of_animation	a1	
	
	; just the background
	move.l	#1,num_sprite
	
	wait_some_frame	#12
	
	move.l		#lz77_backg,a0
	move.l		#30720-1,d0
.clearlz77:
	move.l		#0,(a0)+
	dbra		d0,.clearlz77

	;create center text
	move.l		#howtoup_context,a0
	move.l		#lz77_backg,(a0) ; FONT_CONTEXT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID320,FONT_CONTEXT_BLITTER_FLAG(a0)
	move.l		#(320-16),FONT_CONTEXT_NEXTLINE(a0)		
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)	

	; up bloc
	move.l	#txt_center,a2	
	move.l	#police_kromasky,a0
	move.l	#howtoup_context,a1
	move.l	#$00000000,d0
	jsr		font_draw_word
	
	move.l	#sprite_list,a1		
	add.l	#SPRITE_STRUCT_SIZE,a1
	
	; upper bloc
	jsr		op_prepare_next_sprite	
	move.l	#lz77_backg,SPRITE_BITMAP(a1)
	move.l	#$01400010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#264+112,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	
	move.l	#2,num_sprite
	wait_end_of_animation	a1
	
	move.l	#30,multi_purpose_1
	
	move.l	#game_part_center_screen,current_process
game_part_center_screen:	
	move.l	joy1cur,d2
	
	move.l	multi_purpose_1,d3
		
	btst	#JOY_LEFT,d2
	beq.b	.not_left
	cmp.l	#0,d3
	beq.s	.not_left
	sub.l	#1,d3
	move.l	#sprite_list+SPRITE_STRUCT_SIZE,a1		
	sub.w	#1,SPRITE_XPOS(a1)
.not_left:
	btst	#JOY_RIGHT,d2
	beq.b	.not_right
	cmp.l	#60,d3
	beq.s	.not_right
	add.l	#1,d3
	move.l	#sprite_list+SPRITE_STRUCT_SIZE,a1		
	add.w	#1,SPRITE_XPOS(a1)
.not_right:
	btst	#FIRE_B,d2
	beq.b	.not_B
	move.l	#0,joy1cur
	sub.l	#30,d3
	add.w	d3,scrn_x_origine
	move.l	#game_part_title_init,current_process
	wait_some_frame	#12
	rts
.not_B:	
	move.l	d3,multi_purpose_1
	
	rts
	