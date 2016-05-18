# Class: errbot::config::template_file
# ===========================
#
# Class writes errbot's config.py file from a user
# specified parameters using a template.
#
# Should be considered private and not used directly.
#
# Parameters
# ----------
#
class errbot::config::template_file (
) {

  file { "${::errbot::virtualenv_dir}/config.py":
    ensure  => 'present',
    content => epp('errbot/config.py.epp'),
    owner   => $::errbot::bot_user,
    group   => $::errbot::bot_user,
  }
}
