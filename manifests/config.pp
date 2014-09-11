# == Class: xdmod::config
#
# Private class.
#
class xdmod::config {

  include xdmod

  file { '/etc/xdmod/portal_settings.ini':
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

  logrotate::rule { 'xdmod':
    ensure        => 'present',
    path          => '/var/log/xdmod/*.log',
    rotate        => 4,
    rotate_every  => 'week',
    missingok     => true,
    compress      => true,
    dateext       => true,
  }

}
