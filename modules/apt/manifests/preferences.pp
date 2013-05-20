define apt::preferences ($pin, $priority, $ensure = present, $package = "") {

  file {"/etc/apt/preferences.d/${name}":
#  file {"/etc/apt/preferences":
    ensure  => $ensure,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template("apt/preferences.erb"),
    notify  => Exec["apt-get_update"],
  }

}
