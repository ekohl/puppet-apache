# Class: apache::module::negotiation
#
#
class apache::module::negotiation ($ensure=present) {
	apache::module { "negotiation":
		ensure => $ensure
	}
}
