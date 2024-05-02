use strict;

our $ModulName = 'Текстовые разделы';
our $ModulTableName = 'text_content';

=item
Show
=cut
# Fields
our @ModulShowFields = (
    'id',
    'name',
    'order_content'
);
our @ModulShowType = (
    'text',
    'input',
    'input'
);

# Output
our @ModulShowHeader = (
    'ID',
    'Название',
    'Порядок'
);
our @ModulShowHeaderWidth = (
    '40',
    '100%',
    '80'
);
our @ModulShowHeaderAlign = (
    'center',
    'left',
    'center'
);

# Recurs output
our $ModulShowRecursPaddingValue = 20;
our @ModulShowRecursPadding = (
    'nopadding',
    'padding',
    'nopadding'
);

# Filters
our @ModulShowFieldsFilter = (
    'none',
    'htmlspecialchars',
    'digits'
);
our @ModulShowFieldsFilterResult = (
    'notempty',
    'notempty',
    'notempty'
);

# Delete files
our @ModulShowDeleteFileField = (
);
our @ModulShowDeleteFileResize = (
);

# Languages
our @ModulShowLanguagesField = (
    'none',
    'lang',
    'none'
);

our $ModulShowChangeAll = 'yes';
our $ModulShowIsEdit = 'yes';
our $ModulShowIsDelete = 'yes';

our $ModulAddIsDeleteFile = 'no';

our $ModulShowOrderBy = ' ORDER BY order_content, name ';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данный раздел?';
our $ModulFileDeleteMessage = '';

our $ModulUploadDirectory = "";
our $ModulUploadDirectoryRel = "";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'name',
    'fullname',
    'symbol_link',
    'parent_id',
    'content',
    'order_content',
    'meta_title',
    'meta_description',
    'meta_keywords'
);

our @ModulAddFieldType = (
    'input',
    'input',
    'input',
    'select_parent',
    'big_textarea',
    'input',
    'textarea',
    'textarea',
    'textarea'
);

# Output
our @ModulAddFieldName = (
    'Название',
    'Полное название',
    'Символьная ссылка',
    'Расположение',
    'Содержание',
    'Порядок',
    'Мета-тег заголовки страницы',
    'Мета-тег описание страницы',
    'Мета-тег ключевые слова'
);

# Filters
our @ModulAddFieldsFilter = (
    'htmlspecialchars',
    'htmlspecialchars',
    'latindigitsdash',
    'digits',
    'htmlspecialchars',
    'digits',
    'htmlspecialchars',
    'htmlspecialchars',
    'htmlspecialchars'
);
our @ModulAddFieldsFilterResult = (
    'notempty',
    'none',
    'none',
    'notempty',
    'none',
    'notempty',
    'none',
    'none',
    'none'
);

# Resize
our @ModulAddPictureResize = (
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    '',
    ''
);

# Languages
our @ModulAddLanguagesField = (
    'lang',
    'lang',
    'none',
    'langname',
    'lang',
    'none',
    'lang',
    'lang',
    'lang'
);

1;
