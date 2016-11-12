#!/bin/bash
whoami
pwd
php -v
node -v
npm -v
gulp -v
bower -v
apigen -v

sudo chown -R laradock:laradock /var/www/laravel
chmod +x /var/www/laravel/build.sh
/var/www/laravel/build.sh
