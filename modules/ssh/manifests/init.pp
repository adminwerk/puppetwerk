#
#   class: ssh
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 25.02.2012
#

# class which deploys the configuration of the sshd as well as a global 
# ssh key for the root user to make the server behind the frontline accessible
# informations and most important the authorized_key for root on the server.

class ssh {

	# ==Actions
	# Ensure openssh-server is installed and running
	package { "openssh-server":
		ensure => "latest",
	}

	service { "ssh":
		ensure => running,
		hasrestart => true,
	}
	
	# create .ssh directory first, write a file to it
	# afterwards
	file { "/root/.ssh":
		ensure => "directory",
		owner => "root",
		group => "root",
		mode => 600,
	}

	# take care of the authorized_keys file to have "blind" access to that rig
	# by simply hacking 'ssh db01' into the console
	file { "/root/.ssh/authorized_keys":
		path => "/root/.ssh/authorized_keys",
		owner => "root",
		group => "root", 
		mode => 600,
		recurse => true,
		source => "puppet:///data/ssh/authorized_keys",
		ensure => [directory, present],
	}

	# calling the template defined below
	sshd::conf { "/etc/ssh/sshd_config":
		logingracetime => '60',
		permitrootlogin => 'yes',
		x11forwarding => 'yes',
	} 
}

# sshd_config configuration template
define sshd::conf (
		port = "22",
		keyregenerationinterval = "3600",
		syslogfacility = "AUTH",
		loglevel = "info",
		logingracetime = "120",
		permitrootlogin = "yes",
		strictmodes = "yes",
		rsaauthentication = "yes",
		pubkeyauthentication = "yes", 
		passwordauthentication = "yes",
		x11forwarding = "yes",
		printmotd = "no",
		maxstartups = "10",
		maxauthtries = "5") { 

	file { "/etc/ssh/sshd_config":
		owner => root,
		group => root,
		mode => 600,
		content => template("/etc/puppet/modules/ssh/templates/sshd_config.erb"),
		notify => Service['ssh']
	}
}
