 #include <mega328P.h>      
 #include <delay.h>
 
 
 #define RojoPeaton PORTD.3
 #define RojoAuto PORTD.5
 #define AmbarAuto PORTD.6
 #define VerdePeaton PORTD.4
 #define VerdeAuto PORTD.7

                                                                                 
 #define Dig1 PORTD.0
 #define Dig2 PORTD.1
                     
  unsigned char seg=0;
  bit peaton=0,selDigito=0;
unsigned char sieteSeg[10]={0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xf8,0x80,0x98};
 
 // External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
     peaton=1;
}

// Timer 0 output compare A interrupt service routine
interrupt [TIM0_COMPA] void timer0_compa_isr(void)
{
  selDigito=!selDigito;
  if(selDigito==0)
  {
    Dig1=1;
    PORTC=sieteSeg[seg/10];
    Dig2=0;
  }
  else
  {
    Dig1=0;
    PORTC=sieteSeg[seg%10];
    Dig2=1;
  }  

}
 
 
 
  void noTono(){
    TCCR1B=0x00;
 } 
 
 void tono(float frecuencia)
{
    unsigned int cuentasEnt;
    float cuentas;
    cuentas=(5000000.0/frecuencia);
    cuentasEnt=cuentas;
    if((cuentas-cuentasEnt)>+0.5)
        cuentasEnt++;    
    OCR1AH=(cuentasEnt-1)/256;
    OCR1AL=(cuentasEnt-1)%256;
    TCCR1A=0x40;
    TCCR1B=0x09;
}
 
 
 void main(void)
 {      
    unsigned char i;
    TCCR0A=0x02;
    TCCR0B=0x03;
    OCR0A=77;                  
    
    //external interrupts y clock0 
    EICRA=0x02;
    EIMSK=0x01;
    EIFR=0x01;
    TIMSK0=0x02;
    #asm("sei")
    ACSR=0x80;
    
    DDRD=0xFB;
    PORTD.2=1;
    DDRB.1=1;
    DDRC=0xFF;
    Dig1=1;
    Dig2=1;
    while (1)
      {
      VerdePeaton=0;
      RojoPeaton=1;
      VerdeAuto=1;
      AmbarAuto=0;
      RojoAuto=0;
      while (peaton==0); 
      VerdeAuto=0;
      AmbarAuto=1;
      delay_ms(2000);
      AmbarAuto=0;
      RojoAuto=1;
      VerdePeaton=1;
      RojoPeaton=0;
      seg=20;
      for (i=1;i<=20;i++)
      {
        tono(440);
        delay_ms(250);
        noTono();
        delay_ms(750);
        seg--;
      }
      VerdePeaton=0;
      RojoPeaton=1;
      VerdeAuto=1;
      RojoAuto=0;
      peaton=0;
      delay_ms(20000);
      } 
 }