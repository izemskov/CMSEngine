use strict;

=item
Тип модуля - Обычный (core_simple)
=cut

our $HTDOCS_PATH;

our $ModulName = 'Файловый менеджер';
our $ModulTableName = 'text_editor_files';

# Поля выводимые при общем просмотре модуля
our @ModulShowFields = (
    'id',
    'filename'
);

# Тип полей в общем выводе
our @ModulShowType = (
    'text',
    'text'
);

# Output
our @ModulShowHeader = (
    'ID',
    'Имя файла'
);
our @ModulShowHeaderWidth = (
    '80',
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
    'filename'
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

our $ModulShowOrderBy = ' ORDER BY filename ';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данный файл?';
our $ModulFileDeleteMessage = 'Вы уверены, что хотите удалить данный файл?';

our $ModulUploadDirectory = "$HTDOCS_PATH/user_files/images";
our $ModulUploadDirectoryRel = "/user_files/images";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'filename'
);

our @ModulAddFieldType = (
    'file'
);

# Output
our @ModulAddFieldName = (
    'Файл'
);

# Filters
our @ModulAddFieldsFilter = (
    'picture'
);
our @ModulAddFieldsFilterResult = (
    'none'
);

# Resize
our @ModulAddPictureResize = (
);

# Languages
our @ModulAddLanguagesField = (
    'none'
);

1;
