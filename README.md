Bioinformatics Training Platform
================================

In the first instance the Bioinformatics Training Platform (BTP) is designed to
run on Australia's NeCTAR Research Cloud.

The BTP is intended to be a platform that trainers, with Australian Access
Federation (AAF) credentials can launch and configure VMs, on the NeCTAR Research
Cloud, for a particular bioinformatics workshop.

At the heart of the BTP is a puppetmaster server hosting puppet manifests, files
which describe how a system should be configured. When we bring our training VMs
online we ask them to contact the puppetmaster which in turn tells the VMs how
to configure themselves.

With the BTP, we can perform these actions using automated scripts from our
local computer. We do this by interacting with NeCTAR Research Cloud computers
via OpenStack and EC2 APIs.

Puppetmaster Configuration
==========================

We start with an Ubuntu 12.04 LTS and install and configure the puppetmaster.
On the NeCTAR Research Cloud, this script can be entered into the "User Data".

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
    
    sudo apt-get update
    sudo apt-get --assume-yes upgrade
    wget http://apt.puppetlabs.com/puppetlabs-release-precise.deb
    sudo dpkg -i puppetlabs-release-precise.deb
    sudo apt-get --assume-yes install puppet
    
    sudo sh -c 'echo "$PUPPETMASTER_IP puppet" >> /etc/hosts'
   
    puppet agent ...
   
