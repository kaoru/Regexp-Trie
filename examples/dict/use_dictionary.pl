#!/usr/bin/env perl

use strict;
use warnings;

use Regexp::Trie;

#
# $ ./examples/dict/use_dictionary.pl dict.rx banana
# match! 'banana' is in the dictionary.
#
# $ ./examples/dict/use_dictionary.pl dict.rx bananas
# match! 'bananas' is in the dictionary.
#
# $ ./examples/dict/use_dictionary.pl dict.rx bananax
# miss! 'bananax' is not in the dictionary.
#

my $usage = "$0 [dict] [word]\n\nFor example: $0 dict.rx banana\n";
my $dict = shift || die $usage;
my $word = shift || die $usage;

my $rx = do $dict;

if ($word =~ $rx) {
    print "match! '$word' is in the dictionary.\n";
}
else {
    print "miss! '$word' is not in the dictionary.\n";
}
