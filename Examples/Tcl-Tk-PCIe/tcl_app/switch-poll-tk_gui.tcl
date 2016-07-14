#!/usr/bin/wish
# =====================================================================
# Tcl Program with a TK-GUI to Poll PCIe-Controlled Switches
# =====================================================================

set USAGE \
"Usage:	$argv0 <path-prefix> <switch-letter> ...
 with	- <path-prefix> the prefix of the device file path name
        - <switch-letter> the switch selector (a single letter)
"

if {$argc < 3} {
	puts -nonewline stderr $USAGE; flush stderr; exit 1
}

# Configuration Options (to be changed in source code below)

# set show_scrollbar ""		;# no scrollbar for text output
# set show_scrollbar left 	;# scrollbar for text output left
  set show_scrollbar left 	;# scrollbar for text output right

# set poll_interval 200		;# just a single value or a list
  set poll_interval {1 2 5 10 20 50 100 200 500 1000 2000 5000}

  set poll_flash_duration 25	;# msecs to show the poll flash


set path_prefix [lindex $argv 0]
set switch_list [lreplace $argv 0 0]

proc poll_all_switches {} {
	global argv0 path_prefix switch_state switch_list
	set result ""
	
	foreach sw $switch_list {
		set fn $path_prefix$sw
		if {[catch {open $fn} fh]} {
			puts stderr "$::argv0: cannot open file ($fn)"
			exit 3
		}
		append result [gets $fh]
		close $fh
	}
	return $result
}

proc simulate_key_press {sw on_off} {
	global path_prefix
	set fh [open $path_prefix$sw w]
	puts $fh $on_off
	close $fh
}

proc build_tk_gui {h w args} {
	frame .top -borderwidth 5 -background lightgrey
	pack .top -side top -fill x

	if {[info exists ::poll_interval]
	 && [llength $::poll_interval] > 1} {
		frame .top.poll -borderwidth 3 -relief ridge
		pack .top.poll -side left -fill y
		label .top.poll.label -text "Poll (msec):"
		pack .top.poll.label -side left
		spinbox .top.poll.msec -width 4 -justify right\
			-values $::poll_interval\
			-textvariable poll_msec
		pack .top.poll.msec -side right
	}

	foreach sw $args {
		set b .top._$sw
		button $b -text "$sw"
		pack $b -side left -fill both -expand 1
		bind $b <ButtonPress-1>\
			"+ simulate_key_press $sw 1"
		bind $b <ButtonRelease-1>\
			"+ simulate_key_press $sw 0"
	}

	button .clear -text CLEAR\
		-background blue -foreground white\
		-command [list .out delete 1.0 end]
	pack .clear -side bottom -fill x
	
	text .out -width $w -height $h
	.out tag configure line1 -background white
	.out tag configure line2 -background bisque
	pack .out -side left -fill both -expand 1

	if 1 {
		scrollbar .sb -orient vertical
		.sb configure -command [list .out yview]
		.out configure -yscrollcommand [list .sb set]
		pack .sb -side right -fill y
	}

}

proc poll_once {old_state} {
	.top configure -background yellow
	if {[info exists ::poll_flash_duration]
	 && $::poll_flash_duration < $::poll_msec*2/3} {
		after $::poll_flash_duration\
			.top configure -background lightgrey
	}
	
	set new_state [poll_all_switches]
	if {![string equal $new_state $old_state]} {
		set now [expr {[clock microseconds] / 1e6}]
		set lines [lindex [split [.out index end] .] 0]
		set colorize [format {line%d} [expr {$lines%2 + 1}]]
		set state_change [format "\[%012.6f\]     %s --> %s\n"\
			$now\
			[join [split $old_state ""] " | "]\
			[join [split $new_state ""] " | "]\
		]
		client_sync_send $state_change $colorize
		.out insert end $state_change $colorize
		.out see end
		set ::lastline $state_change
		set ::lastcolor $colorize
	}
	return $new_state
}

proc poll_forever {switch_state} {
	set switch_state [poll_once $switch_state]
	global poll_msec 
	after $poll_msec poll_forever $switch_state
}

eval build_tk_gui 10 60 $switch_list 

set poll_interval_middle [expr {[llength $poll_interval]/2}]
set poll_msec [lindex $poll_interval $poll_interval_middle]

set server_port 8856

proc client_sync_send {ls lc} {
	foreach cl [array names ::clients] {
		puts $cl [list .out insert end $ls $lc]
		flush $cl
	}
}

proc client_receive {cl} {
	if {[eof $cl]
         || [gets $cl line] < 0} {
		close $cl
		unset ::clients($cl)
		return
	}
	append ::command $line\n
	if {[info complete $::command]} {
		uplevel #0 $::command
		unset ::command
	}
	
}

proc client_connect {fd ip port} {
	set ::clients($fd) "$ip:$port"
	puts $fd [list proc build_tk_gui\
			[info args build_tk_gui]\
			[info body build_tk_gui]
	]
	puts $fd [list proc simulate_key_press\
			[info args simulate_key_press]\
			{puts $::server_fd [list simulate_key_press $sw $on_off]}
	]
	puts $fd "build_tk_gui 10 60 $::switch_list"
	puts $fd [list .out insert end $::lastline $::lastcolor]
	flush $fd
	fileevent $fd readable [list client_receive $fd]
}
socket -server client_connect $server_port

wm title . "[wm title .] serving port $server_port"

poll_forever [string repeat ? [llength $switch_list]]
