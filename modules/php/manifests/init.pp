# = Class: php
#
# This module compiles, installs and configures a fresh version
# of PHP
#
# == Parameters:
#
# == Actions:
#
# == Requires:
# 	apache2-prefork to be present
#
# == Sample Usage: 
#	include php
#
class php {

	# a couple of informations that we require to be able to install 
	# this stuff accordingly
	$inst_prefix="/usr/local/php"
	$inst_bindir="/usr/bin"
	$confdir="/etc/php5"
	$bindir="/usr/bin"

	# This is the section where we include all the dependencies. 
	# we need to ensure that the compile environement stands up
	package { 
		[ "apache2-prefork-dev","libc-client2007e-dev","libkrb5-dev","postgresql-server-dev-8.4","libreadline5-dev","libbz2-dev","libcurl4-openssl-dev","libcurl3","libjpeg62-dev","libfreetype6-dev","comerr-dev","libgssrpc4","libidn11-dev","libkadm5clnt-mit7","libt1-dev","libxslt1-dev","libkdb5-4","pkg-config","libpng12-dev","libxpm-dev","libxslt1.1","libperl-dev","libssl-dev","libxcrypt-dev","libldap2-dev","libxml2-dev","libxml2","bison","autoconf","build-essential","libmcrypt-dev","libgdbm-dev","libmhash2","libmhash-dev","libltdl-dev"]:
			ensure => "present";
	} # package

	# create symlinks and files required
	file { 
		"${php::confdir}":
			ensure => symlink,
			target => "${php::inst_prefix}/etc";
		"${php::confdir}/conf.d":
			mode => 750,
			owner => root,
			ensure => directory;
		"${php::bindir}/pear":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/pear";
		"${php::bindir}/peardev":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/peardev";
		"${php::bindir}/pecl":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/pecl";
		"${php::bindir}/phar":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/phar";
		"${php::bindir}/phar.phar":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/phar.phar";
		"${php::bindir}/php":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/php";
		"${php::bindir}/php-config":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/php-config";
		"${php::bindir}/phpize":
			ensure => symlink,
			target => "${php::inst_prefix}/bin/phpize";
	} # file

	# building from source. the main installation is ${php::inst_prefix} with all it's files. after
	# installation completes, several files are linked to the recommended spots. e.g. /etc/php5 or
	# /usr/bin/php, etc. this way we can easily update without the hassle of loosing things.
	exec { "build-php":
		cwd => "/tmp",
		command => "/usr/bin/wget ${php_download_url} -O /tmp/php-${php_version}.tgz && /bin/tar xvzf php-${php_version}.tgz && cd php-${php_version} && ./configure --prefix=${php::inst_prefix} --with-config-file-path=${php::inst_prefix}/etc --with-config-file-scan-dir=${php::inst_prefix}/etc/conf.d --with-pear=${php::inst_prefix}/pear --with-apxs2=`which apxs2` --enable-bcmath --enable-calendar --enable-dba=shared --enable-exif=shared --enable-ftp=shared --enable-soap=shared --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-shmop --enable-zip --enable-mbregex --enable-mbstring --enable-calendar --enable-sqlite-utf8 --enable-sockets --enable-exif --enable-shared --enable-safe-mode --enable-gd-native-ttf --enable-wddx=shared --with-gettext=shared --with-imap=shared --with-imap-ssl=shared --with-openssl=shared --with-kerberos --with-zlib=shared --with-ldap=shared --with-bz2=shared --with-curl=shared --with-curlwrappers=shared --with-gd=shared --with-jpeg-dir=/usr/lib --with-png-dir=/usr/lib --with-sqlite=shared --with-pdo-mysql=shared --with-freetype-dir=/usr/lib --with-xpm-dir=/usr/lib --with-t1lib=shared --with-mcrypt=shared --with-mhash=shared --with-mysql=shared --with-mysql-sock=shared --with-mysqli=/usr/bin/mysql_config --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pgsql=shared --with-readline=shared --with-xsl=shared && make && make install",
		creates => '/usr/local/bin/php',
		logoutput => on_failure,
		timeout => 0,
		refreshonly => true,
		notify => Exec["restart-apache2"],
	}#exec

	# restart the apache with apache2ctl
	exec { "restart-apache2":
		command => "/usr/sbin/apache2ctl restart",
		refreshonly => true,
	}

    # = Define: php::module
    #
    # 	Makes compiled (so) extensions available for PHP. Creates the
    #	required ini files in the PHP configuration directory and enables
    #	them by restarting the Webserver. The created ini-files are not
    #	replaced to ensure configuration modifications aren't lost each
    #	time puppet runs
    #
    # == Parameters:   
    #	
    #	$ensure: 	defaults to present
    #	$content: 	quoted content
    #
    # == Actions:
    # 	Creates module(s).ini in a recognized directory
    #
    # == Requires:
    # 	Requires PHP to be installed prior to the call
    #
    # == Sample Usage:
    #	placed in a node.pp
    #
    #	realize( Php::Module['bz2'] )
    #
	define module () {
		file { "${php::confdir}/conf.d/${name}.ini":
			replace => false,
			ensure => present,
			content => "extension=${name}.so",
			mode => 644,
			notify => Exec['restart-apache2'],
		}#file
	}#define module


	# [be aware of php modules]
	# those are shared objects compiled and available present
	@module { "bz2": }
	@module { "curl": }
	@module { "dba": }
	@module { "ftp": }
	@module { "gd": }
	@module { "gettext": }
	@module { "imap": }
	@module { "ldap": }
	@module { "mcrypt": }
	@module { "openssl": }
	@module { "pgsql": }
	@module { "readline": }
	@module { "soap": }
	@module { "sqlite": }
	@module { "wddx": }
	@module { "xsl": }
	@module { "zlib": }

} # class php











