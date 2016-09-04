 #include <mega328P.h>
  #include <delay.h>
flash int du=262,di= 278,re= 294, ri=312, mi =330,fa=349, fi=370, sol=391,si=416, la=440, li=467, ti=494;
flash int MarioBros[591]={mi*2,mi*2,1,mi*2,1,du*2,mi*2,1,sol*2,1,1,1,sol,1,1,1,du*2,1,1,sol,1,1,mi,1,1,la,1,ti,1,li,la,1,sol,mi*2,1,sol*2,la*2,1,fa*2,sol*2,
1,mi*2,1,du*2,re*2,ti,1,1,du*2,1,1,sol,1,1,mi,1,1,la,1,ti,1,li,la,1,sol,mi*2,1,sol*2,la*2,1,fa*2,sol*2,1,mi*2,1,du*2,re*2,ti,1,1,1,1,sol*2,fi*2,fa*2,ri*2,1,
mi*2,1,si,la,du*2,1,la,du*2,re*2,1,1,sol*2,fi*2,fa*2,ri*2,1,mi*2,1,du*4,1,du*4,du*4,1,1,1,1,1,sol*2,fi*2,fa*2,ri*2,1,mi*2,1,si,la,du*2,1,la,du*2,re*2,1,1,
ri*2,1,1,re*2,1,1,du*2,1,1,1,1,1,1,1,1,1,sol*2,fi*2,fa*2,ri*2,1,mi*2,1,si,la,du*2,1,la,du*2,re*2,1,1,sol*2,fi*2,fa*2,ri*2,1,mi*2,1,du*4,1,du*4,du*4,1,1,1,
1,1,sol*2,fi*2,fa*2,ri*2,1,mi*2,1,si,la,du*2,1,la,du*2,re*2,1,1,ri*2,1,1,re*2,1,1,du*2,1,1,1,1,1,1,1,du*2,du*2,1,du*2,1,du*2,re*2,1,mi*2,du*2,1,la,sol,1,1,1,
du*2,du*2,1,du*2,1,du*2,re*2,1,1,1,1,1,1,1,1,du*2,du*2,1,du*2,1,du*2,re*2,1,mi*2,du*2,1,la,sol,1,1,1,mi*2,mi*2,1,mi*2,1,du*2,mi*2,1,sol*2,1,1,1,sol,1,1,1,du*2,
1,1,sol,1,1,mi,1,1,la,1,ti,1,li,la,1,sol,mi*2,1,sol*2,la*2,1,fa*2,sol*2,1,mi*2,1,du*2,re*2,ti,1,1,du*2,1,1,sol,1,1,mi,1,1,la,1,ti,1,li,la,1,sol,mi*2,1,sol*2,
la*2,1,fa*2,sol*2,1,mi*2,1,du*2,re*2,ti,1,1,mi*2,du*2,1,sol,1,1,si,1,la,fa*2,1,fa*2,la,1,1,1,ti,la*2,1,la*2,la*2,sol*2,1,fa*2,mi*2,du*2,1,la,sol,1,1,1,mi*2,du*2,
1,sol,1,1,si,1,la,fa*2,1,fa*2,la,1,1,1,ti,fa*2,1,fa*2,fa*2,mi*2,1,re*2,sol,mi,1,mi,du,1,1,1,mi*2,du*2,1,sol,1,1,si,1,la,fa*2,1,fa*2,la,1,1,1,ti,la*2,1,la*2,la*2,
sol*2,1,fa*2,mi*2,du*2,1,la,sol,1,1,1,mi*2,du*2,1,sol,1,1,si,1,la,fa*2,1,fa*2,la,1,1,1,ti,fa*2,1,fa*2,fa*2,mi*2,1,re*2,sol,mi,1,mi,du,1,1,1,du*2,du*2,1,du*2,1,
du*2,re*2,1,mi*2,du*2,1,la,sol,1,1,1,du*2,du*2,1,du*2,1,du*2,re*2,1,1,1,1,1,1,1,1,du*2,du*2,1,du*2,1,du*2,re*2,1,mi*2,du*2,1,la,sol,1,1,1,mi*2,mi*2,1,mi*2,1,du*2,
mi*2,1,sol*2,1,1,1,sol,1,1,1,mi*2,du*2,1,sol,1,1,si,1,la,fa*2,1,fa*2,la,1,1,1,ti,la*2,1,la*2,la*2,sol*2,1,fa*2,mi*2,du*2,1,la,sol,1,1,1,mi*2,du*2,1,sol,1,1,si,1,la,
fa*2,1,fa*2,la,1,1,1,ti,fa*2,1,fa*2,fa*2,mi*2,1,re*2,sol,mi,1,mi,du,1,1,1,0};  
                                                     
 
 unsigned int i;
                             
 void noTono(){
    TCCR0B=0x00;
 }
 void tono(float frecuencia)
{
    unsigned int cuentasEnt;
    float cuentas;
    cuentas=(500000.0/(frecuencia*8));
    cuentasEnt=cuentas;
    if((cuentas-cuentasEnt)>+0.5)
        cuentasEnt++;    
    OCR0A=cuentasEnt-1;
    TCCR0A=0x42;
    TCCR0B=0x02;
             
}
 void main(void){               
    DDRD.6=1;
    i=0;                            
    while(1){
        if (MarioBros[i]!=1)            
        {
                tono(MarioBros[i]);         
                delay_ms(100);
                noTono();                       
        }
        else{                                       
            delay_ms(100);
        }                                               
        i++;
        if(i==591){                                         
        i=0;
        }                                                       
    }
 }                                                                                      
    