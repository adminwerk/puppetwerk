#!/bin/bash

# Author:       chris <chris@adminwerk.de>
# Date:         11.03.2012
# Package:      mod-php5-latest
#
# Description:  create a deb package from PHP sources, create a debian file depending
#               on wether CHECK is set to "yes" or simply install the sources in case
#               it is set to "no".
#
# Version:      1.00    prototype
#               1.01    minor fixes and enabling of checkinstall
#               1.02    fixing missing dependencies with some additional libraries
#                       that are going to be installed
#               1.03    test and extended with some pecl stuff (memcache,apc)
#               1.04    added more extension and dependencies
#
#               1.05    create apache2.2 mod based on the php-fpm script
#
# $Id$

# Package informations
PACKAGE=php
VERSION=5.3.10
SRCDIR=/usr/local/src/
USRDIR=/usr/local
PREFIX=$USRDIR/$PACKAGE
ETC=/etc
SCANDIR=$ETC/conf.d

# PECL versions
MEMCACHE_V=""
MEMCACHED_V=""
APC_V=""
HTTP_V=""
JSON_V=""
GEOIP_V=""
IMAGICK_V=""
YAML_V=""
TIDY_V=""
SUHOSIN_V="0.9.33"
MEMTRACK_V="0.2.1"
XDEBUG_V=""
ZIP_V=""
PDFLIB_V="7.0.5"
PDFLIB_RDIR="705"

# Inside this directory all the good stuff happens
SRCTARGET=$SRCDIR$PACKAGE-$VERSION

# Configure parameters set during translation of the package
CONFDIR=/etc/php5
BINDR=/usr/bin
LOGDIR=/var/log/php5
SOCKETDIR=/var/lib/php5/sockets/

# Binaries needed during this process
WGET=`which wget`
APTGET=`which apt-get`
MV=`which mv`
LN=`which ln`
MKDIR=`which mkdir`
CP=`which cp`
TAR=`which tar`
CHMOD=`which chmod`
CHOWN=`which chown`
RM=`which rm`
APXS2=`which apxs2`

# Download and preparation
#DLK=http://de.php.net/get/php-$VERSION.tar.gz/from/this/mirror
cd $SRCDIR
#$WGET $DLK -O $PACKAGE-$VERSION.tar.gz
$TAR xvf $PACKAGE-$VERSION.tar.gz
$CHOWN -R root.root $PACKAGE-$VERSION

# Some extra folders
PAKDIR=$PREFIX/packages
if [ ! -d $PAKDIR ] ; then
        $MKDIR -p $PAKDIR
fi

MODCOMPDIR=$SRCDIR/mods
if [ ! -d $MODCOMPDIR ] ; then
        $MKDIR -p $MODCOMPDIR
fi

# CREATE CONFDIR
#if [ ! -d $CONFDIR ] ; then
#        $MKDIR -p $CONFDIR
#fi

# Compiler stuff
MAKE=`which make`
CONFIGURE=./configure
CHECKINSTALL=`which checkinstall`
MAINTAINER="chris@adminwerk.de"

# [yes/no] to either build a debian file or simply install the sources
CHECK="yes"

# [yes/no] to clean the src directory
CLEAN="no"

# PECL Extensions
# -------------------------------------------------------------------------

# [yes/no] to install memcache.so
# MEMCACHE="yes"
# MEMCACHE_SUMMARY="memcache extension module for PHP5"
# MEMCACHE_PKG_NAME="php5-memcache"

# # [yes/no] to install memcached.so
# MEMCACHED="no"
# MEMCACHED_SUMMARY="memcached extension module for PHP5"
# MEMCACHED_PKG_NAME="php5-memcached"

# # [yes/no] to install apc.so
# APC="yes"
# APC_SUMMARY="apc caching extension module php5"
# APC_PKG_NAME="php5-apc"

# # [yes/no] to install pecl_http
# HTTP="no"
# HTTP_SUMMARY="http module extension for php5"
# HTTP_PKG_NAME="php5-http"

# # [yes/no] to install json
# JSON="yes"
# JSON_SUMMARY="json module extension for php5"
# JSON_PKG_NAME="php5-json"

# # [yes/no] to install geoip
# GEOIP="yes"
# GEOIP_SUMMARY="geoip module extension for php5"
# GEOIP_PKG_NAME="php5-geoip"

