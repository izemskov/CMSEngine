use strict;

our %LANGUAGES;
our $DWFilter;
our $DWDB;
our $TOKEN;
our $MOD;
our $SUB;
our $MAIN_LINK;
our $TOKEN_LINK_LAST_PARAM;
our $ACCESS_LEVEL;

###

our $ModulName;
our $ModulTableName;
our @ModulShowFields;
our @ModulShowType;
our @ModulShowHeader;
our @ModulShowHeaderWidth;
our @ModulShowHeaderAlign;
our $ModulShowRecursPaddingValue;
our @ModulShowRecursPadding;
our @ModulShowFieldsFilter;
our @ModulShowFieldsFilterResult;
our @ModulShowDeleteFileField;
our @ModulShowDeleteFileResize;
our @ModulShowLanguagesField;
our $ModulShowChangeAll;
our $ModulShowIsEdit;
our $ModulShowIsDelete;
our $ModulAddIsDeleteFile;
our $ModulShowOrderBy;
our $ModulShowDeleteMessage;
our $ModulFileDeleteMessage;
our $ModulUploadDirectory;
our $ModulUploadDirectoryRel;
our @ModulAddFields;
our @ModulAddFieldType;
our @ModulAddFieldName;
our @ModulAddFieldsFilter;
our @ModulAddFieldsFilterResult;
our @ModulAddPictureResize;
our @ModulAddLanguagesField;
our $TextAddElem;
our $TextAddSubElem;
our $ModulItemTableName;
our $ModulShowItemOrderBy;
our $ModulShowFieldFoto;
our $ModulItemUploadDirectory;
our $ModulShowFieldFotoPreview;
our $ModulItemUploadDirectoryRel;
our @ModulItemAddFields;
our @ModulItemAddFieldType;
our @ModulItemAddFieldName;
our @ModulItemAddFieldsFilter;
our @ModulItemAddFieldsFilterResult;
our @ModulItemAddPictureResize;
our @ModulItemAddLanguagesField;

require "core_parent.pl";
require "core_double.pl";
require "core_simple.pl";

sub ShowDataAddElem {
    my $ReturnText = '';

    if ($ACCESS_LEVEL->{access_add} eq 'yes') {
        my $Text = $TextAddElem;
        if ($Text eq '') {
            $Text = 'Добавить элемент';
        }

        $ReturnText .= qq{
<div id='main_content_add'>
    <div class='content_add'>
        <a href='$MAIN_LINK?mod=$MOD&sub=$SUB&action=add$TOKEN_LINK_LAST_PARAM'><img src='/img/administration/add.png' alt='Добавить элемент' title='Добавить элемент'></a>
    </div>
    <div class='content_add_text'>
        <a href='$MAIN_LINK?mod=$MOD&sub=$SUB&action=add$TOKEN_LINK_LAST_PARAM'>$Text</a>
    </div>
</div>

<br class='br_clear'>
        };
    }

    return $ReturnText;
}

sub ShowDataChange {
    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }

    my @Fields = ();
    my $FieldsSQL = '';

    if ($ACCESS_LEVEL->{access_edit} eq 'yes') {
        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName);
        while (my $Content = $sth->fetchrow_hashref()) {
            @Fields = ();
            $FieldsSQL = '';

            my $j = 0;
            for (my $i = 0; $i <= $#ModulShowFields; $i++) {
                if ($ModulShowType[$i] eq 'input') {
                    if ($ModulShowLanguagesField[$i] eq 'lang') {
                        foreach my $key (keys %LANGUAGES) {
                            my $Value = $form{$ModulShowFields[$i]."_$key"."_$Content->{id}"};
                            $DWDB->QueryDoDB(qq{UPDATE }.$DWDB->GetMysqlTableName().qq{languages_values SET value=? WHERE lang_id=? AND parent_id=?}, $Value, $key, $Content->{$ModulShowFields[$i]});
                        }
                    }
                    else {
                        if ($FieldsSQL ne '') {
                            $FieldsSQL .= ", $ModulShowFields[$i]=?";
                        }
                        else {
                            $FieldsSQL = "$ModulShowFields[$i]=?";
                        }

                        $Fields[$j] = $form{$ModulShowFields[$i]."_$Content->{id}"};
                        $j++;
                    }
                }
            }

            if (($FieldsSQL ne '') && (scalar(@Fields) > 0)) {
                $DWDB->QueryDoDB(qq{UPDATE }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ SET $FieldsSQL WHERE id='$Content->{id}'}, @Fields);
            }
        }
        $sth->finish();
    }

    print qq{<meta http-equiv="Refresh" content="0; URL=$MAIN_LINK?mod=$MOD&sub=$SUB$TOKEN_LINK_LAST_PARAM">};
}

