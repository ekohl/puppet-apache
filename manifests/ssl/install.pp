# Class: apache::ssl::install
#
#
class apache::ssl::install {
	if ( $operatingsystem =~ /(?i)(Debian|Ubuntu)/ ) {
		if !defined(Package['ca-certificates']) {
			package { 'ca-certificates':
				ensure => present,
			}
		}
	}
}
