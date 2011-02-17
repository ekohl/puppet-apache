define apache::webdav::svn ($ensure=present, $vhost, $parentPath, $confname) {
	include apache::params

	$location = $name

	file { "${apache::params::rootdir}/${vhost}/conf/${confname}.conf":
		ensure  => $ensure,
		content => template("apache/webdav/svn.erb"),
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		notify  => Exec["apache-graceful"]
	}
}
