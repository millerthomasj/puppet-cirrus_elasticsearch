class cirrus_elasticsearch::tls
{
  user { 'elasticsearch':
    ensure => present,
    groups => 'puppet',
  }
}
