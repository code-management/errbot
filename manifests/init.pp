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
  $bot_name          = 'errbot',

  # Python related params
  $virtualenv_dir    = '/opt/errbot',
  $manage_python     = true,
  $manage_virtualenv = true,
  $manage_pip        = true,
  $python_version    = 'python3.4',
  # Backend Specific Params
  $slack_token       = undef,
  # Storage params
  $data_dir          = '/opt/errbot/data',
  $storage_type      = 'Shelf',
) {
  include ::errbot::params

  # Validate params - General
  validate_string($backend)
  if ! member($::errbot::params::valid_backends, $backend) {
    fail("${backend} is not a valid errbot backend")
  }
  validate_string($bot_name)
  # Python related Params
  validate_absolute_path($virtualenv_dir)
  validate_boolean($manage_python)
  validate_boolean($manage_pip)
  validate_boolean($manage_virtualenv)

  # Validate backend specific params
  if $backend == 'Slack' {
    if $slack_token == undef {
      fail('<slack_token> param is required when using Slack backend')
    }
    validate_string($slack_token)
  }

  # Storage params
  validate_absolute_path($data_dir)
  validate_string($storage_type)
  if ! member($::errbot::params::valid_storage_types, $storage_type) {
    fail("${storage_type} is not a valid storage type")
  }


  # Setup environment
  include ::errbot::setup

  # Install errbot & dependencies
  include ::errbot::install

  # Configure errbot
  include ::errbot::configure

  # Plugin Installation

}
