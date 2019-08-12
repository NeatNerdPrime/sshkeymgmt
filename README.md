# sshkeymgmt

#### Table of Contents

1. [Module description](#module-description)
2. [Setup - The basics of getting started with sshkeymgmt](#setup)
    * [What sshkeymgmt affects](#what-sshkeymgmt-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with sshkeymgmt](#beginning-with-sshkeymgmt)
3. [Usage](#usage)
4. [Reference](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)
7. [Changelog](#changelog)
8. [Contributors](#contributors)

##  Module description

Sshkeymgmt module is for managing Unix groups and Unix users together with their ssh keys. The module is focused on deploying users in groups. Groups e. g. can be departemens or teams (system administrators) within your organisation. As a group can consist of one member as well the module is not limited to deply users and ssh keys in groups.

Users used in ssh key groups which are not defined are simly ignored. A notification is printed to inform about that.

## Setup

### What sshkeymgmt affects

Sshkeymgmt adds, modifies or deleted Unix users and Unix groups on your systems. As it is run with super user privileges it can affect any user on your systems.

### Setup Requirements

sshkeymgmt needs puppetlab stdlib and puppetlab concat to work.

### Beginning with sshkeymgmt

The most basic set-up you could achieve with this module looks something like this:

```puppet
include '::sshkeymgmt'
```
or
```puppet
class { '::sshkeymgmt': }
```
If there are no Unix users, no Unix groups and no ssh key groups the module will print a notification only.

## Usage

Configuration for the class can be done either by Hiera oder by writing the configuration directly into the class statement.

### Example Hiera data

Configuration of Users, groups and ssh key groups can be distributed into different Hiera files. You can e. g. have all Unix user and group definitions in your most common Hiera file. The ssh groups ou define in the most particular Hiera file describing the node. Using Hiera reduces codeing effort for class usage to
```puppet
include '::sshkeymgmt'
````
or
```puppet
class { 'sshkeymgmt': }
```

#### common.yaml

```puppet
---
sshkeymgmt::groups:
  test1:
    gid: 5001
    ensure: present
  test2:
    gid: 5002
    ensure: present
  test3:
    gid: 5003
    ensure: present

sshkeymgmt::users:
  test1:
    ensure: present
    gid: 5001
    uid: 5001
    homedir: '/home/test1'
    sshkeys:
      - ssh-rsa AAAA ... Test1
      - ssh-rsa AAAA ... Tom
  test2:
    ensure: present
    gid: 5002
    uid: 5002
    homedir: '/home/test2'
    sshkeys:
      - ssh-rsa AAAA ... Test2
  test3:
    ensure: present
    gid: 5002
    uid: 5003
    homedir: '/home/test3'
    sshkeys:
      - ssh-rsa AAAA ...Test3
  test4:
    ensure: present
    gid: 5004
    uid: 5004
    homedir: '/home/test4'
    sshkeys:
      - ssh-rsa AAAA ... Test4
```

#### node1.yaml

```puppet
---
sshkeymgmt::ssh_key_groups:
  ssh1:
    ssh_users:
      - test1
      - test2
  test3:
    ssh_users:
      - test3
      - test2
```

### Class usage

```puppet
$groups = {
  'test1' => {
    gid => 5001,
    ensure => present
  }
}

$users = {
  'test1' => {
    ensure => present,
    gid => 5001,
    uid => 5001,
    homedir => '/home/test1',
    sshkeys => ['ssh-rsa AAAA ... Test1', 'ssh-rsa AAAA ... Tom']
  }
}

$sshkeygroups = {
  'ssh1: => {
    'ssh_users' => ['test1', 'test2']
  }  
}

class { '::sshkeymgmt':
  users => $users,
  groups => $groups,
  ssh_key_groups => $sshkeygroups
} 
```

## Reference

See [REFERENCE.md](https://git.home.tom-krieger.de/puppet-modules/sshkeymgmt/REFERENCE.md)

## Limitations

This module has been tested on several Unix platforms, and no issues have been identified.

For an extensive list of supported operating systems, see [metadata.json[(https://git.home.tom-krieger.de/puppet-modules/sshkeymgmt/metadata.json)]

## Development

Contributions are welcome in any form, pull requests, and issues should be filed via GitHub.

## Changelog

See [CHANGELOG.md](https://git.home.tom-krieger.de/puppet-modules/sshkeymgmt/CHANGELOG.md)

## Contributors