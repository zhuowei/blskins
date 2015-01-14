#!/bin/sh
my_hostname="blskins.herokuapp.com"
[ `whoami` = zhuowei ] && my_hostname="localhost:$PORT"
cat >nginx.conf << ASDF

error_log stderr crit;
pid `pwd`/nginx.pid;

http {

sendfile on;

upstream appserver {
	server unix:/tmp/blskins.socket;
	keepalive 16;
}

server {
	root "`pwd`";
	listen $PORT;
	server_name $my_hostname;

	access_log off;

	proxy_temp_path "`pwd`/proxy";
	client_body_temp_path "`pwd`/body";
	fastcgi_temp_path "`pwd`/fastcgi";

	location /blskins/ {
	}
	location / {
		proxy_pass http://appserver;
		proxy_http_version 1.1;
		proxy_set_header Connection "";
		proxy_set_header Host "$my_hostname";
	}
}

} # http

events {
	worker_connections 1024;
}

ASDF
./nginx -c nginx.conf -p `pwd`
