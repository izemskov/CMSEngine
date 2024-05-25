package DWDataBase;

use DBI;
use strict;

our $MYSQL_TABLE_NAME = '';

require "connect_data.pl";

sub new {
    my $self = {};
    bless $self;

    shift;
    $self->{_DWErrors} = shift;
    $self->{_CHECK_CONNECT} = 'no';

    my ($mysql_user_db, $mysql_password_db, $mysql_base_name, $mysql_host_url) = &GetConnectData;
    $self->{_DBH} = DBI->connect("DBI:mysql:$mysql_base_name:$mysql_host_url",
       $mysql_user_db, $mysql_password_db) or die "Error connecting to database";

    $self->{_CHECK_CONNECT} = 'yes';
    $self->{_COUNT_QUERY_DB} = 0;
    $self->{_MYSQL_TABLE_NAME} = $MYSQL_TABLE_NAME;
    $self->{_STOP_SCRIPT} = 'no';

    $self->QueryDoDB(qq{SET NAMES utf8});

    return $self;
}

=item
Проверка наличия соединения с базой
=cut
sub IsConnect {
    my $self = shift;
    if (($self->{_CHECK_CONNECT} eq 'yes') && ($self->{_DBH} ne '')) {
        return 'yes';
    }
    else {
        return 'no';
    }
}

=item
Запросы к базе
=cut
sub QueryDoDB {
    my $self = shift;
    my $sql = shift;

    if ($self->IsConnect() eq 'yes') {
        if (@_) {
            $self->{_DBH}->do($sql, undef, @_) or die 'Cannot execute query';
        }
        else {
            $self->{_DBH}->do($sql) or die 'Cannot execute query';
        }
        $self->{_COUNT_QUERY_DB}++;
        $self->CheckErrorDB($self->{_STOP_SCRIPT});
    }
}

sub QuerySelectRowDB {
    my $self = shift;
    my $sql = shift;

    if ($self->IsConnect() eq 'yes') {
        my @result = ();

        if (@_) {
            @result = $self->{_DBH}->selectrow_array($sql, undef, @_);
        }
        else {
            @result = $self->{_DBH}->selectrow_array($sql);
        }
        $self->{_COUNT_QUERY_DB}++;
        $self->CheckErrorDB($self->{_STOP_SCRIPT});

        return @result;
    }
}

sub QuerySelectPrepareDB {
    my $self = shift;
    my $sql = shift;

    if ($self->IsConnect() eq 'yes') {
        my $sth;

        if (@_) {
            $sth = $self->{_DBH}->prepare($sql); $sth->execute(@_);
        }
        else {
            $sth = $self->{_DBH}->prepare($sql); $sth->execute();
        }
        $self->{_COUNT_QUERY_DB}++;
        $self->CheckErrorDB($self->{_STOP_SCRIPT});

        return $sth;
    }
}

=item
Проверка ошибок
=cut
sub CheckErrorDB {
    my $self = shift;
    my $StopScript = shift;

    if ($self->IsConnect() eq 'yes') {
        if ($StopScript eq '') {
            $StopScript = 'no';
        }

        if ($self->{_DBH}->errstr ne '') {
            if ($self->{_DWErrors} ne '') {
                $self->{_DWErrors}->PrintError($self->{_DBH}->errstr, $StopScript);
            }
        }
    }
}

=item
Возвращает ID последней добавленной в базу записи
=cut
sub GetMysqlInsertID {
    my $self = shift;

    if ($self->IsConnect() eq 'yes') {
        return $self->{_DBH}->{mysql_insertid};
    }
    else {
        return '';
    }
}

sub SetStopScript {
    my $self = shift;
    my $StopScript = shift;

    if (($StopScript eq 'yes') || ($StopScript eq 'no')) {
        $self->{_STOP_SCRIPT} = $StopScript;
    }
}

=item
Отключение от базы данных
=cut
sub _DisconnectDB {
    my $self = shift;

    if ($self->IsConnect() eq 'yes') {
        $self->{_DBH}->disconnect();
        $self->{_DBH} = '';
    }
}

sub GetMysqlTableName {
    my $self = shift;

    return $self->{_MYSQL_TABLE_NAME};
}

sub DESTROY {
    my $self = shift;
    $self->_DisconnectDB();
}

return 1;
