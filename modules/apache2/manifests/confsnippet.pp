# = Define: apache2::confsnippet
#
# This define enables one to add specific code snippets to Apaches
# master configuration.
#
# == Parameters:
#
# == Actions:
#  
# == Requires:
#
# == Sample Usage: 
#
#	apache2::confsnippet { "specific.conf": }
#
define apache2::confsnippet() {
	
	# TODO: [201203211213] outsource path|source values
	file { "/etc/apache2/conf.d/${name}":
		source => "puppet:///data/apache2/${name}",
		notify => Service['apache2']
	}
	
}