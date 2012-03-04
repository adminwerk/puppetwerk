#
#   class: mysqld_cluster::populate
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 29.02.2012
#   descr: populates the server with initial data (mysql database)
#
#	stage: three-after-main
#	 info: 
#

class mysqld_cluster::populate {

    notify { "populate": }
	# create and populate mysql db
	exec { "mysql_install_db":

		# unless this directory already exists, which would indicate that this script
		# has already been run, we must executre this!
		unless => "test -d ${datadir}/mysqld_data/mysql",

		# this is fundamental or the call will fail as the script makes some relative
		# calls on other scripts
		cwd => "${basedir}",

		# this is the initiating element. this is where the mysql and test database
		# are created
		command => "${basedir}/scripts/mysql_install_db --no-defaults --datadir=${datadir}/mysqld_data/",
	}

}

