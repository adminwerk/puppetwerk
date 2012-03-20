#
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 20.03.2012
#

# Definition: mysql::server
#
#
# Parameters:   
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
#
class server {

	# the package we need to install is shipped by mysql/oracle directly
	# and brought to the server via internal.packages (our own repository).
	# unfortunately the element is called mysql, not mysql-server (for no
	# reason).
	package { "mysql": 
		ensure => installed, 
	}

	service { "mysql":
		ensure => running,
		enable => true,
		require => Package['mysql'],
	}

	file { "/etc/mysql/my.cnf":
		owner => mysql,
		group => mysql,
		source => "puppet:///data/mysqld/my.cnf",
		notify => Service['mysql'],
		require => Package['mysql'],
	}

	exec { "set-mysql-password:" 
		unless => "mysqladmin -uroot -p${mysql_password} status",
		command => "mysqladmin -uroot password ${mysql_password}",
		require => Service['mysql'],
	}

}