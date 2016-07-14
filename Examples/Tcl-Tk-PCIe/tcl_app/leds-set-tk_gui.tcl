#!/usr/bin/wish
# =====================================================================
# Tcl/Tk Program with a GUI for Switching PCIe-Controlled LEDs
# =====================================================================

set USAGE \
"Usage:	$argv0 \[<driver-sysfs> \[<led-prefix>\]\]
 with	- <driver-sysfs> the directory path to the directory where
	  the led PCIe driver is located
        - <led-prefix> the prefix to the LED device files (for which
          a directly concatenated numeric extension is expected)
"

proc die {rcode {message usage} {detail {}}} {
	if {[string equal $message usage]} {
		puts -nonewline stderr $::USAGE
		flush stderr
		exit $rcode
	}
	if {[string length $detail] > 0} {
		set detail "($detail)"
	}
	puts stderr "$::argv0: $message $detail"
	flush stderr
	exit $rcode
}

switch -exact $argc {
      2	{}
      1	{ lappend argv LED }
      0	{ lappend argv /sys/tcl_drv LED }
default { die 1 }
}

set sys_fs_dir [lindex $argv 0]

if {![file isdirectory $sys_fs_dir]} {
	die 2 "invalid directory" $sys_fs_dir
}

set led_dev_prefix [lindex $argv 1]
if {[catch {
	glob -directory $sys_fs_dir $led_dev_prefix*
   } led_dev_files]} {
	die 3 "cannot locate device files" "for $led_dev_prefix*"
}

proc set_led {led_dev} {
	global $led_dev
	set fh [open $led_dev w]
	puts $fh [set $led_dev]
	close $fh
}

foreach led_dev $led_dev_files {
	set n [string index $led_dev end]
	checkbutton .cb_$n -text $led_dev\
		-variable $led_dev\
		-command [list set_led $led_dev]
	pack .cb_$n -side top -fill x
	set_led $led_dev
}

wm title . "LED Control GUI"
