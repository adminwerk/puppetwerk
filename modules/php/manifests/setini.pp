# Definition: php::setini
#
# 	Creates the php.ini file required for php to be parametrized.
#	This define isn't meant to be called outside class "php"
#
# Parameters:   
#
# Actions:
#   Creates /etc/php5/php.ini
#
# Requires:
#   Requires PHP to be installed prior to creating php.ini
#
# Sample Usage:
#	ini { "$php::inst_prefix/etc/php.ini": }
#

define php::setini (

		$php_ini_safe_mode,
		$php_ini_max_execution_time,
		$php_ini_max_inout_time,
		$php_ini_memory_limit,
		$php_ini_error_reporting,
		$php_ini_error_log,
		$php_ini_register_globals,
		$php_ini_post_max_size,
		$php_ini_include_path,
		$php_ini_upload_max_filesize,
		$php_ini_default_socket_timeout,
		$php_ini_date_timezone,
		$php_ini_smtp_host,
		$php_ini_smtp_port,
		$php_ini_sendmail_path,
		$php_ini_extension_dir) {

	include php

	file { "/etc/php5/php.ini":
			require => Exec['build-php'],
			content => template("php/php_ini.erb"),
			mode => 644,
			notify => Service['apache2'],
	} # file
} # define ini