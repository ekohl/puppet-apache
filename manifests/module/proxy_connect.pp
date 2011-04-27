# Class: apache::module::proxy_connect
#
#
class apache::module::proxy_connect ($ensure = present) {
	apache::module { 'proxy_connect':
		ensure => $ensure,
	}
}
