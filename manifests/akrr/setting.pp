# @summary Manage AKRR config setting value
#
# @param value
#   Setting value
# @param quote
#   Should value be quoted
define xdmod::akrr::setting ($value, $quote = undef) {

  include xdmod

  $_config_path = "${xdmod::_akrr_home}/cfg/akrr.inp.py"

  if $quote != undef {
    $_quote = $quote
  } elsif is_integer($value) {
    $_quote = false
  } else {
    $_quote = true
  }

  if $_quote {
    $_value = "'${value}'"
  } else {
    $_value = $value
  }

  $_line        = "${name} = ${_value}"

  file_line { "akrr-setting-${name}":
    ensure  => 'present',
    path    => $_config_path,
    line    => $_line,
    match   => "^${name}",
    notify  => Exec['restart akrr'],
    require => File['akrr.inp.py'],
  }

}