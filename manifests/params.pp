# Class: errbot::params
# ===========================
#
# Private parameters class for errbot
# class.
#
# Should not be used directly.
#
class errbot::params {
  # Default parameter values

  # Parameter validation
  $valid_storage_types = [
    'Memory', 'Shelf',
  ]

  # OS Package Dependencies
  case $::facts['operatingsystem'] {
    'RedHat', 'CentOS', 'Fedora': { $dependencies = ['libffi-devel', 'openssl-devel']}
    /^(Debian|Ubuntu)$/:          { $dependencies = ['libffi-dev', 'libssl-dev']}
    default: { warn("Unrecognized OS ${::facts['operatingsystem']}. You may need to install dependencies manually")}
  }
}
