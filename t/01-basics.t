use strict;
use warnings;

use Test::More;
use Regexp::Trie;

my @tests = (
    ## simplest - one input only!
    { input => [ 'foo' ], expected => qr/foo/ },
    { input => [ 'bar' ], expected => qr/bar/ },
    { input => [ 'baz' ], expected => qr/baz/ },

    ## two inputs - distinct
    { input => [ 'foo', 'bar' ], expected => qr/(?:bar|foo)/ },

    ## two inputs - prefix
    { input => [ 'foo', 'foos' ], expected => qr/foos?/ },

    ## two inputs - substring
    { input => [ 'foobar', 'foozap' ], expected => qr/foo(?:bar|zap)/ },

    ## lots of inputs!
    {
        input => [ qw(foo bar baz qux quux corge grault) ],
        expected => qr/(?:ba[rz]|corge|foo|grault|qu(?:ux|x))/,
    },
);

plan tests => scalar @tests;

for my $test (@tests) {
    my $rt = Regexp::Trie->new;
    $rt->add($_) for @{ $test->{input} };

    my $msg = sprintf("%s => %s",
        join(",", @{ $test->{input} }),
        $test->{expected}
    );

    is $rt->regexp, $test->{expected}, $msg;
}
