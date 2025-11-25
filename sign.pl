#!/usr/bin/perl -w
use strict;
use warnings;

# Take bootblock filename as argument
my $file = shift or die "usage: sign.pl bootblock\n";

open(my $in, "<", $file) or die "cannot open $file: $!";
binmode($in);

my $buf = "";
my $n = read($in, $buf, 1000);
defined $n or die "read error on $file\n";
$n > 0 or die "empty $file\n";

my @b = unpack("C*", $buf);

# boot block must be at most 510 bytes before signature
if (@b > 510) {
    die "bootblock too large: " . scalar(@b) . " bytes (max 510)\n";
}

# pad with zeros up to 510 bytes
push @b, (0) x (510 - @b);

# add 0x55AA signature
$b[510] = 0x55;
$b[511] = 0xAA;

$buf = pack("C*", @b);

open(my $out, ">", $file) or die "cannot write $file: $!";
binmode($out);
print $out $buf;
close($out);
