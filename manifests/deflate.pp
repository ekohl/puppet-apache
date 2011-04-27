class apache::deflate {
	include apache::params
	include apache::module::deflate

	file { "${apache::params::confdir}/conf.d/deflate.conf":
		ensure  => present,
		source  => 'puppet:///modules/apache/deflate.conf',
		notify  => Exec['apache-graceful'],
		require => Class['apache::install']
	}
}
