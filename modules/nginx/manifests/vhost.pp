#
#  define: nginx::vhost
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 07.03.2012
#    info:
#
#   usage: nginx::vhost::site { "domain.tld": }
#

class nginx::vhost {
	
	define site (
		$siteName = $title,
		$vhost_port,
		$upstream,
		$server_1_ip,
		$server_2_ip,
		$server_3_ip,
		$vhost_index,
		$vhost_proxy_cache,
		$vhost_proxy_cache_valid ) {
	
	file { 
		"/etc/nginx/sites-available/$title.conf":
			ensure => present,
			owner => "root",
			group => "root",
			mode => 644,
			content => template("nginx/vhost.erb");
		
		"/var/www":
			ensure => "directory",
			owner => "www-data",
			group => "www-data",
			mode => 770;

		"/var/www/$title":
			ensure => present,
			owner => "www-data",
			group => "www-data";
		
		"/etc/nginx/sites-enabled/$title.conf":
			ensure => symlink,
			target => "/etc/nginx/sites-available/$title.conf",
			notify => Service['nginx'];

	}

  }

}