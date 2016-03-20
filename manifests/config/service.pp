# Class: errbot::config::service
# ===========================
#
# Class which configures a sysvinit service for errbot.
# Should be considered private and not used directly.
#
# Parameters
# ----------
#
class errbot::configure (
) {

  file { '/etc/init.d/errbot':
    ensure  => 'present',
    mode    => '0755',
    content => epp('errbot/errbot_init.epp'),
  }
}
