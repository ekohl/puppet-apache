# Class: apache::module::deflate
#
#
class apache::module::deflate ($ensure=present) {
	apache::module { "deflate":
		ensure => $ensure
	}
}
