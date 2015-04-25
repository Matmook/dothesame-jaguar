; *************************************
; * Jaguar Soundtracker Module Player *
; * (c) 1995 Sinister Developments    *
; *************************************
;
; * Last update : 08/12/95
;
; * To initialise DSP etc. JSR PLAYER+$0
;   (Always do this before setting up new modules etc.)
;
; * To setup a new module load start address to A0 and JSR PLAYER+$4
;   (Sound channels 1-4 are automatically cleared when a new module is setup)
;
; * In the VBL routine JSR PLAYER+$8
;   (A 50/60 hz speed adjustment is already included)
;
; * To playback a sample JSR PLAYER+$c with the following parameters:
;   D0=Sample length
;   D1=Sample looping length (or 0 for normal sample)
;   D2=Sample Priority (0=highest, $ffff=lowest)
;   (An equal priority sample will replace an existing one)
;   D3=Sample volume (or 0 for default, set by JSR PLAYER+$18)
;   D4=Sample Frequency (or 0 for $1ac default)
;   A0=Sample start address
;   A1=Sample looping start address (or 0 for normal sample)
;   Sample playback channel (5-8) is returned in D0, or 0 if sample was not played
;   Sample format is 16Khz, 8 bit mono, signed (use goldwave and save as raw)
;   Routine Returns d0=0 - No sample played (priority too low)
;   Routine Returns d0=5,6,7,8 - sample played on this channel
;
; * To modify the volume and/or frequency of a sample currently being played
;   JSR PLAYER+$24 with the following parameters:
;   D0=Channel Number
;   D1=New volume (or 0 to leave unchanged)
;   D2=New Frequency (or 0 to leave unchanged)
;
; * To clear and release sound channels load first channel to clear in D0 and
;   number of channels to clear in D1, then JSR PLAYER+$10
;   (eg. To clear all 8 channels set D0=1,D1=8, to clear only sample channels
;   set D0=5,D1=4 etc.)
;   (Note: If a module is still playing (ie. the vbl module player is enabled)
;   there's no point in clearing channels 1-4 'cause another sample will be
;   played on the next vbl anyway!)
;
; * To set the music volume load D0=0 to $ff, then JSR PLAYER+$14
;
; * To set sample volume load D0=0 to $ff, then JSR PLAYER+$18
;
; * To enable the vbl module player JSR PLAYER+$1c
;   (This is enabled as default by the setup new mod call, JSR PLAYER+$4)
;
; * To disable the vbl module player JSR PLAYER+$20
;   (Samples can still be played on channels 5-8, but no music will play on
;   channels 1-4)
;
; * All registers are saved/restored as required on entry/exit of each routine
;

                .text
                bra             setup_dsp               ; +$00
                bra             init_new_mod            ; +$04
                bra             vbl_handler             ; +$08
                bra             play_sample             ; +$0c
                bra             clear_channels          ; +$10
                bra             set_mus_volume          ; +$14
                bra             set_efx_volume          ; +$18
                bra             enable_music            ; +$1c
                bra             disable_music           ; +$20
                bra             modify_channel          ; +$24

                .dc.b           "ATARI JAGUAR SOUNDTRACKER MODULE PLAYER "
                .dc.b           "COPYRIGHT (C) 1995 SINISTER DEVELOPMENTS"
                .long

setup_dsp:                                                      ;setup dsp, init some vars etc.
                movem.l         d0-a6,-(sp)
                lea             vars_space(pc),a6
                move.w          #-1,skip_mod-vars_space(a6)     ;skip vbl player
                move.w          #0,sound_frame-vars_space(a6)   ;reset 50/60 hz counter
                move.l          #0,D_CTRL                       ;stop dsp
                move.l          #0,D_FLAGS                      ;set dsp flags
                lea             dsp_code_start(pc),a0
                lea             dsp_code_end(pc),a1
                lea             D_RAM,a2
.loop1:         move.l          (a0)+,(a2)+                     ;copy dsp code to dsp ram
                move.l          (a0)+,(a2)+
                move.l          (a0)+,(a2)+
                move.l          (a0)+,(a2)+
                cmp.l           a0,a1
                bgt.s           .loop1
                lea             dsp_chan1,a0                    ;clear dsp channels table
                moveq           #31,d0                          ;8 channels at 32 bytes each
.loop2:         move.l          #0,(a0)+
                move.l          #0,(a0)+
                dbf             d0,.loop2
                move.l          #$1b,SCLK                       ;setup dsp timer
                move.l          #$15,SMODE
                move.l          #D_RAM,D_PC                     ;set dsp pc to start of code
                move.l          #1,D_CTRL                       ;start dsp
                moveq           #1,d0                           ;start from chan 1
                moveq           #8,d1                           ;for 8 channels
                bsr             clear_channels                  ;clear all sound channels
                movem.l         (sp)+,d0-a6
                rts

init_new_mod:                                                   ;initialise a new module
                movem.l         d0-a6,-(sp)
                bsr             disable_music
                bsr             setup_new_mod
                bsr             enable_music
                movem.l         (sp)+,d0-a6
                rts

setup_new_mod:                                                  ;setup new mod, sample tables and vars etc.
                lea             vars_space(pc),a6
                moveq           #26,d0
                lea             chan_temp(pc),a1                ;clear channel workspace
.loop3:         move.l          #0,(a1)+
                move.l          #0,(a1)+
                dbf             d0,.loop3
                moveq           #3,d0                           ;setup chan num pointer and porta masks
                moveq           #1,d1
                lea             chan_temp(pc),a1
.loop6:         move.w          #$ff,low_mask-chan_temp(a1)     ;default no mask for $ff
                move.w          d1,chan_num-chan_temp(a1)
                addq.w          #1,d1
                lea             54(a1),a1
                dbf             d0,.loop6
                moveq           #3,d0                           ;clear channel sample w/space
                lea             chan_samps(pc),a1
.loop2:         move.l          #0,(a1)+
                move.l          #0,(a1)+
                dbf             d0,.loop2
                lea             $3b8(a0),a1
                lea             $43c(a0),a2
                cmp.l           #"M.K.",-4(a2)                  ;check for mod type
                beq.s           .over5
                lea             -$1e0(a1),a1                    ;adjust for mod type
                lea             -$1e4(a2),a2
.over5:         move.l          a1,patt_pos_pntr-vars_space(a6)
                move.l          a2,patt_data_pntr-vars_space(a6)
                moveq           #0,d0
                move.b          (a1),d0
                lsl.l           #8,d0
                lsl.l           #2,d0
                add.l           a2,d0
                move.l          d0,song_data_pntr-vars_space(a6)
                move.b          #6,speed-vars_space(a6)         ;init a few pointers and counters
                move.b          #0,counter-vars_space(a6)       ;the var names should say it all!
                move.b          #0,song_pos-vars_space(a6)
                move.l          #0,pattern_pos-vars_space(a6)
                moveq           #$7f,d0
                moveq           #0,d1
.loop1:         cmp.b           (a1)+,d1
                bge.s           .over1
                move.b          -1(a1),d1
.over1:         dbf             d0,.loop1
                addq.w          #1,d1
                lsl.l           #8,d1
                lsl.l           #2,d1
                lea             0(a2,d1.l),a1
                lea             sample_starts(pc),a2            ;pre-calc sample table
                move.l          patt_pos_pntr-vars_space(a6),d0
                sub.l           a0,d0
                sub.l           #$16,d0
                divu            #$1e,d0                         ;max 31 samples per mod
                subq.w          #1,d0
                lea             $2a(a0),a0                      ;point to start
.loop5:         moveq           #0,d1                           ;first clear all regs
                moveq           #0,d2
                moveq           #0,d3
                moveq           #0,d4
                moveq           #0,d5
                movem.w         (a0),d1-d4                      ;get data
                tst.w           d3
                bne.s           .over2
                lsl.l           #1,d1
                lsl.l           #1,d4
                move.l          d1,d5
                bra.s           .over4
.over2:         move.l          d3,d5
                add.l           d4,d5
                cmp.l           d1,d5
                bgt.s           .over3
                lsl.l           #1,d3
.over3:         lsl.l           #1,d1
                lsl.l           #1,d4
                move.l          d3,d5
                add.l           d4,d5
                cmp.l           d1,d5
                ble.s           .over4
                move.l          d1,d4
                sub.l           d3,d4
                move.l          d1,d5
.over4:         move.l          a1,(a2)+                        ;store sample start address
                lsr.l           #1,d4
                lsr.l           #1,d5
                move.w          d5,(a2)+
                move.l          a1,(a2)                         ;store for sample end address
                add.l           d3,(a2)+                        ;and modify
                move.w          d4,(a2)+
                move.w          d2,d3
                and.w           #$ff00,d3                       ;get high byte of word
                lsr.w           #8,d3                           ;and shift down
                move.w          d3,(a2)+                        ;store
                and.w           #$ff,d2                         ;get low byte of word
                move.w          d2,(a2)+                        ;and store
                add.l           d1,a1                           ;next sample
                lea             30(a0),a0                       ;next table entry
                dbf             d0,.loop5                       ;and again
                rts

enable_music:                                                   ;enable the vbl mod player
                movem.l         d0/d1/a6,-(sp)
                lea             vars_space(pc),a6
                moveq           #1,d0
                moveq           #4,d1
                bsr             clear_channels                  ;clear the mod channels 1-4
                move.w          #0,skip_mod-vars_space(a6)      ;enable vbl mod player
                movem.l         (sp)+,d0/d1/a6
                rts

disable_music:                                                  ;disable the vbl mod player
                movem.l         d0/d1/a6,-(sp)
                lea             vars_space(pc),a6
                move.w          #-1,skip_mod-vars_space(a6)     ;disable vbl mod player
                moveq           #1,d0
                moveq           #4,d1
                bsr             clear_channels                  ;clear the mod channels 1-4
                movem.l         (sp)+,d0/d1/a6
                rts

set_mus_volume:                                                 ;setup mod playback volume to D0=0 to $ff
                move.l          a6,-(sp)
                lea             vars_space(pc),a6
                and.w           #$ff,d0
                move.w          d0,period-vars_space(a6)
                move.l          (sp)+,a6
                rts

