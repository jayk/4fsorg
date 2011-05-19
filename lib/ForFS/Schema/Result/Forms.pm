package ForFS::Schema::Result::Forms;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "Core");
__PACKAGE__->table("forms");
__PACKAGE__->add_columns(
  "id",
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
  "formkey",
  {
    data_type => "TEXT",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
  "form",
  {
    data_type => "BLOB",
    default_value => undef,
    is_nullable => 1,
    size => undef,
  },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2010-01-12 21:52:15
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GpJ4nxinIg7hs7c3pBJfVg


# You can replace this text with custom content, and it will be preserved on regeneration
1;
