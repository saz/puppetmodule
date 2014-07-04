class puppet::facter (
  $base = $::puppet::params::facter_base
) {
  exec { "mkdir ${base}":
    command => "mkdir -p '${base}",
    creates => $base,
    path    => ['/bin'],
  }

  file { $base:
    ensure  => directory,
    owner   => 0,
    group   => 0,
    require => Exec["mkdir ${base}"],
  }
}
