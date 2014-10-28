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
  $manage_apache_vhost  = true,
  $apache_vhost_name    = $xdmod::params::apache_vhost_name,
  $apache_port          = '8080',
  $portal_settings      = $xdmod::params::portal_settings,
  $hierarchies          = $xdmod::params::hierarchies,
  $group_to_hierarchy   = $xdmod::params::group_to_hierarchy,
) inherits xdmod::params {

  validate_bool($database, $web, $manage_apache_vhost)

  validate_re($scheduler, ['^slurm$'])

  validate_hash($portal_settings, $group_to_hierarchy)

  validate_array($hierarchies)

  $web_host_real = pick($web_host, $database_host)
  $scheduler_shredder_command = $xdmod::params::shredder_commands[$scheduler]
  $shredder_command_real = pick($shredder_command, $scheduler_shredder_command)

  anchor { 'xdmod::start': }
  anchor { 'xdmod::end': }

  if $database and $web {
    include xdmod::install
    include xdmod::database
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']->
    Class['xdmod::install']->
    Class['xdmod::database']->
    Class['xdmod::config']->
    Class['xdmod::apache']->
    Anchor['xdmod::end']
  } elsif $database {
    include xdmod::database

    Anchor['xdmod::start']->
    Class['xdmod::database']->
    Anchor['xdmod::end']
  } elsif $web {
    include xdmod::install
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']->
    Class['xdmod::install']->
    Class['xdmod::config']->
    Class['xdmod::apache']->
    Anchor['xdmod::end']
  }

}
