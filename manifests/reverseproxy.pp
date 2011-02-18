class apache::reverseproxy {
	include apache::params

	apache::module { [ "proxy", "proxy_http", "proxy_ajp", "proxy_connect" ]: }

	file { "reverseproxy.conf":
		ensure  => "present",
		path    => "${apache::params::confdir}/conf.d/reverseproxy.conf",
		source  => "puppet:///modules/apache/reverseproxy.conf",
		notify  => Exec["apache-graceful"],
		require => Class["apache::install"]
	}
}
