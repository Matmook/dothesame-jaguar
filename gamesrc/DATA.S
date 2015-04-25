	.long
lz77_Gpu_code:	.incbin	"mooklib/lz77dpck.o"
	even
	.qphrase
font8x8:		.incbin	"bitmap/kroma8.cry"
	.qphrase
kromaskyfont:	.incbin	"bitmap/kromasky.cry"
	.qphrase
element:		.incbin	"bitmap/element.cry"	
	.qphrase
minielem:		.incbin	"bitmap/minielem.cry"
	.qphrase
select:			.incbin	"bitmap/select.cry"
	.qphrase
jagware:		.incbin	"bitmap/jagware.cry"
	.qphrase
border:			.incbin	"bitmap/border.cry"	
	.qphrase
dts:			.incbin	"bitmap/dts.cry"	
	.qphrase
hand:			.incbin	"bitmap/hand.cry"	
	.qphrase
timebar:		.incbin	"bitmap/timebar.cry"	
	.qphrase
timemark:		.incbin	"bitmap/timemark.cry"	
	.qphrase
lifeok:			.incbin	"bitmap/lifeok.cry"	
	.qphrase
lifeko:			.incbin	"bitmap/lifeko.cry"	
	.qphrase
start:			.incbin	"bitmap/start.cry"	
	.qphrase
greets:			.incbin	"bitmap/greets.cry"	
	.qphrase
backg_starts:	.incbin	"bitmap/etoile.cry"	
	.long
wav_win:		.incbin	"sound/win.raw"	
end_wav_win:
	.long
wav_loose:		.incbin	"sound/loose.raw"	
end_wav_loose:
	.qphrase
lz77_backg:		.incbin	"bitmap/backg.lz7"	
lz77_backg_end:	dc.l	1

cheat_char:		dc.b	"RZQUWXYZV"
txt_score:		dc.b	"*  /     ",13
txt_paused:		dc.b	"GAME PAUSED !      ",13
txt_empty:		dc.b	"                   ",13
txt_version:	dc.b	"   JUST FOR FUN @  ",13
txt_loose:		dc.b	"GAME OVER !*       ",13
txt_win:		dc.b	"YOU WIN !!!*    TRY",13
txt_win2:		dc.b	" ARE YOU THE BEST ?",13
						 
txt_center:		dc.b	"= PLEASE CENTER ME =",13
txt_greetings:	dc.b	"CODING :           "
				dc.b	"          - MATMOOK"				
				dc.b	"ADDITIONNAL CODING "
				dc.b	"         - GT TURBO"				
				dc.b	"DESIGN :           "
				dc.b	"             - BEAR"
				dc.b	"CD & PACKAGING :   "
				dc.b	"         - RGC TEAM"								
				dc.b	"MUSIC :     - SCRAT"
				dc.b	"            - CLAWZ"
				dc.b	"REPLAY :           "
				dc.b	"           - SEBRMV"
				;dc.b	"     - SINISTER DEV"
				dc.b	"LEVELS:            "
				dc.b	"       - FREDIFREDO"
				dc.b	"         - ODIE ONE"
				dc.b	"                   "
				dc.b	"BETA-TESTERS :     "
				dc.b	"           - ANNESO"
				dc.b	"        - ATARI-FAN"
				
				dc.b 	"       - DOCTOR CLU"				
				dc.b	"       - FREDIFREDO"				
				dc.b 	"          - KRUPKAJ"				
				dc.b	"        - NONNER242"
				dc.b	"         - ODIE ONE"
				
				dc.b	"           - PMDATA"
				dc.b	"           - SEBRMV"
				dc.b	"         - VIMASTER"
				dc.b	"                   "
				
				dc.b	" GREETINGS TO ALL  "
				dc.b	"THE JAGWARE TEAM ! "
				dc.b	"     AND ALL       "
				dc.b	"   JAGUAR FANS !   "	
				
				dc.b	" RELEASED ON  :    "
				dc.b	"    JUNE 15 2009   "
				dc.b	"    JUST FOR FUN   "
				dc.b	"      MATMOOK      "
				
			
				;
txt_difficulty:	dc.b	"CHOOSE DIFFICULTY :"
				dc.b	"  GET16  : PRESS A "
				dc.b	"  32MORE : PRESS B "
				dc.b	"  64ROAR : PRESS C "
txt_panel:		dc.b	"<----------------->",13
				dc.b	"=WEBCODE: XXXXXX  =",13
				dc.b	"(-----------------)",13
txt_how_to_play:dc.b	"HOW TO PLAY ?"
txt_goal_up:	dc.b	"  THE GOAL OF THIS GAME IS TO REPRODUCE ",13
				dc.b	" A PICTURE BY ROTATING A FOUR SQUARED   ",13				
				dc.b	" TILESET. YOU CAN WIN A MAXIMUM OF  50  ",13
				dc.b	" POINTS PER LEVEL. YOUR CURRENT TIME    ",13
				dc.b	" DECREASES EACH TIME YOU WIN A LEVEL !   ",13
txt_goal_down:	dc.b	"  YOU CAN USE WEBSCORE ON THIS SITE :   ",13
				dc.b	"      HTTP://DOTHESAME.JAGWARE.ORG *    ",13				
				dc.b	" AND COMPARE YOUR SCORE WITH PLAYERS    ",13
				dc.b	" ALL OVER THE WORLD.                    ",13
				dc.b	"            ... WILL YOU BE THE BEST ?  ",13				
	.long
module1:		.incbin	"sound/frenck_k.mod"
				dc.l	8
	.long
module2:		.incbin	"sound/outofcon.mod"
				dc.l	8				
	; level definition
	include	"gamesrc/lvdef.s"
	even
