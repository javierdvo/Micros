 #include <mega328P.h>
 
 void main (void){
    DDRD.6=1; //PD6 salida    
    PORTD.0=1; //PD0 Pullup
    DDRB.1=1;  //PB1 de salida
    TCCR0A=0x42; //Modo CTC con salida en OC0A
    TCCR0B=0x02;  // prescalador CK/8
    OCR0A=155;
    TCCR1A=0x40;// CTC salida en OC1A
    TCCR1B=0x09; //  Sin pre-escalador  
    OCR1AH=399/256;
    OCR1AL=399%256; //timer 400 cuentas
    while(1){   
        if (PIND.0==0){
            TCCR0B=0x02;   //cuenta
        }
        else{
            TCCR0B=0x00;   //no cuenta
        }
    }
  }