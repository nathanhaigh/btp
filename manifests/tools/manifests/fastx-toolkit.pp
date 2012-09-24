class tools::fastx-toolkit (
  $version  = 'latest',
  $toolname = "fastx-toolkit"
) {
  include tools

  # set the default version for this tool and default to it, unless a
  # particular version is explicity requested
  $latest_version  = '0.0.13.2'
  $version_requested = $version ? {
    'latest' => $latest_version,
    default  => $version,
  }

  # now configure any known version-specific variables for this tool
  case $version_requested {
    default: {
      $url = "http://hannonlab.cshl.edu/fastx_toolkit/fastx_toolkit-${version_requested}.tar.bz2"
      $extracted_dir = gsub(basename($url), '.(zip|tgz|tar.gz|tar.bz2)', "")
      $toolname_version = "${toolname}-${version_requested}"
    }
  }

  # this class is required and is required before with build the current class
  class { 'tools::libgtextutils': version => 'latest' }
  Class['tools::libgtextutils'] -> Staging::Build_install[$toolname_version]

  staging::build_install { $toolname_version:
    source      => "$url",
    staging_dir => "${tools::staging_dir}/${toolname}",
    target      => "${tools::target_dir}/${toolname}",
    creates     => "${tools::target_dir}/${toolname}/$extracted_dir",
    config_args => "PKG_CONFIG_PATH=${tools::target_dir}/${tools::libgtextutils::toolname}/${tools::libgtextutils::extracted_dir}/lib/pkgconfig"
  }
}

