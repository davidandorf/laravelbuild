#!/bin/bash
whoami
pwd
sudo chown -R laradock:laradock /var/www/laravel
sudo touch /var/www/laravel/storage/database.sqlite
cd /var/www/laravel && composer install && composer dump-autoload && php artisan migrate -f && bower install && bower update
ant full-build
