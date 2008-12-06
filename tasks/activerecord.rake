require 'rubygems'
require 'activerecord'

task :environment do
  ActiveRecord::Base.establish_connection({
        :adapter => "sqlite3", 
        :dbfile => "db/itunes_reports.sqlite"
  })
  ActiveRecord::Base.logger = Logger.new("ar.log")
end

namespace :db do
  desc "Migrate the database through scripts in db/migrate.."
  task :migrate => :environment do
    ActiveRecord::Migration.verbose = ENV["VERBOSE"] ? ENV["VERBOSE"] == "true" : true
    ActiveRecord::Migrator.migrate("db/migrate/", ENV["VERSION"] ? ENV["VERSION"].to_i : nil)
  end
end
