# Class: apache::module::suexec
#
#
class apache::module::suexec ($ensure = present) {
	apache::module { 'suexec':
		ensure => $ensure,
	}
}
