.text
	.include	"jaguar.inc"
	.include	"CD.INC"
	move.l	#$0,BG ; black background (why not ?)

	.include	"mooklib/macros.s"	
	.include "mooklib/resetjag.s" ; reset GPU,DSP and interrupts
;	if ^^defined CDVERSION==1
;	jsr		CD_stop
;	endif	
	.include "gamesrc/init.s" ; general purpose initialisation (font context,...)				
	jsr	sebrmv_sound_player_install_player ; setup SebRMV's sound system	
	;.include "mooklib/sdreplay.s" ; setup Sinister Dev sound replay		
	.include "mooklib/initjag.s" ; set VBL, Interrupt, InitObjectList, SetVideoMode, RunGPU		
	
	
ingame_loop:		
	; the 68k should be resume on vbl's interrupt (I think and I hope !)
	; so I don't test the VBL...finally I test the VBL...
	; 'cause interrupt could be done by other chip
	;stop	#$2000 ; stop 68k!
	sf		vbl_flag	
.loop_wait_vbl:
	tst.b	vbl_flag
	beq.s	.loop_wait_vbl
	
	; GPU has done his job on sprite list ?
	; I can't change sprite struct while GPU use it !
.check_if_gpu_process_is_finished:	
	cmp.l	#0,gpu_lock
	bne.s	.check_if_gpu_process_is_finished	
		
	; read joypad
	jsr		ReadJoypads	; read joypad information

	; global sound config KEY 0	
	move.l	joy1edge,d0
	btst	#KEY_0,d0
	beq.b	.dont_pause_the_music	
	bsr		sebrmv_sound_player_play_pause_player
	wait_some_frame	#12
	
.dont_pause_the_music:
	
	; load current game part ptr and go in it
	move.l	current_process,a0	
	jsr		(a0)	
	
	; load continus part ptr and go in it if exist
;	move.l	background_process,a0		
;	tst.l	(a0)
;	beq.s	.not_second_process
;	jsr		(a0)	
;.not_second_process:

	; and restart the running loop
	bra		ingame_loop	
		
	.text
	; Insert (Mat)Mook's library and other's code	
	.include	"mooklib/defs.s"
	.include	"mooklib/gpu.s"
	.include	"mooklib/utils.s"
	.include	"mooklib/listmngr.s"
	.include	"mooklib/blitter.s"
	.include	"mooklib/scrnmngr.s"
	.include	"mooklib/joypad.s"
	.include	"mooklib/fontmngr.s"
	;.include	"mooklib/gtcurve.s"	
	.include	"mooklib/sebsnd.s"	
;player: 	.include	"mooklib/play.s"		

	; Insert DATA and BSS section
	.data
	.long
scrn_x_origine:   		dcb.w 	1,0
scrn_y_origine:   		dcb.w 	1,0
vbl_flag:				dcb.w	1,0
a_hdb:  				dcb.w  	1,0
a_hde:      			dcb.w  	1,0
a_vdb:      			dcb.w  	1,0
a_vde:      			dcb.w  	1,0
width:      			dcb.w 	1,0
height:     			dcb.w 	1,0	
	.qphrase
num_sprite:				dcb.l	1,0  ; how many used sprite	
	.qphrase
generic_op_stop:		dcb.l	2,0	; generic stop object (for the 2 common branch object !)
	.qphrase
primary_object_list:	dcb.l	1,0	; in use object list
	.qphrase
secondary_object_list:	dcb.l	1,0	; in work object list
	.qphrase
dyn_object_list1:    	dcb.l   MAXNUMSPRITE*8+4+4,0  		; Object List
	.qphrase
dyn_object_list2:    	dcb.l   MAXNUMSPRITE*8+4+4,0  		; Object List
	.qphrase
sprite_list:			dcb.b	MAXNUMSPRITE*SPRITE_STRUCT_SIZE,0	
	.qphrase
dummy_bitmap:			dcb.w	8,7
	.qphrase
;gpu_lock:				dcb.l	1,0 ; ensure GPU has done his job on the current sprite list
game_paused:			dcb.l	1,0 ; freeze the GPU display code

; joypad data
joy1edge:				dcb.l	1,0
joy1cur:				dcb.l	1,0
joy2edge:				dcb.l	1,0
joy2cur:				dcb.l	1,0

; generic frame counter
frame_counter_global:	dcb.l	1,0
multi_purpose_1:		dcb.l	1,0

; game part ptr
current_process:		dcb.l	1,0
saved_process:			dcb.l	1,0
background_process:		dcb.l	1,0

; music ptr
sample_frequency:		dcb.l	1,0
use_music:				dcb.w	1,0
	.include	"gamesrc/data.s"
	
	.bss	
	.long
clear_bss_begin:	ds.l	1
	.include 	"gamesrc/bss.s"	
	
	.text
	; include game functions and core
	.include	"gamesrc/function.s"	
	.include	"gamesrc/team.s"	
	.include	"gamesrc/title.s"	
	.include	"gamesrc/gamemode.s"	
	.include	"gamesrc/greets.s"	
	.include	"gamesrc/youwin.s"	
	.include	"gamesrc/youloose.s"	
	.include	"gamesrc/playtimes.s"	
	.include	"gamesrc/initplay.s"
	.include	"gamesrc/end.s"
	.include	"gamesrc/howto.s"
	.include	"gamesrc/centersc.s"
	;.include	"gamesrc/fade.s"	
	.include	"mooklib/Upck_inc.s"	
	
	.end
