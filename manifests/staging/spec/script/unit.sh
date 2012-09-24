#!/bin/bash

set -e
set -u

puppet apply -e "
package { 'rubygems':
  ensure => present,
}
package { 'rake':
  ensure => present,
  provider => 'gem',
}
"
#/etc/puppet/modules/staging/tests/*.pp
