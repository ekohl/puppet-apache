# Class: apache::module::auth_basic
#
#
class apache::module::auth_basic ($ensure=present) {
	apache::module { "auth_basic":
		ensure => $ensure
	}
}
