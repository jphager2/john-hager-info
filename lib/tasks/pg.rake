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

  desc 'list all backups'
  task :list do
    puts Bundler.with_clean_env { `heroku pg:backups` }
  end

  desc 'destroy a backup, e.g. `rake pg:destroy b999`'
  task :destroy, [:id] do |t, args|
    id    = args[:id]
    list  = Bundler.with_clean_env { `heroku pg:backups` }
    match = list.split("\n").drop(2).any? do |line| 
      line.split("\s").first == id
    end
    if match
      puts Bundler.with_clean_env { 
        `heroku pg:backups delete #{id}`
      }
    else
      puts "There is no backup named: #{id}"
    end
  end

  desc 'backup the database'
  task :backup do
    response = Bundler.with_clean_env { 
      `heroku pg:backups capture`
    }
    if response.include?('delete a backup before creating a new one')
      puts response
      exit 1
    end
  end

  desc 'download the latest database backup'
  task :dump do
    backup_path = Rails.root.join('db', "latest-#{Time.now.to_i}.dump")
    backup_url  = Bundler.with_clean_env {
      `heroku pg:backups public-url`
    }
    file        = open(backup_url, PGUtils::HEADERS).read
    filename = if file[0..4] == 'PGDMP'
      backup_path
    else
      puts 'Sorry, something when wrong. The dump was not downloaded'
      backup_path.sub(/latest/, 'error')
    end

    File.open(filename, 'wb') {|f| f.write(file)}
  end

  desc 'replace the database with the latest dump'
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
