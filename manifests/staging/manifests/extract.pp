# Define: staging::extract
#
#   Define resource to extract files from staging directories to target
#   directories.
#
# Parameters:
#
#   * target: the target extraction directory,
#   * source: the source compression file, supports tar, tar.gz, zip, war. if
#   unspecified defaults to ${staging::path}/${caller_module_name}/${name}
#   * creates: the file created after extraction. if unspecified defaults to
#   ${target_dir}/${name}.
#   * unless: alternative way to conditionally check whether to extract file.
#   * onlyif: alternative way to conditionally check whether to extract file.
#   * user: extract file as this user.
#   * group: extract file as this group.
#   * environments: environment variables.
#   * subdir: subdir per module in staging directory.
#
# Usage:
#
#   staging::extract { 'apache-tomcat-6.0.35':
#     target => '/opt',
#     owner  => 'tomcat',
#     group  => 'tomcat',
#   }
#
define staging::extract (
  $target_dir,
  $source,
  $creates     = undef,
  $unless      = undef,
  $onlyif      = undef,
  $user        = undef,
  $group       = undef,
  $environment = undef,
  # allowing pass through of real caller.
  $subdir      = $caller_module_name
) {

  include staging

  # Use user supplied creates path, set default value if creates, unless or
  # onlyif is not supplied.
  if $creates {
    $creates_path = $creates
  } else {
    $filename = basename($source)
    $extracted_dir = gsub($filename, '.(zip|tgz|tar.gz|tar.bz2)', "")
    $creates_path = "$target_dir/$extracted_dir"
  }

  # Work out the extract command to use for this filetype
  case $source {
    /.tar$/: {
      $command = "tar xf ${source}"
    }

    /(.tgz|.tar.gz)$/: {
      if $::osfamily == 'Solaris' {
        $command = "gunzip -dc < ${source} | tar xf - "
      } else {
        $command = "tar xzf ${source}"
      }
    }
    
    /.tar.bz2$/: {
      $command = "tar xjf ${source}"
    }

    /.zip$/: {
      $command = "unzip ${source}"
    }

    /.war$/: {
      $command = "jar xf ${source}"
    }

    default: {
      fail("staging::extract: unsupported file format ${source}.")
    }
  }
  
  file { $target_dir:
    ensure => directory,
    before => Exec["extract ${source}"],
  }
  
  exec { "extract ${source}":
    command => $command,
    #refreshonly => true,
    path        => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    cwd         => $target_dir,
    user        => $user,
    group       => $group,
    environment => $environment,
    creates     => $creates_path,
    unless      => $unless,
    onlyif      => $onlyif,
    logoutput   => on_failure,
  }
}
