# Class: errbot
# ===========================
#
# Parent class for errbot
#
# Parameters
# ----------
#
# [*backend*]
#   Backend to use to errbot. Default: Slack
#
# [*bot_name*]
#   Name of this bot instance. Default: errbot
#
# [*bot_user*]
#   Local user underwhich to run the errbot instance. Default: errbot
#
# [*manage_user*]
#   Manage bot_user via Puppet. Default: true
#
# [*virtualenv_dir*]
#   Path for the errbot virtualenv & config.py. Defaults to /opt/errbot
#
# [*manage_python*]
#   Whether this module should install Python. Default: true
#
# [*manage_virtualenv*]
#   Whether this module should install python-venv. Default: true
#
# [*manage_pip*]
#   Whether this module should install pip. Default: true
#
# [*addtional_packages*]
#   Any additonal pip packages you want to be installed into the
#   virtualenv
#
# [*python_version*]
#   Python version to use for errbot's virtualenv. Default: python3.4
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
# [*bot_admins*]
#   List of strings for bot admins. Format of strings depends on backend.
#   For exmaple, Slack backend uses '@username' strings.
#
# [*data_dir*]
#   Data directory for errbot. Defaults to /opt/errbot/data
#
# [*storage_type*]
#   Storage type to use. Defaults to 'Shelf'
#
# Example
# -------
#
# class { 'errbot':
#   backend     => 'slack',
#   bot_credentials => {
#     token => 'x097897...',
#   }
#
class errbot (
  $backend,
  $bot_user           = 'errbot',
  $manage_user        = true,

  # Python related params
  $virtualenv_dir     = '/opt/errbot',
  $manage_python      = true,
  $manage_virtualenv  = true,
  $manage_pip         = true,
  $python_version     = 'system',
  $addtional_packages = [],
  # Account and Chatroom params
  $bot_name           = 'errbot',
  $bot_credentials,
  $bot_admins,
  # Core Errbot params
  $data_dir           = '/opt/errbot/data',
  $storage_type       = 'Shelf',
  # Prefix config params
  # Access control & Message diversion params
  # Misc Settings
) {
  include ::errbot::params

  # Validate params - General
  validate_string($backend)   # This is also validated in errbot::params, when solving backend specific deps
  # Python related Params
  validate_absolute_path($virtualenv_dir)
  validate_bool($manage_python)
  validate_bool($manage_pip)
  validate_bool($manage_virtualenv)

  # Account and Chatroom params
  if member(['Slack', 'Telegram'], $backend) {
    if ! member(keys($bot_credentials),'token') {
      fail("Failed to find 'token' key in <bot_credentials>, required when using ${backend} backend")
    }
  }
  #TODO: Validate bot_credentials for other backends
  validate_string($bot_name)
  validate_array($bot_admins)

  # Core Errbot Params
  validate_absolute_path($data_dir)
  validate_string($storage_type)
  if ! member($::errbot::params::valid_storage_types, $storage_type) {
    fail("${storage_type} is not a valid storage type")
  }

  # Prefix Config params

  # Access Control and message diversion params

  # Misc Settings


  Class['::errbot::setup'] -> Class['::errbot::install'] -> Class['::errbot::configure']

  # Setup environment
  include ::errbot::setup

  # Install errbot & dependencies
  include ::errbot::install

  # Configure errbot
  include ::errbot::configure

  # Plugin Installation

  # Errbot Service

}
