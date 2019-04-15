require 'rubygems'
Gem.clear_paths

require 'parseconfig'

config = ParseConfig.new("#{ENV['BUILD_DIR']}/.gitmodules")

config.get_params.each do |param|
  next unless param.match(/^submodule/)
  c = config[param]
  
 url = c["url"]
  puts url
  puts "checking 1111111111"
  url = url.gsub("https://", "https://0dac84dad55c26f2095448d5c0714560dae94a19@")
  puts "checking 2222222222"
  puts url   


  puts "-----> Installing submodule #{c["path"]} #{c["branch"]}"
  branch_flag = c["branch"] ? "-b #{c['branch']}" : ""
  build_path = "#{ENV['BUILD_DIR']}/#{c["path"]}"
  `git clone -q --single-branch #{url} #{branch_flag} #{build_path}`
  if c.key?("revision")
    puts "       Setting submodule revision to #{c["revision"]}"
    Dir.chdir(build_path) do
      `git reset --hard #{c["revision"]}`
    end
  end

  puts "       Removing submodule git folder"
  `rm -rf #{ENV['BUILD_DIR']}/#{c["path"]}/.git`
end
