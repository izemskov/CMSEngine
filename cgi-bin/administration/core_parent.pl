use strict;

our %LANGUAGES;
our $DWFilter;
our $DWDB;
our $TOKEN;
our $MOD;
our $SUB;
our $MAIN_LINK;
our $TOKEN_LINK_LAST_PARAM;

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

sub ShowDataParentStructureRecurs {
    my $ReturnText = '';
    my $ParentID = shift;
    my $PaddingWidth = shift;

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE parent_id='$ParentID' $ModulShowOrderBy });
    while (my $Content = $sth->fetchrow_hashref()) {
        $ReturnText .= qq{
    <tr class='content_table_whitespace' height='30'>
        };

        for (my $i = 0; $i <= $#ModulShowFields; $i++) {
            my $RecursPadding = '';
            if ($ModulShowRecursPadding[$i] eq 'padding') {
                $RecursPadding = " style='padding-left: " . (10 + $PaddingWidth) . "px;' ";
            }
            else {
                $RecursPadding = " style='padding-left: 10px;' ";
            }

            $ReturnText .= qq{
    <td align='$ModulShowHeaderAlign[$i]' $RecursPadding class='content_table_edit_name'>
            };

            if ($ModulShowType[$i] eq 'input') {
                if ($ModulShowLanguagesField[$i] eq 'lang') {
                    foreach my $key (keys %LANGUAGES) {
                        $ReturnText .= qq{
        <b>$LANGUAGES{$key}</b>:<br>
        <input type='text' name='$ModulShowFields[$i]_$key}.qq{_$Content->{id}' class='content_table_field' value='}.&GetLanguageContent($key, $Content->{$ModulShowFields[$i]}).qq{'>
        <br><br>
                        };
                    }
                }
                else {
                    $ReturnText .= qq{
        <input type='text' name='$ModulShowFields[$i]_$Content->{id}' class='content_table_field' value='$Content->{$ModulShowFields[$i]}'>
                    };
                }
            }
            else {
                $ReturnText .= qq{
        $Content->{$ModulShowFields[$i]}
                };
            }

            $ReturnText .= qq{
    </td>
            };
        }

        if ($ModulShowIsEdit eq 'yes') {
            $ReturnText .= qq{
    <td align='center'>
        <a href='$MAIN_LINK?mod=$MOD&sub=$SUB&action=edit&content_id=$Content->{id}$TOKEN_LINK_LAST_PARAM'><img src='/img/administration/edit.png' alt='Изменить' title='Изменить'></a>
    </td>
            };
        }

        if ($ModulShowIsDelete eq 'yes') {
            $ReturnText .= qq{
    <td align='center'>
        <a href='#' onclick="ConfirmDelete('$ModulShowDeleteMessage', '$MAIN_LINK?mod=$MOD&sub=$SUB&action=delete&id=$Content->{id}$TOKEN_LINK_LAST_PARAM');">
            <img src='/img/administration/delete.png' alt='Удалить' title='Удалить'>
        </a>
    </td>
            };
        }

        $ReturnText .= qq{
    </tr>
        };

        my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE parent_id='$Content->{id}'});
        if ($Count > 0) {
            $ReturnText .= &ShowDataParentStructureRecurs("$Content->{id}", $PaddingWidth + $ModulShowRecursPaddingValue);
        }
    }
    $sth->finish();

    return $ReturnText;
}

