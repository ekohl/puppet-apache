# Class: apache::module::fastcgi
#
#
class apache::module::fastcgi ($ensure=present) {
	package { "mod-fastcgi":
		name   => $operatingsystem ? {
			/(?i)(Debian|Ubuntu)/ => "libapache2-mod-fastcgi",
			/(?i)(RedHat|CentOS)/ => "mod_fcgid"
		},
		ensure => installed
	}
	
	apache::module { "fastcgi":
		ensure => $ensure
	}
}
