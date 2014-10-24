class lustre_client::initscripts () 
{

  file { '/etc/init.d/lustre-shutdown':
  ensure  => 'present',
  mode    => '0755',
  owner   => 'root',
  group   => 'root',
  source  => "puppet:///modules/lustre_client/initscript-lustre-shutdown"
  }

  service { lustre-shutdown:
    name       => 'lustre-shutdown',
    ensure     => running,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require => File ["/etc/init.d/lustre-shutdown"]
  }
        
}

