# Class: apache::module::unique_id
#
#
class apache::module::unique_id ($ensure=present) {
	apache::module { "unique_id":
		ensure => $ensure
	}
}
