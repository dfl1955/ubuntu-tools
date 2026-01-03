#!/usr/bin/env tclsh

# written by chatgpt, a hand written comm -23

# Check arguments
if {$argc != 2} {
    puts stderr "Usage: $argv0 <file1> <file2>"
    exit 1
}

set file1 [lindex $argv 0]
set file2 [lindex $argv 1]

set f1 [open $file1 r]
set f2 [open $file2 r]

set line1 [gets $f1]
set line2 [gets $f2]

while {$line1 ne ""} {
    if {$line2 eq ""} {
        # file2 exhausted → print remaining file1 lines
        puts $line1
        set line1 [gets $f1]
    } elseif {$line1 eq $line2} {
        # lines match → skip both
        set line1 [gets $f1]
        set line2 [gets $f2]
    } elseif {$line1 < $line2} {
        # line1 only
        puts $line1
        set line1 [gets $f1]
    } else {
        # line2 is smaller → advance file2
        set line2 [gets $f2]
    }
}

close $f1
close $f2
