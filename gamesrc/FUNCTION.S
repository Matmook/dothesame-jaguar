refresh_score:
	movem.l d0-d4/a0-a2,-(sp)
	
	lea	txt_score,a0
	add.l	#1,a0
	move.l	level_number,d0
;	cmp.l	#0,d0
;	beq.s	.the_first_one
	add.l	#1,d0
;.the_first_one:	
	moveq	#2,d1	; Nombre de chiffres
	jsr	Convert_to_dec_format	
	
	add.l	#3,a0
		
	move.l	global_score,d0
	moveq	#5,d1	; Nombre de chiffres
	jsr	Convert_to_dec_format	
	
	move.l	#txt_score,a2	

	move.l	#police_kromasky,a0
	move.l	#score_context,a1
	move.l	#$00000000,d0
	jsr		font_draw_word
	
	; update webscore
	move.l	#txt_panel,a2	
	move.l	#police_kromasky,a0
	move.l	#panel_context,a1
	move.l	#$00000008,d0
	jsr		font_draw_word	
	
	;compute webscore	

; HERE IS THE WEBCODE GENERATION...REMOVED FROM THE SOURCE	


	move.l	#txt_panel,a2
	add.l	#20,a2	
	move.l	#police_kromasky,a0
	move.l	#panel_context,a1
	move.l	#$00100008,d0
	jsr		font_draw_word
	
	move.l	#txt_panel,a2
	add.l	#40,a2	
	move.l	#police_kromasky,a0
	move.l	#panel_context,a1
	move.l	#$00200008,d0
	jsr		font_draw_word
	
	movem.l (sp)+,d0-d4/a0-a2
	rts
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MOVE SELECT LEFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_select_left:
	movem.l d0-d1/a0-a1,-(sp)
	
	; is there an running animation ?
	;move.l	select_sprite_player,a1
	move.l	#sprite_playtime_select,a1
	cmp.l	#0,SPRITE_ANIM_PTR(a1)
	bne.s	.no_move_left	
	
	; check table border limit
	cmp.w	#0,select_posx_player
	beq.s	.no_move_left
	
	; check if we could go left (if there a picture near us)
	move.l	#current_level,a0 ; current level
	move.l	(a0),a0 ; load current level address
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.w	select_posy_player,d0
	mulu	#6,d0
	move.w	select_posx_player,d1
	subq.w	#1,d1
	add.w	d1,d0
	
	add.l	d0,a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	(a0),d0	
	move.b	6(a0),d1		
	cmp.l	#0,d0
	beq.s	.no_move_left	
	cmp.l	#0,d1
	beq.s	.no_move_left		
	subq.w	#1,select_posx_player		
	move.l	#animation_select_left,SPRITE_ANIM_PTR(a1)	
.no_move_left:
	movem.l (sp)+,d0-d1/a0-a1
	rts
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MOVE SELECT RIGHT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_select_right:
	movem.l d0-d1/a0-a1,-(sp)
	
	; is there an running animation ?
	;move.l	select_sprite_player,a1
	move.l	#sprite_playtime_select,a1	
	cmp.l	#0,SPRITE_ANIM_PTR(a1)
	bne.s	.no_move_right	
	
	; check table border limit
	cmp.w	#4,select_posx_player
	beq.s	.no_move_right
	
	; check if we could go right (if there a picture near us)
	move.l	#current_level,a0 ; current level
	move.l	(a0),a0 ; load current level address
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.w	select_posy_player,d0
	mulu	#6,d0
	move.w	select_posx_player,d1
	addq.w	#2,d1
	add.w	d1,d0
	
	add.l	d0,a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	(a0),d0	
	move.b	6(a0),d1		
	cmp.l	#0,d0
	beq.s	.no_move_right	
	cmp.l	#0,d1
	beq.s	.no_move_right		
	addq.w	#1,select_posx_player		
	move.l	#animation_select_right,SPRITE_ANIM_PTR(a1)	
