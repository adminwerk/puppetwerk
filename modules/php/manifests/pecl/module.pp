#
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 20.03.2012
#

# Definition: php::pecl::module
#
#	Installs PECL modules
#
# Parameters:   
#
# Actions:
#
#
# Requires:
#   PHP and neccessary libraries - PECL does not track those!
#
# Sample Usage:
#
# 	php::pecl::module 
#

define php::pecl::module ($state="stable", $auto_answer="\\n") {

	exec { "pecl-${name}": 
		command => "/usr/bin/printf \"${auto_answer}\" | /usr/bin/pecl -d preferred_state=${state} install ${name}",
		unless => "/usr/bin/pecl info ${name}",
		require => File['/usr/bin/pecl'],
		notify => Service['apache2'],
	}

	file { "/usr/local/php/etc/conf.d/${name}.ini":
		replace => false,
		ensure => present,
		content => "extension=${name}.so",
		mode => 644,
		notify => Service['apache2'],
	} # file	

}