#!/usr/bin/perl

=head1 NAME

to-14.1-crypt-at-rest -

=head1 DESCRIPTION

to-14.1-crypt-at-rest

=cut

use strict;
use warnings;
use lib qw(/usr/local/pf/lib);
use lib qw(/usr/local/pf/lib_perl/lib/perl5);
use pf::UnifiedApi::Controller::Config;
use pf::config::crypt qw();
use Module::Pluggable
  'search_path' => [qw(pf::UnifiedApi::Controller::Config)],
  'sub_name'    => '_all_config',
  'require'     => 1,
  'inner'       => 0,
  ;

for my $name (__PACKAGE__->_all_config) {
    if ($name eq "pf::UnifiedApi::Controller::Config::Subtype" || !$name->isa("pf::UnifiedApi::Controller::Config")) {
        next;
    }

    my $c = $name->new();
    if ($name->isa( "pf::UnifiedApi::Controller::Config::Subtype")) {
        while (my ($type, $formName) = each %{$name->type_lookup()}) {
            update_config_controller($c, $name, $formName, { type => $type });
        }
    } else {
        my $formName = $c->form_class;
        update_config_controller($c, $name, $formName, {});
    }

}

sub update_config_controller{
    my ($c, $name, $formName, $item) = @_;
    $c->stash({admin_roles => []});
    print "$name $formName\n";
    my $form = $c->form($item);
    my %fields2Encrypt;
    for my $field ($form->fields) {
        my $fieldName = $field->name;
        my $type = $field->type;
        if ($type eq 'ObfuscatedText') {
            $fields2Encrypt{$fieldName} = undef;
        }
    }

    my $cs = $c->config_store;
    my $ini = $cs->cachedConfig;
    my $changed = 0;
    for my $section ($ini->Sections()) {
        print "$section\n";
        for my $param ($ini->Parameters($section)) {
            next if (!exists $fields2Encrypt{$param});
            print "$section.$param\n";
            my $val = $ini->val($section, $param);
            $val = pf::config::crypt::pf_encrypt($val);
            $ini->set($section, $val);
            $changed |= 1;
        }
    }
    if ($changed) {
        $ini->RewriteConfig();
    }
}


=head1 AUTHOR

Inverse inc. <info@inverse.ca>

=head1 COPYRIGHT

Copyright (C) 2005-2024 Inverse inc.

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

