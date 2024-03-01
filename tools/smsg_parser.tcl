#!/usr/bin/tclsh

#Version = 0.9
#Author: Dave Levy

# we can parse the arguments, the standared is flagname=value

# we are writing for compat with notify-send
# so -i -t and -m for a message text file , -h[ello] for help
# the parser ignores from after the second byte so -i = -iconfile

proc fileOK  {infile} {
	switch [ file exists $infile ] {
	1 { return } 0 { return }
	default { puts "oops" }
	}
}

set usage " -iconfile=filename -title=title/1st line -message=messagefile"

foreach p $argv {
 set i [ string first  =  $p ] ;# the = index byte
# set f [ string range $p 0 1 ] ;# the switch name/flag
 set a [ string range $p [ expr $i + 1 ] [ string length $p ]];# the argument
# puts [ string first = $p ]
# puts [ string range $p [ expr $i + 1] [ string length $p ]]
 switch [ string range $p 0 1 ] {
	-i { puts [ concat "icon file" $a]
		 fileOK $a  
		set parameters(icon) $a
			}
	-t { puts [ concat "title string " $a] 
		set parameters(title) $a }
	-m { puts [ concat "message file is " $a ] 
		fileOK $a
		set parameters(message) $a }
	-h { puts $usage }
	default { puts "oops"}
 }
}

# need to test that all three params have been set

foreach {key value} [array get parameters] {
	puts "$key -> $value" }
