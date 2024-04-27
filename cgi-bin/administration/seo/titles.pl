use strict;

=item
Тип модуля - Обычный (core_simple)
=cut

our $ModulName = 'Заголовки страниц';
our $ModulTableName = 'seo_titles';

# Поля выводимые при общем просмотре модуля
our @ModulShowFields = (
    'name',
    'translitname',
    'meta_title'
);

# Тип полей в общем выводе
our @ModulShowType = (
    'text',
    'text',
    'text'
);

# Output
our @ModulShowHeader = (
    'Название',
    'Код',
    'Заголовок страницы'
);
our @ModulShowHeaderWidth = (
    '150',
    '150',
    '100%'
);
our @ModulShowHeaderAlign = (
    'center',
    'center',
    'left'
);

# Filters
our @ModulShowFieldsFilter = (
    'none',
    'none',
    'none'
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
    'lang'
);

our $ModulShowChangeAll = 'no';
our $ModulShowIsEdit = 'yes';
our $ModulShowIsDelete = 'yes';

our $ModulAddIsDeleteFile = 'no';

our $ModulShowOrderBy = ' ORDER BY translitname ';

our $ModulShowDeleteMessage = 'Вы уверены, что хотите удалить данный заголовок?';
our $ModulFileDeleteMessage = '';

our $ModulUploadDirectory = "";
our $ModulUploadDirectoryRel = "";

=item
Add
=cut
# Fields
our @ModulAddFields = (
    'name',
    'translitname',
    'meta_title',
    'meta_description',
    'meta_keywords'
);

our @ModulAddFieldType = (
    'input',
    'input',
    'textarea',
    'textarea',
    'textarea'
);

# Output
our @ModulAddFieldName = (
    'Название',
    'Название на транслите',
    'Мета-тег заголовки страницы',
    'Мета-тег описание страницы',
    'Мета-тег ключевые слова'
);

# Filters
our @ModulAddFieldsFilter = (
    'htmlspecialchars',
    'latindigitsdash',
    'htmlspecialchars',
    'htmlspecialchars',
    'htmlspecialchars'
);
our @ModulAddFieldsFilterResult = (
    'notempty',
    'notempty',
    'none',
    'none',
    'none'
);

# Resize
our @ModulAddPictureResize = (
);

# Languages
our @ModulAddLanguagesField = (
    'none',
    'none',
    'lang',
    'lang',
    'lang'
);

1;
