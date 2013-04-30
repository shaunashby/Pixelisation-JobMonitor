use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Pixelisation::JobMonitor' }
BEGIN { use_ok 'Pixelisation::JobMonitor::Controller::Job::Status' }

ok( request('/job/status')->is_success, 'Request should succeed' );


