use strict;

our $CGIBIN_PATH;
our $MOD;
our $SUB;
our $DWFilter;
our $DWDB;

require "$CGIBIN_PATH/$MOD/$SUB.pl";

our $ModulTableName;

my $action = $DWFilter->GetParamFilterLatinDigetDash("action");

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
            $Errors .= "<li>Заголовок с таким кодом уже существует</li>";
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
                    $Errors .= "<li>Заголовок с таким кодом уже существует</li>";
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

1;
