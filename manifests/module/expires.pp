# Class: apache::module::expires
#
#
class apache::module::expires ($ensure = present) {
	apache::module { 'expires':
		ensure => $ensure,
	}
}
