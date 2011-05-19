package ForFS::Model::ForFSDB;

use strict;
use base 'Catalyst::Model::DBIC::Schema';

__PACKAGE__->config(
    schema_class => 'ForFS::Schema',
    
    connect_info => {
        dsn => 'dbi:SQLite:dbname=ForFS.db',
        user => '',
        password => '',
    }
);

=head1 NAME

ForFS::Model::ForFSDB - Catalyst DBIC Schema Model

=head1 SYNOPSIS

See L<ForFS>

=head1 DESCRIPTION

L<Catalyst::Model::DBIC::Schema> Model using schema L<ForFS::Schema>

=head1 GENERATED BY

Catalyst::Helper::Model::DBIC::Schema - 0.35

=head1 AUTHOR

root

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
