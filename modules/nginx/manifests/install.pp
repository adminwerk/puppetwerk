#
#   class: nginx::install
#  author: chris@adminwerk.de
# version: 1.0.2
#    date: 26.02.2012
#


# nginx in Ubunutu Lucid is stone old, so we want a newer version
# which comes from PPA 
class nginx::install {

	package { "python-software-properties":
		ensure => installed,
	}

	exec { "add-apt-repository ppa:nginx/stable && apt-get update":
	    alias => "nginx_repository",
	    require => Package["python-software-properties"],
	    creates => "/etc/apt/sources.list.d/nginx-stable-lucid.list",
	}

  	package { "nginx":
    	ensure => present,
    	require => Exec["nginx_repository"],
  	}

}