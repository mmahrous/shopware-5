# shopware-5

A docker container image providing all tools required by Shopware 5 for developing and building online shops.
If you would like to set up a local development environment with Vagrant, feel free to use and adapt our
[vagrant-docker-shopware](https://github.com/SliceMeNice/vagrant-docker-shopware) boilerplate.

## Description

This docker container image is based on [slicemenice/php-apache-rewrite](https://github.com/SliceMeNice-Docker/php-apache-rewrite) ([GitHub](https://github.com/SliceMeNice-Docker/php-apache-rewrite), [Docker Hub](https://registry.hub.docker.com/u/slicemenice/php-apache-rewrite/))
which sets up an Apache server with PHP5 and mod_rewrite enabled.

It contains Ant, cURL, git, Composer, and the MySQL client, so you can install and build Shopware 5 following our instructions
at [vagrant-docker-shopware](https://github.com/SliceMeNice/vagrant-docker-shopware).

Besides the PHP extensions required by Shopware, this docker container image also includes Xdebug, so you can use your
favorite IDE to step through and debug PHP scripts.

## Contained Tools

Tool(s)            | Description 
:----------------- | :------------
ant                | required to configure and build Shopware 5
php                | used by Shopware's build.xml to install composer
composer           | not directly required by Shopware 5, as the build will also install a local composer for Shopware, but you can also use it to install Shopware via https://packagist.org/packages/shopware/shopware
curl, git, wget    | necessary to execute tasks defined in Shopware's build.xml and for composer to install dependencies
openjdk-7-jdk      | required by Ant
mysql-client       | required by Shopware's build.xml to connect to the SQL database server located in another docker container
xdebug             | used for debugging PHP
