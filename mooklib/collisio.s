;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; a0 containt first obecjt
; a1 containt second obejct
; d0 is trashed and contain 1 if collision of 0 if not
collision_detection_68k:		
	movem.l 	d1-d3/a0-a1,-(sp)
	
	
	;The basic idea is to check if the X position of the first object + its width is lower than the xpos of the second object, 
	; and to check if the X position of 	the first object is greater than the X position of the second object + its width.
	; If one of these cases are true, there is no collision. Otherwise there is.
	; You need to do the same with Y position as well of course. 
	
	move.w	SPRITE_XPOS(a0),d0
	move.w	SPRITE_XPOS(a1),d2
	
	move.l		SPRITE_WIDTH_HEIGHT(a0),d1
	swap		d1
	move.l		SPRITE_WIDTH_HEIGHT(a1),d3
	swap		d3
	
	; test x1+width1<x2
	add.w		d0,d1	
	cmp.w		d1,d2
	bgt.s		.no_collision	
	; test x1>width2+x2
	add.w		d2,d3	
	cmp.w		d0,d3
	blt.s		.no_collision
	
	swap	d1
	swap	d3
	move.w	SPRITE_YPOS(a0),d0
	move.w	SPRITE_YPOS(a1),d2
	
	; test y1+height1<y2
	add.w		d0,d1	
	cmp.w		d1,d2
	bgt.s		.no_collision	
	; test y1>height2+y2
	add.w		d2,d3	
	cmp.w		d0,d3
	blt.s		.no_collision
	
.collision:
	;move.w	#$FF,BG
	move.w	#1,d0
	bra.s	.end_collision_test
.no_collision:	
	move.w	#0,d0
.end_collision_test:
	movem.l 	(sp)+,d1-d3/a0-a1
	rts
_collision_detection_68k_68k:		

