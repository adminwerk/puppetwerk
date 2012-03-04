#
#   class: mysqld_cluster::conf
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 29.02.2012
#   descr: copies all required files to the adequate position on the new server
#		   additionally it creates a couple o configuration files and init scripts
#
#	stage: two-after-main
#    info: ${basedir}/${datadir} are defined in nodes.pp
#

class mysqld_cluster::conf {

	# create my.cnf
	mysql_cluster::my_cnf { "${datadir}/conf/my.cnf": }

	# create conf.ini
	mysql_cluster::config_ini { "${datadir}/conf/config.ini": }

	# create init-script
	mysql_cluster::init { "/etc/init.d/mysql-cluster": }

}

	# create my.cnf
	define mysql_cluster::my_cnf (
			datadir = "${datadir}",
			basedir = "${basedir}",
			port = "${db_port}",) {

		file { "${datadir}/conf/my.cnf":
			owner 	=> "mysql",
			mode 	=> 640,
			content => template("/etc/puppet/modules/mysqld_cluster/templates/my_cnf.erb"),
		}
	}

	# create config.ini
	define mysql_cluster::config_ini (
			hostname = "${hostname}",
			datadir = "${datadir}",) {

		file { "${datadir}/conf/conf.ini":
			owner 	=> "mysql", 
			mode 	=> 640,
			content => template("/etc/puppet/modules/mysqld_cluster/templates/config_ini.erb"),
		}
	}

	# create init-script
	define mysql_cluster::init (
			basedir = "${basedir}",
			datadir = "${datadir}",
			service_startup_timeout = "900", ) {

		file { "/etc/init.d/mysql-cluster":
			owner 	=> "root",
			mode 	=> 755,
			content => template("/etc/puppet/modules/mysqld_cluster/templates/mysql-cluster.erb"),
		}

		exec { "set_service": 
			command => "update-rc.d mysql-cluster defaults",
		}

	}

