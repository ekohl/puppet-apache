# Class: apache::module::security
#
#
class apache::module::security ($ensure=present) {
	package { "mod-security":
		name   => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => "libapache-mod-security",
			/(?i)(RedHat|CentOS)/ => "mod_security"
		},
		ensure => installed
	}
	
	apache::module { "security":
		ensure  => $ensure,
		require => Package["mod-security"]
	}
}
ß