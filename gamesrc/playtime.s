;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; WHEN YOU PLAY
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_you_play:
	; check time mark and life managment
	moveq.l	#0,d1
	move.w	scrn_y_origine,d1
	add.w	#174-120,d1
	;move.l	timemark_animation,a1
	move.l	#sprite_playtime_timemark,a1	
	move.w	SPRITE_YPOS(a1),d0
	cmp.w	d1,d0
	bne.s	.we_have_got_time_and_life
	; we loose a life
	add.w	#120,d1
	move.w	d1,SPRITE_YPOS(a1)	
	subq.l	#1,number_of_life
	bsr		do_life_update
	tst.l	number_of_life
	bne.s	.we_have_got_time_and_life	
	move.l	#game_part_you_loose_init,current_process
	rts
.we_have_got_time_and_life:	
	
	; joypad managment
	move.l	joy1cur,d2
	
;	btst	#PAUSE,d2
;	beq.b	.game_part_you_play_no_pause
;	bchg	#0,game_paused
;	bsr		sebrmv_sound_player_play_pause_player
	;wait_some_frame	#15
	
;	move.l	#game_part_paused_init,current_process
;	bra		end_game_part_you_play
.game_part_you_play_no_pause:
	
	bsr		is_rotation_finished
	cmp.l	#0,d0 ;verify there's not a running animation
	bne.s	check_cross_key

	bsr		are_you_the_winner ; do you win ?
	cmp.b	#1,d1
	bne.s	.end_are_you_the_winner	
	
	; you are a winner
	bsr		update_time_bar		
	
	move.l	#game_part_you_win_init,current_process  
	bra.s		end_game_part_you_play
.end_are_you_the_winner:
	
.game_part_you_play_check_key_A:
	btst	#FIRE_A,d2
	beq.b	.game_part_you_play_check_key_B	
	bsr		rotate_square_right
	bra.s	end_check_pad
.game_part_you_play_check_key_B:
	btst	#FIRE_B,d2
	beq.b	.game_part_you_play_check_key_Option	
	bsr		rotate_square_left
	bra.s	end_check_pad
.game_part_you_play_check_key_Option:
	btst	#KEY_STAR,d2
	beq.b	check_cross_key
	btst	#KEY_HASH,d2
	beq.b	check_cross_key	
	move.l	#game_part_you_loose_init,current_process
	rts
	;;;;testing
check_cross_key:
	;move.l	select_sprite_player,a0
	move.l	#sprite_playtime_select,a0
	cmp.l	#0,SPRITE_ANIM_PTR(a0)
	bne.s	end_check_pad	
.game_part_you_play_check_key_LEFT:
	btst	#JOY_LEFT,d2
	beq.b	.game_part_you_play_check_key_RIGHT
	bsr		move_select_left
	bra.s	end_check_pad
.game_part_you_play_check_key_RIGHT:
	btst	#JOY_RIGHT,d2
	beq.b	.game_part_you_play_check_key_UP
	bsr		move_select_right
	bra.s	end_check_pad
.game_part_you_play_check_key_UP:
	btst	#JOY_UP,d2
	beq.b	.game_part_you_play_check_key_DOWN
	bsr		move_select_up
	bra.s	end_check_pad
.game_part_you_play_check_key_DOWN:
	btst	#JOY_DOWN,d2
	beq.b	end_check_pad		
	bsr		move_select_down
end_check_pad:
end_game_part_you_play:
	rts
