FROM centos:centos7.9.2009

RUN yum update -y
RUN yum install httpd -y
RUN yum install perl perl-CGI -y

COPY cgi-bin/test.pl /var/www/cgi-bin/
RUN chmod 755 /var/www/cgi-bin/test.pl

CMD bash -c "httpd -DFOREGROUND"