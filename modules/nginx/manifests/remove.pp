#
#   class: nginx::remove
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 01.03.2012
#
#	 info: remove the installed nginx server and purge its conf

class nginx::remove {

	service { "nginx":
		provider => "debian",
		ensure => "stopped",
	}

	# remove the package and its config files
	package { "nginx-full": 
		ensure => "purged",
		provider => "apt",
	}


}