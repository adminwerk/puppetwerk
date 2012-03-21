#
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 19.03.2012
#

# Definition: resolvconf::private
#
#	Installs the resolv.conf file with private DNS informations
#
# Parameters:   
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#	include resolvconf::private
#
class resolvconf::private {
	file { "/etc/resolv.conf":
		source => "puppet:///data/resolvconf/resolv.conf.private",
		owner => root,
		group => root,
		mode => 644,
	}
}