require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'models')

class ChangeMoneyToCents < ActiveRecord::Migration
  def self.up
    add_column :daily_reports, :royalty_price_in_ints, :integer
    add_column :daily_reports, :customer_price_in_ints, :integer
    
    DailyReport.find(:all).each do |report|
      report.royalty_price_in_ints = (report.royalty_price.to_f*100).to_i
      report.royalty_price_in_ints = (report.customer_price.to_f*100).to_i
      report.save
    end
    
    remove_column :daily_reports, :customer_price
    remove_column :daily_reports, :royalty_price
    
  end

  def self.down
    add_column :daily_reports, :royalty_price, :float
    add_column :daily_reports, :customer_price, :float

    remove_column :daily_reports, :royalty_price_in_ints
    remove_column :daily_reports, :royalty_price_in_ints
  end
end

