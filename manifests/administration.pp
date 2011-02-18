class apache::administration {
	include apache::params

	group { "apache-admin":
		ensure => present
	}

	# This requires /etc/sudoers to be already setup to use with concat module
	# TODO: move /etc/sudoers concat setup to a common module
	concat::fragment { "sudoers.apache":
		target  => "/etc/sudoers",
		order   => 20,
		content => template("apache/sudoers.erb"),
		require => Group["apache-admin"]
	}
}
