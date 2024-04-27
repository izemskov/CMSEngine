use strict;

our $HTDOCS_PATH;

=item
Тип модуля - Обычный (core_simple)
=cut

our $ModulName = 'Языки';
our $ModulTableName = 'languages';

# Поля выводимые при общем просмотре модуля
our @ModulShowFields = (
    'name',
    'order_content'
);

# Тип полей в общем выводе
our @ModulShowType = (
    'input',
    'input'
);

# Output
our @ModulShowHeader = (
    'Имя',
    'Порядок'
);
our @ModulShowHeaderWidth = (
    '100%',
    '80'
);
our @ModulShowHeaderAlign = (
    'left',
    'center'
);

# Filters
our @ModulShowFieldsFilter = (
    'htmlspecialchars',
    'digits'
);
our @ModulShowFieldsFilterResult = (
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
    'none'
);

our $ModulShowChangeAll = 'yes';
our $ModulShowIsEdit = 'yes';
our $ModulShowIsDelete = 'yes';

our $ModulAddIsDeleteFile = 'no';

our $ModulShowOrderBy = ' ORDER BY order_content, name ';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данный язык? Все заполненные поля для данного языка будут также удалены!';
our $ModulFileDeleteMessage = '';

our $ModulUploadDirectory = "$HTDOCS_PATH/files/languages";
our $ModulUploadDirectoryRel = "/files/languages";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'name',
    'picture',
    'order_content'
);

our @ModulAddFieldType = (
    'input',
    'file',
    'input'
);

# Output
our @ModulAddFieldName = (
    'Название',
    'Картинка',
    'Порядок'
);

# Filters
our @ModulAddFieldsFilter = (
    'htmlspecialchars',
    'picture',
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
    'small#30#',
    ''
);

# Languages
our @ModulAddLanguagesField = (
    'none',
    'none',
    'none'
);

1;
