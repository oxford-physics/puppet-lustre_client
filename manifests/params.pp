class lustre_client::params()
{
 $version = hiera("lustre_client::params::version","2.1") 
 $disabledosts = hiera("lustre_client::params::disabledosts",[]) 
 $confscript   = hiera("lustre_client::params::confscript","/usr/local/bin/lustre_disable_osts.sh")
 $kernelversionel6 = hiera("lustre_client::params::kernelversionel6","")
 $forcekernelversion=hiera("lustre_client::params::forcekernelversion","false")
 $mountopts  = hiera("lustre_client::params::mountopts", "localflock,_netdev,rw")
}

