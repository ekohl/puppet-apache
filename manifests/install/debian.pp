# Class: apache::install::debian
#
#
class apache::install::debian {
	package { $apache::params::mpm_package:
		ensure  => installed,
		require => Package[$apache::params::pkgname],
	}
}