sub ShowDataGetFormData {
    my %form = ();

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id FROM }.$DWDB->GetMysqlTableName().$ModulTableName);
    while (my $Content = $sth->fetchrow_hashref()) {
        for (my $i = 0; $i <= $#ModulShowFields; $i++) {
            if ($ModulShowType[$i] eq 'input') {
                if ($ModulShowLanguagesField[$i] eq 'lang') {
                    foreach my $key (keys %LANGUAGES) {
                        $form{$ModulShowFields[$i]."_$key"."_$Content->{id}"} = $DWFilter->GetClearParam($ModulShowFields[$i]."_$key"."_$Content->{id}");
                    }
                }
                else {
                    $form{$ModulShowFields[$i]."_$Content->{id}"} = $DWFilter->GetClearParam($ModulShowFields[$i]."_$Content->{id}");
                }
            }
        }
    }
    $sth->finish();

    return \%form;
}

sub DoShowDataCheckError {
    my $Error = shift;
    my $FilterValue = shift;
    my $FieldsFilter = shift;
    my $FilterResult = shift;
    my $Header = shift;
    my $ID = shift;

    if ($FieldsFilter eq 'htmlspecialchars') {
        if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
            $Error .= "<li>Поле $Header для ID=$ID не может быть пустым</li>";
        }
        else {
            $FilterValue = $DWFilter->FilterHTMLSpecialChars($FilterValue);
        }
    }
    elsif ($FieldsFilter eq 'digits') {
        if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
            $Error .= "<li>Поле $Header для ID=$ID не может быть пустым</li>";
        }
        else {
            $FilterValue = $DWFilter->FilterDiget($FilterValue);
            if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
                $Error .= "<li>Поле $Header для ID=$ID должно содержать только цифры</li>";
            }
        }
    }
    elsif ($FieldsFilter eq 'latindigits') {
        if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
            $Error .= "<li>Поле $Header для ID=$ID не может быть пустым</li>";
        }
        else {
            $FilterValue = $DWFilter->FilterLatinDiget($FilterValue);
            if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
                $Error .= "<li>Поле $Header для ID=$ID должно содержать только цифры и латинские буквы</li>";
            }
        }
    }

    return ($Error, $FilterValue);
}

sub ShowDataCheckError {
    my $Error = '';

    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id FROM }.$DWDB->GetMysqlTableName().$ModulTableName);
    while (my $Content = $sth->fetchrow_hashref()) {
        for (my $i = 0; $i <= $#ModulShowFields; $i++) {
            if (($ModulShowType[$i] eq 'input') && ($ModulShowFieldsFilter[$i] ne 'none')) {
                my $FilterValue = '';
                if ($ModulShowLanguagesField[$i] eq 'lang') {
                    foreach my $key (keys %LANGUAGES) {
                        $FilterValue = $form{$ModulShowFields[$i]."_$key"."_$Content->{id}"};
                        ($Error, $FilterValue) = &DoShowDataCheckError($Error, $FilterValue, $ModulShowFieldsFilter[$i], $ModulShowFieldsFilterResult[$i],
                           $ModulShowHeader[$i], $Content->{id});

                        $form{$ModulShowFields[$i]."_$key"."_$Content->{id}"} = $FilterValue;
                    }
                }
                else {
                    $FilterValue = $form{$ModulShowFields[$i]."_$Content->{id}"};
                    ($Error, $FilterValue) = &DoShowDataCheckError($Error, $FilterValue, $ModulShowFieldsFilter[$i], $ModulShowFieldsFilterResult[$i],
                           $ModulShowHeader[$i], $Content->{id});

                    $form{$ModulShowFields[$i]."_$Content->{id}"} = $FilterValue;
                }
            }
        }
    }
    $sth->finish();

    return ($Error, \%form);
}

sub DeleteModulFiles {
    my $ID = shift;

    if (scalar(@ModulShowDeleteFileField) > 0) {
        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $ID);
        my $Content = $sth->fetchrow_hashref();
        for (my $i = 0; $i <= $#ModulShowDeleteFileField; $i++) {
            if (($Content->{$ModulShowDeleteFileField[$i]} ne '') && (-e "$ModulUploadDirectory/$Content->{$ModulShowDeleteFileField[$i]}")) {
                unlink("$ModulUploadDirectory/$Content->{$ModulShowDeleteFileField[$i]}");
            }
            my @ResizePictures = split(/~~~/, $ModulShowDeleteFileResize[$i]);

            foreach my $ResizeValue (@ResizePictures) {
                if ($ResizeValue ne '') {
                    if (-e "$ModulUploadDirectory/$ResizeValue/$Content->{$ModulShowDeleteFileField[$i]}") {
                        unlink("$ModulUploadDirectory/$ResizeValue/$Content->{$ModulShowDeleteFileField[$i]}");
                    }
                }
            }
        }
        $sth->finish();
    }
}

