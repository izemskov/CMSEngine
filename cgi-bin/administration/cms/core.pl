use strict;

our $CGIBIN_PATH;
our $MOD;
our $SUB;
our $DWFilter;
our $DWDB;

require "$CGIBIN_PATH/$MOD/$SUB.pl";

our $ModulTableName;

my $action = $DWFilter->GetParamFilterLatinDigetDash("action");

if ($SUB eq 'users') {
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
else {
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

        if (($form{modul} ne '') && ($form{sub_modul} ne '')) {
            my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE modul=? AND sub_modul=?}, $form{modul}, $form{sub_modul});
            if ($Count > 0) {
                $Errors .= "<li>Данные модуль и подмодуль уже существуют</li>";
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

            if (($form{modul} ne '') && ($form{sub_modul} ne '')) {
                my ($OldModul, $OldSubModul) = $DWDB->QuerySelectRowDB(qq{SELECT modul, sub_modul FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $form{id});

                if (($form{modul} ne $OldModul) || ($form{sub_modul} ne $OldSubModul)) {
                    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE modul=? AND sub_modul=?}, $form{modul}, $form{sub_modul});
                    if ($Count > 0) {
                        $Errors .= "<li>Данные модуль и подмодуль уже существуют</li>";
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
            print &ShowDataParentStructure('');
            print &TemplateMainFooter;
        }
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
            print &ShowDataParentStructure($Errors);

            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'delete') {
        &DeleteParentStructure;
        print &ShowDataParentStructure('');
    }
    elsif ($action eq 'delete_file') {
        &DeleteModulFile;
    }
    else {
        print &TemplateMainHeader;
        print &ShowDataAddElem;
        print &ShowDataParentStructure('');
        print &TemplateMainFooter;
    }
}
1;
