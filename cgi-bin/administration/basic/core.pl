use strict;

our $CGIBIN_PATH;
our $MOD;
our $SUB;
our $DWFilter;
our $DWDB;
our $MAIN_LINK;
our $TOKEN_LINK_LAST_PARAM;

require "$CGIBIN_PATH/$MOD/$SUB.pl";

our $ModulTableName;

my $action = $DWFilter->GetParamFilterLatinDigetDash("action");

if ($SUB eq 'languages' || $SUB eq 'langvalues') {
    if ($action eq 'add') {
        print &TemplateMainHeader;
        print &AddEditElem('saveadd');
        print &TemplateMainFooter;
    }
    elsif ($action eq 'saveadd') {
        my $form = &AddEditGetFormData;
        my %form = %$form;

        my ($Errors, $form) = &AddEditCheckError(\%form);
        %form = %$form;

        if ($Errors eq '') {
            my $ID = &SaveAddElem(\%form, 'no');

            if ($ID ne '') {
                my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id FROM }.$DWDB->GetMysqlTableName().qq{languages_fields ORDER BY id});
                while (my $Content = $sth->fetchrow_hashref()) {
                    $DWDB->QueryDoDB(qq{INSERT INTO }.$DWDB->GetMysqlTableName().qq{languages_values SET parent_id='$Content->{id}', lang_id='$ID', value=''});
                }
                $sth->finish();
            }

            print qq{<meta http-equiv="Refresh" content="0; URL=$MAIN_LINK?mod=$MOD&sub=$SUB$TOKEN_LINK_LAST_PARAM">};
        }
        else {
            print &TemplateMainHeader;
            print &AddEditElem('saveadd', $Errors, \%form);
            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'edit') {
        my $form = &EditGetDBData;
        my %form = %$form;

        print &TemplateMainHeader;
        print &AddEditElem('saveedit', '', \%form);
        print &TemplateMainFooter;
    }
    elsif ($action eq 'saveedit') {
        my $form = &AddEditGetFormData;
        my %form = %$form;

        $form{id} = $DWFilter->GetParamFilterDiget("id");

        if ($form{id} ne '') {
            my ($Errors, $form) = &AddEditCheckError(\%form);
            %form = %$form;

            if ($Errors eq '') {
                &SaveEditElem(\%form);
            }
            else {
                print &TemplateMainHeader;
                print &AddEditElem('saveedit', $Errors, \%form);
                print &TemplateMainFooter;
            }
        }
        else {
            print &TemplateMainHeader;
            print &ShowDataAddElem;
            print &ShowDataSimpleStructure('');
            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'delete') {
        my $ID = $DWFilter->GetParamFilterDiget('id');

        if ($ID ne '') {
            $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().qq{languages_values WHERE lang_id=?}, $ID);
        }

        &DeleteSimpleStructure;
        print &ShowDataSimpleStructure('');
    }
    elsif ($action eq 'change') {
        my $form = &ShowDataGetFormData;
        my %form = %$form;

        my ($Errors, $form) = &ShowDataCheckError(\%form);
        %form = %$form;

        if ($Errors eq '') {
            &ShowDataChange(\%form);
        }
        else {
            print &TemplateMainHeader;

            print &ShowDataAddElem;
            print &ShowDataSimpleStructure($Errors);

            print &TemplateMainFooter;
        }
    }
    else {
        print &TemplateMainHeader;
        print &ShowDataAddElem;
        print &ShowDataSimpleStructure('');
        print &TemplateMainFooter;
    }
}
elsif ($SUB eq 'settings') {
    if ($action eq 'add') {
        print &TemplateMainHeader;
        print &AddEditElem('saveadd');
        print &TemplateMainFooter;
    }
    elsif ($action eq 'saveadd') {
        my $form = &AddEditGetFormData;
        my %form = %$form;

        my ($Errors, $form) = &AddEditCheckError(\%form);
        %form = %$form;

        if ($form{translitname} ne '') {
            my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE translitname=?}, $form{translitname});
            if ($Count > 0) {
                $Errors .= "<li>Настройка с таким кодом уже существует</li>";
            }
        }

        if ($Errors eq '') {
            &SaveAddElem(\%form);
        }
        else {
            print &TemplateMainHeader;
            print &AddEditElem('saveadd', $Errors, \%form);
            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'edit') {
        my $form = &EditGetDBData;
        my %form = %$form;

        print &TemplateMainHeader;
        print &AddEditElem('saveedit', '', \%form);
        print &TemplateMainFooter;
    }
    elsif ($action eq 'saveedit') {
        my $form = &AddEditGetFormData;
        my %form = %$form;

        $form{id} = $DWFilter->GetParamFilterDiget("id");

        if ($form{id} ne '') {
            my ($Errors, $form) = &AddEditCheckError(\%form);
            %form = %$form;

            if ($form{translitname} ne '') {
                my ($OldSymbolLink) = $DWDB->QuerySelectRowDB(qq{SELECT translitname FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $form{id});

                if ($form{translitname} ne $OldSymbolLink) {
                    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE translitname=?}, $form{translitname});
                    if ($Count > 0) {
                        $Errors .= "<li>Настройка с таким кодом уже существует</li>";
                    }
                }
            }

            if ($Errors eq '') {
                &SaveEditElem(\%form);
            }
            else {
                print &TemplateMainHeader;
                print &AddEditElem('saveedit', $Errors, \%form);
                print &TemplateMainFooter;
            }
        }
        else {
            print &TemplateMainHeader;
            print &ShowDataAddElem;
            print &ShowDataSimpleStructure('');
            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'delete') {
        &DeleteSimpleStructure;
        print &ShowDataSimpleStructure('');
    }
    else {
        print &TemplateMainHeader;
        print &ShowDataAddElem;
        print &ShowDataSimpleStructure('');
        print &TemplateMainFooter;
    }
}

1;

