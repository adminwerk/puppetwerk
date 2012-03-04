# 
#   class: nrpe
#  author: chris@adminwerk.de
# version: 1.0.4
#    date: 04.03.2012
#

class nrpe { 

	# this class sets up a remote nagios client with nrpe and all
	# available compiled plugins. it requires 'xinetd' to be present,
	# so we need to ensure that it's present ...
	#
	# ==Actions
	# Ensure xinetd to be present and running
	package { "xinetd": ensure => "latest",}
	service { "xinetd": ensure => running,}

	# create user/group (nagios) or ensure they exist
	user {"nagios":
		comment => 'user for monitoring purposes (created by puppet)',
		ensure => 'present',
		home => '/usr/local/nagios',
		shell => '/bin/bash',
	}

	# create and set permissions for the directory "/usr/local/nagios"
	# the files provided here are a compilation of nagios-plugins, configurrations
	file {"/usr/local/nagios":
		ensure => "directory",
		owner => "nagios",
		mode => 750,
		source => "puppet:///data/nagios-plugins/nrpe+plugins/",
		recurse => true,
	}

	# ==Requires
	# A generated configuration for nrpe, called by the template 
	# for the xinetd part of nrpe
	xinetd::nrpe::config { "/etc/xinetd.d/nrpe":}

	# ==Actions
	# add one line to the services
	append_if_no_such_line { "add-nagios-service":
		file => "/etc/services",
		line => "nrpe 	5666/tcp 	# NRPE",
		notify => Service['xinetd'],
	}

}

# xinetd configuration file for nrpe to running
define xinetd::nrpe::config (
	service_name = "nrpe",
	flags = "REUSE",
	socket_type = "stream",
	protocol = "",
	port = "5666",
	wait = "no",
	user = "nagios",
	group = "nagios",
	server = "/usr/local/nagios/bin/nrpe",
	server_args = "-c /usr/local/nagios/etc/nrpe.cfg --inetd",
	log_on_failure = "USERID",
	per_source = "",
	disable = "no",

	# list of monitoring server to be granted access to NRPE
	only_from = "127.0.0.1 ${monitoring_server}") {

	file {"/etc/xinetd.d/nrpe":
		owner => root,
		group => root,
		content => template("/etc/puppet/modules/xinetd/templates/service.erb"),
		notify => service['xinetd']
	}

}
