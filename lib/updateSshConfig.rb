require "updateSshConfig/version"
require 'aws-sdk'

class MySSH
  def initialize()

    AWS.config({:access_key_id => 'HOGE',
                :secret_access_key => 'FOO'})
    ec2 = AWS::EC2.new(:ec2_endpoint => 'FUGA')

    api_data = []
    ec2.instances.each do |instance|
      tags = instance.tags.to_h
      next unless instance.status == :running
      next unless tags["type"] == ""
      api_data << "#{instance.public_dns_name}\t#{tags["Name"]}"
    end

    @api_data = api_data
    @params = 10
    @hash = {}
  end

  def read
    open("#{ENV['HOME']}/.ssh/config", "r") do |file|
      arr = file.read.split(" ")
      arr.each_slice(@params) {|e| @hash[e[1]] = Hash[*e]}
    end

    @api_data.each do |value|

      arr = value.split(/\t/)

				if @hash.key?(arr[-1]) then
        @hash[arr.pop]["HostName"] = arr.shift
      else
        addConfigData = {"Host"=> arr[-1], "HostName"=>arr.shift, "Port"=>"22","User"=>"ec2-user","IdentityFile"=>""}
        @hash["#{arr.pop}"] = addConfigData
      end

    end
    return @hash
  end

  def write(hash)

    `cp -p ~/.ssh/config ~/.ssh/config.bak`
    File.open("#{ENV['HOME']}/.ssh/config.new", 'w') do |file|
      hash.each_value do |v_hash|
        v_hash.each do |key,value|
          file.write "#{key} #{value}\n"
        end
        file.write "\n"
      end
end
    is_same = system("diff -q ~/.ssh/config.new ~/.ssh/config > /dev/null 2>/dev/null")
    unless is_same
      `cp -p ~/.ssh/config.new ~/.ssh/config`
    end
  end

  def create
    write(read)
  end
end

myssh = MySSH.new()
myssh.create
