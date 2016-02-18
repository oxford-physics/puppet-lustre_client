class lustre_client::initscripts ($confscript = $lustre_client::params::confscript)  inherits lustre_client::params
{

#TODO, this should be a better init script
    file {'/etc/rc3.d/S99lustre-disable':
      ensure => link,
      target => $confscript ,
      require => File ["$confscript"]
    }

    file {'/etc/rc5.d/S99lustre-disable':
      ensure => link,
      target => $confscript ,
      require => File ["$confscript"]
    }

  file { '/etc/init.d/lustre-shutdown':
  ensure  => 'present',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  source  => "puppet:///modules/lustre_client/initscript-lustre-shutdown"
  }

  
  service { lustre-shutdown:
    name       => 'lustre-shutdown',
#    ensure     => running,
    enable     => false,
    hasrestart => false,
    hasstatus  => false,
    require => File ["/etc/init.d/lustre-shutdown"]
  }
  #work around https://projects.puppetlabs.com/issues/10980#note-1
    file {'/etc/rc6.d/K02lustre-shutdown':
      ensure => link,
      target => '/etc/init.d/lustre-shutdown' ,
      require => File ["/etc/init.d/lustre-shutdown"]

    }        
    file {'/etc/rc0.d/K02lustre-shutdown':
      ensure => link,
      target => '/etc/init.d/lustre-shutdown' ,
      require => File ["/etc/init.d/lustre-shutdown"]
    }        
}

