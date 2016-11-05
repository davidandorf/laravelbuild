#!/bin/bash
sudo chown -R laradock:laradock .

sudo touch /var/www/laravel/storage/database.sqlite
composer install && composer dump-autoload && php artisan migrate -f && bower install && bower update
ant full-build