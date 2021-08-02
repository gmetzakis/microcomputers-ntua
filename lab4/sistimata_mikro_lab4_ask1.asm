/*
 * sistimata_mikro_lab4_ask1.asm
 *
 *  Created: 27-May-20 11:28:17 AM
 *   Author: giann
 */ 


 .INCLUDE "m16def.inc"

.def counter=r20
.def input=r23
.org 0

reset:
	ldi r24,low(RAMEND)		;itilialize stack pointer
	out SPL,r24
	ldi r24,high(RAMEND)
	out SPH,r24
	clr r27

main:
	clr r28			
	out DDRC,r28			;portC input
	ser r28			
	out DDRB,r28			;portB output
	
	ldi r27,0x01		
	out PORTB,r27			
	ldi counter,7			;set counter value 7


left:
	in input,PINC			;diavazw eisodo
	andi input,0x04
	cpi input,0x04
	breq left			
					
	clc				
	rol r27			
	out PORTB,r27		
	dec counter			
	cpi counter,0		;an 0 exw ftasei gwnia, opote phgaine right
	breq right
	rjmp left			

right:
	in input,PINC			
	andi input,0x04
	cpi input,0x04
	breq right
	clc				
	ror r27
	out PORTB,r27		
	inc counter			
	cpi counter,7			
	breq left
	rjmp right			