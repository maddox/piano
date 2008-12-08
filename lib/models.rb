require 'rubygems'
require 'activerecord'
require 'currency'
require 'currency/active_record'
require 'currency/exchange/rate/deriver'
require 'currency/exchange/rate/source/xe'
require 'currency/exchange/rate/source/timed_cache'

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
  
  validates_uniqueness_of :vendor_identifier
end

class DailyReport < ActiveRecord::Base
  attr_money :royalty_price, :currency_column => 'currency'
  attr_money :customer_price, :currency_column => 'currency'
  attr_money :converted_price, :currency_column => 'converted_currency'
  
  belongs_to :product
  belongs_to :country

  validates_uniqueness_of :date_of, :scope => [:country_id, :product_id ]
  validates_presence_of :converted_currency
  
  # before_create :convert_to_local_currency

  # def convert_to_local_currency
  #   provider = Currency::Exchange::Rate::Source::Xe.new
  #   deriver  = Currency::Exchange::Rate::Deriver.new(:source => provider)
  #   cache = Currency::Exchange::Rate::Source::TimedCache.new(:source => deriver)
  #   Currency::Exchange::Rate::Source.default = cache
  #   puts royalty_price.convert(converted_currency).inspect
  # 
  #   begin
  #   rescue Exception => e
  #     puts e
  #   end
  # end

  def sale_type
    case product_type
    when 1
      "Sale"
    when 7
      "Upgrade"
    end
  end
  
  def subtotal
    converted_price * units
  end

end


