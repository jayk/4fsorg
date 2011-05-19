package ForFS::Controller::FormTest;
use Moose;
use Form::Sensible;
use Data::Dumper;
use String::Random qw(random_regex random_string);
use namespace::autoclean;

BEGIN {extends 'Catalyst::Controller'; }

=head1 NAME

ForFS::Controller::FormTest - Catalyst Controller

=head1 DESCRIPTION

Catalyst Controller.

=head1 METHODS

=cut


=head2 index

=cut

sub index :Path :Args(0) {
    my ( $self, $c ) = @_;

    my @select_options;
    
    foreach my $i (0..23) {
        my $foo = random_string('CCC');
        push @select_options, {
                                 name => "Option " .$foo,
                                 value => $i,
                              };
    }

    my $form = Form::Sensible->create_form( {
                                                name => 'test',
                                                fields => [
                                                             { 
                                                                field_class => 'Text',
                                                                name => 'username',
                                                                validation => { regex => '^[0-9a-z]*'  }
                                                             },
                                                             {
                                                                 field_class => 'Text',
                                                                 name => 'password',
                                                                 editable => 0,
                                                                 render_hints => { field_type => 'password' }
                                                             },
                                                             {   
                                                                field_class => 'Number',
                                                                name => 'a_number',
                                                                step => 10,
                                                                lower_bound => 12,
                                                                upper_bound => 291,
                                                                render_hints => { field_type => 'select' }
                                                             },
                                                             {
                                                                 field_class => 'Toggle',
                                                                 display_name => 'Disable Fields (on/off control)',
                                                                 name => 'disabled',
                                                                 on_label => 'Yes',
                                                                 on_value => '1',
                                                                 off_label => 'No',
                                                                 off_value => '0',
                                                                 render_hints => { render_as => 'checkboxes' }
                                                             },
                                                             {
                                                                 field_class => 'LongText',
                                                                 name => 'long_text'
                                                             },
                                                             {
                                                                 field_class => 'Text',
                                                                 name => 'hidden_text',
                                                                 value => 'bob',
                                                                 render_hints => { field_type => 'hidden' }
                                                             },
                                                             {
                                                                 field_class => 'FileSelector',
                                                                 name => 'upload_file',
                                                                 valid_extensions => [ "jpg", "gif", "png" ],
                                                                 maximum_size => 262144,
                                                             },

                                                             {
                                                                 field_class => 'Select',
                                                                 name => 'a_select',
                                                                 options => \@select_options,
                                                             },
                                                             {
                                                                 field_class => 'Select',
                                                                 name => 'b_select',
                                                                 options => \@select_options,
                                                                 accepts_multiple => 1,
                                                                 render_hints => {
                                                                      select_size => 4,
                                                                  }
                                                             },
                                                             {
                                                                 field_class => 'Select',
                                                                 name => 'c_select',
                                                                 options => \@select_options,
                                                                 render_hints => {
                                                                     render_as => 'checkboxes',
                                                                 }
                                                             },

                                                             {
                                                                 field_class => 'Select',
                                                                 name => 'd_select',
                                                                 options => \@select_options,
                                                                 accepts_multiple => 1,
                                                                 render_hints => {
                                                                     render_as => 'checkboxes',
                                                                 }
                                                             },
                                                             {
                                                                  field_class => 'SubForm',
                                                                  name => 'subform',
                                                                  display_name => '',
                                                                  form => {
                                                                      fields => [
                                                                          { 
                                                                              field_class => 'Text',
                                                                              name => 'subuser',
                                                                              validation => { regex => '^[0-9a-z]*'  }
                                                                           },
                                                                           { 
                                                                               field_class => 'Text',
                                                                               name => 'subname',
                                                                               validation => { regex => '^[0-9a-z]*'  }
                                                                            },
                                                                      ],
                                                                      render_hints => {
                                                                          display_name => 'A Subform',
                                                                      }
                                                                  },
                                                             },
                                                             {
                                                                 field_class => 'Trigger',
                                                                 name => 'reset',
                                                                 render_hints => {
                                                                     render_as => 'reset'
                                                                 }
                                                             },
                                                             {
                                                                 field_class => 'Trigger',
                                                                 name => 'submit'
                                                             },
                                                             {
                                                                 field_class => 'Trigger',
                                                                 name => 'a_link',
                                                                 display_name => "Show me disabled fields",
                                                                 render_hints => {
                                                                     render_as => 'link',
                                                                     link => $c->uri_for($c->action, { disabled => 1 }),
                                                                 }
                                                             },
                                                          ],
                                            } );
                                            
    foreach my $field (values %{$form->fields()}) {
        $field->value_delegate( FSConnector( sub { 
                                  my $caller = shift;

                                  if ($#_ > -1) {   
                                      if (ref($_[0]) eq 'ARRAY' && !($caller->accepts_multiple)) {
                                          $c->req->params->{$caller->name} = $_[0]->[0];
                                      } else {
                                          $c->req->params->{$caller->name} = $_[0];
                                      }
                                  }
                                  return $c->req->params->{$caller->name}; 
                              }
                              ) );
    }
    #$form->field('hidden_text')->value('bob');
    my $renderer = Form::Sensible->get_renderer('HTML');
    my $renderedform = $renderer->render($form);
    $c->log->debug(Dumper($renderer->template)); #include_paths));

    # randomly disable some fields if disabled is set.
    if ($c->req->params->{'disabled'}) {
        foreach my $field (values %{$form->fields()}) {
            if ($field->name ne 'disabled' && $field->name ne 'submit' && (rand() * 100) > 60) {
                $field->editable(0);
            }
        }
    }
    #nt Dumper($renderedform);
    $c->stash->{'fform'} = $renderedform;
    $c->stash->{'template'} = 'formtest/index.tt';
    #$c->response->body('<html><body>' . $renderedform->complete('/formtest/submit') . "</body></html>");
}

sub submit : Local {
    my ($self, $c) = @_;
    
    $c->forward('index');
    #my $output = "You entered " . $c->req->params->{username} . ' and ' . $c->req->params->{'password'} . "\n";
    
    #$c->response->body('<html><body>' . $output . '</body></html>');
}


=head1 AUTHOR

Jay Kuri,,,

=head1 LICENSE

This library is free software. You can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__PACKAGE__->meta->make_immutable;

