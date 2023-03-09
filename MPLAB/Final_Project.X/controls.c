#include "controls.h"
enum chess_stages currentStage= CONFIGURATION;
void setMatchStatus(enum chess_stages stage)
{
    currentStage=stage;
}
