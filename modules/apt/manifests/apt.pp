class apt::apt {

  Apt::Preferences <| |> -> Exec["apt-get_update"]
  Apt::Key <| |> -> Exec["apt-get_update"] 
  package { 'debian-archive-keyring': ensure => installed , notify => Exec['apt-get_update'], } 

  apt::key { 'ubuntu key':
    ensure => present,
    keyid  => '437D05B5',
    notify => Exec['apt-get_update'],
  }

  exec { "apt-get_update":
    command     => "/usr/bin/apt-get update",
    refreshonly => true,
  }

}
