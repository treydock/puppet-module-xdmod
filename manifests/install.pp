# Private class
class xdmod::install {

  package { 'xdmod':
    ensure  => $xdmod::package_ensure,
    name    => $xdmod::package_name,
    require => $xdmod::_package_require,
  }

  if $xdmod::enable_appkernel {
    package { 'xdmod-appkernels':
      ensure  => $xdmod::package_ensure,
      name    => $xdmod::appkernels_package_name,
      require => $xdmod::_package_require,
    }
  }

  if $xdmod::enable_supremm {
    package { 'xdmod-supremm':
      ensure  => $xdmod::package_ensure,
      name    => $xdmod::xdmod_supremm_package_name,
      require => $xdmod::_package_require,
    }
  }

}
