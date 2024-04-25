use Digest;
use Digest::MD5 qw(md5_hex);
use Digest::SHA qw(sha256_hex);
use strict;

our $DWFilter;
our $DWDB;
our $TOKEN;
our $MOD;
our $SUB; 
our $ACCESS;
our $ACCESS_LEVEL;
our $SALT;
our $USER;
our $CGIBIN_PATH;
our $MAIN_LINK;

# Проверяем что в сессии есть только допустимые символы
my $user_session = $DWFilter->GetCookieFilterLatinDiget("admin_session");
my $user_token = $DWFilter->GetParamFilterLatinDiget("token");

if ($user_session eq '') {                
    # Генерируем пользовательскую сессию
    &StartSession; 
}
else {
    # Проверяем есть ли запись в базе
    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().qq{cms_sessions WHERE sess_id=?}, $user_session);
    
    if ($Count > 0) {
        my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().qq{cms_sessions WHERE sess_id=?}, $user_session);
        my $Content = $sth->fetchrow_hashref();
        $sth->finish();
        
        my $now_time = time;
        $DWDB->QueryDoDB(qq{UPDATE }.$DWDB->GetMysqlTableName().qq{cms_sessions SET sess_time='$now_time' WHERE sess_id=?}, $user_session);
        
        $TOKEN = $Content->{token};
    
        &GetUserInfo($Content->{uid});
    }
    else {
        &StartSession;	
    }
}

=item
Создаем пользовательскую сессию
=cut
sub StartSession {
    # Генератор случайных чисел
    &InitRand; 	
     
    # Генерим уникальный хеш
    my $Count;
    my $string = '';
    do {
        $string = $ENV{'HTTP_USER_AGENT'}.rand().$ENV{'REMOTE_ADDR'}.rand().$ENV{'HTTP_REFERER'}.rand().time.rand();	
        $string = md5_hex($string);				
        ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().qq{cms_sessions WHERE sess_id=?}, $string);
    } while ($Count > 0);
     
    my $now_time = time;

    # Пишем в базу
    $DWDB->QueryDoDB(qq{INSERT INTO }.$DWDB->GetMysqlTableName().qq{cms_sessions SET sess_id=?, sess_start_time='$now_time', sess_time='$now_time', uid='-1'}, $string);	

    my $cookie = $DWFilter->{_CGI}->cookie(-name=>'admin_session',
                        -value=>"$string",
                        -path=>'/');
}

=item
Собираем информацию о пользователе
=cut
sub GetUserInfo {                
    my $uid = shift;	
    
    if (($uid ne '') && ($uid >= 0)) {	
        my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().qq{cms_users WHERE id=?}, $uid); 
    
        if ($Count > 0) {
            if (($user_token ne $TOKEN) || ($TOKEN eq '')) {
                $ACCESS = 'notoken';
            }
            else {							
                my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT id, login, email FROM }.$DWDB->GetMysqlTableName().qq{cms_users WHERE id=?}, $uid);
                $USER = $sth->fetchrow_hashref();
                $sth->finish();	
            
                if (($MOD eq '') || ($SUB eq '')) {
                    $ACCESS = 'nomod';
                }
                else {
                    # Проверка существования выбранного модуля
                    my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().qq{cms_struct WHERE modul=? AND sub_modul=?}, $MOD, $SUB); 
                    if ($Count > 0) {					
                        # Проверка существования файлов модуля
                        if ((-e "$CGIBIN_PATH/$MOD/core.pl") && (-e "$CGIBIN_PATH/$MOD/$SUB.pl")) {
                            # Проверка наличия доступа в модуль
                            my ($ModulID) = $DWDB->QuerySelectRowDB(qq{SELECT id FROM }.$DWDB->GetMysqlTableName().qq{cms_struct WHERE modul=? AND sub_modul=?}, $MOD, $SUB);
                        
                            my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().qq{cms_access WHERE modul_id='$ModulID' AND uid='$USER->{id}'});
                            if ($Count > 0) {
                                $ACCESS = 'yes';
                            
                                my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT access_add, access_edit, access_delete FROM }.$DWDB->GetMysqlTableName().qq{cms_access WHERE modul_id='$ModulID' AND uid='$USER->{id}'});
                                $ACCESS_LEVEL = $sth->fetchrow_hashref();
                                $sth->finish(); 
                            }		
                            else {
                                $ACCESS = 'noaccess';
                            }
                        }
                        else {
                            $ACCESS = 'nomod';
                        }
                    }
                    else {						
                        $ACCESS = 'nomod';
                    }					
                }	
            }
        }		
    }
}

=item
Авторизация
=cut
sub Login {
    my $login = $DWFilter->GetParamFilterLatinDiget("login");
    my $pass = $DWFilter->GetParamFilterLatinDiget("pass");
    my $captcha = $DWFilter->GetParamFilterLatinDiget("captcha");
    my $md5 = $DWFilter->GetParamFilterLatinDiget("md5");	
                
    if (($login ne '') && ($pass ne '') && ($captcha ne '')) { 
        my ($CaptchaStr) = $DWDB->QuerySelectRowDB(qq{SELECT string FROM }.$DWDB->GetMysqlTableName().qq{captcha WHERE md5=? LIMIT 1}, $md5);
        if ($captcha eq $CaptchaStr) {
            $pass = &GetCryptPassword($pass);
            
            my ($Count) = $DWDB->QuerySelectRowDB(qq{SELECT count(*) FROM }.$DWDB->GetMysqlTableName().qq{cms_users WHERE login=? AND pass=?}, $login, $pass);		
        
            if ($Count > 0) {					
                my $sth = $DWDB->QuerySelectPrepareDB(qq{SELECT * FROM }.$DWDB->GetMysqlTableName().qq{cms_users WHERE login=? AND pass=?}, $login, $pass);
                my $Content = $sth->fetchrow_hashref();
                $sth->finish();
            
                my $token = $Content->{login}.rand().$ENV{'REMOTE_ADDR'}.rand().$ENV{'HTTP_REFERER'}.rand().time.rand();	
                $token = md5_hex($token);
            
                my $now_time = time;				
                
                $DWDB->QueryDoDB(qq{UPDATE }.$DWDB->GetMysqlTableName().qq{cms_sessions SET uid='$Content->{id}', token=? WHERE sess_id=?}, $token, $user_session);
                $DWDB->QueryDoDB(qq{INSERT INTO }.$DWDB->GetMysqlTableName().qq{cms_sessions_log SET login_time='$now_time', uid='$Content->{id}'});
                
                $TOKEN = $token;
                $user_token = $token;
            
                &GetUserInfo($Content->{id});
            }	
        }		
    }	
}

sub Logout {
    $DWDB->QueryDoDB(qq{UPDATE }.$DWDB->GetMysqlTableName().qq{cms_sessions SET uid='-1', token='' WHERE sess_id=?}, $user_session);
    
    print qq{<meta http-equiv="Refresh" content="0; URL=$MAIN_LINK">};
}

sub AntiSpam {
    # Генерируем строку
    my $string = &RandomString(6, "yes~~~no~~~yes");
    my $now_time = time;
    my $md5 = md5_hex("$now_time$string$now_time");
    
    $DWDB->QueryDoDB(qq{INSERT INTO }.$DWDB->GetMysqlTableName().qq{captcha SET md5='$md5', string='$string', create_time='$now_time'});
    
    return $md5; 
}

sub GetCryptPassword {
    my $pass = shift;

    return sha256_hex($pass . $SALT);
}

1;
