 #include <MEGA328P.h> 
    #include <delay.h> 
    #include <stdio.h>         




void Delay_msKitt(){
    if(PINB.2==0){
        if(PINB.1==0){
            if(PINB.0==0){
                delay_ms(100);
                
            }
            else{
                delay_ms(200);
            }
            
         }
         else{
         if(PINB.0==0){
                delay_ms(300);
                      
            }
            else{
                delay_ms(400);
            }
         }
    }
    else {
         if(PINB.1==0){
            if(PINB.0==0){
                delay_ms(500);
                
            }
            else{
                delay_ms(600);
            }
            
         }
         else{
         if(PINB.0==0){
                delay_ms(700);
                      
            }
            else{
                delay_ms(800);
            }
         }
    }
    
}            

void main()
{
    DDRD=0xFF;
    PORTB.0=1;
    PORTB.1=1;
    PORTB.2=1;
    PORTC.0=1;
    while(1)
    {
        
        if(PINC.0==0){
                if(PINC.0==1){
                
                }
                else{
                PORTD.0=1;
                Delay_msKitt();
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.0=0;
                PORTD.1=1;
                Delay_msKitt();
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.1=0;
                PORTD.2=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.2=0;
                PORTD.3=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.3=0;
                PORTD.4=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.4=0;
                PORTD.5=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.5=0;
                PORTD.6=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.6=0;
                PORTD.7=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.7=0;
                PORTD.6=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.6=0;
                PORTD.5=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.5=0;
                PORTD.4=1;
                Delay_msKitt(); 
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.4=0;
                PORTD.3=1;
                Delay_msKitt();
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.3=0;
                PORTD.2=1;
                Delay_msKitt();
                }
                if(PINC.0==1){
                
                }
                else{
                PORTD.2=0;
                PORTD.1=1;
                Delay_msKitt();   
                }
                if(PINC.0==1){
                PORTD.0=0;
                PORTD.1=0;
                PORTD.2=0;
                PORTD.3=0;
                PORTD.4=0;
                PORTD.5=0;
                PORTD.6=0;
                PORTD.7=0;
                }
                else{
                PORTD.1=0;
                } 
        }
        else{
                if(PINC.0==0){
                
                }
                else{
                PORTD.0=1;
                PORTD.7=1;
                Delay_msKitt();
                }
                if(PINC.0==0){
                
                }
                else{
                PORTD.1=1;
                PORTD.6=1;
                PORTD.0=0;
                PORTD.7=0;
                Delay_msKitt();
                }
                if(PINC.0==0){
                
                }
                else{
                PORTD.2=1;
                PORTD.5=1;
                PORTD.1=0;
                PORTD.6=0;
                Delay_msKitt();
                }
                if(PINC.0==0){
                
                }
                else{
                PORTD.3=1;
                PORTD.4=1;
                PORTD.2=0;
                PORTD.5=0;
                Delay_msKitt();
                }
                if(PINC.0==0){
                }
                else{
                PORTD.2=1;
                PORTD.5=1;
                PORTD.3=0;
                PORTD.4=0;
                Delay_msKitt();
                }
                if(PINC.0==0){
                
                }
                else{
                PORTD.1=1;
                PORTD.6=1;
                PORTD.2=0;
                PORTD.5=0;
                Delay_msKitt();
                }
                if(PINC.0==0){
                PORTD.0=0;
                PORTD.1=0;
                PORTD.2=0;
                PORTD.3=0;
                PORTD.4=0;
                PORTD.5=0;
                PORTD.6=0;
                PORTD.7=0;
                }
                else{
                PORTD.1=0;
                PORTD.6=0;
                }


        }
    }
}