sub DoDeleteModulFile {
    my $ID = shift;
    my $Field = shift;
    my $FileResize = shift;

    if (&ExistInArray($Field, @ModulAddFields)) {
        my ($Value) = $DWDB->QuerySelectRowDB(qq{SELECT $Field FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $ID);

        if (($Value ne '') && (-e "$ModulUploadDirectory/$Value")) {
            unlink("$ModulUploadDirectory/$Value");
        }
        my @ResizePictures = split(/---/, $FileResize);

        foreach my $ResizeValue (@ResizePictures) {
            if ($ResizeValue ne '') {
                if (-e "$ModulUploadDirectory/$ResizeValue/$Value") {
                    unlink("$ModulUploadDirectory/$ResizeValue/$Value");
                }
            }
        }
    }
}

sub DeleteModulFile {
    my $ID = $DWFilter->GetParamFilterDiget('id');
    my $Field = $DWFilter->GetParamFilterLatinDigetDash('field');
    my $FileResize = $DWFilter->GetParamFilterLatinDigetDash('file_resize');

    &DoDeleteModulFile($ID, $Field, $FileResize);
}

sub DeleteLangFields {
    my $Content = shift;

    my $DeleteFieldID = '';
    for (my $i = 0; $i <= $#ModulAddFields; $i++) {
        if ($ModulAddLanguagesField[$i] eq 'lang') {
            if ($DeleteFieldID eq '') {
                $DeleteFieldID .= "$Content->{$ModulAddFields[$i]}";
            }
            else {
                $DeleteFieldID .= ",$Content->{$ModulAddFields[$i]}";
            }
        }
    }

    if ($DeleteFieldID ne '') {
        $DeleteFieldID = "($DeleteFieldID)";

        $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().qq{languages_fields WHERE id IN $DeleteFieldID});
        $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().qq{languages_values WHERE parent_id IN $DeleteFieldID});
    }
}

