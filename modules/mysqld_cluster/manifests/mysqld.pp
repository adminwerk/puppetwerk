#
#   class: mysqld_cluster::mysqld
#  author: chris@adminwerk.de
# version: 1.0.2
#    date: 29.02.2012
#   descr: run mysqld
#
#   stage: six-after-main
#	 info:
#

class mysqld_cluster::mysqld {

	notify { "mysqld": }
	# run mysqld
	exec { "mysql_cluster_run":
		command => "${basedir}/bin/mysqld --defaults-file=${datadir}/conf/my.cnf &" 
	}

	# set password for user 'root'
	exec { "set_mysql_password":
		unless => "${basedir}/bin/mysqladmin -uroot -p${mysql_password} status",
		command => "${basedir}/bin/mysqladmin -uroot password '${mysql_password}'",
	}

	exec { "create-do-not-delete":
		unless => "test -f ${datadir}/doNOTdelete",
		command => "touch ${datadir}/doNOTdelete",
	}

}