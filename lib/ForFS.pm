package ForFS;
use Moose;
use namespace::autoclean;

use Catalyst::Runtime 5.80;

# Set flags and add plugins for the application
#
#         -Debug: activates the debug mode for very useful log messages
#   ConfigLoader: will load the configuration from a Config::General file in the
#                 application's home directory
# Static::Simple: will serve static files from the application's root
#                 directory

use Catalyst qw/
    -Debug
    ConfigLoader
    Static::Simple
/;

extends 'Catalyst';

our $VERSION = '0.01';
$VERSION = eval $VERSION;

# Configure the application.
#
# Note that settings in forfs.conf (or other external
# configuration file that you set up manually) take precedence
# over this when using ConfigLoader. Thus configuration
# details given here can function as a default configuration,
# with an external configuration file acting as an override for
# local deployment.

__PACKAGE__->config(
    name => 'ForFS',
    # Disable deprecated behavior needed by old applications
    disable_component_resolution_regex_fallback => 1,
    'View::TT' => {
        INCLUDE_PATH => [
            __PACKAGE__->path_to( 'root', 'templates', 'lib' ),
            __PACKAGE__->path_to( 'root', 'templates', 'src' ),
            __PACKAGE__->path_to( 'root', 'templates'),
        ],
        TEMPLATE_EXTENSION => '.tt',
        PRE_PROCESS  => 'config/main.tt',
        WRAPPER      => 'site/wrapper.tt',
    },
);

# Start the application
__PACKAGE__->setup();


=head1 NAME

ForFS - Catalyst based application

=head1 SYNOPSIS

    script/forfs_server.pl

=head1 DESCRIPTION

[enter your description here]

=head1 SEE ALSO

L<ForFS::Controller::Root>, L<Catalyst>

=head1 AUTHOR

Jay Kuri,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;
