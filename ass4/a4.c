/*
 * a4.c
 */
#define F_CPU 16000000UL

#include <avr/io.h>
#include <util/delay.h>

#include <string.h>
#include <stdlib.h>
#include <stdio.h>

#include "main.h"
#include "lcd_drv.h"

// These are included by the LCD driver code, so 
// we don't need to include them here.
// #include <avr/io.h>
// #include <util/delay.h>

int main( void )
{
    DDRL = 0xFF;
    DDRB = 0xFF;

    PORTL = 0x80;
	PORTB = 0x00;
    _delay_ms(1000);


	lcd_init();


	/* lcd_puts takes a pointer to a null terminated
	 * string and displays it at the current cursor position.
	 *
	 * In this call, I'm using a constant string
	 */

    int k=0;
	char b[17];
	int n=0;
	char a[200]="This is the first message displayed on the first line of the LCD.";
	char c[200]="On the second line of the LCD there is another message that is scrolled.";
	char d[17];
    int speed=1000;


    while(1){

       

 //lcd1111111111111111111111111111
       
	   int i=0;
	   int l=0;
	     for(i=0;i<16;i++){
		   if((i+k)<strlen(a)){
            b[i]=a[i+k];
			}else{
			 if(l<strlen(a)){
			b[i]=a[l];
			l=l+1;
			}else{
			l=0;
            b[i]=a[l];
			l=l+1;
			}
			}
		 }
	   b[16]=0;

	   k=k+1;
	   if(k==strlen(a)){
	   k=0;
	   }
	   

       
//lcd22222222222222222222222222222222222222


	   int j=0;
	   int m=0;
	     for(j=0;j<16;j++){
		   if((j+n)<strlen(c)){
            d[j]=c[j+n];
			}else{
			 if(m<strlen(c)){
			d[j]=c[m];
			m=m+1;
			}else{
			m=0;
            d[j]=c[m];
			m=m+1;
			}
			}
		 }

	   n=n+1;
	   if(n==strlen(c)){
	   n=0;
	   }
       d[16]=0;

	   lcd_xy( 0, 0 );
       lcd_puts(b);
	   lcd_xy( 0, 1 );
       lcd_puts(d);

	   button();
       if(a==2){
        break;
	   }




//led................................................
      if(PORTB==0x08){
         PORTB=0x02;
		 _delay_ms(1000);
		 continue;
	  }

	  if(PORTB==0x02){
        PORTB=0x00;
		PORTL=0X80;
		_delay_ms(1000);
		continue;
      }
      if(PORTL==0x02){
	      PORTL=0X00;
	      PORTB=0x08;
		  _delay_ms(1000);
		 continue;
      }
      else{
	  
      PORTL=PORTL>>2;
   	   _delay_ms(speed);
       
	    continue;
     
      }
   
    }
	
}		 



void button(){

	
	int a=0;
	


	// start conversion
	ADCSRA |= 0x40;

	// bit 6 in ADCSRA is 1 while conversion is in progress
	// 0b0100 0000
	// 0x40
	while (ADCSRA & 0x40)
    {
	unsigned int val = ADCL;
	unsigned int val2 = ADCH;

	val += (val2 << 8);

	
	if (val > 1000 )
	{
		a=0;
		continue;
	}
			 
    if (val < 50) 
	  a=1;  
    else if (val < 195)
	  a=2;
    else if (val < 380)  
	  a=4;
    else if (val < 555)  
	  a=8;
    else 
	  a=16;
	   
	}



}

















