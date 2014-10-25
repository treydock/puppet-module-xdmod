# Private class
class xdmod::config {

  create_resources('xdmod_portal_setting', $xdmod::portal_settings)

  xdmod_portal_setting { 'logger/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'logger/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'logger/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'logger/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'database/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'database/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'database/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'database/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'datawarehouse/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'datawarehouse/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'datawarehouse/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'datawarehouse/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'shredder/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'shredder/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'shredder/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'shredder/pass': value => $xdmod::database_password }

  xdmod_portal_setting { 'hpcdb/host': value => $xdmod::database_host }
  xdmod_portal_setting { 'hpcdb/port': value => $xdmod::database_port }
  xdmod_portal_setting { 'hpcdb/user': value => $xdmod::database_user }
  xdmod_portal_setting { 'hpcdb/pass': value => $xdmod::database_password }

  file { '/etc/xdmod/portal_settings.ini':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { '/root/xdmod-database-setup.sh':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
    content => template('xdmod/xdmod-database-setup.sh.erb'),
  }

  file { '/etc/cron.d/xdmod':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('xdmod/xdmod_cron.erb'),
  }

  logrotate::rule { 'xdmod':
    ensure       => 'present',
    path         => '/var/log/xdmod/*.log',
    rotate       => 4,
    rotate_every => 'week',
    missingok    => true,
    compress     => true,
    dateext      => true,
  }

}
