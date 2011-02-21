class apache::reverseproxy {
	include apache::params
	include apache::module::proxy
	include apache::module::proxy_ajp
	include apache::module::proxy_connect
	include apache::module::proxy_http

	file { "reverseproxy.conf":
		ensure  => "present",
		path    => "${apache::params::confdir}/conf.d/reverseproxy.conf",
		source  => "puppet:///modules/apache/reverseproxy.conf",
		notify  => Exec["apache-graceful"],
		require => Class["apache::install"]
	}
}
