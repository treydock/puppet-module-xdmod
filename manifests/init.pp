# == Class: xdmod
#
# See README.md for more details.
#
class xdmod (
  $package_ensure       = $xdmod::params::package_ensure,
  $package_name         = $xdmod::params::package_name,
  $package_require      = $xdmod::params::package_require,
) inherits xdmod::params {

  anchor { 'xdmod::start': }->
  class { 'xdmod::install': }->
  class { 'xdmod::config': }->
  anchor { 'xdmod::end': }

}
