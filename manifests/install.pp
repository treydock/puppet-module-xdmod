# Private class
class xdmod::install {

  case $::osfamily {
    'RedHat': {
      include ::epel
    }
    default: {
      # Do nothing
    }
  }

  if $xdmod::create_local_repo {
    $_package_require = [Yumrepo[$xdmod::local_repo_name], Yumrepo['epel']]

    if ! defined(Package['createrepo']) {
      package { 'createrepo': ensure => 'present' }
    }

    file { '/opt/xdmod-repo': ensure => 'directory' }

    staging::file { "xdmod-${xdmod::version}-1.0.el6.noarch.rpm":
      source  => $xdmod::_package_url,
      target  => "/opt/xdmod-repo/xdmod-${xdmod::version}-1.0.el6.noarch.rpm",
      notify  => [Exec['createrepo-xdmod-repo'], Exec['refresh-xdmod-repo']],
      require => File['/opt/xdmod-repo'],
    }

    if $xdmod::enable_appkernel {
      $_refresh_repo_before = [Package['xdmod'], Package['xdmod-appkernels']]

      staging::file { "xdmod-appkernels-${xdmod::version}-1.0.el6.noarch.rpm":
        source  => $xdmod::_appkernels_package_url,
        target  => "/opt/xdmod-repo/xdmod-appkernels-${xdmod::version}-1.0.el6.noarch.rpm",
        notify  => [Exec['createrepo-xdmod-repo'], Exec['refresh-xdmod-repo']],
        require => File['/opt/xdmod-repo'],
      }
    } else {
      $_refresh_repo_before = Package['xdmod']
    }

    exec { 'createrepo-xdmod-repo':
      command     => '/usr/bin/createrepo /opt/xdmod-repo',
      refreshonly => true,
      before      => Yumrepo[$xdmod::local_repo_name],
      require     => Package['createrepo'],
    }

    exec { 'refresh-xdmod-repo':
      command     => "/usr/bin/yum clean metadata --disablerepo=* --enablerepo=${xdmod::local_repo_name}",
      refreshonly => true,
      before      => $_refresh_repo_before,
      require     => Yumrepo[$xdmod::local_repo_name],
    }

    yumrepo { $xdmod::local_repo_name:
      descr    => $xdmod::local_repo_name,
      baseurl  => 'file:///opt/xdmod-repo',
      gpgcheck => '0',
      enabled  => '1',
    }
  }  else  {
    if defined(Yumrepo[$xdmod::local_repo_name]) {
      $_package_require = [Yumrepo[$xdmod::local_repo_name], Yumrepo['epel']]
    } else {
      $_package_require = Yumrepo['epel']
    }
  }

  package { 'xdmod':
    ensure  => $xdmod::package_ensure,
    name    => $xdmod::package_name,
    require => $_package_require,
  }

  if $xdmod::enable_appkernel {
    package { 'xdmod-appkernels':
      ensure  => $xdmod::package_ensure,
      name    => $xdmod::appkernels_package_name,
      require => $_package_require,
    }
  }

}
