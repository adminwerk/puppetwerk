#
#  class: apt::unattended-upgrade
# author: example42
#    url: https://github.com/example42/puppet-modules/blob/master/apt/manifests/unattended-upgrade.pp
#

class apt::unattended-upgrade {
  package {"unattended-upgrades":
    ensure => present,
  }
}