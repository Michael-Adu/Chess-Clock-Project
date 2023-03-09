;******************************************************************************
;                                                            *
;    Filename:           Assembler_Template.asm            	 *
;    Date:               DD/MM/YY                            *
;    File Version:       1.0                                 *
;                                                            *
;    Author:             Your Name Here                                 *
;    Company:            Coventry University                 *
;   
; Program Function :  -----                                                                                 * 
;******************************************************************************
;                                                                             *
;    Files Required: P18F4520.INC                                             *
;                                                                             *
;******************************************************************************

    LIST P=18F4520		    ; directive to define processor
    #include <P18F4520.INC>	; processor specific variable definitions

;******************************************************************************
; CONFIGURATION BITS
; (Microchip has changed the format for defining the configuration bits, please 
; see the .inc file for further details on notation).  Below are a few examples.
;
;
;
;   Oscillator Selection and other fuse settings:

    CONFIG  	OSC    	=  			HS        ;High Speed clock
    CONFIG    MCLRE  	=  			ON         ;MCLR enabled
    CONFIG    DEBUG  	=  			OFF        ;Background debugger disabled, RB6 and RB7 configured as general   IO
    CONFIG    LVP    	= 	 		OFF	    ; Low Voltage Programming OFF
    CONFIG    WDT     	=  			OFF        ; WDT disabled

;******************************************************************************
; RESET VECTOR
; This code will start executing when a reset occurs.

		ORG	0x0000				; ORG

  		goto	Main            ;go to start of main code


Main:



		
;******************************************************************************
; End of program

		END						; End Directive
