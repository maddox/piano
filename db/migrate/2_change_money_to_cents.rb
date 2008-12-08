require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'models')

class ChangeMoneyToCents < ActiveRecord::Migration
  def self.up
    add_column :daily_reports, :royalty_price_in_ints, :integer
    add_column :daily_reports, :customer_price_in_ints, :integer
    
    DailyReport.find(:all).each do |report|
      report.royalty_price_in_ints = (report.royalty_price*100.to_f).to_i
      report.customer_price_in_ints = (report.customer_price*100.to_f).to_i
      report.save
    end
    
    remove_column :daily_reports, :customer_price
    remove_column :daily_reports, :royalty_price
    
    rename_column :daily_reports, :royalty_price_in_ints, :royalty_price
    rename_column :daily_reports, :customer_price_in_ints, :customer_price
  end

  def self.down
    rename_column :daily_reports, :royalty_price, :royatly_price_in_ints
    rename_column :daily_reports, :customer_price, :customer_price_in_ints
    add_column :daily_reports, :royalty_price, :float
    add_column :daily_reports, :customer_price, :float
    remove_column :daily_reports, :royalty_price_in_ints
    remove_column :daily_reports, :royalty_price_in_ints
  end
end

