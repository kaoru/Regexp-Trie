use strict;
use warnings;

use Test::More tests => 3;
use Regexp::Trie;

my $trie = Regexp::Trie->new;
$trie->add($_) for (qw/foobar fooxar foozap fooza/);

is($trie->regexp, qr/foo(?:bar|xar|zap?)/, "regexp()");
is($trie->regexp_string, 'foo(?:bar|xar|zap?)', "regexp_string()");
is($trie->regexp_with_modifiers('i'), qr/foo(?:bar|xar|zap?)/i, "regexp_with_modifiers('i')");
