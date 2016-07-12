#!/usr/bin/wish

set server_ip localhost
set server_port 8856

proc client_sync_send {ls} {
	foreach cl [array names ::clients] {
		puts $cl [list .out insert end $ls \n]
		flush $cl
	}
}

proc client_sync_receive {} {
}

proc client_connect {fd ip port} {
	set ::clients($fd) "$ip:$port"
	puts $fd [list proc build_tk_gui\
			[info args build_tk_gui]\
			[info body build_tk_gui]
	]
	puts $fd "build_tk_gui 10 60 $::switch_list"
	flush $fd
}


if {[info exists remote_control]} {
	socket -server client_connect $server_port
} else {
	set command ""
	proc receive_cmds {} {
		if {[eof $::remote]
                 || [gets $::remote line] < 0} {
			close $::remote
			exit
		}
		append ::command $line \n
		if {[info complete $::command]} {
				puts "# =============== START"
				puts -nonewline $::command
				puts "# =============== END"
				eval $::command
				set ::command ""
		}
	}
	set remote [socket $server_ip $server_port]
	fileevent $remote readable receive_cmds
}
