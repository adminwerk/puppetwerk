define nginx::setup::conf (

	# [GLOBALS]
	$nginx_user,
	$nginx_worker_processes,
	$nginx_pid,
	$nginx_worker_connections) {

	file {
		"/etc/nginx/nginx.conf":
			owner => "root",
			group => "root",
			mode => "744",
			content => template("nginx/nginx.conf.erb"),
			ensure => present
	}

}