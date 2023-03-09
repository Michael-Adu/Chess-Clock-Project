/*
 * File:   main.h
 * Author: micha_5j3z6p3
 *
 * Created on 03 March 2023, 15:19
 */

#ifndef MAIN_H
#define MAIN_H

#pragma config OSC = HS
#pragma config WDT = OFF
#pragma config LVP = OFF
#pragma config DEBUG = OFF

#include <p18cxxx.h>
#include <p18f4520.h>
#include <adc.h>
#include <stdlib.h>
#include <delays.h>
#include <timers.h>
#include <portb.h>

#include "uart.h"
#include "timing.h"
#include "controls.h"
#include "display.h"
#include "adcKnob.h"

#define MASK(X) 0x01 << X

struct playerTimer {
    char *player;
    float currentTime;
} currentPlayer, white, black;

char *echo[10];
char *buff[64] = "";
float knobTimer = 0;
int second = 0;
int sleep = 0;


void switchTC(void);



void interruptCheck(void);
void interruptCode(void);
void configurationMode();
void playMode();
void pauseMode();
void initialize();
void stopMode();
#pragma code interruptCheck = 0x08

void interruptCheck(void)
{
    _asm GOTO interruptCode
        _endasm
}
#pragma code
#pragma interrupt interruptCode

#endif
