#
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 20.03.2012
#

# Definition: php::pecl::config
#
#	Modify runtime parameters for PECL
#
# Parameters:   
#
# Actions:
#   Set or update runtime parameters for PECL
#   and changes the configuration 
#
# Requires:
#   PHP
#
# Sample Usage:
#
# 	php::pecl::config { http_proxy: value => "http://myproxy:8080" }
#
define php::pecl::config ($value) {
	
	include php::pecl

	exec { "pecl-config-set-${name}":
		command => "/usr/bin/pear config-set ${name} ${value}",
		unless => "/usr/bin/pear config-get ${name} | /bin/grep ${value}",
		require => File['/usr/bin/pecl'],
	}
}