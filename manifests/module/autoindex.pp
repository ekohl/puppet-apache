# Class: apache::module::autoindex
#
#
class apache::module::autoindex ($ensure = present) {
	apache::module { 'autoindex':
		ensure => $ensure,
	}
}
