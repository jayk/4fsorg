package ForFS::Schema::Result::Pastes;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("pastes");
__PACKAGE__->add_columns(
  "views",
  {
    data_type => "INTEGER",
    default_value => 1,
    is_nullable => 1,
    size => undef,
  },
  "last_view_time",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "create_time",
  {
    data_type => "INTEGER",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "owner",
  {
    data_type => "NUMERIC",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "pastekey",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "content",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "parent",
  {
      data_type => "TEXT",
      default_value => undef,
      is_nullable => 1,
      size => undef,
  }
);
__PACKAGE__->set_primary_key("pastekey");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-12 21:52:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:QgFaSX3j3dJLIpkA+Yrwzg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
