// JAVIER DE VELASCO ORIOL A01202564    PRO AS HECK DUDE. GUAPO, SEXY Y PROGRAMADOR. YO SI LE DABA
// JOSE AXEL SALAZAR A01202564      NIGGA STOLE MAH PROGRAM.
// RICARDO ANTONIO MEDINA ESPINOSA A01202576       
// MASTER NOOB KARG POR PROPONER SOLUCIONES CHACAS    SPOILER BITCH. GOT REKT. RICK APPROVES


 #include <MEGA328P.h> 
    #include <delay.h> 
    #include "display.h"
    #include <stdio.h>
             
unsigned char TH1;                 
char Cadena[15];
unsigned long frecuencia;
unsigned int i;

void main(void)
{
    ConfiguraLCD(); 
    MoverCursor(1,0);
    StringLCD("Hola");
    TCCR1B=0x07; 
    TH1=0;                         //      T1 para conteo de eventos
    while(1)
    {   
        
        TCNT1H=0;
        TCNT1L=0;                             //Inicia la cuenta                         
        for(i=0; i<50;i++)
            {                         
                delay_ms(19);
                delay_us(979);

                   //Tarda 1.125 (.375 del else + 6 nops de 125nsg cada uno)
                if (TIFR1.TOV1==1)
{
TIFR1.TOV1=1; //Cuando se ejecuta el IF tarda en total 1.125 useg 
TH1++; //0.25useg del IF, 0.25useg del TIFR1.TOV1=1 
// y 0.625useg delTH1++; 
}
else
{
#asm
NOP
NOP
NOP
NOP// HARR HARR DELAYS PARA ERROR MENOR A .000001% HARRRRRRR
NOP
NOP
NOP
NOP
NOP
#endasm //Tarda 1.125 (.375 del else + 6 nops de 125nsg cada uno)
}

                }
        frecuencia=TCNT1L;
        frecuencia=frecuencia+(long)TCNT1H*256+(long)TH1*65536;      //frecuencia=frecuencia+TCNT1H*256
        if(frecuencia>500000){// SOLUCION AL PROBLEMA GANDALLA DEL TIEMPO DE LA FUNCION
        frecuencia=frecuencia-65536;
        
        }
        sprintf(Cadena,"Frec -> %lu",frecuencia);
        TH1=0;
        MoverCursor(6,1);                               //mover cursor o borrar es lo mismo
        StringLCDVar(Cadena);                         

}}   
  