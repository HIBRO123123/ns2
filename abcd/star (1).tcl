set ns [new Simulator]

$ns color 1 blue
$ns color 2 red

set tf [open star.tf w]
$ns trace-all $tf

set nf [open star.nam w]
$ns namtrace-all $nf

proc finish {} {
	global ns nf tf
	$ns flush-trace
	close $nf
	close $tf
	exec nam star.nam &
	exit 0
}

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

$ns duplex-link $n0 $n1 512Kb 50ms DropTail
$ns duplex-link $n0 $n2 512Kb 50ms DropTail
$ns duplex-link $n0 $n3 512Kb 50ms DropTail
$ns duplex-link $n0 $n4 512Kb 50ms DropTail

$ns duplex-link-op $n0 $n1 orient up
$ns duplex-link-op $n0 $n2 orient right
$ns duplex-link-op $n0 $n3 orient down
$ns duplex-link-op $n0 $n4 orient left

set tcp0 [new Agent/TCP]
$tcp0 set class_ 1
$ns attach-agent $n1 $tcp0

set sink0 [new Agent/TCPSink]
$ns attach-agent $n3 $sink0

$ns connect $tcp0 $sink0

set udp0 [new Agent/UDP]
$ns attach-agent $n2 $udp0

set null0 [new Agent/Null]
$ns attach-agent $n4 $null0

$ns connect $udp0 $null0

set cbr0 [new Application/Traffic/CBR]
$cbr0 set rate_ 256Kb
$cbr0 attach-agent $udp0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0

$ns at 0.1 "$ftp0 start"
$ns at 1.5 "$ftp0 stop"

$ns at 0.4 "$cbr0 start"
$ns at 1.0 "$cbr0 stop"

$ns at 2.0 "finish"
$ns run








