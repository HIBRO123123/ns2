set ns [new Simulator]

set tf [open ring.tr w]
$ns trace-all $tf

set nf [open ring.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf tf
	$ns flush-trace
	close $nf
	close $tf
	exec nam ring.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]

$ns duplex-link $n0 $n1 512Kb 5ms DropTail
$ns duplex-link $n1 $n2 512Kb 5ms DropTail
$ns duplex-link $n2 $n3 512Kb 5ms DropTail
$ns duplex-link $n3 $n4 512Kb 5ms DropTail
$ns duplex-link $n4 $n5 512Kb 5ms DropTail
$ns duplex-link $n5 $n0 512Kb 5ms DropTail

set udp0 [new Agent/UDP]
$ns attach-agent $n0 $udp0

set null0 [new Agent/Null]
$ns attach-agent $n3 $null0

$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 1024
$cbr0 set interval_ 0.01
$cbr0 attach-agent $udp0

$ns at 0.5 "$cbr0 start"
$ns at 4.5 "$cbr0 stop"

$ns at 5.0 "finish"

$ns run
