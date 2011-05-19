use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'ForFS' }
BEGIN { use_ok 'ForFS::Controller::Forms' }

ok( request('/forms')->is_success, 'Request should succeed' );
done_testing();