sub AddEditForm {
    my $Action = shift;
    my $Errors = shift;
    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }

    my $ReturnText = '';

    for (my $i = 0; $i <= $#ModulAddFields; $i++) {
        $ReturnText .= qq{
<tr class='content_table_whitespace'>
        };

        if (($ModulAddFieldType[$i] eq 'input') || ($ModulAddFieldType[$i] eq 'select_parent') || ($ModulAddFieldType[$i] eq 'file') ||
           ($ModulAddFieldType[$i] eq 'textarea') || ($ModulAddFieldType[$i] eq 'select_modul') || ($ModulAddFieldType[$i] eq 'password') ||
           ($ModulAddFieldType[$i] eq 'boolean')) {
            $ReturnText .= qq{
<td height='25' width='300' nowrap class='content_table_edit_name'>
    <b>$ModulAddFieldName[$i]</b>
</td>
            };
        }

        if ($ModulAddFieldType[$i] eq 'input') {
            if ($ModulAddLanguagesField[$i] eq 'lang') {
                $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
                };

                foreach my $key (keys %LANGUAGES) {
                    my $Value = '';
                    if (($Action eq 'saveadd') || ($Action eq 'saveadd_item') || ($Errors ne '')) {
                        $Value = $form{$ModulAddFields[$i]."_$key"};
                    }
                    elsif (($Action eq 'saveedit') || ($Action eq 'saveedit_item')) {
                        $Value = &GetLanguageContent($key, $form{$ModulAddFields[$i]});
                    }

                    $ReturnText .= qq{
    <b>$LANGUAGES{$key}</b>:<br>
    <input type='text' name='$ModulAddFields[$i]_$key' value='$Value' class='text_container_input'>
    <br><br>
                    };
                }

                $ReturnText .= qq{
</td>
                };
            }
            else {
                $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
    <input type='text' name='$ModulAddFields[$i]' value='$form{$ModulAddFields[$i]}' class='text_container_input'>
</td>
                };
            }
        }
        elsif ($ModulAddFieldType[$i] eq 'password') {
            $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
    <input type='password' name='$ModulAddFields[$i]' value='' class='text_container_input'>
</td>
            };
        }
        elsif ($ModulAddFieldType[$i] eq 'select_parent') {
            $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
    <select class='text_container_input' name='$ModulAddFields[$i]'>
        <option value='0'>Главное меню
            };

            if ($ModulAddLanguagesField[$i] eq 'langname') {
                $ReturnText .= &RecursLangParentSelect(0, 1, $form{id}, $form{parent_id});
            }
            else {
                $ReturnText .= &RecursParentSelect(0, 1, $form{id}, $form{parent_id});
            }

            $ReturnText .= qq{
    </select>
</td>
            };
        }
        elsif ($ModulAddFieldType[$i] eq 'select_modul') {
            $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
    <select class='text_container_input' name='$ModulAddFields[$i]'>
            };

            if ($ModulAddLanguagesField[$i] eq 'langname') {
                $ReturnText .= &LangModulSelect($form{catalog_id});
            }
            else {
                $ReturnText .= &ModulSelect($form{catalog_id});
            }

            $ReturnText .= qq{
    </select>
</td>
            };
        }
        elsif ($ModulAddFieldType[$i] eq 'file') {
            $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
            };

            if ($ModulAddFieldsFilter[$i] eq 'picture') {
                if (($form{$ModulAddFields[$i]} ne '') && (-e "$ModulUploadDirectory/$form{$ModulAddFields[$i]}")) {
                    my @ResizePicturesTypes = split(/~~~/, $ModulAddPictureResize[$i]);
                    my $FileResize = '';
                    foreach my $value (@ResizePicturesTypes) {
                        my ($DirectoryResize, $NewWidth, $NewHeight) = split(/#/, $value);
                        if ($FileResize ne '') {
                            $FileResize .= "---$DirectoryResize";
                        }
                        else {
                            $FileResize .= "$DirectoryResize";
                        }
                    }

                    # Определяем ширину изображения и если она больше 1024 пикселей принудительно выставляем размер
                    my $PicWidthStr = '';
                    my ($PicWidth, $PicHeight) = &GetPictureSize("$ModulUploadDirectory/$form{$ModulAddFields[$i]}");
                    if ($PicWidth > 600) {
                        $PicWidthStr = " width='600' ";
                    }

                    $ReturnText .= qq{
    <div id='add_edit_form_picture'>
        <center><img src='$ModulUploadDirectoryRel/$form{$ModulAddFields[$i]}' $PicWidthStr>
                    };

                    if ($ModulAddIsDeleteFile eq 'yes') {
                        $ReturnText .= qq{
        <a href='#' onclick="ConfirmDeleteFile('$ModulFileDeleteMessage', '$MAIN_LINK?mod=$MOD&sub=$SUB&action=delete_file&field=$ModulAddFields[$i]&id=$form{id}&file_resize=$FileResize$TOKEN_LINK_LAST_PARAM');">
            <img src='/img/administration/delete.png' alt='Удалить' title='Удалить'>
        </a>
                        };
                    }

                    $ReturnText .= qq{
            </center>
    </div>
                    };
                }
            }

            $ReturnText .= qq{
    <input type="file" name='$ModulAddFields[$i]' class='text_container_input'>
</td>
            };
        }
        elsif ($ModulAddFieldType[$i] eq 'big_textarea') {
            if ($ModulAddLanguagesField[$i] eq 'lang') {
                $ReturnText .= qq{
<td colspan='2' class='content_table_edit_name content_table_cell_100_percent'>
    <b>$ModulAddFieldName[$i]</b><br><br>
                };

                foreach my $key (keys %LANGUAGES) {
                    my $Value = '';
                    if (($Action eq 'saveadd') || ($Action eq 'saveadd_item') || ($Errors ne '')) {
                        $Value = $form{$ModulAddFields[$i]."_$key"};
                    }
                    elsif (($Action eq 'saveedit') || ($Action eq 'saveedit_item')) {
                        $Value = &GetLanguageContent($key, $form{$ModulAddFields[$i]});
                    }

                    $ReturnText .= qq{
    <b>$LANGUAGES{$key}</b>:<br><br>
                    };

                    $ReturnText .= &EditorToolBar("Editor_$ModulAddFields[$i]_$key");

                    $ReturnText .= qq{
    <textarea rows='15' id="Editor_$ModulAddFields[$i]_$key" name='$ModulAddFields[$i]_$key' class='text_container_input' onkeydown="key_pressed('Editor_$ModulAddFields[$i]_$key', event);">$Value</textarea>
    <br><br>
                    };
                }

                $ReturnText .= qq{
</td>
                };
            }
            else {
                $ReturnText .= qq{
<td colspan='2' class='content_table_edit_name content_table_cell_100_percent'>
    <b>$ModulAddFieldName[$i]</b><br>
    <textarea rows='15' name='$ModulAddFields[$i]' class='text_container_input'>$form{$ModulAddFields[$i]}</textarea>
</td>
                };
            }
        }
        elsif ($ModulAddFieldType[$i] eq 'boolean') {
            $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
    <select class='text_container_input' name='$ModulAddFields[$i]'>
        <option value='no' }; if ($form{$ModulAddFields[$i]} eq 'no') { $ReturnText .= qq{selected}; } $ReturnText .= qq{>Нет
        <option value='yes' }; if ($form{$ModulAddFields[$i]} eq 'yes') { $ReturnText .= qq{selected}; } $ReturnText .= qq{>Да
    </select>
</td>
            };
        }
        elsif ($ModulAddFieldType[$i] eq 'textarea') {
            if ($ModulAddLanguagesField[$i] eq 'lang') {
                $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
                };

                foreach my $key (keys %LANGUAGES) {
                    my $Value = '';
                    if (($Action eq 'saveadd') || ($Action eq 'saveadd_item') || ($Errors ne '')) {
                        $Value = $form{$ModulAddFields[$i]."_$key"};
                    }
                    elsif (($Action eq 'saveedit') || ($Action eq 'saveedit_item')) {
                        $Value = &GetLanguageContent($key, $form{$ModulAddFields[$i]});
                    }

                    $ReturnText .= qq{
    <b>$LANGUAGES{$key}</b>:<br>
    <textarea rows='5' name='$ModulAddFields[$i]_$key' class='text_container_input'>$Value</textarea>
    <br><br>
                    };
                }

                $ReturnText .= qq{
</td>
                };
            }
            else {
                $ReturnText .= qq{
<td class='content_table_edit_name content_table_cell_100_percent'>
    <textarea rows='5' name='$ModulAddFields[$i]' class='text_container_input'>$form{$ModulAddFields[$i]}</textarea>
</td>
                };
            }
        }
        elsif ($ModulAddFieldType[$i] eq 'date') {
        }

        $ReturnText .= qq{
</tr>
        };
    }

    return $ReturnText;
}

