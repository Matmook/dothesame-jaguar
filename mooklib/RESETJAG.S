	; CLEAR WHOLE BSS
	.extern	_BSS_E
	; slow and dirty but usefull ;-) !	
	move.l	#clear_bss_begin,a0
	move.l	#_BSS_E,a1	
.clear_whole_bss:	
	move.l	#0,(a0)+
	cmp.l	a0,a1
	bne.s	.clear_whole_bss
	
	
	
	; INIT JAG
	move.w		#$100,JOYSTICK		; no sound
	move.l  	#$70007,G_END		; big-endian mode for GPU
	move.l  	#$70007,D_END		; big-endian mode for DSP	
	move.l		#0,G_CTRL			; stop GPU
	move.l		#0,G_FLAGS			; clear GPU flags
	move.l		#0,D_CTRL			; stop DSP
	move.l		#0,D_FLAGS			; clear DSP flags	
	move.w  	#$FFFF,VI       	; Clear video interrupt
	move.l  	#INITSTACK,a7   	; Set stack
	jsr 		scrn_init_video     ; Set up video mode
