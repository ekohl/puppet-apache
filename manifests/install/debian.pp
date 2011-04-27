# Class: apache::install::debian
#
#
class apache::install::debian {
	package { 'apache2-mpm-prefork':
		ensure  => installed,
		require => Package[$apache::params::pkgname],
	}
}
