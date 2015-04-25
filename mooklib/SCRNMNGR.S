;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; center bitmap on screen with X
; d0 : bitmap width+height
	.globl	scrn_compute_visual_center
scrn_compute_visual_center:		
	movem.l 	d0-d1,-(sp)
	
	;compute Y origin
	move.w  	height,d1            	
	add.w   	a_vdb,d1
	sub.w   	d0,d1			; low word contain bitmap's height
	lsr.w   	#1,d1
	andi.w	#$FFFE,d1
	move.w	d1,scrn_y_origine
	
	swap	d0				; obtain bitmap's width
	
	;compute X origin
	move.w  	width,d1            	; Get width in clocks
	lsr.w   	#2,d1               	; /4 Pixel Divisor
	sub.w	d0,d1			; substract bitmap width
	lsr.w   	#1,d1               	; /2 = center	
	add.w		#4,d1
	andi.w	#$FFFE,d1	
	move.w	d1,scrn_x_origine	
	
	movem.l 	(sp)+,d0-d1
	rts
_scrn_compute_visual_center:		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Setup VBL interrupt rout
scrn_set_vbl_interrupt:
	move.l  	d0,-(sp)			
	move.l  	#scrn_vblrout,LEVEL0
	move.w  	a_vde,d0
	ori.w   	#1,d0
	move.w  	d0,VI
	;or.w		#C_VIDCLR|C_VIDENA,INT1
	or.w		#C_VIDENA,INT1
	and.w		#$f8ff,sr      		; Lower 68k IPL to allow		
	move.l  	(sp)+,d0			
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; VBL interrupt rout
scrn_vblrout:
	; play music
	tst.b	use_music
	beq.s	.no_need_to_play_music	
	movem.l  d0-d2/a0-a2,-(sp)
	jsr _play_module
	movem.l  (sp)+,d0-d2/a0-a2
;	jsr	player+$8 	; on lit la suite du module (à la pattern suivante)	
.no_need_to_play_music:	

	move.l	#1,gpu_lock	; start gpu 	
	add.l	#1,frame_counter_global ; increment frame counter
	st		vbl_flag				; yes, vbl is done
	
	move.w	#$101,INT1 ; enable next interrupt
	move.w  #$0,INT2	
	rte

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Initialise Video Mode
scrn_init_video:
	movem.l 	d0-d6,-(sp)		; on sauvegarde tous ces registres en pile
		
	move.w  	CONFIG,d0      		; On peux trouver à cet emplacement des informations
							; sur les joystick ainsi que sur le mode vidéo de la console
	andi.w  	#VIDTYPE,d0    	; On détermine le type de console utilisé
	beq.s 		palvals			; 0 = PAL, 1 = NTSC
	
	; Nous sommes en NTSC
	move.w  	#NTSC_HMID,d2		; milieu de l'écran en largeur en pixelclock
	move.w  	#NTSC_WIDTH,d0		; largeur de l'écran en NTSC

	move.w  	#NTSC_VMID,d6		; milieu de l'écran en hauteur en pixelclock
	move.w  	#NTSC_HEIGHT,d4		; hauteur de l'écran en NTSC

	bra.s 		calc_vals		
palvals:					; Nous sommes en PAL
	move.w  	#PAL_HMID,d2		; milieu de l'écran en largeur en pixelclock
	move.w  	#PAL_WIDTH,d0	; largeur de l'écran en PAL

	move.w  	#PAL_VMID,d6		; milieu de l'écran en hauteur en pixelcloc
	move.w  	#PAL_HEIGHT,d4	; hauteur de l'écran en PAL	

calc_vals:					; Ici, on va calculer quelques valeurs qui vont nous être
						; utiles pour l'affichage quelque soit le type de jaguar
	move.w  	d0,width		; on sauvegarde la largeur en pixel
	move.w  	d4,height		; on sauvegarde la hauteur en pixel

	move.w  	d0,d1
	asr 		#1,d1         	 ; on a la largeur de l'écran/2 dans d1 (demi-ligne)

	sub.w  	d1,d2         	  	; Mid - Width/2
	add.w  	#4,d2         	  	; (Mid - Width/2)+4

	sub.w   	#1,d1         	  	; Width/2 - 1
	ori.w   	#$400,d1      	  	; (Width/2 - 1)|$400
	
	move.w  	d1,a_hde
	move.w  	d1,HDE

	move.w  	d2,a_hdb
	move.w  	d2,HDB1
	move.w  	d2,HDB2

	move.w  	d6,d5
	sub.w   	d4,d5
	move.w  	d5,a_vdb		; debut du border

	add.w   	d4,d6
	move.w  	d6,a_vde		; fin du border

	move.w  	a_vdb,VDB
	move.w  	#$FFFF,VDE
		
	move.l  	#$0,BORD1        	; Black border
	move.w  	#$0,BG           	; Init line buffer to black
		
	movem.l 	(sp)+,d0-d6
	rts
_scrn_init_video:	


load_clut:
	movem.l d0/a0-a1,-(sp)
	moveq.l	#0,d0
	move.w	(a0)+,d0
	;sub.l	#1,d0	
	move.l	#CLUT,a1
.cloop:
	move.w	(a0)+,(a1)+
	dbra	d0,.cloop
	movem.l (sp)+,d0/a0-a1	
	rts

; need blank line for aln