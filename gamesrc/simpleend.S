you_reach_the_end:
	;move.l	life_animation,a1
	move.l	#sprite_playtime_1stlife,a1	
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	
	;move.l	timemark_animation,a1
	move.l	#sprite_playtime_timemark,a1
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)	
	sub.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)	
		
	;move.l	select_sprite_player,a1
	move.l	#sprite_playtime_select,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	;move.l	todo_board_ptr,a1
	move.l	#sprite_playtime_todoboardshadow,a1	
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	sub.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	
	move.l	#sprite_list,a1
	add.l	#SPRITE_STRUCT_SIZE*5,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)	
	
	move.l	#18-1,d0 ; put slide animation on all tiles
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1
.set_loose_animation_on_tiles:	
	;add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)	
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1	
	wait_some_frame	#1
	dbra	d0,.set_loose_animation_on_tiles
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1
	
	; show "YOU WIN!"
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1			
	move.l	#12-1,d0
	move.l	#72,d1
	move.l	#txt_win,a2
.update_youwin_text:
	;add.l	#SPRITE_STRUCT_SIZE,a1
	clr.l	d5
	move.b	(a2)+,d5
	sub.l	#32,d5
	mulu	#512,d5
	add.l	#kromaskyfont,d5	
	move.l	d5,SPRITE_BITMAP(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	
	move.w	scrn_y_origine,SPRITE_YPOS(a1)
	add.w	d1,SPRITE_XPOS(a1)		
	add.w	#264+112,SPRITE_YPOS(a1)
	add.w	#16,d1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#2
	dbra	d0,.update_youwin_text
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1
	
	;wait_some_frame	#300
	wait_a_key_press
	
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1		
	move.l	#12-1,d0
.hide_youwin_text:
	;add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#2
	dbra	d0,.hide_youwin_text
	wait_end_of_animation	a1
	
	move.l	#game_part_title_init,current_process

	rts
	