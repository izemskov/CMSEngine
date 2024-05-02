use strict;

our $CGIBIN_PATH;
our $MOD;
our $SUB;
our $DWFilter;
our $DWDB;
our $MAIN_LINK;
our $TOKEN_LINK_LAST_PARAM;
our $TOKEN;

require "$CGIBIN_PATH/$MOD/$SUB.pl";

our $ModulTableName;
our $ModulItemUploadDirectory;

my $action = $DWFilter->GetParamFilterLatinDigetDash("action");

if ($SUB eq 'catalog') {
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
            print &ShowDataDoubleModulStructure('', $form{catalog_id});
            print &ShowDataAddSubElem($form{catalog_id});
            print &ShowDataItemDoubleModulFotoStructure('', $form{catalog_id});
            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'delete') {
        &DeleteDoubleStructure;
    }
    elsif ($action eq 'generate') {
        require "$CGIBIN_PATH/$MOD/generate_img.pl";
        &GenerateImg;
    }
    elsif ($action eq 'add_item') {
        &SubModulToModul;

        my %form = ();
        $form{catalog_id} = $DWFilter->GetParamFilterDiget('catalog_id');

        print &TemplateMainHeader;
        print &AddEditElem('saveadd_item', '', \%form);
        print &TemplateMainFooter;
    }
    elsif ($action eq 'saveadd_item') {
        &SubModulToModul;

        my $form = &AddEditGetFormData;
        my %form = %$form;

        my ($Errors, $form) = &AddEditCheckError(\%form);
        %form = %$form;

        if ($Errors eq '') {
            &SaveAddElem(\%form);
        }
        else {
            print &TemplateMainHeader;
            print &AddEditElem('saveadd_item', $Errors, \%form);
            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'edit_item') {
        &SubModulToModul;

        my $form = &EditGetDBData;
        my %form = %$form;

        $form{catalog_id} = $DWFilter->GetParamFilterDiget("catalog_id");

        print &TemplateMainHeader;
        print &AddEditElem('saveedit_item', '', \%form);
        print &TemplateMainFooter;
    }
    elsif ($action eq 'saveedit_item') {
        my $ID = $DWFilter->GetParamFilterDiget('id');

        if ($ID ne '') {
            &SubModulToModul;

            my $form = &AddEditGetFormData;
            my %form = %$form;

            $form{id} = $ID;

            my ($Errors, $form) = &AddEditCheckError(\%form, 'saveedit_item');
            %form = %$form;

            if ($Errors eq '') {
                &SaveEditElem(\%form);
            }
            else {
                print &TemplateMainHeader;
                print &AddEditElem('saveedit_item', $Errors, \%form);
                print &TemplateMainFooter;
            }
        }
        else {
            my $CatalogID = $DWFilter->GetParamFilterDiget('catalog_id');

            print &TemplateMainHeader;
            print &ShowDataAddElem;
            print &ShowDataDoubleModulStructure('', $CatalogID);
            print &ShowDataAddSubElem($CatalogID);
            print &ShowDataItemDoubleModulFotoStructure('', $CatalogID);
            print &TemplateMainFooter;
        }
    }
    elsif ($action eq 'delete_item') {
        &SubModulToModul;
        &DeleteSimpleStructure;
    }
    else {
        my $CatalogID = $DWFilter->GetParamFilterDiget('catalog_id');

        print &TemplateMainHeader;
        print &ShowDataAddElem;
        print &ShowDataDoubleModulStructure('', $CatalogID);

        print &ShowDataAddSubElem($CatalogID);
        print &ShowDataItemDoubleModulFotoStructure('', $CatalogID);
        print &TemplateMainFooter;
    }
}
elsif ($SUB eq 'filemanager') {
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
    elsif ($action eq 'delete') {
        &DeleteSimpleStructure;
        print &ShowDataSimpleStructure('');
    }
    elsif ($action eq 'geteditorhelp') {
        print &EditorHelp;
    }
    elsif ($action eq 'geteditorfilelist') {
        print &EditorFileManager;
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

        if ($form{symbol_link} ne '') {
            my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE symbol_link=?}, $form{symbol_link});
            if ($Count > 0) {
                $Errors .= "<li>Данная символьная ссылка уже существует</li>";
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

            if ($form{symbol_link} ne '') {
                my ($OldSymbolLink) = $DWDB->QuerySelectRowDB(qq{SELECT symbol_link FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $form{id});

                if ($form{symbol_link} ne $OldSymbolLink) {
                    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE symbol_link=?}, $form{symbol_link});
                    if ($Count > 0) {
                        $Errors .= "<li>Данная символьная ссылка уже существует</li>";
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
