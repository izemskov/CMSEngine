use strict;

our $DWFilter;
our $DWDB;
our %LANGUAGES_HASH;
our $HTDOCS_PATH;
our $META_TITLE;
our $META_DESCRIPTION;
our $META_KEYWORDS;

my $ContentID = $DWFilter->GetParamFilterDiget("content_id", 5);

if ($ContentID eq '') {
    print &TemplateMainHeader('', 2);
    print &TemplateShowCase(' ORDER BY order_content ');
    print &TemplateMainFooter(2);
}
else {
    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName.qq{text_catalog_items WHERE id=?}, $ContentID);
    my $Content = $sth->fetchrow_hashref();
    $sth->finish();

    if ($Content->{name} eq '') {
        &ErrorDocument;
    }
    else {
        $Content->{name} = $LANGUAGES_HASH{$Content->{name}};
        $Content->{description} = $LANGUAGES_HASH{$Content->{description}};

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
        print &ShowItem($Content);
        print &TemplateMainFooter(1);
    }
}

sub ShowItem {
    my $Content = shift;

    my $ReturnText = '';

    $ReturnText .= qq{
<h1>$Content->{name}</h1>
<br>
<table cellpadding='0' cellspacing='0' border='0' width='100%'>
<tr>
    };

    if ($Content->{filename} ne '' && -e "$HTDOCS_PATH/files/items/big/$Content->{filename}") {
        $ReturnText .= qq{
<td valign='top' width='400' nowrap>
        };

        if (($Content->{filename1} ne '' && -e "$HTDOCS_PATH/files/items/small/$Content->{filename1}") ||
            ($Content->{filename2} ne '' && -e "$HTDOCS_PATH/files/items/small/$Content->{filename2}"))
        {
            $ReturnText .= qq{
    <img src='/files/items/big/$Content->{filename}'><br><br>

    <table cellpadding='0' cellspacing='0' border='0' width='400'>
    <tr>
            };

            if ($Content->{filename1} ne '' && -e "$HTDOCS_PATH/files/items/small/$Content->{filename1}") {
                $ReturnText .= qq{
    <td>
        <a class='fancybox' data-fancybox-group="items" title='' href='/files/items/big/$Content->{filename1}'><img src='/files/items/small/$Content->{filename1}' width='190' style='border: 1px solid black;'></a>
    </td>
                };
            }

            if ($Content->{filename2} ne '' && -e "$HTDOCS_PATH/files/items/small/$Content->{filename2}") {
                $ReturnText .= qq{
    <td width='20'></td>
    <td>
        <a class='fancybox' data-fancybox-group="items" title='' href='/files/items/big/$Content->{filename2}'><img src='/files/items/small/$Content->{filename2}' width='190' style='border: 1px solid black;'></a>
    </td>
                };
            }

            $ReturnText .= qq{
    </tr>
    </table>
            };
        }
        else {
            $ReturnText .= qq{
    <img src='/files/items/big/$Content->{filename}'>
            };
        }
        $ReturnText .= qq{
</td>
        };
    }

    $ReturnText .= qq{
<td width='25' nowrap><img src='/img/px.gif' width='25'></td>
<td valign='top'>
    <div>}.&DecodeEditorText($Content->{description}).qq{</div>
    };

    $ReturnText .= qq{
</td>
</tr>
</table>
    };

    return $ReturnText;
}

1;
