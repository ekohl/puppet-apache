# Class: apache::module::setenvif
#
#
class apache::module::setenvif ($ensure=present) {
	apache::module { "setenvif":
		ensure => $ensure
	}
}
