#
# == Class: apache::dev
#
# Installs package(s) required to build apache modules using apxs.
#
# Limitation: currently only works on redhat.
#
# Example usage:
#
#   include apache::dev
#
class apache::dev {
	package { "apache-devel":
		name    => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd-devel"
		},
		ensure  => present,
		require => Package["gcc"]
	}
}
