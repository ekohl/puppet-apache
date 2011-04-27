# Class: apache::module::dir
#
#
class apache::module::dir ($ensure = present) {
	apache::module { 'dir':
		ensure => $ensure,
	}
}
