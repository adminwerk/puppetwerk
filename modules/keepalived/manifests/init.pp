#
#   class: keepalived
#  author: chris@adminwerk.de
# version: 1.0.2
#    date: 06.03.2012
#
#    info: installs 'keepalived' from source, 
#          creates symlinks and adds an init script
#

class keepalived {

	package { 
		[ "linux-headers-$kernelrelease",
		  "build-essential",
		  "libssl-dev",
		  "libpopt-dev"]:
			ensure => "present";
	}

	# building from source
	exec { "build-keepalived-latest":
		cwd => "/tmp",
		command => "/usr/bin/wget ${download_url} -O /tmp/keepalived-${version}.tgz && /bin/tar xvzf keepalived-${version}.tgz && cd keepalived-${version} && ./configure --with-kernel-dir=/lib/modules/$kernelrelease/build && make && make install",
		creates => '/usr/local/sbin/keepalived',
		logoutput => on_failure,
		timeout => 0,
	}

	# create symlinks and files required
	file { "/etc/keepalived":
				ensure => symlink,
				target => "/usr/local/etc/keepalived";
		   "/etc/init.d/keepalived":
				owner => "root",
				group => "root",
				mode => "755",
				source => "puppet:///data/keepalived/init/keepalived";  
			"/etc/default/keepalived":
				ensure => symlink,
				target => "/usr/local/etc/sysconfig/keepalived";
	}

	# create a new configuration file for this daemon
	keepalived::conf { "usr/local/etc/keepalived/keepalived.conf": }

	# allow the application to bind to non local addresses
	# and call 'sysctl -p' after
	append_if_no_such_line { "add-sysctl-nonlocal-bind":
		file => "/etc/sysctl.conf",
		line => "net.ipv4.ip_nonlocal_bind = 1",
		notify => Exec['sysctl-p'],
	}

	exec { "sysctl-p":
		command => "/sbin/sysctl -p",
		refreshonly => true,
	}

	# install service
	service { "keepalived": 
		enable => true,
	}

}


define keepalived::conf (
		
		notification_email = "${notification_email}",
		notification_email_from = "${notification_email_from}",
		smtp_server = "${smtp_server}",
		smtp_connect_timeout = "30",

		priority = "${hostname_priority}",
		auth_pass = "${auth_pass}",
		virtual_ipaddress = "${virtual_ipaddress}",
		ka_param= "${ka_param}", 
		eth="${eth}" ) {

	file { "/usr/local/etc/keepalived/keepalived.conf":
		owner => "root",
		group => "root",
		mode => "644",
		content => template("/etc/puppet/modules/keepalived/templates/keepalived.erb"),
		notify => Service['keepalived'],
	}
}










