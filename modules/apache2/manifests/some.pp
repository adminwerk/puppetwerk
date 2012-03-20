# Class: apache2
#
# This class installs apache2
#
# Parameters:
#
# Actions:
#   - Install apache2
#   - Manage apache2 service
#
# Requires:
#
# Sample Usage:
#
class apache2 {
    class install {
        package {
            "package":
                ensure => present;
        }
    }

    class config {
        file {
            "/etc/apache2":
                ensure  => directory,
                owner   => root,
                group   => root,
                mode    => 700,
                require => Class["install"];

            "/etc/apache2/config":
                ensure  => present,
                owner   => root,
                group   => root,
                mode    => 600,
                require => Class["install"];
                #content => template ("apache2/config.erb");
                #source => [
                #   "puppet:///modules/apache2/${fqdn}.conf",
                #   "puppet:///modules/apache2/apache2.conf"
                #];
        }

        #logrotate::file { "apache2":
        #   source => "/etc/logrotate.d/apache2",
        #   log => "/var/log/logfile.log",
        #}
    }

    class service {
        service { "apache2":
            enable      => true,
            ensure      => running,
            #hasrestart => true,
            #hasstatus  => true,
            require     => Class["config"],
        }
    }

    include install
    include config
    include service

    Class["install"] ->
    Class["config"] ->
    Class["service"]
}
