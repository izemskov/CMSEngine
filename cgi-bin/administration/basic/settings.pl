use strict;

=item
Тип модуля - Обычный (core_simple)
=cut

our $ModulName = 'Настройки';
our $ModulTableName = 'settings';

# Поля выводимые при общем просмотре модуля
our @ModulShowFields = (
    'settings_group',
    'name'
);

# Тип полей в общем выводе
our @ModulShowType = (
    'input',
    'input'
);

# Output
our @ModulShowHeader = (
    'Группа',
    'Имя'
);
our @ModulShowHeaderWidth = (
    '150',
    '100%'
);
our @ModulShowHeaderAlign = (
    'center',
    'left'
);

# Filters
our @ModulShowFieldsFilter = (
    'htmlspecialchars',
    'htmlspecialchars'
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

our $ModulShowChangeAll = 'yes';
our $ModulShowIsEdit = 'yes';
our $ModulShowIsDelete = 'yes';

our $ModulAddIsDeleteFile = 'no';

our $ModulShowOrderBy = ' ORDER BY settings_group, name ';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данную настройку?';
our $ModulFileDeleteMessage = '';

our $ModulUploadDirectory = "";
our $ModulUploadDirectoryRel = "";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'settings_group',
    'name',
    'translitname',
    'value'
);

our @ModulAddFieldType = (
    'input',
    'input',
    'input',
    'textarea'
);

# Output
our @ModulAddFieldName = (
    'Группа',
    'Название',
    'Название на транслите',
    'Значение'
);

# Filters
our @ModulAddFieldsFilter = (
    'htmlspecialchars',
    'htmlspecialchars',
    'latindigitsdash',
    'htmlspecialchars'
);
our @ModulAddFieldsFilterResult = (
    'notempty',
    'notempty',
    'notempty',
    'none'
);

# Resize
our @ModulAddPictureResize = (
);

# Languages
our @ModulAddLanguagesField = (
    'none',
    'none',
    'none',
    'lang'
);

1;
