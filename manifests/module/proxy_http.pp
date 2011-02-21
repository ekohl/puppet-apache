# Class: apache::module::proxy_http
#
#
class apache::module::proxy_http ($ensure=present) {
	apache::module { "proxy_http":
		ensure => $ensure
	}
}
