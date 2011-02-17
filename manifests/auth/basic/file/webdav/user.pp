define apache::auth::basic::file::webdav::user ($ensure=present, $authname="Private Area", $vhost, $location="/", $authUserFile=false, $rw_users="valid-user",
												$limits='GET HEAD OPTIONS PROPFIND', $ro_users=False, $allow_anonymous=false) {
	include apache::params

	$fname = regsubst($name, "\s", "_", "G")
	
	if !defined(Apache::Module["authn_file"]) {
		apache::module {"authn_file": }
	}
  
	if $authUserFile {
		$_authUserFile = $authUserFile
	} else {
		$_authUserFile = "${apache::params::rootdir}/${vhost}/private/htpasswd"
	}
  
	if $users != "valid-user" {
		$_users = "user $rw_users"
	} else {
		$_users = $users
	}
  
	file { "${apache::params::rootdir}/${vhost}/conf/auth-basic-file-webdav-${fname}.conf":
		ensure  => $ensure,
		content => template("apache/auth/basic/file/webdav/user.erb"),
		seltype => $operatingsystem ? {
			/(?i)(RedHat|CentOS)/ => "httpd_config_t",
			default               => undef
		},
		notify => Exec["apache-graceful"]
	}
}