set_efx_volume:                                                 ;setup the sample playback volume to D0=0 to $ff
                move.l          a6,-(sp)
                lea             vars_space(pc),a6
                and.l           #$ff,d0
                move.w          d0,efx_vol-vars_space(a6)
                move.l          dsp_chan5+4,d1                  ;get channel 5 volume
                and.l           #$ffff0000,d1                   ;leave loop flag
                or.l            d0,d1                           ;new volume
                move.l          d1,dsp_chan5+4                  ;and store
                move.l          dsp_chan6+4,d1                  ;get channel 6 volume
                and.l           #$ffff0000,d1                   ;leave loop flag
                or.l            d0,d1                           ;new volume
                move.l          d1,dsp_chan6+4                  ;and store
                move.l          dsp_chan7+4,d1                  ;get channel 7 volume
                and.l           #$ffff0000,d1                   ;leave loop flag
                or.l            d0,d1                           ;new volume
                move.l          d1,dsp_chan7+4                  ;and store
                move.l          dsp_chan8+4,d1                  ;get channel 8 volume
                and.l           #$ffff0000,d1                   ;leave loop flag
                or.l            d0,d1                           ;new volume
                move.l          d1,dsp_chan8+4                  ;and store
                move.l          (sp)+,a6
                rts

clear_channels:                                                 ;clear and release sound channels:
                movem.l         a4-a6,-(sp)                     ;D0=start chan, D1=number of chans
                lea             vars_space(pc),a6
                lea             samp_flag(pc),a5
                lea             dsp_chan1,a4                    ;start of dsp channels table
                and.l           #$f,d0                          ;mask start channel (1-8)
                subq.w          #1,d0                           ;modify for dbf
                lsl.w           #5,d0                           ;each channel table entry is 32 bytes long
                add.l           d0,a4                           ;start address in dsp table
                and.l           #$f,d1                          ;mask number of chanels to clear
                subq.w          #1,d1                           ;modify for dbf
.loop1:         move.l          #0,(a4)                         ;disable channel
                cmp.l           #dsp_chan5,a4                   ;check for chan 5
                bne.s           .over1
                move.w          #-1,(a5)                        ;and release sample priority
.over1:         cmp.l           #dsp_chan6,a4                   ;check for chan 6
                bne.s           .over2
                move.w          #-1,2(a5)                       ;and release sample priority
.over2:         cmp.l           #dsp_chan7,a4                   ;check for chan 7
                bne.s           .over3
                move.w          #-1,4(a5)                       ;and release sample priority
.over3:         cmp.l           #dsp_chan8,a4                   ;check for chan 8
                bne.s           .over4
                move.w          #-1,6(a5)                       ;and release sample priority
.over4:         lea             32(a4),a4                       ;next dsp table entry
                dbf             d1,.loop1                       ;do the rest...
                movem.l         (sp)+,a4-a6
                rts

play_sample:                                                    ;Play a sample: D0=Sample length, D1=Sample looping length (or 0)
                                                                ;D2=Sample priority ($ffff=lowest,0=highest)
                movem.l         d1-a6,-(sp)                     ;D3=Sample volume (0 for default), D4=Sample Freq (0 for default)
                lea             vars_space(pc),a6               ;A0=Sample start address, A1=Sample looping start address (or 0)
                lsl.l           #8,d0                           ;shift sample length 8 bits, mul 256
                lsl.l           #8,d1                           ;shift sample looping length 8 bits, mul 256
                and.l           #$ffff,d2                       ;mask sample priority
                and.l           #$ff,d3                         ;mask sample volume
                and.l           #$ffff,d4                       ;mask sample frequency
                move.l          #0,a3                           ;setup sample channel used to return to caller
                lea             samp_flag(pc),a4                ;sample priorties table
                lea             dsp_chan5,a5                    ;start at chan 5 in dsp table
                moveq           #3,d7                           ;4 sample channels
.loop1:         tst.l           (a5)                            ;is this channel free or now completed playing?
                bne.s           .over1                          ;no, so skip
                move.w          #-1,(a4)                        ;yes, reset channel sample priority to minimum
.over1:         lea             2(a4),a4                        ;next chan samp priority table entry
                lea             32(a5),a5                       ;next dsp table entry
                dbf             d7,.loop1                       ;do rest of channels
                lea             samp_flag(pc),a5                ;point to samp priority table
                moveq           #0,d6                           ;setup highest priority
                moveq           #3,d7                           ;check 4 channels
.loop2:         cmp.w           (a5)+,d6                        ;get sample priority from table
                bcc.s           .over2                          ;search for lower priority
                move.w          -2(a5),d6                       ;found, get lower value
                move.w          d7,d5                           ;save which channel it was found in
.over2:         dbf             d7,.loop2                       ;do rest of channels
                cmp.w           d2,d6                           ;check lowest priority in table with current priority
                bcs             .exit                           ;did we find a low enough priority to replace?
                move.w          d5,d6                           ;save found pointer
                addq.w          #1,d6                           ;adjust 0-3 to 1-4
                lsl.w           #1,d6                           ;and double for word table
                sub.l           d6,a5                           ;adjust sample priority table pointer to correct entry
                move.w          d2,(a5)                         ;and store new priority
                lea             dsp_chan5,a5                    ;yes, point to chan 5 in dsp table
                moveq           #3,d7                           ;check for 4 channels
                sub.w           d5,d7                           ;adjust for channel found
                add.l           #5,a3                           ;adjust for start channel 5
                add.l           d7,a3                           ;and add channel number to give 5-8
                lsl.l           #5,d7                           ;mult by 32 for dsp table entry length
                add.l           d7,a5                           ;a5 now points to free channel in dsp table
                move.l          #0,(a5)                         ;disable channel in dsp table
                move.l          d0,8(a5)                        ;copy sample length to dsp table
                move.l          a0,12(a5)                       ;copy sample start address to dsp table
                move.l          a1,24(a5)                       ;copy start address of loop for looping sample to dsp table
                move.l          #0,28(a5)                       ;setup current sample offset
                tst.l           d3                              ;has sample volume been passed to us?
                bne.s           .over3                          ;if not, then just use default
                move.w          efx_vol-vars_space(a6),d3       ;get the sample volume
.over3:         move.l          d1,20(a5)                       ;store sample looping length for looped sample in dsp table
                tst.l           d1                              ;check if sample is looped
                beq.s           .over4                          ;if not, then don't flag sample as looped
                or.l            #$ffff0000,d3                   ;flag sample as being looped by setting top word of volume
.over4:         move.l          d3,4(a5)                        ;store sample volume in dsp table
                tst.l           d4                              ;has sample freq been passed?
                bne.s           .over5                          ;if not, then just use default
                move.w          #$1ac,d4                        ;set the default sample freq
.over5:         mulu            #$1c,d4                         ;adjust sample freq up
                divu            #$2b,d4                         ;and down
                and.l           #$ffff,d4                       ;mask sample freq
                move.l          d4,16(a5)                       ;and store in dsp table
                move.l          #1,(a5)                         ;mark channel as enabled in dsp table
.exit:          move.l          a3,d0                           ;return channel used to caller (0=none found, or 5-8 if sample played)
                movem.l         (sp)+,d1-a6
                rts

modify_channel:                                                 ;modify a samples current parameters: D0=Channel to modify,
                movem.l         d0-a6,-(sp)                     ;D1=New Volume (or 0), D2=New Frequency (or 0)
                lea             dsp_chan1,a5                    ;start at chan 1 in dsp table
                subq.l          #1,d0                           ;channel -1
                and.l           #$ff,d0                         ;mask channel number
                and.l           #$ff,d1                         ;mask sample volume
                and.l           #$ffff,d2                       ;mask sample frequency
                lsl.l           #5,d0                           ;mult by 32 for dsp table entry length
                add.l           d0,a5                           ;point to channel to modify in dsp table
                tst.l           d1                              ;was new volume passed
                beq.s           .over1                          ;skip volume modify
                move.l          4(a5),d7                        ;get channel volume from dsp table
                and.l           #$ffff0000,d7                   ;mask sample looping flag
                or.l            d1,d7                           ;new volume
                move.l          d7,4(a5)                        ;modify dsp table for new volume
.over1:         tst.l           d2                              ;was new frequency passed
                beq.s           .exit                           ;skip frequency modify
                mulu            #$1c,d2                         ;adjust sample freq up
                divu            #$2b,d2                         ;and down
                and.l           #$ffff,d2                       ;mask sample frequency
                move.l          d2,16(a5)                       ;and store in dsp table
.exit:          movem.l         (sp)+,d0-a6
                rts

                .dc.b           "ATARI JAGUAR SOUNDTRACKER MODULE PLAYER "
                .dc.b           "COPYRIGHT (C) 1995 SINISTER DEVELOPMENTS"
                .long

vbl_handler:                                                    ;this is where all the work is done
                movem.l         d0-a6,-(sp)
                lea             vars_space(pc),a6
                tst.w           skip_mod-vars_space(a6)         ;mod playback disabled or not setup yet?
                bne             .exit
                move.w          CONFIG,d0                       ;check for 50/60 hz
                and.w           #VIDTYPE,d0
                beq.s           .pal_vid
                addq.w          #1,sound_frame-vars_space(a6)   ;update frame count
                cmp.w           #6,sound_frame-vars_space(a6)   ;skip every 6th frame for correct sound speed
                bne.s           .pal_vid
                move.w          #0,sound_frame-vars_space(a6)   ;and reset frame count
                bra             .exit
.pal_vid:       bsr             play_mod                        ;play the module!!
                lea             chan_samps(pc),a0               ;sample w/space for each channel 1-4
                lea             freq_table(pc),a1               ;freq convertor table
                lea             chan_temp(pc),a2                ;vars w/space for each channel 1-4
                lea             dsp_chan1,a3                    ;dsp channel table
                moveq           #3,d7                           ;do all 4 channels
