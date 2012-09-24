# Define: staging::build_install
#
#   Define resource to retrieve compressed files, build and install to target directories.
#
# Parameters:
#
#   * source: the source file location, supports local files, puppet://,
#   http://, https://, ftp://
#   * target: the target extraction directory.
#   * staging_path: the staging location for compressed file. defaults to
#   ${staging::path}/${caller_module_name}.
#   * username: https or ftp username.
#   * certificate: https certificate file.
#   * password: https or ftp user password or https certificate password.
#   * environment: environment variable for settings such as http_proxy,
#   https_proxy, of ftp_proxy.
#   * timeout: the the time to wait for the file transfer to complete
#   * user: extract file as this user.
#   * group: extract file as this group.
#   * creates: the file created after extraction. if unspecified defaults to
#   ${target}/${name}.
#   * unless: alternative way to conditionally check whether to extract file.
#   * onlyif: alternative way to conditionally check whether to extract file.
#
# Usage:
#
#   staging::build_install { 'jboss-5.1.0.GA.zip':
#     source => 'http://sourceforge.net/projects/jboss/files/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip',
#     target => '/usr/local',
#   }
#
define staging::build_install (
  $source,
  $staging_dir,
  $target,
  # staging file settings:
  $username     = undef,
  $certificate  = undef,
  $password     = undef,
  $environment  = undef,
  $timeout      = undef,
  # staging extract settings:
  $user         = undef,
  $group        = undef,
  $creates      = undef,
  $unless       = undef,
  $onlyif       = undef,
  # configuration options
  $config_args  = undef
){
  include staging

  $filename = basename($source)
  $extracted_dir = gsub($filename, '.(zip|tgz|tar.gz|tar.bz2)', "")

  staging::file { $name:
    source      => $source,		# the URI to fetch
    staging_dir => $staging_dir,	# the target staging directory
    username    => $username,
    certificate => $certificate,
    password    => $password,
    environment => $environment,
    subdir      => $caller_module_name,
    timeout     => $timeout,
  }

  staging::extract { $name:
    target_dir  => $staging_dir,		# the target extraction directory
    source      => "$staging_dir/$filename",	# the source compression file
    user        => $user,
    group       => $group,
    environment => $environment,
    subdir      => $caller_module_name,
    creates     => $creates,
    unless      => $unless,
    onlyif      => $onlyif,
    require     => Staging::File[$name],
  }

  #file { "$staging_dir/$extracted_dir/Makefile":
  #  ensure => file,
  #  before => Exec["make $name"],
  #}
  
  exec { "configure $name":
    path      => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "$staging_dir/$extracted_dir/" ],
    cwd       => "$staging_dir/$extracted_dir",
    command   => "$staging_dir/$extracted_dir/configure --prefix $target/$extracted_dir/ $config_args",
    require   => Staging::Extract[$name],
    #creates   => "$staging_dir/$extracted_dir/Makefile",
    #subscribe => File["$staging_dir/$extracted_dir/Makefile"],
    #refreshonly => true,
  }
  
  exec { "make $name":
    path      => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "$staging_dir/$extracted_dir/" ],
    cwd       => "$staging_dir/$extracted_dir",
    command => "make",
    #timeout => 600, # 10 minutes
    require => Exec["configure $name"],
    onlyif  => "test -e $staging_dir/$extracted_dir/Makefile",
  }

  exec { "install $name":
    path      => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/", "$staging_dir/$extracted_dir/" ],
    cwd       => "$staging_dir/$extracted_dir",
    command => "make install",
    #timeout => 600, # 10 minutes
    require => Exec["make $name"],
  }

}
