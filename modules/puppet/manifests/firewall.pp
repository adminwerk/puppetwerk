#
#   class: puppet::firewall
#  author: chris@adminwerk.de
# version: 1.0.0.
#    date: 27.02.2012
#   descr: open puppet communication ports for internal use,
#          so only 10.12.40.0/24 is opened
#

class puppet::firewall {

	ufw::allow { "allow-puppet-from-trusted":
		port => 8140,
		ip => "10.12.40.0/24",
	}

}