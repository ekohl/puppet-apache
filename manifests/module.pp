define apache::module ($ensure=present) {
	include apache::params

	if $selinux == "true" {
		apache::redhat::selinux {$name: }
	}

	case $ensure {
		present: {
			exec { "a2enmod ${name}":
				command => $operatingsystem ? {
					/(?i)(Debian|Ubuntu)/ => "/usr//sbin/a2enmod ${name}",
					/(?i)(RedHat|CentOS)/ => "/usr/local/sbin/a2enmod ${name}"
				},
				unless  => "/bin/sh -c '[ -L ${apache::params::confdir}/mods-enabled/${name}.load ] && [ ${apache::params::confdir}/mods-enabled/${name}.load -ef ${apache::params::confdir}/mods-available/${name}.load ]'",
				notify  => Class["apache::service"],
				require => Class["apache::install"]
			}
		}
		absent: {
			exec { "a2dismod ${name}":
				command => $operatingsystem ? {
					/(?i)(Debian|Ubuntu)/ => "/usr/sbin/a2dismod ${name}",
					/(?i)(RedHat|CentOS)/ => "/usr/local/sbin/a2dismod ${name}"
				},
				onlyif  => "/bin/sh -c '[ -L ${apache::params::confdir}/mods-enabled/${name}.load ] || [ -e ${apache::params::confdir}/mods-enabled/${name}.load ]'",
				notify  => Class["apache::service"],
				require => Class["apache::install"]
			}
		}
		default: { 
			err ("Unknown ensure value: '${ensure}'") 
		}
	}
}
