#
#   class: nginx
#  author: chris@adminwerk.de
# version: 1.0.2
#    date: 07.03.2012
#

class nginx {

	require nginx::install

	service { "nginx": 
		ensure => running,
	}	

}