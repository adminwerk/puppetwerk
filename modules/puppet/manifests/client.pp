#
#   class: puppet::client
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 04.03.2012
#
#    info: deploys the client side puppet.conf once the client has been
#          established
#

class puppet::client {
	puppet::client::conf { "/etc/puppet/puppet.conf": }
}

define puppet::client::conf(
		logdir = "/var/log/puppet",
		vardir = "/var/lib/puppet",
		ssldir = "/var/lib/puppet/ssl",
		rundir = "/var/run/puppet",
		report = "true",
		# set in a global variables file
		server = "${puppetmaster}",) {

	file { "/etc/puppet/puppet.conf":
		owner => "puppet",
		group => "puppet",
		content => template("/etc/puppet/modules/puppet/templates/puppet.erb"),
	}
}