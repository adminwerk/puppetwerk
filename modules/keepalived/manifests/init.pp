#
#   class:
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 03.03.2012
#
#    info:
#

class keepalived {


	notify { "linux-headers-$kernelrelease to be present ": }

	package { 
		[ "linux-headers-$kernelrelease",
		  "build-essential",
		  "libssl-dev",
		  "libpopt-dev"]:
			ensure => "present";
	}

	# bilding from source
	exec { "build-keepalived-latest":
		cwd => "/tmp",
		command => "/usr/bin/wget ${download_url} -O /tmp/keepalived-${version}.tgz && /bin/tar xvzf keepalived-${version}.tgz && cd keepalived-${version} && ./configure --with-kernel-dir=/lib/modules/$kernelrelease/build && make && make install",
		creates => '/usr/local/sbin/keepalived',
		logoutput => on_failure,
		timeout => 0,
	}

	# create symlink to the right position(s)
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

	# create a new onfiguration file for this daemon
	keepalived::conf { "usr/local/etc/keepalived/keepalived.conf": }

	# service installieren
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










