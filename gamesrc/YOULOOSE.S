
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; WHEN YOU LOOSE :-(
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_you_loose_init:	

;; set repeat sample
;   ; move.l    #snd_end-snd_start,-(sp)
;    ;move.l    #snd_start,-(sp)
	move.l    #0,-(sp)
	move.l    #0,-(sp)
;; set initial sample
    move.l    #end_wav_loose-wav_loose,-(sp)
    move.l    #wav_loose,-(sp)
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
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	
	move.l	#sprite_list,a1
	add.l	#SPRITE_STRUCT_SIZE*5,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)	
	

	; show web score
	cmp.l	#0,level_number
	beq.s	.do_not_display_code	
	; update score
	sub.l	#1,level_number
	move.l	old_score,d0
	move.l	d0,global_score
	bsr		refresh_score
	move.l	#sprite_playtime_winloose,a1	
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
.do_not_display_code:
	
	move.l	#36-1,d0 ; put slide animation on all tiles
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1
.set_loose_animation_on_tiles:	
	;add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)	
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#1
	dbra	d0,.set_loose_animation_on_tiles
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1
	
	; show "TRY AGAIN!"
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1
	move.l	#12-1,d0
	move.l	#72,d1
	move.l	#txt_loose,a2
.update_youloose_text:
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
	add.w	#264+112-32-16,SPRITE_YPOS(a1)
	add.w	#16,d1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#2
	dbra	d0,.update_youloose_text
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1
	
	;wait_some_frame	#150
	wait_a_key_press

	move.l	#sprite_playtime_winloose,a1	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)

	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1	
	move.l	#12-1,d0
.hide_youloose_text:
	;add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	add.l	#SPRITE_STRUCT_SIZE,a1
	wait_some_frame	#2
	dbra	d0,.hide_youloose_text
	sub.l	#SPRITE_STRUCT_SIZE,a1
	wait_end_of_animation	a1
	
	move.l	#sprite_list,a1	
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1	
	
	move.l	#game_part_title_init,current_process
	rts
	