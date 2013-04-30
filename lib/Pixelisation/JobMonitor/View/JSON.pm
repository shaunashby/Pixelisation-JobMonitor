package Pixelisation::JobMonitor::View::JSON;

use strict;
use base 'Catalyst::View::JSON';

use JSON::XS;

=head1 NAME

Pixelisation::JobMonitor::View::JSON - Catalyst JSON View

=head1 SYNOPSIS

See L<Pixelisation::JobMonitor>

=head1 DESCRIPTION

Catalyst JSON View.

=head1 AUTHOR

Shaun ASHBY

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

sub encode_json($) {
    my($self, $c, $data) = @_;
    my $encoder = JSON::XS->new->pretty->convert_blessed(1);
    return $encoder->encode($data);
}


1;
