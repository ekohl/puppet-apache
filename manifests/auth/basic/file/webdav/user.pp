define apache::auth::basic::file::webdav::user ($vhost,
																								$ensure          = present,
																								$authname        = 'Private Area',
																								$location        = '/',
																								$authUserFile    = false,
																								$rw_users        = 'valid-user',
																								$limits          = 'GET HEAD OPTIONS PROPFIND',
																								$ro_users        = false
																								$allow_anonymous = false) {
	include apache::params
	include apache::module::authn_file

	$fname = regsubst($name, '\s', '_', 'G')
  
	if $authUserFile {
		$_authUserFile = $authUserFile
	} else {
		$_authUserFile = "${apache::params::rootdir}/${vhost}/private/htpasswd"
	}
  
	if $users != 'valid-user' {
		$_users = "user ${rw_users}"
	} else {
		$_users = $users
	}
  
	file { "${apache::params::rootdir}/${vhost}/conf/auth-basic-file-webdav-${fname}.conf":
		ensure  => $ensure,
		content => template('apache/auth/basic/file/webdav/user.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
	}
}
