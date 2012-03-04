#
#   class: fail2ban::install
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 27.02.2012
#   descr: installs fail2ban 
#

# ==Actions
# install the fail2ban package
class fail2ban::install {

	package { "fail2ban":
		ensure => "latest",
	}

}