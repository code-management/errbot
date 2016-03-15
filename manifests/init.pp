# Class: errbot
# ===========================
#
# Parent class for errbot
#
# Parameters
# ----------
#
#
# Example
# -------
class errbot (
  $virtualenv_dir    = '/opt/errbot',
  $manage_python     = true,
  $manage_virtualenv = true,
  $manage_pip        = true,
  $python_version    = '3.3',
) {

  $dependencies = ['slackclient']
  # Validate params

  # Setup environment
  include ::errbot::setup

  # Install errbot & dependencies
  include ::errbot::install

  # Configure errbot


}
