use strict;

our $MOD;
our $DWDB;
our $DWFilter;
our $MAIN_NAME;
our %LANGUAGES_HASH;
our $META_TITLE;
our $META_DESCRIPTION;
our $META_KEYWORDS;
our $HTDOCS_PATH;
our %CMS_SETTINGS;
our %SITE_SETTINGS;
our $ACCESS;

sub TemplateTitle {
    my $ReturnText = '';

    $ReturnText .= qq{
<meta charset="utf-8">

<title>$META_TITLE</title>

<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="robots" content="INDEX,FOLLOW">
<meta name="revisit-after" content="1 days">
<meta name="description" content="$META_DESCRIPTION">
<meta name="keywords" content="$META_KEYWORDS">
<meta name="author" content="">
    };

    return $ReturnText;
}

sub TemplateCSS {
    my $TemplateNumber = shift;
    my $ReturnText = '';

    $ReturnText .= qq{
    <!-- Le styles -->
    <link href="/css/bootstrap.css" rel="stylesheet">
    };

    if ($TemplateNumber == 1) {
        $ReturnText .= qq{
    <style type="text/css">
        body {
            padding-top: 60px;
            padding-bottom: 40px;
        }
    </style>
        };
    }
    elsif ($TemplateNumber == 2) {
        $ReturnText .= qq{
    <style type="text/css">
        body {
            padding-top: 60px;
            padding-bottom: 40px;
        }
        .sidebar-nav {
            padding: 9px 0;
        }
    </style>
        };
    }
    else {
        $ReturnText .= qq{
    <style type="text/css">
        body {
            padding-top: 40px;
            padding-bottom: 40px;
            background-color: #f5f5f5;
        }

        .form-signin {
            max-width: 300px;
            padding: 19px 29px 29px;
            margin: 0 auto 20px;
            background-color: #fff;
            border: 1px solid #e5e5e5;
                -webkit-border-radius: 5px;
                    -moz-border-radius: 5px;
            border-radius: 5px;
                -webkit-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                    -moz-box-shadow: 0 1px 2px rgba(0,0,0,.05);
                        box-shadow: 0 1px 2px rgba(0,0,0,.05);
        }
        .form-signin .form-signin-heading,
        .form-signin .checkbox {
            margin-bottom: 10px;
        }
        .form-signin input[type="text"],
        .form-signin input[type="password"] {
            font-size: 16px;
            height: auto;
            margin-bottom: 15px;
            padding: 7px 9px;
        }
    </style>
        };
    }

    $ReturnText .= qq{
    <link href="/css/bootstrap-responsive.css" rel="stylesheet">
    <link rel="stylesheet" type="text/css" href="/css/jquery.fancybox.css">
    };

    return $ReturnText;
}

sub TemplateJS {
    my $ReturnText = '';

    $ReturnText .= qq{
    <script src="/js/jquery-1.9.0.min.js"></script>
    <!-- Le javascript
    ================================================== -->
    <!-- Placed at the end of the document so the pages load faster -->
    <script src="/js/bootstrap-modal.js"></script>
    <script type='text/javascript' src='/js/jquery.fancybox.js'></script>
    <script type='text/javascript' src='/js/design.js'></script>
    };

    return $ReturnText;
}

sub TemplateMainHeader {
    my $PathString = shift;
    my $TemplateNumber = shift;

    if ($TemplateNumber eq '') {
        $TemplateNumber = 1;
    }

    my $ReturnText = '';

    $ReturnText .= qq{
<html>
<head>
    };

    $ReturnText .= &TemplateTitle;
    $ReturnText .= &TemplateCSS($TemplateNumber);

$ReturnText .= qq{
    <!-- HTML5 shim, for IE6-8 support of HTML5 elements -->
    <!--[if lt IE 9]>
        <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
    <![endif]-->
</head>

<body>
    };

    if ($TemplateNumber == 1) {
        $ReturnText .= qq {
<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
        <div class="container">
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            </a>
            <a class="brand" href="/">CMS</a>
            <div class="nav-collapse collapse">
        };

        $ReturnText .= &TemplateUpMenu;

        $ReturnText .= qq {
                <form class="navbar-form pull-right" action='/cgi-bin/main.pl'>
                    <input type='hidden' name='mod' value='catalog'>
                    <input class="span2" type="text" placeholder="Поиск">
                    <button type="submit" class="btn">Найти</button>
                </form>
            </div><!--/.nav-collapse -->
        </div>
    </div>
</div>

    <div class="container">
        <div class="hero-unit">
        };
    }
    elsif ($TemplateNumber == 2) {
        $ReturnText .= qq {
<div class="navbar navbar-inverse navbar-fixed-top">
    <div class="navbar-inner">
        <div class="container">
            <a class="btn btn-navbar" data-toggle="collapse" data-target=".nav-collapse">
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            </a>
            <a class="brand" href="/">CMS</a>
            <div class="nav-collapse collapse">
        };

        $ReturnText .= &TemplateUpMenu;

        $ReturnText .= qq {
                <form class="navbar-form pull-right" action='/cgi-bin/main.pl'>
                    <input type='hidden' name='mod' value='catalog'>
                    <input class="span2" type="text" placeholder="Поиск">
                    <button type="submit" class="btn">Найти</button>
                </form>
            </div><!--/.nav-collapse -->
        </div>
    </div>
</div>

    <div class="container">
        };
    }

    return $ReturnText;
}

