class ha {

	package { 
		["pacemaker","corosync","heartbeat"]:
		ensure => latest,
	}

}