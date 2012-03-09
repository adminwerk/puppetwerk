#
#  define: user::virtual
#  author: chris@adminwerk.de
# version: 1.0.1
#    date: 09.03.2012
#    info:
#

class user::virtual {

	define user_dotfile ( $username ) {

		file { "/home/${username}/.${name}":
			source => "puppet:///modules/user/${username}-${name}",
			owner => $username,
			group => $username,
			mode => 750,
		}

	}

	define ssh_user ( $key, $dotfile = false ) {
		user { "$name":
			ensure => present,
			managehome => true,
			shell => "/bin/bash"
		}

		ssh_authorized_key { "${name}_key":
			key => $key,
			type => "ssh-rsa",
			user => $name,
		}

		if $dotfile {
			user_dotfile { $dotfile:
				username => $name,
			}
		}

	}

	@ssh_user { "sse":
		key => "AAAAB3NzaC1yc2EAAAABIwAAAQEAnRiIkbndexHA8hLMKqxJ8+5lyVQDJzABrKE469AMRTkYnH6HqmZUD4uNHBr3eTcKMnXReKIG85gI/PtfEa/avHtPt54crwQe8BmxyWFt35BqkcZF9vRwQBUVlG8T5zqYDtsnNVusVwQrdF6rYxKTRh+p1Xssc8SgcMk2YUTnPQxyeufmqZoJbzK0piUlZy9f2CJqPg9QTrGdWdNFC7xtSKp6bHG6mrGyPd7+jIrhoMV7G+C9aAcvb7CwJSWswft7Qq9r0cJVZeyidOSTdHI38N81Vku/WKtFKG60o1CQMXOhOWSmlSVBuIb2P68XliOqa4q0sYCGADVIbCrVx+jUqQ==",
	}

	@ssh_user { "cmr":
		key => "AAAAB3NzaC1yc2EAAAADAQABAAABAQDAWvRx0jSyzp8dddmWYk3MnO23EGDDEXxq22lwXGYoFgp78qbyrycaTJaefEBmclYVn8WDuMHrucBVP5qljQExTM8lfQsb1/qcweqNl5KoqByVxry2yzpqXIaaH6YAN4BFsumqPaURPk1mjJ0ZOg1Mdwu7Wmuas8hdiTSa1pv9klZzUYfceH3Cvqf6K8IybklsO46ORmBMZ7AgaAN+8FemGmgHPtKSy5o+ympcTqTIBJjfL9egDOpQZyrxsgANRS8Yg3CsKgWd/CaCfvEQIneUh855E7tFYLeTJTJgfAYRyKFH7P61csFgltGiQv/SSX27xqBUDn/ZtQpl7aLONHYD",
		dotfile => ["bashrc","bashrc2","screenrc"],
	}

}