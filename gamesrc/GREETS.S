;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; GREETINGS
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_greetings_init:	
	clr.l	d1
	move.l	#sprite_title_1st76char,a1
	move.l	#76-1,d0	
.create_initial_76_tiles:		
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	add.l	#SPRITE_STRUCT_SIZE,a1	
	dbra	d0,.create_initial_76_tiles	
	
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1

	wait_some_frame_or_exit	#50,exit_greetings_part
	
	clr.l	d1
	move.l	#sprite_title_1st76char,a1
	move.l	#76-1,d0	
.create_initial_76_tiles_again:		
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#2
	dbra	d0,.create_initial_76_tiles_again	
	
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1

go_next_or_first_greetings:
	move.l	#sprite_title_1st76char,a1
	move.l	#76-1,d0
.update_greetings_text:
	clr.l	d5
	move.b	(a2)+,d5
	sub.l	#32,d5
	mulu	#512,d5
	add.l	#kromaskyfont,d5	
	move.l	d5,SPRITE_BITMAP(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	dbra	d0,.update_greetings_text
	
	move.l	#txt_greetings,a3
	add.l	#40*19,a3
	cmp.l	a2,a3
	beq.s	end_greetings	
	;move.l	#game_part_greetings_init,current_process
	;rts
	bra		game_part_greetings_init
	
exit_greetings_part:	
	move.l	#sprite_title_1st76char,a1
	move.l	#76-1,d0
.hide_greetings_text:
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	dbra	d0,.hide_greetings_text
	
end_greetings:	

	move.l	#sprite_title_start,a1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)

	move.l	#sprite_title_dtslogo,a1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	move.l	#game_part_title,current_process
	rts
	