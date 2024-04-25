use Time::HiRes;
use GD;
use strict;
use IO::Uncompress::Unzip qw($UnzipError);
use File::Spec::Functions qw(splitpath);
use Image::Magick;

=item
Инициализируем генератор случайных чисел
=cut
sub InitRand {
	my ($seconds, $microseconds) = Time::HiRes::gettimeofday;
	
	srand($microseconds);
}

=item
РАНДОМ ВОЗВРАЩАЮЩИЙ СТРОЧКУ
1. Количество символов в результате
2. Тип используемых символов (yes~~~yes~~~yes, цифры~большие буквы~маленькие буквы)
=cut
sub RandomString {
	my $col_rand = shift;
	my $type = shift;

	my ($dig, $big_text, $small_text) = split(/~~~/, $type);

	my @a = ();
	my @b = ();

	if($dig eq "yes") {
		push @a, (0..9);
	}
	
	if($big_text eq "yes") {
		push @a, ('A'..'Z');
	}
	if($small_text eq "yes") {   	
		push @a, ('a'..'z');
	}	

	while ($col_rand > 0) {
		push @b,  $a[rand(@a)]; 
		$col_rand--;
	}
     
	my $rand_string = join("", @b);
	return $rand_string;
} 

=item
Получение даты и времени из секунд с начала эпохи

Входящие параметры:
1. Дата в секундах с начала эпохи
=cut
sub GetDataTime {
	my $time = shift;

	my ($sec, $min, $hour, $day, $month, $year) = (localtime($time)) [0,1,2,3,4,5];

	if ($day < 10) {
		$day = "0$day";
	}
	
	$month = $month + 1;
	if($month < 10) {
		$month = "0$month";
	}
	
	if ($min < 10) {
		$min = "0$min";
	}
	
	if ($sec < 10) {
		$sec = "0$sec";
	}
	
	$year = $year + 1900;

	return ($sec, $min, $hour, $day, $month, $year);
}

=item
Присутствие элемента в массиве

Входные параметры:
1. Искомая в массиве переменная
2. Массив в котором искать
=cut
sub ExistInArray {  
	my @array = @_;

	for (my $i = 1; $i <= $#array; $i++) {
		if($array[0] eq $array[$i]) {
	        return 1;
 		}
	}
	
	return 0;
} 

sub UploadFile {
	my $UploadFile = shift;
	my $UploadTmpFileName = shift;
	my $Directory = shift;
	
	$UploadFile =~ /(.+)\.(.+)/i;
	my $file_name = $1;
	my $file_ext = lc($2);
	
	my $file_name_new = "$file_name.$file_ext";
	
	my $i = 0;
	while (-e "$Directory/$file_name_new") {
 	 	$i++;
  		$file_name_new = "$file_name\_$i.$file_ext";
  	}
	
	my $buffer;
	
	open (IN, "$UploadTmpFileName");                       
	open (OUT, ">$Directory/$file_name_new");       		    
	binmode (IN);                              
	binmode (OUT);                             
	sysread (IN, $buffer, -s IN);               
	print OUT $buffer;                        
	close (IN);                                
	close (OUT);
	
	chmod (0600, "$Directory/$file_name_new");
	
	return $file_name_new;
}

sub GetGDImageByExt {
	my $FileName = shift;
	
	$FileName =~ /(.+)\.(.+)/i;
	my $im = '';
	my $FileExt = $2;
	
	if ($FileExt =~ /^jpg$/i) {
		$im = GD::Image->newFromJpeg($FileName);
	}
	elsif ($FileExt =~ /^png$/i) {
		$im = GD::Image->newFromPng($FileName);
	}
	elsif ($FileExt =~ /^gif$/i) {
		$im = GD::Image->newFromGif($FileName);
	}
	
	return $im;
}

