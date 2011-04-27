# Class: apache::module::fastcgi
#
#
class apache::module::fastcgi ($ensure = present) {
	$pkg_name = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => 'libapache2-mod-fastcgi',
		/(?i)(RedHat|CentOS)/ => 'mod_fcgid',
	}
	
	package { $pkg_name:
		ensure => installed,
	}
	
	apache::module { 'fastcgi':
		ensure  => $ensure,
		require => Package[$pkg_name],
	}
}
