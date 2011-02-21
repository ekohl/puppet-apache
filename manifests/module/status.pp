# Class: apache::module::status
#
#
class apache::module::status ($ensure=present) {
	apache::module { "status":
		ensure => $ensure
	}
}
