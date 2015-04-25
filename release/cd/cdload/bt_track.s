;*****************************************************************************
;*****************************************************************************
;*** BT_TRACK.S
;***
;*** Atari Jaguar CD Bootrack
;***
;*** 20070112: Matthias Domin, based on a disassembled boottrack
;***
;*****************************************************************************
;*****************************************************************************

.include "jaguar.inc"
.include "cd.inc"


; Adjust these values:
GAME_LOADADDRESS    EQU $004000
GAME_STARTADDRESS   EQU $004000
GAME_FILELENGTH     EQU $C8000
						 

TRACKMARKER         EQU 'TRAK'




 TEXT 
Begin:
    move.l  #$70007,G_END
    movea.l #$1ffff0,A7           ; Set Stackpointer


;-----------------------------------------------------------------------
; CD-ROM init
;-----------------------------------------------------------------------
cd: move.w  #$1865,$f00000
    ;nop
    ;nop
    move.l  #0,$dfff00            ; Switch of CD-Boot-image!
    ;nop
    ;nop


    jsr     CD_setup.w          ; Always call this first for CDs!

    move.w  #3,D0               ; Set mode to data, 2X speed
    jsr     CD_mode.w 


    ; Move GPU-code into GPU-RAM
    movea.l #GPUCODE_START,A0
    movea.l #GPUCODE_END,A1
    move.l  A0,D1 
    move.l  A1,D0 
    sub.l   D1,D0			    ; length of GPU-code 
    asr.l   #2,D0 
    movea.l #G_RAM,A1
L0000:
    move.l  (A0)+,(A1)+ 
    dbf     D0,L0000

    movea.l #$F030C4,A0         ; where to store the requested read-function 
    jsr     CD_initm.w

    move.l  #$F03050,G_PC
    move.l  #1,G_CTRL           ; start GPU

    ; search 2. track of 2. session (?)
    movea.l #CD_toc,A0
    lea     8(A0),A1
    move.b  3(A0),D1
    sub.b   #1,D1 
    ext.w   D1
    move.w  #100,D3 
L0001:
    sub.b   #1,D1 
    beq     L0002       ; second session? 
    adda.l  #8,A0 
    move.b  4(A0),D0
    cmp.b   #1,D0 
    bne.s   L0001 
    move.b  (A0),D0 
    cmp.b   D0,D3 
    blt.s   L0001 
    move.b  D0,D3 
    movea.l A0,A1 
    bra.s   L0001 

L0002:
    addq.b  #1,D3
    movea.l #CD_toc,A0
L0003:
    adda.l  #8,A0 
    move.b  4(A0),D0
    cmp.b   #1,D0 
    bne.s   L0003               ; second track? 
    move.b  (A0),D0
    cmp.b   D3,D0 
    bne.s   L0003
 
    ; Store the MM:SS:FF in d0 for boot track
    move.l  (A0),D0 
    and.l   #$FFFFFF,D0         ; Mask off irrelevant MSB 
    sub.b   #6,D0               ; start 6 frames prior of desired frame (see docs)
    bcc     L0004

    ; Handle wrap
    add.b   #75,D0              ; 75 frames per second 
    sub.w   #$100,D0
    bcc     L0004 
    add.w   #$3C00,D0           ; 256 * 60 
    sub.l   #$10000,D0

L0004:
    movea.l #GAME_LOADADDRESS,A0           ; beginning of destination buffer 
    movea.l #GAME_LOADADDRESS+GAME_FILELENGTH,A1          ; end of destination buffer
    move.l  #TRACKMARKER,D1          ; Track-marker
    moveq   #0,D2 
    jsr     CD_read.w

      ; Did read complete OK?
L0005:
    jsr     CD_ptr.w
    cmpa.l  #GAME_LOADADDRESS+GAME_FILELENGTH,A0          ; end reached?
    ble.s   L0005               ; no, so wait

    ; Stop GPU-process
    move.l  G_CTRL,D0
    bset    #2,D0 
    move.l  D0,G_CTRL


;   Uncomment these 2 lines if you want to stop the CD
;   before you start the loaded program
    moveq   #1,d0               ; Wait until call completes
    jsr     CD_stop

    ; And now jump to the code read from CD
    jmp     GAME_STARTADDRESS




    dc.b    $4A,$FC,$00,$00,$00,$00
GPUCODE_START:
    dc.b    $98,$1E 
    dc.b    $30,$68,$00,$F0,$D3,$C0,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$E4,$00 
    dc.b    $E4,$00,$E4,$00,$E4,$00,$98,$00 
    dc.b    $21,$00,$00,$F0,$A4,$01,$38,$81 
    dc.b    $BC,$01,$98,$1F,$30,$C4,$00,$F0 
    dc.b    $E4,$00,$D7,$C0,$E4,$00,$8C,$1E 
    dc.b    $39,$3E,$98,$1D,$21,$00,$00,$F0 
    dc.b    $BF,$BE,$8C,$1E,$98,$1D,$21,$14 
    dc.b    $00,$F0,$BF,$BE,$E4,$00,$E4,$00
    dcb.w   147,0 	; to reserve space for CD_initx ???
GPUCODE_END:

 END
