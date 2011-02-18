class apache::security {
	case $operatingsystem {
		/(?i)(RedHat|CentOS)/: {
			package { "mod_security":
				ensure => present,
				alias  => "apache-mod_security"
			}

			file { "/etc/httpd/conf.d/mod_security.conf":
				ensure  => present,
				source  => "puppet:///modules/apache/mod_security.conf",
				require => Package["mod_security"],
				notify  => Exec["apache-graceful"]
			}
		}
		/(?i)(Debian|Ubuntu)/: {
			package { "libapache-mod-security":
				ensure => present,
				alias  => "apache-mod_security"
			}
		}
	}
	
	apache::module { [ "unique_id", "security" ]:
		ensure  => present,
		require => Package["apache-mod_security"]
	}
}
