/* Sample source program for the MCC18 compiler */
/*	File name:	C_Template.c					*/
/*	Version:	1.0								*/
/*	Author:		Your Name Here								*/
/*	Company:	Coventry University								*/
/*	Date:		DD/MM/YY								*/
/*	Program function: The following example uses PORT C as a digital output */
/*  LEDs attached to the Port will show a toggling values of 1s and 0s 		*/

/* The following configure operational parameters of the PIC 				*/

#pragma config OSC = HS     //set osc mode to HS  high speed clock			
#pragma config WDT = OFF    // set watchdog timer off 						
#pragma config LVP = OFF    // Low Voltage Programming Off 					
#pragma config DEBUG = OFF  // Compile without extra Debug compile Code 	

/* Include Files 														    */

#include <p18f4520.h>        // Device used is the PICF4520 				
#include <delays.h>			//  Include the delays routines					

unsigned char C = 0xAA;		// Assign hex value 0xAA to C
unsigned char D = 0x55;		// Assign hex value 0x55 to D									

void main (void){

	/*		Set PORT C as Digital Outputs		*/
	
	LATC = 0x00;    // Initialise Port C 										
	TRISC = 0x00;   // Configure Port C as O/P 
								
	while (1){			//  run forever									    
		LATC = C;		     // write the value of C (AA) into Port C 				
		Delay10KTCYx(100);  // Short delay here so we can see output
		LATC = D;		     // write the value of D (55) into Port C 				
		Delay10KTCYx(100);  // Short delay here so we can see output
	 }
}