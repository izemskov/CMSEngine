use strict;

our $DWDB;
our %LANGUAGES;
our $TOKEN;
our $MOD;
our $SUB;
our $MAIN_LINK;
our $TOKEN_LINK_LAST_PARAM;
our $ACCESS_LEVEL;
our $DWFilter;

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
our @ModulItemShowDeleteFileField;
our @ModulItemShowDeleteFileResize;
our $ModulShowItemOrderBy;
our $ModulShowFieldFoto;
our $ModulShowItemDeleteMessage;
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
our $ModulShowItemIsEdit;
our $ModulShowItemIsDelete;
our $ModulAddItemIsDeleteFile;

###
our @tmpModulAddFields;
our @tmpModulAddFieldType;
our @tmpModulAddFieldName;
our @tmpModulAddFieldsFilter;
our @tmpModulAddFieldsFilterResult;
our @tmpModulAddPictureResize;
our @tmpModulAddLanguagesField;
our @tmpModulShowDeleteFileField;
our @tmpModulShowDeleteFileResize;
our $tmpModulTableName;
our $tmpModulUploadDirectory;
our $tmpModulUploadDirectoryRel;
our $tmpModulAddIsDeleteFile;

sub ShowDataAddSubElem {
    my $CatalogID = shift;
    my $ReturnText = '';

    my $Text = $TextAddSubElem;
    if ($Text eq '') {
        $Text = 'Добавить под-элемент';
    }

    my $CatalogIDText = '';
    if ($CatalogID ne '') {
        $CatalogIDText = "&catalog_id=$CatalogID";
    }

    $ReturnText .= qq{
<div id='main_content_add'>
    <div class='content_add'>
        <a href='$MAIN_LINK?mod=$MOD&sub=$SUB&action=add_item$CatalogIDText$TOKEN_LINK_LAST_PARAM'><img src='/img/administration/add.png' alt='Добавить элемент' title='Добавить элемент'></a>
    </div>
    <div class='content_add_text'>
        <a href='$MAIN_LINK?mod=$MOD&sub=$SUB&action=add_item$CatalogIDText$TOKEN_LINK_LAST_PARAM'>$Text</a>
    </div>
</div>

<br class='br_clear'>
    };

    return $ReturnText;
}

sub ShowDataDoubleModulStructure {
    my $Errors = shift;
    my $CatalogID = shift;

    my $ReturnText = '';

    my $CountCols = scalar(@ModulShowHeader);
    if ($ModulShowIsEdit eq 'yes') {
        $CountCols = $CountCols + 1;
    }
    if ($ModulShowIsDelete eq 'yes') {
        $CountCols = $CountCols + 1;
    }

    my $Where = '';
    if ($CatalogID ne '') {
        $Where = " WHERE id='$CatalogID' ";
    }

    my ($Count, $Name) = $DWDB->QuerySelectRowDB(qq{SELECT count(*), name FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ $Where });
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
        };

        if ($CatalogID ne '') {
            $ReturnText .= qq{<a href='$MAIN_LINK?mod=$MOD&sub=$SUB$TOKEN_LINK_LAST_PARAM'>$ModulName</a>&nbsp;&raquo;&nbsp;}.&GetLanguageContent('', $Name);
        }
        else {
            $ReturnText .= $ModulName;
        }

        $ReturnText .= qq{
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

        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ $Where $ModulShowOrderBy });
        while (my $Content = $sth->fetchrow_hashref()) {
            my ($CountSubItem) = $DWDB->QuerySelectRowDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulItemTableName.qq{ WHERE catalog_id='$Content->{id}' });

            $ReturnText .= qq{
        <tr class='content_table_whitespace' height='30'>
            };

            for (my $i = 0; $i <= $#ModulShowFields; $i++) {
                $ReturnText .= qq{
    <td align='$ModulShowHeaderAlign[$i]' class='content_table_edit_name'>
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
                    if ($ModulShowLanguagesField[$i] eq 'lang') {
                        foreach my $key (keys %LANGUAGES) {
                            if ($CountSubItem > 0) {
                                $ReturnText .= qq{<a href='$MAIN_LINK?mod=$MOD&sub=$SUB&catalog_id=$Content->{id}$TOKEN_LINK_LAST_PARAM'>};
                            }

                            $ReturnText .= qq{
        <b>$LANGUAGES{$key}</b>:<br>
        }.&GetLanguageContent($key, $Content->{$ModulShowFields[$i]}).qq{
        <br><br>
                            };

                            if ($CountSubItem > 0) {
                                $ReturnText .= qq{</a>};
                            }
                        }
                    }
                    else {
                        if ($CountSubItem > 0) {
                            $ReturnText .= qq{<a href='#'>};
                        }

                        $ReturnText .= qq{
        $Content->{$ModulShowFields[$i]}
                        };

                        if ($CountSubItem > 0) {
                            $ReturnText .= qq{</a>};
                        }
                    }
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
        <a href='#' onclick="ConfirmDoubleDelete('$ModulShowDeleteMessage', '$MAIN_LINK?mod=$MOD&sub=$SUB&action=delete&id=$Content->{id}$TOKEN_LINK_LAST_PARAM');">
            <img src='/img/administration/delete.png' alt='Удалить' title='Удалить'>
        </a>
    </td>
                };
            }

            $ReturnText .= qq{
    </tr>
            };
        }
        $sth->finish();

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

