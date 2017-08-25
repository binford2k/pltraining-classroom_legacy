# This is a wrapper class to include all the bits needed for Puppetizing infrastructure
class classroom::course::puppetize (
  $control_owner      = $classroom::params::control_owner,
  $offline            = $classroom::params::offline,
  $session_id         = $classroom::params::session_id,
  $jvm_tuning_profile = $classroom::params::jvm_tuning_profile,
  $use_gitea          = $classroom::params::use_gitea,
) inherits classroom::params {
  class { 'classroom::virtual':
    offline            => $offline,
    jvm_tuning_profile => $jvm_tuning_profile,
  }

  if $::fqdn == 'master.puppetlabs.vm' {
    # Classroom Master
    File {
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

    include classroom::master::dependencies::dashboard
    include classroom::master::hiera

    $base_plugin_list = [ "Certificates", "Classification", "ConsoleUser", "Docker", "Logs", "Dashboard", "CodeManager", "ShellUser", "Gitviz" ]

    if $use_gitea {
      $plugin_list = flatten([$base_plugin_list, "Gitea" ])
    } else {
      $plugin_list = $base_plugin_list
    }

    class { 'puppetfactory':
      plugins          => $plugin_list,
      controlrepo      => 'classroom-control-pi.git',
      repomodel        => 'single',
      usersuffix       => $classroom::params::usersuffix,
      session          => $session_id,
      privileged       => false,
    }

    file { '/usr/local/bin/validate_classification.rb':
      ensure => file,
      mode   => '0755',
      source => 'puppet:///modules/classroom/validation/puppetize.rb',
    }

    class { 'classroom::master::codemanager':
      control_owner => $control_owner,
      control_repo  => 'classroom-control-pi.git',
      use_gitea     => $use_gitea,
    }

  }

  # All nodes
  include classroom::agent::git
  class { 'classroom::facts':
    coursename => 'puppetizing',
  }

}
