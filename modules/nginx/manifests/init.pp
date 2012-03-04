#
#   class: ntp
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 25.02.2012
#
class nginx {

	service { "nginx": ensure => running,}	

}