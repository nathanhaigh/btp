
class github {

  package { 'curl':
    ensure => installed,
  }

}

define github::tarball($user, $project, $branch = 'master', $file = $title) {
  include github

  exec { "curl-$title":
    command => "curl -L -o '$file' 'http://github.com/$user/$project/tarball/$branch'",
    unless  => "test -s '$file'",
    path    => '/usr/bin:/usr/sbin',
    require => Class['github'],
  }
}

define github::zipball($user, $project, $branch = 'master', $file = $title) {
  include github

  exec { "curl-$title":
    command => "curl -L -o '$file' 'http://github.com/$user/$project/zipball/$branch'",
    unless  => "test -s '$file'",
    path    => '/usr/bin:/usr/sbin',
    require => Class['github'],
  }
}

