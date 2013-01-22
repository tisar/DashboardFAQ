# --
# Kernel/Output/HTML/DashboardFAQ.pm
# Copyright (C) 2010 Daniel Obée
# --
# $Id: 
# --
# This software comes with ABSOLUTELY NO WARRANTY. For details, see
# the enclosed file COPYING for license information (AGPL). If you
# did not receive this file, see http://www.gnu.org/licenses/agpl.txt.
# --

package Kernel::Output::HTML::DashboardFAQ;

use strict;
use warnings;

use Kernel::System::FAQ;
use Kernel::Modules::FAQ;

sub new {
    my ( $Type, %Param ) = @_;

    # allocate new hash for object
    my $Self = {%Param};
    bless( $Self, $Type );

    $Self->{DashboardFAQObject}   = Kernel::Modules::FAQ->new(%Param);

    # interface settings
    $Self->{FAQObject}   = Kernel::System::FAQ->new(%Param);
    $Self->{DashboardFAQObject}{Interface} = $Self->{FAQObject}->StateTypeGet(
        Name => 'internal'
    );
    $Self->{DashboardFAQObject}{InterfaceStates} = $Self->{FAQObject}->StateTypeList(
        Types => [ 'internal', 'external', 'public' ]
    );
    
    # check all needed objects
    for (qw(ParamObject LayoutObject ConfigObject)) {
        $Self->{LayoutObject}->FatalError( Message => "Got no $_!" ) if ( !$Self->{$_} );
    }

    return $Self;
}

sub Preferences {
    my ( $Self, %Param ) = @_;
    return;
}

sub Config {
    my ( $Self, %Param ) = @_;
    return (
        %{ $Self->{Config} }
    );
}

sub Run {
    my ( $Self, %Param ) = @_;



 	my %DashboardFAQ = $Self->{DashboardFAQObject}->GetExplorer(
 		Mode => 'Agent',
# 		InterfaceStates => $InterfaceStates,
#		Interface => $Interface,
 		);

    my $Content = $Self->{LayoutObject}->Output(
        TemplateFile => 'AgentDashboardFAQ',
        Data 		 => \%DashboardFAQ,
    );

    return $Content;
}

1;
