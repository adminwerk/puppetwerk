#
#   class: apache2::php
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 19.03.2012
#   based:  
#

class apache2::php {

	file { 

		"/etc/apache2/mods-available/php5.conf": 
			ensure => present,
			source => "puppet:///data/php/php5.conf",
			mode => 644,
			owner => root;
		
		"/etc/apache2/mods-available/php5.load":
			ensure => present,
			content => "LoadModule php5_module	/usr/lib/apache2/modules/libphp5.so",
			mode => 644,
			owner => root;

		"/etc/php5":
			mode => 750,
			ensure => directory,
			require => Package["phpPackage"];

		"/etc/php5/conf.d":
			mode => 750,
			ensure => directory,
			require => Package["phpPackage"],
			notify => Exec["enable-php-conf"];
	} # file

	package { "libapache2-mod-php5":
		ensure => present,
		alias => "phpPackage",
	}

	ini { "/etc/php5/php.ini": }

	# set the vhost on fire (start it)
	exec { "enable-php-conf":
		command => "/usr/sbin/a2enmod php5",
		require => [ File["/etc/apache2/mods-available/php5.conf","/etc/apache2/mods-available/php5.load"],
					 Package["phpPackage"]],
		refreshonly => true,
		notify => Service["apacheService"],
	} # exec

	define ini (
		$php_ini_max_execution_time = "600",
		$php_ini_max_inout_time = "300",
		$php_ini_memory_limit = "256M",
		$php_ini_error_reporting = "E_ALL & ~E_NOTICE",
		$php_ini_error_log = "/var/log/php5.log",
		$php_ini_register_globals = "Off",
		$php_ini_post_max_size = "50M",
		$php_ini_include_path  = ".:/usr/share/ZendFramework/library",
		$php_ini_upload_max_filesize = "50M",
		$php_ini_default_socket_timeout = "60",
		$php_ini_date_timezone = "Europe/Berlin",
		$php_ini_smtp_host = '',
		$php_ini_smtp_port = '25',
		$php_ini_sendmail_path = '',) {

		file { "/etc/php5/php.ini":
			content => template("php/php_ini.erb"),
			mode => 644,
			owner => root,
		} # file
	} # define ini

	define module () {
		
		file { "/etc/php5/conf.d/${name}.ini":
			replace => false,
			ensure => present,
			content => "extension=${name}.so",
			mode => 644,

		} # file

	} # define module

	# [be aware of php modules]
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

}