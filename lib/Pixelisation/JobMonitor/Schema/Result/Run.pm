package Pixelisation::JobMonitor::Schema::Result::Run;

use strict;
use warnings;

use base 'DBIx::Class';

__PACKAGE__->load_components("InflateColumn::DateTime", "TimeStamp", "Core");
__PACKAGE__->table("run");
__PACKAGE__->add_columns(
  "id",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
  "hostname",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "revno",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "region",
  { data_type => "TEXT", is_nullable => 0, size => undef },
  "status",
  { data_type => "INTEGER", is_nullable => 0, size => undef },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.04006 @ 2009-07-14 15:56:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BeHAHwTVWgnSVHWRFy+w9w
__PACKAGE__->add_columns(
        "instrument", 
        { data_type => 'TEXT', is_nullable => 0, size => undef },
  		"info",
		{ data_type => "TEXT", is_nullable => 0, size => undef },
        "created",
        { data_type => 'datetime', set_on_create => 1 },
        "updated",
        { data_type => 'datetime', set_on_create => 1, set_on_update => 1 },
    );
# You can replace this text with custom content, and it will be preserved on regeneration

# We're using convert_blessed to convert the objects into hash references as part
# of the encode process. This method returns the serialized object:
sub TO_JSON() {
	my $self = shift;
	# FIXME: Not sure of the proper way to do this. How can we access
	# the names of the columns in the table?
	# Presumably we're supposed to expose this metadata using Moose classes? 
	return { %{ $self->{_column_data} } };
}

1;
