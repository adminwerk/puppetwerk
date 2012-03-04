#
#   class: nginx::firewall
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 27.02.2012
#   descr: open nginx communication ports for internal use,
#          so only 10.12.40.0/24 is opened
#

# ==Actions
# Opens the mentioned port for the service using ufw
class nginx::firewall {

	ufw::allow { "allow-nginx-from-all":
		port => 80,
	}

}