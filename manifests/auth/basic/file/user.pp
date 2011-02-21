define apache::auth::basic::file::user ($ensure=present, $authname="Private Area", $vhost, $location="/", $authUserFile=false, $users="valid-user") {
	include apache::params
	include apache::module::authn_file

	$fname = regsubst($name, "\s", "_", "G")

	if $authUserFile {
		$_authUserFile = $authUserFile
	} else {
		$_authUserFile = "${apache::params::rootdir}/${vhost}/private/htpasswd"
	}

	if $users != "valid-user" {
		$_users = "user $users"
	} else {
		$_users = $users
	}

	file { "${apache::params::rootdir}/${vhost}/conf/auth-basic-file-user-${fname}.conf":
		ensure  => $ensure,
		content => template("apache/auth/basic/file/user.erb"),
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		notify => Exec["apache-graceful"]
	}
}
