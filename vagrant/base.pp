# the default path for puppet to look for executables
Exec { path => [ '/bin', '/sbin' , '/usr/bin', '/usr/sbin', '/usr/local/bin' ] }

stage { 'first': }

stage { 'last': }

Stage['first'] -> Stage['main'] -> Stage['last']

# Run basic bootstrap commands before setting up VM:
class base {
  exec {'apt-get update && touch /tmp/apt-get-updated':
    unless => 'test -e /tmp/apt-get-updated'
  }
  file {'/vagrant/vagrant/solr_test':
    ensure => 'directory',
  }
}

# run apt-get update before anything else runs
class { 'base':
  stage => first,
}


# default use case
# include solr

# With all options
class { 'solr':
  mirror  => 'http://apache.belnet.be/lucene/solr',
  version => '4.10.4',
  cores   => {
    'development'=> {},
    'staging'    => {},
    'production' => {

      'config_type'   => 'link',
      'config_source' => '/vagrant/vagrant/solr_test',
    },
  }
}
