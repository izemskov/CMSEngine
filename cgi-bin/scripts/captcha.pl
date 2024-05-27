#!/usr/bin/perl

use GD;
use strict;
use lib "/home/ilya/www/izemskov.ru/cgi-bin/modules";
use DWDataBase;
use DWFilter;
use DWErrors;

# Создаем класс отслеживающий ошибки
our $DWErrors = DWErrors->new('no', '', '');

# Подключаемся к базе данных
our $DWDB = DWDataBase->new($DWErrors);

# Подключение фильтрации пользовательских данных
our $DWFilter = DWFilter->new();

our $ImageWidth = 100;
our $ImageHeight = 25;

&Generate;

sub Generate {
    # Создаем новое изображение
    my $im = new GD::Image($ImageWidth, $ImageHeight);

    # Определяем цвета
    my $white = $im->colorAllocate(255, 255, 255);
    my $black = $im->colorAllocate(0, 0, 0);
    my $red = $im->colorAllocate(255, 0, 0);
    my $blue = $im->colorAllocate(0, 0, 255);
    my $green = $im->colorAllocate(60, 225, 22);

    $im->transparent($white);
    $im->interlaced('true');

    # Рисуем рамку
    $im->rectangle(0, 0, $ImageWidth - 1, $ImageHeight - 1, $black);

    my $md5 = $DWFilter->GetParamFilterLatinDiget("md5");
    my ($str) = $DWDB->QuerySelectRowDB(qq{SELECT string FROM }.$DWDB->GetMysqlTableName.qq{captcha WHERE md5=?}, $md5);

    my @str = split(//, $str);

    my $x = 7;
    my $y = 5;
    my $i = 0;
    foreach my $value (@str) {
        my $color = '';
        if ($i % 3 == 0) {
            $color = $green;
        }
        elsif ($i % 3 == 1) {
            $color = $red;
        }
        else {
            $color = $blue;
        }

        $im->string(GD::Font->Giant, $x, $y, $value, $color);
        $x = $x + 15;

        $i++;
    }

    print "Content-type: image/png\n\n";
    binmode STDOUT;
    print STDOUT $im->png;

    undef $im;
}

undef $DWFilter;
undef $DWDB;
undef $DWErrors;