.chan_loop1:    moveq           #0,d0
                move.w          set_per-chan_temp(a2),d0        ;get the period of this channel
                tst.w           d0                              ;if zero, no need to update
                beq.s           .over1                          ;so skip?
                lsl.w           #1,d0                           ;table is stored in words
                move.w          0(a1,d0.w),d0                   ;get the new freq value
                and.l           #$0000ffff,d0                   ;clear top word
                move.l          d0,16(a3)                       ;and store in dsp table
.over1:         moveq           #0,d0
                move.w          vol2-chan_temp(a2),d0           ;get the chan volume
                and.l           #$ffff0000,chan_vol-chan_temp(a2)       ;leave upper 16 bits for samp loop flag
                or.l            d0,chan_vol-chan_temp(a2)       ;store chan volume
                move.l          chan_vol-chan_temp(a2),4(a3)    ;copy to dsp table
                move.l          (a0),d0                         ;has this samp been done yet?
                tst.l           d0
                bmi.s           .over2                          ;if so, skip
                move.l          #-1,(a0)                        ;ok, it's done now
                move.l          #0,(a3)                         ;disable channel for the moment
                tst.l           d0                              ;has the sample finished
                beq.s           .over2                          ;if so, end
                move.l          d0,12(a3)                       ;store start address of sample to dsp table
                move.l          #0,28(a3)                       ;reset current sample offset in dsp table
                and.l           #$0000ffff,chan_vol-chan_temp(a2)       ;reset sample looping flag by clearing top 16 bits
                move.l          chan_vol-chan_temp(a2),4(a3)    ;and store to dsp table
                move.l          4(a0),d1                        ;get sample length
                lsr.l           #8,d1                           ;in 256 byte offsets
                move.l          d1,8(a3)                        ;and store to dsp table
                moveq           #0,d1
                move.w          rep_length-chan_temp(a2),d1     ;get sample repeat value
                lsl.l           #8,d1                           ;in 512 byte offsets
                lsl.l           #1,d1
                move.l          d1,20(a3)                       ;and store to dsp table
                move.l          loop_start-chan_temp(a2),d2     ;address to re-start looped sample
                cmp.l           d0,d2                           ;is loop start = sample start?
                bne.s           .over3                          ;if not, do it
                cmp.l           #$200,d1                        ;does sample repeat within $200 (too quick!)
                ble.s           .over4                          ;if so, skip it, 512 byte increments allowed only!
.over3:         move.l          d2,24(a3)                       ;store start of looping address
                or.l            #$ffff0000,chan_vol-chan_temp(a2)       ;flag this as a looping sample, set top 16 bits
                move.l          chan_vol-chan_temp(a2),4(a3)    ;store in dsp table
.over4:         move.l          #1,(a3)                         ;enable this sample for dsp
.over2:         lea             8(a0),a0                        ;next channel sample table entry
                lea             54(a2),a2                       ;next channels vars table entry
                lea             32(a3),a3                       ;next dsp channel table entry
                dbf             d7,.chan_loop1                  ;and do the other channels
.exit:          movem.l         (sp)+,d0-a6
                rts

play_mod:                                                       ;from here it's all just pretty standard mod player stuff, you can
                lea             vars_space(pc),a6               ;work it out from the amazingly informative labels and var names!!
                moveq           #0,d0
                move.b          counter-vars_space(a6),d0
                addq.w          #1,d0
                cmp.b           speed-vars_space(a6),d0
                blt.s           .no_new_note
                move.b          #0,counter-vars_space(a6)
                tst.b           patt_del_time2-vars_space(a6)
                beq.s           .get_new_note
                move.w          #0,efx_type-vars_space(a6)
                bsr             .do_efx
                bra.s           .not_play
.no_new_note:   move.b          d0,counter-vars_space(a6)
                move.w          #0,efx_type-vars_space(a6)
                bsr             .do_efx
                bra             .no_new_pos1
.get_new_note:  move.l          song_data_pntr-vars_space(a6),a0
                add.l           pattern_pos-vars_space(a6),a0
                bsr             .do_voice
                move.w          #1,efx_type-vars_space(a6)
                bsr             .do_efx
.not_play:      add.l           #$10,pattern_pos-vars_space(a6)
                tst.b           patt_del_time1-vars_space(a6)
                beq.s           .skip1
                move.b          patt_del_time1-vars_space(a6),patt_del_time2-vars_space(a6)
                move.b          #0,patt_del_time1-vars_space(a6)
.skip1:         tst.b           patt_del_time2-vars_space(a6)
                beq.s           .skip2
                subq.b          #1,patt_del_time2-vars_space(a6)
                beq.s           .skip2
                sub.l           #$10,pattern_pos-vars_space(a6)
.skip2:         tst.b           break_flag-vars_space(a6)
                beq.s           .skip3
                move.b          #0,break_flag-vars_space(a6)
                moveq           #0,d0
                move.b          break_pos-vars_space(a6),d0
                move.b          #0,break_pos-vars_space(a6)
                lsl.w           #4,d0
                move.l          d0,pattern_pos-vars_space(a6)
.skip3:         cmp.l           #$400,pattern_pos-vars_space(a6)
                blt.s           .no_new_pos1
.next_pos:      moveq           #0,d0
                move.b          break_pos-vars_space(a6),d0
                lsl.w           #4,d0
                move.l          d0,pattern_pos-vars_space(a6)
                move.b          #0,break_pos-vars_space(a6)
                move.b          #0,pos_jump_flag-vars_space(a6)
                moveq           #0,d0
                move.b          song_pos-vars_space(a6),d0
                addq.w          #1,d0
                move.l          patt_pos_pntr-vars_space(a6),a0
                cmp.b           -2(a0),d0
                blt.s           .no_new_pos2
                moveq           #0,d0
.no_new_pos2:   and.w           #$7f,d0
                move.b          d0,song_pos-vars_space(a6)
                move.b          0(a0,d0.w),d0
                lsl.l           #8,d0
                lsl.l           #2,d0
                add.l           patt_data_pntr-vars_space(a6),d0
                move.l          d0,song_data_pntr-vars_space(a6)
.no_new_pos1:   tst.b           pos_jump_flag-vars_space(a6)
                bne.s           .next_pos
                rts

.do_efx:        moveq           #3,d0
                lea             chan_temp(pc),a0
.loop1:         movem.l         d0/a0,-(sp)
                bsr             check_efx
                movem.l         (sp)+,d0/a0
                lea             54(a0),a0
                dbf             d0,.loop1
                rts

.do_voice:      moveq           #3,d0
                lea             chan_temp(pc),a1
                lea             chan_samps(pc),a2
.chan_loop1:    movem.l         d0/a1-a2,-(sp)
                bsr             play_voice
                movem.l         (sp)+,d0/a1-a2
                lea             54(a1),a1
                lea             8(a2),a2
                dbf             d0,.chan_loop1
                rts

play_voice:
                move.l          (a0)+,d0
                move.l          d0,(a1)
                move.w          d0,d1
                swap            d0
                and.w           #$f000,d0
                and.w           #$f000,d1
                lsr.w           #4,d1
                or.w            d0,d1
                tst.w           d1
                beq.s           .set_regs
                lea             sample_starts(pc),a4
                subq.w          #1,d1
                lsr.w           #4,d1
                and.w           #$1f0,d1
                add.w           d1,a4
                move.l          (a4),samp_start-chan_temp(a1)
                move.w          4(a4),samp_length-chan_temp(a1)
                move.l          6(a4),loop_start-chan_temp(a1)
                move.l          6(a4),wave_start-chan_temp(a1)
                move.w          10(a4),rep_length-chan_temp(a1)
                move.w          12(a4),fine_tune-chan_temp(a1)
                move.w          14(a4),vol1-chan_temp(a1)
.set_regs:      move.w          (a1),d0
                and.w           #$fff,d0
                beq             .exit
                move.w          2(a1),d1
                and.w           #$ff0,d1
                cmp.w           #$e50,d1
                bne.s           .no_fine_tune
                moveq           #0,d1
                move.b          3(a1),d1
                move.w          d1,fine_tune-chan_temp(a1)
                bra.s           .set_period
.no_fine_tune:  move.b          2(a1),d1
                and.w           #$f,d1
                cmp.w           #3,d1
                beq             set_tone_porta
                cmp.w           #5,d1
                beq             set_tone_porta
                cmp.w           #9,d1
                bne.s           .set_period
                moveq           #0,d1
                move.b          3(a1),d1
                tst.w           d1
                beq.s           .over1
                move.b          d1,samp_offset-chan_temp(a1)
.over1:         move.b          samp_offset-chan_temp(a1),d1
                lsl.w           #7,d1
                cmp.w           samp_length-chan_temp(a1),d1
                bge.s           .skip1
                sub.w           d1,samp_length-chan_temp(a1)
                lsl.w           #1,d1
                add.l           d1,samp_start-chan_temp(a1)
                bra.s           .set_period
.skip1:         move.w          #1,samp_length-chan_temp(a1)
.set_period:    move.w          (a1),d0
                and.w           #$fff,d0
                lea             period_table(pc),a3
                moveq           #$24,d2
.ftu_loop:      cmp.w           (a3)+,d0
                dbcc            d2,.ftu_loop
                moveq           #0,d1
                move.w          fine_tune-chan_temp(a1),d1
                mulu            #$48,d1
                move.w          -2(a3,d1.l),d0
                move.w          d0,per-chan_temp(a1)
                moveq           #0,d1
                move.w          2(a1),d1
                and.w           #$ff0,d1
                cmp.w           #$ed0,d1
                beq.s           .exit
                btst            #2,wave_control-chan_temp(a1)
                bne.s           .vib_no_chng
                move.b          #0,vibrato_pos-chan_temp(a1)
.vib_no_chng:   btst            #6,wave_control-chan_temp(a1)
                bne.s           .trem_no_chng
                move.b          #0,tremolo_pos-chan_temp(a1)
.trem_no_chng:  move.l          samp_start-chan_temp(a1),(a2)
                move.w          samp_length-chan_temp(a1),4(a2)
                asl             4(a2)
.exit:          rts

