#
#  define: keepalived::conf
#  author: chris@adminwerk.de
# version: 1.0.3
#    date: 07.03.2012
#
#    info: configures the most vital elements for the 'keepalived' daemon  
#   usage:
#
# keepalived::conf { "/usr/local/etc/keepalived/keepalived.conf":
# 		notification_email => "${notification_email}",
#		notification_email_from => "${notification_email_from}",
#		smtp_server => "${smtp_server}",
#		smtp_connect_timeout => "30",
#		state => "MASTER",
#		priority => "${hostname_priority}",
#		auth_pass => "${auth_pass}",
#		virtual_ipaddress => "${virtual_ipaddress}",
#		ka_param => "${ka_param}", 
#		eth =>"${eth}"
# }


define keepalived::conf (
		
		$notification_email,
		$notification_email_from,
		$smtp_server,
		$smtp_connect_timeout,
		$unique_id,
		$state,
		$priority,
		$auth_pass,
		$virtual_ipaddress,
		$ka_param,
		$eth ) {

	include keepalived

	file { "/usr/local/etc/keepalived/keepalived.conf":
		owner => "root",
		group => "root",
		mode => "644",
		content => template("/etc/puppet/modules/keepalived/templates/keepalived.erb"),
		notify => Service['keepalived'],
	}

}