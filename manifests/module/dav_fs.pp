# Class: apache::module::dav_fs
#
#
class apache::module::dav_fs ($ensure = present) {
	apache::module { 'dav_fs':
		ensure => $ensure,
	}
}