set_tone_porta:
                move.w          (a1),d0
                and.w           #$fff,d0
                moveq           #0,d1
                move.w          fine_tune-chan_temp(a1),d1
                mulu            #$48,d1
                lea             period_table(pc),a3
                add.l           d1,a3
                moveq           #0,d1
.s_t_p_loop:    cmp.w           0(a3,d1.w),d0
                bcc.s           .s_t_p_found
                addq.w          #2,d1
                cmp.w           #$48,d1
                bcs.s           .s_t_p_loop
                moveq           #$46,d1
.s_t_p_found:   move.w          fine_tune-chan_temp(a1),d0
                and.w           #8,d0
                beq.s           .s_t_p_goss
                tst.w           d1
                beq.s           .s_t_p_goss
                subq.w          #2,d1
.s_t_p_goss:    move.w          0(a3,d1.w),d0
                move.w          d0,wanted_per-chan_temp(a1)
                move.b          #0,tone_port_dir-chan_temp(a1)
                cmp.w           per-chan_temp(a1),d0
                beq.s           .clear_t_p
                bge.s           .exit
                move.b          #1,tone_port_dir-chan_temp(a1)
                bra.s           .exit
.clear_t_p:     move.w          #0,wanted_per-chan_temp(a1)
.exit:          rts

check_efx:
                bsr             update_funk
                move.w          per-chan_temp(a0),set_per-chan_temp(a0)
                move.w          vol1-chan_temp(a0),vol2-chan_temp(a0)
                moveq           #0,d0
                move.w          2(a0),d0
                and.w           #$fff,d0
                beq.s           .over1
                move.l          d0,d1
                and.w           #$ff,d1
                lsr.w           #8,d0
                lea             efx_set_1(pc),a1
                tst.w           efx_type-vars_space(a6)
                beq.s           .over2
                lea             efx_set_2(pc),a1
.over2:         tst.b           0(a1,d0.w)
                beq.s           .over1
                lsl.w           #1,d0
                lea             e_command_table(pc),a1
                add.w           0(a1,d0.w),a1
                jsr             (a1)
.over1:         move.w          period-vars_space(a6),d0
                mulu            vol2-chan_temp(a0),d0
                move.w          d0,vol2-chan_temp(a0)
                rts

arpeggio:
                moveq           #0,d0
                move.b          counter-vars_space(a6),d0
                divs            #3,d0
                swap            d0
                cmp.w           #0,d0
                beq.s           .arpeggio2
                cmp.w           #2,d0
                beq.s           .arpeggio1
                moveq           #0,d0
                move.w          d1,d0
                lsr.w           #4,d0
                bra.s           .arpeggio3
.arpeggio1:     moveq           #0,d0
                move.w          d1,d0
                and.w           #$f,d0
                bra.s           .arpeggio3
.arpeggio2:     move.w          per-chan_temp(a0),d2
                bra.s           .arpeggio4
.arpeggio3:     asl.w           #1,d0
                moveq           #0,d1
                move.w          fine_tune-chan_temp(a0),d1
                mulu            #$48,d1
                lea             period_table(pc),a1
                add.l           d1,a1
                moveq           #0,d1
                move.w          per-chan_temp(a0),d1
                moveq           #$24,d3
.arp_loop:      move.w          0(a1,d0.w),d2
                cmp.w           (a1)+,d1
                bcc.s           .arpeggio4
                dbf             d3,.arp_loop
.exit:          rts
.arpeggio4:     move.w          d2,set_per-chan_temp(a0)
                bra.s           .exit

porta_up:
                and.w           low_mask-chan_temp(a0),d1
                move.w          #$ff,low_mask-chan_temp(a0)
                sub.w           d1,per-chan_temp(a0)
                move.w          per-chan_temp(a0),d1
                and.w           #$fff,d1
                cmp.w           #$71,d1
                bpl.s           .skip1
                and.w           #$f000,per-chan_temp(a0)
                or.w            #$71,per-chan_temp(a0)
.skip1:         move.w          per-chan_temp(a0),d1
                and.w           #$fff,d1
                move.w          d1,set_per-chan_temp(a0)
                rts

porta_down:
                and.w           low_mask-chan_temp(a0),d1
                move.w          #$ff,low_mask-chan_temp(a0)
                add.w           d1,per-chan_temp(a0)
                move.w          per-chan_temp(a0),d1
                and.w           #$fff,d1
                cmp.w           #$358,d1
                bmi.s           .skip1
                and.w           #$f000,per-chan_temp(a0)
                or.w            #$358,per-chan_temp(a0)
.skip1:         move.w          per-chan_temp(a0),d1
                and.w           #$fff,d1
                move.w          d1,set_per-chan_temp(a0)
                rts

tone_portamento:
                tst.w           d1
                beq.s           tp_no_change
                move.b          d1,tone_port_spd-chan_temp(a0)
                move.b          #0,3(a0)
tp_no_change:   tst.w           wanted_per-chan_temp(a0)
                beq.s           .exit
                moveq           #0,d0
                move.b          tone_port_spd-chan_temp(a0),d0
                tst.b           tone_port_dir-chan_temp(a0)
                bne.s           .tone_up
                add.w           d0,per-chan_temp(a0)
                move.w          wanted_per-chan_temp(a0),d2
                cmp.w           per-chan_temp(a0),d2
                bgt.s           .set_period
                move.w          d2,per-chan_temp(a0)
                move.w          #0,wanted_per-chan_temp(a0)
                bra.s           .set_period
.tone_up:       sub.w           d0,per-chan_temp(a0)
                move.w          wanted_per-chan_temp(a0),d2
                cmp.w           per-chan_temp(a0),d2
                blt.s           .set_period
                move.w          d2,per-chan_temp(a0)
                move.w          #0,wanted_per-chan_temp(a0)
.set_period:    move.w          per-chan_temp(a0),d0
                move.b          gliss_funk-chan_temp(a0),d1
                and.w           #$f,d1
                beq.s           .gliss_skip
                moveq           #0,d1
                move.w          fine_tune-chan_temp(a0),d1
                mulu            #$48,d1
                lea             period_table(pc),a1
                add.l           d1,a1
                moveq           #0,d1
.gliss_loop:    cmp.w           0(a1,d1.w),d0
                bcc.s           .gliss_found
                addq.w          #2,d1
                cmp.w           #$48,d1
                bcs.s           .gliss_loop
                moveq           #$46,d1
.gliss_found:   move.w          0(a1,d1.w),d0
.gliss_skip:    move.w          d0,set_per-chan_temp(a0)
.exit:          rts

vibrato:
                tst.w           d1
                beq.s           vibrato2
                move.b          vibrato_cmd-chan_temp(a0),d2
                and.w           #$f,d1
                beq.s           .vib_skip1
                and.w           #$f0,d2
                or.w            d1,d2
.vib_skip1:     move.b          3(a0),d1
                and.w           #$f0,d1
                beq.s           vib_skip2
                and.w           #$f,d2
                or.w            d1,d2
vib_skip2:      move.b          d2,vibrato_cmd-chan_temp(a0)
vibrato2:       move.b          vibrato_pos-chan_temp(a0),d0
                lea             vibrato_table(pc),a1
                lsr.w           #2,d0
                and.w           #$1f,d0
                moveq           #0,d1
                move.b          wave_control-chan_temp(a0),d1
                and.w           #3,d1
                beq.s           .vib_sine
                lsl.w           #3,d0
                cmp.w           #1,d1
                beq.s           .vib_rampdown1
                move.w          #$ff,d1
                bra.s           .vib_set
.vib_rampdown1: tst.b           vibrato_pos-chan_temp(a0)
                bpl.s           .vib_rampdown2
                move.w          #$ff,d1
                sub.w           d0,d1
                bra.s           .vib_set
.vib_rampdown2: move.w          d0,d1
                bra.s           .vib_set
.vib_sine:      move.b          0(a1,d0.w),d1
.vib_set:       move.b          vibrato_cmd-chan_temp(a0),d0
                and.w           #$f,d0
                mulu            d0,d1
                lsr.w           #7,d1
                move.w          per-chan_temp(a0),d0
                tst.b           vibrato_pos-chan_temp(a0)
                bmi.s           .vib_neg
                add.w           d1,d0
                bra.s           .vibrato3
.vib_neg:       sub.w           d1,d0
.vibrato3:      move.w          d0,set_per-chan_temp(a0)
                move.b          vibrato_cmd-chan_temp(a0),d0
                lsr.w           #2,d0
                and.w           #$3c,d0
                add.b           d0,vibrato_pos-chan_temp(a0)
                rts

tone_plus_vol_slide:
                move.w          d1,-(sp)
                bsr             volume_slide
                move.w         (sp)+,d1
                bsr             tone_portamento
                rts

vibrato_plus_vol_slide:
                move.w          d1,-(sp)
                bsr             volume_slide
                move.w          (sp)+,d1
                bsr             vib_skip2
                rts

tremolo:
                tst.w           d1
                beq.s           .tremolo2
                move.b          tremolo_cmd-chan_temp(a0),d2
                and.w           #$f,d1
                beq.s           .trem_skip1
                and.w           #$f0,d2
                or.w            d1,d2
.trem_skip1:    move.b          3(a0),d1
                and.w           #$f0,d1
                beq.s           .trem_skip2
                and.w           #$f,d2
                or.w            d1,d2
.trem_skip2:    move.b          d2,tremolo_cmd-chan_temp(a0)
.tremolo2:      move.b          tremolo_pos-chan_temp(a0),d0
                lea             vibrato_table(pc),a1
                lsr.w           #2,d0
                and.w           #$1f,d0
                moveq           #0,d1
                move.b          wave_control-chan_temp(a0),d1
                lsr.w           #4,d1
                and.w           #3,d1
                beq.s           .trem_sine
                lsl.w           #3,d0
                cmp.w           #1,d1
                beq.s           .trem_ramp_dn1
                move.w          #$ff,d1
                bra.s           .trem_set
.trem_ramp_dn1: tst.b           vibrato_pos-chan_temp(a0)
                bpl.s           .trem_ramp_dn2
                move.w          #$ff,d1
                sub.w           d0,d1
                bra.s           .trem_set
