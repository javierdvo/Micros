    #include <MEGA328P.h> 
    #include <delay.h> 
    #include "display.h"
    #include <stdio.h>         


char car0[8]={0x00,0x0E,0x1D,0x1F,0x1E,0x1F,0x1F,0x0E};
char car1[8]={0x00,0x0E,0x1D,0x1E,0x1C,0x1E,0x1F,0x0E};

char car2[8]={0x00,0x0E,0x17,0x1F,0x0F,0x1F,0x1F,0x0E};
char car3[8]={0x00,0x0E,0x17,0x0F,0x07,0x0F,0x1F,0x0E};
int i;               


void delayPacman()
{
    delay_ms(10);
}
            
void main()
{
    ConfiguraLCD();
    CreaCaracter(0,car0);
    CreaCaracter(1,car1);
    CreaCaracter(2,car2);
    CreaCaracter(3,car3);
    while(1)
    {
        MoverCursor(1,0);
        StringLCD("Microcontroladores");
        MoverCursor(2,1);
        StringLCD("Agosto-Diciembre");
        MoverCursor(8,2);
        StringLCD("2014");
        MoverCursor(8,3);
        StringLCD("Exito");
        
        for(i=0;i<10;i++){
            MoverCursor(i*2,0);
            LetraLCD(0);
            delayPacman();
            MoverCursor(i*2,0);  
            LetraLCD(' ');
            LetraLCD(1);
            delayPacman();
            MoverCursor(i*2+1,0);
            LetraLCD(' ');
            
            
                
        
        
        }
         for(i=9;i>=0;i--){
            MoverCursor(i*2+1,1);
            LetraLCD(2);
            delayPacman();
            MoverCursor(i*2+1,1);  
            LetraLCD(' ');
            MoverCursor(i*2,1);
            LetraLCD(3);
            delayPacman();
            MoverCursor(i*2,1);
            LetraLCD(' ');
            
            
                
        
        
        }
        for(i=0;i<10;i++){
            MoverCursor(i*2,2);
            LetraLCD(0);
            delayPacman();
            MoverCursor(i*2,2);  
            LetraLCD(' ');
            LetraLCD(1);
            delayPacman();
            MoverCursor(i*2+1,2);
            LetraLCD(' ');
            
            
                
        
        
        }
         for(i=9;i>=0;i--){
            MoverCursor(i*2+1,3);
            LetraLCD(2);
            delayPacman();
            MoverCursor(i*2+1,3);  
            LetraLCD(' ');
            MoverCursor(i*2,3);
            LetraLCD(3);
            delayPacman();
            MoverCursor(i*2,3);
            LetraLCD(' ');
            
            
                
        
        
        }
    
    }
      
}
    
