# Definition: mysqld::setmycnf
#
#
# Parameters:   
#
# Actions:
#   Creates mysql configuration file my,cnf
#
# Requires:
#
# Sample Usage:
#
define mysqld::setmycnf(

	$mysql_cnf_local-infile,
	$mysql_cnf_datadir,
	$mysql_cnf_socket,
	$mysql_cnf_old_password,
	$mysql_cnf_max_connections,
	$mysql_cnf_max_allowed_packet,
	$mysql_cnf_log-slow-queries,
	
	$mysql_cnf_user,
	$mysql_cnf_basedir,
	$mysql_cnf_log-error,
	$mysql_cnf_pid-file,
	$mysql_cnf_port ) {

	file { "set-mysql-ini":
		require => ,
		content => template("mysqld/my_cnf.erb"),
		mode => 644,
		notify => Service['mysql'],
	} # file
} # define