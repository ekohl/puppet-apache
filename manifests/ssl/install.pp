# Class: apache::ssl::install
#
#
class apache::ssl::install {
	case $operatingsystem {
		/(?i)(Debian|Ubuntu)/: {
			if !defined(Package["ca-certificates"]) {
				package { "ca-certificates":
					ensure => present
				}
			}
		}
		/(?i)(RedHat|CentOS)/: {
			package { "mod_ssl":
				ensure => installed
			}
		}
		default: {
			notice("Unsupported operatingsystem ${operatingsystem}")
		}
	}
}
