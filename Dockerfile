FROM phusion/baseimage:latest

MAINTAINER Hammad Ahmed <hammad@brokergenius.com>

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN apt-get update

#
#---------------------------------------------------
# First Setting up locale to include utf8 charset
#---------------------------------------------------
#
#
#
RUN apt-get install -y language-pack-en-base
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8


ARG PUID=1000
ARG PGID=1000
RUN groupadd -g $PGID laradock && \
    useradd -u $PUID -g laradock -m laradock


RUN apt-get install -y software-properties-common && \
    add-apt-repository -y ppa:ondrej/php && \
    add-apt-repository ppa:webupd8team/java -y \
    apt-get update


RUN apt-get -y install php7.0 php7.0-gd php7.0-ldap \
    php7.0-sqlite php7.0-pgsql php-pear php7.0-mysql \
    php7.0-mcrypt php7.0-xmlrpc php7.0-cli php7.0-curl \
    php7.0-json php7.0-odbc php7.0-tidy php7.0-imap \
    php7.0-redis php7.0-intl php7.0-pgsql php7.0-mongodb \
    php7.0-sybase php7.0-zip sendmail supervisor \
    oracle-java7-installer \
    && mkdir /run/php

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle



# Installs Ant
ENV ANT_VERSION 1.9.4
RUN cd && \
    wget -q http://archive.apache.org/dist/ant/binaries/apache-ant-${ANT_VERSION}-bin.tar.gz && \
    tar -xzf apache-ant-${ANT_VERSION}-bin.tar.gz && \
    mv apache-ant-${ANT_VERSION} /opt/ant && \
    rm apache-ant-${ANT_VERSION}-bin.tar.gz
ENV ANT_HOME /opt/ant
ENV PATH ${PATH}:/opt/ant/bin

USER laradock

ARG NODE_VERSION=stable
ENV NODE_VERSION ${NODE_VERSION}
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.6/install.sh | bash && \
        . $NVM_DIR/nvm.sh && \
        nvm install ${NODE_VERSION} && \
        nvm use ${NODE_VERSION} && \
        nvm alias ${NODE_VERSION} && \
        npm install -g gulp gulp-cli bower vue-cli \


# Install composer and add its bin to the PATH.
RUN curl -s http://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

#Installing php build packages

RUN composer global require phpunit/phpunit && \
    composer global require phpunit/dbunit && \
    composer global require phing/phing && \
    composer global require phpdocumentor/phpdocumentor && \
    composer global require sebastian/phpcpd && \
    oomposer global require phploc/phploc && \
    composer global require phpmd/phpmd && \
    composer global require squizlabs/php_codesniffer && \
    composer globalrequire "codeception/codeception:*" \
    echo "export PATH=${PATH}:~/.composer/vendor/bin" >> ~/.bashrc


RUN . ~/.bashrc

WORKDIR /var/www/laravel

RUN touch ./storage/database.sqlite
RUN chown -R laradock:laradock . && composer install && composer dump-autoload && php artisan migrate -f && bower install && bower update
RUN ant full-build
