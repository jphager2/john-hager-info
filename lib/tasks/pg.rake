require 'open-uri'
require 'rake'
require 'fileutils'

class PGUtils
  HEADERS = {
    'User-Agent' => 'Mozilla/5.0 (Windows NT 5.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/40.0.2214.111 Safari/537.36', 
    'Referer' => 'http://financial-advisors.credio.com'
  }
end

namespace :pg do

  task :list do
    puts `heroku pgbackups`
  end

  task :destroy, [:id] do |t, args|
    id    = args[:id]
    list  = `heroku pgbackups`
    match = list.split("\n").drop(2).any? do |line| 
      line.split("\s").first == id
    end
    if match
      puts `heroku pgbackups:destroy #{id}`
    else
      puts "There is no backup named: #{id}"
    end
  end

  task :backup do
    response = `heroku pgbackups:capture`
    if response.include?('delete a backup before creating a new one')
      puts response
      exit 1
    end
  end

  task :dump do
    backup_path = Rails.root.join('db', "latest-#{Time.now.to_i}.dump")
    backup_url  = `heroku pgbackups:url`
    file        = open(backup_url, PGUtils::HEADERS).read
    #response = `curl -o #{backup_path} #{backup_url}`
    #
    #latest = Dir[Rails.root.join('db').to_s + '/latest-*.dump'].last
    #unless File.read(latest)[0..5] == 'PGDMP'
    filename = if file[0..4] == 'PGDMP'
      backup_path
    else
      puts 'Sorry, something when wrong. The dump was not downloaded'
      #FileUtils.mv backup_path, backup_path.sub(/latest/, 'error')
      backup_path.sub(/latest/, 'error')
    end

    File.open(filename, 'wb') {|f| f.write(file)}
  end

  task :restore do
    config  = Rails.configuration.database_configuration[Rails.env]

    pass_path = Dir.home+'/.pgpass'
    `touch #{pass_path}` unless File.exist?(pass_path)
    unless File.read(pass_path).include?(config['database'])
      File.open(pass_path, 'a') do |f|
        pass_line =  "\n#{config['host'] || 'localhost'}:5432"
        pass_line << ":#{config['database']}:#{config['username']}"
        pass_line << ":#{config['password']}\n"
        f.write(pass_line)
      end 
      `chmod 600 #{pass_path}`
    end

    latest = Dir[Rails.root.join('db').to_s + '/latest-*.dump'].last
    options = ''
    options << '--verbose --clean --no-acl --no-owner '
    options << "-h #{config['host'] || 'localhost'} "
    options << "-U #{config['username']} -d #{config['database']}"
    response = `pg_restore #{options} #{latest}`
  end
end
