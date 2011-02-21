# Class: apache::module::authnz_ldap
#
#
class apache::module::authnz_ldap ($ensure=present) {
	apache::module { "authnz_ldap":
		ensure => $ensure
	}
}
