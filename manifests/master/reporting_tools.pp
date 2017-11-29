# Create a few scripts useful for working with reports. These are
# primarily used for the Practitioner course at this point.
class classroom_legacy::master::reporting_tools {
  assert_private('This class should not be called directly')

  File {
    owner => 'root',
    group => 'root',
    mode  => '0777',
  }

  file { '/usr/local/bin/get_environment_version.sh':
    ensure => file,
    source => 'puppet:///modules/classroom/get_environment_version.sh',
  }

}
