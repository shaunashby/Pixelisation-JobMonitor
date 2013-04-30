use strict;
use warnings;
use Test::More tests => 3;

BEGIN { use_ok 'Catalyst::Test', 'Pixelisation::JobMonitor' }
BEGIN { use_ok 'Pixelisation::JobMonitor::Controller::Job' }

ok( request('/job')->is_success, 'Request should succeed' );


