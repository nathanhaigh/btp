class tools::bowtie (
  $version  = 'latest',
  $toolname = "bowtie"
) {
  include tools

  # set the default version for this tool and default to it, unless a
  # particular version is explicity requested
  $latest_version  = '0.12.8'
  $version_requested = $version ? {
    'latest' => $latest_version,
    default  => $version,
  }

  # now configure any known version-specific variables for this tool
  case $version_requested {
    default: {
      $toolname_version = "${toolname}-${version_requested}"
      $url = "http://downloads.sourceforge.net/project/bowtie-bio/bowtie/${version_requested}/bowtie-${version_requested}-linux-x86_64.zip"
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



