#
#   class: mysqld::prepare
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 01.03.2012
#
#   stage: main
#    info: prepare the installation of mysqld
#

class mysqld::prepare {

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
      "${mysqld_pack_tmp}/mysqld/":
         ensure => "directory",
      	owner => root,
      	group => root,
      	mode => 644,
      	source => "puppet:///data/mysqld/", #${cluster_name}-${cluster_version}-${cluster_dist}.deb",
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
