op_create_dummy_list:
	movem.l a0-a1,-(sp)

	move.l	#sprite_list,a1
	; dummy sprite
	move.l	#dummy_bitmap,SPRITE_BITMAP(a1)
	move.l	#$00020002,SPRITE_WIDTH_HEIGHT(a1)
	move.w	#0,SPRITE_XPOS(a1)  
	move.w	#0,SPRITE_YPOS(a1)  
	move.l	a1,a0
	jsr	op_prepare_bitmap
	
	move.l	#1,num_sprite

	movem.l (sp)+,a0-a1
	rts


op_create_initial_list:
	movem.l 	d0/a0-a1,-(sp)

	; create common stop object
	lea		generic_op_stop,a1
	clr.l   (a1)+
	move.l  #(STOPOBJ),(a1)	
	
	; create default 2 branch object
	lea		dyn_object_list2,a0
	move.l	a0,secondary_object_list	
	jsr		op_create_branch
	
	; add stop object to our new list
	clr.l   (a0)+
	move.l  #(STOPOBJ),(a0)	
	
	; do the same with dyn_object_list1
	lea		generic_op_stop,a1
	lea		dyn_object_list1,a0
	move.l	a0,primary_object_list
	jsr		op_create_branch
	clr.l   (a0)+
	move.l  #(STOPOBJ),(a0)
	
	; Now return swapped list pointer in D0	
	lea		primary_object_list,a0
	move.l  (a0),d0	
	swap    d0
	move.l	d0,OLP
	
	move.l	#sprite_list,a1	
	
	; dummy sprite
	move.l	#dummy_bitmap,SPRITE_BITMAP(a1)
	move.l	#$00020002,SPRITE_WIDTH_HEIGHT(a1)
	move.w	#0,SPRITE_XPOS(a1)  
	move.w	#0,SPRITE_YPOS(a1)  
	move.l	a1,a0
	jsr	op_prepare_bitmap
	
	move.l	#1,num_sprite

	movem.l (sp)+,d0/a0-a1
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; create initial branch object
; a1 : addess of stop object
; a0 : current op list pointer; 
; no need to use stack
op_create_branch:	
	; create first branch objet
	; branch if VC > a_vde 
	; stop displaying sprite if VC reach the bottom
	; of the (visible) screen
	movem.l 	d0-d4,-(sp)
	
	move.l	a1,d2						; compute next object link
	make_op_link	d2,d3	
	clr.l	d0
	or.l	d2,d0	
	
	move.l  #(BRANCHOBJ|O_BRLT),d1  	; VC < VDE
	move.w  a_vde,d4                	; for YPOS
	or.l	d3,d1						; Do LINK overlay
	lsl.w   #3,d4                   	; Make it bits 13-3
	or.w    d4,d1
	
	move.l	d0,(a0)+					; store object
	move.l	d1,(a0)+

	; create second branch objet
	; branch if VC < a_vdb 
	; stop displaying sprite if VC is less than the begin 
	; of the (visible) screen
	move.l  #(BRANCHOBJ|O_BRGT),d1  	; VC > VDB
	move.w  a_vdb,d4                	; for YPOS
	or.l	d3,d1						; Do LINK overlay
	lsl.w   #3,d4                   	; Make it bits 13-3
	or.w    d4,d1
	
	move.l	d0,(a0)+					; store object
	move.l	d1,(a0)+
	
	movem.l (sp)+,d0-d4	
	rts	
_op_create_branch:	

op_prepare_next_sprite:
	movem.l d0/a1,-(sp)
	move.l	#SPRITE_STRUCT_SIZE,d0	
	ror.l	#2,d0
