# @summary Manage XDMoD packages
# @api private
class xdmod::install {
  if versioncmp($facts['os']['release']['major'], '8') == 0 {
    package { 'nodejs-module':
      ensure      => '16',
      name        => 'nodejs',
      enable_only => true,
      provider    => 'dnfmodule',
    }

    if $xdmod::local_repo_name {
      Package['nodejs-module'] -> Package['xdmod']
    } else {
      Package['nodejs-module'] -> Yum::Install[$xdmod::package_name]
    }

    $mongodb_dependencies = [
      'openssl-devel',
    ]
    $mongodb_dependencies.each |$p| {
      package { $p:
        ensure => 'installed',
        before => Php::Extension['mongodb'],
      }
    }
    php::extension { 'mongodb':
      # 1.17+ requires newer PHP than what's default for RHEL8
      ensure     => $xdmod::php_mongodb_version,
      provider   => 'pecl',
      ini_prefix => '40-',
      require    => Package['php-devel'],
    }
    if $xdmod::manage_apache_vhost {
      Php::Extension['mongodb'] ~> Service['httpd']
    }
  }

  if $xdmod::local_repo_name {
    package { 'xdmod':
      ensure  => $xdmod::package_ensure,
      name    => $xdmod::package_name,
      require => $xdmod::_package_require,
      notify  => Exec['etl-bootstrap'],
    }

    if $xdmod::enable_appkernel {
      package { 'xdmod-appkernels':
        ensure  => $xdmod::xdmod_appkernels_package_ensure,
        name    => $xdmod::appkernels_package_name,
        require => $xdmod::_package_require,
      }
    }

    if $xdmod::enable_supremm {
      package { 'xdmod-supremm':
        ensure  => $xdmod::xdmod_supremm_package_ensure,
        name    => $xdmod::xdmod_supremm_package_name,
        require => $xdmod::_package_require,
        notify  => Exec['etl-bootstrap-supremm'],
      }
    }
  } else {
    yum::install { $xdmod::package_name:
      ensure  => 'present',
      source  => $xdmod::_package_url,
      timeout => 0,
      require => $xdmod::_package_require,
      notify  => Exec['etl-bootstrap'],
    }
    if $xdmod::enable_appkernel {
      yum::install { $xdmod::appkernels_package_name:
        ensure  => 'present',
        source  => $xdmod::_appkernels_package_url,
        timeout => 0,
        require => $xdmod::_package_require,
      }
    }
    if $xdmod::enable_supremm {
      yum::install { $xdmod::xdmod_supremm_package_name:
        ensure  => 'present',
        source  => $xdmod::_xdmod_supremm_package_url,
        timeout => 0,
        require => $xdmod::_package_require,
        notify  => Exec['etl-bootstrap-supremm'],
      }
    }
  }
}
