
stage { 'system':
  before => Stage['main']
}

class common {
  package { [
    'vim',
    'git-core',
    'python-pip',
    'python-dev',
    'ipython',
    'build-essential',
    'libcurl3',
    'python-pycurl'
  ]:
    ensure => installed 
  }
}

node default { 

  class { 'common':
    stage => 'system'
  }

  package { 'tornado':
    ensure   => '3.0.1',
    provider => pip
  }

}

