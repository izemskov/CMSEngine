use strict;

our $DWFilter;
our $DWDB;
our %LANGUAGES_HASH;
our $META_TITLE;
our $META_DESCRIPTION;
our $META_KEYWORDS;
our $MAIN_NAME;

my $SymbolLink = $DWFilter->GetParamFilterLatinDigetDash("symbol_link");
my $ContentID = $DWFilter->GetParamFilterDiget("content_id", 5);

if (($ContentID eq '') && ($SymbolLink eq '')) {
    ($ContentID) = $DWDB->QuerySelectRowDB(qq{SELECT id FROM }.$DWDB->GetMysqlTableName.qq{text_content WHERE parent_id='0' ORDER BY order_content LIMIT 1});
}

if (($ContentID ne '') || ($SymbolLink ne '')) {
    my $sth = '';
    if ($SymbolLink ne "") {
        $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName.qq{text_content WHERE symbol_link=?}, $SymbolLink);
    }
    else {
        $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName.qq{text_content WHERE id=?}, $ContentID);
    }
    my $Content = $sth->fetchrow_hashref();
    $sth->finish();

    if ($Content->{name} eq '') {
        &ErrorDocument;
    }
    else {
        if($Content->{fullname} eq "") {
            $Content->{fullname} = $Content->{name};
        }

        $Content->{name} = $LANGUAGES_HASH{$Content->{name}};
        $Content->{fullname} = $LANGUAGES_HASH{$Content->{fullname}};
        $Content->{content} = $LANGUAGES_HASH{$Content->{content}};

        if ($Content->{meta_title} ne '') {
            if ($LANGUAGES_HASH{$Content->{meta_title}} ne '') {
                $META_TITLE = $LANGUAGES_HASH{$Content->{meta_title}};
            }
        }
        if ($Content->{meta_description} ne '') {
            if ($LANGUAGES_HASH{$Content->{meta_description}} ne '') {
                $META_DESCRIPTION = $LANGUAGES_HASH{$Content->{meta_description}};
            }
        }
        if ($Content->{meta_keywords} ne '') {
            if ($LANGUAGES_HASH{$Content->{meta_keywords}} ne '') {
                $META_KEYWORDS = $LANGUAGES_HASH{$Content->{meta_keywords}};
            }
        }

        print &TemplateMainHeader("", 1);
        print &Content($Content);
        print &TemplateMainFooter(1);
    }
}
else {
    &ErrorDocument;
}

sub Content {
    my $Content = shift;

    my $ReturnText = '';

    $ReturnText .= qq{
<h1>$Content->{fullname}</h1>
    };

    my $SubContentText = '';
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName.qq{text_content WHERE parent_id='$Content->{id}' ORDER BY order_content, id});
    while (my $SubContent = $sth->fetchrow_hashref()) {
        my $Link = '';
        if ($SubContent->{symbol_link} ne '') {
            $Link = "/content/$SubContent->{symbol_link}/";
        }
        else {
            $Link = "/content/$SubContent->{id}.html";
        }

        $SubContentText .= qq{
        <li><a href='$Link'>$LANGUAGES_HASH{$SubContent->{name}}</a></li>
        };
    }
    $sth->finish();

    if ($SubContentText ne '') {
        $ReturnText .= qq{
<ul>
$SubContentText
</ul>
        };
    }

    $ReturnText .= qq{<br>};
    $ReturnText .= &DecodeEditorText($Content->{content});

    return $ReturnText;
}

1;
