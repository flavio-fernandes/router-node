$deps = [ 'git',
]

package { $deps:
    ensure   => installed,
}

vcsrepo { '/vagrant/puppet/modules/yum':
    ensure   => present,
    provider => git,
    user     => 'vagrant',
    source   => 'git://github.com/purpleidea/puppet-yum',
    revision => 'a5dfa1d0746341d03d0ec1f56173eca96ec0edf2',
    require  => Package['git'],
}

exec { 'run base1.sh':
  command => '/vagrant/puppet/scripts/base1.sh',
  user    => 'root',
  cwd     => '/home/vagrant',
  path    => $::path,
  timeout => 0,
}

