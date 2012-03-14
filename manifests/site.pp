#
#    name: site.pp
#  author: chris@adminwerk.de
# version: 1.0.11
#    date: 14.03.2012
#    info: this file may NOT be deployed to a public place for 
#          various and obvious reasons

import "classes/*.pp"
import "nodes/*.pp"

# variables valid for a couple of server
import "/etc/puppet/variables/global.pp"

# import of user credentials
import "/etc/puppet/variables/_user_creds.pp"

# set default $PATH for all exec
Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

node default { }