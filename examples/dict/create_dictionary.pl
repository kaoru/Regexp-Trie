#!/usr/bin/env perl

use strict;
use warnings;

use Regexp::Trie;

my $usage = "$0 [src] [dst]\n\nFor example: $0 /usr/share/dict/words dict.rx\n";
my $src = shift || die $usage;
my $dst = shift || die $usage;

my $trie = Regexp::Trie->new;

open my $fh_in, "<:encoding(utf-8)", $src or die "$src : $!";
while(readline $fh_in){
    chomp;
    $trie->add($_);
}
close $fh_in;

open my $fh_out, ">:encoding(utf-8)", $dst or die "$dst: $!";
print $fh_out 'qr{^ ', $trie->regexp_string, ' $}msx;';
close($fh_out);
