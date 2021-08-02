/*
 * sistimata_mikro_lab4_ask2.asm
 *
 *  Created: 27-May-20 11:57:53 AM
 *   Author: giann
 */ 


 .INCLUDE "m16def.inc"

.def input=r18
.def A=r20
.def B=r21
.def C=r22
.def D=r23
.def F0=r24
.def F1=r25

main:	
	ldi r27,1
	clr r28
	out DDRB,r28		;portB for input
	ser r28
	out DDRA,r28		;portA for output

	in input,PINB		
	mov A,input		;A
	andi A,0x01		

	mov B,input		;B
	andi B,0x02
	ror B			

	mov C,input		;C
	andi C,0x04
	ror C
	ror C			

	mov D,input		;D
	andi D,0x08
	ror D
	ror D
	ror D			

	mov F0,A
	mov r29,B		;F0
	eor r29,r27
	and F0,r29
	mov r29,C
	eor r29,r27;	;Xor gia to not
	and r29,D
	and r29,B
	or F0,r29
	eor F0,r27

	mov F1,A		;F1
	or F1,C
	mov r29,B
	or r29,D
	and F1,r29
	
	clc
	rol F1
	add F0,F1
	out PORTA,F0

	rjmp main