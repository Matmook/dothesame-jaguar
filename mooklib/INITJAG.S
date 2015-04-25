	jsr 	op_create_initial_list
	jsr		init_GPU   	  				
	move.w	#CRY16|CSYNC|BGEN|PWIDTH4|VIDEN,VMODE ; Configure Video			
	jsr 	scrn_set_vbl_interrupt	
			
	; start GPU	
	move.l	#G_RAM,G_PC
	move.l	#1,G_CTRL
	