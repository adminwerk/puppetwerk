class networking::iptablesflush {

	exec { "flush-iptables":
		command => "/sbin/iptables -F && /sbin/iptables -X && /sbin/iptables -t nat -F && /sbin/iptables -t nat -X && /sbin/iptables -t mangle -F 
					/sbin/iptables -t mangle -X && /sbin/iptables -P INPUT ACCEPT && /sbin/iptables -P FORWARD ACCEPT && /sbin/iptables -P OUTPUT ACCEPT",
		logoutput => on_failure,
		timeout => 0,
	}
}