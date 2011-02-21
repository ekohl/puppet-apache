# Class: apache::module::proxy_html
#
#
class apache::module::proxy_html ($ensure=present) {
	package { "libapache2-mod-proxy-html":
		ensure => installed,
	}
	
	apache::module { "proxy_html":
		ensure  => $ensure,
		require => Package["libapache2-mod-proxy-html"]
	}
}
