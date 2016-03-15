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
    'XMPP':    { $backend_dependencies = ['sleekxmpp', 'pyasn1', 'pyasn1-modules', 'dnspython3']}             #TODO This is dnspython for Python2 :/
    'Hipchat': { $backend_dependencies = ['sleekxmpp', 'pyasn1', 'pyasn1-modules', 'dnspython3', 'hypchat']}  #TODO This is dnspython for Python2 :/
    'IRC':     { $backend_dependencies = ['irc'] }
    'Slack':   { $backend_dependencies = ['slackclient'] }

    'Text', 'Graphic', 'Campfire', 'Glitter', 'TOX', 'Telegram': {
      $backend_dependencies = []
    }
    default:   { fail("${::errbot::backend} is not currently a supported backend")}
  }
}
