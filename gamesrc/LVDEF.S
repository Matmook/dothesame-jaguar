MAX_EASY_LEVEL .equ 2
.long
levelstarteasy:
;practice01 | position : 1 | difficulty : *
dc.b 0,0,0,0,0,0
dc.b 0,0,9,9,0,0
dc.b 0,0,10,10,0,0
dc.b 0,0,9,9,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,10,9,0,0
dc.b 0,0,9,10,0,0
dc.b 0,0,9,9,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
;practice02 | position : 2 | difficulty : *
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,11,11,10,10,0
dc.b 0,11,11,10,10,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,10,10,10,11,0
dc.b 0,11,11,11,10,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0

MAX_MEDIUM_LEVEL .equ 2

.long
levelstartmedium:
;castle_I | position : 1 | difficulty : **
dc.b 0,0,1,1,0,0
dc.b 0,0,1,1,0,0
dc.b 0,0,2,2,0,0
dc.b 0,0,2,2,0,0
dc.b 0,0,1,1,0,0
dc.b 0,0,1,1,0,0
dc.b 0,0,1,2,0,0
dc.b 0,0,2,1,0,0
dc.b 0,0,1,2,0,0
dc.b 0,0,1,1,0,0
dc.b 0,0,1,2,0,0
dc.b 0,0,1,1,0,0
;troll003 | position : 2 | difficulty : *
dc.b 0,0,0,0,0,0
dc.b 0,13,12,12,13,0
dc.b 0,12,13,13,12,0
dc.b 0,12,13,13,12,0
dc.b 0,13,12,12,13,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,12,13,12,13,0
dc.b 0,12,13,13,12,0
dc.b 0,12,12,13,13,0
dc.b 0,13,12,13,12,0
dc.b 0,0,0,0,0,0

MAX_HARD_LEVEL .equ 2
.long
levelstarthard:
;hard_01 | position : 1 | difficulty :
dc.b 0,0,0,0,0,0
dc.b 0,0,2,2,0,0
dc.b 0,0,18,18,0,0
dc.b 0,0,2,2,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,2,18,0,0
dc.b 0,0,2,2,0,0
dc.b 0,0,18,2,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
;hard_02 | position : 2 | difficulty :
dc.b 0,0,0,0,0,0
dc.b 0,0,1,1,0,0
dc.b 0,0,15,15,0,0
dc.b 0,0,15,15,0,0
dc.b 0,0,1,1,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,0,0,0,0
dc.b 0,0,15,1,0,0
dc.b 0,0,15,1,0,0
dc.b 0,0,1,1,0,0
dc.b 0,0,15,15,0,0
dc.b 0,0,0,0,0,0

