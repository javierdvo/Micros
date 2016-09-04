    #include <MEGA328P.h> 
    #include <delay.h> 
    #include "display.h"
    #include <stdio.h>         
               
char car0[8]={0x02,0x04,0x0E,0x11,0x1F,0x10,0x0E,0x00};
char car1[8]={0x09,0x12,0x09,0x00,0x1F,0x1F,0x0E,0x0E};

int segundosCafe[8]={45,40,40,20,120,75,75,40};
int encendido;
char entrada;
int aguaCafe[8]={70,80,80,75,170,150,160,150};
flash char tipoCafe[8][21]={"Cafe:  Ristretto    ","Cafe:  Indriya      ","Cafe:  Roma         ","Cafe:  Ciocattino   ","Cafe:  Ristretto 3x ","Cafe:  Indriya 2x   ","Cafe:  Roma   2x    ","Cafe:  Ciocattino 2x"};


flash int du=262,re= 294,mi =330;

flash int terminado[7]={du,re,du,re,mi,mi,mi};
                                                                     
flash int peligro[4]={re,du,re,du};




#define HacerCafe PIND.0
#define Listo PORTC.4
#define AlertaAgua PORTC.5
#define Trabajando PORTB.3

int seg,agua,i,cuentas;
char Cadenaentra[10];

void noTono()
{
    TCCR0B=0x00;        //Apagar Timer
}


void giraMotor(){
    OCR2B=0xFF;
    delay_ms(5000);
    OCR2B=0x00;
}
void tono(int m)
{    
    cuentas =(62500/m);
    TCCR0A=0x42;    //Toggle y CTC
    TCCR0B=0x03;    //Prende Timer 0 en CK/8
    OCR0A=cuentas-1;       //78 cuentas 256 - 1 = 255    decimal se pone asi natural   
}


void pushCafe(){
    giraMotor();
    OCR1AH = 0x05;
    OCR1AL = 0x14;
    delay_ms(250);
    OCR1AH = 0x06;
    OCR1AL = 0xA4;
    delay_ms(250);
    OCR1AH = 0x05;
    OCR1AL = 0xDC;
    delay_ms(500);

}
void pushEncendido(){
    OCR1BH = 0x06;
    OCR1BL = 0xA4;
    delay_ms(250);
    OCR1BH = 0x05;
    OCR1BL = 0x14;
    delay_ms(250);
    OCR1BH = 0x05;
    OCR1BL = 0xDC;
    //delay_ms(30000);
    encendido=!encendido;

}
void HaciendoCafe()
{
    pushCafe();
    while(seg>0)
    {   
        MoverCursor(0,2);
        StringLCD("Haciendo cafe       ");
        printf("Faltan %i segundos\n",seg+1);
        if(seg<10)
        {
            delay_ms(200);
            MoverCursor(14,2);
            StringLCD(".  ");
            sprintf(Cadenaentra,"Faltan %i segundos ",seg);
            printf("Faltan %i segundos\n",seg);
            delay_ms(200);
            MoverCursor(14,2);
            StringLCD(".. ");
            delay_ms(200);
            MoverCursor(0,3);
            StringLCDVar(Cadenaentra);
            seg--;
            MoverCursor(14,2);
            StringLCD("...");
            delay_ms(200);
        }
        sprintf(Cadenaentra,"Faltan %i segundos",seg);
        delay_ms(835);
        MoverCursor(0,3);
        StringLCDVar(Cadenaentra);
        seg--;
    }
    MoverCursor(0,2);
    StringLCD("       Listo!       ");
    MoverCursor(0,3);
    StringLCD(tipoCafe[entrada-48]);
    pushCafe();
}

void NivelBajo()
{
    MoverCursor(0,2);
    StringLCD("Nivel bajo de agua! ");
    MoverCursor(0,3);
    StringLCD("   Recargue agua    ");
    for(i=0;i<2;i++)
    {
        AlertaAgua=1;
        delay_ms(1000);
        AlertaAgua=0;
        delay_ms(1000);
    }    
}   

