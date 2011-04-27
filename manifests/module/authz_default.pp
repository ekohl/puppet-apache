# Class: apache::module::authz_default
#
#
class apache::module::authz_default ($ensure = present) {
	apache::module { 'authz_default':
		ensure => $ensure,
	}
}
