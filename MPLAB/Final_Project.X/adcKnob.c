
#include "adcKnob.h"
#include "uart.h"

char *adcEcho[10];

void initKnob(void) {
    TRISA = 0xFF;
    OpenADC(ADC_FOSC_32 & ADC_RIGHT_JUST & ADC_20_TAD, ADC_CH0 & ADC_INT_OFF & ADC_VREFPLUS_VDD & ADC_VREFMINUS_VSS, 0b0110);
    SetChanADC(ADC_CH0);
    while (BusyADC())
        ;
}

int readKnobValue(void) {
    static int lastValue;
    static int currentStableValue;
    ConvertADC();
    if ((lastValue - ADRESL) > 2 || (lastValue - ADRESL)<-2) {
        lastValue = ADRESL;
        itoa(lastValue, &adcEcho);
        sendMessage(adcEcho);
        Delay10KTCYx(100);
    }
}