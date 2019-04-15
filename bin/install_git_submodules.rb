require 'rubygems'
Gem.clear_paths

require 'parseconfig'

config = ParseConfig.new("#{ENV['BUILD_DIR']}/.gitmodules")

config.get_params.each do |param|
  next unless param.match(/^submodule/)
  c = config[param]
  # https://d0c7d529cec1c5693d13b3574f366b176c0cbddb@github.com/ashwinsingh2007/herokuchild.git
  url = c[url];
  url = url.split('://', 1);
  puts url
  url = ` #{url[0]}d0c7d529cec1c5693d13b3574f366b176c0cbddb#{url[1]}`
  puts url

  puts "-----> Installing submodule #{c["path"]} #{c["branch"]}"
  branch_flag = c["branch"] ? "-b #{c['branch']}" : ""
  build_path = "#{ENV['BUILD_DIR']}/#{c["path"]}"
  `git clone -q --single-branch #{c["url"]} #{branch_flag} #{build_path}`
  if c.key?("revision")
    puts "       Setting submodule revision to #{c["revision"]}"
    Dir.chdir(build_path) do
      `git reset --hard #{c["revision"]}`
    end
  end

  puts "       Removing submodule git folder"
  `rm -rf #{ENV['BUILD_DIR']}/#{c["path"]}/.git`
end
