use strict;

sub DecodeEditorText {
    my $text = shift;

    $text =~ s/\[br\]/<br>/ig;
    $text =~ s/\[img=(.*?) width=(.*?)\]/<img src=\'\/user_files\/images\/$1\' width=\'$2\'>/igs;
    $text =~ s/\[img=(.*?)\]/<img src=\'\/user_files\/images\/$1\'>/ig;
    $text =~ s/\[center\]/<center>/ig;
    $text =~ s/\[\/center\]/<\/center>/ig;

    # Table
    $text =~ s/\[table\]/<table cellpadding=\'3\' width=\'100\%\'>/ig;
    $text =~ s/\[table border=1\]/<table cellpadding=\'3\' width=\'100\%\' border='1'>/ig;
    $text =~ s/\[tr\]/<tr>/ig;
    $text =~ s/\[\/tr\]/<\/tr>/ig;
    $text =~ s/\[td colspan=(\d+)\]/<td valign=\'top\' colspan=\'$1\'>/igs;
    $text =~ s/\[td width=(.*?)\]/<td width=\'$1\' valign=\'top\'>/ig;
    $text =~ s/\[td\]/<td valign=\'top\'>/ig;
    $text =~ s/\[\/td\]/<\/td>/ig;
    $text =~ s/\[\/table\]/<\/table>/ig;

    # Headers
    $text =~ s/\[h2\]/<h2>/ig;
    $text =~ s/\[\/h2\]/<\/h2>/ig;

    # Div
    $text =~ s/\[div class=(.*?)\]/<div class=\'$1\'>/igs;
    $text =~ s/\[div\]/<div>/ig;
    $text =~ s/\[\/div\]/<\/div>/ig;

    # UL LI
    $text =~ s/\[ul\]/<ul>/ig;
    $text =~ s/\[\/ul\]/<\/ul>/ig;
    $text =~ s/\[li\]/<li>/ig;
    $text =~ s/\[\/li\]/<\/li>/ig;

    # Link
    $text =~ s/\[a href=(.*?)\]/<a href=\'$1\'>/igs;
    $text =~ s/\[a class=(.*?) href=(.*?)\]/<a class=\'$1\' href=\'$2\'>/igs;
    $text =~ s/\[\/a\]/<\/a>/ig;

    # Strong
    $text =~ s/\[b\]/<b>/ig;
    $text =~ s/\[\/b\]/<\/b>/ig;

    # Video
    $text =~ s/\[video src=(.*?) width=(.*?) height=(.*?)\]/<iframe title=\"YouTube video player\" width=\"$2\" height=\"$3\" src=\"http\:\/\/www.youtube.com$1\" frameborder=\"0\" allowfullscreen style=\"display: block; z-index: -1;margin: auto;\"><\/iframe>/igs;

    $text =~ s/\[btn href=(.*?)\]/<a class=\"btn btn-large btn-primary\" href=\"$1\">Играть OnLine<\/a>/igs;

    my $iframe = qq{<iframe frameborder="0" allowtransparency="true" scrolling="no" src="https://money.yandex.ru/embed/small.xml?account=41001617439814&quickpay=small&yamoney-payment-type=on&button-text=03&button-size=l&button-color=black&targets=%D0%9F%D0%BE%D0%BC%D0%BE%D1%89%D1%8C+%D0%BF%D1%80%D0%BE%D0%B5%D0%BA%D1%82%D1%83&default-sum=10&successURL=" width="242" height="54"></iframe>};
    $text =~ s/\[donate\]/$iframe/igs;

    return $text;
}

1;

