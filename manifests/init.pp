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
# [*python_version*]
#   Python version to use for errbot's virtualenv. Default: python3.4
#
# [*slack_token*]
#   Token to use when using the Slack backend
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
#   slack_token => 'x090809-....',
# }
#
class errbot (
  $backend,
  $bot_user          = 'errbot',
  $manage_user       = true,

  # Python related params
  $virtualenv_dir    = '/opt/errbot',
  $manage_python     = true,
  $manage_virtualenv = true,
  $manage_pip        = true,
  $python_version    = '3.4',
  # Account and Chatroom params
  $bot_name          = 'errbot',
  $slack_token       = undef,
  # Core Errbot params
  $data_dir          = '/opt/errbot/data',
  $storage_type      = 'Shelf',
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
  if $backend == 'Slack' {
    if $slack_token == undef {
      fail('<slack_token> param is required when using Slack backend')
    }
    validate_string($slack_token)
  }
  validate_string($bot_name)

  # Core Errbot Params
  validate_absolute_path($data_dir)
  validate_string($storage_type)
  if ! member($::errbot::params::valid_storage_types, $storage_type) {
    fail("${storage_type} is not a valid storage type")
  }

  # Prefix Config params

  # Access Control and message diversion params

  # Misc Settings


  # Setup environment
  include ::errbot::setup

  # Install errbot & dependencies
  include ::errbot::install

  # Configure errbot
  include ::errbot::configure

  # Plugin Installation

  # Errbot Service

}
