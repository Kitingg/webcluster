<VirtualHost *:8080>
    AssignUserID user user
    ServerName site-example.ru
    ServerAlias www.site-example.ru

    DocumentRoot /var/www/metallurg.vsw.ru/
    CustomLog ${APACHE_LOG_DIR}/site-example.ru.access.log combined
    ErrorLog /var/log/apache2/site-example.ru.error.log
</VirtualHost>
