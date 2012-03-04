#
#  define: create_mysql_db
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 28.02.2012
#
#   descr: creates a database with access rights (localhost) for the provided user $user
#          and his password $password and the databasename $name
#   usage:
#    to create ONE database call this (in the node.pp)
#
#    mysql_cluster::db { "create-${name}-db":
#       user => "dBuser",
#       password => "topsecret"
#    }
#
#    to create MORE databases call this like this (in the node.pp)
#
#    mysql_cluster::db { [ "database1", "database2", "database3" ]:
#       user => "dBuser",
#       password => "topsecret"
#    }
#   


define mysql_cluster::db ( $user, $password ) {
	exec { "create-${name}-db":
		unless => "${basedir}/bin/mysql -u${user} -p${password} ${name}",
		command => "${basedir}/bin/mysql -u${user} -p${password} -e \"CREATE DATABASE ${name}; GRANT all on ${name}.* TO ${user}@localhost IDENTIFIED by '$password'; FLUSH PRIVILEGES;\"",
		require => Service['mysql-cluster'],
	}
} 