define apache::auth::basic::ldap ($vhost,
																	$authLDAPUrl, 
																	$ensure                      = present,
																	$authname                    = 'Private Area',
																	$location                    = '/',
																	$authLDAPBindDN              = false,
																	$authLDAPBindPassword        = false,
																	$authLDAPCharsetConfig       = false,
																	$authLDAPCompareDNOnServer   = false,
																	$authLDAPDereferenceAliases  = false,
																	$authLDAPGroupAttribute      = false,
																	$authLDAPGroupAttributeIsDN  = false,
																	$authLDAPRemoteUserAttribute = false,
																	$authLDAPRemoteUserIsDN      = false,
																	$authzLDAPAuthoritative      = false,
																	$authzRequire                = 'valid-user') {
	include apache::params
	include apache::module::authnz_ldap
	include apache::module::ldap
	
	$fname = regsubst($name, '\s', '_', 'G')

	file { "${apache::params::rootdir}/${vhost}/conf/auth-basic-ldap-${fname}.conf":
		ensure  => $ensure,
		content => template('apache/auth/basic/ldap.erb'),
		seltype => $apache::params::seltype,
		notify  => Exec['apache-graceful'],
	}
}
