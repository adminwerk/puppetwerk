#
#    class: apt::add-proxy
#   author: chris@adminwerk.de
#  version: 1.0.0
#     date: 04.03.2012
#

class apt::add-proxy {

	apt::add-proxy::acquire { "/etc/apt/apt.conf.d/02proxy": }

}

define apt::add-proxy::acquire (

		puppetmaster_int_ip = "${puppetmaster_int_ip}",
		proxy_port = "${proxy_port}" ) {

	file{	"/etc/apt/apt.conf.d/02proxy":
		owner => "root",
		group => "root",
		mode => "644",
		content => template("/etc/puppet/modules/apt/templates/02proxy.erb"),
	}
}