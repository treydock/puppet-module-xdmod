#
class xdmod::user {

  if $xdmod::manage_user {
    group { 'xdmod':
      ensure     => 'present',
      name       => 'xdmod',
      gid        => $xdmod::group_gid,
      system     => true,
      forcelocal => true,
    }

    user { 'xdmod':
      ensure     => 'present',
      name       => 'xdmod',
      uid        => $xdmod::user_uid,
      gid        => 'xdmod',
      shell      => '/sbin/nologin',
      home       => '/var/lib/xdmod',
      managehome => true,
      comment    => 'Open XDMoD',
      system     => true,
      forcelocal => true,
    }

    file { '/var/lib/xdmod':
      ensure => 'directory',
      owner  => 'xdmod',
      group  => 'xdmod',
      mode   => '0700',
    }
  }

}
