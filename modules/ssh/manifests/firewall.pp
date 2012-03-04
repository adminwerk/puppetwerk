#
#   class: ssh::firewall
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 28.02.2012
#   descr: allows access for default SSH port on all interfaces

class ssh::firewall {

	ufw::allow { "allow-ssh-from-all":
	  port => 22,
	}

}