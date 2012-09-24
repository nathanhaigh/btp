class tools::fastqc (
  $version  = '0.10.1',
  $toolname = "fastqc"
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
      $url = "http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v${version_requested}.zip"
      $extracted_dir = "FastQC"
    }
  }

  staging::deploy { $toolname_version:
    source      => "$url",
    staging_dir => "${tools::staging_dir}/${toolname}",
    target_dir  => "${tools::target_dir}/${toolname}",
    creates     => "${tools::target_dir}/${toolname}/$extracted_dir",
  }
  
  # things that will need to be installed in order to run the software
  package { 'default-jre':
    ensure => installed,
  }

  # post install changes
  file { "${tools::target_dir}/${toolname}/$extracted_dir/fastqc":
    mode => 755,
  }
}
