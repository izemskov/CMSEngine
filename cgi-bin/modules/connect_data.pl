use strict;

our $MYSQL_TABLE_NAME = 'develgame_';

sub GetConnectData {
	my $mysql_user_db = 'develgame_u';
	my $mysql_password_db = 'ienig4i43nd';
	my $mysql_base_name = 'develgame';
	my $mysql_host_url = 'localhost';
	
	return ($mysql_user_db, $mysql_password_db, $mysql_base_name, $mysql_host_url);
}

1;
