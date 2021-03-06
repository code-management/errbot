# Class: errbot
# ===========================
#
# Parent class for errbot
#
# Parameters
# ----------
#
# [*additional_packages*]
#   Any additonal pip packages to be installed into the errbot
#   virtualenv, such as those to support your chosen backend. Default: []
#
# [*bot_user*]
#   Local system user underwhich to run the errbot instance. Default: errbot
#
# [*manage_bot_user*]
#   Manage bot_user via Puppet. Default: true
#
# [*manage_pip*]
#   Whether this module should install pip. Default: true
#
# [*manage_python*]
#   Whether this module should install Python. Default: true
#
# [*manage_python_dev*]
#   Whether this module should install python-dev packages. Default: true
#
# [*manage_virtualenv*]
#   Whether this module should install python-venv. Default: true
#
# [*python_version*]
#   Python version to use for errbot's virtualenv. Default: system
#
# [*virtualenv_dir*]
#   Path for the errbot virtualenv & config.py. Defaults to /opt/errbot
#
# Example
# -------
#
# include errbot
#
class errbot (
  $additional_packages = [],
  $bot_user            = 'errbot',
  $manage_bot_user     = true,
  $manage_pip          = true,
  $manage_python       = true,
  $manage_python_dev   = true,
  $manage_virtualenv   = true,
  $python_version      = '3.4',
  $virtualenv_dir      = '/opt/errbot',
) {
  include ::errbot::params

  # Parameter Validation
  validate_absolute_path($virtualenv_dir)
  validate_bool($manage_python)
  validate_bool($manage_python_dev)
  validate_bool($manage_pip)
  validate_bool($manage_virtualenv)

  Class['::errbot::setup'] -> Class['::errbot::config'] -> Class['::errbot::install'] -> File["${::errbot::virtualenv_dir}/config.py"]
  Class['::errbot::config::service'] -> Service['errbot']
  File["${::errbot::virtualenv_dir}/config.py"] ~> Service['errbot']
  # Setup environment
  include ::errbot::setup

  # Install errbot & dependencies
  include ::errbot::install

  # Configure errbot service
  include ::errbot::config::service


  # Errbot Service
  service { 'errbot':
    ensure   => 'running',
    start    => '/etc/init.d/errbot start',
    stop     => '/etc/init.d/errbot stop',
    status   => '/etc/init.d/errbot status',
    provider => 'base',
  }

}
