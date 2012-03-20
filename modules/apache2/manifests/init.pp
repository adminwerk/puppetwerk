#
#   class: apache2
#  author: chris@adminwerk.de
# version: 1.0.2
#    date: 17.03.2012
#   based: https://github.com/ghoneycutt/puppet-apache/ 
#


# Class: apache2
#
# This module installs and manages apache2
#
# Parameters:
#
# Actions:
#   - Install apache2
#   - Manage apache2 service
#
# Requires:
#
# Sample Usage: include apache2
#
class apache2 {

	$basedir = "/etc/apache2"
	$conffile = "$basedir/apache2.conf"
	$portfile = "$basedir/ports.conf"
	$vhostcustdir = "$basedir/vhost-custom.d/"

	# requirements
	#-- the name defines the package and the alias is used to get this deployed 
	#-- throughout the configuration
	package { "apache2-mpm-prefork":	
		ensure => present, 
		alias => "apachePackage",
	} # package

	# service control
	#-- the name defines the service and the alias is used to get this deployed
	#-- throughout the configuration
	service { "apache2":
	    enable => true,
		ensure => running,
		hasrestart => true,
		restart => "/usr/sbin/apache2ctl restart",
		alias => apacheService,
		require => Package["apachePackage"]
	} # service

	file { "$apache2::vhostcustdir":
		mode => "755",
		owner => "root",
		ensure => "directory",
		require => Package["apachePackage"];
	} # file

	# Definition: apache2::vhost
	#
	# Parameters:   
	#
	# Actions:
	#
	# Requires:
	#
	# Sample Usage:
	#
	define vhost ( 
		$sitename = '', 
		$documentroot = '', 
		$vhost_ip = '', 
		$vhost_server_alias = '',
		$vhost_domain_options = 'FollowSymLinks',
		$vhost_domain_allow_override = 'None',
		$vhost_domain_order = 'allow,deny',
		$vhost_server_admin = 'root@localhost') {

		# include the master manifest
		include apache2
		#include apache2::php

		# set site name
		if $sitedomain == "" {
			$vhost_domain = $name
		} else {
			$vhost_domain = $sitedomain
		}

		# set documentroot
		if $documentroot == "" {
			$vhost_root = "/var/www/${name}"
		} else {
			$vhost_root = $documentroot
		}

		# some files/directories needed to be setup
		file { 

			# set documentroot directory
			"/var/www/${vhost_domain}":
				mode => "750",
				owner => "www-data",
				ensure => "directory",
				recurse => true,
				require => Package["apachePackage"];

			# custom vhost directives (to be set by hand) and if existent
			# not to be overwritten
			"/etc/apache2/vhost-custom.d/${vhost_domain}-custom.conf":
				replace => false,
				content => template("apache2/vhost-custom.erb"),
				mode => 755,
				owner => root,
				ensure => present;

			# vhost with the main configuration
			"/etc/apache2/sites-available/${vhost_domain}.conf":
				content => template("apache2/vhost.erb"),
				notify => Exec["enable-${vhost_domain}-vhost"];

		} # file

		# set the vhost on fire (start it)
		exec { "enable-${vhost_domain}-vhost":
			command => "/usr/sbin/a2ensite ${vhost_domain}.conf",
			require => [ File["$apache2::basedir/sites-available/${vhost_domain}.conf"],
						 Package["apachePackage"]],
			refreshonly => true,
			notify => Service["apacheService"],

		} # exec

	} # define apache2::vhost


	# Definition: apache2::vhostssl
	#
	# Parameters:   
	#
	# Actions:
	#
	# Requires:
	#
	# Sample Usage:
	#
	define vhostssl ( 

		$sitename = '', 
		$documentroot = '', 
		$vhost_ip = '', 
		$vhost_server_alias = '',
		$vhost_domain_options = 'FollowSymLinks',
		$vhost_domain_allow_override = 'None',
		$vhost_domain_order = 'allow,deny',
		$vhost_server_admin = 'root@localhost') {

		# include the master manifest
		include apache2
		include apache2::php

		# set site name
		if $sitedomain == "" {
			$vhost_domain = $name
		} else {
			$vhost_domain = $sitedomain
		}

		# set documentroot
		if $documentroot == "" {
			$vhost_root = "/var/www/${name}"
		} else {
			$vhost_root = $documentroot
		}

		# some files/directories needed to be setup
		file { 

			# set documentroot directory
			"/var/www/${vhost_domain}":
				mode => "750",
				ensure => "directory",
				require => Package["apachePackage"];

			# custom vhost directives (to be set by hand) and if existent
			# not to be overwritten
			"/etc/apache2/vhost-custom.d/${vhost_domain}_ssl-custom.conf":
				replace => false,
				content => template("apache2/vhostssl-custom.erb"),
				mode => 755,
				owner => root,
				ensure => present;

			# vhost with the main configuration
			"/etc/apache2/sites-available/${vhost_domain}_ssl.conf":
				content => template("apache2/vhostssl.erb"),
				notify => Exec["enable-${vhost_domain}-ssl-vhost"];

		} # file

		# set the vhost on fire (start it)
		exec { "enable-${vhost_domain}-ssl-vhost":
			command => "/usr/sbin/a2ensite ${vhost_domain}_ssl.conf",
			require => [ File["$apache2::basedir/sites-available/${vhost_domain}_ssl.conf"],
						 Package["apachePackage"]],
			refreshonly => true,
			notify => Service["apacheService"],

		} # exec

	} # define apache2::vhostssl

}	# class apache2