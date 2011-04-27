# Class: apache::module::proxy
#
#
class apache::module::proxy ($ensure = present) {
	apache::module { 'proxy':
		ensure => $ensure,
	}
}
