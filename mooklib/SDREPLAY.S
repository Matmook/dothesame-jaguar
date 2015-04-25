	; Setup Sinister Dev's Replay

	; Put player in DSP ram
	jsr	player
	
	move.w	#80,d0		; Set music volume
	jsr	player+$14
	
	move.w	#254,d0		; Set effect volume
	jsr	player+$18
	