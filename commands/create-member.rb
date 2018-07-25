require 'digest/md5'
require 'yaml'

# https://ja.gravatar.com/site/implement/images/ruby/
def calc_gravatar_hash(email_address)
  return Digest::MD5.hexdigest(email_address.downcase)
end

usage 'create matsuerb members NAME [options]'
aliases :cmm
summary 'create new Matsue.rb member profile'
description <<EOS
This command add member to resources/members.yml.
You can modify generated file if you want.
EOS

flag(:h, :help, 'show help for this command') do |value, cmd|
  puts(cmd.help)
  exit(0)
end

option(:g, :github, 'specify GitHub ID', :argument => :optional)
option(:t, :twitter, 'specify twitter ID', :argument => :optional)
option(:u, :websiteurl, 'specify Web Site URL', :argument => :optional)
option(:e, :email, 'specify Gravatar email address', :argument => :optional)

run do |opts, args, cmd|
  member = {
    name: args[0],
    github: opts[:github] || "",
    twitter: opts[:twitter] || "",
    website: opts[:websiteurl] || "",
    profile: "",
    gravatar_hash: opts[:email] ? calc_gravatar_hash(opts[:email]) : "",
    public: true,
  }

  path = "resources/members.yml"
  members = YAML.load(File.read(path)).push(member)
  File.open(path, "w") do |f|
    f.write(members.to_yaml)
  end
  puts "update #{path}, please edit your profile"
end
