# Private class
class xdmod::repo {

  case $::osfamily {
    'RedHat': {
      include ::epel
    }
    default: {
      # Do nothing
    }
  }

  if $xdmod::create_local_repo {
    if $xdmod::enable_appkernel {
      $_refresh_repo_before_appkernel = Package['xdmod-appkernels']
    } else {
      $_refresh_repo_before_appkernel = undef
    }
    if $xdmod::enable_supremm {
      $_refresh_repo_before_xdmod_supremm = Package['xdmod-supremm']
    } else {
      $_refresh_repo_before_xdmod_supremm = undef
    }
    if $xdmod::supremm {
      $_refresh_repo_before_supremm = Package['supremm']
    } else {
      $_refresh_repo_before_supremm = undef
    }
    if $xdmod::web {
      $_refresh_repo_before = delete_undef_values([
        Package['xdmod'],
        $_refresh_repo_before_appkernel,
        $_refresh_repo_before_xdmod_supremm,
        $_refresh_repo_before_supremm
      ])
    } else {
      $_refresh_repo_before = delete_undef_values([$_refresh_repo_before_supremm])
    }

    if ! defined(Package['createrepo']) {
      package { 'createrepo': ensure => 'present' }
    }

    file { '/opt/xdmod-repo': ensure => 'directory' }

    $__xdmod_package_basename = split($xdmod::_package_url, '[/]')
    $_xdmod_package_basename = $__xdmod_package_basename[-1]
    staging::file { "xdmod-${xdmod::version}":
      source  => $xdmod::_package_url,
      target  => "/opt/xdmod-repo/${_xdmod_package_basename}",
      notify  => [Exec['createrepo-xdmod-repo'], Exec['refresh-xdmod-repo']],
      require => File['/opt/xdmod-repo'],
    }

    $__xdmod_appkernels_package_basename = split($xdmod::_appkernels_package_url, '[/]')
    $_xdmod_appkernels_package_basename = $__xdmod_appkernels_package_basename[-1]
    staging::file { "xdmod-appkernels-${xdmod::version}":
      source  => $xdmod::_appkernels_package_url,
      target  => "/opt/xdmod-repo/${_xdmod_appkernels_package_basename}",
      notify  => [Exec['createrepo-xdmod-repo'], Exec['refresh-xdmod-repo']],
      require => File['/opt/xdmod-repo'],
    }

    $__xdmod_supremm_package_basename = split($xdmod::_xdmod_supremm_package_url, '[/]')
    $_xdmod_supremm_package_basename = $__xdmod_supremm_package_basename[-1]
    staging::file { "xdmod-supremm-${xdmod::version}":
      source  => $xdmod::_xdmod_supremm_package_url,
      target  => "/opt/xdmod-repo/${_xdmod_supremm_package_basename}",
      notify  => [Exec['createrepo-xdmod-repo'], Exec['refresh-xdmod-repo']],
      require => File['/opt/xdmod-repo'],
    }

    $__supremm_package_basename = split($xdmod::_supremm_package_url, '[/]')
    $_supremm_package_basename = $__supremm_package_basename[-1]
    staging::file { "supremm-${xdmod::supremm_version}":
      source  => $xdmod::_supremm_package_url,
      target  => "/opt/xdmod-repo/${_supremm_package_basename}",
      notify  => [Exec['createrepo-xdmod-repo'], Exec['refresh-xdmod-repo']],
      require => File['/opt/xdmod-repo'],
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
  }

}
