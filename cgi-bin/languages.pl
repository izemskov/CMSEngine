use strict;
use CGI::Cookie;

our $DWFilter;
our $DWDB;
our $LANGUAGE_ID;
our %LANGUAGES_HASH;

my $LanguageID = $DWFilter->GetCookieFilterDiget("language_id", 3);

if ($LanguageID eq '') {
    ($LANGUAGE_ID) = $DWDB->QuerySelectRowDB(qq{SELECT id FROM }.$DWDB->GetMysqlTableName.qq{languages ORDER BY order_content, id LIMIT 1});

    my $Cookie = CGI::Cookie->new(
        -name => 'language_id',
        -value => "$LANGUAGE_ID",
        -expires => '+3M'
    );
    print qq{<META HTTP-EQUIV="Set-Cookie" CONTENT="$Cookie">};
}
else {
    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName.qq{languages WHERE id=?}, $LanguageID);
    if ($Count > 0) {
        $LANGUAGE_ID = $LanguageID;
    }
    else {
        ($LANGUAGE_ID) = $DWDB->QuerySelectRowDB(qq{SELECT id FROM }.$DWDB->GetMysqlTableName.qq{languages ORDER BY order_content, id LIMIT 1});
    }
}

if ($LANGUAGE_ID ne '') {
    my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT
    value, parent_id
FROM
    }.$DWDB->GetMysqlTableName.qq{languages_values
WHERE
    lang_id=?
    }, $LANGUAGE_ID);
    while (my $Content = $sth->fetchrow_hashref()) {
        $LANGUAGES_HASH{$Content->{parent_id}} = $Content->{value};
    }
    $sth->finish();
}

1;
