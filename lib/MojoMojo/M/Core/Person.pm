package MojoMojo::M::Core::Person;

sub get_user {
    my ( $class, $user ) = @_;
    return __PACKAGE__->search( login => $user )->next;
}

sub is_admin {  
    my $self=shift;
    my $admins = MojoMojo->pref('admins');
    return 1 if my $user=$self->login  && $admins =~m/\b$user\b/ ;
    return 0;
}

sub link {
   my ($self) = @_;
   
   return "/".($self->login || '/no_login');
}

sub registration_profile { 
    return { 
         email => { constraint => 'email',
                    name       => 'Invalid format'},
         login =>[{ constraint => qr/^\w{3,10}$/,
                    name       => 'only letters, 3-10 chars'},
                  { constraint => \&user_exists,
                    name       => 'Username taken'}],
         name  => { constraint => qr/^\S+\s+\S+/,
                    name       => 'Full name please'},
      pass     => { constraint => \&pass_matches,
                     params    => [ qw( pass confirm)],
                     name      => "Password doesn't match"}
   };
}

sub user_exists {
    return 0 if MojoMojo::M::Core::Person->get_user(shift);
    return 1;
}

sub pass_matches {
    return 1 if ($_[0] eq $_[1]);
    return 0
}

sub valid_pass {
    my ($self,$pass)=@_;
    return 1 if $self->pass eq $pass;
    return 0;
}

1;
