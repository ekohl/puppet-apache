# Class: apache::module::mime
#
#
class apache::module::mime ($ensure = present) {
	apache::module { 'mime':
		ensure => $ensure,
	}
}