# # [yes/no] to install imagick
# IMAGICK="yes"
# IMAGICK_SUMMARY="imagick module extension for php5"
# IMAGICK_PKG_NAME="php5-imagick"

# # [yes/no] to install yaml
# YAML="yes"
# YAML_SUMMARY="yaml module extension for php5"
# YAML_PKG_NAME="php5-yaml"

# # [yes/no] to install tidy
# TIDY="yes"
# TIDY_SUMMARY="tidy module extension for php5"
# TIDY_PKG_NAME="php5-tidy"

# # [yes/no] to install suhosin
# SUHOSIN="yes"
# SUHOSIN_SUMMARY="advanced protection extension module for php5"
# SUHOSIN_PKG_NAME="php5-suhosin"

# # [yes/no] to install memtrack
# MEMTRACK="yes"
# MEMTRACK_SUMMARY="memtrack extension module for php5 to watch (unusually high) memory consumption in PHP scripts"
# MEMTRACK_PKG_NAME="php5-memtrack"
# MEMTRACK_CHANNEL="channel://pecl.php.net/memtrack-$MEMTRACK_V"

# # [yes/no] to install xdebug
# XDEBUG="yes"
# XDEBUG_SUMMARY="xdebug extension module for php5"
# XDEBUG_PKG_NAME="php5-xdebug"

# # [yes/no] to install zip
# ZIP="yes"
# ZIP_SUMMARY="zip management extension module for php5"
# ZIP_PKG_NAME="php5-zip"

# # [yes/no] to install pdf
# PDFLIB="yes"
# PDFLIB_SUMMARY="pdflib support extension module for php5"
# PDFLIB_PKG_NAME="php5-pdf"

# Change to where we start the compiling process
cd $SRCTARGET

# Dependencies, conf and compiler needed
# -------------------------------------------------------------------------
$APTGET -m -q -y install apache2-threaded-dev libc-client2007e-dev libkrb5-dev krb5-config postgresql-server-dev-8.4
$APTGET -m -q -y install libreadline5-dev
$APTGET -m -q -y install checkinstall libbz2-dev libcurl4-openssl-dev libcurl3 libjpeg62-dev libfreetype6-dev
$APTGET -m -q -y install comerr-dev krb5-multidev libgssrpc4 libidn11-dev libkadm5clnt-mit7 libt1-dev libxslt1-dev
$APTGET -m -q -y install libkadm5srv-mit7 libkdb5-4 libkrb5-dev pkg-config libpng12-dev libxpm-dev libxslt1.1
$APTGET -m -q -y install libperl-dev libssl-dev libxcrypt-dev libpng12-dev libldap2-dev libxml2-dev libxml2
$APTGET -m -q -y install bison autoconf build-essential libmcrypt-dev libgdbm-dev libmhash2 libmhash-dev libltdl-dev

# Clean up the src directory right before translation of the source
if [ "$CLEAN" = "yes" ] ; then
        $MAKE clean
fi

# Create the raw installation directory structure to be able to link back (fishy)
if [ -d $PREFIX ] ; then
        $MKDIR -p $PREFIX
fi


# Translate the sources
# -------------------------------------------------------------------------
./configure --prefix=$PREFIX \
        --bindir=$BINDIR \
        --with-config-file-path=$ETC \
        --with-config-file-scan-dir=$SCANDIR \
        --with-pear=$PREFIX/pear \
        --with-apxs2=$APXS2 \
        --enable-bcmath \
        --enable-calendar \
        --enable-dba=shared \
        --enable-exif=shared \
        --enable-ftp=shared \
        --enable-soap=shared \
        --enable-sysvmsg \
        --enable-sysvsem \
        --enable-sysvshm \
        --enable-shmop \
        --enable-zip \
        --enable-mbregex \
        --enable-mbstring \
        --enable-calendar \
        --enable-sqlite-utf8 \
        --enable-sockets \
        --enable-exif \
        --enable-shared \
        --enable-safe-mode \
        --enable-gd-native-ttf \
        --enable-wddx=shared \
        --with-gettext=shared \
        --with-imap=shared \
        --with-imap-ssl=shared \
        --with-openssl=shared \
        --with-kerberos \
        --with-zlib=shared \
        --with-ldap=shared \
        --with-bz2=shared \
        --with-curl=shared \
        --with-curlwrappers=shared \
        --with-gd=shared \
        --with-jpeg-dir=/usr/lib \
        --with-png-dir=/usr/lib \
        --with-sqlite=shared \
        --with-pdo-mysql=shared \
        --with-freetype-dir=/usr/lib \
        --with-xpm-dir=/usr/lib \
        --with-t1lib=shared \
        --with-mcrypt=shared \
        --with-mhash=shared \
        --with-mysql=shared \
        --with-mysql-sock=shared \
        --with-mysqli=/usr/bin/mysql_config \
        --with-mysql=mysqlnd \
        --with-mysqli=mysqlnd \
        --with-pdo-mysql=mysqlnd \
        --with-pgsql=shared \
        --with-readline=shared \
        --with-xsl=shared \

