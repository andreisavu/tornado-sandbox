class squid::ppa {
  include apt::apt

  apt::sources_list {'squid-ppa':
    content => 'deb http://ppa.launchpad.net/lynxman/squid-ssl/ubuntu precise main',
    keyid   => 'A89578A0',
  }

  apt::preferences {'squid-ppa':
    package  => 'squid3 squid3-common',
    pin      => 'release o=LP-PPA-lynxman-squid-ssl',
    priority => 600,
    require  => Apt::Sources_list ['squid-ppa'],
  }
  
}
