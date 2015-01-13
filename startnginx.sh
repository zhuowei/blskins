#!/bin/sh
cat >nginx.conf << ASDF

error_log stderr crit;
pid `pwd`/nginx.pid;

http {

sendfile on;

server {
	root "`pwd`";
	listen $PORT;
	server_name blskins.herokuapp.com;

	access_log off;

	proxy_temp_path "`pwd`/proxy";
	client_body_temp_path "`pwd`/body";
	fastcgi_temp_path "`pwd`/fastcgi";

	location /blskins/ {
	}
	location / {
		proxy_pass http://unix:/tmp/blskins.socket:/;
	}
}

} # http

events {
	worker_connections 1024;
}

ASDF
./nginx -c nginx.conf -p `pwd`
