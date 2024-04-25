use strict;

our %CMS_SETTINGS;

our $DWDB;
our $ACCESS;
our $MAIN_LINK;
our $TOKEN_LINK_FIRST_PARAM;
our $TOKEN_LINK_LAST_PARAM;
our $MOD;
our $USER;
our $HTDOCS_PATH;

print &TemplateMainHeader;

if ($ACCESS eq 'noaccess') {
	print qq{Доступ в данный модуль запрещен. Вернутся на <a href='$MAIN_LINK$TOKEN_LINK_FIRST_PARAM'>главную</a>};
}
elsif ($ACCESS eq 'notoken') {
	print qq{Не задан корректный идентификационный токен};
}
elsif (($ACCESS eq 'nomod') && ($MOD ne '')) {
	print qq{Запрашиваемый модуль не существует. Вернутся на <a href='$MAIN_LINK$TOKEN_LINK_FIRST_PARAM'>главную</a>};
}
elsif ((($ACCESS eq 'nomod') && ($MOD eq '')) || ($ACCESS eq 'yes')) {
	print &ModulIconMenu;
	print &WidgetStatistica;	
	print &WidgetDownloadCounter;
}
else {
	my $MD5 = &AntiSpam;
	print &TemplateLoginForm($MD5);
}

print &TemplateMainFooter;

sub ModulIconMenu {
	my $ReturnText = '';

	my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT
	*
FROM
	}.$DWDB->GetMysqlTableName().qq{cms_struct
WHERE 
	parent_id='0'
ORDER BY
	order_content
	});
	while (my $Content = $sth->fetchrow_hashref()) {
		
		my $SubContentText = '';
		my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT
	cms_struct.*
FROM
	}.$DWDB->GetMysqlTableName().qq{cms_struct AS cms_struct,
	}.$DWDB->GetMysqlTableName().qq{cms_access AS cms_access
WHERE 
	cms_struct.parent_id='$Content->{id}' AND
	cms_access.modul_id=cms_struct.id AND
	cms_access.uid=$USER->{id}
ORDER BY
	cms_struct.order_content
		}); 
		my $i = 0;
		while (my $SubContent = $sth->fetchrow_hashref()) {
			if ($i % 3 == 0) {
				$SubContentText .= qq{
<div class='main_content_fast_ico'>		
				};
			}
			
			$SubContentText .= qq{
	<div class='main_content_fast_ico_icons'>
			};
			
			if (($SubContent->{picture} ne '') && (-e "$HTDOCS_PATH/files/administration/moduls/small/$SubContent->{picture}")) {
				$SubContentText .= qq{
		<center><a href='$MAIN_LINK?mod=$SubContent->{modul}&sub=$SubContent->{sub_modul}$TOKEN_LINK_LAST_PARAM'><img src='/files/administration/moduls/small/$SubContent->{picture}'></a></center>
				};
			}
					
			$SubContentText .= qq{
		<a href='$MAIN_LINK?mod=$SubContent->{modul}&sub=$SubContent->{sub_modul}$TOKEN_LINK_LAST_PARAM' class='main_content_fast_ico_icons'>$SubContent->{name}</a>
	</div>
			};
			
			$i++;
			
			if ($i % 3 == 0) {
				$SubContentText .= qq{
</div>
				};
			}
		}
		$sth->finish();
		
		if (($SubContentText ne '') && ($i % 3 != 0)) {
			$SubContentText .= qq{
</div>
			};
		}
			
		if ($SubContentText ne '') {
			$ReturnText .= qq{
<div class='main_content_fast_ico_text'>
	$Content->{name}
</div>			

$SubContentText
			};
		}
	}
	$sth->finish();
	
	
	return $ReturnText;
}

