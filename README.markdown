[![Build
Status](https://travis-ci.org/code-management/errbot.svg?branch=master)](https://travis-ci.org/code-management/errbot)

** There be dragons. **
This module is still under active development, and to be considered incomplete at this time. 
It's entirely possible that it might steal your car and sell it to the mafia.

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Usage](#usage)
4. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Dependencies](#dependencies)
7. [Contributors](#contributors)

## Overview

Puppet module to deploy and manage an [errbot](https://github.com/errbotio/errbot/) instance.

## Module Description



## Usage

```
    class { 'errbot':
        backend    => 'slack',
        bot_name   => 'mybot',
        bot_admins => ['@scary_admin'],
        bot_credentials => {
            token => 'xosbb--dummy_token123456',   
        }
    }
```

## Reference

### Classes

#### Public Classes


##### Parameters
The following parameters are available in `errbot`:


#### Private Classes

#### Types


## Limitations
* Cannot currently managing errbot plugins
* Deploys errbot using Python2, rather than Python3
* Not all configuration options of config.py are natively supported, though most could be hacked in,
using $config_hash

## Dependencies
`errbot` module depends on the following

* [puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)
* [puppet-python](https://github.com/stankevich/puppet-python)

## Contributors

List of contributors can be found at: [https://github.com/code-management/errbot/graphs/contributors](https://github.com/code-management/errbot/graphs/contributors)

This project is under the [Apache v2 License](https://github.com/code-management/errbot/blob/master/LICENSE).
