define apache::vhost ($ensure           = present,
											$config_file      = '',
											$managed          = true,
											$config_content   = false,
											$htdocs           = false,
											$conf             = false,
											$readme           = false,
											$docroot          = false,
											$cgibin           = true,
											$user             = '',
											$admin            = '',
											$group            = 'root',
											$mode             = '2570',
											$aliases          = [],
											$enable_default   = true,
											$ports            = ['*:80'],
											$accesslog_format = 'combined') {
	include apache::params

	$wwwuser = $user ? {
		''      => $apache::params::user,
		default => $user,
	}

	# used in ERB templates
	$wwwroot = $apache::params::rootdir

	$documentroot = $docroot ? {
		false   => "${wwwroot}/${name}/htdocs",
		default => $docroot,
	}

	$cgipath = $cgibin ? {
		true    => "${wwwroot}/${name}/cgi-bin/",
		false   => false,
		default => $cgibin,
	}

	# check if default virtual host is enabled
	if $enable_default == true {
		exec { "enable default virtual host from ${name}":
			command => 'a2ensite default',
			unless  => "test -L ${apache::params::confdir}/sites-enabled/000-default",
			notify  => Exec['apache-graceful'],
			require => Package[$apache::params::pkgname],
		}
	} else {
		exec { "disable default virtual host from ${name}":
			command => 'a2dissite default',
			onlyif  => "test -L ${apache::params::confdir}/sites-enabled/000-default",
			notify  => Exec['apache-graceful'],
			require => Package[$apache::params::pkgname],
		}
	}

	case $ensure {
		present: {
			file { "${apache::params::confdir}/sites-available/${name}":
				ensure  => present,
				owner   => 'root',
				group   => 'root',
				mode    => '0644',
				seltype => $apache::params::seltype,
				notify  => Exec['apache-graceful'],
				require => Package[$apache::params::pkgname],
			}
			
			if ( $managed ) {
				file { "${apache::params::rootdir}/${name}":
					ensure  => directory,
					owner   => $wwwuser,
					group   => $group,
					mode    => '0755',
					seltype => $operatingsystem ? {
						/(?i)(RedHat|CentOS)/ => 'httpd_sys_content_t',
						default               => undef,
					},
					require => File[$apache::params::rootdir],
				}

				file { "${apache::params::rootdir}/${name}/conf":
					ensure  => directory,
					owner   => $admin ? {
						''      => $wwwuser,
						default => $admin,
					},
					group   => $group,
					mode    => $mode,
					seltype => $apache::params::seltype,
					require => File["${apache::params::rootdir}/${name}"],
				}

				file { "${apache::params::rootdir}/${name}/htdocs":
					ensure  => directory,
					owner   => $wwwuser,
					group   => $group,
					mode    => $mode,
					seltype => $operatingsystem ? {
						/(?i)(RedHat|CentOS)/ => 'httpd_sys_content_t',
						default               => undef,
					},
					require => File["${apache::params::rootdir}/${name}"],
				}
 
				if $htdocs {
					File["${apache::params::rootdir}/${name}/htdocs"] {
						source  => $htdocs,
						recurse => true,
					}
				}

				if $conf {
					File["${apache::params::rootdir}/${name}/conf"] {
						source  => $conf,
						recurse => true,
					}
				}

				# cgi-bin
				file { "${name} cgi-bin directory":
					ensure  => $cgipath ? {
						"${apache::params::rootdir}/${name}/cgi-bin/" => directory,
						default                                       => undef, # don't manage this directory unless under $root/$name
					},
					path    => $cgipath ? {
						false   => "${apache::params::rootdir}/${name}/cgi-bin/",
						default => $cgipath,
					},
					owner   => $wwwuser,
					group   => $group,
					mode    => $mode,
					seltype => $operatingsystem ? {
						/(?i)(RedHat|CentOS)/ => 'httpd_sys_script_exec_t',
						default               => undef,
					},
					require => File["${apache::params::rootdir}/${name}"],
				}

				# Log files
				file { "${apache::params::rootdir}/${name}/logs":
					ensure  => directory,
					owner   => 'root',
					group   => 'root',
					mode    => '0755',
					seltype => $operatingsystem ? {
						/(?i)(RedHat|CentOS)/ => 'httpd_log_t',
						default               => undef,
					},
					require => File["${apache::params::rootdir}/${name}"],
				}

				# We have to give log files to right people with correct rights on them.
				# Those rights have to match those set by logrotate
				file { [ "${apache::params::rootdir}/${name}/logs/access.log", "${apache::params::rootdir}/${name}/logs/error.log" ] :
					ensure  => present,
					owner   => 'root',
					group   => 'adm',
					mode    => '0644',
					seltype => $operatingsystem ? {
						/(?i)(RedHat|CentOS)/ => 'httpd_log_t',
						default               => undef,
					},
					require => File["${apache::params::rootdir}/${name}/logs"],
				}

				# Private data
				file { "${apache::params::rootdir}/${name}/private":
					ensure  => directory,
					owner   => $wwwuser,
					group   => $group,
					mode    => $mode,
					seltype => $operatingsystem ? {
						/(?i)(RedHat|CentOS)/ => 'httpd_sys_content_t',
						default               => undef,
					},
					require => File["${apache::params::rootdir}/${name}"],
				}

				# README file
				file { "${apache::params::rootdir}/${name}/README":
					ensure  => present,
					owner   => 'root',
					group   => 'root',
					mode    => '0644',
					content => $readme ? {
						false   => template('apache/README_vhost.erb'),
						default => $readme,
					},
					require => File["${apache::params::rootdir}/${name}"],
				}
			}	

			case $config_file {
				'': {
					if $config_content {
						File["${apache::params::confdir}/sites-available/${name}"] {
							content => $config_content,
						}
					} else {
						# default vhost template
						File["${apache::params::confdir}/sites-available/${name}"] {
							content => template('apache/vhost.erb'),
						}
					}
				}
				default: {
					File["${apache::params::confdir}/sites-available/${name}"] {
						source => $config_file,
					}
				}
			}

			exec { "enable vhost ${name}":
				command => $operatingsystem ? {
					/(?i)(RedHat|CentOS)/ => "/usr/local/sbin/a2ensite ${name}",
					default               => "/usr/sbin/a2ensite ${name}",
				},
				notify  => Exec['apache-graceful'],
				require => [ $operatingsystem ? {
					/(?i)(RedHat|CentOS)/ => File['/usr/local/sbin/a2ensite'],
					default               => Package[$apache::params::pkgname],
					},
					$managed ? {
						false   => File["${apache::params::confdir}/sites-available/${name}"],
						default => [ File["${apache::params::confdir}/sites-available/${name}"],
												 File["${apache::params::rootdir}/${name}/htdocs"],
												 File["${apache::params::rootdir}/${name}/logs"],
	          					   File["${apache::params::rootdir}/${name}/conf"] ]
					},
				],
				unless  => "/bin/sh -c '[ -L ${apache::params::confdir}/sites-enabled/${name} ] && [ ${apache::params::confdir}/sites-enabled/${name} -ef ${apache::params::confdir}/sites-available/${name} ]'",
			}
		}
		absent:{
			file { "${apache::params::confdir}/sites-enabled/${name}":
				ensure  => absent,
				require => Exec["disable vhost ${name}"],
			}

			file { "${apache::params::confdir}/sites-available/${name}":
				ensure  => absent,
				require => Exec["disable vhost ${name}"],
			}

			exec { "remove ${apache::params::rootdir}/${name}":
				command => "rm -rf ${apache::params::rootdir}/${name}",
				onlyif  => "test -d ${apache::params::rootdir}/${name}",
				require => Exec["disable vhost ${name}"]
			}

			exec { "disable vhost ${name}":
				command => $operatingsystem ? {
					/(?i)(RedHat|CentOS)/ => "/usr/local/sbin/a2dissite ${name}",
					default               => "/usr/sbin/a2dissite ${name}",
				},
				notify  => Exec['apache-graceful'],
				require => $operatingsystem ? {
					/(?i)(RedHat|CentOS)/  => File['/usr/local/sbin/a2ensite'],
					default                => Package[$apache::params::pkgname],
				},
				onlyif => "/bin/sh -c '[ -L ${apache::params::confdir}/sites-enabled/${name} ] && [ ${apache::params::confdir}/sites-enabled/${name} -ef ${apache::params::confdir}/sites-available/${name} ]'",
			}
		}
		disabled: {
			exec { "disable vhost ${name}":
				command => "a2dissite ${name}",
				notify  => Exec['apache-graceful'],
				require => Package[$apache::params::pkgname],
				onlyif  => "/bin/sh -c '[ -L ${apache::params::confdir}/sites-enabled/${name} ] && [ ${apache::params::confdir}/sites-enabled/${name} -ef ${apache::params::confdir}/sites-available/${name} ]'",
			}

			file { "${apache::params::conf}/sites-enabled/${name}":
				ensure  => absent,
				require => Exec["disable vhost ${name}"],
			}
		}
		default: { err ( "Unknown ensure value: '${ensure}'" ) }
	}
}
