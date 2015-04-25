;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Procedure: ReadJoypads
;	      Read both joypads and update state variables.
;
; Store a bitmask of the current state of the joysticks in joy1cur
; and joy2cur. The variables joy1edge and joy2edge stores a state
; bitmap of new key 'down' events (never 'up' events) since the last time
; ReadJoypads was called.
;
; The code below may be altered by removing two AND instructions so that
; joy1edge and joy2edge contain a bitmap of keys that have changed (not
; pressed). If desired, this data could be compared to joy1cur and joy2cur
; to determine the actual button state.

ReadJoypads:
	movem.l	d0-d2/a0,-(sp)

	lea	JOYSTICK,a0

	move.l	#$f0fffffc,d1		; d1 = Joypad data mask
	moveq.l	#-1,d2		 	; d2 = Cumulative joypad reading

	move.w	#$81fe,(a0)
	move.l	(a0),d0		 	; Read joypad, pause button, A button
	or.l	d1,d0			; Mask off unused bits
	ror.l	#4,d0
	and.l	d0,d2			; d2 = xxAPxxxx RLDUxxxx xxxxxxxx xxxxxxxx
	move.w	#$81fd,(a0)
	move.l	(a0),d0			; Read *741 keys, B button
	or.l	d1,d0			; Mask off unused bits
	ror.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxxxxxxx xxxxxxxx
	move.w	#$81fb,(a0)
	move.l	(a0),d0			; Read 2580 keys, C button
	or.l	d1,d0			; Mask off unused bits
	rol.l	#6,d0
	rol.l	#6,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxxx 2580xxxx
	move.w	#$81f7,(a0)
	move.l	(a0),d0			; Read 369# keys, Option button
	or.l	d1,d0			; Mask off unused bits
	rol.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== inputs active low

	moveq.l	#-1,d1
	eor.l	d2,d1			; d1 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== now inputs active high

	move.l	joy1cur,d0		; old joycur needed for determining the new joyedge
	move.l	d1,joy1cur		; Current joypad reading stored into joycur
	eor.l	d1,d0

	and.l	d1,d0			; IF DESIRED (AS DOCUMENTED ABOVE)
					; REMOVE THIS AND
	
	move.l	d0,joy1edge		;joypad, buttons, keys that were just pressed

;scan for player 2
	move.l	#$0ffffff3,d1		; d1 = Joypad data mask
	moveq.l	#-1,d2			; d2 = Cumulative joypad reading

	move.w	#$817f,(a0)
	move.l	(a0),d0			; Read joypad, pause button, A button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	ror.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxxx RLDUxxxx xxxxxxxx xxxxxxxx
	move.w	#$81bf,(a0)
	move.l	(a0),d0			; Read *741 keys, B button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	ror.l	#8,d0
	ror.l	#4,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxxxxxxx xxxxxxxx
	move.w	#$81df,(a0)
	move.l	(a0),d0			; Read 2580 keys, C button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	rol.l	#8,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxxx 2580xxxx
	move.w	#$81ef,(a0)
	move.l	(a0),d0			; Read 369# keys, Option button
	or.l	d1,d0			; Mask off unused bits
	rol.b	#2,d0			; note the size of rol
	rol.l	#4,d0
	and.l	d0,d2			; d2 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== inputs active low

	moveq.l	#-1,d1
	eor.l	d2,d1			; d1 = xxAPxxBx RLDU741* xxCxxxOx 2580369# <== now inputs active high

	move.l	joy2cur,d0		; old joycur needed for determining the new joyedge
	move.l	d1,joy2cur		; Current joypad reading stored into joycur
	eor.l	d1,d0

	and.l	d1,d0			; IF DESIRED (AS DOCUMENTED ABOVE)
					; REMOVE THIS AND

	move.l	d0,joy2edge		;joypad, buttons, keys that were just pressed
	movem.l	(sp)+,d0-d2/a0
	rts
		