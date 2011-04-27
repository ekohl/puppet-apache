# Class: apache::module::ldap
#
#
class apache::module::ldap ($ensure = present) {
	apache::module { 'ldap':
		ensure => $ensure,
	}
}
