# Class: errbot::setup
# ===========================
#
# Setup environment for errbot by installing Python, Virtualenv
# and Pip if required, and creating a virtualenv.
#
# Also handles creation of bot_user, if manage_user is true.
#
# Parameters
# ----------
#
class errbot::setup (
) {

  if $::errbot::manage_user {
    user { $::errbot::bot_user:
      ensure     => 'present',
      managehome => true,
      home       => $::errbot::virtualenv_dir,
      system     => true,
    }
  }

  if $::errbot::manage_python {
    class { '::python':
      ensure     => 'present',
      version    => $::errbot::python_version,
      pip        => $::errbot::manage_pip,
      virtualenv => $::errbot::manage_virtualenv,
    }
  }

  python::virtualenv { $::errbot::virtualenv_dir:
    ensure  => 'present',
    version => $::errbot::python_version,
    owner   => $::errbot::bot_user,
  }

}
