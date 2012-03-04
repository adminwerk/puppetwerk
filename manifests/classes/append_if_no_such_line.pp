#
#  define: append_if_no_such_line
#  author: chris@adminwerk.de
# version: 1.0.0
#    date: 25.02.2012
# 

define append_if_no_such_line($file,$line) {
   exec { "/bin/echo '$line' >> '$file'" :
	   unless => "/bin/grep -Fx '$line' '$file'",
   }
}
