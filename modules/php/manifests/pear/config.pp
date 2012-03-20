#
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 20.03.2012
#

# Definition: php::pear::config
#
#	Modify runtime parameters for PEAR
#
# Parameters:   
#
# Actions:
#   Set or update runtime parameters for PEAR
#   and changes the configuration 
#
# Requires:
#   PHP
#
# Sample Usage:
#
# 	php::pear::config { http_proxy: value => "http://myproxy:8080" }
#
define php::pear::config ($value) {
	
	include php::pear

	exec { "pear-config-set-${name}":
		command => "/usr/bin/pear config-set ${name} ${value}",
		unless => "/usr/bin/pear config-get ${name} | /bin/grep ${value}",
		require => File['/usr/bin/pear'],
	}
}