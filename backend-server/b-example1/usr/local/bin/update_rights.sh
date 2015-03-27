#!/bin/bash
chown -R uesr:uesr /etc/apache2
chown -R uesr:uesr /etc/nginx
chown -R uesr:webdev /var/www
find /var/www -type f -exec chmod 644 {} +
find /var/www -type d -exec chmod 755 {} +
echo "Complited"
