class apache::administration {
	include apache::params

	group { "apache-admin":
		ensure => present
	}

	common::concatfilepart { "sudoers.apache":
		ensure  => present,
		file    => "/etc/sudoers",
		content => template("apache/sudoers.apache.erb"),
		require => Group["apache-admin"]
	}
}
