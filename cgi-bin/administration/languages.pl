use strict;

our $DWDB;
our %LANGUAGES;

my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().qq{languages});
while (my $Content = $sth->fetchrow_hashref()) {
    $LANGUAGES{$Content->{id}} = $Content->{name};
}
$sth->finish();

sub GetLanguageContent {
    my $LangID = shift;
    my $FieldID = shift;

    if ($LangID eq '') {
        my @keys = keys(%LANGUAGES);
        $LangID = $keys[0];
    }

    my $Value = '';
    if (($LangID ne '') && ($FieldID ne '')) {
        ($Value) = $DWDB->QuerySelectRowDB(qq{SELECT value FROM }.$DWDB->GetMysqlTableName().qq{languages_values WHERE lang_id=? AND parent_id=?}, $LangID, $FieldID);
    }

    return $Value;
}

1;
