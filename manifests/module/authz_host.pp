# Class: apache::module::authz_host
#
#
class apache::module::authz_host ($ensure=present) {
	apache::module { "authz_host":
		ensure => $ensure
	}
}
