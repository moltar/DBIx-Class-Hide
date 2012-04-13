package DBIx::Class::Hide::Result;

use warnings;
use strict;

use Scalar::Util qw(looks_like_number);

sub hide {
    my $self = shift;
    return $self->update({ $self->result_source->schema->_hidden_column =>
        $self->result_source->schema->_hidden_value });
}

sub show {
    my $self = shift;
    
    # use Data::Dumper;
    # warn Dumper([ $self->hidden ]);
    
    return $self->update({ $self->result_source->schema->_hidden_column =>
            $self->result_source->schema->_visible_value });
}

sub is_hidden {
    my $self = shift;
    
    my $column = $self->result_source->schema->_hidden_column;
    my $visible_value = $self->result_source->schema->_visible_value;
    if (defined $visible_value) {
        if (looks_like_number($visible_value)) {
            return $self->$column != $visible_value;
        } else {
            return $self->$column ne $visible_value;
        }
    } else {
        return defined $self->$column;
    }
}

sub is_visible {
    my $self = shift;
    return ! $self->is_hidden;
}

1; # eof
