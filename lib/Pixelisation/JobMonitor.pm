package Pixelisation::JobMonitor;

use strict;
use warnings;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use parent qw/Catalyst/;
use Catalyst qw/-Debug
                ConfigLoader
                Static::Simple/;
our $VERSION = '0.01';

# Configure the application.
#
# Note that settings in pixelisation_jobmonitor.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config( name => 'Pixelisation::JobMonitor', 
                     clientid => '5F5C34B2-6CC8-45A7-A0A5-8AAC638D2557',
                     'View::JSON' => {
                            expose_stash => 'json',
                            json_driver => 'JSON::XS'
                     }
    );

# Start the application
__PACKAGE__->setup();


=head1 NAME

Pixelisation::JobMonitor - Catalyst based application

=head1 SYNOPSIS

    script/pixelisation_jobmonitor_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<Pixelisation::JobMonitor::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Shaun ASHBY

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
