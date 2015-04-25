;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; GPU SPRITE MANAGER
; 25/04/08 : utilisation de move	(r14+n),rn (optimisation) TROP BIEN !
; 18/10/08 : je commence à refaire tout le code pour pouvoir gérer une double liste d'objet
; 07/11/08 : Yesss, animation et object zoomés....cooolll

gpu_main_code:
.gpu
.org G_RAM	
	; From SCPCD : Code Def
    LE .ccdef %11000 ;plus petit ou egal
    LT .ccdef %11001 ;plus petit strict
    GT .ccdef %10101 ;plus grand strict
    GE .ccdef %10100 ;plus grand ou egal
	
	; register equ for main_sprite_loop
	; r0 to r7 are free to use in this bloc
	Game_Paused		.equr	r7 ; freely usable after test
	O_next			.equr	r8
	Anim_Jumper		.equr	r9
	S_animation		.equr	r10 ; animation pointer
	S_bitmap		.equr	r11 ; current DATA pointer
	S_width			.equr	r12
	S_height		.equr	r13	
	S_current		.equr	r14	; S = current Sprite 
	O_current		.equr	r15	; O = current Object
	S_option		.equr	r16
	S_xpos			.equr	r17
	S_ypos			.equr	r18
	O_phrase1_high	.equr	r20
	O_phrase1_low	.equr	r21
	O_phrase2_high	.equr	r22
	O_phrase2_low	.equr	r25
	
	; mask equ
	MASK_YPOS		.equ	$FFFFC007
	MASK_HEIGHT		.equ	$FF003FFF
	
	; From CD Bios	
CPU_VEC:	nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
	
DSP_VEC:	nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
	
PIT_VEC:	nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
		
OBJ_VEC:	nop
			nop
			nop
			nop
			nop
			nop
			nop
			nop
	
BLIT_VEC:	nop
			nop
			nop
			nop
			nop
			nop
			nop
	
real_gpu_code_start:

	; swap object list (primary<==>secondary)
	movei	#primary_object_list,r0
	movei	#secondary_object_list,r1
	load	(r0),r2 ; main dynamic list
	load	(r1),r3	; secondary dynamic list	
	store	r2,(r1)
	store	r3,(r0)	
	
	move	r3,O_current	; we are working on the second list
		
	; save word swapped pointer of primary_object_list to OLP
	rorq	#16,r2
	movei	#OLP,r4
	store	r2,(r4)
	
	; load some data for paused game
	movei	#game_paused,Game_Paused
	load	(Game_Paused),Game_Paused
	
	; inform we use the GPU
;	movei	#gpu_lock,r1
;	moveq	#1,r0
;	store	r0,(r1)
	
	; prepare some data for list creation	
	moveq	#0,r24	; r24 : sprite loop counter	
	moveq	#(PHRASE*2),O_next	
	movei	#sprite_list,S_current ; first sprite	
	addq	#(PHRASE*2),O_current	; jump over the 2 legacy branch objects	
.main_sprite_loop:	

	; first of all, load saved object (could use loadp instead ???)
	load	(S_current),O_phrase1_high
	load	(S_current+(SPRITE_OBJECT_1STPH+4)/4),O_phrase1_low
	load	(S_current+(SPRITE_OBJECT_2NDPH)/4),O_phrase2_high
	load	(S_current+(SPRITE_OBJECT_2NDPH+4)/4),O_phrase2_low
	
	; get option, xpos, ypos, width, height
	load	(S_current+(SPRITE_XPOS)/4),S_xpos	; load object's xpos and ypox	
	load	(S_current+(SPRITE_OPTION)/4),S_option	; load object'option and more	
	load	(S_current+(SPRITE_WIDTH_HEIGHT)/4),S_width; load width and height
	move	S_xpos,S_ypos
	move	S_width,S_height	
	sharq	#16,S_xpos
	shlq	#16,S_height
	shlq	#16,S_ypos
	shrq	#16,S_height
	sharq	#16,S_ypos
	shrq	#16,S_width
	
	; load old bitmap's adress
	load	(S_current+(SPRITE_BITMAP)/4),S_bitmap ; load bitmap address
	
	; manage animation loop
	load	(S_current+(SPRITE_ANIM_PTR)/4),S_animation ; load animation pointer
	movei	#.do_not_animate_now_or_end_animation,r23	
	cmpq	#0,Game_Paused
	jump	NE,(r23); so bypass animation loop	
	nop
	movei	#.begin_of_animation,r26	
	movei	#.blocking_test,Anim_Jumper
	cmpq	#0,S_animation ; animation pointer is null
	jump	EQ,(r23); so bypass animation loop	
	load	(S_current+(SPRITE_ANIM_SPEED)/4),r0 ; load animation counter
	move	r0,r1
	shrq	#16,r0 ; current
	shlq	#16,r1
	shrq	#16,r1 ; maximum
	addq	#1,r0 ; increment current
	cmp		r0,r1
	jr		CC,.updating_animation_speed
	nop
	store	r1,(S_current+(SPRITE_ANIM_SPEED)/4) ; save animation counter
	jr		T,.begin_of_animation
	nop
