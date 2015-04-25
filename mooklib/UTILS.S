;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; InitGPU
; permet d'initialiser le GPU
init_GPU:
		movem.l a0-a2,-(sp)
		
		lea   gpu_main_code,a0            	; GPU Interrupt Object Handler Code
		lea   _gpu_main_code,a1
		move.l  #G_RAM,a2
		jsr     copy_block 

		movem.l (sp)+,a0-a2
		rts
_init_GPU:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; copy_block
;	      Copies un block de memoire (maximum 65536 bytes)
;
;         Inputs: 	a0.l	- Block Start
;			a1.l	- Block End
;
; Register Usage:	d0.w	- DBRA counter
;
; Stupid copy routine (use Blitter for large blocks of GPU code)

copy_block:
		move.l  d0,-(sp)
			
		move.l  a1,d0           ; End of block
		sub.l   a0,d0           ; Start of block

		lsr.l   #2,d0           ; # of LONGs
.copy_loop:
		move.l  (a0)+,(a2)+
		dbra    d0,.copy_loop

		move.l  (sp)+,d0
		rts
_copy_block:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; hexa to dec conversion by GT !
;	lea	Number,a0
;	move.l	#123467,d0
;	moveq	#6,d1	; Nombre de chiffres
;	jsr	Convert_to_dec_format
Convert_to_dec_format:
	movem.l	d0-d7/a0-a6,-(a7)

	moveq	#0,d4

	move.w	d1,d6
	subq.w	#1,d6

	neg.w	d1
	add.w	#$a,d1
	lsl.w	#2,d1

	lea	Number_tab(pc),a1
	add.w	d1,a1

CEn_entier0:
	move.l	(a1)+,d7
	move.w	#$d0,d5
CSous_tract0:
	sub.l	d7,d0
	dbmi	d5,CSous_tract0
	add.l	d7,d0
	neg.b	d5

	move.b	d5,(a0)+
	dbra	d6,CEn_entier0

	movem.l	(a7)+,d0-d7/a0-a6
	rts

;Number:
;	dcb.b	10,0
;	dc.b	0
;	dc.b	0
Number_tab:
	dc.l	1000000000
	dc.l	100000000
	dc.l	10000000
	dc.l	1000000
	dc.l	100000
	dc.l	10000
	dc.l	1000
	dc.l	100
	dc.l	10
	dc.l	1