sub AddEditElem {
    my $Action = shift;
    my $Errors = shift;
    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }

    my $ReturnText = '';

    if (((($Action eq 'saveadd') || ($Action eq 'saveadd_item')) && ($ACCESS_LEVEL->{access_add} eq 'yes')) ||
        ((($Action eq 'saveedit') || ($Action eq 'saveedit_item')) && ($ACCESS_LEVEL->{access_edit} eq 'yes'))) {
        $ReturnText .= qq{
<form action='$MAIN_LINK' method='POST' enctype="multipart/form-data">
<input type='hidden' name='mod' value='$MOD'>
<input type='hidden' name='sub' value='$SUB'>
<input type='hidden' name='action' value='$Action'>
<input type='hidden' name='token' value='$TOKEN'>
        };

        if (($Action eq 'saveedit') || ($Action eq 'saveedit_item')) {
            $ReturnText .= qq{
<input type='hidden' name='id' value='$form{id}'>
            };
        }

        $ReturnText .= qq{
<table cellpadding='3' cellspacing='1' border='0' width='100%' class='content_table'>
<tr class='content_table_header' height='30'>
<td colspan='2'>
    <div class='content_info_table_header_text'>
        <a href='$MAIN_LINK?mod=$MOD&sub=$SUB$TOKEN_LINK_LAST_PARAM'>$ModulName</a>&nbsp;&raquo;&nbsp;};

        if (($Action eq 'saveadd') || ($Action eq 'saveadd_item')) {
            $ReturnText .= qq{Добавление элемента};
        }
        elsif (($Action eq 'saveedit') || ($Action eq 'saveedit_item')) {
            $ReturnText .= qq{Редактирование элемента};
        }

        $ReturnText .= qq{
    </div>
</td>
</tr>
        };

        if ($Errors ne '') {
            $ReturnText .= qq{
<tr class='content_table_whitespace'>
<td colspan='2' >
    <div class='alert'>
        Ошибки:
        <ul class='alert'>
            $Errors
        </ul>
    </div>
</td>
</tr>
            };
        }

        $ReturnText .= &AddEditForm($Action, $Errors, \%form);

        $ReturnText .= qq{
<tr class='content_table_whitespace_nolight'>
<td colspan='2' align='center'>
    <input type='image' src='/img/administration/save.png' alt='Сохранить' title='Сохранить'>
</td>
</tr>
</table>
</form>
        };

    }

    return $ReturnText;
}

sub AddEditGetFormData {
    my %form = ();

    for (my $i = 0; $i <= $#ModulAddFields; $i++) {
        if ($ModulAddLanguagesField[$i] eq 'lang') {
            foreach my $key (keys %LANGUAGES) {
                $form{$ModulAddFields[$i]."_$key"} = $DWFilter->GetClearParam($ModulAddFields[$i]."_$key");
            }
        }
        else {
            $form{$ModulAddFields[$i]} = $DWFilter->GetClearParam($ModulAddFields[$i]);

            if ($ModulAddFieldType[$i] eq 'file') {
                $form{$ModulAddFields[$i]."_tmpFileName"} = $DWFilter->GetTmpFileName($form{$ModulAddFields[$i]});
            }
        }
    }

    return \%form;
}

