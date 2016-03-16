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

  python::pip { $::errbot::additional_packages:
    ensure     => 'present',
    virtualenv => $::errbot::virtualenv_dir,
  }


  python::pip { $::errbot::params::backend_dependencies:
    ensure     => 'present',
    virtualenv => $::errbot::virtualenv_dir,
  }

  python::pip { 'errbot':
    ensure     => 'present',
    virtualenv => $::errbot::virtualenv_dir,
    require    => Python::Pip[$::errbot::dependencies],
  }

}
