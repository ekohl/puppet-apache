# Class: apache::module::authn_file
#
#
class apache::module::authn_file ($ensure = present) {
	apache::module { 'authn_file':
		ensure => $ensure,
	}
}
