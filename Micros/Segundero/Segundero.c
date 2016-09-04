#include <mega328P.h>
#include <delay.h>

unsigned char i=0;
flash unsigned char sieteSeg[10]={0xFC,0x60,0xDB,0xF3,0x66,0xB7,0xBE,0xE1,0xFE,0xF6};
void main(){
 DDRD=0xFF;
 PORTC.0=1;
 PORTD=sieteSeg[i++];
 while(1){  
    if(PINC.0==1){
    PORTD=sieteSeg[i++];
    if (i==10){i=0;}
    delay_ms(1000);}
 }

}