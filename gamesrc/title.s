;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; TITLE SCREEN
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
game_part_title_init:
	jsr	op_create_dummy_list
	wait_some_frame	#12
	
;	tst.b	use_music
;	beq.s	.no_need_to_clear_player
;	jsr		sebrmv_sound_player_reset_player
;.no_need_to_clear_player:	
	lea		module1,a1
	jsr		sebrmv_sound_player_run_player	
	st	use_music
	
	move.l	#background+768000,a1
	move.l	#8000-2,d1
.fill_in_grey:
	move.l	#$78047804,(a1)+
	dbra	d1,.fill_in_grey
	
	move.l	#background+792000,a1
	move.l	#50688-2,d1
.fill_in_black:
	move.l	#$0,(a1)+
	dbra	d1,.fill_in_black	
	
	move.l	#0,d1
	move.l	#0,d2
	
	move.l	#64,d0	
	move.l	#PIXEL8|PITCH1|WID64,d3
	move.l	#PIXEL8|PITCH1|WID384,d4
	move.l	#384,d5
	move.l	#background+792000,a1	
	move.l	#backg_starts,a0
	REPT	5
		REPT	6
			jsr		blitter_copy_bloc	
			add.l	#64,d1
		ENDR
		add.l	#64,d2
		moveq.l	#0,d1
	ENDR

	move.l	#backg_starts+4096,a0
	jsr		load_clut	
	
	move.l	#sprite_list,a1	

	jsr		op_prepare_next_sprite	
	move.l	#background+792000,SPRITE_BITMAP(a1)
	move.l	#$018000F0,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 	  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#264,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap_8bit
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
		
	add.l	#SPRITE_STRUCT_SIZE,a1
	move.l	#76-1,d0	
	move.l	#8,d1
	move.l	#0,d2
.create_initial_76_tiles:		
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
	cmp.l	#312,d1
	bne.s	.notendofline
	move.l	#8,d1
	add.l	#24,d2
.notendofline:	
	dbra	d0,.create_initial_76_tiles	
	
	jsr		op_prepare_next_sprite	
	move.l	#dts,SPRITE_BITMAP(a1)
	move.l	#$00400020,SPRITE_WIDTH_HEIGHT(a1)
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 
	add.w	#128,SPRITE_XPOS(a1)  	
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#48+264,SPRITE_YPOS(a1)  	
	move.l	a1,a0
	jsr	op_prepare_bitmap	

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

	; text window
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#text_bitmap,SPRITE_BITMAP(a1)
	move.l	#$01400020,SPRITE_WIDTH_HEIGHT(a1)	
	move.w	scrn_x_origine,SPRITE_XPOS(a1) 
	add.w	#8,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#215+264,SPRITE_YPOS(a1)    
	move.l	a1,a0
	jsr	op_prepare_bitmap		
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)

	; start
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#start,SPRITE_BITMAP(a1)
	move.l	#$00840023,SPRITE_WIDTH_HEIGHT(a1)	
	move.w	scrn_x_origine,SPRITE_XPOS(a1)
	add.w	#94,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#141+264,SPRITE_YPOS(a1)		
	move.l	a1,a0
	jsr	op_prepare_bitmap		

	; greets
	add.l	#SPRITE_STRUCT_SIZE,a1
	jsr		op_prepare_next_sprite
	move.l	#greets,SPRITE_BITMAP(a1)
	move.l	#$00840013,SPRITE_WIDTH_HEIGHT(a1)	
	move.w	scrn_x_origine,SPRITE_XPOS(a1)
	add.w	#94,SPRITE_XPOS(a1)  
	move.w	scrn_y_origine,SPRITE_YPOS(a1) 
	add.w	#190+264,SPRITE_YPOS(a1)		
	move.l	a1,a0
	jsr	op_prepare_bitmap		

	; SPRITE LIST FOR THIS PART
	sprite_title_background	.equ (sprite_list+(0*SPRITE_STRUCT_SIZE))	
	sprite_title_1st76char	.equ (sprite_list+(1*SPRITE_STRUCT_SIZE))
	sprite_title_dtslogo	.equ (sprite_list+(77*SPRITE_STRUCT_SIZE))
	sprite_title_lowmask	.equ (sprite_list+(78*SPRITE_STRUCT_SIZE))
	sprite_title_text		.equ (sprite_list+(79*SPRITE_STRUCT_SIZE))
	sprite_title_start		.equ (sprite_list+(80*SPRITE_STRUCT_SIZE))
	sprite_title_greetings	.equ (sprite_list+(81*SPRITE_STRUCT_SIZE))
	; END SPRITE LIST FOR THIS PART
	
	; display video mode
	move.l	#txt_version,a2		
;	move.w  CONFIG,d0
;	andi.w  #VIDTYPE,d0
;	bne.s 	.video_mode_is_pal	; 0 = PAL, 1 = NTSC
;	move.l	#txt_ntsc,a2	
;.video_mode_is_pal:	
	move.l	#police_kromasky,a0
	move.l	#police_context,a1
	move.l	#$00000000,d0
	jsr		font_draw_word

	move.l	#82,num_sprite			
	
	move.l	#sprite_title_lowmask,a1
	wait_end_of_animation	a1
	
	move.l	#sprite_title_dtslogo,a1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)
	wait_end_of_animation	a1	

	move.l	#sprite_title_start,a1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)	
	wait_end_of_animation	a1	
	
	move.l	#sprite_title_greetings,a1
	move.l	#animation_cos_up,SPRITE_ANIM_PTR(a1)	
	wait_end_of_animation	a1	
	
	move.l	#0,multi_purpose_1
	move.l	#game_part_title,current_process
game_part_title:

	move.l	joy1cur,d2
	
	btst	#FIRE_B,d2
	beq.b	.game_part_title_no_key_b	
	
	move.l	#sprite_title_dtslogo,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	cmp.l	#0,multi_purpose_1	
	beq.s	.letsstartthegame
	
	move.l	#txt_greetings,a2
	move.l	#sprite_title_start,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	move.l	#go_next_or_first_greetings,current_process
	rts
.letsstartthegame:
	move.l	#sprite_title_greetings,a1
	move.l	#animation_cos_down,SPRITE_ANIM_PTR(a1)
	
	move.l	#game_part_difficulty_init,current_process
	rts
.game_part_title_no_key_b:	
	btst	#JOY_UP,d2
	beq.b	.game_part_title_no_key_up
	
	move.l	#sprite_title_start,a1
	move.l	#start,SPRITE_BITMAP(a1)
	
	move.l	#sprite_title_greetings,a1
	move.l	#greets,SPRITE_BITMAP(a1)
	
	move.l	#0,multi_purpose_1	
.game_part_title_no_key_up:	
	btst	#JOY_DOWN,d2
	beq.b	.game_part_title_no_key_down
	
	move.l	#sprite_title_start,a1
	move.l	#start+9240,SPRITE_BITMAP(a1)
	
	move.l	#sprite_title_greetings,a1
	move.l	#greets+5016,SPRITE_BITMAP(a1)
	
	move.l	#1,multi_purpose_1	
.game_part_title_no_key_down:	
	btst	#OPTION,d2
	beq.b	.not_option
	move.l	#game_part_center_screen_init,current_process
	rts
.not_option:	

.not_egg2:
	rts
