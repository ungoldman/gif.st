Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'bundler/setup'
Bundler.require
require File.join(File.expand_path(File.dirname(__FILE__)), 'helpers.rb')
Dir.glob(['lib', 'models'].map! {|d| File.join File.expand_path(File.dirname(__FILE__)), d, '*.rb'}).each {|f| require f}

puts "Starting in #{Sinatra::Base.environment} mode.."

class Controller < Sinatra::Base
  register Sinatra::Synchrony
  register Sinatra::Namespace
  register Sinatra::Flash

  set :method_override, true
  set :public,          'public'
  set :sessions,        true
  set :session_secret,  'theoreticalparticlephysicist'
  set :erubis,          :escape_html => true

  configure :development do
    Bundler.require :development
    DataMapper::Logger.new STDOUT, :debug
    DataMapper.setup :default, YAML.load_file(File.join(root, 'config', 'database.yml'))[environment.to_s]
  end

  configure :test do
    DataMapper.setup :default, YAML.load_file(File.join(root, 'config', 'database.yml'))[environment.to_s]
  end

  configure :production do
    DataMapper.setup :default, ENV['DATABASE_URL']
  end
end

require File.join('.', 'controller.rb')