.updating_animation_speed:
	shlq	#16,r0
	or		r1,r0
	store	r0,(S_current+(SPRITE_ANIM_SPEED)/4) ; save animation counter
	jump	T,(r23)
	nop
	
.begin_of_animation:	
	load	(S_animation),r1 ; load command and looping information
	addq	#4,S_animation
	load	(S_animation),r2 ; load param2 (could be PTR or value)
	addq	#4,S_animation ; animation pointer is up to date !
	move	r1,r0
	move	r2,r3 ; for repeat	
	shrq	#16,r0 ; command
	shlq	#16,r1
	sharq	#16,r1 ; param1	
	shlq	#16,r3
	shrq	#16,r3 ; param1bis
.do_not_repeat_or_end_repeat:
	btst	#(SPRITE_ANIM_SIDE+24),S_option
	jr		EQ,.increment_animation_pointer_or_end
	nop
	subq	#16,S_animation ; animation pointer is up to date !	
.increment_animation_pointer_or_end:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;DESTROY OBJECT
	cmpq	#ANI_DESTROY,r0
	jr		NE,.do_not_delete_current_object
	nop
	;; clean next and prev ptr and jump to next object in list
	;; so object will be deleted and his current struct free for use
	;; just an idea
	subq	#(PHRASE*4),O_current
	movei	#._main_sprite_loop,r23
	jump	T,(r23) ; next
.do_not_delete_current_object:		

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE ANIMATION PTR
	cmpq	#ANI_CHANGE_PTR,r0
	jr		NE,.do_not_change_animation_ptr
	btst	#BIT_ABSOLUTE,r1
	jr		NE,.change_animation_ptr_absolute
	add		r2,S_animation
	nop
	move	S_animation,r2	
.change_animation_ptr_absolute:
	move	r2,S_animation
	jump	T,(Anim_Jumper)	
.do_not_change_animation_ptr:	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;HIDE SPRITE
	cmpq	#ANI_HIDE,r0 ; hide the sprite ?
	jr		NE,.do_not_hide
	nop
	movei	#0,S_height
	jump	T,(Anim_Jumper)
.do_not_hide:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE ANIMATION SPEED
	cmpq	#ANI_SPEED,r0 ; change speed ?
	jr		NE,.do_not_change_speed
	nop
	store	r2,(S_current+(SPRITE_ANIM_SPEED)/4)
	jump	T,(Anim_Jumper)
.do_not_change_speed:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE GLOBAL SCALE
	cmpq	#ANI_CHANGE_SCALE,r0 ; change bitmap scale ?
	jr		NE,.do_not_change_scale
	nop		; could be removed ?	
	store	r2,(S_current+(SPRITE_OBJECT_3THPH)/4)
	bset	#(SPRITE_OBJ_TYPE+24),S_option
	cmpq	#0,r2
	jr		NE,.do_not_stop_scaling_object
	nop
	bclr	#(SPRITE_OBJ_TYPE+24),S_option
.do_not_stop_scaling_object:	
	jump	T,(Anim_Jumper)
.do_not_change_scale:	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE BITMAP
	cmpq	#ANI_CHANGE_BITMAP,r0
	jr		NE,.do_not_change_bitmap
	btst	#BIT_ABSOLUTE,r1
	jr		NE,.change_bitmap_absolute
	add		r2,S_bitmap
	nop
	move	S_bitmap,r2 ; to remove a jump
.change_bitmap_absolute:	
	move	r2,S_bitmap
	store	r2,(S_current+(SPRITE_BITMAP)/4)
	jump	T,(Anim_Jumper)	
.do_not_change_bitmap:

