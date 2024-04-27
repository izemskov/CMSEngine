#!/usr/bin/perl

print "Content-type: text/html\n\n";

use strict;
use lib "/home/ilya/www/izemskov.ru/cgi-bin/modules";
use DWDataBase;
use DWErrors;

# Создаем класс отслеживающий ошибки
our $DWErrors = DWErrors->new('no', '', '');

# Подключаемся к базе данных
our $DWDB = DWDataBase->new($DWErrors);

our $CLEAR_CAPTCHA_TIME = 30 * 60;
our $CLEAR_SESSION_TIME = 15 * 60;
our $CLEAR_AUTH_SESSION_TIME = 600 * 60;
our $CLEAR_SESSION_LOG_TIME = 365 * 24 * 60 * 60;

&ClearCaptcha;
&ClearSession;
&ClearSessionLog;

sub ClearCaptcha {
    my $ClearTime = time;
    $ClearTime = $ClearTime - $CLEAR_CAPTCHA_TIME;

    $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().qq{captcha WHERE create_time < $ClearTime});
}

sub ClearSession {
    my $ClearTime = time;
    $ClearTime = $ClearTime - $CLEAR_SESSION_TIME;

    my $ClearAuthTime = time;
    $ClearAuthTime = $ClearAuthTime - $CLEAR_AUTH_SESSION_TIME;

    $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().qq{cms_sessions WHERE sess_time < $ClearTime});
    # TODO
    #$DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().qq{auth_sessions WHERE sess_time < $ClearAuthTime});
}

sub ClearSessionLog {
    my $ClearTime = time;
    $ClearTime = $ClearTime - $CLEAR_SESSION_LOG_TIME;

    $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().qq{cms_sessions_log WHERE login_time < $ClearTime});
}

undef $DWDB;
undef $DWErrors;