sub ShowDataParentStructure {
    my $Errors = shift;

    my $ReturnText = '';

    my $CountCols = scalar(@ModulShowHeader);
    if ($ModulShowIsEdit eq 'yes') {
        $CountCols = $CountCols + 1;
    }
    if ($ModulShowIsDelete eq 'yes') {
        $CountCols = $CountCols + 1;
    }

    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE parent_id='0'});
    if ($Count > 0) {
        $ReturnText .= qq{
<div id='main_content_show'>
        };

        if ($Errors ne '') {
            $ReturnText .= qq{
<div class='alert'>
    Ошибки:
    <ul class='alert'>
        $Errors
    </ul>
</div>
            };
        }

        if ($ModulShowChangeAll eq 'yes') {
            $ReturnText .= qq{
    <form action='$MAIN_LINK' method='POST'>
    <input type='hidden' name='mod' value='$MOD'>
    <input type='hidden' name='sub' value='$SUB'>
    <input type='hidden' name='action' value='change'>
    <input type='hidden' name='token' value='$TOKEN'>
            };
        }

        $ReturnText .= qq{
    <table cellpadding='3' cellspacing='1' border='0' width='100%' class='content_table'>
    <tr class='content_table_header' height='30'>
    <td colspan='$CountCols'>
        <div class='content_info_table_header_text'>
            $ModulName
        </div>
    </td>
    </tr>

    <tr class='content_table_whitespace_nolight' height='30'>
        };

        for (my $i = 0; $i <= $#ModulShowHeader; $i++) {
            my $CellWidth = '';
            my $CellWidthClass = '';
            if ($ModulShowHeaderWidth[$i] ne '100%') {
                $CellWidth = "width='$ModulShowHeaderWidth[$i]'";
            }
            else {
                $CellWidthClass = ' content_table_cell_100_percent ';
            }

            $ReturnText .= qq{
    <td $CellWidth nowrap align='$ModulShowHeaderAlign[$i]' class='content_table_cell_header $CellWidthClass'>
        $ModulShowHeader[$i]
    </td>
            };
        }

        if ($ModulShowIsEdit eq 'yes') {
            $ReturnText .= qq{
    <td width='80' nowrap align='center' class='content_table_cell_header'>
        Изменить
    </td>
            };
        }

        if ($ModulShowIsDelete eq 'yes') {
            $ReturnText .= qq{
    <td width='80' nowrap align='center' class='content_table_cell_header'>
        Удалить
    </td>
            };
        }

        $ReturnText .= qq{
    </tr>
        };

        $ReturnText .= &ShowDataParentStructureRecurs('0', '0');

        if ($ModulShowChangeAll eq 'yes') {
            $ReturnText .= qq{
    <tr class='content_table_whitespace_nolight' height="22">
    <td colspan='$CountCols' align='center'>
        <input type='image' src='/img/administration/save.png' alt='Сохранить' title='Сохранить'>
    </td>
    </tr>
            };
        }

        $ReturnText .= qq{
    </table>
        };

        if ($ModulShowChangeAll eq 'yes') {
            $ReturnText .= qq{
    </form>
            };
        }

        $ReturnText .= qq{
</div>
        };
    }

    return $ReturnText;
}

sub DeleteParentStructureRecurs {
    my $ParentID = shift;

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE parent_id=?}, $ParentID);
    while (my $Content = $sth->fetchrow_hashref()) {
        &DeleteParentStructureRecurs($Content->{id});

        &DeleteModulFiles($Content->{id});
        &DeleteLangFields($Content);

        $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $Content->{id});
    }
    $sth->finish();
}

sub DeleteParentStructure {
    my $ID = $DWFilter->GetParamFilterDiget('id');

    if ($ID ne '') {
        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $ID);
        my $Content = $sth->fetchrow_hashref();
        $sth->finish();

        &DeleteParentStructureRecurs($ID);

        &DeleteModulFiles($ID);
        &DeleteLangFields($Content);
        $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $ID);
    }
}

sub RecursParentSelect {
    my $Parent = shift;
    my $CountSpace = shift;
    my $ExcludeID = shift;
    my $CurrentSelectID = shift;

    my $ReturnText = '';

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id, name FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE parent_id='$Parent' ORDER BY order_content});
    while (my $Content = $sth->fetchrow_hashref()) {
        if ($Content->{id} != $ExcludeID) {
            my $str = '';
            for (my $i = 1; $i <= $CountSpace; $i++) {
                $str .= '-';
            }

            $ReturnText .= qq{<option value='$Content->{id}' }; if ($CurrentSelectID == $Content->{id}) {$ReturnText .= qq{ selected }; } $ReturnText .= qq{>$str$Content->{name}};

            $ReturnText .= &RecursParentSelect($Content->{id}, $CountSpace + 1, $ExcludeID, $CurrentSelectID);
        }
    }
    $sth->finish();

    return $ReturnText;
}

sub RecursLangParentSelect {
    my $Parent = shift;
    my $CountSpace = shift;
    my $ExcludeID = shift;
    my $CurrentSelectID = shift;

    my $ReturnText = '';

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id, name FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE parent_id='$Parent' ORDER BY order_content});
    while (my $Content = $sth->fetchrow_hashref()) {
        if ($Content->{id} != $ExcludeID) {
            my $str = '';
            for (my $i = 1; $i <= $CountSpace; $i++) {
                $str .= '-';
            }

            my @keys = keys(%LANGUAGES);
            $ReturnText .= qq{<option value='$Content->{id}' }; if ($CurrentSelectID == $Content->{id}) {$ReturnText .= qq{ selected }; } $ReturnText .= qq{>$str}.&GetLanguageContent($keys[0], $Content->{name});

            $ReturnText .= &RecursLangParentSelect($Content->{id}, $CountSpace + 1, $ExcludeID, $CurrentSelectID);
        }
    }
    $sth->finish();

    return $ReturnText;
}

1;
