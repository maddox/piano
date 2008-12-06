class CreateBaseDb < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :country_code
    end

    add_index(:countries, :country_code)
    
    create_table :products do |t|
      t.string :title, :vendor_identifier
    end

    add_index(:products, :title)

    create_table :daily_reports do |t|
      t.integer :product_id, :country_id, :product_type, :units
      t.float   :royalty_price, :customer_price
      t.string  :currency
      t.date    :date_of
    end

  end

  def self.down
    drop_table :daily_reports
    drop_table :products
    drop_table :countries
  end
end

