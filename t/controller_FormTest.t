use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'ForFS' }
BEGIN { use_ok 'ForFS::Controller::FormTest' }

ok( request('/formtest')->is_success, 'Request should succeed' );
done_testing();
