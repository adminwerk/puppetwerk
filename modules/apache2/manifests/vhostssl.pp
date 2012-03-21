# = Define: apache2::vhostssl
#
# This module installs a non <VirtualHost> to Apache2
#
# == Parameters:
#
# == Actions:
#  
# == Requires:
#
# == Sample Usage: 
#
#	apache2::vhostssl { "domain-without-www.tld":
#		documentroot => '/path/to/vhost',
#		vhost_ip => '1.2.3.4',
#		vhost_server_alias => '',
#		vhost_domain_allow_override => 'None',
#		vhost_domain_order => 'allow,deny',
#		vhost_server_admin => 'team@ourdomain.tld',
#		vhost_domain_options => '-Indexes -ExecCGI',
#   }
#
define apache2::vhostssl ( 

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

	# some files/directories needed to be setup
	file { 

		# set documentroot directory
		"${vhost_root}/${vhost_domain}":
			mode => "750",
			ensure => "directory",
			require => Package["apachePackage"];

		# custom vhost directives (to be set by hand) and if existent
		# not to be overwritten
		"$apache2::basedir/vhost-custom.d/${vhost_domain}_ssl-custom.conf":
			replace => false,
			content => template("apache2/vhostssl-custom.erb"),
			mode => 755,
			owner => root,
			ensure => present;

		# vhost with the main configuration
		"$apache2::basedir/sites-available/${vhost_domain}_ssl.conf":
			content => template("apache2/vhostssl.erb"),
			notify => Exec["enable-${vhost_domain}-ssl-vhost"];

	}#file

	# set the vhost on fire (start it)
	exec { "enable-${vhost_domain}-ssl-vhost":
		command => "/usr/sbin/a2ensite ${vhost_domain}_ssl.conf",
		require => [ File["$apache2::basedir/sites-available/${vhost_domain}_ssl.conf"],
					 Package["apachePackage"]],
		refreshonly => true,
		notify => Service["apacheService"],

	}#exec

}#define apache2::vhostssl