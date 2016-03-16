# Class: errbot::install
# ===========================
#
# Install errbot and dependencies
#
# Parameters
# ----------
#
class errbot::install (
) {

  # Install user specified packages, if requested
  if $::errbot::additional_packages {
    python::pip { $::errbot::additional_packages:
      ensure     => 'present',
      virtualenv => $::errbot::virtualenv_dir,
      before     => Python::Pip['errbot'],
    }
  }

  # Install backend dependencies, if any exist
  if $::errbot::params::backend_dependencies {
    python::pip { $::errbot::params::backend_dependencies:
      ensure     => 'present',
      virtualenv => $::errbot::virtualenv_dir,
      before     => Python::Pip['errbot'],
    }
  }

  # Install errbot
  python::pip { 'errbot':
    ensure     => 'present',
    virtualenv => $::errbot::virtualenv_dir,
  }

}
