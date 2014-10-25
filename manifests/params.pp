# == Class: xdmod::params
#
# Private class.
#
class xdmod::params {

  $shredder_commands  = {
    'slurm' => '/usr/bin/xdmod-slurm-helper --quiet',
  }

  case $::osfamily {
    'RedHat': {
      $package_name = 'xdmod'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
