#
#  define: user::systems
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 14.03.2012
#    info:

class user::systems {

	search User::Virtual
	realize( Ssh_User['tunnel-ws01'],)

}