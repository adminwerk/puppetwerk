#
#  author: chris@adminwerk.de
# version: 1.0.2
#    date: 20.03.2012
#


# Class: php
#
# This module compiles a fresh PHP5 from source. The version it takes has to
# be defined in the node.pp variable $php_version
#
# Requires:
#   class apache
#
# Sample Usage: include php
#				realize( Php::Module['bz2'] ) 
#				realize( Php::Module['curl'] ) 
#
class php {

	# a couple of informations that we require to be able to install 
	# this stuff accordingly
	$inst_prefix="/usr/local/php"
	$inst_bindir="/usr/bin"

	# This is the section where we include all the dependencies. 
	# we need to ensure that the compile environement stands up
	package { 
		[ "apache2-prefork-dev","libc-client2007e-dev","libkrb5-dev","postgresql-server-dev-8.4","libreadline5-dev","libbz2-dev","libcurl4-openssl-dev","libcurl3","libjpeg62-dev","libfreetype6-dev","comerr-dev","libgssrpc4","libidn11-dev","libkadm5clnt-mit7","libt1-dev","libxslt1-dev","libkdb5-4","pkg-config","libpng12-dev","libxpm-dev","libxslt1.1","libperl-dev","libssl-dev","libxcrypt-dev","libldap2-dev","libxml2-dev","libxml2","bison","autoconf","build-essential","libmcrypt-dev","libgdbm-dev","libmhash2","libmhash-dev","libltdl-dev"]:
			ensure => "present";
	} # package

	# create symlinks and files required
	file { 
		"/etc/php5":
			ensure => symlink,
			target => "$php::inst_prefix/etc";
		"/etc/php5/conf.d":
			mode => 750,
			owner => root,
			ensure => directory;
		"/usr/bin/pear":
			ensure => symlink,
			target => "$php::inst_prefix/bin/pear";
		"/usr/bin/peardev":
			ensure => symlink,
			target => "$php::inst_prefix/bin/peardev";
		"/usr/bin/pecl":
			ensure => symlink,
			target => "$php::inst_prefix/bin/pecl";
		"/usr/bin/phar":
			ensure => symlink,
			target => "$php::inst_prefix/bin/phar";
		"/usr/bin/phar.phar":
			ensure => symlink,
			target => "$php::inst_prefix/bin/phar.phar";
		"/usr/bin/php":
			ensure => symlink,
			target => "$php::inst_prefix/bin/php";
		"/usr/bin/php-config":
			ensure => symlink,
			target => "$php::inst_prefix/bin/php-config";
		"/usr/bin/phpize":
			ensure => symlink,
			target => "$php::inst_prefix/bin/phpize";
	} # file

	# building from source. the main installation is $php::inst_prefix with all it's files. after
	# installation completes, several files are linked to the recommended spots. e.g. /etc/php5 or
	# /usr/bin/php, etc. this way we can easily update without the hassle of loosing things.
	exec { "build-php":
		cwd => "/tmp",
		command => "/usr/bin/wget ${php_download_url} -O /tmp/php-${php_version}.tgz && /bin/tar xvzf php-${php_version}.tgz && cd php-${php_version} && ./configure --prefix=$php::inst_prefix --with-config-file-path=$php::inst_prefix/etc --with-config-file-scan-dir=$php::inst_prefix/etc/conf.d --with-pear=$php::inst_prefix/pear --with-apxs2=`which apxs2` --enable-bcmath --enable-calendar --enable-dba=shared --enable-exif=shared --enable-ftp=shared --enable-soap=shared --enable-sysvmsg --enable-sysvsem --enable-sysvshm --enable-shmop --enable-zip --enable-mbregex --enable-mbstring --enable-calendar --enable-sqlite-utf8 --enable-sockets --enable-exif --enable-shared --enable-safe-mode --enable-gd-native-ttf --enable-wddx=shared --with-gettext=shared --with-imap=shared --with-imap-ssl=shared --with-openssl=shared --with-kerberos --with-zlib=shared --with-ldap=shared --with-bz2=shared --with-curl=shared --with-curlwrappers=shared --with-gd=shared --with-jpeg-dir=/usr/lib --with-png-dir=/usr/lib --with-sqlite=shared --with-pdo-mysql=shared --with-freetype-dir=/usr/lib --with-xpm-dir=/usr/lib --with-t1lib=shared --with-mcrypt=shared --with-mhash=shared --with-mysql=shared --with-mysql-sock=shared --with-mysqli=/usr/bin/mysql_config --with-mysql=mysqlnd --with-mysqli=mysqlnd --with-pdo-mysql=mysqlnd --with-pgsql=shared --with-readline=shared --with-xsl=shared && make && make install",
		creates => '/usr/local/bin/php',
		logoutput => on_failure,
		timeout => 0,
		refreshonly => true,
		notify => Exec["restart-apache2"],
	} # exec

	# restart the apache with apache2ctl
	exec { "restart-apache2":
		command => "/usr/sbin/apache2ctl restart",
		refreshonly => true,
	}

    # Definition: php::module
    #
    # 	Makes compile extensions available for php. Creates
    #	required ini files
    #
    # Parameters:   
    #	
    #	$ensure: 	defaults to present
    #	$content: 	quoted content
    #
    # Actions:
    #   Creates module(s).ini in a recognized directory
    #
    # Requires:
    #   Requires the source to be installed prior to the call
    #
    # Sample Usage:
    #	ini { "$php::inst_prefix/etc/php.ini": }
    #
	define module () {
		
		file { "/etc/php5/conf.d/${name}.ini":
			replace => false,
			ensure => present,
			content => "extension=${name}.so",
			mode => 644,
			notify => Exec['restart-apache2'],
		} # file

	} # define module


	# [be aware of php modules]
	# those are the shared objects that were compiled and that are present
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

    # Definition: php::pearproxy
    #
    #   this definitions enables us to set a proxy for pear. unless this is set
    #	the server can't communicate with the outside and e.g. load pecl modules
    #
    # Parameters:   
    #
    # Actions:
    #
    # Requires:
    #
    # Sample Usage:
    #
	#define pearproxy($proxy_url) {
	#	
	#	exec { "/usr/bin/pear config-set http_proxy '$proxy_url'":
	#		unless => "/usr/bin/pear config-show | grep '$proxy_url'"
	#	}
	#
	#} # define pearproxy


} # class php