.no_move_right:
	movem.l (sp)+,d0-d1/a0-a1
	rts	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MOVE SELECT UP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_select_up:
	movem.l d0-d1/a0-a1,-(sp)
	
	; is there an running animation ?
	;move.l	select_sprite_player,a1
	move.l	#sprite_playtime_select,a1	
	cmp.l	#0,SPRITE_ANIM_PTR(a1)
	bne.s	.no_move_up	
	
	; check table border limit
	cmp.w	#0,select_posy_player
	beq.s	.no_move_up
	
	; check if we could go up (if there a picture near us)
	move.l	#current_level,a0 ; current level
	move.l	(a0),a0 ; load current level address
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.w	select_posy_player,d0
	mulu	#6,d0
	move.w	select_posx_player,d1
	subq.w	#6,d1
	add.w	d1,d0
	
	add.l	d0,a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	(a0)+,d0	
	move.b	(a0),d1		
	cmp.l	#0,d0
	beq.s	.no_move_up	
	cmp.l	#0,d1
	beq.s	.no_move_up		
	subq.w	#1,select_posy_player		
	move.l	#animation_select_up,SPRITE_ANIM_PTR(a1)	
.no_move_up:
	movem.l (sp)+,d0-d1/a0-a1
	rts		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MOVE SELECT DOWN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
move_select_down:
	movem.l d0-d1/a0-a1,-(sp)
	
	; is there an running animation ?
	;move.l	select_sprite_player,a1
	move.l	#sprite_playtime_select,a1	
	cmp.l	#0,SPRITE_ANIM_PTR(a1)
	bne.s	.no_move_down	
	
	; check table border limit
	cmp.w	#4,select_posy_player
	beq.s	.no_move_down
	
	; check if we could go down (if there a picture near us)
	move.l	#current_level,a0 ; current level
	move.l	(a0),a0 ; load current level address
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.w	select_posy_player,d0
	mulu	#6,d0
	move.w	select_posx_player,d1
	add.w	#12,d1
	add.w	d1,d0
	
	add.l	d0,a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.b	(a0)+,d0	
	move.b	(a0),d1		
	cmp.l	#0,d0
	beq.s	.no_move_down	
	cmp.l	#0,d1
	beq.s	.no_move_down		
	addq.w	#1,select_posy_player		
	move.l	#animation_select_down,SPRITE_ANIM_PTR(a1)	
.no_move_down:
	movem.l (sp)+,d0-d1/a0-a1
	rts		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GET SELECT POSITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
look_for_initial_select_position:
	movem.l d0-d1/a0,-(sp)
	
	move.l	#current_level,a0 ; current level
	move.l	(a0),a0 ; load current level address
	
	moveq.l	#-1,d0
.check_for_non_null_position:
	add.l	#1,d0
	tst.b	(a0)+
	beq		.check_for_non_null_position
	divu	#6,d0
	move.w	d0,select_posy_player ; the quotient
	swap	d0
	move.w	d0,select_posx_player ; the rest
	
	movem.l (sp)+,d0-d1/a0
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CHANGE BACKGROUND
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
change_background_picture:
	movem.l d0/a0-a1,-(sp)	
	; look for background/tiles association
	move.l	#current_level,a0 ; current level
	move.l	(a0),a0 ; load current level address
	
	moveq.l	#0,d0
.check_for_non_null_position_again:
	move.b	(a0),d0
	tst.b	(a0)+
	beq		.check_for_non_null_position_again

	move.l	#background,a1
	
	cmp.b	#5,d0 ; castle
	blt.s	.end_background_tiles_association
.not_the_first_background:	
	cmp.b	#8,d0
	bge.s	.not_the_second_background
	add.l	#153600,a1
	bra.s	.end_background_tiles_association
.not_the_second_background:	
	cmp.b	#11,d0
	bgt.s	.not_the_fird_background
	add.l	#153600*2,a1
	bra.s	.end_background_tiles_association
.not_the_fird_background:
	cmp.b	#14,d0
	bge.s	.not_the_fift_background
	add.l	#153600*3,a1
	bra.s	.end_background_tiles_association
.not_the_fift_background:
	add.l	#153600*4,a1
