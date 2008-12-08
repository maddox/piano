require File.join(File.dirname(__FILE__), '..', '..', 'lib', 'models')

class AddConvertedRate < ActiveRecord::Migration
  def self.up
    add_column :daily_reports, :converted_price, :integer
    add_column :daily_reports, :converted_currency, :string
  end

  def self.down
    remove_column :daily_reports, :converted_currency
    remove_column :daily_reports, :converted_price
  end
end

