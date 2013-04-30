package Pixelisation::JobMonitor::Controller::Job;

use strict;
use warnings;
use parent 'Catalyst::Controller';

=head1 NAME

Pixelisation::JobMonitor::Controller::Job - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
	# Get the jobs from the DB:
	$c->stash->{jobs} = [ $c->model('DB::Job')->search(undef,{ order_by => 'updated DESC' }) ];	
    $c->stash->{njobs} = $#{$c->stash->{jobs}} + 1;
    # Set the template:
	$c->stash->{template} = 'jobs/index.tt2';
	$c->forward("View::HTML");
}

sub job_data : Chained("/") PathPart("jobs") CaptureArgs(2) {
    my ($self, $c, $instrument, $dataset) = @_;
    # Get the jobs from the DB:
    $c->stash->{jobs} = [ $c->model('DB::Job')->search({ instrument => $instrument, dataset => $dataset},{ order_by => 'updated DESC' }) ]; 
    $c->stash->{instrument} = uc($instrument);
    $c->stash->{dataset} = uc($dataset);
    $c->stash->{njobs} = $#{$c->stash->{jobs}} + 1;
}

sub runs: Chained("job_data") PathPart('') Args(0) {
	my ($self, $c) = @_;
	$c->log->debug("runs action in ".__PACKAGE__);
    # Set the template:
    $c->stash->{template} = 'jobs/dataset_index.tt2';
    $c->forward("View::HTML");
}

=head1 AUTHOR

Shaun ASHBY

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
