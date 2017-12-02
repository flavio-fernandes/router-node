$deps = [
]

package { $deps:
    ensure   => installed,
}

exec { 'run base1.sh':
  command => '/vagrant/puppet/scripts/base1.sh',
  user    => 'root',
  cwd     => '/home/vagrant',
  path    => $::path,
  timeout => 0,
}

