#
#   class: mysqld_cluster::ndb
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 29.02.2012
#   descr: run management node and data node
#
#	stage: five-after-main
#	 info:


class mysqld_cluster::ndb {

	notify { "node1/2": }
	exec { "node1":
		cwd => "${datadir}",
		command => "${basedir}/bin/ndbd -c ${hostname}:${node_port}",
	}

	exec { "node2":
		cwd => "${datadir}",
		command => "${basedir}/bin/ndbd -c ${hostname}:${node_port}",
	}

}
