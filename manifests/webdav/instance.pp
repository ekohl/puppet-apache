define apache::webdav::instance ($ensure=present, $vhost, $directory=false) {
	include apache::params
 
	if $directory {
		$davdir = "${directory}/webdav-${name}"
	} else {
		$davdir = "${apache::params::rootdir}/${vhost}/private/webdav-${name}"
	}

	file { $davdir:
		ensure => $ensure ? {
			present => directory,
			absent  => absent
		},
		owner  => "www-data",
		group  => "www-data",
		mode   => 2755
	}

	# configuration
	file { "${apache::params::rootdir}/${vhost}/conf/webdav-${name}.conf":
		ensure  => $ensure,
		content => template("apache/webdav/config.erb"),
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		require => File[$davdir],
		notify  => Exec["apache-graceful"]
	}
}
