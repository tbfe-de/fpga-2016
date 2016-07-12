float lo_trigger = 19.0;
float hi_trigger = 25.0;
int system_heater = 0;

void switch_heater(float temp) {
	if (temp <= lo_trigger) {
		system_heater = 1;
	}
	if (temp >= hi_trigger) {
		system_heater = 0;
	}
}
