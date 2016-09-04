 #include <mega328P.h>
 #include <delay.h>
 
 
 void main(void)
 {
  DDRB.1=1;
  TCCR1A=0x81;
  //TCCR1B=0x01;// PHASE CORRECT PWM    
  TCCR1B=0x09; // FAST PWM
  while(1){
   OCR1AH=0;
   OCR1AL=PIND;
  }
 }