# Class: apache::install
#
#
class apache::install {
	$pkg_requires = $operatingsystem ? {
		/(?i)(RedHat|CentOS)/ => [ File["/usr/local/sbin/a2ensite"], File["/usr/local/sbin/a2dissite"], File["/usr/local/sbin/a2enmod"], File["/usr/local/sbin/a2dismod"] ],
		default               => undef,
	}
	
	package { $apache::params::pkgname:
		ensure  => installed,
		require => $pkg_requires,
	}
	
	user { $apache::params::user:
		ensure  => present,
		shell   => $apache::params::user_shell,
		require => Package[$apache::params::pkgname],
	}

	group { $apache::params::group:
		ensure  => present,
		require => Package[$apache::params::pkgname],
	}
	
	include "apache::install::${apache::params::os_suffix}"
}
