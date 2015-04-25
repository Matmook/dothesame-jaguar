;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;	
; BEFORE PLAYING
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_before_playing_init:
	jsr	op_create_dummy_list
	wait_some_frame	#25

	move.l	#lz77_backg,a0
	move.l	#lz77_backg_end,a1	
.clear_whole_z77_backg:	
	move.l	#0,(a0)+
	cmp.l	a0,a1
	bne.s	.clear_whole_z77_backg	
	
	lea		module2,a1
	jsr		sebrmv_sound_player_run_player	
	st	use_music
		
	; reset animation reapeat counter
	move.l	#animation_dts,a1
	move.l	#4-1,20(a1)
	move.l	#4-1,44(a1)
	move.l	#4-1,68(a1)
	move.l	#4-1,92(a1)
	move.l	#4-1,116(a1)
	move.l	#4-1,140(a1)
	
	move.l	#animation_dts_shadow,a1
	move.l	#4-1,20(a1)
	move.l	#4-1,44(a1)
	move.l	#4-1,68(a1)
	move.l	#4-1,92(a1)
	move.l	#4-1,116(a1)
	move.l	#4-1,140(a1)

	move.l	#animation_jagware,a1
	move.l	#16-1,20(a1)
	move.l	#16-1,36(a1)
	
	
;	move.l	#animation_element_left,a1
;	move.l	#16-1,20(a1)
;	move.l	#animation_element_right,a1
;	move.l	#16-1,20(a1)
;	move.l	#animation_element_up,a1
;	move.l	#16-1,20(a1)
;	move.l	#animation_element_down,a1
;	move.l	#16-1,20(a1)
	

	move.l	#animation_select_left,a1
	move.l	#8-1,20(a1)
	move.l	#animation_select_right,a1
	move.l	#8-1,20(a1)
	move.l	#animation_select_up,a1
	move.l	#8-1,20(a1)
	move.l	#animation_select_down,a1
	move.l	#8-1,20(a1)
	; end reset animation reapeat counter	
	
	; clear text bitmap
	move.l	#police_kromasky,a0
	move.l	#police_context,a1
	move.l	#txt_empty,a2
	move.l	#$00000000,d0
	jsr		font_draw_word		
	
	; create dts shadow
	move.l	#dts_shadow,a0
	move.l	#3720/2,d0	
.draw_dts_shadow:	
	;move.l	#$110F110F,(a0)+
	move.l	#$B0FFB0FF,(a0)+
	dbra	d0,.draw_dts_shadow

	move.l	#todo_board_shadow,a0
	move.l	#6272/2,d0	
