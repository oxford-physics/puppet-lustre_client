class lustre_client ( $version=$lustre_client::params::version ) inherits lustre_client::params {

#  $repofile = "puppet:///modules/lustre_client/oxford-local-lustre-2.1-client.repo" 
  if ($version==test){
        $repofile = "puppet:///modules/lustre_client/oxford-local-lustre-2.1-client-test.repo"
  }
  if ($version=="2.1") {
          $repofile = "puppet:///modules/lustre_client/oxford-local-lustre-2.1-client.repo"
  }
    file { '/etc/yum.repos.d/oxford-local-lustre-2.1-client.repo':
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => "$repofile"

    }
  ensure_packages ( [ "lustre-client", "lustre-client-modules" ] )
#:  #libcomm_err
#                ensure =>installed,
#                require => File['/etc/yum.repos.d/oxford-local-lustre-2.1-client.repo']
#          }

  mount { "/lustre/lhcb":
    device  => "pplxlustremds:/lhcb",
    fstype  => "lustre",
    ensure  => "mounted",
    options => "localflock",
    atboot  => "true",
    require => [Package['lustre-client-modules'],File['/lustre/lhcb']],
    }
  mount { "/lustre/atlas":
    device  => "pplxlustremds:/atlas",
    fstype  => "lustre",
    ensure  => "mounted",
    options => "localflock",
    atboot  => "true",
    require => [Package['lustre-client-modules'], File['/lustre/atlas']],
    }

  file { '/lustre' :
  ensure  => 'directory',
  mode    => '0744',
  owner   => 'root',
  group   => 'root',
  }
  file { '/lustre/lhcb' :
  ensure  => 'directory',
  mode    => '0744',
  replace => "no",
  owner   => 'root',
  group   => 'root',
  require => File['/lustre'],
  }
  file { '/lustre/atlas' :
  ensure  => 'directory',
  mode    => '0744',
  replace => "no",
  owner   => 'root',
  group   => 'root',
  require => File['/lustre'],
  }


}