.trem_ramp_dn2: move.w          d0,d1
                bra.s           .trem_set
.trem_sine:     move.b          0(a1,d0.w),d1
.trem_set:      move.b          tremolo_cmd-chan_temp(a0),d0
                and.w           #$f,d0
                mulu            d0,d1
                lsr.w           #6,d1
                move.w          vol1-chan_temp(a0),d0
                tst.b           tremolo_pos-chan_temp(a0)
                bmi.s           .trem_neg
                add.w           d1,d0
                bra.s           .tremolo3
.trem_neg:      sub.w           d1,d0
.tremolo3:      bpl.s           .trem_skip
                moveq           #0,d0
.trem_skip:     cmp.w           #$40,d0
                ble.s           .trem_ok
                moveq           #$40,d0
.trem_ok:       move.w          d0,vol2-chan_temp(a0)
                move.b          tremolo_cmd-chan_temp(a0),d0
                lsr.w           #2,d0
                and.w           #$3c,d0
                add.b           d0,tremolo_pos-chan_temp(a0)
                rts

e_command_8:
                rts

sample_offset:
                tst.w           d1
                beq.s           .not_new
                move.b          d1,samp_offset-chan_temp(a0)
.not_new:       move.b          samp_offset-chan_temp(a0),d1
                lsl.w           #7,d1
                cmp.w           samp_length-chan_temp(a0),d1
                bge.s           .skip
                sub.w           d1,samp_length-chan_temp(a0)
                lsl.w           #1,d1
                add.l           d1,samp_start-chan_temp(a0)
                bra.s           .exit
.skip:          move.w          #1,samp_length-chan_temp(a0)
.exit:          rts

volume_slide:
                move.w          vol1-chan_temp(a0),d3
                move.w          d1,d2
                lsr.w           #4,d1
                and.w           #$f,d1
                tst.w           d1
                beq.s           .vol_slide_dn
                add.w           d1,d3
                cmp.w           #$40,d3
                bmi.s           .skip
                moveq           #$40,d3
                bra.s           .skip
.vol_slide_dn:  and.w           #$f,d2
                sub.w           d2,d3
                bpl.s           .skip
                moveq           #0,d3
.skip:          move.w          d3,vol1-chan_temp(a0)
                move.w          d3,vol2-chan_temp(a0)
                rts

position_jump:
                subq.w          #1,d1
                move.b          d1,song_pos-vars_space(a6)
pos_jump:       move.b          #0,break_pos-vars_space(a6)
                move.b          #$ff,pos_jump_flag-vars_space(a6)
                rts

volume_change:
                cmp.w           #$40,d1
                ble.s           .volume_ok
                moveq           #$40,d1
.volume_ok:     move.w          d1,vol1-chan_temp(a0)
                move.w          d1,vol2-chan_temp(a0)
                rts

pattern_break:
                move.l          d1,d2
                lsr.w           #4,d1
                mulu            #$a,d1
                and.w           #$f,d2
                add.w           d2,d1
                cmp.w           #$3f,d1
                bhi.s           pos_jump
                move.b          d1,break_pos-vars_space(a6)
                move.b          #$ff,pos_jump_flag-vars_space(a6)
.exit:          rts

e_commands:
                move.w          d1,d2
                and.w           #$f,d1
                and.w           #$f0,d2
                lsr.w           #3,d2
                lea             command_lo_table(pc),a1
                add.w           0(a1,d2.w),a1
                jsr             (a1)
                rts

set_speed:
                tst.w           d1
                beq.s           .exit
                move.b          #0,counter-vars_space(a6)
                move.b          d1,speed-vars_space(a6)
.exit:          rts

command_lo_0:
                rts

lo_fine_porta_up:
                tst.b           counter-vars_space(a6)
                bne.s           .exit
                move.w          #$f,low_mask-chan_temp(a0)
                bsr             porta_up
.exit:          rts

lo_fine_porta_down:
                tst.b           counter-vars_space(a6)
                bne.s           .exit
                move.w          #$f,low_mask-chan_temp(a0)
                bsr             porta_down
.exit:          rts

set_gliss_control:
                and.b           #$f0,gliss_funk-chan_temp(a0)
                or.b            d1,gliss_funk-chan_temp(a0)
                rts

set_vibrato_control:
                and.b           #$f0,wave_control-chan_temp(a0)
                or.b            d1,wave_control-chan_temp(a0)
                rts

set_fine_tune:
                move.w          d1,fine_tune-chan_temp(a0)
                rts

jump_loop:
                tst.b           counter-vars_space(a6)
                bne.s           .exit
                tst.w           d1
                beq.s           .set_loop
                tst.b           loop_count-chan_temp(a0)
                beq.s           .over1
                subq.b          #1,loop_count-chan_temp(a0)
                beq.s           .exit
.over2:         move.b          patt_pos-chan_temp(a0),break_pos-vars_space(a6)
                move.b          #$ff,break_flag-vars_space(a6)
                bra.s           .exit
.over1:         move.b          d1,loop_count-chan_temp(a0)
                bra.s           .over2
.set_loop:      move.l          pattern_pos-vars_space(a6),d1
                lsr.w           #4,d1
                move.b          d1,patt_pos-chan_temp(a0)
.exit:          rts

set_tremolo_control:
                lsl.w           #4,d1
                and.b           #$f,wave_control-chan_temp(a0)
                or.b            d1,wave_control-chan_temp(a0)
                rts

command_lo_8:
                rts

retrig_note:
                tst.w           d1
                beq.s           exit_retrig
                moveq           #0,d2
                move.b          counter-vars_space(a6),d2
                bne.s           .over1
                move.w          (a0),d2
                and.w           #$fff,d2
                bne.s           exit_retrig
                moveq           #0,d2
                move.b          counter-vars_space(a6),d2
.over1:         divu            d1,d2
                swap            d2
                tst.w           d2
                bne.s           exit_retrig
do_retrig:      move.w          chan_num-chan_temp(a0),d1
                lsl.w           #3,d1
                lea             chan_samps(pc),a1
                move.l          samp_start-chan_temp(a0),0(a1,d1.w)
                move.w          samp_length-chan_temp(a0),4(a1,d1.w)
                asl             4(a1,d1.w)
exit_retrig:    rts

volume_fine_up:
                tst.b           counter-vars_space(a6)
                bne.s           .exit
                lsl.w           #4,d1
                bsr             volume_slide
.exit:          rts

volume_fine_down:
                tst.b           counter-vars_space(a6)
                bne.s           .exit
                bsr             volume_slide
.exit:          rts

note_cut:
                cmp.b           counter-vars_space(a6),d1
                bne.s           .exit
                move.w          #0,vol1-chan_temp(a0)
                move.w          #0,vol2-chan_temp(a0)
.exit:          rts

note_delay:
                cmp.b           counter-vars_space(a6),d1
                bne.s           .exit
                tst.w           (a0)
                beq.s           .exit
                bsr             do_retrig
.exit:          rts

pattern_delay:
                tst.b           counter-vars_space(a6)
                bne.s           .exit
                tst.b           patt_del_time2-vars_space(a6)
                bne.s           .exit
                addq.w          #1,d1
                move.b          d1,patt_del_time1-vars_space(a6)
.exit:          rts

funk_it:
                tst.b           counter-vars_space(a6)
                bne.s           exit_funk_it
                lsl.w           #4,d1
                and.b           #$f,gliss_funk-chan_temp(a0)
                or.b            d1,gliss_funk-chan_temp(a0)
                tst.w           d1
                beq.s           exit_funk_it
update_funk:    move.l          a0,-(sp)
                moveq           #0,d1
                move.b          gliss_funk-chan_temp(a0),d1
                lsr.w           #4,d1
                beq.s           exit_funk_it
                lea             funk_table(pc),a1
                move.b          0(a1,d1.w),d1
                add.b           d1,funk_offset-chan_temp(a0)
                btst            #7,funk_offset-chan_temp(a0)
                beq.s           exit_funk_it
                move.b          #0,funk_offset-chan_temp(a0)
                move.l          loop_start-chan_temp(a0),d0
                moveq           #0,d1
                move.w          rep_length-chan_temp(a0),d1
                add.l           d1,d0
                add.l           d1,d0
                move.l          wave_start-chan_temp(a0),a1
                addq.l          #1,a1
                cmp.l           d0,a1
                bcs.s           funk_ok
                move.l          loop_start-chan_temp(a0),a1
funk_ok:        move.l          a1,wave_start-chan_temp(a0)
                moveq           #$ff,d0
                sub.b           (a0),d0
                move.b          d0,(a0)
exit_funk_it:   move.l          (sp)+,a0
                rts

e_command_table:
                .dc.w           arpeggio-e_command_table
                .dc.w           porta_up-e_command_table
                .dc.w           porta_down-e_command_table
                .dc.w           tone_portamento-e_command_table
                .dc.w           vibrato-e_command_table
                .dc.w           tone_plus_vol_slide-e_command_table
                .dc.w           vibrato_plus_vol_slide-e_command_table
                .dc.w           tremolo-e_command_table
                .dc.w           e_command_8-e_command_table
                .dc.w           sample_offset-e_command_table
                .dc.w           volume_slide-e_command_table
                .dc.w           position_jump-e_command_table
                .dc.w           volume_change-e_command_table
                .dc.w           pattern_break-e_command_table
                .dc.w           e_commands-e_command_table
                .dc.w           set_speed-e_command_table

command_lo_table:
                .dc.w           command_lo_0-command_lo_table
                .dc.w           lo_fine_porta_up-command_lo_table
                .dc.w           lo_fine_porta_down-command_lo_table
                .dc.w           set_gliss_control-command_lo_table
                .dc.w           set_vibrato_control-command_lo_table
                .dc.w           set_fine_tune-command_lo_table
                .dc.w           jump_loop-command_lo_table
                .dc.w           set_tremolo_control-command_lo_table
                .dc.w           command_lo_8-command_lo_table
                .dc.w           retrig_note-command_lo_table
                .dc.w           volume_fine_up-command_lo_table
                .dc.w           volume_fine_down-command_lo_table
                .dc.w           note_cut-command_lo_table
                .dc.w           note_delay-command_lo_table
                .dc.w           pattern_delay-command_lo_table
                .dc.w           funk_it-command_lo_table

                .dc.b           "ATARI JAGUAR SOUNDTRACKER MODULE PLAYER "
                .dc.b           "COPYRIGHT (C) 1995 SINISTER DEVELOPMENTS"
                .long

