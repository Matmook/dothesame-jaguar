game_part_how_to_play_init:
	; just the background
	move.l	#1,num_sprite
	
	wait_some_frame	#12
	
	move.l		#lz77_backg,a0
	move.l		#30720-1,d0
.clearlz77:
	move.l		#0,(a0)+
	dbra		d0,.clearlz77
	
	move.l		#howtoup_context,a0
	move.l		#lz77_backg,(a0) ; FONT_CONTEXT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID320,FONT_CONTEXT_BLITTER_FLAG(a0)
	move.l		#(320-8),FONT_CONTEXT_NEXTLINE(a0)		
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)	

	move.l		#howtodown_context,a0
	move.l		#lz77_backg+30720,(a0) ; FONT_CONTEXT_BITMAP(a0)
	move.l		#PIXEL16|PITCH1|WID320,FONT_CONTEXT_BLITTER_FLAG(a0)
	move.l		#(320-8),FONT_CONTEXT_NEXTLINE(a0)		
	move.w		#32,FONT_CONTEXT_CHAR_PATCH(a0)	
	
	; up bloc
	move.l	#5-1,d2
	move.l	#0,d3
	move.l	#txt_goal_up,a2	
.drawn_blocup:	
	move.l	#police_8x8,a0
	move.l	#howtoup_context,a1
	move.l	d3,d0
	swap	d0	
	jsr		font_draw_word
	add.l	#41,a2	
	add.l	#10,d3
	dbra	d2,.drawn_blocup

	; down bloc
	move.l	#5-1,d2
	move.l	#0,d3
	move.l	#txt_goal_down,a2	
.drawn_blocdw:	
	move.l	#police_8x8,a0
	move.l	#howtodown_context,a1
	move.l	d3,d0
	swap	d0	
	jsr		font_draw_word
	add.l	#41,a2	
	add.l	#10,d3
	dbra	d2,.drawn_blocdw
	
	move.l	#sprite_list,a1		
	add.l	#SPRITE_STRUCT_SIZE,a1
	
	; create "HOW TO PLAY ?"
	move.l	#13-1,d0	
	move.l	#56,d1
	move.l	#0,d2
.create_how_to_play_tiles:		
	jsr		op_prepare_next_sprite			
	clr.l	d5
	add.l	#kromaskyfont,d5	
	move.l	d5,SPRITE_BITMAP(a1)
	move.l	#$00100010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	d1,SPRITE_XPOS(a1)  	
	add.w	d2,SPRITE_YPOS(a1)  
	add.w	#264+12+16,SPRITE_YPOS(a1)  
	move.l	a1,a0	
	jsr	op_prepare_bitmap
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	add.l	#16,d1
	dbra	d0,.create_how_to_play_tiles	
	
	; upper bloc
	jsr		op_prepare_next_sprite	
	move.l	#lz77_backg,SPRITE_BITMAP(a1)
	move.l	#$01400030,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#264+52+8,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	
	; lower bloc
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite	
	move.l	#lz77_backg+30720,SPRITE_BITMAP(a1)
	move.l	#$01400030,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#264+200-16-8,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	
	; create sample sprites	
	move.l	#14-1,d0		
.create_sample_tiles:		
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite			
	move.l	#element+512,SPRITE_BITMAP(a1)
	move.l	#$00100010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 		
	add.w	#264+12+16,SPRITE_YPOS(a1)  	
	move.l	a1,a0	
	jsr	op_prepare_bitmap
	;move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
		
	dbra	d0,.create_sample_tiles
	
	; create mask
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite	
	move.l	#background+768000,SPRITE_BITMAP(a1)
	move.l	#$01400032,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+112,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	
	move.l	#31,num_sprite
	
	; SPRITE LIST FOR THIS PART
	sprite_howto_background	.equ (sprite_list+(0*SPRITE_STRUCT_SIZE))	
	sprite_howto_howtoplay	.equ (sprite_list+(1*SPRITE_STRUCT_SIZE))
	sprite_howto_blocup		.equ (sprite_list+(14*SPRITE_STRUCT_SIZE))
	sprite_howto_blocdown	.equ (sprite_list+(15*SPRITE_STRUCT_SIZE))
	sprite_howto_sample		.equ (sprite_list+(16*SPRITE_STRUCT_SIZE))
	sprite_howto_lowmask	.equ (sprite_list+(30*SPRITE_STRUCT_SIZE))
	; END SPRITE LIST FOR THIS PART
	
	move.l	#txt_how_to_play,a2
	move.l	#sprite_howto_howtoplay,a1
	move.l	#13-1,d0
