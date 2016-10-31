#!/bin/bash
chown -R laradock:laradock .
su laradock
touch ./storage/database.sqlite
composer install && composer dump-autoload && php artisan migrate -f && bower install && bower update
ant full-build