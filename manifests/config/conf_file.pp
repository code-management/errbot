# Class: errbot::config::conf_file
# ===========================
#
# Class writes errbot's config.py file from a user
# specified file resource.
#
# Should be considered private and not used directly.
#
# Parameters
# ----------
#
class errbot::config::conf_file (
) {

  file { "${::errbot::virtualenv_dir}/config.py":
    ensure => 'present',
    source => $::errbot::config::config_file,
    owner  => $::errbot::bot_user,
    group  => $::errbot::bot_user,
  }
}
