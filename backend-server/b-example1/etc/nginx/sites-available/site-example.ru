server {
        listen 8090;
	root /var/www/site-example.ru;
	index index.php;

	server_name site-example.ru www.site-example.ru;
         
	access_log      /var/log/nginx/site-example.ru_access.log;
    error_log       /var/log/nginx/site-example.ru_error.log;


	
	location / {
        	proxy_pass http://127.0.0.1:8080;

                include /etc/nginx/proxy.conf;
                client_max_body_size 20m;
                 
	}
        include /etc/nginx/netcat.conf;
}


