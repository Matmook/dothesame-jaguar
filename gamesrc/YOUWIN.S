;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WHEN YOU WIN ;-)	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_you_win_init:	
	;; set repeat sample
   ; move.l    #snd_end-snd_start,-(sp)
    ;move.l    #snd_start,-(sp)
	move.l    #0,-(sp)
	move.l    #0,-(sp)
;; set initial sample
    move.l    #end_wav_win-wav_win,-(sp)
    move.l    #wav_win,-(sp)
;; set sample characteristics (not optimized)
    move.l    #0<<31,d1; 16 bits
    moveq    #8,d2      ; panning = 8
    swap    d2
    lsl.l    #8,d2    ; panning computed
    or.l    d2,d1
    moveq    #64,d2    ; volume = 64
    swap    d2    ; volume computed
    or.l    d2,d1
    move.l    #8000,d2; replay freq = 16000 Hz
    lsl.l    #8,d2
    lsl.l    #4,d2
    move.l    sample_frequency,d0
    divu.w    d0,d2    ; divisor computed
    move.w    d2,d1
    move.l    d1,-(sp)
;; voice 0
    move.l    #4,-(sp)
    jsr    _set_voice
    add.w    #24,sp

	;update score
	;move.l	timeleft_animation,a1
	move.l	#sprite_playtime_timeleft,a1
	clr.l	d1
	move.w	SPRITE_XPOS(a1),d1
	tst.w	d1
	bmi.s	.timeleft_is_negative
	add.l	d1,global_score
.timeleft_is_negative:		
	
	move.l	global_score,d0
	move.l	d0,old_score
	
	; hide todo board on left
	;move.l	todo_board_ptr,a1
	move.l	#sprite_playtime_todoboardshadow,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	
	; show clap clap
	;move.l	clap_clap_animation,a1
	move.l	#sprite_playtime_clapclapl,a1	
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)
	add.w	#132,SPRITE_XPOS(a1)  
	add.w	#148,SPRITE_YPOS(a1) 
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)
	add.w	#148,SPRITE_XPOS(a1)  
	add.w	#144,SPRITE_YPOS(a1) 

	; hide select down
	;move.l	select_sprite_player,a0
	move.l	#sprite_playtime_select,a0
	wait_end_of_animation	a0
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a0)	
	
	; hide score
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1

	; add extra point if you win with some life
	move.l	level_number,d0
	add.l	#1,d0
	move.l	last_level_number,d1	
	cmp.l	d0,d1
	bne.s	.not_the_end_level2	
	move.l	number_of_life,d0
	mulu	#50,d0
	add.l	d0,global_score
.not_the_end_level2:
	
	; update score
	bsr		refresh_score		
	
	; show web score
	move.l	#sprite_playtime_winloose,a1	
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	
	; shut down all tiles
	move.l	#36-1,d0 ; put slide animation on all tiles
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1
.set_win_animation_on_tiles:	
	;add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_tiles_win1,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1	
	wait_some_frame #3	
	dbra	d0,.set_win_animation_on_tiles

	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1

	; check if we reach the last level
	add.l	#1,level_number
	add.l	#72,current_level
before_playing_or_level_change:			
	cmp.l	#0,level_number
	beq		.first_level
	
	move.l	#sprite_playtime_timemark,a1
	wait_end_of_animation	a1
	wait_a_key_press
	
	; hide web score
	move.l	#sprite_playtime_winloose,a1	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	move.l	level_number,d0
	move.l	last_level_number,d1	
	cmp.l	d0,d1
	bne.s	.not_the_end_level	
	move.l	#you_reach_the_end,current_process
	rts
.not_the_end_level:
	
	; hide background
	move.l	#sprite_list,a1	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1	
	
.first_level:
	
	; update score
	bsr		refresh_score

	; change background
	bsr		change_background_picture
	move.l	#sprite_list,a1	
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)	
	
	; load new level
	bsr		load_level	
	
	; put zoom animation on all tiles
	move.l	#36-1,d0
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1
.set_zoom_animation_on_tiles:	
	;add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_tiles_zoom,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1	
	dbra	d0,.set_zoom_animation_on_tiles
	
	bsr		look_for_initial_select_position
	bsr		set_initial_select_position	
	bsr		create_todo_picture
	
	; show todo board and his shadow
	;move.l	todo_board_ptr,a1
	move.l	#sprite_playtime_todoboardshadow,a1
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_right,SPRITE_ANIM_PTR(a1)
	
	; hide clap clap
	;move.l	clap_clap_animation,a1
	move.l	#sprite_playtime_clapclapl,a0
	move.w	#800,SPRITE_XPOS(a0)  
	move.w	#120,SPRITE_YPOS(a0) 
	add.l	#SPRITE_STRUCT_SIZE,a0
	move.w	#800,SPRITE_XPOS(a0)  
	move.w	#120,SPRITE_YPOS(a0) 
	
	; wait the end of the todo board display
	;move.l	todo_board_ptr,a1
	move.l	#sprite_playtime_todoboardshadow,a1	
	wait_end_of_animation	a1
	
	; and then show select
	;move.l	select_sprite_player,a1
	move.l	#sprite_playtime_select,a1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1
	
	; show score
	;move.l	clap_clap_animation,a1
	move.l	#sprite_playtime_score,a1
	;add.l	#SPRITE_STRUCT_SIZE*2,a1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	
	; launch time mark animation
	;move.l	timemark_animation,a1
	move.l	#sprite_playtime_timemark,a1	
	move.l	#animation_timemark_up,SPRITE_ANIM_PTR(a1)
	
	; lauch time decrease
	;move.l	timeleft_animation,a1
	move.l	#sprite_playtime_timeleft,a1	
	;move.w	#99,SPRITE_XPOS(a1)
	move.w	#49,SPRITE_XPOS(a1)
	move.l	#animation_timeleft,SPRITE_ANIM_PTR(a1)
	
	; let's play now
	move.l	#game_part_you_play,current_process
end_game_part_you_win:	
	rts	
	