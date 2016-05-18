# Class: errbot::install
# ===========================
#
# Install errbot and dependencies
# Should be considered private and not used directly.
#
# Parameters
# ----------
#
class errbot::install (
) {


  # Install any additional pip packages we require before installing errbot
  $pip_packages = union($::errbot::additional_packages, $::errbot::config::backend_dependencies)
    python::pip { $pip_packages:
      ensure     => 'present',
      virtualenv => $::errbot::virtualenv_dir,
      before     => Python::Pip['errbot'],
    }

  # Install errbot
  python::pip { 'errbot':
    ensure     => 'present',
    virtualenv => $::errbot::virtualenv_dir,
  }

}