# Compile and install
$MAKE

if [ "$CHECK" = "yes" ] ; then
        $CHECKINSTALL -D --pkgname="mod-php5-apache2.2" --pakdir=$PAKDIR --maintainer=$MAINTAINER --delspec $MAKE install
        echo "creating DEB package 'mod-php5-apache2.2' and install it"
fi




# # Create the directory where the sockets are stored (if it dosn't already exists)
# # -------------------------------------------------------------------------
# if [ ! -d $SOCKETDIR ] ; then
#         $MKDIR -p $SOCKETDIR
# fi

# # Create or make files to configurations
# # -------------------------------------------------------------------------
# $CP $SRCTARGET/php.ini-development $CONFDIR/php.ini-development
# $CP $SRCTARGET/php.ini-production $CONFDIR/php.ini


# # Install PECL packages
# # -------------------------------------------------------------------------
# # Jump back out of the php into the src directory
# cd $MODCOMPDIR


# # [MEMCACHE]
# if [ "$MEMCACHE" = "yes" ]; then
# #       $CHECKINSTALL -D --pkgname=$MEMCACHE_PKG_NAME --maintainer=$MAINTAINER --pakdir=$PAKDIR --delspec $BINDIR/pecl install memcache
#         $BINDIR/pecl install memcache
#         echo "extension=memcache.so" > $CONFDIR/conf.d/memcache.ini
# fi

# # [MEMCACHED]
# if [ "$MEMCACHED" = "yes" ]; then
#         $APTGET install -m -q -y libmemcached-dev
#         $BINDIR/pecl install memcached
#         echo "extension=memcached.so" > $CONFDIR/conf.d/memcached.ini
# fi

# # [APC]
# if [ "$APC" = "yes" ] ; then
#         $BINDIR/pecl install apc
#         echo "extension=apc.so" > $CONFDIR/conf.d/apc.ini
# fi

# # [HTTP]
# if [ "$HTTP" = "yes" ] ; then
#         $BINDIR/pecl install pecl_http
#         echo "extension=http.so" > $CONFDIR/conf.d/http.ini
# fi

# # [IMAGICK]
# if [ "$IMAGICK" = "yes" ] ; then
#         $APTGET install -m -y -q libmagickwand-dev
#         $BINDIR/pecl install imagick
#         echo "extension=imagick.so" > $CONFDIR/conf.d/imagick.ini
#         $APTGET remove libmagickwand-dev
# fi

# # [JSON]
# if [ "$JSON" = "yes" ] ; then
#         $BINDIR/pecl download json
#         $TAR json*.tar
#         $RM -rf json*.tar
#         cd json*
#         $BINDIR/phpize
#         $CONFIGURE
#         $MAKE
#         $MAKE install
#         echo "extension=json.so" > $CONFDIR/conf.d/json.ini
#         cd $MODCOMPDIR
# fi

# # [GEOIP]
# if [ "$GEOIP" = "yes" ] ; then
#         $APTGET install -m -q -y libgeoip-dev
#         $BINDIR/pecl install geoip
#         echo "extension=geoip.so" > $CONFDIR/conf.d/geoip.ini
#         $APTGET remove libgeoip-dev
# fi

# # [YAML]
# if [ "$YAML" = "yes" ] ; then
#         $APTGET install -m -q -y libyaml-dev
#         $BINDIR/pecl install yaml
#         echo "extension=yaml.so" > $CONFDIR/conf.d/yaml.ini
#         $APTGET remove libyaml-dev
# fi

