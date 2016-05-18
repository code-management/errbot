# Class: errbot::config
# ===========================
#
# Configuration class for an errbot instance.
# Allows a user to configure a basic errbot instance using Puppet
# parameters.
#
# This class will attempt to install the dependencies for the passed backend.
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
# [*config_file*]
#   An optional file reference to a Python config.py file. #TODO: dox correctly
#
# [*data_dir*]
#   Data directory for errbot. Defaults to /opt/errbot/data
#
# [*storage_type*]
#   Storage type to use. Defaults to 'Shelf'
#
# Example
# -------
# class { 'errbot::config':
#   backend         => 'Slack',
#   bot_admins      => ['@scary_admin'],
#   bot_credentials => {
#       token => 'xosbb--dummy_token123456',
#   }
# }
#

class errbot::config (
  $backend         = undef,
  $bot_name        = 'errbot',
  $bot_credentials = undef,
  $bot_admins      = undef,
  $config_file     = undef,
  $data_dir        = '/opt/errbot/data',
  $storage_type    = 'Shelf',
) {
  # --------------------------------------------------------------
  # Parameter validation
  # --------------------------------------------------------------
  if $config_file == undef {
    notify {'Using template config.py as $errbot::config::config_file was not passed':}
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

    include ::errbot::config::template_file
  } else {

    notify {'Writing config.py with passed config_file':}
    include ::errbot::config::conf_file

  }


  # Dependencies based on backend selection
  case $::errbot::config::backend {
    'XMPP':    { $backend_dependencies = ['sleekxmpp', 'pyasn1', 'pyasn1-modules', ]}
    'Hipchat': { $backend_dependencies = ['sleekxmpp', 'pyasn1', 'pyasn1-modules', 'hypchat']}
    'IRC':     { $backend_dependencies = ['irc'] }
    'Slack':   { $backend_dependencies = ['slackclient'] }
    'Telegram':{ $backend_dependencies = ['python-telegram-bot'] }

    'Text', 'Graphic', 'Campfire', 'Glitter', 'TOX': {
      $backend_dependencies = []
    }
    default:   {
      warning("${::errbot::config::backend} is not a supported backend. Proceed with caution and specify additional dependencies yourself.")
      $backend_dependencies = []
    }
  }
  # Install backend specific dependencies
  python::pip { $::errbot::config::backend_dependencies:
    ensure     => 'present',
    virtualenv => $::errbot::virtualenv_dir,
    before     => Python::Pip['errbot'],
  }


  file { $::errbot::config::data_dir:
    ensure => 'directory',
    owner  => $::errbot::bot_user,
    group  => $::errobt::bot_user,
  }

}
