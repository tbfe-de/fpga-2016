#!/usr/bin/wish
# ----------------------------------------------------------------------------
# C/C++ code will have been compiled into the share object loaded below

load ./thermostat.so

# =============================================================================
# This ends the part that need to be touched if the Tcl/Tk simulation is later
# used to visualize the part that is written in C; below is a very limited and
# bare-bones implementation, that does nothing more as to enable the user to
# the the assumed system temperatur and watch the effect on the heating state.

# ---------------------------
# Simulate temperature sensor
# ---------------------------

set sensed_temperature 21.0

# -------------------
# Create a simple GUI
# -------------------

proc create_gui {} {

	scale .system_temperatur\
		-orient horizontal -length 250\
		-from -20 -to 55 -resolution .5\
		-variable sensed_temperature\
		-command temperature_changed

	pack .system_temperatur\
		-side bottom\
		-fill x

        if 1 {
        frame .switch_on\
                -relief ridge\
                -borderwidth 3
        label .switch_on.t\
                 -text "ON °C"
        spinbox .switch_on.v\
		-state readonly\
                -font {Sans 30}\
                -from 10 -to 35 -increment .5 -wrap 0\
		-width 4 -format "%04.1f"\
                -textvariable lo_trigger
        
        frame .switch_off\
                -relief ridge\
                -borderwidth 3
        label .switch_off.t\
                 -text "OFF °C"
        spinbox .switch_off.v\
		-state readonly\
                -font {Sans 30}\
                -from 10 -to 35 -increment .5 -wrap 0\
		-width 4 -format "%04.1f"\
                -textvariable hi_trigger

        pack .switch_on.t -side top\
		 -fill x
        pack .switch_on.v -side top\
                 -fill both -expand 1
        pack .switch_on -side left\
		 -fill both -expand 1

        pack .switch_off.t -side top\
		 -fill x
        pack .switch_off.v -side top\
                 -fill both -expand 1
        pack .switch_off -side right\
		-fill both -expand 1
        }
        
	label .heater_state\
		-font {Sans 50}\
		-width 5

	pack .heater_state\
		-side top\
		-expand 1\
		-fill both


}

# -------------------------------------------
# Call-back for changes in system temperature
# -------------------------------------------

proc temperature_changed {args} {
	global sensed_temperature
	switch_heater $sensed_temperature
	show_heater_state
}

# -------------------------------------------
# Visualize state of heater (on or off)
# -------------------------------------------

proc show_heater_state {} {
	global system_heater
	if {$system_heater} {
		.heater_state configure\
			-text "ON"\
			-background red\
			-foreground black
	} else {
		.heater_state configure\
			-text "OFF"\
			-background blue\
			-foreground white
	}
}

# ----------------------------------------------
# Actually create the GUI and show current state
# ----------------------------------------------

create_gui;		# (as the name say) and
temperature_changed;	# show consistent state

trace add variable system_heater {write} showvar 

proc showvar args {
	global system_heater
	puts $system_heater
}

# ==============================================
# Netzwerkfähigkeit

proc handle_connection_request {chan client_ip client_port} {
	puts "request from: $client_ip $client_port"
	gets $chan command
	puts "client did send: $command"
	eval $command
	close $chan
}

socket -server handle_connection_request 5678


