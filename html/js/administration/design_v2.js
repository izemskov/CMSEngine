$(document).ready(
    function () {
        $('a.main_menu_text').click(
            function () {
                $(this).next('div.main_menu_sub_item').fadeIn('fast');

                return false;
            }
        );

        $('div.main_menu_sub_item').mouseleave(
            function () {
                $(this).fadeOut('fast');
            }
        );

        $('div.main_menu_sub_item_text').mouseover(
            function () {
                $(this).addClass('main_menu_sub_item_text_active');
                $(this).children('a.main_menu_sub_item_text').addClass('main_menu_sub_item_text_active');
            }
        );

        $('div.main_menu_sub_item_text').mouseout(
            function () {
                $(this).removeClass('main_menu_sub_item_text_active');
                $(this).children('a.main_menu_sub_item_text').removeClass('main_menu_sub_item_text_active');
            }
        );

        $('tr.content_table_whitespace').mouseover(
            function() {
                $(this).addClass('content_table_whitespace_active');
            }
        );
        $('tr.content_table_whitespace').mouseout(
            function() {
                $(this).removeClass('content_table_whitespace_active');
            }
        );

        $('div.main_content_info_table_header_roll_up').click(
            function () {
                var elem = $(this).parent().parent();
                $(this).parent().next().slideUp('slow', function() {
                    elem.height('27');
                });
            }
        );
    }
);

function ConfirmDelete(DeleteMessage, Link) {
    if (confirm(DeleteMessage)) {
        $('#main_content_show').load(Link);
    }

    return false;
}

function ConfirmDoubleDelete(DeleteMessage, Link) {
    if (confirm(DeleteMessage)) {
        $.ajax({
            url: Link,
            success: function(data) {
                location.reload();
            }
        });
    }

    return false;
}

function ConfirmDeleteFile(DeleteMessage, Link) {
    if (confirm(DeleteMessage)) {
        $('#add_edit_form_picture').load(Link);
    }

    return false;
}

function EditorFilePreview(AFileName) {
    $('img.editor_preview_img').attr("src", AFileName);
    return false;
}

function LightboxClose() {
    $('#editor_lightbox_overlay, #editor_lightbox, #editor_lightbox_close').fadeOut('slow', function() {
    $(this).remove();
        $('body').css('overflow-y', 'auto');
    });

    return false;
}

function LightboxPosition (text) {
    var top = ($(window).height() - $('#editor_lightbox').height()) / 2;
    var left = ($(window).width() - $('#editor_lightbox').width()) / 2;

    var top_close = top - $('#editor_lightbox_close').height() / 2;
    var left_close = left + $('#editor_lightbox').width();

    $('#editor_lightbox').css({
        'top': top + $(document).scrollTop(),
        'left': left
    }).fadeIn();
    $('#editor_lightbox').html(text);

    $('#editor_lightbox_close').css({
        'top': top_close + $(document).scrollTop(),
        'left': left_close
    }).fadeIn();
}

function LightboxOpen(text) {
    $('body').css('overflow-y', 'hidden');
    $('<div id="editor_lightbox_overlay"></div>').css('top', $(document).scrollTop()).css('opacity', '0').animate({'opacity': '0.5'}, 'slow').appendTo('body');
    $('<div id="editor_lightbox_close"></div>').hide().click(function () {
        LightboxClose();
    }).appendTo('body');
    $('<div id="editor_lightbox"></div>').hide().appendTo('body').each(function() {
        LightboxPosition(text);
    });

    return false;
}

function LightBoxCall(AText) {
    $.ajax({
        url: AText,
        success: function(data) {
            LightboxOpen(data);
        }
    });
}

function EditorFileSelect(EditorID) {
    var CurrentImage = $('img.editor_preview_img').attr("src");
    if (CurrentImage != '/img/administration/editor/nophoto.jpg') {
        CurrentImage=CurrentImage.replace(/\/user_files\/images\//g, '');
        ins_tag(EditorID, '[img=' + CurrentImage + ']', '')
    }

    LightboxClose();
}
