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
  $valid_backends = [
    'Text', 'Graphic',                          # debug backends
    'Slack', 'Campfire', 'Glitter', 'Hipchat',  # commercial backends
    'TOX', 'IRC', 'XMPP', 'Telegram'            # FOSS backends
  ]
  $valid_storage_types = [
    'Memory', 'Shelf',
  ]
}
