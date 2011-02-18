# Class: apache::ssl::config
#
#
class apache::ssl::config {
	apache::listen { "443":
		ensure => present
	}
	
	apache::namevhost { "*:443":
		ensure => present
	}

	file { "/usr/local/sbin/generate-ssl-cert.sh":
		source => "puppet:///modules/apache/generate-ssl-cert.sh",
		mode   => 755
	}
	
	case $operatingsystem {
		/(?i)(Debian|Ubuntu)/: {
			apache::module { "ssl":
				ensure => present
			}
		}
		/(?i)(RedHat|CentOS)/: {
			file { "/etc/httpd/conf.d/ssl.conf":
				ensure  => absent,
				require => Package["mod_ssl"],
				notify  => Service["apache"],
				before  => Exec["apache-graceful"]
			}

			apache::module { "ssl":
				ensure  => present,
				require => File["/etc/httpd/conf.d/ssl.conf"],
				notify  => Service["apache"],
				before  => Exec["apache-graceful"]
			}

			if $lsbmajdistrelease == 5 {
		   		file { "/etc/httpd/mods-available/ssl.load":
					ensure  => present,
					content => template("apache/ssl.load.erb"),
					mode    => 644,
					owner   => root,
					group   => root,
					seltype => "httpd_config_t",
					require => File["/etc/httpd/mods-available"]
				}
			}
		}
		default: {
			notice("Unsupported operatingsystem ${operatingsystem}")
		}
	}
}