sub WidgetStatistica {
	my $ReturnText = '';
	
	$ReturnText .= qq{
<div id='main_content_info_table1'>
	<div class='main_content_info_table_header'>
		<div class='main_content_info_table_header_text'>
			Популярные разделы
		</div>
		<div class='main_content_info_table_header_roll_up'>
			<a href='#'><img src='/img/administration/roll_up.png'></a>
		</div>
	</div>
	};
	
	my $StatisticaText = '';
	my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT 
	*
FROM 
	}.$DWDB->GetMysqlTableName().qq{text_content
WHERE 
	count_visits > '0'
ORDER BY
	count_visits DESC, 
	order_content ASC
LIMIT 
	5
	}); 
	while (my $Content = $sth->fetchrow_hashref()) {
		my $Link = '';
		if ($Content->{symbol_link} ne '') {
			$Link = "/content/$Content->{symbol_link}/";
		}
		else {
			$Link = "/content/$Content->{id}.html";	
		}
	
		$StatisticaText .= qq{
			<tr>
			<td height='27' width='290' nowrap>
				<a href='$Link' target='_blank'>}.&GetLanguageContent('', $Content->{name}).qq{</a>
			</td>
			<td height='27' width='80' nowrap align='center'>
				$Content->{count_visits}
			</td>
			</tr>		
		};
	}
	$sth->finish();
	
	$ReturnText .= qq{
	<div class='main_content_info_table'>
	};
	
	if ($StatisticaText ne '') {
		$ReturnText .= qq{
			<table cellpadding='0' cellspacing='0' border='0' width='370'>				
			<tr>
			<td height='27' width='290' nowrap>
				<b>Раздел</b>
			</td>
			<td height='27' width='80' nowrap align='center'>
				<b>Посещения</b>
			</td>
			</tr>
				
			$StatisticaText	
			</table>		
		};
	}

	if ($CMS_SETTINGS{googleanalytics} ne '') {
		$ReturnText .= qq{
		<div id='main_content_info_table_analytics_ico'>
			<a href='http://www.google.com/analytics/' target='_blank'><img src='/img/administration/analytics.png'></a>
		</div>
			
		<div id='main_content_info_table_analytics_text'>
			<a href='http://www.google.com/analytics/' target='_blank'><b>Статистика Google</b></a>
		</div>
		};
	}
	
	$ReturnText .= qq{
	</div>	
</div>	
	};

	return $ReturnText;
}

sub WidgetDownloadCounter {
	my $ReturnText = '';
	
	$ReturnText .= qq{
<div id='main_content_info_table3'>
	<div class='main_content_info_table_header'>
		<div class='main_content_info_table_header_text'>
			Закачки приложений
		</div>
		<div class='main_content_info_table_header_roll_up'>
			<a href='#'><img src='/img/administration/roll_up.png'></a>
		</div>
	</div>
	};
	
	my $StatisticaText = '';
	my $sth = $DWDB->QuerySelectPrepareDB(qq{
SELECT 
	*
FROM 
	}.$DWDB->GetMysqlTableName().qq{download_counter
ORDER BY
	counter DESC
LIMIT 
	5
	}); 
	while (my $Content = $sth->fetchrow_hashref()) {
		$StatisticaText .= qq{
			<tr>
			<td height='27' width='290' nowrap>
				$Content->{filename}
			</td>
			<td height='27' width='80' nowrap align='center'>
				$Content->{counter}
			</td>
			</tr>		
		};
	}
	$sth->finish();
	
	$ReturnText .= qq{
	<div class='main_content_info_table'>
	};
	
	if ($StatisticaText ne '') {
		$ReturnText .= qq{
			<table cellpadding='0' cellspacing='0' border='0' width='370'>				
			<tr>
			<td height='27' width='290' nowrap>
				<b>Файл</b>
			</td>
			<td height='27' width='80' nowrap align='center'>
				<b>Закачки</b>
			</td>
			</tr>
				
			$StatisticaText	
			</table>		
		};
	}
	
	$ReturnText .= qq{
	</div>	
</div>	
	};

	return $ReturnText;
}

1;