sub DoAddEditCheckError {
    my $Error = shift;
    my $FilterValue = shift;
    my $FieldsFilter = shift;
    my $FilterResult = shift;
    my $FieldName = shift;

    if ($FieldsFilter eq 'htmlspecialchars') {
        if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
            $Error .= "<li>Поле $FieldName не может быть пустым</li>";
        }
        else {
            $FilterValue = $DWFilter->FilterHTMLSpecialChars($FilterValue);
        }
    }
    elsif ($FieldsFilter eq 'digits') {
        if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
            $Error .= "<li>Поле $FieldName не может быть пустым</li>";
        }
        else {
            $FilterValue = $DWFilter->FilterDiget($FilterValue);
            if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
                $Error .= "<li>Поле $FieldName должно содержать только цифры</li>";
            }
        }
    }
    elsif ($FieldsFilter eq 'latindigits') {
        if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
            $Error .= "<li>Поле $FieldName не может быть пустым</li>";
        }
        else {
            $FilterValue = $DWFilter->FilterLatinDiget($FilterValue);
            if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
                $Error .= "<li>Поле $FieldName должно содержать только цифры и латинские буквы</li>";
            }
        }
    }
    elsif ($FieldsFilter eq 'latindigitsdash') {
        if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
            $Error .= "<li>Поле $FieldName не может быть пустым</li>";
        }
        else {
            $FilterValue = $DWFilter->FilterLatinDigetDash($FilterValue);
            if (($FilterResult eq 'notempty') && ($FilterValue eq '')) {
                $Error .= "<li>Поле $FieldName должно содержать только цифры и латинские буквы</li>";
            }
        }
    }

    return ($Error, $FilterValue);
}

sub AddEditCheckError {
    my $Error = '';

    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }
    my $action = shift;

    for (my $i = 0; $i <= $#ModulAddFields; $i++) {
        if ((($ModulAddFieldType[$i] eq 'input') || ($ModulAddFieldType[$i] eq 'select_parent') || ($ModulAddFieldType[$i] eq 'textarea')
           || ($ModulAddFieldType[$i] eq 'big_textarea') || ($ModulAddFieldType[$i] eq 'password')) && ($ModulAddFieldsFilter[$i] ne 'none')) {
            my $FilterValue = '';
            if ($ModulAddLanguagesField[$i] eq 'lang') {
                foreach my $key (keys %LANGUAGES) {
                    $FilterValue = $form{$ModulAddFields[$i]."_$key"};
                    ($Error, $FilterValue) = &DoAddEditCheckError($Error, $FilterValue, $ModulAddFieldsFilter[$i], $ModulAddFieldsFilterResult[$i],
                       $ModulAddFieldName[$i]);

                    $form{$ModulAddFields[$i]."_$key"} = $FilterValue;
                }
            }
            else {
                $FilterValue = $form{$ModulAddFields[$i]};
                ($Error, $FilterValue) = &DoAddEditCheckError($Error, $FilterValue, $ModulAddFieldsFilter[$i], $ModulAddFieldsFilterResult[$i],
                   $ModulAddFieldName[$i]);

                $form{$ModulAddFields[$i]} = $FilterValue;
            }
        }
        elsif (($ModulAddFieldType[$i] eq 'file') && ($ModulAddFieldsFilter[$i] ne 'none')) {
            if (($ModulAddFieldsFilterResult[$i] eq 'notempty') && ($form{$ModulAddFields[$i]} eq '')) {
                if (($action ne 'saveedit') && ($action ne 'saveedit_item')) {
                    $Error .= "<li>Для поля $ModulAddFieldName[$i] обязательно должен быть выбран файл</li>";
                }
            }
            else {
                $form{$ModulAddFields[$i]} = $DWFilter->FilterFile($form{$ModulAddFields[$i]});
                if (($ModulAddFieldsFilterResult[$i] eq 'notempty') && ($form{$ModulAddFields[$i]} eq '')) {
                    $Error .= "<li>Название файла для поля $ModulAddFieldName[$i] должно содержать только цифры, латинские буквы, символы подчеркивания и тире</li>";
                }
                else {
                    if ($ModulAddFieldsFilter[$i] eq 'picture') {
                        $form{$ModulAddFields[$i]} = $DWFilter->FilterPicture($form{$ModulAddFields[$i]});
                        if (($ModulAddFieldsFilterResult[$i] eq 'notempty') && ($form{$ModulAddFields[$i]} eq '')) {
                            $Error .= "<li>Файл может только следующие расширения: .jpg, .gif, .png</li>";
                        }
                    }
                }
            }
        }
        elsif (($ModulAddFieldType[$i] eq 'boolean')) {
            if ($form{$ModulAddFields[$i]} ne 'yes' && $form{$ModulAddFields[$i]} ne 'no') {
                $Error .= "<li>Для поля $ModulAddFieldName[$i] переданно некоректное значение</li>";
            }
        }
    }

    return ($Error, \%form);
}

sub AddLangField {
    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }
    my $FieldName = shift;

    $DWDB->QueryDoDB(qq{
INSERT INTO
    }.$DWDB->GetMysqlTableName().qq{languages_fields
SET
    comment=''
    });
    my $FieldID = $DWDB->GetMysqlInsertID;

    if ($FieldID ne '') {
        foreach my $key (keys %LANGUAGES) {
            my $Value = $form{$FieldName."_$key"};

            $DWDB->QueryDoDB(qq{
INSERT INTO
    }.$DWDB->GetMysqlTableName().qq{languages_values
SET
    parent_id='$FieldID',
    lang_id='$key',
    value=?
            }, $Value);

        }
    }

    return $FieldID;
}

