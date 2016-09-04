 #include <MEGA328P.h> 
    #include <delay.h> 
    #include "display.h"
    #include <stdio.h>         


unsigned char segundos=0,minutos=0,decimas=0;
char Cadena[20];

char car0[8]={0x08,0x1F,0x0A,0x0C,0x0F,0x0C,0x0E,0x1B};
char car1[8]={0x08,0x14,0x0E,0x1F,0x0E,0x14,0x08,0x00};

char car2[8]={0x00,0x04,0x0E,0x1F,0x0E,0x04,0x00,0x00};
char car3[8]={0x15,0x1F,0x0A,0x06,0x1E,0x06,0x06,0x1B};

char car4[8]={0x0A,0x1F,0x0E,0x1F,0x0E,0x1F,0x0E,0x15};
char car5[8]={0x0A,0x04,0x0E,0x04,0x0E,0x04,0x0A,0x04};
char car6[8]={0x00,0x00,0x04,0x0E,0x04,0x00,0x00,0x00};
char car7[8]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
char car8[8]={0x00,0x00,0x00,0x00,0x00,0x00,0x00,0x00};
char car9[8]={0x00,0x00,0x00,0x00,0x00,0x00,0x04,0x0F};
int y;
            
void main()
{
    ConfiguraLCD();
    PORTD.0=1;
    PORTD.1=1;
    CreaCaracter(0,car0);
    CreaCaracter(1,car1);
    CreaCaracter(2,car2);
    CreaCaracter(3,car3);
    CreaCaracter(4,car4);
    CreaCaracter(5,car5);
    CreaCaracter(6,car6);
    CreaCaracter(7,car7);
    CreaCaracter(8,car8);
    CreaCaracter(9,car9);
    y=0;
    MoverCursor(0,0);
    StringLCD("     CRONOMETRO");
    while(1)
    {   
        if(PIND.0==1){
        if(PIND.1==0)
        {
        segundos=0;
        minutos=0;
        decimas=0;
        }
        sprintf(Cadena,"%02i:%02i:%i",minutos,segundos,decimas);
        MoverCursor(8,2);
        LetraLCD(0); 
        if(y<10){
        MoverCursor(14,2);
        LetraLCD(3);
        }
        else{
        delay_ms(10);
        }
        switch (y) {
        case 0:{
        MoverCursor(9,2);
        LetraLCD(1);
        break;}
        case 1:{
        MoverCursor(9,2);
        LetraLCD(2);
        break;}
        case 2:{
        MoverCursor(9,2); 
        LetraLCD(' ');
        MoverCursor(10,2);
        LetraLCD(1);
        break;}
        case 3:{
        MoverCursor(10,2);
        LetraLCD(2);
        break;}
        case 4:{
        MoverCursor(10,2);
        LetraLCD(' ');
        MoverCursor(11,2);
        LetraLCD(1);
        break;}
        case 5:{
        MoverCursor(11,2);
        LetraLCD(2);
        break;}
        case 6:{
        MoverCursor(11,2);
        LetraLCD(' ');
        MoverCursor(12,2);
        LetraLCD(1);
        break;}
        case 7:{
        MoverCursor(12,2);
        LetraLCD(2);
        break;}
        case 8:{
        MoverCursor(12,2);
        LetraLCD(' ');
        MoverCursor(13,2);
        LetraLCD(1);
        break;}
        case 9:{
        MoverCursor(13,2);
        LetraLCD(2);
        break;}
        case 10:{
        MoverCursor(13,2);
        LetraLCD(' ');
        MoverCursor(14,2);
        LetraLCD(5);
        break;}
        case 11:{
        MoverCursor(14,2);
        LetraLCD(6);
        break;}
        case 12:{
        MoverCursor(14,2);
        LetraLCD(7);
        break;}
        case 13:{
        MoverCursor(14,2);
        LetraLCD(7);
        break;}
        case 14:{
        MoverCursor(14,2);
        LetraLCD(7);
        break;}
        }
        MoverCursor(6,1);
        StringLCDVar(Cadena);
        delay_ms(20);
        decimas++;
        y++;
        if(y==14){
         y=0;
        }
        else{
        delay_ms(5);
        }
        if(decimas==10){
        decimas=0;
        segundos++;
        if(segundos==60)
        {
            segundos=0;
            minutos++;
            if(minutos==60)
                minutos=0;
                }
                else{
        delay_ms(5);
        }
                }
                else{
        delay_ms(10);
        }
                
      }}
}
    
