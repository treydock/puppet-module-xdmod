# == Class: xdmod
#
# See README.md for more details.
#
class xdmod (
  $database                 = true,
  $web                      = true,
  $enable_appkernel         = false,
  $resource_name            = $xdmod::params::resource_name,
  $package_ensure           = 'present',
  $package_name             = $xdmod::params::package_name,
  $appkernels_package_name  = $xdmod::params::appkernels_package_name,
  $database_host            = 'localhost',
  $database_port            = '3306',
  $database_user            = 'xdmod',
  $database_password        = 'changeme',
  $web_host                 = undef,
  $scheduler                = 'slurm',
  $shredder_command         = undef,
  $enable_update_check      = true,
  $manage_apache_vhost      = true,
  $apache_vhost_name        = $xdmod::params::apache_vhost_name,
  $apache_port              = '80',
  $apache_ssl               = true,
  $apache_ssl_port          = '443',
  $apache_ssl_cert          = undef,
  $apache_ssl_key           = undef,
  $apache_ssl_chain         = undef,
  $portal_settings          = $xdmod::params::portal_settings,
  $hierarchies              = $xdmod::params::hierarchies,
  $group_to_hierarchy       = $xdmod::params::group_to_hierarchy,
  $user_pi_names            = $xdmod::params::user_pi_names,
) inherits xdmod::params {

  validate_bool($database, $web, $enable_appkernel, $enable_update_check, $apache_ssl, $manage_apache_vhost)

  validate_re($scheduler, ['^slurm$'])

  validate_hash($portal_settings, $group_to_hierarchy)

  validate_array($hierarchies, $user_pi_names)

  $web_host_real = pick($web_host, $database_host)

  case $scheduler {
    'slurm': {
      $scheduler_shredder_command = "/usr/bin/xdmod-slurm-helper --quiet -r ${resource_name}"
    }
    'pbs': {
      $scheduler_shredder_command = "/usr/bin/xdmod-shredder --quiet -r ${resource_name} -f pbs -d /var/spool/pbs/server_priv/accounting"
    }
    'sge': {
      $scheduler_shredder_command = "/usr/bin/xdmod-shredder --quiet -r ${resource_name} -f sge -i /var/lib/gridengine/default/common/accounting"
    }
    default: {
      fail("Module ${module_name}: Supported scheduler value is either slurm, pbs or sge.")
    }
  }

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
