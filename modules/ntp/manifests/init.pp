#
#   class: ntp
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 16.02.2012
#
class ntp {
      package { "ntp": ensure => latest,}
      service { "ntp": enable => true,
	                   ensure => running,}
}
