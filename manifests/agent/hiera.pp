# Make sure that Hiera is configured for agent nodes so that we
# can work through the hiera sections without teaching them
# how to configure it.
class classroom_legacy::agent::hiera (
  $codedir = $classroom_legacy::params::codedir,
  $confdir = $classroom_legacy::params::confdir,
  $workdir = $classroom_legacy::params::workdir,
) inherits classroom_legacy::params {
  assert_private('This class should not be called directly')

  # Set defaults depending on os
  case $::osfamily {
    'windows' : {
      File {
        owner => 'Administrator',
        group => 'Users',
      }
    }
    default   : {
      File {
        owner => 'pe-puppet',
        group => 'pe-puppet',
        mode  => '0644',
      }
    }
  }

  $hieradata = "${codedir}/hieradata"

  if $classroom_legacy::manage_repos {
    file { $hieradata:
      ensure => link,
      # the hieradata dir is empty so forcing to
      # replace directory with symlink on Win 2012
      force  => true,
      target => "${workdir}/hieradata",
    }

    file { "${confdir}/hiera.yaml":
      ensure => link,
      target => "${workdir}/hiera.yaml",
      force  => true,
    }

    file { "${confdir}/hieradata":
      ensure => link,
      target => "${workdir}/hieradata",
      force  => true,
    }

    file { "${workdir}/hiera.yaml":
      ensure  => file,
      source  => 'puppet:///modules/classroom/hiera/hiera.agent.yaml',
      replace => false,
    }

  }
  else {
    file { $hieradata:
      ensure => directory,
    }

    # Because PE writes a default, we have to do tricks to see if we've already managed this.
    unless defined('$puppetlabs_class') {
      file { "${confdir}/hiera.yaml":
        ensure  => file,
        source  => 'puppet:///modules/classroom/hiera/hiera.agent.yaml',
      }
    }
  }

  unless $::osfamily == 'windows' {
    file { '/usr/local/bin/hiera_explain.rb':
      ensure => file,
      owner  => 'root',
      group  => 'root',
      mode   => '0777',
      source => 'puppet:///modules/classroom/hiera_explain.rb',
    }
  }

  file { "${hieradata}/common.yaml":
    ensure  => file,
    source  => 'puppet:///modules/classroom/hiera/data/common.yaml',
    replace => false,
  }
}