.end_background_tiles_association:
	
	move.l	#sprite_list,a0
	move.l	a1,SPRITE_BITMAP(a0)

	movem.l (sp)+,d0/a0-a1
	rts	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; SET SELECT POSITION
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
set_initial_select_position:
	movem.l d0-d1/a0,-(sp)
	
	; move cursor in X
	;move.l	select_sprite_player,a0
	move.l	#sprite_playtime_select,a0
	clr.l	d0
	move.w	select_posx_player,d0 ; get cursor xpos
	mulu	#16,d0
	clr.l	d1
	move.w	scrn_x_origine,d1
	add.w	#140-8,d1
	add		d1,d0
	move.w	d0,SPRITE_XPOS(a0)
	
	; move cursor in Y
	clr.l	d0
	move.w	select_posy_player,d0 ; get cursor xpos	
	mulu	#16,d0
	clr.l	d1
	move.w	scrn_y_origine,d1
	add.w	#64,d1
	add		d1,d0
	;
	add.w	#264,d0
	
	move.w	d0,SPRITE_YPOS(a0)	
	movem.l (sp)+,d0-d1/a0
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ROTATE TILES LEFT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rotate_square_left:
	movem.l d0-d2/a0-a2,-(sp)
	
	; set sprite animation and update main_board_sprite_array
	move.l	#main_board_sprite,a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.w	select_posx_player,d0
	move.w	select_posy_player,d1
	mulu	#6,d1 ; posy*6
	add.l	d1,d0 ; + posx = initial position in array
	move.l	d0,d2 ; save it for updating main_board_tiles
	rol.l	#2,d0 ; initial position divided by 4 for long
	add.l	d0,a0 ; go to first sprite
	
	move.l	#rotate_running_animation,a2 ; do not launch another animation if one is running
	
	; rotate up/left sprite
	move.l	(a0),a1
	move.l	a1,d1 ; we save it (for updating main_board_sprite array)
	move.l	a1,(a2)+
	move.l	#animation_element_down,SPRITE_ANIM_PTR(a1)
	
	; rotate up/right sprite
	move.l	4(a0),a1
	move.l	a1,(a0)
	move.l	a1,(a2)+
	move.l	#animation_element_left,SPRITE_ANIM_PTR(a1)

	; rotate down/right sprite
	move.l	28(a0),a1
	move.l	a1,4(a0)
	move.l	a1,(a2)+
	move.l	#animation_element_up,SPRITE_ANIM_PTR(a1)
	
	; rotate down/left sprite
	move.l	24(a0),a1
	move.l	a1,28(a0)
	move.l	a1,(a2)+
	move.l	#animation_element_right,SPRITE_ANIM_PTR(a1)
	
	; end update main_board_sprite array
	move.l	d1,24(a0)
	
	; do the same with main_board_tiles array
	move.l	#main_board_tiles,a0
	add.l	d2,a0
	move.b	(a0),d1
	move.b	1(a0),(a0)
	move.b	7(a0),1(a0)
	move.b	6(a0),7(a0)	
	move.b	d1,6(a0)
	
	movem.l (sp)+,d0-d2/a0-a2
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ROTATE TILES RIGHT
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rotate_square_right:
	movem.l d0-d2/a0-a2,-(sp)
	
	; set sprite animation and update main_board_sprite_array
	move.l	#main_board_sprite,a0
	moveq.l	#0,d0
	moveq.l	#0,d1
	move.w	select_posx_player,d0
	move.w	select_posy_player,d1
	mulu	#6,d1 ; posy*6
	add.l	d1,d0 ; + posx = initial position in array
	move.l	d0,d2 ; save it for updating main_board_tiles
	rol.l	#2,d0 ; initial position divided by 4 for long
	add.l	d0,a0 ; go to first sprite
	
	move.l	#rotate_running_animation,a2 ; do not launch another animation if one is running
	
	; rotate up/left sprite
	move.l	(a0),a1
	move.l	a1,d1 ; we save it (for updating main_board_sprite array)
	move.l	a1,(a2)+
	move.l	#animation_element_right,SPRITE_ANIM_PTR(a1)
	
	; rotate up/right sprite
	move.l	24(a0),a1
	move.l	a1,(a0)
	move.l	a1,(a2)+
	move.l	#animation_element_up,SPRITE_ANIM_PTR(a1)

	; rotate down/right sprite
	move.l	28(a0),a1
	move.l	a1,24(a0)
	move.l	a1,(a2)+
	move.l	#animation_element_left,SPRITE_ANIM_PTR(a1)
	
	; rotate down/left sprite
	move.l	4(a0),a1
	move.l	a1,28(a0)
	move.l	a1,(a2)+
	move.l	#animation_element_down,SPRITE_ANIM_PTR(a1)
	
	; end update main_board_sprite array
	move.l	d1,4(a0)
	
	; do the same with main_board_tiles array
	move.l	#main_board_tiles,a0
	add.l	d2,a0
	move.b	(a0),d1
	move.b	6(a0),(a0)	
	move.b	7(a0),6(a0)
	move.b	1(a0),7(a0)	
	move.b	d1,1(a0)
	
	movem.l (sp)+,d0-d2/a0-a2
	rts	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; CREATE TODO
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
create_todo_picture:
	movem.l d0-d6/a0-a3,-(sp)

	move.l	#PIXEL16|PITCH1|WID8,d3
	move.l	#PIXEL16|PITCH1|WID64,d4
	move.l	#64,d5
	move.l	#todo_board,a1
	move.l	#current_level,a3 ; current level
	move.l	(a3),a3	
	move.l	#8,d0
	
	moveq.l	#8,d2
	REPT	6
		moveq.l	#0,d1
		REPT	6
			add.l	#8,d1
			moveq	#0,d6
			move.b	(a3)+,d6
			mulu	#128,d6
			add.l	#minielem,d6
			move.l	d6,a0			
			jsr		blitter_copy_bloc
		ENDR
		add.l	#8,d2
	ENDR
	movem.l (sp)+,d0-d6/a0-a3
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; LOAD LEVEL
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
load_level:
	movem.l d0-d6/a0-a4,-(sp)
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1	

	move.l	#main_board_sprite,a3 ; current board
	move.l	#current_level,a4 ; current level
	move.l	#main_board_tiles,a5 ; current board
	move.l	(a4),a4
	add.l	#36,a4
	clr.l	d0
	clr.l	d1
	move.w	scrn_x_origine,d0
	move.w	scrn_y_origine,d1
	add.w	#140+8-8,d0
	add.w	#64+8,d1
	REPT	6
		REPT	6
			;add.l	#SPRITE_STRUCT_SIZE,a1	
			move.l	a1,(a3)+ ; save current sprite
			clr.l	d5
			move.b	(a4),d5
			move.b	(a4)+,(a5)+
			mulu	#512,d5
			add.l	#element,d5			
			move.l	d5,SPRITE_BITMAP(a1)
			move.l	#0,SPRITE_ANIM_PTR(a1) ; clear animation
			move.w	d0,SPRITE_XPOS(a1)  
			move.w	d1,SPRITE_YPOS(a1)  
			add.l	#16,d0
			add.l	#SPRITE_STRUCT_SIZE,a1
		ENDR
		move.w	scrn_x_origine,d0
		add.w	#140+8-8,d0
		add.l	#16,d1
	ENDR
	
	move.l	#rotate_running_animation,a0
	;move.l	first_movable_sprite,a1	
	move.l	#sprite_playtime_1st36tiles,a1
	;add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	a1,(a0)+
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	a1,(a0)+
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	a1,(a0)+
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	a1,(a0)
	
	movem.l (sp)+,d0-d6/a0-a4
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; DO YOU WIN ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
are_you_the_winner:
	movem.l d0/a0-a1,-(sp)
	
	move.l	#main_board_tiles,a0 ; our table
	move.l	#current_level,a1 ; todo table	
	move.l	(a1),a1	
	moveq.l	#0,d1 ; result
	moveq.l	#8,d0 ; 9*4 LONG = 36 tiles
