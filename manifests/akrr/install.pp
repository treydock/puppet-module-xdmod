# Private class
class xdmod::akrr::install {

  file { $xdmod::_akrr_home:
    ensure => 'directory',
    owner  => $xdmod::akrr_user,
    group  => $xdmod::akrr_user_group,
    mode   => '0700',
  }
  -> archive { "/tmp/akrr-${xdmod::akrr_version}.tar.gz":
    source          => $xdmod::_akrr_source_url,
    extract         => true,
    extract_path    => $xdmod::_akrr_home,
    extract_command => 'tar xfz %s --strip-components=1',
    creates         => "${xdmod::_akrr_home}/setup",
    cleanup         => true,
    user            => $xdmod::akrr_user,
    group           => $xdmod::akrr_user_group,
  }

}
