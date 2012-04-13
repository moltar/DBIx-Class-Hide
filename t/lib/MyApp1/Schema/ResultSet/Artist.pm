package MyApp1::Schema::ResultSet::Artist;

use strict;
use warnings;

use base 'DBIx::Class::ResultSet';

__PACKAGE__->load_components('Hide::ResultSet');

1; # eof