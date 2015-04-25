	move.l	#animation_dts,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000003,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#1,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000002,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#1,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000001,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#1,(a0)+	
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000001,(a0)+	
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#-1,(a0)+		
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000002,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#-1,(a0)+	
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000003,(a0)+	
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#-1,(a0)+	
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.w	#ANI_CHANGE_PTR,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE,d0
	move.l	d0,(a0)+
	move.l	#animation_dts,(a0)		

;####################################
	move.l	#animation_dts_shadow,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000003,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#1,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000002,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#1,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000001,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#1,(a0)+	
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000001,(a0)+	
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#-1,(a0)+		
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000002,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#-1,(a0)+	
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000003,(a0)+	
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#-1,(a0)+	
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#4-1,(a0)+

	move.w	#ANI_CHANGE_PTR,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE,d0
	move.l	d0,(a0)+
	move.l	#animation_dts_shadow,(a0)		

;####################################	
	move.l	#animation_jagware,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w	#ANI_CHANGE_XPOS,d0
	swap	d0
	move.w	#1,d0
	move.l	d0,(a0)+
	move.l	#-1,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#16-1,(a0)+
	
	move.w	#ANI_CHANGE_XPOS,d0
	swap	d0
	move.w	#1,d0
	move.l	d0,(a0)+
	move.l	#1,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#16-1,(a0)+

	move.w	#ANI_CHANGE_PTR,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE,d0
	move.l	d0,(a0)+
	move.l	#animation_jagware,(a0)
;####################################
	; move left animation
	move.l	#animation_element_left,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000002,(a0)+
	
	move.w	#ANI_CHANGE_XPOS,d0
	swap	d0
	move.w	#1,d0	
	
	move.l	d0,(a0)+
	move.l	#-1,(a0)+	
	move.l	d0,(a0)+
	move.l	#-2,(a0)+	
	move.l	d0,(a0)+
	move.l	#-3,(a0)+	
	move.l	d0,(a0)+
	move.l	#-4,(a0)+	
	move.l	d0,(a0)+
	move.l	#-5,(a0)+	
	move.l	d0,(a0)+
	move.l	#-1,(a0)+	

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+

	; move right animation	
	move.l	#animation_element_right,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000002,(a0)+
	
	move.w	#ANI_CHANGE_XPOS,d0
	swap	d0
	move.w	#1,d0	
	
	move.l	d0,(a0)+
	move.l	#1,(a0)+	
	move.l	d0,(a0)+
	move.l	#2,(a0)+	
	move.l	d0,(a0)+
	move.l	#3,(a0)+	
	move.l	d0,(a0)+
	move.l	#4,(a0)+	
	move.l	d0,(a0)+
	move.l	#5,(a0)+	
	move.l	d0,(a0)+
	move.l	#1,(a0)+	

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; move up animation	
	move.l	#animation_element_up,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000002,(a0)+
	
	move.w	#ANI_CHANGE_YPOS,d0
	swap	d0
	move.w	#1,d0	
	
	move.l	d0,(a0)+
	move.l	#-1,(a0)+	
	move.l	d0,(a0)+
	move.l	#-2,(a0)+	
	move.l	d0,(a0)+
	move.l	#-3,(a0)+	
	move.l	d0,(a0)+
	move.l	#-4,(a0)+	
	move.l	d0,(a0)+
	move.l	#-5,(a0)+	
	move.l	d0,(a0)+
	move.l	#-1,(a0)+	

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; move down animation	
	move.l	#animation_element_down,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000002,(a0)+
	
	move.w	#ANI_CHANGE_YPOS,d0
	swap	d0
	move.w	#1,d0	
	
	move.l	d0,(a0)+
	move.l	#1,(a0)+	
	move.l	d0,(a0)+
	move.l	#2,(a0)+	
	move.l	d0,(a0)+
	move.l	#3,(a0)+	
	move.l	d0,(a0)+
	move.l	#4,(a0)+	
	move.l	d0,(a0)+
	move.l	#5,(a0)+	
	move.l	d0,(a0)+
	move.l	#1,(a0)+	

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; move cursor left animation
	move.l	#animation_select_left,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w	#ANI_CHANGE_XPOS,d0
	swap	d0
	move.w	#1,d0
	move.l	d0,(a0)+
	move.l	#-2,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#8-1,(a0)+

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; move cursor right animation
	move.l	#animation_select_right,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w	#ANI_CHANGE_XPOS,d0
	swap	d0
	move.w	#1,d0
	move.l	d0,(a0)+
	move.l	#2,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#8-1,(a0)+

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; move cursor up animation
	move.l	#animation_select_up,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w	#ANI_CHANGE_YPOS,d0
	swap	d0
	move.w	#1,d0
	move.l	d0,(a0)+
	move.l	#-2,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#8-1,(a0)+

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; move cursor down animation
	move.l	#animation_select_down,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w	#ANI_CHANGE_YPOS,d0
	swap	d0
	move.w	#1,d0
	move.l	d0,(a0)+
	move.l	#2,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#8-1,(a0)+

	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; you win tiles animation
	move.l	#animation_tiles_win1,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000001,(a0)+
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-1 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-1 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-1 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-2 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-2 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-2 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-3 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #-3 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2121,(a0)+
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #1 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2222,(a0)+
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #1 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2323,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #1 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2424,(a0)+
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #2 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2525,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #2 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2727,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #2 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2929,(a0)+
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #3 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F2C2C,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #3 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F3030,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #4 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F3535,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #4 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F4040,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #5 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F4545,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #6 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F5050,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #6 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F5555,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #7 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F6060,(a0)+		
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #8 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #9 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F6565,(a0)+	
	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #10 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #10 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #$001F7F7F,(a0)+	

	
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #11 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #12 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #13 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #14 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #15 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #16 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #17 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #19 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #20 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #21 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #22 ,(a0)+
	move.w #ANI_CHANGE_YPOS,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0
	move.l d0,(a0)+
	move.l #24 ,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #0 ,(a0)+
	
	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+

