require 'rubygems'
require 'sinatra'
require 'yaml'
require 'lib/authentication'
require 'lib/models'

include Sinatra::Authentication

AUTH_CREDENTIALS = YAML.load(File.read(File.join(File.dirname(__FILE__),'config', "config.yml")))['piano']

# layout 'layout'



get '/' do
  login_required 
  
  @products = Product.find(:all)
  erb :index
end





helpers do

  def authorize(username, password)
    username == AUTH_CREDENTIALS['login'] && password == AUTH_CREDENTIALS['password']
  end

end
