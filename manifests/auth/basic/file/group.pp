define apache::auth::basic::file::group ($vhost,
																				 $groups,
																				 $ensure        = present,
																				 $authname      = 'Private Area',
																				 $location      = '/',
																				 $authUserFile  = false,
																				 $authGroupFile = false) {
	include apache::params
	include apache::module::authn_file
	
	$fname = regsubst($name, '\s', '_', 'G')

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
		content => template('apache/auth/basic/file/group.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
	}
}
