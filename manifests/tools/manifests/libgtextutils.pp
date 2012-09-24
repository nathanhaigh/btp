class tools::libgtextutils (
  $version  = 'latest',
  $toolname = "libgtextutils"
) {
  include tools

  # set the default version for this tool and default to it, unless a
  # particular version is explicity requested
  $latest_version  = '0.6.2'
  $version_requested = $version ? {
    'latest' => $latest_version,
    default  => $version,
  }

  # now configure any known version-specific variables for this tool
  case $version_requested {
    default: {
      $url = "http://hannonlab.cshl.edu/fastx_toolkit/libgtextutils-${version_requested}.tar.bz2"
      $extracted_dir = gsub(basename($url), '.(zip|tgz|tar.gz|tar.bz2)', "")
      $toolname_version = "${toolname}-${version_requested}"
    }
  }
  
  staging::build_install { "${toolname}-${version_requested}":
    source      => "$url",
    staging_dir => "${tools::staging_dir}/${toolname}",
    target      => "${tools::target_dir}/${toolname}",
    #creates     => "${tools::target_dir}/${toolname}/$extracted_dir",
  }
}

