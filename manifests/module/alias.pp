# Class: apache::module::alias
#
#
class apache::module::alias ($ensure=present) {
	apache::module { "alias":
		ensure => $ensure
	}
}