sub TemplateMainFooter {
    my $TemplateNumber = shift;

    if ($TemplateNumber eq '') {
        $TemplateNumber = 1;
    }

    my $ReturnText = '';

    if ($TemplateNumber == 1) {
        $ReturnText .= qq{
    </div>
        };

        if ($MOD eq 'index') {
            $ReturnText .= TemplateShowCase(" ORDER BY order_content LIMIT 3 ");

            my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName.qq{text_catalog_items});
            if ($Count > 3) {
                $ReturnText .= qq{<br><a class="btn" href="/catalog/">Посмотреть весь каталог</a>};
            }
        }
        elsif ($MOD eq 'content') {
            # Check main page
            my $SymbolLink = $DWFilter->GetParamFilterLatinDigetDash("symbol_link");
            my $ContentID = $DWFilter->GetParamFilterDiget("content_id", 5);

            # Get symbol link && id main page
            my ($ContentIDDB, $SymbolLinkDB) = $DWDB->QuerySelectRowDB(qq{SELECT id, symbol_link FROM }.$DWDB->GetMysqlTableName.qq{text_content ORDER BY order_content LIMIT 1});

            if ($SymbolLink eq $SymbolLinkDB || $ContentID == $ContentIDDB ) {
                $ReturnText .= &TemplateShowCase(" ORDER BY order_content LIMIT 3 ");

                my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName.qq{text_catalog_items});
                if ($Count > 3) {
                    $ReturnText .= qq{<br><a class="btn" href="/catalog/">Посмотреть весь каталог</a>};
                }
            }
        }

        $ReturnText .= qq{
    <hr>

    <footer>
        <p>&copy; $LANGUAGES_HASH{$SITE_SETTINGS{copyright_text}}</p>
    </footer>

    </div> <!-- /container -->
        };
    }
    elsif ($TemplateNumber == 2) {
        $ReturnText .= qq{
    <hr>

    <footer>
        <p>&copy; $LANGUAGES_HASH{$SITE_SETTINGS{copyright_text}}</p>
    </footer>

    </div> <!-- /container -->
        };
    }

    $ReturnText .= &TemplateJS();

    $ReturnText .= qq{
</body>
</html>
    };

    return $ReturnText;
}

sub TemplateUpMenu {
    my $ReturnText = '';

    $ReturnText .= qq{
<ul class="nav">
    };

    my $i = 0;
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName.qq{text_content WHERE parent_id='0' ORDER BY order_content});
    while (my $Content = $sth->fetchrow_hashref()) {
        if ($i == 1) {
            $ReturnText .= qq{
    <li><a href="/catalog/">Каталог</a></li>
            };

            $i = $i + 2;
        }

        my $Link = '';
        if ($Content->{symbol_link} ne '') {
            $Link = "/content/$Content->{symbol_link}/";
        }
        else {
            $Link = "/content/$Content->{id}.html";
        }

        $ReturnText .= qq{
    <li><a href="$Link">$LANGUAGES_HASH{$Content->{name}}</a></li>
        };

        $i++;
    }
    $sth->finish();

    $ReturnText .= qq{
</ul>
    };

    return $ReturnText;
}

sub TemplateShowCase {
    my $sql = shift;

    my $ReturnText = '';

    my $i = 0;
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName.qq{text_catalog_items $sql});
    while (my $Content = $sth->fetchrow_hashref()) {
        if ($i % 3 == 0) {
            $ReturnText .= qq{
<div class="row">
            };
        }

        $ReturnText .= qq{
<div class="span4">
    <h2>$LANGUAGES_HASH{$Content->{name}}</h2>
        };

        if ($Content->{filename} ne '' && -e "$HTDOCS_PATH/files/items/small/$Content->{filename}") {
            $ReturnText .= qq{
    <p><center><a href='/catalog/$Content->{id}.html'><img src='/files/items/small/$Content->{filename}'></a></center></p>
            };
        }

        $ReturnText .= qq{
    <p>}.&DecodeEditorText($LANGUAGES_HASH{$Content->{small_description}}).qq{</p>
    <p><a class="btn" href="/catalog/$Content->{id}.html">Подробнее &raquo;</a></p>
</div>
        };

        $i++;

        if ($i % 3 == 0) {
            $ReturnText .= qq{
</div>
            };
        }
    }
    $sth->finish();

    if ($i % 3 != 0) {
        $ReturnText .= qq{
</div>
        };
    }

    return $ReturnText;
}

1;

