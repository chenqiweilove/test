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
    openssl-devel    \
    libxml2-devel  \
    libcurl-devel  \
    libpng-devel \
    libjpeg-turbo-devel  \
    freetype-devel \
    libicu-devel \
    libmcrypt-devel \
    libxslt-devel

#build php-7.1.8
WORKDIR /tmp/src/
ADD src/php/ /tmp/src/
RUN yum -y localinstall epel-release-latest-7.noarch.rpm &&\
    tar -xf php-7.1.8.tar.gz &&\
    yum repolist &&\
    yum -y install $DEPS  &&\
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
    --with-xsl &&\
    make && make install &&\
    rm -rf  /tmp/src/ && yum clean all && rm -rf /var/cache/yum

#ADD php conf
WORKDIR /tmp/src/
ADD src/etc/ /tmp/src/
RUN mkdir -p /opt/php/etc/php-fpm.d &&\
    cp php.ini /opt/php/etc/ &&\
    cp www.conf /opt/php/etc/php-fpm.d/ &&\
    cp php-fpm.conf /opt/php/etc/ &&\
    rm -rf  /tmp/src/

#build php redis extend 
WORKDIR /tmp/src/
ADD src/ext/redis /tmp/src/
RUN tar -xf redis-4.1.1.tgz &&\
    cd redis-4.1.1/ &&\
    phpize &&\
    ./configure --with-php-config=/opt/php/bin/php-config &&\
    make && make install && \
    sed -i '$a\extension = redis.so' /opt/php/etc/php.ini &&\
    rm -rf  /tmp/src/ && yum clean all && rm -rf /var/cache/yum

#build php swoole extend 
WORKDIR /tmp/src/
ADD src/ext/swoole /tmp/src/
RUN tar -xf swoole-4.2.12.tgz &&\
    cd swoole-4.2.12/ &&\
    phpize &&\
    ./configure --with-php-config=/opt/php/bin/php-config &&\
    make && make install &&\
    sed -i '$a\extension = swoole.so' /opt/php/etc/php.ini &&\
    rm -rf  /tmp/src/ && yum clean all && rm -rf /var/cache/yum

#build php yaf extend  
WORKDIR /tmp/src/
ADD src/ext/yaf /tmp/src/
RUN tar -xf yaf-3.0.7.tgz && \
    cd yaf-3.0.7/ && \
    phpize && \
    ./configure --with-php-config=/opt/php/bin/php-config && \
    make && make install && \
    sed -i '$a\extension = yaf.so' /opt/php/etc/php.ini &&\
    rm -rf  /tmp/src/ && yum clean all && rm -rf /var/cache/yum

#build php mssql extend  
WORKDIR /tmp/src/
ADD src/ext/mssql /tmp/src/
RUN yum -y localinstall unixODBC-2.3.7-1.rh.x86_64.rpm unixODBC-devel-2.3.7-1.rh.x86_64.rpm &&\
    ACCEPT_EULA=Y yum -y localinstall msodbcsql17-17.3.1.1-1.x86_64.rpm &&\
    ACCEPT_EULA=Y yum -y localinstall mssql-tools-17.3.0.1-1.x86_64.rpm &&\
    tar -xf pdo_sqlsrv-5.6.0.tgz &&\
    cd pdo_sqlsrv-5.6.0 &&\
    phpize && \
    ./configure --with-php-config=/opt/php/bin/php-config &&\
    make && make install &&\
    cd /tmp/src/ &&\
    tar -xf sqlsrv-5.6.0.tgz &&\
    cd sqlsrv-5.6.0 &&\
    phpize &&\
    ./configure --with-php-config=/opt/php/bin/php-config &&\
    make && make install &&\
    sed -i '$a\extension = sqlsrv.so\nextension = pdo_sqlsrv.so' /opt/php/etc/php.ini &&\
    rm -rf  /tmp/src/ && yum clean all && rm -rf /var/cache/yum


EXPOSE 9000
CMD ["php-fpm", "-F"]