void main()
{
     
    ConfiguraLCD(); 
    CreaCaracter(0,car0);
    CreaCaracter(1,car1);
    DDRB.1=1;
    TCCR2A=0x23;
    TCCR2B=0x07;
    TCCR1A=0xA2;
    TCCR1B=0x1A;
    ICR1H=0x4E;
    ICR1L=0x20;
    
    UCSR0A=0x00;
    UCSR0B=0x18;
    UCSR0C=0x06;
    UBRR0H=0x00;
    UBRR0L=0x33;


    OCR1AH = 0x05;
    OCR1AL = 0xDC;
    OCR1BH = 0x05;
    OCR1BL = 0xDC;
    
    
    PORTD.0=1;
    PORTD.3=0;
    seg=0;
    agua=900;
    DDRD.3=1;
    DDRB.2=1;
    PORTB.5=1;
    DDRB.4=1;
    DDRD.6=1;
    DDRC.4=1;
    DDRC.5=1;
    DDRB.3=1;
    
    OCR2B=0x00;      
    MoverCursor(1,0);
    StringLCD("Microcontroladores");  
    MoverCursor(2,1);
    StringLCD2("Agosto-Diciembre",150);
    MoverCursor(8,2);
    StringLCD2("2014",150);
    MoverCursor(3,3);
    StringLCD("Proyecto Final");
    delay_ms(2000);
    BorrarLCD();
    MoverCursor(1,0);
    StringLCD("Javier de Velasco");
    MoverCursor(3,1);
    StringLCD("Ricardo Medina");
    MoverCursor(2,2);
    StringLCD("Fernando Villers");
    MoverCursor(4,3);
    StringLCD("Axel Salazar");
    delay_ms(2000);
    BorrarLCD();
    Listo=1;
    delay_ms(2000);
    encendido=1;
        
    while(1)
    {
        
        Listo=0;
        AlertaAgua=0;
        Trabajando=0;
        i=0;
        MoverCursor(1,0);
        StringLCD("Bienvenido a la ");
        LetraLCD(1);
        MoverCursor(0,1);
        StringLCD("Cafetera Inteligente");
        MoverCursor(0,2);
        if(agua <150 )
        {
            NivelBajo();
            while(i<4)
            {
                tono(peligro[i++]);
                delay_ms(500);
                noTono();
            }
            delay_ms(500);
            while(PINB.5==1)
            agua=900;
            i=0;
        }
        else{
            if(encendido==1){
             MoverCursor(0,2);
            StringLCD(" Indique una opcion ");
            MoverCursor(0,3);
            StringLCD("                    ");  }
            else{
             MoverCursor(0,2);
            StringLCD("  Cafetera Apagada  ");
            MoverCursor(0,3);
            StringLCD("                    ");  }
            printf("DAME LA MOTHERFUCKING OPCION RIGHT NOW \n");
            scanf("%c",&entrada);
            printf("%c lel\n",entrada);
            if((entrada-48) < 8)
            {
                printf("Caso 1 \n");
                if(encendido==1){
                    seg=segundosCafe[entrada-48];
                    Trabajando=1;
                    HaciendoCafe();
                    agua=agua-aguaCafe[entrada-48];
                    Trabajando=0;
                    Listo=1;
                    delay_ms(1000);
                    while(i<7)
                    {
                        tono(terminado[i++]);
                        delay_ms(500);
                        noTono();
                    } 
                    delay_ms(3000);
                    MoverCursor(0,2);
                    StringLCD("                    ");
                    MoverCursor(0,3);
                    StringLCD("                    ");
                }
                else{
                    MoverCursor(0,2);
                    StringLCD("  Cafetera Apagada  ");
                    MoverCursor(0,3);
                    StringLCD("  Favor de encender ");
                    delay_ms(2000);    
                }
            }
            else
            {
                printf("Caso 2 \n");
                if((entrada-48)==8){
                printf("Caso 3 \n");
                  if(encendido==1){
                    MoverCursor(0,2);
                    StringLCD("     Apagando...    ");
                    MoverCursor(0,3);
                    StringLCD("                    ");
                    pushEncendido();
                    delay_ms(3000);
                    
                  }
                  else{
                   MoverCursor(0,2);
                    StringLCD("   Encendiendo...   ");
                    MoverCursor(0,3);
                    StringLCD("                    ");
                    pushEncendido();
                    delay_ms(3000); 
                  }
                }
                else{
                printf("Caso 1 \n");
                    MoverCursor(0,2);
                    StringLCD(" Seleccion erronea, ");
                    MoverCursor(0,3);
                    StringLCD(" intente nuevamente ");
                    delay_ms(2000);
                }
            }
        }
            
    }
}
