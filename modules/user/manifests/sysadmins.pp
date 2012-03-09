#
#  define: user::sysadmins
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 08.03.2012
#    info:

class user::sysadmins {

	search User::Virtual

	realize( Ssh_User['sse'],
			 Ssh_User['cmr'])

}