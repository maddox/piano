require 'rubygems'
require 'sinatra'
require 'yaml'
require 'lib/authentication'
require 'lib/models'

include Sinatra::Authentication

config = YAML.load(File.read(File.join(File.dirname(__FILE__),'config', "config.yml")))
AUTH_CREDENTIALS = config['piano']
LOCAL_CURRENCY = config['local_currency']

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
