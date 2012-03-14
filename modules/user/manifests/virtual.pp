#
#  define: user::virtual
#  author: chris@adminwerk.de
# version: 1.0.4
#    date: 14.03.2012
#    info:
#
#   usage: The users are deployed with two more steps from here:
#		   1: they are assigned to a group (see manifests/developer.pp and manifests/sysadmins.pp) and
#		   2: those manifests are "Include user::sysadmins" and "Include user::developers" for the wanted node
#

class user::virtual {

	# requirement for puppet to be able to handle passwords
	package { "libshadow-ruby1.8":
		ensure => present,
	}

	define user_dotfile ( $username ) {

		file { "/home/${username}/.${name}":
			source => "puppet:///data/user/${username}-${name}",
			owner => $username,
			group => $username,
			mode => 750,
		}
	}

	# define/create a new user and put it into a 'default' group (users) if not declared different
	define ssh_user ( $key, $fullname, $dotfile = false, $ingroups = users, $password ) {

		user { "$name":
			ensure => present,
			comment => $fullname,
			managehome => true,
			shell => "/bin/bash",
			allowdupe => false,
			groups => $ingroups,
			password => $password,
		}

		ssh_authorized_key { "${name}_key":
			key => $key,
			type => "ssh-rsa",
			user => $name,
		}

		if $dotfile {
			user_dotfile { $dotfile:
				username => $name,
			}
		}

	}

	# Users that are existent, not necessarily deployed with their according informations -
	# stuff is taken from an external file for obvious reasons.

	@ssh_user { "sse":
		key => "${sse_pub_key}",
		fullname => "${sse_full}",
		ingroups => ["admin"],
		password => "${sse_hashed_passwd}",
	}

	@ssh_user { "cmr":
		key => "${cmr_pub_key}",
		fullname => "${cmr_full}",
		dotfile => ["bashrc","bashrc2","screenrc"],
		ingroups => ["admin"],	
		password => "${cmr_hashed_passwd}",
	}

	# special users which are there to establish a persistent tunnel between servers
	@ssh_user { "tunnel-ws01": 
		key => "${tunnel_pub_key}",
		fullname => "${tunnel_full}",
		password => "${tunnel_hashed_passwd}",
	}

	@ssh_user { "tunnel-db01": 
		key => "${tunnel_pub_key}",
		fullname => "${tunnel_full}",
		password => "${tunnel_hashed_passwd}",
	}

}


