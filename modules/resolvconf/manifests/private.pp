#
#   class: resolvconf::private
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 10.03.2012
#

class resolvconf::private {
	file { "/etc/resolv.conf":
		source => "puppet:///data/resolvconf/resolv.conf.private",
		owner => root,
		group => root,
		mode => 644,
	}
}