sub SaveAddElem {
    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }

    my $AutoRefresh = shift;

    my @Fields = ();
    my $FieldsSQL = '';

    if ($ACCESS_LEVEL->{access_add} eq 'yes') {
        my $j = 0;
        for (my $i = 0; $i <= $#ModulAddFields; $i++) {
            if (($ModulAddFieldType[$i] eq 'input') || ($ModulAddFieldType[$i] eq 'select_parent') || ($ModulAddFieldType[$i] eq 'textarea') ||
                ($ModulAddFieldType[$i] eq 'big_textarea') || ($ModulAddFieldType[$i] eq 'select_modul') || ($ModulAddFieldType[$i] eq 'boolean'))
            {
                if ($ModulAddLanguagesField[$i] eq 'lang') {
                    my $LangFieldValue = &AddLangField(\%form, $ModulAddFields[$i]);

                    if ($FieldsSQL ne '') {
                        $FieldsSQL .= ", $ModulAddFields[$i]=?";
                    }
                    else {
                        $FieldsSQL = "$ModulAddFields[$i]=?";
                    }

                    $Fields[$j] = $LangFieldValue;
                    $j++;
                }
                else {
                    if ($FieldsSQL ne '') {
                        $FieldsSQL .= ", $ModulAddFields[$i]=?";
                    }
                    else {
                        $FieldsSQL = "$ModulAddFields[$i]=?";
                    }

                    $Fields[$j] = $form{$ModulAddFields[$i]};
                    $j++;
                }
            }
            elsif ($ModulAddFieldType[$i] eq 'password') {
                if ($FieldsSQL ne '') {
                    $FieldsSQL .= ", $ModulAddFields[$i]=?";
                }
                else {
                    $FieldsSQL = "$ModulAddFields[$i]=?";
                }

                my $Password = &GetCryptPassword($form{$ModulAddFields[$i]});

                $Fields[$j] = $Password;
                $j++;
            }
            elsif ($ModulAddFieldType[$i] eq 'file') {
                if (($form{$ModulAddFields[$i]} ne '') && ($form{$ModulAddFields[$i].'_tmpFileName'} ne '')) {
                    my $FileName = &UploadFile($form{$ModulAddFields[$i]}, $form{$ModulAddFields[$i].'_tmpFileName'}, $ModulUploadDirectory);

                    if ($FieldsSQL ne '') {
                        $FieldsSQL .= ", $ModulAddFields[$i]=?";
                    }
                    else {
                        $FieldsSQL = "$ModulAddFields[$i]=?";
                    }

                    $Fields[$j] = $FileName;
                    $j++;

                    if ($ModulAddFieldsFilter[$i] eq 'picture') {
                        if ($ModulAddPictureResize[$i] ne '') {
                            my @ResizePicturesTypes = split(/~~~/, $ModulAddPictureResize[$i]);
                            foreach my $ResizeValue (@ResizePicturesTypes) {
                                &ResizePicture($FileName, $ModulUploadDirectory, $ResizeValue);
                            }
                        }
                    }
                }
            }
            elsif ($ModulAddFieldType[$i] eq 'date') {
                if ($FieldsSQL ne '') {
                    $FieldsSQL .= ", $ModulAddFields[$i]=?";
                }
                else {
                    $FieldsSQL = "$ModulAddFields[$i]=?";
                }

                $Fields[$j] = time;
                $j++;
            }
        }

        if (($FieldsSQL ne '') && (scalar(@Fields) > 0)) {
            $DWDB->QueryDoDB(qq{
INSERT INTO
    }.$DWDB->GetMysqlTableName().$ModulTableName.qq{
SET
    $FieldsSQL
            }, @Fields);
        }
    }

    my $CatalogIDText = '';
    if ($form{catalog_id} ne '') {
        $CatalogIDText = "&catalog_id=$form{catalog_id}";
    }

    if ($AutoRefresh ne 'no') {
        print qq{<meta http-equiv="Refresh" content="0; URL=$MAIN_LINK?mod=$MOD&sub=$SUB$CatalogIDText$TOKEN_LINK_LAST_PARAM">};
    }
    else {
        return $DWDB->GetMysqlInsertID();
    }
}

sub EditGetDBData {
    my %form = ();

    my $ContentID = $DWFilter->GetParamFilterDiget('content_id');

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $ContentID);
    my $Content = $sth->fetchrow_hashref();
    $sth->finish();

    for (my $i = 0; $i <= $#ModulAddFields; $i++) {
        $form{$ModulAddFields[$i]} = $Content->{$ModulAddFields[$i]};
    }
    $form{'id'} = $ContentID;

    return \%form;
}

