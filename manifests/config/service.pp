# Class: errbot::config::service
# ===========================
#
# Class which configures a sysvinit service for errbot.
# Should be considered private and not used directly.
#
# Parameters
# ----------
#
class errbot::config::service (
) {

  file { '/etc/init.d/errbot':
    ensure  => 'present',
    mode    => '0755',
    content => epp('errbot/errbot_init.epp'),
  } ~>
  exec { 'systemctl daemon-reload':
    command     => '/bin/systemctl daemon-reload',
    refreshonly => true,
  }
}
