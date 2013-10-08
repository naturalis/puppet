# Redis Module

[![Build Status](https://travis-ci.org/jbussdieker/puppet-redis.png?branch=master)](https://travis-ci.org/jbussdieker/puppet-redis)

This module manages installing, configuring and running redis.

# Usage

    class {'redis':
      port => 6379,
    }
