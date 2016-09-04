 #include <mega328P.h>
 #include <delay.h>
 
 flash unsigned char seno[100]=
{128,136,144,152,160,167,175,182,189,196,203,209,215,221,226,231,235,239,243,246,249,251,
253,254,255,255,255,254,253,251,249,246,243,239,235,231,226,221,215,209,203,196,189,182,
175,167,160,152,144,136,128,120,112,104,96,89,81,74,67,60,53,47,41,35,30,25,21,17,13,10,
7,5,3,2,1,1,1,2,3,5,7,10,13,17,21,25,30,35,41,47,53,60,67,74,81,89,96,104,112,120};
unsigned char i;

void main()
{
    TCCR0A=0x83;
    TCCR0B=0x01;
    DDRD.6=1;
    CLKPR=0x80;
    CLKPR=0x00;
    PORTD.0=1;
    PORTD.1=1;
    PORTD.2=1;
    while(1)
    
    {
        i=0;
        if(PIND.0==0){
        delay_ms(30);
        while(i<7200){
        OCR0A=sonido1[i++];
        delay_us(122);
        #asm
        NOP
        NOP
        NOP
        #endasm
        }
        }
        if(PIND.1==0){
        delay_ms(30);
        while(i<7280){
        OCR0A=sonido2[i++];
        delay_us(122);
        #asm
        NOP
        NOP
        NOP
        #endasm
        }
        }
        if(PIND.2==0){
        delay_ms(30);
        while(i<7200){
        OCR0A=sonido3[i++];
        delay_us(122);
        #asm
        NOP
        NOP
        NOP
        #endasm
        }
        }
    }
}