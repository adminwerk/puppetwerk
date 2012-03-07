#
#  define: nginx::proxy
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 07.03.2012
#    info:
#
#   usage: take a look at e.g. nginx::conf as this 
#		   works exactely the same
#

define nginx::proxy (

	$nginx_proxy_buffering,
	$nginx_proxy_cache_min_uses,
	$nginx_proxy_cache_path,
	$nginx_proxy_cache_valid,
	$nginx_proxy_ignore_client_abort,
	$nginx_proxy_intercept_errors,
	$nginx_proxy_next_upstream,
	$nginx_proxy_redirect,
	$nginx_proxy_set_header,
	$nginx_proxy_connect_timeout,
	$nginx_proxy_send_timeout,
	$nginx_proxy_read_timeout ) {

	include nginx

	file {
		"/etc/nginx/conf.d/proxy.conf":
			owner => "root",
			group => "root",
			mode => "644",
			content => template("nginx/proxy.conf.erb"),
			ensure => present
	}

}