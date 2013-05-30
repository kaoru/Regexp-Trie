use strict;
use warnings;

use Test::More tests => 3;
use Regexp::Trie;

my $rt = Regexp::Trie->new;
$rt->add($_) for (qw/foobar fooxar foozap fooza/);

is($rt->regexp, qr/foo(?:bar|xar|zap?)/, "regexp()");
is($rt->regexp_string, 'foo(?:bar|xar|zap?)', "regexp_string()");
is($rt->regexp_with_modifiers('i'), qr/foo(?:bar|xar|zap?)/i, "regexp_with_modifiers('i')");
