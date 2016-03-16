# Class: errbot::configure
# ===========================
#
# Class for configuring errbot instance via config.py
#
# Parameters
# ----------
#
class errbot::configure (

) {

  file { "${::errbot::virtualenv_dir}/config.py":
    ensure  => 'present',
    content => epp('errbot/config.py.epp'),
    owner   => $::errbot::bot_user,
  }
}
