# Installs puppet development tools, clone git repository and git commit scripts
class { 'stdlib': }
class { 'git': }
class { 'puppetdev': }
