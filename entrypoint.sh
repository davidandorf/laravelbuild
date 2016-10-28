#!/bin/bash

touch ./storage/database.sqlite
chown -R laradock:laradock . && composer install && composer dump-autoload && php artisan migrate -f && bower install && bower update
ant full-build