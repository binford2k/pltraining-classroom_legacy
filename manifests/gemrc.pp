class classroom_legacy::gemrc (
  Boolean $offline = false,
) {
  # NOTE: this online version of the .gemrc should match the one in pltraining-bootstrap

  if $::osfamily == 'windows' {
    file { ['C:/Users/Administrator/.gemrc', 'C:/ProgramData/PuppetLabs/puppet/etc/.gemrc' ]:
      ensure  => file,
      owner   => 'Administrator',
      group   => 'Administrators',
      mode    => '0644',
      content => epp('classroom_legacy/gemrc.epp', { offline => $offline }),
    }
  }
  else {
    file { '/opt/puppetlabs/puppet/etc':
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0755',
    }

    file { ['/root/.gemrc', '/.gemrc', '/etc/gemrc', '/opt/puppetlabs/puppet/etc/gemrc']:
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp('classroom_legacy/gemrc.epp', { offline => $offline }),
    }
  }

  # This is a bit dirty...
  File <| tag == 'classroom_legacy::gemrc' |> -> Package<| provider == 'gem' |>
  File <| tag == 'classroom_legacy::gemrc' |> -> Package<| provider == 'puppet_gem' |>
  File <| tag == 'classroom_legacy::gemrc' |> -> Package<| provider == 'puppetserver_gem' |>
}
