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
				ensure => symlink,
				target => "/usr/local/etc/rc.d/init.d/keepalived";  
			"/etc/default/keepalived":
				ensure => symlink,
				target => "/usr/local/etc/sysconfig/keepalived";
	}

	# service installieren
	service { "keepalived": 
		enable => true,
	}

}