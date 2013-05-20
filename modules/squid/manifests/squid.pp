class squid::squid { 

  package { 'squid': ensure => installed }

  file { '/etc/squid':
    name      => $::lsbdistcodename ? {
      precise => '/etc/squid3',
      default => '/etc/squid',
    },
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file { '/etc/squid/squid.conf':
    name      => $::lsbdistcodename ? {
      precise => '/etc/squid3/squid.conf',
      default => '/etc/squid/squid.conf',
    },
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    source  => $::lsbdistcodename ? {
      precise => 'puppet:///modules/squid/squid3.conf',
      default => 'puppet:///modules/squid/squid.conf',
    },
    require => Package['squid'],
  }

  service { 'squid':
    name      => $::lsbdistcodename ? {
      precise => 'squid3',
      default => 'squid',
    },
    ensure    => running,
    require   => Package['squid'],
    subscribe => $::lsbdistcodename ? {
      precise =>  File['/etc/squid3/squid.conf'],
      default =>  File['/etc/squid/squid.conf'],
    },
  }

}
