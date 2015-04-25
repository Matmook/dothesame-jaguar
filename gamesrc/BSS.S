	; USER BSS
	; BITMAP RESERVED SPACE
	
;	.qphrase
;user_board:			ds.w		12544
user_board			equ	(lz77_backg+(2*12544))
	.qphrase
todo_board:			ds.w		8192
	.qphrase
text_bitmap:		ds.w		10240
	.qphrase
dts_shadow:			ds.w		3720		
	.qphrase
todo_board_shadow:	ds.w		6272
	.qphrase
score_bitmap:		ds.w		5632
	; ANIMATION LIST
	.qphrase
animation_jagware:			ds.l		6*PHRASE

animation_dts:				ds.l		19*PHRASE
animation_dts_shadow:		ds.l		19*PHRASE

animation_element_left:		ds.l		8*PHRASE
animation_element_right:	ds.l		8*PHRASE
animation_element_up:		ds.l		8*PHRASE
animation_element_down:		ds.l		8*PHRASE

animation_select_left:		ds.l		4*PHRASE
animation_select_right:		ds.l		4*PHRASE
animation_select_up:		ds.l		4*PHRASE
animation_select_down:		ds.l		4*PHRASE

animation_tiles_win1:		ds.l		58*PHRASE
animation_tiles_zoom:		ds.l		10*PHRASE

animation_right_clap:		ds.l		30*PHRASE
animation_left_clap:		ds.l		30*PHRASE

animation_timemark_up:		ds.l		3*PHRASE
animation_timemark_down:	ds.l		4*PHRASE
animation_timeleft:			ds.l		3*PHRASE

animation_cos_up:			ds.l		31*PHRASE
animation_cos_down:			ds.l		31*PHRASE
animation_cos_right:		ds.l		31*PHRASE
animation_cos_left:			ds.l		31*PHRASE

	; RUNNING LEVEL DATA
main_board_tiles:			ds.b		6*6 ; (tiles)
main_board_sprite:			ds.l		6*6 ; (tiles sprite)
first_level:				ds.l		1 ; ptr to gamemode's first level
current_level:				ds.l		1 ; ptr to current level
level_number:				ds.l		1 ; current level number
last_level_number:			ds.l		1 ; last level number

	; SELECT POSITION
select_posx_player:			ds.w		1
select_posy_player:			ds.w		1

	; ANIMATION CHECK
rotate_running_animation:	ds.l		4 ; current tiles moving

	; FRAME COUNTER AND MUSIC
	.long
number_of_life:				ds.l		1
global_score:				ds.l		1
old_score:					ds.l		1
difficulty:					ds.l		1

; FONT DECLARATION (FONT AND CONTEXT)
	.long
police_8x8:				ds.b		FONT_STRUCT_SIZE
	.long
police_kromasky:		ds.b		FONT_STRUCT_SIZE
	.long
police_context:			ds.b		FONT_CONTEXT_STRUCT_SIZE
	.long
panel_context:			ds.b		FONT_CONTEXT_STRUCT_SIZE
	.long
score_context:			ds.b		FONT_CONTEXT_STRUCT_SIZE
	.long
howtoup_context:		ds.b		FONT_CONTEXT_STRUCT_SIZE
	.long
howtodown_context:		ds.b		FONT_CONTEXT_STRUCT_SIZE

	.qphrase
background:				ds.w		603776

	.long
clear_bss_end:			ds.l		1
bss_size 	equ	(clear_bss_end-clear_bss_begin)/1024
.print	"BSS Usage : ", bss_size, "Ko"
