;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TEAM SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_team_init:	
	move.w	#$78FF,BG ; put a white background
	
	move.l	#sprite_list,a1	

	jsr		op_prepare_next_sprite	
	move.l	#background+768000,SPRITE_BITMAP(a1)
	move.l	#$0140005E,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#73+264,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr		op_prepare_bitmap	

	; SPRITE LIST FOR THIS PART
	sprite_jagware_logo		.equ (sprite_list+(0*SPRITE_STRUCT_SIZE))
	; END SPRITE LIST FOR THIS PART

	

	move.l	#1,num_sprite		
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	wait_some_frame	#100
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	
	move.l	#background+816640,SPRITE_BITMAP(a1)
	
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	wait_some_frame	#100
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1

	move.l	#background+877440,SPRITE_BITMAP(a1)	

	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	wait_some_frame	#100
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	
	move.w	#$0,BG
	move.l	#game_part_title_init,current_process
	rts
	