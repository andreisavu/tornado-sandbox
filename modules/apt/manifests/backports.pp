class apt::backports inherits apt::apt {

  apt::sources_list { 'backports':
    ensure  => absent,
    content => 'deb http://archive.debian.org/debian-backports lenny-backports main contrib non-free ',
    keyid  => '473041FA',
  }
  
  apt::preferences {'lenny-backports':
    ensure => present,
    package => "puppet puppet-common puppetmaster facter",
    pin => 'release a=lenny-backports',
    priority => '900',
  }

}
