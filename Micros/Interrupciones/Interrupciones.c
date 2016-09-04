 #include <mega328P.h>      
 #include <delay.h>
 
 
flash unsigned char sieteSeg[10]={0xFC,0x60,0xDB,0xF3,0x66,0xB7,0xBE,0xE1,0xFE,0xF6};
 unsigned char seg=0, contador;
 
 interrupt [TIM0_COMPA] void timer0_compa_isr (void)
 {  
    contador++;
    if( contador==4)
    {
        TCCR0B=0x00;    
        delay_us(140);
        contador=0 ;
        PORTD=sieteSeg[seg++];
        if (seg==10)
        seg=0;
    }
 }
 void main (void){   
    DDRD=0xFF;
    PORTB.0=1;
    TCCR0A=0x02;
    TCCR0B=0x05;
    OCR0A=243; 
    TIMSK0=0x02;   
    PORTD=sieteSeg[seg];
    #asm("SEI");
    while(1)
    {
        if (PINB.0==0){
          TCCR0B=0x05;
          }    
        else{
          TCCR0B=0x0;}             
        
    }

 }