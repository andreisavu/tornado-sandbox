define apt::sources_list($ensure = present, $content = false, $source = false, 
                         $keyid= false, $keyserver = "keyserver.ubuntu.com") {

  if $content {
    file { "/etc/apt/sources.list.d/${name}.list":
      ensure  => $ensure,
      content => $content,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      before  => Exec["apt-get_update"],
      notify  => Exec["apt-get_update"],
    }
    if $keyid {
      case $ensure {
          present: {
            exec { "Import ${keyid} to apt keystore":
              path        => '/bin:/usr/bin',
              environment => 'HOME=/root',
              command     => "apt-key adv --keyserver ${keyserver} --recv-keys ${keyid}",
              user        => 'root',
              group       => 'root',
              unless      => "apt-key list | grep ${keyid}",
              logoutput   => on_failure,
              before  => Exec["apt-get_update"],
              notify  => Exec["apt-get_update"],
            } 
          } 
          absent: {
            exec { "Remove ${keyid} from apt keystore":
              path    => '/bin:/usr/bin',
              environment => 'HOME=/root',
              command => "apt-key del ${keyid}",
              user    => 'root',
              group   => 'root',
              onlyif  => "apt-key list | grep ${keyid}",
              before  => Exec["apt-get_update"],
              notify  => Exec["apt-get_update"],
            } 
          } 
          default: {
            fail "Invalid 'ensure' value '${ensure}' for apt::key"
          } 
     
        } 
      }
  }

}

