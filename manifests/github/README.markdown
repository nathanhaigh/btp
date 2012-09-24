puppet-github
=============

Requires
--------

 * *curl*-Package (retrieved automaticly)

Quickstart
----------

Install puppet-github to your modules (when you use git, it's easiest to
*git submodule add git://github.com/rynr/puppet-github.git modules/github*).

Now you can use this for your manifest:

    github::tarball { '/tmp/puppet.tgz':
      user     => 'puppetlabs',
      project  => 'puppet',
      branch   => '3.x',
    }

Branch is not required, *master* will be fetched, if not given.

License
-------

    puppet-github  Copyright (C) 2012  Rainer Jung
    This program comes with ABSOLUTELY NO WARRANTY; This is free software,
    and you are welcome to redistribute it under certain conditions;
    For details see LICENSE-file bundled with this file.
