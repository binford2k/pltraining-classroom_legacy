# Set a DNS server on the windows agents
define classroom_legacy::windows::dns_server (
  $ip = '8.8.8.8',
) {
    # Only run on windows
    if $::osfamily  == 'windows' {
      exec { 'set_dns':
        command  => "set-DnsClientServerAddress -interfacealias Ethernet0* -serveraddresses ${ip}",
        unless   => "if ((Get-DnsClientServerAddress -addressfamily ipv4 -interfacealias Ethernet0*).serveraddresses -ne '${ip}'){exit 1} else {exit 0}",
        provider => powershell,
      }
    }
}
