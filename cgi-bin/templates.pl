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

<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
<meta name="robots" content="INDEX,FOLLOW">
<meta name="revisit-after" content="1 days">
<meta name="description" content="$META_DESCRIPTION">
<meta name="keywords" content="$META_KEYWORDS">
    };

    return $ReturnText;
}

sub TemplateCSS {
    my $TemplateNumber = shift;
    my $ReturnText = '';

    $ReturnText .= q{
    <link href="/css/bootstrap.min.css" rel="stylesheet">

    <style>
      .bd-placeholder-img {
        font-size: 1.125rem;
        text-anchor: middle;
        -webkit-user-select: none;
        -moz-user-select: none;
        -ms-user-select: none;
        user-select: none;
      }

      @media (min-width: 768px) {
        .bd-placeholder-img-lg {
          font-size: 3.5rem;
        }
      }
    </style>

    <link href="/css/jumbotron.css" rel="stylesheet">
    };

    return $ReturnText;
}

sub TemplateJS {
    my $ReturnText = '';

    $ReturnText .= qq{
    <script src="/js/jquery-3.7.1.min.js"></script>
    <script type='text/javascript' src='/js/design.js'></script>
    <script src="/js/bootstrap.bundle.min.js"></script>
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
</head>

<body>
    };

    # TODO - $TemplateNumber not used now
    $ReturnText .= qq {
    <nav class="navbar navbar-expand-md navbar-dark fixed-top bg-dark">
        <a class="navbar-brand" href="#">Navbar</a>
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExampleDefault" aria-controls="navbarsExampleDefault" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse" id="navbarsExampleDefault">
    };

    $ReturnText .= &TemplateUpMenu;

    $ReturnText .= qq {
        </div>
    </nav>

    <main role="main">
        <div class="jumbotron">
            <div class="container">
    };

    return $ReturnText;
}

sub TemplateMainFooter {
    my $TemplateNumber = shift;

    my $ReturnText .= qq{
            </div>
        </div>
    </main>

    <footer class="container">
        <p>&copy; izemskov.ru 2024</p>
    </footer>
    };

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
<ul class="navbar-nav mr-auto">
    };

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName.qq{text_content WHERE parent_id='0' ORDER BY order_content});
    while (my $Content = $sth->fetchrow_hashref()) {
        my $Link = '';
        if ($Content->{symbol_link} ne '') {
            $Link = "/content/$Content->{symbol_link}/";
        }
        else {
            $Link = "/content/$Content->{id}.html";
        }

        $ReturnText .= qq{
    <li class="nav-item active">
        <a class="nav-link" href="$Link">$LANGUAGES_HASH{$Content->{name}}</a>
    </li>
        };
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

