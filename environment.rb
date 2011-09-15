Encoding.default_internal = 'UTF-8'
require 'rubygems'
require 'bundler/setup'
Bundler.require
require File.join(File.expand_path(File.dirname(__FILE__)), 'helpers.rb')
Dir.glob(['lib', 'models'].map! {|d| File.join File.expand_path(File.dirname(__FILE__)), d, '*.rb'}).each {|f| require f}
require 'aws/s3'

puts "Starting in #{Sinatra::Base.environment} mode.."

class Controller < Sinatra::Base
  register Sinatra::Synchrony
  register Sinatra::Namespace
  register Sinatra::Flash
  
  def self.development?; (environment.to_s =~ /dev/ ? true : false); end
  def self.configure(*envs, &block)
    yield self if envs.empty? || envs.include?(environment.to_sym) || (environment.to_s =~ /dev/ && envs.first.eql?(:development))
  end

  set :method_override, true
  set :public,          'public'
  set :sessions,        true
  set :session_secret,  ENV['APP_SESSION_SECRET']
  set :erubis,          :escape_html => true
  
  set :consumer_key,    ENV['consumer_key']
  set :consumer_secret, ENV['consumer_secret']
  set :s3_key,          ENV['S3_KEY']
  set :s3_secret,       ENV['S3_SECRET']
  set :bucket,          ENV['S3_GIF_BUCKET']

  configure :development do
    use Rack::CommonLogger
    Bundler.require :development
    DataMapper::Logger.new STDOUT, :debug
    DataMapper.setup :default, "sqlite3:///#{File.expand_path(File.dirname(__FILE__))}/#{Sinatra::Base.environment}.db"
  end

  configure :test do
  end

  configure :production do
    DataMapper.setup :default, ENV['DATABASE_URL']
  end
end

require File.join('.', 'controller.rb')