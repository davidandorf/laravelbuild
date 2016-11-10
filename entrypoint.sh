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
sudo touch /var/www/laravel/storage/database.sqlite
cd /var/www/laravel && composer install && composer dump-autoload
apigen generate -s ./app -d ./public/phpdocs

echo "++++++++++++++++++++++ Frontend Build and Docs+++++++++++++++++++++++++"
sudo npm install
bower update
gulp generateDocs
gulp build


ant full-build
