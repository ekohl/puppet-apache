define apache::module ($ensure=present) {
	include apache::params

	$a2enmod_deps = $operatingsystem ? {
		/(?i)(Debian|Ubuntu)/ => Package["apache"],
		/(?i)(RedHat|CentOS)/ => [ Package["apache"], File["/etc/httpd/mods-available"], File["/etc/httpd/mods-enabled"], File["/usr/local/sbin/a2enmod"], File["/usr/local/sbin/a2dismod"] ]		
	}

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
				require => $a2enmod_deps,
				notify  => Service["apache"]
			}
		}
		absent: {
			exec { "a2dismod ${name}":
				command => $operatingsystem ? {
					/(?i)(Debian|Ubuntu)/ => "/usr/sbin/a2dismod ${name}",
					/(?i)(RedHat|CentOS)/ => "/usr/local/sbin/a2dismod ${name}"
				},
				onlyif  => "/bin/sh -c '[ -L ${apache::params::confdir}/mods-enabled/${name}.load ] || [ -e ${apache::params::confdir}/mods-enabled/${name}.load ]'",
				require => $a2enmod_deps,
				notify  => Service["apache"]
			}
		}
		default: { 
			err ("Unknown ensure value: '${ensure}'") 
		}
	}
}
