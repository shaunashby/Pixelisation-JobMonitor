package Pixelisation::JobMonitor::Controller::Status;

use strict;
use warnings;
use DateTime::Format::Duration;
use parent 'Catalyst::Controller';

=head1 NAME

Pixelisation::JobMonitor::Controller::Job::Status - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut

=head2 index

=cut

sub index : Path Args(0) {
	my ( $self, $c ) = @_;	
	# Get the runs from the DB:
	$c->stash->{runs} = [ $c->model('DB::Run')->search(undef,{ order_by => 'updated DESC' }) ];	
    # Set the template:
	$c->stash->{template} = 'status/index.tt2';
	$c->forward("View::HTML");
}

sub benchmark : Path('/status/benchmark/instrument') Args(1) {
    my ($self, $c, $instrument) = @_;
    my $dformat = { 
    	   'hms' => DateTime::Format::Duration->new( pattern => '%M:%S' ),
           'secs' => DateTime::Format::Duration->new( pattern => '%s' ) 
    };
     
    my $datastring;
    
    # Get all rows for the given instrument: 
    my $runs = [ 
    map {     	
    	[ $dformat->{'secs'}->format_duration( $_->updated-$_->created ), $dformat->{'hms'}->format_duration( $_->updated-$_->created ), $_];
    } $c->model('DB::Run')->search({ instrument => $instrument },undef) ];
    
   
    foreach my $r (sort { $b->[0] <=> $a->[0] } @$runs) {
        $datastring.=sprintf("%-14s %-20s\t\t%-10d %-10s\n",$r->[2]->revno, $r->[2]->region,$r->[0],$r->[1]);
    }
    $c->response->content_type('text/plain');
	$c->response->body($datastring);
}

#sub index :Path :Args(0) {
#  my ( $self, $c ) = @_;
#  my $page = $c->req->param('page') || 1;
#  my $rows  = $c->req->param('rows') || 3;
#  my $where = { };
#  my $attr = { page => $page, rows => $rows, order_by => "created desc" };
#  my $rs = $c->model('DB::Pictures')->search( $where, $attr );
#  my $pager = $rs->pager();
#  $c->stash->{pager} = $pager;
#  $c->stash->{pictures} = [$rs->all];
#  $c->stash->{template} = 'pictures/list.tt2';
#}

sub result() : Path('/status/result/node') Args(1) {
	my ($self, $c, $node) = @_;
    my $json =
            {
                status => 'Unsuccessful',
                error => {Unknown => ''},
                runs  => []
            };  
    
    # Do something to populate the data.
	# Get the runs from the DB:
    my $runs = [ $c->model('DB::Run')->search({ hostname => $node },{ order_by => 'updated DESC' }) ];

    if ($runs) {
        delete($json->{error}->{'Unknown'}) if defined($json->{error}->{'Unknown'});
        $json->{status} = 'Successful';
        $json->{runs} = $runs
    }
        
    # Putting our return data into the json stash to get serialized into json
    $c->stash->{json} = $json;
    $c->forward("View::JSON");
}

sub notify : Local {
	my ($self, $c) = @_;
	my $logger = $c->log;
	my $secure_token = $c->config->{'clientid'};
	
	# Decode the parameters only if this is a POST:
	if ($c->request->method eq 'POST') {
		my $host = $c->request->param('host');
        my $instrument = $c->request->param('instrument');		
		my $revno = $c->request->param('revno') || 9999;
		my $region = $c->request->param('region') || 'all';
		my $status = $c->request->param('status');
		my $clientid = $c->req->param('CLIENTID');
		my $mode = lc($c->req->param('mode'));
		 
		if ($secure_token eq $clientid) {
			# Handle the request according to the mode (start, stop, update):
			if ($mode eq 'start') {
				my $run = $c->model('DB::Run')->find_or_create({
				'hostname' => $host,
				'instrument' => $instrument,
				'revno' => $revno,
				'region' => $region,
				'status' => $status,
				'info' => 'started'
				});
			} else {
				# Update. Find the run and make modifications deoending on whether we're ending the run
				# or just sending a ping:
				my $run = $c->model('DB::Run')->find({ 'hostname' => $host, 'instrument' => $instrument, 'revno' => $revno, 'region' => $region });
		
				if (!$run) {
					$c->log->debug("ERROR: Problem getting run for $revno $region on $host. Check logs.");
				} else {			
					$c->log->debug("Updating run for $revno $region (ID = ".$run->id."), status $status (host $host).");
					# Update the run status and progress info:
					$run->update({ 'status' => $status, 'info' => 'finished' });
				}
			}		
			# Send back some content:
			$c->response->body("POST request processed.");
		} else {
			$logger->warn("DENIED REQUEST from $host. CLIENTID not permitted access.");
			$c->response->status(404);
		}			
	} else {
		$c->response->body("Sorry, I only handle POST requests from authorised hosts.");
	}

}

=head1 AUTHOR

Shaun ASHBY

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
