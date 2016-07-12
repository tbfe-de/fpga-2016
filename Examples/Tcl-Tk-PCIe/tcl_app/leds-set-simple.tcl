#!/usr/bin/tclsh
# =====================================================================
# Simple Tcl Program to Switch ON/OFF PCIe-Controlled LEDs
# =====================================================================

set USAGE \
"Usage:	$argv0 <pattern>
 with	- <pattern> a sequence of exactly four characters '0' or '1',
          determining wheter LEDs 0 to 3 are lit or dark.
"

set DRIVER_SYS_FS "/sys/tcl_drv/"

if {$argc != 1} {
	puts -nonewline stderr $USAGE; flush stderr; exit 1
}

set pattern [lindex $argv 0]

if {![regexp {^[01]{4}$} $pattern]} {
	puts stderr "$argv0: invalid <pattern> argument"; exit 2
}

set led_driver_fname $DRIVER_SYS_FS/LED0
set led_driver_onoff [string index $pattern 0]
set led_driver_fh [open $led_driver_fname w]
puts $led_driver_fh $led_driver_onoff
flush $led_driver_fh
close $led_driver_fh

set led_driver_fname $DRIVER_SYS_FS/LED1
set led_driver_onoff [string index $pattern 1]
set led_driver_fh [open $led_driver_fname w]
puts $led_driver_fh $led_driver_onoff
close $led_driver_fh

set led_driver_fname $DRIVER_SYS_FS/LED2
set led_driver_onoff [string index $pattern 2]
set led_driver_fh [open $led_driver_fname w]
puts $led_driver_fh $led_driver_onoff
close $led_driver_fh

set led_driver_fname $DRIVER_SYS_FS/LED3
set led_driver_onoff [string index $pattern 3]
set led_driver_fh [open $led_driver_fname w]
puts $led_driver_fh $led_driver_onoff
close $led_driver_fh

