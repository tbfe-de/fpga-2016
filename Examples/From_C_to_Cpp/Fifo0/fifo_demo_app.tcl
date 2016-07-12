#!/usr/bin/wish

source fifo.tcl

proc rate_greyout {type w} {
	set fg [lindex {white black} $::run($type-$w)]
	$w.rate configure -foreground $fg
}

proc create_runner {type w} {
	frame $w\
		-relief ridge\
		-borderwidth 2
	checkbutton $w.run\
		-variable ::run($type-$w)\
		-command [list rate_greyout $type $w]
	label $w.rate\
		-width 7\
		-anchor e\
		-justify right\
		-textvariable ::rate($type-$w)
	set ::rate($type-$w) "--- %"
	eval [$w.run cget -command]	

	switch -exact $type {
		producer { set side top }
		consumer { set side bottom }
	}
	pack $w.run -side $side -fill x
	pack $w.rate -side $side -fill both -expand 1
	pack $w -side left -fill y -expand 1

}

proc create_gui {} {
	frame .p\
		-borderwidth 8\
		-background lightgreen
	label .p.t\
		-text "Producer(s)"\
		-borderwidth 6\
		-background lightgreen
	pack .p.t -side top -fill x
	label .p.info\
		-width 10\
		-anchor e\
		-justify right\
		-background lightgreen\
		-textvariable ::info(producers)
	set ::info(producers) "Total\n---"
	pack .p.info -side right -padx 5 -pady 5 -fill y
	foreach p {1 2 3 4 5} {
		create_runner producer .p.$p
	}

	frame .c\
		-borderwidth 8\
		-background lightblue
	label .c.t\
		-text "Consumer(s)"\
		-borderwidth 6\
		-background lightblue
	pack .c.t -side bottom -fill x
	label .c.info\
		-background lightblue\
		-width 10\
		-anchor e\
		-justify right\
		-textvariable ::info(consumers)
	set ::info(consumers) "Total\n---"
	pack .c.info -side right -padx 5 -pady 5 -fill y
	foreach p {1 2 3} {
		create_runner consumer .c.$p
	}

	frame .s\
		-borderwidth 4\
		-background salmon
	label .s.info\
		-width 14\
		-anchor e\
		-justify right\
		-background salmon\
		-textvariable ::info(fifo)
	
	pack .s.info -side right -padx 5 -pady 5
	label .s.slow -text "(slow)" -anchor s
	label .s.fast -text "(fast)" -anchor s
	label .s.name -text "set load testing speed"
	scale .s.speed\
		-orient horizontal\
		-from 10 -to 0\
		-showvalue 0\
		-variable ::speed
	pack .s.slow -side left -fill y
	pack .s.fast -side right -fill y
	pack .s.name -side top -fill x
	pack .s.speed -fill both -expand 1

	pack .p -side top -fill x
	pack .c -side bottom -fill x

	pack .s -fill both -expand 1
}

proc calculate_latency {dtime} {
	incr ::cumtime $dtime
	lappend ::dtime $dtime
	set ::timings [llength $::dtime]
	if {$timings > 100} {
		incr ::cumtime -[lindex $::dtime 0]
		set ::dtime [lreplace $::dtime 0 0]
		set ::timings 100
	}
}

proc run_simulation {} {
	set names [array names ::run]
	while {[set n [llength $names]]} {
		set p [expr {int(floor($n*rand()))}]
		set x [lindex $names $p]
		set names [lreplace $names $p $p]
		if {!$::run($x)} continue
		set now [clock microseconds]
		switch -glob $x {
			producer-* {
				set ok [fifo_put $now]
			}
			consumer-* {
				set ok [fifo_get since]
				if {$ok} {
					lappend ::dtime [expr {$now-$since}]
				}
			}
		}
		lappend ::tried($x) $ok
	}
	set msec [expr {1<<$::speed}]
	after $msec run_simulation
}

proc info_update {msec} {
	set rate_producers 0
	set rate_consumers 0
	foreach x [array names ::tried] {
		if {[set ntried [llength $::tried($x)]]} {
		}
		set success 0
		foreach ok $::tried($x) {
			incr success $ok
		}
		set triedwin 30
		if {$ntried > $triedwin} {
			set p [expr {$ntried-$triedwin-1}]
			set ::tried($x) [lreplace $::tried($x) 0 $p]
		}
		set rate [expr {100*$success/$ntried}]
		if {$::run($x)} {
			switch -glob -- $x {
				producer-* { incr rate_producers $rate }
				consumer-* { incr rate_consumers $rate }
			}
		}
		set ::rate($x) [format "%d %%" [expr {100*$success/$ntried}]]
		foreach r {producers consumers} {
			set ::info($r) [format "  Total\n%4d %%" [set rate_$r]]
		}
	}
	set ::info(fifo) [format "queued items: %2d\n" [fifo_size]]
	if {[info exists ::dtime]
         && [set ntimings [llength $::dtime]]} {
		set cumtime 0
		foreach ct $::dtime {
			incr cumtime $ct
		}
		set timingswin 30
		if {$ntimings > $timingswin} {
			set p [expr {$ntimings-$timingswin-1}]
			set ::dtime [lreplace $::dtime 0 $p]
		}
		set avgtime [expr {$cumtime/$ntimings}]
		set avgmsec [expr {$avgtime/1e6*1e3}]
		append ::info(fifo) [format "\u0394t: %.2f ms" $avgmsec]
	}
	after $msec info_update $msec
}

set speed 4
create_gui
info_update 133
run_simulation
wm title . "FIFO DEMO"

