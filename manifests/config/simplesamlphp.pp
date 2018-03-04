#
class xdmod::config::simplesamlphp {

  $dirs = [
    '/etc/xdmod/simplesamlphp',
    '/etc/xdmod/simplesamlphp/config',
    '/etc/xdmod/simplesamlphp/metadata',
    '/etc/xdmod/simplesamlphp/cert',
  ]

  if $xdmod::organization_name {
    $simplesamlphp_cert_organization = pick($xdmod::simplesamlphp_cert_organization, $xdmod::organization_name)
  } else {
    $simplesamlphp_cert_organization = $::domain
  }

  $simplesamlphp_cert_commonname = pick($xdmod::simplesamlphp_cert_commonname, $xdmod::apache_vhost_name)

  if $xdmod::manage_simplesamlphp {
    file { $dirs:
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { '/etc/xdmod/simplesamlphp/config/config.php':
      ensure    => 'file',
      owner     => 'xdmod',
      group     => 'apache',
      mode      => '0640',
      content   => $xdmod::simplesamlphp_config_content,
      source    => $xdmod::simplesamlphp_config_source,
      show_diff => false,
    }

    file { '/etc/xdmod/simplesamlphp/config/authsources.php':
      ensure    => 'file',
      owner     => 'xdmod',
      group     => 'apache',
      mode      => '0640',
      content   => $xdmod::simplesamlphp_authsources_content,
      source    => $xdmod::simplesamlphp_authsources_source,
      show_diff => false,
    }

    file { '/etc/xdmod/simplesamlphp/metadata/saml20-idp-remote.php':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => $xdmod::simplesamlphp_metadata_content,
      source  => $xdmod::simplesamlphp_metadata_source,
    }

    openssl::certificate::x509 { 'xdmod':
      country      => $xdmod::simplesamlphp_cert_country,
      organization => $simplesamlphp_cert_organization,
      commonname   => $simplesamlphp_cert_commonname,
      base_dir     => '/etc/xdmod/simplesamlphp/cert',
      require      => File['/etc/xdmod/simplesamlphp/cert'],
    }
  }

}
