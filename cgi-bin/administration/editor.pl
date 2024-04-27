use strict;

our $DWFilter;
our $DWDB;
our $MAIN_LINK;
our $TOKEN_LINK_LAST_PARAM;

sub EditorToolBar {
    my $EditorID = shift;
    my $ReturnText = '';

    $ReturnText .= qq{
<a class='toolbar' href="javascript:ins_tag('$EditorID','[b]','[/b]')" title="[b][/b] Жирный шрифт"><img class='toolbar' src='/img/administration/editor/bold.gif'></a>

<a class='toolbar' href="javascript:ins_tag('$EditorID','[center]','[/center]')" title="[center][/center] Выравнивание по центру"><img class='toolbar' src='/img/administration/editor/center.gif'></a>

<a class='toolbar' href="javascript:ins_tag('$EditorID','[table][tr][td]','[/td][/tr][/table]')" title="[table][tr][td][/td][/tr][/table] Таблица"><img class='toolbar' src='/img/administration/editor/pastetable.gif'></a>

<a class='toolbar' href="javascript:ins_tag('$EditorID','[h2]','[/h2]')" title="[h2][/h2] Подзаголовок"><img class='toolbar' src='/img/administration/editor/header.gif'></a>

<a class='toolbar' href="javascript:ins_tag('$EditorID','[ul][li][/li]','[/ul]')" title="[ul][li][/li][/ul] Маркированный список"><img class='toolbar' src='/img/administration/editor/bullist.gif'></a>

<a class='toolbar' href="javascript:ins_tag('$EditorID','[a href=]','[/a]')" title="[a][/a] Ссылка"><img class='toolbar' src='/img/administration/editor/link.gif'></a>

<a class='toolbar' href="javascript:ins_tag('$EditorID','[video src= width= height=]','')" title="[video src= width= height=] Видео c YouTube"><img class='toolbar' src='/img/administration/editor/media.gif'></a>

<a class='toolbar' id='toolbar_image' href="javascript:LightBoxCall('$MAIN_LINK?mod=text&sub=filemanager&action=geteditorfilelist&editor_id=$EditorID$TOKEN_LINK_LAST_PARAM')" title="Добавить изображение"><img class='toolbar' src='/img/administration/editor/image.gif'></a>

<a class='toolbar' id='toolbar_help' href="javascript:LightBoxCall('$MAIN_LINK?mod=text&sub=filemanager&action=geteditorhelp&editor_id=$EditorID$TOKEN_LINK_LAST_PARAM')" title="Помощь"><img class='toolbar' src='/img/administration/editor/help.gif'></a>
    };

    return $ReturnText;
}

sub EditorHelp {
    my $ReturnText = '';

    $ReturnText .= '
<center>Справка по тегам редактора</center><br>
<center>Общие теги</center><br>
<b>[br]</b> - Перенос строки<br>
<b>[img=image.jpg]</b> - Вставить изображение image.jpg<br>
<b>[center]Текст[/center]</b> - Выравнивание текста по центру<br>
<b>[h2][/h2]</b> - Создать подзаголовок<br>
<b>[b][/b]</b> - Выделить текст полужирным<br>
<b>[video src=youtube_link width=640 height=480\]</b> - Вставить видео с youtube.com<br>

<br><center>Таблица</center><br>
<b>[table][/table]</b> - Вставить таблицу<br>
<b>[tr][/tr]</b> - Строка таблицы<br>
<b>[td][/td]</b> - Ячейка таблицы<br>
<b>[td colspan=3][/td]</b> - Объединить несколько ячеек (например 3)<br>
<b>[td width=100%][/td]</b> - Задать ширину ячейки (например 100%)<br>

<br><center>Слои</center><br>
<b>[div][/div]</b> - Добавить слой<br>
<b>[div class=myclass][/div]</b> - Добавить слой с классом (например myclass)<br>

<br><center>Маркированные списки</center><br>
<b>[ul][/ul]</b> - Добавить маркированный список<br>
<b>[li][/li]</b> - Элемент маркированного списка<br>

<br><center>Ссылка</center><br>
<b>[a href=http://example.com][/a]</b> - Добавить ссылку (например на example.com)<br>
<b>[a class=myclass href=http://example.com][/a]</b> - Добавить ссылку с классом (например myclass)<br>
    ';

    return $ReturnText;
}

sub EditorFileManager {
    my $ReturnText = '';

    my $EditorID = $DWFilter->GetParamFilterLatinDigetDash("editor_id");

    $ReturnText .= qq{
<div id='editor_filemanager'>
    <div id='editor_filemanager_leftcolumn'>
        <b>Закачанные файлы:</b><br><br>
        <div id='editor_filelist'>

    };

    my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().qq{text_editor_files WHERE type='images' ORDER BY filename});
    while (my $Content = $sth->fetchrow_hashref()) {
        $ReturnText .= qq{
        <a href='#' onClick='EditorFilePreview("/user_files/images/$Content->{filename}"); return false;'>$Content->{filename}</a><br><br>
        };
    }
    $sth->finish();

    $ReturnText .= qq{
        </div>
        <br>
        <div id='editor_preview'>
            <img class='editor_preview_img' height='300' src='/img/administration/editor/nophoto.jpg'>
        </div>
    </div>

    <div id='editor_filemanager_rightcolumn'>
        <input type='button' value='Выбрать' class='editor_input' onClick='EditorFileSelect("$EditorID");'>
    </div>
</div>
    };

    return $ReturnText;
}

1;
