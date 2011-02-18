# Class: apache::service
#
#
class apache::service {
	service { "apache":
		name       => $apache::params::servicename,
		ensure     => running,
		enable     => true,
		hasrestart => true,
		require    => Class["apache::config"]
	}
}
