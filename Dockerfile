FROM ubuntu:16.04

MAINTAINER "Tien Vo" <tienvv.it@gmail.com>

# Add locales after locale-gen as needed
# Upgrade packages on image
# Preparations for sshd
RUN locale-gen en_US.UTF-8 \
    && apt-get -q update \
    && apt-get install -y net-tools default-jre-headless openssh-server \
    software-properties-common python-software-properties \
    && sed -i 's|session    required     pam_loginuid.so|session    optional     pam_loginuid.so|g' /etc/pam.d/sshd \
    && mkdir -p /var/run/sshd

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8


# run install git, curl, nginx, imagemagick 
RUN add-apt-repository ppa:ondrej/php \
    && apt-get update && apt-get install -y git curl unzip nginx imagemagick \
	&& mkdir -p /var/www

# run install mysql-server
RUN debconf-set-selections <<< 'mysql-server mysql-server/root_password password root' \
	&& debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password root'
	&& apt-get install -y mysql-server

# run install php
RUN apt-get install -y php5.6-fpm php5.6-curl php5.6-gd php5.6-geoip php5.6-imagick \
    php5.6-imap php5.6-json php5.6-ldap php5.6-mcrypt php5.6-redis php5.6-xdebug \
    php5.6-mbstring php5.6-xml php5.6-pdo php5.6-pdo-mysql 

# Configure PHP-FPM
#RUN sed -i "s/;date.timezone =.*/date.timezone = UTC/" /etc/php5.6/fpm/php.ini && \
#    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php5.6/fpm/php.ini && \
#    sed -i "s/display_errors = Off/display_errors = stderr/" /etc/php5.6/fpm/php.ini && \
#    sed -i "s/upload_max_filesize = 2M/upload_max_filesize = 30M/" /etc/php5.6/fpm/php.ini

# run install composer


# Apply Nginx configuration
#ADD config/nginx.conf /etc/nginx/nginx.conf
#ADD config/laravel /etc/nginx/sites-available/laravel
#RUN ln -s /etc/nginx/sites-available/laravel /etc/nginx/sites-enabled/laravel && \
#    rm /etc/nginx/sites-enabled/default

# Set user jenkins to the image
RUN useradd -m -d /home/jenkins -s /bin/sh jenkins &&\
    echo "jenkins:jenkins" | chpasswd

# Standard SSH port
EXPOSE 22

# Default command
#CMD ["/usr/sbin/sshd", "-D"]
#ENTRYPOINT ["/usr/sbin/php-fpm", "-F"]
#ENTRYPOINT ["/usr/sbin/nginx", "-F"]