.check_if_src_table_equal_dest_table:	
	cmp.l	(a0)+,(a1)+
	bne.s	.end_check_if_src_table_equal_dest_table
	dbra	d0,.check_if_src_table_equal_dest_table

	moveq.l	#1,d1
.end_check_if_src_table_equal_dest_table:
	movem.l (sp)+,d0/a0-a1
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; ROTATION FINISHED ?
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
is_rotation_finished: ; d0 is the result
	movem.l a0-a1,-(sp)	
	
	moveq.l	#0,d0
	move.l	#rotate_running_animation,a0
	move.l	(a0)+,a1
	add.l	SPRITE_ANIM_PTR(a1),d0
	move.l	(a0)+,a1
	add.l	SPRITE_ANIM_PTR(a1),d0
	move.l	(a0)+,a1
	add.l	SPRITE_ANIM_PTR(a1),d0
	move.l	(a0),a1
	add.l	SPRITE_ANIM_PTR(a1),d0	
;	cmp.l	#0,d0
;	bne.s	.rotation_is_not_finished
;	moveq.l	#0,d0
;.rotation_is_not_finished:	

	movem.l (sp)+,a0-a1
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UPDATE LIFE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
do_life_update:
	movem.l d0-d4/a0-a1,-(sp)	
	
	;move.l	life_animation,a0
	move.l	#sprite_playtime_1stlife,a0		
	moveq.l	#0,d0
	move.l	number_of_life,d0	
	move.l	d0,d1
	moveq.l	#3,d2
	sub.l	d1,d2 ; get lost life
	subq.l	#1,d2
	subq.l	#1,d1
