%module thermostat
%{
#include "thermostat.h"
%}

int system_heater;
void switch_heater (float temp);
