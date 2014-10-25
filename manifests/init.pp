# == Class: xdmod
#
# See README.md for more details.
#
class xdmod (
  $database             = true,
  $web                  = true,
  $package_ensure       = 'present',
  $package_name         = $xdmod::params::package_name,
  $database_host        = 'localhost',
  $database_port        = '3306',
  $database_user        = 'xdmod',
  $database_password    = 'changeme',
  $web_host             = undef,
  $scheduler            = 'slurm',
  $shredder_command     = undef,
) inherits xdmod::params {

  validate_bool($database, $web)

  validate_re($scheduler, ['^slurm$'])

  $web_host_real = pick($web_host, $database_host)
  $scheduler_shredder_command = $xdmod::params::shredder_commands[$scheduler]
  $shredder_command_real = pick($shredder_command, $scheduler_shredder_command)

  anchor { 'xdmod::start': }
  anchor { 'xdmod::end': }

  if $database and $web {
    include xdmod::install
    include xdmod::database
    include xdmod::config

    Anchor['xdmod::start']->
    Class['xdmod::install']->
    Class['xdmod::database']->
    Class['xdmod::config']->
    Anchor['xdmod::end']
  } elsif $database {
    include xdmod::database

    Anchor['xdmod::start']->
    Class['xdmod::database']->
    Anchor['xdmod::end']
  } elsif $web {
    include xdmod::install
    include xdmod::config

    Anchor['xdmod::start']->
    Class['xdmod::install']->
    Class['xdmod::config']->
    Anchor['xdmod::end']
  }

}
