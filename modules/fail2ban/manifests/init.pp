#
#   class: fail2ban
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 04.03.2012
#   descr: fail2ban 
#

# ==Actions
# Keeps the fail2ban daemon up and running
class fail2ban {

	# get the package installed
	package { "fail2ban":
		ensure => "latest",
	}

	service { "fail2ban":
		ensure => running,
		hasrestart => true,
	}

}