.draw_todo_board_shadow:	
	;move.l	#$110F110F,(a0)+
	move.l	#$B0FFB0FF,(a0)+
	dbra	d0,.draw_todo_board_shadow	
	
	; create border (user_board)
	move.l	#4,d0
	move.l	#0,d1
	move.l	#0,d2
	move.l	#PIXEL16|PITCH1|WID4,d3
	move.l	#PIXEL16|PITCH1|WID112,d4
	move.l	#112,d5
	move.l	#user_board,a1
	
	move.l	#border,a0
	jsr		blitter_copy_bloc	

	move.l	#border+(4*4*2),a0
	move.l	#0,d2
	REPT	26
		add.l	#4,d1
		jsr		blitter_copy_bloc			
	ENDR
	
	add.l	#4,d1
	move.l	#border+(3*4*4*2),a0
	jsr		blitter_copy_bloc	
	
	move.l	#border+(2*4*4*2),a0
	move.l	#4,d2
	REPT	26
		move.l	#0,d1
		jsr		blitter_copy_bloc	
		move.l	#108,d1
		jsr		blitter_copy_bloc	
		add.l	#4,d2
	ENDR
	
	move.l	#border+(4*4*4*2),a0
	move.l	#0,d1
	jsr		blitter_copy_bloc
	
	move.l	#border+(4*4*2),a0
	REPT	26
		add.l	#4,d1
		jsr		blitter_copy_bloc		
	ENDR
	
	add.l	#4,d1
	move.l	#border+(5*4*4*2),a0
	jsr		blitter_copy_bloc
	
	; create border (todo_board)
	move.l	#4,d0
	move.l	#0,d1
	move.l	#0,d2
	move.l	#PIXEL16|PITCH1|WID4,d3
	move.l	#PIXEL16|PITCH1|WID64,d4
	move.l	#64,d5
	move.l	#todo_board,a1
	
	move.l	#border,a0
	jsr		blitter_copy_bloc	

	move.l	#border+(4*4*2),a0
	move.l	#0,d2
	REPT	14
		add.l	#4,d1
		jsr		blitter_copy_bloc			
	ENDR
	
	add.l	#4,d1
	move.l	#border+(3*4*4*2),a0
	jsr		blitter_copy_bloc	
	
	move.l	#border+(2*4*4*2),a0
	move.l	#4,d2
	REPT	14
		move.l	#0,d1
		jsr		blitter_copy_bloc	
		move.l	#60,d1
		jsr		blitter_copy_bloc	
		add.l	#4,d2
	ENDR
	
	move.l	#border+(4*4*4*2),a0
	move.l	#0,d1
	jsr		blitter_copy_bloc
	
	move.l	#border+(4*4*2),a0
	REPT	14
		add.l	#4,d1
		jsr		blitter_copy_bloc		
	ENDR
	
	add.l	#4,d1
	move.l	#border+(5*4*4*2),a0
	jsr		blitter_copy_bloc	
	
	move.l	#sprite_list,a1	

	; background
	jsr		op_prepare_next_sprite
	move.l	#background,SPRITE_BITMAP(a1)
	move.l	#$014000F0,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#264,SPRITE_YPOS(a1)
	move.l	a1,a0
	jsr	op_prepare_bitmap		
	
	; do the same shadow
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#dts_shadow,SPRITE_BITMAP(a1)
	move.l	#$003C001D,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_YPOS(a1) 
	add.w	#52,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#145,SPRITE_YPOS(a1)  		
	move.l	a1,a0
	jsr	op_prepare_bitmap
	move.l	#animation_dts_shadow,SPRITE_ANIM_PTR(a1)
	ori.l	#O_RMW,SPRITE_OBJECT_2NDPH(a1)
	
	
	; do the same logo
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#dts,SPRITE_BITMAP(a1)
	move.l	#$00400020,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_YPOS(a1) 
	add.w	#50,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#144,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap		
	move.l	#animation_dts,SPRITE_ANIM_PTR(a1)
	
	; jagware logo
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#jagware,SPRITE_BITMAP(a1)
	move.l	#$00400011,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_YPOS(a1) 
	add.w	#272-8,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#205,SPRITE_YPOS(a1)  
	move.l	a1,a0
	jsr	op_prepare_bitmap
	move.l	#animation_jagware,SPRITE_ANIM_PTR(a1)
	
	; text window
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#text_bitmap,SPRITE_BITMAP(a1)
	move.l	#$01400020,SPRITE_WIDTH_HEIGHT(a1)	
	move.w	scrn_x_origine,SPRITE_YPOS(a1) 
	add.w	#160,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#20,SPRITE_YPOS(a1)  
	move.l	a1,a0
	jsr	op_prepare_bitmap		
	
	; user board
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#user_board,SPRITE_BITMAP(a1)
	move.l	#$00700070,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#140-8,SPRITE_XPOS(a1)  
	add.w	#64,SPRITE_YPOS(a1)	
	move.l	a1,a0
	jsr	op_prepare_bitmap	
	
	; todo board
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#todo_board_shadow,SPRITE_BITMAP(a1)
	move.l	#$00380038,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,d0
	add.w	#30,d0
	move.w	d0,SPRITE_XPOS(a1) 
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#22,SPRITE_YPOS(a1)
	move.l	a1,a0
	;move.l	a1,todo_board_ptr
	jsr	op_prepare_bitmap	
	;sub.w	#120,d0
	sub.w	#145,d0
	move.w	d0,SPRITE_XPOS(a1)	
	ori.l	#O_RMW,SPRITE_OBJECT_2NDPH(a1)
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#todo_board,SPRITE_BITMAP(a1)
	move.l	#$00400040,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,d0
	add.w	#30,d0
	move.w	d0,SPRITE_XPOS(a1) 
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#18,SPRITE_YPOS(a1)
	move.l	a1,a0
	;move.l	a1,todo_board_ptr
	jsr	op_prepare_bitmap	
	;sub.w	#120,d0
	sub.w	#149,d0
	move.w	d0,SPRITE_XPOS(a1)	
	
	
	
	; 36 tiles
	;move.l	a1,first_movable_sprite
	move.l	#36-1,d0
