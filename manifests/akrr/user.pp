# @summary Manage XDMoD AKRR user
# @api private
class xdmod::akrr::user {
  if $xdmod::manage_akrr_user {
    if $xdmod::akrr_user_managehome {
      $_user_before = Exec['mk-akrr-home']
    } else {
      $_user_before = undef
    }

    group { 'akrr':
      ensure     => 'present',
      name       => $xdmod::akrr_user_group,
      gid        => $xdmod::akrr_user_group_gid,
      system     => $xdmod::akrr_user_system,
      forcelocal => true,
    }

    user { 'akrr':
      ensure     => 'present',
      name       => $xdmod::akrr_user,
      uid        => $xdmod::akrr_user_uid,
      gid        => $xdmod::akrr_user_group,
      shell      => $xdmod::akrr_user_shell,
      home       => $xdmod::_akrr_user_home,
      managehome => $xdmod::akrr_user_managehome, # This is ignored because of forcelocal => true
      comment    => $xdmod::akrr_user_comment,
      system     => $xdmod::akrr_user_system,
      forcelocal => true,
      before     => $_user_before,
    }
  }

  if $xdmod::akrr_user_managehome {
    # Because forcelocal causes managehome to be ignored, we create home via Exec
    exec { 'mk-akrr-home':
      command => "mkhomedir_helper ${xdmod::akrr_user}",
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      creates => $xdmod::_akrr_user_home,
    }
  }
}
