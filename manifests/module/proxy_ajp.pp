# Class: apache::module::proxy_ajp
#
#
class apache::module::proxy_ajp ($ensure=present) {
	apache::module {"proxy_ajp":
		ensure => $ensure
	}
}
