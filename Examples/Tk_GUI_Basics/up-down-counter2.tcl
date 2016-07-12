#!/usr/bin/wish

set font {Sans 50}

label .counter -font $font -width 5 -textvariable c

button .up -text + -width 2 -font $font -command {incr c}
button .down -text – -width 2 -font $font -command {incr c -1}
button .exit -text EXIT -command exit

grid .up .counter -sticky nwse
grid .down  ^     -sticky nwse
grid .exit  -     -sticky nwse

set c 0
