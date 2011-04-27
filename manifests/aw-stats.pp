define apache::aw-stats($ensure = present) {
	include apache::params

	file { "/etc/awstats/awstats.${name}.conf":
		ensure  => $ensure,
		content => template('apache/awstats.erb'),
		require => [ Class['apache::config'], Class['apache::awstats'] ]
	}
	
	$source = $operatingsystem ? {
		/(?i)(RedHat|CentOS)/ => 'puppet:///modules/apache/awstats.rh.conf',
		/(?i)(Debian|Ubuntu)/ => 'puppet:///modules/apache/awstats.deb.conf',
	}

	file { "${apache::params::rootdir}/${name}/conf/awstats.conf":
		ensure  => $ensure,
		owner   => 'root',
		group   => 'root',
		source  => $source,
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
		require => Apache::Vhost[$name],
	}
}
