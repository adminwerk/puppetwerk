#
#   class: nginx
#  author: chris@adminwerk.de
# version: 1.0.3
#    date: 08.03.2012
#

class nginx {

	require nginx::install

	file { "/var/www":
			ensure => "directory",
			owner => "www-data",
			group => "www-data",
			mode => 770,
	}

	service { "nginx": 
		ensure => running,
	}	

}