FROM centos
ENV PATH /opt/php/bin/:/opt/php/sbin/:$PATH 
ENV DEPS \
	autoconf \
        dpkg-dev dpkg \
        file \
        gcc \
	gcc-c++ \
        make \
        pkgconf \
        re2c \
	openssl-devel      \
        libxml2-devel  \
        libcurl-devel  \
	libpng-devel \
	libjpeg-turbo-devel  \
	freetype-devel \
	libicu-devel \
	libmcrypt-devel \
	libxslt-devel
WORKDIR /tmp/src/
ADD src/ /tmp/src/
RUN rm -rf /etc/yum.repos.d/* &&\
    cp epel.repo /etc/yum.repos.d/ &&\
    tar -xf php-7.1.8.tar.gz &&\
    yum repolist &&\
    yum -y install $DEPS  && \
    cd php-7.1.8 &&\
    ./configure  \
    --prefix=/opt/php  \
    --with-config-file-path=/opt/php/etc  \
    --with-config-file-scan-dir=/opt/php/etc/conf.d  \
    --enable-fpm  \
    --enable-mysqlnd  \
    --with-mysqli=mysqlnd  \
    --with-pdo-mysql=mysqlnd  \
    --with-iconv-dir  \
    --with-freetype-dir=/usr \
    --with-jpeg-dir  \
    --with-png-dir  \
    --with-zlib  \
    --with-libxml-dir=/usr \
    --enable-xml \
    --disable-rpath \
    --enable-bcmath \
    --enable-shmop \
    --enable-sysvsem \
    --enable-inline-optimization \
    --with-curl     \
    --enable-mbregex    \
    --enable-mbstring \
    --enable-intl   \
    --with-mcrypt   \
    --enable-ftp    \
    --with-gd   \
    --enable-gd-native-ttf \
    --with-openssl  \
    --with-mhash    \
    --enable-pcntl   \
    --enable-sockets  \
    --with-xmlrpc   \
    --enable-zip    \
    --enable-soap   \
    --with-gettext  \
    --disable-fileinfo \
    --enable-opcache \
    --with-xsl && \
    make && make install &&\
    cd /tmp/src/ &&\
    tar -xf redis-4.1.1.tgz && \
    tar -xf swoole-4.2.12.tgz && \
    tar -xf yaf-3.0.7.tgz && \
    cd redis-4.1.1/ && \
    phpize && \
    ./configure --with-php-config=/opt/php/bin/php-config && \
    make && make install && \
    cd /tmp/src/yaf-3.0.7 && \
    phpize && \
    ./configure --with-php-config=/opt/php/bin/php-config && \
    make && make install && \
    cd /tmp/src/swoole-4.2.12 &&\
    phpize && \
    ./configure --with-php-config=/opt/php/bin/php-config && \
    make && make install  &&\
    rm -rf  /tmp/src/ && yum clean all && rm -rf /var/cache/yum

EXPOSE 9000
CMD ["php-fpm", "-F"]
