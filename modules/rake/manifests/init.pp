# install rake on a node and keep the latest version

class rake {
      package { "rake":
             ensure => latest,
      }
}
