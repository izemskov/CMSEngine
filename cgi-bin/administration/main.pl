#!/usr/bin/perl

use strict;
use lib "/home/ilya/www/izemskov.ru/cgi-bin/modules";
use DWDataBase;
use DWErrors;
use DWFilter;

# Инициализация переменных
our $CGIBIN_PATH = '';
our $HTDOCS_PATH = '';
our $CGIBIN_REL_PATH = '';
our $LOG_PATH = '';
our $SALT = '';

# Получаем пути для сайта
require "paths.pl";

=item
no - не выводить ошибки
yes - вывод ошибок в браузер
file - вывод ошибок в файл
=cut
# Создаем класс отслеживающий ошибки
our $DWErrors = DWErrors->new('yes', $LOG_PATH, \&EndScript);
if ($DWErrors->GetPrintError() eq 'yes') {
    use CGI::Carp qw(fatalsToBrowser);
}

# Подключаемся к базе данных
our $DWDB = DWDataBase->new($DWErrors);

# Подключение фильтрации пользовательских данных
our $DWFilter = DWFilter->new();

our $VERSION = '3.2';

=item
no - нет доступа
nomod - нет запрашиваемого модуля
noaccess - нет доступа в запрашиваемый модуль
notoken - нет идентификатора передающегося через HTTP
yes - авторизация пройдена
=cut
our $ACCESS = 'no';
our $ACCESS_LEVEL = '';
our $USER = '';
our $TOKEN = '';

our $MAIN_LINK = "$CGIBIN_REL_PATH/main.pl";
our $TOKEN_LINK = '';
our $TOKEN_LINK_FIRST_PARAM = '';
our $TOKEN_LINK_LAST_PARAM = '';

our %LANGUAGES = ();
our %SITE_SETTINGS = ();
our %CMS_SETTINGS = ();

our $WATERMARK = "izemskov.ru";
our $WATERMARK_COLOR = '#6c7fa6';

# Подключение функциональных модулей
require "templates.pl";
require "functions.pl";
require "core.pl";
require "languages.pl";
require "editor.pl";

our $MOD = $DWFilter->GetParamFilterLatinDiget("mod");
our $SUB = $DWFilter->GetParamFilterLatinDiget("sub");

$DWDB->SetStopScript('yes');
require "access.pl";
$DWDB->SetStopScript('no');

print qq{<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">};

&CreateTokenLink;
&GetCMSSettings;
&GetSiteSettings;

if (($ACCESS eq 'nomod') && ($MOD eq 'logout')) {
    &Logout;
    &EndScript;
    exit;
}

if ($ACCESS eq "yes") {
    require "$CGIBIN_PATH/$MOD/core.pl";
}
else {
    if ($ACCESS eq 'no') {
        my $action = $DWFilter->GetParamFilterLatinDigetDash("action");

        if ($action eq 'login') {
            &Login;

            &CreateTokenLink;
        }
    }

    require "index.pl";
}

&EndScript;

sub EndScript {
    undef $DWFilter;
    undef $DWDB;
    undef $DWErrors;
}

sub CreateTokenLink {
    if ($TOKEN ne '') {
        $TOKEN_LINK = "token=$TOKEN";
        $TOKEN_LINK_FIRST_PARAM = "?$TOKEN_LINK";
        $TOKEN_LINK_LAST_PARAM = "&$TOKEN_LINK";
    }
}

sub GetSiteSettings {
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT translitname, value FROM }.$DWDB->GetMysqlTableName().qq{settings});
    while (my $Content = $sth->fetchrow_hashref()) {
        $SITE_SETTINGS{$Content->{translitname}} = $Content->{value};
    }
    $sth->finish();
}

sub GetCMSSettings {
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT translitname, value FROM }.$DWDB->GetMysqlTableName().qq{cms_settings});
    while (my $Content = $sth->fetchrow_hashref()) {
        $CMS_SETTINGS{$Content->{translitname}} = $Content->{value};
    }
    $sth->finish();
}
