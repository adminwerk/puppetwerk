#
#   class: mysqld_cluster::ndb_mgmd
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 29.02.2012
#   descr: run management daemon
#
#	stage: four-after-main
#	 info:

class mysqld_cluster::ndb_mgmd {

	notify { "ndb manager initial": }
	exec { "ndb_mgmd_initial":
		cwd => "${datadir}",
		command => "${basedir}/bin/ndb_mgmd -f conf/conf.ini --initial --configdir=${datadir}/conf/",
		creates => "${datadir}/ndb_data/ndb_3_fs/",
	}


	notify { "ndb manager continue": }
	exec { "ndb_mgmd_continue":
		unless => "test -d ${datadir}/ndb_data/ndb_3_fs/",
		cwd => "${datadir}",
		command => "${basedir}/bin/ndb_mgmd -f conf/conf.ini --configdir=${datadir}/conf/",
	}

}