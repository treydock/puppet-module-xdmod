# @summary Manage XDMoD
#
#
# @param version
# @param xdmod_appkernels_version
# @param xdmod_supremm_version
# @param database
# @param web
# @param akrr
# @param supremm
# @param supremm_database
# @param compute
# @param enable_appkernel
# @param enable_supremm
# @param local_repo_name
# @param manage_epel
# @param package_ensure
# @param xdmod_supremm_package_ensure
# @param xdmod_appkernels_package_ensure
# @param package_name
# @param package_url
# @param appkernels_package_name
# @param appkernels_package_url
# @param xdmod_supremm_package_name
# @param xdmod_supremm_package_url
# @param database_host
# @param database_port
# @param database_user
# @param database_password
# @param akrr_database_user
# @param akrr_database_password
# @param web_host
# @param akrr_host
# @param scheduler
# @param shredder_command
# @param shred_hour_start
# @param shred_minutes
# @param ingest_hour
# @param enable_update_check
# @param manage_apache_vhost
# @param apache_vhost_name
# @param apache_ssl_cert
# @param apache_ssl_key
# @param apache_ssl_chain
# @param portal_settings
# @param hierarchy_levels
# @param hierarchies
# @param group_to_hierarchy
# @param user_pi_names
# @param organization_name
# @param organization_abbrev
# @param resources
# @param resource_specs
# @param sender_email
# @param debug_recipient
# @param php_timezone
# @param center_logo_source
# @param center_logo_width
# @param manage_user
# @param user_uid
# @param group_gid
# @param manage_simplesamlphp
# @param simplesamlphp_config_content
# @param simplesamlphp_config_source
# @param simplesamlphp_authsources_content
# @param simplesamlphp_authsources_source
# @param simplesamlphp_metadata_content
# @param simplesamlphp_metadata_source
# @param simplesamlphp_cert_country
# @param simplesamlphp_cert_organization
# @param simplesamlphp_cert_commonname
# @param akrr_source_url
# @param akrr_version
# @param akrr_home
# @param manage_akrr_user
# @param akrr_user
# @param akrr_user_group
# @param akrr_user_group_gid
# @param akrr_user_uid
# @param akrr_user_shell
# @param akrr_user_home
# @param akrr_user_managehome
# @param akrr_user_comment
# @param akrr_user_system
# @param akrr_restapi_port
# @param akrr_restapi_rw_password
# @param akrr_restapi_ro_password
# @param akrr_cron_mailto
# @param akrr_ingestor_cron_times
# @param appkernel_reports_manager_cron_times
# @param supremm_version
# @param supremm_package_ensure
# @param supremm_package_url
# @param supremm_package_name
# @param supremm_mongodb_password
# @param supremm_mongodb_host
# @param supremm_mongodb_uri
# @param supremm_mongodb_replica_set
# @param supremm_resources
# @param supremm_update_cron_times
# @param ingest_jobscripts_cron_times
# @param aggregate_supremm_cron_times
# @param supremm_archive_out_dir
# @param use_pcp
# @param pcp_declare_method
# @param pcp_resource
# @param pcp_pmlogger_path_suffix
# @param pcp_pmlogger_config_template
# @param pcp_pmlogger_config_source
# @param pcp_logging_static_freq
# @param pcp_logging_standard_freq
# @param pcp_static_metrics
# @param pcp_standard_metrics
# @param pcp_environ_metrics
# @param pcp_merge_metrics
# @param pcp_install_pmie_config
# @param pcp_hotproc_exclude_users
# @param storage_roles_source
# @param storage_cron_times
#
class xdmod (
  String $version                  = $xdmod::params::version,
  String $xdmod_appkernels_version = $xdmod::params::xdmod_appkernels_version,
  String $xdmod_supremm_version    = $xdmod::params::xdmod_supremm_version,

  # Roles
  Boolean $database                 = true,
  Boolean $web                      = true,
  Boolean $akrr                     = false,
  Boolean $supremm                  = false,
  Boolean $supremm_database         = false,
  Boolean $compute                  = false,

  Boolean $enable_appkernel                     = false,
  Boolean $enable_supremm                       = false,
  Optional[String] $local_repo_name             = undef,
  Boolean $manage_epel                          = true,
  String $package_ensure                        = 'present',
  String $xdmod_supremm_package_ensure          = 'present',
  String $xdmod_appkernels_package_ensure       = 'present',
  String $package_name                          = $xdmod::params::package_name,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $package_url                                = $xdmod::params::package_url,
  String $appkernels_package_name               = $xdmod::params::appkernels_package_name,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $appkernels_package_url                     = $xdmod::params::appkernels_package_url,
  String $xdmod_supremm_package_name            = $xdmod::params::xdmod_supremm_package_name,
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $xdmod_supremm_package_url                  = $xdmod::params::xdmod_supremm_package_url,
  String $database_host                   = 'localhost',
  Integer $database_port                   = 3306,
  String $database_user                         = 'xdmod',
  String $database_password                     = 'changeme',
  String $akrr_database_user                    = 'akrr',
  String $akrr_database_password                = 'changeme',
  String $web_host                        = 'localhost',
  String $akrr_host                       = 'localhost',
  Enum['slurm','torque','pbs','sge'] $scheduler = 'slurm',
  Optional[Variant[String, Array]]
    $shredder_command                           = undef,
  Integer[0,23] $shred_hour_start               = 1,
  Integer $shred_minutes                        = 5,
  Optional[Integer[0,23]] $ingest_hour          = undef,
  Boolean $enable_update_check                  = true,
  Boolean $manage_apache_vhost                  = true,
  String $apache_vhost_name               = $xdmod::params::apache_vhost_name,
  Stdlib::Unixpath $apache_ssl_cert             = '/etc/pki/tls/certs/localhost.crt',
  Stdlib::Unixpath $apache_ssl_key              = '/etc/pki/tls/private/localhost.key',
  Optional[Stdlib::Unixpath] $apache_ssl_chain  = undef,
  Hash $portal_settings                         = $xdmod::params::portal_settings,
  Xdmod::Hierarchy_Levels $hierarchy_levels     = $xdmod::params::hierarchy_levels,
  Array $hierarchies                            = $xdmod::params::hierarchies,
  Hash $group_to_hierarchy                      = $xdmod::params::group_to_hierarchy,
  Array $user_pi_names                          = $xdmod::params::user_pi_names,
  Optional[String] $organization_name           = undef,
  Optional[String] $organization_abbrev         = undef,
  Array[Xdmod::Resource] $resources             = [],
  Array[Xdmod::Resource_Spec] $resource_specs   = [],
  String $sender_email                          = $xdmod::params::sender_email,
  String $debug_recipient                       = '',
  Optional[String] $php_timezone                = undef,
  Optional[String] $center_logo_source          = undef,
  Optional[Integer] $center_logo_width          = undef,

  # XDMoD user/group
  Boolean $manage_user = true,
  Optional[Integer] $user_uid = undef,
  Optional[Integer] $group_gid = undef,

  # simplesamlphp
  Boolean $manage_simplesamlphp = false,
  Optional[String] $simplesamlphp_config_content = undef,
  Optional[String] $simplesamlphp_config_source = undef,
  Optional[String] $simplesamlphp_authsources_content = undef,
  Optional[String] $simplesamlphp_authsources_source = undef,
  Optional[String] $simplesamlphp_metadata_content = undef,
  Optional[String] $simplesamlphp_metadata_source = undef,
  String $simplesamlphp_cert_country = 'US',
  Optional[String] $simplesamlphp_cert_organization = undef,
  Optional[String] $simplesamlphp_cert_commonname = undef,

  # AKRR Install
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $akrr_source_url                    = $xdmod::params::akrr_source_url,
  String $akrr_version                  = $xdmod::params::akrr_version,
  Optional[Stdlib::Unixpath] $akrr_home = undef,

  # AKRR User
  Boolean $manage_akrr_user                   = true,
  String $akrr_user                           = 'akrr',
  String $akrr_user_group                     = 'akrr',
  Optional[Integer] $akrr_user_group_gid      = undef,
  Optional[Integer] $akrr_user_uid            = undef,
  Stdlib::Unixpath $akrr_user_shell           = '/bin/bash',
  Optional[Stdlib::Unixpath] $akrr_user_home  = undef,
  Boolean $akrr_user_managehome               = true,
  String $akrr_user_comment                   = 'AKRR',
  Boolean $akrr_user_system                   = true,

  # AKRR config
  Integer $akrr_restapi_port     = 8091,
  String $akrr_restapi_rw_password    = $xdmod::params::akrr_restapi_rw_password,
  String $akrr_restapi_ro_password    = $xdmod::params::akrr_restapi_ro_password,
  Optional[String] $akrr_cron_mailto  = undef,
  Array[Integer, 2, 2] $akrr_ingestor_cron_times = [0,5],
  Array[Integer, 2, 2] $appkernel_reports_manager_cron_times = [0,6],

  # SUPReMM install
  String $supremm_version         = $xdmod::params::supremm_version,
  String $supremm_package_ensure  = 'present',
  Variant[Stdlib::HTTPSUrl, Stdlib::HTTPUrl]
    $supremm_package_url          = $xdmod::params::supremm_package_url,
  String $supremm_package_name    = 'supremm',

  # SUPReMM config
  String $supremm_mongodb_password              = 'changeme',
  String $supremm_mongodb_host            = 'localhost',
  Optional[String] $supremm_mongodb_uri         = undef,
  Optional[String] $supremm_mongodb_replica_set = undef,
  Array[Xdmod::Supremm_Resource] $supremm_resources = [],
  Array[Integer, 2, 2] $supremm_update_cron_times = [0,2],
  Array[Integer, 2, 2] $ingest_jobscripts_cron_times = [0,3],
  Array[Integer, 2, 2] $aggregate_supremm_cron_times = [0,4],
  Stdlib::Absolutepath $supremm_archive_out_dir = '/dev/shm/supremm_test',

  # SUPReMM compute
  Boolean $use_pcp                                = true,
  Enum['include', 'resource'] $pcp_declare_method = 'resource',
  Optional[String] $pcp_resource                  = undef,
  Optional[String] $pcp_pmlogger_path_suffix      = undef,
  String $pcp_pmlogger_config_template            = 'xdmod/supremm/compute/pcp/pmlogger-supremm.config.erb',
  Optional[String] $pcp_pmlogger_config_source    = undef,
  String $pcp_logging_static_freq                 = '1 hour',
  String $pcp_logging_standard_freq               = '30 sec',
  Array $pcp_static_metrics                       = $xdmod::params::supremm_pcp_static_metrics,
  Array $pcp_standard_metrics                     = $xdmod::params::supremm_pcp_standard_metrics,
  Array $pcp_environ_metrics                      = $xdmod::params::supremm_pcp_environ_metrics,
  Boolean $pcp_merge_metrics                      = true,
  Array $pcp_hotproc_exclude_users                = $xdmod::params::supremm_pcp_hotproc_exclude_users,

  # Storage
  String $storage_roles_source = 'puppet:///modules/xdmod/roles.d/storage.json',
  Array[Integer, 2, 2] $storage_cron_times = [0,5],
) inherits xdmod::params {

  case $scheduler {
    'slurm': {
      $scheduler_shredder_command = '/usr/bin/xdmod-slurm-helper --quiet -r RESOURCE'
      $pi_column = 'account_name'
    }
    'pbs': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f pbs -d /var/spool/pbs/server_priv/accounting'
      $pi_column = 'account'
    }
    'torque': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f pbs -d /var/spool/torque/server_priv/accounting'
      $pi_column = 'account'
    }
    'sge': {
      $scheduler_shredder_command = '/usr/bin/xdmod-shredder --quiet -r RESOURCE -f sge -i /var/lib/gridengine/default/common/accounting'
      $pi_column = undef
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

  $storage_resources = $resources.filter |$r| { $r['resource_type_id'] == 9 }

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

  if $manage_epel {
    $epel = [Yumrepo['epel']]
    include ::epel
  } else {
    $epel = []
  }

  if $local_repo_name {
    $_package_require = [Yumrepo[$local_repo_name]] + $epel
  } else  {
    $_package_require = $epel
  }

  $_mysql_remote_args = "-h ${database_host} -u ${database_user} -p${database_password}"

  if $xdmod::params::compute_only and ($web or $database or $akrr or $supremm or $supremm_database) {
    fail('This operating system is only supported for compute resources.')
  }

  if $database and $web {
    include ::phantomjs
    contain xdmod::user
    contain xdmod::install
    contain xdmod::database
    contain xdmod::config
    contain xdmod::config::simplesamlphp
    include xdmod::apache

    Class['::phantomjs']
    -> Class['xdmod::user']
    -> Class['xdmod::install']
    -> Class['xdmod::database']
    -> Class['xdmod::config']
    -> Class['xdmod::config::simplesamlphp']
    -> Class['xdmod::apache']
  } elsif $database {
    contain xdmod::database
  } elsif $web {
    include ::phantomjs
    contain xdmod::user
    contain xdmod::install
    contain xdmod::config
    contain xdmod::config::simplesamlphp
    contain xdmod::apache

    Class['::phantomjs']
    -> Class['xdmod::user']
    -> Class['xdmod::install']
    -> Class['xdmod::config']
    -> Class['xdmod::config::simplesamlphp']
    -> Class['xdmod::apache']
  }

  if $akrr {
    include mysql::bindings
    include mysql::bindings::python
    contain xdmod::akrr::user
    contain xdmod::akrr::install
    contain xdmod::akrr::config
    contain xdmod::akrr::service

    Class['mysql::bindings::python']
    -> Class['xdmod::akrr::user']
    -> Class['xdmod::akrr::install']
    -> Class['xdmod::akrr::config']
    -> Class['xdmod::akrr::service']

    if $database {
      Class['xdmod::database']->Class['xdmod::akrr::user']
    }
  }

  if $supremm_database {
    contain xdmod::supremm::database
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
    contain xdmod::supremm::install
    contain xdmod::supremm::config

    case $xdmod::pcp_declare_method {
      'include': {
        include ::pcp
      }
      'resource': {
        class { '::pcp':
          ensure         => 'stopped',
          package_ensure => '3.12.2-1',
        }
      }
      default: {
        # Do nothing
      }
    }

    if $manage_epel {
      Yumrepo['epel']->Package['mongodb_client']
    }

    Class['::pcp']
    -> Class['xdmod::supremm::install']
    -> Class['xdmod::supremm::config']

    if $database {
      Class['xdmod::database']->Class['xdmod::supremm::config']
    }

    if $supremm_database {
      Class['xdmod::supremm::database']->Class['xdmod::supremm::install']
    }
  }

  if $compute {
    if $use_pcp {
      contain xdmod::supremm::compute::pcp
    }
  }

}
