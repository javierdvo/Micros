#include <mega328P.h>
#include <delay.h>

void main(){
 DDRB.0=1;
 while(1){
    PORTB.0=0;
    delay_ms(500);
    PORTB.0=1;
    delay_ms(500);
 }

}