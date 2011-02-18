# Class: apache::install
#
#
class apache::install {
	package { $apache::params::pkgname:
		ensure => installed,
		require => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => [ File["/usr/local/sbin/a2ensite"], File["/usr/local/sbin/a2dissite"], File["/usr/local/sbin/a2enmod"], File["/usr/local/sbin/a2dismod"] ],
			default               => undef
		}
	}
	
	user { $apache::params::user:
		ensure  => present,
		shell   => "/bin/sh",
		require => Package[$apache::params::pkgname]
	}

	group { $apache::params::group:
		ensure  => present,
		require => Package[$apache::params::pkgname]
	}
	
	case $operatingsystem {
		/(?i)(Debian|Ubuntu)/: {
			package { "apache2-mpm-prefork":
				ensure  => installed,
				require => Package[$apache::params::pkgname]
			}
		}
		/(?i)(RedHat|CentOS)/: {
			file { [ "/usr/local/sbin/a2ensite", "/usr/local/sbin/a2dissite", "/usr/local/sbin/a2enmod", "/usr/local/sbin/a2dismod" ]:
				ensure => present,
				mode   => 755,
				owner  => root,
				group  => root,
				source => "puppet:///modules/apache/usr/local/sbin/a2X.redhat"
			}
		}
		default: { notice "Unsupported operatingsystem ${operatingsystem}" }
	}
}
