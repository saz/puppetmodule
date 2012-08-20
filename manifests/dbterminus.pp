class puppet::dbterminus($puppet_confdir, $puppet_service, $dbport, $dbserver)
{
  package { 'puppetdb-terminus':
    ensure  => present,
  }

  # TODO: this will overwrite any existing routes.yaml;
  #  to handle this properly we should just be ensuring
  #  that the proper lines exist
  file { "$puppet_confdir/routes.yaml":
    ensure      => file,
    source      => 'puppet:///modules/puppet/routes.yaml',
    notify      => $puppet_service,
    require     => Package['puppetdb-terminus'],
  }

  file { "$puppet_confdir/puppetdb.conf":
    ensure      => file,
    require     => File["$puppet_confdir/routes.yaml"],
    notify      => $puppet_service,
  }

  ini_setting {'puppetterminusserver':
    ensure  => present,
    section => 'main',
    setting => 'server',
    path    => "$puppet_confdir/puppetdb.conf",
    value   => $dbserver,
    require => File["$puppet_confdir/puppetdb.conf"],
  }

  ini_setting {'puppetterminusport':
    ensure  => present,
    section => 'main',
    setting => 'port',
    path    => "$puppet_confdir/puppetdb.conf",
    value   => $dbport,
    require => File["$puppet_confdir/puppetdb.conf"],
  }
}