define apache::userdirinstance ($ensure=present, $vhost) {
	include apache::params

	file { "${apache::params::rootdir}/${vhost}/conf/userdir.conf":
		ensure  => $ensure,
		source  => 'puppet:///modules/apache/userdir.conf',
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default  => undef
		},
		notify  => Exec["apache-graceful"]
	}
}
