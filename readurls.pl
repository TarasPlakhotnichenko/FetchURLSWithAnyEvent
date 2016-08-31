#!/usr/bin/perl
use strict;
use warnings;
use AnyEvent;
use AnyEvent::HTTP;
use Time::HiRes qw(gettimeofday tv_interval);
 
my @urls = qw(
	http://yandex.ru/
	http://google.com/
	http://tutu.ru/
);

$userinput =  <STDIN>;
chomp ($userinput); 

my @urls = split(/\s+/, $userinput);

foreach my $url (@urls) {
$url=~s/^\s+|\s+$//g;

}


my $cv = AnyEvent->condvar;
 
foreach my $url (@urls) {
	print "Start $url\n";
	my $start_time = [ gettimeofday ];
	$cv->begin;
	http_get $url, sub {
		my ($html) = @_;
		print "$url received" .  $html "\n";
		$cv->end;
		my $end_time = [ gettimeofday ];
        my $elapsed = tv_interval($start_time,$end_time);
		print "$elapsed\n";
	};
}
 
print "Start the loop\n";
$cv->recv;
print "Finish the loop\n";
