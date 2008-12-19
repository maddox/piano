require 'rubygems'
require 'activerecord'

ActiveRecord::Base.establish_connection({
      :adapter => "sqlite3", 
      :dbfile => File.join(File.dirname(__FILE__), '..', 'db', 'itunes_reports.sqlite')
})

# define a simple model 
class Country < ActiveRecord::Base
  has_many :daily_reports, :order => :date_of

  validates_uniqueness_of :country_code
end

class Product < ActiveRecord::Base
  has_many :daily_reports, :order => :date_of
  
  def total_units
    self.daily_reports.map { |report| report.units }.sum
  end

  def total_sales
    self.daily_reports.sales.map { |report| report.units }.sum
  end
  
  def total_upgrades
    self.daily_reports.upgrades.map { |report| report.units }.sum
  end
  
  def title
    read_attribute(:title).blank? ? vendor_identifier : read_attribute(:title)
  end
  
  validates_uniqueness_of :vendor_identifier
end

class DailyReport < ActiveRecord::Base
  belongs_to :product
  belongs_to :country

  named_scope :sales, :conditions => {:product_type => 1}, :order => 'date_of DESC'
  named_scope :upgrades, :conditions => {:product_type => 7}, :order => 'date_of DESC'
  named_scope :yesterday, :conditions => {:date_of => (Date.today -1)}, :order => 'date_of DESC'
  named_scope :sales_by_date, lambda { |date| {:conditions => {:date_of => date, :product_type => 1}, :order => 'date_of DESC'} }
  named_scope :upgrades_by_date, lambda { |date| {:conditions => {:date_of => date, :product_type => 7}, :order => 'date_of DESC'} }
  named_scope :by_date, lambda { |date| {:conditions => {:date_of => date}, :order => 'date_of DESC'} }

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


