use strict;
use warnings;
use Test::More;

BEGIN { use_ok 'Catalyst::Test', 'ForFS' }
BEGIN { use_ok 'ForFS::Controller::Pastes' }

ok( request('/pastes')->is_success, 'Request should succeed' );
done_testing();
