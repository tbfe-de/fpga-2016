#!/usr/bin/wish

set font {Sans 50}

label .counter -font $font -width 5 -textvariable c
frame .buttons -relief ridge -borderwidth 3
button .buttons.u -text + -width 2 -font $font -command {incr c}
button .buttons.d -text – -width 2 -font $font -command {incr c -1}
button .exit -text EXIT -command exit

grid .buttons.u .buttons.d -sticky nesw
pack .buttons -side top -fill x
pack .counter -fill both -expand 1
pack .exit -side bottom -fill x

set c 0
