use strict;

our $MYSQL_TABLE_NAME = 'izemskov_';

sub GetConnectData {
    my $mysql_user_db = 'izemskov_u';
    my $mysql_password_db = '1234567890';
    my $mysql_base_name = 'izemskov';
    my $mysql_host_url = 'localhost';

    return ($mysql_user_db, $mysql_password_db, $mysql_base_name, $mysql_host_url);
}

1;
