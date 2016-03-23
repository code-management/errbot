# Class: errbot::config
# ===========================
#
# Configuration class for an errbot instance.
# Allows a user to configure a basic errbot instance using Puppet
# parameters.
#
# Parameters
# ----------
#
# [*backend*]
#   Backend to use to errbot.
#
# [*bot_admins*]
#   List of strings for bot admins. Format of strings depends on backend.
#   For exmaple, Slack backend uses '@username' strings.
#
# [*bot_name*]
#   Name of this bot instance. Default: errbot
#
# [*bot_credentials*]
#   Hash used to configure the bot's credentials in config.py.
#   The keys & values depend on the backend being used. For example,
#   hosted Slack, Telegram and Hipchat backends use a hash as below:
#     bot_credentials => {
#       token => 'foobar'
#     }
#   In contrast, XMPP & IRC a username & password, as well as server
#   settings. Refer to the errbot docs for details on your specific backend.
#     http://errbot.io/en/latest/user_guide/setup.html#configuration
#
# [*data_dir*]
#   Data directory for errbot. Defaults to /opt/errbot/data
#
# [*storage_type*]
#   Storage type to use. Defaults to 'Shelf'
#
# Example
# -------
# errbot::config {
#   backend         => 'Slack',
#   bot_admins      => ['@scary_admin'],
#   bot_credentials => {
#       token => 'xosbb--dummy_token123456',
#   }
# }
#

class errbot::config (
  $backend,
  $bot_name            = 'errbot',
  $bot_credentials,
  $bot_admins,
  $data_dir            = '/opt/errbot/data',
  $storage_type        = 'Shelf',
) {
  # --------------------------------------------------------------
  # Parameter validation
  # --------------------------------------------------------------
  validate_string($backend)
  validate_array($bot_admins)

  validate_hash($bot_credentials)
  if member(['Slack', 'Telegram'], $backend) {
    if ! member(keys($bot_credentials),'token') {
      fail("Failed to find 'token' key in <bot_credentials>, required when using ${backend} backend")
    }
  }
  #TODO: Validate bot_credentials for other backends

  validate_string($bot_name)
  validate_absolute_path($data_dir)
  validate_string($storage_type)
  if ! member($::errbot::params::valid_storage_types, $storage_type) {
    fail("${storage_type} is not a valid storage type")
  }

  # --------------------------------------------------------------
  # Configuration
  # --------------------------------------------------------------
  file { "${::errbot::virtualenv_dir}/config.py":
    ensure  => 'present',
    content => epp('errbot/config.py.epp'),
    owner   => $::errbot::bot_user,
  }

  file { $::errbot::config::data_dir:
    ensure => 'directory',
    owner  => $::errbot::bot_user,
  }

}
