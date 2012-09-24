class tools::samtools (
  $version  = 'latest',
  $toolname = "samtools"
) {
  include tools

  # set the default version for this tool and default to it, unless a
  # particular version is explicity requested
  $latest_version  = '0.1.18'
  $version_requested = $version ? {
    'latest' => $latest_version,
    default  => $version,
  }

  # now configure any known version-specific variables for this tool
  case $version_requested {
    default: {
      $url = "http://downloads.sourceforge.net/project/samtools/samtools/${version_requested}/samtools-${version_requested}.tar.bz2"
      $extracted_dir = gsub(basename($url), '.(zip|tgz|tar.gz|tar.bz2)', "")
      $toolname_version = "${toolname}-${version_requested}"
    }
  }

  package { [ 'zlib1g-dev', 'libncurses5-dev' ]:
    ensure => installed,
    before => Staging::Build_install[$toolname_version],
  }

  # TODO: there is no install target for the Makefile
  # Need to move samtools, bcftools/{bcftools,vcfutils.pl} and misc/{executables} to the install directory
  staging::build_install { $toolname_version:
    source      => "$url",
    staging_dir => "${tools::staging_dir}/${toolname}",
    target      => "${tools::target_dir}/${toolname}",
    creates     => "${tools::target_dir}/${toolname}/$extracted_dir",
  }
  
}

