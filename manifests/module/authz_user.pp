# Class: apache::module::authz_user
#
#
class apache::module::authz_user ($ensure=present) {
	apache::module { "authz_user":
		ensure => $ensure
	}
}
