class squid::server { 

  include squid::ppa

  package { 'squid3':
    ensure   => latest,
    provider => aptitude, #provider apt can't downgrade
    require  => Package ['squid3-common'],
  }

  package { 'squid3-common':
    ensure  => latest,
    provider => aptitude, #provider apt can't downgrade
    require => Class ['squid::ppa'],
  }


  file { '/etc/squid3/squid.conf':
    ensure  => present,
    mode    => '0600',
    source  => 'puppet:///modules/squid/squid3.conf',
    require => Package['squid3'],
  }

  service { 'squid3':
    ensure    => running,
    require   => Package['squid3'],
    subscribe => File['/etc/squid3/squid.conf'],
  }

}
