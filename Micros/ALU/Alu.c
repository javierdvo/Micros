 #include <mega328P.h>
  #include <delay.h>


 
 void main (void){
    DDRD=0xFF; //PB1 de salida
    PORTB=0xFF;
    PORTC=0xFF; 

    while(1)
    {
        switch(PINC&0x07){
                
            case 0x00:
            {
                 PORTD.0=!PINB.0;
                 PORTD.1=!PINB.1;
                 PORTD.2=!PINB.2;
                 PORTD.3=!PINB.3;
                 break;
            }
            case 0x01:
            {
                 PORTD.0=PINB.0&&PINB.4;
                 PORTD.1=PINB.1&&PINB.5;
                 PORTD.2=PINB.2&&PINB.6;
                 PORTD.3=PINB.3&&PINB.7;
                 break;
            }
            case 0x02:
            {
                 PORTD.0=!(PINB.0&&PINB.4);
                 PORTD.1=!(PINB.1&&PINB.5);
                 PORTD.2=!(PINB.2&&PINB.6);
                 PORTD.3=!(PINB.3&&PINB.7);
                 break;
            }
           case 0x03:
            {
                 PORTD.0=PINB.0||PINB.4;
                 PORTD.1=PINB.1||PINB.5;
                 PORTD.2=PINB.2||PINB.6;
                 PORTD.3=PINB.3||PINB.7;
                 break;
            }
           case 0x04:
            {
                 PORTD.0=!(PINB.0||PINB.4);
                 PORTD.1=!(PINB.1||PINB.5);
                 PORTD.2=!(PINB.2||PINB.6);
                 PORTD.3=!(PINB.3||PINB.7);
                 break;
            }
            case 0x05:
            {
                 PORTD.0=((PINB.0&&(!PINB.4))||(PINB.4&&(!PINB.0)));
                 PORTD.1=((PINB.1&&(!PINB.5))||(PINB.5&&(!PINB.1)));
                 PORTD.2=((PINB.2&&(!PINB.6))||(PINB.6&&(!PINB.2)));
                 PORTD.3=((PINB.3&&(!PINB.7))||(PINB.7&&(!PINB.3)));
                 break;
            }
            case 0x06:
            {
                 PORTD.0=!((PINB.0&&(!PINB.4))||(PINB.4&&(!PINB.0)));
                 PORTD.1=!((PINB.1&&(!PINB.5))||(PINB.5&&(!PINB.1)));
                 PORTD.2=!((PINB.2&&(!PINB.6))||(PINB.6&&(!PINB.2)));
                 PORTD.3=!((PINB.3&&(!PINB.7))||(PINB.7&&(!PINB.3)));
                 break;
            }
            case 0x07:
            {     
                 PORTD=(PINB&0x0F)+((PINB&0xF0)>>4);
                 break;
            }
        }
    }
 }