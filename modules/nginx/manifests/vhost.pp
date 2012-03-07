#
#  define: nginx::vhost::001
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 07.03.2012
#    info:
#
#   usage: 
#

define nginx::vhost:001 (

	# [GLOBALS]
	$nginx_user,
	$nginx_worker_processes,
	$nginx_pid,
	$nginx_worker_connections) {

	include nginx

	file {
		"/etc/nginx/nginx.conf":
			owner => "root",
			group => "root",
			mode => "644",
			content => template("nginx/nginx.conf.erb"),
			ensure => present
	}

}