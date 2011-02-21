# Class: apache::module::ssl
#
#
class apache::module::ssl ($ensure=present) {
	if ( $operatingsystem =~ /(?i)(RedHat|CentOS)/ ) {
		package { "mod_ssl":
			ensure => $ensure
		}
		
		file { "/etc/httpd/conf.d/ssl.conf":
			ensure  => absent,
			require => Package["mod_ssl"]
		}
		
		if $lsbmajdistrelease == 5 {
	   		file { "/etc/httpd/mods-available/ssl.load":
				ensure  => present,
				content => template("apache/ssl.load.erb"),
				mode    => 644,
				owner   => root,
				group   => root,
				seltype => "httpd_config_t",
				require => File["/etc/httpd/mods-available"]
			}
		}
	}
	
	apache::module { "ssl":
		ensure => $ensure,
		require => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => $lsbmajdistrelease ? {
				"5"     => [ File["/etc/httpd/conf.d/ssl.conf"], File["/etc/httpd/mods-available/ssl.load"] ],
				default => File["/etc/httpd/conf.d/ssl.conf"]
			},
			default => undef
		}
	}
}
