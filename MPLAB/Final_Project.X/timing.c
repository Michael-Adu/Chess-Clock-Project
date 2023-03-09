
#include "timing.h"

struct TimeOption currentTO, lastTO, toBlitz, toRapid, toFblitz, toFrapid;

void initTimeOptions()
{
    sprintf(toBlitz.optionName,"BLITZ");
    toBlitz.duration = 300.00;
    toBlitz.movePen = 0;

    sprintf(toRapid.optionName,"RAPID");
    toRapid.duration = 1500;
    toRapid.movePen = 0;

    sprintf(toFblitz.optionName,"FBLITZ");
    toFblitz.duration = 180;
    toFblitz.movePen = 2;

    sprintf(toFrapid.optionName,"FRAPID");
    toFrapid.duration = 1500.00;
    toFrapid.movePen = 10.00;

    currentTO = toBlitz;
    sprintf(currentTO.optionName,"BLITZ\n");
}

void changeTO(int optionNo)
{
    
    switch (optionNo)
    {
    case 0:
        currentTO = toBlitz;
        break;
    case 1:
        currentTO = toRapid;
        break;
    case 2:
        currentTO = toFblitz;
        break;
    case 3:
        currentTO = toFrapid;
        break;
    default:
        currentTO = toBlitz;
        break;
    }
}
