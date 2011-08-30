define apache::vhost-config ($ensure="present", $vhost, $source = "") {

  include apache::params

  file { "${apache::params::root}/${vhost}/conf/${name}.conf":
    ensure => $ensure,
    source => $souce ? {
      "" => "puppet:///files/apache/${vhost}/conf/${name}.conf",
      default => $source,
    },
    seltype => $operatingsystem ? {
      "RedHat" => "httpd_config_t",
      "CentOS" => "httpd_config_t",
      default  => undef,
    },
    notify => Exec["apache-graceful"],
    require => Apache::Vhost[$vhost],
  }
}
