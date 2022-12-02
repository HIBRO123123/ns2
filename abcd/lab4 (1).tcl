set ns [new Simulator]

set tf [open lab4.tr w]
$ns trace-all $tf

set nf [open lab4.nam w]
$ns namtrace-all $nf

proc finish { } {
	global nf tf ns
	$ns flush-trace
	close $nf
	close $tf
	exec nam lab4.nam &
	exit 0
}

set n0 [$ns node]
$n0 color "magenta"
$n0 label "src1"
set n1 [$ns node]
$n1 color "red"
set n2 [$ns node]
$n2 color "magenta"
$n2 label "src2"
set n3 [$ns node]
$n3 color "blue"
$n3 label "dest2"
set n4 [$ns node]
$n4 shape square
set n5 [$ns node]
$n5 color "blue"
$n5 label "dest1"

$ns make-lan "$n0 $n1 $n2 $n3 $n4" 50Mb 100ms LL Queue/DropTail Mac/802_3

$ns duplex-link $n4 $n5 1Mb 1ms DropTail
$ns duplex-link-op $n4 $n5 orient right

set tcp0 [new Agent/TCP]
$ns attach-agent $n0 $tcp0

set ftp0 [new Application/FTP]
$ftp0 attach-agent $tcp0
$ftp0 set packetSize_ 500
$ftp0 set interval_ 0.0001

set sink0 [new Agent/TCPSink]
$ns attach-agent $n5 $sink0

$ns connect $tcp0 $sink0

set tcp1 [new Agent/TCP]
$ns attach-agent $n2 $tcp1

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1
$ftp1 set packetSize_ 600
$ftp1 set interval_ 0.001

set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1

$ns connect $tcp1 $sink1

set file1 [open file1.tr w]
$tcp0 attach $file1

set file2 [open file2.tr w]
$tcp1 attach $file2

$tcp0 trace cwnd_
$tcp1 trace cwnd_

$ns at 0.5 "$ftp0 start"
$ns at 1.0 "$ftp0 stop"
$ns at 1.5 "$ftp0 start"
$ns at 2.0 "$ftp1 start"
$ns at 2.5 "$ftp1 stop"
$ns at 3.0 "$ftp0 stop"
$ns at 3.5 "$ftp1 start"
$ns at 4.0 "$ftp1 stop"

$ns at 5.0 "finish"

$ns run
