# Class: apache::module::dav
#
#
class apache::module::dav ($ensure = present) {
	apache::module { 'dav':
		ensure => $ensure,
	}
}
