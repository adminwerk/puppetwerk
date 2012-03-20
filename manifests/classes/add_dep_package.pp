define add_dep_package( $dep_package) { 

	package { "$dep_package":
		ensure => latest,
	}

}