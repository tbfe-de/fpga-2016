#!/usr/bin/wish

set font {Sans 50}

label .counter -font $font -width 5 -textvariable c

button .up -text + -width 2 -font $font -command {incr c}
button .down -text – -width 2 -font $font -command {incr c -1}
button .exit -text EXIT -command exit

pack .up -side left -fill y
pack .down -side right -fill y
pack .exit -side bottom -fill x
pack .counter -fill both -expand 1

set c 0
