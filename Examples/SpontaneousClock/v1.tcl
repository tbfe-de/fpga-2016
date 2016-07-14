#!/usr/bin/wish

label .uhrzeit -font {Sans 50} -textvariable c
pack .uhrzeit

proc update_time {} {
	set ::c [clock format [clock seconds] -format %H:%M:%S]
	after 1000 update_time
}

update_time
