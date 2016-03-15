# Class: errbot::setup
# ===========================
#
# Setup environment for errbot.
#
# Parameters
# ----------
#
class errbot::setup (
) {

  if $::errbot::manage_python {
    class { '::python':
      ensure     => 'present',
      version    => $::errbot::python_version,
      pip        => $::errbot::manage_pip,
      virtualenv => $::errbot::manage_virtualenv,
    }
  }

  python::pyvenv { $::errbot::virtualenv_dir:
    ensure  => 'present',
    version => $::errbot::python_version,
  }

}
