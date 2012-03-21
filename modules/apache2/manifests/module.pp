# = Define: apache2::module
#
# This module installs a module to Apache2
#
# == Parameters:
#
# == Actions:
#  
# == Requires:
#
# == Sample Usage: 
# apache2::module { "php5":
#	load_module => "php5_module",
#	load_module_so => "libphp5.so"
# } 
#
define apache2::module( $ensure = 'present', $load_module = '${name}_module', $load_module_so = '${name}_module.so'){
	
	case $ensure {
		present,installed: {
			file { 
				"${apache2::basedir}/mods-available/${name}.conf": 
					ensure => present,
					source => "puppet:///data/${name}/${name}.conf",
					mode => 644,
					owner => root;
				"${apache2::basedir}/mods-available/${name}.load":
					ensure => present,
					content => "LoadModule ${load_module} ${apache2::moduledir}/${load_module_so}",
					mode => 644,
					owner => root;
			}#file
		
			# set the module on fire
			exec { "/usr/sbin/a2enmod ${name}":
				creates => "${apache2::basedir}/mods-enabled/${name}.load",
				notify => Service["apacheService"],
				require => Package["apachePackage"]
			} # exec
		}# present,installed

		absent,purged: {
			# set back
			exec { "/usr/sbin/a2dismod ${name}":
				onlyif => "/usr/bin/test -L ${apache2::basedir}/mods-enabled/${name}.load",
				notify => Service["apacheService"],
				require => Package["apachePackage"]
			} # exec
			
		}# absent,purged
	}
}