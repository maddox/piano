require 'rubygems'
require 'sinatra'
require 'gchart'
require 'yaml'
require 'lib/authentication'
require 'lib/models'

include Sinatra::Authentication

AUTH_CREDENTIALS = YAML.load(File.read(File.join(File.dirname(__FILE__),'config', "config.yml")))['piano']

layout 'layout'

before do
  login_required 
end


get '/' do
  @products = Product.find(:all)
  erb :index
end

get '/apps/:id/report' do
  @the_date = build_date  
  @product = Product.find(params[:id])
  erb :report_show
end

get '/apps/:id' do
  @the_date = build_date  
  
  @product = Product.find(params[:id])

  reports = @product.daily_reports.sales(:conditions => [ "BETWEEN ? AND ?", @the_date - 30, @the_date] ).group_by(&:date_of)
  totals = reports.collect{|report| report[1].inject(0){|sum, report| sum += report.units }}
  dates = reports.collect{|report| report[0].strftime("%d")}

  low_value = totals.sort{|x,y|x<=>y}.first
  high_value = totals.sort{|x,y|x<=>y}.last
  delta = high_value - low_value
  
  step = delta.to_f / 10.to_f
  puts step
  y_values = [0]
  (1..10).each do |i|
    y_values << (i*step).round
  end
  
  y_values << high_value

  @sales_bar_graph = Gchart.line(:size => '700x400', 
              :title => "Last 30 Days Sales",
              :bg => 'efefef',
              :axis_with_labels => 'x,y',
              :axis_labels => [dates, y_values],
              :data => totals)

  
  erb :app_show
end





helpers do

  def authorize(username, password)
    username == AUTH_CREDENTIALS['login'] && password == AUTH_CREDENTIALS['password']
  end
  
  def build_date
    begin
      Date.parse("#{params[:year]}/#{params[:month]}/#{params[:day]}")    
    rescue
      Date.today - 1
    end
  end
  
  def link_to(title, path)
    %{<a href="#{path}">#{title}</a>}
  end
  
  def next_date(id, date)
    date += 1
    link_to('Next >', "/apps/#{id}/report?year=#{date.year}&month=#{date.month}&day=#{date.day}")
  end

  def previous_date(id, date)
    date -= 1
    link_to('< Previous', "/apps/#{id}/report?year=#{date.year}&month=#{date.month}&day=#{date.day}")
  end

end
