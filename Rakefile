require 'bundler'
Bundler.setup
require 'rake/testtask'
require 'dm-migrations'

desc "Run all tests"
Rake::TestTask.new do |t|
  t.libs << "spec"
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

task :default => :test

module Mast
  module Rake
    def sails_init(env)
      require File.join('.', 'environment.rb')
    end
  end
end

namespace :db do
  include Mast::Rake

  desc "DESTRUCTIVE bootstrap of the database (e.g. rake db:bootstrap RACK_ENV=jo_dev)"
  task :bootstrap do
    sails_init ENV['RACK_ENV']
    puts "Bootstrapping database."
    #DataMapper::Schema.create if Sinatra::Base.production? && !DataMapper::Schema.exists?
    DataMapper.auto_migrate!
    DataMapper::Model.descendants.each do |klass|
      klass.bootstrap! if klass.respond_to?('bootstrap!')
    end
  end

  desc "non-destructive migration of the database (e.g. rake db:migrate RACK_ENV=jo_dev)"
  task :migrate do
    sails_init ENV['RACK_ENV']
    DataMapper.auto_upgrade!
  end
end