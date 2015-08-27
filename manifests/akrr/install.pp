# Private class
class xdmod::akrr::install {

  file { $xdmod::_akrr_home:
    ensure => 'directory',
    owner  => $xdmod::akrr_user,
    group  => $xdmod::akrr_user_group,
    mode   => '0700',
  }->
  staging::file { "akrr-${xdmod::akrr_version}.tar.gz":
    source  => $xdmod::_akrr_source_url,
  }->
  staging::extract { "akrr-${xdmod::akrr_version}.tar.gz":
    target  => $xdmod::_akrr_home,
    strip   => '1',
    user    => $xdmod::akrr_user,
    group   => $xdmod::akrr_user_group,
    creates => "${xdmod::_akrr_home}/setup",
  }

}
