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