;;;;;;;;;;;;;;;;;;;;;;;;;;REVERSE ANIMATION SIDE
	cmpq	#ANI_CHANGE_SIDE,r0 ; change side ?
	jr		NE,.do_not_change_side
	nop
	btst	#(SPRITE_ANIM_SIDE+24),S_option
	jr		EQ,.invert_side
	bclr	#(SPRITE_ANIM_SIDE+24),S_option
	jump	T,(Anim_Jumper)
	nop
.invert_side:
	bset	#(SPRITE_ANIM_SIDE+24),S_option
	subq	#16,S_animation
	jump	T,(r26) ; restart
.do_not_change_side:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE XPOS
	cmpq	#ANI_CHANGE_XPOS,r0
	jr		NE,.do_not_change_xpos
	btst	#BIT_ABSOLUTE,r1
	jr		NE,.change_xpos_absolute
	add		r2,S_xpos
	move	S_xpos,r2  ; to remove a jump
.change_xpos_absolute:	
	move	r2,S_xpos
	jump	T,(Anim_Jumper)
.do_not_change_xpos:	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;CHANGE YPOS
	cmpq	#ANI_CHANGE_YPOS,r0
	jr		NE,.do_not_change_ypos
	btst	#BIT_ABSOLUTE,r1
	jr		NE,.change_ypos_absolute
	add		r2,S_ypos
	move	S_ypos,r2  ; to remove a jump
.change_ypos_absolute:	
	move	r2,S_ypos
	jump	T,(Anim_Jumper)
.do_not_change_ypos:	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;REPEAT
	cmpq	#ANI_REPEAT,r0
	jr		NE,.do_not_repeat
	;nop	can be remove this one
	shrq	#16,r2 ; current
	addq	#1,r2 ; increment current
	cmp		r2,r3 ; compare to max
	jr		CC,.updating_repeat_counter
	nop
	moveq	#0,r2	
	moveq	#0,r1
.updating_repeat_counter:	
	shlq	#16,r2
	or		r2,r3
	subq	#4,S_animation
	store	r3,(S_animation)
	addq	#4,S_animation
	add		r1,S_animation	
.do_not_repeat:
	jump	T,(r23) ; next	
	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;; BLOCKING COMMAND TEST
.blocking_test:
	btst	#BIT_BLOCKING,r1 ; blocking ?
	jr		NE,.blocking
	nop
	jump	T,(r26) ; non blocking, go next frame
	nop ; this one could be removed
.blocking:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; END OF ANIMATION LOOP
.do_not_animate_now_or_end_animation:
	move	S_xpos,r0
	move	S_ypos,r1
	shlq	#16,r0
	shlq	#16,r1
	shrq	#16,r1
	store	S_option,(S_current+(SPRITE_OPTION)/4) ; save option
	or		r0,r1	
	store	S_animation,(S_current+(SPRITE_ANIM_PTR)/4) ; save animation pointer
	store	r1,(S_current+(SPRITE_XPOS)/4) ; save current xpos	
	
	; compute new xpos
	shrq	#12,O_phrase2_low		
	btst	#(SPRITE_MIRRORING+24),S_option
	jr		EQ,.no_need_to_do_reflect
	bclr	#13,O_phrase2_high	; always clear reflect bit
	bset	#13,O_phrase2_high ; set reflect bit
	add		S_width,S_xpos
.no_need_to_do_reflect:	
	shlq	#20,S_xpos
	shlq	#12,O_phrase2_low ; remove old xpos
	shrq	#20,S_xpos ; correct xpos format (if <0) for a 12 bit value
	or		S_xpos,O_phrase2_low
	
	; compute new ypos
	cmpq	#0,S_ypos
	jr		GE,.S_ypos_greater_or_equal_zero
	nop		
	add		S_ypos,S_height	; new height		
	imult	S_ypos,S_width ; get size of line to pass			
	sub		S_width,S_bitmap ; update data pointer	
	movei	#0,S_ypos
.S_ypos_greater_or_equal_zero:	
	movei	#MASK_YPOS,r0
	shlq	#4,S_ypos ;3 +1 for half-line tips
	and		r0,O_phrase1_low ; remove old ypos	
	or		S_ypos,O_phrase1_low	
	
	; compute new ypos	
