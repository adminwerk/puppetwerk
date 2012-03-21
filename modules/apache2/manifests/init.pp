# = Class: apache2
#
# This module installs and manages apache2
#
# == Parameters:
#
# == Actions:
#	Install Apache2 and add the main configuration files
#  
# == Requires:
#
# == Sample Usage: 
#	include apache2
#
class apache2 { 

	# TODO: [201203211158] find a possibility to outsource this "hardcoded" part of the manifest into the node or somewhere less disturbing
	$basedir = "/etc/apache2"
	
	$conffile = "$basedir/apache2.conf"
	$portfile = "$basedir/ports.conf"
	$vhostcustdir = "$basedir/vhost-custom.d/"
	$moduledir = "/usr/lib/apache2/modules"

	# requirements
	#-- the name defines the package and the alias is used to get this deployed 
	#-- throughout the configuration
	package { "apache2-mpm-prefork":	
		ensure => present, 
		alias => "apachePackage",
	}#package

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
	}#service

	file { "$apache2::vhostcustdir":
		mode => "755",
		owner => "root",
		ensure => "directory",
		require => Package["apachePackage"];
	}#file

}#class apache2