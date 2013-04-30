package Pixelisation::JobMonitor::View::HTML;

use strict;
use base 'Catalyst::View::TT';

__PACKAGE__->config({
    INCLUDE_PATH => [
        Pixelisation::JobMonitor->path_to( 'root', 'src' ),
        Pixelisation::JobMonitor->path_to( 'root', 'lib' )
    ],
    PRE_PROCESS  => 'config/main',
    WRAPPER      => 'site/wrapper',
    ERROR        => 'error.tt2',
    TIMER        => 0
});

=head1 NAME

Pixelisation::JobMonitor::View::HTML - Catalyst TTSite View

=head1 SYNOPSIS

See L<Pixelisation::JobMonitor>

=head1 DESCRIPTION

Catalyst TTSite View.

=head1 AUTHOR

Shaun ASHBY

=head1 LICENSE

This library is free software, you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

