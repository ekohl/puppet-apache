# Class: apache::module::rewrite
#
#
class apache::module::rewrite ($ensure = present) {
	apache::module { 'rewrite':
		ensure => $ensure,
	}
}