;###############################
	move.l	#animation_right_clap,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0

	move.l d0,(a0)+
	move.l #$001F2626,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2525,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2424,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2323,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2222,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2121,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2020,(a0)+		
	
	move.l d0,(a0)+
	move.l #$001F2121,(a0)+		
	move.l d0,(a0)+
	move.l #$001F2222,(a0)+		
	move.l d0,(a0)+
	move.l #$001F2323,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2424,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2525,(a0)+	
	move.l d0,(a0)+
	move.l #$001F2626,(a0)+	

	move.w	#ANI_CHANGE_PTR,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE,d0
	move.l	d0,(a0)+
	move.l	#animation_right_clap,(a0)	

;###############################
	move.l	#animation_left_clap,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0

	move.l d0,(a0)+
	move.l #$001F1717,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1818,(a0)+
	move.l d0,(a0)+
	move.l #$001F1919,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1A1A,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1B1B,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1C1C,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1D1D,(a0)+		

	move.l d0,(a0)+
	move.l #$001F1C1C,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1B1B,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1A1A,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1919,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1818,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1717,(a0)+	

	move.w	#ANI_CHANGE_PTR,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE,d0
	move.l	d0,(a0)+
	move.l	#animation_left_clap,(a0)	
	
;####################################
	; tiny zoom for tiles
	move.l	#animation_tiles_zoom,a0	
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000000,(a0)+
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #1<<BIT_BLOCKING,d0

	move.l d0,(a0)+
	move.l #$001F1717,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1818,(a0)+
	move.l d0,(a0)+
	move.l #$001F1919,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1A1A,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1B1B,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1C1C,(a0)+	
	move.l d0,(a0)+
	move.l #$001F1D1D,(a0)+	
	
	move.w #ANI_CHANGE_SCALE,d0
	swap d0
	move.w #0,d0
	move.l d0,(a0)+
	move.l #0 ,(a0)+
	
	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; animation_timemark_up
	move.l	#animation_timemark_up,a0
	
	move.w	#ANI_SPEED,d0
	swap	d0
	move.w	#0,d0
	move.l	d0,(a0)+
	move.l	#$00000019,(a0)+
	
	move.w	#ANI_CHANGE_YPOS,d0
	swap	d0
	move.w	#1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#-1,(a0)+
	
	move.w	#ANI_CHANGE_PTR,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE,d0
	move.l	d0,(a0)+
	move.l	#animation_timemark_up,(a0)	

	; animation_timemark_up
	move.l	#animation_timemark_down,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000001,(a0)+
	
	move.l	#ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#1,(a0)+
	
	move.w	#ANI_REPEAT,d0
	swap	d0
	move.w	#-16,d0
	move.l	d0,(a0)+
	move.l	#20,(a0)+
	
	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+

	; animation_cos_up
	move.l	#animation_cos_up,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000000,(a0)+
	
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-22 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-21 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-20 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-19 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-17 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-16 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-15 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-14 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-13 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-12 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-11 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-10 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-10 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-9 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-8 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-7 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-6 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-6 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-5 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-4 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-4 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-3 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-3 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-2 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-2 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-2 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-1 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-1 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #-1 ,(a0)+
	
	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; animation_cos_down
	move.l	#animation_cos_down,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000000,(a0)+
	
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #1 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #1 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #1 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #2 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #2 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #2 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #3 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #3 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #4 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #4 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #5 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #6 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #6 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #7 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #8 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #9 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #10 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #10 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #11 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #12 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #13 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #14 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #15 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #16 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #17 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #19 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #20 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #21 ,(a0)+
	move.l #ANI_CHANGE_YPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l #22 ,(a0)+
	
	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+	
	
	; animation_cos_right
	move.l	#animation_cos_right,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000000,(a0)+
	
	move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #2,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #2,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #2,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #3,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #3,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #3,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #4,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #4,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #4,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #5,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #5,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #6,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #6,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #6,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #7,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #7,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #8,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #8,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #9,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #10,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #10,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #11,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #11,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #9,(a0)+
	
	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+
	
	; animation_cos_left
	move.l	#animation_cos_left,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000000,(a0)+
	
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-1,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-2,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-2,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-2,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-3,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-3,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-3,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-4,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-4,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-4,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-5,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-5,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-6,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-6,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-6,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-7,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-7,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-8,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-8,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-9,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-10,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-10,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-11,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-11,(a0)+
move.l #ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
move.l #-9,(a0)+
	
	move.w	#ANI_STOP,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE|1<<BIT_BLOCKING,d0
	move.l	d0,(a0)+
	move.l	#0,(a0)+	
	
	; animation_timeleft
	move.l	#animation_timeleft,a0
	
	move.l	#ANI_SPEED<<16,(a0)+
	move.l	#$00000019,(a0)+

	move.l	#ANI_CHANGE_XPOS<<16|1<<BIT_BLOCKING,(a0)+
	move.l	#-1,(a0)+
	
	move.w	#ANI_CHANGE_PTR,d0
	swap	d0
	move.w	#1<<BIT_ABSOLUTE,d0
	move.l	d0,(a0)+
	move.l	#animation_timeleft,(a0)	
	