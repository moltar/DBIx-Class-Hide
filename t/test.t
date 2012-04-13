use strict;
use warnings;

use lib qw(t/lib);

use Test::More;
use Test::Warn;

BEGIN {
    use_ok('MyApp1::Schema');
}

ok my $schema = MyApp1::Schema->connect('dbi:SQLite:dbname=:memory:', '', ''), 'Got schema 1';

isa_ok $schema, 'MyApp1::Schema';

$schema->deploy;

isa_ok $schema->resultset('Artist'), 'DBIx::Class::Hide::ResultSet';

for (1..3) {
    ok $schema->resultset('Artist')->create({
        artistid => $_,
        name => "Artist $_",
    }), "Created artist $_";
}
is $schema->resultset('Artist')->count, 3, 'Found 3 artists';

my $artist = $schema->resultset('Artist')->first;
isa_ok $artist, 'DBIx::Class::Hide::Result';

can_ok $artist, qw/hide/;

ok ! $artist->is_hidden, 'not hidden';
ok $artist->hide, 'hid the row';
ok $artist->is_hidden, 'is hidden';

# warn join ', ', @{mro::get_linear_isa('MyApp1::Schema::ResultSet::Artist')};

is $schema->resultset('Artist')->count, 2, 'only 2 artists are visible';
is $schema->resultset('Artist')->include_hidden->count, 3, 'found 3 artists when include_hidden';
is $schema->resultset('Artist')->only_hidden->count, 1, 'found 1 hidden artist';

ok $artist->show, 'show the row';
is $schema->resultset('Artist')->count, 2, '3 artists are visible';

done_testing;