#include <stddef.h>
#include <delays.h>

#include "display.h"


#define MASK(X) 1<<X
#define LEFTSHIFT(Y,X) Y<<X
#define RIGHTSHIFT(Y,X) Y>>X

#define RS PORTDbits.RD4
#define RW PORTDbits.RD5
#define EN PORTDbits.RD6

#define D4 PORTDbits.RD3
#define D5 PORTDbits.RD4
#define D6 PORTDbits.RD5
#define D7 PORTDbits.RD6

char *lcdBuff[32] = "HELLO";
int characterLength = 0;

void initLCD(void) {
    TRISD = 0x00;
    LATD = 0x00;
    EN = 0x00;
    RS = 0x00;
    RW = 0x00;
    lcdCommand(0b00000010);
    lcdCommand(0b00101000);
    lcdCommand(0b00001100);
    lcdCommand(0b00000001);
    lcdCommand(0b00000010);
}

void lcdDisplay(char *data, int row) {
    int i = 0;
    characterLength = strlen(data);
    //lcdClear();
    if (row == 1) {
        lcdCommand(0x80);

        for (i = 0; i < characterLength; i++) {
            unsigned int character = data[i];

            LATD = character >> 4;
            RS = 0x01;
            EN = 0x01;
            EN = 0x00;
            RS = 0x00;

            LATD = character & 0x0f;
            RS = 0x01;
            EN = 0x01;
            EN = 0x00;
            RS = 0x00;
            Delay1KTCYx(1);
        }
    }
    else{
        lcdCommand(0b11000000);

        for (i = 0; i < characterLength; i++) {
            unsigned int character = data[i];

            LATD = character >> 4;
            RS = 0x01;
            EN = 0x01;
            EN = 0x00;
            RS = 0x00;

            LATD = character & 0x0f;
            RS = 0x01;
            EN = 0x01;
            EN = 0x00;
            RS = 0x00;
            Delay1KTCYx(1);
        }
    }

}

void lcdCommand(unsigned int command) {
    LATD = command >> 4;
    EN = 1;
    EN = 0;
    LATD = command & 0x0f;
    EN = 1;
    EN = 0;
    Delay1KTCYx(10);
}

void lcdClear(){
    lcdCommand(0b00000001);
}