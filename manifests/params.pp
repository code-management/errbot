# Class: errbot::params
# ===========================
#
# Private parameters class for errbot
# class.
#
# Should not be used directly.
#
class errbot::params {

  # Parameter validation
  $valid_storage_types = [
    'Memory', 'Shelf',
  ]

  # Dependencies based on backend selection
  case $::errbot::backend {
    'XMPP':    { $backend_dependencies = ['sleekxmpp', 'pyasn1', 'pyasn1-modules', ]}
    'Hipchat': { $backend_dependencies = ['sleekxmpp', 'pyasn1', 'pyasn1-modules', 'hypchat']}
    'IRC':     { $backend_dependencies = ['irc'] }
    'Slack':   { $backend_dependencies = ['slackclient'] }
    'Telegram':{ $backend_dependencies = ['python-telegram-bot'] }

    'Text', 'Graphic', 'Campfire', 'Glitter', 'TOX': {
      $backend_dependencies = []
    }
    default:   { warn("${::errbot::backend} is not a supported backend. Proceed with caution.")}
  }

  # OS Package Dependencies
  case $::facts['operatingsystem'] {
    'RedHat', 'CentOS', 'Fedora': { $dependencies = ['libffi-devel']}
    /^(Debian|Ubuntu)$/:          { $dependencies = ['libffi-dev']}
    default: { warn("Unrecognized OS ${::facts['operatingsystem']}. You may need to install dependencies manually")}
  }
}
