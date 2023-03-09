

#include "main.h"

void main(void) {

    initialize();
    while (1) {
        switch (currentStage) {
            case DISABLED:
                break;
            case CONFIGURATION:
                configurationMode();
                break;
            case PLAY:
                playMode();
                break;
            case PAUSE:
                pauseMode();
                break;
            case STOP:
                stopMode();
                break;
            default:
                configurationMode();
                break;
        }

    }
}

void initialize() {

    ADCON1 = 0b0110;
    LATB = 0x00;
    TRISB = 0xff;
    LATC = 0x00;
    TRISC = 0x00;

    /*Player Buttons Interrupt Setup*/

    OpenRB0INT(PORTB_CHANGE_INT_ON & PORTB_PULLUPS_ON & RISING_EDGE_INT);
    INTCON3bits.INT1IE = 1;
    INTCON3bits.INT1IF = 0;
    INTCONbits.GIE = 1;

    /*Timer Interrupt Setup*/
    initUART();
    initTimeOptions();
    initLCD();

    /* Setting the Power Management Mode to IDLEN=1*/
    OSCCONbits.IDLEN = 1;

    OpenTimer0(TIMER_INT_ON & T0_16BIT & T0_SOURCE_INT & T0_PS_1_256 & T0_EDGE_RISE);
    INTCONbits.TMR0IE = 1;
    INTCONbits.TMR0IF = 0;
    INTCONbits.GIEH = 1;
    RCONbits.IPEN = 1;
    TMR0H = 0xFF; // Timer Reload to count 0.01s
    TMR0L = 0x3C;

    sprintf(white.player, "WHITE");
    sprintf(black.player, "BLACK");
    currentPlayer = white;
    sprintf(currentPlayer.player, white.player);
    currentStage = CONFIGURATION;
}

void configurationMode() {
    PORTCbits.RC2 = 0;
    PORTCbits.RC0 = 0;
    if (lastTO.duration != currentTO.duration) {
        lastTO = currentTO;
        lcdClear();
        sprintf(buff, "%s", currentTO.optionName);
        lcdDisplay(buff, 1);
        sprintf(buff, "Dur:%dmin,Bon:%ds    ec", (int) currentTO.duration / 60, (int) currentTO.movePen);
        lcdDisplay(buff, 2);
    }
    if (PORTBbits.RB4 == 0) {
        second = 0;
        switchTC();
        sprintf(buff, "{\"to\":\"%s\",\"dur\":\"%d\",\"bon\":\"%d\"}", currentTO.optionName, (int) currentTO.duration / 60, (int) currentTO.movePen);
        sendMessage(buff);
        Delay10KTCYx(80);
    }
    if (PORTBbits.RB6 == 0) {
        second = 0;
        sprintf(currentTO.optionName, "Custom Match");
        currentTO.duration += 60;
        sprintf(buff, "{\"to\":\"%s\",\"dur\":\"%d\",\"bon\":\"%d\"}", currentTO.optionName, (int) currentTO.duration / 60, (int) currentTO.movePen);
        sendMessage(buff);
        white.currentTime = currentTO.duration;
        black.currentTime = currentTO.duration;
        Delay10KTCYx(80);
    }
    if (PORTBbits.RB7 == 0) {
        sprintf(currentTO.optionName, "Custom Match");
        if (currentTO.duration <= 60) {
            PORTCbits.RC2 = !PORTCbits.RC2;
            Delay10KTCYx(20);
            PORTCbits.RC2 = !PORTCbits.RC2;
        } else {
            currentTO.duration -= 60;
            white.currentTime = currentTO.duration;
            black.currentTime = currentTO.duration;
            Delay10KTCYx(80);
        }
        sprintf(buff, "{\"to\":\"%s\",\"dur\":\"%d\",\"bon\":\"%d\"}", currentTO.optionName, (int) currentTO.duration / 60, (int) currentTO.movePen);
        sendMessage(buff);
    }
    if (PORTBbits.RB5 == 0) {
        lcdClear();
        sprintf(buff, "Match Start.GLHF");
        lcdDisplay(buff, 1);
        sprintf(buff, "Match Started");
        sendMessage(buff);
        Delay10KTCYx(500);
        setMatchStatus(PLAY);
    }
}

void playMode() {

    second = 0;
    if (PORTBbits.RB4 == 0) {
        setMatchStatus(CONFIGURATION);
        Delay10KTCYx(80);
        lcdClear();
        sprintf(buff, "Mode:%s", currentTO.optionName);
        lcdDisplay(buff, 1);

        sprintf(buff, "Dur:%dmin,Bon:%dsec", (int) currentTO.duration / 60, (int) currentTO.movePen);
        lcdDisplay(buff, 2);

        currentPlayer = white;
        sprintf(currentPlayer.player, "WHITE");
    }
    if (PORTBbits.RB6 == 0) {
        setMatchStatus(PAUSE);
        Delay10KTCYx(80);
        lcdClear();
        sprintf(buff, "Match Paused");
        sendMessage(buff);
        lcdDisplay(buff, 1);
        sprintf(buff, "W%02d:%02d B%02d:%02d", (int) white.currentTime / 60, (int) white.currentTime % 60, (int) black.currentTime / 60, (int) black.currentTime % 60);
        lcdDisplay(buff, 2);
    }
}

