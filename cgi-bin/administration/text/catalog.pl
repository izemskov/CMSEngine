use strict;

our $HTDOCS_PATH;

our $ModulName = 'Каталог';
our $ModulTableName = 'text_catalogs';
our $ModulItemTableName = 'text_catalog_items';

our $TextAddElem = 'Добавить каталог';
our $TextAddSubElem = 'Добавить товар';

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
    'text',
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
our $ModulShowRecursPaddingValue = 0;
our @ModulShowRecursPadding = (
    'nopadding',
    'nopadding',
    'nopadding'
);

# Filters
our @ModulShowFieldsFilter = (
    'none',
    'none',
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

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данный каталог?';
our $ModulFileDeleteMessage = '';

our $ModulUploadDirectory = "";
our $ModulUploadDirectoryRel = "";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'name',
    'description',
    'order_content'
);

our @ModulAddFieldType = (
    'input',
    'big_textarea',
    'input'
);

# Output
our @ModulAddFieldName = (
    'Название',
    'Описание',
    'Порядок'
);

# Filters
our @ModulAddFieldsFilter = (
    'htmlspecialchars',
    'htmlspecialchars',
    'digits'
);
our @ModulAddFieldsFilterResult = (
    'notempty',
    'none',
    'notempty'
);

# Resize
our @ModulAddPictureResize = (
    '',
    '',
    ''
);

# Languages
our @ModulAddLanguagesField = (
    'lang',
    'lang',
    'none'
);

=item
Show Item Foto
=cut
# Delete files
our @ModulItemShowDeleteFileField = (
    'filename',
    'filename1',
    'filename2'
);
our @ModulItemShowDeleteFileResize = (
    'big~~~small',
    'big~~~small',
    'big~~~small'
);

# Fields
our $ModulShowFieldFoto = "filename";
our $ModulShowFieldFotoPreview = "small";

our $ModulShowItemChangeAll = 'no';
our $ModulShowItemIsEdit = 'yes';
our $ModulShowItemIsDelete = 'yes';

our $ModulAddItemIsDeleteFile = 'no';

our $ModulShowItemOrderBy = ' ORDER BY order_content, filename ';

our $ModulShowItemDeleteMessage = 'Вы уверены, что хотите удалить данный товар?';

our $ModulItemUploadDirectory = "$HTDOCS_PATH/files/items";
our $ModulItemUploadDirectoryRel = "/files/items";

=item
Add
=cut
# Fields
our @ModulItemAddFields = (
    'name',
    'catalog_id',
    'filename',
    'filename1',
    'filename2',
    'order_content',
    'small_description',
    'description',
    'meta_title',
    'meta_description',
    'meta_keywords'
);

our @ModulItemAddFieldType = (
    'input',
    'select_modul',
    'file',
    'file',
    'file',
    'input',
    'textarea',
    'big_textarea',
    'textarea',
    'textarea',
    'textarea'
);

# Output
our @ModulItemAddFieldName = (
    'Название',
    'Каталог',
    'Фото',
    'Фото2',
    'Фото3',
    'Порядок',
    'Краткое описание',
    'Описание',
    'Мета-тег заголовки страницы',
    'Мета-тег описание страницы',
    'Мета-тег ключевые слова'
);

# Filters
our @ModulItemAddFieldsFilter = (
    'htmlspecialchars',
    'digits',
    'picture',
    'picture',
    'picture',
    'digits',
    'htmlspecialchars',
    'htmlspecialchars',
    'htmlspecialchars',
    'htmlspecialchars',
    'htmlspecialchars',
);
our @ModulItemAddFieldsFilterResult = (
    'notempty',
    'notempty',
    'notempty',
    'notempty',
    'notempty',
    'notempty',
    'notempty',
    'notempty',
    'none',
    'none',
    'none'
);

# Resize
our @ModulItemAddPictureResize = (
    '',
    '',
    'small#250##no~~~big#400##no',
    'small#190##no~~~big#400##no',
    'small#190##no~~~big#400##no',
    '',
    '',
    '',
    '',
    '',
    ''
);

# Languages
our @ModulItemAddLanguagesField = (
    'lang',
    'langname',
    'none',
    'none',
    'none',
    'none',
    'lang',
    'lang',
    'lang',
    'lang',
    'lang'
);

1;

