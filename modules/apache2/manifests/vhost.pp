# = Define: apache2::vhost
#
# This module installs a non SSL <VirtualHost> to Apache2
#
# == Parameters:
#
#
# == Actions:
#  
# == Requires:
#
# == Sample Usage: 
#
#	apache2::vhost { "domain-without-www.tld":
#		documentroot => '/path/to/vhost',
#		vhost_server_admin => 'team@ourdomain.tld',
#		vhost_domain_options => '-Indexes -ExecCGI',
#   }
#
define apache2::vhost ( 
	
	$sitename = '', 
	$documentroot = '', 
	$vhost_ip = '', 
	$vhost_server_alias = '',
	$vhost_domain_options = 'FollowSymLinks',
	$vhost_domain_allow_override = 'None',
	$vhost_domain_order = 'allow,deny',
	$vhost_server_admin = 'root@localhost') {

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

	# some files/directories needed to be set up prior to being able to 
	# store configurations to them
	file { 
		"${vhost_root}/${vhost_domain}":
			mode => "750",
			owner => "www-data",
			ensure => "directory",
			recurse => true,
			require => Package["apachePackage"];

		# custom vhost directives (to be set by hand) and if existent
		# not to be overwritten
		"$apache2::basedir/vhost-custom.d/${vhost_domain}-custom.conf":
			replace => false,
			content => template("apache2/vhost-custom.erb"),
			mode => 755,
			owner => root,
			ensure => present;

		# vhost with the main configuration
		"$apache2::basedir/sites-available/${vhost_domain}.conf":
			content => template("apache2/vhost.erb"),
			notify => Exec["enable-${vhost_domain}-vhost"];

	}#file

	# set the vhost on fire (start it)
	exec { "enable-${vhost_domain}-vhost":
		command => "/usr/sbin/a2ensite ${vhost_domain}.conf",
		require => [ File["$apache2::basedir/sites-available/${vhost_domain}.conf"],
					 Package["apachePackage"]],
		refreshonly => true,
		notify => Service["apacheService"],
	}#exec

}#define apache2::vhost