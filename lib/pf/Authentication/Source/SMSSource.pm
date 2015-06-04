package pf::Authentication::Source::SMSSource;

=head1 NAME

pf::Authentication::Source::SMSSource

=head1 DESCRIPTION

=cut

use pf::constants qw($TRUE $FALSE);
use pf::Authentication::constants;

use Log::Log4perl qw(get_logger);
use Moose;
extends 'pf::Authentication::Source';

has '+class' => (default => 'external');
has '+type' => (default => 'SMS');
has '+unique' => (default => 1);
has 'sms_carriers' => (isa => 'ArrayRef', is => 'rw', default => sub {[]});
has 'create_local_account' => (isa => 'Str', is => 'rw', default => 'no');

=head1 METHODS

=head2 around BUILDARGS

Convert the comma-delimited string representing the SMS carriers to an array ref.

=cut

around BUILDARGS => sub {
    my $orig = shift;
    my $class = shift;
    my $attrs = shift;

    if (ref $attrs && exists $attrs->{sms_carriers} && !ref($attrs->{sms_carriers}) ) {
        my @carriers = split(/\s*,\s*/, $attrs->{sms_carriers});
        $attrs->{sms_carriers} = \@carriers;
    }

    return $class->$orig($attrs);
};

=head2 available_attributes

=cut

sub available_attributes {
  my $self = shift;

  my $super_attributes = $self->SUPER::available_attributes;
  my $own_attributes = [{ value => "phonenumber", type => $Conditions::SUBSTRING }];

  return [@$super_attributes, @$own_attributes];
}

=head2 available_actions

For a SMS source, only the authentication actions should be available

=cut

sub available_actions {
    my @actions = map( { @$_ } $Actions::ACTIONS{$Rules::AUTH});
    return \@actions;
}

=head2 match_in_subclass

=cut

sub match_in_subclass {
    my ($self, $params, $rule, $own_conditions, $matching_conditions) = @_;
    return $params->{'username'};
}

=head2 mandatoryFields

List of mandatory fields for this source

=cut

sub mandatoryFields {
    return qw(email phone mobileprovider);
}

=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2015 Inverse inc.

=head1 LICENSE

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
USA.

=cut

__PACKAGE__->meta->make_immutable;
1;

# vim: set shiftwidth=4:
# vim: set expandtab:
# vim: set backspace=indent,eol,start:
