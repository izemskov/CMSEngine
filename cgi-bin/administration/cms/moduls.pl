use strict;

=item
Тип модуля - Древовидный (core_parent)
=cut

our $HTDOCS_PATH;

our $ModulName = 'Модули';
our $ModulTableName = 'cms_struct';

=item
Show
=cut
# Поля выводимые при общем просмотре модуля
our @ModulShowFields = (
    'id',
    'name',
    'order_content'
);
# Тип полей в общем выводе
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
    'picture'
);
our @ModulShowDeleteFileResize = (
    'small'
);

# Languages
our @ModulShowLanguagesField = (
    'none',
    'none',
    'none'
);

our $ModulShowChangeAll = 'yes';
our $ModulShowIsEdit = 'yes';
our $ModulShowIsDelete = 'yes';

our $ModulAddIsDeleteFile = 'yes';

our $ModulShowOrderBy = ' ORDER BY order_content, name ';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данный раздел?';
our $ModulFileDeleteMessage = 'Вы уверены, что хотите удалить данный файл?';

our $ModulUploadDirectory = "$HTDOCS_PATH/files/administration/moduls";
our $ModulUploadDirectoryRel = "/files/administration/moduls";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'name',
    'parent_id',
    'modul',
    'sub_modul',
    'picture',
    'order_content'
);

our @ModulAddFieldType = (
    'input',
    'select_parent',
    'input',
    'input',
    'file',
    'input'
);

# Output
our @ModulAddFieldName = (
    'Название',
    'Расположение',
    'Модуль',
    'Под модуль',
    'Картинка',
    'Порядок'
);

# Filters
our @ModulAddFieldsFilter = (
    'htmlspecialchars',
    'digits',
    'latindigits',
    'latindigits',
    'picture',
    'digits'
);
our @ModulAddFieldsFilterResult = (
    'notempty',
    'notempty',
    'notempty',
    'notempty',
    'none',
    'notempty'
);

# Resize
our @ModulAddPictureResize = (
    '',
    '',
    '',
    '',
    'small#50#',
    ''
);

# Languages
our @ModulAddLanguagesField = (
    'none',
    'none',
    'none',
    'none',
    'none',
    'none'
);

1;
