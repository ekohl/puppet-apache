class apache::security {
	include apache::module::security
	include apache::module::unique_id
	
	if ( $operatingsystem =~ /(?i)(RedHat|CentOS)/ ) {
		file { "/etc/httpd/conf.d/mod_security.conf":
			ensure  => present,
			source  => "puppet:///modules/apache/mod_security.conf",
			notify  => Class["apache::module::security"],
			require => Package["mod_security"],
		}
	}
}
