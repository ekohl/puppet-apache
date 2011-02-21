# Class: apache::module::log_config
#
#
class apache::module::log_config ($ensure=present) {
	# this module is statically compiled on debian and must be enabled for RedHat/CentOS
	if ( $operatingsystem =~ /(?i)(RedHat|CentOS)/ ) {
		apache::module { "log_config":
			ensure => $ensure
		}
	}
}
