class lustre_client ( $version=$lustre_client::params::version,
               $disabledosts=$lustre_client::params::disabledosts,
               $confscript=$lustre_client::params::confscript,
               $kernelversionel6 = $lustre_client::params::kernelversionel6,
               $forcekernelversion=$lustre_client::params::forcekernelversion,
               $mountopts = $lustre_client::params::mountopts,
               $atlas_mountopts = $lustre_client::params::mountopts,
  ) inherits lustre_client::params 
{

  $repotarget = "/etc/yum.repos.d/oxford-local-lustre-client.repo"
  if ($version==test){
        $repofile = "puppet:///modules/$module_name/oxford-local-lustre-2.1-client-test.repo"
  }
  if ($version=="2.5") {
          $repofile = "puppet:///modules/$module_name/oxford-local-lustre-2.5-client.repo"

  }
  if ($version=="2.1") {
          $repofile = "puppet:///modules/$module_name/oxford-local-lustre-2.1-client.repo"
           file { '/etc/yum.repos.d/oxford-local-lustre-2.1-client.repo':
               ensure  => absent,
           }

  }

  file { "/usr/local/bin/killlustreprocs":
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/$module_name/killlustreprocs"
  }

  file { "/usr/local/bin/ldf":
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    source  => "puppet:///modules/$module_name/ldf"
  }

  file { "$repotarget":
    ensure  => present,
    mode    => '0644',
    owner   => 'root',
    group   => 'root',
    source  => "$repofile"

    }
  ensure_packages ( [ "lustre-client", "lustre-client-modules" ] )
  mount { "/lustre/lhcb25":
    device  => "pplxlustre25mds3.physics.ox.ac.uk:/lhcb25",
    fstype  => "lustre",
    ensure  => "mounted",
    options => "$mountopts",
    atboot  => "true",
    require => [Package['lustre-client-modules'], File['/lustre/lhcb25']],
    }

   mount { "/lustre/atlas25":
    device  => "pplxlustre25mds3.physics.ox.ac.uk:/atlas25",
    fstype  => "lustre",
    ensure  => "mounted",
    options => "$atlas_mountopts",
    atboot  => "true",
    require => [Package['lustre-client-modules'], File['/lustre/atlas25']],
    }

  file { '/lustre' :
  ensure  => 'directory',
  mode    => '0700',
  owner   => 'root',
  group   => 'root',
  }
  file { '/lustre/lhcb25' :
  ensure  => 'directory',
  mode    => '0744',
  replace => "no",
  owner   => 'root',
  group   => 'root',
  require => File['/lustre'],
  }
  file { '/lustre/atlas25' :
  ensure  => 'directory',
  mode    => '0744',
  replace => "no",
  owner   => 'root',
  group   => 'root',
  require => File['/lustre'],
  }
  

  exec { 'configure_active_osts':
        command => "$confscript",
        refreshonly => true,
        subscribe => File["$confscript"]
    }

  concat { $confscript:
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    notify  => Exec[configure_active_osts],
  }

  concat::fragment { 'lustre_client_confscr':
    target  => $confscript,
    content => template('lustre_client/set_conf.erb')
  }

  if str2bool("$forcekernelversion" )
  {
    notify { "Warning, forcing kernel to version $kernelversionel6" :}
    package { kernel:
              ensure => $kernelversionel6     
    }
  }
  include lustre_client::initscripts
}


