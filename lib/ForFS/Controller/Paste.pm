package ForFS::Controller::Paste;
use Moose;
use Form::Sensible;
use String::Random qw(random_regex random_string);
use Data::Dumper;
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

ForFS::Controller::Paste - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut



sub get_paste_form {
    my ($self, $c) = @_;
    
    my $form = Form::Sensible->create_form({
        name => 'paste',
        fields => [
                     { 
                        field_class => 'Text',
                        name => 'parent',
                        render_hints => { field_type => 'hidden' }
                     },
                     {
                         field_class => 'LongText',
                         name => 'content',
                         required => 1,
                         render_hints => {
                             rows => 25,
                             cols => 80,
                         }
                     },
                     {
                        field_class => 'Text',
                        name => 'pastekey',
                        validation => { regex => '^[0-9a-z]' }
                     },
                     {
                         field_class => 'Trigger',
                         name => 'submit'
                     }
                  ],
    });
    
    if (exists($c->req->params->{'submit'})) {
        $form->set_values($c->req->params);
    }
    
    return($form);
}

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;
    
    my $form = $self->get_paste_form($c);    
    my $renderer = Form::Sensible->get_renderer('HTML');
    my $renderedform = $renderer->render($form);
    $c->stash->{'paste_form'} = $renderedform;
    
    $c->stash->{'template'} = 'paste/index.tt';
}

sub paste_base : PathPart('paste') Chained('/') CaptureArgs(1) {
    my ($self, $c, $key) = @_;
    
    $c->stash->{'paste'} = $c->model('ForFSDB::Pastes')->search( pastekey => $key )->first;
    
    $key =~ m/([^\.]*)\.?(\d*)/;
    @{$c->stash->{'related_pastes'}} = $c->model('ForFSDB::Pastes')->search( {pastekey => { 'like' => $1 . "%" }},
                                                                           { columns => qw/ pastekey /, order_by => 'create_time' } )->all;
    $c->log->debug(Dumper($c->stash->{'related_pastes'}));
}

sub show : PathPart('') Chained('paste_base') Args(0) {
    my ($self, $c) = @_;
    
    my $form = $self->get_paste_form($c);
    
    ## if we are showing a paste, any new pastes will be children of this one.  
    ## So we make the pastekey hidden
    $form->field('pastekey')->render_hints({ field_type => 'hidden' });
    
    if ($c->stash->{'paste'}) {
        $form->set_values({
                            parent => $c->stash->{'paste'}->pastekey,
                            content => $c->stash->{'paste'}->content,
        });
    }
    my $renderer = Form::Sensible->get_renderer('HTML');
    my $renderedform = $renderer->render($form);
    $c->stash->{'paste_form'} = $renderedform;
    
    $c->stash->{'template'} = "paste/show.tt";
}

sub submit : Local {
    my ($self, $c) = @_;
    
    my $form = $self->get_paste_form($c);
    
    if ($form->validate()->is_valid) {
        my $pastekey = $form->field('pastekey')->value;
        my $parent = $form->field('parent')->value;
        my $message;
        my $paste;
        my $count = 0;
        my $child;
        do {
            if (!defined($pastekey)) {
                if (defined($parent) && length($parent) > 1 ) {
                    $parent =~ m/([^\.]*)\.?(\d*)/;
                    if (!$child) {
                        $child = $2;
                    }
                    $child++;
                    $pastekey = $1 . "." . $child;
                } else {
                    $pastekey = String::Random::random_string('cccnnn');
                }
            }
            $paste = $c->model('ForFSDB::Pastes')->search(pastekey => $pastekey)->first;
            if ($paste) {
                $pastekey = undef;
                $paste = undef;
                $count++;
            }
        } while (!defined($pastekey) && $count < 50);
        
        if (defined($pastekey) && !defined($paste)) {
            ## ok to create
            my $create_hash = {
                pastekey => $pastekey,
                content => $form->field('content')->value,
                create_time => time(),
            };
            if ($form->field('parent')->value) {
                $create_hash->{'parent'} = $form->field('parent')->value;
            }
            $paste = $c->model('ForFSDB::Pastes')->create($create_hash);
            if ($paste) {
                $c->log->debug($c->uri_for( $self->action_for('show'), [$paste->pastekey] ));
                $c->response->redirect($c->uri_for( $self->action_for('show'), [$paste->pastekey] ));
                $c->detach();
            }
        }
    } 
    
    my $renderer = Form::Sensible->get_renderer('HTML');
    my $renderedform = $renderer->render($form);
    $c->stash->{'paste_form'} = $renderedform;

    $c->stash->{'template'} = 'paste/form.tt';
    
}

=head1 AUTHOR

root

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