.create_initial_36_tiles:	
	add.l	#SPRITE_STRUCT_SIZE,a1	
	jsr		op_prepare_next_sprite
	move.l	#element,SPRITE_BITMAP(a1) ; all is black
	move.l	#$00100010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	#600,SPRITE_XPOS(a1)  
	move.w	#600,SPRITE_YPOS(a1)  			
	move.l	a1,a0
	jsr	op_prepare_bitmap
	dbra	d0,.create_initial_36_tiles

	; time bar
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#timebar,SPRITE_BITMAP(a1)
	move.l	#$000C007B,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#284+149-8,SPRITE_XPOS(a1)  	
	add.w	#60,SPRITE_YPOS(a1)	
	move.l	a1,a0
	jsr	op_prepare_bitmap

	; time mark
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#timemark,SPRITE_BITMAP(a1)
	move.l	#$00100010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#272+149-8,SPRITE_XPOS(a1)
	;add.w	#149,SPRITE_XPOS(a1)	
	add.w	#174,SPRITE_YPOS(a1)	
	move.l	a1,a0
	jsr	op_prepare_bitmap	
	;move.l	a1,timemark_animation	

	; life
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#lifeok,SPRITE_BITMAP(a1)
	move.l	#$00100010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#284-18-8,SPRITE_XPOS(a1)  
	add.w	#149,SPRITE_XPOS(a1)
	add.w	#4+8,SPRITE_YPOS(a1)	
	move.l	a1,a0
	jsr	op_prepare_bitmap	
	;move.l	a1,life_animation

	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#lifeok,SPRITE_BITMAP(a1)
	move.l	#$00100010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#284-18+16-8,SPRITE_XPOS(a1)
	add.w	#149,SPRITE_XPOS(a1)	
	add.w	#4+8,SPRITE_YPOS(a1)	
	move.l	a1,a0
	jsr	op_prepare_bitmap	
	
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#lifeok,SPRITE_BITMAP(a1)
	move.l	#$00100010,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#284-18+32-8,SPRITE_XPOS(a1)  
	add.w	#149,SPRITE_XPOS(a1)
	add.w	#4+8,SPRITE_YPOS(a1)	
	move.l	a1,a0
	jsr	op_prepare_bitmap	
	
	; select cursor
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#select,SPRITE_BITMAP(a1)
	move.l	#$00300030,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#350,SPRITE_YPOS(a1)	
	;move.l	a1,select_sprite_player	
	move.l	a1,a0
	jsr	op_prepare_bitmap	
	
	; clap clap left
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#hand,SPRITE_BITMAP(a1)
	move.l	#$00300030,SPRITE_WIDTH_HEIGHT(a1)
	move.w	#800,SPRITE_XPOS(a1)  
	move.w	#200,SPRITE_YPOS(a1)  
	move.l	a1,a0
	jsr	op_prepare_bitmap
	bset.b	#SPRITE_MIRRORING,SPRITE_OPTION(a1)
	;move.l	a1,clap_clap_animation
	move.l	#animation_left_clap,SPRITE_ANIM_PTR(a1)
	
	; clap clap right
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#hand,SPRITE_BITMAP(a1)
	move.l	#$00300030,SPRITE_WIDTH_HEIGHT(a1)	
	move.w	#800,SPRITE_XPOS(a1)  
	move.w	#200,SPRITE_YPOS(a1)  
	move.l	a1,a0
	jsr	op_prepare_bitmap
	bset.b	#SPRITE_MIRRORING,SPRITE_OPTION(a1)
	move.l	#animation_right_clap,SPRITE_ANIM_PTR(a1)

	; score text
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#score_bitmap,SPRITE_BITMAP(a1)
	move.l	#$00C00010,SPRITE_WIDTH_HEIGHT(a1)	
	move.w	scrn_x_origine,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#32,SPRITE_XPOS(a1)  
	add.w	#216+264,SPRITE_YPOS(a1)	
	move.l	a1,a0
	jsr	op_prepare_bitmap	
	
	; time left
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#dummy_bitmap,SPRITE_BITMAP(a1)
	move.l	#$00020002,SPRITE_WIDTH_HEIGHT(a1)	
	move.w	#100,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1)  
	add.w	#400,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap
	;move.l	a1,timeleft_animation
	
	; win or loose panel
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite	
	move.l	#background+768000,SPRITE_BITMAP(a1)
	move.l	#$01400030,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 	
	add.w	#96+264,SPRITE_YPOS(a1)  			
	move.l	a1,a0
	jsr		op_prepare_bitmap
	
	; SPRITE LIST FOR THIS PART
	sprite_playtime_background	.equ (sprite_list+(0*SPRITE_STRUCT_SIZE))
	sprite_playtime_dtsshadow	.equ (sprite_list+(1*SPRITE_STRUCT_SIZE))
	sprite_playtime_dts			.equ (sprite_list+(2*SPRITE_STRUCT_SIZE))
	sprite_playtime_jagware		.equ (sprite_list+(3*SPRITE_STRUCT_SIZE))
	sprite_playtime_text		.equ (sprite_list+(4*SPRITE_STRUCT_SIZE))
	sprite_playtime_userboard	.equ (sprite_list+(5*SPRITE_STRUCT_SIZE))
	sprite_playtime_todoboardshadow	.equ (sprite_list+(6*SPRITE_STRUCT_SIZE))
	sprite_playtime_todoboard	.equ (sprite_list+(7*SPRITE_STRUCT_SIZE))
	sprite_playtime_1st36tiles	.equ (sprite_list+(8*SPRITE_STRUCT_SIZE))
	sprite_playtime_timebar		.equ (sprite_list+(44*SPRITE_STRUCT_SIZE))
	sprite_playtime_timemark	.equ (sprite_list+(45*SPRITE_STRUCT_SIZE))
	sprite_playtime_1stlife		.equ (sprite_list+(46*SPRITE_STRUCT_SIZE))
	sprite_playtime_2ndlife		.equ (sprite_list+(47*SPRITE_STRUCT_SIZE))
	sprite_playtime_3rdlife		.equ (sprite_list+(48*SPRITE_STRUCT_SIZE))
	sprite_playtime_select		.equ (sprite_list+(49*SPRITE_STRUCT_SIZE))
	sprite_playtime_clapclapl	.equ (sprite_list+(50*SPRITE_STRUCT_SIZE))
	sprite_playtime_clapclapr	.equ (sprite_list+(51*SPRITE_STRUCT_SIZE))
	sprite_playtime_score		.equ (sprite_list+(52*SPRITE_STRUCT_SIZE))
	sprite_playtime_timeleft	.equ (sprite_list+(53*SPRITE_STRUCT_SIZE))
	sprite_playtime_winloose	.equ (sprite_list+(54*SPRITE_STRUCT_SIZE))	
	; END SPRITE LIST FOR THIS PART

	move.l	#background+768000,a1
	move.l	#8000-2,d1
.fill_in_black:
	move.l	#$0,(a1)+
	dbra	d1,.fill_in_black
	
	; How many sprite in use
	move.l	#55,num_sprite	
	
	wait_some_frame	#3	

	;move.l	life_animation,a1
	move.l	#sprite_playtime_1stlife,a1	
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	wait_some_frame	#2
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)

	;move.l	timemark_animation,a1
	move.l	#sprite_playtime_timemark,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)
	sub.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#animation_cos_left,SPRITE_ANIM_PTR(a1)	
		
	; set life number an time counter
	move.l	#3,number_of_life	
	move.l	#0,global_score
	move.l	#0,old_score
		
	move.l	#0,level_number	
	
	; clear score
	jsr		refresh_score
	
	move.l	#before_playing_or_level_change,current_process
	
	rts
	