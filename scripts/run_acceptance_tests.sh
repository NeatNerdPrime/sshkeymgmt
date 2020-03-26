#!/bin/bash

# install all needed gems locally
pdk bundle install

# fire up two docker containers
# bundle exec rake 'litmus:provision[docker, centos:7]'
# bundle exec rake 'litmus:provision[docker, ubuntu:18.04]'
pdk bundle exec rake 'litmus:provision_list[docker]'

# install Puppet agent
pdk bundle exec rake litmus:install_agent

# show agent versions
pdk bundle exec bolt command run 'puppet --version' -t all -i inventory.yaml

# create symlink for puppet in vagrant environments
# pdk bundle exec bolt command run 'ln -s /opt/puppetlabs/puppet/bin/puppet /usr/local/bin/puppet' --run-as root -i inventory.yaml --targets ssh_nodes

# install Puppet module to test
pdk bundle exec rake litmus:install_module

# show installed modules
pdk bundle exec bolt command run 'puppet module list' -t all -i inventory.yaml

# run tests in parallel with less output
pdk bundle exec rake litmus:acceptance:parallel

# run tests with more output
#TARGET_HOST=localhost:2222 pdk bundle exec rspec ./spec/acceptance --format d
#TARGET_HOST=localhost:2223 pdk bundle exec rspec ./spec/acceptance --format d

# tear down the test environment
pdk bundle exec rake litmus:tear_down

exit 0