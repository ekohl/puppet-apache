# Class: apache::module::env
#
#
class apache::module::env ($ensure=present) {
	apache::module { "env":
		ensure => $ensure
	}
}
