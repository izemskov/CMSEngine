use strict;

our $VERSION;
our $DWFilter;
our $DWDB;
our $MAIN_LINK;
our $TOKEN_LINK_FIRST_PARAM;
our $ACCESS;
our $USER;
our $TOKEN_LINK_LAST_PARAM;

sub TemplateTitle {
    my $ReturnText = '';

    $ReturnText .= qq{
    <meta http-equiv="content-type" content="text/html; charset=utf-8">
    <title>CMS Phoenix Engine v.$VERSION</title>
    };

    return $ReturnText;
}

sub TemplateCSS {
    my $ReturnText = '';

    $ReturnText .= qq{
    <link rel="stylesheet" type="text/css" href="/css/administration/style_v3.css?v=1">
    };

    return $ReturnText;
}

sub TemplateJS {
    my $ReturnText = '';

    $ReturnText .= qq{
    <script type='text/javascript' src='/js/administration/jquery-1.9.0.min.js'></script>
    <script type='text/javascript' src='/js/administration/design_v2.js'></script>
    <script type='text/javascript' src='/js/administration/editor.js'></script>
    };

    return $ReturnText;
}

sub TemplateMainHeader {
    my $ReturnText = '';

    $ReturnText .= qq{
<html>
<head>
    };

    $ReturnText .= &TemplateTitle;
    $ReturnText .= &TemplateCSS;

    $ReturnText .= qq{
<body>
    <div id='header'></div>

    <div id='main'>
        <div id='main_header'>
            <div id='main_logo'><a href='$MAIN_LINK$TOKEN_LINK_FIRST_PARAM'><img src='/img/administration/logo.gif'></a></div>
    };

    if (($ACCESS ne 'no') && ($USER ne '')) {
        $ReturnText .= &TemplateMainMenu;
    }

    $ReturnText .= qq{
        </div>

        <div id='main_content'>
    };

    return $ReturnText;
}

sub TemplateMainFooter {
    my $ReturnText = '';

    $ReturnText .= qq{
        </div>
    </div>
    };

    if ($USER ne '') {
        $ReturnText .= qq{
    <div id='main_footer'>

        <div id='main_footer_lastlogin'>
        };

        $ReturnText .= &GetFooterInfo;

        $ReturnText .= qq{
        </div>

        <div id='main_footer_copyright'>
            CMS Phoenix Engine v.$VERSION<br>
            Студия веб-программирования <a href='http://www.develweb.ru' target='_blank'>DevelWeb</a>
        </div>

    </div>
        };
    }

    $ReturnText .= qq{
    <div id='footer'></div>
    };

    $ReturnText .= &TemplateJS;

    $ReturnText .= qq{
</body>
</html>
    };

    return $ReturnText;
}

sub TemplateLoginForm {
    my $ReturnText = '';
    my $MD5 = shift;

    my ($sec, $min, $hour, $day, $month, $year) = &GetDataTime(time);

    if ($MD5 ne '') {
        $ReturnText .= qq{
<div id='login_window'>
    <div id='login_header'>
        <div id='login_header_text'>
            Авторизация
        </div>
    </div>

    <div class='main_content_info_table'>
        <div id='login_logo'>
            <img src='/img/administration/logo_develweb.gif' width='250'>
        </div>

        <div id='login_form'>
            <form action='#' method='POST'>
            <input type='hidden' name='action' value='login'>
            <input type='hidden' name='md5' value='$MD5'>
            <div id='login_login_text'>
                Логин
            </div>
            <div class='login_login_field'>
                <input type='text' name='login' class='login_login_field'>
            </div>

            <div id='login_pass_text'>
                Пароль
            </div>
            <div class='login_pass_field'>
                <input type='password' name='pass' class='login_login_field'>
            </div>

            <div id='login_captcha_text'>
                Код с картинки
            </div>
            <div id='login_captcha_img'>
                <img src='/cgi-bin/scripts/captcha.pl?md5=$MD5'>
            </div>
            <div class='login_captcha_field'>
                <input type='text' name='captcha' class='login_captcha_field'>
            </div>

            <div class='login_submit'>
                <input type='submit' value='Войти' class='login_submit'>
            </div>
            </form>

            <div id='login_info'>
                CMS Phoenix Engine<br>
                (c) <a href='http://develweb.ru' target='_blank'>Develweb</a> 2008-$year
            </div>
        </div>
    </div>
</div>
        };
    }

    return $ReturnText;
}

sub TemplateMainMenu {
    my $ReturnText = '';

    if ($USER ne '') {
        $ReturnText .= qq{
<div id='main_menu'>
        };

        my @ModulAccess = ();
        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT modul_id FROM }.$DWDB->GetMysqlTableName().qq{cms_access WHERE uid=?}, $USER->{id});
        while (my $Content = $sth->fetchrow_hashref()) {
            push @ModulAccess, $Content->{modul_id};
        }
        $sth->finish();

        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().qq{cms_struct WHERE parent_id='0' ORDER BY order_content, name});
        while (my $Content = $sth->fetchrow_hashref()) {
            my $SubMenuText = '';
            my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().qq{cms_struct WHERE parent_id='$Content->{id}' ORDER BY order_content, name});
            while (my $SubContent = $sth->fetchrow_hashref()) {
                if (&ExistInArray($SubContent->{id}, @ModulAccess)) {
                    $SubMenuText .= qq{
    <div class='main_menu_sub_item_text'><a href='$MAIN_LINK?mod=$SubContent->{modul}&sub=$SubContent->{sub_modul}$TOKEN_LINK_LAST_PARAM' class='main_menu_sub_item_text'>$SubContent->{name}</a></div>
                    };
                }
            }
            $sth->finish();

            if ($SubMenuText ne '') {
                $ReturnText .= qq{
    <div class='main_menu_item'>
        <a href='#' class='main_menu_text'>$Content->{name}</a>
        <div class='main_menu_sub_item'>
            $SubMenuText
        </div>
    </div>
                };
            }
        }
        $sth->finish();

        $ReturnText .= qq{
    <div class='main_menu_item'>
        <a href='$MAIN_LINK?mod=logout$TOKEN_LINK_LAST_PARAM' class='main_menu_text_nojs'>Выход</a>
    </div>
        };

        $ReturnText .= qq{
</div>
        };
    }

    return $ReturnText;
}

sub GetFooterInfo {
    my $ReturnText = '';

    my ($sec, $min, $hour, $day, $month, $year) = &GetDataTime(time);

    $ReturnText .= qq{
    Текущая дата и время: $day.$month.$year $hour:$min<br>
    };

    my $user_session = $DWFilter->GetCookieFilterLatinDiget("admin_session");

    my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT
    cms_users.login,
    cms_sessions_log.login_time
FROM
    }.$DWDB->GetMysqlTableName().qq{cms_sessions_log AS cms_sessions_log,
    }.$DWDB->GetMysqlTableName().qq{cms_users AS cms_users
WHERE
    cms_sessions_log.uid=cms_users.id
ORDER BY
    cms_sessions_log.login_time DESC
LIMIT
    2
    });
    my $Content = $sth->fetchrow_hashref();
    $Content = $sth->fetchrow_hashref();
    $sth->finish();

    if (($Content->{login} ne '') && ($Content->{login_time} ne '')) {
        my ($sec, $min, $hour, $day, $month, $year) = &GetDataTime($Content->{login_time});
        $ReturnText .= qq{
    Дата и время предыдущего использования CMS: $day.$month.$year $hour:$min пользователем $Content->{login}
        };
    }

    return $ReturnText;
}

1;
