use strict;

our $HTDOCS_PATH;

=item
Тип модуля - Обычный (core_simple)
=cut

our $ModulName = 'Значения языков';
our $ModulTableName = 'languages_values';

# Поля выводимые при общем просмотре модуля
our @ModulShowFields = (
    'id',
    'value'
);

# Тип полей в общем выводе
our @ModulShowType = (
    'text',
    'input'
);

# Output
our @ModulShowHeader = (
    'ID',
    'Имя'
);
our @ModulShowHeaderWidth = (
    '40',
    '100%'
);
our @ModulShowHeaderAlign = (
    'center',
    'left'
);

# Filters
our @ModulShowFieldsFilter = (
    'none',
    'none'
);
our @ModulShowFieldsFilterResult = (
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
    'none'
);

our $ModulShowChangeAll = 'no';
our $ModulShowIsEdit = 'yes';
our $ModulShowIsDelete = 'yes';

our $ModulAddIsDeleteFile = 'no';

our $ModulShowOrderBy = ' ORDER BY id';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данное значение языка?';
our $ModulFileDeleteMessage = '';

our $ModulUploadDirectory = "";
our $ModulUploadDirectoryRel = "";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'value'
);

our @ModulAddFieldType = (
    'big_textarea'
);

# Output
our @ModulAddFieldName = (
    'Значение'
);

# Filters
our @ModulAddFieldsFilter = (
    'htmlspecialchars'
);
our @ModulAddFieldsFilterResult = (
    'notempty'
);

# Resize
our @ModulAddPictureResize = (
    ''
);

# Languages
our @ModulAddLanguagesField = (
    'none'
);

1;

