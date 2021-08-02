/*
 * sistimata_mikro_lab4_ask3.c
 *
 * Created: 27-May-20 12:34:14 PM
 *  Author: giann
 */ 

#include <avr/io.h>
unsigned char x;
 
int main(void){
	DDRB = 0xff;    //portB output
	DDRA = 0x00;    //portA input 
     
	x = 1;
	PORTB = x;
	while(1){
		if((PINA & 0x01) == 1){ //1o
			while((PINA & 0x01) == 1){} //wait to release
			if(x == 0x01){
				x = 0x80;
			}
			else{
				x = x>>1;
			}
		}
		if((PINA & 0x02) == 2){	//2o
			while((PINA & 0x02) == 2){}
			
			if(x == 0x80){	
				x = 0x01;
			}
			else{
				x = x<<1;
			}
		}
		if((PINA & 0x04) == 4){ //3o
			while((PINA & 0x04) == 4){} 
			x = 0x01;
		}
		if((PINA & 0x08) == 8){ //4o
			while((PINA & 0x08) == 8){} 
			x = 0x80;
		}
		PORTB = x;
	}
	return 0;   
}