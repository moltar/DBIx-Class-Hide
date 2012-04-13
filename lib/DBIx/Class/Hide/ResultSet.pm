package DBIx::Class::Hide::ResultSet;

use warnings;
use strict;

our $hidden;

sub search_rs {
    my ($self, @args) = @_;
    
    my $rs = $self->next::method(@args);
    
    unless (defined $hidden) {
        $hidden = 1;
        
        return $rs->search({ $self->result_source->schema->_hidden_column =>
            $self->result_source->schema->_visible_condition
        });
    }
    
    return $rs;
}

sub include_hidden {
    $hidden = 1;
    return shift;
}

sub only_hidden {
    my ($self, @args) = @_;
    
    return $self->search({
        $self->result_source->schema->_hidden_column =>
            $self->result_source->schema->_hidden_condition,
    });
}

## need to reset bool flag after the RS was finalized
sub _construct_object {
    my ($self, @args) = @_;
    $hidden = undef;
    $self->next::method(@args);
}

1; # eof