efx_set_1:      .dc.l           $01010101,$01010101
                .dc.l           $00000100,$00000100
efx_set_2:      .dc.l           $00000000,$00000000
                .dc.l           $00010001,$01010101

vars_space:     .dc.l           "VARS"                  ;these are all general vars for the tracker etc.
counter:        .dc.b           0
speed:          .dc.b           0
song_pos:       .dc.b           0
break_pos:      .dc.b           0
pos_jump_flag:  .dc.b           0
break_flag:     .dc.b           0
period:         .dc.w           0
efx_vol:        .dc.w           0
patt_del_time1: .dc.b           0
patt_del_time2: .dc.b           0
patt_pos_pntr:  .dc.l           0
patt_data_pntr: .dc.l           0
pattern_pos:    .dc.l           0
song_data_pntr: .dc.l           0
efx_type:       .dc.w           0
skip_mod:       .dc.w           -1
sound_frame:    .dc.w           0
samp_flag:      .dc.w           -1,-1,-1,-1

chan_temp:      .dc.w           0,0,0                   ;these are repeated after the main set a further 3 times,
tone_port_dir:  .dc.b           0                       ;once for each channel... hence all the .dc.l 0 at the end of this lot!
tone_port_spd:  .dc.b           0
tremolo_cmd:    .dc.b           0
tremolo_pos:    .dc.b           0
vibrato_cmd:    .dc.b           0
vibrato_pos:    .dc.b           0
wave_control:   .dc.b           0
funk_offset:    .dc.b           0
gliss_funk:     .dc.b           0
loop_count:     .dc.b           0
patt_pos:       .dc.b           0
samp_offset:    .dc.b           0
samp_start:     .dc.l           0
samp_length:    .dc.w           0
wave_start:     .dc.l           0
loop_start:     .dc.l           0
rep_length:     .dc.w           0
per:            .dc.w           0
set_per:        .dc.w           0
wanted_per:     .dc.w           0
vol1:           .dc.w           0
vol2:           .dc.w           0
fine_tune:      .dc.w           0
chan_vol:       .dc.l           0
low_mask:       .dc.w           0
chan_num:       .dc.w           0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0

sample_starts:  .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
                .dc.l           0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0

chan_samps:     .dc.l           0,0                             ;start address and length of sample
                .dc.l           0,0                             ;for each of 4 channels
                .dc.l           0,0
                .dc.l           0,0

funk_table:     .dc.b           0,5,6,7,8,10,11,13,16,19,22,26,32,43,64,128

vibrato_table:  .dc.b           0,24,49,74,97,120,141,161
                .dc.b           180,197,212,224,235,244,250,253
                .dc.b           255,253,250,244,235,224,212,197
                .dc.b           180,161,141,120,97,74,49,24

period_table:
; Tuning 0, Normal
                .dc.w           856,808,762,720,678,640,604,570,538,508,480,453
                .dc.w           428,404,381,360,339,320,302,285,269,254,240,226
                .dc.w           214,202,190,180,170,160,151,143,135,127,120,113
; Tuning 1
                .dc.w           850,802,757,715,674,637,601,567,535,505,477,450
                .dc.w           425,401,379,357,337,318,300,284,268,253,239,225
                .dc.w           213,201,189,179,169,159,150,142,134,126,119,113
; Tuning 2
                .dc.w           844,796,752,709,670,632,597,563,532,502,474,447
                .dc.w           422,398,376,355,335,316,298,282,266,251,237,224
                .dc.w           211,199,188,177,167,158,149,141,133,125,118,112
; Tuning 3
                .dc.w           838,791,746,704,665,628,592,559,528,498,470,444
                .dc.w           419,395,373,352,332,314,296,280,264,249,235,222
                .dc.w           209,198,187,176,166,157,148,140,132,125,118,111
; Tuning 4
                .dc.w           832,785,741,699,660,623,588,555,524,495,467,441
                .dc.w           416,392,370,350,330,312,294,278,262,247,233,220
                .dc.w           208,196,185,175,165,156,147,139,131,124,117,110
; Tuning 5
                .dc.w           826,779,736,694,655,619,584,551,520,491,463,437
                .dc.w           413,390,368,347,328,309,292,276,260,245,232,219
                .dc.w           206,195,184,174,164,155,146,138,130,123,116,109
; Tuning 6
                .dc.w           820,774,730,689,651,614,580,547,516,487,460,434
                .dc.w           410,387,365,345,325,307,290,274,258,244,230,217
                .dc.w           205,193,183,172,163,154,145,137,129,122,115,109
; Tuning 7
                .dc.w           814,768,725,684,646,610,575,543,513,484,457,431
                .dc.w           407,384,363,342,323,305,288,272,256,242,228,216
                .dc.w           204,192,181,171,161,152,144,136,128,121,114,108
; Tuning -8
                .dc.w           907,856,808,762,720,678,640,604,570,538,508,480
                .dc.w           453,428,404,381,360,339,320,302,285,269,254,240
                .dc.w           226,214,202,190,180,170,160,151,143,135,127,120
; Tuning -7
                .dc.w           900,850,802,757,715,675,636,601,567,535,505,477
                .dc.w           450,425,401,379,357,337,318,300,284,268,253,238
                .dc.w           225,212,200,189,179,169,159,150,142,134,126,119
; Tuning -6
                .dc.w           894,844,796,752,709,670,632,597,563,532,502,474
                .dc.w           447,422,398,376,355,335,316,298,282,266,251,237
                .dc.w           223,211,199,188,177,167,158,149,141,133,125,118
; Tuning -5
                .dc.w           887,838,791,746,704,665,628,592,559,528,498,470
                .dc.w           444,419,395,373,352,332,314,296,280,264,249,235
                .dc.w           222,209,198,187,176,166,157,148,140,132,125,118
; Tuning -4
                .dc.w           881,832,785,741,699,660,623,588,555,524,494,467
                .dc.w           441,416,392,370,350,330,312,294,278,262,247,233
                .dc.w           220,208,196,185,175,165,156,147,139,131,123,117
; Tuning -3
                .dc.w           875,826,779,736,694,655,619,584,551,520,491,463
                .dc.w           437,413,390,368,347,328,309,292,276,260,245,232
                .dc.w           219,206,195,184,174,164,155,146,138,130,123,116
; Tuning -2
                .dc.w           868,820,774,730,689,651,614,580,547,516,487,460
                .dc.w           434,410,387,365,345,325,307,290,274,258,244,230
                .dc.w           217,205,193,183,172,163,154,145,137,129,122,115
; Tuning -1
                .dc.w           862,814,768,725,684,646,610,575,543,513,484,457
                .dc.w           431,407,384,363,342,323,305,288,272,256,242,228
                .dc.w           216,203,192,181,171,161,152,144,136,128,121,114

