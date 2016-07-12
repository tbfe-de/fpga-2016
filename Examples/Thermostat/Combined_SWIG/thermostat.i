%module thermostat
%{
#include "thermostat.h"
%}

int system_heater;
float lo_trigger;
float hi_trigger;
void switch_heater (float temp);
