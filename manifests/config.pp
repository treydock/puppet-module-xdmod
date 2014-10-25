# Private class
class xdmod::config {

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