;	movei   #a_vdb,r0 ; load first line displayed
;   load    (r0),r0		
;	shlq	#1,S_ypos ; half-line tips
;	move	r0,r1 ; save it	
;	sub		S_ypos,r0 ; Half screen lines outside visible area ?
;   jr		PL,.line_outside_visible_area ; yes 
;    nop
;   moveq   #0,r1 ; No screen lines outside the visible area
;    jr    	T,.end_compute_new_ypos
;    nop
;.line_outside_visible_area:
;    move    r1,S_ypos ; S_ypos becom a_vdb
;    shrq    #1,r0 ; Entire screen lines outside visible area
;	add		S_ypos,S_height	; new height		
;	imult	S_ypos,S_width ; get size of line to pass		
;	sub		S_width,S_bitmap ; update data pointer	
;	movei	#0,S_ypos ; ypos become 0	

;.end_compute_new_ypos:
;	movei	#MASK_YPOS,r0
;	shlq	#3,S_ypos ;3 +1 for half-line tips
;	and		r0,O_phrase1_low ; remove old ypos	
;	or		S_ypos,O_phrase1_low	
	

	; we now must correct the next object link (to the stop or to the next bitmap object)	
	move	O_current,r0	
	
	; is this a scaled bitmap ?
	movei	#.this_is_not_a_scaled_bitmap,r23
	btst	#(SPRITE_OBJ_TYPE+24),S_option
	jump	EQ,(r23)
	add		O_next,r0 ; add 2 phrases for 1st object, 4 for others
	
	subq	#1,S_height
	movei	#0,r1
	load	(S_current+(SPRITE_OBJECT_3THPH)/4),r2	
	store	r1,(O_current+(SPRITE_OBJECT_3THPH)/4)				
	store	r2,(O_current+(SPRITE_OBJECT_3THPH+4)/4)
	bset	#0,O_phrase1_low	; set scaled object type
.this_is_not_a_scaled_bitmap:	

	move	r0,r1	; copy address
	move	r0,r2	; copy address
	shrq	#8,O_phrase1_high
	shlq	#8,O_phrase1_high ; now there's some place for link's low bit
	shlq	#11,O_phrase1_low
	shrq	#11,O_phrase1_low ; now there's some place for link's high bit	
	shrq	#11,r0 ; r0 contain high bit (bit 32-42)
	shlq	#21,r1 ; r1 contain low bit (bit 24-31)
	or		r0,O_phrase1_high
	or		r1,O_phrase1_low	
	
	; correct DATA
	shlq	#20,O_phrase1_high
	shrq	#20,O_phrase1_high
	shlq	#8,S_bitmap	; move DATA (63-43)
	or		S_bitmap,O_phrase1_high	
	
	; correct height
	movei	#MASK_HEIGHT,r0
	and		r0,O_phrase1_low
	shlq	#14,S_height
	or		S_height,O_phrase1_low
	
	; finaly we store our new object in the current list
	store	O_phrase1_high,(O_current)
	store	O_phrase1_low,(O_current+(SPRITE_OBJECT_1STPH+4)/4)
	store	O_phrase2_high,(O_current+(SPRITE_OBJECT_2NDPH)/4)
	store	O_phrase2_low,(O_current+(SPRITE_OBJECT_2NDPH+4)/4)
	
._main_sprite_loop:
	movei	#num_sprite,r1
	movei	#.main_sprite_loop,r23			; r23 : adresse of loop	
	load	(r1),r0
	movei	#SPRITE_STRUCT_SIZE,r1
	addq	#1,r24
	add		O_next,O_current
	movei	#(PHRASE*4),O_next
	add		r1,S_current
	cmp		r0,r24
	jump	NE,(r23)
	nop		
	
	
	; we finaly add a stop object to our new list
	moveq	#0,r0
	moveq	#STOPOBJ,r1
	store	r0,(O_current)
	store	r1,(O_current+LONG/4)	

	; inform we don't use the GPU
	movei	#gpu_lock,r2
	moveq	#0,r0
	store	r0,(r2)	

	; GPU must running for CD Bios
	; so we wait for the next gpu_lock
	movei	#real_gpu_code_start,r1
gpu_loop:
	load	(r2),r0
	nop	
	cmpq	#0,r0
	jump	NE,(r1)
	nop
	jr	gpu_loop
	nop	
	
	
	
	; this should never happen
.now_stop_the_gpu:	
    moveq #0,r30
    movei #G_CTRL,r31
    store r30,(r31)
	nop

	; GPU local data
	.long
gpu_lock:	dc.l	1  ; ensure GPU has done his job on the current sprite list
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
.68000
_gpu_main_code:
gpu_main_code_size 	equ	4096-(_gpu_main_code-gpu_main_code)
.print	"GPU Free Ram size : ", gpu_main_code_size, " Bytes"

; need blank line for aln