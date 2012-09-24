#!/bin/bash
#NAME="<%= tool_name %>"
#VERSION="<%= version %>"
#UNPACKED_DIR="<%= unpacked_dir %>"
#INSTALL_DIR="/usr/local/bioinf/<%= tool_name %>"

mkdir -p /usr/local/bioinf/<%= scope.lookupvar('tool_name') %>
cp -R <%= scope.lookupvar('unpacked_dir') %> /usr/local/bioinf/<%= scope.lookupvar('tool_name') %>/<%= scope.lookupvar('tool_name') %>-<%= scope.lookupvar('version') %>
#chmod +x /usr/local/bioinf/<%= tool_name %>/<%= tool_name %>-<%= version %>/<%= tool_name %>

#ln -s /usr/local/bioinf/<%= tool_name %>/<%= tool_name %>-<%= version %> /usr/local/bioinf/<%= tool_name %>/<%= tool_name %>
#ln -s /usr/local/bioinf/<%= tool_name %>/<%= tool_name %>-<%= version %>/<%= tool_name %> /usr/local/bin/
