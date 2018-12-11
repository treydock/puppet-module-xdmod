# Private class
class xdmod::supremm::compute::pcp {

  $_procpmda_log_path = '/var/log/pcp/pmie/procpmda.log'
  $_pcp_restart_path  = '/etc/pcp/pmie/pcp-restart.sh'

  if $xdmod::pcp_pmlogger_config_source {
    $_pcp_pmlogger_config_source  = $xdmod::pcp_pmlogger_config_source
    $_pcp_pmlogger_config_content = undef
  } else {
    $_pcp_pmlogger_config_source  = undef
    $_pcp_pmlogger_config_content = template($xdmod::pcp_pmlogger_config_template)
  }

  case $xdmod::pcp_declare_method {
    'include': {
      include ::pcp
    }
    'resource': {
      class { '::pcp':
        include_default_pmlogger => false,
        pmlogger_daily_args      => '-M -k forever',
      }
    }
    default: {
      # Do nothing
    }
  }

  $resource = $xdmod::supremm_resources.filter |$r| {
    $r['resource'] == $xdmod::pcp_resource
  }
  if $resource[0] {
    if $xdmod::pcp_pmlogger_path_suffix {
      $log_dir = "${resource[0]['pcp_log_dir']}/LOCALHOSTNAME/${xdmod::pcp_pmlogger_path_suffix}"
    } else {
      $log_dir = "${resource[0]['pcp_log_dir']}/LOCALHOSTNAME"
    }
  } else {
    fail('xdmod::supremm::compute::pcp unable to determine resource')
  }

  file { '/etc/pcp/pmlogger/control.d/timeouts':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => join([
      '# File managed by Puppet',
      '$PMCD_CONNECT_TIMEOUT=150; export PMCD_CONNECT_TIMEOUT',
      '$PMCD_REQUEST_TIMEOUT=120; export PMCD_REQUEST_TIMEOUT',
    ], "\n"),
    require => Class['::pcp::config'],
    notify  => Service['pmlogger'],
  }

  pcp::pmlogger { 'supremm':
    ensure         => 'present',
    hostname       => 'LOCALHOSTNAME',
    primary        => true,
    socks          => false,
    log_dir        => $log_dir,
    args           => '-r',
    config_path    => '/etc/pcp/pmlogger/pmlogger-supremm.config',
    config_content => $_pcp_pmlogger_config_content,
    config_source  => $_pcp_pmlogger_config_source,
  }

  $_all_metrics = union($xdmod::pcp_static_metrics, $xdmod::pcp_standard_metrics)

  pcp::pmda { 'nfsclient':
    ensure => xdmod::member_substring($_all_metrics, '^nfsclient'),
  }

  pcp::pmda { 'infiniband':
    ensure => xdmod::member_substring($_all_metrics, '^infiniband'),
  }

  pcp::pmda { 'perfevent':
    ensure => xdmod::member_substring($_all_metrics, '^perfevent'),
  }

  pcp::pmda { 'slurm':
    ensure => xdmod::member_substring($_all_metrics, '^slurm'),
  }

  pcp::pmda { 'mic':
    ensure => xdmod::member_substring($_all_metrics, '^mic'),
  }

  pcp::pmda { 'nvidia':
    ensure       => xdmod::member_substring($_all_metrics, '^nvidia'),
    package_name => 'pcp-pmda-nvidia-gpu',
  }

  pcp::pmda { 'gpfs':
    ensure => xdmod::member_substring($_all_metrics, '^gpfs')
  }

  pcp::pmda { 'proc':
    has_package    => false,
    config_path    => '/var/lib/pcp/pmdas/proc/hotproc.conf',
    config_content => template('xdmod/supremm/compute/pcp/hotproc.conf.erb'),
    args           => '-A',
  }

  if $xdmod::pcp_install_pmie_config {
    pcp::pmda { 'logger':
      ensure         => 'absent',
      config_content => "procrestart n ${_procpmda_log_path}\n",
    }

    pcp::pmie { 'supremm':
      ensure      => 'absent',
      config_path => '/etc/pcp/pmie/pmie-supremm.config',
    }

    sudo::conf { 'pcp':
      ensure   => 'absent',
      priority => '10',
      content  => "pcp ALL=(root) NOPASSWD: ${_pcp_restart_path}",
    }

    file { '/etc/pcp/pmie/pcp-restart.sh':
      ensure => 'absent',
      path   => $_pcp_restart_path,
    }

    file { '/etc/pcp/pmie/procpmda_check.sh':
      ensure => 'absent',
    }
  }

}
