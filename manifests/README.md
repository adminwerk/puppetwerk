# Manifest directory

This folder is the defined starting point for the puppet infrastructure. Set in puppet.conf via the
manifestdir option. First file called is the site.pp

## site.pp

The initial manifest has to spread word about everything else, which happens with the 'import' command.
Imported are some general classes and the nodes definitions.

	import "classes/*.pp"
	import "nodes/*.pp"

This option offers a good flexibility to handle each node in one file. The chosen naming convention
for nodes is simply hostname.pp. The nodes folder may contain relevant security informations. Therefor
it is not part of the repository. But it exists. A typical node looks like this:

	node "server.domain.tld" {

		$sensible_info = "it-could-go-here"
		$sensible_info2 = "and-here-too"

		include class1,
			class2,
			class...,
	}