.update_lost_life:
	moveq.l	#0,d3
	move.w	scrn_y_origine,d3
	add.w	#50,d3
	moveq.l	#0,d4
	move.w	SPRITE_YPOS(a0),d4
	cmp.w	d3,d4
	bgt.s	.live_is_already_lost
	move.l	#lifeko,SPRITE_BITMAP(a0)
	move.l	#animation_tiles_win1,SPRITE_ANIM_PTR(a0)
.live_is_already_lost:	
	add.l	#SPRITE_STRUCT_SIZE,a0	
	dbra	d2,.update_lost_life
	cmp.l	#-1,d1
	beq.s	.no_life
.update_current_life:
	move.l	#lifeok,SPRITE_BITMAP(a0)
	add.l	#SPRITE_STRUCT_SIZE,a0
	dbra	d1,.update_current_life	
.no_life:	
	movem.l (sp)+,d0-d4/a0-a1
	rts	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; UPDATE TIMEBAR
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
update_time_bar:
	movem.l d0-d2/a0-a1,-(sp)	
	
	; clear time mark animation
	;move.l	timemark_animation,a1
	move.l	#sprite_playtime_timemark,a0
	move.l	#0,SPRITE_ANIM_PTR(a0)
	
	; we win so we must decrease the time
	moveq.l	#0,d1
	move.w	scrn_y_origine,d1
	add.w	#174,d1 ; minus position 
	
	moveq.l	#0,d0
	;move.l	timemark_animation,a0	
	move.w	SPRITE_YPOS(a0),d0 ; current mark position
	
	clr.l	d2
	move.l	difficulty,d2
		
	sub.l	d0,d1
	cmp.l	d1,d2
	ble.s	.not_over_limit
	move.l	d1,d2
.not_over_limit:
	move.l	#animation_timemark_down,a0	
	move.l	d2,20(a0)
	
	; launch time mark animation
	move.l	#sprite_playtime_timemark,a0
	move.l	#animation_timemark_down,SPRITE_ANIM_PTR(a0)
	
	movem.l (sp)+,d0-d2/a0-a1
	rts		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; MOVE BACKGROUND ON CURVE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;move_background_on_curve:
;	movem.l  a0-a2/d3-d4,-(sp)
;	move.l	#$FF,BG
;	move.l	#sprite_list,a1
;	
;	move.l	Curve_pnt,a2
;	addq.w	#4,a2	; Param par pas de
;					; 4, car X cod‚ sur un
;					; mot et Y cod‚ sur un mot 
;	move.w	#0,SPRITE_XPOS(a1) 
;	move.w	#0,SPRITE_YPOS(a1) 
;	;move.w	scrn_y_origine,SPRITE_YPOS(a1) 
;	moveq.l	#0,d3
;	moveq.l	#0,d4
;	
;	
;	
;	move.w	(a2)+,d3
;	cmp.w	#0,d3
;	bge.s	.x_positiv
;	neg		d3
;.x_positiv:
;	
;	cmp.w	#64,d3
;	blt.s	.x_less_than_64
;	divu.w	#64,d3
;	swap	d3
;.x_less_than_64:
;	
;	move.w	(a2)+,d4
;	cmp.w	#0,d4
;	bge.s	.y_positiv
;	neg		d4
;.y_positiv:	
;	
;	cmp.w	#64,d4
;	blt.s	.y_less_than_64	
;	divu.w	#64,d4
;	swap	d4
;.y_less_than_64:
;	
;	sub.w	d3,SPRITE_XPOS(a1) 
;	sub.w	d4,SPRITE_YPOS(a1) 
;	;add.w	#25,SPRITE_YPOS(a1) 
;	;add.w	#100,SPRITE_YPOS(a1) 
;	
;	
;	cmp.l	#Curve+1440,a2	; Boucle la courbe
;	ble.s	Pas_reboucle
;	lea	Curve,a2
;Pas_reboucle:
;	move.l	a2,Curve_pnt
;	move.l	#00,BG
;	movem.l  (sp)+,a0-a2/d3-d4
;	rts
	