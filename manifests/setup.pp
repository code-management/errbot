# Class: errbot::setup
# ===========================
#
# Setup environment for errbot by installing Python, Virtualenv
# and Pip if required, and creating a virtualenv.
#
# Also handles creation of bot_user, if manage_user is true.
# Should be considered private and not used directly.
#
# Parameters
# ----------
#
class errbot::setup (
) {

  if $::errbot::params::dependencies {
    package { $::errbot::params::dependencies:
      ensure => 'installed',
    }
  }

  if $::errbot::manage_user {
    user { $::errbot::bot_user:
      ensure     => 'present',
      managehome => true,
      home       => $::errbot::virtualenv_dir,
      system     => true,
    }
  }

  file { $::errbot::data_dir:
    ensure => 'directory',
    owner  => $::errbot::bot_user,
  }

  if $::errbot::manage_python {
    class { '::python':
      ensure     => 'present',
      version    => $::errbot::python_version,
      pip        => $::errbot::manage_pip,
      dev        => $::errbot::manage_python_dev,
      virtualenv => $::errbot::manage_virtualenv,
    }
  }

  python::virtualenv { $::errbot::virtualenv_dir:
    ensure  => 'present',
    version => $::errbot::python_version,
    owner   => $::errbot::bot_user,
  }

}
