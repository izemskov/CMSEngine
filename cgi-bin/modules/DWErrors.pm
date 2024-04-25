package DWErrors;

use strict;

sub new {
	my $self = {};
	bless $self;
	shift;
	
	$self->{_PRINT_ERRORS} = shift;
	$self->{_LOG_PATH} = shift;
	$self->{_LINK_END_SCRIPT} = shift;
	
	return $self;
}

sub PrintError {
	my $self = shift;
	my $Text = shift;
	my $StopScript = shift;

	if ($self->{_PRINT_ERRORS} eq 'yes') {		
		print $Text;		
	}
	elsif (($self->{_PRINT_ERRORS} eq 'file') && ($self->{_LOG_PATH} ne '')) {
		unless (-e $self->{_LOG_PATH}) {
			open (LOGFILE, ">$self->{_LOG_PATH}");
			close (LOGFILE);
		}
	
		if (-e $self->{_LOG_PATH}) {
			open (LOGFILE, ">>$self->{_LOG_PATH}");
			print LOGFILE $Text."\n";
			close (LOGFILE);
		}
	}
	
	if ($StopScript eq 'yes') {
		if (($self->{_LINK_END_SCRIPT} ne '') && exists(&{$self->{_LINK_END_SCRIPT}})) {
			&{$self->{_LINK_END_SCRIPT}}();
		}
		exit;
	}
}

sub GetPrintError {
	my $self = shift;
	return $self->{_PRINT_ERRORS};
}

return 1;
