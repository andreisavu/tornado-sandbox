define apt::key($keyid, $ensure, $keyserver = "keyserver.ubuntu.com", $source = "") {

  case $ensure {
    present: {
      if $source == "" {
        exec { "Import ${keyid} to apt keystore":
          path        => '/bin:/usr/bin',
          environment => 'HOME=/root',
          command     => "apt-key adv --keyserver ${keyserver} --recv-keys ${keyid}",
          user        => 'root',
          group       => 'root',
          unless      => "apt-key list | grep ${keyid}",
          logoutput   => on_failure,
        }
      } 
	    else {
		    exec { "Import ${keyid} from ${source} to apt keystore":
		      path    => "/bin:/usr/bin",
		      command => "wget -O - '${source}' | apt-key add -",
	        unless  => "apt-key list | grep -Fe '${keyid}' | grep -Fvqe 'expired:'",
		      before  => Exec['apt-get_update'],
          notify  => Exec['apt-get_update'],
		    }
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
      }
    }
    default: {
      fail "Invalid 'ensure' value '${ensure}' for apt::key"
    }
  }

}
