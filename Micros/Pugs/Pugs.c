 #include <mega328P.h>
 #include <delay.h>
 
 
 void main(void)
 {
DDRD.6=1;
DDRD.7=1;
PORTD.7=1;
PORTD.6=1;

  while(1){
   PIND.7=1;
    PIND.6=0;
   delay_ms(150);
   PIND.7=0;
    PIND.6=1;
  }
 }