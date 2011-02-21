class apache::deflate {
	include apache::params
	include apache::module::deflate

	file { "deflate.conf":
		ensure  => present,
		path    => "${apache::params::confdir}/conf.d/deflate.conf",
		source  => "puppet:///modules/apache/deflate.conf",
		notify  => Exec["apache-graceful"],
		require => Class["apache::install"]
	}
}
