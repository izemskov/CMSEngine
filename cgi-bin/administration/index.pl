use strict;

our %CMS_SETTINGS;

our $DWDB;
our $ACCESS;
our $MAIN_LINK;
our $TOKEN_LINK_FIRST_PARAM;
our $TOKEN_LINK_LAST_PARAM;
our $MOD;
our $USER;
our $HTDOCS_PATH;

print &TemplateMainHeader;

if ($ACCESS eq 'noaccess') {
    print qq{Доступ в данный модуль запрещен. Вернутся на <a href='$MAIN_LINK$TOKEN_LINK_FIRST_PARAM'>главную</a>};
}
elsif ($ACCESS eq 'notoken') {
    print qq{Не задан корректный идентификационный токен};
}
elsif (($ACCESS eq 'nomod') && ($MOD ne '')) {
    print qq{Запрашиваемый модуль не существует. Вернутся на <a href='$MAIN_LINK$TOKEN_LINK_FIRST_PARAM'>главную</a>};
}
elsif ((($ACCESS eq 'nomod') && ($MOD eq '')) || ($ACCESS eq 'yes')) {
    print &ModulIconMenu;
}
else {
    my $MD5 = &AntiSpam;
    print &TemplateLoginForm($MD5);
}

print &TemplateMainFooter;

sub ModulIconMenu {
    my $ReturnText = '';

    my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT
    *
FROM
    }.$DWDB->GetMysqlTableName().qq{cms_struct
WHERE
    parent_id='0'
ORDER BY
    order_content
    });
    while (my $Content = $sth->fetchrow_hashref()) {

        my $SubContentText = '';
        my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT
    cms_struct.*
FROM
    }.$DWDB->GetMysqlTableName().qq{cms_struct AS cms_struct,
    }.$DWDB->GetMysqlTableName().qq{cms_access AS cms_access
WHERE
    cms_struct.parent_id='$Content->{id}' AND
    cms_access.modul_id=cms_struct.id AND
    cms_access.uid=$USER->{id}
ORDER BY
    cms_struct.order_content
        });
        my $i = 0;
        while (my $SubContent = $sth->fetchrow_hashref()) {
            if ($i % 3 == 0) {
                $SubContentText .= qq{
<div class='main_content_fast_ico'>
                };
            }

            $SubContentText .= qq{
    <div class='main_content_fast_ico_icons'>
            };

            if (($SubContent->{picture} ne '') && (-e "$HTDOCS_PATH/files/administration/moduls/small/$SubContent->{picture}")) {
                $SubContentText .= qq{
        <center><a href='$MAIN_LINK?mod=$SubContent->{modul}&sub=$SubContent->{sub_modul}$TOKEN_LINK_LAST_PARAM'><img src='/files/administration/moduls/small/$SubContent->{picture}'></a></center>
                };
            }

            $SubContentText .= qq{
        <a href='$MAIN_LINK?mod=$SubContent->{modul}&sub=$SubContent->{sub_modul}$TOKEN_LINK_LAST_PARAM' class='main_content_fast_ico_icons'>$SubContent->{name}</a>
    </div>
            };

            $i++;

            if ($i % 3 == 0) {
                $SubContentText .= qq{
</div>
                };
            }
        }
        $sth->finish();

        if (($SubContentText ne '') && ($i % 3 != 0)) {
            $SubContentText .= qq{
</div>
            };
        }

        if ($SubContentText ne '') {
            $ReturnText .= qq{
<div class='main_content_fast_ico_text'>
    $Content->{name}
</div>

$SubContentText
            };
        }
    }
    $sth->finish();


    return $ReturnText;
}

1;
