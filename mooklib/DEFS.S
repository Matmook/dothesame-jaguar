BYTE				.equ	1
WORD				.equ	2
LONG				.equ	4
PHRASE				.equ	8

MAXNUMSPRITE		.equ	128	; nbr max de sprite
GPU_COMMON_RAM		.equ	$F03F40

; SPRITE STRUCTURE
SPRITE_OBJECT_ADR	.equ	0	; alias
SPRITE_OBJECT_SAVE	.equ	0	; alias
SPRITE_OBJECT_1STPH	.equ	0	; Object's phrase copy (for direct modification)
SPRITE_OBJECT_2NDPH	.equ	8
SPRITE_OBJECT_3THPH	.equ	16
SPRITE_BITMAP		.equ	20	; current bitmap used (for y
SPRITE_XPOS			.equ	24	; current X position
SPRITE_YPOS			.equ	26	; current Y position
SPRITE_WIDTH_HEIGHT	.equ	28	; Sprite size XXXX YYYY
SPRITE_OBJECT_PREV	.equ	32	; previous object in list (chained list ?)
SPRITE_OBJECT_NEXT	.equ	36	; next object in list (chained list ?)
SPRITE_ANIM_PTR		.equ	40	; pointer to animation stucture
SPRITE_ANIM_SPEED	.equ	44	; current / max in word
SPRITE_OPTION		.equ	48	; option flag
; | SPRITE OPTION'S BITs
SPRITE_OBJ_TYPE		.equ	0	; 1 for scaled bitmap, 0 for normal bitmap
SPRITE_ANIM_SIDE	.equ	1	; animation side (up/down in the array)
SPRITE_MIRRORING	.equ	2	; reverse sprite
; |
SPRITE_STRUCT_SIZE	.equ	52	; Size of Sprite

; ANIMATION STRUCTURE
ANIMATION_COMMAND	.equ	0
; | command list

ANI_HIDE			.equ	1
ANI_SPEED			.equ	2
ANI_DESTROY			.equ	6 ; destroy object !
ANI_CHANGE_BITMAP	.equ	3
ANI_CHANGE_PTR		.equ	4
ANI_STOP			.equ	4 ; alias
ANI_CHANGE_SIDE		.equ	5
ANI_CHANGE_XPOS		.equ	7
ANI_CHANGE_YPOS		.equ	8
ANI_REPEAT			.equ	9
ANI_CHANGE_SCALE	.equ	10
ANI_CHANGE_VSCALE	.equ	12
ANI_CHANGE_HSCALE	.equ	13
; | 
ANIMATION_PARAM1	.equ	2
; | option bit
BIT_BLOCKING		.equ 0
BIT_ABSOLUTE		.equ 1
; |
ANIMATION_PARAM2	.equ	4 ; ptr or relative value or other
ANIMATION_STRUCT_SIZE	.equ	8

; FONT STRUCTURE
FONT_BITMAP			.equ	0		; this structure's address
FONT_BLITTER_FLAG	.equ	4		; #PIXEL16|PITCH1|WID8
FONT_BCOUNT			.equ	8		; width / height
FONT_STRUCT_SIZE	.equ	12

; FONT CONTEXT STRUCT
FONT_CONTEXT_BITMAP	.equ	0		; this structure's address
FONT_CONTEXT_BLITTER_FLAG	.equ	4		; #PIXEL16|PITCH1|WID320
FONT_CONTEXT_NEXTLINE		.equ	8
FONT_CONTEXT_CHAR_PATCH		.equ	12
FONT_CONTEXT_STRUCT_SIZE	.equ	14
