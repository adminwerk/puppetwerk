#
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 20.03.2012
#

# Definition: php::pecl::zendmodule
#
#	Installs PECL modules which require to be run as zend modules.
#	The main difference (for us) is the definition of how the module
#	is called in the ${name}.ini
#
# Parameters:   
#
# Actions:
#
# Requires:
#   PHP and neccessary libraries - PECL does not track those!
#
# Sample Usage:
#
# 	php::pecl::zendmodule 
#

define php::pecl::zendmodule ($state="stable", $auto_answer="\\n", $inst_path='') {

	exec { "pecl-zend-${name}": 
		command => "/usr/bin/printf \"${auto_answer}\" | /usr/bin/pecl -d preferred_state=${state} install ${name}",
		unless => "/usr/bin/pecl info ${name}",
		require => File['/usr/bin/pecl'],
		notify => Service['apache2'],
	}

	file { "/etc/php5/conf.d/${name}.ini":
		replace => false,
		ensure => present,
		content => "zend_extension=${$inst_path}${name}.so",
		mode => 644,
		notify => Service['apache2'],
	} # file	

}