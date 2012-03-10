#
#   class: resolvconf::public
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 10.03.2012
#

class resolvconf::public {
	file { "/etc/resolv.conf":
		source => "puppet:///data/resolvconf/resolv.conf.public",
		owner => root,
		group => root,
		mode => 644,
	}
}