# Private class
class xdmod::akrr::config {

  file { "${xdmod::_akrr_home}/cfg":
    ensure => 'directory',
    owner  => $xdmod::akrr_user,
    group  => $xdmod::akrr_user_group,
    mode   => '0700',
  }

  file { 'akrr.inp.py':
    ensure  => 'present',
    path    => "${xdmod::_akrr_home}/cfg/akrr.inp.py",
    source  => "${xdmod::_akrr_home}/setup/scripts/akrr.src.inp.py",
    replace => false,
    owner   => $xdmod::akrr_user,
    group   => $xdmod::akrr_user_group,
    mode    => '0600',
  }

  Xdmod::Akrr::Setting {
    before => Exec['akrrgenerate_tables.py'],
  }

  xdmod::akrr::setting { 'xd_db_host': value => $xdmod::database_host }
  xdmod::akrr::setting { 'xd_db_user': value => $xdmod::akrr_database_user }
  xdmod::akrr::setting { 'xd_db_passwd': value => $xdmod::akrr_database_password }
  xdmod::akrr::setting { 'akrr_db_user': value => $xdmod::akrr_database_user }
  xdmod::akrr::setting { 'akrr_db_passwd': value => $xdmod::akrr_database_password }
  xdmod::akrr::setting { 'restapi_rw_password': value => $xdmod::akrr_restapi_rw_password }
  xdmod::akrr::setting { 'restapi_ro_password': value => $xdmod::akrr_restapi_ro_password }
  xdmod::akrr::setting { 'default_task_params': value => '{\'test_run\': False}', quote => false }

  $_akrr_x509_key  = "${xdmod::_akrr_home}/cfg/server.key"
  $_akrr_x509_cert = "${xdmod::_akrr_home}/cfg/server.cert"
  $_akrr_cert_command = [
    'openssl req -new -newkey rsa:4096',
    '-days 365 -nodes -x509',
    "-subj '/CN=${::fqdn}'",
    "-keyout ${_akrr_x509_key}",
    "-out ${_akrr_x509_cert}",
  ]

  exec { 'akrr-cert':
    cwd     => $xdmod::_akrr_home,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => $xdmod::akrr_user,
    command => join($_akrr_cert_command, ' '),
    creates => [$_akrr_x509_key, $_akrr_x509_cert],
    before  => Concat['akrr-server-cert'],
    require => File["${xdmod::_akrr_home}/cfg"],
  }

  concat { 'akrr-server-cert':
    ensure => 'present',
    path   => "${xdmod::_akrr_home}/cfg/server.pem",
    owner  => $xdmod::akrr_user,
    group  => $xdmod::akrr_user_group,
    before => Exec['akrrgenerate_tables.py'],
  }

  concat::fragment { 'akrr-server.key':
    target => 'akrr-server-cert',
    source => $_akrr_x509_key,
    order  => '01',
  }

  concat::fragment { 'akrr-server.cert':
    target => 'akrr-server-cert',
    source => $_akrr_x509_cert,
    order  => '02',
  }

  if $xdmod::akrr_cron_mailto {
    $_akrr_cron_environment = "MAILTO=${xdmod::akrr_cron_mailto}"
  } else {
    $_akrr_cron_environment = undef
  }

  cron { 'akrr-restart':
    command => "${xdmod::_akrr_home}/bin/restart.sh",
    user    => $xdmod::akrr_user,
    minute  => '50',
    hour    => '23',
  }

  cron { 'akrr-checknrestart':
    command => "${xdmod::_akrr_home}/bin/checknrestart.sh",
    user    => $xdmod::akrr_user,
    minute  => '33',
  }

  shellvar { 'AKRR_HOME':
    ensure => 'exported',
    target => "${xdmod::_akrr_user_home}/.bashrc",
    value  => $xdmod::_akrr_home,
  }

  shellvar { 'akrr-PATH':
    ensure   => 'exported',
    target   => "${xdmod::_akrr_user_home}/.bashrc",
    variable => 'PATH',
    value    => "${xdmod::_akrr_home}/bin:\$PATH",
  }

  exec { 'akrrgenerate_tables.py':
    cwd     => $xdmod::_akrr_home,
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    user    => $xdmod::akrr_user,
    command => 'python ./setup/scripts/akrrgenerate_tables.py && touch ./cfg/.akrrgenerate_tables',
    creates => "${xdmod::_akrr_home}/cfg/.akrrgenerate_tables",
  }

}
