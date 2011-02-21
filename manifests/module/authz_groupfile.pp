# Class: apache::module::authz_groupfile
#
#
class apache::module::authz_groupfile ($ensure=present) {
	apache::module { "authz_groupfile":
		ensure => $ensure
	}
}
