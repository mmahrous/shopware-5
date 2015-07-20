FROM slicemenice/php-apache-rewrite


RUN apt-get update && apt-get install -y \
        curl \
        git \
        wget \
        ant \
        libpng12-dev \
        libjpeg-dev \
        zlib1g-dev \
        openjdk-7-jdk \
        mysql-client \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysql mysqli zip mbstring pdo pdo_mysql


RUN pecl install xdebug
RUN touch /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_enable=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_autostart=0 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_connephpct_back=1 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_port=9000 >> /usr/local/etc/php/conf.d/xdebug.ini; \
    echo xdebug.remote_log=/tmp/php5-xdebug.log >> /usr/local/etc/php/conf.d/xdebug.ini;


# install composer
ENV COMPOSER_HOME /root/composer
ENV COMPOSER_VERSION 1.0.0-alpha10

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION}