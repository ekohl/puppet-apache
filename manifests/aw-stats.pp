define apache::aw-stats($ensure=present) {
	include apache::params

	file { "/etc/awstats/awstats.${name}.conf":
		ensure  => $ensure,
		content => template("apache/awstats.erb"),
		require => [ Package["apache"], Class["apache::awstats"] ]
	}

	# used in ERB template
	$wwwroot = $apache::params::root

	file { "${apache::params::root}/${name}/conf/awstats.conf":
		ensure  => $ensure,
		owner   => root,
		group   => root,
		source  => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "puppet:///modules/apache/awstats.rh.conf",
			/(?i)(Debian|Ubuntu)/ => "puppet:///modules/apache/awstats.deb.conf"
		},
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		notify  => Exec["apache-graceful"],
		require => Apache::Vhost[$name]
	}
}
