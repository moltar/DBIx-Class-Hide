package DBIx::Class::Hide;

use warnings;
use strict;

use version; our $VERSION = version->declare("v0.1");

use base 'DBIx::Class::AccessorGroup';

use DBIx::Class::Carp qw(carp);

__PACKAGE__->mk_group_accessors(inherited => qw/
    _track_resultset_accessors
    _hidden_column
    _hidden_value
    _hidden_condition
    _visible_value
    _visible_condition
/);
__PACKAGE__->_track_resultset_accessors({});
__PACKAGE__->_hidden_column('hidden');
__PACKAGE__->_hidden_value(1);
__PACKAGE__->_hidden_condition(1);
__PACKAGE__->_visible_value(undef);
__PACKAGE__->_visible_condition(undef);

sub register_source {
    my $self    = shift;
    my $moniker = $_[0];
    my $next    = $self->next::method(@_);
    my $schema  = ref($self) || $self;

    # need to track if we already ran register_source once, because
    # it might be re-run in sub-class, like in the case of
    # Catalyst::Model::DBIC::Schema via compose_namespaces
    return $next if
        exists $self->_track_resultset_accessors->{$schema}{$moniker};

    my $source = $schema->source($moniker);
    
    if ($source->has_column('hidden')) {
        $source->result_class->load_components('Hide::Result');
        $source->resultset_class->load_components('Hide::ResultSet');
    }

    return $next;
}



1; # eof
