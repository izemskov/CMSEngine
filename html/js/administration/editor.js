function ins_tag(EditorID, _tag_start, _tag_end) {
    var area = document.getElementById(EditorID);

    area.focus();

    if (document.getSelection) {
        area.value = area.value.substring(0, area.selectionStart) + _tag_start + area.value.substring(area.selectionStart, area.selectionEnd) + _tag_end +
           area.value.substring(area.selectionEnd, area.value.length);
    }
    else{
        document.selection.createRange().text = _tag_start + document.selection.createRange().text + _tag_end;;
    }

    area.focus();
}

function key_pressed(EditorID, event) {
    if (!event.ctrlKey)
        return;
    if (event.keyCode == 13) {
        ins_tag(EditorID, '[br]', '');
    }
}