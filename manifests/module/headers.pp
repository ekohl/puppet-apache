# Class: apache::module::headers
#
#
class apache::module::headers ($ensure = present) {
	apache::module { 'headers':
		ensure => $ensure,
	}
}
