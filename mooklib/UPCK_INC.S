Unpack_adr	EQU	$f03000	; GPU
;Unpack_adr	EQU	$f1b000	; DSP

Install_unpack_rout:
	movem.l	d0-d7/a0-a6,-(a7)

	lea	lz77_Gpu_code,a0
	lea	Unpack_adr,a1

	jsr	Copy_proc_code(pc)
	add.w	d0,a1
	move.l	a1,lz77_params
	
	movem.l	(a7)+,d0-d7/a0-a6
	rts

Unpack:	movem.l	d0-d7/a0-a6,-(a7)

	move.l	lz77_params,a2		; Ou mettre les params
	move.l	a0,(a2)+		; le dessin (compact‚)
	move.l	a1,(a2)		; ou le placer

	move.l	#Unpack_adr,G_PC	; Installe le P(rogram) C(ounter)
				; du Gpu
	lea	G_CTRL,a0		; On installe le registre de Control

	move.l	#1,(a0)		; start le Gpu

	tst.l	d0
	bne.s	Pas_wait_during_unpack

Wait_end_packing:			; et on attend comme des anes
	move.l	(a0),d0		; la fin du d‚compactage
	btst	#0,d0
	bne.s	Wait_end_packing

Pas_wait_during_unpack:

	movem.l	(a7)+,d0-d7/a0-a6
	rts


Copy_proc_code:	movem.l	d1-d7/a0-a6,-(a7)

	move.l	2(a0),d7
	lea	$1a(a0),a0

	move.w	d7,d0

	lsr.w	#2,d7
	subq.w	#1,d7
Copy_the_proc_code:
	move.l	(a0)+,(a1)+
	dbra	d7,Copy_the_proc_code

	movem.l	(a7)+,d1-d7/a0-a6
	rts
	
	.bss
; LZ77 DEPACKING PARAMETER
lz77_params:				ds.l		2	
	.text
	