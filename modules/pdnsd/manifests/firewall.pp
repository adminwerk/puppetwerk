#
#   class: pdnsd::firewall
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 27.02.2012
#   descr: open dns communication ports for internal use,
#          so only 10.12.40.0/24 is opened
#

class pdnsd::firewall {

	ufw::allow { "allow-dns-udp-from-trusted":
		port => 53,
		ip => "10.12.40.0/24",
		proto => "udp"
	}

	ufw::allow { "allow-dns-tcp-from-trusted":
		port => 53,
		ip => "10.12.40.0/24",
		proto => "tcp",
	}

}