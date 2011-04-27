define apache::webdav::svn ($vhost,
														$parentPath,
														$confname,
														$ensure = present) {
	include apache::params

	$location = $name

	file { "${apache::params::rootdir}/${vhost}/conf/${confname}.conf":
		ensure  => $ensure,
		content => template('apache/webdav/svn.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
	}
}
