class apache::administration {
	include apache::params

	group { "apache-admin":
		ensure => present
	}

	# This requires the sudo module to be included somewhere in your setup
	sudo::directive { "sudoers.apache":
		ensure  => present,
		content => template("apache/sudoers.erb"),
		require => Group["apache-admin"]
	}
}
