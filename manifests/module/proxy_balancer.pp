# Class: apache::module::proxy_balancer
#
#
class apache::module::proxy_balancer ($ensure=present) {
	apache::module {"proxy_balancer":
		ensure => $ensure
	}
}
