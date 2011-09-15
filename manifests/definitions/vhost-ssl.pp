/*

== Definition: apache::vhost-ssl

Creates an SSL enabled virtualhost.

As it calls apache::vhost, most of the parameters are the same. A few
additional parameters are used to configure the SSL specific stuff.

Parameters:
- *$name*: the name of the virtualhost. Will be used as the CN in the generated
  ssl certificate.
- *$ensure*: see apache::vhost
- *$config_file*: see apache::vhost
- *$config_content*: see apache::vhost
- *$htdocs*: see apache::vhost
- *$conf*: see apache::vhost
- *$readme*: see apache::vhost
- *$docroot*: see apache::vhost
- *$cgibin*: see apache::vhost
- *$user*: see apache::vhost
- *$admin*: see apache::vhost
- *$group*: see apache::vhost
- *$mode*: see apache::vhost
- *$aliases*: see apache::vhost. The generated SSL certificate will have this
  list as DNS subjectAltName entries.
- *$enable_default*: see apache::vhost
- *$ip_address*: the ip address defined in the <VirtualHost> directive.
  Defaults to "*".
- *$sslonly*: if set to "true", only the https virtualhost will be configured.
  Defaults to "false", which means the virtualhost will be reachable unencrypted
  on port 80, as well as encrypted on port 443.
- *ports*: array specifying the ports on which the non-SSL vhost will be
  reachable. Defaults to "*:80".
- *sslports*: array specifying the ports on which the SSL vhost will be
  reachable. Defaults to "*:443".
- *accesslog_format*: format string for access logs. Defaults to "combined".
- *$cacert*: optional source URL of the CA certificate, if the defaults bundled
  with your distribution don't suit. This the certificate passed to the
  SSLCACertificateFile directive.
- *$certchain*: optional source URL of the CA certificate chain, if needed.
  This the certificate passed to the SSLCertificateChainFile directive.
- *$cert*: source URL of the certificate (see examples below), if the
  default self-signed generated one doesn't suit. This the certificate passed
  to the SSLCertificateFile directive.
- *$certkey*: optional source URL of the private key, if the default generated
  one doesn't suit. This the private key passed to the SSLCertificateKeyFile
  directive.

Requires:
- Class["apache-ssl"]

Example usage:

  include apache::ssl

  apache::vhost-ssl { "foo.example.com":
    ensure => present,
    ip_address => "10.0.0.2",
    cert => "puppet:///exampleproject/ssl-certs/bar.example.com.crt",
    certkey => "puppet:///exampleproject/ssl-certs/bar.example.com.key",
    certchain => "puppet:///exampleproject/ssl-certs/quovadis.chain.crt",
  }
*/
define apache::vhost-ssl (
  $ensure=present,
  $config_file="",
  $config_content=false,
  $htdocs=false,
  $conf=false,
  $readme=false,
  $docroot=false,
  $cgibin=true,
  $user="",
  $admin=$admin,
  $group="root",
  $mode=2570,
  $aliases=[],
  $ip_address="*",
  $sslonly=false,
  $enable_default=true,
  $ports=['*:80'],
  $sslports=['*:443'],
  $accesslog_format="combined",
  $cacert=false,
  $certchain=false,
  $cert,
  $certkey
) {

  include apache::params

  $wwwuser = $user ? {
    ""      => $apache::params::user,
    default => $user,
  }

  # used in ERB templates
  $wwwroot = $apache::params::root

  $documentroot = $docroot ? {
    false   => "${wwwroot}/${name}/htdocs",
    default => $docroot,
  }

  $cgipath = $cgibin ? {
    true    => "${wwwroot}/${name}/cgi-bin/",
    false   => false,
    default => $cgibin,
  }

  # define variable names used in vhost-ssl.erb template
  $certfile      = "${apache::params::root}/$name/ssl/$name.crt"
  $certkeyfile   = "${apache::params::root}/$name/ssl/$name.key"

  # By default, use CA certificate list shipped with the distribution.
  if $cacert != false {
    $cacertfile = "${apache::params::root}/$name/ssl/cacert.crt"
  } else {
    $cacertfile = $operatingsystem ? {
      /RedHat|CentOS/ => "/etc/pki/tls/certs/ca-bundle.crt",
      Debian => "/etc/ssl/certs/ca-certificates.crt",
    }
  }

  if $certchain != false {
    $certchainfile = "${apache::params::root}/$name/ssl/certchain.crt"
  }


  # call parent definition to actually do the virtualhost setup.
  apache::vhost {$name:
    ensure         => $ensure,
    config_file    => $config_file,
    config_content => $config_content ? {
      false => $sslonly ? {
        true => template("apache/vhost-ssl.erb"),
        default => template("apache/vhost.erb", "apache/vhost-ssl.erb"),
      },
      default      => $config_content,
    },
    aliases        => $aliases,
    htdocs         => $htdocs,
    conf           => $conf,
    readme         => $readme,
    docroot        => $docroot,
    user           => $wwwuser,
    admin          => $admin,
    group          => $group,
    mode           => $mode,
    enable_default => $enable_default,
    ports          => $ports,
    accesslog_format => $accesslog_format,
  }

  if $ensure == "present" {
    file { "${apache::params::root}/${name}/ssl":
      ensure => directory,
      owner  => "root",
      group  => "root",
      mode   => 700,
      seltype => "cert_t",
      require => [File["${apache::params::root}/${name}"]],
    }

    # The virtualhost's certificate.
    file { $certfile:
      owner => "root",
      group => "root",
      mode  => 640,
      source  => $cert,
      seltype => "cert_t",
      notify  => Exec["apache-graceful"],
      require => File["${apache::params::root}/${name}/ssl"],
    }

    # The virtualhost's private key.
    file { $certkeyfile:
      owner => "root",
      group => "root",
      mode  => 600,
      source  => $certkey,
      seltype => "cert_t",
      notify  => Exec["apache-graceful"],
      require => File["${apache::params::root}/${name}/ssl"],
    }

    if $cacert != false {
      # The certificate from your certification authority. Defaults to the
      # certificate bundle shipped with your distribution.
      file { $cacertfile:
        owner   => "root",
        group   => "root",
        mode    => 640,
        source  => $cacert,
        seltype => "cert_t",
        notify  => Exec["apache-graceful"],
        require => File["${apache::params::root}/${name}/ssl"],
      }
    }

    if $certchain != false {
      # The certificate chain file from your certification authority's. They
      # should inform you if you need one.
      file { $certchainfile:
        owner => "root",
        group => "root",
        mode  => 640,
        source  => $certchain,
        seltype => "cert_t",
        notify  => Exec["apache-graceful"],
        require => File["${apache::params::root}/${name}/ssl"],
      }
    }
  }
}
