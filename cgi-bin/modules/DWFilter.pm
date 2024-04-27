package DWFilter;

use CGI;
use strict;

our $MAX_PARAM_LENGTH = 50;

sub new {
    my $self = {};
    bless $self;

    $self->{_CGI} = new CGI;

    return $self;
}

sub FilterLatinDiget {
    my $self = shift;
    my $str = shift;

    if ($str !~ /^[a-zA-Z0-9]+$/) {
        return '';
    }
    else {
        return $str;
    }
}

sub FilterLatinDigetDash {
    my $self = shift;
    my $str = shift;

    if ($str !~ /^[a-zA-Z0-9\-\_]+$/) {
        return '';
    }
    else {
        return $str;
    }
}

sub FilterDiget {
    my $self = shift;
    my $str = shift;

    if ($str !~ /^[0-9]+$/) {
        return '';
    }
    else {
        return $str;
    }
}

sub FilterLengths {
    my $self = shift;
    my $str = shift;
    my $length = shift;

    if ($length == -1) {
        $length = $MAX_PARAM_LENGTH;
    }

    if (length($str) > $length) {
        return '';
    }
    else {
        return $str;
    }
}

sub FilterHTMLSpecialChars {
    my $self = shift;
    my $str = shift;

    $str =~ s/\"/\&quot\;/ig;
    $str =~ s/\'/\&quot\;/ig;
    $str =~ s/</\&lt\;/ig;
    $str =~ s/>/\&gt\;/ig;
    $str =~ s/\`/\&lsquo\;/ig;
    $str =~ s/\’/\&rsquo\;/ig;
    $str =~ s/\“/\&ldquo\;/ig;
    $str =~ s/\”/\&rdquo\;/ig;
    $str =~ s/\„/\&bdquo\;/ig;
    $str =~ s/\«/\&laquo\;/ig;
    $str =~ s/\»/\&raquo\;/ig;

    return $str;
}

sub FilterFile {
    my $self = shift;
    my $str = shift;

    if ($str !~ /^[a-zA-Z0-9\.\-\_]+$/) {
        return '';
    }
    else {
        if ($str =~ /\.\./) {
            return '';
        }
        return $str;
    }

    return $str;
}

sub FilterPicture {
    my $self = shift;
    my $str = shift;

    $str =~ /(.+)\.(.+)/i;
    my $Ext = $2;

    if (($Ext =~ /^jpg$/i) || ($Ext =~ /^png$/i) || ($Ext =~ /^gif$/i)) {
        return $str;
    }
    else {
        return '';
    }
}

sub FilterEmail {
    my $self = shift;
    my $str = shift;

    if ($str !~ /^[a-zA-Z0-9\-\_\.\@]+$/) {
        return '';
    }
    else {
        return $str;
    }
}

sub FilterMessage {
    my $self = shift;
    my $str = shift;

    if ($str !~ /^[a-zA-Z0-9\-\_\.\,А-Яа-я\&\;\s]+$/) {
        return '';
    }
    else {
        return $str;
    }
}

sub GetParamFilterDiget {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterDiget($self->FilterLengths($self->{_CGI}->param("$param"), $length));
}

sub GetParamFilterEmail {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterEmail($self->FilterLengths($self->{_CGI}->param("$param"), $length));
}

sub GetParamFilterHTMLSpecialChars {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterHTMLSpecialChars($self->FilterLengths($self->{_CGI}->param("$param"), $length));
}

sub GetParamFilterLatinDiget {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterLatinDiget($self->FilterLengths($self->{_CGI}->param("$param"), $length));
}

sub GetParamFilterLatinDigetDash {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterLatinDigetDash($self->FilterLengths($self->{_CGI}->param("$param"), $length));
}

sub GetCookieFilterDiget {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterDiget($self->FilterLengths($self->{_CGI}->cookie("$param"), $length));
}

sub GetCookieFilterEmail {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterEmail($self->FilterLengths($self->{_CGI}->cookie("$param"), $length));
}

sub GetCookieFilterHTMLSpecialChars {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterHTMLSpecialChars($self->FilterLengths($self->{_CGI}->cookie("$param"), $length));
}

sub GetCookieFilterLatinDiget {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterLatinDiget($self->FilterLengths($self->{_CGI}->cookie("$param"), $length));
}

sub GetCookieFilterLatinDigetDash {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterLatinDigetDash($self->FilterLengths($self->{_CGI}->cookie("$param"), $length));
}

sub GetClearParam {
    my $self = shift;
    my $param = shift;

    return $self->{_CGI}->param("$param");
}

sub GetTmpFileName {
    my $self = shift;
    my $param = shift;

    return $self->{_CGI}->tmpFileName($param);
}

sub GetFilterFile {
    my $self = shift;
    my $param = shift;
    my $length = shift;

    if ($length eq '') {
        $length = -1;
    }

    return $self->FilterFile($self->FilterLengths($self->{_CGI}->param("$param"), $length));
}

sub DESTROY {
    my $self = shift;
    $self->{_CGI} = '';
}

return 1;

