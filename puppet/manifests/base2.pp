$deps = [ 'kernel-devel',
          'dhcp',
          'bind',
]

$hosts = hiera('hosts')
$dhcp = hiera('dhcp')

package { $deps:
    ensure   => installed,
}

file { '/etc/hosts':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('/vagrant/puppet/templates/hosts.erb'),
}

file { '/etc/sysconfig/iptables':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0600,
    content => template('/vagrant/puppet/templates/iptables.erb'),
}

file { '/etc/dhcp/dhcpd.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0644,
    content => template('/vagrant/puppet/templates/dhcpd.conf.erb'),
    require => Package['dhcp'],
}
exec { 'Enable dhcpd':
    command => '/sbin/service dhcpd start ; /sbin/chkconfig dhcpd on',
    path    => $::path,
    user    => 'root',
    require => [ Package['dhcp'], File['/etc/dhcp/dhcpd.conf'] ],
}

file { '/etc/named.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'named',
    mode    => 0640,
    content => template('/vagrant/puppet/templates/named.conf.erb'),
    require => Package['bind'],
}    
exec { 'Enable named':
    command => '/sbin/service named start ; /sbin/chkconfig named on',
    path    => $::path,
    user    => 'root',
    require => File['/etc/named.conf'],
}

file { '/etc/init.d/vboxadd-setuptrigger':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => 0755,
    content => template('/vagrant/puppet/templates/vboxadd-setuptrigger.erb'),
}
exec { 'Vbox Add Setup Trigger Service':
    command => '/sbin/chkconfig --add vboxadd-setuptrigger',
    cwd     => '/etc/init.d',
    path    => $::path,
    user    => 'root',
    require => File['/etc/init.d/vboxadd-setuptrigger'],
    onlyif  => ['/usr/bin/test -f /etc/init.d/vboxadd'],
}

exec { 'Yum Update':
    command => 'yum update -y',  
    cwd     => '/home/vagrant',
    path    => $::path,
    user    => 'root',
    require => Package[$deps],
    timeout => 0,
}

exec { 'Yum Development tools':
    command => 'yum groupinstall -y "Development Tools"',
    cwd     => '/home/vagrant',
    path    => $::path,
    user    => 'root',
    require  => Exec['Yum Update'],
    timeout => 0,
}

# http://puppetcookbook.com/posts/exec-onlyif.html
exec { 'VboxAdd Setup':
  command  => "/bin/touch vboxadd_setup_is_needed",
  cwd      => '/home/vagrant',
  path     => $::path,
  user     => 'vagrant',
  onlyif   => [ '/usr/bin/test -f /etc/init.d/vboxadd' ],
  require  => Exec['Yum Development tools'],
}
