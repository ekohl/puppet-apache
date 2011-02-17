define apache::auth::basic::file::group ($ensure=present, $authname="Private Area", $vhost, $location="/", $authUserFile=false, $authGroupFile=false, $groups) {
	include apache::params
	
	$fname = regsubst($name, "\s", "_", "G")

	if !defined(Apache::Module["authn_file"]) {
		apache::module { "authn_file": }
	}

	if $authUserFile {
		$_authUserFile = $authUserFile
	} else {
		$_authUserFile = "${apache::params::rootdir}/${vhost}/private/htpasswd"
	}

	if $authGroupFile {
		$_authGroupFile = $authGroupFile
	} else {
		$_authGroupFile = "${apache::params::rootdir}/${vhost}/private/htgroup"
	}

	file { "${apache::params::rootdir}/${vhost}/conf/auth-basic-file-group-${fname}.conf":
		ensure  => $ensure,
		content => template("apache/auth/basic/file/group.erb"),
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		notify => Exec["apache-graceful"]
	}
}