sub EditLangField {
    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }
    my $FieldName = shift;
    my $Content = shift;

    my $FieldID = '';

    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().qq{languages_fields WHERE id=?}, $Content->{$FieldName});
    if ($Count > 0) {
        $FieldID = $Content->{$FieldName};
    }

    if ($FieldID ne '') {
        foreach my $key (keys %LANGUAGES) {
            my $Value = $form{$FieldName."_$key"};
            $DWDB->QueryDoDB(qq{
UPDATE
    }.$DWDB->GetMysqlTableName().qq{languages_values
SET
    value=?
WHERE
    parent_id='$FieldID' AND
    lang_id='$key'
            }, $Value);
        }
    }
}

sub SaveEditElem {
    my $form = shift;
    my %form = ();
    if ($form ne '') {
        %form = %$form;
    }

    my @Fields = ();
    my $FieldsSQL = '';

    my $Content = '';

    my $j = 0;
    for (my $i = 0; $i <= $#ModulAddFields; $i++) {
        if (($ModulAddFieldType[$i] eq 'input') || ($ModulAddFieldType[$i] eq 'select_parent') || ($ModulAddFieldType[$i] eq 'textarea') ||
            ($ModulAddFieldType[$i] eq 'big_textarea') || ($ModulAddFieldType[$i] eq 'select_modul') || ($ModulAddFieldType[$i] eq 'boolean'))
        {
            if ($ModulAddLanguagesField[$i] eq 'lang') {
                if ($Content eq '') {
                    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $form{id});
                    $Content = $sth->fetchrow_hashref();
                    $sth->finish();
                }

                &EditLangField(\%form, $ModulAddFields[$i], $Content);
            }
            else {
                if ($FieldsSQL ne '') {
                    $FieldsSQL .= ", $ModulAddFields[$i]=?";
                }
                else {
                    $FieldsSQL = "$ModulAddFields[$i]=?";
                }

                $Fields[$j] = $form{$ModulAddFields[$i]};
                $j++;
            }
        }
        elsif ($ModulAddFieldType[$i] eq 'password') {
            if ($FieldsSQL ne '') {
                $FieldsSQL .= ", $ModulAddFields[$i]=?";
            }
            else {
                $FieldsSQL = "$ModulAddFields[$i]=?";
            }

            my $Password = &GetCryptPassword($form{$ModulAddFields[$i]});
            $Fields[$j] = $Password;
            $j++;
        }
        elsif ($ModulAddFieldType[$i] eq 'file') {
            if (($form{$ModulAddFields[$i]} ne '') && ($form{$ModulAddFields[$i].'_tmpFileName'} ne '')) {
                my @ResizePicturesTypes = split(/~~~/, $ModulAddPictureResize[$i]);
                my $FileResize = '';
                foreach my $value (@ResizePicturesTypes) {
                    my ($DirectoryResize, $NewWidth, $NewHeight) = split(/#/, $value);
                    if ($FileResize ne '') {
                        $FileResize .= "---$DirectoryResize";
                    }
                    else {
                        $FileResize .= "$DirectoryResize";
                    }
                }
                &DoDeleteModulFile($form{id}, $ModulAddFields[$i], $FileResize);

                my $FileName = &UploadFile($form{$ModulAddFields[$i]}, $form{$ModulAddFields[$i].'_tmpFileName'}, $ModulUploadDirectory);

                if ($FieldsSQL ne '') {
                    $FieldsSQL .= ", $ModulAddFields[$i]=?";
                }
                else {
                    $FieldsSQL = "$ModulAddFields[$i]=?";
                }

                $Fields[$j] = $FileName;
                $j++;

                if ($ModulAddFieldsFilter[$i] eq 'picture') {
                    if ($ModulAddPictureResize[$i] ne '') {
                        my @ResizePicturesTypes = split(/~~~/, $ModulAddPictureResize[$i]);
                        foreach my $ResizeValue (@ResizePicturesTypes) {
                            &ResizePicture($FileName, $ModulUploadDirectory, $ResizeValue);
                        }
                    }
                }
            }
        }
        elsif ($ModulAddFieldType[$i] eq 'date') {
            if ($FieldsSQL ne '') {
                $FieldsSQL .= ", $ModulAddFields[$i]=?";
            }
            else {
                $FieldsSQL = "$ModulAddFields[$i]=?";
            }

            $Fields[$j] = time;
            $j++;
        }
    }

    if (($FieldsSQL ne '') && (scalar(@Fields) > 0)) {
        push(@Fields, $form{id});

        $DWDB->QueryDoDB(qq{
UPDATE
    }.$DWDB->GetMysqlTableName().$ModulTableName.qq{
SET
    $FieldsSQL
WHERE
    id=?
        }, @Fields);
    }

    my $CatalogIDText = '';
    if ($form{catalog_id} ne '') {
        $CatalogIDText = "&catalog_id=$form{catalog_id}";
    }

    print qq{<meta http-equiv="Refresh" content="0; URL=$MAIN_LINK?mod=$MOD&sub=$SUB$CatalogIDText$TOKEN_LINK_LAST_PARAM">};
}

1;
