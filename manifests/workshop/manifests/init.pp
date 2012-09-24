class workshop ( $dir = '/mnt/workshop' ) {
  exec { 'mkdir_workshop_dir':
    path    => [ '/bin', '/usr/bin' ],
    command => "mkdir -p $dir",
    unless  => "test -d $dir",
  }
  package { 'curl':
    ensure => installed,
  }
  
  define download_file ($url, $out_file) {
    # only download the file(s) if their modification time has changed
    exec { "get_${url}":
      path    => [ '/bin', '/usr/bin' ],
      command => "curl --remote-time $url -o $out_file",
      require => Package['curl'],
      subscribe => File[$out_file],
      refreshonly => true,
    }
    file { "$out_file":
      checksum => mtime,
      ensure => present,
    }
  }
}

