#
#   class: hosts
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 03.03.2012
#
#	 info: provides /etc/hosts

class hosts {
	set::hosts { "/etc/hosts": }
}


define set::hosts (
	my_host_name = "${my_host_name}",
	hostname = "$hostname",
	ip_internet = "${ip_internet}",
	fqdn = "${fqdn_internet}") {

	file { "/etc/hosts":
		owner => root,
		group => root,
		mode => 644,
		content => template("/etc/puppet/modules/hosts/templates/hosts.erb"),
	}
}