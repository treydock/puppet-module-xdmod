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
        include_default_pmie     => false,
        pmlogger_daily_args      => '-M -k forever',
      }
    }
    default: {
      # Do nothing
    }
  }

  pcp::pmlogger { 'supremm':
    ensure         => 'present',
    hostname       => 'LOCALHOSTNAME',
    primary        => true,
    socks          => false,
    log_dir        => $xdmod::_pcp_log_dir,
    args           => '-r',
    config_path    => '/etc/pcp/pmlogger/pmlogger-supremm.config',
    config_content => $_pcp_pmlogger_config_content,
    config_source  => $_pcp_pmlogger_config_source,
  }

  $_all_metrics = union($xdmod::pcp_static_metrics, $xdmod::pcp_standard_metrics)

  pcp::pmda { 'nfsclient':
    ensure => member_substring($_all_metrics, '^nfsclient'),
  }

  pcp::pmda { 'infiniband':
    ensure => member_substring($_all_metrics, '^infiniband'),
  }

  pcp::pmda { 'perfevent':
    ensure => member_substring($_all_metrics, '^perfevent'),
  }

  pcp::pmda { 'slurm':
    ensure => member_substring($_all_metrics, '^slurm'),
  }

  pcp::pmda { 'mic':
    ensure => member_substring($_all_metrics, '^mic'),
  }

  pcp::pmda { 'nvidia':
    ensure => member_substring($_all_metrics, '^nvidia'),
  }

  if $xdmod::pcp_install_pmie_config {
    if $xdmod::pcp_pmie_config_source {
      $_pcp_pmie_config_source  = $xdmod::pcp_pmie_config_source
      $_pcp_pmie_config_content = undef
    } else {
      $_pcp_pmie_config_source  = undef
      $_pcp_pmie_config_content = template($xdmod::pcp_pmie_config_template)
    }

    pcp::pmda { 'logger':
      has_package    => true,
      config_content => "procrestart n ${_procpmda_log_path}\n"
    }

    pcp::pmie { 'supremm':
      ensure         => 'present',
      hostname       => 'LOCALHOSTNAME',
      socks          => false,
      log_file       => "PCP_LOG_DIR/pmie/${::hostname}/pmie.log",
      config_path    => '/etc/pcp/pmie/pmie-supremm.config',
      config_content => $_pcp_pmie_config_content,
      config_source  => $_pcp_pmie_config_source,
    }

    sudo::conf { 'pcp':
      priority => '10',
      content  => "pcp ALL=(root) NOPASSWD: ${_pcp_restart_path}",
    }

    file { '/etc/pcp/pmie/pcp-restart.sh':
      ensure  => 'file',
      path    => $_pcp_restart_path,
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('xdmod/supremm/compute/pcp/pcp-restart.sh.erb'),
      require => Package['pcp'],
      before  => Pcp::Pmie['supremm'],
    }

    file { '/etc/pcp/pmie/procpmda_check.sh':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0755',
      content => template('xdmod/supremm/compute/pcp/procpmda_check.sh.erb'),
      require => Package['pcp'],
      before  => Pcp::Pmie['supremm'],
    }
  }

}