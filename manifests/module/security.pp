# Class: apache::module::security
#
#
class apache::module::security ($ensure = present) {
	$pkg_name = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'libapache2-mod-security2',
		/(?i)(RedHat|CentOS)/ => 'mod_security',
	}
	
	package { $pkg_name:
		ensure => installed,
	}
	
	apache::module { 'security':
		ensure  => $ensure,
		require => Package[$pkg_name]
	}
}
