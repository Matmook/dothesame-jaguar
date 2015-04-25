;**************************************************************************
; (C)1993 ATARI CORP.       SECRET & CONFIDENTIAL       ALL RIGHTS RESERVED
;
;         CD.INC
;
;                                REVISION HISTORY
;
; REV.  DATE       BY            DESCRIPTION OF EDIT
; """"  """"       ""            """""""""""""""""""
; 1.00  20 Apr 94  LJT   First Release
; 1.01  24 May 94  LJT   Added CD_getoc
; 1.02  31 May 94  LJT   Added err_flag
; 1.03  16 Nov 94  LJT   Added CD_initm & CD_initf
;**************************************************************************

; Jump table to ALL of the functions

CD_init         EQU $3000	;$3000
CD_mode         EQU CD_init+6	;$3006
CD_ack          EQU CD_mode+6	;$300c
CD_jeri         EQU CD_ack+6	;$3012
CD_spin         EQU CD_jeri+6	;$3018
CD_stop         EQU CD_spin+6	;$301e
CD_mute         EQU CD_stop+6	;$3024
CD_umute        EQU CD_mute+6	;$302a
CD_paus         EQU CD_umute+6	;$3030
CD_upaus        EQU CD_paus+6	;$3036
CD_read         EQU CD_upaus+6	;$303c
CD_uread        EQU CD_read+6	;$3042
CD_setup        EQU CD_uread+6	;$3048
CD_ptr          EQU CD_setup+6	;$304e
CD_osamp        EQU CD_ptr+6	;$3054
CD_getoc        EQU CD_osamp+6	;$305a
CD_initm        EQU CD_getoc+6	;$3060
CD_initf        EQU CD_initm+6	;$3066
CD_switch       EQU CD_initf+6	;$306c

err_flag        EQU $3e00

CD_toc          EQU $2c00

BIOS_VER        EQU $3004
