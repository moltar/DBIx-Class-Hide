package MyApp1::Schema;
use base qw/DBIx::Class::Schema/;

__PACKAGE__->load_components('Hide');
__PACKAGE__->load_namespaces();

1;