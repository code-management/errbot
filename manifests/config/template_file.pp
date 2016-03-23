class errbot::config::template_file (
) {

  file { "${::errbot::virtualenv_dir}/config.py":
    ensure  => 'present',
    content => epp('errbot/config.py.epp'),
    owner   => $::errbot::bot_user,
  }
}
