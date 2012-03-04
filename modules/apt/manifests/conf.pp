#
# define: apt::conf
# author: example42
#    url: https://github.com/example42/puppet-modules/blob/master/apt/manifests/conf.pp
#  descr: general apt main configuration file's inline modification define
#         use with caution, it's still at experimental stage and may break 
#         in untested circumstances 
#         engine, pattern end line parameters can be tweaked for better behaviour
#
# usage:
# apt::conf    { "mynetworks":  value => "127.0.0.0/8 10.42.42.0/24" }
#
define apt::conf($ensure, $content = false, $source = false) {
  require apt::params
  
  if $content {
    file {"${apt::params::confd_dir}/${name}":
      ensure  => $ensure,
      content => $content,
      before  => Exec["aptget_update"],
      notify  => Exec["aptget_update"],
    }
  }

  if $source {
    file {"${apt::params::confd_dir}/${name}":
      ensure => $ensure,
      source => $source,
      before  => Exec["aptget_update"],
      notify  => Exec["aptget_update"],
    }
  }
}