.clear_current_sprite_struct_size:	
	move.l	#0,(a1)+
	dbra	d0,.clear_current_sprite_struct_size
	movem.l (sp)+,d0/a1	
	rts

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; create initial branch object
; a0 : addess of current sprite structure
; no need to use stack	
op_prepare_bitmap:
	movem.l d0-d4/a0,-(sp)
	
	clr.l	d0
	clr.l	d1

	; 1st phrase
	move.l	SPRITE_WIDTH_HEIGHT(a0),d2		; set sprite height	
	and.l	#$0000FFFF,d2	
	move.l	d2,d3
	moveq	#14,d4
	lsl.l	d4,d3	
	or.l	d3,d1
	
	move.w	SPRITE_YPOS(a0),d4				; set sprite y pos	
	lsl.w   #1,d4 	
	andi.w 	#$FFFE,d4               		; Must be even
	lsl.w   #3,d4
	or.w    d4,d1                   
	
	move.l	SPRITE_BITMAP(a0),d4		; Set bitmap address
	lsl.l	#8,d4
	or.l	d4,d0

	movem.l	d0-d1,(a0)	; anti atari bug SPRITE_OBJECT_1STPH(a0)
	
	; 2nd phrase
	move.l	SPRITE_WIDTH_HEIGHT(a0),d2
	move.l	d2,d0
	and.l	#$0000FFFF,d2					; height
	and.l	#$FFFF0000,d0
	swap	d0								; width	
	mulu	d0,d2							
	lsl.l	#1,d2							
	
	lsr.l	#2,d0
	move.w	d0,d3							; d3 contain BMP_PHRASES_PIC	
	lsr.l	#4,d0							; Only part of top LONG is IWIDTH
	move.l  #O_DEPTH16|O_NOGAP,d1   		; Bit Depth = 16-bit, Contiguous data
	
	move.w	SPRITE_XPOS(a0),d4				; set sprite y pos		
	or.w    d4,d1

	move.l	d3,d4
	moveq	#28,d2
	lsl.l	d2,d3
	moveq	#18,d2
	lsl.l	d2,d4
	or.l	d3,d4
	
	or.l	d4,d1		; DWIDTH|IWIDTH	
	ori.l	#O_TRANS,d0	; on place le bit de transparence	(par défaut)	
	
	movem.l	d0-d1,SPRITE_OBJECT_2NDPH(a0)	
	move.l	#0,SPRITE_ANIM_PTR(a0) ; security
	move.l	#0,SPRITE_OPTION(a0) ; security
	
	movem.l (sp)+,d0-d4/a0	
	rts

op_prepare_bitmap_8bit:
	movem.l d0-d4/a0,-(sp)
	
	clr.l	d0
	clr.l	d1

	; 1st phrase
	move.l	SPRITE_WIDTH_HEIGHT(a0),d2		; set sprite height	
	and.l	#$0000FFFF,d2	
	move.l	d2,d3
	moveq	#14,d4
	lsl.l	d4,d3	
	or.l	d3,d1
	
	move.w	SPRITE_YPOS(a0),d4				; set sprite y pos	
	lsl.w   #1,d4 	
	andi.w 	#$FFFE,d4               		; Must be even
	lsl.w   #3,d4
	or.w    d4,d1                   
	
	move.l	SPRITE_BITMAP(a0),d4		; Set bitmap address
	lsl.l	#8,d4
	or.l	d4,d0

	movem.l	d0-d1,(a0)	; anti atari bug SPRITE_OBJECT_1STPH(a0)
	
	; 2nd phrase
	move.l	SPRITE_WIDTH_HEIGHT(a0),d2
	move.l	d2,d0
	and.l	#$0000FFFF,d2					; height
	and.l	#$FFFF0000,d0
	swap	d0								; width	
	mulu	d0,d2							
	lsl.l	#6,d2							;/64
	
	lsr.l	#3,d0
	move.w	d0,d3							; d3 contain BMP_PHRASES_PIC	
	lsr.l	#4,d0							; Only part of top LONG is IWIDTH
	move.l  #O_DEPTH8|O_NOGAP,d1   		; Bit Depth = 8-bit, Contiguous data
	
	move.w	SPRITE_XPOS(a0),d4				; set sprite y pos		
	or.w    d4,d1

	move.l	d3,d4
	moveq	#28,d2
	lsl.l	d2,d3
	moveq	#18,d2
	lsl.l	d2,d4
	or.l	d3,d4
	
	or.l	d4,d1		; DWIDTH|IWIDTH	
	;ori.l	#O_TRANS,d0	; on place le bit de transparence	(par défaut)	
	
	movem.l	d0-d1,SPRITE_OBJECT_2NDPH(a0)	
	move.l	#0,SPRITE_ANIM_PTR(a0) ; security
	move.l	#0,SPRITE_OPTION(a0) ; security
	
	movem.l (sp)+,d0-d4/a0	
	rts
