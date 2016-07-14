#!/usr/bin/wish
# =====================================================================
# Reading and Processing Measurement Data from the DT9062 MultiMeter
# =====================================================================
#
# Communication Protocol[*]:
# ---------------------------
# Via its serial interface the multimeter sends out data 14 bytes in
# an ever repeating cycle:
#
# In each byte
# - the upper four bits ("nibble") is a serial number which allows for
#   easy synchronisation.
# - the lower four bits map to elements of the LCD display, like
#   - the individual bars of the digits, or
#   - the units of measurements
#
# So besides receiving the multi-meter data in an "event-driven" style
# the main-challenge for the program logic is to decode the actual
# digits from their switched-on LCD-bars.
#
# [:* Kudos to the friendly but now forgotten person who once put this
# protocol on the internet. I still owe you a chocolate cookie ... :-)

# ----------------------------------------------------------------------
# Mapping of LCD elements to bits in the lower nibbles of serial data
# ----------------------------------------------------------------------

# Below 'aX' to 'dX' represent the four digits, 'z1' to 'z7' one of
# the bars in their associated "7-segment" digit display, and p1 to p3
# the decimal points between the digits. The remaining bits are for the
# measurement units and some miscellaneous information.
#
array set mapping {
        1  {    RS232   Auto    DC      AC      }
        2  {    a1      a6      a5      S       }
        3  {    a2      a7      a3      a4      }
        4  {    b1      b6      b5      p1      }
        5  {    b2      b7      b3      b4      }
        6  {    c1      c6      c5      p2      }
        7  {    c2      c7      c3      c4      }
        8  {    d1      d6      d5      p3      }
        9  {    d2      d7      d3      d4      }
        10 {    Dio     K       n       µ       }
        11 {    Ton     M       %       m       }
        12 {    Hold    Ohm     Duty    F       }
        13 {    Batt    Hz      V       A       }
        14 {    {}      HFE     °C      {}      }
}

# Grouping some of the above logically. Note that 'unit' and 'umod'
# holds mutually exclusive elements, i.e. only ONE may be activated at
# any point in time (at least if the device works like it should :-)).
#
set info {Batt RS232 Auto DC AC Dio Ton Hold HFE}
set unit {Ohm Duty F Hz V A °C}
set umod {K n µ M % m} 

# ----------------------------------------------------------------------
# Prepare the Tk GUI elements
# ----------------------------------------------------------------------

# The sign is there just once ...
#
frame .sign -height 5 -width 20

# ... but the digits are there four times, so it makes sense to describe
# their participation in the GUI via a subroutine ...
#
proc makeDigit {f {p 0}} {
        set length 40
        set thickness 4
        set dotsize 6
        frame $f
        frame $f.1 -height $thickness -width $length -bg grey
        frame $f.2 -height $length -width $thickness -bg grey
        frame $f.3 -height $length -width $thickness -bg grey
        frame $f.4 -height $thickness -width $length -bg grey
        frame $f.5 -height $length -width $thickness -bg grey
        frame $f.6 -height $length -width $thickness -bg grey
        frame $f.7 -height $thickness -width $length -bg grey
        grid $f.1 -column 1 -row 0
        grid $f.2 -column 2 -row 1
        grid $f.3 -column 2 -row 3
        grid $f.4 -column 1 -row 4
        grid $f.5 -column 0 -row 3
        grid $f.6 -column 0 -row 1
        grid $f.7 -column 1 -row 2
        if {$p} {
                frame .p$p -height $dotsize -width $dotsize -bg grey
                grid .p$p -in $f -padx {8 0} -row 3 -column 3 -sticky s
        }
}

# ... and created all of them programmatically:
#
makeDigit .a 1
makeDigit .b 2
makeDigit .c 3
makeDigit .d

# The 'info' elements may be displayed independently from each other,
# hence they all need a label of their own:
#
frame .info
set n -1
foreach s $info {
        label .info.[incr n] -text $s -fg grey
        pack .info.$n -side left -padx 3
}

# The 'umode' and 'unit' elements are mutually exclusive, so there is
# just one label for each group:
#
label .umod -font {Sans 25}
label .unit -font {Sans 25}

# ----------------------------------------------------------------------
# Layout the Tk GUI elements
# ----------------------------------------------------------------------

# The general layout is done with "grid", using "column spanning"
# (requested by '-') and "row spanning" (requested by '^').
#
grid .info -  -  -  -  .umod .unit
grid .sign .a .b .c .d   ^     ^   -padx 3

# ----------------------------------------------------------------------
# Receiving data in an event-driven way
# ----------------------------------------------------------------------

# set-up things(including the baud rate of the serial interface) ...
#
set fd [open /dev/ttyS0]
fconfigure $fd\
        -mode 2400,n,8,1\
        -translation binary
fileevent $fd readable "display $fd"

# ... providing a call-back to read data once it is available:
#
proc display {fd} {
        global mapping info unit umod
        if {[eof $fd]} {
                close $fd
                return
        }
        set x [read $fd 1]
        scan $x %c x
        set n [expr ($x >> 4) & 0xF]
        if {![info exists mapping($n)]} return
        foreach w $mapping($n) {
                if {[regexp {^([abcd])([1-7])$} $w - b z]} {
                        .$b.$z configure -bg grey
                }
                if {[regexp {^p([1-3])$} $w - z]} {
                        .p$z configure -bg grey
                }
                if {[set p [lsearch $info $w]] >= 0} {
                        .info.$p configure -fg grey
                }
                if {[string equal $w [.umod cget -text]]} {
                        .umod configure -text ""
                }
                if {[string equal $w S]} {
                        .sign configure -bg grey
                }
        }
        for {set i 0} {$i < 4} {incr i} {
                if {[expr ($x & (1<<$i))]} {
                        set w [lindex $mapping($n) $i]
                        if {[regexp {^([abcd])([1-7])$} $w - b z]} {
                                .$b.$z configure -bg red
                        }
                        if {[regexp {^p([1-3])$} $w - z]} {
                                .p$z configure -bg red
                        }
                        if {[set p [lsearch $info $w]] >= 0} {
                                .info.$p configure -fg red
                        }
                        if {[string equal $w S]} {
                                .sign configure -bg red
                        }
                        if {[lsearch $umod $w] != -1} {
                                .umod configure -text $w
                        }
                        if {[lsearch $unit $w] != -1} {
                                .unit configure -text $w
                        }
                }
        }
        update idletasks ;# is this really necessary?
}

# ----------------------------------------------------------------------
# As this is Tk the event-loop is now entered and "run forever" ...
# ----------------------------------------------------------------------
#
# ... or until the display window is closed (with the [x]-button)