<br><br><br>
        };
    }

    return $ReturnText;
}

sub ShowDataItemDoubleModulFotoStructure {
    my $Errors = shift;
    my $CatalogID = shift;

    my $ReturnText = '';

    if ($CatalogID ne '') {
        my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().$ModulItemTableName.qq{ WHERE catalog_id='$CatalogID' });
        if ($Count > 0) {
            $ReturnText .= qq{
<div id='main_sub_content_show'>
            };

            $ReturnText .= qq{
    <table cellpadding='3' cellspacing='1' border='0' width='100%' class='content_table'>
    <tr class='content_table_header' height='30'>
    <td colspan='4'>
        <div class='content_info_table_header_text'>
            $ModulName
        </div>
    </td>
    </tr>
            };

            my $i = 0;
            my $Width = int(100 / 4);
            my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulItemTableName.qq{ WHERE catalog_id='$CatalogID' $ModulShowItemOrderBy });
            while (my $Content = $sth->fetchrow_hashref()) {
                if (($i % 4) == 0) {
                    $ReturnText .= qq{
        <tr class='content_table_whitespace_nolight'>
                    };
                }

                $ReturnText .= qq{
        <td width='$Width}.qq{%' align='center'>
                };

                if (($Content->{$ModulShowFieldFoto} ne '') && (-e "$ModulItemUploadDirectory/$ModulShowFieldFotoPreview/$Content->{$ModulShowFieldFoto}")) {
                    $ReturnText .= qq{
            <img src='$ModulItemUploadDirectoryRel/$ModulShowFieldFotoPreview/$Content->{$ModulShowFieldFoto}'>
                    };
                }

                if (($ModulShowItemIsEdit eq 'yes') || ($ModulShowItemIsDelete eq 'yes')) {
                    $ReturnText .= qq{
            <div>};

                    if ($ModulShowItemIsEdit eq 'yes') {
                        $ReturnText .= qq{<a href='$MAIN_LINK?mod=$MOD&sub=$SUB&action=edit_item&catalog_id=$CatalogID&content_id=$Content->{id}$TOKEN_LINK_LAST_PARAM'><img src='/img/administration/edit.png'></a> };
                    }

                    if ($ModulShowItemIsDelete eq 'yes') {
                        $ReturnText .= qq{<a href='#' onclick="ConfirmDoubleDelete('$ModulShowItemDeleteMessage', '$MAIN_LINK?mod=$MOD&sub=$SUB&action=delete_item&id=$Content->{id}&catalog_id=$CatalogID$TOKEN_LINK_LAST_PARAM');"><img src='/img/administration/delete.png'></a>};
                    }

                    $ReturnText .= qq{</div>
                    };
                }


                $i++;

                if (($i % 4) == 0) {
                    $ReturnText .= qq{
        </tr>
                    };
                }
            }
            $sth->finish();

            if (($i % 4) != 0) {
                while (($i % 4) != 0) {
                    $ReturnText .= qq{
        <td width='$Width}.qq{%' align='center'></td>
                    };

                    $i++;
                }

                $ReturnText .= qq{
        </tr>
                };
            }

            $ReturnText .= qq{
    </table>

</div>

<br><br><br>
            };
        }
    }

    return $ReturnText;
}

#sub ShowDataItemDoubleModulFotoStructure {
#
#}

sub DeleteItemStructure {
    my $ID = shift;

    if (($ACCESS_LEVEL->{access_delete} eq 'yes') && ($ID ne '')) {
        &SubModulToModul;

        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE catalog_id=?}, $ID);
        while (my $Content = $sth->fetchrow_hashref()) {
            &DeleteModulFiles($Content->{id});
            &DeleteLangFields($Content);
            $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $Content->{id});
        }
        $sth->finish();

        &ModulToSubModul;
    }
}