freq_table:
                .dc.l            $0000f000,$78005000,$3c003000,$28002249
                .dc.l            $1e001aaa,$180015d1,$14001276,$11241000
                .dc.l            $0f000e1e,$0d550ca1,$0c000b6d,$0ae80a6f
                .dc.l            $0a000999,$093b08e3,$08920846,$080007bd
                .dc.l            $07800745,$070f06db,$06aa067c,$06500627
                .dc.l            $060005da,$05b60594,$05740555,$0537051b
                .dc.l            $050004e5,$04cc04b4,$049d0487,$0471045d
                .dc.l            $04490435,$04230411,$040003ef,$03de03cf
                .dc.l            $03c003b1,$03a20395,$0387037a,$036d0361
                .dc.l            $03550349,$033e0333,$0328031d,$03130309
                .dc.l            $030002f6,$02ed02e4,$02db02d2,$02ca02c2
                .dc.l            $02ba02b2,$02aa02a3,$029b0294,$028d0286
                .dc.l            $02800279,$0272026c,$02660260,$025a0254
                .dc.l            $024e0249,$0243023e,$02380233,$022e0229
                .dc.l            $0224021f,$021a0216,$0211020d,$02080204
                .dc.l            $020001fb,$01f701f3,$01ef01eb,$01e701e3
                .dc.l            $01e001dc,$01d801d5,$01d101cd,$01ca01c7
                .dc.l            $01c301c0,$01bd01ba,$01b601b3,$01b001ad
                .dc.l            $01aa01a7,$01a401a1,$019f019c,$01990196
                .dc.l            $01940191,$018e018c,$01890187,$01840182
                .dc.l            $0180017d,$017b0178,$01760174,$0172016f
                .dc.l            $016d016b,$01690167,$01650163,$0161015f
                .dc.l            $015d015b,$01590157,$01550153,$0151014f
                .dc.l            $014d014c,$014a0148,$01460145,$01430141
                .dc.l            $0140013e,$013c013b,$01390137,$01360134
                .dc.l            $01330131,$0130012e,$012d012b,$012a0128
                .dc.l            $01270125,$01240123,$01210120,$011f011d
                .dc.l            $011c011b,$01190118,$01170116,$01140113
                .dc.l            $01120111,$010f010e,$010d010c,$010b0109
                .dc.l            $01080107,$01060105,$01040103,$01020101
                .dc.l            $010000fe,$00fd00fc,$00fb00fa,$00f900f8
                .dc.l            $00f700f6,$00f500f4,$00f300f2,$00f100f0
                .dc.l            $00f000ef,$00ee00ed,$00ec00eb,$00ea00e9
                .dc.l            $00e800e7,$00e600e6,$00e500e4,$00e300e2
                .dc.l            $00e100e1,$00e000df,$00de00dd,$00dd00dc
                .dc.l            $00db00da,$00d900d9,$00d800d7,$00d600d6
                .dc.l            $00d500d4,$00d300d3,$00d200d1,$00d000d0
                .dc.l            $00cf00ce,$00ce00cd,$00cc00cc,$00cb00ca
                .dc.l            $00ca00c9,$00c800c8,$00c700c6,$00c600c5
                .dc.l            $00c400c4,$00c300c3,$00c200c1,$00c100c0
                .dc.l            $00c000bf,$00be00be,$00bd00bd,$00bc00bb
                .dc.l            $00bb00ba,$00ba00b9,$00b900b8,$00b700b7
                .dc.l            $00b600b6,$00b500b5,$00b400b4,$00b300b3
                .dc.l            $00b200b2,$00b100b1,$00b000b0,$00af00af
                .dc.l            $00ae00ae,$00ad00ad,$00ac00ac,$00ab00ab
                .dc.l            $00aa00aa,$00a900a9,$00a800a8,$00a700a7
                .dc.l            $00a600a6,$00a600a5,$00a500a4,$00a400a3
                .dc.l            $00a300a2,$00a200a2,$00a100a1,$00a000a0
                .dc.l            $00a0009f,$009f009e,$009e009d,$009d009d
                .dc.l            $009c009c,$009b009b,$009b009a,$009a0099
                .dc.l            $00990099,$00980098,$00980097,$00970096
                .dc.l            $00960096,$00950095,$00950094,$00940094
                .dc.l            $00930093,$00920092,$00920091,$00910091
                .dc.l            $00900090,$0090008f,$008f008f,$008e008e
                .dc.l            $008e008d,$008d008d,$008c008c,$008c008b
                .dc.l            $008b008b,$008b008a,$008a008a,$00890089
                .dc.l            $00890088,$00880088,$00870087,$00870087
                .dc.l            $00860086,$00860085,$00850085,$00840084
                .dc.l            $00840084,$00830083,$00830083,$00820082
                .dc.l            $00820081,$00810081,$00810080,$00800080
                .dc.l            $0080007f,$007f007f,$007e007e,$007e007e
                .dc.l            $007d007d,$007d007d,$007c007c,$007c007c
                .dc.l            $007b007b,$007b007b,$007a007a,$007a007a
                .dc.l            $00790079,$00790079,$00780078,$00780078
                .dc.l            $00780077,$00770077,$00770076,$00760076
                .dc.l            $00760075,$00750075,$00750075,$00740074
                .dc.l            $00740074,$00730073,$00730073,$00730072
                .dc.l            $00720072,$00720071,$00710071,$00710071
                .dc.l            $00700070,$00700070,$0070006f,$006f006f
                .dc.l            $006f006f,$006e006e,$006e006e,$006e006d
                .dc.l            $006d006d,$006d006d,$006c006c,$006c006c
                .dc.l            $006c006b,$006b006b,$006b006b,$006b006a
                .dc.l            $006a006a,$006a006a,$00690069,$00690069
                .dc.l            $00690069,$00680068,$00680068,$00680067
                .dc.l            $00670067,$00670067,$00670066,$00660066
                .dc.l            $00660066,$00660065,$00650065,$00650065
                .dc.l            $00650064,$00640064,$00640064,$00640063
                .dc.l            $00630063,$00630063,$00630062,$00620062
                .dc.l            $00620062,$00620061,$00610061,$00610061
                .dc.l            $00610061,$00600060,$00600060,$00600060
                .dc.l            $0060005f,$005f005f,$005f005f,$005f005e
                .dc.l            $005e005e,$005e005e,$005e005e,$005d005d
                .dc.l            $005d005d,$005d005d,$005d005c,$005c005c
                .dc.l            $005c005c,$005c005c,$005b005b,$005b005b
                .dc.l            $005b005b,$005b005b,$005a005a,$005a005a
                .dc.l            $005a005a,$005a0059,$00590059,$00590059
                .dc.l            $00590059,$00590058,$00580058,$00580058
                .dc.l            $00580058,$00580057,$00570057,$00570057
                .dc.l            $00570057,$00570056,$00560056,$00560056
                .dc.l            $00560056,$00560055,$00550055,$00550055
                .dc.l            $00550055,$00550054,$00540054,$00540054
                .dc.l            $00540054,$00540054,$00530053,$00530053
                .dc.l            $00530053,$00530053,$00530052,$00520052
                .dc.l            $00520052,$00520052,$00520052,$00510051
                .dc.l            $00510051,$00510051,$00510051,$00510050
                .dc.l            $00500050,$00500050,$00500050,$00500050
                .dc.l            $0050004f,$004f004f,$004f004f,$004f004f
                .dc.l            $004f004f,$004e004e,$004e004e,$004e004e
                .dc.l            $004e004e,$004e004e,$004d004d,$004d004d
                .dc.l            $004d004d,$004d004d,$004d004d,$004c004c
                .dc.l            $004c004c,$004c004c,$004c004c,$004c004c
                .dc.l            $004c004b,$004b004b,$004b004b,$004b004b
                .dc.l            $004b004b,$004b004b,$004a004a,$004a004a
                .dc.l            $004a004a,$004a004a,$004a004a,$004a0049
                .dc.l            $00490049,$00490049,$00490049,$00490049
                .dc.l            $00490049,$00480048,$00480048,$00480048
                .dc.l            $00480048,$00480048,$00480048,$00470047
                .dc.l            $00470047,$00470047,$00470047,$00470047
                .dc.l            $00470047,$00460046,$00460046,$00460046
                .dc.l            $00460046,$00460046,$00460046,$00450045
                .dc.l            $00450045,$00450045,$00450045,$00450045
                .dc.l            $00450045,$00450044,$00440044,$00440044
                .dc.l            $00440044,$00440044,$00440044,$00440044
                .dc.l            $00430043,$00430043,$00430043,$00430043
                .dc.l            $00430043,$00430043,$00430043,$00420042
                .dc.l            $00420042,$00420042,$00420042,$00420042
                .dc.l            $00420042,$00420041,$00410041,$00410041
                .dc.l            $00410041,$00410041,$00410041,$00410041
                .dc.l            $00410041,$00400040,$00400040,$00400040
                .dc.l            $00400040,$00400040,$00400040,$00400040
                .dc.l            $00400040,$00400040,$00400040,$00400040

                .phrase
dsp_code_start:
                .dsp

                .org            D_RAM

                movei           #dsp_main,r0            ;point to start
                jump            (r0)                    ;go start
                nop
                nop
                nop
                nop
dsp_int:        load            (r28),r29               ;get dsp flags
                bclr            #3,r29                  ;interrupt serviced
                load            (r31),r30               ;get return from stack
                bset            #10,r29                 ;clear int source flag
                addq            #4,r31                  ;update stack
                addq            #2,r30                  ;update return address
                movei           #1,r27                  ;set int wait flag
                jump            (r30)                   ;return from int
                store           r29,(r28)               ;set dsp flags

dsp_main:       movei           #dsp_stack,r31          ;point to stack
                moveta          r31,r31                 ;in both reg sets
                movei           #D_FLAGS,r28            ;point to DSP flags
                movei           #dsp_dummy,r26          ;empty sample pointer
                load            (r28),r0                ;get dsp flags
                bset            #5,r0                   ;enable timer int
                store           r0,(r28)                ;do it
                movei           #$20,r25                ;channel offset skip
                movei           #0,r24                  ;channel disabled
                movei           #$ff,r23                ;setup mask

do_chan_1:      movei           #dsp_chan1,r14          ;Reset table pointer

                movei           #do_chan_2,r0           ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r15                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r15          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r15                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r15,r2                  ;At sample end?
                moveta          r1,r20                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r15                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r15                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r15,r0                  ;Save current offset
                store           r15,(r14+28/4)          ;Update current offset
                shrq            #8,r15                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r15                  ;Samp Offset address
                moveta          r0,r0                   ;Save offset low-byte

do_chan_2:      add             r25,r14                 ;Skip address
                movei           #do_chan_3,r0           ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r16                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r16          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r16                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r16,r2                  ;At sample end?
                moveta          r1,r21                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r16                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r16                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r16,r0                  ;Save current offset
                store           r16,(r14+28/4)          ;Update current offset
                shrq            #8,r16                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r16                  ;Samp Offset address
                moveta          r0,r1                   ;Save offset low-byte

do_chan_3:      add             r25,r14                 ;Skip address
                movei           #do_chan_4,r0           ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r17                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r17          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r17                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r17,r2                  ;At sample end?
                moveta          r1,r22                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r17                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r17                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r17,r0                  ;Save current offset
                store           r17,(r14+28/4)          ;Update current offset
                shrq            #8,r17                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r17                  ;Samp Offset address
                moveta          r0,r2                   ;Save offset low-byte

do_chan_4:      add             r25,r14                 ;Skip address
                movei           #do_chan_5,r0           ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r18                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r18          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r18                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r18,r2                  ;At sample end?
                moveta          r1,r23                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r18                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r18                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r18,r0                  ;Save current offset
                store           r18,(r14+28/4)          ;Update current offset
                shrq            #8,r18                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r18                  ;Samp Offset address
                moveta          r0,r3                   ;Save offset low-byte

do_chan_5:      add             r25,r14                 ;Skip address
                movei           #do_chan_6,r0           ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r19                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r19          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r19                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r19,r2                  ;At sample end?
                moveta          r1,r24                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r19                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r19                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r19,r0                  ;Save current offset
                store           r19,(r14+28/4)          ;Update current offset
                shrq            #8,r19                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r19                  ;Samp Offset address
                moveta          r0,r4                   ;Save offset low-byte

do_chan_6:      add             r25,r14                 ;Skip address
                movei           #do_chan_7,r0           ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r20                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r20          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r20                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r20,r2                  ;At sample end?
                moveta          r1,r25                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r20                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r20                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r20,r0                  ;Save current offset
                store           r20,(r14+28/4)          ;Update current offset
                shrq            #8,r20                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r20                  ;Samp Offset address
                moveta          r0,r5                   ;Save offset low-byte

