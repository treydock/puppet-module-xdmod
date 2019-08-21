# @summary Manage XDMoD packages
# @api private
class xdmod::install {

  if $xdmod::local_repo_name {
    package { 'xdmod':
      ensure  => $xdmod::package_ensure,
      name    => $xdmod::package_name,
      require => $xdmod::_package_require,
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
      }
    }
  } else {
    yum::install { $xdmod::package_name:
      ensure  => 'present',
      source  => $xdmod::_package_url,
      require => $xdmod::_package_require,
    }
    if $xdmod::enable_appkernel {
      yum::install { $xdmod::appkernels_package_name:
        ensure  => 'present',
        source  => $xdmod::_appkernels_package_url,
        require => $xdmod::_package_require,
      }
    }
    if $xdmod::enable_supremm {
      yum::install { $xdmod::xdmod_supremm_package_name:
        ensure  => 'present',
        source  => $xdmod::_xdmod_supremm_package_url,
        require => $xdmod::_package_require,
      }
    }
  }
}
