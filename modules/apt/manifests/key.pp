#
# define: apt::key
# author: example42
#    url: https://github.com/example42/puppet-modules/blob/master/apt/manifests/key.pp
#  descr: add key to keyring
#
# usage:
#  apt::key { "key id": url => 'key url',}
#

define apt::key ( $url="" ) {
    
    case $url {
        '' : {
            exec { "aptkey_add_${name}":
                command => "gpg --recv-key ${name} ; gpg -a --export | apt-key add -",
                unless  => "apt-key list | grep -q ${name}",
            }
        }
        default: {
            exec { "aptkey_add_${name}":
                command => "wget -O - ${url} | apt-key add -",
                unless  => "apt-key list | grep -q ${name}",
            }
        }
    }
}