# Class: apache::module::userdir
#
#
class apache::module::userdir ($ensure=present) {
	apache::module { "userdir":
		ensure => $ensure
	}
}
