#include <stdio.h>
#include <mega328p.h> 

unsigned char sep1,sep2;
char Cadena[20];
int dia,mes,diasemana,year;
char dias[7][10]={"Sabado","Domingo","Lunes","Martes","Miercoles","Jueves","Viernes"};

void main(void){
UCSR0A=0x02;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x0C;
while(1)
{
    printf("Dame la fecha en formato dd-mm-yyyy -> ");
    scanf("%s",Cadena);
    sscanf( Cadena, "%i%c%i%c%i",&dia,&sep1,&mes,&sep2,&year);                                                                       
    if((sep1=='-')&&(sep2=='-'))
    {
        if((dia>=1)&&(dia<=31)&&(mes>=1)&&(mes<=12)&&(year>=1)){
            if (mes<=2)
            {
                mes=mes+12;
                year--;
            }
            else{
            }
            diasemana=(dia+((mes+1)*26/10)+year+(year/4)+((year/100)*6)+(year/400))%7;
            printf("El dia de la semana es %s\n\r",dias[diasemana]);
        }
        else 
        printf("Valores fuera del rango \n\r");
    }
    else 
        printf("Formato invalido \n\r");
}
}