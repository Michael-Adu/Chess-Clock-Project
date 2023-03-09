/*
 * File:   controls.h
 * Author: micha_5j3z6p3
 *
 * Created on 03 March 2023, 15:18
 */

#ifndef CONTROLS_H
#define CONTROLS_H

#include <p18cxxx.h>

enum chess_stages {
    DISABLED,
    CONFIGURATION,
    PLAY,
    PAUSE,
    STOP
};
void setMatchStatus(enum chess_stages stage);
extern enum chess_stages currentStage;

#endif
