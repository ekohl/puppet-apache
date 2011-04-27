define apache::userdirinstance ($vhost,
																$ensure = present) {
	include apache::params

	file { "${apache::params::rootdir}/${vhost}/conf/userdir.conf":
		ensure  => $ensure,
		source  => 'puppet:///modules/apache/userdir.conf',
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
	}
}