do_chan_7:      add             r25,r14                 ;Skip address
                movei           #do_chan_8,r0           ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r21                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r21          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r21                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r21,r2                  ;At sample end?
                moveta          r1,r26                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r21                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r21                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r21,r0                  ;Save current offset
                store           r21,(r14+28/4)          ;Update current offset
                shrq            #8,r21                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r21                  ;Samp Offset address
                moveta          r0,r6                   ;Save offset low-byte

do_chan_8:      add             r25,r14                 ;Skip address
                movei           #done_chans,r0          ;Skip address
                load            (r14),r1                ;On/Off?
                move            r26,r22                 ;Point to dummy samp
                cmp             r24,r1                  ;Is channel disabled?
                jump            eq,(r0)                 ;Do next channel
                load            (r14+16/4),r1           ;Samp freq
                load            (r14+28/4),r22          ;Current samp offset
                load            (r14+8/4),r2            ;Samp length
                add             r1,r22                  ;New offset
                load            (r14+4/4),r1            ;Volume
                cmp             r22,r2                  ;At sample end?
                moveta          r1,r27                  ;Save chan 1 volume
                jr              pl,.over1               ;Not at end yet?
                btst            #16,r1                  ;Sample looped?
                jr              ne,.over2               ;Yes?
                nop
                move            r26,r22                 ;No, point to dummy
                jump            (r0)                    ;Do next channel
                store           r24,(r14)               ;Flag channel as done
.over2:         sub             r2,r22                  ;For current offset
                load            (r14+20/4),r0           ;Samp looping length
                load            (r14+24/4),r1           ;Looping start address
                store           r0,(r14+8/4)            ;Reset samp length
                store           r1,(r14+12/4)           ;Reset start address
.over1:         move            r22,r0                  ;Save current offset
                store           r22,(r14+28/4)          ;Update current offset
                shrq            #8,r22                  ;Divide by 256
                load            (r14+12/4),r1           ;Samp start address
                and             r23,r0                  ;mask $ff
                add             r1,r22                  ;Samp Offset address
                moveta          r0,r7                   ;Save offset low-byte

done_chans:     loadb           (r15),r0                ;get chan 1 byte 1
                loadb           (r16),r1                ;get chan 2 byte 1
                shlq            #8,r0                   ;scale up
                shlq            #8,r1                   ;scale up
                moveta          r0,r8                   ;store chan 1 byte 1
                moveta          r1,r10                  ;store chan 2 byte 1
                addqt           #1,r15                  ;inc chan 1 pointer
                addqt           #1,r16                  ;inc chan 2 pointer
                loadb           (r15),r0                ;get chan 1 byte 2
                loadb           (r16),r1                ;get chan 2 byte 2
                shlq            #8,r0                   ;scale up
                shlq            #8,r1                   ;scale up
                moveta          r0,r9                   ;store chan 1 byte 2
                moveta          r1,r11                  ;store chan 2 byte 2
                loadb           (r17),r0                ;get chan 3 byte 1
                loadb           (r18),r1                ;get chan 4 byte 1
                shlq            #8,r0                   ;scale up
                shlq            #8,r1                   ;scale up
                moveta          r0,r12                  ;store chan 3 byte 1
                moveta          r1,r14                  ;store chan 4 byte 1
                addqt           #1,r17                  ;inc chan 3 pointer
                addqt           #1,r18                  ;inc chan 4 pointer
                loadb           (r17),r0                ;get chan 3 byte 2
                loadb           (r18),r1                ;get chan 4 byte 2
                shlq            #8,r0                   ;scale up
                shlq            #8,r1                   ;scale up
                moveta          r0,r13                  ;store chan 3 byte 2
                moveta          r1,r15                  ;store chan 4 byte 2
                loadb           (r19),r0                ;get chan 5 byte
                loadb           (r20),r1                ;get chan 6 byte
                moveta          r0,r16                  ;store chan 5 byte
                moveta          r1,r17                  ;store chan 6 byte
                loadb           (r21),r0                ;get chan 7 byte
                loadb           (r22),r1                ;get chan 8 byte
                moveta          r0,r18                  ;store chan 7 byte
                moveta          r1,r19                  ;store chan 8 byte


                load            (r28),r0                ;get DSP FLAGS
                bset            #14,r0                  ;change to alt regs
                store           r0,(r28)                ;do it

                nop
                nop

                movefa          r23,r28                 ;get $ff
                sub             r0,r28                  ;calc chan 1 offset
                imult           r0,r9                   ;scale byte 2
                imult           r28,r8                  ;scale byte 1
                movefa          r23,r28                 ;get $ff
                add             r8,r9                   ;combine chan1 byte1+2
                sub             r1,r28                  ;calc chan 2 offset
                imult           r1,r11                  ;scale byte 2
                imult           r28,r10                 ;scale byte 1
                movefa          r23,r28                 ;get $ff
                add             r10,r11                 ;combine chan2 byte1+2
                sub             r2,r28                  ;calc chan 3 offset
                imult           r2,r13                  ;scale byte 2
                imult           r28,r12                 ;scale byte 1
                movefa          r23,r28                 ;get $ff
                add             r12,r13                 ;combine chan3 byte1+2
                sub             r3,r28                  ;calc chan 4 offset
                imult           r3,r15                  ;scale byte 2
                imult           r28,r14                 ;scale byte 1
                add             r14,r15                 ;combine chan4 byte1+2


                sharq           #8,r9                   ;lose 8 low bits ch 1
                sharq           #8,r11                  ;lose 8 low bits ch 2
                sharq           #8,r13                  ;lose 8 low bits ch 3
                sharq           #8,r15                  ;lose 8 low bits ch 4
                shlq            #8,r16                  ;scale up chan 5 byte
                shlq            #8,r17                  ;scale up chan 6 byte
                shlq            #8,r18                  ;scale up chan 7 byte
                shlq            #8,r19                  ;scale up chan 8 byte
                imult           r20,r9                  ;volume scale chan 1
                imult           r21,r11                 ;volume scale chan 2
                imult           r22,r13                 ;volume scale chan 3
                imult           r23,r15                 ;volume scale chan 4
                imult           r24,r16                 ;volume scale chan 5
                imult           r25,r17                 ;volume scale chan 6
                imult           r26,r18                 ;volume scale chan 7
                imult           r27,r19                 ;volume scale chan 8
                sharq           #15,r9                  ;scale down chan 1
                sharq           #15,r11                 ;scale down chan 2
                sharq           #15,r13                 ;scale down chan 3
                sharq           #15,r15                 ;scale down chan 4
                sharq           #8,r16                  ;scale down chan 5
                sharq           #8,r17                  ;scale down chan 6
                sharq           #8,r18                  ;scale down chan 7
                sharq           #8,r19                  ;scale down chan 8

                movei           #$5800,r0               ;normal scale mixer
                movei           #$6000,r1               ;higher scale mixer
                movei           #$3000,r2               ;lower scale mixer
                imultn          r9,r1                   ;chan 1 loud left
                imacn           r11,r2                  ;chan 2 quiet left
                imacn           r13,r2                  ;chan 3 quiet left
                imacn           r15,r1                  ;chan 4 loud left
                imacn           r16,r0                  ;chan 5 normal left
                imacn           r17,r0                  ;chan 6 normal left
                imacn           r18,r0                  ;chan 7 normal left
                imacn           r19,r0                  ;chan 8 normal left
                resmac          r3                      ;final left chan mix
                imultn          r9,r2                   ;chan 1 quiet right
                imacn           r11,r1                  ;chan 2 loud right
                imacn           r13,r1                  ;chan 3 loud right
                imacn           r15,r2                  ;chan 4 quite right
                imacn           r16,r0                  ;chan 5 normal right
                imacn           r17,r0                  ;chan 6 normal right
                imacn           r18,r0                  ;chan 7 normal right
                imacn           r19,r0                  ;chan 8 normal right
                resmac          r4                      ;final right chan mix

                sharq           #15,r3                  ;get 16 most sig bits
                sharq           #15,r4                  ;get 16 most sig bits
                sat16s          r3                      ;saturate 16 bit left
                sat16s          r4                      ;saturate 16 bit right

                movefa          r28,r0                  ;get dsp flags pointer
                load            (r0),r1                 ;get dsp flags
                bclr            #14,r1                  ;change to normal regs
                store           r1,(r0)                 ;do it

                nop
                nop

                moveq           #0,r27                  ;clear int wait flag
                movefa          r3,r0                   ;get left channel val
                movefa          r4,r1                   ;get right channel val
                movei           #L_I2S,r14              ;point to sound h/ware
                movei           #do_chan_1,r2           ;point to start

s_wait_int:     cmpq            #1,r27                  ;wait for timer int
                jr              ne,s_wait_int           ;not yet?
                nop
                store           r0,(r14)                ;output left channel
                store           r1,(r14+4/4)            ;output right channel
                jump            (r2)                    ;and do it all again
                nop                                     ;this is the weird one!!!!

                .phrase
                .dc.l           0,0,0,0,0,0,0,0         ;stack w/space
dsp_stack:      .dc.l           0,0                     ;stack pointer
dsp_dummy:      .dc.l           0,0                     ;empty dummy sample
dsp_chan1:      .dc.l           0                       ;enable/disable channel, 0=disabled
                .dc.l           0                       ;channel volume in low word, sample looping flag in high word
                .dc.l           0                       ;sample length
                .dc.l           0                       ;sample start address
                .dc.l           0                       ;sample playback frequency
                .dc.l           0                       ;sample looping length (or 0)
                .dc.l           0                       ;sample looping start address (or 0)
                .dc.l           0                       ;current offset into sample
dsp_chan2:      .dc.l           0,0,0,0,0,0,0,0         ;chans 2 to 8 are as above
dsp_chan3:      .dc.l           0,0,0,0,0,0,0,0
dsp_chan4:      .dc.l           0,0,0,0,0,0,0,0
dsp_chan5:      .dc.l           0,0,0,0,0,0,0,0
dsp_chan6:      .dc.l           0,0,0,0,0,0,0,0
dsp_chan7:      .dc.l           0,0,0,0,0,0,0,0
dsp_chan8:      .dc.l           0,0,0,0,0,0,0,0

                .68000

dsp_code_end:   .dc.l           0

