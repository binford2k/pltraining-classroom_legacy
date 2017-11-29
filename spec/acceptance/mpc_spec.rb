require 'spec_helper_acceptance'

describe 'mpc' do
    before(:all) do
      sleep_until_puppetserver_started(master)
      on master, "echo 'node default { include classroom_legacy::course::virtual::code_management }' > /etc/puppetlabs/code/environments/production/manifests/site.pp"
    end


    it 'runs with changes' do
      on master, "puppet agent -t", :acceptable_exit_codes => [2]
    end

    it 'runs idempotently' do
      on master, "puppet agent -t", :acceptable_exit_codes => [0]
    end

end
