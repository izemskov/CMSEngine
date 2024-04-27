use strict;

=item
Тип модуля - Обычный (core_simple)
=cut

our $HTDOCS_PATH;

our $ModulName = 'Пользователи';
our $ModulTableName = 'cms_users';

=item
Show
=cut
# Поля выводимые при общем просмотре модуля
our @ModulShowFields = (
    'id',
    'login',
    'email'
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
    'Логин',
    'E-Mail'
);
our @ModulShowHeaderWidth = (
    '40',
    '100%',
    '150'
);
our @ModulShowHeaderAlign = (
    'center',
    'left',
    'left'
);

# Recurs output
our $ModulShowRecursPaddingValue = 0;
our @ModulShowRecursPadding = (
);

# Filters
our @ModulShowFieldsFilter = (
    'none',
    'latindigits',
    'htmlspecialchars'
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
    'none',
    'none'
);

our $ModulShowChangeAll = 'yes';
our $ModulShowIsEdit = 'yes';
our $ModulShowIsDelete = 'yes';

our $ModulAddIsDeleteFile = 'no';

our $ModulShowOrderBy = ' ORDER BY id ';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данного пользователя?';
our $ModulFileDeleteMessage = '';

our $ModulUploadDirectory = "";
our $ModulUploadDirectoryRel = "";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'login',
    'pass',
    'email'
);

our @ModulAddFieldType = (
    'input',
    'password',
    'input'
);

# Output
our @ModulAddFieldName = (
    'Логин',
    'Пароль',
    'E-Mail'
);

# Filters
our @ModulAddFieldsFilter = (
    'latindigits',
    'latindigits',
    'htmlspecialchars'
);
our @ModulAddFieldsFilterResult = (
    'notempty',
    'notempty',
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
    'none',
    'none',
    'none'
);

1;