sub DeleteDoubleStructure {
    if ($ACCESS_LEVEL->{access_delete} eq 'yes') {
        my $ID = $DWFilter->GetParamFilterDiget('id');

        if ($ID ne '') {
            my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $ID);
            my $Content = $sth->fetchrow_hashref();
            $sth->finish();

            &DeleteModulFiles($ID);
            &DeleteLangFields($Content);
            &DeleteItemStructure($ID);
            $DWDB->QueryDoDB(qq{DELETE FROM }.$DWDB->GetMysqlTableName().$ModulTableName.qq{ WHERE id=?}, $ID);
        }
    }
}

sub ModulSelect {
    my $CurrentSelectID = shift;

    my $ReturnText = '';

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id, name FROM }.$DWDB->GetMysqlTableName().$ModulItemTableName);
    while (my $Content = $sth->fetchrow_hashref()) {
        $ReturnText .= qq{<option value='$Content->{id}' }; if ($CurrentSelectID == $Content->{id}) {$ReturnText .= qq{ selected }; } $ReturnText .= qq{>$Content->{name}};
    }
    $sth->finish();

    return $ReturnText;
}

sub LangModulSelect {
    my $CurrentSelectID = shift;

    my $ReturnText = '';

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id, name FROM }.$DWDB->GetMysqlTableName().$ModulItemTableName);
    while (my $Content = $sth->fetchrow_hashref()) {
        my @keys = keys(%LANGUAGES);
        $ReturnText .= qq{<option value='$Content->{id}' }; if ($CurrentSelectID == $Content->{id}) {$ReturnText .= qq{ selected }; } $ReturnText .= qq{>}.&GetLanguageContent($keys[0], $Content->{name});;
    }
    $sth->finish();

    return $ReturnText;
}

sub SubModulToModul {
    @tmpModulAddFields = @ModulAddFields;
    @ModulAddFields = @ModulItemAddFields;

    @tmpModulAddFieldType = @ModulAddFieldType;
    @ModulAddFieldType = @ModulItemAddFieldType;

    @tmpModulAddFieldName = @ModulAddFieldName;
    @ModulAddFieldName = @ModulItemAddFieldName;

    @tmpModulAddFieldsFilter = @ModulAddFieldsFilter;
    @ModulAddFieldsFilter = @ModulItemAddFieldsFilter;

    @tmpModulAddFieldsFilterResult = @ModulAddFieldsFilterResult;
    @ModulAddFieldsFilterResult = @ModulItemAddFieldsFilterResult;

    @tmpModulAddPictureResize = @ModulAddPictureResize;
    @ModulAddPictureResize = @ModulItemAddPictureResize;

    @tmpModulAddLanguagesField = @ModulAddLanguagesField;
    @ModulAddLanguagesField = @ModulItemAddLanguagesField;

    @tmpModulShowDeleteFileField = @ModulShowDeleteFileField;
    @ModulShowDeleteFileField = @ModulItemShowDeleteFileField;

    @tmpModulShowDeleteFileResize = @ModulShowDeleteFileResize;
    @ModulShowDeleteFileResize = @ModulItemShowDeleteFileResize;

    $tmpModulTableName = $ModulTableName;
    $ModulTableName = $ModulItemTableName;
    $ModulItemTableName = $tmpModulTableName;

    $tmpModulUploadDirectory = $ModulUploadDirectory;
    $ModulUploadDirectory = $ModulItemUploadDirectory;

    $tmpModulUploadDirectoryRel = $ModulUploadDirectoryRel;
    $ModulUploadDirectoryRel = $ModulItemUploadDirectoryRel;

    $tmpModulAddIsDeleteFile = $ModulAddIsDeleteFile;
    $ModulAddIsDeleteFile = $ModulAddItemIsDeleteFile;
}

sub ModulToSubModul {
    @ModulAddFields = @tmpModulAddFields;
    @ModulAddFieldType = @tmpModulAddFieldType;
    @ModulAddFieldName = @tmpModulAddFieldName;
    @ModulAddFieldsFilter = @tmpModulAddFieldsFilter;
    @ModulAddFieldsFilterResult = @tmpModulAddFieldsFilterResult;
    @ModulAddPictureResize = @tmpModulAddPictureResize;
    @ModulAddLanguagesField = @tmpModulAddLanguagesField;
    @ModulShowDeleteFileField = @tmpModulShowDeleteFileField;
    @ModulShowDeleteFileResize = @tmpModulShowDeleteFileResize;

    $ModulItemTableName = $ModulTableName;
    $ModulTableName = $tmpModulTableName;

    $ModulUploadDirectory = $tmpModulUploadDirectory;
    $ModulUploadDirectoryRel = $tmpModulUploadDirectoryRel;
    $ModulAddIsDeleteFile = $tmpModulAddIsDeleteFile;
}

1;
