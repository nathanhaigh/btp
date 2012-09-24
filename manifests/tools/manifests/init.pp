class tools(
  $staging_dir = '/usr/local/src',
  $target_dir = '/usr/local/bioinf',
) {
  #include staging
  #Staging {
  #  path
  # define a new "stage" that will be run before the "main" stage.
  # This is intended for tool prerequisits to be defined so they are installed first.
  #stage { "prebuild": before => Stage[main] }

  #file { $staging_dir:
  #  ensure => directory,
  #}
  #file { $target_dir:
  #  ensure => directory,
  #}
  
}

