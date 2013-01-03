Bioinformatics Training Platform
================================

In the first instance the Bioinformatics Training Platform (BTP) is designed to
run on Australia's NeCTAR Research Cloud.

The BTP is intended to be a platform that trainers, with Australian Access
Federation (AAF) credentials can launch and configure VMs, on the NeCTAR Research
Cloud, for a particular bioinformatics workshop.

The original OS used as the basis for the BTP was a large, monolithic, customised
build of Cloud BioLinux (CBL). The script used to build this OS is available in
```build_OS.sh```. The OS contained many different bioinformatic tools that were
never used by the workshops being run and thus occupied much space and took time
to build. As a result we are looking at using puppet manifests to "describe" the
configuration of an OS for use in a workshop. These files are plain text, thus
easily version controlled, and can be shipped alongside workshop content.
Therefore, any particular workshop can describe the OS configuration as well as
the data and content it uses.  

At the heart of the BTP is a puppetmaster server hosting puppet manifests, files
which describe how a system should be configured. When we bring our training VMs
online we ask them to contact the puppetmaster which in turn tells the VMs how
to configure themselves.

With the BTP, we can perform these actions using automated scripts, from our
local computer, using via OpenStack and EC2 APIs.

Puppetmaster Configuration
==========================

We start with an Ubuntu 12.04 LTS and install and configure the puppetmaster.
On the NeCTAR Research Cloud, this script can be entered into the ```User Data```.

    #!/bin/bash
    apt-get update
    apt-get --assume-yes upgrade
    wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    dpkg -i puppetlabs-release-precise.deb
    apt-get --assume-yes install puppetmaster git
    
    # Ask puppetmaster to autosign client certificates
    sh -c 'echo "*" >> /etc/puppet/autosign.conf'
    
    # Install the BTP puppet modules
    cd /etc/puppet/modules
    git clone https://github.com/nathanhaigh/puppet_bioinf_tools.git  

Puppet Agent Configuration
==========================

A puppet agent is a VM which is configured to contact a puppetmaster for
instructions on how to configure itself. This configuration could be done by
passing a bash script in the ```user data``` or by launching a VM that has
already been configured.

    #!/bin/bash
    PUPPETMASTER_IP="xxx.xxx.xx.xx"
    
    apt-get update
    apt-get --assume-yes upgrade
    wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    dpkg -i puppetlabs-release-precise.deb
    apt-get --assume-yes install puppet
    
    sh -c 'echo "$PUPPETMASTER_IP puppet" >> /etc/hosts'
   
    puppet agent ...
   