sub ResizePicture {
	my $FileName = shift;
	my $Directory = shift;
	my $ResizeValue = shift;	
	
	if (-e "$Directory/$FileName") {		
		my ($DirectoryResize, $NewWidth, $NewHeight, $Watermark) = split(/#/, $ResizeValue);
		
		my $q = Image::Magick->new;
		my $x = $q->Read("$Directory/$FileName");
		
		if ($x ne '') {
			return '';
		}
		
		$FileName =~ /(.+)\.(.+)/i;
		my $FileExt = $2;
		
		my ($Width, $Height) = $q->Get('width', 'height');
	
		my $UseCrop = 'no';
		my $CropWidth = 0;
		my $CropHeight = 0;
		
		if (($NewWidth eq '') && ($NewHeight eq '')) {
			$NewWidth = $Width;
			$NewHeight = $Height;			
		}		
		elsif (($NewWidth ne '') && ($NewHeight ne '')) {
			$CropWidth = $NewWidth;
			$CropHeight = $NewHeight;
			$UseCrop = 'yes';
		
			$NewHeight = $Height * ($NewWidth * 100 / $Width) / 100;										
		}
		else {	
			if ($NewWidth eq "") {
				$NewWidth = $Width * ($NewHeight * 100 / $Height) / 100;				
			} 
			
			if ($NewHeight eq "") {	
				$NewHeight = $Height * ($NewWidth * 100 / $Width) / 100;				
			}
		}
		
		# Добавляем водяной знак
		if ($Watermark eq 'yes') {
			&WaterMarkToPicture($q);
		}
				
		if ($UseCrop eq 'yes') {
			$q->Scale(width=>($NewWidth), height=>($NewHeight));					
			
			my $Crop = Image::Magick->new;
			$Crop->Set(size=>"$CropWidth".'x'."$CropHeight");
			$Crop->ReadImage('xc:#000000');
			
			$Crop->Composite(image=>$q, gravity=>'North', background=>'#000000');
			
			$Crop->Write("$Directory/$DirectoryResize/$FileName");
			undef $Crop;
		}
		else {
			$q->Scale(width=>($NewWidth), height=>($NewHeight));
			$q->Write("$Directory/$DirectoryResize/$FileName");
		}
		
		chmod (0600, "$Directory/$DirectoryResize/$FileName");
			
		undef $q;
	}
}

sub WaterMarkToPicture {
	my $im = shift;
	
	our $WATERMARK;
	our $WATERMARK_COLOR;
	
	if ($im ne '') {
		$im->Annotate(text=>"$WATERMARK", pointsize=>"200", fill=>"$WATERMARK_COLOR", gravity=>'SouthEast', x=>'30', y=>'15');
	}
}	

sub GetPictureSize {
	my $FileName = shift;
	
	if (-e "$FileName") {
		my $im = GetGDImageByExt("$FileName");
		my ($Width, $Height) = $im->getBounds();
		undef $im;
		
		return ($Width, $Height);
	}
}

sub SendTextMail {
	my $to = shift;
    my $from = shift;
    my $subject = shift;
    my $message = shift;

    open MAIL, "|/usr/sbin/sendmail -t";
    print MAIL "From: $from\n",
               "To: $to\n",
               "Content-type: text/plain; charset=utf-8\n",
               "Subject: $subject\n\n",
                $message;
    close MAIL or die "Sendmail failed: $!";
}

sub UnZip {
	my $file = shift;
	my $dest = shift;
	
	unless (-e "$file") {
		return ();
	}
	
	my $u = IO::Uncompress::Unzip->new($file) or return ();
	
	my @ProcessFiles = ();
	
	my $status;
	for ($status = 1; $status > 0; $status = $u->nextStream()) {
		my $header = $u->getHeaderInfo();
		my (undef, $path, $name) = splitpath($header->{Name});
		my $destdir = "$dest/$path";

		unless (-d $destdir) {
			undef $u;
			return @ProcessFiles;
		}

		if ($name =~ m!/$!) {
			last if $status < 0;
			next;
		}

		my $destfile = "$dest/$path/$name";
		my $buff;
		my $fh = IO::File->new($destfile, "w")
			or return @ProcessFiles;
		while (($status = $u->read($buff)) > 0) {
			$fh->write($buff);
		}
		$fh->close();
		undef $fh;

		push(@ProcessFiles, $name);
	}
	
	undef $u;
    
	if ($status < 0) {
		return @ProcessFiles;
	}
	
	return @ProcessFiles;
}

1;
