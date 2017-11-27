# Private class
class xdmod::supremm::install {

  if $xdmod::local_repo_name {
    package { 'supremm':
      ensure  => $xdmod::package_ensure,
      name    => $xdmod::supremm_package_name,
      require => $xdmod::_package_require,
    }
  } else {
    yum::install { $xdmod::supremm_package_name:
      ensure  => 'present',
      source  => $xdmod::_supremm_package_url,
      require => $xdmod::_package_require,
    }
  }

}