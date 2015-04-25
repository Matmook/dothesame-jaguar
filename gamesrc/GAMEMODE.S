;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; DIFFICULTY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_difficulty_init:	
	move.l	#txt_difficulty,a2

	move.l	#sprite_title_1st76char,a1
	move.l	#76-1,d0
.update_difficulty_text:
	clr.l	d5
	move.b	(a2)+,d5
	sub.l	#32,d5
	mulu	#512,d5
	add.l	#kromaskyfont,d5	
	move.l	d5,SPRITE_BITMAP(a1)
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#2		
	dbra	d0,.update_difficulty_text
	
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1
	
	move.l	#game_part_difficulty_choice,current_process
	
game_part_difficulty_choice:
	jsr		ReadJoypads	; read joypad information
	move.l	joy1cur,d2
	
	btst	#FIRE_A,d2
	beq.b	.not_easy	
	move.l	#30,difficulty	
	move.l	#levelstarteasy,current_level	
	move.l	#levelstarteasy,first_level	
	move.l	#MAX_EASY_LEVEL,last_level_number
	bra.s	.end_game_part_difficulty_choice
.not_easy:
	btst	#FIRE_B,d2
	beq.b	.not_medium	
	move.l	#30,difficulty		
	move.l	#levelstartmedium,current_level	
	move.l	#levelstartmedium,first_level		
	move.l	#MAX_MEDIUM_LEVEL,last_level_number
	bra.s	.end_game_part_difficulty_choice
.not_medium:
	btst	#FIRE_C,d2
	beq.b	.not_hard
	;move.w	#30,difficulty		
	move.l	#66,difficulty	
	move.l	#levelstarthard,current_level	
	move.l	#levelstarthard,first_level	
	move.l	#MAX_HARD_LEVEL,last_level_number	
	bra.s	.end_game_part_difficulty_choice
.not_hard:	
	btst	#OPTION,d2
	beq.b	.not_option	
	move.l	#game_part_title_init,current_process
	bra.s	.return_to_title_screen
.not_option:
	rts
.end_game_part_difficulty_choice:
	;move.l	#game_part_before_playing_init,current_process
	move.l	#game_part_how_to_play_init,current_process
.return_to_title_screen:		
	clr.l	d1

	move.l	#sprite_title_1st76char,a1
	move.l	#76-1,d0	
.create_initial_76_tiles_again2:		
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#2
	dbra	d0,.create_initial_76_tiles_again2	
		
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1	
	

	;move.l	#sprite_title_background,a1
	;move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)	

	move.l	#sprite_title_1st76char,a1
	move.l	#76-1,d0	
.create_initial_76_tiles_twice:		
	add.w	#100,SPRITE_YPOS(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	dbra	d0,.create_initial_76_tiles_twice
	
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
	
	move.l	#0,background_process	
	rts
	