# # [TIDY]
# if [ "$TIDY" = "yes" ] ; then
#         $APTGET install -m -q -y libtidy-dev
#         $BINDIR/pecl download tidy
#         $TAR xvf tidy*.tar
#         $RM -rf tidy*.tar
#         cd tidy*
#         $BINDIR/phpize
#         $CONFIGURE
#         $MAKE
#         $MAKE install
#         echo "extension=tidy.so" > $CONFDIR/conf.d/tidy.ini
#         cd $MODCOMPDIR
#         $RM -rf tidy*
#         $APTGET remove libtidy-dev
# fi

# # [SUHOSIN]
# if [ "$SUHOSIN" = "yes" ] ; then
#         $WGET http://download.suhosin.org/suhosin-$SUHOSIN_V.tgz
#         $TAR xvf suhosin*.tgz
#         $RM -rf suhosin*.tgz
#         cd suhosin*
#         $BINDIR/phpize
#         $CONFIGURE
#         $MAKE
#         $MAKE install
#         echo "extension=suhosin.so" > $CONFDIR/conf.d/suhosin.ini
#         cd $MODCOMPDIR
#         $RM -rf suhosin*
# fi

# # [XDEBUG]
# if [ "$XDEBUG" = "yes" ] ; then
#         $BINDIR/pecl install xdebug
#         echo ";zend_extension=/path/to/xdebug.so" > $CONFDIR/conf.d/xdebug.ini
# fi

# # [MEMTRACK]
# if [ "$MEMTRACK" = "yes" ] ; then
#         $BINDIR/pecl install $MEMTRACK_CHANNEL
#         echo "extension=memtrack.so" > $CONFDIR/conf.d/memtrack.ini
# fi

# # [ZIP]
# if [ "$ZIP" = "yes" ] ; then
#         $BINDIR/pecl install zip
#         echo "extension=zip.so" > $CONFDIR/conf.d/zip.ini
# fi

# # [PDFLIB]
# if [ "$PDFLIB" = "yes" ] ; then
#         $WGET http://www.pdflib.com/binaries/PDFlib/$PDFLIB_RDIR/PDFlib-Lite-$PDFLIB_V.tar.gz
#         $TAR xvf PDFlib*.tar.gz
#         $RM -rf PDFlib*.tar.gz
#         cd PDFlib*
#         $CONFIGURE --prefix=/usr/local/pdflib
#         $MAKE
#         $MAKE install
#         cd $MODCOMPDIR
#         $BINDIR/pecl download pdflib
#         $TAR xvf pdflib*.tar
#         $RM -rf pdflib*.tar
#         cd pdflib*
#         $BINDIR/phpize
#         $CONFIGURE --with-pdflib=/usr/local/pdflib
#         $MAKE
#         $MAKE install
#         echo "extension=pdflib.so" > $CONFDIR/conf.d/pdflib.ini
#         cd $MODCOMPDIR
#         $RM -rf pdflib*
#         $RM -rf PDFlib-Lite*
# fi

# Clean the mods dir
# cd $SRCDIR
# $RM -rf mods

# remove stuff no longer in use
# $APTGET remove checkinstall libbz2-dev libcurl4-openssl-dev libcurl3 libjpeg62-dev libfreetype6-dev
# $APTGET remove comerr-dev krb5-multidev libgssrpc4 libidn11-dev libkadm5clnt-mit7 libt1-dev
# $APTGET remove libkadm5srv-mit7 libkdb5-4 libkrb5-dev pkg-config libpng12-dev libxpm-dev libltdl-dev
# $APTGET remove libperl-dev libssl-dev libxcrypt-dev libpng12-dev libldap2-dev libxml2-dev libxslt1.1
# $APTGET remove bison autoconf build-essential libmcrypt-dev libgdbm-dev libmhash-dev libxslt1-dev
# $APTGET remove libgeoip-dev libv8-dev libyaml-dev libtidy-dev


# $APTGET autoremove


# manual delete, maybe someday we provide an uninstaller for this
# rm -rf /usr/local/php
# rm -rf /etc/php5
# rm -rf /var/log/php5-fpm
