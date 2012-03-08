#
#    name: site.pp
#  author: chris@adminwerk.de
# version: 1.0.6
#    date: 24.03.2012
#

import "classes/*.pp"
import "nodes/*.pp"

# variables valid for a couple of server
import "/etc/puppet/variables/global.pp"

# set default $PATH for all exec
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node default { }