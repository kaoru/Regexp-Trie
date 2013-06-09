package Regexp::Trie;

use strict;
use warnings;

use 5.008001;

our $VERSION = 0.02;

sub new{ bless {} => shift }
sub add{
    my $self = shift;
    my $str  = shift;
    my $ref  = $self;
    for my $char (split //, $str){
        $ref->{$char} ||= {};
        $ref = $ref->{$char};
    }
    $ref->{''} = 1; # { '' => 1 } as terminator
    $self;
}
sub _regexp{
    my $self = shift;
    return if $self->{''} and scalar keys %$self == 1; # terminator
    my (@alt, @cc);
    my $q = 0;
    for my $char (sort keys %$self){
        my $qchar = quotemeta $char;
        if (ref $self->{$char}){
            if (defined (my $recurse = _regexp($self->{$char}))){
                push @alt, $qchar . $recurse;
            }else{
                push @cc, $qchar;
            }
        }else{
            $q = 1;
        }
    }
    my $cconly = !@alt;
    @cc and push @alt, @cc == 1 ? $cc[0] : '['. join('', @cc). ']';
    my $result = @alt == 1 ? $alt[0] : '(?:' . join('|', @alt) . ')';
    $q and $result = $cconly ? "$result?" : "(?:$result)?";
    return $result;
}
sub regexp{ my $str = shift->_regexp; qr/$str/ }
sub regexp_string { shift->_regexp; }

sub regexp_with_modifiers {
    my $self = shift;
    my $mods = shift;

    my $re_string = $self->_regexp;
    my $re_obj = eval "qr/$re_string/$mods;";
    if ($@) {
        die $@;
    }

    return $re_obj;
}

1;

__END__
=head1 NAME

Regexp::Trie - builds trie-ized regexp

=head1 SYNOPSIS

  use Regexp::Trie;

  my $trie = Regexp::Trie->new;
  $trie->add($_) for (qw/foobar fooxar foozap fooza/);

  print $trie->regexp, "\n";
  # (?^:foo(?:bar|xar|zap?))
  # [ or (?-xism:foo(?:bar|xar|zap?)) before Perl 5.14 ]

  print $trie->regexp_string, "\n";
  # foo(?:bar|xar|zap?)

  print $trie->regexp_with_modifiers('i'), "\n";
  # (?^i:foo(?:bar|xar|zap?))
  # [ or (?i-xsm:foo(?:bar|xar|zap?)) before Perl 5.14 ]

=head1 DESCRIPTION

This module is a faster but simpler version of L<Regexp::Assemble> or
L<Regexp::Optimizer>.  It builds a trie-ized regexp as above.

This module is faster than L<Regexp::Assemble> but you can only add
literals.  C<a+b> is treated as C<a\+b>, not "more than one a's
followed by b".

I wrote this module because I needed something faster than
L<Regexp::Assemble> and L<Regexp::Optimizer>.  If you need more minute
control, use those instead.

To read more about tries see L<Trie on Wikipedia|http://en.wikipedia.org/wiki/Trie>

=head1 TIPS

A good trick is to convert a big dictionary into a single regexp that can be
later loaded as:

  my $rx = do 'dict.rx';

See examples/dict/create_dictionary.pl and examples/dict/use_dictionary.pl for
a fuller example.

=head2 EXPORT

None.

=head1 SEE ALSO

L<Regexp::Optimizer>,  L<Regexp::Assemble>, L<Regex::PreSuf>

=head1 AUTHOR

Original implementation - Dan Kogai, E<lt>dankogai@dan.co.jpE<gt>

regexp_with_string, regexp_with_modifiers, more tests and updated documentation - Alex Balhatchet, E<lt>kaoru@slackwise.netE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 by Dan Kogai

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
