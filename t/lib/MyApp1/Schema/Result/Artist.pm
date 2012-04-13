package MyApp1::Schema::Result::Artist;
use base qw/DBIx::Class::Core/;

__PACKAGE__->table('artist');
__PACKAGE__->add_columns(qw/ artistid name/);
__PACKAGE__->add_columns(
    hidden => {
        data_type           => 'int',
        is_nullable         => 1,
    },
);
__PACKAGE__->set_primary_key('artistid');
__PACKAGE__->has_many(cds => 'MyApp1::Schema::Result::CD', 'artistid');

1;