FROM slicemenice/php-apache-rewrite

RUN a2enmod ssl

# ant              - required to configure and build Shopware 5
# composer         - not directly required by Shopware 5, as the build will also install a local composer for Shopware, but you can also use it to install Shopware via https://packagist.org/packages/shopware/shopware
# curl, git, wget  - necessary to execute tasks defined in Shopware's build.xml and for composer to install dependencies
# openjdk-7-jdk    - required by Ant
# mysql-client     - required by Shopware's build.xml to connect to the SQL database server located in another docker container
# xdebug           - used for debugging PHP

RUN apt-get update && apt-get install -y \
        ant \
        curl \
        git \
        libfreetype6-dev \
        libjpeg-dev \
        libpng12-dev \
        libssl-dev \
        libxml2-dev \
        mysql-client \
        openjdk-7-jdk \
        wget \
        zlib1g-dev \
    && rm -rf /var/lib/apt/lists/* \
    && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-png-dir=/usr --with-jpeg-dir=/usr \
    && docker-php-ext-install gd mysql mysqli zip mbstring pdo pdo_mysql soap ftp


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


# install node/npm

# verify gpg and sha256: http://nodejs.org/dist/v0.10.30/SHASUMS256.txt.asc
# gpg: aka "Timothy J Fontaine (Work) <tj.fontaine@joyent.com>"
# gpg: aka "Julien Gilli <jgilli@fastmail.fm>"
RUN gpg --keyserver pool.sks-keyservers.net --recv-keys 7937DFD2AB06298B2293C3187D33FF9D0246406D 114F43EE0176B71C7BC219DD50A3051F888C628D

ENV NODE_VERSION 0.12.7
ENV NPM_VERSION 3.0-latest

RUN curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-x64.tar.gz" \
    && curl -SLO "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
    && gpg --verify SHASUMS256.txt.asc \
    && grep " node-v$NODE_VERSION-linux-x64.tar.gz\$" SHASUMS256.txt.asc | sha256sum -c - \
    && tar -xzf "node-v$NODE_VERSION-linux-x64.tar.gz" -C /usr/local --strip-components=1 \
    && rm "node-v$NODE_VERSION-linux-x64.tar.gz" SHASUMS256.txt.asc \
    && npm install -g npm@"$NPM_VERSION" \
    && npm cache clear


# install grunt
RUN npm install -g grunt-cli