.create_how_to_play_text:
	clr.l	d5
	move.b	(a2)+,d5
	sub.l	#32,d5
	mulu	#512,d5
	add.l	#kromaskyfont,d5	
	move.l	d5,SPRITE_BITMAP(a1)
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	add.l	#SPRITE_STRUCT_SIZE,a1
	dbra	d0,.create_how_to_play_text
	
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1
	
	; center sample
	move.l	#sprite_howto_sample,a1
	add.l	#5*SPRITE_STRUCT_SIZE,a1
	move.l	#element+(1*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264,SPRITE_YPOS(a1) 
	add.w	#72+24+48,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(2*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264,SPRITE_YPOS(a1) 
	add.w	#72+24+16+48,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part

	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(3*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+16,SPRITE_YPOS(a1) 
	add.w	#72+24+48,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(4*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+16,SPRITE_YPOS(a1) 
	add.w	#72+24+16+48,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#50,exit_howto_part
	
	; left sample
	move.l	#sprite_howto_sample,a1
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(1*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264,SPRITE_YPOS(a1) 
	add.w	#72+24,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(2*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264,SPRITE_YPOS(a1) 
	add.w	#72+24+16,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(3*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+16,SPRITE_YPOS(a1) 
	add.w	#72+24,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(4*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+16,SPRITE_YPOS(a1) 
	add.w	#72+24+16,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#50,exit_howto_part
	
	;A
	move.l	#sprite_howto_sample,a1
	move.l	#kromaskyfont+(34*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+8,SPRITE_YPOS(a1) 
	add.w	#72,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	
	REPT	5
	wait_some_frame_or_exit	#10,exit_howto_part
	move.l	#kromaskyfont,SPRITE_BITMAP(a1)
	wait_some_frame_or_exit	#10,exit_howto_part
	move.l	#kromaskyfont+(34*512),SPRITE_BITMAP(a1)
	ENDR
	
	;rotate
	move.l	#sprite_howto_sample,a1
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_down,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_left,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_right,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	
	; right sample
	move.l	#sprite_howto_sample,a1
	add.l	#9*SPRITE_STRUCT_SIZE,a1
	move.l	#element+(1*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264,SPRITE_YPOS(a1) 
	add.w	#72+120,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(2*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264,SPRITE_YPOS(a1) 
	add.w	#72+120+16,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(3*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+16,SPRITE_YPOS(a1) 
	add.w	#72+120,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#2,exit_howto_part
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#element+(4*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+16,SPRITE_YPOS(a1) 
	add.w	#72+120+16,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame_or_exit	#50,exit_howto_part
	
	;A
	move.l	#sprite_howto_sample,a1
	add.l	#13*SPRITE_STRUCT_SIZE,a1
	move.l	#kromaskyfont+(33*512),SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#128+264+8,SPRITE_YPOS(a1) 
	add.w	#72+120+40,SPRITE_XPOS(a1) 
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	
	REPT	5
	wait_some_frame_or_exit	#10,exit_howto_part
	move.l	#kromaskyfont,SPRITE_BITMAP(a1)
	wait_some_frame_or_exit	#10,exit_howto_part
	move.l	#kromaskyfont+(33*512),SPRITE_BITMAP(a1)
	ENDR
	
	;rotate
	move.l	#sprite_howto_sample,a1
	add.l	#9*SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_right,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_down,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_up,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_element_left,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	
	wait_a_key_press

exit_howto_part:	
	move.l	#sprite_howto_blocup,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	move.l	#sprite_howto_howtoplay,a1
	move.l	#13-1,d0
.hide_how_to_play_text:
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	add.l	#SPRITE_STRUCT_SIZE,a1
	dbra	d0,.hide_how_to_play_text
	
	move.l	#sprite_howto_blocdown,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	move.l	#sprite_howto_sample,a1
	move.l	#14-1,d0
.hide_sample_text:
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	add.l	#SPRITE_STRUCT_SIZE,a1
	dbra	d0,.hide_sample_text	
	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	move.l	#sprite_title_background,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	wait_end_of_animation	a1
	
	move.l	#game_part_before_playing_init,current_process
	rts
	