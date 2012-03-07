#
#  define: nginx::conf
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 07.03.2012
#    info:
#
#   usage: 
#
# nginx::conf { "/etc/nginx/nginx.conf":
#	nginx_user => "www-data",
#	nginx_worker_processes => "4",
#	nginx_pid => "/var/run/nginx.pid",
# 	nginx_worker_connections => "768"
# }

define nginx::conf (

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