# == Class: xdmod::params
#
# Private class.
#
class xdmod::params {

  $shredder_commands  = {
    'slurm' => '/usr/bin/xdmod-slurm-helper --quiet',
  }

  $portal_settings = hiera('xdmod_portal_settings', {})

  case $::osfamily {
    'RedHat': {
      $package_name = 'xdmod'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
