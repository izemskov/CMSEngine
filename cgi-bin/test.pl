#!/usr/bin/perl

use DBI;
use strict;
use CGI::Carp qw(fatalsToBrowser);

print "Content-type: text/html\n\n";
print "<h2>Hello world!</h2>";

my $dbh = DBI->connect("DBI:mysql:izemskov:host.docker.internal",
       "izemskov_u", "1234567890") or die "Error connecting to database";

my $sth = $dbh->prepare("SELECT * FROM izemskov_captcha");
$sth->execute();
while (my $content = $sth->fetchrow_hashref()) {
    print qq{
        id: $content->{id}</br>
        string: $content->{string}</br>
        md5: $content->{md5}</br></br>
    };
}
$sth->finish();

$dbh->disconnect();
