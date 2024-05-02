FROM centos:centos7.9.2009

RUN yum update -y
RUN yum install httpd -y

CMD bash -c "httpd -DFOREGROUND"