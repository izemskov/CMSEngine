#!/usr/bin/perl

use strict;
use lib "/home/ilya/www/izemskov.ru/cgi-bin/modules";
use DWDataBase;
use DWErrors;
use DWFilter;

print "Content-type: text/html\n\n";

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
our $DWErrors = DWErrors->new('file', $LOG_PATH, \&EndScript);
if ($DWErrors->GetPrintError() eq 'yes') {
    use CGI::Carp qw(fatalsToBrowser);
}

# Подключаемся к базе данных
our $DWDB = DWDataBase->new($DWErrors);

# Подключение фильтрации пользовательских данных
our $DWFilter = DWFilter->new();

our $LANGUAGE_ID = '';
our %LANGUAGES_HASH = ();

our $MAIN_LINK = "$CGIBIN_REL_PATH/main.pl";

our %SITE_SETTINGS = ();
our %CMS_SETTINGS = ();

our $META_TITLE = '';
our $META_DESCRIPTION = '';
our $META_KEYWORDS = '';

our $MAIN_NAME = '';

our $MOD = $DWFilter->GetParamFilterLatinDiget("mod");
my $UID = $DWFilter->GetParamFilterDiget("uid");

# Подключение функциональных модулей
require "templates.pl";
require "functions.pl";
require "languages.pl";
require "editor.pl";

&GetSiteSettings;
&GetCMSSettings;
&DefaultModulMetaTag;
&GetMainName;

if ($MOD eq 'content') {
    require "content.pl";
}
elsif ($MOD eq 'catalog') {
    require "catalog.pl";
}
else {
    $MOD = 'index';
    require "index.pl";
}

&EndScript;

sub ErrorDocument {
    print &TemplateMainHeader;
    print qq{<div id='main_content'>К сожалению, запрашиваемая страница не найдена. Перейти на <a href='/'>главную</a></div>};
    print &TemplateMainFooter;
}

sub EndScript {
    undef $DWFilter;
    undef $DWDB;
    undef $DWErrors;
}

sub GetSiteSettings {
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT translitname, value FROM }.$DWDB->GetMysqlTableName.qq{settings});
    while (my $Content = $sth->fetchrow_hashref()) {
        $SITE_SETTINGS{$Content->{translitname}} = $Content->{value};
    }
    $sth->finish();
}

sub GetCMSSettings {
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT translitname, value FROM }.$DWDB->GetMysqlTableName.qq{cms_settings});
    while (my $Content = $sth->fetchrow_hashref()) {
        $CMS_SETTINGS{$Content->{translitname}} = $Content->{value};
    }
    $sth->finish();
}

sub DefaultModulMetaTag {
    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName.qq{seo_titles WHERE translitname=?}, $MOD);

    if ($Count > 0) {
        ($META_TITLE, $META_DESCRIPTION, $META_KEYWORDS) = $DWDB->QuerySelectRowDB(qq{
SELECT
    meta_title, meta_description, meta_keywords
FROM
    }.$DWDB->GetMysqlTableName.qq{seo_titles
WHERE
    translitname=?
        }, $MOD);
    }
    else {
        ($META_TITLE, $META_DESCRIPTION, $META_KEYWORDS) = $DWDB->QuerySelectRowDB(qq{
SELECT
    meta_title, meta_description, meta_keywords
FROM
    }.$DWDB->GetMysqlTableName.qq{seo_titles
WHERE
    translitname='default'
        });
    }

    if ($META_TITLE ne '') {
        $META_TITLE = $LANGUAGES_HASH{$META_TITLE};
    }
    if ($META_DESCRIPTION ne '') {
        $META_DESCRIPTION = $LANGUAGES_HASH{$META_DESCRIPTION};
    }
    if ($META_KEYWORDS ne '') {
        $META_KEYWORDS = $LANGUAGES_HASH{$META_KEYWORDS};
    }
}

sub GetMainName {
    ($MAIN_NAME) = $DWDB->QuerySelectRowDB(qq{SELECT name FROM }.$DWDB->GetMysqlTableName.qq{text_content WHERE parent_id='0' ORDER BY order_content LIMIT 1});

    if ($MAIN_NAME ne '') {
        $MAIN_NAME = $LANGUAGES_HASH{$MAIN_NAME};
    }

    if ($MAIN_NAME eq '') {
        $MAIN_NAME = "Главная";
    }
}
