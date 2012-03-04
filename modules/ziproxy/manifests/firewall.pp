#
#   class: ziproxy::firewall
#  author: chris@adminwerk.de
# version: 1.0.0 
#    date: 27.02.2012
#   descr: open ziproxy communication ports for internal use,
#          so only 10.12.40.0/24 is opened
#

class ziproxy::firewall {

	ufw::allow { "allow-ziproxy-from-trusted":
		port => 8888,
		ip => "10.12.40.0/24",
	}

}