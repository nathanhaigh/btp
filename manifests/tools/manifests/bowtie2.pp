class tools::bowtie2 (
  $version  = 'latest',
  $toolname = "bowtie2"
) {
  include tools

  # set the default version for this tool and default to it, unless a
  # particular version is explicity requested
  $latest_version  = '2.0.0-beta7'
  $version_requested = $version ? {
    'latest' => $latest_version,
    default  => $version,
  }

  # now configure any known version-specific variables for this tool
  case $version_requested {
    default: {
      $toolname_version = "${toolname}-${version_requested}"
      $url = "http://downloads.sourceforge.net/project/bowtie-bio/bowtie2/${version_requested}/bowtie2-${version_requested}-linux-x86_64.zip"
      $extracted_dir = $toolname_version
    }
  }

  staging::deploy { $toolname_version:
    source      => "$url",
    staging_dir => "${tools::staging_dir}/${toolname}",
    target_dir  => "${tools::target_dir}/${toolname}",
    creates     => "${tools::target_dir}/${toolname}/$extracted_dir",
  }
}

