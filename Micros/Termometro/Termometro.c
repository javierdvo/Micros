#include <mega328P.h>
#include <stdio.h>
#include <delay.h>
#include "display.h"

#define ADC_VREF_TYPE 0xC0  //tipo de referencia

unsigned int tempDigital;
float temperatura;
char cadena[10];


unsigned int read_adc(unsigned char adc_input)
{
ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage          
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCW;
}

 void main(void){
     ConfiguraLCD();
    DIDR0=0x20;    //deshabilita el digital
    ADMUX=ADC_VREF_TYPE & 0xff; // configracion prescale
    MoverCursor(2,0);
    StringLCD("Temperatura:");
    ADCSRA=0x83; //habiliuta adc

    while(1){
        tempDigital=read_adc(5);
        temperatura= tempDigital*110.0/1024.0;
        sprintf(cadena,"%3.1f %cC  ",temperatura,0xDF);
        MoverCursor(4,1);
        StringLCDVar(cadena);
        delay_ms(1000);
    }
}