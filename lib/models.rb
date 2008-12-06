require 'rubygems'
require 'activerecord'

ActiveRecord::Base.establish_connection({
      :adapter => "sqlite3", 
      :dbfile => File.join(File.dirname(__FILE__), '..', 'db', 'itunes_reports.sqlite')
})

# define a simple model 
class Country < ActiveRecord::Base
  has_many :daily_reports

  validates_uniqueness_of :country_code
end

class Product < ActiveRecord::Base
  has_many :daily_reports
  
  validates_uniqueness_of :vendor_identifier
end

class DailyReport < ActiveRecord::Base
  belongs_to :product
  belongs_to :country

  def sale_type
    case product_type
    when 1
      "Sale"
    when 7
      "Upgrade"
    end
  end

  def subtotal
    royalty_price * units
  end

  validates_uniqueness_of :date_of, :scope => [:country_id, :product_id ]
end


