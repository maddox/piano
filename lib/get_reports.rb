require 'rubygems'
require 'mechanize'
require File.join(File.dirname(__FILE__), 'models')

itunes_connect_config = YAML.load(File.read(File.join(File.dirname(__FILE__), '../','config', "config.yml")))['itunes_connect']

agent = WWW::Mechanize.new 
agent.user_agent_alias = 'Mac Safari'
page = agent.get("https://itts.apple.com/cgi-bin/WebObjects/Piano.woa/")
login_form = page.form_with(:name => "appleConnectForm")
login_form.field_with(:name => "theAccountPW").value = itunes_connect_config["password"]
login_form.field_with(:name => "theAccountName").value = itunes_connect_config["login"]
itts = agent.submit(login_form)

report_form = itts.form_with(:name => "frmVendorPage")
report_form.field_with(:name => "9.7").value = "Summary"
report_form.field_with(:name => "9.9").value = "Daily"
report_form.field_with(:name => "hiddenDayOrWeekSelection").value = "11/29/2008"
report_form.field_with(:name => "hiddenSubmitTypeName").value = "Preview"
report_page = agent.submit(report_form)

report_table = (report_page/"table")[4]
rows = (report_table/"tr")
date = Date.parse((report_page/"h4").innerHTML.match(/\d+\/\d+\/\d\d\d\d/).to_s)

puts date.class

(1...rows.size).each do |i|
  row = rows[i] 
  cols = (row/"td")
  
  report = nil
  country = nil
  product = nil
  product = Product.find_or_create_by_vendor_identifier(cols[16].innerHTML)
  product.title = cols[2].innerHTML;
  product.save
  country = Country.find_or_create_by_country_code(cols[10].innerHTML)

  report = DailyReport.create( :product_type => cols[4].innerHTML,
                      :units => cols[5].innerHTML,
                      :royalty_price => cols[6].innerHTML,
                      :customer_price => cols[8].innerHTML,
                      :currency => cols[9].innerHTML,
                      :date_of => date,
                      :product => product,
                      :country => country )

end
