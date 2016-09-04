 #include <MEGA328P.h> 
    #include <delay.h> 
    
 void main(void){ 
    PORTD=0xFF;
    PORTB=0xFF;
    DDRC=0x03;
    while(1){
        if(PIND==PINB){
        PORTC.0=1;
        PORTC.1=0;
        }
        else if(PINB>PIND){
        PORTC.0=0;
        PORTC.1=1;
        }
        else{
        PORTC.0=0;
        PORTC.1=0;
        }
    }
 }
 