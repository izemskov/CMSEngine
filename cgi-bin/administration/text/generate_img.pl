use strict;

our $DWFilter;
our $ModulItemTableName;
our $DWDB;
our $ModulItemUploadDirectory;
our @ModulItemAddPictureResize;
our $MAIN_LINK;
our $MOD;
our $SUB;
our $TOKEN_LINK_LAST_PARAM;

sub GenerateImg {
    my $page = $DWFilter->GetParamFilterDiget("page");
    my $mess = 1;

    if ($page eq "") {
        $page = 1;
    }

    my $page1;
    if ($page eq "1") {
        $page1 = 0;
    }
    else {
        $page1 = $mess * $page - $mess;
    }

    my $Sizes = '';
    foreach my $value (@ModulItemAddPictureResize) {
        if ($value ne '') {
            $Sizes = $value;
            last;
        }
    }

    if ($Sizes ne '') {
        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id, filename FROM }.$DWDB->GetMysqlTableName().$ModulItemTableName.qq{ ORDER BY id LIMIT $page1, $mess});
        while (my $CurrentItem = $sth->fetchrow_hashref()) {
            my @ResizePicturesTypes = split(/~~~/, $Sizes);
            foreach my $ResizeValue (@ResizePicturesTypes) {
                my ($DirectoryResize, $NewWidth, $NewHeight) = split(/#/, $ResizeValue);

                if ((-e "$ModulItemUploadDirectory/$CurrentItem->{filename}") && ($CurrentItem->{filename} ne "")) {
                    if (-e "$ModulItemUploadDirectory/$DirectoryResize/$CurrentItem->{filename}") {
                        unlink("$ModulItemUploadDirectory/$DirectoryResize/$CurrentItem->{filename}");
                    }

                    &ResizePicture($CurrentItem->{filename}, $ModulItemUploadDirectory, $ResizeValue);
                }
            }

            print " .";
        }
        $sth->finish();
    }

    my ($CountGoods) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulItemTableName);

    if (($page1 + $mess) >= $CountGoods) {
        print "<br><br>Генерация завершена!";

        print qq{<meta http-equiv="Refresh" content="0; URL=$MAIN_LINK?mod=$MOD&sub=$SUB$TOKEN_LINK_LAST_PARAM">};
    }
    else {
        print "<br><br>Ждите! Сейчас произойдет перезагрузка страницы и генерация картинок продолжиться!";

        $page++;

        print qq{<meta http-equiv="Refresh" content="0; URL=$MAIN_LINK?mod=$MOD&sub=$SUB&action=generate&page=$page$TOKEN_LINK_LAST_PARAM">}
    }
}

1;


