#
#   class: mysqld_cluster::prepare
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 29.02.2012
#
#   stage: main
#    info: prepare the installation of a mysql-cluster
#

class mysqld_cluster::prepare {

   notify { "user/group": }
   user { "mysql":
      comment => "mysql user to run the cluster",
      ensure => present,
      home => "${basedir}",
      shell => "/bin/false",
   }  

   notify { "files/directories": }
   file { 

      # copy the deb file to a temporary spot
      "${cluster_pack_tmp}/mysql-cluster/":
         ensure => "directory",
      	owner => root,
      	group => root,
      	mode => 644,
      	source => "puppet:///data/mysql_cluster/", #${cluster_name}-${cluster_version}-${cluster_dist}.deb",
         recurse => true;
   
      # data directory
      "${datadir}":
         ensure => "directory",
         owner => "mysql",
         group => "mysql",
         mode => "770",
         source => "puppet:///data/mysql/",
         recurse => true; 

   }

  

}
