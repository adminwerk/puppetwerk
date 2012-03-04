#
#   class: mysqld_cluster::setup
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 29.02.2012
#
#	stage: one-after-main
#    info: installs the cluster software
#

class mysqld_cluster::setup {
    # dependencies
    package { 

      "libaio1":
          ensure => latest;

      "mysql-cluster-gpl":
        provider => dpkg,
        ensure => installed,
        source => "${cluster_pack_tmp}/mysql-cluster/mysql-cluster-gpl-7.2.4-debian6.0-x86_64.deb",
 	}
}
