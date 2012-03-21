#
#   class: sudo
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 13.03.2012
#

class sudo {

	file { "/etc/sudoers":
        owner   => root,
        group   => root,
        mode    => 440,
        source  => "puppet:///data/sudo/sudoers",
    }

}