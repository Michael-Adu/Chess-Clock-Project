/*
 * File:   timing.h
 * Author: micha_5j3z6p3
 *
 * Created on 03 March 2023, 14:32
 */

#ifndef TIMING_H
#define TIMING_H

#include <p18cxxx.h>
#include <delays.h>
#include "uart.h"

void initTimeOptions();
void changeTO(int optionNo);
void displayCurrentOption();

struct TimeOption
{
    char optionName[32];
    float duration;
    float movePen;
};
extern struct TimeOption currentTO, lastTO;



#endif
