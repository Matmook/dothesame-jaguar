;-----------------------------------------------------------------------------
; make_op_link permet de transformer une adresse 32 bit au format LINK 64bits
;-----------------------------------------------------------------------------
; entrée : 	\1 contient l'adresse 32 bits à modifier
;		\2 peux contenir n'importe quoi, il est écrasé
; sortie :	\1 contient les 11 bits de poids fort (bits 32 à 42 de la phrase)
;		\2 contient les 8 bits de poids faible (bits 24 à 31 de la phrase)
.macro	make_op_link
	andi.l	#$3FFFF8,\1		; Ensure alignment/valid address
	move.l	\1,\2
	lsr.l	#8,\1
	lsr.l	#3,\1
	swap	\2
	clr.w	\2
	lsl.l	#5,\2
.endm
;-----------------------------------------------------------------------------

;-----------------------------------------------------------------------------
; wait_blitter permet de savoir si le blitter est disponible
; Macro prise dans "The Removers'Library"
;-----------------------------------------------------------------------------
; entrée : 	\1 est utilisé pour faire le test
.macro	wait_blitter
.loop_wait_blitter\~:
	move.l  B_CMD,\1
	btst    #0,\1
	beq.s   .loop_wait_blitter\~
.endm
;-----------------------------------------------------------------------------

; wait_vbl 
; \param1 how many vbl to wait
.macro	wait_vbl	param1
.init_loop_wait_vbl\~:
	sf		vbl_flag
.loop_wait_vbl\~:
	tst.b	vbl_flag
	beq.s	.loop_wait_vbl\~
	dbra	\param1,.init_loop_wait_vbl\~
.endm

; wait_some_frame
; \param1 how many vbl to wait
.macro	wait_some_frame	param1	
	movem.l	d0-d6/a0-a6,-(sp)
	move.l	#0,frame_counter_global	
.wait_the_correct_frame\~:
	;stop	#$2000 ; stop 68k!
	sf		vbl_flag	
.loop_wait_vbl\~:
	tst.b	vbl_flag
	beq.s	.loop_wait_vbl\~
.check_if_gpu_process_is_finished\~:	
	cmp.l	#0,gpu_lock
	bne.s	.check_if_gpu_process_is_finished\~
	cmp.l	\param1,frame_counter_global
	bne.s	.wait_the_correct_frame\~	
	movem.l	(sp)+,d0-d6/a0-a6
.endm

; wait_some_frame_or_exit
; \param1 how many vbl to wait
.macro	wait_some_frame_or_exit	param1,param2	
	movem.l	d0-d6/a0-a6,-(sp)
	;move.l	#0,joy1cur
	move.l	#0,frame_counter_global	
.wait_the_correct_frame\~:
	sf		vbl_flag	
.loop_wait_vbl\~:
	tst.b	vbl_flag
	beq.s	.loop_wait_vbl\~
.check_if_gpu_process_is_finished\~:	
	cmp.l	#0,gpu_lock
	bne.s	.check_if_gpu_process_is_finished\~
	
	jsr		ReadJoypads	; read joypad information
	move.l	joy1cur,d2
	btst	#FIRE_B,d2
	beq.b	.count_frame\~	
	movem.l	(sp)+,d0-d6/a0-a6	
	bra		\param2

.count_frame\~:	
	cmp.l	\param1,frame_counter_global
	bne.s	.wait_the_correct_frame\~	
	movem.l	(sp)+,d0-d6/a0-a6
.endm

; wait_end_of_animation
; \param1 which sprite to test
.macro	wait_end_of_animation	param1	
	movem.l	d0-d6/a0-a6,-(sp)	
.wait_the_null_animation_ptr\~:
	;stop	#$2000 ; stop 68k!
	sf		vbl_flag	
.loop_wait_vbl\~:
	tst.b	vbl_flag
	beq.s	.loop_wait_vbl\~
.check_if_gpu_process_is_finished\~:	
	cmp.l	#0,gpu_lock
	bne.s	.check_if_gpu_process_is_finished\~	
	cmp.l	#0,SPRITE_ANIM_PTR(\param1)
	bne.s	.wait_the_null_animation_ptr\~
	movem.l	(sp)+,d0-d6/a0-a6
.endm

; wait_a_key_press
.macro	wait_a_key_press	
	move.l	#0,joy1cur
	move.l	#current_process,saved_process	
	move.l	#.wait_the_pressed_key_ptr\~,current_process
.wait_the_pressed_key_ptr\~:
	;stop	#$2000 ; stop 68k!
	sf		vbl_flag	
.loop_wait_vbl\~:
	tst.b	vbl_flag
	beq.s	.loop_wait_vbl\~
.check_if_gpu_process_is_finished\~:	
	cmp.l	#0,gpu_lock
	bne.s	.check_if_gpu_process_is_finished\~	
	move.l	d2,-(sp)
	move.l	joy1cur,d2
	btst	#FIRE_A,d2
	beq.b	.check_key_B\~		
	bra.s	.end_wait_the_pressed_key_ptr\~
.check_key_B\~:
	btst	#FIRE_B,d2
	beq.b	.check_key_C\~		
	bra.s	.end_wait_the_pressed_key_ptr\~
.check_key_C\~:
	btst	#FIRE_C,d2
	beq.b	.no_key_pressed\~
	bra.s	.end_wait_the_pressed_key_ptr\~
.no_key_pressed\~:	
	move.l	(sp)+,d2
	rts
.end_wait_the_pressed_key_ptr\~:	
	move.l	(sp)+,d2
	move.l	#saved_process,current_process
.endm

