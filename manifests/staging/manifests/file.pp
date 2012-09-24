# Define: staging::file
#
#   Define resource to retrieve files to staging directories. It is
#   intententionally not replacing files, as these intend to be large binaries
#   that are versioned.
#
# Parameters:
#
#   * source: the source file location, supports local files, puppet://,
#   http://, https://, ftp://.
#   * target: the target staging directory, if unspecified
#   ${staging::path}/${caller_module_name}.
#   * username: https or ftp username.
#   * certificate: https certificate file.
#   * password: https or ftp user password or https certificate password.
#   * environment: environment variable for settings such as http_proxy,
#   https_proxy, of ftp_proxy.
#   * timeout: the the time to wait for the file transfer to complete
#
# Usage:
#
#   staging::file { 'apache-tomcat-6.0.35':
#     source => 'http://apache.cs.utah.edu/tomcat/tomcat-6/v6.0.35/bin/apache-tomcat-6.0.35.tar.gz',
#   }
#
#   If you specify a different staging location, please manage the file
#   resource as necessary.
#
define staging::file (
  $source,			# the URI
  $staging_dir = undef,		# which dir to put the downloaded file in
  $username    = undef,
  $certificate = undef,
  $password    = undef,
  $environment = undef,
  $timeout     = undef,
  # allowing pass through of real caller.
  $subdir      = $caller_module_name
) {

  include staging
  
  if ! $staging_dir {
    $staging_directory = $staging::path
  } else {
    $staging_directory = $staging_dir
  }

  $filename = basename($source)
  $target_file = "$staging_directory/$filename"

  Exec {
    path        => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ],
    environment => $environment,
    #cwd         => $staging_directory,
    creates     => $target_file,
    timeout     => $timeout,
  }

  case $source {
    /^\//: {
      file { $target_file:
        source  => $source,
        replace => false,
      }
    }

    /^puppet:\/\//: {
      file { $target_file:
        source  => $source,
        replace => false,
      }
    }

    /^http:\/\//: {
      exec { "http $target_file":
        command     => "curl -L --create-dirs -o ${target_file} ${source}",
      }
    }

    /^https:\/\//: {
      if $username {
        $command = "curl -L --create-dirs -o ${target_file} -u ${username}:${password} ${source}"
      } elsif $certificate {
        $command = "curl -L --create-dirs -o ${target_file} -E ${certificate}:${password} ${source}"
      } else {
        $command = "curl -L --create-dirs -o ${target_file} ${source}"
      }

      exec { "https $target_file":
        command     => $command,
      }
    }

    /^ftp:\/\//: {
      if $username {
        $command = "curl --create-dirs -o ${target_file} -u ${username}:${password} ${source}"
      } else {
        $command = "curl --create-dirs -o ${target_file} ${source}"
      }

      exec { "ftp $target_file":
        command     => $command,
      }
    }

    default: {
      fail("stage::file: do not recognize source ${source}.")
    }
  }

}
