#
#  define: nginx::options
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 07.03.2012
#    info:
#
#   usage: this is an example usage for a reverse proxy server with only the
#          options sourced out
#
# nginx::options { "/etc/nginx/conf.d/options.conf":
#
#    nginx_client_body_buffer_size => "128K",
#    nginx_client_header_buffer_size => "1M",
#    nginx_client_max_body_size => "1M",
#	 nginx_large_client_header_buffers => "8 8k",
#	
#	 nginx_client_body_timeout => "60",
#	 nginx_client_header_timeout => "60",
#	 nginx_expires => "24h",
#	 nginx_keepalive_timeout => "30",
#	 nginx_send_timeout => "60",
#
#	 nginx_ignore_invalid_headers => "on",
#	 nginx_keepalive_requests => "100",
#	 nginx_limit_zone => "5m",	
#	 nginx_recursive_error_pages => "on",
#	 nginx_sendfile => "on",
#	 nginx_server_name_in_redirect => "off",
#	 nginx_server_tokens => "off",
#
#	 nginx_tcp_nodelay => "on",
#	 nginx_tcp_nopush => "on",
#
#	 nginx_gzip => "on",
#	 nginx_gzip_buffers => "16 8k",
#	 nginx_gzip_comp_level => "6",
#	 nginx_gzip_http_version => "1.0",
#	 nginx_gzip_min_length => "0",
#	 nginx_gzip_types => "text/plain text/css image/x-icon application/x-perl application/x-httpd-cgi",
#	 nginx_gzip_vary => "on",
# }


define nginx::options (

	$nginx_client_body_buffer_size,
	$nginx_client_header_buffer_size,
	$nginx_client_max_body_size,
	$nginx_large_client_header_buffers,
	
	$nginx_client_body_timeout,
	$nginx_client_header_timeout,
	$nginx_expires,
	$nginx_keepalive_timeout,
	$nginx_send_timeout,

	$nginx_ignore_invalid_headers,
	$nginx_keepalive_requests,
	$nginx_limit_zone,	
	$nginx_recursive_error_pages,
	$nginx_sendfile,
	$nginx_server_name_in_redirect,
	$nginx_server_tokens,

	$nginx_tcp_nodelay,
	$nginx_tcp_nopush,

	$nginx_gzip,
	$nginx_gzip_buffers,
	$nginx_gzip_comp_level,
	$nginx_gzip_http_version,
	$nginx_gzip_min_length,
	$nginx_gzip_types,
	$nginx_gzip_vary ) {

	include nginx

	file { 
		"/etc/nginx/conf.d/":
			ensure => "directory",
			owner => "root",
			group => "root",
			mode => "744";
	
		"/etc/nginx/conf.d/options.conf":
			path => "/etc/nginx/conf.d/options.conf",
			owner => "root",
			group => "root",
			mode => "644",
			content => template("nginx/options.conf.erb"),
			ensure => present,
			notify => Service['nginx'],
	}

}