void pauseMode() {
    if (PORTBbits.RB4 == 0) {
        second = 0;
        setMatchStatus(CONFIGURATION);
        Delay10KTCYx(80);
        lcdClear();
        sprintf(buff, "Mode:%s", currentTO.optionName);
        lcdDisplay(buff, 1);
        sprintf(buff, "Dur:%dmin,Bon:%dsec", (int) currentTO.duration / 60, (int) currentTO.movePen);
        lcdDisplay(buff, 2);
        currentPlayer = white;
        sprintf(currentPlayer.player, "WHITE");
    }
    if (PORTBbits.RB6 == 0) {
        second = 0;
        setMatchStatus(PLAY);
        Delay10KTCYx(80);
        sprintf(buff, "Match in Progress");
        sendMessage(buff);
        lcdDisplay(buff, 1);
    }
}

void switchTC(void) {
    static enum tc_options {
        BLITZ,
        RAPID,
        FBLITZ,
        FRAPID
    } tc_option = BLITZ;
    switch (tc_option) {
        case BLITZ:
            tc_option = RAPID;
            break;
        case RAPID:
            tc_option = FBLITZ;
            break;
        case FBLITZ:
            tc_option = FRAPID;
            break;
        case FRAPID:
            tc_option = BLITZ;
            break;
        default:
            tc_option = BLITZ;

            break;
    }
    changeTO(tc_option);

    white.currentTime = currentTO.duration;
    black.currentTime = currentTO.duration;
}

void stopMode() {
    setMatchStatus(CONFIGURATION);
    second = 0;
    lcdClear();
    sprintf(buff, "Match Over. GGs");
    lcdDisplay(buff, 1);
    if (currentPlayer.player == white.player) {
        sprintf(buff, "Winner:%s ", black.player);
    } else {

        sprintf(buff, "Winner:%s", white.player);
    }
    lcdDisplay(buff, 2);
    sendMessage(buff);
    Delay10TCYx(10);
    white.currentTime = currentTO.duration;
    black.currentTime = currentTO.duration;
    currentPlayer = white;
    sprintf(currentPlayer.player, "WHITE");
    //    lcdClear();
    //    sprintf(buff, "Mode:%s", currentTO.optionName);
    //    lcdDisplay(buff, 1);
    //    sendMessage(buff);
    //    sprintf(buff, "Dur:%dmin,Bon:%dsec", (int) currentTO.duration / 60, (int) currentTO.movePen);
    //    lcdDisplay(buff, 2);
    //    sendMessage(buff);
    //    
}

void interruptCode(void) {
    static int centiSecond;
    if (INTCONbits.TMR0IF) {
        TMR0H = 0xFF; // Timer Reload to count 0.1s
        TMR0L = 0x3C;
        centiSecond++;
        INTCONbits.TMR0IF = 0;
        if (centiSecond % 100 == 0) {
            centiSecond = 0;
            second++;
            if (second > 60) {
                if (sleep == 0) {
                    sprintf(buff, "Going to Sleep");
                    sendMessage(buff);
                    sleep = 1;
                    Sleep();
                }
            } else {
                sleep = 0;
            }
        }

        if (currentStage == PLAY) {
            if (centiSecond % 100 == 0) {
                sprintf(buff, "W%d,B%d;", (int) white.currentTime, (int) black.currentTime);
                sendMessage(buff);
                sprintf(buff, "W%02d:%02d B%02d:%02d", (int) white.currentTime / 60, (int) white.currentTime % 60, (int) black.currentTime / 60, (int) black.currentTime % 60);
                lcdDisplay(buff, 2);
                if (white.currentTime < 5) {
                    PORTCbits.RC2 = !PORTCbits.RC2;
                } else if (black.currentTime < 5) {
                    PORTCbits.RC2 = !PORTCbits.RC2;
                }
            }
            if (currentPlayer.player == white.player) {
                if (white.currentTime < 0.01) {
                    white.currentTime = 0;

                    setMatchStatus(STOP);
                } else {

                    white.currentTime -= 0.01;
                    currentPlayer = white;
                }
            } else {
                if (black.currentTime < 0.01) {
                    black.currentTime = 0;
                    setMatchStatus(STOP);
                } else {
                    black.currentTime -= 0.01;
                    currentPlayer = black;
                }
            }

        }


    }
    if (INTCON3bits.INT1IF == 1) {

        INTCON3bits.INT1IE = 0;
        if (currentStage == PLAY) {
            if (currentPlayer.player == white.player) {
                PORTCbits.RC0 = 1;
                black.currentTime += currentTO.movePen;
                currentPlayer = black;

                sprintf(currentPlayer.player, "BLACK");
            } else {
                PORTCbits.RC0 = 0;
                white.currentTime += currentTO.movePen;
                currentPlayer = white;
                sprintf(currentPlayer.player, "WHITE");
            }
        }
        INTCON3bits.INT1IE = 1;
        INTCON3bits.INT1IF = 0;
    }


}