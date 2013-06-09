use strict;
use warnings;

use Test::More;
use Regexp::Trie;

my $fh_words;
open($fh_words, '<', '/usr/share/dict/words');
if (!$fh_words) {
    plan skip_all => 'Test requires /usr/share/dict/words';
    exit 0;
}

my $trie = Regexp::Trie->new;

my $word_count = 0;
while (my $word = readline $fh_words) {
    chomp $word;
    $trie->add($word);
    $word_count++;
}

plan tests => 1 + $word_count;

my $re = $trie->regexp;
ok $re, 'created trie with all words in /usr/share/dict/words';

$fh_words->seek(0, 0);

while (my $word = readline $fh_words) {
    chomp $word;
    ok $word =~ m/^$re$/, $word;
}

close $fh_words;
