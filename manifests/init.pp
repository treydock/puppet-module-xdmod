# == Class: xdmod
#
# See README.md for more details.
#
class xdmod (
  $version                  = $xdmod::params::version,
  $xdmod_appkernels_version = $xdmod::params::xdmod_appkernels_version,
  $xdmod_supremm_version    = $xdmod::params::xdmod_supremm_version,

  # Roles
  $database                 = true,
  $web                      = true,
  $akrr                     = false,
  $supremm                  = false,
  $supremm_database         = false,
  $compute                  = false,

  $enable_appkernel         = false,
  $enable_supremm           = false,
  $local_repo_name          = undef,
  $package_ensure           = 'present',
  $package_name             = $xdmod::params::package_name,
  $package_url              = $xdmod::params::package_url,
  $appkernels_package_name  = $xdmod::params::appkernels_package_name,
  $appkernels_package_url   = $xdmod::params::appkernels_package_url,
  $xdmod_supremm_package_name = $xdmod::params::xdmod_supremm_package_name,
  $xdmod_supremm_package_url  = $xdmod::params::xdmod_supremm_package_url,
  $database_host            = 'localhost',
  $database_port            = '3306',
  $database_user            = 'xdmod',
  $database_password        = 'changeme',
  $akrr_database_user       = 'akrr',
  $akrr_database_password   = 'changeme',
  $web_host                 = 'localhost',
  $akrr_host                = 'localhost',
  $scheduler                = 'slurm',
  $shredder_command         = undef,
  $enable_update_check      = true,
  $manage_apache_vhost      = true,
  $apache_vhost_name        = $xdmod::params::apache_vhost_name,
  $apache_ssl_cert          = '/etc/pki/tls/certs/localhost.crt',
  $apache_ssl_key           = '/etc/pki/tls/private/localhost.key',
  $apache_ssl_chain         = undef,
  $portal_settings          = $xdmod::params::portal_settings,
  $hierarchy_levels         = $xdmod::params::hierarchy_levels,
  $hierarchies              = $xdmod::params::hierarchies,
  $group_to_hierarchy       = $xdmod::params::group_to_hierarchy,
  $user_pi_names            = $xdmod::params::user_pi_names,
  $organization_name        = undef,
  $organization_abbrev      = undef,
  Array[Struct[{
    resource => String,
    resource_id => Integer,
    name => String,
    pi_column => Optional[String],
    pcp_log_dir => Optional[Stdlib::Absolutepath],
    script_dir => Optional[Stdlib::Absolutepath],
  }]] $resources            = [],
  Array[Struct[{
    resource => String,
    start_date => Optional[String],
    end_date => Optional[String],
    processors => Integer,
    nodes => Integer,
    ppn => Integer,
  }]] $resource_specs       = [],
  String $sender_email      = "xdmod@xdmod.${::domain}",

  # AKRR Install
  $akrr_source_url          = $xdmod::params::akrr_source_url,
  $akrr_version             = $xdmod::params::akrr_version,
  $akrr_home                = undef,

  # AKRR User
  $manage_akrr_user         = true,
  $akrr_user                = 'akrr',
  $akrr_user_group          = 'akrr',
  $akrr_user_group_gid      = undef,
  $akrr_user_uid            = undef,
  $akrr_user_shell          = '/bin/bash',
  $akrr_user_home           = undef,
  $akrr_user_managehome     = true,
  $akrr_user_comment        = 'AKRR',
  $akrr_user_system         = true,

  # AKRR config
  $akrr_restapi_port        = '8091',
  $akrr_restapi_rw_password = $xdmod::params::akrr_restapi_rw_password,
  $akrr_restapi_ro_password = $xdmod::params::akrr_restapi_ro_password,
  $akrr_cron_mailto         = undef,

  # SUPReMM install
  $supremm_version              = $xdmod::params::supremm_version,
  $supremm_package_url          = $xdmod::params::supremm_package_url,
  $supremm_package_name         = 'supremm',

  # SUPReMM config
  $supremm_mongodb_password     = 'changeme',
  $supremm_mongodb_host         = 'localhost',
  $supremm_mongodb_uri          = undef,
  $supremm_mongodb_replica_set  = undef,

  # SUPReMM compute
  $use_pcp                      = true,
  $pcp_declare_method           = 'resource',
  $pcp_resource                 = undef,
  $pcp_pmlogger_config_template = 'xdmod/supremm/compute/pcp/pmlogger-supremm.config.erb',
  $pcp_pmlogger_config_source   = undef,
  $pcp_logging_static_freq      = '1 hour',
  $pcp_logging_standard_freq    = '30 sec',
  $pcp_static_metrics           = $xdmod::params::supremm_pcp_static_metrics,
  $pcp_standard_metrics         = $xdmod::params::supremm_pcp_standard_metrics,
  $pcp_environ_metrics          = $xdmod::params::supremm_pcp_environ_metrics,
  $pcp_install_pmie_config      = true,
  $pcp_pmie_config_template     = 'xdmod/supremm/compute/pcp/pmie-supremm.config.erb',
  $pcp_pmie_config_source       = undef,
  $pcp_hotproc_exclude_users    = $xdmod::params::supremm_pcp_hotproc_exclude_users,
) inherits xdmod::params {

  validate_bool(
    $database,
    $web,
    $akrr,
    $supremm,
    $supremm_database,
    $enable_appkernel,
    $enable_supremm,
    $enable_update_check,
    $manage_apache_vhost,
    $use_pcp,
    $pcp_install_pmie_config
  )

  validate_array(
    $pcp_static_metrics,
    $pcp_standard_metrics,
    $pcp_environ_metrics
  )

  validate_re($scheduler, ['^slurm$', '^torque$'])

  validate_hash($portal_settings, $group_to_hierarchy)

  validate_array($hierarchies, $user_pi_names)

  case $scheduler {
    'slurm': {
      $scheduler_shredder_command = '/usr/bin/xdmod-slurm-helper --quiet -r RESOURCE'
    }
    'pbs': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f pbs -d /var/spool/pbs/server_priv/accounting'
    }
    'torque': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f pbs -d /var/spool/torque/server_priv/accounting'
    }
    'sge': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f sge -i /var/lib/gridengine/default/common/accounting'
    }
    default: {
      fail("Module ${module_name}: Supported scheduler value is either slurm, pbs, torque or sge.")
    }
  }

  if $compute {
    if $use_pcp {
      if ! $pcp_resource {
        fail("Module ${module_name}: pcp_resource must be defined.")
      }
    }
  }

  $shredder_command_default = $resources.map |$r| {
    regsubst($scheduler_shredder_command, 'RESOURCE', $r['resource'], 'G')
  }
  $shredder_command_real = pick($shredder_command, $shredder_command_default)

  $_package_url = regsubst($package_url, 'VERSION', $version, 'G')
  $_appkernels_package_url = regsubst($appkernels_package_url, 'VERSION', $xdmod_appkernels_version, 'G')
  $_xdmod_supremm_package_url = regsubst($xdmod_supremm_package_url, 'VERSION', $xdmod_supremm_version, 'G')

  $_akrr_source_url = regsubst($akrr_source_url, 'AKRR_VERSION', $akrr_version, 'G')

  $_akrr_user_home = pick($akrr_user_home, "/home/${akrr_user}")
  $_akrr_home = pick($akrr_home, "${xdmod::_akrr_user_home}/akrr-${xdmod::akrr_version}")

  $_supremm_package_url = regsubst($supremm_package_url, 'SUPREMM_VERSION', $supremm_version, 'G')
  $_supremm_mongodb_host = $supremm_mongodb_host ? {
    Array   => join($supremm_mongodb_host, ','),
    default => $supremm_mongodb_host,
  }
  if $supremm_mongodb_replica_set {
    $mongodb_uri_replica_set = "?replicaSet=${supremm_mongodb_replica_set}"
    $mongodb_args_replica_set = "${supremm_mongodb_replica_set}/"
  } else {
    $mongodb_uri_replica_set = ''
    $mongodb_args_replica_set = ''
  }
  $_supremm_mongodb_uri = pick($supremm_mongodb_uri, "mongodb://supremm:${supremm_mongodb_password}@${_supremm_mongodb_host}/supremm${mongodb_uri_replica_set}")
  $supremm_mongo_args = "-u supremm -p ${supremm_mongodb_password} --host ${mongodb_args_replica_set}${_supremm_mongodb_host} supremm"

  if $local_repo_name {
    $_package_require = [Yumrepo[$local_repo_name], Yumrepo['epel']]
  } else  {
    $_package_require = Yumrepo['epel']
  }

  $_mysql_remote_args = "-h ${database_host} -u ${database_user} -p${database_password}"

  case $::osfamily {
    'RedHat': {
      include ::epel
    }
    default: {
      # Do nothing
    }
  }

  anchor { 'xdmod::start': }
  anchor { 'xdmod::end': }

  if $database and $web {
    include ::phantomjs
    include xdmod::install
    include xdmod::database
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']
    -> Class['::phantomjs']
    -> Class['xdmod::install']
    -> Class['xdmod::database']
    -> Class['xdmod::config']
    -> Class['xdmod::apache']
    -> Anchor['xdmod::end']
  } elsif $database {
    include xdmod::database

    Anchor['xdmod::start']
    -> Class['xdmod::database']
    -> Anchor['xdmod::end']
  } elsif $web {
    include ::phantomjs
    include xdmod::install
    include xdmod::config
    include xdmod::apache

    Anchor['xdmod::start']
    -> Class['::phantomjs']
    -> Class['xdmod::install']
    -> Class['xdmod::config']
    -> Class['xdmod::apache']
    -> Anchor['xdmod::end']
  }

  if $akrr {
    anchor { 'xdmod::akrr::start': }
    anchor { 'xdmod::akrr::end': }

    include mysql::bindings
    include mysql::bindings::python
    include xdmod::akrr::user
    include xdmod::akrr::install
    include xdmod::akrr::config
    include xdmod::akrr::service

    Anchor['xdmod::akrr::start']
    -> Class['mysql::bindings::python']
    -> Class['xdmod::akrr::user']
    -> Class['xdmod::akrr::install']
    -> Class['xdmod::akrr::config']
    -> Class['xdmod::akrr::service']
    -> Anchor['xdmod::akrr::end']

    if $database {
      Class['xdmod::database']->Anchor['xdmod::akrr::start']
    }
  }

  if $supremm_database {
    include xdmod::supremm::database
  }

  if $supremm {
    if $web {
      $supremm_mysql_access = 'include'
      Class['xdmod::supremm::config']->Class['xdmod::config']
    } else {
      $supremm_mysql_access = 'defaultsfile'
    }

    include mysql::client
    include mongodb::client
    include xdmod::supremm::install
    include xdmod::supremm::config

    case $xdmod::pcp_declare_method {
      'include': {
        include ::pcp
      }
      'resource': {
        class { '::pcp':
          ensure => 'stopped'
        }
      }
      default: {
        # Do nothing
      }
    }

    Yumrepo['epel']->Package['mongodb_client']

    Anchor['xdmod::start']
    -> Class['::pcp']
    -> Class['xdmod::supremm::install']
    -> Class['xdmod::supremm::config']
    -> Anchor['xdmod::end']

    if $database {
      Class['xdmod::database']->Class['xdmod::supremm::config']
    }

    if $supremm_database {
      Class['xdmod::supremm::database']->Class['xdmod::supremm::install']
    }
  }

  if $compute {
    if $use_pcp {
      validate_re($pcp_declare_method, ['^include$', '^resource$'], 'pcp_declare_method only supports include and resource')

      include xdmod::supremm::compute::pcp

      Anchor['xdmod::start']
      -> Class['xdmod::supremm::compute::pcp']
      -> Anchor['xdmod::end']
    }
  }

}
