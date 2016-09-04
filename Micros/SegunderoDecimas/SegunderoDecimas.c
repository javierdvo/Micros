 #include <MEGA328P.h> 
    #include <delay.h> 
    #include <stdio.h>   
unsigned char segundos=0,decimas=0;

void main(void)
{    
DDRD=0xFF;
 while(1){

    switch (decimas){
        case 0:{
        PORTD.0=0;
        PORTD.1=0;
        PORTD.2=0;
        PORTD.3=0;
        break;}
        case 1:{
        PORTD.0=1;
        PORTD.1=0;
        PORTD.2=0;
        PORTD.3=0;
        break;}
        case 2:{
        PORTD.0=0;
        PORTD.1=1;
        PORTD.2=0;
        PORTD.3=0;
        break;}
        case 3:{
        PORTD.0=1;
        PORTD.1=1;
        PORTD.2=0;
        PORTD.3=0;
        break;}
        case 4:{
        PORTD.0=0;
        PORTD.1=0;
        PORTD.2=1;
        PORTD.3=0;
        break;}
        case 5:{
        PORTD.0=1;
        PORTD.1=0;
        PORTD.2=1;
        PORTD.3=0;
        break;}
        case 6:{
        PORTD.0=0;
        PORTD.1=1;
        PORTD.2=1;
        PORTD.3=0;
        break;}
        case 7:{
        PORTD.0=1;
        PORTD.1=1;
        PORTD.2=1;
        PORTD.3=0;
        break;}
        case 8:{
        PORTD.0=0;
        PORTD.1=0;
        PORTD.2=0;
        PORTD.3=1;
        break;}
        case 9:{
        PORTD.0=1;
        PORTD.1=0;
        PORTD.2=0;
        PORTD.3=1;
        break;}
    }
    switch (segundos){
        case 0:{
        PORTD.4=0;
        PORTD.5=0;
        PORTD.6=0;
        PORTD.7=0;
        break;}
        case 1:{
        PORTD.4=1;
        PORTD.5=0;
        PORTD.6=0;
        PORTD.7=0;
        break;}
        case 2:{
        PORTD.4=0;
        PORTD.5=1;
        PORTD.6=0;
        PORTD.7=0;
        break;}
        case 3:{
        PORTD.4=1;
        PORTD.5=1;
        PORTD.6=0;
        PORTD.7=0;
        break;}
        case 4:{
        PORTD.4=0;
        PORTD.5=0;
        PORTD.6=1;
        PORTD.7=0;
        break;}
        case 5:{
        PORTD.4=1;
        PORTD.5=0;
        PORTD.6=1;
        PORTD.7=0;
        break;}
        case 6:{
        PORTD.4=0;
        PORTD.5=1;
        PORTD.6=1;
        PORTD.7=0;
        break;}
        case 7:{
        PORTD.4=1;
        PORTD.5=1;
        PORTD.6=1;
        PORTD.7=0;
        break;}
        case 8:{
        PORTD.4=0;
        PORTD.5=0;
        PORTD.6=0;
        PORTD.7=1;
        break;}
        case 9:{
        PORTD.4=1;
        PORTD.5=0;
        PORTD.6=0;
        PORTD.7=1;
        break;}
    }
    delay_ms(99);
    delay_us(310);
    decimas++;
     if(decimas==10){
        decimas=0;
        segundos++;
        if(segundos==10)
        {
            segundos=0;
        }
        }
     }
}